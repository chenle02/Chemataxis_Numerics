#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
RECEIPT_PATH = HERE / "lean-receipt.json"

TRACKED_FILES = [
    "Paper3QuadraticABC.lean",
    "Paper3Regime.lean",
    "Paper3TrigOrtho.lean",
    "Paper3Model.lean",
    "Paper3MinimalABC.lean",
    "Paper3Semidiscrete.lean",
    "Paper3Eigenmodes.lean",
    "Paper3CenterJet.lean",
    "Paper3CubicProjection.lean",
    "Paper3QuadraticProjection.lean",
    "Paper3ReducedAssembly.lean",
    "Paper3TrigFinite.lean",
    "Paper3TrigInfinite.lean",
    "Paper3Thresholds.lean",
    "Paper3DiscreteOrdering.lean",
    "Paper3Taylor.lean",
    "Paper3NormalForm.lean",
    "Paper3ModalEquation.lean",
    "Paper3ModalODE.lean",
    "Paper3LinearRegime.lean",
    "Paper3ConservativeMass.lean",
    "AxiomCheck.lean",
    "lakefile.toml",
    "lean-toolchain",
    "lake-manifest.json",
    "make_receipt.py",
]

EXPECTED_AXIOMS = ["Classical.choice", "Quot.sound", "propext"]

AXIOM_LINE = re.compile(r"^'([^']+)' depends on axioms: \[([^\]]*)\]\s*$")
NO_AXIOM_LINE = re.compile(r"^'([^']+)' does not depend on any axioms\s*$")
PRINT_AXIOMS_DIRECTIVE = re.compile(r"^#print\s+axioms\s+(\S+)\s*$")


def sha256_of(path: Path) -> str:
    digest = hashlib.sha256()
    digest.update(path.read_bytes())
    return digest.hexdigest()


def collect_file_hashes() -> dict[str, str]:
    hashes = {}
    for name in TRACKED_FILES:
        target = HERE / name
        if not target.is_file():
            raise SystemExit(f"missing tracked file: {name}")
        hashes[name] = sha256_of(target)
    return hashes


def declared_theorems() -> list[str]:
    names = []
    for line in (HERE / "AxiomCheck.lean").read_text().splitlines():
        found = PRINT_AXIOMS_DIRECTIVE.match(line.strip())
        if found:
            names.append(found.group(1))
    return names


def parse_axiom_report(text: str) -> dict[str, list[str]]:
    report = {}
    logical_lines = []
    pending = ""
    for line in text.splitlines():
        stripped = line.strip()
        if pending:
            pending = f"{pending} {stripped}"
            if "]" in stripped:
                logical_lines.append(pending)
                pending = ""
        elif stripped.startswith("'") and "depends on axioms: [" in stripped and "]" not in stripped:
            pending = stripped
        else:
            logical_lines.append(stripped)
    if pending:
        logical_lines.append(pending)

    for line in logical_lines:
        stripped = line.strip()
        with_axioms = AXIOM_LINE.match(stripped)
        if with_axioms:
            axioms = [a.strip() for a in with_axioms.group(2).split(",") if a.strip()]
            report[with_axioms.group(1)] = sorted(axioms)
            continue
        without = NO_AXIOM_LINE.match(stripped)
        if without:
            report[without.group(1)] = []
    return report


def pinned_dependencies() -> dict[str, dict[str, str]]:
    manifest = json.loads((HERE / "lake-manifest.json").read_text())
    return {
        package["name"]: {
            "rev": package.get("rev", ""),
            "inputRev": package.get("inputRev", ""),
        }
        for package in manifest.get("packages", [])
    }


def toolchain() -> str:
    return (HERE / "lean-toolchain").read_text().strip()


def audit_axiom_text(axiom_text: str) -> tuple[dict[str, list[str]], list[str]]:
    report = parse_axiom_report(axiom_text)
    expected = declared_theorems()
    failures = []

    duplicates = sorted({name for name in expected if expected.count(name) > 1})
    if duplicates:
        failures.append(f"duplicate #print axioms directives: {', '.join(duplicates)}")

    missing = [name for name in expected if name not in report]
    if missing:
        failures.append(f"axiom output missing theorems: {', '.join(missing)}")

    unexpected = sorted(set(report) - set(expected))
    if unexpected:
        failures.append(f"axiom output contains undeclared theorems: {', '.join(unexpected)}")

    for name in expected:
        if name in report and report[name] != EXPECTED_AXIOMS:
            failures.append(f"{name} has non-sanctioned axioms: {report[name]}")

    return report, failures


def audit(args: argparse.Namespace) -> int:
    report, failures = audit_axiom_text(Path(args.axiom_output).read_text())
    if failures:
        for failure in failures:
            print(f"TRUST GATE FAILED  {failure}", file=sys.stderr)
        return 1

    print(
        f"OK  live axiom audit: {len(report)} theorems; "
        f"sanctioned axioms {EXPECTED_AXIOMS}"
    )
    return 0


def generate(args: argparse.Namespace) -> int:
    axiom_text = Path(args.axiom_output).read_text()
    report, failures = audit_axiom_text(axiom_text)
    expected = declared_theorems()

    structural_failures = [
        failure for failure in failures if "non-sanctioned axioms" not in failure
    ]
    if structural_failures:
        raise SystemExit("; ".join(structural_failures))
    if failures and not args.allow_unsound:
        for failure in failures:
            print(f"TRUST GATE FAILED  {failure}", file=sys.stderr)
        raise SystemExit("refusing to write a receipt for theorems outside the sanctioned axiom set")

    receipt = {
        "schema": "paper3-lean-receipt/1",
        "paper": "Paper III (bifurcation)",
        "evidence_tier": "T3",
        "generated_on_host": args.host,
        "generated_on_date": args.date,
        "toolchain": toolchain(),
        "expected_axioms": EXPECTED_AXIOMS,
        "theorems": {name: report[name] for name in expected},
        "theorem_count": len(expected),
        "dependencies": pinned_dependencies(),
        "files": collect_file_hashes(),
        "self_containment_verified": args.self_contained,
    }
    RECEIPT_PATH.write_text(json.dumps(receipt, indent=2, sort_keys=True) + "\n")
    print(f"wrote {RECEIPT_PATH.name}: {len(expected)} theorems, {len(receipt['files'])} files")
    return 0


def verify(_: argparse.Namespace) -> int:
    if not RECEIPT_PATH.is_file():
        raise SystemExit("no lean-receipt.json present")
    receipt = json.loads(RECEIPT_PATH.read_text())

    failures = []

    current = collect_file_hashes()
    for name, recorded in sorted(receipt.get("files", {}).items()):
        actual = current.get(name)
        if actual != recorded:
            failures.append(f"hash mismatch: {name}")

    for name in TRACKED_FILES:
        if name not in receipt.get("files", {}):
            failures.append(f"file not covered by receipt: {name}")

    if receipt.get("toolchain") != toolchain():
        failures.append("toolchain pin changed")

    if receipt.get("dependencies") != pinned_dependencies():
        failures.append("lake-manifest dependency revisions changed")

    recorded_theorems = receipt.get("theorems", {})
    if sorted(recorded_theorems) != sorted(declared_theorems()):
        failures.append("AxiomCheck.lean theorem set differs from the receipt")

    for name, axioms in sorted(recorded_theorems.items()):
        if axioms != EXPECTED_AXIOMS:
            failures.append(f"receipt records non-sanctioned axioms for {name}: {axioms}")

    if failures:
        for line in failures:
            print(f"FAIL  {line}", file=sys.stderr)
        print(
            "receipt is stale: rebuild on the pinned toolchain and regenerate",
            file=sys.stderr,
        )
        return 1

    print(
        f"OK  {len(recorded_theorems)} theorems, {len(current)} files, "
        f"toolchain {receipt['toolchain']}"
    )
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(
        description=(
            "Generate or verify the Paper III Lean evidence receipt. "
            "The receipt binds source hashes, the pinned toolchain and mathlib "
            "revisions, and the axiom-gate result for every theorem."
        )
    )
    sub = parser.add_subparsers(dest="command", required=True)

    gen = sub.add_parser("generate", help="write lean-receipt.json from an axiom-gate transcript")
    gen.add_argument(
        "--axiom-output",
        required=True,
        help="file containing the output of `lake env lean AxiomCheck.lean`",
    )
    gen.add_argument("--host", required=True, help="host the build was performed on")
    gen.add_argument("--date", required=True, help="ISO date of the build")
    gen.add_argument(
        "--self-contained",
        action="store_true",
        help="record that a fresh-directory rebuild from these files alone succeeded",
    )
    gen.add_argument(
        "--allow-unsound",
        action="store_true",
        help="write the receipt even if a theorem depends on axioms outside the sanctioned set",
    )
    gen.set_defaults(func=generate)

    ver = sub.add_parser("verify", help="re-check tracked sources against the committed receipt")
    ver.set_defaults(func=verify)

    aud = sub.add_parser("audit", help="validate a live `#print axioms` transcript")
    aud.add_argument(
        "--axiom-output",
        required=True,
        help="file containing the output of `lake env lean AxiomCheck.lean`",
    )
    aud.set_defaults(func=audit)

    args = parser.parse_args()
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())

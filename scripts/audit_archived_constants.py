#!/usr/bin/env python3
"""Recompute archived bifurcation constants and compare them with this repo.

Why this exists: the cubic coefficient beta_n0 was corrected to include the
center-graph (slaved-mode) contribution in Chemotaxis_simulation@8942193. That
correction propagated forward into the papers and into newly generated bundles,
but pre-existing case archives were never re-derived. Nothing compared archived
values against the code that produces them, so 28 archives silently kept a
pre-correction beta_n0 until 2026-08. This check closes that gap.

chi_star is the validity control: it does not depend on the correction, so it
must reproduce exactly. If chi_star drifts, the parameter mapping is wrong and
every beta_n0 comparison below is void rather than merely failing.

The simulator is located via --simulator, else $CHEMOTAXIS_SIMULATION, else a
sibling checkout. CI pins it to the revision recorded in the manifest so that
bumping the simulator without re-deriving the archives fails loudly.
"""
from __future__ import annotations

import argparse
import json
import os
import pathlib
import sys

import yaml

ROOT = pathlib.Path(__file__).resolve().parents[1]
RESULTS = ROOT / "docs" / "results"
MANIFEST = ROOT / "docs" / "data" / "paper-iii-manifest.json"
CHI_TOL = 1e-9


def locate_simulator(explicit: str | None) -> pathlib.Path:
    for candidate in (explicit, os.environ.get("CHEMOTAXIS_SIMULATION"),
                      str(ROOT.parent / "Chemotaxis_simulation")):
        if candidate and (pathlib.Path(candidate) / "implied_constants.py").exists():
            return pathlib.Path(candidate).resolve()
    raise SystemExit(
        "cannot locate Chemotaxis_simulation; pass --simulator or set "
        "CHEMOTAXIS_SIMULATION")


def exempt() -> set[str]:
    manifest = json.loads(MANIFEST.read_text())
    keep = {e["raw_path"] for e in manifest.get("provenance_only", [])}
    for case in manifest.get("time_integration_cases", []):
        if case.get("archive_assertions"):
            keep.add(case["raw_path"])
    return keep


def archived(case: pathlib.Path) -> dict:
    const = json.loads((case / "constants.json").read_text())
    nested = const.get("bifurcation") if isinstance(const.get("bifurcation"), dict) else {}
    nested = nested or {}
    return {
        "beta_n0": const.get("beta_n0", nested.get("beta_n0")),
        "chi_star": const.get("chi_star", nested.get("chi_star_mode_n0")),
        "classification": const.get("classification", nested.get("classification")),
        "n0": const.get("n0", nested.get("n0")),
    }


def parameters(case: pathlib.Path, n0: int | None) -> dict:
    cfg = yaml.safe_load((case / "config.yaml").read_text())
    grid = cfg.get("grid", {})
    model = dict(cfg.get("model", {}))
    params = {
        **model,
        "L": grid.get("L"),
        "n0": int(n0 if n0 is not None else int(grid.get("eigen_index", 2)) - 1),
        "equilibrium_mode": (cfg.get("equilibrium_mode")
                             or model.get("equilibrium_mode") or "logistic"),
    }
    params.setdefault("c", 1.0)
    return params


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true", help="exit 1 on disagreement")
    ap.add_argument("--simulator", default=None)
    args = ap.parse_args()

    simulator = locate_simulator(args.simulator)
    sys.path.insert(0, str(simulator))
    from implied_constants import compute_bifurcation_coefficients

    skip = exempt()
    flips, drift, chi_bad = [], [], []
    examined = 0

    for cfg_path in sorted(RESULTS.rglob("config.yaml")):
        case = cfg_path.parent
        if not (case / "constants.json").exists():
            continue
        rel = str(case.relative_to(ROOT))
        arch = archived(case)
        if arch["chi_star"] is None or arch["beta_n0"] is None:
            continue
        examined += 1
        fresh = compute_bifurcation_coefficients(parameters(case, arch["n0"]))
        chi_new = fresh.get("chi_star") or fresh.get("chi_star_mode_n0")
        beta_new = fresh["beta_n0"]
        chi_dev = abs(chi_new - arch["chi_star"]) / max(abs(arch["chi_star"]), 1e-30)

        if chi_dev > CHI_TOL:
            chi_bad.append((rel, chi_dev))
        elif rel in skip:
            continue
        elif (beta_new > 0) != (arch["beta_n0"] > 0):
            flips.append((rel, arch["beta_n0"], beta_new, arch["classification"]))
        elif abs(beta_new - arch["beta_n0"]) > 1e-9:
            drift.append((rel, arch["beta_n0"], beta_new))

    print(f"simulator           : {simulator}")
    print(f"cases examined      : {examined}")
    print(f"exempt (pinned/prov): {len(skip)}")
    print(f"chi_star control    : {'PASS' if not chi_bad else 'FAIL'} "
          f"({len(chi_bad)} drifted, tol {CHI_TOL:g})")
    print(f"sign flips          : {len(flips)}")
    print(f"magnitude drift     : {len(drift)}")

    if chi_bad:
        print("\nchi_star drift: parameter mapping is wrong, beta results are void")
        for rel, dev in chi_bad:
            print(f"  {rel}  reldev={dev:.2e}")
    for rel, old, new, cls in flips:
        print(f"\nSIGN FLIP {rel}\n  archived {old:+.6f} ({cls}) -> current {new:+.6f}")
    for rel, old, new in drift:
        print(f"\ndrift {rel}\n  archived {old:+.6f} -> current {new:+.6f}")

    failed = bool(chi_bad or flips or drift)
    if failed:
        print("\nArchived constants disagree with the current simulator.")
        print("Regenerate them (see codes/regenerate_archived_constants.py in the "
              "manuscript repository) rather than editing constants.json by hand.")
    if args.check and failed:
        return 1
    print("\nOK" if not failed else "\n(reporting only; --check gates)")
    return 0


if __name__ == "__main__":
    sys.exit(main())

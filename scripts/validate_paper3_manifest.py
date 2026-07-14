#!/usr/bin/env python3
"""Validate the Paper III evidence contract against committed Git objects."""

from __future__ import annotations

import hashlib
import json
import math
import re
import subprocess
import sys
from pathlib import Path, PurePosixPath
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
MANIFEST_PATH = ROOT / "docs" / "data" / "paper-iii-manifest.json"
RESULTS_PATH = ROOT / "docs" / "results" / "index.md"

EXPECTED_RELEASE = {
    "version": "1.0.0",
    "data_revision": "e62ffa1e99122f8fbbeb3df7586f4050c4ff5c58",
    "manuscript_science_revision": "fde25e17187bc3f247b36ce411f6f14eb93d52cf",
    "figure_source_revision": "c0bfc431a19b81b1c45363dea472c29a745ad055",
    "simulator_revision": "7c2a09b24fdebb9000b9b996eb34150d6de5ed17",
}
EXPECTED_BUNDLE_FILES = {
    "branch-points.csv",
    "fit-summary.json",
    "states-index.json",
    "stationary-continuation.pdf",
    "stationary-continuation.png",
    "stationary-profiles.csv",
    "stationary-states.npz",
}
EXPECTED_STATIONARY_CASES = {
    "nonminimal-a10-beta0": {
        "classification": "supercritical",
        "theory_c2": 0.00842544631852886,
        "fits": [
            (40, 0.008370760765781244, None),
            (80, 0.008411801148577492, 2.0027693774459787),
            (160, 0.008422057235434008, 2.009423448648791),
        ],
    },
    "nonminimal-beta3": {
        "classification": "subcritical",
        "theory_c2": -19.666710315587455,
        "fits": [
            (40, -19.318560593702777, None),
            (80, -19.579579296748616, 1.9984495528615873),
            (160, -19.64492609095355, 1.9999026486399063),
        ],
    },
    "minimal-m1-g1": {
        "classification": "supercritical",
        "theory_c2": 1.9229899169785474,
        "fits": [
            (40, 1.9130168027041174, None),
            (80, 1.9204956382538594, 1.9994213920153865),
            (160, 1.92236644735955, 2.0002315231020047),
        ],
    },
    "minimal-m2-g2": {
        "classification": "subcritical",
        "theory_c2": -1.1485873311641532,
        "fits": [
            (40, -1.1795328096525204, None),
            (80, -1.1563262402309178, 1.9995265165374327),
            (160, -1.1505222060103328, 1.9998899565433161),
        ],
    },
}
EXPECTED_TIME_CASES = {
    "time-nonminimal-a10-beta0",
    "time-nonminimal-m2-beta1-gamma2",
}
EXPECTED_PROVENANCE_CASES = {
    "legacy-minimal-m1-g1-time-run",
    "legacy-minimal-m2-g2-time-run",
    "legacy-nonminimal-beta3-misseeded",
    "legacy-nonminimal-beta1-misseeded",
}


class ValidationError(RuntimeError):
    """Raised when the public evidence contract is inconsistent."""


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValidationError(message)


def git_bytes(path: str) -> bytes:
    details = []
    for object_name in (f":{path}", f"HEAD:{path}"):
        process = subprocess.run(
            ["git", "show", object_name],
            cwd=ROOT,
            check=False,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
        if process.returncode == 0:
            return process.stdout
        details.append(process.stderr.decode("utf-8", errors="replace").strip())
    raise ValidationError(
        f"missing Git index/HEAD object for {path}: {'; '.join(details)}"
    )


def git_json(path: str) -> dict[str, Any]:
    try:
        value = json.loads(git_bytes(path))
    except json.JSONDecodeError as exc:
        raise ValidationError(f"invalid JSON in Git object {path}: {exc}") from exc
    require(isinstance(value, dict), f"{path} must contain a JSON object")
    return value


def safe_path(path: Any, context: str, prefix: str) -> str:
    require(isinstance(path, str) and path, f"{context} must be a nonempty string")
    pure_path = PurePosixPath(path)
    require(not pure_path.is_absolute(), f"{context} must be repository-relative")
    require(".." not in pure_path.parts, f"{context} must not traverse upward")
    require(path.startswith(prefix), f"{context} must be under {prefix}")
    return path


def validate_archive_file(path: Any, context: str) -> str:
    value = safe_path(path, context, "docs/results/")
    git_bytes(value)
    return value


def sha256_git_object(path: str) -> str:
    return hashlib.sha256(git_bytes(path)).hexdigest()


def validate_public_asset(path: Any, expected_hash: Any, context: str) -> str:
    value = safe_path(path, f"{context}.path", "docs/assets/images/")
    require(
        PurePosixPath(value).suffix in {".png", ".pdf"},
        f"{context}.path must be a PNG or PDF",
    )
    require(
        isinstance(expected_hash, str)
        and re.fullmatch(r"[0-9a-f]{64}", expected_hash) is not None,
        f"{context}.sha256 must be a lowercase SHA-256 digest",
    )
    require(
        sha256_git_object(value) == expected_hash,
        f"{context} hash does not match {value}",
    )
    return value


def assert_close(actual: Any, expected: Any, context: str) -> None:
    require(isinstance(actual, (int, float)), f"{context} actual value is not numeric")
    require(isinstance(expected, (int, float)), f"{context} expected value is not numeric")
    require(
        math.isclose(float(actual), float(expected), rel_tol=1.0e-11, abs_tol=1.0e-12),
        f"{context} mismatch: actual={actual!r}, expected={expected!r}",
    )


def coefficient_record(constants: dict[str, Any]) -> dict[str, Any]:
    bifurcation = constants.get("bifurcation")
    return bifurcation if isinstance(bifurcation, dict) else constants


def validate_figure(
    owner: dict[str, Any],
    context: str,
    expected_source_revision: str,
) -> tuple[str, str]:
    figure_id = owner.get("paper_figure_id")
    figure = owner.get("paper_figure")
    require(isinstance(figure_id, str) and figure_id, f"{context} needs a figure ID")
    require(isinstance(figure, dict), f"{context}.paper_figure must be an object")
    require(
        figure.get("source_manuscript_commit") == expected_source_revision,
        f"{context}.paper_figure has the wrong manuscript revision",
    )
    preview = validate_public_asset(
        figure.get("preview_path"),
        figure.get("preview_sha256"),
        f"{context}.paper_figure.preview",
    )
    vector = validate_public_asset(
        figure.get("vector_path"),
        figure.get("vector_sha256"),
        f"{context}.paper_figure.vector",
    )
    require(
        PurePosixPath(preview).stem == figure_id
        and PurePosixPath(vector).stem == figure_id,
        f"{context}.paper_figure assets do not match the figure ID",
    )
    return preview, vector


def parse_checksums(path: str) -> dict[str, str]:
    records: dict[str, str] = {}
    text = git_bytes(path).decode("utf-8")
    for line_number, line in enumerate(text.splitlines(), start=1):
        match = re.fullmatch(r"([0-9a-f]{64})  ([A-Za-z0-9][A-Za-z0-9._-]*)", line)
        require(match is not None, f"{path}:{line_number} is not a checksum record")
        digest, filename = match.groups()
        require(filename not in records, f"duplicate checksum for {filename}")
        records[filename] = digest
    return records


def gate_values(gates: list[Any], marker: str) -> list[float]:
    values = [
        float(gate["value"])
        for gate in gates
        if isinstance(gate, dict)
        and marker in str(gate.get("name"))
        and isinstance(gate.get("value"), (int, float))
    ]
    require(values, f"no acceptance gates match {marker!r}")
    return values


def validate_stationary_cases(
    declared_cases: Any,
    summary_cases: Any,
) -> None:
    require(isinstance(declared_cases, list), "stationary cases must be an array")
    require(isinstance(summary_cases, list), "fit-summary cases must be an array")
    declared = {
        case.get("id"): case for case in declared_cases if isinstance(case, dict)
    }
    summarized = {
        case.get("parameters", {}).get("name"): case
        for case in summary_cases
        if isinstance(case, dict) and isinstance(case.get("parameters"), dict)
    }
    require(
        set(declared) == set(EXPECTED_STATIONARY_CASES),
        "stationary manifest case IDs changed",
    )
    require(
        set(summarized) == set(EXPECTED_STATIONARY_CASES),
        "fit-summary case IDs changed",
    )

    for case_id, expected in EXPECTED_STATIONARY_CASES.items():
        context = f"stationary case {case_id}"
        manifest_case = declared[case_id]
        summary_case = summarized[case_id]
        coefficients = summary_case.get("bifurcation_coefficients")
        require(isinstance(coefficients, dict), f"{context} has no coefficients")
        alpha = coefficients.get("alpha_n0")
        beta = coefficients.get("beta_n0")
        assert_close(manifest_case.get("alpha_n0"), alpha, f"{context}.alpha_n0")
        assert_close(manifest_case.get("beta_n0"), beta, f"{context}.beta_n0")
        require(float(alpha) != 0.0, f"{context}.alpha_n0 is zero")
        theory_c2 = float(beta) / float(alpha)
        assert_close(manifest_case.get("theory_c2"), theory_c2, f"{context}.theory_c2")
        assert_close(theory_c2, expected["theory_c2"], f"{context}.frozen theory_c2")
        require(
            manifest_case.get("classification") == expected["classification"],
            f"{context} classification changed",
        )
        require(
            (theory_c2 > 0) == (expected["classification"] == "supercritical"),
            f"{context} classification disagrees with the branch slope",
        )

        manifest_fits = manifest_case.get("fits")
        summary_fits = summary_case.get("fits")
        require(isinstance(manifest_fits, list), f"{context}.fits must be an array")
        require(isinstance(summary_fits, list), f"{context} summary fits must be an array")
        require(
            len(manifest_fits) == len(summary_fits) == 3,
            f"{context} must have three mesh fits",
        )
        for index, (mesh, c2, order) in enumerate(expected["fits"]):
            manifest_fit = manifest_fits[index]
            summary_fit = summary_fits[index]
            require(
                isinstance(manifest_fit, dict) and isinstance(summary_fit, dict),
                f"{context}.fits[{index}] must be objects",
            )
            require(
                manifest_fit.get("mesh") == summary_fit.get("mesh") == mesh,
                f"{context}.fits[{index}] mesh changed",
            )
            assert_close(manifest_fit.get("c2"), summary_fit.get("c2"), f"{context}.c2")
            assert_close(summary_fit.get("c2"), c2, f"{context}.frozen c2")
            manifest_order = manifest_fit.get("observed_order")
            summary_order = summary_fit.get("observed_order")
            if order is None:
                require(
                    manifest_order is None and summary_order is None,
                    f"{context} coarse fit must not claim an observed order",
                )
            else:
                assert_close(manifest_order, summary_order, f"{context}.observed_order")
                assert_close(summary_order, order, f"{context}.frozen observed_order")


def validate_stationary(entry: Any) -> None:
    context = "stationary_validation"
    require(isinstance(entry, dict), f"{context} must be an object")
    require(entry.get("status") == "validated_current", f"{context} is not current")
    require(entry.get("quantitative_use") is True, f"{context} must allow use")
    bundle = safe_path(entry.get("bundle_path"), f"{context}.bundle_path", "docs/results/")
    checksums_path = validate_archive_file(
        entry.get("checksums_path"), f"{context}.checksums_path"
    )
    require(
        checksums_path == f"{bundle}/SHA256SUMS",
        f"{context}.checksums_path is outside its bundle",
    )
    checksums = parse_checksums(checksums_path)
    require(
        set(checksums) == EXPECTED_BUNDLE_FILES,
        f"{context} checksum inventory changed",
    )
    for filename, expected_hash in checksums.items():
        path = f"{bundle}/{filename}"
        validate_archive_file(path, f"{context}.{filename}")
        require(
            sha256_git_object(path) == expected_hash,
            f"{context} checksum failed for {filename}",
        )

    summary = git_json(f"{bundle}/fit-summary.json")
    require(summary.get("schema_version") == 2, "fit-summary schema changed")
    require(summary.get("point_count") == 96, "fit-summary point count changed")
    design = entry.get("design")
    require(isinstance(design, dict), f"{context}.design must be an object")
    require(design.get("state_count") == summary.get("point_count") == 96, "state count changed")
    require(design.get("meshes") == summary.get("meshes") == [40, 80, 160], "mesh set changed")
    require(
        design.get("amplitudes") == summary.get("amplitudes")
        == [-0.02, -0.01, -0.005, -0.0025, 0.0025, 0.005, 0.01, 0.02],
        "amplitude set changed",
    )
    provenance = summary.get("provenance")
    require(isinstance(provenance, dict), "fit-summary provenance is missing")
    for producer in ("generator", "simulator"):
        record = provenance.get(producer)
        require(isinstance(record, dict), f"fit-summary {producer} provenance is missing")
        require(record.get("dirty") is False, f"fit-summary {producer} tree was dirty")
        require(
            record.get("revision") == EXPECTED_RELEASE["simulator_revision"],
            f"fit-summary {producer} revision changed",
        )

    acceptance = entry.get("acceptance")
    summary_acceptance = summary.get("acceptance")
    require(isinstance(acceptance, dict), f"{context}.acceptance must be an object")
    require(isinstance(summary_acceptance, dict), "fit-summary acceptance is missing")
    gates = summary_acceptance.get("gates")
    require(isinstance(gates, list), "fit-summary gates must be an array")
    passed = sum(
        1 for gate in gates if isinstance(gate, dict) and gate.get("passed") is True
    )
    require(summary_acceptance.get("passed") is True, "fit-summary acceptance is false")
    require(len(gates) == passed == 780, "stationary acceptance is not 780/780")
    require(acceptance.get("passed") is True, "manifest stationary acceptance is false")
    require(
        acceptance.get("gates_passed") == acceptance.get("gates_total") == 780,
        "manifest gate count is not 780/780",
    )
    metrics = {
        "max_full_stationary_residual": max(gate_values(gates, "/full-residual")),
        "max_elliptic_residual": max(gate_values(gates, "/elliptic-residual")),
        "max_mass_error": max(gate_values(gates, "/mass")),
        "observed_order_min": min(gate_values(gates, "/c2-observed-order")),
        "observed_order_max": max(gate_values(gates, "/c2-observed-order")),
    }
    for name, value in metrics.items():
        assert_close(acceptance.get(name), value, f"{context}.acceptance.{name}")

    preview, vector = validate_figure(
        entry,
        context,
        EXPECTED_RELEASE["manuscript_science_revision"],
    )
    require(
        sha256_git_object(preview) == checksums["stationary-continuation.png"],
        "stationary preview differs from immutable bundle",
    )
    require(
        sha256_git_object(vector) == checksums["stationary-continuation.pdf"],
        "stationary vector figure differs from immutable bundle",
    )
    validate_stationary_cases(entry.get("cases"), summary.get("cases"))


def validate_archive_assertions(entry: dict[str, Any], context: str) -> None:
    constants_path = validate_archive_file(entry.get("constants_path"), f"{context}.constants_path")
    constants = coefficient_record(git_json(constants_path))
    assertions = entry.get("archive_assertions")
    require(isinstance(assertions, dict), f"{context}.archive_assertions must be an object")
    require(
        constants.get("classification") == assertions.get("classification"),
        f"{context} archived classification changed",
    )
    for key in ("chi_star_mode_n0", "beta_n0"):
        assert_close(constants.get(key), assertions.get(key), f"{context}.{key}")


def validate_run_paths(runs: Any, raw_path: str, context: str) -> None:
    require(isinstance(runs, list) and runs, f"{context} must be a nonempty array")
    for index, run in enumerate(runs):
        run_context = f"{context}[{index}]"
        require(isinstance(run, dict), f"{run_context} must be an object")
        for field in ("run_path", "metadata_path", "legacy_preview_path"):
            path = validate_archive_file(run.get(field), f"{run_context}.{field}")
            require(path.startswith(raw_path + "/"), f"{run_context}.{field} escapes its family")


def validate_time_cases(cases: Any) -> list[dict[str, Any]]:
    require(isinstance(cases, list), "time_integration_cases must be an array")
    require(
        {case.get("id") for case in cases if isinstance(case, dict)} == EXPECTED_TIME_CASES,
        "time-integration case IDs changed",
    )
    for index, case in enumerate(cases):
        context = f"time_integration_cases[{index}]"
        require(isinstance(case, dict), f"{context} must be an object")
        require(case.get("status") == "validated_current", f"{context} is not current")
        require(case.get("quantitative_use") is True, f"{context} must allow use")
        raw_path = safe_path(case.get("raw_path"), f"{context}.raw_path", "docs/results/")
        validate_archive_assertions(case, context)
        validate_figure(case, context, EXPECTED_RELEASE["figure_source_revision"])
        require(
            isinstance(case.get("legacy_preview_policy"), str)
            and case.get("legacy_preview_policy"),
            f"{context} needs a legacy preview policy",
        )
        validate_run_paths(case.get("featured_runs"), raw_path, f"{context}.featured_runs")
    return cases


def validate_provenance(entries: Any, results_page: str) -> list[dict[str, Any]]:
    require(isinstance(entries, list), "provenance_only must be an array")
    require(
        {entry.get("id") for entry in entries if isinstance(entry, dict)}
        == EXPECTED_PROVENANCE_CASES,
        "provenance-only case IDs changed",
    )
    for index, entry in enumerate(entries):
        context = f"provenance_only[{index}]"
        require(isinstance(entry, dict), f"{context} must be an object")
        require(entry.get("status") == "provenance_only", f"{context} has the wrong status")
        require(entry.get("quantitative_use") is False, f"{context} permits quantitative use")
        require(entry.get("reader_facing") is False, f"{context} is reader-facing")
        require(isinstance(entry.get("reason"), str) and entry.get("reason"), f"{context} needs a reason")
        raw_path = safe_path(entry.get("raw_path"), f"{context}.raw_path", "docs/results/")
        constants_path = validate_archive_file(entry.get("constants_path"), f"{context}.constants_path")
        require(constants_path.startswith(raw_path + "/"), f"{context} constants escape their family")
        require(raw_path not in results_page, f"{context} raw archive appears on curated Results page")
    return entries


def validate_results_page(
    stationary: dict[str, Any],
    time_cases: list[dict[str, Any]],
    provenance: list[dict[str, Any]],
) -> None:
    page = RESULTS_PATH.read_text(encoding="utf-8")
    require("run_summary6.png" not in page, "Results page embeds a legacy summary image")
    current = [stationary, *time_cases]
    for index, entry in enumerate(current):
        figure = entry.get("paper_figure")
        require(isinstance(figure, dict), f"reader-facing entry {index} has no figure")
        preview = figure.get("preview_path")
        require(isinstance(preview, str), f"reader-facing entry {index} has no preview")
        relative = "../" + str(PurePosixPath(preview).relative_to("docs"))
        require(relative in page, f"Results page does not embed {relative}")
    for entry in provenance:
        require(entry["raw_path"] not in page, f"Results page links provenance-only {entry['id']}")


def main() -> int:
    try:
        manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
        require(isinstance(manifest, dict), "manifest root must be a JSON object")
        require(manifest.get("schema_version") == "2.0", "unsupported schema_version")
        require(manifest.get("released_on") == "2026-07-14", "release date changed")
        require(manifest.get("release") == EXPECTED_RELEASE, "release revisions changed")
        policies = manifest.get("evidence_policy")
        require(isinstance(policies, dict), "evidence_policy must be an object")
        require(
            set(policies) == {"validated_current", "provenance_only"},
            "evidence policy vocabulary changed",
        )

        stationary = manifest.get("stationary_validation")
        validate_stationary(stationary)
        time_cases = validate_time_cases(manifest.get("time_integration_cases"))
        page = RESULTS_PATH.read_text(encoding="utf-8")
        provenance = validate_provenance(manifest.get("provenance_only"), page)
        require(isinstance(stationary, dict), "stationary validation is missing")
        validate_results_page(stationary, time_cases, provenance)
    except (OSError, UnicodeDecodeError, json.JSONDecodeError, ValidationError) as exc:
        print(f"Paper III manifest validation failed: {exc}", file=sys.stderr)
        return 1

    print(
        "Paper III manifest valid: 4 stationary cases (96 states, 780/780 gates), "
        "2 time-integration figures, 4 provenance-only archives."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

#!/usr/bin/env python3
"""Validate the curated Paper III evidence manifest against Git objects."""

from __future__ import annotations

import json
import math
import subprocess
import sys
from pathlib import Path, PurePosixPath
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
MANIFEST_PATH = ROOT / "docs" / "data" / "paper-iii-manifest.json"
ALLOWED_STATUSES = {"validated_current", "under_review"}


class ValidationError(RuntimeError):
    """Raised when the public evidence contract is inconsistent."""


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValidationError(message)


def git_bytes(path: str) -> bytes:
    process = subprocess.run(
        ["git", "show", f"HEAD:{path}"],
        cwd=ROOT,
        check=False,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if process.returncode != 0:
        detail = process.stderr.decode("utf-8", errors="replace").strip()
        raise ValidationError(f"missing Git object HEAD:{path}: {detail}")
    return process.stdout


def git_json(path: str) -> dict[str, Any]:
    try:
        value = json.loads(git_bytes(path))
    except json.JSONDecodeError as exc:
        raise ValidationError(f"invalid JSON in HEAD:{path}: {exc}") from exc
    require(isinstance(value, dict), f"HEAD:{path} must contain a JSON object")
    return value


def validate_archive_path(path: Any, context: str) -> str:
    require(isinstance(path, str) and path, f"{context} must be a nonempty string")
    pure_path = PurePosixPath(path)
    require(not pure_path.is_absolute(), f"{context} must be repository-relative: {path}")
    require(".." not in pure_path.parts, f"{context} must not traverse upward: {path}")
    require(path.startswith("docs/results/"), f"{context} must be under docs/results/: {path}")
    git_bytes(path)
    return path


def coefficient_record(constants: dict[str, Any]) -> dict[str, Any]:
    bifurcation = constants.get("bifurcation")
    return bifurcation if isinstance(bifurcation, dict) else constants


def assert_close(actual: Any, expected: Any, context: str) -> None:
    require(isinstance(actual, (int, float)), f"{context} archive value is not numeric")
    require(isinstance(expected, (int, float)), f"{context} manifest value is not numeric")
    require(
        math.isclose(float(actual), float(expected), rel_tol=1.0e-11, abs_tol=1.0e-12),
        f"{context} mismatch: archive={actual!r}, manifest={expected!r}",
    )


def validate_archive_assertions(entry: dict[str, Any], context: str) -> None:
    constants_path = validate_archive_path(entry.get("constants_path"), f"{context}.constants_path")
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
    require(isinstance(runs, list), f"{context} must be an array")
    for run_index, run in enumerate(runs):
        run_context = f"{context}[{run_index}]"
        require(isinstance(run, dict), f"{run_context} must be an object")
        for field in ("run_path", "metadata_path", "preview_path"):
            run_path = validate_archive_path(run.get(field), f"{run_context}.{field}")
            require(run_path.startswith(raw_path + "/"), f"{run_context}.{field} escapes its family")


def validate_case(case: Any, index: int) -> str:
    context = f"cases[{index}]"
    require(isinstance(case, dict), f"{context} must be an object")
    case_id = case.get("id")
    require(isinstance(case_id, str) and case_id, f"{context}.id must be nonempty")
    require(case.get("status") == "validated_current", f"{context} must be validated_current")
    require(case.get("quantitative_use") is True, f"{context} must permit quantitative use")
    require(isinstance(case.get("claim_scope"), str), f"{context} needs a claim_scope")
    raw_path = validate_archive_path(case.get("raw_path"), f"{context}.raw_path")
    require(isinstance(case.get("paper_figure_id"), str), f"{context} needs a paper_figure_id")
    validate_archive_assertions(case, context)
    validate_run_paths(case.get("featured_runs"), raw_path, f"{context}.featured_runs")
    return case_id


def validate_under_review(entry: Any, context: str, runs_field: str | None = None) -> str:
    require(isinstance(entry, dict), f"{context} must be an object")
    entry_id = entry.get("id")
    require(isinstance(entry_id, str) and entry_id, f"{context}.id must be nonempty")
    require(entry.get("status") == "under_review", f"{context} must be under_review")
    require(entry.get("quantitative_use") is False, f"{context} must prohibit quantitative use")
    for forbidden_key in ("classification", "current_values", "archive_assertions"):
        require(forbidden_key not in entry, f"{context} must not freeze {forbidden_key} while under review")
    raw_path = validate_archive_path(entry.get("raw_path"), f"{context}.raw_path")
    validate_archive_path(entry.get("constants_path"), f"{context}.constants_path")
    if runs_field is not None:
        validate_run_paths(entry.get(runs_field), raw_path, f"{context}.{runs_field}")
    return entry_id


def main() -> int:
    try:
        manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
        require(isinstance(manifest, dict), "manifest root must be a JSON object")
        require(manifest.get("schema_version") == "1.0", "unsupported schema_version")
        policies = manifest.get("evidence_policy")
        require(isinstance(policies, dict), "evidence_policy must be an object")
        require(set(policies) == ALLOWED_STATUSES, "evidence_policy keys do not match allowed statuses")

        cases = manifest.get("cases")
        pending = manifest.get("pending_review")
        reruns = manifest.get("rerun_queue")
        excluded = manifest.get("excluded_cases")
        require(isinstance(cases, list), "cases must be an array")
        require(isinstance(pending, list) and pending, "pending_review must be nonempty")
        require(isinstance(reruns, list), "rerun_queue must be an array")
        require(isinstance(excluded, list), "excluded_cases must be an array")

        ids = [validate_case(case, index) for index, case in enumerate(cases)]
        ids.extend(
            validate_under_review(entry, f"pending_review[{index}]", "archived_runs")
            for index, entry in enumerate(pending)
        )
        ids.extend(
            validate_under_review(entry, f"rerun_queue[{index}]")
            for index, entry in enumerate(reruns)
        )
        ids.extend(
            validate_under_review(entry, f"excluded_cases[{index}]")
            for index, entry in enumerate(excluded)
        )
        require(len(ids) == len(set(ids)), "manifest IDs must be unique")
    except (OSError, json.JSONDecodeError, ValidationError) as exc:
        print(f"Paper III manifest validation failed: {exc}", file=sys.stderr)
        return 1

    print(
        "Paper III manifest valid: "
        f"{len(cases)} current, {len(pending)} pending review, "
        f"{len(reruns)} rerun queue, {len(excluded)} excluded."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

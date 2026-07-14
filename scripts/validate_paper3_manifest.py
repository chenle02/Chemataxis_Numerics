#!/usr/bin/env python3
"""Validate the curated Paper III evidence manifest against Git objects."""

from __future__ import annotations

import hashlib
import json
import math
import subprocess
import sys
from pathlib import Path, PurePosixPath
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
MANIFEST_PATH = ROOT / "docs" / "data" / "paper-iii-manifest.json"
RESULTS_PATH = ROOT / "docs" / "results" / "index.md"
ALLOWED_STATUSES = {"validated_current", "under_review"}


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


def validate_public_asset(path: Any, expected_hash: Any, context: str) -> str:
    require(isinstance(path, str) and path, f"{context}.path must be nonempty")
    pure_path = PurePosixPath(path)
    require(
        path.startswith("docs/assets/images/"),
        f"{context}.path must be under docs/assets/images/: {path}",
    )
    require(
        pure_path.suffix in {".png", ".pdf"},
        f"{context}.path must be a PNG or PDF: {path}",
    )
    require(
        isinstance(expected_hash, str) and len(expected_hash) == 64,
        f"{context}.sha256 must be a 64-character digest",
    )
    actual_hash = hashlib.sha256(git_bytes(path)).hexdigest()
    require(
        actual_hash == expected_hash,
        f"{context} hash mismatch: object={actual_hash}, manifest={expected_hash}",
    )
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


def validate_run_paths(
    runs: Any,
    raw_path: str,
    context: str,
    preview_field: str = "preview_path",
) -> None:
    require(isinstance(runs, list), f"{context} must be an array")
    for run_index, run in enumerate(runs):
        run_context = f"{context}[{run_index}]"
        require(isinstance(run, dict), f"{run_context} must be an object")
        for field in ("run_path", "metadata_path", preview_field):
            run_path = validate_archive_path(run.get(field), f"{run_context}.{field}")
            require(
                run_path.startswith(raw_path + "/"),
                f"{run_context}.{field} escapes its family",
            )


def validate_paper_figure(case: dict[str, Any], context: str) -> None:
    figure_id = case.get("paper_figure_id")
    figure = case.get("paper_figure")
    require(isinstance(figure, dict), f"{context}.paper_figure must be an object")
    source_commit = figure.get("source_manuscript_commit")
    require(
        isinstance(source_commit, str)
        and 7 <= len(source_commit) <= 40
        and all(character in "0123456789abcdef" for character in source_commit),
        f"{context}.paper_figure.source_manuscript_commit must be a Git SHA",
    )
    preview_path = validate_public_asset(
        figure.get("preview_path"),
        figure.get("preview_sha256"),
        f"{context}.paper_figure.preview",
    )
    vector_path = validate_public_asset(
        figure.get("vector_path"),
        figure.get("vector_sha256"),
        f"{context}.paper_figure.vector",
    )
    require(
        PurePosixPath(preview_path).stem == figure_id
        and PurePosixPath(vector_path).stem == figure_id,
        f"{context}.paper_figure assets must match paper_figure_id",
    )


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
    validate_paper_figure(case, context)
    require(
        isinstance(case.get("legacy_preview_policy"), str)
        and case["legacy_preview_policy"],
        f"{context} needs a legacy_preview_policy",
    )
    validate_archive_assertions(case, context)
    validate_run_paths(
        case.get("featured_runs"),
        raw_path,
        f"{context}.featured_runs",
        "legacy_preview_path",
    )
    return case_id


def validate_results_page(cases: list[Any]) -> None:
    page = RESULTS_PATH.read_text(encoding="utf-8")
    require(
        "run_summary6.png" not in page,
        "curated Results page must not embed legacy per-run summary images",
    )
    for index, case in enumerate(cases):
        require(isinstance(case, dict), f"cases[{index}] must be an object")
        figure = case.get("paper_figure")
        require(isinstance(figure, dict), f"cases[{index}].paper_figure must be an object")
        preview_path = figure.get("preview_path")
        require(isinstance(preview_path, str), f"cases[{index}] needs a preview path")
        relative_path = "../" + str(PurePosixPath(preview_path).relative_to("docs"))
        require(
            relative_path in page,
            f"curated Results page does not embed {relative_path}",
        )


def validate_under_review(entry: Any, context: str, runs_field: str | None = None) -> str:
    require(isinstance(entry, dict), f"{context} must be an object")
    entry_id = entry.get("id")
    require(isinstance(entry_id, str) and entry_id, f"{context}.id must be nonempty")
    require(entry.get("status") == "under_review", f"{context} must be under_review")
    require(entry.get("quantitative_use") is False, f"{context} must prohibit quantitative use")
    for forbidden_key in ("classification", "current_values", "archive_assertions"):
        require(
            forbidden_key not in entry,
            f"{context} must not freeze {forbidden_key} while under review",
        )
    raw_path = validate_archive_path(entry.get("raw_path"), f"{context}.raw_path")
    constants_path = validate_archive_path(
        entry.get("constants_path"), f"{context}.constants_path"
    )
    corrected = entry.get("corrected_analysis")
    archived = entry.get("archived_constants")
    require(
        (corrected is None) == (archived is None),
        f"{context} must provide corrected_analysis and archived_constants together",
    )
    if corrected is not None:
        require(
            isinstance(corrected, dict),
            f"{context}.corrected_analysis must be an object",
        )
        require(
            isinstance(archived, dict),
            f"{context}.archived_constants must be an object",
        )
        require(
            isinstance(corrected.get("source_revision"), str)
            and corrected["source_revision"],
            f"{context}.corrected_analysis.source_revision must be nonempty",
        )
        require(
            corrected.get("classification") in {"supercritical", "subcritical"},
            f"{context}.corrected_analysis.classification is invalid",
        )
        constants = coefficient_record(git_json(constants_path))
        require(
            constants.get("classification") == archived.get("classification"),
            f"{context} archived classification changed",
        )
        assert_close(
            constants.get("beta_n0"),
            archived.get("beta_n0"),
            f"{context}.archived_constants.beta_n0",
        )
        require(
            isinstance(corrected.get("beta_n0"), (int, float)),
            f"{context}.corrected_analysis.beta_n0 must be numeric",
        )
    if runs_field is not None:
        validate_run_paths(entry.get(runs_field), raw_path, f"{context}.{runs_field}")
    return entry_id


def main() -> int:
    try:
        manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
        require(isinstance(manifest, dict), "manifest root must be a JSON object")
        require(manifest.get("schema_version") == "1.1", "unsupported schema_version")
        policies = manifest.get("evidence_policy")
        require(isinstance(policies, dict), "evidence_policy must be an object")
        require(
            set(policies) == ALLOWED_STATUSES,
            "evidence_policy keys do not match allowed statuses",
        )

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
        validate_results_page(cases)
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

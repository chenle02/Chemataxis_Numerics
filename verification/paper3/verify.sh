#!/usr/bin/env bash
set -euo pipefail

proof_dir=$(CDPATH= cd -- "$(dirname -- "$0")/lean" && pwd)
cd "$proof_dir"

proof_lake=$(command -v lake || true)
if [[ -z "$proof_lake" && -x "${HOME}/.elan/bin/lake" ]]; then
  proof_lake="${HOME}/.elan/bin/lake"
fi
if [[ -z "$proof_lake" ]]; then
  echo "ERROR: lake was not found. Install Lean with elan, then open a new terminal." >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "ERROR: python3 was not found. Install Python 3, then try again." >&2
  exit 1
fi

axiom_report=$(mktemp "${TMPDIR:-/tmp}/paper3-lean-axioms.XXXXXX")
trap 'rm -f "$axiom_report"' EXIT

echo "[1/4] Fetching the pinned mathlib build cache"
"$proof_lake" exe cache get

echo "[2/4] Building all Paper III Lean modules"
"$proof_lake" build

echo "[3/4] Computing and auditing the live axiom report"
"$proof_lake" env lean AxiomCheck.lean > "$axiom_report"
python3 make_receipt.py audit --axiom-output "$axiom_report"

echo "[4/4] Checking source, toolchain, dependencies, and theorem set against the receipt"
python3 make_receipt.py verify

echo "PASS: the canonical Paper III Lean verification is reproducible."

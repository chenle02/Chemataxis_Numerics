---
title: Reproduce
---

# Reproduce and verify

## Verify the frozen evidence contract

From the repository root, run the dependency-free validator and the bundle
checksum audit:

```bash
python scripts/validate_paper3_manifest.py
(cd docs/results/paper-iii/stationary-continuation/v1 && \
  sha256sum --check SHA256SUMS)
```

The validator checks:

- the exact simulator, manuscript-science, figure-source, and immutable-data
  revisions;
- the seven files named by the v1 `SHA256SUMS` manifest;
- `acceptance.passed=true`, 96 states, and 780 of 780 passing gates;
- all four stationary case IDs, analytical slopes, fitted mesh slopes, and
  observed orders;
- the stationary and time-figure PNG/PDF hashes;
- the two validated time-integration archives, constants, and featured runs;
- absence of legacy run previews and provenance-only raw paths from the
  curated Results page; and
- the exact four-family provenance-only boundary.

Expected output:

```text
Paper III manifest valid: 4 stationary cases (96 states, 780/780 gates), 2 time-integration figures, 4 provenance-only archives.
```

## Reproduce stationary continuation

Use the exact public simulator revision frozen by release 1.0.0:

```bash
git clone https://github.com/ianruau/Chemotaxis_simulation.git
cd Chemotaxis_simulation
git checkout 7c2a09b24fdebb9000b9b996eb34150d6de5ed17
python -m venv .venv
.venv/bin/pip install --editable .
.venv/bin/python stationary_branch_validation.py \
  --output-dir /tmp/paper3-stationary-validation \
  --check
```

The generator prescribes the signed first-cosine amplitude, eliminates the
elliptic variable with the production solver, and solves the remaining
stationary equations. For each of four cases it uses

- meshes `N=40,80,160`;
- amplitudes `A=+/-{0.0025,0.005,0.01,0.02}`; and
- the constrained fit `chi-chi_star_disc=c2*A^2+c4*A^4`.

For minimal cases, one dependent flux equation is replaced in the Newton
system by the fixed-mass constraint; the omitted endpoint equation is restored
and checked in the published full residual.

The command writes:

```text
branch-points.csv
fit-summary.json
states-index.json
stationary-continuation.pdf
stationary-continuation.png
stationary-profiles.csv
stationary-states.npz
SHA256SUMS
```

The published bundle was produced in two empty output directories. `diff -qr`
reported no difference, including the deterministic NPZ archive and PDF.

## Inspect the immutable data

The bundle is frozen at
[`stationary-continuation/v1`](https://github.com/chenle02/Chemataxis_Numerics/tree/master/docs/results/paper-iii/stationary-continuation/v1)
in public data commit
`e62ffa1e99122f8fbbeb3df7586f4050c4ff5c58`.

- `branch-points.csv` is the compact 96-row scalar table.
- `stationary-profiles.csv` is the long-form profile table.
- `stationary-states.npz` stores every `x`, `u`, and `v` array.
- `states-index.json` maps stable state IDs to NPZ array names and reflection
  partners.
- `fit-summary.json` records coefficients, gates, methods, runtime versions,
  and full source revisions.

Version `v1` is immutable. A changed method or regenerated artifact requires a
new version directory.

## Reproduce time-dependent diagnostics

The same simulator revision can reproduce or extend the two archived
time-integration families. Use each family's `config.yaml`, `constants.json`,
`run_plan.json`, and per-run `run_meta.json` together. Do not infer a current
coefficient or classification from a historical folder name or old preview
annotation.

The two current reader-facing composites are separately hashed in the release
manifest. Historical per-run summary images are not part of the paper
contract.

## Build the companion site

```bash
python -m venv .venv-docs
.venv-docs/bin/pip install --requirement requirements-docs.txt
.venv-docs/bin/mkdocs build --strict
```

The Pages build omits raw arrays, CSV files, result PDFs, checksums, legacy
galleries, and duplicate media. Git remains the complete archive; the site is
the restrained reading layer.

## Frozen provenance

| Component | Revision |
| --- | --- |
| Paper III numerical science | `fde25e17187bc3f247b36ce411f6f14eb93d52cf` |
| Simulator and generator | `7c2a09b24fdebb9000b9b996eb34150d6de5ed17` |
| Immutable stationary data | `e62ffa1e99122f8fbbeb3df7586f4050c4ff5c58` |
| Font-embedded time figures | `c0bfc431a19b81b1c45363dea472c29a745ad055` |

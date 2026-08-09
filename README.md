# Chemotaxis Models III · Evidence companion

[![Companion site](https://img.shields.io/badge/companion%20site-open-165a72?logo=githubpages)](https://chenle02.github.io/Chemataxis_Numerics/)
[![Verify evidence](https://github.com/chenle02/Chemataxis_Numerics/actions/workflows/verify.yml/badge.svg)](https://github.com/chenle02/Chemataxis_Numerics/actions/workflows/verify.yml)
[![Verify Lean proof](https://github.com/chenle02/Chemataxis_Numerics/actions/workflows/verify-lean.yml/badge.svg)](https://github.com/chenle02/Chemataxis_Numerics/actions/workflows/verify-lean.yml)
[![Deploy Pages](https://github.com/chenle02/Chemataxis_Numerics/actions/workflows/pages.yml/badge.svg)](https://github.com/chenle02/Chemataxis_Numerics/actions/workflows/pages.yml)
[![Release 1.0.0](https://img.shields.io/badge/data-v1.0.0-253b80)](CHANGELOG.md)
[![License: CC BY 4.0](https://img.shields.io/badge/license-CC%20BY%204.0-d97706.svg)](LICENSE)
[![Lean code: MIT](https://img.shields.io/badge/Lean%20code-MIT-6b7280.svg)](verification/LICENSE)

The public numerical and formal-verification companion to *Chemotaxis models with signal-dependent
sensitivity and a logistic-type source. III: Bifurcation* by Le Chen, Ian
Ruau, and Wenxian Shen.

Release 1.0.0 freezes the manuscript's numerical evidence at two complementary
levels: stationary continuation checks the local branch coefficient in four
parameter regimes, while two time-integration figures illustrate selected
near-threshold semidiscrete dynamics. Historical runs that failed the final
coefficient or conservation audit remain in Git for provenance, but are not
part of the reader-facing evidence. The separately versioned T3 layer supplies
the canonical Lean proof source and its own reproducibility receipt.

## Evidence ledger

| Evidence layer | Cases | Frozen result | Status |
| --- | ---: | --- | --- |
| Amplitude-constrained stationary continuation | 4 | `N=40,80,160`; 96 states; 780/780 gates; second-order coefficient convergence | Validated current |
| Near-threshold time integration | 2 | Quasi-linear and nonlinear-mobility manuscript figure families | Validated current |
| Lean formal verification | 167 declarations | 26 receipt-bound files; pinned Lean/mathlib; live axiom audit | Proof-grade T3 |
| Earlier fixed-mass and coefficient-seeded runs | 4 families | Retained only to document superseded calculations | Provenance only |

The stationary cases cover both branch directions in both model classes:

- non-minimal `a=10, beta=0` — supercritical;
- non-minimal `beta=3` — subcritical;
- minimal `m=gamma=1` — supercritical; and
- minimal `m=gamma=2` — subcritical.

The immutable bundle is
[`docs/results/paper-iii/stationary-continuation/v1/`](docs/results/paper-iii/stationary-continuation/v1/).
It contains scalar and profile CSV files, an indexed NPZ archive, PDF/PNG
figures, a machine-readable fit summary, and `SHA256SUMS`.

## Verify locally

The contract validator uses only the Python standard library:

```bash
python scripts/validate_paper3_manifest.py
(cd docs/results/paper-iii/stationary-continuation/v1 && sha256sum --check SHA256SUMS)
```

To rebuild the formal proof without downloading the large numerical archive,
follow the [novice Lean guide](docs/lean-reproduce.md). From an existing clone,
the short route is:

```bash
bash verification/paper3/verify.sh
```

The [statement coverage ledger](docs/lean-verification.md) lists exactly what
is verified, partially verified, and not formalized, with the reason for every
boundary.

Reproduce the stationary validation from the exact simulator revision:

```bash
git clone https://github.com/ianruau/Chemotaxis_simulation.git
cd Chemotaxis_simulation
git checkout 7c2a09b24fdebb9000b9b996eb34150d6de5ed17
python stationary_branch_validation.py \
  --output-dir /tmp/paper3-stationary-validation \
  --check
```

The frozen bundle was generated twice in separate output directories; the two
runs were byte-identical. See the
[reproduction guide](https://chenle02.github.io/Chemataxis_Numerics/reproduce/)
for environment and artifact details.

## Provenance anchors

| Object | Full Git revision |
| --- | --- |
| Immutable public data commit | `e62ffa1e99122f8fbbeb3df7586f4050c4ff5c58` |
| Paper III numerical-science commit | `fde25e17187bc3f247b36ce411f6f14eb93d52cf` |
| Simulator and stationary generator | `7c2a09b24fdebb9000b9b996eb34150d6de5ed17` |
| Font-embedded time-figure source | `c0bfc431a19b81b1c45363dea472c29a745ad055` |

These values, artifact hashes, case slopes, archive boundaries, and acceptance
counts are enforced by
[`paper-iii-manifest.json`](docs/data/paper-iii-manifest.json) and CI.

## Documentation

Build the Material site locally:

```bash
python -m venv .venv
.venv/bin/pip install --requirement requirements-docs.txt
.venv/bin/mkdocs build --strict
```

GitHub Pages is currently configured to serve the committed `master/docs`
snapshot. After changing the source Markdown or theme, refresh it with
`rsync -a site/ docs/`; CI verifies the same strict build.

The complete historical result tree remains under `docs/results/`. Folder
names are stable provenance identifiers, not evidence classifications. Only
the curated site and versioned manifest define the current Paper III contract.

Reusable simulation code is maintained separately in
[`ianruau/Chemotaxis_simulation`](https://github.com/ianruau/Chemotaxis_simulation).
The canonical Lean proof source is maintained in
[`verification/paper3/lean/`](verification/paper3/lean/).

## Citation and license

Use the repository's [`CITATION.cff`](CITATION.cff), cite version 1.0.0 and the
exact Git revision used, and cite the associated Paper III manuscript. The
documentation and published numerical material are licensed under
[CC BY 4.0](LICENSE). Formal-verification code under `verification/` is
licensed separately under the [MIT License](verification/LICENSE).

# Chemotaxis Models III · Bifurcation

[![Companion site](https://img.shields.io/badge/companion%20site-open-165a72?logo=githubpages)](https://chenle02.github.io/Chemataxis_Numerics/)
[![Verify data contract](https://github.com/chenle02/Chemataxis_Numerics/actions/workflows/verify.yml/badge.svg)](https://github.com/chenle02/Chemataxis_Numerics/actions/workflows/verify.yml)
[![Deploy Pages](https://github.com/chenle02/Chemataxis_Numerics/actions/workflows/pages.yml/badge.svg)](https://github.com/chenle02/Chemataxis_Numerics/actions/workflows/pages.yml)
[![License: CC BY 4.0](https://img.shields.io/badge/license-CC%20BY%204.0-d97706.svg)](LICENSE)

Public numerical archive and reader-facing companion for
*Chemotaxis models with signal-dependent sensitivity and a logistic-type
source. III: Bifurcation* by Le Chen, Ian Ruau, and Wenxian Shen.

The site connects the Paper III bifurcation statements to the exact archived
configurations and runs that were generated for them. The full center-graph
coefficient audit is complete. Two non-minimal figure families are validated;
minimal-model and coefficient-dependent branch-seeded runs remain explicitly
withheld or queued for regeneration.

## Evidence status

| Family | Public use | Status |
| --- | --- | --- |
| Non-minimal, `a=10`, `beta=0` | Paper III quasi-linear fixed-seed figure | Validated current |
| Non-minimal, `m=2`, `beta=1`, `gamma=2` | Paper III nonlinear-mobility fixed-seed figure | Validated current |
| Minimal model | Corrected coefficients, but no valid fixed-mass figure yet | Under review |
| Non-minimal subcritical `beta=3` | Corrected rerun/continuation target | Queued |

Historical directory names are preserved for stable data links. The manifest
and committed constants, not folder labels, define the current classification.

## Quick start

Validate the Paper III data contract:

```bash
python scripts/validate_paper3_manifest.py
```

Build the documentation locally:

```bash
python -m venv .venv
.venv/bin/pip install -r requirements-docs.txt
.venv/bin/mkdocs build --strict
```

GitHub Pages is currently locked to the legacy `master/docs` publishing mode.
After changing the reader-facing Markdown or theme, refresh the committed
static snapshot so the legacy deployment and the Actions deployment serve the
same Material site:

```bash
.venv/bin/mkdocs build --strict
rsync -a site/ docs/
```

The committed `docs/.nojekyll` file makes the legacy Pages job publish that
snapshot directly instead of rebuilding the Markdown with a different Jekyll
theme.

Open the curated guide at
[chenle02.github.io/Chemataxis_Numerics](https://chenle02.github.io/Chemataxis_Numerics/).
The full result tree stays available under
[`docs/results/`](docs/results/); large raw arrays and duplicate renderings are
intentionally excluded from the deployed Pages artifact.

## Repository map

```text
docs/
  .nojekyll                        publish the Material snapshot verbatim
  index.md                         landing-page source
  index.html                       committed legacy-Pages snapshot
  paper-iii.md                     model and paper-to-data contract
  results/index.md                 curated Paper III result families
  reproduce.md                     verification and rerun guide
  data.md                          provenance and archive layout
  cite.md                          citation guidance
  data/paper-iii-manifest.json     machine-readable evidence manifest
scripts/
  validate_paper3_manifest.py      contract and archive validator
.github/workflows/
  verify.yml                       pull-request verification
  pages.yml                        strict build and Pages deployment
```

Simulation code is maintained separately in
[`ianruau/Chemotaxis_simulation`](https://github.com/ianruau/Chemotaxis_simulation).

> **Maintainer note:** `scripts/generate_gallery.py` is the legacy full-archive
> indexer and is not part of the curated Paper III site build. If it overwrites
> `docs/results/index.md`, the manifest validator rejects the page because the
> two hashed manuscript figures disappear or a legacy `run_summary6.png`
> becomes reader-facing.

## License

Repository documentation and published numerical material are licensed under
[Creative Commons Attribution 4.0 International](LICENSE).

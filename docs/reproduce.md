---
title: Reproduce
---

# Reproduce and verify

## Verify the public evidence contract

The validator uses only the Python standard library. From the repository root:

```bash
python scripts/validate_paper3_manifest.py
```

It checks that:

- every featured family, constants file, and selected run exists in Git;
- validated coefficient values agree with archive assertions;
- quantitative use is disabled for every under-review record;
- every selected run belongs to its declared family;
- each current paper-figure PNG/PDF matches its declared SHA-256 digest;
- legacy per-run previews remain marked as archive-only and are not embedded
  on the curated Results page;
- historical or rerun-required families remain outside the validated list; and
- corrected analytical values recorded for an under-review family remain
  explicitly separated from, and checked against, its archived constants.

To build the same reader-facing site used by GitHub Pages:

```bash
python -m venv .venv
.venv/bin/pip install --requirement requirements-docs.txt
.venv/bin/mkdocs build --strict
```

## Reproduce a simulation

The numerical solver is maintained in
[`ianruau/Chemotaxis_simulation`](https://github.com/ianruau/Chemotaxis_simulation)
and released on PyPI as `chemotaxis-sim`.

```bash
python -m venv .venv-sim
.venv-sim/bin/pip install \
  "chemotaxis-sim @ git+https://github.com/ianruau/Chemotaxis_simulation.git@b414cee"
.venv-sim/bin/chemotaxis-sim --help
```

Commit `b414cee` includes the full center-graph coefficient calculation and
the conservative fixed-mass spatial flux. Use that revision or a later release
that contains both fixes; older package builds can reproduce raw trajectories
but not the corrected Paper III coefficient metadata or minimal-model mass
invariant.

Each archived family contains:

- `config.yaml` — model and solver parameters;
- `constants.json` — threshold and bifurcation diagnostics as computed at the
  time of the run;
- `run_plan.json` — the batch design;
- `runs/*/run_meta.json` — the realized sensitivity, amplitude, mesh, and time;
- `runs/*/run.npz` — raw solution arrays; and
- `runs/*/run_summary6.png` — a compact historical trajectory rendering.

Use the configuration and run metadata together. Do not infer a quantitative
Paper III result from a folder name or an old summary-image annotation alone.
The current reader-facing composites are versioned separately under
`docs/assets/images/` and identified by hash in the manifest.

## Review and rerun queue

Four items remain outside the validated Paper III contract:

1. Rerun the analytically supercritical minimal `m=1`, `gamma=1` case with the
   conservative fixed-mass solver and verify the invariant in the published
   raw array.
2. Rerun or continue the minimal `m=2`, `gamma=2` case, whose corrected
   coefficient is subcritical despite its historical `supercritical` folder.
3. Regenerate the genuinely subcritical non-minimal `beta=3` branch seeds with
   the corrected coefficient, or solve the stationary problem by continuation.
4. Keep the reclassified all-ones `beta=1` `A_rel` archive out of the paper
   contract; those files were initialized from an obsolete negative
   coefficient even though the case is supercritical.

The manifest keeps all four items non-quantitative until replacement files are
versioned and checked.

!!! info "Current validated scope"
    The quasi-linear `a=10`, `beta=0` and nonlinear `m=2`, `beta=1`, `gamma=2`
    fixed-seed families are the two validated Paper III numerical examples.
    The manifest fixes their exact constants and selected run paths.

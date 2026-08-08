# `xover-m05-g2-L5p3-n2-beta0`

!!! warning "Candidate, not validated evidence"
    Not part of the Paper III evidence contract; must not be cited as a
    validated result.

![xover-m05-g2-L5p3-n2-beta0](stationary-continuation.png)

## What was run

Amplitude-constrained stationary continuation of the non-minimal model, with
the signed first-cosine amplitude as the continuation parameter.

| quantity | value |
|---|---|
| a, b, α | 1, 1, 1 |
| m, γ | 0.5, 2 |
| β | 0 |
| domain length L | 5.3 |
| critical mode n₀ | 2 |
| χ\*(β) | 2.058477 |
| closed-form β_{n₀} | +0.75072174 |
| α_{n₀} | 1.16854646 |
| meshes | 40, 80, 160 |
| measured c₂ (N=160) | +0.64130535 |
| theory c₂ = β_{n₀}/α_{n₀} | +0.64244065 |
| relative error (finest) | 1.767e-03 |
| observed order | 2.000 |
| acceptance gates | 183/183 passed |
| measured direction | **supercritical** |

## Files

`run-card.yaml` (exact input) · `fit-summary.json` (methods, provenance, gates)
· `branch-points.csv` · `stationary-profiles.csv` · `stationary-states.npz` ·
`states-index.json` · `stationary-continuation.pdf` / `.png` · `SHA256SUMS`

## Reproduce

```bash
python stationary_branch_validation.py \
  --case-file run-card.yaml \
  --meshes 40,80,160 \
  --output-dir /tmp/xover-m05-g2-L5p3-n2-beta0 --check
```

Verify the published bytes:

```bash
sha256sum --check SHA256SUMS
```

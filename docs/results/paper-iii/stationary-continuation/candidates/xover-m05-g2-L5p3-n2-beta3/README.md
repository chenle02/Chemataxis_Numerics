# `xover-m05-g2-L5p3-n2-beta3`

!!! warning "Candidate, not validated evidence"
    Not part of the Paper III evidence contract; must not be cited as a
    validated result.

![xover-m05-g2-L5p3-n2-beta3](stationary-continuation.png)

## What was run

Amplitude-constrained stationary continuation of the non-minimal model, with
the signed first-cosine amplitude as the continuation parameter.

| quantity | value |
|---|---|
| a, b, α | 1, 1, 1 |
| m, γ | 0.5, 2 |
| β | 3 |
| domain length L | 5.3 |
| critical mode n₀ | 2 |
| χ\*(β) | 16.467816 |
| closed-form β_{n₀} | -1.37709297 |
| α_{n₀} | 0.14606831 |
| meshes | 40, 80, 160 |
| measured c₂ (N=160) | -9.44194239 |
| theory c₂ = β_{n₀}/α_{n₀} | -9.42773278 |
| relative error (finest) | 1.507e-03 |
| observed order | 2.001 |
| acceptance gates | 183/183 passed |
| measured direction | **subcritical** |

## Files

`run-card.yaml` (exact input) · `fit-summary.json` (methods, provenance, gates)
· `branch-points.csv` · `stationary-profiles.csv` · `stationary-states.npz` ·
`states-index.json` · `stationary-continuation.pdf` / `.png` · `SHA256SUMS`

## Reproduce

```bash
python stationary_branch_validation.py \
  --case-file run-card.yaml \
  --meshes 40,80,160 \
  --output-dir /tmp/xover-m05-g2-L5p3-n2-beta3 --check
```

Verify the published bytes:

```bash
sha256sum --check SHA256SUMS
```

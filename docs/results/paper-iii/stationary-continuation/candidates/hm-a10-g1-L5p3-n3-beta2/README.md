# `hm-a10-g1-L5p3-n3-beta2`

!!! warning "Candidate, not validated evidence"
    Not part of the Paper III evidence contract; must not be cited as a
    validated result.

![hm-a10-g1-L5p3-n3-beta2](stationary-continuation.png)

## What was run

Amplitude-constrained stationary continuation of the non-minimal model, with
the signed first-cosine amplitude as the continuation parameter.

| quantity | value |
|---|---|
| a, b, α | 10, 1, 1 |
| m, γ | 1, 1 |
| β | 2 |
| domain length L | 5.3 |
| critical mode n₀ | 3 |
| χ\*(β) | 209.627119 |
| closed-form β_{n₀} | -0.09498999 |
| α_{n₀} | 0.06278867 |
| meshes | 48, 96 |
| measured c₂ (N=96) | -1.51352444 |
| theory c₂ = β_{n₀}/α_{n₀} | -1.51285231 |
| relative error (finest) | 4.443e-04 |
| observed order | 1.963 |
| acceptance gates | 123/123 passed |
| measured direction | **subcritical** |

## Files

`run-card.yaml` (exact input) · `fit-summary.json` (methods, provenance, gates)
· `branch-points.csv` · `stationary-profiles.csv` · `stationary-states.npz` ·
`states-index.json` · `stationary-continuation.pdf` / `.png` · `SHA256SUMS`

## Reproduce

```bash
python stationary_branch_validation.py \
  --case-file run-card.yaml \
  --meshes 48,96 \
  --output-dir /tmp/hm-a10-g1-L5p3-n3-beta2 --check
```

Verify the published bytes:

```bash
sha256sum --check SHA256SUMS
```

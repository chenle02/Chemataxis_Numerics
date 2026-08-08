# `hm-m2-g2-L5p3-n2-beta1`

!!! warning "Candidate, not validated evidence"
    Not part of the Paper III evidence contract; must not be cited as a
    validated result.

![hm-m2-g2-L5p3-n2-beta1](stationary-continuation.png)

## What was run

Amplitude-constrained stationary continuation of the non-minimal model, with
the signed first-cosine amplitude as the continuation parameter.

| quantity | value |
|---|---|
| a, b, α | 1, 1, 1 |
| m, γ | 2, 2 |
| β | 1 |
| domain length L | 5.3 |
| critical mode n₀ | 2 |
| χ\*(β) | 4.116954 |
| closed-form β_{n₀} | +2.26224175 |
| α_{n₀} | 0.58427323 |
| meshes | 80, 160, 320 |
| measured c₂ (N=320) | +3.86749077 |
| theory c₂ = β_{n₀}/α_{n₀} | +3.87189012 |
| relative error (finest) | 1.136e-03 |
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
  --meshes 80,160,320 \
  --output-dir /tmp/hm-m2-g2-L5p3-n2-beta1 --check
```

Verify the published bytes:

```bash
sha256sum --check SHA256SUMS
```

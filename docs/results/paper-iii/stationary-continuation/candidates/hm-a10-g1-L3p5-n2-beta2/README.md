# `hm-a10-g1-L3p5-n2-beta2`

!!! warning "Candidate, not validated evidence"
    Not part of the Paper III evidence contract; must not be cited as a
    validated result.

![hm-a10-g1-L3p5-n2-beta2](stationary-continuation.png)

## What was run

Amplitude-constrained stationary continuation of the non-minimal model, with
the signed first-cosine amplitude as the continuation parameter.

| quantity | value |
|---|---|
| a, b, α | 10, 1, 1 |
| m, γ | 1, 1 |
| β | 2 |
| domain length L | 3.5 |
| critical mode n₀ | 2 |
| χ\*(β) | 209.640840 |
| closed-form β_{n₀} | -0.09449102 |
| α_{n₀} | 0.06307324 |
| meshes | 40, 80 |
| measured c₂ (N=80) | -1.49850674 |
| theory c₂ = β_{n₀}/α_{n₀} | -1.49811574 |
| relative error (finest) | 2.610e-04 |
| observed order | 1.975 |
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
  --meshes 40,80 \
  --output-dir /tmp/hm-a10-g1-L3p5-n2-beta2 --check
```

Verify the published bytes:

```bash
sha256sum --check SHA256SUMS
```

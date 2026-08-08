# `hm-m2-g2-L5p3-n2-beta6`

!!! warning "Candidate, not validated evidence"
    Not part of the Paper III evidence contract; must not be cited as a
    validated result.

![hm-m2-g2-L5p3-n2-beta6](stationary-continuation.png)

## What was run

Amplitude-constrained stationary continuation of the non-minimal model, with
the signed first-cosine amplitude as the continuation parameter.

| quantity | value |
|---|---|
| a, b, α | 1, 1, 1 |
| m, γ | 2, 2 |
| β | 6 |
| domain length L | 5.3 |
| critical mode n₀ | 2 |
| χ\*(β) | 131.742530 |
| closed-form β_{n₀} | -1.35126335 |
| α_{n₀} | 0.01825854 |
| meshes | 40, 80 |
| measured c₂ (N=80) | -74.25425046 |
| theory c₂ = β_{n₀}/α_{n₀} | -74.00720236 |
| relative error (finest) | 3.338e-03 |
| observed order | 2.007 |
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
  --output-dir /tmp/hm-m2-g2-L5p3-n2-beta6 --check
```

Verify the published bytes:

```bash
sha256sum --check SHA256SUMS
```

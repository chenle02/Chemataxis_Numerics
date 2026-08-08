# `hm-a10-g1-L5p3-n3-beta0`

!!! warning "Candidate, not validated evidence"
    Not part of the Paper III evidence contract; must not be cited as a
    validated result.

![hm-a10-g1-L5p3-n3-beta0](stationary-continuation.png)

## What was run

Amplitude-constrained stationary continuation of the non-minimal model, with
the signed first-cosine amplitude as the continuation parameter.

| quantity | value |
|---|---|
| a, b, α | 10, 1, 1 |
| m, γ | 1, 1 |
| β | 0 |
| domain length L | 5.3 |
| critical mode n₀ | 3 |
| χ\*(β) | 1.732456 |
| closed-form β_{n₀} | +0.12138172 |
| α_{n₀} | 7.59742940 |
| meshes | 48, 96, 192 |
| measured c₂ (N=192) | +0.01595091 |
| theory c₂ = β_{n₀}/α_{n₀} | +0.01597668 |
| relative error (finest) | 1.613e-03 |
| observed order | 1.999 |
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
  --meshes 48,96,192 \
  --output-dir /tmp/hm-a10-g1-L5p3-n3-beta0 --check
```

Verify the published bytes:

```bash
sha256sum --check SHA256SUMS
```

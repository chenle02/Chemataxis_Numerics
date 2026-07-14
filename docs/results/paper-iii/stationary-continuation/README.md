# Paper III stationary continuation

This archive validates the local Paper III bifurcation coefficient without
time integration.  The solver prescribes the signed first-cosine amplitude,
solves the stationary finite-difference equations, and fits
`chi - chi_star_disc = c2 A^2 + c4 A^4`.

Version [`v1`](v1/) contains four cases: the non-minimal `a=10, beta=0`
supercritical benchmark, the non-minimal `beta=3` subcritical benchmark, and
the fixed-mass minimal cases `m=gamma=1` and `m=gamma=2`.  Each case uses
meshes `N=40,80,160` and amplitudes
`A=+/-{0.0025,0.005,0.01,0.02}`, for 96 stationary states in total.

All 780 of 780 acceptance gates pass.  Across the archive, the maximum full
stationary `u` residual is `8.51e-11`, the maximum independently reconstructed
elliptic residual is `1.14e-10`, and the maximum fixed-mass error is
`3.33e-16`.  The fitted quadratic coefficient has observed mesh-refinement
order `1.998--2.009`.

The bundle was generated from simulator commit
`7c2a09b24fdebb9000b9b996eb34150d6de5ed17` with:

```bash
python stationary_branch_validation.py \
  --output-dir /tmp/paper3-stationary-7c2a09b-run1 \
  --check
```

An independent duplicate run at `/tmp/paper3-stationary-7c2a09b-run2` was
byte-identical (`diff -qr`).  File digests are recorded in
[`v1/SHA256SUMS`](v1/SHA256SUMS).  The `v1` directory is immutable; any future
regeneration or extension must be published under a new version directory.

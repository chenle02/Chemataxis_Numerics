---
title: Results
---

# Curated Paper III results

!!! info "Working companion — evolving, not yet distributed"
    This site is the coauthor-facing view of the Paper III computations while
    the paper is being prepared. Content evolves as results come in. It is not
    being distributed until the manuscript is submitted to a journal and
    arXiv, at which point a milestone tag will freeze the results to match the
    paper. Access is not restricted, so please note the evidence tier attached
    to anything you read here.

The release contains one complete stationary-continuation study and two
selected time-integration figure families. These are the only reader-facing
numerical objects. The larger historical archive is preserved for provenance,
but folder names and legacy galleries do not define evidence status.

## Stationary continuation across four regimes

<div class="result-card result-card--featured" markdown>
<div class="result-card__topline">
  <span class="status-pill status-pill--current">Validated current · v1</span>
  <span>4 cases · 3 meshes · 8 amplitudes · 96 states</span>
</div>

### The local coefficient, measured independently

Instead of integrating in time, this experiment prescribes the signed
first-cosine amplitude and solves the stationary finite-difference equations.
For each mesh it fits

\[
\chi_h(A)-\chi_h^*=c_{2,h}A^2+c_{4,h}A^4,
\]

then compares \(c_{2,h}\) with the analytical value
\(\beta_{n_0}/\alpha_{n_0}\).

![Four amplitude-constrained stationary branches](../assets/images/paper3-stationary-continuation.png)

| Case | Direction | Theory \(c_2\) | \(c_{2,160}\) | Finest relative error |
| --- | --- | ---: | ---: | ---: |
| Non-minimal `a=10, beta=0` | Supercritical | `0.0084254463` | `0.0084220572` | `4.02e-4` |
| Non-minimal `beta=3` | Subcritical | `-19.66671032` | `-19.64492609` | `1.11e-3` |
| Minimal `m=gamma=1` | Supercritical | `1.922989917` | `1.922366447` | `3.24e-4` |
| Minimal `m=gamma=2` | Subcritical | `-1.148587331` | `-1.150522206` | `1.68e-3` |

The coefficient errors refine at observed order `1.998--2.009`. All 780 of
780 acceptance gates pass. The largest full stationary `u` residual is
`8.51e-11`, the largest independently reconstructed elliptic residual is
`1.14e-10`, and the largest fixed-mass error is `3.33e-16`.

[Immutable v1 bundle](https://github.com/chenle02/Chemataxis_Numerics/tree/master/docs/results/paper-iii/stationary-continuation/v1){ .md-button .md-button--primary }
[Fit summary](https://github.com/chenle02/Chemataxis_Numerics/blob/master/docs/results/paper-iii/stationary-continuation/v1/fit-summary.json){ .md-button }
[Checksums](https://github.com/chenle02/Chemataxis_Numerics/blob/master/docs/results/paper-iii/stationary-continuation/v1/SHA256SUMS){ .md-button }
[Vector figure](../assets/images/paper3-stationary-continuation.pdf){ .md-button }
</div>

## Near-threshold time integration

These two three-panel composites are the time-dependent figures retained in
the manuscript. They use fixed perturbations and report semidiscrete behavior
on the named archives.

### Quasi-linear supercritical benchmark

<div class="result-card" markdown>
<div class="result-card__topline">
  <span class="status-pill status-pill--current">Validated current</span>
  <span>Logistic equilibrium · mode n = 1</span>
</div>

#### Parameters: a=10, b=alpha=m=gamma=mu=nu=L=1, beta=0

The full center-graph calculation gives

\[
\chi^*=2.188281623751274,
\qquad
\beta_{1}=0.076503080515203>0.
\]

The below-threshold trajectory returns toward the constant state; the two
above-threshold trajectories approach symmetry-related patterns. For the
1%-above run, the final cosine amplitude is `1.62372574646`, compared with the
leading-order prediction `1.61159217017`.

![Quasi-linear Paper III three-panel comparison](../assets/images/paper3-supercritical-quasilinear.png)

[Raw validated family](https://github.com/chenle02/Chemataxis_Numerics/tree/master/docs/results/quasilinear/supercritical/a10_b1_alpha1_m1_beta0_gamma1_mu1_nu1_L1_n1){ .md-button }
[Corrected constants](https://github.com/chenle02/Chemataxis_Numerics/blob/master/docs/results/quasilinear/supercritical/a10_b1_alpha1_m1_beta0_gamma1_mu1_nu1_L1_n1/constants.json){ .md-button }
[Vector figure](../assets/images/paper3-supercritical-quasilinear.pdf){ .md-button }
</div>

### Nonlinear-mobility supercritical benchmark

<div class="result-card" markdown>
<div class="result-card__topline">
  <span class="status-pill status-pill--current">Validated current</span>
  <span>Logistic equilibrium · mode n = 1</span>
</div>

#### Parameters: a=b=alpha=1, m=2, beta=1, gamma=2, mu=nu=L=1

The corrected analytical values are

\[
\chi^*=11.970925584731697,
\qquad
\beta_{1}=9.508880363384589>0.
\]

Fixed positive and negative seeds above threshold produce opposite patterned
trajectories, while the selected below-threshold run decays. This family tests
nonlinear chemotactic mobility and nonlinear signal production.

![Nonlinear-mobility Paper III three-panel comparison](../assets/images/paper3-supercritical-nonlinear.png)

[Raw validated family](https://github.com/chenle02/Chemataxis_Numerics/tree/master/docs/results/nonlinear_beta_gamma/supercritical/a1_b1_alpha1_m2_beta1_gamma2_mu1_nu1_L1_n1){ .md-button }
[Corrected constants](https://github.com/chenle02/Chemataxis_Numerics/blob/master/docs/results/nonlinear_beta_gamma/supercritical/a1_b1_alpha1_m2_beta1_gamma2_mu1_nu1_L1_n1/constants.json){ .md-button }
[Vector figure](../assets/images/paper3-supercritical-nonlinear.pdf){ .md-button }
</div>

## Provenance boundary

Four earlier families remain versioned but are excluded from the current
contract: two time-dependent minimal-model archives with conservation or
classification problems, the obsolete `beta=3` coefficient-seeded runs, and
the reclassified all-ones coefficient-seeded runs. Their exact Git paths and
reasons are recorded under `provenance_only` in the
[manifest](../data/paper-iii-manifest.json); this page intentionally provides
no galleries or preview links for them.

!!! note "Scientific scope"
    The figures and fitted coefficients are evidence about the spatially
    semidiscrete computations. The continuous-PDE conclusions come from the
    manuscript's analysis.

## Candidate stationary cases (not validated evidence)

!!! warning "These are candidates, not results of this paper"
    The twelve bundles below are **not** part of the Paper III evidence
    contract and must not be cited as validated. They are published so the
    computation is inspectable and reproducible, at an explicitly lower tier
    than the four `validated_current` stationary cases above. Promotion to
    `validated_current` is an author decision that has not been taken.

Each candidate extends the stationary-continuation study to a nontrivial
critical mode (n₀ = 2 or 3) or to a new sensitivity exponent. Every bundle
carries the same artifact set as the validated v1 bundle, plus the exact
`run-card.yaml` it was generated from, and each is checked in CI by the same
machinery that guards v1:

- every file hash in `SHA256SUMS` is re-derived from the committed Git object;
- the generating tree must have been clean;
- the bundle's own acceptance gates must all pass;
- the continuum minimizing mode must equal the declared critical mode;
- `theory_c2` must equal `beta_n0 / alpha_n0`, with `alpha_n0 > 0`; and
- the **label gate**: the sign of the measured branch slope `c₂` at the finest
  mesh must equal the sign of the closed-form `beta_n0`, which must in turn
  agree with the declared regime.

The manifest's numbers for each candidate are compared against the bundle
itself, so a manifest entry cannot disagree with the artifact it describes.

Twelve candidate bundles are published. Every row below is read from the
bundle's own `fit-summary.json`; the site cannot disagree with the artifacts.

| Case | family | L | n₀ | β | closed-form β_{n₀} | measured c₂ (finest) | order | gates | regime |
|---|---|---:|---:|---:|---:|---:|---:|:---:|---|
| [`hm-a10-g1-L3p5-n2-beta0`](paper-iii/stationary-continuation/candidates/hm-a10-g1-L3p5-n2-beta0/) | a=10, &gamma;=1 | 3.5 | 2 | 0 | +0.118097 | +0.015458 | 2.001 | 183/183 | supercritical |
| [`hm-a10-g1-L3p5-n2-beta2`](paper-iii/stationary-continuation/candidates/hm-a10-g1-L3p5-n2-beta2/) | a=10, &gamma;=1 | 3.5 | 2 | 2 | -0.094491 | -1.498507 | 1.975 | 123/123 | subcritical |
| [`hm-a10-g1-L5p3-n3-beta0`](paper-iii/stationary-continuation/candidates/hm-a10-g1-L5p3-n3-beta0/) | a=10, &gamma;=1 | 5.3 | 3 | 0 | +0.121382 | +0.015951 | 1.999 | 183/183 | supercritical |
| [`hm-a10-g1-L5p3-n3-beta2`](paper-iii/stationary-continuation/candidates/hm-a10-g1-L5p3-n3-beta2/) | a=10, &gamma;=1 | 5.3 | 3 | 2 | -0.094990 | -1.513524 | 1.963 | 123/123 | subcritical |
| [`hm-m05-g2-L5p3-n2-beta1`](paper-iii/stationary-continuation/candidates/hm-m05-g2-L5p3-n2-beta1/) | m=0.5, &gamma;=2 | 5.3 | 2 | 1 | +0.261571 | +0.447162 | 1.997 | 123/123 | supercritical |
| [`hm-m05-g2-L5p3-n2-beta2`](paper-iii/stationary-continuation/candidates/hm-m05-g2-L5p3-n2-beta2/) | m=0.5, &gamma;=2 | 5.3 | 2 | 2 | -0.447701 | -1.536975 | 2.005 | 123/123 | subcritical |
| [`hm-m05-g2-L8-n3-beta1`](paper-iii/stationary-continuation/candidates/hm-m05-g2-L8-n3-beta1/) | m=0.5, &gamma;=2 | 8 | 3 | 1 | +0.253238 | +0.434907 | 1.996 | 123/123 | supercritical |
| [`hm-m05-g2-L8-n3-beta2`](paper-iii/stationary-continuation/candidates/hm-m05-g2-L8-n3-beta2/) | m=0.5, &gamma;=2 | 8 | 3 | 2 | -0.457315 | -1.580808 | 2.008 | 123/123 | subcritical |
| [`hm-m2-g2-L5p3-n2-beta1`](paper-iii/stationary-continuation/candidates/hm-m2-g2-L5p3-n2-beta1/) | m=2, &gamma;=2 | 5.3 | 2 | 1 | +2.262242 | +3.867491 | 2.000 | 183/183 | supercritical |
| [`hm-m2-g2-L5p3-n2-beta6`](paper-iii/stationary-continuation/candidates/hm-m2-g2-L5p3-n2-beta6/) | m=2, &gamma;=2 | 5.3 | 2 | 6 | -1.351263 | -74.254250 | 2.007 | 123/123 | subcritical |
| [`xover-m05-g2-L5p3-n2-beta0`](paper-iii/stationary-continuation/candidates/xover-m05-g2-L5p3-n2-beta0/) | m=0.5, &gamma;=2 | 5.3 | 2 | 0 | +0.750722 | +0.641305 | 2.000 | 183/183 | supercritical |
| [`xover-m05-g2-L5p3-n2-beta3`](paper-iii/stationary-continuation/candidates/xover-m05-g2-L5p3-n2-beta3/) | m=0.5, &gamma;=2 | 5.3 | 2 | 3 | -1.377093 | -9.441942 | 2.001 | 183/183 | subcritical |

`c₂` is the measured branch slope at the finest mesh and `β_{n₀}` the
closed-form cubic coefficient; they carry the same sign because
`c₂ = β_{n₀}/α_{n₀}` with `α_{n₀} > 0`. Observed orders are the empirical
mesh-refinement rates.

### Figures

<div class="grid cards" markdown>

-   **`hm-a10-g1-L3p5-n2-beta0`**

    ![hm-a10-g1-L3p5-n2-beta0](paper-iii/stationary-continuation/candidates/hm-a10-g1-L3p5-n2-beta0/stationary-continuation.png)

    L=3.5, n₀=2, β=0 · β_{n₀}=+0.1181 · c₂=+0.0155 · **supercritical**

-   **`hm-a10-g1-L3p5-n2-beta2`**

    ![hm-a10-g1-L3p5-n2-beta2](paper-iii/stationary-continuation/candidates/hm-a10-g1-L3p5-n2-beta2/stationary-continuation.png)

    L=3.5, n₀=2, β=2 · β_{n₀}=-0.0945 · c₂=-1.4985 · **subcritical**

-   **`hm-a10-g1-L5p3-n3-beta0`**

    ![hm-a10-g1-L5p3-n3-beta0](paper-iii/stationary-continuation/candidates/hm-a10-g1-L5p3-n3-beta0/stationary-continuation.png)

    L=5.3, n₀=3, β=0 · β_{n₀}=+0.1214 · c₂=+0.0160 · **supercritical**

-   **`hm-a10-g1-L5p3-n3-beta2`**

    ![hm-a10-g1-L5p3-n3-beta2](paper-iii/stationary-continuation/candidates/hm-a10-g1-L5p3-n3-beta2/stationary-continuation.png)

    L=5.3, n₀=3, β=2 · β_{n₀}=-0.0950 · c₂=-1.5135 · **subcritical**

-   **`hm-m05-g2-L5p3-n2-beta1`**

    ![hm-m05-g2-L5p3-n2-beta1](paper-iii/stationary-continuation/candidates/hm-m05-g2-L5p3-n2-beta1/stationary-continuation.png)

    L=5.3, n₀=2, β=1 · β_{n₀}=+0.2616 · c₂=+0.4472 · **supercritical**

-   **`hm-m05-g2-L5p3-n2-beta2`**

    ![hm-m05-g2-L5p3-n2-beta2](paper-iii/stationary-continuation/candidates/hm-m05-g2-L5p3-n2-beta2/stationary-continuation.png)

    L=5.3, n₀=2, β=2 · β_{n₀}=-0.4477 · c₂=-1.5370 · **subcritical**

-   **`hm-m05-g2-L8-n3-beta1`**

    ![hm-m05-g2-L8-n3-beta1](paper-iii/stationary-continuation/candidates/hm-m05-g2-L8-n3-beta1/stationary-continuation.png)

    L=8, n₀=3, β=1 · β_{n₀}=+0.2532 · c₂=+0.4349 · **supercritical**

-   **`hm-m05-g2-L8-n3-beta2`**

    ![hm-m05-g2-L8-n3-beta2](paper-iii/stationary-continuation/candidates/hm-m05-g2-L8-n3-beta2/stationary-continuation.png)

    L=8, n₀=3, β=2 · β_{n₀}=-0.4573 · c₂=-1.5808 · **subcritical**

-   **`hm-m2-g2-L5p3-n2-beta1`**

    ![hm-m2-g2-L5p3-n2-beta1](paper-iii/stationary-continuation/candidates/hm-m2-g2-L5p3-n2-beta1/stationary-continuation.png)

    L=5.3, n₀=2, β=1 · β_{n₀}=+2.2622 · c₂=+3.8675 · **supercritical**

-   **`hm-m2-g2-L5p3-n2-beta6`**

    ![hm-m2-g2-L5p3-n2-beta6](paper-iii/stationary-continuation/candidates/hm-m2-g2-L5p3-n2-beta6/stationary-continuation.png)

    L=5.3, n₀=2, β=6 · β_{n₀}=-1.3513 · c₂=-74.2543 · **subcritical**

-   **`xover-m05-g2-L5p3-n2-beta0`**

    ![xover-m05-g2-L5p3-n2-beta0](paper-iii/stationary-continuation/candidates/xover-m05-g2-L5p3-n2-beta0/stationary-continuation.png)

    L=5.3, n₀=2, β=0 · β_{n₀}=+0.7507 · c₂=+0.6413 · **supercritical**

-   **`xover-m05-g2-L5p3-n2-beta3`**

    ![xover-m05-g2-L5p3-n2-beta3](paper-iii/stationary-continuation/candidates/xover-m05-g2-L5p3-n2-beta3/stationary-continuation.png)

    L=5.3, n₀=2, β=3 · β_{n₀}=-1.3771 · c₂=-9.4419 · **subcritical**

</div>

### β-dependence of the bifurcation direction

!!! question "Numerical response to Wenxian's question of 2025-12-07"
    Wenxian asked whether β affects the bifurcation *direction*, not only the
    threshold. These four measurements are in the same family
    (m=1/2, gamma=2, L=5.3, n0=2), with β the only quantity moved. They are reported as
    measurements; whether this becomes a named result in the paper is hers to
    decide.

| β | closed-form β_{n₀} | measured c₂ (finest) | measured direction |
|---:|---:|---:|---|
| 0 | +0.750722 | +0.641305 | supercritical |
| 1 | +0.261571 | +0.447162 | supercritical |
| 2 | -0.447701 | -1.536975 | subcritical |
| 3 | -1.377093 | -9.441942 | subcritical |

The measured direction changes between β = 1 and β = 2, bracketing the positive
root of the closed-form quadratic in β (β⁺ ≈ 1.406 for this family).

Each bundle folder carries a `README.md` with its parameters, measured
numbers, and a reproduction command; browse them on
[GitHub](https://github.com/chenle02/Chemataxis_Numerics/tree/master/docs/results/paper-iii/stationary-continuation/candidates).
Every bundle path is also listed under `candidate_stationary_cases` in the
[evidence manifest](../data/paper-iii-manifest.json). Folder names are
provenance identifiers, not evidence classifications.

## Machine-readable record

The [Paper III evidence manifest](../data/paper-iii-manifest.json) freezes the
two evidence layers, all source revisions, figure hashes, v1 checksums, case
IDs, branch slopes, acceptance metrics, and provenance exclusions. CI resolves
every declared object from Git and rejects a reader-facing link to any
provenance-only raw family. Candidate cases are recorded separately under
`candidate_stationary_cases` and are excluded from the reader-facing contract.

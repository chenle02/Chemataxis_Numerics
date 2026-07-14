---
title: Results
---

# Curated Paper III results

This page mirrors the numerical section of the active Paper III manuscript.
Only two non-minimal fixed-seed families are current paper evidence. The raw
archive remains much larger, but folder names and historical galleries are not
evidence statuses.

## Quasi-linear supercritical benchmark

<div class="result-card" markdown>
<div class="result-card__topline">
  <span class="status-pill status-pill--current">Validated current</span>
  <span>Logistic equilibrium · mode n = 1</span>
</div>

### Parameters: a=10, b=α=m=γ=μ=ν=L=1, β=0

The full center-graph calculation gives

\[
\chi^*=2.188281623751274,
\qquad
\beta_{1}=0.076503080515203>0.
\]

The selected runs use the same fixed perturbation magnitude on both sides of
the threshold. The below-threshold trajectory returns toward the constant
state; the two above-threshold trajectories approach symmetry-related
patterns. For the 1%-above run, the final cosine amplitude is
`1.62372574646`, compared with the leading-order prediction
`1.61159217017`.

![Quasi-linear positive branch](https://raw.githubusercontent.com/chenle02/Chemataxis_Numerics/master/docs/results/quasilinear/supercritical/a10_b1_alpha1_m1_beta0_gamma1_mu1_nu1_L1_n1/runs/chi2-2102_ep0-0010_p/run_summary6.png)

[Raw family](https://github.com/chenle02/Chemataxis_Numerics/tree/master/docs/results/quasilinear/supercritical/a10_b1_alpha1_m1_beta0_gamma1_mu1_nu1_L1_n1){ .md-button }
[Corrected constants](https://github.com/chenle02/Chemataxis_Numerics/blob/master/docs/results/quasilinear/supercritical/a10_b1_alpha1_m1_beta0_gamma1_mu1_nu1_L1_n1/constants.json){ .md-button }
</div>

## Nonlinear-mobility supercritical benchmark

<div class="result-card" markdown>
<div class="result-card__topline">
  <span class="status-pill status-pill--current">Validated current</span>
  <span>Logistic equilibrium · mode n = 1</span>
</div>

### Parameters: a=b=α=1, m=2, β=1, γ=2, μ=ν=L=1

The corrected analytical values are

\[
\chi^*=11.970925584731697,
\qquad
\beta_{1}=9.508880363384589>0.
\]

This family tests nonlinear chemotactic mobility and nonlinear signal
production. Fixed positive and negative seeds above threshold produce opposite
patterned trajectories, while the selected below-threshold run decays. These
are semidiscrete numerical observations; they are not a substitute for the
continuous-PDE stability argument.

![Nonlinear-mobility positive branch](https://raw.githubusercontent.com/chenle02/Chemataxis_Numerics/master/docs/results/nonlinear_beta_gamma/supercritical/a1_b1_alpha1_m2_beta1_gamma2_mu1_nu1_L1_n1/runs/chi12-0906_ep0-0010_p/run_summary6.png)

[Raw family](https://github.com/chenle02/Chemataxis_Numerics/tree/master/docs/results/nonlinear_beta_gamma/supercritical/a1_b1_alpha1_m2_beta1_gamma2_mu1_nu1_L1_n1){ .md-button }
[Corrected constants](https://github.com/chenle02/Chemataxis_Numerics/blob/master/docs/results/nonlinear_beta_gamma/supercritical/a1_b1_alpha1_m2_beta1_gamma2_mu1_nu1_L1_n1/constants.json){ .md-button }
</div>

## Withheld and queued evidence

<div class="result-card result-card--review" markdown>
<div class="result-card__topline">
  <span class="status-pill status-pill--review">Under review</span>
  <span>Fixed-mass minimal model</span>
</div>

The minimal `m=1`, `gamma=1` coefficient is positive, but its archived
above-threshold trajectory has unacceptable mass drift. The archived `m=2`,
`gamma=2` family is actually subcritical, despite its historical directory
name. Neither family is a current Paper III figure.
</div>

!!! note "Subcritical continuation target"
    The corrected all-ones family with sensitivity exponent `beta=3` has
    `beta_n0 = -2.232172436126313`. Existing `A_rel` runs used an obsolete
    asymptotic amplitude, so a corrected rerun or stationary continuation solve
    is queued. The former `beta=1` branch-seeded family is supercritical and is
    retained only as a reclassified historical archive.

## Machine-readable record

Every value, archive path, selected run, and evidence boundary above is listed
in the [Paper III evidence manifest](../data/paper-iii-manifest.json). The
validator resolves each path as a Git object and compares the featured
coefficients against the corrected committed metadata.

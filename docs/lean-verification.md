---
title: Lean verification
---

# Paper III Lean verification

The canonical package in
[`verification/paper3/lean/`](https://github.com/chenle02/Chemataxis_Numerics/tree/master/verification/paper3/lean)
contains 167 receipt-backed Lean declarations. A pristine Home-Dell rebuild
completed 8,696 jobs under Lean `v4.32.2` and mathlib revision
`905b95818eb32af7874a58b427f50c1711a5e96c`. The live axiom audit accepts only
`propext`, `Classical.choice`, and `Quot.sound`; it rejects `sorryAx`.

This page separates three statuses:

- **Verified** means the stated finite, algebraic, or modewise claim is proved
  in Lean, included in `AxiomCheck.lean`, and bound by the receipt.
- **Partially verified** means a named analytical result has a specified
  algebraic core proved, but the full PDE or functional-analytic assertion is
  not formalized.
- **Not formalized** means no Lean proof is claimed. This does not mean the
  manuscript statement is false.

## Verified statements

| Manuscript statement | Receipt-backed Lean evidence | Exact boundary |
| --- | --- | --- |
| Positive equilibrium, equation (1.4), p. 4, label `E:equilibrium` | `Paper3Thresholds.equilibriumU_pos`, `equilibriumV_pos`, `equilibrium_logistic_residual`, `equilibrium_signal_residual` | Positivity and both constant steady-state residual identities. |
| Linear cosine modes and growth rate, equations (1.5)--(1.7), p. 5, labels `E:main-linear-PE1`, `E:sigma_n`, `E:main-linear-PE2`; Lemma 2.2, p. 11, label `L:eigenvalues` | `Paper3Eigenmodes.hasDerivAt_mode`, `second_deriv_mode`, `mode_neumann_boundary`, `coupled_mode_substitution`, `cosine_mode_linearized_residuals` | Each concrete Neumann cosine eigenpair and its coupled `u`/`v` substitution are proved. No stronger operator-spectrum completeness claim is added. |
| Modal threshold and lower bound, equations (1.8)--(1.9), p. 5, labels `E:chi-star`, `E:chi-star-lower` | `Paper3Thresholds.modeFactor_lower_bound`, `modeFactor_eq_lower_bound`, `modeFactor_zero_isGLB`, `modeThreshold_lower_bound`, `isMinMode_beta_iff`, `modeThreshold_succ_tendsto_atTop`, `exists_minimizing_positive_mode` | Sharp pointwise bound, equality for `a*alpha>0`, the minimal `a=0` greatest-lower-bound endpoint, positivity, divergence, discrete attainment, and beta-independent minimizers. |
| Positivity and beta monotonicity of the crossing coefficient, equations (1.13), p. 7, and (4.2), p. 31, labels `E:alpha-beta-defs`, `E:alpha_n0-minimal` | `Paper3Model.alphaN0_pos`, `alphaN0_strictAnti`, `alphaN0_pos_minimal`, `c2_pos_iff_betaN0_pos`, `c2_neg_iff_betaN0_neg` | Both model classes under primitive parameter positivity; the sign of `c2` follows from the sign of `beta_n0`. |
| Bilinear and trilinear cosine integrals, Lemma 2.3, p. 11, label `L:trig-integrals` | `Paper3TrigFinite.integral_range_bilinear_nat`, `integral_range_trilinear_nat`; `Paper3TrigInfinite.integral_cosineSeries_bilinear`, `integral_cosineSeries_trilinear` | Both finite and `ell^1` displays, all three/seven index families, constant-mode corrections, absolute summability, and integral/series interchanges. |
| Scalar Taylor coefficients, equations (3.2)--(3.3), pp. 13--14, labels `E:local-bifurcation-eq2`, `E:local-bifurcation-eq3` | `Paper3Taylor.sensitivity_weight_derivatives`, `mobility_density_derivatives`, `signal_derivatives`, `logistic_derivatives`, `taylor_factorial_normalization` | Scalar derivatives and factorial coefficients through cubic order; not the function-valued remainder estimates. |
| Positive-mode elliptic solve, equation (3.9), p. 16, label `E:vk=uk` | `Paper3ModalEquation.bilinearMain_self_eq`, `trilinearMain_self_eq`, `elliptic_mode_solution`, `elliptic_mode_denominator_ne_zero` | Exact three/seven-family coefficient sums and the denominator-aware projected solve. |
| Projected modal ODE coefficients, equations (3.14a)--(3.15), pp. 20--21, labels `E:mode-ode-u0`, `E:mode-ode-uk`, `E:Fk-def` | `Paper3ModalODE.average_mode_quadratic_projection`, `positive_mode_quadratic_projection`, `positive_mode_cubic_projection`, `chemotactic_quotient_cancels_of_pos` | Exact zero-mode square collection, normalized `-q2/4` and `-q3/24` positive-mode coefficients, and cancellation of positive sensitivity. |
| Quadratic center-graph coefficients, equations (3.21), (3.26a)--(3.26b), pp. 23--24, labels `E:a_0,i`, `E:a_k,i-zero`, `E:a_k,i>0`; minimal equations (4.9a)--(4.9b), p. 33 | `Paper3CenterJet.coefficients_of_quadratic_jet_residual`, `nonminimal_constant_mode_coefficients`, `nonminimal_second_mode_coefficients`, `minimal_second_mode_coefficients`, `nonminimal_p2_invariance_solution`, `minimal_p2_invariance_solution` | Finite jet residual extraction and nonzero spectral-denominator wrappers; not analytic center-manifold existence. |
| Quadratic forcing and compact cubic chemotactic projection, equations (3.25), (3.29), p. 24, labels `E:Gamma2n0-explicit`, `E:Gamma-n0-explicit`; minimal equations (4.8), p. 32, and (4.11), p. 33 | `Paper3QuadraticProjection.normalized_second_mode_projection`, `nonminimal_chiGamma2_eq_affine`, `minimal_chiGamma2_eq_affine`; `Paper3CubicProjection.normalized_critical_projection`, `nonminimal_Gamma3_eq_projected_compact`, `minimal_Gamma3_eq_projected_compact` | Independent finite harmonic projections and bridges to both raw model definitions. |
| Logistic harmonic and reduced cubic assembly, equations (3.27), (3.31), pp. 24--25, labels `E:S2S3-center`, `E:beta-n0`; minimal equation (4.13), p. 33, label `E:beta-n0-minimal` | `Paper3ReducedAssembly.normalized_quadratic_logistic_projection`, `normalized_cubic_logistic_projection`, `nonminimal_betaRaw_eq_projected_channels`, `minimal_betaRaw_eq_projected_channel` | Exact finite assembly of the projected logistic and chemotactic channels. |
| Quadratic dependence on beta, equation (3.32), p. 26, label `E:beta-quadratic`, and minimal equation (4.13), p. 33 | `Paper3QuadraticABC.beta_quadratic`, `Paper3MinimalABC.betaMin_quadratic`, `Paper3QuadraticABC.regime_classification` | Exact `A*beta^2+B*beta+C` identities. Regime classification is conditional on `A<0<C` and a supplied positive root; concrete parameter signs remain T2 evidence. |
| Cubic scalar normal-form conclusions, equations (3.30), p. 25, and (4.12), p. 33, labels `E:center-ODE-final`, `E:center-ODE-final-minimal` | `Paper3NormalForm.nonzero_equilibrium_branch_side`, `branch_amplitudes`, `nonzero_equilibrium_eq_branch`, `deriv_at_nonzero_equilibrium`, `supercritical_deriv_neg`, `subcritical_deriv_pos` | Exact cubic branch side, two leading roots, uniqueness among nonzero roots, and scalar derivative signs. Remainder perturbation and PDE lifting are excluded. |
| Fixed-mode semidiscrete consistency, Proposition 1.3, p. 9, label `P:semidiscrete-threshold`; equations (6.2)--(6.3), p. 37, labels `E:disc-eigenvalues`, `E:disc-threshold` | `Paper3Semidiscrete.discLam_eq_continuum_mul_sinc_sq`, `discLam_tendsto_continuum`, `modeThreshold_disc_tendsto` | Exact discrete-eigenvalue identity and convergence of each fixed positive mode and its threshold. |
| Discrete/continuum ordering and minimal-model mesh minimum, pp. 37 and 41 | `Paper3DiscreteOrdering.discLam_lt_continuum`, `modeFactor_lt_of_turning_le`, `modeFactor_lt_of_le_turning`; `Paper3Semidiscrete.minimalDiscThreshold_isLeast`, `minimalDiscThreshold_tendsto` | Strict represented-mode eigenvalue underestimate, both threshold-map ordering regimes, exact mode-one minimum in the minimal model, and convergence of those minima. |
| Conservative trapezoidal mass, equation (6.6), p. 41, label `E:main-DIS-conservative`, and the following unnumbered assertion | `Paper3ConservativeMass.flux_difference_telescope`, `conservative_flux_mass_rate_zero`, `conservative_scheme_preserves_trapezoidal_mass` | For arbitrary face fluxes and node rates satisfying (6.6), the half-weighted endpoints and all interior differences cancel exactly. Trajectory existence/differentiability is not asserted. |

## Partially verified named results

| Named result | What Lean verifies | What remains outside the proof package |
| --- | --- | --- |
| Proposition 1.2, p. 5, label `P:review-prop-2` | `Paper3LinearRegime` proves every represented positive-mode growth rate is negative below, zero at, and positive above its modal threshold. | Full semigroup stability/instability and nonlinear PDE consequences. |
| Theorem 1.1, p. 7, label `T:local-bifurcation-1` | Non-minimal Taylor coefficients, modal projections, center-jet coefficients, cubic assembly, branch side, leading amplitudes, and scalar stability signs. | Existence of PDE branches, local uniqueness, Hadamard/implicit-function arguments, remainder control, elliptic regularity, and stability lifting to the PDE. |
| Theorem 1.2, p. 8, label `T:local-bifurcation-2` | The analogous fixed-mass minimal-model finite jet, coefficient assembly, branch side, leading amplitudes, and scalar signs. | Center-manifold existence in the fixed-mass phase space, PDE branch existence/uniqueness, remainder control, and PDE stability lifting. |
| Center-manifold calculations in Sections 3--4 | Independent finite invariance residuals and harmonic projections recover the displayed graph and cubic coefficients. | Existence, smoothness, and invariance of the analytic center manifold itself. |

## Not formalized

| Manuscript statement | Why it is not claimed as Lean-verified |
| --- | --- |
| Proposition 1.1, p. 4, label `P:review-prop-1` | PDE well-posedness and global existence require a substantial parabolic/elliptic estimates library; this paper only reviews the result. |
| Lemma 2.1, p. 10, label `L:center-manifold-reduction` | The general sectorial-operator center-manifold theorem, analytic semigroups, and local semiflow machinery are outside this finite verification package. |
| Full Theorems 1.1 and 1.2, pp. 7--8 | Their finite algebraic cores are listed above, but the complete functional-analytic bifurcation and PDE stability arguments are not formalized. |
| Theorem 1.3, p. 9, label `T:global-bifurcation` | Unilateral global continuation requires infinite-dimensional topology, compactness, and global bifurcation machinery not developed here. |
| Full Proposition 1.2, p. 5 | Only the exact modewise sign algebra is formalized; semigroup-level stability is not. |
| Numerical figures, tables, fitted slopes, residual measurements, and mesh observations | These are empirical T1/T2 artifacts checked by numerical validators and manifests. Lean does not turn floating-point measurements into analytical PDE theorems. |
| Function-valued Taylor remainder estimates and root perturbation by remainders | Lean checks scalar derivatives and the exact cubic polynomial, not the Banach-space remainder bounds, Hadamard lemma, or implicit-function step. |

## Residual trust boundary

Lean checks consequences of the formal definitions. The primitive model
parameters and initial scalar/modal formulas are a transcription of the
manuscript, so fidelity of that initial transcription remains a human-reviewed
seam. The package reduces that seam by independently deriving the finite
harmonic projections, invariance-residual solutions, and reduced coefficient
assembly instead of merely restating the final formulas.

The receipt records source hashes, the toolchain, all dependency revisions,
and the live axiom result. See the
[`lean/README.md`](https://github.com/chenle02/Chemataxis_Numerics/blob/master/verification/paper3/lean/README.md)
for rebuild instructions and detailed theorem mapping.

# Paper III — Lean 4 formal verification (evidence tier T3)

This directory is **self-contained**: the twenty-six tracked files below are sufficient
to rebuild and re-check every theorem from a clean machine. Nothing else is
required from any other repository or from any pre-existing local Lean project.

| File | Role |
| --- | --- |
| `Paper3QuadraticABC.lean` | parameter structure, closed-form `A`, `B`, `C`, and `beta_quadratic` |
| `Paper3Regime.lean` | the `alpha_n0` facts, the regime classification, and the label-gate bridge |
| `Paper3TrigOrtho.lean` | orthogonality of the Neumann cosine modes on `(0,L)` |
| `Paper3Model.lean` | model-agnostic `alpha_n0` layer covering the minimal model too |
| `Paper3MinimalABC.lean` | the minimal model's cubic coefficient, eq. (4.13), is quadratic in `beta` |
| `Paper3Semidiscrete.lean` | fixed-mode convergence of the discrete eigenvalue and threshold in Proposition 1.3 |
| `Paper3Eigenmodes.lean` | Neumann cosine eigenpairs and coupled-mode substitution in Lemma 2.2 |
| `Paper3CenterJet.lean` | independent quadratic invariance residuals and center-graph coefficient extraction |
| `Paper3CubicProjection.lean` | finite mobility-jet collection and normalized cubic chemotactic projection |
| `Paper3QuadraticProjection.lean` | finite `2n0` forcing projection and affine source bridges |
| `Paper3ReducedAssembly.lean` | projected logistic harmonics and full reduced-channel assembly |
| `Paper3TrigFinite.lean` | exact finite nonnegative-index forms of both displays in Lemma 2.3 |
| `Paper3TrigInfinite.lean` | absolute-convergence and integral-interchange layer for Lemma 2.3 |
| `Paper3Thresholds.lean` | equilibrium residuals, sharp threshold bound, beta-independent minimizers, divergence, and minimum attainment |
| `Paper3DiscreteOrdering.lean` | strict discrete eigenvalue inequality and turning-point threshold ordering |
| `Paper3Taylor.lean` | scalar real-power derivatives underlying equations (3.2)--(3.3) |
| `Paper3NormalForm.lean` | exact cubic branch-side, amplitude, uniqueness, and derivative-sign algebra |
| `Paper3ModalEquation.lean` | manuscript-facing three/seven-family bridge and elliptic mode solve for equation (3.9) |
| `Paper3ModalODE.lean` | exact average/positive-mode logistic projections and the sensitivity cancellation in equations (3.14a)--(3.15) |
| `Paper3LinearRegime.lean` | modewise stable/neutral/unstable sign equivalences at the modal threshold |
| `Paper3ConservativeMass.lean` | exact telescoping of the conservative flux under the trapezoidal mass weights |
| `AxiomCheck.lean` | trust gate: `#print axioms` on all 167 theorems |
| `lakefile.toml` | package definition and the mathlib requirement |
| `lean-toolchain` | pinned Lean toolchain |
| `lake-manifest.json` | exact resolved revisions of mathlib and its transitive dependencies |
| `make_receipt.py` | live axiom-audit gate and source/toolchain receipt verifier |

## Pinned environment

- Toolchain: `leanprover/lean4:v4.32.2`
- mathlib: `inputRev = v4.32.2`, resolved to `905b95818eb32af7874a58b427f50c1711a5e96c`
- All transitive dependency revisions are pinned in `lake-manifest.json`

## Rebuild and re-check

Copy the twenty-six tracked files into an empty directory, then:

```bash
lake exe cache get                 # fetch mathlib + prebuilt oleans
lake build                         # defaultTargets; expect 8696 jobs, no errors
lake env lean AxiomCheck.lean > axiom-report.txt
python3 make_receipt.py audit --axiom-output axiom-report.txt
```

Accept the proof **only** if the last command prints, for every one of the 167
theorems, exactly

```
depends on axioms: [propext, Classical.choice, Quot.sound]
```

`sorryAx` in that list means the theorem is not proved. A green `lake build`
with a `sorry` present is not a proof.

To re-verify that the tracked sources still match the recorded receipt:

```bash
python3 make_receipt.py verify
```

### Build route for this project

Per the `lean-single-file-proof-homedell` lab convention, the working route is
Home-Dell (`~/lean-projects/paper3-abc`), editing on Greenwood and shipping with
`scp`. Lean is never built on the Greenwood workstation. `leancheck`/Easley is
the receipt-grade route for full-mathlib certification, but its remote path is
pinned to a different project and cannot build this one.

The "never local Lean" rule is a workstation-safety rule and does **not** apply
to cloud CI runners.

### Self-containment check (2026-08-09)

A fresh directory on Home-Dell containing only the twenty-six tracked files above completed
`lake exe cache get` (rc 0), `lake build` (rc 0, 8696 jobs), and the axiom gate
(rc 0, all 167 theorems clean). Before this, the build harness existed only on
Home-Dell and the proof was not rebuildable from any repository.

## What the theorems certify, and where they land in the manuscript

| Lean theorem | Manuscript object | Location |
| --- | --- | --- |
| `beta_quadratic` | `beta_n0(beta) = A*beta^2 + B*beta + C` with the explicit closed forms | eq. (3.32), label `E:beta-quadratic`, p. 26 |
| `alphaN0_pos` | `alpha_n0 > 0`, the transversality hypothesis | eq. (1.13), label `E:alpha-beta-defs`, p. 7; consumed in the IFT step of `T:local-bifurcation-1` and `T:local-bifurcation-2` |
| `alphaN0_strictAnti` | "`alpha_n0` decreases with `beta`" | asserted in the introduction; **not proved in the paper** |
| `regime_classification` | supercritical on `[0, beta+)`, subcritical on `(beta+, inf)`, `beta+` the unique root in `[0, inf)` | section 3, analysis of `beta_n0(beta)` |
| `c2_pos_iff_betaN0_pos`, `c2_neg_iff_betaN0_neg` | `sign(c2) = sign(beta_n0)` where `c2 = beta_n0/alpha_n0` | section 6; this is the **label gate** used by the numerics |
| `quadratic_factor_of_root`, `cofactor_neg` | internal lemmas; root division avoids the quadratic formula | — |
| `integral_mode_mul_mode` | orthogonality of the Neumann cosine modes on `(0,L)`: the integral is `L` when `m=n=0`, `L/2` when `m=n>0`, and `0` otherwise | the step the proof of `L:trig-integrals` invokes as *"the orthogonality of the Neumann cosine modes on (0,L)"* |
| `integral_cos_linear`, `integral_cos_mode_int` | supporting lemmas: `∫₀^L cos(cx) = sin(cL)/c`, and the integral of a nonzero integer mode over a full period-set vanishes | — |
| `Paper3Model.alphaN0_pos`, `alphaN0_strictAnti` | the same two `alpha_n0` facts, but for **both** model classes, assuming only primitive parameter positivity | eq. (1.13) non-minimal **and** eq. (4.2) minimal |
| `Paper3Model.c2_pos_iff_betaN0_pos`, `c2_neg_iff_betaN0_neg` | the label-gate bridge for both model classes | section 6 |
| `Paper3Model.alphaN0_ofParams` | the non-minimal definition is exactly the specialization of the general one (`rfl`) | — |
| `Paper3Model.alphaN0_pos_minimal` | `alpha_n0 > 0` at any free `u* > 0`, i.e. the minimal model | eq. (4.2); covers the two minimal cases in the public `v1` bundle |
| `Paper3TrigOrtho.integral_triple_modeZ` | the triple-mode integral equals `(L/4)` times four index indicators; the bilinear engine of `L:trig-integrals`, with the `i=j=k=0` indicator being exactly its `1_{k=0}u0v0` correction | Lemma 2.3, first display |
| `Paper3TrigOrtho.integral_finset_bilinear` | the lemma's first display for finitely-supported coefficient sequences | Lemma 2.3, first display (finite-support case) |
| `Paper3MinimalABC.betaMin_quadratic` | the minimal model's `beta_n0` is exactly `A b^2 + B b + C`; with `regime_classification` this gives the minimal model its supercritical/subcritical classification | eq. (4.13) |
| `Paper3Model.kap_pos`, `one_lt_w` | `kappa > 0` and `w > 1` **derived** from primitive positivity rather than assumed | — |
| `Paper3Semidiscrete.discLam_eq_continuum_mul_sinc_sq` | exact rewriting of the discrete eigenvalue as its continuum value times a sinc correction | eq. (6.2), label `E:disc-eigenvalues`, p. 37 |
| `Paper3Semidiscrete.discArg_tendsto_zero`, `discLam_tendsto_continuum` | the discrete eigenvalue of every fixed positive mode converges to the continuum eigenvalue | Proposition 1.3, label `P:semidiscrete-threshold`, p. 9 |
| `Paper3Semidiscrete.modeThreshold_disc_tendsto` | continuity transfers that limit through the fixed-mode threshold formula | Proposition 1.3, label `P:semidiscrete-threshold`, p. 9; threshold formula in eq. (6.3), label `E:disc-threshold`, p. 37 |
| `Paper3Semidiscrete.minimalDiscThreshold_isLeast`, `minimalDiscThreshold_tendsto` | mode one is the exact finite-mesh minimum in the minimal model, and these minima converge to the continuum minimum | unnumbered assertion in the minimal discretization discussion, p. 41; equations (1.8), (6.3), labels `E:chi-star`, `E:disc-threshold`, pp. 5 and 37 |
| `Paper3Eigenmodes.hasDerivAt_mode`, `second_deriv_mode`, `mode_neumann_boundary` | the cosine modes satisfy `-phi''=lambda_n phi` and both Neumann boundary conditions | Lemma 2.2, label `L:eigenvalues`, p. 11 |
| `Paper3Eigenmodes.coupled_mode_substitution`, `cosine_mode_linearized_residuals` | substituting the coupled `u`/`v` cosine mode into both linearized equations yields the growth rate `sigma_n` | equations (1.5)--(1.7), labels `E:main-linear-PE1`, `E:sigma_n`, `E:main-linear-PE2`, p. 5; Lemma 2.2, p. 11 |
| `Paper3CenterJet.coefficients_of_quadratic_jet_residual` and three model corollaries | an independently stated degree-two invariance residual forces the constant and `2n0` center-graph coefficients and kills the other two jet coefficients | equations (3.21), (3.26a)--(3.26b), pp. 23--24; minimal equations (4.9a)--(4.9b), p. 33 |
| `Paper3CenterJet.nonminimal_a01_residual`, `nonminimal_p2_invariance_solution`, `minimal_p2_invariance_solution` | the definitions consumed by the cubic files solve those independent residual equations under nonzero denominators | same center-graph equations; this closes coefficient extraction, not the modal forcing projection |
| `Paper3CenterJet.betaMin_quadratic_of_simple_mode` | manuscript-facing minimal quadratic identity carrying the nonzero `sigma_2n0` side condition | equation (4.13), label `E:beta-n0-minimal`, p. 33 |
| `Paper3CubicProjection.mobility_quadratic_collection`, `cubicFlux_decomposition`, `neg_deriv_cubicFlux` | collection of the finite center-graph mobility jet and its first/third harmonic cubic flux decomposition | equation (3.29), label `E:Gamma-n0-explicit`, p. 24; minimal equation (4.11), label `E:Gamma-n0-explicit-minimal`, p. 33 |
| `Paper3CubicProjection.normalized_critical_projection` | normalized projection kills the third harmonic and leaves exactly `kappa^2` times the compact bracket | same two compact cubic formulas |
| `Paper3CubicProjection.nonminimal_Gamma3_eq_projected_compact`, `minimal_Gamma3_eq_projected_compact` | both existing raw `Gamma3` definitions equal the independently projected compact formula | equations (3.29) and (4.11) above |
| `Paper3QuadraticProjection.quadraticFlux_decomposition`, `normalized_second_mode_projection` | the `0+2` and `1+1` flux channels project to the explicit quadratic forcing bracket | equation (3.25), label `E:Gamma2n0-explicit`, p. 24; minimal equation (4.8), label `E:Gamma2n0-explicit-minimal`, p. 32 |
| `Paper3QuadraticProjection.nonminimal_chiGamma2_eq_affine`, `minimal_chiGamma2_eq_affine` | multiplying the projected forcing by the threshold gives exactly `D0+D1*beta`, the source used by the graph coefficients | same quadratic forcing chain in both models |
| `Paper3ReducedAssembly.normalized_quadratic_logistic_projection`, `normalized_cubic_logistic_projection` | the center-graph logistic projections recover the factors `2p0+p2` and `3/4`, equivalently the manuscript's `4p0+2p2` and `3` conventions | equation (3.27), label `E:S2S3-center`, p. 24 |
| `Paper3ReducedAssembly.nonminimal_betaRaw_eq_projected_channels`, `minimal_betaRaw_eq_projected_channel` | the raw reduced cubic coefficients equal the independently projected logistic and chemotactic channel assembly | equation (3.31), label `E:beta-n0`, p. 25; minimal equation (4.13), label `E:beta-n0-minimal`, p. 33 |
| `Paper3TrigFinite.integral_range_bilinear_nat`, `integral_range_trilinear_nat` | exact finite-truncation versions of the lemma's two displays, with the three/seven nonnegative index families and separated constant-mode corrections | Lemma 2.3, label `L:trig-integrals`, p. 11 |
| `Paper3TrigInfinite.integral_cosineSeries_bilinear` | the first display for `ell^1` coefficients, including absolute summability, product-series collection, integral/`tsum` interchange, and the separated correction | Lemma 2.3, label `L:trig-integrals`, p. 11, first display |
| `Paper3TrigInfinite.integral_cosineSeries_trilinear` | the second display for `ell^1` coefficients, including the triple product series, integral/`tsum` interchange, all seven index families, and the separated correction | Lemma 2.3, label `L:trig-integrals`, p. 11, second display |
| `Paper3Thresholds.equilibrium_logistic_residual`, `equilibrium_signal_residual` | the displayed positive equilibrium solves both constant steady-state equations | equation (1.4), label `E:equilibrium`, p. 4 |
| `Paper3Thresholds.modeFactor_lower_bound`, `modeFactor_eq_lower_bound`, `modeThreshold_lower_bound` | the sharp pointwise AM--GM estimate underlying the continuous threshold lower bound | equation (1.9), label `E:chi-star-lower`, p. 5 |
| `Paper3Thresholds.modeFactor_zero_isGLB` | in the minimal case, `mu` is the exact continuous infimum of the modal factor over positive eigenvalues | equation (1.9), label `E:chi-star-lower`, p. 5, endpoint `a=0` |
| `Paper3Thresholds.isMinMode_beta_iff`, `modeThreshold_succ_tendsto_atTop`, `exists_minimizing_positive_mode` | beta-independence of minimizing modes, divergence of positive-mode thresholds, and discrete minimum attainment | equation (1.8), label `E:chi-star`, p. 5 |
| `Paper3DiscreteOrdering.discLam_lt_continuum`, `modeFactor_lt_of_turning_le`, `modeFactor_lt_of_le_turning` | strict discrete eigenvalue underestimate and both threshold-map ordering regimes | equations (6.2)--(6.3), labels `E:disc-eigenvalues` and `E:disc-threshold`, p. 37 |
| `Paper3Taylor.sensitivity_weight_derivatives`, `mobility_density_derivatives`, `signal_derivatives`, `logistic_derivatives` | all scalar derivative coefficients through cubic order | equations (3.2)--(3.3), labels `E:local-bifurcation-eq2` and `E:local-bifurcation-eq3`, pp. 13--14 |
| `Paper3NormalForm.nonzero_equilibrium_branch_side`, `branch_amplitudes`, `deriv_at_nonzero_equilibrium`, `supercritical_deriv_neg`, `subcritical_deriv_pos` | exact cubic branch side, leading amplitudes, two-root uniqueness, and scalar stability signs | equations (3.30), (4.12), labels `E:center-ODE-final` and `E:center-ODE-final-minimal`, pp. 25 and 33 |
| `Paper3ModalEquation.bilinearMain_self_eq`, `trilinearMain_self_eq`, `elliptic_mode_solution` | exact three/seven-family indicator sums and denominator-aware solution of the projected elliptic residual | equation (3.9), label `E:vk=uk`, p. 16 |
| `Paper3ModalODE.average_mode_quadratic_projection`, `positive_mode_quadratic_projection`, `positive_mode_cubic_projection`, `chemotactic_quotient_cancels_of_pos` | exact constant-mode square collection, normalized `-q2/4` and `-q3/24` positive-mode coefficients, and cancellation of the common positive sensitivity | equations (3.14a)--(3.15), labels `E:mode-ode-u0`, `E:mode-ode-uk`, and `E:Fk-def`, pp. 20--21 |
| `Paper3LinearRegime.modalGrowth_neg_iff`, `modalGrowth_eq_zero_iff`, `modalGrowth_pos_iff` | a positive mode is damped below, neutral at, and growing above its modal sensitivity threshold | Proposition 1.2, label `P:review-prop-2`, p. 5; equations (1.6), (1.8), labels `E:sigma_n` and `E:chi-star`, p. 5 |
| `Paper3ConservativeMass.flux_difference_telescope`, `conservative_flux_mass_rate_zero`, `conservative_scheme_preserves_trapezoidal_mass` | the half-weighted endpoint rates and all interior flux differences cancel exactly for arbitrary face fluxes | equation (6.6), label `E:main-DIS-conservative`, p. 41, and the following unnumbered mass-conservation assertion |

The label-gate bridge is the load-bearing one for the numerical companion. Every
published stationary case compares `sign(measured c2)` against
`sign(closed-form beta_n0)`. That comparison is legitimate precisely because
`alpha_n0 > 0`, which is `alphaN0_pos`.

## Claim boundaries — what is deliberately NOT certified

These limits must be preserved in any public wording.

0. **Model coverage is split, and the split matters.**

   `Paper3QuadraticABC` and `Paper3Regime` are **non-minimal only** (`a, b > 0`):
   they define `us = (a/b)^(1/alpha)`, so instantiating them at `a = b = 0`
   yields `us = 0`, hence `kap = 0`, hence the hypothesis `0 < kap p` is
   unsatisfiable and those theorems are *inapplicable* (not false) there.

   `Paper3Model` removes that restriction for the `alpha_n0` layer: it carries
   `u*` as data, so `alphaN0_pos`, `alphaN0_strictAnti` and the label-gate
   bridge hold for **both** model classes, assuming only positivity of the
   primitive parameters (`u*, nu, gamma, mu, L, n0`), from which positivity of
   `kap` and `w > 1` are *derived* rather than assumed. `alphaN0_ofParams`
   proves by `rfl` that the non-minimal definition is the specialization, so
   this is an extension of the existing result, not a parallel unchecked copy.

   Consequence for published evidence: the two minimal cases among the four
   `validated_current` stationary cases in the public `v1` bundle
   (`(m,gamma) = (1,1)` and `(m,gamma) = (2,2)`) rely on `alpha_n0 > 0` for
   their label gate, and that fact **is now machine-checked** for them
   (`alphaN0_pos_minimal`).

   `Paper3MinimalABC` closes the remaining half: it proves that the minimal
   model's *cubic* coefficient is itself exactly quadratic in `beta`
   (`betaMin_quadratic`), where by eq. (4.13) that coefficient is
   `-chi* * Gamma^(3)` with `a_{0,1} = 0` and `b = 0`. Because
   `Paper3Regime.regime_classification` is pure algebra about `A b^2 + B b + C`,
   it then applies verbatim to the minimal coefficients, so the minimal model
   now has the same supercritical/subcritical classification as the non-minimal
   one.

   Net position for the minimal model: `alpha_n0 > 0`, strict monotonicity in
   `beta`, the label-gate bridge, the quadratic form of `beta_n0`, and the
   regime classification are all machine-checked. What is *not* machine-checked
   is that these transcriptions match the manuscript — see boundary 4, which
   applies to both model classes.

   Mitigation specific to the minimal file: it was obtained by specializing the
   non-minimal development, so the dominant risk is a *mis*-specialization
   (dropping or keeping the wrong term). `check_minimal_against_symbolic.py`
   guards exactly that, comparing its `A, B, C` against
   `chemotaxis_symbolic.bifurcation.minimal_1d`, a separately written module,
   over 24 parameter/`beta` combinations including both published minimal cases;
   worst relative difference `2.4e-15`. That is a genuine check of the
   specialization, and it is still not a check against the manuscript.
1. `alphaN0_pos` is proved **under** the hypotheses `0 < kap p`, `0 < w p`,
   `0 < lam p n0`, `0 < p.mu`. These are natural parameter-positivity
   assumptions; they are assumed, not derived from the model.
2. `alphaN0_strictAnti` additionally requires `1 < w p`, that is `v* > 0`.
3. `regime_classification` is **pure algebra**: it assumes `A < 0 < C` and the
   existence of a positive root `beta+`. It does **not** prove that
   `A < 0 < C` holds for any particular parameter family, and it does **not**
   prove that `beta+` exists. Establishing those signs for concrete families is
   tier-T2 (symbolic/numeric) work, not T3.
4. The primitive model parameters and the initial scalar Taylor/modal data are
   a **transcription** of the manuscript. Lean independently derives the finite
   harmonic projections, center-jet residual solutions, and final coefficient
   assemblies from those inputs, but fidelity of the primitive transcription
   remains human-checked and is the residual trust seam.
5. **`L:trig-integrals` is fully formalized.** The orthogonality engine, the
   exact finite-truncation versions of both displays, and both full `ell^1`
   displays are proved.
   `integral_range_bilinear_nat` collects the three nonnegative index families
   and constant correction; `integral_range_trilinear_nat` does the same for
   all seven families in the four-mode display.
   `integral_cosineSeries_bilinear` and
   `integral_cosineSeries_trilinear` prove the absolute-convergence and
   integral/`tsum` interchange passages under the manuscript's `ell^1`
   hypotheses.
6. Proposition 1.3 is checked only for each **fixed positive mode**, exactly as
   stated. The Lean theorem does not claim convergence of a minimum over a
   mode set that changes with the mesh size.
7. Lemma 2.2 is checked as the concrete mode calculation stated in its proof:
   cosine derivatives, boundary data, elliptic-mode elimination, and the
   resulting growth rate. The formalization does not construct the Neumann
   Laplacian as an unbounded operator or prove completeness of its spectrum.
8. The quadratic center-graph **coefficient extraction** is now checked from an
   independently stated jet residual, including nonzero spectral denominators.
   The compact **cubic** chemotactic formula is now independently derived from
   the finite mobility/signal jet and bridged to both raw `Gamma3` definitions.
   The separate quadratic `2n0` forcing projection and its affine source bridge
   are now checked as well. The analytic existence of the center manifold is
   still outside this finite-jet claim.
   The final finite reduced coefficient assembly is also checked from projected
   quadratic/cubic logistic harmonics and the certified chemotactic channel.
9. The continuous-infimum equality in equation (1.9) is realized directly in
   Lean when `a*alpha > 0` and `mu > 0`. In the minimal case `a=0`, Lean proves
   that `mu` is the greatest lower bound over positive continuous eigenvalues.
10. The Taylor layer certifies the scalar derivatives and factorial
   coefficients, not the function-valued fourth-order remainder bounds.
11. The normal-form layer certifies the exact cubic leading polynomial. It
   does not formalize Hadamard's lemma, the implicit function theorem, the
   perturbation of the roots by the displayed remainder, or stability lifting
   from the center equation to the PDE.
12. The modewise stable/neutral/unstable sign algebra underlying Proposition
   1.2 is formalized. The full semigroup stability proposition and the PDE
   results (`T:local-bifurcation-1`, `T:local-bifurcation-2`,
   `T:global-bifurcation`) are **not** formalized and are out of scope: they
   require Crandall--Rabinowitz, center-manifold reduction, analytic semigroups,
   and unilateral global continuation.
13. No numerical measurement is formalized; measurements are tiers T1/T2 by
   construction.
14. The conservative-mass layer proves the exact finite rate identity for an
   arbitrary face-flux sequence and any node-rate vector satisfying equation
   (6.6). It does not assert existence or differentiability of a semidiscrete
   trajectory; linearity of differentiation is the analytical bridge from a
   differentiable trajectory to this rate identity.

## Owner-ratified publication-location design (2026-08-09)

The owner selected `chenle02/Chemataxis_Numerics` as the final canonical home.
The receipt-backed sources will live in its separately licensed
`verification/paper3/lean/` subtree, beside a statement-level coverage ledger
and reproducibility instructions. The simulator remains canonical for Python
simulation logic, not for the Lean proof source. The copy in this manuscript
repository is retained as a hash-pinned vendor snapshot; after publication it
must not diverge from the canonical data-repository subtree.

## Ready-to-paste block for the manuscript

The manuscript's "Data and code availability" section contains the integrated
version of this wording. The block below is retained as the auditable source
for future revisions.

Checked against the manuscript on 2026-08-09 so it can be pasted without
surprises:

- `\eqref{E:beta-quadratic}` resolves — equation (3.32), p. 26;
- `\ref{L:trig-integrals}` resolves — Lemma 2.3, p. 11;
- `\ref{L:eigenvalues}` resolves — Lemma 2.2, p. 11;
- `\ref{P:semidiscrete-threshold}` resolves — Proposition 1.3, p. 9;
- `\operatorname` is available (`amsmath` is loaded at line 2);
- all references are by label, not hardcoded number, so they survive renumbering.

A compile gate is still required after pasting, per repo convention.

```latex
The closed-form cubic coefficient and the regime classification are also
machine-checked in Lean~4. The formalization is tracked in \texttt{codes/lean/}
and pins toolchain \texttt{leanprover/lean4:v4.32.2} with \texttt{mathlib}
revision \texttt{905b9581}. It proves that $\beta_{n_0}(\beta)$ is exactly the
quadratic $A\beta^2+B\beta+C$ with the closed forms stated in
\eqref{E:beta-quadratic}, that $\alpha_{n_0}>0$ and is strictly decreasing in
$\beta$, that the quadratic is positive on $[0,\beta^+)$ and negative on
$(\beta^+,\infty)$ with $\beta^+$ its unique nonnegative root, and consequently
that $\operatorname{sign}(c_2)=\operatorname{sign}(\beta_{n_0})$, which is the
criterion used for the numerical regime labels. Lemma~\ref{L:trig-integrals}
is machine-checked in full, including both $\ell^1$ series, their three and
seven index families, and the integral/series interchanges. For every fixed positive mode, the discrete eigenvalue
and threshold in Proposition~\ref{P:semidiscrete-threshold} are proved to
converge to their continuum counterparts. The concrete Neumann cosine eigenmode
calculation in Lemma~\ref{L:eigenvalues} and its substitution into the coupled
linearized equations are checked as well. The quadratic center-graph
coefficients are extracted from independent invariance residuals, with the
compact cubic chemotactic formula independently derived by finite harmonic
projection. The quadratic `2n_0` forcing and its affine center-jet source are
independently projected as well. The projected logistic harmonics are assembled
with those chemotactic channels to recover both raw reduced cubic coefficients.
The positive-equilibrium identities, the sharp modal-threshold lower bound,
threshold positivity and divergence, discrete minimum attainment, and the
beta-independence of minimizing modes are checked as well. The strict discrete
eigenvalue underestimate and both turning-point threshold-ordering directions
are also proved. The scalar Taylor coefficients through cubic order and the
exact cubic normal-form branch and stability-sign algebra are checked as well.
The final three/seven-family solve for the positive elliptic modes in
equation (3.9), the normalized positive-mode logistic coefficients in equation
(3.14b), the exact quadratic average-mode collection in equation (3.14a), and
the nonzero sensitivity cancellation in equation (3.15) are checked too. The
modewise growth rate is also proved negative below, zero at, and positive above
its sensitivity threshold. The minimal-model finite-mesh minimum and its
continuum limit, including the `a=0` continuous-infimum endpoint, are also
proved. The conservative semidiscrete flux is also proved to preserve the
trapezoidal mass by exact finite telescoping. All 167 theorems
depend only on the axioms
\texttt{propext}, \texttt{Classical.choice}, and \texttt{Quot.sound}.
```

Claim boundaries 0--14 above should be respected if this wording is shortened.
The `ell^1` hypotheses above are represented as summability of the absolute
values of the real coefficient sequences.

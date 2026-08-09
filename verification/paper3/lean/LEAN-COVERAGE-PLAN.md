# Paper III Lean coverage plan

Date frozen: 2026-08-09

## Gate verdict

**REFRAME -- proceed as a formal-verification artifact, not as a theorem-novelty
claim.** The exact mathematical source is the current Paper III manuscript.
Kurt--Shen--Xue is the closest source for the center-manifold calculation, while
the Neumann cosine identities and finite-difference limits are classical.
Nothing in this lane is presented as new mathematics merely because Lean checks
it.

Sources checked before this wave:

- `04-02-2026-CRS-3.tex` and its refreshed `.aux`;
- the formal-verification scope in the deterministic-chemotaxis wiki project;
- `Kurt_Wenxian_arXiv/Kurt-Shen-Xue-revised-version-Arxiv.tex`;
- `codes/lean/*.lean`, `AxiomCheck.lean`, and `lean-receipt.json`;
- pinned mathlib v4.32.2 source on Home-Dell, including `Real.sinc` and
  `Real.continuous_sinc`.

The existing formalization is a new checkable artifact. Its residual trust seam
is the transcription from the manuscript into Lean definitions.

## Definition of complete

Every item classified **T3 feasible** below must end in one of two states:

1. `PROVED`: built on the pinned toolchain, included in `AxiomCheck.lean`, and
   bound by the generated receipt; or
2. `BLOCKED WITH WITNESS`: an exact missing mathlib theorem or a reduction to an
   excluded analytic framework is recorded, rather than silently omitted.

The main center-manifold and global-bifurcation theorems are not T3-feasible in
the current mathlib ecosystem and are explicit exclusions, not unfinished Lean
work.

## Coverage matrix

| Manuscript object | Current status | Target |
| --- | --- | --- |
| Equation (3.32), `E:beta-quadratic` | PROVED | Preserve raw-to-collected quadratic identity |
| Equations (1.13), (4.2), alpha positivity and strict decrease in beta | PROVED for both model classes | Preserve primitive-parameter versions |
| Sign of continuation slope and quadratic regime classification | PROVED, conditional on `A < 0 < C` and a positive root | Preserve conditional claim boundary |
| Equation (4.13), minimal cubic coefficient quadratic in beta | PROVED | Preserve minimal-model specialization cross-check |
| Lemma 2.3, `L:trig-integrals` | PROVED IN WAVES 3E--3G; receipt-backed | Both ell-one displays, all three/seven index families, and both constant-mode corrections are proved with the integral/tsum interchanges |
| Proposition 1.3, `P:semidiscrete-threshold` | PROVED IN WAVE 1; receipt-backed | Fixed-mode discrete eigenvalue convergence and transfer through the threshold formula |
| Minimal-model finite-mesh minimum convergence, p. 41 | PROVED IN WAVE 10; receipt-backed | Mode one is the exact minimum on every represented mesh and those minima converge to the continuum minimum |
| Conservative trapezoidal mass after equation (6.6), `E:main-DIS-conservative` | PROVED IN WAVE 11; receipt-backed | For arbitrary face fluxes, the half-weighted endpoint rates and every interior flux difference cancel exactly; trajectory existence/differentiability is not asserted |
| Lemma 2.2, `L:eigenvalues` | PROVED IN WAVE 2; receipt-backed | Cosine-mode eigenpair identities and coupled-mode substitution; no claim of full operator-spectrum completeness |
| Equations (3.21), (3.26), center-graph coefficients | PROVED IN WAVES 3A--3D; receipt-backed | Quadratic jet residual extraction, both model specializations, finite modal forcing, and reduced assembly are proved |
| Equations (3.29), (4.11), compact cubic chemotactic projection | PROVED IN WAVE 3B; receipt-backed | Independent mobility collection, harmonic decomposition, differentiation, normalized projection, and raw-definition bridges for both models |
| Equations (3.25), (4.8), quadratic `2n0` forcing | PROVED IN WAVE 3C; receipt-backed | Independent `0+2`/`1+1` flux projection and exact affine `D0+D1 beta` bridges for both models |
| Equations (3.27), (3.31), (4.13), reduced cubic assembly | PROVED IN WAVE 3D; receipt-backed | Independent logistic harmonic projections and full channel bridges to both raw reduced coefficients |
| Equilibrium, modal threshold, and threshold lower bound, equations (1.4), (1.8), (1.9) | PROVED IN WAVE 4; receipt-backed | Equilibrium positivity/residuals, sharp pointwise lower bound, beta-independent minimizers, threshold positivity/divergence, and minimum attainment are proved |
| Minimal continuous infimum in equation (1.9) | PROVED IN WAVE 10; receipt-backed | For `a=0`, `mu` is proved to be the greatest lower bound over positive continuous eigenvalues |
| Proposition 1.2 modewise sign algebra | PROVED IN WAVE 9; receipt-backed | Each positive-mode growth rate is negative below, zero at, and positive above its modal threshold; semigroup and nonlinear PDE stability remain analytical |
| Discrete eigenvalue formula and threshold-ordering remarks, equations (6.2), (6.3) | PROVED IN WAVES 1 AND 5; receipt-backed | Exact mode identity, strict fixed-mode inequality, turning-point ordering, and same-mode threshold directions are proved |
| Scalar Taylor coefficients, equations (3.2), (3.3) | PROVED IN WAVE 6; receipt-backed | Zeroth-through-cubic real-power derivatives and all mobility, sensitivity, signal, and logistic coefficient signs/factors are proved; function-valued remainders remain analytic |
| Scalar normal-form endgame, equations (3.30), (4.12) | PROVED IN WAVE 6 at the exact cubic algebra layer; receipt-backed | Branch side, two leading amplitudes, nonzero-root uniqueness, and scalar derivative signs are proved; Hadamard/IFT/remainder and PDE lifting remain analytic |
| Elliptic modal coefficient, equation (3.9) | PROVED IN WAVE 7; receipt-backed | Three/seven-family sums are bridged from the `L/4` and `L/8` integral forms, and the projected residual is solved under a denominator derived nonzero from positivity |
| Projected modal ODE coefficients, equations (3.14a)--(3.15) | PROVED IN WAVES 8--9 at the algebraic projection layer; receipt-backed | The zero-mode square sum is collected exactly, the positive-mode projections normalize to `-q2/4` and `-q3/24`, and the common positive sensitivity is proved to cancel; time differentiation and Taylor remainders remain analytic |
| Concrete numerical measurements and fitted slopes | NOT T3 | Remain T1/T2 evidence; Lean may certify exact label logic but not measurements |
| Theorems 1.1, 1.2, 1.3 and Lemma 2.1 | OUT OF SCOPE | Require center manifolds, analytic semigroups, elliptic regularity, and unilateral global bifurcation absent from mathlib |

An independent skeptical audit confirmed that the old twenty-four-theorem
receipt completed only its declared algebra tier. Waves 3A--3G closed the two
largest gaps identified there: the manuscript-facing finite and infinite
versions of Lemma 2.3, and the independent center-graph projection chain behind
the existing `Gamma3`/`betaRaw` definitions.

## Wave 1 frozen theorem

For fixed `L > 0` and fixed positive natural mode `n`, define

```text
h_N = L / N,
lambdaDisc_N = 4 / h_N^2 * sin(n*pi/(2*N))^2.
```

The Lean theorem will prove, along natural `N -> infinity`,

```text
lambdaDisc_N -> (n*pi/L)^2.
```

For positive parameters and the fixed-mode threshold map

```text
T(lambda) = K * (lambda + a*alpha) * (mu + lambda) / lambda,
```

it will then prove

```text
T(lambdaDisc_N) -> T((n*pi/L)^2).
```

This is exactly the assertion of Proposition 1.3. Wave 1 alone did not assert
convergence of the minimum over a mode set that changes with `N`; Wave 10 adds
that stronger conclusion for the minimal model, where the minimum is mode one.

Wave 1 passed a pristine-directory `lake exe cache get`, the full 8666-job
build, and the axiom audit on Home-Dell. The generated receipt binds all 28
theorems and 10 tracked files; every theorem uses only `propext`,
`Classical.choice`, and `Quot.sound`.

Wave 2 passed the corresponding pristine-directory 8668-job build and axiom
audit. The receipt now binds 33 theorems and 11 tracked files. It proves the
concrete cosine eigenpair and coupled-mode substitution used in Lemma 2.2, not
spectral completeness of the Neumann Laplacian.

Wave 3A passed a pristine-directory 8670-job build and axiom audit. The receipt
now binds 41 theorems and 12 tracked files. It independently extracts the three
quadratic graph coefficients from a vanishing jet residual, proves the current
non-minimal and minimal definitions solve those residuals, and adds a minimal
quadratic wrapper carrying `sigma_2n0 != 0`. The modal projection that produces
the forcing constants and the cubic compact formula remain open Wave 3 work.

Wave 3B passed a pristine-directory 8672-job build and axiom audit. The receipt
now binds 50 theorems and 13 tracked files. It derives the compact cubic
chemotactic coefficient from the finite mobility/signal jet, removes the third
harmonic by an actual normalized Neumann projection, and proves both raw
`Gamma3` definitions equal that independently projected formula. The quadratic
`Gamma_2n0` forcing projection and final reduced-coefficient assembly remain.

Wave 3C passed a pristine-directory 8674-job build and axiom audit. The receipt
now binds 56 theorems and 14 tracked files. It derives the quadratic `2n0`
forcing from the `0+2` and `1+1` flux channels and proves, for both model
classes, that threshold times forcing is exactly the affine `D0+D1*beta`
source used by the center-jet invariance equations.

Wave 3D passed a pristine-directory 8676-job build and axiom audit. The receipt
now binds 63 theorems and 15 tracked files. It independently projects the
quadratic and cubic logistic harmonics and assembles them with the certified
chemotactic channel, recovering both raw reduced cubic coefficients.

Wave 3E passed a pristine-directory 8678-job build and axiom audit. The receipt
now binds 72 theorems and 16 tracked files. It proves the exact
finite-truncation forms of both displays in Lemma 2.3, including the
nonnegative three- and seven-index families and the separated constant-mode
correction.

Wave 3F passed a pristine-directory 8680-job build and axiom audit. The receipt
now binds 82 theorems and 17 tracked files. It proves the full `ell^1` bilinear
display in Lemma 2.3: absolute summability, multiplication of the two cosine
series, interval-integral/`tsum` interchange, all three index families, and the
separated constant-mode correction.

Wave 3G passed a pristine-directory 8680-job build and axiom audit. The receipt
now binds 89 theorems and 17 tracked files. It proves the full `ell^1`
trilinear display in Lemma 2.3: multiplication of three absolutely convergent
cosine series, the triple-index interval-integral/`tsum` interchange, all seven
index families, and the separated constant-mode correction.

Wave 4 passed a pristine-directory 8682-job build and axiom audit. The receipt
now binds 109 theorems and 18 tracked files. It proves the positivity and
steady-state residual identities for equation (1.4), the sharp pointwise
AM--GM estimate behind equation (1.9), positivity and divergence of the
positive-mode thresholds, attainment of their discrete minimum, and the fact
that the common positive beta-dependent factor cannot change a minimizing
mode in equation (1.8).

Wave 5 passed a pristine-directory 8684-job build and axiom audit. The receipt
now binds 116 theorems and 19 tracked files. It proves the strict inequality
between each represented positive discrete eigenvalue and its continuum
counterpart, the two strict turning-point orderings of the modal threshold map,
and the resulting same-mode discrete/continuum threshold directions stated in
the remark following equation (6.3).

Wave 6 passed a pristine-directory 8688-job build and axiom audit. The receipt
now binds 133 theorems and 21 tracked files. It proves the real-power
derivatives producing every scalar coefficient through cubic order in
equations (3.2)--(3.3), and the exact cubic normal-form branch-side,
leading-amplitude, uniqueness, and scalar stability-sign algebra used in both
Step 5 arguments. Function-valued Taylor remainders, Hadamard's lemma, the
implicit function theorem, and lifting scalar stability to the PDE remain
explicit analytic boundaries.

Wave 7 passed a pristine-directory 8690-job build and axiom audit. The receipt
now binds 137 theorems and 22 tracked files. It closes the manuscript-facing
equation (3.9) bridge: the three- and seven-family indicator sums are matched
to the certified bilinear/trilinear integral summands, and the projected
elliptic residual is solved with an explicit denominator that follows from the
manuscript's spectral positivity assumptions.

Wave 8 passed a pristine-directory 8692-job build and axiom audit. The receipt
now binds 143 theorems and 23 tracked files. It converts the certified infinite
bilinear and trilinear cosine projections into the exact normalized
`-q2/4` and `-q3/24` positive-mode coefficients in equation (3.14b), and it
proves the nonzero sensitivity cancellation used in equation (3.15).

Wave 9 passed a pristine-directory 8694-job build and axiom audit. The receipt
now binds 156 theorems and 24 tracked files. It factors every represented
positive-mode growth rate as a positive multiplier times sensitivity minus
the mode threshold, proving the stable, neutral, and unstable sign regimes
underlying Proposition 1.2 without claiming semigroup stability. The final
scope audit also collects the constant-mode quadratic projection into exactly
the square sum displayed in equation (3.14a).

Wave 10 passed a pristine-directory 8694-job build and axiom audit. The receipt
now binds 164 theorems and 24 tracked files. It proves the minimal-model
finite-mesh threshold is minimized by mode one and that these exact minima
converge to the continuum minimum. It also closes the `a=0` endpoint of the
continuous-infimum equality in equation (1.9) by proving that `mu` is the
greatest lower bound over positive continuous eigenvalues.

Wave 11 passed a pristine-directory 8696-job build and axiom audit. The receipt
now binds 167 theorems and 26 tracked files, including the receipt verifier
itself. It proves the exact finite
telescoping assertion after equation (6.6): the half-weighted endpoint rates
and the interior conservative flux differences give zero trapezoidal mass
rate for arbitrary face fluxes.

## Trust and execution gates

- Never run Lean on Greenwood.
- Iterate in `~/lean-projects/paper3-abc` on Home-Dell using the warm pinned
  cache.
- Accept a theorem only after `#print axioms` contains no `sorryAx`.
- Regenerate `lean-receipt.json` only from the real axiom-audit transcript.
- Keep manuscript wording at the exact claim boundary proved.

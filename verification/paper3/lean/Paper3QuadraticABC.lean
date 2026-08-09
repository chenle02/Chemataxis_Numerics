/-
# Paper III — Lean 4 verification sketch for the closed-form A, B, C

Target identity (manuscript `04-02-2026-CRS-3.tex`, subsection
"Analysis of β_{n₀}(β)"): with everything defined as below (exactly mirroring
`codes/verify_paper3_quadratic_abc.py`, which matches the canonical symbolic
package to 7e-16 on ten parameter families), the assembled cubic coefficient
is exactly quadratic in the sensitivity exponent, i.e. for all real β,

  betaAssembled β = A β^2 + B β + C

where `betaAssembled` is the logistic + chemotaxis combination
`c1 * (4*a01 + 2*a2n1 β) - chiStar β * Gamma3 β + c3`.

Proof strategy (to be run on Easley via `leancheck`; NEVER locally — see the
`heavy-compute-via-bg-run-and-leancheck` lab rule):

1. `simp only` the `let`-free definitions below (all plain real algebra).
2. The only transcendental-looking factor is `(1+v*)^β`; every occurrence
   cancels against a `(1+v*)^{-kβ}` weight of the mobility coefficients.
   Formalize this by setting `w := 1 + v*` and using `Real.rpow` laws
   `w^β * w^(-β) = 1` (needs `0 < w`, which follows from `v* > 0`).
3. After cancellation the identity is a polynomial identity in β with
   rational-function coefficients in the remaining parameters; close with
   `field_simp` (side conditions: `σ₂ ≠ 0`, `w ≠ 0`,
   `a - (1+α)b(u*)^α ≠ 0`, `μ + λ₁ ≠ 0`, `μ + λ₂ ≠ 0`, `λ₁ ≠ 0`)
   followed by `ring`.

Sanity anchor: instantiating at the manuscript family
(a,b,α,m,γ,ν,μ,L,n₀) = (1,1,1,1,1,1,1,1,1) must give
A ≈ -0.00404035, B ≈ -2.63214241, C ≈ +5.70061792.

Provenance of that anchor, and its limits (corrected 2026-08-09): the numbers
were produced by `codes/verify_paper3_quadratic_abc.py`, and the definitions
below were transcribed to mirror that same file. The anchor is therefore NOT an
independent check of the transcription — comparing these definitions against
that script compares an implementation with its own descendant. Re-running that
comparison on 2026-08-09 reproduced the anchor (worst relative difference
7.8e-07, consistent with the quoted significant figures), which confirms only
that the Python side is self-consistent.

An earlier version of this docstring claimed that "a `norm_num` instance check
of the constant family is included below as a smoke test". No such check exists
in this file, and none ever did; the claim is removed rather than left standing.
Adding a genuine `norm_num` evaluation of `Acf`/`Bcf`/`Ccf` at the all-ones
family would be worthwhile — at that instantiation the `rpow` exponents collapse
to 0 and 1 — because it would at least detect later drift between these
definitions and the anchor. It would still not validate the transcription
against the manuscript, which remains human-checked (README claim boundary 4).

STATUS (2026-08-07): PROVEN on Home-Dell (elan 4.2.3, toolchain
leanprover/lean4:v4.32.2, mathlib v4.32.2 prebuilt cache) —
`lake build Paper3QuadraticABC` completes clean in ~7.5 s with zero `sorry`
and zero errors. The hypotheses `_hs` and `_hden` are the identity's
nondegeneracy side-conditions (recorded for mathematical completeness; the
algebraic step itself does not reference them).
-/

import Mathlib

namespace Paper3QuadraticABC

/-- Model parameters of the nonminimal 1D Keller–Segel model. -/
structure Params where
  a : ℝ
  b : ℝ
  alpha : ℝ
  m : ℝ
  gamma : ℝ
  nu : ℝ
  mu : ℝ
  L : ℝ
  n0 : ℝ  -- kept real; instantiate at positive integers

/-- Laplace eigenvalue λ_k = (kπ/L)². -/
noncomputable def lam (p : Params) (k : ℝ) : ℝ := (k * Real.pi / p.L) ^ 2

/-- Equilibrium u* = (a/b)^{1/α}. -/
noncomputable def us (p : Params) : ℝ := (p.a / p.b) ^ (1 / p.alpha)

/-- Equilibrium v* = (ν/μ) (u*)^γ. -/
noncomputable def vs (p : Params) : ℝ := (p.nu / p.mu) * (us p) ^ p.gamma

/-- w = 1 + v*. -/
noncomputable def w (p : Params) : ℝ := 1 + vs p

/-- State-correction coefficients C_k^{(1)}, C_k^{(2)}, C_k^{(3)}. -/
noncomputable def C1 (p : Params) (lk : ℝ) : ℝ :=
  p.nu * p.gamma * (us p) ^ (p.gamma - 1) / (p.mu + lk)
noncomputable def C2 (p : Params) (lk : ℝ) : ℝ :=
  p.nu * p.gamma * (p.gamma - 1) * (us p) ^ (p.gamma - 2) / (4 * (p.mu + lk))
noncomputable def C3 (p : Params) (lk : ℝ) : ℝ :=
  p.nu * p.gamma * (p.gamma - 1) * (p.gamma - 2) * (us p) ^ (p.gamma - 3) / (24 * (p.mu + lk))

/-- M = (λ₁+aα)(μ+λ₁)/λ₁ (the β-free factor of χ*/w^β times λ₁/κ is P below). -/
noncomputable def M (p : Params) : ℝ :=
  (lam p p.n0 + p.a * p.alpha) * (p.mu + lam p p.n0) / lam p p.n0

/-- κ = νγ (u*)^{m+γ-1}. -/
noncomputable def kap (p : Params) : ℝ := p.nu * p.gamma * (us p) ^ (p.m + p.gamma - 1)

/-- P = (λ₁+aα)(μ+λ₁)/κ — the effective prefactor of χ*Γ channels. -/
noncomputable def P (p : Params) : ℝ :=
  (lam p p.n0 + p.a * p.alpha) * (p.mu + lam p p.n0) / kap p

/-- σ₂ = σ_{2n₀}(χ*), β-independent. -/
noncomputable def sig2 (p : Params) : ℝ :=
  -lam p (2 * p.n0) + M p * lam p (2 * p.n0) / (p.mu + lam p (2 * p.n0)) - p.a * p.alpha

/-- Logistic coefficients c₁, c₃. -/
noncomputable def c1 (p : Params) : ℝ :=
  (1 + p.alpha) * p.alpha * p.b * (us p) ^ (p.alpha - 1) / 4
noncomputable def c3 (p : Params) : ℝ :=
  (1 + p.alpha) * p.alpha * (p.alpha - 1) * p.b * (us p) ^ (p.alpha - 2) / 8

/-- Center-manifold constant-mode coefficient a_{0,1} (β-independent). -/
noncomputable def a01 (p : Params) : ℝ :=
  c1 p / (p.a - (1 + p.alpha) * p.b * (us p) ^ p.alpha)

/-- χ*Γ_{2n₀} = D₀ + D₁ β. -/
noncomputable def D0 (p : Params) : ℝ :=
  P p * (4 * (us p) ^ p.m * C2 p (lam p (2 * p.n0)) + p.m * (us p) ^ (p.m - 1) * C1 p (lam p p.n0))
noncomputable def D1 (p : Params) : ℝ :=
  -P p * (us p) ^ p.m * (C1 p (lam p p.n0)) ^ 2 / w p

/-- a_{2n₀,1} = p₂₀ + p₂₁ β. -/
noncomputable def p20 (p : Params) : ℝ := (c1 p - D0 p) / sig2 p
noncomputable def p21 (p : Params) : ℝ := -D1 p / sig2 p

/-- Signal-corrected aggregates. -/
noncomputable def v1 (p : Params) : ℝ := C1 p (lam p p.n0)
noncomputable def v0 (p : Params) : ℝ := C1 p 0 * a01 p + C2 p 0
noncomputable def v20 (p : Params) : ℝ := C1 p (lam p (2 * p.n0)) * p20 p + C2 p (lam p (2 * p.n0))
noncomputable def v21 (p : Params) : ℝ := C1 p (lam p (2 * p.n0)) * p21 p
noncomputable def V0 (p : Params) : ℝ :=
  C2 p (lam p p.n0) * (4 * a01 p + 2 * p20 p) + 3 * C3 p (lam p p.n0)
noncomputable def V1 (p : Params) : ℝ := 2 * C2 p (lam p p.n0) * p21 p

/-- β-free aggregates E₀, E₁, E₂ (the w^β-normalized cubic bracket). -/
noncomputable def E0 (p : Params) : ℝ :=
  (us p) ^ p.m * V0 p + p.m * (us p) ^ (p.m - 1) * v1 p * a01 p
    - (p.m / 2) * (us p) ^ (p.m - 1) * v1 p * p20 p
    + p.m * (us p) ^ (p.m - 1) * v20 p
    + p.m * (p.m - 1) * (us p) ^ (p.m - 2) * v1 p / 8
noncomputable def E1 (p : Params) : ℝ :=
  (us p) ^ p.m * V1 p - (p.m / 2) * (us p) ^ (p.m - 1) * v1 p * p21 p
    + p.m * (us p) ^ (p.m - 1) * v21 p
    - p.m * (us p) ^ (p.m - 1) * (v1 p) ^ 2 / (4 * w p)
    - (us p) ^ p.m * v0 p * v1 p / w p
    - (us p) ^ p.m * v1 p * v20 p / (2 * w p)
    + (us p) ^ p.m * (v1 p) ^ 3 / (8 * (w p) ^ 2)
noncomputable def E2 (p : Params) : ℝ :=
  -(us p) ^ p.m * v1 p * v21 p / (2 * w p) + (us p) ^ p.m * (v1 p) ^ 3 / (8 * (w p) ^ 2)

/-- The closed-form coefficients. -/
noncomputable def Acf (p : Params) : ℝ := -P p * E2 p
noncomputable def Bcf (p : Params) : ℝ := 2 * c1 p * p21 p - P p * E1 p
noncomputable def Ccf (p : Params) : ℝ := c1 p * (4 * a01 p + 2 * p20 p) - P p * E0 p + c3 p

/-- χ*(β) = (P/λ₁)·w^β — the threshold, with the genuine `Real.rpow`
β-dependence.  (P/λ₁ = M/κ by definition of P and M; this form keeps the
proof free of κ.) -/
noncomputable def chiStar (p : Params) (β : ℝ) : ℝ := (P p / lam p p.n0) * (w p) ^ β

/-- Γ₃(β) = λ₁ · (cubic bracket), with the mobility weights carrying the
uncollected `w^{-β}` factors (`Real.rpow`).  This is the RAW assembled form;
nothing is pre-collected here. -/
noncomputable def Gamma3 (p : Params) (β : ℝ) : ℝ :=
  lam p p.n0 *
    ((us p) ^ p.m / (w p) ^ β * (V0 p + V1 p * β)
      + p.m * (us p) ^ (p.m - 1) / (w p) ^ β * (v1 p * a01 p)
      - (p.m / 2) * (us p) ^ (p.m - 1) / (w p) ^ β * (v1 p * (p20 p + p21 p * β))
      + p.m * (us p) ^ (p.m - 1) / (w p) ^ β * (v20 p + v21 p * β)
      + p.m * (p.m - 1) * (us p) ^ (p.m - 2) / (2 * (w p) ^ β) * (v1 p / 4)
      - p.m * β * (us p) ^ (p.m - 1) / (w p) ^ (β + 1) * ((v1 p) ^ 2 / 4)
      - β * (us p) ^ p.m / (w p) ^ (β + 1) * (v0 p * v1 p)
      - β * (us p) ^ p.m / (w p) ^ (β + 1) * (v1 p * (v20 p + v21 p * β) / 2)
      + β * (β + 1) * (us p) ^ p.m / (2 * (w p) ^ (β + 2)) * ((v1 p) ^ 3 / 4))

/-- The assembled cubic coefficient, RAW: logistic channels plus the
chemotaxis channel with explicit `w^β` / `w^{-β}` factors. -/
noncomputable def betaRaw (p : Params) (β : ℝ) : ℝ :=
  c1 p * (4 * a01 p + 2 * (p20 p + p21 p * β)) + c3 p
    - chiStar p β * Gamma3 p β

set_option maxHeartbeats 800000
set_option maxRecDepth 8000

/-- **Target identity** (the non-vacuous one): the raw assembled coefficient,
with all `Real.rpow` factors explicit, is exactly the closed-form quadratic.

Proof: normalize the `w^(β+k)` factors to atoms, then `field_simp` + `ring`.

Sanity anchor (cross-checked against `verify_paper3_quadratic_abc.py`):
at the manuscript family the closed forms give
A ≈ -0.00404035, B ≈ -2.63214241, C ≈ +5.70061792. -/
theorem beta_quadratic (p : Params)
    (hw : 0 < w p) (_hs : sig2 p ≠ 0)
    (_hden : p.a - (1 + p.alpha) * p.b * (us p) ^ p.alpha ≠ 0)
    (hlam : lam p p.n0 ≠ 0)
    (β : ℝ) :
    betaRaw p β = Acf p * β ^ 2 + Bcf p * β + Ccf p := by
  have hwne : w p ≠ 0 := hw.ne'
  set u := (w p) ^ β with hu
  have hu0 : u ≠ 0 := by
    rw [hu]; exact (Real.rpow_pos_of_pos hw β).ne'
  have hpow1 : (w p) ^ (β + 1) = u * w p := by
    rw [hu, Real.rpow_add hw, Real.rpow_one]
  have hpow2 : (w p) ^ (β + 2) = u * (w p) ^ 2 := by
    rw [hu, Real.rpow_add hw, Real.rpow_ofNat]
  unfold betaRaw chiStar Gamma3 Acf Bcf Ccf E0 E1 E2
  rw [hpow1, hpow2]
  rw [← hu]
  field_simp
  ring_nf

end Paper3QuadraticABC

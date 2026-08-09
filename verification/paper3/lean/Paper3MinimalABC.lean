import Mathlib

/-!
# Paper III — the minimal model's cubic coefficient is quadratic in β

`Paper3QuadraticABC` proves the analogous statement for the non-minimal model
(`a, b > 0`). It cannot be reused here: it derives the equilibrium as
`u* = (a/b)^{1/α}`, which is meaningless at `a = b = 0`, and it carries the
logistic channels `c₁`, `c₃`, `a₀,₁` that the minimal model does not have.

This file mirrors that development under the specialization the manuscript
states in the proof of Theorem~\ref{T:local-bifurcation-2}:

* `u* > 0` is a free parameter (any positive constant is an equilibrium);
* `a₀,₁ = 0` by mass conservation, and the logistic terms vanish because `b = 0`,
  so `c₁ = c₃ = 0`;
* consequently `β_{n₀} = -χ* Γ_{n₀}^{(3)}`, eq. (4.13) — the chemotactic channel
  alone;
* with `a = 0` the prefactor reduces to `P = λ_{n₀}(μ+λ_{n₀})/κ`.

The naming follows the manuscript: `v0 = d₀ = C₀^{(2)}`,
`v20 + v21 β = d₂ = C_{2n₀}^{(1)} p₂ + C_{2n₀}^{(2)}`, and
`V0 + V1 β = d₃ = 2 C_{n₀}^{(2)} p₂ + 3 C_{n₀}^{(3)}`.

`regime_classification` in `Paper3Regime` is pure algebra about a quadratic
`A β² + B β + C`, so it applies verbatim to the coefficients proved here; no
minimal-model analogue of it is needed.
-/

namespace Paper3MinimalABC

/-- Minimal-model parameters. There is no `a` or `b`: the equilibrium `u*` is
carried directly, exactly as the manuscript treats it. -/
structure MinParams where
  us : ℝ
  m : ℝ
  gamma : ℝ
  nu : ℝ
  mu : ℝ
  L : ℝ
  n0 : ℝ

variable (p : MinParams)

noncomputable def lam (k : ℝ) : ℝ := (k * Real.pi / p.L) ^ 2
noncomputable def vs : ℝ := (p.nu / p.mu) * p.us ^ p.gamma
noncomputable def w : ℝ := 1 + vs p

noncomputable def C1 (lk : ℝ) : ℝ := p.nu * p.gamma * p.us ^ (p.gamma - 1) / (p.mu + lk)
noncomputable def C2 (lk : ℝ) : ℝ :=
  p.nu * p.gamma * (p.gamma - 1) * p.us ^ (p.gamma - 2) / (4 * (p.mu + lk))
noncomputable def C3 (lk : ℝ) : ℝ :=
  p.nu * p.gamma * (p.gamma - 1) * (p.gamma - 2) * p.us ^ (p.gamma - 3) / (24 * (p.mu + lk))

noncomputable def kap : ℝ := p.nu * p.gamma * p.us ^ (p.m + p.gamma - 1)

/-- `M = (μ + λ_{n₀})`, the `a = 0` specialization of `(λ+aα)(μ+λ)/λ`. -/
noncomputable def M : ℝ := p.mu + lam p p.n0

/-- `P = λ_{n₀}(μ+λ_{n₀})/κ`, the `a = 0` specialization. -/
noncomputable def P : ℝ := lam p p.n0 * (p.mu + lam p p.n0) / kap p

/-- `σ₂ = σ_{2n₀}(χ*)`, with the `aα` term absent. -/
noncomputable def sig2 : ℝ :=
  -lam p (2 * p.n0) + M p * lam p (2 * p.n0) / (p.mu + lam p (2 * p.n0))

/-- `χ*Γ_{2n₀} = D₀ + D₁ β`. -/
noncomputable def D0 : ℝ :=
  P p * (4 * p.us ^ p.m * C2 p (lam p (2 * p.n0)) + p.m * p.us ^ (p.m - 1) * C1 p (lam p p.n0))
noncomputable def D1 : ℝ := -P p * p.us ^ p.m * (C1 p (lam p p.n0)) ^ 2 / w p

/-- `p₂ = a_{2n₀,1} = p₂₀ + p₂₁ β`. With `c₁ = 0` the numerator loses its
logistic term, leaving `-D₀/σ₂`. -/
noncomputable def p20 : ℝ := -D0 p / sig2 p
noncomputable def p21 : ℝ := -D1 p / sig2 p

noncomputable def v1 : ℝ := C1 p (lam p p.n0)
/-- `d₀ = C₀^{(2)}`; the `C₀^{(1)} a₀,₁` term drops because `a₀,₁ = 0`. -/
noncomputable def v0 : ℝ := C2 p 0
noncomputable def v20 : ℝ := C1 p (lam p (2 * p.n0)) * p20 p + C2 p (lam p (2 * p.n0))
noncomputable def v21 : ℝ := C1 p (lam p (2 * p.n0)) * p21 p
/-- `d₃ = 2 C_{n₀}^{(2)} p₂ + 3 C_{n₀}^{(3)}`; the `4 a₀,₁` term drops. -/
noncomputable def V0 : ℝ := C2 p (lam p p.n0) * (2 * p20 p) + 3 * C3 p (lam p p.n0)
noncomputable def V1 : ℝ := 2 * C2 p (lam p p.n0) * p21 p

noncomputable def E0 : ℝ :=
  p.us ^ p.m * V0 p
    - (p.m / 2) * p.us ^ (p.m - 1) * v1 p * p20 p
    + p.m * p.us ^ (p.m - 1) * v20 p
    + p.m * (p.m - 1) * p.us ^ (p.m - 2) * v1 p / 8
noncomputable def E1 : ℝ :=
  p.us ^ p.m * V1 p - (p.m / 2) * p.us ^ (p.m - 1) * v1 p * p21 p
    + p.m * p.us ^ (p.m - 1) * v21 p
    - p.m * p.us ^ (p.m - 1) * (v1 p) ^ 2 / (4 * w p)
    - p.us ^ p.m * v0 p * v1 p / w p
    - p.us ^ p.m * v1 p * v20 p / (2 * w p)
    + p.us ^ p.m * (v1 p) ^ 3 / (8 * (w p) ^ 2)
noncomputable def E2 : ℝ :=
  -p.us ^ p.m * v1 p * v21 p / (2 * w p) + p.us ^ p.m * (v1 p) ^ 3 / (8 * (w p) ^ 2)

/-- Closed-form minimal-model coefficients. The logistic contributions
`2 c₁ p₂₁`, `c₁(4a₀,₁ + 2p₂₀)` and `c₃` present in the non-minimal `B` and `C`
are absent here. -/
noncomputable def AcfMin : ℝ := -P p * E2 p
noncomputable def BcfMin : ℝ := -P p * E1 p
noncomputable def CcfMin : ℝ := -P p * E0 p

noncomputable def chiStar (β : ℝ) : ℝ := (P p / lam p p.n0) * (w p) ^ β

/-- `Γ_{n₀}^{(3)}(β)`, raw, with the `a₀,₁` channel removed. -/
noncomputable def Gamma3 (β : ℝ) : ℝ :=
  lam p p.n0 *
    (p.us ^ p.m / (w p) ^ β * (V0 p + V1 p * β)
      - (p.m / 2) * p.us ^ (p.m - 1) / (w p) ^ β * (v1 p * (p20 p + p21 p * β))
      + p.m * p.us ^ (p.m - 1) / (w p) ^ β * (v20 p + v21 p * β)
      + p.m * (p.m - 1) * p.us ^ (p.m - 2) / (2 * (w p) ^ β) * (v1 p / 4)
      - p.m * β * p.us ^ (p.m - 1) / (w p) ^ (β + 1) * ((v1 p) ^ 2 / 4)
      - β * p.us ^ p.m / (w p) ^ (β + 1) * (v0 p * v1 p)
      - β * p.us ^ p.m / (w p) ^ (β + 1) * (v1 p * (v20 p + v21 p * β) / 2)
      + β * (β + 1) * p.us ^ p.m / (2 * (w p) ^ (β + 2)) * ((v1 p) ^ 3 / 4))

/-- `β_{n₀} = -χ* Γ_{n₀}^{(3)}`, eq. (4.13): the chemotactic channel alone. -/
noncomputable def betaRawMin (β : ℝ) : ℝ := -chiStar p β * Gamma3 p β

set_option maxHeartbeats 800000
set_option maxRecDepth 8000

/-- **The minimal model's cubic coefficient is exactly quadratic in β.**

This is the eq. (4.13) analogue of `Paper3QuadraticABC.beta_quadratic`. Together
with `Paper3Regime.regime_classification`, which is pure algebra about
`A β² + B β + C`, it supplies the minimal model with the same supercritical /
subcritical classification as the non-minimal one. -/
theorem betaMin_quadratic (hw : 0 < w p) (hlam : lam p p.n0 ≠ 0) (β : ℝ) :
    betaRawMin p β = AcfMin p * β ^ 2 + BcfMin p * β + CcfMin p := by
  have hwne : w p ≠ 0 := hw.ne'
  set u := (w p) ^ β with hu
  have hu0 : u ≠ 0 := by
    rw [hu]; exact (Real.rpow_pos_of_pos hw β).ne'
  have hpow1 : (w p) ^ (β + 1) = u * w p := by
    rw [hu, Real.rpow_add hw, Real.rpow_one]
  have hpow2 : (w p) ^ (β + 2) = u * (w p) ^ 2 := by
    rw [hu, Real.rpow_add hw, Real.rpow_ofNat]
  unfold betaRawMin chiStar Gamma3 AcfMin BcfMin CcfMin E0 E1 E2
  rw [hpow1, hpow2]
  rw [← hu]
  field_simp
  ring_nf

end Paper3MinimalABC

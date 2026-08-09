import Paper3Regime

namespace Paper3Model

open Real

/-- Equilibrium data shared by both model classes of Paper III.

In the non-minimal model (`a, b > 0`) the equilibrium is determined,
`u* = (a/b)^{1/α}`. In the minimal model (`a = b = 0`) the manuscript leaves
`u* > 0` free: for any positive constant `u*`, the pair `(u*, v*)` with
`v* = (ν/μ)(u*)^γ` is an equilibrium.

`Paper3QuadraticABC` hard-wires the non-minimal choice, so its theorems cannot
be instantiated at `a = b = 0`. Carrying `u*` as data covers both classes at
once, which matters because eq. (4.2) states exactly the same `α_{n₀}` formula
as eq. (1.13). -/
structure ModelData where
  us : ℝ
  m : ℝ
  gamma : ℝ
  nu : ℝ
  mu : ℝ
  L : ℝ
  n0 : ℝ

variable (d : ModelData)

/-- Laplace eigenvalue `λ_k = (kπ/L)²`. -/
noncomputable def lam (k : ℝ) : ℝ := (k * Real.pi / d.L) ^ 2

/-- `v* = (ν/μ)(u*)^γ`. -/
noncomputable def vs : ℝ := (d.nu / d.mu) * d.us ^ d.gamma

/-- `w = 1 + v*`. -/
noncomputable def w : ℝ := 1 + vs d

/-- `κ = νγ(u*)^{m+γ-1}`. -/
noncomputable def kap : ℝ := d.nu * d.gamma * d.us ^ (d.m + d.gamma - 1)

/-- `α_{n₀}(β) = νγ (u*)^{m+γ-1} (1+v*)^{-β} λ_{n₀}/(μ+λ_{n₀})`, eq. (1.13) for
the non-minimal model and eq. (4.2) for the minimal model. -/
noncomputable def alphaN0 (β : ℝ) : ℝ :=
  kap d / (w d) ^ β * (lam d d.n0 / (d.mu + lam d d.n0))

lemma vs_pos (hus : 0 < d.us) (hnu : 0 < d.nu) (hmu : 0 < d.mu) : 0 < vs d :=
  mul_pos (div_pos hnu hmu) (Real.rpow_pos_of_pos hus _)

/-- `w > 1` is *derived* from `v* > 0`, not assumed. -/
lemma one_lt_w (hus : 0 < d.us) (hnu : 0 < d.nu) (hmu : 0 < d.mu) : 1 < w d := by
  have := vs_pos d hus hnu hmu
  unfold w
  linarith

lemma w_pos (hus : 0 < d.us) (hnu : 0 < d.nu) (hmu : 0 < d.mu) : 0 < w d :=
  lt_trans one_pos (one_lt_w d hus hnu hmu)

/-- `κ > 0` is *derived* from `u*, ν, γ > 0`, not assumed. -/
lemma kap_pos (hus : 0 < d.us) (hnu : 0 < d.nu) (hgamma : 0 < d.gamma) : 0 < kap d :=
  mul_pos (mul_pos hnu hgamma) (Real.rpow_pos_of_pos hus _)

lemma lam_pos (hL : 0 < d.L) (hn0 : 0 < d.n0) : 0 < lam d d.n0 :=
  pow_pos (div_pos (mul_pos hn0 Real.pi_pos) hL) 2

/-- **`α_{n₀} > 0` for both model classes.**

Unlike `Paper3QuadraticABC.alphaN0_pos`, whose hypotheses are positivity of the
derived quantities `κ` and `w`, this version assumes only positivity of the
primitive parameters and derives the rest. In particular it applies to the
minimal model, where `u*` is free. -/
theorem alphaN0_pos (β : ℝ) (hus : 0 < d.us) (hnu : 0 < d.nu) (hgamma : 0 < d.gamma)
    (hmu : 0 < d.mu) (hL : 0 < d.L) (hn0 : 0 < d.n0) :
    0 < alphaN0 d β := by
  have hk := kap_pos d hus hnu hgamma
  have hw := w_pos d hus hnu hmu
  have hl := lam_pos d hL hn0
  have hwb : 0 < (w d) ^ β := Real.rpow_pos_of_pos hw β
  exact mul_pos (div_pos hk hwb) (div_pos hl (by linarith))

/-- **`α_{n₀}` is strictly decreasing in `β`, for both model classes.** -/
theorem alphaN0_strictAnti (hus : 0 < d.us) (hnu : 0 < d.nu) (hgamma : 0 < d.gamma)
    (hmu : 0 < d.mu) (hL : 0 < d.L) (hn0 : 0 < d.n0) :
    StrictAnti (alphaN0 d) := by
  have hk := kap_pos d hus hnu hgamma
  have hw1 := one_lt_w d hus hnu hmu
  have hw := w_pos d hus hnu hmu
  have hl := lam_pos d hL hn0
  intro x y hxy
  have hx : 0 < (w d) ^ x := Real.rpow_pos_of_pos hw x
  have hmono : (w d) ^ x < (w d) ^ y := (Real.rpow_lt_rpow_left_iff hw1).mpr hxy
  have hfac : 0 < lam d d.n0 / (d.mu + lam d d.n0) := div_pos hl (by linarith)
  exact mul_lt_mul_of_pos_right (div_lt_div_of_pos_left hk hx hmono) hfac

/-- **Label-gate bridge for both model classes**: `c₂ = β_{n₀}/α_{n₀}` is
positive exactly when `β_{n₀}` is. -/
theorem c2_pos_iff_betaN0_pos (β bn0 : ℝ) (hα : 0 < alphaN0 d β) :
    0 < bn0 / alphaN0 d β ↔ 0 < bn0 := by
  rw [div_pos_iff]
  constructor
  · rintro (⟨h, _⟩ | ⟨_, h⟩)
    · exact h
    · linarith
  · intro h
    exact Or.inl ⟨h, hα⟩

/-- Companion of `c2_pos_iff_betaN0_pos` for the subcritical sign. -/
theorem c2_neg_iff_betaN0_neg (β bn0 : ℝ) (hα : 0 < alphaN0 d β) :
    bn0 / alphaN0 d β < 0 ↔ bn0 < 0 := by
  rw [div_neg_iff]
  constructor
  · rintro (⟨_, h⟩ | ⟨h, _⟩)
    · linarith
    · exact h
  · intro h
    exact Or.inr ⟨h, hα⟩

/-- The non-minimal parameter record, viewed as equilibrium data. -/
noncomputable def ofParams (p : Paper3QuadraticABC.Params) : ModelData where
  us := Paper3QuadraticABC.us p
  m := p.m
  gamma := p.gamma
  nu := p.nu
  mu := p.mu
  L := p.L
  n0 := p.n0

/-- In the non-minimal model the equilibrium is positive. -/
lemma us_pos_of_nonminimal (p : Paper3QuadraticABC.Params) (ha : 0 < p.a) (hb : 0 < p.b) :
    0 < Paper3QuadraticABC.us p :=
  Real.rpow_pos_of_pos (div_pos ha hb) _

/-- **The general layer specializes to the existing one.** This is what makes
the generalization a genuine extension rather than a parallel unverified copy:
`Paper3QuadraticABC.alphaN0` is literally `alphaN0` at `ofParams`. -/
theorem alphaN0_ofParams (p : Paper3QuadraticABC.Params) (β : ℝ) :
    alphaN0 (ofParams p) β = Paper3QuadraticABC.alphaN0 p β := rfl

/-- **The minimal model is covered.** For `a = b = 0` the manuscript leaves
`u* > 0` free; this instantiates the general positivity result at any such
`u*`, which is exactly the fact the label gate of the published minimal-model
cases rests on. -/
theorem alphaN0_pos_minimal (us m gamma nu mu L n0 β : ℝ)
    (hus : 0 < us) (hnu : 0 < nu) (hgamma : 0 < gamma)
    (hmu : 0 < mu) (hL : 0 < L) (hn0 : 0 < n0) :
    0 < alphaN0 ⟨us, m, gamma, nu, mu, L, n0⟩ β :=
  alphaN0_pos _ β hus hnu hgamma hmu hL hn0

end Paper3Model

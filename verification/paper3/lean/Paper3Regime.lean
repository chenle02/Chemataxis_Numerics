/-
# Paper III — Lean 4 verification of the α_{n₀} facts and the regime classification

This file extends `Paper3QuadraticABC.lean` (which proves that the assembled
cubic coefficient is exactly the quadratic `β_{n₀}(β) = A β² + B β + C`).

Two manuscript claims are formalized here.

**(1) The α_{n₀} facts.**  The manuscript (`04-02-2026-CRS-3.tex`) defines

  α_{n₀} = ∂_{χ₀} σ_{n₀}(χ₀) = ν γ (u*)^{m+γ-1} (1+v*)^{-β} λ_{n₀}/(μ+λ_{n₀}) > 0,

and asserts that α_{n₀} *decreases* with β.  Both the positivity and the
decrease are asserted in the text but not proved there.  They are load-bearing:
the β-crossover figure of `NUMERICS-RESTRUCTURE-PLAN.md` §3 plots the measured
quantity c₂ = β_{n₀}/α_{n₀}, and converting between c₂ and β_{n₀} is
"non-trivial" precisely because α_{n₀} varies with β.

**(2) The regime classification.**  With A < 0 < C the quadratic has exactly one
positive root β⁺, is positive on [0, β⁺) and negative on (β⁺, ∞) — i.e. the
family is supercritical below β⁺ and subcritical above it.  The proof here
avoids the quadratic formula entirely: dividing out a known root gives
`f(β) = (β - β⁺)·(A(β + β⁺) + B)`, whose second factor is negative for every
β ≥ 0, so the sign of f is decided by the sign of `β - β⁺` alone.

**(3) The label-gate bridge.**  Because α_{n₀} > 0, the measured continuation
slope c₂ = β_{n₀}/α_{n₀} has the same sign as β_{n₀}.  This is the mathematical
content of the label gate used by `codes/stationary_branch_validation.py`:
comparing the measured sign of c₂ against the closed-form sign of β_{n₀} is a
valid test.

Build route: Home-Dell (`~/lean-projects/paper3-abc`, elan 4.2.3, toolchain
leanprover/lean4:v4.32.2, mathlib v4.32.2 prebuilt cache), per the
`lean-single-file-proof-homedell` lab skill.  `leancheck`/Easley is the route
for receipt-grade certification of a full mathlib build, and its remote path is
pinned to a different project; it is not the route for this single-file proof.
-/

import Paper3QuadraticABC

namespace Paper3QuadraticABC

/-- `α_{n₀}(β) = ν γ (u*)^{m+γ-1} (1+v*)^{-β} · λ_{n₀}/(μ+λ_{n₀})`, written with
the already-defined `kap p = ν γ (u*)^{m+γ-1}` and `w p = 1 + v*`. -/
noncomputable def alphaN0 (p : Params) (β : ℝ) : ℝ :=
  kap p / (w p) ^ β * (lam p p.n0 / (p.mu + lam p p.n0))

/-- α_{n₀} is strictly positive. -/
theorem alphaN0_pos (p : Params) (β : ℝ)
    (hkap : 0 < kap p) (hw : 0 < w p)
    (hlam : 0 < lam p p.n0) (hmu : 0 < p.mu) :
    0 < alphaN0 p β := by
  unfold alphaN0
  have hwb : 0 < (w p) ^ β := Real.rpow_pos_of_pos hw β
  have h1 : 0 < kap p / (w p) ^ β := div_pos hkap hwb
  have h2 : 0 < lam p p.n0 / (p.mu + lam p p.n0) := div_pos hlam (by linarith)
  exact mul_pos h1 h2

/-- α_{n₀} strictly decreases in β, whenever `v* > 0` (i.e. `w = 1 + v* > 1`).
This is the manuscript's asserted monotonicity. -/
theorem alphaN0_strictAnti (p : Params)
    (hkap : 0 < kap p) (hw : 1 < w p)
    (hlam : 0 < lam p p.n0) (hmu : 0 < p.mu) :
    StrictAnti (alphaN0 p) := by
  have hw0 : (0 : ℝ) < w p := one_pos.trans hw
  intro x y hxy
  unfold alphaN0
  have hx : 0 < (w p) ^ x := Real.rpow_pos_of_pos hw0 x
  have hmono : (w p) ^ x < (w p) ^ y := by
    exact (Real.rpow_lt_rpow_left_iff hw).mpr hxy
  have hfac : 0 < lam p p.n0 / (p.mu + lam p p.n0) := div_pos hlam (by linarith)
  have hdiv : kap p / (w p) ^ y < kap p / (w p) ^ x :=
    div_lt_div_of_pos_left hkap hx hmono
  exact mul_lt_mul_of_pos_right hdiv hfac

/-- Dividing a quadratic by a known root: if `β⁺` is a root then
`A β² + B β + C = (β - β⁺)(A(β + β⁺) + B)`. -/
theorem quadratic_factor_of_root (A B C βp β : ℝ)
    (hroot : A * βp ^ 2 + B * βp + C = 0) :
    A * β ^ 2 + B * β + C = (β - βp) * (A * (β + βp) + B) := by
  have hC : C = -(A * βp ^ 2 + B * βp) := by linarith
  rw [hC]; ring

/-- The second factor `A(β + β⁺) + B` is strictly negative for every `β ≥ 0`,
when `A < 0 < C` and `β⁺ > 0` is a root. -/
theorem cofactor_neg (A B C βp β : ℝ)
    (hA : A < 0) (hC : 0 < C) (hβp : 0 < βp)
    (hroot : A * βp ^ 2 + B * βp + C = 0) (hβ : 0 ≤ β) :
    A * (β + βp) + B < 0 := by
  have hprod : βp * (A * βp + B) = -C := by linear_combination hroot
  have hg0 : A * βp + B < 0 := by nlinarith
  nlinarith

/-- **Regime classification.**  For `A < 0 < C` with positive root `β⁺`, the
quadratic `β_{n₀}(β) = A β² + B β + C` is positive on `[0, β⁺)` (supercritical),
negative on `(β⁺, ∞)` (subcritical), and `β⁺` is its only root in `[0, ∞)`. -/
theorem regime_classification (A B C βp : ℝ)
    (hA : A < 0) (hC : 0 < C) (hβp : 0 < βp)
    (hroot : A * βp ^ 2 + B * βp + C = 0) :
    (∀ β, 0 ≤ β → β < βp → 0 < A * β ^ 2 + B * β + C) ∧
    (∀ β, βp < β → A * β ^ 2 + B * β + C < 0) ∧
    (∀ β, 0 ≤ β → A * β ^ 2 + B * β + C = 0 → β = βp) := by
  refine ⟨?_, ?_, ?_⟩
  · intro β hβ hlt
    rw [quadratic_factor_of_root A B C βp β hroot]
    have hg := cofactor_neg A B C βp β hA hC hβp hroot hβ
    have hd : β - βp < 0 := by linarith
    exact mul_pos_of_neg_of_neg hd hg
  · intro β hgt
    have hβ : 0 ≤ β := by linarith
    rw [quadratic_factor_of_root A B C βp β hroot]
    have hg := cofactor_neg A B C βp β hA hC hβp hroot hβ
    have hd : 0 < β - βp := by linarith
    exact mul_neg_of_pos_of_neg hd hg
  · intro β hβ hzero
    rw [quadratic_factor_of_root A B C βp β hroot] at hzero
    have hg := cofactor_neg A B C βp β hA hC hβp hroot hβ
    have : β - βp = 0 := by
      rcases mul_eq_zero.mp hzero with h | h
      · exact h
      · exact absurd h (ne_of_lt hg)
    linarith

/-- **Label-gate bridge.**  Since `α_{n₀} > 0`, the measured continuation slope
`c₂ = β_{n₀}/α_{n₀}` is positive exactly when `β_{n₀}` is.  This justifies
comparing the measured sign of `c₂` with the closed-form sign of `β_{n₀}`. -/
theorem c2_pos_iff_betaN0_pos (p : Params) (β bn0 : ℝ)
    (hα : 0 < alphaN0 p β) :
    0 < bn0 / alphaN0 p β ↔ 0 < bn0 := by
  rw [div_pos_iff]
  constructor
  · rintro (⟨h, _⟩ | ⟨_, h⟩)
    · exact h
    · linarith
  · intro h
    exact Or.inl ⟨h, hα⟩

/-- Companion of `c2_pos_iff_betaN0_pos` for the subcritical sign. -/
theorem c2_neg_iff_betaN0_neg (p : Params) (β bn0 : ℝ)
    (hα : 0 < alphaN0 p β) :
    bn0 / alphaN0 p β < 0 ↔ bn0 < 0 := by
  rw [div_neg_iff]
  constructor
  · rintro (⟨_, h⟩ | ⟨h, _⟩)
    · linarith
    · exact h
  · intro h
    exact Or.inr ⟨h, hα⟩

end Paper3QuadraticABC

/-
# Paper III -- discrete/continuum threshold ordering

This file checks the strict eigenvalue inequality and the turning-point
ordering statements in the Section 6 remark following equation (6.3).
-/

import Paper3Thresholds

namespace Paper3DiscreteOrdering

open Paper3Semidiscrete Paper3Thresholds

/-- For every fixed positive mode and finite positive mesh size, the standard
three-point Neumann eigenvalue is strictly below its continuum counterpart. -/
theorem discLam_lt_continuum (L : ℝ) (n N : ℕ)
    (hL : 0 < L) (hn : 0 < n) (hN : 0 < N) :
    discLam L n N < continuumLam L n := by
  have harg : 0 < discArg n N := by
    unfold discArg
    positivity
  have hargne : discArg n N ≠ 0 := harg.ne'
  have hsinc_abs : |Real.sinc (discArg n N)| < 1 := by
    rw [Real.sinc_of_ne_zero hargne, abs_div, abs_of_pos harg]
    exact (div_lt_one harg).2 (by
      simpa [abs_of_pos harg] using Real.abs_sin_lt_abs hargne)
  have hsinc_sq : Real.sinc (discArg n N) ^ 2 < 1 := by
    rcases abs_lt.mp hsinc_abs with ⟨hneg, hpos⟩
    nlinarith [sq_nonneg (Real.sinc (discArg n N) + 1),
      sq_nonneg (1 - Real.sinc (discArg n N))]
  rw [discLam_eq_continuum_mul_sinc_sq L n N hL.ne' hn hN]
  simpa using
    (mul_lt_mul_iff_right₀ (continuumLam_pos L n hL hn)).2 hsinc_sq

/-- The discrete eigenvalue is positive for the represented modes
`1 ≤ n ≤ N`. -/
theorem discLam_pos (L : ℝ) (n N : ℕ)
    (hL : 0 < L) (hn : 0 < n) (hN : 0 < N) (hnN : n ≤ N) :
    0 < discLam L n N := by
  have hnR : (n : ℝ) ≤ (N : ℝ) := by exact_mod_cast hnN
  have hNR : 0 < (N : ℝ) := by exact_mod_cast hN
  have hden : 0 < 2 * (N : ℝ) := mul_pos two_pos hNR
  have hangle : 0 < discArg n N := by
    unfold discArg
    positivity
  have hangle_le : discArg n N ≤ Real.pi / 2 := by
    unfold discArg
    apply (div_le_iff₀ hden).2
    calc
      (n : ℝ) * Real.pi ≤ (N : ℝ) * Real.pi :=
        mul_le_mul_of_nonneg_right hnR Real.pi_pos.le
      _ = Real.pi / 2 * (2 * (N : ℝ)) := by ring
  have hsin : 0 < Real.sin (discArg n N) :=
    Real.sin_pos_of_pos_of_lt_pi hangle
      (hangle_le.trans_lt (half_lt_self Real.pi_pos))
  unfold discLam
  positivity

/-- Exact difference formula for the modal threshold map. -/
theorem modeFactor_sub (q mu x y : ℝ) (hx : x ≠ 0) (hy : y ≠ 0) :
    modeFactor q mu y - modeFactor q mu x
      = (y - x) * (x * y - q * mu) / (x * y) := by
  unfold modeFactor
  field_simp
  ring

/-- Above the turning point `sqrt (q*mu)`, the threshold map is strictly
increasing. -/
theorem modeFactor_lt_of_turning_le (q mu x y : ℝ)
    (hq : 0 ≤ q) (hmu : 0 ≤ mu) (hx : 0 < x) (hxy : x < y)
    (hturn : Real.sqrt (q * mu) ≤ x) :
    modeFactor q mu x < modeFactor q mu y := by
  have ht0 : 0 ≤ Real.sqrt (q * mu) := Real.sqrt_nonneg _
  have hqm : Real.sqrt (q * mu) ^ 2 = q * mu :=
    Real.sq_sqrt (mul_nonneg hq hmu)
  have hxsq : Real.sqrt (q * mu) ^ 2 ≤ x ^ 2 := by
    have h₁ : 0 ≤ x - Real.sqrt (q * mu) := sub_nonneg.mpr hturn
    have h₂ : 0 ≤ x + Real.sqrt (q * mu) := add_nonneg hx.le ht0
    nlinarith [mul_nonneg h₁ h₂]
  have hxyl : x ^ 2 < x * y := by
    nlinarith [mul_pos hx (sub_pos.mpr hxy)]
  have hnum : 0 < x * y - q * mu := by nlinarith
  have hden : 0 < x * y := mul_pos hx (hx.trans hxy)
  rw [← sub_pos, modeFactor_sub q mu x y hx.ne' (hx.trans hxy).ne']
  positivity

/-- Below the turning point, the threshold map is strictly decreasing. -/
theorem modeFactor_lt_of_le_turning (q mu x y : ℝ)
    (hq : 0 ≤ q) (hmu : 0 ≤ mu) (hx : 0 < x) (hxy : x < y)
    (hturn : y ≤ Real.sqrt (q * mu)) :
    modeFactor q mu y < modeFactor q mu x := by
  have ht0 : 0 ≤ Real.sqrt (q * mu) := Real.sqrt_nonneg _
  have hqm : Real.sqrt (q * mu) ^ 2 = q * mu :=
    Real.sq_sqrt (mul_nonneg hq hmu)
  have hysq : y ^ 2 ≤ Real.sqrt (q * mu) ^ 2 := by
    have h₁ : 0 ≤ Real.sqrt (q * mu) - y := sub_nonneg.mpr hturn
    have h₂ : 0 ≤ Real.sqrt (q * mu) + y :=
      add_nonneg ht0 (hx.trans hxy).le
    nlinarith [mul_nonneg h₁ h₂]
  have hxyl : x * y < y ^ 2 := by
    nlinarith [mul_pos (hx.trans hxy) (sub_pos.mpr hxy)]
  have hnum : x * y - q * mu < 0 := by nlinarith
  have hden : 0 < x * y := mul_pos hx (hx.trans hxy)
  rw [← sub_neg, modeFactor_sub q mu x y hx.ne' (hx.trans hxy).ne']
  exact div_neg_of_neg_of_pos (mul_neg_of_pos_of_neg (sub_pos.mpr hxy) hnum) hden

/-- If the discrete eigenvalue for a fixed mode is at or above the turning
point, then its discrete threshold is strictly below the continuum threshold
for that same mode. -/
theorem disc_modeThreshold_lt_of_turning_le
    (L K q mu : ℝ) (n N : ℕ)
    (hL : 0 < L) (hK : 0 < K) (hq : 0 ≤ q) (hmu : 0 ≤ mu)
    (hn : 0 < n) (hN : 0 < N) (hnN : n ≤ N)
    (hturn : Real.sqrt (q * mu) ≤ discLam L n N) :
    Paper3Thresholds.modeThreshold K q mu (discLam L n N)
      < Paper3Thresholds.modeThreshold K q mu (continuumLam L n) := by
  unfold Paper3Thresholds.modeThreshold
  exact mul_lt_mul_of_pos_left
    (modeFactor_lt_of_turning_le q mu _ _ hq hmu
      (discLam_pos L n N hL hn hN hnN)
      (discLam_lt_continuum L n N hL hn hN) hturn) hK

/-- If the continuum eigenvalue remains below the turning point, then the
discrete threshold for that mode is strictly above its continuum threshold. -/
theorem continuum_modeThreshold_lt_of_le_turning
    (L K q mu : ℝ) (n N : ℕ)
    (hL : 0 < L) (hK : 0 < K) (hq : 0 ≤ q) (hmu : 0 ≤ mu)
    (hn : 0 < n) (hN : 0 < N) (hnN : n ≤ N)
    (hturn : continuumLam L n ≤ Real.sqrt (q * mu)) :
    Paper3Thresholds.modeThreshold K q mu (continuumLam L n)
      < Paper3Thresholds.modeThreshold K q mu (discLam L n N) := by
  have hdiscpos := discLam_pos L n N hL hn hN hnN
  unfold Paper3Thresholds.modeThreshold
  exact mul_lt_mul_of_pos_left
    (modeFactor_lt_of_le_turning q mu _ _ hq hmu hdiscpos
      (discLam_lt_continuum L n N hL hn hN) hturn) hK

end Paper3DiscreteOrdering

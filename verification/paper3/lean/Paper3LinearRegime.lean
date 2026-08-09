/-
# Paper III -- modewise linear stability threshold algebra

This file checks the modewise sign calculation underlying Proposition 1.2.
It proves that the growth rate of a positive Neumann mode factors as a positive
coefficient times sensitivity minus its modal threshold.  Hence the mode is
strictly stable below threshold, neutral at threshold, and unstable above it.

No semigroup, spectral completeness, or nonlinear PDE stability claim is made.
-/

import Paper3Thresholds
import Paper3Eigenmodes

namespace Paper3LinearRegime

/-- Growth rate of a positive mode, with `drive` denoting the positive
chi-free chemotactic coefficient. -/
noncomputable def modalGrowth
    (chi drive q mu lam : ℝ) : ℝ :=
  Paper3Eigenmodes.growthRate chi drive mu q lam

/-- Sensitivity at which the selected mode has zero growth. -/
noncomputable def criticalSensitivity
    (drive q mu lam : ℝ) : ℝ :=
  Paper3Thresholds.modeThreshold (1 / drive) q mu lam

/-- Exact factorization of the modal growth rate around its threshold. -/
theorem modalGrowth_factorization
    (chi drive q mu lam : ℝ)
    (hdrive : 0 < drive) (hmu : 0 ≤ mu) (hlam : 0 < lam) :
    modalGrowth chi drive q mu lam =
      drive * lam / (mu + lam) *
        (chi - criticalSensitivity drive q mu lam) := by
  have hsum : mu + lam ≠ 0 := by positivity
  unfold modalGrowth criticalSensitivity Paper3Eigenmodes.growthRate
    Paper3Thresholds.modeThreshold Paper3Thresholds.modeFactor
  field_simp [hdrive.ne', hlam.ne', hsum]
  ring

/-- Every positive mode is strictly damped below its modal threshold. -/
theorem modalGrowth_neg_iff
    (chi drive q mu lam : ℝ)
    (hdrive : 0 < drive) (hmu : 0 ≤ mu) (hlam : 0 < lam) :
    modalGrowth chi drive q mu lam < 0 ↔
      chi < criticalSensitivity drive q mu lam := by
  rw [modalGrowth_factorization chi drive q mu lam hdrive hmu hlam]
  have hfactor : 0 < drive * lam / (mu + lam) := by positivity
  constructor
  · intro hneg
    have hdiff : chi - criticalSensitivity drive q mu lam < 0 := by
      by_contra hnot
      have hnonneg : 0 ≤ chi - criticalSensitivity drive q mu lam :=
        le_of_not_gt hnot
      have hprod : 0 ≤ drive * lam / (mu + lam) *
          (chi - criticalSensitivity drive q mu lam) :=
        mul_nonneg hfactor.le hnonneg
      linarith
    exact sub_neg.mp hdiff
  · intro hbelow
    exact mul_neg_of_pos_of_neg hfactor (sub_neg.mpr hbelow)

/-- Every positive mode grows strictly above its modal threshold. -/
theorem modalGrowth_pos_iff
    (chi drive q mu lam : ℝ)
    (hdrive : 0 < drive) (hmu : 0 ≤ mu) (hlam : 0 < lam) :
    0 < modalGrowth chi drive q mu lam ↔
      criticalSensitivity drive q mu lam < chi := by
  rw [modalGrowth_factorization chi drive q mu lam hdrive hmu hlam]
  have hfactor : 0 < drive * lam / (mu + lam) := by positivity
  rw [mul_pos_iff_of_pos_left hfactor]
  exact sub_pos

/-- The selected mode is neutral exactly at its modal threshold. -/
theorem modalGrowth_eq_zero_iff
    (chi drive q mu lam : ℝ)
    (hdrive : 0 < drive) (hmu : 0 ≤ mu) (hlam : 0 < lam) :
    modalGrowth chi drive q mu lam = 0 ↔
      chi = criticalSensitivity drive q mu lam := by
  rw [modalGrowth_factorization chi drive q mu lam hdrive hmu hlam]
  have hfactor : drive * lam / (mu + lam) ≠ 0 := by positivity
  rw [mul_eq_zero]
  simp only [hfactor, false_or]
  exact sub_eq_zero

/-- A sensitivity below every positive-mode threshold makes every represented
positive mode strictly stable. -/
theorem all_modalGrowth_neg
    {ι : Type*} (chi drive q mu : ℝ) (lam : ι → ℝ)
    (hdrive : 0 < drive) (hmu : 0 ≤ mu)
    (hlam : ∀ i, 0 < lam i)
    (hbelow : ∀ i, chi < criticalSensitivity drive q mu (lam i)) :
    ∀ i, modalGrowth chi drive q mu (lam i) < 0 := by
  intro i
  exact (modalGrowth_neg_iff chi drive q mu (lam i)
    hdrive hmu (hlam i)).2 (hbelow i)

/-- Crossing any selected modal threshold makes that mode strictly unstable. -/
theorem selected_modalGrowth_pos
    {ι : Type*} (chi drive q mu : ℝ) (lam : ι → ℝ) (i : ι)
    (hdrive : 0 < drive) (hmu : 0 ≤ mu) (hlam : 0 < lam i)
    (habove : criticalSensitivity drive q mu (lam i) < chi) :
    0 < modalGrowth chi drive q mu (lam i) := by
  exact (modalGrowth_pos_iff chi drive q mu (lam i)
    hdrive hmu hlam).2 habove

end Paper3LinearRegime

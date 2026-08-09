/-
# Paper III -- ell-one cosine series

This file supplies the analytic passage from finite cosine sums to the
absolutely convergent series stated in Lemma 2.3.
-/

import Paper3TrigFinite

namespace Paper3TrigInfinite

open Paper3TrigOrtho Paper3TrigFinite MeasureTheory

noncomputable def cosineSeries (L : ℝ) (u : ℕ → ℝ) (x : ℝ) : ℝ :=
  ∑' n, u n * mode L n x

lemma norm_mode_le_one (L : ℝ) (n : ℕ) (x : ℝ) : ‖mode L n x‖ ≤ 1 := by
  unfold mode
  simpa [Real.norm_eq_abs] using Real.abs_cos_le_one ((n * Real.pi / L) * x)

lemma summable_norm_cosine_terms (L : ℝ) (u : ℕ → ℝ)
    (hu : Summable fun n => |u n|) (x : ℝ) :
    Summable fun n => ‖u n * mode L n x‖ := by
  refine Summable.of_nonneg_of_le (fun n => norm_nonneg _) (fun n => ?_) hu
  rw [Real.norm_eq_abs, abs_mul]
  exact mul_le_of_le_one_right (abs_nonneg (u n)) (norm_mode_le_one L n x)

lemma cosineSeries_mul (L : ℝ) (u v : ℕ → ℝ)
    (hu : Summable fun n => |u n|) (hv : Summable fun n => |v n|) (x : ℝ) :
    cosineSeries L u x * cosineSeries L v x =
      ∑' z : ℕ × ℕ,
        (u z.1 * mode L z.1 x) * (v z.2 * mode L z.2 x) := by
  unfold cosineSeries
  exact tsum_mul_tsum_of_summable_norm
    (summable_norm_cosine_terms L u hu x)
    (summable_norm_cosine_terms L v hv x)

lemma intervalIntegral_tsum_of_summable_integral_norm
    {ι : Type*} [Countable ι] {F : ι → ℝ → ℝ} {a b : ℝ}
    (hab : a ≤ b) (hF : ∀ i, IntervalIntegrable (F i) MeasureTheory.volume a b)
    (hsum : Summable fun i => ∫ x in a..b, ‖F i x‖) :
    (∑' i, ∫ x in a..b, F i x) = ∫ x in a..b, ∑' i, F i x := by
  have hsum' : Summable fun i => ∫ x in Set.Ioc a b, ‖F i x‖ := by
    simpa only [intervalIntegral.integral_of_le hab] using hsum
  simp_rw [intervalIntegral.integral_of_le hab]
  exact integral_tsum_of_summable_integral_norm (fun i => (hF i).1) hsum'

lemma summable_bilinear_integral_norm (L : ℝ) (hL : 0 < L)
    (u v : ℕ → ℝ) (hu : Summable fun n => |u n|)
    (hv : Summable fun n => |v n|) (k : ℕ) :
    Summable fun z : ℕ × ℕ =>
      ∫ x in (0 : ℝ)..L,
        ‖u z.1 * v z.2 * (mode L z.1 x * mode L z.2 x * mode L k x)‖ := by
  have huv : Summable fun z : ℕ × ℕ => |u z.1| * |v z.2| :=
    hu.mul_of_nonneg hv (fun _ => abs_nonneg _) (fun _ => abs_nonneg _)
  have hbound : Summable fun z : ℕ × ℕ =>
      (|u z.1| * |v z.2|) * L := huv.mul_right L
  refine Summable.of_nonneg_of_le
    (fun z => intervalIntegral.integral_nonneg hL.le (fun _ _ => norm_nonneg _))
    (fun z => ?_) hbound
  have hb := intervalIntegral.norm_integral_le_of_norm_le_const
    (a := (0 : ℝ)) (b := L)
    (f := fun x : ℝ =>
      ‖u z.1 * v z.2 * (mode L z.1 x * mode L z.2 x * mode L k x)‖)
    (C := |u z.1| * |v z.2|) (fun x _ => by
      have hi := norm_mode_le_one L z.1 x
      have hj := norm_mode_le_one L z.2 x
      have hk := norm_mode_le_one L k x
      simp only [norm_norm, norm_mul]
      change |u z.1| * |v z.2| *
        (‖mode L z.1 x‖ * ‖mode L z.2 x‖ * ‖mode L k x‖) ≤
          |u z.1| * |v z.2|
      have hij : ‖mode L z.1 x‖ * ‖mode L z.2 x‖ ≤ 1 :=
        mul_le_one₀ hi (norm_nonneg _) hj
      have hijk : ‖mode L z.1 x‖ * ‖mode L z.2 x‖ *
          ‖mode L k x‖ ≤ 1 := mul_le_one₀ hij (norm_nonneg _) hk
      exact mul_le_of_le_one_right
        (mul_nonneg (abs_nonneg _) (abs_nonneg _)) hijk)
  rw [Real.norm_eq_abs,
    abs_of_nonneg (intervalIntegral.integral_nonneg hL.le
      (fun _ _ => norm_nonneg _)), sub_zero, abs_of_pos hL] at hb
  exact hb

noncomputable def bilinearMain (L : ℝ) (u v : ℕ → ℝ) (k : ℕ)
    (z : ℕ × ℕ) : ℝ :=
  u z.1 * v z.2 * (L / 4 *
    ((if (z.1 : ℤ) - (z.2 : ℤ) = (k : ℤ) then (1 : ℝ) else 0) +
      (if (z.1 : ℤ) - (z.2 : ℤ) = -(k : ℤ) then (1 : ℝ) else 0) +
      (if z.1 + z.2 = k then (1 : ℝ) else 0)))

noncomputable def bilinearCorrection (L : ℝ) (u v : ℕ → ℝ) (k : ℕ)
    (z : ℕ × ℕ) : ℝ :=
  u z.1 * v z.2 * (L / 4 *
    (if z.1 = 0 ∧ z.2 = 0 ∧ k = 0 then (1 : ℝ) else 0))

lemma summable_bilinearMain (L : ℝ) (u v : ℕ → ℝ)
    (hu : Summable fun n => |u n|) (hv : Summable fun n => |v n|)
    (k : ℕ) : Summable (bilinearMain L u v k) := by
  have huv : Summable fun z : ℕ × ℕ => |u z.1| * |v z.2| :=
    hu.mul_of_nonneg hv (fun _ => abs_nonneg _) (fun _ => abs_nonneg _)
  have hbound : Summable fun z : ℕ × ℕ =>
      (|u z.1| * |v z.2|) * (3 * |L| / 4) :=
    huv.mul_right (3 * |L| / 4)
  refine hbound.of_norm_bounded (fun z => ?_)
  unfold bilinearMain
  split_ifs <;> norm_num [Real.norm_eq_abs]
  all_goals
    have hnon : 0 ≤ |u z.1| * |v z.2| * |L| := by positivity
    nlinarith

lemma summable_bilinearCorrection (L : ℝ) (u v : ℕ → ℝ) (k : ℕ) :
    Summable (bilinearCorrection L u v k) := by
  apply summable_of_ne_finset_zero (s := {(0, 0)})
  intro z hz
  simp only [Finset.mem_singleton] at hz
  unfold bilinearCorrection
  by_cases h₁ : z.1 = 0
  · by_cases h₂ : z.2 = 0
    · exact False.elim (hz (Prod.ext h₁ h₂))
    · simp [h₂]
  · simp [h₁]

lemma tsum_bilinearCorrection (L : ℝ) (u v : ℕ → ℝ) (k : ℕ) :
    (∑' z : ℕ × ℕ, bilinearCorrection L u v k z) =
      L / 4 * (if k = 0 then u 0 * v 0 else 0) := by
  by_cases hk : k = 0
  · subst k
    rw [tsum_eq_single (0, 0)]
    · unfold bilinearCorrection
      simp
      ring
    · intro z hz
      unfold bilinearCorrection
      by_cases h₁ : z.1 = 0
      · by_cases h₂ : z.2 = 0
        · exact False.elim (hz (Prod.ext h₁ h₂))
        · simp [h₂]
      · simp [h₁]
  · unfold bilinearCorrection
    simp [hk]

/-- Infinite bilinear cosine identity before separating the unique constant
correction from the absolutely convergent double series. -/
theorem integral_cosineSeries_bilinear_tsum (L : ℝ) (hL : 0 < L)
    (u v : ℕ → ℝ) (hu : Summable fun n => |u n|)
    (hv : Summable fun n => |v n|) (k : ℕ) :
    (∫ x in (0 : ℝ)..L,
      cosineSeries L u x * cosineSeries L v x * mode L k x) =
      ∑' z : ℕ × ℕ, u z.1 * v z.2 *
        (L / 4 *
            ((if (z.1 : ℤ) - (z.2 : ℤ) = (k : ℤ) then (1 : ℝ) else 0) +
              (if (z.1 : ℤ) - (z.2 : ℤ) = -(k : ℤ) then (1 : ℝ) else 0) +
              (if z.1 + z.2 = k then (1 : ℝ) else 0)) +
          L / 4 *
            (if z.1 = 0 ∧ z.2 = 0 ∧ k = 0 then (1 : ℝ) else 0)) := by
  have hpoint : ∀ x : ℝ,
      cosineSeries L u x * cosineSeries L v x * mode L k x =
        ∑' z : ℕ × ℕ, u z.1 * v z.2 *
          (mode L z.1 x * mode L z.2 x * mode L k x) := by
    intro x
    rw [cosineSeries_mul L u v hu hv x, ← tsum_mul_right]
    apply tsum_congr
    intro z
    ring
  have hmode : ∀ n : ℕ, Continuous (mode L n) := by
    intro n
    unfold mode
    continuity
  have hFint : ∀ z : ℕ × ℕ, IntervalIntegrable
      (fun x : ℝ => u z.1 * v z.2 *
        (mode L z.1 x * mode L z.2 x * mode L k x))
      MeasureTheory.volume 0 L := by
    intro z
    exact (continuous_const.mul
      (((hmode z.1).mul (hmode z.2)).mul (hmode k))).intervalIntegrable _ _
  rw [intervalIntegral.integral_congr (fun x _ => hpoint x)]
  rw [← intervalIntegral_tsum_of_summable_integral_norm hL.le
    hFint
    (summable_bilinear_integral_norm L hL u v hu hv k)]
  apply tsum_congr
  intro z
  rw [intervalIntegral.integral_const_mul, integral_triple_mode_nat L hL]

/-- First display of Lemma 2.3 for `ell^1` coefficients, with the constant
correction separated exactly as in the manuscript. -/
theorem integral_cosineSeries_bilinear (L : ℝ) (hL : 0 < L)
    (u v : ℕ → ℝ) (hu : Summable fun n => |u n|)
    (hv : Summable fun n => |v n|) (k : ℕ) :
    (∫ x in (0 : ℝ)..L,
      cosineSeries L u x * cosineSeries L v x * mode L k x) =
      (∑' z : ℕ × ℕ, bilinearMain L u v k z) +
        L / 4 * (if k = 0 then u 0 * v 0 else 0) := by
  rw [integral_cosineSeries_bilinear_tsum L hL u v hu hv k]
  rw [show (fun z : ℕ × ℕ => u z.1 * v z.2 *
      (L / 4 *
          ((if (z.1 : ℤ) - (z.2 : ℤ) = (k : ℤ) then (1 : ℝ) else 0) +
            (if (z.1 : ℤ) - (z.2 : ℤ) = -(k : ℤ) then (1 : ℝ) else 0) +
            (if z.1 + z.2 = k then (1 : ℝ) else 0)) +
        L / 4 *
          (if z.1 = 0 ∧ z.2 = 0 ∧ k = 0 then (1 : ℝ) else 0))) =
      fun z => bilinearMain L u v k z + bilinearCorrection L u v k z by
    funext z
    unfold bilinearMain bilinearCorrection
    ring]
  rw [(summable_bilinearMain L u v hu hv k).tsum_add
    (summable_bilinearCorrection L u v k), tsum_bilinearCorrection]

lemma cosineSeries_mul_three (L : ℝ) (u v w : ℕ → ℝ)
    (hu : Summable fun n => |u n|) (hv : Summable fun n => |v n|)
    (hw : Summable fun n => |w n|) (x : ℝ) :
    cosineSeries L u x * cosineSeries L v x * cosineSeries L w x =
      ∑' z : (ℕ × ℕ) × ℕ,
        ((u z.1.1 * mode L z.1.1 x) * (v z.1.2 * mode L z.1.2 x)) *
          (w z.2 * mode L z.2 x) := by
  rw [cosineSeries_mul L u v hu hv x]
  have hu' := summable_norm_cosine_terms L u hu x
  have hv' := summable_norm_cosine_terms L v hv x
  have huv' : Summable fun z : ℕ × ℕ =>
      ‖u z.1 * mode L z.1 x‖ * ‖v z.2 * mode L z.2 x‖ :=
    hu'.mul_of_nonneg hv' (fun _ => norm_nonneg _) (fun _ => norm_nonneg _)
  have huv : Summable fun z : ℕ × ℕ =>
      ‖(u z.1 * mode L z.1 x) * (v z.2 * mode L z.2 x)‖ :=
    by simpa only [norm_mul] using huv'
  exact tsum_mul_tsum_of_summable_norm
    huv
    (summable_norm_cosine_terms L w hw x)

lemma summable_trilinear_integral_norm (L : ℝ) (hL : 0 < L)
    (u v w : ℕ → ℝ) (hu : Summable fun n => |u n|)
    (hv : Summable fun n => |v n|) (hw : Summable fun n => |w n|)
    (k : ℕ) :
    Summable fun z : (ℕ × ℕ) × ℕ =>
      ∫ x in (0 : ℝ)..L,
        ‖u z.1.1 * v z.1.2 * w z.2 *
          (mode L z.1.1 x * mode L z.1.2 x * mode L z.2 x * mode L k x)‖ := by
  have huv : Summable fun z : ℕ × ℕ => |u z.1| * |v z.2| :=
    hu.mul_of_nonneg hv (fun _ => abs_nonneg _) (fun _ => abs_nonneg _)
  have huvw : Summable fun z : (ℕ × ℕ) × ℕ =>
      (|u z.1.1| * |v z.1.2|) * |w z.2| :=
    huv.mul_of_nonneg hw
      (fun _ => mul_nonneg (abs_nonneg _) (abs_nonneg _))
      (fun _ => abs_nonneg _)
  have hbound : Summable fun z : (ℕ × ℕ) × ℕ =>
      ((|u z.1.1| * |v z.1.2|) * |w z.2|) * L := huvw.mul_right L
  refine Summable.of_nonneg_of_le
    (fun z => intervalIntegral.integral_nonneg hL.le (fun _ _ => norm_nonneg _))
    (fun z => ?_) hbound
  have hb := intervalIntegral.norm_integral_le_of_norm_le_const
    (a := (0 : ℝ)) (b := L)
    (f := fun x : ℝ => ‖u z.1.1 * v z.1.2 * w z.2 *
      (mode L z.1.1 x * mode L z.1.2 x * mode L z.2 x * mode L k x)‖)
    (C := (|u z.1.1| * |v z.1.2|) * |w z.2|) (fun x _ => by
      have hi := norm_mode_le_one L z.1.1 x
      have hj := norm_mode_le_one L z.1.2 x
      have hell := norm_mode_le_one L z.2 x
      have hk := norm_mode_le_one L k x
      simp only [norm_norm, norm_mul]
      change (|u z.1.1| * |v z.1.2|) * |w z.2| *
        (‖mode L z.1.1 x‖ * ‖mode L z.1.2 x‖ * ‖mode L z.2 x‖ *
          ‖mode L k x‖) ≤ (|u z.1.1| * |v z.1.2|) * |w z.2|
      have hij : ‖mode L z.1.1 x‖ * ‖mode L z.1.2 x‖ ≤ 1 :=
        mul_le_one₀ hi (norm_nonneg _) hj
      have hijell : ‖mode L z.1.1 x‖ * ‖mode L z.1.2 x‖ *
          ‖mode L z.2 x‖ ≤ 1 := mul_le_one₀ hij (norm_nonneg _) hell
      have hijellk : ‖mode L z.1.1 x‖ * ‖mode L z.1.2 x‖ *
          ‖mode L z.2 x‖ * ‖mode L k x‖ ≤ 1 :=
        mul_le_one₀ hijell (norm_nonneg _) hk
      exact mul_le_of_le_one_right
        (mul_nonneg (mul_nonneg (abs_nonneg _) (abs_nonneg _))
          (abs_nonneg _)) hijellk)
  rw [Real.norm_eq_abs,
    abs_of_nonneg (intervalIntegral.integral_nonneg hL.le
      (fun _ _ => norm_nonneg _)), sub_zero, abs_of_pos hL] at hb
  exact hb

noncomputable def trilinearMain (L : ℝ) (u v w : ℕ → ℝ) (k : ℕ)
    (z : (ℕ × ℕ) × ℕ) : ℝ :=
  u z.1.1 * v z.1.2 * w z.2 * (L / 8 *
    ((if z.1.1 + z.1.2 + z.2 = k then (1 : ℝ) else 0) +
      (if (z.1.1 : ℤ) + z.1.2 - z.2 = (k : ℤ) then (1 : ℝ) else 0) +
      (if (z.1.1 : ℤ) + z.1.2 - z.2 = -(k : ℤ) then (1 : ℝ) else 0) +
      (if (z.1.1 : ℤ) - z.1.2 + z.2 = (k : ℤ) then (1 : ℝ) else 0) +
      (if (z.1.1 : ℤ) - z.1.2 + z.2 = -(k : ℤ) then (1 : ℝ) else 0) +
      (if (z.1.1 : ℤ) - z.1.2 - z.2 = (k : ℤ) then (1 : ℝ) else 0) +
      (if (z.1.1 : ℤ) - z.1.2 - z.2 = -(k : ℤ) then (1 : ℝ) else 0)))

noncomputable def trilinearCorrection (L : ℝ) (u v w : ℕ → ℝ) (k : ℕ)
    (z : (ℕ × ℕ) × ℕ) : ℝ :=
  u z.1.1 * v z.1.2 * w z.2 * (L / 8 *
    (if z.1.1 = 0 ∧ z.1.2 = 0 ∧ z.2 = 0 ∧ k = 0 then (1 : ℝ) else 0))

lemma summable_trilinearMain (L : ℝ) (u v w : ℕ → ℝ)
    (hu : Summable fun n => |u n|) (hv : Summable fun n => |v n|)
    (hw : Summable fun n => |w n|) (k : ℕ) :
    Summable (trilinearMain L u v w k) := by
  have huv : Summable fun z : ℕ × ℕ => |u z.1| * |v z.2| :=
    hu.mul_of_nonneg hv (fun _ => abs_nonneg _) (fun _ => abs_nonneg _)
  have huvw : Summable fun z : (ℕ × ℕ) × ℕ =>
      (|u z.1.1| * |v z.1.2|) * |w z.2| :=
    huv.mul_of_nonneg hw
      (fun _ => mul_nonneg (abs_nonneg _) (abs_nonneg _))
      (fun _ => abs_nonneg _)
  have hbound : Summable fun z : (ℕ × ℕ) × ℕ =>
      ((|u z.1.1| * |v z.1.2|) * |w z.2|) * (7 * |L| / 8) :=
    huvw.mul_right (7 * |L| / 8)
  refine hbound.of_norm_bounded (fun z => ?_)
  let q₁ : ℝ := if z.1.1 + z.1.2 + z.2 = k then 1 else 0
  let q₂ : ℝ := if (z.1.1 : ℤ) + z.1.2 - z.2 = (k : ℤ) then 1 else 0
  let q₃ : ℝ := if (z.1.1 : ℤ) + z.1.2 - z.2 = -(k : ℤ) then 1 else 0
  let q₄ : ℝ := if (z.1.1 : ℤ) - z.1.2 + z.2 = (k : ℤ) then 1 else 0
  let q₅ : ℝ := if (z.1.1 : ℤ) - z.1.2 + z.2 = -(k : ℤ) then 1 else 0
  let q₆ : ℝ := if (z.1.1 : ℤ) - z.1.2 - z.2 = (k : ℤ) then 1 else 0
  let q₇ : ℝ := if (z.1.1 : ℤ) - z.1.2 - z.2 = -(k : ℤ) then 1 else 0
  have hq_nonneg : 0 ≤ q₁ + q₂ + q₃ + q₄ + q₅ + q₆ + q₇ := by
    dsimp [q₁, q₂, q₃, q₄, q₅, q₆, q₇]
    positivity
  have hq_le : q₁ + q₂ + q₃ + q₄ + q₅ + q₆ + q₇ ≤ 7 := by
    have h₁ : q₁ ≤ 1 := by dsimp [q₁]; split_ifs <;> norm_num
    have h₂ : q₂ ≤ 1 := by dsimp [q₂]; split_ifs <;> norm_num
    have h₃ : q₃ ≤ 1 := by dsimp [q₃]; split_ifs <;> norm_num
    have h₄ : q₄ ≤ 1 := by dsimp [q₄]; split_ifs <;> norm_num
    have h₅ : q₅ ≤ 1 := by dsimp [q₅]; split_ifs <;> norm_num
    have h₆ : q₆ ≤ 1 := by dsimp [q₆]; split_ifs <;> norm_num
    have h₇ : q₇ ≤ 1 := by dsimp [q₇]; split_ifs <;> norm_num
    linarith
  unfold trilinearMain
  change ‖u z.1.1 * v z.1.2 * w z.2 *
    (L / 8 * (q₁ + q₂ + q₃ + q₄ + q₅ + q₆ + q₇))‖ ≤
      (|u z.1.1| * |v z.1.2| * |w z.2|) * (7 * |L| / 8)
  calc
    _ = |u z.1.1| * |v z.1.2| * |w z.2| *
        (|L| / 8 * (q₁ + q₂ + q₃ + q₄ + q₅ + q₆ + q₇)) := by
      simp only [Real.norm_eq_abs, abs_mul, abs_div, abs_of_nonneg hq_nonneg]
      norm_num
    _ ≤ |u z.1.1| * |v z.1.2| * |w z.2| * (|L| / 8 * 7) := by
      gcongr
    _ = (|u z.1.1| * |v z.1.2| * |w z.2|) * (7 * |L| / 8) := by
      ring

lemma summable_trilinearCorrection (L : ℝ) (u v w : ℕ → ℝ) (k : ℕ) :
    Summable (trilinearCorrection L u v w k) := by
  apply summable_of_ne_finset_zero (s := {((0, 0), 0)})
  intro z hz
  simp only [Finset.mem_singleton] at hz
  unfold trilinearCorrection
  by_cases h₁ : z.1.1 = 0
  · by_cases h₂ : z.1.2 = 0
    · by_cases h₃ : z.2 = 0
      · exact False.elim (hz (Prod.ext (Prod.ext h₁ h₂) h₃))
      · simp [h₃]
    · simp [h₂]
  · simp [h₁]

lemma tsum_trilinearCorrection (L : ℝ) (u v w : ℕ → ℝ) (k : ℕ) :
    (∑' z : (ℕ × ℕ) × ℕ, trilinearCorrection L u v w k z) =
      L / 8 * (if k = 0 then u 0 * v 0 * w 0 else 0) := by
  by_cases hk : k = 0
  · subst k
    rw [tsum_eq_single ((0, 0), 0)]
    · unfold trilinearCorrection
      simp
      ring
    · intro z hz
      unfold trilinearCorrection
      by_cases h₁ : z.1.1 = 0
      · by_cases h₂ : z.1.2 = 0
        · by_cases h₃ : z.2 = 0
          · exact False.elim (hz (Prod.ext (Prod.ext h₁ h₂) h₃))
          · simp [h₃]
        · simp [h₂]
      · simp [h₁]
  · unfold trilinearCorrection
    simp [hk]

theorem integral_cosineSeries_trilinear_tsum (L : ℝ) (hL : 0 < L)
    (u v w : ℕ → ℝ) (hu : Summable fun n => |u n|)
    (hv : Summable fun n => |v n|) (hw : Summable fun n => |w n|)
    (k : ℕ) :
    (∫ x in (0 : ℝ)..L,
      cosineSeries L u x * cosineSeries L v x * cosineSeries L w x *
        mode L k x) =
      ∑' z : (ℕ × ℕ) × ℕ, u z.1.1 * v z.1.2 * w z.2 *
        (L / 8 *
            ((if z.1.1 + z.1.2 + z.2 = k then (1 : ℝ) else 0) +
              (if (z.1.1 : ℤ) + z.1.2 - z.2 = (k : ℤ) then (1 : ℝ) else 0) +
              (if (z.1.1 : ℤ) + z.1.2 - z.2 = -(k : ℤ) then (1 : ℝ) else 0) +
              (if (z.1.1 : ℤ) - z.1.2 + z.2 = (k : ℤ) then (1 : ℝ) else 0) +
              (if (z.1.1 : ℤ) - z.1.2 + z.2 = -(k : ℤ) then (1 : ℝ) else 0) +
              (if (z.1.1 : ℤ) - z.1.2 - z.2 = (k : ℤ) then (1 : ℝ) else 0) +
              (if (z.1.1 : ℤ) - z.1.2 - z.2 = -(k : ℤ) then (1 : ℝ) else 0)) +
          L / 8 * (if z.1.1 = 0 ∧ z.1.2 = 0 ∧ z.2 = 0 ∧ k = 0
            then (1 : ℝ) else 0)) := by
  have hpoint : ∀ x : ℝ,
      cosineSeries L u x * cosineSeries L v x * cosineSeries L w x *
          mode L k x =
        ∑' z : (ℕ × ℕ) × ℕ, u z.1.1 * v z.1.2 * w z.2 *
          (mode L z.1.1 x * mode L z.1.2 x * mode L z.2 x * mode L k x) := by
    intro x
    rw [cosineSeries_mul_three L u v w hu hv hw x, ← tsum_mul_right]
    apply tsum_congr
    intro z
    ring
  have hmode : ∀ n : ℕ, Continuous (mode L n) := by
    intro n
    unfold mode
    continuity
  have hFint : ∀ z : (ℕ × ℕ) × ℕ, IntervalIntegrable
      (fun x : ℝ => u z.1.1 * v z.1.2 * w z.2 *
        (mode L z.1.1 x * mode L z.1.2 x * mode L z.2 x * mode L k x))
      MeasureTheory.volume 0 L := by
    intro z
    exact (continuous_const.mul
      ((((hmode z.1.1).mul (hmode z.1.2)).mul (hmode z.2)).mul
        (hmode k))).intervalIntegrable _ _
  rw [intervalIntegral.integral_congr (fun x _ => hpoint x)]
  rw [← intervalIntegral_tsum_of_summable_integral_norm hL.le hFint
    (summable_trilinear_integral_norm L hL u v w hu hv hw k)]
  apply tsum_congr
  intro z
  rw [intervalIntegral.integral_const_mul, integral_four_mode_nat L hL]

/-- Second display of Lemma 2.3 for `ell^1` coefficients, with all seven
index families and the constant correction separated as in the manuscript. -/
theorem integral_cosineSeries_trilinear (L : ℝ) (hL : 0 < L)
    (u v w : ℕ → ℝ) (hu : Summable fun n => |u n|)
    (hv : Summable fun n => |v n|) (hw : Summable fun n => |w n|)
    (k : ℕ) :
    (∫ x in (0 : ℝ)..L,
      cosineSeries L u x * cosineSeries L v x * cosineSeries L w x *
        mode L k x) =
      (∑' z : (ℕ × ℕ) × ℕ, trilinearMain L u v w k z) +
        L / 8 * (if k = 0 then u 0 * v 0 * w 0 else 0) := by
  rw [integral_cosineSeries_trilinear_tsum L hL u v w hu hv hw k]
  rw [show (fun z : (ℕ × ℕ) × ℕ => u z.1.1 * v z.1.2 * w z.2 *
      (L / 8 *
          ((if z.1.1 + z.1.2 + z.2 = k then (1 : ℝ) else 0) +
            (if (z.1.1 : ℤ) + z.1.2 - z.2 = (k : ℤ) then (1 : ℝ) else 0) +
            (if (z.1.1 : ℤ) + z.1.2 - z.2 = -(k : ℤ) then (1 : ℝ) else 0) +
            (if (z.1.1 : ℤ) - z.1.2 + z.2 = (k : ℤ) then (1 : ℝ) else 0) +
            (if (z.1.1 : ℤ) - z.1.2 + z.2 = -(k : ℤ) then (1 : ℝ) else 0) +
            (if (z.1.1 : ℤ) - z.1.2 - z.2 = (k : ℤ) then (1 : ℝ) else 0) +
            (if (z.1.1 : ℤ) - z.1.2 - z.2 = -(k : ℤ) then (1 : ℝ) else 0)) +
        L / 8 * (if z.1.1 = 0 ∧ z.1.2 = 0 ∧ z.2 = 0 ∧ k = 0
          then (1 : ℝ) else 0))) =
      fun z => trilinearMain L u v w k z +
        trilinearCorrection L u v w k z by
    funext z
    unfold trilinearMain trilinearCorrection
    ring]
  rw [(summable_trilinearMain L u v w hu hv hw k).tsum_add
    (summable_trilinearCorrection L u v w k), tsum_trilinearCorrection]

end Paper3TrigInfinite

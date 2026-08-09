/-
# Paper III -- manuscript-facing finite cosine identities

This file converts the integer-indexed harmonic engine into the exact
nonnegative index families appearing in Lemma 2.3 and proves the four-mode
integral behind its trilinear display. Infinite-series interchanges are kept
for a separate analytic layer.
-/

import Paper3ReducedAssembly

namespace Paper3TrigFinite

open Paper3TrigOrtho

/-- Three-mode integral in the paper's nonnegative-index convention. -/
theorem integral_triple_mode_nat (L : ℝ) (hL : 0 < L) (i j k : ℕ) :
    (∫ x in (0 : ℝ)..L, mode L i x * mode L j x * mode L k x) =
      L / 4 *
          ((if (i : ℤ) - (j : ℤ) = (k : ℤ) then (1 : ℝ) else 0) +
            (if (i : ℤ) - (j : ℤ) = -(k : ℤ) then (1 : ℝ) else 0) +
            (if i + j = k then (1 : ℝ) else 0)) +
        L / 4 * (if i = 0 ∧ j = 0 ∧ k = 0 then (1 : ℝ) else 0) := by
  rw [← modeZ_natCast L i, ← modeZ_natCast L j, ← modeZ_natCast L k,
    integral_triple_modeZ L hL]
  have h₀ : (i : ℤ) + j + k = 0 ↔ i = 0 ∧ j = 0 ∧ k = 0 := by omega
  have h₁ : (i : ℤ) + j - k = 0 ↔ i + j = k := by omega
  have h₂ : (i : ℤ) - j + k = 0 ↔ (i : ℤ) - j = -(k : ℤ) := by omega
  have h₃ : (i : ℤ) - j - k = 0 ↔ (i : ℤ) - j = (k : ℤ) := by omega
  simp only [h₀, h₁, h₂, h₃]
  ring

/-- Product-to-sum formula for four integer-indexed cosine modes. -/
theorem integral_four_modeZ (L : ℝ) (hL : 0 < L) (i j ell k : ℤ) :
    (∫ x in (0 : ℝ)..L,
      modeZ L i x * modeZ L j x * modeZ L ell x * modeZ L k x) =
      L / 8 *
        ((if i + j + ell + k = 0 then (1 : ℝ) else 0) +
          (if i + j + ell - k = 0 then (1 : ℝ) else 0) +
          (if i + j - ell + k = 0 then (1 : ℝ) else 0) +
          (if i + j - ell - k = 0 then (1 : ℝ) else 0) +
          (if i - j + ell + k = 0 then (1 : ℝ) else 0) +
          (if i - j + ell - k = 0 then (1 : ℝ) else 0) +
          (if i - j - ell + k = 0 then (1 : ℝ) else 0) +
          (if i - j - ell - k = 0 then (1 : ℝ) else 0)) := by
  have hprod : ∀ x : ℝ, modeZ L ell x * modeZ L k x =
      (modeZ L (ell - k) x + modeZ L (ell + k) x) / 2 := by
    intro x
    unfold modeZ
    push_cast
    have hsub : ((ell : ℝ) - k) * Real.pi / L * x =
        (ell : ℝ) * Real.pi / L * x - (k : ℝ) * Real.pi / L * x := by
      ring
    have hadd : ((ell : ℝ) + k) * Real.pi / L * x =
        (ell : ℝ) * Real.pi / L * x + (k : ℝ) * Real.pi / L * x := by
      ring
    rw [hsub, hadd, Real.cos_sub, Real.cos_add]
    ring
  have hcont : ∀ m : ℤ, Continuous (modeZ L m) := by
    intro m
    unfold modeZ
    continuity
  have hminus : IntervalIntegrable
      (fun x : ℝ => modeZ L i x * modeZ L j x * modeZ L (ell - k) x)
      MeasureTheory.volume 0 L :=
    (((hcont i).mul (hcont j)).mul
      (hcont (ell - k))).intervalIntegrable _ _
  have hplus : IntervalIntegrable
      (fun x : ℝ => modeZ L i x * modeZ L j x * modeZ L (ell + k) x)
      MeasureTheory.volume 0 L :=
    (((hcont i).mul (hcont j)).mul
      (hcont (ell + k))).intervalIntegrable _ _
  rw [intervalIntegral.integral_congr (g := fun x =>
      (modeZ L i x * modeZ L j x * modeZ L (ell - k) x +
        modeZ L i x * modeZ L j x * modeZ L (ell + k) x) / 2)
      (fun x _ => by
        rw [show modeZ L i x * modeZ L j x * modeZ L ell x * modeZ L k x =
          (modeZ L i x * modeZ L j x) *
            (modeZ L ell x * modeZ L k x) by ring, hprod x]
        ring)]
  rw [intervalIntegral.integral_div,
    intervalIntegral.integral_add hminus hplus,
    integral_triple_modeZ L hL, integral_triple_modeZ L hL]
  simp only [sub_eq_add_neg]
  ring_nf

/-- Four-mode integral in the paper's seven-family nonnegative convention. -/
theorem integral_four_mode_nat (L : ℝ) (hL : 0 < L) (i j ell k : ℕ) :
    (∫ x in (0 : ℝ)..L,
      mode L i x * mode L j x * mode L ell x * mode L k x) =
      L / 8 *
          ((if i + j + ell = k then (1 : ℝ) else 0) +
            (if (i : ℤ) + j - ell = (k : ℤ) then (1 : ℝ) else 0) +
            (if (i : ℤ) + j - ell = -(k : ℤ) then (1 : ℝ) else 0) +
            (if (i : ℤ) - j + ell = (k : ℤ) then (1 : ℝ) else 0) +
            (if (i : ℤ) - j + ell = -(k : ℤ) then (1 : ℝ) else 0) +
            (if (i : ℤ) - j - ell = (k : ℤ) then (1 : ℝ) else 0) +
            (if (i : ℤ) - j - ell = -(k : ℤ) then (1 : ℝ) else 0)) +
        L / 8 *
          (if i = 0 ∧ j = 0 ∧ ell = 0 ∧ k = 0 then (1 : ℝ) else 0) := by
  rw [← modeZ_natCast L i, ← modeZ_natCast L j, ← modeZ_natCast L ell,
    ← modeZ_natCast L k, integral_four_modeZ L hL]
  have h₀ : (i : ℤ) + j + ell + k = 0 ↔
      i = 0 ∧ j = 0 ∧ ell = 0 ∧ k = 0 := by omega
  have h₁ : (i : ℤ) + j + ell - k = 0 ↔ i + j + ell = k := by omega
  have h₂ : (i : ℤ) + j - ell + k = 0 ↔
      (i : ℤ) + j - ell = -(k : ℤ) := by omega
  have h₃ : (i : ℤ) + j - ell - k = 0 ↔
      (i : ℤ) + j - ell = (k : ℤ) := by omega
  have h₄ : (i : ℤ) - j + ell + k = 0 ↔
      (i : ℤ) - j + ell = -(k : ℤ) := by omega
  have h₅ : (i : ℤ) - j + ell - k = 0 ↔
      (i : ℤ) - j + ell = (k : ℤ) := by omega
  have h₆ : (i : ℤ) - j - ell + k = 0 ↔
      (i : ℤ) - j - ell = -(k : ℤ) := by omega
  have h₇ : (i : ℤ) - j - ell - k = 0 ↔
      (i : ℤ) - j - ell = (k : ℤ) := by omega
  simp only [h₀, h₁, h₂, h₃, h₄, h₅, h₆, h₇]
  ring

/-- Finite nonnegative-index version of the first display in Lemma 2.3. -/
theorem integral_finset_bilinear_nat (L : ℝ) (hL : 0 < L)
    (s t : Finset ℕ) (u v : ℕ → ℝ) (k : ℕ) :
    (∫ x in (0 : ℝ)..L,
      (∑ i ∈ s, u i * mode L i x) *
        (∑ j ∈ t, v j * mode L j x) * mode L k x) =
      ∑ i ∈ s, ∑ j ∈ t, u i * v j *
        (L / 4 *
            ((if (i : ℤ) - (j : ℤ) = (k : ℤ) then (1 : ℝ) else 0) +
              (if (i : ℤ) - (j : ℤ) = -(k : ℤ) then (1 : ℝ) else 0) +
              (if i + j = k then (1 : ℝ) else 0)) +
          L / 4 * (if i = 0 ∧ j = 0 ∧ k = 0 then (1 : ℝ) else 0)) := by
  have hcont : ∀ m : ℕ, Continuous (mode L m) := by
    intro m
    unfold mode
    continuity
  have hterm : ∀ i j : ℕ, Continuous
      (fun x : ℝ => u i * v j * (mode L i x * mode L j x * mode L k x)) :=
    fun i j => continuous_const.mul (((hcont i).mul (hcont j)).mul (hcont k))
  have key : ∀ x : ℝ,
      (∑ i ∈ s, u i * mode L i x) *
          (∑ j ∈ t, v j * mode L j x) * mode L k x =
        ∑ i ∈ s, ∑ j ∈ t,
          u i * v j * (mode L i x * mode L j x * mode L k x) := by
    intro x
    rw [Finset.sum_mul_sum, Finset.sum_mul]
    refine Finset.sum_congr rfl (fun i _ => ?_)
    rw [Finset.sum_mul]
    exact Finset.sum_congr rfl (fun j _ => by ring)
  rw [intervalIntegral.integral_congr (fun x _ => key x)]
  rw [intervalIntegral.integral_finsetSum
      (fun i _ => (continuous_finsetSum _
        (fun j _ => hterm i j)).intervalIntegrable _ _)]
  refine Finset.sum_congr rfl (fun i _ => ?_)
  rw [intervalIntegral.integral_finsetSum
      (fun j _ => (hterm i j).intervalIntegrable _ _)]
  refine Finset.sum_congr rfl (fun j _ => ?_)
  rw [intervalIntegral.integral_const_mul, integral_triple_mode_nat L hL]

/-- Finite nonnegative-index version of the second display in Lemma 2.3. -/
theorem integral_finset_trilinear_nat (L : ℝ) (hL : 0 < L)
    (s t r : Finset ℕ) (u v w : ℕ → ℝ) (k : ℕ) :
    (∫ x in (0 : ℝ)..L,
      (∑ i ∈ s, u i * mode L i x) *
        (∑ j ∈ t, v j * mode L j x) *
        (∑ ell ∈ r, w ell * mode L ell x) * mode L k x) =
      ∑ ell ∈ r, ∑ j ∈ t, ∑ i ∈ s, u i * v j * w ell *
        (L / 8 *
            ((if i + j + ell = k then (1 : ℝ) else 0) +
              (if (i : ℤ) + j - ell = (k : ℤ) then (1 : ℝ) else 0) +
              (if (i : ℤ) + j - ell = -(k : ℤ) then (1 : ℝ) else 0) +
              (if (i : ℤ) - j + ell = (k : ℤ) then (1 : ℝ) else 0) +
              (if (i : ℤ) - j + ell = -(k : ℤ) then (1 : ℝ) else 0) +
              (if (i : ℤ) - j - ell = (k : ℤ) then (1 : ℝ) else 0) +
              (if (i : ℤ) - j - ell = -(k : ℤ) then (1 : ℝ) else 0)) +
          L / 8 *
            (if i = 0 ∧ j = 0 ∧ ell = 0 ∧ k = 0 then (1 : ℝ) else 0)) := by
  have hcont : ∀ m : ℕ, Continuous (mode L m) := by
    intro m
    unfold mode
    continuity
  have hterm : ∀ i j ell : ℕ, Continuous
      (fun x : ℝ => u i * v j * w ell *
        (mode L i x * mode L j x * mode L ell x * mode L k x)) :=
    fun i j ell => continuous_const.mul
      ((((hcont i).mul (hcont j)).mul (hcont ell)).mul (hcont k))
  have key : ∀ x : ℝ,
      (∑ i ∈ s, u i * mode L i x) *
          (∑ j ∈ t, v j * mode L j x) *
          (∑ ell ∈ r, w ell * mode L ell x) * mode L k x =
        ∑ ell ∈ r, ∑ j ∈ t, ∑ i ∈ s, u i * v j * w ell *
          (mode L i x * mode L j x * mode L ell x * mode L k x) := by
    intro x
    simp only [Finset.sum_mul, Finset.mul_sum]
    refine Finset.sum_congr rfl (fun ell _ => ?_)
    refine Finset.sum_congr rfl (fun j _ => ?_)
    exact Finset.sum_congr rfl (fun i _ => by ring)
  rw [intervalIntegral.integral_congr (fun x _ => key x)]
  rw [intervalIntegral.integral_finsetSum
      (fun ell _ => (continuous_finsetSum _ (fun j _ =>
        continuous_finsetSum _ (fun i _ => hterm i j ell))).intervalIntegrable
          _ _)]
  refine Finset.sum_congr rfl (fun ell _ => ?_)
  rw [intervalIntegral.integral_finsetSum
      (fun j _ => (continuous_finsetSum _
        (fun i _ => hterm i j ell)).intervalIntegrable _ _)]
  refine Finset.sum_congr rfl (fun j _ => ?_)
  rw [intervalIntegral.integral_finsetSum
      (fun i _ => (hterm i j ell).intervalIntegrable _ _)]
  refine Finset.sum_congr rfl (fun i _ => ?_)
  rw [intervalIntegral.integral_const_mul, integral_four_mode_nat L hL]

lemma sum_range_bilinear_zero_correction (N M k : ℕ) (u v : ℕ → ℝ)
    (c : ℝ) :
    (∑ i ∈ Finset.range (N + 1), ∑ j ∈ Finset.range (M + 1),
      u i * v j * (c *
        (if i = 0 ∧ j = 0 ∧ k = 0 then (1 : ℝ) else 0))) =
      c * (if k = 0 then u 0 * v 0 else 0) := by
  by_cases hk : k = 0
  · subst k
    rw [Finset.sum_eq_single 0]
    · rw [Finset.sum_eq_single 0]
      · simp
        ring
      · intro j _ hj
        simp [hj]
      · simp
    · intro i _ hi
      simp [hi]
    · simp
  · simp [hk]

lemma sum_range_trilinear_zero_correction (N M R k : ℕ)
    (u v w : ℕ → ℝ) (c : ℝ) :
    (∑ ell ∈ Finset.range (R + 1), ∑ j ∈ Finset.range (M + 1),
      ∑ i ∈ Finset.range (N + 1), u i * v j * w ell *
        (c * (if i = 0 ∧ j = 0 ∧ ell = 0 ∧ k = 0
          then (1 : ℝ) else 0))) =
      c * (if k = 0 then u 0 * v 0 * w 0 else 0) := by
  by_cases hk : k = 0
  · subst k
    rw [Finset.sum_eq_single 0]
    · rw [Finset.sum_eq_single 0]
      · rw [Finset.sum_eq_single 0]
        · simp
          ring
        · intro i _ hi
          simp [hi]
        · simp
      · intro j _ hj
        simp [hj]
      · simp
    · intro ell _ hell
      simp [hell]
    · simp
  · simp [hk]

/-- First display of Lemma 2.3 for finite truncations, with its three index
families and constant-mode correction separated exactly as in the paper. -/
theorem integral_range_bilinear_nat (L : ℝ) (hL : 0 < L)
    (N M : ℕ) (u v : ℕ → ℝ) (k : ℕ) :
    (∫ x in (0 : ℝ)..L,
      (∑ i ∈ Finset.range (N + 1), u i * mode L i x) *
        (∑ j ∈ Finset.range (M + 1), v j * mode L j x) * mode L k x) =
      (∑ i ∈ Finset.range (N + 1), ∑ j ∈ Finset.range (M + 1),
        u i * v j * (L / 4 *
          ((if (i : ℤ) - (j : ℤ) = (k : ℤ) then (1 : ℝ) else 0) +
            (if (i : ℤ) - (j : ℤ) = -(k : ℤ) then (1 : ℝ) else 0) +
            (if i + j = k then (1 : ℝ) else 0)))) +
        L / 4 * (if k = 0 then u 0 * v 0 else 0) := by
  rw [integral_finset_bilinear_nat L hL]
  simp_rw [mul_add, Finset.sum_add_distrib]
  rw [sum_range_bilinear_zero_correction]

/-- Second display of Lemma 2.3 for finite truncations, with its seven index
families and constant-mode correction separated exactly as in the paper. -/
theorem integral_range_trilinear_nat (L : ℝ) (hL : 0 < L)
    (N M R : ℕ) (u v w : ℕ → ℝ) (k : ℕ) :
    (∫ x in (0 : ℝ)..L,
      (∑ i ∈ Finset.range (N + 1), u i * mode L i x) *
        (∑ j ∈ Finset.range (M + 1), v j * mode L j x) *
        (∑ ell ∈ Finset.range (R + 1), w ell * mode L ell x) * mode L k x) =
      (∑ ell ∈ Finset.range (R + 1), ∑ j ∈ Finset.range (M + 1),
        ∑ i ∈ Finset.range (N + 1), u i * v j * w ell *
          (L / 8 *
            ((if i + j + ell = k then (1 : ℝ) else 0) +
              (if (i : ℤ) + j - ell = (k : ℤ) then (1 : ℝ) else 0) +
              (if (i : ℤ) + j - ell = -(k : ℤ) then (1 : ℝ) else 0) +
              (if (i : ℤ) - j + ell = (k : ℤ) then (1 : ℝ) else 0) +
              (if (i : ℤ) - j + ell = -(k : ℤ) then (1 : ℝ) else 0) +
              (if (i : ℤ) - j - ell = (k : ℤ) then (1 : ℝ) else 0) +
              (if (i : ℤ) - j - ell = -(k : ℤ) then (1 : ℝ) else 0)))) +
        L / 8 * (if k = 0 then u 0 * v 0 * w 0 else 0) := by
  rw [integral_finset_trilinear_nat L hL]
  simp_rw [mul_add, Finset.sum_add_distrib]
  rw [sum_range_trilinear_zero_correction]

end Paper3TrigFinite

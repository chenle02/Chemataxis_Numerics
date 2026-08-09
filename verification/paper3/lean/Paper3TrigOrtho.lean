import Mathlib

namespace Paper3TrigOrtho

open Real

noncomputable def mode (L : ℝ) (n : ℕ) (x : ℝ) : ℝ := Real.cos ((n * Real.pi / L) * x)

lemma integral_cos_linear (c L : ℝ) (hc : c ≠ 0) :
    (∫ x in (0:ℝ)..L, Real.cos (c * x)) = Real.sin (c * L) / c := by
  rw [intervalIntegral.integral_comp_mul_left (fun x => Real.cos x) hc, integral_cos]
  simp
  ring

lemma integral_cos_mode_int (L : ℝ) (hL : 0 < L) (j : ℤ) :
    (∫ x in (0:ℝ)..L, Real.cos (((j : ℝ) * Real.pi / L) * x)) = if j = 0 then L else 0 := by
  by_cases hj : j = 0
  · subst hj
    simp
  · rw [if_neg hj]
    have hj' : (j : ℝ) ≠ 0 := Int.cast_ne_zero.mpr hj
    have hc : (j : ℝ) * Real.pi / L ≠ 0 :=
      div_ne_zero (mul_ne_zero hj' (ne_of_gt Real.pi_pos)) (ne_of_gt hL)
    rw [integral_cos_linear _ _ hc]
    have hL' : L ≠ 0 := ne_of_gt hL
    have hstep : (j : ℝ) * Real.pi / L * L = (j : ℝ) * Real.pi := by field_simp
    rw [hstep, Real.sin_int_mul_pi]
    simp

theorem integral_mode_mul_mode (L : ℝ) (hL : 0 < L) (m n : ℕ) :
    (∫ x in (0:ℝ)..L, mode L m x * mode L n x)
      = if m = n then (if m = 0 then L else L / 2) else 0 := by
  have hL' : L ≠ 0 := ne_of_gt hL
  have key : ∀ x : ℝ, mode L m x * mode L n x
      = (Real.cos ((((m : ℤ) - (n : ℤ) : ℤ) : ℝ) * Real.pi / L * x)
         + Real.cos ((((m : ℤ) + (n : ℤ) : ℤ) : ℝ) * Real.pi / L * x)) / 2 := by
    intro x
    unfold mode
    have c1 : ((((m : ℤ) - (n : ℤ) : ℤ) : ℝ)) = (m : ℝ) - (n : ℝ) := by push_cast; ring
    have c2 : ((((m : ℤ) + (n : ℤ) : ℤ) : ℝ)) = (m : ℝ) + (n : ℝ) := by push_cast; ring
    rw [c1, c2]
    have e1 : ((m : ℝ) - (n : ℝ)) * Real.pi / L * x
        = (m : ℝ) * Real.pi / L * x - (n : ℝ) * Real.pi / L * x := by field_simp
    have e2 : ((m : ℝ) + (n : ℝ)) * Real.pi / L * x
        = (m : ℝ) * Real.pi / L * x + (n : ℝ) * Real.pi / L * x := by field_simp
    rw [e1, e2, Real.cos_sub, Real.cos_add]
    ring
  have hcont1 : Continuous fun x : ℝ =>
      Real.cos (((((m : ℤ) - (n : ℤ) : ℤ) : ℝ)) * Real.pi / L * x) := by continuity
  have hcont2 : Continuous fun x : ℝ =>
      Real.cos (((((m : ℤ) + (n : ℤ) : ℤ) : ℝ)) * Real.pi / L * x) := by continuity
  rw [intervalIntegral.integral_congr (g := fun x =>
        (Real.cos (((((m : ℤ) - (n : ℤ) : ℤ) : ℝ)) * Real.pi / L * x)
         + Real.cos (((((m : ℤ) + (n : ℤ) : ℤ) : ℝ)) * Real.pi / L * x)) / 2)
        (fun x _ => key x)]
  rw [intervalIntegral.integral_div,
      intervalIntegral.integral_add
        (hcont1.intervalIntegrable _ _) (hcont2.intervalIntegrable _ _),
      integral_cos_mode_int L hL, integral_cos_mode_int L hL]
  by_cases hmn : m = n
  · subst hmn
    by_cases hm : m = 0
    · subst hm; norm_num
    · have hsum : ((m : ℤ) + (m : ℤ)) ≠ 0 := by
        have hm' : (m : ℤ) ≠ 0 := Int.natCast_ne_zero.mpr hm
        omega
      simp [hsum, hm]
  · have hdiff : ((m : ℤ) - (n : ℤ)) ≠ 0 := by
      intro h
      exact hmn (by exact_mod_cast sub_eq_zero.mp h)
    have hsum : ((m : ℤ) + (n : ℤ)) ≠ 0 := by
      rcases Nat.eq_zero_or_pos m with hm | hm
      · rcases Nat.eq_zero_or_pos n with hn | hn
        · exact absurd (hm.trans hn.symm) hmn
        · omega
      · omega
    simp [hdiff, hsum, hmn]

/-- Integer-indexed Neumann cosine mode. `cos` is even, so `modeZ L (-j) = modeZ L j`;
working over `ℤ` keeps `i - j` honest instead of truncating it in `ℕ`. -/
noncomputable def modeZ (L : ℝ) (j : ℤ) (x : ℝ) : ℝ := Real.cos (((j : ℝ) * Real.pi / L) * x)

lemma modeZ_natCast (L : ℝ) (n : ℕ) : modeZ L (n : ℤ) = mode L n := by
  funext x
  unfold modeZ mode
  norm_num

/-- **Triple-product integral of Neumann cosine modes.**

This is the bilinear engine of `L:trig-integrals`: expanding the two cosine
series and integrating termwise reduces every term to this. The manuscript's own
three-cosine product-to-sum identity turns the integrand into four single modes
indexed by `i+j+k`, `i+j-k`, `i-j+k`, `i-j-k`, and each integral survives only
when its index vanishes.

For `i, j, k ≥ 0` the four indicators are exactly the manuscript's three index
sets `i+j = k`, `i-j = -k`, `i-j = k`, plus the `i = j = k = 0` term, which is
precisely the `1_{k=0} u₀v₀` correction appearing in the displayed formula. -/
theorem integral_triple_modeZ (L : ℝ) (hL : 0 < L) (i j k : ℤ) :
    (∫ x in (0:ℝ)..L, modeZ L i x * modeZ L j x * modeZ L k x)
      = L / 4 * ((if i + j + k = 0 then (1:ℝ) else 0)
               + (if i + j - k = 0 then (1:ℝ) else 0)
               + (if i - j + k = 0 then (1:ℝ) else 0)
               + (if i - j - k = 0 then (1:ℝ) else 0)) := by
  have hLne : L ≠ 0 := ne_of_gt hL
  have key : ∀ x : ℝ, modeZ L i x * modeZ L j x * modeZ L k x
      = (Real.cos ((((i + j + k : ℤ) : ℝ) * Real.pi / L) * x)
        + Real.cos ((((i + j - k : ℤ) : ℝ) * Real.pi / L) * x)
        + Real.cos ((((i - j + k : ℤ) : ℝ) * Real.pi / L) * x)
        + Real.cos ((((i - j - k : ℤ) : ℝ) * Real.pi / L) * x)) / 4 := by
    intro x
    unfold modeZ
    push_cast
    have hi : ((i : ℝ) + (j : ℝ) + (k : ℝ)) * Real.pi / L * x
        = (i : ℝ) * Real.pi / L * x + (j : ℝ) * Real.pi / L * x + (k : ℝ) * Real.pi / L * x := by
      field_simp
    have hij : ((i : ℝ) + (j : ℝ) - (k : ℝ)) * Real.pi / L * x
        = (i : ℝ) * Real.pi / L * x + (j : ℝ) * Real.pi / L * x - (k : ℝ) * Real.pi / L * x := by
      field_simp
    have hik : ((i : ℝ) - (j : ℝ) + (k : ℝ)) * Real.pi / L * x
        = (i : ℝ) * Real.pi / L * x - (j : ℝ) * Real.pi / L * x + (k : ℝ) * Real.pi / L * x := by
      field_simp
    have hjk : ((i : ℝ) - (j : ℝ) - (k : ℝ)) * Real.pi / L * x
        = (i : ℝ) * Real.pi / L * x - (j : ℝ) * Real.pi / L * x - (k : ℝ) * Real.pi / L * x := by
      field_simp
    rw [hi, hij, hik, hjk]
    simp only [Real.cos_add, Real.cos_sub]
    ring
  have hcont : ∀ m : ℤ, Continuous fun x : ℝ =>
      Real.cos ((((m : ℤ) : ℝ) * Real.pi / L) * x) := by
    intro m; continuity
  have hI : ∀ m : ℤ, IntervalIntegrable
      (fun x : ℝ => Real.cos ((((m : ℤ) : ℝ) * Real.pi / L) * x))
      MeasureTheory.volume 0 L := fun m => (hcont m).intervalIntegrable _ _
  rw [intervalIntegral.integral_congr (g := fun x =>
      (Real.cos ((((i + j + k : ℤ) : ℝ) * Real.pi / L) * x)
      + Real.cos ((((i + j - k : ℤ) : ℝ) * Real.pi / L) * x)
      + Real.cos ((((i - j + k : ℤ) : ℝ) * Real.pi / L) * x)
      + Real.cos ((((i - j - k : ℤ) : ℝ) * Real.pi / L) * x)) / 4)
      (fun x _ => key x)]
  rw [intervalIntegral.integral_div,
      intervalIntegral.integral_add (((hI _).add (hI _)).add (hI _)) (hI _),
      intervalIntegral.integral_add ((hI _).add (hI _)) (hI _),
      intervalIntegral.integral_add (hI _) (hI _),
      integral_cos_mode_int L hL, integral_cos_mode_int L hL,
      integral_cos_mode_int L hL, integral_cos_mode_int L hL]
  split_ifs <;> ring

/-- **Finite-support bilinear case of `L:trig-integrals`.**

Two cosine series with finitely many nonzero coefficients, integrated against a
third mode. Expanding the product and integrating termwise reduces every term to
`integral_triple_modeZ`.

This is the finite-support version of the lemma's first display. The manuscript
states it for `ell^1` coefficient sequences; that generality needs an
integral/`tsum` interchange which is NOT proved here (README claim boundary 5).
The finite case is what the paper's own applications use, since they instantiate
at concrete low-mode expansions. -/
theorem integral_finset_bilinear (L : ℝ) (hL : 0 < L) (s t : Finset ℤ)
    (u v : ℤ → ℝ) (k : ℤ) :
    (∫ x in (0:ℝ)..L,
        (∑ i ∈ s, u i * modeZ L i x) * (∑ j ∈ t, v j * modeZ L j x) * modeZ L k x)
      = ∑ i ∈ s, ∑ j ∈ t, u i * v j * (L / 4 *
          ((if i + j + k = 0 then (1:ℝ) else 0)
         + (if i + j - k = 0 then (1:ℝ) else 0)
         + (if i - j + k = 0 then (1:ℝ) else 0)
         + (if i - j - k = 0 then (1:ℝ) else 0))) := by
  have hcontZ : ∀ m : ℤ, Continuous (modeZ L m) := by
    intro m; unfold modeZ; continuity
  have hterm : ∀ i j : ℤ, Continuous
      (fun x : ℝ => u i * v j * (modeZ L i x * modeZ L j x * modeZ L k x)) :=
    fun i j => continuous_const.mul (((hcontZ i).mul (hcontZ j)).mul (hcontZ k))
  have key : ∀ x : ℝ,
      (∑ i ∈ s, u i * modeZ L i x) * (∑ j ∈ t, v j * modeZ L j x) * modeZ L k x
      = ∑ i ∈ s, ∑ j ∈ t, u i * v j * (modeZ L i x * modeZ L j x * modeZ L k x) := by
    intro x
    rw [Finset.sum_mul_sum, Finset.sum_mul]
    refine Finset.sum_congr rfl (fun i _ => ?_)
    rw [Finset.sum_mul]
    exact Finset.sum_congr rfl (fun j _ => by ring)
  rw [intervalIntegral.integral_congr (fun x _ => key x)]
  rw [intervalIntegral.integral_finsetSum
        (fun i _ => (continuous_finsetSum _ (fun j _ => hterm i j)).intervalIntegrable _ _)]
  refine Finset.sum_congr rfl (fun i _ => ?_)
  rw [intervalIntegral.integral_finsetSum
        (fun j _ => (hterm i j).intervalIntegrable _ _)]
  refine Finset.sum_congr rfl (fun j _ => ?_)
  rw [intervalIntegral.integral_const_mul, integral_triple_modeZ L hL]

end Paper3TrigOrtho

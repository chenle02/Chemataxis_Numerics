/-
# Paper III -- manuscript-facing projected modal ODE coefficients

This file converts the absolutely convergent cosine integral identities into
the exact normalized quadratic and cubic logistic coefficients displayed in
equation (3.14b).  It also checks the cancellation in the definition (3.15)
of the residual chemotactic coupling.  The parabolic time differentiation and
the function-valued Taylor remainders remain analytic inputs.
-/

import Paper3ModalEquation

namespace Paper3ModalODE

open Paper3TrigInfinite Paper3ModalEquation

/-- The certified bilinear integral summands collect to `L/4` times the raw
three-family sum used in the positive-mode ODE. -/
theorem tsum_bilinearMain_self_eq (L : ℝ) (u : ℕ → ℝ) (k : ℕ) :
    (∑' z : ℕ × ℕ, bilinearMain L u u k z) =
      L / 4 * bilinearIndexSum u k := by
  unfold bilinearIndexSum
  rw [← tsum_mul_left]
  apply tsum_congr
  intro z
  exact bilinearMain_self_eq L u k z

/-- The certified trilinear integral summands collect to `L/8` times the raw
seven-family sum used in the positive-mode ODE. -/
theorem tsum_trilinearMain_self_eq (L : ℝ) (u : ℕ → ℝ) (k : ℕ) :
    (∑' z : (ℕ × ℕ) × ℕ, trilinearMain L u u u k z) =
      L / 8 * trilinearIndexSum u k := by
  unfold trilinearIndexSum
  rw [← tsum_mul_left]
  apply tsum_congr
  intro z
  exact trilinearMain_self_eq L u k z

/-- The zero-mode specialization of the raw three-family summand. -/
noncomputable def bilinearZeroSummand (u : ℕ → ℝ) (z : ℕ × ℕ) : ℝ :=
  u z.1 * u z.2 *
    ((if (z.1 : ℤ) - z.2 = 0 then (1 : ℝ) else 0) +
      (if (z.1 : ℤ) - z.2 = 0 then (1 : ℝ) else 0) +
      (if z.1 + z.2 = 0 then (1 : ℝ) else 0))

lemma bilinearZeroSummand_off_diag
    (u : ℕ → ℝ) (i j : ℕ) (hij : j ≠ i) :
    bilinearZeroSummand u (i, j) = 0 := by
  unfold bilinearZeroSummand
  have hsub : (i : ℤ) - j ≠ 0 := by omega
  by_cases hi : i = 0
  · by_cases hj : j = 0
    · exact False.elim (hij (hj.trans hi.symm))
    · simp [hi, hj]
  · simp [hsub, hi]

lemma bilinearZeroSummand_diag (u : ℕ → ℝ) (i : ℕ) :
    bilinearZeroSummand u (i, i) =
      2 * u i ^ 2 + if i = 0 then u 0 ^ 2 else 0 := by
  unfold bilinearZeroSummand
  by_cases hi : i = 0
  · subst i
    norm_num
    ring
  · simp [hi]
    ring

lemma summable_square (u : ℕ → ℝ) (hu : Summable fun n => |u n|) :
    Summable fun n => u n ^ 2 := by
  have hprod : Summable fun z : ℕ × ℕ => |u z.1| * |u z.2| :=
    hu.mul_of_nonneg hu (fun _ => abs_nonneg _) (fun _ => abs_nonneg _)
  have hdiag := hprod.comp_injective
    (i := fun n : ℕ => (n, n)) (by intro i j h; simpa using h)
  simpa [Function.comp_def, sq, abs_mul_self] using hdiag

lemma summable_bilinearZeroSummand (u : ℕ → ℝ)
    (hu : Summable fun n => |u n|) :
    Summable (bilinearZeroSummand u) := by
  have heq : bilinearZeroSummand u = bilinearMain (4 : ℝ) u u 0 := by
    funext z
    unfold bilinearZeroSummand bilinearMain
    norm_num
  rw [heq]
  exact summable_bilinearMain 4 u u hu hu 0

/-- At the constant mode, the three indicator families collect to twice the
full square sum plus the extra all-zero contribution. -/
theorem bilinearIndexSum_zero_eq (u : ℕ → ℝ)
    (hu : Summable fun n => |u n|) :
    bilinearIndexSum u 0 = 2 * (∑' n, u n ^ 2) + u 0 ^ 2 := by
  have hraw := summable_bilinearZeroSummand u hu
  have hinner : ∀ i : ℕ, (∑' j : ℕ, bilinearZeroSummand u (i, j)) =
      2 * u i ^ 2 + if i = 0 then u 0 ^ 2 else 0 := by
    intro i
    rw [tsum_eq_single i]
    · exact bilinearZeroSummand_diag u i
    · intro j hji
      exact bilinearZeroSummand_off_diag u i j hji
  have hsq := summable_square u hu
  have htwo : Summable fun i => 2 * u i ^ 2 := hsq.mul_left 2
  have hzero : Summable fun i : ℕ => if i = 0 then u 0 ^ 2 else 0 := by
    apply summable_of_ne_finset_zero (s := {0})
    intro i hi
    simp only [Finset.mem_singleton] at hi
    simp [hi]
  have hzero_tsum : (∑' i : ℕ, if i = 0 then u 0 ^ 2 else 0) = u 0 ^ 2 := by
    rw [tsum_eq_single 0]
    · simp
    · intro i hi
      simp [hi]
  change (∑' z : ℕ × ℕ, bilinearZeroSummand u z) = _
  rw [hraw.tsum_prod]
  simp_rw [hinner]
  rw [htwo.tsum_add hzero, tsum_mul_left, hzero_tsum]

/-- Sum of the squares of the positive-mode coefficients. -/
noncomputable def positiveSquareSum (u : ℕ → ℝ) : ℝ :=
  ∑' n : ℕ, u (n + 1) ^ 2

lemma square_tsum_eq_zero_add_positive (u : ℕ → ℝ)
    (hu : Summable fun n => |u n|) :
    (∑' n : ℕ, u n ^ 2) = u 0 ^ 2 + positiveSquareSum u := by
  have hsplit := (summable_square u hu).sum_add_tsum_nat_add 1
  unfold positiveSquareSum
  simpa using hsplit.symm

/-- Equation (3.14a), quadratic part: the constant-mode projection is exactly
`u0^2 + (1/2) * sum_{i>=1} ui^2` after division by the interval length. -/
theorem average_mode_quadratic_projection
    (L q2 : ℝ) (hL : 0 < L) (u : ℕ → ℝ)
    (hu : Summable fun n => |u n|) :
    1 / L * (-(q2 / 2) *
      (∫ x in (0 : ℝ)..L,
        cosineSeries L u x * cosineSeries L u x)) =
      -(q2 / 2) * (u 0 ^ 2 + positiveSquareSum u / 2) := by
  have hint := integral_cosineSeries_bilinear L hL u u hu hu 0
  simp only [Paper3TrigOrtho.mode, Nat.cast_zero, zero_mul, zero_div,
    Real.cos_zero, mul_one, if_true] at hint
  rw [hint, tsum_bilinearMain_self_eq, bilinearIndexSum_zero_eq u hu,
    square_tsum_eq_zero_add_positive u hu]
  field_simp [hL.ne']
  ring

/-- The normalized positive-mode projection of the quadratic logistic Taylor
term has exactly the coefficient `-q2/4` in equation (3.14b). -/
theorem positive_mode_quadratic_projection
    (L q2 : ℝ) (hL : 0 < L) (u : ℕ → ℝ)
    (hu : Summable fun n => |u n|) (k : ℕ) (hk : k ≠ 0) :
    2 / L * (-(q2 / 2) *
      (∫ x in (0 : ℝ)..L,
        cosineSeries L u x * cosineSeries L u x *
          Paper3TrigOrtho.mode L k x)) =
      -(q2 / 4) * bilinearIndexSum u k := by
  rw [integral_cosineSeries_bilinear L hL u u hu hu k]
  simp only [hk, if_false, mul_zero, add_zero]
  rw [tsum_bilinearMain_self_eq]
  field_simp [ne_of_gt hL]

/-- The normalized positive-mode projection of the cubic logistic Taylor term
has exactly the coefficient `-q3/24` in equation (3.14b). -/
theorem positive_mode_cubic_projection
    (L q3 : ℝ) (hL : 0 < L) (u : ℕ → ℝ)
    (hu : Summable fun n => |u n|) (k : ℕ) (hk : k ≠ 0) :
    2 / L * (-(q3 / 6) *
      (∫ x in (0 : ℝ)..L,
        cosineSeries L u x * cosineSeries L u x *
          cosineSeries L u x * Paper3TrigOrtho.mode L k x)) =
      -(q3 / 24) * trilinearIndexSum u k := by
  rw [integral_cosineSeries_trilinear L hL u u u hu hu hu k]
  simp only [hk, if_false, mul_zero, add_zero]
  rw [tsum_trilinearMain_self_eq]
  field_simp [ne_of_gt hL]
  ring

/-- In equation (3.15), the common factor `chi` in the four projected
chemotactic terms cancels from the quotient under the manuscript's local
positivity assumptions. -/
theorem chemotactic_quotient_cancels
    (L chi projected coupling linear : ℝ)
    (hL : L ≠ 0) (hchi : chi ≠ 0)
    (hprojected : projected = chi * coupling) :
    2 / (L * chi) * projected - linear =
      2 / L * coupling - linear := by
  rw [hprojected]
  field_simp [hL, hchi]

/-- Positivity of the length and critical sensitivity supplies the two
nonzero hypotheses required by the cancellation theorem. -/
theorem chemotactic_quotient_cancels_of_pos
    (L chi projected coupling linear : ℝ)
    (hL : 0 < L) (hchi : 0 < chi)
    (hprojected : projected = chi * coupling) :
    2 / (L * chi) * projected - linear =
      2 / L * coupling - linear := by
  exact chemotactic_quotient_cancels L chi projected coupling linear
    hL.ne' hchi.ne' hprojected

end Paper3ModalODE

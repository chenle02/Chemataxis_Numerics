/-
# Paper III -- manuscript-facing elliptic modal equation

This file closes the final algebraic bridge from the bilinear/trilinear cosine
projections to equation (3.9).  The integral and infinite-sum interchanges are
proved in `Paper3TrigInfinite`; here the three- and seven-family indicator sums
are placed into the exact elliptic residual and solved with an explicit
nonzero-denominator hypothesis.
-/

import Paper3TrigInfinite

namespace Paper3ModalEquation

/-- The three index families in the quadratic part of equation (3.9). -/
noncomputable def bilinearIndexSum (u : ℕ → ℝ) (k : ℕ) : ℝ :=
  ∑' z : ℕ × ℕ, u z.1 * u z.2 *
    ((if (z.1 : ℤ) - z.2 = (k : ℤ) then (1 : ℝ) else 0) +
      (if (z.1 : ℤ) - z.2 = -(k : ℤ) then (1 : ℝ) else 0) +
      (if z.1 + z.2 = k then (1 : ℝ) else 0))

/-- The seven index families in the cubic part of equation (3.9). -/
noncomputable def trilinearIndexSum (u : ℕ → ℝ) (k : ℕ) : ℝ :=
  ∑' z : (ℕ × ℕ) × ℕ, u z.1.1 * u z.1.2 * u z.2 *
    ((if z.1.1 + z.1.2 + z.2 = k then (1 : ℝ) else 0) +
      (if (z.1.1 : ℤ) + z.1.2 - z.2 = (k : ℤ) then (1 : ℝ) else 0) +
      (if (z.1.1 : ℤ) + z.1.2 - z.2 = -(k : ℤ) then (1 : ℝ) else 0) +
      (if (z.1.1 : ℤ) - z.1.2 + z.2 = (k : ℤ) then (1 : ℝ) else 0) +
      (if (z.1.1 : ℤ) - z.1.2 + z.2 = -(k : ℤ) then (1 : ℝ) else 0) +
      (if (z.1.1 : ℤ) - z.1.2 - z.2 = (k : ℤ) then (1 : ℝ) else 0) +
      (if (z.1.1 : ℤ) - z.1.2 - z.2 = -(k : ℤ) then (1 : ℝ) else 0))

/-- The `L/4` bilinear integrand collected in Lemma 2.3 is exactly `L/4`
times the raw three-family summand used in equation (3.9). -/
theorem bilinearMain_self_eq (L : ℝ) (u : ℕ → ℝ) (k : ℕ) (z : ℕ × ℕ) :
    Paper3TrigInfinite.bilinearMain L u u k z =
      L / 4 * (u z.1 * u z.2 *
        ((if (z.1 : ℤ) - z.2 = (k : ℤ) then (1 : ℝ) else 0) +
          (if (z.1 : ℤ) - z.2 = -(k : ℤ) then (1 : ℝ) else 0) +
          (if z.1 + z.2 = k then (1 : ℝ) else 0))) := by
  unfold Paper3TrigInfinite.bilinearMain
  ring

/-- The `L/8` trilinear integrand is exactly `L/8` times the raw seven-family
summand used in equation (3.9). -/
theorem trilinearMain_self_eq
    (L : ℝ) (u : ℕ → ℝ) (k : ℕ) (z : (ℕ × ℕ) × ℕ) :
    Paper3TrigInfinite.trilinearMain L u u u k z =
      L / 8 * (u z.1.1 * u z.1.2 * u z.2 *
        ((if z.1.1 + z.1.2 + z.2 = k then (1 : ℝ) else 0) +
          (if (z.1.1 : ℤ) + z.1.2 - z.2 = (k : ℤ) then (1 : ℝ) else 0) +
          (if (z.1.1 : ℤ) + z.1.2 - z.2 = -(k : ℤ) then (1 : ℝ) else 0) +
          (if (z.1.1 : ℤ) - z.1.2 + z.2 = (k : ℤ) then (1 : ℝ) else 0) +
          (if (z.1.1 : ℤ) - z.1.2 + z.2 = -(k : ℤ) then (1 : ℝ) else 0) +
          (if (z.1.1 : ℤ) - z.1.2 - z.2 = (k : ℤ) then (1 : ℝ) else 0) +
          (if (z.1.1 : ℤ) - z.1.2 - z.2 = -(k : ℤ) then (1 : ℝ) else 0))) := by
  unfold Paper3TrigInfinite.trilinearMain
  ring

/-- Exact numerator in equation (3.9).  `c1`, `c2`, and `c3` denote the
undivided first, second, and third scalar derivatives of the signal production
term, so the normalized cosine projections produce the factors `1/4` and
`1/24`. -/
noncomputable def ellipticModeNumerator
    (c1 c2 c3 : ℝ) (u : ℕ → ℝ) (k : ℕ) : ℝ :=
  c1 * u k + c2 / 4 * bilinearIndexSum u k +
    c3 / 24 * trilinearIndexSum u k

/-- Equation (3.9): solving the projected elliptic residual gives the displayed
positive-mode coefficient formula. -/
theorem elliptic_mode_solution (lam mu c1 c2 c3 vk : ℝ)
    (u : ℕ → ℝ) (k : ℕ) (hden : lam + mu ≠ 0)
    (hresidual :
      -(lam + mu) * vk + ellipticModeNumerator c1 c2 c3 u k = 0) :
    vk = 1 / (lam + mu) *
      (c1 * u k + c2 / 4 * bilinearIndexSum u k +
        c3 / 24 * trilinearIndexSum u k) := by
  unfold ellipticModeNumerator at hresidual
  field_simp [hden]
  nlinarith

/-- Under positive spectral parameters, the denominator required by the
manuscript-facing solve theorem is automatic. -/
theorem elliptic_mode_denominator_ne_zero (lam mu : ℝ)
    (hlam : 0 ≤ lam) (hmu : 0 < mu) :
    lam + mu ≠ 0 := by
  positivity

end Paper3ModalEquation

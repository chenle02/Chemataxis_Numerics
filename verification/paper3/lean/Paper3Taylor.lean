/-
# Paper III -- scalar Taylor coefficients

This file checks the scalar zeroth-through-third derivatives that generate the
coefficients in equations (3.2) and (3.3).  It does not formalize the
function-valued fourth-order remainder estimates.
-/

import Mathlib

namespace Paper3Taylor

/-- First derivative of a real power at a positive base. -/
theorem rpow_first (r x : ℝ) :
    deriv (fun y : ℝ => y ^ r) x = r * x ^ (r - 1) := by
  exact Real.deriv_rpow_const x r

/-- Second derivative of a real power, in the falling-factorial form used by
the manuscript's quadratic Taylor coefficients. -/
theorem rpow_second (r x : ℝ) :
    deriv^[2] (fun y : ℝ => y ^ r) x =
      r * (r - 1) * x ^ (r - 2) := by
  rw [Real.iter_deriv_rpow_const]
  have hpoch : (descPochhammer ℝ 2).eval r = r * (r - 1) := by
    norm_num [descPochhammer]
  rw [hpoch]
  norm_num

/-- Third derivative of a real power, in the falling-factorial form used by
the manuscript's cubic Taylor coefficients. -/
theorem rpow_third (r x : ℝ) :
    deriv^[3] (fun y : ℝ => y ^ r) x =
      r * (r - 1) * (r - 2) * x ^ (r - 3) := by
  rw [Real.iter_deriv_rpow_const]
  have hpoch : (descPochhammer ℝ 3).eval r = r * (r - 1) * (r - 2) := by
    norm_num [descPochhammer]
    ring
  rw [hpoch]
  norm_num

/-- The three sensitivity-weight derivatives for exponent `-beta`, including
the alternating signs in equation (3.2). -/
theorem sensitivity_weight_derivatives (beta w : ℝ) :
    deriv (fun y : ℝ => y ^ (-beta)) w =
        -beta * w ^ (-beta - 1) ∧
    deriv^[2] (fun y : ℝ => y ^ (-beta)) w =
        beta * (beta + 1) * w ^ (-beta - 2) ∧
    deriv^[3] (fun y : ℝ => y ^ (-beta)) w =
        -beta * (beta + 1) * (beta + 2) * w ^ (-beta - 3) := by
  constructor
  · simpa using rpow_first (-beta) w
  constructor
  · rw [rpow_second]
    ring
  · rw [rpow_third]
    ring

/-- The density-mobility derivatives producing the `m`, `m(m-1)`, and
`m(m-1)(m-2)` coefficients in equation (3.2). -/
theorem mobility_density_derivatives (m u : ℝ) :
    deriv (fun y : ℝ => y ^ m) u = m * u ^ (m - 1) ∧
    deriv^[2] (fun y : ℝ => y ^ m) u =
        m * (m - 1) * u ^ (m - 2) ∧
    deriv^[3] (fun y : ℝ => y ^ m) u =
        m * (m - 1) * (m - 2) * u ^ (m - 3) := by
  exact ⟨rpow_first m u, rpow_second m u, rpow_third m u⟩

/-- The signal-production derivatives producing the `gamma` coefficients in
equation (3.3). -/
theorem signal_derivatives (gamma u : ℝ) :
    deriv (fun y : ℝ => y ^ gamma) u = gamma * u ^ (gamma - 1) ∧
    deriv^[2] (fun y : ℝ => y ^ gamma) u =
        gamma * (gamma - 1) * u ^ (gamma - 2) ∧
    deriv^[3] (fun y : ℝ => y ^ gamma) u =
        gamma * (gamma - 1) * (gamma - 2) * u ^ (gamma - 3) := by
  exact ⟨rpow_first gamma u, rpow_second gamma u, rpow_third gamma u⟩

/-- The logistic derivatives for exponent `1+alpha`, including the exact
linear, quadratic, and cubic factors in equation (3.2). -/
theorem logistic_derivatives (alpha u : ℝ) :
    deriv (fun y : ℝ => y ^ (1 + alpha)) u =
        (1 + alpha) * u ^ alpha ∧
    deriv^[2] (fun y : ℝ => y ^ (1 + alpha)) u =
        (1 + alpha) * alpha * u ^ (alpha - 1) ∧
    deriv^[3] (fun y : ℝ => y ^ (1 + alpha)) u =
        (1 + alpha) * alpha * (alpha - 1) * u ^ (alpha - 2) := by
  constructor
  · rw [rpow_first]
    ring_nf
  constructor
  · rw [rpow_second]
    ring_nf
  · rw [rpow_third]
    ring_nf

/-- The factorial divisions in the displayed Taylor polynomials are exactly
`1/2` and `1/6`. -/
theorem taylor_factorial_normalization (c₁ c₂ c₃ : ℝ) :
    c₁ + c₂ / (2 : ℝ) + c₃ / (6 : ℝ) =
      c₁ + (1 / 2 : ℝ) * c₂ + (1 / 6 : ℝ) * c₃ := by
  ring

end Paper3Taylor

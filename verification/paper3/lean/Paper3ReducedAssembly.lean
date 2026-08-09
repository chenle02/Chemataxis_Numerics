/-
# Paper III -- finite reduced cubic channel assembly

This file completes the finite coefficient chain by projecting the quadratic
and cubic logistic harmonics on the center graph and assembling them with the
independently projected chemotactic cubic coefficient.
-/

import Paper3QuadraticProjection

namespace Paper3ReducedAssembly

/-- Order-three part of the squared center-graph state. -/
noncomputable def quadraticCenterCubic (p0 p2 theta : ℝ) : ℝ :=
  2 * p0 * Real.cos theta +
    (2 * p2) * (Real.cos theta * Real.cos (2 * theta))

theorem quadraticCenterCubic_decomposition (p0 p2 theta : ℝ) :
    quadraticCenterCubic p0 p2 theta =
      (2 * p0 + p2) * Real.cos theta + p2 * Real.cos (3 * theta) := by
  unfold quadraticCenterCubic
  rw [show Real.cos theta * Real.cos (2 * theta) =
      (Real.cos (3 * theta) + Real.cos theta) / 2 by
        calc
          Real.cos theta * Real.cos (2 * theta) =
              (Real.cos (theta + 2 * theta) +
                Real.cos (theta - 2 * theta)) / 2 := by
            rw [Real.cos_add, Real.cos_sub]
            ring_nf
          _ = (Real.cos (3 * theta) + Real.cos theta) / 2 := by
            rw [show theta - 2 * theta = -theta by ring_nf, Real.cos_neg]
            ring_nf]
  ring_nf

/-- Normalized critical projection of the quadratic center-graph channel. -/
theorem normalized_quadratic_logistic_projection (L : ℝ) (n : ℕ)
    (hL : 0 < L) (hn : 0 < n) (p0 p2 : ℝ) :
    2 / L * (∫ x in (0 : ℝ)..L,
      quadraticCenterCubic p0 p2
        (Paper3Eigenmodes.waveNumber L n * x) *
          Paper3TrigOrtho.mode L n x) = 2 * p0 + p2 := by
  have hfun : (fun x : ℝ => quadraticCenterCubic p0 p2
      (Paper3Eigenmodes.waveNumber L n * x)) = fun x =>
      (2 * p0 + p2) * Paper3TrigOrtho.mode L n x +
        p2 * Paper3TrigOrtho.mode L (3 * n) x := by
    funext x
    rw [quadraticCenterCubic_decomposition]
    unfold Paper3Eigenmodes.waveNumber Paper3TrigOrtho.mode
    push_cast
    ring_nf
  rw [show (fun x : ℝ => quadraticCenterCubic p0 p2
        (Paper3Eigenmodes.waveNumber L n * x) *
          Paper3TrigOrtho.mode L n x) = fun x =>
      (2 * p0 + p2) *
          (Paper3TrigOrtho.mode L n x * Paper3TrigOrtho.mode L n x) +
        p2 * (Paper3TrigOrtho.mode L (3 * n) x *
          Paper3TrigOrtho.mode L n x) by
      funext x
      rw [show quadraticCenterCubic p0 p2
        (Paper3Eigenmodes.waveNumber L n * x) =
          (2 * p0 + p2) * Paper3TrigOrtho.mode L n x +
            p2 * Paper3TrigOrtho.mode L (3 * n) x from congrFun hfun x]
      ring_nf]
  have hcont : ∀ m : ℕ, Continuous (Paper3TrigOrtho.mode L m) := by
    intro m
    unfold Paper3TrigOrtho.mode
    continuity
  rw [intervalIntegral.integral_add
      (f := fun x => (2 * p0 + p2) *
        (Paper3TrigOrtho.mode L n x * Paper3TrigOrtho.mode L n x))
      (g := fun x => p2 *
        (Paper3TrigOrtho.mode L (3 * n) x * Paper3TrigOrtho.mode L n x))
      ((continuous_const.mul ((hcont n).mul (hcont n))).intervalIntegrable _ _)
      ((continuous_const.mul ((hcont (3 * n)).mul (hcont n))).intervalIntegrable _ _),
    intervalIntegral.integral_const_mul,
    intervalIntegral.integral_const_mul,
    Paper3TrigOrtho.integral_mode_mul_mode L hL,
    Paper3TrigOrtho.integral_mode_mul_mode L hL]
  have hn0 : n ≠ 0 := Nat.ne_of_gt hn
  have h3n : 3 * n ≠ n := by omega
  simp [hn0, h3n]
  field_simp [ne_of_gt hL]

theorem cosine_cube_decomposition (theta : ℝ) :
    Real.cos theta ^ 3 =
      (3 * Real.cos theta + Real.cos (3 * theta)) / 4 := by
  rw [Real.cos_three_mul]
  ring_nf

/-- Normalized critical projection of the bare cubic state. -/
theorem normalized_cubic_logistic_projection (L : ℝ) (n : ℕ)
    (hL : 0 < L) (hn : 0 < n) :
    2 / L * (∫ x in (0 : ℝ)..L,
      Paper3TrigOrtho.mode L n x ^ 3 * Paper3TrigOrtho.mode L n x) = 3 / 4 := by
  rw [show (fun x : ℝ => Paper3TrigOrtho.mode L n x ^ 3 *
        Paper3TrigOrtho.mode L n x) = fun x =>
      (3 / 4 : ℝ) *
          (Paper3TrigOrtho.mode L n x * Paper3TrigOrtho.mode L n x) +
        (1 / 4 : ℝ) *
          (Paper3TrigOrtho.mode L (3 * n) x * Paper3TrigOrtho.mode L n x) by
      funext x
      unfold Paper3TrigOrtho.mode
      rw [cosine_cube_decomposition]
      push_cast
      ring_nf]
  have hcont : ∀ m : ℕ, Continuous (Paper3TrigOrtho.mode L m) := by
    intro m
    unfold Paper3TrigOrtho.mode
    continuity
  rw [intervalIntegral.integral_add
      (f := fun x => (3 / 4 : ℝ) *
        (Paper3TrigOrtho.mode L n x * Paper3TrigOrtho.mode L n x))
      (g := fun x => (1 / 4 : ℝ) *
        (Paper3TrigOrtho.mode L (3 * n) x * Paper3TrigOrtho.mode L n x))
      ((continuous_const.mul ((hcont n).mul (hcont n))).intervalIntegrable _ _)
      ((continuous_const.mul ((hcont (3 * n)).mul (hcont n))).intervalIntegrable _ _),
    intervalIntegral.integral_const_mul,
    intervalIntegral.integral_const_mul,
    Paper3TrigOrtho.integral_mode_mul_mode L hL,
    Paper3TrigOrtho.integral_mode_mul_mode L hL]
  have hn0 : n ≠ 0 := Nat.ne_of_gt hn
  have h3n : 3 * n ≠ n := by omega
  simp [hn0, h3n]
  field_simp [ne_of_gt hL]

noncomputable def logisticQuadratic (q2 p0 p2 : ℝ) : ℝ :=
  q2 / 2 * (2 * p0 + p2)

noncomputable def logisticCubic (q3 : ℝ) : ℝ := q3 / 8

/-- The manuscript's combinatorial form is the normalized projected form. -/
theorem logistic_channel_collection (q2 q3 p0 p2 : ℝ) :
    logisticQuadratic q2 p0 p2 + logisticCubic q3 =
      q2 / 4 * (4 * p0 + 2 * p2) + q3 / 8 := by
  unfold logisticQuadratic logisticCubic
  ring_nf

/-- Full non-minimal reduced cubic coefficient assembled from independently
projected logistic and chemotactic channels. -/
theorem nonminimal_betaRaw_eq_projected_channels
    (p : Paper3QuadraticABC.Params) (beta : ℝ) :
    Paper3QuadraticABC.betaRaw p beta =
      logisticQuadratic
          ((1 + p.alpha) * p.alpha * p.b *
            (Paper3QuadraticABC.us p) ^ (p.alpha - 1))
          (Paper3QuadraticABC.a01 p)
          (Paper3QuadraticABC.p20 p + Paper3QuadraticABC.p21 p * beta) -
        Paper3QuadraticABC.chiStar p beta *
          (Paper3QuadraticABC.lam p p.n0 *
            Paper3CubicProjection.compactBracket
              (Paper3CubicProjection.dataOfParams p beta)) +
        logisticCubic
          ((1 + p.alpha) * p.alpha * (p.alpha - 1) * p.b *
            (Paper3QuadraticABC.us p) ^ (p.alpha - 2)) := by
  rw [← Paper3CubicProjection.nonminimal_Gamma3_eq_projected_compact]
  unfold Paper3QuadraticABC.betaRaw Paper3QuadraticABC.c1
    Paper3QuadraticABC.c3 logisticQuadratic logisticCubic
  ring_nf

/-- Minimal reduced coefficient has only the independently projected
chemotactic channel. -/
theorem minimal_betaRaw_eq_projected_channel
    (p : Paper3MinimalABC.MinParams) (beta : ℝ) :
    Paper3MinimalABC.betaRawMin p beta =
      -Paper3MinimalABC.chiStar p beta *
        (Paper3MinimalABC.lam p p.n0 *
          Paper3CubicProjection.compactBracket
            (Paper3CubicProjection.dataOfMinParams p beta)) := by
  rw [← Paper3CubicProjection.minimal_Gamma3_eq_projected_compact]
  rfl

end Paper3ReducedAssembly

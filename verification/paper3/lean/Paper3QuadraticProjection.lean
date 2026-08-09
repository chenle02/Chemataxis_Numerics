/-
# Paper III -- quadratic chemotactic forcing projection

This file derives the `2*n0` chemotactic forcing from the finite primary-mode
jet. It projects the `0+2` and `1+1` flux channels and then connects the result
to the affine `D0 + D1*beta` source consumed by the center-graph invariance
equations in both model classes.
-/

import Paper3CubicProjection

namespace Paper3QuadraticProjection

structure QuadraticData where
  B0 : ℝ
  Bu : ℝ
  Bv : ℝ
  d1 : ℝ
  e2 : ℝ

variable (d : QuadraticData)

def M1 : ℝ := d.Bu + d.Bv * d.d1

/-- Bracket in the manuscript's explicit `Gamma_(2n0)` formula. -/
def quadraticBracket : ℝ := 4 * d.B0 * d.e2 + M1 d * d.d1

/-- Raw order-two flux from the `0+2` and `1+1` order splits. -/
noncomputable def quadraticFlux (k x : ℝ) : ℝ :=
  (-2 * k * d.B0 * d.e2) * Real.sin (2 * (k * x)) +
    (-k * M1 d * d.d1) *
      (Real.cos (k * x) * Real.sin (k * x))

/-- The raw quadratic flux is a pure second sine harmonic. -/
theorem quadraticFlux_decomposition (k x : ℝ) :
    quadraticFlux d k x =
      -k * (2 * d.B0 * d.e2 + M1 d * d.d1 / 2) *
        Real.sin (2 * (k * x)) := by
  unfold quadraticFlux
  rw [show Real.cos (k * x) * Real.sin (k * x) =
      Real.sin (2 * (k * x)) / 2 by
        rw [Real.sin_two_mul]
        ring_nf]
  ring_nf

/-- Quadratic chemotactic density after the outer negative derivative. -/
noncomputable def quadraticDensity (k x : ℝ) : ℝ :=
  k ^ 2 * quadraticBracket d * Real.cos (2 * (k * x))

theorem hasDerivAt_quadraticFlux (k x : ℝ) :
    HasDerivAt (quadraticFlux d k) (-quadraticDensity d k x) x := by
  have hfun : quadraticFlux d k = fun y =>
      -k * (2 * d.B0 * d.e2 + M1 d * d.d1 / 2) *
        Real.sin (2 * (k * y)) := by
    funext y
    exact quadraticFlux_decomposition d k y
  rw [hfun]
  have h2k : HasDerivAt (fun y : ℝ => 2 * k * y) (2 * k) x := by
    simpa using (hasDerivAt_id x).const_mul (2 * k)
  have hs := (Real.hasDerivAt_sin (2 * k * x)).comp x h2k
  have h := hs.const_mul
    (-k * (2 * d.B0 * d.e2 + M1 d * d.d1 / 2))
  have hval :
      -k * (2 * d.B0 * d.e2 + M1 d * d.d1 / 2) *
          (Real.cos (2 * k * x) * (2 * k)) =
        -quadraticDensity d k x := by
    unfold quadraticDensity quadraticBracket
    ring_nf
  rw [hval] at h
  have hfunc :
      (fun y => -k * (2 * d.B0 * d.e2 + M1 d * d.d1 / 2) *
        (Real.sin ∘ fun z => 2 * k * z) y) =
      (fun y => -k * (2 * d.B0 * d.e2 + M1 d * d.d1 / 2) *
        Real.sin (2 * (k * y))) := by
    funext y
    simp only [Function.comp_apply]
    congr 1
    ring_nf
  rw [hfunc] at h
  exact h

theorem neg_deriv_quadraticFlux (k x : ℝ) :
    -deriv (quadraticFlux d k) x = quadraticDensity d k x := by
  rw [(hasDerivAt_quadraticFlux d k x).deriv]
  ring_nf

/-- Normalized projection onto the `2*n` Neumann cosine mode. -/
theorem normalized_second_mode_projection (L : ℝ) (n : ℕ)
    (hL : 0 < L) (hn : 0 < n) :
    let k := Paper3Eigenmodes.waveNumber L n
    2 / L * (∫ x in (0 : ℝ)..L,
      quadraticDensity d k x * Paper3TrigOrtho.mode L (2 * n) x) =
        k ^ 2 * quadraticBracket d := by
  dsimp only
  have hmode : (fun x : ℝ => Real.cos
      (2 * (Paper3Eigenmodes.waveNumber L n * x))) =
        Paper3TrigOrtho.mode L (2 * n) := by
    funext x
    unfold Paper3Eigenmodes.waveNumber Paper3TrigOrtho.mode
    congr 1
    push_cast
    ring_nf
  have hcontMode : Continuous (Paper3TrigOrtho.mode L (2 * n)) := by
    unfold Paper3TrigOrtho.mode
    continuity
  have hfun : (fun x : ℝ =>
      quadraticDensity d (Paper3Eigenmodes.waveNumber L n) x *
        Paper3TrigOrtho.mode L (2 * n) x) = fun x =>
      (Paper3Eigenmodes.waveNumber L n ^ 2 * quadraticBracket d) *
        (Paper3TrigOrtho.mode L (2 * n) x *
          Paper3TrigOrtho.mode L (2 * n) x) := by
    funext x
    unfold quadraticDensity
    rw [show Real.cos (2 * (Paper3Eigenmodes.waveNumber L n * x)) =
      Paper3TrigOrtho.mode L (2 * n) x from congrFun hmode x]
    ring_nf
  rw [hfun, intervalIntegral.integral_const_mul,
      Paper3TrigOrtho.integral_mode_mul_mode L hL]
  have h2n : 2 * n ≠ 0 := by omega
  simp [h2n]
  field_simp [ne_of_gt hL]

noncomputable def dataOfParams (p : Paper3QuadraticABC.Params) (beta : ℝ) :
    QuadraticData where
  B0 := (Paper3QuadraticABC.us p) ^ p.m / (Paper3QuadraticABC.w p) ^ beta
  Bu := p.m * (Paper3QuadraticABC.us p) ^ (p.m - 1) /
    (Paper3QuadraticABC.w p) ^ beta
  Bv := -beta * (Paper3QuadraticABC.us p) ^ p.m /
    (Paper3QuadraticABC.w p) ^ (beta + 1)
  d1 := Paper3QuadraticABC.C1 p (Paper3QuadraticABC.lam p p.n0)
  e2 := Paper3QuadraticABC.C2 p
    (Paper3QuadraticABC.lam p (2 * p.n0))

noncomputable def gamma2OfParams (p : Paper3QuadraticABC.Params) (beta : ℝ) : ℝ :=
  Paper3QuadraticABC.lam p p.n0 * quadraticBracket (dataOfParams p beta)

/-- Multiplying the independently projected non-minimal quadratic forcing by
the threshold gives exactly the affine source used by `p20,p21`. -/
theorem nonminimal_chiGamma2_eq_affine (p : Paper3QuadraticABC.Params)
    (hw : 0 < Paper3QuadraticABC.w p)
    (hlam : Paper3QuadraticABC.lam p p.n0 ≠ 0) (beta : ℝ) :
    Paper3QuadraticABC.chiStar p beta * gamma2OfParams p beta =
      Paper3QuadraticABC.D0 p + Paper3QuadraticABC.D1 p * beta := by
  have hwne : Paper3QuadraticABC.w p ≠ 0 := hw.ne'
  set z := (Paper3QuadraticABC.w p) ^ beta with hz
  have hz0 : z ≠ 0 := by
    rw [hz]
    exact (Real.rpow_pos_of_pos hw beta).ne'
  have hpow1 : (Paper3QuadraticABC.w p) ^ (beta + 1) =
      z * Paper3QuadraticABC.w p := by
    rw [hz, Real.rpow_add hw, Real.rpow_one]
  unfold Paper3QuadraticABC.chiStar gamma2OfParams quadraticBracket M1
    dataOfParams Paper3QuadraticABC.D0 Paper3QuadraticABC.D1
  rw [hpow1, ← hz]
  field_simp
  ring_nf

noncomputable def dataOfMinParams (p : Paper3MinimalABC.MinParams) (beta : ℝ) :
    QuadraticData where
  B0 := p.us ^ p.m / (Paper3MinimalABC.w p) ^ beta
  Bu := p.m * p.us ^ (p.m - 1) / (Paper3MinimalABC.w p) ^ beta
  Bv := -beta * p.us ^ p.m / (Paper3MinimalABC.w p) ^ (beta + 1)
  d1 := Paper3MinimalABC.C1 p (Paper3MinimalABC.lam p p.n0)
  e2 := Paper3MinimalABC.C2 p (Paper3MinimalABC.lam p (2 * p.n0))

noncomputable def gamma2OfMinParams (p : Paper3MinimalABC.MinParams)
    (beta : ℝ) : ℝ :=
  Paper3MinimalABC.lam p p.n0 * quadraticBracket (dataOfMinParams p beta)

/-- Minimal analogue of the affine forcing bridge. -/
theorem minimal_chiGamma2_eq_affine (p : Paper3MinimalABC.MinParams)
    (hw : 0 < Paper3MinimalABC.w p)
    (hlam : Paper3MinimalABC.lam p p.n0 ≠ 0) (beta : ℝ) :
    Paper3MinimalABC.chiStar p beta * gamma2OfMinParams p beta =
      Paper3MinimalABC.D0 p + Paper3MinimalABC.D1 p * beta := by
  have hwne : Paper3MinimalABC.w p ≠ 0 := hw.ne'
  set z := (Paper3MinimalABC.w p) ^ beta with hz
  have hz0 : z ≠ 0 := by
    rw [hz]
    exact (Real.rpow_pos_of_pos hw beta).ne'
  have hpow1 : (Paper3MinimalABC.w p) ^ (beta + 1) =
      z * Paper3MinimalABC.w p := by
    rw [hz, Real.rpow_add hw, Real.rpow_one]
  unfold Paper3MinimalABC.chiStar gamma2OfMinParams quadraticBracket M1
    dataOfMinParams Paper3MinimalABC.D0 Paper3MinimalABC.D1
  rw [hpow1, ← hz]
  field_simp
  ring_nf

end Paper3QuadraticProjection

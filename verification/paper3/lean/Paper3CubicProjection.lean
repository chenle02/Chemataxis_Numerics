/-
# Paper III -- finite cubic chemotactic projection

This file derives the compact center-graph cubic chemotactic coefficient from
the finite low-mode jet used in the manuscript. It independently collects the
mobility jet, performs the sine/cosine product-to-sum calculation, differentiates
the cubic flux, and projects against the critical cosine mode. The third
harmonic vanishes by the previously proved Neumann cosine orthogonality.

No center-manifold existence theorem or infinite Fourier-series interchange is
claimed here.
-/

import Paper3Eigenmodes
import Paper3TrigOrtho
import Paper3QuadraticABC
import Paper3MinimalABC

namespace Paper3CubicProjection

/-- Scalar data entering the center-graph mobility and signal jets. -/
structure CubicData where
  B0 : ℝ
  Bu : ℝ
  Bv : ℝ
  Buu : ℝ
  Buv : ℝ
  Bvv : ℝ
  p0 : ℝ
  p2 : ℝ
  d0 : ℝ
  d1 : ℝ
  d2 : ℝ
  d3 : ℝ

variable (d : CubicData)

def M1 : ℝ := d.Bu + d.Bv * d.d1
def Q : ℝ := d.Buu + d.Buv * d.d1 + d.Bvv * d.d1 ^ 2
noncomputable def R0 : ℝ := d.Bu * d.p0 + d.Bv * d.d0 + Q d / 2
noncomputable def R2 : ℝ := d.Bu * d.p2 + d.Bv * d.d2 + Q d / 2

/-- The bracket in equations (3.29) and (4.11). -/
noncomputable def compactBracket : ℝ :=
  d.B0 * d.d3 + M1 d * d.d2 + d.d1 * (R0 d - R2 d / 2)

/-- Coefficient of the irrelevant third sine harmonic before differentiation. -/
noncomputable def thirdBracket : ℝ := M1 d * d.d2 + d.d1 * R2 d / 2

/-- `cos(theta) sin(2 theta)` product-to-sum identity used by the projection. -/
theorem cos_mul_sin_two (theta : ℝ) :
    Real.cos theta * Real.sin (2 * theta) =
      (Real.sin (3 * theta) + Real.sin theta) / 2 := by
  calc
    Real.cos theta * Real.sin (2 * theta) =
        (Real.sin (2 * theta + theta) + Real.sin (2 * theta - theta)) / 2 := by
      rw [Real.sin_add, Real.sin_sub]
      ring_nf
    _ = (Real.sin (3 * theta) + Real.sin theta) / 2 := by ring_nf

/-- `cos(2 theta) sin(theta)` product-to-sum identity used by the projection. -/
theorem cos_two_mul_sin (theta : ℝ) :
    Real.cos (2 * theta) * Real.sin theta =
      (Real.sin (3 * theta) - Real.sin theta) / 2 := by
  calc
    Real.cos (2 * theta) * Real.sin theta =
        (Real.sin (theta + 2 * theta) + Real.sin (theta - 2 * theta)) / 2 := by
      rw [Real.sin_add, Real.sin_sub]
      ring_nf
    _ = (Real.sin (3 * theta) - Real.sin theta) / 2 := by
      rw [show theta - 2 * theta = -theta by ring_nf, Real.sin_neg]
      ring_nf

/-- Independent collection of the order-two mobility jet into its constant and
second-harmonic coefficients `R0` and `R2`. -/
theorem mobility_quadratic_collection (theta : ℝ) :
    d.Bu * (d.p0 + d.p2 * Real.cos (2 * theta)) +
        d.Bv * (d.d0 + d.d2 * Real.cos (2 * theta)) +
        Q d * Real.cos theta ^ 2 =
      R0 d + R2 d * Real.cos (2 * theta) := by
  rw [Real.cos_two_mul]
  unfold R0 R2
  ring_nf

/-- Raw coefficient of `A^3` in `B(u,v) v_x`, before differentiating and
projecting. Each summand comes from one order split: `0+3`, `1+2`, or `2+1`. -/
noncomputable def cubicFlux (k x : ℝ) : ℝ :=
  (-k * d.B0 * d.d3) * Real.sin (k * x) +
    (-2 * k * M1 d * d.d2) *
      (Real.cos (k * x) * Real.sin (2 * (k * x))) +
    (-k * d.d1 * R0 d) * Real.sin (k * x) +
    (-k * d.d1 * R2 d) *
      (Real.cos (2 * (k * x)) * Real.sin (k * x))

/-- The raw cubic flux has only first and third sine harmonics. -/
theorem cubicFlux_decomposition (k x : ℝ) :
    cubicFlux d k x =
      -k * compactBracket d * Real.sin (k * x) -
        k * thirdBracket d * Real.sin (3 * (k * x)) := by
  unfold cubicFlux
  rw [cos_mul_sin_two, cos_two_mul_sin]
  unfold compactBracket thirdBracket
  ring_nf

/-- Cubic chemotactic density after applying the outer negative derivative. -/
noncomputable def cubicDensity (k x : ℝ) : ℝ :=
  k ^ 2 * compactBracket d * Real.cos (k * x) +
    3 * k ^ 2 * thirdBracket d * Real.cos (3 * (k * x))

/-- Differentiating the raw flux produces the compact critical coefficient plus
an orthogonal third harmonic. -/
theorem hasDerivAt_cubicFlux (k x : ℝ) :
    HasDerivAt (cubicFlux d k) (-cubicDensity d k x) x := by
  have hfun : cubicFlux d k = fun y =>
      -k * compactBracket d * Real.sin (k * y) -
        k * thirdBracket d * Real.sin (3 * (k * y)) := by
    funext y
    exact cubicFlux_decomposition d k y
  rw [hfun]
  have hk : HasDerivAt (fun y : ℝ => k * y) k x := by
    simpa using (hasDerivAt_id x).const_mul k
  have h3k : HasDerivAt (fun y : ℝ => 3 * k * y) (3 * k) x := by
    simpa using (hasDerivAt_id x).const_mul (3 * k)
  have hs1 := (Real.hasDerivAt_sin (k * x)).comp x hk
  have hs3 := (Real.hasDerivAt_sin (3 * k * x)).comp x h3k
  have h := (hs1.const_mul (-k * compactBracket d)).sub
    (hs3.const_mul (k * thirdBracket d))
  have hval :
      -k * compactBracket d * (Real.cos (k * x) * k) -
          k * thirdBracket d * (Real.cos (3 * k * x) * (3 * k)) =
        -cubicDensity d k x := by
    unfold cubicDensity
    ring_nf
  rw [hval] at h
  have hfunc :
      ((fun y => -k * compactBracket d * (Real.sin ∘ fun z => k * z) y) -
        fun y => k * thirdBracket d * (Real.sin ∘ fun z => 3 * k * z) y) =
      (fun y => -k * compactBracket d * Real.sin (k * y) -
        k * thirdBracket d * Real.sin (3 * (k * y))) := by
    funext y
    simp only [Function.comp_apply, Pi.sub_apply]
    ring_nf
  rw [hfunc] at h
  exact h

/-- Pointwise negative derivative of the cubic flux. -/
theorem neg_deriv_cubicFlux (k x : ℝ) :
    -deriv (cubicFlux d k) x = cubicDensity d k x := by
  rw [(hasDerivAt_cubicFlux d k x).deriv]
  ring_nf

/-- Actual normalized Neumann projection of the cubic density. The third
harmonic is killed by cosine orthogonality, leaving exactly the manuscript's
compact coefficient `kappa^2 * compactBracket`. -/
theorem normalized_critical_projection (L : ℝ) (n : ℕ)
    (hL : 0 < L) (hn : 0 < n) :
    let k := Paper3Eigenmodes.waveNumber L n
    2 / L * (∫ x in (0 : ℝ)..L,
      cubicDensity d k x * Paper3TrigOrtho.mode L n x) =
        k ^ 2 * compactBracket d := by
  dsimp only
  have hmode1 : (fun x : ℝ => Real.cos
      (Paper3Eigenmodes.waveNumber L n * x)) = Paper3TrigOrtho.mode L n := by
    funext x
    unfold Paper3Eigenmodes.waveNumber Paper3TrigOrtho.mode
    rfl
  have hmode3 : (fun x : ℝ => Real.cos
      (3 * (Paper3Eigenmodes.waveNumber L n * x))) =
        Paper3TrigOrtho.mode L (3 * n) := by
    funext x
    unfold Paper3Eigenmodes.waveNumber Paper3TrigOrtho.mode
    congr 1
    push_cast
    ring_nf
  have hsplit : (fun x : ℝ =>
      cubicDensity d (Paper3Eigenmodes.waveNumber L n) x *
        Paper3TrigOrtho.mode L n x) = fun x =>
      (Paper3Eigenmodes.waveNumber L n ^ 2 * compactBracket d) *
          (Real.cos (Paper3Eigenmodes.waveNumber L n * x) *
            Paper3TrigOrtho.mode L n x) +
        (3 * Paper3Eigenmodes.waveNumber L n ^ 2 * thirdBracket d) *
          (Real.cos (3 * (Paper3Eigenmodes.waveNumber L n * x)) *
            Paper3TrigOrtho.mode L n x) := by
    funext x
    unfold cubicDensity
    ring_nf
  rw [hsplit]
  have hcontMode : ∀ m : ℕ, Continuous (Paper3TrigOrtho.mode L m) := by
    intro m
    unfold Paper3TrigOrtho.mode
    continuity
  have hc1 : Continuous (fun x : ℝ =>
      (Paper3Eigenmodes.waveNumber L n ^ 2 * compactBracket d) *
        (Real.cos (Paper3Eigenmodes.waveNumber L n * x) *
          Paper3TrigOrtho.mode L n x)) := by
    exact continuous_const.mul
      ((by fun_prop : Continuous fun x : ℝ =>
        Real.cos (Paper3Eigenmodes.waveNumber L n * x)).mul (hcontMode n))
  have hc3 : Continuous (fun x : ℝ =>
      (3 * Paper3Eigenmodes.waveNumber L n ^ 2 * thirdBracket d) *
        (Real.cos (3 * (Paper3Eigenmodes.waveNumber L n * x)) *
          Paper3TrigOrtho.mode L n x)) := by
    exact continuous_const.mul
      ((by fun_prop : Continuous fun x : ℝ =>
        Real.cos (3 * (Paper3Eigenmodes.waveNumber L n * x))).mul (hcontMode n))
  rw [intervalIntegral.integral_add (hc1.intervalIntegrable _ _)
      (hc3.intervalIntegrable _ _),
      intervalIntegral.integral_const_mul,
      intervalIntegral.integral_const_mul]
  rw [show (fun x : ℝ => Real.cos
        (Paper3Eigenmodes.waveNumber L n * x) *
        Paper3TrigOrtho.mode L n x) =
      fun x => Paper3TrigOrtho.mode L n x *
        Paper3TrigOrtho.mode L n x by
          funext x
          rw [show Real.cos (Paper3Eigenmodes.waveNumber L n * x) =
            Paper3TrigOrtho.mode L n x from congrFun hmode1 x]]
  rw [show (fun x : ℝ => Real.cos
        (3 * (Paper3Eigenmodes.waveNumber L n * x)) *
        Paper3TrigOrtho.mode L n x) =
      fun x => Paper3TrigOrtho.mode L (3 * n) x *
        Paper3TrigOrtho.mode L n x by
          funext x
          rw [show Real.cos (3 * (Paper3Eigenmodes.waveNumber L n * x)) =
            Paper3TrigOrtho.mode L (3 * n) x from congrFun hmode3 x]]
  rw [Paper3TrigOrtho.integral_mode_mul_mode L hL,
      Paper3TrigOrtho.integral_mode_mul_mode L hL]
  have hn0 : n ≠ 0 := Nat.ne_of_gt hn
  have h3n : 3 * n ≠ n := by omega
  simp [hn0, h3n]
  field_simp [ne_of_gt hL]

/-- Non-minimal manuscript data specialized into the independent projection
structure. -/
noncomputable def dataOfParams (p : Paper3QuadraticABC.Params) (beta : ℝ) :
    CubicData where
  B0 := (Paper3QuadraticABC.us p) ^ p.m / (Paper3QuadraticABC.w p) ^ beta
  Bu := p.m * (Paper3QuadraticABC.us p) ^ (p.m - 1) /
    (Paper3QuadraticABC.w p) ^ beta
  Bv := -beta * (Paper3QuadraticABC.us p) ^ p.m /
    (Paper3QuadraticABC.w p) ^ (beta + 1)
  Buu := p.m * (p.m - 1) *
    (Paper3QuadraticABC.us p) ^ (p.m - 2) /
      (2 * (Paper3QuadraticABC.w p) ^ beta)
  Buv := -p.m * beta * (Paper3QuadraticABC.us p) ^ (p.m - 1) /
    (Paper3QuadraticABC.w p) ^ (beta + 1)
  Bvv := beta * (beta + 1) * (Paper3QuadraticABC.us p) ^ p.m /
    (2 * (Paper3QuadraticABC.w p) ^ (beta + 2))
  p0 := Paper3QuadraticABC.a01 p
  p2 := Paper3QuadraticABC.p20 p + Paper3QuadraticABC.p21 p * beta
  d0 := Paper3QuadraticABC.v0 p
  d1 := Paper3QuadraticABC.v1 p
  d2 := Paper3QuadraticABC.v20 p + Paper3QuadraticABC.v21 p * beta
  d3 := Paper3QuadraticABC.V0 p + Paper3QuadraticABC.V1 p * beta

/-- The existing non-minimal raw cubic definition is exactly the compact
coefficient independently obtained by the finite projection above. -/
theorem nonminimal_Gamma3_eq_projected_compact
    (p : Paper3QuadraticABC.Params) (beta : ℝ) :
    Paper3QuadraticABC.Gamma3 p beta =
      Paper3QuadraticABC.lam p p.n0 * compactBracket (dataOfParams p beta) := by
  unfold Paper3QuadraticABC.Gamma3 compactBracket M1 R0 R2 Q dataOfParams
  ring_nf

/-- Minimal manuscript data specialized into the same independent projection
structure (`p0 = 0`). -/
noncomputable def dataOfMinParams (p : Paper3MinimalABC.MinParams) (beta : ℝ) :
    CubicData where
  B0 := p.us ^ p.m / (Paper3MinimalABC.w p) ^ beta
  Bu := p.m * p.us ^ (p.m - 1) / (Paper3MinimalABC.w p) ^ beta
  Bv := -beta * p.us ^ p.m / (Paper3MinimalABC.w p) ^ (beta + 1)
  Buu := p.m * (p.m - 1) * p.us ^ (p.m - 2) /
    (2 * (Paper3MinimalABC.w p) ^ beta)
  Buv := -p.m * beta * p.us ^ (p.m - 1) /
    (Paper3MinimalABC.w p) ^ (beta + 1)
  Bvv := beta * (beta + 1) * p.us ^ p.m /
    (2 * (Paper3MinimalABC.w p) ^ (beta + 2))
  p0 := 0
  p2 := Paper3MinimalABC.p20 p + Paper3MinimalABC.p21 p * beta
  d0 := Paper3MinimalABC.v0 p
  d1 := Paper3MinimalABC.v1 p
  d2 := Paper3MinimalABC.v20 p + Paper3MinimalABC.v21 p * beta
  d3 := Paper3MinimalABC.V0 p + Paper3MinimalABC.V1 p * beta

/-- The existing minimal raw cubic definition is exactly the same projected
compact coefficient with the constant center-graph mode removed. -/
theorem minimal_Gamma3_eq_projected_compact
    (p : Paper3MinimalABC.MinParams) (beta : ℝ) :
    Paper3MinimalABC.Gamma3 p beta =
      Paper3MinimalABC.lam p p.n0 *
        compactBracket (dataOfMinParams p beta) := by
  unfold Paper3MinimalABC.Gamma3 compactBracket M1 R0 R2 Q dataOfMinParams
  ring_nf

end Paper3CubicProjection

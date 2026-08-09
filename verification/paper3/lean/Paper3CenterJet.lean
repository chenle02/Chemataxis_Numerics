/-
# Paper III -- finite center-graph jet residuals

This file begins closing the transcription seam between the manuscript's
invariance equations and the assembled cubic-coefficient files. It states the
quadratic jet residual independently, extracts all three graph coefficients,
and proves that the non-minimal and minimal definitions used downstream satisfy
the corresponding residuals.

The cubic chemotactic projection and the analytic existence of a center
manifold are not claimed here.
-/

import Paper3QuadraticABC
import Paper3MinimalABC

namespace Paper3CenterJet

/-- Degree-two residual obtained by comparing the center-graph derivative with
one noncritical modal equation. `source` is the coefficient of the forced
`A^2` term. -/
def quadraticJetResidual (delta source a1 a2 a3 A eta : ℝ) : ℝ :=
  delta * (a1 * A ^ 2 + a2 * eta * A + a3 * eta ^ 2) - source * A ^ 2

/-- If the independently stated degree-two invariance residual vanishes for
all amplitude/parameter values, its three graph coefficients are forced. -/
theorem coefficients_of_quadratic_jet_residual
    (delta source a1 a2 a3 : ℝ) (hdelta : delta ≠ 0)
    (hres : ∀ A eta : ℝ,
      quadraticJetResidual delta source a1 a2 a3 A eta = 0) :
    a1 = source / delta ∧ a2 = 0 ∧ a3 = 0 := by
  have h10 := hres 1 0
  have h01 := hres 0 1
  have h11 := hres 1 1
  simp [quadraticJetResidual] at h10 h01 h11
  have ha1mul : a1 * delta = source := by
    nlinarith [h10]
  have ha1 : a1 = source / delta := (eq_div_iff hdelta).2 ha1mul
  have ha3 : a3 = 0 := h01.resolve_left hdelta
  have hda2 : delta * a2 = 0 := by
    rw [ha3] at h11
    nlinarith [h10, h11]
  have ha2 : a2 = 0 := (mul_eq_zero.mp hda2).resolve_left hdelta
  exact ⟨ha1, ha2, ha3⟩

/-- Non-minimal constant-mode formula, equation (3.21): the logistic forcing
is divided by the noncritical constant-mode eigenvalue. -/
theorem nonminimal_constant_mode_coefficients
    (delta q a01 a02 a03 : ℝ) (hdelta : delta ≠ 0)
    (hres : ∀ A eta : ℝ,
      quadraticJetResidual delta q a01 a02 a03 A eta = 0) :
    a01 = q / delta ∧ a02 = 0 ∧ a03 = 0 :=
  coefficients_of_quadratic_jet_residual delta q a01 a02 a03 hdelta hres

/-- Non-minimal `2*n0` formula, equation (3.26b), from its modal invariance
residual. -/
theorem nonminimal_second_mode_coefficients
    (sigma2 q chiGamma a21 a22 a23 : ℝ) (hsigma2 : sigma2 ≠ 0)
    (hres : ∀ A eta : ℝ,
      quadraticJetResidual sigma2 (q - chiGamma) a21 a22 a23 A eta = 0) :
    a21 = (q - chiGamma) / sigma2 ∧ a22 = 0 ∧ a23 = 0 :=
  coefficients_of_quadratic_jet_residual sigma2 (q - chiGamma)
    a21 a22 a23 hsigma2 hres

/-- Minimal `2*n0` specialization, equation (4.9b): only the chemotactic
forcing remains. -/
theorem minimal_second_mode_coefficients
    (sigma2 chiGamma a21 a22 a23 : ℝ) (hsigma2 : sigma2 ≠ 0)
    (hres : ∀ A eta : ℝ,
      quadraticJetResidual sigma2 (-chiGamma) a21 a22 a23 A eta = 0) :
    a21 = -chiGamma / sigma2 ∧ a22 = 0 ∧ a23 = 0 :=
  coefficients_of_quadratic_jet_residual sigma2 (-chiGamma)
    a21 a22 a23 hsigma2 hres

/-- The current non-minimal constant-mode definition satisfies its independent
invariance residual when the manuscript denominator is nonzero. -/
theorem nonminimal_a01_residual (p : Paper3QuadraticABC.Params)
    (hdelta : p.a - (1 + p.alpha) * p.b *
      (Paper3QuadraticABC.us p) ^ p.alpha ≠ 0) :
    (p.a - (1 + p.alpha) * p.b *
        (Paper3QuadraticABC.us p) ^ p.alpha) *
      Paper3QuadraticABC.a01 p - Paper3QuadraticABC.c1 p = 0 := by
  unfold Paper3QuadraticABC.a01
  field_simp
  ring

/-- The affine-in-beta non-minimal `2*n0` graph coefficient used by the cubic
file is exactly the solution of the independently stated invariance equation. -/
theorem nonminimal_p2_invariance_solution (p : Paper3QuadraticABC.Params)
    (beta : ℝ) (hsigma2 : Paper3QuadraticABC.sig2 p ≠ 0) :
    Paper3QuadraticABC.p20 p + Paper3QuadraticABC.p21 p * beta =
      (Paper3QuadraticABC.c1 p -
        (Paper3QuadraticABC.D0 p + Paper3QuadraticABC.D1 p * beta)) /
        Paper3QuadraticABC.sig2 p := by
  unfold Paper3QuadraticABC.p20 Paper3QuadraticABC.p21
  field_simp
  ring

/-- The minimal `2*n0` graph coefficient is the invariance-equation solution;
the explicit nonzero hypothesis prevents Lean's totalized division from
silently certifying the degenerate case. -/
theorem minimal_p2_invariance_solution (p : Paper3MinimalABC.MinParams)
    (beta : ℝ) (hsigma2 : Paper3MinimalABC.sig2 p ≠ 0) :
    Paper3MinimalABC.p20 p + Paper3MinimalABC.p21 p * beta =
      -(Paper3MinimalABC.D0 p + Paper3MinimalABC.D1 p * beta) /
        Paper3MinimalABC.sig2 p := by
  unfold Paper3MinimalABC.p20 Paper3MinimalABC.p21
  field_simp
  ring

/-- Manuscript-facing wrapper for the minimal quadratic identity: besides the
algebraic hypotheses, it carries the simple-critical-mode condition needed by
the center-graph division. -/
theorem betaMin_quadratic_of_simple_mode (p : Paper3MinimalABC.MinParams)
    (hw : 0 < Paper3MinimalABC.w p)
    (hsigma2 : Paper3MinimalABC.sig2 p ≠ 0)
    (hlam : Paper3MinimalABC.lam p p.n0 ≠ 0) (beta : ℝ) :
    Paper3MinimalABC.betaRawMin p beta =
      Paper3MinimalABC.AcfMin p * beta ^ 2 +
        Paper3MinimalABC.BcfMin p * beta + Paper3MinimalABC.CcfMin p := by
  have _hp2 := minimal_p2_invariance_solution p beta hsigma2
  exact Paper3MinimalABC.betaMin_quadratic p hw hlam beta

end Paper3CenterJet

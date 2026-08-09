---
title: Paper III
---

# Paper III

## The model

On a one-dimensional interval with no-flux boundary conditions, Paper III
studies

\[
\begin{aligned}
u_t &= u_{xx}
  - \chi_0\,\partial_x\!\left(\frac{u^m}{(1+v)^\beta}v_x\right)
  + au-bu^{1+\alpha}, \\
0 &= v_{xx}-\mu v+\nu u^\gamma.
\end{aligned}
\]

The bifurcation parameter is the sensitivity strength \(\chi_0\). The paper
locates the first loss of stability of a positive constant equilibrium,
computes the coefficient selecting the local branch direction, treats the
fixed-mass minimal case \(a=b=0\), and develops global continuation for the
non-minimal model.

## Two complementary numerical questions

<div class="method-grid" markdown>

<article class="method-card" markdown>

### Stationary continuation

Does the discrete branch leave the threshold with the sign and quadratic
coefficient predicted by the local bifurcation calculation?

The solver prescribes a signed first-cosine amplitude \(A\), solves the
stationary equations, and fits

\[
\chi_h(A)-\chi_h^*=c_{2,h}A^2+c_{4,h}A^4.
\]
</article>

<article class="method-card" markdown>

### Time integration

Do selected semidiscrete trajectories decay below threshold and move toward
opposite patterned states above threshold?

Two non-minimal manuscript figures answer this diagnostic question for fixed
positive and negative seeds. They are supportive numerical observations, not
proofs of PDE stability.
</article>

</div>

## Stationary branch contract

For the four cases below, theory predicts \(c_2=\beta_{n_0}/\alpha_{n_0}\).
The numerical value is the constrained fit on the finest mesh, `N=160`.

| Parameter regime | Direction | Theory \(c_2\) | Numerical \(c_{2,160}\) | Observed order |
| --- | --- | ---: | ---: | ---: |
| Non-minimal `a=10, beta=0` | Supercritical | `0.0084254463` | `0.0084220572` | `2.009` |
| Non-minimal `beta=3` | Subcritical | `-19.66671032` | `-19.64492609` | `2.000` |
| Minimal `m=gamma=1` | Supercritical | `1.922989917` | `1.922366447` | `2.000` |
| Minimal `m=gamma=2` | Subcritical | `-1.148587331` | `-1.150522206` | `2.000` |

The full design uses three meshes and eight symmetric nonzero amplitudes per
case: 96 stationary states. All 780 acceptance gates pass, including solver,
positivity, residual, amplitude, reflection, mass, sign, intercept, and mesh
refinement checks.

## Paper-to-data map

| Paper-side role | Public object | Scope |
| --- | --- | --- |
| Four local branch-direction checks | Immutable stationary continuation v1 | Coefficient sign, value, symmetry, and mesh convergence |
| Quasi-linear supercritical figure | Non-minimal `a=10, beta=0` time archive | Below-threshold decay and two above-threshold trajectories |
| Nonlinear-mobility supercritical figure | `m=2, beta=1, gamma=2` time archive | Nonlinear mobility and signal-production diagnostic |
| Earlier minimal or branch-seeded runs | Historical Git objects | Provenance only; excluded from numerical claims |
| Finite algebraic and modewise proof layer | Canonical Lean package and receipt | 167 declarations; exact inclusions and exclusions in the statement ledger |

The [manifest](data/paper-iii-manifest.json) records the exact boundary and is
checked on every push.
The separate [Lean statement ledger](lean-verification.md) identifies every
formalized claim and every analytical or numerical statement not covered.

## Revisions frozen by release 1.0.0

- Paper III numerical science:
  `fde25e17187bc3f247b36ce411f6f14eb93d52cf`
- Simulator and stationary generator:
  `7c2a09b24fdebb9000b9b996eb34150d6de5ed17`
- Immutable public data:
  `e62ffa1e99122f8fbbeb3df7586f4050c4ff5c58`
- Font-embedded time figures:
  `c0bfc431a19b81b1c45363dea472c29a745ad055`

!!! info "Interpretation boundary"
    The public archive supports comparisons with the spatially semidiscrete
    model. It is not, by itself, a proof of the continuous PDE statements.

## Authors

- Le Chen, Department of Mathematics and Statistics, Auburn University
- Ian Ruau, Department of Mathematics and Statistics, Auburn University
- Wenxian Shen, Department of Mathematics and Statistics, Auburn University

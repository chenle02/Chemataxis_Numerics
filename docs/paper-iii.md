---
title: Paper III
---

# Paper III

## The model

On a one-dimensional interval with no-flux boundary conditions, Paper III
studies the parabolic--elliptic system

\[
\begin{aligned}
u_t &= u_{xx}
  - \chi_0\,\partial_x\!\left(\frac{u^m}{(1+v)^\beta}v_x\right)
  + au-bu^{1+\alpha}, \\
0 &= v_{xx}-\mu v+\nu u^\gamma.
\end{aligned}
\]

The bifurcation parameter is the sensitivity strength \(\chi_0\). The paper
tracks when a positive constant equilibrium loses stability, computes the
cubic coefficient that selects the local branch direction, treats the
fixed-mass minimal case \(a=b=0\), and develops global continuation for the
non-minimal model.

## What the numerical layer is for

The numerical experiments are diagnostics for the spatially semidiscrete
system. They compare runs just below and just above the analytical threshold,
seed the critical cosine mode with both signs, and record whether the solution
returns to the constant state or moves toward a patterned state.

The site uses two public evidence levels:

1. **Validated current** — archived constants agree with the completed full
   center-graph audit and the named raw runs support the stated semidiscrete
   observation.
2. **Under review** — analytical metadata may be corrected, but the numerical
   run needs a conservative rerun, corrected initialization, or is retained
   only for provenance.

These labels are encoded in
[`paper-iii-manifest.json`](data/paper-iii-manifest.json) and enforced in CI.

## Paper-to-data contract

| Paper-side role | Public evidence | Present scope |
| --- | --- | --- |
| Quasi-linear supercritical figure | Logistic `a=10`, `beta=0` archive | Validated coefficient and three fixed-seed trajectories |
| Nonlinear-mobility supercritical figure | Logistic `m=2`, `beta=1`, `gamma=2` archive | Validated coefficient and three fixed-seed trajectories |
| Minimal-model numerics | Historical fixed-mass archives | Withheld pending a conservative rerun |

The retired branch-seeded panel is no longer in the figure contract. Its
logistic `m=1`, `beta=1`, `gamma=1` archive used a coefficient-dependent seed
with the wrong sign. The corrected subcritical rerun target uses `beta=3`.

!!! info "Interpretation boundary"
    The simulation archive supports comparisons with the semidiscrete
    numerical model. It is not, by itself, a proof of the continuous PDE
    stability statements.

## Authors

- Le Chen, Department of Mathematics and Statistics, Auburn University
- Ian Ruau, Department of Mathematics and Statistics, Auburn University
- Wenxian Shen, Department of Mathematics and Statistics, Auburn University

Paper III is an active manuscript. The public contract will be versioned again
when the conservative minimal rerun and corrected subcritical continuation
data are complete.

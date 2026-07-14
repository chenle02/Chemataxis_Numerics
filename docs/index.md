---
title: Numerical companion
hide:
  - navigation
---

<section class="paper-hero">
  <div class="paper-hero__eyebrow">Paper III · Reproducible numerical evidence</div>
  <h1>Bifurcation, tested two ways</h1>
  <p class="paper-hero__lead">
    Stationary continuation resolves the local branch direction; selected
    time evolutions show how the semidiscrete dynamics cross the threshold.
  </p>
  <div class="paper-hero__actions">
    <a class="md-button md-button--primary" href="results/">Read the results</a>
    <a class="md-button" href="reproduce/">Verify the release</a>
  </div>
  <div class="paper-hero__authors">Le Chen · Ian Ruau · Wenxian Shen · Data release 1.0.0</div>
</section>

<div class="status-strip status-strip--four" role="status" aria-label="Release evidence status">
  <span><strong>4</strong> stationary cases</span>
  <span><strong>96</strong> solved states</span>
  <span><strong>780/780</strong> gates passed</span>
  <span><strong>2</strong> time-evolution figures</span>
</div>

## A paper-to-data companion

Paper III studies the loss of stability of a positive constant state as the
chemotactic sensitivity crosses a critical value. This companion makes the
numerical part of that argument inspectable: every reader-facing figure has a
frozen vector source, every stationary state is archived, and the release
manifest checks the exact paper and code revisions.

<div class="feature-grid" markdown>

<article class="feature-card" markdown>
<span class="feature-card__number">01</span>

### See the contract

Connect the model, branch coefficient, parameter regimes, and numerical scope
used in the manuscript.

[Paper III overview](paper-iii.md)
</article>

<article class="feature-card" markdown>
<span class="feature-card__number">02</span>

### Inspect the evidence

Compare the four stationary branches and the two retained time-integration
figures.

[Curated results](results/index.md)
</article>

<article class="feature-card" markdown>
<span class="feature-card__number">03</span>

### Reproduce the release

Verify 780 gates, all file digests, exact source revisions, and the immutable
data bundle.

[Reproduction guide](reproduce.md)
</article>

</div>

## Evidence matrix

| Model and parameters | Stationary branch | Finest-mesh coefficient | Additional evidence |
| --- | --- | ---: | --- |
| Non-minimal `a=10, beta=0` | Supercritical | `0.0084220572` | Near-threshold time evolution |
| Non-minimal `beta=3` | Subcritical | `-19.64492609` | Stationary continuation |
| Minimal `m=gamma=1` | Supercritical | `1.922366447` | Fixed-mass stationary continuation |
| Minimal `m=gamma=2` | Subcritical | `-1.150522206` | Fixed-mass stationary continuation |
| Non-minimal `m=2, beta=1, gamma=2` | Supercritical | — | Near-threshold time evolution |

The stationary coefficients converge at observed order `1.998--2.009` over
`N=40,80,160`. The full 2-by-2 comparison, raw branch points, profiles, and
indexed state arrays are in the
[immutable v1 bundle](https://github.com/chenle02/Chemataxis_Numerics/tree/master/docs/results/paper-iii/stationary-continuation/v1).

![Four amplitude-constrained Paper III stationary branches](assets/images/paper3-stationary-continuation.png)

!!! info "A deliberately narrow claim"
    These computations validate the stated spatially semidiscrete numerical
    comparisons. They do not replace the manuscript's continuous-PDE proofs.
    Superseded fixed-mass and coefficient-seeded trajectories remain in Git
    as provenance only and are not promoted by this site.

## Frozen release

Release 1.0.0 pins the stationary generator and simulator, the manuscript
numerical-science revision, the immutable public data commit, all figure
hashes, and the four coefficient-convergence records. The
[data and provenance guide](data.md) explains the archive boundary; the
[machine-readable manifest](data/paper-iii-manifest.json) enforces it in CI.

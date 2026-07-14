---
title: Numerical companion
hide:
  - navigation
---

<section class="paper-hero">
  <div class="paper-hero__eyebrow">Paper III · Bifurcation</div>
  <h1>From critical sensitivity<br>to patterned branches</h1>
  <p class="paper-hero__lead">
    A transparent numerical companion for chemotaxis models with
    signal-dependent sensitivity and a logistic-type source.
  </p>
  <div class="paper-hero__actions">
    <a class="md-button md-button--primary" href="results/">Explore the evidence</a>
    <a class="md-button" href="reproduce/">Reproduce a run</a>
  </div>
  <div class="paper-hero__authors">Le Chen · Ian Ruau · Wenxian Shen</div>
</section>

<div class="status-strip" role="status" aria-label="Current evidence status">
  <span><strong>2</strong> Paper III figure families validated</span>
  <span><strong>5</strong> archived coefficient records corrected</span>
  <span><strong>0</strong> minimal-model figures released</span>
</div>

## What this companion establishes

The manuscript studies loss of stability of a positive constant state as the
chemotactic sensitivity crosses a critical value. This repository supplies a
paper-to-data map for the numerical evidence and separates current evidence
from historical runs that require a conservative rerun or corrected
coefficient-dependent initialization.

<div class="feature-grid" markdown>

<article class="feature-card" markdown>
<span class="feature-card__number">01</span>

### Read the model

See the parameterization, the local bifurcation question, and the precise scope
of the companion.

[Paper III overview](paper-iii.md)
</article>

<article class="feature-card" markdown>
<span class="feature-card__number">02</span>

### Inspect the evidence

Follow each featured result to its configuration, constants, run metadata, and
raw numerical array.

[Curated results](results/index.md)
</article>

<article class="feature-card" markdown>
<span class="feature-card__number">03</span>

### Verify the contract

Run one dependency-free command to check every manifest path and archived
constant used by this site.

[Reproduction guide](reproduce.md)
</article>

</div>

!!! warning "Evidence boundary"
    The site does not present every archived gallery as paper evidence. The
    two non-minimal fixed-seed families below passed the full center-graph
    coefficient audit. Minimal-model trajectories remain withheld until the
    fixed-mass numerical path is rerun conservatively. These decisions are
    machine-readable in the [Paper III manifest](data/paper-iii-manifest.json).

## Evidence at a glance

| Result family | What can be read from it now | Contract status |
| --- | --- | --- |
| Non-minimal, `a=10`, `beta=0` | Corrected positive cubic coefficient; decay below and opposite patterned trajectories above threshold | **Validated current** |
| Non-minimal, `m=2`, `beta=1`, `gamma=2` | Corrected positive cubic coefficient and nonlinear-mobility fixed-seed trajectories | **Validated current** |
| Minimal model | Corrected analytical metadata, but archived trajectories are unsuitable for a fixed-mass figure | **Under review** |
| Subcritical `beta=3` protocol | Correct parameter family; coefficient-dependent branch seeds need regeneration | **Rerun queued** |

The [data and provenance guide](data.md) explains how these labels are assigned.

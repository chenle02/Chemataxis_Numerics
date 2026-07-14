---
title: Cite
---

# Cite this companion

Please cite both the Paper III manuscript and the exact numerical-companion
revision used. GitHub exposes the repository's machine-readable
[`CITATION.cff`](https://github.com/chenle02/Chemataxis_Numerics/blob/master/CITATION.cff)
through **Cite this repository**.

## Suggested data citation

> Chen, Le; Ruau, Ian; and Shen, Wenxian (2026). *Chemotaxis Models III:
> Bifurcation — Numerical Companion and Data Archive*, version 1.0.0. GitHub.
> https://github.com/chenle02/Chemataxis_Numerics

Add the 40-character Git revision and access date:

```text
Repository revision: <40-character Git commit>
Data release: 1.0.0 (2026-07-14)
Accessed: YYYY-MM-DD
```

For the immutable stationary bundle, also record its data commit:

```text
Stationary data revision: e62ffa1e99122f8fbbeb3df7586f4050c4ff5c58
Simulator revision: 7c2a09b24fdebb9000b9b996eb34150d6de5ed17
```

## What to cite for a reproduced result

- Cite the Paper III manuscript for the analytical theorem and coefficient.
- Cite this companion and its exact revision for the published numerical
  tables, states, or figures.
- Cite the simulator revision when reporting a fresh regeneration or modified
  numerical experiment.

The [manifest](data/paper-iii-manifest.json) identifies the manuscript-science
revision and the permitted scope of each public artifact.

## License

The documentation and published numerical material are available under
[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). Attribution must
identify the authors, repository, release version, and exact Git revision.

## Reuse boundary

Only records marked `validated_current` may support current Paper III
numerical statements, and only within their declared semidiscrete scope.
Records marked `provenance_only` document superseded work and must not be used
as quantitative evidence.

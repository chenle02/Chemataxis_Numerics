---
title: Data & provenance
---

# Data and provenance

## One repository, three layers

<div class="provenance-stack" markdown>

1. **Curated evidence** — three hashed manuscript figures and the exact
   stationary values summarized on this site.
2. **Immutable release data** — the complete stationary-continuation v1 bundle
   with file-level SHA-256 digests.
3. **Historical archive** — earlier configurations, trajectories, arrays, and
   galleries retained in Git, including explicitly provenance-only families.

</div>

The layers are intentionally distinct. A file's presence in Git does not make
it current Paper III evidence; the versioned manifest does.

## Immutable stationary bundle

The v1 release lives at
`docs/results/paper-iii/stationary-continuation/v1/` and was frozen in commit
`e62ffa1e99122f8fbbeb3df7586f4050c4ff5c58`.

| File | Purpose |
| --- | --- |
| `branch-points.csv` | One row per case, mesh, and signed amplitude |
| `stationary-profiles.csv` | Long-form nodal `x`, `u`, and `v` profiles |
| `stationary-states.npz` | Compact numerical arrays for all 96 states |
| `states-index.json` | Stable state IDs, array names, and reflection partners |
| `fit-summary.json` | Method, coefficients, gates, runtime, and source provenance |
| `stationary-continuation.pdf/png` | Four-panel release figure |
| `SHA256SUMS` | Digests for every generated file above |

The bundle is deterministic: two complete runs from the same clean simulator
revision were byte-identical. Version `v1` is immutable.

## Evidence manifest

[`paper-iii-manifest.json`](data/paper-iii-manifest.json) is the source of truth
for release 1.0.0. Schema 2.0 records:

- the full Paper III, simulator, figure-source, and data revisions;
- the stationary design, acceptance metrics, case IDs, theoretical
  coefficients, and three-mesh fits;
- all bundle checksums and reader-facing asset hashes;
- the two validated time-integration families and their selected raw runs; and
- four historical families whose status is `provenance_only`.

The standard-library validator resolves each declared object from the Git
index or `HEAD`, then compares the manifest with the archived JSON and SHA-256
records.

## Status vocabulary

| Status | Meaning | Reader-facing quantitative use |
| --- | --- | --- |
| `validated_current` | The named artifact passed the frozen release checks | Allowed only within its declared semidiscrete scope |
| `provenance_only` | Superseded or invalid numerical work retained for audit history | Prohibited |

## Historical archive policy

Historical directory names are never silently rewritten. Some predate the
full center-graph audit and therefore disagree with current classifications;
some branch seeds were built from obsolete coefficients; some minimal-model
time runs have unacceptable mass drift. The raw objects remain available for
reproducibility of the research process, but the curated Results page neither
embeds nor links their galleries.

This policy preserves stable Git paths while preventing an old annotation or
folder label from being mistaken for a current numerical claim.

## Pages delivery boundary

The repository is the complete archive. GitHub Pages is a reader-sized build
that excludes raw arrays, CSV and result PDF files, checksums, per-folder JSON
and YAML, legacy galleries, and duplicate historical media. Reader-facing
pages link to immutable Git objects when direct data access is appropriate.

## Release chain

The provenance order is deliberate:

1. simulator and stationary generator:
   `7c2a09b24fdebb9000b9b996eb34150d6de5ed17`;
2. immutable stationary data:
   `e62ffa1e99122f8fbbeb3df7586f4050c4ff5c58`;
3. manuscript numerical science:
   `fde25e17187bc3f247b36ce411f6f14eb93d52cf`; and
4. this versioned reader-facing companion.

The [citation guide](cite.md) explains how to identify the exact companion
revision used in downstream work.

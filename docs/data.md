---
title: Data & provenance
---

# Data and provenance

## One archive, two delivery layers

The Git repository is the complete archive. It retains configurations,
constants, metadata, raw NumPy arrays, JPEG/PNG renderings, and historical HTML
galleries under `docs/results/`.

The GitHub Pages site is a curated reading layer. Its build deliberately omits
raw arrays, duplicate media, legacy galleries, and per-folder support files.
Reader-facing pages link back to the corresponding GitHub tree, so the archive
paths remain stable without pushing roughly a gigabyte of experiment material
through Pages.

```text
docs/results/
  <experiment family>/
    <classification>/
      <parameter slug>/
        config.yaml
        constants.json
        run_plan.json
        runs/
          <run slug>/
            run_meta.json
            run.npz
            run_summary6.png
```

## Evidence manifest

[`docs/data/paper-iii-manifest.json`](data/paper-iii-manifest.json) is the source
of truth for the curated layer. Each case records:

- its exact raw archive path;
- the manuscript figure role, if any;
- validated-current or under-review status, plus any separate rerun
  requirements;
- the analytical values approved by the current audit;
- archive objects that exist without treating provisional coefficients as
  final analytical values, including an explicit corrected-versus-archived
  record when those values differ;
- selected run paths, manuscript-matched figure assets, and legacy-preview
  status; and
- the precise boundary on permissible claims.

The validator reads constants directly from the referenced Git objects. This
means a sparse checkout can verify provenance without materializing every raw
array.

## Status vocabulary

| Status | Meaning | Quantitative use |
| --- | --- | --- |
| `validated_current` | Corrected analysis and archived metadata agree | Allowed within the named scope |
| `under_review` | The archive needs a conservative rerun, corrected initialization, or is retained only for provenance | Not allowed |

## Historical paths

Several directory names predate the full center-graph audit. In particular,
the all-ones `beta=1` non-minimal archive is stored below `subcritical` but is
supercritical, while the two minimal-model directory names are reversed by the
corrected coefficients. Paths are not renamed because they are stable
provenance identifiers; the committed `constants.json`, per-family README, and
manifest carry the current interpretation.

## Integrity and versioning

Git object identity supplies the present file-level audit trail. A tagged data
release with checksums and an archival DOI is planned after the conservative
minimal rerun and corrected subcritical continuation experiment. Until then,
cite the repository URL and the commit used for analysis.

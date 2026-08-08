# Verification tiers redesign (2026-08)

Status: design only for branch `redesign/verification-tiers-2026-08`.
Scope: add a three-tier verification architecture to `Chemataxis_Numerics`
without moving or relabeling any existing evidence in this branch.

## 0. Existing anchors to extend, not replace

- `README.md` already distinguishes reader-facing evidence from provenance-only
  archives and exposes verify/pages badges.
- `.github/workflows/verify.yml` already enforces a fast manifest + docs gate.
- `.github/workflows/pages.yml` already deploys the strict MkDocs build.
- `docs/data/paper-iii-manifest.json` already encodes a two-layer evidence
  contract (`validated_current` vs `provenance_only`).
- `scripts/validate_paper3_manifest.py` is already the dependency-free public
  contract checker.
- `docs/` is already a curated reading layer over a much larger Git archive.

The redesign should therefore preserve the current public contract model and
generalize it from a one-release manifest to a three-tier verification ledger.

## 1. Three evidence tiers

### T1 — run-card evidence in `docs/results/`

Purpose: freeze every reader-facing numerical case as a structured, hashed,
portable artifact card.

Each curated case folder gets a `run-card.yaml` with this minimum schema:

| Field | Meaning |
| --- | --- |
| `case_id` | stable identifier used by docs, CI, and manuscript sync |
| `paper` / `claim_scope` | human-readable claim boundary |
| `parameters` | `a,b,alpha,beta,m,gamma,mu,nu,c` and equilibrium mode |
| `L`, `n0` | domain length and critical mode |
| `chi_star` | closed-form threshold at the demonstration beta |
| `chi_star_disc` | discrete threshold at the production mesh |
| `beta_n0_closed_form` | signed cubic coefficient from the canonical verifier |
| `expected_regime` | `supercritical` / `subcritical` / `degenerate` |
| `measured_c2_sign` | sign returned by stationary continuation |
| `meshes` | mesh list used for the sign/convergence gate |
| `artifacts` | relative paths + SHA-256 for figures, JSON, CSV, NPZ, checksums |
| `provenance` | simulator revision, verifier revision, data revision |
| `status` | `validated_current`, `candidate`, or `provenance_only` |

Notes:

- T1 is the public-facing ledger layer; it does not recompute the science.
- `constants.json` may remain as a legacy/generated file during migration, but
  `run-card.yaml` becomes the authoritative per-case record.
- The current four stationary cases and two current time-figure families each
  receive run cards; the historical archives remain explicitly
  `provenance_only`.

### T2 — NumPy/SymPy closed-form verification

Purpose: adversarially check the mathematical classification logic behind the
 run cards.

This tier is the public, machine-checkable realization of
`verify_paper3_quadratic_abc.py` plus the symbolic coefficient package. It
must verify at least:

- exact quadratic decomposition `beta_n0(beta)=A beta^2 + B beta + C`;
- the ten verification families already validated to ~`1e-15`;
- the canonical regime classification used in every run card;
- consistency of `chi_star`, `chi_star_disc`, and `beta_n0` with the selected
  case metadata.

T2 is the first place where a label can fail. If a run card says
`subcritical` but T2 computes `beta_n0 > 0`, CI fails immediately even before
any heavy numerics start.

### T3 — Lean formal proof

Purpose: give a proof-grade certificate that the closed-form quadratic identity
is not only numerically right but algebraically forced.

The Lean artifact is `Paper3QuadraticABC.lean`. In the redesigned companion it
should be treated as a third evidence tier with its own status field in the
ledger:

- `passed` when the Lean job builds the theorem under the pinned mathlib cache;
- `stale` when T2 changed but T3 was not rerun;
- `not_applicable` for cases that depend only on T1/T2 data promotion.

T3 does not replace T2. Lean proves the formula; T2 checks the case matrix and
floating-point manifestations used by the public artifacts.

## 2. Canonical-code-home decision

### Options evaluated

| Option | Pros | Cons |
| --- | --- | --- |
| (a) `Chemotaxis_simulation` is canonical | already public; already owns `implied_constants.py`; stationary validator was explicitly designed to be publishable there; natural home for CI-executed numerics | requires moving Paper III symbolic verifier out of manuscript repo |
| (b) `verification/` subtree in data repo | keeps companion self-contained; easy to cite from this repo | turns a frozen evidence repo into the mutable source of scientific truth; awkward for the simulator package to consume |
| (c) submodule/subtree links | reduces file copying | adds a third sync surface, weakens offline/Overleaf ergonomics, and complicates release pinning |

### Recommendation: option (a)

Make `Chemotaxis_simulation` the **single canonical home for executable
verification logic**, in a dedicated public subtree such as:

```text
Chemotaxis_simulation/
  verification/paper3/
    run_cards.py
    verify_quadratic_abc.py
    stationary_branch_validation.py
    lean/Paper3QuadraticABC.lean
    cases/*.yaml
```

Rationale:

1. The duplication problem already centers on the simulator repo's
   `implied_constants.py` versus manuscript-repo symbolic code; canonicalizing
   in the simulator repo collapses the split at the point where public code
   already lives.
2. The stationary validator already advertises itself as independent of the
   manuscript-only package and suitable for publication with the simulator.
3. The data repo should remain the frozen evidence and release-ledger layer,
   not the moving source of scientific logic.
4. Separate workflow badges become honest: code/verifier health belongs to the
   simulator/verification release; evidence-contract health belongs here.

### Consumption contract

- **Data repo**: pins one released simulator verification revision and imports
  it in CI; no local forks of the mathematics.
- **Manuscript repo**: vendors an exact snapshot of the verification subtree
  under a tracked `codes/vendor/chemotaxis_verification/` path, with a
  SHA-256 manifest and pinned source revision. This vendor step happens by an
  explicit sync script, never by `pip install` during `latexmk`.
- **No compile-time fetch**: Overleaf/arXiv/journal builds read only vendored
  files and vendored figures.

Rejected alternatives:

- **(b)** would make the public data repo simultaneously the mutable code home
  and immutable evidence home; those roles want different branching and release
  rhythms.
- **(c)** increases operational complexity for little gain and is hostile to the
  offline manuscript build requirement.

## 3. CI architecture

Use three verification workflows plus the existing Pages deploy workflow.
Separate workflows, not separate jobs in one workflow, are preferred because
README needs per-tier badges.

### 3.1 Fast tier — extend `verify.yml`

Trigger: every push and PR on every branch.

Responsibilities:

1. install lightweight verification dependencies;
2. validate `run-card.yaml` files against a committed schema;
3. run the T2 closed-form harness on the frozen family set;
4. enforce the label gate on committed artifacts:
   `run-card expected_regime == sign(beta_n0_closed_form)`;
5. check that committed measured signs (if present) agree with the declared
   regime;
6. run `scripts/validate_paper3_manifest.py` (or its generalized successor);
7. validate `CITATION.cff`;
8. build MkDocs strictly and compare `site/` with committed `docs/` snapshot.

Failure rule (CI-as-adversary): any disagreement among run-card label, T2
closed form, and committed measured sign is a hard failure.

### 3.2 Heavy tier — new `verify-heavy.yml`

Trigger:

- `schedule:` nightly;
- `workflow_dispatch:`;
- path-triggered on changes to canonical verification code, case definitions,
  run-card schema, or promotion manifests.

Responsibilities:

1. run stationary sign checks at `N=80` for every case flagged
   `status in {candidate, validated_current}`;
2. confirm `sign(c2_measured) == sign(beta_n0_closed_form)`;
3. upload generated summaries as CI artifacts;
4. refuse automatic promotion of mismatching cases.

This tier is deliberately measurement-only and moderate-cost: it is the
adversarial sign gate, not the full 3-mesh publication rerun.

### 3.3 Lean tier — new `verify-lean.yml`

Trigger: only when files under the Lean path change, plus manual dispatch.

Implementation:

- standard Lean 4 action on `ubuntu-latest`;
- `lake exe cache get` before build;
- build only the Paper III Lean package subtree;
- upload build log and theorem status summary.

The Greenwood rule "never local Lean" does **not** apply to cloud CI runners;
it remains a workstation-safety rule.

### 3.4 Pages tier — keep `pages.yml`

`pages.yml` remains the publication workflow, but it should depend on the fast
tier being green and should publish the new verification-ledger page.

## 4. Site/dashboard redesign

Add `docs/verification-ledger.md` and place it in the MkDocs nav between
`Results` and `Reproduce`.

The page should present one row per case:

| Case | Closed-form regime | Measured sign | Mesh convergence | Lean status | Public status |
| --- | --- | --- | --- | --- | --- |

Recommended behavior:

- green row only if T1/T2/T3 agree where applicable;
- amber row for `candidate` cases awaiting owner promotion;
- grey row for `provenance_only` archives;
- direct links to run card, immutable bundle, fit summary, and paper figure.

README badge redesign:

- `Fast verify` → `verify.yml`
- `Heavy sign gate` → `verify-heavy.yml`
- `Lean proof` → `verify-lean.yml`
- `Deploy Pages` → `pages.yml`

The current README evidence ledger can stay, but its counts should be sourced
from the machine-readable ledger generator rather than hand-maintained prose.

## 5. Migration plan

### Phase M0 — one-time repository repair (owner-gated)

Before any content promotion:

1. repair the broken local `Chemataxis_Numerics` checkout (behind by dozens of
   commits, Dropbox conflict files, missing `minimal_model/` locally);
2. fast-forward to current `origin/master`;
3. record the repair in an audit note so later label changes are not blamed on
   Dropbox residue.

This is operational repair, not scientific redesign.

### Phase M1 — canonical-home extraction

Move the Paper III verification logic from the manuscript repo into the chosen
canonical home (`Chemotaxis_simulation/verification/paper3/`).

Targets:

- closed-form coefficient package now living under
  `codes/chemotaxis_symbolic/`;
- `verify_paper3_quadratic_abc.py`;
- stationary validator driver and case definitions;
- Lean file `Paper3QuadraticABC.lean`.

The manuscript repo becomes a vendor consumer, not the primary authoring home
for these files.

### Phase M2 — run-card layer

Add run cards for all currently curated Paper III evidence and for all
provenance-only archives. During this phase, do **not** relabel folders yet;
instead, encode the corrected regime in the run card and keep the historical
folder path as provenance.

### Phase M3 — owner-gated relabel promotion

Design target only; not executed on this branch.

Pending relabel set from the restructure plan:

- all 4 `high_modes/subcritical/*m0p5_beta1_gamma{2,3}*` folders;
- both `minimal_model/*` folders (currently swapped);
- `quasilinear/a=1` small-β rows currently living under `subcritical`.

Promotion rule:

1. relabel only after T2 and heavy-tier measured sign agree;
2. regenerate all derived artifacts that encode labels:
   `constants.json`, per-folder `README.md`, galleries, site summaries, and any
   aggregated manifests;
3. retain historical paths in provenance metadata if user-facing URLs must not
   silently vanish.

### Phase M4 — new high-mode evidence

Add the new high-mode cases from plan §3 as **future CI-produced artifacts**,
not hand-curated one-offs:

- `(m,gamma)=(1/2,2)`, `L=5.3`, `n0=2`, `beta=1` and `beta=2`;
- `(m,gamma)=(1/2,2)`, `L=8`, `n0=3`, `beta=1` and `beta=2`.

These should enter first as `candidate` cases with generated run cards and CI
artifacts, then be promoted to `validated_current` only after owner review.

## 6. Vendoring contract for the manuscript repo

### Published source of truth

Each promoted companion release publishes:

1. a versioned release artifact (for example
   `paper3-companion-vX.Y.Z.tar.gz`);
2. a release-level `SHA256SUMS` manifest;
3. a machine-readable ledger file enumerating the exact figures/data intended
   for manuscript consumption.

### Manuscript-side storage

The manuscript repo stores a vendored snapshot under a tracked path such as:

```text
Submission/Paper-III/vendor/companion/vX.Y.Z/
```

including:

- paper-facing PDF/PNG figures;
- release manifest / ledger JSON;
- selected run cards or summary tables if cited in prose;
- a text file pinning the simulator verification revision and release hash.

### One-command verified sync sketch

Sketch only (not implemented here):

```bash
codes/sync_paper3_companion.sh \
  --source ../Chemataxis_Numerics \
  --release vX.Y.Z \
  --dest Submission/Paper-III/vendor/companion/vX.Y.Z
```

Required behavior:

1. copy only whitelisted release artifacts;
2. verify every copied file against the release `SHA256SUMS` and the ledger;
3. write a local manifest recording source repo, commit, release tag, and
   copied hashes;
4. fail closed on missing or extra files;
5. never execute during `latexmk`, Overleaf compile, arXiv upload build, or
   journal source build.

Compile rule: the manuscript always reads local vendored assets. Network access
is forbidden at compile time.

## 7. Open questions for the owners

### Ian (numerics gate)

1. Is `Chemotaxis_simulation` acceptable as the single canonical home for the
   executable Paper III verification stack?
2. Should heavy-tier CI stop at `N=80` sign checks, or should some candidate
   cases immediately require the full 3-mesh publication gate?
3. Do relabeled historical folders keep old paths plus metadata overlays, or do
   we accept reader-visible path changes at the first promoted verification-tier
   release?

### Wenxian (mathematical narrative)

1. Should the public site explicitly present the `beta`-crossover story as a
   named mathematical claim, or keep it as supporting numerical organization?
2. Is the high-mode public narrative best grouped by `(m,gamma)` family or by
   mode number `n0`?
3. How prominently should `provenance_only` historical mislabels be explained to
   readers versus left to the audit ledger?

### Le (layout and canonical-home decision)

1. Approve or reject the recommendation that the simulator repo, not the data
   repo, becomes canonical for executable verification logic.
2. Decide whether `docs/design/` remains internal design history or is linked in
   site navigation as public project-method documentation.
3. Decide whether the manuscript should vendor only figures + manifests, or a
   larger companion slice including run cards and validator summaries.

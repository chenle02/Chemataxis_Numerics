# Where code lives, and why it must be committed

Written 2026-08-09 after two incidents in one session: a load-bearing analysis
script sat untracked for hours while its results were being relied on, and an
automated agent wrote an unwanted checker straight into this public repository.

## The rule

**If a result depends on it, it is committed before the result is used.**

Scratch exploration is fine. The moment output informs a decision, a document
or a commit message, the code that produced it belongs in a repository. Work
performed in `/tmp` is unreproducible by construction: nobody can re-derive the
number, and nobody can review the method.

## Which repository

| Code | Home | Test |
|---|---|---|
| Reusable simulation / coefficient computation | `Chemotaxis_simulation` | Would another project want it? |
| Validators and generators for published artifacts | this repo, `scripts/` | Does CI here need to run it? |
| Paper-specific analysis, one-off waves, figure generation | manuscript repo, `codes/` | Is it meaningful only for this paper? |

A checker that validates **this** repository's artifacts belongs **here**, so
that this repository's CI can run it without depending on a private repository.
That is why `audit_archived_constants.py` was moved here on 2026-08-09.

## Single source of truth

Do not copy a module between repositories. A copy diverges silently, and the
divergence is invisible until something built on the stale copy is published —
which is precisely the failure this project already paid for once, with cached
`beta_n0` values.

**Known outstanding violation:** `stationary_branch_validation.py` exists in
both `Chemotaxis_simulation` (1404 lines) and the manuscript repo
(1459 lines), diverging by ~118 lines; the manuscript copy is ahead. This is
recorded rather than silently tolerated. It does not affect the CI gate, which
imports only `implied_constants` from the simulator.

## Enforcement

`scripts/check_tracked_code.py` fails when any `*.py` or `*.sh` in this
repository is untracked, or is hidden by a `.gitignore` rule. It runs in
`Verify data contract` on every push and pull request.

It is intentionally narrow. It does not judge code quality; it only insists
that code exists in version control where a reviewer can see it.

## Derived artifacts

This repository commits computed artifacts. Any value derived by code and then
cached in a committed file must have a check that recomputes it and compares.
Without one, an upstream correction reaches only the artifacts someone happens
to regenerate, and the rest go stale undetectably.

The working example is `.github/workflows/constants-drift.yml`, which
recomputes every archived bifurcation coefficient against the simulator
revision pinned in the manifest.

Two properties make that gate trustworthy, and any similar gate should copy
them:

1. **A validity control.** `chi_star` is unaffected by the correction being
   checked, so it must reproduce exactly. If it drifts, the parameter mapping
   is wrong and the comparison is reported as void rather than as a finding.
2. **Tamper tests.** The gate was verified to fail on an injected sign flip and
   on an injected magnitude drift. A gate that passes because it never fires is
   worse than no gate, because it also confers false confidence.

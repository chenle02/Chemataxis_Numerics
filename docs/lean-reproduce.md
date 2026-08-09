---
title: Re-run the Lean proof
---

# Re-run the Lean proof

You do not need to know how to write Lean proofs to check this package. The
commands below download the exact Lean version, reuse mathlib's compiled cache,
build every proof, compute the axioms used by every checked theorem, and verify
the committed receipt.

## What you will need

Install these three tools:

1. [Git](https://git-scm.com/downloads), which downloads the repository.
2. [Lean through `elan`](https://lean-lang.org/install/), Lean's toolchain
   manager. The repository's `lean-toolchain` file automatically selects Lean
   `v4.32.2`; do not replace it with whatever version happens to be newest.
3. [Python 3](https://www.python.org/downloads/), used only for the receipt and
   axiom-report checks.

On macOS or Linux, the official `elan` installer can be run with:

```bash
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh
```

Close and reopen the terminal after installation. On Windows, follow the
Windows instructions on the Lean installation page. Git Bash, installed with
Git for Windows, can run the one-command script below.

!!! note "Disk space and first-run time"
    Mathlib is large. Allow several gigabytes of free disk space. The first
    cache download can take several minutes; later runs are much faster.

## Download only the proof subtree

The full repository contains large numerical arrays and images. A sparse clone
avoids downloading their contents:

```bash
git clone --depth 1 --filter=blob:none --sparse \
  https://github.com/chenle02/Chemataxis_Numerics.git
cd Chemataxis_Numerics
git sparse-checkout set verification/paper3
```

After this, the proof source is in `verification/paper3/lean/`.

## Easiest check: one command

From the repository root, run:

```bash
bash verification/paper3/verify.sh
```

The script stops immediately if a step fails. A successful run ends with:

```text
OK  live axiom audit: 167 theorems; sanctioned axioms ['Classical.choice', 'Quot.sound', 'propext']
OK  167 theorems, 26 files, toolchain leanprover/lean4:v4.32.2
PASS: the canonical Paper III Lean verification is reproducible.
```

## Manual check, with every step explained

Enter the Lean package directory:

```bash
cd verification/paper3/lean
```

### 1. Confirm that Lean is available

```bash
lake --version
```

`lake` is Lean's project build tool. If the command is not found, reopen the
terminal after installing `elan`. Running any `lake` command in this directory
causes `elan` to install the pinned Lean version when necessary.

### 2. Download the compiled mathlib cache

```bash
lake exe cache get
```

The proofs use mathlib. This command downloads precompiled dependencies instead
of compiling all of mathlib from source. Wait for `Completed successfully`.

### 3. Build every proof module

```bash
lake build
```

This compiles all default targets in `lakefile.toml`. The receipt-grade build
completed 8,696 jobs. The important message is:

```text
Build completed successfully (8696 jobs).
```

A successful build means Lean's kernel accepted every declaration, but Lean
allows unfinished `sorry` placeholders during ordinary builds. Therefore the
next step is essential.

### 4. Compute the live axiom report

```bash
lake env lean AxiomCheck.lean > axiom-report.txt
python3 make_receipt.py audit --axiom-output axiom-report.txt
```

`AxiomCheck.lean` asks Lean to print the axioms used by all 167 checked
declarations. The Python audit requires exactly the standard axioms
`propext`, `Classical.choice`, and `Quot.sound`. It fails if it sees `sorryAx`,
if a theorem is missing, if an undeclared theorem appears, or if an audit
directive is duplicated.

Expected result:

```text
OK  live axiom audit: 167 theorems; sanctioned axioms ['Classical.choice', 'Quot.sound', 'propext']
```

You may delete `axiom-report.txt` after the check; it is a generated log.

### 5. Verify the historical receipt

```bash
python3 make_receipt.py verify
```

This compares the current files with `lean-receipt.json`. It checks all 26
receipt-bound file hashes, the toolchain, the resolved mathlib dependencies,
the theorem list, and the recorded axiom set.

Expected result:

```text
OK  167 theorems, 26 files, toolchain leanprover/lean4:v4.32.2
```

The live audit and receipt check answer different questions:

- the **live audit** asks Lean what the code you just built depends on;
- the **receipt check** asks whether your checkout is exactly the audited
  source and pinned environment recorded by the project.

Both must pass.

## Try one small theorem file

To see a shorter build, compile the discrete-mass proof alone:

```bash
lake env lean Paper3ConservativeMass.lean
```

No output and exit status zero means the file compiled successfully. Open the
file in a text editor to see three declarations: flux telescoping, the direct
weighted rate identity, and the manuscript-facing conservative-scheme theorem.

## Common problems

| Message or symptom | What to do |
| --- | --- |
| `lake: command not found` | Reopen the terminal. If it persists, repeat the official `elan` installation. |
| `python3: command not found` | Install Python 3. On some Windows setups the command is `python`; Git Bash with a standard Python installation normally provides `python3`. |
| `no configuration file ... lean-toolchain` | You are in the wrong directory. Change to `verification/paper3/lean/`. |
| Cache download fails | Check the network and rerun `lake exe cache get`; the command is safe to repeat. |
| `hash mismatch` or `receipt is stale` | Your files differ from the audited source. Run `git status`, restore a clean checkout, and retry. Do not describe a modified checkout as receipt-backed. |
| `sorryAx` appears | At least one result contains an unproved placeholder. The verification must be rejected until that dependency is removed and a new receipt-grade audit is published. |
| Build is killed or disk fills | Free several gigabytes and rerun. The cache avoids rebuilding completed dependencies. |

## What passing does—and does not—mean

Passing proves that Lean accepted the 167 declarations at the boundaries listed
in the [statement coverage ledger](lean-verification.md), with the recorded
axiom set and exact source/dependency hashes. It does not claim that the full
PDE center-manifold, global-bifurcation, or numerical-measurement statements
have been formalized. Those exclusions are listed explicitly in the ledger.

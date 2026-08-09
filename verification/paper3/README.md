# Paper III Lean verification

This is the canonical public source for the Lean verification accompanying
*Chemotaxis models with signal-dependent sensitivity and a logistic-type
source. III: Bifurcation*.

## What is canonical

- Proof package: [`lean/`](lean/)
- Verification version: [`VERSION`](VERSION)
- Receipt: [`lean/lean-receipt.json`](lean/lean-receipt.json)
- Coverage ledger: [`../../docs/lean-verification.md`](../../docs/lean-verification.md)
- Import provenance: [`IMPORT-PROVENANCE.json`](IMPORT-PROVENANCE.json)

The Python simulator remains canonical at
[`ianruau/Chemotaxis_simulation`](https://github.com/ianruau/Chemotaxis_simulation).
The private manuscript repository may retain a hash-pinned vendor snapshot,
but proof changes originate here after this import.

## Rebuild

The package pins Lean `v4.32.2`, mathlib, and every transitive dependency.
From `verification/paper3/lean/` run:

```bash
lake exe cache get
lake build
lake env lean AxiomCheck.lean > axiom-report.txt
python3 make_receipt.py audit --axiom-output axiom-report.txt
python3 make_receipt.py verify
```

The accepted live axiom set for every one of the 167 checked declarations is
exactly `propext`, `Classical.choice`, and `Quot.sound`. Any `sorryAx`, missing
theorem, extra theorem, duplicate audit directive, hash drift, toolchain drift,
or dependency drift fails the gate.

The receipt-grade local rebuild was performed in a pristine source-only
directory on Home-Dell. GitHub Actions repeats the build and live axiom audit
on changes to this subtree.

## Authorship and scope

The mathematical statements come from the three-author Paper III manuscript.
Wenxian Shen is not represented as an author of the Lean source. Formalization
maintenance and code licensing are recorded separately from manuscript
authorship.

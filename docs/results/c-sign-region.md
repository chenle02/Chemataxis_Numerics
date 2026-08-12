---
title: Sign of C in the cubic coefficient
---

# Where the cubic coefficient starts negative

!!! warning "Evidence tier — symbolic, screened, not `validated_current`"
    This page reports an **exact symbolic computation** (sympy), deterministic and
    reproducible from a committed script. It is *not* a numerical simulation and
    therefore does not carry the `validated_current` tier of the
    [manifest evidence policy](../data.md): it has no branch-slope label gate to
    pass. Every parameter point is screened against the standing hypotheses of
    the local-bifurcation theorem, and points failing that screen are retained in
    the data but are **not** counterexamples to anything. Promotion to
    reader-facing validated evidence is an author decision.

## What this is

Paper III writes the cubic coefficient of the reduced pitchfork equation as a
quadratic in the desensitization exponent `beta`:

```
beta_n0(beta) = A beta^2 + B beta + C ,        C = beta_n0(0)
```

and proves that `A < 0` throughout the admissible parameter range. The direction
classification — supercritical below a single threshold `beta^+`, subcritical
above it — additionally requires **`C > 0`**, which is a separate hypothesis and
not a consequence of `A < 0`.

This dataset maps where that hypothesis holds.

## Headline: the threshold is governed by `gamma`, almost alone

Eight parameter families, twelve production exponents each: **96 screened
points, 37 of them admissible with `C < 0`.**

| family | `m` | `b` | `nu` | `mu` | `L` | `C<0` count | `gamma` bracket for `C = 0` |
|---|---|---|---|---|---|---|---|
| base | 1 | 1 | 1 | 1 | 1 | 4 | [4.25, 4.5] |
| small-b | 1 | 0.2 | 1 | 1 | 1 | 4 | [4.25, 4.5] |
| small-m | 0.5 | 1 | 1 | 1 | 1 | 4 | [4.25, 4.5] |
| small-m-small-b | 0.5 | 0.2 | 1 | 1 | 1 | 4 | [4.25, 4.5] |
| large-m | 2 | 1 | 1 | 1 | 1 | 5 | [4, 4.25] |
| fast-signal | 1 | 1 | 10 | 1 | 1 | 4 | [4.25, 4.5] |
| strong-decay | 1 | 1 | 1 | 5 | 1 | 6 | **[3.5, 4]** |
| long-domain | 1 | 1 | 1 | 1 | 2 | 6 | **[3.5, 4]** |

Fixed throughout: `a = 1`, `alpha = 1`, `n_0 = 1`.

**`C > 0` requires roughly `gamma <~ 4`, across every family sampled.** The
sign change is controlled almost entirely by the production exponent, and only
weakly by `(m, b, nu, mu, L)`. Stronger signal decay (`mu = 5`) and a longer
domain (`L = 2`) push the threshold down to `[3.5, 4]`.

Both parameter families reported in the manuscript use `gamma = 1`, which is why
the issue does not appear there.

## What happens when `C < 0`

With `A < 0` the product of the roots is `C/A`. While `C > 0` that product is
negative, so the roots have opposite signs and exactly one is positive — the
`beta^+` of the classification. Once `C < 0` the product turns positive, the
negative root crosses the origin, and there are **two** positive roots
`0 < beta_1 < beta_2`. The direction pattern becomes subcritical, supercritical,
subcritical.

Representative admissible case, base family at `gamma = 5`:

```
A = -0.101009    B = +16.314390    C = -6.996476
positive roots:  beta_1 = 0.4300 ,  beta_2 = 161.085
```

### The second root is not physical; the first one is

`beta_2` is large in every case located here — 67.65 at best, up to `4.7e7`.
There is a structural reason: the root sum is `B/|A|`, and `B` dominates `|A|`
throughout the `C < 0` region, so no search in this family will produce a
moderate second root.

The consequence that matters is therefore **`beta_1`**, which ranges over
roughly `0.04 .. 1.1` in the physically sensible families. On `[0, beta_1)` the
bifurcation is subcritical — an inversion relative to the `C > 0` picture, at
ordinary values of the desensitization exponent.

## Caveats

- `gamma_critical_bracket` in the data is a **grid bracket**, not a solved root.
  `C` is sampled at the listed `gamma` values only.
- Rows with `b = 5` in the wider working-repository scan are unphysical on
  **both** roots (`beta_1` from 56.6 up to `2.1e5`) and should not be cited as
  evidence. They are excluded from the families above.
- Admissibility here means: `n_0` is the unique minimiser of `chi_n(u*)`,
  `sigma_{2n_0}(chi*) < 0`, and `u*, v*, chi* > 0`. It does **not** assert that a
  family is physically interesting.

## Data and reproduction

- Data: [`paper-iii-c-sign-scan.json`](../data/paper-iii-c-sign-scan.json) —
  96 records with `A`, `B`, `C`, positive roots, admissibility verdict and the
  minimising mode for every point.
- Reproducers, in the Paper III working repository:
  - `codes/c_sign_probe.py` — single-point evaluation with the admissibility screen
  - `codes/c_sign_region_sweep.py` — the eight-family sweep that produced this data
  - `codes/two_roots_hunt.py` — direct bracketing of the two roots
  - `codes/plot_c_sign.py` — the manuscript figure

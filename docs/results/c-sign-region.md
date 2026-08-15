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

## Why the threshold is governed by `gamma`

Setting `beta = 0` in the assembled cubic coefficient gives an **exact identity**
splitting `C` into two competing parts:

```
C  =  [ c_1 (4 a_{0,1} + 2 a_{2n_0,1}) + c_3 ]   -   chi^* Gamma_{n_0}^{(3)}
      \________ logistic ________/                  \___ chemotactic ___/
```

`c_3` carries the factor `alpha - 1`, so it vanishes identically in the
quadratic-logistic case `alpha = 1`. Since `chi^* > 0`, the chemotactic term
carries the sign of `-Gamma_{n_0}^{(3)}`.

Across the crossing at `gamma ~ 4.25` in the base family the two parts behave
very differently:

| | at `gamma = 4.25` | at `gamma = 4.5` | change |
|---|---|---|---|
| logistic | −0.3106 | −0.2853 | **+0.025** |
| chemotactic | +0.3491 | −1.7825 | **−2.13** |
| `C` | +0.0385 | −2.0678 | — |

`Gamma_{n_0}^{(3)}` itself changes sign there (−0.124 → +0.670). The chemotactic
projection is therefore what destroys `C > 0`, and it is why the production
exponent is the controlling parameter.

### What is NOT true

The attractive clean statement — *"`C > 0` requires `Gamma_{n_0}^{(3)} < 0`"*,
which would follow if the logistic term were always negative — is **false**.
A scope scan of **72 admissible points** (`scope_scan` in the data file) found:

- the logistic term **non-negative at 12 points**, all with `m = 2`;
- `sign(C)` differing from `sign(-Gamma_{n_0}^{(3)})` at **2 points**.

So neither part is sign-definite. The decomposition is an identity; the
dominance of the chemotactic term is an empirical statement about the sampled
range, not a theorem. This is recorded because the clean version is the natural
thing to assume and it does not hold.

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

- Data: [`paper-iii-c-sign-decomposition.json`](../data/paper-iii-c-sign-decomposition.json)
  — the `gamma` sweep of the two parts plus the 72-point `scope_scan`.
- Data: [`paper-iii-c-sign-scan.json`](../data/paper-iii-c-sign-scan.json) —
  96 records with `A`, `B`, `C`, positive roots, admissibility verdict and the
  minimising mode for every point.
- Reproducers, in the Paper III working repository:
  - `codes/c_sign_probe.py` — single-point evaluation with the admissibility screen
  - `codes/c_sign_region_sweep.py` — the eight-family sweep that produced this data
  - `codes/two_roots_hunt.py` — direct bracketing of the two roots
  - `codes/plot_c_sign.py` — the manuscript figure

## When `beta_n0` stays negative for every `beta`

Wenxian Shen asked (2026-08-13) whether the sub-case

```
C < 0   and   beta_n0(beta) < 0  for all beta >= 0
```

can occur, or is excluded. It **occurs**, on an open set of admissible
parameters, so the `C < 0` branch splits into two genuinely different patterns
rather than one.

### Criterion

With `A < 0` the parabola opens downward, and `C < 0` puts `beta_n0(0)` below
the axis, so `beta_n0` can reach `[0, infinity)` only through a positive root.
The roots multiply to `C/A > 0` and therefore share a sign, and they sum to
`-B/A`. Hence, writing `D = B^2 - 4AC`:

| condition | pattern |
|---|---|
| `B <= 0` | `beta_n0 < 0` on all of `beta >= 0` — subcritical throughout |
| `B > 0` and `D < 0` | `beta_n0 < 0` on all of `beta >= 0` — subcritical throughout |
| `B > 0` and `D >= 0` | two positive roots `beta_1 < beta_2` — sub / super / sub |

So the case is **not** excluded by sign considerations; the question is whether
the admissible region reaches it.

### Witness

`a = b = m = gamma = nu = mu = L = 1` with `alpha = 5`, admissible, minimising
index `n_0 = 1`, `sigma_{2n_0}(chi*) = -28.5068`:

```
A = -0.00613654      B = -11.4039      C = -2.92797
```

All three coefficients are negative, so `beta_n0(beta) < 0` for every
`beta >= 0` immediately. Confirmed by evaluating `beta_n0` directly, not through
`A, B, C`:

| `beta` | 0 | 1 | 5 | 50 |
|---|---|---|---|---|
| `beta_n0` | -2.92797 | -14.338 | -60.1009 | -588.464 |

This family sits at `gamma = 1`, the value both manuscript families already use,
and differs from the two-root counterexample only in `(alpha, gamma)`.

### How large the region is

175 admissible-screened points across five targeted 2-D sweeps crossing `alpha`
against the knobs that drive `C` negative (`m`, `b`, `a`, `mu`, `gamma`). The
grid was deliberately built to *realise* the case rather than to reconfirm the
reference point — a "not found" from a confirmatory grid would carry no
information.

| quantity | value |
|---|---|
| points evaluated | 175 |
| with `C < 0` | 59 |
| realising the case | 41 |
| of those, admissible | 41 (all) |
| admissible points with `A >= 0` | 0 |
| `alpha` values realising it | 3, 4, 5, 6, 8 |

**Mechanism.** All 41 realisations arrive through `B <= 0`; none through
`D < 0`. The closest approach to a negative discriminant (`D ~ 0.27` at
`alpha = 8`, `mu = 100`) was inadmissible. So it is the sign of `B`, not the
discriminant, that selects between the two patterns. `alpha` is what drives `B`
negative, but it pushes `C` positive at the same time, which is why the sweeps
cross `alpha` against the `C`-negative knobs.

### Data and reproduction

- Data: [`paper-iii-beta-n0-all-negative.json`](../data/paper-iii-beta-n0-all-negative.json)
  — all 175 records with `A`, `B`, `C`, `D`, admissibility and the sweep name,
  plus the 41 hits and a summary block.
- Data: [`paper-iii-beta-n0-sensitivity.json`](../data/paper-iii-beta-n0-sensitivity.json)
  — the one-at-a-time pass that located `alpha` as the knob flipping `B`.
- Reproducer, in the Paper III working repository:
  `codes/beta_n0_all_negative_hunt.py --mode hunt`.

## Where the supercritical window lives

The organising object is not the sign of a coefficient but the **supercritical
window** itself. Since `A < 0` throughout the admissible range,

```
{ beta >= 0 : beta_n0(beta) > 0 }
```

is exactly the part of the interval between the two roots that lies in
`[0, infinity)`. With `D = B^2 - 4AC` and `beta_pm = (B -+ sqrt(D)) / (2|A|)`:

| condition | window | is `beta = 0` inside? |
|---|---|---|
| `C > 0` | `[0, beta_+)` | **yes** |
| `C < 0`, `B > 0`, `D > 0` | `(beta_-, beta_+)` | **no** |
| otherwise | **empty** | subcritical for every `beta >= 0` |

So the sign of `C` decides only *whether `beta = 0` sits inside the window*.
Note `D = 0` leaves the window **empty** rather than degenerate, since the two
roots coincide.

### Sweep

82 points, eight parameters, each varied with the others held at
`a = b = m = gamma = nu = mu = L = 1`, `n_0 = 1`. **This is the first sweep in
which `nu` and `L` were varied at all** — both had previously been pinned at 1.

| parameter | points | admissible | nonempty window | window empty at |
|---|---|---|---|---|
| `gamma` | 15 | 15 | 15 | -- |
| `alpha` | 13 | 13 | 9 | 5, 6, 7, 8 |
| `m` | 11 | 11 | 11 | -- |
| `b` | 10 | 10 | 10 | -- |
| `mu` | 8 | 8 | 8 | -- |
| `nu` | 8 | 8 | 8 | -- |
| `L` | 9 | 7 | 7 | -- |
| `a` | 8 | 8 | 8 | -- |

Two things stand out. `A < 0` held at **every** admissible point, now including
the `nu` and `L` directions that had never been probed. And **`alpha` is the
only parameter in the sweep that closes the window**: every other parameter
keeps a nonempty supercritical window across its whole admissible range.

As always this is a bounded search along one-parameter families, not a claim
about the whole admissible set.

### Figures

- [`paper3-regime-windows.pdf`](figs/paper3-regime-windows.pdf) — eight panels,
  `beta` on the horizontal axis (log), swept parameter on the vertical; the
  band is the supercritical window, red dashed curves are the roots, grey
  dotted rows are inadmissible.
- [`paper3-regime-parabolas.pdf`](figs/paper3-regime-parabolas.pdf) — monic
  families `beta_n0/|A|`; dividing by `|A| > 0` preserves sign and roots
  exactly while making curves of very different magnitude comparable.

### Data and reproduction

- Data: [`paper-iii-regime-sweep.json`](../data/paper-iii-regime-sweep.json) —
  all 82 records with `A`, `B`, `C`, `D`, roots, window and admissibility.
- Reproducer, in the Paper III working repository:
  `codes/paper3_regime_maps.py --sweep` then `--figures`.


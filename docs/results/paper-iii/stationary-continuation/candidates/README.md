# Candidate stationary cases

!!! warning "Candidates, not validated evidence"
    These bundles are **not** part of the Paper III evidence contract and must
    not be cited as validated results. Promotion to `validated_current` is an
    author decision that has not been taken.

Each folder holds one amplitude-constrained stationary-continuation study: the
same artifact set as the validated v1 bundle, plus the exact `run-card.yaml`
the case was generated from.

| Case | family | L | n₀ | β | closed-form β_{n₀} | measured c₂ (finest) | order | gates | regime |
|---|---|---:|---:|---:|---:|---:|---:|:---:|---|
| [`hm-a10-g1-L3p5-n2-beta0`](hm-a10-g1-L3p5-n2-beta0/) | a=10, &gamma;=1 | 3.5 | 2 | 0 | +0.118097 | +0.015458 | 2.001 | 183/183 | supercritical |
| [`hm-a10-g1-L3p5-n2-beta2`](hm-a10-g1-L3p5-n2-beta2/) | a=10, &gamma;=1 | 3.5 | 2 | 2 | -0.094491 | -1.498507 | 1.975 | 123/123 | subcritical |
| [`hm-a10-g1-L5p3-n3-beta0`](hm-a10-g1-L5p3-n3-beta0/) | a=10, &gamma;=1 | 5.3 | 3 | 0 | +0.121382 | +0.015951 | 1.999 | 183/183 | supercritical |
| [`hm-a10-g1-L5p3-n3-beta2`](hm-a10-g1-L5p3-n3-beta2/) | a=10, &gamma;=1 | 5.3 | 3 | 2 | -0.094990 | -1.513524 | 1.963 | 123/123 | subcritical |
| [`hm-m05-g2-L5p3-n2-beta1`](hm-m05-g2-L5p3-n2-beta1/) | m=0.5, &gamma;=2 | 5.3 | 2 | 1 | +0.261571 | +0.447162 | 1.997 | 123/123 | supercritical |
| [`hm-m05-g2-L5p3-n2-beta2`](hm-m05-g2-L5p3-n2-beta2/) | m=0.5, &gamma;=2 | 5.3 | 2 | 2 | -0.447701 | -1.536975 | 2.005 | 123/123 | subcritical |
| [`hm-m05-g2-L8-n3-beta1`](hm-m05-g2-L8-n3-beta1/) | m=0.5, &gamma;=2 | 8 | 3 | 1 | +0.253238 | +0.434907 | 1.996 | 123/123 | supercritical |
| [`hm-m05-g2-L8-n3-beta2`](hm-m05-g2-L8-n3-beta2/) | m=0.5, &gamma;=2 | 8 | 3 | 2 | -0.457315 | -1.580808 | 2.008 | 123/123 | subcritical |
| [`hm-m2-g2-L5p3-n2-beta1`](hm-m2-g2-L5p3-n2-beta1/) | m=2, &gamma;=2 | 5.3 | 2 | 1 | +2.262242 | +3.867491 | 2.000 | 183/183 | supercritical |
| [`hm-m2-g2-L5p3-n2-beta6`](hm-m2-g2-L5p3-n2-beta6/) | m=2, &gamma;=2 | 5.3 | 2 | 6 | -1.351263 | -74.254250 | 2.007 | 123/123 | subcritical |
| [`xover-m05-g2-L5p3-n2-beta0`](xover-m05-g2-L5p3-n2-beta0/) | m=0.5, &gamma;=2 | 5.3 | 2 | 0 | +0.750722 | +0.641305 | 2.000 | 183/183 | supercritical |
| [`xover-m05-g2-L5p3-n2-beta3`](xover-m05-g2-L5p3-n2-beta3/) | m=0.5, &gamma;=2 | 5.3 | 2 | 3 | -1.377093 | -9.441942 | 2.001 | 183/183 | subcritical |

<div class="grid cards" markdown>

-   **`hm-a10-g1-L3p5-n2-beta0`**

    ![hm-a10-g1-L3p5-n2-beta0](hm-a10-g1-L3p5-n2-beta0/stationary-continuation.png)

    L=3.5, n₀=2, β=0 · β_{n₀}=+0.1181 · c₂=+0.0155 · **supercritical**

-   **`hm-a10-g1-L3p5-n2-beta2`**

    ![hm-a10-g1-L3p5-n2-beta2](hm-a10-g1-L3p5-n2-beta2/stationary-continuation.png)

    L=3.5, n₀=2, β=2 · β_{n₀}=-0.0945 · c₂=-1.4985 · **subcritical**

-   **`hm-a10-g1-L5p3-n3-beta0`**

    ![hm-a10-g1-L5p3-n3-beta0](hm-a10-g1-L5p3-n3-beta0/stationary-continuation.png)

    L=5.3, n₀=3, β=0 · β_{n₀}=+0.1214 · c₂=+0.0160 · **supercritical**

-   **`hm-a10-g1-L5p3-n3-beta2`**

    ![hm-a10-g1-L5p3-n3-beta2](hm-a10-g1-L5p3-n3-beta2/stationary-continuation.png)

    L=5.3, n₀=3, β=2 · β_{n₀}=-0.0950 · c₂=-1.5135 · **subcritical**

-   **`hm-m05-g2-L5p3-n2-beta1`**

    ![hm-m05-g2-L5p3-n2-beta1](hm-m05-g2-L5p3-n2-beta1/stationary-continuation.png)

    L=5.3, n₀=2, β=1 · β_{n₀}=+0.2616 · c₂=+0.4472 · **supercritical**

-   **`hm-m05-g2-L5p3-n2-beta2`**

    ![hm-m05-g2-L5p3-n2-beta2](hm-m05-g2-L5p3-n2-beta2/stationary-continuation.png)

    L=5.3, n₀=2, β=2 · β_{n₀}=-0.4477 · c₂=-1.5370 · **subcritical**

-   **`hm-m05-g2-L8-n3-beta1`**

    ![hm-m05-g2-L8-n3-beta1](hm-m05-g2-L8-n3-beta1/stationary-continuation.png)

    L=8, n₀=3, β=1 · β_{n₀}=+0.2532 · c₂=+0.4349 · **supercritical**

-   **`hm-m05-g2-L8-n3-beta2`**

    ![hm-m05-g2-L8-n3-beta2](hm-m05-g2-L8-n3-beta2/stationary-continuation.png)

    L=8, n₀=3, β=2 · β_{n₀}=-0.4573 · c₂=-1.5808 · **subcritical**

-   **`hm-m2-g2-L5p3-n2-beta1`**

    ![hm-m2-g2-L5p3-n2-beta1](hm-m2-g2-L5p3-n2-beta1/stationary-continuation.png)

    L=5.3, n₀=2, β=1 · β_{n₀}=+2.2622 · c₂=+3.8675 · **supercritical**

-   **`hm-m2-g2-L5p3-n2-beta6`**

    ![hm-m2-g2-L5p3-n2-beta6](hm-m2-g2-L5p3-n2-beta6/stationary-continuation.png)

    L=5.3, n₀=2, β=6 · β_{n₀}=-1.3513 · c₂=-74.2543 · **subcritical**

-   **`xover-m05-g2-L5p3-n2-beta0`**

    ![xover-m05-g2-L5p3-n2-beta0](xover-m05-g2-L5p3-n2-beta0/stationary-continuation.png)

    L=5.3, n₀=2, β=0 · β_{n₀}=+0.7507 · c₂=+0.6413 · **supercritical**

-   **`xover-m05-g2-L5p3-n2-beta3`**

    ![xover-m05-g2-L5p3-n2-beta3](xover-m05-g2-L5p3-n2-beta3/stationary-continuation.png)

    L=5.3, n₀=2, β=3 · β_{n₀}=-1.3771 · c₂=-9.4419 · **subcritical**

</div>

See the [curated results page](../../../index.md) for context and the
[evidence manifest](../../../../data/paper-iii-manifest.json) for the
machine-readable record.

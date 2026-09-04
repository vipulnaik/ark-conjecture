# The rate of approach to 7 − 4√3

*Auxiliary note. `arithmetic-of-density.md` states the class-11 ceiling as δ(n) ≤ 7 − 4√3 − o(1) and does not say what the o(1) is. This note works it out, tests it, and says which half of the answer the singular series supplies and which half is a Cramér-model assumption. It is kept out of `aod` deliberately: the leading term is Bateman–Horn arithmetic of the kind `aod` already uses, but the distributional half is a heuristic about a shrinking window, which is a class of assumption `aod` does not otherwise carry.*

**Status: heuristic with an empirical fit. Not a theorem, and not a conjecture the framework depends on.** Nothing in `aod`, `enumeration-proof.md` or the short note uses any of this; the ceiling itself is unaffected.

---

## 1. Where the loss comes from

At n ≡ 11 (mod 12) the ceiling shape is n = 4c + r with c a prime power, r = n − 4c prime, and the foreign twist a power of q = (r−1)/6, so the configuration needs

> **c, r = n − 4c, and q = (r−1)/6 all prime.**

Writing x = c/n, the two binding terms of the density are 4x² (the fused intra term, 4·C(c,2) against C(n,2)) and (1−4x)²/3 (the foreign term at η = 1/3). They cross at

> x\* = (2 − √3)/2 = 0.133975…,  δ\* = 7 − 4√3 = 0.0717968…

Near x\* the two terms have slopes 8 − 4√3 = 1.0718 and (8/3)(2√3 − 3) = 1.2376 in x, so the density falls **linearly** in the distance from the optimum. If the nearest admissible c below x\*n is at distance D_L and the nearest above at D_R,

> δ\* − δ(n) ≈ min( (8 − 4√3)·D_L , (8/3)(2√3−3)·D_R ) / n.

So the whole question is the distribution of the gap between admissible c near x\*n. **The loss is Θ(gap/n), and gaps between admissible c are what the singular series counts.**

## 2. The constant, from Bateman–Horn

The triple (c, n − 4c, (n − 4c − 1)/6) is a linear system in c of degree 3. Its Bateman–Horn density at scale n is λ(n) = S(n) / (log c\* · log r\* · log q\*), with

> **S(n) = 3·C₀ · ∏_{ℓ | n(n−1), ℓ ≥ 5} (ℓ−2)/(ℓ−3),  C₀ = ∏_{ℓ ≥ 5} (1 − 3/ℓ)(1 − 1/ℓ)^{−3} = 0.6351664…**

The prefactor is 4 · (3/4): the ℓ = 2 factor is 4 because all three forms are forced odd, and the ℓ = 3 factor is 3/4 because c ≡ 1 (mod 3) is forced and q ≢ 0 (mod 3) is required. This is the **same constant `aod` §3.4 computes** — 4·(9/8)·C₀ = 2.858249 there, in the normalisation that section uses — and it is the one place the two calculations can be cross-checked against each other. They agree.

Modelling the admissible c near x\*n as a Poisson process of intensity λ(n), the two one-sided gaps are independent exponentials and the slope-weighted minimum is exponential with

> **E[δ\* − δ(n)] = log(x\*n)·log((1−4x\*)n)·log((1−4x\*)n/6) / ( 1.7410 · S(n) · n ) ≈ 0.30 · log³n / n**,

where 1.7410 = 1/(8−4√3) + 3/(8(2√3−3)). **So the o(1) is Θ(log³ n / n)** — not 1/n, and not log n / n — with the constant given entirely by the singular series.

## 3. What is tested, and against what

Two independent data sources, covering different ranges:

**(a) The ladder to 10⁶** (`ladder_weak_v10_1e6.txt`), which supplies the family score at every class-11 n below the ceiling. Over n ∈ [3·10⁵, 10⁶], 32,486 values, the observed loss divided by the predicted mean matches Exp(1) across the whole quantile function:

| quantile | empirical | Exp(1) | ratio |
|---|---|---|---|
| 0.10 | 0.10 | 0.11 | 0.97 |
| 0.25 | 0.27 | 0.29 | 0.94 |
| 0.50 | 0.65 | 0.69 | 0.94 |
| 0.75 | 1.28 | 1.39 | 0.92 |
| 0.90 | 2.13 | 2.30 | 0.92 |
| 0.99 | 4.34 | 4.61 | 0.94 |
| max | 10.35 | ln N = 10.39 | — |

The uniform ~7% deficit is the size of the known second-order Bateman–Horn correction at log ≈ 12. The extreme matching ln N is the check that most constrains the tail.

**(b) Exact B(n) to 10⁴** (`mu_exact.py`), which removes the concern that (a) fits the family score rather than δ(n). **At every class-11 n ≤ 10⁴ the exact B equals the ladder value, and the two agree on which n fall below the ceiling** — 185 joined values, ladder tight at all 185, and identical membership of the below-ceiling set. So (a) was fitting δ(n) after all.

**Decade medians against the prediction** (the leading-order test, from the ladder):

| decade | class-11 in worklist | observed median δ | predicted median |
|---|---|---|---|
| [10³, 10⁴) | 184 | 0.0665 | 0.0651 |
| [10⁴, 10⁵) | 3,149 | 0.0698 | 0.0694 |
| [10⁵, 10⁶) | 40,752 | 0.0714 | 0.0712 |

## 4. Two things that make the fit worse at moderate n, both understood

**Competing shapes truncate the loss from below.** The prediction is for the F = 4 shape's deficit. What is observed is δ\* − max over *all* shapes, and at moderate n other shapes are often close: among class-11 n ≥ 5000 with n ≤ 10⁴, only 42% fall below the ceiling at all, and of those the winner is F = 4 in 69 cases but F = 2 in 21 and F = 6 in 19. A minimum over several near-independent deficits sits below any one of them, so the observed loss is systematically *smaller* than the F = 4 prediction — median ratio 0.30 in [10³, 5·10³), 0.47 in [5·10³, 10⁴), 0.62 in [10⁴, 10⁵), 0.65 in [3·10⁵, 10⁶], converging upward to ln 2 = 0.69 as the competing shapes thin out. **The convergence is the evidence; the moderate-n compression is not a failure of the model but a feature the model does not include.**

**The n at or above the ceiling are a selected set.** They are S2-rescued (n with a large prime-power divisor, where the multiplicative engine wins outright) or §3.3.8 escapes. Both are density-zero families, so they disappear asymptotically, but at 10⁴ they are the majority of the class. Among class-11 n ≥ 5000 at or above the ceiling the winning shapes are F = 2 (57), F = 5 (32), F = 7 (26) — a different population, and correctly outside the model.

## 5. What the singular series does and does not give

**Does:** the mean, exactly, including the arithmetic dependence on n through S(n). Every leading-order number above is Bateman–Horn and nothing else.

**Does not:** the distribution. "The gaps near x\*n are Poisson" is a Cramér-model statement about a window of width ~log³n, and Bateman–Horn — which counts solutions up to x — says nothing about it. Anything of the form "δ(n) ≥ δ\* − C·log⁴n/n for **all** n in the class" comes from the extreme-value tail of that model, not from the series. The data in §3(a) supports the Poisson step about as directly as data can, and it remains a rabbit.

**So: leading term from the singular series; distribution and worst case from Cramér.** That is the honest split, and it is the reason this note sits outside `aod`.

## 6. Not done

- No attempt at a rigorous upper bound on the loss. The natural route — an admissible c must exist within O(log³n) of x\*n — is a shifted-prime-triple statement of exactly the kind §6 of `sp-to-floor.md` shows the sumset route cannot supply.
- The second-order Bateman–Horn correction is quoted as "about the right size" for the 7% deficit; it has not been computed.
- The classes other than 11 are untouched. The same analysis applies with different slopes and a different local system at each of the six ceilings; nothing suggests a different shape of answer.
- The competing-shape effect of §4 is described, not modelled. A model would need the joint distribution of several shapes' deficits, which is more machinery than the question warrants.

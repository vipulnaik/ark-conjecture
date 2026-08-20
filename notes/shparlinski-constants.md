# Shparlinski's Theorem 2 with the constants written out, and what it gives at our end of the ladder

*Standalone working note. Source: I. E. Shparlinski, "Evasive properties of sparse graphs and some linear equations in primes", arXiv:1304.0188 (= Theoret. Comput. Sci. 547 (2014), 117–121), Theorem 2 and its proof in §4 — Theorem 1 and its Bombieri–Vinogradov argument in §3 are deliberately out of scope. This document exists because the published argument is written in the style of the field: `≫`, `≪` and unspecified absolute constants throughout, which costs nothing at his exponents and costs a great deal at ours. **That applies to the objective function too, not only to the analytic estimates** — §1.5 replaces BBKN's `min{p²k, pkr, qr}` with the true orbital sizes, two of the three differing by a factor near 2. **Less audited than the main documents** — one pass, no independent reading, arithmetic checked numerically where noted. Nothing here is cited by `arithmetic-of-density.md` or `enumeration-proof.md`; §6.8(iv) states the conclusions, and this is the working behind them.*

---

## 0. Why the constants matter here and not there

Shparlinski's Corollary 3 lands at exponent 1.677 and his Corollary 4 at 3/2. At those exponents the difference between `≫ x/log x` and `≫ x/log²x` in an input set is invisible: it moves an exceptional-set bound from `x^{0.354}log³x` to `x^{0.354}log⁴x`, both of which are `o(x)` by an enormous margin, and the polylogarithms are recorded rather than used.

Our situation is the opposite. The framework needs a **constant fraction of n²**, which is the α = 1, γ = 1 endpoint of the same machinery, and at an endpoint every logarithm is the whole question. The purpose of this note is to carry the constants and the polylog exponents through the argument explicitly, so that the sentence "the machinery tolerates a thinner input set" can be replaced by a number.

Two constants **cannot** be extracted from the paper, and this is stated up front so the rest is not read as more precise than it is:

- **c** in Lemma 7's hypothesis `#𝒜·#ℬ ≥ cN(log N)²`, and
- the implied constant in Lemma 7's conclusion, which I call **c₁**: `max P(a−b) ≥ c₁(#𝒜#ℬ)^{1/2}/log N`.

Both are inherited from Balog–Sárközy (1984) and would need that paper's sieve unwound. **They do not affect any conclusion below**, because they are absolute constants and every threshold that matters turns out to sit at the `loglog x / log x` scale, where a constant factor is absorbed. That is itself a useful finding: the answer is robust to the two things we cannot compute.

---

## 1. The machinery, restated with names for everything

**Input hypothesis (Shparlinski's, parametrised by α and A).**

> **(BH_{α,A})** `#{r ≤ z : r prime, P(r−1) > r^α} ≥ A·z/log z` for all large z,

where P(·) is the largest prime divisor. Baker–Harman gives this at α = 0.677 for some unspecified A > 0.

**The transfer lemma (his Lemma 7, from Balog–Sárközy Theorem 2, modified from a+b to a−b).**

> For 𝒜, ℬ ⊆ [1, N] with `#𝒜·#ℬ ≥ cN(log N)²`:  `max_{a∈𝒜, b∈ℬ} P(a−b) ≥ c₁·(#𝒜#ℬ)^{1/2}/log N`.

**The target (BBKN's Lemma 5 / his (1)–(2)).** With
`f(n) = max over (k,p,q,r) of min{p²k, pkr, qr}` subject to `n = kp + r`, `r ≡ 1 (mod q)`, p, q, r prime,
any nontrivial monotone property with ≤ c·f(n) edges is evasive.

> **This f is itself stated up to constants, and §1.5 replaces it.** Two of its three terms are not orbital sizes but orbital sizes times a factor near 2. That is harmless in the source — Lemma 5 carries an unspecified `c` in front of f, which absorbs any bounded factor — and it is exactly what this document cannot absorb, since our δ₀ is a specific number and the whole exercise is to see where a factor of 2 goes. **Everything below uses §1.5's expressions, not the display above.**

**The conclusion.** For all but `O(x^{max{0,2γ−1}}(log x)⁴)` integers n ≤ x, every nontrivial monotone property with ≤ c(α,γ,A)·n^{1+γ} edges is evasive, for any γ ≤ α.

*(The paper's abstract says `(log x)⁴` and its proof derives `(log x)³` on the dyadic block `[x/2, x]`; the extra log is the sum over `O(log x)` dyadic blocks. Below I work on one block and quote `(log x)³`, adding the block sum only at the end. This is worth stating because it is the one place a logarithm appears for a reason unrelated to the sieve, and it is easy to double-count it.)*

---

## 1.5 The objective function with the constants restored

The group is `Γ ≤ Sym(n)` with `n = kp + r`: a matching part of **k blocks of size p**, fused, with the block-internal action 2-transitive (AGL(1,p)) and a diagonal twist; and a foreign part, **one block of size r** carrying a twist of order q with `q | r − 1`. The score `m*(Γ)` is the **minimum orbital**, so every orbital counts, and each of f's three terms is meant to be one of them. Their true sizes, verified by direct orbit computation:

| f's term | what it is | **true orbital size** | f overstates by |
|---|---|---|---|
| `p²k` | intra-block pairs of the matching part, fused across the k blocks | **`k·C(p,2) = kp(p−1)/2`** | `2p/(p−1) → 2` |
| `pkr` | cross pairs between the two parts | **`kpr`**, when they form a single orbital | 1 (but see below) |
| `qr` | intra-block pairs of the foreign part | **`rq`** if q is odd; **`rq/2`** if q is even | 1, or 2 at q = 2 |

*Verified by explicit orbit enumeration.* For the matching part, building `𝔽_p^k ⋊ (C_{p−1} diagonal × C_k rotation)` and enumerating its pair-orbits gives intra-block orbitals of exactly `k·C(p,2)` at (p,k) = (5,2), (7,2), (7,3), (11,2), (5,3); the cross-block orbitals — which f omits entirely — are `p²·C(k,2)` in one orbit, always **larger**, so omitting them is safe and the intra term is genuinely the minimum. For the foreign part, the stabiliser of a pair `{0,x}` in `C_r ⋊ C_Q` is nontrivial exactly when `−1 ∈ C_Q`, i.e. when `2 | Q`; at (r,Q) = (13,4), (13,3), (31,5), (31,2), (41,8), (11,5) the orbit sizes are `rQ` for odd Q and `rQ/2` for even Q, with no exceptions.

Three consequences worth stating separately, because they are different kinds of thing:

- **The `p²k` term is a genuine factor-2 overstatement**, in the direction that matters: f is used as a *lower* bound on m\*, so overstating it overstates evasiveness. Absorbed by Lemma 5's `c` in the source; not absorbable here.
- **The `qr` term is essentially exact**, since q is prime and so odd except at q = 2. This matters for `ep` F.4, which bounds a foreign class's contribution by `F·r·Q` — **that is the true orbital for odd Q, so F.4 is tight and cannot be sharpened by recovering a factor 2.** The natural-looking sharpening — recover the halving that the other terms concede — is unavailable here, because it applies only at even Q, and `aod` §6.8's structural remark (cofactors are essentially even, hence Q essentially odd) says that is the rare case.
- **The `pkr` term hides a structural condition, not a constant.** It is the true orbital only if the cross pairs form a *single* orbit; if they split, each piece is smaller and the minimum drops. **The condition is sharp and easy to lose:** with *simultaneous* translations across the blocks rather than independent ones, a diagonal orbital of size `kp` appears and `m*` collapses from `kp(p−1)/2` to `p`. The construction needs the full `𝔽_p^k`, not its diagonal copy; only then does the cross term hold. So `f(n)` is a valid lower bound on `m*(Γ)` **only for a Γ whose orbital structure has been verified** — it is not a formula one may evaluate at an arbitrary admissible quadruple.

> **A cross-check that the corrected expressions are the right ones.** At p = 5, k = 2, r = 0 — i.e. n = 10 with no foreign part — the computation gives `m* = 20`, which is **exactly μ(10) = 20** as established independently by the GAP battery (`small-degree-computation.md` §4.1). Shparlinski's `p²k` would give 50 at the same group, which exceeds the proven ceiling `⌊C(10,2)/2⌋ = 22`. That is the clearest possible demonstration that the factor is real and that it must not be carried into a constant-level argument.

**Convention from here on.** Densities are relative to **C(n,2)**, as everywhere else in this project — a floor is `m* ≥ δ₀·C(n,2) = δ₀n(n−1)/2`, *not* `δ₀n²`. Mixing the two is a second factor-of-2 and §6 records what happens when both slips are present at once.

---

## 2. The proof of Theorem 2 with constants carried

Work on `n ∈ [x/2, x]`.

### 2.1 Building the input set ℛ, and the first real constant

Shparlinski sets `ℛ = {r ∈ [c₀x, x/4] : r prime, P(r−1) > r^α}` and asserts `#ℛ ≫ x/log x` "from the definition of α". The constant c₀ is where that assertion is paid for, and (BH) is a **cumulative** bound, so the window count is a difference:

`#ℛ ≥ A·(x/4)/log(x/4) − π(c₀x)`.

With `π(c₀x) ≤ (1+o(1))·c₀x/log x` and `log(x/4) = log x − log 4`:

> **`#ℛ ≥ (A/4 − c₀ − o(1))·x/log x`, so any `c₀ < A/4` works, and `c₀ = A/8` gives `#ℛ ≥ (A/8)·x/log x` for large x.**

This is the pattern the whole document is about: an unspecified `≫` conceals a genuine constraint linking the *window* to the *input density*. Here it is benign — c₀ is ours to choose and only has to be positive — but note the shape, because §4 hits the same step with a hypothesis whose constant is not ours to choose.

*Aside, since it recurs.* The reason a cumulative lower bound needs an upper bound at the other end is exactly the point `aod` §6.8 makes about why (SP) is stated in window form. Here the upper bound is free: it is π(c₀x) and the prime number theorem supplies it. For a general set with only a lower-bound hypothesis it is not free, which is why (SP) builds the window in.

### 2.2 The good case

If `n ∈ [x/2, x]` admits `r ∈ ℛ` with `P(n − r) ≥ n^γ`, set `p = P(n−r)`, `q = P(r−1)`, `k = (n−r)/p`. Since `r ≤ x/4 ≤ n/2`, we get `pk = n − r ≥ n/2`. Evaluating **§1.5's orbitals** rather than f's terms:

- matching intra: `k·C(p,2) = (pk)(p−1)/2 ≥ (n/2)(n^γ − 1)/2 ≥ n^{1+γ}/4` for large n;
- cross: `kpr ≥ (n/2)·c₀x ≥ (c₀/2)·n²` — `Ω(n²)`, never the minimum;
- foreign intra: `≥ rq/2 > r^{1+α}/2 ≥ (c₀^{1+α}/2)·n^{1+α} ≥ (c₀^{1+α}/2)·n^{1+γ}` (taking the even-q value, the safe one).

> **`m*(Γ) ≥ min{1/4, c₀/2, c₀^{1+α}/2}·n^{1+γ}`**, and with `c₀ = A/8 < 1` the minimum is **`(A/8)^{1+α}/2`**. At α = 0.677 and A = 1 that is `0.125^{1.677}/2 ≈ 0.0155` — **half** what f's uncorrected terms give, the factor coming from the matching intra term (and from the even-q foreign case, taken conservatively).

Two observations that matter later. **The foreign term carries α** and is `Ω(n^{1+α})`, so the r-side is already at the exponent the input set supplies, with no loss. **The matching term carries γ**, and it is the companion `n − r` that has to produce it. §3 and §6 are about the fact that these two are not symmetric.

### 2.3 The exceptional set

`ℰ = {n ∈ [x/2, x] : P(n−r) < n^γ for every r ∈ ℛ}`. Apply Lemma 7 with `𝒜 = ℰ`, `ℬ = ℛ`, `N = x`. Every difference `n − r` has `P(n−r) < n^γ ≤ x^γ`, so the conclusion cannot hold above that, and therefore **one of the two must fail**:

- **the hypothesis fails**: `#ℰ·#ℛ < cx(log x)²`, giving `#ℰ < cx(log x)²/#ℛ`;
- **or the conclusion is contradicted**: `c₁(#ℰ#ℛ)^{1/2}/log x ≤ x^γ`, giving `#ℰ ≤ x^{2γ}(log x)²/(c₁²·#ℛ)`.

Substituting `#ℛ ≥ (A/8)x/log x`:

> **`#ℰ ≤ max{ (8c/A)·(log x)³ , (8/(Ac₁²))·x^{2γ−1}(log x)³ }`.**

Summing over the `O(log x)` dyadic blocks gives the paper's `(log x)⁴`. The constants are `8c/A` and `8/(Ac₁²)` — both inherited, both harmless.

*Checked numerically:* at x = 10¹², γ = 1/2, with c = c₁ = 1, the two branches agree at ≈ 2.1×10⁴, which is the crossover `x^{2γ−1} = x⁰ = 1`; for γ > 1/2 the second dominates. Consistent with the paper's `x^{max{0,2γ−1}}`.

---

## 3. What the argument actually consumes

Three properties, worth separating because they are easily conflated — they concern different objects (the input set, the output exponent, and the tool's own limits) and only the first is about density.

**(a) The input set enters through its cardinality and nothing else.** Lemma 7's hypothesis is `#𝒜·#ℬ ≥ cN(log N)²` — a counting condition on arbitrary subsets of `[1,N]`. There is no equidistribution requirement, no level of distribution, no exponential sum over ℛ. This is a **sieve** result (Balog–Sárközy), not a circle-method result. Anything one reads about major and minor arcs belongs to the almost-all Goldbach literature, which is a different route to a superficially similar conclusion.

**(b) The output exponent γ is capped strictly below 1, structurally.** The certified prime factor is at most `(#ℰ#ℛ)^{1/2}/log x`, and both sets live in `[1,x]`: `#ℰ ≤ x/2` and `#ℛ ≤ π(x/4) ≈ x/(4 log x)`. So

> **certified `P(n−r) ≤ x/(2√2·(log x)^{3/2})`** — sub-linear, by a factor `(log x)^{3/2}`, *no matter how good the input set is.*

Numerically: at x = 10¹² this cap is x/400, at x = 10³⁰ it is x/1608 — and it grows without bound. Run the requirement backwards: to certify `p ≥ δ₀x` with δ₀ = 1/25 the sieve would need `#ℰ ≥ (δ₀x log x)²/#ℛ`, which at x = 10¹² with a `x/log²x` input set is `933·x`. Larger than the interval the exceptional set lives in, so it is not a matter of a better estimate — **the sieve cannot certify a linear prime factor at any input density**, because it is capped by the sizes of the two sets it is playing against.

**(c) Therefore thinness costs a logarithm and the endpoint costs the argument.** These are different failures and the distinction is the point of this note.

---

## 4. Substituting our input set

Our set is `S_D = {r prime : (r−1)/Q(r) ≤ D}` with Q the largest **prime-power** divisor. Two adjustments first.

**4.1 Prime versus prime power — the direction is safe, and the discrepancy is tiny.** Shparlinski's hypothesis and Lemma 7's conclusion are about `P(·)`, the largest *prime* divisor; BBKN's (2) also wants **q prime**. Our framework wants Q a prime power, because the top layer is a q-group of order Q. Since `P(m) ≤ Q(m)` always, a hypothesis about P implies the corresponding one about Q — so the sieve's output is *stronger* than what we need, and using it is safe. *Measured over primes r ≤ 2·10⁶:* Q(r−1) is a proper prime power (i.e. `Q > P`) for 5.4% of all primes, but for only **0.55% within S₁₂** — the bounded-cofactor condition already forces `r − 1 = dQ` with d small, which makes a proper power an unlikely way to be in the set. So for our purposes the prime and prime-power versions of S_D are the same set to within half a percent, and the distinction never becomes load-bearing.

**4.2 Density.** Write the hypothesis in the cardinality form the machinery consumes: `#(S_D ∩ [c₀x, x/4]) ≥ B·x/(log x)²`. This is `aod` §6.8's (SP_{D,c,ρ}) at `ρ ≍ 1/log x` (relative to π(x)), which the Bateman–Horn heuristic and the measurements support with `B` of order κ(D,c)/4. The c₀ chase of §2.1 goes through unchanged with `A` replaced by `B/log x`, which is where the extra logarithm enters and the only place it does.

**4.3 The bound.** Repeating §2.3 with `#ℛ ≥ B·x/(log x)²`:

> **`#ℰ ≤ max{ (c/B)(log x)⁴ , (1/(Bc₁²))·x^{2γ−1}(log x)⁴ }`** on a dyadic block; `(log x)⁵` summed.

**One power of log x, exactly, and nothing else changes.** Not the structure of the argument, not the applicability of Lemma 7, not any hypothesis about S_D beyond its size. For every fixed γ < 1 this is still `o(x)`, so:

> **Result A.** (SP_{D,c,ρ}) at any `ρ ≍ 1/log^C x` implies: for all but `O(x^{2γ−1}(log x)^{C+3})` integers `n ≤ x`, `f(n) ≫ n^{1+γ}` — hence `μ(n) ≫ n^{1+γ}` and monotone properties with `≪ n^{1+γ}` edges are evasive. In particular **`n^{2−ε}` for almost all n, every ε > 0**, from the bounded-cofactor hypothesis alone with no Baker–Harman input.

---

## 5. How close to the endpoint the machinery reaches — the quantitative version

This is the part the `≫` notation hides completely, and it is the most useful thing in this note.

`#ℰ = o(x)` needs `x^{2γ−1}(log x)^k = o(x)`, i.e. `x^{2γ−2}(log x)^k → 0`, i.e.

`(2γ − 2)·log x + k·loglog x → −∞`,

so **γ may be taken to depend on x**, up to

> **`γ < 1 − (k/2)·loglog x / log x`**, with `k = 3` for a `1/log x`-relative-density input and `k = 4` for a `1/log²x` one.

*(Legitimate because Lemma 7 is applied at a fixed x, with no uniformity in γ required across x — worth stating, since a γ varying with x is exactly the kind of step that is usually illegitimate.)*

Translate back to the certified companion prime factor `p ≥ n^γ`:

| input set | relative density | k | certified companion factor |
|---|---|---|---|
| Baker–Harman `{P(r−1) > r^α}` | constant | 3 | `p ≫ n/(log n)^{3/2}` |
| `S_D`, bounded cofactor | `1/log x` | 4 | `p ≫ n/(log n)²` |
| *what a density floor needs* | — | — | **`p ≥ δ₀·n`** |

> **So the entire cost of moving from Baker–Harman's set to the bounded-cofactor set is `(log n)^{1/2}` in the certified companion factor — and the entire distance from the machinery's reach to what a floor needs is `(log n)²`.** The first is a rounding error; the second is the whole problem.

This is the sharpest form of the finding, and it makes the situation legible: the method gets to within a **squared logarithm** of the endpoint and cannot cross, because §3(b)'s cap forbids a linear factor even with perfect inputs. Note also that `(log x)²` exceeds `1/δ₀ = 25` for every `x > e⁵ ≈ 148` — so the gap is not a small-x artefact that closes asymptotically; it *opens* with x, which is the correct way round for something the method can never do.

---

## 6. The endpoint is on the companion, not on the input

Assemble the requirement, now in the project's own convention: a floor is `m* ≥ δ₀·C(n,2) = δ₀n(n−1)/2`, and every orbital of §1.5 must clear it.

- **matching intra:** `kp(p−1)/2 ≥ δ₀n(n−1)/2`, and `kp ≤ n`, so `p − 1 ≥ δ₀n(n−1)/(kp) ≥ δ₀(n−1)`: **`p ≳ δ₀·n`**, and then `k = (n−r)/p ≤ n/p ≤ 1/δ₀`.
- **foreign intra:** `rq ≥ δ₀n(n−1)/2` with `r ≤ n` gives `q ≥ δ₀(n−1)/2`, i.e. cofactor **`(r−1)/q ≤ 2/δ₀`** — which is exactly `ep` F.4's branch (b), as it must be.

> **A trap worth naming, because it leaves no trace in the answer.** Deriving this from `p²k ≥ δ₀n²` instead — f's uncorrected term against the `n²` convention — also yields `p ≥ δ₀n`. The two factors of 2 cancel: the one `p²k` gains over `kp(p−1)/2`, against the one `δ₀n²` gains over `δ₀·C(n,2)`. Either alone moves the constant; together they leave it invariant, so a spot-check of the conclusion cannot detect that both are present. **Agreement with F.4 is the check that catches it**, since F.4 is derived in the C(n,2) convention from true orbitals throughout.

**Both requirements are the same endpoint condition, on the two summands of `n = pk + r`.** (SP) supplies the second by hypothesis. The first is what the sieve must produce, and §5 says it produces `n/(log n)²`.

> **The demonstration that settles where the difficulty lives.** Run the whole argument with `ℛ = S_D` itself. The foreign intra orbital becomes `≥ r·Q/2 ≥ r(r−1)/(2D) ≫ n²/D` — **`Ω(n²)`, the endpoint reached even after the conservative halving** — and the cross orbital `kpr ≫ n²` as before. The minimum is still the matching intra term `kp(p−1)/2 ≈ n^{1+γ}/4`, pinned by the companion. So substituting the endpoint hypothesis on the input side improves the r-side from `n^{1+α}` to `n²` and improves the *answer* not at all. Every bit of (H)'s difficulty is in the companion clause: *n decomposes as `pk + r` with p linear in n*. That is a Goldbach-type condition over a twin-prime-thin set, and it is not what a sumset sieve is for.

---

## 7. Where a density obstruction genuinely lives

Certifying a **linear** prime factor is not out of the literature's reach in general — it is what Sárközy–Stewart ("On divisors of sums of integers, II", *J. Reine Angew. Math.* 365 (1986), 171–191) give, and Shparlinski names them in the remark after his Lemma 7 as the improvement available "when both sets are large (of cardinalities of order N)". That is precisely the hypothesis we cannot meet:

- Baker–Harman's set: density `≈ 0.37/log x` in the integers — not of order N.
- `S_12`: density `≈ 2.67/log²x` — two logarithms from order N.

> **So the honest accounting is: below the endpoint, density is free (cardinality divides through, one log per log); at the endpoint, the tool that could certify a linear factor wants positive density in the integers, and S_D is two logarithms short of that.** The tempting one-line summary — "S_D is one logarithm short of what the machinery consumes" — is wrong on both counts: it attributes to Balog–Sárközy a density requirement it does not have, and it places the obstruction a whole step earlier in the argument than where it sits.

---

## 8. What would have to be true

Stated as targets rather than hopes, in decreasing order of plausibility:

1. **A sumset theorem certifying `P(a−b) ≫ N/(log N)^θ` for `θ < 2` at input densities `1/log N` and `1/log²N`.** This is the direct successor question. Anything with `θ = 0` at those densities would close §6 outright; anything with `θ < 2` narrows the gap of §5 without closing it, and would sharpen Result A's exponent past `2 − ε`.
2. **A cofactor-controlled version of any of the above.** Note that even a linear-factor result gives `p ≫ N` with an unspecified constant, whereas a floor needs `p ≥ δ₀n` with δ₀ *ours*; the constant in the sumset conclusion becomes the constant in the floor. So the round trip that `aod` §6.7 records — `d ≤ 12` out, `D ≤ 700` back — would acquire a third loss here.
3. **A route that is not a sumset argument at all.** Since §3(b)'s cap is structural to playing two subsets of `[1,x]` against each other, the linear-factor requirement may simply be the wrong thing to ask of this genre. The fixed-residue level-of-distribution results (BFI, Mikawa, Fouvry — `pending-checks.md` T4) are the other family in the room, and they attack the *input* side, which §6 shows is not where the difficulty is. **That is an argument for de-prioritising them relative to how T4 currently ranks them**, and it is the one strategic consequence of this note.

---

## 9. Status and what is not checked

- **The objective function is the corrected one throughout (§1.5), not Shparlinski's f as printed.** Importing `min{p²k, pkr, qr}` directly is wrong at constant precision in two of three terms, so §§2.2 and 6 evaluate §1.5's orbitals instead. The constants enter only there: §§3–5 and 7–8 live at logarithmic scale, where a factor of 2 is invisible, so the `(log n)^{3/2}` versus `(log n)²` versus `δ₀·n` ladder, the sub-linear cap and the threshold `γ < 1 − (k/2)loglog x/log x` are independent of this choice.
- **The orbital sizes in §1.5 were verified by explicit orbit enumeration**, not by reading them off a formula: the matching part via `𝔽_p^k ⋊ (C_{p−1} × C_k)` at five (p,k) pairs, the foreign part via `C_r ⋊ C_Q` at six (r,Q) pairs. The p = 5, k = 2 case reproduces `μ(10) = 20` independently. What is *not* verified is that these are the orbital structures of the groups BBKN's Lemma 5 actually quantifies over — I reconstructed the natural construction, and the agreement with μ(10) is evidence but not proof that it is theirs.
- **Balog–Sárközy's own proof is not read.** The *statement* Shparlinski consumes has been confirmed to carry a pure-cardinality hypothesis, which is what settles §3(a); the sieve producing it is taken on citation, as are the constants c and c₁.
- **Baker–Harman's α = 0.677** and the value of A are taken on citation. The 0.679 improvement noted in `aod` §3.6 does not change anything here.
- **Sárközy–Stewart is taken from Shparlinski's characterisation of it** ("cardinalities of order N"), not from the original. If their hypothesis is weaker than that — e.g. density `1/log N` — then §7 changes materially and §8 item 1 is partly answered already. **This is the single highest-value thing to check next in this document.**
- The dyadic-block accounting (§1, `(log x)³` per block versus `(log x)⁴` overall) is my reconstruction of the discrepancy between the paper's proof and its theorem statement; it is the natural reading but is not stated in the paper.
- One pass, one reader. The numerical checks (§1.5 orbit enumerations, §2.3 crossover, §3(b) caps, §4.1 prime-power census over r ≤ 2·10⁶, §5 threshold arithmetic) are reproducible from the snippets in the session log but are not wrapped in a script.

> **The general lesson, and the purpose of this note.** Every quantity imported from the literature here is stated up to constants, and in each case the constant was absorbed by an unspecified factor somewhere downstream — Lemma 5's `c` for the objective function, Lemma 7's `c` and `c₁` for the sieve. That is correct practice at exponent 1.677 and silently wrong at exponent 2. **The rule this suggests for the rest of the project: any expression taken from a source that works up to constants must be re-derived from the underlying object — here, from the orbital structure — before it is allowed to touch a δ₀.**

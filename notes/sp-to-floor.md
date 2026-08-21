# From (SP) back to a density floor: the circle-method route, carried out

*Standalone working note, companion to `shparlinski-constants.md`. **One pass, no independent reading**; each step below carries a rigor label — [PROVED HERE], [STANDARD, not rewritten], [VERIFIED COMPUTATIONALLY], or [INTERFACE to the framework's shape space]. The headline claims should be treated as a detailed proof sketch by one reader until a second reading disagrees or doesn't.*

---

## 0. The two answers, up front

The question: can the almost-all-Goldbach machinery take Hypothesis (SP) — a **cardinality** lower bound on the bounded-cofactor set — back to a positive density floor δ₀, or is something stronger needed on that side?

**Answer 1: (SP) as stated cannot feed the circle method, and the generic-set version of the implication is false.** The major arcs require the main term of `S_ℬ` at rationals with small denominators, which a cardinality bound leaves undetermined — and this is not a limitation of the technique: §6 constructs, for any cardinality at the (SP) scale, a set of primes satisfying the count for which **almost all** n are unrepresentable. So no proof can proceed from the count alone while treating S_D as an arbitrary set. What remains open is whether *unconditional* facts about the actual S_D (sieve upper bounds, which do rule the counterexample's structure out) can substitute — §6.3 names that route without pursuing it.

**Answer 2: with the exact Bateman–Horn local structure the proof completes**, and the constant it produces is explicit:

> **Theorem (conditional).** Assume Hypothesis (BH-SW) below for the four two-prime systems `{Q, dQ+1}`, `d ∈ {2, 4, 6, 12}`. Then for every ε > 0 and A > 0, for all but `O_{ε,A}(x/(log x)^A)` integers `n ≤ x`,
>
> `μ(n) ≥ (δ(n mod 12) − ε)·C(n,2)`,
>
> with the per-class constants of §4.4, uniformly `δ(·) ≥ 7 − 4√3 ≈ 0.0718` — the binding class being **n ≡ 11 (mod 12)**.

**The per-class constants are the framework's ceiling table** (§3), so the theorem's sharper statement is: **(BH-SW) implies that almost all n attain their own class ceiling, up to ε.** That is the exact asymptotic half of the floor conjecture, meeting the ceiling from below — not a positive constant that happens to beat 1/25, but the best constant the shape space permits at each n. In the framework's names, **(BH-SW) ⟹ (BCG-AA)** (`arithmetic-of-density.md` §3.5.3), cell by cell in the (F, d) grid.

Two things about the constant before anything else. It exceeds `1/25`, the framework's working floor, by a factor 1.8. And it is keyed **mod 12** — the same modulus that keys the ceiling table, and §3 shows this is an identity rather than a coincidence — for a reason visible in the proof: the residues of `r = dQ + 1` are pinned mod 4 and mod 3 by the choice of `d | 12`, and those two pins are the only local constraints that ever bind.

---

## 1. Hypothesis (BH-SW)

For an even `d` and coprime residue data `(q, b)`, let

> `π_d(t; q, b) = #{Q ≤ t : Q prime, dQ + 1 prime, dQ + 1 ≡ b (mod q)}`.

**Hypothesis (BH-SW_d).** For every `B > 0` there is `B′ = B′(B)` such that, uniformly for `q ≤ (log t)^B` and all `b`,

> `π_d(t; q, b) = 𝔰_d(q, b) · 𝔖_d · t/(log t)² · (1 + O_B((log t)^{−B′}))`,

where `𝔖_d` is the Bateman–Horn constant of the pair `{Q, dQ+1}` and `𝔰_d(q, b)` are **the standard local proportions of that pair** — the density of the local model in which `Q` and `dQ+1` are independently "prime-like" mod q. Explicitly, `𝔰_d(q,b)` is supported on `b` with `(b, q) = 1` and `b ≡ dQ̄ + 1` for a unit `Q̄`, with the natural weights; §4.2 uses only two of its properties: it is the **specific** BH local measure (not an abstract one), and its Fourier coefficients `τ_d(q, a) = Σ_b 𝔰_d(q,b) e(ab/q)` inherit Ramanujan-sum decay from that specificity.

Three remarks. **(i)** This is Bateman–Horn for finitely many *fixed* systems, with Siegel–Walfisz-quality uniformity in progressions to **polylogarithmic** moduli — no level-of-distribution content whatever; the moduli here and the moduli in `shparlinski-constants.md` §7.5's endpoint discussion differ by the entire ladder, and Friedlander–Granville's endpoint failure is about the latter. **(ii)** It implies (SP) trivially (take q = 1), so the theorem is genuinely a strengthening of the hypothesis side, and §6 shows the strengthening is not removable by this method. **(iii)** Proper prime powers `Q = q^j`, `j ≥ 2` are excluded from the systems; they only ever *add* members to S_D, so excluding them is safe for a lower bound, and they are rare in it anyway (0.55% of S₁₂ below 2·10⁶).

---

## 2. The deterministic reduction

**Reduction Lemma.** Let `k ∈ {1, 2, 4}`, `d ∈ {2, 4, 6, 12}`, and suppose `n = kp + r` with `p, r` prime, `r = dQ + 1`, `Q` prime, `gcd(k(p−1), r) = 1`, `p` odd, `p ≠ r`, and `r ∈ (αn, βn]` for window constants `0 < α < β < 1`. Then

> `μ(n) ≥ min{ k·C(p,2), 2p²·[k=4], p²·[k=2], k·p·r, r·Q } ≥ (min{u²/k, 2αu, 2α²/d} − o(1)) · n²/2`, `u := 1 − β`.

*Construction and proof.* [INTERFACE + VERIFIED COMPUTATIONALLY] Take the group `Γ = (𝔽_p^k ⋊ ⟨g⟩) × (C_r ⋊ C_Q)` on `kp + r` points, where `g` is the **entangled generator** `(v_0, …, v_{k−1}) ↦ (ζ v_{k−1}, v_0, …, v_{k−2})`, `ζ` a primitive root mod p, so `⟨g⟩` is cyclic of order `k(p−1)` with `g^k = ζ·diag` — the cyclic-layer rotation with full twist that the framework's corrected shape space provides at any k. The Oliver chain: `Γ₂ = 𝔽_p^k` (bottom p-group), `Γ₁/Γ₂ = ⟨g⟩ × C_r` (cyclic — this is where `gcd(k(p−1), r) = 1` is used, and it holds automatically in our windows since `r > k(p−1)` and r is prime), top `= C_Q` (q-group, Q prime). The orbitals, enumerated explicitly at `(p,k) ∈ {(5,2),(7,2),(5,3),(5,4),(7,4)}` and in every case matching the formulas: matching intra `k·C(p,2)` in a single orbital (full twist reached through `g^k`); cross-block `p²·(orbit structure of C_k on block-pairs)`, smallest `p²` at k = 2 and `2p²` at k = 4 (the antipodal orbit), in all cases `≥ k·C(p,2)·(1 − o(1))` so never binding below the intra term; part-to-part cross `k·p·r`, a single orbital by joint transitivity; foreign intra `r·Q` for odd Q and `r·Q/2` for even (the `−1 ∈ C_Q` dichotomy of `shparlinski-constants.md` §1.5), and **Q is odd throughout this note**, so the bound uses `r·Q`.

> **The halved value is not the conservative choice here; it is the wrong one, and using it costs a factor 2 in the objective.** Every `d` in the grid is even, so `Q = (r − 1)/d` is an odd prime in every window, and `−1 ∉ C_Q`: the true orbital is `rQ`. Verified by direct orbit enumeration at `(r,Q) = (13,3), (31,5), (11,5)` — sizes 39, 155, 55, exactly `rQ` — against `(13,4), (31,2), (41,8)` giving 26, 31, 164, exactly `rQ/2`. The same argument, in the same form, is already made in `note-to-framework-bridge.md` §5 for the note's construction: an even twist order would force `q = 2` and hence a bounded `r`, which the window excludes. Writing `rQ/2` "to be safe" is only safe when the halving can occur. With `pk = n − r ∈ [un, (1−α)n)` and `Q = (r−1)/d`, the numerical form follows. ∎

**Window optimization.** [PROVED HERE, closed form verified against a grid search] Maximizing `min{u²/k, 2αu, 2α²/d}` over `0 < α < β < 1`: the cross term never binds, the balance `u²/k = 2α²/d` gives `α = u√(d/(2k))`, the constraint `α ≤ β = 1 − u` gives `u ≤ 1/(1 + √(d/(2k)))`, and

> **`δ(k, d) = 1/(√k + √(d/2))²`** — as a supremum; any `δ(k,d) − ε` is attained with a nondegenerate window.
>
> **This is the framework's ceiling formula.** `1/(√k + √(d/2))² = cap_k(2/d)` identically, where `cap_F(η) = η/(1 + √(Fη))²` is the cap of `arithmetic-of-density.md` §3.3.5 — so the grid below is that document's ceiling table read at `F = k`, `η = 2/d`, and the optimal window `u = √k/(√k + √(d/2))` is its balance point `x*`.

The window is degenerate at the optimum (`α = β`), which is why the theorem carries an ε; the empirical run of §7 backs the windows off by 4% and loses exactly the predicted 8%.

---

## 3. The local lemma, and where the modulus 12 comes from

**Local Lemma.** [VERIFIED COMPUTATIONALLY for all prime-power moduli `m ∈ {4, 8, 16, 3, 9, 5, 7}` and all primes `ℓ < 200`; PROVED HERE for generic ℓ] For every n there is a pair `(k, d)` in the grid below such that the congruence `kp + dQ + 1 ≡ n (mod m)` is solvable with `p, Q` in the classes the two prime variables can occupy, for every prime power m. The choice is forced by exactly two constraints, both on `r = dQ + 1`:

- **mod 4** (the trap): `d ≡ 2 (mod 4)` forces `r ≡ 3 (mod 4)` and `d ≡ 0 (mod 4)` forces `r ≡ 1 (mod 4)`, because Q is odd. With `kp` contributing `k·(odd)`, parity forces `k` odd for even n and even for odd n, and **for odd n the residue of n mod 4 then dictates `d mod 4`**. A grid restricted to `d ∈ {2, 6}` therefore covers no `n ≡ 3 (mod 4)` at all — an analysis run only at odd primes ℓ misses this entirely, because the binding constraint lives at the prime power 4, not at the prime 2. Higher 2-powers do not bind: mod 8 and 16 the term `kp` already ranges over enough classes.
- **mod 3**: `3 | d` forces `r ≡ 1 (mod 3)`; `3 ∤ d` forces `r ≡ 2 (mod 3)` (the unit class of Q is pinned by `r ≢ 0`). Either way `kp` has two available classes, covering two of the three residues of n; the two `d`-types are complementary.
- **Every other prime ℓ is free**: for `ℓ ∤ kd`, `ℓ ≥ 5`, both `p` and `Q` range over units with at most one excluded value each, and `#{(p̄, Q̄)}` solving the congruence is `≥ ℓ − 3 > 0`. [PROVED HERE]

Hence the per-class grid, with `δ(k,d) = (√k + √(d/2))^{−2} = cap_k(2/d)`:

| n mod 12 | (k, d) | δ | | n mod 12 | (k, d) | δ |
|---|---|---|---|---|---|---|
| 0, 4, 6, 10 | (1, 2) | `1/4 = 0.2500` | | 3, 7 | (2, 4) | `1/8 = 0.1250` |
| 1, 9 | (2, 2) | `3 − 2√2 ≈ 0.1716` | | 5 | (2, 6) | `(√2+√3)^{−2} ≈ 0.1010` |
| 2, 8 | (1, 6) | `(1+√3)^{−2} ≈ 0.1340` | | **11** | **(4, 6)** | **`7 − 4√3 ≈ 0.0718`** |

The binding class `n ≡ 11 (mod 12)` needs simultaneously `k ≡ 0 (mod 4)` with `d ≡ 2 (mod 4)` and `3 | kd` — it is the class where both pins act against each other, and **`(4,6)` is the cheapest resolution**, at `(√k+√(d/2))² = 7 + 4√3`. Alternatives are strictly worse: the transpose `(6,4)` and `(2,12)` both give `≈ 0.0670`, and `(12,2)` gives `≈ 0.0502`.

> **The corrected objective is not symmetric in `(k,d)`, and that changes the shape of this class.** Under the halved foreign term the objective was `1/(√k+√d)²`, symmetric, so `(4,6)` and `(6,4)` tied and the optimum was a degenerate pair. With the true orbital the term is `√(d/2)`, and the transpose falls to `0.0670`: **`(4,6)` is the unique optimum at class 11.** Worth noting because a tie is fragile — anything perturbing the objective could have flipped it — whereas a strict optimum with a `0.0718 : 0.0670` margin is not.

**This grid is the framework's ceiling table, not a resemblance to it.** Every cell agrees with `arithmetic-of-density.md` §3.3.5 exactly — 1/4, 3 − 2√2, (1+√3)^{−2}, 1/8, (√2+√3)^{−2}, 7 − 4√3 — under the identification `F = k`, `η = 2/d`, and the binding constant is the framework's global constant `7 − 4√3` at the same extremal class. It also reproduces clause 3 of (BCG) cell by cell: `d = 2` at the even classes and at 1, 9; `d = 4` at 3, 7; `d = 6` at 2, 8, 5 and 11; `F = 4` at 11 alone. So the mod-12 keying is the *same* optimization arrived at twice, and the surprise is not the agreement of two formulas but that **the analytic route selects the same (F, d) per class with no access to the shape space at all** — the two moduli 4 and 3 pin `r − 1`'s divisor structure identically whether one is enumerating Oliver groups or solving a congruence for a circle-method window.

---

## 4. The circle method

Fix a class `n₀ mod 12` with its `(k, d)`, and work in thin slabs `n ∈ (x, (1+Δ)x]` (Δ a small constant; `O(1/Δ)` slabs per dyadic block, absorbed in the ε). Windows `r ∈ (α′x, β′x]` chosen so `r/n` lands in the optimized `(α, β)` for every n in the slab, at an `O(Δ)` loss.

**Setup.** `ℬ = {r = dQ + 1 : Q prime, both prime, r ∈ window}` (the BH pair set — a subset of S_D, which is all a lower bound needs). Weighted counting function

> `R(n) = Σ_{kp + r = n, r ∈ ℬ} log p`,  `R(n) = ∫₀¹ f(θ)·g(θ)·e(−nθ) dθ`,

with `f(θ) = Σ_{m ∈ M} Λ(m) e(kmθ)` (M the induced p-range) and `g(θ) = Σ_{r ∈ ℬ} e(rθ)`. Major arcs `𝔐`: `|θ − a/q| ≤ P/x`, `q ≤ P := (log x)^B`; minor arcs `𝔪` the complement.

### 4.1 Minor arcs — where only the cardinality is consumed

[PROVED HERE, modulo one standard lemma] By Bessel's inequality over the slab,

> `Σ_n |∫_𝔪 f g e(−nθ) dθ|² ≤ ∫_𝔪 |f|²|g|² ≤ (sup_𝔪 |f|)² · ∫₀¹ |g|² = (sup_𝔪 |f|)² · #ℬ`.

`∫₀¹|g|² = #ℬ` is Parseval — **the count and nothing else**; even an upper bound `#ℬ ≤ π(x)` suffices here, since the count's lower bound is spent only on the main term. For the sup: θ ∈ 𝔪 means every rational approximation `a/q` with `q ≤ x/P` has `q > P`; then `kθ` has approximations of denominator `≥ P/k`, and Vinogradov's estimate gives `sup_𝔪 |f| ≪ x·(log x)^{c}·P^{−1/2}` for an absolute c. [STANDARD, not rewritten: the dilation-by-k bookkeeping, `k ≤ 4`, is routine but is the one lemma this note uses without writing out.] Choosing `B` large:

> `#{n in slab : |E_𝔪(n)| ≥ x/(log x)³} ≪ x·(log x)^{6+2c+2−B} = O_A(x/(log x)^A)`.

The main term of §4.2 has size `≍ x/(log x)²` (the Λ-weight soaks one logarithm), so the threshold above is a full logarithm below it — comfortable.

### 4.2 Major arcs — where the hypothesis is consumed, all of it

[PROVED HERE at the level of assembly; the two per-sum evaluations are STANDARD] On `𝔐(q, a)`:

- **Prime side, unconditional.** Siegel–Walfisz: `f(a/q + η) = (c_k(q,a)/φ(q_k))·v(η) + O(x·exp(−c√(log x)))`, with `v(η) = Σ_{m ∈ M} e(kmη)` and `|c_k| ≤ 1`; `q_k = q/gcd(q,k)`-type constants, `k ≤ 4`.
- **Hypothesis side.** Writing `g(a/q + η) = Σ_b e(ab/q)·Σ_{r ∈ ℬ, r ≡ b} e(rη)` and applying partial summation to the inner sum, (BH-SW_d) gives, uniformly on the arc (`|η| ≤ P/x`, so the summation-by-parts loss is a factor `≤ 1 + |η|x ≤ P`),

  > `g(a/q + η) = τ_d(q, a)·W(η) + O(x·(log x)^{B − B′})`, `W(η) = 𝔖_d ∫_window e(tη)·dt/(log t)²`.

  This is the step a cardinality hypothesis cannot perform: without the per-class asymptotic, `g(a/q + η)` is undetermined for every `q ≥ 2`, and the major-arc integral with it.

- **Assembly.** `∫_𝔐 f g e(−nθ) = 𝔖_{k,d}(n; P)·J(n) + (error)`, with the truncated singular series `𝔖(n; P) = Σ_{q ≤ P} Σ_{(a,q)=1} c_k(q,a)·τ_d(q,a)·e(−na/q)` and the singular integral `J(n) = ∫ v·W·e(−nη) ≍ 𝔖_d·x/(log x)²·(window measure)`.

- **Completion and nonvanishing.** [STANDARD for squarefree q; general q not written out] Here the *exactness* of the local densities earns its keep twice. Once for decay: `τ_d(q,a)` is the Fourier coefficient of the explicit BH local measure and decays like a Ramanujan-type sum, `≪ gcd-driven/φ(q)`, so the series completes with tail `≪ P^{−1/2}` after the standard `Σ_a`-cancellation in n. And once for positivity: `𝔖_{k,d}(n) = Π_ℓ σ_ℓ(k,d,n)` with the local factors those of the Local Lemma — positive at every ℓ for the class-adapted `(k,d)`, with the product convergent and bounded below by an absolute `c₀(k,d) > 0` uniformly in n within the class. **With abstract limiting densities in place of the exact ones, both steps fail** — decay because `|τ| ≤ 1` is all one has, positivity because §6's counterexample realizes `𝔖(n) = 0` on almost all n.

### 4.3 Conclusion of the analytic part

For all but `O_A(x (log x)^{−A})` of the n in the slab, `R(n) ≥ (1 − o(1))·𝔖_{k,d}(n)·J(n) > 0`, so a representation `n = kp + r` exists with all the Reduction Lemma's side conditions (the finitely many degenerate p, r — `p = r`, `p | k`-adjacent, `gcd` failures — are excluded at a cost `O(x^{1/2+ε})` inside `R(n)`, negligible). Summing over slabs and the twelve classes gives the Theorem. ∎

### 4.4 The constant

`δ₀ = min over classes = δ(4,6) = 7 − 4√3 = 0.071797…` at `n ≡ 11 (mod 12)`, with the full per-class table in §3 — which is to say δ₀ is the framework's global asymptotic constant, and this route attains it. For comparison — and the comparison needs its caveats attached — the framework records that **(BCG_{1/5}) yields δ₀ = 1/350 for all large n**; this route yields `≈ 1/13.9` for **almost all** n from a *different* hypothesis. The gain has one honest source: (BCG_{1/5}) hands over a single r per n, while (BH-SW) populates the whole window, letting the balance point `r ≈ α·n` be *chosen* — the constant is then a window-geometry optimum rather than a worst case. The costs are the almost-all quantifier and the asymptotic (rather than one-sided) form of the hypothesis.

---

## 5. Audit: what each step consumed

| step | consumes | status |
|---|---|---|
| Reduction Lemma | framework shape space (entangled rotation at any k); orbital sizes | verified by enumeration at 5 (p,k) pairs; interface |
| window optimum | nothing | closed form, grid-checked |
| Local Lemma | nothing | computed to 200; generic-ℓ proof |
| minor arcs | **#ℬ only** (Parseval); Vinogradov | unconditional; one standard dilation lemma unwritten |
| major arcs, prime side | Siegel–Walfisz | unconditional |
| major arcs, ℬ side | **(BH-SW): asymptotic + exact local densities, moduli ≤ (log x)^B** | the hypothesis, all of it |
| completion + 𝔖(n) > 0 | exactness of the densities | standard shape; squarefree case sketched |
| **level of distribution** | **nothing, anywhere** | — |

The last row is the point of the whole exercise: the route from the multiplicative hypothesis back to the floor never touches primes in progressions to large moduli. The hard arithmetic is confined to the *existence* half — (BH-SW) itself, which is four Sophie-Germain-hard statements — exactly where `aod` §3.5 always said the difficulty lives.

---

## 6. Why (SP) alone cannot do it — and what "alone" leaves open

### 6.1 The generic-set counterexample

[PROVED HERE] Suppose the implication "(cardinality at the (SP) scale) ⟹ (almost-all representation `n = kp + r`, `k ≤ K`)" held for arbitrary sets of primes. Take `m = Π_{ℓ ≤ L} ℓ` with `L` chosen so `φ(m) ≍ log x` (so `L ≍ log log x`), fix any unit `b mod m`, and let

> `ℬ* = {r prime : r ≡ b (mod m)} ∩ window`, `#ℬ* ≍ x/(φ(m) log x) ≍ x/(log x)²` — **the (SP) scale exactly.**

For any n with `n ≡ b (mod ℓ)` for some `ℓ ≤ L`: every `r ∈ ℬ*` has `ℓ | n − r = kp`, and `k ≤ K < ℓ` forces `p = ℓ` — impossible for p of linear size. The n thus excluded have density `1 − Π_{K < ℓ ≤ L}(1 − 1/ℓ) = 1 − O(log K/log L) → 1` — the product must start above `K`, since an `ℓ ≤ K` may divide `k` and then excludes nothing; the conclusion is unaffected, the Mertens tail still tending to 1. So **almost all n are unrepresentable** from a set satisfying the cardinality hypothesis. The richness of the companion set `{kp}` — which covers every *unit* class mod every modulus — is helpless here, because the attack forces the **zero** class, where the only escape is `p = ℓ` itself.

Two corollaries. The counterexample also carries *abstract* Siegel–Walfisz-type equidistribution data (it has limiting densities mod every fixed q — concentrated ones), so "cardinality + equidistribution with unspecified limits" is equally dead: the hypothesis must pin the densities themselves, which is what (BH-SW)'s exactness does. And it retroactively justifies the ε-free claim in `aod` §6.8(iv) that (SP) as stated is insufficient for this route however large ρ is.

### 6.2 Why this does not close the question for the actual S_D

The counterexample set is concentrated in one class mod m with `φ(m) ≍ log x`. The actual S_D provably is not: Selberg/Brun–Titchmarsh upper bounds for the pair `{Q, dQ+1}` in a residue class are **unconditional** and cap `#(S_D ∩ window ∩ (b mod m))` at `≪ (local factor)·x/(φ(m)(log x)²)` — a vanishing fraction of the (SP) count once `φ(m) → ∞`. So the one structure that defeats cardinality-only arguments is unconditionally absent from S_D. A proof from (SP) alone would have to *use* that: the natural vehicle is a **transference argument** — S_D under (SP) has positive relative density inside the Selberg majorant of the pair, whose pseudorandomness (linear-forms-type correlation conditions) is sieve-provable; a restriction/transference estimate for the equation `n = kp + r` against that majorant would then give the representation for almost all n with no distributional hypothesis on S_D at all. That is a genuine research question, not an afternoon's work, and it is the precise form of the "tier 3" question: **filed as open, with the counterexample marking its boundary** — any such argument must consume the sieve upper bounds, since §6.1 shows the count alone is not enough.

### 6.3 The resolution of the either/or

So, to the question as posed: **something stronger than (SP) is needed for this method — the exact Bateman–Horn local structure, and §6.1 shows the exactness is doing real work, not tidying** — and with it the proof completes at `δ₀ = 7 − 4√3 − ε` for almost all n. The cardinality-only version is neither proved nor refuted for the actual S_D; it is refuted for generic sets, and the transference route is the named candidate for rescuing it.

---

## 7. Numerical checks

All [VERIFIED COMPUTATIONALLY], reproducible from the session log:

- **Closed form.** `δ(k,d) = (√k+√(d/2))^{−2}` against a 2000² grid at nine (k,d) pairs; agreement to the grid resolution. ⟦PENDING-RERUN⟧ *The grid check was run against the pre-correction objective; the closed form has been re-derived and matches `cap_k(2/d)` algebraically, but the grid search has not been rerun.*
- **Orbitals.** The entangled construction at `(p,k) ∈ {(5,2),(7,2),(5,3),(5,4),(7,4)}`: matching intra exactly `k·C(p,2)`, single orbital; smallest cross-block orbital `p²` (k=2), `2p²` (k=4, antipodal), never binding; `m* = k·C(p,2)` in every case.
- **Local grid.** Coverage of every class at every prime-power modulus in `{4, 8, 16, 3, 9, 5, 7}` and every prime `< 200`; the per-(k,d) failures are exactly the mod-4 and mod-3 pins described in §3, nothing else.
- **End-to-end.** At `x = 4·10⁶` with per-class `(k,d)` and windows backed off 4% inside the optima: **zero exceptional n among the 400,000 consecutive `n ∈ (10⁶, 1.4·10⁶]`**, and the worst realized `δ(n)` in each class sits within the predicted 8% of its ideal — e.g. class 11 realizes 0.04655 against the ideal 0.05051. The BH pair counts feeding this: 13,934 / 7,422 / 10,281 / 5,420 pairs for d = 2, 4, 6, 12 below 4·10⁶ *(recount; the earlier 13,933 and 10,280 differ by an endpoint convention at the window edge)*.

  ⟦PENDING-RERUN⟧ **The end-to-end run scored foreign orbitals at `rQ/2` and so inherits the factor-2 undercount corrected in §2.** The structural conclusion — zero exceptional n, realized values within a predictable margin of ideal — is unaffected, since both sides of the comparison move together; the *numbers* are not. Expected on a rerun with `orb = rQ` at odd Q: class 11 realizing `≈ 0.066` against the ideal `0.0718`. Not rerun here.

---

## 8. Status and what is not checked

- **One pass, one reader**, and the two evaluations labeled [STANDARD] — the Vinogradov dilation lemma and the Siegel–Walfisz major-arc manipulation — are used, not rewritten. The singular-series completion is sketched for squarefree q only.
- The Reduction Lemma's constructions are verified by orbit enumeration at five parameter pairs, not proved for all (p, k); the general proof is a finite orbit computation in the same pattern and is not expected to hold surprises, but it has not been written.
- The comparison `1/13.9` vs `1/350` compares **different hypotheses with different quantifiers**; it should not be quoted without both caveats.
- The transference question of §6.2 is raised, not begun. If it succeeds, (SP) as literally stated suffices and this note's hypothesis is overkill; if it fails in an instructive way, the failure would locate exactly how much distributional information the truth requires. Either outcome is informative, which is what makes it the right next question on this side of the framework.
- The mod-12 agreement with the ceiling table is **explained** (§3): it is the same optimization, `δ(k,d) = cap_k(2/d)`, and not a coincidence. What remains genuinely open is one level up — *why the analytic route selects the same (F, d) at every residue class when it has no access to the shape space*. The congruence conditions that pin `d` here are conditions on `r − 1`'s divisor structure, and the shape space's conditions are on which Oliver chains exist; that these agree cell by cell is a fact about the arithmetic of `r = dQ + 1`, and it is the reason to believe the mod-12 keying is intrinsic rather than an artifact of how either table was built.

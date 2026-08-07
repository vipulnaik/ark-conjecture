# The arithmetic of the density ladder

*Supplement to `orbital-evasiveness-notes.md` and `enumeration-proof.md`. Where those two ask what μ(n) is and prove that the enumeration computes it, this one asks **which arithmetic conditions on n control the answer**, sets up the Hardy–Littlewood and Bateman–Horn machinery that governs them, and checks the predictions against the computed table. **The 2026-08 defect is repaired** (`enumeration-proof.md` Part 0): the shape space was incomplete, `mu_enumerate_v2.py` now covers it, and **μ(n) ≤ B_safe(n) holds again**. What has not caught up is the data — see the provenance banner in §2.0 — so every measured figure below is from a superseded table and wants recomputing against v4. Everything below that compares families against one another, or that reads a family's cap, is unaffected; everything that treats a tabulated value as μ(n) needs the qualifier.*

**Status labels as in the other documents.** *Verified* — an independent computation agreed. *Sound* — argued and read, no independent computation. *Heuristic* — a singular-series prediction, i.e. conditional on Hardy–Littlewood or Bateman–Horn.

**Prime powers are kept, not excluded.** At n = p^a the group AGL(1, n) is 2-transitive, so μ(n) = C(n,2) and δ(n) = 1 — the maximum. That is the trivial case of the framework rather than an exception to it, and it is S1 in the census. Tables and scans skip prime powers because the answer is already known, in the way one might skip n = 1 in a factorisation routine; nothing here treats μ as undefined there. "Composite non-prime-power n" in the floor statements means *the cases still to be determined*, not *the cases where μ exists*.

---

## 1. The thesis, in one page

The framework has **two arithmetic engines**, and they are of different kinds.

> **The multiplicative engine.** A single **fused class** — F blocks of size c permuted by the top q-group, with n = F·c, F a power of q and c a prime power — achieves density **1/F**. It requires n to have at most two distinct prime factors, and it is the only structure that breaks density 1/4.
>
> **The additive engine.** k unfused parts, balanced, achieve density **1/k²** and no more. Two parts need n = c + r with c a prime power and r a prime; three parts need n = 2c + r. These are Hardy–Littlewood conditions, and they carry all the number theory.

Everything else in this document elaborates that split. Five consequences set the agenda:

1. **The density ladder's thresholds are the engine caps, not artefacts.** 1/2 and 1/3 are fused-class values at F = 2 and F = 3; **1/4 is the two-part cap; 1/9 is the three-part cap; 1/16 is the four-part cap.** The thresholds that appear throughout the other two documents — δ₀^even = 1/4, Theorem E.1's 1/9, Corollary F.3's 1/16 — are all the same quantity read at different k.
2. **The parity asymmetry is multiplicative in origin, not additive.** Even n has 2 | n, so F = 2 is available whenever n/2 is a prime power, giving density 1/2. Odd n has F ≥ 3, capping the multiplicative engine at 1/3; and its two-part route needs the *even* part to be a power of 2, which is scarce. So odd n loses on both engines at once — and the loss is a matter of caps, not of representation counts: both parametric systems supply ~n/log³n representations where they are soluble at all (§§3.1–3.3).
3. **The ceiling splits by residue class mod 12, for both parities**, from local obstructions at ℓ = 2 and ℓ = 3 — and those are the only two moduli that can obstruct, because each system is three linear polynomials so ω(ℓ) ≤ 3 < ℓ for ℓ ≥ 5. Six distinct constants result, from 1/4 down to 0.05051, each met by the constructions to within 2% (§3.3).
4. **One global floor covers everything.** Conjecturally **δ(n) ≥ 0.02 for every composite non-prime-power n** — and below 10⁶ the branch-and-bound establishes **δ(n) ≥ 0.026117** unconditionally, since every step used the table only as a lower bound (§5). What it does *not* establish, after the 2026-08 defect, is where the minimum sits: at n = 3239 the corrected shape space raises δ to 0.043570, so the argmin has moved and the bound is no longer tight. The extremal residue is **n ≡ 23 (mod 24)** (§3.3), and every stage of the search has landed in n ≡ 11 (mod 12), which contains it, at every stage.
5. **The multiplicative engine covers a density-zero set, so asymptotically the additive engine is everything.** The fraction of n with ω(n) = 2 thins like log log n / log n — measured at 52% below 2000 but 29% near 10⁶. So the asymptotic behaviour of μ is governed entirely by the Hardy–Littlewood side, and the observed density floor should be expected to drift downward as the fused family's reach recedes.

---

## 2. The configurations, and the two engines

*The companion `enumeration-proof.md` classifies which configurations an Oliver group can realise and proves that classification; this document is about how they behave arithmetically. Its Part 0 carries the **configuration census**, reproduced below so that both documents can be read on their own.*

> **The census is duplicated on purpose.** A split — structure there, behaviour here — would force a reader to join two tables across two files mentally, which is worse than the drift risk. So the duplication is deliberate and the drift risk is handled mechanically instead: `check_doc_figures.py --pass census` cross-checks every S-row between the two documents and reports any that is missing or reworded. **S-numbers are append-only.** A new shape gets the next number and a row in both files; nothing is ever renumbered, because the S-numbers are the key the documents are joined by.

### 2.0 The census

> **Provenance of every measured figure in this document.** Three tables have been in play. **v2** predates the shape-space repair (G.2). **v3** has the repair but predates the SAFE tightening, so it over-credits fused shapes. **v4** is current and in flight. Structural columns, closed forms and asymptotic verdicts are stable; **winner counts, percentages and per-shape medians are not**, and are marked with their table where it matters. Anything below quoting a count without a table attribution is v2- or v3-era and should be recomputed against v4 before being cited.

| # | shape | engine | winners | asymptotic verdict | where |
|---|---|---|---|---|---|
| **S1** | one matching block, no copies | — | every prime power | **→ 0**: prime powers up to N number π(N) + O(√N) = O(N/log N). Trivial where it applies: δ = 1, and the only shape there | §2.1 |
| **S2** | fused matching class, **top**-layer copies, n = F·c | multiplicative | 40.4% (v3) | **→ 0**: needs ω(n) = 2 with both factors prime powers | §4 |
| **S3** | matching + outside, n = c + r\* | additive | 37.8% (v3) | **→ ~50%**, essentially all even n | §3.1 |
| **S4** | two matching + outside, n = 2c + r\* | additive | 2 winners to n = 360 (v4); **0** in v3, an over-credit artefact | **→ 1/24 ≈ 4.2%** outright, plus 1/24 tied with S5. Confined to residues 7, 15, 23 mod 24 | §3.2 |
| **S5** | fused matching + outside; forces q = 2 | hybrid | 21.8% (v3) | **→ 10/24 ≈ 41.7%** outright, plus the 1/24 tied with S4. Sole winner at the nine rung-B residues | §3.2 |
| **S6** | two outside blocks | additive | 0% | **→ 0**: supply-limited, needs two coordinated safe primes | §4.3 |
| **S7** | **middle**-layer-fused matching + outside | hybrid | — | an escape, not a family; see §4.1 | §4.1 |
| **S8** | bottom-layer-fused matching | — | never | excluded (Lemma D1) | — |
| **S9** | fused outside block, any layer | — | never | excluded (Lemma D2) | — |
| **S10** | outside block with r = q | — | never | excluded: normality kills the twist | — |

> **S4 and S5 are co-carriers, not rivals.** Both realise the same family n = 2c + r; whether fusing the two equal blocks helps depends on c mod 8, and each verdict holds on a quarter of all c. The analysis is in §3.2.
>
> **What the winner column reports is sensitive to the SAFE cap.** Crediting a fused class F·C(c,2) regardless of its twist inflates fused shapes specifically — the one place SAFE's over-count is not shape-neutral — and under that scoring S4 vanishes from the census entirely. The cap now accounts for the constraint (the cyclic part of the twist must be coprime to Fmid, a proven necessary condition and so usable in SAFE), and **S4 reappears at exactly the predicted residues**: both instances below n = 360 have c ≡ 1 (mod 8). Winner counts from v3 and earlier are affected; structural columns are not.

**The engine dichotomy is a simplification, and the hybrids are where the action is.** S1 and S2 are purely multiplicative and S3, S4, S6 purely additive, but **S5 and S7 are neither** — a fused class supplying the multiplicative factor F alongside a foreign block supplying the additive one. That is not a defect of the taxonomy; it is where the two interesting phenomena live. S5's full efficiency requires a Fermat prime (§3.3), and S7 exists only because block fusion can come from the cyclic layer (§4.1). Both were missed by earlier drafts precisely because the two-engine framing had no slot for them.

### 2.1 The multiplicative engine: density 1/F

Let n = F·c with F a power of q and c a power of p. The single fused class has intra-orbital F·C(c,2), within-class cross (F or F/2)·c², and no other terms, so

> m\* = F·C(c,2) = F·c(c−1)/2, and **δ = m\*/C(n,2) = (c−1)/(Fc−1) → 1/F.**

Two things follow immediately. Since a fused class needs F ≥ q ≥ 2, the engine cannot exceed **1/2**. And since n = F·c with both factors prime powers forces **ω(n) ≤ 2**, it is available only on that set.

To maximise, take F to be the **smallest prime-power cofactor** of n — the least F such that F and n/F are both prime powers.

> *Verified.* Over all 754 one-part winners in the table, the predicted density 1/F agrees with the computed value to O(1/n), with no exceptions. By F: 205 rows at F = 2 with median density 0.4995, 151 at F = 3 with median 0.3326, 116 at F = 4 with 0.2492, 97 at F = 5 with 0.1992, 68 at F = 7 with 0.1420, 44 at F = 9 with 0.1103. Maxima 0.49978, 0.33304, 0.24967, 0.19965, 0.14247, 0.11072 against 1/F = 0.5, 0.3333, 0.25, 0.2, 0.1429, 0.1111. (The remaining 73 sit at F = 8, 11, 13, 17, 19, 23.)

> *Verified.* All one-part winners have ω(n) = 2, and **no** value with ω(n) ≥ 3 has a one-part winner. Over the current 2,008-row table: of the 1,118 values with ω(n) = 2, 780 are one-part winners and the other 338 do better with a split. (Over the n ≤ 2,298 slice the figures were 754 and 323 — the counts below in §2.1 and §2.3 are for that slice unless stated.)

**Why fusion is worth a factor of F.** F *unfused* equal parts of size c give min(C(c,2), c²) = C(c,2) ≈ n²/(2F²), density 1/F². Fusing them replaces the mutual capping by a single intra term F·C(c,2), density 1/F. So fusion buys exactly F, which is why reduction (R1) of the proof document — merge equal-size classes when F₁ + F₂ is a q-power — is the single most valuable simplification in the search, and why the enumeration's winners are so often a single fused class.

**Terminology, since the next few sections depend on it.** A configuration is n = Σᵢ Fᵢcᵢ. Each summand is a **class**: Fᵢ blocks of size cᵢ, *fused* by the top q-group, with Fᵢ a q-power and cᵢ a prime power. A class is **unfused** when Fᵢ = 1 — a single block. The `parts` column of the table counts **classes**, not blocks, and Proposition F.1's k is that count, whether or not the classes are internally fused.

So fusion is an axis *within* a configuration rather than a separate kind of configuration, and the two engines above are a first approximation rather than a dichotomy. Mixed shapes occur: **58 of the 909 two-class winners** pair a fused class with an unfused foreign prime, and the current global minimum is one of them — n = 2291, witness `2x761 + 1x769*`, two classes of which one is fused. (No three-class winner contains a fused class.) Fusion also carries a cost that is easy to miss: Fᵢ must be a power of the top prime q, so fusing at all constrains q, and the foreign block's twist must then be a q-power too. At n = 2291 the fusion forces q = 2, which caps the foreign efficiency at the 2-part of 768, i.e. η = 1/3.

### 2.2 The additive engine: density 1/k²

For k classes of sizes sᵢ = Fᵢcᵢ summing to n, the between-orbit classes sᵢsⱼ and the intra terms C(cᵢ,2) cap each other. Proposition F.1 of the proof document gives k < 1/√δ; read backwards,

> **k classes ⟹ δ < 1/k²**, and the bound is saturated by balanced *unfused* classes. Proposition F.2 refines it to k + (√2 − 1)f ≤ 1/√δ over f fused classes, so a fused class costs more budget than an unfused one — which is the same fact as fusion being worth a factor of F, seen from the other side.

> *Verified, and tight.* Maximum observed density is 0.24939 among two-part winners and 0.11037 among three-part winners; **no two-part winner exceeds 1/4 and no three-part winner exceeds 1/9**, over 909 and 258 rows respectively. Medians 0.1988 and 0.0889.

So the ladder of thresholds is one sequence: 1/4, 1/9, 1/16 at k = 2, 3, 4. The 1/9 above which Theorem E.1 settles the collapse, and the 1/16 above which Corollary F.3 gives k ≤ 3, are not independently chosen constants; they are the points at which the next part count becomes possible.

### 2.3 What the engines cover, and what that implies

**Density above 1/4 is a purely multiplicative phenomenon.** Only **S1 and S2** can exceed 1/4 — S1 trivially, at δ = 1 on the prime powers, and S2 by fusion. Every additive or hybrid shape has at least two classes, and Proposition F.2 caps k classes at 1/k², so everything at or below 1/4 is additive or hybrid and therefore Hardy–Littlewood-conditional.

**The two engines cover complementary sets in the sense that matters.** S1 needs n itself a prime power and S2 needs ω(n) = 2 with both factors prime powers; both are conditions of density zero, and both count O(n/log n). S3–S5 need only that n admit a suitable split, which is conjecturally almost always. So the multiplicative side is where the density is high and the supply is thin, and the additive side is the reverse.

So the asymptotic picture is entirely §3's: **S3 for even n, and S4 and S5 jointly for odd n** (splitting by c mod 8, §3.2), at the ceilings of §3.3 — with S1 and S2 thinning exceptions (§4) and S6, S7 and the escapes contributing at densities §4 measures rather than assumes.

## 3. The arithmetic conditions, family by family

The additive families need simultaneous prime and prime-power values. The systems are *parametric* in n — see §3.5, which is where that distinction is drawn and where it matters — but their **local** analysis is the standard singular-series computation, and that is what §§3.1–3.3 use. Write the singular series for a system of polynomials f₁, …, f_k with product f as

> 𝔖(f₁,…,f_k) = ∏_p (1 − ω_f(p)/p)·(1 − 1/p)^{−k},  ω_f(p) = #{a mod p : f(a) ≡ 0}.

### 3.1 Two parts at even n (S3), and why 1/4 needs a safe prime

To reach the two-part cap the configuration needs c ≈ r ≈ n/2 with the foreign block at **full efficiency**: cap(r) = C(r,2) requires the twist to have order (r−1)/2 or r−1, and Lemma B′ forces it to be a power of the top prime q. So r − 1 = 2qᵉ or qᵉ. The clean case is **r a safe prime** — r = 2s + 1 with s prime, so q = s, e = 1 — which is why safe primes are the objects the notes keep returning to.

The representation required at even n is therefore: **n = c + r with c a prime power near n/2 and r a safe prime near n/2.** Taking the leading case c prime, this is the Bateman–Horn system

> f₁(x) = x,  f₂(x) = (x−1)/2,  f₃(x) = n − x

— r, its Sophie Germain partner, and the complementary prime — so the predicted count of representations is

> R₂(n) ~ 𝔖₃(n) · n / (2 log³ n),  with 𝔖₃(n) = ∏_{p>2} (1 − ω(p)/p)(1 − 1/p)^{−3}, ω(p) = 3 for p ∤ n(n−2) and correspondingly fewer otherwise.

The exponent is what matters: **three log factors, so ~n/log³n representations.** Existence is therefore not the binding constraint at even n where the system is locally soluble; the count grows. *Heuristic*, and unproven in every case — a ternary problem with two of the three conditions on the same variable, beyond current technology in the same way binary Goldbach is.

> **Even n carries an ℓ = 3 obstruction.** Substituting r = 2s+1, the system is {s, 2s+1, n−2s−1}, with roots mod 3 at s ≡ 0, 1 and 2(n−1). These are distinct — so ω(3) = 3 and the singular series vanishes — exactly when **n ≡ 2 (mod 3)**. Re-optimising at the reduced efficiency gives x² = (1−x)²/3, hence x = 1/(1+√3) and **cap = 1/(1+√3)² ≈ 0.13397**. So δ₀^even = 1/4 holds for n ≢ 2 (mod 3), and 0.13397 otherwise.

### 3.2 Three parts at odd n (S4 and S5): the family, and its ceilings

Odd n cannot use a balanced two-part split: c + r odd forces one part even, and an even prime foreign part must be 2, which is useless. So the even part would have to be the p-characteristic one, i.e. c = 2^a, leaving only ~log₂n candidate splits — the route counted at O(n/log n) in §4.1.

The route that avoids it is **three parts with two equal p-characteristic blocks**: n = 2c + r with c an odd prime power and r an odd prime, all parts odd. At full efficiency, balancing x² against η(1−2x)² gives the cap **1/9 at x\* = 1/3**; the ceilings at reduced efficiency, and the rung structure that raises them, are §3.3.

**Two shapes realise this family, and which is better depends on c mod 8.** The two equal c-blocks may be left unfused (**S4**) or fused into one class of two (**S5**). Fusing doubles the intra term to 2·orb(c, d), but puts C₂ in the cyclic layer, so d must be the **odd part of c − 1** — against the unfused C(c,2) at the full twist. Over all primes c < 20000 the comparison is exceptionless:

| c mod 8 | c − 1 | fused intra | verdict | primes < 20000 |
|---|---|---|---|---|
| 3, 7 | 2·odd | 2·C(c,2) | **fused (S5) strictly better** | 570 / 565 |
| 5 | 4·odd | C(c,2) | exact tie | 569 |
| 1 | 8 \| c−1 | ≤ C(c,2)/2 | **unfused (S4) strictly better** | 556 |

So the two are **co-carriers of the odd-n asymptotics**, not rivals with one dominating: each verdict holds on a quarter of all c.

*How that translates into a proportion of n is a separate question — for a given n one takes the best c available near the balance point, not a random one — and it is answered in §3.8.*

**Full efficiency is obstructed locally, and the obstructions split the ceiling by residue class.** Write **η** for a foreign block's efficiency, η = orb(r, t)/C(r,2) with t the q-part of r − 1 — the fraction of full 2-homogeneous capacity its twist reaches. (η rather than e, to keep clear of Euler's number.) Efficiency η = 1 requires the foreign twist to have order (r−1)/2, which Lemma B′ forces to be a power of q — so (r−1)/2 must be a prime power, the clean case being r a safe prime. Which n admit it, and at what efficiency, is settled in §3.3. Re-optimising δ(x) at reduced efficiency gives the other ceilings in closed form:

> at **η = 1/2**: δ(x) = min(x², 2x(1−2x), (1−2x)²/2) is maximised where x√2 = 1−2x, i.e. **x = 1/(2+√2) ≈ 0.29289**, giving **1/(2+√2)² = (2−√2)²/4 ≈ 0.08579**;
> at **η = 1/3**: **≈ 0.07180** at x ≈ 0.2679.

Where the family is locally soluble the predicted representation count is ~𝔖₃(n)·n/log³n, with

> 𝔖₃(n) = ∏_{p>2} (1 − ω(p)/p)(1 − 1/p)^{−3},  ω(p) = #{r mod p : r(r−1)(n−r) ≡ 0},

so ω(p) = 3 for p ∤ n(n−2) and smaller on the divisors, with the 2-adic and 3-adic factors as computed in §3.3. *Heuristic*, and unproven — a ternary system with two conditions on the same variable, out of reach for the same reasons as binary Goldbach.

### 3.3 Local solubility, and the ceiling by residue class (S3, S4, S5)

Full efficiency needs (r−1)/2 to be a prime power, so with r prime and c = (n−r)/2 a prime power the requirement is a system of three conditions in one variable,

> f₁(r) = r,  f₂(r) = (r−1)/2,  f₃(r) = (n−r)/2,

of the same three-condition shape as the even case. Its singular series is positive iff ω(ℓ) < ℓ at every prime ℓ. For **odd ℓ** the forbidden residues are r ≡ 0, 1, n — a set of size at most three — so **only ℓ = 3 can be fatal**, and it is fatal exactly when **n ≡ 2 (mod 3)**. At **ℓ = 2** the division by 2 must be handled directly: full efficiency wants (r−1)/2 odd, so r ≡ 3 (mod 4), and then c = (n−r)/2 is odd only when **n ≡ 1 (mod 4)**; for n ≡ 3 (mod 4) the alternative r ≡ 1 (mod 4) gives 4 | r−1 and caps the efficiency at 1/2.

**Only ℓ = 2 and ℓ = 3 can obstruct, and no prime power beyond them.** Two facts, both needed.

*No prime beyond 3.* Each family's system is three *linear* polynomials in one variable with leading coefficients 1, 2, −2. For ℓ odd, none of these is divisible by ℓ, so every form stays genuinely linear mod ℓ and contributes at most one root: **ω(ℓ) ≤ 3**, and an obstruction requires ω(ℓ) ≥ ℓ, hence ℓ ≤ 3.

> **A uniform lower bound, which positivity alone does not give.** What the ladder needs is not that the singular series is positive at each n but that it is bounded below by an absolute constant — otherwise it could decay along a sequence of n and the predicted count fall below 1. It is, and the argument is short. A prime ℓ ≥ 5 cannot divide both n and n−1, so at most one root coincidence occurs, dropping ω(ℓ) from 3 to 2; and the factor with ω = 2 *exceeds* 1, so the bad primes only help. With ω(2) = 1 and ω(3) ≤ 2 contributing 4 and 9/8,
>
> **S(n) ≥ 4 · (9/8) · C₀ = 2.858249…,   C₀ = ∏ over ℓ ≥ 5 of (1 − 3/ℓ)(1 − 1/ℓ)⁻³ = 0.635166…,**
>
> uniformly in n. The corresponding count is then ≫ n/log³n — a one-sided bound with an absolute constant, which is what the argument uses. It is not two-sided: the upper side carries a log log n from the primes dividing n(n−1).

> **The caveat matters once the family is widened.** "Linear implies at most one root" holds only when ℓ does not divide the leading coefficient. If it does, the form degenerates to a constant, and a constant that happens to be 0 vanishes at *every* residue, giving ω(ℓ) = ℓ. That cannot happen here because the leading coefficients are 1, 2, −2. It does happen in the generalised family of `mu-theta-n2-note.md`, where the foreign block is written r = dq + 1 with d ∈ {2, 4, 6, 12}: at d = 6 and n ≡ 1 (mod 3) the third form is identically 0 mod 3. So the bound above is a fact about *this* system, not a general principle, and any widening of the leading coefficients reopens the question. Brute-force confirmation over all residues and all ℓ < 500 finds none, as the argument requires.

*No higher power of 2 or 3 either.* The singular series is a product of local densities σ_ℓ = (1 − ω(ℓ)/ℓ)(1 − 1/ℓ)^{−3}, one factor per **prime**, and ω(ℓ) counts roots mod ℓ only. Nothing is imposed mod ℓ²: the local condition being enforced is "f_i(s) is not divisible by ℓ", and divisibility by ℓ is decided mod ℓ. A residue s mod ℓ that avoids all three roots already guarantees ℓ ∤ f_i(s) whatever s is mod ℓ². So there is no obstruction at 8, at 9, or at any higher power.

*Then why do the conditions read mod 4 and mod 3 in terms of n?* Purely the change of variable. The system lives in s, with r = 2s+1 and (for odd n) c = m − s where m = (n−1)/2. The ℓ = 2 condition is a condition on **m mod 2**, and since m = (n−1)/2 that is a condition on **n mod 4**. The ℓ = 3 condition is on m mod 3, and 2 is invertible mod 3, so it is a condition on **n mod 3**. Hence mod 12 in n, with nothing finer available. Verified empirically: representability rates computed modulo 24, 36, 48, 72 and 144 show no spread within a fixed class mod 12 beyond sampling noise. The efficiency available in each class then follows from the structure of r − 1: writing r − 1 = 2^a·u with u odd and L the largest prime power dividing u, the best top prime gives

> **η = max(1/u, L/(2^{a−1}u))**, so **η = 1 exactly when either u = 1, or a = 1 and u is a prime power** — equivalently r − 1 ∈ {q^e, 2q^e}, the two cases being the **Fermat** primes (q = 2) and the **safe-prime-like** ones r − 1 = 2q^e with q odd.

The ℓ = 2 obstruction forces a ≥ 2, and hence η ≤ 1/2 **provided u > 1**; the ℓ = 3 obstruction forces 3 | u and hence η ≤ 1/3 generically, unless u is itself a power of 3; both together give η ≤ 1/6 subject to the same two provisos.

> **The u = 1 branch is a real escape from ℓ = 2, and it occurs in range.** An earlier version of this section characterised η = 1 as "a = 1 with u a prime power" and concluded that 4 | r − 1 caps η at 1/2. That is false at a **Fermat** prime, where u = 1 and η = 1 for every a. The mechanism is the one §2.1 records from the other side: fusing the two equal c-blocks of the three-class family forces q = 2, and then the foreign twist is the 2-part of r − 1, which is full **exactly** when r is Fermat. In the computed table this produces **20 winners of shape `2×c + 257*`**, every one in class 3 or 7 mod 12, with densities from 0.09177 up to **0.16138** (n = 639) against those classes' tabulated 0.08579 — at n = 451, 459, 475, 531, 555, 559, 583, 595, 639, 651, 679, 703, 711, 715, 735, 759, 783, 795, 799, 819. Since only five Fermat primes are known the escape is O(1)-sparse — thinner even than the O(log n) 3-power escapes below — so **the asymptotic constants are unaffected**; but the derivation as previously written was invalid, and the class caps must be read as generic rather than absolute. `ladder_verify.py`'s `EFF` array computes η correctly, including this case; it was only the prose that was wrong.

> **The balanced additive family, by residue class mod 12.** Every entry is derived, not fitted; "observed" is the largest density attained by a winner of *this family* running at its class's generic efficiency.
>
> **These are ceilings of the family, hence floors for μ — they do not bound δ(n).** The number in each row is the most the balanced two- or three-class shape can extract in that class, so it is exactly the δ₀ of the ladder: μ(n) ≥ δ₀·C(n,2) whenever n admits the representation. Other shapes routinely do better and are not constrained by it. A single fused class reaches 1/F and so exceeds every row here; at odd n the shape 2^a + r\* sidesteps the three-class balance entirely — n = 1015 = 512 + 503\* gives δ = 0.24534 against this table's 0.08579 for class 7. Over the computed table **91 values in class 11 alone exceed 0.05051, the largest being 0.20168**. Read the rows as "what this family guarantees", never as "what n can achieve".
>
> | n mod 12 | parity | family | ℓ=2 | ℓ=3 | η | **δ₀ (exact)** | decimal | observed | ratio |
> |---|---|---|---|---|---|---|---|---|---|
> | 0, 4, 6, 10 | even | c + r | — | — | 1 | **1/4** | 0.25000 | 0.24939 | 0.998 |
> | 2, 8 | even | c + r | — | ✗ | 1/3 | **(2 − √3)/2** | 0.13397 | 0.13374 | 0.998 |
> | 1, 9 | odd | 2c + r | — | — | 1 | **1/9** | 0.11111 | 0.11037 | 0.993 |
> | 3, 7 | odd | 2c + r | ✗ | — | 1/2 | **(3 − 2√2)/2** | 0.08579 | 0.08565 | 0.998 |
> | 5 | odd | 2c + r | — | ✗ | 1/3 | **(2 − √3)²** | 0.07180 | 0.07043 | 0.981 |
> | 11 | odd | 2c + r | ✗ | ✗ | 1/6 | **(5 − 2√6)/2** | 0.05051 | 0.05036 | 0.997 |
>
> All six are the same formula. Balancing x² against η(1−kx)² gives x\* = √η/(1 + k√η), where k = 1 for the two-part family and k = 2 for the three-part, so
>
> > **cap = η/(1 + k√η)²**,
>
> and each rationalises to an integer denominator as tabulated. The class-5 value is a perfect square, (2 − √3)² = 7 − 4√3. In every case the cross term 2x\*(1 − kx\*) exceeds the cap, so the minimum is genuinely the intra/foreign balance and not the cross class.
>
> **Four routes lift individual n above the ceiling for their residue**, each by supplying a block whose size is a power of a fixed small prime, so that the divisibility which kills primality is harmless:
>
> - the ℓ = 3 residues when (r−1)/2 or c is a power of 3;
> - the ℓ = 2 residues when c is a power of 2, which turns the shape into the two-part 2^a + r\*;
> - the ℓ = 2 residues when r is a **Fermat** prime, where u = 1 defeats the a ≥ 2 argument outright — the boxed note above. Tied to the five known Fermat primes, so O(1) in total; 20 instances in range, all with r = 257, all in residues 3 and 7 mod 12;
> - the odd residues when a cyclic-layer-fused class of F = 3 blocks is available — the S7 route.
>
> **All four are O(n/log n) in n, and §4.1 proves it.** Each supplies O(1) usable block sizes per n, because the ceiling itself confines the block to a bounded ratio range; the remaining freedom is one prime, and that is where the log comes from. So they lift a vanishing proportion of n and leave the asymptotic constants untouched — but the proportion vanishes only logarithmically, so at any computed range they are visible rather than negligible.

> **The table omits fusion, and that is why the caps are exceeded so often.** The δ₀ above are derived for **unfused** classes: k = 1 (one p-block + one foreign) or k = 2 (two equal p-blocks + one foreign). But when q = 2 the two equal p-blocks *can* be fused, and reduction (R1) says they should be — fusion is worth a factor of F. For a fused class of F blocks of size c plus one foreign prime r the terms are F·C(c,2) ≈ Fx², the within-class cross (F or F/2)c² ≥ Fx², the foreign intra η(1−Fx)², and the cross 2Fx(1−Fx). Balancing the first against the third,
>
> > **x\* = √η / (√F + F√η),   cap_F(η) = F·η / (√F + F√η)²**,
>
> which reduces to the table's k = 1 row at F = 1 and gives new values at F = 2: **0.17157 at η = 1 and 0.10102 at η = 1/3**, against the unfused three-class 1/9 and 0.0718. *Verified:* over all 58 fused-class-plus-foreign winners, **none exceeds cap_F(η)**, and the maximum observed is 0.16138 (n = 639), 94% of cap_2(1). The cross term exceeds the cap at x\* in each case, as before.
>
> Fusion at F = 2 forces q = 2, which pins the foreign efficiency to the 2-part of r − 1 — full **exactly** at a Fermat prime. So cap_2(1) is reachable only with r ∈ {5, 17, 257, 65537}, which is why all 20 of the winners attaining it use r = 257, and why they sit in classes 3 and 7 where the table says η ≤ 1/2. The two facts are the same fact.
>
> **2026-08: the ceilings are a mod-24 phenomenon, and the table below optimises the wrong rung.** Two corrections compound here. Both were found by asking whether the S4/S5 result should have changed this analysis; both understate δ₀.
>
> **(a) The shapes form a ladder and the table takes its bottom rung.** For odd n = (c-part) + r\*, with x = c/n:
>
> | rung | shape | census | intra density | cap | balance point |
> |---|---|---|---|---|---|
> | **A** | one c-block + foreign | **S3** at odd n, needing c = 2^a | x² | η/(1+√η)² | √η/(1+√η) |
> | **B** | two c-blocks **fused** + foreign | **S5** | 2x² | 2η/(√2+2√η)² | √η/(√2+2√η) |
> | **C** | two c-classes **unfused** + foreign | **S4** | x² | η/(1+2√η)² | √η/(1+2√η) |
>
> with **A > B > C** in every class, and each rung at its **own** balance point — (√6 − 2)/2 = 0.22474 for C at η = 1/6, (√3 − 1)/4 = 0.18301 for B. The cross term binds at none of them, so all three derivations are valid; only the choice of answer was wrong. Behind the ladder is a change of variable. Since (√F + F√η)² = F(1 + √(Fη))², the fused cap simplifies to
>
> > **cap_F(η) = η/(1 + √(Fη))²**,
>
> which is the k-class formula η/(1 + k√η)² at **k = √F**. So *fusing F blocks is worth exactly √F unfused classes*: rung B sits at k = √2, strictly between the one-class rung A (k = 1) and the two-class rung C (k = 2). Equivalently **cap_F(η) = cap₁(Fη)/F**, which is why one rung's value at η is exactly half the next rung's at 2η — visible in the surd column below, where rung C at η = 1/6 is (5 − 2√6)/2 and rung B at η = 1/3 is 5 − 2√6.
>
> **(b) Reachability is a congruence on n mod 24, not mod 12.** Rung A needs c even, hence c = 2^a — only ~log₂n choices, so its optimum is rarely available; that is what §3.3 below miscalls the "2^a + r\* escape", which is not an escape from the ceiling but the top rung, usually out of reach. Rung B needs the twist on the c-blocks to be odd, i.e. **c ≡ 3 (mod 4)**. But η = 1/6 with an odd twist forces r − 1 = 12·odd, hence **r ≡ 5 (mod 8)**; with 2c ≡ 6 (mod 8) that gives **n ≡ 3 (mod 8)**. So half of each obstructed class can use rung B and half cannot, and the split is by n mod 24. Measured over 15,000 values per residue, it is 100% or 0% with no boundary cases.
>
> **The corrected ceiling table.**
>
> | n mod 24 | rung | η | **x\* = c/n** | x\* | cap, closed form | cap | vs mod-12 |
> |---|---|---|---|---|---|---|---|
> | 0, 4, 6, 10, 12, 16, 18, 22 | even, k = 1 | 1 | **1/2** | 0.50000 | **1/4** | 0.25000 | — |
> | 2, 8, 14, 20 | even, k = 1 | 1/3 | **(√3 − 1)/2** | 0.36603 | **(2 − √3)/2** | 0.13397 | — |
> | 1, 9, 13, 21 | B, k = √2 | 1 | **(2 − √2)/2** | 0.29289 | **3 − 2√2** | 0.17157 | ×1.54 |
> | 3, 19 | B, k = √2 | 1/2 | **1/4** | 0.25000 | **1/8** | 0.12500 | ×1.46 |
> | 5, 17 | B, k = √2 | 1/3 | **(√6 − 2)/2** | 0.22474 | **5 − 2√6** | 0.10102 | ×1.41 |
> | 7, 15 | C, k = 2 | 1/2 | **(2 − √2)/2** | 0.29289 | **(3 − 2√2)/2** | 0.08579 | — |
> | 11 | B, k = √2 | 1/6 | **(√3 − 1)/4** | 0.18301 | **(2 − √3)/4** | 0.06699 | ×1.33 |
> | **23** | **C, k = 2** | 1/6 | **(√6 − 2)/2** | 0.22474 | **(5 − 2√6)/2** | 0.05051 | — |
>
> **x\* is the fraction of n in a *single block***, so it is what `count_check.py --centre` wants and what the balanced window of §3.4 is centred on. For a fused rung the whole class occupies F·x\*, not x\*.
>
> **Read the x\* column against 1/(k+1), the equal split.** They agree only at η = 1 — the even unobstructed rows, where x\* = 1/2. Everywhere else they differ, and at (C, η = 1/6) the equal split 1/3 sits **0.109 away** from x\* = 0.22474, more than twice the half-width of the standard window. Any count taken on a window centred at the equal split therefore covers a region that cannot reach the ceiling, which is why §3.7 tests each residue at its own x\*.
>
> Every entry is a unit in ℤ[√d] over 1, 2 or 4 — the same shape as the mod-12 table, as it must be, since only k and η changed. The pairings are worth noticing: **3 − 2√2** at (B, 1) against **(3 − 2√2)/2** at (C, 1/2), and **5 − 2√6** at (B, 1/3) against **(5 − 2√6)/2** at (C, 1/6). That is cap_F(η) = cap₁(Fη)/F in the table.
>
> Eight distinct ceilings across 24 residues, against six across 12. Nine of the twelve odd residues rise by 33–54%; **three do not** — 7, 15 and 23 mod 24 are stuck on rung C.
>
> **The global asymptotic constant survives, but its extremal class halves.** The minimum is still **0.050510 = (5 − 2√6)/2**, now attained only at **n ≡ 23 (mod 24)** rather than throughout n ≡ 11 (mod 12). So §5's headline is right, for a reason the earlier derivation did not give, and the class it names is twice as large as it should be.
>
> **Downstream.** The ceilings above are what §3.7 tests, each residue at its own x\*, and what `ladder_verify.py`'s `CAP` is keyed on.

> **Consequence for how the table should be read.** Against the current data, **194 of the 1,108 two- and three-class one-foreign winners exceed their own class's tabulated δ₀** — 57 via the documented 2^a + r\* route, 43 via the fused 2×c + r\* route above, and 94 via an η above the class's generic value (mostly the 3-power escapes). In class 11 the *median* winner sits at 1.24× the tabulated cap and 28 of 39 exceed it, with a maximum of 3.99×. The δ₀ are therefore best read strictly as **guarantees for one specific unfused shape**, not as generic behaviour — the wording "generic ceiling" overstates how typical they are inside the computed range. What *is* an upper bound, and holds without exception, is cap_F(η) evaluated at the configuration's own F and η: **0 of 1,108 rows exceed it.**

*How this is validated, and why the maximum alone would not do it.* A class maximum meeting its cap only shows the cap is **attainable**; it is met whenever some n in the class happens to have a good representation, and would go on being met even if a further condition were quietly suppressing most of the class. Two stronger checks are therefore needed, and both pass.

*Upper: no row exceeds its own cap.* Computing each winner's actual efficiency from its own foreign block and top prime, and comparing its density against cap(η) for that efficiency: over all **1,167** two- and three-part winners — 1,108 of them checkable by the automated re-derivation, which covers every unfused one-foreign row — **zero exceed it**. So δ(x) = min(x², 2x(1−kx), η(1−kx)²) bounds every individual row, not just the extremes.

*Lower: the distribution is uniform across classes.* An unmodelled obstruction acting on some residue would show as that residue failing to reach its cap, or as its bulk sitting systematically lower than its siblings'. The right version of this check normalises by the **mod-24** cap and does **not** pre-filter by efficiency — an earlier version restricted to winners at their class's generic efficiency, which is exactly the filter that hides the escape rows, so it could not have detected an error in the class → η map at all. Over the whole table, normalised by cap(own η): every residue lands in 0.28–0.998, none exceeds 1. Normalised by the residue cap, the escapes push a minority above 1, quantified in §4.1. The per-residue δ/cap minima from `ladder_verify.py` currently run **0.327–0.653**, which is the spread expected from representation availability alone.

**The ℓ = 3 obstruction has an escape, reaching O(n/log n) values (§4.1).** If (r−1)/2 or c is itself a power of 3, full efficiency returns, because the divisibility that kills primality is harmless for prime powers. In range this lifts n ≡ 5 (mod 12) to a maximum of 0.10975 — but 22 of those 35 rows use the *same* foreign prime r = 487, with (r−1)/2 = 243 = 3⁵, and the others use r = 163 with 81 = 3⁴ or c = 243, 729. Candidates of the form r = 2·3^k + 1 are as thin as any other exponential family, so the escape supplies O(log n) candidates rather than n/log³n and should be read as a feature of the computed range. **The generic ceiling 0.0718 is the one to quote asymptotically.**

### 3.4 The balanced window, and why it leaves the singular series intact

Every cap above is attained at a specific balance point — x = c/n equal to 1/2, 1/3, or the values in the table — so the representations that matter are not all representations of n but those in a window around that point. Whether the Bateman–Horn heuristic survives that restriction needs checking, because a window shrinking with n would turn each of these into a short-interval problem and put it out of reach.

It does not shrink. Each δ(x) is continuous with an **interior maximum**, so asking for δ ≥ δ₀ at any δ₀ strictly below the cap confines x to an interval of positive length, and that length is a fixed fraction of n rather than a vanishing one. Taking δ₀ = 0.9 × cap in each class:

| class | family, efficiency | cap | attained at | x-window | width |
|---|---|---|---|---|---|
| 0, 4, 6, 10 | two parts, η = 1 | 0.25000 | 0.5000 | [0.474, 0.526] | 0.052 |
| 2, 8 | two parts, η = 1/3 | 0.13397 | 0.3660 | [0.347, 0.399] | 0.051 |
| 1, 9 | three parts, η = 1 | 0.11111 | 0.3333 | [0.316, 0.342] | 0.026 |
| 3, 7 | three parts, η = 1/2 | 0.08579 | 0.2929 | [0.278, 0.304] | 0.026 |
| 5 | three parts, η = 1/3 | 0.07180 | 0.2680 | [0.254, 0.280] | 0.026 |
| 11 | three parts, η = 1/6 | 0.05051 | 0.2247 | [0.213, 0.239] | 0.026 |

So in every class the count required is of primes in an interval of length **c·n for an absolute constant c between 0.026 and 0.052** — not primes in a short interval. That is exactly the regime where the Hardy–Littlewood and Bateman–Horn heuristics are standard: the predicted count over the window is the full-range prediction times the window's measure, up to the smooth variation of 1/log across it, and no short-interval input is needed. The asymptotic ~𝔖(n)·n/log³n of §§3.1–3.2 therefore stands as written, with 𝔖(n) unchanged and only the constant scaled.

Two caveats, both real and both explaining why the observed maxima of §3.3 fall just short of their caps rather than meeting them.

**Approaching the cap costs.** Requiring δ ≥ (1−ε)·cap confines x to a window of relative width Θ(√ε), so the predicted count degrades like √ε·n/log³n. It stays positive for fixed ε but not uniformly in ε, so the caps are suprema rather than values guaranteed to be attained at any particular n.

**Exact balance is arithmetically impossible anyway.** At the balance point the three-part family needs c = r = n/3 exactly, but r is the foreign prime and c the p-characteristic block size, and admissibility requires r ≠ p. The same obstruction applies to the two-part family at x = 1/2. So the caps are approached and never met, independently of any analytic question.

### 3.5 Which conjecture, exactly: parametric systems versus fixed ones

The systems of §§3.1–3.3 are routinely called "Bateman–Horn systems" in the working documents, and that is loose in a way worth correcting, because the imprecision hides where the difficulty actually sits.

**Two traditions.** *Fixed-system* problems take polynomials f₁, …, f_k with integer coefficients and ask how often f₁(x), …, f_k(x) are simultaneously prime as x runs to infinity. Twin primes, {x, x+2}, is the model; the Bateman–Horn conjecture is the general asymptotic,

> π_f(X) ~ (1/D)·𝔖(f)·∫₂^X dt/(log t)^k,

with 𝔖(f) the singular series. *Parametric* problems fix a target n, ask for a representation of n, and ask how the count behaves as n grows. Binary Goldbach, n = p₁ + p₂, is the model; the relevant conjecture is Hardy–Littlewood's

> r(n) ~ 2C₂ · ∏_{p | n, p > 2} (p−1)/(p−2) · n/log²n.

**Our systems are parametric, not fixed.** Writing r = dq + 1, the conditions of §3.2 become {q, dq+1, (n−dq−1)/2} — but the third polynomial has n in its coefficients, so as n varies the *system itself* varies. And the variable q is confined to roughly [1, n/d]: at fixed n there is no limit to take, so there is nothing for a Bateman–Horn asymptotic to be an asymptotic *in*. What we need is that the representation count is positive at each large n, which is a statement about a family of systems indexed by n. That is the Goldbach shape, and the circle method rather than Bateman–Horn is the relevant machinery.

**Where Bateman–Horn nonetheless applies, and where it does not.**

| | applies | why |
|---|---|---|
| classification of local obstructions (§3.3) | **yes** | the singular series is computed from the polynomials' roots mod ℓ, and n enters only as a residue; the computation is identical whether the system is fixed or parametric |
| positivity of 𝔖(n) | **yes** | same reason |
| the asymptotic count of representations | **no** | there is no growing variable at fixed n |
| existence for all large n | **no** | this is a uniformity statement across the family, which no fixed-system conjecture addresses |

So the local analysis of §3.3 — that only ℓ = 2 and ℓ = 3 obstruct, and which classes mod 12 they kill — is on firm ground and can properly be attributed to the Bateman–Horn/Hardy–Littlewood local formalism. The existence claim cannot.

**How hard is the parametric statement?** Comparison with the Goldbach problems places it fairly precisely. Ternary Goldbach, n = p₁ + p₂ + p₃, is a *theorem* (Vinogradov asymptotically, Helfgott unconditionally for all odd n > 5) because it has **two** free variables and the circle method's minor arcs can be controlled. Binary Goldbach has **one** free variable and remains open. Our system has **one** free variable carrying **three** primality conditions, so per shape it demands strictly more than binary Goldbach.

Two things cut the other way. The demand is a **disjunction** over eight shapes — two block patterns × four values of d — and only one need succeed at each n, which is a weaker requirement than any single Goldbach-type assertion. And we do not need an asymptotic, only positivity, so a result of "almost all n" type with a small exceptional set would do, and such results *are* available for binary Goldbach: Montgomery–Vaughan and subsequently Pintz give exceptional sets of size O(x^θ) with θ well below 1, some of them effective.

**The uniformity trap.** Even granting the asymptotic for each n, deducing positivity for *all* large n needs the error term controlled uniformly in n, and that is not a free assumption: Friedlander and Granville showed that sufficiently uniform versions of Hardy–Littlewood-type conjectures are **false**. So the honest form of a hypothesis here is either "for all large n" taken as an axiom — which is what §3.2's hypothesis does, and which is of Goldbach difficulty — or "for all but O(x^θ) of n ≤ x", which is weaker, closer to known technology, and sufficient for a density statement about μ.

**What this means for the framework.** The ladder's conditional results should be read as conditional on a *parametric* hypothesis of Goldbach type, not on Bateman–Horn. The distinction matters in two places. It explains why §3.4's window analysis is needed at all: for a fixed system one would simply count solutions up to X, whereas here the solutions live in a window proportional to n and one must check that the window does not shrink. And it explains why §6's covering formulation is the right shape — a disjunction over a finite family of parametric systems is exactly what a lower bound on μ can deliver, and is strictly weaker than any single system's solvability.

### 3.6 What the conjectures give: the shifted-prime ladder, and effectivity

**The route's strength is a single parameter.** The efficiency condition — that r − 1 carry a large prime-power divisor — is what couples this framework to the literature on shifted primes, and the coupling reduces to one exponent. Write θ for what can be guaranteed in P(r − 1) > r^θ. The foreign block then contributes qr ≥ r^{1+θ}, and with r of order n the family delivers roughly **n^{1+θ}**. Every result in this area is a value of θ:

| input on shifted primes | θ | quantifier | edge bound |
|---|---|---|---|
| Bombieri–Vinogradov | 1/4 | all large n | n^{5/4+o(1)} |
| Chowla-type | 1/2 | all large n | n^{3/2−ε} |
| Baker–Harman, positive relative density; **0.679** (Li, 2025) | 0.677 → 0.679 | **almost all** n | n^{1.677} |
| Elliott–Halberstam | → 1 | all large n | n^{2−o(1)} |

Hypothesis (H) of §3.5 is the **θ = 1 endpoint** of this ladder. Stating it that way is more informative than calling it a barrier: it places the hypothesis on a scale with a known current value rather than in a separate category.

**The ceiling on the route is technological, not conjectural — and this distinguishes it from Chowla's 1/2.** Chowla's exponent is the value a *conjecture* buys; beating it means assuming something else. Baker–Harman's is the current output of a *method*, and the method's limit is a **level-of-distribution barrier**: results of this shape rest on Brun–Titchmarsh on average, i.e. on controlling primes in progressions to moduli beyond x^{1/2} — exactly the gap between Bombieri–Vinogradov and Elliott–Halberstam. The exponent moves whenever that control does, and it has: 0.677 became **0.679** on Maynard's triple-convolution estimates, in the lineage that took Bombieri–Friedlander–Iwaniec's x^{29/56} to Maynard's x^{11/21} and Lichtman's x^{17/32}. So θ → 1 is not a separate wish; it *is* level → 1, which is Elliott–Halberstam.

**It is the shifted-prime condition specifically that imposes this.** Binary Goldbach in the almost-all regime carries no such condition, which is why Montgomery–Vaughan settles it unconditionally with a power-saving exceptional set. Adding "and r − 1 has a large prime factor" couples the problem to primes in progressions to large moduli and puts it behind the barrier. The condition that buys the density is the same condition that caps the exponent.

> *One caveat on transferring the ladder.* θ is stated for the largest **prime** divisor of r − 1, while the efficiency η of §3.3 is built from the largest prime **power** divisor of the odd part, together with the 2-part. The two agree when r − 1 = 2q and differ otherwise, so the ladder should be checked against the prime-power version before (H) is called its endpoint without qualification.

**On effectivity.** Whichever rung is in play, the conjecture supplying it has no error term: Bateman–Horn and Hardy–Littlewood alike assert π_f(x) ~ (1/D)·𝔖(f)·∫₂^x dt/(log t)^k, a bare asymptotic with an ineffective implied constant. It says nothing about any specific n, so what is uncovered is not a middle interval that computation might close from below — it is everything above wherever the computation stops.

The conjectured square-root refinement π_f(x) = (1/D)·𝔖(f)·Li_k(x) + O_ε(x^{1/2+ε}) does not help, being the wrong shape: it bounds the *counting function up to x*, while the families need a representation at each individual n, and an exceptional n contributes O(1) to a count whose error term is a power of x. Nor is uniformity in n a free hypothesis — Friedlander and Granville showed that sufficiently uniform versions of Hardy–Littlewood-type conjectures are false outright.

**But the quantity §5 needs is computable directly and cheaply**, and that is what dissolves the difficulty. At each n it is not an asymptotic count of representations but the best density the families actually achieve — a sieve computation costing O(n/log n) against the n^2.9 of computing B(n). The asymmetry is what lets the floor be verified far past the range where μ(n) is known.

> *Verified* (`ladder_verify.py`). Over every composite non-prime-power n ≤ 10⁶ — all twenty-four residues, no eligibility filter — the best density the four families achieve is at least **0.02516**, attained at n = 8927, and **no value falls below 0.02**. That is a direct verification of §5's conjecture over a range roughly 450× wider than where μ(n) itself is known.

So the structure is not "computed below, conjectural above" with an unreachable band between:

| | range | status |
|---|---|---|
| μ(n) known exactly | the computed table | computed |
| collapse B_refined = B_safe certified | n ≤ 100,000 | computed from lower bounds (Part E″), at all but two values — n = 50,817 and n = 89,697 |
| global floor δ ≥ 0.02516 | n ≤ 10⁶ | computed (§5); the branch-and-bound gives the stronger δ ≥ 0.026117 over the same range |
| global floor δ ≥ 0.02 | n > 10⁶ | conjectural, ineffectively |

**The natural next rung is an exceptional-set bound**, not because it would be better than an all-n statement — it would not — but because it is strictly weaker and is where progress on problems of this shape has historically come first. "All but O(x^θ) of n ≤ x admit a representation", for some θ < 1, is exactly the form Montgomery–Vaughan and then Pintz achieved for binary Goldbach, and results of that shape are sometimes effective. An effective one here, combined with verification up to N, would give an unconditional density statement about the ladder — which no amount of asymptotic Bateman–Horn can, at any rung.

**One consistency check worth recording.** The obstructions of §3.3 were derived there from the structure of r − 1 — which twists Lemma B′ permits. They also fall out of the singular series: 𝔖(n) vanishes precisely when ω(2) = 2 or ω(3) = 3, which is exactly n ≡ 3 (mod 4) or n ≡ 2 (mod 3). Two independent routes to the same obstructions.

### 3.7 The prediction, tested by counting

*The ceilings of §3.3 come from a singular series being **positive** — a solution exists near the balance point. The heuristic says more than that: it predicts a **count**. This section tests the count, at every residue mod 24, each at its own ceiling's balance point. `count_check.py`.*

**The system.** A foreign block r carries a twist of order t dividing r − 1, with efficiency η = 2t/(r−1) for odd t — so **η = 2/D exactly when r − 1 = D·t**. Taking t = q prime, the three forms are

> f₁ = q,  f₂ = D·q + 1 (= r),  f₃ = (n − 1 − D·q)/K (= c)

with K = 1 for the even family n = c + r of §3.1 and K = 2 for the odd family n = 2c + r of §3.2. A solution is a q making all three prime, with c in a window around x\*.

**Testing at the right centre is the whole point.** The count is taken over a window centred on x\*, and x\* = √η/(1 + k√η) equals the equal split 1/(k+1) **only at η = 1**. At the obstructed residues they diverge sharply — at (C, η = 1/6) the equal split sits 0.109 from x\* = 0.22474, more than twice the window half-width — so a window centred on the equal split covers a region that cannot reach the ceiling at all, and a count taken there says nothing about attainment. Each row below uses its own residue's x\*, taken from the table in §3.3.

**How the prediction is computed.** The window has a fixed *relative* width, so the three log factors are not constant across it — at D = 12 the parameter q sweeps a factor of about 1.9 from one end to the other. The predicted count is therefore the integral of 𝔖(n)/(log q · log r · log c) across the window rather than its value at the midpoint. The two differ by well under a percent, and by more at larger D since log q ≈ log(n/(3D)) is smaller there, so nothing below turns on the choice; the integral is simply the quantity the heuristic actually predicts.

**Results.** Exhaustive over n ∈ [2×10⁵, 2.15×10⁵], ratio of actual count to predicted.

| n mod 24 | K | D | x\* | mean | sd |
|---|---|---|---|---|---|
| 0 | 1 | 2 | 0.50000 | 0.9867 | 0.157 |
| 4 | 1 | 2 | 0.50000 | 0.9975 | 0.147 |
| 6 | 1 | 2 | 0.50000 | 1.0141 | 0.151 |
| 10 | 1 | 2 | 0.50000 | 0.9954 | 0.164 |
| 12 | 1 | 2 | 0.50000 | 0.9876 | 0.149 |
| 16 | 1 | 2 | 0.50000 | 0.9915 | 0.147 |
| 18 | 1 | 2 | 0.50000 | 1.0055 | 0.155 |
| 22 | 1 | 2 | 0.50000 | 0.9970 | 0.163 |
| 2 | 1 | 6 | 0.36603 | 1.0442 | 0.172 |
| 8 | 1 | 6 | 0.36603 | 0.9971 | 0.174 |
| 14 | 1 | 6 | 0.36603 | 1.0422 | 0.173 |
| 20 | 1 | 6 | 0.36603 | 0.9983 | 0.176 |
| 1 | 2 | 2 | 0.29289 | 1.0066 | 0.089 |
| 9 | 2 | 2 | 0.29289 | 1.0228 | 0.097 |
| 13 | 2 | 2 | 0.29289 | 1.0065 | 0.092 |
| 21 | 2 | 2 | 0.29289 | 1.0198 | 0.097 |
| 3 | 2 | 4 | 0.25000 | 0.9354 | 0.143 |
| 19 | 2 | 4 | 0.25000 | 0.9030 | 0.134 |
| 7 | 2 | 4 | 0.29289 | 1.0213 | 0.145 |
| 15 | 2 | 4 | 0.29289 | 1.0162 | 0.142 |
| 5 | 2 | 6 | 0.22474 | 1.0068 | 0.121 |
| 17 | 2 | 6 | 0.22474 | 1.0056 | 0.123 |
| 11 | 2 | 12 | 0.18301 | 1.1006 | 0.168 |
| **23** | 2 | 12 | 0.22474 | 1.0341 | 0.151 |

```
python3 count_check.py --nmin 200000 --nmax 215000 --maxn 99999999 \
        --residue R --modulus 24 --parts K+1 --dq D --centre X
```

`--maxn 99999999` forces an exhaustive run; the default subsamples, which leaves the mean sound but the sd noisy.

**Every residue agrees to within a few percent, and no n in any band lacks a solution in its window.** The residual spread is finite-size: convergence is slow and one-sided at a given n, and the largest deviations sit at the largest D, where the count is thinnest. Following the two extremes further:

| | [2×10⁵, 2.15×10⁵] | [5×10⁵, 5.3×10⁵] | [10⁶, 1.03×10⁶] |
|---|---|---|---|
| n ≡ 11 (mod 24), D = 12 | 1.1006 | 1.0891 | **1.0025** |
| n ≡ 23 (mod 24), D = 12 | 1.0341 | — | **1.0033** |

with sd falling like n^{−1/2} throughout. Slow approach to an asymptotic constant is ordinary here; π(x) − li(x) is the standard caution against over-reading a one-sided gap at fixed size.

**The obstruction predictions hold in the other direction too.** Where the singular series vanishes the count must be zero, and it is: at n ≡ 23 (mod 24) the full-efficiency system (D = 2) vanishes identically, 834 of 834 values in a test band, with zero observed solutions at every one. Likewise n ≡ 1 (mod 12) at D ≥ 4, where h = (n−1)/2 is even and c would have to be even. So §3.3's local analysis is confirmed from the counting side as well as from the root analysis.

*The extra congruence the fused rung needs is automatic.* Rung B requires c ≡ 3 (mod 4). For n ≡ 11 (mod 24), r = Dq + 1 with q odd gives r ≡ 5 (mod 8), and n ≡ 3 (mod 8) then forces c = (n − r)/2 ≡ 3 (mod 4). No fourth condition has to be imposed — which is also why the mod-24 split coincides exactly with the split between rungs.

> **A local obstruction indexed by the twist prime.** Distinct from the above. In the weaker system c prime, r = n − 2c prime, r ≡ 1 (mod q), the congruence pins c to the single class (n−1)/2 (mod q); when that class is 0 the family is empty, since q | c forces c = q. It fires for one n in q. Verified: observed count 0 at every such n. It belongs in §3.3's inventory alongside ℓ = 2 and ℓ = 3, being an obstruction indexed by the twist prime rather than by a fixed small prime.

**What this establishes.** The local analysis and the singular series are confirmed at every residue mod 24, in both families, each at the balance point its own ceiling is derived from — the count matches, and the vanishing predictions vanish. It says nothing about §3.5's global question, whether solutions exist for *every* large n, which is where the conjecture lives. What it removes is the possibility that the constants are right but the model is wrong.

### 3.8 Which of S4 and S5 wins, and how often

*The two shapes of §3.2 have overlapping ceilings, so the question of which realises the family at a given n is not settled by the ceiling table. It is settled — asymptotically — by the relative supply of the three underlying systems, which is a singular-series computation of the same kind as §§3.1–3.3.*

**The predicted shares, from the singular series.** The three outcomes correspond to three systems, distinguished by the class of c and hence by the condition on r:

| outcome | c mod 8 | system | ceiling |
|---|---|---|---|
| S4 wins | 1 | q, Dq+1, (n−r)/2 all prime, D = 4 (res 7, 15) or 12 (res 23) | 0.085786 / 0.050510 |
| tie | 5 | same system | same |
| S5 wins | 3, 7 | same with **D doubled** — 8 or 24 — since c ≡ 3 (mod 4) forces 8 \| r − 1 | 0.085786 / **0.042020** |

Three facts settle the split. **The two singular series agree**: computed over n in a test band, 𝔖(D) and 𝔖(2D) match to four decimals at all three residues, since the systems differ only in a coefficient and ω(ℓ) = 3 generically for both. **The log factors agree** to within a percent, since the balance points differ but the arguments are all Θ(n). And **c mod 8 is decided by q mod 4** — from c = (n−1)/2 − (D/2)q with q odd — so the D-system's solutions split 1:1 between c ≡ 1 and c ≡ 5, i.e. between S4-wins and ties, by Dirichlet.

Hence at residues 7 and 15 the shares are **1 : 1 : 2** — S4 1/4, tie 1/4, S5 1/2 — the last class being two residues of c rather than one. At residue 23 the doubled system's ceiling **0.042020 falls below** 0.050510, so it never wins and the split is 1/2 : 1/2 : 0. Over all n:

> **S5 → 9/24 + 1/24 = 10/24 ≈ 41.7% outright; S4 → 1/24 ≈ 4.2%; tied → 1/24 ≈ 4.2%**, with S3 taking the even 12/24. The four sum to 1.

*These are model predictions.* What is actually observed at computed sizes follows, and it agrees on one of the three shares and not the other two. The nine-residue block is congruence-forced and so stable; the internal split at 7, 15 and 23 is empirical and may drift. So the two shapes are co-carriers, but very unequally: S4's outright share is an order of magnitude smaller and confined to three residues. Which of them the enumeration *reports* as the winner is a separate question, sensitive to how the SAFE cap treats a fused class — see §2.0.

**The observed split, by residue.** For a given n one takes the best c near the balance point, so S5 wins wherever *some* c ≡ 3 (mod 4) works — which is exactly the rung-B condition of §3.3, a congruence on n mod 24. At the nine rung-B residues S5 therefore wins outright, and only 7, 15 and 23 are in question. Measured over odd n in [2×10⁵, 2.06×10⁵]:

| n mod 24 | S5 wins | S4 wins | tie |
|---|---|---|---|
| 1, 3, 5, 9, 11, 13, 17, 19, 21 | **100%** | 0% | 0% |
| 7 | 24.0% | 24.8% | 51.2% |
| 15 | 26.8% | 18.8% | 54.4% |
| 23 | 0% | 44.0% | 56.0% |
| **all odd n** | **79.2%** | **7.3%** | **13.5%** |

Against the predicted 25 / 25 / 50 at residues 7 and 15: **the S4 share is already right** (24.8 and 18.8 against 25), while the tie and S5 shares are transposed — ties running at ~50% where S5 was predicted to. The next two boxes explain that, and the explanation is one the model itself predicts.

**Why 7 and 15 behave differently from 23, though all three are rung-C residues.** All three are n ≡ 7 (mod 8), and there c ≡ 3 (mod 4) forces 2c ≡ 6 (mod 8), hence r ≡ 1 (mod 8) and 8 | r − 1. With r − 1 = D·t and t odd that forces 8 | D — so the fused reading is not *unavailable* at these residues, only pushed to a lower efficiency: D = 8, i.e. **η = 1/4**, instead of the residue's own η = 1/2.

That would normally lose. It does not, because the two ceilings coincide **exactly**:

> cap_C(1/2) = (1/2)/(1+√2)² = **(3 − 2√2)/2** = cap_B(1/4) = (1/4)/(1+1/√2)².

This is not an instance of the ladder identity; solving cap_B(η/2) = cap_C(η) gives 2η = 1, so it holds at **η = 1/2 alone** — precisely the efficiency of residues 7 and 15. The two shapes therefore have the same ceiling there, and among the n where the *balanced family* decides the outcome, which one wins is settled by supply rather than structure: hence the near-even 24.8% / 24.0% split at residue 7.

At **23 mod 24** the mod-3 obstruction caps η at 1/6, so the fused reading needs D = 24, η = 1/12, and its ceiling **0.042020 falls below** S4's 0.050510. S5 can never win there — the measured 0%.

> **The ties are a separate phenomenon, and not the one the coincidence explains.** A tie means the two readings return the same *value*, which happens whenever the winning configuration's binding term is one that fusion does not touch. Diagnosed over tied n at residue 7: the binding term is the **foreign block** in 43 of 65 cases and the intra term in 22 — and the winning configurations sit at a median of **1.21× the residue's ceiling**, so at these sizes they are escape configurations (§4.1) rather than the balanced family. Fusing changes only the intra term, so wherever an escape wins on its foreign block the two readings agree identically. Consistently, at 23 mod 24 — where escapes are weaker — the tied values sit *at* the ceiling (median 0.989×) rather than above it.

> **Why the computed range does not yet show the predicted split.** The prediction above assumes the winner is drawn from the pool of near-optimal candidates in proportion to each class's supply. Two things have to happen for that to be the operative regime, and both are asymptotic. The escape-driven ties **thin at O(n/log n)** (§4.1), so eventually the outcome at every n is decided by the balanced family alone. And within that family the candidate count near the balance point grows like n/log³n, so every class becomes dense enough that its best candidate is essentially *at* the ceiling — at which point choosing the maximum is effectively drawing from the pool, and the probability the argmax lands in a class tends to that class's share of the pool. So the outcome split **should converge to the singular-series proportions**, with a residual tie fraction converging to the c ≡ 5 (mod 8) share rather than to zero, since fused and unfused give literally the same value there.
>
> The computed range is too small for either. The observed figures do not move monotonically across bands (28.0/26.4/45.6 at 2×10⁴, 23.5/50.0/26.5 at 2×10⁵, 32.7/41.3/26.0 at 10⁶), and those bands hold only 100–250 values apiece. A drift of order 1/log n falls from about 10% to 7% across that range, well inside the sampling noise. **The measurement is underpowered by roughly an order of magnitude, not in tension with the model.** Settling it wants the predicted class shares computed directly from the three singular series — which differ by the condition on r, not only by the density of c — against a single band of a few thousand values.
>
> *Does Friedlander–Granville threaten this?* Their result defeats strong uniformity for primes in progressions to moduli growing almost as fast as x, so it is the right thing to worry about whenever a heuristic leans on equidistribution across many classes at once. It does not bite here: **every modulus in play is bounded** — 8 and 24 for the residue bookkeeping, D ≤ 24 for the efficiency condition — and the windows have length Θ(n), so what is being assumed is equidistribution in a *fixed* finite set of classes over a long interval, which is a far weaker demand than anything their construction disturbs. The genuinely non-trivial assumption is elsewhere and is §3.5's: that the Bateman–Horn count holds **uniformly in n** as the singular series varies with n, rather than pointwise for each fixed system. That is where the conjectural weight sits, and no amount of bounded-modulus equidistribution supplies it.

## 4. Asymptotics: which configurations survive, and why the others do not

*§3 handles the configurations that carry the asymptotics — S3 for even n, and **S4 and S5 jointly** for odd n, which split the range by a congruence on c. This section covers everything else in the census: **S1 and S2**, the multiplicative engine, which thins; **S6**, present but supply-limited; **S7 and the escapes**, which reach only O(n/log n) values; and **S8–S10**, excluded by theorem. Each subsection says which of three fates applies, and on what evidence.*

> **Three fates, and they are different.** A configuration can (i) require a condition on n of density zero, so it *thins*; (ii) remain available at a positive density of n but be beaten by a better shape, so it *stops winning*; or (iii) remain available while reaching only a vanishing proportion of n. The distinction matters because (i) and (iii) both remove a shape from the asymptotic picture while (ii) does not, and because a fate-(iii) shape can still be conspicuous at computed sizes when the vanishing is only logarithmic — which §4.1 shows is the case for all four escapes.

### 4.0 The multiplicative engine (S1 and S2): fate (i), it thins

*Both shapes of the multiplicative engine live or die on the same condition. A fused class needs n = F·c with F and c both prime powers, i.e. **ω(n) ≤ 2**, and the two values of ω split the engine in two: ω(n) = 1 is **S1**, the trivial case at δ = 1, and ω(n) = 2 is **S2**, the fused family proper. Both thin, S1 the faster.*

ω(n) ≤ 2 is a **density-zero condition**. The count of n ≤ N with exactly two distinct prime factors is ~N log log N / log N; the prime powers are smaller still, at **π(N) + O(√N) = O(N/log N)**. So S1 vanishes fastest, S2 next, and neither survives into the asymptotic picture.

**S1 is the cleanest instance of fate (i), and the most extreme.** At n = p^a the group AGL(1, n) is 2-transitive, so μ(n) = C(n,2) and δ = 1 — the maximum possible density, achieved on a set of density zero. It is kept in the census for the same reason one keeps the trivial group: the degenerate member of the family, not an exception to it. Its O(N/log N) count is, incidentally, the same order as the escapes of §4.1, though for a far more elementary reason. The tables skip prime powers because the answer is known, not because μ is undefined there.

**The rest of this subsection is about S2**, where the thinning is slower and has a second mechanism on top of it.

> *Verified.* Fraction of composite non-prime-power n with ω(n) = 2, by dyadic block: **52.3%** on [10³, 2·10³), 43.1% on [5·10³, 10⁴), 35.0% on [5·10⁴, 10⁵), 29.8% on [5·10⁵, 10⁶), 28.5% on [10⁶, 2·10⁶).

**The prediction has begun to show up in the table, on both of its halves.** The density floor sat at 0.041812 (n = 575) for most of the programme; extending to n = 2212 moved it to 0.041107 (n = 2183), and extending to n = 2298 moved it again, to **0.037524 at n = 2291**. Each extension has lowered it. The thirds of the range behave as the argument requires:

| n | ω(n) = 2 share | median smallest cofactor F | min density |
|---|---|---|---|
| [6, 800) | 64.9% | 4 | 0.04181 |
| [800, 1500) | 53.6% | 5 | 0.04229 |
| [1500, 2298) | 50.0% | **7** | **0.03752** |

Two effects, not one. The ω(n) = 2 population thins, as predicted; and **among the values that remain, the smallest prime-power cofactor grows**, so the 1/F the multiplicative engine delivers shrinks even where the engine applies. n = 2183 = 37·59 illustrates the mechanism: ω(n) = 2, so a fused class exists, but only at F = 37, worth 1/37 ≈ 0.027 — which loses to the three-class configuration 1297\* + 443 + 443 at 0.041107, itself unbalanced at x = 0.2029 against its residue's 0.2247. The current floor n = 2291 = 29·79 is the same story one step further: F = 29 gives only 1/29 ≈ 0.034, and the winner `2x761 + 1x769*` is a mixed shape — a fused pair plus a foreign prime — reaching 0.037524. Both are values where **both engines are weak at once**, and both are n ≡ 11 (mod 12), the doubly-obstructed class.

Two consequences, and both should temper how the computed range is read.

**The observed density floor should drift downward.** Fully 55.7% of the current table has ω(n) = 2, so more than half the computed values are served by an engine whose reach halves over the next few decades of n. The median of 0.1994 is propped up by a population that thins — and the prediction has already been borne out: the floor was 0.0418 at n = 575 when the table reached 1,540, then 0.041107, then 0.037524 at n = 2,291, and it now stands at 0.026117.

### 4.1 The escapes: O(n/log n), and why the log is the whole story

*§3.3 lists four routes by which an individual n exceeds its residue's ceiling. Each supplies a block whose size is a power of a fixed small prime; this section counts how many n they reach.*

*They are routes **within** families, not families of their own, which is why they have no S-number and why they are gathered here rather than under §4.0 or §4.2:*

| route | the family it sits inside |
|---|---|
| c a power of 2, giving the two-part 2^a + r\* | **S3** at odd n |
| (r − 1)/2 or c a power of 3 | **S4 / S5** |
| r a Fermat prime | **S5** |
| a cyclic-layer-fused class of F = 3 blocks | **S7** |

*What they share is the mechanism, not the family: a block pinned to a power of a fixed small prime. That is also what bounds them, since it leaves O(1) choices per n.*

**The ceiling confines the block to a bounded ratio range.** Take the 2^a + r\* route, at a residue with ceiling δ₀. Its density is min(x², η(1−x)², 2x(1−x)) at x = 2^a/n, so reaching δ₀ needs **both** x² > δ₀ and η(1−x)² > δ₀, and since η ≤ 1 the second forces (1−x)² > δ₀. Hence

> **√δ₀ < x < 1 − √δ₀.**

The interval has ratio (1 − √δ₀)/√δ₀, which is largest at the smallest ceiling. At δ₀ = 0.050510, the value at n ≡ 23 (mod 24), the range is (0.2247, 0.7753) — ratio **3.45 < 4**, so it holds **at most two powers of 2**. At the unobstructed odd residues, δ₀ = 0.171573, the range is (0.4142, 0.5858) with ratio 1.41, holding at most one.

**Counting by a rather than by n.** Fix the block size 2^a and ask which n it can serve. The constraint above inverts to n ∈ (1.290·2^a, 4.449·2^a), so r = n − 2^a runs over an interval of length at most 3.16·2^a, and the number of primes in it is at most

> 3.16·2^a / log(0.290·2^a)  ≤  (3.16/log 2)·2^a/a  for a ≥ 3.

*The shape of the answer is visible before any care is taken.* Substituting x = 2^a turns the sum into a Riemann sum for an integral: da = dx/(x log 2) and the summand is x·log 2/log x, so the term times da is dx/log x, and the sum looks like **li(N)** — that is, N/log N. (Equivalently, parametrising by x = 2^{a/2} gives ∫x dx/log x, which u = x² returns to ∫du/log u.) This gets the order right and the constant wrong: because the sum runs over a geometric sequence rather than a continuum, S(A)/li(2^A) tends to about **1.38**, not to 1. So the picture is right and the bookkeeping still has to be done.

Summing over a ≤ A := ⌊log₂(N/1.290)⌋ needs care: there are A ≈ log₂N terms and the largest is already of order 2^A/A ≈ N/log N, so a term-by-term bound would only give O(N). What saves it is that the terms decay geometrically going down, so the sum is a constant multiple of its last term. Explicitly, split at m := ⌈log₂A⌉:

> **tail** Σ_{A−m < a ≤ A} 2^a/a ≤ (A−m)⁻¹ Σ_{a ≤ A} 2^a < 2^{A+1}/(A−m),
> **head** Σ_{a ≤ A−m} 2^a/a ≤ Σ_{a ≤ A−m} 2^a < 2^{A−m+1} ≤ 2^{A+1}/A,

the head bound using 2^m ≥ A. Adding,

> **Σ_{a ≤ A} 2^a/a < 2^{A+1}(1/(A−m) + 1/A) = (4 + o(1))·2^A/A.**

The head is crude — it throws away the 1/a entirely — but it is applied only where the geometric factor has already made the terms negligible, which is what makes the crudeness harmless. (The true ratio Σ/(2^A/A) tends to 2, so the constant 4 is safe with room.) With 2^A ≤ N/1.290 and A = log₂N − O(1),

> **#{n ≤ N reachable by this route} = O(N/log N),**

with an explicit constant of about 20 as bounded here. The direct sum evaluates to ≈ 3.7·N/log N, so the bound is loose but unconditional.

The same argument covers the other three routes verbatimThe same argument covers the other three routes verbatim — powers of 3 instead of 2 (at most two in a ratio-3.45 window, at most one once the ceiling exceeds 0.086), and for the Fermat route only five block sizes exist at all. **So every escape reaches a vanishing proportion of n, and the asymptotic constants of §5 stand.**

**But the vanishing is logarithmic, which is why they are conspicuous at computed sizes.** Measured against the mod-24 ceilings, the fraction of odd n whose ceiling the route exceeds:

| n ≈ | 1.3×10⁴ | 1.0×10⁵ | 1.0×10⁶ |
|---|---|---|---|
| 2-power route | 3.73% | 2.20% | 1.20% |
| 3-power route | 2.48% | 1.00% | 0.00% |

Both fall, consistent with the O(1/log n) bound and if anything faster — the 3-power route is already empty by 10⁶, since once a residue's ceiling exceeds 0.086 its window admits at most one power of 3 and usually none.

**Availability and effectiveness are different quantities, and only the second thins.** A route being *available* — some 2^a + r\* representation existing at all — is a much weaker condition than its reaching the ceiling, and it does not thin: Romanov (1934) gives {2^k + p} positive lower density, and Erdős (1950) gives a positive density of odd n with no such representation, so availability sits at 86–99% of odd n and stays there. What the count above measures is effectiveness, and that is what the ceiling analysis needs.

**None of this moves §5's floor**, and the reason is general: every escape *raises* δ(n), a floor is a minimum over n, so a route lifting some values above their ceiling cannot lower it however common it is. What the escapes change is the reading of the ceiling table — δ₀ is what the *balanced* shape guarantees at that residue, not a bound on what any shape achieves there.

### 4.2 S6: fate (ii), present but supply-limited

*S4 needs no entry here. It and S5 both realise the family of §3.2 and draw on the same Hardy–Littlewood supply, so neither thins; they divide the range by c mod 8, and the analysis is in §3.2. Both carry the odd-n asymptotics.*

**S6 — two outside blocks and no matching class.** Its ceiling is 1/4, the same as S3's, so it is not cap-limited; it is **supply**-limited. It needs r₁ + r₂ = n with both rᵢ − 1 = 2qᵉ for a *common* q, which is a system with two efficiency conditions coupled through a shared parameter rather than the single condition of §3.2. That is strictly harder than anything §3 analyses, and it is why S6 has exactly one winner in the whole computed range (n = 1175). Expected fate (ii) tending to (i), but the singular series for the coupled system has not been written down.

### 4.3 What is left over

**S8, S9, S10** are excluded by theorem, not by rarity — D1, D2, and the normality argument respectively. They cannot occur at any n, so they have no asymptotics.

**S7** is an escape rather than a family, and §4.1 counts it with the other three at O(n/log n). Its parity structure is the one thing here that genuinely restricts n: at odd n it forces c to be a power of 2, which is what puts it in that class.

### 4.4 The asymptotic question is entirely Hardy–Littlewood

**Summary of the fates.**

| shape | fate | evidence |
|---|---|---|
| S2 | (i) thins | ω(n) = 2 with both factors prime powers has density 0 |
| S3 | carries even n — **≈ 50% of n** | §3.1; the counting check of §3.7 |
| S5 | carries odd n — **10/24** outright, sole winner at the nine rung-B residues | §3.2 |
| S4 | co-carries odd n — **1/24** outright, 1/24 tied with S5, only at 7, 15, 23 mod 24 | §3.2 |
| S6 | (ii), plausibly (i) | supply-limited by a coupled two-efficiency system; 1 winner in range |
| S7, the escapes | (iii) permanent at a small proportion | measured in §4.1 for two of three routes |
| S1 | (i) thins | prime powers are O(N/log N); δ = 1 there, known exactly |
| S8, S9, S10 | cannot occur | excluded by D1, D2, normality |

Since the multiplicative engine vanishes in density, the asymptotic behaviour of μ(n) for almost all n is set by the additive families, whose caps are 1/4 and 1/9 and whose availability is a Bateman–Horn question. In particular the ladder constants of §5 of the notes — the §3.3 constants — are the right asymptotic quantities, and the fused family's 1/2 and 1/3 are not, however dominant they look in the table.

---

## 5. A single global lower bound

The residue analysis gives eight different δ₀ across the 24 residue classes (§3.3). It is worth collapsing them into a single number that should hold everywhere, even at the cost of being loose.

**Where the floor lives.** The worst residue is **n ≡ 23 (mod 24)** — the only one carrying both local obstructions *and* unable to reach the fused rung — with δ₀ = 0.05051. Every value that has ever set a running floor has been in n ≡ 11 (mod 12), which contains it; 8 of the 11 are ≡ 23 (mod 24) and the other three are ≡ 11, which is not a contradiction, since finite-n record holders are low from *supply* failure rather than from a low ceiling. `ladder_verify.py` computes, for each n, the best density achievable by four explicit families, scanning the block size over a window wide enough to contain every balance point, x ∈ [0.10, 0.55]. Over all composite non-prime-power **n ≤ 10⁶** (78 minutes) the smallest value is

> **δ ≥ 0.02516, at n = 8927.**

This is a *lower* bound on δ(n), not δ(n) itself, since it uses only four families. No class is anomalously weak relative to its own cap: the per-class minima of δ/cap run from **0.327 to 0.716**, the spread expected from representation availability alone.

**The floor rises with n**, as the singular-series picture requires — once representations near the balance point become plentiful, the achievable density approaches the class cap. Block minima over the last seven blocks of 10⁵:

| block | floor | at n |
|---|---|---|
| [3·10⁵, 4·10⁵) | 0.04625 | 368639 |
| [4·10⁵, 5·10⁵) | 0.04518 | 421679 |
| [5·10⁵, 6·10⁵) | 0.04704 | 562847 |
| [6·10⁵, 7·10⁵) | 0.04729 | 602843 |
| [7·10⁵, 8·10⁵) | 0.04732 | 714347 |
| [8·10⁵, 9·10⁵) | 0.04738 | 848327 |
| [9·10⁵, 10⁶] | 0.04810 | 948527 |

> **These are now real minima.** An earlier version of the script exited as soon as it cleared 0.9 × the class cap, so six consecutive blocks all reported the same 0.04546 = 0.9 × 0.05051 — an artefact sitting exactly where the signal is. With the cutoff raised to the asymptotic constant, nothing below 0.050510 is truncated, and the rise above is the first direct evidence for §4's prediction that the envelope climbs as the ω(n) = 2 population thins.

So the low-density dips are a small-n phenomenon and the asymptotic floor is the ceiling at **n ≡ 23 (mod 24)**.

> **The constant is right and the extremal residue is now stated correctly below.** §3.3 derives the ceilings mod 24 rather than mod 12: nine of the twelve odd residues rise by 33–54% because a fused rung is reachable there, and three do not — **7, 15 and 23 mod 24**. The minimum over all residues is unchanged at **0.050510**, attained at **n ≡ 23 (mod 24)** alone, half of the old n ≡ 11 (mod 12).

> **Conjecture (global density floor).** For every composite non-prime-power n,
>
> **μ(n) ≥ C(n,2)/50**,  i.e. **δ(n) ≥ 0.02**,
>
> and asymptotically
>
> **δ(n) ≥ (5 − 2√6)/2 − o(1) = 0.050510…**,
>
> the extremal class being **n ≡ 23 (mod 24)** — the only residue carrying both local obstructions *and* unable to reach the fused rung, where the balanced family yields η/(1 + k√η)² at η = 1/6, k = 2. The other half of n ≡ 11 (mod 12) reaches 0.06699 (§3.3). The asymptotic half says the *worst* n eventually reach what the balanced family guarantees; it is a floor, and individual n exceed it freely.

The constant 1/50 is deliberately loose. Two things are absorbed into the margin: the finite exceptional set of §3.5, whose members fall back on whatever configuration they can find, and the windowing loss of §3.4, which costs a factor Θ(√ε) when the balance point is not exactly available.

### 5.1 The branch-and-bound, and what it currently establishes

The worklist admits a search that converges fast, because `ladder_verify` returns a *lower* bound: if LB(n) ≥ M for the standing minimum M, then δ(n) ≥ M and n cannot lower it, so n is discarded without computation. Take the smallest known δ as M, discard every candidate with LB ≥ M, compute δ at a survivor, lower M if it beats it, repeat.

**As run, against the pre-2026-08 table**, over 48,729 candidates:

> M = (5 − 2√6)/2 → 0.041812 (n = 575) → 0.041107 (n = 2183) → 0.037524 (n = 2291) → 0.029282 (n = 3059) → **0.026117** (n = 3239), and the search then terminates: n = 8927, the last candidate, rejects at K = 3 without B(8927) ever being computed —
>
> ```
> [193/48729] n=8927    B/C(n,2) > 0.02612  rejected at K=3   (9398.0s cumulative)
> ```
>
> The order of examination changes which values get *recorded* — one can set the running floor and then be superseded by a smaller n examined later — but not the result, since the floor only falls and pruning is sound at every stage.

**What survives the enumeration defect, and what does not.** Every step used the table from below: `ladder_verify.py` scores explicit constructions, and B(n) ≤ μ(n) wherever the collapse certificate applies, which covers both survivors. So

> **min { μ(n)/C(n,2) : n ≤ 10⁶ composite, not a prime power } ≥ 0.0261166…**

is proved and unaffected. What fails is the reading of that number as a *value* of μ. It is **not attained at n = 3239**: under the corrected shape space that n reaches 0.043570 (seven copies of a 256-block plus an outside 1447-block, twist 241) and n = 3059 reaches 0.083906. The argmin has moved and the bound is no longer tight.

**The rerun will be cheap, and should raise the floor.** The 2026-08 worklist has **41,584** entries, 14.7% fewer, and only **one** sits below 0.026117 — n = 8927 itself, whose B(n) already exceeds 0.02612. Two lie below 0.030 and 23 below 0.037524. So the true minimum below 10⁶ looks likely to land at or above **0.037524** (n = 2291), which would put the conjecture's margin above 1.8 rather than the 1.31 the old floor gave.

`mu_enumerate.py --floor M --adaptive` runs the loop as one job: it seeds at M·C(n,2) so any configuration above the floor rejects n immediately, prunes candidates whose lower bound has risen above the current floor, computes B(n) exactly only for survivors, and adopts a lower value as the new floor — which in turn tightens Proposition F.1's part-count cap ⌊1/√M⌋ for everything after it.

### 5.2 The hard range is bounded on both sides, and it is small

The worry motivating §3.5 — that between the computable range and the asymptotic one lies a middle where neither argument reaches — is answerable empirically, and the answer is favourable. Minimum lower bound over each decade of the 41,584-entry worklist:

| n | values in worklist | minimum bound | attained at |
|---|---|---|---|
| [10², 10³) | 2 | 0.03649 | 935 |
| [10³, 10⁴) | 158 | 0.02516 | 8927 |
| [10⁴, 10⁵) | 2,987 | 0.03045 | 11819 |
| [10⁵, 10⁶) | 38,437 | 0.04125 | 134423 |

## 6. Running the implication backwards, correctly

Corollary 3.2 of the notes is an equivalence, so a lower bound on μ yields an additive prime statement. It is worth being exact about *which* statement, because the natural reading is too strong.

**It does not force any single Bateman–Horn system to be solvable for all large n.** A bound μ(n) ≥ δ₀·C(n,2) says only that *some* admissible configuration reaches δ₀ — and which one may vary with n. Nothing in the framework privileges a particular system, and indeed the computed table shows the winning shape changing constantly with n.

**What it does force is a covering statement over a finite set of systems.** At density δ₀ the search bounds are all effective. Proposition F.1 caps the number of classes at k ≤ 1/√δ₀; each part has size s_i ≳ √δ₀·n, so with Σ s_i = n the fusion counts obey F_i ≤ 1/√δ₀ as well; foreign parts are never fused (Lemma B′) and are pairwise distinct primes. So the possible **shapes** — the choice of k, of each part's type, and of the fusion counts — form a finite set whose size depends on δ₀ alone:

| δ₀ | k ≤ | distinct shapes |
|---|---|---|
| 1/9 | 3 | 31 |
| 1/16 | 4 | 117 |
| 0.026117 (current floor) | 6 | 1,593 |
| 0.02 (conjectured) | 7 | 5,937 |

Each shape, with n as a parameter, *is* a Bateman–Horn system in its remaining free variables. So the correct backwards implication is:

> **μ(n) ≥ δ₀·C(n,2) for most n  ⟹  for most n, at least one of a finite explicit set of Bateman–Horn systems is solvable at n.**

That is a covering statement, and it is strictly weaker than any single system being solvable — which is why the route yields robustness rather than sharp prime theorems. It is also why the ladder survives individual systems failing: §3.3's local obstructions kill particular systems in particular residue classes without touching the conclusion, because another shape covers those n.

**Why conditionality is unavoidable once ω(n) ≥ 3: a dichotomy.** Every block must have size ≍ n, so there are boundedly many. A p-characteristic block of size c contributes C_{c−1} to the cyclic middle layer, and Oliver's chain requires that layer to be cyclic. Two blocks of *different* odd prime-power sizes c, c′ contribute C_{c−1} × C_{c′−1}, and both orders are even, so the product is never cyclic. That leaves exactly three escapes:

- **all blocks the same size** — one diagonal C_{c−1}, cyclic, with the top q-group coming free from permuting the blocks. This is n = F·c, the multiplicative engine, and it is unconditional — but it needs ω(n) ≤ 2;
- **a block of 2-power size** — then c − 1 is odd and can sit cyclically beside C_{r−1} without demotion. This is what n = 551 = 256 + 167\* + 128 exploits, and §4.1 counts at O(n/log n) values;
- **demote one block's multiplicative group into the top q-group** — then Γ/Γ₁ = C_t must be a q-group, so t = (r−1)/d must be a prime power. That is the Sophie Germain condition, and it is where the conditionality enters.

Read this way η = 2/d is not an efficiency knob but **the price of using blocks of unequal size at all**, and the dichotomy explains why no unconditional family with ω(n) ≥ 3 has ever appeared in the computed table: from constructions of this shape, none can.

**In census terms**, the disjunction below ranges over S3, S4 and S5 for the two- and three-class shapes, plus their higher-k analogues; S2 drops out with the fusion shapes, and S6 through S10 either cannot occur or are supply-limited past the point of mattering (§4). So the finite set of Bateman–Horn systems is exactly the set §3 analyses, taken over all part-counts up to the bound below.

**The fusion shapes can be dropped from the asymptotic statement.** A shape with any F_i > 1 needs a q-power's worth of equal blocks, and in the extreme single-class case n = F·c it needs ω(n) ≤ 2 outright. Fused winners are 39.3% of the computed table, but that share is propped up by small n: the ω(n) ≤ 2 population thins like log log n / log n (§4), from 64.9% below 800 to 28.5% near 10⁶. So the fusion shapes cover a **density-zero** set of n, and the asymptotic covering statement runs over the purely additive shapes alone — a much smaller set, 5 of the 31 at δ₀ = 1/9.

**What this does not give.** Because the conclusion is a disjunction over shapes, it cannot be inverted into a statement about any one prime configuration; one cannot extract "n = c + r with r a safe prime is solvable for large n" from it. Getting that would need the covering to be shown *irredundant* — that some particular n are covered by one shape only — which the data does not support, since most n are covered by several.

---

## 7. What this says about the open problems

**The odd-n route above 1/9 is refuted.** It asked for a constant above 1/9 bounding δ from below on odd n, so Theorem E.1 would settle the collapse there wholesale. No such constant exists: **54.3% of the odd n in the computed table have δ(n) < 1/9**, and these are exact values of μ, not shortfalls of any family. Worse, the share grows — 37.0% of odd n below 800, 59.9% in [800, 1600), 64.8% in [1600, 2299). The route is closed permanently, so **Open Problem 8(b) must be settled by promoting E.3(ii) directly**, which is the only remaining path.

**Open Problem 1** stands: the ℓ = 2 and ℓ = 3 efficiency losses obstruct *these* families rather than μ itself, and a family with different local structure might avoid them. The worked instance is n = 551 = 256 + 167\* + 128, using two distinct powers of 2 to sidestep the equal-block form. Since both systems already supply ~n/log³n representations wherever soluble, no strengthening of sieve input helps — this is a question about mechanisms.

**Open Problem 8(a) (k ≤ 3)** is the statement that the four-class cap 1/16 is never the best available, which needs ω(n) ≥ 3 together with no good two- or three-class representation. It has never occurred: no winner in the computed table uses four classes, and the δ ≤ 1/16 tail is 45 of 1,921 values. The branch-and-bound of §5 adds a little: it examined every n ≤ 10⁶ whose lower bound fell below the running floor, and none of them wanted a fourth class either.

**Open Problem 8(b)** lives where the three-class family is the best available. With the above-1/9 route refuted, the only path is the direct one. It also **grew harder as the density floor fell**: s ≤ 1/√δ − 1, so at 0.026117 the branches s = 4 and s = 5 are both reachable, and neither has a theorem — unlike s = 3, which E.4 collapses to a single dead pair. *This may partly reverse under the repair*: the corrected shape space lifts both former record-holders well above 1/25, so the number of values admitting s ≥ 4 should be recounted once the enumerator is fixed.

**The §4 barrier at exponent 3/2** is untouched: both engines give density Θ(1) where they apply, and the barrier concerns lower bounds on the least prime in an arithmetic progression. The two obstructions are independent.

---

## 8. Open questions specific to this document

1. **Extend the branch-and-bound past 10⁶.** The search as run is complete below 10⁶ (§5) and gives δ ≥ 0.026117, but its argmin has moved under the corrected shape space and it wants rerunning first — the 2026-08 worklist has 41,584 entries against 48,729 and only one below 0.026117. Pushing further needs `ladder_verify.py` run at a larger N, which is O(N²/log N) — 78 minutes to 10⁶, so 10⁷ is multi-day. The lower envelope has risen monotonically since [10³, 10⁴), so the expected return is confirmation rather than a new minimum; the value of doing it is in how far the pattern can be pushed, not in what it is likely to find. The reduction is essentially free: all but a handful of worklist entries are eliminated by comparing their lower bound against the running floor. Extending the range would replace the deliberately loose 1/50 in the conjecture with something close to the observed value.

2. **Bound the s = 4 and s = 5 branches.** The only item here that is a gap in a *proof* rather than in evidence. *Recount after the rebuild:* at n = 3239 and 3059 the density rises sharply under the corrected shape space, so both leave the sub-1/25 set and the branch may narrow without any new theorem. E.1 caps s = 1 by the Mersenne constants and E.3(iii) caps the s = 2 repunit branch; s = 4 has neither, and is not thin enough for an E.4-style collapse. An absolute cap would have to come from the foreign block's twist, as in those two. The search clears it at every computed n, so nothing is unproved — but the gap widens as the floor falls.

3. **Predict the 1/12 shortfall from the singular series.** §5.5 of the notes measures **22.2% of odd and 1.0% of even** values below 1/12. Both engines' availability is computable heuristically, so this compares the whole framework of this document against measurement rather than testing any single family.

4. **Is the four-class family ever optimal?** Equivalently, does the triple coincidence of §6 ever occur? *Partial answer, measured 2026-08.* Over odd n in [2×10⁵, 2.012×10⁵], the necessary condition — both the two- and three-class families below the four-class cap of 1/16 — holds at **95 of 600 values**, so it is far from rare. But at every one of those the three-class family still reaches 0.046–0.050, and a four-class family would have to beat that while capped at 1/16 = 0.0625 and needing **four** simultaneous prime conditions rather than three. The margin is a factor of only 1.25–1.35, against a supply penalty of one more log. So the answer is very likely no, and the reason is a squeeze rather than an obstruction — which also means it will not yield to a local-solubility argument. A proper heuristic estimate would compare the four-condition singular series against that margin directly; the machinery for it is `count_check.py` with a fourth form.

5. ~~**Do the ℓ = 3 escapes behave as the sparsity heuristic says?**~~ **Resolved (§4.1), and now proved rather than assumed.** All four escape routes reach **O(n/log n)** values of n: the residue's own ceiling confines the block to a ratio range of width under 4, which admits O(1) block sizes, leaving one prime's worth of freedom. Measured, the 2-power route's effectiveness falls 3.73% → 2.20% → 1.20% across n ≈ 10⁴, 10⁵, 10⁶ and the 3-power route reaches zero by 10⁶. The asymptotic constants are untouched; the escapes are conspicuous at computed sizes only because a log vanishes slowly.

6. **The fused family at ω(n) = 2 but bad splitting.** **338 of the 1,118** values with ω(n) = 2 do better with a split than with fusion, which happens when the smallest prime-power cofactor F is large. The distribution of F over ω(n) = 2 integers is classical, so predicting the 754/323 division is a clean test.

7. **Efficiency below 1.** The distribution of the largest prime-power divisor of r − 1 over primes r is a shifted-prime question of Erdős type; the known results should be imported rather than re-derived, since η is what fixes every constant in §3.3.

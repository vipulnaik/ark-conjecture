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
3. **The ceiling splits by residue class mod 24, for both parities.** Two ingredients combine. The local obstructions at ℓ = 2 and ℓ = 3 split it mod 12 — and those are the only two moduli that can obstruct, because each system is three linear polynomials so ω(ℓ) ≤ 3 < ℓ for ℓ ≥ 5. On top of that, whether the odd family can reach its **fused rung** is a further condition mod 8 on n, which refines the odd classes to mod 24. Eight distinct constants result, from 1/4 down to 0.05051 (§3.3).
4. **One global floor covers everything.** Conjecturally **δ(n) ≥ 0.02 for every composite non-prime-power n** — and below 10⁶ the branch-and-bound establishes **δ(n) ≥ 0.026117** unconditionally, since every step used the table only as a lower bound (§5). What it does *not* establish, after the 2026-08 defect, is where the minimum sits: at n = 3239 the corrected shape space raises δ to 0.043570, so the argmin has moved and the bound is no longer tight. The extremal residue is **n ≡ 23 (mod 24)** (§3.3), and almost every stage of the search has landed in n ≡ 11 (mod 12), which contains it.
5. **The multiplicative engine covers a density-zero set, so asymptotically the additive engine is everything.** The fraction of n with ω(n) = 2 thins like log log n / log n — measured at 52% below 2000 but 29% near 10⁶. So the asymptotic behaviour of μ is governed entirely by the Hardy–Littlewood side, and the observed density floor should be expected to drift downward as the fused family's reach recedes.

---

## 2. The configurations, and the two engines

*The companion `enumeration-proof.md` classifies which configurations an Oliver group can realise and proves that classification; this document is about how they behave arithmetically. Its Part 0 carries the **configuration census**, reproduced below so that both documents can be read on their own.*

> **One computed instance of each live shape**, from `mu_table_safe_v4.csv`, so that every row below can be checked against a concrete configuration. The starred part is the foreign block; the term in bold is the one that binds.
>
> | shape | first instance in v4 | witness | B(n) | δ |
> |---|---|---|---|---|
> | S1 | every prime power | n = c, AGL(1, n) | C(n,2) | 1 |
> | S2 | n = 6 | `p=3 q=2: 2x3` | 6 | 0.400000 |
> | S3 | n = 30 | `p=13 q=2: 1x17* + 1x13` | 78 | 0.179310 |
> | S4 | n = 247 | `p=73 q=5: 1x101* + 1x73 + 1x73` | 2525 | 0.083111 |
> | S5 | n = 459 | `p=101 q=2: 1x257* + 2x101` | 10100 | 0.096089 |
> | S7 at F = 2 | n = 99 | `p=23 q=13: 1x53* + 2x23` | 506 | 0.104308 |
> | S7 at F ≥ 3 | n = 143 | `p=2 q=23: 3x32 + 1x47*` | 1081 | 0.106471 |
>
> S6 has no instance in v4's current range. The pair to compare is **S5 at n = 459 against S7 at F = 2 at n = 99**: both are `2×c + r*`, and they are distinguished only by the top prime — q = 2 in the first, where the twist stays full and the Fermat prime 257 keeps the foreign block at η = 1, and q = 13 in the second, where the twist is cut to the odd part of 22 and the foreign block runs at η = 1 through an odd q instead.

> **The census is duplicated on purpose.** A split — structure there, behaviour here — would force a reader to join two tables across two files mentally, which is worse than the drift risk. So the duplication is deliberate and the drift risk is handled mechanically instead: `check_doc_figures.py --pass census` cross-checks every S-row between the two documents and reports any that is missing or reworded. **S-numbers are append-only.** A new shape gets the next number and a row in both files; nothing is ever renumbered, because the S-numbers are the key the documents are joined by.

### 2.0 The census

> **Provenance of every measured figure in this document.** Three tables have been in play. **v2** predates the shape-space repair (G.2). **v3** has the repair but predates the SAFE tightening, so it over-credits fused shapes. **v4** is current and in flight. Structural columns, closed forms and asymptotic verdicts are stable; **winner counts, percentages and per-shape medians are not**, and are marked with their table where it matters. Anything below quoting a count without a table attribution is v2- or v3-era and should be recomputed against v4 before being cited.

| # | shape | engine | winners | asymptotic verdict: **exists** / **wins** | where |
|---|---|---|---|---|---|
| **S1** | one matching block, no copies | — | every prime power | **exists → 0**; **wins → 0**, the same set. Prime powers up to N number π(N) + O(√N) = O(N/log N), and where the shape exists it wins outright at δ = 1 | §2.1, §4.1 |
| **S2** | fused matching class, **top**-layer copies, n = F·c | multiplicative | 40.4% (v3) | **exists → 0**; **wins → 0**, essentially the same set. Needs ω(n) = 2 with both factors prime powers; where available it gives δ = 1/F, which beats every additive shape at small F, so it wins nearly wherever it exists | §2.1, §4.1 |
| **S3** | matching + outside, n = c + r\* | additive | 37.8% (v3) | **exists → 12/24 *plus a positive proportion of odd n***; **wins → 12/24**. All even n conjecturally, and at odd n the shape survives with c = 2^a, giving n = 2^a + r\* — which Romanov puts at positive lower density and Erdős's covering congruences keep bounded away from all of odd n. So this is the one row where existence strictly exceeds winning by a positive density rather than by a rate: the odd instances exist but are almost never good enough near the balance point to win, and even on the even side existence converges faster than winning | §3.1, §4.3 |
| **S4** | two matching + outside, n = 2c + r\* | additive | **6** winners over v4's current range (n = 247, 285, 437, 777, 1377, 1417), all with c ≡ 1 (mod 8) | **exists → 12/24** (all odd n); **wins → 1/24 ≈ 4.2%** outright plus 1/24 tied with S7 at F = 2, confined to residues 7, 15, 23 mod 24. **The widest existence/winning gap in the census**: the shape is available at essentially every odd n and is simply beaten by the fused rung wherever that rung is reachable | §3.2, §3.9 |
| **S5** | **top-layer**-fused matching + outside; forces q = 2, hence η = 1/u | hybrid | 24 (v4) | **exists → 12/24** (all odd n — q = 2 fusion is always available, just usually at a useless η); **wins → 0**. An escape: winning needs η = 1/u with u small, i.e. r = 2^a·u + 1, which is O(log n) candidates per n and so O(n/log n) values | §3.3, §4.3 |
| **S6** | two outside blocks | additive | 0 (v4) | **exists → 12/24** (every even n with a Goldbach representation); **wins → 0**, and not from scarcity: cap = 1/(√m₁+√m₂)², the 1/4 and 0.17157 rungs are locally obstructed at ℓ = 3 down to n = 26 and n = 20, and the plentiful rung caps at 0.13397 where S3 reaches 1/4 | §4.2 |
| **S7** | **middle**-layer-fused matching + outside; **F = 2 is the odd-n fused rung B** | hybrid | 150 at F = 2 (v4) | **F = 2: exists → 12/24** (all odd n); **wins → 10/24 ≈ 41.7%** outright plus 1/24 tied with S4, sole winner at the nine rung-B residues. The gap is the three residues 7, 15, 23 mod 24 where the rung is unreachable or only ties. **F ≥ 3: exists → 12/24** — at even n the shape n = 3c + r is a full Hardy–Littlewood system with the same supply as S3, plus O(n/log n) odd values where F·c even forces c = 2^a; **wins → 0**, since even n already have S3 at cap 1/4 against F = 3's ceiling of 0.13397 | §3.2, §3.9, §4.3 |
| **S8** | bottom-layer-fused matching | — | never | never exists (Lemma D1), so no asymptotics | — |
| **S9** | fused outside block, any layer | — | never | never exists (Lemma D2), so no asymptotics | — |
| **S10** | outside block with r = q | — | never | never exists — normality kills the twist | — |

> **The verdict column reports two different limits, and they can differ sharply.** **Exists** is the proportion of n at which *some* admissible configuration of the shape can be built. **Wins** is the proportion at which one attains B(n). For S1, S2 and S6 the two coincide because the shape is rare and dominant where it occurs; for S8–S10 both are zero by theorem. For the odd-n family they diverge: S4, S5 and S7 at F = 2 all exist at essentially every odd n, and which of them wins is decided by the ceiling comparison of §3.3, so their winning shares partition the odd residues while their existence shares all equal 12/24. Even where the two limits agree, existence converges faster — a representation becomes available well before it becomes good enough near the balance point to beat everything else.
>
> **The winning shares sum to 1; the existence shares do not, and are not even a partition.** Several shapes are simultaneously available at the same n — that is exactly what makes the ceiling comparison the substantive question — so the existence column double-counts by design. S3 is the case worth watching, since its existence is not confined to one parity: the odd-n instances n = 2^a + r\* are a positive proportion by Romanov, so S3 exists on strictly more than half of all n while winning on exactly half. Note also that the odd-n existence density here is not known to *converge*: Romanov gives a positive lower density and Erdős an upper bound below 1, with the limit itself unsettled, so the entry is a proportion bounded away from both ends rather than a value.

> **S4 and S7 at F = 2 are co-carriers, not rivals.** Both realise the same family n = 2c + r; whether fusing the two equal blocks helps depends on c mod 8, and each verdict holds on a quarter of all c. **The fused rung here is S7 at F = 2, not S5.** S5 fuses by a *top-layer* involution, which keeps the full twist and obeys no congruence on c at all, but forces q = 2 and so is rationed by the foreign block instead — which is what makes it an escape rather than a carrier. The analysis is in §3.2.
>
> **What the winner column reports is sensitive to the SAFE cap.** Crediting a fused class F·C(c,2) regardless of its twist inflates fused shapes specifically — the one place SAFE's over-count is not shape-neutral — and under that scoring S4 vanishes from the census entirely. The cap now accounts for the constraint (the cyclic part of the twist must be coprime to Fmid, a proven necessary condition and so usable in SAFE), and **S4 reappears at exactly the predicted residues**: all six instances over v4's current range have c ≡ 1 (mod 8). Winner counts from v3 and earlier are affected; structural columns are not.

**The engine dichotomy is a simplification, and the hybrids are where the action is.** S1 and S2 are purely multiplicative and S3, S4, S6 purely additive, but **S5 and S7 are neither** — a fused class supplying the multiplicative factor F alongside a foreign block supplying the additive one. That is not a defect of the taxonomy; it is where the two interesting phenomena live. They are also the pair most easily confused with each other, since both fuse two equal c-blocks beside a foreign block and differ only in which layer holds the swap: S5 in the top layer, which forces q = 2 and caps its efficiency at η = 1/u, and S7 in the cyclic layer, which leaves q free but cuts the twist to the odd part of c − 1 (§3.2). That difference decides their fates — S7 at F = 2 carries 10/24 of all n and S5 is an escape.

### 2.1 The multiplicative engine: density 1/F

Let n = F·c with F a power of q and c a power of p. The single fused class has intra-orbital F·C(c,2), within-class cross (F or F/2)·c² — F for odd F, F/2 for even F — and no other terms, so

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

**The two engines cover complementary sets in the sense that matters.** S1 needs n itself a prime power and S2 needs ω(n) = 2 with both factors prime powers; both are conditions of density zero, and both count O(n/log n). S3, S4 and S7 at F = 2 need only that n admit a suitable split, which is conjecturally almost always; S5 needs a split *and* a foreign prime of the special form r = 2^a·u + 1, so it sits with the thin side despite being a hybrid. So the multiplicative side is where the density is high and the supply is thin, and the additive side is the reverse.

So the asymptotic picture is entirely §3's: **S3 for even n, and S4 together with S7 at F = 2 for odd n** (splitting by c mod 8, §3.2), at the ceilings of §3.3 — with S1 and S2 thinning exceptions (§4) and S6, S7 and the escapes contributing at densities §4 measures rather than assumes.

## 3. The additive engine (S3, S4, S5, S7 at F = 2): the arithmetic conditions, family by family

The additive families need simultaneous prime and prime-power values. The systems are *parametric* in n — see §3.5, which is where that distinction is drawn and where it matters — but their **local** analysis is the standard singular-series computation, and that is what §§3.1–3.3 use. Write the singular series for a system of polynomials f₁, …, f_k with product f as

> 𝔖(f₁,…,f_k) = ∏_p (1 − ω_f(p)/p)·(1 − 1/p)^{−k},  ω_f(p) = #{a mod p : f(a) ≡ 0}.

**How this section is organised, and why.** The section answers one question — *how much density can the additive engine extract at a given n, and what has to be true of n for it to do so* — and it answers it in three passes: first derive the ceiling, then ask what it takes to reach it, then check the derivation against data. The subsections are in that order rather than by family, because the same two quantities recur across every family and it is cheaper to introduce them once.

Those two quantities are worth naming up front, since almost everything below is a statement about one of them:

- **x = c/n**, the fraction of n sitting in a single matching block. Every family's density is a min of terms that grow and shrink in x, so each has an interior optimum — its **balance point x\*** — and the value there is the family's **ceiling**.
- **η**, a foreign block's **efficiency**: the fraction of its full 2-homogeneous capacity C(r,2) that its twist can actually reach. Because Lemma B′ confines that twist to a power of the single top prime q, η is a condition on the *factorisation of the shifted prime r − 1*. This is where the number theory enters, and it is the only place it does.

The pass structure:

- **§§3.1–3.2 derive the families and their ceilings.** §3.1 does even n, which needs two parts and reaches 1/4. §3.2 does odd n, which cannot split in two and so needs three — and where the same n admits three different readings depending on whether and how the two equal blocks are fused. Most of §3.2 is spent distinguishing those readings, because they score differently and are easily conflated.
- **§3.3 turns the ceilings into a table indexed by n.** Which ceiling applies at a given n depends on two separate things: which local obstructions bite (a condition mod 12, from ℓ = 2 and ℓ = 3, and no other prime can obstruct) and which fusion rung is reachable (a further condition mod 8 at odd n). Together these give mod 24 and eight constants, of which the smallest — 0.050510 at n ≡ 23 (mod 24) — is the number §5's floor is stated against.
- **§3.4 checks that the balance point is not a cheat.** The ceilings are attained only near x\*, so the count that matters is of representations in a *window*. If that window shrank with n these would all become short-interval problems and be out of reach. It does not; the window has fixed relative width.
- **§§3.5–3.6 say what is actually being assumed.** §3.5 draws the distinction the rest of the section relies on — these are *parametric* Goldbach-type systems, not fixed Bateman–Horn ones — and states **Hypothesis (H)**, the single hypothesis everything conditional in this document rests on. §3.6 places (H) on the ladder of shifted-prime results, where it is the θ = 1 endpoint against a current unconditional 0.679.
- **§§3.7–3.9 test all of it against computation.** §3.7 asks whether representations *exist* (a cheap sieve, verified to 10⁶). §3.8 asks the much stronger question of whether the *number* of them matches the singular series, residue by residue. §3.9 asks which of the competing odd-n readings actually wins, predicts the shares, and then measures them — the one place where prediction and measurement do not yet agree.

Two throughlines are worth holding onto while reading. **The ceilings are ceilings of families, never bounds on μ(n)**: they say what a specific balanced shape guarantees, and individual n exceed them freely by the escape routes of §4.3. And **every constant in the section traces back to η**, hence to the factorisation of r − 1 — which is why a framework about permutation groups ends up depending on the distribution of shifted primes.

### 3.1 Two parts at even n (S3), and why 1/4 needs a safe prime

To reach the two-part cap the configuration needs c ≈ r ≈ n/2 with the foreign block at **full efficiency**: cap(r) = C(r,2) requires the twist to have order (r−1)/2 or r−1, and Lemma B′ forces it to be a power of the top prime q. So r − 1 = 2qᵉ or qᵉ. The clean case is **r a safe prime** — r = 2s + 1 with s prime, so q = s, e = 1 — which is why safe primes are the objects the notes keep returning to.

The representation required at even n is therefore: **n = c + r with c a prime power near n/2 and r a safe prime near n/2.** Taking the leading case c prime, this is the Bateman–Horn system

> f₁(x) = x,  f₂(x) = (x−1)/2,  f₃(x) = n − x

— r, its Sophie Germain partner, and the complementary prime — so the predicted count of representations is

> R₂(n) ~ 𝔖₃(n) · n / (2 log³ n),  with 𝔖₃(n) = ∏_{p>2} (1 − ω(p)/p)(1 − 1/p)^{−3}, ω(p) = 3 for p ∤ n(n−2) and correspondingly fewer otherwise.

The exponent is what matters: **three log factors, so ~n/log³n representations.** Existence is therefore not the binding constraint at even n where the system is locally soluble; the count grows. *Heuristic*, and unproven in every case — a ternary problem with two of the three conditions on the same variable, beyond current technology in the same way binary Goldbach is.

> **Even n carries an ℓ = 3 obstruction.** Substituting r = 2s+1, the system is {s, 2s+1, n−2s−1}, with roots mod 3 at s ≡ 0, 1 and 2(n−1). These are distinct — so ω(3) = 3 and the singular series vanishes — exactly when **n ≡ 2 (mod 3)**. Re-optimising at the reduced efficiency gives x² = (1−x)²/3, hence x = 1/(1+√3) and **cap = 1/(1+√3)² ≈ 0.13397**. So δ₀^even = 1/4 holds for n ≢ 2 (mod 3), and 0.13397 otherwise.
>
> *This is one instance of a general pattern, worked out in §3.3.* That section establishes that ℓ = 2 and ℓ = 3 are the **only** primes that can obstruct any of these systems — because each is three linear polynomials, so ω(ℓ) ≤ 3 and an obstruction needs ω(ℓ) ≥ ℓ — that no higher power of 2 or 3 obstructs either, and how the resulting conditions translate from the variable s into congruences on n. It also gives the efficiency available in each class, in terms of the factorisation r − 1 = 2^a·u, and assembles the whole ceiling table. The two conditions above are the even rows of it: n ≢ 2 (mod 3) is the ℓ = 3 condition, and even n has no ℓ = 2 condition to satisfy, which is why only two constants appear at even n against six at odd n.

### 3.2 Three parts at odd n (S4, S5 and S7 at F = 2): the family, and its ceilings

#### 3.2.1 The family, and why odd n needs three parts

Odd n cannot use a balanced two-part split: c + r odd forces one part even, and an even prime foreign part must be 2, which is useless. So the even part would have to be the p-characteristic one, i.e. c = 2^a, leaving only ~log₂n candidate splits — the route counted at O(n/log n) in §4.3.

The route that avoids it is **three parts with two equal p-characteristic blocks**: n = 2c + r with c an odd prime power and r an odd prime, all parts odd. At full efficiency, balancing x² against η(1−2x)² gives the cap **1/9 at x\* = 1/3**; the ceilings at reduced efficiency, and the rung structure that raises them, are §3.3.

#### 3.2.2 Three readings of the same n, and where the block swap lives

**Three shapes realise this family, because there are two places the block swap can live.** The two equal c-blocks may be left unfused (**S4**), or fused into one class of two — and fusion by an involution admits two distinct layer assignments, which score differently and are *different census shapes*:

> **Cyclic-layer fusion — S7 at F = 2.** F = F_mid = 2, so the swap sits in Γ₁/Γ₂ alongside the twist and the foreign translations. A cyclic group has a unique subgroup of each order, so the twist must be coprime to 2: **d is the odd part of c − 1**, and the intra term is 2·orb(c, d). The top prime q is *unconstrained*, so the foreign block's efficiency η is free.
>
> **Top-layer fusion — S5.** F = F_top = 2, which **forces q = 2**. Then F_mid = 1, nothing competes with the twist in the cyclic layer, d = c − 1, and the intra term is **2·C(c,2) for every odd prime power c**. The price is paid on the other side: with q = 2 the foreign twist must be a 2-power, so **η = 1/u** where u is the odd part of r − 1.

*The top-layer reading is Theorem 2.1.* That theorem's group is exactly this construction with the foreign block deleted, and it gives m\* = 2·C(m,2) for **every** odd prime power m, verified at m = 9 and m = 25, both ≡ 1 (mod 8). So no congruence on c can be attached to top-layer fusion, and any argument that derives one has silently assumed the swap is in the cyclic layer.

> **The gotcha.** It is natural to reason "fusing two blocks puts C₂ somewhere, and C₂ competes with the twist" and to conclude that fusion *as such* costs the 2-part of the twist. That is true of cyclic-layer fusion and false of top-layer fusion, and the two are the same picture drawn at different heights. Whenever a congruence on c appears in an argument about fusion, check which layer is being assumed.

#### 3.2.3 Why c ≡ 3 (mod 4) is the good case, and the c mod 8 law

> **Why c ≡ 3 (mod 4) is the good case: it is a statement about quadratic residues.** The c mod 8 table below is not a coincidence of the formula orb(c, d) = cd or cd/2; it is Euler's criterion. A block's intra-orbitals are the classes **±δ·T** for T the twist group, because the pairs {x, y} are unordered — the orbital of a pair depends on the difference y − x only up to sign. Take T = the quadratic residues, of index 2, and ask when ±T is all of 𝔽_c^×:
>
> > **−1 is a quadratic residue mod c exactly when c ≡ 1 (mod 4).** So at **c ≡ 3 (mod 4)** it is a non-residue, T ∩ (−T) = ∅, and **±T = T ⊔ (−T) = 𝔽_c^×** — every nonzero difference lies in one class, and the index-2 subgroup already gives a **single orbital containing all C(c,2) pairs**. At c ≡ 1 (mod 4), −1 ∈ T, so ±T = T and the same subgroup gives *two* orbitals of C(c,2)/2 each.
>
> *(Verified directly: at c = 7, 11, 19, 23, 83 the set ±QR has c − 1 elements and the orbital is exactly C(c,2); at c = 5, 13, 17, 29, 73, 137 it has (c−1)/2 and the orbital is C(c,2)/2.)*
>
> **This is the Paley graph, read from the other side.** The Paley graph is defined only for c ≡ 1 (mod 4) — precisely so that the residue relation is symmetric and gives an undirected graph on half the pairs. At c ≡ 3 (mod 4) there is no Paley graph: the residue relation is a *tournament*, and symmetrising it returns the complete graph. What is a defect for constructing an interesting graph is exactly what we want here, since we need one large orbital and not two.
>
> **And that is what frees a factor of 2 for the block swap.** Full 2-homogeneity normally costs the whole multiplicative group C_{c−1}; at c ≡ 3 (mod 4) it costs only the odd index-2 subgroup, so the factor 2 in c − 1 is never needed inside the block and is available for the cyclic layer to spend elsewhere — on F_mid = 2, i.e. on fusing the two c-blocks. That is the entire content of the rung-B condition: **the fused rung is reachable exactly when the block does not need the 2 for itself.** At c ≡ 1 (mod 8) the block needs 4 or more of the 2-part and there is nothing left to spend, which is the last row of the table below.
>
> (The characteristic-2 case is separate and degenerate: at p₀ = 2 one has −1 = 1, so ±T = T always and the halving never applies — this is the `char2` flag in the scoring code, not an instance of the above.)

**The c mod 8 law governs the cyclic-layer rung only.** Against the unfused C(c,2) at full twist, over all primes c < 20000 the comparison is exceptionless:

| c mod 8 | c − 1 | cyclic-fused intra | verdict | primes < 20000 |
|---|---|---|---|---|
| 3, 7 | 2·odd | 2·C(c,2) | **fused (S7 at F = 2) strictly better** | 570 / 565 |
| 5 | 4·odd | C(c,2) | exact tie | 569 |
| 1 | 8 \| c−1 | ≤ C(c,2)/2 | **unfused (S4) strictly better** | 556 |

#### 3.2.4 Three worked instances

**One n of each, with the terms.** The clearest way to see that these are three genuinely different shapes is to score all three readings at the same n and watch a different one win each time. Every row is n = 2c + r, and the bold entry is the value `mu_bound` records in `mu_table_safe_v4.csv`:

| n | c, r | S4 (unfused) | S7 at F = 2 (cyclic) | S5 (top) | the winning value, in full |
|---|---|---|---|---|---|
| **273** | c = 83 ≡ 3 (8)<br>r = 107, r−1 = 2·53 | 3403 — binds on **intra** C(83,2) | **5671** — binds on the **foreign** block, orb(107, 53) | 107 — binds on the **foreign** block at q = 2, orb(107, 2) | **5671 = min( 2·orb(83,41), orb(107,53) ) = min(6806, 5671)**, the other two terms being 13778 and 17762. Cyclic fusion doubles the intra term to 6806 and the foreign block then binds 17% below it — near, but not at, the balance point (x = 0.3040 against x\* = 0.29289) |
| **247** | c = 73 ≡ 1 (8)<br>r = 101, r−1 = 4·25 | **2525** — binds on the **foreign** block, orb(101, 25) | 1314 — binds on **intra**, 2·orb(73, 9) | 202 — binds on the **foreign** block at q = 2, orb(101, 4) | **2525 = min( C(73,2), orb(101,25) ) = min(2628, 2525)**, the other two being 5329 and 7373. The two live terms are within **4%** of each other, which is what being close to the balance point looks like: x = 0.2955 against x\* = 0.29289 for this row's η = 1/2 |
| **531** | c = 137 ≡ 1 (8)<br>r = 257, r−1 = 2⁸ | 9316 — binds on **intra** C(137,2) | **does not exist** — r − 1 has no odd prime factor, so the cyclic rung has no admissible q | **18632** — binds on **intra**, 2·C(137,2) | **18632 = min( 2·C(137,2), 137² ) = min(18632, 18769)**, the foreign and cross terms being 32896 and 70418. The two live terms differ by **0.7%**, but that near-tie is *structural* rather than a balance effect: a fused class always has intra = c(c−1) against within-class cross = c², so they sit a factor c/(c−1) apart at every c |

**Reading the losing entries.** The three readings share the same n, c and r and differ only in how the two c-blocks are treated, so the columns are directly comparable and the shortfalls are informative. At n = 273 the unfused reading loses by a factor 1.67 because it forgoes the doubling; the top-layer reading loses by a factor 53 because forcing q = 2 leaves the foreign block a twist of order 2 where q = 53 would give order 53. At n = 247 cyclic fusion is actively *harmful* — 1314 against the unfused 2628, a factor of 2 lost — because 8 | c − 1 cuts the twist from 72 to 9, and 2·orb(73,9) = 1314 is half of C(73,2), so the factor 2 that fusion buys does not repay the factor 4 the twist loses. At n = 531 the top-layer reading is worth exactly twice the unfused one, 18632 against 9316, since the twist is untouched and nothing else binds.

**A structural note visible in the last column.** For a fused class the within-class cross term is c² for q = 2 and 2c² for odd q, against an intra term of at most c(c−1); so at q = 2 the two are always within a factor c/(c−1) and at odd q the cross term is never within a factor 2. The consequence is that a **fused class's minimum is essentially always its intra or its foreign term**, never its within-class cross — which is why the ceiling derivations of §3.3 balance only those two.

The bold values are what `mu_table_safe_v4.csv` records, under the witnesses `p=137 q=2: 2x137 + 1x257*` and `p=83 q=53: 2x83 + 1x107*`. Note what the first one shows: its intra term is 2·C(137,2) at the **full** twist 136 with c ≡ 1 (mod 8), which is precisely what the c mod 8 law would forbid if that law applied to top-layer fusion.

#### 3.2.5 The split in the computed table

**The split is visible in the table, and it is by q rather than by c.** Over v4's `2×c + 1×r*` winners, separated by top prime:

| | winners | c mod 4 | u = odd part of r − 1 |
|---|---|---|---|
| **q odd** (cyclic-layer, S7 at F = 2) | 150 | **136 of 150 at c ≡ 3 (mod 4)**; 9 at c ≡ 5 (mod 8), the tie case; 5 at p = 2 | unrestricted |
| **q = 2** (top-layer, S5) | 24 | 9 / 7 / 5 / 3 across 7 / 5 / 3 / 1 mod 8 — **no congruence** | only **1** (×18, r = 257) and **3** (×6, r = 769) |

So S4 and the cyclic-layer fused rung are **co-carriers of the odd-n asymptotics**, each verdict holding on a quarter of all c; and S5 is a third, supply-limited route that ignores c entirely and is instead rationed by u.

*How that translates into a proportion of n is a separate question — for a given n one takes the best c available near the balance point, not a random one — and it is answered in §3.9.1.*

#### 3.2.6 Efficiency, and the count of representations

**Full efficiency is obstructed locally, and the obstructions split the ceiling by residue class.** Write **η** for a foreign block's efficiency, η = orb(r, t)/C(r,2) with t the q-part of r − 1 — the fraction of full 2-homogeneous capacity its twist reaches. (η rather than e, to keep clear of Euler's number.) Efficiency η = 1 requires the foreign twist to have order (r−1)/2, which Lemma B′ forces to be a power of q — so (r−1)/2 must be a prime power, the clean case being r a safe prime. Which n admit it, and at what efficiency, is settled in §3.3. Re-optimising δ(x) at reduced efficiency gives the other ceilings in closed form:

> at **η = 1/2**: δ(x) = min(x², 2x(1−2x), (1−2x)²/2) is maximised where x√2 = 1−2x, i.e. **x = 1/(2+√2) ≈ 0.29289**, giving **1/(2+√2)² = (2−√2)²/4 ≈ 0.08579**;
> at **η = 1/3**: **≈ 0.07180** at x ≈ 0.2679.

Where the family is locally soluble the predicted representation count is ~𝔖₃(n)·n/log³n, with

> 𝔖₃(n) = ∏_{p>2} (1 − ω(p)/p)(1 − 1/p)^{−3},  ω(p) = #{r mod p : r(r−1)(n−r) ≡ 0},

so ω(p) = 3 for p ∤ n(n−2) and smaller on the divisors, with the 2-adic and 3-adic factors as computed in §3.3. *Heuristic*, and unproven — a ternary system with two conditions on the same variable, out of reach for the same reasons as binary Goldbach.

### 3.3 Local solubility, and the ceiling by residue class (S3, S4, and the fused rungs)

#### 3.3.1 The system, and which primes can obstruct it

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

#### 3.3.2 From the local conditions to the efficiency of a foreign block

*Then why do the conditions read mod 4 and mod 3 in terms of n?* Purely the change of variable. The system lives in s, with r = 2s+1 and (for odd n) c = m − s where m = (n−1)/2. The ℓ = 2 condition is a condition on **m mod 2**, and since m = (n−1)/2 that is a condition on **n mod 4**. The ℓ = 3 condition is on m mod 3, and 2 is invertible mod 3, so it is a condition on **n mod 3**. Hence mod 12 in n, with nothing finer available *from the local analysis*. Verified empirically: representability rates computed modulo 24, 36, 48, 72 and 144 show no spread within a fixed class mod 12 beyond sampling noise. (The ceilings below are nonetheless keyed mod 24. That is not a finer local obstruction but a question of which *rung* is reachable, which is a separate condition and enters below.) The efficiency available in each class then follows from the structure of r − 1: writing r − 1 = 2^a·u with u odd and L the largest prime power dividing u, the best top prime gives

> **η = max(1/u, L/(2^{a−1}u))**, so **η = 1 exactly when either u = 1, or a = 1 and u is a prime power** — equivalently r − 1 ∈ {q^e, 2q^e}, the two cases being the **Fermat** primes (q = 2) and the **safe-prime-like** ones r − 1 = 2q^e with q odd.

The ℓ = 2 obstruction forces a ≥ 2, and hence η ≤ 1/2 **provided u > 1**; the ℓ = 3 obstruction forces 3 | u and hence η ≤ 1/3 generically, unless u is itself a power of 3; both together give η ≤ 1/6 subject to the same two provisos.

> **η = 1 has two sources, and the second is easy to miss.** The formula reads η = 1 as "u = 1, or a = 1 with u a prime power". The second disjunct is the familiar one — r a safe prime or r = 2q^e + 1 — and it is tempting to treat it as the only one and conclude that 4 | r − 1 caps η at 1/2. It does not: at u = 1 the efficiency is full for **every** a, because the whole of r − 1 is then a 2-power and q = 2 reaches all of it. These are the **Fermat** primes. In the computed table the branch produces **20 winners of shape `2×c + 257*`**, with densities from 0.09177 up to **0.16138** (n = 639) against 0.08579 for the classes they sit in — at n = 451, 459, 475, 531, 555, 559, 583, 595, 639, 651, 679, 703, 711, 715, 735, 759, 783, 795, 799, 819. `ladder_verify.py`'s `EFF` array computes η from r − 1 directly and so covers this case automatically; it is only in prose that the branch tends to get dropped.

#### 3.3.3 The ladder of rungs

**The shapes form a ladder, and each rung has its own balance point.** For odd n = (c-part) + r\*, with x = c/n:

| rung | shape | census | intra density | cap | balance point |
|---|---|---|---|---|---|
| **A** | one c-block + foreign | **S3** at odd n, needing c = 2^a | x² | η/(1+√η)² | √η/(1+√η) |
| **B** | two c-blocks fused in the **cyclic layer** + foreign | **S7 at F = 2**, needing c ≡ 3 (mod 4) | 2x² | 2η/(√2+2√η)² | √η/(√2+2√η) |
| **B′** | two c-blocks fused in the **top layer** + foreign | **S5**, forcing q = 2 and hence η = 1/u | 2x² | same as B | same as B |
| **C** | two c-classes **unfused** + foreign | **S4** | x² | η/(1+2√η)² | √η/(1+2√η) |

with **A > B = B′ > C** in every class. The cross term binds at none of the four, so each rung's optimisation is valid on its own terms and the only question is which rung is *reachable* at a given n. Behind the ladder is a change of variable. Since (√F + F√η)² = F(1 + √(Fη))², the fused cap simplifies to

> **cap_F(η) = η/(1 + √(Fη))²**,

which is the k-class formula η/(1 + k√η)² at **k = √F**. So *fusing F blocks is worth exactly √F unfused classes*: the fused rungs sit at k = √2, strictly between the one-class rung A (k = 1) and the two-class rung C (k = 2). Equivalently **cap_F(η) = cap₁(Fη)/F**, which is why one rung's value at η is exactly half the next rung's at 2η — visible in the surd column below, where rung C at η = 1/6 is (5 − 2√6)/2 and rung B at η = 1/3 is 5 − 2√6.

> **A rung is not an escape.** Rung A needs c even, hence c = 2^a — only ~log₂n choices, so its optimum is usually out of reach. It is sometimes described as the "2^a + r\* escape", which misreads it: it is the *top* rung of this ladder, not a way around the ladder, and its rarity is a supply fact rather than a structural one.

#### 3.3.4 Which rung is reachable, and why the answer is mod 24

**Reachability is a congruence on n mod 24.** Rung B — cyclic-layer fusion, where C₂ shares the cyclic layer with the twist — needs the twist on the c-blocks to be odd, i.e. **c ≡ 3 (mod 4)**. But η = 1/6 with an odd twist forces r − 1 = 12·odd, hence **r ≡ 5 (mod 8)**; with 2c ≡ 6 (mod 8) that gives **n ≡ 3 (mod 8)**. So half of each obstructed class can use rung B and half cannot, and the split is by n mod 24 rather than by n mod 12, which is all the ℓ = 2 and ℓ = 3 analysis above sees. Measured over 15,000 values per residue, it is 100% or 0% with no boundary cases.

> **Rung B′ obeys no congruence at all, and is rationed on the other side instead.** Top-layer fusion reaches 2·C(c,2) for every odd prime power c, so B′ is available at every odd n and the mod-24 argument says nothing about it. What limits it is that F_top = 2 forces q = 2, the foreign twist is then the 2-part of r − 1, and **η = 1/u** with u the odd part. Reading cap_2(1/u) = (1/u)/(1 + √(2/u))² down the odd u:
>
> | u | 1 | 3 | 5 | 7 | 9 | 11 |
> |---|---|---|---|---|---|---|
> | cap₂(1/u) | 0.17157 | 0.10102 | 0.07505 | 0.06068 | 0.05133 | **0.04468** |
>
> So B′ clears the worst class ceiling 0.050510 exactly when **u ≤ 9**, i.e. when r = 2^a·u + 1 for one of five small odd u. That is an exponential family: it supplies O(log n) candidate r per n, hence reaches O(n/log n) values of n by the counting of §4.3 — the same tier as the other escapes, and **it therefore leaves every ceiling in the table below untouched.** The observed u are 1 and 3 and nothing else: 18 winners at r = 257, 6 at r = 769 = 3·2⁸ + 1. The Fermat branch above is this rung at u = 1, which is why reading that branch as an O(1) phenomenon tied to the five known Fermat primes understates it — the family is r = 2^a·u + 1 with u a small odd prime power.

#### 3.3.5 The ceiling table

> **These are ceilings of the family, hence floors for μ — they do not bound δ(n).** The number in each row is the most the balanced shape can extract in that class, so it is exactly the δ₀ of the ladder: μ(n) ≥ δ₀·C(n,2) whenever n admits the representation. Other shapes routinely do better and are not constrained by it. A single fused class reaches 1/F and so exceeds every row here; at odd n the shape 2^a + r\* sidesteps the three-class balance entirely — n = 1015 = 512 + 503\* gives δ = 0.24534 against 0.08579 for its class. Over the computed table **91 values in class 11 (mod 12) alone exceed 0.05051, the largest being 0.20168**. Read the rows as "what this family guarantees", never as "what n can achieve".

| n mod 24 | which rung attains the cap | shape | η | **x\* = c/n** | x\* | cap, closed form | cap |
|---|---|---|---|---|---|---|---|
| 0, 4, 6, 10, 12, 16, 18, 22 | k = 1, no fusion question | S3 | 1 | **1/2** | 0.50000 | **1/4** | 0.25000 |
| 2, 8, 14, 20 | k = 1, no fusion question | S3 | 1/3 | **(√3 − 1)/2** | 0.36603 | **(2 − √3)/2** | 0.13397 |
| 1, 9, 13, 21 | **B alone** | S7 at F = 2 | 1 | **(2 − √2)/2** | 0.29289 | **3 − 2√2** | 0.17157 |
| 3, 19 | **B alone** | S7 at F = 2 | 1/2 | **1/4** | 0.25000 | **1/8** | 0.12500 |
| 5, 17 | **B alone** | S7 at F = 2 | 1/3 | **(√6 − 2)/2** | 0.22474 | **5 − 2√6** | 0.10102 |
| 7, 15 | **B ≡ C**, either or by tie | S4 or S7 at F = 2 | 1/2 (C) or 1/4 (B) | **(2 − √2)/2** at C | 0.29289 | **(3 − 2√2)/2** | 0.08579 |
| 11 | **B alone** | S7 at F = 2 | 1/6 | **(√3 − 1)/4** | 0.18301 | **(2 − √3)/4** | 0.06699 |
| **23** | **C alone**, or a tie | S4, or S7 at F = 2 by tie | 1/6 | **(√6 − 2)/2** | 0.22474 | **(5 − 2√6)/2** | 0.05051 |

> **The rung column answers "which shape realises the cap here", and the outcome allows for ties.** A tie arises whenever the *best available* c sits at **c ≡ 5 (mod 8)**, where cyclic-layer fusion gives literally the same value as not fusing (§3.2). At the nine **B alone** residues the fused rung reaches the cap and the unfused one cannot, so the fused shape is the sole winner, and the argmax always sits at c ≡ 3 or 7 (mod 8) with no ties. At **7 and 15** the two are **exactly tied**: c ≡ 3 (mod 4) forces 8 | r − 1 there, pushing the fused rung from η = 1/2 down to η = 1/4, and cap_B(1/4) = cap_C(1/2) = (3 − 2√2)/2 identically — a coincidence holding at η = 1/2 and nowhere else, so those two residues admit all three outcomes. At **23** the fused rung needs D = 24, giving η = 1/12 and a cap of 0.042020, below C's 0.050510: it cannot reach the ceiling, c ≡ 3 (mod 4) is out of contention, and the best c lies in {1, 5} mod 8 — giving S4 outright, or a tie. The tie is not the fused rung failing to appear; at c ≡ 5 (mod 8) the odd part of c − 1 is (c−1)/4, so the fused reading returns exactly C(c,2) and attains the cap too. What it never does at 23 is win strictly. The proportions follow in §3.9.1.

#### 3.3.6 Reading the balance-point column

> **x\* is the fraction of n in a *single block***, so it is what `count_check.py --centre` wants and what the balanced window of §3.4 is centred on. For a fused rung the whole class occupies F·x\*, not x\*.

> **Read the x\* column against 1/(k+1), the equal split.** They agree only at η = 1 — the even unobstructed rows, where x\* = 1/2. Everywhere else they differ, and at (C, η = 1/6) the equal split 1/3 sits **0.109 away** from x\* = 0.22474, more than twice the half-width of the standard window. Any count taken on a window centred at the equal split therefore covers a region that cannot reach the ceiling, which is why §3.8 tests each residue at its own x\*.

Every entry is a unit in ℤ[√d] over 1, 2 or 4, as it must be, since only k and η enter. The pairings are worth noticing: **3 − 2√2** at (B, 1) against **(3 − 2√2)/2** at (C, 1/2), and **5 − 2√6** at (B, 1/3) against **(5 − 2√6)/2** at (C, 1/6). That is cap_F(η) = cap₁(Fη)/F in the table.

#### 3.3.7 The global constant, and which residue attains it

Eight distinct ceilings across the 24 residues, and three of the twelve odd ones — 7, 15 and 23 mod 24 — are stuck on rung C. **The global asymptotic constant is the smallest of them: 0.050510 = (5 − 2√6)/2, attained at n ≡ 23 (mod 24) alone**, the only residue carrying both local obstructions *and* unable to reach a fused rung. That is the constant §5's floor is stated against.

#### 3.3.8 Routes above the ceiling, and how the table is validated

> **Four routes lift individual n above the ceiling for their residue**, each by supplying a block whose size is a power of a fixed small prime, so that the divisibility which kills primality is harmless:
>
> - the ℓ = 3 residues when (r−1)/2 or c is a power of 3;
> - the ℓ = 2 residues when c is a power of 2, which turns the shape into the two-part 2^a + r\*;
> - the ℓ = 2 residues when r = 2^a·u + 1 with u a small odd prime power, so that rung B′ is available at a usable η — the u = 1 (Fermat) case being the commonest, with 20 instances in range at r = 257;
> - the odd residues when a cyclic-layer-fused class of F = 3 or 5 blocks is available — the S7 route at F ≥ 3.
>
> **All four are O(n/log n) in n, and §4.3 proves it.** Each supplies O(1) usable block sizes per n, because the ceiling itself confines the block to a bounded ratio range; the remaining freedom is one prime, and that is where the log comes from. So they lift a vanishing proportion of n and leave the asymptotic constants untouched — but the proportion vanishes only logarithmically, so at any computed range they are visible rather than negligible.


> **What bounds an individual row is cap_F(η), not its class ceiling.** Against the current data, **194 of the 1,108 two- and three-class one-foreign winners exceed their own class's tabulated δ₀** — 57 via the 2^a + r\* route, 43 via the fused 2×c + r\* route, and 94 via an η above the class's generic value, mostly the 3-power escapes. In class 11 the *median* winner sits at 1.24× the tabulated cap and 28 of 39 exceed it, with a maximum of 3.99×. So δ₀ is a guarantee for one specific balanced shape and not a description of typical behaviour; "generic ceiling" is the wrong reading of it. What *is* an upper bound, and holds without exception, is cap_F(η) evaluated at the configuration's own F and η: **0 of 1,108 rows exceed it**, and over the 58 fused-class-plus-foreign winners the maximum observed is 0.16138 (n = 639), 94% of cap_2(1).

*How this is validated, and why the maximum alone would not do it.* A class maximum meeting its cap only shows the cap is **attainable**; it is met whenever some n in the class happens to have a good representation, and would go on being met even if a further condition were quietly suppressing most of the class. Two stronger checks are therefore needed, and both pass.

*Upper: no row exceeds its own cap.* Computing each winner's actual efficiency from its own foreign block and top prime, and comparing its density against cap(η) for that efficiency: over all **1,167** two- and three-part winners — 1,108 of them checkable by the automated re-derivation, which covers every unfused one-foreign row — **zero exceed it**. So δ(x) = min(x², 2x(1−kx), η(1−kx)²) bounds every individual row, not just the extremes.

*Lower: the distribution is uniform across classes.* An unmodelled obstruction acting on some residue would show as that residue failing to reach its cap, or as its bulk sitting systematically lower than its siblings'. The check must normalise by the **mod-24** cap and must **not** pre-filter by efficiency. Restricting to winners running at their class's generic efficiency is the natural-looking simplification and is exactly the filter that hides the escape rows, so a check written that way cannot detect an error in the class → η map at all — which is the one thing it is for. Over the whole table, normalised by cap(own η): every residue lands in 0.28–0.998, none exceeds 1. Normalised by the residue cap, the escapes push a minority above 1, quantified in §4.3. The per-residue δ/cap minima from `ladder_verify.py` run **0.327–0.653** at N = 20,000, which is the spread expected from representation availability alone. Note that the odd-residue end of that range moved once the script was taught the two F = 2 fused rungs: eight of the nine rung-B residues rose by 0.03–0.15 (worst odd residue 0.385 → 0.450) while **no even residue moved**, which is the control, since fusion does not arise at k = 1. Before that fix those eight were being measured against a ceiling the script structurally could not reach.

**The ℓ = 3 obstruction has an escape, reaching O(n/log n) values (§4.3).** If (r−1)/2 or c is itself a power of 3, full efficiency returns, because the divisibility that kills primality is harmless for prime powers. In range this lifts n ≡ 5 (mod 12) to a maximum of 0.10975 — but 22 of those 35 rows use the *same* foreign prime r = 487, with (r−1)/2 = 243 = 3⁵, and the others use r = 163 with 81 = 3⁴ or c = 243, 729. Candidates of the form r = 2·3^k + 1 are as thin as any other exponential family, so the escape supplies O(log n) candidates rather than n/log³n and should be read as a feature of the computed range. **The generic ceiling 0.0718 is the one to quote asymptotically.**

**Downstream.** The ceilings above are what §3.8 tests, each residue at its own x\*, and what `ladder_verify.py`'s `CAP` is keyed on.

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

#### 3.5.1 Two traditions, and which one these systems belong to

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

#### 3.5.2 How hard the parametric statement is

**How hard is the parametric statement?** Comparison with the Goldbach problems places it fairly precisely. Ternary Goldbach, n = p₁ + p₂ + p₃, is a *theorem* (Vinogradov asymptotically, Helfgott unconditionally for all odd n > 5) because it has **two** free variables and the circle method's minor arcs can be controlled. Binary Goldbach has **one** free variable and remains open. Our system has **one** free variable carrying **three** primality conditions, so per shape it demands strictly more than binary Goldbach.

Two things cut the other way. The demand is a **disjunction** over eight shapes — two block patterns × four values of d, of which each class admits one or two — and only one need succeed at each n, which is a weaker requirement than any single Goldbach-type assertion. And we do not need an asymptotic, only positivity, so a result of "almost all n" type with a small exceptional set would do, and such results *are* available for binary Goldbach: Montgomery–Vaughan and subsequently Pintz give exceptional sets of size O(x^θ) with θ well below 1, some of them effective.

**The uniformity trap.** Even granting the asymptotic for each n, deducing positivity for *all* large n needs the error term controlled uniformly in n, and that is not a free assumption: Friedlander and Granville showed that sufficiently uniform versions of Hardy–Littlewood-type conjectures are **false**. So the honest form of a hypothesis here is either "for all large n" taken as an axiom — which is what (H) below does, and which is of Goldbach difficulty — or "for all but O(x^θ) of n ≤ x", which is weaker, closer to known technology, and sufficient for a density statement about μ.

#### 3.5.3 Hypothesis (H)

**The hypothesis, stated.** Everything conditional in this document rests on one statement, which is worth writing out rather than gesturing at, since its exact shape is what §§3.3–3.4 have been determining.

> **Hypothesis (H).** Every sufficiently large n admits a prime q, a prime r and a prime power c with
>
> 1. **the shape** — n = c + r if n is even, and n = 2c + r if n is odd;
> 2. **the balance** — c/n lies in the window around n's own balance point x\*, as tabulated by residue class mod 24 in §3.3; equivalently δ ≥ (1 − ε)·δ₀(n) for a fixed ε > 0;
> 3. **the efficiency** — r = d·q + 1 with **d ∈ {2, 4, 6, 12}**, the value of d being one admissible for n's class mod 12;
> 4. **coherence** — r ∤ c − 1, so that the cyclic layer stays cyclic with the c-block at full twist.
>
> Condition 3 delivers a foreign twist of order q, hence efficiency η = 2/d; conditions 1–2 place the configuration at its class ceiling; condition 4 is Lemma C. Given all four, Part E of `enumeration-proof.md` builds an Oliver group with m\* ≥ δ₀(n)·C(n,2), which is the ladder's top rung (Proposition 5.2′ of the notes) and the asymptotic half of §5's floor conjecture.

Four things about the statement have been settled elsewhere in this document and should be read into it.

#### 3.5.4 What the four clauses rest on

*Why d runs exactly to 12.* Every permitted d is even, since q is odd and r = dq + 1 must be an odd prime, and every permitted d has all its prime factors in {2, 3}, which is what confines the local analysis to ℓ ≤ 3 (§3.3, and the leading-coefficient caveat there: a d with a larger prime factor would open a degeneration channel at that prime, as d = 6 already does at ℓ = 3 when 3 | n − 1). Writing d = 2e, the leading 2 makes r odd, the 2 in e fixes n mod 4 — through the halving in c = (n − r)/2, which is why the second factor of 2 appears only in the odd case — and the 3 in e fixes n mod 3. Hence e | 6 and **d ≤ 12**, with the admissible d by class:

| n mod 12 | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| admissible d | all | 2 | 6, 12 | 4, 12 | 2, 4 | 6 | all | 4 | 6, 12 | 2, 6 | 2, 4 | 12 |

The efficiencies η = 2/d this yields are exactly the η column of §3.3's ceiling table: d = 2 gives η = 1 at n ≡ 1, 9 (mod 12) and at the unobstructed even classes, d = 4 gives η = 1/2 at 3 and 7, d = 6 gives η = 1/3 at 5 and at the even classes 2 and 8, and d = 12 gives η = 1/6 at 11 — the two tables being the same fact read from the two ends.

Every class has at least one admissible d, so **(H) is locally soluble at every n**, and by §3.3's uniform bound its singular series is bounded below by an absolute constant rather than merely being positive. What is unproven is existence, not local solubility.

*Why the list is mod 12 while the ceilings are mod 24.* These are different questions and it is easy to conflate them. The admissible-d table above is about **local solubility** — which systems are not identically obstructed — and that is decided by ℓ = 2 and ℓ = 3, hence mod 12. The ceiling table of §3.3 is about **which rung is reachable**, an extra condition on n mod 8 at odd n, hence mod 24. (H) quantifies over the first and is stated so that condition 2 absorbs the second.

*The fused rung needs no separate clause.* At the nine rung-B residues the fused reading of the same (c, r) attains the class ceiling automatically, because c ≡ 3 (mod 4) follows from n ≡ 3 (mod 8) and r ≡ 5 (mod 8) without a fourth condition being imposed (§3.8). At residues 7 and 15 the fused rung at d = 8 ties with the unfused at d = 4, and at 23 the fused rung would need d = 24 and falls short of the unfused d = 12 — so d ∈ {2, 4, 6, 12} suffices to *attain* every ceiling, and 8 and 24 describe alternatives rather than requirements.

*(H) is not of Goldbach type alone.* n = c + r with both prime is Goldbach-like; r = dq + 1 with both prime is a Sophie Germain condition, independently twin-prime-hard. Neither implies the other and (H) demands both on the same variable. Nor is it implied by Chowla, or it by (H) — §3.6 places it as the **θ = 1 endpoint** of the shifted-prime ladder, which is a scale on which the current unconditional value is 0.679.

#### 3.5.5 What this means for the framework

**What this means for the framework.** The ladder's conditional results should be read as conditional on a *parametric* hypothesis of Goldbach type, not on Bateman–Horn. The distinction matters in two places. It explains why §3.4's window analysis is needed at all: for a fixed system one would simply count solutions up to X, whereas here the solutions live in a window proportional to n and one must check that the window does not shrink. And it explains why §6's covering formulation is the right shape — a disjunction over a finite family of parametric systems is exactly what a lower bound on μ can deliver, and is strictly weaker than any single system's solvability.

### 3.6 What the conjectures give: the shifted-prime ladder, and effectivity

**The route's strength is a single parameter.** The efficiency condition — that r − 1 carry a large prime-power divisor — is what couples this framework to the literature on shifted primes, and the coupling reduces to one exponent. Write θ for what can be guaranteed in P(r − 1) > r^θ. The foreign block then contributes qr ≥ r^{1+θ}, and with r of order n the family delivers roughly **n^{1+θ}**. Every result in this area is a value of θ:

| input on shifted primes | θ | quantifier | edge bound |
|---|---|---|---|
| Bombieri–Vinogradov | 1/4 | all large n | n^{5/4+o(1)} |
| Chowla-type | 1/2 | all large n | n^{3/2−ε} |
| Baker–Harman, positive relative density; **0.679** (Li, 2025) | 0.677 → 0.679 | **almost all** n | n^{1.677} |
| Elliott–Halberstam | → 1 | all large n | n^{2−o(1)} |

Hypothesis (H) of §3.5 above is the **θ = 1 endpoint** of this ladder. Stating it that way is more informative than calling it a barrier: it places the hypothesis on a scale with a known current value rather than in a separate category.

**The ceiling on the route is technological, not conjectural — and this distinguishes it from Chowla's 1/2.** Chowla's exponent is the value a *conjecture* buys; beating it means assuming something else. Baker–Harman's is the current output of a *method*, and the method's limit is a **level-of-distribution barrier**: results of this shape rest on Brun–Titchmarsh on average, i.e. on controlling primes in progressions to moduli beyond x^{1/2} — exactly the gap between Bombieri–Vinogradov and Elliott–Halberstam. The exponent moves whenever that control does, and it has: 0.677 became **0.679** on Maynard's triple-convolution estimates, in the lineage that took Bombieri–Friedlander–Iwaniec's x^{29/56} to Maynard's x^{11/21} and Lichtman's x^{17/32}. So θ → 1 is not a separate wish; it *is* level → 1, which is Elliott–Halberstam.

**It is the shifted-prime condition specifically that imposes this.** Binary Goldbach in the almost-all regime carries no such condition, which is why Montgomery–Vaughan settles it unconditionally with a power-saving exceptional set. Adding "and r − 1 has a large prime factor" couples the problem to primes in progressions to large moduli and puts it behind the barrier. The condition that buys the density is the same condition that caps the exponent.

> *One caveat on transferring the ladder.* θ is stated for the largest **prime** divisor of r − 1, while the efficiency η of §3.3 is built from the largest prime **power** divisor of the odd part, together with the 2-part. The two agree when r − 1 = 2q and differ otherwise, so the ladder should be checked against the prime-power version before (H) is called its endpoint without qualification.

**On effectivity.** Whichever rung is in play, the conjecture supplying it has no error term: Bateman–Horn and Hardy–Littlewood alike assert π_f(x) ~ (1/D)·𝔖(f)·∫₂^x dt/(log t)^k, a bare asymptotic with an ineffective implied constant. It says nothing about any specific n, so what is uncovered is not a middle interval that computation might close from below — it is everything above wherever the computation stops.

The conjectured square-root refinement π_f(x) = (1/D)·𝔖(f)·Li_k(x) + O_ε(x^{1/2+ε}) does not help, being the wrong shape: it bounds the *counting function up to x*, while the families need a representation at each individual n, and an exceptional n contributes O(1) to a count whose error term is a power of x. Nor is uniformity in n a free hypothesis — Friedlander and Granville showed that sufficiently uniform versions of Hardy–Littlewood-type conjectures are false outright.

**The natural next rung is an exceptional-set bound**, not because it would be better than an all-n statement — it would not — but because it is strictly weaker and is where progress on problems of this shape has historically come first. "All but O(x^θ) of n ≤ x admit a representation", for some θ < 1, is exactly the form Montgomery–Vaughan and then Pintz achieved for binary Goldbach, and results of that shape are sometimes effective. An effective one here, combined with verification up to N, would give an unconditional density statement about the ladder — which no amount of asymptotic Bateman–Horn can, at any rung.

**One consistency check worth recording.** The obstructions of §3.3 were derived there from the structure of r − 1 — which twists Lemma B′ permits. They also fall out of the singular series: 𝔖(n) vanishes precisely when ω(2) = 2 or ω(3) = 3, which is exactly n ≡ 3 (mod 4) or n ≡ 2 (mod 3). Two independent routes to the same obstructions.

### 3.7 Empirical data on the existence of representations

*The conjectural apparatus of §3.6 is asymptotic and ineffective. What §5 actually needs at each n is not that apparatus but a finite check, and the finite check is cheap. This section is what that check returns; §3.8 is the finer question of whether the **number** of representations matches prediction.*

**The quantity §5 needs is computable directly and cheaply.** At each n it is not an asymptotic count of representations but the best density the families actually achieve — a sieve computation costing O(n/log n) against the n^2.9 of computing B(n). The asymmetry is what lets the floor be verified far past the range where μ(n) is known.

> *Verified* (`ladder_verify.py`). Over every composite non-prime-power n ≤ 10⁶ — all twenty-four residues, no eligibility filter — the best density the four families achieve is at least **0.02516**, attained at n = 8927, and **no value falls below 0.02**. That is a direct verification of §5's conjecture over a range roughly 450× wider than where μ(n) itself is known.

So the picture is not "computed below, conjectural above" with an unreachable band between. What is known, and how:

| | range | status |
|---|---|---|
| μ(n) known exactly | the computed table | computed |
| collapse B_refined = B_safe certified | n ≤ 100,000 | computed from lower bounds (Part E″), at all but two values — n = 50,817 and n = 89,697 |
| global floor δ ≥ 0.02516 | n ≤ 10⁶ | computed (§5); the branch-and-bound gives the stronger δ ≥ 0.026117 over the same range |
| global floor δ ≥ 0.02 | n > 10⁶ | conjectural, ineffectively |

**Where the verification is hardest is a middle range, and it is bounded.** The lower envelope of achievable density does not fall away as n grows — it dips and then recovers. Minimum bound over the 41,584-entry worklist, by decade:

| n | entries | minimum bound | attained at |
|---|---|---|---|
| [10², 10³) | 2 | 0.03649 | 935 |
| [10³, 10⁴) | 158 | **0.02516** | 8927 |
| [10⁴, 10⁵) | 2,987 | 0.03045 | 11819 |
| [10⁵, 10⁶) | 38,437 | 0.04125 | 134423 |

and the per-block floors continue to rise thereafter — 0.04625, 0.04518, 0.04704, 0.04729, 0.04732, 0.04738, **0.04810** across the last seven blocks of 10⁵.

**The dip has a structural explanation, and it is the two engines handing over.** Below ~500 the multiplicative shapes are still plentiful — S1 at every prime power, S2 wherever ω(n) = 2 with both factors prime powers, which is 57.5% of winners below n = 400 — and they carry densities far above any additive ceiling. Above ~10⁴ the additive families have enough supply near their balance points to sit close to those ceilings. **In between, S1 and S2 have thinned but S3, S4 and the fused rung have not yet saturated**, and the escapes of §4.3 are themselves at their least helpful. Every value that has ever set a running floor lies in this band: 575, 935, 2183, 2291, 2303, 3059, 3239, 3479, 8927.

So the uncovered region is not open-ended. It is a *finite* interval, roughly [500, 10⁴], where verification is most needed and has been done exhaustively — and above it the empirical trend runs toward the ceilings rather than away.

### 3.8 Empirical data on the density of representations: the prediction tested by counting

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

*The extra congruence the fused rung needs is automatic.* Rung B — the cyclic-layer one, S7 at F = 2 — requires c ≡ 3 (mod 4). (Rung B′, S5 proper, requires no congruence on c and is not what this paragraph is about; see the box in §3.3.) For n ≡ 11 (mod 24), r = Dq + 1 with q odd gives r ≡ 5 (mod 8), and n ≡ 3 (mod 8) then forces c = (n − r)/2 ≡ 3 (mod 4). No fourth condition has to be imposed — which is also why the mod-24 split coincides exactly with the split between rungs.

> **A local obstruction indexed by the twist prime.** Distinct from the above. In the weaker system c prime, r = n − 2c prime, r ≡ 1 (mod q), the congruence pins c to the single class (n−1)/2 (mod q); when that class is 0 the family is empty, since q | c forces c = q. It fires for one n in q. Verified: observed count 0 at every such n. It belongs in §3.3's inventory alongside ℓ = 2 and ℓ = 3, being an obstruction indexed by the twist prime rather than by a fixed small prime.
>
> *It cannot obstruct the family, and that is a triviality rather than an observation.* Read the condition the other way round: at a fixed n the degenerate q are exactly the **prime divisors of (n−1)/2**, of which there are ω((n−1)/2) ≤ log₂ n — measured over odd n ∈ [10⁴, 4·10⁴], mean 2.56 and maximum 5. Every other prime is non-degenerate, so the obstruction removes O(log n) candidates from an unbounded supply. What is *not* settled by that is whether some non-degenerate q also has supply near the balance point and an efficiency worth having; that is the parametric question of §3.5 and Hypothesis (H), not a separate obstruction.

**What this establishes.** The local analysis and the singular series are confirmed at every residue mod 24, in both families, each at the balance point its own ceiling is derived from — the count matches, and the vanishing predictions vanish. It says nothing about §3.5's global question, whether solutions exist for *every* large n, which is where the conjecture lives. What it removes is the possibility that the constants are right but the model is wrong.

### 3.9 Which of S4 and the fused rung wins: prediction, and measurement

*The competition here is between **S4** and **S7 at F = 2** — the unfused and cyclic-layer-fused readings of the same n = 2c + r. S5 is not a party to it: top-layer fusion obeys no congruence on c, so it does not sort by the c mod 8 law the shares below are built on, and it is supply-limited to r = 2^a·u + 1 with u small (§3.3). It contributes O(n/log n) values, which is why it takes no share of the limit and appears here only in §3.9.2's account of the finite-range discrepancy.*

#### 3.9.1 The predicted shares

*The two shapes of §3.2 have overlapping ceilings, so the question of which realises the family at a given n is not settled by the ceiling table. It is settled — asymptotically — by the relative supply of the three underlying systems, which is a singular-series computation of the same kind as §§3.1–3.3.*

##### 3.9.1.1 The three systems, and why their singular series agree

**The predicted shares, from the singular series.** The three outcomes correspond to three systems, distinguished by the class of c and hence by the condition on r:

| outcome | c mod 8 | system | ceiling |
|---|---|---|---|
| S4 wins | 1 | q, Dq+1, (n−r)/2 all prime, D = 4 (res 7, 15) or 12 (res 23) | 0.085786 / 0.050510 |
| tie | 5 | same system | same |
| fused rung wins | 3, 7 | same with **D doubled** — 8 or 24 — since c ≡ 3 (mod 4) forces 8 \| r − 1 | 0.085786 / **0.042020** |

Three facts settle the split. **The two singular series agree**: computed over n in a test band, 𝔖(D) and 𝔖(2D) match to four decimals at all three residues, since the systems differ only in a coefficient and ω(ℓ) = 3 generically for both. **The log factors agree** to within a percent, since the balance points differ but the arguments are all Θ(n). And **c mod 8 is decided by q mod 4** — from c = (n−1)/2 − (D/2)q with q odd — so the D-system's solutions split 1:1 between c ≡ 1 and c ≡ 5, i.e. between S4-wins and ties, by Dirichlet.

**The singular series agree exactly, not approximately.** For our two pairs — D = 4 against 8 at residues 7 and 15, and D = 12 against 24 at residue 23 — the local factors are *identical at every prime*. The reason is structural rather than numerical: ω(ℓ) < 3 requires two of the roots {0, −D⁻¹, h·(D/2)⁻¹} to collide, and the two collision conditions are **h ≡ 0** and **h ≡ −1/2 (mod ℓ)**, neither of which mentions D. At the primes dividing D the two systems degenerate the same way. Checked at every ℓ < 500 over a band of n: zero mismatches.

##### 3.9.1.2 The log factors, and how firm the 1 : 1 : 2 limit is

**The log factors do not agree, and that is where the split departs from 1 : 1 : 2.** The two systems balance at different points — x\* = 0.29289 for the D-system, 0.20711 for the 2D-system — so the arguments of the three logs differ:

| n | A+B share | C share | C/(A+B) |
|---|---|---|---|
| 10⁵ | 0.4899 | 0.5101 | 1.0412 |
| 10⁶ | 0.4920 | 0.5080 | 1.0325 |
| 10⁹ | 0.4951 | 0.5049 | 1.0198 |
| 10¹² | 0.4965 | 0.5035 | 1.0142 |
| 10²⁰ | 0.4980 | 0.5020 | 1.0081 |

So **1 : 1 : 2 is the limit the heuristic predicts, not the value at any finite n**: the fused class is favoured by a factor 1 + O(1/log n), about 4% at 10⁵ and 3% at 10⁶. The correction is well inside the sampling noise of anything measurable at present, which is why the table below quotes the limiting fractions.

> **How firm is the limit? Less firm than the constants elsewhere in §3, and for a reason worth stating.** Reaching 1 : 1 : 2 takes two steps beyond the singular-series computation. First, that each class's supply near the balance point is given by its Bateman–Horn count; second, that the *argmax* over classes therefore lands in a class with probability equal to that class's share of the pool. The second step is an extreme-value claim about which class happens to supply the candidate closest to x\*, not a claim about counts, and it is the one carrying the weight.
>
> The competing rates are these. The deterministic bias between the two systems is the log-factor ratio above, of relative size **Θ(1/log n)**. The stochastic fluctuation in each class's count over a window of length Θ(n) is relative size **O(log^{3/2}n/√n)**, which vanishes far faster — so *if* the Bateman–Horn count is accurate to relative error o(1/log n), the bias dominates the noise, the argmax probabilities converge, and the limit is as stated. The trouble is that **the neglected secondary term in the Bateman–Horn asymptotic is itself of relative order 1/log n** — the same order as the effect being predicted. Much of it cancels between the two systems, which share their functional form, but not all: they have different d and different balance points, so their secondary terms differ, and the surviving difference is not known to be smaller than the bias it would perturb. It could shift the constant in the drift or, in principle, its sign.
>
> So the honest statement is that **1 : 1 : 2 is what the heuristic gives when read at leading order, and is well converged in that reading, but the convergence rate and the accuracy of the model are of the same order and no argument here separates them.** Nor can computation: an effect of size 1/log n moves from 10% to 7% between 10⁵ and 10⁶, so the ranges reachable at present cannot distinguish 1 : 1 : 2 from a nearby limit, or from no limit at all. This is a softer claim than the ceiling constants of §3.3, which are exact algebraic numbers derived from a balance condition, or the local-solubility classification of §3.3, which is a finite computation. It is a drift that is one-signed and slow *under the model*, and the model's own error at that order has not been controlled.

##### 3.9.1.3 The predicted shares, by residue

**Predicted outcome shares, by residue.**

| n mod 24 | rung situation | S7 at F = 2 | S4 | tie |
|---|---|---|---|---|
| 1, 3, 5, 9, 11, 13, 17, 19, 21 | B alone | **100%** | 0% | 0% |
| 7 | B ≡ C | **50%** | 25% | 25% |
| 15 | B ≡ C | **50%** | 25% | 25% |
| 23 | C alone | 0% | **50%** | **50%** |
| **all odd n** | | **83.3%** | **8.3%** | **8.3%** |

At the nine B-alone residues the fused rung has a strictly higher cap, so the argmax always lies at c ≡ 3 or 7 (mod 8). At 7 and 15 the caps coincide and all three c-classes compete, splitting 1 : 1 : 2 as derived above. At 23 the fused rung cannot reach the cap, so only c ≡ 1 and c ≡ 5 (mod 8) are in play — S4 and ties, evenly. Over all n, halving for the even residues:

> **S7 at F = 2 → 9/24 + 1/24 = 10/24 ≈ 41.7% outright; S4 → 1/24 ≈ 4.2%; tied → 1/24 ≈ 4.2%**, with S3 taking the even 12/24. The four sum to 1.

##### 3.9.1.4 Row by row

**Row by row.** Each residue's row is fixed by two congruences: which c-classes can supply a solution at all, and which rung each of those classes lands on. Both follow from c = (n − 1)/2 − (D/2)q with q odd.

*The nine **B alone** residues — 1, 3, 5, 9, 11, 13, 17, 19, 21.* Here n ≡ 3 (mod 8), so c ≡ 3 (mod 4) is reachable: 2c ≡ 6 (mod 8) and r ≡ n − 6 ≡ 5 (mod 8), which is exactly the r − 1 = D·odd the residue's own η needs. The fused rung therefore attains the cap while the unfused one, at the same η, sits a factor cap_C/cap_B below it. Any c ≡ 3 or 7 (mod 8) solution thus beats every c ≡ 1 or 5 one, and the argmax lands there whenever such a solution exists near the balance point — which it does, since these classes are a positive proportion of primes. **Fused rung only: 100 / 0 / 0.**

*Residues 7 and 15.* These are n ≡ 7 (mod 8), where c ≡ 3 (mod 4) forces r ≡ 1 (mod 8), hence 8 | r − 1, hence 8 | D — pushing the fused rung from η = 1/2 down to η = 1/4. That would normally lose, but cap_B(1/4) = cap_C(1/2) = (3 − 2√2)/2 exactly, a coincidence holding at η = 1/2 and nowhere else. So all four c-classes reach the same ceiling and compete on supply alone. Among them, c ≡ 3 and c ≡ 7 (mod 8) give the fused rung, c ≡ 1 gives S4, and c ≡ 5 gives a tie, since there the odd part of c − 1 is (c−1)/4 and fusing returns exactly C(c,2). Those are two classes, one and one. **fused / S4 / tie = 50 / 25 / 25.**

*Residue 23.* Also n ≡ 7 (mod 8), so c ≡ 3 (mod 4) again forces 8 | D — but here the mod-3 obstruction already caps η at 1/6, so the fused rung needs D = 24, giving η = 1/12 and a cap of 0.042020 against the unfused 0.050510. It cannot reach the ceiling, and c ≡ 3, 7 (mod 8) is out of contention entirely. That leaves c ≡ 1 and c ≡ 5 (mod 8), which by the same c = (n−1)/2 − (D/2)q bookkeeping are equinumerous — selected by q mod 4. The first gives S4 outright; the second gives a tie, because there the odd part of c − 1 is (c−1)/4 and the fused reading returns exactly C(c,2). So the fused rung does attain the cap at half the values; what it never does at this residue is win strictly. **fused / S4 / tie = 0 / 50 / 50**, reading the first column as *strict* wins.

*The even residues* have k = 1 and one block, so no fusion question arises and no row is needed.

> **S7 at F = 2 → 9/24 + 1/24 = 10/24 ≈ 41.7% outright; S4 → 1/24 ≈ 4.2%; tied → 1/24 ≈ 4.2%**, with S3 taking the even 12/24. The four sum to 1.

#### 3.9.2 The observed split, and why it does not yet match

*§3.9.1 predicts 100/0/0 at nine residues, 50/25/25 at two, and 0/50/50 at one. This sub-section reports what the computed range actually shows, in the same fused / S4 / tie order, and accounts for the difference.*

##### 3.9.2.1 The observed split

**The observed split, by residue.** Measured over odd n in [2×10⁵, 2.06×10⁵], in the same fused / S4 / tie order as §3.9.1's prediction:

| n mod 24 | fused rung wins | S4 wins | tie |
|---|---|---|---|
| 1, 3, 5, 9, 11, 13, 17, 19, 21 | **100%** | 0% | 0% |
| 7 | 24.0% | 24.8% | 51.2% |
| 15 | 26.8% | 18.8% | 54.4% |
| 23 | 0% | 44.0% | 56.0% |
| **all odd n** | **79.2%** | **7.3%** | **13.5%** |

**The nine rung-B residues match exactly**, at 100 / 0 / 0 — no surprise, since there the prediction rests on a congruence rather than on supply, and congruences do not wait for n to grow.

**Residue 23 matches on the fused rung and misses on the other two**: predicted 0 / 50 / 50, observed 0 / 44.0 / 56.0. The zero is congruence-forced and exact; the 44 / 56 against 50 / 50 is a modest excess of ties.

**Residues 7 and 15 match on S4 and transpose the other two**: predicted 50 / 25 / 25, observed 24.0 / 24.8 / 51.2 and 26.8 / 18.8 / 54.4. **The S4 share is already right** — 24.8 and 18.8 against 25 — while the fused-rung share and the ties are swapped, ties running near 50% where fused wins were predicted to. (These figures predate the per-residue window convention; the layer-separated rescan below, taken at each residue's own x\*, gives the same qualitative picture with the transposition larger still.)

##### 3.9.2.2 Separating the two fused rungs

**The table above does not separate the two fused rungs.** Its columns were taken by asking whether the winner fuses its two c-blocks, not by asking *which layer* the swap sits in — so a top-layer win (S5) is scored as a fused win, and a top-layer configuration equalling the unfused value is scored as a tie. Those are different shapes with different laws, and only S7 at F = 2 is a party to §3.9.1's prediction. Rescanning the same band with the three readings scored separately (`rung_split.py`), taking each residue's window as **its own balance point ± 0.05** — `count_check.py`'s convention, and the right one here, since §3.9.1's prediction is about configurations *at the class ceiling*:

| n mod 24 | S7 at F = 2 wins | S4 wins | S5 wins | tie | values |
|---|---|---|---|---|---|
| 1, 3, 5, 9, 11, 13, 17, 19, 21 | **100.0%** | 0.0% | 0.0% | 0.0% | 1887 |
| 7 | 8.7% | 31.1% | **0.0%** | 60.2% | 196 |
| 15 | 0.0% | 31.6% | **0.0%** | 68.4% | 250 |
| 23 | **0.0%** | 43.2% | **0.0%** | 56.8% | 185 |
| **all odd n** | **75.6%** | **8.7%** | **0.0%** | **15.6%** | 2518 |

> **The window convention is not a detail.** Run flat — a single c/n window [0.10, 0.42] shared by every residue — the same scan gives 33.2 / 20.9 / 0 / 45.9 at residue 7 and **7.6%** fused wins at residue 23, where §3.9.1 argues the fused rung can never win strictly. Those extra wins are an artefact: a flat window reaches c/n ratios that no residue's ceiling is derived at, admitting configurations well away from the balance point, and at residue 23 it lets in c ≡ 3 (mod 8) escapes that the ceiling comparison does not govern. With each residue scanned at its own x\* the 7.6% goes to **0.0%, exactly as predicted**. Any measurement in this section that is not taken at the per-residue balance point is measuring a different question.

**S5 never wins outright anywhere in the band**, which is the expected consequence of its being supply-limited to r = 2^a·u + 1 with u small — at n ≈ 2×10⁵ that family is too thin to supply the *best* configuration at any value. So the conflation is not inflating the fused column.

**It is inflating the tie column, and by a measurable amount.** Asking how often each reading merely *belongs* to the argmax set rather than owning it:

| n mod 24 | S7 at F = 2 | S4 | S5 |
|---|---|---|---|
| 1, 3, 5, 9, 11, 13, 17, 19, 21 | 100.0% | 0.0% | 0.0% |
| 7 | 45.4% | 91.3% | **23.5%** |
| 15 | 38.0% | 100.0% | **30.4%** |
| 23 | 56.8% | 100.0% | **0.0%** |

So at residues 7 and 15, S5 is among the joint winners at a quarter to a third of values — it reaches the same score without ever exceeding it, which is exactly how a shape whose binding term is the foreign block behaves under a change of fusion layer. That is a real contribution to the excess ties at those two residues. **It contributes nothing at residue 23**, where S5 is never in the argmax at all, so the excess ties there need a different explanation — which the next box supplies.

> **Residue 23 now matches the prediction closely.** Predicted 0 / 50 / 50 for fused / S4 / tie; observed **0.0 / 43.2 / 56.8**. The zero is exact and congruence-forced, and the 43 / 57 against 50 / 50 is the same modest excess of ties seen elsewhere. Residues 7 and 15 are where the gap remains, and it is entirely in the tie column: predicted 50 / 25 / 25, observed 8.7 / 31.1 / 60.2 and 0.0 / 31.6 / 68.4, with S4's share already near its predicted 25.

##### 3.9.2.3 The excess ties

Beyond the layer conflation the excess ties have a further cause, and it is one the model itself accounts for.

> **The excess ties are escapes, not the balanced family.** A tie means the fused and unfused readings return the same *value*, which happens whenever the winning configuration's binding term is one that fusion does not touch — and note that this is the same mechanism by which an S5 configuration registers as a tie, since fusing in the top layer also leaves a binding foreign term unchanged. Diagnosed over tied n at residue 7: the binding term is the **foreign block** in 43 of 65 cases and the intra term in 22 — and the winning configurations sit at a median of **1.21× the residue's ceiling**, so at these sizes they are escape configurations (§4.3) rather than the balanced family. Fusing changes only the intra term, so wherever an escape wins on its foreign block the two readings agree identically. Consistently, at 23 mod 24 — where escapes are weaker — the tied values sit *at* the ceiling (median 0.989×) rather than above it.

##### 3.9.2.4 Why the computed range cannot settle it

> **Why the computed range does not yet show the predicted split.** The prediction above assumes the winner is drawn from the pool of near-optimal candidates in proportion to each class's supply. Two things have to happen for that to be the operative regime, and both are asymptotic. The escape-driven ties **thin at O(n/log n)** (§4.3), so eventually the outcome at every n is decided by the balanced family alone. And within that family the candidate count near the balance point grows like n/log³n, so every class becomes dense enough that its best candidate is essentially *at* the ceiling — at which point choosing the maximum is effectively drawing from the pool, and the probability the argmax lands in a class tends to that class's share of the pool. So the outcome split **should converge to the singular-series proportions**, with a residual tie fraction converging to the c ≡ 5 (mod 8) share rather than to zero, since fused and unfused give literally the same value there. *Should*, under the model — and per the box in §3.9.1 the model's own error is of the same 1/log n order as the drift it predicts, so "the split converges to 1 : 1 : 2" is a prediction of the heuristic read at leading order rather than a consequence of it.
>
> The computed range is too small for either. The observed figures do not move monotonically across bands (28.0/26.4/45.6 at 2×10⁴, 23.5/50.0/26.5 at 2×10⁵, 32.7/41.3/26.0 at 10⁶), and those bands hold only 100–250 values apiece. A drift of order 1/log n falls from about 10% to 7% across that range, well inside the sampling noise. **The measurement is underpowered by roughly an order of magnitude, not in tension with the model** — and would remain so at any range reachable by computation, since an effect of relative size 1/log n cannot be separated from a nearby limit by data at 10⁶. Settling it wants the predicted class shares computed directly from the three singular series — which differ by the condition on r, not only by the density of c — against a single band of a few thousand values, **with the winners classified by top prime** so that S5 is excluded rather than folded into the tie column — the split above shows that correction is worth 23–30% of the values at residues 7 and 15 and nothing at 23.
>
> *Does Friedlander–Granville threaten this?* Their result defeats strong uniformity for primes in progressions to moduli growing almost as fast as x, so it is the right thing to worry about whenever a heuristic leans on equidistribution across many classes at once. It does not bite here: **every modulus in play is bounded** — 8 and 24 for the residue bookkeeping, D ≤ 24 for the efficiency condition — and the windows have length Θ(n), so what is being assumed is equidistribution in a *fixed* finite set of classes over a long interval, which is a far weaker demand than anything their construction disturbs. The genuinely non-trivial assumption is elsewhere and is §3.5's: that the Bateman–Horn count holds **uniformly in n** as the singular series varies with n, rather than pointwise for each fixed system. That is where the conjectural weight sits, and no amount of bounded-modulus equidistribution supplies it.

## 4. The remaining configurations (S1, S2, S6–S10, and the escapes): what survives asymptotically

*§3 handles the configurations that carry the asymptotics — S3 for even n, and **S4 together with S7 at F = 2** for odd n, which split the range by a congruence on c. This section covers everything else in the census, and the subsections are numbered to the three fates: **§4.1** fate (i), S1 and S2, the multiplicative engine, which thins; **§4.2** fate (ii), S6, present but supply-limited; **§4.3** fate (iii), S5, S7 at F ≥ 3, and the escape routes, which reach only O(n/log n) values. **§4.4** collects what is excluded by theorem, and **§4.5** draws the conclusion.*

> **Three fates, and they are different.** A configuration can (i) require a condition on n of density zero, so it *thins*; (ii) remain available at a positive density of n but be beaten by a better shape, so it *stops winning*; or (iii) remain available while reaching only a vanishing proportion of n. The distinction matters because (i) and (iii) both remove a shape from the asymptotic picture while (ii) does not, and because a fate-(iii) shape can still be conspicuous at computed sizes when the vanishing is only logarithmic — which §4.3 shows is the case for all four escapes.

### 4.1 The multiplicative engine (S1 and S2): fate (i), it thins

*Both shapes of the multiplicative engine live or die on the same condition. A fused class needs n = F·c with F and c both prime powers, i.e. **ω(n) ≤ 2**, and the two values of ω split the engine in two: ω(n) = 1 is **S1**, the trivial case at δ = 1, and ω(n) = 2 is **S2**, the fused family proper. Both thin, S1 the faster.*

ω(n) ≤ 2 is a **density-zero condition**. The count of n ≤ N with exactly two distinct prime factors is ~N log log N / log N; the prime powers are smaller still, at **π(N) + O(√N) = O(N/log N)**. So S1 vanishes fastest, S2 next, and neither survives into the asymptotic picture.

**S1 is the cleanest instance of fate (i), and the most extreme.** At n = p^a the group AGL(1, n) is 2-transitive, so μ(n) = C(n,2) and δ = 1 — the maximum possible density, achieved on a set of density zero. It is kept in the census for the same reason one keeps the trivial group: the degenerate member of the family, not an exception to it. Its O(N/log N) count is, incidentally, the same order as the escapes of §4.3, though for a far more elementary reason. The tables skip prime powers because the answer is known, not because μ is undefined there.

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

### 4.2 S6: available at almost every even n, and dominated at all of them

**S6 — two outside blocks and no matching class.** Both parts are foreign primes, so n = r₁ + r₂ with r₁ ≠ r₂ odd primes: **S6 lives only at even n**, and it exists there whenever n has a Goldbach representation, i.e. conjecturally always. Its problem is never availability. Write the value with x = r₁/n and η_i the efficiency of each block:

> δ(x) = min( η₁x², η₂(1−x)², 2x(1−x) ),  maximised where x√η₁ = (1−x)√η₂.

**The efficiencies are a pair of integers, and the cap is a clean closed form.** A single top prime q serves both blocks, so writing **r_i − 1 = 2·q^{a_i}·m_i with gcd(m_i, q) = 1**, the usable twist is q^{a_i} and

> **η_i = 1/m_i**,  hence  **cap_{S6}(m₁, m₂) = 1/(√m₁ + √m₂)²**.

*(Verified against a direct optimisation and against the definition η = orb(r, t)/C(r,2) at every r = 2q^a m + 1 with q ≤ 7, a ≤ 2, m ≤ 5.)* The formula reads off the whole ladder: 1/4 at (1,1), 3 − 2√2 = 0.17157 at (1,2), (2 − √3)/2 = 0.13397 at (1,3), 1/8 at (2,2), 1/9 at (1,4).

**The ceiling 1/4 is unreachable except on a set of size O(N^{1/3}).** It needs m₁ = m₂ = 1, i.e. r_i = 2q^{a_i} + 1; and the two foreign primes must be **distinct**, which then forces a₁ ≠ a₂. So the ceiling requires

> n = 2(q^a + q^b) + 2,  a < b,  with q, 2q^a + 1 and 2q^b + 1 all prime.

That is a Bateman–Horn system with a nonlinear form, and most of its members are locally dead. Computing ω(3) directly over all a < b ≤ 6: **every pair is obstructed at ℓ = 3 except (1,3), (1,5) and (3,5)** — in particular the leading case (1,2), which carries the bulk of the count, has ω(3) = 3 and admits only q = 3, giving the single value n = 26. The surviving pairs all have b ≥ 3, so q ≤ (N/2)^{1/3} and the count of n ≤ N reaching the ceiling is

> **O(N^{1/3}/log N)** — thinner than every other shape in the census by a power of N, not merely by a logarithm.

**One rung down is obstructed too.** The next cap, 3 − 2√2 = 0.17157 at m = (1,2), is the family q, 2q + 1, 4q + 1 with n = 6q + 2. It also has **ω(3) = 3** and also admits only q = 3, giving n = 20. So the two configurations that would let S6 compete are both killed by the same local obstruction rather than by scarcity.

**What survives is dominated.** The best unobstructed family with a full Hardy–Littlewood supply is m = (1,3) — q, 2q + 1, 6q + 1, with n = 8q + 2 — at cap **(2 − √3)/2 = 0.13397**, reached at O(N/log N) values. But n = 8q + 2 ≡ 2q + 2 (mod 3), which is ≡ 2 (mod 3) only when q = 3, so at every other member of the family **S3 is unobstructed and has cap 1/4**. S6's plentiful regime therefore sits exactly where its competitor is strongest, and its cap there is barely half of S3's.

> **So S6's fate is (ii), and more sharply than for any other shape.** It is available at essentially every even n, its ceiling equals S3's at 1/4, and yet it is beaten everywhere: the configurations that would reach 1/4 or 0.17157 are locally obstructed down to one value of n each, and the configurations that are plentiful cap at 0.13397 in a regime where S3 reaches 1/4. **The winning set is plausibly finite**, which is a stronger statement than the "fate (ii) tending to (i)" this section previously offered, and it is a statement about local obstructions rather than about supply.

> *Verified over the computed range.* Scanning every even n ≤ 1428 for the best two-foreign configuration: **703 values admit one, and none attains B(n)**. The maximum density reached is **0.11104** (n = 56, r = 19 + 37 at q = 3), against that n's B(n) = 203 — a ratio of 0.842, the closest S6 comes anywhere. The next best are n = 20 and n = 12, which are exactly the two locally-surviving members of the obstructed families above. *(This supersedes the earlier report of one S6 winner at n = 1175; under the corrected shape space that n is won by `1x619* + 4x139`. See `pending-checks.md` A7.)*

### 4.3 The escapes: O(n/log n), and why the log is the whole story

*§3.3 lists four routes by which an individual n exceeds its residue's ceiling. Each supplies a block whose size is a power of a fixed small prime; this section counts how many n they reach.*

*Throughout this section the counts are of **effectiveness** — the n at which a route lifts the value above its residue's ceiling — not of availability. For several of these shapes the two differ by a positive density; the closing paragraph on Romanov and Erdős is where that distinction is made precise.*

*Three of them are routes **within** families rather than families of their own, which is why they have no S-number; the fourth is S5, which is a census shape but is effective on the same kind of thin set and is counted with them:*

| route | the family it sits inside |
|---|---|
| c a power of 2, giving the two-part 2^a + r\* | **S3** at odd n |
| (r − 1)/2 or c a power of 3 | **S4 / S7 at F = 2** |
| r = 2^a·u + 1 with u a small odd prime power, the u = 1 case being a Fermat prime | **S5** — the whole shape, not a route inside it |
| a cyclic-layer-fused class of F = 3 or 5 blocks | **S7 at F ≥ 3** |

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

The same argument covers the other three routes verbatim — powers of 3 instead of 2 (at most two in a ratio-3.45 window, at most one once the ceiling exceeds 0.086), and for the S5 route the block r = 2^a·u + 1 is pinned to a power of 2 times one of five small u, so the same geometric-sequence count applies with a constant factor of five. **So every escape reaches a vanishing proportion of n, and the asymptotic constants of §5 stand.**

**But the vanishing is logarithmic, which is why they are conspicuous at computed sizes.** Measured against the mod-24 ceilings, the fraction of odd n whose ceiling the route exceeds:

| n ≈ | 1.3×10⁴ | 1.0×10⁵ | 1.0×10⁶ |
|---|---|---|---|
| 2-power route | 3.73% | 2.20% | 1.20% |
| 3-power route | 2.48% | 1.00% | 0.00% |

Both fall, consistent with the O(1/log n) bound and if anything faster — the 3-power route is already empty by 10⁶, since once a residue's ceiling exceeds 0.086 its window admits at most one power of 3 and usually none.

**Availability and effectiveness are different quantities, and only the second thins.** A route being *available* — some 2^a + r\* representation existing at all — is a much weaker condition than its reaching the ceiling, and it does not thin: Romanov (1934) gives {2^k + p} positive lower density, and Erdős (1950) gives a positive density of odd n with no such representation, so availability sits at 86–99% of odd n and stays there, bounded away from both 0 and 1 with the limiting density itself unsettled. What the count above measures is effectiveness, and that is what the ceiling analysis needs.

*This is the source of the census's one existence/winning gap of positive density.* The 2^a + r\* route is S3 at odd n, so S3 **exists** on all even n plus a positive proportion of odd n, while **winning** on the even 12/24 alone — the odd instances are available almost everywhere and effective almost nowhere. Every other gap in that column is a difference of rate rather than of density.

**None of this moves §5's floor**, and the reason is general: every escape *raises* δ(n), a floor is a minimum over n, so a route lifting some values above their ceiling cannot lower it however common it is. What the escapes change is the reading of the ceiling table — δ₀ is what the *balanced* shape guarantees at that residue, not a bound on what any shape achieves there.

### 4.4 What is left over

**S8, S9, S10** are excluded by theorem, not by rarity — D1, D2, and the normality argument respectively. They cannot occur at any n, so they have no asymptotics.

**S7 at F ≥ 3** is an escape rather than a carrier, and §4.3 counts it with the other routes at O(n/log n). Its parity structure is what restricts it: at odd n, F·c even with F odd forces c to be a power of 2, leaving O(log n) choices per n. **S7 at F = 2 is a different matter entirely** — it is the odd-n fused rung and carries 10/24 of all n; it is listed under §4.5's live shares, not here.

**S5** is a census shape but behaves as an escape, for a reason on the other side of the configuration: top-layer fusion forces q = 2, so the foreign efficiency is 1/u with u the odd part of r − 1, and reaching a useful η needs r = 2^a·u + 1 with u small. That is an exponential family, O(log n) candidates per n, hence O(n/log n) values — §3.3 and §4.3.

### 4.5 The asymptotic question is entirely Hardy–Littlewood

**Summary of the fates.**

| shape | fate | evidence |
|---|---|---|
| S1 | **(i)** thins | prime powers are O(N/log N); δ = 1 there, known exactly — §4.1 |
| S2 | **(i)** thins | ω(n) = 2 with both factors prime powers has density 0 — §4.1 |
| S3 | carries even n — **12/24** | §3.1; the counting check of §3.8 |
| S4 | co-carries odd n — **1/24** outright, 1/24 tied with S7 at F = 2, only at 7, 15, 23 mod 24 | §3.2, §3.9 |
| **S7 at F = 2** | carries odd n — **10/24** outright, sole winner at the nine rung-B residues | §3.2, §3.9 |
| S5 | **(ii)**: available at essentially every odd n, beaten almost everywhere. q = 2 pins η = 1/u, so clearing the ceiling needs r = 2^a·u + 1 with u small — effective at O(n/log n) values | §3.3, §4.3 |
| S6 | **(ii)**, with a plausibly *finite* winning set | available at essentially every even n and beaten at all of them; its two competitive rungs are obstructed at ℓ = 3, not scarce; **0 winners in range** — §4.2 |
| S7 at F ≥ 3 | **(iii)** at odd n, where c is forced to a power of 2; **(ii)** at even n, where the supply matches S3's but its 0.13397 ceiling loses to S3's 1/4 | §4.3, §4.4 |
| the escape routes | **(iii)**: effective at a vanishing but only logarithmically thinning proportion | all four routes measured — §4.3 |
| S8, S9, S10 | cannot occur | excluded by D1, D2, normality |

The four live shares sum to 1: 12/24 to S3, 10/24 to S7 at F = 2, 1/24 to S4 outright and 1/24 tied between them. S5, S7 at F ≥ 3 and the escape routes take no share of the limit. Note that for the first two this is a matter of being **beaten**, not of being absent: both are available at a positive density of n — S5 at essentially every odd n, S7 at F ≥ 3 at essentially every even one — and it is their ceilings that lose. Only the O(n/log n) subset where they clear their residue's ceiling shows up at all.

Since the multiplicative engine vanishes in density, the asymptotic behaviour of μ(n) for almost all n is set by the additive families, whose ceilings are the mod-24 table of §3.3 and whose availability is a Bateman–Horn question. In particular the ladder constants of §5 of the notes — the §3.3 constants — are the right asymptotic quantities, and the fused family's 1/2 and 1/3 are not, however dominant they look in the table.

---

## 5. A single global lower bound

The residue analysis gives eight different δ₀ across the 24 residue classes (§3.3). It is worth collapsing them into a single number that should hold everywhere, even at the cost of being loose.

**Where the floor lives.** The worst residue is **n ≡ 23 (mod 24)** — the only one carrying both local obstructions *and* unable to reach the fused rung — with δ₀ = 0.05051. Almost every value that has ever set a running floor has been in n ≡ 11 (mod 12), which contains it; 8 of the 11 are ≡ 23 (mod 24) and the other three are ≡ 11, which is not a contradiction, since finite-n record holders are low from *supply* failure rather than from a low ceiling.

> **The finite-range minimum is not currently an additive phenomenon at all.** Over the corrected table the smallest density is **0.051813 at n = 1159 = 19·61**, whose winner is the single fused class `19x61` — an S2 value at n ≡ 7 (mod 12), not n ≡ 11. Its weakness is *multiplicative*: F = 19 is the smallest prime-power cofactor of n, so the engine delivers 1/19 and nothing additive competes. Eight of the ten weakest values are still ≡ 11 (mod 12), six of them ≡ 23 (mod 24), so the additive pattern is intact — but the binding constraint at computed sizes is the multiplicative engine's *granularity*, and only asymptotically does the class-23 additive ceiling take over. This is the handover of §3.7 seen from the floor's side, with a concrete witness. `ladder_verify.py` computes, for each n, the best density achievable by four explicit families, scanning the block size over a window wide enough to contain every balance point, x ∈ [0.10, 0.55]. Over all composite non-prime-power **n ≤ 10⁶** (78 minutes) the smallest value is

> **δ ≥ 0.02516, at n = 8927.**

This is a *lower* bound on δ(n), not δ(n) itself, since it uses only four families. No class is anomalously weak relative to its own cap: the per-class minima of δ/cap run from **0.327 to 0.653** at N = 20,000, the spread expected from representation availability alone. The one residue that behaves unlike its class is **n ≡ 11 (mod 24)**, which alone among the nine rung-B residues did not rise when the fused rungs were added — its worst value, n = 11819 at 0.455 of cap, is unmoved, so either the supply fails there or η = 1/6 is not reachable.

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

> **Why the extremal residue is mod 24 and not mod 12.** The local obstructions at ℓ = 2 and ℓ = 3 only see n mod 12. What splits the odd classes further is whether the **fused rung** of §3.3 is reachable, which is a condition on n mod 8; nine of the twelve odd residues reach it and three — **7, 15 and 23 mod 24** — do not. The minimum over all residues is **0.050510**, attained at **n ≡ 23 (mod 24)** alone, which is half of n ≡ 11 (mod 12).

<!-- DUP:density_floor_conjecture -->
> **Conjecture (global density floor).** For every composite non-prime-power n, **μ(n) ≥ C(n,2)/50**, i.e. δ(n) ≥ 0.02; and asymptotically **δ(n) ≥ (5 − 2√6)/2 − o(1) = 0.050510…**, the extremal residue being **n ≡ 23 (mod 24)**, the only one carrying both local obstructions and unable to reach the fused rung.
<!-- /DUP -->

> **Conjecture (global density floor).** For every composite non-prime-power n,
>
> **μ(n) ≥ C(n,2)/50**,  i.e. **δ(n) ≥ 0.02**,
>
> and asymptotically
>
> **δ(n) ≥ (5 − 2√6)/2 − o(1) = 0.050510…**,
>
> the extremal class being **n ≡ 23 (mod 24)** — the only residue carrying both local obstructions *and* unable to reach the fused rung, where the balanced family yields η/(1 + k√η)² at η = 1/6, k = 2. The other half of n ≡ 11 (mod 12) reaches 0.06699 (§3.3). The asymptotic half says the *worst* n eventually reach what the balanced family guarantees; it is a floor, and individual n exceed it freely.

**The asymptotic half is exactly what (H) buys.** Granting Hypothesis (H) of §3.5, every sufficiently large n admits a representation at its own class ceiling, so δ(n) ≥ δ₀(n) − o(1) ≥ 0.050510 − o(1) with the minimum at n ≡ 23 (mod 24). The finite half — δ ≥ 0.02 at *every* composite non-prime-power n — is not implied by (H), which is an eventual statement; it is supported by the computation to 10⁶ and by the margin below.

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

`mu_enumerate_v2.py --floor M --adaptive` runs the loop as one job: it seeds at M·C(n,2) so any configuration above the floor rejects n immediately, prunes candidates whose lower bound has risen above the current floor, computes B(n) exactly only for survivors, and adopts a lower value as the new floor — which in turn tightens Proposition F.1's part-count cap ⌊1/√M⌋ for everything after it.

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
- **a block of 2-power size** — then c − 1 is odd and can sit cyclically beside C_{r−1} without demotion. This is what n = 551 = 256 + 167\* + 128 exploits, and §4.3 counts at O(n/log n) values;
- **demote one block's multiplicative group into the top q-group** — then Γ/Γ₁ = C_t must be a q-group, so t = (r−1)/d must be a prime power. That is the Sophie Germain condition, and it is where the conditionality enters.

Read this way η = 2/d is not an efficiency knob but **the price of using blocks of unequal size at all**, and the dichotomy explains why no unconditional family with ω(n) ≥ 3 has ever appeared in the computed table: from constructions of this shape, none can.

**In census terms**, the disjunction below ranges over S3, S4 and S7 at F = 2 for the two- and three-class shapes, plus their higher-k analogues; S2 drops out with the fusion shapes, and S6 through S10 either cannot occur or are supply-limited past the point of mattering (§4). So the finite set of Bateman–Horn systems is exactly the set §3 analyses, taken over all part-counts up to the bound below.

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

5. ~~**Do the ℓ = 3 escapes behave as the sparsity heuristic says?**~~ **Resolved (§4.3), and now proved rather than assumed.** All four escape routes reach **O(n/log n)** values of n: the residue's own ceiling confines the block to a ratio range of width under 4, which admits O(1) block sizes, leaving one prime's worth of freedom. Measured, the 2-power route's effectiveness falls 3.73% → 2.20% → 1.20% across n ≈ 10⁴, 10⁵, 10⁶ and the 3-power route reaches zero by 10⁶. The asymptotic constants are untouched; the escapes are conspicuous at computed sizes only because a log vanishes slowly.

6. **The fused family at ω(n) = 2 but bad splitting.** **338 of the 1,118** values with ω(n) = 2 do better with a split than with fusion, which happens when the smallest prime-power cofactor F is large. The distribution of F over ω(n) = 2 integers is classical, so predicting the 754/323 division is a clean test.

7. **Efficiency below 1.** The distribution of the largest prime-power divisor of r − 1 over primes r is a shifted-prime question of Erdős type; the known results should be imported rather than re-derived, since η is what fixes every constant in §3.3.

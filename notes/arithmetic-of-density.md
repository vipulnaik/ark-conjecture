# The arithmetic of the density ladder

> **Pending: the numerical rebuild.** Figures marked ⟦PENDING-REBUILD⟧ are read off a table that
> predates the current SAFE cap and are known low at 289 rows — the density floor and its argmin, the
> census winner counts, and per-row witnesses. `mu_enumerate_v3.py` is the enumerator; running
> `check_doc_figures.py` against its completed output is the pass that replaces them. Unmarked figures
> from the current table remain correct as lower bounds but may rise. Structural and asymptotic claims
> are **not** provisional: the ceiling table is keyed mod 12 with six constants, confirmed by scanning
> real configurations per residue class (`ceiling_rederive.py`), and the ladder floors (0.04453 to
> 10⁶, conjectured 1/25) are construction-side and independent of the cap.


*Supplement to `orbital-evasiveness-notes.md` and `enumeration-proof.md`. Where those two ask what μ(n) is and prove that the enumeration computes it, this one asks **which arithmetic conditions on n control the answer**, sets up the Hardy–Littlewood and Bateman–Horn machinery that governs them, and checks the predictions against the computed table. The shape space is the one set out in `enumeration-proof.md` Part 0 and implemented in `mu_enumerate_v2.py`, so **μ(n) ≤ B_safe(n)**. What has not caught up is the data — see the provenance banner in §2.0 — so measured figures below carry the table they came from and want recomputing against v4. Everything below that compares families against one another, or that reads a family's cap, is unaffected; everything that treats a tabulated value as μ(n) needs the qualifier.*

**Status labels as in the other documents.** *Verified* — an independent computation agreed. *Sound* — argued and read, no independent computation. *Heuristic* — a singular-series prediction, i.e. conditional on Hardy–Littlewood or Bateman–Horn.

**Which hypothesis each constant depends on.** Every ceiling in this document is row 1 of the table in `orbital-evasiveness-notes.md` §1 ("Which hypothesis is doing which work"): the eight constants come from the **shifted-prime condition**, which is Oliver's chain and not solvability, while the existence of a full-density block — the thing being optimised — comes from **2-homogeneity at k = 2** and not from the chain. Relaxing the chain collapses the eight constants to two (`solvable-relaxation.md`); raising k removes the block instead. The two are independent, and no constant here survives the first relaxation unchanged.

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
3. **The ceiling splits by residue class mod 12, for both parities.** The local obstructions at ℓ = 2 and ℓ = 3 split it mod 12 — and those are the only two moduli that can obstruct, because each system is three linear polynomials so ω(ℓ) ≤ 3 < ℓ for ℓ ≥ 5. **Six distinct constants result**, from 1/4 down to 7 − 4√3 = 0.07180 (§3.3). *Nothing finer than mod 12 appears: which fusion rung is reachable is a separate question, but at F = 2 it depends on n only mod 4 and at F = 4 its mod-8 condition is constant on the mod-12 class (§3.3.4).*
4. **One global floor covers everything.** Conjecturally **δ(n) ≥ 1/25 for every composite non-prime-power n** — and below 10⁶ this is **verified unconditionally**: the four-family ladder gives δ(n) ≥ 0.04453 at every composite non-prime-power n ≤ 10⁶, attained at n = 11183 (§5). The bound is a lower bound at every step, so it needs nothing from the table. The extremal residue is **n ≡ 11 (mod 12)** (§3.3), which is where the search has landed at every stage.
5. **The multiplicative engine covers a density-zero set, so asymptotically the additive engine is everything.** The fraction of n with ω(n) = 2 thins like log log n / log n — measured at 52% below 2000 but 29% near 10⁶. So the asymptotic behaviour of μ is governed entirely by the Hardy–Littlewood side, and the observed density floor should be expected to drift downward as the fused family's reach recedes.

---

## 2. The configurations, and the two engines

*The companion `enumeration-proof.md` classifies which configurations an Oliver group can realise and proves that classification; this document is about how they behave arithmetically. Its Part 0 carries the **configuration census**, reproduced below so that both documents can be read on their own.*

> **One computed instance of each live shape**, from `mu_table_safe_v4.csv`, so that every row below can be checked against a concrete configuration. The starred part is the foreign block; the term in bold is the one that binds.
>
> | shape | first instance | witness | B(n) | δ |
> |---|---|---|---|---|
> | S1 | every prime power | n = c, AGL(1, n) | C(n,2) | 1 |
> | S2 | n = 6 | `p=3 q=2: 2x3` | 6 | 0.400000 |
> | S3 | n = 30 | `p=13 q=2: 1x17* + 1x13` | 78 | 0.179310 |
> | S4 | n = 247 | `p=73 q=5: 1x101* + 1x73 + 1x73` | 2525 | 0.083111 |
> | S5 | n = 459 | `p=101 q=2: 1x257* + 2x101` | 10100 | 0.096089 |
> | S7 at F = 2 | n = 99 | `p=23 q=13: 1x53* + 2x23` | 506 | 0.104308 |
> | S7 at F ≥ 3 | n = 143 | `p=2 q=23: 3x32 + 1x47*` | 1081 | 0.106471 |
>
> S6 has no instance in the current range. The pair to compare is **S5 at n = 459 against S7 at F = 2 at n = 99**: both are `2×c + r*`, and they are distinguished only by the top prime — q = 2 in the first, where the twist stays full and the Fermat prime 257 keeps the foreign block at η = 1, and q = 13 in the second. The twist is full at either q, so the two shapes differ only in foreign efficiency and S5's q = 2 reading is dominated at odd q; the census split is pending the rebuild.

> **The census is duplicated on purpose.** A split — structure there, behaviour here — would force a reader to join two tables across two files mentally, which is worse than the drift risk. So the duplication is deliberate and the drift risk is handled mechanically instead: `check_doc_figures.py --pass census` cross-checks every S-row between the two documents and reports any that is missing or reworded. **S-numbers are append-only.** A new shape gets the next number and a row in both files; nothing is ever renumbered, because the S-numbers are the key the documents are joined by.

### 2.0 The census

> **Provenance of every measured figure in this document.** Structural columns, closed forms and asymptotic verdicts are stable and can be read as stated. **Winner counts, percentages and per-shape medians are not** — they are measurements of the current table over its **contiguous range**, they move with every extension, and they are what `validate_table.py` prints back for copying. Two gotchas govern them. **A count taken over the whole CSV is not a count over the range**: rows above the contiguous frontier are worklist rows selected by low ladder score, so they skew every share (they hold 4 of the 20 three-part winners and 21 of the 71 F = 4 ones). And **the winner column is sensitive to the SAFE cap**, which is not shape-neutral: crediting a fused class F·C(c,2) regardless of its twist inflates fused shapes specifically and can empty a census row that a tightened cap restores.

| # | shape | engine | winners (contiguous range) | asymptotic verdict: **exists** / **wins** | where |
|---|---|---|---|---|---|
| **S1** | one matching block, no copies | — | every prime power | **exists → 0**; **wins → 0**, the same set. Prime powers up to N number π(N) + O(√N) = O(N/log N), and where the shape exists it wins outright at δ = 1 | §2.1, §4.1 |
| **S2** | fused matching class, **top**-layer copies, n = F·c | multiplicative | **777** (35.5%) | **exists → 0**; **wins → 0**, essentially the same set. Needs ω(n) = 2 with both factors prime powers; where available it gives δ = 1/F, which beats every additive shape at small F, so it wins nearly wherever it exists | §2.1, §4.1 |
| **S3** | matching + outside, n = c + r\* | additive | **900** (41.2%) | **exists → 12/24 *plus a positive proportion of odd n***; **wins → 12/24**. All even n conjecturally, and at odd n the shape survives with c = 2^a, giving n = 2^a + r\* — which Romanov puts at positive lower density and Erdős's covering congruences keep bounded away from all of odd n. So this is the one row where existence strictly exceeds winning by a positive density rather than by a rate: the odd instances exist but are almost never good enough near the balance point to win, and even on the even side existence converges faster than winning | §3.1, §4.3 |
| **S4** | two matching + outside, n = 2c + r\* | additive | **⟦PENDING-REBUILD⟧** 15 of the 16 are exceeded by entangled S7-at-F=2 readings (all but n = 1529); expect ~0 after the rebuild | **exists → 12/24** (all odd n); **wins → 0**. The cyclic-layer fused rung beats it at **every** c, since 2·C(c,2) > C(c,2) with no congruence in play (§3.2.3), so it is dominated inside the three-part family as well as outside it. **The widest existence/winning gap in the census**: available at essentially every odd n and beaten everywhere | §3.2 |
| **S5** | **top-layer**-fused matching + outside; forces q = 2, hence η = 1/u | hybrid | **30** | **exists → 12/24** (all odd n — q = 2 fusion is always available, just usually at a useless η); **wins → 0**. An escape: winning needs η = 1/u with u small, i.e. r = 2^a·u + 1, which is O(log n) candidates per n and so O(n/log n) values | §3.3, §4.3 |
| **S6** | two outside blocks | additive | **0** | **exists → 12/24** (every even n with a Goldbach representation); **wins → 0**, and not from scarcity: cap = 1/(√m₁+√m₂)², the 1/4 and 0.17157 rungs are locally obstructed at ℓ = 3 down to n = 26 and n = 20, and the plentiful rung caps at 0.13397 where S3 reaches 1/4 | §4.2 |
| **S7** | **middle**-layer-fused matching + outside; **F = 2 is the odd-n fused rung B** | hybrid | **338** at F = 2; 50 at F = 4; 53/3/17/2 at F = 3/5/6/8 | **F = 2: exists → 12/24** (all odd n); **wins → 8/24 ≈ 33.3%**, the odd residues whose class ceiling it attains — 1, 3, 5, 9, 13, 17, 19, 21 mod 24. At the other four odd residues the ceiling belongs to F = 4, so F = 2 does not win there even where it attains the three-part family's own best. **F ≥ 3: exists → 24/24; wins → 4/24 ≈ 16.7%**, all of it at F = 4. Two regimes, split by the parity of F. At **odd F** the shape n = F·c + r needs F·c even, hence c = 2^a, which is O(log n) block sizes per n — a genuine escape reaching O(n/log n) values, and it wins nowhere, since even n already have S3 at cap 1/4 against F = 3's ceiling of 0.13397. At **even F** there is no such restriction: at odd n, F·c is automatically even and c ranges over all prime powers, so the supply is a full Hardy–Littlewood system. **F = 4 attains the class ceiling at the four residues 7, 11, 15, 23 mod 24** (§3.3.5), where it beats every F = 2 rung because 4c ≡ 4 rather than 6 (mod 8) removes the 2-adic cut on the foreign efficiency | §3.2, §3.3.5, §4.3 |
| **S8** | bottom-layer-fused matching | — | never | never exists (Lemma D1), so no asymptotics | — |
| **S9** | fused outside block, any layer | — | 0 | **exists → positive** (buildable whenever n = F·r admits the permuter); **wins → 0**. Lemma D2 caps any configuration containing one at n^{3/2}/2, so its density is O(n^{−1/2}) → 0 and it is beaten wherever δ(n) ≫ n^{−1/2} | §4.4 |
| **S10** | outside block with r = q, any F | — | never | never exists at any F — the twist is forced into the cyclic layer beside the translations, hence trivial, so the orbit is worth only \|O\| (`enumeration-proof.md` Part D2, Lemma D2q) | — |

> **The verdict column reports two different limits, and they can differ sharply.** **Exists** is the proportion of n at which *some* admissible configuration of the shape can be built. **Wins** is the proportion at which one attains B(n). For S1, S2 and S6 the two coincide because the shape is rare and dominant where it occurs; for S8 and S10 both are zero by theorem, and for S9 existence is positive while winning is zero. For the odd-n family they diverge: S4, S5 and S7 at F = 2 all exist at essentially every odd n, and which of them wins is decided by the ceiling comparison of §3.3, so their winning shares partition the odd residues while their existence shares all equal 12/24. Even where the two limits agree, existence converges faster — a representation becomes available well before it becomes good enough near the balance point to beat everything else.
>
> **The winning shares sum to 1; the existence shares do not, and are not even a partition.** Several shapes are simultaneously available at the same n — that is exactly what makes the ceiling comparison the substantive question — so the existence column double-counts by design. S3 is the case worth watching, since its existence is not confined to one parity: the odd-n instances n = 2^a + r\* are a positive proportion by Romanov, so S3 exists on strictly more than half of all n while winning on exactly half. Note also that the odd-n existence density here is not known to *converge*: Romanov gives a positive lower density and Erdős an upper bound below 1, with the limit itself unsettled, so the entry is a proportion bounded away from both ends rather than a value.

> **S4 and S7 at F = 2 are co-carriers, not rivals.** Both realise the same family n = 2c + r; whether fusing the two equal blocks helps depends on c mod 8, and each verdict holds on a quarter of all c. **The fused rung here is S7 at F = 2, not S5.** S5 fuses by a *top-layer* involution, which keeps the full twist and obeys no congruence on c at all, but forces q = 2 and so is rationed by the foreign block instead — which is what makes it an escape rather than a carrier. The analysis is in §3.2.
>
> **What the winner column reports is sensitive to the SAFE cap.** Crediting a fused class F·C(c,2) regardless of its twist inflates fused shapes specifically — the one place SAFE's over-count is not shape-neutral — and under that scoring S4 vanishes from the census entirely. **Gotcha: tightening the cap by requiring the cyclic twist coprime to F_mid looks conservative and is not sound.** That coprimality is not a necessary condition — entangled generators realise the full twist at any F_mid (`entangled-generator-finding.md`) — so the tightened cap *undercounts* fused classes and resurrects S4 as an artifact. The flat cap F·C(c,2) is the correct one. Winner counts throughout this census await the v3 rebuild; structural columns are not affected.

**The engine dichotomy is a simplification, and the hybrids are where the action is.** S1 and S2 are purely multiplicative and S3, S4, S6 purely additive, but **S5 and S7 are neither** — a fused class supplying the multiplicative factor F alongside a foreign block supplying the additive one. That is not a defect of the taxonomy; it is where the two interesting phenomena live. They are also the pair most easily confused with each other, since both fuse two equal c-blocks beside a foreign block and differ only in which layer holds the swap: S5 in the top layer, which forces q = 2 and caps its efficiency at η = 1/u, and S7 in the cyclic layer, which leaves q free and keeps the **full** twist (§3.2.3 — a cyclic-layer fusion costs nothing on the matching side). S7 at F = 2 therefore weakly dominates S5 at odd q, and the fates of both await the rebuild.

### 2.1 The multiplicative engine: density 1/F

Let n = F·c with F a power of q and c a power of p. The single fused class has intra-orbital F·C(c,2), within-class cross (F or F/2)·c² — F for odd F, F/2 for even F — and no other terms, so

> m\* = F·C(c,2) = F·c(c−1)/2, and **δ = m\*/C(n,2) = (c−1)/(Fc−1) → 1/F.**

Two things follow immediately. Since a fused class needs F ≥ q ≥ 2, the engine cannot exceed **1/2**. And since n = F·c with both factors prime powers forces **ω(n) ≤ 2**, it is available only on that set.

To maximise, take F to be the **smallest prime-power cofactor** of n — the least F such that F and n/F are both prime powers.

> *Verified.* Over all 777 one-part winners in the table, the predicted density 1/F agrees with the computed value to O(1/n), with no exceptions — indeed |δ − 1/F|·n < 0.95 on every row, and every row matches the exact form (c−1)/(Fc−1). By F: 227 rows at F = 2 with median density 0.4996, 167 at F = 3 with median 0.3327, 130 at F = 4 with 0.2493, 106 at F = 5 with 0.1993, 67 at F = 7 with 0.1420. Maxima 0.49981, 0.33308, 0.24971, 0.19969, 0.14252 against 1/F = 0.5, 0.3333, 0.25, 0.2, 0.1429. (The remaining 80 sit at F = 6, 8, 9, 10, 11, 13, 17, 19.)

> *Verified.* All one-part winners have ω(n) = 2, and **no** value with ω(n) ≥ 3 has a one-part winner. Over the contiguous range to n = 2,600 — 2,186 rows — of the 1,118 values with ω(n) = 2, 780 are one-part winners and the other 338 do better with a split. (The 2,008-row era gave 780 and 338 on its own range, and the narrower n ≤ 2,298 slice gave 754 and 323; where a count below is quoted from one of those slices it says so.)

**Why fusion is worth a factor of F.** F *unfused* equal parts of size c give min(C(c,2), c²) = C(c,2) ≈ n²/(2F²), density 1/F². Fusing them replaces the mutual capping by a single intra term F·C(c,2), density 1/F. So fusion buys exactly F, which is why reduction (R1) of the proof document — merge equal-size classes when F₁ + F₂ is a q-power — is the single most valuable simplification in the search, and why the enumeration's winners are so often a single fused class.

**Terminology, since the next few sections depend on it.** A configuration is n = Σᵢ Fᵢcᵢ. Each summand is a **class**: Fᵢ blocks of size cᵢ, *fused* by the top q-group, with Fᵢ a q-power and cᵢ a prime power. A class is **unfused** when Fᵢ = 1 — a single block. The `parts` column of the table counts **classes**, not blocks, and Proposition F.1's k is that count, whether or not the classes are internally fused.

So fusion is an axis *within* a configuration rather than a separate kind of configuration, and the two engines above are a first approximation rather than a dichotomy. Mixed shapes are the norm rather than the exception: **493 of the 1,393 two-class winners (35.4%)** pair a fused class with an unfused foreign prime (v4 counts, pre-rebuild). **⟦PENDING-REBUILD⟧** The tentative global minimum is n = 2183 at 0.048039, witness `6x251 + 1x677*` — also a fused class plus a foreign prime; v4's minimum n = 1817 rises to ≥ 0.0594 under the corrected caps (`3x256 + 1049*`). (No three-class winner contains a fused class.) Fusion also carries a cost that is easy to miss: Fᵢ must be a power of the top prime q, so fusing at all constrains q, and the foreign block's twist must then be a q-power too. At n = 1817 the fused pair forces q | 2 on that class while the foreign 1039 takes q = 173, which is what the witness records.

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
- **§3.3 turns the ceilings into a table indexed by n.** Which ceiling applies at a given n is decided by which local obstructions bite — a condition **mod 12**, from ℓ = 2 and ℓ = 3, and no other prime can obstruct. That gives **six constants**, of which the smallest — 7 − 4√3 = 0.071797, at n ≡ 11 (mod 12) — is the number §5's floor is stated against.
- **§3.4 checks that the balance point is not a cheat.** The ceilings are attained only near x\*, so the count that matters is of representations in a *window*. If that window shrank with n these would all become short-interval problems and be out of reach. It does not; the window has fixed relative width.
- **§§3.5–3.6 say what is actually being assumed.** §3.5 draws the distinction the rest of the section relies on — these are *parametric* Goldbach-type systems, not fixed Bateman–Horn ones — and states **Hypothesis (H)**, the single hypothesis everything conditional in this document rests on. §3.6 places (H) on the ladder of shifted-prime results, where it is the θ = 1 endpoint against a current unconditional 0.679.
- **§§3.7–3.8 test all of it against computation.** §3.7 asks whether representations *exist* (a cheap sieve, verified to 10⁶). §3.8 asks the much stronger question of whether the *number* of them matches the singular series, residue by residue. *(A third test — which of the competing odd-n readings realises the three-part family — is in `three-part-family-split.md`. It is kept out of the main line because its conclusions concern runners-up: S4 wins at no residue asymptotically, so the split it predicts does not enter any share of n.)*

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

> **Cyclic-layer fusion — S7 at F = 2.** F = F_mid = 2, so the swap sits in Γ₁/Γ₂ alongside the twist and the foreign translations. **The twist is nevertheless full: d = c − 1, and the intra term is 2·C(c,2).** The block swap is realised by an *entangled generator* — a single z of order F·d acting as a block rotation whose step-multipliers generate 𝔽_c^×, so that z^F is the full twist and the block-permutation image is a **quotient** of the cyclic layer rather than a subgroup of it. The top prime q is *unconstrained*, so the foreign block's efficiency η is free.
>
>
> **Top-layer fusion — S5.** F = F_top = 2, which **forces q = 2**. Then F_mid = 1, nothing competes with the twist in the cyclic layer, d = c − 1, and the intra term is **2·C(c,2) for every odd prime power c**. The price is paid on the other side: with q = 2 the foreign twist must be a 2-power, so **η = 1/u** where u is the odd part of r − 1.

*The top-layer reading is Theorem 2.1.* That theorem's group is exactly this construction with the foreign block deleted, and it gives m\* = 2·C(m,2) for **every** odd prime power m, verified at m = 9 and m = 25, both ≡ 1 (mod 8). So no congruence on c can be attached to top-layer fusion, and any argument that derives one has silently assumed the swap is in the cyclic layer.

> **The gotcha, and how it was itself one level too shallow.** It is natural to reason "fusing two blocks puts C₂ somewhere, and C₂ competes with the twist" and to conclude that fusion *as such* costs the 2-part of the twist. Whenever a congruence on c appears in an argument about fusion, check which layer is being assumed.
>
> **The deeper gotcha, and the one that actually bites.** Asking *which layer* is assumed is not enough, because the tempting argument — "C₂ must sit somewhere, and a cyclic group has a unique subgroup of each order" — is invalid at **either** layer: it treats the fusion image as a *subgroup* of the cyclic layer when it is a **quotient**. Entangled generators (§3.2.3) exhibit the difference. So the standing check is: *whenever an argument constrains a layer by what subgroups it contains, ask whether the object being placed there is a subgroup or a quotient.* This confusion has produced three separate defects in this programme, which is enough to make it a checklist item.

#### 3.2.3 The orbital halving, and what c mod 4 does and does not buy

> **Why c ≡ 3 (mod 4) halves fewer orbitals: it is a statement about quadratic residues.** The split in the formula orb(c, d) = cd or cd/2 is not a coincidence of the bookkeeping; it is Euler's criterion. A block's intra-orbitals are the classes **±δ·T** for T the twist group, because the pairs {x, y} are unordered — the orbital of a pair depends on the difference y − x only up to sign. Take T = the quadratic residues, of index 2, and ask when ±T is all of 𝔽_c^×:
>
> > **−1 is a quadratic residue mod c exactly when c ≡ 1 (mod 4).** So at **c ≡ 3 (mod 4)** it is a non-residue, T ∩ (−T) = ∅, and **±T = T ⊔ (−T) = 𝔽_c^×** — every nonzero difference lies in one class, and the index-2 subgroup already gives a **single orbital containing all C(c,2) pairs**. At c ≡ 1 (mod 4), −1 ∈ T, so ±T = T and the same subgroup gives *two* orbitals of C(c,2)/2 each.
>
> *(Verified directly: at c = 7, 11, 19, 23, 83 the set ±QR has c − 1 elements and the orbital is exactly C(c,2); at c = 5, 13, 17, 29, 73, 137 it has (c−1)/2 and the orbital is C(c,2)/2.)*
>
> **This is the Paley graph, read from the other side.** The Paley graph is defined only for c ≡ 1 (mod 4) — precisely so that the residue relation is symmetric and gives an undirected graph on half the pairs. At c ≡ 3 (mod 4) there is no Paley graph: the residue relation is a *tournament*, and symmetrising it returns the complete graph. What is a defect for constructing an interesting graph is exactly what we want here, since we need one large orbital and not two.
>
> **What this does *not* buy is a cheaper block swap — and the tempting inference that it does is the central gotcha of this section.** Full 2-homogeneity normally costs the whole multiplicative group C_{c−1}; at c ≡ 3 (mod 4) it costs only the odd index-2 subgroup, so the factor 2 in c − 1 is not needed inside the block. From there it is natural to conclude that the freed 2 is what the cyclic layer spends on F_mid = 2, hence that **the fused rung is reachable exactly when the block does not need the 2 for itself** — a congruence condition on c. That conclusion is false. A block swap realised as an **entangled generator** — which has consequences beyond the scoring: its cycle type differs from a block permutation's, so it is the object whose *sign* matters in the A_n setting (`chiral-graph-properties.md` §3 rule (F2)) — takes z of order F·d acting as a block rotation whose step-multipliers generate 𝔽_c^×; then z^F is the full twist, and the block-permutation image is a *quotient* of the cyclic layer, not a subgroup of it. So a cyclic-layer fusion costs nothing on the matching side at **any** c, and no congruence on c is required for the fused rung.
>
> **What c mod 4 does instead is steer.** At F = 2, 2c ≡ 2 or 6 (mod 8) according to c mod 4, so r = n − 2c is reachable at **two** residues mod 8. At F = 4 it steers nothing, since 4c ≡ 4 (mod 8) for every odd c. That asymmetry — and not any property of c itself — is what separates the residue classes: the two F = 2 options differ by 4 mod 8 and so agree mod 4, which means the choice can turn r ≡ 1 (mod 8) into r ≡ 5 (mod 8), buying η = 1/2, but can never produce an r ≡ 3 (mod 4) and so never buys η = 1 or η = 1/3 where those are otherwise unavailable. Hence only the classes that need η = 1/2 benefit from the choice at all (§3.3.4a, §3.3.5).
>
> (The characteristic-2 case is separate and degenerate: at p₀ = 2 one has −1 = 1, so ±T = T always and the halving never applies — this is the `char2` flag in the scoring code, not an instance of the above.)

**No congruence on c prices a cyclic-layer fusion.** The fused intra term is 2·C(c,2) at every odd prime power c, so the cyclic-layer rung is strictly better than the unfused C(c,2) **everywhere**, with no congruence and no tie case. The four c mod 8 classes are still worth tabulating, because they are where v₂(c − 1) governs what Lemma C's strip leaves behind:

| c mod 8 | c − 1 | cost of cyclic-layer fusion | where the old arithmetic still applies |
|---|---|---|---|
| 3, 7 | 2·odd | **none** | — |
| 5 | 4·odd | **none** | Lemma C, if a foreign prime divides c − 1 |
| 1 | 8 \| c−1 | **none** | Lemma C, ditto — and the largest 2-part, so the strip bites hardest here when it bites at all |

**The surviving home of v₂(c − 1) is Lemma C's conjugation strip**, which cuts the twist when it shares a prime with a foreign block; the parity of what remains is still governed by v₂(c − 1). So the old arithmetic is a special case inside that regime, not a general law about fusion — and the orbital-halving argument above is what makes it work there.

#### 3.2.4 Three worked instances

**One n of each, with the terms.** The clearest way to see that these are three genuinely different shapes is to score all three readings at the same n and watch a different one win each time. Every row is n = 2c + r, and the bold entry is the value `mu_bound` records in `mu_table_safe_v4.csv`:

| n | c, r | S4 (unfused) | S7 at F = 2 (cyclic) | S5 (top) | the winning value, in full |
|---|---|---|---|---|---|
| **273** | c = 83 ≡ 3 (8)<br>r = 107, r−1 = 2·53 | 3403 — binds on **intra** C(83,2) | **5671** — binds on the **foreign** block, orb(107, 53) | 107 — binds on the **foreign** block at q = 2, orb(107, 2) | **5671 = min( 2·orb(83,41), orb(107,53) ) = min(6806, 5671)**, the other two terms being 6889 and 17762. Cyclic fusion doubles the intra term to 6806 and the foreign block then binds 17% below it — near, but not at, the balance point (x = 0.3040 against x\* = 0.29289) |
| **253** | c = 73 ≡ 1 (8)<br>r = 107, r−1 = 2·53 | 2628 — binds on **intra**, C(73,2) | **5256** — binds on **intra**, 2·C(73,2) at the **full** twist 72 | 214 — binds on the **foreign** block at q = 2, orb(107, 2) | **5256 = min( 2·C(73,2), 73², orb(107,53) ) = min(5256, 5329, 5671)**, the inter term being 15622. The cleanest exhibit of the fused rung's unconditionality: c ≡ 1 (mod 8), the 2-part of c − 1 as large as it gets, and the fused class still at its **full** twist |
| **531** | c = 137 ≡ 1 (8)<br>r = 257, r−1 = 2⁸ | 9316 — binds on **intra** C(137,2) | **does not exist** — r − 1 has no odd prime factor, so the cyclic rung has no admissible q | **18632** — binds on **intra**, 2·C(137,2) | **18632 = min( 2·C(137,2), 137² ) = min(18632, 18769)**, the foreign and cross terms being 32896 and 70418. The two live terms differ by **0.7%**, but that near-tie is *structural* rather than a balance effect: a fused class always has intra = c(c−1) against within-class cross = c², so they sit a factor c/(c−1) apart at every c |

**Reading the losing entries.** The three readings share the same n, c and r and differ only in how the two c-blocks are treated, so the columns are directly comparable and the shortfalls are informative. At n = 273 the unfused reading loses by a factor 1.67 because it forgoes the doubling; the top-layer reading loses by a factor 53 because forcing q = 2 leaves the foreign block a twist of order 2 where q = 53 would give order 53. At n = 253 cyclic fusion is worth its full factor of 2 — 5256 against the unfused 2628 — *at c ≡ 1 (mod 8)*, where the 2-part of c − 1 is largest: the fused intra term clears the foreign term 5671 and the block's own 2-adic structure costs it nothing. At n = 531 the top-layer reading is worth exactly twice the unfused one, 18632 against 9316, since the twist is untouched and nothing else binds.

> **A case worth one line, because it looks like it should be interesting and is not.** At n = 247 (c = 73, r = 101, r − 1 = 4·25) the fused and unfused readings score **identically** at 2525: the foreign term orb(101, 25) binds below both intra terms, so fusion is free but buys nothing. The winner there is neither reading but a different shape, `4x41 + 1x83*` at 3280.

**A structural note visible in the last column.** For a fused class of F blocks the within-class cross term is **(F/2)·c² for even F and F·c² for odd F** — keyed on the parity of the **block count**, not on the top prime q. (The two conditions come apart under the corrected shape space, where F = F_mid·F_top need not be a q-power; keying the coefficient on q is correct only where every F is a q-power, so that even F forces q = 2.) At **F = 2**, which is every rung-B and rung-B′ configuration, the term is therefore **c²** at either top prime, against an intra term of at most c(c−1) — so the two sit within a factor c/(c−1) and the cross term never binds. The consequence is that a **fused class's minimum is essentially always its intra or its foreign term**, never its within-class cross — which is why the ceiling derivations of §3.3 balance only those two.

> *Verified by direct orbit computation rather than by reading the formula.* Building the group at c = 7 with two blocks, independent translations, a diagonal twist of order 3 (the odd part of c − 1 — one valid choice among several, not a forced one) and a block swap gives orbital sizes **{42, 49}** summing to C(14,2) = 91: intra 2·orb(7,3) = 42 and within-class cross **49 = c²**, not 2c². That is the F-keyed rule, and it agrees with the orbital count of `orbital-evasiveness-notes.md` §9.7, whose ⌊F/2⌋ term gives exactly one within-class cross orbital at F = 2.

The bold values are what `mu_table_safe_v5_code_v3.csv` records, under the witnesses `p=137 q=2: 2x137 + 1x257*`, `p=83 q=53: 2x83 + 1x107*` and `p=73 q=53: 2x73 + 1x107*`. Note what the first two show together: **both** reach the full twist at c ≡ 1 (mod 8) — one through the top layer and one through the cyclic layer. The two layers agree, which is the content of §3.2.3 in one line.

#### 3.2.5 The split in the computed table

**The split is visible in the table, and it is by q rather than by c.** Over the `2×c + 1×r*` winners, separated by top prime:

| | winners | c mod 4 | u = odd part of r − 1 |
|---|---|---|---|
| **q odd** (cyclic-layer, S7 at F = 2) | 80 | **⟦PENDING-REBUILD⟧** **no congruence: c mod 8 = {1: 14, 3: 23, 5: 23, 7: 17}**, i.e. **37 at c ≡ 1 (mod 4)**, plus 3 at p = 2 | unrestricted |
| **q = 2** (top-layer, S5) | 15 | 5 / 4 / 4 / 2 across 7 / 5 / 3 / 1 mod 8 — **no congruence** | only **1** and **3** |

**So the split is by q and by nothing else.** Neither row shows a congruence on c. **The cyclic-layer rung is available at every c**, so it carries the odd-n asymptotics alone and S4 wins nowhere. S5 is a third, supply-limited route that ignores c entirely and is rationed by u instead.

> **⟦PENDING-REBUILD⟧** *The counts above are provisional*, taken from `mu_table_safe_v5_code_v3.csv` at 806 rows (n ≤ 1000) rather than the full range; the c mod 8 shape of them is what matters and is not in doubt — 46% of cyclic-layer winners now sit at c ≡ 1 (mod 4), against 9% under v4. Requote on the completed rebuild via `check_doc_figures.py`.

*How that translates into a proportion of n is a separate question — for a given n one takes the best c available near the balance point, not a random one — and it is worked out in `three-part-family-split.md`.*

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

*Then why do the conditions read mod 4 and mod 3 in terms of n?* Purely the change of variable. The system lives in s, with r = 2s+1 and (for odd n) c = m − s where m = (n−1)/2. The ℓ = 2 condition is a condition on **m mod 2**, and since m = (n−1)/2 that is a condition on **n mod 4**. The ℓ = 3 condition is on m mod 3, and 2 is invertible mod 3, so it is a condition on **n mod 3**. Hence mod 12 in n, with nothing finer available *from the local analysis*. Verified empirically: representability rates computed modulo 24, 36, 48, 72 and 144 show no spread within a fixed class mod 12 beyond sampling noise. (The ceilings below are keyed mod 12 as well, though for a partly different reason — which *rung* is reachable, §3.3.4 — so the agreement of the two moduli is a fact to check rather than assume.) The efficiency available in each class then follows from the structure of r − 1: writing r − 1 = 2^a·u with u odd and L the largest prime power dividing u, the best top prime gives

> **η = max(1/u, L/(2^{a−1}u))**, so **η = 1 exactly when either u = 1, or a = 1 and u is a prime power** — equivalently r − 1 ∈ {q^e, 2q^e}, the two cases being the **Fermat** primes (q = 2) and the **safe-prime-like** ones r − 1 = 2q^e with q odd.

The ℓ = 2 obstruction forces a ≥ 2, and hence η ≤ 1/2 **provided u > 1**; the ℓ = 3 obstruction forces 3 | u and hence η ≤ 1/3 generically, unless u is itself a power of 3; both together give η ≤ 1/6 subject to the same two provisos.

> **η = 1 has two sources, and the second is easy to miss.** The formula reads η = 1 as "u = 1, or a = 1 with u a prime power". The second disjunct is the familiar one — r a safe prime or r = 2q^e + 1 — and it is tempting to treat it as the only one and conclude that 4 | r − 1 caps η at 1/2. It does not: at u = 1 the efficiency is full for **every** a, because the whole of r − 1 is then a 2-power and q = 2 reaches all of it. These are the **Fermat** primes. In the computed table the branch produces **20 winners of shape `2×c + 257*`**, with densities from 0.09177 up to **0.16138** (n = 639) against 0.08579 for the classes they sit in — at n = 451, 459, 475, 531, 555, 559, 583, 595, 639, 651, 679, 703, 711, 715, 735, 759, 783, 795, 799, 819. `ladder_verify.py`'s `EFF` array computes η from r − 1 directly and so covers this case automatically; it is only in prose that the branch tends to get dropped.

#### 3.3.3 The ladder of rungs

**The shapes form a ladder, and each rung has its own balance point.** For odd n = (c-part) + r\*, with x = c/n:

| rung | shape | census | intra density | cap | balance point |
|---|---|---|---|---|---|
| **A** | one c-block + foreign | **S3** at odd n, needing c = 2^a | x² | η/(1+√η)² | √η/(1+√η) |
| **B** | two c-blocks fused in the **cyclic layer** + foreign | **S7 at F = 2** (no congruence on c) | 2x² | 2η/(√2+2√η)² | √η/(√2+2√η) |
| **B′** | two c-blocks fused in the **top layer** + foreign | **S5**, forcing q = 2 and hence η = 1/u | 2x² | same as B | same as B |
| **C** | two c-classes **unfused** + foreign | **S4** | x² | η/(1+2√η)² | √η/(1+2√η) |

with **A > B = B′ > C** in every class. The cross term binds at none of the four, so each rung's optimisation is valid on its own terms and the only question is which rung is *reachable* at a given n. Behind the ladder is a change of variable. Since (√F + F√η)² = F(1 + √(Fη))², the fused cap simplifies to

> **cap_F(η) = η/(1 + √(Fη))²**,

which is the k-class formula η/(1 + k√η)² at **k = √F**. So *fusing F blocks is worth exactly √F unfused classes*: F = 2 sits at k = √2, strictly between the one-class rung A (k = 1) and the two-class rung C (k = 2), and **F = 4 sits at k = 2, coinciding with rung C identically** — the two shapes differ in every structural respect and agree in cap at every η, so a matching value never identifies the shape. Equivalently **cap_F(η) = cap₁(Fη)/F**, which is why one rung's value at η is exactly half the next's at 2η: (5 − 2√6)/2 at (F = 4, η = 1/6) against 5 − 2√6 at (F = 2, η = 1/3).

> **A rung is not an escape.** Rung A needs c even, hence c = 2^a — only ~log₂n choices, so its optimum is usually out of reach. It is sometimes described as the "2^a + r\* escape", which misreads it: it is the *top* rung of this ladder, not a way around the ladder, and its rarity is a supply fact rather than a structural one.

#### 3.3.4 Which rung is reachable, and why the answer is mod 12

**Reachability imposes nothing beyond mod 12.** A cyclic-layer fusion keeps the full twist at any c (§3.2.3), so **the matching side imposes no congruence at all** and the keying follows from the foreign side alone:

> **At F = 2 the 2-adic condition drops from mod 8 to mod 4.** With c mod 4 free, 2c ≡ 2 or 6 (mod 8), so r = n − 2c reaches two residues mod 8 — and they differ by 4, hence agree mod 4. So what n determines is **r ≡ n − 2 (mod 4)**, and nothing finer. Then η = 1 needs r ≡ 3 (mod 4), i.e. **n ≡ 1 (mod 4)**; η = 1/2 needs r ≡ 5 (mod 8), which sits inside r ≡ 1 (mod 4), i.e. **n ≡ 3 (mod 4)** — and the freedom in c mod 4 is exactly what guarantees the mod-8 residue 5 is reachable rather than 1. A condition mod 4 for the 2-adic part, mod 3 for the ℓ = 3 obstruction: **mod 12.**
>
> **At F = 4 a genuine mod-8 condition survives, and is degenerate where it is used.** Here 4c ≡ 4 (mod 8) for every odd c, so r ≡ n − 4 (mod 8) is pinned and c has no say. F = 4 attains the ceiling only at n ≡ 11 (mod 12), whose two mod-24 residues 11 and 23 give n ≡ 3 and 7 (mod 8), hence r ≡ 7 and 3 (mod 8) — **v₂(r − 1) = 1 either way.** So the mod-8 condition is real in the derivation but constant on the class, and it produces no mod-24 structure in the table.

So the ceilings are keyed **mod 12**, and the same modulus decides local solubility (§3.5.4) — two distinct questions that happen to answer alike (§3.5.4 says why that is a coincidence worth not leaning on). **Gotcha: a grouping that puts 7, 15 in one row and 3, 19 in another is the way to reintroduce a spurious mod 24**, since 15 ≡ 3 and 7 ≡ 19 (mod 12), so such a grouping cuts across mod-12 classes. All four share a row. *Confirmed empirically: over n ∈ [24000, 48000] the per-residue sup agrees in cap, F and η across every pair {a, a+12} (`ceiling_rederive.py`). The old "100% or 0% over 15,000 values per residue, no boundary cases" measurement was made against a condition that does not hold, and is void.*

> **Rung B′ obeys no congruence at all, and is rationed on the other side instead.** Top-layer fusion reaches 2·C(c,2) for every odd prime power c, so B′ is available at every odd n and the mod-24 argument says nothing about it. What limits it is that F_top = 2 forces q = 2, the foreign twist is then the 2-part of r − 1, and **η = 1/u** with u the odd part. Reading cap_2(1/u) = (1/u)/(1 + √(2/u))² down the odd u:
>
> | u | 1 | 3 | 5 | 7 | 9 | 11 |
> |---|---|---|---|---|---|---|
> | cap₂(1/u) | 0.17157 | 0.10102 | 0.07505 | 0.06068 | 0.05133 | **0.04468** |
>
> So B′ clears (5 − 2√6)/2 = 0.050510, which was the worst class ceiling under the F = 2 rungs, exactly when **u ≤ 9**, i.e. when r = 2^a·u + 1 for one of five small odd u. That is an exponential family: it supplies O(log n) candidate r per n, hence reaches O(n/log n) values of n by the counting of §4.3 — the same tier as the other escapes, and **it therefore leaves every ceiling in the table below untouched.** The observed u are 1 and 3 and nothing else: 18 winners at r = 257, 6 at r = 769 = 3·2⁸ + 1. The Fermat branch above is this rung at u = 1, which is why reading that branch as an O(1) phenomenon tied to the five known Fermat primes understates it — the family is r = 2^a·u + 1 with u a small odd prime power.

#### 3.3.4a The efficiency available at each (class, F), by congruence

The ceiling of §3.3.5 is a joint optimum over the fusion count F and the efficiency η. §3.3.4 settles which *rung* a class reaches at F = 2; this settles the η available at each F, which is what the joint optimum ranges over. Two independent conditions multiply, and both are congruences on n.

**The 2-adic condition.** Nothing constrains c mod 4 (§3.2.3), so F·c mod 8 is determined by F alone — and the two F values that matter behave differently:

> - **F = 4** — 4c ≡ 4 (mod 8) for *every* odd c, so F·c is determined mod 8 with **no premise about c at all**. The F = 4 rows below are therefore exactly as they were, which is why the classes whose optimum takes F = 4 need no premise about c.
> - **F = 2** — 2c ≡ 2 or 6 (mod 8) according to c mod 4, both now available. So r = n − 2c is reachable at **two** residues mod 8, so the F = 2 rows have a choice. Since the two differ by 4 and hence agree mod 4, that choice is confined to converting r ≡ 1 (mod 8) into r ≡ 5 (mod 8) — i.e. to buying η = 1/2, never η = 1 or η = 1/3.

In either case r = n − F·c is determined mod 8, and the best case r − 1 = 2^v·q^e gives

> **η₂ = 2^(1−v)**,  where v = v₂(r − 1) is read off r mod 8: **v = 1** at r ≡ 3, 7; **v = 2** at r ≡ 5; **v ≥ 3** at r ≡ 1.

**The 3-adic condition.** If 3 | r − 1 is forced then the odd part of r − 1 carries a factor 3, and for that odd part to be a single prime power it would have to be a power of 3 — the family r = 2^v·3^e + 1, which is density zero. Generically the odd part is 3·(prime power), so **η is cut by 3**. Whether 3 | r − 1 is forced depends on F mod 3:

> - **F ≢ 0 (mod 3).** c mod 3 is free, so r can be steered to 2 (mod 3) by solving F·c ≡ n − 2 — *unless* that forces c ≡ 0 (mod 3), which happens exactly at **n ≡ 2 (mod 3)**. This is the ℓ = 3 obstruction of §3.3.1 seen at the level of the fused family.
> - **F ≡ 0 (mod 3).** Now r ≡ n (mod 3) is forced. The cut applies at n ≡ 1 (mod 3); and at n ≡ 0 (mod 3) one gets 3 | r, so **the shape does not exist** at all for prime r > 3.

Multiplying, **η = η₂ / (3 if cut else 1)**, which is the η column of §3.3.5.

> **Where mod 8 is not enough, and why it no longer forces a deeper keying.** At r ≡ 1 (mod 8) the rule above gives only v ≥ 3. The exact value needs mod 16: with c mod 4 free, 4c ≡ 4 or 12 (mod 16), so r ≡ n − 4 or n − 12 (mod 16), and **n mod 16 is not determined by n mod 24** either way. The class splits, with the better of the two options available at each n: v = 3 and η₂ = 1/4, or v = 4 and η₂ = 1/8. That affects the F = 4 entry at three classes, 5, 13 and 21. **None of them is a class whose optimum takes F = 4**, so the loosening is harmless here and the guarantee at those cells is unchanged or better. Of the classes that do take F = 4, **11 and 23 have r ≡ 3 or 7 (mod 8), hence v = 1 exactly** — the smallest value available, pinned, and undisturbable by any deeper modulus, which is why no deeper modulus can disturb them. Classes 7 and 15 sit outside the F = 4 group entirely, to an F = 2 reading at η = 1/2 (§3.3.5), so no class whose optimum takes F = 4 is exposed to the mod-16 refinement. **The binding cells are precisely those where the 2-adic valuation is pinned at the bottom, and there it is pinned at v = 1 for both mod-24 residues of the class** — which is why no modulus deeper than 12 appears in the table, though mod 8 appears in the derivation (§3.3.4).

*What this fixes and what it does not.* The η values are consequences of the congruences, so they can be checked by hand and do not rest on a search. What is not settled here is **supply**: that primes of the required form r = 2^v·q^e + 1 exist near the balance point in the density §3.4's windowing needs is a Bateman–Horn statement, exactly as elsewhere in this section. The congruence analysis answers whether such an r is *obstructed*, not whether it *occurs*.

#### 3.3.5 The ceiling table

> **These are ceilings of the family, hence floors for μ — they do not bound δ(n).** The number in each row is the most the balanced shape can extract in that class, so it is exactly the δ₀ of the ladder: μ(n) ≥ δ₀·C(n,2) whenever n admits the representation. Other shapes routinely do better and are not constrained by it. A single fused class reaches 1/F and so exceeds every row here; at odd n the shape 2^a + r\* sidesteps the three-class balance entirely — n = 1015 = 512 + 503\* gives δ = 0.24534 against 0.08579 for its class. Over the computed table **91 values in class 11 (mod 12) alone exceed 0.05051 — the old class-23 figure, and still a useful low-water mark for this purpose — the largest being 0.20168**. Read the rows as "what this family guarantees", never as "what n can achieve".

| n mod 12 | which rung attains the cap | shape | η | **x\* = c/n** | x\* | cap, closed form | cap |
|---|---|---|---|---|---|---|---|
| 0, 4, 6, 10, 12, 16, 18, 22 | k = 1, no fusion question | S3 | 1 | **1/2** | 0.50000 | **1/4** | 0.25000 |
| 2, 8, 14, 20 | k = 1, no fusion question | S3 | 1/3 | **(√3 − 1)/2** | 0.36603 | **(2 − √3)/2** | 0.13397 |
| 1, 9, 13, 21 | **B alone** | S7 at F = 2 | 1 | **(2 − √2)/2** | 0.29289 | **3 − 2√2** | 0.17157 |
| **3, 7, 15, 19** | **B alone** | S7 at F = 2 | 1/2 | **1/4** | 0.25000 | **1/8** | 0.12500 |
| 5, 17 | **B alone** | S7 at F = 2 | 1/3 | **(√6 − 2)/2** | 0.22474 | **5 − 2√6** | 0.10102 |
| **11, 23** | **F = 4** | S7 at F = 4 | 1/3 | **(2 − √3)/2** | 0.13397 | **7 − 4√3** | 0.07180 |

> **The rung column answers "which (F, η) pair attains the cap here."** The cap is a *joint* optimum over the fusion count and the efficiency, not an optimisation of η at a rung fixed in advance: cap_F(η) = η/(1 + √(Fη))² is decreasing in F at fixed η, so fusing is never worth doing for its own sake, and is worth doing only when a larger F moves r into a residue class carrying a better η. §3.3.4a gives the η available at each (class, F) and `fusion-count-ceilings.md` works the trade-off; the entries here are their output.

> **At odd n the fusion count must be even, and the search over F is finite.** With c odd and r an odd prime, n = F·c + r forces F even: odd F makes Fc odd and r = n − Fc even. The F-search then closes on an argument needing no arithmetic at all — since η ≤ 1, **cap_F(1) = 1/(1 + √F)²** bounds the entire F-slice, and that is below 7 − 4√3 for every F ≥ 8. So only F ∈ {2, 4, 6} can attain any of these caps, and §3.3.4a gives their efficiencies. At **7 and 15** the tabulated cap is cap₄(1) = 1/9, which *is* the absolute ceiling at F = 4, so those two rows cannot be improved by any fusion count at any efficiency.

> **Where F = 4 beats F = 2, and why it is a mod-8 effect.** At F = 4, 4c ≡ 4 (mod 8) for every odd c, so r ≡ n − 4 (mod 8) is pinned with no condition on c at all, giving v₂(r − 1) = 1 and no 2-adic cut on the foreign efficiency. At F = 2, by contrast, 2c ≡ 2 or 6 (mod 8) according to c mod 4, so r reaches **two** residues mod 8 — and they differ by 4, hence agree mod 4, which bounds what the choice can buy.
>
> **At 11 and 23, F = 4 wins**: the two F = 2 options both land on r ≡ 1 (mod 4), so with the ℓ = 3 obstruction the best F = 2 can reach is η = 1/6 and cap₂(1/6) = 0.050510 < 7 − 4√3. The D = 24 obstruction is a property of F = 2 at those classes.
>
> **At 7 and 15 it loses.** There the choice in c mod 4 puts r ≡ 5 (mod 8) within reach, so F = 2 attains η = 1/2 and cap₂(1/2) = 1/8, above the F = 4 value 1/9. The resulting (F, η, x\*, cap) is **identical to that of classes 3 and 19**, so 7 and 15 sit in that row rather than in one of their own — which is why the odd part of the table has six constants and not seven.
>
> **A gotcha in this box's shape.** The tempting inference is that a fused rung must pay for its fusion count out of the 2-part of c − 1, making the whole comparison a statement about c. It is not: the matching term is F·x² unconditionally (§3.2.3), and every congruence above is on **r**. Any argument here that constrains c is either steering r or wrong.
>
> *Confirmed independently of the congruence argument.* `ceiling_rederive.py` scans real configurations of the generic family — c a prime ≥ 5, twist a prime power at q ≥ 5, F even — and takes the empirical sup of density per residue class, with the four escapes of §3.3.8 excluded. Over n ∈ [45000, 90000] the sup at classes 7 and 15 is 0.124987 and 0.124985 against 1/8, attained at F = 2, η = 1/2 and c/n = 0.24999, 0.25001 against the predicted x\* = 1/4 — and **both witnesses sit at c ≡ 1 (mod 4)** — the branch a c-congruence would have excluded. At 11 and 23 the same scan returns 0.071791 and 0.071793 against 7 − 4√3 = 0.071797, attained at F = 4, η = 1/3, x\* = 0.13398 against 0.13397: **unchanged, as the F = 4 argument requires.** All eight other odd classes reproduce their tabulated constants to four places from below. *(Run without the escape filter and the sup exceeds the cap at 5, 11, 17 and 23 — by 1.48× at class 11 — every time via c or oddpart(r−1) a power of 3. Those are §3.3.8's documented O(n/log n) routes, and their appearance is a check on the filter rather than on the table.)*

> **Where ties come from, and where they do not.** A tie means two shapes return the same *value*. **No congruence on c produces one:** the fused reading returns 2·C(c,2) at every c and so strictly beats the unfused C(c,2), at every residue. Ties arise only when the binding term is one that fusion does not touch — as at n = 247, where a foreign term binds below both intra terms — and that is a property of the configuration, not of c. The identity cap_B(1/4) = cap_C(1/2) is a genuine coincidence of the cap formula at η = 1/2, true as arithmetic, but it does not describe two *reachable* shapes and should not be read as a tie condition.

> **What the merged row hides, and why it is still one row.** *The table now has **six** constants, not seven: classes 7 and 15 joined the 1/8 row when the entangled correction freed c mod 4 (see the box above), so the four residues 3, 7, 15, 19 share it.* The rows group residues sharing a cap, an η and a shape, and they have always grouped residues whose *foreign* residue differs — at (F = 2, η = 1) the four residues 1, 9, 13, 21 split into r ≡ 3 and r ≡ 7 (mod 8) yet share a row. The 11/23 merge is the same convention: with F = 4 the mod-8 condition drops out, both take η = 1/3, and the row entries are identical. Two things they do **not** share, needed downstream:
>
> - **The Bateman–Horn system differs between the class's two mod-24 halves.** The optimum needs r ≡ 7 (mod 24) at n ≡ 11 and r ≡ 19 (mod 24) at n ≡ 23 — the *ceiling* is the same, by the mod-12 law, but the singular series and hence the supply constants are computed per residue, not per row. §3.5's counting keeps them separate.
> - **The second-best shape differs, though its value does not.** Both classes fall to (2 − √3)/4 = 0.066987 if the F = 4 optimum is unavailable, but class 11 reaches that at **F = 2** with η = 1/6 while class 23 reaches it at **F = 6** with η = 1/2 — its F = 2 rung being worthless at η = 1/12. Any argument that needs the *runner-up* rather than the winner must therefore split the row; §7's disjunction-collapse is one such.
>
> Empirically the two behave alike, as equal caps predict: over n ∈ [2·10⁴, 1.2·10⁵] their ladder medians are 0.07047 and 0.07035, their fractions below cap 64.6% and 65.6%, and the regenerated worklist splits 1823 : 1824. The older observation that low-δ values concentrate at n ≡ 23 was largely a **selection effect** — that worklist was thresholded at 0.050510, which was class 23's own ceiling, so 23 appeared on merely falling short of its cap while 11 had to fall 25% below a higher one.

> **A coincidence to keep in view when reading these numbers.** cap₄(η) = η/(1 + 2√η)² is *identically* the two-unfused-block formula cap_C(η) — immediate from cap_F(η) = η/(1 + √(Fη))², since √(4η) = 2√η. One orbit of four fused blocks and two unfused orbits are different configurations, in different census rows, with different part counts, and they agree at every η. So a matching value says nothing about which shape produced it: (5 − 2√6)/2 is both cap_C(1/6) and cap₄(1/6), and reading the old class-23 ceiling as an F = 4 rung on that basis would be an error.

Every entry is a unit in ℤ[√d] over a small denominator, as it must be, since only F and η enter. The pairings come from **cap_F(η) = cap₁(Fη)/F**, immediate from the closed form: one rung's value at η is exactly half the next rung's at 2η. Visible here as **3 − 2√2** at (F = 2, η = 1) against **(3 − 2√2)/2** at (F = 4, η = 1/2), and **5 − 2√6** at (F = 2, 1/3) against **(5 − 2√6)/2** at (F = 4, 1/6) — the latter being the value the class-23 row carried before the F = 4 optimum was taken.

#### 3.3.7 The global constant, and which residue attains it

Six distinct ceilings, keyed mod 12. **The global asymptotic constant is the smallest of them: 7 − 4√3 = 0.071797, attained at n ≡ 11 (mod 12)** — the two residues carrying the ℓ = 3 obstruction at odd n, which caps their efficiency at η = 1/3 even once F = 4 removes the 2-adic cut. That is the constant §5's floor is stated against.

> **Why it is a tie between two residues rather than a single worst class.** Taking F = 4 removes any mod-8 dependence from the *outcome* — 4c ≡ 4 (mod 8) for every odd c, so r ≡ n − 4 (mod 8) is pinned and gives v₂(r − 1) = 1 at both 11 and 23 — leaving only the ℓ = 3 obstruction, which sees n mod 12 and cannot distinguish them. So the two halves of n ≡ 11 (mod 12) are equal — as, by §3.3.4, are the two halves of every class. **Gotcha, and a useful invariant:** a ceiling table that separates any a from a + 12 must be getting it from a mod-8 condition, and the only mod-8 condition in the derivation — F = 4's pinning of r ≡ n − 4 (mod 8) — is constant on the mod-12 class. So such a separation is a bug, not a refinement.

#### 3.3.8 Routes above the ceiling, and how the table is validated

> **Four routes lift individual n above the ceiling for their residue**, each by supplying a block whose size is a power of a fixed small prime, so that the divisibility which kills primality is harmless:
>
> - the ℓ = 3 residues when (r−1)/2 or c is a power of 3;
> - the ℓ = 2 residues when c is a power of 2, which turns the shape into the two-part 2^a + r\*;
> - the ℓ = 2 residues when r = 2^a·u + 1 with u a small odd prime power, so that rung B′ is available at a usable η — the u = 1 (Fermat) case being the commonest, with 20 instances in range at r = 257;
> - the odd residues when a cyclic-layer-fused class of **odd** F — 3 or 5 blocks — is available, which at odd n forces c = 2^a and so is an escape. **Even F is not on this list**: at odd n, F·c is automatically even, c is unrestricted, and F = 4 is not an escape but the shape that *sets* the ceiling at 11 (mod 12) (§3.3.5).
>
> **All four are O(n/log n) in n, and §4.3 proves it.** Each supplies O(1) usable block sizes per n, because the ceiling itself confines the block to a bounded ratio range; the remaining freedom is one prime, and that is where the log comes from. So they lift a vanishing proportion of n and leave the asymptotic constants untouched — but the proportion vanishes only logarithmically, so at any computed range they are visible rather than negligible.


> **What bounds an individual row is cap_F(η), not its class ceiling.** Against the current data, **194 of the 1,108 two- and three-class one-foreign winners exceed their own class's tabulated δ₀** — 57 via the 2^a + r\* route, 43 via the fused 2×c + r\* route, and 94 via an η above the class's generic value, mostly the 3-power escapes. In class 11 the *median* winner sits at 1.24× the tabulated cap and 28 of 39 exceed it, with a maximum of 3.99×. So δ₀ is a guarantee for one specific balanced shape and not a description of typical behaviour; "generic ceiling" is the wrong reading of it. What *is* an upper bound, and holds without exception, is cap_F(η) evaluated at the configuration's own F and η: **0 of 1,108 rows exceed it**, and over the 58 fused-class-plus-foreign winners the maximum observed is 0.16138 (n = 639), 94% of cap_2(1).

*How this is validated, and why the maximum alone would not do it.* A class maximum meeting its cap only shows the cap is **attainable**; it is met whenever some n in the class happens to have a good representation, and would go on being met even if a further condition were quietly suppressing most of the class. Two stronger checks are therefore needed, and both pass.

*Upper: no row exceeds its own cap.* Computing each winner's actual efficiency from its own foreign block and top prime, and comparing its density against cap(η) for that efficiency: over all **1,167** two- and three-part winners — 1,108 of them checkable by the automated re-derivation, which covers every unfused one-foreign row — **zero exceed it**. So δ(x) = min(x², 2x(1−kx), η(1−kx)²) bounds every individual row, not just the extremes.

*Lower: the distribution is uniform across classes.* An unmodelled obstruction acting on some residue would show as that residue failing to reach its cap, or as its bulk sitting systematically lower than its siblings'. The check must normalise by the **mod-24** cap and must **not** pre-filter by efficiency. Restricting to winners running at their class's generic efficiency is the natural-looking simplification and is exactly the filter that hides the escape rows, so a check written that way cannot detect an error in the class → η map at all — which is the one thing it is for. Over the whole table, normalised by cap(own η): every residue lands in 0.28–0.998, none exceeds 1. Normalised by the residue cap, the escapes push a minority above 1, quantified in §4.3. The per-residue δ/cap minima from `ladder_verify.py` run **0.327–0.653** at N = 20,000, which is the spread expected from representation availability alone. Note that the odd-residue end of that range moved once the script was taught the two F = 2 fused rungs: eight of the nine rung-B residues rose by 0.03–0.15 (worst odd residue 0.385 → 0.450) while **no even residue moved**, which is the control, since fusion does not arise at k = 1. Before that fix those eight were being measured against a ceiling the script structurally could not reach.

**The ℓ = 3 obstruction has an escape, reaching O(n/log n) values (§4.3).** If (r−1)/2 or c is itself a power of 3, full efficiency returns, because the divisibility that kills primality is harmless for prime powers. In range this lifts n ≡ 5 (mod 12) to a maximum of 0.10975 — but 22 of those 35 rows use the *same* foreign prime r = 487, with (r−1)/2 = 243 = 3⁵, and the others use r = 163 with 81 = 3⁴ or c = 243, 729. Candidates of the form r = 2·3^k + 1 are as thin as any other exponential family, so the escape supplies O(log n) candidates rather than n/log³n and should be read as a feature of the computed range. **The generic ceiling 0.0718 is the one to quote asymptotically.**

**Downstream.** The ceilings above are what §3.8 tests, each residue at its own x\*, and what `ladder_verify.py`'s `CAP` is keyed on.

### 3.4 The balanced window, and why it leaves the singular series intact

Every cap above is attained at a specific balance point — x = c/n equal to 1/2 at the unobstructed even classes, or the values in the table — so the representations that matter are not all representations of n but those in a window around that point. Whether the Bateman–Horn heuristic survives that restriction needs checking, because a window shrinking with n would turn each of these into a short-interval problem and put it out of reach.

It does not shrink. Each δ(x) is continuous with an **interior maximum**, so asking for δ ≥ δ₀ at any δ₀ strictly below the cap confines x to an interval of positive length, and that length is a fixed fraction of n rather than a vanishing one. Taking δ₀ = 0.9 × cap in each class:

| class (mod 12) | family, efficiency | F | cap | attained at x\* | x-window | width | F·width |
|---|---|---|---|---|---|---|---|
| 0, 4, 6, 10 | S3, k = 1, η = 1 | 1 | 0.25000 | 0.5000 | [0.474, 0.526] | 0.051 | 0.0513 |
| 2, 8 | S3, k = 1, η = 1/3 | 1 | 0.13397 | 0.3660 | [0.347, 0.399] | 0.051 | 0.0513 |
| 1, 9 | S7 at F = 2, η = 1 | 2 | 0.17157 | 0.2929 | [0.278, 0.304] | 0.026 | 0.0513 |
| **3, 7** | S7 at F = 2, η = 1/2 | 2 | 0.12500 | 0.2500 | [0.237, 0.263] | 0.026 | 0.0513 |
| 5 | S7 at F = 2, η = 1/3 | 2 | 0.10102 | 0.2247 | [0.213, 0.239] | 0.026 | 0.0513 |
| 11 | S7 at F = 4, η = 1/3 | 4 | 0.07180 | 0.1340 | [0.127, 0.140] | 0.013 | 0.0513 |

*Computed from δ(x) = min(F x², 2F x(1 − Fx), η(1 − Fx)²) with x = c/n; the x\* column reproduces §3.3.5's independently, which is the cross-check worth re-running whenever either table moves. This table is keyed mod 12, as §3.3.5 is. **The live hazard, and it is easy to hit: reading an odd row off the unfused rung gives a cap that is a real number attached to a real shape and simply not the class ceiling.***

> **The last column is an exact identity, not a near-coincidence.** For δ ≥ λ·cap the window is bounded by the two branches that meet at x\*: the increasing one gives F x² ≥ λ·F x\*², i.e. x ≥ x\*√λ, and the decreasing one gives η(1 − Fx)² ≥ λ·η(1 − Fx\*)², i.e. Fx ≤ 1 − √λ(1 − Fx\*). Writing u = F x\*, the width is
>
>   (1/F)·[1 − √λ(1 − u)] − (u/F)√λ = (1/F)·[1 − √λ(1 − u) − u√λ] = **(1 − √λ)/F**,
>
> in which η and x\* have both cancelled. So **F·width = 1 − √λ for every row**, here 1 − √0.9 = 0.051317. *Verified numerically at λ = 0.9, 0.99, 0.999 across all six (F, η) pairs, agreeing to seven places.* The rows differ in width only through F, and in the class's own footprint — the block occupies F·c of the n points — they are not merely comparable but **identical**.

So in every class the count required is of primes in an interval of length **c·n for an absolute constant c between 0.013 and 0.051** — not primes in a short interval. (The F = 4 row is the narrowest, at (1 − √0.9)/4 = 0.013, purely because the window is measured in x = c/n while the block occupies F·c of the n points; by the identity above, in the class's own footprint every row has the same width.) That is exactly the regime where the Hardy–Littlewood and Bateman–Horn heuristics are standard: the predicted count over the window is the full-range prediction times the window's measure, up to the smooth variation of 1/log across it, and no short-interval input is needed. The asymptotic ~𝔖(n)·n/log³n of §§3.1–3.2 therefore stands as written, with 𝔖(n) unchanged and only the constant scaled.

Two caveats, both real and both explaining why the observed maxima of §3.3 fall just short of their caps rather than meeting them.

**Approaching the cap costs — but linearly, not as a square root.** Requiring δ ≥ (1−ε)·cap confines x to a window of width (1 − √(1−ε))/F = **Θ(ε)**, by the identity above with λ = 1 − ε, so the predicted count degrades like ε·n/log³n. It stays positive for fixed ε but not uniformly in ε, so the caps remain suprema rather than values guaranteed to be attained at any particular n.

> **Gotcha: the exponent depends on the maximum being a kink, and √ε is the natural wrong answer.** A **smooth** interior maximum gives Θ(√ε) — δ ≈ cap − k(x − x\*)² yields |x − x\*| ≤ √(ε·cap/k) — and every δ(x) here does have an interior maximum, so the smooth estimate looks applicable. It is not: the maximum is where an *increasing* branch meets a *decreasing* one, so the window closes linearly. Check which kind of maximum is in play before quoting a rate.

**Exact balance is arithmetically impossible anyway, though the reason differs by row.** At the even two-part rows with x\* = 1/2 the balance point needs c = r, which admissibility forbids outright, since r is the foreign prime and c the p-characteristic block size and r ≠ p is required. At the odd rows c ≠ r at balance and the obstruction is instead integrality: x\* is irrational at 1, 9, 5 and 11 (mod 12), and at 3, 7 (mod 12), where x\* = 1/4 is rational, n is odd so c = n/4 is not an integer. Either way the caps are approached and never met, independently of any analytic question. *(The earlier form of this paragraph asserted that the three-part family needs c = r = n/3 at balance. No row has x\* = 1/3 — the three-part balance points are 0.2929, 0.25, 0.2247 and 0.1340 — so that was a legacy statement from an equal-three-part reading and has been replaced.)*

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

> **Hypothesis (H).** Write (F, η) for the fusion count and efficiency that attain n's class ceiling, as tabulated by residue mod 12 in §3.3.5 — so **F = 1** at even n, **F = 2** at n ≡ 1, 3, 5, 7, 9, 13, 15, 17, 19, 21 (mod 24), and **F = 4** at n ≡ 11, 23 (mod 24) — classes 7 and 15 having moved from F = 4 to F = 2 under the entangled correction (§3.3.5) — and put **d = 2/η**. Then every sufficiently large n admits a prime q, a prime r and a prime power c with
>
> 1. **the shape** — **n = F·c + r**, with F as above;
> 2. **the balance** — c/n lies in the window around n's own balance point x\* = √η/(√F(1 + √(Fη))), as tabulated by residue class mod 12 in §3.3.5; equivalently δ ≥ (1 − ε)·δ₀(n) for a fixed ε > 0;
> 3. **the efficiency** — r = d·q + 1 with **d ∈ {2, 4, 6, 12}**, the value being the one §3.3.4a makes available at n's (class, F): d = 2 at the unobstructed even classes and at 1, 9, 13, 21; **d = 4 at 3, 7, 15, 19**; d = 6 at 2, 8, 14, 20, at 5, 17, and at **11, 23**; d = 12 at none of the ceiling-setting cells, since at class 11 the F = 4 reading at d = 6 beats the F = 2 rung that would need it;
> 4. **coherence** — r ∤ c − 1, so that the cyclic layer stays cyclic with the c-block at full twist.
>
> **There is deliberately no clause on c.** The intra term is F·x² at every c, since a fused matching class keeps its full twist (§3.2.3), so a congruence condition on c would both be unnecessary and cost a factor 2 in supply for every fused shape. If one appears in a derivation here, it is steering r (§3.3.4a) or it is wrong.
>
> Condition 3 delivers a foreign twist of order q, hence efficiency η = 2/d; conditions 1–2 place the configuration at its class ceiling; condition 4 is Lemma C. Given all five, Part E of `enumeration-proof.md` builds an Oliver group with m\* ≥ δ₀(n)·C(n,2), which is the ladder's top rung (Proposition 5.2′ of the notes) and the asymptotic half of §5's floor conjecture.
>
> **The F = 4 clause is not a refinement but a load-bearing one.** The two residues that attain the global constant 7 − 4√3, and hence set §5's asymptotic floor, are 11 and 23 — both F = 4. A version of (H) quantifying only over n = 2c + r at odd n does not deliver δ₀ at those two classes, so it does not imply the floor it is invoked for.

Several things about the statement have been settled elsewhere in this document and should be read into it.

#### 3.5.4 What the four clauses rest on

*(Shape, balance, efficiency, coherence — and deliberately nothing on c; see the box under the statement.)*

*Why d runs exactly to 12.* The table below is the **local-solubility** statement for the two- and three-part shapes, i.e. F = 1 and F = 2; the F = 4 cells are read off §3.3.4a instead, which computes η at each (class, F) directly, and they need only d = 2 and d = 6. Every permitted d is even, since q is odd and r = dq + 1 must be an odd prime, and every permitted d has all its prime factors in {2, 3}, which is what confines the local analysis to ℓ ≤ 3 (§3.3, and the leading-coefficient caveat there: a d with a larger prime factor would open a degeneration channel at that prime, as d = 6 already does at ℓ = 3 when 3 | n − 1). Writing d = 2e, the leading 2 makes r odd, the 2 in e fixes n mod 4 — through the halving in c = (n − r)/2, which is why the second factor of 2 appears only in the odd case — and the 3 in e fixes n mod 3. Hence e | 6 and **d ≤ 12**, with the admissible d by class:

| n mod 12 (at F ≤ 2) | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| admissible d | all | 2 | 6, 12 | 4, 12 | 2, 4 | 6 | all | 4 | 6, 12 | 2, 6 | 2, 4 | 12 |

The efficiencies η = 2/d this yields are exactly the η column of §3.3's ceiling table: d = 2 gives η = 1 at n ≡ 1, 9 (mod 12) and at the unobstructed even classes, d = 4 gives η = 1/2 at 3 and 7 (mod 12), i.e. at 3, 7, 15, 19 (mod 24), d = 6 gives η = 1/3 at 5 and at the even classes 2 and 8, and d = 12 gives η = 1/6 at 11 **under F = 2** — the two tables being the same fact read from the two ends. At the **two** residues where F = 4 attains the ceiling — 11 and 23 — the relevant η is §3.3.4a's and the d it calls for is 6; classes 7 and 15 now take F = 2 at d = 4, alongside 3 and 19. So d = 4 covers four residues rather than two, and d = 12 survives in clause 3's list only as the F = 2 value at class 11, which the F = 4 optimum supersedes.

Every class has at least one admissible d, so **(H) is locally soluble at every n**, and by §3.3's uniform bound its singular series is bounded below by an absolute constant rather than merely being positive. What is unproven is existence, not local solubility.

*Why the list and the ceilings are keyed alike, at mod 12 — and why that is a coincidence.* These are **different questions**: the admissible-d table above is about **local solubility**, which systems are not identically obstructed, decided by ℓ = 2 and ℓ = 3; the ceiling table of §3.3 is about **which rung is reachable**, which turns on the 2-adic structure of r − 1 and on F. They happen to answer at the same modulus — at F = 2 reachability depends on n only mod 4, and the mod-8 condition at F = 4 is constant on the mod-12 class (§3.3.4). (H) quantifies over local solubility, with condition 2 absorbing reachability. **Gotcha: do not treat the shared modulus as an identification.** Nothing here says a wider shape space would keep the two aligned, and an argument that silently transfers a fact from one table to the other because "both are mod 12" is unsupported.

*What c mod 4 does, given that (H) imposes nothing on it.* It steers, per §3.3.4a: **at F = 2, c mod 4 chooses between two reachable r mod 8; at F = 4, 4c ≡ 4 (mod 8) for every odd c, so c mod 4 is free and inert.** That is the whole of its role — a parameter to be chosen, never a condition to be met. With clause 3's values, **d ∈ {2, 4, 6, 12} suffices to attain every ceiling**; larger d describe alternatives rather than requirements.

*(H) is not of Goldbach type alone.* n = c + r with both prime is Goldbach-like; r = dq + 1 with both prime is a Sophie Germain condition, independently twin-prime-hard. Neither implies the other and (H) demands both on the same variable. Nor is it implied by Chowla, or it by (H) — §3.6 places it as the **θ = 1 endpoint** of the shifted-prime ladder, which is a scale on which the current unconditional value is 0.679.

#### 3.5.5 What this means for the framework

**What this means for the framework.** The ladder's conditional results should be read as conditional on a *parametric* hypothesis of Goldbach type, not on Bateman–Horn. The distinction matters in two places. It explains why §3.4's window analysis is needed at all: for a fixed system one would simply count solutions up to X, whereas here the solutions live in a window proportional to n and one must check that the window does not shrink. And it explains why §6's covering formulation is the right shape — a disjunction over a finite family of parametric systems is exactly what a lower bound on μ can deliver, and is strictly weaker than any single system's solvability.

#### 3.5.6 Which families are polynomial in q, and which are not

**The shapes of §6 already link their parts, so linkage is not what distinguishes the fallback families.** §3.3's system is three conditions in *one* variable — f₁(r) = r, f₂(r) = (r−1)/2, f₃(r) = (n−r)/2 — because c is determined by r and n; the coprimality budget and the distinct-foreign-prime rule are inter-part constraints too. What varies between families is not whether the parts are linked but **the degree of the system in its natural variable**, and for the fallback families that variable is the top prime q rather than a block size. `count_check.py --dq D` already scans this way: r = Dq + 1 and c = h − (D/K)q.

Write a foreign block's twist as t = q^e and its cofactor as u = (r − 1)/t. The gate orb(r, t) ≥ B forces **t ≥ B/r ≥ δn/2**, hence **u ≤ 2/δ** and **q ≥ (δn/2)^{1/e}**. Three regimes follow, and they are genuinely different objects:

| regime | r as a function of q | supply of admissible r near δn | standing |
|---|---|---|---|
| **e = 1** | r = uq + 1, **linear** | positive density | an ordinary parametric family, no different from S3's |
| **e ≥ 2 fixed** | r = u·q^e + 1, degree e | ~N^{1/e} up to N, so **density zero** | still Bateman–Horn, but available at almost no n |
| **q fixed, e varying** (in practice q = 2) | r = u·2^e + 1, **exponential** | — | **outside Bateman–Horn**: no polynomial to apply it to |

> **The middle column is where the reasoning is easy to get wrong, so it is worth stating carefully.** The density-zero claim is *not* that n must be of the form u·q^e — n is given, not constructed. It is that the primes with r − 1 = u·q^e and u bounded are themselves sparse, about N^{1/e} up to N, so the chance that one lands in the window near δn is about n^{1/e−1} → 0. The sparsity is in the **supply of foreign blocks**, not in n, and the two would suggest different repairs.

**This is the polynomial-versus-exponential line that Jones–Zvonkin draw explicitly** and that `literature-findings.md` item 14 asks us to draw: their Mersenne-like families are outside the conjecture's scope for exactly the reason the third row is. Ours coincides with the **Fermat** branch of §3.3.2, r − 1 = 2^a, which is also where the q-pinning of `enumeration-proof.md` Part E″ goes vacuous — a modulus of 2 constrains nothing. So the two escapes are one phenomenon seen twice: the family stops being polynomial in q.

**Consequence for how the collapse is certified.** A family whose members are available at a density-zero set of n cannot be dispatched by a per-shape argument, because at the sparse n where it *is* available it may well be the optimum. **That is why `enumeration-proof.md` Part E′ certifies the collapse per n rather than per shape** — the per-n certificate is the right instrument for a family with density-zero members, not a stopgap for a missing theorem.

### 3.6 What the conjectures give: the shifted-prime ladder, and effectivity

**The route's strength is a single parameter.** The efficiency condition — that r − 1 carry a large prime-power divisor — is what couples this framework to the literature on shifted primes, and the coupling reduces to one exponent. Write θ for what can be guaranteed in P(r − 1) > r^θ. The foreign block then contributes qr ≥ r^{1+θ}, and with r of order n the family delivers roughly **n^{1+θ}**. Every result in this area is a value of θ:

| input on shifted primes | θ | quantifier | edge bound | who proved / conjectured it | who connected it to this framework |
|---|---|---|---|---|---|
| Bombieri–Vinogradov | 1/4 | all large n | n^{5/4+o(1)} | Bombieri, A. I. Vinogradov (1965) | **Shparlinski**, Thm 1 (2014) — unconditional, matching BBKN's ERH bound without ERH |
| Chowla-type | 1/2 | all large n | n^{3/2−ε} | conjectural (Chowla) | **BBKN**, Thm 1.4(a) |
| Baker–Harman, positive relative density | 0.677, now **0.679** | **almost all** n | n^{1.677} | Baker–Harman; 0.679 by **Runbo Li**, arXiv:2508.18285 (2025) | **Shparlinski**, Cor. 3 (2014); the 0.679 update is ours |
| Elliott–Halberstam | → 1 | all large n | n^{2−o(1)} | conjectural (Elliott–Halberstam) | **Shparlinski**, §5 remark (2014), at n^{3/2} |
| ERH | — | all large n | n^{5/4−ε} | conjectural | **BBKN**, Thm 1.4(b) — **superseded**: Shparlinski's Thm 1 reaches this unconditionally |

> **Two attributions are being tracked here and they come apart, which is the point of the last two columns.** The arithmetic inputs are not ours and are not new; what varies is *who noticed that this framework consumes them*. BBKN state the θ = 1/2 and ERH rungs; Shparlinski isolates the max-min as a named function and supplies the unconditional 1/4 rung and the almost-all 0.677 rung; **what is ours is the 0.679 update, the observation that the whole picture is one parameter θ, and the identification of (H) as its θ = 1 endpoint.** A reader should be able to see at a glance that the ladder is a survey with two original entries rather than a contribution.
>
> **One row is a trap.** The ERH rung is still quoted in some presentations as the state of the art for all large n; it is not, since Shparlinski (2014, Thm 1) reaches n^{5/4+o(1)} unconditionally. Any comparison of ours against "the ERH bound" is against a superseded baseline.
>
> **The quantifier column is not decoration.** The two strongest exponents — 1.677 and 3/2 — both carry exceptional sets (O(x^{0.354}(log x)⁴) and O((log x)⁴) respectively). On the *all large n* row the unconditional state of the art is 5/4. Omitting the quantifiers would mislead **in our favour**, which is worse than misleading against us.
>
> *Primary-source check still owed:* the attribution of the θ = 1/4 rung to Bombieri–Vinogradov is taken from Shparlinski's framing rather than read off the original, and the Chowla row is a conjecture-type rather than a specific citation. Both want checking against primary sources before publication.

Hypothesis (H) of §3.5 above is the **θ = 1 endpoint** of this ladder. Stating it that way is more informative than calling it a barrier: it places the hypothesis on a scale with a known current value rather than in a separate category.

**The ceiling on the route is technological, not conjectural — and this distinguishes it from Chowla's 1/2.** Chowla's exponent is the value a *conjecture* buys; beating it means assuming something else. Baker–Harman's is the current output of a *method*, and the method's limit is a **level-of-distribution barrier**: results of this shape rest on Brun–Titchmarsh on average, i.e. on controlling primes in progressions to moduli beyond x^{1/2} — exactly the gap between Bombieri–Vinogradov and Elliott–Halberstam. The exponent moves whenever that control does, and it has: 0.677 became **0.679** on Maynard's triple-convolution estimates, in the lineage that took Bombieri–Friedlander–Iwaniec's x^{29/56} to Maynard's x^{11/21} and Lichtman's x^{17/32}. So θ → 1 is not a separate wish; it *is* level → 1, which is Elliott–Halberstam.

**It is the shifted-prime condition specifically that imposes this.** Binary Goldbach in the almost-all regime carries no such condition, which is why Montgomery–Vaughan settles it unconditionally with a power-saving exceptional set. Adding "and r − 1 has a large prime factor" couples the problem to primes in progressions to large moduli and puts it behind the barrier. The condition that buys the density is the same condition that caps the exponent.

> *Transferring the ladder needs no work, and the reason is a one-line domination.* θ is stated for the largest **prime** divisor of r − 1, while the efficiency η of §3.3 is built from the largest prime **power** divisor of the odd part, together with the 2-part. Those are different quantities, but they are ordered the convenient way: **the largest prime-power divisor is at least the largest prime divisor**, and if a prime q ≥ r^θ divides r − 1 then the q-part of r − 1 is at least q ≥ r^θ. So every rung above is a valid lower bound on this framework's quantity **verbatim**, with no transfer of proof and no loss. Nothing needs re-deriving in the prime-power setting, and (H) is the θ = 1 endpoint without qualification.
>
> The same domination imports the *density* results in this area for free — statements of the form lim inf |{p ≤ x : P(p−1) ≥ p^c}| / π(x) ≥ 1 − c for c ≤ 1/2, and the improvements on them — since a lower bound on the largest prime divisor is a lower bound on the largest prime-power divisor. What the domination does **not** give is the converse: an upper bound on this framework's η does not follow from an upper bound on P(r − 1), so the ladder's *ceiling* arguments, and the level-of-distribution barrier below, are about the literature's quantity and are not automatically about ours.

**On effectivity.** Whichever rung is in play, the conjecture supplying it has no error term: Bateman–Horn and Hardy–Littlewood alike assert π_f(x) ~ (1/D)·𝔖(f)·∫₂^x dt/(log t)^k, a bare asymptotic with an ineffective implied constant. It says nothing about any specific n, so what is uncovered is not a middle interval that computation might close from below — it is everything above wherever the computation stops.

The conjectured square-root refinement π_f(x) = (1/D)·𝔖(f)·Li_k(x) + O_ε(x^{1/2+ε}) does not help, being the wrong shape: it bounds the *counting function up to x*, while the families need a representation at each individual n, and an exceptional n contributes O(1) to a count whose error term is a power of x. Nor is uniformity in n a free hypothesis — Friedlander and Granville showed that sufficiently uniform versions of Hardy–Littlewood-type conjectures are false outright.

**The natural next rung is an exceptional-set bound**, not because it would be better than an all-n statement — it would not — but because it is strictly weaker and is where progress on problems of this shape has historically come first. "All but O(x^θ) of n ≤ x admit a representation", for some θ < 1, is exactly the form Montgomery–Vaughan and then Pintz achieved for binary Goldbach, and results of that shape are sometimes effective. An effective one here, combined with verification up to N, would give an unconditional density statement about the ladder — which no amount of asymptotic Bateman–Horn can, at any rung.

**One consistency check worth recording.** The obstructions of §3.3 were derived there from the structure of r − 1 — which twists Lemma B′ permits. They also fall out of the singular series: 𝔖(n) vanishes precisely when ω(2) = 2 or ω(3) = 3, which is exactly n ≡ 3 (mod 4) or n ≡ 2 (mod 3). Two independent routes to the same obstructions.

### 3.7 Empirical data on the existence of representations

*The conjectural apparatus of §3.6 is asymptotic and ineffective. What §5 actually needs at each n is not that apparatus but a finite check, and the finite check is cheap. This section is what that check returns; §3.8 is the finer question of whether the **number** of representations matches prediction.*

**The quantity §5 needs is computable directly and cheaply.** At each n it is not an asymptotic count of representations but the best density the families actually achieve — a sieve computation costing O(n/log n) against the n^2.9 of computing B(n). The asymmetry is what lets the floor be verified far past the range where μ(n) is known.

> *Verified* (`ladder_verify.py`). Over every composite non-prime-power n ≤ 10⁶ — all twenty-four residues, no eligibility filter — the best density the four families achieve is at least **0.04453**, attained at **n = 11183**, and **no value falls below 1/25**. That is a direct verification of §5's conjecture over a range roughly 380× wider than where μ(n) itself is known, and with a factor of 1.11 to spare. The floor is set at n = 11183 and does not move again: over the remaining 989,000 values nothing undercuts it.

So the picture is not "computed below, conjectural above" with an unreachable band between. What is known, and how:

| | range | status |
|---|---|---|
| μ(n) known exactly | the computed table | computed |
| collapse B_refined = B_safe certified | n ≤ 100,000 | computed from lower bounds (Part E″), at **every** composite non-prime-power value, 90,299 of 90,299 |
| global floor δ ≥ 0.04453, hence δ ≥ 1/25 | n ≤ 10⁶ | computed (§5), from the four-family ladder alone |
| global floor δ ≥ 1/25 | n > 10⁶ | conjectural, ineffectively |

**Where the verification is hardest is a middle range, and it is bounded.** The lower envelope of achievable density does not fall away as n grows — it dips and then recovers. Minimum bound over the **46,520-entry** worklist, by decade:

| n | entries | minimum bound | attained at |
|---|---|---|---|
| [10², 10³) | 6 | 0.05703 | 527 |
| [10³, 10⁴) | 251 | 0.04574 | 1817 |
| **[10⁴, 10⁵)** | 3,435 | **0.04453** | **11183** |
| [10⁵, 10⁶] | 42,828 | 0.05603 | 173627 |

The global minimum is the third row, and it is **fixed by n = 20,000**: over the remaining 980,000 values of the scan nothing undercuts n = 11183. The per-block floors climb steadily thereafter — 0.05603, 0.05928, 0.06209, 0.06150, 0.06363, 0.06415, 0.06499, 0.06590, 0.06478 across the blocks of 10⁵ — which is the recovery, not noise.

> **The worklist is an even split between the two extremal classes, which is the mod-24 prediction landing hard.** Of the 46,520 entries, **23,372 (50.2%) are n ≡ 11 (mod 24) and 23,102 (49.7%) are n ≡ 23**, with 43 spread across the other residues. Those two classes share a ceiling (§3.3.5), and the split is as even as one could ask for. It is worth remembering what a worklist thresholded at a class ceiling can and cannot show: the earlier list, cut at 0.050510, was 99.92% class 23 — not because class 23 is worse but because that number *was* class 23's ceiling under the F = 2 rungs, so it appeared on merely falling short while class 11 had to fall 25% below a higher one. **A residue's prominence in a worklist is a fact about the threshold, not about the residue.**

> **The families are not underperforming at the extremal classes.** The per-residue min-ratio column of the scan puts n ≡ 23 at 0.620 of its cap and n ≡ 11 at 0.671, against a spread from 0.327 (n ≡ 16) to 0.671 across all twenty-four. The two lowest-cap classes are mid-range in *relative* shortfall, and the even classes fall proportionally further from their caps. So the low absolute floor at n ≡ 23 comes from its cap being lowest, not from a family the ladder is missing there — which is the check worth running whenever a class dominates the low tail.

> **The per-residue diagnostic saturates early, so extending N does not test it further.** Every one of the 24 per-class minima is attained below n ≈ 12,000 — the largest are n ≡ 23 at 11183 and n ≡ 11 at 6275 — so the min-ratio spread is the same at N = 20,000 as at N = 10⁶. Read it as a statement about small n, and do not expect a wider scan to move it.

**The dip has a structural explanation, and it is the two engines handing over.** Below ~500 the multiplicative shapes are still plentiful — S1 at every prime power, S2 wherever ω(n) = 2 with both factors prime powers, which is 57.5% of winners below n = 400 — and they carry densities far above any additive ceiling. Above ~10⁴ the additive families have enough supply near their balance points to sit close to those ceilings. **In between, S1 and S2 have thinned but S3, S4 and the fused rungs — at F = 2 and F = 4 alike — have not yet saturated**, and the escapes of §4.3 are themselves at their least helpful. Every value that has ever set a running floor lies in this band — 575, 935, 1817, 2183, 2303, 3479, 9911, 11183 — and the current global minimum, n = 11183, sits at its upper end.

So the uncovered region is not open-ended. It is a *finite* interval, roughly [500, 10⁴], where verification is most needed and has been done exhaustively — and above it the empirical trend runs toward the ceilings rather than away.

### 3.8 Empirical data on the density of representations: the prediction tested by counting

*The ceilings of §3.3 come from a singular series being **positive** — a solution exists near the balance point. The heuristic says more than that: it predicts a **count**. This section tests the count, at every residue mod 24, each at its own ceiling's balance point. `count_check.py`.*

**The system.** A foreign block r carries a twist of order t dividing r − 1, with efficiency η = 2t/(r−1) for odd t — so **η = 2/D exactly when r − 1 = D·t**. Taking t = q prime, the three forms are

> f₁ = q,  f₂ = D·q + 1 (= r),  f₃ = (n − 1 − D·q)/K (= c)

with K = 1 for the even family n = c + r of §3.1 and K = 2 for the odd family n = 2c + r of §3.2. A solution is a q making all three prime, with c in a window around x\*.

**Testing at the right centre is the whole point.** The count is taken over a window centred on x\*, and x\* = √η/(1 + k√η) equals the equal split 1/(k+1) **only at η = 1**. At the obstructed residues they diverge sharply — at (C, η = 1/6) the equal split sits 0.109 from x\* = 0.22474, more than twice the window half-width — so a window centred on the equal split covers a region that cannot reach the ceiling at all, and a count taken there says nothing about attainment. Each row below uses its own residue's x\*, taken from the table in §3.3 — including the **F** column, which is 4 at the residues 7, 11, 15 and 23 whose ceiling the F = 4 shape attains, and where the system is therefore c = (n − r)/4 rather than (n − r)/2. Those four rows need the F = 4 optima rather than the F = 2 ones, which required extending `count_check.py` to fusion counts not dividing D, and turned up three defects in its local-factor computation, all inert at F ≤ 2 (`pending-checks.md` R9).

**How the prediction is computed.** The window has a fixed *relative* width, so the three log factors are not constant across it — at D = 12 the parameter q sweeps a factor of about 1.9 from one end to the other. The predicted count is therefore the integral of 𝔖(n)/(log q · log r · log c) across the window rather than its value at the midpoint. The two differ by well under a percent, and by more at larger D since log q ≈ log(n/(3D)) is smaller there, so nothing below turns on the choice; the integral is simply the quantity the heuristic actually predicts.

**Results.** Exhaustive over n ∈ [2×10⁵, 2.15×10⁵], ratio of actual count to predicted.

| n mod 24 | F | D | x\* | mean | sd |
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
| 7 | 4 | 2 | 0.16667 | 1.0233 | 0.095 |
| 15 | 4 | 2 | 0.16667 | 1.0197 | 0.090 |
| 5 | 2 | 6 | 0.22474 | 1.0068 | 0.121 |
| 17 | 2 | 6 | 0.22474 | 1.0056 | 0.123 |
| 11 | 4 | 6 | 0.13397 | 0.8977 | 0.110 |
| **23** | 4 | 6 | 0.13397 | 1.0625 | 0.109 |

```bash
# F = 1 and F = 2 rows (the even family and the three-part / fused rungs)
python3 count_check.py --nmin 200000 --nmax 215000 --maxn 99999999 \
        --residue R --modulus 24 --parts F+1 --dq D --centre X

# F = 4 rows: residues 11, 23 at (D, x*) = (6, 0.13397). Classes 7 and
# 15 have left this block -- they now take F = 2 at (D, x*) = (4, 0.25000) and
# belong in the --parts run above, alongside 3 and 19.
python3 count_check.py --nmin 200000 --nmax 215000 --maxn 99999999 \
        --residue R --modulus 24 --fc 4   --dq D --centre X
```

`--maxn 99999999` forces an exhaustive run; the default subsamples, which leaves the mean sound but the sd noisy. `--fc F` sets the fusion count directly and does not require F | D, which `--parts` cannot express.

> **Three gotchas, each of which produces a plausible wrong number rather than an error.**
>
> - **Pass `--centre` explicitly.** `XSTAR_BY_RESIDUE` is auto-selected whenever `--modulus 24` is given, so a run that *looks* correctly configured can silently take a balance point belonging to a different rung. Take the value from §3.3.5's x\* column for the residue being tested.
> - **The F column is part of the specification, not bookkeeping.** Testing a residue at the wrong F tests a system with nothing to do with its ceiling: at 11 and 23 the F = 2 reading wants d = 12 and the F = 4 reading wants d = 6, and both run without complaint.
> - **A regression suite over one parameter range does not certify another.** Three defects in the local-factor computation — an assumed F | D, a missing gcd(D,F)/F integrality factor, and an enumeration modulus not divisible by F/gcd(D,F) — are all inert at F ≤ 2 and left every F ≤ 2 row reproducing to four decimals. What caught them was brute-forcing the local densities directly inside the new range. Do that whenever the parameters move, in preference to re-running the rows whose answers are already known.

*Verification for the F = 4 rows:* the local density from the formula agrees with brute-force enumeration at every prime at every n tested, and the four rows converge two-sided to 1 with sd falling as n^{−1/2}.

**Every residue agrees to within a few percent, and no n in any band lacks a solution in its window.** The residual spread is finite-size: convergence is slow at a given n, and the largest deviations sit where the count is thinnest. Following the four extreme residues — **the two furthest above 1 and the two furthest below**, so that the convergence claim is not being tested only on the deviations that flatter it:

| | [2×10⁵, 2.15×10⁵] | [5×10⁵, 5.03×10⁵] | [10⁶, 1.003×10⁶] |
|---|---|---|---|
| n ≡ 11 (mod 24), F = 4, D = 6 | 0.8977 | 0.9964 | **0.9853** |
| n ≡ 23 (mod 24), F = 4, D = 6 | 1.0625 | 0.9691 | **0.9924** |
| n ≡ 19 (mod 24), D = 4 | 0.9030 | 1.0045 | **0.9995** |
| n ≡ 3 (mod 24), D = 4 | 0.9354 | 0.9909 | **1.0247** |

with sd falling like n^{−1/2} throughout — 0.146 → 0.103 → 0.092 on the D = 4 rows. **The deviation is two-sided, not one-sided**, which is what the finite-size reading predicts and what a wrong singular series would not produce: a mis-specified system would drift consistently in one direction rather than converging from both.

> **Why the log factors are the actual polynomial values.** `_density_integral` evaluates 1/(log q · log r · log c) at r = Dq + 1 and c = (n−1)/K − (D/K)q, integrating across the window — not 1/log³ of a common variable. That is the refinement Jones–Zvonkin found necessary for agreement at their precision, and at our range it is not optional: log n runs 12 to 14 here, so an additive constant inside a log is a percent-level effect and three of them compound. The singular series is likewise computed from the true root count of the system mod p (`roots_mod`), not from a generic form. Slow approach to an asymptotic constant is ordinary here; π(x) − li(x) is the standard caution against over-reading a one-sided gap at fixed size.

**The obstruction predictions hold in the other direction too.** Where the singular series vanishes the count must be zero, and it is: at n ≡ 23 (mod 24) the full-efficiency system (D = 2) vanishes identically, 834 of 834 values in a test band, with zero observed solutions at every one. Likewise n ≡ 1 (mod 12) at D ≥ 4, where h = (n−1)/2 is even and c would have to be even. So §3.3's local analysis is confirmed from the counting side as well as from the root analysis.

*No extra congruence on c is needed at either rung* (§3.2.3). The arithmetic is worth recording as a *consequence*, since it is easy to mistake for a condition: at n ≡ 11 (mod 24), r = Dq + 1 with q odd gives r ≡ 5 (mod 8), and n ≡ 3 (mod 8) then makes c = (n − r)/2 ≡ 3 (mod 4). So that value of c arises — and nothing breaks if it does not. **Gotcha: this is the shape of inference that has repeatedly been read backwards.** The residue keying comes from the foreign block's r − 1 alone (§3.3.4a); a c-congruence appearing downstream of it is an artifact of the parametrisation.

> **A local obstruction indexed by the twist prime.** Distinct from the above. In the weaker system c prime, r = n − 2c prime, r ≡ 1 (mod q), the congruence pins c to the single class (n−1)/2 (mod q); when that class is 0 the family is empty, since q | c forces c = q. It fires for one n in q. Verified: observed count 0 at every such n. It belongs in §3.3's inventory alongside ℓ = 2 and ℓ = 3, being an obstruction indexed by the twist prime rather than by a fixed small prime.
>
> *It cannot obstruct the family, and that is a triviality rather than an observation.* Read the condition the other way round: at a fixed n the degenerate q are exactly the **prime divisors of (n−1)/2**, of which there are ω((n−1)/2) ≤ log₂ n — measured over odd n ∈ [10⁴, 4·10⁴], mean 2.56 and maximum 5. Every other prime is non-degenerate, so the obstruction removes O(log n) candidates from an unbounded supply. What is *not* settled by that is whether some non-degenerate q also has supply near the balance point and an efficiency worth having; that is the parametric question of §3.5 and Hypothesis (H), not a separate obstruction.

**What this establishes.** The local analysis and the singular series are confirmed at every residue mod 24 — finer than the mod-12 law now requires, so the agreement across each pair {a, a+12} is itself a check on the rekey — in both families, each at the balance point its own ceiling is derived from — the count matches, and the vanishing predictions vanish. It says nothing about §3.5's global question, whether solutions exist for *every* large n, which is where the conjecture lives. What it removes is the possibility that the constants are right but the model is wrong.

## 4. The remaining configurations (S1, S2, S6–S10, and the escapes): what survives asymptotically

*§3 handles the configurations that carry the asymptotics — S3 for even n, and **S4 together with S7 at F = 2** for odd n, which split the range by a congruence on c. This section covers everything else in the census, and the subsections are numbered to the three fates: **§4.1** fate (i), S1 and S2, the multiplicative engine, which thins; **§4.2** fate (ii), S6, present but supply-limited; **§4.3** fate (iii), S5, S7 at F ≥ 3, and the escape routes, which reach only O(n/log n) values. **§4.4** collects what is excluded by theorem, and **§4.5** draws the conclusion.*

> **Three fates, and they are different.** A configuration can (i) require a condition on n of density zero, so it *thins*; (ii) remain available at a positive density of n but be beaten by a better shape, so it *stops winning*; or (iii) remain available while reaching only a vanishing proportion of n. The distinction matters because (i) and (iii) both remove a shape from the asymptotic picture while (ii) does not, and because a fate-(iii) shape can still be conspicuous at computed sizes when the vanishing is only logarithmic — which §4.3 shows is the case for all four escapes.

### 4.1 The multiplicative engine (S1 and S2): fate (i), it thins

*Both shapes of the multiplicative engine live or die on the same condition. A fused class needs n = F·c with F and c both prime powers, i.e. **ω(n) ≤ 2**, and the two values of ω split the engine in two: ω(n) = 1 is **S1**, the trivial case at δ = 1, and ω(n) = 2 is **S2**, the fused family proper. Both thin, S1 the faster.*

ω(n) ≤ 2 is a **density-zero condition**. The count of n ≤ N with exactly two distinct prime factors is ~N log log N / log N; the prime powers are smaller still, at **π(N) + O(√N) = O(N/log N)**. So S1 vanishes fastest, S2 next, and neither survives into the asymptotic picture.

**S1 is the cleanest instance of fate (i), and the most extreme.** At n = p^a the group AGL(1, n) is 2-transitive, so μ(n) = C(n,2) and δ = 1 — the maximum possible density, achieved on a set of density zero. It is kept in the census for the same reason one keeps the trivial group: the degenerate member of the family, not an exception to it. Its O(N/log N) count is, incidentally, the same order as the escapes of §4.3, though for a far more elementary reason. The tables skip prime powers because the answer is known, not because μ is undefined there.

**The rest of this subsection is about S2**, where the thinning is slower and has a second mechanism on top of it.

> *Verified.* Fraction of composite non-prime-power n with ω(n) = 2, by dyadic block: **52.3%** on [10³, 2·10³), 43.1% on [5·10³, 10⁴), 35.0% on [5·10⁴, 10⁵), 29.8% on [5·10⁵, 10⁶), 28.5% on [10⁶, 2·10⁶).

**The prediction shows up in the table, on both of its halves.** Two forces act on the observed floor in opposite directions, and separating them is the point. Extending the range lowers it, since a wider range can only find weaker values. Adding configurations raises it, since B(n) is a maximum — so a shape-space correction lifts the whole curve at once. Over the contiguous range to n = 2600 the floor is **⟦PENDING-REBUILD⟧** **tentatively 0.048039 at n = 2183** (v4's 0.045742 at n = 1817 rises to ≥ 0.0594 under the entangled-generator correction; 2183 is not among the 289 raised rows, so its v4 value stands as the working minimum pending the rebuild). So the *within-table* floor moved up when the space was corrected, while the mechanism below — which is about which n the engines reach, not about how well they are scored — is unaffected. The thirds of the range behave as the argument requires:

| n | ω(n) = 2 share | median smallest cofactor F | min density |
|---|---|---|---|
| [6, 800) | 64.9% | 4 | 0.05703 |
| [800, 1500) | 53.6% | 5 | 0.05181 |
| [1500, 2298) | 50.0% | **7** | **0.04574** |

Two effects, not one. The ω(n) = 2 population thins, as predicted; and **among the values that remain, the smallest prime-power cofactor grows**, so the 1/F the multiplicative engine delivers shrinks even where the engine applies. n = 2183 = 37·59 illustrates the mechanism: ω(n) = 2, so a fused class exists, but only at F = 37, worth 1/37 ≈ 0.027 — which loses to `6x251 + 1x677*` at 0.048039. (Under the v2 shape space the winner there was the three-class 1297\* + 443 + 443 at 0.041107; the cyclic-layer block count is what lifted it.) **⟦PENDING-REBUILD⟧** n = 2183 is tentatively the table floor itself: v4's floor row n = 1817 rises to ≥ 0.0594 (`3x256 + 1049*` at full twist), while 2183 is not among the raised rows. 2183 is n ≡ 11 (mod 12), the doubly-obstructed class — so the floor tentatively returns to that class, and the 1817 exception becomes historical pending the rebuild.

Two consequences, and both should temper how the computed range is read.

**The observed density floor should drift downward.** Fully 55.4% of the current table has ω(n) = 2, so more than half the computed values are served by an engine whose reach halves over the next few decades of n. The median of 0.1994 is propped up by a population that thins. The evidence is two-sided and worth keeping apart: *within* the exactly-computed range each extension lowers the floor, which is the prediction, while shape-space repairs keep lifting the current table's floor — to 0.045742 at n = 1817 under v4, and **⟦PENDING-REBUILD⟧** tentatively to 0.048039 at n = 2183 under the entangled-generator correction — corrections to the scoring and not counter-observations. Beyond the table the ladder of §5 reaches 0.04453 below 10⁶, attained at n = 11183 — above the exactly-computed floor's own value in the table's range, which is the recovery showing through rather than a contradiction.

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

> **So S6's fate is (ii), and more sharply than for any other shape.** It is available at essentially every even n, its ceiling equals S3's at 1/4, and yet it is beaten everywhere: the configurations that would reach 1/4 or 0.17157 are locally obstructed down to one value of n each, and the configurations that are plentiful cap at 0.13397 in a regime where S3 reaches 1/4. **The winning set is plausibly finite**, and that is a statement about local obstructions rather than about supply.

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
| a cyclic-layer-fused class of F = 3 or 5 blocks (odd F only; even F is not an escape) | **S7 at F ≥ 3, odd F** |

*What they share is the mechanism, not the family: a block pinned to a power of a fixed small prime. That is also what bounds them, since it leaves O(1) choices per n.*

**The ceiling confines the block to a bounded ratio range.** Take the 2^a + r\* route, at a residue with ceiling δ₀. Its density is min(x², η(1−x)², 2x(1−x)) at x = 2^a/n, so reaching δ₀ needs **both** x² > δ₀ and η(1−x)² > δ₀, and since η ≤ 1 the second forces (1−x)² > δ₀. Hence

> **√δ₀ < x < 1 − √δ₀.**

The interval has ratio (1 − √δ₀)/√δ₀, which is largest at the smallest ceiling. At δ₀ = 7 − 4√3 = 0.071797, the smallest ceiling, the range is (0.2679, 0.7321) — ratio **2.73 < 4**, so it holds **at most two powers of 2**. (The old ceiling 0.050510 gave the wider range (0.2247, 0.7753) at ratio 3.45, so the conclusion held there too and is only strengthened.) At the unobstructed odd residues, δ₀ = 0.171573, the range is (0.4142, 0.5858) with ratio 1.41, holding at most one.

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

**But the vanishing is logarithmic, which is why they are conspicuous at computed sizes.** Measured against the ceilings (now keyed mod 12), the fraction of odd n whose ceiling the route exceeds:

| n ≈ | 1.3×10⁴ | 1.0×10⁵ | 1.0×10⁶ |
|---|---|---|---|
| 2-power route | 3.73% | 2.20% | 1.20% |
| 3-power route | 2.48% | 1.00% | 0.00% |

Both fall, consistent with the O(1/log n) bound and if anything faster — the 3-power route is already empty by 10⁶, since once a residue's ceiling exceeds 0.086 its window admits at most one power of 3 and usually none.

**Availability and effectiveness are different quantities, and only the second thins.** A route being *available* — some 2^a + r\* representation existing at all — is a much weaker condition than its reaching the ceiling, and it does not thin: Romanov (1934) gives {2^k + p} positive lower density, and Erdős (1950) gives a positive density of odd n with no such representation, so availability sits at 86–99% of odd n and stays there, bounded away from both 0 and 1 with the limiting density itself unsettled. What the count above measures is effectiveness, and that is what the ceiling analysis needs.

*This is the source of the census's one existence/winning gap of positive density.* The 2^a + r\* route is S3 at odd n, so S3 **exists** on all even n plus a positive proportion of odd n, while **winning** on the even 12/24 alone — the odd instances are available almost everywhere and effective almost nowhere. Every other gap in that column is a difference of rate rather than of density.

**None of this moves §5's floor**, and the reason is general: every escape *raises* δ(n), a floor is a minimum over n, so a route lifting some values above their ceiling cannot lower it however common it is. What the escapes change is the reading of the ceiling table — δ₀ is what the *balanced* shape guarantees at that residue, not a bound on what any shape achieves there.

### 4.4 What is left over

**S8 and S10 are excluded by theorem, not by rarity** — D1 and the twist-collapse of D2q respectively; they cannot occur at any n, so they have no asymptotics. **S9 is different: it occurs, and is dominated.** Lemma D2 bounds any configuration containing a fused outside class by n·min(F,r)/2 ≤ n^{3/2}/2, so its density is O(n^{−1/2}) and it loses to every shape with density bounded below — a fate of kind (ii), and the most decisive instance of it in the census, since the margin grows like √n rather than resting on a comparison of constants.

**S7 at F ≥ 3** is an escape rather than a carrier, and §4.3 counts it with the other routes at O(n/log n). Its parity structure is what restricts it: at odd n, F·c even with F odd forces c to be a power of 2, leaving O(log n) choices per n. **S7 at F = 2 is a different matter entirely** — it is the odd-n fused rung and carries 10/24 of all n; it is listed under §4.5's live shares, not here.

**S5** is a census shape but behaves as an escape, for a reason on the other side of the configuration: top-layer fusion forces q = 2, so the foreign efficiency is 1/u with u the odd part of r − 1, and reaching a useful η needs r = 2^a·u + 1 with u small. That is an exponential family, O(log n) candidates per n, hence O(n/log n) values — §3.3 and §4.3.

### 4.5 The asymptotic question is entirely Hardy–Littlewood

**Summary of the fates.**

| shape | fate | evidence |
|---|---|---|
| S1 | **(i)** thins | prime powers are O(N/log N); δ = 1 there, known exactly — §4.1 |
| S2 | **(i)** thins | ω(n) = 2 with both factors prime powers has density 0 — §4.1 |
| S3 | carries even n — **12/24** | §3.1; the counting check of §3.8 |
| S4 | **wins nowhere**; the argmax of the three-part family at 23 mod 24, where F = 4 beats the family (at 7 and 15 the F = 2 entangled reading now beats both, and at 11 F = 4 does) | §3.2 |
| **S7 at F = 2** | carries odd n — **10/24**, the residues 1, 3, 5, 7, 9, 13, 15, 17, 19, 21 mod 24 (i.e. all of n ≡ 1, 3, 5, 7, 9 mod 12) | §3.2 |
| **S7 at F = 4** | carries odd n — **2/24**, the residues 11, 23 mod 24 (i.e. n ≡ 11 mod 12) | §3.3.5 |
| S5 | **(ii)**: available at essentially every odd n, beaten almost everywhere. q = 2 pins η = 1/u, so clearing the ceiling needs r = 2^a·u + 1 with u small — effective at O(n/log n) values | §3.3, §4.3 |
| S6 | **(ii)**, with a plausibly *finite* winning set | available at essentially every even n and beaten at all of them; its two competitive rungs are obstructed at ℓ = 3, not scarce; **0 winners in range** — §4.2 |
| S7 at F ≥ 3 | **(iii)** at odd n, where c is forced to a power of 2; **(ii)** at even n, where the supply matches S3's but its 0.13397 ceiling loses to S3's 1/4 | §4.3, §4.4 |
| the escape routes | **(iii)**: effective at a vanishing but only logarithmically thinning proportion | all four routes measured — §4.3 |
| S8, S10 | cannot occur | excluded by D1 and D2q's twist collapse |
| S9 | **(ii)**, decisively: occurs, but capped at n^{3/2}/2 by D2, so δ = O(n^{−1/2}) | §4.4; `enumeration-proof.md` Part D2 |

The four live shares sum to 1: 12/24 to S3, 10/24 to S7 at F = 2, 1/24 to S4 outright and 1/24 tied between them. S5, S7 at F ≥ 3 and the escape routes take no share of the limit. Note that for the first two this is a matter of being **beaten**, not of being absent: both are available at a positive density of n — S5 at essentially every odd n, S7 at F ≥ 3 at essentially every even one — and it is their ceilings that lose. Only the O(n/log n) subset where they clear their residue's ceiling shows up at all.

Since the multiplicative engine vanishes in density, the asymptotic behaviour of μ(n) for almost all n is set by the additive families, whose ceilings are the mod-12 table of §3.3 and whose availability is a Bateman–Horn question. In particular the ladder constants of §5 of the notes — the §3.3 constants — are the right asymptotic quantities, and the fused family's 1/2 and 1/3 are not, however dominant they look in the table.

---

## 5. A single global lower bound

> **The constants of this section are contingent on a group-theoretic accident, and it is worth knowing which one.** Every ceiling here traces to a block being **2-homogeneous** — a single orbital of size C(c,2), so a block can carry full density, and the optimisation below is what one does *once that is given*. Solvable 2-homogeneous groups exist at every prime power, which is why the method has anything to optimise. **3-homogeneously they exist only at degrees 3, 4, 5, 8 and 32** — the last two regular on triples, all five Oliver — so at k = 3 the family is finite, the ceiling apparatus vanishes asymptotically, and the best available threshold is Θ(n²) against C(n,3); see `three-uniform-note.md` §3.1. The optimisation is not the heart of the method; it is the dividend of 2-homogeneity.
>
> **2-homogeneity, not 2-transitivity, is the right name for what is being spent here**, and the difference is exactly the arithmetic this section runs on. AGL(1, c) is 2-transitive and always suffices, but at **c ≡ 3 (mod 4)** the index-2 subgroup with twist (c−1)/2 is already 2-homogeneous, because omitting −1 fuses the two halves of each difference class — which is precisely the orb(c, d) = cd/2 case of §3.1 and the reason c ≡ 3 (mod 4) governs which rung is reachable throughout §3.3. Naming the property 2-transitivity would make the η bookkeeping look like an unrelated coincidence rather than the same fact counted twice.
>
> *One degree of freedom that is **not** hidden in these ceilings:* whether a block's twist is read in GL(1, c) or in the semilinear ΓL(1, c). At k = 2 that choice provably changes no orbital minimum (`enumeration-proof.md` J0a), so the ceilings here are insensitive to it. At k = 3 it does change the minimum, which is a further respect in which the k = 2 constants are contingent.

The residue analysis gives seven distinct δ₀ across the 24 residue classes (§3.3). It is worth collapsing them into a single number that should hold everywhere, even at the cost of being loose.

> **Read δ against the right literature, because the obvious comparison is a category error.** The known unconditional lower bounds on the number of *queries* forced by a nontrivial monotone property run Rivest–Vuillemin n²/16 → Kleitman–Kwiatkowski n²/9 → Kahn–Saks–Sturtevant n²/4 → Korneffel–Triesch → **Scheidweiler–Triesch n²/3 − o(n²)**, the current best. Our floor of 0.04453 is about 0.022n², a factor of 15 below that — and the two numbers are **incomparable, not competing**.
>
> **δ measures *which properties* the method reaches; c(n) measures *how many queries* are forced for all of them.** Scheidweiler–Triesch bound D(P) from below for every nontrivial monotone property. What δ does is different in kind: m\* ≥ δ·C(n,2) gives **full evasiveness** — exactly C(n,2) queries, the maximum possible — for every property of dimension below m\*. A weak bound on all properties and an exact result on a restricted class do not sit on the same scale, and a small δ next to a larger n²/3 says nothing about the strength of either.

**Where the floor lives.** The worst residues are **n ≡ 11 (mod 12)**, with δ₀ = 7 − 4√3 = 0.07180 — the odd classes carrying the ℓ = 3 obstruction. Almost every value that has ever set a running floor has been in n ≡ 11 (mod 12): of §4.1's eight record-setters under the corrected table, seven are ≡ 23 (mod 24), and the one exception was v4's table floor **n = 1817 ≡ 17 (mod 24)**, i.e. 5 (mod 12) — **⟦PENDING-REBUILD⟧** under the entangled-generator correction 1817 rises to ≥ 0.0594 and the tentative floor returns to n = 2183 ≡ 23 (mod 24), restoring the doubly-obstructed class as the argmin's home. (The pre-repair descent's record-setters were all ≡ 11 (mod 12), eight at 23 and three at 11 mod 24.) Finite-n record holders are low from *supply* failure rather than from a low ceiling, so class membership of the argmin is weaker evidence than the ceiling table itself.

> **The finite-range minimum is set by whichever engine happens to be weakest at the extreme value, and that alternates.** Over v4's contiguous range to n = 2600 the smallest density is

> **⟦PENDING-REBUILD⟧** **tentatively 0.048039 at n = 2183 = 37·59**, witness `6x251 + 1x677*` (v4's floor **0.045742 at n = 1817**, witness `p=389 q=173: 1x1039* + 2x389`, rises to ≥ 0.0594 under the corrected caps),

an **additive** three-part configuration at **n ≡ 17 (mod 24)**. It is **intra-bound**: the binding term is 2·orb(389, 97) = 75,466, the twist cut from 388 to 97 because F_mid = 2 strips the factor 4, against a foreign term of orb(1039, 173) = 179,747 and larger cross terms. **Which term binds is a property of the record-holder, not of the record**, so it changes silently whenever the argmin does — re-derive it from the witness rather than carrying it forward. The runner-up mechanism is multiplicative granularity: n = 1159 = 19·61 sits at 0.051813 on the single fused class `19x61`, where F = 19 is the smallest prime-power cofactor so the engine delivers only 1/19 and nothing additive competes. Which of the two owns the record at a given frontier is not stable, and **the record-holder's mechanism is a range-scoped claim that expires silently** — `check_doc_figures.py --pass scope` catches numeric range assertions but not claims about mechanisms, which is the failure mode `pending-checks.md` A5 records. Re-read this paragraph at every extension. Asymptotically neither mechanism is the story: the class-23 additive ceiling takes over, which is the §3.7 handover seen from the floor's side.

`ladder_verify.py` computes, for each n, the best density achievable by four explicit families, scanning the block size over a window wide enough to contain every balance point, x ∈ [0.10, 0.55]. Over all composite non-prime-power **n ≤ 10⁶** (78 minutes) the smallest value is

> **δ ≥ 0.04453, at n = 11183.**

This is a *lower* bound on δ(n), not δ(n) itself, since it uses only four families. No class is anomalously weak relative to its own cap: the per-class minima of δ/cap run from **0.327 to 0.653** at N = 20,000, the spread expected from representation availability alone. The one residue that did not rise when the fused rungs were added is **n ≡ 11 (mod 24)**, and the reason is instructive rather than anomalous.

> **The fused rungs double the intra term and nothing else, so they are invisible wherever the foreign block binds.** At every one of the nine rung-B residues, the configuration realising the *class minimum* binds on its foreign term, not its intra term — checked directly at all nine. Fusing cannot move a value whose bottleneck is the foreign block, so what the fix changed at eight of them was the value at some *other* n in the class, which then displaced the old minimum. At n ≡ 11 (mod 24) nothing displaced it.
>
> Worked at n = 11819 = 53·223, a class-11 value where the three-part family does poorly (it reaches 0.06814; the class minimum is n = 6275 at 0.04815): the best three-part split is c = 2069, r = 7681, and r − 1 = 7680 = 2⁹·3·5 has **odd part 15**, so η = 1/15 at q = 2 and 0.00026 at any odd q. The intra term is C(2069,2) = 2,139,346 and the foreign term is 1,966,336 — the foreign one binds, and doubling the intra to 4,278,692 changes nothing. Both fused readings return exactly the unfused value. (Also c ≡ 1 (mod 4), so the cyclic rung would lose the twist anyway; but even at c ≡ 3 it would not have helped.)
>
> **And residue 11 is the one most exposed to this**, by construction: it is the doubly-obstructed class, needing η = 1/6, the hardest efficiency in the table. A class whose ceiling already assumes a scarce foreign efficiency is the class whose weak values will be foreign-bound, and foreign-bound values are exactly the ones fusion cannot lift. So the residue that failed to move is the one the model predicts should fail to move.

**The floor rises with n**, as the singular-series picture requires — once representations near the balance point become plentiful, the achievable density approaches the class cap. Block minima over the blocks of 10⁵, with the untruncated series sampled inside the two lowest-cap classes alongside:

| block | block floor | at n | untruncated, classes 11 and 23 | at n |
|---|---|---|---|---|
| [0, 10⁵) | **0.04453** | **11183** | 0.04582 | 9911 |
| [10⁵, 2·10⁵) | 0.05603 | 173627 | 0.06027 | 120791 |
| [2·10⁵, 3·10⁵) | 0.05928 | 275267 | 0.06202 | 235127 |
| [3·10⁵, 4·10⁵) | 0.06209 | 349823 | 0.06257 | 326423 |
| [4·10⁵, 5·10⁵) | 0.06150 | 407279 | 0.06375 | 415127 |
| [5·10⁵, 6·10⁵) | 0.06363 | 501167 | 0.06542 | 585623 |
| [6·10⁵, 7·10⁵) | 0.06415 | 608807 | 0.06525 | 614903 |
| [7·10⁵, 8·10⁵) | 0.06499 | 758327 | 0.06499 | 758327 |
| [8·10⁵, 9·10⁵) | 0.06590 | 873287 | 0.06767 | 801239 |
| [9·10⁵, 10⁶] | 0.06478 | 928583 | 0.06647 | 935723 |

The first block contains the global minimum; every block after it sits above 0.056 and the trend is upward, with the last four all above 0.064 against the asymptotic ceiling of 0.071797.

**Every one of the ten block minima falls in class 11 or 23** — eight at 23, two at 11 — which is the ceiling table landing where it should, those two classes sharing the lowest cap. That is read off the first column alone and owes nothing to the sampling. *The two columns coinciding in [7·10⁵, 8·10⁵) is not additional evidence*: the sampled series takes one in four of those classes, so it agrees with the block floor exactly when the block's minimising n happens to be sampled and cannot agree otherwise. One coincidence in ten blocks is if anything slightly under the rate that alone would predict.

> **These are real minima, and the early-exit trap is worth naming.** `ladder_verify.py` stops scanning once a value clears its `stop_at`, and returns *some* value above it rather than the family maximum — so any per-block figure sitting at the threshold is a truncation artefact rather than a minimum. Blocks reporting exactly 0.9 × cap, or exactly the asymptotic constant, are the signature, and it sits precisely where the signal is. The script labels a clamped block floor as such — no block in the table above is clamped, all sitting below the asymptotic bound — and reports the untruncated sampled minimum in the second pair of columns; that series is what shows the envelope climbing as the ω(n) = 2 population thins, which is §4's prediction. Note what the agreement between the two columns does *not* show: both run the same four families, so it tests the clamping and says nothing about whether a family is missing. The check for that is the per-residue min-ratio spread above. Sampling uniformly for that purpose does not work — the values attaining a minimum are rare and structured, and a uniform sample overstates by a factor of two or more.

So the low-density dips are a small-n phenomenon and the asymptotic floor is the ceiling at **n ≡ 11 (mod 12)**.

> **Why the extremal residue is mod 12, as is everything else.** The local obstructions at ℓ = 2 and ℓ = 3 see only n mod 12, and nothing in the ceiling table sees anything finer (§3.3.4): at F = 2 the 2-adic dependence is mod 4, and the genuine mod-8 condition at F = 4 is constant on its class. So the extremal class is keyed no more coarsely than the rest of the table. The minimum over all residues is **7 − 4√3 = 0.071797**, attained on **n ≡ 11 (mod 12)**.

<!-- DUP:density_floor_conjecture -->
> **Conjecture (global density floor).** For every composite non-prime-power n, **μ(n) ≥ C(n,2)/25**, i.e. δ(n) ≥ 0.04 — verified unconditionally for every n ≤ 10⁶, where the four-family ladder gives δ ≥ 0.04453 attained at n = 11183; and asymptotically **δ(n) ≥ 7 − 4√3 − o(1) = 0.071797…**, the extremal residue being **n ≡ 11 (mod 12)**, the odd class carrying the ℓ = 3 obstruction.
<!-- /DUP -->

> **The finite constant was 1/50 and the gap between the two forms is the interesting part.** 1/50 was set when the observed floor was near 0.026 and falling with every extension of the range, so it was a modest safety margin under a moving target. The target then stopped moving down and moved up, and every fall turned out to be a scoring deficiency rather than a property of μ: the pre-repair shape space read n = 2291 at 0.037524 where the true value is 0.066767, and the pre-repair ladder read n = 8927 at 0.02516 where the corrected families put it above the asymptotic ceiling entirely, dropping it from the worklist. **The drift is one-directional for a structural reason.** B(n) is a *maximum* over admissible configurations, so a missing shape can only depress it — and a missing shape has no witness, hence nothing in the pipeline can detect one, whereas an over-credit is caught by re-deriving μ from the recorded witness. The errors that survive to be found later are therefore biased toward those that lower the floor, which is why the ratchet has run upward and why 1/25 should also be read as likely loose.



*Reading the conjecture.* The asymptotic constant is cap_F(η) = η/(1 + √(Fη))² at η = 1/3, F = 4 — the joint optimum at the odd residues carrying the ℓ = 3 obstruction. Both halves of n ≡ 11 (mod 12) reach it, since the F = 4 shape is indifferent to the mod-8 split that separates 11 from 23 (§3.3). The asymptotic half says the *worst* n eventually reach what the balanced family guarantees; it is a floor, and individual n exceed it freely.

**The asymptotic half is exactly what (H) buys.** Granting Hypothesis (H) of §3.5, every sufficiently large n admits a representation at its own class ceiling, so δ(n) ≥ δ₀(n) − o(1) ≥ 7 − 4√3 − o(1) with the minimum at n ≡ 11 and n ≡ 23 (mod 24). The finite half — δ ≥ 1/25 at *every* composite non-prime-power n — is not implied by (H), which is an eventual statement; it is verified to 10⁶ by the ladder and supported by the margin below.

The constant 1/25 is deliberately loose, though less so than 1/50 was. Two things are absorbed into the margin: the finite exceptional set of §3.5, whose members fall back on whatever configuration they can find, and the windowing loss of §3.4, which costs a factor Θ(√ε) when the balance point is not exactly available. The measured margin over the computed range is only 11% — the ladder's floor is 0.04453 against 1/25 = 0.04 — so 1/25 is close to what the current families actually deliver, and a sharper constant would want either B(11183) computed or a fifth family.

### 5.1 The branch-and-bound, and what it currently establishes

The worklist admits a search that converges fast, because `ladder_verify` returns a *lower* bound: if LB(n) ≥ M for the standing minimum M, then δ(n) ≥ M and n cannot lower it, so n is discarded without computation. Take the smallest known δ as M, discard every candidate with LB ≥ M, compute δ at a survivor, lower M if it beats it, repeat.

> **The ladder is tight wherever both are known, which is what licenses extrapolating it.** Joining the worklist against the computed table — `validate_table.py --ladder`, which reads both files and recomputes nothing — the ladder equals B(n) at **every one of the 100 values in both**. So on the measured range the four families do not merely bound δ(n), they attain it, and the ladder's advantage is entirely in cost: O(n/log n) per value against the enumeration's n^2.9. That is the empirical basis for reading the floor out to 10⁶ as an estimate of δ rather than only as a bound. The check also runs in the other direction: a ladder value *above* B(n) would mean a family scored too generously, a shape missing from the enumeration, or a broken collapse.
>
> **This became true only after the S7 family was given its layer split**, and the gotcha is worth keeping. A fused class of F blocks does not put every prime of F into the cyclic layer: F = F_mid·F_top with F_top a power of the top prime q (`enumeration-proof.md` G.2), so the foreign twist must avoid the primes of **F_mid**, not of F. Excluding all of F is a valid lower bound but discards every configuration whose foreign twist needs a prime dividing F — in practice **q = 2 with F even**, the Fermat-prime branch. It cost exactly one value in range: at **n = 935** the ladder read 0.04898 against B(935) = 0.07534, on `6x113 + 1x257*` with F_top = 2, F_mid = 3, binding on orb(257, 256) = 32,896. The repair lifts 935 above the asymptotic ceiling and 1007 from 0.06444 to 0.06494, changes nothing else below 5·10⁴, and leaves the global floor at 0.04453 (n = 11183).

**The ladder alone now settles the range**, without the branch-and-bound needing to compute a single B(n): every one of the 46,520 worklist entries scores at least 0.04453, so M never falls below that and no survivor exists to examine. What the search is for is *sharpening* — computing B at the lowest entries to raise the verified floor — rather than establishing it. An illustrative run against an earlier, weaker ladder shows the shape of the descent:

> M → 0.041812 (n = 575) → 0.041107 (n = 2183) → 0.037524 (n = 2291) → 0.029282 (n = 3059) → 0.026117 (n = 3239), each step an n whose family score fell below the standing minimum. Under the corrected families none of those five is a candidate at all: 2291 reaches 0.066767 and 3239 reaches 0.043570, and the descent terminates immediately.
>
> The order of examination changes which values get *recorded* — one can set the running floor and then be superseded by a smaller n examined later — but not the result, since the floor only falls and pruning is sound at every stage.

**What survives the enumeration defect, and what does not.** Every step used the table from below: `ladder_verify.py` scores explicit constructions, and B(n) ≤ μ(n) wherever the collapse certificate applies, which covers both survivors. So

> **min { μ(n)/C(n,2) : n ≤ 10⁶ composite, not a prime power } ≥ 0.04453**

is proved, the ladder alone supplying it: every one of the 10⁶ values scores at least that, with the minimum at **n = 11183 = 53·211**. In particular **δ(n) ≥ 1/25 throughout**, with 11% to spare. What the bound does not license is reading it as a *value* of μ — it is a lower bound at n = 11183 like everywhere else, and B(11183) has not been computed.

**What the branch-and-bound has left to do.** The worklist holds **46,520** entries — every n whose family score falls below the asymptotic ceiling 7 − 4√3 — but **none below 1/25**, so it has nothing left to eliminate against the conjecture as stated. Its remaining use is sharpening: the operative question is **"does B(11183) exceed 0.04453"**, and more generally whether any of the ten lowest entries (11183, 1817, 9911, 2759, 5063, 3503, 7031, 2183, 6275, 1739 — all in the 10³–10⁴ band where the two engines cross) is tight. Computing B at those ten would either raise the verified floor above 1/25 with real margin or, if the ladder is tight at 11183, fix the minimum below 10⁶ exactly.

> **Probe before committing to any of them.** Finding one configuration that clears a threshold is sub-second; proving optimality is what costs hours. A targeted scan over the two-part census shapes, scored with `mu_enumerate_v2.py`'s own `value()`, reproduced B(n) exactly at all eleven worklist values where B was independently known.

`mu_enumerate_v2.py --floor M --adaptive` runs the loop as one job: it seeds at M·C(n,2) so any configuration above the floor rejects n immediately, prunes candidates whose lower bound has risen above the current floor, computes B(n) exactly only for survivors, and adopts a lower value as the new floor — which in turn tightens Proposition F.1's part-count cap ⌊1/√M⌋ for everything after it.

### 5.2 The hard range is bounded on both sides, and it is small

The worry motivating §3.5 — that between the computable range and the asymptotic one lies a middle where neither argument reaches — is answerable empirically, and the answer is favourable. Minimum lower bound over each decade of the 46,520-entry worklist:

| n | values in worklist | minimum bound | attained at |
|---|---|---|---|
| [10², 10³) | 6 | 0.05703 | 527 |
| [10³, 10⁴) | 251 | 0.04574 | 1817 |
| **[10⁴, 10⁵)** | 3,435 | **0.04453** | **11183** |
| [10⁵, 10⁶] | 42,828 | 0.05603 | 173627 |

The middle decade holds the global minimum and the one after it recovers by a quarter, so the region where neither argument reaches is a single decade wide and its worst value clears 1/25.

## 6. Running the implication backwards, correctly

Corollary 3.2 of the notes is an equivalence, so a lower bound on μ yields an additive prime statement. It is worth being exact about *which* statement, because the natural reading is too strong.

**It does not force any single Bateman–Horn system to be solvable for all large n.** A bound μ(n) ≥ δ₀·C(n,2) says only that *some* admissible configuration reaches δ₀ — and which one may vary with n. Nothing in the framework privileges a particular system, and indeed the computed table shows the winning shape changing constantly with n.

**What it does force is a covering statement over a finite set of systems.** At density δ₀ the search bounds are all effective, so the possible **shapes** form a finite set depending on δ₀ alone. Getting that set right matters, since the covering statement is only as strong as the set is small.

#### 6.1 The feasibility criterion, derived

Write x_i = s_i/n for each part's share of n, so Σx_i = 1. Each part imposes one constraint, and they are all the same constraint:

- a **matching class** of F blocks of size c = x n / F has intra term F·C(c,2), of density **x²/F**;
- its **within-class cross** term is F·c² for odd F and (F/2)·c² for even F, of density 2x²/F and x²/F respectively — so it is never tighter than the intra term, and at even F exactly ties it;
- a **foreign block** has intra term at most C(r,2), of density **x²**, which is the F = 1 case;
- **cross terms** x_i x_j are implied once every x_i ≥ √δ₀.

So every part obeys x_i ≥ √(δ₀ F_i), with F = 1 for foreign parts, and summing:

> **Feasibility.  Σ_i √F_i ≤ 1/√δ₀.**

One criterion replaces the three that might be imposed separately, and it is strictly sharper than their conjunction. It gives k ≤ 1/√δ₀ (Proposition F.1) by taking every F_i = 1, and it gives **F ≤ 1/δ₀** — note this is *not* 1/√δ₀, which is the natural-looking but wrong bound: at δ₀ = 1/9 a single class of **nine** fused blocks is feasible. The tightest instance in range is `2x1297` at n = 2594, where √2 = 1.41421 against 1/√δ = 1.41449, a slack of **0.0003** — essentially *on* the boundary; `19x61` at n = 1159 is the next tightest at slack 0.034. (The floor value — **⟦PENDING-REBUILD⟧** tentatively 0.048039 at n = 2183 — is lower but its winner's fused class is small, so it is not the binding test — the criterion binds where F is large *relative to* δ, not where δ is least.) **Checked against every winner in the table: 0 of 2,186 violate it.**

Writing **L = 1/√δ₀** and **N(δ₀)** for the number of shapes the criterion admits:

| δ₀ | L | k ≤ | F ≤ | N(δ₀) |
|---|---|---|---|---|
| 1/9 | 3.000 | 3 | 9 | **24** |
| 1/16 | 4.000 | 4 | 16 | **65** |
| 0.051813 (`19x61`, n = 1159) | 4.393 | 4 | 19 | **83** |
| 0.04453 (ladder floor to 10⁶, n = 11183) | 4.739 | 4 | 22 | **122** |
| 0.04 = 1/25 (conjectured) | 5.000 | 5 | 25 | **164** |

> *The floor rows want recomputing as the table extends.* At the conjectured floor of 1/25, L = 5.000 and the part cap is **k ≤ 5** — a substantial narrowing of the search this table sizes, since the count grows steeply in L. The exactly-computed floor — **⟦PENDING-REBUILD⟧** tentatively 0.048039 at n = 2183, giving L = 4.562, k ≤ 4, F ≤ 20 (v4's 0.045742 at n = 1817 gave L = 4.676, N(δ₀) = 112) — wants these rows re-derived after the rebuild. Recompute the affected rows rather than the whole table. (The 122 and 164 above, and the 112 here, are direct enumerations of the criterion, checked against the 24 / 65 / 83 rows by the same code.)

**This column is the raw count and nothing has been removed from it yet.** §6.2 asks whether a shape names one system at all, §6.3 gives the reductions, and §6.4 counts what survives them — which is a far smaller and much more slowly growing set than the table suggests.

#### 6.2 Does a shape determine a single system? The one-size presupposition

*The whole count rests on each shape naming one Bateman–Horn system, so this comes first.* Naively each matching class carries its own free size, so the number of free variables would grow with the class count and a "shape" would not name a single Bateman–Horn system. What collapses them is the cyclic layer, and the argument is a density argument rather than a structural one — it is worth setting out carefully, because the crisp version of it is false.

**The twist orders are what the cyclic layer constrains, not the multiplicative groups.** A matching class of blocks of size c carrying a twist of order d has intra term ≈ c·d/2, so its density is c·d/n², and reaching δ₀ needs

> **d ≥ δ₀·n²/c**,  equivalently a twist fraction **d/(c−1) ≥ δ₀/x²** with x = c/n.

So a block needs a *bounded fraction* of its multiplicative group, not all of it: at x = 0.3 and δ₀ = 0.05 the fraction may be as low as about 0.55. Cyclicity of Γ₁/Γ₂ then requires the twist orders {d_i} of the distinct classes, together with the foreign translation orders {r_b}, to be **pairwise coprime** — it does not require the full C_{c_i−1} to embed.

**Two classes of equal size cost nothing**, because they can share a single *diagonal* twist: one C_d acting on both, contributing one factor rather than two. That is Theorem 2.1's construction and it is why S4 exists at all.

> **Linkage between parts is normal here, and is not what distinguishes one family from another.** §3.3's system is three conditions in a single variable, because c is determined by r and n; the coprimality budget and the distinct-foreign-prime rule are inter-part constraints as well. So a shape is not a set of independent size variables, and a family that adds a divisibility relation between two parts is not thereby a new kind of object. What separates families is the **degree of the system in its natural variable** — see §3.5.6, where the fallback families split into linear, higher-degree and exponential according to the exponent in the foreign twist.

**Two classes of unequal size are admissible, at every p — and the reason they do not appear is economic, not structural.** It is tempting to argue that independent twists d, d′ must be coprime, so at most one may be even and the other loses a factor 2, and that at odd p this is fatal. **That argument does not apply.** Part E's construction carries every p-characteristic twist on **one diagonal generator of the cyclic layer**, whose image in each class is that class's full twist; distinct p-characteristic classes therefore need no coprimality between their twist orders at all. What the cyclic layer requires is that the generator's total order be coprime to the foreign translation orders {r_b} and to the block-rotation orders {F_mid}. So there is no p = 2 versus odd-p asymmetry here, and the n = 551 configuration below is admissible for a more general reason than the coprimality of 255 and 127.

**What bounds the shape is a density ceiling.** Take the unfused two-class case c = p^a > c′ = p^b, so c′ ≤ c/p and c + c′ ≤ n, whence c′ ≤ n/(p+1). The configuration's minimum is at most the smaller class's intra term, ≤ C(c′,2), so

> **δ ≤ (c′/n)² ≤ 1/(p+1)²** — 1/9 at p = 2, **1/16 at p = 3**, 1/36 at p ≥ 5.

So an unequal-size shape is *infeasible* above density 1/9 whatever p is, and above 1/16 unless p = 2. Only p = 3 can compete anywhere near the computed floor, and only inside the δ ≤ 1/16 tail.

**Measured.** Scoring every unequal odd-p configuration at full diagonal twist: **none wins** — confirmed directly against the current table, where **0 of 2,186 winners have matching classes of two different block sizes, at any p**. (The admitting-count and the best-ratio figure — 654 of 1,666 values admitting one, best ratio 0.236·B at n = 1007 — are from the n ≤ 2000 run and want re-measuring at the current frontier; the qualitative finding is what the ceiling below explains.) Together with the earlier observation that no winner in the table has two matching classes of different sizes, that is the empirical side; the ceiling above is the structural side, and it says why.

**So the one-size presupposition is false but harmless.** Unequal-size shapes exist; they are simply escapes rather than competitors, exactly like the fusion shapes and the c = 2^a family of §6.5, and they sit outside the ceiling accounting for the same reason. Two consequences for the counts below: at **δ₀ > 1/9 the one-size counts are exact**, since no unequal shape is feasible at all; below 1/9 the covering set gains a partition factor, tabulated in the box that follows. The n = 551 = 256 + 167\* + 128 configuration — two matching classes at 2⁸ and 2⁷, cyclic layer C₂₅₅ × C₁₂₇ × C₁₆₇ — is §6.5's second escape and the worked instance.

**The standing check.** p = 3 is the one value that could put an unequal shape inside the competitive range, so **whenever the δ ≤ 1/16 tail is recounted, check it once against p = 3**. That is the whole residue of what this section leaves open.

> **What the partition factor costs below 1/9.** Worth tabulating, since the counts of §6.1 and §6.4 are stated per shape.
>
> - **Finiteness survives, and easily.** A shape records not only its parts but which matching parts share a size — a set partition of them. The number of distinct sizes is bounded by the number of matching classes, itself bounded by k ≤ 1/√δ₀, so the shape space stays finite and every shape is still one Bateman–Horn system, merely in several size variables rather than one. **The general principle — finitely many explicit systems, computable from δ₀ alone — is not at risk.**
> - **The counts change, by a partition factor.** For the purely additive shapes that carry the asymptotics, a shape with k parts and i foreign ones must additionally partition its j = k − i matching parts by size, giving Σ_{k≤K} Σ_{j<k} p(j) in place of Σ_{k≤K} k:
>
>   |  | | **additive shapes** | | | **all shapes** | | |
>   | δ₀ | K | one size (§6.4) | sizes free | sizes free, penalised | one size (§6.1) | sizes free | sizes free, penalised |
>   |---|---|---|---|---|---|---|---|
>   | 1/9 | 3 | 6 | 7 | 7 | 24 | 32 | **26** |
>   | 1/16 | 4 | 10 | 14 | 14 | 65 | 109 | **80** |
>   | 0.04 = 1/25 | 5 | 15 | 25 | 24 | — | — | — |
>   | 1/400 | 20 | 210 | 8,266 | — | — | — | — |
>
>   The two "sizes free" columns differ by whether a per-class penalty is charged. The **penalised** column is the one to quote, but the penalty's justification is the density ceiling above rather than a twist-parity argument: a class of size c′ ≤ c/p contributes at most (c′/n)², so an unequal shape needs x ≥ √(δ₀F)·(1 + 1/p) across its two sizes rather than √(δ₀F) for each, and that pushes some newly admitted shapes back out of feasibility. At δ₀ = 1/9 the effect is total — no unequal shape is feasible — which is why the one-size and penalised counts should agree at the top row and the table's 24 versus 26 there is worth re-deriving. At the conjectured floor of 1/25 the purely additive disjunction would be **24-way rather than 15-way** (the table's own bottom row); at the old 1/50 floor the pairs were 63 against 28 for the additive count and 1,956 against 982 for the raw one. A factor of about two in each case, not an explosion.
>
>   The growth of the additive count becomes Σ_{k≤K}Σ_{j<k}p(j) ~ K·p(K) = exp(π√(2K/3) + O(log K)), i.e. **exp(c·δ₀^{−1/4})** — worse than quadratic but still subexponential, and still far below the raw fusion count's exp(2.53·δ₀^{−1/3}).
> - **The ceiling table of §3.3 is not at risk.** A configuration with two unequal matching sizes has its smaller class capped at (c′/n)² ≤ 1/(p+1)², so its cap is *below* the equal-size shape of the same part count. Such shapes would enlarge the covering set without raising any class ceiling, so §3.3's caps stand as caps and §6.6's collapse argument is unaffected in kind, though the gaps ε it needs would have to be rechecked against the new shapes' caps.
> - **The parity reduction survives** unchanged: every matching size is a power of the same odd p, hence odd, so n ≡ ΣF_a + i (mod 2) regardless of how many distinct sizes there are.
>
> So the exposure is to the specific numbers of §6.1 and §6.4 below 1/9, not to the structure of the argument.

#### 6.3 How the naive count overstates the covering set

Granting §6.2's presupposition, three reductions apply to the raw table, and they are worth keeping apart because only some are unconditional.

**(a) A shape is already a number-theoretic object, not a group-theoretic one — so census shapes and systems are different counts.** The Bateman–Horn system attached to a shape sees the part sizes and nothing else. It does not see *which layer* holds a fusion. So **S5 and S7 at F = 2 are one shape and one system** — both are n = 2c + r\*, realised by two different Oliver groups distinguished only by whether the block swap sits in the top or the cyclic layer (§3.2). The same holds for every fused shape. The consequence is that the census counts (S1…S10, ten shapes) and N(δ₀) are measuring different things and must never be compared: one group realisation may serve several shapes, and one shape may carry several realisations. *This reduction is already built into N(δ₀) above*, which counts systems; it is listed because the comparison is the tempting error, not because it removes anything further.

**(b) Parity halves the set pointwise.** With p odd, c is odd, and every foreign r is odd, so n ≡ ΣF_a + i (mod 2), where i is the number of foreign parts. **A shape is available only at n of one parity**, so the disjunction at any given n runs over about half of N(δ₀). This one *does* cut the table: 24 splits 14 / 10 at δ₀ = 1/9, and at the old 1/50 floor the raw 982 split 498 / 484. (The c = 2^a escape sits outside it, as the remark above notes.)

**(c) Local obstructions prune further, per residue class.** §3.3 does this for the three-part family: at n ≡ 2 (mod 3) the full-efficiency system has ω(3) = 3 and vanishes identically, and the ℓ = 2 conditions cut the odd classes similarly. Every shape has such an analysis, and each removes that shape from the covering set at particular residues. **This is the one reduction not computed here.** Doing it for all shapes at the operative δ₀ is mechanical — each system is a few linear forms in one variable, and only ℓ = 2 and ℓ = 3 can obstruct (§3.3.1) — and it is the obvious next step, being the reduction most likely to be large: the three-part family alone loses a third of residues mod 12.

**What is *not* available is a domination argument.** One might hope some shapes are unconditionally beaten by others and could be dropped. The unconditional facts of that kind are already applied in generating the list: Lemma D1 removes F a power of p (bottom-layer fusion is absorbed into a larger block), Lemma D2 removes fused foreign blocks by domination rather than by exclusion, Lemma B′ removes foreign prime powers, and Part A removes fixed points. Beyond those, domination fails at exactly the interesting places — S4 and S7-at-F=2 realise the same shape, and *S7-at-F=2 dominates S4 on the matching term at every c* (2·C(c,2) against C(c,2)), so what prevents dropping S4 is no longer a congruence on c but the foreign and cross terms, which fusion also scales and which can bind either reading first. So the list cannot be shortened by comparing shapes to each other.

#### 6.4 Counting the shapes, before and after the reductions

**The raw count is a weighted partition problem.** A shape is a multiset {F_i} of fusion counts with Σ√F_i ≤ L, together with a choice of which of its F = 1 parts are foreign rather than matching; a multiset with m₁ parts equal to 1 admits m₁ + 1 such choices. So

> **N(δ₀) = Σ_{ M : Σ_{F ∈ M} √F ≤ L } ( m₁(M) + 1 )**,  over nonempty multisets M of positive integers.

The parts are drawn from {√1, √2, √3, …}, whose counting function is A(x) = #{F : √F ≤ x} = x², so their Dirichlet series is Σ_F (√F)^{−s} = **ζ(s/2)**, with a simple pole at s = 2 of residue 2. Meinardus' theorem for parts of counting order α with residue A gives log N ~ (1 + 1/α)·[A·Γ(α+1)·ζ(α+1)]^{1/(α+1)}·L^{α/(α+1)}, and at α = 2, A = 2,

> **log N(δ₀) ~ 3/2 · (4ζ(3))^{1/3} · δ₀^{−1/3} ≈ 2.532·δ₀^{−1/3}**.

So the raw set grows like exp(2.53·δ₀^{−1/3}) — subexponential in 1/δ₀, so halving the floor does not square the disjunction. Convergence is slow, as always for Meinardus: fitting log N against L^{2/3} over L ∈ [6,10] gives slope **2.416**, still climbing, and the asymptotic overstates the exact count by about 11× at the densities of interest. Use the exact sum in range and the asymptotic only for the growth.

**Applying the reductions changes the growth rate, not just the constant.** Reduction (a) is already in N. Reduction (b) halves it, which is invisible in log N. What matters is §6.5's observation that the **fusion shapes cover a density-zero set of n**, so the asymptotic covering set consists of the purely additive shapes — every F_i = 1 — with at least one foreign part. Those are counted directly rather than by a partition asymptotic: a shape is determined by its number of parts k ≤ K = ⌊L⌋ and its number of foreign parts i ∈ {1,…,k}, giving

> **N_add(δ₀) = Σ_{k=1}^{K} k = K(K+1)/2,  K = ⌊δ₀^{−1/2}⌋** — **quadratic in L, hence ≈ 1/(2δ₀)**.

And parity is now exact rather than approximate: since every F_i = 1, n ≡ k (mod 2), so **a shape with k parts serves exactly the n of parity k**. The covering set at a given n is therefore

> **Σ_{k ≤ K, k ≡ n (mod 2)} k**.

| δ₀ | K | raw N(δ₀) | additive N_add | at odd n | at even n |
|---|---|---|---|---|---|
| 1/9 | 3 | 24 | **6** | 4 | 2 |
| 1/16 | 4 | 65 | **10** | 4 | 6 |
| 0.04453 (verified to 10⁶) | 4 | 122 | **10** | 4 | 6 |
| 0.04 = 1/25 (conjectured) | **5** | 164 | **15** | **9** | **6** |

That is the number that belongs in the covering statement: **at the conjectured floor, 9 systems at odd n and 6 at even n**, before local obstruction cuts further. The exponential growth of the raw count is an artefact of counting fusion shapes that cover a vanishing set of n. Two readings of the last two rows, and they differ by a boundary case: K = ⌊1/√δ₀⌋ is 5 exactly at 1/25 and 4 at the verified 0.04453 — Proposition F.1's inequality is strict, so k = 5 is feasible only at δ exactly on the 1/25 boundary, and the conjectured-floor row keeps it as the inclusive (safe) covering set. The raised floor is a large cut either way: K was 7 at the old 1/50 floor, with additive count 28 splitting 16 odd / 12 even.

#### 6.5 The dichotomy, and where the conditionality enters

**Why conditionality is unavoidable once ω(n) ≥ 3.** Every block must have size ≍ n, so there are boundedly many. A p-characteristic block of size c needs a twist of order d ≥ δ₀n²/c to contribute at all (§6.2), and Oliver's chain requires the cyclic layer's total order to be coprime to the foreign translation orders and the block rotations. Distinct p-characteristic classes are *not* mutually constrained — Part E's diagonal generator carries all their twists at once (§6.2) — but two classes of different sizes are capped by the smaller one, at δ ≤ 1/(p+1)². Either way it pushes hard towards three escapes:

- **all blocks the same size** — one diagonal C_{c−1}, cyclic, with the top q-group coming free from permuting the blocks. This is n = F·c, the multiplicative engine, unconditional but needing ω(n) ≤ 2;
- **a block of 2-power size** — then c − 1 is odd and can sit cyclically beside C_{r−1} without demotion. This is what n = 551 = 256 + 167\* + 128 exploits, and §4.3 counts at O(n/log n) values;
- **demote one block's multiplicative group into the top q-group** — then Γ/Γ₁ = C_t must be a q-group, so t = (r−1)/d must be a prime power. That is the Sophie Germain condition, and it is where the conditionality enters.

Read this way η = 2/d is not an efficiency knob but **the price of using blocks of unequal size at all**, and the dichotomy explains why no unconditional family with ω(n) ≥ 3 has ever appeared in the computed table: from constructions of this shape, none can.

**Hence the fusion shapes drop from the asymptotic statement.** A shape with any F_i > 1 needs a q-power's worth of equal blocks, and in the extreme single-class case n = F·c it needs ω(n) ≤ 2 outright. Fused winners are 39.6% of the computed table, but that share is propped up by small n: the ω(n) ≤ 2 population thins like log log n / log n (§4), from 64.9% below 800 to 28.5% near 10⁶. So the fusion shapes cover a **density-zero** set of n, which is what licenses the N_add count of §6.4.

**In census terms** — with the caveat of §6.3(a) — the disjunction ranges over S3, S4 and S7 at F = 2 for the two- and three-class shapes, plus their higher-k analogues; S2 drops with the fusion shapes, and S6 through S10 either cannot occur or are supply-limited past the point of mattering (§4).

#### 6.6 The covering statement, and when it collapses to a single system

> **μ(n) ≥ δ₀·C(n,2) for most n  ⟹  for most n, at least one of a finite explicit set of Bateman–Horn systems is solvable at n** — the set being the purely additive shapes with at most ⌊δ₀^{−1/2}⌋ parts, of the parity of n, not locally obstructed at n's residue class.

At the conjectured floor that is **9 systems at odd n and 6 at even n** (§6.4; the count depends on the floor — at a 1/50 floor with K = 7 it is 16 and 12 instead, so quote it against a stated δ₀). It is a covering statement, and weaker than any single system being solvable — which is why the route ordinarily yields robustness rather than sharp prime theorems, and why the ladder survives individual systems failing: §3.3's local obstructions kill particular systems in particular residue classes without touching the conclusion, because another shape covers those n.

**But the disjunction collapses when δ₀ is set just below a class ceiling.** The shapes' ceilings are known and separated, so **a floor just under δ_c admits only the shape that attains it**. At n ≡ 11 (mod 12) the surviving shape is the F = 4 rung at 7 − 4√3 = 0.071797. The next one down is **not** S4's (5 − 2√6)/2 but the rung at (2 − √3)/4 = 0.066987, which each class reaches by a different route — **F = 2 at η = 1/6** when n ≡ 11 (mod 24) and **F = 6 at η = 1/2** when n ≡ 23, as §3.3.5 records — so the usable margin is only **ε < 0.0048**, a quarter of what the gap to S4 would suggest. That is a real weakening of this route: the separation it needs is now of the order of the difference between two adjacent fusion counts rather than between a fused and an unfused shape. The conclusion is

> for most n ≡ 11 (mod 12), **the system n = 4c + r with c a prime power, r prime and r − 1 = 6q^e for a prime power q^e, is solvable with c/n near (2 − √3)/2** — *the clause "c ≡ 3 (mod 4)" has been dropped (the twist is full at any c, §3.2.3), and the residue widened from 23 mod 24 to 11 mod 12 since the two halves are now equal*

— one system, not a disjunction. Three caveats:

- **The density-zero families must be excluded by hand**, being bounded by no class ceiling: n a prime power (S1), ω(n) = 2 (S2), and the escapes of §4.3 — c a power of 2, c or (r−1)/2 a power of 3, and r = 2^a·u + 1 with u small. Each is O(n/log n) or thinner, so "most n" survives, but the statement is about the complement of an explicit sparse set.
- **The gap between consecutive ceilings bounds ε**, and it is not uniform: 0.0048 at n ≡ 11 (mod 12) — the gap from 7 − 4√3 down to (2 − √3)/4, as computed above; a gap computed against F = 2 optima instead gives 0.0085, so state which optima — but the classes where two rungs tie — 7 and 15, where cap_B(1/4) = cap_C(1/2) exactly — admit **no** such ε, and there the disjunction genuinely cannot be collapsed.
- **It is conditional in the direction that matters.** The hypothesis is a lower bound on μ that we do not have; the argument shows that *if* the floor conjecture holds just under a class ceiling, the arithmetic consequence is sharp. That is a statement about the strength of the conclusion, not evidence for it.

So: **the route yields robustness at floors well below the ceilings, and sharp single-system statements at floors just beneath them.** The closer δ₀ sits to a class ceiling the stronger the arithmetic and the harder the hypothesis — worth stating because it identifies which floor conjecture would be worth proving. A floor of 1/25 gives a 9-way disjunction at odd n; a floor just under 7 − 4√3 at n ≡ 11 (mod 12) gives a single Bateman–Horn system.

---

## 7. What this says about the open problems

**The odd-n route above 1/9 is refuted.** It asked for a constant above 1/9 bounding δ from below on odd n, so Theorem E.1 would settle the collapse there wholesale. No such constant exists: **34.8% of the odd n in the computed table have δ(n) < 1/9** (312 of 897), and these are exact values of μ, not shortfalls of any family. Worse, the share grows — 23.6% of odd n below 800, 33.5% in [800, 1600), 43.3% in [1600, 2600]. (The corrected shape space lifts these values, so the shares are markedly lower than the pre-repair table gave; the *trend* is what closes the route, and it is unchanged.) The route is closed permanently, so **Open Problem 8(b) must be settled by promoting E.3(ii) directly**, which is the only remaining path.

**Open Problem 1** stands, and its second face is now closed. As stated it asks whether a family with different *local* structure can beat the ℓ = 2 and ℓ = 3 efficiency losses, which obstruct these families rather than μ itself. The subsidiary question — whether a shape determines a single Bateman–Horn system — turned on whether unequal matching sizes are admissible, and §6.2 settles that they are, at every p, since Part E's diagonal generator makes coprimality between distinct p-part twists unnecessary. What keeps them out of the accounting is the density ceiling 1/(p+1)², which makes them escapes rather than competitors. So Open Problem 1 is about lifting the obstructed residues and nothing else; the one standing check is p = 3 against the δ ≤ 1/16 tail. Since both systems already supply ~n/log³n representations wherever soluble, no strengthening of sieve input helps — this is a question about mechanisms.

**Open Problem 8(a) (k ≤ 3)** is the statement that the four-class cap 1/16 is never the best available, which needs ω(n) ≥ 3 together with no good two- or three-class representation. It has never occurred: no winner in the computed table uses four classes, and the δ ≤ 1/16 tail is 18 of 2,186 values (0.8%) — n = 527, 1159, 1175, 1739, 1763, 1817, 1943, 2015, 2057, 2075, 2117, 2147, 2183, 2279, 2303, 2387, 2507, 2599. The branch-and-bound of §5 adds a little: it examined every n ≤ 10⁶ whose lower bound fell below the running floor, and none of them wanted a fourth class either.

**Open Problem 8(b)** lives where the three-class family is the best available. With the above-1/9 route refuted, the only path is the direct one. It also **gets harder as the density floor falls**, since s ≤ 1/√δ − 1 — but the floor has risen rather than fallen: at the verified 0.04453 the cap is s ≤ 3.74, so **s = 4 and s = 5 are both out of reach throughout 10⁶** and E.4's collapse of s = 3 to a single dead pair is the whole remaining content. The branches with no theorem are unreachable at the current floor, which is the strongest form this reduction has taken.

**The §4 barrier at exponent 3/2** is untouched: both engines give density Θ(1) where they apply, and the barrier concerns lower bounds on the least prime in an arithmetic progression. The two obstructions are independent.

---

## 8. Open questions specific to this document

1. **Extend the ladder past 10⁶.** The scan is complete below 10⁶ (§5) and gives δ ≥ 0.04453 at n = 11183, with nothing below 1/25 anywhere in range. Pushing further is O(N²/log N) — about 4 hours to 10⁶, so 10⁷ is multi-day. The lower envelope has risen monotonically since [10⁴, 10⁵) and the global minimum has been fixed since n = 20,000, so the expected return is confirmation rather than a new minimum; the value is in how far the pattern can be pushed, not in what it is likely to find. **The cheaper win is at the other end**: computing B(n) at the ten lowest worklist entries, all in [10³, 10⁴], would either lift the verified floor above 1/25 with real margin or pin the minimum below 10⁶ exactly.

2. **Bound the s = 4 and s = 5 branches.** The only item here that is a gap in a *proof* rather than in evidence. *Recount after the rebuild:* at n = 3239 and 3059 the density rises sharply under the corrected shape space, so both leave the sub-1/25 set and the branch may narrow without any new theorem. E.1 caps s = 1 by the Mersenne constants and E.3(iii) caps the s = 2 repunit branch; s = 4 has neither, and is not thin enough for an E.4-style collapse. An absolute cap would have to come from the foreign block's twist, as in those two. The search clears it at every computed n, so nothing is unproved — but the gap widens as the floor falls.

3. **Predict the 1/12 shortfall from the singular series.** The odd/even split is **12.2% of odd and 0.2% of even** values below 1/12, over the contiguous range. Both engines' availability is computable heuristically, so this compares the whole framework of this document against measurement rather than testing any single family.

4. **Is the four-class family ever optimal?** Equivalently, does the triple coincidence of §6 ever occur? *Partial answer, measured.* Over odd n in [2×10⁵, 2.012×10⁵], the necessary condition — both the two- and three-class families below the four-class cap of 1/16 — holds at **95 of 600 values**, so it is far from rare. But at every one of those the three-class family still reaches 0.046–0.050, and a four-class family would have to beat that while capped at 1/16 = 0.0625 and needing **four** simultaneous prime conditions rather than three. The margin is a factor of only 1.25–1.35, against a supply penalty of one more log. So the answer is very likely no, and the reason is a squeeze rather than an obstruction — which also means it will not yield to a local-solubility argument. A proper heuristic estimate would compare the four-condition singular series against that margin directly; the machinery for it is `count_check.py` with a fourth form.

5. ~~**Do the ℓ = 3 escapes behave as the sparsity heuristic says?**~~ **Resolved (§4.3), and now proved rather than assumed.** All four escape routes reach **O(n/log n)** values of n: the residue's own ceiling confines the block to a ratio range of width under 4, which admits O(1) block sizes, leaving one prime's worth of freedom. Measured, the 2-power route's effectiveness falls 3.73% → 2.20% → 1.20% across n ≈ 10⁴, 10⁵, 10⁶ and the 3-power route reaches zero by 10⁶. The asymptotic constants are untouched; the escapes are conspicuous at computed sizes only because a log vanishes slowly.

6. **The fused family at ω(n) = 2 but bad splitting.** **338 of the 1,118** values with ω(n) = 2 do better with a split than with fusion, which happens when the smallest prime-power cofactor F is large. The distribution of F over ω(n) = 2 integers is classical, so predicting the 780/338 division is a clean test. (Both figures must come from the same slice — the 754/323 pair quoted elsewhere is the older n ≤ 2,298 range.)

7. **Efficiency below 1.** The distribution of the largest prime-power divisor of r − 1 over primes r is a shifted-prime question of Erdős type; the known results should be imported rather than re-derived, since η is what fixes every constant in §3.3.

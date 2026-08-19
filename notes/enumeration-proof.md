# Bounding μ(n) by enumeration of Oliver configurations

> **Pending: the numerical rebuild.** Figures marked ⟦PENDING-REBUILD⟧ are read off a table that
> predates the current SAFE cap and are known low at 289 rows — the density floor and its argmin, the
> census winner counts, and per-row witnesses. `mu_enumerate_v3.py` is the enumerator; running
> `check_doc_figures.py` against its completed output is the pass that replaces them. Unmarked figures
> from the current table remain correct as lower bounds but may rise. Structural and asymptotic claims
> are **not** provisional: the ceiling table is keyed mod 12 with six constants, confirmed by scanning
> real configurations per residue class (`ceiling_rederive.py`), and the ladder floors (**⟦PENDING-REBUILD⟧** to
> 10⁶, conjectured 1/25) are construction-side and independent of the cap.


*Companion to `orbital-evasiveness-notes.md` §2, whose "Which hypothesis is doing which work" table records which of this document's steps depend on Oliver's chain rather than on solvability or on k = 2 — every shape and fusion claim below is row 1 of it. Classifies the possible orbit-and-twist structures of an Oliver group, enumerates them, and establishes an upper bound on μ(n). Implemented in `mu_enumerate_v3.py`.*

**Status — read this first.** The three quantities the document works with are **not** totally ordered, and conflating them is the single easiest way to misread everything below:

> - **B_refined(n) ≤ μ(n)**, unconditionally, from Part E's explicit construction. This is the most robust of the three inequalities: it needs only that the constructions are groups.
> - **B_refined(n) ≤ B_safe(n)** by design. `B_safe` deliberately over-counts a p-characteristic part at F·orb(c, dmax) even where Lemma C's coupling reduces its twist further, precisely so that no assumption is made about which configuration is realisable.
> - **μ(n) ≤ B_safe(n)**, because F·orb(c, dmax) caps any point stabiliser whatever and Part 0's shape space covers every Oliver group. **This is the inequality with the worst track record** — it fails the moment a realisable shape is missing from the enumeration, and it has failed that way once, at n = 308 (see the gotcha in Part 0, step 3). It rests on Part 0's completeness and on the cap F·orb(c, dmax) being valid, and on nothing else.
> - **B_safe(n) ≥ μ(n) does not make B_safe an equality.** It may sit strictly above wherever a fallback configuration is the optimum — which is what the over-count is *for*.
>
> **B_safe = B_refined wherever the collapse is certified**, which is the point of E′: where a certificate applies, no fallback configuration attains B(n), the endpoints coincide, **B_refined = B_safe = B**, and hence **μ(n) = B(n)**. Every construction, every "μ(n) ≥ …" statement, and §5's floor rest on that. **⟦PENDING-REBUILD⟧** *The certified range is a script output, not a structural claim: both certificates rest on `fb_common.py`'s eight necessary conditions and are quoted only after a run against the current table. See `pending-checks.md` R1.*

**On the word "proved", and on what the numerical checks are for.** The statuses in this document mean *an argument has been written down that appears complete*, not *the argument has been verified by anyone else*. The distinction is not academic. Two compact structural steps read as plausible sketches and are false — the ΓL(1) step of Part B, and the q-power block count that Part G.2's pitfall box records — and a case analysis over the wrong partition of cases has produced a *near*-repair more than once. **Compact structural steps here have a poor track record, and every one of them repays being written out in full.** That is the standing reason for the pitfall boxes throughout, and for preferring a numerical check that could falsify a step to one that merely re-runs it.

**Notation, since three related quantities appear throughout.** A *configuration* is what the enumeration ranges over: a choice of chain primes (p, q) and orbit sizes n = Σ Fᵢcᵢ with twists, admissible in the sense of Parts B–D. Each configuration has a *score* — the minimum over its intra-orbital, within-class-cross and between-orbit terms (Part E) — and the two scorings differ on exactly one kind of part, a p-characteristic part whose twist the coupling of Lemma C strictly reduces:

<!-- DUP:B_definition -->
**B(n)** denotes the maximum, over all admissible configurations, of the minimum orbital size. It is computed by `mu_enumerate_v3.py`, over the shape space of `enumeration-proof.md` Part 0. **B₀(n)** is the coarser partition-only bound of Theorem 2.3, which ignores coherence and is therefore larger.
<!-- /DUP -->

> **B_safe(n)** = max over admissible configurations of the score with such a part valued at **F·C(c,2)**, the unconditional capacity: at most every pair inside every block of the class, which bounds any point stabiliser whatever.
>
> *Why the cap is flat, and the tightening that looks free and is not.* It is tempting to cut a fused class's twist by the block count — to argue that the block-rotation group C_{F_mid} and the cyclic part of the twist both sit in the one cyclic layer, which has a unique subgroup of each order, so the two must have coprime orders. **That argument is invalid, and the failure mode is worth naming because it recurs**: the block-permutation image is a *quotient* of the cyclic layer, not a subgroup of it. An **entangled generator** — an element z acting as a block rotation whose step-multipliers have product a generator of 𝔽_c^×, so that z^F is the full twist — supplies the block count and the full twist from a single cyclic subgroup, at any F_mid. So the cut is not a necessary condition, and imposing it makes the cap **anti-permissive**: it under-scores fused classes specifically, which is the direction that breaks μ(n) ≤ B_safe(n). See the projection-versus-subgroup gotcha in Part 0 step 3, which is the same error one level up.
>
> Note also that the flat cap's looseness is **not shape-neutral** — it credits a fused class every pair in every block regardless of twist, so it is generous to fused shapes specifically. That is the safe direction for an upper bound, and it is why census winner counts are sensitive to the cap in a way the bound itself is not.
>
> Lemma C's foreign strip is a different matter and survives: its proof is a conjugation argument on the r-primary component of the layer, which *is* a genuine subgroup (the foreign block's translations). SAFE deliberately does not use it, which is what keeps B_safe independent of Lemma C.
>
> B_safe is what `mu_enumerate_v3.py` computes by default and what the `mu_bound` column holds.
> **B_refined(n)** = the same max with such a part valued at F·orb(c, d) instead, which is what the Part E construction actually realises.
> **B(n)** := **B_safe(n)**, written without a subscript wherever the distinction is not at issue.

Since C(c,2) ≥ orb(c, d) always, B_refined ≤ B_safe. The *collapse* results below (E′, E″, the two certificates) show the two endpoints coincide over the computed range, which is what turns the sandwich into the equality μ(n) = B(n) there.

**Lemma B′'s socle argument has had two independent readings, agreeing** — Step 0 does need irreducibility plus C_G(V) = V, exactly as written. A third reader remains worth more than another pass by either existing one, per the track record noted above.

---

## Part 0. The picture proof

*Self-contained, and deliberately free of the vocabulary used elsewhere in this document, so it can be checked without cross-referencing. Every place it defers to a lemma is marked, and the lemma inventory at the end says exactly what each lemma must establish. Terms are defined where first used.*

**What we are bounding.** We shuffle n labelled points. A *shuffling group* is a set of shuffles closed under composition. The **three-layer condition** (Oliver's condition) requires the group to break into a bottom layer in which every element's order is a power of one prime — the **home prime** — a middle layer generated by a single element, and a top layer in which every order is a power of a second prime, the **top prime**. Only such groups are usable.

Given such a group, look at the pairs of points. A **family** is a set of pairs that the shuffles carry onto one another. The **score** of a group is the number of pairs in its smallest family. We want μ(n): the largest score any usable group on n points achieves.

### Step 1 — splitting into chunks

A **chunk** is a set of points that shuffle among themselves and never mix with the rest.

```
                  the n points split into chunks
                                |
                every pair of points is one of two kinds
                                |
              +-----------------+-----------------+
              |                                   |
     both points in one chunk            points in two chunks
     (the hard case -- step 2)           family holds at most
              |                          (size A) x (size B) pairs
              |                                   |
              +-----------------+-----------------+
                                |
                 score = the smallest family of all
          over-stating any one family over-states the score,
                    and over-stating is the safe direction
```

**But the chunks are not independent.** The middle layer is a *single* generator serving the whole arrangement, so anything any chunk needs from it competes with everything every other chunk needs from it. Writing the n = 308 arrangement out:

```
  +--------------------------------------------------------------------+
  |  the middle layer: ONE generator, shared by the whole arrangement   |
  |  its order factors into prime powers -- each prime available ONCE   |
  +--------------------------------------------------------------------+
        ^                        ^                        ^
        | demands 3 and 52       | demands 149            | may demand
        |                        |                        | none of 2,3,13,149
   +---------------+      +----------------+      +--------------------+
   | chunk of 159  |      | chunk of 149   |      | any further chunk  |
   | 3 copies of a |      | one outside    |      |                    |
   | 53-block      |      | block; its     |      |                    |
   |               |      | twist is up top|      |                    |
   +---------------+      +----------------+      +--------------------+
                                |
             allowed only if every demanded prime is distinct
             here 3, 52 and 149 share nothing, so it stands
```

**The coupling is what makes chunks non-independent**, and it is invisible if one assumes copy counts come from the top layer, where nothing competes. Any argument that treats the chunks separately is implicitly making that assumption.

### Step 2 — inside one chunk

*No minimality assumption is made anywhere: this applies to every chunk, since the score is a minimum over the whole arrangement and a skipped chunk could hold it.*

A **block** is the smallest repeating unit the shuffles never split apart. The **twist** is the extra shuffling inside a block, beyond sliding every point along by a fixed amount and wrapping round (the **sliding step**).

```
       a chunk is several identical copies of one block
       chunk size = (number of copies) x (block size)
                            |
       the block size is one prime raised to a power     [Lemma B]
                            |
            +---------------+----------------+
            |                                |
      MATCHING block                   OUTSIDE block
      size is a power of the           size is a prime other than
      home prime; the bottom           the home prime -- and then it
      layer shuffles points            is that prime EXACTLY, never
      around inside it                 a power of it        [Lemma B']
            |                                |
            +---------------+----------------+
                            |
            two kinds of pair live inside a chunk
                            |
            +---------------+----------------+
            |                                |
     both in the same block          in two different blocks
     at most                         at most
     copies x (pairs in a block)     copies x (block size) squared
```

### Step 3 — where the copies come from

```
   copies = (bottom-layer factor) x (middle-layer factor) x (top-layer factor)
                                |
        +-----------------------+-----------------------+
        |                       |                       |
   BOTTOM layer            MIDDLE layer             TOP layer
        |                       |                       |
   matching block:         the only requirement    this factor is a
     the chunk becomes     is that the middle      power of the top
     one bigger block      layer keeps a single    prime
         [Lemma D1]        generator                   |
   outside block:              |                       |
     a family drops to     so this factor must         |
     about copies x r      share no prime with         |
         [Lemma D2]        any twist or outside        |
        |                  block ANYWHERE in the       |
        v                  arrangement                 |
   factor = 1                  |                       v
   nothing is lost             v                  a power of q
                        *** NO LEMMA KILLS THIS ***
                          n = 308 realises it
```

> **The gotcha, and it is the one that has actually bitten.** The middle column is easy to lose. The tempting argument runs: the group permuting the copies is transitive on them, it sits in the top layer, a transitive q-group has q-power degree, therefore the copy count is a power of q. Every step of that is fine **except the second**, which is assumed rather than shown — and it is false. The block-permuting group may sit in the **middle** layer instead, where the only requirement is that the middle layer stay single-generated, i.e. that the copy count be coprime to every twist and outside block anywhere in the arrangement.
>
> **n = 308 realises exactly this.** Take BBKN's own Γ = Γ₀(53, Z₃) × Γ(149, 37): three copies of a 53-block with the 3 living in the middle layer, plus an outside block of 149 with twist 37. The chain is Γ₂ = (F⁺₅₃)³, a 53-group; Γ₁/Γ₂ = C₅₂ × C₃ × C₁₄₉, cyclic because the three orders are pairwise coprime; Γ/Γ₁ = C₃₇. Its terms are 3·C(53,2) = 4134, 3·53² = 8427, 159·149 = 23691 and orb(149, 37) = 5513, so m\* = **4134** — and the copy count 3 is a power of neither the home prime 53 nor the top prime 37, so no q-power-only enumeration can see this group at all. That is already fatal to such an enumeration as an upper bound, since μ(n) ≥ 4134 here and the restricted search returns 3775. **And the phenomenon is not confined to this group:** the winner at n = 308 is `3x67 + 1x107*` at (p, q) = (67, 53), whose block count 3 is again a power of neither prime, and whose score B(308) = 5671 the restricted enumeration cannot reach either.
>
> **The near-miss repair is worth recording too**, because it is the same mistake one level down: an attempted fix argued by cases on whether the finest block is matching or outside, and concluded the q-power claim survived. It never considered a copy count that is neither a q-power nor a p-power — a *third* prime living in the middle layer, which is precisely what happens here. Case analyses over the wrong partition of cases are the recurring failure mode in this document.

### The lemma inventory

Five deferrals above, plus one that whittles step 1 rather than steps 2–3. This is the whole list of what has to be checked.

**Lemma B — the block size is one prime raised to a power.** *Must show:* the shuffles acting on a single block, with no smaller repeating unit inside it, are of the kind arising from arithmetic in a finite field. The three-layer condition forces solvability; a classical theorem then gives affine structure of prime-power degree. **Status: sound. The settled step.**

**Lemma B′ — an outside block has prime size, never a prime power.** *Must show:* that every nontrivial normal subgroup of the block's primitive affine group contains the socle; that the middle layer's image is then cyclic containing it, forcing prime size; and that the whole twist lands in the top layer. **Status: proved in full (Part B), including the socle step and the degenerate branch where the middle layer acts trivially. Read in detail by a second reader.**

**Lemma C — a middle-layer twist sharing a prime with an outside block couples the two.** *Must show:* that the top layer's conjugation is a single power map on the cyclic layer, so its Frobenius exponent on the matching block and its multiplier on the outside block agree mod r; hence the outside twist divides ord_r(p), which divides a. **Status: proved at every a (Part D). Shares are admissible — there are explicit Oliver groups at n = 28, 21 and 10 — so this is a coupling, not an exclusion, and what removes such configurations is Corollary C′'s domination, whose range-scoped half expires silently.** Does not affect B_safe, which caps every matching block at F·orb(c, dmax) without reference to it. **It does bear on the collapse:** `fb_common.py`'s condition (4) uses the corollary to cap a leftover part's twist, so that strip is necessary above the n·log₂n threshold rather than unconditionally.

**Lemma D1 — bottom-layer copies of a matching block are absorbed.** *Must show:* the chunk's size is then again a power of the home prime, so the chunk appears on the list already, as a single block with no copies; and that the single-block reading never scores lower. **Status: proved (Part D2). Two copies of a 4-block score 2 × 6 = 12; the same chunk read as one 8-block scores 28.**

**Lemma D2 — a fused outside block is dominated.** *Must show:* that its translations are diagonal across the copies, because independent copies would put a non-cyclic group into the middle layer; that when F < r the per-block origins can be normalised so the same-position pairs form an invariant class of C(F,2)·r; and that with the within-block class F·C(r,2) this caps the whole configuration at n^{3/2}/2. **Status: proved at every r (Part D2). Fused outside blocks do exist — there are explicit Oliver groups reaching m\* = 3|O| — so this is a domination statement, not an exclusion, and its use carries a range-scoped half.**

**Theorem 2.3 — B₀ bounds μ, and the chunk count is at most two.** Whittles step 1. *Must show:* the two per-chunk bounds (Part A), and that splitting into many chunks never beats splitting into few. **Status: the bound μ ≤ B₀ is proved (Part C). The two-part reduction is *not* proved — cap is not monotone, so merging parts can lower the cap term — and is verified by exhaustive comparison to n = 1200. Only the O(n) cost claim for B₀ depends on it.** Proof now in Part C rather than the companion document.


### Index: where each lemma is stated and proved

| Lemma | Statement | Proof | Rests on it |
|---|---|---|---|
| **B** — block size is a prime power | Part B, opening box | Part B, opening box | everything |
| **B′** — an outside block has prime size | Part B, under *foreign characteristic* | same place | the upper bound, and only this |
| **C** — a middle-layer twist sharing an outside prime couples the two | Part D, opening box | Part D, opening box, **proved at every a**; exclusion is Corollary C′'s domination | `--refined`, attainment, **and the collapse certificate's condition (4)**; not B_safe |
| **D1** — bottom-layer copies of a matching block absorb | Part D2 | Part D2, proved | the block-count split F = F_mid·F_top |
| **D2** — fused outside blocks are dominated | Part D2 | Part D2, **proved**; the r = q case (D2q) is the sharpest | the block-count split F = F_mid·F_top |
| **2.3** — B₀ bounds μ; chunk count ≤ 2 | Part C, opening box | Part C — bound **proved**, two-part reduction **verified to n = 1200 only** | Part F's search bounds |
| **E.1–E.4** — the fallback branches | Part E′ | Part E′ | the collapse, not the bound |

**One entry is not a complete proof.** Theorem 2.3 has two halves. The bound μ(n) ≤ B₀(n) is proved in Part C. The **two-part reduction** — that the maximising partition never needs three or more parts — is *not* proved. The tempting justification — "more parts only shrink minᵢ cap(sᵢ)" — is false, since cap is not monotone (cap(127) = 8001 against cap(129) = 2709), and the gap has not been closed. It is verified exhaustively to n = 1200, and nothing depends on it except the O(n) cost claim for B₀; the inequality μ ≤ B₀ quantifies over all partitions regardless.

**Lemma C is a coupling rather than an exclusion**, and holds at every a. B_safe does not use it, so the *bound* is unaffected — but the **collapse certificate does**: condition (4) of `fb_common.py` caps a leftover p-characteristic part by stripping the foreign primes from its twist, which is justified by Corollary C′ among configurations scoring above n·log₂n. Since the certificates only ever evaluate candidates against thresholds far above that line, the strip applies at every a, and the obstacle to replacing B_safe by B_refined outright is correspondingly removed.

Everything else in the table is proved, Lemma B′ included; its socle step and its degenerate branch are the two clauses a compressed version tends to assert rather than establish, and both are written out in Part B.

### Six worked cases

Each isolates one phenomenon. All figures recomputed.

**A. n = 10 — copies from the top layer.** Two copies of a 5-block, copies from the top prime 2. Inside one block 2 × C(5,2) = 20; across the two blocks 2 × 5² / 2 = 25. Score **20** = B(10). The shape the program already knows. The halving on the across-blocks term happens exactly when **F is even** — here F = 2, so the fusing prime and F's parity coincide and either reading gives 25; see the parity pitfall box in Part E, since keying this on q instead is wrong the moment F is not a q-power.

**B. n = 308 — copies from the middle layer.** Three copies of a 53-block, plus an outside block of 149 with twist 37 from the top layer. Terms 4134 / 8427 / 23691 / 5513, score **4134**. *This is a configuration a q-power-only block count cannot see*, which would value n = 308 at 3775 and so fail to bound μ. It is not the optimum there — the winner is `3x67 + 1x107*` at 5671, itself a cyclic-layer block count — which is the point worth taking: the missing shapes are not exotic outliers but the ordinary inhabitants of the space. The chain: bottom layer = three copies of the additive group of the 53-element field, a 53-group; middle layer = C₅₂ × C₃ × C₁₄₉, cyclic since pairwise coprime; top layer = C₃₇. Home prime 53, top prime 37, and 3 is a power of neither.

**C. A collision.** Three copies of a 7-block. The twist on a 7-block divides 6. Were the twist 6, the inside-one-block family would be 3 × 21 = 63; but the copies have already spent the prime 3 in the middle layer, so the twist may only divide 2 and the family is 3 × 7 = **21**. A factor of three lost. The coupling is not merely bookkeeping: it can cost more than the new branch gains, so the corrected B is **not** uniformly larger and the table must be recomputed rather than adjusted upward.

**D. Absorption (Lemma D1).** Home prime 2, two copies of a 4-block fused by the bottom layer. As copies: 2 × C(4,2) = 12. As a single 8-block: C(8,2) = **28**. The coarser reading scores higher and is the one already listed, so refusing bottom-layer copies here loses nothing.

**E. Why an outside block cannot be fused (Lemma D2).** Home prime 2, two copies of a 19-block plus a 32-block, n = 70. The twist of order 9 on the 19-blocks is the quadratic residues mod 19; since 19 ≡ 3 (mod 4), −1 is a non-residue, so the twist together with the block swap generates all of 𝔽₁₉ˣ and the offset classes have 18 elements. The between-block pairs of nonzero offset therefore form a class of 19 × 18 = 342. But the **offset-zero pairs form a class of just 19** — the translations are diagonal, so no shuffle can move a same-position pair to a different-position one. So m\* ≤ 19, against B(70) = 301. *Scoring the between-block term as (F/2)·r² = 361 here makes this configuration look like a counterexample to the whole framework; the diagonal class is what kills it.*

**F. n = 3239 — a cyclic-layer block count at a record-relevant value.** Seven copies of a 256-block plus an outside block of 1447 with twist 241. Terms 228,480 / 458,752 / 2,593,024 / 348,727 → score **228,480**, density **0.043570**. Seven is a power of neither the home prime 2 nor the top prime 241, so a q-power-only count values this n at 136,957 (density 0.026117) instead. This n scores **289,230 (density 0.055155)** via `6x311 + 1x1373*`, well above the global floor, so the case is kept for the block-count phenomenon rather than for its density. **The gotcha it records:** a q-power-only block count values this n at 136,957 instead, so a "minimum over n ≤ 10⁶" computed that way has an argmin that is an artefact of the missing shape rather than a fact about μ.

### The configuration census

*Every shape the framework admits or excludes, in one place. **Winner counts are measurements of the current table over its contiguous range** — every non-prime-power to n = 2600, 2,186 rows — and move with every extension; `validate_table.py` prints them back for copying. The "trend" column is a winner share across thirds of the range, and is what tests a `wins → 0` verdict: the verdicts are asymptotic limits, so a count alone tests nothing and only a declining share does.*

*`aod` = `arithmetic-of-density.md`. The **δ behaviour** column describes the unfused rung; the class ceilings themselves are keyed **mod 12** and are in `aod` §3.3, which is the sole ceiling table.*


| # | Shape | Status | Winners | Trend | Asymptotic guess: **exists** / **wins** | δ behaviour | where |
|---|---|---|---|---|---|---|---|
| **S1** | one matching block, no copies | enumerated | every prime power (skipped: prime powers) | — | **exists → 0**, **wins → 0** — the same set, since where the shape exists it wins outright. Prime powers are O(N/log N) | trivial where it applies: n = c, AGL(1, n) 2-transitive, δ = 1 | `aod` §4.1 |
| **S2** | fused matching class, **top**-layer copies, n = F·c | enumerated | **777** (35.5%) | 49.1 → 36.2 → **32.6%** | **exists → 0**, **wins → 0** — essentially the same set: δ = 1/F beats every additive shape at small F, so it wins nearly wherever it exists. Needs ω(n) = 2 with both factors prime powers | clusters at **1/F**: 0.4995, 0.3326, 0.2492, 0.1992, 0.1420, 0.1103. Holds every δ > 1/4 | `aod` §4.1 |
| **S3** | matching + outside, n = c + r\* | enumerated | **900** (41.2%) | 41.2 → 45.8 → **45.9%** | **exists → all even n *plus a positive proportion of odd n***, **wins → all six even classes**. All even n conjecturally; at odd n the shape survives with c = 2^a, i.e. n = 2^a + r\*, which Romanov puts at positive lower density and Erdős's covering congruences keep bounded away from all of odd n. The only row where existence exceeds winning by a positive **density** rather than merely by a rate — the odd instances exist but almost never sit well enough near the balance point to win. On the even side the two limits agree and existence still converges faster | → class cap. Medians 0.220/0.221/0.218/0.213 at n ≡ 0,4,6,10 (cap **1/4**); 0.1265/0.1272 at 2,8 (cap **0.13397**) | `aod` §3.1 |
| **S4** | two matching + outside, n = 2c + r\* | enumerated | **16** in the v4 baseline (0.7%), all c ≡ 1 (mod 8) — **⟦PENDING-REBUILD⟧ 15 of the 16 are exceeded by entangled two-class readings** (all but n = 1529; see the three-part box in Part I), so ~0–1 is expected on the rebuild, consistent with the first-instance table's "no winner" | 6.1 → 13.9 → **20.0%** | **exists → 12/24** (all odd n), **wins → 0.** The cyclic-layer fused rung beats it at every c, since 2·C(c,2) > C(c,2) with no congruence in play (`aod` §3.2.3), so it is dominated inside the three-part family as well as outside it. The widest existence/winning gap in the census: available almost everywhere, beaten by the fused rung where that rung is reachable and by F = 4 where it is not — see `arithmetic-of-density.md` §3.2 and `three-part-family-split.md` | → class cap. Medians 0.1033/0.0997 at 1,9 (**1/9**); 0.0782/0.0765 at 3,7 (**0.08579**); 0.0695 at 5 (**0.0718**); 0.052 at 11 (**0.05051**) | `aod` §3.2, §3.3.5 |
| **S5** | **top-layer**-fused matching + outside; forces q = 2, hence η = 1/u | enumerated | **30** (1.4%) | 3.6 → 3.9 → **1.6%** | **exists → 12/24** (all odd n — q = 2 fusion is always buildable, just usually at a useless η), **wins → 0**. An escape: winning needs η = 1/u with u small, i.e. r = 2^a·u + 1, which is O(log n) candidates per n | cap₂(η) = 0.17157 at η = 1, but η = 1 needs a **Fermat** prime; at η = 1/3 it is 0.10102, already below S4's 1/9. Max seen 0.1614 (n = 639) | `aod` §3.2, §3.3, §4.3 |
| **S6** | two outside blocks | enumerated | **0** | 0 → 0.2 → 0% | **exists → 12/24** (every even n with a Goldbach representation); **wins → 0**, by local obstruction rather than scarcity — the cap 1/(√m₁+√m₂)² reaches 1/4 and 0.17157 only on families with ω(3) = 3, leaving n = 26 and n = 20 | ceiling is 1/4 but unreachable: it needs both rᵢ − 1 = 2q^{aᵢ} for a **common** q with a₁ ≠ a₂, an O(N^{1/3}) set | `aod` §4.2 |
| **S7** | **middle**-layer-fused matching + outside; **F = 2 is the odd-n fused rung B** | enumerated | **338** at F = 2 (15.5%); **50** at F = 4; 53/3/17/2 at F = 3/5/6/8 | 2.7 → 2.3 → **3.4%** | **F = 2: exists → all odd n**, **wins → five of the six odd classes** — n ≡ 1, 3, 5, 7, 9 (mod 12), whose class ceiling it attains. At n ≡ 11 (mod 12) the ceiling belongs to F = 4. **F ≥ 3: exists → every n; wins → one odd class**, n ≡ 11 (mod 12), all of it at F = 4. Split by the parity of F. **Odd F** needs F·c even, hence c = 2^a at odd n — O(log n) sizes per n, an escape, winning nowhere since S3's cap 1/4 beats F = 3's 0.13397 at even n. **Even F** has no such restriction: at odd n, F·c is automatically even and c ranges over all prime powers, so the supply is a full Hardy–Littlewood system, and **F = 4 attains the class ceiling at n ≡ 11 (mod 12)** (`aod` §3.3.5) | cap_F(η) = η/(1 + √(Fη))². F = 2: **0.17157 / 0.12500 / 0.10102 / 0.06699** at η = 1, ½, ⅓, ⅙. F = 4: **0.11111 / 0.08579 / 0.07180 / 0.05051** at the same η. Decreasing in F, so a larger F pays only when it unlocks a better η | `aod` §3.2, §3.3, §4.3 |
| **S8** | bottom-layer-fused matching | killed, **D1** | — | — | never exists, so neither limit is defined | F·C(c,2) < C(F·c,2) strictly | Part D2 |
| **S9** | fused outside block, any layer | **exists; dominated, D2** | 0 | — | **exists → positive** (every n = F·r with the permuter admissible); **wins → 0**, capped at n^{3/2}/2 by D2 and checked below B(n) across the computed range | m\* ≤ n·min(F,r)/2, so δ = O(n^{−1/2}) → 0 | Part D2 |
| **S10** | outside block with r = q, any F | killed | — | — | never exists, so neither limit is defined | the twist is forced into the cyclic layer beside the translations, hence trivial (D2q) ⇒ the orbit is worth \|O\| | Part D2 |

> **One computed instance of each live shape**, from the current table (**⟦PENDING-REBUILD⟧** — the rebuild is in progress, so first-instance values move with it). The starred part is the foreign block; each is the first value of n at which that shape is the winner.
>
> | shape | first instance | witness | B(n) | δ | binding term |
> |---|---|---|---|---|---|
> | S1 | every prime power | n = c, AGL(1, n) | C(n,2) | 1 | the single orbital |
> | S2 | n = 6 | `p=3 q=2: 2x3` | 6 | 0.400000 | intra, F·C(c,2) |
> | S3 | n = 30 | `p=13 q=2: 1x17* + 1x13` | 78 | 0.179310 | the 13-block |
> | S4 | — | no winner in the computed range | — | — | dominated by the fused rung at every c |
> | S5 | n = 475 | `p=109 q=2: 1x257* + 2x109` | 11772 | 0.104570 | intra, 2·C(109,2) at full twist |
> | S7 at F = 2 | n = 99 | `p=23 q=13: 1x53* + 2x23` | 506 | 0.104308 | the foreign 53, at twist 13 |
> | S7 at F ≥ 3 | n = 143 | `p=2 q=23: 3x32 + 1x47*` | 1081 | 0.106471 | the foreign 47, at twist 23 |
>
> **S5 and S7 at F = 2 are the pair to compare**, since they differ only in which layer holds the swap and nothing else in the witness string distinguishes them — both read `2×c + r*`. The tell is the top prime: q = 2 means F_top = 2 and the fusion is top-layer; any odd q means F_mid = 2 and the fusion is cyclic-layer. **The twist is full either way** — a cyclic-layer fusion costs nothing on the matching side — so what separates them is the foreign efficiency: q = 2 forces η to the 2-part of r − 1, while an odd q leaves it free. *Gotcha: reading the cyclic-layer case as paying for its swap out of the twist is the error that makes S5 look like the stronger shape; it is the weaker one at odd q.* `arithmetic-of-density.md` §3.2 scores all three readings at the same n.

> **The asymptotic column reports two limits, not one.** **Exists** is the proportion of n at which some admissible configuration of the shape can be built at all; **wins** is the proportion at which one attains B(n). They coincide for the rare-but-dominant shapes (S1, S2), diverge completely for S6 — available at essentially every even n and winning nowhere — and diverge sharply across the odd-n family, where S4, S5 and S7 at F = 2 are all available at essentially every odd n and the ceiling comparison of `aod` §3.3 decides which of them takes the value. Even where the two limits agree, existence converges faster, since a representation becomes available long before it becomes good enough near the balance point to beat everything else.
>
> **The winning shares sum to 1; the existence shares do not.** Several shapes coexist at the same n — which is what makes the ceiling comparison the substantive question — so the existence column double-counts by design, and S3 in particular is not confined to one parity. Its odd-n existence density is also not known to converge: Romanov gives a positive lower density for n = 2^a + r\* and Erdős an upper bound below 1, with the limit unsettled, so that entry is a proportion bounded away from both ends rather than a value.

> **Asymptotics are covered in `arithmetic-of-density.md`, not here.** This census's asymptotic column is a summary; the arguments behind it — which shapes thin, which stop winning, and the O(n/log n) count of the escapes — are §4 of that document, and it carries the same census keyed by the same S-numbers. The duplication is deliberate and cross-checked by `check_doc_figures.py --pass census`; **S-numbers are append-only**, since they are what joins the two.

**S7 splits at F = 2, and only the F ≥ 3 half vanishes.** Write the shape as n = F·c + r with r an odd prime. At **F = 2** the shape is the odd-n **fused rung B**: it carries 5/12 of all n asymptotically, is the sole winner at the five odd classes n ≡ 1, 3, 5, 7, 9 (mod 12), and is the commonest single shape among the odd rows. It does not vanish and is analysed in `aod` §§3.2–3.3 alongside S4, not here. What follows is about **F ≥ 3**, which does vanish, for a reason that differs by parity.

- **n odd** forces F·c even. With F = 3 or 5 this forces **c to be a power of 2**, so there are only O(log n) choices of c *per n*. All 12 odd-n instances in range have c ∈ {32, 128}. That is a count of representations, not of values of n; `aod` §4.3 converts it, giving O(n/log n) values reached.
- **n even** forces c odd, and the supply is a full Hardy–Littlewood system. But even n already have S3 available with cap 1/4, comfortably above the F = 3 ceiling of 0.13397, so S7 at F ≥ 3 can only win at even n where S3's *local supply* fails. All 45 even-n instances are of this kind. Under the conjectures that give S3 its supply, this set is thin.

So S7 **at F ≥ 3** is an escape rather than a competing family — reaching O(n/log n) values, like the other escape routes (`aod` §4.3) — but it is a genuine one, and it raises the odd-n ceilings where it applies. Among F ≥ 3 only F = 3 and F = 5 occur at all: larger fusion primes shrink F·C(c,2) faster than the foreign term can compensate.

> **S7 at F = 2 versus S5, since the two are easy to confuse.** Both fuse two equal c-blocks alongside a foreign block, and they differ only in which layer holds the swap. In the **cyclic** layer (S7 at F = 2) the swap competes with the twist, so the twist is cut to the odd part of c − 1 and the gain depends on c mod 8 — but the top prime is free, so the foreign efficiency η is unconstrained. In the **top** layer (S5) the twist is untouched and the intra term is 2·C(c,2) for every odd prime power c — but q is forced to 2, so η = 1/u with u the odd part of r − 1. The first is a carrier of the odd-n asymptotics; the second is supply-limited to r = 2^a·u + 1 with u small and is therefore an escape. Over v4, 150 winners are the cyclic-layer rung and 24 are S5. Full treatment in `arithmetic-of-density.md` §§3.2–3.3.

**`ladder_verify.py` reaches both.** Its S7 loop runs over F ∈ {3, 9, 5, 25, 7} — F = 2 is deliberately absent from it, because at F = 2 the shape is not an escape but the odd-n fused rung and belongs with the family it competes against. Both F = 2 readings are therefore scored in the three-part branch instead: **rung B** (cyclic-layer swap, **full twist at every c**, q restricted to odd primes) and **rung B′** (top-layer swap, full twist, η the 2-part of r − 1). Its `CAP` table is keyed on the **mod-12** ceilings of `arithmetic-of-density.md` §3.3, which is what the rung values are measured against. **The gotcha the script guards against:** scoring rung B with a twist cut by the block count understates it at every c, and since the script takes a max over families it would report a floor that is too low rather than an error.

<!-- DUP:theorem_3_1 -->
> **Theorem 3.1 (structure of Oliver groups).** Let Γ satisfy Oliver's condition on n points. Then for some pair of chain primes (p, q) the Γ-orbits are described by
>
> **n = Σᵢ Fᵢcᵢ**, each cᵢ a prime power and each **Fᵢ = F_mid,ᵢ · F_top,ᵢ** with F_top a power of q,
>
> in which each orbit is either **p-characteristic** — cᵢ a power of p, twist any divisor of cᵢ−1 — or **foreign** — cᵢ prime, twist a power of q, and unfused (fusing an outside class is possible but dominated, Lemma D2, so no extremal configuration contains one). *Gotcha: there is deliberately **no** clause requiring every F_mid, cyclic-layer twist and foreign prime pairwise coprime. That is **not a necessary condition**. The block-rotation image C_F_mid is a quotient of the cyclic layer, not a subgroup, and an entangled generator (block rotation whose F-th power is a full twist) realises the full twist at any F_mid; explicit counterexample groups at n = 33, 78, 105. What survives: foreign primes are pairwise distinct (unique-subgroup argument on genuine subgroups), and twist-vs-foreign shares remain governed by Lemma C's coupling. The orbital-size clause below stands with dᵢ unrestricted by F_mid.* Imprimitive tower depth contributes nothing beyond Fᵢ. The orbital sizes are then *forced*, not chosen: **Fᵢ·orb(cᵢ, dᵢ)** within a fused class, **(Fᵢ or Fᵢ/2)·cᵢ²** between the blocks of one class — Fᵢ for odd Fᵢ and Fᵢ/2 for even Fᵢ, keyed on the block count's parity rather than on q — and **sᵢsⱼ** between distinct orbits.
<!-- /DUP -->

### What the corrected shape space is

A class is F blocks of size c with **F = F_mid · F_top**, where F_top is a power of the top prime and F_mid is subject only to the middle layer remaining single-generated. F_bottom = 1 by D1, and outside classes are taken unfused by D2's domination. The middle layer's order is then a single product of pairwise-coprime factors drawn from: every F_mid, every twist in the middle layer, and every outside block size, across the whole arrangement at once.

The enumeration therefore cannot stay "pick parts, then check constraints". The natural order is to choose the middle layer's factorisation first and distribute it, which is a restructure of `best_with_k` rather than an extra branch.

*Case E below is a worked instance of D2 at F = 2 — where the same-position class is exactly |O|/2 — rather than an independent case, and is kept because the mis-scoring it guards against is easy to repeat.*

*Two axes deliberately absent from the trees.* The **twist's shape** never gets a branch, because the safe scoring credits every matching block with every pair inside it — the most it could contribute — so no assumption about the twist can inflate the bound. This is also why an open question, whether the twist must come from field arithmetic at all rather than being any irreducible linear group, does not threaten the upper bound; it bears on attainment. And **nesting**: a chunk with block systems at several depths splits its cross-families further, so it scores no higher than the flattened reading.

## Part A. Reduction to orbits and crosses

> *This Part is about how a given group's score decomposes, not about which groups exist, so it is independent of the shape space. One coupling to carry forward, from Part 0 step 1: the chunks are **not** independent, because block counts may come from the cyclic layer and that layer is one shared generator. Any argument here that treats parts as freely combinable needs the coprimality budget attached.*

Let Γ have vertex orbits O₁, …, O_k with |O_i| = s_i. A pair inside O_i has its whole Γ-orbital inside O_i, and a pair between O_i and O_j has its orbital inside O_i × O_j. Hence

> m\*(Γ) ≤ min( min_i M_i , min_{i<j} s_i·s_j ),

where M_i is the minimum intra-orbital of the transitive group Γ|_{O_i}. Both terms are needed: the first is the intra-orbit content, the second bounds every cross class by the total number of pairs available to it. Parts of size 1 are permitted but contribute a cross bound of s_j, so any configuration containing a fixed point has m\* ≤ max_j s_j ≤ n−1 and is dominated except at tiny n.

## Part B. Per-orbit classification

> **Lemma B.** Let O be an orbit of an Oliver group and let the action on its finest block system be primitive. Then that block has size p₀^a for a single prime p₀, and the action on it is affine: the block carries the structure of 𝔽_{p₀}^a with the group acting as 𝔽_{p₀}^a ⋊ H, H ≤ GL(a, p₀) irreducible.

*Proof.* By Lemma A, Γ|_{O} inherits the chain with the same (p, q). Oliver's condition forces solvability, so Γ|_O is solvable and transitive; a solvable primitive group is affine by the classical theorem, giving the stated structure and prime-power degree. ∎

*The rest of this Part works out what H can be, which is where the ΓL(1) failure lives.* Γ|_O is solvable and transitive, so exactly one of:

**(B1) Primitive.** The affine case just established: Γ|_O = 𝔽_{p₀}^a ⋊ H with H ≤ GL(a, p₀) irreducible.

- *H is cyclic-by-q.* H inherits the chain, so it is p-by-cyclic-by-q; its normal p-subgroup is unipotent, and a normal unipotent subgroup of an irreducible linear group has a nonzero invariant fixed space, contradicting irreducibility unless trivial.
- *The point stabiliser need not lie in ΓL(1, p₀^a).* The tempting argument runs: let C ◁ H be cyclic with H/C a q-group; if C acts *irreducibly* then 𝔽_{p₀}[C] is a division algebra by Schur and a field by Wedderburn, so O is one-dimensional over it, C lies in a Singer cycle, and H ≤ N_{GL}(C) = ΓL(1, p₀^a). That is valid **only when C acts irreducibly**. C need not be, and when it is not the conclusion fails:

> **Counterexample.** Let E = 3^{1+2} be the extraspecial group of order 27 acting on 𝔽₇³, generated by diag(1, 2, 4) and the cyclic shift. Verified by direct computation: |E| = 27; the commutator of the generators is the scalar 4·I, so E is extraspecial; E has **no invariant 1-dimensional subspace**, so it is irreducible; and its only cyclic normal subgroup is the centre C₃, of index 9 with quotient C₃ × C₃ — not cyclic. So E is **cyclic-by-q with q = 3** yet **not metacyclic**, hence not contained in ΓL(1, 343) = C₃₄₂ ⋊ C₃, which is cyclic-by-C₃ and therefore metacyclic.

The general obstruction is Clifford's theorem: V restricted to C is semisimple with isotypic components permuted transitively by the q-group H/C, and when there is more than one component — or one component of multiplicity m > 1 — H sits in ΓL(m, p₀^b) with bm = a rather than in ΓL(1, p₀^a). Extraspecial groups realise exactly this.

Three consequences.

1. **Foreign parts are unaffected.** Lemma B′ forces a = 1 there, so H ≤ GL(1, r) = 𝔽_r^\*, which is cyclic outright — ΓL(1, r) is automatic and the formula orb(r, t) is exact. Neither Lemma B′ nor Lemma C's coupling depends on it.
2. **The coarse capacity bound is unaffected.** cap(c) ≤ C(c,2) for a p-characteristic part holds for *any* H whatsoever, being just "at most all pairs inside the block". Theorem 2.3, Part C's recursion and Part F's bounds rest only on this.
3. **The refined formula can under-state a single group's minimum orbital, so it is not a valid per-part UPPER bound — but B_refined is a valid LOWER bound on μ(n).** Writing the minimum intra-orbital as c·(smallest ±H-orbit on non-zero vectors)/2, the code takes the twist to be cyclic of order d = strip(c−1, foreigns) and computes orb(c, d). For non-ΓL(1) H the orbits can be larger than the ±δT classes — up to |±H| = 2|C|·qᵉ rather than 2|C| — so orb(c, d) can be an **under**-estimate by as much as a factor 2qᵉ.

   *The phenomenon, concretely.* For the counterexample group itself, E = 3^{1+2} on 𝔽₇³, direct computation gives the ±E-orbit sizes on the 342 non-zero vectors as **{18 (×4), 54 (×5)}**, so a 343-block carrying E has minimum intra-orbital 343·18/2 = **3087**, while |Z(E)| = 3 means its cyclic-layer image has order only d = 3. Against that, with 342 = 2·3²·19:

   | foreign primes present | d | refined orb(343, d) | E achieves | under-statement |
   |---|---|---|---|---|
   | none | 342 | 58,653 = C(343,2) | 3087 | — |
   | 19 | 18 | 3087 | 3087 | — |
   | 2, 19 | 9 | 3087 | 3087 | — |
   | 3 | 38 | 6517 | 3087 | — |
   | 2, 3 | 19 | 6517 | 3087 | — |
   | **3, 19** | **2** | **343** | **3087** | **×9** |
   | **2, 3, 19** | **1** | **343** | **3087** | **×9** |

   Note that Part B's natural test case — 343 with a foreign prime 19 — is the third row, where the formula returns exactly E's value; the under-statement needs the sharper stripping.

   *This also answers the question the open items used to pose.* "For a primitive affine orbit 𝔽_c ⋊ H with H cyclic-by-q and cyclic-layer image of order d, is the minimum ±H-orbit on 𝔽_c∖{0} at most 2d?" — **no**: for E it is 18 against 2d = 6. An affirmative answer would have made orb(c, d) a valid per-part upper bound and hence made attainment follow directly; that route is closed, and E′ replaces it.

   *What this does and does not license saying.* It shows orb(c, d) is not an upper bound on the minimum intra-orbital of an arbitrary admissible group on that block. It does **not** exhibit an n with μ(n) > B_refined(n), and no such n is known. The reason is that the under-statement is confined to configurations of negligible density: driving d well below c−1 requires the *small* prime factors of c−1 stripped, hence *small foreign blocks*, and a foreign block of size r caps m\* at r(n−r), hence the density at 2r/n. Both under-statement rows need 3 as a foreign prime, and the configurations 343+3+19 and 343+2+3+19 have smallest cross classes 57 and 6 — densities 0.00086 and 0.00009. At n = 365, for instance, the winner is `5x73` with B = 13,140, and 343+3+19 (the same n) has m\* ≤ 57, losing by a factor of 231; the exotic group is capped by that same cross class and so does not beat B_refined(365) either. Since B_refined(n) = Ω(n log n) unconditionally and any configuration exhibiting the under-statement has m\* = O(n), the mechanism cannot produce μ(n) > B_refined(n) for large n.

   *Where this sits in the sandwich.* Part E constructs, for every admitted configuration W, an explicit Oliver group with orbital data exactly the enumeration's terms at twist d — so m\*(Γ_W) = REFINED-score(W), whence B_refined is a **construction lower bound**. On the other side, F·orb(c, dmax) caps any point stabiliser whatsoever, so B_safe is an upper bound **provided the enumerated configurations are all of them** — which is exactly the load Part 0's completeness carries, and the one place the upper half can fail. The two endpoints collapse onto each other exactly when the SAFE optimum is fallback-free, since orb(c, c−1) = C(c,2) identically and the foreign and cross terms are mode-independent; on the certified range that collapse gives **B_refined = B_safe = B = μ**.

**Why the endpoints meet, and why the Singer failure cannot reach B(n).** When no share is present, d = c−1 and **orb(c, c−1) = C(c,2)** exactly — in characteristic 2 because −1 = 1, in odd characteristic because c−1 is even. So on any configuration the fallback does not touch, the refined and unconditional scores are *identical*, and the collapse B_refined(n) = B_safe(n) is equivalent to the statement that the optimum is fallback-free. That statement is not left to measurement: Part E′ gives two structural bounds and a per-n certificate, both proved and both checked over the whole computed range.

> **Why per n rather than per shape, which is a design choice and not a shortfall.** The fallback configurations are shapes in the ordinary sense — the shapes of `arithmetic-of-density.md` §6 already link their parts, since §3.3's system is three conditions in one variable — so the natural question is why the collapse is not dispatched shape by shape. The answer is in §3.5.6: written in their natural variable, the top prime q, these families split by the exponent e in the foreign twist t = q^e. At **e = 1** the family is linear in q and behaves like any other, but at **e ≥ 2** the supply of admissible foreign blocks is sparse — about N^{1/e} up to N — so such a configuration is available only at a **density-zero set of n**, and at those n it may well be the optimum. A per-shape argument cannot dispatch a family that is available at almost no n yet decisive where it is available. **The per-n certificate is the right instrument for that, not a stopgap for a missing theorem.** The refined formula is therefore only ever strictly below C(c,2) on configurations that lose anyway.

*When the stabiliser IS of ΓL(1) type* — which Lemma B′ makes automatic for foreign parts, and which is the case the constructions of Part E realise — the per-part formulas are exact:

- The intra-orbitals are the classes ±δ·T for T the twist group, and the minimum intra-orbital is **orb(s, t) = s·t/2 if t is even or p₀ = 2, else s·t**, where t = |T|.
> **Lemma B′.** *Setting: this is the **primitive** branch (B1) of the case analysis above. O is an orbit on which Γ acts primitively — the imprimitive branch (B2) is peeled off first by passing to the finest block system, so "O" here is a single block with the group the primitive action on it.* Let that block have size s = p₀^a with **p₀ ≠ p**, the home prime — an *outside block*. Then **a = 1**, so the block size is the prime p₀ itself, and its twist order t divides s − 1 and is a power of the top prime **q**.
>
> *Three primes are in play and it is worth fixing them before the proof: **p** is the home prime, the one governing Γ₂; **q** is the top prime, governing Γ/Γ₁; and **p₀** is the characteristic of the block, which by hypothesis differs from p. The conclusion is that p₀ ends up being the block size outright, and in the degenerate Case 2 below it turns out to equal q.*

*Proof.* By Lemma B the action on O is affine: O ≅ V = 𝔽_{p₀}^a and Γ|_O = V ⋊ H with H ≤ GL(a, p₀) **irreducible**. Write G = Γ|_O.

> **Step 0 (every nontrivial normal subgroup of G contains V).** This is the step a compressed proof tends to assert, and it does *not* hold for primitive groups in general — a normal subgroup need only be transitive, and where there are two minimal normal subgroups it can contain one and meet the other trivially. What makes it true here is that the group is affine, so V is the *unique* minimal normal subgroup, and the argument needs irreducibility rather than mere primitivity.
>
> Let N ⊴ G. Then N ∩ V ⊴ G, and N ∩ V is an H-submodule of V, so by irreducibility of H it is 1 or V. Suppose N ∩ V = 1. Since N and V are both normal, [N, V] ≤ N ∩ V = 1, so N ≤ C_G(V) = V; with N ∩ V = 1 this forces N = 1. Hence every nontrivial normal subgroup of G contains V. ∎ *(Step 0)*

Now π_O(Γ₂) is a normal p-subgroup of G. If it were nontrivial it would contain V by Step 0, and V is elementary abelian of order p₀^a with p₀ ≠ p — impossible in a p-group. So **π_O(Γ₂) = 1**.

Next π_O(Γ₁) is normal in G, and is cyclic: with π_O(Γ₂) = 1 it is a quotient of the cyclic group Γ₁/Γ₂.

*Case 1: π_O(Γ₁) ≠ 1.* By Step 0 it contains V ≅ C_{p₀}^a, and a cyclic group has cyclic subgroups, so **a = 1**. Being cyclic it is abelian, hence centralises V, so π_O(Γ₁) ≤ C_G(V) = V; containing V as well, it *equals* V. So the image of Γ₁ in G is exactly the translations, the point stabiliser of Γ₁ on O is trivial, and the entire twist H ≅ G/V lies in the image of Γ/Γ₁, a q-group.

*Case 2: π_O(Γ₁) = 1.* Then G is a quotient of Γ/Γ₁, so G is a **q-group** — a group of q-power order — acting transitively on O. A transitive group of q-power order has q-power degree, so s = q^a and in particular **p₀ = q**: the block's characteristic coincides with the top prime.

> *Why such a G is forced to have s = q.* A nontrivial group of prime-power order has a nontrivial centre, so pick a central subgroup Z of order q. Being central it is normal in G, and the orbits of a normal subgroup form a block system. Primitivity leaves only the two trivial block systems, and Z ≠ 1 rules out singleton blocks, so Z is transitive on O. A transitive group of order q therefore has |O| = q, and it acts regularly. Hence **s = q**.

The point stabiliser is then trivial, so the twist is trivial — a power of q vacuously. Note this case has a = 1 as well, so the lemma's conclusion holds here for a different reason than in Case 1.

In both cases **s is prime and t is a power of q**. ∎

> **Two dependencies worth naming, since the compressed version hid them.** The proof uses *irreducibility* of H, which is part of Lemma B's conclusion, so B′ genuinely rests on B and not merely on primitivity. And it uses **C_G(V) = V** twice — once in Step 0 to kill the N ∩ V = 1 alternative, and once in Case 1 to upgrade "contains V" to "equals V". The earlier write-up invoked it only in the second place, which is part of why the first step read as a leap.
  > *One case the sketch skips, with the same conclusion.* The step "π_O(Γ₁) contains the socle" assumes π_O(Γ₁) ≠ 1. If instead π_O(Γ₁) = 1 then Γ|_O is a quotient of the q-group Γ/Γ₁, so a transitive q-group, so of q-power degree; and a transitive **q**-group acting primitively is regular of prime degree. Hence s = q is prime and the twist is trivial — a q-power. The lemma's conclusion holds in this branch too, but it needs saying rather than assuming.
  >
  > *Verified structurally.* Unlike Lemma C (see Part D), **B_safe does depend on Lemma B′**: it is what stops a foreign part being valued at C(s,2). Removing it would raise B, which breaks attainment and hence the collapse. So B′ is load-bearing in a way Lemma C is not, and is the first thing to re-read whenever the shape space moves.
- *Own characteristic (p₀ = p).* t may be any divisor of s−1, realised by a subgroup of the Singer cycle inside the cyclic layer.

**(B2) Imprimitive.** There is a block system; taking a coarsest one, the induced action on blocks is primitive solvable, hence affine of prime-power degree. **It need not be a q-group action**, and assuming it is, is the projection-versus-subgroup error of Part 0 step 3: the block-permuting group may sit in the cyclic layer instead of the top q-group, in which case the block count is constrained only by the layer staying single-generated. So the count splits as F = F_mid·F_top with only F_top a q-power, and F_mid ranges over the integers. The block stabiliser acts transitively on a block, again inheriting the chain, and the intra-block orbital valencies are its suborbit sizes. Recurse.

## Part C. The valency recursion

> *A statement about one block's twist, independent of how blocks are counted.*

Define, for chain primes (p, q),

> V(s; p, q) = s − 1 if s is a power of p;
> V(s; p, q) = t or 2t (t the q-part of s−1, the former iff t is even) if s is a prime ≠ p;
> V(s; p, q) = max over divisors b > 1 of s of V(s/b; p, q) otherwise;

and cap(s; p,q) = s·V(s; p,q)/2. Induction on s using Part B gives M_i ≤ cap(s_i; p, q) for every orbit.

> **The block-count range in this recursion is the whole shape space, and narrowing it is unsound.** It is tempting to let b run over q-powers only, on the grounds that the block-permuting group sits in the top q-group. It need not: a block count may be supplied by the cyclic layer, so b ranges over every divisor. Two things follow. The recursion as written **covers every orbit**, including sizes such as s = 3·53 that have no q-power divisor at all for the relevant q and would otherwise fall through with no branch. And widening b is the **permissive** direction for an upper bound, so nothing is lost: the chain-free form of Theorem 2.3 below quantifies over all divisors anyway, and that is the form B₀ uses.
>
> *What a q-restricted recursion would and would not buy.* Restricting b would be sharper if it were sound, because a recursion over arbitrary block counts implicitly maximises the twist prime independently at each level whereas the group has a single q. Since it is not sound, the sharpening is unavailable, and the chain-free bound is what the framework rests on.

> **Theorem 2.3 (the chunk count is bounded, and B₀ is an upper bound).** Let Γ be an Oliver group on n points with orbit sizes s₁, …, s_k, and let cap(s) = s·(L(s) − 1)/2 where L(s) is the largest prime-power divisor of s. Then
>
> > m\*(Γ) ≤ min( min_i cap(s_i), min_{i<j} s_i s_j ),
>
> and consequently μ(n) ≤ B₀(n) := max over partitions n = Σ s_i of that quantity, **where the maximum is attained at a partition into at most two parts.**

*Proof.* The two bounds are Part A: an orbit of size s_i has a class of at most cap(s_i) pairs by the valency recursion of C.1 below, and the pairs between orbits i and j form classes totalling s_i s_j, so some class among them has at most s_i s_j pairs. Every Oliver group therefore determines a partition whose value is at least m\*(Γ), giving μ(n) ≤ B₀(n).

For the two-part claim, suppose a partition has k ≥ 3 parts, ordered s₁ ≤ s₂ ≤ ⋯ ≤ s_k. Its value is at most s₁s₂, the smallest cross term. Now compare with the two-part partition (s₁, n − s₁): its value is min(cap(s₁), cap(n − s₁), s₁(n − s₁)). We have s₁(n − s₁) ≥ s₁(s₂ + ⋯ + s_k) ≥ s₁s₂, and cap(s₁) is unchanged. So the two-part partition is worse only if cap(n − s₁) < s₁s₂. Since n − s₁ ≥ s₂ + s₃ ≥ 2s₂ and cap(m) ≥ m/2 for every m ≥ 2 (as L(m) ≥ 2), we get cap(n − s₁) ≥ (n − s₁)/2 ≥ s₂, which does not yet suffice. **This is where the argument is currently incomplete:** cap is not monotone in its argument — cap(127) = 8001 while cap(129) = 2709 — so merging the top k − 1 parts can lower the cap term, and no general inequality closes the gap. ∎ *(for the first two claims; the two-part reduction is verified rather than proved — see below)*

> **Status of the two-part reduction: true, but not elementary.** The conclusion holds throughout the range checked — an exhaustive comparison finds **no n ≤ 1200 at which a three-part partition beats the best one- or two-part one** — and the reason for it is identified in `pending-checks.md` A4a. A three-part partition is capped by min(cap(s₁), s₁s₂) ≤ (n/3)²/2, so it can only win where no two-part split reaches that value; over odd n in [1500, 4000] **not one** fails to reach it, the optimal splits being (prime power, large-prime-power-factor) pairs. That two-part splits of the required quality are plentiful is a **Goldbach-tier fact**, not something an inequality on cap will produce. Any proof needs an additive input of the same kind as §3 of the companion document. The justification offered in earlier drafts — "more parts only shrink min_i cap(s_i)" — is false as stated, because cap is not monotone. What is actually doing the work is the *cross* terms, which shrink as the parts do; the missing step is a bound on how far cap(n − s₁) can fall below cap of the parts it absorbs. **Nothing in this document depends on the two-part reduction except the cost claim** that B₀ is computable in O(n) per value; the inequality μ(n) ≤ B₀(n) itself quantifies over all partitions and is unaffected.

**C.1 The recursion has a closed form.** The chain-free version of V — the one in Theorem 2.3 above, where b ranges over all prime-power divisors rather than q-powers — collapses:

> **V(s) = L(s) − 1**, where **L(s)** is the largest prime-power divisor of s; hence **cap(s) = s(L(s) − 1)/2**.
>
> *Proof.* Each step replaces s by s/b for a prime-power divisor b > 1 and stops when the argument is a prime power, returning that argument minus 1. So the reachable return values are exactly c − 1 for prime powers c dividing s such that s/c is a product of prime powers — which every integer is. Hence the maximum is L(s) − 1. ∎

Verified against the recursion for every s < 4000, with no exceptions. This is worth recording because it makes the crude ceiling elementary: no memoised recursion is needed, and its arithmetic content is visibly just the divisor structure of the parts.

**C.2 The crude ceiling B₀, and why it is not the quantity of interest.** Write

> **B₀(n) = max over partitions n = Σ sᵢ into parts ≥ 2 of min( minᵢ cap(sᵢ), min_{i<j} sᵢsⱼ )**,

the right-hand side of Theorem 2.3 above. Taking the maximum over one- and two-part splits only — which is the unproved half of Theorem 2.3, verified to n = 1200 — B₀ costs **O(n) per value** after a sieve, B₀(200,000) taking a quarter of a second against the enumeration's measured n^2.9. And **μ(n) ≤ B₀(n)** and **B(n) ≤ B₀(n)** both hold: every Oliver group, and every enumerated configuration, determines a partition whose parts are valued at least as highly by cap. (The middle inequality μ ≤ B is what G.2's failure removed; B₀ is unaffected, since its proof never used the block-count classification. That is what makes it the robust fallback described below.)

The second inequality is typically strict, and the reason is structural rather than a per-part over-valuation: **B₀'s optimising partition frequently supports no admissible configuration at all.** B₀ ranges over partitions with parts of any size; a configuration additionally fixes chain primes (p, q), requires each part to be Fᵢcᵢ with Fᵢ a q-power and cᵢ a prime power, types each part as p-characteristic or foreign, constrains twists by Lemma B′ and by Lemma C's coupling, and carries a within-class cross term that B₀ has no notion of.

> *Worked contrast at n = 1460.* B₀(1460) = 263,901 from the partition 727 + 733, both prime: cap(727) = C(727,2) = 263,901, cap(733) = 268,278, cross term 532,891. No Oliver group realises it. Reaching cap(727) needs a twist of order 363 or 726, and Lemma B′ forces a foreign block's twist to be a power of the top prime — the largest prime-power divisor of 726 = 2·3·11² is 121, capping that block at orb(727, 121) = 87,967, a third of what the partition assumes. Reading 727 as p-characteristic instead forces p = 727, and then 733 is prime and foreign, with 732 = 2²·3·61 giving at best orb(733, 61) = 44,713. Either way the partition's value is unreachable. The enumeration returns **B(1460) = 108,811** from `3x331 + 1x467*` at (p, q) = (331, 233), a factor 0.41 below B₀ — the binding term being the foreign block at orb(467, 233) = C(467,2), against an intra term of 3·C(331,2) = 163,845.

**What B₀ is therefore good for, and what it is not.** Three genuine uses. It is the **robust fallback**: its proof needs only "solvable primitive ⟹ prime-power degree" plus orbit–stabiliser, so it survives intact if Lemma B′ — not independently scrutinised — turns out to be wrong. It is **computable arbitrarily far**, which the enumeration is not. And its asymptotics is **cleaner**: with no coherence conditions there are no multiplicative side conditions on shifted primes, so B₀ is governed by additive representation by numbers of large prime-power core, not by the Hardy–Littlewood systems that govern B.

Against that, B₀ is **loose exactly where it would matter**. Its density floor below 3000 is 0.123 (at n = 551), against B's **⟦PENDING-REBUILD⟧** tentatively 0.048039 at n = 2183 (v4: 0.045742 at n = 1817, now known low), and it sits near 1/4 generically — B₀(200,000) has density 0.2494. So it does not identify arithmetically weak n, and it cannot be used to prune the enumeration. It is a cheap outer bracket, not a tool.

## Part D. Coherence across parts

> **Lemma C (twist–foreign coupling).** Let O_i be a p-characteristic part whose blocks have size c = p^a and whose twist of order d lies in the cyclic layer Γ₁/Γ₂, and let O_j be an outside part of prime size r (so r ∉ {p, q}). If **r | d**, then every multiplier induced on O_j lies in ⟨p mod r⟩; hence the twist order t of O_j satisfies
>
> **t | ord_r(p), and ord_r(p) | a,**
>
> so O_j carries an intra class of at most **orb(r, t) ≤ min(r·ord_r(p), C(r,2)) ≤ r·a ≤ n·log₂n.**
>
> In particular at **a = 1** the share forces t = 1: an outside part sharing a prime with a matching part's twist is untwisted.

*Proof.* Write elements of the block action as usual, and let C_{r^k} be the r-primary component of Γ₁/Γ₂. It surjects onto the r-part of O_i's twist — r | d puts that r-part in the cyclic layer, since the top is a q-group with q ≠ r — and onto O_j's translations C_r, which lie in Γ₁ by Part B and are r-elements with r ∉ {p, q}. So a single generator z of a preimage acts as a multiplier of order divisible by r on O_i's blocks and as a nontrivial translation on O_j.

Conjugation by any h ∈ Γ is an automorphism of the cyclic layer, hence a single power map z ↦ z^{m_h}. Project it to each part:

- *On O_i.* Multiplier components of h centralise the twist; translation components contribute commutators in Γ₂, which die in the layer; the Galois component sends ζ ↦ ζ^{p^{k_h}} with k_h the Frobenius exponent of h's block action. So **m_h ≡ p^{k_h} (mod r)**.
- *On O_j.* Conjugating a translation by h scales it by h's induced multiplier, so **m_h ≡ mult_h (mod r)**.

Hence mult_h ≡ p^{k_h} (mod r) for every h ∈ Γ. Elements of Γ₁ induce trivial multipliers on O_j — a cyclic-layer multiplier acting beside the C_r translations would put an r-element into [Γ₁, Γ₁] ⊆ Γ₂, a p-group, which is Lemma D2q's commutator step — so the multiplier group on O_j is the image of the top layer's, and the congruence confines it to ⟨p mod r⟩, of order ord_r(p). Finally ord_r(p) | a because r | d | p^a − 1, and orb(r, t) ≤ r·t ≤ r·ord_r(p) ≤ r·a ≤ n·log₂n since p^a + r ≤ n. ∎

> **Pitfall.** The weaker argument — "independent pieces generate a direct product, which must be cyclic" — establishes nothing here. A single generator can act as a twist on one part and a translation on another, in which case cyclicity alone imposes no condition; indeed that is exactly the configuration the coupling describes. What constrains the two is the conjugation action, and what excludes the resulting configurations is domination, not admissibility.

> **A share is admissible, and both witnesses matter.** The coupling is a constraint, not an exclusion: configurations in which a cyclic-layer twist shares a prime with an outside block **exist as Oliver groups**.
>
> - **n = 28 = 25 + 3, a = 2.** 𝔽₂₅ with translations C₅², beside 𝔽₃. One cyclic-layer element z acts as multiplication by ω of order 3 on 𝔽₂₅ *and* as +1 on 𝔽₃; one top element g acts as Frobenius x ↦ x⁵ there *and* as negation here, so both projections give g z g⁻¹ = z⁻¹ and the conjugation closes. |Γ| = 150 with Γ₂ = C₅², Γ₁/Γ₂ ≅ C₃, Γ/Γ₁ ≅ C₂. The twist order and the foreign prime are both 3.
> - **n = 21 = 16 + 5, showing the coupling is tight and rigid.** ord₅(2) = 4, and the share is realised with foreign twist of order exactly 4: |Γ| = 320, layer C₅, top C₄. Pairing the *wrong* Frobenius exponent with the multiplier — Frob² with a multiplier of order 4 — fails to close: the closure contains the pure matching twist and the pure foreign translation as separate elements, so its Sylow 5-subgroup is C₅ × C₅, non-cyclic, and no chain exists for q ≠ 5 (q = 5 makes O_j an r = q part, dead by Lemma D2q).
>
> At **a = 1** the share still occurs, with the foreign part untwisted as the lemma requires: n = 10 = 7 + 3 gives an Oliver group of order 21 with Γ₂ = C₇, layer C₃ and trivial top. `t5_verify.py` reproduces all three.

> **Corollary C′ (what a share costs).** No configuration containing a share attains the maximum wherever δ(n)·C(n,2) > n·log₂n. With the ladder's unconditional δ ≥ 0.02516 on n ≤ 10⁶ that holds for **n ≥ 763**; below it, direct scoring of the bound against every tabulated value clears with worst ratio 0.7000 (at n = 15), so the exclusion covers the computed range and everything to 10⁶ with overlap. Beyond 10⁶ it needs only δ(n) ≫ log n / n — the weakest arithmetic input anywhere in the framework.

> **What this buys the certificates, and the one qualification to carry with it.** `fb_common.py`'s condition (4) caps a leftover p-characteristic part by stripping the foreign primes from its twist. That strip is **not** a necessary condition on admissible configurations — the witnesses above are admissible and violate it. It **is** necessary among configurations scoring above n·log₂n, by Corollary C′, and that is the only necessity the certificates use, since they evaluate candidates against thresholds of order δ·C(n,2) ≫ n·log₂n. So the strip is justified **at every a wherever B exceeds the sharing bound**, with the justification being coupling-plus-licence rather than an unconditional lemma — and the licence is local, needing no threshold on n at all: **min(r·ord_r(p), C(r,2)) < B**, evaluated per (p, a, r). At a = 1 the coupling forces ord_r(p) = 1 and the licence reads r < B. Crude global forms of the same statement — B(n) > n·log₂n, say, which fails at 34 tabulated values below n = 118 — are implied by it and are not needed.

*How this interacts with B_safe.* SAFE scores every p-characteristic part at F·orb(c, dmax), a cap that accounts for the layer constraint but not for the coupling, so **B_safe does not use Lemma C at all** — deleting the stripping from `value()` reproduces the table exactly at every n ≤ 400. The lemma enters through `--refined`, through the `fallback` column and through the Part E′ collapse argument. Note also that dropping a necessary condition can only *enlarge* the configuration space, so the max could only rise, and in SAFE mode it does not rise at all; while Part E's construction uses coprimality only as a *sufficient* condition, which is an existence argument. Both **μ(n) ≤ B_safe(n)** and its attainment are therefore independent of this lemma; what it buys is the sharpness of the search and the collapse.

Twists on distinct p-characteristic parts carry **no** mutual constraint: a single cyclic generator surjects onto each, which is exactly what the diagonal constructions exploit.

## Part D2. The bottom-layer lemmas

*These two are what rule out the bottom layer as a source of block copies, leaving copies = F_mid · F_top. Nothing older in this document depends on them; everything in the repair does.*

> **Lemma D1 (absorption).** Let O be an orbit whose finest block is p-characteristic of size c = p^a, and suppose the F copies of that block are permuted by a subgroup of Γ₂, so that F is a power of p. Then |O| = F·c is itself a power of p, the orbit is already enumerated as the single part (F, c) = (1, |O|), and the single-part reading scores at least as high.

*Proof.* F = p^b and c = p^a give |O| = p^{a+b}, a prime power, so (1, |O|) is an admissible part and appears in the enumeration. Its SAFE intra-orbital is C(|O|, 2). The F-copy reading's intra-orbital is at most F·C(c, 2) = p^b·p^a(p^a − 1)/2 < p^{a+b}(p^{a+b} − 1)/2 = C(|O|, 2), since p^a − 1 < p^{a+b} − 1. The within-class cross term of the F-copy reading only lowers its minimum further, and the between-orbit terms depend on |O| alone and so are identical. Hence the single-part reading scores at least as high, and no configuration is lost by refusing bottom-layer copies of a matching block. ∎

*Worked instance.* Home prime 2, two copies of a 4-block: 2 × C(4,2) = 12, against the same chunk read as one 8-block, C(8,2) = 28.

> **Lemma D2 (fused outside blocks are dominated).** Let O be an orbit whose finest block is an outside block of prime size r, with F ≥ 2 copies permuted transitively by some subgroup of Γ. Then
>
> **m\*(Γ) ≤ n·min(F, r)/2 ≤ n^{3/2}/2**,
>
> by two classes: O carries a within-block class of at most **F·C(r,2)** pairs always, and when **F < r** a same-position class of at most **C(F,2)·r** pairs. At **F = 2** the second reads r = |O|/2, recovering the sharper linear form. When **r = q** the conclusion is stronger still: at F < q the twist is trivial and some class has at most **F·r = |O|** pairs.

*Proof.* **(a) The within-block class.** The block system is Γ-invariant, so a pair inside a block maps to a pair inside a block: the F·C(r,2) within-block pairs are a union of classes, and some class has at most F·C(r,2) = |O|(r−1)/2 ≤ n·r/2 pairs. This needs only that the block system exists.

**(b) The same-position class, when F < r.** Three steps, and the first is where the chain does work no earlier argument asked of it.

*Step 1: the r-elements are exactly the translations, and they are diagonal.* Γ₂ is a p-group and Γ/Γ₁ a q-group with r ∉ {p, q}, so every r-element of Γ maps into the cyclic layer; hence the Sylow r-subgroup of Γ, and of the quotient Γ|_O, is **cyclic**. Write a general element of Γ|_O as (i, x) ↦ (σi, aᵢx + tᵢ), with σ the block permutation and each block affine by Lemma B. An r-element has σ of r-power order in Sym(F) with F < r, forcing **σ = 1**; and each multiplier aᵢ of r-power order dividing r − 1, forcing **aᵢ = 1**. So the r-elements form the group T\* of pure translation vectors, elementary abelian inside a cyclic Sylow subgroup, hence **T\* ≅ C_r generated by one vector**. Transitivity forces every component nonzero — each block's induced group is transitive on r points, so r divides its order, and that r-part comes from T\*'s component — so normalising each block's coordinate makes **T\* the diagonal C_r**.

*Step 2: one common multiplier, and coordinates in which every translation part is diagonal.* For g = (σ, (aᵢ), (tᵢ)) the conjugate g τ_s g⁻¹ is the pure translation vector with components a_{σ⁻¹(j)}·s, which must lie in the diagonal T\*; hence **all aᵢ are equal**. For the translations, let T_full = C_r^F be the full translation group of the coordinatised blocks, W = Γ|_O·T_full, V = T_full/T\*, and Q = W/T_full ≅ Γ|_O/T\*. Since Sylow-r of Γ|_O is exactly T\*, **r ∤ |Q|**, so H¹(Q, V) = 0 and any two complements of V in W/T\* are conjugate by an element of V — i.e. by a translation vector, i.e. **by a change of per-block origins**. Conjugating Γ|_O/T\* onto the complement of elements with diagonal translation part, we may take every element to act as **(i, x) ↦ (σi, ax + s)**, one multiplier and one translation across all blocks.

*Step 3.* In those coordinates the C(F,2)·r pairs {(i,x),(j,x)} with i ≠ j are Γ-invariant — block maps preserve equal positions, translations shift both coordinates, the common multiplier scales both — so they are a union of classes and some class has at most C(F,2)·r = |O|(F−1)/2 ≤ n·F/2 pairs.

Finally min(F, r) ≤ √(Fr) ≤ √n. Adding further orbits only adds classes and cannot raise the minimum, so the bound holds for any Oliver group *containing* such an orbit. ∎

> **What Step 2 is for.** Without it "same position" is coordinate-dependent, and an element acting as (ax, ax + u) across two blocks would merge the offset-zero class into offset u. The splitting shows such elements can always be normalised away when F < r. A bound resting instead on the block-permuting group having prime-power degree does **not** hold. What the same-position class costs is governed by the permuter’s minimum orbital on **unordered** pairs of blocks, so the property to ask for is **2-homogeneity**, not 2-transitivity, and a 2-homogeneous permuter makes that class C(F,2)·r rather than (F/2)·r. Two realised instances, both dominated by the theorem rather than excluded by it:

> - **F = 5, via a 2-transitive permuter.** AGL(1,5) = C₅ ⋊ C₄ is admissible with C₅ in the cyclic layer and C₄ on top. Five fused 17-blocks with a diagonal translation and a diagonal twist of order 16 give an Oliver group at n = 85 with orbitals 170 / 680 / 2720, so **m\* = 2|O|**.
> - **F = 7, via a permuter that is 2-homogeneous but *not* 2-transitive — and this is the sharper one.** For F ≡ 3 (mod 4) the index-2 subgroup C_F ⋊ C_{(F−1)/2} is already 2-homogeneous, since the twist omits −1. At F = 7 that is C₇ ⋊ C₃ of order 21, which sits in a chain with **q = 3** — whereas the full AGL(1,7) = C₇ ⋊ C₆ does not, C₆ being no prime power. Seven fused 13-blocks with a diagonal translation and a diagonal twist of order 3 give an Oliver group at **n = 91**, order 819, with Γ₁ = C₉₁ cyclic normal and Γ/Γ₁ of order 9; its orbitals are 273 / 273 / 273 / 819 / 819 / 819 / 819, so **m\* = 273 = 3|O|**.
>
> The second instance is why the distinction matters rather than being pedantry: **an argument phrased in terms of 2-transitivity would not have found it**, since it would have looked for AGL(1,7) and correctly concluded that the chain rejects it. The chain-admissible 2-homogeneous permuters are a strictly larger family than the chain-admissible 2-transitive ones, and at F ≡ 3 (mod 4) they are cheaper, needing only (F−1)/2 to be a prime power. The bound C(F,2)·r is unaffected — 2-homogeneity is exactly what maximises the block-pair orbital — only the set of F at which the shape is buildable grows.

So the enumeration may restrict to unfused outside blocks without loss: **the block count of any class is F = F_mid · F_top**, with no contribution from Γ₂ for matching blocks (D1), and fused-outside configurations omitted because they are dominated (D2) rather than because they fail to exist. This is a domination argument and therefore carries a **range-scoped half**, which expires silently as the table grows — rerun `a18_verify.py` on every extension.

*Why the bound is stated with min(F, r).* Branch (a) alone is weak when r is large and F small; branch (b) alone is unavailable when F ≥ r. Together they cap the orbit at n·√n/2 uniformly, which is what makes the exclusion a theorem rather than a computation.

*The asymmetry that is the content of the lemma.* Γ₂ can hold F independent copies of a p-group, so matching blocks may be fused profitably; Γ₁/Γ₂ cannot hold C_r^F, so an outside block's translations are diagonal and its same-position pairs are cheap. Scoring the between-block class as (F or F/2)·r² — the formula for *matching* blocks, which presumes independent per-block translations — inflates these configurations enough to make 16 of them appear to beat B(n) below n = 1500, the largest at n = 518 with ratio 1.50. That formula is what the diagonal structure forbids.

**The case r = q, where the bound improves.** If the block size equals the top prime, the r-elements may lie in Γ/Γ₁ rather than the cyclic layer, so Sylow-r is not forced cyclic and the diagonal step of branch (b) is unavailable. What replaces it is stronger.

> **Lemma D2q (at r = q the twist dies).** With O an orbit of F fused outside blocks of prime size q and **2 ≤ F < q**, there are per-block coordinates in which every element of Γ|_O acts as (i, x) ↦ (σi, x + s) — trivial linear part on every block — the translation group is the **diagonal C_q**, and some class has at most **F·q = |O|** pairs. For F ≥ q, branch (a) applies unchanged.

*Proof.* Write elements of Γ|_O as (i, x) ↦ (σi, aᵢx + tᵢ), and M_g for the monomial action (σ, (aᵢ)) on translation vectors.

*(1) The q-elements are exactly the pure translations.* Such an element has σ of q-power order in Sym(F) with F < q, so σ = 1, and each aᵢ of q-power order dividing q − 1, so aᵢ = 1. They form T\* ≤ C_q^F, elementary abelian and the unique — hence normal — Sylow q-subgroup of Γ|_O. Transitivity makes each coordinate projection of T\* surjective: block i's setwise stabiliser induces a transitive subgroup of AGL(1, q), whose order q must come from T\*'s i-th component.

*(2) The block action is realised inside Γ₁.* Put N = π_O(Γ₁) ◁ Γ|_O. As Γ/Γ₁ is a q-group every q′-element lies in N, and splitting each g into its q- and q′-parts gives **Γ|_O = N·T\***. A q-group of degree F < q is trivial, so the block-permuting image P of Γ|_O is already the image of N.

*(3) T₀ := T\* ∩ N has rank ≤ 1.* T₀ is the set of q-elements of N, i.e. its normal Sylow q-subgroup. Γ₂ is a p-group with p ≠ q and Γ₁/Γ₂ is cyclic, so Sylow-q(N) is cyclic, and an elementary abelian subgroup of a cyclic group has rank ≤ 1. Being characteristic in N, T₀ ◁ Γ|_O.

*(4) The linchpin: (1 − M_g)T\* ⊆ T₀ for g ∈ N.* Lift g into Γ₁ and t ∈ T\* into Γ. Normality of Γ₁ puts the commutator in Γ₁, and computing it in Γ|_O gives the pure translation (1 − M_g)t — a q-element of N, hence in T₀.

*(5) If T₀ = ⟨v⟩ ≠ 0.* Its Γ|_O-invariance makes supp(v) invariant under the transitive P, hence full, so coordinates may be chosen with v = 𝟙; invariance of ⟨𝟙⟩ then forces M_g = λ_g·P_σ, one multiplier per element. Now the cyclic layer speaks: Γ₁/Γ₂ cyclic gives [Γ₁, Γ₁] ⊆ Γ₂, whose image is a p-group; but for τ generating T₀ and g ∈ N the commutator [g, τ] is translation by (λ_g − 1)𝟙, of order q unless λ_g = 1. A q-element cannot sit in a p-group, so **λ_g = 1 throughout**. Step (4) becomes (1 − P_σ)T\* ⊆ ⟨𝟙⟩; writing t = c𝟙 + t̄ in the sum-zero decomposition (available since q ∤ F), t̄ − σ(t̄) ∈ ⟨𝟙⟩ ∩ S = 0 for all σ ∈ P, so t̄ is P-invariant, constant, and zero. Hence **T\* = ⟨𝟙⟩**.

*(6) If T₀ = 0.* Then N is a q′-group and (4) gives M_g t = t for all g ∈ N, t ∈ T\*. The fixed-vector relation aⱼt_{σ⁻¹j} = tⱼ makes supp(t) P-invariant, hence full for t ≠ 0; two independent vectors would have P-invariant pointwise ratio, hence constant, so T\* is a single line of full support. Normalising its generator to 𝟙 forces every aⱼ = 1.

*(7) The class.* With trivial linear parts every element sends {(i,x),(i,y)} to {(σi, x+s),(σi, y+s)}, preserving the within-block difference ±δ. The pairs of one such difference number at most F·q and form a union of classes. ∎

> **One principle covers both cases, and explains why only r = q collapses.** A twist forced into the **same abelian layer** as the translations it scales must be trivial. At r = q the linear parts have order dividing q − 1, so they are q′-elements and the top q-group pushes them down into Γ₁ beside the translations — where the cyclic layer's abelianness kills them. At r ≠ q the twist is a q-power living a layer *above* the translations, the commutator lands harmlessly in Γ₁, and the twist survives; that is why the r ≠ q case needs the C(F,2)·r counting argument while r = q does not. The F = 1 statement — a lone outside block with r = q has trivial twist, so is worth orb(q, 1) = q — is the F = 1 instance of exactly this proof.

> **Corollary D2′ (what fusion of outside blocks costs).** Fused outside blocks **exist**, but no configuration containing one attains the maximum wherever δ(n)·C(n,2) > n^{3/2}/2, i.e. **√n < δ(n)·(n − 1)** — and δ here may be any construction lower bound, which the fused-outside question cannot touch. With the ladder's unconditional δ ≥ 0.02516 on n ≤ 10⁶ this holds for **n ≥ 1582**; below that, direct scoring of the bound against every tabulated value clears it with worst ratio 0.83 (at n = 56), so the exclusion covers the whole computed range and everything to 10⁶ with overlap. Beyond 10⁶ it needs only δ(n) ≫ n^{−1/2}, weaker than every density statement the framework runs on. `a18_verify.py` reproduces the witness, its chain and the range check.

*The argument never uses the fusing layer, so the domination holds whichever layer supplies the copies* — which is why Part E may take outside parts unfused outright (its admissibility bullet) rather than case-splitting on the permuter's home.

## Part E. Completeness of the enumeration, and realisability

> **The two halves of this Part rest on different things, and only one of them is fragile.** *Realisability* — every enumerated configuration is achieved by an explicit group — is self-contained: it exhibits groups, and it is what makes B_refined a lower bound on μ. *Completeness* — every Oliver group realises some enumerated configuration — rests entirely on Part 0's shape space, which is the step in this framework with the worst track record. Read every completeness claim below as scoped to that shape space, and re-read it whenever the space moves.

Completeness is proved below and realisability with it; what is *not* proved is minimality, which costs running time only (Part J item 1).

**The general configuration.** Parts B–D leave the following shape. Fix chain primes (p, q). The orbits are: some p-characteristic parts, each a p-power, grouped into fusion classes of **F = F_mid·F_top** blocks — F_top a q-power supplied by the top layer, F_mid any integer the cyclic layer's coprimality budget admits (G.2) — and some foreign parts, each a prime with a q-power twist, subject to Lemma C against every p-part twist. Writing one fusion class of F blocks of size m together with foreign primes r₁, …, r_v:

> value = min( F·orb(m, d), (F or F/2)·m², min_j orb(r_j, t_j), min_j F·m·r_j, min_{j<j'} r_j·r_{j'} ),  the second coefficient being F for odd F and F/2 for even F

with d the largest divisor of m−1 coprime to every r_j, t_j the q-part of r_j−1, and the second term present only when F > 1, its coefficient being **F for odd F and F/2 for even F** — keyed on the parity of the block count itself, not on q.

**Admissibility constraints.** Two are easy to omit, and omitting either inflates the bound — the dangerous direction.

- **Foreign primes are pairwise distinct.** Two foreign parts of the same prime r would place C_r × C_r inside the cyclic layer, which is not cyclic.
- **Foreign parts are taken unfused.** Independent translations across F blocks generate C_r^F, cyclic only for F = 1, so the translations are diagonal. The same-position pairs then form an invariant class of C(F,2)·r when F < r (Lemma D2, whose Step 2 is what makes "same position" coordinate-independent), and the within-block pairs one of at most F·C(r,2) always. Either way the configuration caps at n^{3/2}/2 and cannot be extremal, so omitting fused foreign parts loses nothing.

> **Pitfall.** Estimating the fused-foreign case *without* the diagonal cross class suggests it beats the bound at dozens of n; including that class shows it never does.

**Two reductions.**

> **(R1) Equal-size merge.** Two p-characteristic classes of the same block size c with fusion counts F₁, F₂ whose sum is a q-power are dominated by the single class of F₁+F₂ blocks: the intra-orbital rises from max(F₁,F₂)·orb(c,d) to (F₁+F₂)·orb(c,d) while every cross term is unchanged or larger. *Under the corrected shape space the merge is not confined to q-power sums:* a cyclic-layer merge to F_mid = F₁+F₂ is available whenever the coprimality budget admits it, with the same domination arithmetic — this is what absorbs the equal-pair three-part winners (Part I's three-part box). Accordingly no winning configuration in the computed range uses two fused classes.
>
> **(R2) Twist maximality.** Each term is non-decreasing in its own twist order, so the optimum is attained with every twist maximal subject to Lemma C, which removes the twist axis from the search.

> **Pitfall.** Without (R2) the order of optimisation matters — max–min and min–max differ — and an implementation that mixes them computes neither bound.

What does **not** reduce is multisets of distinct part sizes and the choice of bottom prime: both are genuinely distinct configurations, and the measured data shows both matter — 257 winners use two p-characteristic classes alongside a foreign prime of a different size (the two p-blocks themselves are *equal* in 255 of the 257; the exceptions are n = 551 = 256 + 167\* + 128 and n = 2015 = 1024 + 512 + 479\*, each two distinct 2-powers), and the winning p ranges from 2 to 1129.

**Status of the enumeration.** Every configuration permitted by Parts A–D is enumerated, within the bounds proved in F and G, so the enumeration is **complete and finite**. It is not known to be **minimal**: no argument prunes it to a shortest sufficient list. That affects running time, not validity. Several structural questions that might have obstructed completeness do not: the number of foreign parts needs no separate cap, since foreign parts are orbits and Proposition F.1 bounds the orbit count; multiple p-characteristic classes of different sizes are enumerated as multisets of parts; and towers do not couple to foreign parts (Part G).

**Realisability: every admitted configuration is realised.** The enumeration does not over-generate. Every configuration the enumeration admits is realised by an explicit group, assembled from ingredients whose Oliver condition is verified purely arithmetically. Given (p, q) and parts (Fᵢ, cᵢ, type, twist dᵢ):

- each p-characteristic part contributes the translations of its Fᵢ blocks of 𝔽_{cᵢ}, all of which lie in the bottom p-group Γ₂;
- each foreign part contributes translations C_{r} lying in the cyclic layer;
- one generator of the cyclic layer carries the twists of all p-characteristic parts *diagonally*, its image in each part being that part's full twist C_{dᵢ}, so distinct p-parts need no coprimality between their twist orders;
- each foreign twist, a q-power, lies in the top q-group, as does each class's **F_top** factor of block permutation; a class's **F_mid** factor is carried by an **entangled cyclic-layer generator** — one element z rotating the F_mid blocks whose step-multipliers have product a generator of the twist, so z^{F_mid} is the full twist and the rotation and twist come from a single cyclic subgroup. The n = 33, 78 and 105 regression witnesses of the battery are builds of exactly this element, and n = 255 (`73+73+109*` at q = 3) is a battery row whose F = 2 is entirely cyclic-layer.

Γ₂ is a p-group by construction; Γ₁/Γ₂ is cyclic exactly when the independent orders in it are pairwise coprime, which is Lemma C and is what the enumeration enforces; Γ/Γ₁ is a q-group as a product of q-groups on disjoint supports. And the resulting orbital sizes are *forced*, not chosen: the intra-orbital of a class is Fᵢ·orb(cᵢ, dᵢ) because the block permutation fuses the Fᵢ copies; the within-class cross is (Fᵢ or Fᵢ/2)·cᵢ² because the block-permuting group of the construction is the regular C_F, whose minimum pair-orbital is exactly **Fᵢ/2 for even Fᵢ and Fᵢ for odd Fᵢ** — for a transitive group of prime-power degree ℓ^a every orbital has ℓ-power size, and the ℓ-part of C(F,2) = F(F−1)/2 is F for odd ℓ and F/2 for ℓ = 2 since F−1 is coprime to ℓ, so if every orbital exceeded that value they would all be divisible by ℓF and so would their sum, contradicting the ℓ-part of the sum.

> **Where the coefficients come from, in one rule.** Both the within-class cross coefficient and the halving inside `orb(c, d)` are instances of a single fact: **the minimum orbital is c·d divided by the largest order of a setwise stabiliser of a 2-set inside the affine group**, capped at C(c,2). That stabiliser has order dividing 2, and there are exactly two ways to realise it — inside the twist, when 2 | d (the map x ↦ −x, up to translation), or inside the translations, when p = 2 (the map x ↦ x + 1, which swaps a pair). Hence `orb`'s `t % 2 == 0 or char2` condition, which otherwise looks like two unrelated special cases.
>
> *The same rule at general k*, where it is a useful check on any generalisation: the stabiliser of a k-set has order dividing k, realised in the twist when m | d, or in the translations when p | k. At k = 3 that gives a factor 3 when 3 | d, a factor 2 when 2 | d, and — from the translation side — a factor 3 exactly when p = 3, which is the affine-line degeneracy of `three-uniform-note.md` §2.2.1. The k = 2 char-2 halving and the k = 3 affine-line failure are the same phenomenon at different k.

> **Pitfall — this coefficient is exact for the construction and is *not* an upper bound over all admissible block-permuters.** The divisibility argument above needs the block-permuting group to be an ℓ-group, and the corrected shape space does not force that: F = F_mid·F_top, so the group permuting the Fᵢ blocks may be, for instance, AGL(1,5) = C₅⋊C₄ with the C₅ in the cyclic layer and the C₄ on top. That group is 2-homogeneous on 5 blocks — here in fact 2-transitive, though 2-homogeneity is all that is needed, and at F ≡ 3 (mod 4) it is strictly cheaper to arrange, C_F ⋊ C_{(F−1)/2} sufficing — so its **only** within-class cross orbital has size 10c², against the coefficient’s 5c². Nothing downstream breaks, and the reason is worth stating rather than trusting: **coeff·c² ≥ F·C(c,2) ≥ F·orb(c, dmax) always**, so the cross term can never be the binding reason a score under-counts a group — the intra cap binds first — and μ ≤ B_safe survives untouched. *(That inequality is exercised on every one of the 437 shapes above: the scored cross exceeds the scored intra at each, so the intra term is what binds, and the realised minima confirm it.)* But the claim must be read as *the value the construction realises*, not as a bound on every group; the same scoping applies to the ⌊F/2⌋ orbital count in §9.7 of `orbital-evasiveness-notes.md`.

> **Pitfall — the parity is F's, not q's.** Stating this coefficient as "F for odd q, F/2 for q = 2" is correct only where every block count is forced to be a q-power, since F even then means q = 2. Under the corrected shape space F = F_mid·F_top need not be a q-power and the two conditions come apart: at n = 15 the winner is `p=5 q=2: 3x5`, with **q = 2 but F = 3**, so the coefficient is 3 and the term is 75, not 25. Reading it off q there gives a within-class cross of 25 and understates B(15) as 25 against the true 30. Both shipped enumerators key on `F % 2`, so this is a trap for prose and for any hand check, not for the search. The fusing group's own prime ℓ is what the divisibility argument uses, and ℓ = 2 exactly when F is even. This replaces an appeal to "the pattern-orbit count", which asserted attainment where the bound is what the argument needs; and the between-orbit classes are single orbitals of size sᵢsⱼ because the translations of distinct orbits act independently.

**The two within-class coefficients are verified systematically, not only at witnesses.** `shape_realize.py` and `ark_shapes.g` construct a group for each fused matching class and compare its realised pair-orbitals against the scored terms. Over **437 shapes across two sweeps** — every prime power c ≤ 49 at F ∈ {2, 3, 4}, and every prime power c ≤ 97 at F = 2, with every divisor d of c − 1 in each case — the scored intra F·orb(c, d) and the scored cross ((F/2)c² at even F, F·c² at odd) **equal the realised minimum on every row**, in two independent implementations that agree with each other and with an independent re-derivation from the closed forms. The sweep includes the cases the coefficient rules are easiest to get wrong: characteristic 2 at c = 4, 8, 16, 32, 64 where `orb`'s halving comes from the translations rather than the twist; proper prime powers at c = 9, 25, 27, 49, 81 where using ℤ/c instead of 𝔽_c gives wrong sizes (the pitfall below); **c = 41 at d = 40**, a full twist at c ≡ 1 (mod 8); and c = 97, whose c − 1 has twelve divisors, so the halving rule is exercised at ten distinct twist orders on a single block size.

This is evidence of a different kind from the witness table below, and the distinction matters. The table checks **winners** — configurations the enumeration selected. The sweep checks the **scoring function** on shapes that lose, which is where a mis-score is invisible to every other check in the battery until the shape becomes a winner at some larger n. See `pending-checks.md` R6.

Verified by orbit computation that the built group's orbital sizes equal the enumeration's terms exactly:

| configuration | predicted m\* | built m\* | orbitals |
|---|---|---|---|
| n = 12, 3×4, q = 3 | 18 | 18 | {18, 48} |
| n = 18, 2×9, q = 2 | 72 | 72 | {72, 81} |
| n = 20, 4×5, q = 2 | 40 | 40 | {40, 50, 100} |
| n = 26, 9 + 17\*, q = 2 | 36 | 36 | {36, 136, 153} |
| n = 35, 16 + 19\*, q = 2 | 19 | 19 | {19, 120, 304} |
| n = 45, 2×11 + 23\*, q = 2 | 23 | 23 | {23, 110, 121, 506} |
| n = 255, 73+73+109\*, q = 3 | 2628 | 2628 | {2628, 2943, 5329, 7957} |
| n = 315, 2×61 + 193\*, q = 2 | 3660 | 3660 | {3660, 3721, 6176, 23546} |

So **B(n) is attained, and μ(n) = B(n)**, in every case where the enumeration's score for each part is the one the construction realises. The single exception is a p-characteristic part whose twist the coupling strictly reduces, where unconditional scoring assigns F·C(c,2) rather than the F·orb(c, d) the construction reaches; that exception is discharged in E′ below, which proves it cannot arise at any optimum in the computed range.

> **Pitfall.** When checking this by construction, the twist must be a multiplicative generator of the *field* 𝔽_c. Using ℤ/c instead is correct only for prime c, and silently gives wrong orbital sizes for proper prime powers — for n = 12 with three blocks of 4 it yields 6 rather than 18. A related error in the same family: the translations must generate the **whole** additive group of 𝔽_c, which for c = p^a needs a basis rather than the single element 1 — translating by 1 alone generates only ℤ/p and under-builds the block group silently. Both are now covered at c = 4, 8, 9, 16, 25, 27, 32, 49, 64, 81 by the sweeps, which is why it is worth running after any change to `orb` or to the cap.

**E′. Discharging the exception: the fallback never bites the optimum.** The construction above realises REFINED-score(W) for every admitted W, so **B_refined(n) ≤ μ(n)** unconditionally, and with the classification's F·C(c,2) cap on any point stabiliser,

> **B_refined(n) ≤ μ(n) ≤ B_safe(n)**.

Since orb(c, c−1) = C(c,2) identically (Part B), the two endpoints coincide exactly when the optimum does not invoke the fallback. So attainment reduces to excluding fallback configurations from the optimum, and that is provable rather than merely observable.

*The structural bound.* Let W contain a p-characteristic part (F, c) and a foreign prime r of W with r | c−1; put s = (c−1)/r and δ = B(n)/C(n,2). The foreign part's own intra term satisfies orb(r,t) ≤ C(r,2), so r(r−1) ≥ δ·n(n−1); and c ≤ n − r, so s ≤ (n−r−1)/r. Hence

> **s ≤ (1 − √δ)/√δ** — s ≤ 3 at δ ≥ 1/16, s ≤ 2 at δ ≥ 1/9, and **s = 1 as soon as δ > 1/9** (sharp form: s ≤ 1 needs only r > (n−1)/3, which r² > δn(n−1) delivers once δ > (n−1)/9n).

> **Theorem E.1 (collapse above density 1/9).** If δ(n) > 1/9 then any fallback configuration attaining B(n) has s = 1, so c − 1 = r is prime, and exactly one of:
>
> - **p odd.** Then c is odd and c − 1 even, so r = 2. A foreign block of size 2 contains a single pair, so orb(2, t) = 1 and SAFE(W) ≤ 1 — excluded at every n with B(n) > 1.
> - **p = 2.** Then c = 2^a and r = 2^a − 1 is a **Mersenne prime**, and d = strip(r, {r}) = 1, so the twist dies outright. Since r − 1 = 2(2^{a−1} − 1) and t is a q-power dividing it, SAFE(W) ≤ orb(r, t) ≤ **Cap(a) := (2^a − 1)·max(2, L(a))** with L(a) the largest prime-power divisor of 2^{a−1} − 1 — an absolute constant, independent of F and of n.
>
> So the collapse holds unless B(n) ≤ Cap(a) for some Mersenne exponent a with 2^{a+1} − 1 ≤ n: an O(log n) check.

> **Lemma E.2 (Cap is small).** The case a = 2 is trivial (2^{a−1} − 1 = 1, so L = 1 and Cap(2) = 6). For a an odd prime write a − 1 = 2m. Then 2^{2m} − 1 = (2^m − 1)(2^m + 1) with the factors coprime, so every prime power dividing 2^{a−1} − 1 divides one of them. Hence **L(a) ≤ 2^{(a−1)/2} + 1** and **Cap(a) = O(n^{3/2})**. Attained at a = 17, where L = 257 = 2⁸ + 1.

*Coverage.* Four cases, in decreasing strength.

- **n = 2·(odd prime power): unconditional.** Theorem 2.1 gives δ = (m−1)/(2m−1) → 1/2 > 1/9. An infinite family on which the sandwich provably collapses, with no conjecture at all.
- **Even n: conditional.** δ₀^even = 1/4 > 1/9, so granting the even-n Hardy–Littlewood statement the collapse holds at every even n admitting the representation, hence at all sufficiently large even n.
- **Above exponent 3/2: the s = 1 branch dies unconditionally.** Cap(a) = O(n^{3/2}) means it needs δ = O(n^{−1/2}), i.e. **μ(n) = O(n^{3/2})** — exactly the §4 provability barrier, so this residue is the same wall as the rest of Part II rather than an independent one. Shparlinski's Ω(n^{5/4−ε}) gives only δ = Ω(n^{−3/4−ε}) and does not suffice.
- **Odd n at low density: open** (Part J item 2).

> **Theorem E.3 (structure of the s = 2 branch).** Let (c, r) be an s = 2 fallback pair: c = p^a = 2r + 1 a prime power, r prime.
>
> **(i) a ≥ 2 forces p = 3 and r = (3^a − 1)/2 with a prime.** For p^a − 1 = 2r with r prime, factor p^a − 1 = (p−1)(1 + p + ⋯ + p^{a−1}); with a ≥ 2 both factors exceed 1, and the divisors of 2r are 1, 2, r, 2r, so p − 1 = 2. Hence r is a **base-3 repunit prime** — the exponents are a = 3, 7, 13, 71, 103, … (only c = 27, 2187, 1594323 below 4×10⁶): scarcity of the same order as the Mersenne branch of Theorem E.1. Moreover **every Oliver group with orbit sizes {3^a, r} has m\* ≤ c = 2r + 1**: with bottom 3, Lemma C confines the c-twist's cyclic-layer part to divisors of 2, and the top can add only the q-part of 2r — q = r rescues the c-block to full capacity but trivialises the foreign r-block's twist (r ∤ r − 1), giving m\* ≤ orb(r, 1) = r, while any other q leaves the c-block at orb(c, 2) = c; bottom r is impossible (𝔽₃^a is not cyclic, and c-translations in the top fail normality of Γ₁); and both-foreign fails since 3^a is not prime. So the pair is worth at most c — *linear* — to any actual group.
>
> **(ii) a = 1: a non-fallback re-reading dominates, and RESOLVES the bare-pair case.** Here c = 2r + 1 is a **safe prime**. The explicit group Γ = (𝔽_c ⋊ C_r) × AGL(1, r) is Oliver with (p, q) = (r, r) — chain 𝔽_r ◁ 𝔽_r ⋊ (C_{r−1} × 𝔽_c) ◁ Γ, the layer cyclic since gcd(r−1, c) = 1 — and its orbitals are exactly {C(c,2), C(r,2), cr}: the c-block's ±C_r classes merge because |±C_r| = 2r = c − 1, equivalently **orb(c, r) = c·r = C(c,2) identically**. Verified by direct permutation-orbit computation at (c, r) = (11, 5) and (23, 11), group orders 1100 and 27,830, orbitals matching. Since every fallback reading of the same pair scores min(C(c,2), orb(r, t), cr) with orb(r, t) ≤ C(r,2), the non-fallback reading — which is the enumeration's own (p, q) = (r, r) configuration, r-block p-characteristic at full twist, c-block foreign at twist r — scores at least as much. **This is why the five longest-surviving candidates in the certificate's development, all of shape "c safe prime, r = (c−1)/2", were harmless: they are exactly the re-readable pairs.**
>
> When the configuration is the **bare pair** — F = 1 with no leftover, so n = c + r — this is not merely a domination but a **proof of collapse at that n**. The re-reading is itself fallback-free: its only foreign prime is c, its p-part is r, and c = 2r + 1 > r − 1 cannot divide r − 1. So its SAFE and REFINED scores coincide, and if the fallback reading attained B_safe(n) then so does the re-reading, giving B_refined(n) ≥ B_safe(n) and hence equality. Both certificates apply this as a resolution.
>
> It does **not** extend past the bare pair, and the obstruction is sharp rather than technical. With a leftover the re-reading must re-type the leftover parts too, and the commonest case **L = c fails outright**: two blocks of the same prime c would be two *equal* foreign parts, which the admissibility constraints above forbid (they would place C_c × C_c in the cyclic layer), and fusing them is forbidden for the same reason. So the promotion is complete for L = 0 and open for L > 0.
>
> **(iii) The repunit branch is SAFE-capped too.** For a ≥ 2 the foreign block's own SAFE score is absolutely bounded: r − 1 = 3·(3^{a−1} − 1)/2 and 3^{a−1} − 1 = (3^{(a−1)/2} − 1)(3^{(a−1)/2} + 1) with gcd 2, so every odd prime-power divisor of r − 1 is at most 3^{(a−1)/2} + 1, whence orb(r, t) ≤ **Cap′(a) = O(r^{3/2})** for every top prime q. Concretely Cap′(3) = 39 (q = 3), Cap′(7) = 14,209 (q = 13), Cap′(13) = 58,192,753 (q = 73), each comfortably below r^{3/2}. So the a ≥ 2 branch is excluded as a SAFE candidate wherever B(n) > Cap′(a) — an O(log n) check per n, exactly parallel to Theorem E.1's Mersenne case, and it dies unconditionally above the same μ = ω(n^{3/2}) wall. In range: the only feasible pair is (27, 13) (n ≥ 40), whose cap 39 is below the minimum B(n) = 140 there; (2187, 1093) first fits at n = 3280, beyond the current table, where the certificate will test its cap 14,209 mechanically.

> **s = 4 is out of reach while the density floor holds, and would have no theorem if it were not.** The corollary below bounds s by 1/√δ − 1, so a lower density admits a larger s, and the branch reopens only below **δ = 1/25 = 0.04**. **⟦PENDING-REBUILD⟧** *The current floor, its argmin and the resulting largest permitted s are table outputs; `check_doc_figures.py --pass scope` is what keeps this box honest, and the margin to 1/25 is what to read off it.* Unlike s = 3, the branch is **not** thin: c − 1 = 4r with c a prime power and r prime carries no parity or congruence forcing — 33 such pairs exist with c < 4000, beginning (9,2), (13,3), (29,7), (53,13), (125,31) — so no analogue of E.4 is available and an absolute cap would have to come from the foreign block's twist, as in E.1 and E.3(iii). The search clears it at every computed n, so nothing is unproved; but the theorem-side coverage would have a hole that widens as the density floor falls. **The gotcha this box exists for:** the s-ladder is arithmetic on the floor and nothing else, so a sentence naming a threshold stays true-looking after the floor moves. Recompute rather than reuse.

> **Theorem E.4 (the s = 3 branch is a single pair, and dead).** Let (c, r) be an s = 3 fallback pair: c − 1 = 3r. If r = 2 the foreign block holds one pair and SAFE ≤ 1. If r is odd then c = 3r + 1 is even, so c = 2^a with r = (2^a − 1)/3 and a = 2b even; then 2^{2b} − 1 = (2^b − 1)(2^b + 1) with exactly one factor divisible by 3, and after dividing that factor by 3 both factors exceed 1 — except at b = 2, where 2^b − 1 = 3 collapses to 1. Hence r is prime **only for (c, r) = (16, 5)** (verified by scan to a = 200). For that pair, t = qpart(4, q) gives orb(5, t) = 10 at q = 2 and 5 otherwise, so **SAFE ≤ 10 absolutely**. The pair fits only at n ≥ 21, where every computed B(n) is at least 63; beyond the table B(n) ≥ μ-constructions → ∞, so the branch never attains B(n) anywhere. **s = 3 is closed.**

> **Corollary (the fallback question below 1/9, reduced).** Since s ≤ 1/√δ − 1, **δ > 1/9 forces s ≤ 2**, **δ > 1/16 forces s ≤ 3**, **δ > 1/25 forces s ≤ 4**, and so on: **the thresholds are 1/(s+2)²**, so the branch at a given s first becomes reachable once δ ≤ 1/(s+2)². *(The sharp reading of the s = 4 line is "δ > 1/25 forces s ≤ 3", and it does follow — 1/√δ − 1 < 4 exactly when δ > 1/25. Quoting the s = 4 threshold as 1/16 is slack by one and understates how far the floor must fall before that branch opens. The applications below are computed from the inequality directly, so they do not depend on reading the ladder correctly.)* **This covers the whole table so long as the floor stays above 1/25.** **⟦PENDING-REBUILD⟧** *Read the current floor and the largest permitted s off the run; `check_doc_figures.py --pass scope` exists to recount them.* **The gotcha is that the recount is arithmetic on the floor and nothing else**, so a sentence naming a floor or an argmin that is no longer current still reads as true — state the bound without naming one, or requote both together.
>
> So at a computed n with δ > 1/16 the fallback question reduces by theorem to: s = 1 (Mersenne, Cap(a)); s = 2 with a ≥ 2 (repunit, Cap′(a)); s = 2 with a = 1 (safe prime; bare pair resolved by E.3(ii)); s = 3 (dead by E.4) — and there the **only branch without an absolute cap is s = 2, a = 1**, where E.3(ii) resolves the bare pair outright and only the leftover cases remain. Below the sharper thresholds — **δ ≤ 1/25 for s = 4, δ ≤ 1/36 for s = 5** (s ≤ 1/√δ − 1; Corollary F.3's box keeps the two ladders apart) — those branches become reachable and **neither has a theorem**; the search clears them at every computed value, so nothing is unproved, but the theorem-side reduction stops being complete once the floor passes 1/25. Between 1/16 and 1/25 the reduction is still complete: s ≤ 3 there, and every s ≤ 3 branch is dispatched above. Together with the leftover case, that is the theorem-side residue of Part J item 2.

> **The same holds for `wide_cert.py`.** Its pass 2 calls `branch_settled` and skips the dispatched branches, so the same worry applies there, and is tested the same way, via `--no-theorems`. **⟦PENDING-REBUILD⟧** *Coverage figures are run outputs; requote after the certificates are rerun.* The collapse at that scale rests only on the necessary conditions — and at these ranges it rests on nothing else at all, since the dispatch settles no branch there (every live pair has s ∈ {2, 4, 6}); the mode comparison that carries weight is `fallback_cert.py`'s.
>
> **The hardest shape in the certificate, worked at its two extreme instances.** The shape that resists longest is 2c + r\* with c a safe prime, r = (c−1)/2, s = 2 and a leftover L = c — exactly the case E.3(ii) declines to cover, since the (r, r) re-reading would re-type the leftover c-block as a *second* foreign part equal to the first, which Part E forbids. Its two extreme instances below 10⁵ are **n = 50,817 = 2·20327 + 10163** and **n = 89,697 = 2·35879 + 17939**. What settles them is not a re-reading but a cap: **the leftover twist lemma of E″ below** bounds any p-characteristic class's intra term by F·orb(c, dmax), with dmax stripped of the licensed foreign prime. At L = c with c − 1 = 2r that leaves dmax | 2, so the leftover's intra caps at orb(c, 2) = c, far below B; the F = 2 reading of the same n dies the same way, on the same foreign strip. **⟦PENDING-REBUILD⟧** *Both are expected to certify; requote on the rerun.*

> **The theorems are not part of the trusted base over the certified range.** `fallback_cert.py` passes each n's theorem-settled s-branches to the search as a `skip` set, so a branch dispatched by E.1, E.3(iii) or E.4 is never searched — which means an error in one of those theorems, or in its implementation, would silently remove a real candidate. That worry is now closed by experiment rather than by argument. Re-running the certificate with **`skip_settled` disabled entirely** — every s-branch searched, no theorem consulted — still returns **0 surviving candidates at every value**, in 3 seconds. Disabling the E.3(ii) resolution as well, so that not one clause of Part E′ is used, gives the same answer.
>
> So over the certified range the collapse μ(n) = B(n) rests **only** on the eight necessary conditions being necessary. E.1, E.3(ii), E.3(iii) and E.4 explain why the search is cheap and are what any statement about *all* n would have to go through, but they carry no weight in the per-n proof as it currently stands. This is worth stating plainly, because it is a much smaller trusted base than the section's structure suggests: the hardcoded `MERSENNE` and `REPUNIT3` tables, Lemma E.2's bound on L(a), E.4's uniqueness scan to a = 200 and E.3(ii)'s re-reading are all, for the computed range, commentary.

*The certificate.* `fallback_cert.py` enumerates the tuples (p, q, F, c, r) satisfying eight necessary conditions for a fallback configuration to score B(n) — c a p-power; r prime with r | c−1 and r ≠ p; F **any integer** with Fc + r ≤ n (F = F_mid·F_top with only F_top a q-power — see the permissive-block-count box below); each of the p-part intra, foreign intra, cross and within-class-cross terms at least B; and the leftover L = n − Fc − r either 0 or large enough to be a legal part carrying an intra-orbital of size B. Further parts only lower the minimum, so the conditions are necessary and an empty list is a proof at that n. Cost O(n log n) per value. It also reports which values Theorem E.1 settles outright.

> **Over the contiguous range the certificate returns no candidate at any value, and 0 inconclusive.** **⟦PENDING-REBUILD⟧** *Every count in this box — values covered, the theorem-settled share, the per-s-branch dispatch share, the size of the E.3(ii) residue and the largest permitted s — is a run output, and the certificates are held pending the `fb_common.py` condition-(4) repair (`pending-checks.md` R1). Requote them from the rerun rather than from here.* What the run establishes when it is clean is that μ(n) = B(n) is proved at each computed n, independently of tie-breaking, with B_refined = B_safe following rather than being separately measured. The theorem-side residue is a single class: the branches where E.3(ii) is pairwise only and the global promotion is open. The run is also repeated with `--no-theorems`, which stubs every dispatch and rests the result on the eight necessary conditions alone.
>
> **And it rests only on the eight necessary conditions.** Rerun with `--no-theorems`, which dispatches nothing and disables the E.3(ii) resolution, every branch reaches the search and the candidate list should still be empty. That is not a vacuous check — most branches really are dispatched in the normal run, so switching them off genuinely moves work into the search — but it is a check whose value depends on the dispatch actually firing at the range in question, which has to be measured rather than assumed. E.1, E.3(ii), E.3(iii), E.4, Lemma E.2's bound and the hardcoded `MERSENNE` / `REPUNIT3` tables are therefore commentary for the per-n proof — they explain why the search is cheap, and they are what any statement about *all* n must go through.
>
> *The same comparison at `wide_cert.py` is weaker than it looks.* There B_lo replaces B, so the foreign-cap filter removes the s = 1 and s = 3 branches before the dispatch sees them: at NMAX = 10⁴ every live pair has s ∈ {2, 4} and the dispatch settles **nothing**, so the two modes agree trivially. The evidential weight sits with this file, where B is the true value.

> **The certificate's enumeration must be permissive on the block count, and that is easy to lose.** Both certificates enumerate candidate (p, q, F, c, r) tuples, and **F must range over every integer**, not over a q-power ladder: under the corrected shape space F = F_mid·F_top with only F_top a q-power, so a ladder is a restriction in the **anti-permissive** direction — the one that discards a real candidate and turns an inconclusive n into a spurious proof. Three sites in `fb_common.py` carried the ladder (`pair_candidates`, `multi_part_ok`'s p-characteristic list, `single_part_ok`), each collapsing to F = 1 in the generic `q = '*'` branch, and all three are now widened. Enumerating F that the coprimality budget would reject is permissive, which is the right direction. The restriction was vacuous over the table, since the generic branch is gated on r ≥ B and the only n with max(r) = n ≥ B(n) is **n = 6** — but that gate loosens the moment B drops to O(n), and a side-by-side run over all 501,046 (n, c, r) pairs with n ≤ 2000 confirms the widening moves no verdict. The within-class cross coefficient in the same function must likewise be keyed on **F's parity, not q's**; the q-keyed form is the larger at odd q with even F, so it errs permissive here, but the same expression elsewhere would not.

> **Pitfall.** Getting the necessary conditions right took two corrections, both in the permissive direction. Without the leftover-*size* condition, 58 of the then-1,582 values admit candidates; without the leftover-*decomposition* condition, 5 do. Those five are all one shape — c a safe prime with r = (c−1)/2: 359/179 at n = 725, 731 and 719/359 at n = 1457, 1595, 1643 — excluded because the leftover is either not of the form (q-power)·(prime power) (187 = 11·17, 517 = 11·47, 565 = 5·113) or is a prime with trivial q-part twist (193, 379). Reproduce those five before trusting an empty result. The check is also not exhaustive if a leftover could itself be two or more parts; that never arises in range and is reported when it does.

**E″. The global promotion, and the certificate at scale.** Promoting E.3(ii)'s pairwise domination to a global statement runs into a wall that is worth recording precisely, because it shows the residue is arithmetic rather than structural. For a fallback W with s = 2, a = 1 attaining B: **(α)** the r points admit no re-typing — a size-r part is foreign-r or p-characteristic with r = p^j, impossible since p = c; and splitting them fails since every part needs C(s,2) ≥ B while C(r,2) ≥ B already pins r ≈ √(2B); **(β)** the Fc points, kept whole, read uniquely as (F, c), since q^j·c factors no other way into (q-power)·(prime power); **(γ)** F > 1 pins the bottom prime to c — fused translations must lie in Γ₂ — recreating the conflict, while the q = r escape trivialises the r-twist and scores only r < B. So within W's own partition the fallback reading is forced, and any promotion must compare across partitions of n, where the arithmetic enters.

What *is* available is the certificate run at scale, and the key observation making that possible: **the certificate is sound against any proven lower bound on B(n)**. A fallback W attaining B_safe(n) has every SAFE term ≥ B_safe(n) ≥ B_lo(n), so it appears among the candidates computed against B_lo; an empty list against B_lo proves the collapse without knowing B(n). Since B_lo needs only *some* admissible configuration's SAFE score, it costs O(n/log n) per value instead of the table's n^2.9. `wide_cert.py` implements this. Three ingredients are each necessary, and each was found by watching the certificate fail without it.

*B_lo must cover both parities.* The three-part shape (1,c)+(1,c)+(1,r\*) needs n − 2c prime and so exists essentially only for odd n; even n is carried by the two-part shape (1,c)+(1,r\*) and by a single fused class (F, c) with n = F·c, the latter including Theorem 2.1 at F = 2. Using the three-part family alone leaves 4,987 of 8,719 values with no bound at all.

*Each family must be scanned outward from its balance point.* All of them trade a growing term against a shrinking one — C(c,2) against cap(r\*) — so the optimum is interior: near c ≈ n/2 for the two-part shape and c ≈ n/3 for the three-part. Scanning downward from maximal c instead gives r\* tiny and cap(r\*) worthless, which collapses the weakest density from 0.020 to 0.000007 and makes the permitted s explode. With outward scanning, keeping the 60 nearest prime powers suffices, and a few thousand values need a top-up from the family menu or a full scan.

*The leftover machinery needs both checks:* the single-part test of conditions (7)–(8), and a **multi-part decomposition check** — an exact-sum reachability computation over the admissible part sizes (foreign primes r_j ≠ r with orb(r_j, qpart(r_j−1, q)) ≥ B, distinct; p-characteristic sizes F′p^j with F′·C(p^j,2) ≥ B, repeats allowed), sound because it enforces necessary conditions only.

> **Result: the collapse B_refined(n) = B_safe(n) = B(n) is certified from proven lower bounds alone, far past the computed table's reach. ⟦PENDING-REBUILD⟧** *The coverage count is a run output and is requoted after each certificate run; see `pending-checks.md` R1.* The cost is minutes of arithmetic at 10⁵: the lower-bound pass dominates at roughly 150 s per 10⁵ and is cached, so the next decade is an afternoon rather than a research problem.

> **The leftover twist lemma, and why the sharp case of E.3(ii) is no longer sharp.** The shape that resisted longest is s = 2 with c a safe prime and **leftover L = c** — two equal c-blocks plus the foreign r — since that is precisely where the (r, r) re-reading is unavailable, two blocks of the same prime being unable to both be foreign. It is closed by a cap rather than a re-reading.
>
> **Lemma (leftover twist cap).** *In any admissible configuration containing a foreign block of prime size r, every p-characteristic class of F blocks of size c whose twist shares the prime r has minimum intra-orbital at most F·orb(c, d), where d is qpart(c−1, q) times the largest divisor of the remainder coprime to r — provided Corollary C′ licenses the strip, i.e. sharing_bound(p, a, r) = min(r·ord_r(p), C(r,2)) < B.*
>
> *Proof.* The twist has order coprime to p, so it embeds in (cyclic layer) × (top q-group), and only the q-part can lie in the top layer. For the cyclic part: a configuration that *keeps* the share carries, by Lemma C's coupling, a class of at most sharing_bound(p, a, r) on the foreign block, so when that is below B no such configuration attains B and discarding it is sound. ∎
>
> **Only the foreign prime may be stripped, and the block count may not.** The tempting extra factor — also stripping F_mid, on the grounds that the block rotation sits in the same cyclic layer — is the projection-versus-subgroup error: the rotation's image is a *quotient* of the layer, and an entangled generator supplies rotation and full twist together at any F_mid. Stripping it is anti-permissive and would discard real candidates. See the same gotcha at the SAFE cap in the Notation box and at Part 0 step 3.
>
> Every ingredient is an already-proven necessary condition or a licensed strip, so this is the leftover analogue of the coupling argument. **At L = c the shape dies on the foreign strip alone:** c − 1 = 2r, so the r goes and, for the odd q that survive the foreign gate (q ∤ 2r), the q-part is 1 — leaving d | 2 and an intra term of orb(c, 2) = c ≪ B. The q = 2 reading dies earlier still, at orb(r, 2) = r < B. The same cap applied to the *main* class kills the F = 2 reading: there too c − 1 = 2r, the foreign strip removes r, and what is left is d | 2. **No F_mid strip is used anywhere in this, and none is available** — which matters, because an earlier route to the same conclusion leaned on one. **The hardest instances of this shape below 10⁵ — n = 50,817 with (c, r) = (20327, 10163) and n = 89,697 with (35879, 17939) — are closed by exactly this cap. ⟦PENDING-REBUILD⟧** The foreign-leftover analogue falls out the same way: a foreign leftover of size c needs q | c − 1 = 2r, forcing q = 2, which is dead at the same gate.

The survivors at 10⁴ before the multi-part check were themselves informative: every one involved the pairs (1439, 719) or (2879, 1439) — the **Cunningham chain 719 → 1439 → 2879**, each prime twice the previous plus one, the arithmetically worst case for this branch. Their structure is what kills them: r − 1 = 2q with q prime (718 = 2·359, 1438 = 2·719, 2878 = 2·1439), so the *only* top prime with orb(r, t) ≥ B is that q, which forces every extra foreign part in the leftover to satisfy **r_j ≡ 1 (mod q)** — a modulus of 359–1439 against a leftover window of ~1,100–4,600, leaving no admissible decomposition. This q-pinning mechanism is the general reason deep-chain candidates strangle themselves, and it generalises — see the box.

> **q-pinning in general, and the two places it fails.** The Cunningham instance is the extreme case of a chain that runs entirely off the foreign gate. Write the foreign twist as t = q^e with cofactor u = (r − 1)/t.
>
> 1. orb(r, t) ≤ rt, so the gate orb(r, t) ≥ B forces **t ≥ B/r ≥ δn/2**;
> 2. hence **u ≤ 2/δ** — the bounded-cofactor regime, the same inequality as the θ = 1 endpoint of `arithmetic-of-density.md` §3.6, which is no coincidence;
> 3. hence **q ≥ (δn/2)^{1/e}**;
> 4. Lemma B′ puts a foreign leftover part's twist in the top q-group, so such a part is worth more than its own size only if **q | r_j − 1**, i.e. r_j ≡ 1 (mod q);
> 5. so the leftover admits at most **L/q ≤ n/q** foreign positions, which at **e = 1 is the constant 2/δ**.
>
> *Measured over the table*, on the 32,830 foreign parts passing the gate: at **e = 1 — 87.6% of them — the median number of admissible positions is 0 and the maximum is 9**, against the ceiling 2/δ ≈ 44. So on the main branch the mechanism is not merely present, it is usually total.
>
> **It becomes conditional at step 1, and only there.** Every later bound is proportional to δ, so an unconditional q-pinning lemma needs an unconditional floor δ ≥ δ₀ — which is Hypothesis (H), or `arithmetic-of-density.md` §5's conjecture. Inside the verified range the floor is computed and the argument is unconditional; beyond it, this route is conditional on the same hypothesis the density ceilings are. That is not circular, since B(n) ≥ δ₀·C(n,2) comes from the constructions rather than from the certificate, but it does mean the unconditional version dies with the asymptotic floor.
>
> **Two escapes, and they are one phenomenon.** At **e ≥ 2** the position bound degrades to n/(δn/2)^{1/e} ~ n^{1−1/e} and the measured medians follow it — 13, 33, 40, 116 at e = 2, 3, 4, 5, with a maximum of 524 — covering 12.4% of gate-passing parts. At **q = 2** the pinning is vacuous outright, since r_j ≡ 1 (mod 2) says nothing; that is 2.2% of them, and it correlates with the large-e cases because the 2-power branch is where e runs to 8. Both are the regime where the family stops being polynomial in q (`arithmetic-of-density.md` §3.5.6), and q = 2 is the **Fermat** branch of §3.3.2.
>
> **And pinning reaches only half the leftover.** It constrains *foreign* leftover parts. A p-characteristic leftover part is not pinned by q at all; what bounds it is the leftover twist cap below, which is Lemma C's coupling together with Corollary C′ — proved at every a, so this half is unconditional. What remains conditional is the pinning half, which fails at q = 2 and large e.
>
> **The e = 1 branch, worked as far as it goes — and it does not close by counting.** Take the main branch: e = 1 with q odd. Three size bounds are available, each from a part's own intra term against B:
>
> - the p-characteristic part of total size S = F·c has F·C(c,2) ≤ S·c/2 ≤ S²/2, so **S ≥ √(2B)**;
> - each foreign part r has orb(r, ·) ≤ C(r,2) < r²/2, so **r ≥ √(2B)**, and likewise r_j;
> - with B = δ·C(n,2), √(2B) ≈ n√δ.
>
> Three parts each of size ≥ n√δ give 3n√δ ≤ n, i.e. **δ ≤ 1/9** — which is Proposition F.1 at k = 3 and nothing new. *Adding the pinning does not improve it:* r_j ≥ q + 1 with q ≥ B/r gives n ≥ √(2B) + r + max(√(2B), B/r) ≥ 3.54√B, hence δ ≤ 0.16, **weaker** than 1/9. So above density 1/9 the branch is empty for part-counting reasons already known, and below it **counting alone cannot close the branch**; what remains is the specific arithmetic of the pinned positions.
>
> **What that arithmetic gives, measured over the table.** Across every e = 1 odd-q foreign part passing the gate at n ≤ 2000, the leftover holds **24,322 candidate positions r_j ≡ 1 (mod q)**, of which exactly **4 are admissible** — prime, distinct from r, and passing their own gate — and those four are two configurations counted twice by symmetry:
>
> | n | δ | q | r | r_j | space left |
> |---|---|---|---|---|---|
> | 779 | 0.0706 | 73 | 293 | 439 | **47** |
> | 1943 | 0.0577 | 137 | 823 | 1097 | **23** |
>
> Both die on the p-characteristic part, which needs S ≥ √(2B) — 207 at n = 779 and 467 at n = 1943 — against 47 and 23 of remaining space. The pinning forces r_j well above its own floor (439 against 207; 1097 against 467), and it is that excess, not the generic bound, that leaves no room.
>
> **So the status of e = 1 is: empty over the computed range, by a finite check rather than by a theorem.** Above δ = 1/9 it is closed unconditionally by F.1. Below, it reduces to enumerating the ≤ 2/δ pinned positions at each n and testing each — which is what `fallback_cert.py` does, and which is why this branch has never produced a candidate. That is a reduction to a bounded search, not an elimination.

> **So the realistic target is not "eliminate the fallback branch unconditionally"** but: *conditional on δ ≥ δ₀, the fallback branch reduces to the q = 2 and large-e cases together with the a > 1 case* — a named finite residue rather than an open problem. That is a statable lemma and it is closer than it looks.

*A free diagnostic.* **B_safe − B_refined is exactly the width of the interval containing μ(n)**, computable by running both modes. It is zero wherever the certificate passes, and if the certificate ever fails nothing becomes wrong — both endpoints stay valid and the sandwich merely opens.

## Part F. The search is bounded

> *The counting arguments here are independent of the shape space, but the part-count cap is derived from the density floor, which moves with every table extension. Re-derive the numbers before relying on them; the inequalities themselves are stable.*

The enumeration needs no number-theoretic input to be finite, and the bound is small.

> **Proposition F.1 (part count).** If a configuration on n points achieves density δ = m\*/C(n,2), then it has at most **1/√δ** orbits.
>
> *Proof.* Each orbit's capacity is at most C(s_i, 2) < s_i²/2 (Part C), and m\* ≤ min_i cap(s_i) by Part A, so s_i > √(2m\*) = √(δ·n(n−1)) for every i. Summing over the k orbits, n = Σ s_i > k√(δ·n(n−1)), whence k < 1/√δ (up to the n/(n−1) factor). ∎

Two consequences.

*The search is small in practice.* The floor over the computed table is **⟦PENDING-REBUILD⟧** tentatively 0.048039 at n = 2183, giving k ≤ 4 (as did v4's 0.045742); at the median density 0.1994 the bound is k ≤ 2. And wherever the ladder keeps δ above 1/25 (**⟦PENDING-REBUILD⟧** for the exact floor and range), **no admissible configuration in that range has more than four orbits**, and most have two. (**Gotcha:** a family-menu figure is not a density, and reading 0.0147 at n = 4917 as one gives k ≤ 8. That figure is a *lower bound* on μ rather than a density — see the two-δ caution in Part H — and the ladder's floor supersedes it in both directions.)

*The search is self-certifying.* Let B_K(n) be the maximum over configurations with at most K parts, and δ_K its density. B_K is non-decreasing in K, so δ_K is too, and 1/√δ_K is non-increasing. Compute B_2, B_3, … and stop at the first K with 1/√δ_K ≤ K: by Proposition F.1 no configuration with more than K parts can achieve δ_K, so B_K = B. For every n below 10⁴ this terminates by K = 8. **No conjecture is consulted at any point.**

> **Proposition F.2 (fused parts cost more).** Let f be the number of parts with F_i > 1. Then **k + (√2 − 1)·f ≤ 1/√δ**.
>
> *Proof.* An unfused part has s_i = c_i and needs F_i·C(c_i,2) ≥ m\*, i.e. s_i(s_i − 1) ≥ 2m\*, so s_i ≳ √(2m\*). A part with F_i ≥ 2 has c_i = s_i/F_i, and the same requirement F_i·C(c_i,2) ≥ m\* gives s_i² ≥ F_i(2m\* + s_i) ≥ 2F_i·m\* ≥ 4m\* (discarding the F_i s_i term, which only helps), so s_i ≥ 2√m\*. Summing over the k parts, n ≥ √m\*(√2(k − f) + 2f), and √m\* ≈ n√(δ/2) gives the claim. ∎
>
> **F.1 is tight and cannot be improved to k ≤ 3 by counting.** Running the same argument through the *smallest* part reproduces k ≤ 1/√δ exactly, so the equal-parts case saturates it, and no tightening of constants does better: at the density floor (**⟦PENDING-REBUILD⟧** tentatively 0.048039 at n = 2183; v4's 0.045742 shown here) F.2 gives k ≤ 4.29 against F.1's k ≤ 4.68 — still 4, not 3, and a higher floor only lowers both. Since no winning configuration anywhere in the computed range uses more than three parts (Part I), the residual factor is arithmetic, not metric: any proof of k ≤ 3 must use the prime-power structure and the Diophantine constraint n = Σ F_i c_i. This is Part J item 1.

> **Corollary F.3 (density thresholds for each part count).** δ > 1/(K+1)² ⟹ k ≤ K. In particular **δ > 1/16 ⟹ k ≤ 3** and δ > 1/9 ⟹ k ≤ 2. So the minimality target of Part J item 1 is *free* at all but the lowest densities, and what remains open there is only the δ ≤ 1/16 regime.
>
> *Do not conflate this with the s-bound of Part E′.* That one reads s ≤ 1/√δ − 1 and governs (c−1)/r, not the part count. The two ladders descend from the same counting inequality k, s < 1/√δ, but they are **offset by one**, because F.1 bounds k by 1/√δ while E′ bounds s by 1/√δ − 1: δ > 1/(K+1)² gives k ≤ K, whereas s ≤ K needs only δ > 1/(K+2)². So at δ > 1/25 the k-ladder reads 4 and the s-ladder reads 3. That shared source is for the *arithmetic*, not a shared mechanism for the *content*: the two quantities are unrelated, and an argument bounding one says nothing about the other. (The offset is the thing to keep straight — "s ≤ 3 at δ > 1/25" is correct and sharp, and reading the two ladders as coinciding is what produces an off-by-one in either direction.)

> **Proposition F.4 (the converse: a density floor forces a shifted-prime statement).** Suppose μ(n) ≥ δ₀·C(n,2). Then **at least one** of the following holds.
>
> **(a) Multiplicative branch.** n = M·p^b with p^b a prime power and M < n/(δ₀(n−1)) — so M ≤ 1/δ₀ up to a 1 + O(1/n).
>
> **(b) Shifted-prime branch.** There is a prime r ≥ δ₀(n−1)/2 with a **prime-power divisor Q of r − 1** satisfying **(r − 1)/Q ≤ 2/δ₀**.
>
> Integers of the form (a) have density zero, so **(b) holds for almost all n**.
>
> *Proof.* The score is a minimum over orbitals, so **every** part's intra term is at least δ₀·C(n,2) = δ₀n(n−1)/2 — this is what makes a converse available at all, and it is the same feature that makes the forward direction hard.
>
> If some part is **foreign**, it is a class of F ≥ 1 blocks of prime size r whose twist Q is a q-power — forced, not assumed: AGL(1,r) is nonabelian, so the translations occupy the abelian cyclic layer and the twist is pushed into the top q-group, which is Lemma B′'s content. The class contributes at most F·r·Q, and **F·r ≤ n jointly** — the same care the matching branch needs — so F·r·Q ≥ δ₀n(n−1)/2 gives Q ≥ δ₀n(n−1)/(2·F·r) ≥ δ₀(n−1)/2, and Q ≤ r − 1 ≤ n − 1 then gives both r ≥ δ₀(n−1)/2 and (r − 1)/Q ≤ 2/δ₀. That is (b). (The F ≥ 2 case is shape S9, which Lemma D2 shows is dominated and which wins nowhere in range; the bound is stated for it anyway, since domination is not non-existence and F.4 quantifies over configurations rather than over winners.)
>
> If **no part is foreign**, every part is a matching class of F_i blocks of size c_i = p^{a_i}, all sharing the chain prime p (Part B). From F_i·c_i²/2 > δ₀n(n−1)/2 with F_i c_i ≤ n we get c_i > δ₀(n−1) and F_i < n/(δ₀(n−1)); writing b = min a_i, n = Σ F_i p^{a_i} = p^b·(Σ F_i p^{a_i − b}) with p^b ≥ min c_i, so the cofactor is bounded by the same quantity. That is (a). ∎
>
> **Checked shape by shape against the Part B census, which is a different kind of check from the numerical one.** The proof splits on whether a foreign part is present, so the census is a finite audit of that split. **S3** (c + r\*), **S4** (2c + r\*), **S5** (top-fused matching + outside), **S6** (two outside blocks) and **S7** (middle-fused matching + outside) all contain a foreign part and land in (b) — S6 twice over, either block serving. **S9** (fused outside class) also lands in (b), and is the one shape the first draft of the proof did not cover: it needs the joint bound F·r ≤ n rather than r ≤ n, exactly as the matching branch does. **S8** and **S10** are killed (D1 and D2q), so no configuration of those shapes exists to quantify over — S10 instructively, its twist being forced into the cyclic layer beside the translations and hence trivial, which is the degenerate boundary of the very confinement (b) relies on. **S1** and **S2** are the multiplicative engine and land in (a).
>
> *One thing the census walk shows that the census itself does not.* Branch (a) is **wider than S1 ∪ S2**: any all-matching configuration lands there, including multi-class shapes the census does not name because they win nowhere — for instance n = 640 = 1·256 + 3·128 (`arithmetic-of-density.md` §6.2), which is two matching classes with no foreign part, reaches δ = 0.1192, and satisfies (a) with p^b = 128, M = 5 against 1/δ = 8.4. The proof covers these because it splits on the *presence of a foreign part*, not on the census; had it been written shape by shape it would have missed them.
>
> **Why (a) carries no arithmetic content, and must therefore be an alternative rather than a weakened conclusion.** A matching class's twist is **any divisor of c − 1** (Part 0's shape space): it is carried by the cyclic layer, not the top q-group, and a class may take the *full* twist d = c − 1, for which the cofactor is 1 and the divisor need not be a prime power at all. So at n = M·p^b the multiplicative engine reaches density ≈ 1/M with no shifted-prime input whatever, and no statement of the form "(c − 1)/d bounded, d a prime power" follows. **An earlier form of this Proposition made (a) qualify only the primality of the witness, leaving the divisor conclusion apparently unconditional. That was wrong**, and the asymmetry it missed is exactly the one Lemma B′ creates: foreign twists are confined to the top layer and so are prime powers; matching twists are not confined and so are not.

> **Branch (b) rests entirely on Q being a prime power** — with Q merely a divisor of r − 1 the conclusion is vacuous, since Q = r − 1 always qualifies, which is precisely what happens in branch (a). The confinement is **Lemma B′'s**, so this is a layer-assignment claim resting on a proved lemma rather than on an unstated assumption — but layer-assignment claims are the category with the worst record here, and B′ is itself the one structural lemma still inviting further scrutiny (`pending-checks.md` T1, T8). One reading of the Proposition so far.
>
> **Checked against the table.** All three inequalities hold at every one of the 2,186 contiguous rows: (r − 1)/Q ≤ 2/δ at all 1,409 foreign primes appearing in winning witnesses, r ≥ δ·n at every one, and M ≤ 1/δ at all 777 one-part winners. The all-matching bound is nearly attained at n = 2594 = 2·1297 (ratio 0.9996), which is also §6.1's tightest feasibility row. The largest cofactor (r − 1)/Q anywhere in the table is **12** — (H)'s own constant, recovered from the opposite direction — against the bound's D = 44 at the global floor, so the Proposition is loose by a factor ≈ 4 against what optima use. **⟦PENDING-REBUILD⟧** These are v4-era counts; `converse_check.py` (in R1) requotes them. The v5 partial frontier gives the same 12 at the same witness with no violations, so the corrected shape space has not disturbed either the inequalities or the headline constant so far; the slack figure moves with the floor and so is range-dependent even on a correct table.
>
> **What the second branch costs, and why it is not a defect of the statement.** Integers of the form M·p^b with M bounded have density → 0, so for **almost all** n the all-matching branch is unavailable and the conclusion is the clean one: *a prime r linear in n whose r − 1 has a prime-power divisor of bounded cofactor*. But the decay is only of order H_M/log n — at n ≤ 10⁵ roughly 44% of integers are still within a factor 25 of a prime power — so this is an asymptotic exclusion and not one any computation will exhibit.

This is the structural answer to the question of whether the enumeration needs Hardy–Littlewood-type input to cut down cases. It does not. The division of labour is:

| question | apparatus | conditional? |
|---|---|---|
| what shapes can an Oliver group have? | Parts A–D, group theory | no |
| what is the maximum at a given n? | bounded search, ≤ 1/√δ parts | no |
| how does that maximum behave as n → ∞? | Hardy–Littlewood, Chowla (§4–5 of the notes) | yes |

Number theory answers *which n admit a good configuration*, never *which configurations are admissible*. The temptation the four failures all yielded to was replacing the general shape by a menu of special cases because the general search looked expensive; Proposition F.1 removes the excuse, and writing the general enumeration once — over all configurations with at most 1/√δ parts — is what remains of Part E.

## Part G. Nested towers add no new shapes

The one structural loose end left by Parts A–F was whether a deep imprimitive tower, interacting with foreign parts elsewhere in the partition, could escape the classification. It cannot, and the reason collapses the shape space rather than enlarging it.

**G.0 The chain is a choice, not an invariant.** A group may admit several Oliver chains with different primes — a cyclic group of order pqr is exhibited as cyclic-with-trivial-top by Γ₂ = 1, Γ₁ = Γ for *every* (p, q), and other choices place any of the three primes at the bottom. So "the bottom prime" and "the top prime" always mean *of the chain under consideration*. Nothing below is affected, since every argument fixes a chain first, but two things follow that are worth separating.

*A gain not yet taken.* Each admissible chain yields its own congruence: a group with top primes q₁ and q₂ forces χ(Δ_P^Γ) ≡ 1 modulo both, hence modulo lcm(q₁, q₂). The batteries of §8 enforce one chain per group and therefore leave this on the table.

*Slack in the bound.* To bound m\*(Γ) any admissible chain may be used, so the truth is m\*(Γ) ≤ minimum over its chains of that chain's bound. The enumeration instead maximises over (p, q), which is the least restrictive choice. This is **safe** — every group is covered by at least one enumerated configuration, so the result remains an upper bound — but a tighter bound is available to anyone willing to pair each group with its most restrictive chain.

*What the enumeration does with the readings.* `mu_enumerate_v3.py` loops over every pair (p, q) of primes, so every chain-prime reading is enumerated and no Oliver group escapes: each admits some chain, that chain's primes are in the loop, and its configuration is admissible there. Empirically the optimum is attained at a **unique** (p, q) — (5,2) at n = 10, (2,3) at n = 12, (83,53) at n = 273 — because the winning configuration determines both primes.

*Twist placement: why the code need not model it.* This looks like a gap and is worth spelling out. For a **foreign** block there is no choice at all: its translations and its twist do not commute (AGL(1,r) is nonabelian), the translations must lie in the abelian cyclic layer, so the twist is forced into the top — which is exactly the content of Lemma B′, and why foreign twist orders are q-powers. For a **p-characteristic** block there is a genuine choice: the twist may sit in the cyclic layer, in the top, or split between them. Only the placement in the cyclic layer is subject to Lemma C's coupling, so one might expect a q-power twist to escape the constraint by moving to the top.

It cannot. Write the twist order as d = d′·qᵉ with gcd(d′, q) = 1. Since Γ/Γ₁ is a q-group, the image of the twist there is a q-group, so **d′ is forced into Γ₁** and Lemma C binds d′ alone. But a foreign prime r carries a nontrivial q-power twist, so q | r − 1 and hence **q ≠ r**; therefore r never divides qᵉ, and

> **r | d ⟺ r | d′.**

The part that could escape to the top is precisely the part that was never at risk. So `strip(c − 1, foreigns)` — the largest divisor of c − 1 coprime to the foreign primes — is exactly right, without modelling placement. *One unstated case:* the argument assumes the foreign block's twist is nontrivial. If q equals a foreign prime ρ whose twist is trivial, a p-part's twist can carry a ρ-power in the top after all, and the strip-based score under-states that p-part (Theorem E.3(i)'s q = r reading is the instance). This never affects the configuration's minimum: a foreign block with trivialised twist binds at orb(ρ, 1) = ρ, below anything the escape gains.

*Worked example (n = 26 as 9 + 17).* The 17-block is foreign, so its twist is forced to the top; with q = 2 all of C₁₆ survives and its orbital is 17·16/2 = 136. The 9-block is p-characteristic with twist C₈, which may go either way; gcd(8, 17) = 1 so Lemma C strips nothing and both readings give C(9,2) = 36. With the cross class at 9·17 = 153, m\* = 36 — the 9-block binds, and this configuration is far from μ(26) = 156, which comes from 2 × 13 instead. Lemma C does bite elsewhere: for c = 16 with foreign r = 3 the twist drops from 15 to 5, and there are 74 such (c, r) pairs below 200. In every one of them the q-part of the twist is too small to help, exactly as the equivalence above predicts.

**G.1 The chain descends to block stabilisers.** Let H be the setwise stabiliser of a block. Then H ∩ Γ₂ is a p-group, (H ∩ Γ₁)/(H ∩ Γ₂) embeds in the cyclic Γ₁/Γ₂ hence is cyclic, and H/(H ∩ Γ₁) embeds in the q-group Γ/Γ₁ hence is a q-group. So H — and therefore its action on the block — inherits an Oliver chain **with the same (p, q)**. The recursion of Part C is thus sound at every depth, with the primes fixed throughout.

**G.2 Every orbit is F·c with c a prime power and F = F_mid·F_top.** Iterate Part B on an orbit O. The recursion terminates at the finest blocks, which are **primitive**, hence affine of prime-power degree. What the tower contributes is a block count at each level, and those counts multiply into a single F.

> **Pitfall — the block count is not a q-power, and assuming it is breaks the upper bound.** The natural argument is: the block-permuting group is transitive on the blocks, it lies in the top q-group, a transitive q-group has q-power degree, so the count is a power of q. The failure is at the second clause, which is assumed rather than shown. **The block-permuting group may sit in the cyclic layer**, where the only constraint is that Γ₁/Γ₂ stay cyclic — so the count may be **any integer** coprime to everything else the cyclic layer carries (a transitive abelian group is regular, so the image on the blocks is C_{F_mid} for any F_mid; "prime power" here was a slip — the n = 282 battery entry has F_mid = 6, and the code enumerates every integer). Part 0 sets the corrected shape space out in full; the witness is n = 308, worked there.
>
> *Two things the pitfall does **not** reach.* The bottom-layer branch is genuinely dead, by D1 and D2: p-power block counts over a p-characteristic block make the orbit a prime power, already enumerated as (F, c) = (1, |O|) and scored higher that way; over a foreign block they leave a family linear in the orbit size. So **F = F_mid · F_top with no contribution from Γ₂**, F_top a q-power and F_mid subject only to the cyclic layer's coprimality budget. (For an outside block the bottom branch is dead outright; fusion by the other two layers is possible but dominated, D2.)
>
> *Scale of what the cyclic-layer branch adds.* Restricted to one cyclic-fused class per configuration and ignoring the coprimality budget against other classes' twists, 57 values of n ≤ 2400 have such a configuration beating the q-power-only bound, median ratio 1.141 and worst 2.387 at n = 2375. That is a two-sided estimate — it understates by allowing only one fused class and overstates by not checking coherence — so it indicates the size of the branch rather than measuring it.

**G.3 The general configuration, in final form.** Combining G.2 with Parts A–D, an Oliver group on n points is described by a choice of chain primes (p, q) and orbits O₁, …, O_k with

> **n = Σᵢ Fᵢ·cᵢ**, Fᵢ = F_mid,ᵢ·F_top,ᵢ with F_top a q-power, cᵢ a prime power, each cᵢ p-characteristic or a foreign prime,

twists dᵢ | cᵢ−1 (a q-power when foreign), subject to Lemma C. The orbital data is that of Part E's value formula: intra-orbital Fᵢ·orb(cᵢ, dᵢ) per class, within-class cross (Fᵢ or Fᵢ/2)·cᵢ² when Fᵢ > 1 — Fᵢ for odd Fᵢ, Fᵢ/2 for even Fᵢ — and between-orbit classes of size sᵢsⱼ.

**G.4 The search is bounded on every axis.** With δ = m\*/C(n,2): the intra-orbital satisfies Fᵢ·orb(cᵢ,dᵢ) < Fᵢcᵢ²/2 and must be at least m\*, while Fᵢcᵢ ≤ n. Hence

> **cᵢ ≥ δn**,  **Fᵢ ≤ 1/δ**,  and **k ≤ 1/√δ** (Proposition F.1).

At the weakest density below 10⁴ (0.0147) this reads c ≥ 0.0147n, F ≤ 68, k ≤ 8; at the median density, c ≥ 0.2n, F ≤ 5, k ≤ 2. Checked against every fused-form witness in the table — **3,053 of 3,053** satisfy both derived constraints, with no exceptions.

So the configuration space is finite along all three axes, with bounds computable from the density alone, and the self-certifying iteration of Part F applies unchanged. The general enumeration of G.3 is written once, in `mu_enumerate_v3.py`, rather than as a menu of special cases — the failure mode that produced all four historical corrections — and Part E records its status.

## Part H. The cost of the search, stated without number theory

Write δ = B(n)/C(n,2) for the density the search is currently certifying. Parts F and G.4 bound every axis of the configuration space:

| axis | bound | source |
|---|---|---|
| number of orbits k | **k ≤ 1/√δ** | Prop. F.1 |
| finest-block size cᵢ | **cᵢ ≥ δn** | G.4 |
| fusion count Fᵢ | **Fᵢ ≤ 1/δ** | G.4 |
| tower depth | *irrelevant* — absorbed into Fᵢ | G.2 |

From these the size of the search follows. The admissible parts are pairs (F, c) with c a prime power in [δn, n] and F a q-power at most 1/δ, so their number is

> **P(n, δ) = O( (n / log n) · log(1/δ) )**,

and a configuration is a multiset of at most k of them summing to n. Including the choice of chain primes (p, q), the whole search is

> **O( π(n)² · P(n,δ)^{1/√δ} ) = n^{O(1/√δ)}** operations,

with the self-certifying iteration of Part F guaranteeing that the correct K is reached and recognised. Every quantity here is elementary; no conjecture has been used, and the enumeration halts with a certificate regardless of how δ turns out.

*Preprocessing.* The primes and prime powers up to n, and the factorisations needed for the q-part and Lemma C computations, all come from a single smallest-prime-factor sieve: **O(n log log n)** time and O(n) space. Afterwards primality and prime-power tests cost O(log n), q-parts O(log n), and the divisors of c−1 cost O(√n). This is dominated by the search itself — at least π(n)² ≈ (n/log n)² from the choice of chain primes alone — so it never enters the asymptotics. It is stated only because the cost model would otherwise be silent about where the arithmetic comes from.

*Measured cost* on one core (recorded when the run stood at n = 1540): 0.63 s per value at n ≈ 300, 4.79 s at n ≈ 600, 15.63 s at n ≈ 900, fitting **≈ n^2.9**. Projecting from there: roughly 11 h to reach 2000, 75 h to 3000, 595 h to 5000. Values of n are independent, so the work parallelises perfectly across disjoint ranges.

**The one term that is not bounded by anything elementary is δ itself**, and that is the whole of the dependence. *Two different δ's appear in this document and must not be conflated.* Part F's self-certification uses δ = B(n)/C(n,2), the density the search is certifying; the figure "0.0147 at n = 4917" below comes from the family-menu table `mu_fast.py`, which is a *lower* bound on μ and hence a smaller δ. Using the smaller one is safe — a too-small δ yields a too-large k bound — but it is why that number can sit alongside Part I's floor — **⟦PENDING-REBUILD⟧** tentatively 0.048039 at n = 2183 (v4: 0.045742 at n = 1817) — over the certified range without contradiction. Unconditionally, BBKN gives μ(n) = Ω(n log n), i.e. δ = Ω(log n / n), so the exponent 1/√δ is only bounded by **O(√(n / log n))** and the search is n^{O(√n)} — subexponential, but not polynomial. Empirically δ never drops below 0.0147 anywhere under 10⁴, giving k ≤ 8, but that is an observation about a finite range and not a theorem.

**Forward pointer.** This is where the number-theoretic conjectures re-enter, and in a role distinct from the one they play in §§4–5 of the notes. There they bound μ(n) from below; here the *same* bound bounds the **running time of the search**, because δ appears in the exponent. Under the ladder — δ ≥ 1/4 for even n, δ ≥ 0.049 for odd n with 3 ∤ n, δ ≥ 0.028 for 3 | n — the orbit count falls to k ≤ 2, 4, 5 respectively (1/√0.25 = 2, 1/√0.049 = 4.52, 1/√0.028 = 5.98) and the search becomes **polynomial of fixed degree** in n. So a Hardy–Littlewood-type hypothesis buys two things at once: the value of μ(n), and a guarantee that the certified enumeration terminates in polynomial rather than n^{O(√n)} time. That is worth stating explicitly in the number-theory sections, since it is a consequence of those conjectures that has nothing to do with what they were introduced for.

## Part I. Measurements

> *Figures below are measurements of the current table over its **contiguous range** — every non-prime-power to n = 2600, 2,186 rows — so they describe what the enumeration computes, which equals μ(n) wherever the collapse certificate applies. They move with every extension; `validate_table.py` prints them back for copying, and its INFO lines are keyed to the places here that quote them. The n = 10 and n = 12 GAP comparisons are of a different kind and are the more valuable for it: they are the only check that would catch a **missing** shape, since a missing shape has no witness and nothing else in the pipeline can see one. They did not fire at those degrees, which says only that such a shape needs a larger n to appear — the smallest known instance is n = 143.*

From the current table, unconditional mode, over its contiguous range. **⟦PENDING-REBUILD⟧** *Every distributional figure in this Part is a measurement over that range and moves with it; `validate_table_v3.py` prints them back for copying.*

> *Reconciling the several row counts quoted across these documents, since they look inconsistent and are not.* They are different windows on one file. The CSV holds every non-prime-power to the **contiguous frontier** — 2,186 rows to n = 2600, which is the basis of every count in this Part — plus the sparse higher values the branch-and-bound of `arithmetic-of-density.md` §5 adds from the worklist. A figure quoted against an older frontier, or against the whole file rather than the contiguous prefix, differs from the numbers here for that reason alone. **The gotcha that produced the confusion in the first place:** the worklist rows are selected by low ladder score, so including them moves every share downward while leaving the floor untouched.

- every value certified; no internal inconsistency; **no row violates the Proposition F.1 stopping rule** (checked directly: 1/√δ ≤ K on every row);
- **independently re-derived**: recomputing m\* from each row's witness string by the G.3 formulas, in a separate implementation, reproduces `mu_bound` on **every row**, with parts summing to n, foreign parts prime and unfused and pairwise distinct, and p-characteristic parts powers of p. *(A re-derivation that also asserts every F is a q-power will now fail: F = F_mid·F_top, and the cyclic-layer-fused rows are exactly the ones it would flag.)*
- the unconditional fallback is invoked on the optimum at **0 of 2,186** values, so the bound is unconditional throughout;
- **certification level, not orbit count.** The `certified_K` column records the K at which the Part F iteration halts, which is one more than the part count it rules out. Its distribution is {2: 394, 3: 1443, 4: 331, 5: 18}, but the **actual part counts are {1: 777, 2: 1393, 3: 16}** — no winner uses more than three parts. **Reading `certified_K` as an orbit count is the trap here**, and it invites the conclusion that "K = 5 is the predicted ceiling, reached by the hardest rows" — wrong twice over. At the weakest density in range (**⟦PENDING-REBUILD⟧** tentatively 0.048039 at n = 2183) Proposition F.1 permits **four** orbits and the winner there uses **two**. Nothing in range has five orbits; the certified_K distribution and part counts here are v4 figures awaiting the rebuild;
- what *is* tight is Part G.4 on the individual axes, and tight on a single row. Under the v2 table the instance was n = 575 with witness `23x25` at δ = 0.041812: the fusion bound 1/δ = 23.9 met by F = 23, and the block-size bound δn = 24.0 by c = 25 — both within one unit simultaneously. ⟦PENDING-REBUILD⟧ That n is won by `4x103 + 1x163*` at δ = 0.080006 in the v4 table, so the instance is pending recomputational and the current one is below. **Against v4 the tightest row is n = 1994 = `2x997`**, where both G.4 ratios sit at 1.001 and the feasibility criterion Σ√Fᵢ ≤ 1/√δ has slack 0.0004. That the same row saturates all three is structural rather than a coincidence: a single fused class n = F·c has δ = (c−1)/(Fc−1), so c = δn, F = 1/δ and Σ√Fᵢ = 1/√δ all hold to O(1/n) at once, and the three bounds are one bound read on three axes;
- over the contiguous range the minimum is **⟦PENDING-REBUILD⟧** **tentatively 0.048039 at n = 2183** (`6x251 + 1x677*`; v4's minimum 0.045742 at n = 1817 rises to ≥ 0.0594 under the corrected caps), the maximum 0.499807 at n = 2594 (Theorem 2.1's family), and the median 0.1994 (v4; will rise). **A falling floor is what makes a larger s-branch reachable**, so it is the figure to recheck after any extension — and it moves in both directions, a missing shape depressing it and a repair lifting it;
- **Theorem settles 1,837 of the 2,186 values (84.0%) outright**, with no search needed; per s-branch it is 2,204 of 2,553 (86.3%). The residue is a single class, **349 branches on E.3(ii)'s open global promotion** — the s = 4 and s = 5 branches of the v2 figures having gone, since the largest permitted s over v4 is 3. The Mersenne branch of Theorem E.1 never binds: no n in range has Cap(a) ≥ B(n) for any applicable exponent. Only Cap(2) = 6, Cap(3) = 21, Cap(5) = 155 and Cap(7) = 1143 arise, with tightest margins B/Cap = 1.43 at n = 15, 1.63 at n = 63 and 1.90 at n = 20. So the entire residual difficulty is low density, not the Mersenne coincidence.

Winning configuration shapes, over the contiguous range **⟦PENDING-REBUILD⟧** (v4 counts — 289 rows are known low and the S4 row in particular reverts, so recount after the rebuild): **900** use one p-characteristic part with one foreign prime (S3); **777** a single class, fused or not (S1/S2); **493** a fused class with a foreign prime (S5 and S7 at every F); **16** two p-characteristic parts with one foreign prime (S4); and **none** uses two foreign primes. The last is worth watching rather than dismissing: the branch-and-bound of `arithmetic-of-density.md` §5 found a second instance at **n = 3059** = 1511\* + 907\* + 641, and it is the global density minimum. So the two-foreign shape is not merely rare — it is concentrated at the extremes, appearing where nothing else is available. These are the same five shapes reported at n ≤ 1306 (553 / 542 / 127 / 46 / 1) — **no sixth shape appears** in the extended range, which is the more informative fact. The last two are the ones a hand-built family menu is most likely to miss, since they combine features that are natural to treat separately. (The only known two-foreign instance is the worklist value n = 3059, beyond the contiguous range and the global density minimum. Candidates inside the range are exceeded by fused readings — n = 1175 = 641\* + 277 + 257\* by `1x619* + 4x139`, see the three-part box below.)

Against the family menu of `mu_fast.py` (measured over the range its table covers, n ≤ 1540) the enumeration is **higher at 173 values and never lower**, and the shortfalls have exactly two shapes — 127 "two p-parts plus a foreign prime" and 46 "fused class plus a foreign prime" — with no third type appearing at larger n.

**The three-part winners have one shape, without exception.** **⟦PENDING-REBUILD⟧** (v4 census: 15 of these 16 rows are exceeded by entangled two-class readings — all but n = 1529 — so expect this shape class to nearly empty on rebuild.) All **16** v4 winners using three parts are **"one foreign prime plus two unfused p-characteristic parts of equal block size"** — n = 247, 285, 437, 777, 1377, 1417, 1529, 1921, 1927, 1935, 1969, 2047, 2241, 2321, 2345, 2369. The pre-repair table had three exceptions and all three have gone: its unique two-foreign winner at n = 1175 is now the fused `1x619* + 4x139`, and the unequal-power winners n = 551 and n = 2015 are now `3x128 + 1x167*` and `8x191 + 1x487*`. **No winner in the table now has matching classes of two different block sizes at any p, and none has two foreign primes** — the fused rung absorbs both families, which is why the three-part count fell from 258 to 16. They occur precisely where n admits no good two-part decomposition. Reduction (R1)'s **top-layer** merge cannot fuse the equal pair — F₁ + F₂ = 2 is not a power of the relevant q, which in these rows is 3, 5, 41, 53, 83, 89, 163, 173, 179, 233 — but the **cyclic-layer** merge is available at exactly these odd q, and it is what exceeds 15 of the 16 (the entangled readings above). The shape class survives only where no merge of either kind reaches it. Why a *fourth* part never wins is visible in the same shape: the binding term is C(c,2), increasing in c, and a further part of the same kind reduces the budget per part, so three equal p-parts plus a foreign strictly loses to two. Making that a theorem needs the freed points to be reabsorbable at the same n — the Diophantine step of Part J item 1.

> **The three-part count and the low-density tail are the two figures here that move most, and they move together.** Both are downstream of the fused rungs: a cyclic-layer-fused two-part configuration absorbs what would otherwise be a three-part winner and lifts the value's density at the same time, so a shape-space change shows up in both at once. Recount them together, and treat a large three-part count or a wide δ ≤ 1/16 tail as a signal that some fused shape is not being reached rather than as a fact about μ.

**The low-density tail, where minimality is still open.** Corollary F.3 gives k ≤ 3 wherever δ > 1/16, so the open content of Part J item 1 is confined to the tail below that threshold. **⟦PENDING-REBUILD⟧** *The tail's size, membership and per-member part counts are table outputs — `check_doc_figures.py --pass scope` reports the current list — and no winner in it has approached the permitted part-count ceiling at any frontier so far.* *(A split like this must sum to the size of the set being split; one that does not is a figure an extension has left behind, and the arithmetic is the cheapest tell.)*

**Three-part winners beat two-part configurations by wide margins.** Over a sample of 23 three-part winners spread across the range, the ratio B₃/B₂ — the winner against the best configuration of at most two parts at the same n — has **minimum 1.040, median 1.688, mean 1.925 and maximum 4.857**, with 7 of 23 at least 2. The extremes are informative: n = 777 = 263\* + 257 + 257 at ratio 4.857, where the Fermat prime 257's full C₂₅₆ twist gives 32,896 against a best two-part value of 6,773; and n = 1989 = 701 + 701 + 587\* at 4.192. Three-part winners are therefore not marginal improvements on two-part ones, which is what rules out the perturbation route to k ≤ 3 (Part J item 1).

**The part count is a fact about optima, not about tie-breaking.** `mu_enumerate_v3.py` records a witness on a tie only when none exists yet, so the *reported* part count is not canonical and "max 3 parts" could have been an artefact. It is not. Asking directly whether any configuration with **exactly** k parts attains B(n) — pruned at target B, so only configurations reaching B survive — gives, at every value tested (the three-part-winner values 247, 255, 273, 285, 323, 345, 357, 377, 425, 429, 437, 465, 575 and a further sweep through 493–633): B is attained at exactly **one** part count, and **no 4- or 5-part configuration reaches it**. There are no cross-part-count ties.

**Independent validation of Lemmas B and C.** These checks were made against the notes' construction tables and the GAP battery; they are recorded here because they test the classification rather than the search.

Against every two-block witness in `mu_table_full.csv`: of 5,025 such rows, the 3,316 whose foreign block attains full capacity satisfy **Lemma B without exception** (3,302 of shape 2qᵉ, 14 of shape qᵉ), and **no witness carries a twist–foreign share** — gcd(d, r) = 1 at every one of the 5,025 — which is what Corollary C′'s domination predicts of optima. (Read as domination, not admissibility: shares *are* admissible, per the witnesses in Part D; they are merely never optimal.) Lemma B also predicts a density split among two-block witnesses — among rows clearing the 1/12 diagnostic threshold, 73.1% have r − 1 ∈ {qᵉ, 2qᵉ}; among those below, 9.9%.

That check is partly circular, since the witnesses come from our own constructions. The GAP battery at n = 10 is not: those 967 Oliver groups were enumerated exhaustively with no reference to the lemmas. Extracting vertex orbits by colour refinement and locating orbitals that induce a complete graph on their support gives **1,061 full-capacity orbits across 728 groups, of sizes 2, 3, 4, 5, 7, 8, 9 — every one a prime power, with no exceptions**; **no group** has two proper-prime-power full-capacity orbits of different primes, confirming the uniqueness of p; and of the 88 prime-sized full-capacity orbits inside groups with a genuine top prime q, **all 88** satisfy s − 1 ∈ {qᵉ, 2qᵉ}.

**Independent confirmation against exhaustive group enumeration.** Agreement with constructions drawn from the same families is partly circular; the only non-circular check is against an exhaustive enumeration of Oliver groups obtained without reference to any of this. Two exist, and both are **tight** rather than merely consistent.

| n | groups enumerated | max m\* over all of them | B(n) | attaining |
|---|---|---|---|---|
| 10 | 967 | 20 | 20 | 8 groups, all with orbitals {20, 25}; exemplar T(10,17), order 200 |
| 12 | 7,115 | 18 | 18 | 8 groups, all with orbitals {18, 48} |

The n = 12 row has been re-derived directly from `groups_out.txt`: the file holds exactly 7,115 groups (295 trivial-top, 657 at q = 2, 67 at q = 3, 6,096 p-groups), the maximum m\* is 18, and exactly eight attain it — `T(12,85)`, `T(12,164)`, `T(12,166)`, `T(12,207)`, `T(12,228)`, `T(12,229)`, `T(12,265)` and `T(4,4)≀T(3,1)`, orders 144 to 5184 — all with orbital sizes {18, 48} and all sharing a single orbital partition across three distinct tags. (A count of 8,819 for this file, which has been quoted, is wrong.) Their common orbital data is exactly what Theorem 3.1's value formula predicts for n = 3·4: three fused blocks of 4 with the full twist give 3·C(4,2) = 18, and the cross class, with coefficient 3 because **F = 3 is odd**, gives 3·4² = 48. (Here q = 3 as well, so reading the coefficient off q would give the same answer at this n; the box "The parity is F's, not q's" in Part E records why it does not in general.) So the exhaustive optimum *is* the predicted construction, orbital sizes included. This does not establish exhaustiveness in general — both checks sit at small n, where few configurations are available — but it is the strongest form of evidence the framework admits.

**How odd n are actually served, and the correct scope of the older diagnosis.** One diagnosis of the odd-n shortfall runs by arguing that the strong two-block family needs exactly one even block, that the block must be the p-characteristic one since the other has prime degree and 2 is the only even prime, and hence that odd n reach the strong family only through n = 2^a + r with r prime — about log₂n candidate splits against ~n/2 for even n. The reasoning is sound about that *family*, and it is the binding constraint for odd n with **ω(n) ≥ 3 that use two parts** — which is precisely the weak tail. What it does not describe is how most odd n are served, because most *strong* odd n have ω(n) = 2 and use a single fused class, where no additive representation enters at all.

Of the 679 odd values in the table, 548 reach density 1/12 or better. Among those:

| route | count |
|---|---|
| **no even part at all** | **461** |
| one even part, a 2-power p-characteristic block (the 2^a + r shape) | 53 |
| one even part, odd block size with even fusion count | 34 |

and by part count, 339 use a **single fused class**, 87 two parts, 122 three parts. So the dominant route for a strong odd n is the single fused class of §2.1 of `arithmetic-of-density.md` with both factors odd — n = k·m with k a q-power and m a prime power — and after that the three-part configurations.

Restricting to the values where the fused family is *unavailable* recovers the older claim exactly. Of the **150 odd values with ω(n) ≥ 3**, 97 use a three-part configuration with no even part (n = 2c + r, all odd), and 53 use two parts, of which 28 have the 2-power p-characteristic block the argument predicts. Their median density is 0.0957, sitting at the three-part cap of 1/9 rather than the two-part 1/4.

What limits odd n is therefore a pair of **caps**, not a shortage of representations. The multiplicative fused family gives density 1/F, and odd n has F ≥ 3 where even n has F = 2; the balanced additive route for odd n is three parts, capped at 1/9, rather than two, capped at 1/4. Both engines and the Bateman–Horn conditions behind the additive one are set out in `arithmetic-of-density.md`.

**The hand family menu against B₀, above the computed range.** These figures compare `mu_fast.py`'s menu of constructions against the crude ceiling B₀ of Part C.2, and are the only measurements in this framework still taken against B₀ rather than B — which is why they look worse than they are. Over the 6,401 values n ≤ 10⁴ the menu leaves gapped against B₀, the median ratio menu/B₀ is 0.533, the worst cases being the familiar arithmetically weak odd n: n = 1425 at 10,025 against 171,991 (ratio 0.058), then 4245, 3393, 5457, 4059. **⟦PENDING-REBUILD⟧** *These ratios are measured against B₀ over a range where B is not computed; at the values where B is known, much of the apparent gap is B₀'s own slack rather than the menu's shortfall, as the worked contrast in C.2 shows.* Below n = 2298 there is no gap at all, since B is computed exactly and attained.

**Foreign-block efficiency.** For a foreign prime r under top prime q the usable twist is t = (q-part of r−1), and the intra-orbital is r·|±δT|/2 against a maximum of C(r,2). So

> **eff(r, q) = (t if t is even, else 2t)/(r − 1)**, with **eff = 1 exactly when r − 1 = qᵉ or 2qᵉ** — precisely the case in which Part B's restriction of foreign twists to q-powers costs nothing.

Fermat primes achieve this at q = 2, safe primes with t = q odd and 2t = r−1, and the general family is r = 2qᵉ + 1 (so 163 = 2·3⁴+1 and 251 = 2·5³+1 qualify without being either). **The Fermat case is the one that defeats the ℓ = 2 obstruction** of `arithmetic-of-density.md` §3.3: it has r − 1 a pure 2-power, so 4 | r − 1 yet eff = 1, and it is why 20 winners of shape `2×c + 257*` sit in classes 3 and 7 mod 12 at densities up to 0.16138 against those classes' generic cap of 0.08579. Across winning configurations about 77% of the foreign blocks used have efficiency 1, the commonest being 487, 257, 347 and 383. (The notes' glossary quotes 74.8% with a different top-five; that figure is over n < 685 and this one over the full range — same measurement, different windows.) The Fermat prime 257 is frequently the *binding* orbital, its full C₂₅₆ twist giving 257·128 = 32,896.

## Part J. Open items

**J0. Re-check the lemma inventory whenever the shape space moves.** B, B′, C, D1 and D2 each quantify over the space of admissible configurations, so a change to that space means each wants re-reading for whether its hypotheses still cover every case. D2 is the standing illustration of why: it is the one whose hypotheses the shape space outgrew, and it now holds as a domination statement rather than an exclusion. This is cheap and is the step most easily skipped.

**J0a. The stabiliser question — the semilinear half is settled, the rest is not.** The framework assumes a matching block's twist lies in the multiplicative group of the field. The stabiliser of a primitive affine group of degree p^a may be any irreducible subgroup of GL(a, p), which is larger. This cannot inflate B_safe — the safe scoring already credits C(c,2) — but it is an unstated assumption bearing on attainment.

> **The ΓL(1) sub-case cannot change any score, and this is provable rather than measured.** Suppose the twist group is enlarged from C_d to C_d ⋊ C_m by adjoining Galois elements. Enlarging a group can only fuse orbitals, never split them, so no term of the value formula can *fall*; and the intra term does not rise either, because the 2-set **{0, 1} ⊆ 𝔽_p is fixed pointwise by every Galois element** and lies in a minimum-size orbital — its setwise stabiliser in the affine group has order 2, realised by x ↦ 1 − x when 2 | d, or by the translation x ↦ x + 1 in characteristic 2. Every other term of the formula is a product of part sizes or a cross term already pooled into one class, so none of them is the minimum's binding term either. Hence **min orbital is unchanged, and B_safe, B_refined and every measured figure are untouched by whether the twist is read in GL(1, c) or ΓL(1, c).**
>
> *This is a fact about k = 2 specifically.* The escape is a k-subset of the fixed field 𝔽_p, which exists exactly when p ≥ k — always at k = 2, and failing in characteristic 2 at k = 3, where the semilinear reading genuinely raises the minimum by a factor of a on suitable blocks. See `three-uniform-note.md` §2.2.2. So the dormancy of this item at k = 2 is a consequence of p ≥ k, not evidence that the assumption is harmless in general.

**What remains of J0a** is the genuinely larger case: an irreducible subgroup of GL(a, p) that is *not* semilinear. That is not covered by the argument above and is still an unstated assumption bearing on attainment. It should be either justified or scoped.

*What is established, and where. Realisability: Part E. The relation between B_refined, B_safe and μ, Theorem E.1, and the collapse certificate: Part E′. The search bounds and why counting cannot sharpen them further: Part F. All measurements: Part I. This section lists only what remains.*

1. **Minimality: k ≤ 3 in the low-density tail.** Corollary F.3 makes this free wherever δ > 1/16 — 99.2% of the computed table — so what is open is the tail below that threshold, measured in Part I over the low-density tail (**⟦PENDING-REBUILD⟧**). (How much of n beyond the computed range lies below 1/16 is itself governed by the open density questions, so this is a per-n statement, not a global one.)

   Three findings constrain any proof there, all recorded elsewhere: Proposition F.2 shows counting saturates at four parts, so the argument must be arithmetic; the wide B₃/B₂ margins of Part I rule out a perturbation or small-domination route, since a proof must instead *produce* a strong ≤3-part decomposition at the given n; and the configuration 551 = 256 + 167\* + 128 forbids assuming the two p-parts are equal, since distinct powers of one prime are admissible together — §6.2 of `arithmetic-of-density.md` shows they need no coprimality between their twists, Part E's diagonal generator carrying both. (That configuration is admissible rather than optimal at its n, which is all the argument uses; whether distinct powers ever *win* is open, and `validate_table.py --baseline` is where a winning instance would show up.) The supply question that remains has the same shifted-prime character as the density questions, which is why this item and item 2 now sit in the same regime.

   Of the three older sub-narrowings, the first two — at most two p-characteristic classes, at most two foreign primes — follow from k ≤ 3; the third, **at most one fused class**, does not (two fused classes are only two parts) and is a separate open statement. Each remains individually worth proving, since each removes a different search axis regardless of density.

2. **The collapse for odd n at low density: the global promotion.** Part E′ closes every branch but one *within the δ > 1/16 regime* — s = 3 outright (E.4), the s = 2 repunit family by absolute cap (E.3(iii)), s = 1 by Cap(a) (E.1), and everything at δ > 1/9 (E.1); below 1/25 the s = 4 branch opens (1/36 for s = 5) with no theorem either — the sharp thresholds, per item 2a below; between 1/16 and 1/25 the reduction stays complete at s ≤ 3 — and E″ certifies the collapse per n from lower bounds alone, far beyond the table (**⟦PENDING-REBUILD⟧** for the coverage count). The surviving branches are **s = 2 with c a safe prime** — within which E.3(ii) resolves the bare pair outright, leaving only the case **with a leftover**. Wherever the density floor keeps the largest permitted s at 3, the s = 4 and s = 5 branches — which have no theorem at all — are not reachable.

   The obstruction to *re-reading* at L = c is sharp — it would require two equal foreign parts, which admissibility forbids — but the **certificate** no longer stalls there: the leftover twist cap of E″ closes the shape by bounding the leftover's intra term instead of re-typing it. What remains open is only the **global** promotion of E.3(ii) to a theorem over all n, which is a statement about unbounded n rather than about any concrete value.

   What else is known: cases (α)–(γ) of E″ prove no *structural* argument can do it, since within a fallback configuration's own partition the fallback reading is forced, so any proof must compare across partitions of n where arithmetic supply enters. The Cunningham chain 719 → 1439 → 2879 is where the leftover cases bite hardest, and the **q-pinning mechanism** that kills those (r − 1 = 2q pins the top prime, forcing every leftover foreign part into r_j ≡ 1 mod q) is the likely ingredient of an unconditional argument.

   The alternative route — raise the odd-n guarantee above 1/9 and bring odd n under Theorem E.1 wholesale — is **closed**. It would need a constant above 1/9 bounding μ(n)/C(n,2) from below on odd n, and no such constant exists: a substantial and **growing** share of the odd n in the computed table already fall below 1/9. **⟦PENDING-REBUILD⟧** *The share is a table output; `arithmetic-of-density.md` §7 carries the same statement and both are requoted from the rerun. The trend, not the level, is what closes the route.* So the direct promotion is the only path.

   Two things to keep in view. The per-n frontier extends cheaply, since E″'s lower-bound pass dominates the cost and is cached. And "almost all n" is the wrong target — the density thresholds of Part I show δ ≥ 1/4 at only 18.5% of computed values, so density-1/4 is a minority property; proving thinness of the exceptional set would land on the same shifted-prime condition, a Hardy–Littlewood-type statement of the tier this framework is trying to avoid depending on.

2a. **Bound the s = 4 and s = 5 branches — which no longer arise in range.** Under the corrected shape space **no computed value falls below 1/25**, which is precisely the threshold at which s = 4 would open: the two in the contiguous range that did have lifted (n = 2291 to 0.066767, n = 2303 to 0.059833), and n = 3059 and 3239 lie beyond the frontier. The certificate accordingly reports **largest permitted s = 3** over the whole table, so the branch is empty in range rather than merely cleared by search. What follows is why it would still want a theorem if the floor fell. Note that the *threshold* for s = 4 to become reachable at all is **δ ≤ 1/25**, not δ ≤ 1/16: s ≤ 1/√δ − 1 gives s ≤ 3 throughout δ > 1/25. That is exactly the threshold the certificate reports against, so "permitted by the threshold" and "actually reported" agree, and the 18-of-2,186 tail below 1/16 (Part I) is the k ≤ 3 question of item 1 rather than this one — the two ladders are offset by one (Corollary F.3). Neither branch is thin enough for an E.4-style collapse — c − 1 = 4r and c − 1 = 5r carry no parity or congruence forcing — so an absolute cap would have to come from the foreign block's twist, as in E.1 and E.3(iii). The search clears both at every computed n, so nothing is unproved; the gap is theorem-side and widens as the floor falls.

3. **More non-circular confirmation.** The two exhaustive comparisons (Part I) both sit at small degree, where few configurations are available, so they cannot establish exhaustiveness in general. A third degree would be worth more per unit of compute than any extension of the numerical range — but exhaustive enumeration of Oliver groups is only feasible at small degrees, so the supply is short.

   *Status of the structural steps, since they are what a third degree would test.* **B′ is proved**, with two gaps in the sketch filled — the socle step, which does not follow from primitivity alone and needs irreducibility plus C_G(V) = V, and the degenerate branch π_O(Γ₁) = 1 — and checked in detail by a second reader. **Lemma C is proved at every a**, in its corrected form: its old gcd = 1 statement is false — shares occur, at prime and prime-power blocks alike — and what holds is the coupling, with Corollary C′ supplying the exclusion by domination. B_safe does not use it either way, so the exposure was always to attainment. **The q-power block count is false**, which is the pitfall in G.2. The lesson is that compact structural steps in this framework have a poor track record and every one of them repays being written out; the reading is worth continuing across the parts that have not had it.

4. **The enumerator's pruning is conservative in the right direction** throughout, and nothing in it can inflate B(n) — established by a full read plus a separately written naive enumerator (`brute.py`), which covers the corrected shape space and the tightened SAFE cap. It agrees at **every one of the 142 values in `brute.jsonl`**, running contiguously over n ≤ 110 and then spot-checking upward — including **n = 198, 200, 247, 285 and 308**. Agreement at a value whose winner has a **cyclic-layer block count** is the kind worth quoting, since it exercises exactly the shapes a q-power-only enumeration cannot see rather than only the small n where few configurations exist. Note what the check does and does not test: it tests the *pruning*, because `brute.py` prunes nothing, and it cannot test a convention the two programs share.

5. **Extending the numerical range.** The contiguous table reaches n = 2600 and extends at about n^2.9 per value; see Part H for projections. This extends the certificate's per-n coverage and tests the implementation, but does not test the classification, whose consequences do not vary with n. Note that two cheaper computations already reach much further and are the better use of compute: `wide_cert.py` certifies the collapse to n = 10⁵ from lower bounds, and the branch-and-bound of `arithmetic-of-density.md` §5 settles the global density minimum over all n ≤ 10⁶.

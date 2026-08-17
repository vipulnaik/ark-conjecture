# Plan: rewriting `arithmetic-of-density.md` §3 after the entangled-generator correction

*A plan, not a rewrite. Every edit below is stated concretely enough to execute without further decisions, except where a decision is explicitly asked for (§D). Written 2026-08-17 against `arithmetic-of-density.md` as shipped, `mu_table_safe_v5_code_v3.csv` at 806 rows (n ≤ 1000), and `entangled-generator-finding.md`.*

---

## A. The one-sentence diagnosis

§3.2.3 states a **cost**: a cyclic-layer fusion forces the twist to the odd part of c − 1, so v₂(c − 1) prices the fused rung and pins c mod 8. The entangled-generator construction refutes the forcing — z^F is the full twist at any F_mid, because the block-permutation image is a *quotient* of the cyclic layer, not a subgroup — so the cost is identically zero and the congruence on c is vacated.

What replaces it is not silence. c mod 4 becomes a **free parameter that steers the foreign residue**:

> At F = 2, 2c ≡ 2 or 6 (mod 8) according to c mod 4, so r = n − 2c reaches **two** residues mod 8 where the old law reached one. At F = 4, 4c ≡ 4 (mod 8) for every odd c, so F = 4 steers **nothing**.

That asymmetry is the whole mechanism of the correction's effect on the ceiling table, and it is why 7, 15 mod 24 rose to 1/8 while 11, 23 did not move. The two F = 2 options differ by 4 mod 8 and so agree mod 4, which means the freeing can convert r ≡ 1 (mod 8) into r ≡ 5 (mod 8) — buying η = 1/2 — but can never produce an r ≡ 3 (mod 4), so it never buys η = 1 or η = 1/3 where those were unavailable. Hence: the classes needing η = 1/2 gained; the classes already at η = 1 or stuck at η = 1/3 did not.

**The rewrite is therefore a demotion, not a deletion: a two-sided law (c pays, r pays) becomes one-sided (only r pays, and c chooses which r).** The mod-24 keying survives untouched, because it was always driven by the foreign block's r − 1.

---

## B. Inventory: every affected passage in §3

Line numbers are against the shipped `arithmetic-of-density.md`. **R** = refuted content, must change. **S** = survives, but its framing or its supporting statistics change. **C** = clean, no edit.

| Site | Line | Class | What happens |
|---|---|---|---|
| §3.2.2 "Three readings" — the two layer-assignment boxes | 170–174 | **R** | The S7-at-F=2 box says "the twist must be coprime to 2: **d is the odd part of c − 1**". This is the refuted claim in its primary statement. Rewrite: d = c − 1 at either fusion site; what distinguishes the two readings is only the constraint on q (free vs forced to 2). |
| §3.2.2 "The gotcha" box | 178 | **S** | The lesson ("check which layer is being assumed whenever a congruence on c appears") **survives and is vindicated** — but it now under-reads its own warning. Upgrade: the congruence is spurious at *both* layers, and the gotcha's own diagnosis stopped one step short. This box is the best place in the document to record the incident. |
| §3.2.3 QR/Paley material: Euler's criterion, ±T = 𝔽_c^×, Paley reading, the c = 7/11/19/23/83 verifications | 182–188 | **C** | Correct and unaffected. It concerns orb(c, d) = cd vs cd/2, which stands. Keep verbatim; only its *placement and framing* are in question (see §D). |
| §3.2.3 "And that is what frees a factor of 2 for the block swap" | 190 | **R** | The refuted paragraph, in full. Delete; replace with the steering statement of §A. |
| §3.2.3 char-2 parenthetical | 192 | **C** | Correct (`char2` flag). Keep. |
| §3.2.3 "The c mod 8 law governs the cyclic-layer rung only" + 4-row table | 194–200 | **R** | The table's arithmetic is right *as a statement about a cut twist* and wrong as a statement about fusion. Replace with a table of what the four c mod 8 classes now cost (answer: nothing) and where the old arithmetic still applies (Lemma C's strip). |
| §3.2.4 worked instance **n = 273** | 206 | **C** | Survives intact. v3 confirms 5671 with the same witness `p=83 q=53: 2x83 + 1x107*`, and the three-reading scores are unchanged (S4 3403, S7f2 5671, S5 214) because c = 83 ≡ 3 (mod 8) never paid a cut. |
| §3.2.4 worked instance **n = 247** | 208 | **R** | Inverts qualitatively. Prose says "cyclic fusion is actively *harmful* — 1314 against the unfused 2628 — because 8 \| c − 1 cuts the twist from 72 to 9". No cut now: recomputed, S4 = S7f2 = **2525** (exact tie, the foreign term binding either way), and the row's actual v3 winner is a *different shape entirely* — `4x41 + 1x83*`, 3280, up from v4's 2525. Both the lesson and the row must be replaced. |
| §3.2.4 worked instance **n = 531** | 210 | **S** | Row survives (v3 confirms 18632, same witness; S7f2 still does not exist because r − 1 = 2⁸ has no odd prime factor — a *supply* fact, EG-independent). But its closing punchline — "precisely what the c mod 8 law would forbid if that law applied to top-layer fusion" — loses its force, since the law now forbids nothing anywhere. Rewrite the punchline. |
| §3.2.4 "Reading the losing entries" | 212 | **R** | Contains the n = 247 harm narrative. Rewrite with the tie. |
| §3.2.4 F-parity structural note + c = 7 orbit verification {42, 49} | 214–216 | **C** | Correct and EG-independent (it is the within-class cross coefficient, keyed on F's parity). Keep. Note the verification uses "a diagonal twist of order 3 (the odd part of c − 1)" — still a valid group, just no longer the *forced* one; one clause of framing. |
| §3.2.4 closing "bold values are what v4 records" | 218 | **S** | Repoint to the v3 file, and n = 247's bold value changes. |
| §3.2.5 split table: "**136 of 150 at c ≡ 3 (mod 4)**; 9 at the tie; 5 at p = 2" | 224 | **R** | **The section's empirical centrepiece inverts.** Recomputed from v5 (806 rows, n ≤ 1000): of 80 cyclic-layer winners, c mod 8 = {1: 14, 3: 23, 5: 23, 7: 17}, plus 3 at p = 2 — **37 at c ≡ 1 (mod 4), 46%**, against 14/150 = 9% before. The congruence has not weakened; it is gone. |
| §3.2.5 "So S4 and the cyclic-layer fused rung are co-carriers… each verdict holding on a quarter of all c" | 228 | **R** | "Each verdict holding on a quarter of all c" is the retired law's arithmetic. The *headline* — "the split is by q rather than by c" — **survives and strengthens**, since c now carries no signal at all. |
| §3.2.6 η definition, Lemma B′ reference, the η = 1/2 and 1/3 closed forms | 235–241 | **C** | Untouched. η lives on the foreign block. The 0.08579 and 0.07180 values are F = 2 unfused-rung caps and are correct as stated. |
| §3.3.4 "Rung B … needs the twist on the c-blocks to be odd, i.e. **c ≡ 3 (mod 4)**" | 301 | **R** | Same refuted premise, and here it is load-bearing for the mod-24 keying. Rewrite: the chain from η = 1/6 to r ≡ 5 (mod 8) survives; what changes is that 2c ≡ 6 (mod 8) is no longer forced, so **both** 2c ≡ 2 and 6 are available and the reachability condition on n loosens. The "measured 100% or 0% with no boundary cases over 15,000 values per residue" measurement is of the *old* condition and needs rerunning. |
| §3.3.4 rung-B′ box (top-layer, q = 2, η = 1/u, u ≤ 9 table) | 303–307 | **C** | Untouched — top-layer fusion never paid a cyclic-layer cut, which was §3.2.2's whole point. The cap₂(1/u) table and the O(n/log n) supply counting stand. |
| §3.3.4a "**The 2-adic condition.** Take c ≡ 3 (mod 4) — required for even F, since the fusion count occupies the prime 2 in the cyclic layer and the twist is cut to the odd part" | 315 | **R** | The refuted premise, doing real derivational work: it is what pins F·c mod 8. Rewrite per §A — and note the outcome is **better than a repair**, because at F = 4 the conclusion is *unchanged* (4c ≡ 4 mod 8 for all odd c, no premise needed), while at F = 2 an extra residue opens. |
| §3.3.4a η₂ = 2^(1−v) rule and the v-from-r-mod-8 reading | 317 | **C** | Correct and now the *primary* statement rather than a consequence. This is what `validate_table_v3.py`'s new `c_eta_reach` check tests. |
| §3.3.4a 3-adic condition | 319–323 | **C** | Untouched — it is about c mod 3 and F mod 3, and the entangled correction concerns the prime 2 in the cyclic layer. |
| §3.3.4a mod-16 box ("4c ≡ 12 (mod 16) is again forced") | 325 | **S** | Same premise. With c mod 4 free, 4c ≡ 4 or 12 (mod 16), so r ≡ n − 4 or n − 12 (mod 16) and the v = 3 / v = 4 split at classes 5, 13, 21 gains an option. The box's own conclusion — "none of them is a class whose optimum takes F = 4" — makes this **harmless**, and the final sentence (the binding cells 7, 11, 15, 23 have v = 1 pinned) still holds at 11, 23. Needs re-derivation at 7, 15 under their new F = 2 reading. |
| §3.3.5 ceiling table, 7/15 and 11/23 rows | 332–361 | **S** | Already carries ⟦EG-TENTATIVE⟧ marks from the earlier pass. The §3 rewrite should leave these alone until the rekey is independently re-derived — see §E ordering. |
| §3.5.3 Hypothesis (H), clause 4: "at F ≥ 2, **c ≡ 3 (mod 4)**, so that the matching class keeps its full 2-homogeneity … and its intra term stays at F·x² (§3.2.3)" | 463 | **R** | A refuted clause inside the stated hypothesis. Already flagged in the earlier pass; the §3 rewrite is where it gets its final wording. The clause should be **deleted, not weakened** — the intra term stays at F·x² unconditionally now. Renumber the remaining clauses and check §3.5.4 ("What the four clauses rest on") for the orphaned entry. |
| §3.8 empirical density counts | 588+ | **S** | Independent of §3.2/3.3's mechanism, but the runs were auto-centred at the `XSTAR_BY_RESIDUE` values, which are the **rung-B balance points, not §3.3.5's x\*** (the `count_check.py` defect flagged earlier). Not part of this rewrite; listed so it is not forgotten. |

---

## C. Replacement content, stated concretely

Three passages need genuinely new text rather than deletion. Drafts, to be reviewed here rather than mid-surgery:

**C1. The new §3.2.3 core paragraph** (replacing line 190's "frees a factor of 2"):

> The factor of 2 in c − 1 is *not* needed inside the block at c ≡ 3 (mod 4), by the residue argument above — but nor is it needed for the block swap, and that is the point on which this section was long wrong. A block swap realised as an entangled generator takes z of order F·d acting as a block rotation whose step-multipliers generate 𝔽_c^×; then z^F is the full twist, and the block-permutation image is a *quotient* of the cyclic layer rather than a subgroup of it. So a cyclic-layer fusion costs nothing on the matching side at any c, and no congruence on c is required for the fused rung. What c mod 4 does instead is **steer**: at F = 2, 2c ≡ 2 or 6 (mod 8) according to c mod 4, so r = n − 2c is reachable at two residues mod 8 rather than one. At F = 4 it steers nothing, since 4c ≡ 4 (mod 8) for every odd c. That asymmetry, and not any property of c itself, is what separates the classes.

**C2. The replacement for the four-row c mod 8 table.** Same four rows, reinterpreted — and worth keeping in this shape precisely because the old table was memorable:

| c mod 8 | c − 1 | cost of cyclic-layer fusion | where the old arithmetic still applies |
|---|---|---|---|
| 3, 7 | 2·odd | **none** | — |
| 5 | 4·odd | **none** | Lemma C, if a foreign prime divides c − 1 |
| 1 | 8 \| c−1 | **none** | Lemma C, ditto — and this is where the old law's penalty was largest, hence where its absence is most visible in the table |

with a following sentence: the surviving home of v₂(c − 1) is Lemma C's conjugation strip, which cuts the twist when it shares a prime with a foreign block; the parity of what remains is still governed by v₂(c − 1), so the arithmetic above is a special case inside that regime rather than a general law about fusion.

**C3. The replacement §3.2.4 third instance.** n = 247 no longer illustrates anything about fusion, so either (i) keep n = 247 with the *tie* as the lesson — fusion is free but does not always help, since at c = 73, r = 101 the fused intra rises 2628 → 5256 while the foreign term 2525 binds regardless, so S4 and S7-at-F=2 score identically and the winner is decided elsewhere (and in fact v3's actual winner at this n is neither: `4x41 + 1x83*` at 3280) — or (ii) replace the row with a c ≡ 1 (mod 4) row where fusion now *wins*, which is the more informative choice and directly exhibits the 46% population. **Recommendation: (ii), and use n = 253** (`2x73 + 1x107*`, 5256, c = 73 ≡ 1 mod 8, η = 1 — a row that was 2783 under v4 and is the largest single ratio in the exceedance list at 1.889). It is the cleanest possible exhibit: the old law forbade exactly this configuration.

---

## D. The one decision I am not making unilaterally

**Where the quadratic-residue material goes.** Lines 182–188 (Euler's criterion → ±T = 𝔽_c^× → Paley) are correct, well-written, and no longer support the claim they were written to support. Three options:

1. **Keep in place, retitle §3.2.3** to something like "The orbital halving, and what c mod 4 does and does not buy." Least disruption; the QR material leads, the steering statement follows, the section keeps its slot. Risk: a reader still expects a congruence law from a section positioned here.
2. **Demote to a box inside §3.2.2**, where the two layer readings are introduced, and delete §3.2.3 as a numbered subsection (renumbering 3.2.4–3.2.6). Tightest result; §3.2 becomes "the family, the readings, the instances, the table, the efficiency" with no orphan. Risk: renumbering touches every cross-reference to §3.2.3–3.2.6 across five documents (`aod` internal, `three-uniform-note` §5.6.2, `note-to-framework-bridge`, `solvable-relaxation`, `enumeration-proof`).
3. **Move to §3.3.4a**, where orb(c, d) = cd vs cd/2 is actually consumed by the η derivation. Most logical placement. Risk: §3.2 loses its most vivid passage, and §3.3.4a is already dense.

**My recommendation: option 1.** The renumbering cost of option 2 is real and the cross-document references are exactly the kind of thing that goes stale silently — and after this correction I would rather not spend the error budget on bookkeeping. Option 1 also keeps the QR argument adjacent to the gotcha box, which is where the incident is recorded, so a reader meets the correct mechanism and its cautionary tale together.

---

## E. Ordering, and what must not be written yet

**Do now (independent of the rebuild):** every **R** row in §B whose content is mechanism rather than measurement — §3.2.2's boxes, §3.2.3, §3.2.4's n = 247 replacement and n = 531 punchline, §3.3.4's and §3.3.4a's premises, §3.5.3 clause 4. These follow from the finding itself and will not change when the table finishes.

**Do after the full v3 run:** every statistic. §3.2.5's table (the 806-row figures above are honest but provisional — quote them as such or wait), §3.2.4's bold values, §3.3.4's "100% or 0% over 15,000 values" measurement, and any per-shape count. The `check_doc_figures.py` pass against the completed CSV is the mechanism.

**Do not touch until the mod-24 rekey is independently re-derived:** §3.3.5's table and the ⟦EG-TENTATIVE⟧ marks on the 7/15 rows. My derivation of 7, 15 → 1/8 has now been done twice by the same route (hand, then the free-c re-derivation of all twelve odd classes, which reproduced exactly 7 and 15 moving and nothing else). Agreeing with itself is not independent confirmation. The re-derivation should ideally come from the other direction — a witness at n ≡ 7 or 15 (mod 24) exhibiting cap 1/8, or `eta_derive.py` rerun with c mod 4 free.

**Blocked, and not part of this rewrite:** the fb_common condition-(4) repair and the certificate reruns; `count_check.py`'s `XSTAR_BY_RESIDUE` fix and the §3.8 rerun at correct centres.

---

## F. What this rewrite is quietly good news about

Worth a sentence in §3.2.2's gotcha box, because it is the honest reading of the incident. The document already contained the warning that caught this class of error — "whenever a congruence on c appears in an argument about fusion, check which layer is being assumed" — and it was applied correctly to distinguish top-layer from cyclic-layer fusion. What it missed is that the congruence was spurious at *both* layers, because the argument it was auditing ("C₂ must sit somewhere, and a cyclic group has a unique subgroup of each order") assumes the fusion image is a subgroup. The gotcha found the right question one level too shallow. That is a more useful thing to record than a bare correction, and it is the third instance of the same projection-vs-subgroup confusion in this programme (after the n = 308 bug and the SAFE `dmax` strip), which argues for making it a standing check rather than an incident note.

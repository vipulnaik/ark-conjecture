# Session log 16 — a second fresh-eyes pass, the owed checks worked through, and collapsibility shown not to be self-dual

*One sitting, 2026-11-10, in four parts: a critical read of `orbital-evasiveness-notes.md` (oen), `enumeration-proof.md` (ep) and `arithmetic-of-density.md` (aod) against `pending-checks.md`, `literature-findings.md`, the scripts and the outputs, with the fixes it produced; the unfinished and skipped checks from that read; the harder items of `pending-checks.md`; and a cleanup of the notes against `check_doc_figures.py`. Commits 18b8e85, 3374c97, 97b50bd and the one this log ships in. The read put correctness in spirit first and in letter second; wording and structure were out of scope until the last part.*

---

## 1. The read and its fixes (commit 18b8e85)

The line-level list is the commit's diff; what follows is what changed in substance.

- **`brute.py` enumerated the pre-entanglement shape space.** It still required the F_mid block counts to be pairwise coprime to the twists and stripped the twist accordingly. Both are gone: a matching class scores the flat `F * comb(c, 2)` at any F. `outputs/brute.jsonl` was regenerated and agrees with the table at all 142 of its values.
- **n_G is the product of a group's usable top primes**, not a single one (C₇⋊C₃ × D₅ on 7 + 5 points has n_G = 6). The batteries already enforce the lcm; the prose in `small-degree-computation.md` §8.6 and its item 8 now says so.
- **`pending-checks.md` gained a seventh gap-inventory item**: `ladder-completeness.md` Proposition 1 is the only route from the ladder table to B(n) between 10⁵ and 10⁶, and is single-read.
- **A43(2) answered, negatively**: contractible ⇏ K\* contractible, by Lutz's 30-vertex complex A.
- **`check_doc_figures.py`**: invariant I12 (no live pre-entanglement claim about cyclic-layer fusion); the refs pass no longer reads `session-log-N §x` or "his Theorem" as citations of our own results; the witness pass reads comma-grouped n.
- **Two errors in the review's own first report, corrected in the same sitting**: `brute.jsonl` had been called clean on the strength of its row count alone, and "every sub-1/9 odd n lies in classes 5 and 11" was false (780 lie elsewhere).

## 2. Owed and unfinished checks, all clean (commits 3374c97, 97b50bd)

- **`wide_cert.py 100000`, both modes**, with B_lo rebuilt to include the fused rung: 90,299 of 90,299 certified; `--no-theorems` leaves exactly the five bare pairs E.3(ii) resolves (n = 32398, 35098, 62368, 86848, 99160). `settled by theorem:` prints NONE at 10⁵ as at 10⁴, so the mode comparison says nothing about the branch dispatch at any NMAX run so far.
- **R8 battery**: 13/13 `VERDICT: true`; the control (`ARK_WITNESS_FTOP_SPLIT=1`) aborts at n = 78 on `G / G1` normality.
- **`IsOliverTop` against a second implementation** (O^q(G) as the normal closure of the other Sylow subgroups, then a p-by-cyclic test): equal on 1,554 groups of order ≤ 150, on 546 transitive groups of degree ≤ 14, and on the table of marks of S₁₀, where it reproduces `tom10.txt` line by line (1,593 classes, 1,294 Oliver, 1,111 with at most 12 orbitals, 24 transitive) and the tag column of the TOM emission (558 / 532 / 18 / 3).
- **Table witnesses**: all 921,265 rows name prime p and q and parts summing to n.
- **`mu_exact.py` against the ladder table above 10⁵**: 114 values in four windows up to 10⁶, no differences. A spot check on Proposition 1, not the second reading it is owed.
- **Bipartite scans**: `bip_union_scan.g` (16,712 groups), `bip_sylow_check.g` and `bip_halves_sign_check.g` (15,728 groups each), every degree to 46, no failures.
- **Signed sums**: K₃-free 4, 3, 61 and C₄-free −36, 228, 880 at n = 5, 6, 7, by brute force.
- **B(n) of the bipartite count**: period p − 1, the mod-3 and parity laws and p | B(n) for (p − 1) | (n − 2), all n < 700; the class n ≡ 2 (mod 240) to 10⁷, largest least witness 67.
- **Lutz's A**: f-vector (30, 195, 340, 255, 96, 15), ℤ-acyclic without torsion, π₁ = SL(2,5), recomputed from the 21 facets.
- **n = 6 template profiles**: 21 classes, 18 templates, 546 profiles, 2 passing, 20 survivors, 2 Oliver-χ-resistant; those two are ℚ-acyclic with homology at 2 and at 3, so not ℤ-acyclic.
- **oen §7.6, A₅ on the edges of K₅**: every count recomputed from scratch — 3,176 functions, the five rung totals, the six separation counts, the 32 / 8 / 4 split of the 44. `ws_search.py` and `a5_10_oliver.txt`, which that subsection cites, are not in the repository.
- **Sources**: BBKN Theorems 1.3 and 1.4, Shparlinski's Theorem 1 and Corollary 3, Runbo Li's 0.679 (infinitely many primes), Scheidweiler–Triesch's n²/3 − o(n²), all as the notes cite them. Not located: the Bombieri–Vinogradov original, the Elliott–Halberstam exponent of Shparlinski's §5, the survey crediting Santha–Yao.
- **Read line by line and found sound**: ep Part D2 (D1, D2, the non-permuted case, D2q, D2′), with two remarks added to the text; ep E.3–E.4 and the certificate boxes; `fb_common.py`'s eight conditions (T3), where the one finding is that pairwise-distinct foreign primes rest on D2's non-permuted form, which the header now says; `approach-rate-note.md` and `bcp-to-floor.md`, constants and counts recomputed.

## 3. The harder items

### 3.1 A43: collapses dualise, and collapsibility is not self-dual

- **Lemma.** If K ↘ L then L\* ↘ K\*, duals on a common vertex set: removing a free pair σ ⊂ τ from K adds V ∖ τ ⊂ V ∖ σ to the dual, and V ∖ τ is free there because every subset of τ lies in K. So the dual of a collapsible complex is a collapse of a cone — contractible, with no PL argument.
- **Counterexample.** A dunce hat D has no free face; its dual collapses to a vertex. Found at 13 vertices (4,055 elementary collapses, replayed by a checker that tests each step from the definition) and then at **8 vertices** (17 triangles; dual of 205 faces). Eight is least, given Bagchi–Datta's theorem that a ℤ₂-acyclic complex on at most 7 vertices is collapsible, which was taken from `literature-findings.md` §27 and not from the source. D\* is collapsible and evasive.
- `dunce_dual.py`; oen §7.12 and the ladder diagram's footnote; A43 in `pending-checks.md`. Not checked: whether the lemma or the example is in the literature.

### 3.2 A41: the t = 12 stage at n = 10 is feasible

The saved stage had returned UNKNOWN. Re-solved with two workers it is feasible, and three further rounds repaired 15 violated groups: 237 active groups, 7,042 templates, 2,669 in the property. Not every t ≤ 12 group has been passed. The run died on memory twice at 8 GB, when a round rebuilds the model, with one worker as with two. `pending-checks.md` described an `n10_search/` directory and a shipped `libemb.so` that do not exist; the working paths are recorded there.

### 3.3 T2: Part E does not need Frobenius

The construction takes the twist inside the field and claims no primitivity. The field subgroup is semiregular at any order, so the scored orbital is realised at a subfield-order twist too (the shape sweep has such rows, and they match); an imprimitive block changes how the classification files the group, not the group. No winner to 10⁶ is at a subfield-order twist: 0 of 16,733 matching parts of proper prime-power size have a foreign prime dividing c − 1.

### 3.4 T5a: the runner-up, at cap level

Ranking every rung (F, v₂(r − 1), odd cofactor) by cap_F(η): the gap from each odd class's ceiling to the next rung is 0.0706 at classes 1 and 9, 0.0139 at 3 and 7, 0.0170 at 5, 0.0048 at 11. Neither S4 nor S5 is a runner-up in this currency. Whether cap-level gaps are what aod §7 needs was left as a judgement for a human reader.

### 3.5 Left open

A38.3 (a sufficient condition recorded, no proof); A41 beyond the above; A43(4), the collapsibility of Lutz's 60-vertex complex; ep E″ from the q-pinning box to the end of Part E, unread; `small-degree-computation.md` and `small-degree-verification.md`, not read end to end.

## 4. Cleanup against `check_doc_figures.py`

Run over `notes/*.md` the script reported 90 findings. It now reports none, by three routes.

- **Documents sorted by what they are.** Session logs and `archive/` are skipped by charter. A note whose opening carries the ⟦ARCHIVED⟧ banner, or that dates itself in its first lines ("Written 2026-08-16 …"), is checked for structure only. `session-log-15.md` moved to `archive/`.
- **Four excuses in the figures pass, each needing evidence in the line itself**: the sentence names the old frontier; the quantity matched is not the one the sentence is about; the number is a current decade minimum or the runner-up density, beside its n or the word "decade"; the number is not written as a bound on n. A figure scoped "at n ≤ X" is recomputed from the table, not taken on trust. Two invariants lost a false positive each (I2 on "class-5 ceilings", I6 on a sentence that states the sharp constant beside the crude one), and the history pass no longer flags archive banners, rename notices or the hypothetical "an earlier frontier".
- **Text fixed where the finding was real.** `ladder-completeness.md` still licensed reading the ladder "at n > 36,848"; `solvable-relaxation.md` quoted a truncated 0.49999 where the table has 0.499997; `entangled-generator-finding.md`'s status box said the battery had not reached rows it now carries. Some two dozen sentences narrating a document's own drafting were rewritten as statements of fact, across eleven notes.

Controls: a note with a planted stale share, a stale range bound, a bare old minimum, a crude cofactor bound, a wrong constant count and an "earlier draft" sentence draws all six findings, and a planted session log draws none.

## 5. The short note read for airtightness, and the bridge end to end

The Theorem and its proof stand: Proposition 1 re-derived, both constructions built in GAP at n = 12, 17, 40, 45 (and the n = 2m family at m = 9), condition 4 and the diagonal twist each shown necessary by breaking them, the 48 entries of the admissible-d table re-derived, the singular-series bound recomputed, 1/350 valid from n = 29. The discussion around the hypothesis had four statements wrong as written and three that understated it; all are corrected in both versions of the note.

- **Wrong:** "{2, 4, 6, 12} are exactly the even d with prime factors in {2, 3}" (8, 18, 24 qualify); "ℓ | d makes L3 degenerate" (not at ℓ = 2 for odd n with d ≡ 2 mod 4, where the obstruction is the covering mechanism); c − 1 ∈ {0, r, …, 4r} and "five values" (four); "δ(n) = 1/2 − o(1)" for n = 2m (an inequality, and false as an equality at m a power of 2).
- **Understated:** "a disjunction over eight shapes" (at most four per n, exactly one at n ≡ 1, 5, 7, 11 mod 12); "of broadly Goldbach difficulty" (the hypothesis implies binary Goldbach at large even n and Lemoine's form at large odd n); "halve every constant" (the density doubles).
- **Example replaced:** n = 17 = 2·5 + 7 uses d = 2 at a class whose table entry is d = 6 alone; the note now quotes n = 45 = 2·11 + 23.
- **The bridge**, read in full: a wrong balance point (0.155 for 0.183), a wrong parity ("F of n's parity" for the opposite), exactness still credited to the per-n certificate in two places, a stale claim that the note omits the Elliott–Halberstam rung, and the same "one of the eight". `arithmetic-of-density.md` §3.5.2 had the eight-shapes sentence too.
- **Sources:** Shparlinski's §5 on Elliott–Halberstam, Corollary 3 and the positive-proportion form of his hypothesis now read from the full text and agree with the note. Not confirmed: BBKN's remark on 3/2 as a barrier, and that Li's 0.679 comes in positive-proportion form.
- **`bcg15_scan.py`:** (BCG₁/₅) holds at every n with 6179 < n ≤ 120,000; 26 failures below, 22 of them at n ≡ 7 or 11 (mod 12).
- **For the rewrite plan:** the plan's μ\*(n) ≥ n(Q(n) − 1)/2 checks out (built at n = 30, 36, 40), but Q(n) ≥ log n is only asymptotic — it fails first at n = lcm(1..19) = 232,792,560.

## 6. The sparse threshold is larger than μ\*

Asked whether any direction was unmapped, one was, and it could be carried through in the sitting. `threshold-beyond-mu.md` has the statement and proof.

- The k cyclotomic orbitals of a foreign block are isomorphic graphs cycled by a multiplier, so the part of the fixed complex they span is a C_k-invariant complex on k points; where no such proper complex has χ ≡ 1 (mod q), Oliver's congruence fails for every budget up to C(r,2), not only up to the orbital size. `orbital-evasiveness-notes.md` §9.7 had the symmetry and the all-or-none consequence; the full-capacity conclusion and its effect on the constants are new.
- k = 2, …, 11 and 13 qualify outside a finite set of q (exact sets for k ≤ 7); k = 12 does not.
- Under the short note's hypothesis as it stands the evasiveness constant becomes 1/26 in place of 1/350. The ceilings become 1/4 (even n) and 3 − 2√2 (odd n). To n = 4000 the floor of the threshold rises from 0.0462 to 0.0887 and 1,847 of 3,410 rows improve.
- μ\* itself, the table and the classification are untouched: this is about what the congruence proves, not about the invariant.
- Unread by anyone else; `pending-checks.md` A49 lists what is owed.

## 7. The finding restated as a projection of the ladder

The first write-up measured the gain by E(n), the least size of a non-evasive property — tautological at the top and not what had been proved. Restated on Vipul's suggestion, in the terms of `orbital-evasiveness-notes.md` §7: each rung R projects to M\*_R(n), the least largest-member size of a property satisfying R, and μ\*(n) is the projection of Oliver-resistance. `threshold-beyond-mu.md` is rewritten around this; all new quantities carry the star.

- **Already in the notes under other names:** fact 8's n(q(n) − 1)/2 is the projection of vertex-transitive Oliver-resistance, and the implication between the two resistance rungs projects to μ\*(n) ≥ n(q(n) − 1)/2. Bi-resistance projects to μ\*(n) as well: the threshold property is bi-resistant on the window μ\* ≤ B ≤ C(n,2) − 1 − μ\*, which at n = 10 is the measured 20–24.
- **Why the χ rung is different:** a threshold property has χ = 1 − (−1)^B·C(N − 1, B), never 1, so the witness behind the resistance projections fails every χ rung. The max–min μ\*_χ(n) (per group) and the min–max M\*_OCR(n) (one property against all groups) separate, with M\*_OCR(6) = 9 against μ\*(6) = 6. By fact 5 both are determined by the p-by-cyclic groups; by fact 3 non-maximal groups matter.
- **The Proposition is a lower bound on the per-group quantity**, and through it on μ\*_χ and on the nontrivial-top and Oliver-χ projections. The mod-12 column is a lower bound for μ\*_χ, not its asymptotic value: no classification stands behind it.
- **Connections drawn:** §7.3's direction (b), restricting Oliver's tight set of χ values to graph-property complexes; §9.7's isomorphic orbitals; §7.13's two-block loop, which is the case k = 2; §7.9's per-shape conditions, where full-index shapes give no gain and the partial-index case was missing; the n = 10 search as M\*_OCR without an objective.

## 8. Shedding the construction: three levels and one fusion per type

Vipul's abstraction of §6–7, with two corrections to its setup. S_n does not act on a group's orbitals; the permutations N\* that preserve the orbital partition do (§9.7 already names them), and the fixed complex is N\*-invariant. That alone defines a level between non-voidness and the full χ rung: m\*(Γ) ≤ m\*_N(Γ) ≤ m\*_χ(Γ), and μ\* ≤ μ\*_N ≤ μ\*_χ.

- **One fusion per type is the most symmetry can give:** m\*_N(Γ) ≤ m\*_typ(Γ), the smallest total of an N\*-orbit of orbitals, because the full simplex on a type is invariant with χ = 1. The Proposition of §6 is the case of equality — a single good type under the budget. With two types it can fail, by cancellation (−2 at k = 4 with 3 at k = 3) or by mixed faces (a path through a singleton orbital); a single large type can fail too (k = 12).
- **A claim withdrawn in the same sitting:** that μ\*_typ(n), the maximum over groups of the type total, is a useful invariant. The trivial group has one type of total C(n,2), so the maximum is trivial; m\*_typ is a per-group ceiling only, and the mod-12 column stays a lower bound for μ\*_N.
- **Computed at n = 6** (`type_levels6.py`, all 50 Oliver classes): 34 groups with all four quantities equal; 11 where the fusion is fully paid (C₃ × C₃ on 3 + 3 goes from 3 to 6); 6 where the embedding relations of level 2 push m\*_χ above the type total; the trivial group, where cancellation inside its one type gives 6 against a type total of 15. The maxima are μ\*(6) = μ\*_N(6) = μ\*_χ(6) = 6, against M\*_OCR(6) = 9 — the max–min and the min–max separate at the first non-prime-power.

## 9. The biclique side, and a decision on staging

Vipul asked whether the device also boosts §9.7's s(n) — a required-subgraph projection in place of a numerical one. It does (`threshold-beyond-mu.md` §6): if a property omits K_{a,b} with a + b at most the smallest block, every clique and complete-bipartite orbital is out, so is the full union K_r of the foreign classes, and what is left is a proper cyclically invariant complex on a good type. So pseudorandom foreign blocks, discarded by s(n), come back, and the predicted limits become 1/2 at even n and 1/3 at odd n in place of 1/2 down to 1/13. `biclique_boost_scan.py` to 10⁴: 5,625 of 9,995 values improve; the class medians on the upper half sit at 1/2 and 1/3. The smallest improving instance, n = 21 = 8 + 13 with two classes of 39 (8 against s(21) = 7), was built and its orbitals listed. *(A first draft cited n = 24 = 11 + 13 against "s(24) = 8"; s(24) is already 11, from 13 + 11, and the example was replaced before the patch went out.)* It is a sufficient region; no upper bound.

**Decisions (Vipul).** The short note keeps its loose bound — the earlier idea of restating its corollary with 1/26 is dropped. And `threshold-beyond-mu.md` is a staging area: more rounds of refinement there before anything is carried into the framework documents. So no pointer was added to §9.7.

## 10. The convention on the trivial property, and a missing condition in the scan

- **No ∞.** Vipul: the projections should follow §7.1, where the empty property is excluded by definition and the trivial one is included, so the ladder loops. M\*_R(n) is now a minimum over all properties, at most C(n,2), with equality exactly when the ladder has collapsed at R; ARK at n reads M\*_NE(n) = C(n,2); at prime powers everything is C(n,2), as μ\* already is. The first version excluded the trivial property and wrote ∞.
- **Where μ\* and μ\*_cyc part.** Nowhere below n = 56 (asked as a table to 50, where the three exact columns M\*_vtOR, μ\*, μ\*_cyc agree except M\*_vtOR < μ\* at 30, 35, 42). The first ten diverging rows are now in §5.
- **A condition `threshold_scan.py` lacked.** Listing those rows showed n = 63 scored through 32 + 31, where the twist C₃₁ on 𝔽₃₂ and the translations of the 31 points cannot share a cyclic layer. The scan now requires gcd(F(c − 1), r) = 1. Re-run to 4000: the old rule still reproduces the table at all 3,410 rows, still 1,847 improve, the floor is still 0.0887 at 1159; only n = 63 changed (465 → 272).

## 11. Certifying μ\*_cyc, and the entangled group

Vipul asked whether the scan's values at 56 and the other small rows are the true μ\*_cyc, and how much higher the χ rung sits.

- **An upper bound from the table alone.** The complement of the block carries an Oliver group, so its least orbital is at most μ\*(n − r): μ\*_cyc(n) ≤ U(n) (`cyc_certify.py`). U = μ\* at every n ≤ 55, so the device gains nothing there; U equals the scan at 2,385 of 3,410 rows to 4000, including the first ten improved rows. For foreign blocks alone the bound equals the scan at all but seven rows. The matching-prime reading with a partial twist is uncertified at about a thousand rows; 110, 154, 171 were closed by hand.
- **The bound exposed a wrong correction of §10.** U(63) = 465, the value §10 had removed as "not a group of this shape". It is a group: AΓL(1, 32) on 32 + 31 points, the translation of the 31 points tied to the element of order 31 in the twist, the Frobenius acting on them as y ↦ 2y. Built in GAP (`entangled_check.g`): Oliver chain 32, 31, 5; orbitals 496, 992, 155 × 3. So μ\*_cyc(63) = 465, and patch 07's 272 was wrong. `threshold_scan.py` and `biclique_boost_scan.py` now admit the entangled case at F = 1.
- **A by-product on the biclique side:** the same family at n = 15 = 8 + 7 is fully structured (K₇, K₈, K₈,₇), so s(15) ≥ 7 where `biclique_table.py` has 5. Recorded in A49; the framework table is not edited.
- **On the χ rung:** at n = 56 and 63 a property with s equal to the certified value passes the witnessing group, so m\*_χ of that group is exactly the value. Anything more must come from other groups, by arguments the Proposition does not contain; nothing is known beyond n = 6.

## 12. The N level: types, the trivial group, and G\*

Vipul asked for μ\*_N to be certified or bounded at n ≤ 50 and at the first rows where μ\*_cyc leaves μ\*.

- **Structure.** N\*(Γ) is the normaliser of the group Γ̂ fixing every orbital, and a type total is a pair-orbit of N\*. Only the trivial group has a single type (2-transitive groups of non-prime-power degree are almost simple; checked on all classes at n = 6, 10, 12). So μ\*_N ≤ max(ν\*, G\*): ν\* the largest smallest-type over nontrivial groups, G\* the trivial group's own value — the least s(P) with χ(Δ_P) = 1. A group with two pair-orbits has one of at most (n/2)⌊(n − 1)/2⌋, which at n = 2m is m(m − 1) = μ\*: **at n = 2·(prime power) the N level is the trivial group's alone.**
- **G\*.** From below, Smith's congruence at p-subgroups, computed at level 1 (`pgroup_levels.py`). From above, a searched property: the subgraphs of the forced graph plus a deletion-closed family of small classes with Σ ± n!/|Aut| = 1 (`global_chi_forced.py`), rechecked by `verify_global_chi.py` and, at n = 6, by brute force. G\* = 6, 20, 11, 42, 18 at n = 6, 10, 12, 14, 18.
- **Certified:** μ\*_N = μ\* at 6, 10, 12, 14, 18. At 12 the table of marks was run for the first time in full (8,572 Oliver classes; the earlier n = 12 file holds only groups with few orbitals) and gives ν\*(12) = 18.
- **Dead ends recorded:** a property "at most B − 1 edges plus some B-edge graphs" has χ = 1 only if a union of orbits has size C(N − 1, B − 1); impossible at n = 6 for every B, and at n = 10, B = 20 by a 3-adic count. At n = 14 and 18 the first searches failed modulo 9 until D was allowed 12 edges, respectively until 6K₃ was forced.
- **Not reached:** G\* at 22, 26, 34, 38, 46, 50; ν\* away from 2·(prime power) — at n = 30 a group fixing 14 points has smallest type 91 > μ\* = 78, though its level is at most G\*(14) = 42; the rows from 56 on, where only 351 ≤ μ\*_N(56) ≤ max(756, G\*(56)) and the like are proved.

## 13. A notation collision removed

Vipul: `threshold-beyond-mu.md` used s(P) for the largest number of edges of a member, while `orbital-evasiveness-notes.md` §9.7 uses s(n) for the biclique location — and the staging note's own §6 uses that s(n) and s\*_N(n). The property's edge budget is now **e_max(P)** throughout the note and in the docstrings of the three `global_chi` scripts; s is left to §9.7's sense. No statement changed.

## 14. The staging note read against `aod` and against k ≥ 3

- **`aod`, section by section** (`threshold-beyond-mu.md` §9). Nothing in `aod` is wrong; a χ-rung track would sit beside it. The six ceilings become 1/4 and 3 − 2√2, the same pair as `solvable-relaxation.md`. S5 gains nothing (q = 2 is exceptional at the odd indices 3, 5, 7). The feasibility criterion and the shape counts of §6 are unchanged for μ\*_cyc; just under the new ceilings the covering set is one shape per parity, with a disjunction over the cofactor. The converse stops at μ\*_cyc: above it the trivial group's G\* enters, with no shifted-prime content, and at the top rung ARK itself would make the projection C(n,2) with no arithmetic.
- **k ≥ 3** (§10). The device spends the 2-homogeneity of the *normaliser* of the block group. At k = 3 AGL(1, r) has about r/6 orbits on triples, so a foreign block has that many types and χ can be tuned: computed at three blocks, the level-1 budget is the smallest orbit. The one exception is the block of 32, where AΓL(1, 32) is 3-homogeneous: AGL(1, 32)'s five orbits of 992 are one type and the budget is C(32,3), so the Galois escape's pinning of the top prime is waived there. No infinite family at any k ≥ 3.
- **Flagged, not done:** G\*_k against μ\*_k at k ≥ 3, the one place an order of magnitude could move.

## 15. A map of the quantities

At Vipul's request `threshold-beyond-mu.md` opens with three ASCII diagrams: the spine from M\*_vtOR up to C(n,2) with G\*, ν\*, U(n) and the n = 2·(prime power) corollary attached; the per-group levels; and the biclique pair s(n) ≤ s\*_N(n). A ---> B reads A ≥ B: arrowheads point at the smaller quantity. The section is unnumbered so that no cross-reference moves.

## 16. The floor of μ\*_cyc, and the hand-off

- **Two questions answered in conversation, recorded here.** (i) The device stops when the index grows: a prime-power index k is good whenever q ≥ 2^k (every proper invariant complex has χ divisible by the prime, and |χ − 1| < 2^k), so the cofactor may be logarithmic in r but no more; with P⁺(r − 1) ≈ r^θ, θ < 1, the index is a power of r and the device gives nothing. *The prime-power statement is not yet in the note's §4.* (ii) PD(1) is a limit law at fixed θ and says nothing about cofactors of size (log r)^A, an event of vanishing proportion; extrapolating the Dickman density would give about x·log K/log² x primes with cofactor at most K, the Bateman–Horn order, but that is a prime-pair statement.
- **`cyc_floor_scan.py`** — a floor scan that examines only rows whose μ\* is under a threshold. To 10⁵: infimum of the lower bound 0.0887 at n = 1159 (not lifted; true value at most 0.1001), next 0.0938 at 923 (exact). It agrees with `threshold_scan.py` on every shared row. The decade table is in the note's §5; the run above 10⁵ is **R14** in `pending-checks.md`.
- **A50** in `pending-checks.md` is the integration item: which section of the staging note goes to which framework document, what is decided, and what to read first.

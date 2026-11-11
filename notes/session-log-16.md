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

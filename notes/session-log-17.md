# Session log 17 — a third fresh-eyes read of the arithmetic programme, its fixes, and a new checker pass

*One sitting, 2026-11-14. A critical read of `orbital-evasiveness-notes.md` (oen), `enumeration-proof.md` (ep) and `arithmetic-of-density.md` (aod), compared against `pending-checks.md`, `literature-findings.md` (structure and §§25–27 only), the scripts and the outputs; then a patch fixing what it found and extending `check_doc_figures.py`. Correctness in spirit first, in letter second; wording and structure out of scope. `check_doc_figures.py` reported 0 findings on the documents before the read, so everything below was invisible to it.*

---

## 1. Substantive errors

- **oen §2.2, the route past p₁ = 3 was false.** The note proposed that suborbit refinement would kill Theorem 2.2's intransitive branch and extend exactness to p₁ = 5, 7, …. The table refutes it: μ\*(35) = 120 > 105 via `16 + 19*`, and μ\* exceeds the transitive value at 108,709 of 140,364 n = p₁·(prime power), p₁ ≥ 5. Rewritten as a learning: the branch's value is attained, so tightening its estimate cannot help.
- **oen §7.1, ladder placement of the near-misses.** "448 with χ = 1, none 𝔽_p-acyclic" contradicted "28 ℚ-acyclic failing only by a single ℤ/2" (those are 𝔽₃-acyclic). The n = 6 dual pair is 𝔽₅- and 𝔽₇-acyclic, the A₅-on-15 complexes acyclic mod 3, 5, 7: all sit on the AC_p rung, one above ℚ-acyclic. Fixed in oen §7.1 and `pending-checks.md` A38 item 4.
- **ep G.0, "the optimum has a unique (p, q)"**, citing (2,3) at n = 12. The table records (2,2), and a fused class with a cyclic-layer rotation does not constrain q. Rewritten.

## 2. Internal contradictions fixed

- ep: "only F = 3–6 occur" against 2 S7 winners at F = 8; G.4 and Part H reading the menu's 0.0147 as a density (k ≤ 8) where the floor gives k ≤ 4; the s-ladder corollary's "≥ 4, i.e. δ ≤ 1/25" against its own strict form; n = 255 described as cyclic-fused in one place and unfused in another; E.5's exception list filing (16, 5) as Mersenne; R1's max/min; Lemma B vs B′ labels; Part B's row reference; Lemma B′ reader count (now three throughout).
- aod: "two constants at even n against six at odd n" (four at odd n); two-foreign systems "drop above 1/16" (S6 survives to 1/9 at even n); "F ≤ 16 of n's parity" (the opposite parity); §6.3's claim that fusion could let S4 bind first (S7 at F = 2 dominates it term by term); "all five" clauses (four); §4.3's Brun–Titchmarsh bound (wrong direction, missing factor 2; constant now ≈ 40).
- oen: §7.9's t = 12 status (two contradictory paragraphs); gap-inventory count (seven); misdirected "above/below" references; glossary's "exactly 1/F"; App C's unconditional lim inf; §5's even-n ceiling now names the n ≡ 2, 8 (mod 12) obstruction.

## 3. Stale figures requoted

Fermat-branch counts (1,883 at 65537 and 108 at 12289, beside 16 at 257 and 5 at 769); class-11 exceedance (7,950 of 52,038); n = 1943 at δ 0.0659; δ ≥ 1/4 at 7.7%; the certificate's 2,187 rows identified as prefix-plus-tail; worklist size 44,091; ladder runtime 78 minutes; the ω(n) = 2 split over [6, 10⁶]; the F_mid "coprimality budget" replaced by the entangled-generator statement; the record-setter narrative and "awaiting the rebuild" banners replaced by current statements; oen App A's menu figures labelled as lower bounds; "δ ≥ 0.04621" replaced by the fraction or the truncation 0.046209 in ep, `a18-resolution.md`, `t5-resolution.md` and `literature-findings.md`.

## 4. `check_doc_figures.py` PASS 12 (`--pass bounds`)

B1 rounded floor after ≥; B2 sub-floor density in an unlabelled sentence; B3 per-parity counts of ceiling constants; B4 markdown rows keyed by n with a δ column. Regression file built from the pre-fix sentences fires all four; the patched documents give 0 findings on every pass.

## 5. Checked clean

Theorems 2.1–2.3 and their numerics (V, cap(1425), B₀(1460), B₀(1425) = B(1425)); n = 308 and n = 3239 terms; the extraspecial table; Part E's witness rows; S-shape decompositions summing to C(n,2); Theorem 3.1's coefficients; fact 3's n = 10 group; the bipartite e.g.f. and χ = 1,062,436 at n = 10; the A₅ and diagram counts; n = 45, 58, 83 orbitals; the mod-12 smallest-F table; every cap and x\*; the window identity; C₀ = 0.635166; decade and block minima with their residues mod 24; E.1–E.5 arithmetic and the 12 exceptions; F.1, F.2, F.4 constants; the 37,316 count; census totals summing to 921,265; the 3-D Jacobian counterexample cited in oen §10.

## 6. Not done (effort budget)

The rest of `literature-findings.md` and the satellite notes; oen §7.4's focal-subgroup argument beyond its logic, §7.11's protocols, §9.6's tree, §4's oracle argument, aod §§6.8–6.9 analytics, the PD(1) row, the Lean files. No script beyond table queries and the checker was rerun.

---

# Part 2: the satellite notes

*Same session, after 8a4e366. Scope: the satellites the three primary documents link to, in order of reference count. Archived satellites were skipped.*

## 7. Substantive errors

- **`bcp-to-floor.md` §1 remark (iii): a correct figure was "corrected" to a wrong one.** The note had replaced 0.55% with "34 of 3,114, 1.09%", computed for the single system d = 12. But S₁₂ is the bounded-cofactor set (cofactor ≤ 12). Recomputed here: 25,353 primes below 2·10⁶, of which 140 (0.55%) have Q a proper prime power. This matches `shparlinski-constants.md` §4.1. Both figures are now given, each with its definition.
- **`ladder-completeness.md` Prop 1, window bullet.** The note claimed the per-block share c/n is "smaller still" and so inside [0.10, 0.85]. That is backwards: the floor gives only c/n ≳ 1/(5√F), which is below 0.10 from F = 5 on. `mu_ladder_exact.py` windows the class share instead, which is sound.
- **`chiral-graph-properties.md`.**
  - §1 said the prime-power theorem fails only at primes ≡ 1 (mod 4). Theorem 2′ says it fails at every power of a prime p ≡ 1 (mod 4).
  - §4 called the c = 9 group 3²:Q₈ one of Huppert's exceptional groups. Its Q₈ lies inside ΓL(1, 9), so it is not exceptional.
- **`johnson-presentations.md` §5a.**
  - The status line said Lemmas 1–3 had "no independent reading", yet the box directly below them is that reading.
  - The Lemma 1 body still said "P is a line or trivial", which the box replaces with |P| ∈ {1, c, c²}.
  - The ERH row of the table read ~27,023; the correct value is 19,098·log₁₀(26.73) ≈ 27,253.
- **`monotone-transitive-note.md`.**
  - The status row, the §3 table and §6 item 5 all called M₁₂ and 14T54 undecided. §6 item 1 and oen §7.13 both say `halfsplit_large.g` decided them.
  - §6 item 4 cited `small-degree-computation.md` §10 item 7 for an Adamaszek negative control. That item is about S at n = 12; the Adamaszek check is in §4.3.
- **`shape-counting.md`.** §6 said feasibility is read strictly "throughout", but §1's counts 24 / 65 / 164 use ≤. Read strictly they would be 17 / 53 / 145. The note now states which convention each count uses.
- **`small-degree-computation.md`.**
  - §4.3 said Angel–Borja is "not yet in literature-findings" (it is read there, §5).
  - §5.4 gave a χ range starting at ~1.8×10⁴, which contradicts its own sample of −1,215.
  - §8.2a's "q = 2 tags 159 → 532" mixed conventions. The hand-built file has 156 pure tags, or 159 with `2+3`; TOM has 532 pure, or 535 with `2+3`.
  - §5.4 and §10 item 1 cited the "full 170"; the TOM battery is 242.
  - Stage A of §3.1 counted the emitted Oliver groups, not every transitive group.
  - "Fermat-adjacent" should read "Fermat" for 5.
- **`shparlinski-constants.md`** said nothing in it is cited by aod, but aod §6.8 cites it.

## 8. Stale references and figures

- **`ladder-completeness.md`.**
  - Fusion caps at F = 13–15 corrected to 0.0471 / 0.0445 / 0.0421.
  - Updated to 90,299 rows and 15 ms/n.
  - Repointed R7b to R7.
  - The two "risk item 3" pointers had become misdirected after a renumbering; one is repointed, one dropped.
- **`solvable-relaxation.md`.**
  - "Verified over n ≤ 159,027" changed to 10⁶.
  - §3.4 (which does not exist) changed to §4.
  - oen "§9 item 9" changed to §10 item 9.
- **`bcp-to-floor.md`.**
  - The header and the §5 audit table still listed the §9a–§9c steps as unwritten.
  - §7's first end-to-end bullet is now labelled as the halved-orbital control.
- **aod §6.9(e).** "One pass, one reader" updated to the note's actual standing: one author and one independent reader, not refereed.
- **`entangled-generator-finding.md`.** Its mod-24 classes are now mapped to the current mod-12 keying.

## 9. Dehistoricized

Satellite edits follow the same rule as the primaries. Dates, strikethrough "done" items and "this file once said" were rewritten across ladder-completeness, small-degree-computation, monotone-transitive, johnson-presentations, shape-counting, solvable-relaxation, chiral, bcp-to-floor, general-k and directed.

## 10. Checked clean

- Every count, ratio and orbital sum in `monotone-transitive-note.md`, including:
  - Illies' parity sums and its 56 / 32 set counts;
  - the 1,647,681 / 2,630 totals and both orbit-complex tables;
  - the PSL(2,7) f-vector and the 1 − i/2 + 3k/4 formula;
  - χ(A) = 1 and the coset-template equation forcing |G| = 12.
- The johnson §5 table (except the ERH entry), the 3.10 and 4.00 ratios, the Reed–Solomon orders, and the Lemma 1 repair's inequalities.
- `entangled-generator-finding.md`: all orbital sums (33, 78, 105) and the 1.605 / 1.889 ratios.
- Solvable §§3½–4: every ceiling and ratio, all eight best-balanced representations, the 2,594 and n = 2q family, and the m = 5 gap of 700.
- `shape-counting.md`: N and N_foreign with their parity splits at all five rows (recomputed), plus the L values.
- Chiral: every orbital list, the ε-caps, and cap₂(1; ½) = 1/9.
- bcp-to-floor:
  - every grid cell, the class-11 alternatives and the (3,2)/(1,6) tie;
  - 0.96², the Π(1 − 2/((ℓ−1)(ℓ−2))) = 0.7216 product, and 1/13.9.
- Directed: every closed form and ratio in the §3 table, cap₁(1/6), cap₂(1/12), the rank sequences and 2⁴⁵.
- general-k: the c = 32 partition sums, the c = 13 / k = 5 values, and the β_k identity.
- Shparlinski: the x/411 and x/1624 caps, 933·x, D(δ₀) = 26.7 and ≤ 630, the 2.67/log² density, and 0.0153.
- Three-uniform §5.7: both β₃ columns.

## 11. Not done (effort budget)

- `three-uniform-note.md` beyond its status table and §5.7.
- `mu-theta-n2-note.md` beyond its main bound (it is frozen by decision).
- `shparlinski-constants.md` §§7.5–9 literature claims.
- `entangled-generator-finding.md`'s §3–5 repair list (a historical record).
- The low-priority satellites: small-degree-verification, approach-rate-note, restriction-game.
- GAP-dependent claims, since there is no GAP here: the T(10,31) identification and 12T162's structure.
- `ladder-completeness.md` Prop 1's three-foreign enumeration still covers only q ≤ 31, with the q > 31 exclusion unwritten. This is flagged but was not fixed.
- No checker extensions this part.

---

# Part 3: the items Part 2 skipped for effort

*After 55f6983. GAP 4 (with transgrp/TomLib) was installed in the workspace, which unblocked every GAP-dependent check.*

## 12. A substantive finding: the k = 3 ceiling table needs a mod-3 column rule

The κ_c = 2 column of `three-uniform-note.md` §5.7 ("generic", bold) assumes a block with 3 ∤ c − 1, i.e. c ≡ 2 (mod 3). That pins r ≡ n − F·c (mod 3), while the row's efficiency needs r ≡ 2 (mod 3) for d ∈ {2, 4} and r ≡ 1 (mod 3) for d ∈ {6, 12}.

- At n ≡ 0, 1, 6, 7, 11 (mod 12) the bold cell is therefore locally obstructed. This answers §10 item 5's question, "obstructed or thin?": the cells are obstructed.
- The reachable class ceilings at k = 3 are tabulated in a new box after §5.7's table, and `ceiling_rederive3.py` over [10⁴, 2·10⁴] attains each of them to 0.1%.
- Class 11 at k = 3 is set by F = 2, d = 12, at **(2 − √3)/8 ≈ 0.03349**. The bold value (7 − 4√3)/2 ≈ 0.03590 comes from F = 4, which is obstructed.
- Class 7 at k = 3 is set by κ_c = 2 at F = 4, at 1/18.
- `general-k-note.md` §4's "the six mod-12 ceilings are the same at every arity" is corrected accordingly: the values of the generic column are arity-free, but its availability is not.

## 13. Other fixes

- **`ladder-completeness.md` Prop 1, three foreign primes.** The q ≥ 37 case is now written out: shares lie in (1/5, 3/5), η > 1/9 forces k_j ≤ 17, and q ≥ 29 forces a common exponent, after which min η·y² ≤ 2k_min/K² ≤ 0.028.
- **`approach-rate-note.md`.** The log³ ratios were wrong: 1.29 → 1.44 over [8000, 25620], and 3.6 → 3.4 over [10⁴, 10⁶]. Also, `ladder-completeness.md` now points at its §6 third bullet, not the first.
- **`restriction-game.md`.** m = 47 was run (2 groups, so n = 94 joins). `matching_descent.g` read an unset `MS` and now has a default.
- **`monotone-transitive-note.md`.** T(10,31) is identified as M₁₀, the non-split A₆·2. A₆.2 alone is ambiguous with T(10,30) = PGL(2,9), which contains a regular C₁₀.
- **`shparlinski-constants.md`.**
  - The 0.679 improvement is credited to R. Li, arXiv:2508.18285, which uses an average Brun–Titchmarsh theorem, not Maynard's estimates.
  - Maynard's 11/21 and Lichtman's 17/32 are confirmed against arXiv:2211.09641.
  - The Friedlander–Granville III and Sárközy–Stewart II citations are confirmed.
- **Scripts.**
  - `halfsplit_scan.g` counted nothing: `ncand` was never incremented, and its label said 50000 where the cap is 5000.
  - Three GAP scripts read `/tmp/g/ws_oliver.g`; they now read it relative to `scripts/`.
- **`check_doc_figures.py` PASS 12.** Added B5, which recomputes quoted cap_F(η[; ε]) values, and B6, which recomputes "(caps a, b, c)" lists. Both use a ½-ulp tolerance. Regression: the old 0.0472 / 0.0447 / 0.0425 and a wrong cap₂(1/12) all fire.

## 14. GAP reruns, all clean

| script | result |
|---|---|
| `verify_witness.g` | 13 witnesses, every chain clause true, min orbital = μ_bound at each, including 175813 at n = 2759 |
| `t12_162_structure.g`, `t12_162_loop.g`, `t12_162_kernel.g` | order 576, derived series 576 > 144 > 16 > 1, blocks 6 and 2, stabiliser C₂ × S₄; five loop classes (12, 24, 48, 96, 144); kernel is 12T162 |
| `halfsplit_scan.g` | the no-transitive-Oliver groups at degrees 12–14 (order ≤ 5000) are 12T162 (loop), 14T10 and 14T30 (no loop) |
| `halfsplit_large.g` | all 62 larger groups settled, including M₁₂ (order 12) and 14T54 |
| `oliver_negative.g` | PASS |
| `oliver_tom.g` | S₆ has 50 classes, S₁₀ has 1,294 |
| `entangled_check.g` | ✓ |
| `lutzA_pi1.g` | SL(2,5) |
| `matching_descent.g` | matches §6a |

## 15. Read, checked clean

- **`approach-rate-note.md`.**
  - Constants: C₀ = 0.6351664, recomputed; slopes 1.0718 / 1.2376; 1.7410; and 4·(9/8)·C₀ = 2.8582.
  - Counts: 69.2% and 40,488 / 40,752.
- **`restriction-game.md`.**
  - §6a: the 320-group, Fermat / odd-prime-power C_d condition matched against the m list, C(n,2) − n/2 at 84 / 91 and 220 / 231, and 1 − 1/(n − 1).
  - §4: Lemma 2's brute-force values.
- **`three-uniform-note.md`.**
  - §6.2's whole table, the k = 3 Kantor list (via `khomog_verify.py`), and the Galois gains (via `k3_galois.py`).
  - Its §§1–4 and 7–9 were read only for cross-references against §5.7's finding.
- **`mu-theta-n2-note.md`.** The 1/300 corner and 1/350, and the "16 times" figure.
- **`small-degree-verification.md`.** The run list and status were checked against `small-degree-computation.md`: 242 / 186 / 131 / 55, V = 3,782, 17.9%, and 290 ms.

## 16. Still not done

- `small-degree-verification.md`'s per-item figures (for example, 1,061 full-capacity orbits and the 88 prime-sized ones) were not recomputed from the artefacts.
- The full text of Baker–Harman and Balog–Sárközy remains unread, as the note itself records.

---

# Part 4: the OpenAI PD(1) claim beside Baker–Harman

**Status recheck (2026-11-14).** OpenAI family 011 claims the Ford–Konyagin–Luca conjecture: the PD(1) law for the prime factors of p − 1.

- It is still unrefereed and unformalized. There is no `lean/docs/011.md` in openai/math, which is OpenAI's official per-family formalization page (checked by Vipul). Independent catalogues likewise list no Lean formalization, and the community-notes site carries no errata or verification for it.
- The outside work found is limited to two items:
  - A numerical probe to 3·10⁷. It fits the first two PD(1) components but not yet components 3–8 at that range, which is consistent with slow convergence and not decisive.
  - A conditional count-to-supply reduction that explicitly does not verify the analytic theorem.
- No strengthening was found, and no refutation.

**Propagation.** Every live document that cites Baker–Harman as the shifted-prime input now names the PD(1) claim as the conditional strengthening (every θ < 1, relative density 1 − ρ(1/θ), still short of the endpoint):

| document | where |
|---|---|
| aod §3.6 | status line updated |
| oen §10 item 2 | the 0.679 attribution also fixed: Li's route is average Brun–Titchmarsh, not Maynard |
| literature-findings | table row and the shifted-primes wall table |
| note-to-framework-bridge | the θ-ladder paragraph |
| shparlinski-constants | §1's (BH) hypothesis, the §5 table and §9 |

**Deliberately unchanged.** `mu-theta-n2-note.md` and its LaTeX sibling (frozen by decision, and an unrefereed claim does not belong in the outward-facing note), `claude-understanding-of-project-plan.md` (a plan, no claim), and the archived logs.

---

# Part 5: `threshold-beyond-mu.md` read and corrected (staging file only)

*The file is a staging area by decision. Nothing from it was carried into the framework documents.*

## 17. Read and checked

**Clean:**
- The §4 k-table for k ≤ 7, with the complex counts and χ values recomputed by brute force, and the q column that follows from them.
- The threshold-property χ formula.
- §5's first-divergence table (n = 56 to 84), n = 2759 (0.1568), n = 1159 (0.0887 to 0.1001), the 1/26 constant, and the q ∉ {2, 5, 7} side condition holding from n ≥ 426.
- §6's n = 21 orbitals.
- §7:
  - the count of 323 values of n;
  - the claim that no 20-edge graph on 10 vertices has 27 dividing its automorphism group, with v₃(C(44,19)) = 1, so the mod-9 obstruction stands;
  - the n = 30 counterexample;
  - the single-type argument.
- §10's orbit counts on triples.
- `entangled_check.g` rerun.

**Not rechecked:** the solver claims at k = 10 and k = 12.

## 18. Corrections

- **§1 table.** The nontrivial-top rung was merged with the Oliver-χ rung under "≥ μ\*_χ". μ\*_χ is attained on trivial-top groups, and a group's value is at most its core's, so the nontrivial-top rung is bounded only by §4's bound. The row is now split.
- **§9.** Clause 3's d-list is k ∈ {1, 2, 3, 6}, inside the exhaustive range k ≤ 7. It was described as "exactly the range k ≤ 6".
- **§7.** The 976 at n = 63 is now explained as (n/2)·⌊(n − 1)/2⌋ = 976.5, rounded down.

## 19. The pending updates from session-log-16 §16, written in

- **§4: prime-power indices.** A prime-power index k, prime k included, is good for every q ≥ 2^k. The cofactor may therefore grow like log q and no faster, and the device gives nothing at a cofactor that is a power of r. This now covers k = 8, 9, 11 and 13 without the solver. The placeholder in §11 is removed.
- **§9, the §3.6 bullet: PD(1) gives no relief.** PD(1) is a limit law at fixed θ < 1 and does not see cofactors of size (log r)^A. Extrapolating Dickman gives the Bateman–Horn order, x·log K / log² x, but that is a statement about pairs of primes.

---

# Part 6: second check of the scripts behind `threshold-beyond-mu.md`

*Staging file only. Nothing was propagated to the framework documents or to `pending-checks.md`.*

## 20. What was done, script by script

Every script was read line by line, then rerun against the figures the note quotes. Where noted, the result was also recomputed by code written independently for this check.

| script | review | rerun | independent check |
|---|---|---|---|
| `cyclic_chi_values.py` | correct | k = 2–7 table; SAT at k = 8–13 (only 12 attainable) | k ≤ 7 and **k = 10 by exhaustive enumeration**: 292,592,828 complexes, χ ∈ [−125, 127], never 1. The **k = 12 SAT witness** (3,943 faces) rechecked for closure, invariance, properness and χ = 1. |
| `threshold_scan.py` | correct; conservative in two places (only the full q-part twist is tried; k ≥ 14 is treated as bad) | 3,410/3,410 old-rule agreement, 1,847 improved, floor 0.0887 at n = 1159, n = 2759 at 0.1568; the CSV is byte-identical to the committed one | §5's divergence table (n = 56–84) by hand |
| `cyc_certify.py` | correct (the U(n) argument) | 2,385 exact, 1,044 of the improved rows, 3,403 under the foreign reading with the seven exceptions as listed, 1,341 with no gain, every n ≤ 55 | — |
| `cyc_floor_scan.py` | correct (window from §6.1, D0 = 0.078) | 12,529 rows examined, 12,519 lifted; decade table as quoted; agreement with the 4000 scan | — |
| `entangled_check.g` | — | n = 63 orbitals 496, 992 and 3 × 155 | — |
| `type_levels6.py` | correct | the maxima 6 / 15 / 6 / 6; row categories 34 / 11 / 6 / 1 with an overlap of 2 | — |
| `nstar_types.py` | correct (N\* as the automorphism group of the points–pairs–orbitals graph) | ν\* = 6, 20, 18 at n = 6, 10, 12; at each, only the trivial group has a single type | — |
| `pgroup_levels.py` | correct | Z/5 gives 20 at n = 10; the two-block translations give 6, 20, 42, 18, 22, 26 at m = 3, 5, 7, 9, 11, 13 | — |
| `global_chi_min.py` | correct | G\*(6) = 6; n = 12 infeasible at every s ≤ 10 | the n = 6 property's χ by brute force over all 2¹⁵ graphs: χ = 1, e_max = 6 |
| `global_chi_forced.py` | correct | n = 6 regenerated, and its brute-force check passes | — |
| `verify_global_chi.py` | **bug, fixed** (below) | n = 6, 10, 12, 14, 18 all pass after the fix | — |
| `kset_block_levels.py` | correct | all five cases as tabulated in §10 | — |
| `biclique_boost_scan.py` | correct | 5,627 rows improved, all minima and medians and the k counts as quoted, 2759 → 881 | — |

## 21. The bug

`verify_global_chi.py`'s membership test for the H₀ = (n/3)K₃ mode ("tri", used at n = 18) checked only that every component has at most 3 vertices. A graph with more than n/3 such components does not embed in (n/3)K₃. The 7-edge matching at n = 18 is an example: it is not a member, but the test admitted it.

The χ computation was unaffected, since it lists subgraphs of H₀ by deletion. But the closure check and the Smith check were made more permissive. With the test fixed (at most n/3 components), the n = 18 property passes closure, χ = 1 and Smith at 284 p-groups. The solver, `global_chi_forced.py`, builds the property correctly and never had the bug.

## 22. Smith counts reconciled

The counts quoted in §7 depend on TMAX, the cap on how many orbitals a p-group may have to be included:

| n | TMAX | p-groups checked | source |
|---|---|---|---|
| 12 | 11 | 1,919 | as quoted |
| 12 | 12 | 2,239 | extended in this check; all pass |
| 14, 18 | 14 | 44 and 284 | quoted; `verify_global_chi.py` defaults to TMAX 12, which gives 30 and 280 |

The usage line now says which TMAX gives which count. `tom12.txt` (8,572 Oliver classes) was regenerated with `oliver_tom.g` and, as before, is not committed.

## 23. Edits

- **`threshold-beyond-mu.md`:**
  - the header now records the second check;
  - §4's k = 10 / 12 sentence states the independent confirmations;
  - §7's n = 12 Smith count gives both TMAX values;
  - §11's "Owed" splits off what is now done. Still owed: the device inside the exact enumerator, and the right-hand column rescanned class by class.
- **Scripts:** the `cyclic_chi_values.py` docstring records the recheck; `verify_global_chi.py` carries the fix and the usage note.

---

# Part 7: a cost table, and μ\*_cyc / U(n) stated precisely

- **New unnumbered section "Cost of computing each quantity"** in `threshold-beyond-mu.md`, after the map. For each quantity it records what is computed and by which script, measured costs, and the complexity class, alongside size and standing as functions of n.
  - Main observations: everything up to U(n) is polynomial; from ν\* on, everything is super-exponential or doubly exponential, with no middle tier.
  - μ\* is polynomial only because of the classification and the collapse theorem.
- **A box stating μ\*_cyc, L(n) and U(n) precisely.** It covers:
  - the definition, including that the one-orbit restriction is a choice of definition;
  - every way L(n) errs low (one twist per prime, no k ≥ 14, prime-power k refused for q ≤ 2^k, no two-foreign or two-matching-class shapes);
  - the proviso that each scanned shape is a genuine Oliver group;
  - the U argument;
  - the status to 4000;
  - the audit state.
- **New `scripts/cyc_witness_check.g`**, which builds three scanned witnesses as permutation groups: n = 70 (41 + 29\*, q = 7), 77 (2 × 23 + 31\*, q = 5) and 84 (43 + 41\*, q = 5). All are Oliver, and their orbitals give exactly the scanned values 406, 465 and 820. With n = 63 (`entangled_check.g`) that makes four witnesses built in GAP.
- **Still owed for μ\*_cyc:**
  - an independent reimplementation of L and U;
  - a comparison against a rescored full enumeration at small n.

  Neither has been run.

---

# Part 8: two cleanups, and a diagnosis of the L–U gap

- **§1 of `threshold-beyond-mu.md`.** Removed the parenthetical distinguishing e_max from §9.7's s(n); it dates from when e_max was called s. The bi-resistance row now reads simply "μ\*(n) again".
- **Diagnosis of the 1,025 rows to 4000 where L < U.** At every one of them, U's maximising prime r cannot carry a good foreign type. The complement m = n − r is:
  - composite at 449 rows;
  - prime at 401;
  - a proper prime power at 175.

  So the whole gap is the reading in which R is a block of the group's own prime p = r, with a twist from the cyclic layer. The scan never rescores matching blocks. U, meanwhile, bounds the complement by μ\*(m) as if it were an arbitrary Oliver group. That ignores two constraints: the complement must share R's chain (blocks of size a power of r, or foreign primes with translations in the cyclic layer), and R's twist must leave room in that layer.
- **The route to closing it (proposed, not started).** L(n) ≥ 0.0887·C(n,2) at every n ≤ 10⁶. So any configuration beating L must pass the feasibility criterion Σ√F_i ≤ 1/√δ₀ (`aod` §6.1), which carries over to μ\*_cyc unchanged.
  - At δ₀ = 0.0887 that leaves 19 fusion-count multisets.
  - Per n, at δ₀ = L(n)/C(n,2), typically 8 or fewer (at 0.15: {1}, {1,1}, {1,2}, and single fused classes up to F = 6).
  - Enumerating those shapes exactly, with both readings (foreign R, and matching R of prime size with a partial twist) and the framework's chain rules, gives a classification-relative exact value. Call it B_cyc.
  - Wherever B_cyc = L, the value is attained by a constructed witness, so no SAFE-type realisability question arises, and μ\*_cyc = L follows from the classification alone.

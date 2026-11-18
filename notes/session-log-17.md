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

---

# Part 9: closing L against U, the first round

## 24. The tool

**`scripts/mu_cyc_bounds.py`.** For n ≤ N it computes two bounds over the framework's shape space:
- shapes A: F·c, B: F·c + r, C: r₁ + r₂, D: F·c + r₁ + r₂, E: r₁ + r₂ + r₃;
- foreign primes at a common top q, at most one of them rescored.

Why this shape space suffices:
- Two matching classes of one prime merge (`ladder-completeness.md` Prop. 1's merge step, which uses matching-class scores only).
- A part whose own pairs fall below the running best cannot be in a winner. Since L ≥ 0.0887·C(n,2), that leaves at most three parts.
- Matching classes are credited flat at F·C(c,2). This subsumes the "R = a prime matching block with a partial twist" reading of Part 8: rescoring such a block gives C(c,2), which is already its flat credit.

The two bounds:
- **B^(n)** credits a foreign block with C(r,2) unless its type is proved BAD, with no gcd condition.
- **L'(n)** credits only proved-GOOD types, under the scan's chain rules. It is taken as the maximum with the old L.

**`scripts/cyclic_chi_small.py`** is CP-SAT for χ = 1 on C_k with faces of at most S vertices.

## 25. Three facts about C_k-invariant proper complexes X on k points

1. **Pull-back.** Suppose m | k and Y is such a complex on m points. Then X = {S : π(S) ∈ Y}, where π : ℤ/k → ℤ/m, is invariant and proper. X is Y with each vertex inflated to its fibre. The duplicated vertices are dominated, so X strong-collapses to Y and χ(X) = χ(Y). *Consequence:* every value attained at m is attained at each multiple of m.
2. **Reduction.** Let p | k, let S be the Sylow p-subgroup of C_k, and let k′ = k/p^{v_p(k)}. The faces of X not fixed by S fall into S-orbits of size divisible by p. So χ(X) ≡ Σ over the S-fixed faces, which are the unions of S-cosets. Those form a C_{k′}-invariant proper complex Y on the k′ cosets.
   - For p odd, the signs agree, so χ(X) ≡ χ(Y) (mod p).
   - For p = 2, every such face has even size, so χ(X) ≡ −#faces(Y) (mod 2). Since k′ is odd, this never obstructs anything.

   *Consequence:* χ(X) = 1 needs, at every odd p | k, a C_{k′}-complex on k′ points with χ ≡ 1 (mod p). The same holds for χ ≡ 1 (mod q) when q | k, taking p = q.
3. **Skeleta.** The s-skeleton of the simplex, for s ≤ k − 2, is invariant and proper, with χ = 1 − (−1)^s C(k − 1, s). So q | C(k − 1, s) for some s makes the type BAD for q.

**Exact value sets**, by exhaustive enumeration:
- k = 8: every even integer from −34 to 36.
- k = 9: {−69, −60, −54, −51, −45, −42, −36, −33, −27, −24, −18, −15, −9, −6, 0, 3, 9, 12, 18, 21, 27, 30, 36, 39, 45, 48, 54, 57}.

**χ = 1 attained:**
- k = 12 (Part 6's witness);
- **k = 30**: CP-SAT with faces of at most 5 vertices, and the witness of 55,651 faces checked independently. Its orbit sizes 15, 10 and 6 satisfy 10 + 6 − 15 = 1.

**χ = 1 not attained:**
- k = 14, 15 and 18 (CP-SAT, unrestricted), as the reduction predicts. 14 = 2·7 and 18 = 2·9 have k′ = 2; 15 has k′ = 3 at p = 5.
- k = 20 timed out in CP-SAT, but the reduction decides it: at p = 5, k′ = 4, and no value in {−2, 0, 2, 4} is ≡ 1 (mod 5).

## 26. What the trivial top gives, and the results

With a trivial top, the type's condition is χ = 1 exactly. So a foreign prime r scores C(r,2) whenever k = (r − 1)/2 is a prime power, or fails the reduction test. One example is r = 593: k = 296 = 8·37, and at p = 37 the value set of k′ = 8 has nothing ≡ 1. This is new: the earlier rule only credited k ≤ 13.

It is built in GAP at n = 1159 = 2 × 283 + 593. The group is Oliver with an exact (trivial-top) reading. Its orbitals are 296 × 593, 79,806, 80,089 and 335,638, so M = 79,806. The old floor row of μ\*_cyc rises from 0.0887 to 0.1189.

**Results:**
- **To 4000.** L′ rises above the old L at 158 rows. **L′ = B^ at 2,590 of 3,410 rows**, so μ\*_cyc is exact there, relative to the classification. At each of the other 820 rows, B^'s witness is a trivial-top foreign block whose k is undecided. There are 218 distinct undecided k below 2000; the smallest are 56, 63, 99, 105 and 135. All pass the reduction test. At 56 and 63 there is no χ = 1 complex with faces of at most 5 vertices; larger faces are needed there, since Y's faces have size divisible by 7.
- **The conditional collapse.** Rerunning with every undecided k treated as BAD gives **L′ = B^ at all 3,410 rows**. So the gap is exactly the question of whether the reduction condition is sufficient for χ = 1. If it is, μ\*_cyc = L′ at every n ≤ 4000. If some undecided k turns out GOOD, L′ rises there instead. Either way, the value is determined by this one question.
- **The floor to 10⁵.** `cyc_floor_scan.py` now imports this goodness rule. The infimum of μ\*_cyc/C(n,2) is **0.09378 at n = 923**, which is exact. The next rows are 5219 (0.0972), 3959 and 3523, which are not lifted. Its comparison file is now `outputs/mu_cyc_bounds_4000.csv`. Against it: 511 rows equal, none higher.

## 27. Edits, and what is still owed

**Edits:**
- **`threshold-beyond-mu.md`.** An update paragraph in the μ\*_cyc box. The floor statements in the box and in §5 are revised: 1159 is lifted, and the infimum is 0.09378 at 923. The scripts list in the header is extended.
- **Scripts.** `cyc_floor_scan.py` now uses the shared goodness rule. `threshold_scan.py`, `cyc_certify.py` and `biclique_boost_scan.py` still use the older, more conservative rule. Their outputs remain valid lower bounds.

**Still owed:**
- decide sufficiency: by a construction, or by CP-SAT at k = 56 and 63 with larger faces;
- run `mu_cyc_bounds.py` beyond 4000;
- an independent second reading of `mu_cyc_bounds.py`.

---

# Part 10: toward sufficiency, the product construction

**The construction.** Take a coprime split k = a·b, so ℤ/k = ℤ/a × ℤ/b, and write vertices as pairs. P(A, B) = {S : π_a(S) ∈ A, π_b(S) ∈ B} is the simplicial (categorical) product, whose realisation is homotopy equivalent to |A| × |B|. So χ(P(A,B)) = χ(A)·χ(B). For C_a-complexes A₁ ⊆ A₂ and C_b-complexes B₁ ⊆ B₂, with A₁ and B₁ proper and A₂, B₂ not both full, the complex

  X = P(A₁, Δ_b) ∪ P(Δ_a, B₁) ∪ P(A₂, B₂)

is C_k-invariant and proper. By inclusion–exclusion, χ(X) = 1 exactly when (a₂ − a₁)(b₂ − b₁) = (a₁ − 1)(b₁ − 1).

- **Explicit check at k = 56** (8·7): A₁ = the 8 vertices and A₂ a complex with χ = 2; B₁ = the 7 vertices and B₂ the 7-cycle. Enumerating the faces gives 5,839 faces, closed, invariant, proper, with χ = 1. So 56, which the reduction lemma could not decide, is BAD.
- **`scripts/cyclic_chi_product.py`.** The A side is solved by CP-SAT on a ≤ 11 points, with A₁ ⊆ A₂ and the linear form of the equation. The B side uses graph chains (vertices plus edge orbits). Of the 218 undecided k below 2000, it certifies **32**: 56, 63, 99, 105, 153, 176, 198, 200, 209, 230, 231, 261, 306, 315, 410, 414, 429, 440, 470, 473, 495, 530, 561, 590, 638, 774, 803, 1190, 1199, 1265, 1463 and 1925. These are added to the χ = 1 set in `mu_cyc_bounds.py`, and pull-back extends them to all their multiples. Only 56 was checked by explicit face enumeration; the other 31 rest on the product lemma.
- **Result to 4000.** **L′ = B^ at 2,744 of 3,410 rows**, every n < 527 included. B^'s floor now equals L′'s, 0.09378 at n = 923, so the minimum of μ\*_cyc/C(n,2) to 4000 is settled from both sides, relative to the classification. The first open row is n = 527.
- **The marks test.** The Burnside congruences on the marks φ_H give a stronger-looking necessary condition: for every m | k, Σ_{j | k/m} φ(j)·φ_{mj} ≡ 0 (mod k/m), with φ₁ = 1 and φ_k = 0, and the odd-m marks drawn from the known value sets. It reproduces every known case: 6, 10, 14, 15, 18 and 20 infeasible; 12 and 30 feasible. But it is feasible at all the undecided k tested (56, 63, 99, 105). So it does not decide anything the reduction lemma doesn't.
- **Open.** The other 186 undecided k, the smallest being 135, 140, 165, 189, 221 and 224. Each has either no coprime split with a small factor, or none for which graph chains on the large side suffice. The natural next step is to build the B side recursively from the product construction itself, which needs nested pairs rather than single values. A general proof that the reduction condition is sufficient is not in hand. Every k settled so far fits it: every undecided k tested so far has turned out BAD, and none GOOD.

## Part 11: recursive certifier and the q-top pairs

- **`scripts/cyclic_chi_recursive.py`.** It computes NP(m), the realisable nested pairs (χ(A₁), χ(A₂), A₂ full?) on m points. The sources are:
  - exact DFS for m ≤ 8 (`outputs/cyclic_nested_pairs.pkl`, sizes 5, 6, 16, 12, 148, 42, 895);
  - graph chains;
  - prime and generic skeleton chains;
  - pull-backs from divisors;
  - products over coprime splits.

  All values are capped at |χ| ≤ 1500. A k is certified when some coprime split a·b and a pair in NP(a) give b₂ = b₁ + (a₁−1)(b₁−1)/(a₂−a₁) with (b₁, b₂) in NP(b). It certifies **146 of the 160** undecided trivial-top k below 4000 (CAP 600 gives 133). The results are in `outputs/cyclic_chi_certified.txt`, and `mu_cyc_bounds.py` loads them.
- **Sanity check (clean).** None of the 260 proved-GOOD k below 400 is certified.
- **q-top pairs.** 107 (k, q) pairs were undecided.
  - 87 are BAD by a realised χ value.
  - CP-SAT (χ = 1 + qz on k points) finds 8 BAD: (10,41), (10,47), (10,53), (10,59), (11,73), (14,79), (14,127) and (16,113).
  - It finds 8 GOOD (infeasible): (10,107), (10,131), (10,137), (10,173), (10,179), (10,191), (11,103) and (11,151).
  - (16,2), (32,2), (64,2) and (128,2) are GOOD because every orbit has even size. This was argued, not run.

  All are recorded in `outputs/cyclic_chi_modq.txt` and loaded by `status()`.
- **Result.** **L′ = B^ at all 3,410 rows to 4000.** So μ\*_cyc is exact relative to the classification, and its floor is 0.09378 at n = 923.
- **Caveats and open items.**
  - The 14 trivial-top k the certifier leaves open turned out not to affect any row.
  - Nested pairs were enumerated exactly only up to m = 8. The m = 9 run was not used.
  - The CP-SAT verdicts are solver results, with no independent check.
  - Certificates beyond k = 56 were not checked by explicit face enumeration.
  - A general sufficiency proof is still open, as is extending beyond 4000.

## Part 12: `check_doc_figures` findings, and the checks Part 11 left open

- **`check_doc_figures` on threshold-beyond-mu.md and this log: 33 findings, all resolved.**
  - **32 dangling references.** Bare §-references to `orbital-evasiveness-notes.md` (§7.1–7.13, §9.7) and `arithmetic-of-density.md` (§§1–8 in the section-by-section reading), and "Theorem E.5". The note has its own §7 and §9, so these were genuinely ambiguous. Each now names its document, as does the §8 heading.
  - **One I2 false positive.** The checker read threshold-beyond-mu.md's μ\*_cyc ceiling table, whose last column has 5 distinct constants, as *the* ceiling table. `check_doc_figures.py` now takes the table from `arithmetic-of-density.md`, which has 6.
  - After the fixes: 0 findings on the two files.
  - Across all of notes/ there is 1 finding: pending-checks.md L18 "2,186". It is a historical count of rows screened, not a row-count claim, and was left as it is.
- **New script `scripts/cyclic_chi_witness_check.py`.** Its output is in `outputs/cyclic_chi_witness_check.txt`. Witnesses are found by CP-SAT and then checked by separate code: it lists every face and checks closure, invariance under x ↦ x + 1, properness and χ.
  - **Product lemma (`--product`).** 192 random nested pairs on Z/a × Z/b (ab ≤ 12) were listed face by face. χ(P(A,B)) = χ(A)χ(B) held in every case. So did the union formula χ(X) = x₁ + y₁ + x₂y₂ − x₁y₂ − x₂y₁, which gives χ = 1 iff (x₂−x₁)(y₂−y₁) = (x₁−1)(y₁−1). X was closed, invariant and proper each time.
  - **Pull-back lemma (`--pullback`).** 300 random cases with k ≤ 12, every face listed. χ was preserved, and the result was closed, invariant and proper.
  - **BAD (k, q) pairs (`--modq`).** All 95 have an explicit verified witness. 94 have faces of at most 5 vertices. (143, 13) is a χ = 66 complex on Z/11, pulled back.
  - **GOOD (k, q) pairs.** The eight CP-SAT infeasibility verdicts, (10,107), (10,131), (10,137), (10,173), (10,179), (10,191), (11,103) and (11,151), are confirmed by HiGHS (scipy.milp, `scripts/cyclic_chi_good_recheck.py`). The orbit code was written afresh. Controls (10,41) and (11,73) are feasible. (k, 2) with k a power of 2 is a proof, not a computation: a proper nonempty subset has a proper stabiliser in a 2-group, so its orbit size is even.
  - **Certificates (`--cert`).** All 146 check out.
    - 141 have explicit sides: small faces, or a pull-back from a divisor.
    - 5 (140, 308, 615, 1295, 1694) needed more. 615 and 1295 have small-face sides once CP-SAT gets 300 s. 140, 308 and 1694 use derivation trees whose leaves are listed face by face and whose inner steps are a pull-back, a product, or "A₂ = full simplex". For example, 140's B side is the product over Z/4 × Z/7 of an explicit pair and (an explicit complex ⊆ the full simplex).
    - In every case A₂ and B₂ are not both full.
  - **Why the 5 matter.** With them withdrawn, L′ = B^ at only 3,358 of 3,410 rows (first open row n = 552). With them checked, L′ = B^ at all 3,410 rows to 4000 rests on explicit witnesses plus the two tested lemmas.
- **Exact nested pairs at m = 9.** The enumeration finished: 812 pairs, about 41 minutes. It was added to `outputs/cyclic_nested_pairs.pkl`. Rerunning the certifier on the 14 open trivial-top k (1070, 1106, 1133, 1310, 1370, 1469, 1649, 1661, 1695, 1730, 1778, 1790, 1808, 1910) certifies none of them. The certifier now merges with the existing certificate file instead of overwriting it, since `mu_cyc_bounds` already reads that file.
- **Still not done.**
  - The two lemmas are tested, not formally reproved. Their proofs are in Parts 9–10.
  - The CP-SAT and HiGHS GOOD verdicts are solver results with no proof certificate.
  - Two runs make up the full `--cert` record: the second was a targeted rerun, not a clean single pass.
  - Open: the 14 k, a general sufficiency proof, and n > 4000.

## Part 13: density one for μ\*_cyc

The question was whether, conditional on a (BCG-AL)-type supply hypothesis, the constants 1/4 (even n) and 3 − 2√2 (odd n) hold on a set of density 1, with the escapes of density 0. Before this part they were arithmetic on the cap formula plus a spot check. They are now a proposition pair in threshold-beyond-mu.md §5, *Density one*. Nothing was carried to the framework documents.

- **Upper half: Proposition U, unconditional.** μ\*_cyc(n) < δ_cyc(n)·C(n,2) outside an explicit set E, with |E ∩ [1, N]| = O(N/log N). E is:
  - n/q(n) small, the transitive groups, via `orbital-evasiveness-notes.md` §7.2 fact 8;
  - odd n = 2^j + (prime power) with both parts in the balance window.

  The proof uses only the orbit structure:
  - Oliver groups are solvable.
  - Three or more orbits give at most 1/9.
  - Two orbits give below 1/4 at even n, and at odd n need two solvable 2-homogeneous constituents, hence prime-power sizes (Huppert, Kantor), one of them a power of 2.
  - A non-2-homogeneous orbit caps the score at max min(s²/2, (1−s)²) = 3 − 2√2.

  It needs neither the classification nor the good-k question. So the 4000-row work of Parts 9–12 is not an input; it serves as a test.
- **Lower half: Proposition L, conditional on (BH-SW).** This is `bcp-to-floor.md`'s route with the foreign orbital rescored from rQ to C(r,2). The objective becomes min{u²/k, 2αu, α²}, so δ = 1/(1+√k)² depends on k alone, and the cheapest cells are:
  - (1, 2) and (1, 6) at even n;
  - (2, 2), (2, 4) and (2, 6) at odd n;
  - (2, 12) at n ≡ 11.

  Goodness of k = d/2 ∈ {1, 2, 3, 6} for Q ∉ {2, 5, 7} comes from the note's reduction lemma. bcp-to-floor's §9b singular-series bound already covers every (k, d) used.
- **Corollary.** Under (BH-SW), μ\*_cyc(n)/C(n,2) → 1/4 along even n and → 3 − 2√2 along odd n, on a set of density 1. An all-large-n hypothesis at the cyc cells would make the lower bound hold at every large n, leaving E as the only exceptions, and only upward.
- **Checks (`scripts/cyc_density_one.py`), clean.**
  - On the exact 4000 table, no row outside E reaches δ_cyc; 792 of the 884 rows in E do.
  - |E| share: 33.9 / 23.1 / 16.2 / 13.0% at 10³ to 10⁶, ≈ 1.7·N/log N.
  - The local congruences are solvable at all six cyc cells.
  - Best Reduction-Lemma value as a fraction of δ_cyc: worst 0.906, 0.978 and 0.9965 on samples at 10⁵, 10⁶ and 10⁷.
- **Not checked.**
  - The transfer of bcp-to-floor §§4 and 9b to the cyc cells and windows is a reading of which steps use the window and the cell, not a recheck of the circle method.
  - Proposition U's proof has had one reading, mine.
  - The lower-bound samples are short intervals.

## Part 14: the fixed-point-free part of the N level

The question: can the part of μ\*_N that doesn't come from fixed points be isolated, given that ν\* is a loose upper bound for it? It can. threshold-beyond-mu.md §7 now has *The fixed-point-free part*, and the map and cost table has a new row.

- **Definitions and how μ\*_N splits.**
  - μ\*_N^fpf is the largest m\*_N over fixed-point-free Oliver groups, and ν\*_fpf is the largest m\*_typ over the same groups. They satisfy μ\*_cyc ≤ μ\*_N^fpf ≤ ν\*_fpf ≤ ν\*.
  - μ\*_N ≤ max(μ\*_N^fpf, n − 1, max over 2 ≤ a ≤ n of G\*(a)). The n − 1 bounds groups with exactly one fixed point: Γ̂ fixes that point, so N\* does too, and the pairs at it form a type of n − 1 pairs.
- **The type-level ceiling argument (Steps 1–5).**
  - Γ̂ has Γ's orbits, and N\* = N(Γ̂) permutes them.
  - A 2-homogeneous type forces a prime-power orbit. The proof goes through Γ̂ normal in N\*, with the socle of a 2-homogeneous almost simple group being 2-homogeneous except for PΓL(2,8) on 28 points; the existing note already shows that one's socle orbitals belong to no soluble group.
  - **Intransitive Γ:** the Σ√F_i argument over N\*-classes of orbits.
  - **Transitive Γ with N\* imprimitive:** a block argument.
  - **Transitive Γ with N\* primitive, non-abelian socle, rank ≥ 3:** open. This is Conjecture P, fact 8 lifted to types.
- **Corollary (conditional on (BH-SW) and Proposition U_typ).** μ\*_N^fpf and ν\*_fpf tend to 1/4 or 3 − 2√2 on a set of density 1. So any asymptotic excess of μ\*_N over μ\*_cyc comes from fixed points, that is, from G\*.
- **Checks.**
  - `nstar_types.py` now reports ν\*_fpf: it equals ν\* = μ\* at n = 6 and 10.
  - `nstar_transitive_check.g` and `.py` cover all 7,315 soluble transitive groups of degree 6, 10, 12, 14, 15, 18, 20, 21, 22, 26, 28 and 30. Degree 24 was skipped because it has about 25,000 transitive groups. m\*_typ never exceeds n(q(n) − 1)/2, and the maximum attains it at every degree. Soluble is a superset of Oliver, so the test is wider than needed.
  - `socle_2homog_check.g` runs over 2-homogeneous primitive groups of non-prime-power degree, skipping natural A_a and S_a. Only PΓL(2,8) on 28 has a socle that is not 2-homogeneous, up to degree 877. The script's full range, 2,500, was too slow; it was stopped by hand.
- **Not done.**
  - Conjecture P, which is Step 5. It looks like it needs the classification of primitive groups containing a soluble transitive subgroup.
  - The infinite families in the socle fact rest on their standard actions, not on a citation.
  - Steps 1–5 have had one reading, mine.

## Part 15: μ\*_χ at n = 10

- **New script `scripts/chi_level10.py`.** It computes level 2 at n = 10 using nauty certificates for the union graphs and `emb.c` (via ctypes) for embedding. Brute-force canonicalisation over S₆, as in `type_levels6.py`, doesn't scale.
  - **Main pass:** one CP-SAT feasibility call per class at B = 20, cheapest classes first.
  - **Ladder mode:** for heavy classes, budgets b = 2, 4, … until the first feasible one. Feasibility is monotone in the budget.
- **Result: μ\*_χ(10) = 20 = μ\*_N(10) = μ\*(10).**
  - Every Oliver class but the trivial group is feasible at budget ≤ 20: 1,211 in the main pass, 82 by the ladder.
  - The heaviest cases are the groups of order 3 and 6 that move 3 points. They needed a cap of 3·10⁷, with 2.8 M invariant graphs and 1,340 classes at b = 10.
  - The trivial group is G\*(10) = 20 (§7).
- **Level-2 lifts.** ℤ/5, D₅ and F₂₀ on 5 points, fixing 5, have m\* = 1 and m\*_χ = 20 exactly, confirmed with steps of 1. Level 2 lifts weak groups to the maximum and no further, as at n = 6.
- **Checks (clean).**
  - CHI_N=6 reproduces `type_levels6.py`'s m\*_χ for all 50 classes.
  - The embedding test agrees with networkx VF2 on 6,000 random pairs: 3,000 against my first Python backtracker, 3,000 against `emb.c`.
  - The seven classes with m\* = 20 are exactly 20.
- **Not done.**
  - Per-class exact m\*_χ for all classes. Only the bound ≤ 20 matters for the maximum.
  - M\*_OCR(10).

## Part 16: G\* at odd n, and whether fixed points ever decide μ\*_N

- **G\*(15) = 7**, against μ\*(15) = 30.
  - `global_chi_min.py 9 15` finds a property at s = 7 and proves every s < 7 infeasible (`outputs/global_chi_min_15.txt`).
  - The Smith bound 7 comes from ℤ/7 on two 7-cycles with one fixed point.
- **G\*(21) = 14**, against μ\*(21) = 63.
  - **Lower bounds.** Exhaustion proves G\* ≥ 11 (`outputs/global_chi_min_21.txt`), and Smith at ℤ/7³ proves ≥ 14.
  - **Upper bound.** `global_chi_forced.py` has a new mode, `circ`, with forced graphs C₇(1,2) and 2C₇ and D of at most 10 edges. It finds |D| = 147 and e_max = 14 (`outputs/global_chi_circ_21.json`). With only one of the two forced graphs it is infeasible. The ℤ/7³ Smith complex explains why: all 9 intra-block 7-cycles plus all 36 pairs, χ = −27 ≡ 1 (mod 7).
  - **Verified** by `verify_global_chi.py`: closure, χ = 1, and Smith at 7 hand-picked p-groups (`outputs/verify_global_chi_circ_21.txt`, with the groups written by `pgroup_levels_explicit.py 21 ../outputs/pgroups21_explicit.txt`).
- **A fix to `verify_global_chi.py`.** It took nauty's floating-point group size on all n vertices. At n = 21 that is (n − v)!·|Aut| ≈ 8.5·10¹⁵, past exact float range, so it got χ = 2 instead of 1. It now multiplies the small group's exact size by (n − v)!. Earlier runs (n ≤ 18) were within range; n = 10 rerun, still passing.
- **New script `pgroup_levels_explicit.py`.** Smith bounds from hand-picked p-subgroups at n = 15, 21, 33 and 35, where no table of marks is stored. It reuses `pgroup_levels.py`'s level().
- **n = 33.** ℤ/11³ gives G\*(33) ≥ 33 (μ\*(33) = 165). The upper-bound search with the forced graphs C₁₁(1,2) + C₁₁ and C₁₁(1,3) + C₁₁ was stopped after more than 30 minutes, while it was still listing subgraph classes.
- **Observation: Smith-tightness of G\*.** At all seven known n (6, 10, 12, 14, 15, 18, 21), G\*(n) equals the largest Smith bound. Even if that holds in general, it does not by itself show fixed points never decide μ\*_N. An induction on n fails because μ\*_N^fpf is not monotone (μ\*(14) = 42, μ\*(15) = 30), so G\*(a) at a good a < n can exceed the fixed-point-free value at n. What's needed is a per-group bound that also uses the moved points, Proposition U's Σ√F bookkeeping with the fixed block as a part. That is not done. Recorded in threshold-beyond-mu.md §7 and §11 as an observation only.
- **Not done.**
  - The n = 33 upper bound.
  - A general construction of χ = 1 properties at the Smith bound.
  - The Smith checks at n = 21 cover only hand-picked groups, since there is no table of marks at 21.

## Part 17: the Smith bound for translations of blocks

- **Definition**, now in threshold-beyond-mu.md §7: S(n) = max over p-subgroups Q of s_Q, where s_Q = m\*_N(Q) under Q's own condition χ ≡ 1 (mod p). Smith gives G\*(n) ≥ S(n).
- **The class complex.** For Q = (ℤ/p)^k translating k blocks of a prime p ≥ 5:
  - Q̂ = D_p^k, so N\*(Q) = AGL(1, p) ≀ S_k, which acts on the k(p − 1)/2 intra classes as C_h ≀ S_k.
  - Cross orbitals have p² pairs, so below budget p² the problem reduces to a (C_h ≀ S_k)-invariant complex on the classes, and s_Q = p·j.
- **Proposition B.** Two blocks: s_Q = 2p for all primes p ≥ 11. The proof is an explicit j = 2 complex: χ = 2h − 2hx − hy − h²z ≡ 1 (mod p) reduces to x + y/2 − z/4 ≡ 2, solved by x = 2 once h ≥ 5. The small primes give 6, 20, 42 at p = 3, 5, 7.
- **New script `scripts/smith_blocks.py`** (`outputs/smith_blocks.txt`): the least j for k = 2, 3, 4 and p ≤ 43. Once p ≥ 11, j ≤ 3 everywhere.
- **Checks (clean).** Seven (k, p) pairs agree with `pgroup_levels.level()` on the orbitals themselves, where nauty computes N\* independently: (2,3), (2,5), (2,7), (2,11), (3,5), (3,7), (3,11).
- **Consequence, recorded conditionally.** If S(n) = O(n) and G\* is Smith-tight, then every group fixing a ≥ 2 points has m\*_N ≤ G\*(a) = O(n). That bypasses the monotonicity gap of Part 16, so μ\*_N = μ\*_N^fpf for large n.
- **Not done.**
  - A proof that j is bounded for k ≥ 3.
  - Other p-subgroups: iterated wreath products, mixed block sizes, groups with fixed points.
  - Prime-power block sizes.

## Part 18: Proposition B′, the Smith bound of block translations for large p

- **Proposition B′.** For k ≥ 2 blocks of a prime p ≥ 37 with p ∤ k, p ≤ s_Q ≤ 3p, with s_Q = p iff k ≡ −2 (mod p).
  - *The construction.* Take every class, every within-block pair, and t generic within-block triangle families of kh triangles each. Then χ = kh − k·C(h,2) + t·kh. Since p ∤ kh, t can be chosen in [0, p − 1].
  - *Why p ≥ 37.* There are G(h) ≥ (h − 1)(h − 2)/6 − 1 generic families, and this is at least 2h once h ≥ 18.
- **Checks (`smith_blocks.py --construct`; `outputs/smith_blocks_construct.txt`), clean.**
  - The congruence and t ≤ G(h) hold for all 37 ≤ p < 400 and 2 ≤ k < min(p, 61).
  - G(h) matches enumeration at h = 18, 20, 21, 30.
  - Explicit complexes at (2,37), (3,41), (5,43) and (7,53) are closed and invariant, with χ ≡ 1 (mod p).
  - CP-SAT at six larger (k, p) gives j ∈ {2, 3}.
- **Small primes.** For j ≤ J, feasibility depends only on k mod p once k ≥ J, because the family list stabilises and the sizes are polynomials in k. So each prime p < 37 is a finite check. That check is not done. The computed cases with k ≤ 8 and p ∤ k (p = 5, 7, 11, 13) all have j ≤ 6.
- **p | k.** Here χ ≡ 0 (mod p) below budget p², so s_Q ≥ p² (≤ n). Not covered.
- **Where this leaves S(n) = O(n).** It is proved for block translations with p ≥ 37 and p ∤ k. Still open for small primes, p | k, and all other p-subgroups.

## Part 19: the remaining block cases for S(n) = O(n)

- **New script `scripts/smith_families.py`.** It computes j on families of faces (patterns of parts), so k is unrestricted. A family's size is a polynomial in k, periodic mod p while every multiplicity is below p, and the pattern list is stable for k ≥ J. It reproduces `smith_blocks.py` at ten (k, p) pairs.
- **Small primes, done.** For every prime 5 ≤ p ≤ 31 and every k from 2 to 8 + p with p ∤ k (`outputs/smith_families.txt`), the least j is below 8 and below p. That covers a full period, so it covers every k. The largest j per p: 4, 6, 5, 6, 3, 3, 3, 3, 3 for p = 5, 7, 11, 13, 17, 19, 23, 29, 31. For p = 3 the closed form is χ = 1 − (−1)^J·C(k − 1, J), giving s_Q ∈ {3, 6} for 3 ∤ k.
- **Proposition B″.** Translations of k ≥ 2 blocks of any prime p ≥ 3 with p ∤ k have s_Q ≤ 6p ≤ 3n. It combines B′ (p ≥ 37), the computation (5 ≤ p ≤ 31) and the formula (p = 3).
- **p | k.** s_Q ≥ p², because families with fewer than p parts have size ≡ 0 (mod p). One data point: 6 blocks of 3 give s_Q = 18 = 2p². No general upper bound.
- **Not attempted: other p-subgroups.** These are iterated wreath products, mixed block sizes and groups with fixed points. I see no reduction yet: the class-complex argument needs equal blocks of prime size with N\* = AGL(1, p) ≀ S_k.

## Part 20: Smith bounds of other p-subgroups (survey)

- **New scripts.** `scripts/smith_pgroups.g` exports orbitals of two sets of groups, with `scripts/smith_pgroups.py` computing s_Q by `pgroup_levels.level()` (`outputs/smith_pgroups.txt`):
  - the Sylow p-subgroups of S_n at 28 pairs (n, p), n ≤ 96;
  - 429 random subgroups of them, n ≤ 44, kept when they have ≤ 18 orbitals and a new (sizes, order) pair, seed 17. The GAP run is reproducible.
- **Result: s_Q ≤ 3n everywhere.**
  - The maximum, 3n, is at n = 14 (two blocks of 7, 42).
  - 2n occurs at n = 10 and at n = 50, where the Sylow 5-subgroup on 25 + 25 gives 100.
  - Sylow 2-subgroups give at most 16 (n = 96).
  - The per-n maximum otherwise always comes from equal prime blocks.
- **Caveats.**
  - The random sample favours large groups, since few orbitals means a large group.
  - The Sylow list has one group per (n, p).
  - No family seen grows faster than linearly, but nothing is proved beyond Propositions B to B″.
- **Where S(n) = O(n) stands.**
  - Proved for translations of equal prime blocks with p ∤ k.
  - Lower bound p² and one data point for p | k.
  - The survey above for everything else.

## Part 21: looking for μ\*_N^fpf > μ\*_cyc, and how M\*_OCR separates

- **Search for a separation.** All three searches checked whether μ\*_N^fpf > μ\*_cyc at some n ≤ 4000, against L_new of `mu_cyc_bounds_4000.csv`. New script: `scripts/fpf_separation_search.py`.
  - **Two foreign primes, both rescored.** n = r₁ + r₂, with G = (C_{r₁} ⋊ C_{q^{e₁}}) × (C_{r₂} ⋊ C_{q^{e₂}}). G is Oliver, with P = C_{r₁}, H = C_{r₁} × C_{r₂} and a q-group on top, and its cross orbital is all r₁r₂ pairs. Only n = 240 and 812 give C(min r, 2) > μ\*_cyc, and both fail joint goodness: the vertex complex of one block already has χ ≡ 1 (mod q). With joint goodness by CP-SAT for k₁ + k₂ ≤ 22: no hits.
  - **Two isomorphic prime blocks plus a foreign prime, k = 1.** n = 2r + r′ with r − 1 = 2q^e and r′ − 1 = 2q^{e′}, which needs no device beyond N\* merging the two r-blocks. No n ≤ 4000 has such a pair with value above μ\*_cyc.
  - **2r + r′ with general k.** 1,009 triples would beat μ\*_cyc if the merged types were jointly good. CP-SAT checks with 2k + k′ ≤ 18 find none good. The common top primes are small (3, 5, 7), and small q makes χ ≡ 1 easy to reach.
  - **Conclusion.** No separation found. Possible routes: exact μ\*_N^fpf at n = 15, 20 or 21, or devices with non-cyclic multiplier actions.
- **How M\*_OCR separates from μ\*_χ (discussion, nothing filed in the note).** μ\*_χ is max–min: each group may be passed by a different property. M\*_OCR is min–max: one property must pass all groups at once.
  - At n = 6 the forced graph K₃,₃ (9 edges) is required by no single group, since K₃,₃ ⊄ K₃. So the separation is an interaction: passing one group's congruence forces members that another group's congruence then needs completed.
  - **The lower bounds available for M\*_OCR** are μ\*_χ, G\* (the trivial group) and the required graphs of §6. A required K_{a,b} with a + b ≤ s\*_N(n) gives e_max ≥ ⌊s\*_N/2⌋·⌈s\*_N/2⌉. With s\*_N ≈ n/2 at even n and n/3 at odd n (shapes c + r and 2c + r), that is about 1/8 and 1/18 of C(n,2): below δ_cyc.
  - **No known lower bound on M\*_OCR exceeds the conjectured μ\*_N^fpf asymptotics.** One would need a forcing-chain argument across groups.

## Part 22: the barrier, written up

- **New threshold-beyond-mu.md §12, "A barrier, informally".** It defines orbit-local methods: certification through one Oliver group at a time, read from orbit data (orbital sizes, N\*-types, mod-p counts of face-orbits). It argues that such methods are capped at δ_cyc on a set of density 1, because the cap comes from pair counting plus "2-homogeneous ⇒ prime power", and number theory decides only whether the cap is reached.
- **Proved instances:** Propositions U, U_typ (except Conjecture P's case), and B, B′, B″.
- **Outside the class:** embedding (μ\*_χ), G\*, and simultaneity (M\*_OCR). These are the doubly-exponential quantities.
- **Caveats recorded:** no formal definition; density-1 only; no bearing on ARK's truth; KSS's order-n²/4 bound mentioned as consistent but not compared.
- The map legend points to §12. Nothing was carried to the framework documents.

## Part 23: μ\*_N^fpf = ν\*_fpf = μ\*_cyc for every non-prime-power n ≤ 46 except 40

- **The orbit-data bound (new script `scripts/fpf_upper.py`; `outputs/fpf_upper.txt`).** For an orbit O of size a, N\*(Γ) restricted to O lies in N\*(Γ^O). So Γ's types inside O are refined by N\*(Γ^O)'s pair-orbits, and some type has at most F·τ(a) pairs, with τ(a) the largest m\*_typ over soluble transitive groups of degree a (C(a,2) if a is a prime power). Maximising over orbit shapes, with equal sizes merged into one class, gives U_fpf(n) ≥ ν\*_fpf ≥ μ\*_N^fpf ≥ μ\*_cyc.
- **τ computed** by `nstar_transitive_check.py`, which now takes degrees as arguments, at every non-prime-power degree from 6 to 46 except 40. The new degrees are 24 (24,193 groups), 33, 34, 35, 38, 39, 42, 44, 45, 46 (16,737) and 36 (118,027, about 1 h 50 min). In every degree τ equals fact 8's bound, so Conjecture P holds to degree 46 apart from 40.
- **Result.** U_fpf = μ\*_cyc at all 23 non-prime-power n ≤ 46 except 40, so there μ\*_N^fpf = ν\*_fpf = μ\*_cyc = μ\*. No separation. n = 40 needs τ(40), from about 315,000 transitive groups, not run.
- **Where to look next for a separation:** n = 56, 63, …, the first rows where μ\*_cyc > μ\*. There τ is out of reach of the transitive-group library, which stops at degree 47.

## Part 24: the orbit-data bound to n = 4000, given Conjecture P

- **New script `scripts/fpf_upper_scan.py`** (`outputs/fpf_upper_scan.txt`, 50 s). It runs fpf_upper's bound with τ(a) = a(q(a) − 1)/2 at non-prime-power degrees (Conjecture P), searching shapes of up to three orbit classes. A subset-sum check over all shapes, with any number of classes, finds exactly the same 977 gap rows.
- **Result.** 2,433 of 3,410 rows are settled: μ\*_N^fpf = ν\*_fpf = μ\*_cyc there, given Conjecture P. 977 rows are gaps, starting at n = 110 (49 + 61). Every gap witness has two classes, each credited at its full intra-pair count, and no transitive term exceeds μ\*_cyc.
- **Reading.** The bound ignores Oliver structure (a common top q) and goodness. Gap rows can separate only through two-class configurations outside μ\*_cyc: two rescored blocks that are jointly good, or a rescored prime-power block. Part 21's searches found none.
- **Next step, if pursued.** A level-1 analysis of two-class shapes under P ⊴ H ⊴ Γ, the analogue of the classification's two-part cases.

## Part 25: §10 (arity k ≥ 3) updated with this session's findings

- **"What transfers"** now includes §7's split into the fixed-point-free part and groups with fixed points, the latter bounded by G\*_k at the number of fixed points.
- **New paragraph: the barrier at arity k.**
  - The two parts of the mechanism become k-set counting (about s^k/F^{k−1}) and a k-homogeneous normaliser, which is a finite list for k ≥ 3. So the μ\* → μ\*_cyc step has no infinite supply.
  - The computable quantities stay at μ\*_k = Ω(n²), O(n² log n) (`general-k-note.md` §5), a vanishing fraction of C(n,k).
  - That every orbit-local method is o(C(n,k)) at k ≥ 3 is stated as not proved: it would need a type-level bound at arity k.
- **"What might still have juice" rewritten with the k = 2 evidence.**
  - G\* ≤ μ\* wherever known, it equals the largest Smith bound, and block-translation Smith bounds are O(n).
  - Heuristically, the arity-k block-translation Smith bounds are also O(n), so Smith-tightness at arity k would leave G\*_k far below μ\*_k.
  - Recorded as a heuristic, with the first data points named: 3-uniform G\* at n = 6, and a k-set class complex.
- `three-uniform-note.md` and `general-k-note.md` themselves are not edited (staging-area rule).

## Part 26: scope of the definitions; directed and chiral sections

- **threshold-beyond-mu.md §13, "Scope: which definitions need graphs".** It sorts the quantities into three groups:
  - **Defined for any (N, G), as in `monotone-transitive-note.md`:** the rungs and projections, G\*, the per-group levels and types, μ\*_{X,G}, §4's Proposition, and the Smith bounds.
  - **Needing a vertex set:** blocks, shapes, the cap formula, the number theory, Propositions L and U, the fixed-point-free split, bicliques, and the barrier.
  - **Needing pairs or the arity:** full orbit credit (2-homogeneous versus k-homogeneous), the constants, U_typ, Conjecture P, and the B Propositions.
- **§14, directed graph properties** (`directed-graph-properties.md`).
  - *Rescoring.* On a foreign block at odd q, the ordered orbitals are the d cosets of T, cycled regularly by multipliers, so the device applies with k = d (not d/2). It undoes the directed halving at every class except n ≡ 11 (mod 12). There the cell (2, 12) needs k = 12, which is bad at every q: 12 is in ATT1, so χ = 1 is attained. The best is (4, 6), at 1/9.
  - *Ceilings.* The directed device ceilings are 1/4 at even n and 3 − 2√2 at odd n except class 11. Proposition U's counting gives the same orbit-local ceilings, so class 11 has a gap between 1/9 and 3 − 2√2.
  - *Status.* Argued, not computed. Oriented graphs are not examined.
- **§15, chiral graph properties** (`chiral-graph-properties.md`). The bullet in §8 is replaced by a pointer.
  - *Device.* The odd multiplier is corrected by an odd element of Γ̂, which exists whenever some orbit has a 2-homogeneous constituent, as in every shape with a matching block.
  - *Ceilings.* The chiral μ\*_cyc analogue reaches 1/4 and 3 − 2√2 under Proposition L's hypotheses plus c ≡ 3 (mod 4) for the unfused matching block at even n. Proposition U applies verbatim.
  - *Status.* Argued, not checked.
- `check_doc_figures`: two dangling references (Theorem D1, Theorem 1) were fixed by naming their documents; 0 findings.

## Part 27: general theory in the (N, G) setting; a level-1 filter; bi-resistance

- **threshold-beyond-mu.md §13, "What is general theory, and what is not".** "No theory" holds for values: there is no family index. Three structural results are general:
  - the inequalities between the projections;
  - a level-1 closure criterion, with t = 1 (Proposition 1), the single-type case and the §7.13 loop as instances;
  - Smith lower bounds for G\*_G.
- **New scripts `scripts/ws_level1_filter.g` and `.py`** (`outputs/ws_level1_filter.txt`). The criterion was run over every Oliver subgroup class of the six groups without a transitive Oliver subgroup:
  - 12T162: settled by 8 classes, including orders 4 and 8 with six orbits of size 2, not only the known loop;
  - 10T31: settled by the trivial group;
  - 10T7, 10T26: not settled at level 1, but already settled by the A₅ search and inclusion;
  - **14T10 and 14T30: not settled at level 1.** Level 2 is the next filter.
- **Bi-resistance.** T_B is bi-resistant iff μ\*_G ≤ B ≤ N − 1 − μ\*_G. So M\*_BR = M\*_OR whenever μ\*_G < N/2. They can differ only at a half-split (an Oliver subgroup with two orbits of size N/2), where M\*_BR is N/2 or N according to the half-split graph. 12T162 separates them, with μ\*_G = 6 and M\*_BR = 12. For graphs, μ\* < C(n,2)/2 by `monotone-transitive-note.md` §5's case analysis of two-orbital Oliver groups, so M\*_BR = μ\*. The cases are imprimitive vertex-transitive (2K_p and K_{p,p} at n = 2p; in general valencies b − 1 and n − b, equal only if n = 2b − 1), a star plus a clique, and primitive affine at prime powers. None has two equal orbitals at a non-prime-power n. A first draft said "star + clique only", which wrongly omitted the imprimitive case; Vipul caught it. "No isomorphic swapped orbitals" is the special case; the basic reason is "no half-split".

## Part 28: directed and chiral claims on a witness; the directed class-11 gap

- **New script `scripts/dir_chiral_witness.py`** (`outputs/dir_chiral_witness.txt`). It uses Γ = (C₇ ⋊ C₃) × (C₁₃ ⋊ C₃) on 20 points, which is Oliver with q = 3 and consists of even permutations.
  - **Undirected:** orbitals 21, 39, 39, 91; m\*_N = 21.
  - **Directed:** orbitals 21, 21, 39 ×4, 91, 91. The types are 42 (7-block, k = 2, good), 156 (13-block, k = 4, bad at q = 3), and 91 twice. m\*_N = 39 > 21: the device undoes the 7-block's halving and fails on the 13-block, as predicted.
  - **Chiral:** under N\* ∩ A_n (even elements of the nauty group, enumerated with sympy) the 13-block's classes still merge into one type of 78. The odd order-12 multiplier is corrected by an odd element of Γ̂ (S₇ on the 7-block), as §15 claimed.
- **Directed class 11.**
  - **Odd matching blocks force d ≡ 0 (mod 12)**, which is bad at every q. That leaves 1/9 on a density-1 set.
  - **c = 2^j escapes.** It gives d ≡ 2 (mod 4), so the cell is (2, 6) and the value is 3 − 2√2, but only along powers of two, a density-0 set.
  - **q = 3 twists give only density-0 families** (r = 4·3^e + 1).
  - **What would close the gap:** the directed version of the two-class level-1 classification.

## Part 29: the two degree-14 groups settled

- **New scripts `scripts/ws_level2_battery.g` and `.py`** (`outputs/ws_level2_battery.txt`). One variable per G-orbit on subsets of the coordinates. Downward closure, ∅ in, full set out, and each Oliver H's χ(Δ_P^H) is linear in the variables.
  - **Level 2 (one H):** no class settles 14T10 or 14T30 alone.
  - **The battery (all H):** 14T30 = PSL(2,13) is **infeasible**, so settled. 14T10 is feasible, with least e_max 7.
  - **Controls:** 12T162 is infeasible (level 2 settles 13 classes, against 8 at level 1); 10T31 is infeasible; A₅ on 10 points is feasible (e_max 5).
- **New script `scripts/ws_14t10_exhaust.py`** (`outputs/ws_14t10_exhaust.txt`, about 6 min). It enumerates all 4,224 battery solutions at 14T10, and `dtree.c` gives D = 14 for every one. So 14T10 is settled.
- **Both degree-14 groups are now settled by Oliver methods plus one exact check.** That agrees with the literature's N ≤ 14. Recorded in threshold-beyond-mu.md §13. `monotone-transitive-note.md` itself is not edited.

## Part 30: a first pass at two-class shapes on the gap rows

- **New script `scripts/ws_gapclose.py`** (`outputs/ws_gapclose.txt`). For the prime-pair witnesses on the 977 gap rows, it enumerates the twist configurations allowed by the Oliver structure and tries to certify each one BAD with a complex meeting over-approximated readings.
- **First attempt, requiring χ = 1 exactly:** this closed 0 of 489 pairs.
- **With readings taken mod q:** 240 of 489 pairs are closed and 1,190 configurations are open, the first at n = 638.
- **Not done:**
  - the 210 prime-power pairs;
  - joins and richer value sets;
  - a rigorous re-derivation of the reading model.
- No row is promoted. Recorded in threshold-beyond-mu.md §7.

## Part 31: the prime+prime gap rows, settled at level 1

- **Readings re-derived.** The readings are now derived from the Oliver structure itself: an orientation is available when gcd(dX, Y) = 1 and M_Y is a q-group. The reading is exact if M_Y = 1, and mod q otherwise. The 240 closures of Part 30 are unchanged.
- **Two new kinds of closing complex.** First, layered complexes pulled back from C_m on m | k points: a full skeleton plus any orbits of the next layer. Second, disjoint unions of one such complex on each side, compared by residues.
- **All 489 prime pairs close**, 485 of them without unions. The last 4 (n = 904, 1888, 2522, 3678) need a union, because two top primes apply there.
- **New `ws_gaprows_kinds.py`** sorts the 977 gap rows by witness kind. 335 rows are prime+prime only, so they are settled at level 1, given Conjecture P. The other 642 have prime-power (semilinear), merged or non-prime-power witnesses and are not handled.
- **Checked:** the script's count matches the witness list of `fpf_upper_scan.py`. For n = 904 I checked the union residues by hand.
- **Not checked:** an independent reimplementation; the subgroups' readings beyond Γ's own (level 2).

## Part 32: a sign bug, and the pp+pp gap rows

- **A sign bug in Part 31's layered complexes.** The faces added in a layer were given sign (−1)^s instead of (−1)^(s−1), where s is the number of classes in a face. The formula is now checked by brute force at m = 5 and 6.
  - With the fix, 487 of the 489 prime pairs close. Joins (1 − χ = (1 − x)(1 − y)) close the last 2 (n = 1632, 3586). So the claim of Part 31 stands, on a corrected argument.
- **Readings completed.** An orientation also gives a mod-p_Y reading when p_Y divides |M_X| and M_Y = 1. Every pair of twists is now enumerated, and a configuration with no reading counts as not Oliver.
- **New `ws_blockdata.g`** (about 50 min of GAP) and **`ws_gapclose_pp.py`**. These handle the pp+pp witnesses with ΓL(1) twists. The readings are assembled exactly as `OliverData` computes them. On blocks of rank at least 2 only full skeleta are used, so N\*'s action does not need to be known.
  - **Result:** 181 of 210 pairs close; 173 configurations stay open, in 29 rows. Every open configuration has an exact reading and a regular prime block (Z_p, k = (p − 1)/2), where χ = 1 has to be reached exactly.
- **Rows settled at level 1, given Conjecture P:** 462 of 977. That is 335 prime+prime-only rows, plus 127 with prime-power witnesses within ΓL(1). Still open: 19 rows with regular prime blocks, and 496 rows with merged or non-prime-power witnesses.
- **Checked:** the layered χ formula, by brute force; the witness kinds, against `fpf_upper_scan.py`.
- **Not checked:**
  - an independent reimplementation;
  - affine twists outside ΓL(1);
  - subgroup readings (level 2);
  - whether the open regular-prime configurations are truly GOOD or only beyond these complex families.

## Part 33: χ = 1 on a regular prime block

- **The question.** Every configuration left open in Part 32 needs a C_k-invariant proper complex on k points with χ = 1, where k = (p − 1)/2.
- **New `cyc_chi_one_cpsat.py`** (exact, by CP-SAT): χ = 1 is impossible at m = 6, 10, 14, 15, 18 and 20, and possible at m = 12.
- **The Smith test.** It is necessary: for every prime r | m, some value in V(m/r) is ≡ 1 (mod r). It agrees with all seven exact answers. It does not rule out any of the 18 open k (99 through 891).
- **New `cyc_pullback_union.py`.** It computes χ of a union of two pull-backs by a closed formula, checked against 280 explicit complexes. Such unions reach χ = 1 at m = 12, 30 and 36, but not at 44, 45, 66, 99, 176 or 230 (random search). At m = 99, a hand argument shows that a pull-back of a 0-skeleton combined with one other pull-back cannot reach χ = 1.
- **Status.** The 173 configurations (29 rows) stay undecided: neither ruled out nor constructed. Recorded in threshold-beyond-mu.md §7.
- **Not checked.** Exact searches at the open k are out of reach: their orbit counts are about 2^k/k.

## Part 34: χ = 1 on regular prime blocks, so all pp+pp rows close

- **New `cyc_chi_one_construct.py`.** For a coprime split k = ab it takes layered X on Z_a and Y on Z_b and forms Δ₀, the union of their pull-backs. Then 1 − χ = (1 − x)(1 − y), and the search arranges χ(Δ₀) = 1 + ck. Adding |c| free orbits of minimal non-faces of one size, with the right parity, brings χ to exactly 1.
  - m = 99 matches the hand construction: x = 12, y = −44, χ₀ = 496, plus 5 orbits of size 4.
  - Pull-back from a divisor keeps χ. That covers 459 (from 153), 704 (from 176) and 891 (from 99); no split works at 704 or 891.
- **Each construction is checked independently.** χ(Δ₀) is recomputed by summing over exact supports, with the signed count brute-forced for small sizes, and each correction orbit is re-tested. All 18 open sizes are realised.
- **`ws_gapclose_pp.py` now uses these complexes.** It reads `outputs/cyc_chi_one_construct.txt` and accepts χ = 1 on a prime block whose k has a constructed divisor. All 210 pp+pp pairs close, with 0 configurations open.
- **Rows settled at level 1, given Conjecture P:** 481 of 977. That is 335 prime+prime-only rows, plus 146 rows with prime-power witnesses, within ΓL(1). Still open: 496 rows with merged or non-prime-power witnesses.
- **Checked:** every construction's χ, independently, as above.
- **Not checked:**
  - affine twists outside ΓL(1);
  - subgroup readings (level 2);
  - the edge budget on faces, set aside throughout §7.

## Part 35: the budget, and n = 40

- **The budget had been ignored.** m\*_N(Γ) bounds the size of every face (§3), and the level-1 closures of Parts 30–34 never checked face sizes. So they do not settle any row, and the 481-row claim of Part 34 is withdrawn.
- **New `ws_budget_exact.py`: exact CP-SAT for prime+prime configurations with few usable classes.** It searches every C_kA × C_kB-invariant complex whose faces fit the budget. 1,312 configurations are decided and every one has a complex. Seven needed χ fixed to each admissible value (n = 3156, 3216, 3220 ×2, 3310, 3376 ×2); all close. 84,663 are too large to search.
- **New `ws_budget_scan.py`: construction families with the budget.** Of 85,975 configurations, 147 roomy ones in 48 rows are not closed.
- **New `ws_budget_pp.py`: pp+pp with ΓL(1) twists, at most 14 usable classes, no symmetry imposed.** All 1,790 have a complex; 159,556 roomy configurations are not checked.
- **n = 40 settled.** New `nstar_t40_export.g` (about 30 min of GAP) and `nstar_t40.py`. They cover all 291,598 soluble transitive groups of degree 40, using the fact that N\* preserves orbital sizes. Every group has m\*_typ ≤ 140: either a size class has total ≤ 140, or nauty finds a type total of at most 60.
  - So τ(40) ≤ 140 and U_fpf(40) = 140 = μ\*_cyc(40). With that, μ\*_N^fpf = ν\*_fpf = μ\*_cyc at every non-prime-power n ≤ 46, and Conjecture P is checked at every non-prime-power degree ≤ 46.
- **No separation found.**
- **Checked:**
  - the seven slow cases by targeted runs;
  - that degree 40's export covers every index up to 314,565, the last soluble group.
- **Not checked:**
  - the roomy configurations, with the budget;
  - the 496 merged or non-prime-power rows;
  - twists outside ΓL(1).

## Part 36: Lemma C, Smith completeness for cyclic actions

- **New `lemma_c_check.py`.** It compares exact χ sets of C_k-invariant complexes (faces of at most c points) with the prime-by-prime Smith prediction. They agree at prime k and at most composite (k, c). At prime powers they do not: χ ≡ 6 (mod 9) is allowed by the prediction but never realised at k = 9, and similar gaps appear at k = 8. (k = 2 to 9.)
- **New `lemma_c_data.py`.** It uses full data vectors ψ(f) = χ(Δ^{C_f}) with conditions (R), realised quotient data, and (B), the Burnside congruence. It runs over k ≤ 11 with every c, and k = 12 with c ≤ 5.
  - All predicted vectors are realised except a few near the ends of the χ range: |ψ(1)| ≥ 8, and at least 60% of that side of the range.
  - k = 12 with c ≥ 6 is not run (too slow).
- **Lemma C (conjectural) and a proof route.** The route is equivariant cell attachment by stabiliser type, plus a room lemma. Recorded in threshold-beyond-mu.md §7.
- **Not done:**
  - the proof itself;
  - an explicit room bound;
  - the two-block arithmetic.

## Part 37: Lemma F, and the reduction to residues

- **Lemma F (free adjustment), proved.** Adding orbits of free minimal non-faces of a single size s leaves every fixed complex Δ^{C_f} with f > 1 unchanged, and shifts χ by (−1)^(s−1)·k per orbit. Removing free maximal faces works the same way with the opposite sign.
- **Corollary.** χ = 1 is realisable whenever some complex within the cap has χ ≡ 1 (mod k) and enough room. By the Burnside congruence that residue is fixed by the proper fixed-point data. So realising χ = 1 on k points reduces to which data on the quotients Z_{k/r} can occur together.
- **What remains:**
  - gluing: realising compatible quotient data in a single complex;
  - room: a quantitative supply of free minimal non-faces.
  
  Both are recorded in threshold-beyond-mu.md §7.
- **Not done:** a proof of gluing, or an explicit room bound.

## Part 38: Lemma R, and gluing by pull-back unions

- **Lemma R (room), proved.** Starting from L with every vertex, add missing free edge orbits (e of them), then missing free triangles that avoid difference k/2 (t of them). This reaches χ(L) + jk for every −e ≤ j ≤ t − e, with the proper fixed data unchanged.
- **New `gluing_check.py`.** For k ≤ 12 and every cap, the residues of χ mod k reached by unions of pull-backs along prime quotients equal those reached by all invariant complexes. They agree in all 54 cases.
- **Observed: every realised residue set is a CRT product over prime powers.** If this holds in general, χ ≡ 1 (mod k) is decided prime by prime.
- **Not done:**
  - a proof of the CRT-product property;
  - each prime's residue set;
  - k > 12.

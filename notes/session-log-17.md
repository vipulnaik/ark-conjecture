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

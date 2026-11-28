# Session log 18 — a fourth fresh-eyes read of the arithmetic programme, and its fixes

*One sitting, 2026-11-24. A critical read of `orbital-evasiveness-notes.md` (oen, whole), `enumeration-proof.md` (ep: Part 0, census, B–E‴, F, J) and `arithmetic-of-density.md` (aod: §§1–2.3, 3.3.3–3.3.7, 6.1–6.6), with `ladder-completeness.md` Proposition 1, compared against `pending-checks.md` and `literature-findings.md` §§23–28; then a patch. Correctness in spirit first, in letter second. `check_doc_figures.py` reported the same 6 standing findings before and after; everything below was invisible to it.*

---

## 1. Substantive errors

- **Covering-system counts above 1/16 and 1/9 (oen §6, aod §6.4 end, §6.6 twice).** The counts dropped the two-foreign systems at higher floors but kept all F·c + r systems with F ≤ 16. Those are capped too: cap_F(1) > δ₀ gives F ≤ 8 strictly above 1/16 and F ≤ 3 at or above 1/9. Corrected: 4 at odd n and 5 at even n strictly between 1/16 and 1/9; 1 and 2 at or above 1/9. The 13/13 count at 1/25 stands. New checker invariant **I13**.
- **ep Theorem E.3(i) was false inside ΓL(1).** It claimed every Oliver group with orbit sizes {3^a, r} has m\* ≤ c, reading Lemma C as confining the c-twist. Lemma C confines the foreign twist. Counterexample at n = 40 = 27 + 13, p = q = 3: z = (×ω on 𝔽₂₇, +1 on 𝔽₁₃), g = (Frobenius, ×3), gzg⁻¹ = z³; orbitals {39, 39, 351, 351}, so m\* = 39 > 27 (built by script). Corrected bound max(c, r·a), which agrees with E.3(iii)'s Cap′(3) = 39; the first branch needs only t ≤ a (proved for any stabiliser in E‴), so J0a(b)'s exposure moves to the second branch's orb(c, 2). Theorem-side only.
- **Theorem 3.1 (both copies): the within-class cross term was stated as bounded above by (F or F/2)·c².** Its own gotcha's AGL(1,5)-on-five-blocks example (10c²) refutes that. Now: bounded above by C(F,2)·c²; (F or F/2)·c² exact for Part E's groups. New invariant **I14**.
- **oen §7.2, n = 10 reading census** contradicted "every nontrivial Oliver group has a nontrivial-top reading". The buckets are GAP-export tags (p-groups tagged exact, no split-off C_q; `groups_out_10_tom.txt` tags 0, 2, 3, P2, P3, …). Scoped accordingly.
- **oen Appendix B: "pairing each group with its most restrictive chain would give a smaller valid bound"** — false where B is attained (Part E realises every configuration; E.6). Rewritten.
- **ep E‴ sharpness box: "B_refined = B_safe at every n is equivalent to …"** — not an equivalence: any fallback branch can be optimal where B_safe < C(n,2)/25. Rewritten as what is needed at the near-sharp shapes.

## 2. Letter errors that changed the reading

- ep E″: "12.4%" and "2.2%" contradicted the counts 4,080 and 656 of 49,552 → 8.2% and 1.3%.
- oen §7.9: "only resistant properties at n = 6" → only Oliver-χ-resistant.
- oen §2.3 (n = 1460): "no admissible twist reaches either part's cap" → not both at once. B₀'s 0.123 floor scoped to n < 3000.
- oen §7.1 ladder sentence aligned with its own "probably" for the collapsible rung; §7.11 "the two trivial ones" named; §7.12 "half of them" → 55,679 of ~60,000; dangling "Mazur-type mechanism above" and "§3.1" fixed; §11 stale v4 count requoted; ep Part E's C_F coefficient given a direct argument covering composite F; E.5 comma; pending-checks T5 tripwire count rescoped.

## 3. Checked clean

Theorems 2.1, 2.2 (108,709 / 140,364 recomputed), V recursion; Lemma B′; D2 thresholds 371, 471; every E.5 sub-case and the 12 exceptions; E.3(ii)–(iii), E.4; F.1 boundary, F.4 constants; the ceiling table (η per class, x\*, caps, runner-up gaps); census totals; ~20 quoted (n, B) values, floor, 39-row tail, KSS count 37,316; §7 group data, bipartite e.g.f./ODE/parity/period, 16,712 transitive groups, n = 6/A₅ separation counts, dunce-hat f-vectors, duality lemmas; §9 scorpion and triclique orbitals.

## 4. Second pass: the sections skipped for effort budget

*`enumeration-proof.md` Parts G, H, I; `arithmetic-of-density.md` §§3.1–3.2, 3.3.8–3.8, 4, 5, 6.7–6.9, 7, 8; `oen` §7.4's Sylow-form reductions; `literature-findings.md` items 1–7; the shape counts, orbital counts and single-orbital minimum recomputed.*

- **ep G.0 repeated Appendix B's "most restrictive chain would tighten B"**, and is corrected the same way.
- **aod §6.9(b) left open whether the enumeration admits F = 3 at d = 2 at classes 2, 8.** §3.3.5 and the census already answer yes (68,927 F = 3 winners); the sentence now says so.
- **aod §4.3:** the "at most one power of 3 once the ceiling exceeds 0.086" threshold is 1/16, which every class ceiling clears; the explicit constant of the 2-power count is ≈ 19.6, not "about 40". aod §5's "orb(c, d) = cd case of §3.1" → §3.2.3. `shape-counting.md`'s "8 above 1/16" carried the §6 count error.
- **aod §3.6 and `literature-findings.md` item 2 file Runbo Li's 0.679 in the positive-relative-density row feeding Shparlinski's Theorem 2**, but Li's abstract states it for infinitely many p. Flagged in the table and in `pending-checks.md` T4; whether his lower bound is ≫ x/log x is owed.

*Checked clean in this pass:* N(δ₀) = 24 / 65 / 83 / 112 / 164 and the foreign splits 9 (6/3), 25 (11/14), 30, 42 (22/20), 66 (37/29); t and t_eff distributions; 768,400 single-orbital minima; all G.3a builds sum to C(n,2); G.4 and Part H bounds; Part I's odd-n routes (58,844 / 6,187 / 307,070), η = 1 share 511,572, n = 12 tag counts; aod §3.1 ℓ = 3 roots, §3.2.4 worked instances (all four against the table), §3.2.5 c mod 8 split, §3.3.8's 19,665 and 7,950 of 52,038, §3.4 window identity, §3.5.4 admissible-d table (rederived cell by cell), §4.2 S6 table and n = 42, 56 values, §4.3 window ratios, §5 fraction factorisation, block and decade minima, low tail, §6.7 round-trip constants, §6.8(iv) exponents, §7–8 counts (39-row tail, 49,183 odd and the single even n = 1952 below 1/12); oen §7.4 R-reductions (H ◁ L case, (b) ⇔ (c) by Burnside, the local N_L(T) version).

## 5. Third pass: the q-pinning argument of ep E″

Steps 1–5 of the q-pinning box re-derived and sound (gate t ≥ B/r ≥ δn/2; cofactor ≤ 2/δ; q ≥ (δn/2)^{1/e}; Lemma B′ forcing q | r_j − 1 on any leftover foreign part that clears B; at most L/q ≤ 2/δ positions at e = 1; the e ≥ 2 degradation n^{1−1/e}), as is the conditionality at step 1 only. Two findings:

- **The "3.54√B, δ ≤ 0.16" comparison drops r ≥ √(2B).** With it, the pinned bound r_j ≥ B/r is always below r_j's own gate, so pinning adds nothing and the total is exactly F.1's 1/9. Reworded.
- **The n = 1943 row of the pinned-position table is stale.** At the current B(1943) = 124,256, orb(823, 137) = 112,751 fails the gate. The 24,322 / 4 measurement used an earlier, lower B; requoting can only shrink it. n = 779 still sits exactly on its gate. Annotated.

## 6. Fourth pass: threshold-beyond-mu.md and the new notes it cites

Full read of all three. Fixes kept inside these files; no framework document touched.

- **burnside-ring-view.md §7.6:** the converse's feasible system was stated at budget p(p − 3), below |A| = p(p − 1); corrected to p(p − 1) < p². The iff stands.
- **Gap-row counts:** §2 and §10 of threshold-beyond-mu still had 488/489 after n = 1395 and 3555 were settled (session-log-17 Part 65). `nonpp_close2.py` checks faces against T (caps from `ws_budget_scan`, `chi1_ok` with faces ≤ T), so these are budgeted closures within its model; now 490 settled, 487 open, and §6.4 says so.
- **§10:** dropped "subject to checking the cited statements against the memoir" for Li–Xia, contradicted by §6.3 and conjecture-p-proof Appendix B.
- **Letter:** §1.4's n = 10 bullets moved under the n = 10 paragraph; "7,315 to degree 30" now "except 24" (two places); τ(a) formula a(q(a) − 1)/2; 803 added to the 18 open k; class-11 pull-back sentence; μ\*_χ = μ\* at 6, 10 and 12 in §10; §6.4 "fifteen remaining n ≤ 50" now notes μ\*_N^fpf is known there; burnside §7.4 excess 1/(2p − 1) ≈ 1/n (was 1/(2n)); burnside §7.3 p = 3 core order 36 explained; conjecture-p-proof Lemma 2's "socle 2-transitive" (PSL(2,8) on 28).
- **Retracted:** 8,572 vs 7,115 at S₁₂ is classes vs hand-built rows, already reconciled in orbital-evasiveness-notes and small-degree-computation.
- **Checked clean:** see the review reply (ceiling table, Props U/L, first separating rows, Smith Props B/B′/B″, Conjecture P lemmas, gap-row tallies, worked closures, burnside §§4–7.7 proofs and counts).
- **Skipped:** §4's 1/26 claim; script reruns; LX against the memoir; Lemma G / Theorem G line check.

## 7. Fifth pass: the satellite notes

Read in full: solvable-relaxation, three-uniform-note, general-k-note, chiral-graph-properties, directed-graph-properties, ladder-completeness, bcp-to-floor, monotone-transitive-note, johnson-presentations, restriction-game, hardness-of-evasiveness, shparlinski-constants, approach-rate-note, entangled-generator-finding, small-degree-computation §§1–7. Archived notes (three-part-family-split, fusion-count-ceilings, t5-resolution, a18-resolution) read for their banners and current claims, not edited.

- **three-uniform-note:** Lenstra–Pomerance–Wagstaff count is log log x, not log x; c ≡ 17 (mod 24) has v ≥ 3, not v = 4 (c = 41 has v = 3), so mod 24 does not pin v there; "a third of odd blocks" at k = 2 is half; ten (not nine) of the 24 cells fall short, by the note's own 10 + 2·2 count; "non-degenerate" for {8, 32} contradicted §3.1's treatment of 5, now "regular on triples"; the Mersenne paragraph now states the split criterion, and "proof below" is "above"; n = 32's comparison ceiling labelled as the largest class ceiling.
- **solvable-relaxation:** the nilpotent-top probe's n include 63, so "all even" was wrong (two places).
- **general-k-note:** generic-column condition on the foreign twist restated with the corrected θ (no q-power dividing k or k − 1), not L_k.
- **chiral-graph-properties, threshold §8.4:** ε = 1/2 is for c = p^a with p ≡ 1 (mod 4), not every c ≡ 1 (mod 4) (c = 9, 49 are rescued).
- **threshold §8.2:** "β_k = cap_F(η)/2 … untouched at every arity" overstated; only the generic-column values are, the usable columns depend on k.
- **README:** broken link to note-to-framework-bridge.md.
- **Flagged, not edited:** t5-resolution summary still says n ≥ 763 (old δ; ep Corollary C′ and the note's own §3 say 371); monotone-transitive §3 and §6 item 5 call 14T10 and 14T30 open "by these methods", while threshold §8.1 settles both (left alone to keep threshold content out until integration).
- **Skipped:** small-degree-computation §§8–10, small-degree-verification, verification-lessons (operational/meta).

## 8. Sixth pass: the short note (both versions) and the bridge

- **Note §5, quantifiers:** "1.677 and 3/2 both carry exceptional sets" contradicted the note's own §1 (BBKN's Chowla 3/2 for all large n) and `aod` §3.6; now 1.677 carries the exceptional set and 3/2 is conditional.
- **Note §5, Li 0.679:** the parenthetical asserted the positive-proportion form; `aod` §3.6 and `pending-checks.md` record it as owed. Now says so.
- **Note §5, "Goldbach rather than Bateman–Horn difficulty":** the wording item of A26, now "Goldbach and Sophie Germain difficulty rather than a fixed-system Bateman–Horn statement".
- **Note §2:** "admissible set is precisely the pairs with ω(3) ≤ 2" is false (ℓ = 2 also excludes); now one direction plus "the ℓ = 3 half of admissibility".
- All four applied identically to the LaTeX version.
- **Bridge:** PD(1) clause no longer reads as making Shparlinski's rungs conditional; two-foreign systems: S11 drops out above 1/16, S6 only above 1/9; "four parameter choices each" with three listed.
- **Checked clean:** admissible-d table cell by cell from the three mechanisms; S ≥ 4·(9/8)·C₀; 1/350 at n ≥ 29 and the 1/300 corner; both verification groups (orders and orbitals); n = 17 example; §4 family and the 1/2 ceiling; 0.0462 / 2183 against `mu_table_ladder.csv`; bridge balance-point tables, the 1/20, 1/30, 1/48 figures, the 25× ratio.
- **Not edited:** the LaTeX version still has Unicode symbols and markdown bold outside math (≤, −, ×, **...**), which a pdflatex paste will reject; bridge §0's box labels ("A fourth", "Three further") are out of order.

## 9. Lean: pinned build in the container, and the A9 items

- **Environment.** With `cache.mathlib.org` allowlisted, the container fetches Mathlib's cache; `releases.lean-lang.org` (plural) is still blocked, so the toolchain is linked into elan from the GitHub tarball (recipe in `lean/README.md`).
- **Pin.** `lean/` is now a lake project: `lean-toolchain` = v4.36.0, Mathlib tag v4.36.0, `lake-manifest.json` committed, `.lake/` ignored. Files stay at top level (`srcDir = "."`, explicit roots). `leancheck.sh`: 5 files, 0 errors, 0 sorry. The core files still compile against core 4.15.0.
- **Drift fixed** (commit ba37f12): four core lemmas in `E5Core` reproved from lemmas stable across 4.15–4.36; `ArkCore`'s deprecated `if_pos`/`if_neg` replaced by `simp only [h, ite_true/ite_false]`.
- **A9:** `orb_self_pairing` (hypothesis c odd is necessary — counterexample at even c, d = c − 1); `fused_value` / `fused_value_orb`; `Bridge.lean` (`IsPrimeN ↔ Nat.Prime`, i.e. `Nat.prime_def`).
- **Proposal for Vipul:** SAFE model as a bundle of the inequalities E.5 consumes (Option A in the README), plus how to treat the 12 exceptions.
- **README** rewritten at the top: status table for both toolchains, a Building section, the lemma-name lesson updated; the old laptop/container gotchas (LEAN_PATH, cache unreachable) removed as superseded.

## 10. Lean: E.5 on the text's SAFE (A9)

- **Decision (Vipul):** whichever is most faithful to the text — so **Option B** (SAFE as a function, per Part G.3/G.3a) and the **12 exceptions row by row**.
- **New file `lean/E5Assembly.lean`** (Mathlib; a `lakefile` root). Zero sorries. Contents: `Part`/`Fallback`/`safe`/`Admissible`; `safe_le_pairs_r`, `safe_le_pairs_part`; `e5_s_ge4`; `e5_s2a1` (all four a = 1, s = 2 sub-cases, cofactor bounds derived from SAFE, q odd and q = 2); `exceptions` (12 rows, SAFE values equal the table's); `ex28_admissible`.
- **Checked and clean.** Every table row's SAFE value, recomputed from the G.3 definition (not from the script), matches the table, and each row fails 25·SAFE < C(n,2). The text's odd-q chain survives with its two cofactor bounds proved from SAFE instead of assumed. The q = 2 sub-case's r ∈ {3, 5} follows from c prime plus the Fermat-exponent lemma; with only SAFE ≤ C(r,2) (no need for the text's orb(7,2)) it still clears at n = 15 and 23.
- **Observation (no error).** `fallback_sup.py` omits the within-part cross term for a *leftover* class with F₂ ≥ 2, which G.3 includes. Omitting a term can only raise the min, so the script's sup over-states SAFE — the safe direction for the "< 1/25" claim; at the one row where it matters (n = 31, leftover 2·8) the extra term is 64 > 21 and the value is unchanged.
- **Open for full E.5:** the s = 1, s = 3, s = 2 with a ≥ 2 classification steps; completeness of the exception list stays computational.
- **Not checked (effort budget):** `Admissible` was proved for one exception row (n = 28), not all twelve; the Lean core-4.15 build was not rerun (no core file changed).

## 11. Lean: E.5 assembled

- **Added to `E5Assembly.lean`:** `e5_s1` (E.1 classification + `e1_mersenne`), `e5_s3` (E.4), `e5_s2a2` (E.3(i) + `e3_repunit`), and **`e5`**: admissible, non-bare W ⇒ 25·SAFE < C(n,2) or (c, r) is one of the six exception pairs. Zero sorries.
- **Checked and clean.** E.1's step (p odd ⇒ (3, 2); p = 2 ⇒ Mersenne exponent prime), E.3(i)'s "(p−1)/2 divides r, so p = 3", E.4's "only (16, 5)" (now proved for every b, not just scanned to a = 200), and the reduction a = 2m + 1, A = (3^m − 1)/2 that feeds `e3_repunit`. E.3(i)'s "a prime" is not needed: the proof uses only that a is odd (a even fails mod 8).
- **Text finding (wording).** The exception table gives one configuration per n. (F, c, r) = (2, 8, 7) at n = 23 and (3, 8, 7) at n = 31, with no leftover, are also exceptions, with SAFE 21 (`exceptions_more`). E.5's "exactly 12 exceptions" therefore counts n values. A one-line note is added under E.5; the table itself is unchanged.
- **Open.** The exceptional n are not yet pinned to the table's 12 (crude bounds give n ≤ 62 for five pairs; (32, 31) is open between 64 and 88). Corollary E.6 not started.
- **Not checked (effort budget):** I did not rerun `fallback_sup.py` to confirm it records the F = 2, 3 configurations as ties.

## 12. Lean: the exceptional n pinned; E.5 complete

- **`e5_exceptions`**: an admissible, non-bare W with 25·SAFE ≥ C(n,2) has n ∈ {5, 7, 11, 12, 15, 21, 23, 27, 28, 31, 40, 63}. With `exceptions`, this is E.5's exception claim exactly. Zero sorries.
- **Method.**
  - n is bounded per pair through SAFE ≤ orb(r, t), with t a prime power dividing r − 1.
  - Each leftover part satisfies 5·size ≥ n + 3, so there are at most two leftover parts, and two only at (8, 7).
  - The remaining finite enumeration (`chk`) is checked by `decide +kernel`, about 30 s, against an over-approximation of the admissible parts.
  - Soundness: `glue`, `mem_cands`, `twist_mem`.
- **Checked and clean.**
  - The table's n-list is complete, and stays complete under a looser model: t′ any divisor of r′ − 1 when t = 1, leftover foreign primes not required to be distinct.
  - `fallback_sup.py` enumerates leftovers of at most 2 parts. That restriction is now justified, since 3 or more parts cannot reach the line at any exceptional pair.
- **Needed, not optional.** Dropping Lemma B′ ("one q") or the primality of r′ from the enumeration produces spurious exceptions, e.g. (8, 7) with a foreign 5 at t′ = 4, n = 20. So B′ carries weight in E.5's exception list, not just in the odd-q sub-case.
- **Open:** Corollary E.6, which needs B_refined/μ\* (Phase 3).

## 13. Lean: Corollary E.6

- **New `lean/E6.lean`** (lakefile root). Zero sorries.
  - The model: `Config`, `GAdm`, `safe` and `refined`.
  - `e6_core`; **`e6_maxima`**: IsBsafe n B ∧ C(n,2) < 25B ⇒ IsBrefined n B.
  - `e6`: μ = B, given the sandwich halves as hypotheses.
  - `refined_le_safe`.
  - Non-vacuity at prime powers.
- **The model reconciled with Parts 0 and D.**
  - The first draft assumed "a twist below c − 1 needs a foreign r ∣ c − 1". That assumption has been removed: a configuration with no fallback is raised to full twist, which changes no SAFE term. So any d ∣ c − 1 is allowed, as in Theorem 3.1, and Lemma C is used nowhere. This confirms the text's claim that B_safe and the collapse are independent of Lemma C.
  - F is any integer (the certificates' permissive F_mid·F_top).
  - Fused foreign classes and repeated foreign primes are omitted as D2-dominated, as the enumerator does.
- **Checked and clean.**
  - Every case of the text's proof goes through: fallback-free; bare safe-prime pair via the (r, r) re-reading; the twelve exceptions.
  - Each exceptional n has a one-class full-twist configuration (5, 7, 11, 23, 27, 31 transitive; 12 = 3·4; 15 = 3·5; 21 = 3·7; 28 = 4·7; 40 = 5·8; 63 = 7·9) whose SAFE exceeds every fallback's bound there. So "checked directly" holds in the strong form: no exception is ever the optimum.
  - (27, 13) at n = 40 is "bare" in Lean's sense, which does not require c prime. E.3(i) routes it to the exceptions. The text's "bare safe-prime pair" means c prime. No gap, but the definitions differ.
- **D2's parts added to the model.** `fo F r t` stands for F ≥ 2 outside blocks of one prime r, fused or repeated. Its SAFE terms are D2's two classes: F·C(r,2), and for F < r the same-position class, taking max(C(F,2)·r, F·r) to cover D2q.
  - `d2_case` proves D2's domination above the line inside the model.
  - Above the line a D2 part forces F, r ≤ 25 and n < 614 (`d2_small`). Inside that region, `d2check` (kernel-checked, about 1 min) confirms that each of the 256 affected n has a one- or two-part fallback-free witness (`d2wits`) scoring at least the D2 bound, using the rest-part bound C(n − F·r, 2) as well.
  - A single class suffices at all but two values of n: n = 140 (31 + 109) and n = 168 (37 + 131), each needing a class plus a foreign block.
  - Admissibility of the witnesses is proved via `admB` → `GAdm`.
- **Checked and clean.** D2's domination holds in the model at every n, not just over the computed range. The text's Corollary D2′ is range-scoped (n ≥ 471 by the floor, and the computed table below that). This is an independent route covering every n, though it still takes D2's two classes as given.
- **Not checked (effort budget):** that the witness configurations are realised by actual Oliver groups. Most are S1/S2 shapes, but the two-part witnesses (two classes of one p, or a class plus a foreign block) rely on Part E's general construction. I also didn't check whether `d2check`'s region could be narrowed.

## 14. Lean: Lemma D2's counting half

- **New `lean/D2.lean`** (Mathlib; lakefile root). Zero sorries. G ≤ Sym(Fin F × ZMod r) stands for Γ|_O; orbitals are G-orbits on `Sym2`.
  - `d2a`: branch (a), F·C(r,2), needing only that blocks are preserved.
  - `d2b`: Step 3, C(F,2)·r, given the form (σi, a·x + s).
  - `d2q`: D2q step (7), F·r, given trivial linear parts.
  - `step1_sigma` / `step1_mult`: Step 1's order arguments.
  - `step2_mult_equal`: Step 2's equal multipliers.
  - `fo_terms_match`: the link to `E6`'s `fo` scores.
- **Checked and clean.**
  - Branch (a) is unconditional, as the text says ("needs only that the block system exists").
  - Step 3's invariance: block maps keep equal positions, and one common multiplier and translation preserve "same position".
  - D2q (7): with trivial linear parts the within-block difference is preserved, so (7) needs no uniform s, as the text notes.
  - The counts: within-block pairs F·C(r,2), same-position C(F,2)·r, one difference ±δ at most F·r.
- **Not formalised (and why):** the structural core of Steps 1–2. That the r-elements are one diagonal C_r needs Sylow-r of Γ cyclic, which comes from the chain (Γ₂ a p-group, cyclic layer, q-group top), so Γ's chain must be modelled first. The origin change is H¹(Q, V) = 0 with r ∤ |Q|; Mathlib's Schur–Zassenhaus gives conjugacy of complements, so this is reachable once the chain model exists.

## 15. Lean: Oliver's chain and D2's Step 1

- **New `lean/Chain.lean`** (Mathlib; lakefile root). Zero sorries.
  - `OliverChain`, and `OliverChain.map`: the chain passes to surjective images such as Γ → Γ|_O.
  - `rsub_le_N₁`, `rsub_inf_N₂`, and **`rsub_cyclic`**: every r-subgroup is cyclic for r ∉ {p, q}.
  - `trHom`, `step1_translations` / **`step1_Gamma`**: Γ|_O's translations are k·v for one v.
  - `step1_full_support`, `step1_diagonal`.
- **Checked and clean.**
  - The text's Step 1 derivation of cyclic Sylow-r is exactly right as stated: an r-element maps trivially to the q-group top, so it lies in Γ₁; it meets the p-group Γ₂ trivially; so it embeds in the cyclic layer.
  - It needs r ∉ {p, q} both times, which is why D2q (r = q) needs a separate argument.
  - Translations have order r, so the translation subgroup is an r-group without needing any Sylow theory.
- **Step 1 completed (`step1_full`)** from Lemma B's affine form and transitivity:
  - Cauchy gives an element of order r, since F·r divides |Γ|_O|;
  - it is a pure translation (`rElem_is_translation`, with the iterate formulas `affine_pow_fst` / `affine_pow_one`);
  - conjugation sends τ_t to τ_w with w_{σi} = aᵢtᵢ (`conj_translation`), so every component of the generator is nonzero.
- **Checked and clean.** The text's "transitivity forces every component nonzero" is right, and it needs only point-transitivity plus the affine form. Lemma B is used exactly at the conjugation step and to make the r-element a translation.
- **Step 2's first claim for the group** (`exists_translation`, `step2_common_mult`): a nonzero translation t = k₀v lies in Γ|_O; conjugating it by g gives aᵢvᵢ = (k/k₀)·v_{σi}. So the multipliers are equal once v = 𝟙. Checked and clean: this is the text's argument verbatim.
- **Remaining for a full Lean D2.**
  - Step 2's H¹ = 0 origin change (the second claim).
  - The bridge into `D2.lean`'s normal-form hypothesis.
  - Lemma B itself.

## 16. Lean: D2's Step 2 (H¹ = 0) and Sylow-r = T\*

- **New `lean/Step2.lean`.** Zero sorries.
  - `origin_change`: for any finite group Q with |Q| invertible in a field K, and any cocycle t modulo constants with multiplier a, the origins o := −|Q|⁻¹ Σ a_h⁻¹ t_h make every translation part constant across blocks.
  - This is the computation behind the text's H¹(Q, V) = 0.
  - Byproduct: σ need not be multiplicative. Only the cocycle identity is used.
- **`Chain.not_rsq_dvd`.** r² ∤ |Γ|_O|, because a subgroup of order r² would consist of r-elements, hence translations k·v, of which there are only r. So Sylow-r of Γ|_O is T\* and |Q| is prime to r, exactly the text's "r ∤ |Q|".
- **Checked and clean.** The text's Step 2 holds as stated. The coprimality input it cites ("Sylow-r of Γ|_O is exactly T\*") follows from Step 1, as the text implies, and is now proved.
- **Remaining for a full Lean D2.**
  - Rescale to v = 𝟙, read (σ, a, t) off coset representatives of T\*, and check the cocycle identity modulo constants. The identity itself is the one-line composition formula t_{hg} = a_h t_g + t_h ∘ σ_g.
  - Assemble everything into `D2.d2b`'s normal form.
  - Lemma B.

## 17. Lean: Step 2 applied to Γ|_O; Step 2 → Step 3

- **New `lean/Glue.lean`.** Zero sorries.
  - `affine_mul`, `affine_tr`, and `data_of_affine`, which shows the affine data is determined by g.
  - `Tsub` and `Tsub_normal`: T\* is normal.
  - **`step2_glue`**: in normalised coordinates (common multiplier, T\* diagonal) with [G : T\*] prime to r, there are origins o with every g ∈ G acting as (σi, a·(x − oᵢ) + s).
  - Reading the data off coset representatives costs a diagonal translation, which shifts t by a constant and so leaves the cocycle modulo constants intact.
- **`D2.d2b_shift`.** Step 3 in shifted coordinates, so `step2_glue`'s output gives the C(F,2)·r orbital directly.
- **Checked and clean.**
  - The text's Step 2 holds for the actual group, not only abstractly.
  - The composition formula t_{hg} = a_h t_g + t_h∘σ_g is the right cocycle.
  - T\*'s normality is what makes Γ|_O/T\* a group, as the text implicitly uses.
- **Remaining for a full Lean D2.**
  - Conjugate Γ|_O by the per-block rescaling x ↦ x/vᵢ, to connect `Chain.step1_full`/`step2_common_mult` (general coordinates) to `Glue.step2_glue` (normalised). Orbital sizes are invariant under conjugation.
  - Lemma B.

## 18. Lean: Lemma D2 end to end (r ∉ {p, q})

- **New `lean/Rescale.lean`.** Zero sorries.
  - `scale`, `conjG`, `mem_conjG`.
  - `conj_affine`: after rescaling by v the multiplier is the common λ.
  - `conj_translation_scale`: τ_{k·v} becomes τ_{k·𝟙}.
  - `orbit2_conj`: conjugation preserves orbital sizes.
  - **`d2_full`**: chain + 2 ≤ F < r + r ∉ {p, q} + Lemma B + transitivity ⇒ an orbital of at most C(F,2)·r pairs.
- **The index step.** |T\*| is divisible by r, since it contains a nonzero translation of order r. Also |G'| = |G|, and r² ∤ |G| (`not_rsq_dvd`). So r ∤ [G' : T\*], which is the input `Glue.step2_glue` needs.
- **`Chain.step2_common_mult`** now also returns the translation property of the same v, so Step 1 and Step 2 use one generator.
- **Checked and clean.** The text's Steps 1–3 compose as written. The only external inputs are Lemma B's affine form, the chain on Γ|_O (proved to pass from Γ by `OliverChain.map`), and transitivity.
- **Remaining.**
  - **Lemma B for prime blocks.** A route without the classical "solvable primitive ⇒ affine" theorem:
    - the block group's normal p-subgroup is trivial, because its orbits have p-power size dividing r;
    - so its Γ₁-part is cyclic and its Sylow-r is characteristic in it, hence normal;
    - and the normaliser of a regular C_r in Sym(r) is AGL(1, r), elementary: f(x + 1) = f(x) + c forces f(x) = cx + f(0).
    The cost is coordinatising each block by its r-cycle.
  - D2q (r = q) end to end.

## 19. Lean: Lemma B for prime blocks — the three steps

- **New `lean/LemmaB.lean`.** Zero sorries.
  - `affine_of_shift` / `affine_of_normalizes` (with `addRight_zpow_apply`).
  - `normal_pgroup_trivial`, via Mathlib's primitive/quasiprimitive results.
  - `mem_zpowers_of_orderOf_eq` and `conj_mem_zpowers`: in a finite cyclic group, two elements of order r generate the same subgroup.
- **Why this route.** The text's Lemma B cites "a solvable primitive group is affine", which is not in Mathlib. For prime blocks the chain gives a shortcut: Γ₂ dies on the block, Γ₁ acts through a cyclic group whose r-cycle every element normalises, and normalisers of a regular C_r are affine.
- **Checked and clean.** Each step holds as stated. The route needs only the chain and r ∉ {p}, not solvability in general, and not q ≠ r for step 1.
- **Remaining for Lemma B (prime blocks).**
  - Per block: show Γ₁'s image is cyclic and contains an r-cycle z.
  - Coordinatise the block by z.
  - Glue the blocks into `Chain.Affine`. This last step needs one element of order r acting as an r-cycle on every block. The chain makes Sylow-r of Γ|_O cyclic (`rsub_cyclic`), and transitivity should spread a nontrivial action to every block. **This must not reuse `Chain.step1_full`, which assumes Lemma B: that would be circular.** Not yet worked out.

## 20. Lean: Lemma B for prime blocks, and D2 with no Lemma B hypothesis

- **`LemmaB.lemmaB_block`**, assembled. For a transitive H on ZMod r with an Oliver chain and r ∉ {p, q}:
  - the bottom layer is trivial on the block (`normal_pgroup_trivial` plus faithfulness), so the middle layer is cyclic;
  - Cauchy gives z of order r in the middle layer, and every h conjugates z to a power of z;
  - z is an r-cycle, and labelling k ↦ zᵏ(0) makes it x ↦ x + 1, so every relabelled h is affine.
- **New `lean/D2Full.lean`.** Zero sorries.
  - `OliverChain.comap`: chains restrict to subgroups.
  - `Kstab`, `ρ`: the block stabiliser and its action on the block.
  - `block_onto`.
  - `conjBy` / `orbit2_conjBy`.
  - **`d2_noB`**: Lemma D2 (r ∉ {p, q}) from the chain, a preserved block system and transitivity. No Lemma B hypothesis.
- **The circularity is avoided.** Lemma B is derived per block from the chain directly, using only the block's own group, and is transported by a transversal. Step 1 (`Chain.step1_full`) is then applied to the relabelled group, which is affine by construction.
- **Checked and clean.**
  - The text's Lemma B, for prime blocks, follows from the chain without the classical solvable-primitive theorem.
  - The transversal construction is the standard induced-action argument.
  - Every hypothesis the text uses is now either a theorem or a stated input: chain, block system, transitivity, F < r, r ∉ {p, q}.
- **Remaining.** D2q (r = q) end to end: steps (1)–(6) of its proof.

## 21. Lean: Lemma D2q, and Lemma D2 complete

- **`LemmaB.lemmaB_block_any`.** Lemma B for a prime block without r ≠ q. When the middle layer acts trivially, H is a q-group of degree r, so r = q, |H| = r (r² ∤ r!) and H is cyclic. `affine_of_normal_cycle` factors out the final step.
- **`D2Full.exists_affine_relabel`.** The relabelling half of `d2_noB`, factored out and using `lemmaB_block_any`, so it serves r = q too.
- **New `lean/D2q.lean`.** Zero sorries.
  - `affine_mul_gen`, `affine_pow`.
  - `pow_is_translation`: g^(F!(q−1)) is a translation.
  - `centralizes_of_coprime`: Bezout on exponents.
  - **`d2q_fixed`**, `d2q_affine`, **`d2q_noB`**.
  - **`lemmaD2`**: all three classes.
- **How the proof relates to the text's D2q.**
  - Steps (1)–(4) are absorbed: q-elements are translations (`rElem_is_translation`), and commutators of translations with affine maps are translations (`conj_translation`).
  - Step 5 (T₀ ≠ 0) and step 6 (T₀ = 0) are the two branches of `d2q_fixed`, each giving a v fixed by the middle layer.
  - The extension from N₁ to all of Γ|_O uses g^(qᵏ) ∈ N₁ and g^(F!(q−1)) ∈ T\* with gcd = 1. This replaces the text's "Γ|_O = N·T\*" decomposition.
  - Step 7 is `D2.d2q`.
- **Checked and clean.** D2q holds as the text states it, for every 1 ≤ F < q. The text's principle, "a twist forced into the same abelian layer as the translations it scales must be trivial", is exactly the step-5 commutator argument.
- **Lemma D2 is now formalised in full** from three inputs: the chain on Γ|_O, a preserved block system and transitivity. The chain passes from Γ to Γ|_O by `OliverChain.map`.

## 22. Lean: tying D2 back to E.6; Lemma D1

- **New `lean/FoBridge.lean`: `fo_terms_valid`.** For every group realising F ≥ 2 outside blocks of prime size r ≠ p (chain, block system, transitivity), each `fo` SAFE term of `E6.lean` bounds some orbital.
  - F·C(r,2) comes from (a).
  - For F < r, max(C(F,2)·r, F·r) comes from (b) when r ≠ q and from (c) when r = q.
  - So the `max` the E.6 model takes, chosen to cover both cases without knowing q, is justified on both branches.
- **New `lean/D1.lean`: `lemmaD1`.** Replacing `pc F c d` (F = pᵏ) by `pc 1 (F·c) (F·c − 1)` keeps GAdm and n, and SAFE does not drop. Each new term dominates an old one: C(F·c,2) ≥ F·C(c,2), the cross term disappears, and the between-part terms are unchanged.
- **Checked and clean.**
  - D1's proof is exactly the text's.
  - The `fo` scores in E6 are now consistent with what Lemma D2 proves, rather than copied from the text.

## 23. Lean: Lemma B′

- **New `lean/LemmaBprime.lean`.** Zero sorries.
  - `step0`.
  - `lemmaBprime`, abstract.
  - `card_eq_prime`: cyclic of exponent p₀ means order p₀.
  - `τ`, `Tsub`, `conj_τ`.
  - `lemmaBprime_affine`: concrete, giving **a = 1** and a q-group twist.
- **Checked and clean.**
  - Step 0 holds exactly as written, needing both irreducibility and C_G(V) = V.
  - Case 1: the middle layer contains V and is abelian, so it centralises V, so it lies in V, so it equals V.
  - Case 2: G is a q-group, so its centre has an element of order q, which generates a normal subgroup containing V by Step 0. So V is cyclic and p₀ = q.
  - The text's Case 2 detour through block systems and regularity is not needed once Step 0 is available. The central subgroup of order q is normal, so it contains V directly.
- **The affine link.** In the concrete version, minimality of V is derived from irreducibility of the linear parts on additive subgroups, which equal subspaces over 𝔽_{p₀}. C_G(V) = V is derived from affineness: an element commuting with every translation has trivial linear part. So these are not extra assumptions beyond the affine form.
- **B′ from primitivity alone (`lemmaBprime_primitive`), added the same day.**
  - The classical "solvable primitive ⇒ affine" theorem is not in Mathlib. I checked: Mathlib has primitive and quasiprimitive actions, Jordan, Schur–Zassenhaus and solvable groups, but no socle or minimal-normal theory.
  - The shorter route needs no solvability and no minimal normal subgroup either:
    - nontrivial abelian normal subgroups of a primitive group are regular (`card_eq_of_abelian_normal`);
    - Γ₂ = 1, since a transitive p-group would make |X| a p-power;
    - Γ₁ is cyclic; if nontrivial it is regular, and its order-p₀ subgroup is regular, so |X| = p₀;
    - if Γ₁ = 1, a central order-q subgroup is regular, so |X| = q.
  - **So B′ is proved from the chain and primitivity outright.**
- **README note added (at Vipul's request).** On a future Mathlib bump, check whether ready-made socle / solvable-primitive results exist and could replace the hand proofs. This needs a version bump and re-pin, so it is not to be done lightly.


## 24. Lean README cleanup

- **Readthrough of `lean/README.md`** (at Vipul's request), removing outdated material:
  - **Core 4.15.0 build dropped.** The column is gone from the status table, the "core-only route" paragraph is deleted, and the reconciliation section no longer ties route 1 to the 4.15 check. The 4.15 history stays in the lemma-name note as history.
  - **Plan section.** It now opens with a status line: E.5 is done (in `E5Assembly`, not `Basic.lean`); Proposition 1 of `ladder-completeness.md` is open; steps 2–6 of the October plan are not started; work went to D2, B and B′ instead. The rest is kept as the forward plan, with month references removed.
  - **Superseded statements fixed.** "Phase 1b" became "Theorem E.5 and Corollary E.6 — done". The "not formalised" and "given Lemma B" statements in the E6, D2, Chain and Rescale entries now point to the files that discharge them. "The split" now says only the deep inputs (Oliver, Smith theory, Huppert) are out of reach, not chain-level group theory. Phase 0 no longer calls `Note.lean` uncompiled.
- **`pending-checks.md` state line** updated to match: eighteen files, the core build dropped, and the current proved and conditional lists.
- **Checked clean:** no remaining "five files", "October" or "given Lemma B" statements in the README, apart from history.
- **Not run:** `lake build`, since no `.lean` file changed. Earlier session-log entries that mention the 4.15 build (§§ on the pin and drift) are left as they are, since they record what was true then.

## 25. Lean: Proposition 1's fusion-count clause

- **`Prop1.lean`.** `ladder-completeness.md` Proposition 1 bounds the fusion count of a class beside other parts at F ≤ 16 above 1/25. Proved in the `E6` model as `fusion_cap`, via the exact ℕ inequality `cap16`: 25·min(F·C(c,2), C(s,2)) ≤ C(F·c + s, 2) for F ≥ 16.
- **Finding:** the bound is one loose. cap_16(1) = 1/25 exactly, so the strict inequality forces F ≤ 15. Recorded in `ladder-completeness.md` beside the clause. The ladder's menu, which scans to F = 16, is unaffected.
- **More of Proposition 1 in `Prop1.lean`:** every part has share > 1/5 and there are at most four parts (`part_share`, `parts_le_four`); a foreign part of share below 1/2 has 2(r − 1) < 25t (`foreign_efficient`, the k ≤ 12 clause); two matching classes merge without lowering SAFE (`merge_classes`, the S12 clause). The merge needs no "within-class cross never binds" assumption: the merged cross term is proved ≥ F₂·C(c,2).
- **Three foreign primes, the reduction (`three_foreign`).** Sorted r₁ ≤ r₂ ≤ r₃ above the line give k₁ ≤ 5, k₂ ≤ 12, k₃ ≤ 17 (rⱼ − 1 = kⱼtⱼ), from orb ≤ r·t and the shares ≤ 1/3, ≤ 1/2, < 3/5.
- **Three foreign primes excluded (`ThreeForeign.lean`, `no_three_foreign`).** Exact, for every q and exponent. Normalise by the least twist T: rⱼ = aⱼT + 1, tⱼ = bⱼT, bⱼ a power of q dividing aⱼ, one bⱼ = 1. The b = 1 part bounds A = Σaⱼ ≤ 31; in every remaining pattern some part's bound fails at every T (leading coefficient ≤ A², linear ≤ 5A). Kernel check, one `decide` per q; about two minutes, under 2 GB.
  - Exploration on the way (scripts not kept): dropping the halving for q = 2 or the parity of rⱼ breaks the exclusion (continuous sup 1/18 at q = 3 without parity), so both inputs are needed. A direct scan of actual prime triples to 20,000 gives max density 0.0286.
  - A single `decide` over all q ran out of memory (7 GB container); splitting per q fixed it.
- **Proposition 1 assembled (`Prop1Final.lean`, `prop1`).** Above the line, any admissible D2-free configuration is matched (same n, SAFE no lower) by one with ≤ 1 class and ≤ 2 foreign parts, and F ≤ 15 when the class has company. So Proposition 1 is now a theorem of the model, with the fusion bound one sharper than the text's.
- **Next in `ladder-completeness.md`:** Proposition 2 (the S6 ≤ 1/9 and S11 ≤ 1/16 ceilings).

## 26. Lean: Proposition 2 (S6 and S11 ceilings)

- **`TwoForeign.lean`.** `s6_ceiling`: two foreign primes alone have 9·SAFE ≤ C(n,2). `s11_ceiling`: a class beside two foreign primes has 16·SAFE ≤ C(n,2). Every q and exponent.
- **Method.** As for three primes: normalise by the least twist, bound A = a₁ + a₂ < 18, kernel check per q. One family passes the coefficient test (q = 2, r₁ = 2T + 1, r₂ = 3T + 1); primality removes it, using 2^m mod 15. S11 reduces to S6's lemma because a class above 1/16 forces 9n(n − 1) ≥ 16R(R − 1).
- **Findings, recorded in `ladder-completeness.md` §3:** the text's exceptions {3, 5} and {5, 7} are unnecessary with actual orbit counts ({5, 7}: 9·7 = 63 ≤ 66); and "S6 has n even" fails at {2, 3} and {2, 5} (n = 5, 7), so the odd-n clause needs n ≥ 8.
- **Checked numerically first:** actual prime pairs to 6,000, all q: max S6 density 0.11111, no violation of 1/9.

## 27. (BCG) restructured: specification × quantifier

- **Vipul's direction.** Restate (BCG) so that the framework docs and Lean agree, and so that a change of balance points or of quantifier is a change of parameters to one proof, not a new argument. The framework docs say nothing about other applications.
- **`arithmetic-of-density.md` §3.5.3.** New paragraph, "How the statement is organised: a specification and a quantifier". (BCG) is Q n: W_Σ(n). Σ is the per-class table (F, d, window, target); Σ₀ is §3.3.5's table, and the note's (BCG_{1/5}) is another Σ. Q is AL or AA. Consequences: results are proved pointwise and then quantified; the arithmetic half is one argument with Σ as a parameter (minimum of the configuration's polynomials over the window), which is why clause 2 is a window and not "δ ≥ (1 − ε)δ₀"; route comparisons such as (BH-SW)'s are table comparisons.
- **`lean/BCG.lean`.** `Hyp W L`, the filters `atTop` and `almostAll`, `atTop_le_almostAll`, `almostAll_neBot`, and the lift lemmas. The note's specification as `noteWitness`, equivalent to `Note.HypBCG`; its arithmetic half proved pointwise and lifted to both quantifiers.
- **`lean/Sigma.lean`.** Σ₀ as data (`F0`, `d0`); the (BH-SW) six-cell agreement as `decide` on two tables, the second transcribed from `bcp-to-floor.md`'s grid; `xstar` and `balance` for any (F, η); the window lemma and `target` for any window; `window_of_eps` (clause 2's window and (1 − ε)δ₀ forms correspond, for every (F, η)); `pointwise` (exact at one n); `cap_table` (§3.3.5's caps at all twelve classes as the generic cap at Σ₀'s table).
- **`lean/SigmaHalf.lean`.** The arithmetic half for any class specification (`pointwise_half`), and for Σ₀ under either quantifier (`sigma0_half`). The cross terms are handled: the within-class term never binds, and the between-parts term needs 2F·x₋·y₋ ≥ target, which holds for every (F ≥ 1, d ≥ 2) at the ε-window. ε ≥ 0 turned out not to be needed as a hypothesis (for ε < 0 the window is empty and the statement vacuous).
- **`sigma0_mu`.** With Part E as one named hypothesis (`PartE μ`), the μ\* floor statement under either quantifier. So the conditional floor now has exactly three named inputs in Lean: the quantified witness hypothesis, Part E, and (for the upper side, elsewhere) Part 0.
- **Next.** Part E itself, starting with F = 1.

## 28. Cross-check: Lean scoring model against the Python scorers

- **Why.** In the residual-risk assessment, risk 4 was that Lean's `E6.Config` SAFE/REFINED might not be the functions the table scripts compute, which would make the Lean theorems true of a different model.
- **`scripts/lean_score_crosscheck.py`.** Random configurations; compares the **full sorted term lists** (the minimum alone hides non-binding mis-scores) of Lean's SAFE and REFINED against `mu_enumerate_v3.value` in both modes, and `validate_table_v3.score` against `mu_enumerate_v3`. Lemma C is passed to Lean as d = strip(c − 1, foreign primes), as the enumerator applies it; foreign twists as the full q-part (R2).
- **Result.** 8,000 configurations, 0 mismatches (Lemma C changing a term in 2,750 of them); validator 20,000, 0 mismatches. Mutation control (no 2 | t halving in `orb`) caught in both comparisons.
- **Not covered:** `mu_ladder_exact.py` (its own inline scorer; cross-checked against the exact table under R0), D2 parts (the scripts skip them), `Note.lean`'s note-specific values. Added to `pending-checks.md` R6's rerun recipe.

## 29. Lean: Part E for F = 1

- **`lean/PartE1.lean`.** Realisability for one unfused class 𝔽_c (full twist) beside one foreign block ℤ/r with twist of odd prime order q.
  - The group: K's affine group alongside z ↦ u·z + v on ℤ/r, u in the order-q subgroup U of (ℤ/r)ˣ, built as a product of `Aff1` groups and mapped into Perm(K ⊕ ℤ/r).
  - The Oliver chain, on the abstract group and then pushed to the permutation group: translations of K (p-group by characteristic p) ◁ trivial ℤ/r-multiplier (layer ≅ Kˣ × ℤ/r, cyclic by CRT on an explicit generator; this is exactly where r ∤ c − 1 is used) ◁ G (q-group on top).
  - Orbitals: C(c,2) inside K, c·r mixed, ≥ q·r inside ℤ/r (−1 ∉ U since q is odd). So every pair-orbital is ≥ SAFE = REFINED.
  - `sigma0_F1_realised`: Σ₀'s floor at the even classes, under either quantifier, with Part E proved.
- **SigmaHalf refactor:** `cfg_half` (explicit-witness form of the pointwise half) and `spec0_eventually` split out so `PartE1` can reuse them; `pointwise_half` and `sigma0_half` unchanged in statement.
- **Next.** F ≥ 2: the fused class (blocks permuted transitively) and, for F_mid > 1, the entangled generator; the binding class 11 is F = 4.

## 30. Lean: Part E for F ≥ 2, and Σ₀'s floor with Part E proved

- **`lean/PartEF.lean`.** The fused class with F_mid = F, by the entangled generator zc: (i, x) ↦ (i + 1, x), wrapping with ×ω. Power formula zc^j(i, x) = (i + j, ω^⌊(i+j)/F⌋·x), so zc^F is the full twist.
  - Group ⟨T, γ, μ(U)⟩ defined by generators; chain T ◁ ⟨T, γ⟩ ◁ G. Layer cyclic by closure induction (generated by γ over T); top a q-group via the decomposition g = μ_u·n. Coherence r ∤ F(c − 1) enters exactly once, to put ρ_v in N₁ (CRT on a power of γ), which is what makes N₁ normal under μ.
  - Orbitals: F·C(c,2), ≥ K0·c² (rotation orbit of a block pair: F for odd F, F/2 for even F — the text's parity-of-F rule, here proved for this construction), F·c·r, ≥ q·r.
  - `PartEAll.sigma0_realised`: Σ₀'s floor at all twelve classes, under either quantifier, with Part E proved. Σ₀ uses only F ∈ {1, 2, 4} with r = dq + 1 ≥ 7, so r ∤ F is automatic.
- **Scope.** Only the two-part shapes Σ₀ needs. Not formalised: several classes, several foreign parts, F_top > 1 (block permutation in the top q-group), q = 2.

## 31. Lean: the threshold beyond μ\*, conditional on KSS/Oliver

- **New files.** `CycGood.lean` (χ-tables for C_1, C_2, C_3, C_6 by `decide`, from Python-generated literals each checked in Lean), `Evasive.lean` (abstract down-closed properties, `HypKSSOliver` as a named structure hypothesis, the single-good-type Proposition), `RGlue.lean` (the ℤ/r block's C(r,2) pairs split into exactly k orbit types when r − 1 = 2qk), `Threshold.lean` (`thr_1`, `thr_F`, `thr_bound`, `thr_realised`).
- **Statement.** `thr_realised`: under `BCG.Hyp (WT ε) L` with L ≤ atTop, L-eventually there is a vertex set of size n and m with 2m ≥ ((1 − ε)·δ_cyc − κ/n)·n(n − 1), δ_cyc = 1/4 (even n) or 3 − 2√2 (odd n), such that for every evasiveness predicate satisfying `HypKSSOliver`, every property with e_max < m is evasive.
- **Design.** A parameter change, as planned: `specEps (FT a) 2 ε` reuses `specEps_good`, `window_of_eps`, `cap11`, `cap21`; the groups are Part E's. No framework document mentions it.
- **Scope / not formalised.** KSS/Oliver itself; the witness hypothesis `WT` (r = 2kq + 1 prime, q > 7 prime, in the window — a (BH-SW)-type input); the upper half of Proposition L; Proposition U. The good-k table is used only for k ∈ {1, 2, 3, 6}.

## 32. Skipped checks from §31, and Lean: the covering statement (§6's ⇒ direction)

- **§31's skipped checks, now done.**
  - The Lean k table (`kT`, `FT`) against `threshold-beyond-mu.md`'s ceilings table and cell list: all twelve classes agree (k = 1 at 0, 1, 4, 6, 9, 10; 2 at 3, 7; 3 at 2, 5, 8; 6 at 11; F = 1 even, F = 2 odd; d = 2k).
  - `HypKSSOliver` read against KSS + Oliver: the fixed complex is the complex on orbitals whose unions lie in P (KSS's reduction), and χ ≡ 1 (mod q) for every Oliver chain; with a trivial top, every q is allowed, so it gives χ = 1 exactly, as Oliver's theorem says. The faithfulness looks right.
  - The commit touched no framework document.
  - One deliberate strengthening: `WT` asks for q > 7 where the text needs q ∉ {2, 5, 7}. This costs only q = 3, a density-zero restriction.
- **`lean/Cover.lean`.** `cover_hyp`: SAFE floor δ > 1/25, L-eventually ⇒ `ShapeD δ (min 15 Fmax)` L-eventually, whenever cap_{Fmax+1}(1) < δ. Instances: `cover_25`, `cover_16` (F ≤ 8, no S11), `cover_9` (F ≤ 3, no S6/S11) — §6.4's counts 13/13, 4/5 and 1/2 once parity (`parity_one`, `parity_two`) is applied and the escapes are set aside.
- **Findings.**
  - The floors are strict in Lean. The text's "at or above 1/9 only F ≤ 3" claims the boundary too. `fbound` gives δ ≤ (n/(n−1))²·cap_F(1), so at δ₀ exactly cap_F the shape F is not excluded by this argument. *Checked numerically (Python, two-term bound min(F·C(c,2), C(r,2)) for n = F·c + r):* F = 4 never reaches C(n,2)/9 for c < 1500, nor F = 9 C(n,2)/16, nor F = 16 C(n,2)/25. So the boundary claims look right for the one-foreign shapes, but a proof at equality is not in Lean.
  - The escapes drop only at density one. Their count, ≍ x/log x, exceeds (AA)'s O(x/(log x)^A), so §6.6's "for most n" must mean density one, not the (AA) rate, on the conclusion side.
  - The hypothesis is on B_safe; reading it for μ\* needs Part 0.

- **Follow-up: closed floors.** New lemma `fexact`: for F = s², s ≥ 1, a class F·c beside a part of size m in n ≥ 2 points cannot both be worth δ·C(n,2) once δ(1 + s)² ≥ 1. This is proved for all n (not just large n), with no numerics, and turns the Python check above into a theorem for the F-bounds. It gives `cover_16_closed` (δ ≥ 1/16: F ≤ 8) and `cover_9_closed` (δ ≥ 1/9: F ≤ 3, no S11). Still open at the boundary:
  - δ₀ = 1/25 itself (Proposition 1 needs strict);
  - S6 at exactly 1/9 and S11 at exactly 1/16: `TwoForeign`'s ceilings are non-strict, and the two-term min is not enough to decide equality there.
- **Follow-up: the escapes counted (`lean/CoverDensity.lean`).**
  - `ShapeD`'s S2 escape now carries F ≤ 25, from the class's own ceiling δ·C(Fc,2) ≤ F·C(c,2) with δ > 1/25.
  - `esc_count`: the escapes (primes, and F·p^b with F ≤ 25) number O(x/log x) up to x. This uses Mathlib's `Chebyshev.pi_le_log4_mul_div`, plus an elementary count of the proper prime powers, ≤ (√x + 1)(log₂ x + 1).
  - `cover_foreign`: a floor δ > 1/25 holding under (AL) or (AA) forces a system with a foreign part outside O(x/log x) exceptions.
  - This makes §6.6's "for most n" precise on the conclusion side: the rate is x/log x, which is sharp for this route.
- **Follow-up: the two-foreign ceilings are strict.** `TwoForeign`'s check is now parametrised by the slack k in `PartH2`. With k = 1 it proves `two_foreign_lt` (one of the two primes has 18·orb < R(R − 1)), and hence `s6_ceiling_lt` (9·SAFE < C(n,2)) and `s11_ceiling_lt` (16·SAFE < C(n,2)). `ShapeD` now requires δ < 1/9 for S6 and δ < 1/16 for S11. So `cover_16_closed` (δ ≥ 1/16) excludes S11, and `cover_9_closed` (δ ≥ 1/9) excludes S6 and S11. The only boundary still open is δ₀ = 1/25 itself.

## 33. Lean: toward Proposition U_typ (the upper side, up to μ\*_N^fpf)

- **`lean/Upper.lean`.**
  - Definitions, after `threshold-beyond-mu.md` §1.4: N\*(Γ) (permutations carrying orbitals onto orbitals), N\*-invariant complexes on the orbitals, Γ's χ condition (Oliver's congruence for every chain, as in `HypKSSOliver`), m\*_N(Γ) (level 1) and m\*_typ(Γ).
  - `evasive_below_mN`: under `HypKSSOliver`, every property with e_max < m\*_N(Γ) is evasive. So μ\*_N^fpf is a certified threshold, and the ceiling question is an upper bound on m\*_N.
  - `mN_le_total`, `mN_le_mtyp`: the full simplex on any nonempty N\*-invariant set of orbitals has χ = 1.
  - **Step 1** (`Nstar_orb`): for fixed-point-free Γ, N\* permutes Γ's orbits; N\* is a group containing Γ. The proof goes through Γ̂, as in the text.
  - **Step 3** (intransitive Γ):
    - per-class bound m\*_N ≤ F·C(a,2) (`mN_le_class`);
    - classes partition the points and W = Σ over classes of √F (`W_eq`);
    - **exact** bound 2·m\*_N·W² < n(n − 1) at every n for intransitive Γ (`mN_lt_intrans`). This is stronger than the text's asymptotic form; the boundary W = 2 and W = 1 + √2 cases come out strict for free.
  - Consequences: m\*_N ≥ C(n,2)/4 ⇒ one class of F ≤ 3 (`intrans_quarter`); m\*_N ≥ (3 − 2√2)C(n,2) ⇒ one class of F ≤ 5, or two classes each one orbit (`intrans_silver`).
- **Plan for the rest.**
  - Step 3's residuals: Step 2 (a 2-homogeneous type forces a prime-power orbit; the almost-simple half to enter as a named hypothesis), the halving when intra-orbit pairs split into two or more types, and E.
  - Step 4: the block-system analysis for N\* imprimitive.
  - Step 5: Conjecture P as a named hypothesis.
  - The text's Step 3 bullet "single class (n = F·a, a a prime power, F ≤ 5)" includes F = 1, the transitive case, which Lean routes to Steps 4 and 5. With the exact Σ√F bound, an intransitive single class has F ≥ 2.
- **Follow-up: Proposition U_typ, conditional.**
  - `mN_half`: when the orbitals inside an N\*-invariant pair set are not a single type, the complement of a proper invariant subset is invariant too, so 2·m\*_N ≤ the set's size.
  - Step 2 and Conjecture P enter as the named hypotheses `HypStep2` and `HypConjP`.
  - `intrans_even` and `intrans_odd`: the intransitive case lands in E. The text's two-orbit argument maximises min(s₁²/2, s₂²) continuously. In Lean the discrete boundary is strict (`two_orbit_strict`), and the second clause's ">" comes from the irrationality of √2 (`silver_irr`).
  - `Utyp_even` and `Utyp_odd`: m\*_N(Γ) < δ_cyc(n)·C(n,2) for every fixed-point-free Oliver Γ, for n not a prime power and n ∉ E.
  - `UpperDensity.E1_count`: E's first clause lies in the escape set of `CoverDensity`, so it is O(x/log x).
- **Notes for the text.**
  - (i) §6.3 calls U_typ "unconditional for intransitive Γ". The intransitive argument does use Step 2 (a 2-homogeneous type forces a prime power), whose almost-simple half rests on the socle check. Lean makes that dependence explicit. *Not checked:* whether the intransitive case can avoid Step 2 by using solvability of Γ alone, as Proposition U does for μ\*_cyc (Huppert/Kantor). It may well, since there the 2-homogeneous group is a constituent of the soluble Γ itself, not of N\*.
  - (ii) The statement needs n not a prime power: at a prime power, AGL(1, p)-type groups are 2-transitive.
- **Follow-up: Step 4 proved.**
  - `BlockSys` is an N\*-invariant partition into blocks of one size b ≥ 2. The intra-block pairs give m\*_N ≤ m·C(b,2) (`mN_le_blocks`).
  - `step4`: either they split, and the halved bound falls below δ_cyc (at odd n, m is odd, so m ≥ 3); or they form a single type, and b is a prime power (`HypStep2Block`, "Step 2 with the block in place of an orbit"), which puts n in E's first clause.
  - The text's first bullet (m ≥ 4 even, m ≥ 7 odd) isn't needed, since the single-type case lands in E for every m.
  - `trans_E1_steps`, `Utyp_even_steps` and `Utyp_odd_steps` state U_typ with Conjecture P replaced by `HypStep5` (P for N\* primitive) and Step 2 for blocks.
- **Follow-up: E counted.** `UpperDensity.E2_count`: at odd n, E's second clause has one summand even, hence 2^j. The window forces the other summand m ≤ 4·2^j (for δ ≥ 1/6). The count is at most Σ_{j ≤ log₂ x} #pp(2^{j+2}) ≤ Σ K·2^{j+2}/((j+2) log 2) + K. With Σ_{j≤J} 2^j/(j+2) ≤ 4·2^J/(J+2) (`geom_sum`, by induction), this is O(x/log x). Together with `E1_count`, E is O(x/log x), as §6.3 states. Nothing else is needed for U_typ's density-one form beyond the three named hypotheses.
- **Follow-up: the density-one ceiling.** `UpperDensity.ceiling_density` assumes `HypStep2`, `HypStep2Block` and `HypStep5` at every degree, and concludes that `Ceiling n` holds outside O(x/log x) exceptions. `Ceiling n` says every fixed-point-free Oliver Γ on n points has m\*_N(Γ) < δ_cyc(n)·C(n,2), i.e. μ\*_N^fpf(n) < δ_cyc(n)·C(n,2). The failure set lies in the escapes (prime powers, and E1 at δ ≥ 1/6), E2 at odd n, and {0, 1}. With `thr_realised`, which gives the lower half at the level of evasiveness itself, this gives the upper and lower halves of μ\*_N^fpf/C(n,2) → δ_cyc(n) on a density-one set, conditional on the named hypotheses (KSS/Oliver and WT for the lower half; Steps 2 and 5 for the upper).

## 34. Lean README cleanup, and Part 0 begun

- **README pass** (commit a6268a4): statuses brought up to date. The open items are now in one list ("Open, as of 2026-11-26").
- **`lean/Part0.lean`**, toward μ\* ≤ B_safe.
  - `orbLe_safe` (Part A's assembly): if Γ realises a configuration, some orbital of Γ is at most SAFE. "Realises" means: Γ-invariant, pairwise disjoint, nonempty point sets of the parts' sizes, each part's own SAFE terms bounded below by orbitals. Cross terms come for free (`cross_orbLe`).
  - `blocks_orbLe`, `pc_terms`: a class's terms from its block system (the flat cap F·C(c,2), and the within-class cross term ≥ F·C(c,2)).
- **Interface finding.** `GAdm` requires distinct foreign primes. A real Oliver group may have several orbits with outside blocks of the same prime r. The text handles this by Lemma D2's non-permuted case (Part D2, the remark after the proof; Part E's admissibility bullet): they share a diagonal C_r, and the same-position class has C(F,2)·r pairs. In Lean, `FoBridge` covers only a single transitive fused orbit. So Part 0 needs D2 for a union of orbits of one prime, permuted or not, with r = q handled by D2q per orbit. The remaining Part 0 steps are listed in the README's "Open" list.
- **Part 0, step 2 done (`lean/Part0Fr.lean`).** `fr_orbit`: an orbit of prime size r ≠ p of an Oliver group has an orbital of at most orb(r, q^f) pairs, for some q^f ∣ r − 1. It is proved from the chain alone, with no hypothesis.
  - Lemma B for prime blocks gives the affine form.
  - The multipliers form a subgroup `mulGp` of (ℤ/r)ˣ, of order t ∣ r − 1. By Lemma B′, every element has a q-power power in the order-r normal subgroup, whose multipliers are 1 by Fermat; so t = q^f.
  - The orbital of {0, 1} lies in {s(b, b + u)}, at most r·t pairs. At even t, −1 is a multiplier, so each pair is hit twice and the bound is r·t/2. The cap C(r,2) is counted separately.
  - Transport from an invariant set of Γ to a model type (`resHom`, `orbit2_res_le`, `res_transitive`) is in place for the remaining steps.
- **Part 0, more pieces (`Part0.lean`).** `fixed_orbLe`: a fixed point gives an orbital of at most n − 1. `exists_least_block`: a least block of size ≥ 2 exists in any invariant set of size ≥ 2. `blockSys`: its images, of one size, permuted by Γ, pairwise equal or disjoint. `pc_terms_of_set`: a class's SAFE terms from that block system.
- **Part 0, step 1 done.**
  - `blockSys_card`: a least block's images tile a transitive orbit, so |O| = F·|B|.
  - `stab_primitive`: the setwise stabiliser of a least block acts primitively on it. A nontrivial block of the stabiliser on B lifts to a block of Γ strictly inside B, contradicting leastness.
  - `chainSub`: the chain passes to the stabiliser.
  - These are the inputs Lemma B′ and the Huppert hypothesis take.
- **Part 0, step 4 done.** `block_kind`: a least block of an orbit has size a power of p, or a prime r ≠ p. The second branch is Lemma B′, applied to the primitive block stabiliser; the first takes `HypHuppert` (p ∣ degree of a primitive Oliver group ⇒ the degree is a power of p), a named hypothesis standing for "a solvable primitive group is affine".
- **Plan for step 3, simpler than re-running D2.**
  - A fused outside orbit is covered by `FoBridge`, after transport.
  - At r = q, each orbit is worth q by `fr_orbit`.
  - The new case is two unfused orbits of one prime r ≠ q. The stabiliser Γ_x of x ∈ O₁ acts on O₂ through a q-group: the q-power power of each element is trivial on O₁ and a translation on O₂, and a nonzero translation there would make a non-cyclic r-subgroup. So Γ_x fixes some y ∈ O₂, since r ≢ 0 (mod q). Then g·x determines g·y, and the orbital of {x, y} has at most r pairs.
  - This is the text's same-position class, reached by a fixed-point count instead of Step 2's change of origins.
- **Part 0, step 3's new case done (`two_orbits`), from the chain alone.** For O₁, O₂ orbits of one prime r ∉ {p, q}:
  - Take g fixing x ∈ O₁, and h := g^(q^K). Then h is trivial on O₁ (its multiplier has q-power order, and it fixes a point), and h^r is trivial on O₂ (a translation).
  - If h were nontrivial on O₂: its r-part h₁ lies in a Sylow-r subgroup P, which is cyclic (`rsub_cyclic`). P's generator w moves O₁, since otherwise r would divide [Γ : P]. So h₁ = w^j with r ∣ j, and w^r is trivial on O₂, so h₁ is trivial on O₂; hence h is too, a contradiction.
  - So the stabiliser of x acts on O₂ as a q-group, and fixes some y, since r ≢ 0 (mod q). The orbital of {x, y} then has at most r pairs.
  - Helper lemmas: `orbit_coords` (affine coordinates on a prime orbit, multipliers of q-power order), `mul_qpow`, `affine_rpow`, `hasMul_one_pow`, `hasMul_one_fix`.
- **Part 0 assembled (`lean/Part0Fo.lean`, `lean/Part0Main.lean`).**
  - `fused_orbit`: a fused outside orbit is relabelled as Fin F × ℤ/r with blocks {i} × ℤ/r (`fusedEquiv`), and `FoBridge` gives D2's `fo` terms.
  - `part0`: for an Oliver group Γ on n ≥ 2 points, either Γ has a fixed point (then an orbital ≤ n − 1), or the configuration read off Γ is admissible, has n points, and has SAFE ≥ one of Γ's orbitals. The configuration is:
    - a class `pc F c (c − 1)` for each orbit whose least block has p-power size c;
    - for each outside prime r, one part over all orbits with r-blocks: `fr r t` when that is a single unfused orbit, else `fo F r 1` with F the total number of r-blocks.
  - The `fo` part's same-position term is bounded by:
    - `fused_orbit` when some orbit is fused;
    - `two_orbits` when there are ≥ 2 unfused orbits and r ≠ q;
    - `fr_orbit` with t = 1 when r = q.
  - Distinct foreign primes hold by construction, which is the text's justification made formal. `part0_Bsafe` is `E6.e6`'s `hcap` (μ ≤ B_safe) wherever B_safe(n) ≥ n − 1.
  - **The only input beyond the chain is `HypHuppert`.**
- **Checked against the text (Part 0, steps 1–3):**
  - the copy count is unrestricted (F any integer, as the n = 308 gotcha requires; no coprimality is used);
  - the class term is the flat cap F·C(c,2);
  - the within-class cross term is never needed beyond F·C(c,2);
  - Lemma C is not used anywhere.
- **Not done (done in §35):** the fixed-point disjunct's domination; a Lean definition of μ\*(n).

## 35. Lean: μ\* as a number, and Part 0 wired into E6 and Cover (`Part0Mu.lean`)

- **The fixed-point disjunct is dominated at every n ≥ 2, not just "except at tiny n"** (`Bsafe_ge`). For n = 2 take any admissible configuration; otherwise n has a prime-power divisor c = p^b ≥ 3, and the one-class configuration ⟨p, 2, [pc F c (c − 1)]⟩ with F = n/c is admissible with SAFE ≥ n − 1. So `part0'`: every Oliver group on n ≥ 2 points has an orbital ≤ SAFE(C) for some admissible C on n points.
- **μ\*(n)** (`muStar`): sSup over Oliver Γ ≤ Sym(Fin n) of the least orbital (`minOrb`, an sInf; bounded by C(n,2), `minOrb_le_pairs`; attained once positive, `muStar_attained`).
- **μ\*(n) ≤ B_safe(n)** (`muStar_le`, given `HypHuppert`).
- **Wiring:** `e6_mu` (E.6 with μ\* in place of the abstract μ; superseded by `PartEMu.e6_mu` in §36); `floor_of_mu` (a floor δ·C(n,2) ≤ μ\*(n) is a SAFE floor `Cover.Floor δ n`; when μ\*(n) = 0 the floor is vacuous and `Bsafe_ge` supplies C); `cover_mu`, `cover_foreign_mu` (`Cover.cover_25` and `CoverDensity.cover_foreign` with hypothesis on μ\*).
- **Checked:** full `lake build` clean; no `sorry`/`axiom` in the new file; the only hypothesis is `HypHuppert` (a structure).
- **Still open on Part 0:** only (optionally) proving `HypHuppert`.

## 36. Lean: Part E beyond the two-part shapes, and μ\* = B_safe above 1/25 given only `HypHuppert`

- **Scoping finding.** `PartE μ` (every admissible configuration realised at its REFINED score, as `E6.e6`'s `hconstr`) is stronger than any construction delivers: fallback configurations at full twist (Lemma C), `fo` parts (D2 upper bounds), and a foreign prime r ∣ F·(c − 1) (the entangled carrier cannot be coprime to r, so the foreign twist dies) are not realised at that score. So the target became: realise one optimum.
- **`PartEG.lean`:** the construction for one class (F ≥ 1, full twist) beside any number k of foreign blocks of distinct primes, any q (q = 2 included), coherent. CRT (`ZMod.prodEquivPi`) puts every foreign translation vector in ⟨γ⟩. Orbitals inside ℤ/rⱼ: ≥ orb(rⱼ, |Wⱼ|), from injectivity (−1 ∉ Wⱼ) or a 2-to-1 count.
- **`PartEMu.lean`:** `mu_ge` (any Oliver group on n points with orbitals ≥ m gives μ\*(n) ≥ m, transported to `Fin n`); `real_le_mu`; `e6_real` (the SAFE optimum above 1/25 can be taken realisable; the r ∣ F case is n < 73 and closed by a kernel-checked single-class witness table at n = 6, 9, 12, 15, 20, 28); **`e6_mu`: μ\*(n) = B_safe(n) = B_refined(n) above 1/25, given only `HypHuppert`**.
- **`E6.lean` edits:** `d2_case` also returns that its witness is D2-free (`foB`, decided); `e6_of_view` returns the bare-pair re-reading explicitly. `Part0Mu.e6_mu` (which took `hconstr`) removed as superseded.
- **Brute force before building:** over the E.6 scoring model (≤ 4 parts), the best realisable configuration ties the unrestricted SAFE optimum at every n ≤ 60.
- **Open for the text:** whether the enumerator's shape space admits a foreign prime dividing F_mid. If it does, the realisability paragraph's "every admitted configuration is realised" fails for those configurations as stated (its own construction needs the carrier coprime to the foreign primes). E.6 is unaffected (checked: such shapes reach the line only at n < 73, where single-class witnesses beat them).
- **Still open on Part E:** several classes; `SigmaHalf.sigma0_mu`/`E6.e6` still state the over-strong `PartE μ`.

## 37. Part E: several classes, and the over-strong hypothesis removed

- **Text finding (Part E realisability).** Two classes share the one cyclic-layer carrier (two independent entangled generators would make the layer non-cyclic), so their block rotations are coupled and the between-class orbital is lcm(Fᵢ, Fⱼ)·cᵢcⱼ = sᵢsⱼ/gcd(Fᵢ, Fⱼ), not sᵢsⱼ as the text said ("the translations of distinct orbits act independently"). Direct orbit computation: two classes of two blocks over 𝔽₃ and 𝔽₉ (n = 24) give 54 against 108. **The scores stand**: the orbital is ≥ Fᵢ·cᵢcⱼ ≥ Fᵢ·C(cᵢ,2) for the smaller-block class, so it is never the minimum. Corrected in `enumeration-proof.md` Part E (new box after the parity pitfall), with the matching comments in `mu_enumerate_v3.py` and `audit_fmid.py`.
- **Second scope note in the same box:** the construction needs foreign primes coprime to every Fᵢ·(cᵢ − 1). The enumerator admits r ∣ F_mid by a counting argument; above 1/25 (every computed n) the SAFE optimum can be taken realisable regardless (`PartEMu.e6_real`, `badOK_all`).
- **Lean:** `PartEG.lean` now builds any number of classes beside any foreign blocks (`partE_M`, `cfgM`, `orbit_CC`); `PartEMu.RealCfg` and `real_le_mu` are multi-class. The blanket Part E hypothesis is gone: `E6.e6` and `SigmaHalf.PartE`/`sigma0_mu` deleted; `PartEMu.sigma0_muStar` gives Σ₀'s floor on μ\* itself from the explicit groups (no hypothesis beyond the witness hypothesis).
- **Still open on Part E:** reduced twists (REFINED below SAFE) and configurations with a foreign prime dividing some Fᵢ·(cᵢ − 1); neither affects a computed n.

## 38. Lean: the vertex-transitive Oliver-resistance threshold (and the BBKN-type bound)

- `VertexTransitive.lean`: μ\*_vt(n) (largest least orbital of a transitive Oliver group, the threshold of vertex-transitive Oliver-resistance) = n(q(n) − 1)/2 (`muVT_eq`). Upper half via a least nontrivial block, which is a prime power by `Part0Fr.block_kind` (`HypHuppert`); lower half unconditional, from the transitive fused class of `PartEG`. Then μ\*_vt ≤ μ\* gives μ\*(n) ≥ n(q(n) − 1)/2 unconditionally (`muStar_ge_qmax`). This was the README's "BBKN replacement" item.
- Framework text: `orbital-evasiveness-notes.md` §7.2 fact 8 now records the Lean status.

## 39. `pending-checks.md` brought up to date with the Lean results; R0d (the table against the Lean model)

- **Out-of-date items updated** (status, not history): "the two tables" now names `PartEMu.e6_mu` as the Lean form of "each value is μ\*(n)"; gap inventory items 1 (Part 0, proved given `HypHuppert`), 4 (E.5), 6 (Lemma B′) and 7 (Proposition 1, whose owed second reading the Lean proof discharges) record their machine checks; residual risk 1 (GAP stages) is now "the only *unconditional* non-circular check", and risk 2 (Part E realisability) is superseded by a proof at every n above 1/25; R8 is now described as a cross-system GAP build rather than "the only leg with no per-n check"; T2 and A34 item 1 point to the Lean results.
- **New R0d, `scripts/lean_model_max.py`:** the Lean model's B_safe(n), maximised directly over the family Proposition 1 reduces to above the line with the Lean scoring, against the ladder table's `mu_bound`. `lean_score_crosscheck.py` compared scorers term by term; this compares the maxima row by row, so `e6_mu` is shown to be a statement about the table's numbers. **All 17,671 rows n ≤ 20,000 agree**, and windows [10000, 10500] and [100000, 100100]. Control: dropping the q = 2 halving in `orb` gives 17 mismatches to n = 1000 (dropping K0·c² changes nothing, correctly: it never binds). A 21-row window near 10⁶ did not finish in 50 minutes; reaching 10⁶ needs the ladder's pruning (optional, noted in R0d).
- **Lean:** `PartEMu.Bsafe_le_mu` — μ\*(n) ≥ B_safe(n) above 1/25 with no hypothesis; `e6_mu` uses it, so `HypHuppert` is needed only for the upper bound.

## 40. Lean: the k-uniform orbit law for prime blocks

- `KUniform.lean`: for c prime, 1 ≤ k < c and a twist W ≤ 𝔽_c^× of order d, the least orbit of a k-set under {x ↦ ux + v : u ∈ W} is exactly c·d/θ_k(d), where θ_k(d) is the largest j dividing d and dividing k or k − 1 (`orbit_law`). This is `three-uniform-note.md` §2.1 at every k, with `general-k-note.md` §2.2's corrected θ. No hypotheses; axioms are the standard three.
- The lower bound goes through the stabiliser (no translation, so it embeds in W, it fixes a point, and it acts freely off that point) and orbit–stabiliser. Attainment takes t cosets of the order-θ subgroup of W, with 0 added when θ ∤ k.
- Side observation: the C(c,k) cap in the §2.1 statement is never needed, since an orbit is at most C(c,k) anyway.

## 41. Lean: AΓL(1, 2^p) is free on 3-sets, and the Mersenne condition is not needed for that

- `Mersenne.lean`: for a finite field of characteristic 2 with 2^p elements, p prime ≥ 5, a semilinear affine map x ↦ u·x^(2^i) + v that stabilises a 3-set is the identity (`free`, `free_galois`). This is the freeness half of `three-uniform-note.md` §2.2.3's proposition. No hypotheses; axioms are the standard three.
- The proof does not use primality of 2^p − 1. It works through g⁶ (fixes the 3-set pointwise, hence trivial), the absence of order 3 (3 ∤ 2^p − 1 for odd p), and order 2 being a translation. So freeness, and the orbit size 2^p(2^p − 1)p, hold at every prime p ≥ 5.

## 42. Satellite-note corrections prompted by `KUniform` and `Mersenne`

- **`three-uniform-note.md` §2.1.** The C(c,3) cap never binds: an orbit is at most C(c,3), so c·d/κ ≤ C(c,3) automatically. The old claim that it binds for c ≤ 7 compared C(c,3) with c·d rather than c·d/κ. The "general shape" box used κ_k(d) = max{m ≤ k : m | d} and a min with C(c,k). It now states orb_k = c·d/θ_k(d) with `general-k-note.md`'s θ_k, which is what `KUniform.orbit_law` proves. The naive κ_k is wrong from k = 5.
- **§2.2.3.** The proposition now asks only that p ≥ 5 be prime. The direct proof's order-M step now covers any prime ℓ | M, and the "three prime divisors" claim is replaced by 3 ∤ |AΓL(1, 2^p)|. "What the Mersenne condition adds" said the condition makes d = c − 1 coprime to 6. That is false as a distinction: 2^p − 1 is coprime to 6 for every odd p. The paragraph now says the condition adds nothing here. The Jones–Zvonkin paragraph is weakened to match: both families sit at 2-power degrees, outside Bateman–Horn, but no Mersenne primes and no Lenstra–Pomerance–Wagstaff count are involved. Name-dependent references now say "the c = 2^p family".
- **§6.1** dropped "Mersenne-adjacent in the twist condition, thin even among those"; for odd a the twist condition is automatic. Its block list (32, 128, 2048, 8192, …) already included non-Mersenne exponents.
- **`literature-findings.md` item 20** has its §2.2.3 cross-reference corrected the same way.

## 43. Lean: the AGL part of Proposition 1 for prime-power blocks, and the cross-orbit fibre bound; §4.1 corrected

- `KUniformPP.lean`: over any finite field of characteristic p, a k-set stabiliser in {x ↦ ux + v : u ∈ W} has order ≤ τ_k·θ_k(d) (`card_stab_le`). Hence orbits are ≥ q·d/(τ_k·θ_k(d)) (`orbit_lower`). This is `general-k-note.md` Proposition 1's bound in the generic case γ_k = m. Joint attainment stays open.
- `CrossOrbit.lean`: #(G·S) ≥ #(G·(S ∩ A))·#(N·S) for G-invariant A and N fixing A pointwise (`cross_orbit`).
- **`three-uniform-note.md` §4.1's three-line proof was flawed in two places.**
  - It counted s′ (the third point's whole part) choices of the third point, which needs the pair's pointwise stabiliser to be transitive on that part. The fibre that is guaranteed is the third point's block c′, through that block's own translations.
  - It closed κ₃ = 1 with "s′ ≥ r ≥ 5 > a", which is false for every Galois block (a ≥ 5), and compared against m rather than the gain ℓ = lpf(a).
  - Redone: the comparison needs c′ ≥ 2ℓ/κ₃. That holds for foreign blocks (r ≥ 2q + 1 with q | a) and for blocks of the same class. It is **open** for a third point in a different matching class of small 2-power blocks next to a Galois block.
- **The claim fails for Oliver groups in general**: diagonal AΓL(1, 32) plus the swap on 64 points has intra term 9920 but cross orbit 1984 (`scripts/diag_cross_orbit.py`). It is excluded from the note's configurations only because its translations are diagonal.

## 44. §4.1's open case closed

- The case left open in §43 is a pair in a Galois 2^a block with the third point in a separate matching class of 2-power blocks c′ ≤ 2ℓ. Such a configuration is admissible (S12-type). It is closed by applying `CrossOrbit.cross_orbit` with A the small class's part: the pair's block translations fix that part, so the cross orbit is ≥ F′·c′·c/2. That is at least the small class's intra term F′·C(c′, 3) when c/2 ≥ (c′ − 1)(c′ − 2)/6, which holds for every a ≥ 5 with c′ ≤ 2a a power of 2. So min₃ is an intra term in every configuration of the note.

## 45. Lean: three short satellite results

- `SylowTransitive.lean`: `monotone-transitive-note.md` Proposition 2, a Sylow p-subgroup of a transitive group of degree p^a is transitive.
- `Chiral.lean`: `chiral-graph-properties.md` Theorem 1, μ\*(n) ≤ 2·μ\*_chi(n), using `Part0Mu`'s `minOrb` and the subgroup chain restriction `D2Full.OliverChain.comap`.
- `Directed.lean`: `directed-graph-properties.md` Theorem D1, μ\*(n) ≤ μ\*_dir(n).
- All three are hypothesis-free. Each proof matched the note's argument, so no text corrections were needed.

## 46. S9 at k = 3: dominated for F ≥ 3, not at F = 2 — the census was incomplete

- **F ≥ 3.** Lemma D2's diagonal coordinates (k-independent) make same-position triples a class of C(F,3)·r. So a fused foreign class scores at most min(C(F,3)·r, F·r(r − 1)) = O(n^{5/3}), which is below `b3_census` at every n ≤ 2000.
- **F = 2 is not dominated.** Two blocks have no same-position triples, so the pair scores 2·orb₃(r, t, 1).
  - Construction: diagonal translations of the r-blocks in the cyclic layer. The swap goes in the cyclic layer when the matching twist is odd, otherwise in the top with q = 2.
  - Built as permutation groups with exact least 3-orbits: n = 78 = 32 + 2×23\* (q = 11) gives **506**, against `b3_census` 312. Likewise n = 63 and 65 (2×17\*, q = 2) give 272, and n = 221 (127 + 2×47\*) gives 2162.
- **`mu3_menu.py`** scores the shape `1xc + 2xr*`. It raises 77 of 1,666 rows to n = 2000, by up to 1.94×, and `b3_census_2000.csv` is regenerated.
- Notes updated: the §4.2 S9 row, §4.1 (fused pairs inside the fibre argument) and §10 item 1 in `three-uniform-note.md`, plus `pending-checks.md` R12.
- **Still open:** other placements of a fused foreign pair, and whether S9 moves any §5 class ceiling (`ceiling_rederive3.py` doesn't enumerate it).

## 47. S9 and the k = 3 class ceilings

- `ceiling_rederive3.py --s9` adds c + 2r\* to the generic-family scan. To n = 6000 S9 stays below the tabled ceiling in every class. It approaches it in classes 3, 5 and 9 (ratios 0.997, 0.998, 0.999), so it ties the existing ceilings asymptotically there but never beats them. §5's table stands.

## 48. J0a′: statement corrected, one data point

- `general-k-note.md` §1's J0a′ said non-semilinear blocks have minimum k-orbit "no smaller" than AΓL(1, c)'s, which is the wrong direction for "never win". It now says "no larger". The comparator is also now the best semilinear block admissible in the same configuration, since Oliver constraints can cut the semilinear twist.
- Data point: c = 25, k = 3, C₄ ≀ C₂ ≤ GL(2, 5) (order 32, not semilinear) has least 3-orbit 100 against AΓL(1, 25)'s 200.
- The component argument itself is not yet checked. Its reducible branch needs a bound on |H| for Oliver-admissible H, a cyclic normal subgroup with q-group quotient. Wreath-type q-groups such as C₄ ≀ C₂ show |H| can exceed the semilinear q-part, so the argument must bound orbits, not orders.
- **Probe at a = 2, k = 3** (`scripts/j0a_gl2_search.py`): every 2-generated subgroup of GL(2, p) (with or without scalars), p = 3, 5, 7. Oliver-admissibility is tested with chain prime p: O_p(H), plus the q′-generated subgroup cyclic modulo it. Semilinearity is tested as lying in a Singer normaliser. Per top prime q, the best non-semilinear least 3-orbit never beats the best semilinear one: 3/12, 100/200 and 50/200, then 196, 98, 98 against 784. Coverage gaps: 3-generated subgroups, and a ≥ 3.- **a = 3** (`scripts/j0a_a3_probe.py`): every 2-generated subgroup of GL(3, 2) gives at most 24 against 56. Built directly at c = 343 (AΓL(1, 343): 39102): C₃ ≀ C₃ (order 81) gives 1029; 3^{1+2} gives 1029, or 2058 with scalars; ΓL(1, 49) × C₂ (order 192, reducible) gives 343. C₆ ≀ C₃, C₂ ≀ C₃ and ΓL(1, 49) × C₆ are not admissible. No counterexample to J0a′, and the margins are large. A proof remains owed.
- **The note's component sketch for J0a′ was reviewed against these examples, and it has three gaps.** (1) It omits O_p(H) ≠ 1, which occurs (unitriangular). (2) The m > 1 count of k-sets in component translates is about c²/3 at k = 3, level with the target, and exceeds c² at k ≥ 4, so it is not arity-free. (3) The m = 1 branch assumes Q primitive (C₃ ≀ C₃ is monomial) and compares |Γ_B| with c² log c, where the right test is |H| ≤ (c − 1)·m/κ_k. The note now says J0a′ remains open, with a corrected route: irreducible gives semilinear, else an order test or an invariant-subspace stabiliser.

## 49. Wider S9 placements in the k = 3 census

- `mu3_menu.py` now scores a fused foreign pair beside a fused matching class (F×c + 2r\*), beside a further single foreign block (+ r₂\*), and two pairs under one joint swap (+ 2r₂\*). The common top prime divides every r − 1. The matching twist loses the foreign primes, and loses its 2-part when q ≠ 2. Fusion F is credited as in S7.
- 24 more rows rise to n = 2000, by up to 1.38×, and none fall. n = 182 = 2×32 + 2×59\* (q = 29) goes from 1751 to 1984, built and confirmed exactly (`scripts/s9_witness_182.py`). `b3_census_2000.csv` is regenerated.
- Unchecked: the §5 ceilings against these placements, and combinations with three or more foreign parts.
- **Ceilings:** `ceiling_rederive3.py --s9 --s9-wide` (all three placements, generic family, n ≤ 4000): no class exceeds its tabled ceiling.

## 50. J0a′ at k = 3: the reducible case for odd p

- Lemma: for odd p, 3-term progressions are preserved by affine maps, so min₃(V ⋊ H) ≤ c·|H·x ∪ −H·x|/2 for any x ≠ 0.
- With x in a proper invariant subspace this gives at most c(c/p − 1)/2, below the stand-alone semilinear value: c(c − 1)/θ₃ for p ≥ 5, c(c − 1)/6 for p = 3. So reducible H, including O_p(H) ≠ 1, never wins at k = 3 for odd p.
- Open: irreducible non-semilinear H (imprimitive or extraspecial type) at odd p; all of p = 2; configurations where the semilinear twist is cut.
- **Odd p closed.**
  - p = 3: affine lines give c(c − 1)/6 for every block group, equal to AΓL(1, 3^a).
  - p ≥ 5, ±H intransitive on V ∖ 0: a ±-orbit of size ≤ (c − 1)/2 gives min₃ ≤ c(c − 1)/4 < c(c − 1)/3.
  - p ≥ 5, ±H transitive: Huppert's solvable 2-transitive theorem leaves c ∈ {25, 49, 121, 529} with ±H ≤ N(Q₈). Enumeration (`scripts/j0a_c49_exceptional.py`, all subgroups of N(Q₈) at 25 and 49, those containing Q₈ at 121 and 529) gives only ties with AΓL(1, c). The single larger value, 300 at c = 25, is not Oliver-admissible.
  - So J0a′ at k = 3 holds for odd p against the stand-alone semilinear block. Open: p = 2, and cut twists.- Huppert's exceptional list (3², 5², 7², 11², 23², 3⁴) checked against the literature: Passman 1968, Huppert–Blackburn XII.7.3, and recent papers citing it. The citation is now in the note.
- p = 2: Huppert has no exceptions there, so non-semilinear means intransitive on nonzero vectors. The plane-orbit count, c·|𝒫| out of (c − 1)(c − 2)/6 planes, is too weak unless H has about c/2 plane orbits. A stabiliser argument is needed; still open.

## 51. A p = 2 near-counterexample to J0a′, and why it is not one

- `scripts/j0a_gl42_probe.py` (sampled subgroups of GL(4, 2)) found an Oliver non-semilinear H of order 168 with least 3-orbit 112, against AΓL(1, 16)'s 80. It is AΓL(1, 8) acting on 𝔽₂ ⊕ 𝔽₈ by (t, x) ↦ (t, αx^σ + βt). The family 𝔽₂ ⊕ 𝔽_{2^{a−1}} scores 2·min₃(AΓL(1, 2^{a−1})): 112, 160, 9920, 2688 at c = 16, 32, 64, 128.
- **It is reducible, hence imprimitive.** It is the fused class of two 2^{a−1}-blocks (`enumeration-proof.md` B2), which the census already credits with the same value. Scoring it as a separate block in `mu3_menu.py` changed no row to n = 2000 (3×64: 29760 = 6×32), so that change was not kept.
- So J0a′ is about irreducible H (primitive blocks, B1). With `--irreducible` the c = 16 sample has no Oliver-admissible non-semilinear H. The notes now say this; an earlier draft in this session had called J0a′ false.
- Open: irreducible H at p = 2. Huppert says it is intransitive, and an argument is owed.

## 52. J0a′ at p = 2 reduced to one case

- For irreducible H: O₂(H) = 1, so K is odd cyclic; enlarge it by a central C_q so that K ≠ 1.
  - K irreducible: semilinear.
  - K not homogeneous: the 3-sets in component cosets number at most c(c − 1)/3, so H never wins (this also works for odd p).
  - K homogeneous with |L| = 4: 3-sets in L-line cosets number c(c − 1)/3, so H never wins.
- Open: |L| ≥ 8. At c = 64 (𝔽₈²) every 3-subgroup configuration in ΓL(2, 8) was checked (`scripts/j0a_p2_c64.py`), and every irreducible one is semilinear; q = 2 and q = 7 are excluded by hand. So J0a′ at k = 3, p = 2 holds for every prime a and every c ≤ 128. The owed case is |L| = 2^b ≥ 8 with b a proper divisor of a, first at c = 256.

## 53. Status consolidation

- `general-k-note.md` status table, §1 row: J0a′ is now described as for primitive blocks, proved at k = 3 for odd p, and for p = 2 when a is prime or c ≤ 128; open otherwise and at k ≥ 4.
- `three-uniform-note.md` §10: item 2 (the orbit law's stabiliser step) is marked done via `KUniform` / `KUniformPP`. A new item 7 records J0a′'s k = 3 status, and k ≥ 4 becomes item 8. Item 1 already carries the S9 census findings.

## 54. J0a′ at p = 2 pushed to c = 2²¹

- With |L| = 2^b and b even, the equilateral triples {v, v + x, v + ωx} form an invariant family of exactly c(c − 1)/3. This closes c = 256 and every even b.
- H imprimitive over L: the component count again. e = 2: odd-order irreducible groups mod scalars are not absolutely irreducible, so they are semilinear.
- Left: b odd, H primitive over L. Via Suprunenko's structure theory (cited, not proved), the Fitting subgroup is scalars times an extraspecial q^{1+2n} with q | 2^b − 1. First at c = 2²¹ (b = 3, q = 7). The notes' status lines now say "proved below c = 2²¹".

## 55. J0a′ at k = 3, p = 2 closed

- The L-primitive case (b odd) closes by an order count. By the primitive-solvable structure theorem (Suprunenko; checked against arXiv:2204.13375 and arXiv:1612.05959), F = E·U with E extraspecial q^{1+2n}. Here q ≥ 7, because odd-degree fields exclude 3 and 5, and even degree goes to the equilateral argument over 𝔽₂[U]. This gives |H| ≤ c^{1/q^n}·q^{n²+2n}·a ≤ (c − 1)/3 from c = 2²¹ up. So min₃ ≤ c|H| ≤ the semilinear value.
- J0a′ at k = 3 is now proved for every p against the stand-alone semilinear block, modulo Huppert (odd p) and Suprunenko (p = 2), both cited. Open: configurations that cut the twist, and k ≥ 4.

## 56. Readthrough of `general-k-note.md` and `three-uniform-note.md`

- `general-k-note.md` §1's J0a′ box rewritten as current state: statement (primitive blocks, "no larger", configuration comparator), status, the k = 3 proof organised by invariant families and order counts, the p = 2 near-counterexample excluded by primitivity, and a compact list of computational corroboration. The superseded component sketch and its review are removed from the note; they are recorded in §§48–55 here. §6 gains an item for J0a′ beyond the stand-alone k = 3 case.
- `three-uniform-note.md`: the status-table §4 row (S9 found missing; §4.1 proved); §4.1's degree count relabelled a heuristic; the S9 row counts the wider placements; §6.2's soundness remark (orbit law now in Lean; §4.1 by the fibre bound); §7's J0a′ remarks (proved at k = 3, stand-alone); §8's Part D row (D2 only partly transfers).

## 57. E.3(i)'s J0a residue closed for primitive blocks

- The last theorem-side use of J0a at k = 2 is E.3(i)'s reading of orb(c, 2) as an upper bound on the c-block, with c = 3^a = 2r + 1, cyclic-layer image ≤ C₂, and q ≠ r.
  - For a primitive block, H is irreducible, so the order-≤ 2 normal K is central and hence ±1.
  - For q odd, a q-group's orbits on the 2r nonzero vectors force a fixed vector, since q ∉ {2, r}.
  - For q = 2, a ±H-orbit of size 2 exists, since 2r ≡ 2 (mod 4).
  - Either way there is a pair orbital of size c, with no semilinearity needed.
- The gap inventory's item 5 and the J0a bullet in §2a are updated. One reading is owed: that an imprimitive action on the 3^a-orbit is a fused class covered by the shape analysis.


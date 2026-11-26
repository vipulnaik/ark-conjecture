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

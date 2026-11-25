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

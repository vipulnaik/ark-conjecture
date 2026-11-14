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

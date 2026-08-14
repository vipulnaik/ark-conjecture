# Session log 6 — independent read pass, contiguity scoping, and the F = 4 counting rows

*Model: Claude Opus 5 (the session was opened against Fable and routed to Opus by Anthropic's safeguards mechanism; recorded here because T1's argument turns on **which** reader read what). Working set: the three primary documents, `pending-checks.md`, `literature-findings.md`, `small-degree-computation.md`, `three-uniform-note.md`, `solvable-relaxation.md`, `three-part-family-split.md`, and the scripts `eta_derive.py`, `ladder_verify.py`, `count_check.py`, `validate_table.py`, `mu_enumerate_v2.py`, `check_doc_figures.py`, with `mu_table_safe_v4.csv`, `mu_table_safe_v2.csv`, the 10⁶ ladder log and `ladder_weak_v7.txt`.*

## What was read

`orbital-evasiveness-notes.md` §§1–11 in full. `enumeration-proof.md` in full — Part 0, A, B (including the B′ socle proof), C, D, D2, E, E′, E″, F, G, H, I, J. `arithmetic-of-density.md` §§3.1–3.8, 5, 7, 8, and §§1–2 in outline. `pending-checks.md` in full. Not read: `fb_common.py` (absent from the working set), `small-degree-computation.md`, the three companion notes, `literature-findings.md` beyond its structure, and the bodies of `mu_enumerate_v2.py`, `validate_table.py` and `ladder_verify.py`.

## Independent recomputation

- **All 2,233 rows of `mu_table_safe_v4.csv` rescored** from their witness strings by a separately written implementation of the SAFE convention: 0 mismatches, 0 size mismatches.
- **`eta_derive.py` rerun**: 36/36 (class, F) cells agree, 0 ceiling-setting cells splitting across their mod-24 class.
- **Closed forms**: cap₂(1) = 3−2√2, cap₄(1) = 1/9, cap₄(1/2) = (3−2√2)/2, cap₄(1/3) = 7−4√3, cap₄(1/6) = (5−2√6)/2, cap₃(1) = 2−√3 as a slice bound, the identity cap_F(η) = cap₁(Fη)/F, and class 11's 676 > 675 margin.
- **The extraspecial counterexample** E = 3^{1+2} ≤ GL(3,7) rebuilt from scratch: |E| = 27, |Z| = 3, no invariant line, ±E-orbit sizes {18 ×4, 54 ×5} on the 342 non-zero vectors, minimum intra-orbital 3087 — matching Part B's table including the ×9 under-statement rows.
- **E.3(ii)'s group** (𝔽₁₁ ⋊ C₅) × AGL(1,5) built as permutations on 16 points: orbitals {10, 55, 55} = {C(5,2), C(11,2), 11·5}, confirming orb(c, r) = C(c,2) at the safe prime.
- **The 10⁶ ladder log** reconciled against `aod` §5 line by line: every block floor, the untruncated class-(11,23) column, the 46,722 worklist entries against §5.2's decade split, and the global 0.04453 at n = 11183 ≡ 23 (mod 24).
- Worked cases A–F of Part 0, the n = 11819 example, the n = 1425 B₀-vs-B contrast, Theorems 2.1–2.3 including the n = 35 crossover, and the d ∈ {2,4,6,12} map against the η table.

**No mathematical error was found in any structural argument.** B′'s socle step is confirmed correct as written (Step 0 needs irreducibility plus C_G(V) = V; both cases close), as are Lemma C's coupling, D2q's seven steps, E.1–E.4, E″, F.1–F.3 and G.

## Findings and what was done

**Documentation drift, seventeen items, all applied.** The stale density floor 0.026117 at four sites; "eight" ceilings where the table has seven, at three sites; `aod` §3.4's window table keyed mod 12 to superseded caps (recomputed, and its x\* column now reproduces §3.3.5's independently); §5's record-holder described as foreign-bound when it is intra-bound; Part 0 Case F's record-relevance; the "In one paragraph" odd-n clause; the s = 4 box and the Corollary after E.3, both describing a branch that is empty in range; a duplicated `--no-theorems` box with figures from a different run; **a wholesale duplicated Part D2 block whose second copy contradicted the D2q proof above it by describing r = q as open**; 90,297 vs 90,299; Part I's tail part-count split (which did not sum to the size of the set it split); Part I's preamble; two documents disagreeing on the share of odd n below 1/9 (54.3% vs 34.8%, the latter correct) and on the 1/12 split; the `density_floor_conjecture` DUP block, whose copies differed and whose marker enclosed extra commentary; a dangling §3.3.6.

**Contiguity scoping.** The table is a contiguous prefix (every non-prime-power to the frontier) plus worklist rows appended by R7's adaptive runs, which select n *by low ladder score*. Median density 0.1994 below the frontier against 0.0662 above; 0.8% versus 31.9% below 1/16. Pooled aggregates are therefore biased downward — this is what made an independent recount report 33 rows below 1/16 and 20 three-part winners where the documents said 18 and 16. **The documents were right.** `check_doc_figures.py` now detects the frontier itself and computes every aggregate over the prefix, patching back only the floor and its argmin, which stay valid on any superset.

**`check_doc_figures.py`.** Frontier detection; PASS 1 and PASS 2 keyed to the frontier rather than the file maximum; five new SCOPE patterns for the phrasings that carried the stale floor; and a pre-existing bug fixed — `no computed value ... below ([\d.]+)` captured the `1` out of `1/25` and reported two *true* statements as expired.

**Hypothesis (H) restated.** As it stood, clause 1 gave the odd-n shape as n = 2c + r, while §3.3.5 has the ceilings at 7, 11, 15 and 23 (mod 24) attained by S7 at **F = 4**, i.e. n = 4c + r. So (H) did not deliver δ₀ at the two residues that set the global constant 7 − 4√3, and §5's "granting (H), δ(n) ≥ 7 − 4√3 − o(1)" did not follow where it matters most. (H) is now stated over (F, η) from §3.3.5, with d = 2/η — d = 2 at 7 and 15, d = 6 at 11 and 23 — and a separate clause for c ≡ 3 (mod 4), which is automatic at F = 2 and a genuine condition at F = 4. §3.5.4's supporting derivation is scoped to F ≤ 2 accordingly.

**`count_check.py` extended, and three defects found in it.** §3.8's four F = 4 rows were keyed to the superseded F = 2 optima. Re-running them needed fusion counts not dividing D, which surfaced: (1) `roots_mod` computing `g = D//K`, assuming K | D; (2) `_density_integral` missing the integrality factor gcd(D,K)/K; (3) the enumeration modulus l^v not being a multiple of K/gcd(D,K), so at l = 3 with D = 6, K = 4 the residues sampled the mod-2 integrality condition 5:4 and returned 3/4 where the truth is 2/3 — a ratio of exactly 8/9, which was the observed shortfall. **All three are inert at F ≤ 2, so the regression suite over the published rows passed identically before and after each.** What caught them was brute-forcing the local densities inside the new range.

The four rows now read 1.0233, 1.0197 at 7, 15 and 0.8977, 1.0625 at 11, 23, converging two-sided (11: 0.8977 → 0.9964 → 0.9853; 23: 1.0625 → 0.9691 → 0.9924 across [2×10⁵], [5×10⁵], [10⁶]) with sd falling as n^{−1/2}. Written into §3.8, whose run commands now include the F = 4 invocations, so R9 was retired rather than carried.

Also measured, since it bears on (H) clause 4: c ≡ 3 (mod 4) holds at **50.1–50.4%** of solutions at all four residues — an unbiased half, hence a factor 2 in supply and no local structure.

## Lessons worth carrying, in the form this framework's record keeps producing

1. **A regression suite over one parameter range cannot certify another.** Three defects hid behind four exactly-reproducing regression rows. Brute-force the quantity inside the new range instead.
2. **An aggregate over a table whose rows were *selected* is not an aggregate over the range.** The selection rule was "low ladder score", so the bias is toward exactly the values the aggregates are used to reason about.
3. **Duplicated prose diverges silently, and the copy that is wrong is the one nobody re-reads.** Two of this session's findings were a second copy of a block contradicting the first.
4. **A figure that is arithmetic on a moving quantity expires without changing.** The s-bound, the record-holder's binding term, and the class-ceiling caps are all of this kind.
5. **A split must sum to the size of the set it splits**, and a claim about a *mechanism* (which term binds, which engine holds the record) expires as silently as a number but is invisible to a numeric sweep.

## The census and Part I recount

`validate_table.py --baseline` run clean (**23 PASS / 0 FAIL / 12 INFO**), and its `classify` used to recount both censuses and Part I over the contiguous range. Winner counts now read S3 900 (41.2%), S2 777 (35.5%), S7 at F = 2 338 (15.5%) and at F = 4 50, S5 30, S4 16, S6 0, with 53/3/17/2 at F = 3/5/6/8; part counts {1: 777, 2: 1393, 3: 16}; certified_K {2: 394, 3: 1443, 4: 331, 5: 18}; floor 0.045742 at n = 1817, max 0.499807 at n = 2594, median 0.1994. The `enumeration-proof.md` census collapsed from three version columns to one measured column, and both censuses now carry a provenance box stating that these are contiguous-range measurements that move with every extension.

**One thing the recount exposed.** Over the whole CSV the same census gives S7 at F = 4 as 71 rather than 50, and three-part winners as 20 rather than 16 — the worklist tail holding 21 of the F = 4 winners and 4 of the three-part ones out of 47 rows. That is the contiguity bias hitting exactly the shapes the ceiling analysis is about, since the worklist selects low-density n and those are where the fused rungs win.

## Outstanding

De-historicization is complete across all five documents; version references survive only as filenames. The review items in `pending-checks.md` §2 are unchanged by this session except where noted there, and `fb_common.py` remains the largest unread surface.

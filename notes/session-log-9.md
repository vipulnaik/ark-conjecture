# Session log 9 — fresh-eyes review of §§1–6 and the two companions, and the repairs it produced

*Purpose of this file: hold the history, so `orbital-evasiveness-notes.md`, `enumeration-proof.md`, `arithmetic-of-density.md` and `pending-checks.md` can stay dehistoricized. Nothing here is a live claim about the mathematics; every conclusion that survives has been written into one of those files, and this log records **what was read, what was found, what was fixed, what was measured, and what was deliberately not done**, so that none of it has to be rediscovered.*

**Shape of the session.** A cold read (no prior chat context) of `orbital-evasiveness-notes.md` introduction and §§1–6 with §§7+ skimmed, then `enumeration-proof.md` and `arithmetic-of-density.md` in full, with `ep` Proposition F.4 and `aod` §§6.7–6.8 deferred to the end as instructed. Then `pending-checks.md` and `literature-findings.md`, compared against the reviewer's own flag list. Then a second pass over the scripts and outputs supplied mid-session (`fb_common.py`, `ceiling_rederive.py`, `fallback_cert.py`, `wide_cert.py`, the six `shapes_out*.txt` files, the two `ceiling_rederive_*.log` files). Then the repairs.

---

## 1. Findings, with disposition

*Ordered by severity as judged at the time. "Fixed" means the documents now carry the corrected form; the correction itself is not attributed in them.*

### 1.1 The notes' SAFE-cap pitfall box prescribed the cap the entangled-generator repair removed — **fixed**

`orbital-evasiveness-notes.md` §1's box read: "A p-characteristic part is capped at F·orb(c, dmax), with dmax the q-part of c − 1 times the largest divisor of the rest **coprime to F_mid**." That is the pre-correction cap. The box whose job is to warn readers off the wrong cap was teaching the wrong cap.

Evidence assembled at the time, since this is the kind of claim worth being able to re-check:

- `mu_enumerate_v3.py`'s `value()` implements the flat `t.cap` = F·C(c,2) in SAFE mode, and its comment block explicitly says the F_mid cut "is NOT a necessary condition, and imposing it is unsound in the dangerous direction."
- `ep`'s Notation box and the E″ leftover-twist lemma both say so in bold.
- `fb_common.py` implements foreign-strip-only, with the F_mid strip named as anti-permissive at all three strip sites.
- The data confirms which scoring is live: v4 has n = 78 at 465 (`1x47* + 1x31`) and n = 222 at 3403 (`1x139 + 1x83*`), where v5 has `6x13 → 468` and `6x37 → 3996` — the composite-F entangled winners the strip suppressed.
- The shipped control sweeps show the same thing directly: `shapes_out_control.txt` and `shapes_out_nmax_100_maxf_4_control.txt` carry 21 and 59 `UNDER-SCORE` rows against 0 in the correct-scoring runs, and `3x4|d=3` scores 6 against a realised 18.

Fixed by rewriting the box to state the flat cap, name the tightening, give the quotient-not-subgroup reason, and record that the flat cap's looseness is non-shape-neutral *in the safe direction*.

**Also fixed in the same sweep:** four descriptions of `B_safe` in `ep` (Status box ×3, the sandwich paragraph in Part B, and the "How this interacts with B_safe" paragraph in Part D) said B_safe scores a p-characteristic part at F·orb(c, dmax). They now say F·C(c,2). The F·orb(c, dmax) form survives only where it belongs — in the certificates' leftover twist cap, where `dmax` means the licensed *foreign* strip and nothing else.

**And in the code:** `mu_enumerate_v3.py` carried a stale comment paragraph immediately above the correct one, asserting that the F_mid coprimality "is a proven necessary condition, not a Lemma C-style conjecture, so SAFE mode may use it." Deleted; the correct rebuttal that followed it is left standing. The code's behaviour was always right — this was a comment that contradicted the code four lines below it.

### 1.2 `aod` §3.3.5 quoted cap₂(1/6) = 0.050510, which is cap₄(1/6) — **fixed**

The box "At n ≡ 11 (mod 12), F = 4 wins" argued from "the best F = 2 can reach is η = 1/6 and cap₂(1/6) = 0.050510 < 7 − 4√3". Recomputed: cap₂(1/6) = (1/6)/(1 + √(1/3))² = **(2 − √3)/4 = 0.066987**. The value 0.050510 = (5 − 2√6)/2 is **cap₄(1/6)**, equal to the unfused rung C at the same η.

The conclusion survives — 0.066987 < 0.071797, F = 4 still wins at class 11 — but the margin is **0.0048, not 0.021**. `aod` §6.6 already had this right ("the next one down is **not** S4's (5 − 2√6)/2 but the rung at (2 − √3)/4 = 0.066987"), so the document was internally inconsistent and §3.3.5 was the wrong side of it.

Fixed with the correct constant, the margin, and a gotcha naming 0.050510 as cap₄(1/6) so the substitution cannot be made again silently.

Three consequential relabels, since 0.050510 appears elsewhere as a *threshold* and the threshold arithmetic is correct even though its label was not:

- §3.3.4's rung-B′ box called it "the worst class ceiling under the F = 2 rungs". It is the **old class-23 figure** (unfused reading). The u ≤ 9 conclusion is right against 0.050510 and the box now says so, adding that against the corrected worst F = 2 ceiling 0.066987 the condition tightens to u ≤ 5 — either way the family is exponential and nothing downstream moves.
- §3.7's worklist-threshold box and the §3.3.4-adjacent selection-effect paragraph both attributed 0.050510 to "the F = 2 rungs"; both now attribute it to the older unfused reading.
- §3.4's "old ceiling 0.050510 gave the wider range" needed no change — it is explicitly historical about a superseded ceiling.

### 1.3 Stale mod-24-era constant counts — **fixed**

Three counts survived the re-keying to six constants mod 12, each in a sentence that reads as true:

| where | said | now |
|---|---|---|
| notes §1 hypothesis table, row 1 | "the seven mod-24 ceilings" | six mod-12 |
| notes §1, "the two axes are orthogonal" | "seven ceilings collapsing to two" | six |
| `aod` header, "Which hypothesis each constant depends on" | "the eight constants" (×2) | six |
| `aod` §5 opening | "seven distinct δ₀ across the 24 residue classes" | six, mod 12 |
| `literature-findings` item on the quadratic optimisation | "the seven mod-24 ceilings" | six mod-12 |
| `literature-findings` conditionality table | "the mod-24 ceilings (§3.3)" | mod-12 |
| `literature-findings` Romanov/Erdős parallel | "mod-12 (then mod-24) classification" | mod-12 |
| `literature-findings` k ≥ 3 headline | "the mod-24 classification … transfer row for row" | mod-12 |

This is the class of defect that motivated invariant I2 below: a cardinality in prose is invisible to a numeric sweep.

### 1.4 The overview's "d = 12 at 11" contradicted (H) — **fixed**

The one-paragraph overview correctly said class 11's ceiling is taken by the F = 4 shape, then cited "§3.5.4's table: … d = 12 at 11". §3.5.4's table is the **F ≤ 2** table; at F = 4 the ceiling-setting value is d = 6, and (H) clause 3 says "d = 12 at none of the ceiling-setting cells". Fixed by distinguishing the two explicitly in the citation.

### 1.5 Two winner counts contradicting the census in the same document — **fixed**

- `ep` Part 0's "S7 at F = 2 versus S5" box said "Over v4, 150 winners are the cyclic-layer rung and 24 are S5", against the census's 338 and 30. Recounted directly from `mu_table_safe_v4.csv` over the contiguous prefix: **338 cyclic-layer (q odd), 30 S5 (q = 2)** — the census is right. 150/24 matches no natural frontier (n ≤ 1306 gives 133/22, n ≤ 1540 gives 169/26, n ≤ 2298 gives 286/30), so it was a stale snapshot carrying an "over v4" label. Fixed to 338/30 with a PENDING-REBUILD tag and a note to recount both together.
- `aod` §3.3.2's Fermat box said "**20 winners** of shape `2×c + 257*`" with a 20-element list and a density floor of 0.09177. Direct count: **18**, min density 0.096089 at n = 459, max 0.16138 at n = 639 (the max was right). The listed n = 451 and n = 819 are not members — both are won by F = 4 shapes, `4x71 + 1x167*` and `4x139 + 1x263*`. §3.3.4's rung-B′ box already said "18 winners at r = 257", so again the document contradicted itself and the census-adjacent figure was the correct one. Fixed, with the two non-members named so the error is not reconstructed. `ep` Part I's foreign-block-efficiency paragraph inherited "20 winners" and now points at the `aod` list.

### 1.6 `converse_check.py` had a branch-(a) coverage gap — **fixed**

F.4 branch (a) is "no part is foreign", which includes multi-class all-matching configurations (the proof's own n = 640 = 1·256 + 3·128 example, and the S9 discussion insists F.4 quantifies over configurations rather than winners). The script identified branch (a) by `parts == 1`, so a row with parts ≥ 2 and no starred prime would trigger **neither** check and pass silently.

Verified vacuous at the time — 0 such rows in v4 and in the v5 prefix — but the failure mode is the silent kind the script exists to prevent, and a rebuild rewrites witnesses. Fixed: branch (a) is now keyed on the absence of a foreign star, multi-class all-matching rows are counted and reported separately (with an explicit "none in range; the check is live but currently vacuous" line), and a row that reaches neither branch is flagged and sets exit 1.

### 1.7 `converse_check.py`'s inequality (2) is a sharpening of F.4, not F.4's own bound — **fixed as documentation**

F.4(b) concludes r ≥ δ₀(n−1)/2. The script and `ep` F.4's measurement box test the stronger r ≥ δ·n. The stronger form is derivable — foreign intra ≤ F·C(r,2) with F ≤ n/r — but by a different route than F.4's proof, so a violation between 1× and 2× would contradict the sharper form without touching the Proposition. Kept in the sharp form (that is what the table satisfies and what a sharpening question would consume) and documented as such in the script docstring, in `ep` F.4's box and in `aod` §6.7's measurement box.

### 1.8 The certificates' trusted base is larger than "the eight necessary conditions" — **fixed as documentation, and one half measured**

Two dependencies sit underneath the conditions and were named nowhere:

**(a) Foreign parts are scored unfused.** `pair_candidates` applies condition (3) as orb(r, t) ≥ B — a single block — and the leftover tests admit foreign parts only at F = 1. For a fused foreign class of F′ blocks the intra term is F′·orb(r, t), so (3) is not necessary for it. What excludes fused-foreign configurations is Lemma D2's domination, whose range-scoped half is `a18_verify.py` and which beyond the table needs only δ ≫ n^{−1/2}. Sound as a proof; the point is that quoting the `--no-theorems` banner without D2′ overstates the result. Now named in `fb_common.py`'s header, in `ep`'s E″ box, and in `pending-checks.md` risk item 7.

**(b) Condition (4) inherits J0a at a ≥ 2.** Lemma C's proof pins the multiplier via a Frobenius exponent, i.e. inside AΓL(1, c). At a = 1 that is automatic (GL(1, p) is cyclic); at a ≥ 2 it assumes a semilinear stabiliser, which is J0a and open. Since condition (4)'s strip licence is Corollary C′, the collapse certificates inherit it at a ≥ 2 strip sites. `ep`'s three flat "Lemma C is proved at every a" statements (lemma inventory, index table, Part J item 3) now carry the semilinear scope, as does the q-pinning box's "proved at every a, so this half is unconditional".

**Then measured rather than argued.** `fb_common.set_strip_trace` already existed for exactly this. Run over v4 at n ≤ 1200 through `pair_candidates`: **24 strip decisions, all 24 licensed, none at a ≥ 2.** So condition (4) never reaches the a ≥ 2 case over that range and the J0a exposure in the collapse is empty in fact. Recorded in `fb_common.py`, in `ep`'s E″ box and in `pending-checks.md` with a PENDING-REBUILD to repeat over the full rebuilt range — one licensed strip at a ≥ 2 puts J0a back into the trusted base.

### 1.9 `wide_cert.py`: latent over-credit at share pairs — **fixed**

`two_part_lo` and `three_part_lo` scored min(C(c,2), c·r\*, cap(r\*)) without checking r\* ∤ c − 1. At a share pair that value is not realisable (the coupling cuts one twist or the other), and since B_lo feeds the s_max and foreign-cap **filters**, an over-credit is **anti-permissive** — too large a B_lo drops candidate (pair, n) combinations and can turn an unresolved value into a silent pass, which is the one error class the file cannot see in its own output.

Measured before fixing: over n ≤ 2600 no share pair ever set or came within 0.1% of setting B_lo, and the only two cases where the reconstructed B_lo exceeded the tabulated B(n) were n = 78 and n = 222 — the two v4-known-low rows of §1.1, i.e. v4's deficiency and not the families'. So the guard costs nothing. Added anyway, with the reasoning in the docstring, on the principle that removing the question beats relying on it staying moot.

The same latent issue exists in `ceiling_rederive.py`'s scorer and was left alone deliberately: near every balance point r > c − 1, so r | c − 1 cannot occur where the sup is set.

### 1.10 `wide_cert.py`'s cache signature was incomplete — **fixed**

`_SIG` hashed SCAN_CAP, WEAK, the three family functions' bytecode and docstrings, `near`, and the mode — but B_lo also flows through `fb.foreign_cap`, `fb.orb`, `fb.qpart`, the local `orb_full` and `me.seed_value`. A fix to any of those would silently reuse a stale cache, precisely the failure the signature's own comment says it exists to prevent. All five added.

### 1.11 "437 shapes across two sweeps" does not reconcile with the shipped outputs — **fixed as a requote**

The two files matching Part E's description hold 241 rows (`shapes_out_nmax_100_maxf_4.txt`: prime powers c ≤ 49 at F ∈ {2, 3, 4}, all divisors of c − 1) and 211 rows (`shapes_out_nmax_200_maxf_2.txt`: c ≤ 97 at F = 2). Sum 452; **339 distinct (F, c, d)** after removing the F = 2, c ≤ 49 overlap. No natural variant reaches 437 (excluding d = 1 gives 366 summed / 275 distinct). Fixed to 339 with the file names, a PENDING-REBUILD tag, and the overlap trap stated — summing the two row counts double-counts.

The substantive claim behind the count fully verifies and is untouched: every row in every correct-scoring sweep reports `ok`, in three implementations (see §2.1).

### 1.12 `aod` §3.3.5's unfiltered-run parenthetical disagreed with the shipped log — **fixed**

It said the unfiltered sup exceeds the cap "at 5, 11, 17 and 23 — by 1.48× at class 11 — every time via c or oddpart(r−1) a power of 3". The shipped `ceiling_rederive_16000_no-filter.log` shows exceedances at classes **3, 5, 7 and 11** (mod 12) — 3 and 7 via c = 2048 and 4096, i.e. the 2-power route — and class 11 at **1.74×**, which is also what the script's own docstring quotes. Which escapes fire is range-dependent, so neither figure is wrong as a statement about its own range; the defect is that the sentence read as a stable fact while quoting a run other than the one on file. Fixed to cite the log and its range, and to say that the class list is range-dependent while the O(n/log n) character is not.

### 1.13 Smaller items — all **fixed**

- `aod` §3.2.4: "Note what the **first two** show together: both reach the full twist at c ≡ 1 (mod 8)". The witnesses as listed are (531, c = 137), (273, c = 83), (253, c = 73), and 83 ≡ 3 (mod 8); the two c ≡ 1 rows are the first and third. Now names the rows by n instead of by position.
- `ep` E.3(ii): stated "the layer cyclic since gcd(r−1, c) = 1" with no argument, while `fb_common.e3ii_resolves`'s docstring already flagged this as "the gap worth naming" and gave it — gcd(r−1, 2r+1) = gcd(r−1, 3), and 3 | r−1 would force 3 | c. Promoted the code comment into the theorem text.
- `pending-checks.md`: two paragraphs ("The extracted hypothesis (SP)…" and the "Three smaller steps" header) appeared **twice**, with the first occurrence of the header glued to the shape-audit paragraph and orphaning it. Four lines deleted. Pure editing defect, but in the one file designated read-before-work.
- The new closed-defects paragraph in `pending-checks.md` was reworded once after PASS 8 flagged "Closed in this pass" as a reference to a work session — it now reads as a statement about the documents rather than about the editing.

---

## 2. Independent verification performed

*Recorded because re-running it is cheaper than re-deciding whether it was done, and because several of these are the checks that would catch a regression.*

### 2.1 A third implementation of the fused-class orbital computation

Built from scratch in Python — finite-field arithmetic over 𝔽_{p^e} by explicit modulus polynomial, entangled generator as a block rotation whose F-th power is the full twist, permutation closure, pair-orbit computation — sharing no code with `ark_shapes.g`, `shape_realize.py` or the enumerator. Results:

| configuration | intra orbitals | cross orbitals | scored intra | scored cross |
|---|---|---|---|---|
| F = 3, c = 4, d = 3 | {18} | {48} | 18 | 48 |
| F = 2, c = 9, d = 4 | {36, 36} | {81} | 36 | 81 |
| F = 2, c = 9, d = 8 | {72} | {81} | 72 | 81 |
| F = 2, c = 8, d = 7 | {56} | {64} | 56 | 64 |

All four match the shipped GAP outputs and the scored terms exactly, including `3x4|d=3`, which is the row the F_mid strip mis-scores. So the corrected coefficient rules now have **three** agreeing implementations, one of them written without reference to the others. (A first attempt used a wrong modulus polynomial for GF(9) and found no field generator; the assertion added for that is why the second attempt was quick. Worth keeping in mind for any future hand-rolled field arithmetic.)

### 2.2 `converse_check.py` re-run against an independently written `Arith`

`fb_common.py` was not available in the first half of the session, so `Arith` — sieve, `is_prime`, `factor`, `largest_pp_divisor` — was rewritten from scratch and `converse_check.py` run against it. Reproduces every documented v4 figure: 2,186 contiguous rows, floor 0.045742 at n = 1817, 1,409 foreign primes, 777 branch-(a) winners, 0 violations on all three inequalities, max cofactor **12** at (n, r, Q) = (221, 157, 13), slack 3.6, tightest (3) ratio 0.9996 at n = 2594, tightest (1) 0.4976, tightest (2) 2.003 at (2040, 1019). The frontier-detection-at-gap-10 story reproduces (2,186 rows). Re-run after the edits with the real `fb_common.py`: identical.

### 2.3 Table recounts

Direct from `mu_table_safe_v4.csv` (contiguous prefix) and `mu_table_safe_v5_code_v3.csv`:

- fused-plus-foreign winners by (F, q-type) over v4: F = 2 → 338 at odd q, 30 at q = 2; F = 3 → 51/2; F = 4 → 50; F = 5 → 3; F = 6 → 14/3; F = 8 → 2. Matches the census rows.
- the same at four cutoffs (1306, 1540, 2298, 2600), which is how 150/24 was shown to match no frontier.
- 18 `2×c + 257*` winners, all in classes 3 and 7 mod 12, densities 0.096089–0.16138.
- 16 three-part winners, list matching `ep` Part I exactly.
- v5 at n ≤ 1000: 104 cyclic-layer vs 16 S5, c mod 8 = {1: 17, 3: 31, 5: 29, 7: 23} → 46% at c ≡ 1 (mod 4), matching the percentage `aod` §3.2.5 quotes though not its absolute counts (correctly tagged PENDING-REBUILD there).
- 0 multi-part all-matching rows in either table, which is what makes §1.6 vacuous-but-live.
- 43.5% of n ≤ 10⁵ are within a factor 25 of a prime power, against the "roughly 44%" of `ep` F.4 and `aod` §6.7.

### 2.4 Constants recomputed

All six caps and all six x\* of §3.3.5; cap_F(η) = cap₁(Fη)/F; cap₄(1) = 1/9; 7 − 4√3 = 0.07179677; (2 − √3)/4 = 0.06698730; (5 − 2√6)/2 = 0.05051026; the F·width = 1 − √λ identity of §3.4 (the algebra does cancel); the F = 4 mod-8 pinning at classes 11 and 23 (r ≡ 7 and 3 mod 8, v₂ = 1 both).

### 2.5 Log arithmetic checked from scratch

`ceiling_rederive_16000_no-filter.log`'s class-11 witness n = 8747 = 2·3⁷ + 4373 with r − 1 = 4·1093 gives exactly 0.12496; `ceiling_rederive_24000_mod12.log`'s class-11 witness n = 15143 = 4·2029 + 7027 gives exactly 0.07178, foreign-bound, η = 1/3. All six generic sups agree with the tabled constants to ≤ 0.0006 and all six {a, a+12} pairs agree — this is the empirical leg of the ceiling table and it stands.

### 2.6 Post-edit smoke tests

`wide_cert.py 2000` → 1666 of 1666 certified, 0 unresolved. `fallback_cert.py mu_table_safe_v4.csv` → CERTIFIED. `converse_check.py` → as in §2.2. Full `check_doc_figures.py` → 16 findings, all pre-existing informational (old-checkpoint figures awaiting the rebuild, `[theorem] scope` recounts, `[elsewhere]` cross-file result citations, and two false-positive DANGLINGs on Shparlinski's Theorems 1 and 2); PASS 4 hygiene and PASS 7 tables clean.

### 2.7 Read and found sound, no change needed

Theorem 2.1 (both directions, including t ≥ 3 and the intransitive branch), Theorem 2.2 and its p₁ ∈ {2,3} equality, Theorem 2.3 and C.1's closed form, Lemma B′ (Step 0 and the degenerate branch), Lemma C's conjugation argument, D1, D2 (all three steps — the H¹ vanishing use is correct since r ∤ |Q|), D2q (all seven steps), E.1/E.2/E.3(i)–(iii)/E.4 including the b = 2 exception and the (16,5) uniqueness logic, E.3(ii)'s explicit group and the orb(c, r) = C(c,2) identity for safe primes, F.1, F.2, the q-pinning box's five steps, G.2's r | d ⟺ r | d′ argument, and §7.1–7.3 including the 7.2(A)/(B) prime-power lists.

F.4 itself, read closely at the end as instructed: the foreign branch's joint F·r ≤ n care, the matching branch's shared-p step, the density-zero claim for (a), and the asymmetry argument for why (a) must be an alternative all check out. §6.8's (SP) formulation is careful in the right places — the window-in-definition rationale is correct (a cumulative lower bound really does not yield a window count), and the ρ ≍ 1/log²x placement of S_D against 1/log x for Baker–Harman is the right order.

`fb_common.py` read line by line and found sound: the `s_max` exact-integer boundary handling, condition (6) as a tripwire that provably never binds, the '*' branch's gating on r ≥ B, `leftover_ok`'s need-floor logic, `multi_part_ok`'s subset-sum treatment of distinct foreign primes vs repeatable p-parts, the asserted-and-traced strip gates, F ranging over all integers at every site, and MERSENNE/REPUNIT3/E4 against the theorems. `branch_settled`'s dispatch matches the theorems' actual scope (s = 2 honestly never dispatched). `ceiling_rederive.py`'s filter, its full-number prime-power test on c (the documented odd-part defect is fixed), and its mod-12 pairing test. `wide_cert.py`'s pass-2 filters and its "dispatch settled nothing → the comparison is trivial" self-warning.

`oliver_negative_out.txt`: internal totals consistent (160 transitive groups over degrees 6–11; 108 + 52; 11 solvable-not-Oliver rows enumerate correctly), and the spot-checked group facts right (T(8,36) = AΓL(1,8) solvable Oliver at q = 3; PSL(2,7) fails; S4 Oliver via A4).

---

## 3. `check_doc_figures.py` — two invariants added

Both target defects this session found that **no existing pass could see**, because they are prose rather than figures. Both live in PASS 2.

**I1 — no sentence may prescribe an F_mid strip on the SAFE cap.** Triggers on the co-occurrence of `dmax` with `F_mid` / "coprime to F" / "block count", exempting sentences that carry a negation marker (`not`, `unsound`, `anti-permissive`, `tempting`, …) since naming the strip in order to reject it is exactly what the pitfall boxes do. The trigger is deliberately the co-occurrence and not `dmax` alone, because F·orb(c, dmax) is legitimate in the certificates, where `dmax` strips only the licensed foreign prime. This is the invariant that would have caught §1.1.

**I2 — every quoted count of ceiling constants must match the ceiling table.** The cardinality and modulus are **read off the table** (the `| n mod N |` header and the distinct values in the cap column) rather than hardcoded, so the check cannot itself go stale when the table changes. This is the invariant for §1.3.

I2 took three tightening passes and the failures are worth recording, since a noisy invariant is one nobody reads:

1. A loose "(number) … (ceilings|constants)" pattern produced 13 findings, nearly all false — "two engines", "the constants die at k ≥ 3", "two ceilings, a block recursion" (the two crude bounds of notes §2), and `converse_check`'s "the two constants" (max cofactor and slack).
2. Narrowed to four explicit patterns, each naming the counted object, plus exemptions for `collaps|solvable|k ≥ 3` lines, bare counts ≤ 2 without a modulus, and "the N constants" outside a ceiling/δ₀/shifted-prime context. Down to 1 finding.
3. That last one was **a genuine catch of a different kind**: "the mod-12 ceilings (§3.3)" in `literature-findings.md`, where the pattern was reading the *modulus* as the cardinality. Fixed with a lookbehind excluding `mod ` / `mod-`, which is the right fix because "the mod-12 ceilings" is a keying and not a count — and finding it required first correcting the same line's stale "mod-24", so step 3 both fixed a document and fixed the checker.

Both invariants report `[ok]` on the current documents.

---

## 4. Deliberately not done

- **Not read line by line:** `validate_table_v3.py`, `ladder_verify.py`, `verify_witness.g`, `ark_shapes.g`. `mu_enumerate_v3.py` was read only around `value()` and `strip()`, which is what §1.1 turned on.
- **Not audited line by line:** `aod` §§3.8, 4.1–4.2, 6.1–6.5 (§6.1's feasibility derivation, §6.4's parity table, §6.6 and all of §§6.7–6.8 were read closely; §3.8's per-residue counting and §4.2's S6 analysis got a skim), and the notes §§8–11 beyond §§7.1–7.3.
- **Not re-derived:** the D2′ and C′ threshold constants (n ≥ 1582, n ≥ 763).
- **Not run end to end:** the certificates in `--no-theorems` mode, and `wide_cert.py` at 10⁵.
- **Not reconciled:** the `certified_K` distribution, part-count distribution and low-density-tail figures — these are rebuild outputs, correctly tagged, not errors.
- **Not fixed, deliberately:** `ceiling_rederive.py`'s share-pair scoring (moot by §1.9's last paragraph), and `aod` §6.7's headline "equivalent up to constants", which the following fine-print paragraph honestly walks back on four axes. The headline is the sentence likely to be quoted out of context, so it is flagged here rather than changed — a decision worth revisiting when the note is shaped into a paper.

---

## 4b. Second pass — the skipped checks, done

The items §4 listed as skipped were returned to and completed. What they found, and what was done:

**Read in full and sound:** `mu_enumerate_v3.py` (859 lines — pruning permissive on ties throughout, `rec(i, …)` deliberately permitting repeated p-parts while `value()` excludes duplicate foreigns, p = 0 sentinel and q = p both in scope, decision-mode rejection exact for integers, `--refined`+`--floor` correctly refused); `validate_table_v3.py` (1,286 lines — v5 all 28 PASS, v4 failing only `c_rederive` at its 18 cut-scored rows, as its own header says it must); `ladder_verify.py` (660 lines); `ark_shapes.g`; `verify_witness.g`. Five v5 rows reproduced exactly, values *and* witnesses (78, 222, 273, 640, 1175); `--refined` agrees at fb = 0 rows; decision mode exercised.

**The two thresholds re-derived.** With δ ≥ 0.02516: √n < δ(n−1) first holds at **n = 1582** (analytic crossover 1581.71) and δ(n−1)/2 > log₂n first holds at **n = 763** — the latter razor-thin, n = 762 failing by 0.0002 — both monotone through 10⁶. The below-threshold direct scoring reproduces exactly: C′'s worst ratio **0.7000 at n = 15** via the share (p^a, r) = (8, 7); D2′'s **0.8276 at n = 56** via (F, r) = (8, 7). One sharp edge: the *closed-form* relaxation n·min(F,r)/2 **ties** B(n) at n = 6, so `ep`'s "direct scoring of the bound" must mean the branch bounds min(F·C(r,2), C(F,2)·r) and not the closed form. It does, and is correct as written — but the margin is zero, so do not restate D2′'s range check in the closed form.

**Both certificates run end to end in `--no-theorems`:** `fallback_cert` on v4 → CERTIFIED with zero dispatches; `wide_cert 2000` → 1666/1666 in both modes, agreeing.

**Fixed in this pass:**

- `ep` Part G.2's "257 winners … 255 of the 257 … n = 551, n = 2015" was the **pre-repair** census stated untagged in the present tense (current v4: 16 three-part winners, all equal-pair, both named n now fused two-class winners). Tagged ⟦PENDING-REBUILD⟧ with the corrected figures named, rather than requoted, since the rebuild lands within days and will requote it alongside Part I's box.
- **Both certificates' banners overstated the trusted base.** The `--no-theorems` runs printed "rests only on the eight necessary conditions" — the very claim §1.8 corrected in `fb_common.py`, `ep` and `pending-checks.md`, still being printed by the two scripts a reader would quote *from*. Both banners and both docstrings now name the two scoped dependencies (unfused-foreign via Lemma D2, range-scoped below n = 1582; condition (4)'s strip via Corollary C′, inheriting J0a at a ≥ 2, measured empty at a ≥ 2 over n ≤ 1200).
- **`ladder_verify.py`'s S7 loop asserted the refuted F_mid twist-coprimality as fact**, in a comment thirty lines below rung B's correct entangled-generator rebuttal, with the docstring repeating it. Both rewritten: the cut is retained (understating a family is safe when the script takes a max over families) but now labelled as a sharpness cost with the measurement — over v4's 154 fused-plus-foreign winners the cut intra never falls below B once the `eff_at(q)` branches are considered — and with the tightening named.
- **`ladder_verify.py`'s fused family required a prime-power block count** (`ispp[FF]`), the pre-repair reading; `6x13` at n = 78 is the counterexample. Guard dropped and the cross coefficient keyed on F's parity, which is the correct rule and the only available one once F is composite.
- `validate_table_v3.py`: `c_realisable`'s carrier and `c_cross_coeff`'s `binds` statistic both still build the **old stripped dmax**. Left in place (each is conservative — a smaller carrier passes more easily, a smaller intra fires the tripwire less) but both now carry a staleness flag stating the direction of the weakening and that a rebuild on the flat cap is owed. `c_s5`'s u ≤ 9 comment gained the 0.050510 = cap₄(1/6) relabel and the u ≤ 5 form under the corrected ceiling.
- `ark_shapes.g`: `NOT-OLIVER` added to `CheckOutputComplete`'s verdict whitelist (it is a verdict, not a truncation — dormant, which is why it went unnoticed), and output-integrity failure separated from score mismatch, so a truncated control run can no longer print "the strip is detected as expected."
- `verify_witness.g`: `ok.transitive_parts := true` was a **hardcoded stub printed beside real checks**. Now a genuine test that each class is a single G-orbit, with the block ranges threaded out of `BuildConfig`. Verified against an independent Python rebuild of the battery groups: all seven prime-block witnesses give exactly one orbit per class. The header's "the orbital MULTISET equals" was also an overclaim — the code checks set containment — and now says so, with the reason multiplicities are deliberately unmatched and the note that the sum check is what catches the gross version.

**Post-edit verification:** `validate_table_v3.py` on v5 now 22 PASS / 0 FAIL (the ladder cross-check joins and passes); the widened ladder at 20,000 gives floor 0.04621 at n = 2759 with 0 values below 0.04. The ladder-vs-table check is worth recording carefully: against **v4** it now reports 11 exceedances, and every one is v4's known-low rows — at n = 1175, 1919, 1943 the ladder's value matches v5's density to five places. Against **v5** it passes, 20 joined, none exceeding. So the exceedances are the stale table's deficiency, not a ladder over-credit, and this check will be a useful acceptance test on the rebuild. Its `under-explores` companion names the remaining gaps (×1.81 at n = 1235, ×1.62 at 455, ×1.60 at 1739) and every one is an F = 3 or F = 4 fused-plus-foreign witness — i.e. exactly the S7 twist cut above, which is the argument for tightening it.

**Still not done:** `aod` §§3.8, 4.1–4.2, 6.1–6.5 and `notes` §§8–11 line by line; `check_doc_figures.py`'s PASS 5 and PASS 8 internals (PASS 1 and PASS 6 were read this pass and are sound); `wide_cert` at 10⁵ and a 10⁶ ladder rerun on the widened families.

## 4c. Third pass — the remaining document sections, and invariant I3

The last of §4's skipped items were completed: `aod` §§3.8, 4.1–4.5 and 6.1–6.5 read line by line, `notes` §§8–11 likewise, and `check_doc_figures.py`'s PASS 5 and PASS 8 internals, which completes a read of all eight passes.

**Fixed:**

- **`aod` §3.8's rows 7 and 15 test a cell that is no longer their ceiling's.** They are run at (F, D, x\*) = (4, 2, 0.16667), which was their assignment when cap₄(1) = 1/9 was read as their ceiling; under the mod-12 keying they take F = 2 at η = 1/2, cell (4, 0.25000), sharing the 1/8 row with 3 and 19 — as the bash comment below the table already said, while the table, its lead-in and its closing summary did not. The measurements are sound as counts of the F = 4 system and are kept; the two rows are daggered, a footnote states the position, the lead-in now names only 11 and 23, and the summary carries the exception. Re-running them at (2, 4, 0.25000) removes the qualification.
- The same stale residue list in **`validate_table_v3.py`**, twice: `c_census`'s expect string (S7f2 8/24 at 1,3,5,9,13,17,19,21 and S7f4 4/24 at 7,11,15,23 → 10/24 and 2/24, with the keying note) and `classify`'s docstring.
- **`wide_cert.py`'s normal-mode prompt** still said "rests only on the eight necessary conditions" — the residual of §4b's banner fix, which covered the `--no-theorems` banner and the docstring but not the else branch.
- `aod` §4.3's inversion constants (1.290, 4.449) invert the *old* 0.050510 ceiling, not the current (1.366, 3.732). They are retained — a wider interval can only over-count, and the result is an upper bound — but the text now says that is why, instead of leaving them as an apparently stale pair. The downstream A := ⌊log₂(N/1.290)⌋ is consistent with the retained constants.
- `aod` §6.2's partition table, additive "sizes free" at δ₀ = 1/25: 25 → **26** (Σ_{k≤5}Σ_{j<k}p(j) = 1+2+4+7+12). The column is now given explicitly as 7, 14, 26, 8,266 so the arithmetic is checkable in place. Nothing downstream quoted the 25.
- `notes` §9's triangle-freeness list omitted n = 24 and 69 while listing larger members, and silently skipped 27; corrected, with a parenthesis noting that the n which are themselves prime powers (9, 27, 81 — m a power of 3) are left out because KSS already settles them, the criterion covering them redundantly. `C₄-freeness at both` gained its **m ≥ 4** scope, since 2K₃ and 3K₃ are C₄-free.
- `notes` §11 problem 1's "fixes its value in every class **mod 24**" → mod 12.

**Invariant I3 added to `check_doc_figures.py` PASS 2.** The §3.8 defect was invisible to everything: it is an F-assignment, not a figure (PASS 1), not a constant count (I2), not a strip prescription (I1), and it appeared identically in prose, in a script docstring and in a census expect string. I3 reads the F = 4 residue set off the ceiling table's own rung column, reduces every quoted list mod the table's modulus, and compares as sets — so a mod-24 spelling of the mod-12 law passes, since it is the set that must agree, not the notation.

Two implementation notes worth keeping, because the first cost a wrong "clean" verdict:

- **It scans the flattened text, not line by line.** The claim wraps across lines in prose and is reflowed in docstrings; a per-line scan missed the very docstring the invariant was written for, and reported `[ok]`. The scan now collapses newlines and leading comment/quote furniture, recovering the line number from the match offset.
- The pattern needed an optional `n =` between "at" and the residue list, which is how the docstring spells it and the prose does not.

Verified by injection: with `classify`'s docstring reverted to the stale list, I3 reports `validate_table_v3.py L~97 … says F = 4 attains the ceiling at [3, 7, 11] (mod 12 reduced) against the table's [11]`; with it repaired, `[ok]`. The reduction is what makes the message readable — 7, 11, 15, 23 mod 24 is three distinct classes mod 12, and naming them is more useful than echoing the original list.

**Post-edit:** `check_doc_figures` unchanged at 16 pre-existing informational findings, PASS 4 and PASS 7 clean, I1/I2/I3 all `[ok]`; `validate_table_v3.py` on v5 22 PASS / 0 FAIL; `wide_cert 2000` still 1666/1666.

**Also run this pass:** `wide_cert` at **10,000** — 8,719 of 8,719 certified, 0 unresolved, in both modes, agreeing exactly. That extends the collapse fivefold past the previous run under both trusted-base framings.

**Still not done:** `wide_cert` at 10⁵; the 10⁶ ladder rerun on the widened families (cost grows like N²/log N, so this is hours, and the 20,000 smoke test stands in the meantime); the GAP battery re-run for `verify_witness.g`'s new `transitive_parts` check on the proper-prime-power witnesses `3x4` and `1x9`, GAP being unavailable here; and `small-degree-computation.md`, which was never in scope.

## 4d. Fourth pass — the small-degree files, scripts and n = 10 artefacts

A separate object from the arithmetic programme: `small-degree-computation.md` (narrative), `small-degree-verification.md` (state-tracking), the pipeline scripts and the n = 10 checkpoints. Reviewed for correctness and sync with the corrected framework only, not to resume execution. **No fix here requires a rerun**; two must land before the eventual resume.

**The main finding was that the narrative doc never applied its own truncation discovery to its own results.** The verification file's item 7 establishes that the published n = 10 battery was 75 of 167 available conditions — the old dedup key merged Oliver conditions three to one — and states the required phrasing ("satisfiable on the 75-condition battery"). The computation doc followed it nowhere: §5.1 presented the 75 as a legitimate dedup product, §5.2 stated SAT unqualified, §7.1's one-sidedness diagnosis leaned on escalations that were all inside the truncation, §3.2 described the broken key with n = 12 numbers only, and §10's open list omitted the rerun entirely — which the verification file ranks as the cheapest run available and the only one that could settle a degree outright. All five fixed, with the rerun added as open question 1 and the SAT explicitly excluded from §10's "settled and not at risk" list.

**Fixed in the docs:** the n = 10 SAT qualification above; §1.1(b)'s "the unique nonevasive property at 5 vertices" → up to duality, matching §4.3; §5.4 gained the published solution's own χ kill, which is a tenth kill and an order of magnitude outside the quoted nine-kill range (χ = 15,183,001, reproduced here end to end); verification item 3 rewritten around the resolved pressure point; item 8's stale claim about `chi_test.py` corrected; item 10 and `notes` §8 updated to the entangled shape space; item 14's `stage4_fast.py` entry closed.

**Two findings worth the detail:**

- **Item 3's apparent contradiction was a same-edge-count coincidence.** The complements of the 38-edge forced-OUT classes 393/401/405 are classes **457, 414, 434** (7-edge), not class 108 — so the involution theorem was never in danger; the partners are just unprobed. The item's suggested probe list included 457, missed 414 and 434, and included 437, which is not a partner of anything. The complete list of 15 unprobed partners was computed from the catalog and now sits in the item and in the Commands block: 414, 434, 439, 457, 493 (predicted IN) and 541, 543, 548, 549, 555, 560, 561, 562, 565, 566 (predicted OUT).
- **Item 10's prescribed repair was the weaker of two, and would miss the n = 10 optimum.** It said Theorem 3.1 puts the rotation in the top q-group, so k need only be a prime power, and prescribed moving the rotation upward. Under the entangled correction a cyclic-layer rotation carries the full twist at *any* k. The sharp point: the m\* = 20 attainer `A:18` has a **trivial top**, i.e. no top layer for a rotation to occupy, so it is reachable only by the cyclic-layer route — the prescribed repair would reproduce the tag-2 attainers and not the χ = 1-exact one the doc treats as the point of the result.

**Fixed in the scripts (both sync-before-resume, no rerun):** `stage4_fast.py`'s three UNSAT verdict strings hardcoded `n=10` while `NVERT` was computed, so an n = 12 UNSAT — the one outcome that would be a theorem — would have printed the wrong degree in the string that gets quoted; and `probe_backbone.py`'s leaf silently rejected where `stage4_fast.py` hard-aborts on the same pend/undo desync signature, which in probe would corrupt the **UNSAT rows, i.e. the forced classes**, its most-quoted output. Both synced, plus stage4 gaining probe's multi-prime firing log.

**`check_doc_figures.py`:** `small-degree-verification.md` added to the ARCHIVE exemption, and **PASS 8 switched from its own private skip list to the shared `ARCHIVE` regex** — the two lists had drifted, so `pending-checks.md` and the verification files were exempt from stale-figure reports while still being flagged for edit-history phrasing that is correct in a state-tracking file.

**Verified clean, much of it by independent recomputation.** All 75 group conditions re-verified on `solution1.pkl` against a from-scratch 𝔽_p-homology implementation (`smith.py` was not in the working set): 0 failures — stronger than the recorded check, which covered only the 40 Oliver χ conditions. `chi_test.py` reproduced the 64,333-class down-closure; `engine.py`'s self-tests reproduced χ = −1215 and −243. Every artefact figure the two files quote checks out: battery tags and V = 1,242, 214/1,028 with 0 monotonicity violations, order matrix 249,711 entries at density 0.162 with 0 antisymmetry violations, the 10 skeleton generators, 2K₅ IN and K₅,₅ OUT, complement closure 1,242/1,242 with 0 self-complementary and a palindromic edge distribution, the probe record 25/20/310/54 over 409 classes and 817 rows, CAP range 9–36 with 49 interior, involution 30 confirmed / 0 violations / 15 unprobed, and timings 32.8 h with CAP at 70%. `ark_gap.g` is library-driven and therefore immune to the entangled correction by construction. Also confirmed: 0 of 817 probe rows carry the nodecap column, so all 54 CAPs retry at any budget, as the resume rule intends.

**Not covered → closed:** the n = 10 `groups_out.txt` arrived after the pass and every figure resting on it was re-verified directly: 967 lines all well-formed (`check_groups.py` green), census 95/159/14/699 with p-split 673/18/6/2, stages A 24 / B 319 / B2 6 / C 618, 756 groups at `--maxt 10`, and — by re-running the complete canonical dedup key — **167 distinct conditions = 125 Oliver + 42 p-group**, confirming the 75-of-167 truncation figure from the file itself rather than from item 7's record. The 8 attainers all sit on partition (20, 25) and collapse to exactly 2 distinct conditions (seven tag-2 plus the trivial-top `A:18`), matching §4.1's three-way count. Still unread: `smith.py`, `oliver_mu.py` and `ark_intersect.py` remain unread, `fp_acyclic` having been checked behaviourally rather than by reading.

## 4e. Fifth pass — T8 (Proposition F.4, `aod` §§6.7–6.8) and the Shparlinski reading

T8's thorough read was done independently, then the §6.8(iv) literature question was settled by fetching Shparlinski (arXiv:1304.0188) and reading Theorem 2's proof rather than its statement. The container has no arXiv egress; ar5iv via web search worked.

**The read itself.** Both F.4 branches re-derived from scratch and correct; the census walk, the S9 joint bound, branch (a) being wider than S1 ∪ S2 (the n = 640 example checks), the round trip 700, the 44, and the ≈58 and ≈4 slack factors all recompute. `converse_check.py` reproduces on both tables: 0 violations, max cofactor 12 at (221, 157, 13).

**T8's three smaller steps, all three resolved and marked so:**

- *Every part clears the floor* — no part **kind** escapes, but a part of support 1 has no intra orbital at all, so the sentence is about s_i ≥ 2; such a part is excluded outright by its cross orbitals. Proviso added to the proof.
- *The shared chain prime* — resolved **structurally** rather than by Part B citation, which is the stronger form: given the chain, a block class of size s^k with k ≥ 2 and s ≠ p has non-cyclic elementary-abelian translations whose only home is the bottom Γ₂, a p-group. So it does not exist; a second prime forces k = 1, which is the foreign case. The dichotomy is exhaustive per chain, and only *some* chain is needed. Now in the proof.
- *The constants* — re-derived, correct, n(n−1) consistent. One imprecision, conservative: the foreign class's smallest intra orbital is at most F·r·Q/2, so the derivation discards a factor 2 in the safe direction. Retained.

**One defect found: §6.8(ii)'s window constant sat exactly on a degenerate boundary.** The claim gave (SP) with **c = δ₀/2 exactly**, on the argument that an empty window makes the n in its upper part fail (b). But an n fails only if its whole r-range lies inside the window, needing n ≤ x and n ≥ x + 1 — no such n, so at the endpoint the emptiness implies nothing and the constant was unproved at its own value. Any c < δ₀/2 opens a positive-proportion interval and the argument runs. Fixed in §6.8(ii) and in `ep` F.4's aside (Λ > 2/δ₀ strictly). This is the **third** endpoint-where-a-constant-is-quoted-exactly defect in this framework, after the F.1/E′ offset and the D2′ closed-form tie — worth treating as a recurring category rather than three coincidences.

**The Shparlinski question answered, and it had been filed under the wrong mechanism.** T4 asked whether the almost-all step survives relative density ≈ 1/log x, presuming the machinery was circle-method and density-hungry. It is neither:

- Theorem 2's engine is **Balog–Sárközy's sumset theorem**, whose hypothesis is a **pure cardinality condition**. The input set enters through #ℛ and nothing else.
- So thinness costs **one logarithm, not the argument**: #ℰ ≪ x^{2γ−1}log⁴x at an S_D-type input against log³x at Baker–Harman — still o(x) for every γ < 1. "One logarithm short of what the machinery consumes" was wrong.
- **No equidistribution clause is needed.** That requirement belongs to a circle-method route; §6.8(v)'s "very likely insufficient as it stands" was describing a different pipeline.
- **What blocks the floor is the companion exponent, at every input density.** The certified prime factor is capped at ≤ x/(2√2 log x), sub-linear, so γ = 1 is unreachable even with a full-density input; and a floor needs the **companion** n − r to carry a linear prime factor at bounded cofactor — the α = 1 endpoint again, on the other side.

**Two things came out of this that are new rather than corrective.** A demonstration: running Theorem 2 with ℛ = S_D itself makes the r-side term reach Ω(n²) while the min stays pinned at p²k ≈ n^{1+γ}, so substituting the endpoint hypothesis on the input side buys nothing — all of (H)'s difficulty is in the companion clause. And a positive conditional now stated in §6.8(iv): **(SP) at any ρ ≍ 1/log^C x gives f(n) ≫ n^{2−ε} for almost all n**, every ε > 0, exceptional set O(x^{1−2ε}log^{C+3}x) — the ladder's limiting exponent from the bounded-cofactor hypothesis alone, with no Baker–Harman input.

**Where a density obstruction does live**, now recorded correctly: certifying a *linear* prime factor needs Sárközy–Stewart's dense-sumset theorem, which wants **positive density in the integers on both sets**; S_D at ≈ 1/log²x is two logarithms short of *that*. Not one log short of a circle-method requirement.

**Edited:** `aod` §6.8(ii) (strict c), (iv) (rewritten), the density-currency and equidistribution paragraphs (re-aimed), the closing box and §3.6's echo at L589 (the "exponent and density compete for one resource" framing was wrong in both places), §6.7's round-trip summary; `ep` F.4's proof (two provisos) and its gaps aside; `pending-checks.md` T8 (three resolutions, the new finding, standing header) and T4 (question replaced by the answer).

**Not done:** Balog–Sárközy's own proof internals were not re-derived — the *statement* Theorem 2 consumes was confirmed to have a pure-cardinality hypothesis, which settles the equidistribution question at the level it is used, but the sieve is taken on citation. Baker–Harman's 0.677 likewise. Lemma B′ remains T1's item and has still had one reading; F.4 now has two.

## 4f. Sixth pass — `shparlinski-constants.md`, a standalone constants-level account

Written because the published argument uses `≫`/`≪` and unnamed absolute constants throughout, which is free at his exponents (1.677, 3/2) and not free at ours (the γ = 1 endpoint). Scope: Theorem 2 only, Theorem 1 and its Bombieri–Vinogradov argument deliberately excluded. Standalone and **lightly audited by design** — one pass, no independent reading — so it does not add audit surface to the main documents; `aod` §6.8(iv) and `pending-checks.md` T4 each gained one pointer to it and nothing else.

**What the constants turn out to be.** Two are unextractable — Balog–Sárközy's `c` and the implied constant `c₁` in Lemma 7's conclusion — and the note says so up front. Everything else comes out: the window constant needs `c₀ < A/4` (a cumulative hypothesis minus π(c₀x), the same lower-plus-upper structure that makes (SP) a window statement); the good case gives `f(n) ≥ (A/8)^{1+α}·n^{1+γ}`; the exceptional bound is `#ℰ ≤ max{(8c/A)(log x)³, (8/(Ac₁²))·x^{2γ−1}(log x)³}` per dyadic block. **The two unextractable constants turn out not to matter**, since every threshold that decides anything sits at the `loglog x/log x` scale where a constant factor is absorbed — which is worth knowing, being the one thing we could not have computed.

**The quantitative result, which is what the ≫-notation was hiding.** `#ℰ = o(x)` permits γ to vary with x up to `γ < 1 − (k/2)·loglog x/log x`, k = 3 at a constant-relative-density input and 4 at ours. Translating to the certified companion prime factor:

- Baker–Harman input → `p ≫ n/(log n)^{3/2}`
- bounded-cofactor input → `p ≫ n/(log n)²`
- what a floor needs → `p ≥ δ₀·n`

**So thinness costs `(log n)^{1/2}` and the endpoint costs `(log n)²`.** That is the sharpest form of the §6.8(iv) finding and it makes the situation legible: the method reaches within a squared logarithm and cannot cross. Note `(log x)² > 25 = 1/δ₀` for every `x > e⁵ ≈ 148`, so the gap opens with x rather than closing — the right direction for something the method can never do.

**Also established here:** the structural cap `certified P(n−r) ≤ x/(2√2·(log x)^{3/2})`, which holds at *any* input density since both sets live in [1,x] — run backwards, certifying `p ≥ x/25` at x = 10¹² would need `#ℰ ≥ 933·x`, larger than the interval it lives in. And a prime-versus-prime-power check the main documents never made: Shparlinski's `P(·)` is the largest *prime* divisor while our Q is the largest *prime-power* divisor, so the sieve's output is stronger than we need (safe direction) — and measured over primes `r ≤ 2·10⁶`, Q is a proper prime power for 5.4% of all primes but only **0.55% within S₁₂**, the bounded-cofactor condition making a proper power an unlikely route into the set. The distinction never becomes load-bearing.

**One strategic consequence, now recorded in T4.** The fixed-residue level-of-distribution family (BFI, Mikawa, Fouvry) attacks the **input** side, which this reading shows is not where the difficulty is — so it should rank below the sumset question rather than beside it. And the highest-value next check is **Sárközy–Stewart's actual hypothesis**, taken here from Shparlinski's characterisation of it rather than the original; if it is weaker than "cardinalities of order N", the endpoint accounting changes materially.

**Correction applied the same session, on Vipul's catch: the objective function was also stated up to constants, and I had imported it as printed.** BBKN's / Shparlinski's `f(n) = max min{p²k, pkr, qr}` is not a minimum of orbital sizes. Verified by explicit orbit enumeration rather than by formula:

| term | true orbital | overstatement |
|---|---|---|
| `p²k` | `k·C(p,2) = kp(p−1)/2` | `2p/(p−1) → 2` |
| `pkr` | `kpr`, *if* the cross pairs form a single orbital | structural condition, not a constant |
| `qr` | `rq` (q odd), `rq/2` (q even) | 1, or 2 at q = 2 |

Not an error in the source — Lemma 5 carries an unspecified `c` in front of f, which absorbs any bounded factor. It is exactly what this document cannot absorb.

**Three things came out of checking it.** (i) The `qr` term is essentially exact since q is prime hence odd, so **`ep` F.4's `F·r·Q` is tight and cannot be sharpened by recovering a factor 2** — I went looking for that sharpening specifically and there is none; `aod` §6.8's "cofactors are essentially even, hence Q odd" is what closes it. (ii) The `pkr` term hides a *structural* condition rather than a constant: an early version of my check used simultaneous rather than independent block translations, which creates a diagonal orbital of size `kp` and collapses m\* from `kp(p−1)/2` to `p`. So f is a valid lower bound on m\* only for a Γ whose orbital structure has been verified, not a formula to evaluate at an arbitrary quadruple. (iii) **§6 had reached the right answer via two cancelling errors** — the factor 2 that `p²k` gains over `kp(p−1)/2`, against the factor 2 that `δ₀n²` gains over `δ₀·C(n,2)`. Either alone would have moved the constant. Recorded in the document, since a cancelling pair is what a spot-check does not catch.

**Cross-check that the corrected expressions are right:** at p = 5, k = 2 the enumeration gives m\* = 20 = **μ(10)**, matching the GAP battery independently; Shparlinski's `p²k` would give 50 at the same group, above the proven ceiling ⌊C(10,2)/2⌋ = 22.

**Nothing in the headline results moved** — the `(log n)^{3/2}` / `(log n)²` / `δ₀n` ladder, the sub-linear cap and the γ threshold all live at logarithmic scale where a factor of 2 is invisible. What moved: §2.2's leading constant halved to `(A/8)^{1+α}/2`, and §6 now derives `p ≳ δ₀n` and cofactor `≤ 2/δ₀` correctly, agreeing with F.4 as it must. The document gained §1.5 and a closing rule: **any expression taken from a source that works up to constants must be re-derived from the underlying object before it touches a δ₀.**

**`check_doc_figures.py`:** the new file joins `literature-findings` in `PREFIXED_ONLY`, since it works inside a single paper and every bare "Lemma 7" / "Theorem 2" is that paper's numbering — without it the file reported 13 dangling references, all spurious. With it, 0.

## 4g. Dehistoricisation of the constants note, and a PASS 8 defect it exposed

Six passages in `shparlinski-constants.md` narrated its own drafting rather than stating what is true — the cancelling-errors box in §6, the objective-function bullet in §9, the `pkr` structural-condition bullet, the F.4-tightness parenthesis, the §3 lead-in, and the §7 closing. All rewritten to say the thing without the history: the §6 box now names the trap prospectively ("deriving this from `p²k ≥ δ₀n²` instead *also* yields `p ≥ δ₀n`, because the two factors of 2 cancel"), which is more useful to a first-time reader than an account of having fallen into it.

**PASS 8 caught none of them, for two independent reasons, and both are now fixed.**

*The exemption was line-scoped.* `EXEMPT` carries author names (`Shparlinski`, `BBKN`, `Baker.Harman`, …) so that the literature's own history is not reported — but it was tested against the **whole line**, so a single mention of an author anywhere in a sentence exempted every other clause in it. In a document about one author, where the name appears on nearly every line, **this disabled the pass entirely**: it reported "none found" on a file with six historicizing passages. Narrowing to a fixed character window has the same failure in miniature (an author named at the end of one sentence exempts the start of the next — verified, it swallowed the §9 bullet at a 60-character window). The exemption is now evaluated in the match's **own clause**, bounded by sentence punctuation, which is the unit the subject test actually encodes.

*The pattern list had no first-person-singular or self-drafting forms.* Added: `I checked|found|went looking|built|imported|…`, `my/our check|reading|draft`, `the first version/draft of this`, `this document/note/section was (first) drafted|written|commissioned`, `before/until this reading`, and `an early version of`. The plural `we found|noticed|…` was already there; the singular forms are what a single-author working note produces.

Verified by injection: all five restored phrasings fire, at the right lines and with the right labels, and the repaired file reports clean. Also verified that legitimate exemptions still hold — "Baker–Harman's exponent has since been improved", v4-era and ⟦PENDING-REBUILD⟧ labels, `--baseline` references, and "Shparlinski previously stated the bound without an exponent" all remain unreported.

**The fix surfaced three pre-existing hits** that the line-scoped exemption had been hiding: `ep` L768 (F.4's census walk, "the one shape the first draft of the proof did not cover" — rewritten to "the shape the split is easiest to get wrong on"), and two in `literature-findings.md` (L278 "narrower than I first wrote", L360 "The first version of this argument used Oliver-chain groups") which are **left as they stand for a decision** — that file's charter is arguably to record how findings were reached, in which case it belongs in `ARCHIVE` alongside `pending-checks.md` rather than being edited.

## 5. Files touched

`orbital-evasiveness-notes.md`, `arithmetic-of-density.md`, `enumeration-proof.md`, `pending-checks.md`, `literature-findings.md`, `check_doc_figures.py`, `converse_check.py`, `wide_cert.py`, `fb_common.py`, `mu_enumerate_v3.py`, in the second pass `fallback_cert.py`, `ladder_verify.py`, `validate_table_v3.py`, `ark_shapes.g`, `verify_witness.g`, in the third `arithmetic-of-density.md`, `orbital-evasiveness-notes.md`, `validate_table_v3.py`, `wide_cert.py` and `check_doc_figures.py` again, in the fourth `small-degree-computation.md`, `small-degree-verification.md`, `orbital-evasiveness-notes.md`, `stage4_fast.py`, `probe_backbone.py` and `check_doc_figures.py`, in the fifth `arithmetic-of-density.md`, `enumeration-proof.md` and `pending-checks.md`, in the sixth a new file `shparlinski-constants.md` plus pointers in `arithmetic-of-density.md` and `pending-checks.md` and one regex in `check_doc_figures.py`, and in the seventh `shparlinski-constants.md`, `enumeration-proof.md` and `check_doc_figures.py`'s PASS 8.

Not touched: the tables, `ceiling_rederive.py`, and every `*_out*.txt` / `*.log` artefact. Note that `ladder_weak.txt` **was** regenerated at N = 20,000 as a smoke test of the widened families and is not the 10⁶ artefact.

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

## 5. Files touched

`orbital-evasiveness-notes.md`, `arithmetic-of-density.md`, `enumeration-proof.md`, `pending-checks.md`, `literature-findings.md`, `check_doc_figures.py`, `converse_check.py`, `wide_cert.py`, `fb_common.py`, `mu_enumerate_v3.py`.

Not touched: the tables, `ceiling_rederive.py`, `fallback_cert.py`, the GAP scripts, and every `*_out*.txt` / `*.log` artefact.

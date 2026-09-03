# Pending checks

*What is left to run or build, for the arithmetic programme — `orbital-evasiveness-notes.md` §§1–6, `enumeration-proof.md`, `arithmetic-of-density.md`. **Outstanding work only**; anything closed moves to a session log.*

*This file is a work list. It carries what a run needs in order to be run correctly — the command, the input, the expected shape of the output, and the traps specific to that run. It does **not** carry the reasoning behind the checks: that is `verification-lessons.md`, and the explanatory logic needed while a run is in progress belongs in the script's own output.*

> **What is owed, and what merely re-runs.** Each is expanded at its own item.
>
> **Nothing here is owed as a *run*: the full R1 battery has been executed against the completed table and passed, certificates included, and their figures are now requoted into the documents.**
>
> | run | result on the completed table |
> |---|---|
> | `fallback_cert.py --verbose` | 2,187 values to n = 2759, **0 candidates**; theorem-settled 1,940/2,187 (88.7%), s-branches 2,195/2,442 (89.9%); E.3(ii) residue 247; largest permitted s = 3 |
> | `fallback_cert.py --no-theorems` | **still 0 candidates** at 0/2,187 settled by theorem — the per-n proof carries no theorem weight |
> | `wide_cert.py 100000` | ⟦PENDING-RERUN⟧ the last complete run predates the fused rung's addition to B_lo. It gave 90,297 of 90,299 with two values open, **n = 50,817 and n = 89,697**; both are now closed at those n individually (candidate lists empty, s_max 1). The headline count, the weakest B_lo density and the permitted s want requoting from a full rerun |
> | `wide_cert.py 100000 --no-theorems` | ⟦PENDING-RERUN⟧ expect **five more unresolved than the normal run**, and that is the correct disagreement rather than a defect: the five are bare pairs that E.3(ii) resolves and the mode declines to |
>
> **The two values that resisted were a B_lo deficiency, and the diagnosis is reusable.** Both are 2c + r\* with c a safe prime, r = (c−1)/2 and leftover **L = c** — the case E.3(ii)'s global promotion declines. Under the flat-cap conditions they survived at the shipped B_lo, and the natural reading was that they need the true B(n). They do not. Each candidate dies once B exceeds the foreign block's own cap, at density **0.039994** and **0.039996** respectively — just under 1/25 — so what they needed was any lower bound clearing the conjectured floor, and the fused F = 2 rung supplies δ ≥ 0.1715 and 0.1694.
>
> **`wide_cert.py`'s B_lo was missing that rung**, scoring the three-part shape unfused only (census S4, which wins nowhere) where the fused reading is the odd-n carrier and worth a factor of two on the intra term. Same missing shape, same reason, as the S7 branch `ladder_verify.py` used to cut. **The trap inside the fix is worth more than the fix:** the fused rung balances at x\* = (2 − √2)/2 = 0.29289, not the unfused 1/3, and the scan keeps only the 60 prime powers nearest its anchor — so a family added with the wrong anchor is present in the code, absent from the answer, and silent about it. At n = 50,817 the winning c sits 2,060 away from n/3. **Whenever a family is added to B_lo, derive its balance point rather than reusing a neighbour's.**
>
> *A weak B_lo is permissive, so this cost nothing but two false residues.* The opposite error is the dangerous one — an over-credited B_lo feeds the s_max and foreign-cap filters and drops candidates silently, which is what the share-pair guard in those families exists to prevent. That half is still unexercised. → **T3**
>
> **The two `fallback_cert.py` runs are evidence precisely because the dispatch fires**: 89.9% of s-branches are dispatched normally and 0% under `--no-theorems`, so switching the theorems off genuinely moves work into the search. **`wide_cert.py` at this NMAX is the opposite case** — its dispatch settles *nothing*, the foreign-cap filter having removed the s = 1 and s = 3 branches the theorems cover before the dispatch sees them, so a `--no-theorems` run there would agree trivially and is no evidence. The script says so in its own banner; believe it rather than the symmetry with `fallback_cert.py`.
>
> **The condition-(4) strip trace is now measured on the completed table** — instrumenting `set_strip_trace()` under `--no-theorems`, so that every (c, r) pair reaches the search, gives **42 strip decisions over all 2,187 rows, all 42 licensed, none at a ≥ 2** (v4 at n ≤ 1200 gave 24). So condition (4) never invokes the a ≥ 2 case anywhere in range, including at n = 2759, and the J0a exposure of the collapse is empty in fact. `fallback_cert.py --no-theorems` still prints the v4 figure from a stored string and wants updating to 42 / 2,187. One ⟦PENDING-RERUN⟧ tag remains elsewhere: `sp-to-floor.md` §7's end-to-end rerun (A23).
>
> **Re-runs, triggered by a table extension rather than owed today** — R0 and R7 are complete over their ranges and further extension is discretionary:
>
> | run | trigger | item |
> |---|---|---|
> | `validate_table_v3.py` | every batch; gates everything else | R1 |
> | `check_doc_figures.py` | every batch; replaces range-scoped figures | R1 |
> | `audit_fmid.py` | every batch; **read its coverage line before its verdict** | R1 |
> | `solvable_relaxation.py` | every batch; B ≤ B_solv on the current table | R1 |
> | `a18_verify.py`, `t5_verify.py` | range-scoped dominations, which expire silently on extension | R1 |
> | `mu_enumerate_v3.py` (extend) | only if a question needs it | R0 |
> | `ladder_verify.py --resume` | only if the range moves, or if rung B / `CAP` change | R7 |
> | `verify_witness.g` | any change to the construction; **run the `ARK_WITNESS_FTOP_SPLIT=1` control first** | R8 |

> **The table itself does not need recomputing.** The enumerator's scoring is unchanged from when the current rows were written, so rows already present are current values and a run in flight can continue. Everything owed above is downstream of the enumerator, or a script whose own scoring changed. The test for any artefact: does the script that produced it appear in the list?

**Scope notes.** The table is a **contiguous prefix plus a worklist-driven tail**; quote distributional figures over the prefix only (R0). Single-degree work — the GAP battery, the CSP, the backbone probes, the template enumerator — is in `small-degree-verification.md` with its own run list, and touches this programme only through the exhaustiveness of its GAP stages, which licenses Part I's n = 10 and n = 12 comparisons.

**Companion files.** `verification-lessons.md` — the failure-mode taxonomy and the reasoning behind the checks. `fusion-count-ceilings.md` — **⟦ARCHIVED⟧** the derivation of §3.3.5 as a joint optimum over (F, η); its conclusion is integrated, but it is keyed mod 24 and predates the entangled correction, so read it for the derivation and not for its constants. `shape-counting.md` — the enumeration, asymptotics and recomputation apparatus behind `aod` §6's counts; verified arithmetic, and in the canonical `check_doc_figures.py` invocation. `solvable-relaxation.md` — the same extremal problem with the chain relaxed to solvability; calibration only, nothing in the main line depends on it. `three-uniform-note.md`, `general-k-note.md` — the arity axis; `k3_galois.py` is the k = 3 Galois admissibility predicate, to be imported rather than re-derived. `chiral-graph-properties.md` — the A_n port. `monotone-transitive-note.md` — the general transitive setting. `literature-findings.md` — framing, deliberately not folded into the primary documents. `mu-theta-n2-note.md` and its LaTeX twin (identical in content) with `note-to-framework-bridge.md` — the standalone Θ(n²) note and its standing consistency check; **requote the bridge's §2 figures whenever a framework figure the note imports moves** (currently: the ladder floor with its range and argmin, and the mod-12 ceiling values). The **Lean formalisation** (`Basic.lean`, `Note.lean`, own `README.md`) tracks these documents and can fall out of step silently — see A9. `three-part-family-split.md` and the two resolution notes `a18-resolution.md` and `t5-resolution.md` are **⟦ARCHIVED⟧**, each carrying a banner saying what was integrated and what has moved; the resolution notes' *mathematics* is current and is the authority behind Lemma D2's replacement and Lemma C's coupling, and `a18-resolution.md` §4's r = q sub-case is still open. Session logs hold the review record, `session-log-11.md` current.

**Status labels.** *Verified* — an independent computation agreed. *Sound* — an argument was read and found correct. *Unverified* — neither.

*Do not restate the inequality as `B_safe ≤ μ`.* `B_safe` over-counts per configuration; what holds is B_refined ≤ μ ≤ B_safe, the endpoints collapsing where the certificate applies.

## The enumeration-proof gap inventory

*One place for the daylight between what `enumeration-proof.md` proves and what it verifies. Fresh-eyes read of the full document, 2026-08-18 (session-log-8 §21). The gap has moved in both directions since the document began — unexpected winners found (cyclic-layer block counts, the fused rungs, the Fermat escapes, the two-foreign shape at the extremes) and exclusions gained (E′'s collapse machinery, the D2′/C′ dominations, q-pinning) — and this is what remains between the two:*

1. **Part 0 completeness** (μ ≤ B_safe's whole load): a shape missing from the space fails silently. Three tests could see one, and all three are independent of the enumerator rather than derived from it — the exhaustive GAP comparisons at n = 10 and 12; **B ≤ B_solv**, which a *mis-scored* shape can violate even though a missing one cannot (R1 step 7); and the **S2 identity** δ_S2(n) = (Q(n) − 1)/(n − 1), arithmetic where the table is a search output. Verification-lessons §1 site 4. → risk item 2 below, `small-degree-verification.md` item 5, A24.
2. **The two-part reduction of Theorem 2.3**: verified to n = 1200, Goldbach-tier to prove; nothing rests on it but B₀'s O(n) cost claim.
3. **Minimality k ≤ 3 below δ = 1/16** (J item 1): free above 1/16 by F.3; counting saturates at 4 (F.2 is tight); any proof is arithmetic — must *produce* a strong ≤3-part decomposition — and the wide B₃/B₂ margins close the perturbation route.
4. **The collapse's theorem-side residue** (J items 2, 2a): E.3(ii)'s global promotion (the leftover case; the bare pair is resolved), and the s = 4 / s = 5 branches, theoremless and reachable only below δ = 1/25 and 1/36 respectively (sharp thresholds — the s-ladder, not F.3's k-ladder). Per-n the certificates close everything; the gap is only over *all* n.
5. **J0a's non-semilinear stabilisers**: **largely discharged** (T2). A non-ΓL(1) stabiliser cannot beat the field one at the same twist order — orbits are bounded by the group order and the field subgroup is semiregular, so it attains that bound everywhere at once. B_safe was untouched either way; what survives is the narrower **primitivity** point, that a subfield-order twist needs Frobenius to stay irreducible, which is a reading of Part E against a stated condition.
6. **Lemma B′**: proved, second reading done and confirmed; the one structural lemma whose failure would break B_safe itself, so further scrutiny stays profitable. → T1.

*Everything else in the document is proved, and the per-n machinery (eight necessary conditions + search) makes each computed value unconditional independently of items 2–4.*

**Not on this list, because it closed:** the converse direction — that a density floor *forces* a shifted-prime statement — is now Proposition F.4 of `enumeration-proof.md`, with the discussion in `aod` §6.7. It is elementary given F.1's machinery and needed no new input. **What it opens instead is a sharpening question**, which is a research item rather than a gap: the round trip (BCG_{1/5}) → δ₀ = 1/350 → D = 630 loses a factor ~52 against its own d ≤ 12, uniformly across both branches. *(F.4's cofactor bound is D(δ₀) = 2(1 − √δ₀)²/δ₀ rather than the crude 2/δ₀ — the sharper form follows from Proposition F.1's own part-size bound, since a configuration carrying a foreign part carries a second part too, and it holds with zero violations across the table. At the verified floor it gives 25.4 against a measured maximum cofactor of 12, so the remaining slack is ~2.1 rather than ~3.5.)* Whether either direction can be tightened — a better constant in the note's central inequality, or a converse that reaches a prime rather than a prime power — decides how close to a genuine equivalence this is. Neither is needed for anything currently claimed.

**Staleness defects already closed, listed so they are not rediscovered.** *The counts quoted inside this paragraph are the ones that were in contradiction at the time; do not read them as current census figures.* Four, all now corrected in the documents: the notes §1 SAFE-cap box prescribed the **F_mid strip** that the entangled-generator repair removed, i.e. the box warning readers off the wrong cap taught the wrong cap (the live cap in `mu_enumerate_v3.py` is the flat F·C(c,2), and `ep`'s four "F·orb(c, dmax)" descriptions of B_safe are now flat too — the F·orb(c, dmax) form survives only where it belongs, in the certificates' leftover twist cap); `aod` §3.3.5 quoted **cap₂(1/6) = 0.050510**, which is cap₄(1/6) — the correct value is (2 − √3)/4 = 0.066987, so the F = 4 margin at class 11 is 0.0048 and not 0.021, as §6.6 already had it; three surviving mod-24-era constant counts ("seven mod-24 ceilings", "eight constants", "seven distinct δ₀") against the table's six mod 12; and two winner counts contradicting the census in the same document (150/24 against 338/30 for the fused `2×c + r*` rung; 20 against 18 for the `2×c + 257*` Fermat winners, whose list also contained two n won by F = 4 shapes). `check_doc_figures.py --pass scope` now carries greppable invariants for the first and third of these.

**Owed source check — the E–H exponent's exact form.** `aod` §3.6 and `literature-findings.md` now state Shparlinski's §5 Elliott–Halberstam consequence as n^{3/2−ε} for every ε, on the grounds that E–H is quantified for fixed ε > 0 (level z^{1−ε}) and so no single application reaches 3/2. **This is inference, not a quoted bound** — the §5 remark states the improvement without writing an exponent, and the arXiv version is what was read. Confirm against the published version; if he does claim a bare n^{3/2}, the reasoning behind it needs recovering, since the unconditional n^{5/4+o(1)}'s `+o(1)` is the subpolynomial-loss convention and does not supply the difference.

## Where the residual risk sits

*Ranked, so the item order below has a stated basis. The reasoning behind this ranking — the failure-site taxonomy it comes from — is `verification-lessons.md` §1.*

> **One class has left this list entirely.** The arithmetic layer — the inequalities, the cap algebra, the threshold ladders, the six ceiling constants — is now **formally proved** (A9), so an error there is no longer a risk to rank but a contradiction that fails to compile. That is worth stating because it was never the top item and its removal does not reorder anything: what remains is what formalisation cannot reach, exactly as the Lean README predicted. The residual risk is now **entirely** realisability, completeness, and the reading of arguments — group theory and prose, not arithmetic.

1. **Part E's realisability.** Ten values now verified end to end — the battery returns `true` on every row, including the composite-F construction the entangled correction turns on — so this is **evidence-backed at ten points rather than untested**. What keeps it at the top is what those points do *not* reach: **even F = 4**, the fusion count that sets the ceiling at n ≡ 11 (mod 12), and **n = 2759**, the one n where the framework claims μ *exactly* and whose binding class is a foreign block at a proper prime-power twist order. → **T2**, **R8**
2. **Exhaustiveness of the GAP stages.** The only non-circular check in the framework; the subdirect-product hole is undischarged. → `small-degree-verification.md` item 5
3. **The table's and ladder's reach — no longer in motion, and demoted for that reason.** The contiguous range is complete to 2600, the ladder to 10⁶ with an exact minimum at n = 2759, and further extension is discretionary. What remains is that both are *finite*: nothing here bears on n beyond 10⁶. → **R0**, **R7**, **R1** after any discretionary batch.
4. **§3.3.5's ceilings.** Exposure is the shared supply hypothesis. The class-11 entry rests on 676 > 675, but **both sides of that comparison are now independently reproduced** by the circle-method route, which selects the same winner and the same runner-up from congruences alone (`aod` §6.9(b)) — so the argmax is no longer part of the exposure, only the supply. → **T6**
5. **The κ parameters at k = 3.** Whether κ can be steered independently of the congruences fixing F and η. No risk to k = 2. → **T7**
6. **Proposition F.4's reliance on Lemma B′.** Branch (b) is vacuous unless a foreign twist is a prime power, which is B′'s content — so the exposure is B′'s correctness (item 1 above) plus one reading of a new argument, not an unstated assumption. The proof's shared-chain-prime step now carries **both** of its branches explicitly, the s = q case running through Lemma B′ Case 2 rather than through the "only Γ₂ can hold it" sentence, which is false there. → **T8**
7. **The eight necessary conditions of `fb_common.py`.** Both certificates rest on these plus **one** dependency underneath them, and what matters is *necessity*. → **T3**, and the one named in `fb_common.py`'s header: foreign parts are scored **unfused**, so what excludes a fused foreign class is Lemma D2's domination and not any condition in the list — its range-scoped half is `a18_verify.py`, so quoting the "eight conditions alone" banner without it overstates the result. *Condition (4) is the flat SAFE cap F·C(c,2), so no twist strip is applied and neither Corollary C′ nor J0a is in the base at all; the strip survives only as an unread diagnostic. That is a smaller base than the previous strip-gated version had, and it is measured rather than argued: with flat caps and `--no-theorems` the candidate list is still empty at every row.*

---

# §1. Script runs

*Can be launched in the background. Flags are checked against the scripts as they stand; where a run needs code that does not exist, that is said rather than papered over with a plausible-looking flag.*

## R0. Extend the table, then rerun everything downstream

**DONE, and further extension is discretionary.** The rebuild is complete over the contiguous range **[6, 2600]** — all 2,186 eligible n, no gaps — plus one worklist row at **n = 2759** consumed under R7. `mu_table_safe_v4.csv` is the **baseline, not the current table**; its rows are lower bounds and 289 of them are known low. Extension costs roughly n^2.9 per value, so the next decade is expensive and nothing in the framework is waiting on it: decide to extend because a specific question needs it, not as owed work.

```bash
python3 mu_enumerate_v3.py --nmax <N> --fill-gaps --out mu_table_safe_v5_code_v3.csv
```

- **Use `mu_enumerate_v3.py`.** An enumerator whose SAFE cap cuts a fused class's twist by the block count produces lower bounds, not values — such a table may be a baseline, never an extension.
- **Rows above the contiguous frontier are worklist rows, not range.** Values consumed under R7 are appended to the same CSV and are a low-density subsample. Quote distributional figures over the contiguous prefix; quote the floor and "nothing below X" over the whole file.
- **A rebuild must never lower a value.** `validate_table_v3.py`'s group-A monotonicity check against `--baseline` is the signature to read on every batch.
- **Rebuild the R7 worklist afterwards** — its pruning is keyed to a floor that has moved.
- **Extending re-arms three things**, and they are easy to miss because none of them errors: the prefix/tail discipline (a worklist-driven extension selects by low score, so aggregates must be requoted over the contiguous part); every range-scoped claim of the form "at every row of the table", which is a *different statement* after the table grows; and `shape-counting.md` §3's floor rows, which are keyed to the computed floor.
- **Append the old maximum to `check_doc_figures.py`'s `CHECKPOINTS`** on every extension. Two minutes, and skipping it turns every correctly-scoped historical figure into noise in PASS 1.

## R1. Routine, after any new batch of table values

> **R0/R1 are DONE over [6, 2600], and expectations are live again.** The rebuild is complete over **all 2,186 eligible n** — composite, non-prime-power — with no gaps, plus a single worklist row at n = 2759 from R7, and the full R1 battery passes: `validate_table_v3.py` **24 PASS / 0 FAIL / 14 INFO / 2 SKIP** with `--baseline` supplied (23 PASS without it, the baseline-only checks skipping), `converse_check.py` 0 violations with max cofactor 12 at (221, 157, 13), the S2 identity clear at every row, and per-n monotonicity showing **0 rows lowered and exactly 289 raised** — the exceedance list, row for row. Further extension is **discretionary**: nothing in the framework is waiting on it, and a decision to extend should be made on what a specific question needs rather than as owed work.
>
> **If the range is extended, three things re-arm.** The prefix/tail discipline (a worklist-driven extension selects by low score, so aggregates must then be requoted over the contiguous part only); every range-scoped claim of the form "at every row of the table", which is a different statement after the table grows; and the floor rows of `shape-counting.md` §3, which are keyed to the computed floor.
>
> Reference points so a deviation is recognisable: `validate_table_v3.py` gives **0 FAIL** on an enumerator output under the current scoring, but **not** when pointed at a *baseline*, where group A's re-derivation check fires on every row whose recorded winner is a cyclic-fused class scored under the superseded cut twist (18 rows on v4; see A22, which pairs that count with the 289). The S2-identity check in group B is deliberately *not* a second FAIL on a baseline: it returns INFO naming n = 78 and n = 222, which are the correct baseline answer, and FAILs only on some other set. `check_doc_figures.py` does not go to zero — most PASS 1 flags are coincidental numeric matches, so read it finding by finding. Certificate counts are requoted from their runs rather than carried forward; both certificates have been run against the completed table, returned 0 candidates, and their figures are now in `ep`'s certificate box and `aod` §5.1. The collapse coverage came back **unchanged at 90,299 of 90,299**, which is the outcome the entangled repair made uncertain — the repair removed an anti-permissive strip, so the candidate lists could have grown and did not. The ⟦PENDING-LADDER-REBUILD⟧ tags introduced to isolate the ladder are discharged with it: that run completed at floor **175813/3804661 = 0.046209898…**, n = 2759, nothing below 1/25 anywhere.

> **The adaptive follow-up at floor 0.05 is also complete, and it terminated after one value.** `mu_enumerate_v3.py` computed **B(2759) = 175813**, i.e. 175813/3804661 = 0.046209898…, equal to the ladder's own bound there. *(Quote the fraction, not the 5-place rounding: 0.04621 lies above the true value and cannot follow a ≥.)* M was then pinned below every remaining ladder value, so all other candidates were skipped and nothing further was written. **The skips are a result, not an omission:** every other n in range has a ladder lower bound strictly above 0.0462099 (next is 0.04801 at n = 11183), so none can be the minimiser and none needed computing. **Capture such skips from the log at the time**: the CSV shows a hole where the run proved a bound, and a gap between 2600 and the next row later reads as an unfinished job.
>
> **This makes the range minimum exact rather than bounded.** Ladder ≤ μ ≤ B pinches at 2759, so μ(2759)/C(2759,2) = 175813/3804661 exactly, granting the μ ≤ B_safe direction — and it is the unique global minimiser over n ≤ 10⁶. The table now carries **one row beyond its contiguous range**, n = 2759; `converse_check.py` and `validate_table_v3.py` both already scope their aggregates to the prefix and report it as tail, so no re-scoping was needed. A validator asserting a congruence on the matching block's residue would FAIL on any correct table.

Each of these is a per-n statement that does not extend itself. Point them at the current enumerator output with the previous table as `--baseline`. **Run in order — the first gates the rest.**

```bash
TABLE=<current enumerator output>
BASE=<previous table>

# 1. gates everything: is the file a well-formed enumeration?
python3 validate_table_v3.py $TABLE --baseline $BASE --ladder ladder_weak.txt

# 2. the per-n collapse certificate
python3 fallback_cert.py $TABLE --verbose
python3 fallback_cert.py $TABLE --no-theorems

# 3. the same certificate beyond the table, against a proven lower bound
python3 wide_cert.py 100000

# 4. the range-scoped halves of Lemma D2's and Corollary C'''s domination
python3 a18_verify.py $TABLE
python3 t5_verify.py $TABLE

# 5. Proposition F.4's inequalities, and the two constants the documents quote
python3 converse_check.py $TABLE

# 6. the shared-block-count screen -- read its COVERAGE line before its verdict
python3 audit_fmid.py $TABLE

# 7. the solvable relaxation; only its comparison pass reads the table
python3 solvable_relaxation.py $TABLE

# 8. the documents against the table; this replaces the pending figures
python3 check_doc_figures.py $TABLE *.md
```

**What to read off each.**

- **`validate_table_v3.py`** — pass both `--ladder` and `--baseline`; they enable two cross-artefact checks for the cost of a dict join. **Group A** FAIL: the run or parser is broken, nothing downstream is meaningful. **Group B** FAIL: a real contradiction between table and documents. **Group C** is INFO, each line printing the expected asymptotic beside the measurement. `--explain N` for one row's term breakdown, `--baseline` for shape-migration reporting. Full description of the three groups: A0b.
- **`fallback_cert.py`** — headline is *0 candidates*. Then read the **density floor**, the **largest permitted s** and the **theorem residue**, off the run itself: they move together (s ≤ 1/√δ − 1), and **s = 4 is the first branch with no theorem covering it**. If `largest permitted s` prints 4, `enumeration-proof.md`'s Corollary after E.3 and Part I's tail figures want re-deriving. `--no-theorems` should agree exactly — but measure whether the dispatch is firing, or the agreement is vacuous.
- **`wide_cert.py`** — read `settled by theorem:`. At NMAX ≤ 10⁴ it prints NONE and a `--no-theorems` comparison there is no evidence. `--menu` cross-checks pass 1; `--refresh` rebuilds the cached B_lo.
- **`a18_verify.py`** — Lemma D2's witnesses plus its **range-scoped** fused-outside domination, which a table extension can invalidate silently.
- **`t5_verify.py`** — Lemma C's coupling and Corollary C′, plus the three facts gating condition (4)'s strip (T5). Its last pass is **range-scoped**.
- **`converse_check.py`** — headline is *0 violations*, but the run is for the two constants rather than the verdict. **Max cofactor** is quoted in `ep` F.4 and `aod` §6.7 as **12**, matching (BCG)'s own d ≤ 12; that coincidence is the reason to look, and a value above 12 weakens the claim that (BCG)'s constant is the natural one rather than a chosen one. **Slack** is quoted as ≈ 4 in the gap inventory. *These two behave differently under a rerun and the difference matters:* max cofactor is a maximum over witnesses, so it moves only if the corrected shape space changes which primes win; slack is max-cofactor against 2/floor, so it moves whenever the **floor** moves and is therefore **range-dependent even on a correct table** — at the v5 partial frontier (n ≤ 1546) it reads 2.9 against v4's 3.6 purely because the floor over a shorter range is higher. Requote slack with its range, and do not read a change in it as a finding.

- **`audit_fmid.py`** — headline is *0 shared-F_mid configurations scoring above B(n)*, but **read the coverage line first**: it reports how many non-prime-power n in range are absent from the table and therefore unscreened, and a clean verdict over rows never screened is indistinguishable from a pass. It screens only the low-density rows (461 of 2,186 at δ ≤ 0.13 on the current table) — a scope statement, not a shortfall. The screen compares an optimistic candidate against the recorded B(n), so a stale table makes it *miss* rather than merely go quiet. **It is the only artefact behind the shape space's shared-block-count admission** — the other two ways a block count could have mattered are covered by argument, Part E's diagonal carrier and a counting bound on foreign primes — so a hit is a configuration to score exactly, not a reason to tighten the admission.
- **`solvable_relaxation.py`** — all passes should be PASS; B_solv ≥ B_safe is structural, so a FAIL there means the Oliver side credits a class no solvable group carries. Two INFO lines are printed rather than asserted and both look alarming without their reason: the **class-11 share** (91 of 119 tabulated values exceed 7 − 4√3) is expected, because the ceilings bound the balanced additive family and not μ; and the **attainment share** (916 of 2,187) is the S2 identity showing through, every row whose winner is a fused matching class landing on it exactly. Requote both from the run rather than carrying them forward. Its ratio distribution — median, per-parity medians, maximum — is still v4-era and owed a recount.
- **`check_doc_figures.py`** — `--quiet` for findings only, `--pass {figures,scope,prose,hygiene,census,refs,tables}` for one pass. **Pass every `.md` that might be cited**, or `refs` reports live citations as dangling. Append the old maximum to `CHECKPOINTS` and a pattern to `SCOPE` in the same sitting, or superseded-range figures report as unexplained rather than historical.

**Add to step 1 if not already there:** **B(n) ≤ B_solv(n)** must hold at every row, Oliver groups being solvable. O(n) partition scan per row, no certificate needed — currently 0 violations with exact attainment at 916 of 2,187 rows. Step 7 of the block above runs the full version, which is the cheapest independent check available on any rebuild: no certificate, no GAP, no second enumeration.

**Static — one run per environment, not per batch.** `eta_derive.py` (the η column, derived and measured independently), `khomog_verify.py` (the k-homogeneity claims behind the `notes` §1 hypothesis table), `a18_rq_verify.py` (nine checks on Lemma D2q), `k3_galois.py` (the k = 3 Galois predicate, with its own self-test).

**Deliberately absent.** `ladder_verify.py` never reads the table — it belongs to R7. `s7_scan.py` and `mu_fast.py` are not in the working set; group B covers what `s7_scan.py` would test.

**Do not extend the table without rerunning this list in full.** `check_doc_figures.py --pass refs` and `validate_table_v3.py`'s coefficient assertion are what catch the omission mechanically. The Lean statements are read by no check here — see A9.

## R6. Shape-level scoring checks

*Score **shapes**, not rows, so they do not rerun on table extension. Rerun after any change to the SAFE cap, to `orb`, or to `mu_enumerate_v3.py`'s scoring. `k3_galois.py` belongs to this class too — it takes no table and scans a fixed range, so one run per environment suffices.*

```bash
python3 shape_realize.py --nmax 34            # expect 0 mismatches
python3 shape_realize.py --nmax 22 --strip    # control: expect UNDER-SCOREs
ARK_SHAPES_NMAX=100 ARK_SHAPES_MAXF=4 gap -q -o 8g ark_shapes.g
ARK_SHAPES_NMAX=200 ARK_SHAPES_MAXF=2 gap -q -o 8g ark_shapes.g
ARK_SHAPES_STRIP=1 ARK_SHAPES_NMAX=100 ARK_SHAPES_MAXF=4 gap -q -o 8g ark_shapes.g
gap -q -o 8g oliver_negative.g                # the admissibility predicate's negatives
```

- **Read the control before the green run.** Expect UNDER-SCORE at exactly the shapes where stripping **changes** orb(c,d) — check against that predictor, not a remembered count. It is *not* "wherever gcd(d, F) > 1", which names about twice as many rows.
- **`-o 8g`, not `4g`.** The maxf = 2 sweep's largest groups reach order ≈ 1.8 × 10⁶ on 194 points; 4 GB truncates. `ark_shapes.g` FAILs on a row without a verdict rather than summarising over it.
- **`oliver_negative.g`** ends in a single PASS/FAIL and writes `oliver_negative_out.txt`. Part B needs the `transgrp` package; without it the part is skipped and counted as a failure. `OLIVER_NEG_DEGMAX` widens it, `OLIVER_NEG_CRANK` bounds part C's lattice cost. Its part D prints **two verdict columns and asserts one** — a rejected witness alongside a successful search is the designed behaviour.

**Still owed** — *none blocked; all buildable in `shape_realize.py`'s existing Python. Order below is by cost.*

1. **The foreign block's η = 2t/(r−1)**, against a realised AGL(1,r) twist. Cheapest by a wide margin: a foreign block is a *prime* block, so no field construction arises. Wants a `--foreign` mode with a `--strip` control.
2. **The inter-class term F·c·r.** The "chain element linking two classes" is one generator — a diagonal element acting as the twist on the matching block and as twist or translation on the foreign one. Build matching blocks through the existing `field()` basis, or restrict a first pass to prime c.
3. **Lemma C's foreign strip.** Highest value of the three. The target is not "did the matching block lose its twist" — forcing twist and foreign translations into one cyclic layer leaves the matching intra at full score — but **the largest foreign twist still realisable once the layer is cyclic, against what the enumerator credits**. A statement about the foreign term, so it wants item 1 first.

## R6a. The ceiling table's re-derivation — conditional rerun only

*Currently clean and not owed. Rerun if `arithmetic-of-density.md` §3.3.5 changes or the script does; it scans configurations, not table rows, so an extension does not trigger it.*

```bash
python3 ceiling_rederive.py --nmax 24000 --mod12     # expect all six approached from below, all pairs agreeing
python3 ceiling_rederive.py --nmax 16000 --no-filter # control: expect exceedances at 3, 5, 7, 11
```

**`--no-filter` must exceed, and its witnesses must be prime powers.** A composite c in that column means the candidate list is admitting block sizes no Oliver group has, and the escapes it reports are partly phantom.

## R7. Consume the ladder worklist with the adaptive branch-and-bound

> **R7 IS DONE at the corrected scoring, and the rerun changed the tail without touching the floor.** Run to 10⁶ against a floor of 0.04: **44,091** worklist entries (down 1,299), minimum **0.04621 at n = 2759**, nothing below 0.04, and the ladder tight against B at all **28** joined values where the pre-fix run was short at 16 of 37. Decade minima 0.05703 / **0.04621** / 0.05829 / 0.06391, so the descent is one decade wide as a statement about δ rather than about the scan. Exactly two entries fall below 0.05 — 2759 and 2183 — both already in the μ table, so no further exact B below 10⁶ can move the floor; the independent adaptive `mu_enumerate_v3.py` run at threshold 0.05 returns the same two values and the same global minimum. `validate_table_v3.py --ladder` now passes.
>
> **What the change was, and why it needed a rerun rather than a patch.** The cut valued a fused class at F·orb(c, dmax) with dmax stripped of F_mid's primes; that is not a necessary condition (entangled generators realise the full twist at any F_mid), and it understated the family at even F with c ≡ 1 (mod 4) — halving the intra term exactly at the fused-plus-foreign shapes that win at the arithmetically weakest n. An understating ladder is still a valid floor, so **the minimum 175813/3804661 at n = 2759 and its uniqueness are unaffected** (that value is tight against B). What is superseded is the *shape* of the low tail: worklist membership, the decade minima, and which n are worth an exact B. Against the computed table the corrected scoring is tight at all 37 joined values where the cut left 16 short by up to 1.81×. **`--resume` will refuse, correctly, since the source hash has changed; this needs a full rerun.**
>
> **What the run establishes.** `ladder_verify.py` to 10⁶ under the corrected scoring produces a **44,091-entry** worklist with minimum 0.04621 at n = 2759 and nothing below 1/25, so the 0.0400 run prunes everything and writes no rows. The 0.05 run computed **one** value — **B(2759) = 175813**, i.e. 175813/3804661 = 0.046209898… — which *equals the ladder bound there*, pinning M below every remaining entry and skipping the rest. **The skips are the result**: no other n can be the minimiser, because every other ladder bound is strictly above it.
>
> **Run the ladder before consuming its worklist**, and rerun it on any change to a rung's scoring or to `CAP`. *(The v10 run is current; `--resume` correctly refused the v9 state, the source hash having changed.)* `ladder_verify.py` scores rung B **and the S7 branch** at the full twist and keys `CAP` mod 12, so a worklist or floor from any other scoring ranks against the wrong ceiling. **The check that catches a scoring regression here is `validate_table_v3.py --ladder`**, whose gap check FAILs when the ladder falls short of B at any joined value — which is how the cut was found, and the reason that check is a FAIL rather than an INFO: an understating ladder is sound, so it fails silently everywhere else.

```bash
python3 ladder_verify.py 1000000                      # regenerates ladder_weak.txt
python3 ladder_verify.py 2000000 --resume             # extend, reusing the prior scan
python3 mu_enumerate_v3.py --nlist ladder_weak.txt \
        --floor 0.0400 --adaptive --out <current table>
```

> **`--resume` makes extension cheap, and it is exact rather than approximate.** The per-n scan is *clamped*: it stops as soon as a value clears the asymptotic bound, so for every n above that bound the run learns exactly one thing and records nothing finer. Every n it learns more about is by definition in the worklist. So a completed run's worklist plus its N already contains everything the scan produced, and a resumed run reproduces a from-scratch one **byte for byte** — verified by running 20,000 in one pass and as 8,000 + resume, with identical worklists and identical per-class statistics.
>
> State lives in a sidecar `ladder_weak.txt.state.json` (override with `LADDER_STATE`), never in the worklist itself, whose format `mu_enumerate_v3.py --nlist` depends on. **It records N, not max(worklist)** — the point of resuming is knowing which n were examined and *cleared*, which is exactly what the worklist does not say.
>
> **The resume refuses on any edit to the script**, comparing a hash of the whole source. That is deliberately conservative — there is no reliable way to distinguish a scoring change from a comment, and the asymmetry is stark: a spurious full rerun costs hours, a silently mixed worklist costs the credibility of every figure drawn from it. It also refuses if the worklist and state disagree on length, if a worklist line is malformed, or if the asymptotic bound has moved (which would invalidate "absent means cleared").

**The result, stated as a fraction because a rounded figure cannot follow a ≥:**

> **min { μ(n)/C(n,2) : n ≤ 10⁶, composite, not a prime power } = 175813/3804661 = 0.046209898…, attained only at n = 2759.**

The ladder gives μ ≥ this unconditionally (it exhibits groups); B gives μ ≤ this at 2759 granting μ ≤ B_safe. The two pinch, so the range minimum is **exact**, not bounded — and the ~997,000 uncomputed n need no B(n), since the ladder already places each of them above it.

**What `--floor … --adaptive` does that a plain `--nlist` run does not.** Prunes on the supplied lower bound (LB(n) ≥ floor already proves δ(n) ≥ floor); seeds unpruned n at floor·C(n,2) so it need only find *some* clearing configuration; appends exact rows to `--out` with the full schema and witness, never rewriting or reordering; and reads the table back as prior knowledge, so existing rows tighten the search.

**Set the floor to the question.** It is an interrogation threshold, not the known answer — setting it to the current floor prunes everything.

| `--floor` | what it settles |
|---|---|
| **0.0400** = 1/25 | whether any n leaves room for **s = 4**, the first fallback branch with no theorem |
| the current table floor | whether anything undercuts it |
| the ladder's global floor + ε | whether the argmin's B(n) exceeds the ladder bound there — **run; it does not, they are equal** |

Run in that order; the cheap one may answer the expensive one's question. `--nmax` caps a `--nlist`, which is how to defer five-figure entries — at n^2.9, n ≈ 50,000 costs roughly 10⁴ times an n = 2,000 row.

**Cautions.**

- **Needs R0 finished** — pruning and the part-count cap are both keyed to a floor read off the table.
- **A skipped n is a recorded result, not a gap.** Adaptive mode writes nothing for an n it prunes, so the CSV shows a hole where the run proved a bound. Capture the examined-and-cleared set from the log at the time; six months on, a gap between 2600 and the next row reads as an unfinished run rather than a finding.
- **Never combine with `--refined`.** The script refuses it: adaptive mode appends rows, the schema records no mode, so a refined row in an unconditional table would be undetectable.
- **Rerun R1 afterwards** — the job extends the table.
- **Do not overwrite the worklist.** `LADDER_OUT` is honoured; each run's file is the evidence for §3.7 and §5.2.
- **Probe before committing an expensive n.** A targeted scan over the two-part census shapes, scored with `mu_enumerate_v3.py`'s own `value()`, settles the floor question whenever the answer is "clears". It reproduced B(n) exactly at all eleven worklist values where B was independently known.

## R8. Widen the Part E realisability battery

*The one leg of μ(n) = B(n) with no per-n check. **RUN — and it found two defects in its first outing, both in the battery rather than in the framework.** Details below; neither is a μ ≤ B violation, and every constructed group scores at or below the current B(n).*

> **Defect 1: the `BATTERY` list's expectations are stale, and one is pre-entangled.** Four of eight rows quote a `mu_bound` matching no current table: n = 26 gives 36 against B = 156, n = 35 gives 105 against 120, n = 308 gives 4134 against 5671, and n = 247 gives **1314 against 2525** — the only one that FAILs, because 1314 is not even that configuration's own score. It is `F·c·18/2` with the matching twist **cut from 72 to 18**: a pre-correction value. The constructed group takes the full twist, so its matching intra is 2·C(73,2) = 5256 and the minimum passes to the foreign class at r·Q = 101·25 = **2525**, the odd-Q rule. **So the FAIL is the battery working**: the expectation was computed under the superseded cut, the assertion fired, and it fired in the direction that matters — the old expectation *under-scored*. Update the row to 2525, and regenerate every expectation from the current table rather than hand-maintaining them.
>
> **Defect 2: the chain construction cannot build a composite F, which is the flagship case of the entangled correction.** At n = 78 = `6x13` the script splits F = 6 by `ftop := largest q-power dividing F` → ftop = 2, fmid = 3, putting *part* of the block rotation in the top layer. That is the pre-entangled decomposition, and it does not close: the entangled generator carries its multiplier at one specific wrap boundary, conjugation by the top rotation moves that boundary, and G₁ is not normal in G — the error GAP reports. **The correct group puts all of F in the cyclic layer with a trivial top:** a single F-cycle on blocks with step-multipliers whose product is a primitive root, here (2,1,1,1,1,1) mod 13, giving ⟨z⟩ ≅ C₇₂ cyclic. *Verified independently:* that construction yields orbitals **{468, 507, 1014, 1014}**, matching `entangled-generator-finding.md` exactly, with min 468 = B(78). **The fix is to prefer fmid = F, ftop = 1** — use the top layer only when the configuration genuinely needs it — which is also what makes the n = 33 and n = 105 regressions meaningful rather than accidental.

**Both defects are fixed and the battery now returns `true` on every row**, including the composite-F row n = 78 that previously aborted. **Rerun both paths after any change to the construction:**

```bash
ARK_WITNESS_FTOP_SPLIT=1 gap -q -A -o 8g verify_witness.g   # must still abort at n = 78
gap -q -A -o 8g verify_witness.g                            # then the fixed path
```

> **`-A` is belt and braces, not a requirement.** The script defined a global named `Orb`, which the autoloaded `orb` package owns and makes read-only, so without `-A` it aborted with `Variable: 'Orb' is read only` — a message naming a variable rather than this file. That global is now `ArkOrb`, and a **collision guard** at the top checks every global the file defines and, on a clash, names it and says what to do. *Renaming beats requiring the flag*: a script that is only correct under a start-up option fails exactly for whoever omits it, and the failure does not point at the cause.

The control restores the old split and must still reproduce the `G/G1` normality abort at n = 78; **if the control ever passes, the fix has stopped doing what it claims** and a green run of the default path means nothing. The corrected placement was also checked outside GAP by direct orbit enumeration: {20, 25} at n = 10, {30, 75} at n = 15, {468, 507, 1014, 1014} at n = 78.

**Coverage now**: ten rows, largest n = 308, spanning the fused rung at F = 2, 3, 5 and 6, a trivial-top attainer, cyclic-layer fusion beside a foreign block, Lemma C's worked example, and the three entangled-generator regressions. **What is still uncovered** and is what a widening should target, in order:

1. **n = 2759**, the range minimiser and the one n where the framework claims μ *exactly* rather than boundedly. Its binding class is the **foreign** one at r·Q with Q = 11² a proper prime power — a stratum no current row reaches, every other foreign row here having prime Q.
2. **Even F ≥ 4**, where the cross-class coefficient is (F/2)·c² rather than F·c². The battery has F = 6 at n = 78 but no F = 4, which is the fusion count that sets the ceiling at n ≡ 11 (mod 12).
3. **A two-part row from the current table's own census**, since eight of the ten rows are configurations that are no longer winners at their n.

*A note on why the composite-F row was the one that crashed: the rebuild around the entangled generator reached the **twist** and not the **block-rotation placement**, and only a composite F exercises the second. Coverage before this pass was twelve values from the superseded battery, largest n = 575.*

**Step 1 — run the battery.**

```bash
gap -q -A verify_witness.g          # no argument runs the battery
WITNESS=... MUBOUND=... gap -q -A verify_witness.g   # a single row
```

Entries n = 20, 255, 282, 323, 575, all at battery speed, covering both branches of `ConstructionTwists`:

- **F a q-power** — n = 20 (F = 4, q = 2): F_top = F, F_mid = 1, twist not stripped, intra 4·orb(5,4) = 40.
- **F not a q-power** — n = 255, 323, 575 (F = 4) and n = 282 (F = 6, both 2 and 3 in the cyclic layer): twists [21, 41], [21, 25], [51, 81], 46.

Plus three **entangled-generator regressions** whose orbital multisets are known from an independent build: n = 33 → {21, 156, 169, 182}, n = 78 → {468, 507, 1014, 1014}, n = 105 → {812, 841, 1081, 2726}. **A failure there is a finding about the construction, not a malformed entry** — those are the rows that fail if a twist cut by the block count is reintroduced anywhere.

**Step 2 — a stratified sample, once step 1 passes.** One row per census shape, both parities, each of the six odd classes mod 12, preferring the **lowest-density** row in each stratum. Then the extremal rows: the table floor, and the lowest worklist entries with B(n) computed. **Even fusion counts are the priority** — S7 at F = 4 attains the class ceiling at n ≡ 11 (mod 12) and has the thinnest construction evidence.

**The scaling limit.** `OrbitalSizes` materialises `Combinations([1..n], 2)` — 690k entries at n = 1175, 3.4M at n = 2600 — which binds well before the table's frontier. Port it to union-find (about 3 s at n = 1175 outside GAP) and keep the chain and multiset checks where they are. **Do not drop the chain check to buy speed**; it is what distinguishes this from a re-derivation of the value formula.

**What a pass settles:** that the enumeration's score at that n is *attained*, μ(n) ≥ B(n). Not completeness. **J0a it now largely covers by argument rather than by test:** the twist is built inside the field's multiplicative group, and no other stabiliser of the same order can do better, since orbits are bounded by the group order and the field subgroup is semiregular (T2). What it still cannot see is the primitivity point — at a subfield-order twist the field subgroup is reducible and the construction needs Frobenius.

> **n = 2759 is now the highest-value single row in this battery.** Its B(n) equals the ladder's lower bound there, so it is the one n where the framework claims to know μ *exactly* rather than to bound it — and that claim rests on one enumerator run and one ladder run, neither reproduced. A realisability pass would confirm the upper half against an independently built group. It is also a **two-part row with F = 2 fusion and a foreign prime whose twist order is a proper prime power (Q = 11²)**, which is a stratum the battery does not otherwise reach.

**Also worth a row: the exact-value coincidence.** B_solv = B_safe at 916 of 2,186 rows, and on those the fused matching class is doing all the work. A single realisability pass on one of them tests the same construction the S2 identity predicts, so the two checks corroborate rather than repeat each other.

## R10. The chiral-half homology — only the n = 5 Smith form remains

*Script: `chiral_mv.py` (`--verify` runs the regression, `--table N` prints the closed forms). The question — whether any chiral half of the Hamiltonian-cycle complex is **ℤ-acyclic**, the lowest rung at which a counterexample could exist — is answered **no**, at every n ≡ 1 (mod 4); see the session log for the closed forms and the argument.*

**What remains.** Only the n = 5 torsion, and only if one wants the Smith form rather than the answer: the connecting map is ℤ⁶ → ℤ⁶ with cokernel (ℤ/2)², elementary divisors (1,1,1,1,2,2). The regression at n = 5, 6, 7 should be re-run after any change to `chiral_mv.py`; it checks the closed forms against direct 𝔽₂ homology and asserts non-negative Betti numbers, which is what catches the boundary-orientation bug described in the script header.

## §2a. Needs human thought

*Judgement calls, independent scrutiny, or things requiring materials Claude cannot obtain.*

### T1. Independent reading of the structural arguments

*The failure-site taxonomy this item rests on is `verification-lessons.md` §1; do not restate it here.*

**What is owed: a further independent reading**, worth more than another pass by any previous reader. Parts A–J and Part 0 have had a second reading by someone with no prior exposure; it found no error in the steps it examined, confirmed B′'s socle argument, and **every finding it returned was site 3**. A later full-document critical pass returned ~15 findings, all drift or cross-era inconsistency and none a defect in a proof — consistent with the same limit: the passes that have happened check statements against each other, which is not the same as checking a step whose plausibility is doing the work. It did not reach the site-4 defect that sat in the theorem statement, the SAFE cap and `fb_common`'s condition (4) throughout — so a reading running sites 1–3 should be assumed to leave site 4 untouched.

**A machine reading is weakest exactly where the failure mode is "an argument that reads as plausible"**: it verifies constants and recomputes tables freely, and cannot notice a step whose plausibility is doing the work. That is the residual human item.

**Where to look, in order.** Part E's realisability (T2) — reading a construction is not building one, so the read pass could not close it. Part 0's completeness — the worst record, the sole support for μ ≤ B_safe, and the place a missing shape hides. Then Parts D2q and E″, which carry the most intricate case analysis per line.

### T2. Part E's realisability: preconditions are checked, construction is not

The preconditions check is **built and passing**: `validate_table_v3.py` group A asserts per winner row that the Part E build's ingredients exist — F_top a q-power, every foreign block scored above r having q | r − 1. The carrier's order must be coprime to every **foreign prime**; it need not be coprime to any block count, a fused class being carried by an entangled generator whose F_mid-th power is the full twist. *A precondition stricter than the construction requires does not err on the safe side here — it rejects rows the construction realises, and the check's purpose is attainment.*

Part E's construction has been read and found sound as written, with E.3(ii)'s (c, r) = (11, 5) group rebuilt independently returning orbitals {10, 55, 55}. **Reading a construction establishes that it would work if assembled, not that assembling it at the table's actual configurations yields the predicted multiset** — only R8 does that.

**What is owed, and it is what a check cannot reach.**

- **Whether to build groups at all, and how often.** The shapes and the order to run them are R8; the priority follows from the ceiling table, so **S7 at F = 4 needs even-F battery entries** rather than being treated as a curiosity.
- **J0a, the stabiliser assumption** (item 5 of the enumeration-proof gap inventory above)**. Largely discharged: the restriction is without loss at a fixed twist order, by an orbit-counting argument.** The construction takes a matching block's twist inside the field's multiplicative group, whereas the stabiliser of a primitive affine group of degree p^a may be any irreducible subgroup H ≤ GL(a, p). The worry was that some non-field H realises a block orbital the field cannot. It cannot:

  > **At a fixed order t, the field subgroup is optimal.** Any orbit of H on the c − 1 nonzero vectors has size at most |H| = t, by orbit–stabiliser. The multiplicative subgroup of 𝔽_c^× of order t acts **semiregularly** — its orbits are the cosets, every one of size exactly t — so it attains that bound at every vector simultaneously. Hence **no subgroup of GL(a, p) of order t has a larger minimum orbit than the field subgroup of order t**, and the same holds for the ± version that governs pair orbitals, replacing H by ⟨H, −1⟩. Since the block's contribution is decided by its minimum orbit, a construction that reaches for a non-field stabiliser can never beat the field one at the same order.
  >
  > *(Confirmed by exhaustive search over the subgroups of GL(2, p) for p = 3, 5, 7: no subgroup anywhere has minimum orbit exceeding its order. The search is a sanity check on the statement, not evidence for it — the bound is orbit–stabiliser.)*

  **What remains, and it is narrower than the original item.** The argument compares *at a fixed order*, so it discharges attainment but not **primitivity**: the field subgroup of order t is irreducible only when t fails to divide p^b − 1 for every proper b | a, so at a twist order lying inside a subfield the block group built from it is imprimitive, and Lemma B's affine reading needs the Frobenius element of ΓL(1, c) to restore irreducibility. **So the scoped claim to make is:** the twist may be taken inside ΓL(1, c) without loss, and the check owed is that the constructions do reach for Frobenius at subfield-order twists rather than assuming irreducibility. That is a reading of Part E's construction against a stated condition, not an open structural question.

### T3. Independent necessity read of the eight conditions

*Why necessity rather than truth, and why the failure is invisible: `verification-lessons.md` §2.*

Both certificates pass with every Part E′ theorem disabled, so these eight conditions, together with Part 0's shape space and Lemma D2's domination of fused foreign classes, are the whole trusted base for μ(n) = B(n). `fb_common.py` carries a per-condition necessity argument in its header, so **what is owed is scrutiny of those eight arguments, not their reconstruction** — and the value is in the independence, so a second reader beats another pass by the first.

**What a reading of these has to keep straight, and it is one thing.** The certificate's question is whether a share-carrying configuration's **SAFE score** can reach B_safe(n), and SAFE credits a p-characteristic part the flat F·C(c,2). So a condition on such a part is necessary exactly when F·C(c,2) ≥ B implies it. A cap of F·orb(c, dmax) — the twist stripped of the foreign prime — tests a *smaller* number and can reject a configuration whose SAFE score does reach B: anti-permissive, and invisible in the output. The strip bounds a different quantity, what an actual *group* of that shape realises, which yields μ = B_refined rather than B_refined = B_safe, and is itself valid only for a ΓL(1)-type stabiliser. **The conditions therefore use the flat cap and no strip**, which is also why they no longer inherit Lemma C, Corollary C′ or J0a. Measured: with flat caps and `--no-theorems`, the candidate list is empty at every row of the computed table.

**Where to press hardest, in order.** **Condition (7)–(8)'s leftover machinery** is now the least examined part, since it carries the load the strip used to at the L = c shapes — check that the subset-sum reachability really over-approximates (it ignores inter-leftover cross terms and distinctness from p, both permissive, but the reasoning wants a second reader). **Condition (2)'s `'*'` branch**, gated on r ≥ B, fires only at n = 6 in range, so it is untested by the passing run. **Condition (6)** is not independently necessary and is retained as a tripwire; check nothing has come to rely on it.

**No strip site remains as a gate.** `_record_strip_diagnostic` records what the old cap would have decided, and nothing reads it. **Re-check on any edit to the file** that no cap on a p-characteristic part is anything other than F·C(c,2): a strip reintroduced as a gate produces the same (empty) output as a correct run.

### T4. Literature: one high-upside investigation, four smaller owed items, framing deferred

*Untouched by any review pass so far, all of which stayed inside the documents; every item below stands as written. Four passes are written up in `literature-findings.md`, which carries a reference convention — every citation of our own documents is prefixed `` `aod` ``, `` `notes` ``, `` `ep` ``, and a bare § belongs to a cited paper. Two candidate follow-ups — running our CSP against Angel–Borja's surviving types, and chasing the two-orbital criterion computationally — are **deliberately not on the list**: the exhaustive n = 10 and n = 12 batteries already validate the machinery more strongly than either would.*

**Outstanding, and it is the item with the most upside in this file.** Skorobogatov–Sofos (*Inventiones* 231, 2023) prove Schinzel's Hypothesis on average and use it to get a *positive proportion* of varieties with rational points — the move being that one does not need the full conjecture, only that most polynomials satisfying the obvious necessary condition represent at least one prime. **That is structurally `aod` §4**, which needs not an asymptotic at every n but only that for almost every admissible n *some* shape in `aod` §6's finite feasible set is realised. If the averaging works over our shape families, §4's density claim moves from conditional to unconditional, which changes what the paper is. Obstacles to check: the coprimality budget means our family is not a generic family of polynomials, and their result is for linear polynomials in several variables, which fits our two-part shapes better than the fused ones. **Read before `aod` §4 is written, not after.**

**ANSWERED — the fixed-residue exclusion does not bind on us, and the results are worth less than this item assumed.** *(Worked out in `shparlinski-constants.md` §7.5.)* The item asked whether Shparlinski's reason for setting aside BFI/Mikawa/Fouvry — that they restrict the residue classes a in ψ(y,m,a) — is a restriction our formulation already satisfies. **It is**, and for the reason guessed: everything this framework needs is `r ≡ 1 (mod Q)`, the residue fixed at 1, because `Q | r − 1` ⟺ `𝔽_r^×` has a subgroup of order Q ⟺ AGL(1,r) has a twist of order Q. No other residue class corresponds to a group we can build a block out of. Write **EH(1; θ)** for the specialisation.

More precisely, the exclusion is about **Theorem 1**, which builds its residue by CRT (`a ≡ n mod p`, `a ≡ 1 mod q`) so that a varies with n, forcing the sup-over-a form of Bombieri–Vinogradov. **Theorem 2**, the one this framework consumes, never forms such a residue: its inputs are Baker–Harman (purely about the class 1) and Balog–Sárközy (no congruence content at all). Its only congruence-sensitive dependence is EH(1).

**But two findings cut against pursuing them.**

- **Fixing the residue buys nothing at the endpoint.** Friedlander–Granville, *Limitations to the equi-distribution of primes III* (Compositio 81 (1992), 19–32), anticipated exactly the hope in this item — they say outright that there were several reasons to expect the asymptotic might hold for large q with a kept fixed — and refute it: *for any fixed a ≠ 0 and any N > 0, `π(x;q,a) ~ π(x)/φ(q)` cannot hold uniformly for `q ≤ x/(log x)^N`.* So EH(1) fails at the endpoint exactly as EH does. The gain is entirely in the interior (`1/2 → 4/7 → 11/21 → 17/32`), which is real but is a gain in **α**, and `shparlinski-constants.md` §6 shows α buys nothing.
- **Which constrains the shape of any proof of (BCG)/(SP), independently of the density accounting.** Bounded cofactor needs moduli `Q ≍ r/D`, inside Friedlander–Granville's failure window — but the framework never needs a per-modulus asymptotic there (the count of `r ≤ x` in one class mod `Q ≍ r/D` is `O(D)`, bounded, so an asymptotic is meaningless). (SP) is a count **aggregated over Q**, which irregular moduli do not disturb. **So (BCG) and (SP) cannot be derived from a level-of-distribution statement of the usual asymptotic form at level ≈ 1, because that statement is false; they must come from a counting or sieve argument tolerant of irregular moduli.**

*Also recorded there:* Baker–Harman's `α = 0.677` (Li: `0.679`, via Maynard's triple convolution estimates) needs moduli of size `r^{0.677}` and therefore exists only because the residue is fixed — so the α in the ladder of `aod` §3.6 is a reading of how far EH(1; θ) has been pushed, not an independent input.

**ANSWERED — the almost-all step survives a thin set; the obstruction is elsewhere.** *(Read against Shparlinski's Theorem 2 in full, `aod` §6.8(iv) rewritten accordingly. The question as filed presumed the machinery was circle-method and density-hungry; it is neither.)*

Theorem 2's engine is **Balog–Sárközy's sumset theorem**, whose hypothesis on the input sets is a **pure cardinality condition** — #𝒜·#ℬ ≥ cN log²N, giving a difference with a prime factor ≫ (#𝒜#ℬ)^{1/2}/log N. Shparlinski plays the exceptional set against the input set and reads off #ℰ ≪ x^{2γ}log²x/#ℛ. Three consequences, each correcting something this item or `aod` §6.8 previously asserted:

- **Thinness costs one logarithm, not the argument.** Baker–Harman input (#ℛ ≫ x/log x) gives x^{2γ−1}log³x; an S_D-type input at relative density 1/log x gives **x^{2γ−1}log⁴x** — still o(x) for every γ < 1. "One logarithm short of what the machinery consumes" was wrong: a cardinality hypothesis divides straight through.
- **No equidistribution clause is needed.** The "consumes distribution in arithmetic progressions, major arcs built from it" reading describes a **circle-method** route, not this one. Balog–Sárközy is sieve-based. The former item's instruction to determine "what equidistribution clause a sufficient version of (SP) would need" is answerable as: none, for this route.
- **What blocks the floor is the companion exponent, at every input density.** The certified prime factor is capped by (#ℰ#ℛ)^{1/2}/log x ≤ x/(2√2 log x), sub-linear — so γ = 1 is unreachable even with a full-density input. A floor needs min{p²k, pkr, qr} ≥ δ₀n², forcing p ≥ δ₀n at k ≤ 1/δ₀: the **companion** n − r must carry a linear prime factor at bounded cofactor, the α = 1 endpoint again on the other side.

**Demonstration worth keeping:** run Theorem 2 with ℛ = S_D itself. Then qr ≫ n²/D reaches Ω(n²) on the r-side and the min is still pinned at p²k ≈ n^{1+γ} by the companion — feeding in the endpoint hypothesis buys nothing, which localises all of (BCG-AL)'s difficulty in the companion clause rather than in S_D's thinness.

**The positive result this yields**, now stated in `aod` §6.8(iv): **(SP_{D,c,ρ}) at any ρ ≍ 1/log^C x implies f(n) ≫ n^{2−ε} for almost all n**, every ε > 0, exceptional set O(x^{1−2ε}log^{C+3}x) — the ladder's limiting exponent from the bounded-cofactor hypothesis alone, no Baker–Harman needed. Not Ω(n²); the gap is exactly the companion endpoint.

**Where a density obstruction does live.** To certify a *linear* prime factor the available tool is **Sárközy–Stewart's** dense-sumset theorem (Shparlinski's own remark after Lemma 7), which wants **positive density in the integers on both sets**. S_D at ≈ 1/log²x is two logarithms short of that. So the honest accounting is: sub-endpoint, density is free; at the endpoint, the known tool wants positive density and S_D is two logs short — not one log short of a circle-method requirement.

**Worked through with explicit constants in `shparlinski-constants.md`** (standalone, less audited), which carries the c₀ chase, the two-branch bound with its constants, the sub-linear cap, and the quantitative threshold: the machinery reaches `p ≫ n/(log n)^{3/2}` at a constant-density input and `p ≫ n/(log n)²` at ours, against the `p ≥ δ₀n` a floor needs. **So thinness costs `(log n)^{1/2}` and the endpoint costs `(log n)²`.**

**Still open from this reading:** Balog–Sárközy's own proof internals were not re-derived (the *statement* consumed by Theorem 2 was confirmed to have a pure-cardinality hypothesis, which settles the equidistribution question at the level it is used); and whether any endpoint-capable sumset result tolerates a 1/log²x set is the live successor question — which, with Sárközy–Stewart's hypothesis now confirmed, is the **only** remaining route on this side and is a genuine literature search rather than a citation check. **Sárközy–Stewart's hypothesis: CHECKED, and Shparlinski's characterisation stands.** Two independent secondary restatements give it as **positive relative density** — `#A, #B ≥ c₁N` yields some `a + b` with `P(a + b) ≥ c₂N`, `c₂` depending only on `c₁` (Mérai, arXiv:2112.03607 §1, and Stewart's framing of the multiplicative analogue). The series does treat sets that are merely "not too small", but those give correspondingly weaker bounds on `P(a + b)` rather than the linear one the endpoint needs. **So the endpoint accounting is unchanged and this item closes negatively** — the outcome that leaves the two-logarithm gap standing rather than the one that would have narrowed it. What remains is small: the original was not read, so a variant elsewhere in the series (I–V) pairing a weaker density with a linear conclusion is not formally excluded. *(`shparlinski-constants.md` §9 records the same, and this was that document's own highest-value open item.)* *Note also the strategic consequence:* the fixed-residue item above attacks the **input** side, which this reading shows is not where the difficulty is, so it should probably rank below the sumset question rather than beside it.

*Sizing, now that the above is settled.* Bounded cofactor needs level → 1, which is not merely unreached but **false** in asymptotic form; 4/7 does not approach it and nothing in this family would give the bounded-D statement. The realistic prize is the **almost-all exponents** of §3.6's ladder, where a fixed-a improvement over BV could raise a rung — a gain in α, which `shparlinski-constants.md` §6 shows does not propagate to the floor. Two obstacles remain if anyone does pursue it: whether the well-factorable or smooth-modulus conditions those results carry are compatible with Q ranging over prime powers, and whether their averaging reaches Q ≈ r/D at all.

> *Where this came from, since the framing is the useful part.* Proposition F.4's condition — r − 1 = dQ with d ≤ D and Q a prime power — is to Sophie Germain what bounded prime gaps are to twin primes, with the ladder's θ → 1 corresponding to letting D grow like r^ε. That analogy invites the hope that a Zhang/Maynard-style result could give bounded D without the full ladder. **It cannot, and the reason is worth recording so the hope is not re-entertained.** GPY/Maynard proves that at least 2 of k linear forms are prime without specifying *which*, and for bounded gaps that is harmless because the forms n + h_i are interchangeable — any two give a gap. Here the two primes are asymmetric: one must divide the other minus one. Sieving {n, 2n+1, …, Dn+1} and being handed 3n + 1 and 5n + 1 with n composite yields nothing, because the large prime-power divisor of r − 1 has to come from n itself. A prime at a **designated** form is the twin-prime barrier itself, which those methods route around rather than break. What survives the analogy is not the method but the residue observation above.
>
> *A quantitative consequence of the same framing.* The primes with bounded cofactor have density ≈ C·log D/log x among primes — measured at D = 12 as 0.343, 0.235, 0.182 over x = 10⁴, 10⁵, 10⁶, tracking log 12/log x. So the set is twin-prime-thin, no positive-proportion statement about it can be true, and (BCG) is a Goldbach condition **over a set that thin** — which is the quantitative form of the "independently twin-prime-hard" remark in `aod` §3.5.

**One comparison replaces a reading task.** `literature-findings.md` items 4 and 17 identify Black's spacing framework (ITCS 2015 / ACM ToCT 2019) as containing the sub-board Fourier-degree route, p-group hypothesis included. What is left is not to read it but to ask a specific question: **does our group data give better spacing at composite non-prime-power n than the sequences already in the literature?** His target is Ω(n) asymptotically; ours is constants near C(n,2) at specific n, which his framework does not chase. The two feed the same machinery with different objectives, so the comparison is concrete — compute spacing for the orbit augmentation sequences our batteries supply.

> **Note the optimisation runs opposite to the battery selection.** That route wants many *small* orbitals; the max-m\* search wants the reverse and discards exactly the useful groups. Same inversion as the two-orbital criterion.

**Four primary-source checks owed before publication.** Three are flagged in `aod` §3.6: the θ = 1/4 rung is attributed to Bombieri–Vinogradov on Shparlinski's framing rather than from the original; the Chowla row names a conjecture-type rather than a specific paper; and the two Elliott–Halberstam rungs are quoted in the form n^{3/2−ε} and n^{2−ε} by inference from how E–H is quantified, since Shparlinski's §5 states those improvements without writing an exponent — confirm against the published version, and if a bare n^{3/2} is claimed there, recover the reasoning. The fourth sits in `aod` §5 and the `notes` reference list rather than §3.6: **the Ω(n²/3) bound is attributed by at least one survey to unpublished work of Santha–Yao rather than to Scheidweiler–Triesch**, whom we cite alone. Citing one of two is a priority claim we have not checked.

**The step we are missing, and it is elementary.** Jones–Zvonkin is a *programme* — at least five papers applying Bateman–Horn to dessins, permutation groups, block designs and simple-group orders, with a stable recipe (`literature-findings.md` item 20). Their step (ii) is an explicit, elementary verification of Bunyakovsky's conditions for each polynomial. **`aod` §3.5 asserts an ample supply without doing the analogue** — checking, per shape family, that the relevant system satisfies Schinzel's conditions and has no fixed prime divisor. That is a page of work per family and it interacts with the polynomial-versus-exponential line below: a shape with unbounded exponent has no polynomial to check, which is itself the finding.

**Deferred: the framing decision.** Jones–Zvonkin's programme (arXiv:2106.00346 and four companions) is the model for how this genre states its standing — conditional on Bateman–Horn, labelled as such in the abstract, with the conjecture validated numerically at the range used. Three consequences are recorded in `literature-findings.md` items 14–16 and are *not* being acted on yet: a standing table at the front of `aod` §3 dividing unconditional from conditional from conjectural; the polynomial-versus-exponential line in `aod` §3.5, since shapes needing prime powers of unbounded exponent are Mersenne-like and outside Bateman–Horn; and the Catalan/Pillai caution where both parts are proper prime powers, which is our S1 and S2 and which `aod` §6 currently treats as amply supplied.

### T5. Condition (4)'s strip, and the residue that blocks B_refined = B_safe

*Mathematics in `enumeration-proof.md` Part D (Lemma C's coupling, Corollary C′); gate implemented at all three strip sites in `fb_common.py`.*

**The licence**, which is local to (p, a, r) and involves no n, density floor or table threshold:

> **sharing_bound(p, a, r) = min(r·ord_r(p), C(r,2))**, and the strip is sound iff this is **< B**.

At a = 1 the coupling forces ord_r(p) = 1, so the bound is r and the licence reads r < B. The strip acts only when r | p^a − 1.

**Measured on the completed table, and the expected picture holds.** Instrumenting every strip decision the certificate reaches (`set_strip_trace()` records (p, a, r, B, bound, licensed)) under `--no-theorems`, so that no branch is dispatched away before the strip sees it: **42 decisions over all 2,187 rows, 42 licensed, 0 at a > 1**, and no verdict differs from an ungated run. `orb(r, t) < B` does kill every proper-prime-power branch before condition (4) reaches it, which is why the a ≥ 2 case never arises. **Still do not quote a decision count without measuring it on the run in hand** — it is a property of the frontier and of the file's current form, and a single licensed strip at a ≥ 2 would put J0a back into the collapse's trusted base.

**A second thing J0a touches here, which the header does not name.** Condition (4) caps a fallback part at F·orb(c, dmax) rather than F·C(c,2). For that to be *necessary*, orb(c, d) must bound the block's minimum intra-orbital once the share is dropped — true for a ΓL(1)-type stabiliser and **false in general at a ≥ 2**, by Part B's own 3^{1+2} ≤ GL(3,7) example, where the realised minimum exceeds orb(c, d) by a factor 9. So the a ≥ 2 exposure of condition (4) is Corollary C′'s Frobenius step *and* the orb formula itself; at a = 1 neither bites, GL(1, r) being cyclic. Same scope, same empirical discharge (0 strips at a ≥ 2), but the sentence describing what J0a reaches should say both.

**What remains open.** The fallback residue is Part E″'s **q = 2 and large-e** cases, where pinning is vacuous or weak and domination rather than supply is needed. That is the obstacle to replacing B_safe by B_refined outright.

| piece | status |
|---|---|
| e = 1, δ > 1/9 | **closed unconditionally** — Proposition F.1 at k = 3 |
| e = 1, δ ≤ 1/9 | **reduced to a bounded search**: ≤ 2/δ pinned positions per n; empty over the table (4 admissible of 24,322). Not a theorem |
| e ≥ 2 | supply density zero in n; enumerable at the sparse n where it exists |
| q = 2 | pinning vacuous, family exponential; needs domination |
| p-characteristic half of the leftover | **closed at every a** — Lemma C's coupling and Corollary C′, gated locally |

*Counting alone does not close e = 1 below 1/9, and the pinned bound n ≥ 3.54√B gives only δ ≤ 0.16, weaker than F.1's 1/9.* Part E″'s pinning is conditional on a floor δ ≥ δ₀, so the unconditional version of this route dies with the asymptotic floor.

**Tripwire.** `validate_table_v3.py` asserts per row that no winner has a proper prime power c with a foreign prime dividing c − 1 — currently 0 of 2,202 p-characteristic winner parts. It flags the first n where Corollary C′ would have to be checked directly.

### T6. The residual conditionality in §3.3.5's ceilings

Both coordinates of the joint optimum are settled without a search. The **F side** closes on cap_F(1) = 1/(1 + √F)² together with η ≤ 1, which bounds each F-slice with no arithmetic input and excludes F ≥ 8; the parity constraint at odd n leaves F ∈ {2, 4, 6}. The **η side** is derived from congruences in §3.3.4a — a 2-adic factor 2^(1−v) with v fixed by r mod 8, and a 3-adic cut by 3 when 3 | r − 1 is forced — and `eta_derive.py` checks that derivation against an independent measurement at every (class, F) cell. *Gotcha the F side invites: cap₄(1) = 1/9 bounds the F = 4 slice and is not any class's ceiling, since a class that could take F = 4 at full efficiency reaches 1/8 through F = 2 at η = 1/2 instead.*

**What is left is one hypothesis and three scope limits.**

- **Supply, which is the same hypothesis as everywhere in §3.** The congruences say a suitable r is unobstructed; that primes of the form r = 2^v·q^e + 1 actually occur near the balance point in the density §3.4 needs is Bateman–Horn. Nothing in §3.3.4a improves on that, and it is why the ceilings are family guarantees rather than theorems about δ.
- **Only F ≤ 6 is derived.** §2.1's bound makes that sufficient for the conclusion, but the congruence bookkeeping itself has been done for F ∈ {2, 4, 6} only.
- **Mixed three-part shapes** — 4c + 2c′ + r and the like — lie outside both the two-part family and the three-part ladder, and no ceiling here bounds them.
- **Class 11's entry rests on 676 > 675 — and the comparison now has a second, independent derivation.** The margin is 7 − 4√3 > (2 − √3)/4, i.e. 26 > 15√3, the narrowest possible integer margin, and anything upstream that moves it flips the class. **What has changed is that both sides of it are now reproduced by a route with no access to the shape space.** `sp-to-floor.md`'s circle-method optimisation selects (k, d) per residue class from congruence conditions on r − 1, and at class 11 it returns **(4,6) → 7 − 4√3 = 0.071797** as the optimum with **(6,4) and (2,12) → 0.066987 = (2 − √3)/4** as the runners-up — the same winner, the same runner-up, the same margin, derived from arithmetic rather than from an enumeration of rungs (`aod` §6.9(b)). So the residual exposure at this bullet is **no longer that the argmax is misidentified**; a shape-space error large enough to flip class 11 would have to be mirrored by an unrelated error in the congruence analysis that happens to land on the same two constants.
  - *One thing the second derivation adds rather than confirms:* under it the optimum at class 11 is **unique**, not a tied pair. The framework's own objective is symmetric enough that (4,6) and its transpose look interchangeable; the analytic objective is not symmetric — its foreign term carries √(d/2) — and the transpose falls to 0.0670. A strict optimum at a 0.0718 : 0.0670 margin is a sturdier object than a tie, and it is worth checking whether the framework's side should be stated the same way.
  - *The runner-up is a **tie**, and that is now measured too.* `ceiling_rederive.py --runners` takes the sup per fusion count and per mod-24 half: both halves reach (2 − √3)/4 at **F = 2, η = 1/6** and again at **F = 6, η = 1/2**, all four values within 2·10⁻⁵. So the older reading — F = 2 in the half n ≡ 11 (mod 24), F = 6 in the half n ≡ 23 — was a mod-24-era artefact, and an argument needing the runner-up needs the tie. This matters to T5a, whose live question is precisely the runner-up ordering.
  - *(Every closed-form constant in §3.3.5 and the cap_F(η) = cap₁(Fη)/F identity independently re-verified. The exposure that remains here is the supply hypothesis and the margin, not the arithmetic and not the argmax.)*

*The ceiling table's independent re-derivation is `ceiling_rederive.py` (R6-adjacent); the working is recorded in the session log.*

### T8. Proposition F.4 (the converse) — two readings; one step carries the whole statement

*Given a second, independent reading: both branch derivations re-derived from scratch, the census walk re-checked, the three smaller steps resolved (below), and one defect found and fixed (§6.8(ii)'s window endpoint). What remains single-sourced is Lemma B′ itself, which is T1's item, not this one. The measurements still are not independent evidence of the derivation — they test the inequalities, which the table's winners satisfy whatever the proof says.*

**The step everything rests on, and its support is better than first recorded: why must the foreign twist Q be a prime power?** Branch (b) is vacuous without it — Q = r − 1 always satisfies a cofactor bound. The confinement is **Lemma B′'s content, not an unstated assumption**: AGL(1,r) is nonabelian, so a foreign block's translations must occupy the abelian cyclic layer and its twist is forced into the top q-group. So the question is not "is this assumed?" but "is B′ right?", which is T1's standing item — B′ being the one structural lemma whose failure would break B_safe itself. That is a much better position than an unexamined layer claim, but **layer-assignment claims remain the category with the worst record here** (the F_mid coprimality clause, the c mod 8 fusion mechanism), so the reliance is worth keeping visible.

**The asymmetry that this creates was got wrong once and is the thing to re-check on any restatement.** A *matching* class's twist is **any divisor of c − 1**, carried by the cyclic layer, and may be the full c − 1 — cofactor 1, not a prime power. So the all-matching branch yields **no arithmetic statement whatever**, and F.4's multiplicative case must be a genuine **alternative** rather than a weakened form of the same conclusion. An earlier draft had it qualifying only the primality of the witness, leaving the divisor conclusion apparently unconditional; that was wrong, and it is the natural error to repeat, since the two branches look parallel until one asks which layer supplies each twist.

**The shape audit is done and closed one gap; record it so it is not redone.** Walking S1–S10 against the branch split: S3, S4, S5, S6, S7 and **S9** carry a foreign part and land in (b); S8 and S10 are killed so nothing exists to quantify over; S1 and S2 land in (a). **S9 (fused outside class) is the gap it found** — the first draft bounded a foreign part's contribution by r·Q with r ≤ n, which is the unfused case; a fused foreign class contributes F·r·Q and needs the **joint** bound F·r ≤ n, the same care the matching branch already required. Stated in the proof now. *Note this is the second time the joint-versus-separate bound has been the defect* (the other produced the spurious 2/δ₀²), which makes it the thing to check first on any restatement. Also recorded there: branch (a) is **wider than S1 ∪ S2**, since multi-class all-matching shapes such as n = 640 = 1·256 + 3·128 are not named in the census but land in (a) correctly — the proof splits on presence of a foreign part rather than on the census, and a shape-by-shape proof would have missed them.

**The extracted hypothesis (SP) is new with the same standing.** `aod` §6.8 states the n-free multiplicative half as **(SP_{D,c,ρ}): |S_D ∩ [cx, x]| ≥ ρ(x)·π(x)** — the window built into the definition rather than derived, because a cumulative *lower* bound does not yield a window count (that needs a lower bound at x and an upper bound at cx, the PNT-to-Bertrand relationship), and because a cumulative *asymptotic* would pin ρ to one function and stop the statement being a family. In window form ρ is a genuine lower bound and all three parameters are monotone. Bounded multiplicative gaps are the weakest case, ρ = 1/π(x), and are what a floor implies for free. The section asserts two things about the hypothesis that want checking independently: that a floor implies it (the gap half being a short argument from branch (b) plus branch (a)'s density-zero exceptional set not filling an interval), and that it does **not** imply a floor, the additive clause of (b) being inexpressible n-freely. The second is stated more carefully: a purely multiplicative hypothesis *can* reach the additive clause, via the exceptional-set machinery of Shparlinski's Theorem 2. What blocks it is **not** the thinness of S_D — that machinery's hypothesis is a pure cardinality condition, so relative density ≈ C·log D/log x costs one logarithm and divides straight through (T4 above, `aod` §6.8(iv)). What blocks it is the **companion** exponent, sub-linear at every input density, so the route yields n^{2−ε} for almost all n and not Ω(n²). Density does have an appetite at the *endpoint* tool, Sárközy–Stewart, where S_D at ≈ 1/log²x is two logarithms short. So the honest status is *open*, not impossible, and the concrete question is filed as a T4 literature item. *Measured for context:* the largest multiplicative gap below 2·10⁶ is 1.041 at D = 12 and 1.165 at D = 2, counting from r > 10³, and shrinking with the cutoff — so (SP) at the constants a 1/25 floor needs is enormously weaker than the data suggests, and its difficulty is entirely that bounded D is the Sophie Germain endpoint.

**The three smaller steps are now resolved** *(second reading, independent of the pass that wrote them).*

- **"Every part clears δ₀·C(n,2) on its own." RESOLVED, with one proviso now stated in the proof.** The direction is safe as used, and no part *kind* escapes: any class with an intra pair has an intra orbital bounded by F·c·d/2. The exception is a part of support **s_i = 1**, which has no intra orbital at all, so the sentence is literally about s_i ≥ 2; such a part needs no branch, since its cross orbitals have size ≤ n and fail the floor outright at large n. `ep` F.4 now carries the proviso.
- **The shared chain prime. RESOLVED structurally rather than by citation**, and the reason is now in the proof — **in two branches, which the one-line form of it conflates.** Fix the chain first (G.0's discipline, which F.4 follows). A block class of size s^k with k ≥ 2 and s ≠ p has non-cyclic elementary-abelian translations needing a home. At **s ∉ {p, q}** there is none: s-elements map into the cyclic layer, so Sylow-s is cyclic. At **s = q** the top layer *is* such a home, so that argument fails and the branch runs through **Lemma B′ Case 2** instead — a primitive transitive q-group is regular of prime degree. So no such class exists; a block class at a second prime must have k = 1, which is the foreign case and exits to (b). The dichotomy is exhaustive **per chain**, and since only *some* chain is needed, a group admitting several costs nothing. Two matching classes at different primes cannot arise, so the density-zero exceptional set is safe.
- **The constants. RE-DERIVED from scratch and correct** — both branches, the round trip, the floor-dependent D(δ₀), the slack factors, and n(n−1) carried consistently. **One earlier entry here was itself wrong and is now corrected.** It claimed the smallest intra orbital of a foreign class is at most F·r·Q/**2** rather than F·r·Q, so that the derivation was discarding a factor 2 in the safe direction. That is false at **odd Q**, where `−1 ∉ C_Q` and the orbital is exactly `r·Q` — verified by orbit enumeration at (13,3), (31,5), (11,5) giving 39, 155, 55, against the halved values 26, 31, 164 at the even-Q pairs (13,4), (31,2), (41,8). `shparlinski-constants.md` §1.5 draws the correct and opposite conclusion: **F.4's F·r·Q is tight at odd Q and the factor 2 is not recoverable there**; the halving occurs only at Q = 2, which `aod` §6.8's parity remark makes the rare case. F.4's derivation is sound either way, since F·r·Q bounds the orbital above in both parities — what was wrong was the belief that slack was hiding here. *(The same error, made independently, cost `sp-to-floor.md`'s Reduction Lemma a factor 2 in its headline constant; the correct argument was already written in `note-to-framework-bridge.md` §5 and propagated to neither.)* The residual watch-list: the orb halving at even twist, and C(n,2) versus n²/2 — *the second of which has already produced one slip, a draft asserting δ₀·C(n,2) > δ₀n²/2, which is backwards since C(n,2) < n²/2; the statement now carries n(n−1) throughout.* Nothing structural turns on it, but `aod` §6.7 quotes 700 as the round-trip figure and it inherits any slip. *One such loss has already been found and removed* — the all-matching branch was first derived at 2/δ₀² by bounding F ≤ 1/δ₀ and c ≤ n separately, when F·c is bounded by n jointly; keeping the product together gives 2/δ₀ on both branches. Checked over ~4·10⁵ random configurations, 0 violations, tightest ratio 0.5. **Both branches now carry the same constant, so a future slip that makes them differ is itself a signal.**

**One finding from the second reading: §6.8(ii)'s window constant sat at a degenerate boundary.** The claim was that a floor gives (SP) with **c = δ₀/2 exactly**, argued by "if some window held none, every n in its upper part would fail (b)." But an n fails only if its whole r-range [δ₀(n−1)/2, n] lies inside the empty window [δ₀x/2, x], which needs n ≤ x *and* n ≥ x + 1 — no such n exists, so at the endpoint the emptiness implies nothing and the claim was unproved at its own constant. For any **c < δ₀/2** the failing n fill [2cx/δ₀, x], a positive proportion, and branch (a)'s O(x/log x) integers cannot cover it. Fixed in `aod` §6.8(ii) and in `ep` F.4's gaps aside (Λ > 2/δ₀ strictly). **This is the class of defect T8 exists to catch** — an endpoint where a constant is quoted exactly and the argument needs one side open — and it is the third such in this framework after the F.1/E′ offset and the D2′ closed-form tie.

**The cofactor constant sharpens, and the sharpening is inside F.1's existing machinery.** Bounding r ≤ n gives (r − 1)/Q ≤ 2/δ₀; dividing the same inequality by Q instead makes the cofactor depend on r's *share* of n, and a configuration carrying a foreign part carries a second part of support > √(δ₀n(n−1)), so r ≤ n − √(δ₀n(n−1)) and **(r − 1)/Q ≤ D(δ₀) = 2(1 − √δ₀)²/δ₀**. That is a strict improvement at every δ₀ — 25.4 against 42 at the table floor, 32 against 50 at the conjectured 1/25, 14.9 against 28 at the asymptotic ceiling — and it costs nothing new. Both forms hold with zero violations across the table; `converse_check.py` reports each separately so a document still quoting the crude one can be checked against the run rather than silently disagreeing with it. **The residual sharpening question is correspondingly smaller: ~2.1 against the measured 12, not ~3.5.**

**Rerunnable as `converse_check.py`** (`--delta0` to test one global floor rather than each row's own density, `--frontier` to pin the contiguous cut, `--all-rows` to include the worklist), and **in R1's command list**, because these checks read the **witness column** and the rebuild rewrites witnesses — composite-F fusions change which rows are one-part, and raised rows change δ. **Requoted from the completed table.** Over [6, 2600]: **0 violations** across all three inequalities, at **1,443** foreign primes and **743** one-part winners (v4: 1,409 and 777). Max cofactor **12**, at the same witness as ever — n = 221, r = 157, Q = 13 — and now with a second attainer at **n = 2759** (r = 1453, Q = 121), which is the range minimiser, so the constant that F.4 records is realised both at the smallest witness and at the hardest n. Slack: D(floor) = 25.4 against 12 used, loose by a factor **2.1** (the crude 2/floor = 42 gives 3.5). *Slack moves with the floor rather than with any finding, so it is not a result; the invariant figures are the zero violations and the 12.* Negative control: `--delta0 0.35` gives 796 violations and exit 1. The frontier is detected as the first gap wider than 10, reproducing the documented 2,186 rows; a looser threshold silently swallows worklist rows, which is how the detection was found to be wrong.

**What the measurements do and do not support.** All three inequalities hold at every contiguous row with zero violations, and two independent constraints bind simultaneously at n = 2594 — genuine corroboration that the bounds are tight rather than merely true. But the measurements test the *inequalities*, not the *derivation*: a wrong constant or an unjustified layer assignment would produce inequalities that still hold on the table, since the table's winners satisfy the true statement whatever the proof says. **The measured maximum cofactor of 12 is the strongest single datum here** — it matches (BCG)'s own constant from the opposite direction — and it is also the reason to suspect F.4's D(δ₀) = 25.4 is loose by ~2.1, which is the sharpening question the gap inventory records.

### T5a. The runner-up ordering inside the three-part family

**The 1 : 1 : 2 prediction is refuted, not open.** `three-part-family-split.md` §1.2 predicts odd-n win shares of 1 : 1 : 2 among S4 (unfused), S5 (top-layer fused) and S7 at F = 2 (cyclic-layer fused); that document is archived and the prediction does not survive the corrected shape space. The whole three-way competition rested on the **c mod 8 law** — S4 winning at c ≡ 1, a tie at c ≡ 5, the fused rung at c ≡ 3, 7 — and the entangled-generator correction removes its mechanism: a cyclic-layer fusion does not cut the twist, so the fused rung scores 2·C(c,2) against the unfused C(c,2) **at every c** with no congruence in play. S4 is dominated everywhere, and S5's only remaining advantage over S7 was a twist cut neither now pays, leaving S7 ahead on its free choice of top prime. So the asymptotic split is not 1 : 1 : 2; **S7 takes the family**, and the shares of the other two tend to zero. `enumeration-proof.md`'s S4 census row and `aod` §3.2.5 both already say this.

**What is genuinely still open, and it is what `aod` §7 needs.** The disjunction-collapse argument wants the **gap to the next shape down**, so the live question is the *runner-up* ordering, not the winner:

> **At each odd residue class, is S5 or S4 second — and by how much?**

Two specific things a human pass should settle, in this order:

1. **Where Lemma C's coupling bites.** S7's advantage over S5 is its free top prime; the coupling (`enumeration-proof.md` Part D) is what can take that away, by stripping S7's layer where the matching twist shares a prime with the foreign block. Wherever it bites, S5 is second; elsewhere S4 is. **This is a congruence condition, not an extreme-value argument**, which is why it is tractable: the fragility of the discarded 1 : 1 : 2 route lay entirely in its extreme-value step.
2. **Whether the gap is bounded below by a constant.** §7 needs a gap, not an ordering. The candidates are cap-level quantities at each class, so this is arithmetic on the §3.3.5 table plus the coupling's density, and it should not need a search.

**What not to reuse.** The archived note's tables are keyed **mod 24**, predate the entangled correction, and quote 0.050510 at class 11 as a *within-family* cap at η = 1/6 — which is not the class ceiling, that being 7 − 4√3 from the two-part F = 4 shape outside this family. Take the question from here and the constants from `aod` §3.3.5.

### T7. The k = 3 κ parameters

*The F = 4 transfer is settled as a derivation and the tables are in `three-uniform-note.md` §5.7; this entry records only what is still open.*

**Open:** whether κ_c and κ_r can be steered independently of the congruences fixing F and η. The tables hold κ_r = 1 throughout and treat κ_c as a free parameter with two values; if the κ's are coupled to n the way η is, the κ_c = 3 column is not reachable at every residue and the class-11 F = 2 / F = 4 tie may be unrealisable. **No risk to k = 2.**

**What the transfer rests on**, unchanged from k = 2: the ceilings are family guarantees, and that primes of the required form occur near the balance point in the needed density is Bateman–Horn. Two narrower gaps also persist from k = 2 — only F ≤ 6 has been worked, and mixed three-part shapes lie outside both families.

## §2b. Self-contained items

*Analysis against the existing files, needing no new materials.*

### A20. The density check must compare in exact arithmetic

*A standing constraint on `validate_table_v3.py`'s group-A density test. Why a float tolerance fails here: `verification-lessons.md` §2.*

A stored decimal density with k places is a correct rounding of μ/C(n,2) iff |stored − B/C| ≤ ½·10⁻ᵏ, evaluated in **exact rational arithmetic**, with k **read off the string**:

```python
def density_ok(r):
    s = r.delta_str
    places = len(s.split(".")[1]) if "." in s else 0
    return abs(Fraction(s) - Fraction(r.B, r.C)) * 2 * 10 ** places <= 1
```

Needs `Fraction` imported and the raw string kept on the `Row` as `delta_str` — `float(d["density"])` discards exactly what the check needs. Worked boundary instance: 250978/3278080 = 49/640 = 0.0765625 exactly at n = 2561, where the float difference is 5.000000000005e-07.

**What the test must still reject**, and what any change to it is re-checked against: one-in-the-last-place errors in *either* direction, truncation rather than rounding, and wholly wrong values — while accepting a tie rounded either way and strings at 4, 6 or 8 decimals at their own precision. Eleven such cases plus the full table are the standing behavioural check.

**Open decision.** Group A's banner says a FAIL there means the run or parser is broken. That holds for its other four tests, not this one — it checks a presentation column no other check reads. Either move it to group B or amend the message.

### A20a. A bound may not be quoted as a rounded decimal

*Companion constraint to A20, and the same root cause seen from the other side: rounding is symmetric and a bound is not.*

The range minimum is **175813/3804661 = 0.04620989885…**, so the natural 5-place rounding **0.04621 lies above the true value** and "δ ≥ 0.04621" is false at the one n that attains it. Every quotation of a floor as a lower bound must use the exact rational, or truncate toward the bound; 0.04621 is fine as a *label* for the minimum and wrong after a `≥`. Fixed across five documents; the standing rule is in `verification-lessons.md` §5.

**The same applies one level up, to any rounded scan output.** `ladder_verify.py` prints five places, so the file alone supports only "≥ printed − 5·10⁻⁶" at each entry. That is enough here — the next-lowest entry is 0.04801, hence at worst 0.048005, clear of the minimum by 0.0017 — but it is a margin to check, not a formality: had the two lowest entries been within 10⁻⁵ of each other, the printed file could not have established which was the minimiser. **On any ladder rerun whose two lowest values are close, print more digits before drawing a uniqueness conclusion.**

### A21. A fusion-aware penalty for the partition-factor table

*The table itself now lives in `shape-counting.md` §4; this is the live remainder.*

The all-shapes **penalised** column (`shape-counting.md` §4) is a **lower bound**, not an exact count. Its penalty `x ≥ √(δ₀F)·(1 + 1/p)` comes from the density ceiling, which prices the smaller class at C(c′,2) — the *unfused* reading — so it is too harsh on a shape whose smaller class is fused, by exactly the factor fusion supplies. `n = 640 = 1·256 + 3·128` is the witness: penalised cost 4.10 against L = 3, rejected, yet a real configuration at δ = 0.1192.

**What to do:** derive the penalty for the fused reading (the smaller class is worth F′·C(c′,2), so the requirement should scale with √F′ rather than being charged per size-group), and recount the three all-shapes entries. Expect them to rise, staying between the current penalised figures and the unpenalised 34 / 115 / 357.

**Priority: low.** The top row is unaffected — a fused unequal shape needs n to be a sum of two distinct p-power multiples, a density-zero condition that puts it among §6.5's escapes rather than in the covering accounting — and §6.6's covering statement quotes N_add, which is counted directly and never uses this table. So the exposure is to a commentary figure, and `shape-counting.md` §4 states the direction of the error.

### A22. `validate_table_v3.py`'s group-A expectation is scoped to the current table

*Not owed work — retained because it is the reference point that makes a baseline run readable, and the 289-vs-18 pairing is asked about repeatedly.*

The R1 reference point reads *0 FAIL*, which holds for an enumerator output under the current scoring. Run against a **baseline** it does not: a row whose recorded winner is a cyclic-fused class scored under the superseded cut twist re-derives *higher* from its own witness, so group A's re-derivation check fires. On the v4 baseline that is **18 rows of 2,186** — a subset of the 289 known-low rows, the other ~271 being exceeded by a different configuration rather than by a rescoring of their own witness, and so invisible to a check that re-derives from the recorded witness. **Neither number is a defect**; the pairing of them is the thing to state, since 289 and 18 look like they should match and do not. Either scope the expectation in R1's banner or have the check name the baseline case when `--baseline` is supplied.

### A23. `sp-to-floor.md` §7's end-to-end run needs rerunning at the corrected orbital

The run scored foreign intra orbitals at `rQ/2` where every `d` in its grid is even and `Q` is therefore an **odd** prime, so the true orbital is `rQ` (§2, corrected). Both sides of its comparison moved together, so the structural conclusion — zero exceptional n among 400,000 consecutive values, realized δ within a predictable margin of ideal — survives; the numbers do not. **Expected on rerun:** class 11 realizing ≈ 0.066 against the ideal 0.0718, in place of 0.04655 against 0.05051. The §3 grid search wants the same treatment. Tagged ⟦PENDING-RERUN⟧ in the note; not fabricated here.

### A23a. `check_doc_figures.py` — the tail row changed what "current" means

*Both fixes are made; this records the reasoning, since the next tail row will raise it again.*

Adding n = 2759 above the contiguous frontier made the pass report 22 extra findings. **They were correct, not artefacts** — the documents' "the table floor is 0.048039" had silently become a *contiguous-range* figure quoted as the table's. Two changes followed:

1. **Both floors are current figures.** The contiguous floor and the file floor answer different questions and a document may legitimately quote either; keeping only one made the other read as stale. `CUR` now carries both, and which one a sentence means is a prose matter no pass can check.
2. **Extremal quantities come from the whole file, distributional ones from the prefix.** A worklist row above CONTIG is computed *because* it may be a new minimum, so "the floor is X at n = Y" should quote the file while "the median is Z" should quote the prefix. The staleness test previously treated NMAX as stale for everything, which flagged the floor — a correct figure — as a defect on every run once a tail row existed.

**The general lesson**, since this will recur: a checker's notion of "the current table" is a *population choice*, and a file that is a contiguous prefix plus a biased tail has two populations, not one. Any quantity added to `quantities()` needs classifying as extremal or distributional at the time it is added.

### A24. Is the shape space complete?

*Now load-bearing for a second claim, and that is new.* Until n = 2759, completeness carried only the μ ≤ B direction of the certified range. It now also carries the framework's **one exact value of μ**: the pinch at 2759 gives μ = 175813/3804661 *granting* μ ≤ B_safe, and a missing shape would make B too small there, so the true μ(2759) would be larger and both the minimum and its uniqueness would move. The failure runs the safe way — the floor would be an understatement, never an overstatement — but the *exactness* is exactly as strong as this item.

The ceiling table is a theorem about the Oliver-admissible family **as currently characterized**, and the entangled-generator correction showed that characterization can be wrong in the permissive direction — a whole family was excluded by an argument that confused a quotient for a subgroup. **Nobody has searched for the optimal admissible family**, in this project or in the literature: BBKN had no reason to, since below the endpoint any admissible family gives the same order (`literature-findings.md` §15b). So the literature's silence is evidence neither for nor against the entangled construction's optimality, and this is the one place a further constant factor could still be hiding. No cheap test is known; the honest status is that the ceiling is a ceiling *over what we have enumerated*.

### A25. The transference route from (SP) to a floor

`sp-to-floor.md` §6.2 files it: S_D under (SP) has positive relative density inside the Selberg majorant for the pair `{Q, dQ+1}`, whose pseudorandomness is sieve-provable, and a restriction/transference estimate for `n = kp + r` against that majorant would give the representation for almost all n with **no distributional hypothesis on S_D at all**. §6.1's counterexample marks the boundary any such argument must respect — the count alone is provably insufficient — so a successful transference must consume the unconditional sieve upper bounds. A research question, not an afternoon; filed here because it is otherwise homeless outside a one-pass working note.

### A26. The note before circulation: what to re-read, and one decision to make

*The naming and the non-nesting are done — the note carries `(BCG_{1/5})` with a paragraph explaining it, and `note-to-framework-bridge.md` §4 states the non-nesting. What is left is a reading and a judgement call.*

`mu-theta-n2-note.md` remains **correct on its own terms** — its family is the unfused one, its window is deliberately generous, its constant crude by design — and nothing here touches its Theorem. What changed around it: its hypothesis is now **(BCG_{1/5})**, and its relation to the framework's is **non-nesting in both directions**, not "a weaker form of the same thing". (BCG-AL) hands over an `F = 4` configuration at n ≡ 11 (mod 12) with `c/n ≈ 0.134`, which the note's `c ≥ n/5` rejects; the note in turn is far weaker in constant and restricted to `n = c + r` and `n = 2c + r`. **Before any circulation:** re-read the note's §5 θ-ladder against `aod` §3.6's current attributions, and decide whether the note should mention the F = 4 shape at all or stay deliberately silent about it.

### A27. A second reading of `sp-to-floor.md`, now that `aod` §6.9 quotes it

Promoting the note's findings into `aod` raises the value of a second reading rather than lowering it, and §6.9 is written so the tiers can be checked independently.

**Cheap and self-contained (an hour):** (a) the identity `1/(√k+√(d/2))² = cap_k(2/d)`, algebra; (b) the six-cell (F, d) match against §3.5.3's clause 3, a table comparison; (c) the generic-set counterexample, elementary. If these three hold, §6.9(a)–(d) stand whatever happens to the rest, which is why they are separated out.

**The real read (a day or more), in descending value:**
1. **The Reduction Lemma's orbital structure**, proved rather than enumerated at five (p,k) pairs — and specifically the foreign term, which carried a factor-2 error through the note's first draft and set its headline constant 42% low. The corrected value `rQ` at odd Q is verified by enumeration and matches `shparlinski-constants.md` §1.5, but **it has one reader**.
2. **The major-arc assembly** (§4.2), where the hypothesis is actually consumed; the singular-series completion is sketched for squarefree `q` only.
3. The two [STANDARD] steps used on citation — the Vinogradov dilation lemma and the Siegel–Walfisz manipulation.
4. §7's end-to-end run, which is separately blocked on A23's rerun.

**What a disagreement would cost.** (a)–(d) are quoted in `aod` §§3.5.3, 6.8 and 6.9 and would survive; (e) is cited rather than restated, so a failure there retracts a citation and the strengthened reading of the asymptotic half, not any unconditional claim. That asymmetry is deliberate and should be preserved if §6.9 is ever expanded.

### A9. The Lean formalisation — keep it in step, and keep it moving

*Home: the Lean project's own `README.md`, which carries the phasing, the case for and against, and the failure-mode analysis. **This item exists so the work resurfaces even when nobody thinks to mention it**; do not restate the reasoning here.*

**Two obligations, and the first is the one that rots silently.**

1. **Sync.** The Lean statements encode claims from these documents — ceiling values, coefficient rules, threshold ladders, the `orb` definition. *Most recent sync found one drift and fixed it:* `Note.lean`'s hypothesis structure was `HypH`, which both invited conflation with the framework's class-keyed hypothesis and carried the Schinzel collision the (BCG) rename existed to remove; it is now `HypBCG`, with the non-nesting recorded at its docstring. When a document changes, the Lean can quietly stop matching it, and nothing in this repository's checks looks at `.lean` files. Any revision to §3.3.5's table, to the cap algebra, to `orb`, or to the E′ s-bound should be followed by a pass over `ArkCore.lean`, `Note.lean` and `Basic.lean`. The ceiling table is the sharpest case: the entries are enumerated one per constant, so a table that gains or loses a constant leaves a list of the wrong length — which is useful only if someone looks.

2. **Progress. Phase 0 is complete.** Status is per file, and the distinction that matters is the sorry count rather than the compile — a sketch full of sorries compiles perfectly happily:

   | file | compiles | sorries |
   |---|---|---|
   | `ArkCore.lean` | laptop **and** container (core 4.15.0, no Mathlib) | **0 — every proof complete** |
   | `Note.lean` | laptop | **0 — every proof complete**, six by import from `ArkCore` |
   | `Basic.lean` | laptop | nonzero — the remaining sketch, phase 1 |

   Between the first two the note's whole arithmetic layer is proved; what stays conditional is **(BCG_{1/5}-AL)** — the *note's* fixed-window hypothesis, formalised as `HypBCG`, not the framework's class-keyed (BCG-AL), the two being non-nested — and Oliver, neither formalisable. `ArkCore.lean`'s clean compile against core 4.15.0 with no `sorry` warning has been **independently reproduced** in a container built from the GitHub-releases tarball, so the zero-sorry claim rests on a rerun rather than on a remembered result. **Phase 1 is DONE: all three Lean files are sorry-free.** `Basic.lean` went **18 → 0** in one pass. Proved: `orb_full`, Lemma D1, the capacity bound, Prop F.1, the E′ s-bound and both threshold ladders, the `capF` algebra, **all six §3.3.5 ceiling entries as algebraic numbers** including the global constant `capF 4 (1/3) = 7 − 4√3` at the extremal class, the two-foreign closed form, and the quadratic-residue collapse.

> **Three signature corrections came out of it, which is the better argument for this layer than the proofs are.** `orb_full`'s `2 ≤ c` and `capF_eq_k_sqrt`'s `0 ≤ η` turn out unnecessary — Lean reports them unreferenced, and both are now underscored. **`prop_F1` was false as stated**: at `k = 0` the sum over `Fin 0` is 0, so `n = 0`, the capacity hypothesis is vacuous, and the conclusion reads `0 < 0`. `0 < k` added. That is the *same* failure the file already recorded at `size_of_capacity` — an informal claim quantifying over a configuration and forgetting the empty one. **Two instances in one file is a pattern worth carrying: whenever a claim is "k things each with property P force a bound", check k = 0 first.** A prover cannot skip the degenerate branch the way a reader does.

> **Two techniques worth reusing.** *Write δ = m/N and square* — both ladders are claims about `1/√δ`, and squaring clears the real and the root together, leaving `Nat` arithmetic core Lean proves outright. Where a real-valued claim is an inequality between two squares, the `Nat` form is the same statement with the coercion removed, not an approximation of it. And *supply the surd once*: `capF_of_sqrt` takes the root and its defining equation as arguments, so six ceiling entries became six instances of one identity.

**The remaining Lean work is phases 2 and 3, and neither is owed.** Phase 2 is the balance-point maxima — partly pre-empted, since its cleanest named target (the two-foreign closed form) is already proved and `capF_of_sqrt` is likely the lever for the rest. Phase 3 would make `B n` a Lean-checkable function; the Lean README's own judgement that *this is where I would stop* still stands, `validate_table_v3.py` already covering the rows.

**What the sync obligation now guards** is drift in the other direction: the Lean statements are checked, so a document changing a constant, a coefficient rule or a threshold now contradicts a *proved theorem* rather than a sketch. `Basic.lean`'s ceiling entries are the mod-12 table; if §3.3.5 ever gains or loses a constant, the list of six no longer matches.

**Two environment lessons, both earned by a failed run, and both about names rather than mathematics.**

- **Imports.** Lean resolves `import ArkCore` through `LEAN_PATH` and lake's build dirs and loads the compiled `.olean`, so co-locating sources does nothing and `PATH` is irrelevant. Either `lake env lean -o ArkCore.olean ArkCore.lean` then `LEAN_PATH=$PWD ./leancheck.sh Note.lean` — **on one line** (exporting `LEAN_PATH` first does not take) and **without** `:$LEAN_PATH` (unset variable ⟹ empty path entry ⟹ rejected) — or move the files under the lake library's source dir and import `Ark.ArkCore`. The README carries both recipes and all three gotchas, plus the container recipe for a bare toolchain (direct GitHub tarball; elan's release server is off the allowlist; **Mathlib stays unreachable there**, so Mathlib-side work is laptop work).
- **Lemma names are the version-dependent part.** Two of the three failures so far were name drift, neither a false statement: `List.mem_cons_self`'s arguments are explicit in core 4.15.0 and implicit on the laptop; `div_le_div_iff` no longer exists under that name. **The convention: prefer a tactic, or a decomposition into long-stable lemmas, over a named iff-lemma wherever the goal is routine** — the division inequalities now go by difference-is-nonneg (`div_nonneg`, `field_simp`, `linarith`) rather than by whatever `div_le_div_*` is currently called. Ordering-and-division iff-lemmas are the highest-churn corner of Mathlib. Likeliest next offenders: the `Nat.mul_le_mul_left` / `mul_le_mul_right` / `mul_lt_mul_left` family, used at a dozen sites in `ArkCore`.

**What it is not for.** Formalising the arithmetic layer does not check the group theory, and reaches no layer-assignment claim — which is where this framework's defects have been. Re-read the README's closing caveat before spending time here.

### A0b. `validate_table_v3.py` — the three groups

`python3 validate_table_v3.py <current table> --baseline <previous table> --ladder ladder_weak.txt`

- **A. Table integrity** — well-formedness, Lemmas B′ and D2 on each witness, re-derivation of `mu_bound` from the witness by the G.3 formulas, the density column (A20), certification, monotonicity against the baseline, and the **Part E preconditions** (T2). A FAIL means the run or parser is broken.
- **B. Exact claims, holding at every n** — Prop F.1, cap_F(η), S2's 1/F, layer-by-top-prime, S6 emptiness, Lemma C exposure, the cyclic layer's pairwise coprimality, the feasibility criterion, Part G.4's per-axis bounds, the within-class cross coefficient, and the foreign-side residue patterns. The matching block's residue prices nothing, so the exact checks live on r, not c; the retired c mod 8 patterns are kept as group-C INFO, where a population at the residues the old law forbade is positive evidence. A FAIL is a real contradiction between table and documents.
- **C. Density and distribution** — floor and the s/k bounds it implies, low-density tail, part-count distribution, census shares, odd-n shares, class-ceiling exceedance, median density by residue class, foreign-block efficiency, ω(n) = 2 share. All INFO, each printing the expected asymptotic beside the measurement.

**Four group-B checks have no independent counterpart elsewhere:** the cyclic layer's global pairwise-coprimality condition (the only check that would catch the enumerator *over*-correcting), the feasibility criterion Σ√Fᵢ ≤ 1/√δ, Part G.4's per-axis bounds, and the within-class cross **coefficient**, which is invisible to output since the term never binds. Each has a negative control: breaking it makes the check FAIL.

**Group-B trend check, for census rows claiming `wins → 0`.** The verdicts are asymptotic limits, so a count tests nothing; what is required is a *declining share*, clearing both a proportional bar and Poisson noise. `ZERO_SHARE` entries may be a tuple treated as one aggregate — needed because splitting S7 by fusion count costs sensitivity. To exercise it, replace the `S7f3`/`S7f5` entries with `("S7f3","S7f4","S7f5","S7f6","S7f8")`: it fails with `S7f3+…+S7f8 4.1%→7.6%` against `S2 45.2%→29.3%`.

**Amend it in the same pass whenever the model changes** — each check names the document section it comes from, so a stale check is findable from either end. It checks the table against the documents' model, not against mathematics; for independent evidence use `brute_compare.py`.

> **Keep it fast — a design constraint, not a nicety.** The suite runs in about **0.1 s on 1,700 rows**, which is what makes it reflexive rather than scheduled. Keep each check O(rows) or O(rows × parts) on numbers already parsed from the witness. Enumerating configurations, isomorphism work, re-deriving B(n), or sieving past `NMAX` belong in a certificate. If a new check must compare a row against alternatives, budget it against the 0.1 s and say so at the check.

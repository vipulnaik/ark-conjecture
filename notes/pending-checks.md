# Pending checks

*What is left to run or build, for the arithmetic programme — `orbital-evasiveness-notes.md` §§1–6, `enumeration-proof.md`, `arithmetic-of-density.md`. **Outstanding work only**; anything closed moves to a session log.*

*This file is a work list. It carries what a run needs in order to be run correctly — the command, the input, the expected shape of the output, and the traps specific to that run. It does **not** carry the reasoning behind the checks: that is `verification-lessons.md`, and the explanatory logic needed while a run is in progress belongs in the script's own output.*

> **Every run currently owed.** Each is expanded at its own item.
>
> | run | why owed | item |
> |---|---|---|
> | `mu_enumerate_v3.py` (extend) | contiguous frontier short of where the documents' figures want it — an extension, not a redo | R0 |
> | `validate_table_v3.py` | gates everything else; run on every batch | R1 |
> | `fallback_cert.py`, both modes | unblocked; coverage counts requoted from the run | R1 |
> | `wide_cert.py` | same, plus `fused_lo` now admits composite block counts | R1 |
> | `a18_verify.py`, `t5_verify.py` | range-scoped dominations; they expire on extension | R1 |
> | `check_doc_figures.py` | the pass that replaces ⟦PENDING-REBUILD⟧ figures | R1 |
> | `audit_fmid.py` | reads the table; also owed for range coverage | R6b |
> | `solvable_relaxation.py` (comparison pass) | B ≤ B_solv on the rebuilt table | R6c |
> | `ladder_verify.py` | rung B now at full twist, `CAP` keyed mod 12; floor and worklist both move | R7 |
> | `verify_witness.g` | rebuilt around the entangled generator; never run in this form | R8 |

> **The table itself does not need recomputing.** The enumerator's scoring is unchanged from when the current rows were written, so rows already present are current values and a run in flight can continue. Everything owed above is downstream of the enumerator, or a script whose own scoring changed. The test for any artefact: does the script that produced it appear in the list?

**Scope notes.** The table is a **contiguous prefix plus a worklist-driven tail**; quote distributional figures over the prefix only (R0). Single-degree work — the GAP battery, the CSP, the backbone probes, the template enumerator — is in `small-degree-verification.md` with its own run list, and touches this programme only through the exhaustiveness of its GAP stages, which licenses Part I's n = 10 and n = 12 comparisons.

**Companion files.** `verification-lessons.md` — the failure-mode taxonomy and the reasoning behind the checks. `fusion-count-ceilings.md` — **⟦ARCHIVED⟧** the derivation of §3.3.5 as a joint optimum over (F, η); its conclusion is integrated, but it is keyed mod 24 and predates the entangled correction, so read it for the derivation and not for its constants. `shape-counting.md` — the enumeration, asymptotics and recomputation apparatus behind `aod` §6's counts; verified arithmetic, and in the canonical `check_doc_figures.py` invocation. `solvable-relaxation.md` — the same extremal problem with the chain relaxed to solvability; calibration only, nothing in the main line depends on it. `three-uniform-note.md`, `general-k-note.md` — the arity axis; `k3_galois.py` is the k = 3 Galois admissibility predicate, to be imported rather than re-derived. `chiral-graph-properties.md` — the A_n port. `monotone-transitive-note.md` — the general transitive setting. `literature-findings.md` — framing, deliberately not folded into the primary documents. `mu-theta-n2-note.md` and its LaTeX twin (identical in content) with `note-to-framework-bridge.md` — the standalone Θ(n²) note and its standing consistency check; **requote the bridge's §2 figures whenever a framework figure the note imports moves** (currently: the ladder floor with its range and argmin, and the mod-12 ceiling values). The **Lean formalisation** (`Basic.lean`, `Note.lean`, own `README.md`) tracks these documents and can fall out of step silently — see A9. `three-part-family-split.md` and the two resolution notes `a18-resolution.md` and `t5-resolution.md` are **⟦ARCHIVED⟧**, each carrying a banner saying what was integrated and what has moved; the resolution notes' *mathematics* is current and is the authority behind Lemma D2's replacement and Lemma C's coupling, and `a18-resolution.md` §4's r = q sub-case is still open. Session logs hold the review record, `session-log-11.md` current.

**Status labels.** *Verified* — an independent computation agreed. *Sound* — an argument was read and found correct. *Unverified* — neither.

*Do not restate the inequality as `B_safe ≤ μ`.* `B_safe` over-counts per configuration; what holds is B_refined ≤ μ ≤ B_safe, the endpoints collapsing where the certificate applies.

## The enumeration-proof gap inventory

*One place for the daylight between what `enumeration-proof.md` proves and what it verifies. Fresh-eyes read of the full document, 2026-08-18 (session-log-8 §21). The gap has moved in both directions since the document began — unexpected winners found (cyclic-layer block counts, the fused rungs, the Fermat escapes, the two-foreign shape at the extremes) and exclusions gained (E′'s collapse machinery, the D2′/C′ dominations, q-pinning) — and this is what remains between the two:*

1. **Part 0 completeness** (μ ≤ B_safe's whole load): a shape missing from the space fails silently, and the only tests that could see one are the exhaustive GAP comparisons at n = 10 and 12. Verification-lessons §1 site 4. → risk item 2 below, `small-degree-verification.md` item 5.
2. **The two-part reduction of Theorem 2.3**: verified to n = 1200, Goldbach-tier to prove; nothing rests on it but B₀'s O(n) cost claim.
3. **Minimality k ≤ 3 below δ = 1/16** (J item 1): free above 1/16 by F.3; counting saturates at 4 (F.2 is tight); any proof is arithmetic — must *produce* a strong ≤3-part decomposition — and the wide B₃/B₂ margins close the perturbation route.
4. **The collapse's theorem-side residue** (J items 2, 2a): E.3(ii)'s global promotion (the leftover case; the bare pair is resolved), and the s = 4 / s = 5 branches, theoremless and reachable only below δ = 1/25 and 1/36 respectively (sharp thresholds — the s-ladder, not F.3's k-ladder). Per-n the certificates close everything; the gap is only over *all* n.
5. **J0a's non-semilinear stabilisers**: an irreducible non-ΓL(1) subgroup of GL(a, p) is an unstated assumption bearing on attainment only (the ΓL(1) case is proved harmless at k = 2; B_safe is untouched either way).
6. **Lemma B′**: proved, second reading done and confirmed; the one structural lemma whose failure would break B_safe itself, so further scrutiny stays profitable. → T1.

*Everything else in the document is proved, and the per-n machinery (eight necessary conditions + search) makes each computed value unconditional independently of items 2–4.*

**Not on this list, because it closed:** the converse direction — that a density floor *forces* a shifted-prime statement — is now Proposition F.4 of `enumeration-proof.md`, with the discussion in `aod` §6.7. It is elementary given F.1's machinery and needed no new input. **What it opens instead is a sharpening question**, which is a research item rather than a gap: the round trip (BCG_{1/5}) → δ₀ = 1/350 → D = 700 loses a factor ~58 against its own d ≤ 12, uniformly across both branches. Whether either direction can be tightened — a better constant in the note's central inequality, or a converse that reaches a prime rather than a prime power — decides how close to a genuine equivalence this is. Neither is needed for anything currently claimed.

**Staleness defects already closed, listed so they are not rediscovered.** Four, all now corrected in the documents: the notes §1 SAFE-cap box prescribed the **F_mid strip** that the entangled-generator repair removed, i.e. the box warning readers off the wrong cap taught the wrong cap (the live cap in `mu_enumerate_v3.py` is the flat F·C(c,2), and `ep`'s four "F·orb(c, dmax)" descriptions of B_safe are now flat too — the F·orb(c, dmax) form survives only where it belongs, in the certificates' leftover twist cap); `aod` §3.3.5 quoted **cap₂(1/6) = 0.050510**, which is cap₄(1/6) — the correct value is (2 − √3)/4 = 0.066987, so the F = 4 margin at class 11 is 0.0048 and not 0.021, as §6.6 already had it; three surviving mod-24-era constant counts ("seven mod-24 ceilings", "eight constants", "seven distinct δ₀") against the table's six mod 12; and two winner counts contradicting the census in the same document (150/24 against 338/30 for the fused `2×c + r*` rung; 20 against 18 for the `2×c + 257*` Fermat winners, whose list also contained two n won by F = 4 shapes). `check_doc_figures.py --pass scope` now carries greppable invariants for the first and third of these.

**Owed source check — the E–H exponent's exact form.** `aod` §3.6 and `literature-findings.md` now state Shparlinski's §5 Elliott–Halberstam consequence as n^{3/2−ε} for every ε, on the grounds that E–H is quantified for fixed ε > 0 (level z^{1−ε}) and so no single application reaches 3/2. **This is inference, not a quoted bound** — the §5 remark states the improvement without writing an exponent, and the arXiv version is what was read. Confirm against the published version; if he does claim a bare n^{3/2}, the reasoning behind it needs recovering, since the unconditional n^{5/4+o(1)}'s `+o(1)` is the subpolynomial-loss convention and does not supply the difference.

## Where the residual risk sits

*Ranked, so the item order below has a stated basis. The reasoning behind this ranking — the failure-site taxonomy it comes from — is `verification-lessons.md` §1.*

1. **The table's and ladder's reach, both in motion.** → **R0**, **R7**, **R1** after every batch.
2. **Exhaustiveness of the GAP stages.** The only non-circular check in the framework; the subdirect-product hole is undischarged. → `small-degree-verification.md` item 5
3. **Part E's realisability.** No per-n verification, and no coverage at the fusion count that sets the ceiling at n ≡ 11 (mod 12). → **T2**, **R8**
4. **§3.3.5's ceilings.** Exposure is the shared supply hypothesis plus a class-11 entry resting on 676 > 675. → **T6**
5. **The κ parameters at k = 3.** Whether κ can be steered independently of the congruences fixing F and η. No risk to k = 2. → **T7**
6. **Proposition F.4's reliance on Lemma B′.** Branch (b) is vacuous unless a foreign twist is a prime power, which is B′'s content — so the exposure is B′'s correctness (item 1 above) plus one reading of a new argument, not an unstated assumption. → **T8**
7. **The eight necessary conditions of `fb_common.py`.** Both certificates rest on these *plus two dependencies underneath them*, and what matters is *necessity*. → **T3**, and the two named in `fb_common.py`'s header: (i) foreign parts are scored **unfused**, so what excludes a fused foreign class is Lemma D2's domination and not any condition in the list — its range-scoped half is `a18_verify.py`, so quoting the "eight conditions alone" banner without it overstates the result; (ii) condition (4)'s strip licence is Corollary C′, whose Frobenius-exponent step is written inside AΓL(1, c), so at **a ≥ 2** it inherits J0a. Measured on v4 over n ≤ 1200: **24 strip decisions, all 24 licensed, none at a ≥ 2** — so over that range condition (4) never invokes the a ≥ 2 case and the J0a exposure is empty in fact. **⟦PENDING-REBUILD⟧** *A trace count is a run output; repeat it over the full rebuilt range, since a single a ≥ 2 licensed strip puts J0a back into the collapse's trusted base.*

---

# §1. Script runs

*Can be launched in the background. Flags are checked against the scripts as they stand; where a run needs code that does not exist, that is said rather than papered over with a plausible-looking flag.*

## R0. Extend the table, then rerun everything downstream

**⟦PENDING-REBUILD⟧** The rebuild is in progress; the contiguous frontier is wherever the run has reached. The previous table is the **baseline, not the current table** — its rows are lower bounds. Extension costs roughly n^2.9 per value.

```bash
python3 mu_enumerate_v3.py --nmax <N> --fill-gaps --out mu_table_safe_v5_code_v3.csv
```

- **Use `mu_enumerate_v3.py`.** An enumerator whose SAFE cap cuts a fused class's twist by the block count produces lower bounds, not values — such a table may be a baseline, never an extension.
- **Rows above the contiguous frontier are worklist rows, not range.** Values consumed under R7 are appended to the same CSV and are a low-density subsample. Quote distributional figures over the contiguous prefix; quote the floor and "nothing below X" over the whole file.
- **A rebuild must never lower a value.** `validate_table_v3.py`'s group-A monotonicity check against `--baseline` is the signature to read on every batch.
- **Rebuild the R7 worklist afterwards** — its pruning is keyed to a floor that has moved.

## R1. Routine, after any new batch of table values

> **⟦PENDING-REBUILD⟧ Expectations suspended while the rebuild runs.** Reference points so a deviation is recognisable: `validate_table_v3.py` gives **0 FAIL** on an enumerator output under the current scoring — 23 PASS / 0 FAIL / 12 INFO / 5 SKIP on the in-progress rebuild — but **not** when pointed at a *baseline*, where group A's re-derivation check fires on every row whose recorded winner is a cyclic-fused class scored under the superseded cut twist (18 rows on v4; see A22, which pairs that count with the 289). The S2-identity check in group B is deliberately *not* a second FAIL on a baseline: it returns INFO naming n = 78 and n = 222, which are the correct baseline answer, and FAILs only on some other set. `check_doc_figures.py` does not go to zero — most PASS 1 flags are coincidental numeric matches, so read it finding by finding. Certificate counts are requoted from their reruns. A validator asserting a congruence on the matching block's residue would FAIL on any correct table.

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

# 6. the documents against the table; this replaces the pending figures
python3 check_doc_figures.py $TABLE *.md
```

**What to read off each.**

- **`validate_table_v3.py`** — pass both `--ladder` and `--baseline`; they enable two cross-artefact checks for the cost of a dict join. **Group A** FAIL: the run or parser is broken, nothing downstream is meaningful. **Group B** FAIL: a real contradiction between table and documents. **Group C** is INFO, each line printing the expected asymptotic beside the measurement. `--explain N` for one row's term breakdown, `--baseline` for shape-migration reporting. Full description of the three groups: A0b.
- **`fallback_cert.py`** — headline is *0 candidates*. Then read the **density floor**, the **largest permitted s** and the **theorem residue**, off the run itself: they move together (s ≤ 1/√δ − 1), and **s = 4 is the first branch with no theorem covering it**. If `largest permitted s` prints 4, `enumeration-proof.md`'s Corollary after E.3 and Part I's tail figures want re-deriving. `--no-theorems` should agree exactly — but measure whether the dispatch is firing, or the agreement is vacuous.
- **`wide_cert.py`** — read `settled by theorem:`. At NMAX ≤ 10⁴ it prints NONE and a `--no-theorems` comparison there is no evidence. `--menu` cross-checks pass 1; `--refresh` rebuilds the cached B_lo.
- **`a18_verify.py`** — Lemma D2's witnesses plus its **range-scoped** fused-outside domination, which a table extension can invalidate silently.
- **`t5_verify.py`** — Lemma C's coupling and Corollary C′, plus the three facts gating condition (4)'s strip (T5). Its last pass is **range-scoped**.
- **`converse_check.py`** — headline is *0 violations*, but the run is for the two constants rather than the verdict. **Max cofactor** is quoted in `ep` F.4 and `aod` §6.7 as **12**, matching (BCG)'s own d ≤ 12; that coincidence is the reason to look, and a value above 12 weakens the claim that (BCG)'s constant is the natural one rather than a chosen one. **Slack** is quoted as ≈ 4 in the gap inventory. *These two behave differently under a rerun and the difference matters:* max cofactor is a maximum over witnesses, so it moves only if the corrected shape space changes which primes win; slack is max-cofactor against 2/floor, so it moves whenever the **floor** moves and is therefore **range-dependent even on a correct table** — at the v5 partial frontier (n ≤ 1546) it reads 2.9 against v4's 3.6 purely because the floor over a shorter range is higher. Requote slack with its range, and do not read a change in it as a finding.

- **`check_doc_figures.py`** — `--quiet` for findings only, `--pass {figures,scope,prose,hygiene,census,refs,tables}` for one pass. **Pass every `.md` that might be cited**, or `refs` reports live citations as dangling. Append the old maximum to `CHECKPOINTS` and a pattern to `SCOPE` in the same sitting, or superseded-range figures report as unexplained rather than historical.

**Add to step 1 if not already there:** **B(n) ≤ B_solv(n)** must hold at every row, Oliver groups being solvable. O(n) partition scan per row, no certificate needed. Currently 0 violations, 20 exact attainments across the 289 raised rows. (R6c runs the full version.)

**Static — one run per environment, not per batch.** `eta_derive.py` (the η column, derived and measured independently), `khomog_verify.py` (the k-homogeneity claims behind the `notes` §1 hypothesis table), `a18_rq_verify.py` (nine checks on Lemma D2q), `k3_galois.py` (the k = 3 Galois predicate, with its own self-test).

**Deliberately absent.** `ladder_verify.py` never reads the table — it belongs to R7. `s7_scan.py` and `mu_fast.py` are not in the working set; group B covers what `s7_scan.py` would test.

**Do not extend the table without rerunning this list in full.** `check_doc_figures.py --pass refs` and `validate_table_v3.py`'s coefficient assertion are what catch the omission mechanically. The Lean statements are read by no check here — see A9.

## R6. Shape-level scoring checks

*Score **shapes**, not rows, so they do not rerun on table extension. Rerun after any change to the SAFE cap, to `orb`, or to `mu_enumerate_v3.py`'s scoring.*

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

## R6b. Re-screen the shared-block-count configurations

```bash
python3 audit_fmid.py <current table>.csv   # expect 0 configurations scoring above B(n)
```

**Owed twice over: for the table it reads, and for the range it covers.**

- **Which table.** The screen compares an optimistic candidate against a recorded B(n), so a table that understates B makes it fire more often and one that overstates makes it miss. Run it against the current table. Against the previous one it reports 2 hits (n = 1739, 2223), both artefacts of stale rows — the current enumerator scores those at 118341 and 307193 against candidates of 97656 and 166872.
- **Coverage is part of the result.** Rows the table does not reach are not screened, and the silence looks like a pass. The script prints the count of unscreened non-prime-power n in range before the verdict; **read that line first.** Not satisfiable until the contiguous frontier reaches 2600.

*Context: this screen is the only artefact behind the shape space's shared-block-count admission. The other two ways a block count could have mattered are covered by argument — Part E's diagonal carrier, and a counting bound on foreign primes. A hit is a configuration to score exactly, not a reason to tighten the admission.*

## R6c. The solvable relaxation's comparison pass

```bash
python3 solvable_relaxation.py <current table>.csv
```

*Only the comparison pass reads the table; the rest computes B_solv from scratch. Owed on every extension.*

B(n) ≤ B_solv(n) is structural — an Oliver group is solvable — and on a matching class the two coincide exactly, so exact attainments are expected and a violation means the Oliver side is crediting a class no solvable group carries. Cheapest independent check available on a rebuild: no certificate, no GAP, no second enumeration.

**Requote from the run, do not carry forward**: the exact-attainment share and the class-11 exceedance share, both quoted in `solvable-relaxation.md` and both moved by the rebuild. *(The class-11 share is large — 77 of 94 on the rebuild prefix exceed 7 − 4√3 — and that is expected, not a contradiction: the ceilings bound the balanced additive family, not μ. A reader meeting the figure cold reads it as a violation.)* `k3_galois.py` is *not* registered here — it takes no table and scans a fixed range, so one run per environment suffices.

## R7. Consume the ladder worklist with the adaptive branch-and-bound

> **⟦PENDING-REBUILD⟧ Run the ladder before consuming its worklist.** `ladder_verify.py` now scores rung B at the full twist and keys `CAP` mod 12, so a worklist or floor from any other scoring ranks against the wrong ceiling. Rerun, regenerate the worklist, and only then read any count below as live.

```bash
python3 ladder_verify.py 1000000                      # regenerates ladder_weak.txt
python3 mu_enumerate_v3.py --nlist ladder_weak.txt \
        --floor 0.0400 --adaptive --out <current table>
```

*Interim figure under the corrected scoring, pending the 10⁶ run: δ ≥ 0.0462 over every composite non-prime-power n ≤ 10⁵, minimum at n = 2759.*

**What `--floor … --adaptive` does that a plain `--nlist` run does not.** Prunes on the supplied lower bound (LB(n) ≥ floor already proves δ(n) ≥ floor); seeds unpruned n at floor·C(n,2) so it need only find *some* clearing configuration; appends exact rows to `--out` with the full schema and witness, never rewriting or reordering; and reads the table back as prior knowledge, so existing rows tighten the search.

**Set the floor to the question.** It is an interrogation threshold, not the known answer — setting it to the current floor prunes everything.

| `--floor` | what it settles |
|---|---|
| **0.0400** = 1/25 | whether any n leaves room for **s = 4**, the first fallback branch with no theorem |
| the current table floor | whether anything undercuts it |
| the ladder's global floor + ε | whether the argmin's B(n) exceeds the ladder bound there |

Run in that order; the cheap one may answer the expensive one's question. `--nmax` caps a `--nlist`, which is how to defer five-figure entries — at n^2.9, n ≈ 50,000 costs roughly 10⁴ times an n = 2,000 row.

**Cautions.**

- **Needs R0 finished** — pruning and the part-count cap are both keyed to a floor read off the table.
- **Never combine with `--refined`.** The script refuses it: adaptive mode appends rows, the schema records no mode, so a refined row in an unconditional table would be undetectable.
- **Rerun R1 afterwards** — the job extends the table.
- **Do not overwrite the worklist.** `LADDER_OUT` is honoured; each run's file is the evidence for §3.7 and §5.2.
- **Probe before committing an expensive n.** A targeted scan over the two-part census shapes, scored with `mu_enumerate_v3.py`'s own `value()`, settles the floor question whenever the answer is "clears". It reproduced B(n) exactly at all eleven worklist values where B was independently known.

## R8. Widen the Part E realisability battery

*The one leg of μ(n) = B(n) with no per-n check. **⟦PENDING-REBUILD⟧** `verify_witness.g` was rebuilt around the entangled generator and has not been rerun; prior coverage stands at twelve values from the superseded battery, largest n = 575.*

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

**What a pass settles:** that the enumeration's score at that n is *attained*, μ(n) ≥ B(n). Not completeness, and not J0a — the script builds the twist inside the field's multiplicative group, so it cannot detect that a larger stabiliser was available.

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
- **J0a, the stabiliser assumption** (item 5 of the enumeration-proof gap inventory above)**.** The construction takes a matching block's twist inside the field's multiplicative group, whereas the stabiliser of a primitive affine group of degree p^a may be any irreducible subgroup of GL(a, p). This cannot inflate B_safe, which already credits C(c,2), but it bears on attainment, and **no precondition check reaches it** — the witness records a twist order, not the group the twist lives in. Either justify the restriction or scope the realisability claim to it.

### T3. Independent necessity read of the eight conditions

*Why necessity rather than truth, and why the failure is invisible: `verification-lessons.md` §2.*

Both certificates pass with every Part E′ theorem disabled, so these eight conditions are the whole trusted base for μ(n) = B(n). `fb_common.py` carries a per-condition necessity argument in its header, so **what is owed is scrutiny of those eight arguments, not their reconstruction** — and the value is in the independence, so a second reader beats another pass by the first.

**Two places to press hardest.** **Condition (4)'s foreign strip** is load-bearing and its necessity is *licence-scoped*: press on the licence and its gate rather than the strip — an over-generous sharing bound licenses an over-strip, and the loss is invisible in the output. **Condition (6)** is not independently necessary and is retained as a tripwire; check nothing has come to rely on it.

**Three strip sites** — `pair_candidates`, `single_part_ok`, `multi_part_ok` — each gated on the same local licence, asserting it, and recording through `set_strip_trace()`. **Re-count the sites on any edit to the file**: an ungated strip produces the same output as a correct run.

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

**Still open from this reading:** Balog–Sárközy's own proof internals were not re-derived (the *statement* consumed by Theorem 2 was confirmed to have a pure-cardinality hypothesis, which settles the equidistribution question at the level it is used); and whether any endpoint-capable sumset result tolerates a 1/log²x set is the live successor question. **The highest-value next check is Sárközy–Stewart's actual hypothesis** — it is taken here from Shparlinski's characterisation ("cardinalities of order N") rather than the original, and if it is weaker than that the endpoint accounting changes materially. *Note also the strategic consequence:* the fixed-residue item above attacks the **input** side, which this reading shows is not where the difficulty is, so it should probably rank below the sumset question rather than beside it.

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

**⟦PENDING-REBUILD⟧ Owed on each rerun:** instrument every strip decision the certificate reaches (`set_strip_trace()` records (p, a, r, B, bound, licensed)) and read off how many fire, whether any fires at a > 1, and whether any verdict differs from an ungated run. **Do not quote a decision count without measuring it on the run in hand** — it is a property of the frontier and of the file's current form. The expected picture is that `orb(r, t) < B` kills every proper-prime-power branch before condition (4) sees it.

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
- **Class 11's entry rests on 676 > 675.** The comparison 7 − 4√3 > (2 − √3)/4 reduces to 26 > 15√3, the narrowest possible integer margin. The derivation removes the way the η there was most likely to be wrong, but the margin is what it is, and anything upstream that moves it flips the class. *(Independently re-verified, along with every closed-form constant in §3.3.5 and the cap_F(η) = cap₁(Fη)/F identity. The exposure here is the supply hypothesis and the margin, not the arithmetic.)*

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
- **The constants. RE-DERIVED from scratch and correct** — both branches, the 700 round trip, the 44 at the v4 floor, the ≈58 and ≈4 slack factors, and n(n−1) carried consistently. **One earlier entry here was itself wrong and is now corrected.** It claimed the smallest intra orbital of a foreign class is at most F·r·Q/**2** rather than F·r·Q, so that the derivation was discarding a factor 2 in the safe direction. That is false at **odd Q**, where `−1 ∉ C_Q` and the orbital is exactly `r·Q` — verified by orbit enumeration at (13,3), (31,5), (11,5) giving 39, 155, 55, against the halved values 26, 31, 164 at the even-Q pairs (13,4), (31,2), (41,8). `shparlinski-constants.md` §1.5 draws the correct and opposite conclusion: **F.4's F·r·Q is tight at odd Q and the factor 2 is not recoverable there**; the halving occurs only at Q = 2, which `aod` §6.8's parity remark makes the rare case. F.4's derivation is sound either way, since F·r·Q bounds the orbital above in both parities — what was wrong was the belief that slack was hiding here. *(The same error, made independently, cost `sp-to-floor.md`'s Reduction Lemma a factor 2 in its headline constant; the correct argument was already written in `note-to-framework-bridge.md` §5 and propagated to neither.)* The residual watch-list: the orb halving at even twist, and C(n,2) versus n²/2 — *the second of which has already produced one slip, a draft asserting δ₀·C(n,2) > δ₀n²/2, which is backwards since C(n,2) < n²/2; the statement now carries n(n−1) throughout.* Nothing structural turns on it, but `aod` §6.7 quotes 700 as the round-trip figure and it inherits any slip. *One such loss has already been found and removed* — the all-matching branch was first derived at 2/δ₀² by bounding F ≤ 1/δ₀ and c ≤ n separately, when F·c is bounded by n jointly; keeping the product together gives 2/δ₀ on both branches. Checked over ~4·10⁵ random configurations, 0 violations, tightest ratio 0.5. **Both branches now carry the same constant, so a future slip that makes them differ is itself a signal.**

**One finding from the second reading: §6.8(ii)'s window constant sat at a degenerate boundary.** The claim was that a floor gives (SP) with **c = δ₀/2 exactly**, argued by "if some window held none, every n in its upper part would fail (b)." But an n fails only if its whole r-range [δ₀(n−1)/2, n] lies inside the empty window [δ₀x/2, x], which needs n ≤ x *and* n ≥ x + 1 — no such n exists, so at the endpoint the emptiness implies nothing and the claim was unproved at its own constant. For any **c < δ₀/2** the failing n fill [2cx/δ₀, x], a positive proportion, and branch (a)'s O(x/log x) integers cannot cover it. Fixed in `aod` §6.8(ii) and in `ep` F.4's gaps aside (Λ > 2/δ₀ strictly). **This is the class of defect T8 exists to catch** — an endpoint where a constant is quoted exactly and the argument needs one side open — and it is the third such in this framework after the F.1/E′ offset and the D2′ closed-form tie.

**Rerunnable as `converse_check.py`** (`--delta0` to test one global floor rather than each row's own density, `--frontier` to pin the contiguous cut, `--all-rows` to include the worklist), and **in R1's command list**, because these checks read the **witness column** and the rebuild rewrites witnesses — composite-F fusions change which rows are one-part, and raised rows change δ. **⟦PENDING-REBUILD⟧ The figures in `ep` F.4 and `aod` §6.7 are v4-era and are owed a requote from `mu_table_safe_v5_code_v3.csv` when it completes.** Reference points meanwhile: v4 gives 0 violations over 1,409 foreign primes and 777 one-part winners, max cofactor 12, slack 3.6; the **v5 partial frontier (n ≤ 1546) also gives 0 violations**, max cofactor still **12** at the same witness (n = 221, r = 157, Q = 13), slack 2.9. So the corrected shape space has not disturbed the inequalities or the headline constant on the range rebuilt so far — but the counts and the floor will both move, and slack moves with the floor rather than with any finding. Negative control: `--delta0 0.35` gives 796 violations and exit 1. The frontier is detected as the first gap wider than 10, reproducing the documented 2,186 rows; a looser threshold silently swallows worklist rows, which is how the detection was found to be wrong.

**What the measurements do and do not support.** All three inequalities hold at every contiguous row with zero violations, and two independent constraints bind simultaneously at n = 2594 — genuine corroboration that the bounds are tight rather than merely true. But the measurements test the *inequalities*, not the *derivation*: a wrong constant or an unjustified layer assignment would produce inequalities that still hold on the table, since the table's winners satisfy the true statement whatever the proof says. **The measured maximum cofactor of 12 is the strongest single datum here** — it matches (BCG)'s own constant from the opposite direction — and it is also the reason to suspect F.4's D = 44 is loose by ~4, which is the sharpening question the gap inventory records.

### T5a. Re-derive `three-part-family-split.md` §1.2's competing-rates argument on every revision

*Treat any version of it, including the one on file, as provisional: the argument produces plausible pictures that are partly wrong.*

The claim is that the odd-n win shares within the three-part family tend to **1 : 1 : 2**. It rests not on the singular-series computation but on a second step — that the *argmax* over c-classes lands in a class with probability equal to that class's share of the pool — which is an extreme-value claim, not a counting one, decided by which of several competing effects is largest. **Re-derive rather than read.**

- **The analysis is robust to changes in the ceiling table; any *share* summary built on it is not.** The congruences concern which c mod 8 the three-part argmax sits at and are untouched by a two-part shape obeying 4c ≡ 4 rather than 2c ≡ 6 (mod 8). What breaks is the conversion to shares of n, which silently assumes the family attains the class ceiling — a change there can move S4's absolute share to 0 without altering one congruence.
- **Check the tables, not just the prose.** A caveat at the head of the note is not enough; a reader reaches a table before any head-note applies to anything concrete.

*Why the note sits outside `arithmetic-of-density.md`:* its conclusions are about runners-up. S4 wins at no residue asymptotically, and where the family does win the answer is congruence-forced, so the 1 : 1 : 2 split governs which shape is *second*. That is wanted for `aod` §7's disjunction-collapse, which needs the gap to the next shape down, and not wanted in the main line.

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

### A21. A fusion-aware penalty for the partition-factor table

*The table itself now lives in `shape-counting.md` §4; this is the live remainder.*

The all-shapes **penalised** column (`shape-counting.md` §4) is a **lower bound**, not an exact count. Its penalty `x ≥ √(δ₀F)·(1 + 1/p)` comes from the density ceiling, which prices the smaller class at C(c′,2) — the *unfused* reading — so it is too harsh on a shape whose smaller class is fused, by exactly the factor fusion supplies. `n = 640 = 1·256 + 3·128` is the witness: penalised cost 4.10 against L = 3, rejected, yet a real configuration at δ = 0.1192.

**What to do:** derive the penalty for the fused reading (the smaller class is worth F′·C(c′,2), so the requirement should scale with √F′ rather than being charged per size-group), and recount the three all-shapes entries. Expect them to rise, staying between the current penalised figures and the unpenalised 34 / 115 / 357.

**Priority: low.** The top row is unaffected — a fused unequal shape needs n to be a sum of two distinct p-power multiples, a density-zero condition that puts it among §6.5's escapes rather than in the covering accounting — and §6.6's covering statement quotes N_add, which is counted directly and never uses this table. So the exposure is to a commentary figure, and `shape-counting.md` §4 states the direction of the error.

### A22. `validate_table_v3.py`'s group-A expectation is scoped to the current table

The R1 reference point reads *0 FAIL*, which holds for an enumerator output under the current scoring. Run against a **baseline** it does not: a row whose recorded winner is a cyclic-fused class scored under the superseded cut twist re-derives *higher* from its own witness, so group A's re-derivation check fires. On the v4 baseline that is **18 rows of 2,186** — a subset of the 289 known-low rows, the other ~271 being exceeded by a different configuration rather than by a rescoring of their own witness, and so invisible to a check that re-derives from the recorded witness. **Neither number is a defect**; the pairing of them is the thing to state, since 289 and 18 look like they should match and do not. Either scope the expectation in R1's banner or have the check name the baseline case when `--baseline` is supplied.

### A23. `sp-to-floor.md` §7's end-to-end run needs rerunning at the corrected orbital

The run scored foreign intra orbitals at `rQ/2` where every `d` in its grid is even and `Q` is therefore an **odd** prime, so the true orbital is `rQ` (§2, corrected). Both sides of its comparison moved together, so the structural conclusion — zero exceptional n among 400,000 consecutive values, realized δ within a predictable margin of ideal — survives; the numbers do not. **Expected on rerun:** class 11 realizing ≈ 0.066 against the ideal 0.0718, in place of 0.04655 against 0.05051. The §3 grid search wants the same treatment. Tagged ⟦PENDING-RERUN⟧ in the note; not fabricated here.

### A24. Is the shape space complete?

The ceiling table is a theorem about the Oliver-admissible family **as currently characterized**, and the entangled-generator correction showed that characterization can be wrong in the permissive direction — a whole family was excluded by an argument that confused a quotient for a subgroup. **Nobody has searched for the optimal admissible family**, in this project or in the literature: BBKN had no reason to, since below the endpoint any admissible family gives the same order (`literature-findings.md` §15b). So the literature's silence is evidence neither for nor against the entangled construction's optimality, and this is the one place a further constant factor could still be hiding. No cheap test is known; the honest status is that the ceiling is a ceiling *over what we have enumerated*.

### A25. The transference route from (SP) to a floor

`sp-to-floor.md` §6.2 files it: S_D under (SP) has positive relative density inside the Selberg majorant for the pair `{Q, dQ+1}`, whose pseudorandomness is sieve-provable, and a restriction/transference estimate for `n = kp + r` against that majorant would give the representation for almost all n with **no distributional hypothesis on S_D at all**. §6.1's counterexample marks the boundary any such argument must respect — the count alone is provably insufficient — so a successful transference must consume the unconditional sieve upper bounds. A research question, not an afternoon; filed here because it is otherwise homeless outside a one-pass working note.

### A26. The note and the bridge are *more* stale after the (AL)/(AA) split, not less

`mu-theta-n2-note.md` remains **correct on its own terms** — its family is the unfused one, its window is deliberately generous, its constant crude by design — and nothing here touches its Theorem. What changed around it: its hypothesis is now **(BCG_{1/5})**, and its relation to the framework's is **non-nesting in both directions**, not "a weaker form of the same thing". (BCG-AL) hands over an `F = 4` configuration at n ≡ 11 (mod 12) with `c/n ≈ 0.134`, which the note's `c ≥ n/5` rejects; the note in turn is far weaker in constant and restricted to `n = c + r` and `n = 2c + r`. `note-to-framework-bridge.md` §4 now says this. **Before any circulation:** re-read the note's §5 θ-ladder against `aod` §3.6's current attributions, and decide whether the note should mention the F = 4 shape at all or stay deliberately silent about it.

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

1. **Sync.** The Lean statements encode claims from these documents — ceiling values, coefficient rules, threshold ladders, the `orb` definition. When a document changes, the Lean can quietly stop matching it, and nothing in this repository's checks looks at `.lean` files. Any revision to §3.3.5's table, to the cap algebra, to `orb`, or to the E′ s-bound should be followed by a pass over `ArkCore.lean`, `Note.lean` and `Basic.lean`. The ceiling table is the sharpest case: the entries are enumerated one per constant, so a table that gains or loses a constant leaves a list of the wrong length — which is useful only if someone looks.

2. **Progress. Phase 0 is complete.** Status is per file, and the distinction that matters is the sorry count rather than the compile — a sketch full of sorries compiles perfectly happily:

   | file | compiles | sorries |
   |---|---|---|
   | `ArkCore.lean` | laptop **and** container (core 4.15.0, no Mathlib) | **0 — every proof complete** |
   | `Note.lean` | laptop | **0 — every proof complete**, six by import from `ArkCore` |
   | `Basic.lean` | laptop | nonzero — the remaining sketch, phase 1 |

   Between the first two the note's whole arithmetic layer is proved; what stays conditional is (BCG-AL) and Oliver, neither formalisable. **Next Lean work is phase 1: `Basic.lean`'s sorries**, where the mod-12 ceiling table and cap algebra live — and its statements carry the ladder correction while its proofs have never been attempted, so nothing there has been pre-checked by a compiler.

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

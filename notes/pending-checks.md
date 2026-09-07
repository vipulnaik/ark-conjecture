# Pending checks

*The work list for the arithmetic programme (`orbital-evasiveness-notes.md` §§1–6, `enumeration-proof.md`, `arithmetic-of-density.md`). **Outstanding work only.** This file exists to make a run runnable: the command, the input, the expected shape of the output, and the traps specific to that run. It is not a summary of results, an argument, or a history — those live in the documents, in `verification-lessons.md`, and in the session logs, and duplicating them here is how this file went stale before.*

## The two tables

| file | producer | reach | rows | what it is |
|---|---|---|---|---|
| `mu_table_ladder.csv` | `mu_ladder_exact.py` | **10⁶ — complete** | 921,265 | exact B(n), certified above C(n,2)/25 by Theorem E.5 + `ladder-completeness.md` Prop 1 |
| `mu_table_exact.csv` | `mu_exact.py` | 76,752 (ongoing) | 69,107 | exhaustive search — the arbiter |

Both contiguous, no worklist tail, **0 uncertified rows**, minimum **175813/3804661 = 0.046210 at n = 2759** (the only other value below 0.05 anywhere is 0.048039 at n = 2183). Since every row clears 1/25, **Corollary E.6 makes each value μ(n), not a bound on it** — so μ is known exactly at every composite non-prime-power n ≤ 10⁶.

## Five standing rules

1. **A rebuild must never lower a value.** Group A's monotonicity check against `--baseline` is the signature to read on every batch; the value-agreement check beside it gives equal/higher/lower and the tie count.
2. **Never read the `density` column.** It is rounded to six places and the margins are tighter than that — see **A20b**, which cost two spurious FAILs in one script and 991 in another. Compute δ = B/C.
3. **A screen must state its coverage before its verdict**, and the coverage must come from the table rather than a constant — see **A20c**. Two scripts silently screened 2,186 of 921,265 rows while printing a pass.
4. **Append the old maximum to `check_doc_figures.py`'s `CHECKPOINTS`** on every extension, or every correctly-scoped historical figure becomes noise in PASS 1.
5. **Requote what the extension moves**, per the tag scheme in **R0c**. The floor, its argmin, and small-n first instances do not move; distributions do.

**Status labels.** *Verified* — an independent computation agreed. *Sound* — an argument was read and found correct. *Unverified* — neither.

**Companion files.** `verification-lessons.md` — the failure-mode taxonomy and the reasoning behind these checks. `fusion-count-ceilings.md` — ⟦ARCHIVED⟧. `shape-counting.md` — the enumeration behind `aod` §6.

*Do not restate the inequality as `B_safe ≤ μ`.* `B_safe` over-counts per configuration; what holds is B_refined ≤ μ ≤ B_safe, the endpoints collapsing where E.5 or the certificate applies.

## Before the pause: the landing checklist

*Everything in this list is small, and each item names the exact edit it produces, so none of it needs a fresh decision. When all four are done the documents are current to 10⁶ on every measured figure and nothing is pending on a run.*

1. **When `mu_exact.py` reaches 10⁵:** run `validate_table_v3.py mu_table_exact.csv --baseline mu_table_ladder.csv`. Expected: 25 PASS / 0 FAIL, and the value-agreement line reading `ALL equal, 0 higher, 0 lower` over all ~90k common n. Then one edit, in three places — the status banner's second sentence in `aod`, `ep` and `notes` ("contiguous to n = 76,752 (69,107 rows) and still running toward 10⁵" → the final reach and row count, "confirmed by exhaustive search to 10⁵"), and the "two tables" row above. Nothing else moves: every measured figure keys on the ladder table, which is already complete, and every requoted site already reads [6, 10⁶].
2. **The solvable side is now split, so this is a one-off cost rather than a per-question one.** `solvable_table.py` computes B_solv(n) and writes a CSV; `solvable_relaxation.py` asks the twenty-two questions and takes `--solvable-table PATH` to skip the scan. **Measured at N = 22,591: 6.03 s → 0.45 s, identical verdicts.** So run the table once at 10⁶ (~3 h, resumable, chunkable eight ways to ~25 min) and every later question is seconds:

   ```bash
   python3 solvable_table.py --nmax 1000000 --out solvable_table.csv
   python3 solvable_relaxation.py mu_table_ladder.csv --solvable-table solvable_table.csv
   ```

   The writer mirrors `mu_exact.py`'s driver exactly — resume by reissuing the same command, `--chunks i/N`, work-weighted heartbeat and ETA — and the scoring core lives in `solvable_table.py` alone, imported by the validator, so the two cannot drift. **A loaded table is spot-checked against a fresh recomputation** at the extremes, the single-orbit rows and a random sample (210 values at 22k), and the run refuses outright if the cache does not cover the mu table's range. *Verified: corrupting the n = 551 row makes the check FAIL and name the row.*
   **Then requote:** requote the five figures its output prints — equality share, class-11 count, ratio distribution (median / even / odd / max), the multiplier census, the two extreme values — into `solvable-relaxation.md` §§1, 3.5, 4 and the header. The header already carries the tag and names the five. Expect the equality share to fall further from 23.5% (it tracks S2's win share, now 13.5%) and the odd/even ratio gap to widen.
3. **The three unreached GAP battery rows** (n = 78, 33, 105): run the battery to completion once, or record that they were skipped. R8 says which they are and why they matter.
4. **`wide_cert.py` is rescoped, not owed** (see R1b): B is known exactly to 10⁶, so a certificate "beyond the table" has no range to certify below 10⁶. It would matter again only for an extension past 10⁶.

*Not on this list, deliberately:* `audit_fmid.py` at the full range (a scaling note, A20c; the 20k-row slice is clean and the screen is about low-density rows, which are dense at small n); `a18_verify.py`'s slow table scan (its witness checks pass; the scan is range-scoped domination that E.5 now covers above 1/25); the `stage4_fast.py` seeds (they produce no verdict without UNSAT, and the backtrack ceiling is what to read if they are left running). None of these gates anything, and none should be a nagging worry.

## What is still owed

*Everything else in this file is a re-run triggered by an extension, or an item under §2. Nothing below is owed as a run today.*

| owed | kind | item |
|---|---|---|
| `wide_cert.py 100000`, both modes | rerun — the last complete run predates the fused rung's addition to B_lo | R1 |
| Part E realisability by GAP for the two remaining shapes | build | R8 |
| the n = 5 chiral Smith form | compute | R10 |
| six items needing a human reading | judgement | §2a |

## The gap inventory

*The daylight between what `enumeration-proof.md` proves and what it verifies. Six items; the document's Part J carries the full statement of each and this is the index.*

1. **Part 0 completeness** — a shape missing from the space fails silently. Three independent tests could see one; none has.
2. **The two-part reduction of Theorem 2.3** — verified to n = 1200, Goldbach-tier to prove. Nothing rests on it but B₀'s O(n) cost claim.
3. **Minimality k ≤ 3 below δ = 1/16** — free above 1/16 by F.3; any proof is arithmetic and must *produce* a configuration.
4. **The collapse's theorem-side residue** — **narrowed to δ ≤ 1/25 only**, by Theorem E.5. No row of either table is in that regime, so this is now a statement about hypothetical n rather than about the tables.
5. **J0a's non-semilinear stabilisers** — discharged for every computed value; one theorem-side clause remains.
6. **Lemma B′** — proved, and read three times independently, the third in 2026-09 with no prior exposure.

## Where the residual risk sits

*Ranked. The taxonomy behind the ranking is `verification-lessons.md`.*

1. **Exhaustiveness of the GAP stages** — the only non-circular check in the framework. Closed at degrees 10 and 12 by the TOM stage; the subdirect-product hole remains at other degrees. → `small-degree-verification.md`
2. **Part E's realisability** — the battery's last run covered **7 of its 10 rows**, all passing, largest n = 308; the three entangled-generator regressions were not reached, and n = 2759 and any even F ≥ 4 are unbuilt. → **R8**
3. **§3.3.5's ceilings** — exposure is the shared supply hypothesis. → **T6**
4. **Proposition F.4's reliance on Lemma B′** — branch (b) is vacuous unless a foreign twist is a prime power. → **T8**
5. **The κ parameters at k = 3** — no risk to k = 2. → **T7**
6. **The eight necessary conditions of `fb_common.py`** — demoted: with E.5 in hand an error in them can no longer invalidate the collapse above 1/25, though it still gates the certificates. → **T3**

> **One class has left this list entirely.** The arithmetic layer — inequalities, cap algebra, threshold ladders, the six ceiling constants — is now checked by script on every run, and the caps are *attained to the resolution the integers allow* in all twelve residue classes (A20b). Errors there would be caught, not reasoned about.

---

# §1. Script runs

*Can be launched in the background. Flags are checked against the scripts as they stand; where a run needs code that does not exist, that is said rather than papered over with a plausible-looking flag.*

> **Numbered in order, and not every entry is a live run.** **R0, R0c, R1, R6, R6a, R8, R10, R12b** are things to do; **R1b, R7, R12, R12a** are retained because a reader meeting a reference to them elsewhere needs to find out what happened — R7 superseded, R12a a tool with its result recorded, R1b and R12 explaining a scope that is easy to get wrong. **An item whose findings are fully written into the documents becomes a one-line row in the ledger below instead** — that is where R11 and A31 went once §4b of `approach-rate-note.md` and §5 of `aod` carried their content.

## R0. The two producers: how to run them, and what they cost

`mu_enumerate_v3.py` is the reference implementation and stays the arbiter. **`mu_exact.py`** enumerates the same shape space with the same SAFE score by arithmetic rather than generic search. **`mu_ladder_exact.py`** scores the ladder menu plus S6/S11 exactly and, above C(n,2)/25, equals B(n) *by theorem* (E.5 + `ladder-completeness.md` Prop 1) with a witness; below that line it is a lower bound and `mu_exact.py` is still needed.

**Extending either table.** Both share one driver: same CSV schema, resume by reissuing the identical command (a partial final row is truncated, not spliced over), `--progress` heartbeat to stderr with rows / percent-of-work / rate / ETA, and `--chunks i/N` splitting for equal work.

```bash
# extend the exact table (the arbiter; slow)
python3 mu_exact.py --nmax 200000 --out mu_table_exact.csv
for i in $(seq 1 8); do python3 mu_exact.py --nmax 200000 --out mu.csv --chunks $i/8 & done

# extend the ladder-exact table (fast; certified above 1/25)
python3 mu_ladder_exact.py --nmax 2000000 --out mu_table_ladder.csv
for i in $(seq 1 8); do python3 mu_ladder_exact.py --nmax 2000000 --out mu.csv --chunks $i/8 & done

# merge chunked output
head -1 mu.csv.part1 > mu.csv && for i in $(seq 1 8); do tail -n +2 mu.csv.part$i; done >> mu.csv

# spot checks that need no table
python3 mu_ladder_exact.py --check mu_table_exact.csv --time   # must print 0 low, 0 high
python3 mu_ladder_exact.py 100000 100500                       # quick lookup to stdout
python3 mu_ladder_exact.py 2755 2762 --cert-threshold 0.05     # exercises the uncertified path at n = 2759
```

*Chunking splits at nmax·(j/N)^{1/2} for the ladder and ^{2/5} for `mu_exact.py`, because cost per n is ~linear in the first and ~n^{1.5} in the second. Do not copy one exponent to the other.*

**Cost, measured.** `mu_exact.py` scales as ~n^2.3 with a tail nearer n^2.9 per row — about 3 h *per value* at 10⁶. `mu_ladder_exact.py` is **4.3 ms/n at 2.5·10⁵ and 15 ms/n at 10⁶**, so a contiguous run to 10⁶ is ~3 h single-threaded and under half an hour on eight chunks. *Quote per-value cost by density band, not one aggregate rate: a δ < 0.10 value costs about twice a δ ≥ 0.22 one, so an n/s figure weights the hard values and understates any speedup.*

**Two columns mean different things by producer, and the difference is the point.** `certified` = 1 means F.1's k self-certification from `mu_exact.py`, but E.5 + Proposition 1 from `mu_ladder_exact.py` — there a 0 means the row fell below 1/25, where every pruning step is unjustified and the value is a lower bound. `fallback` = 1 only on a row that went through the exhaustive handoff and whose optimum is a fallback: the only rows where μ(n) = B(n) is not established by any theorem.

> **What `mu_ladder_exact.py` does when a row does not clear 1/25 — the case that matters most.** Such an n would also be the first counterexample to the floor conjecture, so the script does not merely flag it: it hands the n to `mu_exact.py`'s exhaustive `best_for_n` (imported from the same directory; `--on-uncertified flag` to suppress), prints both values and whether the exhaustive optimum is a fallback configuration — in which case `fallback_cert.py` is the next step — and writes `EXHAUSTIVE` or `EXHAUSTIVE-FALLBACK` into the witness. `--check` lists uncertified rows separately whatever the value comparison says, because agreement at such a row is a coincidence, not a certification.

> **A witness may differ between the two producers on a tie** — at n = 423 one records `1x256 + 1x167*` and the other `2x128 + 1x167*`, both scoring 13861. **Compare values, not witnesses**; `validate_table_v3.py`'s value-agreement check counts the ties for exactly this reason.

> **The validation any replacement must meet**, done once for `mu_exact.py`: every row of the then-current table reproduced exactly with low (missing shape) and high (over-score) mismatches reported separately, both zero; cross-checks against `v3.mu_bound` at n never previously computed; and an **independent spec-derived enumerator**, written from the shape-space description rather than from either script, agreeing on 139 values for 6 ≤ n ≤ 200 — the only check that would catch a case dropped by *both*.

> **A cost correction worth keeping.** An early estimate of `mu_exact.py` fitted only n ≤ 8,000 and was wrong by an order of magnitude in the tail. Re-time when the range changes rather than extrapolating a fitted exponent. **Not to be confused with `mu_fast.py`**, a pre-shape-space family menu that is superseded and should not be run.

## R0c. The three pending tags, and what clears each

*One tag for three different pending things was the confusion; they are now separate and each is named for the thing that clears it.*

| tag | what it marks | cleared by | affected by the in-flight runs? |
|---|---|---|---|
| **⟦REQUOTE-ON-EXTENSION⟧** | a table measurement — winner counts, shares, low-density tails, first instances | requoting from the table; `check_doc_figures.py` recomputes most of them and `validate_table_v3.py`'s INFO lines print the rest | **yes** — these are exactly what the two runs move |
| **⟦PENDING-CERT-RUN⟧** | an output of a certificate or shape script (`wide_cert.py`, `fallback_cert.py`, `shape_realize.py`) — coverage counts, shape-scan totals | rerunning that script | **no** — extending the tables does not touch these |
| **⟦NEEDS-ITS-OWN-RUN⟧** | the orbital-count distribution, which no script produces because t is not a CSV column | a bespoke run (see `notes` §9.7 for the formula) | **no** |

*A fourth tag, ⟦PENDING-1E5-EXACT-RUN⟧, was retired earlier and its notice has been folded away; the range convention it enforced is now invariant I7's job. Nothing should reintroduce it.*

**So the answer to "what are these pending on" is: only the first kind is pending on the current runs.** Nine sites were of that kind while the banner claimed all of them were script outputs, which is what made the tag unreadable. Untagged measured figures are not exempt from range discipline — they name their range under invariant I7 — and structural claims, closed forms, ceilings and theorems were never in scope for any tag.

**When the two runs land:** rerun `check_doc_figures.py <table> *.md`, requote every ⟦REQUOTE-ON-EXTENSION⟧ site, and rerun `solvable_relaxation.py <table>`. The certificate and own-run tags stay put.

> **`CHECKPOINTS` is already primed.** 36848, 55814, 71288 and 159027 have been added, so a figure correctly scoped to any of those frontiers is reported as *matching an old checkpoint* — a historical citation to leave alone — rather than as unexplained staleness. Add the new maxima on the next extension too; it takes a minute and skipping it turns every correctly-scoped historical figure into noise in PASS 1. Expect the old-checkpoint counts to be large and mostly benign: 16 in `aod` on the current run, which is what a document with a long recorded history should look like.

## R1. Routine, after any new batch of table values

**Current status: the battery has been run against the completed 10⁶ table and passes.** `validate_table_v3.py` 27 PASS / 0 FAIL / 16 INFO with the exhaustive table as baseline, all μ equal on the overlap. `t5_verify.py`, `converse_check.py`, `audit_fmid.py`, `check_doc_figures.py` clean. `fallback_cert.py` and `wide_cert.py` are rescoped — see **R1b**. `solvable_relaxation.py` owed a recount at 10⁶.

Run in order; the first gates the rest.

```bash
TABLE=<current enumerator output>
BASE=<previous table>

python3 validate_table_v3.py $TABLE --baseline $BASE   # 1. gates everything
python3 fallback_cert.py $TABLE --verbose              # 2. per-n collapse certificate,
python3 fallback_cert.py $TABLE --no-theorems          #    ON A SLICE ONLY -- see R1b
python3 wide_cert.py 100000                            # 3. the certificate beyond the table
python3 a18_verify.py $TABLE                           # 4. range-scoped dominations
python3 t5_verify.py $TABLE                            #    (D2 and Corollary C')
python3 converse_check.py $TABLE                       # 5. Proposition F.4's inequalities
python3 audit_fmid.py $TABLE                           # 6. shared-block-count screen
python3 solvable_relaxation.py $TABLE                  # 7. the solvable relaxation
python3 check_doc_figures.py $TABLE *.md               # 8. documents against the table
```

**What to read off each.**

- **`validate_table_v3.py`** — **Group A** FAIL: the run or parser is broken and nothing downstream is meaningful. **Group B** FAIL: a real contradiction between table and documents. **Group C** is INFO, each line printing the expected asymptotic beside the measurement. `--explain N` for one row's terms; `--baseline` for the value-agreement and shape-migration reporting. Groups described at **A0b**. *Expect FAILs when pointed at a **baseline** as the table: group A's re-derivation check fires on rows scored under an old cap. That is the correct reading, not a defect.*
- **`fallback_cert.py`** — headline is *0 candidates*. Then read the **density floor**, the **largest permitted s** and the **theorem residue** off the run: they move together (s ≤ 1/√δ − 1), and **s = 4 is the first branch no theorem covers**, so if `largest permitted s` prints 4, `enumeration-proof.md`'s Corollary after E.3 and Part I's tail figures want re-deriving. `--no-theorems` should agree exactly — but check the dispatch is firing, or the agreement is vacuous.
- **`wide_cert.py`** — read `settled by theorem:`. At NMAX ≤ 10⁴ it prints NONE and a `--no-theorems` comparison there is no evidence. `--menu` cross-checks pass 1; `--refresh` rebuilds the cached B_lo.
- **`a18_verify.py`** — Lemma D2's witnesses plus its **range-scoped** fused-outside domination, which a table extension can invalidate silently.
- **`t5_verify.py`** — Lemma C's coupling and Corollary C′. Its pass 4 and its threshold now read the range and the floor **from the table**; both were hardcoded (A20c).
- **`converse_check.py`** — headline is *0 violations*, but the run is for the two constants. **Max cofactor** is quoted in `ep` F.4 and `aod` §6.7 as **12**, matching (BCG)'s own d ≤ 12; a value above 12 would weaken the claim that (BCG)'s constant is natural rather than chosen. **Slack** is max-cofactor against 2/floor, so it moves whenever the **floor** moves and is **range-dependent on a correct table** — requote it with its range and do not read a change in it as a finding.
- **`audit_fmid.py`** — headline is *0 shared-F_mid configurations above B(n)*, but **read the coverage line first**. It screens only the low-density rows, which is a scope statement rather than a shortfall. It is the only artefact behind the shape space's shared-block-count admission, so a hit is a configuration to score exactly, not a reason to tighten the admission.
- **`solvable_relaxation.py`** — all PASS; B_solv ≥ B_safe is structural, so a FAIL means the Oliver side credits a class no solvable group carries. Two INFO lines look alarming without their reason: the **class-11 share** exceeding 7 − 4√3 is expected (the ceilings bound the balanced additive family, not μ), and the **attainment share** is the S2 identity showing through. Requote both, and the ratio distribution, from the run.
- **`check_doc_figures.py`** — `--quiet` for findings only, `--pass {figures,scope,prose,hygiene,census,refs,tables}` for one pass. **Pass every `.md` that might be cited**, or `refs` reports live citations as dangling.

**Static — one run per environment, not per batch.** `eta_derive.py`, `khomog_verify.py`, `a18_rq_verify.py`, `k3_galois.py`, `shape_realize.py` and `ceiling_rederive.py` — the last two read no table at all and are sized for small n by design (**R6**, **R6a**).

**Deliberately absent.** `ladder_verify.py` never reads the table and is retired (R7). `s7_scan.py` and `mu_fast.py` are not in the working set; group B covers what `s7_scan.py` would test. The Lean statements are read by no check here — see **A9**.

## R1b. The certificate steps of R1 do not scale to 10⁶ — and no longer need to

**Measured:** `fallback_cert.py` runs in 3.2 s on 1,000 rows, 24.3 s on 3,000 and 196 s on 9,000 — about n^1.9 — which extrapolates to **roughly 15 days** on the 921,265-row table. It cannot be run there as written.

**It also has nothing left to decide there.** The certificate answers, per n, "could any fallback configuration reach B(n)?" **Theorem E.5 answers it for every n at once above C(n,2)/25**, and **0 of the 921,265 rows are at or below that line** (the minimum is 0.046210). So the per-n certificate is redundant on the whole table, exactly as Corollary E.6 intends: the certificate was the tool for the regime the theorem now covers.

> **So R1's certificate steps are rescoped rather than dropped.** Run `fallback_cert.py` and `wide_cert.py` on a **slice** — the first few thousand rows, where they are seconds and still exercise every branch — as a check on the *code*, not on the table; the table itself is covered by E.5. Verdict on the [6, 3531] slice, rerun now: **0 values where some fallback configuration could reach B(n)**, 88.8% settled by theorem alone, s ≤ 3 over the range, and the foreign-part regime split 91.7% e = 1 / 7.5% e ≥ 2 / 0.8% q = 2. *If a future extension ever produces a row below 1/25, that row — and only that row — needs the certificate, and it will be one n rather than a million.*

**Still to run when convenient** (they are unaffected by this and were not reached): `a18_verify.py` on the full table (its own witness checks all pass; the table-scanning part is slow), `solvable_relaxation.py`, `t5_verify.py`, `audit_fmid.py`, `shape_realize.py`, `ceiling_rederive.py`. None of them gates anything the completed run establishes.

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

## R7. ~~Consume the ladder worklist with the adaptive branch-and-bound~~ — SUPERSEDED

**The worklist route is retired, and `ladder_verify.py` with it, at any range we intend to reach.** Its purpose was to find the n where B might fall below the floor without computing B everywhere; `mu_ladder_exact.py` now computes B **exactly** at 15 ms/n, so there is nothing for a lower-bound-and-prune loop to save. The 44,091-entry worklist, the `--floor … --adaptive` consumption, the `--resume` sidecar and the clamped-scan discipline are all history.

> **What survives, and it is the result rather than the method:**
>
> > **min { μ(n)/C(n,2) : n ≤ 10⁶, composite, not a prime power } = 175813/3804661 = 0.046209898…, attained only at n = 2759**
>
> — now with the stronger provenance that the contiguous exact table *contains* the argmin rather than reaching it by a worklist row, and no entry anywhere below 1/25. The ladder gives μ ≥ this unconditionally (it exhibits groups); B gives μ ≤ this granting μ ≤ B_safe; above 1/25 Corollary E.6 closes the gap outright.

**When `ladder_verify.py` would become useful again:** only far beyond 10⁶, where a lower-bound-only scan is meaningfully cheaper per value than computing B. At 15 ms/n for exact B that crossover is not near, and until it is, running the ladder alone buys a weaker statement for no saving. *If it is ever revived, the two defects found in it must be carried over: the block-size window must be `[0.10, 0.85]`, not `[0.10, 0.55]` (the narrow one clipped the two-part family at 274 tabulated n, understating by up to 1.8×), and the fusion set must be 3..16 ∪ {25}, not 3..12 ∪ {16, 25} (cap_F(1) crosses 1/25 between F = 16 and 17).*

## R8. The Part E realisability battery — the only leg of μ = B with no per-n check

**What a pass settles:** that the enumeration's score at that n is *attained*, i.e. μ(n) ≥ B(n). Not completeness. This is the only artefact that builds a group; everything else re-derives a value.

```bash
gap -q -A -o 8g verify_witness.g                            # the battery
ARK_WITNESS_FTOP_SPLIT=1 gap -q -A -o 8g verify_witness.g   # the control: must ABORT at n = 78
WITNESS="p=5 q=2: 2x5" MUBOUND=20 gap -q -A verify_witness.g   # a single row
```

**Read the control first.** It restores the pre-entangled split (part of the block rotation in the top layer) and must still reproduce the `G/G1` normality abort at n = 78. **If the control ever passes, the fix has stopped doing what it claims and a green run of the default path means nothing.**

> **Last run: 7 of the battery's 10 rows, all `VERDICT: true`** — n = 10, 12, 15, 26, 35, 247, 308, chains verified and orbital multisets matching the prediction at each. **The three rows not reached are the entangled-generator regressions** (n = 78 `6x13`, n = 33 `2x13 + 1x7*`, n = 105 `2x29 + 1x47*`), which are precisely the rows that exist to fail if a twist cut by the block count is ever reintroduced. *A run that stops before them is a run of the battery without its regressions.* Rerun to the end, or say which three were skipped whenever the result is quoted.

**Four of the ten rows score a configuration that is not the winner at its n** — n = 26 (36 against B = 156), n = 35 (105 against 120), n = 247 (2525 against 3280 at `4x41 + 1x83*`), n = 308 (4134 against 5671. That is deliberate: the row checks realisability of the configuration, not optimality of the value, and the comment in `BATTERY` says so at each. *The n = 247 row is the standing example of the battery working: its expectation was 1314, a pre-correction value with the matching twist cut from 72 to 18, and the assertion fired in the direction that matters — the old expectation under-scored.*

**Coverage: ten rows, largest n = 308**, spanning the fused rung at F = 2, 3, 5, 6, a trivial-top attainer, cyclic-layer fusion beside a foreign block, Lemma C's worked example, and the three regressions. **What is still uncovered, in priority order:**

1. **n = 2759** — the range minimiser, and the one n where the framework claims μ *exactly* rather than boundedly. Its binding class is the **foreign** one at r·Q with Q = 11², a proper prime power: a stratum no current row reaches, every other foreign row here having prime Q.
2. **Even F ≥ 4** — the cross-class coefficient is (F/2)·c² rather than F·c², and F = 4 is the fusion count that sets the ceiling at n ≡ 11 (mod 12). The battery has F = 6 but no F = 4.
3. **A two-part row from the current census**, since most rows are configurations that no longer win at their n.

**The scaling limit, which is what blocks (1).** `OrbitalSizes` materialises `Combinations([1..n], 2)` — 690k entries at n = 1175, 3.4M at n = 2600. Port it to union-find and keep the chain and multiset checks where they are. **Do not drop the chain check to buy speed**; it is what distinguishes this from a re-derivation of the value formula.

> **`-A` is belt and braces, not a requirement.** The script once defined a global named `Orb`, which the autoloaded `orb` package owns and makes read-only, so without `-A` it aborted with `Variable: 'Orb' is read only` — a message naming a variable rather than this file. That global is now `ArkOrb`, and a **collision guard** at the top checks every global the file defines and, on a clash, names it and says what to do. *Renaming beats requiring the flag*: a script correct only under a start-up option fails exactly for whoever omits it, and the failure does not point at the cause.

## R10. The chiral-half homology — only the n = 5 Smith form remains

*Script: `chiral_mv.py` (`--verify` runs the regression, `--table N` prints the closed forms). The question — whether any chiral half of the Hamiltonian-cycle complex is **ℤ-acyclic**, the lowest rung at which a counterexample could exist — is answered **no**, at every n ≡ 1 (mod 4); see the session log for the closed forms and the argument.*

**What remains.** Only the n = 5 torsion, and only if one wants the Smith form rather than the answer: the connecting map is ℤ⁶ → ℤ⁶ with cokernel (ℤ/2)², elementary divisors (1,1,1,1,2,2). The regression at n = 5, 6, 7 should be re-run after any change to `chiral_mv.py`; it checks the closed forms against direct 𝔽₂ homology and asserts non-negative Betti numbers, which is what catches the boundary-orientation bug described in the script header.

## R12. `mu3_menu.py` — B₃ over the k = 3 census

**New 2026-09, and it closes half of `three-uniform-note.md` §10 item 1.** Scores every shape in that note's §4.2 census at every n in a range and writes `n, C(n3), b3_census, delta3, witness`. Table to n = 2000 in the working set as `b3_census_2000.csv` (1,666 rows, 7 s).

**Read the column name, and know which way the inequality runs.** `b3_census` is the max over the *census* shapes. Two directions, two hypotheses, neither established at k = 3:

- **μ₃ ≥ B₃^census** if every census shape is realisable by an Oliver group (the Part E analogue — no GAP battery exists at k = 3);
- **μ₃ ≤ B₃^census** if the census is complete (§10 item 1, open).

So the useful reading is a **lower** bound on μ₃ modulo realisability. Nothing should read the column as μ₃. What it legitimately replaces is the *hand* searches: §6.2's "optimal" at one n, §6's escape counts, §5's class ceilings.

> **A defect caught on the first run, worth recording because the check that caught it was a question about direction.** The script credited a Galois part of order m without requiring m to be a power of the top prime q — the Frobenius lives in the top layer, which is a q-group. **295 of 306 rows crediting m > 1 had the top prime ≠ 5 while crediting m = 5 on a 32-block.** Fixed; 266 rows fell, all downward, and n = 133 did not move because there q = 5 = m is the coincidence §6.2 exists to display. This is §4.3's warning — "spending the top prime on the Galois gain cripples every foreign block" — made concrete.

**Why it is short where `mu_enumerate_v3.py` is long.** At k = 3 only intra terms bind — proved in three lines by a degree count, cross terms being cubic in n against quadratic intra terms (§4.1) — so a configuration's score is min over classes of F·orb₃(c, d, m) with no term-type comparison. The scoring itself is the proved orbit law with κ₃ = τ·θ·γ, verified on 104 triples.

```bash
python3 mu3_menu.py --check-133          # reproduces §6.2's worked example
python3 mu3_menu.py --nmax 2000 --out b3_census_2000.csv
python3 mu3_menu.py 130 136              # lookup
```

**Verified on writing:** every value in §6.2's table including all seven r-rows; the full-density degrees of §3.1 (5, 8, 32 attain C(c,3), 16 does not — Kantor's classification appearing in the arithmetic); and the n = 133 row reproduces the note's witness `1x32 + 1x101*` at δ₃ = 0.006587.

**What is still owed here** is §10 item 1 proper: a completeness argument for the k = 3 census, whose concrete first step the note names — locating the crossover between the quadratic intra term and the cubic cross terms, which §4.1's degree count makes unlikely to bind but does not exclude at small n.

## R12a. `ceiling_rederive3.py` — the k = 3 ceiling table, measured

The counterpart of `ceiling_rederive.py`, and the reason it was needed: **without a generic-family filter, a sup over any range measures §6's escapes rather than the ceiling** — on `b3_census_2000.csv` the unfiltered class sup exceeds the tabulated ceiling in 11 of 12 classes, by 18× at class 0, and **7 of the 12 sups are attained by a fused S2 shape with no foreign block**.

```bash
python3 ceiling_rederive3.py --nmax 14000        # generic family; exit 0 = no cell exceeded
python3 ceiling_rederive3.py --nmax 2500 --no-filter   # the escapes, deliberately
```

**Result over n ∈ [7000, 14000]: no cell exceeded, and every one of the twelve classes attains its ceiling to within 0.1% in exactly one κ_c column** (2 and 8 in both). That is §5's table converted from derived-and-asserted into measured.

**Two k = 3-specific things a reader should know before comparing it with the k = 2 script.** *κ_c is a split, not a nuisance*: for a prime block at full twist κ_c = 3 when 3 | c − 1 and 2 otherwise, so §5's table has two columns and a scan that pools them compares against neither — results are per (class, κ_c) cell. And *the no-foreign-block cut is structural, not part of the filter*: it stays on under `--no-filter`, because §5's table is about the two-part additive family and a fused-only shape is §6.3's question. The two scripts' `--no-filter` modes therefore scan different shape sets.

**What the run leaves open**, and it is sharper than what it replaced: nine of twenty-four cells fall short, and they are exactly the *other* column at each class. Whether each unreachable column is arithmetically obstructed or merely thin in supply is the open question — at class 0, κ_c = 2 the η = 1 entry needs r − 1 = 2·q^e with q ≥ 5, a supply condition of the safe-prime family rather than an obvious obstruction. A k = 3 analogue of `aod` §3.3.8's escape analysis would settle it.

## R12b. ~~Rerun `ladder-completeness.md`'s two scans at 10⁶~~ — DONE for `offmenu_scan.py`; one half left

**Found in the 2026-09 read-through.** Every measured figure in `ladder-completeness.md` is scoped to the **36,848-row frontier** of its writing and neither scan has been rerun since the exact table completed to 10⁶:

- **`offmenu_scan.py`** — the S6/S11 sweep, currently "over all efficient-prime pairs with a common q up to 36,848 … 729 tabulated n, above 1/25 at 352, maximum density 0.1111 at n = 4376, never reaches B(n)". This is **the empirical half of Proposition 2**, and it is the half that licenses reading a ladder value as B: Proposition 1 says the optimum is a menu shape *or* S6/S11, and the scan is what says the second disjunct is never taken.
- **`ladder_vs_B.py`** — "ladder = B at all 32,861 tabulated values", now 921,265.

**Done 2026-09.** `offmenu_scan.py` at 10⁶: off-menu shapes score at **5,739** tabulated n (was 729), above 1/25 at **5,045** (was 352), **reach B at none**, maximum density **0.1111 still at n = 4376**. So Proposition 2's empirical half holds over twenty-seven times the range with the margin unchanged. Worth noting for a future extension: a near-approach family appears around n ≈ 2.95·10⁵ on the Fermat pair 65537\* + 163841\* at q = 2, reaching **0.70 of B** — the largest ratio anywhere above n = 5000.

**One half left, and it is only a matter of time:** `ladder_vs_B.py` is **~n^1.5**, measured at 4 s / 5,000 rows and 35 s / 20,000, so the full table is about **3 hours**. Run to 120,000 rows here: **ladder = B at 120,000 of 120,000**, 0 short, 0 over (was 32,861).

```bash
python3 ladder_vs_B.py mu_table_ladder.csv        # ~3 h, expect 921,265 of 921,265
```

*Nothing depends on the remaining half* — `mu_ladder_exact.py --check` already agrees with `mu_exact.py` everywhere both run, and this scan checks the weaker four-family ladder rather than the menu. It is a cheap independent confirmation, not a gate.

## Closed, kept as a one-line ledger

*Items retired without residue, so a reader meeting a reference to them elsewhere can tell what happened. Full accounts are in the session logs. Items retired **with** residue keep their section in §1 — R7 and R11 — rather than appearing here twice.*

| item | what it was | outcome |
|---|---|---|
| **R0b** | retire the ⟦PENDING-1E5-EXACT-RUN⟧ tag once a run passed 10⁵ | **done** against the ladder-exact table; all 27 tagged sites requoted, banner replaced, the range convention now enforced by `check_doc_figures.py` invariant I7 |
| **R7a** | rerun `ladder_verify.py` to 10⁶ at the corrected window | **moot** with R7; the two window/fusion-set defects it found are recorded there in case the script is ever revived |
| **R7c** | audit `solvable_relaxation.py` and `k3_galois.py` | **done** — the former had the same O(N²) sweep the validator had (5× on the scan, 3× end to end, 22 checks pass to n = 159,027); the latter's self-test had a range-scoped claim stated as a law and a clause whose only witness (a = 155) sat outside the test range |
| **R11** | recheck `approach-rate-note.md` §4a's falsifiable claim against the completed run | **done** — the offset climbs 0.536 → 0.652 as predicted and the F = 4 share reaches 99.4%; its limit is **ln 2, not 1**, which §4a had wrong. All of it is in that note's new §4b, which is now the only place it needs to be |
| **A31** | `aod` §5's decade tables labelled ladder *bounds* where the section says the minima are exact | **done** — recomputed exactly over the 921,265 rows; the ladder's bounds agree at every decade minimum, so the tables now show δ with the bound beside it and the point is recorded in §5 itself: the ladder is **tight at the decade minimisers** |
| **R7d** | audit `khomog_verify.py` | **done** — one vacuous check (an arithmetic tautology no computation could falsify) replaced, and the {8, 32} finiteness claim swept over every prime power in [6, 63] rather than three spot checks |

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
- **J0a, the stabiliser assumption** (item 5 of the enumeration-proof gap inventory above)**. Discharged for every computed value by the flat cap, and without loss at a fixed twist order by the orbit-counting argument below.** *(The flat cap is the stronger of the two and the one to quote: B_safe credits F·C(c,2) and sᵢsⱼ, both counting bounds on the pair set rather than statements about the group, so μ ≤ B_safe holds whatever the stabiliser is. The argument below is what additionally rules out a non-field stabiliser **at the same order**; a larger-order one is the residue, and it reaches only E.3(i).)* The construction takes a matching block's twist inside the field's multiplicative group, whereas the stabiliser of a primitive affine group of degree p^a may be any irreducible subgroup H ≤ GL(a, p). The worry was that some non-field H realises a block orbital the field cannot. It cannot:

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
- **Which constrains the shape of any proof of (BCG)/(BCP), independently of the density accounting.** Bounded cofactor needs moduli `Q ≍ r/D`, inside Friedlander–Granville's failure window — but the framework never needs a per-modulus asymptotic there (the count of `r ≤ x` in one class mod `Q ≍ r/D` is `O(D)`, bounded, so an asymptotic is meaningless). (BCP) is a count **aggregated over Q**, which irregular moduli do not disturb. **So (BCG) and (BCP) cannot be derived from a level-of-distribution statement of the usual asymptotic form at level ≈ 1, because that statement is false; they must come from a counting or sieve argument tolerant of irregular moduli.**

*Also recorded there:* Baker–Harman's `α = 0.677` (Li: `0.679`, via Maynard's triple convolution estimates) needs moduli of size `r^{0.677}` and therefore exists only because the residue is fixed — so the α in the ladder of `aod` §3.6 is a reading of how far EH(1; θ) has been pushed, not an independent input.

**ANSWERED — the almost-all step survives a thin set; the obstruction is elsewhere.** *(Read against Shparlinski's Theorem 2 in full, `aod` §6.8(iv) rewritten accordingly. The question as filed presumed the machinery was circle-method and density-hungry; it is neither.)*

Theorem 2's engine is **Balog–Sárközy's sumset theorem**, whose hypothesis on the input sets is a **pure cardinality condition** — #𝒜·#ℬ ≥ cN log²N, giving a difference with a prime factor ≫ (#𝒜#ℬ)^{1/2}/log N. Shparlinski plays the exceptional set against the input set and reads off #ℰ ≪ x^{2γ}log²x/#ℛ. Three consequences, each correcting something this item or `aod` §6.8 previously asserted:

- **Thinness costs one logarithm, not the argument.** Baker–Harman input (#ℛ ≫ x/log x) gives x^{2γ−1}log³x; an S_D-type input at relative density 1/log x gives **x^{2γ−1}log⁴x** — still o(x) for every γ < 1. "One logarithm short of what the machinery consumes" was wrong: a cardinality hypothesis divides straight through.
- **No equidistribution clause is needed.** The "consumes distribution in arithmetic progressions, major arcs built from it" reading describes a **circle-method** route, not this one. Balog–Sárközy is sieve-based. The former item's instruction to determine "what equidistribution clause a sufficient version of (BCP) would need" is answerable as: none, for this route.
- **What blocks the floor is the companion exponent, at every input density.** The certified prime factor is capped by (#ℰ#ℛ)^{1/2}/log x ≤ x/(2√2 log x), sub-linear — so γ = 1 is unreachable even with a full-density input. A floor needs min{p²k, pkr, qr} ≥ δ₀n², forcing p ≥ δ₀n at k ≤ 1/δ₀: the **companion** n − r must carry a linear prime factor at bounded cofactor, the α = 1 endpoint again on the other side.

**Demonstration worth keeping:** run Theorem 2 with ℛ = S_D itself. Then qr ≫ n²/D reaches Ω(n²) on the r-side and the min is still pinned at p²k ≈ n^{1+γ} by the companion — feeding in the endpoint hypothesis buys nothing, which localises all of (BCG-AL)'s difficulty in the companion clause rather than in S_D's thinness.

**The positive result this yields**, now stated in `aod` §6.8(iv): **(BCP_{D,c,ρ}) at any ρ ≍ 1/log^C x implies f(n) ≫ n^{2−ε} for almost all n**, every ε > 0, exceptional set O(x^{1−2ε}log^{C+3}x) — the ladder's limiting exponent from the bounded-cofactor hypothesis alone, no Baker–Harman needed. Not Ω(n²); the gap is exactly the companion endpoint.

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

### T5. Condition (4)'s strip — historical — and the residue that blocks B_refined = B_safe

*Mathematics in `enumeration-proof.md` Part D (Lemma C's coupling, Corollary C′). **No gate is implemented anywhere:** all three former strip sites in `fb_common.py` now carry the flat cap, and `set_strip_trace()` records what the old cap would have decided without anything reading it.*

**The licence**, which is local to (p, a, r) and involves no n, density floor or table threshold:

> **sharing_bound(p, a, r) = min(r·ord_r(p), C(r,2))**, and the strip is sound iff this is **< B**.

At a = 1 the coupling forces ord_r(p) = 1, so the bound is r and the licence reads r < B. The strip acts only when r | p^a − 1.

**The strip measurement is now historical, and says so.** Condition (4) used to cap a fallback part at F·orb(c, dmax) rather than F·C(c,2), and the exposure was measured by instrumenting every strip decision the certificate reached: 42 decisions over all 2,187 rows, all licensed, none at a > 1. **That measurement no longer protects anything, because the cap it measured is gone**: condition (4) is the flat F·C(c,2), the strip is an unread diagnostic, and neither Corollary C′ nor J0a is in the certificate's base. Keep the instrument (`set_strip_trace()`) for anyone wanting the weaker group-level statement; do not quote the count as a discharge of anything.

**Why the old cap was doubly exposed, which is worth keeping as the reason not to reinstate it.** For F·orb(c, dmax) to be a *necessary* condition, orb(c, d) had to bound the block's minimum intra-orbital — true for a ΓL(1)-type stabiliser and **false in general at a ≥ 2**, by Part B's own 3^{1+2} ≤ GL(3,7), where the realised minimum exceeds orb(c, d) by a factor 9. So that cap leaned on Corollary C′'s Frobenius step *and* on the orb formula itself, and it was anti-permissive on top of both. The flat cap has neither exposure: F·C(c,2) counts pairs and holds for every stabiliser.

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

### T5a. The runner-up ordering inside the three-part family

**The 1 : 1 : 2 prediction is refuted, not open.** `three-part-family-split.md` §1.2 predicts odd-n win shares of 1 : 1 : 2 among S4 (unfused), S5 (top-layer fused) and S7 at F = 2 (cyclic-layer fused); that document is archived and the prediction does not survive the corrected shape space. The whole three-way competition rested on the **c mod 8 law** — S4 winning at c ≡ 1, a tie at c ≡ 5, the fused rung at c ≡ 3, 7 — and the entangled-generator correction removes its mechanism: a cyclic-layer fusion does not cut the twist, so the fused rung scores 2·C(c,2) against the unfused C(c,2) **at every c** with no congruence in play. S4 is dominated everywhere, and S5's only remaining advantage over S7 was a twist cut neither now pays, leaving S7 ahead on its free choice of top prime. So the asymptotic split is not 1 : 1 : 2; **S7 takes the family**, and the shares of the other two tend to zero. `enumeration-proof.md`'s S4 census row and `aod` §3.2.5 both already say this.

**What is genuinely still open, and it is what `aod` §7 needs.** The disjunction-collapse argument wants the **gap to the next shape down**, so the live question is the *runner-up* ordering, not the winner:

> **At each odd residue class, is S5 or S4 second — and by how much?**

Two specific things a human pass should settle, in this order:

1. **Where Lemma C's coupling bites.** S7's advantage over S5 is its free top prime; the coupling (`enumeration-proof.md` Part D) is what can take that away, by stripping S7's layer where the matching twist shares a prime with the foreign block. Wherever it bites, S5 is second; elsewhere S4 is. **This is a congruence condition, not an extreme-value argument**, which is why it is tractable: the fragility of the discarded 1 : 1 : 2 route lay entirely in its extreme-value step.
2. **Whether the gap is bounded below by a constant.** §7 needs a gap, not an ordering. The candidates are cap-level quantities at each class, so this is arithmetic on the §3.3.5 table plus the coupling's density, and it should not need a search.

**What not to reuse.** The archived note's tables are keyed **mod 24**, predate the entangled correction, and quote 0.050510 at class 11 as a *within-family* cap at η = 1/6 — which is not the class ceiling, that being 7 − 4√3 from the two-part F = 4 shape outside this family. Take the question from here and the constants from `aod` §3.3.5.

### T6. The residual conditionality in §3.3.5's ceilings

Both coordinates of the joint optimum are settled without a search. The **F side** closes on cap_F(1) = 1/(1 + √F)² together with η ≤ 1, which bounds each F-slice with no arithmetic input and excludes F ≥ 8; the parity constraint at odd n leaves F ∈ {2, 4, 6}. The **η side** is derived from congruences in §3.3.4a — a 2-adic factor 2^(1−v) with v fixed by r mod 8, and a 3-adic cut by 3 when 3 | r − 1 is forced — and `eta_derive.py` checks that derivation against an independent measurement at every (class, F) cell. *Gotcha the F side invites: cap₄(1) = 1/9 bounds the F = 4 slice and is not any class's ceiling, since a class that could take F = 4 at full efficiency reaches 1/8 through F = 2 at η = 1/2 instead.*

**What is left is one hypothesis and three scope limits.**

- **Supply, which is the same hypothesis as everywhere in §3.** The congruences say a suitable r is unobstructed; that primes of the form r = 2^v·q^e + 1 actually occur near the balance point in the density §3.4 needs is Bateman–Horn. Nothing in §3.3.4a improves on that, and it is why the ceilings are family guarantees rather than theorems about δ.
- **Only F ≤ 6 is derived.** §2.1's bound makes that sufficient for the conclusion, but the congruence bookkeeping itself has been done for F ∈ {2, 4, 6} only.
- **Mixed three-part shapes** — 4c + 2c′ + r and the like — lie outside both the two-part family and the three-part ladder, and no ceiling here bounds them.
- **Class 11's entry rests on 676 > 675 — and the comparison now has a second, independent derivation.** The margin is 7 − 4√3 > (2 − √3)/4, i.e. 26 > 15√3, the narrowest possible integer margin, and anything upstream that moves it flips the class. **What has changed is that both sides of it are now reproduced by a route with no access to the shape space.** `bcp-to-floor.md`'s circle-method optimisation selects (k, d) per residue class from congruence conditions on r − 1, and at class 11 it returns **(4,6) → 7 − 4√3 = 0.071797** as the optimum with **(6,4) and (2,12) → 0.066987 = (2 − √3)/4** as the runners-up — the same winner, the same runner-up, the same margin, derived from arithmetic rather than from an enumeration of rungs (`aod` §6.9(b)). So the residual exposure at this bullet is **no longer that the argmax is misidentified**; a shape-space error large enough to flip class 11 would have to be mirrored by an unrelated error in the congruence analysis that happens to land on the same two constants.
  - *One thing the second derivation adds rather than confirms:* under it the optimum at class 11 is **unique**, not a tied pair. The framework's own objective is symmetric enough that (4,6) and its transpose look interchangeable; the analytic objective is not symmetric — its foreign term carries √(d/2) — and the transpose falls to 0.0670. A strict optimum at a 0.0718 : 0.0670 margin is a sturdier object than a tie, and it is worth checking whether the framework's side should be stated the same way.
  - *The runner-up is a **tie**, and that is now measured too.* `ceiling_rederive.py --runners` takes the sup per fusion count and per mod-24 half: both halves reach (2 − √3)/4 at **F = 2, η = 1/6** and again at **F = 6, η = 1/2**, all four values within 2·10⁻⁵. So the older reading — F = 2 in the half n ≡ 11 (mod 24), F = 6 in the half n ≡ 23 — was a mod-24-era artefact, and an argument needing the runner-up needs the tie. This matters to T5a, whose live question is precisely the runner-up ordering.
  - *(Every closed-form constant in §3.3.5 and the cap_F(η) = cap₁(Fη)/F identity independently re-verified. The exposure that remains here is the supply hypothesis and the margin, not the arithmetic and not the argmax.)*

*The ceiling table's independent re-derivation is `ceiling_rederive.py` (R6-adjacent); the working is recorded in the session log.*

### T7. The k = 3 κ parameters

*The F = 4 transfer is settled as a derivation and the tables are in `three-uniform-note.md` §5.7; this entry records only what is still open.*

**Open:** whether κ_c and κ_r can be steered independently of the congruences fixing F and η. The tables hold κ_r = 1 throughout and treat κ_c as a free parameter with two values; if the κ's are coupled to n the way η is, the κ_c = 3 column is not reachable at every residue and the class-11 F = 2 / F = 4 tie may be unrealisable. **No risk to k = 2.**

**What the transfer rests on**, unchanged from k = 2: the ceilings are family guarantees, and that primes of the required form occur near the balance point in the needed density is Bateman–Horn. Two narrower gaps also persist from k = 2 — only F ≤ 6 has been worked, and mixed three-part shapes lie outside both families.

### T8. Proposition F.4 (the converse) — two readings; one step carries the whole statement

*Given a second, independent reading: both branch derivations re-derived from scratch, the census walk re-checked, the three smaller steps resolved (below), and one defect found and fixed (§6.8(ii)'s window endpoint). What remains single-sourced is Lemma B′ itself, which is T1's item, not this one. The measurements still are not independent evidence of the derivation — they test the inequalities, which the table's winners satisfy whatever the proof says.*

**The step everything rests on, and its support is better than first recorded: why must the foreign twist Q be a prime power?** Branch (b) is vacuous without it — Q = r − 1 always satisfies a cofactor bound. The confinement is **Lemma B′'s content, not an unstated assumption**: AGL(1,r) is nonabelian, so a foreign block's translations must occupy the abelian cyclic layer and its twist is forced into the top q-group. So the question is not "is this assumed?" but "is B′ right?", which is T1's standing item — B′ being the one structural lemma whose failure would break B_safe itself. That is a much better position than an unexamined layer claim, but **layer-assignment claims remain the category with the worst record here** (the F_mid coprimality clause, the c mod 8 fusion mechanism), so the reliance is worth keeping visible.

**The asymmetry that this creates was got wrong once and is the thing to re-check on any restatement.** A *matching* class's twist is **any divisor of c − 1**, carried by the cyclic layer, and may be the full c − 1 — cofactor 1, not a prime power. So the all-matching branch yields **no arithmetic statement whatever**, and F.4's multiplicative case must be a genuine **alternative** rather than a weakened form of the same conclusion. An earlier draft had it qualifying only the primality of the witness, leaving the divisor conclusion apparently unconditional; that was wrong, and it is the natural error to repeat, since the two branches look parallel until one asks which layer supplies each twist.

**The shape audit is done and closed one gap; record it so it is not redone.** Walking S1–S10 against the branch split: S3, S4, S5, S6, S7 and **S9** carry a foreign part and land in (b); S8 and S10 are killed so nothing exists to quantify over; S1 and S2 land in (a). **S9 (fused outside class) is the gap it found** — the first draft bounded a foreign part's contribution by r·Q with r ≤ n, which is the unfused case; a fused foreign class contributes F·r·Q and needs the **joint** bound F·r ≤ n, the same care the matching branch already required. Stated in the proof now. *Note this is the second time the joint-versus-separate bound has been the defect* (the other produced the spurious 2/δ₀²), which makes it the thing to check first on any restatement. Also recorded there: branch (a) is **wider than S1 ∪ S2**, since multi-class all-matching shapes such as n = 640 = 1·256 + 3·128 are not named in the census but land in (a) correctly — the proof splits on presence of a foreign part rather than on the census, and a shape-by-shape proof would have missed them.

**The extracted hypothesis (BCP) is new with the same standing.** `aod` §6.8 states the n-free multiplicative half as **(BCP_{D,c,ρ}): |S_D ∩ [cx, x]| ≥ ρ(x)·π(x)** — the window built into the definition rather than derived, because a cumulative *lower* bound does not yield a window count (that needs a lower bound at x and an upper bound at cx, the PNT-to-Bertrand relationship), and because a cumulative *asymptotic* would pin ρ to one function and stop the statement being a family. In window form ρ is a genuine lower bound and all three parameters are monotone. Bounded multiplicative gaps are the weakest case, ρ = 1/π(x), and are what a floor implies for free. The section asserts two things about the hypothesis that want checking independently: that a floor implies it (the gap half being a short argument from branch (b) plus branch (a)'s density-zero exceptional set not filling an interval), and that it does **not** imply a floor, the additive clause of (b) being inexpressible n-freely. The second is stated more carefully: a purely multiplicative hypothesis *can* reach the additive clause, via the exceptional-set machinery of Shparlinski's Theorem 2. What blocks it is **not** the thinness of S_D — that machinery's hypothesis is a pure cardinality condition, so relative density ≈ C·log D/log x costs one logarithm and divides straight through (T4 above, `aod` §6.8(iv)). What blocks it is the **companion** exponent, sub-linear at every input density, so the route yields n^{2−ε} for almost all n and not Ω(n²). Density does have an appetite at the *endpoint* tool, Sárközy–Stewart, where S_D at ≈ 1/log²x is two logarithms short. So the honest status is *open*, not impossible, and the concrete question is filed as a T4 literature item. *Measured for context:* the largest multiplicative gap below 2·10⁶ is 1.041 at D = 12 and 1.165 at D = 2, counting from r > 10³, and shrinking with the cutoff — so (BCP) at the constants a 1/25 floor needs is enormously weaker than the data suggests, and its difficulty is entirely that bounded D is the Sophie Germain endpoint.

**The three smaller steps are now resolved** *(second reading, independent of the pass that wrote them).*

- **"Every part clears δ₀·C(n,2) on its own." RESOLVED, with one proviso now stated in the proof.** The direction is safe as used, and no part *kind* escapes: any class with an intra pair has an intra orbital bounded by F·c·d/2. The exception is a part of support **s_i = 1**, which has no intra orbital at all, so the sentence is literally about s_i ≥ 2; such a part needs no branch, since its cross orbitals have size ≤ n and fail the floor outright at large n. `ep` F.4 now carries the proviso.
- **The shared chain prime. RESOLVED structurally rather than by citation**, and the reason is now in the proof — **in two branches, which the one-line form of it conflates.** Fix the chain first (G.0's discipline, which F.4 follows). A block class of size s^k with k ≥ 2 and s ≠ p has non-cyclic elementary-abelian translations needing a home. At **s ∉ {p, q}** there is none: s-elements map into the cyclic layer, so Sylow-s is cyclic. At **s = q** the top layer *is* such a home, so that argument fails and the branch runs through **Lemma B′ Case 2** instead — a primitive transitive q-group is regular of prime degree. So no such class exists; a block class at a second prime must have k = 1, which is the foreign case and exits to (b). The dichotomy is exhaustive **per chain**, and since only *some* chain is needed, a group admitting several costs nothing. Two matching classes at different primes cannot arise, so the density-zero exceptional set is safe.
- **The constants. RE-DERIVED from scratch and correct** — both branches, the round trip, the floor-dependent D(δ₀), the slack factors, and n(n−1) carried consistently. **One earlier entry here was itself wrong and is now corrected.** It claimed the smallest intra orbital of a foreign class is at most F·r·Q/**2** rather than F·r·Q, so that the derivation was discarding a factor 2 in the safe direction. That is false at **odd Q**, where `−1 ∉ C_Q` and the orbital is exactly `r·Q` — verified by orbit enumeration at (13,3), (31,5), (11,5) giving 39, 155, 55, against the halved values 26, 31, 164 at the even-Q pairs (13,4), (31,2), (41,8). `shparlinski-constants.md` §1.5 draws the correct and opposite conclusion: **F.4's F·r·Q is tight at odd Q and the factor 2 is not recoverable there**; the halving occurs only at Q = 2, which `aod` §6.8's parity remark makes the rare case. F.4's derivation is sound either way, since F·r·Q bounds the orbital above in both parities — what was wrong was the belief that slack was hiding here. *(The same error, made independently, cost `bcp-to-floor.md`'s Reduction Lemma a factor 2 in its headline constant; the correct argument was already written in `note-to-framework-bridge.md` §5 and propagated to neither.)* The residual watch-list: the orb halving at even twist, and C(n,2) versus n²/2 — *the second of which has already produced one slip, a draft asserting δ₀·C(n,2) > δ₀n²/2, which is backwards since C(n,2) < n²/2; the statement now carries n(n−1) throughout.* Nothing structural turns on it, but `aod` §6.7 quotes 700 as the round-trip figure and it inherits any slip. *One such loss has already been found and removed* — the all-matching branch was first derived at 2/δ₀² by bounding F ≤ 1/δ₀ and c ≤ n separately, when F·c is bounded by n jointly; keeping the product together gives 2/δ₀ on both branches. Checked over ~4·10⁵ random configurations, 0 violations, tightest ratio 0.5. **Both branches now carry the same constant, so a future slip that makes them differ is itself a signal.**

**One finding from the second reading: §6.8(ii)'s window constant sat at a degenerate boundary.** The claim was that a floor gives (BCP) with **c = δ₀/2 exactly**, argued by "if some window held none, every n in its upper part would fail (b)." But an n fails only if its whole r-range [δ₀(n−1)/2, n] lies inside the empty window [δ₀x/2, x], which needs n ≤ x *and* n ≥ x + 1 — no such n exists, so at the endpoint the emptiness implies nothing and the claim was unproved at its own constant. For any **c < δ₀/2** the failing n fill [2cx/δ₀, x], a positive proportion, and branch (a)'s O(x/log x) integers cannot cover it. Fixed in `aod` §6.8(ii) and in `ep` F.4's gaps aside (Λ > 2/δ₀ strictly). **This is the class of defect T8 exists to catch** — an endpoint where a constant is quoted exactly and the argument needs one side open — and it is the third such in this framework after the F.1/E′ offset and the D2′ closed-form tie.

**The cofactor constant sharpens, and the sharpening is inside F.1's existing machinery.** Bounding r ≤ n gives (r − 1)/Q ≤ 2/δ₀; dividing the same inequality by Q instead makes the cofactor depend on r's *share* of n, and a configuration carrying a foreign part carries a second part of support > √(δ₀n(n−1)), so r ≤ n − √(δ₀n(n−1)) and **(r − 1)/Q ≤ D(δ₀) = 2(1 − √δ₀)²/δ₀**. That is a strict improvement at every δ₀ — 25.4 against 42 at the table floor, 32 against 50 at the conjectured 1/25, 14.9 against 28 at the asymptotic ceiling — and it costs nothing new. Both forms hold with zero violations across the table; `converse_check.py` reports each separately so a document still quoting the crude one can be checked against the run rather than silently disagreeing with it. **The residual sharpening question is correspondingly smaller: ~2.1 against the measured 12, not ~3.5.**

**Rerunnable as `converse_check.py`** (`--delta0` to test one global floor rather than each row's own density, `--frontier` to pin the contiguous cut, `--all-rows` to include the worklist), and **in R1's command list**, because these checks read the **witness column** and the rebuild rewrites witnesses — composite-F fusions change which rows are one-part, and raised rows change δ. **Requoted from the completed table.** Over [6, 2600]: **0 violations** across all three inequalities, at **1,443** foreign primes and **743** one-part winners (v4: 1,409 and 777). Max cofactor **12**, at the same witness as ever — n = 221, r = 157, Q = 13 — and now with a second attainer at **n = 2759** (r = 1453, Q = 121), which is the range minimiser, so the constant that F.4 records is realised both at the smallest witness and at the hardest n. Slack: D(floor) = 25.4 against 12 used, loose by a factor **2.1** (the crude 2/floor = 42 gives 3.5). *Slack moves with the floor rather than with any finding, so it is not a result; the invariant figures are the zero violations and the 12.* Negative control: `--delta0 0.35` gives 796 violations and exit 1. The frontier is detected as the first gap wider than 10, reproducing the documented 2,186 rows; a looser threshold silently swallows worklist rows, which is how the detection was found to be wrong.

**What the measurements do and do not support.** All three inequalities hold at every contiguous row with zero violations, and two independent constraints bind simultaneously at n = 2594 — genuine corroboration that the bounds are tight rather than merely true. But the measurements test the *inequalities*, not the *derivation*: a wrong constant or an unjustified layer assignment would produce inequalities that still hold on the table, since the table's winners satisfy the true statement whatever the proof says. **The measured maximum cofactor of 12 is the strongest single datum here** — it matches (BCG)'s own constant from the opposite direction — and it is also the reason to suspect F.4's D(δ₀) = 25.4 is loose by ~2.1, which is the sharpening question the gap inventory records.

## §2b. Self-contained items

*Analysis against the existing files, needing no new materials.*

### A0b. `validate_table_v3.py` — the three groups

`python3 validate_table_v3.py <current table> --baseline <previous table>`

- **A. Table integrity** — well-formedness, Lemmas B′ and D2 on each witness, re-derivation of `mu_bound` from the witness by the G.3 formulas, the density column (A20), certification, monotonicity against the baseline, **value agreement against the baseline**, and the **Part E preconditions** (T2). *The monotonicity check is the FAIL gate — a value going down is a defect under every reading — and the value-agreement check beside it is INFO carrying the equal/higher/lower breakdown, the coverage either way, and the count of **ties** (equal value, different recorded witness). It sits immediately above the shape-migration check because that check is read against it: a migration with zero value differences is a tie, not a disagreement. Compared on the integer `mu_bound`, and reported as `ALL equal` or raw counts — never a percentage, since a negative control corrupting one value in each direction printed `100.00%`.* A FAIL means the run or parser is broken.
- **B. Exact claims, holding at every n** — Prop F.1, cap_F(η), S2's 1/F, layer-by-top-prime, S6 emptiness, Lemma C exposure, the cyclic layer's pairwise coprimality, the feasibility criterion, Part G.4's per-axis bounds, the within-class cross coefficient, and the foreign-side residue patterns. The matching block's residue prices nothing, so the exact checks live on r, not c; the retired c mod 8 patterns are kept as group-C INFO, where a population at the residues the old law forbade is positive evidence. A FAIL is a real contradiction between table and documents.
- **C. Density and distribution** — floor and the s/k bounds it implies, low-density tail, part-count distribution, census shares, odd-n shares, class-ceiling exceedance, median density by residue class, foreign-block efficiency, ω(n) = 2 share. All INFO, each printing the expected asymptotic beside the measurement.

**Four group-B checks have no independent counterpart elsewhere:** the cyclic layer's global pairwise-coprimality condition (the only check that would catch the enumerator *over*-correcting), the feasibility criterion Σ√Fᵢ ≤ 1/√δ, Part G.4's per-axis bounds, and the within-class cross **coefficient**, which is invisible to output since the term never binds. Each has a negative control: breaking it makes the check FAIL.

**Group-B trend check, for census rows claiming `wins → 0`.** The verdicts are asymptotic limits, so a count tests nothing; what is required is a *declining share*, clearing both a proportional bar and Poisson noise. `ZERO_SHARE` entries may be a tuple treated as one aggregate — needed because splitting S7 by fusion count costs sensitivity. To exercise it, replace the `S7f3`/`S7f5` entries with `("S7f3","S7f4","S7f5","S7f6","S7f8")`: it fails with `S7f3+…+S7f8 4.1%→7.6%` against `S2 45.2%→29.3%`.

**Amend it in the same pass whenever the model changes** — each check names the document section it comes from, so a stale check is findable from either end. It checks the table against the documents' model, not against mathematics; for independent evidence use `brute_compare.py`.

> **Keep it fast — a design constraint, not a nicety.** The suite runs in about **0.1 s on 1,700 rows, 1 s on 50,000, 3.5 s on 144,000**, which is what makes it reflexive rather than scheduled. Keep each check O(rows) or O(rows × parts) on numbers already parsed from the witness. Enumerating configurations, isomorphism work, re-deriving B(n), or sieving past `NMAX` belong in a certificate. If a new check must compare a row against alternatives, budget it against the per-row cost and say so at the check.
>
> **It was violated once, and not by a check.** The gap scan in `main()` read `n not in set(ns)`, rebuilding the set every iteration — quadratic in the row count, 0.02 s at 2,186 rows and **47 of 51 seconds at 50,062**, minutes on the 144k ladder-exact table. Fixed (hoist the set; sieve the prime-power test; skip the scan entirely on a non-contiguous file and say so), together with two smaller costs the fix exposed: `prime_power_base` is now memoised (409k calls, a few thousand distinct block sizes) and `density_ok` uses integer arithmetic instead of `Fraction`, whose normalisation was 1.4 s of a 13 s run. **Output is bit-identical before and after on the exact table, and the density fast path was checked against the `Fraction` reference on every row of both tables — 0 disagreements.** *The lesson to carry: `main()` is subject to the cost model too and is where nobody looks, and a quadratic term is invisible until the data grows an order of magnitude — so re-time when the table's scale changes rather than trusting that it was fast last month.*

### A9. The Lean formalisation — keep it in step, and keep it moving

*Home: the Lean project's own `README.md`, which carries the phasing, the case for and against, and the failure-mode analysis. **This item exists so the work resurfaces even when nobody thinks to mention it**; do not restate the reasoning here.*

> **State, 2026-09.** All three files sorry-free (the word appears only in comments); `ArkCore.lean` compiles against core 4.15.0 with no Mathlib; `Note.lean`'s main theorem `theorem_arithmetic_half` is correctly scoped — its primality and coprimality hypotheses are bound with underscores because the arithmetic half does not use them, which is the honest signal that they belong to the Oliver half. **The README predates Theorem E.5**, and E.5 is now the highest-value formalisation target in the project: arithmetic on SAFE terms, one human reading, load-bearing for the whole "μ known exactly to 10⁶" claim. Recorded there as Phase 1b. Also reachable and cheap: the BBKN-replacement inequality `μ(n) ≥ n·(Q(n) − 1)/2` (three lines from `orb_full`, if the note's §1 commentary keeps it), and the self-pairing lemma `orb c d = c·d/2 ⟺ d even` behind `directed-graph-properties.md` §2.

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

### A20b. delta must be computed from the integers, never parsed from the density column — DONE

**The failure this exists to prevent, because it fired.** `validate_table_v3.py` parsed `Row.delta` from the CSV's `density` column, which carries **six decimals** — a rounding error up to 5·10⁻⁷. The cap_F margins at n ≈ 10⁶ are *narrower than that*: the closest approach on the completed 10⁶ table is **1.77·10⁻⁷** and **96 rows sit within 5·10⁻⁷**. So a rounded density can land on the wrong side of a cap, and at exactly one row in 921,265 it did:

> **n = 999685**, witness `2x292801 + 1x414083*`: true density **0.171572510776**, column **0.171573**, cap₂(1) = 3 − 2√2 = **0.171572875254**. The true value is below the cap by 3.6·10⁻⁷; the rounded one is above it by 1.2·10⁻⁷.

That produced **two spurious FAILs** — the cap_F check and the feasibility check, which reads 1/√δ — on the same row, from one cause. *Confirmed exactly in integers: (3C − B)² − 8C² = 514799345346156900 > 0, so δ < 3 − 2√2 with no floating point anywhere.* **The data were correct and the checker was wrong.**

**The same defect was in a second script, and there it was far louder.** `converse_check.py` also parsed the density column, and inequality (2) of Proposition F.4 — r ≥ √(δ·n(n−1)) — is *tight*, its closest ratio on the 10⁶ table being 1.0000. The inflated δ therefore broke it on **991 rows**, and the script printed *"991 violation(s) — F.4 is contradicted by the table"*. Checked exactly in integers, r(r−1) ≥ 2B holds at **every one of the 796,763 one-foreign rows**; with δ computed from the integers the script reports **all four inequalities clean**. *A script whose failure message is "the Proposition is contradicted" is exactly the one that must not read a rounded column* — and the two scripts failed the same way in the same week, which is why the guard below is a check rather than a comment.

**Fixed and guarded.** `Row.delta` is now `B / C`; `delta_str` is kept because check A20's whole job is to verify the column against B/C, and that check must read the string while every other check must not. Three guards: the cap_F check now **reports its margin** (closest approach, and how many rows sit within the column's rounding error) so the next person sees immediately that the column is unusable here; a new group-A check **fails if anyone reverts** `Row.delta` to `float(density)`; and both are documented at the point of use.

> **The failure is evidence for the bound.** A rounding error can only flip a comparison whose two sides are within the rounding error of each other, so this could not have happened against a loose ceiling. Measured on the completed 10⁶ table, the closest approach to cap_F(η) **in every one of the twelve residue classes**:
>
> | n mod 12 | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
> |---|---|---|---|---|---|---|---|---|---|---|---|---|
> | closest gap (×10⁻⁶) | 1.25 | 0.36 | 0.18 | 1.40 | 3.25 | 0.23 | 2.25 | 1.14 | 0.19 | 0.40 | 6.26 | 0.41 |
>
> **Every class is approached to within 7·10⁻⁶, six of them to within 5·10⁻⁷**, and the approach tightens with the range: the closest gap in each decade runs 9.3·10⁻³ (n ≈ 70), 3.9·10⁻⁴, 3.7·10⁻⁵, 3.0·10⁻⁶, 1.8·10⁻⁷ — *gap × n roughly constant at 0.14–0.65*, which is the O(1/n) discretisation of the balance point and exactly the rate a tight ceiling should show. So the ceilings of `arithmetic-of-density.md` §3.3 are not merely upper bounds but **attained to the resolution the integers allow**, in every class, and the checker's one-in-a-million false positive is a symptom of that rather than of anything wrong.

*The general form, which is why this is worth a section rather than a line in a log:* a derived column is a **lossy** copy of the data, and a check that reads it is testing the printer rather than the value. The tell is that the failure appeared only after the table grew — the margins tighten as n grows, so the rounding error stays fixed while the quantity being compared does not. **Six decimals were ample at n = 2600 and are not at 10⁶**, and no amount of care at the earlier scale would have surfaced it.

### A20c. A screen must derive its range from the table, never from a constant — DONE

**Two scripts silently under-screened the completed table while printing a pass.** `t5_verify.py`'s pass 4 built its event list to a hardcoded `N = 2484`, so on the 10⁶ table the running maximum froze there and the check passed vacuously at **918,781 of the 921,265 rows it reported**. `audit_fmid.py` had `--nmax` defaulting to 2600 against a hardcoded sieve bound of 2700, so it screened **2,186 of 921,265 rows** — and its coverage line, "0 non-prime-power values in that range absent from the table", reads exactly like a clean pass because it is one, over the range it chose.

Both now derive the range from the table's own maximum, and `t5_verify.py` also reads the **floor** from the table rather than quoting 0.02516 (its threshold accordingly moves from n ≥ 763 to n ≥ 371). Its r-loop was rewritten to run over the prime *divisors* of p^a − 1 rather than every prime below it, without which the corrected range is not reachable.

**Coverage measured, and one scaling limit found.** With the range derived, `audit_fmid.py` screens a **20,000-row slice to n = 22,591 clean** — 4,945 rows at δ ≤ 0.13, 0 configurations above B(n) — but its candidate loop scans the prime-power list per row without bisecting, so the full 10⁶ run does not finish in reasonable time. **That is a scope note, not a defect**: the screen is about low-density rows and those are dense at small n. Bisect the `parts` loop on c before claiming the whole range.

*The general form is the one A20b's lesson does not cover:* a check can be wrong about **what it looked at** as easily as about **what it concluded**, and the first failure is quieter, because the output still says PASS and still names a large number of rows. **A screen must state its coverage before its verdict, and the coverage must be derived from the input.**

### A21. A fusion-aware penalty for the partition-factor table

*The table itself now lives in `shape-counting.md` §4; this is the live remainder.*

The all-shapes **penalised** column (`shape-counting.md` §4) is a **lower bound**, not an exact count. Its penalty `x ≥ √(δ₀F)·(1 + 1/p)` comes from the density ceiling, which prices the smaller class at C(c′,2) — the *unfused* reading — so it is too harsh on a shape whose smaller class is fused, by exactly the factor fusion supplies. `n = 640 = 1·256 + 3·128` is the witness: penalised cost 4.10 against L = 3, rejected, yet a real configuration at δ = 0.1192.

**What to do:** derive the penalty for the fused reading (the smaller class is worth F′·C(c′,2), so the requirement should scale with √F′ rather than being charged per size-group), and recount the three all-shapes entries. Expect them to rise, staying between the current penalised figures and the unpenalised 34 / 115 / 357.

**Priority: low.** The top row is unaffected — a fused unequal shape needs n to be a sum of two distinct p-power multiples, a density-zero condition that puts it among §6.5's escapes rather than in the covering accounting — and §6.6's covering statement quotes N_add, which is counted directly and never uses this table. So the exposure is to a commentary figure, and `shape-counting.md` §4 states the direction of the error.

### A22. `validate_table_v3.py`'s group-A expectation is scoped to the current table

*Not owed work — retained because it is the reference point that makes a baseline run readable, and the 289-vs-18 pairing is asked about repeatedly.*

The R1 reference point reads *0 FAIL*, which holds for an enumerator output under the current scoring. Run against a **baseline** it does not: a row whose recorded winner is a cyclic-fused class scored under the superseded cut twist re-derives *higher* from its own witness, so group A's re-derivation check fires. On the v4 baseline that is **18 rows of 2,186** — a subset of the 289 known-low rows, the other ~271 being exceeded by a different configuration rather than by a rescoring of their own witness, and so invisible to a check that re-derives from the recorded witness. **Neither number is a defect**; the pairing of them is the thing to state, since 289 and 18 look like they should match and do not. Either scope the expectation in R1's banner or have the check name the baseline case when `--baseline` is supplied.

### A23. `bcp-to-floor.md` §7's end-to-end run needs rerunning at the corrected orbital

The run scored foreign intra orbitals at `rQ/2` where every `d` in its grid is even and `Q` is therefore an **odd** prime, so the true orbital is `rQ` (§2, corrected). Both sides of its comparison moved together, so the structural conclusion — zero exceptional n among 400,000 consecutive values, realized δ within a predictable margin of ideal — survives; the numbers do not. **Expected on rerun:** class 11 realizing ≈ 0.066 against the ideal 0.0718, in place of 0.04655 against 0.05051. The §3 grid search wants the same treatment. Tagged ⟦PENDING-RERUN⟧ in the note; not fabricated here.

### A23a. `check_doc_figures.py` — the tail row changed what "current" means

*Both fixes are made; this records the reasoning, since the next tail row will raise it again.*

Adding n = 2759 above the contiguous frontier made the pass report 22 extra findings. **They were correct, not artefacts** — the documents' "the table floor is 0.048039" had silently become a *contiguous-range* figure quoted as the table's. Two changes followed:

1. **Both floors are current figures.** The contiguous floor and the file floor answer different questions and a document may legitimately quote either; keeping only one made the other read as stale. `CUR` now carries both, and which one a sentence means is a prose matter no pass can check.
2. **Extremal quantities come from the whole file, distributional ones from the prefix.** Both current tables are contiguous, so this is dormant — but it re-arms the moment an extension fills higher n selectively, since such rows are computed *because* they may be new minima and belong in a floor rather than a share.

**The general lesson**, since this will recur: a checker's notion of "the current table" is a *population choice*, and a file that is a contiguous prefix plus a biased tail has two populations, not one. Any quantity added to `quantities()` needs classifying as extremal or distributional at the time it is added.

### A24. Is the shape space complete?

*Now load-bearing for a second claim, and that is new.* Until n = 2759, completeness carried only the μ ≤ B direction of the certified range. It now also carries the framework's **one exact value of μ**: the pinch at 2759 gives μ = 175813/3804661 *granting* μ ≤ B_safe, and a missing shape would make B too small there, so the true μ(2759) would be larger and both the minimum and its uniqueness would move. The failure runs the safe way — the floor would be an understatement, never an overstatement — but the *exactness* is exactly as strong as this item.

The ceiling table is a theorem about the Oliver-admissible family **as currently characterized**, and the entangled-generator correction showed that characterization can be wrong in the permissive direction — a whole family was excluded by an argument that confused a quotient for a subgroup. **Nobody has searched for the optimal admissible family**, in this project or in the literature: BBKN had no reason to, since below the endpoint any admissible family gives the same order (`literature-findings.md` §15b). So the literature's silence is evidence neither for nor against the entangled construction's optimality, and this is the one place a further constant factor could still be hiding. No cheap test is known; the honest status is that the ceiling is a ceiling *over what we have enumerated*.

### A25. The transference route from (BCP) to a floor

`bcp-to-floor.md` §6.2 files it: S_D under (BCP) has positive relative density inside the Selberg majorant for the pair `{Q, dQ+1}`, whose pseudorandomness is sieve-provable, and a restriction/transference estimate for `n = kp + r` against that majorant would give the representation for almost all n with **no distributional hypothesis on S_D at all**. §6.1's counterexample marks the boundary any such argument must respect — the count alone is provably insufficient — so a successful transference must consume the unconditional sieve upper bounds. A research question, not an afternoon; filed here because it is otherwise homeless outside a one-pass working note.

### A26. The note before circulation: what to re-read, and one decision to make

*The naming and the non-nesting are done — the note carries `(BCG_{1/5})` with a paragraph explaining it, and `note-to-framework-bridge.md` §4 states the non-nesting. What is left is a reading and a judgement call.*

`mu-theta-n2-note.md` remains **correct on its own terms** — its family is the unfused one, its window is deliberately generous, its constant crude by design — and nothing here touches its Theorem. What changed around it: its hypothesis is now **(BCG_{1/5})**, and its relation to the framework's is **non-nesting in both directions**, not "a weaker form of the same thing". (BCG-AL) hands over an `F = 4` configuration at n ≡ 11 (mod 12) with `c/n ≈ 0.134`, which the note's `c ≥ n/5` rejects; the note in turn is far weaker in constant and restricted to `n = c + r` and `n = 2c + r`. **Before any circulation:** re-read the note's §5 θ-ladder against `aod` §3.6's current attributions, and decide whether the note should mention the F = 4 shape at all or stay deliberately silent about it.

### A27. A second reading of `bcp-to-floor.md`, now that `aod` §6.9 quotes it

Promoting the note's findings into `aod` raises the value of a second reading rather than lowering it, and §6.9 is written so the tiers can be checked independently.

**Cheap and self-contained (an hour):** (a) the identity `1/(√k+√(d/2))² = cap_k(2/d)`, algebra; (b) the six-cell (F, d) match against §3.5.3's clause 3, a table comparison; (c) the generic-set counterexample, elementary. If these three hold, §6.9(a)–(d) stand whatever happens to the rest, which is why they are separated out.

**The real read (a day or more), in descending value:**
1. **The Reduction Lemma's orbital structure**, proved rather than enumerated at five (p,k) pairs — and specifically the foreign term, which carried a factor-2 error through the note's first draft and set its headline constant 42% low. The corrected value `rQ` at odd Q is verified by enumeration and matches `shparlinski-constants.md` §1.5, but **it has one reader**.
2. **The major-arc assembly** (§4.2), where the hypothesis is actually consumed; the singular-series completion is sketched for squarefree `q` only.
3. The two [STANDARD] steps used on citation — the Vinogradov dilation lemma and the Siegel–Walfisz manipulation.
4. §7's end-to-end run, which is separately blocked on A23's rerun.

**What a disagreement would cost.** (a)–(d) are quoted in `aod` §§3.5.3, 6.8 and 6.9 and would survive; (e) is cited rather than restated, so a failure there retracts a citation and the strengthened reading of the asymptotic half, not any unconditional claim. That asymmetry is deliberate and should be preserved if §6.9 is ever expanded.

### A28. Score the Galois layer: B_refined⁺

*Small, well-posed, and the last structural source of an interior μ(n) apart from J0a itself.*

`mu_enumerate`'s `orb(c, d)` takes a matching block's twist to be **cyclic** of order d, which is exact for a stabiliser inside the Singer cycle and *under*-states one inside ΓL(1, c) proper. At c = 343 with foreign prime 19, C₁₈ ⋊ Frob₃ sits in an Oliver chain at q = 3 and realises minimum intra-orbital 3087 against the stripped cyclic reading's 1029. So B_refined as implemented is not the sharpest construction-side lower bound available; **B_refined⁺**, taking the twist inside ΓL(1, c), is.

**Why it is worth doing even though nothing currently depends on it.** Part E‴'s trichotomy leaves exactly one way for μ(n) to sit *strictly between* the endpoints: a proper prime power c, a stripped twist, and a density below the E.1/E.3(iii) caps. Scoring the Galois layer removes the middle of those three, after which an interior μ requires a stabiliser outside ΓL(1, c) altogether — i.e. J0a proper, which is a much sharper thing to be left with than "the refined scoring is not tight".

**What it costs.** One clause in `orb` (multiply by the Frobenius orbit count where the twist order divides a subfield's), a re-run of the shape sweeps at c = 4, 8, 9, 16, 25, 27, 32, 49, 64, 81, and a check that `B_refined⁺ ≤ B_safe` still holds at every row. It cannot move B_safe, and it can only *raise* a lower bound, so the direction is safe. **Do not let it touch the certificates**, which score SAFE and must stay flat.

### A29. Second reading: the J0a-free bound t ≤ a

Lemma C's coupling conclusion t \| ord_r(p) is proved via a Frobenius exponent and assumes a semilinear stabiliser at a ≥ 2. The **bound** it is consumed for — orb(r, t) ≤ r·a, which is all Corollary C′ and E.3(i) use — appears to need no such assumption: the r-element of the cyclic layer has r-th-root-of-unity eigenvalues on V = 𝔽_p^a, closed under Frobenius, hence at most a/ord_r(p) Frobenius orbits; conjugation is a power map whose reduction mod r is the induced multiplier, so the multiplier group permutes those orbits and M⟨p⟩/⟨p⟩ acts freely on cosets, giving \|M\| ≤ a. **One reading only, and nothing currently rests on it** — E.3(i) is theorem-side and `--no-theorems` closes every n without it, and Part E‴ does not use Lemma C at all. If it holds it removes J0a from Corollary C′ and weakens E.3(i)'s "worth at most c" only to "at most max(c, r·a)", still linear. → T1's queue, after Part 0.

### A30. ~~`johnson-presentations.md` is cited and not in the working set~~ — RESOLVED

The file exists and is now in the set. Its Proposition 1 is the unification the citation promised — a transitive action whose coordinates are the k-subsets of a base X (a **k-Johnson presentation**) has a transitive Oliver subgroup **iff** G contains a subgroup that is Oliver and k-homogeneous on X — so the §1 citation is restored, and Appendix C's prime-powers box now states one criterion with three inputs (arity, base size, containment) instead of listing three coincidences. *Spot-checked on reading: AGL(1,5) ⊄ A₅ (the twist x ↦ 2x is an odd 4-cycle), D₁₀'s pair-orbitals are [5, 5] against A₅'s [10], and T(m) has degree 2(m−2) at m = 5, 6, 7 — all as the note states.*

**One live item it leaves behind**, worth carrying separately since it is not about the presentation at all: §5's open question, **what is the minimum order of an Oliver group on m points whose minimum orbital is ≥ δ·C(m,2), for m not a prime power?** The necessary bound is Ω(m²) and is tight at prime powers (AGL(1, m) has order 2·C(m,2)), but the multi-block constructions use groups polynomially larger — the bottom layer alone is c^F — and nothing in the framework explains the excess. Either much smaller Oliver groups achieve constant δ at composite m, which would widen the class of G the argument reaches, or Ω(m²) is far from achievable off prime powers and a better lower bound exists. `mu_exact.py` could settle it over the computed range by recording each winning configuration's group order beside its density — a small change to a script that already enumerates the configurations.

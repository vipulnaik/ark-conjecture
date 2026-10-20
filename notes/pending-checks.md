# Pending checks

*The work list for the arithmetic programme (`orbital-evasiveness-notes.md` §§1–6, `enumeration-proof.md`, `arithmetic-of-density.md`). **Outstanding work only.** This file exists to make a run runnable: the command, the input, the expected shape of the output, and the traps specific to that run. It is not a summary of results, an argument, or a history — those live in the documents, in `verification-lessons.md`, and in the session logs, and duplicating them here is how this file went stale before.*

## The two tables

| file | producer | reach | rows | what it is |
|---|---|---|---|---|
| `mu_table_ladder.csv` | `mu_ladder_exact.py` | **10⁶ — complete** | 921,265 | exact B(n), certified above C(n,2)/25 by Theorem E.5 + `ladder-completeness.md` Prop 1 |
| `mu_table_exact.csv` | `mu_exact.py` | **10⁵ — COMPLETE** | 90,299 | exhaustive search — the arbiter |

Both contiguous, no worklist tail, **0 uncertified rows**, minimum **175813/3804661 = 0.046210 at n = 2759** (the only other value below 0.05 anywhere is 0.048039 at n = 2183). Since every row clears 1/25, **Corollary E.6 makes each value μ\*(n), not a bound on it** — so μ\* is known exactly at every composite non-prime-power n ≤ 10⁶.

## Six standing rules

1. **A rebuild must never lower a value.** Group A's monotonicity check against `--baseline` is the signature to read on every batch; the value-agreement check beside it gives equal/higher/lower and the tie count.
2. **Never read the `density` column.** It is rounded to six places and the margins are tighter than that — see **A20b**, which cost two spurious FAILs in one script and 991 in another. Compute δ = B/C.
3. **A screen must state its coverage before its verdict**, and the coverage must come from the table rather than a constant — see **A20c**. Two scripts silently screened 2,186 of 921,265 rows while printing a pass.
4. **Append the old maximum to `check_doc_figures.py`'s `CHECKPOINTS`** on every extension, or every correctly-scoped historical figure becomes noise in PASS 1.
5. **Requote what the extension moves**, per the tag scheme in **R0c**. The floor, its argmin, and small-n first instances do not move; distributions do.
6. **Close an item in the same edit that finishes it.** It becomes a ledger row, or, if it holds a rerun recipe, shrinks to the commands, the expected output, the gotchas and a one-line "last run". Results and working go to the session log or the target document, never back into this file. No struck-through text and no "*Original text:*" tails. *Added 2026-10-19, after this file grew from closures written in place.*

**Status labels.** *Verified* — an independent computation agreed. *Sound* — an argument was read and found correct. *Unverified* — neither.

**Companion files.** `verification-lessons.md` — the failure-mode taxonomy and the reasoning behind these checks. `fusion-count-ceilings.md` — ⟦ARCHIVED⟧. `shape-counting.md` — the enumeration behind `aod` §6.

*Do not restate the inequality as `B_safe ≤ μ*`.* `B_safe` over-counts per configuration; what holds is B_refined ≤ μ\* ≤ B_safe, the endpoints collapsing where E.5 or the certificate applies.

## Before the pause: the landing checklist

*Nothing on this list is live.* Items 1–3 are done; item 2 stays for the recipe it leaves behind, and item 4 is a non-obligation recorded so it is not mistaken for one. **Run outputs still scoped to older tables, and not rerun:** `fallback_cert.py` (2,187 rows). It says so where it is quoted.

1. **`mu_exact.py` to 10⁵ — done 2026-09:** validate gives 27 PASS / 0 FAIL, values ALL equal over all 90,299 common n, and the banners are updated.
2. **`solvable-relaxation.md` at 10⁶ — done 2026-09** (22 PASS / 0 FAIL, every figure requoted). For any future extension, build the table once, after which every question takes seconds:

   ```bash
   python3 solvable_table.py --nmax <N> --out solvable_table.csv   # ~3 h at 10⁶; --chunks i/8 for ~25 min
   python3 solvable_relaxation.py mu_table_ladder.csv --solvable-table solvable_table.csv
   ```

   The writer resumes by reissuing; the validator imports the scoring core, so the two cannot drift; and a loaded cache is spot-checked and refused if it does not cover the μ\* table's range.
3. **The GAP battery's three regression rows — done 2026-10-18** (R8).
4. **`wide_cert.py` is rescoped, not owed** (see R1b): B is known exactly to 10⁶, so a certificate "beyond the table" has no range to certify below 10⁶. It would matter again only for an extension past 10⁶.

*Not on this list, deliberately:* `a18_verify.py`'s slow table scan (its witness checks pass; the scan is range-scoped domination that E.5 now covers above 1/25), and the `stage4_fast.py` seeds (they produce no verdict without UNSAT). Neither gates anything.

## What is still owed

*Everything else in this file is a re-run triggered by an extension, or an item under §2. Nothing below is owed as a run today.*

| owed | kind | item |
|---|---|---|
| `wide_cert.py 100000`, both modes | rerun — the last complete run predates the fused rung's addition to B_lo | R1 |
| items needing a human reading | judgement | §2a |

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
2. **Part E's realisability** — the GAP battery builds 13 configurations, n ≤ 2759, including the range minimiser, three entangled-generator regressions and F = 4 at n ≡ 11 (mod 12); all pass. What remains is that the battery samples configurations rather than covering every winner. → **R8**
3. **§3.3.5's ceilings** — exposure is the shared supply hypothesis. → **T6**
4. **Proposition F.4's reliance on Lemma B′** — branch (b) is vacuous unless a foreign twist is a prime power. → **T8**
5. **The κ parameters at k = 3** — no risk to k = 2. → **T7**
6. **The eight necessary conditions of `fb_common.py`** — demoted: with E.5 in hand an error in them can no longer invalidate the collapse above 1/25, though it still gates the certificates. → **T3**

> **One class has left this list entirely.** The arithmetic layer — inequalities, cap algebra, threshold ladders, the six ceiling constants — is now checked by script on every run, and the caps are *attained to the resolution the integers allow* in all twelve residue classes (A20b). Errors there would be caught, not reasoned about.

---

# §1. Script runs

*Can be launched in the background. Flags are checked against the scripts as they stand; where a run needs code that does not exist, that is said rather than papered over with a plausible-looking flag.*

> **Not every entry is a live run.** **R0, R0c, R1, R6, R6a, R8, R13** are rerun recipes (R13 optional); **R1b, R12, R12a** are kept because they explain a scope that is easy to get wrong or record a tool's measured result. **A finished item becomes a ledger row** (standing rule 6).

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

**Two columns mean different things by producer, and the difference is the point.** `certified` = 1 means F.1's k self-certification from `mu_exact.py`, but E.5 + Proposition 1 from `mu_ladder_exact.py` — there a 0 means the row fell below 1/25, where every pruning step is unjustified and the value is a lower bound. `fallback` = 1 only on a row that went through the exhaustive handoff and whose optimum is a fallback: the only rows where μ\*(n) = B(n) is not established by any theorem.

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
| ~~**⟦NEEDS-ITS-OWN-RUN⟧**~~ | **retired 2026-09** — its one site, the orbital-count distribution in `notes` §9.7, is now produced by `orbital_counts.py` and was regenerated on the completed table | — | — |

*A fourth tag, ⟦PENDING-1E5-EXACT-RUN⟧, was retired earlier and its notice has been folded away; the range convention it enforced is now invariant I7's job. Nothing should reintroduce it.*

**So the answer to "what are these pending on" is: only the first kind is pending on the current runs.** Nine sites were of that kind while the banner claimed all of them were script outputs, which is what made the tag unreadable. Untagged measured figures are not exempt from range discipline — they name their range under invariant I7 — and structural claims, closed forms, ceilings and theorems were never in scope for any tag.

**When the two runs land:** rerun `check_doc_figures.py <table> *.md`, requote every ⟦REQUOTE-ON-EXTENSION⟧ site, and rerun `solvable_relaxation.py <table>`. The certificate and own-run tags stay put.

> **`CHECKPOINTS` is already primed.** 36848, 55814, 71288 and 159027 have been added, so a figure correctly scoped to any of those frontiers is reported as *matching an old checkpoint* — a historical citation to leave alone — rather than as unexplained staleness. Add the new maxima on the next extension too; it takes a minute and skipping it turns every correctly-scoped historical figure into noise in PASS 1. Expect the old-checkpoint counts to be large and mostly benign: 16 in `aod` on the current run, which is what a document with a long recorded history should look like.

## R1. Routine, after any new batch of table values

**Current status: the battery has been run against the completed 10⁶ table and passes.** *Scope of the 0 FAIL expectation (formerly A22):* it holds for an enumerator output under the current scoring. Run with a **superseded** table as the current one, group A's re-derivation check fires on rows whose recorded cyclic-fused winner was scored under the old cut twist: **18 rows of 2,186** on the v4 table, a subset of its 289 known-low rows (the rest are beaten by a different configuration, which a re-derivation from the recorded witness cannot see). That is expected, not a defect. `validate_table_v3.py` 27 PASS / 0 FAIL / 16 INFO with the exhaustive table as baseline, all μ\* equal on the overlap. `t5_verify.py`, `converse_check.py`, `audit_fmid.py`, `check_doc_figures.py` clean. `fallback_cert.py` and `wide_cert.py` are rescoped — see **R1b**. `solvable_relaxation.py` owed a recount at 10⁶.

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
- **`solvable_relaxation.py`** — all PASS; B_solv ≥ B_safe is structural, so a FAIL means the Oliver side credits a class no solvable group carries. Two INFO lines look alarming without their reason: the **class-11 share** exceeding 7 − 4√3 is expected (the ceilings bound the balanced additive family, not μ\*), and the **attainment share** is the S2 identity showing through. Requote both, and the ratio distribution, from the run.
- **`check_doc_figures.py`** — `--quiet` for findings only, `--pass {figures,scope,prose,hygiene,census,refs,tables}` for one pass. **Pass every `.md` that might be cited**, or `refs` reports live citations as dangling.

**Static — one run per environment, not per batch.** `eta_derive.py`, `khomog_verify.py`, `a18_rq_verify.py`, `k3_galois.py`, `shape_realize.py` and `ceiling_rederive.py` — the last two read no table at all and are sized for small n by design (**R6**, **R6a**).

**Deliberately absent.** `ladder_verify.py` never reads the table and is retired (R7); **`ladder_vs_B.py` is retired with it** (R12b) — it tested that script's implementation, and the shape-space half of what it covered is group B's menu-shape check, which needs no ladder file. `validate_table_v3.py --ladder` is correspondingly vestigial, and its two checks SKIP, which is now the normal state. `s7_scan.py` and `mu_fast.py` are not in the working set; group B covers what `s7_scan.py` would test. The Lean statements are read by no check here — see **A9**.

## R1b. The certificate steps of R1 do not scale to 10⁶ — and no longer need to

**Measured:** `fallback_cert.py` runs in 3.2 s on 1,000 rows, 24.3 s on 3,000 and 196 s on 9,000 — about n^1.9 — which extrapolates to **roughly 15 days** on the 921,265-row table. It cannot be run there as written.

**It also has nothing left to decide there.** The certificate answers, per n, "could any fallback configuration reach B(n)?" **Theorem E.5 answers it for every n at once above C(n,2)/25**, and **0 of the 921,265 rows are at or below that line** (the minimum is 0.046210). So the per-n certificate is redundant on the whole table, exactly as Corollary E.6 intends: the certificate was the tool for the regime the theorem now covers.

> **So R1's certificate steps are rescoped rather than dropped.** Run `fallback_cert.py` and `wide_cert.py` on a **slice** — the first few thousand rows, where they are seconds and still exercise every branch — as a check on the *code*, not on the table; the table itself is covered by E.5. Verdict on the [6, 3531] slice, rerun now: **0 values where some fallback configuration could reach B(n)**, 88.8% settled by theorem alone, s ≤ 3 over the range, and the foreign-part regime split 91.7% e = 1 / 7.5% e ≥ 2 / 0.8% q = 2. *If a future extension ever produces a row below 1/25, that row — and only that row — needs the certificate, and it will be one n rather than a million.*

**Still to run when convenient** (they are unaffected by this and were not reached): `a18_verify.py` on the full table (its own witness checks all pass; the table-scanning part is slow), `solvable_relaxation.py`, `t5_verify.py`, `audit_fmid.py`, `shape_realize.py`, `ceiling_rederive.py`. None of them gates anything the completed run establishes.

## R6. Shape-level scoring checks

*Score **shapes**, not rows, so they do not rerun on table extension. Rerun after any change to the SAFE cap, to `orb`, or to `mu_enumerate_v3.py`'s scoring. `k3_galois.py` belongs to this class too — it takes no table and scans a fixed range, so one run per environment suffices.*

```bash
python3 shape_realize.py --nmax 34              # expect 0 mismatches
python3 shape_realize.py --nmax 22 --strip      # control: expect UNDER-SCOREs
python3 shape_realize.py --foreign --nmax 200   # foreign blocks vs orb(r,t): expect 0 mismatches; add --strip for the control
python3 shape_realize.py --interclass --nmax 40 # all four terms incl. F*c*r: expect 0 mismatches
python3 lemma_c_share.py --cmax 64              # Lemma C sharing groups: expect 0 coupling violations, 0 sharing-bound excesses, every licence ok (~75 s)
python3 lemma_c_share.py --cmax 32 --nocouple   # control: expect coupling violations
ARK_SHAPES_NMAX=100 ARK_SHAPES_MAXF=4 gap -q -o 8g ark_shapes.g
ARK_SHAPES_NMAX=200 ARK_SHAPES_MAXF=2 gap -q -o 8g ark_shapes.g
ARK_SHAPES_STRIP=1 ARK_SHAPES_NMAX=100 ARK_SHAPES_MAXF=4 gap -q -o 8g ark_shapes.g
gap -q -o 8g oliver_negative.g                  # the admissibility predicate's negatives
```

**Last run 2026-10-17/18 — all clean** (session-log-15 §§31–33): 197 foreign blocks, 495 inter-class shapes, 3,248 sharing groups, and every control fired.

- **Read the control before the green run.** Expect UNDER-SCORE at exactly the shapes where stripping **changes** orb(c,d) — check against that predictor, not a remembered count. It is *not* "wherever gcd(d, F) > 1", which names about twice as many rows.
- **`lemma_c_share.py` reports refined under-credits, and they are expected.** `--refined` scores 257 sharing groups below what they realise (worst c = 32, r = 31: 16 against 155). The strip is not a necessary condition; Corollary C′'s licence covers it, and that is the column to read.
- **`-o 8g`, not `4g`.** The maxf = 2 sweep's largest groups reach order ≈ 1.8 × 10⁶ on 194 points; 4 GB truncates. `ark_shapes.g` FAILs on a row without a verdict rather than summarising over it.
- **`oliver_negative.g`** ends in a single PASS/FAIL and writes `oliver_negative_out.txt`. Part B needs the `transgrp` package; without it the part is skipped and counted as a failure. `OLIVER_NEG_DEGMAX` widens it, `OLIVER_NEG_CRANK` bounds part C's lattice cost. Its part D prints **two verdict columns and asserts one** — a rejected witness alongside a successful search is the designed behaviour.

## R6a. The ceiling table's re-derivation — conditional rerun only

*Currently clean and not owed. Rerun if `arithmetic-of-density.md` §3.3.5 changes or the script does; it scans configurations, not table rows, so an extension does not trigger it.*

```bash
python3 ceiling_rederive.py --nmax 24000 --mod12     # expect all six approached from below, all pairs agreeing
python3 ceiling_rederive.py --nmax 16000 --no-filter # control: expect exceedances at 3, 5, 7, 11
```

**`--no-filter` must exceed, and its witnesses must be prime powers.** A composite c in that column means the candidate list is admitting block sizes no Oliver group has, and the escapes it reports are partly phantom.

## R8. The Part E realisability battery — the only leg of μ\* = B with no per-n check

**What a pass settles:** that the enumeration's score at that n is *attained*, i.e. μ\*(n) ≥ B(n). Not completeness. This is the only artefact that builds a group; everything else re-derives a value.

```bash
cd scripts   # required: launched elsewhere, GAP prints "Could not read file" and exits 0
gap -q -A -o 8g verify_witness.g < /dev/null                            # the battery, 13 rows, ~5 s
ARK_WITNESS_FTOP_SPLIT=1 gap -q -A -o 8g verify_witness.g < /dev/null   # the control: must ABORT at n = 78
WITNESS="p=5 q=2: 2x5" MUBOUND=20 gap -q -A verify_witness.g < /dev/null   # a single row
```

**Read the control first.** It restores the pre-entangled split and must reproduce the `G/G1` normality abort at n = 78. **If the control ever passes, a green run of the default path means nothing.**

**Last run 2026-10-19: 13/13 `VERDICT: true`; the control aborts at n = 78** (session-log-15 §§34–36). The rows cover the fused rung at F = 2, 3, 4, 5, 6, a trivial-top attainer, cyclic-layer fusion beside a foreign block, Lemma C's worked example, the three entangled-generator regressions (n = 78, 33, 105), **n = 2759** (the range minimiser, foreign class at Q = 11²), and F = 4 at n = 52 and n = 323 ≡ 11 (mod 12).

- **`< /dev/null` is needed**, or GAP waits for input after the run and looks hung.
- **Four rows score a configuration that is not the winner at its n** (n = 26, 35, 247, 308). That is deliberate: they check realisability of a configuration, not optimality, and `BATTERY`'s comments say so. The n = 247 row once caught a pre-correction expectation that under-scored.
- **What made n = 2759 reachable:** translations from a basis of F_c rather than all c − 1 elements, `PositionSorted` lookups, and suborbit-based `OrbitalSizes` (the naive version stays behind `ARK_ORBITALS_NAIVE=1`). **Do not drop the chain check to buy speed**; it is what distinguishes this from a re-derivation of the value formula.
- **`-A` is belt and braces.** A collision guard at the top names any global the file defines that an autoloaded package has made read-only (`Orb` once was; it is now `ArkOrb`).

**Not owed, but the next step if wanted:** more current winners. Each new row now costs seconds.

## R12. `mu3_menu.py` — B₃ over the k = 3 census

**New 2026-09, and it closes half of `three-uniform-note.md` §10 item 1.** Scores every shape in that note's §4.2 census at every n in a range and writes `n, C(n3), b3_census, delta3, witness`. Table to n = 2000 in the working set as `b3_census_2000.csv` (1,666 rows, 7 s).

**Read the column name, and know which way the inequality runs.** `b3_census` is the max over the *census* shapes. Two directions, two hypotheses, neither established at k = 3:

- **μ\*₃ ≥ B₃^census** if every census shape is realisable by an Oliver group (the Part E analogue — no GAP battery exists at k = 3);
- **μ\*₃ ≤ B₃^census** if the census is complete (§10 item 1, open).

So the useful reading is a **lower** bound on μ\*₃ modulo realisability. Nothing should read the column as μ\*₃. What it legitimately replaces is the *hand* searches: §6.2's "optimal" at one n, §6's escape counts, §5's class ceilings.

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

## R13. `biclique_table.py` beyond 10⁴ — optional

Computes s(n), the largest smallest-block over Oliver groups whose minimal blocks are all 2-homogeneous — the location of the linear biclique region a + b ≤ s(n) (`oen`, biclique box). **Run to 10⁴ in 17 s**; results in `biclique_table_1000.csv` and `biclique_table_10000.csv`, summarised in the box.

```bash
python3 biclique_table.py --nmax 100000 --out biclique_table_100000.csv   # roughly quadratic: ~30 min
```

**Worth doing only to watch the thin families recede** — at 10⁴ the generic share of winners is still 16% at class 11 and 38% at class 5. Beyond 10⁵ the script needs restructuring: it loops over (c, F, r) per n, so it should instead iterate over η = 1 foreign primes r and prime powers c once, scattering into n. *Not enumerated, deliberately:* S12 (two matching classes of one prime, different sizes), which could in principle be structured — it would show as an n where a hand construction beats the table.

## Closed, kept as a one-line ledger

*Items retired without residue, so a reader meeting a reference to them elsewhere can tell what happened. Full accounts are in the session logs.*

| item | what it was | outcome |
|---|---|---|
| **R0b** | retire the ⟦PENDING-1E5-EXACT-RUN⟧ tag once a run passed 10⁵ | **done** against the ladder-exact table; all 27 tagged sites requoted, banner replaced, the range convention now enforced by `check_doc_figures.py` invariant I7 |
| **R7a** | rerun `ladder_verify.py` to 10⁶ at the corrected window | **moot** with R7; the two window/fusion-set defects it found are recorded there in case the script is ever revived |
| **R7c** | audit `solvable_relaxation.py` and `k3_galois.py` | **done** — the former had the same O(N²) sweep the validator had (5× on the scan, 3× end to end, 22 checks pass to n = 159,027); the latter's self-test had a range-scoped claim stated as a law and a clause whose only witness (a = 155) sat outside the test range |
| **R11** | recheck `approach-rate-note.md` §4a's falsifiable claim against the completed run | **done** — the offset climbs 0.536 → 0.652 as predicted and the F = 4 share reaches 99.4%; its limit is **ln 2, not 1**, which §4a had wrong. All of it is in that note's new §4b, which is now the only place it needs to be |
| **A33** | who settles n = 6, and by what argument | **done** — Kahn–Saks–Sturtevant 1984, as a separate case alongside the prime-power theorem (confirmed by Engström 2006's abstract). `small-degree-computation.md` updated at all three sites |
| **A35** | can a shape-space configuration give a larger fully-evasive sub-structure than Korneffel–Triesch? | **no** — single-group certification only ever reaches a single orbital, which the adversary forces to be the minimum, so the route gives exactly D(h) ≥ μ\*(n) ≤ n²/4; the better constants use multi-orbital sub-structures that need a second symmetry layer the shape space does not model. Written up in `oen` beside the threshold result |
| **A31** | `aod` §5's decade tables labelled ladder *bounds* where the section says the minima are exact | **done** — recomputed exactly over the 921,265 rows; the ladder's bounds agree at every decade minimum, so the tables now show δ with the bound beside it and the point is recorded in §5 itself: the ladder is **tight at the decade minimisers** |
| **R7d** | audit `khomog_verify.py` | **done** — one vacuous check (an arithmetic tautology no computation could falsify) replaced, and the {8, 32} finiteness claim swept over every prime power in [6, 63] rather than three spot checks |
| **R12b** | rerun `ladder-completeness.md`'s two scans at 10⁶ | **done / retired** — `offmenu_scan.py` at 10⁶: off-menu shapes at 5,739 n, above 1/25 at 5,045, reaching B at none, maximum still 0.1111 at n = 4376; `ladder_vs_B.py` retired with `ladder_verify.py` (R7). Account in session-log-14 |
| **A20b** | δ must be computed from the integers, never parsed from the six-decimal density column | **done** — `Row.delta = B/C` in `validate_table_v3.py` and `converse_check.py`; the two spurious FAILs at n = 999685 traced to rounding; per-class closest cap gaps tabulated. Account in session-log-14 |
| **A23** | rerun `bcp-to-floor.md` §7 at the corrected orbital rQ | **done 2026-10-17** — control reproduces 0.04655; corrected: zero exceptional n, class 11 at 0.06617 (worst representation, window geometry) and 0.06794 (best). `bcp-to-floor.md` §7, session-log-15 §23 |
| **A32** | does the conjecture give a classification-free proof of Brown's question? | **no** — it yields only evasiveness of the coset complex, the weakest link of χ̃ ≠ 0 ⟹ not contractible ⟹ evasive. `hardness-of-evasiveness.md` §5 |
| **A20c** | a screen must derive its range from the table; `audit_fmid.py` at the full range | **done 2026-10-17/18** — the hardcoded N = 2700, which survived every committed version, is replaced by a table-derived range, a bisected c-loop, base-prime grouping and `--nmin` for chunked runs (controls: identical output to the old version, including the same 21 hits on a superseded table). **Full table screened: all 921265 rows, 232105 at δ ≤ 0.13, 0 shared-F_mid configurations above B(n)**, run in 50,000-wide chunks. The general lesson stays in `verification-lessons.md` §5 |
| **R10** | the chiral-half homology at n ≡ 1 (mod 4) | **done 2026-10-17** — no chiral half of the Hamiltonian-cycle complex is ℤ-acyclic (closed forms, session log). The last residue, the n = 5 Smith form, is now confirmed directly: integer homology of each half, by Smith normal form over `chiral_mv.build(5)`, is **H̃ = ℤ/2 in degree 1 only**, so the sum is (ℤ/2)², matching the stated cokernel with elementary divisors (1,1,1,1,2,2). `chiral_mv.py --verify` passes at n = 5, 6, 7 |
| **A22** | `validate_table_v3.py`'s group-A expectation is scoped to the current table | **done 2026-10-17** — the scoping sentence is now in R1's status paragraph: run on a superseded table, group A fires on 18 of 2,186 v4 rows, a subset of the 289 known-low rows, and neither number is a defect |
| **A23a** | `check_doc_figures.py`: the tail row changed what "current" means | **done** — both fixes made (two floors in `CUR`; extremal from the whole file, distributional from the prefix); the lesson moved to `verification-lessons.md` §5 |
| **A27** | second reading of `bcp-to-floor.md` | **done 2026-10-17** — cheap tier clean; orbitals proved for all (p, k); (BH-SW) strengthened to Siegel–Walfisz strength; the 2/8 tie found; the [STANDARD] steps, the singular series (non-squarefree q, uniform lower bound) and §6.2's sieve claim written out (note §9–§9c). Only a referee-style read by a third party remains, which is not a pending check |
| **A28** | score the Galois layer, B_refined⁺ | **resolved 2026-10-17** — within ΓL(1, c) the Galois layer never beats the full stripped cyclic twist (orb⁺ ≤ orb(c, D)), so B_refined⁺ = B_refined and the enumerator needs no change. Proof in `enumeration-proof.md` E‴, second-read by an independent referee with a finite-field check to c = 729; `galois_orb.py` |
| **R7** | consume the ladder worklist with `ladder_verify.py`'s adaptive branch-and-bound | **superseded** — `mu_ladder_exact.py` computes B exactly at 15 ms/n, so a lower-bound-and-prune loop saves nothing below 10⁶. The result survives: min μ\*(n)/C(n,2) over composite non-prime-power n ≤ 10⁶ is 175813/3804661 at n = 2759 alone (now also built by R8). *If the script is ever revived:* the window must be [0.10, 0.85], not [0.10, 0.55], and the fusion set 3..16 ∪ {25}, not 3..12 ∪ {16, 25} |
| **R6 items 1–3** | foreign-block η, the inter-class term, Lemma C's foreign strip, against realised groups | **done 2026-10-17/18** — all clean; recipe kept in R6, results in session-log-15 §§31–33 |
| **R8 items 1–3** | n = 2759, even F ≥ 4, a current two-part winner in the GAP battery | **done 2026-10-19** — all built and passing; recipe kept in R8, results in session-log-15 §§34–36 |
| **A20 / A20a** | the density check must compare in exact arithmetic; a bound may not be quoted as a rounded decimal | **standing constraints, closed as items 2026-10-19** — `density_ok` in `validate_table_v3.py` compares exactly (string precision read off the string, integer fast path checked against `Fraction` on every row); its group-A note and the summary banner now say its FAIL means a mis-rounded presentation column, not a broken run (the open decision; control: one corrupted density string gives exactly that FAIL). The rounded-bound rule lives in `verification-lessons.md` §5 |
| **A29** | second reading of the J0a-free bound t ≤ a | **done 2026-10-19 — holds**, for any stabiliser. One gap was found and closed: conjugation is a power map only modulo P, repaired by Sylow conjugacy in P⟨z′⟩. The three steps are now explicit in `ep` beside the argument. *Not yet acted on:* removing J0a from Corollary C′ and E.3(i)'s statement — a document decision; nothing currently rests on it |
| **A44** | bi-resistance: rung, natural properties, the half-split criterion, the degree-12–14 census | **done 2026-10-19** — the census is complete: all 62 transitive groups of degree 12–14 above order 5,000 contain a transitive Oliver subgroup (`halfsplit_large.g`; M₁₂ via a regular C₆ × C₂), and 12T162 is confirmed as the sign kernel in S₄ ≀ C₂ (`t12_162_kernel.g`). Extending past degree 14 is `monotone-transitive-note.md`'s item 1, not a separate item |

## §2a. Needs human thought

*Judgement calls, independent scrutiny, or things requiring materials Claude cannot obtain.*

### T1. Independent reading of the structural arguments

*The failure-site taxonomy this item rests on is `verification-lessons.md` §1; do not restate it here.*

**What is owed: a further independent reading**, worth more than another pass by any previous reader. Parts A–J and Part 0 have had a second reading by someone with no prior exposure; it found no error in the steps it examined, confirmed B′'s socle argument, and **every finding it returned was site 3**. A later full-document critical pass returned ~15 findings, all drift or cross-era inconsistency and none a defect in a proof — consistent with the same limit: the passes that have happened check statements against each other, which is not the same as checking a step whose plausibility is doing the work. It did not reach the site-4 defect that sat in the theorem statement, the SAFE cap and `fb_common`'s condition (4) throughout — so a reading running sites 1–3 should be assumed to leave site 4 untouched.

**A machine reading is weakest exactly where the failure mode is "an argument that reads as plausible"**: it verifies constants and recomputes tables freely, and cannot notice a step whose plausibility is doing the work. That is the residual human item.

**Where to look, in order.** Part E's realisability (T2) — reading a construction is not building one, so the read pass could not close it. Part 0's completeness — the worst record, the sole support for μ\* ≤ B_safe, and the place a missing shape hides. Then Parts D2q and E″, which carry the most intricate case analysis per line.

### T2. Part E's realisability: preconditions are checked, construction is not

The preconditions check is **built and passing**: `validate_table_v3.py` group A asserts per winner row that the Part E build's ingredients exist — F_top a q-power, every foreign block scored above r having q | r − 1. The carrier's order must be coprime to every **foreign prime**; it need not be coprime to any block count, a fused class being carried by an entangled generator whose F_mid-th power is the full twist. *A precondition stricter than the construction requires does not err on the safe side here — it rejects rows the construction realises, and the check's purpose is attainment.*

Part E's construction has been read and found sound as written, with E.3(ii)'s (c, r) = (11, 5) group rebuilt independently returning orbitals {10, 55, 55}. **Reading a construction establishes that it would work if assembled, not that assembling it at the table's actual configurations yields the predicted multiset** — only R8 does that.

**What is owed, and it is what a check cannot reach.**

- **Whether to build groups at all, and how often.** R8 now builds 13 configurations in seconds, including F = 4 and n = 2759, so adding rows is cheap. What a check cannot decide is which further winners are worth adding.
- **J0a, the stabiliser assumption** (item 5 of the enumeration-proof gap inventory above)**. Discharged for every computed value by the flat cap, and without loss at a fixed twist order by the orbit-counting argument below.** *(The flat cap is the stronger of the two and the one to quote: B_safe credits F·C(c,2) and sᵢsⱼ, both counting bounds on the pair set rather than statements about the group, so μ\* ≤ B_safe holds whatever the stabiliser is. The argument below is what additionally rules out a non-field stabiliser **at the same order**; a larger-order one is the residue, and it reaches only E.3(i).)* The construction takes a matching block's twist inside the field's multiplicative group, whereas the stabiliser of a primitive affine group of degree p^a may be any irreducible subgroup H ≤ GL(a, p). The worry was that some non-field H realises a block orbital the field cannot. It cannot:

  > **At a fixed order t, the field subgroup is optimal.** Any orbit of H on the c − 1 nonzero vectors has size at most |H| = t, by orbit–stabiliser. The multiplicative subgroup of 𝔽_c^× of order t acts **semiregularly** — its orbits are the cosets, every one of size exactly t — so it attains that bound at every vector simultaneously. Hence **no subgroup of GL(a, p) of order t has a larger minimum orbit than the field subgroup of order t**, and the same holds for the ± version that governs pair orbitals, replacing H by ⟨H, −1⟩. Since the block's contribution is decided by its minimum orbit, a construction that reaches for a non-field stabiliser can never beat the field one at the same order.
  >
  > *(Confirmed by exhaustive search over the subgroups of GL(2, p) for p = 3, 5, 7: no subgroup anywhere has minimum orbit exceeding its order. The search is a sanity check on the statement, not evidence for it — the bound is orbit–stabiliser.)*

  **What remains, and it is narrower than the original item.** The argument compares *at a fixed order*, so it discharges attainment but not **primitivity**: the field subgroup of order t is irreducible only when t fails to divide p^b − 1 for every proper b | a, so at a twist order lying inside a subfield the block group built from it is imprimitive, and Lemma B's affine reading needs the Frobenius element of ΓL(1, c) to restore irreducibility. **So the scoped claim to make is:** the twist may be taken inside ΓL(1, c) without loss, and the check owed is that the constructions do reach for Frobenius at subfield-order twists rather than assuming irreducibility. That is a reading of Part E's construction against a stated condition, not an open structural question.

### T3. Independent necessity read of the eight conditions

*Why necessity rather than truth, and why the failure is invisible: `verification-lessons.md` §2.*

Both certificates pass with every Part E′ theorem disabled, so these eight conditions, together with Part 0's shape space and Lemma D2's domination of fused foreign classes, are the whole trusted base for μ\*(n) = B(n). `fb_common.py` carries a per-condition necessity argument in its header, so **what is owed is scrutiny of those eight arguments, not their reconstruction** — and the value is in the independence, so a second reader beats another pass by the first.

**What a reading of these has to keep straight, and it is one thing.** The certificate's question is whether a share-carrying configuration's **SAFE score** can reach B_safe(n), and SAFE credits a p-characteristic part the flat F·C(c,2). So a condition on such a part is necessary exactly when F·C(c,2) ≥ B implies it. A cap of F·orb(c, dmax) — the twist stripped of the foreign prime — tests a *smaller* number and can reject a configuration whose SAFE score does reach B: anti-permissive, and invisible in the output. The strip bounds a different quantity, what an actual *group* of that shape realises, which yields μ\* = B_refined rather than B_refined = B_safe, and is itself valid only for a ΓL(1)-type stabiliser. **The conditions therefore use the flat cap and no strip**, which is also why they no longer inherit Lemma C, Corollary C′ or J0a. Measured: with flat caps and `--no-theorems`, the candidate list is empty at every row of the computed table.

**Where to press hardest, in order.** **Condition (7)–(8)'s leftover machinery** is now the least examined part, since it carries the load the strip used to at the L = c shapes — check that the subset-sum reachability really over-approximates (it ignores inter-leftover cross terms and distinctness from p, both permissive, but the reasoning wants a second reader). **Condition (2)'s `'*'` branch**, gated on r ≥ B, fires only at n = 6 in range, so it is untested by the passing run. **Condition (6)** is not independently necessary and is retained as a tripwire; check nothing has come to rely on it.

**No strip site remains as a gate.** `_record_strip_diagnostic` records what the old cap would have decided, and nothing reads it. **Re-check on any edit to the file** that no cap on a p-characteristic part is anything other than F·C(c,2): a strip reintroduced as a gate produces the same (empty) output as a correct run.

### T4. Literature: one high-upside investigation, four smaller owed items, framing deferred

*Untouched by any review pass so far, all of which stayed inside the documents. Four passes are written up in `literature-findings.md`, which carries the reference convention (`` `aod` ``, `` `notes` ``, `` `ep` `` prefixes; a bare § belongs to a cited paper). Two candidate follow-ups are **deliberately not on the list** — running our CSP against Angel–Borja's surviving types, and chasing the two-orbital criterion computationally — because the exhaustive n = 10 and n = 12 batteries already validate the machinery more strongly.*

**Outstanding, and it is the item with the most upside in this file.** Skorobogatov–Sofos (*Inventiones* 231, 2023) prove Schinzel's Hypothesis on average and use it to get a *positive proportion* of varieties with rational points — the move being that one does not need the full conjecture, only that most polynomials satisfying the obvious necessary condition represent at least one prime. **That is structurally `aod` §4**, which needs not an asymptotic at every n but only that for almost every admissible n *some* shape in `aod` §6's finite feasible set is realised. If the averaging works over our shape families, §4's density claim moves from conditional to unconditional, which changes what the paper is. Obstacles to check: the coprimality budget means our family is not a generic family of polynomials, and their result is for linear polynomials in several variables, which fits our two-part shapes better than the fused ones. **Read before `aod` §4 is written, not after.**

**Answered, and recorded where they live:**
- *Does Shparlinski's fixed-residue exclusion bind on us?* No — everything needs only r ≡ 1 (mod Q). But Friedlander–Granville III shows fixing the residue buys nothing at the endpoint, so (BCG)/(BCP) must come from a counting or sieve argument tolerant of irregular moduli, not a level-of-distribution statement. → `shparlinski-constants.md` §7.5.
- *Does the almost-all step survive a thin set?* Yes: Balog–Sárközy needs only cardinality, so thinness costs a logarithm. What blocks a floor is the companion exponent, and (BCP) at ρ ≍ 1/log^C x gives n^{2−ε} for almost all n. → `aod` §6.8(iv), `shparlinski-constants.md`.
- *Sárközy–Stewart's hypothesis:* checked — it needs positive relative density, so the two-logarithm endpoint gap stands. → `shparlinski-constants.md` §9.

**Still open from that reading:** whether any endpoint-capable sumset result tolerates a 1/log²x set. It is a genuine literature search, and it should rank above the fixed-residue question, which attacks the input side where the difficulty is not. Balog–Sárközy's proof internals were not re-derived, and Sárközy–Stewart's original (series I–V) was not read.

**One comparison replaces a reading task.** `literature-findings.md` items 4 and 17 identify Black's spacing framework (ITCS 2015 / ACM ToCT 2019) as containing the sub-board Fourier-degree route, p-group hypothesis included. The specific question: **does our group data give better spacing at composite non-prime-power n than the sequences already in the literature?** Compute spacing for the orbit augmentation sequences our batteries supply. *That route wants many small orbitals, the reverse of the max-m\* battery selection.*

**Four primary-source checks owed before publication.** Three are flagged in `aod` §3.6: the θ = 1/4 rung is attributed to Bombieri–Vinogradov on Shparlinski's framing rather than from the original; the Chowla row names a conjecture-type rather than a specific paper; and the two Elliott–Halberstam rungs are quoted in the form n^{3/2−ε} and n^{2−ε} by inference, since Shparlinski's §5 states those improvements without writing an exponent. The fourth sits in `aod` §5 and the `notes` reference list: **the Ω(n²/3) bound is attributed by at least one survey to unpublished work of Santha–Yao rather than to Scheidweiler–Triesch**, whom we cite alone.

**The step we are missing, and it is elementary.** Jones–Zvonkin's programme (`literature-findings.md` item 20) verifies Bunyakovsky's conditions explicitly for each polynomial. **`aod` §3.5 asserts an ample supply without doing the analogue** — checking, per shape family, that the relevant system satisfies Schinzel's conditions and has no fixed prime divisor. A page of work per family; a shape with unbounded exponent has no polynomial to check, which is itself the finding.

**Deferred: the framing decision.** Jones–Zvonkin's programme is also the model for how this genre states its standing. Three consequences are recorded in `literature-findings.md` items 14–16 and are *not* being acted on yet: a standing table at the front of `aod` §3; the polynomial-versus-exponential line in `aod` §3.5; and the Catalan/Pillai caution for S1 and S2.

*The Zhang/Maynard analogy (why bounded-gap methods cannot give bounded D) and the bounded-cofactor density measurement are archived in session-log-15 §37.*

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

*Second reading done: both branch derivations re-derived, the census walk re-checked, the three smaller steps resolved, and §6.8(ii)'s window-endpoint defect fixed — all now stated in `ep` F.4 and `aod` §6.8. What remains single-sourced is Lemma B′, which is T1's item. The working is archived in session-log-15 §37.*

**The step everything rests on: why must the foreign twist Q be a prime power?** Branch (b) is vacuous without it. The confinement is Lemma B′'s content — a foreign block's translations occupy the abelian cyclic layer, forcing its twist into the top q-group — so the question is "is B′ right?". **Layer-assignment claims remain the category with the worst record here**, so the reliance stays visible.

**Re-check on any restatement:**
- **The branch asymmetry.** A matching class's twist may be the full c − 1, so the all-matching branch yields no arithmetic statement, and F.4's multiplicative case must be a genuine alternative. An earlier draft got this wrong.
- **Joint, not separate, bounds.** F·r ≤ n and F·c ≤ n jointly. This has been the defect twice (S9's fused foreign class, and the spurious 2/δ₀²). Both branches now carry the same constant, so a slip that makes them differ is itself a signal.
- **Endpoints quoted exactly.** §6.8(ii)'s c = δ₀/2 needed one side open (now Λ > 2/δ₀ strictly) — the third such defect after F.1/E′ and D2′.
- **C(n,2) versus n²/2**, and the orb halving at even twist only (F·r·Q is tight at odd Q).

**Open:**
*Last `converse_check.py` run: 2026-10-19, all of [6, 10⁶], 0 violations; the control fires (R1 runs it on every batch).*

1. **The sharpening question:** D(δ₀) = 2(1 − √δ₀)²/δ₀ = 26.7 at the floor, against the measured maximum cofactor 12 — loose by about 2.2. The measurements test the inequalities, not the derivation.
2. **(BCP)'s two asserted properties** (`aod` §6.8): that a floor implies it, and that it does not imply a floor. The second is open, not impossible; its blocker is the companion exponent (T4).

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

> **Keep it fast — a design constraint, not a nicety.** About 0.1 s on 1,700 rows, 1 s on 50,000, 3.5 s on 144,000, which is what makes it reflexive rather than scheduled. Keep each check O(rows) or O(rows × parts) on numbers already parsed from the witness; enumeration, isomorphism work or re-deriving B(n) belong in a certificate. **`main()` is subject to the cost model too** — a quadratic gap scan there once took 47 of 51 seconds at 50k rows. Re-time when the table's scale changes. *(The fix's account is archived in session-log-15 §37.)*

### A9. The Lean formalisation — keep it in step, and keep it moving

*Home: the Lean project's own `README.md`, which carries the phasing, the case for and against, the failure-mode analysis, the build recipes and the environment gotchas. **This item exists so the work resurfaces even when nobody thinks to mention it**; do not restate the reasoning here.*

**State.** Phases 0 and 1 are done: `ArkCore.lean`, `Note.lean` and `Basic.lean` are all sorry-free (`ArkCore` reproduced in a container against core 4.15.0 with no Mathlib). Proved: `orb_full`, Lemma D1, the capacity bound, Prop F.1, the E′ s-bound and both threshold ladders, the `capF` algebra, all six §3.3.5 ceiling entries, the two-foreign closed form, and the quadratic-residue collapse. What stays conditional is `HypBCG` (the note's (BCG_{1/5})) and Oliver, neither formalisable.

**Two obligations.**
1. **Sync — the one that rots silently.** Nothing in this repository's checks looks at `.lean` files. Any revision to §3.3.5's table, the cap algebra, `orb`, or the E′ s-bound should be followed by a pass over all three files. A document changing a constant now contradicts a *proved theorem*; `Basic.lean`'s ceiling list has six entries, so a table that gains or loses a constant no longer matches.
2. **Progress.** **Theorem E.5 is the highest-value next target** — arithmetic on SAFE terms, one human reading plus a machine second reading (2026-10-19), load-bearing for "μ\* known exactly to 10⁶"; the README predates it (Phase 1b). **Started 2026-10-19:** `E5Core.lean` (core Lean, zero sorries) proves E.5's counting and congruence steps. Lemma E.2 and both the Mersenne and repunit windows are covered too. The odd-q leftover sub-case is assembled end to end (`odd_q_leftover`). **What remains is the SAFE model and the assembly of E.5's statement over it** — a design decision about how to represent configurations, best made together. Mathlib reconciliation is planned in the Lean README. Also cheap: `μ*(n) ≥ n·(Q(n) − 1)/2` and the self-pairing lemma `orb c d = c·d/2 ⟺ d even`. Phases 2 and 3 are not owed.

**Two lessons to carry:**
- **Check k = 0 first** on any "k things each with property P force a bound" claim: `prop_F1` was false as stated, the same failure as `size_of_capacity`.
- **Prefer tactics or long-stable lemmas over named iff-lemmas.** Two of three build failures were Mathlib name drift.

**What it is not for.** It does not check the group theory or any layer-assignment claim, which is where this framework's defects have been.

*The fuller state notes, techniques and environment lessons are archived in session-log-15 §37.*

### A21. A fusion-aware penalty for the partition-factor table

*The table itself now lives in `shape-counting.md` §4; this is the live remainder.*

The all-shapes **penalised** column (`shape-counting.md` §4) is a **lower bound**, not an exact count. Its penalty `x ≥ √(δ₀F)·(1 + 1/p)` comes from the density ceiling, which prices the smaller class at C(c′,2) — the *unfused* reading — so it is too harsh on a shape whose smaller class is fused, by exactly the factor fusion supplies. `n = 640 = 1·256 + 3·128` is the witness: penalised cost 4.10 against L = 3, rejected, yet a real configuration at δ = 0.1192.

**What to do:** derive the penalty for the fused reading (the smaller class is worth F′·C(c′,2), so the requirement should scale with √F′ rather than being charged per size-group), and recount the three all-shapes entries. Expect them to rise, staying between the current penalised figures and the unpenalised 34 / 115 / 357.

**Priority: low.** The top row is unaffected — a fused unequal shape needs n to be a sum of two distinct p-power multiples, a density-zero condition that puts it among §6.5's escapes rather than in the covering accounting — and §6.6's covering statement quotes N_add, which is counted directly and never uses this table. So the exposure is to a commentary figure, and `shape-counting.md` §4 states the direction of the error.

### A24. Is the shape space complete?

*Now load-bearing for a second claim, and that is new.* Until n = 2759, completeness carried only the μ\* ≤ B direction of the certified range. It now also carries the framework's **one exact value of μ\***: the pinch at 2759 gives μ\* = 175813/3804661 *granting* μ\* ≤ B_safe, and a missing shape would make B too small there, so the true μ\*(2759) would be larger and both the minimum and its uniqueness would move. The failure runs the safe way — the floor would be an understatement, never an overstatement — but the *exactness* is exactly as strong as this item.

The ceiling table is a theorem about the Oliver-admissible family **as currently characterized**, and the entangled-generator correction showed that characterization can be wrong in the permissive direction — a whole family was excluded by an argument that confused a quotient for a subgroup. **Nobody has searched for the optimal admissible family**, in this project or in the literature: BBKN had no reason to, since below the endpoint any admissible family gives the same order (`literature-findings.md` §15b). So the literature's silence is evidence neither for nor against the entangled construction's optimality, and this is the one place a further constant factor could still be hiding. No cheap test is known; the honest status is that the ceiling is a ceiling *over what we have enumerated*.

### A25. The transference route from (BCP) to a floor

`bcp-to-floor.md` §6.2 files it: S_D under (BCP) has positive relative density inside the Selberg majorant for the pair `{Q, dQ+1}`, whose pseudorandomness is sieve-provable, and a restriction/transference estimate for `n = kp + r` against that majorant would give the representation for almost all n with **no distributional hypothesis on S_D at all**. §6.1's counterexample marks the boundary any such argument must respect — the count alone is provably insufficient — so a successful transference must consume the unconditional sieve upper bounds. A research question, not an afternoon; filed here because it is otherwise homeless outside a one-pass working note.

### A26. The note before circulation: one decision, one mismatch

*Re-read 2026-10-17; the decision remains Vipul's.* `mu-theta-n2-note.md` is correct on its own terms; its hypothesis is (BCG_{1/5}), non-nesting with the framework's (BCG-AL) in both directions (`note-to-framework-bridge.md` §4). Its §5 θ-ladder agrees with `aod` §3.6 at every rung and attribution.
- **Decide:** whether the note mentions the F = 4 shape. *Recommendation:* stay silent in the Theorem and proofs (the note's family is the unfused one, and naming F = 4 invites the non-nesting confusion); at most one sentence in §4 saying the constant is not optimised.
- **Mismatch inside `aod`, not the note:** §3.6's table gives "all large n" for the Chowla and Elliott–Halberstam rungs, while its own blockquote says the 3/2 rungs carry O((log x)⁴) exceptional sets. Needs BBKN Thm 1.4(a) and Shparlinski Thm 1 to decide.
- **Wording in the note:** §5 calls (BCG_{1/5}) "of Goldbach rather than Bateman–Horn difficulty" and then its prime-factor clause Sophie Germain-type. Say "Goldbach as well as Bateman–Horn".
- **Keep out before circulation:** `aod`'s conditional PD(1) row (unrefereed).

### A34. Review the minimum-order result — answered, with three lemmas awaiting an independent reading

**The question is answered** in `johnson-presentations.md` §5a: the minimum order of an Oliver group on n points with minimum orbital ≥ δ·C(n,2) is **Θ(n²)** at prime powers, **Θ(n³)** at bounded-cofactor n (a Reed–Solomon construction, built and verified at n = 21, 39, 55), **Θ(n⁴)** at almost all even n and **Θ(n⁵)** at almost all odd n. The measured witness orders sit in fixed bands across five decades (order/n⁴ → 0.0312 even; order/n⁵ → 0.00196 odd), which is what the earlier "exponent 3.5–4.5" was.

**What is still owed** (Lemmas 1–3 were read independently and refereed 2026-10-17, with a written-out repair for intermediate P at a ≥ 2; `johnson-presentations.md` §5a box):

1. **The claim that every alternative configuration costs at least as much at generic n** — the lower bounds are per-shape, and the minimum over shapes rests on the census being complete, i.e. on **Part 0**.
2. **The exceptional-set density argument** — that twist-sharing needs a large prime-power divisor on n − 2 or n − 3 from a prime whose powers reach [δn, n], with probability about |log δ|/log n per exponent window. Heuristic in its current form.

The upper bounds for generic n are conditional on the same bounded-cofactor supply as μ\*(n) itself.

### A36. The weighted restriction game beyond n = 10

*Settled 2026-10-17:* value **40** at n = 10, so every nontrivial monotone graph property on 10 vertices has D ≥ 40, and D ≥ C(n,2) − n/2 wherever a solvable 2-homogeneous Oliver construction exists (`restriction-game.md` §6a; session-log-15). *Owed:*
1. **Novelty check:** Scheidweiler–Triesch's full text (paywalled) and Angel–Borja's citation list are unread. Two searches have found nothing (best n = 10 figure in print: 21).
2. **Beyond 40 at n = 10:** multi-step descents or a larger catalogue (this catalogue's maximum interval value is 40), and `restriction-game.md` §5's case tree with guard-conditioned k-partite leaves.
3. **Other n:** other orbital pairs whose complementary graph embeds in the large orbital, and the n = 18 two-step descent.

### A37. Non-maximal Oliver groups at the χ rung — one residue

*Answered* (TOM stage and `oliver_tom.g`; literature in `literature-findings.md` entry 23). **Left:** the uncapped band — 183 Oliver classes at n = 10 with 13 ≤ t ≤ 45 — as a post-check battery on SAT candidates (`small-degree-computation.md` §7.2). Not built, since it needs pipeline candidates not in this directory.

### A38. Open questions on the metaproperty ladder (`oen` §§7.2, 7.4)

1. **Separations.** *Settled:* global-χ-resistance does **not** imply Oliver-resistance — 148 counterexamples at n = 6 from a targeted exhaustive search, one verified by brute force. *Settled for graph properties at n = 6* (`oen` §7.9, exhaustive over template profiles): Oliver-χ ⇒ nontrivial-top is strict (16 witnesses, 2 with global χ = 1) and nontrivial-top does not imply global-χ (14); one witness of each verified independently. The random sample had simply missed them. An exhaustive n = 6 run is **infeasible in Python here**: the 24 classes of 7-edge graphs already give 2²⁴ ≈ 1.7 × 10⁷ distinct antichains, hence at least that many monotone properties, at several milliseconds each; it would need a compiled implementation with pruning. *Weakly symmetric analogue settled* (`oen` §7.6): for A₅ on K₅'s edges, Oliver-χ ⇒ nontrivial-top is strict (272, 44 of them with global χ = 1) and nontrivial-top ⇏ global-χ (228), so any proof of either for graph properties must use S_n specifically.
2. **The largest-invariant-bipartite-graph conjecture** (formerly "cone conjecture"). At n ≡ 2 (mod 4) every transitive group should have a unique largest invariant bipartite graph. **Verified on every transitive group at every n ≡ 2 (mod 4) up to 46** (16,712 groups, the whole library at those degrees, Oliver or not; `bip_union_scan.g`), so bipartiteness is vertex-transitive Oliver-χ-resistant at every such n ≤ 46. *Proved*: the parity lemma and its three consequences, the reduction to a quotient of the same shape, the two-block case, perfect matchings inside components, and every group whose point stabiliser is normal in the stabiliser of its component of W (`oen` §7.4). *Reduced* (`oen` §7.4): the conjecture is equivalent to the half-swap characters extending to one character of L. The extension is computed to be ε_U, the sign on U's halves, for every U at every degree checked (`bip_halves_sign_check.g`). *Sylow form* (`oen` §7.4): the conjecture is equivalent to **no element of S ∖ T fixing a point of D**. Here T is a Sylow 2-subgroup of the point stabiliser, S ⊇ T a Sylow 2-subgroup of L, and L the stabiliser of x's component of W. The focal subgroup theorem then supplies the colouring character. *Proved*: the same statement restricted to the fixed points of T (via Witt and a group of order 2·odd), and the case of a point stabiliser of odd order. *Computed*: the fixed-point-free condition holds at every degree to 46 (`bip_sylow_check.g`). *Open*: the fixed-point-free condition itself, i.e. that L, being generated by component stabilisers, fuses no element of S ∖ T into T. A₄ on six points shows the generation hypothesis cannot be dropped.
3. **Bipartiteness at the small-global rung.** *Proved for every n ≢ 2 (mod 3)*: B(n) is odd exactly there (`oen` §7.4). **Proved 2026-10-17: B(n) ≡ [n odd] (mod 3)** (sinh² identity, `oen` §7.4), which settles every odd n and hence n ≡ 5 (mod 6). *Computed for all n ≤ 300.* **Further, same day:** B(n) mod p has period p − 1 (Stirling expansion of F(eˣ − 1)), so p | B(n) whenever (p − 1) | (n − 2). Primes with p − 1 | 240 then cover every n ≡ 2 (mod 6) except **n ≡ 2 (mod 240)**, which is now the only open class beyond the computed range (n ≤ 300). *Refereed* by an independent agent: (2) and (3) need odd p, and (3) needs n ≥ 2. *Checked* in that class to **n = 10⁷**: every value has an odd witnessing prime ≤ 67. No finite set of primes can close it, by the same corollary, so it needs an argument producing a prime p ≤ n with (p − 1) ∤ (n − 2) at a non-vanishing residue.
4. **How far do graph properties climb?** *Answered at n = 6*: to ℚ-acyclic but not ℤ-acyclic. The 151 χ = 1 properties of §7.1 are not ℚ-acyclic, but the Oliver-χ-resistant dual pair of §7.9 is ℚ-acyclic with torsion at 2 and 3 (an earlier version of this item said no graph property at n = 6 is ℚ-acyclic; corrected). Open at larger n.
5. **A natural χ = 1 example.** The resistance side of global-χ ⇏ Oliver-resistant is explained (sub-properties of "no perfect matching"), but no natural property with χ = 1 has been found; the 148 were found by search (`oen` §7.2).

### A39. Weakly symmetric functions: the Oliver-χ ⇒ ℤ-acyclic gap

*Found* (`oen` §7.6): for A₅ on the 10 edges of K₅, 44 of 3,176 nontrivial invariant functions are Oliver-χ-resistant and none is ℤ-acyclic. A weakly symmetric ℤ-acyclic example already exists (Lutz's complex A, `monotone-transitive-note.md` §6); the gap between ℤ-acyclic and non-evasive is that note's question. *Next*: (1) between A₅ and S₅, which conditions kill the 44 — how much of the gap S_n's extra Oliver subgroups close; (2) the intermediate rungs (𝔽_p-acyclic, ℚ-acyclic) for these functions.

### A40. How far do the small-orbital tests reach?

`oen` §7.7 proposes a susceptibility algorithm from Oliver groups with t ≤ 3 orbitals, blow-up descent, and a parity principle. *Measured* (`oen` §7.7): n = 6 sample, t ≤ 2 kills 87.6%, t ≤ 3 99.9%, t ≤ 5 all; self-dual properties silent on every even-t group and killed at t = 3; n = 10, all 61 natural properties killed at t ≤ 3. The n = 10 run was an inline script, not saved as a file. The small-t case analysis the algorithm relies on is §9.7's fixed-complex table (two-orbital case credited there to Angel–Borja); §7.7 now cites it. *To work out*: which n admit which two-orbital shapes (entanglement conditions); whether the constraints are inconsistent for all nontrivial P at some n beyond prime powers.

### A41. Smallest susceptible orbital count, and template profiles

*Recorded* (`oen` §§7.8–7.9): τ(P, n); the block-chain lemma (t ≥ ω(m) for transitive Oliver groups); τ ≤ min(σ(P), σ(P*)); the one-point and pair extension lemmas; τ(bipartite, 14) = 4; template profiles, with 20 properties surviving every t ≤ 3 condition at n = 6, among them **two Oliver-χ-resistant graph properties, neither ℤ-acyclic**. *Open*: (1) machine-check the classification of t ≤ 3 groups behind "τ(bipartite) ≥ 4 at n ≡ 2 (mod 4) unless n − 2 is a power of 2" — *partly done*: τ = 3 verified at n = 6 and 10; the τ ≥ 4 half needs the Oliver groups at n = 14; (2) is τ bounded for natural properties as n grows; (3) the template-profile search at n = 10, where the large/small distinction is sharper; (4) *described* (`oen` §7.9): P₁ = bipartite and caterpillar-free, P₂ = no 2K₃, K₅ or X; *explained* group by group (40 cones, 7 acyclic 2-group complexes, 2 cancellations); *does not generalise literally* — five analogues all fail at n = 10 against t ≤ 8 groups. Finding resistant graph properties at n = 10 needs the template-profile search there (item 3). *In progress* (`oen` §7.9, `n10_search/`): a counterexample-guided CP-SAT search is feasible through every group with t ≤ 11 (each level checked completely); at t = 12 the solver returned UNKNOWN (5,318 templates) and a longer re-solve was killed, likely memory — next: re-solve with 1–2 workers and the t ≤ 11 solution as a hint; remaining after that, a method for the t > 12 classes (exact global χ by component DP; the others open).

*Structure so far* (`oen` §7.9): no bipartite-only property satisfies the t ≤ 11 constraints (infeasible from the t = 6 groups on); a re-solved t ≤ 11 solution has 178 cone, 21 acyclic and 15 cancelling fixed complexes among its 214 active groups. *Also found*: the re-solved t ≤ 11 solution violates χ = 1 at 22 non-active non-cyclic 2-groups (`oen` §7.10), so it is not a full t ≤ 11 solution. *Open*: a minimal set of groups forcing the bipartite infeasibility (the extraction run was killed — rerun with fewer solver workers); re-check the re-solved solution against every t ≤ 11 group; a structural description of a solution (steering the solver, e.g. by minimising the number of templates, may give a cleaner one).

**Running the n = 10 search on your own machine** (`n10_search/`). Running longer settles t = 12 and probably a little beyond; it cannot finish the job, because the 183 classes with t > 12 (the trivial group among them) need new code — union enumeration is 2^t per group.

*Setup.* Python 3 with `pip install ortools networkx pynauty` (networkx is needed to unpickle the saved state); a C compiler. Compile the embedding library for your platform, in `n10_search/`: `gcc -O2 -shared -fPIC -o libemb.so emb.c` (the shipped `libemb.so` is a Linux x86-64 build). The scripts expect `tom10.txt` one directory up (the project directory); override with `N10_TOM10=path`.

*Run*, from `n10_search/`:

```
N10_WORKERS=4 N10_RESOLVE_TIMEOUT=3600 N10_SOLVE_TIMEOUT=1800 python3 loop2.py 12 36000
```

Arguments: the largest orbital count t to check (12), and a wall-clock budget in seconds. Environment: `N10_WORKERS` solver threads (default 8; lower it if memory is tight — memory is what killed the last attempt), `N10_RESOLVE_TIMEOUT` for re-solving the saved stage, which is currently UNKNOWN (default 600 s), `N10_SOLVE_TIMEOUT` per round (default 300 s), `N10_STATE` for the state file (default `n10_search/state.pkl`; it is overwritten after every round, so copy it first if you want to keep the current one).

*Reading the output.* Each round prints how many groups it added and whether the stage is feasible. "PASSES every group with t ≤ 12 (all checked; …)" means done for t ≤ 12; then try `loop2.py 13`, `14`, … while it stays tractable (2^t unions per group). "INFEASIBLE" would mean no monotone property satisfies the active groups — no resistant property at n = 10 exists — worth reporting at once. "UNKNOWN" means the solver ran out of time: rerun with a larger `N10_RESOLVE_TIMEOUT`. "TIME BUDGET HIT" means rerun; progress is saved.

*Send back*: the console output and the final `state.pkl`.

*Tested here*: a smoke run from the project directory with only environment variables set loads the state, re-solves, and stops cleanly. Not tested: any platform other than Linux x86-64.

### A42. Information-theoretic variants

*Recorded* (`oen` §7.11): invariant subcube partitions ⇒ exact χ = 1 at the group; certificate-evasive = the two trivial properties; one-shuffle reduction; bipartiteness secret-shuffler non-evasive for n ≥ 4; the conjecture secret-shuffler evasive ⇔ certificate-evasive, checked exhaustively at n = 4. *Open*: (1) does non-evasiveness imply orbitwise non-evasiveness (the fixed-point question for decision trees)? (2) do the n = 6 resistant pair admit Γ-invariant proper subcube partitions for their Oliver groups, or an S₆-invariant one, and is that forced by their cone/acyclic structure? (3) the conjecture in general (verified at n = 4 and n = 5, `oen` §7.11); (4) prove the n ≤ 7 lemma for the original bipartite protocol, or drop it for the walk-and-check version; (5) record-level check of the table's protocol sketches.

### A43. Self-duality of collapsibility and contractibility

*Recorded* (`oen` §7.12): collapsible ⇒ K\* contractible (PL sketch); the dual-of-join formula; Lutz's 60-vertex complex has contractible dual; ~60,000 random collapsible complexes (N = 6–9) all had collapsible duals. *Open*: (1) collapsible ⇒ K\* collapsible, via a targeted search (not random expansions) or an argument; (2) contractible ⇒ K\* contractible **when dim K ≥ N − 4** — below that it holds by general position plus Alexander duality (`oen` §7.12), which also settles the dunce hat; (3) write out the PL argument in full; (4) collapsibility of Lutz's complex K = A ∗ A′ or its dual. A itself is not collapsible (π₁ = SL(2,5)), and greedy collapses of K stall (`oen` §7.12).

### A45. Random monotone properties

*Recorded* (`oen` §7.10, expanded): the uniform model, the duality identity, exact membership at n = 4, 5 and sampled at n = 6, the fractions reached by the sparse and biclique criteria, the ladder rungs on random properties at n = 6. *Open*: (1) a Korshunov-type theorem for the graph poset (literature check); (2) the anti-concentration conjecture — almost every monotone graph property evasive via global χ — and whether it is already known; (3) resistance → probability 1 is heuristic and not visible at n = 6; (4) a sampler at n = 10 (needs a representation not enumerating graph classes).

### A46. The OpenAI batch as a conditional input

*Recorded* (`arithmetic-of-density.md` §3.6, `literature-findings.md` entry 24): the conditional PD(1) row and its dependency chain; family 003's zero-free region does not help (exponent at most 1 + 1/8). *Open*: (1) watch github.com/openai/math (`lean/formalization.yaml`) and the literature for verification of families 011 and 029; (2) whether Prop. 2.1's control of v₂(p − 1) and the residue class mod M matters for the ceiling analysis; (3) if anything becomes formalized, audit the Lean statement against the paper.

*Side remark, not needed for the θ-ladder (which uses only p − 1):* the PD(1) argument appears to give the same law for p − a₀, for every fixed a₀ ≠ 0, **with no a₀-dependent correction**. The statistic only sees prime factors ≥ exp(L^0.1), and all of those are coprime to a fixed a₀. (The shift is written a₀ to avoid our c, r in n = Fc + r and the paper's a, b, c.) Where the shift enters:
- PD (3.10): the target becomes t = a₀(b − a), with a, b the paper's moduli.
- PD Lemma 7.2: the progression class is ℓy ≡ −a₀ (mod r).
- PD (7.21): the model probabilities are unchanged for p ∤ a₀.
- Companion §6.5: the determinant identity becomes mh′ − m′h = ka₀ instead of k; the converse needs (m, ka₀) = 1, which holds since m is W-rough.
- PD Theorem 6.1: its proof already handles a family of shifts kD and isolates the unit shift at the end; with shift a₀, the raw term has shift a₀.

*Read:* PD §3.1, §3.4, §7 in full; the Theorem 6.1 statement and the paragraph after it; companion §6.5. *Not read:* PD §4–5 (where the shift should appear only as the scaled target), the rest of the §6 proof, §8 (skimmed), and companion §5. The paper itself states only p − 1. The method's generality belongs in a one-line remark after Thm 1.1 that the paper doesn't have. The interesting extension is uniformity in a₀ growing with x, e.g. |a₀| ≤ L^A or x^δ. That strains the |k| ≪ L^{O(1)} bounds and the "band primes ∤ a₀" step. No route to ask the producers: the repo has issues disabled for outsiders.

### A47. Single-shape non-evasive properties (oen Open Problem 6)

*Settled* (`oen` §9.6): the smallest n is **6**, with 21 non-evasive single shapes (2 at D = 13, 19 at D = 14), each verified by an explicit tree checked on all 2^15 graphs. *Open:*
1. A human-readable algorithm for the D = 13 shape. The two-cherry opening is forced; the rest resists greedy and phased rules.
2. Why these shapes work. Unique witnesses explain the parity for 17 of 21, but 149 evasive survivors also have them.
3. The same analysis for the D = 14 shapes and the four without unique witnesses.
4. n = 7 (2,302,938 shapes): the same pipeline with the signed-sum prefilter; the D computation over 3^21 subcubes needs a symmetry-reduced solver.

### A48. Regular actions and the coset template (`monotone-transitive-note` §5b)

*Recorded:* the regular action is universal for both versions; counting in it gives exactly Rivest–Vuillemin; the design equation; Illies's construction is non-evasive at all 28 choices across the five groups of order 12; the exhaustive template search at orders ≤ 15 finds only order 12; monotone pieces in pairwise-trivially-intersecting subgroups never give a contractible complex (proved, §5b). *Open:*
1. D₁₂ and C₂ × C₆ in the template search (35–45 orbits; needs a smarter enumeration than all unions).
2. Solve the design equation with richer piece menus and test larger groups (orders 18, 20, 24, then A₅). Needs a decision-tree solver that uses the coset structure, since D on 2^|G| inputs is out of reach beyond about 16.
3. Prove Illies-type non-evasiveness from the local structure at a point, so that order-12 genericity becomes a theorem, and find which other local configurations admit such a proof.

*Notation (2026-10-17):* μ(n) is now **μ\*(n)** throughout the current documents, with all variants starred (oen §1). Archived logs and code (script names, identifiers, the `mu-theta-n2-note` file names) keep `mu`.

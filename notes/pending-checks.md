# Pending checks

*What is left to run or verify, for the arithmetic programme — `orbital-evasiveness-notes.md` §§1–6, `enumeration-proof.md`, `arithmetic-of-density.md`. **Outstanding work only** — anything closed moves to a session log and is not restated here.*

> **The computational programme is mid-rebuild; every pillar needs a run against the current scoring.** The SAFE cap is the flat F·C(c,2), which invalidates any table or ladder computed with a twist cut by the block count, so what would otherwise be settled bounds are runs in progress:
>
> - **R0 — the table.** `mu_enumerate_v3.py` is rebuilding. The contiguous frontier is wherever that run has reached, and every distributional figure keyed to a wider range is provisional until it lands.
> - **R7 — the ladder.** `ladder_verify.py` now scores rung B at the full twist and keys its `CAP` table mod 12; it wants a fresh 10⁶ scan, and the worklist and the floor it prunes against both move with it.
> - **R8 — realisability.** `verify_witness.g` now builds fused classes with the entangled generator and carries three regression witnesses; the battery wants running, and beyond repeating it what is owed is **width**, at the fusion counts that set the class ceilings.
> - **R1** gates all of these and runs against whatever the current table is. The certificates are **unblocked** — condition (4) no longer strips the block count — so they are a rerun rather than a hold.
>
> Nothing here should be read as "a further run happens only if a bug is found." The runs are owed because the scoring changed, not because anything is currently suspect.
>
> **What does NOT need redoing: the table itself.** The enumerator's scoring is what it was when the current rows were computed — the flat SAFE cap, the same `orb`, the same coprimality condition — so rows already written are current values, and a run in flight can continue. The reruns below are all of things *downstream* of the enumerator or of scripts whose own scoring changed. If in doubt about any artefact, the test is whether the script that produced it appears in the list below.

> **Every run currently owed, in one place.** Each is expanded at its own item; this is the index, so that nothing is owed only inside a paragraph.
>
> | run | why it is owed | item |
> |---|---|---|
> | `mu_enumerate_v3.py` (extend) | the contiguous frontier is short of where the documents' figures want it — an extension, not a redo | R0 |
> | `validate_table_v3.py` | gates everything else; run on every batch | R1 |
> | `fallback_cert.py`, both modes | unblocked; its coverage counts are quoted nowhere until requoted from a run | R1 |
> | `wide_cert.py` | same, plus `fused_lo` now admits composite block counts, which raises B_lo and shrinks pass 2 | R1 |
> | `a18_verify.py`, `t5_verify.py` | range-scoped dominations that expire silently as the table grows | R1 |
> | `check_doc_figures.py` | the pass that replaces ⟦PENDING-REBUILD⟧ figures | R1 |
> | `ark_shapes.g` wide sweep | the previous output was truncated mid-line, so its later rows are untested | R6 |
> | `ceiling_rederive.py --no-filter` | the candidate list admitted non-prime-power block sizes, so earlier unfiltered output mixed real escapes with phantoms | R6a |
> | `audit_fmid.py` | the only artefact behind the shared-block-count admission, and it reads the table | R6b |
> | `ladder_verify.py` | rung B now scores at the full twist and `CAP` is keyed mod 12; floor, worklist and per-class reporting all move | R7 |
> | `verify_witness.g` | rebuilt around the entangled generator, with three new regression witnesses; it has never been run in this form | R8 |

> **The table is a contiguous prefix plus a biased tail.** Rows above the contiguous frontier are worklist rows, not range, so every distributional figure is quoted over the prefix — see R0. Read counts of the read-pass state in the session logs; this file carries only what is outstanding.

**Small-degree work lives elsewhere.** Everything pursued at a single fixed degree — the GAP battery, the CSP and its backbone probes, the χ machinery, the template enumerator — is in `small-degree-verification.md`, including its own run list. It touches this programme at exactly one point: **exhaustiveness of the GAP stages**, which licenses Part I's two non-circular comparisons at n = 10 and n = 12. Nothing else there gates anything here.

**Companion files.** The three documents hold the results and their figures. `three-part-family-split.md` is **deprecated**: the competition it analyses does not exist, since the fused rung beats the others at every c once the twist is full. It is kept only for the three results flagged in its header banner. `fusion-count-ceilings.md` records the derivation of §3.3.5's ceilings as a joint optimum over (F, η) — kept as a separate note because it carries the working and the measurements, which do not belong in a document that states only current understanding. `solvable-relaxation.md` computes the same extremal problem with Oliver's condition relaxed to bare solvability, isolating what the chain costs; it is a calibration exercise and nothing in the main line depends on it. The review record is in the numbered session logs, `session-log-8.md` being the current one. Literature findings, which bear on framing rather than correctness and are deliberately not folded into the primary documents, are in `literature-findings.md`. The standalone short note (`mu-theta-n2-note.md` and its LaTeX twin, kept identical in content) states the Θ(n²) result with lower bounds only; `note-to-framework-bridge.md` is its standing consistency check against these documents — **re-read the bridge's §0 hazards and requote its §2 figures whenever a framework figure the note imports moves**, the imports currently being the ladder floor with its range and argmin, and the mod-12 ceiling values. The **Lean formalisation** of the arithmetic layer — `Basic.lean`, `Note.lean` and its own `README.md`, which is the home for its phasing and its rationale — tracks these documents' claims and can fall out of step with them silently; see **A9**. Single-small-degree work — the GAP battery, the SAT/CSP machinery, the backbone probes, the template enumerator — is in `small-degree-verification.md`, which touches §§1–6 only through the n = 10 and n = 12 exhaustive comparisons cited in Part I.

**Status labels.** *Verified* — an independent computation agreed. *Sound* — an argument was read and found correct, with no independent computation. *Unverified* — neither.

*Do not restate the inequality as `B_safe ≤ μ`.* `B_safe` deliberately over-counts per configuration, so B_safe and μ are incomparable in general; what holds is B_refined ≤ μ ≤ B_safe, with the endpoints collapsing wherever the certificate applies.

## Where the residual risk sits

Ranked, so the sections below have a stated basis. This is not the order the items appear in.

1. **The table's reach, and the fact that it is currently in motion.** Everything measured across the three documents is keyed to the table's frontier and the ladder's, and **both are being recomputed** — the table by `mu_enumerate_v3.py`, the ladder by a patched `ladder_verify.py` that has not yet been rerun. Until both land, the recorded figures are provisional rather than merely extensible, which is a stronger statement than this item used to make. → **R0**, **R7**, and **R1** after every batch.
2. **Exhaustiveness of the GAP stages.** The subdirect-product hole is undischarged. It degrades *evidence* rather than creating an error — a missed group with larger m\* would be a counterexample rather than a silent corruption, and one with smaller m\* changes nothing — but it is the only non-circular check in the framework. **This is the one small-degree item the arithmetic programme depends on**, since Part I's two exhaustive comparisons rest on it. → `small-degree-verification.md` item 5
3. **Part E's realisability construction.** Attainment's other leg, argued in general and checked at seven configurations from n = 10 to 308, under the superseded script, and none of them at the fusion count that sets the ceiling at n ≡ 11 (mod 12). It has no per-n verification. → **T2** for the argument, **R8** for the run that would close most of it.
4. **§3.3.5's ceilings.** Both coordinates of the joint optimum are settled without a search — the F side by cap_F(1) = 1/(1 + √F)², the η side by the congruences of §3.3.4a — so what remains is the supply hypothesis shared with the rest of §3, plus a class-11 entry resting on 676 > 675. Nothing computed depends on any of it, these being family guarantees and hence floors for μ; the exposure is to the asymptotic story alone. → **T6**
5. **The κ parameters at k = 3.** The F = 4 result transfers to k = 3, but the tables hold κ_r = 1 and treat κ_c as free; whether κ can be steered independently of the congruences fixing F and η is unchecked. No risk to k = 2. → **T7**
6. **The eight necessary conditions of `fb_common.py`.** Both certificates rest on these and nothing else. What matters is their being *necessary* — that is what makes an empty candidate list a proof — and that is a different reading from checking each is true. The conditions have now had one independent necessity read; what is exposed is the quality of the eight arguments, and in particular condition (4)'s foreign strip, whose necessity is licence-scoped. The defect class to watch is an enumeration narrower than the shape space it must cover: it removes a real candidate silently and leaves the output looking clean. → **T3**

---

# §1. Script runs

*Can be launched in the background. Flags are checked against the scripts as they stand; where a run needs code that does not exist, that is said rather than papered over with a plausible-looking flag.*

## R0. Extend the table, then rerun everything downstream

**⟦PENDING-REBUILD⟧** The rebuild is in progress; the contiguous frontier is wherever the run has reached, and the previous table is the **baseline to compare against, not the current table** — a table computed with a twist cut by the block count understates B at every value where a cyclic-layer fusion is available, so its rows are lower bounds. Extension costs roughly n^2.9 per value. **Rows above the contiguous frontier are worklist rows, not range:** values consumed from `ladder_weak.txt` under R7 are appended to the same CSV, and since the worklist selects n *by low ladder score*, those rows are a low-density subsample — median density well below the frontier's. Quote every distributional figure over the contiguous prefix; quote the floor and “nothing below X” over the whole file. Extending the *contiguous* range is what moves the aggregates, and it is what “extend the table” means here. R1 runs clean against it and the documents are recounted to it. What is left on this axis:

1. **Rebuild the branch-and-bound worklist**, since its pruning is keyed to the density floor and the floor has moved (item R7).
2. **Extend further** when wanted, rerunning R1 each time.

```bash
python3 mu_enumerate_v3.py --nmax <N> --fill-gaps --out mu_table_safe_v5_code_v3.csv
```

**Use `mu_enumerate_v3.py`.** Any enumerator whose SAFE cap cuts a fused class's twist by the block count produces rows that are *lower bounds* on B(n) rather than values, so such a table may be a baseline but never an extension. The rebuild must reproduce or raise every baseline row.

**A rebuild must never lower a value.** B(n) is a maximum over admissible configurations, so adding configurations can only raise it: a rebuild that comes out *lower* anywhere means a shape has been lost, not gained. `validate_table_v3.py`'s group-A monotonicity check against `--baseline` is what tests this, and it is the signature to read on every batch.

## R1. Routine, after any new batch of table values

> **⟦PENDING-REBUILD⟧ Expectations are suspended while the rebuild runs.** `validate_table_v3.py` is the current validator; a validator asserting a congruence on the matching block's residue will FAIL on any correct table, since the fused twist is full at every c. Expected output on the partial table, so that a deviation is recognisable: `validate_table_v3.py` **21 PASS / 0 FAIL / 14 INFO / 3 SKIP** against the previous table as `--baseline`. `check_doc_figures.py` does not go to zero — most of its PASS 1 flags are coincidental numeric matches, so it is read finding by finding rather than as a pass/fail. The certificates' counts are requoted from their reruns.

Every one of these is a per-n statement that does not extend itself, and none of them extends with the table. Point them all at the current enumerator output, with the previous table as `--baseline`. **Run in this order** — the first gates the rest. Extending the table is R0's step, not one of these; this list is what the extension obliges.

**All five steps run.** Condition (4) strips only the licensed foreign prime, so both certificates are sound to run; their previously quoted coverage figures predate the current scoring and are requoted from the rerun rather than carried forward.

```bash
TABLE=<current enumerator output>           # what mu_enumerate_v3.py is writing
BASE=<previous table>                       # baseline: must never be lowered

# 1. cheapest, and gates everything: is the file a well-formed enumeration?
python3 validate_table_v3.py $TABLE --baseline $BASE --ladder ladder_weak.txt

# 2. the per-n collapse certificate, against the TRUE B(n)
python3 fallback_cert.py $TABLE --verbose
python3 fallback_cert.py $TABLE --no-theorems

# 3. the same certificate far beyond the table, against a proven lower bound
python3 wide_cert.py 100000

# 4. the range-scoped halves of Lemma D2's and Corollary C′'s domination
python3 a18_verify.py $TABLE
python3 t5_verify.py $TABLE

# 5. the documents against the table (five passes, incl. refs).  This is the
# pass that replaces the figures once the rebuild is complete.
python3 check_doc_figures.py $TABLE *.md
```

**A free structural check worth adding to step 1.** The Oliver matching-class score F·C(c,2) = s(c−1)/2 coincides with `solvable-relaxation.md`'s solvable score at c = P(s), so **B(n) ≤ B_solv(n)** must hold at every row — Oliver groups being solvable. It costs an O(n) partition scan per row and needs no certificate. Against the 289 rows the current cap raises: 0 violations, 20 exact attainments on the two-part solvable optimum alone.

**What each one is for, and what to read off it.**

- **`validate_table_v3.py`** — pass `--ladder` the current worklist as well as `--baseline` the previous table: the two cross-artefact checks it enables are the cheapest instance of the defect class T1 item 3 names, and they cost a dict join rather than a recomputation. One is a correctness check (the ladder's lower bound must never exceed the table's density) and one a coverage diagnostic (where it falls well below, the four families are missing a shape the enumeration finds, and the witness column names it). A FAIL in **group A** means the run itself is broken and nothing downstream is meaningful; a FAIL in **group B** is a real contradiction between table and documents; **group C** is INFO, each line printing the expected asymptotic beside the measurement. `--explain N` gives one row's full term breakdown, `--quiet` shows failures only, `--baseline` adds shape-migration reporting, which is how winners changing census row become visible.
- **`fallback_cert.py`** — the headline is *0 candidates*. Then read three numbers, because **the low-density recount lives here**: the **density floor**, the **largest permitted s**, and the **theorem residue**. They move together, since s ≤ 1/√δ − 1 means a falling floor admits a larger s, and **s = 4 is the first branch with no theorem covering it**. **⟦PENDING-REBUILD⟧** *Read the floor, the largest permitted s and the margin to δ = 1/25 off the run itself; they move together and a quoted value goes stale silently.* If `largest permitted s` ever prints 4, `enumeration-proof.md`'s Corollary after E.3 and Part I's tail figures both want re-deriving rather than recounting. The `--no-theorems` run should agree exactly, and the agreement is not vacuous while the dispatch is actually firing — which is a thing to measure per run, since at ranges where the foreign-cap filter removes the dispatched branches first the two modes agree trivially.
- **`wide_cert.py`** — read the `settled by theorem:` line. At NMAX ≤ 10⁴ it prints NONE, because B_lo is small enough that the foreign-cap filter removes the s = 1 and s = 3 branches before the dispatch sees them, so a `--no-theorems` comparison there agrees *trivially* and is no evidence about E.1 / E.3 / E.4. `--menu` cross-checks pass 1 against the family menu; `--refresh` rebuilds the cached B_lo, which is rarely needed since the cache is keyed on everything that determines it.
- **`k3_galois.py`** — the k = 3 Galois admissibility predicate, with a self-test covering the a = 35 witness, the superset relation against the naive reading, and the gain-versus-top-prime distinction. Import it; do not re-derive it.
- **`validate_table_v3.py`'s group-B trend check** — for each census row claiming `wins → 0`, the shape's winner share must not *rise* across the range. The verdicts are asymptotic limits, so the count alone tests nothing (S1 and S2 win at half the values in range and still tend to zero); what a density-zero supply argument implies is a declining share. Growth must clear both a proportional bar and Poisson noise on the raw counts, since a rise like 19 → 24 is 26% and entirely consistent with a flat share. `ZERO_SHARE` entries may be a label or a tuple treated as one aggregate — needed because splitting S7 by fusion count costs sensitivity, a trend obvious in aggregate sitting inside noise once divided five ways. To exercise it, replace the `S7f3`/`S7f5` entries with the aggregate `("S7f3","S7f4","S7f5","S7f6","S7f8")`: it fails with `S7f3+S7f4+S7f5+S7f6+S7f8 4.1%→7.6%` against `S2 45.2%→29.3%`.
- **`verify_witness.g`** (GAP) — the Part E realisability check: builds the construction from a witness string, verifies the Oliver chain explicitly, and compares the orbital multiset against the value formula's terms. Driven by **R8**; `WITNESS=... MUBOUND=... gap -q -A verify_witness.g` runs a single row, no argument runs the battery.
- **`eta_derive.py`** — the η column of §3.3.5, computed twice: derived from congruences by exact enumeration mod 2⁷, and measured by scanning real decompositions. Asserts agreement at every (class, F) cell, and that no cell whose 2-adic factor is not constant across its class is one where F = 4 sets the ceiling — the classes taking F = 4 have v₂(r − 1) pinned at 1, which is what keeps the table at mod 12. Static; one run per environment.
- **`khomog_verify.py`** — the k-homogeneity claims underlying the hypothesis table of `orbital-evasiveness-notes.md` §1: the c ≡ 3 (mod 4) half-twist case at k = 2, and the five full-density degrees {3, 4, 5, 8, 32} at k = 3, with the sharpness of the order bound that makes the list finite. Static; one run per environment.
- **`a18_rq_verify.py`** — nine static checks on Lemma D2q, the r = q half: the exhaustive (2,5) subgroup scan, the (3,7) rank-2 eigenvector group, and the tightness and twist-collapse controls. Nothing in it depends on the table, so it needs no rerun on extension; one run per environment.
- **`t5_verify.py`** — Lemma C's coupling and Corollary C′: the n = 28, 21 and 10 witnesses with their chains, the coupling's tightness at (16,5) and the chainlessness of the mismatched pairing, the sharing bound against every row, and the three facts underlying the local licence that gates condition (4)'s strip (T5). The last pass is **range-scoped** and expires silently on extension, so it belongs in this list beside `a18_verify.py`.
- **`a18_verify.py`** — Lemma D2's witnesses and its range-scoped half: the n = 85 and n = 91 orbitals and chains, the 2-homogeneity of the n = 91 permuter, and the fused-outside domination bound against every row. Only the third can move with the table, and it is the one that matters: it is a **range-scoped** claim, so a table extension can invalidate it silently. Exits nonzero on any failure.
- **`check_doc_figures.py`** — `--quiet` for findings only, `--pass {figures,scope,prose,hygiene,census,refs,tables}` for one pass; exits nonzero when anything is flagged. **Pass every `.md` that might be cited**, or `refs` reports live cross-document citations as dangling. And append the old maximum to `CHECKPOINTS` and a pattern to `SCOPE` in the same sitting, or figures written against the superseded range report as unexplained rather than as historical.

**Two things deliberately absent from this list.**

- **`ladder_verify.py`** is not a per-batch check — it never reads the table, it scores explicit families. It belongs to **R7** and runs on its own schedule.
- **`s7_scan.py` and `mu_fast.py` are absent** from the working set. `validate_table_v3.py` group B covers the S4 / S5 / S7-at-F=2 congruence patterns `s7_scan.py` would test, so nothing is owed unless a new check is wanted.

**Do not extend the table without rerunning this list in full.** An extension leaves a different subset of the documents behind each time, and the failure is silent: a stale figure reads as a claim about the current range. *(The same applies to the Lean statements, which no check in this list reads — see A9.)* The two passes that catch it mechanically are `check_doc_figures.py --pass refs` and `validate_table_v3.py`'s coefficient assertion.

## R6. Shape-level scoring checks

*Independent of the table: these score **shapes**, not rows, so they do not rerun on extension. Rerun after any change to the SAFE cap, to `orb`, or to the scoring in `mu_enumerate_v3.py`.*

```bash
python3 shape_realize.py --nmax 34            # expect 0 mismatches
python3 shape_realize.py --nmax 22 --strip    # control: expect UNDER-SCOREs
ARK_SHAPES_NMAX=100 ARK_SHAPES_MAXF=4 gap -q -o 4g ark_shapes.g
ARK_SHAPES_NMAX=200 ARK_SHAPES_MAXF=2 gap -q -o 4g ark_shapes.g
ARK_SHAPES_STRIP=1 ARK_SHAPES_NMAX=100 ARK_SHAPES_MAXF=4 gap -q -o 4g ark_shapes.g
```

**Read the control first, always.** A clean run means nothing until the `--strip` / `ARK_SHAPES_STRIP=1` pass has been seen to fail: it re-scores with a condition known to be wrong, so a control that comes back clean means the harness is inert, not that the scoring is right. Expect UNDER-SCORE at exactly the shapes where stripping **changes** orb(c,d), and check the count against that predictor rather than against a remembered number. It is *not* "wherever gcd(d, F) > 1", which names roughly twice as many rows: stripping a single factor of 2 from an even d never changes orb, since orb = c·d/2 when −1 ∈ T and c·(d/2) when the halved d is odd.

**UNDER-SCORE (scored < realised) is the failure that matters.** B(n) is an upper-bound claim, so a shape scored below what a group achieves makes B too small and can break μ(n) ≤ B(n). A restriction that looks conservative fails exactly this way. OVER-SCORE is unsound the other way — the cap crediting an orbital no group delivers.

**What these cover that the rest of the battery does not.** Every other check validates the **winner**; none looks at a shape that **loses**, so a mis-scored losing shape stays invisible until it becomes a winner at some larger n — which can be many degrees above where the defect is first present and detectable.

**A wide sweep can be cut short by memory pressure part way through a line, and the truncated rows carry no verdict.** They are untested, but they look like data, so a summary counting mismatches over the file counts them as passes. `ark_shapes.g` re-reads its own output and FAILs on any row without a verdict; if a run reports truncation, lower `ARK_SHAPES_MAXF` or raise the GAP workspace rather than reading the summary line.

**Owed runs.** The wide GAP sweep (`ARK_SHAPES_NMAX=200 ARK_SHAPES_MAXF=2`) wants repeating: its output was cut short part way through a line, so every row past the truncation point is untested while looking like data. `ark_shapes.g` now FAILs on that condition rather than reporting a clean summary over it, so the rerun is also what confirms the guard fires or stays quiet.

**Still owed.**

1. **Give the Oliver test something it can fail.** Every row returns `oliver=0`, correctly and unavoidably on a single fused class — and since the lattice search was replaced by `CheckChainWitness`, the check now verifies the supplied chain rather than searching for one. Either way it **cannot currently fail and is not evidence**. Extend to shapes that can fail it: a foreign block whose top prime does not divide r − 1, or a class with a non-cyclic layer.
2. **Lemma C's foreign strip** — the one cyclic-layer restriction that *is* real, hence where an over-eager repair could break something in the other direction. Highest value of the three uncovered terms, and the natural shape to build is a configuration that genuinely shares a prime between a matching twist and a foreign block.
3. The **foreign block's** η = 2t/(r−1), against a realised AGL(1,r) twist.
4. The **inter-class** term F·c·r, which needs the chain element linking two classes, hence a genuine two-class Oliver group rather than a single class.

## R6a. The ceiling table's independent re-derivation

*Static: it scans configurations, not table rows, so it does not rerun on extension. One run per environment, and again if §3.3.5 changes or the script does. **Owed now:** the `--no-filter` candidate list was tested for prime-power-ness on the odd part alone, which admitted block sizes no Oliver group has (6, 12, 20, 24, …), so any earlier unfiltered output mixed real escapes with phantoms. The filtered mode was unaffected.*

```bash
python3 ceiling_rederive.py --nmax 24000 --mod12   # expect all six from below, all pairs agree
python3 ceiling_rederive.py --nmax 16000 --no-filter  # control: expect exceedances at 3, 5, 7, 11
```

**`--no-filter` is the control and must exceed.** It removes §3.3.8's escape filter, and the exceedances that appear — witnesses with c or oddpart(r−1) a pure power of 3, so the ℓ = 3 obstruction evaporates — are that section working as documented, not counterexamples. A `--no-filter` run that comes back clean means the filter is not doing what its comment says. **Check the witnesses are prime powers**: a non-prime-power c in that column means the candidate list is admitting block sizes no group has, and the escapes it reports are then partly phantom.

## R6b. Re-screen the shared-block-count configurations against the rebuilt table

*Owed, and it is the one artefact behind the shape space's most permissive admission.*

The enumerator does not require two fused classes' block counts to be coprime, and nothing makes that a necessary condition — a block-permutation image is a quotient of the cyclic layer, not a subgroup of it. Three arguments cover the three ways a block count could have mattered, and only one of them has an artefact:

| case | what covers it |
|---|---|
| F_mid vs F_mid | **`audit_fmid.py`** — a measured screen, not a theorem |
| F_mid vs another class's twist | Part E's diagonal carrier (argument) |
| F_mid vs a foreign prime r | counting: orb(r, ·) ≥ B forces r ≥ √(2B), and r \| F_mid then makes the class size overrun n (argument) |

```bash
python3 audit_fmid.py            # expects: 0 configurations scoring above B(n)
```

**Why it needs rerunning.** The screen compares an optimistic score against a recorded B(n), so it is only as strong as the table it reads. Run it against the rebuilt table, not a superseded one. Its scope cuts — δ ≤ 0.13, F ≤ 25, fused classes only — are stated in the script's docstring and are bounds on where such a configuration could *win*, not on where one could exist.

**If it ever returns a hit**, that is not a bug in the screen: it is a configuration the enumeration admits and the table does not reflect, and the right response is to score it exactly rather than to tighten the admission.

## R7. Consume the ladder worklist with the adaptive branch-and-bound

> **⟦PENDING-REBUILD⟧ Run the ladder before consuming its worklist.** `ladder_verify.py` scores rung B at the full twist and keys `CAP` mod 12, so a worklist or floor produced under any other scoring ranks against the wrong ceiling and understates the floor. Re-run the ladder first, regenerate the worklist, and only then read any count below as live. When `--floor 0.04` prunes every entry on its supplied lower bound, the branch-and-bound has no survivor to examine and δ ≥ 1/25 over the scanned range is established without computing a single further B(n); what follows is then **sharpening**, wanted only if a tighter constant is the goal, plus the mechanics for whenever the range is extended.

*Turning the ladder's lower bounds into decisions about B(n) — **one job, not three**, writing into the existing table.*

> **Regenerate the worklist before consuming it.** The ladder's families and its CAP table both determine the list, so a worklist produced by an older `ladder_verify.py` ranks against the wrong ceiling and omits the shapes that ceiling now depends on. One property of the list is worth knowing before planning a run: it is thresholded at the **asymptotic constant** 7 − 4√3, so it is long and correspondingly weak as a "compute B(n) here" ranking, since falling short of that ceiling is generic at computed sizes rather than exceptional. The **floor question is not read off this list at all** but off the separate `--floor` count, which reports the values failing a stated floor and is 0 at 1/25 throughout 10⁶. What the list is good for is its *lowest* entries: the ten smallest all lie in [10³, 10⁴], and computing B there is what would sharpen the verified floor.

```bash
python3 ladder_verify.py 1000000                      # regenerates ladder_weak.txt
python3 mu_enumerate_v3.py --nlist ladder_weak.txt \
        --floor 0.0400 --adaptive --out <current table>
```

**Why this and not a `--nlist` run per tier.** `--floor … --adaptive` is the branch-and-bound of `arithmetic-of-density.md` §5.1 run inside the job, and it does four things a plain run does not:

- **Prunes on the supplied lower bound.** The worklist's second column is read as LB(n); any n with LB(n) ≥ the current floor is skipped without computation, since LB(n) ≥ floor already proves δ(n) ≥ floor. At a floor near 0.04 this disposes of all but a handful of a worklist's entries for free.
- **Rejects most survivors without computing B(n).** For an unpruned n it seeds the search at floor·C(n,2), so it only has to show *some* configuration clears the floor. Measured on the first 40 entries: n = 1175 is rejected at K = 2 — δ(1175) > 0.04 established without ever computing B(1175).
- **Appends the exact row when it does compute one**, to `--out`, with the full schema and the witness — so the expensive values land in **the same CSV** rather than a side file that then needs merging. It only appends, never rewrites or reorders, and skips n already present.
- **Reads the table back as prior knowledge.** An n already in `--out` is not skipped; its density is fed to the floor. So the table's existing rows tighten the search rather than being ignored.

**Set the floor to the question you are asking.** The floor is an interrogation threshold, not the known answer — setting it to the current global floor would prune everything, since pruning triggers at LB ≥ floor.

| `--floor` | what it settles |
|---|---|
| **0.0400** = 1/25 | whether any n leaves room for **s = 4**, the first fallback branch with no theorem |
| the current table floor | whether anything undercuts it |
| the ladder's global floor + ε | whether the argmin's B(n) exceeds the ladder bound there, which is what §5.1 turns on |

Run them in that order; each is a superset of the next in cost and the cheap one may answer the expensive one's question. `--nmax` acts as an upper cut-off on a `--nlist`, which is how to defer the five-figure entries — at n^2.9 per value an n near 50,000 costs roughly 10⁴ times an n = 2,000 row, so it is worth seeing the rest first.

> **Before committing an expensive n, probe it.** Finding one configuration that clears a floor is sub-second; proving optimality is what costs hours. A targeted scan over the two-part census shapes, scored with `mu_enumerate_v3.py`'s own `value()`, settles the floor question outright whenever the answer is "clears" and costs nothing when it is not. It reproduced B(n) exactly at all eleven worklist values where B was independently known.

**Preconditions and cautions.**

- **Needs R0 finished.** The pruning and the part-count cap are both keyed to a floor read off the table.
- **Never combine with `--refined`.** The script refuses it, and the reason is worth knowing: adaptive mode appends rows to `--out`, the schema records no mode, so a refined row in an unconditional table would be undetectable and would corrupt every downstream figure.
- **Rerun R1 afterwards.** The job adds rows, which is a table extension like any other.
- **Do not overwrite the worklist.** `ladder_verify.py` honours `LADDER_OUT`; each run's file is the evidence for figures in §3.7 and §5.2.

## R8. Widen the Part E realisability battery

*The one leg of μ(n) = B(n) with no per-n check. **⟦PENDING-REBUILD⟧ `verify_witness.g` was patched and the battery has not been rerun**, so the seven-witness core's clean pass is a result about the superseded script; repeat it first. Beyond that, what is owed is width. (It had been reporting `false` on every foreign-part row: `BuildConfig` put a foreign class's C_r translations into `gens.bottom`, so `IsPGroup(G2)` failed on a chain that is not the construction's — Part E puts them in the cyclic layer. Fixed, and the verdict line now names each failing condition, since a bare `false` beside orbital data that visibly matches invites hunting in the wrong place.)* *⟦PENDING-REBUILD⟧ Current coverage: the certificate side is **held** pending the condition-(4) repair, and attainment stands at **twelve** values from the superseded battery, the largest n = 575. `verify_witness.g` is the tool; step 1 below is ready to run.*

**Why this is the highest-value run available.** `validate_table_v3.py` group A checks that the construction's *ingredients* exist at every row — block counts, foreign twists, a twist carrier — but not that assembling them yields a group whose minimum orbital is B(n). `verify_witness.g` does exactly that, and does three things a looser check would not: it verifies the Oliver chain explicitly rather than assuming the generator placement is right; it compares the whole orbital **multiset** against the predicted terms, since matching only the minimum can pass while realising a different group; and it builds a fused class with the **entangled generator**, one cyclic-layer element whose F_mid-th power is the full twist. That last is what makes the script able to realise a fused class at full twist at all: a build that supplies the rotation and the twist as two separate generators is a different group, and it will report a shortfall against every full-twist fused witness.

**Why even fusion counts matter here.** A battery drawn only from F ∈ {1, 2, 3, 5} exercises no even F ≥ 4, which is the blind spot a "fusion counts are prime powers" reading produces. Since S7 at F = 4 attains the class ceiling at n ≡ 11 (mod 12) (`aod` §3.3.5), that family carries as much weight as any in the battery, and it is the one whose construction evidence is thinnest.

**Step 1 — run the battery.** The entries are in `verify_witness.g`; just run it:

```bash
gap -q -A verify_witness.g
```

They are n = 20, 255, 282, 323 and 575, all at battery speed. Between them they cover both branches of `ConstructionTwists`, which a single entry would not:

> - **F a q-power** — n = 20 (F = 4, q = 2). Then F_top = F and F_mid = 1, so the twist is **not** stripped by F: it stays 4 and the intra term is 4·orb(5,4) = 40, where an F-stripped twist would give 20.
> - **F not a q-power** — n = 255, 323, 575 (F = 4) and n = 282 (F = 6, where 2 and 3 both occupy the cyclic layer at once). Here F_mid = F and the twist is cut coprime to it: twists [21, 41], [21, 25], [51, 81] and 46 respectively.

`ConstructionTwists` splits F into F_mid and F_top by q, and `PredictedTerms` keys the within-class cross coefficient on **F's parity**, not on q. The battery also carries three **entangled-generator regressions** — n = 33 (2×13 + 7\*), n = 78 (6×13, a composite block count with trivial top) and n = 105 (2×29 + 47\*) — whose orbital multisets are known from an independent build outside GAP: {21, 156, 169, 182}, {468, 507, 1014, 1014} and {812, 841, 1081, 2726}. Those are the rows that fail if a twist cut by the block count is ever reintroduced anywhere in the pipeline, so **a failure there is a finding about the construction, not a malformed entry**.

**Step 2 — a stratified sample, once step 1 passes.** One row per census shape, both parities of n, and each of the six odd classes mod 12, preferring the *lowest-density* row available in each stratum — a construction is most likely to fail where the score is tightest. Then the extremal rows: the current table floor, and the lowest worklist entries whose B(n) has been computed.

**The scaling limit, and what to do at it.** `OrbitalSizes` calls `Combinations([1..n], 2)`, which materialises the pair list: 690k entries at n = 1175, 3.4M at n = 2600. That becomes the binding cost well before the table's frontier. A union-find over the generators does n = 1175 in about 3 seconds outside GAP, so for coverage across hundreds of rows, port `OrbitalSizes` to union-find and keep the chain and multiset checks where they are. Do not drop the chain check to buy speed — it is the part that distinguishes this from a re-derivation of the value formula.

**What a pass does and does not settle**, restated because it is easy to over-read and the script's own header says it: a pass establishes that the enumeration's score at that n is **attained**, i.e. μ(n) ≥ B(n). It says nothing about completeness (μ(n) ≤ B(n)), which is Part 0's business, and nothing about J0a — the construction takes each matching twist inside the field's multiplicative group and the script builds exactly that group, so it cannot detect that a larger stabiliser was available.

## R10. The chiral-half homology — only the n = 5 Smith form remains

*Script: `chiral_mv.py` (`--verify` runs the regression, `--table N` prints the closed forms). The question — whether any chiral half of the Hamiltonian-cycle complex is **ℤ-acyclic**, the lowest rung at which a counterexample could exist — is answered **no**, at every n ≡ 1 (mod 4); see the session log for the closed forms and the argument.*

**What remains.** Only the n = 5 torsion, and only if one wants the Smith form rather than the answer: the connecting map is ℤ⁶ → ℤ⁶ with cokernel (ℤ/2)², elementary divisors (1,1,1,1,2,2). The regression at n = 5, 6, 7 should be re-run after any change to `chiral_mv.py`; it checks the closed forms against direct 𝔽₂ homology and asserts non-negative Betti numbers, which is what catches the boundary-orientation bug described in the script header.

## §2a. Needs human thought

*Judgement calls, independent scrutiny, or things requiring materials Claude cannot obtain.*

### T1. Independent reading of the structural arguments

**A step compressed to a clause tends not to survive being written out**, and this framework's record bears that out. Of its compact structural steps: one is false (the ΓL(1) step); one is false as stated and correct once repaired (the q-power block count); one needed two gaps filled (B′); two are exclusions that are only dominations (Lemma D2, whose conclusion fails outright at F ≥ 3, and Lemma C, whose gcd = 1 fails at every a and gives way to a coupling); one is an upper-bound claim that is only an attained value (the within-class cross coefficient, scoped to the construction); one was a supply claim whose proof covered half its quantifier (the census S7 row at F ≥ 3, whose "F·c even forces c = 2^a" holds only for odd F); and one was a **necessary** condition that is merely sufficient (Theorem 3.1's F_mid coprimality clause, refuted by entangled generators).

**Three failure sites, calling for three different checks.**

1. **Reasoning over the wrong partition of cases**, which accounts for most of them. In four the false clause quoted a small or regular group's behaviour as if it bounded every admissible one; in the S7 case the partition was F odd versus F even and the sentence's own arithmetic silently selected the odd branch. *The check is to ask which cases a clause was verified on, and whether its quantifier is wider.*
2. **Transcription from proof to statement**, which accounts for Lemma C: its a = 1 proof established "share ⟹ outside twist trivial" while the sentence recording it claimed "no share". The proof was correct and the statement stronger, and the discrepancy survived because the statement was only ever tested against the case its proof did cover. *The check is to read each lemma's statement against its own proof's conclusion, independently of whether the proof is believed.*
3. **Contradiction between artefacts that nobody compared.** The S7 error is the clearest instance: the enumerator's `parts_for` implemented the correct reading and found 125 winners of the shape, while the census row asserted it wins nowhere, and `validate_table.py` printed both figures a few lines apart in the same report on every run. The same shape recurs in the strip-trace and `--no-theorems` findings. *The check is cheap and mechanical — compare each prose claim against the artefact that would contradict it — and it is the one most likely to be skipped, because neither artefact looks wrong on its own.*
4. **A claim no artefact can contradict, because every artefact derives from it.** The F_mid coprimality clause is the clean instance: the prose asserted it, `mu_enumerate` implemented it in the SAFE cap, `validate_table` re-derived B from witnesses that cap had chosen, and the certificates rested on the same condition. Four artefacts, one source, so no cross-comparison could fire — site 3's check runs and passes. Worse, the defect was **invisible to the argmax**: it under-scored a losing shape, and everything in the battery validated winners. It was fully present and detectable at n = 10, the smallest fused shape in the programme, and changed no recorded value until n = 78. *The check is to build the object from first principles and compare against the scored value — not to compare two artefacts that share a derivation. This is what `shape_realize.py` and `ark_shapes.g` do (R6), and why their control run matters more than their green run.*

**What the second reading settled, and what it missed.** Parts A–J and Part 0 have had a second reading by someone with no prior exposure, running the failure sites above. It found no error in the structural steps it examined, and **B′'s socle argument is confirmed** — Step 0 does need irreducibility plus C_G(V) = V, exactly as written, and both cases close. Every finding it returned was failure site 3.

> **It did not catch the F_mid clause, and that is the most useful thing known about it.** The clause sat in Theorem 3.1, in the SAFE cap, and in `fb_common`'s condition (4) throughout that reading. It is site 4: nothing in the reading's toolkit could reach a claim that every artefact agrees with. A reading that runs sites 1–3 should now be assumed to leave site 4 untouched.

**What remains.** A further independent reading is still worth more than another pass by either previous reader — the argument for independence does not stop applying once two readers agree, and this framework's record is of errors surviving one reading each. And **a machine reading is weakest exactly where the failure mode is "an argument that reads as plausible"**: it verifies constants and recomputes tables freely, and has no way to notice a step whose plausibility is doing the work. That is the residual human item.

**Some of what this item flagged as unverified now has an artefact behind it.** Three of the compact steps in the opening inventory are no longer resting on the prose alone:

- **The within-class cross coefficient** — called out above as "an upper-bound claim that is only an attained value, scoped to the construction" — is now checked against realised orbitals at 134 shapes in GAP and 98 in Python, two independent constructions agreeing exactly, across every divisor d of c − 1 for every prime power c ≤ 19 (R6). The same runs cover the intra term F·orb(c,d) and hence orb's halving rule.
- **Lemma B′'s consequence** — that a foreign twist is a q-power divisor of r − 1 and η respects v₂(r − 1) — is now an exact check over every one-foreign winner (`c_eta_reach`), not only a read argument.
- **The ceiling table's keying** was re-derived by scanning real configurations per residue class rather than by re-running the congruence argument (`ceiling_rederive.py`).

**What has no artefact, in the order I would worry about it.**

1. **Part 0's completeness.** Unchanged and still first: a missing shape has no witness to contradict, so it is site-4 by construction. The shape checks narrow this only for the fused matching class.
2. **Lemma C's strip.** The one cyclic-layer restriction that survives, and therefore the one place a correction in the other direction would show — nothing yet builds a sharing configuration and checks it.
3. **Part E's realisability**, per T2: `verify_witness.g` covers recorded winners, so a shape that never wins is never built.
4. **The inter-class term F·c·r**, which needs a genuine two-class Oliver group.
5. **Oliver admissibility of the scored shapes** — the test exists in `ark_shapes.g` but is currently tautological, every row returning `oliver=0` by construction.

Items 1–5 share a property worth stating plainly: **each is a claim that the artefacts either derive from or do not reach.** That is site 4, and it is where the next error should be expected.

**Where to look, in order.** Part E's realisability construction is still the least-defended thing the framework relies on — it exhibits groups and nothing checks it per-n (T2), and the read pass could not change that, since reading a construction is not building one. Part 0's completeness is the step with the worst record and the sole support for μ ≤ B_safe; it has had two readings and remains the place a missing shape would hide, because a missing shape has no witness to contradict. The one new lever on it is **B(n) ≤ B_solv(n)**, which a missing Oliver shape cannot violate but a mis-scored one can — cheap enough to run on every row (R1). Below those, Parts D2q and E″ carry the most intricate case analysis per line.

### T2. Part E's realisability: preconditions are checked, construction is not

The preconditions check is **built and passing**: `validate_table_v3.py` group A asserts per winner row that the Part E build's ingredients exist — F_top a q-power, and every foreign block scored above r actually having q | r − 1. The carrier's order must be coprime to every **foreign prime**; it need not be coprime to any block count, since a fused class is carried by an entangled generator whose F_mid-th power is the full twist. *Gotcha worth keeping in the check's comment: a precondition stricter than the construction requires does not err on the safe side here — it would reject rows the construction realises, and the check's purpose is attainment.*

**Part E's construction has been read and found sound as written** — the layer assignment, the twist carrier, the forced orbital sizes, and the F-parity coefficient with its correctly-scoped pitfall box all check out, and E.3(ii)'s (c, r) = (11, 5) group was rebuilt independently, returning orbitals {10, 55, 55} as predicted. **That does not close this item**, and the distinction is the point of it: reading a construction establishes that it would work if assembled, not that assembling it at the table's actual configurations yields the predicted orbital multiset. Only R8 does that, and its coverage is a dozen values.

**What is left for a human, and it is the part a check cannot reach.**

- **Whether to build groups at all, and how often.** Preconditions existing is not the same as the group existing. The n = 10 and n = 12 exhaustive batteries plus eight hand-built configurations from n = 12 to 315 are the current evidence; the construction check itself is **R8**, which is where the shapes and the order to run them are set out. The priority there follows from the ceiling table: **S7 at F = 4 attains the class ceiling at n ≡ 11 (mod 12)** (`aod` §3.3.5), so it needs even-F entries in the battery rather than being treated as a curiosity.
- **J0a, the stabiliser assumption.** The construction takes a matching block's twist inside the field's multiplicative group, whereas the stabiliser of a primitive affine group of degree p^a may be any irreducible subgroup of GL(a, p). This cannot inflate B_safe, which already credits C(c,2), but it is an unstated assumption bearing on attainment. **No precondition check reaches it**, because the witness records a twist order and not the group the twist lives in. Either justify the restriction or scope the realisability claim to it.

### T3. Independent necessity read of the eight conditions

These are the whole trusted base for μ(n) = B(n): both certificates pass with every Part E′ theorem disabled, so nothing else carries weight in the per-n proof. The question is not "is each condition true" but **"is each condition necessary"** — does every fallback configuration attaining B(n) really satisfy it. **The direction to fear is anti-permissive**: a condition that is not in fact necessary silently removes a real candidate and leaves an empty list looking like a proof, and it is invisible from the certificate's own output.

`fb_common.py` carries a per-condition necessity argument in the header, so **what is outstanding is scrutiny of those eight arguments rather than the reconstruction of them**. Two places to press hardest, both flagged in that header. **Condition (4)'s foreign strip** is the load-bearing one, and its necessity is *licence-scoped* rather than absolute: the strip is licensed by Corollary C′ exactly where sharing_bound(p, a, r) < B, so what wants scrutiny is the licence and its gate rather than the strip itself — in particular whether the bound is right, since an over-generous bound licenses an over-strip and the resulting loss is invisible in the output. **Condition (6)** is *not* independently necessary and is retained only as a tripwire — check that nothing has come to rely on it.

**Three strip sites, all gated.** The foreign strip appears in `pair_candidates`, in `single_part_ok` and in `multi_part_ok`, and each is gated on the same local licence, asserts it, and records the decision through `set_strip_trace()`. A site that strips without the gate produces exactly the same empty candidate list as a correct run, so the count of sites is itself worth re-checking whenever the file is edited.

*Human, for the same reason as T1: the value is in the independence.* **The eight necessity arguments have had one independent reading.** A second is worth more than another pass by the same reader.

### T4. Literature: one high-upside investigation, four smaller owed items, framing deferred

*Untouched by any review pass so far, all of which stayed inside the documents; every item below stands as written. Four passes are written up in `literature-findings.md`, which carries a reference convention — every citation of our own documents is prefixed `` `aod` ``, `` `notes` ``, `` `ep` ``, and a bare § belongs to a cited paper. Two candidate follow-ups — running our CSP against Angel–Borja's surviving types, and chasing the two-orbital criterion computationally — are **deliberately not on the list**: the exhaustive n = 10 and n = 12 batteries already validate the machinery more strongly than either would.*

**Outstanding, and it is the item with the most upside in this file.** Skorobogatov–Sofos (*Inventiones* 231, 2023) prove Schinzel's Hypothesis on average and use it to get a *positive proportion* of varieties with rational points — the move being that one does not need the full conjecture, only that most polynomials satisfying the obvious necessary condition represent at least one prime. **That is structurally `aod` §4**, which needs not an asymptotic at every n but only that for almost every admissible n *some* shape in `aod` §6's finite feasible set is realised. If the averaging works over our shape families, §4's density claim moves from conditional to unconditional, which changes what the paper is. Obstacles to check: the coprimality budget means our family is not a generic family of polynomials, and their result is for linear polynomials in several variables, which fits our two-part shapes better than the fused ones. **Read before `aod` §4 is written, not after.**

**One comparison replaces a reading task.** `literature-findings.md` items 4 and 17 identify Black's spacing framework (ITCS 2015 / ACM ToCT 2019) as containing the sub-board Fourier-degree route, p-group hypothesis included. What is left is not to read it but to ask a specific question: **does our group data give better spacing at composite non-prime-power n than the sequences already in the literature?** His target is Ω(n) asymptotically; ours is constants near C(n,2) at specific n, which his framework does not chase. The two feed the same machinery with different objectives, so the comparison is concrete — compute spacing for the orbit augmentation sequences our batteries supply.

> **Note the optimisation runs opposite to the battery selection.** That route wants many *small* orbitals; the max-m\* search wants the reverse and discards exactly the useful groups. Same inversion as the two-orbital criterion.

**Three primary-source checks owed before publication**, each flagged at its site in `aod` §3.6: the θ = 1/4 rung is attributed to Bombieri–Vinogradov on Shparlinski's framing rather than from the original; the Chowla row names a conjecture-type rather than a specific paper; and **the Ω(n²/3) bound is attributed by at least one survey to unpublished work of Santha–Yao rather than to Scheidweiler–Triesch**, whom we cite alone in `aod` §5 and the `notes` reference list. Citing one of two is a priority claim we have not checked.

**The step we are missing, and it is elementary.** Jones–Zvonkin is a *programme* — at least five papers applying Bateman–Horn to dessins, permutation groups, block designs and simple-group orders, with a stable recipe (`literature-findings.md` item 20). Their step (ii) is an explicit, elementary verification of Bunyakovsky's conditions for each polynomial. **`aod` §3.5 asserts an ample supply without doing the analogue** — checking, per shape family, that the relevant system satisfies Schinzel's conditions and has no fixed prime divisor. That is a page of work per family and it interacts with the polynomial-versus-exponential line below: a shape with unbounded exponent has no polynomial to check, which is itself the finding.

**Deferred: the framing decision.** Jones–Zvonkin's programme (arXiv:2106.00346 and four companions) is the model for how this genre states its standing — conditional on Bateman–Horn, labelled as such in the abstract, with the conjecture validated numerically at the range used. Three consequences are recorded in `literature-findings.md` items 14–16 and are *not* being acted on yet: a standing table at the front of `aod` §3 dividing unconditional from conditional from conjectural; the polynomial-versus-exponential line in `aod` §3.5, since shapes needing prime powers of unbounded exponent are Mersenne-like and outside Bateman–Horn; and the Catalan/Pillai caution where both parts are proper prime powers, which is our S1 and S2 and which `aod` §6 currently treats as amply supplied.

### T5. Condition (4)'s strip, and the residue that blocks B_refined = B_safe

*The mathematics is in `enumeration-proof.md` Part D (Lemma C's coupling and Corollary C′); the gate is implemented in `fb_common.py` at all three strip sites. **⟦PENDING-REBUILD⟧** the certificates' counts are requoted from their reruns.*

**The licence.** Condition (4) caps a leftover p-characteristic part by stripping the foreign prime r from its twist. Corollary C′ licenses that strip exactly when a configuration retaining the share cannot reach B, and the sharing bound is **local to (p, a, r)**:

> **sharing_bound(p, a, r) = min(r·ord_r(p), C(r,2))**, and the strip is sound iff this is **< B**.

No n, no density floor, no threshold on the table. At **a = 1** the coupling forces ord_r(p) = 1, so the bound is r and the licence reads r < B. The strip only ever acts when r | p^a − 1, i.e. ord_r(p) | a; elsewhere the gate is vacuous either way. **Three sites are gated**: the primary block in `pair_candidates`, the single-part leftover in `single_part_ok`, and the multi-part leftover in `multi_part_ok`. *The site count is itself a thing to recheck on any edit — an ungated strip produces exactly the same output as a correct run, so nothing downstream will report one.*

**The gate carries an assertion rather than a silent `if`, and that is load-bearing.** A strip firing where it is not licensed discards a real candidate and produces the same empty candidate list as a correct run, so the failure is invisible in the output and must be caught at the point of decision. `set_strip_trace()` records every decision as (p, a, r, B, bound, licensed), which is the only way to observe the gate at all.

**Whether the gate is inert at the current frontier is worth more than the counts, and it is measured rather than assumed.** **⟦PENDING-REBUILD⟧** *Instrument every strip decision the certificate reaches (`set_strip_trace()`) on each rerun and read three things off it: how many decisions fire, whether any fires at a > 1, and whether any verdict differs from an ungated run.* The expected picture is that the foreign block's own cap `orb(r, t) < B` kills every proper-prime-power branch before condition (4) sees it, so the licence earns its place by staying correct as the table extends and that cap stops biting rather than by changing anything now. **Do not quote a decision count without measuring it on the run in hand** — the figure is a property of the table's frontier and of this file's current form, and it moves with both.

**What remains open.** The fallback residue is the **q = 2 and large-e** cases of Part E″'s q-pinning, where pinning is vacuous or weak and domination rather than supply is needed. That is the obstacle to replacing B_safe by B_refined outright — the structural route to **B_refined = B_safe = μ by construction rather than by computation**, as against a per-n certificate that the optimum happens to be fallback-free.

**The residue in full, so the remaining work can be costed.**

| piece | status |
|---|---|
| e = 1, δ > 1/9 | **closed unconditionally** — Proposition F.1 at k = 3; three parts each of size ≥ n√δ do not fit |
| e = 1, δ ≤ 1/9 | **reduced to a bounded search**: ≤ 2/δ pinned positions per n. Empty over the table — 4 admissible of 24,322 positions, all killed by the p-characteristic part not fitting. Not a theorem |
| e ≥ 2 | supply of admissible foreign blocks is density zero in n; enumerable at the sparse n where it exists |
| q = 2 | pinning vacuous, family exponential; needs domination rather than supply |
| p-characteristic half of the leftover | **closed at every a** — Lemma C's coupling and Corollary C′, gated locally |

*Counting alone does not close e = 1 below 1/9, and adding the pinning does not help:* the pinned bound n ≥ 3.54√B gives δ ≤ 0.16, weaker than F.1's 1/9. What closes the computed range is the specific arithmetic of the pinned positions, not a size argument. Note also that Part E″'s pinning is **conditional on a floor δ ≥ δ₀** — step 1 is the only place δ enters — so the unconditional version of this route dies with the asymptotic floor, exactly as the density ceilings do.

**Tripwire, worth keeping.** `validate_table_v3.py` asserts per row that no winner has a proper prime power c with a foreign prime dividing c − 1 — 0 of 2,202 p-characteristic winner parts, rechecked on every extension. It confirms a proved domination rather than guarding an open lemma, and flags the first n where Corollary C′ would have to be checked directly.

### T6. The residual conditionality in §3.3.5's ceilings

Both coordinates of the joint optimum are settled without a search. The **F side** closes on cap_F(1) = 1/(1 + √F)² together with η ≤ 1, which bounds each F-slice with no arithmetic input and excludes F ≥ 8; the parity constraint at odd n leaves F ∈ {2, 4, 6}. The **η side** is derived from congruences in §3.3.4a — a 2-adic factor 2^(1−v) with v fixed by r mod 8, and a 3-adic cut by 3 when 3 | r − 1 is forced — and `eta_derive.py` checks that derivation against an independent measurement at every (class, F) cell. *Gotcha the F side invites: cap₄(1) = 1/9 bounds the F = 4 slice and is not any class's ceiling, since a class that could take F = 4 at full efficiency reaches 1/8 through F = 2 at η = 1/2 instead.*

**What is left is one hypothesis and three scope limits.**

- **Supply, which is the same hypothesis as everywhere in §3.** The congruences say a suitable r is unobstructed; that primes of the form r = 2^v·q^e + 1 actually occur near the balance point in the density §3.4 needs is Bateman–Horn. Nothing in §3.3.4a improves on that, and it is why the ceilings are family guarantees rather than theorems about δ.
- **Only F ≤ 6 is derived.** §2.1's bound makes that sufficient for the conclusion, but the congruence bookkeeping itself has been done for F ∈ {2, 4, 6} only.
- **Mixed three-part shapes** — 4c + 2c′ + r and the like — lie outside both the two-part family and the three-part ladder, and no ceiling here bounds them.
- **Class 11's entry rests on 676 > 675.** The comparison 7 − 4√3 > (2 − √3)/4 reduces to 26 > 15√3, the narrowest possible integer margin. The derivation removes the way the η there was most likely to be wrong, but the margin is what it is, and anything upstream that moves it flips the class. *(Independently re-verified, along with every closed-form constant in §3.3.5 and the cap_F(η) = cap₁(Fη)/F identity. The exposure here is the supply hypothesis and the margin, not the arithmetic.)*

*The ceiling table's independent re-derivation is `ceiling_rederive.py` (R6-adjacent); the working is recorded in the session log.*

### T5a. Re-derive `three-part-family-split.md` §1.2's competing-rates argument on every revision

*Flagged because this argument is unusually good at producing plausible pictures that are partly wrong; treat any version of it, including the one on file, as provisional.*

The claim is that the odd-n win shares within the three-part family tend to **1 : 1 : 2**. It rests not on the singular-series computation but on a second step — that the *argmax* over c-classes lands in a class with probability equal to that class's share of the pool — and that step is an extreme-value claim, not a counting one. What decides it is which of several competing effects is largest, and the accounting is delicate enough to be worth re-deriving rather than read.

**Two standing cautions, both learned the hard way.**

- **The analysis is robust to changes in the ceiling table; any *share* summary built on it is not.** The congruences concern which c mod 8 the three-part argmax sits at, and are untouched by a two-part shape obeying 4c ≡ 4 rather than 2c ≡ 6 (mod 8). What breaks is the conversion to shares of n, which silently assumes the family attains the class ceiling. When that assumption failed at four odd residues, S4's absolute share went from 1/24 to **0** and the fused rung's from 10/24 to 8/24, while not one congruence changed.
- **Check the tables, not just the prose.** Scoping the note by adding a caveat at its head is not enough: a reader reaches a table before any head-note applies to anything concrete, and two sub-sections needed a second pass for exactly that reason.

**And the reason the whole note now sits outside `arithmetic-of-density.md`:** its conclusions are about runners-up. S4 wins at no residue asymptotically, and where the family does win the answer is congruence-forced with no supply argument needed — so the 1 : 1 : 2 split governs which shape is *second*, at 7 and 15, and third at 23. That is worth having for `aod` §7's disjunction-collapse, which needs the gap to the next shape down, and it is not worth carrying in the main line.

### T7. The k = 3 F = 4 rows rest on the same supply hypothesis as k = 2

*Resolved as a derivation; this entry records what it rests on. `three-uniform-note.md` §5.7 carries the tables.*

The F = 4 shape transfers to k = 3 with nothing new assumed. Three ingredients are arity-free and carry over verbatim: the **parity constraint** (at odd n with c odd and r an odd prime, F·c + r = n forces F even), the **mod-8 mechanism** (c ≡ 3 (mod 4) determines F·c mod 8, hence r, hence v₂(r − 1)), and the **η values**, since η₃ = η/2 uses the same twist and the same prime, so `aod` §3.3.4a applies unchanged. Only the cap formula differs, the arity entering as a √κ inside each term: β₃ = 1/(√(F·κ_c) + √(κ_r/η₃))².

**At κ_c = 2 the transfer is exact:** β₃ = cap_F(η)/2, a monotone transform of the k = 2 cap, so the joint optimisation over (F, η) has the same argmax — same fusion counts, same efficiencies, same four residues — with every value halved. **At κ_c = 3 it is not a monotone transform**, and the k = 2 optimum survives at every cell but one: class 11 becomes an exact tie between F = 2 and F = 4, because the formula is symmetric in its two terms and there they swap, {√6, √12} against {√12, √6}.

**What this does not settle**, and it is the same list as at k = 2: the ceilings are family guarantees, and that primes of the required form occur near the balance point in the needed density is Bateman–Horn. The arity does not improve or worsen that. Two narrower gaps also persist from k = 2 — only F ≤ 6 has been worked, and mixed three-part shapes lie outside both families.

*One genuinely k = 3 item remains open:* whether κ_c and κ_r can be steered independently of the congruences fixing F and η, since the tables above hold κ_r = 1 throughout and treat κ_c as a free parameter with two values. If they are coupled to n the way η is, the κ_c = 3 column is not reachable at every residue and the tie above may be unrealisable.

## §2b. Self-contained items

*Analysis against the existing files, needing no new materials.*

### A20. The density check must compare in exact arithmetic, not at a floating-point boundary

*A standing constraint on `validate_table_v3.py`'s group A density test, recorded because the natural implementation is wrong in a way that only ever shows at the values the test exists to admit.*

**The constraint.** A stored decimal density with k places is a correct rounding of μ/C(n,2) iff |stored − B/C| ≤ ½·10⁻ᵏ. That must be evaluated in **exact rational arithmetic**, and k must be **read off the string** rather than assumed:

```python
def density_ok(r):
    s = r.delta_str
    places = len(s.split(".")[1]) if "." in s else 0
    return abs(Fraction(s) - Fraction(r.B, r.C)) * 2 * 10 ** places <= 1
```

This needs `Fraction` imported and the raw string kept on the `Row` as `delta_str`, since `float(d["density"])` discards exactly what the check needs.

**Why not a float tolerance, which is the obvious version.** `abs(r.delta - r.B / r.C) > 5e-7` looks equivalent at six decimals and is not. An exact tie rounds to a difference of exactly 5e-7 — the tolerance is the boundary — and evaluating that subtraction in doubles lands a few ulps above it, so the comparison rejects a correctly rounded row. A worked instance: μ/C(n,2) = 250978/3278080 = 49/640 = 0.0765625 exactly at n = 2561, where the float difference is 5.000000000005e-07. Exact ties of this kind are rare — typically one per few thousand rows — which is precisely why a tolerance that mishandles them survives. Widening the tolerance would hide this while weakening the check.

*The general form, which is worth carrying to any other threshold test here.* **A tolerance equal to the exact boundary of the property it tests fails on the boundary cases** — those are the only inputs that reach it, and floating point settles them by accident of representation. Move the comparison into arithmetic with no boundary error rather than moving the boundary.

**What the test must still reject**, and what a change to it should be re-checked against: one-in-the-last-place errors in *either* direction, truncation rather than rounding, and wholly wrong values; while accepting a tie rounded either way and strings at 4, 6 or 8 decimals at their own precision. Eleven such cases plus the full table are the standing behavioural check.

**A framing point left open for a decision.** Group A's banner says a FAIL there means the run or the parser is broken and nothing downstream is meaningful. That holds for its other four tests and not for this one, which checks a presentation column no other check reads: a density mismatch with the G.3 re-derivation passing is cosmetic. Either move this test to group B or say so in the message.

### A9. The Lean formalisation — keep it in step, and keep it moving

*Home: the Lean project's own `README.md`, which carries the phasing, the case for and against, and the failure-mode analysis. **This item exists so the work resurfaces even when nobody thinks to mention it**; do not restate the reasoning here.*

**Two obligations, and the first is the one that rots silently.**

1. **Sync.** The Lean statements encode claims from these documents — ceiling values, coefficient rules, threshold ladders, the `orb` definition. When a document changes, the Lean can quietly stop matching it, and nothing in this repository's checks looks at `.lean` files. Any revision to §3.3.5's table, to the cap algebra, to `orb`, or to the E′ s-bound should be followed by a pass over `Basic.lean` and `Note.lean`. The ceiling table is the sharpest case: the entries are enumerated one per constant, so a table that gains or loses a constant leaves a list of the wrong length — which is useful only if someone looks.
2. **Progress.** Phase 0 (`Note.lean`) compiles. Beyond that the order is in the README; the near-term item is compiling `Basic.lean`, which has never been run and whose statements were reviewed by inspection only.

**What it is not for.** Formalising the arithmetic layer does not check the group theory, and would not have caught any of the layer-assignment errors in this framework's record — including the largest. The README's closing caveat is the honest version and is worth re-reading before spending time here.

### A0b. `validate_table_v3.py` — run this on every table extension

`python3 validate_table_v3.py <current table> --baseline <previous table> --ladder ladder_weak.txt`

Checks are grouped into three, and the group tells you what a result means:

- **A. Table integrity** — is the file a well-formed enumeration at all? Well-formedness, Lemmas B′ and D2 on each witness, re-derivation of `mu_bound` from the witness by the G.3 formulas, the density column, certification, monotonicity against a baseline, and the **Part E preconditions** (T2) — whether the construction's ingredients exist at each row, which the score re-derivation would not notice. A FAIL here is a bug in the run or the parser, and nothing downstream is meaningful until it clears.
- **B. Exact claims, holding at every n** — Prop F.1, cap_F(η), S2's 1/F, layer-by-top-prime, S6 emptiness, Lemma C exposure, the cyclic layer's pairwise coprimality, the feasibility criterion, Part G.4's per-axis bounds, the within-class cross coefficient, and the foreign-side residue patterns that replaced the retired congruences on c — the matching block's residue prices nothing, so what the exact checks assert lives on r, not on c. (The retired c mod 8 patterns are kept as group-C INFO, where a population at the residues the old law forbade is positive evidence rather than a failure.) A FAIL here is a real contradiction between table and documents.
- **C. Density and distribution** — floor and the s/k bounds it implies, low-density tail, part-count distribution, census shares, odd-n shares, class-ceiling exceedance, median density by residue class, foreign-block efficiency, and the ω(n) = 2 share. All INFO, each printing the **expected asymptotic value beside the measurement** so the comparison needs no reference to `arithmetic-of-density.md`. A gap here is data about convergence, not a failure.

**Four of the group-B checks have no independent counterpart elsewhere, and are worth knowing by name:** the cyclic layer's global pairwise-coprimality condition (the corrected shape space's own admissibility rule, and the only check that would catch the enumerator *over*-correcting), the feasibility criterion Σ√Fᵢ ≤ 1/√δ that `aod` §6.1's shape counts are derived from, Part G.4's per-axis bounds, and the within-class cross **coefficient** — which is invisible to output, since the term never binds. Each has a negative control: breaking it makes the check FAIL.

Together they cover every belief the three documents state. Exits nonzero on any FAIL.

Two extra modes cover the cases that would otherwise send you to the CSV. **`--baseline`** adds shape-migration and aggregate-movement reporting: which winners changed census row and in what direction, and how the floor, the low-density tail and the per-shape counts have moved on the common range. **`--explain N`** prints one row's full term breakdown — every intra, within-class-cross and cross term, which one binds, the twist and its F_mid/F_top split, the foreign block's η and u, and whether the value exceeds its class ceiling.

It **replaces the by-hand checking** of each review pass. **Amend it in the same pass whenever the model changes** — each check names the document section it comes from, so a stale check is findable from either end. Note what it does *not* do: it checks the table against the documents' model, not against mathematics. For independent evidence use `brute_compare.py`.

> **Keep it fast, and treat that as a design constraint rather than a nicety.** The whole suite runs in about **0.1 s on 1,700 rows**, which is what makes it something to run reflexively — before every certificate, after every batch, on any hunch — rather than a job to schedule. A check that costs seconds gets skipped, and a skipped check is worth nothing.
>
> So each check should stay **O(rows) or O(rows × parts)** with arithmetic on numbers already parsed from the witness. What does not belong here: enumerating configurations, VF2 or isomorphism work, re-deriving B(n), sieving past `NMAX`, or anything whose cost grows with n rather than with the row count. Those are `brute_compare.py`'s and the certificates' business, and they have their own items.
>
> The one place this bites is a check that wants to compare a row against alternatives rather than against a formula. If a new check needs that, it belongs in a certificate — and if it must live here, budget it against the 0.1 s and say so at the check, so the next person knows what they are protecting.

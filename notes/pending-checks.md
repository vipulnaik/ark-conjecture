# Pending checks

*What is left to run or verify, for the arithmetic programme — `orbital-evasiveness-notes.md` §§1–6, `enumeration-proof.md`, `arithmetic-of-density.md`. **Outstanding work only** — anything closed moves to a session log and is not restated here.*

> **The computational programme is complete to its planned bounds.** `mu_enumerate_v2.py` has the table contiguous over every non-prime-power n ≤ **2,600**; `ladder_verify.py` has scanned to **10⁶**; R1 runs clean against both; and R7 is **vacuous at the conjectured floor of 1/25**, every worklist entry pruning on its own lower bound with no survivor to compute. So R0, R1 and R7 are not a backlog: **a further run of those happens only if a bug is found or the range is deliberately extended**, and in either case the trigger is a change to the code or a decision about scope, never an outstanding obligation. **R8 is the exception and the one computational item genuinely owed** — the attainment leg of μ(n) = B(n) is checked at twelve values against the certificate side's 2,186, and its battery has never been run on the fusion counts that set four of the class ceilings. Its seven-witness core now passes cleanly, foreign-part configurations included; what is owed is width, not repair. It sits in §1 with the other runs, since it is a run: `gap -q -A verify_witness.g`, with its step 1 entries already in the file.

> **The table is a contiguous prefix plus a biased tail.** Rows above the contiguous frontier are worklist rows, not range, so every distributional figure is quoted over the prefix — see R0. Read counts of the read-pass state in `session-log-6.md` and its predecessors; this file carries only what is outstanding.

**Small-degree work lives elsewhere.** Everything pursued at a single fixed degree — the GAP battery, the CSP and its backbone probes, the χ machinery, the template enumerator — is in `small-degree-verification.md`, including its own run list. It touches this programme at exactly one point: **exhaustiveness of the GAP stages**, which licenses Part I's two non-circular comparisons at n = 10 and n = 12. Nothing else there gates anything here.

**Companion files.** The three documents hold the results and their figures. `three-part-family-split.md` holds the internal split of the three-part family — which of S4, S5 and S7-at-F=2 realises it — kept separate because its conclusions concern runners-up and nothing in the main line depends on them. `fusion-count-ceilings.md` records the derivation of §3.3.5's ceilings as a joint optimum over (F, η) — kept as a separate note because it carries the working, the measurements and the diagnosis of the superseded claim, none of which belongs in a document that states only current understanding. `solvable-relaxation.md` computes the same extremal problem with Oliver's condition relaxed to bare solvability, isolating what the chain costs; it is a calibration exercise and nothing in the main line depends on it. The review record is in `session-log-6.md` (current), `session-log-5.md`, `session-log-4.md`, `session-log-3.md`, `session-log-2.md` and `session-log.md`. Literature findings, which bear on framing rather than correctness and are deliberately not folded into the primary documents, are in `literature-findings.md`. Single-small-degree work — the GAP battery, the SAT/CSP machinery, the backbone probes, the template enumerator — is in `small-degree-verification.md`, which touches §§1–6 only through the n = 10 and n = 12 exhaustive comparisons cited in Part I.

**Status labels.** *Verified* — an independent computation agreed. *Sound* — an argument was read and found correct, with no independent computation. *Unverified* — neither.

*Do not restate the inequality as `B_safe ≤ μ`.* `B_safe` deliberately over-counts per configuration, so B_safe and μ are incomparable in general; what holds is B_refined ≤ μ ≤ B_safe, with the endpoints collapsing wherever the certificate applies.

## Where the residual risk sits

Ranked, so the sections below have a stated basis. This is not the order the items appear in.

1. **The table's reach.** The table is contiguous over every non-prime-power n ≤ 2600 and the ladder has scanned to 10⁶; everything measured across the three documents is keyed to those bounds and moves if either extends, so extension is the single largest source of churn in the recorded figures — though extending is now a *choice*, the planned bounds having been reached. → **R0**, and **R1** after every batch.
2. **Exhaustiveness of the GAP stages.** The subdirect-product hole is undischarged. It degrades *evidence* rather than creating an error — a missed group with larger m\* would be a counterexample rather than a silent corruption, and one with smaller m\* changes nothing — but it is the only non-circular check in the framework. **This is the one small-degree item the arithmetic programme depends on**, since Part I's two exhaustive comparisons rest on it. → `small-degree-verification.md` item 5
3. **Part E's realisability construction.** Attainment's other leg, argued in general and checked at seven configurations from n = 10 to 308 — none of them at the fusion counts that now set four of the class ceilings. Unlike the certificate, which is verified at every row, it has no per-n verification. → **T2** for the argument, **R8** for the run that would close most of it.
4. **§3.3.5's ceilings.** Both coordinates of the joint optimum are settled without a search — the F side by cap_F(1) = 1/(1 + √F)², the η side by the congruences of §3.3.4a — so what remains is the supply hypothesis shared with the rest of §3, plus a class-11 entry resting on 676 > 675. Nothing computed depends on any of it, these being family guarantees and hence floors for μ; the exposure is to the asymptotic story alone. → **T6**
5. **The κ parameters at k = 3.** The F = 4 result transfers to k = 3, but the tables hold κ_r = 1 and treat κ_c as free; whether κ can be steered independently of the congruences fixing F and η is unchecked. No risk to k = 2. → **T7**
6. **The eight necessary conditions of `fb_common.py`.** *The largest unread surface in the framework: the structural arguments have had a second independent reading and these have not.* Both certificates rest on these and nothing else. What matters is their being *necessary* — that is what makes an empty candidate list a proof — and that is a different reading from checking each is true. The file carries a per-condition necessity argument, so what is exposed is the quality of those eight arguments, and in particular condition (4)'s cyclic-layer stripping, which is the load-bearing one and whose necessity is threshold-scoped. The defect class to watch is an enumeration narrower than the shape space it must cover: it removes a real candidate silently and leaves the output looking clean. → **T3**

---

# §1. Script runs

*Can be launched in the background. Flags are checked against the scripts as they stand; where a run needs code that does not exist, that is said rather than papered over with a plausible-looking flag.*

## R0. Extend the table, then rerun everything downstream

`mu_table_safe_v4.csv` holds **2,186 rows, contiguous over every non-prime-power n ≤ 2600**, and extends at roughly n^2.9 per value. **Rows above 2,600 are worklist rows, not range:** values consumed from `ladder_weak.txt` under R7 are appended to the same CSV, and since the worklist selects n *by low ladder score*, those rows are a low-density subsample — median density 0.0662 against 0.1994 below the frontier. Quote every distributional figure over n ≤ 2,600; quote the floor and “nothing below X” over the whole file. Extending the *contiguous* range is what moves the aggregates, and it is what “extend the table” means here. R1 runs clean against it and the documents are recounted to it. What is left on this axis:

1. **Rebuild the branch-and-bound worklist**, since its pruning is keyed to the density floor and the floor has moved (item R7).
2. **Extend further** when wanted, rerunning R1 each time.

```bash
python3 mu_enumerate_v2.py --nmax <N> --fill-gaps --out mu_table_safe_v4.csv
```

**A rebuild must never lower a value.** B(n) is a maximum over admissible configurations, so adding configurations can only raise it: a rebuild that comes out *lower* anywhere means a shape has been lost, not gained. `validate_table.py`'s group-A monotonicity check against `--baseline` is what tests this, and it is the signature to read on every batch.

## R1. Routine, after any new batch of table values

> **Clean at n ≤ 2600, 2,186 rows; nothing below is owed until the table moves.** Expected output, so that a deviation is recognisable: `validate_table.py` **23 PASS / 0 FAIL**; `fallback_cert.py` **0 candidates in both modes**; `wide_cert.py 100000` certifying 90,299 of 90,299; `a18_verify.py` and `t5_verify.py` green. `check_doc_figures.py` does not go to zero — most of its PASS 1 flags are coincidental numeric matches, so it is read finding by finding rather than as a pass/fail.

Every one of these is a per-n statement that does not extend itself, and none of them extends with the table. Point them all at **v4**. **Run in this order** — the first gates the rest. Extending the table is R0's step, not one of these; this list is what the extension obliges.

```bash
# 1. cheapest, and gates everything: is the file a well-formed enumeration?
python3 validate_table.py mu_table_safe_v4.csv --baseline mu_table_safe_v2.csv \
        --ladder ladder_weak_v8.txt

# 2. the per-n collapse proof, then the same run with the trusted base shrunk
python3 fallback_cert.py mu_table_safe_v4.csv --verbose
python3 fallback_cert.py mu_table_safe_v4.csv --no-theorems

# 3. the wide certificate.  MU_ENUMERATE IS REQUIRED: the default is
#    mu_enumerate.py, absent from the working set, so the import fails on load.
MU_ENUMERATE=$PWD/mu_enumerate_v2.py python3 wide_cert.py 100000

# 4. the range-scoped halves of Lemma D2's and Corollary C′'s domination
python3 a18_verify.py mu_table_safe_v4.csv
python3 t5_verify.py mu_table_safe_v4.csv

# 5. the documents against the table (five passes, incl. refs)
python3 check_doc_figures.py mu_table_safe_v4.csv *.md
```

**What each one is for, and what to read off it.**

- **`validate_table.py`** — pass `--ladder` the current worklist as well as `--baseline` the previous table: the two cross-artefact checks it enables are the cheapest instance of the defect class T1 item 3 names, and they cost a dict join rather than a recomputation. One is a correctness check (the ladder's lower bound must never exceed the table's density) and one a coverage diagnostic (where it falls well below, the four families are missing a shape the enumeration finds, and the witness column names it). A FAIL in **group A** means the run itself is broken and nothing downstream is meaningful; a FAIL in **group B** is a real contradiction between table and documents; **group C** is INFO, each line printing the expected asymptotic beside the measurement. `--explain N` gives one row's full term breakdown, `--quiet` shows failures only, `--baseline` adds shape-migration reporting, which is how winners changing census row become visible.
- **`fallback_cert.py`** — the headline is *0 candidates*. Then read three numbers, because **the low-density recount lives here**: the **density floor**, the **largest permitted s**, and the **theorem residue**. They move together, since s ≤ 1/√δ − 1 means a falling floor admits a larger s, and **s = 4 is the first branch with no theorem covering it**. At the current floor of 0.045742 (n = 1817) the bound is 3.68, so s ≤ 3 and E.1 / E.3(iii) / E.4 close everything but one class of 349 E.3(ii) branches. **The margin to δ = 1/25, where s = 4 reopens, is 0.0457 against 0.0400 — one extension could close it.** If `largest permitted s` ever prints 4, `enumeration-proof.md`'s Corollary after E.3 and Part I's tail figures both want re-deriving rather than recounting. The `--no-theorems` run should agree exactly, and the agreement is not vacuous here: 2,204 of 2,553 branches are dispatched in the normal run, so disabling them genuinely moves work into the search.
- **`wide_cert.py`** — read the `settled by theorem:` line. At NMAX ≤ 10⁴ it prints NONE, because B_lo is small enough that the foreign-cap filter removes the s = 1 and s = 3 branches before the dispatch sees them, so a `--no-theorems` comparison there agrees *trivially* and is no evidence about E.1 / E.3 / E.4. `--menu` cross-checks pass 1 against the family menu; `--refresh` rebuilds the cached B_lo, which is rarely needed since the cache is keyed on everything that determines it.
- **`k3_galois.py`** — the k = 3 Galois admissibility predicate, with a self-test covering the a = 35 witness, the superset relation against the naive reading, and the gain-versus-top-prime distinction. Import it; do not re-derive it.
- **`validate_table.py`'s group-B trend check** — for each census row claiming `wins → 0`, the shape's winner share must not *rise* across the range. The verdicts are asymptotic limits, so the count alone tests nothing (S1 and S2 win at half the values in range and still tend to zero); what a density-zero supply argument implies is a declining share. Growth must clear both a proportional bar and Poisson noise on the raw counts, since a rise like 19 → 24 is 26% and entirely consistent with a flat share. `ZERO_SHARE` entries may be a label or a tuple treated as one aggregate — needed because splitting S7 by fusion count costs sensitivity, a trend obvious in aggregate sitting inside noise once divided five ways. To exercise it, replace the `S7f3`/`S7f5` entries with the aggregate `("S7f3","S7f4","S7f5","S7f6","S7f8")`, the historical lumped claim: it fails with `S7f3+S7f4+S7f5+S7f6+S7f8 4.1%→7.6%` against `S2 45.2%→29.3%`.
- **`verify_witness.g`** (GAP) — the Part E realisability check: builds the construction from a witness string, verifies the Oliver chain explicitly, and compares the orbital multiset against the value formula's terms. Driven by **R8**; `WITNESS=... MUBOUND=... gap -q -A verify_witness.g` runs a single row, no argument runs the battery.
- **`eta_derive.py`** — the η column of §3.3.5, computed twice: derived from congruences by exact enumeration mod 2⁷, and measured by scanning real decompositions. Asserts agreement at all thirty-six (class, F) cells, and that none of the three cells whose 2-adic factor is not constant across its mod-24 class is one where F = 4 sets the ceiling. Static; one run per environment.
- **`khomog_verify.py`** — the k-homogeneity claims underlying the hypothesis table of `orbital-evasiveness-notes.md` §1: the c ≡ 3 (mod 4) half-twist case at k = 2, and the five full-density degrees {3, 4, 5, 8, 32} at k = 3, with the sharpness of the order bound that makes the list finite. Static; one run per environment.
- **`a18_rq_verify.py`** — nine static checks on Lemma D2q, the r = q half: the exhaustive (2,5) subgroup scan, the (3,7) rank-2 eigenvector group, and the tightness and twist-collapse controls. Nothing in it depends on the table, so it needs no rerun on extension; one run per environment.
- **`t5_verify.py`** — Lemma C's coupling and Corollary C′: the n = 28, 21 and 10 witnesses with their chains, the coupling's tightness at (16,5) and the chainlessness of the mismatched pairing, the sharing bound against every row, and the three facts underlying the local licence that gates condition (4)'s strip (T5). The last pass is **range-scoped** and expires silently on extension, so it belongs in this list beside `a18_verify.py`.
- **`a18_verify.py`** — Lemma D2's witnesses and its range-scoped half: the n = 85 and n = 91 orbitals and chains, the 2-homogeneity of the n = 91 permuter, and the fused-outside domination bound against every row. Only the third can move with the table, and it is the one that matters: it is a **range-scoped** claim, so a table extension can invalidate it silently. Exits nonzero on any failure.
- **`check_doc_figures.py`** — `--quiet` for findings only, `--pass {figures,scope,prose,hygiene,census,refs,tables}` for one pass; exits nonzero when anything is flagged. **Pass every `.md` that might be cited**, or `refs` reports live cross-document citations as dangling. And append the old maximum to `CHECKPOINTS` and a pattern to `SCOPE` in the same sitting, or figures written against the superseded range report as unexplained rather than as historical.

**Two things deliberately absent from this list.**

- **`ladder_verify.py`** is not a per-batch check — it never reads the table, it scores explicit families. It belongs to **R7** and runs on its own schedule.
- **`s7_scan.py` and `mu_fast.py` are absent** from the working set. `validate_table.py` group B covers the S4 / S5 / S7-at-F=2 congruence patterns `s7_scan.py` would test, so nothing is owed unless a new check is wanted.

**Do not extend the table without rerunning this list in full.** An extension leaves a different subset of the documents behind each time, and the failure is silent: a stale figure reads as a claim about the current range. The two passes that catch it mechanically are `check_doc_figures.py --pass refs` and `validate_table.py`'s coefficient assertion.

## R7. Consume the ladder worklist with the adaptive branch-and-bound

> **Nothing owed at the conjectured floor.** Against the 10⁶ ladder, `--floor 0.04` prunes all **46,520** entries on their supplied lower bounds — the worklist minimum is 0.04453 — so the branch-and-bound has no survivor to examine and δ ≥ 1/25 over 10⁶ is established without computing a single further B(n). What follows is **sharpening**, wanted only if a tighter constant is the goal, plus the mechanics for whenever the range is extended.

*Turning the ladder's lower bounds into decisions about B(n) — **one job, not three**, writing into the existing table.*

> **Regenerate the worklist before consuming it.** The ladder's families and its CAP table both determine the list, so a worklist produced by an older `ladder_verify.py` ranks against the wrong ceiling and omits the shapes that ceiling now depends on. Two properties of the current list are worth knowing before planning a run: it is thresholded at the **asymptotic constant**, which is 7 − 4√3, so it is long — 46,520 entries to 10⁶ — and correspondingly weak as a "compute B(n) here" ranking, since falling short of that ceiling is generic at computed sizes rather than exceptional. The **floor question is not read off this list at all** but off the separate `--floor` count, which reports the values failing a stated floor and is 0 at 1/25 throughout 10⁶. What the list is good for is its *lowest* entries: the ten smallest all lie in [10³, 10⁴], and computing B there is what would sharpen the verified floor.

```bash
python3 ladder_verify.py 1000000                      # regenerates ladder_weak.txt
python3 mu_enumerate_v2.py --nlist ladder_weak.txt \
        --floor 0.0400 --adaptive --out mu_table_safe_v4.csv
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

> **Before committing an expensive n, probe it.** Finding one configuration that clears a floor is sub-second; proving optimality is what costs hours. A targeted scan over the two-part census shapes, scored with `mu_enumerate_v2.py`'s own `value()`, settles the floor question outright whenever the answer is "clears" and costs nothing when it is not. It reproduced B(n) exactly at all eleven worklist values where B was independently known.

**Preconditions and cautions.**

- **Needs R0 finished.** The pruning and the part-count cap are both keyed to a floor read off the table.
- **Never combine with `--refined`.** The script refuses it, and the reason is worth knowing: adaptive mode appends rows to `--out`, the schema records no mode, so a refined row in an unconditional table would be undetectable and would corrupt every downstream figure.
- **Rerun R1 afterwards.** The job adds rows, which is a table extension like any other.
- **Do not overwrite the worklist.** `ladder_verify.py` honours `LADDER_OUT`; each run's file is the evidence for figures in §3.7 and §5.2.

## R8. Widen the Part E realisability battery

*The one leg of μ(n) = B(n) with no per-n check. **The battery's seven-witness core passes cleanly** — all seven true, foreign-part configurations included — so what is owed here is width, not repair. (It had been reporting `false` on every foreign-part row: `BuildConfig` put a foreign class's C_r translations into `gens.bottom`, so `IsPGroup(G2)` failed on a chain that is not the construction's — Part E puts them in the cyclic layer. Fixed, and the verdict line now names each failing condition, since a bare `false` beside orbital data that visibly matches invites hunting in the wrong place.)* *Current coverage: the certificate side is verified at all 2,186 rows, attainment at **twelve**, the largest n = 575. `verify_witness.g` is the tool; step 1 below is ready to run.*

**Why this is the highest-value run available.** `validate_table.py` group A checks that the construction's *ingredients* exist at every row — block counts, foreign twists, a diagonal carrier — but not that assembling them yields a group whose minimum orbital is B(n). `verify_witness.g` does exactly that, and does three things a looser check would not: it verifies the Oliver chain explicitly rather than assuming the generator placement is right; it compares the whole orbital **multiset** against the predicted terms, since matching only the minimum can pass while realising a different group; and it uses the diagonal-carrier-stripped twist, which is the construction's requirement rather than SAFE's looser `dmax`.

**Why the even fusion counts were added.** The battery's original seven entries use F ∈ {1, 2, 3, 5} and exercise **no even F ≥ 4** — the same blind spot that kept even F out of `ladder_verify.py`'s S7 loop, and from the same source: the belief that a fusion count had to be a prime power. Since S7 at F ≥ 3 attains the class ceiling at residues 7, 11, 15 and 23 (`aod` §3.3.5), that family carries as much weight as any in the battery and had no construction evidence at all.

**Step 1 — run the battery.** The five even-F entries are **already in `verify_witness.g`**; just run it:

```bash
gap -q -A verify_witness.g
```

They are n = 20, 255, 282, 323 and 575, all at battery speed. Between them they cover both branches of `ConstructionTwists`, which a single entry would not:

> - **F a q-power** — n = 20 (F = 4, q = 2). Then F_top = F and F_mid = 1, so the twist is **not** stripped by F: it stays 4 and the intra term is 4·orb(5,4) = 40, where an F-stripped twist would give 20.
> - **F not a q-power** — n = 255, 323, 575 (F = 4) and n = 282 (F = 6, where 2 and 3 both occupy the cyclic layer at once). Here F_mid = F and the twist is cut coprime to it: twists [21, 41], [21, 25], [51, 81] and 46 respectively.

No code change was needed — `ConstructionTwists` already splits F into F_mid and F_top by q, and `PredictedTerms` already keys the within-class cross coefficient on F's parity. All five have been checked to realise their scores by an independent build, so **a failure here is a finding about the construction, not a malformed entry**; that is the point of pre-checking them.

**Step 2 — a stratified sample, once step 1 passes.** One row per census shape, both parities of n, and each of the twelve odd residues mod 24, preferring the *lowest-density* row available in each stratum — a construction is most likely to fail where the score is tightest. Then the extremal rows: the table floor n = 1817, and the ten lowest worklist entries if their B(n) has been computed.

**The scaling limit, and what to do at it.** `OrbitalSizes` calls `Combinations([1..n], 2)`, which materialises the pair list: 690k entries at n = 1175, 3.4M at n = 2600. That becomes the binding cost well before the table's frontier. A union-find over the generators does n = 1175 in about 3 seconds outside GAP, so for coverage across hundreds of rows, port `OrbitalSizes` to union-find and keep the chain and multiset checks where they are. Do not drop the chain check to buy speed — it is the part that distinguishes this from a re-derivation of the value formula.

**What a pass does and does not settle**, restated because it is easy to over-read and the script's own header says it: a pass establishes that the enumeration's score at that n is **attained**, i.e. μ(n) ≥ B(n). It says nothing about completeness (μ(n) ≤ B(n)), which is Part 0's business, and nothing about J0a — the construction takes each matching twist inside the field's multiplicative group and the script builds exactly that group, so it cannot detect that a larger stabiliser was available.

## R10. Finish the chiral-half homology via Mayer–Vietoris (shelved)

*Shelved mid-computation; picked up from `chiral-graph-properties.md` §6 and `session-log-6.md`. The object is the homology of one A_n-orbit half of the Hamiltonian-cycle complex, and the question it settles is whether any chiral candidate at n = 9 is **ℤ-acyclic** — the first rung above χ = 1, and the lowest rung at which a counterexample could exist.*

**The setup, which is done.** Write L for the S_n-invariant complex whose faces are the subgraphs of Hamiltonian cycles of K_n — that is, all linear forests together with the cycles themselves. When n ≡ 1 (mod 4) the S_n-orbit of Hamiltonian cycles splits into two A_n-orbits (because Stab = D_{2n} ≤ A_n exactly then), giving two chiral halves P₀, P₁ with P₀ ∪ P₁ = L. Mayer–Vietoris on that union, with M = P₀ ∩ P₁ and H̃(P₀) ≅ H̃(P₁) by the outer symmetry, gives

> **H̃(P₀) ⊕ H̃(P₁) = coker( H̃(L) → H̃(M) )**,

so the whole answer is the **Smith normal form of one integer matrix**, and both ends are S_n-invariant even though the halves are not.

**What is established.** At n = 5, H̃₂(L) = ℤ⁶, H̃₁(M) = ℤ⁶, and the connecting map ℤ⁶ → ℤ⁶ is injective with cokernel (ℤ/2)² — so each half has H̃₁ = ℤ/2 and **P₀ ≃ ℝP²**, confirmed three independent ways (directly on its 152 faces; via the nerve, which is the 6-vertex hemi-icosahedron with f-vector (6, 15, 10); and over ℚ, 𝔽₂, 𝔽₃).

**A closed form for one end, regression-tested.** Homology of L is concentrated in degree n − 3 at every n checked, so its rank is the Euler characteristic. With P(x) = x + x²/(2(1−x)) the EGF for a single undirected path,

> **rank H̃_{n−3}(L) = | n![xⁿ] e^{−P(x)} + (n−1)!/2 |**,

the second term being the Hamiltonian-cycle layer, which is *not* a linear forest and whose omission was the first error made here. Values 6, 46, 380, 3396 at n = 5, 6, 7, 8 agree with direct 𝔽₂ computation (the n = 8 case over 120,212 faces); the formula then gives **32,732 at n = 9**, and 339,256, 3,767,724, 44,662,960 at n = 10, 11, 12.

> **This killed a tempting guess, which is worth recording.** At n = 5 both rank H̃(L) and the orbit size are 6, suggesting rank = orbit size. At n = 9 the orbit has 10,080 cycles against rank 32,732, so the coincidence was a coincidence.

**What is owed.**

1. **A formula for rank H̃(M).** M is the sub-complex of forests extending to cycles in **both** orbits, so it is S_n-invariant and the same generating-function route should apply. The count needed is: how many linear forests have all their Hamiltonian completions inside a single A_n-orbit? **M is not the (n−3)-skeleton** — at n = 5, 30 of the (n−2)-edge faces are already chiral — which is the guess to avoid. The parity argument that gave the n ≡ 1 (mod 4) criterion (D_{2n} ≤ A_n) is the likely tool.
2. **The Smith form of the connecting map.** P₀ is ℤ-acyclic **iff that map is unimodular**; the torsion is exactly its elementary divisors. At n = 5 they are (1,1,1,1,2,2).
3. **Then n = 9**, where the matrix is 32,732 × rank H̃(M).

**Cost and standing.** Direct homology at n = 9 is out of reach — L has millions of faces — which is the whole reason for the Mayer–Vietoris reduction. Even a ℤ-acyclic answer leaves the candidate two rungs below a counterexample, since ℤ-acyclicity is necessary and far from sufficient for non-evasiveness, and every chiral candidate computed so far is known evasive. **Do not let a positive answer here be read as a counterexample.**

# §2. Thinking work

> **Scope.** The structural arguments of `enumeration-proof.md` — Part 0, Parts A–J, the B′ socle proof, D, D2, E, E′, E″, F, G — and `orbital-evasiveness-notes.md` §§1–11 have each had a second independent reading, with the mod-24 constants, the witness rescoring, `eta_derive.py` and two group constructions recomputed from scratch. No mathematical error was found in them; what that reading returned was documentation drift, and the machinery for catching that now lives in `check_doc_figures.py`. **Not covered by any of it:** `fb_common.py`, the literature items, and the scripts other than `eta_derive.py` and `count_check.py`. The items below are what remains.


## §2a. Needs human thought

*Judgement calls, independent scrutiny, or things requiring materials Claude cannot obtain.*

### T1. Independent reading of the structural arguments

**A step compressed to a clause tends not to survive being written out**, and this framework's record bears that out. Of its compact structural steps: one is false (the ΓL(1) step); one is false as stated and correct once repaired (the q-power block count); one needed two gaps filled (B′); two are exclusions that are only dominations (Lemma D2, whose conclusion fails outright at F ≥ 3, and Lemma C, whose gcd = 1 fails at every a and gives way to a coupling); one is an upper-bound claim that is only an attained value (the within-class cross coefficient, scoped to the construction); and one was a supply claim whose proof covered half its quantifier (the census S7 row at F ≥ 3, whose "F·c even forces c = 2^a" holds only for odd F).

**Three failure sites, calling for three different checks.**

1. **Reasoning over the wrong partition of cases**, which accounts for most of them. In four the false clause quoted a small or regular group's behaviour as if it bounded every admissible one; in the S7 case the partition was F odd versus F even and the sentence's own arithmetic silently selected the odd branch. *The check is to ask which cases a clause was verified on, and whether its quantifier is wider.*
2. **Transcription from proof to statement**, which accounts for Lemma C: its a = 1 proof established "share ⟹ outside twist trivial" while the sentence recording it claimed "no share". The proof was correct and the statement stronger, and the discrepancy survived because the statement was only ever tested against the case its proof did cover. *The check is to read each lemma's statement against its own proof's conclusion, independently of whether the proof is believed.*
3. **Contradiction between artefacts that nobody compared.** The S7 error is the clearest instance: `mu_enumerate_v2.py`'s `parts_for` implemented the correct reading and found 125 winners of the shape, while the census row asserted it wins nowhere, and `validate_table.py` printed both figures a few lines apart in the same report on every run. The same shape recurs in the strip-trace and `--no-theorems` findings. *The check is cheap and mechanical — compare each prose claim against the artefact that would contradict it — and it is the one most likely to be skipped, because neither artefact looks wrong on its own.*

**What is settled.** Parts A–J and Part 0 have had a second reading by someone with no prior exposure, and the three failure sites above were the checks it ran. It found **no mathematical error** in any structural step; in particular **B′'s socle argument is confirmed** — Step 0 does need irreducibility plus C_G(V) = V, exactly as written, and both cases close. Every finding it returned was failure site 3, a claim contradicting an artefact nobody had compared it against, which is the site this file predicted would be most productive and the one a reader catches most cheaply.

**What remains, and it is narrower than the original item.** A further independent reading is still worth more than another pass by either previous reader — the argument for independence does not stop applying once two readers agree, and this framework's record is of errors surviving one reading each. And **a machine reading is weakest exactly where the failure mode is "an argument that reads as plausible"**: it verifies constants and recomputes tables freely, and has no way to notice a step whose plausibility is doing the work. That is the residual human item.

**Where to look, in order.** Part E's realisability construction is still the least-defended thing the framework relies on — it exhibits groups and nothing checks it per-n (T2), and the read pass could not change that, since reading a construction is not building one. Part 0's completeness is the step with the worst record and the sole support for μ ≤ B_safe; it has now had two readings and remains the place a missing shape would hide, because a missing shape has no witness to contradict. Below those, Parts D2q and E″ carry the most intricate case analysis per line.

### T2. Part E's realisability: preconditions are checked, construction is not

The preconditions check is **built and passing**: `validate_table.py` group A asserts per winner row that the Part E build's ingredients exist: F_top a q-power, every foreign block scored above r actually having q | r − 1 (live at 1,409 rows), and the **diagonal carrier's order coprime to every foreign prime and every F_mid in the configuration** (live at 1,665 rows). That last is deliberately stricter than SAFE's `dmax`, which strips only a class's own F_mid — looseness is safe for an upper bound but not for a construction, and attainment needs the construction.

**Part E's construction has been read and found sound as written** — the layer assignment, the diagonal carrier, the forced orbital sizes, and the F-parity coefficient with its correctly-scoped pitfall box all check out, and E.3(ii)'s (c, r) = (11, 5) group was rebuilt independently, returning orbitals {10, 55, 55} as predicted. **That does not close this item**, and the distinction is the point of it: reading a construction establishes that it would work if assembled, not that assembling it at the table's actual configurations yields the predicted orbital multiset. Only R8 does that, and R8's coverage is twelve values against the certificate side's 2,186.

**What is left for a human, and it is the part a check cannot reach.**

- **Whether to build groups at all, and how often.** Preconditions existing is not the same as the group existing. The n = 10 and n = 12 exhaustive batteries plus eight hand-built configurations from n = 12 to 315 are the current evidence; the construction check itself is **R8**, which is where the shapes and the order to run them are set out. The priority there follows from the ceiling table: **S7 at F ≥ 3 has moved from least-evidenced curiosity to the shape attaining the class ceiling at four residues** (`aod` §3.3.5), and the battery has no even-F entry at all.
- **J0a, the stabiliser assumption.** The construction takes a matching block's twist inside the field's multiplicative group, whereas the stabiliser of a primitive affine group of degree p^a may be any irreducible subgroup of GL(a, p). This cannot inflate B_safe, which already credits C(c,2), but it is an unstated assumption bearing on attainment. **No precondition check reaches it**, because the witness records a twist order and not the group the twist lives in. Either justify the restriction or scope the realisability claim to it.

### T3. Independent necessity read of the eight conditions

These are the whole trusted base for μ(n) = B(n): both certificates pass with every Part E′ theorem disabled, so nothing else carries weight in the per-n proof. The question is not "is each condition true" but **"is each condition necessary"** — does every fallback configuration attaining B(n) really satisfy it. **The direction to fear is permissive**: a condition that is not in fact necessary silently removes a real candidate and leaves an empty list looking like a proof, and it is invisible from the certificate's own output.

`fb_common.py` carries a per-condition necessity argument in the header, so **what is outstanding is scrutiny of those eight arguments rather than the reconstruction of them**. Two places to press hardest, both flagged in that header. **Condition (4)'s cyclic-layer stripping** is the load-bearing one, and its necessity is now *conditional* rather than absolute: the strip is licensed by Corollary C′ exactly where sharing_bound(p, a, r) < B, so what wants scrutiny is the licence and its gate rather than the strip itself — and in particular whether the bound is right, since an over-generous bound licenses an over-strip and the resulting loss is invisible in the output. **Condition (6)** is *not* independently necessary and is retained only as a tripwire — check that nothing has come to rely on it.

*Human, for the same reason as T1: the value is in the independence.* **The eight necessity arguments have had exactly one reading** — `fb_common.py` has not been in the working set of any review pass. Of everything in §2a this is the largest unread surface, and it is the whole trusted base for μ(n) = B(n) on the certified range.

### T4. Literature: one high-upside investigation, four smaller owed items, framing deferred

*Untouched by any review pass so far, all of which stayed inside the documents; every item below stands as written. Four passes are written up in `literature-findings.md`, which carries a reference convention — every citation of our own documents is prefixed `` `aod` ``, `` `notes` ``, `` `ep` ``, and a bare § belongs to a cited paper. Two candidate follow-ups — running our CSP against Angel–Borja's surviving types, and chasing the two-orbital criterion computationally — are **deliberately not on the list**: the exhaustive n = 10 and n = 12 batteries already validate the machinery more strongly than either would.*

**Outstanding, and it is the item with the most upside in this file.** Skorobogatov–Sofos (*Inventiones* 231, 2023) prove Schinzel's Hypothesis on average and use it to get a *positive proportion* of varieties with rational points — the move being that one does not need the full conjecture, only that most polynomials satisfying the obvious necessary condition represent at least one prime. **That is structurally `aod` §4**, which needs not an asymptotic at every n but only that for almost every admissible n *some* shape in `aod` §6's finite feasible set is realised. If the averaging works over our shape families, §4's density claim moves from conditional to unconditional, which changes what the paper is. Obstacles to check: the coprimality budget means our family is not a generic family of polynomials, and their result is for linear polynomials in several variables, which fits our two-part shapes better than the fused ones. **Read before `aod` §4 is written, not after.**

**One comparison replaces a reading task.** `literature-findings.md` items 4 and 17 identify Black's spacing framework (ITCS 2015 / ACM ToCT 2019) as containing the sub-board Fourier-degree route, p-group hypothesis included. What is left is not to read it but to ask a specific question: **does our group data give better spacing at composite non-prime-power n than the sequences already in the literature?** His target is Ω(n) asymptotically; ours is constants near C(n,2) at specific n, which his framework does not chase. The two feed the same machinery with different objectives, so the comparison is concrete — compute spacing for the orbit augmentation sequences our batteries supply.

> **Note the optimisation runs opposite to the battery selection.** That route wants many *small* orbitals; the max-m\* search wants the reverse and discards exactly the useful groups. Same inversion as the two-orbital criterion.

**Three primary-source checks owed before publication**, each flagged at its site in `aod` §3.6: the θ = 1/4 rung is attributed to Bombieri–Vinogradov on Shparlinski's framing rather than from the original; the Chowla row names a conjecture-type rather than a specific paper; and **the Ω(n²/3) bound is attributed by at least one survey to unpublished work of Santha–Yao rather than to Scheidweiler–Triesch**, whom we cite alone in `aod` §5 and the `notes` reference list. Citing one of two is a priority claim we have not checked.

**The step we are missing, and it is elementary.** Jones–Zvonkin is a *programme* — at least five papers applying Bateman–Horn to dessins, permutation groups, block designs and simple-group orders, with a stable recipe (`literature-findings.md` item 20). Their step (ii) is an explicit, elementary verification of Bunyakovsky's conditions for each polynomial. **`aod` §3.5 asserts an ample supply without doing the analogue** — checking, per shape family, that the relevant system satisfies Schinzel's conditions and has no fixed prime divisor. That is a page of work per family and it interacts with the polynomial-versus-exponential line below: a shape with unbounded exponent has no polynomial to check, which is itself the finding.

**Deferred: the framing decision.** Jones–Zvonkin's programme (arXiv:2106.00346 and four companions) is the model for how this genre states its standing — conditional on Bateman–Horn, labelled as such in the abstract, with the conjecture validated numerically at the range used. Three consequences are recorded in `literature-findings.md` items 14–16 and are *not* being acted on yet: a standing table at the front of `aod` §3 dividing unconditional from conditional from conjectural; the polynomial-versus-exponential line in `aod` §3.5, since shapes needing prime powers of unbounded exponent are Mersenne-like and outside Bateman–Horn; and the Catalan/Pillai caution where both parts are proper prime powers, which is our S1 and S2 and which `aod` §6 currently treats as amply supplied.

### T5. Condition (4)'s strip, and the residue that blocks B_refined = B_safe

*The mathematics is in `enumeration-proof.md` Part D (Lemma C's coupling and Corollary C′); the gate is implemented in `fb_common.py` at both strip sites. `fallback_cert.py` reports 0 candidates at all 2,186 values in both modes.*

**The licence.** Condition (4) caps a leftover p-characteristic part by stripping the foreign prime r from its twist. Corollary C′ licenses that strip exactly when a configuration retaining the share cannot reach B, and the sharing bound is **local to (p, a, r)**:

> **sharing_bound(p, a, r) = min(r·ord_r(p), C(r,2))**, and the strip is sound iff this is **< B**.

No n, no density floor, no threshold on the table. At **a = 1** the coupling forces ord_r(p) = 1, so the bound is r and the licence reads r < B. The strip only ever acts when r | p^a − 1, i.e. ord_r(p) | a; elsewhere the gate is vacuous either way. Both sites are gated: the primary block in `pair_candidates` and the leftover in `single_part_ok`.

**The gate carries an assertion rather than a silent `if`, and that is load-bearing.** A strip firing where it is not licensed discards a real candidate and produces the same empty candidate list as a correct run, so the failure is invisible in the output and must be caught at the point of decision. `set_strip_trace()` records every decision as (p, a, r, B, bound, licensed), which is the only way to observe the gate at all.

**At the current frontier the gate is inert, and knowing that is worth more than the counts.** Instrumenting every strip decision the certificate reaches over the whole table gives **74**, all at a = 1, none at a > 1, and no verdict differing from an ungated run. The a > 1 branches never reach condition (4): 129,878 enter `pair_candidates`, 120,389 survive the divisibility and dispatch filters, and every one dies at the foreign cap `orb(r, t) < B` first. So the foreign block's own cap already excludes every proper-prime-power branch, and the licence earns its place by staying correct as the table extends and that cap stops biting — not by changing anything now.

> **Do not reintroduce a branch-count figure here without measuring it.** Condition (4) is evaluated 30 times at n ≤ 2000 and 74 times over the whole table, with zero proper-prime-power evaluations at either. Any larger figure describes a different quantity or a different version of `fb_common.py`.

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

**Tripwire, worth keeping.** `validate_table.py` asserts per row that no winner has a proper prime power c with a foreign prime dividing c − 1 — 0 of 2,202 p-characteristic winner parts, rechecked on every extension. It confirms a proved domination rather than guarding an open lemma, and flags the first n where Corollary C′ would have to be checked directly.

### T6. The residual conditionality in §3.3.5's ceilings

Both coordinates of the joint optimum are settled without a search. The **F side** closes on cap_F(1) = 1/(1 + √F)² together with η ≤ 1, which bounds each F-slice with no arithmetic input and excludes F ≥ 8; the parity constraint at odd n leaves F ∈ {2, 4, 6}, and at residues 7 and 15 the tabulated value *is* cap₄(1), so those rows admit no improvement at all. The **η side** is derived from congruences in §3.3.4a — a 2-adic factor 2^(1−v) with v fixed by r mod 8, and a 3-adic cut by 3 when 3 | r − 1 is forced — and `eta_derive.py` checks that derivation against an independent measurement at all thirty-six (class, F) cells.

**What is left is one hypothesis and three scope limits.**

- **Supply, which is the same hypothesis as everywhere in §3.** The congruences say a suitable r is unobstructed; that primes of the form r = 2^v·q^e + 1 actually occur near the balance point in the density §3.4 needs is Bateman–Horn. Nothing in §3.3.4a improves on that, and it is why the ceilings are family guarantees rather than theorems about δ.
- **Only F ≤ 6 is derived.** §2.1's bound makes that sufficient for the conclusion, but the congruence bookkeeping itself has been done for F ∈ {2, 4, 6} only.
- **Mixed three-part shapes** — 4c + 2c′ + r and the like — lie outside both the two-part family and the three-part ladder, and no ceiling here bounds them.
- **Class 11's entry rests on 676 > 675.** The comparison 7 − 4√3 > (2 − √3)/4 reduces to 26 > 15√3, the narrowest possible integer margin. The derivation removes the way the η there was most likely to be wrong, but the margin is what it is, and anything upstream that moves it flips the class. *(Independently re-verified, along with every closed-form constant in §3.3.5, the cap_F(η) = cap₁(Fη)/F identity, and a rerun of `eta_derive.py` — 36/36 cells, no ceiling-setting cell splitting across its mod-24 class. The exposure here is the supply hypothesis and the margin, not the arithmetic.)*

*Working, measurements and the diagnosis of what the table said before are in `fusion-count-ceilings.md`.*

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

*A standing constraint on `validate_table.py`'s group A density test, recorded because the natural implementation is wrong in a way that only ever shows at the values the test exists to admit.*

**The constraint.** A stored decimal density with k places is a correct rounding of μ/C(n,2) iff |stored − B/C| ≤ ½·10⁻ᵏ. That must be evaluated in **exact rational arithmetic**, and k must be **read off the string** rather than assumed:

```python
def density_ok(r):
    s = r.delta_str
    places = len(s.split(".")[1]) if "." in s else 0
    return abs(Fraction(s) - Fraction(r.B, r.C)) * 2 * 10 ** places <= 1
```

This needs `Fraction` imported and the raw string kept on the `Row` as `delta_str`, since `float(d["density"])` discards exactly what the check needs.

**Why not a float tolerance, which is the obvious version.** `abs(r.delta - r.B / r.C) > 5e-7` looks equivalent at six decimals and is not. An exact tie rounds to a difference of exactly 5e-7 — the tolerance is the boundary — and evaluating that subtraction in doubles lands a few ulps above it, so the comparison rejects a correctly rounded row. **n = 2561 is the instance in the current table**: μ/C(n,2) = 250978/3278080 = 49/640 = 0.0765625 exactly, the only six-decimal tie in 2,186 rows, where the float difference is 5.000000000005e-07. Widening the tolerance would hide this while weakening the check.

*The general form, which is worth carrying to any other threshold test here.* **A tolerance equal to the exact boundary of the property it tests fails on the boundary cases** — those are the only inputs that reach it, and floating point settles them by accident of representation. Move the comparison into arithmetic with no boundary error rather than moving the boundary.

**What the test must still reject**, and what a change to it should be re-checked against: one-in-the-last-place errors in *either* direction, truncation rather than rounding, and wholly wrong values; while accepting a tie rounded either way and strings at 4, 6 or 8 decimals at their own precision. Eleven such cases plus the full table are the standing behavioural check.

**A framing point left open for a decision.** Group A's banner says a FAIL there means the run or the parser is broken and nothing downstream is meaningful. That holds for its other four tests and not for this one, which checks a presentation column no other check reads: a density mismatch with the G.3 re-derivation passing is cosmetic. Either move this test to group B or say so in the message.

### A0b. `validate_table.py` — run this on every table extension

`python3 validate_table.py mu_table_safe_v4.csv --baseline mu_table_safe_v2.csv`

Checks are grouped into three, and the group tells you what a result means:

- **A. Table integrity** — is the file a well-formed enumeration at all? Well-formedness, Lemmas B′ and D2 on each witness, re-derivation of `mu_bound` from the witness by the G.3 formulas, the density column, certification, monotonicity against a baseline, and the **Part E preconditions** (T2) — whether the construction's ingredients exist at each row, which the score re-derivation would not notice. A FAIL here is a bug in the run or the parser, and nothing downstream is meaningful until it clears.
- **B. Exact claims, holding at every n** — Prop F.1, cap_F(η), S2's 1/F, layer-by-top-prime, S6 emptiness, Lemma C exposure, the cyclic layer's pairwise coprimality, the feasibility criterion, Part G.4's per-axis bounds, the within-class cross coefficient, and the three congruence-gated patterns (S4 at c ≡ 1 mod 8; S7-at-F=2 at c ≡ 3 mod 4 bar the tie and p = 2; S5 at no congruence with u ≤ 9). A FAIL here is a real contradiction between table and documents.
- **C. Density and distribution** — floor and the s/k bounds it implies, low-density tail, part-count distribution, census shares, odd-n shares, class-ceiling exceedance, median density by residue mod 24, foreign-block efficiency, and the ω(n) = 2 share. All INFO, each printing the **expected asymptotic value beside the measurement** so the comparison needs no reference to `arithmetic-of-density.md`. A gap here is data about convergence, not a failure.

**Four of the group-B checks have no independent counterpart elsewhere, and are worth knowing by name:** the cyclic layer's global pairwise-coprimality condition (the corrected shape space's own admissibility rule, and the only check that would catch the enumerator *over*-correcting), the feasibility criterion Σ√Fᵢ ≤ 1/√δ that `aod` §6.1's shape counts are derived from, Part G.4's per-axis bounds, and the within-class cross **coefficient** — which is invisible to output, since the term never binds. Each has a negative control: breaking it makes the check FAIL.

Together they cover every belief the three documents state. Exits nonzero on any FAIL.

Two extra modes cover the cases that would otherwise send you to the CSV. **`--baseline`** adds shape-migration and aggregate-movement reporting: which winners changed census row and in what direction, and how the floor, the low-density tail and the per-shape counts have moved on the common range. **`--explain N`** prints one row's full term breakdown — every intra, within-class-cross and cross term, which one binds, the twist and its F_mid/F_top split, the foreign block's η and u, and whether the value exceeds its class ceiling.

It **replaces the by-hand checking** of each review pass. **Amend it in the same pass whenever the model changes** — each check names the document section it comes from, so a stale check is findable from either end. Note what it does *not* do: it checks the table against the documents' model, not against mathematics. For independent evidence use `brute_compare.py`.

> **Keep it fast, and treat that as a design constraint rather than a nicety.** The whole suite runs in about **0.1 s on 1,700 rows**, which is what makes it something to run reflexively — before every certificate, after every batch, on any hunch — rather than a job to schedule. A check that costs seconds gets skipped, and a skipped check is worth nothing.
>
> So each check should stay **O(rows) or O(rows × parts)** with arithmetic on numbers already parsed from the witness. What does not belong here: enumerating configurations, VF2 or isomorphism work, re-deriving B(n), sieving past `NMAX`, or anything whose cost grows with n rather than with the row count. Those are `brute_compare.py`'s and the certificates' business, and they have their own items.
>
> The one place this bites is a check that wants to compare a row against alternatives rather than against a formula. If a new check needs that, it belongs in a certificate — and if it must live here, budget it against the 0.1 s and say so at the check, so the next person knows what they are protecting.

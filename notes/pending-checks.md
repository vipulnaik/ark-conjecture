# Pending checks

*What is left to run or verify, for the arithmetic programme — `orbital-evasiveness-notes.md` §§1–6, `enumeration-proof.md`, `arithmetic-of-density.md`. **Outstanding work only** — anything closed moves to a session log and is not restated here.*

**Small-degree work lives elsewhere.** Everything pursued at a single fixed degree — the GAP battery, the CSP and its backbone probes, the χ machinery, the template enumerator — is in `small-degree-verification.md`, including its own run list. It touches this programme at exactly one point: **exhaustiveness of the GAP stages**, which licenses Part I's two non-circular comparisons at n = 10 and n = 12. Nothing else there gates anything here.

**Companion files.** The three documents hold the results and their figures. The review record is in `session-log-4.md` (current), `session-log-3.md`, `session-log-2.md` and `session-log.md`. Literature findings, which bear on framing rather than correctness and are deliberately not folded into the primary documents, are in `literature-findings.md`. Single-small-degree work — the GAP battery, the SAT/CSP machinery, the backbone probes, the template enumerator — is in `small-degree-verification.md`, which touches §§1–6 only through the n = 10 and n = 12 exhaustive comparisons cited in Part I.

**Status labels.** *Verified* — an independent computation agreed. *Sound* — an argument was read and found correct, with no independent computation. *Unverified* — neither.

*Do not restate the inequality as `B_safe ≤ μ`.* `B_safe` deliberately over-counts per configuration, so B_safe and μ are incomparable in general; what holds is B_refined ≤ μ ≤ B_safe, with the endpoints collapsing wherever the certificate applies.

## Where the residual risk sits

Ranked, so the sections below have a stated basis. This is not the order the items appear in.

1. **Lemma D2's coverage — RESOLVED, with a residue.** D2 is **false at F ≥ 3** (explicit Oliver witness at n = 85, m\* = 2|O|), so the shape space was genuinely missing shapes; but the missing shapes are dominated — never above n^{3/2}/2, checked below B(n) at every v4 row and a theorem for n ≥ 1582 — so μ ≤ B_safe is restored and no computed value moves. What remains of the risk is the **r = q sub-case at F < q**, where the argument has no footing and S10's normality argument must be extended; that residue, not D2, is now the ranked exposure. → **A18**, `a18-resolution.md`
2. **The table rebuild.** v4 reaches n = 2000; everything measured across the three documents is keyed to it and moves as it extends. → **R0**, and **R1** after every batch.
3. **Exhaustiveness of the GAP stages.** The subdirect-product hole is undischarged. It degrades *evidence* rather than creating an error — a missed group could only have larger m\*, i.e. it would be a counterexample rather than a silent corruption — but it is the only non-circular check in the framework. **This is the one small-degree item the arithmetic programme depends on**, since Part I's two exhaustive comparisons rest on it. → `small-degree-verification.md` item 5
4. **Part E's realisability construction.** Attainment's other leg, argued in general and spot-checked at eight configurations from n = 12 to 315. Unlike the certificate, it has no per-n verification. → **T2**
5. **The k = 3 Galois admissibility predicate**, corrected but not yet built on. It carries no risk to the k = 2 programme at all — it is listed here because its error direction is the unusual one (under-counting admissible blocks, which at k = 3 breaks the upper bound rather than loosening it) and because the fix is free only until code exists. → **A19**
6. **The eight necessary conditions of `fb_common.py`.** Both certificates rest on these and nothing else. What matters is their being *necessary* — that is what makes an empty candidate list a proof — and that is a different reading from checking each is true. The file now carries a per-condition necessity argument, so what is exposed is the quality of those eight arguments, and in particular condition (4)'s cyclic-layer stripping, which is the load-bearing one. The defect class to watch is an enumeration narrower than the shape space it must cover: it removes a real candidate silently and leaves the output looking clean. → **T3**

---

# §1. Script runs

*Can be launched in the background. Flags are checked against the scripts as they stand; where a run needs code that does not exist, that is said rather than papered over with a plausible-looking flag.*

## R0. Rebuild the table, then rerun everything downstream

`mu_table_safe_v4.csv` reaches n = 2000 and extends at roughly n^2.9 per value. What is left:

1. **Finish the rebuild.**
2. **Rerun all of R1** against it — that list is the whole downstream, and its second item is where the floor, the largest permitted s and the theorem residue get recounted.
3. **Rebuild the branch-and-bound worklist**, since its pruning is keyed to the density floor.

```bash
python3 mu_enumerate_v2.py --nmax 2600 --fill-gaps --out mu_table_safe_v4.csv
```

**Quote figures from v4 only.** v3 is over-credited on fused shapes and v2 predates the corrected shape space, so both understate or misattribute; v4 is at or above v2 at every common value, which is the signature to check on each batch.

## R1. Routine, after any new batch of table values

Every one of these is a per-n statement that does not extend itself, and none of them extends with the table. Point them all at **v4**. **Run in this order** — the first gates the rest.

```bash
# 0. extend the table (this IS the batch; --fill-gaps, not plain resume)
python3 mu_enumerate_v2.py --nmax 2600 --fill-gaps --out mu_table_safe_v4.csv

# 1. cheapest, and gates everything: is the file a well-formed enumeration?
python3 validate_table.py mu_table_safe_v4.csv --baseline mu_table_safe_v2.csv

# 2. the per-n collapse proof, then the same run with the trusted base shrunk
python3 fallback_cert.py mu_table_safe_v4.csv --verbose
python3 fallback_cert.py mu_table_safe_v4.csv --no-theorems

# 3. the wide certificate.  MU_ENUMERATE IS REQUIRED: the default is
#    mu_enumerate.py, which no longer exists, and the import fails on load.
MU_ENUMERATE=$PWD/mu_enumerate_v2.py python3 wide_cert.py 100000

# 4. the documents against the table (five passes, incl. refs)
python3 check_doc_figures.py mu_table_safe_v4.csv *.md
```

**What each one is for, and what to read off it.**

- **`validate_table.py`** — a FAIL in **group A** means the run itself is broken and nothing downstream is meaningful; a FAIL in **group B** is a real contradiction between table and documents; **group C** is INFO, each line printing the expected asymptotic beside the measurement. `--explain N` gives one row's full term breakdown, `--quiet` shows failures only, `--baseline` adds shape-migration reporting, which is how winners changing census row become visible.
- **`fallback_cert.py`** — the headline is *0 candidates*. Then read three numbers, because **the low-density recount lives here**: the **density floor**, the **largest permitted s**, and the **theorem residue**. They move together, since s ≤ 1/√δ − 1 means a falling floor admits a larger s, and **s = 4 is the first branch with no theorem covering it**. At the current floor of 0.045742 (n = 1817) the bound is 3.68, so s ≤ 3 and E.1 / E.3(iii) / E.4 close everything but one class of 247 E.3(ii) branches. **The margin to δ = 1/25, where s = 4 reopens, is 0.0457 against 0.0400 — one extension could close it.** If `largest permitted s` ever prints 4, `enumeration-proof.md`'s Corollary after E.3 and Part I's tail figures both want re-deriving rather than recounting. The `--no-theorems` run should agree exactly, and the agreement is not vacuous here: 1,673 of 1,920 branches are dispatched in the normal run, so disabling them genuinely moves work into the search.
- **`wide_cert.py`** — read the `settled by theorem:` line. At NMAX ≤ 10⁴ it prints NONE, because B_lo is small enough that the foreign-cap filter removes the s = 1 and s = 3 branches before the dispatch sees them, so a `--no-theorems` comparison there agrees *trivially* and is no evidence about E.1 / E.3 / E.4. `--menu` cross-checks pass 1 against the family menu; `--refresh` rebuilds the cached B_lo, which is rarely needed since the cache is keyed on everything that determines it.
- **`check_doc_figures.py`** — `--quiet` for findings only, `--pass {figures,scope,prose,hygiene,census,refs,tables}` for one pass; exits nonzero when anything is flagged. **Pass every `.md` that might be cited**, or `refs` reports live cross-document citations as dangling. And append the old maximum to `CHECKPOINTS` and a pattern to `SCOPE` in the same sitting, or figures written against the superseded range report as unexplained rather than as historical.

**Two things deliberately absent from this list.**

- **`ladder_verify.py`** is not a per-batch check — it never reads the table, it scores explicit families. It belongs to **R7** and runs on its own schedule.
- **`s7_scan.py` and `mu_fast.py` do not exist** in the working set. `validate_table.py` group B already covers the S4 / S5 / S7-at-F=2 congruence patterns `s7_scan.py` would test, so nothing is owed unless a new check is wanted.

**Do not extend the table without rerunning this list in full.** An extension leaves a different subset of the documents behind each time, and the failure is silent: a stale figure reads as a claim about the current range. The two passes that catch it mechanically are `check_doc_figures.py --pass refs` and `validate_table.py`'s coefficient assertion.

## R7. Consume the ladder worklist with the adaptive branch-and-bound

*The 10⁶ ladder run is done (`ladder_weak_v4.txt`, 19,583 entries; findings in `session-log-4.md`). What is left is turning those lower bounds into decisions about B(n) — and it is **one job, not three**, writing into the existing table.*

```bash
python3 mu_enumerate_v2.py --nlist ladder_weak_v4.txt \
        --floor 0.0400 --adaptive --out mu_table_safe_v4.csv
```

**Why this and not a `--nlist` run per tier.** `--floor … --adaptive` is the branch-and-bound of `arithmetic-of-density.md` §5.1 run inside the job, and it does four things a plain run does not:

- **Prunes on the supplied lower bound.** `ladder_weak_v4.txt`'s second column is read as LB(n); any n with LB(n) ≥ the current floor is skipped without computation, since LB(n) ≥ floor already proves δ(n) ≥ floor. At `--floor 0.0400` that disposes of 19,562 of the 19,583 entries for free.
- **Rejects most survivors without computing B(n).** For an unpruned n it seeds the search at floor·C(n,2), so it only has to show *some* configuration clears the floor. Measured on the first 40 entries: n = 1175 is rejected at K = 2 — δ(1175) > 0.04 established without ever computing B(1175).
- **Appends the exact row when it does compute one**, to `--out`, with the full schema and the witness — so the expensive values land in **the same CSV** rather than a side file that then needs merging. It only appends, never rewrites or reorders, and skips n already present.
- **Reads the table back as prior knowledge.** An n already in `--out` is not skipped; its density is fed to the floor. So v4's existing 1,666 rows tighten the search rather than being ignored.

**Set the floor to the question you are asking.** The floor is an interrogation threshold, not the known answer — and setting it to the current global floor would prune everything, 8927 included, since pruning triggers at LB ≥ floor.

| `--floor` | what it settles | entries left after pruning |
|---|---|---|
| **0.0400** = 1/25 | whether any n in 10⁶ leaves room for **s = 4**, the first fallback branch with no theorem | 21 |
| 0.045742 | whether anything undercuts the current table floor | 189 |
| 0.02516 + ε | whether **B(8927) exceeds 0.02516**, which is what §5.1 now turns on | 1 |

Run them in that order; each is a superset of the next in cost and the cheap one may answer the expensive one's question. `--nmax` acts as an upper cut-off on a `--nlist`, which is how to defer the four five-figure entries — at n^2.9 per value, the lone n = 46,127 costs roughly 10⁴ times an n = 2,000 row, so it is worth seeing the rest first.

**Preconditions and cautions.**

- **Needs R0 finished.** The pruning and the part-count cap are both keyed to a floor read off the table.
- **Never combine with `--refined`.** The script refuses it, and the reason is worth knowing: adaptive mode appends rows to `--out`, the schema records no mode, so a refined row in an unconditional table would be undetectable and would corrupt every downstream figure.
- **Rerun R1 afterwards.** The job adds rows, which is a table extension like any other.
- **Do not overwrite the worklist.** `ladder_verify.py` honours `LADDER_OUT`; each run's file is the evidence for figures in §3.7 and §5.2.

# §2. Thinking work

## §2a. Needs human thought

*Judgement calls, independent scrutiny, or things requiring materials Claude cannot obtain.*

### T1. Independent reading of the structural arguments

**A step compressed to a clause tends not to survive being written out**, and this framework's record bears that out: of its compact structural steps, one is false (the ΓL(1) step), one was false and is now repaired (the q-power block count), one needed two gaps filled (B′), one holds only at prime c (Lemma C), and one was an upper-bound claim that is only an attained value (the within-class cross coefficient, now scoped to the construction).

Parts A, E and F have had one close reading each; what is outstanding is a reading by **someone who has not read them before**. A second pass by the same reader on the same evidence is worth much less than a first pass by another, which is the whole reason this is a human item rather than a script.

**Where to look, in order.** Part E's realisability construction is the least-defended thing the framework relies on — it exhibits groups and nothing checks it per-n (T2). Part B′'s socle argument has had one reading and no independent scrutiny. Part 0's completeness is the step with the worst record, and it is the sole support for μ ≤ B_safe. Expect roughly one finding per three arguments.

### T2. Part E's realisability: preconditions are checked, construction is not

The preconditions check is **built and passing** — see `session-log-4.md`. `validate_table.py` group A now asserts per winner row that the Part E build's ingredients exist: F_top a q-power, every foreign block scored above r actually having q | r − 1 (live at 1,034 rows), and the **diagonal carrier's order coprime to every foreign prime and every F_mid in the configuration** (live at 1,239 rows). That last is deliberately stricter than SAFE's `dmax`, which strips only a class's own F_mid — looseness is safe for an upper bound but not for a construction, and attainment needs the construction.

**What is left for a human, and it is the part a check cannot reach.**

- **Whether to build groups at all, and how often.** Preconditions existing is not the same as the group existing. The n = 10 and n = 12 exhaustive batteries plus eight hand-built configurations from n = 12 to 315 are the current evidence; a decision about whether to add occasional GAP spot-checks at new shapes — S4 and S7-at-F≥3 are the ones with the least construction evidence — is a priorities call.
- **J0a, the stabiliser assumption.** The construction takes a matching block's twist inside the field's multiplicative group, whereas the stabiliser of a primitive affine group of degree p^a may be any irreducible subgroup of GL(a, p). This cannot inflate B_safe, which already credits C(c,2), but it is an unstated assumption bearing on attainment. **No precondition check reaches it**, because the witness records a twist order and not the group the twist lives in. Either justify the restriction or scope the realisability claim to it.

### T3. Independent necessity read of the eight conditions

These are the whole trusted base for μ(n) = B(n): both certificates pass with every Part E′ theorem disabled, so nothing else carries weight in the per-n proof. The question is not "is each condition true" but **"is each condition necessary"** — does every fallback configuration attaining B(n) really satisfy it. **The direction to fear is permissive**: a condition that is not in fact necessary silently removes a real candidate and leaves an empty list looking like a proof, and it is invisible from the certificate's own output.

`fb_common.py` now carries a per-condition necessity argument in the header, so **what is outstanding is scrutiny of those eight arguments rather than the reconstruction of them**. Two places to press hardest, both flagged in that header: condition (4)'s cyclic-layer stripping, which is the load-bearing one and the newest; and condition (6), which is *not* independently necessary and is retained only as a tripwire — check that nothing has come to rely on it.

*Human, for the same reason as T1: the value is in the independence.*

### T4. Literature: three edits made, one investigation outstanding, framing deferred

*Four passes are written up in `literature-findings.md`, which carries a reference convention — every citation of our own documents is prefixed `` `aod` ``, `` `notes` ``, `` `ep` ``, and a bare § belongs to a cited paper. The two decisions that used to sit here (running our CSP against Angel–Borja's surviving types; chasing the two-orbital criterion computationally) are **dropped as not worth doing** — the exhaustive n = 10 and n = 12 batteries already validate the machinery more strongly than either would.*

**The three edits are done** — `aod` §5's δ-versus-c(n) distinction with the Rivest–Vuillemin-to-Scheidweiler–Triesch chain and a pointer from `notes` OP8; `aod` §3.6's domination replacing the transfer caveat, plus attribution columns on the ladder table; and the missing query-bound references. Details in `session-log-4.md`.

**Outstanding, and it is the item with the most upside in this file.** Skorobogatov–Sofos (*Inventiones* 231, 2023) prove Schinzel's Hypothesis on average and use it to get a *positive proportion* of varieties with rational points — the move being that one does not need the full conjecture, only that most polynomials satisfying the obvious necessary condition represent at least one prime. **That is structurally `aod` §4**, which needs not an asymptotic at every n but only that for almost every admissible n *some* shape in `aod` §6's finite feasible set is realised. If the averaging works over our shape families, §4's density claim moves from conditional to unconditional, which changes what the paper is. Obstacles to check: the coprimality budget means our family is not a generic family of polynomials, and their result is for linear polynomials in several variables, which fits our two-part shapes better than the fused ones. **Read before `aod` §4 is written, not after.**

**One comparison replaces a reading task.** `literature-findings.md` items 4 and 17 identify Black's spacing framework (ITCS 2015 / ACM ToCT 2019) as containing the sub-board Fourier-degree route, p-group hypothesis included. What is left is not to read it but to ask a specific question: **does our group data give better spacing at composite non-prime-power n than the sequences already in the literature?** His target is Ω(n) asymptotically; ours is constants near C(n,2) at specific n, which his framework does not chase. The two feed the same machinery with different objectives, so the comparison is concrete — compute spacing for the orbit augmentation sequences our batteries supply.

> **Note the optimisation runs opposite to the battery selection.** That route wants many *small* orbitals; the max-m\* search wants the reverse and discards exactly the useful groups. Same inversion as the two-orbital criterion.

**Three primary-source checks owed before publication**, both flagged at the site in `aod` §3.6: the θ = 1/4 rung is attributed to Bombieri–Vinogradov on Shparlinski's framing rather than from the original; the Chowla row names a conjecture-type rather than a specific paper; and **the Ω(n²/3) bound is attributed by at least one survey to unpublished work of Santha–Yao rather than to Scheidweiler–Triesch**, whom we cite alone in `aod` §5 and the `notes` reference list. Citing one of two is a priority claim we have not checked.

**The step we are missing, and it is elementary.** Jones–Zvonkin is a *programme* — at least five papers applying Bateman–Horn to dessins, permutation groups, block designs and simple-group orders, with a stable recipe (`literature-findings.md` item 20). Their step (ii) is an explicit, elementary verification of Bunyakovsky's conditions for each polynomial. **`aod` §3.5 asserts an ample supply without doing the analogue** — checking, per shape family, that the relevant system satisfies Schinzel's conditions and has no fixed prime divisor. That is a page of work per family and it interacts with the polynomial-versus-exponential line below: a shape with unbounded exponent has no polynomial to check, which is itself the finding.

**Deferred: the framing decision.** Jones–Zvonkin's programme (arXiv:2106.00346 and four companions) is the model for how this genre states its standing — conditional on Bateman–Horn, labelled as such in the abstract, with the conjecture validated numerically at the range used. Three consequences are recorded in `literature-findings.md` items 14–16 and are *not* being acted on yet: a standing table at the front of `aod` §3 dividing unconditional from conditional from conjectural; the polynomial-versus-exponential line in `aod` §3.5, since shapes needing prime powers of unbounded exponent are Mersenne-like and outside Bateman–Horn; and the Catalan/Pillai caution where both parts are proper prime powers, which is our S1 and S2 and which `aod` §6 currently treats as amply supplied.

### T5. Close the Lemma C gap at a > 1 — now load-bearing, not optional

*Rescoped. This item previously recommended fencing rather than closing, on the ground that the exposure was zero. That is no longer true: the fallback certificate's condition (4) uses Lemma C's conclusion, so the lemma now sits inside the trusted base for μ(n) = B(n) rather than only inside attainment.*

**What Lemma C says and where it is proved.** A twist of order d in the cyclic layer of a p-characteristic part shares no prime with any outside block of prime size r: gcd(d, r) = 1. Proved when the block has **prime** size — conjugation by a top-layer element induces the identity on the twist there but the twist's own order on the foreign part, which is impossible if they share a prime. **Open at c = p^a with a > 1**, because the top element may act through the Galois part of ΓL(1, p^a) and its induced power map then has q-power order, exactly as the multiplier on the foreign part does, so the two are not incompatible and the argument does not close. This is the same failure mode as the ΓL(1) step of Part B.

> **Do not try to replace the conjugation argument with cyclicity.** "The twist and the foreign translations generate a direct product inside a cyclic group, so their orders are coprime" is **invalid**, and Part D says so in a pitfall box: a single cyclic generator can act as a twist of order d on one part and as a translation of order r on another, in which case ⟨g⟩ is cyclic of order lcm(d, r) and nothing is forced. Any repair of this item must go through conjugation or through domination, not through cyclicity.

**Why the exposure changed.** The A2 tightening gave `fb_common.py`'s condition (4) the cap F·orb(c, dmax) with dmax stripped of the foreign primes — which *is* Lemma C's conclusion. Conditions in that file must be **necessary**, and a condition that is not necessary silently discards a real candidate. So the strip is now scoped to a = 1 in code, where the lemma is proved. **Measured:** the strip changes condition (4)'s verdict on 630,477 branches at n ≤ 2000, of which **53,807 have c a proper prime power** — so this is not a vacuous scoping, even though no candidate list changes emptiness either way (0 gained, 0 removed against the pre-A2 baseline over 501,046 pairs).

**What the closure would buy, and it is now the main prize.** With Lemma C at a > 1, the foreign-prime strip becomes unconditionally necessary, and the SAFE cap can be replaced by the refined one everywhere. That is the structural route to **eliminating SAFE mode as ever necessary for the optimum**: not a per-n certificate that the optimum happens to be fallback-free, but a proof that the refined score is itself an upper bound, collapsing B_refined = B_safe = μ by construction rather than by computation.

**The realistic target is narrower than "eliminate SAFE", and worth stating as such.** `enumeration-proof.md` Part E″ now carries the general form of q-pinning: the foreign gate forces t ≥ δn/2, hence a bounded cofactor u ≤ 2/δ and a top prime q ≥ (δn/2)^{1/e}, hence every *foreign* leftover part is pinned to r_j ≡ 1 (mod q) with at most 2/δ positions at e = 1. Measured, that branch is usually killed outright — median 0 admissible positions, maximum 9. **Conditional on a floor δ ≥ δ₀, the fallback branch therefore reduces to a named finite residue:** the q = 2 and large-e cases, where pinning is vacuous or weak, together with the a > 1 case, where the twist cap is Lemma C. Step 1 is the only place δ enters, so the unconditional version dies with the asymptotic floor — this route is conditional on the same hypothesis the density ceilings are.

**Where each piece now stands, so the remaining work can be costed.**

| piece | status |
|---|---|
| e = 1, δ > 1/9 | **closed unconditionally** — Proposition F.1 at k = 3; three parts each of size ≥ n√δ do not fit |
| e = 1, δ ≤ 1/9 | **reduced to a bounded search**: ≤ 2/δ pinned positions per n. Empty over v4 — 4 admissible of 24,322 positions, all killed by the p-characteristic part not fitting. Not a theorem |
| e ≥ 2 | supply of admissible foreign blocks is density zero in n; enumerable at the sparse n where it exists |
| q = 2 | pinning vacuous, family exponential; needs domination rather than supply |
| p-characteristic half of the leftover | **Lemma C at a > 1** — the prerequisite below |

*Counting alone does not close e = 1 below 1/9, and adding the pinning does not help:* the pinned bound n ≥ 3.54√B gives δ ≤ 0.16, weaker than F.1's 1/9. What closes the computed range is the specific arithmetic of the pinned positions, not a size argument.

**Two routes, and the second may be easier.**

1. **Prove it.** Show a q-element of Γ inducing a Galois automorphism on a p^a-block is incompatible with the chain. This is the hard direction and shares an obstruction with the ΓL(1) step.
2. **Dominate it.** Show that configurations with a > 1 *and* a foreign prime dividing c − 1 are beaten by some other configuration, as the fused-foreign case is by Lemma D2. Evidence that this is the right shape: **0 of the 2,178 p-characteristic parts in a computed winner have both a > 1 and a foreign prime dividing c − 1**, so the configurations in question never win in range. A domination lemma would close the item without touching the Galois question.

**Tripwire, unchanged and still worth keeping.** `validate_table.py` asserts per row that no winner has a proper prime power c with a foreign prime dividing c − 1 — 0 of 1,677 parts, rechecked on every extension. That now guards attainment *and* flags the first n where route 2's domination would have to be checked directly.

### T5a. Re-derive §3.9.1.2's competing-rates argument on every revision

*Flagged because each pass over this argument has produced a different picture, and every version so far has been plausible and at least partly wrong.*

The claim is that the odd-n win shares tend to **1 : 1 : 2**. It rests not on the singular-series computation but on a second step — that the *argmax* over c-classes lands in a class with probability equal to that class's share of the pool — and that step is an extreme-value claim, not a counting one. What decides it is which of several competing effects is largest, and the accounting has been revised twice:

| effect | size | status |
|---|---|---|
| log-factor bias between the D- and 2D-systems | Θ(1/log n) | real; drives the finite-n tilt in the table |
| count noise over the window | O(log^{3/2}n/√n) | real; vanishes far faster |
| Bateman–Horn secondary term | Θ(1/log n) | **same order as the bias**; partially cancels between systems, remainder uncontrolled |
| singular-series ratio fluctuating with n | would be Θ(1) | **identically zero** — the root count is a condition on h = (n−1)/2 alone, D-independent for the pair compared |

**Two things to re-check whenever this section is touched.**

1. **Do not appeal to Maier / Friedlander–Granville irregularity.** Those theorems need moduli growing like x/(log x)^A, or short intervals of length (log x)^A. Our moduli are fixed and small, where Siegel–Walfisz gives error smaller than any power of 1/log n. This is the **high**-uniformity regime, and high uniformity lets the 1/log n bias steer the argmax rather than drowning it — the opposite of what the irregularity literature would suggest if applied out of range.
2. **Recheck the D-independence when the family widens.** 𝔖_D/𝔖_{2D} = 1 is a fact about D = 4 versus D = 8, verified numerically over 8,333 values in each of two bands. It **fails** at ℓ = 3 between D = 6 and D = 12, where the degenerate branch ℓ | D/2 fires. Any comparison involving those D values reopens the whole argument, and the generalised family of `mu-theta-n2-note.md` is exactly where that happens.

**The general hazard worth naming**, since it has now bitten twice in this section: *both* too much and too little uniformity relative to the pseudorandom model produce surprises, and which regime one is in depends on the modulus range. An argument that quotes an irregularity result without checking that its moduli reach ours will reliably reach the wrong conclusion, and will look right while doing so.

## §2b. Claude can pick these off

*Self-contained analysis against the existing files. No new materials needed.*

### A18. RESOLVED (2026-08): Lemma D2 is false at F ≥ 3; the shapes it missed are dominated and never win

*Full resolution, proofs, machine verification and the edit list: **`a18-resolution.md`**, with `a18_verify.py` reproducing every claim (witness orbitals, chain check, range check — all passing). This entry is the summary and the follow-through list; the original item's text is superseded.*

**How each route came out.**

1. **Route 1 (inadmissibility of the 2-transitive permuter) is closed, negatively.** The witness is now a *complete Oliver group*, not just a permuter: n = 85, five fused outside 17-blocks, diagonal translation and full diagonal twist (16 = 2⁴), AGL(1,5) on the block indices. Machine-verified: Γ₁ = C₈₅ cyclic normal, Γ/Γ₁ of order 64, transitive; orbitals exactly 170 / 680 / 2720, so **m\* = 170 = 2|O|** — Lemma D2's m\* ≤ |O|/2 is falsified by a factor of four. The shape exists at every n = 5r and beyond; **the corrected shape space is missing shapes and μ ≤ B_safe as previously argued had a hole**, exactly the q-power failure mode.
2. **Route 2 succeeds with a corrected bound.** The fused-outside domination theorem (`a18-resolution.md` §2): for r ≠ q, **m\* ≤ n·min(F, r)/2 ≤ n^{3/2}/2** — some same-block class ≤ F·C(r,2) always, and some same-position class ≤ C(F,2)·r when F < r. The F < r half runs through **Sylow-r cyclicity** (a chain consequence never load-tested before) plus a coprime-cohomology normalisation making every translation part diagonal; the code comment's instinct in `parts_for` was right and its class size wrong, as the earlier version of this item suspected. D2's conclusion survives at **F = 2** (C(2,2)·r = |O|/2), so worked case E and every F = 2 statement stand.
3. **Route 3 executed.** Over all 2,081 v4 rows, the bound's maximum over (F, r) stays strictly below B(n) — worst ratio 0.8276 at n = 56 — and the theorem takes over from **n ≥ 1582** given the ladder's δ ≥ 0.02516, covering everything to 10⁶ with overlap. Beyond 10⁶ the exclusion needs only δ(n) ≫ n^{−1/2}, the weakest arithmetic input anywhere in the programme.

**Net effect: no computed value of B(n) changes; μ ≤ B_safe is restored by adding the domination theorem to the completeness argument** — the census's S9 moves from "never exists" to "exists, never wins", the first row ever to make that move, and the resolution has the same theorem-above-threshold-plus-check-below-it shape as E′/E″.

**What remains open here — one scoped sub-case: F ≥ 2 fused outside blocks with r = q.** Both halves of D2 lose their footing there (the top q-group can hold non-diagonal translations, so even the diagonal step fails; Sylow-q is not forced cyclic, so the same-position argument fails), while branch (a) still covers F ≥ q. Open is exactly **F < q copies of a q-block**, which at F = 2 could reach ~n²/4 if unbounded. S10's F = 1 normality argument is the thing to extend, and **S10 is thereby promoted to load-bearing for completeness**. Starting fact: at F < q the permuter's image has trivial q-part, hence is p-by-cyclic — which still admits 2-transitivity (AGL(1,5) is 5-by-cyclic), so the sub-case cannot be closed by ruling the permuter out.

**Follow-through (the edit sites, from `a18-resolution.md` §5, for the consistency pass):** D2's status in `enumeration-proof.md` (Part 0 inventory, Part D2, lemma index); Theorem 3.1's "never fused" clause, both DUP copies; the S9 and S10 census rows in both files; `orbital-evasiveness-notes.md` §2.4 and the one-paragraph overview; `parts_for`'s comment in `mu_enumerate_v2.py`. Plus one addition to `validate_table.py`'s group-B ideas if wanted: nothing to check per-row (no witness can contain the shape), but `a18_verify.py`'s pass 3 should be rerun on every table extension, since the range half of the exclusion is a range-scoped claim that expires silently — the exact failure mode `check_doc_figures.py --pass scope` exists for, and this bound should be registered there.

*Lesson, for T1's ledger.* A fourth compact structural step falsified — and the first falsified **by explicit construction inside the framework** rather than by a counterexample found in the literature or by a re-derivation. The step that broke (a small permuter's pair-orbital quoted as if it covered all permuters) is again a case analysis over the wrong partition of cases.

### A19. The k = 3 Galois admissibility predicate was wrong — fix it before any k = 3 code exists

*Corrected in `three-uniform-note.md` §2.2.2; this item is the follow-through, and it is here rather than in that document because the cheapest moment to fix a shape-space predicate is before anything is built on it.*

**What was wrong.** §2.2.2's Oliver-constrained corollary concluded that the Galois gain requires **a = q^e with q ≥ 5**, reasoning that Frobenius acts nontrivially on C_d for d > 1, so C_a cannot join the cyclic layer and must therefore be the top q-group entire. The step from "the generator cannot join the middle layer" to "all of C_a sits on top" is the leap. A subgroup C_{a′} ≤ C_a **acting trivially on C_d** may join it, and then only C_{a/a′} has to be a q-group. The corrected requirement is a layer split: **∃ a′ | a with d | 2^{a/a′} − 1, gcd(d, a′) = 1, and a/a′ a prime power.**

**Its own stated test case is the counterexample.** The corollary asserted that a = 35 is admissible unconstrained but not under Oliver's condition. With d = 31 and c = 2³⁵: 31 | 2⁵ − 1 | 2⁵ − 1 divides 2^{35/7} − 1, so a′ = 7 joins the cyclic layer, C₃₁ × C₇ ≅ C₂₁₇ is cyclic, and Γ/Γ₁ ≅ C₅. A genuine chain, top prime 5, gain factor 5.

**Why it is worth an item.** The error **under-counts** admissible Galois blocks, and §5.8 of that document records that a k = 3 scoring which under-credits the Galois part *is not an upper bound at all* — unlike at k = 2, where the analogous looseness is safe. So this is the one place in the k = 3 design where the usual "conservative direction" intuition inverts. Three things read the predicate and are now known to read a strict subset: §4.2's census note on m, §6.1's escape condition and count, and the ceiling table of §5.7 wherever a Galois block competes.

**What is unaffected**, and worth stating so the correction is not over-read: the gain still needs characteristic 2, gcd(a, 6) = 1 and gcd(d, 6) = 1; q | a still holds, so §4.3's top-prime coupling — every foreign block needing q | r − 1 — stands unchanged; and a ≤ log₂ n still caps the escape at O(n/log n). Only the set of qualifying blocks moves.

**What to do.** Nothing is running on this yet, which is the point of fixing it now. When the k = 3 enumerator of §10 item 1 is built, the block-admissibility test must implement the split rather than a primality test on a — and the split is cheap, being a loop over divisors of a. Until then the item is a tripwire against the old predicate being re-derived from the superseded text, which is a live risk because the wrong version is the one a compressed argument naturally reaches.

*Lesson, for T1's ledger.* This is another compact structural step that read as plausible and was false — the same failure mode as the ΓL(1) step and the q-power block count, and the third time a case analysis has been run over the wrong partition of cases. T1's estimate of roughly one finding per three arguments continues to hold.

### A0b. `validate_table.py` — run this on every table extension

`python3 validate_table.py mu_table_safe_v4.csv --baseline mu_table_safe_v2.csv`

Checks are grouped into three, and the group tells you what a result means:

- **A. Table integrity** — is the file a well-formed enumeration at all? Well-formedness, Lemmas B′ and D2 on each witness, re-derivation of `mu_bound` from the witness by the G.3 formulas, the density column, certification, monotonicity against a baseline, and the **Part E preconditions** (T2) — whether the construction's ingredients exist at each row, which the score re-derivation would not notice. A FAIL here is a bug in the run or the parser, and nothing downstream is meaningful until it clears.
- **B. Exact claims, holding at every n** — Prop F.1, cap_F(η), S2's 1/F, layer-by-top-prime, S6 emptiness, Lemma C exposure, the cyclic layer's pairwise coprimality, the feasibility criterion, Part G.4's per-axis bounds, the within-class cross coefficient, and the three congruence-gated patterns (S4 at c ≡ 1 mod 8; S7-at-F=2 at c ≡ 3 mod 4 bar the tie and p = 2; S5 at no congruence with u ≤ 9). A FAIL here is a real contradiction between table and documents.
- **C. Density and distribution** — floor and the s/k bounds it implies, low-density tail, part-count distribution, census shares, odd-n shares, class-ceiling exceedance, median density by residue mod 24, foreign-block efficiency, and the ω(n) = 2 share. All INFO, each printing the **expected asymptotic value beside the measurement** so the comparison needs no reference to `arithmetic-of-density.md`. A gap here is data about convergence, not a failure.

**Four of the group-B checks have no independent counterpart elsewhere, and are worth knowing by name:** the cyclic layer's global pairwise-coprimality condition (the corrected shape space's own admissibility rule, and the only check that would catch the enumerator *over*-correcting), the feasibility criterion Σ√Fᵢ ≤ 1/√δ that `aod` §6.1's shape counts are derived from, Part G.4's per-axis bounds, and the within-class cross **coefficient** — which is invisible to output, since the term never binds. Each has a negative control: breaking it makes the check FAIL.

Together they cover every belief the three documents currently state. Exits nonzero on any FAIL.

Two extra modes cover the cases that would otherwise send you to the CSV. **`--baseline`** adds shape-migration and aggregate-movement reporting: which winners changed census row and in what direction, and how the floor, the low-density tail and the per-shape counts have moved on the common range. **`--explain N`** prints one row's full term breakdown — every intra, within-class-cross and cross term, which one binds, the twist and its F_mid/F_top split, the foreign block's η and u, and whether the value exceeds its class ceiling.

It **replaces the by-hand checking** of each review pass. **Amend it in the same pass whenever the model changes** — each check names the document section it comes from, so a stale check is findable from either end. Note what it does *not* do: it checks the table against the documents' model, not against mathematics. For independent evidence use `brute_compare.py`.

> **Keep it fast, and treat that as a design constraint rather than a nicety.** The whole suite runs in about **0.1 s on 1,700 rows**, which is what makes it something to run reflexively — before every certificate, after every batch, on any hunch — rather than a job to schedule. A check that costs seconds gets skipped, and a skipped check is worth nothing.
>
> So each check should stay **O(rows) or O(rows × parts)** with arithmetic on numbers already parsed from the witness. What does not belong here: enumerating configurations, VF2 or isomorphism work, re-deriving B(n), sieving past `NMAX`, or anything whose cost grows with n rather than with the row count. Those are `brute_compare.py`'s and the certificates' business, and they have their own items.
>
> The one place this bites is a check that wants to compare a row against alternatives rather than against a formula. If a new check needs that, it belongs in a certificate — and if it must live here, budget it against the 0.1 s and say so at the check, so the next person knows what they are protecting.

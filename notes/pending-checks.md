# Pending checks

*What is left to run or verify, for the arithmetic programme — `orbital-evasiveness-notes.md` §§1–6, `enumeration-proof.md`, `arithmetic-of-density.md`.*

**Companion files.** Completed work and its figures live in the three documents; the review record is in `session-log-2.md` (2026-08 pass) and `session-log.md` (earlier). Findings from the literature review — which bear on framing, not correctness, and have deliberately **not** been folded into the primary documents — are in `literature-findings.md`. Everything pursued at a single small degree — the GAP battery, the SAT/CSP machinery, the backbone probes, the template enumerator — is in `small-degree-verification.md`, which touches §§1–6 only through the n = 10 and n = 12 exhaustive comparisons cited in Part I.

**Status labels.** *Verified* — an independent computation agreed. *Sound* — an argument was read and found correct, with no independent computation. *Unverified* — neither.

---

## The open defect

**G.2 is false and the upper bound does not currently hold.** The block-permuting group of an orbit may sit in the cyclic layer rather than the top q-group, so the block count need not be a q-power. Smallest witness n = 308. Full account in `enumeration-proof.md` Part 0; the density consequences in `arithmetic-of-density.md` §3.3.

**What survives:** `B_refined ≤ μ` unconditionally, and `B_safe = B_refined` wherever the collapse certificate applies — the whole computed table and all but two composite non-prime-power n ≤ 10⁵ — so on that range the tabulated value is ≤ μ. Every construction stands, and §5's global floor holds as an inequality (`δ ≥ 0.026117` over n ≤ 10⁶).

*Do not restate this as `B_safe ≤ μ`.* `B_safe` deliberately over-counts per configuration, scoring a p-characteristic part at F·C(c,2) even where Lemma C reduces the twist. That over-count and the incomplete shape space push in opposite directions, so B_safe and μ are **incomparable** in general.

**What does not survive:** μ(n) = B(n), the table as exact values, and the argmin of the floor — at n = 3239 the corrected space gives 0.043570.

**The repair is done in the enumerator and restores the original inequality.** `mu_enumerate_v2.py` covers the corrected shape space, so `μ ≤ B_safe` holds again for the original reason — F·orb(c, dmax) caps any admissible stabiliser. What remains is to propagate it: rebuild the table (R0), and fix the two scripts still using the old scoring (R7, R3).

## Where the residual risk sits

Ranked, so the sections below have a stated basis. This is not the order the items appear in.

1. **The rebuild.** The enumerator is repaired, `ladder_verify.py` and `brute.py` now carry the same tightening, and the table rebuild is in flight (v4, 210 rows). Everything downstream waits on it. → **R0**

2. **Exhaustiveness of the GAP stages.** The subdirect-product hole is real and undischarged. It degrades *evidence* rather than creating an error — a missed group could only have larger m\*, i.e. it would be a counterexample, not a silent corruption — but it is the only non-circular check in the framework. → `small-degree-verification.md` item 5
3. **Part E's realisability construction.** Attainment's other leg, argued in general and spot-checked at eight configurations from n = 12 to 315. Unlike the certificate, this has no per-n verification at all. → **T2**
4. **The eight necessary conditions of `fb_common.py`.** Both certificates now rest on these and nothing else — the Part E′ theorems were shown to be optimisations in each. They have had one read. Their being *necessary* is what makes an empty candidate list a proof, and two of them have been corrected in the permissive direction historically. → **T3**

Closed in the 2026-08 pass and no longer risks: **Lemma B′** (proved in full, socle step supplied, read in detail by a second reader), **Lemmas D1 and D2** (both proved), `fallback_cert.py` and `wide_cert.py` (both read; both shown to pass with every Part E′ theorem disabled), Lemma C (gap found, shown to affect neither endpoint), `mu_enumerate.py` (read; two independent checks).

---

# §1. Script runs

*Can be launched in the background. Flags are checked against the scripts as they stand; where a run needs code that does not exist, that is said rather than papered over with a plausible-looking flag.*

## R0. Rebuild the table, then rerun everything downstream

The enumerator is repaired and the rebuild is **in flight** (`mu_table_safe_v4.csv`). What is left:

1. **Finish the rebuild.** ~n^2.9 per value.
2. **Rerun everything in R1** against it.
3. **Rebuild the branch-and-bound worklist**, which was pruned against a floor that has moved.

```bash
python3 scripts/mu_enumerate_v2.py --nmax 2600 --out outputs/mu_table_safe_v4.csv
```

**Do not quote figures from v2 or v3.** v3 predates the SAFE over-credit fix and is over-credited on fused shapes; v2 predates the shape-space repair. Against v4 so far (n ≤ 288): 14 values lower than v3, 0 higher, and **0 below v2** — the expected signature.

## R1. Routine, after any new batch of table values

Every one of these is a per-n statement that does not extend itself. Point them all at **v4**.

```bash
python3 mu_enumerate_v2.py --nmax 2600 --fill-gaps --out mu_table_safe_v4.csv
python3 fallback_cert.py mu_table_safe_v4.csv --verbose
python3 wide_cert.py 100000
python3 check_doc_figures.py mu_table_safe_v4.csv *.md
python3 ladder_verify.py 200000
python3 s7_scan.py mu_table_safe_v4.csv --nmax 2600
```

`check_doc_figures.py`: `--quiet` for findings only, `--pass {figures,scope,prose,hygiene,census}` for one pass; exits nonzero when anything is flagged. `mu_enumerate_v2.py`: `--nlist FILE`, `--n`, `--check`, `--quiet`, `--refined`. `--fill-gaps` matters because plain resume continues after the *last* row, so holes a targeted run left are never filled. `wide_cert.py`: `--menu`, `--refresh`.

**Do not extend the table without rerunning R1 in full.** Three consecutive extensions each left a different subset of the documents behind.

## R2. Add a `--no-theorems` flag to `fallback_cert.py` and `wide_cert.py`

Both certificates were shown by hand to pass with every Part E′ theorem switched off — so over the certified range μ(n) = B(n) rests only on the eight necessary conditions, not on E.1, E.3(ii), E.3(iii), E.4, Lemma E.2's bound, or the hardcoded `MERSENNE`/`REPUNIT3` tables. That is a large reduction in the trusted base and it should be re-established on every extension rather than living in a log.

If it ever starts failing while the normal run passes, that localises an error to E.1/E.3(iii)/E.4 or their tables immediately.

```bash
python3 fallback_cert.py mu_table_safe_v4.csv --no-theorems    # NEEDS THE FLAG
python3 wide_cert.py 100000 --no-theorems                      # NEEDS THE FLAG
```

## R3. Extend the naive-enumerator comparison

The only check that tests the restructure rather than re-running it. `brute.py` carries the same SAFE tightening as the enumerator, implemented by repeated trial division rather than a shared factor set so it stays a different program.

**Status: 67 values to n = 105 by contiguous sweep, 0 mismatches**, with all gaps exactly the prime powers (correctly skipped). Every record agrees with v4.

**Targeted values matter more than contiguous coverage here.** Cost grows like n^4.5, so a sweep stalls well below the range where the corrected shape space actually bites — the first S7-at-F≥3 instance is n = 143 and the first S4 winner is n = 247, both far above where a sweep reaches in reasonable time. Use `--nlist`:

```bash
python3 brute_compare.py mu_table_safe_v4.csv --nlist 143,247,285,308 --resume runs/brute.jsonl
python3 brute_compare.py mu_table_safe_v4.csv --nmax 200 --resume runs/brute.jsonl
```

Both new-shape values confirmed independently: **n = 143 → 1081** (the first cyclic-layer-fused winner) and **n = 247 → 2525** (the first S4 winner, c = 73 ≡ 1 mod 8). So the new code paths are verified by a program that knows nothing about them, which the contiguous sweep alone could not do.

n = 308 is not yet in v4 — it needs the rebuild to pass 288 — and is worth rerunning once it is, since it is the original counterexample.

## R4. Count the Lemma C exposure after each extension

Currently **zero**: of the p-characteristic parts appearing in a computed winner, none has both a > 1 and a foreign prime dividing c − 1. Since Lemma C is proved only for prime c, this count is the live measure of whether the gap has started to bite. A dozen lines against the CSV; worth folding into `check_doc_figures.py`. Recount against v4.

## R5. Fix the two `fb_common.py` defects

*(The two `wide_cert.py` defects found alongside these — a pass-1 cache keyed on NMAX alone, so a changed `SCAN_CAP` or `WEAK` silently reused a stale B_lo; and hardcoded absolute paths — are already fixed in the shipped file.)*

Neither affects a result today, but (i) is in the anti-permissive direction and the gate that makes it vacuous could loosen.

- **(i)** In `pair_candidates`, let F range over prime powers in the `q == '*'` branch rather than F = 1 only; likewise `multi_part_ok`'s `pcands` loop. F must be a q-power and q is unconstrained in that branch, so restricting to F = 1 could discard a real candidate. Vacuous over the table because the branch is gated on `r >= B` and the only n with n ≥ B(n) is **n = 6** — but that gate loosens if B ever drops to O(n).
- **(ii)** Add the missing step to `e3ii_resolves`'s docstring: it justifies the (r, r) re-reading's cyclic layer by "gcd(r − 1, c) = 1", which does not follow, since gcd(r − 1, 2r + 1) = gcd(r − 1, 3). It is always 1, because r ≡ 1 (mod 3) would force 3 | 2r + 1 and kill the safe prime. True conclusion, unstated reason.

## R6. Maintain `check_doc_figures.py`'s two whitelists

The script was rewritten in the 2026-08 pass into four passes — figures, scope, prose, hygiene — and now reports 21 findings, all deliberate historical citations. What it needs is upkeep, not development, and both items are two-minute edits that must not be skipped:

- **`CHECKPOINTS`.** Pass 1 recomputes every quantity at each listed checkpoint so a figure can be reported as "correct for n ≤ 2212" rather than merely wrong. **Append the old maximum whenever the table is extended**, or figures written against the superseded range will report as unexplained instead of as historical.
- **`SCOPE`.** Pass 2's patterns are a *whitelist*, so silence means "nothing recognised", not "nothing to find". **Add a pattern whenever a new range assertion is written** — anything of the form "every computed value has δ ≥ x", "no computed value falls below x", "δ > 1/k forces". This pass is what catches the failure mode that produced the two worst defects of the 2026-08 pass, and it is only as good as its list.

Also worth knowing: Pass 3 exempts files matching `session-log|pending-checks|README` from the contradiction check, since describing a superseded state is what a log is for. If a fourth document is added that is genuinely a log, add it to `ARCHIVE`.

## R7. Rerun `ladder_verify.py` to 10⁶

**The SAFE over-credit is fixed.** Its S7-at-F≥3 family scored the fused class at `F·comb(c,2)` regardless of the twist's parity, which credited a twist the configuration cannot have and made the reported value an upper bound on that family rather than a lower one. Now `F·orb(c, dmax)` with dmax the largest divisor of c − 1 coprime to the fusion prime. Verified over n ≤ 20,000: **no value rose, none fell, the worklist is unchanged at 436** — the term was never binding in this window, so no published number moves, but the script is sound now rather than accidentally right.

Two gaps remain, and both lose coverage rather than soundness. **The S7 family is narrower than the enumerator's**, modelling prime-power `F` with one fused class where the enumerator allows any `Fmid` and composite `F` such as 6 = 2·3. And it starts at `F = 3`, so it misses **F = 2 in either layer** — the odd-n fused rung B and S5 — which is the more serious of the two, since the `CAP` table it reports against is keyed on rung-B ceilings it therefore cannot reach. See A6.

The 10⁶ run then wants redoing. `ASYMPTOTIC` = 0.050510 is unchanged, so the 41,584 entries should be roughly stable — but every per-residue `min delta/cap` diagnostic shifts under the mod-24 ceilings, and those are what would reveal a residue behaving anomalously. Current spread at 20,000 is 0.327–0.653.

```bash
python3 ladder_verify.py 1000000
```

# §2. Thinking work

## §2a. Needs human thought

*Judgement calls, independent scrutiny, or things requiring materials Claude cannot obtain.*

### T1. A second reading of the structural arguments

Of this framework's compact structural steps, two were false and shipped (the ΓL(1) step, G.2), one was under-argued and is now fixed (B′), and one is proved only in a special case (C). A step compressed to a clause tends not to survive being written out.

So: **work through the parts that have had no close reading** — Part A's orbit decomposition, Part E's realisability construction, Part F's counting bounds — and expect roughly one finding per three arguments.

*Human, because the value is in the independence.* A second pass by the same reader on the same evidence is worth much less than a first pass by someone else, which is what the B′ reading demonstrated.

### T2. Verify Part E's realisability construction per-n

Attainment's other leg. Argued in general and spot-checked at eight configurations from n = 12 to 315; unlike the collapse certificate it has no per-n verification. The question is whether a per-n check is even the right shape here, or whether the general argument should be strengthened instead — that is a decision about where to spend effort, not a computation. **If** a per-n check is wanted, it is buildable and moves to §1.

### T3. A second read of the eight necessary conditions

Now the whole trusted base for μ(n) = B(n), since both certificates were shown to pass with every Part E′ theorem disabled. The conditions have had exactly one read, which found two defects (both anti-permissive, both vacuous in range) and no soundness error. But the history is that getting them right took two prior corrections, *both in the permissive direction* — and a permissive error is the one that silently removes a real candidate.

The specific question is not "is each condition true" but **"is each condition necessary"** — i.e. does every fallback configuration attaining B(n) really satisfy it. That is a different reading from the one already done, and it is the reading that matters.

*Human, for the same reason as T1: the value is in the independence.*

### T4. Literature checks — four items left; see `literature-findings.md`

The decisive one is settled and unfavourable: BBKN §5.1 defines the max-min our §3 optimises, Shparlinski (2014) names it f(n), and our even/odd constructions are k = 1 and k = 2 in that family. B(n) is nonetheless strictly larger and nobody has studied f(n) at fixed n. What remains:

- **Read Angel–Borja, arXiv:1603.04412**, before writing anything about n = 10. Oliver groups, dimension bounds, applied at ten vertices — same degree, same tool, unknown overlap, not in our reference list.
- **Read Black's spacing definition.** Restricted to p-groups and concluding weak evasiveness, so probably incomparable to m\*, but the definition is in the paper body.
- **Check whether Shparlinski's Theorem 2 survives the prime-power version of α.** *Now the main live number-theoretic question,* since his Corollary 3 already settles what Open Problem 2 of the notes was asking for. His ladder uses the largest *prime* divisor of r − 1; our η uses the largest prime *power* divisor of the odd part. If it transfers, "(H) is the γ = 1 endpoint" is a clean framing.
- **Read Scheidweiler–Triesch and Korneffel–Triesch properly.** The current best unconditional weak bound is n²/3 − o(n²); §5 will read as competing and losing unless it says why the statements differ in kind.

### T5. Decide whether to close the Lemma C gap at all

Now a question about the *sharpness* of the search rather than about the results — dropping Lemma C can only enlarge the configuration space, B_safe does not use it, Part E's construction uses it only as a sufficient condition, and the measured exposure is zero. What it is load-bearing for is `--refined`, the `fallback` bookkeeping, and the reasoning inside E′. So the call is whether the E′ argument is worth repairing at a > 1 or whether it should simply be scoped to prime c. **A priorities decision.**

## §2b. Claude can pick these off

*Self-contained analysis against the existing files. No new materials needed.*

### A1. ~~Bound the s = 4 and s = 5 branches~~ — dissolved in range by the rebuild

*Recounted against `mu_table_safe_v4.csv` at the 1,295-row / n ≤ 1572 frontier.* Since **s ≤ 1/√δ − 1** and the corrected shape space has lifted the density floor over that range to **δ ≥ 0.051813** (n = 1159, `19x61`), the bound gives

> s ≤ 1/√0.051813 − 1 = **3.393**, hence **s ≤ 3 at every n in the current v4 range.**

So the s = 4 and s = 5 branches are **not reachable at all** where the table now reaches, and Part E′ closes every branch by theorem there: E.1 for s = 1, E.3(iii) for the s = 2 repunit family, E.4 for s = 3 outright. **The whole theorem-side residue collapses to the one open case, E.3(ii) with a leftover** — which is A2.

This is not a proof of the branches, and the item should not be closed outright: the floor moves with the range, and the branches reappear the moment some n drops below 1/16. What has changed is that they are no longer *live* — they were an artefact of a floor (0.026117 at n = 3239) computed under the pre-repair shape space. Both former record-holders leave the sub-1/25 set entirely. **Recheck at each extension**; the trigger is the first n with δ ≤ 1/16.

*Related recount, same source.* The low-density tail that Part J item 1 and Open Problem 8(a) are scoped to has also collapsed. Over the common range n ≤ 1572, comparing v2 against v4:

| | v2 | v4 |
|---|---|---|
| δ ≤ 1/9 | 275 | **159** |
| δ ≤ 1/16 | 17 | **3** (n = 527, 1159, 1175) |
| δ ≤ 1/25 | 0 | 0 |
| density floor | 0.041812 (n = 575) | **0.051813** (n = 1159) |

So Corollary F.3's k ≤ 3 is now free at **1292 of 1295 values (99.8%)**, against the 97.7% the documents quote from v2. Open Problem 8(a) is correspondingly narrower, though its *stated* scope ("45 of 1,921 values") is a v2-era figure over a wider range and should be restated only once the rebuild finishes.

### A0. What the extended v4 run confirms (n ≤ 1572, 1,295 rows)

*Checked against the run in progress. No document counts updated — those wait for the run to finish — but the structural verdicts are worth recording now, because every one of them is a hypothesis this session's relabelling rests on, and all of them hold.*

- **v4 ≥ v2 everywhere.** Over the 1,295 common values, **213 rise and 0 fall**. That is the signature R0 predicts for a shape-space enlargement plus a SAFE tightening that was never binding.
- **S4 winners all have c ≡ 1 (mod 8).** Seven instances now — n = 247, 285, 437, 777, 1377, 1417, **1529** (c = 521 ≡ 1). The new one extends the pattern rather than breaking it.
- **S5 winners obey no congruence on c and have small u.** 27 instances, c spread 9/8/7/3 across c ≡ 7, 5, 3, 1 (mod 8), and **u = oddpart(r − 1) ∈ {1, 3} only** (18 and 9). Exactly what §3.3's rung-B′ box predicts: no c-condition, and supply confined to r = 2^a·u + 1 with u small.
- **S7 at F = 2 concentrates at c ≡ 3 (mod 4).** 157 of 172, with 10 at c ≡ 5 (mod 8) — the documented tie case — and 5 at p = 2. The c mod 8 law holds for the cyclic rung and not for the top one, which is the whole content of §3.2.
- **S6 still has zero winners** anywhere in range, confirming A7 at the wider frontier.
- **No winner exceeds cap_F(η) for its own F and η** — 0 violations across every one-matching-class, one-foreign row. This is the upper-bound half of §3.3.8's validation, and it survives the enlarged range.
- **Class ceilings are exceeded freely, as they should be.** At n ≡ 11 and n ≡ 23 (mod 24) **every single winner** (33 of 33, 33 of 33) beats its residue's δ₀. The ceilings are family guarantees, not bounds on δ(n) — but 100% is worth knowing, since it means the tabulated δ₀ describes essentially nothing about the computed range at those two residues.

**One structural change that is not a count.** Three-part winners have largely been absorbed by two-part fused ones: over the common range the part distribution moves from **{1: 551, 2: 615, 3: 129}** to **{1: 513, 2: 775, 3: 7}**. A configuration that was c + c + r\* is now read as the single fused class 2×c + r\*, which is one part rather than two. This is the largest qualitative change the repair has produced, and it bears on several claims written against v2 — in particular Part I's "three-part winners beat two-part configurations by wide margins" (a sample of 23 three-part winners, of which few now survive as three-part) and Part J item 1's framing of minimality. Both should be re-derived rather than merely recounted.

### A0b. `validate_table.py` — run this on every table extension

`python3 validate_table.py mu_table_safe_v4.csv --baseline mu_table_safe_v2.csv`

Checks a table against every belief the three documents currently state: well-formedness and Lemmas B′/D2 on each witness, re-derivation of `mu_bound` from the witness by the G.3 formulas, Prop F.1, cap_F(η), the S4/S5/S7-at-F=2 congruence patterns, S6 emptiness, layer-by-top-prime, monotonicity against a baseline, and seven measured quantities (floor and the s/k bounds it implies, low-density tail, part-count distribution, census counts, class-ceiling exceedances, foreign-block efficiency, Lemma C exposure). Exits nonzero on any FAIL.

It **replaces the by-hand checking** done in each review pass, and it found a documentation error on its first run (see below). **Amend it in the same pass whenever the model changes** — each check names the document section it comes from, so a stale check is findable from either end. Note what it does *not* do: it checks the table against the documents' model, not against mathematics. For independent evidence use `brute_compare.py`.

### A0c. The within-class cross coefficient is keyed on F's parity, not on q — **fixed**

*Found by `validate_table.py` on its first run: 170 of 1,295 rows failed re-derivation.*

Parts E, G.3 and the value formula stated the within-class cross term's coefficient as "**F for odd q, F/2 for q = 2**". That was correct while every block count was forced to be a q-power, since F even then meant q = 2. Under the corrected shape space F = F_mid·F_top need not be a q-power and the two conditions come apart. The smallest witness is **n = 15**, whose winner is `p=5 q=2: 3x5`: **q = 2 but F = 3**, so the coefficient is 3 and the term is 75. Reading it off q gives 25 and understates B(15) as 25 against the true 30.

The correct rule is **F for odd F, F/2 for even F** — the divisibility argument is about the fusing group's own prime ℓ, and ℓ = 2 exactly when F is even. **Both shipped enumerators already key on `F % 2`** (`mu_enumerate_v2.py` line 190, `brute.py` line 119), so no computed value moves and no rerun is needed; this was prose only. Corrected in Part E's value formula, the realisability paragraph, G.3, both copies of the Theorem 3.1 `DUP` block, and `aod` §2.1.

### A2. Promote E.3(ii) past the bare pair

The largest theorem-side residue: **505 branches** where E.3(ii) is pairwise only and the global promotion is open. The obstruction is known and specific: with a leftover, the (r, r) re-reading must also re-type the leftover parts, and the commonest case L = c fails outright because two blocks of the same prime c would be two equal foreign parts, which Part E forbids.

### A3. ~~Make "blocked at one q, available at another" a theorem~~ — reclassified: the congruence half is trivial, the rest is Hardy–Littlewood

*Worked through 2026-08.* The item conflated two questions with very different status, and separating them settles one and relocates the other.

**The congruence half is immediate.** For the diagnostic system of §3.9.2 — c prime, r = n − 2c prime, r ≡ 1 (mod q) — the congruence pins c to the class (n−1)/2 (mod q), and the system is degenerate exactly when that class is 0, i.e. when

> **q | (n − 1)/2.**

So the degenerate q at a given n are precisely the prime divisors of (n−1)/2. There are **ω((n−1)/2) ≤ log₂ n** of them, and typically far fewer: measured over odd n ∈ [10⁴, 4·10⁴] the mean is **2.56** and the maximum **5**. Every other prime is non-degenerate. So "another q is always available" is not an empirical observation at all — it is the statement that a positive integer has finitely many prime divisors, and the obstruction can remove only O(log n) candidates from an unbounded supply. That half needs no theorem.

**The half that remains is not about q at all.** What the ladder actually needs is not *some* non-degenerate q but a q whose system has both **supply** (a solution near the balance point) and **efficiency** (q large enough that η = 2/d is usable, which ties q to a large prime-power divisor of r − 1). Neither follows from non-degeneracy: a system can be locally fine at every prime and still have no solution at a given n, which is exactly the content of Hypothesis (H). So the residual question is the same parametric Hardy–Littlewood question as §3.5's, restricted to a particular q, and not a separate item.

**Conclusion: close A3 as a standalone item.** Record the congruence count in §3.9.2's obstruction box — where the text currently says the availability of another q is "measured" rather than proved, which understates it — and let the supply question sit with (H), where it already is. Nothing here is unproved that was not already unproved.

### A4a. Theorem 2.3's two-part reduction is not elementary — reclassified

*Investigated 2026-08. The statement is true and the reason is now clear, but it is not the kind of statement the proof was reaching for.*

The claim is that the maximising partition never needs three or more parts. The natural attack compares a k-part partition against the two-part split (s₁, n − s₁): the cap(s₁) term is shared and the cross term only improves, so the two-part split is worse **only if cap(n − s₁) falls below the k-part value**. Since cap is not monotone, that cannot be ruled out termwise — which is where the old justification failed and where my attempt stalled.

**The reason it nonetheless holds is additive, not combinatorial.** A three-part partition is capped by min(cap(s₁), s₁s₂) ≤ (n/3)²/2. So it can only win at an n where *no* two-part split reaches that value. Searching odd n in [1500, 4000): **not one** has V(1 or 2 parts) < (n/3)²/2 — the necessary condition is never even met, let alone the conclusion violated. Inspecting the optimal splits shows why: they are (prime power, composite-with-a-large-prime-power-factor) at 428 of 500 sampled n, and (prime power, prime power) at the other 72. Examples: n = 2001 splits as 977 + 1024 with both parts prime powers, value 476776 against the three-part ceiling of 222444.

So two-part splits of the required quality are **plentiful**, and that is a Goldbach-tier fact about the additive structure of n, not something an inequality on cap will produce. Any proof will need an input of the same kind as §3's.

**What this changes.** The reduction should be reclassified from "a gap in a proof" to "a statement of the same conjectural tier as the rest of §3", and stated that way. Nothing depends on it except the O(n) cost claim for B₀; the inequality μ ≤ B₀ quantifies over all partitions and is unaffected. Verified exhaustively to n = 1200 for all partitions, and to n = 4000 for odd n by the necessary-condition test above.

### A5. Sweep for other expired-scope arguments

*Partly done.* A pattern scan across the three documents found the O(log n) sparsity claims (now corrected, §4.3), the mod-12 ceiling framing (now mod-24), and the `B_safe` definition (now F·orb(c, dmax)). What remains unswept: the ~85 "absolute claims" (never / always / no exception) across the three documents, which a numeric sweep cannot check and which are the class §4.3's error lived in. Worth one pass reading each against its current scope.


### A6. Fold the two F = 2 fused rungs apart, and fix `ladder_verify.py` to scan both

*Opened 2026-08 after the S5/rung-B conflation was found; the documents are relabelled, the script is not.*

Fusing the two equal c-blocks of the odd-n family n = 2c + r admits two layer assignments, which are different census shapes and score differently:

- **cyclic layer** (F_mid = 2, q free): twist cut to the odd part of c − 1, so the gain is governed by c mod 8. This is **S7 at F = 2**, and it is what §§3.2, 3.3(b), 3.9 of `arithmetic-of-density.md` derive under the name S5. 150 winners in v4.
- **top layer** (F_top = 2, forcing q = 2): full twist, intra 2·C(c,2) for **every** odd prime power c — this is Theorem 2.1's own construction with a foreign block added — but η pinned to 1/u, u the odd part of r − 1. This is **S5** as the census defines it. 24 winners in v4, all with u ∈ {1, 3}.

The prose is now split; three things remain.

1. **`ladder_verify.py` scans neither rung.** Its three-part branch scores the intra term at `comb(c,2)`, i.e. unfused rung C only, and its S7 loop runs over `Fp ∈ (3, 9, 5, 25, 7)` — **F = 2 is never tried**. So every family value it reports for odd n is a rung-C value, while its `CAP` table is keyed on rung B. The per-residue `δ/cap` diagnostics are therefore measuring against a ceiling the script structurally cannot approach, which is exactly the kind of systematic shortfall those diagnostics exist to detect. Adding F = 2 needs care: the S7 loop's guard `(c - 1) % qF == 0 → continue` kills every odd c at qF = 2, and the cyclic-layer constraint is already carried by `dmax`, so the guard wants rewriting rather than extending. The top-layer rung needs a separate branch with `η = 1/u`.
2. ~~**Recompute §3.9.2's observed split with the rungs separated by top prime.**~~ **Done** — `rung_split.py`, band [2×10⁵, 2.06×10⁵]. S5 never wins outright anywhere in the band, but is in the argmax set at 23.5% of n ≡ 7 and 30.4% of n ≡ 15 (mod 24) and never at 23, so the conflation was inflating the tie column at two residues and nothing else. The window convention turned out to matter more than the layer separation: scanning each residue at its **own** balance point ± 0.05 (`count_check.py`'s convention) rather than at a flat window makes residue 23 match §3.9 exactly at 0 / 43.2 / 56.8, whereas a flat [0.10, 0.42] window produces a spurious 7.6% of fused wins there. **Check the window convention before reading any discrepancy in §§3.8–3.9 as a finding.**

Still open: residues 7 and 15 transpose the fused and tie columns (predicted 50 / 25 / 25, observed 8.7 / 31.1 / 60.2 and 0.0 / 31.6 / 68.4) with S4 already near its predicted share; and §3.9.2's original table (24.0 / 24.8 / 51.2 at residue 7) predates the window convention and should either be re-derived under it or dropped in favour of the rescan.
3. **Recount the census winner columns for S5 and S7.** Done for v4 (S5 24, S7 150 at F = 2); recount on every extension, since the split is by top prime and nothing in the pipeline computes it automatically.

*What is not affected.* No ceiling in the mod-24 table moves: rung B′ has the same cap formula as B but η = 1/u, so it clears the worst class ceiling 0.050510 only for u ≤ 9, i.e. r = 2^a·u + 1 with u one of five small odd values — an O(log n)-per-n family, hence an escape of the same tier as the others. The documented "Fermat escape" is its u = 1 case.

### A7. The n = 1175 two-foreign witness has changed under v4

`enumeration-proof.md` Part I records n = 1175 = 641\* + 277 + 257\* as the unique two-foreign winner in the table, binding on the Fermat prime 257 at 32,896. Under v4 the winner at that n is **`p=139 q=103: 1x619* + 4x139`** with B = 38,364 and δ = 0.05562 — one foreign part, not two, and a cyclic-layer-fused class of four. So the claim that the two-foreign shape (S6) has exactly one instance in range needs recounting: it may now have **none** below 1428, which would change S6's row in both censuses from "1 winner" to "no instance in the current v4 range".

The second instance the branch-and-bound found, n = 3059 = 1511\* + 907\* + 641, is beyond v4's frontier and untested under the corrected shape space. Both should be rechecked when the rebuild passes those values — and note the general point, which is that the shape-space repair can move a winner from one census row to another, so **every per-shape count in Part I is v2-era until recomputed**, not merely the ones marked as such.

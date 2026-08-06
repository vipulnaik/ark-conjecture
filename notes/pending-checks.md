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

**The repair restores the original inequality.** Redefining B_safe as the same over-count over the corrected shape space gives back `μ ≤ B_safe`, for the original reason that F·C(c,2) caps any point stabiliser. The over-count was never the defect.

Everything in §1 and §2 below is subordinate to **R0**.

## Where the residual risk sits

Ranked, so the sections below have a stated basis. This is not the order the items appear in.

1. **The repair itself.** Until R0 lands there is no upper bound on μ(n) at all. The whittling lemmas are in hand — D1 and D2 both proved, D2 more strongly than conjectured (m\* ≤ n/2 outright, no threshold) — so what is missing is the enumerator, not an argument. → **R0**

2. **Exhaustiveness of the GAP stages.** The subdirect-product hole is real and undischarged. It degrades *evidence* rather than creating an error — a missed group could only have larger m\*, i.e. it would be a counterexample, not a silent corruption — but it is the only non-circular check in the framework. → `small-degree-verification.md` item 5
3. **Part E's realisability construction.** Attainment's other leg, argued in general and spot-checked at eight configurations from n = 12 to 315. Unlike the certificate, this has no per-n verification at all. → **T2**
4. **The eight necessary conditions of `fb_common.py`.** Both certificates now rest on these and nothing else — the Part E′ theorems were shown to be optimisations in each. They have had one read. Their being *necessary* is what makes an empty candidate list a proof, and two of them have been corrected in the permissive direction historically. → **T3**

Closed in the 2026-08 pass and no longer risks: **Lemma B′** (proved in full, socle step supplied, read in detail by a second reader), **Lemmas D1 and D2** (both proved), `fallback_cert.py` and `wide_cert.py` (both read; both shown to pass with every Part E′ theorem disabled), Lemma C (gap found, shown to affect neither endpoint), `mu_enumerate.py` (read; two independent checks).

---

# §1. Script runs

*Can be launched in the background. Flags are checked against the scripts as they stand; where a run needs code that does not exist, that is said rather than papered over with a plausible-looking flag.*

## R0. Repair the shape space — everything else waits on this

In dependency order. Steps 1 and 2 are authoring; 3 onward are runs.

1. **Restructure `mu_enumerate.py`** around the cyclic layer's factorisation rather than around parts. The coprimality budget is global — every fusion count, every cyclic-layer twist and every foreign prime competes for one shared generator — so "pick parts, then check" cannot express it. Note the correction both adds configurations and forbids some previously counted, so B is **not** uniformly larger and the table must be recomputed rather than adjusted.
2. **Re-check the lemma inventory against the enlarged shape space** (T1). The repair changes which configurations exist, so B, B′, C, D1 and D2 each want re-reading for whether their hypotheses still cover every case — not because any is in doubt, but because the space they quantify over is moving.
3. **Recompute the table**, then rerun everything in R1.
4. **Rebuild the branch-and-bound worklist.** It was pruned against a floor that has moved.

```bash
python3 s7_scan.py mu_table_safe_v2.csv --nmax 2400 --out s7_weak.txt   # the worklist
```

`s7_scan.py` is new. It reports every n where the missing family beats the table — 57 values to n = 2400, worst ratio 2.387, fusion counts only 3 and 5 — and writes them with their witnesses. Rerun after any table extension to see whether the defect's reach grows; exits nonzero when it finds anything, so it can gate a commit.

## R0a. `ladder_verify.py` now models the S7 family

Already done, and it changes results. The floor to n = 20,000 rises from 0.02504 (at n = 3239) to **0.02516 (at n = 8927)**, and the sub-asymptotic worklist shrinks from 572 entries to **509**. Since the script takes a max over families and every family is an explicit construction, adding one can only raise the floor — so the §5 bound improves rather than weakens.

**Consequence to watch:** `ladder_verify.py` now models a family `mu_enumerate.py` does not, so at some n the ladder reports a *larger* value than the table. That is the defect, not an inconsistency, and the script says so in its output. Rerun to 10⁶ once the enumerator is repaired.

```bash
python3 ladder_verify.py 20000        # 4 families, ~30 s
python3 ladder_verify.py 1000000      # ~70 min; do this after R0 step 3
```

## R1. Routine, after any new batch of table values

Every one of these is a per-n statement that does not extend itself.

```bash
python3 mu_enumerate.py --nmin 2377 --nmax 2600 --out mu_table_safe_v2.csv   # extend (~n^2.9/value)
python3 mu_enumerate.py --nmax 2600 --fill-gaps --out mu_table_safe_v2.csv   # close gaps a targeted run left
python3 fallback_cert.py mu_table_safe_v2.csv --verbose                      # collapse cert vs true B(n)
python3 wide_cert.py 100000                                                  # same, from lower bounds; pass 1 cached
python3 check_doc_figures.py mu_table_safe_v2.csv *.md                       # figures, scope, prose, hygiene
python3 ladder_verify.py 200000                                              # ladder floor, all 12 classes, 4 families
python3 s7_scan.py mu_table_safe_v2.csv --nmax 2600                          # does the defect reach further?
```

`check_doc_figures.py` takes `--quiet` for findings only and `--pass {figures,scope,prose,hygiene}` to run one pass. It exits nonzero when anything is flagged, so it can gate a commit. Not every finding is an error — historical citations are legitimate — but each should be a decision.

`mu_enumerate.py` also takes `--nlist FILE` (one n per line; a second field read as a lower bound on δ, the form `ladder_verify.py` writes), `--n` for a single value, `--check` to validate without extending, `--quiet`, and `--refined` (the lower endpoint B_refined — read Part C.2 first). `--fill-gaps` matters because plain resume continues after the *last* row, so holes a targeted run left would never be filled. `wide_cert.py` takes `--menu` to add the family-menu lower bound as a cross-check and `--refresh` to discard the cached pass 1.

**Do not extend the table without rerunning R1 in full.** Three consecutive extensions each left a *different* subset of the documents behind, because updates were done by ad-hoc string replacement rather than a sweep.

## R2. Add a `--no-theorems` flag to `fallback_cert.py`, then run it alongside R1

**The highest-value cheap run on this page.** It was established by hand that the certificate passes with every Part E′ theorem switched off — `skip_settled=None`, never calling `theorem_report` — giving 0 candidates at all 2,008 values in 3 seconds. That shrinks the trusted base for μ(n) = B(n) enormously: over the certified range the result rests only on the eight necessary conditions being necessary, not on E.1, E.3(ii), E.3(iii), E.4, Lemma E.2's bound, or the hardcoded `MERSENNE`/`REPUNIT3` tables.

But it was a throwaway script. Making it a flag means the guarantee is re-established on every extension instead of being a one-off claim in a log. If it ever starts failing while the normal run passes, that localises an error to E.1/E.3(iii)/E.4 or their tables immediately.

The same now holds for `wide_cert.py` out to 10⁵ — stubbing its `branch_settled` call gives identical output at 10⁴ and 10⁵, including the same two unresolved values. Both deserve the flag, and both should run with it in the routine.

```bash
python3 fallback_cert.py mu_table_safe_v2.csv --no-theorems    # NEEDS THE FLAG
python3 wide_cert.py 100000 --no-theorems                      # NEEDS THE FLAG
```

## R3. Extend the naive-enumerator comparison to n ≤ 260

The strongest available test of `mu_enumerate.py`'s pruning, because it re-derives B(n) from the Part G.3 spec with no pruning, seed or part pool — so it tests the pruning rather than re-running it. Now at **n ≤ 175, 0 mismatches**. `brute.py` (the naive enumerator) and `brute_compare.py` (the driver) accompany these files. `--resume` appends a JSONL and flushes per value, so a long run survives interruption and rerunning skips what is done. Roughly an overnight run to 260.

```bash
python3 brute_compare.py mu_table_safe_v2.csv --nmax 260 --resume runs/brute.jsonl
```

The direction that matters is stated in the output: *naive higher than table* would mean `mu_enumerate.py` prunes away a real configuration, i.e. B(n) too small and the upper bound broken. *Naive lower* would only mean the naive enumerator misses a shape.

## R4. Count the Lemma C exposure after each extension

Currently **zero**: of the 2,178 p-characteristic parts appearing in a computed winner, 1,903 have prime size and none has both a > 1 and a foreign prime dividing c − 1. Since Lemma C's proof only covers prime c, this count is the live measure of whether the gap has started to bite. A dozen lines against the CSV; worth folding into `check_doc_figures.py` rather than keeping as a separate script.

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

## R7. Extend `ladder_verify.py` past 10⁶ *(optional)*

Lowest priority here and explicitly optional. O(N²/log N) — 33 s to 10⁵, 4,062 s to 10⁶ — so 10⁷ is multi-day. The running minimum has not moved since 10⁴ and the lower envelope has risen monotonically since [10³, 10⁴), so the expected return is confirmation rather than a new minimum. The value is in how far the pattern can be pushed.

If it *is* extended, the branch-and-bound must be rerun on the new `ladder_weak.txt`:

```bash
python3 mu_enumerate.py --nlist ladder_weak.txt --floor 0.026117 --adaptive \
                        --out mu_table_safe_v2.csv
```

Start from the current floor 0.026117, not from the asymptotic constant. `--out` is required, not optional: existing rows are never rewritten, the table is read for the δ of any already-computed n (which is what makes the run fast), and newly computed exact values are appended in the normal schema. `--refined` is refused in combination with `--floor`/`--adaptive`. Check the first line reads `mode  UNCONDITIONAL (safe)`. Follow with `--fill-gaps` before quoting the table as a contiguous range.

---

# §2. Thinking work

## §2a. Needs human thought

*Judgement calls, independent scrutiny, or things requiring materials Claude cannot obtain.*

### T1. A second reading of the structural arguments

*Not a single-lemma item any more.* Lemma B′ has now been read in detail by a second reader and is settled: the socle step — which does **not** follow from primitivity alone, since a normal subgroup of a primitive group need only be transitive — is proved via irreducibility of H plus C_G(V) = V, and the degenerate branch π_O(Γ₁) = 1 is handled separately. Both were assertions in earlier drafts.

What that leaves is a general point rather than a specific worry. Of the compact structural steps in this framework, one was false and shipped (the ΓL(1) step), one was false and shipped (G.2), one was under-argued and is now fixed (B′), and one is proved only in a special case (C). The pattern is that a step compressed to a clause tends not to survive being written out. So the item is: **work through the parts that have had no close reading**, in the same way — Part A's orbit decomposition, Part E's realisability construction, and Part F's counting bounds — and expect roughly one finding per three arguments.

*Human, because the value is in independence.* A second pass by the same reader on the same evidence is worth much less than a first pass by someone else, which is exactly what the B′ reading demonstrated.

### T2. Verify Part E's realisability construction per-n

Attainment's other leg. Argued in general and spot-checked at eight configurations from n = 12 to 315; unlike the collapse certificate it has no per-n verification. The question is whether a per-n check is even the right shape here, or whether the general argument should be strengthened instead — that is a decision about where to spend effort, not a computation. **If** a per-n check is wanted, it is buildable and moves to §1.

### T3. A second read of the eight necessary conditions

Now the whole trusted base for μ(n) = B(n), since both certificates were shown to pass with every Part E′ theorem disabled. The conditions have had exactly one read, which found two defects (both anti-permissive, both vacuous in range) and no soundness error. But the history is that getting them right took two prior corrections, *both in the permissive direction* — and a permissive error is the one that silently removes a real candidate.

The specific question is not "is each condition true" but **"is each condition necessary"** — i.e. does every fallback configuration attaining B(n) really satisfy it. That is a different reading from the one already done, and it is the reading that matters.

*Human, for the same reason as T1: the value is in the independence.*

### T4. Literature checks — mostly resolved; see `literature-findings.md`

Worked through in the 2026-08 pass. Findings are in **`literature-findings.md`**; none of the primary documents was edited on the strength of them, deliberately, since they bear on framing rather than correctness.

**The decisive one came back against us and should be absorbed before more writing happens.** BBKN §5.1 does define the max-min our §3 optimises — m\* = Ω(min{p²k, pkr, qr}) over n = pk + r with r ≡ 1 (mod q) — and Shparlinski (2014) has already isolated it as a named function f(n) (his eq. (1), Lemma 5). Our even and odd constructions are k = 1 and k = 2 in that family. B(n) is nonetheless strictly larger than f(n) (prime powers not just primes, prime-power twists not just prime, and the fused-only configurations that are 39% of the table and which W_n cannot express), and neither paper claims a maximum over *all* Oliver groups or studies f(n) at fixed n at all. But §3 is a parameter choice inside a published family and should not be presented as a new construction.

Four items remain, listed at the end of `literature-findings.md`:

- **Read Black's spacing definition.** The only item that could not be settled from abstracts. Spacing is restricted to p-groups and concludes weak evasiveness, so it looks incomparable to m\* rather than subsuming it — but the definition is in the paper body.
- **Check whether Shparlinski's Theorem 2 survives the prime-power version of α.** His ladder is parameterised by the largest *prime* divisor of r − 1; our η uses the largest prime *power* divisor of the odd part, plus the 2-part. If the ladder transfers, "(H) is the γ = 1 endpoint" is a clean framing; if not, we need another.
- **Read Scheidweiler–Triesch and Korneffel–Triesch properly.** The current best unconditional weak bound is n²/3 − o(n²), which is a factor of 25 above our density floor. Not a defect in the result — a weak bound on all properties and an exact result on a restricted class are different in kind — but §5 does not currently say so, and will read as competing and losing.
- **Decide the framing.** No longer a literature question. It determines whether §3 is a contribution or a recap, and it should be settled before more writing.
- **Read Angel–Borja, arXiv:1603.04412**, before writing anything about n = 10. Surfaced incidentally: they use Oliver groups to bound the dimension of a non-evasive complex on 2p vertices and apply it at ten vertices. Same degree, same tool, same target as `small-degree-verification.md`; overlap unknown, and they are not in our reference list.

*Also settled:* the Θ(n²) / Hardy–Littlewood reframing was searched for in Lovász–Young (ruled out on dates — 1990 lectures), Kulkarni's ITCS 2013 circuit-lens paper, Shparlinski's §5 comments, BBKN §2.4, and the Csernák survey, plus direct topic searches. **No trace.** There is a structural reason: every tool in that literature is an existence-of-one-prime tool and so cannot produce a Θ statement. Negative searches cannot rule out talks or referee reports, so the note should present the heuristic as the natural reading of the data rather than as a new observation.

### T5. Decide whether to close the Lemma C gap at all

Now a question about the *sharpness* of the search rather than about the results — dropping Lemma C can only enlarge the configuration space, B_safe does not use it, Part E's construction uses it only as a sufficient condition, and the measured exposure is zero. What it is load-bearing for is `--refined`, the `fallback` bookkeeping, and the reasoning inside E′. So the call is whether the E′ argument is worth repairing at a > 1 or whether it should simply be scoped to prime c. **A priorities decision.**

## §2b. Claude can pick these off

*Self-contained analysis against the existing files. No new materials needed.*

### A1. Bound the s = 4 and s = 5 branches

Opened by the density floor falling to 0.026117, which puts four computed values below 1/25 (n = 2291, 2303, 3059, 3239) and one below 1/36. Neither branch is thin enough for an E.4-style collapse — c − 1 = 4r and c − 1 = 5r carry no parity or congruence forcing — so an absolute cap would have to come from the foreign block's twist, as in E.1 and E.3(iii). The search clears both at every computed n, so nothing is unproved; the gap is theorem-side and widens as the floor falls. Currently 4 branches at s = 4 and 1 at s = 5 over the certified range.

### A2. Promote E.3(ii) past the bare pair

The largest theorem-side residue: **505 branches** over the certified range where E.3(ii) is pairwise only and the global promotion is open. With the above-1/9 route refuted (a majority of odd n have δ < 1/9 outright), this is the only path left to Part J item 2. The obstruction is known and specific: with a leftover the (r, r) re-reading must also re-type the leftover parts, and the commonest case L = c fails outright because two blocks of the same prime c would be two equal foreign parts, which Part E forbids.

### A3. Erdős covering congruences vs the 2-power escape claim

Not attempted in the literature pass — it is a mathematical check, not a framing question, which is why it sits here rather than in T4. Reportedly give a *positive density* of odd n with no 2^k + p representation — stronger than the O(log n)-sparse claim about 2-power escapes in §3.3, and would close that route rather than thin it. Checkable from the literature plus a direct computation over the table. Sits here rather than in T4 because it is a mathematical check, not a framing question.

### A4. Reconstruct or retire the filtered per-class table in §3.3

Its row counts sum to 887 and the filter that produced them was not reconstructed. The unfiltered version now in the document supersedes it in content, but the document carries both, which is worse than carrying either. Either reproduce the filter or delete the table. **Partly unverified.**

### A4a. Prove Theorem 2.3's two-part reduction

The only gap left in the whittling. That the maximising partition never needs three or more parts is verified exhaustively to n = 1200 but not proved; the old justification is false because cap is not monotone (cap(127) = 8001 against cap(129) = 2709). My attempt reaches "the merged partition is worse only if cap(n − s₁) < s₁s₂" and stalls there. Nothing depends on it except the O(n) cost claim for B₀ — the inequality μ ≤ B₀ quantifies over all partitions — so this is low priority but self-contained.

### A5. Sweep for other expired-scope arguments

The two worst defects of the 2026-08 pass were arguments whose scope silently expired — one because the density floor moved, one because a class table was never re-derived from the formula that superseded it. A systematic backward pass — every claim of the form "for all computed n, X", every derivation that fixes a parameter the data has since moved — would say whether there are more. Distinct from R6, which automates detection going forward.

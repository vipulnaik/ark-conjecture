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

**Targeted values matter more than contiguous coverage here.** Cost grows like n^4.5, so a sweep stalls well below the range where the corrected shape space actually bites — the first S7 instance is n = 143 and the first S4 winner is n = 247, both far above where a sweep reaches in reasonable time. Use `--nlist`:

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

**The SAFE over-credit is fixed.** Its S7 family scored the fused class at `F·comb(c,2)` regardless of the twist's parity, which credited a twist the configuration cannot have and made the reported value an upper bound on that family rather than a lower one. Now `F·orb(c, dmax)` with dmax the largest divisor of c − 1 coprime to the fusion prime. Verified over n ≤ 20,000: **no value rose, none fell, the worklist is unchanged at 436** — the term was never binding in this window, so no published number moves, but the script is sound now rather than accidentally right.

One gap remains, and it only loses coverage rather than soundness: **the S7 family is narrower than the enumerator's**, modelling prime-power `F` with one fused class where the enumerator allows any `Fmid` and composite `F` such as 6 = 2·3. Widening it would shorten the worklist.

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
- **Check whether Shparlinski's Theorem 2 survives the prime-power version of α.** His ladder uses the largest *prime* divisor of r − 1; our η uses the largest prime *power* divisor of the odd part. If it transfers, "(H) is the γ = 1 endpoint" is a clean framing.
- **Read Scheidweiler–Triesch and Korneffel–Triesch properly.** The current best unconditional weak bound is n²/3 − o(n²); §5 will read as competing and losing unless it says why the statements differ in kind.

### T5. Decide whether to close the Lemma C gap at all

Now a question about the *sharpness* of the search rather than about the results — dropping Lemma C can only enlarge the configuration space, B_safe does not use it, Part E's construction uses it only as a sufficient condition, and the measured exposure is zero. What it is load-bearing for is `--refined`, the `fallback` bookkeeping, and the reasoning inside E′. So the call is whether the E′ argument is worth repairing at a > 1 or whether it should simply be scoped to prime c. **A priorities decision.**

## §2b. Claude can pick these off

*Self-contained analysis against the existing files. No new materials needed.*

### A1. Bound the s = 4 and s = 5 branches

The only remaining gap in a *proof* rather than in evidence. E.1 caps s = 1 by the Mersenne constants and E.3(iii) caps the s = 2 repunit branch; s = 4 and s = 5 have neither, and neither is thin enough for an E.4-style collapse — c − 1 = 4r and c − 1 = 5r carry no parity or congruence forcing. An absolute cap would have to come from the foreign block's twist, as in those two. The search clears both at every computed n, so nothing is unproved.

*Recount after the rebuild.* At n = 3239 and 3059 the density rises sharply under the corrected shape space, so both leave the sub-1/25 set and the branch may narrow without any new theorem.

### A2. Promote E.3(ii) past the bare pair

The largest theorem-side residue: **505 branches** where E.3(ii) is pairwise only and the global promotion is open. The obstruction is known and specific: with a leftover, the (r, r) re-reading must also re-type the leftover parts, and the commonest case L = c fails outright because two blocks of the same prime c would be two equal foreign parts, which Part E forbids.

### A3. Make "blocked at one q, available at another" a theorem

The twist-prime obstruction is written into §3.7: the congruence r ≡ 1 (mod q) pins c to the class (n−1)/2 (mod q), and when that class is 0 the family is empty, which fires for one n in q. What is open is whether the observation that another q is always available can be proved rather than measured.

### A4a. Theorem 2.3's two-part reduction is not elementary — reclassified

*Investigated 2026-08. The statement is true and the reason is now clear, but it is not the kind of statement the proof was reaching for.*

The claim is that the maximising partition never needs three or more parts. The natural attack compares a k-part partition against the two-part split (s₁, n − s₁): the cap(s₁) term is shared and the cross term only improves, so the two-part split is worse **only if cap(n − s₁) falls below the k-part value**. Since cap is not monotone, that cannot be ruled out termwise — which is where the old justification failed and where my attempt stalled.

**The reason it nonetheless holds is additive, not combinatorial.** A three-part partition is capped by min(cap(s₁), s₁s₂) ≤ (n/3)²/2. So it can only win at an n where *no* two-part split reaches that value. Searching odd n in [1500, 4000): **not one** has V(1 or 2 parts) < (n/3)²/2 — the necessary condition is never even met, let alone the conclusion violated. Inspecting the optimal splits shows why: they are (prime power, composite-with-a-large-prime-power-factor) at 428 of 500 sampled n, and (prime power, prime power) at the other 72. Examples: n = 2001 splits as 977 + 1024 with both parts prime powers, value 476776 against the three-part ceiling of 222444.

So two-part splits of the required quality are **plentiful**, and that is a Goldbach-tier fact about the additive structure of n, not something an inequality on cap will produce. Any proof will need an input of the same kind as §3's.

**What this changes.** The reduction should be reclassified from "a gap in a proof" to "a statement of the same conjectural tier as the rest of §3", and stated that way. Nothing depends on it except the O(n) cost claim for B₀; the inequality μ ≤ B₀ quantifies over all partitions and is unaffected. Verified exhaustively to n = 1200 for all partitions, and to n = 4000 for odd n by the necessary-condition test above.

### A5. Sweep for other expired-scope arguments

*Partly done.* A pattern scan across the three documents found the O(log n) sparsity claims (now corrected, §4.1), the mod-12 ceiling framing (now mod-24), and the `B_safe` definition (now F·orb(c, dmax)). What remains unswept: the ~85 "absolute claims" (never / always / no exception) across the three documents, which a numeric sweep cannot check and which are the class §4.1's error lived in. Worth one pass reading each against its current scope.


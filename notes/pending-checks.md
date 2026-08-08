# Pending checks

*What is left to run or verify, for the arithmetic programme — `orbital-evasiveness-notes.md` §§1–6, `enumeration-proof.md`, `arithmetic-of-density.md`.*

**Companion files.** Completed work and its figures live in the three documents; the review record is in `session-log-2.md` (2026-08 pass) and `session-log.md` (earlier). Findings from the literature review — which bear on framing, not correctness, and have deliberately **not** been folded into the primary documents — are in `literature-findings.md`. Everything pursued at a single small degree — the GAP battery, the SAT/CSP machinery, the backbone probes, the template enumerator — is in `small-degree-verification.md`, which touches §§1–6 only through the n = 10 and n = 12 exhaustive comparisons cited in Part I.

**Status labels.** *Verified* — an independent computation agreed. *Sound* — an argument was read and found correct, with no independent computation. *Unverified* — neither.

---

## Status

**The G.2 defect is repaired and propagated in the enumerator.** The block-permuting group of an orbit may sit in the cyclic layer rather than the top q-group, so the block count need not be a q-power; smallest witness n = 308. `mu_enumerate_v2.py` covers the corrected shape space, so **μ(n) ≤ B_safe(n) holds again** for the original reason — F·orb(c, dmax) caps any admissible stabiliser. Full account in `enumeration-proof.md` Part 0.

**What is left is propagation, not repair.** The table rebuild (R0) is in flight and everything measured waits on it. Two scripts still carry the old model: `ladder_verify.py` (A6) and, for its narrower S7 family, R7.

*Do not restate the inequality as `B_safe ≤ μ`.* `B_safe` deliberately over-counts per configuration, so B_safe and μ are incomparable in general; what holds is B_refined ≤ μ ≤ B_safe, with the endpoints collapsing wherever the certificate applies.

## Where the residual risk sits

Ranked, so the sections below have a stated basis. This is not the order the items appear in.

1. **The rebuild.** The enumerator is repaired, `ladder_verify.py` and `brute.py` now carry the same tightening, and the table rebuild is in flight (v4, 1,295 rows to n = 1572). Everything measured waits on it. → **R0**

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

## R4. ~~Count the Lemma C exposure after each extension~~ — automated

Now a check in `validate_table.py` (group B), which reports it on every run. Currently **0 of 1,302** p-characteristic winner parts have both a > 1 and a foreign prime dividing c − 1, so the gap Lemma C leaves at a > 1 is still vacuous on every winner. Nothing to do by hand.

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

### T4. Literature checks — three read, one left, and two things to decide

*Three of the four are now read and written up in `literature-findings.md` §§5–8. What is left for you is judgement, not reading.*

**Still needs the paper: Shparlinski's Theorem 2 at prime powers.** His ladder uses the largest *prime* divisor of r − 1; our η uses the largest prime *power* divisor of the odd part plus the 2-part. They agree at r − 1 = 2q and differ otherwise. If the argument transfers, "(H) is the θ = 1 endpoint" is exact; if not, §3.6's caveat stays. A judgement about a proof's robustness, so it wants a human read.

**Decisions arising, in descending order of value:**

1. **Run our n = 10 CSP against Angel–Borja's five surviving types.** They reduce potential counterexamples at ten vertices to order ideals I₂, I₄, I₅, I₆, I₈ of a 10-element poset, having killed I₁, I₃, I₇, I₉ — and say explicitly they could not find Oliver groups for the rest. Each type is a stated set of isomorphism classes, so it is a constraint our solver accepts directly. Reproducing their four eliminations is **non-circular validation of the CSP**, which the framework is short of; killing more is an increment on a 2016 paper. This is the most concrete thing the literature review has produced.
2. **Decide whether to take their χ = 1 exploitation.** At a trivial-top Oliver group χ(P^Γ) = 1 exactly, so the fixed complex cannot be a single point and P must contain a **union of two orbitals** — which gives them dim P ≥ 4p − 1. We stop at non-voidness (§7.2's bottom box). Their step needs only two vertices in the fixed complex, which our orbital counts supply at every non-prime-power n, so it looks cheap. §7.3 lists three places left to look for strength; this may be a fourth.
3. **Add a sentence to §5 distinguishing δ from c(n).** Scheidweiler–Triesch's n²/3 − o(n²) is a bound on *how many queries* every nontrivial monotone property forces; our δ ≈ 0.05 is a threshold on *which properties* the method reaches exactly. Same technique — the Triesch line is explicitly topological — different quantity. Without that sentence §5 reads as competing and losing against a larger number.
4. **Cite Angel–Borja**, and note that the vertex-homogeneous dimension bound they attribute to Lutz is a *different* Lutz paper (JCTB 81, 2001) from the one we reference.

**Two things the reading closed.** Black's spacing is confirmed incomparable — p-groups only, bounds D(f) directly rather than a single group's minimum orbital, and concludes Ω(n) rather than exact evasiveness; its one useful role is as the standing demonstration that the number theory is not needed for Ω(n), which sharpens what ours buys. And Angel–Borja does **not** overlap: they use Oliver groups to force *named members* and feed those into a mod-p isomorphism-class count, where we extract a *size*. Their Proposition 4.5 is our Theorem 2.1 with the diagonal twist deleted (m\* = 2p against our p(p−1)) — so we are stronger on size, and they get a qualitative membership statement that fusing the orbitals destroys. That trade-off is worth a line in §9.7.

### T5. Decide whether to close the Lemma C gap at all

Now a question about the *sharpness* of the search rather than about the results — dropping Lemma C can only enlarge the configuration space, B_safe does not use it, Part E's construction uses it only as a sufficient condition, and the measured exposure is zero. What it is load-bearing for is `--refined`, the `fallback` bookkeeping, and the reasoning inside E′. So the call is whether the E′ argument is worth repairing at a > 1 or whether it should simply be scoped to prime c. **A priorities decision.**

## §2b. Claude can pick these off

*Self-contained analysis against the existing files. No new materials needed.*

**Closed this pass** — detail in `session-log-3.md`, nothing left to do:

- **A0. What the extended v4 run confirms.** Every structural hypothesis holds at n ≤ 1572; v4 ≥ v2 at all 1,295 common values. Now re-run automatically by `validate_table.py`.
- **A0c. The within-class cross coefficient.** Stated as "F for odd q, F/2 for q = 2"; the rule is keyed on **F's parity**, not q's. Smallest witness n = 15 (`p=5 q=2: 3x5`, q = 2 but F = 3). Both enumerators were already right; prose corrected in five places.
- **A1. The s = 4 and s = 5 branches.** Dissolved in range: the floor rose to 0.051813, so s ≤ 1/√δ − 1 = 3.393 and only s ≤ 3 is reachable, where E.1/E.3(iii)/E.4 close everything. **Recheck at each extension** — the trigger is the first n with δ ≤ 1/16.
- **A3. "Blocked at one q, available at another".** The congruence half is trivial (the degenerate q are the prime divisors of (n−1)/2, at most log₂n of them); the rest is Hypothesis (H) restricted to one q, not a separate item.
- **A4a. Theorem 2.3's two-part reduction.** Reclassified as a Goldbach-tier statement rather than a gap in a proof; nothing depends on it but the O(n) cost claim for B₀.
- **A5. The expired-scope sweep.** 41 range-scoped absolute claims read against v4; two expiries found and fixed — the weak values are no longer all n ≡ 11 (mod 12) (the minimum is now n = 1159 = 19·61, a *multiplicative* value), and Part I's low-density tail figures are structurally wrong rather than merely stale. Closed as an item, but budget **one reading pass per major extension**: `validate_table.py` and `check_doc_figures.py --pass scope` catch mechanical and whitelisted claims, neither catches a claim about a *mechanism*, and that is the kind that expired here.
- **A7. The n = 1175 two-foreign witness.** Moved under v4; S6 now has **zero** winners in range, confirmed to n = 1572. Now checked automatically.

### A0b. `validate_table.py` — run this on every table extension

`python3 validate_table.py mu_table_safe_v4.csv --baseline mu_table_safe_v2.csv`

Checks are grouped into three, and the group tells you what a result means:

- **A. Table integrity** — is the file a well-formed enumeration at all? Well-formedness, Lemmas B′ and D2 on each witness, re-derivation of `mu_bound` from the witness by the G.3 formulas, the density column, certification, and monotonicity against a baseline. A FAIL here is a bug in the run or the parser, and nothing downstream is meaningful until it clears.
- **B. Exact claims, holding at every n** — Prop F.1, cap_F(η), S2's 1/F, layer-by-top-prime, S6 emptiness, Lemma C exposure, and the three congruence-gated patterns (S4 at c ≡ 1 mod 8; S7-at-F=2 at c ≡ 3 mod 4 bar the tie and p = 2; S5 at no congruence with u ≤ 9). A FAIL here is a real contradiction between table and documents.
- **C. Density and distribution** — floor and the s/k bounds it implies, low-density tail, part-count distribution, census shares, odd-n shares, class-ceiling exceedance, median density by residue mod 24, foreign-block efficiency, and the ω(n) = 2 share. All INFO, each printing the **expected asymptotic value beside the measurement** so the comparison needs no reference to `arithmetic-of-density.md`. A gap here is data about convergence, not a failure.

Together they cover every belief the three documents currently state: well-formedness and Lemmas B′/D2 on each witness, re-derivation of `mu_bound` from the witness by the G.3 formulas, Prop F.1, cap_F(η), the S4/S5/S7-at-F=2 congruence patterns, S6 emptiness, layer-by-top-prime, monotonicity against a baseline, and seven measured quantities (floor and the s/k bounds it implies, low-density tail, part-count distribution, census counts, class-ceiling exceedances, foreign-block efficiency, Lemma C exposure). Exits nonzero on any FAIL.

Two extra modes cover the cases that would otherwise send you to the CSV. **`--baseline`** adds shape-migration and aggregate-movement reporting: which winners changed census row and in what direction, and how the floor, the low-density tail and the per-shape counts have moved on the common range. **`--explain N`** prints one row's full term breakdown — every intra, within-class-cross and cross term, which one binds, the twist and its F_mid/F_top split, the foreign block's η and u, and whether the value exceeds its class ceiling.

It **replaces the by-hand checking** done in each review pass, and it found a documentation error on its first run (see below). **Amend it in the same pass whenever the model changes** — each check names the document section it comes from, so a stale check is findable from either end. Note what it does *not* do: it checks the table against the documents' model, not against mathematics. For independent evidence use `brute_compare.py`.

### A2. Promote E.3(ii) past the bare pair

The largest theorem-side residue: **505 branches** where E.3(ii) is pairwise only and the global promotion is open. The obstruction is known and specific: with a leftover, the (r, r) re-reading must also re-type the leftover parts, and the commonest case L = c fails outright because two blocks of the same prime c would be two equal foreign parts, which Part E forbids.

### A6. Fix `ladder_verify.py` to scan both F = 2 rungs

*The documents are relabelled; the script is not.* Its three-part branch scores the intra term at `comb(c,2)` — unfused rung C only — and its S7 loop runs over `Fp ∈ (3, 9, 5, 25, 7)`, so **F = 2 is never tried in either layer**, while its `CAP` table is keyed on the rung-B ceilings. Every family value it reports for odd n is therefore a rung-C value measured against a ceiling it structurally cannot reach, which is exactly the systematic shortfall those `δ/cap` diagnostics exist to detect.

Adding F = 2 needs care rather than an extra tuple entry: the S7 loop's guard `(c - 1) % qF == 0 → continue` kills every odd c at qF = 2, and the cyclic-layer constraint is already carried by `dmax`, so the guard wants rewriting. The top-layer rung needs a separate branch with η = 1/u.

*Nothing published moves.* The script computes a lower bound, so adding a family can only raise it: `δ ≥ 0.02516` over n ≤ 10⁶ stands and would if anything improve. What changes is the per-residue diagnostics.

**Still open alongside it:** residues 7 and 15 transpose the fused and tie columns (predicted 50 / 25 / 25, observed 8.7 / 31.1 / 60.2 and 0.0 / 31.6 / 68.4), and §3.9.2's original table (24.0 / 24.8 / 51.2 at residue 7) predates the per-residue window convention and should be re-derived under it or dropped in favour of the rescan.

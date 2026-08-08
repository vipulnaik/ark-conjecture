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
python3 validate_table.py mu_table_safe_v4.csv --baseline mu_table_safe_v2.csv
python3 check_doc_figures.py mu_table_safe_v4.csv *.md
python3 ladder_verify.py 200000
python3 s7_scan.py mu_table_safe_v4.csv --nmax 2600
```

**Run `validate_table.py` first** — it is the cheapest and it gates the rest: a FAIL in its group A means the run itself is broken and nothing downstream is meaningful. `--explain N` gives one row's term breakdown, `--quiet` shows failures only. `check_doc_figures.py`: `--quiet` for findings only, `--pass {figures,scope,prose,hygiene,census}` for one pass; exits nonzero when anything is flagged. `mu_enumerate_v2.py`: `--nlist FILE`, `--n`, `--check`, `--quiet`, `--refined`. `--fill-gaps` matters because plain resume continues after the *last* row, so holes a targeted run left are never filled. `wide_cert.py`: `--menu`, `--refresh`.

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

The script is now correct on both counts that were open: the SAFE over-credit on the S7-at-F≥3 family is fixed (`F·orb(c, dmax)` rather than `F·comb(c,2)`), and A6 added the two F = 2 fused rungs. At N = 20,000 the worklist is **213**, down from 436, and the per-residue diagnostics moved only at the fused-rung residues.

So the 10⁶ run wants redoing, and this time the diagnostics are worth reading rather than discounting — the repair's own validation was that only fused-rung residues moved and no even one did, so a residue behaving unlike its class is now a signal. The first such signal, n ≡ 11 (mod 24), was chased and came back explained (§3.7): the fused rungs lift only the intra term, and every rung-B class minimum is foreign-bound, so **a residue not moving is informative about which term binds, not about the model being wrong.** Read the 10⁶ diagnostics that way. `ASYMPTOTIC` = 0.050510 is unchanged; the previous run's 41,584 worklist entries should roughly halve. Current spread at 20,000 is 0.327–0.653.

*One coverage gap remains, and it only loses values rather than soundness:* the S7-at-F≥3 family still models prime-power `F` with one fused class, where the enumerator allows any `Fmid` and composite `F` such as 6 = 2·3.

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
2. ~~**Decide whether to take their χ = 1 exploitation.**~~ **Written up** as the *two-orbital criterion* in §9.7, in a slightly more general form than theirs: if v orbitals of Γ lie in P and no pairwise union does, then χ(Δ_P^Γ) = v exactly, so the congruence forces **v ≡ 1 (mod q)** or a two-orbital union in P — the trivial-top case (χ = 1) being theirs. At q = 2 with two orbitals in P it bites immediately, and it strengthens §9.7's two-graph criterion at n = 2m to "P contains exactly one of 2K_m and K_{m,m}".

   *What is left is whether to chase it computationally, and my read is that it is low-yield at the groups we favour.* It needs **many** orbitals to constrain a nontrivial P — with few, large orbitals the forced union is K_n and the conclusion degenerates to triviality. Our max-m\* search discards exactly the many-orbital groups. The n = 10 and n = 12 batteries do enumerate them, so if it is worth an experiment it is there, as a filter over the 967 and 7,115 group lists asking which have small orbital count *in P* under a candidate assignment. Same asymmetry as the fixed-point one below.
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
- **A6. `ladder_verify.py` scans both F = 2 rungs.** Rungs B (cyclic, odd-q efficiency) and B′ (top, q = 2, η = 1/u) added to the three-part branch; worklist halves 436 → 213 at N = 20,000; the per-residue diagnostics move **only** at fused-rung residues and not at any even one. Two follow-ups below.
- **A7. The n = 1175 two-foreign witness.** Moved under v4; S6 now has **zero** winners in range, confirmed to n = 1572. Now checked automatically.
- **A8. The two `ladder_verify.py` follow-ups.** The n ≡ 11 (mod 24) diagnostic is not anomalous — the fused rungs lift only the intra term, and every rung-B class minimum is foreign-bound, so residue 11 is the one the model predicts should not move. And §3.9.2's pre-convention table is gone, leaving one measurement under one window convention. What survives is the substantive gap at residues 7 and 15, now stated as such in §3.9.2 rather than as a pending item.

### A0b. `validate_table.py` — run this on every table extension

`python3 validate_table.py mu_table_safe_v4.csv --baseline mu_table_safe_v2.csv`

Checks are grouped into three, and the group tells you what a result means:

- **A. Table integrity** — is the file a well-formed enumeration at all? Well-formedness, Lemmas B′ and D2 on each witness, re-derivation of `mu_bound` from the witness by the G.3 formulas, the density column, certification, and monotonicity against a baseline. A FAIL here is a bug in the run or the parser, and nothing downstream is meaningful until it clears.
- **B. Exact claims, holding at every n** — Prop F.1, cap_F(η), S2's 1/F, layer-by-top-prime, S6 emptiness, Lemma C exposure, and the three congruence-gated patterns (S4 at c ≡ 1 mod 8; S7-at-F=2 at c ≡ 3 mod 4 bar the tie and p = 2; S5 at no congruence with u ≤ 9). A FAIL here is a real contradiction between table and documents.
- **C. Density and distribution** — floor and the s/k bounds it implies, low-density tail, part-count distribution, census shares, odd-n shares, class-ceiling exceedance, median density by residue mod 24, foreign-block efficiency, and the ω(n) = 2 share. All INFO, each printing the **expected asymptotic value beside the measurement** so the comparison needs no reference to `arithmetic-of-density.md`. A gap here is data about convergence, not a failure.

Together they cover every belief the three documents currently state: well-formedness and Lemmas B′/D2 on each witness, re-derivation of `mu_bound` from the witness by the G.3 formulas, Prop F.1, cap_F(η), the S4/S5/S7-at-F=2 congruence patterns, S6 emptiness, layer-by-top-prime, monotonicity against a baseline, and seven measured quantities (floor and the s/k bounds it implies, low-density tail, part-count distribution, census counts, class-ceiling exceedances, foreign-block efficiency, Lemma C exposure). Exits nonzero on any FAIL.

Two extra modes cover the cases that would otherwise send you to the CSV. **`--baseline`** adds shape-migration and aggregate-movement reporting: which winners changed census row and in what direction, and how the floor, the low-density tail and the per-shape counts have moved on the common range. **`--explain N`** prints one row's full term breakdown — every intra, within-class-cross and cross term, which one binds, the twist and its F_mid/F_top split, the foreign block's η and u, and whether the value exceeds its class ceiling.

It **replaces the by-hand checking** done in each review pass, and it found a documentation error on its first run (see below). **Amend it in the same pass whenever the model changes** — each check names the document section it comes from, so a stale check is findable from either end. Note what it does *not* do: it checks the table against the documents' model, not against mathematics. For independent evidence use `brute_compare.py`.

### A9. The unequal-matching-sizes dichotomy — rescoped: this **is** Open Problem 1, at odd p

*Raised 2026-08 while making §6 rigorous, then traced to an existing item rather than a new one.*

§6 needs each shape to determine **one** Bateman–Horn system, hence all matching classes to share a block size. The argument given — two blocks of different odd prime-power sizes contribute C_{c−1} × C_{c′−1}, both orders even, never cyclic — **assumes full twists**. A block of size c with twist of order d has intra term ≈ cd/2, so it needs only d ≥ δ₀n²/c, a twist *fraction* ≥ δ₀/x², about 0.55 at x = 0.3 and δ₀ = 0.05. Cyclicity constrains the twist **orders** to be pairwise coprime, not the full multiplicative groups to embed, so two unequal classes cost a factor of 2 at worst — affordable at these densities.

**And at p = 2 the dichotomy fails outright, with a witness already in the documents.** Open Problem 1's worked instance is **n = 551 = 256 + 167\* + 128** — two matching classes of *different* sizes, 2⁸ and 2⁷. Both c − 1 = 255 and c′ − 1 = 127 are **odd**, gcd(255, 127) = 1, so both twists are full and the cyclic layer C₂₅₅ × C₁₂₇ × C₁₆₇ is genuinely cyclic. This is exactly §6.5's second escape, and it is the mechanism Open Problem 1 asks about.

**So the residual question is the odd-p case, and it is Open Problem 1 in general form:** at odd p, c − 1 and c′ − 1 are both even, so at most one twist keeps its 2-part. Does the resulting loss always sink the configuration below what an equal-size shape achieves at the same n, or is there a family here? Framed that way it is the same "can a family with different local structure beat the ℓ = 2 loss" question, with the 2-power escape being the known positive answer at p = 2 and the odd-p case open.

**If it goes the other way, what breaks is the arithmetic and not the architecture.** Finiteness survives — a shape would additionally record a set partition of its matching parts by size, bounded by k ≤ 1/√δ₀, so it is still finitely many explicit Bateman–Horn systems. The purely additive count goes from Σ_{k≤K} k = K(K+1)/2 to Σ_{k≤K} Σ_{j<k} p(j), i.e. from ≈1/(2δ₀) to exp(c·δ₀^{−1/4}); at the conjectured floor **28 → 63** once the factor-2 penalty is charged (75 without it), and the raw count **982 → 1,956**. A factor of about two, not an explosion. §3.3's ceilings are unaffected, since an unequal-size configuration loses a factor 2 on one class's intra term and so caps *below* the equal-size shape of the same part count. Parity survives too. See the box in §6.2.

**What is wanted:** given c = p^a, c′ = p^b with a < b and p odd, twist fractions bounded below by δ₀/x² and δ₀/x′², and pairwise-coprime orders, show x + x′ ≤ 1 cannot be met — or exhibit the configuration. The second branch would be a new family and would also break §6's one-size-variable presupposition, so the shape count depends on it.

**Evidence meanwhile:** **no winner in the computed table has two matching classes of different sizes at odd p** (the p = 2 instances aside), and all seven winners with two matching classes have them equal. The enumerator imposes the true pairwise-coprimality condition rather than the full-twist version, so it would have found such a configuration had one been optimal below n = 1572. Checked automatically by `validate_table.py` (group B) on every extension.

*Note the v4 witness at n = 551 is now `p=2 q=83: 3x128 + 1x167*` — a fused class of three 128-blocks, not the two distinct powers of 2. The 256 + 167\* + 128 configuration is still admissible and still makes the point about cyclicity; it is simply no longer the optimum there. Open Problem 1's worked instance should be restated as an admissible configuration rather than as a winner.*

### A10. Two defects in the GAP/CSP pipeline — see `gap_review.md`

*Found 2026-08 on a cold review of the n = 10 pipeline. The pipeline is otherwise sound: the order matrix verifies clean (V = 1,242, reflexive, 0 antisymmetry and 0 transitivity violations sampled), and the χ machinery already subsumes §9.7's fixed-complex criterion rather than needing it added.*

**(a) `adversary.py` poisons its persisted memo on budget exhaustion — fix before any rerun.** A child returning `False` because the node budget ran out is indistinguishable from a genuine failure to survive; the `out_of_budget` test sits *after* the `res = False; break`, so `memo[key] = False` is written for a node whose value is unknown. The memo is pickled in the heartbeat and in the `finally`, and reloaded on the next run — which the docstring actively recommends. Failure mode is a spurious **NON-EVASIVE**, the counterexample-found verdict. Two-line fix in `gap_review.md` §1; **delete any `adversary_memo.pkl` from a BUDGET run rather than resuming it.**

**(b) `ark_intersect.py`'s `.top_primes` is unsound, and fires at n = 12.** It reads q off the **twist** prime, which is the cyclic layer, not the top — the same layer conflation as the S5/S7 finding. Returning the minimum is safe, but the documented "enforce mod lcm, strictly stronger" is not: a twist prime need not be a valid top prime. At the group the docstring itself names, AGL(1,5)[d=4] × F₇:C₃ on n = 12, q = 2 is valid and q = 3 appears not to be, so mod 6 would impose an unjustified constraint — and on a CSP whose useful answer is UNSAT, an unjustified constraint is **a spurious proof of ARK**. `ark_gap.g` is unaffected: `IsOliverTop` verifies each q against an actual normal subgroup, so **lcm over the GAP `"+"` tag is legitimate; lcm over `.top_primes` is not.** Nothing consumes the tag today and no n = 10 group is multi-prime, so this is latent.

**(c) Worth measuring, not a defect.** By §9.7 the χ constraint is decisive at t ≤ 3 and weak by t ≥ 4, but 93% of the battery's Σ2^t cost sits at t ≥ 7 (31 groups, 16,128 of 17,356). High-t groups do generate catalog classes and monotonicity couplings, so this is not an argument to drop them — but the battery is selected by m\* and cost, never by constraint strength, and the trade is unmeasured. Cheap test: solve the t ≤ 6 sub-battery (44 groups, 7% of the cost) and see how much backbone survives. If most does, n = 12 becomes tractable.

### A11. Section 8.8-8.12 validation -- mostly PASSED; two findings and one gap

*The n = 10 artefacts arrived and the census claims check out exactly.* **967 = 268 Oliver + 699 p-groups**; 24 transitive Oliver groups at t <= 12; `groups_out.txt` well-formed; order matrix reproduces (V = 1,242, 249,711 true entries, density 0.162); catalog complement-closed with **no self-complementary class**; m* = 20 via AGL(1,5) wr C2; section 9.7's "skeleton contains 2K5, not K5,5" confirmed (x[2] = 1, x[1] = 0); probe record 817 rows / 409 classes / **54 CAP** exactly as the source comment says; involution 30 confirmed pairs, 0 violations. I re-derived primal and dual chi for all 40 Oliver groups on `solution1.pkl` from scratch: **0 violations**, plus 0 monotonicity violations. Detail in `gap_review.md` section 0.

**Finding 1 -- every t <= 3 group has chi = 1 exactly, primal and dual**, including those only required to satisfy chi = 1 mod q, and the one extra option section 9.7 permits (chi = 3 at t = 3, q = 2) is not taken. The criterion's prediction lands empirically, and at the small-t end the mod-q groups behave as if they had trivial tops.

**Finding 2 -- the complement-dual of solution1 is itself a valid solution, with 1,028 IN classes against 214.** Section 8.9's involution is a pairing of the *solution set*, not a symmetry of any solution (they differ at 814 of 1,242 classes), and the pair is wildly asymmetric in size. Any argument from "the surviving property is sparse" must reckon with a dense dual partner the CSP cannot distinguish.

**Gap -- the free band is not established.** Forced IN runs to 10 edges and forced OUT from 35, but the 54 CAP probes span **9-36**, straddling both boundaries. So "band = 11-34, static" is not a measurement, and the runbook's escalation rule (static band => stage FULL) is being applied to an unestablished number. **Rerun the 54 CAP classes at a larger `--nodecap` before escalating**; it is far cheaper than stage FULL.

### A12b. Corrections to `small-degree-verification.md` -- see `small-degree-review.md`

Four corrections and one reordering. **m* = 18 at n = 12 is attained by 8 groups / 1 orbital partition / 3 distinct (partition, prime) conditions** -- that document is right, section 8.11's "six ways" is wrong, and my own "seven ways" missed the wreath `B2:4x3:4.1` = T(4,4) wr T(3,1), whose presence is the direct confirmation that (F4:C3) wr C3 attains the optimum. **Its item 5b's "the eight attainers sit at q = 2 and q = 3" is wrong**: one is `A:166`, a **trivial top**, so the optimum is witnessed by the harshest condition available. **Its item 4's CAP range is 9-36, not 12-36**, which matters because forced-IN ends at 10 and forced-OUT begins at 35, so the CAPs straddle both boundaries. **Its item 6 is answerable**: the `+` diagnostic returns 0 at both degrees, 8,082 groups, so either the files predate the change or no group admits two usable q -- and if a fresh re-emission also yields none, the lcm strengthening should be **retired**, not left as dead code carrying the A10(b) hazard.

**New finding: `--maxt` truncates far more than `--maxgroups`.** I reimplemented `_orbital_canon` independently and it reproduces the n = 12 log exactly (2,293 -> 230 distinct, 2,063 redundant, 203 Oliver + 27 p-groups). Distinct conditions by cut: maxt 4/5/6/7/8/10/12 -> 36/73/125/169/**230**/339/**425**. So `--maxgroups 200` drops 3 conditions and `--maxt 8` drops **195**. The honest framing of the proposed `--maxt 6` remedy is "we use 54% of available conditions today; that would use 29%".

**Reordering: run a cheap battery before deciding how to compute S.** That document's item 11 says the S question gates item 1. The prior question is whether n = 12 is SAT at all: a `--maxt 6` battery is 125 conditions with a much smaller catalog, and stage 3 scales with V-squared, so plausibly hours. UNSAT there settles n = 12 and neither the 22-day stage 3 nor the EGF route is needed.

*Also:* item 8's premise verified (the empty graph is in both catalogs, so the mutating-`classify` hazard is latent as described); item 7's audit script is written and validated (`dedup_audit.py`) but **the n = 10 `groups_out.txt` was replaced by the n = 12 one in the latest upload** -- re-upload it and item 7 closes in two minutes.

### A12. n = 12 validated — census exact, one off-by-one, and stage 3 is a 22-day job

**Exact:** 7,115 = 295 + 657 + 67 + 6,096 (6,004/88/2/2); 2,293 raw at t ≤ 8; all lines well-formed with 66-entry maps; stages A/B/B2/C = 194/969/28/5,924; inference rate 20.8% against n = 10's 19.9%. The earlier 8,819 was wrong and 7,115 is right.

**Corrections to §8.11:**

- **m\* = 18 is achieved *seven* ways, not six** — `A:85`, `A:164`, `A:166`, `A:207`, `A:228`, `A:229`, `A:265`, all with orbital sizes [18, 48] and one (`A:166`) with a trivial top. Exceeded zero ways, so the wreath-optimality conclusion stands. All seven are **t = 2**, so §9.7's two-orbital criterion applies at n = 12 exactly as at n = 10: any counterexample contains **exactly one** of the 18-edge and 48-edge orbitals.
- **"keeps 230" should be "keeps 227".** 230 is the number of *distinct (partition, prime) conditions*; 227 is what survives `--maxgroups 200` capping the Oliver side (203 distinct Oliver conditions, 3 dropped).
- **`done_keys.txt` gives the missing skip count**: 16,353 keys against 7,115 emitted, so **9,238 groups were dropped** as non-Oliver or over `MAXT = 12` — 56% of what GAP built, and the bound on what raising `MAXT` could add.

**Action needed — the running battery will not finish.** Measured from the log's own throughput (16,061 pairs in 30,002 s = 0.54 pairs/s), the 227-group stage 3 needs **1,018,719 VF2-requiring pairs ≈ 529 h ≈ 22 days**, against ~39 h total for the 59-group battery. §8.11's "should collapse to hours" is right for the 59-group run and wrong for this one: the inference *rate* transfers, but 13.6× the classes means 13.7× the work. (Upper bound only — the closure feeds back on resume, 20.6% → 17.8% → 16.8% on the small battery — but not an upper bound that makes it advisable.)

**Run a t ≤ 6 battery instead**, per §9.7's finding that constraint force comes from *few* orbitals: 125 of the 227 groups, all four t = 2 groups included, Σ2^t of 4,952 against 25,432, and a much smaller catalog since class count is driven by the big lattices. Cheapest route to a SAT/UNSAT verdict at n = 12; if UNSAT, the expensive battery is never needed.

**One more observation across both degrees.** No group at n = 10 or n = 12 carries a **multi-prime tag** — tags are `0`, `2`, `3` and `P*` at both. So the `+`-separated tag and the lcm strengthening in `stage4_fast.py` / `probe_backbone.py`, which Appendix B flags as "available and unused", **has never fired in 8,082 groups**. Worth understanding why before treating it as a live strengthening, especially as it carries the A10(b) soundness hazard.

### A11b. Artefacts still wanted -- see `gap_data_wanted.md`

Those sections assert roughly twenty numbers; three are verifiable from the uploaded n = 10 checkpoints and the rest are not. Priority order: **groups_out.txt at n = 10** (the 967 / 268 / 699 headline, unreachable from `ckpt_groups.pkl`, which holds only the 75 post-selection survivors), **groups_out.txt at n = 12** (a census that has already been wrong once, 8,819 to 7,115, plus the m* = 18 six-ways claim underpinning the wreath clause), **a stage-4 solution pickle** (unlocks the section 8.9 backbone, section 9.7's "the skeleton contains 2K5" claim, and makes `chi_test.py` runnable so section 8.12's chi kill can be reproduced), and **stage4_fast.py / probe_backbone.py** (unreviewed, and where the A10(b) lcm hazard would land).

*Verified meanwhile:* section 8.11's order-matrix acceptance reproduces exactly (V = 1,242, 249,711 true entries, density 0.162, reflexive, antisymmetric, transitive on samples); the catalog is **complement-closed with no self-complementary class**, confirming section 8.9's involution as a property of the object; and m* = 20 at n = 10 from AGL(1,5) wr C2, with 2K5 and K5,5 sitting at catalog indices 2 and 1.

### A2. Promote E.3(ii) past the bare pair

The last theorem-side residue in the fallback collapse. With a leftover, the (r, r) re-reading must also re-type the leftover parts, and the commonest case **L = c** fails outright because two blocks of the same prime c would be two equal foreign parts, which Part E forbids.

*Scoped 2026-08 and not attempted.* Two things about its shape are worth recording before anyone spends time on it.

- **No structural argument can work**, and that is already proved: cases (α)–(γ) of E″ show that within a fallback configuration's own partition the fallback reading is *forced*, so any promotion must compare across partitions of n — where additive supply enters and one is back at Hypothesis (H). So this is not a gap to be closed by a better case analysis.
- **The "505 branches" figure is v2-era and probably much smaller now.** A1's recount found the whole fallback question narrowed sharply under the corrected shape space (s ≤ 3 everywhere in range, δ ≤ 1/16 down from 17 values to 3). The first move is a recount, not a proof — rerun `fallback_cert.py` against v4 and see what the residue actually is.

Two questions for whoever picks it up, either of which would make it tractable rather than open-ended:

1. **Is the q-pinning mechanism written out anywhere in full?** E″ observes that r − 1 = 2q forces every leftover foreign part into r_j ≡ 1 (mod q), and calls it "the likely ingredient of an unconditional argument", but only in the context of the Cunningham chain 719 → 1439 → 2879. Extracting it as a lemma looks doable; the question is whether that has been tried and hit something.
2. **Is L = c the only obstructed leftover, or only the one that has come up?** If every other leftover shape is re-readable, the open case is narrower than "with a leftover" — it is a single configuration, two equal c-blocks plus the foreign r, which is exactly the shape of both unresolved values below 10⁵ (n = 50,817 and n = 89,697) and might yield to a direct argument.

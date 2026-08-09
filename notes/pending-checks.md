# Pending checks

*What is left to run or verify, for the arithmetic programme — `orbital-evasiveness-notes.md` §§1–6, `enumeration-proof.md`, `arithmetic-of-density.md`. **Outstanding work only** — anything closed moves to a session log and is not restated here.*

**Small-degree work lives elsewhere.** Everything pursued at a single fixed degree — the GAP battery, the CSP and its backbone probes, the χ machinery, the template enumerator — is in `small-degree-verification.md`, including its own run list. It touches this programme at exactly one point: **exhaustiveness of the GAP stages**, which licenses Part I's two non-circular comparisons at n = 10 and n = 12. Nothing else there gates anything here.

**Companion files.** The three documents hold the results and their figures. The review record is in `session-log-4.md` (current), `session-log-3.md`, `session-log-2.md` and `session-log.md`. Literature findings, which bear on framing rather than correctness and are deliberately not folded into the primary documents, are in `literature-findings.md`. Single-small-degree work — the GAP battery, the SAT/CSP machinery, the backbone probes, the template enumerator — is in `small-degree-verification.md`, which touches §§1–6 only through the n = 10 and n = 12 exhaustive comparisons cited in Part I.

**Status labels.** *Verified* — an independent computation agreed. *Sound* — an argument was read and found correct, with no independent computation. *Unverified* — neither.

*Do not restate the inequality as `B_safe ≤ μ`.* `B_safe` deliberately over-counts per configuration, so B_safe and μ are incomparable in general; what holds is B_refined ≤ μ ≤ B_safe, with the endpoints collapsing wherever the certificate applies.

## Where the residual risk sits

Ranked, so the sections below have a stated basis. This is not the order the items appear in.

1. **The table rebuild.** v4 reaches n = 2000; everything measured across the three documents is keyed to it and moves as it extends. → **R0**, and **R1** after every batch.
2. **Exhaustiveness of the GAP stages.** The subdirect-product hole is undischarged. It degrades *evidence* rather than creating an error — a missed group could only have larger m\*, i.e. it would be a counterexample rather than a silent corruption — but it is the only non-circular check in the framework. **This is the one small-degree item the arithmetic programme depends on**, since Part I's two exhaustive comparisons rest on it. → `small-degree-verification.md` item 5
3. **Part E's realisability construction.** Attainment's other leg, argued in general and spot-checked at eight configurations from n = 12 to 315. Unlike the certificate, it has no per-n verification. → **T2**
4. **The eight necessary conditions of `fb_common.py`.** Both certificates rest on these and nothing else. What matters is their being *necessary* — that is what makes an empty candidate list a proof — and that is a different reading from checking each is true. The defect class to watch is an enumeration narrower than the shape space it must cover, which removes a real candidate silently and leaves the output looking clean. → **T3**

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
- **`check_doc_figures.py`** — `--quiet` for findings only, `--pass {figures,scope,prose,hygiene,census,refs}` for one pass; exits nonzero when anything is flagged. **Pass every `.md` that might be cited**, or `refs` reports live cross-document citations as dangling. And append the old maximum to `CHECKPOINTS` and a pattern to `SCOPE` in the same sitting, or figures written against the superseded range report as unexplained rather than as historical.

**Two things deliberately absent from this list.**

- **`ladder_verify.py`** is not a per-batch check — it never reads the table, it scores explicit families. It belongs to **R7** and runs on its own schedule.
- **`s7_scan.py` and `mu_fast.py` do not exist** in the working set. `validate_table.py` group B already covers the S4 / S5 / S7-at-F=2 congruence patterns `s7_scan.py` would test, so nothing is owed unless a new check is wanted.

**Do not extend the table without rerunning this list in full.** An extension leaves a different subset of the documents behind each time, and the failure is silent: a stale figure reads as a claim about the current range. The two passes that catch it mechanically are `check_doc_figures.py --pass refs` and `validate_table.py`'s coefficient assertion.

## R7. Rerun `ladder_verify.py` to 10⁶

The script scores the S7-at-F≥3 family at `F·orb(c, dmax)` and covers both F = 2 fused rungs, so its N = 20,000 worklist stands at **213** and the 10⁶ run wants redoing against it.

**Read the per-residue diagnostics rather than discounting them.** Fusion lifts only the intra term, so a residue moves when the fix reaches it and does not when its class minimum is foreign-bound — n ≡ 11 (mod 24) is the worked case (§3.7), where every rung-B class minimum is foreign-bound and the residue correctly does not move. **A residue not moving is informative about which term binds, not about the model being wrong.** `ASYMPTOTIC` = 0.050510; expect roughly half of the 41,584 worklist entries the wider model produced. Current spread at 20,000 is 0.327–0.653.

*One coverage gap, and it loses values rather than soundness:* the S7-at-F≥3 family still models prime-power `F` with one fused class, where the enumerator allows any `Fmid` and composite `F` such as 6 = 2·3.

```bash
python3 ladder_verify.py 1000000
```

> **Independent of R0.** `ladder_verify.py` never reads the table: its only input is NMAX on the command line, and it scores four explicit families in closed form off a sieve. So it can run alongside the rebuild, and its output does not go stale when the table extends.
>
> *What is not independent is the consumption.* The branch-and-bound of `arithmetic-of-density.md` §5.1 prunes this worklist against a running floor taken from B(n), so **settling the global density minimum** from the worklist does need R0. The worklist itself, the per-residue diagnostics and the global floor over the four families are all usable immediately.
>
> **It writes `ladder_weak.txt` unversioned**, so a rerun overwrites it. The previous output (`ladder_weak_v3.txt`, 41,584 entries) is evidence for the figures currently quoted in §3.7 and §5.2 — keep it, or rename the new one, before comparing the two.

# §2. Thinking work

## §2a. Needs human thought

*Judgement calls, independent scrutiny, or things requiring materials Claude cannot obtain.*

### T1. A second reading of the structural arguments

**A step compressed to a clause tends not to survive being written out**, and this framework's record bears that out: of its compact structural steps, one is false (the ΓL(1) step), one was false and is now repaired (the q-power block count), one needed two gaps filled (B′), and one holds only at prime c (Lemma C).

So: **work through the parts that have had no close reading** — Part A's orbit decomposition, Part E's realisability construction, Part F's counting bounds — and expect roughly one finding per three arguments.

*Human, because the value is in the independence.* A second pass by the same reader on the same evidence is worth much less than a first pass by someone else.

### T2. Verify Part E's realisability construction per-n

Attainment's other leg. It is argued in general and spot-checked at eight configurations from n = 12 to 315, and unlike the collapse certificate it has no per-n verification. The question is whether a per-n check is even the right shape here, or whether the general argument should be strengthened instead — that is a decision about where to spend effort, not a computation. **If** a per-n check is wanted, it is buildable and moves to §1.

### T3. A second read of the eight necessary conditions

These are the whole trusted base for μ(n) = B(n): both certificates pass with every Part E′ theorem disabled, so nothing else carries weight in the per-n proof. They have had one read, which found four narrowings and no soundness error. **The direction to fear is permissive** — a condition that is not in fact necessary silently removes a real candidate and leaves an empty list looking like a proof — and every correction these conditions have needed has been of that kind.

The specific question is not "is each condition true" but **"is each condition necessary"** — i.e. does every fallback configuration attaining B(n) really satisfy it. That is a different reading from the one already done, and it is the reading that matters.

*Human, for the same reason as T1: the value is in the independence.*

### T4. Literature checks — one read left, and two things to decide

*The reading is written up in `literature-findings.md` §§5–8. What is outstanding here is judgement, not reading.*

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

### A0b. `validate_table.py` — run this on every table extension

`python3 validate_table.py mu_table_safe_v4.csv --baseline mu_table_safe_v2.csv`

Checks are grouped into three, and the group tells you what a result means:

- **A. Table integrity** — is the file a well-formed enumeration at all? Well-formedness, Lemmas B′ and D2 on each witness, re-derivation of `mu_bound` from the witness by the G.3 formulas, the density column, certification, and monotonicity against a baseline. A FAIL here is a bug in the run or the parser, and nothing downstream is meaningful until it clears.
- **B. Exact claims, holding at every n** — Prop F.1, cap_F(η), S2's 1/F, layer-by-top-prime, S6 emptiness, Lemma C exposure, and the three congruence-gated patterns (S4 at c ≡ 1 mod 8; S7-at-F=2 at c ≡ 3 mod 4 bar the tie and p = 2; S5 at no congruence with u ≤ 9). A FAIL here is a real contradiction between table and documents.
- **C. Density and distribution** — floor and the s/k bounds it implies, low-density tail, part-count distribution, census shares, odd-n shares, class-ceiling exceedance, median density by residue mod 24, foreign-block efficiency, and the ω(n) = 2 share. All INFO, each printing the **expected asymptotic value beside the measurement** so the comparison needs no reference to `arithmetic-of-density.md`. A gap here is data about convergence, not a failure.

**Four of the group-B checks are the ones with no independent counterpart elsewhere, and are worth knowing by name:** the cyclic layer's global pairwise-coprimality condition (the corrected shape space's own admissibility rule, and the only check that would catch the enumerator *over*-correcting), the feasibility criterion Σ√Fᵢ ≤ 1/√δ that `aod` §6.1's shape counts are derived from, Part G.4's per-axis bounds, and the within-class cross **coefficient** — which is invisible to output, since the term never binds. Each has a negative control: breaking it makes the check FAIL.

Together they cover every belief the three documents currently state: well-formedness and Lemmas B′/D2 on each witness, re-derivation of `mu_bound` from the witness by the G.3 formulas, Prop F.1, cap_F(η), the S4/S5/S7-at-F=2 congruence patterns, S6 emptiness, layer-by-top-prime, monotonicity against a baseline, and seven measured quantities (floor and the s/k bounds it implies, low-density tail, part-count distribution, census counts, class-ceiling exceedances, foreign-block efficiency, Lemma C exposure). Exits nonzero on any FAIL.

Two extra modes cover the cases that would otherwise send you to the CSV. **`--baseline`** adds shape-migration and aggregate-movement reporting: which winners changed census row and in what direction, and how the floor, the low-density tail and the per-shape counts have moved on the common range. **`--explain N`** prints one row's full term breakdown — every intra, within-class-cross and cross term, which one binds, the twist and its F_mid/F_top split, the foreign block's η and u, and whether the value exceeds its class ceiling.

It **replaces the by-hand checking** of each review pass. **Amend it in the same pass whenever the model changes** — each check names the document section it comes from, so a stale check is findable from either end. Note what it does *not* do: it checks the table against the documents' model, not against mathematics. For independent evidence use `brute_compare.py`.

> **Keep it fast, and treat that as a design constraint rather than a nicety.** The whole suite runs in about **0.1 s on 1,700 rows**, which is what makes it something to run reflexively — before every certificate, after every batch, on any hunch — rather than a job to schedule. A check that costs seconds gets skipped, and a skipped check is worth nothing.
>
> So each check should stay **O(rows) or O(rows × parts)** with arithmetic on numbers already parsed from the witness. What does not belong here: enumerating configurations, VF2 or isomorphism work, re-deriving B(n), sieving past `NMAX`, or anything whose cost grows with n rather than with the row count. Those are `brute_compare.py`'s and the certificates' business, and they have their own items.
>
> The one place this bites is a check that wants to compare a row against alternatives rather than against a formula. If a new check needs that, it belongs in a certificate — and if it must live here, budget it against the 0.1 s and say so at the check, so the next person knows what they are protecting.

### A9. The unequal-matching-sizes dichotomy — rescoped: this **is** Open Problem 1, at odd p

§6 needs each shape to determine **one** Bateman–Horn system, hence all matching classes to share a block size. The argument given — two blocks of different odd prime-power sizes contribute C_{c−1} × C_{c′−1}, both orders even, never cyclic — **assumes full twists**. A block of size c with twist of order d has intra term ≈ cd/2, so it needs only d ≥ δ₀n²/c, a twist *fraction* ≥ δ₀/x², about 0.55 at x = 0.3 and δ₀ = 0.05. Cyclicity constrains the twist **orders** to be pairwise coprime, not the full multiplicative groups to embed, so two unequal classes cost a factor of 2 at worst — affordable at these densities.

**And at p = 2 the dichotomy fails outright, with a witness already in the documents.** Open Problem 1's worked instance is **n = 551 = 256 + 167\* + 128** — two matching classes of *different* sizes, 2⁸ and 2⁷. Both c − 1 = 255 and c′ − 1 = 127 are **odd**, gcd(255, 127) = 1, so both twists are full and the cyclic layer C₂₅₅ × C₁₂₇ × C₁₆₇ is genuinely cyclic. This is exactly §6.5's second escape, and it is the mechanism Open Problem 1 asks about.

**So the residual question is the odd-p case, and it is Open Problem 1 in general form:** at odd p, c − 1 and c′ − 1 are both even, so at most one twist keeps its 2-part. Does the resulting loss always sink the configuration below what an equal-size shape achieves at the same n, or is there a family here? Framed that way it is the same "can a family with different local structure beat the ℓ = 2 loss" question, with the 2-power escape being the known positive answer at p = 2 and the odd-p case open.

**If it goes the other way, what breaks is the arithmetic and not the architecture.** Finiteness survives — a shape would additionally record a set partition of its matching parts by size, bounded by k ≤ 1/√δ₀, so it is still finitely many explicit Bateman–Horn systems. The purely additive count goes from Σ_{k≤K} k = K(K+1)/2 to Σ_{k≤K} Σ_{j<k} p(j), i.e. from ≈1/(2δ₀) to exp(c·δ₀^{−1/4}); at the conjectured floor **28 → 63** once the factor-2 penalty is charged (75 without it), and the raw count **982 → 1,956**. A factor of about two, not an explosion. §3.3's ceilings are unaffected, since an unequal-size configuration loses a factor 2 on one class's intra term and so caps *below* the equal-size shape of the same part count. Parity survives too. See the box in §6.2.

**What is wanted:** given c = p^a, c′ = p^b with a < b and p odd, twist fractions bounded below by δ₀/x² and δ₀/x′², and pairwise-coprime orders, show x + x′ ≤ 1 cannot be met — or exhibit the configuration. The second branch would be a new family and would also break §6's one-size-variable presupposition, so the shape count depends on it.

**Evidence meanwhile:** **no winner in the computed table has two matching classes of different sizes at odd p** (the p = 2 instances aside), and all seven winners with two matching classes have them equal. The enumerator imposes the true pairwise-coprimality condition rather than the full-twist version, so it would have found such a configuration had one been optimal below n = 1572. Checked automatically by `validate_table.py` (group B) on every extension.

*Note that the winner at n = 551 is `p=2 q=83: 3x128 + 1x167*`, a fused class of three 128-blocks, not the two distinct powers of 2. The 256 + 167\* + 128 configuration is admissible and makes the point about cyclicity without being optimal there, so Open Problem 1's worked instance should be stated as an admissible configuration rather than as a winner.*

### A2. Promote E.3(ii) past the bare pair

The last theorem-side residue in the fallback collapse. With a leftover, the (r, r) re-reading must also re-type the leftover parts, and the commonest case **L = c** fails outright because two blocks of the same prime c would be two equal foreign parts, which Part E forbids.

Two things about its shape are worth recording before anyone spends time on it.

- **No structural argument can work**, and that is already proved: cases (α)–(γ) of E″ show that within a fallback configuration's own partition the fallback reading is *forced*, so any promotion must compare across partitions of n — where additive supply enters and one is back at Hypothesis (H). So this is not a gap to be closed by a better case analysis.
- **The residue is a single class of 247 branches**, all E.3(ii) pairwise-only. The largest permitted s over the computed range is 3, so the s = 4 and s = 5 branches — which have no theorem — are not reachable there, and only 7 values sit below δ = 1/16. So the target is one shape rather than a spread.

Two questions for whoever picks it up, either of which would make it tractable rather than open-ended:

1. **Is the q-pinning mechanism written out anywhere in full?** E″ observes that r − 1 = 2q forces every leftover foreign part into r_j ≡ 1 (mod q), and calls it "the likely ingredient of an unconditional argument", but only in the context of the Cunningham chain 719 → 1439 → 2879. Extracting it as a lemma looks doable; the question is whether that has been tried and hit something.
2. **Is L = c the only obstructed leftover, or only the one that has come up?** If every other leftover shape is re-readable, the open case is narrower than "with a leftover" — it is a single configuration, two equal c-blocks plus the foreign r, which is exactly the shape of both unresolved values below 10⁵ (n = 50,817 and n = 89,697) and might yield to a direct argument.

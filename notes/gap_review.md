# Review of the GAP/CSP pipeline against the 2026-08 understanding

*Updated with the second upload: `groups_out.txt`, `solution1.pkl`, `skeleton.pkl`, `probe_results.csv`, `stage4_fast.py`, `probe_backbone.py`. §0 below records what is now independently verified.*

## 0. Verified against the n = 10 artefacts

| §8.8–8.12 claim | status |
|---|---|
| **967 groups = 268 Oliver + 699 p-groups** | **exact.** Tags: 95 trivial-top, 159 at q = 2, 14 at q = 3, 673 P2, 18 P3, 6 P5, 2 P7. Stages A/B/B2/C = 24/319/6/618 |
| "45 transitive, **24 Oliver with ≤ 12 orbitals**" | **exact** — `^A:` lines number 24 |
| `groups_out.txt` well-formedness | **clean** — 0 lines with `NF != 4`, all orbital maps 45 long |
| §8.11 order-matrix acceptance | **exact** — V = 1,242, 249,711 true entries, density 0.162, reflexive, antisymmetric, transitive on 1,655 sampled chains |
| catalog complement-closure (§8.9) | **exact, and stronger than stated**: all 1,242 classes have their complement present, the map is an involution, and **no class is self-complementary** |
| m\*(10) = 20 via AGL(1,5)≀C₂ | **confirmed**, `A:17`/`A:18`, one with a trivial top |
| §9.7: skeleton "contains 2K₅, not K₅,₅" | **confirmed** — x[2] = 1 (2K₅, 20 edges), x[1] = 0 (K₅,₅, 25 edges) |
| probe record "**54 of 817** inconclusive" | **exact** — 817 rows, 409 classes, {IN 25, OUT 20, free 310, **CAP 54**} |
| involution predicts forced IN ↔ forced OUT | **30 confirmed pairs, 0 violations**, 15 forced classes whose complement is unprobed |

**I re-derived the χ conditions on `solution1.pkl` from scratch** — parsing the tags, recomputing primal and dual χ over all 2^t − 1 union masks for each of the 40 Oliver groups in the battery — and got **0 violations**, plus 0 monotonicity violations against the order matrix, empty graph IN, K₁₀ OUT. So the solution is verified independently of `stage4_fast.py`'s own leaf check.

**Two things that fell out of that and are worth recording as findings, not just checks.**

*Every t ≤ 3 group has χ = 1 **exactly**, primal and dual, including the ones only required to satisfy χ ≡ 1 (mod q).* That is §9.7's prediction landing empirically: at t = 2 the congruence leaves only v = 1, at t = 3 with odd q only χ = 1, and the one extra option the criterion allows (χ = 3 at t = 3, q = 2, meaning all three orbitals in P with no pairwise union) is **not taken** by the solution. So at the small-t end the mod-q groups are behaving as if they had trivial tops, and the battery gains nothing there from the distinction.

*The complement-dual of `solution1` is itself a valid solution, and a very different one.* Setting x\*[c] = 1 − x[comp c] gives 0 χ violations, 0 monotonicity violations, empty IN, K₁₀ OUT — **but 1,028 IN classes against the original's 214.** §8.9's involution is therefore not a symmetry of the solution (solution1 is not self-dual; they differ at 814 of 1,242 classes) but a **pairing of the solution set**, and the pair is wildly asymmetric in size. Anything reasoning from "the surviving property is sparse" should note that its dual partner is dense, and that the CSP cannot distinguish them.

*Scripts: `ark_gap.g`, `consume_gap.py`, `check_groups.py`, `compare_order.py`, `chi_test.py`, `ark_intersect.py`, `adversary.py`. Outputs: the n = 10 checkpoints and both logs. Reviewed cold against `orbital-evasiveness-notes.md` §§8.8, 9.7 and this session's findings.*

## Verdict up front

The pipeline is in better shape than the arithmetic side was. The GAP layer is **sound**, the order matrix **verifies clean**, and the χ machinery **already subsumes** the fixed-complex criterion of §9.7 rather than needing to be extended by it. Two defects are worth acting on: one is a genuine correctness bug in `adversary.py` that can produce a wrong verdict in the dangerous direction, and one is a latent unsoundness in `ark_intersect.py` that will bite at n = 12.

## 0b. n = 12: the census is exact, one count is off by one, and stage 3 will not finish

**§8.11's n = 12 census reproduces exactly.** 7,115 groups = **295** trivial-top + **657** at q = 2 + **67** at q = 3 + **6,096** p-groups (6,004 P2, 88 P3, 2 P5, 2 P11), summing correctly; all 7,115 lines well-formed with 66-entry orbital maps; stages A/B/B2/C = 194/969/28/5,924; **2,293 raw at t ≤ 8** as claimed. The earlier 8,819 figure is indeed wrong and 7,115 is right.

**`done_keys.txt` supplies the number that was nowhere recorded**: 16,353 keys against 7,115 emitted, so **9,238 groups were examined and dropped** — either non-Oliver or exceeding `MAXT = 12`. That is 56% of everything GAP built, and it bounds what raising `MAXT` could add.

**m\* = 18, exceeded zero ways — but achieved *seven*, not six.** The transitive census gives `A:85`, `A:164`, `A:166`, `A:207`, `A:228`, `A:229`, `A:265`, all with orbital sizes **[18, 48]** (summing to 66 ✓), tags 3/3/**0**/2/3/3/3. So §8.11's "six ways" is off by one, and the wreath-optimality conclusion is unaffected. Note what the list shows: **all seven are t = 2**, and `A:166` has a **trivial top**, so this is structurally the same situation as n = 10's `A:17`/`A:18` — §9.7's two-orbital criterion applies at n = 12 too, reading: *any counterexample contains exactly one of the 18-edge and the 48-edge orbital.*

**No group at either degree carries a multi-prime tag.** Tags at n = 12 are `0`, `2`, `3`, `P2`, `P3`, `P5`, `P11`; at n = 10, `0`, `2`, `3`, `P2`, `P3`, `P5`, `P7`. So the `+`-separated tag and the lcm strengthening in `stage4_fast.py` / `probe_backbone.py` — the thing Appendix B flags as "available and unused" — **has still never fired**, at 8,082 groups across two degrees. Either `IsOliverTop` is finding fewer multi-prime groups than expected, or the strengthening is worth less than its write-up suggests. Worth one look at *why*, since it is currently dead code carrying a soundness hazard (§2).

**The "227 vs 230" figures are two different things.** The log reads *"2,063 groups impose a condition already present, 230 distinct (partition, prime) conditions"* and then *"2,293 raw → 227 kept (200 Oliver, 27 p-groups)"*. So 2,293 − 2,063 = **230 distinct conditions exist**, of which **227 are kept** because `--maxgroups 200` caps the Oliver side at 200 (203 distinct Oliver conditions, 3 dropped). §8.11's "with the corrected dedup it keeps 230" conflates the two; it keeps 227.

**Stage 3 on the 227-group battery is a 22-day job, not "hours".** Measured from the log's own throughput on the 59-group battery — 16,061 pairs resolved in 30,002 s across three runs — the rate is **0.54 pairs/s**:

| battery | V | ordered pairs | need VF2 | projected |
|---|---|---|---|---|
| 59 groups | 600 | 359,400 | 74,213 (20.6%) | ~39 h total, ~30 h remaining |
| **227 groups** | **2,212** | **4,890,732** | **1,018,719 (20.8%)** | **~529 h ≈ 22 days** |

§8.11's "the measured 48 h ETA of the unoptimized code should collapse to hours" is right about the *59-group* battery and wrong about the one now running. The inference rate transfers intact — 20.8% versus 20.6% versus n = 10's 19.9% — but 13.6× the classes means 13.7× the work, and the constant factor was the thing being optimised, not the exponent.

*One encouraging detail the log does show:* the VF2 results feed back through transitive closure between runs, so the pairs-needing-VF2 count **falls on resume** — 20.6% → 17.8% → 16.8% on the 59-group battery. The work is superlinearly self-reducing, which the projection above ignores, so 22 days is an upper bound. It is not an upper bound that makes the run advisable.

**§9.7 says which battery to run instead.** The constraint's force comes from few orbitals, and the 227-group selection is 58 groups at t = 8 costing 25,432 of its 25,432 lattice cost… of which:

| cut | groups | Σ2^t | Oliver |
|---|---|---|---|
| t ≤ 4 | 36 | 440 | 35 |
| t ≤ 5 | 73 | 1,624 | 72 |
| **t ≤ 6** | **125** | **4,952** | **119** |
| t ≤ 8 (current) | 227 | 25,432 | 200 |

A **t ≤ 6** battery keeps 125 of 227 groups — including all four t = 2 groups, where the criterion is decisive — at a fifth of the lattice cost and, more importantly, a far smaller catalog, since the class count is driven by the large lattices. That is the run to do first: it is the cheapest way to learn whether n = 12 is SAT or UNSAT, and if it is UNSAT the expensive battery is never needed.

## 0a. The free band is not established, and §8.9 should not be read as if it were

The probe record's headline is IN 25 / OUT 20 / free 310 / **CAP 54**, with

- forced **IN** at 0–10 edges,
- forced **OUT** at 35–45 edges,
- **CAP** at 9–36 edges.

So the CAP set straddles *both* boundaries: there are inconclusive probes at 9 and 10 edges, where the forced-IN band ends, and at 35 and 36, where forced-OUT begins. **The band edges are therefore not determined** — "max forced IN = 10" is a statement about what has been proved, not about where the boundary is, and a rerun at larger `--nodecap` could move it either way.

`probe_backbone.py` already says this, in a comment that deserves to be in the notes rather than the source: *"a class with a CAP probe is NOT known to be free … at n = 10 ran to 54 of 817 probes, concentrated at 12–36 edges, i.e. straight through the free middle band whose freeness §§8.6 and 8.9′ reason from."* That is the right caveat and it is currently stronger than what §8.9 records.

It also bears on the runbook's escalation rule (§3: "if the free middle band narrows below ~10 edges, the dual χ-magnitude screen likely finishes it; if the band is static, the miss is lattice-decoupling and stage FULL is the escalation"). The observed band is 11–34 edges — 24 wide, i.e. **static**, pointing at FULL. But with 54 CAP probes inside it, the band width is not yet a measurement, so the escalation decision is being made on an unestablished number. **Rerunning the 54 CAP classes at a larger node budget is cheaper than stage FULL and should come first.**

## 1. `adversary.py` — a budget-exhaustion path poisons the persisted memo

**This is the one to fix first.** In `survive`:

```python
if not (survive(L | bit, A, k + 1) or survive(L, A | bit, k + 1)):
    res = False; break
if out_of_budget[0]: return False
...
memo[key] = res
```

A child that returns `False` *because the node budget ran out* is indistinguishable from a child that genuinely fails to survive. The budget check sits **after** the `res` assignment, so the `break` path skips it and control falls through to `memo[key] = res` — writing **False for a node whose value is unknown**.

Three things make this worse than a transient error:

- the memo is **persisted** (`pickle.dump` in the 30-second heartbeat, and again in the `finally`), so the poison outlives the run;
- it is **reloaded** on the next invocation, and the docstring explicitly advertises "rerun larger — the memo is persisted and reloaded, so reruns resume most of the work";
- `if key in memo: return memo[key]` sits at the top, so a poisoned entry propagates to every ancestor.

The failure mode is a spurious **NON-EVASIVE** — the "counterexample found" verdict, i.e. the wrong direction to be wrong in. The fix is two lines: test `out_of_budget[0]` before interpreting the child result, and never write to `memo` (or to disk) once it is set.

```python
    for i in range(N):
        bit = 1 << i
        if (L | A) & bit: continue
        a = survive(L | bit, A, k + 1)
        b = survive(L, A | bit, k + 1) if not a else False
        if out_of_budget[0]: return False        # BEFORE reading a, b
        if not (a or b):
            res = False; break
    if out_of_budget[0]: return False
    memo[key] = res
```

**Any existing `adversary_memo.pkl` from a BUDGET run should be deleted**, not resumed.

## 2. `ark_intersect.py` `top_prime` — reads the wrong layer, and one documented "improvement" is unsound

The function derives q from the **twist** prime of each part (`F<c>:C<tw>`). That is exactly the layer conflation this session spent its time on: the twist lives in the **cyclic** layer, the top prime governs **Γ/Γ₁**. The two coincide for a single-part group `F_c : C_{q^e}` — the chain Γ₂ = 𝔽_c, Γ₁ = Γ₂, Γ/Γ₁ = C_{q^e} is valid — so the *returned* value is a legitimate top prime there and the docstring's "SAFE direction" claim holds for weakness (1).

**Weakness (2), as documented, is not safe.** The docstring says a group admitting several top primes "forces the congruence modulo each, hence modulo their lcm — strictly stronger", and exposes `.top_primes` for a consumer to use. But the primes in that set are *twist* primes, and a twist prime need not be a valid top prime. Concretely, at the group the docstring itself names, AGL(1,5)[d=4] × F₇:C₃ on n = 12:

- **q = 2 is valid**: N = 𝔽₅ × (𝔽₇⋊C₃) is 7-by-cyclic (N/O₇(N) ≅ C₁₅), and Γ/N ≅ C₄ is a 2-group.
- **q = 3 appears not to be**: neither O₅ nor O₇ leaves a cyclic quotient in the complementary factor, so no normal N with Γ/N a 3-group of that shape presents itself.

Enforcing χ ≡ 1 (mod 6) there would impose an unjustified constraint, and an unjustified constraint on a CSP whose *useful* answer is UNSAT means **a spurious proof of ARK**. This is the one place in the pipeline where an error would be silent and in the fatal direction.

**`ark_gap.g` does not have this problem**, and the contrast is instructive. `IsOliverTop` iterates over `NormalSubgroups(G)`, checks each candidate Γ₁ for the p-by-cyclic condition, and adds q *only* when `FactorGroup(G, N)` is verified to be a q-group. So the `"+"`-separated tag it emits is a set of **verified** top primes, and taking their lcm downstream is sound. The rule to record: **lcm over the GAP tag is legitimate; lcm over `ark_intersect.py`'s `.top_primes` is not.**

**This is live, not latent.** `consume_gap.py` carries the tag as an opaque string and never splits on `"+"`, but §8.11 of the notes records that `stage4_fast.py` and `probe_backbone.py` **do** enforce χ ≡ 1 mod lcm on it. That is sound *because* the tag comes from `IsOliverTop` — but it means the two paths must never be crossed: if anything ever feeds `ark_intersect.top_prime`'s `.top_primes` into the same lcm enforcement, the result is unsound. Worth an assertion at the consumption point rather than a comment. No group in the n = 10 battery is multi-prime (tags are `0`, `2`, `3`, `P2`, `P3`, `P5`, `P7`), so the distinction has not yet been exercised; at n = 12 it will be.

## 3. The χ machinery already contains §9.7's fixed-complex criterion

Worth stating so nobody "improves" the CSP by adding it. `ark_intersect.py`'s

```python
def chi(t, member):
    c = 0
    for m in range(1, 1 << t):
        if member[m]: c += 1 if (bin(m).count('1') % 2 == 1) else -1
```

is exactly χ(Δ_P^Γ) = Σ_{S ≠ ∅} (−1)^{|S|−1} over the faces, where a face is a set of orbitals whose union lies in P. So the CSP enforces the **full** condition, of which §9.7's t ≤ 3 tables are hand-readable consequences. The criterion is a tool for reasoning, not extra power for the solver.

**The n = 10 battery confirms the §9.7 analysis empirically.** Five groups have t = 2 and eleven have t = 3 — exactly the range where the criterion is decisive — and among them:

| key | t | tag | m\* | reading |
|---|---|---|---|---|
| `A:18` | 2 | **0** (trivial top, χ = 1 *exactly*) | 20 | orbitals of 20 and 25 edges; χ = 1 forces **exactly one** in P |
| `A:17` | 2 | 2 | 20 | same group data at q = 2; v = 2 gives χ = 2 ≢ 1 (mod 2), same conclusion |
| `A:6`, `A:8`, `B:9+1:9.1`, `B:9+1:10.1` | 3 | 0 | 5–10 | with all three orbitals in P, exactly two pairwise unions must lie in P |

`A:17`/`A:18` at m\* = 20 is Theorem 2.1's group at m = 5, and it is where the battery's μ lower bound of **20/45 = 0.444** comes from. So §9.7's worked case *is* the n = 10 case, and it behaves as predicted: a genuine constraint, no contradiction — which is why n = 10 remains open.

## 4. The battery's cost profile argues for a different selection rule

By §9.7, the χ constraint's force comes from **few** orbitals: at t = 1 it is a contradiction, at t = 2 it pins the count, at t = 3 it pins the count *and* the union structure, and by t = 4 the congruence has enough complexes to hide in. The battery's cost is the opposite shape:

| | groups | Σ2^t | share |
|---|---|---|---|
| t ≤ 3 (criterion decisive) | 16 | 108 | **0.6%** |
| t = 4–6 | 28 | 1,120 | 6.5% |
| t ≥ 7 (criterion weak) | 31 | 16,128 | **93%** |

So 93% of the lattice cost buys the constraints §9.7 says are weakest. That is *not* an argument to drop them outright — high-t groups also generate catalog classes and hence monotonicity couplings, which is a different kind of value, and the catalog tripling from 428 to 1,242 classes when 18 p-groups were added is direct evidence of it. But it is an argument that **the battery is currently selected by m\* and orbital cost, and not by constraint strength**, and that the trade has never been measured. A cheap experiment: run the solver on the t ≤ 6 sub-battery (44 groups, 1,228 cost, 7% of the total) and see how much of the backbone survives. If most of it does, the n = 12 run becomes tractable in a way it currently is not.

## 5. `chi_test.py` — the sign convention checks out

χ(Δ_P) = Σ_{G ∈ P, G ≠ ∅} (−1)^{|E(G)|−1} = −(S − 1) = 1 − S, since the empty graph contributes +1 to S = Σ_{G ∈ P} (−1)^{|E(G)|}. That matches the code. The two sanity assertions — down-closure contains the empty graph, excludes K_n — are the right pair, and the docstring is correctly careful that a CSP solution constrains only *catalog* classes, so the test covers one canonical extension and not the solution.

One gap worth noting: `S = 0` is reported as "screen PASSED", which is right, but the script does not say how *often* S = 0 should be expected by chance. For a property with L labelled members, S is a signed sum of L terms; a heuristic null model would make |S| ≍ √L, so S = 0 exactly is a strong signal rather than a coin flip. Recording that would stop a future reader over-reading a pass.

## 6. Smaller observations

**`check_groups.py`'s green-light criteria are the right ones**, and the degree auto-detection is correct (45 → n = 10 via the triangular inverse). One addition suggested by §9.7: report the count of t ≤ 3 groups, since a battery with none of those has lost its sharpest constraints regardless of how many groups it has.

**`compare_order.py` handles all three checkpoint formats** and refuses to compare partials, which is right. The v3 `TU`/`F` undecided count is the correct completeness test.

**The order matrix verifies clean, and §8.11's acceptance figures reproduce exactly.** V = 1,242, reflexive, 0 antisymmetry violations, 0 transitivity violations in 1,655 sampled chains, **249,711 true entries, density 0.162** — bit-for-bit the numbers §8.11 quotes for the archived reference. Combined with `consume_gap.py`'s own VF2 spot-check ("verification PASSED"), the inference layer is trustworthy.

**The catalog is closed under complementation, exactly.** Its edge-count distribution is palindromic (1, 1, 2, 3, 4, 5, 12, … 12, 5, 4, 3, 2, 1, 1), and checking every class: all 1,242 have their complement in the catalog, the map is an involution, and **no class is self-complementary**. That is §8.9's involution verified as a property of the object rather than of the argument, and the absence of fixed points means the involution pairs the catalog perfectly — a useful fact, since a self-complementary class would be a fixed point of any duality argument built on it.

**The two named orbitals of §9.7 are catalog classes 1 and 2**: K₅,₅ (25 edges) at index 1 and 2K₅ (20 edges) at index 2 — the orbitals of `A:17`/`A:18`, entering the catalog first because that group is processed first.

**The `9+1` groups are fixed-point configurations**, and keeping them is correct — a point worth recording because it cuts against the enumeration side. Part A discards fixed points, since a fixed point caps m\* at n − 1 (and indeed these have m\* = 9). But Angel–Borja's Corollary 4.3 gets a strong conclusion from exactly such a configuration at n = p^r + 1, and here they contribute catalog classes and χ constraints for free. **Fixed points are worthless for orbital annihilation and useful for the transversal/χ argument** — the GAP battery already exploits what §6 discards, which is the cleanest illustration of why the two halves of the framework want different groups.

**The log records a selection change mid-run** (`stage 1: SELECTION CHANGED -> rebuilding all downstream checkpoints`, 23:08:06) after a partial resume at 22:16 had already extended the catalog from 428 to 992 classes under the *old* selection. The rebuild did the right thing. But it is worth noting that the 22:16 run's stage-2 output (992 classes) and the 23:08 rebuild's (1,242) differ for the same 75 groups, because the resumed run inherited a catalog built from 57. The signature check caught it. That is the checkpoint discipline working as designed, and it is the reason to keep it.

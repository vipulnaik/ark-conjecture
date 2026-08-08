# Review of the GAP/CSP pipeline against the 2026-08 understanding

*Scripts: `ark_gap.g`, `consume_gap.py`, `check_groups.py`, `compare_order.py`, `chi_test.py`, `ark_intersect.py`, `adversary.py`. Outputs: the n = 10 checkpoints and both logs. Reviewed cold against `orbital-evasiveness-notes.md` §§8.8, 9.7 and this session's findings.*

## Verdict up front

The pipeline is in better shape than the arithmetic side was. The GAP layer is **sound**, the order matrix **verifies clean**, and the χ machinery **already subsumes** the fixed-complex criterion of §9.7 rather than needing to be extended by it. Two defects are worth acting on: one is a genuine correctness bug in `adversary.py` that can produce a wrong verdict in the dangerous direction, and one is a latent unsoundness in `ark_intersect.py` that will bite at n = 12.

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

Since `consume_gap.py` carries the tag as an opaque string and never splits on `"+"`, nothing currently consumes it — and no group in the n = 10 battery has a multi-prime tag (tags are `0`, `2`, `3`, `P2`, `P3`, `P5`, `P7`). This is latent, and it fires at n = 12.

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

**The order matrix verifies clean.** V = 1,242, reflexive, 0 antisymmetry violations, 0 transitivity violations in 1,655 sampled chains, density 0.162. Combined with `consume_gap.py`'s own VF2 spot-check ("verification PASSED"), the inference layer looks trustworthy.

**The `9+1` groups are fixed-point configurations**, and keeping them is correct — a point worth recording because it cuts against the enumeration side. Part A discards fixed points, since a fixed point caps m\* at n − 1 (and indeed these have m\* = 9). But Angel–Borja's Corollary 4.3 gets a strong conclusion from exactly such a configuration at n = p^r + 1, and here they contribute catalog classes and χ constraints for free. **Fixed points are worthless for orbital annihilation and useful for the transversal/χ argument** — the GAP battery already exploits what §6 discards, which is the cleanest illustration of why the two halves of the framework want different groups.

**The log records a selection change mid-run** (`stage 1: SELECTION CHANGED -> rebuilding all downstream checkpoints`, 23:08:06) after a partial resume at 22:16 had already extended the catalog from 428 to 992 classes under the *old* selection. The rebuild did the right thing. But it is worth noting that the 22:16 run's stage-2 output (992 classes) and the 23:08 rebuild's (1,242) differ for the same 75 groups, because the resumed run inherited a catalog built from 57. The signature check caught it. That is the checkpoint discipline working as designed, and it is the reason to keep it.

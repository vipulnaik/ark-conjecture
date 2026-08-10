# The 3-uniform case: what transfers, what inverts, and what k = 2 was relying on

*Companion to `enumeration-proof.md` and `arithmetic-of-density.md`. Works the Oliver-group machinery at k = 3 — properties of 3-uniform hypergraphs on n vertices — both for its own sake and as a fresh-eyes pass over the k = 2 programme in a setting where the answers are not already known. Nothing here is load-bearing for k = 2; where it contradicts a k = 2 document, the k = 2 document is right about k = 2 and this one is describing a different problem.*

**Status of everything below.** The orbit law of §2 is verified exhaustively over 32 (c, d) pairs and proved modulo one routine step. The shape-ranking claims of §4 are **empirical over small cases** (n ≤ 52) and are not proved. The adaptation notes of §6 are a reading of the k = 2 proofs, not a rewrite. Treat this as a design document.

---

## 1. What transfers verbatim

**The criterion.** Nothing in Oliver's theorem or in the χ argument is 2-specific. For Γ an Oliver chain group acting on [n] and P a nontrivial monotone Γ-invariant property of 3-uniform hypergraphs, non-evasiveness still forces χ((P)_Γ) ≡ 1 (mod q), with χ = 1 exactly when the top layer is trivial. The fixed complex is indexed by unions of **Γ-orbits on 3-subsets** rather than on pairs, so the computation is still 2^t over t orbits and `chi_test.py` needs one line changed.

**The group theory.** Parts A, B, B′, C, D and D2 of `enumeration-proof.md` are statements about *which groups exist* and about their block structure. None mentions pairs. They transfer unchanged, and so does the shape space: chain primes (p, q), orbits, matching and foreign blocks, fusion counts F = F_mid·F_top, the cyclic-layer coprimality budget.

**The sandwich.** B_refined ≤ μ₃ ≤ B_safe has the same shape, with the same reasons, once the scoring function is replaced.

**So the whole apparatus up to the scoring function is k-agnostic.** That is worth knowing in itself: it locates everything k-specific in one place.

## 2. The orbit law at k = 3

Everything k-specific lives in the analogue of `orb(c, d)` — the minimum size of a Γ-orbit on 3-subsets inside a single block of size c carrying a twist of order d.

> **Orbit law (k = 3).** For a block of prime size c with cyclic twist of order d | c − 1, acting as x ↦ ζx on 𝔽_c together with translations,
>
> **orb₃(c, d) = min( c·d / κ , C(c,3) )**, where **κ = 3 if 3 | d, else 2 if 2 | d, else 1.**

*Why.* The translations act freely on 3-subsets up to the choice of "base point", contributing a factor c. The stabiliser of a 3-set inside the twist ⟨ζ⟩ is a cyclic group of order m acting on the 3-set with all orbits of equal size, so m | 3 and m | d; the largest stabiliser available is therefore the largest m ≤ 3 dividing d. Orbit size is c·d/m, minimised by taking m as large as possible. ∎ *(The step needing care is that a stabiliser of order m forces the 3-set to be a union of ⟨ζ^{d/m}⟩-orbits, which at m = 3 means {x, ζ'x, ζ'²x} for ζ' of order 3 and at m = 2 means a set containing an antipodal pair.)*

**Verified exhaustively** over every (c, d) with c ∈ {5, 7, 11, 13, 17, 19, 23} and d | c − 1 — **32 of 32 agree**, including both the C(c,3) cap at small c and the three κ regimes.

> **The general shape, which is the useful statement.** Writing κ_k(d) = max{ m ≤ k : m | d }, one gets **orb_k(c, d) = min(c·d/κ_k(d), C(c,k))**, and the familiar k = 2 law orb(c, d) = min(cd/2 if 2 | d else cd, C(c,2)) is the case k = 2. So the twist buys a factor d, and the *only* thing k changes is how much of that factor the stabiliser can give back — at most a factor k, and only when k | d.

**This is the whole reason the density collapses.** orb_k ≤ c·d/κ ≤ c(c−1)/k, which is Θ(c²) whatever k is, while C(c,k) ~ c^k/k!. The numerator does not grow with k; the denominator does.

## 3. Why the constant-density apparatus dies, and it is not an artefact

Every orbit has size at most |Γ|, so m\*_k ≥ δ·C(n,k) needs |Γ| ≳ δn^k/k!. Our blocks sit inside AΓL(1, c), of order at most c² log c. Against C(c,3) that is a density of O(log c / c) → 0.

**The structural reason is sharper.** The k = 2 constants exist because AGL(1, c) is **2-transitive**: one orbital of size C(c,2), giving full density on a block, which is what makes δ = 1/4 reachable at all. The k = 3 analogue would need 3-transitivity — and

> **there are no solvable 3-transitive groups of degree > 4.**

The 3-transitive affine groups are AGL(d, 2); GL(d, 2) is simple for d ≥ 3, so those are not solvable, and d = 2 gives AGL(2,2) ≅ S₄ at degree 4. Oliver chain groups are solvable by construction. **So the mechanism k = 2 depends on is excluded at k ≥ 3, not merely unfound.**

*Consequence for `arithmetic-of-density.md`:* §3's mod-24 ceilings, the cap_F(η) optimisation and the balance points are a **k = 2 phenomenon resting on a group-theoretic accident** — that solvable 2-transitive groups exist at every prime power. They are not a general feature of the method. One sentence saying so belongs in §3.

## 4. The shape ranking inverts, and this is the interesting part

At k = 2, fusion is the whole game — S2 reaches δ = 1/4 — and prime-power blocks are unremarkable. At k = 3, **both are actively bad**, for reasons that are the exact analogues of things the k = 2 documents already know:

**Fusion is poison.** F fused blocks of size c admit *same-position triples* {(b₁,x), (b₂,x), (b₃,x)}: the diagonal translation moves all three together, so the class has size (block-triple orbital) × c, at most C(F,3)·c. Measured: n = 35 as `5x7` gives 70 = C(5,3)·7, i.e. Θ(n), against 253 for an unfused two-block configuration at n = 52. **This is Lemma D2's offset-0 class one dimension up** — the same mechanism that forbids fusing *foreign* blocks at k = 2 now penalises fusing *matching* ones at k = 3.

**Prime-power blocks are poison.** In a block of size p^a with a ≥ 2 the additive group has subgroups of order p, so at p = 3 the twelve affine lines {a, a+d, a+2d} of AG(2,3) form a single orbit of size 12 = Θ(n). Measured: n = 26 as `9 + 17*` gives 12. At prime c no 3-term additive structure exists.

**So the optimum at k = 3 is unfused, two blocks, both of prime size** — and the arithmetic requirement *relaxes* accordingly, from "prime powers with a coprimality budget" to **n = p + r with both prime**, which is binary Goldbach. Balanced blocks maximise:

> **μ₃(n) ≳ n²/8**, and ≳ **n²/12** in the worst case where both blocks are ≡ 1 (mod 3), since κ = 3 there.

*Measured, both blocks prime, full twists:*

| n | configuration | min on 3-sets | closed form |
|---|---|---|---|
| 24 | 11 + 13\* | 52 | 13·12/3 |
| 30 | 13 + 17\* | 52 | 13·12/3 |
| 36 | 17 + 19\* | 114 | 19·18/3 |
| 42 | 19 + 23\* | 114 | 19·18/3 |
| 52 | 23 + 29\* | 253 | 23·22/2 |

**Caveat, and it is not small.** "Two prime blocks is optimal" is empirical over n ≤ 52 and is *not* proved. Three-block and mixed shapes have not been enumerated. This is exactly the kind of claim that in the k = 2 programme has been wrong twice.

## 5. What the k = 3 statement buys

The dimension-threshold reading survives even though the density does not:

> **Any nontrivial monotone 3-uniform property all of whose members have fewer than ~n²/8 edges is fully evasive**, for n a sum of two roughly equal primes.

That rules out every sparse property — the same service BBKN's Ω(n log n) performs at k = 2, and the same reason it is worth having despite being o(C(n,k)). It is a different quantity from Black's weak evasiveness, which bounds queries without producing a threshold, so the two do not compete.

*Quantifier:* it inherits Goldbach's, so **almost all n unconditionally**, rather than all n. That is stronger than the k = 2 supply situation, not weaker, because prime powers are no longer needed.

## 6. Adapting the proofs, part by part

| part of `enumeration-proof.md` | at k = 3 |
|---|---|
| **Part 0** (shape space) | **unchanged**; the picture proof's step 1 and step 2 are about chunks and blocks, not pairs |
| **Part A** (orbits and crosses) | **restructured**: a 3-set meets the chunks in a partition of 3, so there are *three* term types (3+0+0, 2+1+0, 1+1+1) rather than two. The min is still over term types |
| **Part B, B′** (per-orbit classification) | **unchanged** — statements about blocks |
| **Part C** (valency recursion) | **needs redoing**: the counting bound B₀ is pair-specific; the analogue would bound μ₃ by a partition-only quantity, and the two-part reduction would need re-verifying |
| **Part D, D2** | **unchanged as stated**, but D2 acquires a k = 3 analogue for *matching* blocks (§4 above), which at k = 2 has no counterpart |
| **Part E** (value formula) | **replace orb by orb₃** and add the 1+1+1 cross term Fᵢcᵢ·Fⱼcⱼ·F_lc_l. The within-class cross term splits into more cases: 2-in-one-block-1-in-another, and same-position triples |
| **Part E′, E″** (collapse) | **structure survives**; the fallback question is still whether Lemma C's strip changes the optimum, and the certificate's conditions have direct analogues with orb₃ |
| **Part F** (search is bounded) | **easier**: the feasibility criterion tightens because orb₃ ≤ c²/3 caps each part harder |
| **Part G** (nested towers) | **unchanged** |
| **`aod` §3** (ceilings) | **does not transfer** — see §3 above |
| **`aod` §3.5–3.6** (supply) | **simplifies**: binary Goldbach replaces the prime-power systems; the shifted-prime ladder becomes irrelevant, since the twist no longer needs a large prime-power divisor to reach constant efficiency — it cannot reach it anyway |
| **`aod` §6** (finite shape space) | **transfers with different constants**; the feasibility criterion needs re-deriving from orb₃ |

## 7. What this says about k = 2, read backwards

The exercise was partly a fresh-eyes pass, and three things about the k = 2 programme look different from here.

1. **The constants are contingent, not structural.** δ = 1/4, the mod-24 ceilings, the balance points — all of it exists because solvable 2-transitive groups happen to exist at every prime power. That is a fact about the classification of solvable 2-transitive groups, not about evasiveness. `aod` §3 currently reads as though the optimisation is the heart of the method; it is more accurate to say the optimisation is what you get to do *once* 2-transitivity has handed you a full-density block.
2. **Fusion and prime-power blocks are k = 2 luxuries.** Both are penalised at k = 3 by mechanisms the k = 2 documents already contain in another guise — D2's offset-0 class, and the additive subgroup structure that Lemma C's a > 1 case worries about. That the same two structures reappear as the *obstructions* one dimension up is a hint that they are the load-bearing features of the whole setup, and worth watching in k = 2 too.
3. **The arithmetic difficulty is not intrinsic to the method.** At k = 3 the supply question collapses to binary Goldbach, unconditionally almost-all. The prime-power-with-coprimality-budget difficulty of `aod` §3.5 is the price of chasing constant density — which is to say, the price of exploiting 2-transitivity. Drop the constant and the number theory becomes easy. That reframes what `aod` §§3–6 are *for*.

## 8. Open, if anyone takes this further

1. **Prove the shape ranking**, or find a counterexample. Three-block and mixed configurations at k = 3 are unenumerated, and "two prime blocks is optimal" rests on n ≤ 52.
2. **Prove the orbit law's stabiliser step** properly rather than modulo the routine argument in §2.
3. **Redo Part C** — the partition-only bound and its two-part reduction are the only genuinely pair-specific piece of the structural chain.
4. **Decide whether the threshold statement is new.** Black's framework does not produce dimension thresholds, and no other k ≥ 3 work found so far does; but the k = 2 literature is deep enough that a threshold statement may exist in some form.
5. **k ≥ 4.** The orbit law generalises (κ_k(d) = max{m ≤ k : m | d}), so the same analysis runs; the threshold degrades to Θ(n²) against C(n,k) throughout, and the shape ranking presumably inverts further.

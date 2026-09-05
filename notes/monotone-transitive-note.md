# Monotone transitive Boolean functions: what the framework buys, and what it does not

*Companion to `orbital-evasiveness-notes.md`. The k-uniform documents move along the arity axis; this one moves off it entirely, to nontrivial monotone Boolean functions on N coordinates invariant under a transitive group. That setting contains all the k-uniform cases (a k-graph property is the case N = C(n,k) with Γ = Sₙ acting on k-sets), so it is the natural ceiling of the programme.*

**The short answer, stated first because it is negative and the reasons are the interesting part.** The μ(n) apparatus contributes **almost nothing** to the general transitive case, and the reason is structural rather than a matter of the bounds being weak: in the general setting the group acts on the coordinates directly, so transitivity is available where the graph case only ever gets vertex-transitivity, and the Oliver argument closes at its very first rung without any of the machinery. What the framework does contribute is a *localisation of the difficulty* — a computable criterion picking out exactly the groups where the argument fails, and a scan finding the first of them.

**Status.**

| section | standing |
|---|---|
| §1 the criterion | **proved**; it is one paragraph, and essentially KSS's argument stated for general Γ |
| §2 why μ(n) does not transfer | **proved** |
| §3 the scan | **computed**, degrees 4–14, with an insoluble residue recorded |
| §4 T(12,162) | **computed** |
| §5 what this says about graph properties | commentary |
| §6 the counterexample programme | a proposal |

---

## 1. The criterion, and it closes at t = 1

Let P be a nontrivial monotone decreasing property of subsets of an N-element coordinate set, Δ_P its simplicial complex, and Γ ≤ S_N a group preserving P.

> **Proposition 1.** If Γ contains a **transitive** Oliver subgroup H, then P is evasive.

*Proof.* Suppose not. Non-evasive ⟹ Δ_P collapsible ⟹ ℤ-acyclic, and H acts on it. The H-invariant subsets of the coordinates are unions of H-orbits, and H is transitive, so they are exactly ∅ and the whole set. The whole set is not in P (nontriviality) and ∅ is, so **Δ_P^H = {∅}**, the complex with no vertices, of Euler characteristic **0**. Oliver's theorem for an H that is p-by-cyclic-by-q forces χ(Δ_P^H) ≡ 1 (mod q), and 0 ≡ 1 (mod q) is false for every prime q — and false outright in the trivial-top case, where the congruence collapses to χ = 1. ∎

Three corollaries, each a one-line check on Γ:

- **A regular cyclic subgroup suffices.** C_N is cyclic, hence Oliver with Γ₂ = 1 and a trivial top. So any Γ containing an N-cycle is done.
- **A transitive Sylow subgroup suffices**, a p-group being Oliver with Γ₁ = Γ₂ = itself.
- **Prime-power N is done**, via the regular elementary abelian subgroup of AGL(1, N) — which is KSS's theorem, recovered as the special case where the Sylow route fires.

> **This is the t = 1 row of `small-degree-computation.md` §2.4**, which says that with one orbital *nothing survives*. There it is a row in a table about fixed complexes; here it is the entire theory. The difference is that in the graph setting t = 1 requires a 2-homogeneous group and so is available only at prime powers, whereas here t = 1 *is* transitivity, which is the hypothesis.

---

## 2. Why μ(n) does not transfer, and what that says about its role

The framework's central quantity is m\*(Γ) = the minimum size of a Γ-orbital, i.e. of a Γ-orbit on **pairs** of vertices — and δ = m\*/C(n,2). Its analogue here is the minimum Γ-orbit on **coordinates**, and for transitive Γ that is N: the whole thing, in one orbit.

So the general-transitive analogue of the density is δ = 1, at every N and every transitive Γ — the maximum possible — and by Proposition 1 the conclusion follows immediately with no optimisation, no shape space, no ceilings and no arithmetic. **Every part of the apparatus is machinery for the case t ≥ 2, and the general setting does not have that case.**

> **Which locates precisely what the graph setting costs, and it is worth stating as the framework's own explanation of itself.** For a graph property the group acts on **vertices**, while the coordinates are **pairs**. A vertex-transitive group is therefore *not* coordinate-transitive: its induced action on pairs has one orbit only when it is 2-homogeneous, which for solvable groups forces prime-power degree (`solvable-relaxation.md` §1). At every composite non-prime-power n the pair action has t ≥ 2 orbits, Δ_P^Γ acquires vertices, and the χ condition stops being a contradiction and becomes a constraint that a real property can satisfy — which is exactly `small-degree-computation.md` §7.4's finding that the two-orbital criterion "sharpens but does not close".
>
> **So the whole δ apparatus is the price of the induced action.** μ(n) is measuring how close a vertex action can come to being coordinate-transitive, and the mod-12 ceilings are the arithmetic of how close that is. Nothing analogous arises when the action is on the coordinates to begin with.

**The one thing that does transfer is the negative result about escalation.** `small-degree-computation.md` §7.1's one-sidedness diagnosis — every χ condition and every monotone propagation pushes coordinates *into* P, and the only OUT-generator in the whole system is nontriviality — is a statement about the constraint system and not about graphs. It applies verbatim to any CSP over a general Boolean property, and it predicts that at a group where Proposition 1 fails, adding more groups to a battery will not produce UNSAT either.

---

## 3. Where Proposition 1 fails: a scan of the transitive groups

Before computing anything, one whole family of degrees is settled outright, and it explains the shape of the table below.

> **Proposition 2 (prime-power degrees).** Every transitive group of prime-power degree contains a transitive Oliver subgroup — indeed a Sylow subgroup is one. Hence every nontrivial monotone weakly-symmetric property on p^a coordinates is evasive.
>
> *Proof.* Let G be transitive of degree n = p^a with point stabiliser G_x, and let P be a Sylow p-subgroup, |P| = p^b. From [G : G_x] = p^a we get v_p(|G_x|) = b − a, and P ∩ G_x is a p-subgroup of G_x, so |P ∩ G_x| ≤ p^{b−a}. Then
>
> |P·G_x| = |P|·|G_x| / |P ∩ G_x| ≥ p^b·|G_x| / p^{b−a} = p^a·|G_x| = |G|,
>
> so **P·G_x = G** and the P-orbit of x has size [P : P ∩ G_x] = p^a — all of it. A p-group is Oliver with Γ₂ = itself and both quotients trivial, so Proposition 1 applies. ∎
>
> **At prime degree this is just Cauchy's theorem**, and prettier for it: transitivity forces p | |G|, Cauchy gives an element of order p, and on p points such an element has all cycles of length 1 or p, hence is a single p-cycle — regular, transitive, cyclic, Oliver.
>
> *Attribution.* The prime-power case is due to **Rivest and Vuillemin**, in the paper that introduced the conjecture; whether they argued via Sylow or by an equivalent route is not checked here.

**This is why the scan below finds nothing at 4, 5, 7, 8, 9, 11, 13 — those are exactly the prime powers in range** — and why every failure and every unresolved case sits at 6, 10, 12, 14, the composite non-prime-powers. The empirical zero column is a theorem, not a measurement.

> **A sharpening, from a population run done for a different purpose** (`oliver_negative.g`, R6 item 1 of `pending-checks.md`). Testing every transitive group of degrees 6–11 for whether **it** is Oliver — as opposed to whether it *contains* a transitive Oliver subgroup — gives 108 Oliver against 52 not, and **eleven of the failures are solvable**: four at degree 8 and seven at degree 9. Both are prime powers, so by Proposition 2 those degrees are settled outright and no property invariant under any of those eleven groups can be a counterexample. **The gap between the two questions is therefore not cosmetic**: a group can fail the chain condition itself while the Sylow subgroup inside it satisfies it, and it is the subgroup that decides evasiveness. This is the same distinction §5 draws for Sₙ — the criterion needs a transitive Oliver *subgroup*, not an Oliver group — instantiated at small degree where it can be counted.

> **Which is a structural echo of the graph case worth pausing on.** In the S_n world μ(n) = C(n,2) exactly at prime powers, because AGL(1, p^a) is 2-homogeneous, and the entire δ apparatus exists to handle composite non-prime-power n. Here the same dividing line appears for a different but analogous reason — a Sylow subgroup is transitive when the degree is a prime power, and nothing substitutes otherwise. **Both settings are measuring how far a degree is from being a prime power**, one through orbitals on pairs and the other through orbits on coordinates.

With that family removed, Proposition 1 turns what remains into a finite group-theoretic question that can simply be computed:

> **For which transitive Γ ≤ S_N is there no transitive Oliver subgroup?**

Those groups are the *only* possible homes for a counterexample, since every other transitive group settles its properties outright. The scan (`oliver_transitive_scan.g`): for each transitive group of each degree, test G itself; then look for an N-cycle; then for a transitive Sylow subgroup; then, for solvable G, walk the full subgroup lattice.

| degree | # transitive | **proved: no transitive Oliver subgroup** | still unresolved |
|---|---|---|---|
| 4, 5 | 5, 5 | 0 | 0 |
| 6 | 16 | 0 | 0 |
| 7 | 7 | 0 | 0 |
| 8 | 50 | 0 | 0 |
| 9 | 34 | 0 | 0 |
| **10** | 45 | 0 | **4** — T(10, 7), (10, 26), (10, 31), (10, 44) |
| 11 | 8 | 0 | 0 |
| **12** | **301** | **1 — T(12,162)** | **1** — T(12, 295) = M₁₂ |
| 13 | 9 | 0 | 0 |
| **14** | 63 | 0 | **3** — T(14, 10), (14, 30), (14, 54) |

**Revised after resolving the almost-simple cases.** Two of the nine were settled by an explicit construction rather than by search (below), and one of the four at degree 10 turned out to be a genuine failure, so the corrected picture is:

| degree | failing groups |
|---|---|
| 4–9, 11, 13 | **none** |
| **10** | **T(10,7) = A₅ acting on the 10 pairs of {1..5}** |
| **12** | **T(12,162)** |
| still open | A₆ and S₆ on 10 points; M₁₂; PSL(3,2) and PSL(2,13) and one order-322,560 group at degree 14 |

> **The construction that resolves A₁₀ and A₁₄, due to Vipul.** At degree 2p with p an odd prime, take the p blocks {1,2}, …, {2p−1, 2p}, the **index-2 subgroup of (C₂)^p generated by the products of evenly many of the p transpositions**, and extend it by a p-cycle permuting the blocks diagonally. The result has order **2^{p−1}·p**, is transitive, lies **inside A₂ₚ** (every generator is even), and is Oliver with Γ₂ = (C₂)^{p−1} normal and cyclic quotient C_p — a trivial top. Verified at p = 2, 3, 5, 7, 11; at p = 2 it is exactly the Klein four-group inside A₄. So **A₂ₚ contains a transitive Oliver subgroup for every odd prime p**, which settles T(10,44) and T(14,62) and any transitive group containing them.
>
> **And the same line of checking exposed a failure the first scan had hidden in its unresolved column.** A₅ on the 10 pairs is transitive, and its **only** transitive subgroup is itself (checked exhaustively over 2-generated subgroups): D₁₀ has two orbits on pairs, A₄ has orbits 4 and 6. A₅ is insoluble, so there is no transitive Oliver subgroup, and **degree 10 fails as well as degree 12.** The contrast with S₅ is sharp and instructive: S₅ on pairs *does* contain one — F₂₀ = C₅⋊C₄ is transitive on the 10 pairs and is Oliver with top q = 2 — which is consistent with KSS at the prime power 5. The gap is exactly the properties invariant under A₅ but not under S₅.

**Degree 10 is the first failure and degree 12 the second** — A₅ on the 10 pairs, and one group out of 301 at degree 12. Degrees 4–9, 11 and 13 are settled completely: every transitive group there contains a transitive Oliver subgroup, so every nontrivial monotone invariant property at those degrees is evasive.

*All of them sit at non-prime-power degrees, as Proposition 2 requires* — so none can be settled by Sylow theory, and any transitive Oliver subgroup there has to come from a genuine construction, like the degree-2p one below, rather than from a counting argument.

*On the unresolved column, which turned out more interesting than expected.* The solvable groups are all resolved by the lattice route. What remains is nine **almost-simple** groups where GAP's lattice route needs the SmallGroups identification (absent here), and where a randomised search over subgroups generated by up to three random elements failed after 3,000 trials each:

> **What the A₅ row is, in the other notation.** A₅ acting on the 10 pairs of {1..5} is exactly the invariance group of a **chiral graph property on 5 vertices** (`chiral-graph-properties.md` §1): a monotone A₅-invariant family of subsets of E(K₅). So §6 item 3's exhaustive search there — 3,176 invariant monotone properties, 112 with χ = 1, **0 non-evasive** — is a complete verification of the chiral analogue of ARK at n = 5, which is the smallest n where the chiral world's natural group (AGL(1, 5)) falls outside A₅ and so the first place a chiral counterexample could have lived. It is also the group behind that note's ℝP² candidate, which the search rules out. **The chiral frontier is therefore n = 13**, and this scan is where the n = 5 case was actually decided.

> A₅ and A₆ and S₆ on 10 points (orders 60, 360, 720), **A₁₀** (1,814,400); **M₁₂** (95,040) on 12 points; PSL(3,2) and PSL(2,13) on 14 points (168, 1,092), one of order 322,560, and **A₁₄**.
>
> Of those nine, **three are now settled**: A₁₀ and A₁₄ contain the degree-2p group constructed above, and A₅ on 10 points is a genuine *failure* rather than an unresolved case. **Six remain open**, and the table above is stated after that revision.

**The naive expectation — that big insoluble groups are rich enough to contain a transitive Oliver subgroup — is not obviously right, and the 10-cycle is why.** An Oliver group is solvable, so what is needed is a transitive *solvable* subgroup carrying the chain. On 10 points the natural candidate is the regular C₁₀ — but a 10-cycle is an **odd** permutation and lies outside A₁₀. **A₁₀ and A₁₄ are nonetheless settled**, by the degree-2p construction of the box above, which supplies a transitive Oliver subgroup inside A₂ₚ without using a 2p-cycle. **Six remain genuinely open** — A₆ and S₆ on 10 points, M₁₂, and PSL(3,2), PSL(2,13) and the order-322,560 group at degree 14 — and a failed randomised search is weak evidence for "no" rather than any evidence for "yes"; resolving them properly is item 1 of §6.

---

## 4. T(12,162)

| | |
|---|---|
| order | 576 |
| solvable | yes |
| point stabiliser | order 48 |
| derived series | 576 ▷ 144 ▷ 16 ▷ 1 |
| block systems | blocks of size 6 and of size 2 |
| element orders | 1, 2, 3, 4, 6, 8 — **no element of order 12** |
| transitive Sylow subgroup | none (neither p = 2 nor p = 3) |
| **transitive subgroups** | **exactly one: G itself** |
| G Oliver? | **no** |

The last two rows are the sharp statement, and they are stronger than the scan's criterion required: **G is minimal transitive and is not itself an Oliver group.** So the failure is not that some transitive subgroup was missed — there are none to miss. Every route into Proposition 1 is closed at once, and closed for a single reason.

> **What Illies (1978) does and does not give, since the citation is routinely misread.** Illies is often quoted as supplying a non-evasive *monotone* transitive Boolean function on 12 variables, which would make degree 12 the known home of a counterexample. **That reading is wrong, and the error matters because it inverts the status of the whole question.**
>
> Rivest and Vuillemin's original conjecture asked only that f be **weakly symmetric** (invariant under a transitive group) with f(∅) = f(X) — *monotonicity was not assumed*. **Illies's counterexample refutes that version**, and Aigner subsequently repaired the conjecture by *adding* monotonicity. Kahn–Saks–Sturtevant say so explicitly: "they proposed a somewhat stronger version … in which monotonicity was replaced by the weaker condition: F contains exactly one of ∅, X; a counterexample to this was provided by Illies." There is also an infinite family of counterexamples to the set-system version, of which Illies's is the smallest member.
>
> **So the monotone weakly-symmetric conjecture — the one this note is about — is open, not false.** It is verified for n ≤ 14 in the literature (there is a recent paper settling n = 14 specifically). Degree 12 therefore has no special status coming from Illies, and the scan's identification of T(12,162) stands on its own group-theoretic footing rather than being corroborated by a known example.
>
> **The exhaustive searches below are consistent with that**, and would have been in tension with the mistaken reading: they find no non-evasive monotone invariant property at either candidate group. Under the wrong version of the literature that would have been a contradiction demanding a bug hunt; under the right one it is a reproduction of a known theorem, and so a validation of the pipeline.

---

## 5. What this sharpens about graph properties

What makes graph properties different is the question this section answers, and the scan gives a sharper answer than "the group is bigger".

**The criterion fails as early as it possibly can — and where it fails, the conjecture itself remains open, not false (§4).** Degrees 4 through 9, 11 and 13 admit no failure at all — every transitive group there contains a transitive Oliver subgroup, so every nontrivial monotone invariant property at those degrees is evasive, unconditionally and without any of this framework. Degree 6 being clean, the earliest a failure could occur is 10, and it does: **T(10,7) = A₅ on pairs**, with **T(12,162)** the second — and, subject to the six still-open almost-simple cases at degrees 10, 12 and 14, the only two through degree 14. A failure of the criterion is an open door, not a counterexample: the literature verifies the monotone weakly-symmetric conjecture through n = 14 (§4), and the exhaustive searches of §6 reproduce that at both failing groups.

**The graph case is not a sub-case of the general one where the group happens to be large; it is a case where the group acts on the wrong set.** For a graph property on n vertices the coordinate set is the C(n,2) pairs and the group is Sₙ acting through the induced action, which is *never* transitive on coordinates for n ≥ 2... except that it is: **Sₙ is transitive on pairs**. So Proposition 1 applies with Γ = Sₙ, and every Sₙ-invariant monotone property — i.e. every graph property — would be evasive.

> **That cannot be right, and finding the error is the content of this section.** The step that fails is the identification of the relevant group. A graph *property* is Sₙ-invariant, and Sₙ *is* transitive on the C(n,2) coordinates, so Proposition 1 appears to prove ARK outright. The resolution is that Oliver's theorem requires an Oliver **group**, and Sₙ is not one for n ≥ 5 — it is not even solvable. The criterion needs a transitive Oliver *subgroup* of Sₙ *acting on the pairs*, and a subgroup of Sₙ that is transitive on pairs is precisely a 2-homogeneous group, which for solvable groups forces prime-power degree. **So the graph case is exactly the general case, and the entire difficulty is that the 2-homogeneity requirement is far more demanding than transitivity on n points.**
>
> This is the cleanest statement of the difference available, and it reframes the whole programme: **μ(n) is what one falls back on when no transitive Oliver subgroup exists on the coordinate set.** *(It also closes the question of whether a different statistic would serve better: the t = 1 case is settled without any statistic, and in the t ≥ 2 case the fixed-point argument consumes the minimum orbital itself, so no coarser invariant suffices and no finer one is available. μ(n) is not a modelling choice.)* At prime powers one does exist — AGL(1, p^k) is 2-homogeneous on pairs — and KSS follows from Proposition 1 directly. At every other n none exists, t ≥ 2, and the δ machinery is the substitute.

**And it explains why the general case is *not* the place to look for leverage.** Ω(n²) is the ceiling of the k-uniform results at every arity (`general-k-note.md` §5), and the general Boolean setting has no ambient structure at all to trade for a better constant. The needle does not move there, as expected.

---

## 6. The counterexample programme, which is where the value is

If the object of the exercise is to sharpen what distinguishes graph properties, the scan suggests a concrete and cheap programme.

0. **Test only MINIMAL transitive groups — the rest are settled by inclusion.** If H ≤ G are both transitive on X, every G-invariant family is H-invariant, so if every nontrivial monotone H-invariant family is evasive, so is every G-invariant one. Hence the census needs only the *minimal* transitive groups that are not Oliver; any transitive group containing one is settled once it is. **This closes item 1 without computation:** A₆ and S₆ on 10 points contain A₅ acting transitively on the same 10 points (the point-stabiliser A₅ ≤ A₆ permutes the ten 3+3 partitions of six points as A₅ on pairs of five), and item 3's exhaustive scan at A₅ found nothing.

   *The same argument makes the regular action universal.* Given a G-invariant nonevasive complex on a transitive G-set G/K, pull it back along g ↦ gK to the regular G-set: each vertex becomes a simplex on its fibre, duplicated vertices are dominated by their twins, and removing a dominated vertex is a strong collapse, which preserves nonevasiveness in both directions. So a counterexample for *any* transitive action of G yields one for G acting on itself, and the cleanest form of the question is: **does some non-Oliver G admit a left-translation-invariant nonevasive down-set on G?** Cleaner still, since Proposition 1 disposes of every Oliver group: **does there exist a vertex-transitive nonevasive simplicial complex with more than one vertex?** No group need be chosen in advance.

1. **Close the six remaining almost-simple cases, then extend the scan.** *(Superseded at degree 10 by item 0; the extension to degree 20 should list minimal transitive non-Oliver groups only.)* The right tool is not the subgroup lattice but the transitive-groups library itself: a transitive Oliver subgroup of G is in particular a transitive group of that degree which is solvable and Oliver, so enumerate *those* first (a short list per degree — they are the entries the scan already classifies) and test each for embedding in G. That is a small computation and it decides the cases rather than merely failing to find. **A₆ and S₆ on 10 points are the ones to do first**, being the smallest and the only remaining cases at the first failing degree. (A₁₀ and A₁₄, which an earlier form of this item named, are settled by the degree-2p construction of §3; and the first failing degree is already 10, via A₅.) Then extend to degree 20; the output is a list of candidate degrees with a short list of groups at each.
2. **Identify Illies's invariance group** against the 1978 source — as history, not as validation. Since Illies's function is **not monotone** (§4's correction), Proposition 1 says nothing about it: a non-monotone property has no monotone complex for Oliver's theorem to act on, so its invariance group may perfectly well contain a transitive Oliver subgroup with no contradiction anywhere. The identification is still worth one look — if the group turns out to be T(12,162) or another criterion-failing group, that would suggest invariant structure is cheapest exactly there — but **no outcome bears on the scan's correctness**, and the earlier framing of this item as a potential contradiction with Proposition 1 predates §4's correction.
3. ~~Run the CSP at T(12,162).~~ **Done, and at both candidate groups — no counterexample at either.**

   | group | orbits on subsets | nontrivial invariant monotone properties | χ(Δ_P) = 1 | **non-evasive** |
   |---|---|---|---|---|
   | A₅ on 10 pairs | 40 | 3,176 | 112 | **0** |
   | T(12,162) | 66 | 77,819 | 336 | **0** |

   Both are exhaustive over the invariant monotone properties, with evasiveness decided exactly by the standard recursion rather than by any χ screen. Since non-evasive ⟹ ℤ-acyclic ⟹ χ = 1, testing the χ = 1 class suffices, and the T(12,162) row is reported that way.

   > **A trap worth recording, because it nearly produced a false positive.** The recursion is "non-evasive on a subcube iff constant there, or some variable splits it into two non-evasive halves", and *the base case must come first*: with no free variables D = 0, which is **not** less than 0, so a fully-queried subcube is evasive by convention. Testing constancy first returns True at every leaf and the True propagates to the root, reporting **every** function non-evasive — which is exactly what the first run of this search did, returning 336 of 336. The tell was the implausibility of the aggregate, not a control; controls (P = {∅} evasive, a one-variable function non-evasive, |S| ≤ 1 evasive) were added afterwards and pass. This is `small-degree-computation.md` §1.2's asymmetry in its sharpest form: dropping constraints turns a real UNSAT into a spurious SAT.

3a. **A₅ on 15 points — the smallest open degree, and where the acyclicity rung stops.** With n ≤ 14 verified in the literature (§4), degree 15 is the frontier, and by item 0 it reduces to the minimal transitive non-Oliver groups there — A₅ in its unique 15-point action (cosets of C₂², equivalently pairs of the 6-point PSL(2,5) action), provided the census confirms nothing else is minimal at that degree. `a5_on_15.py` applies every fixed-complex condition available: all proper subgroups of A₅ are Oliver, so Smith 𝔽_p-acyclicity at C₂, C₃, C₂², C₅ and χ ≡ 1 (mod q) at S₃, D₁₀, A₄, on the 254 of 688 subset-orbits that some subgroup fixes; plus χ(link v) ≡ 1 (mod 4), which the 434 free orbits (trivial stabiliser, size 60, contributing ±4k to the link) cannot repair. **The acyclicity rung is SAT**, with hundreds of touched-part solutions and the free part unconstrained — `small-degree-computation.md` §7's one-sidedness, one degree up. The completions tuned to χ = χ(link) = 1 and tested exactly (decision-tree recursion on 2¹⁵ subsets, 0.3 s each) were evasive; a sample, not a verdict. **But their actual homology was computed** — via Alexander duality, the dual complex having 1,151 faces — and every one is **ℚ-acyclic, acyclic mod 3, 5 and 7, and has 𝔽₂-homology of rank 4**: not ℤ-acyclic, with 2-torsion. That is one rung above where graph properties at n = 10 stand (χ = 1 with fixed-complex consequences, ℤ-acyclicity uncheckable at 12 million classes) and the same rung the chiral n = 5 candidate reached (ℝP²-like, ℤ/2). So the transitive world is where the metaproperty ladder has been climbed highest — by one rung — which is a statement about what is *computable* at 15 points, not yet about what exists. *(The apparent mod-60 constraint on χ(Δ) from the free orbits is redundant: Smith at the Sylow subgroups already forces χ ≡ 1 mod 3, 4, 5 by the Burnside congruences.)*

   **So n = 15 is open and not decidable by fixed-point methods.** Deciding it means climbing the ladder: non-evasiveness is checkable exactly per candidate but the candidate space is 2⁴³⁴.

   **The literature check (`literature-findings.md` §§13–16) answered the structural question and reframed the target.** Barmak–Minian (DCG 2012) prove that strongly collapsible complexes have the fixed-point property for automorphisms (Thm 6.2), that the core of a vertex-homogeneous non-evasive complex is vertex-homogeneous and non-evasive (Cor. 6.13), and hence that the conjecture reduces to **minimal** complexes (no dominated vertex). On 15 vertices the core would have 3, 5 or 15 vertices and the first two are prime-power cases where the conjecture is a theorem, so **any counterexample at A₅ on 15 is itself minimal** — a cheap necessary condition, now checked (both tuned candidates are minimal, and so are their Alexander duals). And Lutz (DCG 2002) shows the ladder for vertex-homogeneous complexes already fails to collapse at ℤ-acyclic *and* contractible: the smallest known contractible vertex-homogeneous non-simplex has **60 vertices** — the regular A₅-set that item 0's inflation argument singled out — and dimension 11; whether it is collapsible, let alone non-evasive, appears untested (Benedetti–Lutz 2013 could not settle collapsibility by random Morse). **So the interesting comparison is 15 against 60, not 15 against 10**, and the strongest known candidate is a published complex nobody has run the adversary on.

   *Integer torsion, computed.* Smith normal form on the 1,151-face dual gives boundary-map torsion exactly **(ℤ/2)⁴** in one degree — the 𝔽₂-Betti rank 4 is genuine 2-torsion, not a mod-2 artefact of free classes. Consistent with Lutz 2001's bound (no ℤ-acyclic vertex-homogeneous complex of dimension ≤ 3; the dual here is 5-dimensional) and with the Sylow observation that every non-solvable group contains C₂ × C₂, making 2-torsion the cheapest way for an A₅-complex to clear every fixed-complex condition and still fail ℤ-acyclicity.

   *An attempted "small-side" search did not work, and the reason is recorded in `a5_on_15.py --small`'s help text*: the C₂ Smith condition spans 248 of 254 touched orbits and fires only at the leaf, so trying OUT first on large sets explores an exponential tree of small assignments that all fail it, while IN-first lands on near-full complexes almost immediately. A genuine small-side search needs an incremental acyclicity test on partial C₂ lattices. Meanwhile homology is computed on whichever side is smaller, so the near-full leaves already *are* the small side seen from the other end.

   **The 60-vertex Lutz complex was then tested, and it is EVASIVE — by a two-line argument, not a search** (`lutz30.py`). Its 441 published facets are exactly {a ∪ (b+30)} for a, b over one family of 21 sets on {1..30}: **it is a join K = A ∗ A′**, A being Lutz's 5-dimensional ℤ-acyclic example on 30 vertices (the A₅ action on cosets of C₂; f = (30, 195, 340, 255, 96, 15), χ = 1, 𝔽₂-acyclic, every vertex in 4 facets). By Welker (1999) a join is non-evasive iff a factor is, so K is non-evasive iff A is. And **every vertex link of A has χ = 0**, where a non-evasive complex needs a vertex with a non-evasive, hence ℤ-acyclic, hence χ = 1 link. The exact recursion confirms in 31 nodes.

   *Two lessons.* (i) **The join hides the obstruction**: for v on the A-side, lk_K(v) = lk_A(v) ∗ A′ and reduced Euler characteristics multiply under join, so χ(lk_K v) = 1 and the link test on K itself passes — one must factor first. **Check any candidate's facet set for a product structure before running anything expensive.** (ii) The real object was **30 vertices** — the third of the 15/20/30 A₅ targets — and it is the first complex in the programme to clear *every* counting condition (being ℤ-acyclic) and fail at the first non-counting one. A non-evasive vertex-homogeneous complex must have a vertex whose link is itself ℤ-acyclic; A's are not.

   **What A is, group-theoretically** (`lutzA.py`; Lutz 2002 is paywalled, so this was recovered from the facets): Aut(A) = A₅ acting on A₅/C₂ — the 30 edges of the icosahedron — and the 21 facets are **orbits of the three classes of maximal subgroups**: the 6 D₁₀'s each give a 5-set (stabiliser order 10), the 5 A₄'s each give a 6-set (stabiliser order 12), the 10 S₃'s each give a regular 6-set (stabiliser order 6). So A is an **orbit complex**: vertex set G/K, facets = G-orbits of H-orbits for subgroups H. This is exactly the shape of the Klein-group proposal above, with the maximal subgroups in place of the Sylow-2's — and it is what makes the difference between χ = −165 and ℤ-acyclic.

   **The orbit-complex search space** (`orbitcx.py`, `orbitsearch.py`). For each transitive A₅-set G/K and each subgroup H, the G-orbit of an H-orbit is a *face-orbit type*; there are 57 types on the regular set, 28 on A₅/C₂, 19 on A₅/C₃, 13 on A₅/V, 10 on A₅/C₅, 9 on A₅/S₃. An orbit complex is the closure of a union of types; A uses three. Every such complex is vertex-homogeneous by construction and its faces all have large stabilisers, which is where the fixed-complex conditions are most constraining — so this is the natural place a group-theoretic counterexample would live. Filters in order: χ = 1, χ(link) = 1, 𝔽₂-, 𝔽₃-, 𝔽₅-acyclicity, then the exact recursion.

   **Results: the A₅ family is now COMPLETE at k ≤ 4, on every transitive set.**

   | G/K | unions tried | χ = 1 | χ(link) = 1 | fail 𝔽₂ | **survive** |
   |---|---|---|---|---|---|
   | 60 (regular) | 425,923 | 3,420 | **0** | — | 0 |
   | 30 (A₅/C₂) | 24,157 | 736 | 58 | 58 | 0 |
   | 20 (A₅/C₃) | 5,035 | 132 | 128 | 128 | 0 |
   | 15 (A₅/V) | 1,092 | 27 | 0 | — | 0 |
   | 12 (A₅/C₅) | 385 | 52 | 52 | 52 | 0 |
   | 10 (A₅/S₃) | 255 | 10 | 0 | — | 0 |
   | **total** | **456,847** | **4,377** | **238** | **238** | **0** |

   **No orbit complex on any transitive A₅-set, built from at most four face-orbit types, is ℤ-acyclic.** Of 456,847 unions, 0.96% reach χ = 1; of those, 5.4% also have χ(link) = 1; and **all 238 survivors of both Euler tests carry 2-torsion — every single one.** Not a single 𝔽₂-acyclic example. Lutz's A is among the 736 at 30 points and fails at χ(link).

   *Three things the table says beyond the headline.* (i) **The regular set is the worst place to look**, not the best: 3,420 complexes reach χ = 1 there and *none* has an acyclic link. The inflation argument makes the regular action the universal *target*, but the 60-point orbit complexes are too coarse to hit it — the useful examples live on the smaller sets, as Lutz's does. (ii) **The link test is informative only at 30 points** (58 of 736); at 20 and 12 it is nearly vacuous (128/132, 52/52) and at 60, 15 and 10 it kills everything. (iii) **𝔽₂-acyclicity is doing 100% of the remaining work.** If the programme had only counting conditions, 238 candidates would still be standing at A₅; the one test that is not a counting condition eliminates all of them, and it eliminates them at the same prime every time. The Sylow argument says why: A₅'s Sylow 2-subgroup *is* C₂ × C₂, Smith forces the fixed complexes 𝔽₂-acyclic, and rank-2 elementary abelian actions are exactly the classical setting where 𝔽₂-homology of the whole complex escapes the fixed-point conditions.

   **Next, in order of value:** the two-subgroup family (faces H₁x ∪ H₂y), which is one step less structured and is where "balance" and "an acyclic link" could both be arranged; k = 5 on the 30-point set if cheap; and the PSL(2,7) sets listed in `small-degree-verification.md` §15.

   **Degree 20 as a bare CSP would hit the same wall and is not worth running**; the orbit-complex search above is the version of it that is.

   **The involution-quotient complex, and what fusion does to it** (`psl27.py`). The proposal "f(S) = 1 iff every pairwise quotient is an involution" on a regular G-set has faces = subsets of left cosets of the elementary-abelian 2-subgroups generated by pairwise-commuting involutions. On A₅ these are the 5 Klein groups, which are TI, so the 75 tetrahedra meet only in vertices and the complex is homotopy equivalent to the vertex–coset incidence graph: χ = −165. The suggestion was that a group with **non-trivial 2-fusion** might do better. On PSL(2,7) (order 168, Sylow D₈, 21 involutions, 14 Klein groups in two classes of 7, each involution the centre of its D₈ centraliser and hence in exactly 2 Klein groups): f = (168, 1764, 2352, 588), **χ = 168 = |G|**, reduced 𝔽₂-Betti (0, 34, 201, 0). **Every one of the 1,764 edges lies in exactly two tetrahedra** — the fusion glues the tetrahedra along edges — so there are no free faces at all, the complex is not collapsible, and it has a 201-dimensional H₂. Fusion made it worse: it created 2-cycles where A₅ had only 1-cycles.

   *The general obstruction is arithmetic.* For a coset complex of one conjugacy class the per-vertex Euler characteristic is 1 − i/2 + 3k/4 (i involutions, k Klein groups), so χ = |G|·(rational with denominator ≤ 4) — it equals |G| for PSL(2,7), −165 for A₅, and can never equal 1 for |G| > 4. Acyclicity needs faces of *several* orbit types whose sizes balance, on a *non-regular* set, which is exactly what Lutz's A does with three maximal-subgroup classes on 30 points. Fusion is not the missing ingredient; balance is.

   **Does Lutz's recipe generalise?** Stated group-theoretically, A is: vertex set G/⟨t⟩ for an involution t (each point carries its own involution xtx⁻¹, two points per involution); facets = the *own-involution* orbits of the maximal subgroups — the H-orbit of a point has size |H|/2 exactly when the point's involution lies in H; one G-orbit chosen where a subgroup has two. Nothing platonic in that; the icosahedron is what it looks like for A₅. **By the nerve theorem A ≃ the nerve of its facets** (all intersections are simplices), so acyclicity is a property of how maximal subgroups meet on involution cosets: χ(A) = Σₖ(−1)^{k−1}·#{k-sets of facets sharing a point} = 21 − 110 + 120 − 30 = 1. Through every point pass one D₁₀-, one A₄- and two S₃-facets, and **the link of a vertex is the nerve of those four, which is a 4-cycle** (pairwise intersections of sizes 3,3,2,2 beyond the vertex; 1,1 for the other two pairs): lk(v) ≃ S¹, χ = 0. That is the mechanism of A's evasiveness in one sentence.

   *On PSL(2,7) the recipe fails, for a structural reason* (`psl27.py`, `psl27_orbit.py` on G/C₂, 84 points). Only involution-bearing maximal classes can contribute own-involution orbits; C₇:C₃ has none and drops out. The two S₄ classes each give 7 facets of size 12 that **partition** the 84 points, and a facet of one class meets a facet of the other iff the corresponding point and line of the Fano plane are incident — so the nerve is the **Heawood graph**, χ = 14 − 21 = −7, b₁ = 8. Not acyclic, and no choice within the recipe changes it. So the construction is not generic: it needs every maximal class to carry involutions *and* the Möbius-type sum over their incidences to come out to 1, which is a Diophantine coincidence A₅ happens to satisfy. Whether Lutz 2002's "further higher-dimensional examples" realise it for other groups could not be checked (paywalled). **Where it does generalise, evasiveness reduces to the local nerve at a point — the incidence structure of the maximal subgroups containing one involution — and non-evasiveness would need that to be acyclic at some vertex and recursively below**; for A₅ it is a circle.

   **Orbit complexes on PSL(2,7), all six transitive sets** (`psl27_orbit.py`; full table in `small-degree-verification.md` §15): **129,758 unions, 121 with χ = 1, and not one with χ(link) = 1** — so on this group nothing ever reached the homological filter. **The failure mode inverts between the two groups.** On A₅, counting leaves 238 candidates and 𝔽₂-acyclicity kills all of them; on PSL(2,7) the χ = 1 rate is ten times lower (0.093% against 0.96%) and the link test alone finishes the job. The larger group has more subgroup classes, hence more distinct orbit sizes, hence a harder balance problem: **richer structure makes the coincidence rarer, not commoner** — the same conclusion the involution-complex comparison reached independently.

   *One near-theorem, and why it is not one.* On PSL(2,7), χ = 1 occurs only when 3 divides |K| — never on the four sets with 2-group stabilisers. The natural explanation is Smith: no conjugate of a 2-group contains C₃, so C₃ has no fixed vertices, the fixed complex is empty, and χ ≡ 0 (mod 3). **That is wrong**, and A₅ refutes the rule — its 15-, 30- and 60-point sets have 2-group stabilisers and yield 27, 736 and 3,420 complexes with χ = 1. The fixed *space* |Δ|^{C₃} is built from **setwise**-invariant faces, being the fixed subcomplex of the barycentric subdivision, not from fixed vertices: checked on an A₅ 15-point example, there are no C₃-fixed vertices but exactly one setwise-invariant face, giving χ(|Δ|^{C₃}) = 1 in agreement with χ(Δ) = 1. A useful trap to have walked into, since the pointwise reading would have "proved" several of these sets vacuous.

   *Two bugs on the way, both predicted by existing text.* An early return inside the pend-decrement loop produced 36 spurious "solutions" (the false-SAT bug `stage4_fast.py`'s comment describes); and the exact recursion first returned True on a fully-queried subcube, declaring a "counterexample" in 0.0 s (the base-case trap of item 3's box). Both times impossible speed was the tell. Both fixed, controls passing.

4. **Run the CSP against Illies's example — with the monotonicity constraint switched off.** The whole `small-degree-computation.md` pipeline applies with the coordinate action in place of the pair action, and the object is much smaller: 12 coordinates rather than 45 or 66, and 2^12 subsets rather than 12 million isomorphism classes. But the target is a **set-system** counterexample, not a monotone one (§4), so the run must enumerate all invariant properties with ∅ ∈ P, X ∉ P rather than the monotone ones — a monotone-constrained run *cannot* reproduce it, and finding nothing there would be §6 item 3 over again, not a control. **If the unconstrained run reproduces a non-evasive property, the pipeline is validated against a known counterexample** — a control the pipeline has never had. (`small-degree-computation.md` §10 item 7 asks for a negative control of the same kind, but for the adversary game against Adamaszek's ℰ; this one exercises the CSP-and-χ layers, which that control does not reach.) Worth doing regardless of what else comes of this.
5. **Then ask the sharpening question.** Given a counterexample at T(12,162), what does its structure use that a graph property cannot? The scan says the group has no transitive Oliver subgroup; a graph property's group always has *some* structure at the pair level even when 2-homogeneity fails. Making that comparison precise is what would sharpen the distinction, and it is the reason this document exists rather than the bounds.

> **What is not worth doing** is trying to improve the general-transitive bound with the δ apparatus. §2 says why: the machinery is a substitute for a transitive Oliver subgroup, and where one exists the answer is already exact, while where none exists the machinery has nothing to act on either.

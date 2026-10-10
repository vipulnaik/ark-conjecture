# Monotone transitive Boolean functions: what the framework buys, and what it does not

*Companion to `orbital-evasiveness-notes.md`. The k-uniform documents move along the arity axis; this one moves off it entirely, to nontrivial monotone Boolean functions on N coordinates invariant under a transitive group. That setting contains all the k-uniform cases (a k-graph property is the case N = C(n,k) with Γ = Sₙ acting on k-sets), so it is the natural ceiling of the programme.*

**The short answer.** In the general setting the group acts on the coordinates directly. So wherever Γ contains a **transitive Oliver subgroup** the argument closes at its first rung, with none of the μ(n) machinery (§1). Where Γ has none, the analogue μ_Γ is a real quantity but has no theory behind it (§2). The graph case is different because Sₙ acts on the pairs through the vertices: there transitivity on coordinates is 2-homogeneity, which a solvable group has only at prime-power degree, and μ(n) is what the arithmetic supplies in its place (§5). What the framework contributes in the general setting is a *localisation*: a computable criterion picking out the groups where the argument fails (§3), and a stronger fallback, bi-resistance, that settles one of them (§4).

**Literature status.** The monotone weakly-symmetric conjecture is **open**, and verified for N ≤ 14 in the literature (§4).

**Status.**

| section | standing |
|---|---|
| §1 the criterion | **proved**; essentially KSS's argument stated for general Γ |
| §2 why μ(n) does not transfer | **proved** |
| §3 the scan | **computed**, degrees 4–14; M₁₂ and 14T54 not decided |
| §4 T(12,162) | **settled**: every nontrivial monotone invariant function is evasive, by a two-orbit Oliver subgroup whose orbits the group swaps |
| §5 what this says about graph properties | **proved**: neither a transitive Oliver subgroup on pairs nor a loop exists away from prime-power n |
| §5a the coset complex | a worked example, settled by a literature theorem |
| §6 the counterexample programme | computed searches and proposals |

---

## 1. The criterion, and it closes at t = 1

Let P be a nontrivial monotone decreasing property of subsets of an N-element coordinate set, Δ_P its simplicial complex, and Γ ≤ S_N a group preserving P.

> **Proposition 1.** If Γ contains a **transitive** Oliver subgroup H, then P is evasive.

*Proof.* Suppose not. Non-evasive ⟹ Δ_P collapsible ⟹ ℤ-acyclic, and H acts on it. The H-invariant subsets of the coordinates are unions of H-orbits, and H is transitive, so they are exactly ∅ and the whole set. The whole set is not in P (nontriviality) and ∅ is, so **Δ_P^H = {∅}**, the complex with no vertices, of Euler characteristic **0**. Oliver's theorem for an H that is p-by-cyclic-by-q forces χ(Δ_P^H) ≡ 1 (mod q), and 0 ≡ 1 (mod q) is false for every prime q — and false outright in the trivial-top case, where the congruence collapses to χ = 1. ∎

Three corollaries, each a one-line check on Γ:

- **A regular cyclic subgroup suffices.** C_N is cyclic, hence Oliver with Γ₂ = 1 and a trivial top. So any Γ containing an N-cycle is done.
- **A transitive Sylow subgroup suffices**, a p-group being Oliver with Γ₁ = Γ₂ = itself.
- **Prime-power N is done**, via a Sylow subgroup (Proposition 2, §3) — KSS's theorem in this setting.

> **This is the t = 1 row of `small-degree-computation.md` §2.4**, which says that with one orbital *nothing survives*. There it is a row in a table about fixed complexes; here it is the entire theory. In the graph setting t = 1 requires a 2-homogeneous group and so is available only at prime powers, whereas here t = 1 *is* transitivity, which is the hypothesis.

---

## 2. The analogue of μ(n) here: definable, but with no theory behind it

The framework's central quantity is m\*(Γ), the minimum size of a Γ-orbital (an orbit on **pairs** of vertices), and δ = m\*/C(n,2). The analogue here is a minimum orbit on **coordinates**, and the group that matters is not Γ itself: Γ is transitive, but Proposition 1 needs a transitive *Oliver subgroup*, and Γ's Oliver subgroups are in general intransitive. So the quantity is

> **μ_Γ(N) := max over Oliver subgroups Λ ≤ Γ of the minimum Λ-orbit on the N coordinates**,

which equals N exactly when Γ contains a transitive Oliver subgroup, and is smaller — sometimes much smaller — when it does not (A₅ on 10 points and T(12,162), §3).

**μ_Γ has no theory behind it.** μ(n) is computable because the graph setting fixes the shape of the action — a group on [n], inducing on pairs — so the orbitals are block-structured and the shape space, ceilings and arithmetic apply. μ_Γ(N) depends on an arbitrary transitive action on N points: there is no shape space, no mod-12 keying, no cap formula, and it can only be computed group by group (`orbital-evasiveness-notes.md` Appendix C row 6). In particular there is no general guarantee of an Oliver subgroup with large orbits, or with few orbits. That is the real difference from graph properties: there, Oliver-resistance does not collapse the ladder at non-prime-power n, but the Θ(n²) orbitals of §3 of `arithmetic-of-density.md` force real structure on every resistant property; here the group theory may give nothing to start from.

**One thing does transfer: the negative result about escalation.** `small-degree-computation.md` §7.1's one-sidedness diagnosis — every primal χ condition and every monotone propagation pushes coordinates *into* P, the only primal OUT-generator being nontriviality — is a statement about the constraint system, not about graphs. It predicts that at a group where Proposition 1 fails, adding more groups to a battery will not produce UNSAT either.

---

## 3. Where Proposition 1 fails: a scan of the transitive groups

One whole family of degrees is settled outright.

> **Proposition 2 (prime-power degrees).** Every transitive group of prime-power degree contains a transitive Oliver subgroup — indeed a Sylow subgroup is one. Hence every nontrivial monotone weakly-symmetric property on p^a coordinates is evasive.
>
> *Proof.* Let G be transitive of degree n = p^a with point stabiliser G_x, and let P be a Sylow p-subgroup, |P| = p^b. From [G : G_x] = p^a we get v_p(|G_x|) = b − a, and P ∩ G_x is a p-subgroup of G_x, so |P ∩ G_x| ≤ p^{b−a}. Then
>
> |P·G_x| = |P|·|G_x| / |P ∩ G_x| ≥ p^b·|G_x| / p^{b−a} = p^a·|G_x| = |G|,
>
> so **P·G_x = G** and the P-orbit of x has size [P : P ∩ G_x] = p^a — all of it. A p-group is Oliver with Γ₂ = itself and both quotients trivial, so Proposition 1 applies. ∎
>
> **At prime degree this is just Cauchy's theorem**: transitivity forces p | |G|, Cauchy gives an element of order p, and on p points such an element is a single p-cycle — regular, transitive, cyclic, Oliver. *Attribution*: the prime-power case is due to **Rivest and Vuillemin**, by exactly this Sylow counting. They had no need of Oliver groups: at a prime power the p-group layer alone is transitive, so the cyclic and q-layers that KSS added are not needed.

So failures can only occur at composite non-prime-power degrees. In the S_n world μ(n) = C(n,2) exactly at prime powers, because AGL(1, p^a) is 2-homogeneous; here a Sylow subgroup is transitive exactly at prime powers. **Both settings measure how far a degree is from being a prime power**, one through orbitals on pairs and the other through orbits on coordinates.

*Containing versus being.* Testing every transitive group of degrees 6–11 for whether **it** is Oliver (`oliver_negative.g`, R6 item 1 of `pending-checks.md`) gives 108 Oliver against 52 not, and eleven of the failures are solvable, at degrees 8 and 9. Those are prime powers, so every property invariant under those groups is evasive anyway: a group can fail the chain condition while a subgroup satisfies it, and it is the subgroup that decides.

**The scan** (`oliver_transitive_scan.g`, with the exhaustive subgroup-class search of `halfsplit_scan.g` for orders ≤ 5,000 at degrees 12–14) asks, for every transitive group of degree 4–14: **is there a transitive Oliver subgroup?**

| degree | groups with **no** transitive Oliver subgroup | how settled |
|---|---|---|
| 4, 5, 7, 8, 9, 11, 13 | none | Proposition 2 |
| 6 | none | scan |
| **10** | **T(10,7) = A₅ on the 10 pairs of {1..5}**; also T(10,26) = A₆ and T(10,31) = A₆.2 (order 720) | exhaustive search at A₅ finds no non-evasive property (§6 item 3); both contain A₅ acting transitively on the same 10 points (§6 item 0; checked in GAP) |
| **12** | **T(12,162)** | settled by bi-resistance (§4) |
| **14** | T(14,10) = PSL(3,2), T(14,30) = PSL(2,13) | admit bi-resistant properties, so **open by these methods**; within the literature's N ≤ 14 |
| not decided | M₁₂ = T(12,295); T(14,54) = 2⁶:S₇ | too large for the subgroup-class search |

*A₅ on pairs.* A₅'s only transitive subgroup on the 10 pairs is itself (D₁₀ has two orbits, A₄ has orbits 4 and 6), and A₅ is insoluble. S₅ on pairs, by contrast, contains F₂₀ = C₅⋊C₄, which is transitive and Oliver — consistent with KSS at the prime power 5. The gap is exactly the properties invariant under A₅ but not under S₅. In the other notation, A₅ on the 10 pairs is the invariance group of a **chiral graph property on 5 vertices** (`chiral-graph-properties.md` §1), so §6 item 3's exhaustive search there is a complete verification of the chiral analogue of ARK at n = 5, the first place a chiral counterexample could have lived. **The chiral frontier is therefore n = 13.**

> **The construction for A₂ₚ, due to Vipul.** At degree 2p with p an odd prime, take the p blocks {1,2}, …, {2p−1, 2p}, the **index-2 subgroup of (C₂)^p generated by the products of evenly many of the p transpositions**, and extend it by a p-cycle permuting the blocks diagonally. The result has order **2^{p−1}·p**, is transitive, lies **inside A₂ₚ** (every generator is even), and is Oliver with Γ₂ = (C₂)^{p−1} normal and cyclic quotient C_p — a trivial top. Verified at p = 2, 3, 5, 7, 11; at p = 2 it is exactly the Klein four-group inside A₄. So **A₂ₚ contains a transitive Oliver subgroup for every odd prime p**, which settles A₁₀ and A₁₄ even though the obvious candidate, a 2p-cycle, is odd. This is a transitive Oliver subgroup arising with no connection to k-homogeneity, and so the kind of construction that has to be found at non-prime-power degrees.

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

G is minimal transitive and not itself Oliver, so Proposition 1 has nothing to act on, and μ_Γ < 12.

**But the Oliver route still closes, one step up.** G has a block system with two blocks of size 6, {1,4,5,8,9,12} and {2,3,6,7,10,11}, and has Oliver subgroups whose two orbits are exactly those blocks — five conjugacy classes of them, of orders 12, 24, 48, 96 and 144 (*verified by enumerating all subgroup classes of G*). The smallest is a diagonal A₄ rotating the two tetrahedra whose edges the blocks are, in lockstep; the structure is worked out in `orbital-evasiveness-notes.md` §7.13. For such an H, a G-invariant P contains one block iff it contains the other, since G swaps them; the union of the two is the whole set, which P omits. So Δ_P^H is either empty (χ = 0) or two isolated points (χ = 2), and neither is ≡ 1 modulo any prime. **Every nontrivial monotone G-invariant function is evasive.** This is the bi-resistance criterion of `orbital-evasiveness-notes.md` §7.13: a two-orbit Oliver subgroup whose orbits the group swaps forms a *loop* in the half-split graph, and a loop rules out every nontrivial property. Of the groups with no transitive Oliver subgroup through degree 14, T(12,162) is the only one with a loop.

The exhaustive search of §6 item 3 at T(12,162) (77,819 properties, 336 with χ = 1, **0 non-evasive**) is therefore a check of the criterion and of the search code, not independent evidence.

**Illies (1978), since the citation is routinely misread.** Illies is often quoted as supplying a non-evasive *monotone* transitive Boolean function on 12 variables. It does not. Rivest and Vuillemin's original conjecture asked only that f be weakly symmetric with f(∅) ≠ f(X), *without monotonicity*; Illies's counterexample refutes that version, and Aigner repaired the conjecture by adding monotonicity. Kahn–Saks–Sturtevant say so explicitly: "they proposed a somewhat stronger version … in which monotonicity was replaced by the weaker condition: F contains exactly one of ∅, X; a counterexample to this was provided by Illies." The set-system version also fails at 6 variables, and therefore at every multiple of 6 (below). **The monotone weakly-symmetric conjecture is open, and verified for N ≤ 14 in the literature** (a recent paper settles N = 14 specifically).

**Illies's example, recovered** (from arXiv:1409.7890, Prop. 3.15; checked by `illies12.py`). Identify the 12 points with ℤ/12 ≅ ℤ/3 × ℤ/4 and draw them on a 3 × 4 torus grid: x ↦ (x mod 3, x mod 4). A *row* fixes x mod 3 and is a 4-cycle; a *column* fixes x mod 4 and is a triangle. Then

> **F = {∅} ∪ {S : S lies in one row or one column and is connected there}**,

i.e. ∅, the 12 points, the 24 grid edges, the 12 three-point paths in rows plus the 4 columns, and the 3 full rows (1 + 12 + 24 + 16 + 3 = 56 sets). Illies gives it as the ℤ/12-orbits of ∅, {1}, {1,4}, {1,5}, {1,4,7}, {1,5,9} and {1,4,7,10}.
- **Not monotone:** a row's opposite pair {1,7} is disconnected, but adding a middle point gives {1,4,7} ∈ F.
- **f(∅) ≠ f(X).**
- **The parity condition holds:** Σ (−1)^{|S|} = 1 − 12 + 24 − 16 + 3 = 0, which every non-evasive function needs.
- **Decision-tree complexity 11**, by the exact recursion; an optimal tree has 110 leaves, 36 of them at depth 11. It queries 1, 2, 3, … adaptively, consecutive integers being off any common line. Two 1s off a common line answer NO at once, and the all-zero path ends at depth 11 because ∅ and every singleton are both in F.
- **Full symmetry group S₃ × D₄ = T(12,28)**, of order 48: S₃ on the row index, D₄ on the column index. It is maximal, since it is the automorphism group of the grid graph K₃ □ C₄ that the 2-sets of F form.
- **It contains the 12-cycle**, a transitive Oliver subgroup. So for a monotone property Proposition 1 would forbid exactly this; the example lives entirely in the non-monotone gap. Neither Sylow subgroup of T(12,28) is transitive, which is why Rivest–Vuillemin's prime-power counting, the tool for set systems, does not reach it either.

**Illies is not the smallest: a 6-variable counterexample, and infinite families.** An exhaustive search over every transitive group of degree 6 (`rv_search.c`, `rv_search.py`) finds non-evasive invariant set systems with f(∅) ≠ f(X) under exactly one group, **A₄ acting on the six edges of K₄** (T(6,4)): eight of them, all with D = 5. Checked by `rv6_a4.py`. One of them: with the three opposite-edge pairs as P₀, P₁, P₂ in a cyclic order,

> F = ∅, the 6 points, the 12 two-sets other than the opposite pairs, the 4 triangles of K₄ (the other four transversals, the stars, are excluded), each opposite pair together with either point of the cyclically preceding pair (6 sets), and the 3 unions of two opposite pairs — 32 sets, signed count 1 − 6 + 12 − 10 + 3 = 0.

It is not monotone. Neither Sylow subgroup of A₄ is transitive on the 6 points (V₄ has three orbits of size 2, C₃ two of size 3), so Rivest–Vuillemin's counting does not apply. A₄ itself is a transitive Oliver group, so a monotone version is again impossible. The chirality is essential: S₄ on the same points, and every other group of degree 6, admits none. **In graph terms:** the example is a *chiral* graph property on 4 vertices, invariant under even vertex permutations only. For full Sₙ-invariant graph properties with f(∅) ≠ f(K_n) there is no counterexample on n ≤ 5 vertices: S₄ above admits none, and by Adamaszek (arXiv:1303.5601) the only nontrivial nonevasive properties on ≤ 5 vertices are his eleven-class property and its images under negation, complementation and duality, all closed under G ↦ Ḡ and so with f(∅) = f(K₅) (`small-degree-computation.md` §4.3). The first open graph case is n = 6, which is out of reach of Rivest–Vuillemin (C(n,2) is not a prime power) and of KSS (not monotone). We have not found this example in the literature, which consistently cites Illies's 12 as *the* counterexample. Lovász–Young's notes mention, without construction or reference, a counterexample at n = 14.

**Infinite families come for free, by composition.** If f is a counterexample on k variables under G, then f(AND(B₁), …, AND(B_k)) on blocks of size m is invariant under the transitive group G ≀ S_m, keeps f(∅) ≠ f(X), and has D ≤ D(f)·m < km. The same holds for an outer g with g(∅) ≠ g(X) applied to copies of f. So **every multiple of 6 carries a counterexample** (checked at n = 12: both compositions have D = 10). This is presumably the "infinite family" the literature alludes to; the sentence in these notes saying so has no recorded source. The open question is which degrees *not* divisible by 6 carry one: none at the prime powers (Rivest–Vuillemin), none at degree 10 among the groups with at most 26 subset orbits, and Lovász–Young's unconstructed 14.

**Why 3 and 4: two counting constraints, and a coincidence.** Generalise to an a × b torus grid with rows of length b and columns of length a, each line either a cycle or a complete graph, and F = {∅} ∪ {S inside one line, connected there}. Two necessary conditions for non-evasiveness can be read off directly.

1. **Global parity.** A non-evasive function has Σ_{S∈F} (−1)^{|S|} = 0. Counting by lines (singletons lie on two lines), the sum is 1 + a·s(b) + b·s(a) + ab. Here s(m) is the signed count of nonempty connected subsets of one line: s = 1 − m for an even cycle, and s = −1 for an odd cycle or a complete graph. So the sum vanishes **only for b = a + 1 with b even and the b-lines cycles** (or symmetrically). Both lines complete gives (a − 1)(b − 1), and two even cycles give 1 + a + b − ab. Candidates are 3 × 4, 5 × 6, 7 × 8, ….
2. **The link of the first query.** By transitivity any first query looks like any other, and its 1-branch is the *link* g of a point p: the other points of p's row and column, with g(T) = 1 iff T lies in one of the two lines and T ∪ {p} is connected there. Every other point is a kill switch, since a 1 there forces NO. If g is evasive, so is the whole family: an adversary plays g's adversary, answers 0 at the kill switches, and arranges g = 1 at the end, which then needs every kill switch too. The link's parity is b/2 − 2 when the a-lines are complete and (b − a + 1)/2 − 1 when they are odd cycles. **With complete columns this forces b = 4, hence a = 3.** With cycle columns it holds for every b = a + 1, but the link is then evasive anyway: exact decision-tree complexity 9 of 9, 13 of 13 and 17 of 17 at 5 × 6, 7 × 8 and 9 × 10 (`illies_link.py`). So **every family of this kind beyond 3 × 4 is evasive**; the locality solver `illies_local_solver.py` confirms this at 5 × 6, and the brute-force `illies_grid.py` confirms it over every grid with N ≤ 15.

**What the 3 × 4 link does right.** There the column part is the triangle C₃ = K₃: both other column points are adjacent to p and to each other, so every column subset is connected to p and the column condition is vacuous. The row part is C₄ minus p, a path r₁ r₂ r₃ whose ends are p's neighbours; its only bad set is {r₂}, the antipode alone. So g = NOR(R) ∨ (NOR(C) ∧ R ≠ {r₂}), on five variables. It has a depth-4 tree: query r₁; if 1, only the column is left to check, so g = NOR(C); if 0, query r₃; if that is also 0, the column has become irrelevant and g = ¬r₂. **The column dropping out is the whole mechanism, and it needs a line on which every subset is connected to the pivot: a triangle.** The even line must then have length a + 1 = 4 for the parity, and C₄ is also the smallest cycle with an antipode, the one point whose isolation the tree has to test. A triangle is the only cycle that is complete; at a ≥ 5 the column condition is genuinely restrictive, and the link becomes evasive.

---

## 5. What this sharpens about graph properties

For a graph property the coordinates are the C(n,2) pairs and the group is Sₙ, which is transitive on them. Proposition 1 does not apply, because Sₙ is not Oliver for n ≥ 5. What it needs is a transitive Oliver *subgroup* of Sₙ on the pairs, i.e. a solvable 2-homogeneous group, and that exists only at prime-power n. **So the graph case is exactly the general case, with the coordinate-transitivity requirement replaced by 2-homogeneity.** At prime powers AGL(1, p^k) supplies it and KSS follows; at every other n, μ(n) is the fallback, and in the t ≥ 2 case the fixed-point argument consumes the minimum orbital itself, so μ(n) is not a modelling choice.

**The §4 escape does not help graph properties either.** For a graph property, the analogue of a loop is an Oliver group with exactly two orbitals that Sₙ maps to each other, i.e. two isomorphic orbital graphs. A vertex-transitive group with exactly two orbitals is rank 3. If primitive and solvable it is affine, so of prime-power degree. If imprimitive, its orbitals are "same block" and "different block", of valencies b − 1 and n − b; these are equal only if n = 2b − 1, and b | n then forces b = 1. A group intransitive on vertices has a third orbital unless one vertex orbit is a single point, and then the two orbitals are a star and a clique. **So at non-prime-power n no Oliver group gives a loop, and neither escape that settles the general case is available to graph properties.**

**The general case is not the place to look for better constants.** Ω(n²) is the ceiling of the k-uniform results at every arity (`general-k-note.md` §5), and the general Boolean setting has no ambient structure to trade for a better constant.

---
## 5a. A worked family where evasiveness is a theorem at every group — and not by this framework

*From a question of Vipul's: the first example in this note of a natural monotone property, invariant under a transitive group, that is settled at **every** finite group — including the ones the Oliver criterion cannot touch.*

**The property.** Let G act on itself by left multiplication — regular, hence transitive, so the coordinates are the |G| elements. For S ⊆ G put

> **P(S) ⟺ the subgroup generated by the left quotients {s⁻¹t : s, t ∈ S} is proper.**

Left quotients are invariant under left translation, since (gs)⁻¹(gt) = s⁻¹t, so P is G-invariant; it is monotone decreasing, since S ⊆ T makes the quotient set grow; and it is nontrivial (∅ ∈ P, G ∉ P).

> **What it actually is.** For nonempty S, ⟨s⁻¹t⟩ ≤ H proper ⟺ **S lies inside a left coset of a proper subgroup**. *Verified exhaustively at C₄, C₆, S₃ and A₄: the two families of subsets coincide exactly.* So **Δ_P is the coset complex**, whose maximal faces are the maximal proper cosets — and by the nerve lemma (intersections of cosets are cosets, hence contractible) it is homotopy equivalent to **Brown's coset poset** C(G).

**Where that lands it.** Non-evasive ⟹ collapsible ⟹ contractible. And:

- **Shareshian–Woodroofe proved the coset poset of a finite group is never contractible**, settling a question of Brown. **So P is evasive at every finite group** — A₅, every A_n, every group outside the Oliver class.
- The cruder Euler-characteristic route also works wherever it is available: Brown proved **P(G, −1) = −χ̃(Δ(C(G)))**, so χ̃ ≠ 0 forces evasiveness on its own. *Verified here, both sides computed independently — the complex by counting faces, the zeta value by Möbius inversion over the subgroup lattice: C₄ (1), C₆ (−2), S₃ (−8), A₄ (−30), agreeing exactly.* At **A₅ the subgroup lattice gives P(A₅,−1) = −1560, so χ̃ = 1560 ≠ 0** — evasiveness there without the topological theorem, and 1560 = 60·26 respects Brown's divisibility result. Whether χ̃ ≠ 0 at *every* finite group is still open; Brown proved it for solvable G from Hall's formula.

> **The instructive part is why this note's own machinery is silent here.** A subgroup H ≤ G acting by left multiplication has orbits the right cosets Hg, so **H is transitive on G iff H = G**. Hence "G contains a transitive Oliver subgroup" collapses to "**G is Oliver**", and at A₅ there is not a weak criterion but *no smaller subgroup to fall back on at all*. The regular action is the extreme case of §5's transitive-versus-Oliver-subgroup gap: the subgroup lattice offers nothing, so the question has to be answered by the shape of Δ_P instead — which is what Brown and Shareshian–Woodroofe do.
>
> *The wider argument this example supports — that the conjecture's known corners each cost a different deep theorem, and that the hardness concentrates in the uniform quantifier — is in `hardness-of-evasiveness.md`, along with the nerve-lemma step spelled out.*
>
> **So this is a template for the cases §6 cares about.** Where the Oliver route is unavailable, the alternative is to recognise Δ_P as a complex whose homotopy type is already known, rather than to search for groups. The coset complex is one such; §6's orbit complexes are another, and the reason they have resisted may be that no comparable identification has been found for them.


---

## 5b. Regular actions: universal, and where Illies's construction really lives

*From a question of Vipul's: is the conjecture easier when the group acts regularly, i.e. for set systems on a group G invariant under left multiplication only (not under automorphisms or right multiplication)?*

**No easier: the regular action is the whole problem, group by group.** A counterexample for any transitive action G/K yields one for the regular action of the same G.
- *Monotone:* pull the complex back along g ↦ gK (§6 item 0).
- *Not monotone:* compose f with AND over each coset gK. This keeps f(∅) ≠ f(X) and D < |G|, as in §4's composition.

So Illies's ℤ/12 example is already regular, and the 6-variable A₄ example of §4, AND-ed over the pairs gC₂, becomes a left-invariant counterexample on A₄ itself.

**What counting gives in the regular action is exactly Rivest–Vuillemin.** A set with stabiliser H has a left-translation orbit of size |G : H|. So Σ_{f(S)=1} (−1)^{|S|} is 1 (for ∅) plus multiples of the indices of proper subgroups. A prime dividing all those indices exists exactly when G is a p-group, since otherwise a maximal subgroup containing a Sylow p-subgroup has index prime to p. Two consequences:
- Free orbits contribute multiples of |G|, so a counterexample needs its *periodic* sets (unions of cosets of a nontrivial subgroup) to carry signed weight ≡ −1 (mod |G|).
- The Oliver route is at its weakest here: a subgroup acting by left multiplication is transitive only if it is G (§5a).

**The coset template.** Choose subgroups H₁, …, H_k and, for each, a family of *pieces*: subsets of Hᵢ, invariant under left multiplication by Hᵢ, which is what makes the next step well defined. Let F be ∅ together with every left translate g·(piece). Illies's example is this with G = ℤ/12, H₁ = ⟨3⟩ with the connected arcs of its 4-cycle, and H₂ = ⟨4⟩ with every subset of its triangle.

*The design equation.* If the Hᵢ meet pairwise trivially, each piece of size ≥ 2 lies in exactly one coset. Writing σᵢ for the signed count of Hᵢ's pieces of size ≥ 2, the root parity condition becomes

> Σᵢ |G : Hᵢ| · σᵢ = |G| − 1.

For Illies: σ = 4 − 4 + 1 = 1 for the 4-cycle arcs and σ = 3 − 1 = 2 for the triangle, so 3·1 + 4·2 = 11. **With these two piece types the equation reads 1 − |G| + |G|/4 + 2|G|/3 = 0, which forces |G| = 12.** So the 12 is the parity equation's choice, not ℤ/12's. The equation is necessary only; §4's grid family shows the restricted functions after the first query are the real filter.

**The construction is group-generic at order 12** (`illies_transplant.py`). Take G any group of order 12, K an order-4 subgroup made a 4-cycle by its Cayley structure (⟨y⟩ with y^{±1}, or V₄ with two of its three involutions), and T an order-3 subgroup with K ∩ T = 1. Then F = ∅ ∪ (all subsets of left cosets of T) ∪ (connected arcs of left cosets of K) is non-evasive, D = 11, **at every one of the 28 such choices across all five groups of order 12**: C₁₂ (1), C₃ ⋊ C₄ (3), A₄ (12), D₁₂ (9), C₂ × C₆ (3). This is consistent with §4's analysis of why 3 × 4 works, which is local to a point's row and column.

**Exhaustive search within the template** (`coset_template_orbits.g`, `coset_template_search.py`, using `rv_search.c`). Members lie in left cosets of proper cyclic subgroups, or of all proper subgroups. Every union of orbits with exactly one of ∅, G was tested, at every group of non-prime-power order ≤ 15 whose orbit count is at most 30:

| order | groups | non-evasive |
|---|---|---|
| 6, 10, 14, 15 | S₃, C₆, D₅, C₁₀, D₇, C₁₄, C₁₅ (both subgroup classes) | **0** |
| 12 | C₁₂ | 8 |
| 12 | C₃ ⋊ C₄ | 24 (all subgroups are cyclic, so the two classes agree) |
| 12 | A₄ | 0 with cyclic subgroups; **12** once V₄ is allowed |
| 12 | D₁₂, C₂ × C₆ | not searched (35–45 orbits) |

All found have D = 11, and all are Illies-shaped. Every C₃ ⋊ C₄ example (checked by coset type) takes one C₄ with exactly Illies's 4-cycle arcs (3 choices) and pairs it with one of 8 "column" families inside the cosets of C₆. The Illies transplant is one of the 8; the other 7 use pieces in the C₆ cosets, which meet C₄ in the centre. The A₄ examples agree with the transplants in count (12) and piece structure; they were not matched set-for-set. **So within this template, at orders up to 15, Illies's construction is the only mechanism found, and order 12 is the only order that hosts it.** The 6-variable A₄ example is not of this form after the pull-back, since its pulled-back members span several cosets.

**Monotone pieces: the template is dead when the subgroups meet trivially** (sketch). For a monotone F the piece families are complexes, and Δ is a union of translates of them. If the Hᵢ meet pairwise trivially, two translates share at most one point. Treat each connected component of a translate, with at least 2 points, as a block. For Δ to be contractible the blocks must form a hypertree: connected, with Σ_blocks (size − 1) = |G| − 1. By transitivity every point lies in the same number r of blocks.
- r = 1: the blocks partition G, and connectivity forces a single block G, which is the trivial property.
- r ≥ 2: the number of blocks N ≤ r|G|/2 and Σ size = r|G|, so the hypertree condition r|G| − N = |G| − 1 gives (r/2 − 1)|G| + 1 ≤ 0, which is false.

So a monotone construction must use overlapping subgroups, where translates share edges and larger faces. That is the territory of Brown's coset complexes (§5a). *Not written out in full:* the homotopy step, that a union of blocks pairwise meeting in at most a point is contractible only if the incidence structure is a hypertree, is standard but has not been checked in this setting.

## 6. The counterexample programme

0. **Only MINIMAL transitive groups need testing; the rest are settled by inclusion.** If H ≤ G are both transitive on X, every G-invariant family is H-invariant, so if every nontrivial monotone H-invariant family is evasive, so is every G-invariant one. Hence the census needs only the minimal transitive groups that are not Oliver. This settles A₆ and T(10,31) = A₆.2 on 10 points: each contains A₅ acting transitively on the same 10 points (in A₆, the point-stabiliser A₅ permutes the ten 3+3 partitions of six points as A₅ on pairs of five), and item 3's exhaustive scan at A₅ found nothing.

   *The same argument makes the regular action universal.* Given a G-invariant nonevasive complex on a transitive G-set G/K, pull it back along g ↦ gK to the regular G-set: each vertex becomes a simplex on its fibre, duplicated vertices are dominated by their twins, and removing a dominated vertex is a strong collapse, which preserves nonevasiveness in both directions. So a counterexample for *any* transitive action of G yields one for G acting on itself, and the cleanest form of the question is: **does some non-Oliver G admit a left-translation-invariant nonevasive down-set on G?** Cleaner still, since Proposition 1 disposes of every Oliver group: **does there exist a vertex-transitive nonevasive simplicial complex with more than one vertex?** No group need be chosen in advance.

1. **Decide M₁₂ and 2⁶:S₇, then extend the scan.** The right tool is the transitive-groups library rather than the subgroup lattice: a transitive Oliver subgroup of G is a transitive solvable Oliver group of the same degree, so enumerate those (a short list per degree) and test each for embedding in G. Then extend to degree 20, listing minimal transitive non-Oliver groups only, each with its half-split graph (§4): a loop settles the group, and only loop-free groups are candidate homes.

2. ~~Identify Illies's invariance group.~~ **Done** (§4): ℤ/12 as given, and the full symmetry group is S₃ × D₄ = T(12,28), which contains a 12-cycle. That is exactly what a monotone example could not have, by Proposition 1.

3. **Exhaustive searches at the two failing groups through degree 12: no counterexample.**

   | group | orbits on subsets | nontrivial invariant monotone properties | χ(Δ_P) = 1 | **non-evasive** |
   |---|---|---|---|---|
   | A₅ on 10 pairs | 40 | 3,176 | 112 | **0** |
   | T(12,162) | 66 | 77,819 | 336 | **0** (as §4 proves it must be) |

   Both are exhaustive over the invariant monotone properties, with evasiveness decided exactly by the standard recursion rather than by any χ screen. Since non-evasive ⟹ ℤ-acyclic ⟹ χ = 1, testing the χ = 1 class suffices.

   > **A trap worth recording, because it nearly produced a false positive.** The recursion is "non-evasive on a subcube iff constant there, or some variable splits it into two non-evasive halves", and *the base case must come first*: with no free variables D = 0, which is **not** less than 0, so a fully-queried subcube is evasive by convention. Testing constancy first returns True at every leaf and the True propagates to the root, reporting **every** function non-evasive — which is exactly what the first run of this search did, returning 336 of 336. The tell was the implausibility of the aggregate, not a control; controls (P = {∅} evasive, a one-variable function non-evasive, |S| ≤ 1 evasive) were added afterwards and pass. At T(12,162) the theorem of §4 now serves as that control too.

3a. **A₅ on 15 points — the smallest open degree, and where the acyclicity rung stops.** With N ≤ 14 verified in the literature (§4), degree 15 is the frontier, and by item 0 it reduces to the minimal transitive non-Oliver groups there — A₅ in its unique 15-point action (cosets of C₂², equivalently pairs of the 6-point PSL(2,5) action), provided the census confirms nothing else is minimal at that degree. `a5_on_15.py` applies every fixed-complex condition available: all proper subgroups of A₅ are Oliver, so Smith 𝔽_p-acyclicity at C₂, C₃, C₂², C₅ and χ ≡ 1 (mod q) at S₃, D₁₀, A₄, on the 254 of 688 subset-orbits that some subgroup fixes; plus χ(link v) ≡ 1 (mod 4), which the 434 free orbits (trivial stabiliser, size 60, contributing ±4k to the link) cannot repair. **The acyclicity rung is SAT**, with hundreds of touched-part solutions and the free part unconstrained — `small-degree-computation.md` §7's one-sidedness, one degree up. The completions tuned to χ = χ(link) = 1 and tested exactly (decision-tree recursion on 2¹⁵ subsets, 0.3 s each) were evasive; a sample, not a verdict. **But their actual homology was computed** — via Alexander duality, the dual complex having 1,151 faces — and every one is **ℚ-acyclic, acyclic mod 3, 5 and 7, and has 𝔽₂-homology of rank 4**: not ℤ-acyclic, with 2-torsion. That is one rung above where graph properties at n = 10 stand (χ = 1 with fixed-complex consequences, ℤ-acyclicity uncheckable at 12 million classes) and the same rung the chiral n = 5 candidate reached (ℝP²-like, ℤ/2). So the transitive world is where the metaproperty ladder has been climbed highest — by one rung — which is a statement about what is *computable* at 15 points, not yet about what exists. *(The apparent mod-60 constraint on χ(Δ) from the free orbits is redundant: Smith at the Sylow subgroups already forces χ ≡ 1 mod 3, 4, 5 by the Burnside congruences.)*

   **So n = 15 is open and not decidable by fixed-point methods.** Deciding it means climbing the ladder: non-evasiveness is checkable exactly per candidate but the candidate space is 2⁴³⁴.

   **The literature check (`literature-findings.md` §§25–28) answered the structural question and reframed the target.** Barmak–Minian (DCG 2012) prove that strongly collapsible complexes have the fixed-point property for automorphisms (Thm 6.2), that the core of a vertex-homogeneous non-evasive complex is vertex-homogeneous and non-evasive (Cor. 6.13), and hence that the conjecture reduces to **minimal** complexes (no dominated vertex). On 15 vertices the core would have 3, 5 or 15 vertices and the first two are prime-power cases where the conjecture is a theorem, so **any counterexample at A₅ on 15 is itself minimal** — a cheap necessary condition, now checked (both tuned candidates are minimal, and so are their Alexander duals). And Lutz (DCG 2002) shows the ladder for vertex-homogeneous complexes already fails to collapse at ℤ-acyclic *and* contractible: the smallest known contractible vertex-homogeneous non-simplex has **60 vertices** — the regular A₅-set that item 0's inflation argument singled out — and dimension 11. Benedetti–Lutz 2013 could not settle its collapsibility by random Morse; its evasiveness is settled below.

   *Integer torsion, computed.* Smith normal form on the 1,151-face dual gives boundary-map torsion exactly **(ℤ/2)⁴** in one degree — the 𝔽₂-Betti rank 4 is genuine 2-torsion, not a mod-2 artefact of free classes. Consistent with Lutz 2001's bound (no ℤ-acyclic vertex-homogeneous complex of dimension ≤ 3; the dual here is 5-dimensional) and with the Sylow observation that every non-solvable group contains C₂ × C₂, making 2-torsion the cheapest way for an A₅-complex to clear every fixed-complex condition and still fail ℤ-acyclicity.

   *An attempted "small-side" search did not work, and the reason is recorded in `a5_on_15.py --small`'s help text*: the C₂ Smith condition spans 248 of 254 touched orbits and fires only at the leaf, so trying OUT first on large sets explores an exponential tree of small assignments that all fail it, while IN-first lands on near-full complexes almost immediately. A genuine small-side search needs an incremental acyclicity test on partial C₂ lattices. Meanwhile homology is computed on whichever side is smaller, so the near-full leaves already *are* the small side seen from the other end.

   **The 60-vertex Lutz complex was then tested, and it is EVASIVE — by a two-line argument, not a search** (`lutz30.py`). Its 441 published facets are exactly {a ∪ (b+30)} for a, b over one family of 21 sets on {1..30}: **it is a join K = A ∗ A′**, A being Lutz's 5-dimensional ℤ-acyclic example on 30 vertices (the A₅ action on cosets of C₂; f = (30, 195, 340, 255, 96, 15), χ = 1, 𝔽₂-acyclic, every vertex in 4 facets). By Welker (1999) a join is non-evasive iff a factor is, so K is non-evasive iff A is. And **every vertex link of A has χ = 0**, where a non-evasive complex needs a vertex with a non-evasive, hence ℤ-acyclic, hence χ = 1 link. The exact recursion confirms in 31 nodes.

   *Two lessons.* (i) **The join hides the obstruction**: for v on the A-side, lk_K(v) = lk_A(v) ∗ A′ and reduced Euler characteristics multiply under join, so χ(lk_K v) = 1 and the link test on K itself passes — one must factor first. **Check any candidate's facet set for a product structure before running anything expensive.** (ii) The real object was **30 vertices** — the third of the 15/20/30 A₅ targets — and it is the first complex in the programme to clear *every* counting condition (being ℤ-acyclic) and fail at the first non-counting one. A non-evasive vertex-homogeneous complex must have a vertex whose link is itself ℤ-acyclic; A's are not.

   **What A is, group-theoretically** (`lutzA.py`; Lutz 2002 is paywalled, so this was recovered from the facets): Aut(A) = A₅ acting on A₅/C₂ — the 30 edges of the icosahedron — and the 21 facets are **orbits of the three classes of maximal subgroups**: the 6 D₁₀'s each give a 5-set (stabiliser order 10), the 5 A₄'s each give a 6-set (stabiliser order 12), the 10 S₃'s each give a regular 6-set (stabiliser order 6). So A is an **orbit complex**: vertex set G/K, facets = G-orbits of H-orbits for subgroups H. This is exactly the shape of the involution-quotient proposal below, with the maximal subgroups in place of the Sylow-2's — and it is what makes the difference between χ = −165 and ℤ-acyclic.

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

   **The two-subgroup family was then coded and run** (`twosub.py`; facets = G-orbits of H₁·x ∪ H₂·y, which contains orbit complexes as the case H₂ = H₁, y = x). It was proposed because orbit complexes' facet sizes *are* subgroup-orbit sizes, so balance and an acyclic link compete for the same few degrees of freedom; two-subgroup faces decouple them. **The decoupling works and does not help.** On 69,140 unions across four A₅-sets: χ = 1 at 3.8% (against 0.96% for orbit complexes) and, of those, 22.4% pass the link test (against 5.4%) — and at 15 and 10 points, where orbit complexes gave **zero** link-test survivors, this family gives 15 and 68. So the extra freedom does exactly what it was predicted to do. **All 592 survivors then fail 𝔽₂-acyclicity, without exception.**

   **The 30-point set was then run** (A₅/C₂, the set Lutz's A lives on; k ≤ 2 types, faces ≤ 10): 1,408 face-orbit types, **991,936 unions**, χ = 1 at **4,170** (0.42%), link test passed by **1,800 of those (43%)** — and **all 1,800 fail 𝔽₂-acyclicity.** Two things in the numbers. The link-pass rate is the highest yet measured, 43% against the orbit complexes' 8% on the same set, so the decoupling is doing even more at 30 points than at 15 and 10 — and it still delivers nothing. And the χ = 1 rate is *lower* than on the smaller sets (0.42% against 3.8%), the same direction as PSL(2,7): more types to balance, rarer coincidence.

   **Running total across both families, both groups, every set tried: 1,647,681 complexes, 2,630 clearing both Euler tests, zero 𝔽₂-acyclic.** Widening the family tripled the number of candidates reaching the homological test, and the 30-point run alone more than tripled it again; nothing changed. That is the evidence that 2-torsion is not an artefact of how narrow the orbit-complex family was — every one of 2,630 complexes that clears every counting condition on every A₅-set carries it.

   **Degree 20 as a bare CSP would hit the same wall and is not worth running**; the orbit-complex search above is the version of it that is.

   **The involution-quotient complex, and what fusion does to it** (`psl27.py`). The proposal "f(S) = 1 iff every pairwise quotient is an involution" on a regular G-set has faces = subsets of left cosets of the elementary-abelian 2-subgroups generated by pairwise-commuting involutions. On A₅ these are the 5 Klein groups, which are TI, so the 75 tetrahedra meet only in vertices and the complex is homotopy equivalent to the vertex–coset incidence graph: χ = −165. The suggestion was that a group with **non-trivial 2-fusion** might do better. On PSL(2,7) (order 168, Sylow D₈, 21 involutions, 14 Klein groups in two classes of 7, each involution the centre of its D₈ centraliser and hence in exactly 2 Klein groups): f = (168, 1764, 2352, 588), **χ = 168 = |G|**, reduced 𝔽₂-Betti (0, 34, 201, 0). **Every one of the 1,764 edges lies in exactly two tetrahedra** — the fusion glues the tetrahedra along edges — so there are no free faces at all, the complex is not collapsible, and it has a 201-dimensional H₂. Fusion made it worse: it created 2-cycles where A₅ had only 1-cycles.

   *The general obstruction is arithmetic.* For a coset complex of one conjugacy class the per-vertex Euler characteristic is 1 − i/2 + 3k/4 (i involutions, k Klein groups), so χ = |G|·(rational with denominator ≤ 4) — it equals |G| for PSL(2,7), −165 for A₅, and can never equal 1 for |G| > 4. Acyclicity needs faces of *several* orbit types whose sizes balance, on a *non-regular* set, which is exactly what Lutz's A does with three maximal-subgroup classes on 30 points. Fusion is not the missing ingredient; balance is.

   **Does Lutz's recipe generalise?** Stated group-theoretically, A is: vertex set G/⟨t⟩ for an involution t (each point carries its own involution xtx⁻¹, two points per involution); facets = the *own-involution* orbits of the maximal subgroups — the H-orbit of a point has size |H|/2 exactly when the point's involution lies in H; one G-orbit chosen where a subgroup has two. Nothing platonic in that; the icosahedron is what it looks like for A₅. **By the nerve theorem A ≃ the nerve of its facets** (all intersections are simplices), so acyclicity is a property of how maximal subgroups meet on involution cosets: χ(A) = Σₖ(−1)^{k−1}·#{k-sets of facets sharing a point} = 21 − 110 + 120 − 30 = 1. Through every point pass one D₁₀-, one A₄- and two S₃-facets, and **the link of a vertex is the nerve of those four, which is a 4-cycle** (pairwise intersections of sizes 3,3,2,2 beyond the vertex; 1,1 for the other two pairs): lk(v) ≃ S¹, χ = 0. That is the mechanism of A's evasiveness in one sentence.

   *On PSL(2,7) the recipe fails, for a structural reason* (`psl27.py`, `psl27_orbit.py` on G/C₂, 84 points). Only involution-bearing maximal classes can contribute own-involution orbits; C₇:C₃ has none and drops out. The two S₄ classes each give 7 facets of size 12 that **partition** the 84 points, and a facet of one class meets a facet of the other iff the corresponding point and line of the Fano plane are incident — so the nerve is the **Heawood graph**, χ = 14 − 21 = −7, b₁ = 8. Not acyclic, and no choice within the recipe changes it. So the construction is not generic: it needs every maximal class to carry involutions *and* the Möbius-type sum over their incidences to come out to 1, which is a Diophantine coincidence A₅ happens to satisfy. Whether Lutz 2002's "further higher-dimensional examples" realise it for other groups could not be checked (paywalled). **Where it does generalise, evasiveness reduces to the local nerve at a point — the incidence structure of the maximal subgroups containing one involution — and non-evasiveness would need that to be acyclic at some vertex and recursively below**; for A₅ it is a circle.

   **Orbit complexes on PSL(2,7), all six transitive sets** (`psl27_orbit.py`):

   | G/K | k | tried | χ = 1 | χ(link) = 1 | **survive** |
   |---|---|---|---|---|---|
   | 21 (G/D₈) | ≤ 4 | 5,035 | **0** | — | 0 |
   | 28 (G/S₃) | ≤ 4 | 24,157 | 105 | **0** | 0 |
   | 42 (G/order-4) | ≤ 3 | 8,473 | **0** | — | 0 |
   | 56 (G/C₃) | ≤ 3 | 24,857 | 16 | **0** | 0 |
   | 84 (G/C₂) | ≤ 3 | 57,225 | **0** | — | 0 |
   | 168 (regular) | ≤ 2 | 10,011 | **0** | — | 0 |
   | **total** | | **129,758** | **121** | **0** | **0** |

   **121 with χ = 1 and not one with χ(link) = 1** — so on this group nothing ever reached the homological filter. **The failure mode inverts between the two groups.** On A₅, counting leaves 238 candidates and 𝔽₂-acyclicity kills all of them; on PSL(2,7) the χ = 1 rate is ten times lower (0.093% against 0.96%) and the link test alone finishes the job. The larger group has more subgroup classes, hence more distinct orbit sizes, hence a harder balance problem: **richer structure makes the coincidence rarer, not commoner** — the same conclusion the involution-complex comparison reached independently.

   *One near-theorem, and why it is not one.* On PSL(2,7), χ = 1 occurs only when 3 divides |K| — never on the four sets with 2-group stabilisers. The natural explanation is Smith: no conjugate of a 2-group contains C₃, so C₃ has no fixed vertices, the fixed complex is empty, and χ ≡ 0 (mod 3). **That is wrong**, and A₅ refutes the rule — its 15-, 30- and 60-point sets have 2-group stabilisers and yield 27, 736 and 3,420 complexes with χ = 1. The fixed *space* |Δ|^{C₃} is built from **setwise**-invariant faces, being the fixed subcomplex of the barycentric subdivision, not from fixed vertices: checked on an A₅ 15-point example, there are no C₃-fixed vertices but exactly one setwise-invariant face, giving χ(|Δ|^{C₃}) = 1 in agreement with χ(Δ) = 1. A useful trap to have walked into, since the pointwise reading would have "proved" several of these sets vacuous.

   *Two bugs on the way, both predicted by existing text.* An early return inside the pend-decrement loop produced 36 spurious "solutions" (the false-SAT bug `stage4_fast.py`'s comment describes); and the exact recursion first returned True on a fully-queried subcube, declaring a "counterexample" in 0.0 s (the base-case trap of item 3's box). Both times impossible speed was the tell. Both fixed, controls passing.

4. **Run the CSP against Illies's example — with the monotonicity constraint switched off.** The whole `small-degree-computation.md` pipeline applies with the coordinate action in place of the pair action, and the object is much smaller: 12 coordinates rather than 45 or 66, and 2^12 subsets rather than 12 million isomorphism classes. But the target is a **set-system** counterexample, not a monotone one (§4), so the run must enumerate all invariant properties with ∅ ∈ P, X ∉ P rather than the monotone ones. **If the unconstrained run reproduces a non-evasive property, the pipeline is validated against a known counterexample** — a control it has never had. Illies's family itself is now explicit (§4, `illies12.py`); the exact recursion already finds D = 11 on it, so it is a positive control for that layer. (`small-degree-computation.md` §10 item 7 asks for a negative control of the same kind for the adversary game against Adamaszek's ℰ; this one exercises the CSP-and-χ layers, which that control does not reach.)
5. **The sharpening question.** A counterexample must live at a minimal transitive group with no transitive Oliver subgroup and a loop-free half-split graph (§4). Through degree 14 those are A₅ on 10 points (searched exhaustively, item 3) and PSL(3,2) and PSL(2,13) on 14 points, with M₁₂ and 2⁶:S₇ undecided. What such a group's structure provides that Sₙ acting on pairs cannot is the comparison that would sharpen the distinction between the two settings.

> **What is not worth doing** is trying to improve the general-transitive bound with the δ apparatus. §2 says why: the machinery is a substitute for a transitive Oliver subgroup, and where one exists the answer is already exact, while where none exists the machinery has nothing to act on either.

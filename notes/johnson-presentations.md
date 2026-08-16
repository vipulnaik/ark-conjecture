# Johnson presentations: when a transitive action is secretly an action on k-subsets

*Companion to `monotone-transitive-note.md`. That document shows the μ(n) apparatus contributes nothing to the general transitive case, because there the group acts on the coordinates directly and the Oliver argument closes at once. This one identifies the structural feature that puts an action back into the regime where the apparatus **is** the right tool — namely, that the coordinate set is the set of k-subsets of a smaller set the group also acts on. Graph properties are the case k = 2; the point of the abstraction is that nothing about S_n is needed to state it.*

**Status.**

| section | standing |
|---|---|
| §1 the definition | definitional |
| §2 recognition, and the intersection axioms | **classical** (Chang, Johnson-graph characterisations); the parameters verified here |
| §3 the reduction proposition | **proved**, one line |
| §4 what the reduction costs: the "inside G" subtlety | **proved**; A₅ worked in full |
| §5 how large G must be | **proved** (necessary bound, tight at prime powers); sufficiency **open** |
| §6 limits, and what this does not do | commentary |

---

## 1. The definition

Let G act transitively on Ω, so Ω ≅ G/H for H a point stabiliser.

> **Definition.** A **k-Johnson presentation** of (G, Ω) is a subgroup K ≤ G such that, writing X = G/K and m = [G : K],
>
> 1. G acts **k-homogeneously** on X (transitively on k-subsets), and
> 2. H is the **setwise stabiliser in G of a k-subset of X**.
>
> Then Ω ≅ X^{(k)} as G-sets and |Ω| = C(m, k). Call m the **base size** and k the **arity**.

Everything is stated inside the subgroup lattice of G — no ambient symmetric group appears — so A_m, AGL(1, m) and every other k-homogeneous group are covered on the same footing as S_m. That is the point of the definition: **arity is an intrinsic invariant of a permutation group, not a feature of how the problem was presented.**

**Graph properties are the case k = 2 with X the vertices**, and the coordinates are edges. Chiral graph properties are the same with G ≤ A_m. The k-uniform documents are arity k. And `monotone-transitive-note.md`'s general setting is the degenerate case k = 1, where X = Ω and the action is already transitive on coordinates — which is exactly why the Oliver argument closes there without any machinery.

---

## 2. Recognition: the intersection axioms and the Johnson graph

A presentation is recoverable from the action on Ω alone, which makes the definition checkable rather than merely descriptive.

For each x ∈ X the **star** S_x = {ω ∈ Ω : x ∈ ω} is a subset of Ω, and at k = 2 the stars satisfy:

> - every ω ∈ Ω lies in exactly **2** stars (its two endpoints);
> - two distinct stars meet in exactly **one** point of Ω (the edge joining them);
> - |S_x| = m − 1 for every x.

Those are the axioms of a **partial linear space**, and the point–line duality between X and the stars is what lets one recover X from Ω — the "vertex ↔ edge duality" that makes the recovery work in both directions. The orbital graph "ω, ω′ share a vertex" is then the **triangular graph T(m)**, the line graph of K_m, which is the **Johnson graph J(m, 2)**.

*Verified:* at m = 5, 6, 7 the induced action of S_m on C(m,2) coordinates gives a graph of degree exactly 2(m−2) = 6, 8, 10, and every pair of stars meets in exactly one point.

**And recognition is decidable from the parameters, with a known finite exceptional list.** T(m) is strongly regular with parameters determined by m, and **Chang's theorem** says a strongly regular graph with those parameters *is* T(m), with exactly three exceptions at m = 8 — the Chang graphs. More generally the Johnson graphs J(m, k) are determined by their intersection arrays up to known exceptions. So:

> **To test whether (G, Ω) has a 2-Johnson presentation: compute the orbital graphs of G on Ω and check whether one of them is a triangular graph.** The answer is determined by the parameters except at m = 8.

---

## 3. The reduction

> **Proposition 1.** Suppose (G, Ω) has a k-Johnson presentation over X with base size m. Then G has a **transitive Oliver subgroup on Ω** if and only if G contains a subgroup that is **Oliver and k-homogeneous on X**.
>
> *Proof.* If Γ ≤ G is Oliver and k-homogeneous on X then it is transitive on X^{(k)} = Ω. Conversely a transitive Oliver subgroup of Ω is transitive on k-subsets of X, i.e. k-homogeneous. ∎

**That is the whole content of the abstraction, and it is a genuine collapse of the search space**: from a set of size C(m, k) ≈ m^k/k! down to one of size m. At k = 2 the base set of m points buys ~m²/2 coordinates — the "square" that makes the graph case tractable at all.

And it identifies precisely which classical result does the work at each arity:

> **Solvable + k-homogeneous is a severe constraint.** At k = 2, a solvable 2-homogeneous group has **prime-power degree** — so the criterion fires at m = p^a via AGL(1, p^a) and has nothing to offer otherwise. At k ≥ 3 the constraint is worse: solvable 3-homogeneous groups exist only at degrees 3, 4, 5, 8, 32 (Kantor), and by Livingstone–Wagner there are none at all for 5 ≤ k ≤ m/2. This is `three-uniform-note.md`'s finding restated: the **constants** die with arity because the k-homogeneous solvable groups die.

> **So the arithmetic of the problem enters at the base size m, not at the coordinate count.** That is the cleanest statement of where number theory comes into this programme: it is the arithmetic governing which k-homogeneous Oliver groups exist at degree m, and it lives one level below the object being studied.

**When the criterion fails, μ(m) is the fallback.** No k-homogeneous Oliver subgroup means no single orbital, and the question becomes how large the *minimum* orbital can be — which is exactly μ(m)/C(m,2) and the entire apparatus of `enumeration-proof.md` and `arithmetic-of-density.md`.

---

## 4. "Inside G" is not a formality: the A₅ example

The proposition says G must **contain** a group that is Oliver and k-homogeneous. It is tempting to read this as a condition on m alone — m a prime power, take AGL(1, m) — and that reading is wrong.

> **A₅ acting on the 10 pairs of {1,…,5}** has a 2-Johnson presentation with base size **m = 5, a prime power**. Yet it has **no** transitive Oliver subgroup at all: its only transitive subgroup on the 10 pairs is itself, and A₅ is insoluble.
>
> The reason is exactly the "inside G" clause. The 2-homogeneous Oliver group at m = 5 is AGL(1,5) = C₅ ⋊ C₄, and its full-order twist x ↦ 2x is a 4-cycle on 𝔽₅^× — an **odd** permutation. So **AGL(1,5) ⊄ A₅** (verified). The largest twist available inside A₅ has order (5−1)/2 = 2, giving C₅ ⋊ C₂ = D₁₀, whose orbitals on pairs are **[5, 5]** rather than [10] (verified). The action is 2-homogeneous but no *Oliver* subgroup realising that is present.

**This is the mod-4 phenomenon of `chiral-graph-properties.md` seen through the presentation.** For odd prime power c the full twist is always odd, so the largest admissible twist inside the alternating group is (c−1)/2, and whether that is still 2-homogeneous turns on **c mod 4**: yes at c ≡ 3, no at c ≡ 1. A₅ is the smallest instance of the failing class, and it is where the ℝP² candidate of `pending-checks.md` R10 lives — not a coincidence, but the same fact twice.

> **So the criterion has three inputs, not one:** the base size m, the arity k, and **which subgroups of G are actually present**. The third is invisible if one thinks only about S_m, which is why the abstraction is worth stating: S_m contains every candidate, so the subtlety only becomes visible once G is allowed to be smaller.

---

## 5. How large must G be?

Two different questions hide here, and separating them answers one and opens the other.

**The necessary bound, and it is tight.** A Γ-orbital has size at most |Γ| by orbit–stabiliser, so a conclusion δ·C(m,2) for the minimum orbital requires

> **|G| ≥ |Γ| ≥ δ·C(m, 2) = Ω(m²).**

At prime power m this is **tight up to a factor of 2**: AGL(1, m) has order m(m−1) = 2·C(m,2) and achieves δ = 1. So the smallest group that can possibly give a single orbital is essentially the classical one, and no smaller host can help.

**But order is not sufficient, and the gap is structural.** C_m ⋊ C_d is transitive of order md for any d | m − 1, and its orbitals have size about md/2, giving δ ≈ d/m → 0 for small d. What the framework needs is not a large group but a **large twist**: a subgroup of AΓL(1, c) type on each block with the multiplicative part of near-maximal order, together with the element fusing the blocks. §4 is the sharp illustration — A₅ has all the ingredients except that the twist is capped at order 2.

> **An open gap worth naming.** The necessary bound is Ω(m²), but the multi-block constructions use groups polynomially larger: the bottom layer alone is (𝔽_c)^F of order c^F, so a two-part configuration already carries |Γ₂| ≫ m² before the cyclic and top layers are counted. **Nothing in the framework explains that excess.** Either there are much smaller Oliver groups achieving constant δ at composite m — which would widen the class of G to which the argument applies — or the Ω(m²) bound is far from achievable off prime powers and a better lower bound is available. The question is self-contained:
>
> **What is the minimum order of an Oliver group on m points whose minimum orbital is ≥ δ·C(m,2), for m not a prime power?**
>
> `mu_enumerate_v2.py` could answer it over the computed range: it already enumerates every configuration with its density, and would only need each configuration's group order recorded alongside.

---

## 6. What this does not do

**Most transitive actions have no Johnson presentation.** The condition on H — that it be a setwise k-set stabiliser in a larger transitive action of the same group — is strong, and fails generically. **T(12,162) has none**, which is why `monotone-transitive-note.md` had to attack it by direct search over the subgroup lattice rather than by any reduction. So this classifies a special family; it is not a general method.

**The reduction is an "iff" only along the Johnson route.** A group may have a transitive Oliver subgroup arising in a way that has nothing to do with k-homogeneity — the degree-2p construction of `monotone-transitive-note.md` §3, an elementary abelian 2-group extended by a p-cycle, is exactly such a case, and it settles A₂ₚ with no Johnson presentation in sight.

**And the honest summary of what the abstraction buys.** It does not prove anything new. What it does is locate, in one statement, *where* each ingredient of the programme acts: the arity k fixes which homogeneity is required and hence which classification applies; the base size m carries the arithmetic; and the containment condition carries the parity and chirality subtleties. Read that way, several results become instances of one pattern rather than separate phenomena —

> - KSS at prime powers = the criterion firing at k = 2, m = p^a;
> - the collapse of constants at k ≥ 3 = the k-homogeneous solvable groups running out;
> - the chiral mod-4 split = the containment condition failing inside A_m;
> - μ(n) itself = what remains when the criterion fails and one must settle for a minimum orbital rather than a single one.

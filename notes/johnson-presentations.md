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

**This is the mod-4 phenomenon of `chiral-graph-properties.md` seen through the presentation.** For odd prime power c the full twist is always odd, so the largest admissible twist inside the alternating group's *linear* part is (c−1)/2, and whether that is still 2-homogeneous turns on **c mod 4**: yes at c ≡ 3, no at c ≡ 1. A₅ is the smallest instance of the failing class, and it is where the ℝP² candidate of `pending-checks.md` R10 lives — not a coincidence, but the same fact twice. *(At c = p^a with a ≥ 2 the containment question is not settled by that congruence: a **semilinear** subgroup can be 2-transitive, even and Oliver where no linear one is, which is what rescues c = 9, 49, 81, 121 — see `chiral-graph-properties.md` §4. The presentation reading is unchanged; what changes is which m fall in the failing class, and it is a thinner set than c ≡ 1 (mod 4).)*

> **So the criterion has three inputs, not one:** the base size m, the arity k, and **which subgroups of G are actually present**. The third is invisible if one thinks only about S_m, which is why the abstraction is worth stating: S_m contains every candidate, so the subtlety only becomes visible once G is allowed to be smaller.

---

## 5. How large must G be?

Two different questions hide here, and separating them answers one and opens the other.

**The necessary bound, and it is tight.** A Γ-orbital has size at most |Γ| by orbit–stabiliser, so a conclusion δ·C(m,2) for the minimum orbital requires

> **|G| ≥ |Γ| ≥ δ·C(m, 2) = Ω(m²).**

At prime power m this is **tight up to a factor of 2**: AGL(1, m) has order m(m−1) = 2·C(m,2) and achieves δ = 1. So the smallest group that can possibly give a single orbital is essentially the classical one, and no smaller host can help.

**But order is not sufficient, and the gap is structural.** C_m ⋊ C_d is transitive of order md for any d | m − 1, and its orbitals have size about md/2, giving δ ≈ d/m → 0 for small d. What the framework needs is not a large group but a **large twist**: a subgroup of AΓL(1, c) type on each block with the multiplicative part of near-maximal order, together with the element fusing the blocks. §4 is the sharp illustration — A₅ has all the ingredients except that the twist is capped at order 2.

> **The group order and the minimum orbital improve together, and both are functions of one variable: F, the block count.** This is not a story about anyone choosing a better group. In BBKN's own §4.1 construction the bottom layer is the additive group of the blocks, of order c^F with c = p^a and F = k — so **c^F is the price of the fusion count** — while the minimum orbital is Ω(p^{2a} m_k) = Ω(nc). Driving F down raises the orbital *and* collapses the bottom layer at once, because both are read off F. There is no trade-off to make.
>
> **And what drives F down is the number theory available, nothing else.** BBKN's §5.1 already uses the n = pk + r shape; only the unconditional case is forced to F = n/Q(n), because that is all Vinogradov/Haselgrove licenses.
>
> | route | what fixes the block count | F at n = 510,510 | orbital | log10 of the c^F layer |
> |---|---|---|---|---|
> | BBKN §4.4, unconditional | F = n/Q(n) | 30,030 | n log n | ~36,950 |
> | BBKN §5.3, under ERH | p ~ n^{1/4} | 19,098 | n^{5/4-e} | ~27,023 |
> | BBKN §5.4, under Chowla | p ~ n^{1/2} | 714 | n^{3/2-e} | ~2,038 |
> | Shparlinski 2014 | p ~ n^{1/2}, unconditional | 714 | n^{5/4+o(1)} | ~2,038 |
> | **this framework, under (BCG-AL)** | **F <= 16** | **16** | **d_0 n^2** | **~72** |
>
> So each rung of `arithmetic-of-density.md` §3.6's ladder buys down F, and the group order follows for free. **The framework's contribution here is a bounded F**, which is what turns c^F from superpolynomial into O(1) factors and the order into a polynomial — log|G|/log n between 2.9 and 9.7 on a sample across [2*10^4, 10^6], typically 3.5–4.5.
>
> > **One genuine inefficiency, and it costs *both* order and orbital.** The block-permuting group must be a product of cyclic groups of prime order, over k written as t <= 4 roughly equal primes — Vinogradov again — where **a single entangled generator of order F(c-1) would do**. Two separate losses follow.
> >
> > **On the orbital, a constant factor t.** Under a product of prime-order cyclics, a pair inside one block has its orbit closed only under the factor acting on *that part*, so it sweeps p_i blocks rather than all k: m_intra = (min_i p_i)*C(c,2) ~ (k/t)*C(c,2), against k*C(c,2) under full fusion. **Fusion happens on the smallest prime chosen, not on k.** Measured: 39,160 against 121,396 at n = 2759 (ratio 3.10), and 1,020,952 against 4,084,080 at n = 510,510 (ratio 4.00).
> >
> > **On the order, a factor about k^{t-1}/t^t** — the product of the p_i against our single F — measured at 10^1.5 at n = 2759, 10^7.7 at n = 30,030 and 10^11 at n = 510,510.
> >
> > *Neither loss moves an Ω(n log n) statement — a constant on the orbital and a polynomial-in-k factor on the order are both invisible at big-O level — which is exactly why the point went unremarked rather than being missed.*

### 5a. The minimum order, answered: the exponent is 2, 3, 4 or 5, and parity decides between the last two

**Question.** What is the minimum order of an Oliver group on n points whose minimum orbital is ≥ δ·C(n,2), for fixed δ > 0? The necessary bound is Ω(n²), since every orbital size divides the order.

> **Answer, within the shape space.**
>
> | n | minimum \|Γ\| | construction |
> |---|---|---|
> | prime power | Θ(n²) | AGL(1, n) |
> | a prime-power divisor c ≥ δ′n (bounded cofactor; density zero) | Θ(n³) | Reed–Solomon translations, below |
> | almost all **even** n | **Θ(n⁴)** | one matching block + one foreign block |
> | almost all **odd** n | **Θ(n⁵)** | two fused matching blocks + one foreign block |
>
> *Status.* The lower bounds are proofs **modulo Part 0** of `enumeration-proof.md` (every Oliver group meeting the floor lies in the shape space) and **modulo the three short lemmas below, which are sketched and have had no independent reading**. The upper bounds for generic n are **conditional** on the framework's bounded-cofactor Goldbach supply — the same hypothesis μ(n) itself rests on — and are verified on the table to 10⁶. "Almost all" means outside explicit density-zero exceptional sets, described at the end.

**The method: count the roles a group must fill, and show they cannot overlap.** The divisibility bound |Γ| ≥ lcm(orbital sizes) of the earlier draft was the wrong tool — its edge case (all orbitals equal) was never the real obstruction. What forces the order up is that a block-structured group needs several *independent* subgroups, each of size Θ(n):

- **translations** on each block, to make it one vertex-orbit;
- a **twist** (multipliers) on each block, to fuse its intra pairs into orbitals of size ≥ δn² — which forces the twist to have order ≥ δn, since an intra orbital on a block of size c has size c·d/2 with d the twist;
- and, where there are two or more blocks of the same prime, translations that **distinguish** them.

The per-axis bound (`enumeration-proof.md` G.4) makes every block size ≥ δn/2, since a cross orbital between blocks of sizes a and b has size at most ab.

**Lemma 1 (distinguishing translations cost c²).** *If two blocks i, j of the same prime-power size c lie in one fused class, the translation subgroup T projects **onto** F_c² on i × j; so |T| ≥ c².* Otherwise the projection P is a line or trivial, and the rest of Γ acts on the quotient F_c²/P ≅ F_c affinely **without translations** — an element acting there as a translation would, raised to the order of its linear part (coprime to c), give a translation of F_c² outside P. An affine group of order coprime to c fixes a point of F_c, and the P-coset over that point is a union of orbits of total size c. Every cross orbital through it then has size at most (number of block pairs)·c = O(n), below δn².

**Lemma 2 (a matching twist cannot share with foreign translations).** *In a configuration with a matching block of prime size c and a foreign block of prime size r, the cyclic layer Γ₁/Γ₂ contains elements acting as the matching twist (order d) and as the foreign translations (order r), and gcd(d, r) = 1 is forced; so |Γ₁/Γ₂| ≥ d·r.* The top q-group acts on the cyclic layer by z ↦ z^k. On the foreign block it must act as a nontrivial multiplier m of the translations, so k ≡ m ≠ 1 (mod r); on the matching block, conjugating a multiplier by an affine map leaves it unchanged when c is prime, so k ≡ 1 (mod d). If r | d the two congruences contradict. *(When c = p^a with a ≥ 2 a Frobenius twist relaxes the second congruence — a thin case, among the exceptions below.)*

**Lemma 3 (the foreign twist stands apart).** *The foreign twist lies in the top layer and the matching translations act trivially on the foreign block.* The first is `enumeration-proof.md` Lemma D2q (a foreign twist in the cyclic layer, beside the translations, is trivial). For the second: Γ₂ is a p-group normal in Γ₁, and a nontrivial action on the foreign block would be by multipliers, whose conjugates by the foreign translations are translations — putting r-elements in a p-group.

**Lower bounds.** *Even n, one matching block + one foreign:* translations c, matching twist d ≥ δn, foreign translations r, foreign twist t ≥ δn (from rt ≥ δn²), pairwise independent by Lemmas 2 and 3 — so |Γ| ≥ c·d·r·t = Ω(n⁴). *Odd n:* a single matching block plus a foreign one has c + r even unless c = 2^a, so generic odd n needs two fused matching blocks, and Lemma 1 turns their translations into c²: |Γ| ≥ c²·d·r·t = Ω(n⁵). *Every alternative at generic n costs at least as much:* a matching block plus two foreign ones has c·d·r₁·r₂·t = Ω(n⁵); more fused blocks only enlarge T; and configurations whose twists could share (two or three foreign blocks under one q-group, or a matching twist moved to the top beside the foreign one) need a common large q-power in several of c − 1, rᵢ − 1, which forces a large prime-power divisor on n − 2 or n − 3 — a density-zero condition.

**Upper bounds.** The recorded witnesses realise them, and the measured orders sit in fixed bands across five decades:

| shape (generic) | order / n⁴, median by decade 10² → 10⁶ | order / n⁵, median by decade 10² → 10⁶ |
|---|---|---|
| even, `1xc + 1xr*` | 0.0305 → 0.0311 → 0.0312 → 0.0312 | — |
| odd, `2xc + 1xr*` | — | 0.00423 → 0.00343 → 0.00198 → 0.00196 |

*So the "exponent between 2.9 and 9.7, typically 3.5–4.5" measured earlier was never a fractional exponent:* it is n⁴ times about 1/32 at even n and n⁵ times about 1/500 at odd n, seen through log|Γ|/log n at finite n (e.g. 4 − log 32/log 10⁵ ≈ 3.7).

**The Θ(n³) case, and where our witnesses were wasteful.** At n = F·c with F | c − 1, index the blocks by a subgroup H ≤ F_cˣ of order F and take translations (i, y) ↦ (i, y + a + b·i) — a **two-dimensional Reed–Solomon code**, of order c², projecting onto every pair of blocks by Vandermonde — with one entangled generator (i, y) ↦ (h·i, λ·y). The chain is T (elementary abelian p-group), Γ/T = ⟨z⟩ cyclic, top trivial; |Γ| = c²(c − 1). *Built and verified:* n = 21 = 3·7 gives order 294 against the witness's c^F·F(c−1) = 6,174; n = 55 = 5·11 gives 1,210 against 8,052,550; n = 39 = 3·13 gives 2,028 against 79,092 — each with minimum orbital a constant fraction of C(n,2). By Lemma 1 no block-structured group does better, since two blocks already need c² translations and the twist needs δn more. **Our witnesses spend c^F where c² suffices** — they use independent translations on every block, which is the natural construction and the wasteful one.

**The exceptional sets**, all of density zero: prime powers (exponent 2); bounded-cofactor n (3); odd n = 2^a + r with r a suitable prime (4, not 5); and n for which n − 2 or n − 3 carries a prime-power divisor from a prime whose powers reach [δn, n], where a shared top q-group can save a factor up to that divisor. The last condition has probability about |log δ|/log n per window of exponents, hence density zero.

> **What this explains about the framework.** The earlier question was why the constructions sit polynomially above Ω(n²). The answer is that Ω(n²) is only achievable with a single block, and every additional block that the arithmetic forces — one foreign block at even n, a second matching block at odd n — brings its own translations and twist, which the chain structure will not let it share. **The parity split in the order is the same parity split as in the shapes**: odd n needs the fused rung because c + r is even.

---

## 6. What this does not do

**Most transitive actions have no Johnson presentation.** The condition on H — that it be a setwise k-set stabiliser in a larger transitive action of the same group — is strong, and fails generically. **T(12,162) has none**, which is why `monotone-transitive-note.md` had to attack it by direct search over the subgroup lattice rather than by any reduction. So this classifies a special family; it is not a general method.

**The reduction is an "iff" only along the Johnson route.** A group may have a transitive Oliver subgroup arising in a way that has nothing to do with k-homogeneity — the degree-2p construction of `monotone-transitive-note.md` §3, an elementary abelian 2-group extended by a p-cycle, is exactly such a case, and it settles A₂ₚ with no Johnson presentation in sight.

**And the honest summary of what the abstraction buys.** It does not prove anything new. What it does is locate, in one statement, *where* each ingredient of the programme acts: the arity k fixes which homogeneity is required and hence which classification applies; the base size m carries the arithmetic; and the containment condition carries the parity and chirality subtleties. Read that way, several results become instances of one pattern rather than separate phenomena —

> - KSS at prime powers = the criterion firing at k = 2, m = p^a;
> - the collapse of constants at k ≥ 3 = the k-homogeneous solvable groups running out;
> - the chiral mod-4 split = the containment condition failing inside A_m;
> - μ(n) itself = what remains when the criterion fails and one must settle for a minimum orbital rather than a single one.

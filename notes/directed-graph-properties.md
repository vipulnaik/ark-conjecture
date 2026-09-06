# Directed and oriented graph properties: what the framework says, and what the literature already said

*Companion to `orbital-evasiveness-notes.md`, `enumeration-proof.md` and `arithmetic-of-density.md`. The k-uniform notes move along the arity axis and `monotone-transitive-note.md` moves off it entirely; this one moves sideways, to properties of the **ordered** pairs. It sits between the two: a digraph property is a monotone S_n-invariant property of the n(n−1) ordered pairs, so it is a special case of the general transitive setting and a generalisation of the graph case.*

**Status.**

| section | standing |
|---|---|
| §1 the object, and the literature | **settled by citation** — this is Karp's original formulation |
| §2 the halving theorem and when it is paid | **proved**; the twist-parity criterion verified computationally |
| §3 the directed ceiling table | **derived** from §2 by substitution into cap_F |
| §4 oriented graphs: the 2-cycle fiat | **proved**; monotonicity verified exhaustively at n = 3 |
| §5 the self-pairing collapse, and what it settles | **proved**; verified on the framework's own constructions and by exhaustive search at n = 3 |
| §6 open | a short list |

---

## 1. The object, and the literature check that should come first

A **digraph property** is a monotone family of subsets of the n(n−1) ordered pairs of distinct vertices, invariant under S_n. Loops are not excluded by fiat — they are simply not coordinates, the group acting on ordered pairs of *distinct* points.

> **This is not a generalisation of ARK. It is Karp's own statement, and KSS proved the prime-power case for it.** The literature check is the first thing to do here and it changes the whole enterprise: Kahn–Saks–Sturtevant's abstract opens *"The complexity of a **digraph** property is the number of entries of the vertex adjacency matrix of a digraph which must be examined in worst case"*, and the paper's summary of its own result is that Karp's conjecture is proved **"for the case of properties of graph and digraph properties on a prime power number of vertices."** Their paper's Karp-conjecture statement is "every nontrivial monotone digraph property is evasive" (numbered as such in that paper). The undirected reading is the one the field settled into; the directed one is the original.
>
> **So §§2–3 below are a re-derivation of constants, not a new theorem**, and the honest description of what the framework adds here is: the *quantitative* half. KSS settles prime powers for digraphs; what the μ apparatus contributes at composite non-prime-power n — a density floor and a Θ(n²) threshold — has a directed analogue, and §2 computes it. §§4–5 are a different matter: they concern **oriented** graphs, where the coordinate space is the same but the property is constrained, and there the answer is genuinely easier than the undirected case rather than harder.

**Why the digraph case is not simply harder than the graph case, which is the naive expectation.** More coordinates (n(n−1) against C(n,2)) sounds like more room for a counterexample. But the group acts on ordered pairs, and the relevant statistic is the minimum orbit on ordered pairs — the classical **orbital** — which is *larger* than the minimum orbit on unordered pairs, never smaller. §2 makes that exact.

---

## 2. The halving theorem, and the twist-parity criterion for when it is paid

Write μ_dir(n) for the maximum over Oliver groups Γ ≤ S_n of the minimum Γ-orbit on **ordered** pairs, and δ_dir = μ_dir/(n(n−1)).

> **Theorem D1.** For every n, **μ_dir(n) ≥ μ(n)**, and hence **δ_dir(n) ≥ δ(n)/2**.
>
> *Proof.* Fix Γ realising μ(n). Each Γ-orbit O on unordered pairs is the image of either one or two orbits on ordered pairs: the pair-orbit {x,y} ↦ {(x,y), (y,x)} is **self-paired** when some g ∈ Γ has g(x) = y and g(y) = x, in which case the ordered orbital above it has size 2|O|, and otherwise it splits into two ordered orbitals of size |O| each. Either way every ordered orbital has size **at least |O| ≥ μ(n)**. The ambient doubles, giving the density statement. ∎

So the whole apparatus transfers with a factor two, exactly as `chiral-graph-properties.md` Theorem 1 does — Θ(n²) is untouched, the conjectural floor 1/25 becomes 1/50, and the asymptotic constant 7 − 4√3 becomes at worst half of it.

**And the factor is paid on an explicit arithmetic condition, not everywhere.** For an affine block of size c with twist subgroup T of order d, the difference classes are the cosets of T, and the orbital on ordered pairs is self-paired exactly when −1 ∈ T. Since T is the unique subgroup of order d in a cyclic group, and −1 is the unique element of order 2:

> **−1 ∈ T ⟺ d is even.** So a block's intra orbital is self-paired iff its twist order is even, and the halving is paid exactly at **odd** twist.

*Verified* over every (c, d) with c ∈ {7, 11, 13, 17}: at even d the ordered orbitals are exactly twice the unordered ones (no density loss), at odd d they are equal (density halved), with no exceptions.

> **Which reprices the framework's own branches, and inverts one preference.** A matching block at full twist has d = c − 1, even for odd c, so **matching classes pay nothing**. A foreign block carries a twist of order t = q^e (Lemma B′), and there the parity is the top prime's: at **odd q** the twist is odd and the class is halved; at **q = 2** it is even and the class is not. So the Fermat branch (S5), which `aod` §3.2.3 shows is *weakly dominated* in the undirected world by cyclic-layer fusion at odd q, is the branch that pays no directed penalty. The directed problem does not simply scale the undirected one — it reweights which branch is worth taking.
>
> **Restated as an efficiency, this is the cleanest form.** The framework writes η = 2t/(r−1) for a foreign block, and the factor 2 has always looked like bookkeeping. It is not: it is the self-pairing. The directed efficiency is
>
> > **η_dir = t/(r − 1)**, with no factor of 2 and no case split,
>
> and η = η_dir at even t, η = 2·η_dir at odd t. **η_dir = 1 requires t = r − 1 a prime power, i.e. r a Fermat prime** — a finite supply — so the directed world has no generic full-efficiency branch at all, and the generic best is η_dir = 1/2 from a safe prime.

---

## 3. The directed ceiling table

The cap formula cap_F(η) = η/(1 + √(Fη))² is an optimisation over part sizes and is indifferent to what realises the terms, so it ports with η replaced by η_dir. Taking each class's undirected optimum (F, η) from `aod` §3.3.5 and halving η — the odd-q branch, which is what every class but the Fermat rows uses — and re-optimising F subject to the parity constraint (odd n needs even F):

| n mod 12 | undirected (F, η) | undirected cap | directed η | directed best F | **directed cap** | ratio (exact) |
|---|---|---|---|---|---|---|
| 0, 4, 6, 10 | (1, 1) | 1/4 | 1/2 | 1 | **3 − 2√2 = 0.1715729** | 12 − 8√2 = 0.68629 |
| 1, 9 | (2, 1) | 3 − 2√2 | 1/2 | 2 | **1/8 = 0.125** | (3 + 2√2)/8 = 0.72855 |
| 2, 8 | (1, 1/3) | (2−√3)/2 = 0.1339746 | 1/6 | 1 | **(7 − 2√6)/25 = 0.0840408** | 2(7−2√6)(2+√3)/25 = 0.62729 |
| 3, 7 | (2, 1/2) | 1/8 | 1/4 | 2 | **(3 − 2√2)/2 = 0.0857864** | 12 − 8√2 = 0.68629 |
| 5 | (2, 1/3) | 5 − 2√6 = 0.1010205 | 1/6 | 2 | **(2 − √3)/4 = 0.0669873** | (2−√3)(5+2√6)/4 = 0.66311 |
| 11 | (4, 1/3) | 7 − 4√3 = 0.0717968 | 1/6 | **2** | **(2 − √3)/4 = 0.0669873** | (2 + √3)/4 = 0.93301 |

*Each closed form is cap_F(η_dir) evaluated exactly and checked against the decimal to twelve places.* The derivations are one line each from cap_F(η) = η/(1 + √(Fη))²: at F = 1, η = 1/2 the denominator is 3/2 + √2 and the cap is 1/(3 + 2√2) = 3 − 2√2; at F = 1, η = 1/6 it is 1/(7 + 2√6) = (7 − 2√6)/25; at F = 2, η = 1/4 it is 1/(6 + 4√2) = (3 − 2√2)/2; at F = 2, η = 1/6 it is 1/(8 + 4√3) = (2 − √3)/4; and F = 2, η = 1/2 gives 1/8 outright, the only rational entry.

> **Five of the six are on the undirected ladder or exactly half of it, and the reason is an identity the undirected table already carries.** `aod` §3.3.5 records **cap_F(η) = cap₁(Fη)/F**, so every directed entry taken at F = 2 is half of an F = 1 undirected ceiling: (3 − 2√2)/2 is half the class-1 ceiling, (2 − √3)/4 is half the class-2 one, and 1/8 and 3 − 2√2 are undirected ceilings unmoved. **The single exception is classes 2 and 8**, whose optimum stays at F = 1, so no halving identity applies and **(7 − 2√6)/25 is a genuinely new constant** — the only value in the directed table that does not appear in the undirected one. That it is the class whose ratio is worst (0.627) is the same fact twice: the classes that keep F = 1 pay the efficiency cut in full, and those that can move to F = 2 buy part of it back.

**Three things the table says.** The global directed constant is **cap₂(1/6) = (2 − √3)/4 = 0.0669873**, attained at **n ≡ 5 and n ≡ 11 (mod 12)** — so the extremal class is no longer unique, and class 5 joins class 11 at the bottom. The loss is nowhere the full factor of two: the ratios run (7−2√6)-driven 0.627 up to (2 + √3)/4 = 0.933, because halving η moves the balance point and a larger share compensates, the same effect `chiral-graph-properties.md` §5 records for ε. And **the F = 4 rung stops being optimal at class 11** — at η = 1/6 the best even fusion count is 2, which is why that class loses least.

*A coincidence worth not over-reading, since it has now appeared twice.* cap₁(1/2) = 3 − 2√2 and cap₂(1/4) are S_n ceilings one rung down, exactly as the chiral note's ε = ½ penalty produced. Both are "halve the efficiency", so the ladder shifts rather than acquiring new constants; the two tables are indexed differently and nothing transfers between them.

---

## 4. Oriented graphs: the 2-cycle fiat, and why it is legitimate

An **oriented graph** forbids a 2-cycle — an edge and its reverse together. That is not a restriction of the coordinate space but a constraint on the property, so the natural framing is: take a monotone property on the n(n−1) coordinates and declare it **false by fiat** whenever both (x,y) and (y,x) are present.

> **Proposition D2.** The 2-cycle-free family is downward closed and S_n-invariant. Hence for any monotone **decreasing** S_n-invariant Q, the family P = Q ∩ {2-cycle-free} is again monotone decreasing, S_n-invariant, and **automatically nontrivial**: the full digraph contains 2-cycles so is never in P, and ∅ ∈ P whenever ∅ ∈ Q.
>
> *Verified exhaustively at n = 3:* the 2-cycle-free family is down-closed (all 27 of them), and intersecting it with each of 200 randomly generated down-closed families leaves a down-closed family every time.

> **The fiat works for the decreasing convention and not for the increasing one, and the asymmetry is worth stating** because the framework's own convention is the decreasing one and it is easy to carry the construction across a translation and lose it. "Contains no 2-cycle" is down-closed; its negation is up-closed. So a monotone *increasing* property cannot be cut down this way — one would have to work with the complementary property, and the nontriviality that comes free above is then not free.

---

## 5. The self-pairing collapse: oriented properties are much easier, and n = 10 falls

Here the fiat does something the undirected framework has no analogue for.

> **Theorem D3.** Let Γ ≤ S_n be an Oliver group **all of whose orbitals are self-paired**, and let P be a nontrivial monotone oriented-graph property. Then P is evasive.
>
> *Proof.* A self-paired orbital O contains (x,y) and (y,x) for some x, y, hence contains a 2-cycle, hence **O ∉ P**. The Γ-invariant digraphs are the unions of orbitals, and a union lies in P only if each of its orbitals does, so Δ_P^Γ has **no vertices at all**: Δ_P^Γ = {∅} and χ = 0. Oliver's theorem forces χ ≡ 1 (mod q), and 0 ≢ 1 for every prime q — outright in the trivial-top case, where the congruence collapses to χ = 1. ∎

This is the t = 1 argument of `monotone-transitive-note.md` §1 arriving by a completely different route: there the fixed complex is empty because the group is transitive on coordinates; here it is empty because *every* coordinate class is disqualified by the fiat. **No density, no orbital sizes, no arithmetic** — the statistic that matters is not how big the smallest orbital is but whether any orbital is non-self-paired.

**What that settles, and it includes the first open ARK case.**

- **n a prime power.** AGL(1, n) is 2-transitive, so its single orbital is self-paired. Every nontrivial monotone oriented-graph property at a prime power is evasive.
- **n = 2c with c an odd prime power.** The framework's own fused construction — two blocks of 𝔽_c with the entangled generator z, z² the full twist — has *every* orbital self-paired: the full twist d = c − 1 is even so the intra orbitals are, and z exchanges the two blocks so the cross orbital is. *Computed: n = 10 (orbitals 40, 50), n = 14 (84, 98), n = 22 (220, 242) — all self-paired.* So **every nontrivial monotone oriented-graph property on 10 vertices is evasive**, and likewise at 14, 22, 26, … — the first composite non-prime-power case, which the undirected problem has resisted through a 75-group CSP battery and a decade of attention.
- **Odd fusion counts do not have this.** At F = 3 or 4 the block rotation is not an involution and the cross orbitals are not self-paired: n = 15 gives 1 of 3, n = 12 gives 2 of 4, n = 21 gives 1 of 3. So the argument reaches n = 2·(prime power) and prime powers, not all n.

**Control.** Exhaustive decision-tree evaluation over every nontrivial monotone S₃-invariant 2-cycle-free property at n = 3 — 27 oriented digraphs, 7 orbits, 16 invariant down-closed families, 15 nontrivial — finds **0 non-evasive**, consistent with the theorem and with the base-case discipline of `monotone-transitive-note.md` §6 (the recursion's no-free-variables case must be tested first, or every function reports non-evasive).

> **The moral, and it is the reason this section is worth more than §§2–3.** Constraining the property made the problem *easier*, not harder, because the constraint disqualifies whole coordinate classes at once. That is the opposite of the usual direction — `chiral-graph-properties.md` observes that weakening the invariance group makes a counterexample *easier* to find — and it identifies the real content of the oriented question: it lives entirely at the n where no Oliver group is generously transitive.

---

## 6. Open

1. **For which n does an Oliver group with all orbitals self-paired exist?** §5 gives prime powers and 2·(prime power) by construction. A generously transitive solvable group of degree n is the object to classify; the answer would settle the oriented conjecture on that set outright, with no density argument anywhere. **This is the single highest-value item here** and it is a pure group-theory question, not a computation.
2. **The directed μ table.** `mu_ladder_exact.py` computes the undirected B(n) from a shape's parts; the directed score of a configuration is the same arithmetic with η_dir in place of η (§2), so a `--directed` flag is a small change and would give the directed analogue of the 1/25 floor. The prediction from §3 is a floor near 0.0670·(2/1) of the undirected one at the extremal classes, i.e. that the two floors stand in ratio 0.63–0.93 by class rather than a uniform half.
3. **Does the digraph case have its own n = 10?** KSS settles prime powers for digraphs. Whether the composite non-prime-power digraph case is *strictly harder or easier* than the undirected one is not addressed by Theorem D1, which only bounds one by the other. The small-degree pipeline of `small-degree-computation.md` would answer it at n = 10 with the orbital map replaced by the ordered one — t is larger, so §2.4's fixed-complex criterion is weaker, which argues the digraph case is the harder of the two.
4. **Tournaments.** A tournament is a *maximal* oriented graph, so the maximal faces of the oriented complex are exactly the tournaments on n vertices. Whether that gives a usable handle — the complex is pure of dimension C(n,2) − 1 — is unexplored.

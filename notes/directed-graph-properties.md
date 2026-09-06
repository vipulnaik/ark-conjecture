# Directed and oriented graph properties: what the framework says, and what the literature already said

*Companion to `orbital-evasiveness-notes.md`, `enumeration-proof.md` and `arithmetic-of-density.md`. The k-uniform notes move along the arity axis and `monotone-transitive-note.md` moves off it entirely; this one moves sideways, to properties of the **ordered** pairs. It sits between the two: a digraph property is a monotone S_n-invariant property of the n(n−1) ordered pairs, so it is a special case of the general transitive setting and a generalisation of the graph case.*

**Status.**

| section | standing |
|---|---|
| §1 the object, and the literature | **settled by citation** — this is Karp's original formulation |
| §2 the halving theorem and when it is paid | **proved**; the twist-parity criterion verified computationally |
| §3 the directed ceiling table | **derived** from §2 by substitution into cap_F |
| §4 oriented graphs: the 2-cycle fiat | **proved**; monotonicity verified exhaustively at n = 3 |
| §5 the self-pairing collapse | **proved**, and **scoped**: it is a statement about the Boolean cube on n(n−1) coordinates, driven by the 2-cycle check, not about the ternary oriented model. Hypothesis satisfied at every n by D_n; both models measured exhaustively at n = 3 |
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

## 5. Oriented graphs: the self-pairing collapse, and what it does *not* establish

Here the fiat does something the undirected framework has no analogue for. The theorem below is correct, but **the model it is stated in is not the model the phrase "oriented graph property" suggests**, and that qualification is the substance of this section rather than a footnote to it.

> **Theorem D3.** Let Γ ≤ S_n be an Oliver group **all of whose orbitals are self-paired**, and let P be a nontrivial monotone property of subsets of the n(n−1) ordered pairs with P contained in the 2-cycle-free sets. Then P is evasive **on the n(n−1)-coordinate Boolean cube**.
>
> *Proof.* A self-paired orbital O contains (x,y) and (y,x), hence a 2-cycle, hence **O ∉ P**. The Γ-invariant digraphs are unions of orbitals and a union lies in P only if each of its orbitals does, so Δ_P^Γ has no vertices: Δ_P^Γ = {∅}, χ = 0. Oliver forces χ ≡ 1 (mod q), and 0 ≢ 1 for every prime q. ∎

**The hypothesis is satisfied at every n, by the dihedral group.** D_n on the n-gon is transitive; for any x ≠ y the reflection through the perpendicular bisector swaps them (solve 2m ≡ x + y mod n, which is solvable for odd n directly and for even n using both reflection classes by parity), so **every orbital is self-paired**. And D_n is Oliver: Γ₂ = 1, Γ₁ = C_n cyclic, Γ/Γ₁ = C₂, top prime q = 2. *Verified computationally for every n from 3 to 25.* So Theorem D3 applies at **every degree**, with no arithmetic and no density anywhere.

> **And that is exactly why it proves less than it appears to.** In this model the algorithm is handed an arbitrary subset of the n(n−1) ordered pairs and must decide P. Since P is false on anything containing a 2-cycle, **part of the task is confirming that the input is an oriented graph at all** — and that check is what the adversary is exploiting. The nontriviality-by-fiat of §4, which looked like a convenience, is a large supply of OUT-forcing: on the undirected side the only OUT-generator in the whole system is "K_n ∉ P" (`small-degree-computation.md` §7.1), whereas here every one of the C(n,2) reversal pairs generates one. The theorem is a statement about that, not about the difficulty of the property.
>
> **The model that matches the phrase is ternary, and Theorem D3 says nothing about it.** An oriented graph is a map from the C(n,2) unordered pairs to {absent, forward, backward}; the natural query is "what is the state of pair {x,y}?", monotone means closed under arc deletion, and evasive means all C(n,2) pairs must be queried. That is not a Boolean cube, Δ_P is not its complex, and **the KSS/Oliver machinery does not apply to it as stated** — the fixed-complex argument above has no ternary analogue, because there is no "the orbital is excluded" step when the exclusion was an artefact of the encoding.
>
> *Measured at n = 3, both models:* on the Boolean cube, 2,062 of the 15,935 nontrivial down-closed families inside the oriented sets are non-evasive — so the fiat alone does **not** force evasiveness — but **0 of those are S_n-invariant**, which is Theorem D3 doing real work at that degree. In the ternary model there are 14 nontrivial S₃-invariant monotone properties and **0 are non-evasive**. Both are consistent; neither implies the other.

**So what is settled, stated precisely.** Every nontrivial monotone S_n-invariant property of the n(n−1) ordered pairs that excludes 2-cycles is evasive as a Boolean function on those n(n−1) coordinates, for every n. That subsumes the earlier prime-power and 2·(prime-power) readings — the dihedral group makes the fusion constructions unnecessary — and it is **not** a statement about deciding an oriented-graph property given the promise that the input is an oriented graph.

> **A recursion bug found here, recorded because the documents already warn about its sibling.** The first version of the exhaustive control had the branch condition **inverted**: non-evasiveness requires *some* variable whose two restrictions are both non-evasive, and the code returned "evasive" in exactly that case. It therefore reported everything evasive, and the first reading of the n = 3 control — "0 non-evasive even with no symmetry, so the group hypothesis does no work" — was an artefact of it. `monotone-transitive-note.md` §6 records the base-case form of this same trap (testing constancy before the no-free-variables case reports every function non-evasive); this is the branch form, and it fails in the opposite direction, which is why the controls looked *reassuring* rather than absurd. **The tell was a contradiction with an explicit strategy**, not the aggregate. Both controls above use the corrected recursion and pass three sanity checks (P = {∅} evasive; a one-free-variable property non-evasive; χ(Δ_P) ≠ 1 forcing evasive independently at P = "is an oriented graph", where χ = 2).

## 6. Open

1. ~~**For which n does an Oliver group with all orbitals self-paired exist?**~~ **Closed: every n.** D_n is generously transitive and Oliver at every degree (§5), so the question has no content — which also removes the interest, since it means Theorem D3's hypothesis is free and the theorem's force comes entirely from the 2-cycle fiat.
1a. **The ternary oriented model is the real question, and it is open.** Is every nontrivial monotone S_n-invariant property of oriented graphs evasive in the C(n,2)-query ternary model? Verified at n = 3 (14 properties, 0 non-evasive). The Boolean machinery does not apply; what would be needed is a fixed-point argument for group actions on the *ternary* decision-tree complex, and no such thing is in the framework or, so far as the searches went, the literature. **This is where the interest went** once the Boolean version turned out to be driven by the encoding.
2. **The directed μ table.** `mu_ladder_exact.py` computes the undirected B(n) from a shape's parts; the directed score of a configuration is the same arithmetic with η_dir in place of η (§2), so a `--directed` flag is a small change and would give the directed analogue of the 1/25 floor. The prediction from §3 is a floor near 0.0670·(2/1) of the undirected one at the extremal classes, i.e. that the two floors stand in ratio 0.63–0.93 by class rather than a uniform half.
3. **Does the digraph case have its own n = 10?** KSS settles prime powers for digraphs. Whether the composite non-prime-power digraph case is *strictly harder or easier* than the undirected one is not addressed by Theorem D1, which only bounds one by the other. The small-degree pipeline of `small-degree-computation.md` would answer it at n = 10 with the orbital map replaced by the ordered one — t is larger, so §2.4's fixed-complex criterion is weaker, which argues the digraph case is the harder of the two.
4. **Tournaments.** A tournament is a *maximal* oriented graph, so the maximal faces of the oriented complex are exactly the tournaments on n vertices. Whether that gives a usable handle — the complex is pure of dimension C(n,2) − 1 — is unexplored.

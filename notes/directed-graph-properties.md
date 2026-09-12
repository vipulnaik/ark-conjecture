# Directed and oriented graph properties: what the framework says, and what the literature already said

*Companion to `orbital-evasiveness-notes.md`, `enumeration-proof.md` and `arithmetic-of-density.md`. The k-uniform notes move along the arity axis and `monotone-transitive-note.md` moves off it entirely; this one moves sideways, to properties of the **ordered** pairs. It sits between the two: a digraph property is a monotone S_n-invariant property of the n(n−1) ordered pairs, so it is a special case of the general transitive setting and a generalisation of the graph case.*

**Status.**

| section | standing |
|---|---|
| §1 the object, and the literature | **settled by citation** — this is Karp's original formulation |
| §2 the halving theorem and when it is paid | **proved**; the twist-parity criterion verified computationally |
| §3 the directed ceiling table | **derived** from §2 by substitution into cap_F |
| §4 oriented graphs: the 2-cycle fiat | **proved**; monotonicity verified exhaustively at n = 3 |
| §5a0 up/down versus self-duality | **proved**; the poset's rank sequence computed at n = 3, 4, 5 |
| §5a1 lift/projection retraction, and the direction of algorithms | **proved**; π∘L = id and the lift criterion verified at n = 3, the downward failure witnessed at n = 4 |
| §5b counterexamples, and the nontriviality condition | **literature + computed**; the known directed counterexample reproduced and scoped |
| §5a the lift, and the difficulty ordering | **proved**; verified as an identity of exact decision-tree depths at n = 3 and n = 4 |
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

Write μ_dir(n) for the maximum over Oliver groups Γ ≤ S_n of the minimum Γ-orbit on **ordered** pairs, and δ_dir = μ_dir/(n(n−1)) — normalised against n(n−1), not C(n,2).

> **Why this is a well-posed quantity here, unlike μ_Γ in the general transitive setting.** The action is still **induced from vertices**: Γ acts on [n] and the n(n−1) ordered pairs are determined by that. So the block structure survives, the orbitals have the same block-and-twist form, and there is something for an optimisation to range over — which is why §3's ceiling table exists at all. *Contrast `monotone-transitive-note.md` §2, where the group acts on the coordinates directly, the orbital shapes are unconstrained, and no such table can be written.* The one thing that does change is the t = 1 condition: a single **ordered** orbital needs Γ to be 2-**transitive**, not merely 2-homogeneous, and the two part company at degrees ≡ 3 (mod 4) (`orbital-evasiveness-notes.md` Appendix C, row 4).

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

## 5a. The lift: the ternary oriented conjecture is at least as hard as ARK

The previous section leaves a natural hope — that the oriented question might be *easier* than the undirected one, since the Boolean version fell out in three lines. It is not, and one paragraph settles the direction.

> **Proposition D4 (the lift).** Let P be a nontrivial monotone graph property on n vertices. Define the oriented property **P′(D) = P(underlying undirected graph of D)**. Then P′ is monotone (deleting an arc deletes an underlying edge), S_n-invariant and nontrivial, and in the ternary model
>
> > **D_ternary(P′) = D(P)** exactly.
>
> *Proof.* A ternary query on the pair {x,y} returns absent / forward / backward, which in particular determines whether the underlying edge is present; and P′ depends on the input **only** through the underlying graph, so no orientation ever changes the verdict. A decision tree for P therefore lifts verbatim — query each pair, use the presence bit — and conversely any tree for P′ yields one for P by ignoring the orientation. ∎
>
> **So a non-evasive graph property lifts to a non-evasive oriented one, and the ternary oriented conjecture implies ARK.** Equivalently: a counterexample to ARK is a counterexample to the oriented conjecture, so the oriented statement is at least as strong, and any proof of it is a proof of ARK. *Verified as an identity of exact decision-tree depths at n = 3 (3 properties) and n = 4 (22 properties, all at D = 6 = C(4,2), as KSS requires at a prime power).*

**This is the right way to have been suspicious of §5.** If the Boolean argument had had genuine content about oriented graphs, the same lift would have carried it to ARK — three lines proving a conjecture that has stood since 1973, which is the tell. What the lift shows is where the content went: it went into the 2-cycle check, which the lift does not see, because in the ternary model the promise is free rather than something the algorithm must verify.

> **The right framing of the ternary model, and why it is not a Boolean question in disguise.** The promise "no 2-cycle" is C(n,2) constraints x_e ∧ x_ē = 0 on the n(n−1) Boolean coordinates, and a ternary query buys **both** coordinates of a reversal pair at once. So the two models differ in their accounting, not only in their constraints: n(n−1) Boolean queries against C(n,2) ternary ones, the latter carrying log₂3 ≈ 1.585 bits each, for ≈ 0.79·n(n−1) bits in total. The question "can you beat C(n,2) ternary queries when part of the input space has been ruled out for free" is therefore not implied by any statement about the Boolean cube, in either direction — which is exactly why Theorem D3, a Boolean statement, says nothing about it.
>
> *Measured at n = 3:* 14 nontrivial monotone S₃-invariant oriented properties in the ternary model, **0 non-evasive** — consistent with ARK at n = 3 via the lift, and with nothing stronger.

## 5a0. Up and down are still symmetric; *self-duality* is what is lost

Before the conventions can be used, two things that coincide in the undirected case have to be separated, because only one of them survives.

- **Negating the function.** P ↦ its complement family. A down-set complements to an up-set, and **D(f) = D(¬f) always**, in any model — a decision tree is the same object whichever answer you call "yes". The nontriviality conditions correspond exactly: *P increasing with P(∅) false and P(T) true at every tournament T* ⟺ *¬P decreasing with ∅ ∈ ¬P and no tournament in ¬P*. **So "increasing" and "decreasing" are interchangeable here exactly as they are undirected, and working in the decreasing convention costs nothing.** *Checked on the example: "no vertex dominates" is decreasing, contains ∅, and contains 32 of the 64 tournaments on 4 vertices — so it fails strict nontriviality in precisely the way the increasing form does.*
- **Complementing the object**, G ↦ Ḡ. *This is what has no oriented analogue*, and it is the operation the undirected framework actually leans on.

> **The precise statement, and it is a fact about the poset rather than about graphs.** The oriented poset is a product of C(n,2) copies of the three-element poset **V = {0 < 1, 0 < 2}** — arc absent, or present in one of two directions. **V has one minimal element and two maximal ones, so V is not self-dual, and neither is any product of copies of it.** The Boolean cube is a product of 2-**chains**, which *are* self-dual, and that single difference is the whole of the asymmetry. Concretely the rank sizes C(m,k)·2^k are not palindromic — *(1, 6, 12, 8) at n = 3, (1, 12, 60, 160, 240, 192, 64) at n = 4* — and a palindromic rank sequence is necessary for an order-reversing bijection, so **the oriented poset admits no order-reversing automorphism at all**. There is a unique bottom, the empty digraph, against 2^{C(n,2)} maximal elements.
>
> *The reversal map D ↦ D^rev, the obvious candidate, is an involution but an order-**preserving** one — it is an automorphism, not a duality — so it does not do this job.*

**Two consequences, and the second is a real loss to the machinery.**

1. **This is why nontriviality had to be restated.** "f(∅) ≠ f(top)" presupposes a top. There isn't one, and the honest replacement quantifies over the maximal elements — which is exactly the condition §5b needs in order for dominant-vertex not to count.
2. **The dual conditions of the undirected CSP have no analogue.** `small-degree-computation.md` §2.2 gets a second condition per group for free from P^∨ = {G : Ḡ ∉ P}, because complements of orbital unions are orbital unions of the *same* group; §2.3 gets the backbone involution from the same map, halving the probe sweep. Both rest on the cube's self-duality. **In the oriented model neither exists**, so a ternary battery would have to run at roughly twice the cost for the same constraint count, and the forced-IN/forced-OUT pairing that §2.3 exploits is simply unavailable.

> **Modus ponens, modus tollens — and the tollens reading is the informative one.** Filed as above this is a nuisance: the oriented model loses a tool. Read the other way it is a statement about what the undirected framework's difficulty actually is. `small-degree-computation.md` §7.1 diagnoses the persistent SAT as **one-sidedness**: every χ condition, every Smith condition and monotone propagation push graphs *into* P, and "the only OUT-generator in the entire system is nontriviality" — the single constraint K_n ∉ P. The duality is what partially repairs that, by converting IN-forcing into OUT-forcing at every group.
>
> **The oriented model has the opposite balance and is still the harder conjecture.** It has no duality at all, but under strict nontriviality **every tournament is an OUT-generator** — *2^{C(n,2)} of them, against the undirected model's one: 8 at n = 3, 64 at n = 4, and 3.5 × 10¹³ at n = 10.* So it trades one duality for an exponential supply of exactly the constraint the undirected setting is starved of, and it *still* implies ARK (§5a).
>
> **Which says that OUT-pressure is not what the undirected problem is short of.** The one-sidedness diagnosis explains why a *particular battery* stays satisfiable; it does not explain why the conjecture is hard, because the model with vastly more OUT-forcing is harder, not easier. What the oriented model lacks is not constraints but the *self-duality* — and on this reading self-duality is a load-bearing hypothesis of ARK rather than a computational convenience, which is a claim the undirected framework cannot see from the inside because the cube is self-dual and the hypothesis is never varied. **Testing it means asking which undirected arguments break when the duality is removed**, and §§2.2–2.3's are the first two.

## 5a1. Lift and projection: a retraction, and which way algorithms travel

*Stated in the **decreasing** convention throughout, which is the framework's: P is closed under arc deletion, and nontrivial means **∅ ∈ P and no tournament lies in P**. By §5a0 this is no restriction — negating the function exchanges the two conventions and preserves both D and nontriviality.*

Write **L** for the lift and **π** for projection, in two flavours:

> **L(Q) = {D : underlying(D) ∈ Q}**,  **π_∃(P) = {G : some orientation of G lies in P}**,  **π_∀(P) = {G : every orientation of G lies in P}**.

> **Proposition D5.** All three are monotone decreasing and S_n-invariant, all three preserve nontriviality in the strict sense, and
>
> > **π_∃ ∘ L = π_∀ ∘ L = id.**
>
> So **L is a section and each π is a retraction**: the undirected problem sits inside the oriented one as a retract.
>
> *Proof.* Decreasing: for π_∃, if D ⊆ orientation of G realises G ∈ π_∃ then deleting an edge of G leaves a sub-orientation, and P is decreasing; for π_∀, any orientation of a subgraph extends to one of G. Nontriviality: ∅ ∈ π iff ∅ ∈ P; and K_n ∈ π_∃(P) iff some tournament lies in P, K_n ∈ π_∀(P) iff every tournament does — both excluded. The retraction is immediate since membership in L(Q) depends only on the underlying graph. ∎ *Verified at n = 3 on every case.*

> **Proposition D6 (what a lift is, intrinsically).** **P is a lift ⟺ π_∃(P) = π_∀(P)**, and in that case D_ternary(P) = D(π(P)).
>
> The gap **π_∃(P) ∖ π_∀(P)** is precisely the set of underlying graphs whose verdict depends on the orientation — **the content of the oriented problem over and above ARK**, made into a concrete object one can compute with rather than a slogan. *At n = 3 there are 9 strictly nontrivial invariant oriented properties, of which **3 are lifts** (π_∃ = π_∀, both of size 4 or 7) and **6 are not** (π_∃ of size 7 against π_∀ of size 4).*

**Now the two directions, which is the question.**

- **Algorithms push UP, always, at no cost.** A ternary answer determines the underlying edge, so a decision tree for Q runs verbatim on L(Q): **D_ternary(L(Q)) = D(Q)** (§5a). This is what makes the oriented conjecture imply ARK.
- **Algorithms do not push DOWN, and the failure is strict.** Given a ternary tree for P, there is no undirected tree for π(P): an undirected query returns one bit where the tree branches three ways, and when the edge is present the simulation does not know which branch to take. That is not a gap in the argument but a fact — **dominant-vertex** is the witness. In the oriented model D_ternary = 4 at n = 4; its projection π_∃ is "some vertex has degree n − 1", for which *computed*, D = **6** = C(4,2). So an oriented algorithm can be strictly cheaper than every undirected algorithm for its own projection.

> **Which is exactly the asymmetry the two conjectures should have.** The retraction gives oriented ⟹ ARK for free, and the algorithmic one-sidedness is why nothing comes back: the extra information in a ternary answer is worth log₂3 − 1 ≈ 0.585 bits per pair, and the dominant-vertex knock-out is a case where the algorithm spends it. **So a counterexample must live in the non-lift part π_∃ ∖ π_∀** — a lift can never be one, since its ternary complexity equals an undirected complexity that ARK asserts is full — which turns "look for a non-lift" from a heuristic into the only place left to look.

## 5b. Counterexamples in the oriented model: yes, and what they do and do not refute

The expectation is right — the oriented model should be the easier place to *find* a counterexample, since a non-lift has no undirected shadow — and the literature already has one.

> **The dominant-vertex / sink property.** "Some vertex v has v → w for every w ≠ v" is monotone increasing under arc addition, S_n-invariant and non-constant. On tournaments it is decided by a knock-out: play 1 against 2, the winner against 3, and so on (n − 1 queries), then check the survivor against everyone it has not met (n − 2 more), for **2n − 3** queries against C(n,2). The literature records this as **the first counterexample to a (too strong) version of the evasiveness conjecture on directed graphs** — the directed analogue of the scorpion, which played the same role undirected and is what prompted restricting the conjecture to monotone properties.
>
> *Reproduced and pinned computationally.* In the **ternary oriented** model, "has a dominant vertex" has D = **4** against C(4,2) = 6 at n = 4 — **non-evasive** (and likewise "has a sink"). In the **Boolean digraph** model on the same property, D = 6 of 6 at n = 3 and **12 of 12 at n = 4** — **evasive**. So the property is evasive as a digraph property and non-evasive as an oriented one: **the promise is what buys the saving**, which is the sharpest available demonstration that the two models are genuinely different questions and not a change of encoding.

**But it does not refute the conjecture as it should be stated, and the reason is where the nontriviality condition goes.** In the Boolean cube nontriviality reads f(∅) ≠ f(top), and there is a unique top. In the ternary oriented poset there is **no unique maximal element** — the maximal elements are the C(n,2)-arc tournaments — so the honest analogue of "f(top) = 1" is **"P holds at every tournament"**. Dominant-vertex fails it: *computed, 32 of the 64 tournaments on 4 vertices have a dominant vertex and 32 do not*. So it is non-constant but not nontrivial in the sense the conjecture needs, exactly as the literature's "too strong a version" phrasing indicates.

> **So the oriented conjecture has to be stated with the strict condition**, and this is the one place where the ternary model demands a genuinely new definition rather than a translation:
>
> > **Oriented evasiveness conjecture (decreasing convention, which is the right one).** Let P be a monotone **decreasing** S_n-invariant property of oriented graphs on n vertices with **∅ ∈ P** and **no tournament in P**. Then P requires all C(n,2) ternary queries.
>
> Under this statement the lift of §5a still goes through (an undirected P with P(∅) = 0, P(K_n) = 1 lifts to a P′ true at every tournament, since a tournament's underlying graph is K_n), so the conjecture still implies ARK; and dominant-vertex is no longer a counterexample to it. **That is the right target**, and the search for a non-lift counterexample should be run against it rather than against non-constancy.

*What was not completed.* An exhaustive n = 4 sweep of all invariant monotone oriented properties under both nontriviality conventions. The obstruction was an enumeration blunder rather than the mathematics: **42** oriented graphs on 4 vertices up to isomorphism, and the first attempt enumerated candidate families as subsets of the orbit set — 2⁴² of them. The down-set DP over the orbit poset is the right algorithm and the run is a small job; it has not been done.

## 6. Open

1. ~~**For which n does an Oliver group with all orbitals self-paired exist?**~~ **Closed: every n.** D_n is generously transitive and Oliver at every degree (§5), so the question has no content — which also removes the interest, since it means Theorem D3's hypothesis is free and the theorem's force comes entirely from the 2-cycle fiat.
1a. **The ternary oriented model is the real question, it is open, and §5a places it: it implies ARK.** Is every nontrivial monotone S_n-invariant property of oriented graphs evasive in the C(n,2)-query ternary model? By the lift (Proposition D4) this is **at least as strong as ARK**, so it will not be proved by anything cheap — but that also makes it a sharper target than a mere generalisation: the extra content over ARK is exactly the properties that *do* see the orientation, and asking whether those are the hard ones is a question the undirected framework cannot pose. The Boolean machinery does not apply; what would be needed is a fixed-point argument for group actions on the ternary decision-tree complex, and no such thing is in the framework or, so far as the searches went, the literature.
1b. **Which oriented properties are not lifts?** §5a's P′ ignores orientation entirely, so the lifted family contributes nothing beyond ARK. The interesting subfamily is its complement — properties genuinely sensitive to direction. Two data points so far, both at n = 4: **acyclicity is evasive** (D = 6 = C(4,2)), and **dominant-vertex is not** (D = 4) but fails strict nontriviality (§5b). So the live question is whether a *strictly* nontrivial non-lift can be non-evasive, and acyclicity — strictly nontrivial, since no tournament is acyclic, wait: the transitive tournament *is* acyclic, so acyclicity is false at some tournaments too and is likewise not strictly nontrivial in the decreasing sense — is worth redoing with the condition stated carefully.
1c. **Run the n = 4 sweep properly.** 42 orbits, down-set DP over the orbit poset, both nontriviality conventions; the first attempt tried 2⁴² subsets and was abandoned. This is the cheapest experiment that could produce a strictly-nontrivial non-lift counterexample or rule one out at n = 4.
2. **The directed μ table.** `mu_ladder_exact.py` computes the undirected B(n) from a shape's parts; the directed score of a configuration is the same arithmetic with η_dir in place of η (§2), so a `--directed` flag is a small change and would give the directed analogue of the 1/25 floor. The prediction from §3 is a floor near 0.0670·(2/1) of the undirected one at the extremal classes, i.e. that the two floors stand in ratio 0.63–0.93 by class rather than a uniform half.
3. **Does the digraph case have its own n = 10?** KSS settles prime powers for digraphs. Whether the composite non-prime-power digraph case is *strictly harder or easier* than the undirected one is not addressed by Theorem D1, which only bounds one by the other. The small-degree pipeline of `small-degree-computation.md` would answer it at n = 10 with the orbital map replaced by the ordered one — t is larger, so §2.4's fixed-complex criterion is weaker, which argues the digraph case is the harder of the two.
4. **Tournaments.** A tournament is a *maximal* oriented graph, so the maximal faces of the oriented complex are exactly the tournaments on n vertices. Whether that gives a usable handle — the complex is pure of dimension C(n,2) − 1 — is unexplored.

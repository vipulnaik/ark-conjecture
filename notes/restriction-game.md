# The restriction game: a framework for query-complexity lower bounds

*Companion to `orbital-evasiveness-notes.md` and `hardness-of-evasiveness.md`. The evasiveness results in this project run through one framework — a group, its fixed complex, an Euler characteristic — and that framework turned "clever proofs" into a search over groups and arithmetic. The quantitative bounds in the literature (Rivest–Vuillemin n²/16, Kahn–Saks–Sturtevant n²/4, Korneffel–Triesch 8n²/25, the n²/3 bound, BBKN's C(n,2) − O(1) for forbidden subgraphs) look instead like a collection of tricks. This note argues they are strategies in a single game, and that one level of that game reduces to a widest-path computation.*

**Status.** §2's reduction (Theorem 1) and §4's escape bound (Lemma 2) are proved here and checked by computation at small n. §3's reconstructions of KSS and Rivest–Vuillemin are exact. §5 reconstructs the topological core of Korneffel–Triesch from Miller's description — the papers themselves have not been read — and computes the equal-parts extension exactly; the residual branches of their arguments are not reconstructed. **The restriction method itself is standard; whether Theorem 1 or Lemma 2 is folklore has not been checked.**

---

## 1. Objects

**Worlds.** A *world* is a pair (S, G): a finite coordinate set S with a group G acting on it. Its *minimum complexity* is

> C(S, G) = min { D(f) : f : 2^S → {0,1} nontrivial, monotone, G-invariant },

and the world is *evasive* when C(S, G) = |S|. The graph world of order n is 𝒢ₙ = (E(Kₙ), Sₙ), with Cₙ := C(𝒢ₙ); ARK says Cₙ = C(n,2). Two facts are used throughout:

- **Shrinking the group can only lower C.** If H ≤ G, every G-invariant function is H-invariant, so C(S, G) ≥ C(S, H). A certificate may use any subgroup.
- **Restriction.** For f on 2^S and a pair of configurations U ⊆ W ⊆ S, let f|(U,W) be the function on 2^(W∖U) given by X ↦ f(U ∪ X). Then D(f) ≥ D(f|(U,W)), since a tree for f becomes a tree for the restriction by answering every query outside W ∖ U according to U. The restriction is monotone, is invariant under Stab_G(U, W) — the elements preserving both U and W — and is nontrivial exactly when f(U) ≠ f(W).

**Intervals and sub-worlds.** Call (U, W) an *interval* of the world, with *free set* W ∖ U and *sub-world* (W ∖ U, Stab_G(U, W)). If f is monotone increasing, the restriction is nontrivial iff f(U) = 0 and f(W) = 1; we say f *crosses* the interval.

**Certificates come in two kinds**, and keeping them apart is half the point of the framework.

- **Whole-world certificates** show a world is evasive, or that a *specific* function on it is. Examples: a transitive Oliver subgroup (`monotone-transitive-note.md` Proposition 1 — the fixed complex is void); Yao's theorem for the bipartite world (K_{a,b}, S_a × S_b); χ computations such as KSS at n = 6, the two-graph criterion, and our triangle-freeness results at n = 45 and 58.
- **Descent certificates** give lower bounds below |S| by chaining restrictions — §2.

A descent can never prove evasiveness, since every step's free set is a proper subset of S. **So exact evasiveness and query-complexity bounds are different outputs of the same apparatus**: the first needs a whole-world certificate, the second a descent through certified sub-worlds.

## 2. The game, and its reduction to a widest path

Fix a world (S, G) and a catalogue ℐ of intervals, each with a *value* v(I) — a proven lower bound on the minimum complexity of its sub-world. A nontrivial monotone G-invariant f is the same thing as a nontrivial G-invariant up-set 𝒰 = f⁻¹(1) in 2^S, and f crosses (U, W) iff U ∉ 𝒰 and W ∈ 𝒰. By the restriction fact, D(f) ≥ v(I) for every I that f crosses. So the best bound the catalogue can prove for *every* f is the value of a game:

> V(ℐ) = min over nontrivial invariant up-sets 𝒰 of max { v(I) : I ∈ ℐ crossed by 𝒰 },

and C(S, G) ≥ V(ℐ). Because 𝒰 is G-invariant, only G-orbits of configurations matter; in the graph world, isomorphism classes ordered by subgraph containment.

**Call a family ℐ unavoidable if every nontrivial invariant up-set crosses one of its members.** Then V(ℐ) ≥ v for exactly those v such that the intervals of value ≥ v form an unavoidable family.

> **Theorem 1 (descent criterion).** ℐ is unavoidable iff it contains a *descent*: intervals (U₁, W₁), …, (U_k, W_k) with W₁ = S, each W_{i+1} containing some G-translate of Uᵢ, and U_k = ∅.

*Proof.* Write x_X = [X ∈ 𝒰] for configurations X. An up-set avoiding every member of ℐ must satisfy: x_∅ = 0 and x_S = 1 (nontriviality); x_X → x_Y whenever X ⊆ gY for some g (invariance and up-closure); and, for each interval, x_W → x_U (not crossed, given W ∈ 𝒰). Every constraint is a single implication between positive literals, so the system is satisfiable iff x_S = 1 does not force x_∅ = 1. Forcing proceeds by closure: starting from {S}, close upward under containment, and whenever some interval's W lies in the current set, add its U. Each added U has exactly one premise, so a derivation of ∅ traces back along a single chain of intervals — a descent. Conversely, along a descent, W₁ = S ∈ 𝒰 and U_k = ∅ ∉ 𝒰, so some step has W_i ∈ 𝒰 and U_i ∉ 𝒰: it is crossed. ∎

> **Corollary.** With values attached, V(ℐ) is the **widest path** — the maximum over descents of the minimum value along the descent — in the graph whose nodes are G-orbits of configurations and which has an edge X → U of weight v(U, W) for every interval (U, W) whose top contains a translate of X.

Two consequences are worth stating at once. **Only interval endpoints matter**: the poset needed is the set of endpoints with their containment relations, not all of 2^S, which keeps small cases computable even where the full poset is enormous. And **the property-specific version is degenerate**: for a fixed f the up-set is given, so D(f) ≥ max over crossed intervals — one step, no descent.

## 3. The known bounds as descents

**Kahn–Saks–Sturtevant n²/4** (Miller's tutorial, Prop. 5.4). Three intervals in the graph world, increasing convention:

| interval | free set | sub-world | value |
|---|---|---|---|
| I₁ = (vertex v isolated, K_{n−1} on the rest) | E(K_{n−1}) | 𝒢_{n−1} | C_{n−1} |
| I₂ = (star at v, Kₙ) | E(K_{n−1}) | 𝒢_{n−1} | C_{n−1} |
| I₃ = (K_m on a half, K_m plus all edges across) | K_{m,n−m} | bipartite world | m(n − m) |

The descent is **Kₙ →(I₂) star →(I₃) K_m →(I₁) ∅**: I₃'s top contains a star, since a vertex of the clique side is adjacent to everything, and I₁'s top contains K_m, which has isolated vertices. By Theorem 1 the family is unavoidable, so Cₙ ≥ min(C_{n−1}, m(n−m)), and peeling to the largest prime power, where KSS give C_q = C(q,2), yields n²/4 − o(n²). **The famous case analysis — test the star, test the near-clique — is exactly Theorem 1's closure run by hand.**

**Rivest–Vuillemin n²/16.** The same descent, with a weaker certificate for I₃: their only whole-world certificate was a transitive p-group, so the bipartite sub-world needed a prime-power number of edges, forcing equal halves of size 2^j. The escape value drops to (n/4)² in the worst case. *Same game, smaller catalogue.*

**This project's D(h) ≥ μ(n).** For an Oliver group Γ, each maximal chain of Γ-invariant graphs is a descent whose steps add one orbital, certified by Γ acting transitively on it. An adversary with O_min ∈ 𝒰 and Kₙ ∖ O_min ∉ 𝒰 crosses every such chain at O_min, so one group yields exactly μ. **Combining groups is automatic in the framework** — the widest path may switch groups mid-descent, since a step's top need only contain the current configuration up to isomorphism — so the "unexplored direction" in `orbital-evasiveness-notes.md` is simply the widest path over the union of all groups' orbital intervals.

**BBKN's C(n,2) − O(1) for forbidden subgraphs** is the property-specific case: a single interval, fixing O(1) coordinates, whose sub-world has every orbital containing H by Weil's character-sum universality. And **exact evasiveness results** — KSS at prime powers and n = 6, our two-graph and triangle criteria — are whole-world certificates, not descents.

## 4. Why coordinate-transitive escapes stop at n²/4

In a KSS-shaped descent, peel steps recurse to 𝒢_{n−1} and one *escape* interval connects them. The descent's geometry forces two conditions on the escape (U, W): **U has an isolated vertex**, so that I₁'s top contains it, and **W has a universal vertex**, so that it contains the star. Suppose further that the escape's free set is a **single orbit** of Stab(U, W) — the case where a transitive group certifies it outright, and the only case in which the escape is guaranteed to be a fully evasive world.

> **Lemma 2 (single-orbit escape bound).** If U has an isolated vertex, W ⊇ U has a universal vertex, and S = W ∖ U is a single orbit of Stab(U, W), then either (U, W) = (∅, Kₙ) or |S| ≤ ⌊n²/4⌋.

*Proof.* Let Z be U's isolated vertices and Y be W's universal vertices; both are preserved by Stab(U, W). For u ∈ Y and z ∈ Z the pair uz lies in W but not in U, so uz ∈ S, and since S is one orbit every edge of S joins a vertex of Y to a vertex of Z. If some a ∈ Y ∩ Z, every edge at a lies in S (a is universal in W and isolated in U). The edge types {Y∩Z, Y∩Z}, {Y∩Z, Y∖Z}, {Y∩Z, Z∖Y} and {Y∖Z, Z∖Y} are separately preserved, so S, being a single orbit, has one type. If |Y ∩ Z| ≥ 2 and some vertex lies outside Y ∩ Z, the edges at a vertex of Y ∩ Z already have two types — so either Y ∩ Z is everything, giving (∅, Kₙ), or |Y ∩ Z| = 1 and S is a star with n − 1 edges. Otherwise Y and Z are disjoint and |S| ≤ |Y|·|Z| ≤ ⌊n²/4⌋. ∎

*Checked by brute force* at n = 4, 5, 6, 7 over all such escapes whose free set is an Aut(U)-orbit (3, 9, 19 and 58 of them): the maximum is exactly ⌊n²/4⌋ = 4, 6, 9, 12 each time, attained by KSS's bipartite halves.

> **So n²/4 is the ceiling of the regime KSS work in**, not an artefact of their choice: within KSS-shaped descents whose escape is certified by transitivity, no escape has more free edges than the balanced bipartite one. Crossing 1/4 requires either a different descent shape or an escape whose free set has **two or more orbits** — and the latter is where the constants 8/25 and 1/3 live.

## 5. How Korneffel–Triesch cross 1/4: conditional certificates

### 5.1 What they do

From Miller's tutorial (§5.4) — the paper itself we have not read. Split V into V₁, V₂, V₃ with |V₁| = |V₂| = p, a prime near 2n/5, and |V₃| = n − 2p. Restrict h to *tripartite* graphs P, taken together with complete graphs on all three parts: h′(P) = h(P ∪ K_{V₁} ∪ K_{V₂} ∪ K_{V₃}). The group G = ℤ/p × ℤ/p × ℤ/(n−2p) acts by cycling each part. "From this action and some other arguments" they get 8n²/25 − o(n²).

In this note's terms the interval is **(U, Kₙ) with U = three disjoint cliques**, free set the complete tripartite cross edges, p² + 2p(n − 2p) of them — exactly 8n²/25 at p = 2n/5. G has three orbitals on the free set: A between V₁ and V₂, and B, C between V₃ and V₁, V₂. G is Oliver: ℤ/p × ℤ/p is a p-group and the quotient ℤ/(n−2p) is cyclic.

**This interval is not a KSS-shaped escape at all.** Its bottom, three cliques, has no isolated vertex, so Lemma 2's hypothesis is not met — Lemma 2 is evaded, not contradicted.

### 5.2 The topological core, reconstructed

*This is our derivation; it is consistent with Miller's description but not checked against the paper.*

The escape is needed only in the branch KSS could not close — **neither peel crossed** — so h already satisfies two *guard* facts:

- every graph with a **universal vertex** satisfies h (it contains the star, and the star-peel was not crossed);
- every graph with an **isolated vertex** fails h (it lies inside K_{n−1} ⊔ K₁, and the other peel was not crossed).

Now look at the fixed complex of G. **Any union of two orbitals together with U has a universal vertex** — U ∪ A ∪ B makes every vertex of V₁ adjacent to everything — so by the first guard no two orbitals form a face. The complex is a set of isolated points, and χ is the number of orbitals whose addition to U keeps h false. Oliver's theorem forces χ = 1 for a non-evasive h′.

The second symmetry layer finishes it. Swapping V₁ and V₂ preserves U, so h′ is swap-invariant **even though the swap is not in G**; the set of points is therefore ∅, {A}, {B, C} or {A, B, C}, with χ = 0, 1, 2, 3. **So h′ is evasive in every case but one**: the pattern {A}, i.e.

> h(K_{2p} ⊔ K_{n−2p}) = 0 but h(K_{n−p} ⊔ K_p) = 1,

together with the branch h(U) = 1, where the interval is not crossed at all. Those two residual branches are what "some other arguments" must dispose of. We have not reconstructed how.

### 5.3 What this adds to the framework

**Conditional certificates.** Lemma 2 assumed an escape had to be certified *unconditionally* — evasive for every invariant function on its sub-world — which forces a single orbit and caps it at n²/4. Korneffel–Triesch's escape is not an evasive world: with three orbits, some invariant functions on it are cheap. It is **evasive for every function consistent with what the descent has already established** — the guard facts. Those facts kill exactly the bad cases: a function like "every A-edge present" would need U ∪ B ∪ C to fail h, but that graph has a universal vertex.

So interval values must be allowed to depend on the branch: **v(I | 𝒩)**, the minimum complexity over sub-world functions consistent with the facts implied by the intervals 𝒩 not crossed on the way. The game becomes a **case tree**: the prover queries h on finitely many test graphs (star, near-clique, three cliques, …), and each leaf is an interval certified *conditionally on its branch*. The bound is the minimum leaf value, and checking a proposed tree is mechanical — each leaf's certificate is a χ computation over the guard-consistent invariant complexes. KSS is a depth-two tree; §2's widest path is the special case where certificates ignore their branch.

**Two symmetry layers.** The Oliver group G does the topology; the larger stabiliser — here the V₁ ↔ V₂ swap, which G lacks — cuts the χ = 1 patterns down. This is Yao's structure again, where a cyclic group does the topology and Sym(Z) makes the property a threshold. It is also what the project has elsewhere called running an Oliver-like argument where the shoe doesn't fit: the certificate is not "a transitive Oliver group" but "an Oliver group whose χ condition fails on every complex the guards and the full stabiliser allow".

### 5.4 With conditional certificates, the topology stops being the bottleneck

Take k **equal** parts of prime-power size m, all cliqued, and G = (ℤ/m)^k, a p-group. Each pair of parts is one orbital, so a face is a set of part-pairs — an edge set of K_k. The universal-vertex guard forbids any part joined to all k − 1 others; the parts are cliques, so no isolated vertex arises; and the full stabiliser permutes the parts, so the complex is an S_k-invariant down-set of graphs on k vertices with maximum degree ≤ k − 2. *Computed by enumerating every such down-set:*

| k | graph classes | invariant down-sets | down-sets with χ = 1 | escape value |
|---|---|---|---|---|
| 3 | 1 | 2 | **0** | n²/3 |
| 4 | 6 | 11 | **0** | 3n²/8 |
| 5 | 22 | 267 | **0** | 2n²/5 |

**So an equal-parts k-partite escape, whenever it is crossed in the guarded branch, is evasive — with no residual pattern at all.** At k = 3 this is the unequal case with the V₃ asymmetry removed: full S₃ symmetry leaves only ∅ and all three points, χ ∈ {0, 3}. The value (1 − 1/k)·n²/2 is **n²/3 at k = 3, exactly the Scheidweiler–Triesch constant** — which suggests, though we have not checked, that their improvement over Korneffel–Triesch is precisely equalising the parts to remove the residual {A}, peeling to n = 3m with m prime at o(n²) cost.

### 5.5 Where the difficulty went

If topology is not the bottleneck, crossing is. The k-partite escape is crossed only when **h(k·K_{n/k}) = 0**, and the branch h(k·K_{n/k}) = 1 needs different intervals. That branch is not exotic. **"No isolated vertex"** sits in KSS's case 3, yet k·K_{n/k} has no isolated vertex for every k ≤ n/2, so it crosses none of these escapes — checked at n = 12 for k = 2, 3, 4, 6 — and among {peels, bipartite, all-cliqued k-partite} only the bipartite escape pays, at n²/4. Any bound above 1/4 must handle it with an interval built around its own structure: bottoms with isolated vertices, where the restricted function depends only on edges at those vertices.

> **The framework's precise open problem, then:** a case tree whose leaves cover the branch h(k·K_{n/k}) = 1 with conditional certificates of value above 1/3. The equal-parts computation says the k-partite leaf is already worth 3/8 at k = 4 and 2/5 at k = 5 wherever it is reached; what is missing is a leaf for the properties that never reach it. **This is where Korneffel–Triesch's and Scheidweiler–Triesch's unreconstructed arguments must live**, and reading those papers is the first step.

## 6. A computational programme

**(a) The weighted game at small n.** Build the catalogue — peel intervals, bipartite escapes, and every orbital interval of every Oliver subgroup of Sₙ up to conjugacy — and compute the widest path over interval endpoints. At n = 10, the open case, the KSS-shaped descent gives 25 and a single group gives μ(10) = 20; **any value above 25 would be a new explicit lower bound for the famous case**, and a value of exactly 25 would say the weighted game cannot improve it. Feasible: only endpoints and their containments are needed, and the Oliver subgroups of S₁₀ are a finite, GAP-computable list.

**(b) Other descent shapes.** Lemma 2 is scoped to KSS's shape — peel one vertex, isolated or universal. Peeling k vertices with uniform attachment gives other shapes with their own escape conditions; whether any admits a single-orbit escape above n²/4 is a finite question at each n.

**(c) Read the two papers.** Korneffel–Triesch (Combinatorica 30 (2010)) and Scheidweiler–Triesch (SIAM J. Discrete Math. 27 (2013)) — to confirm §5.2's reconstruction, and to see how each handles the residual branches.

**(d) Case trees at small n.** Search for case trees — test graphs plus conditionally certified leaves — that beat the KSS tree, starting with n = 10 and A36's catalogue.

**(e) The branch h(k·K_{n/k}) = 1.** Characterise which properties live there beyond "no isolated vertex", and find conditional leaves for them. By §5.5 this, not topology, is the whole gap between 1/3 and 1/2 within this family of arguments.

## 7. What this buys

For evasiveness, the project's framework reduced proof to a catalogue (groups and their orbitals) plus a mechanical test (χ of the fixed complex). This note does the same for query complexity at the first level: **a catalogue of certified sub-worlds plus a mechanical widest path**. It explains at once why RV and KSS got the constants they did, and why n²/4 is a genuine barrier for escapes certified unconditionally. Past it, the right extension is **conditional certification in a case tree** — which is how Korneffel–Triesch evade Lemma 2 — and once that is allowed, the topology is no longer the obstacle: equal-parts k-partite escapes are evasive in the guarded branch at every k we checked. The open constants live in the branch where those escapes are never crossed.

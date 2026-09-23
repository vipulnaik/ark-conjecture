# The restriction game: a framework for query-complexity lower bounds

*Companion to `orbital-evasiveness-notes.md` and `hardness-of-evasiveness.md`. The evasiveness results in this project run through one framework — a group, its fixed complex, an Euler characteristic — and that framework turned "clever proofs" into a search over groups and arithmetic. The quantitative bounds in the literature (Rivest–Vuillemin n²/16, Kahn–Saks–Sturtevant n²/4, Korneffel–Triesch 8n²/25, the n²/3 bound, BBKN's C(n,2) − O(1) for forbidden subgraphs) look instead like a collection of tricks. This note argues they are strategies in a single game, and that one level of that game reduces to a widest-path computation.*

**Status.** §2's reduction (Theorem 1) and §4's escape bound (Lemma 2) are proved here and checked by computation at small n. §3's reconstructions of KSS and Rivest–Vuillemin are exact. §5 — where the n²/4 barrier is crossed — is a diagnosis, not a reconstruction: we have not read Korneffel–Triesch or the n²/3 paper closely enough to recast their arguments, and say so. **The restriction method itself is standard; whether Theorem 1 or Lemma 2 is folklore has not been checked.**

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

## 5. Beyond 1/4: escapes that are not fully evasive worlds

The later constants match the edge counts of complete tripartite cross structures exactly: parts p, p, n − 2p give p² + 2p(n − 2p), maximised at p = 2n/5 to **8n²/25** (Korneffel–Triesch); equal thirds give **n²/3**. That is consistent with an escape whose free set is the complete tripartite cross edges, and — by Lemma 2 — such an escape cannot be a single orbit.

**And a multi-orbit escape is not a fully evasive world**, which is the structural reason these arguments need more than a weight. Take parts P₁, P₂ cliqued in U and P₃ empty, so the free set has two edge types: X between P₁ and P₂, and Y between them and P₃. The property "every edge of X is present" is nontrivial, monotone and invariant, yet has complexity |X| < |X ∪ Y| — it never needs to look at Y. It even arises as a restriction of a genuine graph property: "contains K_{2|P₁|}" restricts to it on this interval. **So the escape's payoff depends on which function is restricted**, and a fixed weight v(I) can only be the small worst case.

This forces a second level of the game:

> V* = min over h of max { D(h|I) : I crossed by h } ≥ V(ℐ),

in which the prover is paid the restricted function's actual complexity. Arguments at this level establish *conditional certificates*: if h's restriction to one interval is not evasive — AND-like, say — then h crosses some other interval of high value. These link intervals together, so the problem is no longer a widest path. **This is where "and some other arguments" in Miller's description of Korneffel–Triesch sits.** The framework names that level and says what shape its arguments must take, but does not make it mechanical, and we have not reconstructed the actual descents of the 8/25 and 1/3 papers.

One observation sharpens the target. **Large certified worlds exist; the difficulty is reaching them.** Complete k-partite cross edges on k parts of prime size m, with *no* distinguished part, are certified evasive by a transitive Oliver group whenever the parts can be permuted 2-homogeneously by a cyclic-by-q group: Γ = (ℤ/m)^k ⋊ (ℤ/k ⋊ Q), with Q a q-group of multipliers on the k parts. That is possible for Fermat k ∈ {3, 5, 17, 257, 65537}, where Q is the whole multiplier group, and for primes k = 2q^e + 1, where Q has index 2 and −1 supplies the rest on unordered pairs. The chain is (ℤ/m)^k, then ℤ/k, then Q; the full translations make each pair of parts a single orbit, and Q makes all pairs of parts one orbit. The value is (1 − 1/k)·n²/2 — 0.40 at k = 5. But a symmetric k-partite world has no isolated vertex at its bottom and no distinguished part, so it cannot be the escape of a KSS-shaped descent; Lemma 2 says exactly that. The obstacle to beating 1/3 is therefore not certifying big worlds but **making big certified worlds reachable**: either new descent shapes, or conditional certificates for asymmetric ones.

## 6. A computational programme

**(a) The weighted game at small n.** Build the catalogue — peel intervals, bipartite escapes, and every orbital interval of every Oliver subgroup of Sₙ up to conjugacy — and compute the widest path over interval endpoints. At n = 10, the open case, the KSS-shaped descent gives 25 and a single group gives μ(10) = 20; **any value above 25 would be a new explicit lower bound for the famous case**, and a value of exactly 25 would say the weighted game cannot improve it. Feasible: only endpoints and their containments are needed, and the Oliver subgroups of S₁₀ are a finite, GAP-computable list.

**(b) Other descent shapes.** Lemma 2 is scoped to KSS's shape — peel one vertex, isolated or universal. Peeling k vertices with uniform attachment gives other shapes with their own escape conditions; whether any admits a single-orbit escape above n²/4 is a finite question at each n.

**(c) Conditional certificates.** Formalise the second level well enough to recast Korneffel–Triesch as an explicit certificate. Then "is 1/3 the value of the game over known certificates?" becomes a well-posed question rather than a comparison of papers.

## 7. What this buys

For evasiveness, the project's framework reduced proof to a catalogue (groups and their orbitals) plus a mechanical test (χ of the fixed complex). This note does the same for query complexity at the first level: **a catalogue of certified sub-worlds plus a mechanical widest path**. It explains at once why RV and KSS got the constants they did, why n²/4 is a genuine barrier for transitivity-certified escapes, and why every argument past it needed a different kind of reasoning. What it does not yet do is make the second level mechanical — and that is where the open constants are.

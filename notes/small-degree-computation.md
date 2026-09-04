# Small-degree computation: exact evasiveness at n = 10 and n = 12

*Companion to `orbital-evasiveness-notes.md`, `enumeration-proof.md` and `arithmetic-of-density.md`. Those three are about the general framework — Oliver groups, the μ(n) bound, the additive engine. This one is about what happens when a single small degree is attacked exhaustively: what the computation confirms, what it has failed to settle, and why.*

**Reading guide.** §1 says what the exercise is for. §§2–3 set up the objects and the pipeline — §2.0 first, since where each test sits on the metaproperty ladder is what bounds the whole exercise. §4 is the part the rest of the programme depends on — the independent confirmations. §§5–6 are the results at each degree. §7 diagnoses why n = 10 has not fallen. §8 is the barrier analysis. §9 is the algorithmic contrast. §10 collects what is open.

---

## 1. What small-degree computation is for

### 1.1 Three separate jobs

The computations serve three purposes that are easy to run together and should be kept apart, because they have different standards of evidence.

**(a) Cross-validating the framework and the search against each other.** μ(n) is defined as a maximum over Oliver groups, and `enumeration-proof.md` computes a bound B(n) by a *classification* argument — it enumerates configuration shapes and scores them, never touching an actual group. An exhaustive group search computes the same quantity by construction rather than by classification, so agreement is evidence in **both directions at once**: it is the only non-circular check that the classification has not missed a shape, and it is simultaneously the only check that the GAP enumeration, the orbital-map extraction and the Oliver test are computing what they claim to. A disagreement would not say which side was wrong, only that one of them was — which is why §4 records both readings.

**(b) Cross-validating against the literature.** KSS settle n = 6; Adamaszek settles n ≤ 5 and identifies the unique nonevasive property at 5 vertices up to duality (it and its set-complement are the only two — §4.3) — **that one is not monotone**, and the word is worth carrying every time it is cited, since everywhere else in this document "property" means "monotone graph property" per §2.1 and a reader who applies that convention here collides with KSS at the prime 5; Angel–Borja reduce n = 10 to five candidate types by a wholly different method. Reproducing these is cheap, and again it cuts both ways: a reproduction is evidence that the pipeline is correct, and it is also evidence that *our reading of the literature* is correct — that we have the right statement of Oliver's condition, the right notion of the fixed complex, and the right convention for χ. Several of the sign and normalisation conventions in §2 are only pinned down by these reproductions.

*Neither (a) nor (b) is a one-way audit of the code.* Treating them as such is the natural mistake, and it discards half their value: the framework's own statements are what the code is tested against, so the code passing is a statement about the framework too.

**(c) Attacking the conjecture.** If the CSP over a battery of groups is **UNSAT**, ARK holds unconditionally at that degree. This is the only one of the three that could produce a new theorem, and it is the only one that has not succeeded.

### 1.2 The direction of the dependence, and why incompleteness is survivable

Job (a) rests on the group enumeration being exhaustive, which is not proved (§8.5). But the risk is one-directional:

> A group missed by the enumeration can have any minimum orbital, but only a **larger** one would matter: the reported optimum is a maximum over what was enumerated, so a missed group with a smaller m\* changes nothing, and one with a larger m\* would be a counterexample to μ(n) ≤ B(n) — visible as a contradiction, not a silent corruption.

So incomplete enumeration weakens the *evidence* without creating an error. If exhaustiveness cannot be established, the claim "the exhaustive optimum is the predicted construction" weakens to "no group in the enumerated set exceeds B(n)". That is a real loss, since this is the framework's only external check, but it is not a retraction.

Job (c) has the opposite sensitivity. There, **dropping a group drops a constraint**, and dropping constraints can only turn a real UNSAT into a spurious SAT. So a negative verdict survives truncation and a positive one does not. Every truncation knob in the pipeline (§8.4) has to be read with that asymmetry in mind.

### 1.3 Why 10 and 12

The smallest open cases of the right kind. n = 6 is settled by KSS; 7, 8, 9 are prime powers, where the conjecture is a theorem. **n = 10 = 2·5** is the first composite non-prime-power beyond 6, and it is *arithmetically strong*: 5 is a Fermat-adjacent prime, 5 − 1 = 4 is a 2-power, and the wreath construction AGL(1,5)≀C₂ achieves density 20/45 = 0.444, close to the ceiling of 1/2 — which holds for *all solvable* groups at non-prime-power n, not merely Oliver ones (`solvable-relaxation.md` Proposition 1 — stated there over all solvable groups of degree n, transitivity not imposed, matching this framework's own shape space), so the headroom above 0.444 is genuinely small rather than an artefact of the chain condition.

**n = 12 = 2²·3** is the first *arithmetically weak* composite — the density available is 18/66 = 0.273, so the topological obstruction is much weaker relative to n². That makes it the higher-information target: at n = 10 the machinery has enough room that SAT is unsurprising, while at n = 12 both outcomes are genuinely live.

---

## 2. The objects

### 2.0 The metaproperty ladder, and which rung the pipeline lives on

Everything the pipeline tests is a consequence of one implication, and it is worth having the chain in view before the machinery, because the pipeline's reach is exactly a statement about where on it each test sits.

> **non-evasive ⟹ ℤ-acyclic ⟹ 𝔽_p-acyclic for each p ⟹ χ(Δ_P) = 1.**

(There are intermediate rungs — collapsible, contractible — between the first two; they matter for the general theory and not here, since no test in this document distinguishes them.) **ARK is exactly the assertion that the first implication reverses**, and each step to the right discards information: the left end is simplicial, the middle homotopical and homological, the right end a single integer.

**Two families of test hang off this chain, and they are independent.**

| test | needs | form |
|---|---|---|
| Oliver congruences | ℤ-acyclicity | χ(Δ_P^Γ) ≡ 1 (mod q) for each Oliver Γ |
| Smith conditions | 𝔽_p-acyclicity | Δ_P^{P₀} is 𝔽_p-acyclic for p-subgroups P₀ |
| **global χ** | **χ(Δ_P) = 1** | one integer, for the whole complex |

The first two constrain **fixed complexes** — the subcomplexes cut out by a group action. The third constrains **Δ_P itself**, with no group in sight, and asks for χ = 1 *on the nose*, not a congruence. Neither family implies the other, and that is not a technicality: it is exactly why the n = 10 skeleton satisfied every group condition in a 75-group battery and then died to a single integer (§5.4). **When §3.7 says the global test is "not expressible on the CSP variables", this is why** — the CSP's variables are memberships of *orbital unions*, and χ(Δ_P) is a sum over all 12,005,168 isomorphism classes.

**Nothing in the pipeline probes above ℤ-acyclicity, and that is a deliberate consequence of where the evidence is.** The tests are all consequences of acyclicity, so a property passing every one of them — including the global χ test — would not disprove ARK. It would exhibit a nontrivial monotone property whose complex is ℤ-acyclic, which is *strictly weaker* than a counterexample, since ¬ARK additionally demands non-evasiveness. Climbing the ladder means working with collapsibility or non-evasiveness directly, which is what the adversary game of §3.8 does and why it is the only tool here that could settle a candidate outright.

The reason we have not climbed is that **no plausible counterexample to ℤ-acyclicity has turned up.** Every candidate the CSP produced has been killed at the χ = 1 rung — the weakest rung of all — or has survived every rung tested. There has been no case where a property passed χ = 1 and the acyclicity conditions and then needed a finer test, so building machinery for the higher rungs would be building it speculatively. If the n = 12 battery returns SAT and its skeleton survives the global χ test, that changes, and §3.8 becomes the next tool rather than the last resort.

*One structural fact about the bottom rung, which explains the prime-power case.* For n = p^k take Γ = AGL(1, n) = 𝔽_n ⋊ C_{n−1}: an Oliver chain with a **trivial** top layer, so ℤ-acyclicity forces χ(Δ_P^Γ) = 1 exactly — while the invariant graphs are only ∅ and K_n, giving a fixed complex {∅} with χ = 0. That is KSS, and it is the t = 1 row of §2.4 below. But the collapse stops at ℤ-acyclicity: 𝔽_p-acyclicity and χ(Δ_P) = 1 are *not* excluded at prime powers, because Smith theory applied to the translation subgroup leaves a large fixed complex and yields no contradiction. Even where ARK is a theorem, the last two rungs are strictly weaker than the rest.

### 2.1 Fixed complexes and orbital partitions

Let P be a monotone decreasing graph property on [n] and Γ ≤ Sₙ. Γ acts on the C(n,2) pairs; its orbits on pairs are the **orbitals**, and they partition the edge set of Kₙ. A graph is Γ-invariant exactly when it is a union of orbitals, so:

> **Δ_P^Γ is the simplicial complex whose vertices are the orbitals lying in P and whose faces are the sets of orbitals whose union lies in P.**

That family is downward closed because P is. The whole computation is about this complex, and the key consequence is stated here because it governs everything downstream:

> **Δ_P^Γ depends only on Γ's orbital partition, not on Γ.** Two groups with the same partition impose conditions differing only through the prime involved.

That is what makes deduplication possible (§3.2) and what bounds how much a larger battery can buy.

### 2.2 The three conditions on a fixed complex

Refining §2.0's table for the group-dependent tests, which is what the battery enforces:

| source | condition on Δ_P^Γ | when | tag |
|---|---|---|---|
| Oliver's fixed-point theorem | χ(Δ_P^Γ) ≡ 1 (mod q) | Γ is p-by-cyclic-by-q | `q` |
| Oliver, trivial top layer | **χ(Δ_P^Γ) = 1 exactly** | Γ is p-by-cyclic | `0` |
| Smith theory | Δ_P^Γ is 𝔽_p-acyclic | Γ is a p-group | `P<p>` |

The trivial-top case is the harshest — a congruence collapses to an equality — which is why the pipeline tags it separately. The p-group condition is not a congruence but a homological one, and is checked by Smith normal form rather than by an alternating sum.

**Each condition comes in a primal and a dual form.** P^∨ = {G : Ḡ ∉ P} is monotone, nontrivial, and evasive exactly when P is; complements of orbital unions are orbital unions of the *same* group, so the dual bits are y[S] = 1 − x[comp S] — no new variables, a second condition per group for free.

### 2.3 The complement involution

The duality of §2.2 acts on the whole problem. Verified as a property of the computed object at n = 10: **all 1,242 catalog classes have their complement in the catalog, the map is an involution, and no class is self-complementary.** The edge-count distribution is exactly palindromic.

Two consequences, one useful and one cautionary:

- **Useful.** Probing one representative per complement pair halves the backbone sweep, and forced-IN classes must pair with forced-OUT ones. Measured: 30 confirmed pairs, **0 violations**.
- **Cautionary.** The involution is a symmetry of the *solution set*, not of any solution. Applying it to the n = 10 solution gives another valid solution — 0 χ violations, 0 monotonicity violations, empty graph IN, Kₙ OUT — but with **1,028 IN classes against the original's 214**, differing at 814 of 1,242. Any argument from "the surviving property is sparse" must reckon with a dense partner the CSP cannot distinguish.

### 2.4 The fixed-complex criterion, and why small t is where the force is

Since a face is a set of orbitals whose union is in P, and the all-orbitals face is barred (its union is Kₙ, making P trivial), the condition is a finite constraint once the orbital count **t** is small. Enumerating every downward-closed family on t vertices and filtering by χ ≡ 1 (mod q):

| t | what survives |
|---|---|
| **1** | **nothing** — recovers the classical result that a 2-homogeneous Γ forces evasiveness |
| **2** | exactly one orbital in P; their union not in P |
| **3** | two orbitals ⟹ their union is forced into P. All three ⟹ at odd q, exactly two of the three pairwise unions lie in P and no triple union — the complex is a *path*, singling out one orbital. At q = 2 there is one extra option (χ = 3, no pairwise union) |
| **4** | loose: several patterns survive at every q. The constraint stops being interesting |

**Force comes from few orbitals, not many** — the opposite of the intuition that more orbitals means more constraint. With t orbitals there are only t + 1 possible values of the orbital-count-in-P, and by t = 4 the congruence has enough complexes to hide in. This governs the battery-selection question of §8.4.

**Empirically confirmed at n = 10**: recomputing χ on the found solution, **every t ≤ 3 group has χ = 1 exactly, primal and dual** — including the ones required only to satisfy χ ≡ 1 (mod q), and the one extra option the criterion permits at t = 3, q = 2 is not taken.

---

## 3. The pipeline

Seven stages, each checkpointed, each with an independent failure mode.

### 3.1 GAP enumeration (`ark_gap.g`)

Four stages, chosen because GAP's comparative advantage is subgroup lattices and the transitive-groups library:

| stage | what | n = 10 | n = 12 |
|---|---|---|---|
| **A** | every transitive group of the degree | 24 | 194 |
| **B** | direct products of transitive groups over partitions into ≤ 4 parts | 319 | 969 |
| **B2** | imprimitive wreath products T(d,k) ≀ T(r,j) with dr = n | 6 | 28 |
| **C** | subgroups of each Sylow p-subgroup up to conjugacy | 618 | 5,924 |
| | **emitted** | **967** | **7,115** |

Each emitted line carries a key, a description, a tag, and the orbital map. The tag is `P<p>` for a p-group, `0` for a trivial top, or a `+`-separated list of usable top primes.

**The Oliver test is sound, and now exercised against negatives.** `IsOliverTop` iterates over normal subgroups N, checks N/O_p(N) cyclic for some p, and records q only when Γ/N is verified to be a q-group. Taking Γ₂ = O_p(N) is WLOG since any normal p-subgroup with cyclic quotient lies in O_p(N); normality in Γ is automatic because O_p(N) is characteristic in N ◁ Γ. The same predicate, verbatim, passes a negative-control battery (`oliver_negative.g`): seven asserted simple-group negatives, a 160-group transitive population at degrees 6–11 that it separates 108 to 52 with eleven solvable failures, agreement with the chain-witness check on 71 fused shapes, and four deliberately broken chains rejected one clause at a time. So the `oliver` column is a predicate demonstrated to vary, not a constant.

**What was dropped is recorded and large.** At n = 12, `done_keys.txt` has 16,353 keys against 7,115 emitted, so **9,238 groups were built and discarded** — non-Oliver, or exceeding the `MAXT = 12` orbital cap. That is 56% of everything GAP constructed, and it bounds what raising MAXT could add.

### 3.2 Deduplication by orbital partition

By §2.1 a group's condition depends only on (orbital partition, prime). Deduplicating on that pair is exact, and the reduction is enormous: at n = 12, **7,115 groups impose only 425 distinct conditions** (94.0% redundant), and at the `--maxt 8` cut, 2,293 groups impose 230.

**The key must be a complete invariant of the partition, and the first one shipped was not.** `consume_gap.py` originally keyed on (orbital count, sorted sizes, tag, per-vertex valency signature) — strong but incomplete — and used it to *discard*. Measured at n = 12: **41 of 278 collision buckets merged inequivalent partitions**, and the retained representatives covered 381 of the 425 conditions — 44 dropped, 10.4% overall and **22.4% of the Smith conditions**. The failure direction is the dangerous one (§1.2): a dropped condition turns a real UNSAT into SAT. The corrected key canonicalises the partition itself, via a layered graph with a node per point, per pair and per orbital, so a colour-preserving isomorphism must carry orbitals onto orbitals.

**The loss is worse at n = 10, and that is where the published results are.** The same measurement against the n = 10 file gives **40 Oliver conditions kept where 125 exist**, so the published battery carried **75 of 167 available conditions, 45%** — a three-to-one merge rather than n = 12's ten percent. Everything in §5 was computed on that battery; §5.1 states the consequence and §10 carries the rerun.

*A trap for anyone re-measuring this.* Ordering tied orbitals by their GAP index makes the canonical form index-dependent, over-splits equivalent partitions, and inflates the apparent loss roughly sevenfold. Tied orbitals must share a colour class.

### 3.3 The union-graph catalog

Each group of t orbitals contributes 2^t union graphs; membership depends only on isomorphism class, so the classes are pooled across groups. Overlap is heavy — the class count grows sublinearly in the group count, which is itself the check that the isomorphism dedup is working. At n = 10 the 75-group battery gives **V = 1,242**; at n = 12 the 227-group battery gives **V = 2,212**.

### 3.4 The containment order matrix

Monotonicity needs the subgraph-monomorphism order on the V classes — V² ordered pairs, decided by VF2 in the worst case. The rebuilt stage is **inference-first**: within-lattice mask containments are free by construction; equal-edge-count distinct classes are automatically non-embeddable; invariant domination (degree sequence, triangles, P₃, C₄) excludes most negatives; and two-sided transitive closure runs to fixpoint after every parallel VF2 batch.

**Acceptance passed at n = 10**: the rebuilt matrix is *bit-identical* to an archived full-VF2 reference — **249,711 true entries, density 0.162** — so two algorithmically independent computations agree, one deciding every pair by VF2 and one deciding ~80% by inference. Independently re-verified here: reflexive, 0 antisymmetry violations, 0 transitivity violations in 1,655 sampled chains.

The inference rate transfers across degrees almost exactly: **19.9% of ordered pairs need VF2 at n = 10, 20.6% and 20.8% at n = 12** on the two batteries. The invariant filters are degree-generic.

### 3.5 The CSP solver (`stage4_fast.py`)

Variables are the V membership bits. Constraints: empty graph IN, Kₙ OUT, monotonicity along the order matrix, and per-group primal+dual χ or 𝔽_p-acyclicity. The solver is event-driven — each group's condition fires exactly when the last class in its lattice becomes decided, so harsh conditions prune high in the tree — with memoization on (group, lattice bit-pattern).

**Two defensive features earned by past bugs.** The variable ordering is a greedy group-completion: repeatedly take the group with the fewest unplaced classes and append them, so whole lattices close early. And every leaf **re-verifies every group** and raises on failure rather than warning — a leaf reached with a failing group means the pending-count bookkeeping has desynchronised, which is the exact signature of an earlier false-SAT bug, and degrading it to a warning would make a silent undercount indistinguishable from a correct run.

### 3.6 Backbone probing (`probe_backbone.py`)

The CSP's solution set is large, so the informative object is the **backbone**: classes whose value is the same in every solution. For each class c and value v, pin x[c] = v and solve. (c,0) UNSAT ⟹ c forced IN; (c,1) UNSAT ⟹ forced OUT; both SAT ⟹ free; either CAP ⟹ undetermined at the node budget. UNSAT and SAT verdicts are exact; only CAP is inconclusive.

### 3.7 The global χ test (`chi_test.py`)

For downward-closed P, let S = Σ over *labelled* G ∈ P of (−1)^{|E(G)|}. Then χ(Δ_P) = 1 − S, and since D(f) ≥ deg(f) with degree C(n,2) exactly when the top Fourier coefficient is nonzero:

> **S ≠ 0 ⟹ P is evasive**, with no game search.

This is the decisive test, and — as §2.0 sets out — it is **not expressible on the CSP variables**: it constrains Δ_P itself rather than a fixed complex, and asks for χ = 1 on the nose rather than a congruence. The CSP constrains only catalog classes, so a solution does not determine a property. The test therefore applies to the *minimal monotone extension* of a solution's IN set: take the maximal IN classes as generators and enumerate the full down-closure by edge-deletion BFS with nauty canonicalisation.

### 3.8 The adversary game (`adversary.py`)

Exact evasiveness of a fully specified property by adversary search over canonical states. The state (L, A) of known-present and known-absent edges is canonicalised as a two-layer 2n-vertex coloured graph, turning the game tree into a DAG over isomorphism classes. Used as a last resort when the χ screen passes.

---

## 4. What the computations confirm

This is the section the rest of the programme cites.

### 4.1 The optima match the predicted constructions

| | exhaustive maximum m\* | achieved by | B(n) predicts |
|---|---|---|---|
| **n = 10** | **20** (density 0.444) | 8 groups, **1 orbital partition** [20, 25], 2 distinct conditions — incl. `B2:5x2:3.1` = T(5,3) ≀ T(2,1), the wreath, and a trivial-top witness (`A:18`, order 200) | Theorem 2.1 at m = 5: 2·C(5,2) = 20 |
| **n = 12** | **18** (density 0.273) | 8 groups, **1 orbital partition**, 3 distinct conditions | the wreath bound at (𝔽₄⋊C₃)≀C₃ |

> **Both optima are the fused matching shape at its closed form, which is a second independent confirmation and a sharper one.** `arithmetic-of-density.md` §2.1 gives δ_S2(n) = (Q(n) − 1)/(n − 1) for every non-prime-power n, Q the largest prime-power divisor — an identity derived from the shape space with no group computation in it. At **n = 10**: Q = 5, F = 2, value 2·C(5,2) = **20**, density 4/9 = 0.4444. At **n = 12**: Q = 4, F = 3, value 3·C(4,2) = **18**, density 3/11 = 0.2727. Both agree with the exhaustive search exactly.
>
> That is worth more than it looks. These are the only two degrees where μ is known by *construction* rather than by classification, and at both of them μ equals the universal fused shape's own value — so the identity is checked against ground truth, not against another bound. It also explains the attainer structure recorded above rather than leaving it a coincidence: a single orbital partition at both degrees, because there is essentially one optimal shape and it is this one. **The framework's whole difficulty lies at the n where this shape is not good enough**, and neither 10 nor 12 is such an n.

**Exceeded zero ways at both degrees, and the attainer structure is parallel.** At n = 12 the eight attainers are the seven transitive groups `A:85, 164, 166, 207, 228, 229, 265` together with **`B2:4x3:4.1` = T(4,4) ≀ T(3,1)** — the direct confirmation that the wreath construction attains the optimum, rather than merely being consistent with it. All eight share the orbital partition **[18, 48]**, tags six at q = 3, one at q = 2, one at `0`: **the optimum is witnessed by a trivial-top group**, hence by χ = 1 exactly, the harshest condition available. At n = 10 the same three-way count holds — eight attainers, one partition, two conditions — with the wreath among them as `B2:5x2:3.1` and the trivial-top witness an **order-200** group rather than the order-800 wreath — a fused-class realisation with cyclic quotient, of the same order and orbital partition as the entangled-generator construction of `arithmetic-of-density.md` §3.2.3. (Two non-isomorphic order-200 realisations share that partition, the entangled one and the block-permutation-plus-twist one, neither containing the other; the record does not say which `A:18` is, and for the trivial-top point it does not matter.)

Note the shape of both optima: **t = 2**, so §2.4's criterion applies at its sharpest. At n = 10 it reads *any counterexample contains exactly one of 2K₅ (20 edges) and K₅,₅ (25 edges)*; at n = 12, *exactly one of the 18-edge and 48-edge orbitals*.

### 4.2 The lemma spot-checks

At n = 10 the enumeration's structural lemmas were checked against the actual orbits: **1,061 full-capacity orbits, all of prime-power size**, and all 88 prime-sized ones satisfying Lemma B′'s condition. These support Part I of `enumeration-proof.md` and §2.4 of the notes.

### 4.3 Reproduction of known results

- **n = 6** (KSS) reproduces.
- **n ≤ 5** (Adamaszek) reproduces, including the eleven-graph nonevasive property at 5 vertices and its set-complement being the only two. **That property is not monotone** — up to negation, complementation and the other obvious symmetries it is the unique nontrivial nonevasive property at 5 vertices — and the qualifier is load-bearing here rather than pedantic: n = 5 is prime, so among *monotone* properties KSS already gives evasiveness outright, and a reader carrying §2.1's convention will read this line as contradicting that.

  **It is also a different kind of check from the other two, which is the reason to keep it.** KSS at n = 6 and Angel–Borja at n = 10 exercise the Oliver machinery — the fixed-complex conditions and the CSP that consumes them. Adamaszek's property is outside that machinery entirely, monotonicity being what the group conditions are stated for. What reproducing it tests is the **decision-tree side**: the evasiveness computation of `adversary.py` (§3.8), on an input where the CSP has nothing to say. So it is the only entry in this list that validates the one tool capable of settling a candidate outright, and the only one whose success is consistent with ARK rather than an instance of it.
- **The 10-vertex isomorphism-class count** comes out at 12,005,168, matching the known value — a check on the enumeration streams used for the χ computations.
- **Angel–Borja's n = 10 reduction** is a genuinely independent method: isomorphism-class counting mod p, with Oliver groups used to force *named* members rather than to extract a size. Their five surviving types (I₂, I₄, I₅, I₆, I₈ of a 10-element poset) are stated as sets of isomorphism classes, so they are directly testable against this CSP — reproducing their four eliminations would be non-circular validation, and killing more would be an increment. **Not yet run**, and **the paper is not yet in `literature-findings.md`**: the five types are quoted here at second hand, so the run needs the primary source first or it validates against a possibly mis-transcribed target.

### 4.4 Internal cross-checks

- Order matrix bit-identical against an independent full-VF2 reference (§3.4).
- Catalog complement-closed with no self-complementary class (§2.3).
- Involution predictions on the backbone: 30 confirmed pairs, 0 violations.
- The published n = 10 solution independently re-verified here: recomputing primal and dual χ from the tags for all 40 Oliver groups in the battery gives **0 violations**, plus 0 monotonicity violations, empty IN, K₁₀ OUT.

---

## 5. Results at n = 10

### 5.1 The battery

967 groups → 75 selected: tags {trivial-top 18, q = 2 17, q = 3 5, P2 29, P3 3, P5 2, P7 1}, orbital counts 2 through 10, V = 1,242 classes.

> **This is 75 of 167 available conditions, and the shortfall is the old dedup key's, not the orbital cap's.** The `--maxt 10` cut leaves 167 distinct (partition, prime) conditions in the n = 10 file; the key that produced the 75 was the incomplete invariant of §3.2, which merged Oliver conditions roughly three to one — 40 kept where 125 exist (`small-degree-verification.md` item 7). By §1.2's asymmetry this is safe for §4.1's μ(10) = 20, which is read off `groups_out.txt` and never touches the battery, and unsafe in exactly one direction for everything in §§5.2–5.5: **dropping conditions can only turn a real UNSAT into a SAT.**

### 5.2 SAT, and the surviving skeleton

The CSP is **satisfiable on the 75-condition battery**, and has remained so across every escalation of that battery — every one of which was taken under the same truncation (§5.1), so the run on the full 167 conditions is untried rather than confirmatory.

> **What the SAT/UNSAT question is now worth, given §5.4.** Every solution the CSP has produced, including this one's canonical extension, has died to the global χ test. So the operative question is not "is the CSP satisfiable" but "does any solution survive χ = 1" — and those are different searches, because χ is not expressible on the CSP's variables (§3.7: the variables are memberships of orbital unions, χ is a sum over all 12,005,168 iso classes). Running the full 167 conditions answers the first question and leaves the second untouched; a battery that returns UNSAT settles the degree outright, but a battery that returns SAT has, on the evidence so far, produced another χ kill rather than a candidate. **That argues for spending the next effort on a χ-magnitude screen inside the probe loop rather than on battery size** — which is the same conclusion §8.4 reaches from the constraint-strength side, and it makes item 12's cost/strength measurement less informative than it looks, since it measures the wrong one of the two questions. The found solution has 214 IN classes, IN edge counts running 0–25 and OUT 8–45. Its skeleton — the maximal IN classes, which generate the minimal monotone extension — has **10 generators at 12, 13, 15, 15, 15, 15, 18, 18, 20, 25 edges**.

Consistent with §2.4: the solution has 2K₅ **in** and K₅,₅ **out**, which is exactly the one-of-two the two-orbital criterion demands, satisfied legitimately. That is why n = 10 remained SAT and why the global χ test was needed.

### 5.3 The backbone

817 probes over 409 classes: **25 forced IN** (0–10 edges: the empty graph, K₃, K₄, C₁₀, the perfect matching, K₁,₈, assorted forests), **20 forced OUT** (35–45 edges), **310 free**, **54 CAP**. Discovery is steady at ~5.5 forcings per 100 probes with no decay.

**The geometry is not density-stratified**, which was the natural first guess. Classes with ≤ 4 edges are uniformly forced IN (8 of 8) and ≥ 41 uniformly forced OUT (5 of 5), but where forcings occur they interleave with free classes at the same edge count — 29 free classes at ≤ 10 edges. And the forced sets do not reach across the middle: forcings occur only at 5, 6, 8, 9, 10 and at 35, 36, 38, 39, 40.

**No invariant-based heuristic predicts the backbone.** Classes 5 and 43 are both 35-edge, 7-regular, with 50 triangles *and* 200 four-cycles — yet 43 is forced OUT and 5 is free. The distinction lives in the complement (43 = co-C₁₀, 5 = co-(C₅⊔C₅)) and follows from the involution plus the facts that C₁₀ is forced IN while C₅⊔C₅ is free.

A detail that bears on §9: **K₁,₈ is forced IN but K₁,₉ — the spanning star — is free**, so an admissible property may exclude the spanning star.

### 5.4 The χ kill

Nine minimal completions have been killed *exactly* by the global χ test, via three cross-validated methods: an exponential formula over signed connected-component weights, a two-sort EGF log(eˣ + eʸ − 1) for bipartite components, and nauty/geng streams. χ values run from ~1.8×10⁴ to ~9.3×10⁵ in absolute value, against the required conspiracy value of 1. Samples: χ(closure K₅,₅) = **−288,729**; χ(α ≥ 5) = 36,541; χ(max-deg ≤ 1) = **−1,215 = −5·3⁵**, the matching complex M₁₀, a recognisable object with known homology.

**The published solution's own canonical extension is a tenth kill, and the largest.** Running `chi_test.py` on `solution1.pkl` enumerates a down-closure of **64,333 iso classes** (153,468,934,696 labelled graphs) and returns S = −15,183,000, hence **χ = 15,183,001** — an order of magnitude outside the nine above. So the §5.2 skeleton dies to the same one-integer test that every other candidate has, which is what §2.0's "died to a single integer" refers to and why the SAT of §5.2 has never become a candidate counterexample.

Remaining: nine patterns involving two structural closures (subgraphs of C₅[K₂]; of C₅⊔C₅ ∪ K₅,₅) that need a dedicated subgraph-class enumeration.

### 5.5 The free band is not established

Forced IN reaches 10 edges, forced OUT begins at 35 — but the **54 CAP classes span 9 to 36 edges**, straddling both boundaries. A CAP class is *not* known to be free; free requires both pinnings SAT.

So "the band is free from 11 to 34" is unsupported, and so are its **endpoints**. This matters operationally: the escalation rule keys on band width (a narrowing band suggests the dual χ-magnitude screen will close it; a static band suggests the miss is lattice-decoupling and the full subgroup enumeration is the escalation). The observed 24-edge band looks static, but that is not yet a measurement. **Re-probing the 54 CAP classes at a larger node budget is much cheaper than the escalation it would inform.**

---

## 6. Results at n = 12

### 6.1 The census

**7,115 groups** = 295 trivial-top + 657 at q = 2 + 67 at q = 3 + 6,096 p-groups (6,004 at p = 2, 88 at p = 3, 2 at p = 5, 2 at p = 11). All lines well-formed with 66-entry orbital maps. Deduplicating: **425 distinct (partition, prime) conditions**, 309 Oliver and 116 p-group.

### 6.2 The optimum

m\* = 18, as in §4.1 — the one result at n = 12 that is complete.

### 6.3 Where it stands

Stage 3 has not finished on any battery. The 600-class battery reached 22% across four sessions; the 2,212-class battery has 1,018,719 VF2-requiring pairs and is projected at 22 days (§8.2). **No SAT/UNSAT verdict exists at n = 12.**

---

## 7. Why n = 10 has not fallen: the one-sidedness diagnosis

### 7.1 Every constraint pushes graphs *into* P

The mechanism behind the persistent SAT is structural rather than computational.

- **χ conditions** are satisfied by making the fixed complex contractible, which is easiest when more unions are IN.
- **𝔽_p-acyclicity** likewise.
- **Monotone propagation** carries IN downward and never generates an OUT.
- **The only OUT-generator in the entire system is nontriviality** — the single constraint that Kₙ ∉ P.

So the constraint system is **one-sided**. Adding groups adds IN-pressure and almost no OUT-pressure, which is why escalating the battery has not changed the verdict and, on this analysis, would not be expected to. *The mechanism is structural and does not depend on which battery was run; the empirical half of the claim does, and every escalation so far was inside the 75-condition truncation (§5.1). The full-battery run is the diagnosis's cheapest test as well as its cheapest threat.*

### 7.2 The cone escape

Run against the Smith battery with ℤ₅² and ℤ₉, all patterns survive, and the *mechanism* of survival is the finding: **every surviving fixed complex is a cone** — there is an orbital O with U ∈ P ⟹ U ∪ O ∈ P, which makes the complex contractible for free. Blocking cones requires OUT-forcing that the patterns do not have.

**The cone escape is self-dual.** Adding the full dual battery cuts 878 joint patterns to 138 — a factor of 6.4 — but all 18 original patterns survive in projection. The free middle band is contractible from either direction whenever the lattices are decoupled from the band's boundary.

### 7.3 Why KSS wins at prime powers

At n = p^k the available groups are 2-homogeneous, so **t = 1**: the fixed complex has one potential vertex, and §2.4's t = 1 row says no complex survives. Equivalently, the coarse lattice makes IN-forcing plus the single top OUT jointly unsatisfiable. At composite n the lattices are finer, the IN-forcing does not reach the OUT-forcing, and a free middle band opens.

### 7.4 The two-orbital criterion sharpens but does not close

§2.4's t = 2 row gives *exactly one of 2K₅ and K₅,₅ lies in P* — a strengthening of the disjunctive "at least one", and hence of the disjunctive density statement of 0.444. But it is a **case split, not a contradiction**: both branches are consistent downward-closed properties, and the found solution takes the first legitimately.

This is the general shape of the difficulty. With t orbitals the criterion has only t + 1 values of the orbital-count to exclude, and at t = 2 exactly one survives. Sharpening the constraint at the groups the framework favours — few, large, heavily fused orbitals — cannot produce a contradiction, only a narrower consistent set.

---

## 8. Barriers to scale

### 8.1 The catalog

Class count is driven by the largest lattices: a group with t orbitals contributes up to 2^t unions. At n = 10 the 75-group battery gives V = 1,242; at n = 12 the 227-group battery gives V = 2,212. Since every later stage is at least quadratic in V, **the marginal cost of a high-t group is far above its marginal constraint value** — which §2.4 says is near zero past t = 4.

The cost profile is currently inverted. At n = 10, 93% of the battery's Σ2^t lattice cost sits at t ≥ 7, where the criterion is weakest; t ≤ 3, where it is decisive, is 0.6%.

### 8.2 Stage 3 is the wall

Measured throughput from the n = 12 logs: 2,176 VF2 calls resolving 16,061 pairs in 30,002 s — 7.4 pairs per call at 13.8 s per call, i.e. **0.54 pairs/s**, with yield decaying as the easy pairs go first.

| battery | V | ordered pairs | need VF2 | projected |
|---|---|---|---|---|
| 59 groups | 600 | 359,400 | 74,213 (20.6%) | ~39 h |
| **227 groups** | **2,212** | **4,890,732** | **1,018,719 (20.8%)** | **~22 days**, 33–41 at the late rate |

The inference *rate* transfers intact from n = 10 — the invariant filters are degree-generic — but 13.6× the classes means 13.7× the work. One mitigating fact the projection ignores: the pairs-needing-VF2 count **falls on resume** as closure propagates (20.6% → 17.8% → 16.8% across three sessions), so these are upper bounds.

### 8.2a A cost model for stage 3 at n = 10, calibrated, and what the full battery will take

*Benchmarked with the shipped `consume_gap.py`, `networkx` 3.6.1 and the real n = 10 `groups_out` file. Stages 1–2 and the stage-3 inference were run to completion on the full 167-condition battery (`--estimate-only`, 8 minutes, most of it stage-2 catalog canonicalisation), so **V and the VF2 pair count below are measured, not modelled.** The per-call VF2 cost is measured on 600 invariant-passing pairs drawn from that catalog; the closure cost on the shipped `close()`.*

**The full battery, measured.** The 167 distinct conditions give **V = 2,902** union-graph classes (2.34× the published 1,242), complement-closed with a palindromic edge-count histogram peaking at 134 classes at 21 and 24 edges. Ordered pairs 8,418,702; free containments 170,572; invariant/size exclusions 6,259,977; **1,482,293 pairs (17.6%) need VF2 after closure** — the same fraction range §8.2 saw at n = 12, and below the 24.5% pre-closure figure of the published run.

**Two costs, and the second is the one nobody had priced.**

1. **VF2.** Mean **290 ms per call on the real catalog** (600 sampled pairs: median 13 ms, p90 0.70 s, p99 6.0 s, worst 9.5 s; 57% embed). A random-graph proxy at the same degree gives 64 ms — **4.5× too optimistic** — and the published V = 1,242 wall time of 6.5 h happens to match the proxy figure rather than the real one, which is a warning about calibrating from a single wall-clock datum. The mechanism is the one §8.2 identified at n = 12: orbital unions are near-regular, and near-regular non-embeddings are VF2's worst case. **Use 290 ms**, and expect the post-closure survivors to skew harder still, since closure removes the easy pairs first.

2. **Closure.** `close()` is pure Python over V-bit integers and scales as roughly **V^2.6**: 0.7 s at V = 1,242, 4.1 s at 2,500, 15 s at 4,000 (steady-state pass, measured). It runs **once per batch**, and the batch was `max(64, 16·procs)` = 128 pairs at 8 procs. That is invisible at V = 1,242 (0.5 h total) and dominant past V ≈ 2,000: at V = 3,000 it is **30 h against 4.4 h of VF2**, at 4,000 it is **112 h against 7.8 h**. `consume_gap.py` now takes `--batch`, defaulting to `max(2048, 256·procs)`, which removes the term at a cost of a few percent more VF2 calls from lost propagation. **Do not run the full battery at the old batch size.**

**The model.** With N_VF2 pairs surviving inference, on `procs` cores with batch B:

> T_VF2 ≈ 0.29 s × N_VF2 / procs   T_closure ≈ (N_VF2 / B) × 0.7 s × (V/1242)^2.6

**For the 167-condition battery, N_VF2 = 1,482,293 and V = 2,902:**

| cores | VF2 | closure @ 2048 | closure @ 128 (old default) | **total @ 2048** |
|---|---|---|---|---|
| 8 | 14.9 h | 1.3 h | 21 h | **~16 h** |
| 16 | 7.5 h | 1.3 h | 21 h | **~9 h** |
| 32 | 3.7 h | 1.3 h | 21 h | **~5 h** |

Single-threaded it is 120 h of VF2, which is what the old row-based loop would have taken. The closure column is serial and does not shrink with cores, so past ~32 cores it is the floor. **At the old batch size the closure alone exceeds the VF2 work on 8 cores**, which is why `--batch` exists and defaults to 2048.

**Read the projection as a lower estimate by perhaps 1.5×.** The 290 ms is over invariant-passing pairs; the pairs that reach VF2 are those closure could not decide either, which selects toward the hard tail. The run's own per-batch log lines give the true rate in the first ten minutes and the instructions in `small-degree-verification.md` say to read them.

**For other batteries** — the 189 conditions of the whole file at `--maxt 12`, or the TOM-enlarged set — V is not known but is minutes to compute: `consume_gap.py --estimate-only` runs stages 1–2 and the inference, prints V, N_VF2 and the projected hours from this model, and exits before any VF2 call.

**Stage 2 is no longer free at this size.** The catalog canonicalisation (`Catalog.classify`, linear scan with `nx.is_isomorphic` within an invariant bucket) took most of the 8-minute sizing run at V = 2,902 and grows roughly as V × (bucket size); it is minutes, not hours, but it is not the seconds the earlier draft of this section assumed, and it is checkpointed.

**The remaining stages are cheap at any plausible V.** Stage 4 (`stage4_fast.py --first`) found its first verified solution in 30–90 s at V = 1,242 across five logged runs, 5,500–7,200 nodes/s; it is a CSP over V booleans and will grow, but not to hours. The `--verify 3000` sample is 3,000 VF2 calls, minutes. The TOM stage in `ark_gap.g` reads class representatives from a precomputed table and then costs one `Orbits` and one `NormalSubgroups` call per group; minutes, not hours, though `NormalSubgroups` on the largest non-Oliver groups (A₁₀, S₁₀ itself) is the step to watch.

**What this model does not cover.** n = 12: nothing here transfers except the closure term, since the per-call VF2 cost there is 13.8 s (§8.2), fifty times the n = 10 figure.

### 8.3 The down-closure at n = 12

The global χ test enumerates the full down-closure with a canonicalisation per node: 64,333 classes and about 60 s at n = 10. At n = 12 the ambient count is 1.65×10¹¹ isomorphism classes, and the closure of an 18-edge-or-larger generator set may exceed any practical cap. Since **the χ test is the only test that has actually killed anything**, losing it at n = 12 would be a real loss. The alternative is the exponential-formula route of §5.4, which computes S without enumerating the closure.

### 8.4 Truncation, and which knob actually bites

Two knobs silently discard conditions, and the documentation has been attending to the smaller one. Distinct (partition, prime) conditions at n = 12 as a function of the orbital cap:

| `--maxt` | 4 | 5 | **6** | 7 | **8** | 10 | **12** |
|---|---|---|---|---|---|---|---|
| groups | 264 | 392 | 892 | 1,541 | 2,293 | 4,803 | 7,115 |
| **conditions** | 36 | 73 | **125** | 169 | **230** | 339 | **425** |

`--maxgroups 200` drops **3** conditions (203 distinct Oliver conditions capped to 200). `--maxt 8` drops **195**. So the current battery uses 54% of the available conditions, and the proposed remedy of dropping to `--maxt 6` would use 29%.

By §1.2 this only endangers a positive verdict, so both truncations are safe for the μ results of §4.1 and unsafe for any UNSAT claim.

### 8.5 Exhaustiveness: the subdirect-product hole

The four GAP stages are **not obviously exhaustive over intransitive imprimitive groups.** Stage B builds *direct* products of transitive constituents. An intransitive group whose projections onto its orbits are transitive but which is a **proper subdirect product** — a fibre product over a common quotient — is generated by neither B nor B2, and C reaches it only if it happens to be a p-group.

This is the concrete gap. By §1.2 it cannot corrupt the μ results; it can only mean the enumeration is not the exhaustive check it is advertised as.

> **It is closable by construction rather than by argument, and cheaply.** Enumerating *every* conjugacy class of subgroups of S_N settles it outright — a subdirect product is a subgroup like any other — and the reason that was written off as heavy is that the `FULL` stage calls `ConjugacyClassesSubgroups(S_N)`, which is the expensive step and the one item 5b flags as never confirmed to have finished. **The table of marks is the way round it:** TomLib ships precomputed tables for the symmetric groups in this range, and `RepresentativeTom` returns a representative of each class with no subgroup computation at all. `ark_gap.g` now carries this as stage **`TOM`**, off by default, logging the class count rather than predicting it, and falling back with a message if no table exists for the degree.
>
> **What it would buy is the difference between the two readings of §1.2**, and it buys it at both degrees at once. Job (a) upgrades from "no enumerated group exceeds B(n)" to the exhaustive statement the framework's only external check is supposed to make — which matters because §4.1's μ(10) = 20 and μ(12) = 18 are the only two degrees where μ is known by construction rather than by classification. Job (c) gets the complete condition set in place of the union-of-stages battery, which is the direction that can only help, since dropping conditions is what turns a real UNSAT into a spurious SAT. **Run it before spending anything further on battery size** — it dominates the escalation of §5.1, which is a bigger subset of an unknown whole.

A second, smaller question: `ConjugacyClassesSubgroups` on the Sylow 2-subgroup is the expensive step and is not internally checkpointable, so any completeness claim for stage C depends on that call having finished. Mitigating for the headline: p-subgroups do not attain the optimum at either degree.

### 8.6 A dead strengthening

`IsOliverTop` returns *every* usable top prime as a `+`-separated tag, and the solvers enforce χ ≡ 1 mod the lcm — strictly stronger than any single chain. **No group at either degree has a multi-prime tag.** Across 8,082 groups the tags are exactly `0`, `2`, `3` and `P*`. Either the emitted files predate the change, or no group in this range admits two usable top primes and the strengthening is worth nothing. A known-current run of the same predicate over the 160 transitive groups of degrees 6–11 (`oliver_negative.g`) also returns no two-prime verdict, which is weight on the second reading without settling the emitted files — those include intransitive and p-subgroup stages the population does not. One re-emission distinguishes the readings; if the answer is the second, the path should be retired rather than left as dead code.

---

## 9. The algorithmic side: what monotonicity costs

The **scorpion property** (Best–van Emde Boas–Lenstra) is the standing example of a nontrivial *non-monotone* graph property decidable in O(n) queries. Its engine is celebrity-elimination: sting (degree exactly 1), tail (exactly 2) and body (exactly n − 2) are pinned by **two-sided** degree constraints, so every query answer disqualifies some vertex for some role — "present" can kill a sting or tail candidacy, "absent" a body candidacy — giving linear convergence to an O(n)-checkable witness.

**Monotonicity destroys the engine by fiat**: a positive answer can never disqualify anything. That is the same one-sidedness that §7.1 finds on the topological side, appearing on the algorithmic side, and it is why the two halves of the ledger point the same way.

The connection to §5.3 is worth noting. K₁,₈ is forced IN while the spanning star K₁,₉ is free — so an admissible property *may* exclude the spanning star, i.e. may have a degree-based upper constraint of exactly the kind the scorpion argument exploits. The gap between the two settings is narrower than the phrase "monotone properties are handicapped" suggests.

---

## 10. Open questions

**Settled and not at risk:** μ(10) = 20 and μ(12) = 18 over the enumerated groups, exceeded zero ways; the optima match the predicted constructions; the order matrix and the involution are verified. *These read off `groups_out.txt` or the catalog directly and are untouched by the battery truncation of §5.1 — the SAT verdict and everything derived from it are not on this list.*

**Open, in rough order of expected value:**

1. **Rerun the n = 10 CSP on the full 167-condition battery.** The published SAT was computed on 75 of 167 available conditions (§5.1), the old dedup key having merged the rest, and dropping conditions can only turn a real UNSAT into a SAT — so the positive verdict does not transfer. This is the cheapest run on the list (stage 3 has completed at n = 10 before) and **the only one whose outcome could settle a degree outright**: UNSAT settles n = 10, and SAT puts the framework's only satisfiability claim on an untruncated battery and hands `chi_test.py` a fresh skeleton worth killing.
2. **Run a cheap n = 12 battery.** A `--maxt 6` cut is 125 conditions with a much smaller catalog, and stage 3 scales with V², so plausibly hours rather than weeks. If it returns UNSAT, n = 12 is settled and neither the 22-day stage 3 nor the closure machinery of §8.3 is needed. If SAT, the result is a solution to χ-test and the §8.3 question becomes concrete. **This ordering inverts the current dependency and should be checked first.**
3. **Re-probe the 54 CAP classes** at a larger node budget, before any statement about the free band or any escalation decision that depends on its width (§5.5).
4. **Probe the 15 unprobed involution partners** of the forced classes — `414, 434, 439, 457, 493` (predicted forced IN, 7–9 edges) and `541, 543, 548, 549, 555, 560, 561, 562, 565, 566` (predicted forced OUT, 37–43 edges). Each is a cheap two-sided test of the duality of §2.3 and would roughly double the known backbone if it confirms.
5. **Run the n = 10 CSP against Angel–Borja's five surviving types** (§4.3). Non-circular validation if it reproduces their eliminations; a publishable increment if it kills more. *(The arithmetic programme deprioritises this: the exhaustive n = 10 and n = 12 m\* comparisons validate the machinery more strongly. Its standing is as an increment on Angel–Borja, not as validation the framework is waiting on.)*
6. **Close the subdirect-product hole via the table of marks** (§8.5) — the only thing standing between "no enumerated group exceeds B(n)" and "the exhaustive optimum is the predicted construction", and now a run rather than a research question: stage `TOM` in `ark_gap.g`, which reads subgroup-class representatives out of TomLib instead of computing them. **Highest value per unit effort of anything on this list**, since it upgrades the framework's only external check at both degrees simultaneously.
7. **Decide how S is computed at n = 12** (§8.3): full down-closure versus the exponential-formula route.
8. **Settle the multi-prime tag question** (§8.6) and either exercise or retire the lcm strengthening.
9. **Climb the ladder, if a candidate ever warrants it** (§2.0). Nothing in the pipeline probes above ℤ-acyclicity, because no candidate has yet survived the χ = 1 rung to need it. If the n = 12 battery returns SAT and its skeleton passes the global χ test, the adversary game of §3.8 stops being a last resort and becomes the next tool — and `adversary.py` should be validated against Adamaszek's ℰ as a negative control before any EVASIVE verdict from it is trusted.
10. **The two structural closures** at n = 10 (subgraphs of C₅[K₂], of C₅⊔C₅ ∪ K₅,₅) that the χ kill has not reached (§5.4).

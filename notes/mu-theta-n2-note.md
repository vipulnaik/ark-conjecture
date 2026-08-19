# Sparse evasiveness up to a positive edge density, conditionally

*A short self-contained note. Background assumed: Babai–Banerjee–Kulkarni–Naik, "Evasiveness and the distribution of prime numbers" (arXiv:1001.4829), henceforth BBKN. A version with LaTeX markup, for pasting into a LaTeX document, is in `mu-theta-n2-note-latex.md`; the two are identical in content.*

## 1. The invariant

Let Γ ≤ S_n. The **u-orbitals** of Γ are its orbits on the C(n,2) unordered pairs from [n]; write **m\*(Γ)** for the smallest of them. Call Γ an **Oliver group** if it admits a normal chain

> 1 ◁ Γ₂ ◁ Γ₁ ◁ Γ

with Γ₂ a p-group, Γ₁/Γ₂ cyclic, and Γ/Γ₁ a q-group, for some primes p, q. These are exactly the groups to which Oliver's fixed-point theorem applies. Define

> **μ(n) = max { m\*(Γ) : Γ ≤ S_n an Oliver group }.**

Throughout we measure μ against the number of pairs, writing

> **δ(n) = μ(n) / C(n,2)**

for the *density*. All constants below are stated in this unit; since C(n,2) ~ n²/2, a density δ corresponds to about δn²/2 edges.

The relevance is the standard orbital-annihilation argument, which we recall to fix conventions. Let P be a nontrivial monotone-decreasing graph property on n vertices, and Δ(P) its simplicial complex on the vertex set E(K_n). If P is nonevasive then Δ(P) is collapsible, hence ℤ-acyclic; Oliver's theorem then gives χ(Δ(P)^Γ) = 1 for any Oliver group Γ. But Δ(P)^Γ consists of the Γ-invariant graphs in P, and every such graph is a union of u-orbitals. So if every u-orbital of Γ exceeds the edge budget of P, the only invariant member is the empty graph, χ(Δ(P)^Γ) = 0, and we have a contradiction. Hence:

> **Proposition 1.** If every graph in P has fewer than μ(n) edges, then P is evasive.

BBKN's Theorem 1.4 is exactly this route with μ(n) ≥ n^(3/2−ε) for all sufficiently large n, obtained under Chowla's conjecture on the least Dirichlet prime; their conclusions are likewise eventual. Our object here is the growth rate of μ(n) itself.

## 2. The result

> **Theorem.** Assume Hypothesis (H) below. Then μ(n) = Θ(n²) — equivalently, δ(n) ≥ δ₀ for an absolute constant δ₀ > 0 and **all sufficiently large n**. Consequently, for all sufficiently large n, every nontrivial monotone graph property on n vertices whose members have fewer than δ₀·C(n,2) edges is evasive — in BBKN's terminology, such properties are **eventually evasive**.

The "sufficiently large" is inherited from (H) and is not an artefact of the argument: Proposition 1 is exact at every n, but it is (H) that supplies a suitable group at a given n, and (H) is an eventual hypothesis. For any particular n one can of course check directly whether a construction exists, and §4 records one infinite family for which no hypothesis is needed at all.

The upper bound is trivial: δ(n) ≤ 1, since a single u-orbital cannot exceed the number of pairs. Everything below concerns the lower bound.

> **Hypothesis (H).** Every sufficiently large n admits primes q, r, c with
>
> 1. n = c + r if n is even, and n = 2c + r if n is odd;
> 2. c ≥ n/5 and r ≥ n/5 (which, with condition 1, bounds both above too: c, r ≤ 4n/5 for even n, and c ≤ 2n/5, r ≤ 3n/5 for odd n);
> 3. r = d·q + 1 for some d ∈ {2, 4, 6, 12};
> 4. r ∤ c − 1.

**(H) is a parametric Hardy–Littlewood hypothesis, combining a Goldbach-type split with a Sophie Germain condition on the same variable.** Two things need separating, since they have different status: the classification of modular obstructions, which is routine, and the existence claim itself, which is not.

*What is routine.* Substituting condition 3, the system becomes three **linear** polynomials in the single variable q:

> q,  dq + 1,  and  n − dq − 1  (n even)   or   (n − dq − 1)/2  (n odd),

required to be simultaneously prime. Write L1, L2, L3 for the three and ω(ℓ) for the number of residues q mod ℓ at which L1·L2·L3 vanishes; an obstruction is ω(ℓ) = ℓ, meaning ℓ divides one of the three for *every* q. Two mechanisms can produce one, and the split between them is what confines the analysis:

> **ℓ ∤ d.** Each form is genuinely linear mod ℓ, so contributes at most one root, and ω(ℓ) ≤ 3 < ℓ for ℓ ≥ 5.
>
> **ℓ | d.** Now L2 = dq + 1 ≡ 1 never vanishes, but L3 **degenerates to a constant**, which vanishes identically when ℓ | (n−1) — resp. ℓ | (n−1)/2 — giving ω(ℓ) = ℓ outright. The bound from the first mechanism does not apply here.

Since every permitted d has only 2 and 3 as prime factors, **both mechanisms are confined to ℓ ≤ 3**. That is also the real reason the list is {2, 4, 6, 12}: these are exactly the even d whose prime factors lie in {2, 3}, which keeps the local analysis finite and the table indexed mod 12 — a d with a larger prime factor, 10 say, would open a degeneration channel at 5. Nor does any higher power of 2 or 3 force a longer list: the ℓ = 3 condition is decided mod 3, and the ℓ = 2 condition — because of the halving in L3, explained below — is decided mod 4, which the freedom in d mod 4 already covers. Nothing imposes a condition mod 8 or mod 9.

The degeneration is not a corner case: it is precisely what excludes d ∈ {6, 12} at n ≡ 1 (mod 3). With d = 6 and n = 100, the form L3 = 99 − 6q is identically 0 mod 3, since 3 divides both 99 and 6. The two conditions on n are therefore a condition mod 4 and a condition mod 3 — that is, mod 12. (Mod 4 rather than mod 2 because of a change of variable, explained just below.) This is exactly what the four permitted values of d are for:

> | n mod 12 | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
> |---|---|---|---|---|---|---|---|---|---|---|---|---|
> | admissible d | all | 2 | 6, 12 | 4, 12 | 2, 4 | 6 | all | 4 | 6, 12 | 2, 6 | 2, 4 | 12 |

**Why the list runs to 12 and not to 6.** A reader expecting one factor for ℓ = 2 and one for ℓ = 3 would predict d ≤ 6. The extra factor of 2 comes from a change of variable, and is worth spelling out since it is easy to notice and not easy to guess.

Write d = 2e. The leading 2 is forced immediately: q is an odd prime, so r = dq + 1 is odd only if d is even. That is the first appearance of ℓ = 2, and it fixes the leading factor.

Now r mod 4 is determined by d mod 4, since q is odd: d ≡ 2 (mod 4) gives r ≡ 3 (mod 4), and d ≡ 0 (mod 4) gives r ≡ 1 (mod 4). For **even** n this is irrelevant — c = n − r is odd automatically, being even minus odd. For **odd** n it is not, because the third polynomial is **(n − dq − 1)/2**, not n − dq − 1. That halving is the change of variable. It means the parity of c — which is what ℓ = 2 controls — depends on n − r modulo **4** rather than modulo 2:

> c = (n − r)/2 is odd ⟺ n − r ≡ 2 (mod 4),

so d ≡ 2 (mod 4), i.e. d ∈ {2, 6}, serves odd n ≡ 1 (mod 4), while d ≡ 0 (mod 4), i.e. d ∈ {4, 12}, serves odd n ≡ 3 (mod 4). This is ℓ = 2 biting a **second** time, and it costs a second factor of 2 — but only in the odd case.

With ℓ = 3 contributing a factor 3 independently, the pattern is exactly

> **d = 2e with e | 6**, so e ∈ {1, 2, 3, 6} and d ∈ {2, 4, 6, 12},

the leading 2 making r odd, the 2 in e fixing n mod 4, and the 3 in e fixing n mod 3. Hence max d = 2 × 6 = 12. Had we needed only even n, d ∈ {2, 6} would suffice and the list would stop at 6.

The list {2, 4, 6, 12} is what *these* block patterns require, not an intrinsic feature of the problem: other constructions reach some classes with smaller d, and in particular the d = 12 demand at n ≡ 11 is specific to the two-block-plus-remainder shape used here.

Every class has at least one admissible d, so (H) is locally soluble at every n. But more than *positivity* of the singular series S(n, d) is needed, and more is available: ℓ cannot divide both n and n−1, so at most one root coincidence occurs at each ℓ ≥ 5, and a coincidence *raises* the corresponding factor above 1 — the bad primes only help. Hence

> **S(n, d) ≥ 4 · (9/8) · C0 = 2.858249…,   where C0 = ∏ over ℓ ≥ 5 of (1 − 3/ℓ)(1 − 1/ℓ)⁻³ = 0.635166…,**

uniformly in n and d, the two leading factors coming from ω(2) = 1 and ω(3) ≤ 2. The uniformity is what the hypothesis needs, not just positivity: pointwise positivity would leave open a sequence of n along which S decays and the predicted count falls below 1. With the uniform bound, the heuristic count of valid q is ≫ n/log³n — a lower bound with an absolute constant, which is all (H) requires. It is not a two-sided ≍: the upper side carries a log log n from the primes dividing n(n−1). This local analysis is the standard singular-series computation and is insensitive to the system being parametric — the local densities at each prime ℓ are read off the polynomials in the usual way, with n entering only as a residue.

*What is not routine.* (H) is **not** a Bateman–Horn statement, and we do not claim it as one. Bateman–Horn concerns a **fixed** system of polynomials, counting x ≤ X with all fᵢ(x) prime as X → ∞; twin primes is the model case. Here the polynomials move with n, the variable q is confined to roughly [1, n/d], and at fixed n there is no limit to take. What (H) asserts is that the representation count is **positive for every large n** — a statement about a family of systems indexed by n, in the tradition of the Hardy–Littlewood circle method as applied to Goldbach, not of the fixed-system asymptotics.

The comparison with Goldbach is close enough to be worth stating plainly, but (H) is not of Goldbach type *alone*: n = c + r with both prime is Goldbach-like, while r = dq + 1 with both prime is a Sophie Germain condition, independently twin-prime-hard. Neither implies the other, and (H) demands both simultaneously on the same variable. Binary Goldbach has one free variable and two primality conditions; our system has one free variable and three, so per shape it is a strictly stronger demand. Against that, (H) is a **disjunction** over eight shapes — two block patterns and four values of d — and needs only one of them to succeed. (H) is therefore of broadly Goldbach difficulty: it is not implied by any published result, and we do not expect it to be provable by current methods. Two classes are worth noting. At n ≡ 11 (mod 12) — the only class obstructed at both 2 and 3 — **d = 12 is forced**, which is why the list must run that far. And d must always be even, since q is odd and r = dq + 1 must be an odd prime.

Condition 3 is deliberately weaker than "r is a safe prime" (d = 2). Demanding d = 2 throughout would restrict n to the classes in which 2 is admissible above — 0, 1, 4, 6, 9, 10 — and fail outright on the other six. Condition 4 is a divisibility side condition, and a very weak one: since 0 < c − 1 < n and r ≥ n/5, r | c − 1 forces c − 1 ∈ {0, r, 2r, 3r, 4r}, so it excludes at most five values of q — O(1), not a set of positive density — and it does not interact with the local analysis.

## 3. The constructions

Fix q, r, c and set t := q = (r−1)/d, as in (H).

### Even n = c + r

Partition [n] into blocks A of size c and B of size r, identified with ℤ/c and ℤ/r. Let

> **Γ = AGL(1, c) × (ℤ/r ⋊ C_t)**,

where the first factor acts on A by all affine maps x ↦ λx + β, and the second on B by y ↦ ηy + γ with η ranging over the subgroup of order t in (ℤ/r)\*.

**Oliver's condition.** Take Γ₂ = ℤ/c (translations of A), a c-group; Γ₁ = AGL(1, c) × (ℤ/r); and Γ/Γ₁ = C_t, a q-group. Then

> Γ₁/Γ₂ ≅ C_(c−1) × C_r,

which is cyclic precisely because gcd(c−1, r) = 1 — this is what condition 4 of (H) secures.

**Orbitals.** Within A: the translations make pairs equivalent to their differences, and (ℤ/c)\* acts transitively on those, so all C(c,2) pairs form one orbital. Within B: differences are scaled by C_t, giving orbitals of size rt/2 if t is even and rt if t is odd, capped at C(r,2). Across: all cr mixed pairs form one orbital. Hence

> m\*(Γ) = min { C(c,2), rt/2, cr } ≥ min { C(c,2), r(r−1)/24, cr } ≥ C(n,2)/350

for n large, using c, r ≥ n/5.

### Odd n = 2c + r

Now take two blocks A₁, A₂ of size c and one block B of size r, and let

> **Γ = ( (ℤ/c)² ⋊ C_(c−1) ) × (ℤ/r ⋊ C_t)**,

with (ℤ/c)² translating A₁ and A₂ independently and C_(c−1) acting **diagonally**, by the same scalar on both blocks.

**Oliver's condition.** As before, with Γ₂ = (ℤ/c)² and Γ₁/Γ₂ ≅ C_(c−1) × C_r cyclic. The diagonal action is essential: two independent copies of C_(c−1) would make Γ₁/Γ₂ non-cyclic and destroy the chain.

**Orbitals.** C(c,2) within each A_i; c² between A₁ and A₂; the B-orbitals as before; cr from each A_i to B. Hence

> m\*(Γ) = min { C(c,2), c², rt/2, cr } ≥ C(n,2)/350

again. This proves the Theorem with **δ₀ = 1/350**, i.e. roughly n²/700 edges. Both bounds come from minimising 2·min{ x²/2, y²/24, xy } — respectively 2·min{ x²/2, x², y²/24, xy } — over the region cut out by condition 2 — x = c/n and y = r/n both at least 1/5, with x + y = 1 (even) or 2x + y = 1 (odd) — the factor 2 converting from n² to C(n,2). The worst density is **1/300** in each case, attained at the corner where the foreign block is smallest, so 1/350 is slack but not by much.

**Verification.** Both constructions have been checked by direct computation of the permutation groups and their orbit decompositions on pairs. For n = 12 = 5 + 7 with t = 3: |Γ| = 420 and the orbitals are {10, 21, 35}. For n = 17 = 2·5 + 7: |Γ| = 2100 and the orbitals are {10, 10, 21, 25, 35, 35}.

## 4. What is unconditional, and what the constant is

One infinite family needs no hypothesis. For n = 2m with m an odd prime power, take two blocks of size m with the diagonal twist and a block swap; the resulting group is Oliver with q = 2, its orbitals are m(m−1) and m², and so

> μ(2m) ≥ m(m−1), i.e. δ(n) = 1/2 − o(1).

This is best possible up to the o(1): for non-prime-power n an Oliver group has at least two u-orbitals, which partition the C(n,2) pairs, so m\*(Γ) ≤ ⌊C(n,2)/2⌋ and δ(n) ≤ 1/2. (Density 1 would force 2-homogeneity, hence primitivity, hence prime-power degree.)

The constant δ₀ above is deliberately crude. Optimising the block sizes and the efficiency t/(r−1) gives materially better constants. The local conditions at the primes 2 and 3 depend on n modulo 12, but the optimised constants are keyed **modulo 12** as well, with the residue entering through the efficiency available to the foreign block; the optimisation is finer, the modulus the same.

A companion computation, which we do not reproduce here, scans four explicit families of such constructions — each written down directly as a permutation group, with its minimum orbital in closed form — and exhibits one at every composite non-prime-power n it covers, giving

> δ(n) ≥ 0.0462 for every composite non-prime-power n ≤ 10⁵,

the scan's minimum over the range being attained at n = 2759. These are lower bounds, which is all the present argument needs; over that range the density therefore never falls below **16 times** the δ₀ = 1/350 proved above. *(A matching upper bound — and hence exact values of μ — is the object of a companion classification of the possible orbit structures together with a finite search over the resulting configurations. That is separate work, and nothing here depends on it.)*

The comparison is worth making carefully, because the two statements have different quantifiers and the computation is the stronger of the two on that axis. The Theorem gives δ(n) ≥ 1/350 **for all sufficiently large n**, and says nothing about any particular n. The computation gives δ(n) ≥ 0.0462 for **every** composite non-prime-power n in [6, 10⁵] — a global statement over its range, with no exceptional set: the minimum is attained at n = 2759, well inside the range, and small n sit comfortably above it (δ = 0.400 at n = 6, 0.273 at n = 12). So 1/350 is conservative not merely as an eventual constant but as a global one, and no n is currently known at which δ is small.

## 5. Comparison with BBKN and Shparlinski

BBKN obtain μ(n) ≥ n^(3/2−ε) under Chowla's conjecture, and note that 3/2 is a natural barrier for their method: it is the exponent at which the least-prime-in-an-arithmetic-progression input runs out. The present route replaces that input with a Goldbach-type one and passes the barrier, at the cost of a different and not obviously comparable hypothesis. Neither (H) nor Chowla is known to imply the other.

**All the bounds in this direction, ours included, are governed by one exponent.** The constructions consume a foreign block of prime size r whose twist has order a large divisor of r − 1, so what is needed is a large prime-power divisor of a shifted prime: writing P(r−1) > r^θ for what can be guaranteed, the block contributes about r^(1+θ) and, with r of order n, the family delivers **n^(1+θ)**. BBKN's Chowla bound is θ = 1/2. Hypothesis (H) is the **θ = 1 endpoint**, which is why it yields n² and why it is of Goldbach rather than Bateman–Horn difficulty.

**Shparlinski (2014) supplies the strongest unconditional results on that scale**, and they are the most directly comparable predecessors to what is proved here. Bombieri–Vinogradov gives θ = 1/4 and hence **μ(n) ≥ n^(5/4+o(1)) unconditionally, for all large n** — which already matches BBKN's ERH bound with no hypothesis at all, so that ERH statement should not be quoted as the state of the art. Using instead the Baker–Harman result on shifted primes with a large prime factor, θ = 0.677 gives **μ(n) ≫ n^(1.677)**, though now for **almost all** n rather than all large n; the exponent in the underlying shifted-prime input has since been improved to 0.679 (Runbo Li, arXiv:2508.18285, 2025 — stated there for infinitely many primes; the almost-all transfer uses the positive-proportion form, which the method supplies, as it does for Baker–Harman's 0.677).

The quantifiers matter and are easy to blur in our favour. On the *all large n* row the unconditional record is 5/4; the two larger exponents, 1.677 and 3/2, both carry exceptional sets, and 3/2 is in any case conditional. Against that scale, the present result is the θ = 1 endpoint under a hypothesis, for all sufficiently large n.

**What the documented conditional routes reach, and where they stop.** Shparlinski also records (2014, §5) what the Elliott–Halberstam conjecture would give on the same scale: extending the averaging in his Theorem 1 raises 5/4 to 3/2 − ε for every ε > 0 — the exponent BBKN obtain from Chowla, by a different and arguably weaker conjecture, since Chowla's route concerns individual progressions — and allowing any α < 1 in his Theorem 2 raises 1.677 to 2 − ε for every ε, still for almost all n. **This is the natural comparison for the present result, and the gap is not only in the quantifier.** A bound of n^{2−ε} for every ε is consistent with n²/log n; what is proved here is δ₀·C(n,2), a *fixed positive fraction* of the maximum. The reason no strengthening of Elliott–Halberstam closes that gap is visible in the hypothesis: the α-ladder asks for a prime factor of r − 1 of size r^α with α approaching 1, whereas (H) asks for one of size (r − 1)/d with d ≤ 12, linear in r — a Sophie Germain-type condition, independently twin-prime-hard, and strictly stronger than every rung rather than the ladder's limit.

The resulting evasiveness statement — every nontrivial monotone property whose members have fewer than δ₀·C(n,2) edges is eventually evasive — covers a positive fraction of the full edge set, and so is a proportional rather than a sub-polynomial sparsity condition. In particular it covers every property with o(n²) edges, and more besides; "O(n²) edges" would be vacuous, since every graph has at most C(n,2) of them. It does not settle Aanderaa–Rosenberg–Karp: the full conjecture concerns all monotone properties, and Proposition 1 gives nothing once the edge budget exceeds C(n,2)/2, which is the ceiling for any group of non-prime-power degree.

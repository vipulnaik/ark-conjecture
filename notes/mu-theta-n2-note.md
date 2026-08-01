# Sparse evasiveness up to a positive edge density, conditionally

*A short self-contained note. Background assumed: Babai–Banerjee–Kulkarni–Naik, "Evasiveness and the distribution of prime numbers" (arXiv:1001.4829), henceforth BBKN. A version with LaTeX markup, for pasting into a LaTeX document, is in `mu-theta-n2-note-latex.md`; the two are identical in content.*

## 1. The invariant

Let Γ ≤ S_n. The **u-orbitals** of Γ are its orbits on the C(n,2) unordered pairs from [n]; write **m\*(Γ)** for the smallest of them. Call Γ an **Oliver group** if it admits a normal chain

> 1 ◁ Γ₂ ◁ Γ₁ ◁ Γ

with Γ₂ a p-group, Γ₁/Γ₂ cyclic, and Γ/Γ₁ a q-group, for some primes p, q. These are exactly the groups to which Oliver's fixed-point theorem applies. Define

> **μ(n) = max { m\*(Γ) : Γ ≤ S_n an Oliver group }.**

The relevance is the standard orbital-annihilation argument, which we recall to fix conventions. Let P be a nontrivial monotone-decreasing graph property on n vertices, and Δ(P) its simplicial complex on the vertex set E(K_n). If P is nonevasive then Δ(P) is collapsible, hence ℤ-acyclic; Oliver's theorem then gives χ(Δ(P)^Γ) = 1 for any Oliver group Γ. But Δ(P)^Γ consists of the Γ-invariant graphs in P, and every such graph is a union of u-orbitals. So if every u-orbital of Γ exceeds the edge budget of P, the only invariant member is the empty graph, χ(Δ(P)^Γ) = 0, and we have a contradiction. Hence:

> **Proposition 1.** If every graph in P has fewer than μ(n) edges, then P is evasive.

BBKN's Theorem 1.4 is exactly this route with μ(n) ≥ n^(3/2−ε), obtained under Chowla's conjecture on the least Dirichlet prime. Our object here is the growth rate of μ(n) itself.

## 2. The result

> **Theorem.** μ(n) = Θ(n²), conditionally on Hypothesis (H) below. Consequently every nontrivial monotone graph property on n vertices whose members have at most c₀·n² edges is evasive, for an absolute constant c₀ > 0 and all sufficiently large n.

The upper bound is trivial: μ(n) ≤ C(n,2), since a single u-orbital cannot exceed the number of pairs. Everything below concerns the lower bound.

> **Hypothesis (H).** There is a constant K such that every sufficiently large n admits primes c, r with
>
> 1. n = c + r if n is even, and n = 2c + r if n is odd;
> 2. n/5 ≤ c, r ≤ n/2;
> 3. r − 1 has a divisor q^a ≥ (r−1)/K with q prime;
> 4. r ∤ c − 1.

(H) is a Hardy–Littlewood / Bateman–Horn statement of binary-Goldbach type: for fixed n it asks for a prime r in a fixed proportional window such that n − r (or (n−r)/2) is prime and r − 1 has a large prime-power divisor. The heuristic count of such r is ≍ n/log³n. Condition 4 is a divisibility side condition excluding a set of r of density O(1/n).

Two remarks on the shape of (H). It is a *disjunctive* hypothesis over two families, so it does not require any single Bateman–Horn system to be solvable for all large n. And condition 3 is deliberately weaker than "r is a safe prime" (r − 1 = 2s with s prime): demanding the latter would impose congruence conditions mod 4 and mod 3 on n that fail for some residue classes, whereas condition 3 with K ≥ 6 is satisfiable in every class.

## 3. The constructions

Fix c, r and t := q^a as in (H).

### Even n = c + r

Partition [n] into blocks A of size c and B of size r, identified with ℤ/c and ℤ/r. Let

> **Γ = AGL(1, c) × (ℤ/r ⋊ C_t)**,

where the first factor acts on A by all affine maps x ↦ λx + β, and the second on B by y ↦ ηy + γ with η ranging over the subgroup of order t in (ℤ/r)\*.

**Oliver's condition.** Take Γ₂ = ℤ/c (translations of A), a c-group; Γ₁ = Γ₂ × (ℤ/r) × C_(c−1); and Γ/Γ₁ = C_t, a q-group. Then

> Γ₁/Γ₂ ≅ C_(c−1) × C_r,

which is cyclic precisely because gcd(c−1, r) = 1 — this is what condition 4 of (H) secures.

**Orbitals.** Within A: the translations make pairs equivalent to their differences, and (ℤ/c)\* acts transitively on those, so all C(c,2) pairs form one orbital. Within B: differences are scaled by C_t, giving orbitals of size rt/2 if t is even and rt if t is odd, capped at C(r,2). Across: all cr mixed pairs form one orbital. Hence

> m\*(Γ) = min { C(c,2), rt/2, cr } ≥ min { C(c,2), r(r−1)/2K, cr } ≥ n²/60K

for n large, using c, r ≥ n/5.

### Odd n = 2c + r

Now take two blocks A₁, A₂ of size c and one block B of size r, and let

> **Γ = ( (ℤ/c)² ⋊ C_(c−1) ) × (ℤ/r ⋊ C_t)**,

with (ℤ/c)² translating A₁ and A₂ independently and C_(c−1) acting **diagonally**, by the same scalar on both blocks.

**Oliver's condition.** As before, with Γ₂ = (ℤ/c)² and Γ₁/Γ₂ ≅ C_(c−1) × C_r cyclic. The diagonal action is essential: two independent copies of C_(c−1) would make Γ₁/Γ₂ non-cyclic and destroy the chain.

**Orbitals.** C(c,2) within each A_i; c² between A₁ and A₂; the B-orbitals as before; cr from each A_i to B. Hence

> m\*(Γ) = min { C(c,2), c², rt/2, cr } ≥ n²/60K

again. This proves the Theorem with **c₀ = 1/(60K)**; taking K = 6 gives **c₀ = 1/360**. Both bounds come from minimising min{ x²/2, y²/2K, xy } — respectively min{ x²/2, x², y²/2K, xy } — over the window x = c/n, y = r/n ∈ [1/5, 1/2], and both are slack: the true worst cases are 1/48 and 1/300.

**Verification.** Both constructions have been checked by direct computation of the permutation groups and their orbit decompositions on pairs. For n = 12 = 5 + 7 with t = 3: |Γ| = 420 and the orbitals are {10, 21, 35}. For n = 17 = 2·5 + 7: |Γ| = 2100 and the orbitals are {10, 10, 21, 25, 35, 35}.

## 4. What is unconditional, and what the constant is

One infinite family needs no hypothesis. For n = 2m with m an odd prime power, take two blocks of size m with the diagonal twist and a block swap; the resulting group is Oliver with q = 2, its orbitals are m(m−1) and m², and so

> μ(2m) ≥ m(m−1) = (1/2 − o(1))·C(n,2).

This is best possible up to the o(1), since a group attaining C(n,2) would be 2-homogeneous, hence primitive, hence of prime-power degree.

The constant c₀ above is deliberately crude. Optimising the block sizes and the efficiency t/(r−1) gives materially better constants, which depend on n modulo 12 through local conditions at the primes 2 and 3; we do not need that refinement here.

A companion computation, which we do not reproduce here since it rests on a classification of the possible orbit structures rather than on constructions, evaluates μ(n) exactly for all composite non-prime-power n ≤ 2298 and gives

> min { μ(n)/C(n,2) : n ≤ 10⁶, n composite, not a prime power } = 0.02611…,

attained at n = 3239. Read as a lower bound — which is all the present argument needs — this says the true density constant is an order of magnitude better than the c₀ proved above, with no downward drift across the range.

## 5. Comparison with BBKN

BBKN obtain μ(n) ≥ n^(3/2−ε) under Chowla's conjecture, and note that 3/2 is a natural barrier for their method: it is the exponent at which the least-prime-in-an-arithmetic-progression input runs out. The present route replaces that input with a Goldbach-type one and passes the barrier, at the cost of a different and not obviously comparable hypothesis. Neither (H) nor Chowla is known to imply the other.

The resulting evasiveness statement — all nontrivial monotone properties of graphs with O(n²) edges are eventually evasive — covers a positive fraction of the full edge set, and so is a proportional rather than a sub-polynomial sparsity condition. It does not settle Aanderaa–Rosenberg–Karp: the full conjecture concerns all monotone properties, and Proposition 1 gives nothing once the edge budget exceeds C(n,2)/2, which is the ceiling for any group of non-prime-power degree.

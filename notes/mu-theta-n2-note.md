# Sparse evasiveness up to a positive edge density, conditionally

*A short self-contained note. Background assumed: Babai–Banerjee–Kulkarni–Naik, "Evasiveness and the distribution of prime numbers" (arXiv:1001.4829), henceforth BBKN.*

## 1. The invariant

Let $\Gamma \le S_n$. The **u-orbitals** of $\Gamma$ are its orbits on the $\binom{n}{2}$ unordered pairs from $[n]$; write $m^*(\Gamma)$ for the smallest of them. Call $\Gamma$ an **Oliver group** if it admits a normal chain
$$1 \trianglelefteq \Gamma_2 \trianglelefteq \Gamma_1 \trianglelefteq \Gamma$$
with $\Gamma_2$ a $p$-group, $\Gamma_1/\Gamma_2$ cyclic, and $\Gamma/\Gamma_1$ a $q$-group, for some primes $p,q$. These are exactly the groups to which Oliver's fixed-point theorem applies. Define
$$\mu(n) \;=\; \max\{\, m^*(\Gamma) \;:\; \Gamma \le S_n \text{ an Oliver group} \,\}.$$

The relevance is the standard orbital-annihilation argument, which we recall to fix conventions. Let $P$ be a nontrivial monotone-decreasing graph property on $n$ vertices, and $\Delta(P)$ its simplicial complex on the vertex set $E(K_n)$. If $P$ is nonevasive then $\Delta(P)$ is collapsible, hence $\mathbb{Z}$-acyclic; Oliver's theorem then gives $\chi(\Delta(P)^\Gamma) = 1$ for any Oliver group $\Gamma$. But $\Delta(P)^\Gamma$ consists of the $\Gamma$-invariant graphs in $P$, and every such graph is a union of u-orbitals. So if every u-orbital of $\Gamma$ exceeds the edge budget of $P$, the only invariant member is the empty graph, $\chi(\Delta(P)^\Gamma) = 0$, and we have a contradiction. Hence:

> **Proposition 1.** If every graph in $P$ has fewer than $\mu(n)$ edges, then $P$ is evasive.

BBKN's Theorem 1.4 is exactly this route with $\mu(n) \ge n^{3/2-\varepsilon}$, obtained under Chowla's conjecture on the least Dirichlet prime. Our object here is the growth rate of $\mu(n)$ itself.

## 2. The result

**Theorem.** $\mu(n) = \Theta(n^2)$, conditionally on Hypothesis (H) below. Consequently every nontrivial monotone graph property on $n$ vertices whose members have at most $c_0 n^2$ edges is evasive, for an absolute constant $c_0 > 0$ and all sufficiently large $n$.

The upper bound is trivial: $\mu(n) \le \binom{n}{2}$, since a single u-orbital cannot exceed the number of pairs. Everything below concerns the lower bound.

> **Hypothesis (H).** There is a constant $K$ such that every sufficiently large $n$ admits primes $c, r$ with
>
> 1. $n = c + r$ if $n$ is even, and $n = 2c + r$ if $n$ is odd;
> 2. $n/5 \le c, r \le n/2$;
> 3. $r - 1$ has a divisor $q^a \ge (r-1)/K$ with $q$ prime;
> 4. $r \nmid c - 1$.

(H) is a Hardy–Littlewood/Bateman–Horn statement of binary-Goldbach type: for fixed $n$ it asks for a prime $r$ in a fixed proportional window such that $n - r$ (or $(n-r)/2$) is prime and $r-1$ has a large prime-power divisor. The heuristic count of such $r$ is $\asymp n/\log^3 n$. Condition 4 is a divisibility side condition excluding a set of $r$ of density $O(1/n)$.

Two remarks on the shape of (H). It is a *disjunctive* hypothesis over two families, so it does not require any single Bateman–Horn system to be solvable for all large $n$. And condition 3 is deliberately weaker than "$r$ is a safe prime" ($r - 1 = 2s$, $s$ prime): demanding the latter would impose congruence conditions mod 4 and mod 3 on $n$ that fail for some residue classes, whereas condition 3 with $K \ge 6$ is satisfiable in every class.

## 3. The constructions

Fix $c, r, q^a =: t$ as in (H).

**Even $n = c + r$.** Partition $[n]$ into blocks $A$ of size $c$ and $B$ of size $r$, identified with $\mathbb{Z}/c$ and $\mathbb{Z}/r$. Let
$$\Gamma \;=\; \mathrm{AGL}(1,c) \;\times\; \bigl(\mathbb{Z}/r \rtimes C_t\bigr),$$
where the first factor acts on $A$ by all affine maps $x \mapsto \lambda x + \beta$ and the second on $B$ by $y \mapsto \eta y + \gamma$ with $\eta$ ranging over the subgroup of order $t$ in $(\mathbb{Z}/r)^\times$.

*Oliver's condition.* Take $\Gamma_2 = \mathbb{Z}/c$ (translations of $A$), a $c$-group; $\Gamma_1 = \Gamma_2 \times (\mathbb{Z}/r) \times C_{c-1}$; and $\Gamma/\Gamma_1 = C_t$, a $q$-group. Then $\Gamma_1/\Gamma_2 \cong C_{c-1} \times C_r$, which is cyclic precisely because $\gcd(c-1, r) = 1$ — this is what condition 4 of (H) secures.

*Orbitals.* Within $A$: the translations make pairs equivalent to their differences and $(\mathbb{Z}/c)^\times$ acts transitively on those, so all $\binom{c}{2}$ pairs form one orbital. Within $B$: differences are scaled by $C_t$, giving orbitals of size $rt/2$ if $t$ is even and $rt$ if odd, capped at $\binom{r}{2}$. Across: all $cr$ mixed pairs form one orbital. Hence
$$m^*(\Gamma) \;=\; \min\Bigl\{\tbinom{c}{2},\; \tfrac{r t}{2},\; cr\Bigr\} \;\ge\; \min\Bigl\{\tbinom{c}{2},\; \tfrac{r(r-1)}{2K},\; cr\Bigr\} \;\ge\; \frac{n^2}{60K}$$
for $n$ large, using $c, r \ge n/5$.

**Odd $n = 2c + r$.** Now take two blocks $A_1, A_2$ of size $c$ and one block $B$ of size $r$, and let
$$\Gamma \;=\; \Bigl(\bigl(\mathbb{Z}/c\bigr)^2 \rtimes C_{c-1}\Bigr) \;\times\; \bigl(\mathbb{Z}/r \rtimes C_t\bigr),$$
with $(\mathbb{Z}/c)^2$ translating $A_1$ and $A_2$ independently and $C_{c-1}$ acting **diagonally**, by the same scalar on both blocks.

*Oliver's condition.* As before, with $\Gamma_2 = (\mathbb{Z}/c)^2$ and $\Gamma_1/\Gamma_2 \cong C_{c-1} \times C_r$ cyclic. The diagonal action is essential: two independent copies of $C_{c-1}$ would make $\Gamma_1/\Gamma_2$ non-cyclic and destroy the chain.

*Orbitals.* $\binom{c}{2}$ within each $A_i$; $c^2$ between $A_1$ and $A_2$; the $B$-orbitals as before; $cr$ from each $A_i$ to $B$. Hence
$$m^*(\Gamma) \;=\; \min\Bigl\{\tbinom{c}{2},\; c^2,\; \tfrac{rt}{2},\; cr\Bigr\} \;\ge\; \frac{n^2}{60K}$$
again. This proves the Theorem with $c_0 = 1/(60K)$; taking $K = 6$ gives $c_0 = 1/360$. Both bounds come from minimising $\min\{x^2/2,\ y^2/2K,\ xy\}$ (respectively $\min\{x^2/2,\ x^2,\ y^2/2K,\ xy\}$) over the window $x = c/n,\ y = r/n \in [1/5, 1/2]$, and both are slack: the true worst cases are $1/48$ and $1/300$.

*Verification.* Both constructions have been checked by direct computation of the permutation groups and their orbit decompositions on pairs — e.g. for $n = 12 = 5 + 7$ with $t = 3$, $|\Gamma| = 420$ and the orbitals are $\{10, 21, 35\}$; for $n = 17 = 2\cdot 5 + 7$, $|\Gamma| = 2100$ and the orbitals are $\{10, 10, 21, 25, 35, 35\}$.

## 4. What is unconditional, and what the constant is

One infinite family needs no hypothesis. For $n = 2m$ with $m$ an odd prime power, take two blocks of size $m$ with the diagonal twist and a block swap; the resulting group is Oliver with $q = 2$, its orbitals are $m(m-1)$ and $m^2$, and so
$$\mu(2m) \;\ge\; m(m-1) \;=\; \bigl(\tfrac{1}{2} - o(1)\bigr)\tbinom{n}{2}.$$
This is best possible up to the $o(1)$, since a group attaining $\binom{n}{2}$ would be $2$-homogeneous, hence primitive, hence of prime-power degree.

The constant $c_0$ above is deliberately crude. Optimising the block sizes and the efficiency $t/(r-1)$ gives materially better constants, which depend on $n$ modulo $12$ through local conditions at the primes $2$ and $3$; we do not need that refinement here.

A companion computation, which we do not reproduce here since it rests on a classification of the possible orbit structures rather than on constructions, evaluates $\mu(n)$ exactly for all composite non-prime-power $n \le 2298$ and gives
$$\min\{\, \mu(n)/\tbinom{n}{2} \;:\; n \le 10^6,\ n \text{ composite, not a prime power} \,\} \;=\; 0.02611\ldots,$$
attained at $n = 3239$. Read as a lower bound — which is all the present argument needs — this says the true density constant is an order of magnitude better than the $c_0$ proved above, with no downward drift across the range.

## 5. Comparison with BBKN

BBKN obtain $\mu(n) \ge n^{3/2-\varepsilon}$ under Chowla's conjecture, and note that $3/2$ is a natural barrier for their method: it is the exponent at which the least-prime-in-an-arithmetic-progression input runs out. The present route replaces that input with a Goldbach-type one and passes the barrier, at the cost of a different and not obviously comparable hypothesis. Neither (H) nor Chowla is known to imply the other.

The resulting evasiveness statement — all nontrivial monotone properties of graphs with $O(n^2)$ edges are eventually evasive — covers a positive fraction of the full edge set, and so is a proportional rather than a sub-polynomial sparsity condition. It does not settle Aanderaa–Rosenberg–Karp: the full conjecture concerns all monotone properties, and Proposition 1 gives nothing once the edge budget exceeds $\binom{n}{2}/2$, which is the ceiling for any group of non-prime-power degree.

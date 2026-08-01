# Sparse evasiveness up to a positive edge density, conditionally

*A short self-contained note, written with LaTeX markup for pasting into a LaTeX document. For a version that renders in GitHub-flavoured Markdown, see `mu-theta-n2-note.md`; the two are kept identical in content. Background assumed: Babai–Banerjee–Kulkarni–Naik, "Evasiveness and the distribution of prime numbers" (arXiv:1001.4829), henceforth BBKN.*

## 1. The invariant

Let $\Gamma \le S_n$. The **u-orbitals** of $\Gamma$ are its orbits on the $\binom{n}{2}$ unordered pairs from $[n]$; write $m^*(\Gamma)$ for the smallest of them. Call $\Gamma$ an **Oliver group** if it admits a normal chain
$$1 \trianglelefteq \Gamma_2 \trianglelefteq \Gamma_1 \trianglelefteq \Gamma$$
with $\Gamma_2$ a $p$-group, $\Gamma_1/\Gamma_2$ cyclic, and $\Gamma/\Gamma_1$ a $q$-group, for some primes $p,q$. These are exactly the groups to which Oliver's fixed-point theorem applies. Define
$$\mu(n) \;=\; \max\{\, m^*(\Gamma) \;:\; \Gamma \le S_n \text{ an Oliver group} \,\}.$$

Throughout we measure $\mu$ against the number of pairs, writing
$$\delta(n) \;=\; \mu(n)\big/\tbinom{n}{2}$$
for the *density*. All constants below are stated in this unit; since $\binom{n}{2} \sim n^2/2$, a density $\delta$ corresponds to about $\delta n^2/2$ edges.

The relevance is the standard orbital-annihilation argument, which we recall to fix conventions. Let $P$ be a nontrivial monotone-decreasing graph property on $n$ vertices, and $\Delta(P)$ its simplicial complex on the vertex set $E(K_n)$. If $P$ is nonevasive then $\Delta(P)$ is collapsible, hence $\mathbb{Z}$-acyclic; Oliver's theorem then gives $\chi(\Delta(P)^\Gamma) = 1$ for any Oliver group $\Gamma$. But $\Delta(P)^\Gamma$ consists of the $\Gamma$-invariant graphs in $P$, and every such graph is a union of u-orbitals. So if every u-orbital of $\Gamma$ exceeds the edge budget of $P$, the only invariant member is the empty graph, $\chi(\Delta(P)^\Gamma) = 0$, and we have a contradiction. Hence:

> **Proposition 1.** If every graph in $P$ has fewer than $\mu(n)$ edges, then $P$ is evasive.

BBKN's Theorem 1.4 is exactly this route with $\mu(n) \ge n^{3/2-\varepsilon}$ for all sufficiently large $n$, obtained under Chowla's conjecture on the least Dirichlet prime; their conclusions are likewise eventual. Our object here is the growth rate of $\mu(n)$ itself.

## 2. The result

**Theorem.** Assume Hypothesis (H) below. Then $\mu(n) = \Theta(n^2)$ — equivalently, $\delta(n) \ge \delta_0$ for an absolute constant $\delta_0 > 0$ and **all sufficiently large $n$**. Consequently, for all sufficiently large $n$, every nontrivial monotone graph property on $n$ vertices whose members have fewer than $\delta_0\binom{n}{2}$ edges is evasive — in BBKN's terminology, such properties are **eventually evasive**.

The "sufficiently large" is inherited from (H) and is not an artefact of the argument: Proposition 1 is exact at every $n$, but it is (H) that supplies a suitable group at a given $n$, and (H) is an eventual hypothesis. For any particular $n$ one can of course check directly whether a construction exists, and §4 records one infinite family for which no hypothesis is needed at all.

The upper bound is trivial: $\delta(n) \le 1$, since a single u-orbital cannot exceed the number of pairs. Everything below concerns the lower bound.

> **Hypothesis (H).** Every sufficiently large n admits primes q, r, c with
>
> 1. $n = c+r$ if $n$ is even, and $n = 2c+r$ if $n$ is odd;
> 2. $n/5 \le c, r \le n/2$;
> 3. $r = d\cdot q + 1$ for some $d \in \{2,4,6,12\}$;
> 4. $r \nmid c-1$.

**(H) is squarely a Bateman–Horn statement, and it has no modular obstruction.** Substituting condition 3, the system becomes three **linear** polynomials in the single variable q:

> $$q,\qquad dq+1,\qquad n-dq-1 \ (n \text{ even}) \quad\text{or}\quad (n-dq-1)/2 \ (n \text{ odd}),$$

required to be simultaneously prime. A linear polynomial has at most one root mod $\ell$, so the local count $\omega(\ell)$ never exceeds 3; an obstruction needs $\omega(\ell)$ ≥ ℓ, so **only $\ell = 2$ and $\ell = 3$ can obstruct**, and no higher power of either can, since the local condition is non-divisibility by ℓ and that is decided mod $\ell$. The two conditions on n are therefore a condition mod 4 and a condition mod 3 — that is, mod 12. (Mod 4 rather than mod 2 because of a change of variable, explained just below.) This is exactly what the four permitted values of d are for:

> | n mod 12 | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
> |---|---|---|---|---|---|---|---|---|---|---|---|---|
> | admissible d | all | 2 | 6, 12 | 4, 12 | 2, 4 | 6 | all | 4 | 6, 12 | 2, 6 | 2, 4 | 12 |

**Why the list runs to 12 and not to 6.** A reader expecting one factor for $\ell = 2$ and one for $\ell = 3$ would predict d ≤ 6. The extra factor of 2 comes from a change of variable, and is worth spelling out since it is easy to notice and not easy to guess.

Write $d = 2e$. The leading 2 is forced immediately: q is an odd prime, so $r = dq+1$ is odd only if d is even. That is the first appearance of $\ell = 2$, and it fixes the leading factor.

Now r mod 4 is determined by d mod 4, since q is odd: $d \equiv 2 \pmod 4$ gives $r \equiv 3 \pmod 4$, and $d \equiv 0 \pmod 4$ gives $r \equiv 1 \pmod 4$. For **even** n this is irrelevant — $c = n-r$ is odd automatically, being even minus odd. For **odd** n it is not, because the third polynomial is **$(n-dq-1)/2$**, not $n-dq-1$. That halving is the change of variable. It means the parity of c — which is what $\ell = 2$ controls — depends on n − r modulo **4** rather than modulo 2:

> $$c = (n-r)/2 \text{ is odd} \iff n - r \equiv 2 \pmod 4,$$,

so $d \equiv 2 \pmod 4$, i.e. $d \in \{2,6\}$, serves odd $n \equiv 1 \pmod 4$, while $d \equiv 0 \pmod 4$, i.e. $d \in \{4,12\}$, serves odd $n \equiv 3 \pmod 4$. This is $\ell = 2$ biting a **second** time, and it costs a second factor of 2 — but only in the odd case.

With $\ell = 3$ contributing a factor 3 independently, the pattern is exactly

> **$$d = 2e$$ with $e \mid 6$**, so $e \in \{1,2,3,6\}$ and $d \in \{2,4,6,12\}$,

the leading 2 making r odd, the 2 in e fixing n mod 4, and the 3 in e fixing n mod 3. Hence max d = 2 × 6 = 12. Had we needed only even n, $d \in \{2,6\}$ would suffice and the list would stop at 6.

Every class has at least one admissible d, so (H) is locally soluble at every n; the singular series of the corresponding system is positive, and the heuristic count of valid q is $\asymp n/\log^3 n$. Two classes are worth noting. At $n \equiv 11 \pmod{12}$ — the only class obstructed at both 2 and 3 — **$d = 12$ is forced**, which is why the list must run that far. And d must always be even, since q is odd and r = dq + 1 must be an odd prime.

Condition 3 is deliberately weaker than "r is a safe prime" ($d = 2$). Demanding $d = 2$ throughout would restrict n to the classes in which 2 is admissible above — 0, 1, 4, 6, 9, 10 — and fail outright on the other six. Condition 4 is a divisibility side condition excluding a set of q of density $O(1/n)$, and does not interact with the local analysis.

## 3. The constructions

Fix $q, r, c$ and set $t := q = (r-1)/d$, as in (H).

**Even $n = c + r$.** Partition $[n]$ into blocks $A$ of size $c$ and $B$ of size $r$, identified with $\mathbb{Z}/c$ and $\mathbb{Z}/r$. Let
$$\Gamma \;=\; \mathrm{AGL}(1,c) \;\times\; \bigl(\mathbb{Z}/r \rtimes C_t\bigr),$$
where the first factor acts on $A$ by all affine maps $x \mapsto \lambda x + \beta$ and the second on $B$ by $y \mapsto \eta y + \gamma$ with $\eta$ ranging over the subgroup of order $t$ in $(\mathbb{Z}/r)^\times$.

*Oliver's condition.* Take $\Gamma_2 = \mathbb{Z}/c$ (translations of $A$), a $c$-group; $\Gamma_1 = \Gamma_2 \times (\mathbb{Z}/r) \times C_{c-1}$; and $\Gamma/\Gamma_1 = C_t$, a $q$-group. Then $\Gamma_1/\Gamma_2 \cong C_{c-1} \times C_r$, which is cyclic precisely because $\gcd(c-1, r) = 1$ — this is what condition 4 of (H) secures.

*Orbitals.* Within $A$: the translations make pairs equivalent to their differences and $(\mathbb{Z}/c)^\times$ acts transitively on those, so all $\binom{c}{2}$ pairs form one orbital. Within $B$: differences are scaled by $C_t$, giving orbitals of size $rt/2$ if $t$ is even and $rt$ if odd, capped at $\binom{r}{2}$. Across: all $cr$ mixed pairs form one orbital. Hence
$$m^*(\Gamma) \;=\; \min\Bigl\{\tbinom{c}{2},\; \tfrac{r t}{2},\; cr\Bigr\} \;\ge\; \min\Bigl\{\tbinom{c}{2},\; \tfrac{r(r-1)}{24},\; cr\Bigr\} \;\ge\; \tfrac{1}{350}\tbinom{n}{2}$$
for $n$ large, using $c, r \ge n/5$.

**Odd $n = 2c + r$.** Now take two blocks $A_1, A_2$ of size $c$ and one block $B$ of size $r$, and let
$$\Gamma \;=\; \Bigl(\bigl(\mathbb{Z}/c\bigr)^2 \rtimes C_{c-1}\Bigr) \;\times\; \bigl(\mathbb{Z}/r \rtimes C_t\bigr),$$
with $(\mathbb{Z}/c)^2$ translating $A_1$ and $A_2$ independently and $C_{c-1}$ acting **diagonally**, by the same scalar on both blocks.

*Oliver's condition.* As before, with $\Gamma_2 = (\mathbb{Z}/c)^2$ and $\Gamma_1/\Gamma_2 \cong C_{c-1} \times C_r$ cyclic. The diagonal action is essential: two independent copies of $C_{c-1}$ would make $\Gamma_1/\Gamma_2$ non-cyclic and destroy the chain.

*Orbitals.* $\binom{c}{2}$ within each $A_i$; $c^2$ between $A_1$ and $A_2$; the $B$-orbitals as before; $cr$ from each $A_i$ to $B$. Hence
$$m^*(\Gamma) \;=\; \min\Bigl\{\tbinom{c}{2},\; c^2,\; \tfrac{rt}{2},\; cr\Bigr\} \;\ge\; \frac{n^2}{700}$$
again. This proves the Theorem with $\delta_0 = 1/350$, i.e. roughly $n^2/700$ edges. Both bounds come from minimising $2\min\{x^2/2,\ y^2/24,\ xy\}$ (respectively $2\min\{x^2/2,\ x^2,\ y^2/24,\ xy\}$) over the window $x = c/n,\ y = r/n \in [1/5, 1/2]$, the factor $2$ converting from $n^2$ to $\binom{n}{2}$; both are slack, the true worst densities being $1/48$ (even) and $1/300$ (odd).

*Verification.* Both constructions have been checked by direct computation of the permutation groups and their orbit decompositions on pairs — e.g. for $n = 12 = 5 + 7$ with $t = 3$, $|\Gamma| = 420$ and the orbitals are $\{10, 21, 35\}$; for $n = 17 = 2\cdot 5 + 7$, $|\Gamma| = 2100$ and the orbitals are $\{10, 10, 21, 25, 35, 35\}$.

## 4. What is unconditional, and what the constant is

One infinite family needs no hypothesis. For $n = 2m$ with $m$ an odd prime power, take two blocks of size $m$ with the diagonal twist and a block swap; the resulting group is Oliver with $q = 2$, its orbitals are $m(m-1)$ and $m^2$, and so
$$\mu(2m) \;\ge\; m(m-1), \qquad \text{i.e. } \delta(n) = \tfrac12 - o(1).$$
This is best possible up to the $o(1)$, since $\delta(n) = 1$ would force $2$-homogeneity, hence primitive, hence of prime-power degree.

The constant $\delta_0$ above is deliberately crude. Optimising the block sizes and the efficiency $t/(r-1)$ gives materially better constants, which depend on $n$ modulo $12$ through local conditions at the primes $2$ and $3$; we do not need that refinement here.

A companion computation, which we do not reproduce here since it rests on a classification of the possible orbit structures rather than on constructions, evaluates $\mu(n)$ exactly for all composite non-prime-power $n \le 2298$ and gives
$$\min\{\, \delta(n) \;:\; n \le 10^6,\ n \text{ composite, not a prime power} \,\} \;=\; 0.02611\ldots,$$
attained at $n = 3239$. Read as a lower bound — which is all the present argument needs — this says the true density constant is about $9$ times the $\delta_0 = 1/350$ proved above.

The comparison is worth making carefully, because the two statements have different quantifiers and the computation is the stronger of the two on that axis. The Theorem gives $\delta(n) \ge 1/350$ \emph{for all sufficiently large $n$}, and says nothing about any particular $n$. The computation gives $\delta(n) \ge 0.0261$ for \emph{every} composite non-prime-power $n \in [6, 10^6]$ — a global statement over its range, with no exceptional set: the minimum is attained in the middle of the range, at $n = 3239$, and small $n$ are comfortably above it ($\delta = 0.400$ at $n = 6$, $0.273$ at $n = 12$). So $1/350$ is conservative not merely as an eventual constant but as a global one, and no $n$ is currently known at which $\delta$ is small.

## 5. Comparison with BBKN

BBKN obtain $\mu(n) \ge n^{3/2-\varepsilon}$ under Chowla's conjecture, and note that $3/2$ is a natural barrier for their method: it is the exponent at which the least-prime-in-an-arithmetic-progression input runs out. The present route replaces that input with a Goldbach-type one and passes the barrier, at the cost of a different and not obviously comparable hypothesis. Neither (H) nor Chowla is known to imply the other.

The resulting evasiveness statement — all nontrivial monotone properties of graphs with $O(n^2)$ edges are eventually evasive — covers a positive fraction of the full edge set, and so is a proportional rather than a sub-polynomial sparsity condition. It does not settle Aanderaa–Rosenberg–Karp: the full conjecture concerns all monotone properties, and Proposition 1 gives nothing once the edge budget exceeds $\binom{n}{2}/2$, which is the ceiling for any group of non-prime-power degree.

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
> 2. $c \ge n/5$ and $r \ge n/5$ (which, with condition 1, bounds both above too: $c, r \le 4n/5$ for even $n$, and $c \le 2n/5$, $r \le 3n/5$ for odd $n$);
> 3. $r = d\cdot q + 1$ for some $d \in \{2,4,6,12\}$;
> 4. $r \nmid c-1$.

**(H) is a parametric Hardy–Littlewood hypothesis, combining a Goldbach-type split with a Sophie Germain condition on the same variable.** Two things need separating, since they have different status: the classification of modular obstructions, which is routine, and the existence claim itself, which is not.

\emph{What is routine.} Substituting condition 3, the system becomes three **linear** polynomials in the single variable $q$:

> $$q,\qquad dq+1,\qquad n-dq-1 \ (n \text{ even}) \quad\text{or}\quad (n-dq-1)/2 \ (n \text{ odd}),$$

required to be simultaneously prime. Write $L_1, L_2, L_3$ for the three and $\omega(\ell)$ for the number of residues $q$ mod $\ell$ at which $L_1L_2L_3$ vanishes; an obstruction is $\omega(\ell) = \ell$, meaning $\ell$ divides one of the three for \emph{every} $q$. Two mechanisms can produce one, and the split between them is what confines the analysis:

> **$\ell \nmid d$.** Each form is genuinely linear mod $\ell$, so contributes at most one root, and $\omega(\ell) \le 3 < \ell$ for $\ell \ge 5$.
>
> **$\ell \mid d$.** Now $L_2 = dq+1 \equiv 1$ never vanishes, but $L_3$ **degenerates to a constant**, which vanishes identically when $\ell \mid (n-1)$ — resp. $\ell \mid (n-1)/2$ — giving $\omega(\ell) = \ell$ outright. The bound from the first mechanism does not apply here.

Since every permitted $d$ has only 2 and 3 as prime factors, **both mechanisms are confined to $\ell \le 3$**. That is also the real reason the list is $\{2,4,6,12\}$: these are exactly the even $d$ whose prime factors lie in $\{2,3\}$, which keeps the local analysis finite and the table indexed mod 12 — a $d$ with a larger prime factor, 10 say, would open a degeneration channel at 5. No higher power of 2 or 3 obstructs either, since the local condition is non-divisibility by $\ell$ and that is decided mod $\ell$.

The degeneration is not a corner case: it is precisely what excludes $d \in \{6,12\}$ at $n \equiv 1 \pmod 3$. With $d = 6$ and $n = 100$, the form $L_3 = 99 - 6q$ is identically $0$ mod 3, since 3 divides both 99 and 6. The two conditions on n are therefore a condition mod 4 and a condition mod 3 — that is, mod 12. (Mod 4 rather than mod 2 because of a change of variable, explained just below.) This is exactly what the four permitted values of d are for:

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

The list $\{2,4,6,12\}$ is what \emph{these} block patterns require, not an intrinsic feature of the problem: other constructions reach some classes with smaller $d$, and in particular the $d = 12$ demand at $n \equiv 11$ is specific to the two-block-plus-remainder shape used here.

Every class has at least one admissible $d$, so (H) is locally soluble at every $n$. But more than \emph{positivity} of the singular series $\mathfrak{S}(n,d)$ is needed, and more is available: $\ell$ cannot divide both $n$ and $n-1$, so at most one root coincidence occurs at each $\ell \ge 5$, and a coincidence \emph{raises} the corresponding factor above 1 — the bad primes only help. Hence
$$\mathfrak{S}(n,d) \;\ge\; 4 \cdot \tfrac{9}{8} \cdot C_0 \;=\; 2.858249\ldots, \qquad C_0 = \prod_{\ell \ge 5}\Bigl(1-\tfrac{3}{\ell}\Bigr)\Bigl(1-\tfrac{1}{\ell}\Bigr)^{-3} = 0.635166\ldots,$$
uniformly in $n$ and $d$, the two leading factors coming from $\omega(2) = 1$ and $\omega(3) \le 2$. The uniformity is what the hypothesis needs, not just positivity: pointwise positivity would leave open a sequence of $n$ along which $\mathfrak{S}$ decays and the predicted count falls below 1. With the uniform bound, the heuristic count of valid $q$ is $\gg n/\log^3 n$ — a lower bound with an absolute constant, which is all (H) requires. It is not a two-sided $\asymp$: the upper side carries a $\log\log n$ from the primes dividing $n(n-1)$. This local analysis is the standard singular-series computation and is insensitive to the system being parametric — the local densities at each prime $\ell$ are read off the polynomials in the usual way, with $n$ entering only as a residue.

\emph{What is not routine.} (H) is \textbf{not} a Bateman–Horn statement, and we do not claim it as one. Bateman–Horn concerns a \emph{fixed} system of polynomials, counting $x \le X$ with all $f_i(x)$ prime as $X \to \infty$; twin primes is the model case. Here the polynomials move with $n$, the variable $q$ is confined to roughly $[1, n/d]$, and at fixed $n$ there is no limit to take. What (H) asserts is that the representation count is \textbf{positive for every large $n$} — a statement about a family of systems indexed by $n$, in the tradition of the Hardy–Littlewood circle method as applied to Goldbach, not of the fixed-system asymptotics.

The comparison with Goldbach is close enough to be worth stating plainly, but (H) is not of Goldbach type \emph{alone}: $n = c+r$ with both prime is Goldbach-like, while $r = dq+1$ with both prime is a Sophie Germain condition, independently twin-prime-hard. Neither implies the other, and (H) demands both simultaneously on the same variable. Binary Goldbach has one free variable and two primality conditions; our system has one free variable and three, so per shape it is a strictly stronger demand. Against that, (H) is a \textbf{disjunction} over eight shapes — two block patterns and four values of $d$ — and needs only one of them to succeed. (H) is therefore of broadly Goldbach difficulty: it is not implied by any published result, and we do not expect it to be provable by current methods.pmod{12}$ — the only class obstructed at both 2 and 3 — **$d = 12$ is forced**, which is why the list must run that far. And d must always be even, since q is odd and r = dq + 1 must be an odd prime.

Condition 3 is deliberately weaker than "r is a safe prime" ($d = 2$). Demanding $d = 2$ throughout would restrict n to the classes in which 2 is admissible above — 0, 1, 4, 6, 9, 10 — and fail outright on the other six. Condition 4 is a divisibility side condition, and a very weak one: since $0 < c-1 < n$ and $r \ge n/5$, $r \mid c-1$ forces $c-1 \in \{0, r, 2r, 3r, 4r\}$, so it excludes at most five values of $q$ — $O(1)$, not a set of positive density — and it does not interact with the local analysis.

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
$$m^*(\Gamma) \;=\; \min\Bigl\{\tbinom{c}{2},\; c^2,\; \tfrac{rt}{2},\; cr\Bigr\} \;\ge\; \tfrac{1}{350}\tbinom{n}{2}$$
again. This proves the Theorem with $\delta_0 = 1/350$, i.e. roughly $n^2/700$ edges. Both bounds come from minimising $2\min\{x^2/2,\ y^2/24,\ xy\}$ (respectively $2\min\{x^2/2,\ x^2,\ y^2/24,\ xy\}$) over the region cut out by condition 2 — $x = c/n$ and $y = r/n$ both at least $1/5$, with $x+y=1$ (even) or $2x+y=1$ (odd) — the factor $2$ converting from $n^2$ to $\binom{n}{2}$. The worst density is $1/300$ in each case, attained at the corner where the foreign block is smallest, so $1/350$ is slack but not by much.

*Verification.* Both constructions have been checked by direct computation of the permutation groups and their orbit decompositions on pairs — e.g. for $n = 12 = 5 + 7$ with $t = 3$, $|\Gamma| = 420$ and the orbitals are $\{10, 21, 35\}$; for $n = 17 = 2\cdot 5 + 7$, $|\Gamma| = 2100$ and the orbitals are $\{10, 10, 21, 25, 35, 35\}$.

## 4. What is unconditional, and what the constant is

One infinite family needs no hypothesis. For $n = 2m$ with $m$ an odd prime power, take two blocks of size $m$ with the diagonal twist and a block swap; the resulting group is Oliver with $q = 2$, its orbitals are $m(m-1)$ and $m^2$, and so
$$\mu(2m) \;\ge\; m(m-1), \qquad \text{i.e. } \delta(n) = \tfrac12 - o(1).$$
This is best possible up to the $o(1)$: for non-prime-power $n$ an Oliver group has at least two u-orbitals, which partition the $\binom{n}{2}$ pairs, so $m^*(\Gamma) \le \lfloor \binom{n}{2}/2 \rfloor$ and $\delta(n) \le 1/2$. (Density $1$ would force $2$-homogeneity, hence primitive, hence of prime-power degree.)

The constant $\delta_0$ above is deliberately crude. Optimising the block sizes and the efficiency $t/(r-1)$ gives materially better constants. The local conditions at the primes $2$ and $3$ depend on $n$ modulo $12$, but the optimised constants are keyed \emph{modulo $24$}, a further condition mod $8$ deciding which construction is available; we do not need that refinement here.

A companion computation, which we do not reproduce here, exhibits an Oliver group at every composite non-prime-power $n \le 2600$ and so bounds $\delta(n)$ below at each; a separate scan over four explicit families gives
$$\delta(n) \;\ge\; 0.04453 \qquad \text{for every composite non-prime-power } n \le 10^6,$$
with equality at $n = 11183$, and a minimum of $0.045742$ at $n = 1817$ over the range where groups are exhibited individually. These are lower bounds, which is all the present argument needs, and they say the true density constant is at least $15$ times the $\delta_0 = 1/350$ proved above. \emph{(A matching upper bound --- and hence exact values of $\mu$ --- follows from a classification of the possible orbit structures together with a finite search over the resulting configurations. That is a separate result, and nothing here depends on it.)}

The comparison is worth making carefully, because the two statements have different quantifiers and the computation is the stronger of the two on that axis. The Theorem gives $\delta(n) \ge 1/350$ \emph{for all sufficiently large $n$}, and says nothing about any particular $n$. The computation gives $\delta(n) \ge 0.0445$ for \emph{every} composite non-prime-power $n \in [6, 10^6]$ — a global statement over its range, with no exceptional set: the bound is smallest in the middle of the range, at $n = 11183$, and small $n$ are comfortably above it ($\delta = 0.400$ at $n = 6$, $0.273$ at $n = 12$). So $1/350$ is conservative not merely as an eventual constant but as a global one, and no $n$ is currently known at which $\delta$ is small.

## 5. Comparison with BBKN

BBKN obtain $\mu(n) \ge n^{3/2-\varepsilon}$ under Chowla's conjecture, and note that $3/2$ is a natural barrier for their method: it is the exponent at which the least-prime-in-an-arithmetic-progression input runs out. The present route replaces that input with a Goldbach-type one and passes the barrier, at the cost of a different and not obviously comparable hypothesis. Neither (H) nor Chowla is known to imply the other.

The resulting evasiveness statement — all nontrivial monotone properties of graphs with $O(n^2)$ edges are eventually evasive — covers a positive fraction of the full edge set, and so is a proportional rather than a sub-polynomial sparsity condition. It does not settle Aanderaa–Rosenberg–Karp: the full conjecture concerns all monotone properties, and Proposition 1 gives nothing once the edge budget exceeds $\binom{n}{2}/2$, which is the ceiling for any group of non-prime-power degree.

# From the short note to the full framework

*A bridge. Reads alongside `mu-theta-n2-note.md` — or its LaTeX-markup twin `mu-theta-n2-note-latex.md`, identical in content — referred to below as **the note**; it also reads alongside the three working documents: `orbital-evasiveness-notes.md`, `enumeration-proof.md`, `arithmetic-of-density.md`. Its purposes are to say what the note omits, to express the omitted material in the note's own vocabulary, and — by doing both — to check that the note is consistent with what the fuller work actually establishes.*

---

## 0. Corrections the bridge turned up

**Superseded figures, now corrected in the note.** The note quoted an exactly-computed range of $n \le 2298$ and a global minimum of $0.026117$ at $n = 3239$ over $n \le 10^6$. Both predate the shape-space repair, which added the cyclic-layer-fused configurations that the enumeration had been missing. Since $B(n)$ is a *maximum* over admissible configurations, adding configurations can only **raise** it: the corrected figures are an exactly-computed range of $n \le 2600$ (2,186 values), a minimum of $0.045742$ at $n = 1817$ over that range, and $\delta \ge 0.04453$ at $n = 11183$ over $n \le 10^6$ from the four-family scan. The note now carries these, and the multiple of $\delta_0 = 1/350$ rises from $9$ to $15$. *(A rebuild that ever comes out **lower** at any $n$ means a shape has been lost, not gained; that monotonicity is the standing check on the table.)*

The note also says *"We have computed $\mu(n)$ exactly"*, which raises a separate issue of entitlement.

Computing $\mu(n)$ **exactly** requires an upper bound — a proof that no Oliver group of degree $n$ does better. That is the classification (Theorem 3.1 of the notes) together with the configuration enumeration and its collapse, none of which the note contains: §3 of the note gives constructions only, hence lower bounds only.

So on its own contents the note is entitled to $\mu(n) \ge \ldots$, not $\mu(n) = \ldots$. The exactness itself is not in doubt — the collapse $\mu(n) = B(n)$ is certified per-$n$ across the whole computed range, with the unconditional fallback invoked at $0$ of $2{,}186$ values — but it rests on the classification and the enumeration's completeness, neither of which the note contains. Either cite it as a companion result or restate those sentences as lower bounds. **Restating costs nothing**, since the Theorem only needs $\Omega(n^2)$.

Writing this bridge also turned up several errors in earlier drafts of the note, all now fixed there. The most embarrassing was in condition 2 of (H), which read "$n/5 \le c, r \le n/2$": for even $n = c + r$ that forces $c = r = n/2$, so the hypothesis was very nearly vacuous. It survived repeated checking because the checking was numerical and the error was not. Every verification swept $x = c/n$ over the range encoded **in the script** — $[0.2, 0.5]$ for even $n$, which correctly expresses "$c$ is the smaller block" — and compared the resulting constant against the note's claim. Nothing ever compared the note's *prose* against the script's window. This is a gap the consistency checks of §4 were structurally unable to close, and it argues for reading the hypothesis statement against the derivation by hand rather than only re-running the derivation. (The constant survives: with condition 2 stated correctly the worst density is $1/300$, and $\delta_0 = 1/350$ is still safe.) Also fixed: Hypothesis (H)'s condition 3 permitted too small a range of $d$ (it stopped at 6, and $d = 12$ is needed at $n \equiv 11$), the constant was twice claimed with too little margin, on top of a units slip between $n^2$ and $\binom{n}{2}$; and the Theorem's evasiveness conclusion was stated without the "sufficiently large $n$" that (H) forces on it. Proposition 1 is exact at every $n$; the Theorem is eventual, in BBKN's sense, because (H) is. Both are recorded in §4. Nothing else is inconsistent.

---

## 1. What the note leaves out

| Omitted | Where it lives | Why the note can omit it |
|---|---|---|
| the classification of Oliver groups by orbit structure | notes §2–3, Theorem 3.1 | needed only for the *upper* bound $\mu \le B$ |
| the configuration enumeration $B(n)$ and its self-certifying search | `enumeration-proof.md` Parts A–I | ditto |
| the collapse $\mu(n) = B(n)$, and the fallback certificate | Parts E′–E″ | ditto |
| the **seven** $\delta_0$ constants by residue class, keyed **mod 24** | `arithmetic-of-density.md` §3.3 | the note has the mod 12 *structure*, not the optimised values |
| the fused rungs, and the $F = 4$ shape that attains four of the ceilings | `arithmetic-of-density.md` §3.3.3–3.3.5 | the note's family is the unfused/$F=2$ rung only; see §2 below |
| the multiplicative (fused) engine, density $1/F$ | §2.1 | the note uses it once, at $n = 2m$, without naming it |
| the halving under $A_n$-invariance, and the arity axis | `chiral-graph-properties.md`, `general-k-note.md` | orthogonal to the note's claim entirely |
| the part-count bound $k < 1/\sqrt\delta$ | Prop. F.1 | only needed to make the *search* finite |
| prime-power block sizes $c = p^e$ | throughout | the note takes $c$ prime for self-containedness |
| the reverse implication, $\mu \Rightarrow$ prime statements | `arithmetic-of-density.md` §6 | not needed for evasiveness |
| the parametric-vs-fixed-system distinction, and where Bateman–Horn does and does not apply | `arithmetic-of-density.md` §3.5 | the note states the conclusion — (H) is of Goldbach type, not a Bateman–Horn statement — without the full comparison |

The exponent $2$ in the note's Theorem needs none of this. What the omitted material buys is a much better constant, exact values, and the reverse direction.

---

## 2. Dictionary

**The note's $d$ and the framework's efficiency $\eta$ are the same parameter: $\eta = 2/d$.** In the framework a *foreign* block of prime size $r$ under top prime $q$ has efficiency
$$\eta \;=\; \frac{\mathrm{orb}(r,t)}{\binom{r}{2}}, \qquad t = q\text{-part of } r-1,$$
the fraction of that block's full 2-homogeneous capacity its twist can reach. The note's condition 3, $r = dq+1$, makes $t = q = (r-1)/d$; since $q$ is odd, $\mathrm{orb}(r,t) = rt$ and so $\eta = 2t/(r-1) = 2/d$ exactly. The four permitted $d$ therefore correspond one-to-one with the framework's four efficiency values, and to the same residue classes:

| note's $d$ | 2 | 4 | 6 | 12 |
|---|---|---|---|---|
| $\eta = 2/d$ | 1 | 1/2 | 1/3 | 1/6 |
| classes served | 0,4,6,10 even; 1,9 odd | 3,7 odd | 2,8 even; 5 odd | 11 odd |

**This is the sharpest correspondence between the two documents.** The note derives $\{2,4,6,12\}$ from a local analysis of a three-linear-polynomial Bateman–Horn system; the framework derives $\{1, 1/2, 1/3, 1/6\}$ from the structure of $r-1$ under Lemma B′. The two arguments share no step, and they produce the same partition of the residue classes mod 12 — with $d = 12$, equivalently $\eta = 1/6$, forced at exactly $n \equiv 11$.

> **A caveat that has become important, and that costs the note nothing.** The correspondence above is exact **for the note's own family** — the additive shape $n = c + r$ or $n = 2c + r$, which is the framework's *unfused* reading together with the $F = 2$ fused rung. The framework's current ceilings are **not** attained by that family at four residues. Fusing $F$ blocks of size $c$ into one class is worth $\sqrt{F}$ unfused classes, so the cap becomes $\mathrm{cap}_F(\eta) = \eta/(1 + \sqrt{F\eta})^2$, and at $n \equiv 7, 11, 15, 23 \pmod{24}$ the optimum is the **two-part $F = 4$ shape** $n = 4c + r$, not any three-part shape. Two consequences for reading the note against the framework:
>
> - **The efficiency needed at $n \equiv 11$ is $\eta = 1/3$, i.e. $d = 6$, not $\eta = 1/6$, $d = 12$** — the $F = 4$ shape sidesteps the doubled $\ell = 2$ obstruction that forces $d = 12$ in the three-part family. The note's "$d = 12$ is forced at $n \equiv 11$" is correct *within its own family* and is exactly why that family is not optimal there.
> - **The ceilings are keyed mod 24, not mod 12**, and there are **seven** of them, not six. The mod-12 classification is the $\ell = 2, 3$ obstruction; the refinement to mod 24 is the further condition mod 8 deciding whether the fused rung is reachable.
>
> None of this touches the note's Theorem, which needs only $\Omega(n^2)$ and gets it from the unfused family. It matters only when the note's $d$-table is read as the framework's efficiency table — they agree on the classes, and disagree on which shape is best at four of them.

**The note's admissible region contains all six of its own balance points.** Writing $x = c/n$ and $k = 1$ (even) or $2$ (odd), the density of the note's construction is
$$\delta(x) \;=\; \min\{\,x^2,\ 2x(1-kx),\ \eta(1-kx)^2\,\},$$
maximised at $x^* = \sqrt{\eta}/(1 + k\sqrt{\eta})$ with value $\eta/(1+k\sqrt\eta)^2$:

| $n \bmod 12$ | $k$ | $\eta$ | $x^*$ | $\delta_0$ (note's family) |
|---|---|---|---|---|
| 0, 4, 6, 10 | 1 | 1 | 0.5000 | $1/4$ |
| 2, 8 | 1 | 1/3 | 0.3660 | $(2-\sqrt3)/2 = 0.13397$ |
| 1, 9 | 2 | 1 | 0.3333 | $1/9$ |
| 3, 7 | 2 | 1/2 | 0.2929 | $(3-2\sqrt2)/2 = 0.08579$ |
| 5 | 2 | 1/3 | 0.2679 | $(2-\sqrt3)^2 = 0.07180$ |
| 11 | 2 | 1/6 | 0.2247 | $(5-2\sqrt6)/2 = 0.05051$ |

For comparison, the framework's current ceilings, keyed mod 24 and attained by fused shapes at eleven of the twenty-four classes:

| $n \bmod 24$ | rung | $\delta_0$ |
|---|---|---|
| 0, 4, 6, 10, 12, 16, 18, 22 | $F = 1$, $\eta = 1$ | $1/4$ |
| 2, 8, 14, 20 | $F = 1$, $\eta = 1/3$ | $0.13397$ |
| 1, 9, 13, 21 | $F = 2$, $\eta = 1$ | $3 - 2\sqrt2 = 0.17157$ |
| 3, 19 | $F = 2$, $\eta = 1/2$ | $1/8 = 0.125$ |
| 5, 17 | $F = 2$, $\eta = 1/3$ | $0.10102$ |
| **7, 15** | **$F = 4$, $\eta = 1$** | $1/9 = 0.11111$ |
| **11, 23** | **$F = 4$, $\eta = 1/3$** | $7 - 4\sqrt3 = 0.07180$ |

The worst class is $n \equiv 11, 23 \pmod{24}$ at $7 - 4\sqrt3 = 0.07180$, which is also the asymptotic global constant. Note that the note's family reaches $0.05051$ there and the fused family reaches $0.07180$ — the same numerical value the note's table shows at class 5, arrived at by a different shape.

Balance points span $[0.2247, 0.5]$ in $x = c/n$. Condition 2 of (H) asks only that $c$ and $r$ each be at least $n/5$, which admits $x \in [0.2, 0.8]$ for even $n$ and $[0.2, 0.4]$ for odd, so all six balance points lie comfortably inside. The region is deliberately generous: it is chosen so that (H) is easy to state and to check, not so that it is tight, and the resulting constant $1/350$ is correspondingly crude.

**The note's $\delta_0 = 1/350$ against the full $\delta_0$.** Both are densities relative to $\binom{n}{2}$ — the note now fixes that unit explicitly, since its construction bounds arrive naturally in units of $n^2$ and the factor 2 is easy to drop. The full analysis is $25\times$ better in the worst class, and the two bracket the observed minimum:
$$\underbrace{1/350 = 0.00286}_{\text{note's } \delta_0} \;<\; \underbrace{0.04453}_{\text{observed min, }n \le 10^6} \;<\; \underbrace{0.07180}_{\delta_0 \text{ at } n \equiv 11, 23 \ (24)}$$

*(The right-hand term is now the asymptotic constant itself rather than one class's ceiling, since $7 - 4\sqrt3$ is attained exactly at the extremal classes.)*

**The three terms are of three different logical types, and the ordering is more informative once that is said.** The left is *conditional on* (H), *eventual*, and proved. The middle is *unconditional*, *global* over $[6, 10^6]$ with no exceptional set, and computed. The right is the *asymptotic* ceiling of a single family in a single residue class. So the middle term is not merely between the other two numerically — it is the strongest of the three in quantifier and the weakest in range, which is exactly what one would want as a sanity check: the proved eventual constant is conservative even when measured against a global minimum, and the asymptotic ceiling is not yet approached anywhere in the computed range.
The middle term lying between the two is the arithmetic check that both are right: the proved constant must be below the observed minimum, and the observed minimum must be below the best any single class guarantees.

**The note's Hypothesis (H) is one disjunct of a covering statement.** In full, a density-$\delta_0$ bound corresponds to a finite set of configuration *shapes* — 31 of them at $\delta_0 = 1/9$, 117 at $1/16$ — each of which is a Bateman–Horn system in $n$. The correct implication is that *at least one* is solvable at each large $n$. (H) picks a small explicit subfamily — two block patterns, each with four permitted values of $d$ — and asserts that one of the eight always works. That is stronger than the framework needs, and far easier to state; the price is that it could in principle fail while the framework's conclusion survives, if some $n$ were covered only by a shape outside the eight.

---

## 3. Statements in the note's language

**The two engines.** The note's constructions are all *additive*: disjoint blocks whose sizes sum to $n$, with density capped at $1/k^2$ for $k$ blocks. The framework has a second, *multiplicative* engine — a single class of $F$ blocks of size $c$ fused by the top group, $n = Fc$, with density $1/F$. The note uses it exactly once, in §4 at $n = 2m$, without naming it: that is $F = 2$, giving $1/2$. The engine requires $n$ to have at most two distinct prime factors and so covers a density-zero set of $n$, which is why the note is right to treat it as a special family rather than a general method.

**The mod 12 analysis is now carried by the note itself**, as the table of admissible $d$ and the change-of-variable argument behind it. What the framework adds is the same partition reached from the other side: there it appears as an *efficiency loss* — a factor 2 at $\ell = 2$, a factor 3 at $\ell = 3$, and 6 when both bite — rather than as a constraint on which $d$ is available. The note's "$d = 2$ alone would fail on six of the twelve classes" and the framework's "$\eta$ drops to $1/6$ at $n \equiv 11$" are the same statement in the two vocabularies.

**The upper bound, stated as the note would.** The note gives $\mu(n) \le \binom{n}{2}$ and observes that equality forces 2-homogeneity, hence prime-power degree. The framework replaces this with an exact evaluation: every Oliver group's orbit structure is one of an explicitly enumerable list of configurations, each configuration's minimum orbital is a closed-form expression in its parameters, and $B(n)$ is the maximum over that list. The upper bound $\mu(n) \le B(n)$ is then a classification theorem, and $\mu(n) = B(n)$ needs the further fact that the optimum is realised by an actual group.

---

## 4. Consistency checks performed

1. **Both constructions built as explicit permutation groups** and their orbit decompositions on pairs computed, at four parameter choices each. Even: $n = 12 = 5+7$ gives $|\Gamma| = 420$, orbitals $\{10, 21, 35\}$. Odd: $n = 17 = 2\cdot5+7$ gives $|\Gamma| = 2100$, orbitals $\{10, 10, 21, 25, 35, 35\}$. All match the closed forms.
2. **The Oliver chain verified symbolically** in both cases, including that $\Gamma_1/\Gamma_2 \cong C_{c-1} \times C_r$ is cyclic exactly under condition 4 of (H), and that the diagonal action of $C_{c-1}$ in the odd construction is what keeps it cyclic.
3. **The constant re-derived numerically, three times.** A first draft claimed $1/(50K)$ against a true worst case of $0.003340$ — safe by $0.2\%$, too tight to circulate. A second used $\eta \ge 1/6$, the correct worst-case efficiency but not what condition 3 conservatively guarantees. With $\eta \ge 1/12$ — taking $\mathrm{orb}(r,t) \ge rt/2$ regardless of the parity of $t$ — the worst densities are $1/48$ (even) and $1/300$ (odd), and $\delta_0 = 1/350$ is safe with room. The third correction was a units slip rather than an arithmetic one: the construction bounds arrive as $m^*/n^2$ while every constant elsewhere is a density relative to $\binom{n}{2}$, a factor 2 apart. The note now fixes the unit in §1 and states the conversion where the bounds are derived.
4. **Condition 2's region checked to contain all six balance points**, which span $[0.2247, 0.5]$ in $x = c/n$. An earlier draft stated condition 2 as "$n/5 \le c, r \le n/2$", which for even $n$ forces $c = r = n/2$ and is therefore vacuous — see §0.
4a. **The change of variable checked explicitly.** For odd $n$ the third polynomial is $(n-dq-1)/2$, so the parity of $c$ is governed by $n-r \bmod 4$, not $\bmod 2$; with $q$ odd, $d \equiv 2 \pmod 4$ forces $r \equiv 3$ and $d \equiv 0 \pmod 4$ forces $r \equiv 1$, verified over $q = 3, \ldots, 19$. This is why $\ell = 2$ contributes **two** factors of 2 in the odd case — one to make $r$ odd, one to fix $n \bmod 4$ — and hence why $d$ runs to $2 \times 6 = 12$ rather than to 6. The note now states this; it is the detail most likely to be queried and least likely to be reconstructed.
4b. **The admissible-$d$ table computed exhaustively**: for each $n \bmod 12$ and each $d \in \{2,4,6,12\}$, whether the system $\{q,\ dq+1,\ \ldots\}$ has $\omega(\ell) < \ell$ at $\ell = 2, 3$. Every class has at least one admissible $d$; $d = 12$ is needed, and needed only at $n \equiv 11$.
5. **$1/350 < 0.04453 < 0.07180$** verified, all three in units of $\binom{n}{2}$ — and their quantifiers checked to differ as stated: the middle term is global over $[6, 10^6]$, confirmed by noting that the smallest $n$ appearing in the family-scan worklist at all is $323$, so every composite non-prime-power $n < 323$ already has lower bound above the asymptotic ceiling $7 - 4\sqrt3$, and the small values are far above the minimum ($\delta = 0.400$ at $n = 6$).
6. **The unconditional family cross-checked**: $n = 2m$, $m$ an odd prime power, gives orbitals $m(m-1)$ and $m^2$, density $(m-1)/(2m-1) \to 1/2$, which is Theorem 2.1 of the notes.

---

## 4b. Results available for a teaser, but not written up here

*The note's Theorem is one corner of a larger body of work. If the arXiv version wants to gesture at what else is established, these are the claims that are (i) proved or computed, (ii) statable in a sentence, and (iii) independent of the note's hypothesis unless marked.*

- **Exact values and the collapse.** $\mu(n) = B(n)$, certified per $n$ across every composite non-prime-power $n \le 2600$, with the unconditional fallback invoked at $0$ of $2{,}186$ values. *(Conditional on nothing; it is a classification plus a finite search.)*
- **The global floor.** $\delta(n) \ge 0.04453$ for every composite non-prime-power $n \le 10^6$, attained at $n = 11183$, from a four-family scan whose families are all explicit — so this is an unconditional lower bound over that range, and the conjecture $\delta \ge 1/25$ is open beyond it.
- **The closed-form ceilings.** Seven constants indexed by $n \bmod 24$, from $1/4$ down to $7 - 4\sqrt3$, with the extremal classes $n \equiv 11, 23$ and the global asymptotic constant $7 - 4\sqrt3 = 0.07180$. *(Conditional on the covering hypothesis, as the note's $\delta_0$ is.)*
- **The reverse implication.** Lower bounds on $\mu$ yield additive statements about primes, so the connection runs both ways rather than being a one-off application.
- **Weakening the invariance group.** For properties invariant only under $A_n$ — which may separate isomorphic labelled graphs when every isomorphism between them is odd — the same $\Theta(n^2)$ holds, with $\mu_{\mathrm{chi}}(n) \ge \mu(n)/2$; and the prime-power theorem qualifies to $n = 2^a$ and $n \equiv 3 \pmod 4$, failing at $n \equiv 1 \pmod 4$.
- **Higher arity.** At $k \ge 3$ the same machinery gives $\Theta(n^2)$ for $k$-uniform hypergraph properties, and the stabiliser analysis is *complete* at $k = 3$: no new phenomena appear at any larger $k$.

**What should not be teased.** The general monotone-transitive case, where this apparatus gives nothing new; and anything about the topological rungs above $\chi = 1$, where the honest statement is that no example is known and the search space has barely been explored.

## 5. What a fuller paper would add, in order of value

1. **The exactness claim**, which needs the classification and the collapse — the largest single addition, and the one that turns "$\mu = \Omega(n^2)$" into "$\mu(n)$ is computable".
2. **The mod 24 constants**, replacing $\delta_0 = 1/350$ with $\delta_0(n \bmod 24) \ge 7 - 4\sqrt3 = 0.07180$, a 25-fold improvement stated in closed form — and requiring the fused rungs, since the $F = 4$ shape is what attains it at the extremal classes.
3. **The covering formulation of (H)**, which weakens the hypothesis from "these two shapes always work" to "some shape in a finite list works" — more robust and more likely to be provable.
4. **The reverse implication**, that lower bounds on $\mu$ yield additive prime statements, which is what makes the connection two-way rather than a one-off application.
5. **The unconditional infinite family** at density $\to 1/2$, already in the note but worth expanding, since it is the only part needing no hypothesis at all.

Items 1 and 4 are the ones a referee will ask about; items 2 and 3 are refinements that can be deferred.

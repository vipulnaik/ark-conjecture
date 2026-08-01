# From the short note to the full framework

*A bridge. Reads alongside `mu-theta-n2-note.md` — or its LaTeX-markup twin `mu-theta-n2-note-latex.md`, identical in content — referred to below as **the note**; it also reads alongside the three working documents: `orbital-evasiveness-notes.md`, `enumeration-proof.md`, `arithmetic-of-density.md`. Its purposes are to say what the note omits, to express the omitted material in the note's own vocabulary, and — by doing both — to check that the note is consistent with what the fuller work actually establishes.*

---

## 0. One correction the bridge turned up

The note says *"We have computed $\mu(n)$ exactly for all composite non-prime-power $n \le 2298$"* and quotes $\min \mu(n)/\binom{n}{2} = 0.026117$ over $n \le 10^6$.

Computing $\mu(n)$ **exactly** requires an upper bound — a proof that no Oliver group of degree $n$ does better. That is the classification (Theorem 3.1 of the notes) together with the configuration enumeration and its collapse, none of which the note contains: §3 of the note gives constructions only, hence lower bounds only.

So on its own contents the note is entitled to $\mu(n) \ge \ldots$, not $\mu(n) = \ldots$. Either cite the classification as a companion result, or restate those two sentences as lower bounds. **Restating costs nothing**, since the Theorem only needs $\Omega(n^2)$ — the exactness is a separate and much larger claim that a short note cannot carry.

This is the only inconsistency found; everything below checks out.

---

## 1. What the note leaves out

| Omitted | Where it lives | Why the note can omit it |
|---|---|---|
| the classification of Oliver groups by orbit structure | notes §2–3, Theorem 3.1 | needed only for the *upper* bound $\mu \le B$ |
| the configuration enumeration $B(n)$ and its self-certifying search | `enumeration-proof.md` Parts A–I | ditto |
| the collapse $\mu(n) = B(n)$, and the fallback certificate | Parts E′–E″ | ditto |
| the residue analysis mod 12, six $\delta_0$ values | `arithmetic-of-density.md` §3.3 | improves the constant, not the exponent |
| the multiplicative (fused) engine, density $1/F$ | §2.1 | the note uses it once, at $n = 2m$, without naming it |
| the part-count bound $k < 1/\sqrt\delta$ | Prop. F.1 | only needed to make the *search* finite |
| prime-power block sizes $c = p^e$ | throughout | the note takes $c$ prime for self-containedness |
| the reverse implication, $\mu \Rightarrow$ prime statements | `arithmetic-of-density.md` §6 | not needed for evasiveness |

The exponent $2$ in the note's Theorem needs none of this. What the omitted material buys is a much better constant, exact values, and the reverse direction.

---

## 2. Dictionary

**The note's $d$ is the reciprocal of the efficiency $\eta$, up to a factor 2.** In the full framework, a *foreign* block of prime size $r$ under top prime $q$ has efficiency
$$\eta \;=\; \frac{\mathrm{orb}(r,t)}{\binom{r}{2}}, \qquad t = q\text{-part of } r-1,$$
the fraction of that block's full 2-homogeneous capacity its twist can reach. Condition 3 of Hypothesis (H) — that $r-1$ has a prime-power divisor $\ge (r-1)/K$ — is exactly $\eta \ge 1/K$. So:

> **$d = 12$ in the note $\iff$ $\eta = 1/6$, the worst case in the full analysis, which occurs exactly at $n \equiv 11 \pmod{12}$ — and the note's own table of admissible $d$ shows $d = 12$ forced at precisely that class.**

This is the sharpest correspondence between the two documents. The note derives its list $\{2,4,6,12\}$ from a local analysis of a three-linear-polynomial Bateman–Horn system; the framework derives its six $\eta$ values from the structure of $r-1$ under Lemma B′; the two land on the same partition of the residue classes mod 12.

**The note's window $[n/5,\, n/2]$ is the convex hull of the six balance points.** Writing $x = c/n$ and $k = 1$ (even) or $2$ (odd), the density of the note's construction is
$$\delta(x) \;=\; \min\{\,x^2,\ 2x(1-kx),\ \eta(1-kx)^2\,\},$$
maximised at $x^* = \sqrt{\eta}/(1 + k\sqrt{\eta})$ with value $\eta/(1+k\sqrt\eta)^2$:

| $n \bmod 12$ | $k$ | $\eta$ | $x^*$ | $\delta_0$ |
|---|---|---|---|---|
| 0, 4, 6, 10 | 1 | 1 | 0.5000 | $1/4$ |
| 2, 8 | 1 | 1/3 | 0.3660 | $(2-\sqrt3)/2 = 0.13397$ |
| 1, 9 | 2 | 1 | 0.3333 | $1/9$ |
| 3, 7 | 2 | 1/2 | 0.2929 | $(3-2\sqrt2)/2 = 0.08579$ |
| 5 | 2 | 1/3 | 0.2679 | $(2-\sqrt3)^2 = 0.07180$ |
| 11 | 2 | 1/6 | 0.2247 | $(5-2\sqrt6)/2 = 0.05051$ |

Balance points span $[0.2247, 0.5]$, so the note's $[0.2, 0.5]$ contains all six with room. **That is not a coincidence and is the cleanest consistency check available**: the note's window was chosen for convenience, and it turns out to be exactly what the optimised analysis needs.

**The note's $c_0 = 1/700$ against the full $\delta_0$.** The full analysis is $35\times$ better in the worst class, and the two bracket the observed minimum correctly:
$$\underbrace{1/700 = 0.00143}_{\text{note's } c_0} \;<\; \underbrace{0.026117}_{\text{observed min, } n \le 10^6} \;<\; \underbrace{0.05051}_{\delta_0 \text{ at } n \equiv 11}$$
The middle term lying between the two is the arithmetic check that both are right: the proved constant must be below the observed minimum, and the observed minimum must be below the best any single class guarantees.

**The note's Hypothesis (H) is one disjunct of a covering statement.** In full, a density-$\delta_0$ bound corresponds to a finite set of configuration *shapes* — 31 of them at $\delta_0 = 1/9$, 117 at $1/16$ — each of which is a Bateman–Horn system in $n$. The correct implication is that *at least one* is solvable at each large $n$. (H) picks two specific shapes and asserts one of them always works, which is stronger than the framework needs but far easier to state.

---

## 3. Statements in the note's language

**The two engines.** The note's constructions are all *additive*: disjoint blocks whose sizes sum to $n$, with density capped at $1/k^2$ for $k$ blocks. The framework has a second, *multiplicative* engine — a single class of $F$ blocks of size $c$ fused by the top group, $n = Fc$, with density $1/F$. The note uses it exactly once, in §4 at $n = 2m$, without naming it: that is $F = 2$, giving $1/2$. The engine requires $n$ to have at most two distinct prime factors and so covers a density-zero set of $n$, which is why the note is right to treat it as a special family rather than a general method.

**The mod 12 analysis is now carried by the note itself**, as the table of admissible $d$; the framework's derivation of the same partition runs differently and is worth comparing. Condition 3 of (H) cannot be strengthened to "$r$ is a safe prime" ($d = 2$ throughout): that would restrict $n$ to the six classes in which $d=2$ is admissible and fail outright on the rest. In the framework the same fact appears as an efficiency loss — a factor 2 at $\ell = 2$, a factor 3 at $\ell = 3$, and 6 when both bite, at $n \equiv 11 \pmod{12}$.

Two further facts the note could cite in one line each. Only $\ell = 2$ and $\ell = 3$ can obstruct, because each system is three *linear* polynomials so $\omega(\ell) \le 3 < \ell$ for $\ell \ge 5$; and no higher power of 2 or 3 obstructs, because the local condition is non-divisibility by $\ell$, which is decided mod $\ell$.

**The upper bound, stated as the note would.** The note gives $\mu(n) \le \binom{n}{2}$ and observes that equality forces 2-homogeneity, hence prime-power degree. The framework replaces this with an exact evaluation: every Oliver group's orbit structure is one of an explicitly enumerable list of configurations, each configuration's minimum orbital is a closed-form expression in its parameters, and $B(n)$ is the maximum over that list. The upper bound $\mu(n) \le B(n)$ is then a classification theorem, and $\mu(n) = B(n)$ needs the further fact that the optimum is realised by an actual group.

---

## 4. Consistency checks performed

1. **Both constructions built as explicit permutation groups** and their orbit decompositions on pairs computed, at four parameter choices each. Even: $n = 12 = 5+7$ gives $|\Gamma| = 420$, orbitals $\{10, 21, 35\}$. Odd: $n = 17 = 2\cdot5+7$ gives $|\Gamma| = 2100$, orbitals $\{10, 10, 21, 25, 35, 35\}$. All match the closed forms.
2. **The Oliver chain verified symbolically** in both cases, including that $\Gamma_1/\Gamma_2 \cong C_{c-1} \times C_r$ is cyclic exactly under condition 4 of (H), and that the diagonal action of $C_{c-1}$ in the odd construction is what keeps it cyclic.
3. **The constant $c_0$ re-derived numerically, twice.** A first draft claimed $1/(50K)$ against a true worst case of $0.003340$ — safe by $0.2\%$, too tight to circulate. A second used $\eta \ge 1/6$, the correct worst-case efficiency but not what condition 3 conservatively guarantees. With $\eta \ge 1/12$ — taking $\mathrm{orb}(r,t) \ge rt/2$ regardless of the parity of $t$ — the worst cases are $1/96$ (even) and $1/599$ (odd), and $c_0 = 1/700$ is safe with room.
4. **The window $[1/5, 1/2]$ checked to contain all six balance points**, $[0.2247, 0.5]$.
4a. **The admissible-$d$ table computed exhaustively**: for each $n \bmod 12$ and each $d \in \{2,4,6,12\}$, whether the system $\{q,\ dq+1,\ \ldots\}$ has $\omega(\ell) < \ell$ at $\ell = 2, 3$. Every class has at least one admissible $d$; $d = 12$ is needed, and needed only at $n \equiv 11$.
5. **$1/700 < 0.026117 < 0.05051$** verified, as above.
6. **The unconditional family cross-checked**: $n = 2m$, $m$ an odd prime power, gives orbitals $m(m-1)$ and $m^2$, density $(m-1)/(2m-1) \to 1/2$, which is Theorem 2.1 of the notes.

---

## 5. What a fuller paper would add, in order of value

1. **The exactness claim**, which needs the classification and the collapse — the largest single addition, and the one that turns "$\mu = \Omega(n^2)$" into "$\mu(n)$ is computable".
2. **The mod 12 constants**, replacing $c_0 = 1/700$ with $\delta_0(n \bmod 12) \ge 0.05051$, a 35-fold improvement stated in closed form.
3. **The covering formulation of (H)**, which weakens the hypothesis from "these two shapes always work" to "some shape in a finite list works" — more robust and more likely to be provable.
4. **The reverse implication**, that lower bounds on $\mu$ yield additive prime statements, which is what makes the connection two-way rather than a one-off application.
5. **The unconditional infinite family** at density $\to 1/2$, already in the note but worth expanding, since it is the only part needing no hypothesis at all.

Items 1 and 4 are the ones a referee will ask about; items 2 and 3 are refinements that can be deferred.

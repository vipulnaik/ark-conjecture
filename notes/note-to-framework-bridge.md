# From the short note to the full framework

*A bridge. Reads alongside `mu-theta-n2-note.md` — or its LaTeX-markup twin `mu-theta-n2-note-latex.md`, identical in content — referred to below as **the note**; it also reads alongside the three working documents: `orbital-evasiveness-notes.md`, `enumeration-proof.md`, `arithmetic-of-density.md`. Its purposes are to say what the note omits, to express the omitted material in the note's own vocabulary, and — by doing both — to check that the note is consistent with what the fuller work actually establishes.*

---

## 0. Hazards this bridge exists to catch

*The note and the framework can drift apart in two directions — the note can quote a framework figure that has moved, and the note can claim more than its own contents support. Both are live risks; this section records the standing hazards rather than the incidents, since the incidents are fixed and the hazards are not. Worth knowing that the two can fire together: a scoring correction can move the framework's figures **and** invalidate a claim the note was citing as established, in the same sitting.*

**Framework figures move in one direction, and the note must be re-read whenever they do.** B(n) is a *maximum* over admissible configurations, so enlarging the shape space can only **raise** it — a rebuild that comes out lower at any n means a shape has been lost, not gained, and that monotonicity is the standing check on the table. The consequence for the note is that any figure it imports (the exactly-computed range, the global minimum and its argmin, the multiple of δ₀) is a **snapshot**, and the direction of staleness is always the same: an imported figure is too *small*. Current values are in §2 below; the note carries them.

**The note may only claim what its own contents prove.** Computing μ(n) **exactly** needs an upper bound — a proof that no Oliver group of degree n does better — which is the classification (Theorem 3.1 of the notes) together with the configuration enumeration and its collapse. §3 of the note gives constructions, hence lower bounds. The exactness claim is currently **suspended on the runs, not on the structure**: the statements are in their corrected form, but the table rebuild is in progress and the collapse certificates await their reruns against it. The note accordingly states lower bounds only and describes the companion classification as separate work. **Stating lower bounds costs nothing**, since the Theorem needs only Ω(n²) — and lower bounds are the half that no scoring correction can disturb.

> **The failure mode that numerical checking cannot see, and the reason §4 is not enough on its own.** A hypothesis window written as both a lower and an upper bound on both blocks — "n/5 ≤ c, r ≤ n/2", say — silently pins c = r = n/2 at even n = c + r and makes the hypothesis very nearly vacuous, and the defect is invisible to every numerical check: a verification sweeps x = c/n over the range encoded *in the script* — [0.2, 0.5], say, which correctly expresses "c is the smaller block" — and compares the resulting constant against the note's claim, while nothing compares the note's *prose* against the script's window. No amount of re-running the derivation closes that gap; only reading the hypothesis statement against the derivation by hand does. **Any hypothesis in the note should be read this way before circulation**, and the check is cheap: substitute the stated constraints and see whether they leave a region.

> **Three further hazards of the same family.** A permitted parameter range set too small — a d-list stopped at 6 fails outright at n ≡ 11, where 12 is needed, and looks complete everywhere the checker happens to sample. A constant claimed with too little margin — a bound that clears the true worst case by 0.2% is technically safe and not fit to circulate, since any slack anywhere upstream flips it. And **a units slip**: the construction bounds arrive naturally as m*/n², while every constant elsewhere is a density relative to C(n,2), a factor 2 apart, and nothing stops one displayed bound taking one unit and the next the other, three lines apart. The note fixes its unit in §1 for that reason, and states the conversion where the bounds are derived. A units slip is invisible to every consistency check that works in one unit throughout; **the check that catches it is to read every displayed bound in the note and confirm each names the same unit**, which no numerical rerun will do for you.

## 1. What the note leaves out

| Omitted | Where it lives | Why the note can omit it |
|---|---|---|
| the classification of Oliver groups by orbit structure | notes §2–3, Theorem 3.1 | needed only for the *upper* bound $\mu \le B$ |
| the configuration enumeration $B(n)$ and its self-certifying search | `enumeration-proof.md` Parts A–I | ditto |
| the collapse $\mu(n) = B(n)$, and the fallback certificate | Parts E′–E″ | ditto |
| the $\delta_0$ constants by residue class — **six** distinct values, keyed **mod 12** | `arithmetic-of-density.md` §3.3 | the note has the mod-12 structure and the same modulus, but not the optimised values |
| the fused rungs, and the $F = 4$ shape that attains the ceiling at $n \equiv 11 \pmod{12}$ | `arithmetic-of-density.md` §3.3.3–3.3.5 | the note's shapes are the unfused ones (census S3 even, S4 odd), plus one top-layer $F = 2$ fusion in its §4; see §2 below |
| the multiplicative (fused) engine, density $1/F$ | §2.1 | the note uses it once, at $n = 2m$, without naming it |
| the halving under $A_n$-invariance, and the arity axis | `chiral-graph-properties.md`, `general-k-note.md` | orthogonal to the note's claim entirely |
| the part-count bound $k < 1/\sqrt\delta$ | Prop. F.1 | only needed to make the *search* finite |
| prime-power block sizes $c = p^e$ | throughout | the note takes $c$ prime for self-containedness |
| the reverse implication, $\mu \Rightarrow$ prime statements | `arithmetic-of-density.md` §6, §6.7 | not needed for evasiveness — see the note below on why the sharper form stays out |
| the full $\theta$-ladder of shifted-prime inputs, with quantifiers and attributions | `arithmetic-of-density.md` §3.6 | the note carries the three rungs that bear on it — Bombieri–Vinogradov, Baker–Harman, Chowla — and the framing of (BCG_{1/5}) as the $\theta = 1$ endpoint; what it omits is the Elliott–Halberstam rung, the two-column attribution split, and the primary-source caveats |
| the parametric-vs-fixed-system distinction, and where Bateman–Horn does and does not apply | `arithmetic-of-density.md` §3.5 | the note states the conclusion — (BCG_{1/5}) is of Goldbach type, not a Bateman–Horn statement — without the full comparison |

The exponent $2$ in the note's Theorem needs none of this. What the omitted material buys is a much better constant, exact values, and the reverse direction.

> **A deliberate omission, recorded so it reads as a decision rather than an oversight.** The framework now has a converse in a sharper form than the covering statement: a density floor *forces* a shifted prime with a prime-power divisor of bounded cofactor (`enumeration-proof.md` Prop. F.4, `arithmetic-of-density.md` §6.7). It is tempting to add to the note, because it would strengthen the paragraph on Elliott--Halberstam — it explains *structurally* why no $\theta < 1$ rung reaches the note's conclusion, rather than leaving that as an observation about exponents. **It stays out anyway**, for two reasons that are about the note's role rather than the mathematics. It has had one reading, and it depends on a step about which layer of the chain supplies a foreign block's twist — the framework's least reliable category of step, and one whose failure would make the Proposition *vacuous* rather than merely weaker (`pending-checks.md` T8). And the note's claim is an implication *in the other direction*; a converse is interesting context but is not load-bearing for anything the note asserts, so it would be new unreviewed material in the one document written to be read by strangers. **Revisit when T8 is discharged**: at that point the two-sentence version — a floor demands a linear-sized prime-power divisor, which is exactly what the ladder cannot supply — would earn its place in §5's comparison.

---

## 2. Dictionary

**The note's $d$ and the framework's efficiency $\eta$ are the same parameter: $\eta = 2/d$.** In the framework a *foreign* block of prime size $r$ under top prime $q$ has efficiency
$$\eta \;=\; \frac{\mathrm{orb}(r,t)}{\binom{r}{2}}, \qquad t = q\text{-part of } r-1,$$
the fraction of that block's full 2-homogeneous capacity its twist can reach. The note's condition 3, $r = dq+1$, makes $t = q = (r-1)/d$; since $q$ is odd, $\mathrm{orb}(r,t) = rt$ and so $\eta = 2t/(r-1) = 2/d$ exactly. The four permitted $d$ therefore correspond one-to-one with the framework's four efficiency values, and to the same residue classes:

| note's $d$ | 2 | 4 | 6 | 12 |
|---|---|---|---|---|
| $\eta = 2/d$ | 1 | 1/2 | 1/3 | 1/6 |
| classes served | 0,4,6,10 even; 1,9 odd | 3,7 odd | 2,8 even; 5 odd | 11 odd |

**This is the sharpest correspondence between the two documents.** The note derives $\{2,4,6,12\}$ from the local analysis of a parametric three-linear-polynomial system; the framework derives $\{1, 1/2, 1/3, 1/6\}$ from the structure of $r-1$ under Lemma B′. The two arguments share no step, and they produce the same partition of the residue classes mod 12 — with $d = 12$, equivalently $\eta = 1/6$, forced at exactly $n \equiv 11$.

> **A caveat that costs the note nothing.** The correspondence above is exact **for the note's own family** — the additive shapes $n = c + r$ and $n = 2c + r$, which are the framework's *unfused* readings (census S3 and S4). The framework's ceilings are attained by **fused** shapes at every odd class, and the note's family attains none of them: fusing $F$ blocks of size $c$ into one class is worth $\sqrt{F}$ unfused classes, so the cap becomes $\mathrm{cap}_F(\eta) = \eta/(1 + \sqrt{F\eta})^2$, and at odd $n$ the $F = 2$ fused rung — **at full twist, with no congruence condition on $c$ at all** — beats the note's unfused $2c + r$ everywhere, with $F = 4$ taking over at $n \equiv 11 \pmod{12}$. Indeed the note's odd shape is the framework's **census S4, which wins nowhere in the computed range**. Three consequences for reading the note against the framework:
>
> - **The efficiency needed at $n \equiv 11$ is $\eta = 1/3$, i.e. $d = 6$, not $\eta = 1/6$, $d = 12$** — the $F = 4$ shape sidesteps the doubled $\ell = 2$ obstruction that forces $d = 12$ in the note's three-block pattern (at $F = 4$, $4c \equiv 4 \pmod 8$ for every odd $c$, so the change-of-variable factor never arises). The note's "$d = 12$ is forced at $n \equiv 11$" is correct *within its own family* and is exactly why that family is not optimal there.
> - **The ceilings are keyed mod 12 — the same modulus as the note's own classification.** The mod-12 split is the $\ell = 2, 3$ obstruction. *(**Gotcha:** it is tempting to key these mod 24, on the grounds that reachability of the fused rung adds a condition mod 8. It does not — the rung is reachable at full twist at every odd $n$ — and every mod-8 condition in the derivation is either absorbed at $F = 2$ or constant on the mod-12 class at $F = 4$. Six constants, mod 12.)*
> - **That the note's shape is never the winner is not a defect of the note.** A lower bound does not need the optimal shape, and the unfused family is the one whose Oliver chain can be verified in three lines. The framework pays for its better constants in the machinery the note omits.
>
> None of this touches the note's Theorem, which needs only $\Omega(n^2)$ and gets it from the unfused family. It matters only when the note's $d$-table is read as the framework's *ceiling* table — the two agree on the modulus and on the residue classes, and they assign the same $\eta = 2/d$ at every class except $n \equiv 11 \pmod{12}$, where the framework's optimum switches shape and needs only $\eta = 1/3$.

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

For comparison, the framework's current ceilings, keyed **mod 12** and attained by fused shapes at every odd class:

| $n \bmod 12$ | rung | $\delta_0$ |
|---|---|---|
| 0, 4, 6, 10 | $F = 1$, $\eta = 1$ | $1/4$ |
| 2, 8 | $F = 1$, $\eta = 1/3$ | $0.13397$ |
| 1, 9 | $F = 2$, $\eta = 1$ | $3 - 2\sqrt2 = 0.17157$ |
| **3, 7** | $F = 2$, $\eta = 1/2$ | $1/8 = 0.125$ |
| 5 | $F = 2$, $\eta = 1/3$ | $0.10102$ |
| **11** | **$F = 4$, $\eta = 1/3$** | $7 - 4\sqrt3 = 0.07180$ |

*Six constants, keyed mod 12. The $F = 4$ shape sets the ceiling at $n \equiv 11 \pmod{12}$ only; every other odd class takes $F = 2$.*

The worst class is $n \equiv 11 \pmod{12}$ at $7 - 4\sqrt3 = 0.07180$, which is also the asymptotic global constant. Note that the note's family reaches $0.05051$ there and the fused family reaches $0.07180$ — the same numerical value the note's table shows at class 5, arrived at by a different shape.

Balance points in $x = c/n$ are $0.5$ (classes 0, 4, 6, 10), $0.3660$ (2, 8), $0.2929$ (1, 9), $0.25$ (3, 7), $0.2247$ (5) — and **$0.1340$ at class 11**, where $F = 4$ makes each block small. Condition 2 of (BCG_{1/5}) asks only that $c$ and $r$ each be at least $n/5$, which admits $x \in [0.2, 0.8]$ for even $n$ and $[0.2, 0.4]$ for odd, so the first five lie comfortably inside **and the sixth does not**.

> **Consequence: (BCG-AL) and (BCG_{1/5}) are not nested in either direction, and the class-11 value is why.** The note's window excludes the $F = 4$ configuration that attains the framework's ceiling at $n \equiv 11 \pmod{12}$ — necessarily, since four blocks of size $c$ summing inside $n$ forces $c/n \approx 0.134 < 1/5$. So (BCG-AL) does not imply (BCG_{1/5}): at class 11 it hands over a configuration the note's condition 2 rejects. And (BCG_{1/5}) plainly does not imply (BCG-AL), being far weaker in constant and restricted to the unfused shapes. They are **incomparable siblings over the same primes**, not a strong and a weak form of one statement, and neither's status transfers to the other. *(This is a sharpening of §2's caveat, which says the note's family attains no ceiling; the window is the mechanism, and it is worth stating separately because a reader checking the note's hypothesis against the framework's will otherwise expect a containment that does not hold.)* The region is deliberately generous: it is chosen so that (BCG_{1/5}) is easy to state and to check, not so that it is tight, and the resulting constant $1/350$ is correspondingly crude.

**The note's $\delta_0 = 1/350$ against the full $\delta_0$.** Both are densities relative to $\binom{n}{2}$, the unit the note fixes explicitly, since its construction bounds arrive naturally in units of $n^2$ and the factor 2 is easy to drop. The full analysis is $25\times$ better in the worst class, and the two bracket the observed minimum:
$$\underbrace{1/350 = 0.00286}_{\text{note's } \delta_0} \;<\; \underbrace{0.0462}_{\text{observed min, }n \le 10^5} \;<\; \underbrace{0.07180}_{\delta_0 \text{ at } n \equiv 11 \ (12)}$$

*(The right-hand term is now the asymptotic constant itself rather than one class's ceiling, since $7 - 4\sqrt3$ is attained exactly at the extremal classes.)*

**The three terms are of three different logical types, and the ordering is more informative once that is said.** The left is *conditional on* (BCG_{1/5}), *eventual*, and proved. The middle is *unconditional*, *global* over $[6, 10^5]$ with no exceptional set, and computed — and it is a run output, so it moves (upward, or over a wider range) with each ladder rerun; the note and this bridge quote the same run. The right is the *asymptotic* ceiling of a single family in a single residue class. So the middle term is not merely between the other two numerically — it is the strongest of the three in quantifier and the weakest in range, which is exactly what one would want as a sanity check: the proved eventual constant is conservative even when measured against a global minimum, and the asymptotic ceiling is not yet approached anywhere in the computed range.
The middle term lying between the two is the arithmetic check that both are right: the proved constant must be below the observed minimum, and the observed minimum must be below the best any single class guarantees.

**The note's Hypothesis (BCG_{1/5}) is one disjunct of a covering statement.** In full, a density-$\delta_0$ bound corresponds to a finite set of configuration *shapes* — 24 of them at $\delta_0 = 1/9$ and 65 at $1/16$, the raw feasibility counts of `arithmetic-of-density.md` §6.1 — each of which is a Hardy–Littlewood-type system moving with $n$ (the framework calls these Bateman–Horn systems as shorthand; the note is careful to reserve that name for fixed systems, and §3.5 of `arithmetic-of-density.md` is the full comparison). The correct implication is that *at least one* is solvable at each large $n$. (BCG_{1/5}) picks a small explicit subfamily — two block patterns, each with four permitted values of $d$ — and asserts that one of the eight always works. That is stronger than the framework needs, and far easier to state; the price is that it could in principle fail while the framework's conclusion survives, if some $n$ were covered only by a shape outside the eight.

---

## 3. Statements in the note's language

**The two engines.** The note's constructions are all *additive*: disjoint blocks whose sizes sum to $n$, with density capped at $1/k^2$ for $k$ blocks. The framework has a second, *multiplicative* engine — a single class of $F$ blocks of size $c$ fused into one orbit, $n = Fc$, with density about $1/F$. The note uses it exactly once, in §4 at $n = 2m$, without naming it: that is $F = 2$, giving $1/2$. The engine covers a density-zero set of $n$ — density $\ge \delta$ needs $F \le 1/\delta$, so $n$ must be a bounded multiple of a prime power — which is why the note is right to treat it as a special family rather than a general method.

**The note's condition 4 and the framework's Lemma C are the same issue handled at two prices.** Condition 4 ($r \nmid c-1$) *avoids* the twist and the foreign translations sharing a prime, so that $C_{c-1} \times C_r$ is cyclic outright — cheap, since it excludes $O(1)$ values of $q$ and nothing else. The framework cannot afford to avoid shares, because its enumeration must score every admissible configuration including those that keep one; there the sharing is *priced* instead — Lemma C's coupling forces the shared prime's action on the foreign block into a small cyclic group, capping that block's orbital, and a strip is licensed exactly where that cap already rules the configuration out. The note's version is the right one for a two-page construction; the framework's is what an exact evaluation requires.

**The $\theta$-ladder is now carried by the note in outline.** §5 of the note states the parametrisation $P(r-1) > r^{\theta} \Rightarrow \mu \gtrsim n^{1+\theta}$, places BBKN at $\theta = 1/2$ and (BCG_{1/5}) at $\theta = 1$, and gives Shparlinski's two rungs — $\theta = 1/4$ unconditionally for all large $n$, and $\theta = 0.677$ (now $0.679$) for almost all $n$. Three things in §3.6 do not travel and should not be reconstructed from the note: the **attribution split** between who proved an arithmetic input and who noticed this framework consumes it (only the $0.679$ update and the $\theta$ framing are ours); the **ERH trap**, that BBKN's ERH bound is superseded by Shparlinski's unconditional $n^{5/4+o(1)}$ and should not be quoted as a baseline; and the observation that the Baker–Harman ceiling is **technological rather than conjectural**, unlike Chowla's $1/2$. The note states the ERH point but not the other two.

**The mod 12 analysis is now carried by the note itself**, as the table of admissible $d$ and the change-of-variable argument behind it. What the framework adds is the same partition reached from the other side: there it appears as an *efficiency loss* — a factor 2 at $\ell = 2$, a factor 3 at $\ell = 3$ — rather than as a constraint on which $d$ is available. The note's "$d = 6$ and $12$ are excluded at $n \equiv 1 \pmod 3$" and the framework's "the $\ell = 3$ obstruction cuts $\eta$ by 3 exactly when $3 \mid r - 1$ is forced" are the same statement in the two vocabularies, related by $\eta = 2/d$.

**The upper bound, stated as the note would.** The note gives $\mu(n) \le \binom{n}{2}$ and observes that equality forces 2-homogeneity, hence prime-power degree. The framework replaces this with an exact evaluation: every Oliver group's orbit structure is one of an explicitly enumerable list of configurations, each configuration's minimum orbital is a closed-form expression in its parameters, and $B(n)$ is the maximum over that list. The upper bound $\mu(n) \le B(n)$ is then a classification theorem, and $\mu(n) = B(n)$ needs the further fact that the optimum is realised by an actual group. The statements are in place; the table rebuild and the certificate reruns are in flight, and until they land the framework, like the note, asserts lower bounds.

---

## 4. Consistency checks performed

1. **Both constructions built as explicit permutation groups** and their orbit decompositions on pairs computed, at four parameter choices each. Even: $n = 12 = 5+7$ gives $|\Gamma| = 420$, orbitals $\{10, 21, 35\}$. Odd: $n = 17 = 2\cdot5+7$ gives $|\Gamma| = 2100$, orbitals $\{10, 10, 21, 25, 35, 35\}$. All match the closed forms.
2. **The Oliver chain verified symbolically** in both cases, including that $\Gamma_1/\Gamma_2 \cong C_{c-1} \times C_r$ is cyclic exactly under condition 4 of (BCG_{1/5}), and that the diagonal action of $C_{c-1}$ in the odd construction is what keeps it cyclic.
3. **The constant re-derived numerically.** The efficiency to use is $\eta \ge 1/12$ — taking $\mathrm{orb}(r,t) \ge rt/2$ regardless of the parity of $t$, which is what the note's displayed bound uses. In fact $t = q$ is odd for all large $n$ (an even $t$ would mean $q = 2$ and $r = 2d + 1 \le 25$, excluded by $r \ge n/5$), so $\eta \ge 1/6$ does hold eventually and the note leaves a factor 2 on the table — deliberate crudeness, not necessity. *(This argument is the precedent for the correction to `sp-to-floor.md`'s Reduction Lemma, which used the halved value $rQ/2$ where every $d$ in its grid is even and $Q$ is therefore an odd prime. Same dichotomy, same conclusion; there the halving was not deliberate and cost a factor 2 in the headline constant. Worth noting that the correct version was written here first and did not propagate.)* With $\eta \ge 1/12$ the worst density is $1/300$ in **both** the even and the odd case — attained at the corner of the region where the foreign block is smallest, $r = n/5$, not at the balanced point — so $\delta_0 = 1/350$ is safe with room. *(The balanced point gives $1/48$; quoting that as the worst case is the easy slip here, since the minimising configuration is a corner and not an interior optimum.)* All three figures are densities relative to $\binom{n}{2}$, which is the unit the note fixes in §1 — the construction bounds arrive as $m^*/n^2$, a factor 2 away.
4. **Condition 2's region checked to contain all six balance points**, which span $[0.2247, 0.5]$ in $x = c/n$. The check to run is that the stated constraints leave a region *at all*: writing the condition as an upper as well as a lower bound on both $c$ and $r$ can silently pin $c = r = n/2$ at even $n$ — see §0.
4a. **The change of variable checked explicitly.** For odd $n$ the third polynomial is $(n-dq-1)/2$, so the parity of $c$ is governed by $n-r \bmod 4$, not $\bmod 2$; with $q$ odd, $d \equiv 2 \pmod 4$ forces $r \equiv 3$ and $d \equiv 0 \pmod 4$ forces $r \equiv 1$, verified over $q = 3, \ldots, 19$. This is why $\ell = 2$ contributes **two** factors of 2 in the odd case — one to make $r$ odd, one to fix $n \bmod 4$ — and hence why $d$ runs to $2 \times 6 = 12$ rather than to 6. The note states this explicitly; it is the detail most likely to be queried and least likely to be reconstructed.
4b. **The admissible-$d$ table computed exhaustively**: for each $n \bmod 12$ and each $d \in \{2,4,6,12\}$, whether the system $\{q,\ dq+1,\ \ldots\}$ has $\omega(\ell) < \ell$ at $\ell = 2, 3$. Every class has at least one admissible $d$; $d = 12$ is needed, and needed only at $n \equiv 11$.
5. **$1/350 < 0.0462 < 0.07180$** verified, all three in units of $\binom{n}{2}$ — and their quantifiers checked to differ as stated: the middle term is global over $[6, 10^5]$ (under the corrected scoring the floor is $0.04621$ at $n = 2759$, no value below $0.04$), confirmed by noting that the smallest $n$ appearing in the family-scan worklist at all is $323$, so every composite non-prime-power $n < 323$ already has lower bound above the asymptotic ceiling $7 - 4\sqrt3$, and the small values are far above the minimum ($\delta = 0.400$ at $n = 6$).
6. **The unconditional family cross-checked**: $n = 2m$, $m$ an odd prime power, gives orbitals $m(m-1)$ and $m^2$, density $(m-1)/(2m-1) \to 1/2$, which is Theorem 2.1 of the notes.

---

## 4b. Results available for a teaser, but not written up here

*The note's Theorem is one corner of a larger body of work. If the arXiv version wants to gesture at what else is established, these are the claims that are (i) proved or computed, (ii) statable in a sentence, and (iii) independent of the note's hypothesis unless marked.*

- **Exact values and the collapse — not yet teasable.** The claim $\mu(n) = B(n)$, certified per $n$ across the computed range, is withheld pending the runs: the table rebuild is in progress and the certificates await their reruns against it. Until both land, only the lower-bound half can be stated.
- **The global floor.** $\delta(n) \ge 0.0462$ for every composite non-prime-power $n \le 10^5$, attained at $n = 2759$, from a four-family scan whose families are all explicit — an unconditional lower bound over that range, with the scan extending routinely (to $10^6$ on the previous scoring) and the conjecture $\delta \ge 1/25$ open beyond it.
- **The closed-form ceilings.** **Six** constants indexed by $n \bmod 12$, from $1/4$ down to $7 - 4\sqrt3$, with the extremal class $n \equiv 11 \pmod{12}$ and the global asymptotic constant $7 - 4\sqrt3 = 0.07180$. *(Conditional on the covering hypothesis, as the note's $\delta_0$ is.)*
- **The reverse implication.** Lower bounds on $\mu$ yield additive statements about primes, so the connection runs both ways rather than being a one-off application.
- **Weakening the invariance group.** For properties invariant only under $A_n$ — which may separate isomorphic labelled graphs when every isomorphism between them is odd — the same $\Theta(n^2)$ holds, with $\mu_{\mathrm{chi}}(n) \ge \mu(n)/2$ in general, and at odd $n$ the fused constructions are even permutations outright, so the mod-12 ceilings carry over unscaled; the prime-power theorem qualifies to $n = 2^a$ and $n \equiv 3 \pmod 4$, failing at $n \equiv 1 \pmod 4$.
- **Higher arity.** At $k \ge 3$ the same machinery gives $\Theta(n^2)$ for $k$-uniform hypergraph properties, and the stabiliser analysis is *complete* at $k = 3$: no new phenomena appear at any larger $k$.

**What should not be teased.** The general monotone-transitive case, where this apparatus gives nothing new; and anything about the topological rungs above $\chi = 1$, where the honest statement is that no example is known and the search space has barely been explored.

## 5. What a fuller paper would add, in order of value

1. **The exactness claim**, which needs the classification and the collapse — the largest single addition, and the one that turns "$\mu = \Omega(n^2)$" into "$\mu(n)$ is computable".
2. **The mod 12 constants**, replacing $\delta_0 = 1/350$ with $\delta_0(n \bmod 12) \ge 7 - 4\sqrt3 = 0.07180$, a 25-fold improvement stated in closed form — and requiring the fused rungs, since a fused shape attains the ceiling at every odd class, the $F = 4$ shape at the extremal $n \equiv 11 \pmod{12}$.
3. **The covering formulation of (BCG_{1/5})**, which weakens the hypothesis from "these two shapes always work" to "some shape in a finite list works" — more robust and more likely to be provable.
4. **The reverse implication**, that lower bounds on $\mu$ yield additive prime statements, which is what makes the connection two-way rather than a one-off application.
5. **The unconditional infinite family** at density $\to 1/2$, already in the note but worth expanding, since it is the only part needing no hypothesis at all.

Items 1 and 4 are the ones a referee will ask about; items 2 and 3 are refinements that can be deferred.

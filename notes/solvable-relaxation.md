# The solvable relaxation: what Oliver's condition costs

*Companion note to `arithmetic-of-density.md` and `enumeration-proof.md`; this is row 2 of the hypothesis table in `orbital-evasiveness-notes.md` §1. Relaxes Oliver's chain condition to bare solvability, works out the resulting extremal problem, and reads off the price of the chain. Verification: `solvable_relaxation.py` (nineteen checks, all passing; it needs `mu_table_safe_v4.csv` only for the comparison pass). Status: the shape space and the ceiling are **proved** below; the two generic constants of §3 are **conditional on the same Goldbach-type input the main framework uses**; the weaker floors of §3½ are **unconditional** for large n, modulo one citation flagged there; everything is **verified** over n ≤ 2600.*

---

## 0. The question, and why it is the right one to ask

The framework's μ(n) is a maximum over groups satisfying **Oliver's condition**: a chain Γ₂ ◁ Γ₁ ◁ Γ with Γ₂ a p-group, Γ₁/Γ₂ cyclic, and Γ/Γ₁ a q-group. That condition is not a modelling choice — it is what makes the fixed-point-set argument run, and a group failing it carries no evasiveness conclusion. But it is also, structurally, a *severe* restriction, and the framework's seven ceiling constants (`aod` §3.3.5) all come from arithmetic that the chain forces: the twist on a prime block must be a q-power, so a prime r contributes only the q-part of r − 1, which is the efficiency η ≤ 1 that every ceiling is a function of.

Define **μ_solv(n)** identically, but maximising over *all solvable transitive groups of degree n*, and **δ_solv(n) = μ_solv(n)/C(n,2)**. Solvability is the weakest condition under which the same combinatorial analysis still applies — the block structure, the affine blocks, the class counting all survive — while every arithmetic constraint the chain imposes disappears. So the gap between δ and δ_solv isolates the chain's cost exactly, with the shape space held fixed.

**The headline.** The two problems have the *same* shape space, the *same* cap formula cap_F(η) = η/(1 + √(Fη))², and the *same* balance points. The relaxation changes exactly one thing: **η = 1 always.** Oliver's seven ceilings collapse to two — 1/4 at even n and 3 − 2√2 at odd n — and the global constant improves by a factor of **2.390**, from 7 − 4√3 = 0.071797 to 3 − 2√2 = 0.171573. Sharper still: the relaxed problem's *unconditional* odd-n floor of 1/9 (§3½) **exceeds the constrained problem's conjectural worst-case ceiling**.

---

## 1. The ceiling: δ_solv < 1/2, and why the framework's prime-power exclusion is doing real work

> **Proposition 1.** For n not a prime power, δ_solv(n) < 1/2. For n a prime power, δ_solv(n) = 1.

*Proof.* The relevant property is **2-homogeneity** — transitivity on *unordered* pairs — not 2-transitivity, since a single orbital is exactly one orbit on unordered pairs. The two are not the same, and the difference is not idle: they part company precisely at degrees ≡ 3 (mod 4), which is where much of this framework's arithmetic lives. Both branches nonetheless force a prime power. A 2-homogeneous group that is **not** 2-transitive has degree q ≡ 3 (mod 4) with q a prime power and lies in AΓL(1, q) (Kantor); a **solvable** 2-transitive group has a regular elementary abelian socle, hence prime-power degree (Huppert). So a solvable 2-homogeneous group has prime-power degree either way, and for n not a prime power the pair set splits into at least two orbitals, putting the minimum below C(n,2)/2. For n = p^a, AGL(1, p^a) is solvable and 2-transitive, so the single orbital is everything. ∎

> **Why the distinction has to be made here rather than waved at.** At even n it is harmless — a 2-homogeneous group of even degree is 2-transitive, the exceptional degrees being odd — which is why `orbital-evasiveness-notes.md` §2's Theorem 2.1 can pass through 2-transitivity at n = 2m without loss. At odd n it is not harmless, and stating the ceiling via 2-transitivity would leave the odd case unproved: one would have ruled out only the groups with one orbital on *ordered* pairs.

The second half is worth stating because it shows the framework's restriction to non-prime-powers is not bookkeeping: **at prime powers the solvable relaxation is vacuous**, δ_solv = 1, and any bound proved there says nothing. That the same n are exactly the ones ARK settles by other means is a coincidence of the two problems having the same easy case, not a shared mechanism.

The ceiling is approached: at **n = 2q with q a prime power** a single orbit of two fused q-blocks gives classes q(q − 1) and q², so δ_solv = (q − 1)/(2q − 1) → 1/2. Verified: the maximum over all non-prime-power n ≤ 2600 is 0.49981, at n = 2594 = 2·1297.

## 2. The shape space collapses to one formula

An orbit of size s is a transitive solvable group; to make its minimum orbital large it should be F blocks of prime-power size c, s = F·c, each block carrying an affine group **2-homogeneous** on it — so the whole within-block pair set is one class — with the F blocks permuted transitively. Its classes are the fused within-block class **F·C(c,2)** and the cross-block class **m(F)·c²**, where m(F) is the permuter's minimum orbital on unordered pairs of blocks.

> **What 2-homogeneity on a block actually costs, which is less than AGL(1, c).** The full AGL(1, c) always works, being 2-transitive. But at **c ≡ 3 (mod 4)** the index-2 subgroup C_c ⋊ C_{(c−1)/2} is already 2-homogeneous — the twist omits −1, so it fuses the two halves of each difference class — while at c ≡ 1 (mod 4) it is not, and the pair set splits in two. Verified directly at c = 7, 11, 19, 23 (one orbital) against c = 5, 13, 17 (two). This changes nothing in the solvable world, where the full group is free, but it is exactly the mechanism behind the framework's orb(c, d) = cd/2 versus cd split, and it is why c ≡ 3 (mod 4) recurs throughout `aod` §3.

> **Proposition 2.** The within-block class always binds, so an orbit of size s is worth **score(s) = s·(P(s) − 1)/2**, where **P(s) is the largest prime-power divisor of s**. Between two orbits of sizes sᵢ, sⱼ every cross pair lies in one class of exactly sᵢsⱼ.

*Proof.* Even the weakest admissible permuter, a cyclic C_F, has m(F) ≥ F/2, and (F/2)·c² > (F/2)·c(c − 1) = F·C(c,2). So the cross class never binds and the orbit is worth F·C(c,2) = s(c − 1)/2, maximised over prime-power c | s by taking c = P(s). Cross-orbit pairs between two orbits number sᵢsⱼ and form at most one class. ∎

This is a striking simplification against the Oliver world, where the shape space needs Parts B through D of `enumeration-proof.md` to pin down and where the analogous quantity depends on twist orders, layer assignments and coprimality budgets. Here **the entire group-theoretic content of an orbit is the size of its largest prime-power divisor.** Two consequences worth noting:

- **Fusion is never *preferred*, only permitted.** For fixed s, an unfused prime-power orbit (P(s) = s) is worth ≈ s²/2 while a fused one with P(s) = s/2 is worth ≈ s²/4. Fusion earns its place only when s is not itself a prime power — which at odd n is forced, since one part must be even.
- **The "save the cyclic layer" problem vanishes.** In the Oliver world the twist competes with the block count and the foreign primes for room in the single cyclic layer (SAFE's `dmax` stripping, Lemma C). Here each block simply takes all of AGL(1, c), and nothing is shared between orbits.

**B_solv(n)** is then the maximum over partitions n = s₁ + … + s_k of min(minᵢ score(sᵢ), min_{i<j} sᵢsⱼ).

> **At most two parts.** Writing xᵢ = sᵢ/n and θᵢ = P(sᵢ)/sᵢ ≤ 1, the intra term of part i is xᵢ²θᵢ and the cross term of a pair is 2xᵢxⱼ, both as fractions of C(n,2). With k equal parts the intra terms give θ/k² against cross 2/k², so the intra binds and the value falls like 1/k². Three or more parts therefore never win, and no k ≥ 3 partition wins at any n < 400 by exhaustive check. **This looks like a structural difference from the Oliver world and is a smaller one than it appears.** Three-part shapes do not win there either — S4's asymptotic share is zero, the odd-n winner being two-part throughout, at F = 2 on eight residues and F = 4 on four (`aod` §3.3.5). What differs is *why*: here three or more parts lose on the balance, the value falling like 1/k² with nothing to buy back; there a third part is a way to keep η up when the congruences cut it, and it is beaten not by the balance but by a two-part shape with a larger fusion count that keeps η up more cheaply. The relaxation removes the reason a third part was ever attractive, rather than removing a family that was winning.

## 3. The two generic constants

**Even n.** Take two odd prime-power parts near n/2, each θ = 1. Then δ = min(x², 2x(1 − x)) which is maximised at the equal split x = 1/2, giving **1/4 = cap₁(1)**. The intra terms bind (1/4 against a cross term of 1/2), so the balance point is the equal split exactly. This is Goldbach with both summands near n/2 — the same input `aod` §3.2 needs, and no shifted-prime condition on top.

**Odd n.** One part must be even, hence (unless it is a power of 2) has θ = 1/2 at best — it is 2c with c a prime power, i.e. **a fused pair of blocks**. The other is an odd prime power, θ = 1. So δ = min(x₁²/2, x₂², 2x₁x₂), and balancing the two intra terms gives x₁ = √2·x₂, hence

> **x₂ = 1/(1 + √2) = 0.41421, and δ = 1/(1 + √2)² = 3 − 2√2 = 0.171573 = cap₂(1).**

Verified: over non-exceptional odd n ≥ 1200 the median δ_solv is 0.16734 and the median small-part share is 0.4167, against the predicted 0.17157 and 0.41421. **The balance point is the framework's own**: `aod` §3.3.5 lists x\* = (2 − √2)/2 = 0.29289 as the block share for the fused odd rung at η = 1, and 1 − 2(0.29289) = 0.41421 is the same split read from the other side. The shape is n = 2c + r\* exactly as predicted — a fused pair on one side, an unfused prime on the other, with the asymmetry between them (θ = 1/2 against θ = 1) doing all the work in setting the balance.

**The exceptional family.** A single orbit gives δ = (P(n) − 1)/(n − 1) ≈ P(n)/n, which beats the generic constant when n has a prime-power divisor above n/4 (even) or above n/5.83 (odd) — that is, n = mc with c a prime power and m ≤ 5. Such n are a **density-zero** set, their share decaying like log 5/log n; measured, the share of single-orbit winners falls 0.370 → 0.285 → 0.238 across [100,500], [500,1200], [1200,2600], against log 5/log n of 0.282 → 0.239 → 0.213. The observed multipliers are m ∈ {2, 3, 4, 5} plus three small values at m = 7 (n = 119, 721, 1211) where the two-part split fails on supply rather than on balance. **This family has no analogue in the Oliver world**, where a single fused orbit needs its block count and twist to fit the chain and cannot simply take AGL(1, c).

**Both constants are conditional**, each on a binary-Goldbach-type input: two prime powers near n/2 at even n, c prime with n − 2c prime at odd n. One partial strengthening is free — almost all even n admit a near-equal Goldbach split, so **δ_solv = 1/4 − o(1) for almost all even n unconditionally** — but for *every* n the unconditional statement is weaker and is the subject of §3½. Note that Chen's P₂ does not help here: a product of two primes has a small largest prime-power divisor, hence poor θ.

## 3½. Unconditional floors: 1/9 at odd n, 1/16 at even n

Everything in §3 is conditional. Both generic constants need a **binary**-Goldbach-type input — two prime powers near n/2 at even n, and c prime with n − 2c prime at odd n — so as stated they rest on the same unproved supply the main framework rests on. That is worth separating out, because unlike the Oliver problem the solvable one has a **positive unconditional floor**, and the reason is a clean parity argument.

> **Proposition 3.** For every ε > 0 there is n₀(ε) such that for all n ≥ n₀(ε),
> **δ_solv(n) ≥ 1/9 − ε** for odd n, and **δ_solv(n) ≥ 1/16 − ε** for even n.

*Proof sketch.* With k orbits of prime sizes and shares xᵢ, θᵢ = 1 throughout, so δ = min(minᵢ xᵢ², min_{i<j} 2xᵢxⱼ); the intra terms bind and the equal split gives **1/k²**. So the question is only the smallest k for which a near-equal all-prime representation is unconditionally available.

**Odd n takes k = 3.** Ternary Goldbach supplies n = p₁ + p₂ + p₃, and the circle method supplies it in the *interval-constrained* form — each pᵢ confined to an interval of length εn about n/3 — since the major-arc main term survives the restriction and the singular series stays bounded below for odd n. That gives δ ≥ (1/3 − ε)² = 1/9 − O(ε).

**Even n is forced up to k = 4, and this is where the parity argument bites.** Three odd primes sum to an odd number, so an even n has no three-odd-prime representation at all. The only way to keep k = 3 is to admit the prime 2 as a part — and a part of size 2 scores C(2,2) = 1, which annihilates the minimum. (An even prime-power part 2^a near n/3 would do, but its existence at a given n is not unconditional.) So k = 4, with four primes near n/4, giving δ ≥ (1/4 − ε)² = 1/16 − O(ε). ∎

**What the parity costs, stated as the two losses.** At odd n the unconditional route gives up **fusion**: the conditional optimum uses an even part 2c whose fused pair supplies θ = 1/2, and an all-prime representation has no even part at all, so 3 − 2√2 = 0.1716 drops to 1/9 = 0.1111. At even n it gives up **the two-part split**: 1/4 drops to 1/16, a full factor of 4, because the part count doubles and the value goes as 1/k². Even n is therefore the case where being unconditional is expensive, which inverts the conditional picture where even n is the *better* case.

**Numerically, the constants are approached rather than attained**, the deficit being the failure of the primes to sit exactly at n/k. Best-balanced representations:

| n (odd) | three primes | δ | deficit from 1/9 |
|---|---|---|---|
| 1001 | 317 + 317 + 367 | 0.10007 | 0.01104 |
| 2001 | 659 + 659 + 683 | 0.10835 | 0.00276 |
| 5001 | 1667 + 1667 + 1667 | 0.11107 | 0.00004 |
| 20001 | 6661 + 6661 + 6679 | 0.11090 | 0.00021 |

| n (even) | four primes | δ | deficit from 1/16 |
|---|---|---|---|
| 1000 | 241 + 241 + 241 + 277 | 0.05790 | 0.00460 |
| 2000 | 499 + 499 + 499 + 503 | 0.06216 | 0.00034 |
| 10000 | 2477 + 2477 + 2503 + 2543 | 0.06134 | 0.00116 |
| 20000 | 4999 + 4999 + 4999 + 5003 | 0.06247 | 0.00003 |

**And the floors are not binding in the computed range**, so nothing needs the asymptotics below n₀: the minimum of δ_solv over all non-prime-power n ≤ 2600 is **0.12296, at n = 551**, above 1/9 and well above 1/16, with no value anywhere in range falling below either constant.

> **The comparison that makes this worth a section.** The solvable relaxation's *unconditional* floors, 1/9 and 1/16, sit either side of Oliver's conditional worst-class ceiling of 7 − 4√3 = 0.071797 at n ≡ 11 (mod 12): the odd-n floor **1/9 = 0.1111 exceeds it**, while the even-n floor 1/16 = 0.0625 falls just below. So at odd n the relaxed problem's *unconditional* guarantee beats the constrained problem's *conjectural* one — the sharpest statement of the price available here, and one no sieve improvement changes since it compares a proved bound against a ceiling. At even n the comparison runs the other way and the two are close, which is worth stating rather than eliding.

*One check owed.* The interval-constrained forms of ternary Goldbach and of the four-prime theorem are standard circle-method output, but the versions quoted above — all parts within εn of n/k, for every fixed ε and all large n — should be pinned to a specific reference rather than to folklore before this is circulated. Helfgott gives ternary Goldbach for all odd n ≥ 7 unconditionally; the interval-constrained refinement is what needs the citation, and it is also where an effective n₀(ε) would come from.

## 4. What Oliver's condition costs

The two problems produce ceilings from the same formula. Under the relaxation η = 1 everywhere, so:

| n mod 24 | Oliver ceiling | solvable ceiling | ratio | what the chain is charging for |
|---|---|---|---|---|
| 0, 4, 6, 10, 12, 16, 18, 22 | 1/4 | 1/4 | **1.000** | nothing — η = 1 is already reachable |
| 1, 9, 13, 21 | 3 − 2√2 = 0.17157 | 3 − 2√2 | **1.000** | nothing |
| 3, 19 | 1/8 | 3 − 2√2 | 1.373 | η = 1/2: the twist loses the 2-part of r − 1 |
| 5, 17 | 5 − 2√6 = 0.10102 | 3 − 2√2 | 1.698 | η = 1/3: local obstruction at ℓ = 3 |
| 2, 8, 14, 20 | (2 − √3)/2 = 0.13397 | 1/4 | 1.866 | η = 1/3 at even n |
| 7, 15 | 1/9 = 0.11111 | 3 − 2√2 | 1.544 | η = 1 is reachable at F = 4, but F = 4 costs against F = 2 |
| **11, 23** | 7 − 4√3 = 0.07180 | 3 − 2√2 | **2.390** | η = 1/3: the ℓ = 3 obstruction, at F = 4 |

**Two distinct charges, and they are separable.** The first is the **shifted-prime penalty**: the chain forces the twist to be a q-power, so a prime r contributes only η = 2/D of its multiplicative group, and every ceiling is cap_F(2/D) rather than cap_F(1). The second is a **fusion-count penalty** at the four residues whose optimum takes F = 4: reaching a usable η there costs a larger F, and cap_F(η) decreases in F, so even at η = 1 the class caps at cap₄(1) = 1/9 rather than cap₂(1) = 3 − 2√2 — visible at 7 and 15, where the efficiency is already perfect and the whole 1.544 is the fusion count. The relaxation removes both: the twist is the whole of C_{c−1}, so η = 1 everywhere, and F = 2 suffices because no congruence forces a larger one.

The **global constant** is where the two charges compound. Oliver's is 7 − 4√3 = 0.071797, attained on all of n ≡ 11 (mod 12) — the odd residues carrying the ℓ = 3 obstruction, which forces both a cut efficiency and the larger fusion count. The relaxation's is 3 − 2√2 = 0.171573, the odd-n constant. **The chain costs a factor of 2.390 in the worst class and nothing at all in twelve of the twenty-four.**

**Empirically, against the computed table.** B_solv ≥ B_safe at all 2,186 tabulated non-prime-power n, as it must be since Oliver groups are solvable. The median ratio is 1.082 (1.040 at even n, 1.194 at odd n), with 41% exact equality and a maximum of 4.275 at n = 2147. The empirical ratios sit *below* the ceiling ratios above because both sides frequently exceed their family ceilings by other shapes — the table's values are attainments, not caps.

## 5. What this says about the framework

**The chain's cost is entirely arithmetic, not structural.** Both problems reduce to the same balance, the same shape space and the same cap formula; only η moves — and, through η, which fusion count is worth paying for, since F is chosen to buy efficiency and the relaxation makes efficiency free. That is a genuinely useful separation, because it means the framework's ceiling constants are *not* artefacts of an idiosyncratic shape space — remove the chain and the same analysis produces the same formula at η = 1. Anyone doubting the seven constants should doubt the η bookkeeping, not the geometry.

**It corrects a prediction in `orbital-evasiveness-notes.md` §9 item 9.** That item conjectures that a layer word with an abelian or nilpotent top should show no residue structure and "bare ceilings 1/4 and 1/9". The residue structure does vanish and the even ceiling is bare 1/4, but the odd ceiling is **3 − 2√2 = 0.17157, not 1/9**: the 1/9 reading assumes odd n needs three parts, and once the twist is unconfined a fused pair is always available, so the two-part shape wins. The item's probe never tested this, having moved only even n (56, 60, 63, 66, 70).

**Three-part shapes are a chain phenomenon.** Under the relaxation they never win. In the Oliver world they are the generic odd-n winner, because the third part is what keeps η up rather than what balances the sizes. That is a sharper account of the odd-n three-class shape than "the sizes want to be equal", and it predicts where a partial relaxation would first change the answer.

**A caution about direction.** δ_solv is *not* an upper bound for anything in the ARK programme, and must never be quoted as one. A solvable group without the chain carries no evasiveness conclusion, so μ_solv bounds no topological quantity; it measures the *combinatorial* headroom the chain gives up. In particular the fact that δ_solv ≥ 0.17157 generically says nothing about whether μ(n) ≥ 0.17157·C(n,2), and the 1/25 conjecture is untouched by anything here.

**One suggestive reading, offered as such.** Three constants sit close together: the relaxation guarantees **3 − 2√2 ≈ 0.1716**, Oliver groups guarantee **7 − 4√3 ≈ 0.0718**, and the conjectured floor for μ is **1/25 = 0.04**. So the chain costs a factor of **2.39**, and the conjectured floor sits a further **1.80** below what the chain still guarantees. Those are the same order, which is the point: the chain is expensive but not dominant, and the larger part of the gap between a family ceiling and μ's actual floor is that these are all *families*. δ(n) is a maximum over shapes, and shapes routinely beat every family ceiling — `aod` §3.3.5 says so, and 86 of the 118 class-11 (mod 12) values in the contiguous range exceed the class ceiling 7 − 4√3 itself.

---

*Open, and cheap if wanted.* Three intermediate conditions would localise the cost further.

> **First, a trap in stating them.** The cyclic layer cannot simply be *dropped*: doing so makes the condition **vacuous**. Take Γ₂ = 1 and Γ₁ = Γ — then Γ₂ is a p-group and Γ/Γ₁ is a q-group trivially, and Γ₁/Γ₂ = Γ is unconstrained, so every group qualifies and μ degenerates to a maximum over all transitive groups. The outer two conditions are prime-power conditions that a *trivial* factor satisfies for free, so they constrain nothing by themselves; the middle layer is the only one of the three carrying content unaided. Any relaxation of it must therefore **replace** it rather than remove it, and the natural replacement is **abelian**.

1. **Γ₁/Γ₂ abelian rather than cyclic.** This isolates the coprimality budget: cyclic forces the layer's order to be a product of pairwise-coprime factors, so every F_mid, every cyclic-layer twist and every foreign prime must be mutually coprime, while abelian permits C_r × C_r and drops the budget entirely. `orbital-evasiveness-notes.md` §9 item 9 has already probed this over n ≤ 70 and found **no change at any n**, consistent with Lemma C being vacuous on every winning configuration in the table — the budget appears to be slack at the optimum.

   > **But it is not slack in the *proofs*, and Lemma D2 is where that shows.** D2's diagonal-translation step is exactly "Γ₁/Γ₂ cannot contain C_r^F, being cyclic". Under an abelian middle layer that step fails outright and independent per-block translations become admissible — C_r ≀ C_2 has Γ₁ = C_r × C_r abelian and Γ/Γ₁ = C₂. At r = 5 that group has orbitals 10 / 10 / 25, so m\* = 10 = |O| — twice the bound D2 used to assert, reached without any 2-homogeneous permuter and by independent translations alone. The exhaustive (2,5) scan in `a18_rq_verify.py` records that these rank-2 translation groups are chainless *under Oliver's condition*; they would not be under this one. So the probe's "no change in the values" and "no change in the arguments" are different claims, and only the first has evidence. Anyone running this relaxation should expect to reprove D2, not merely rerun the search.

2. **Γ/Γ₁ nilpotent rather than a q-group.** This isolates the shifted-prime penalty alone, and should recover η = 1 while leaving the layer structure intact. It is the one that would say directly whether that penalty is the whole story — the probe already moves five arithmetically weak n by factors 1.22–1.85, all even, so the odd-n prediction is untested.

3. **Supersolvable rather than solvable**, the narrowest relaxation still permitting a 2-homogeneous group on a prime block.

Each of (2) and (3) is a small edit to `solvable_relaxation.py`'s `score`; (1) is not, since it changes which orbits exist rather than what they are worth.

# Chiral graph properties: the framework under A_n rather than S_n

*Companion to `enumeration-proof.md` and `arithmetic-of-density.md`. Those develop μ(n) for monotone **S_n**-invariant properties of E(K_n) — graph properties. This one ports the whole apparatus to monotone **A_n**-invariant properties, and works out what each construction costs when every group in it has to consist of even permutations.*

**Status.**

| section | standing |
|---|---|
| §1 the definition and why it is the right object | definitional |
| §2 the halving theorem | **proved**, one line |
| §3 the parity calculus | **proved**; each rule verified computationally, including the entangled-generator rule (F2) |
| §4 prime powers: KSS survives at 3 mod 4 and fails at 1 mod 4 | **proved**, and verified at every odd prime ≤ 31 and at c = 4, 8, 16 |
| §5 the chirality efficiency, and the ported cap formula | **derived**; the conclusion ε = 1 at every fused class is verified on the groups |
| §6 what is open | a to-do list |

---

## 1. The object

A **graph property** is a monotone family of subsets of E(K_n) invariant under S_n acting on the n vertices. A **chiral graph property** is the same with S_n replaced by **A_n**.

The difference is exactly a chirality. A chiral property may evaluate two *isomorphic* labelled graphs differently, provided every isomorphism between them is an odd permutation. That happens precisely for graphs G with **Aut(G) ≤ A_n**: their S_n-orbit splits into two A_n-orbits, and a chiral property is free to take one and leave the other. Graphs admitting an odd automorphism are unaffected, since their orbit does not split.

> **Two things follow immediately and are worth stating before any machinery.**
>
> - **Every graph property is a chiral graph property.** So evasiveness for all chiral properties is a *strictly stronger* statement than ARK: proving it is harder, and **finding a counterexample is easier**. That asymmetry is the reason to care — the chiral world is where a counterexample to something ARK-adjacent could plausibly live while ARK itself stays true.
> - **The prime-power theorem is not inherited.** KSS proves evasiveness at n = p^a using AGL(1, p^a), which is 2-homogeneous and Oliver. §4 shows that group is *not* inside A_n at odd p, so the argument has to be redone, and it does not survive intact.

Throughout, μ_chi(n) is the maximum over Oliver groups **Γ ≤ A_n** of the minimum Γ-orbital on pairs, and δ_chi = μ_chi(n)/C(n,2).

---

## 2. The halving theorem: nothing is lost by more than a factor of two

> **Theorem 1.** For every n, **μ_chi(n) ≥ μ(n)/2**, hence δ_chi ≥ δ/2.

*Proof.* Let Γ realise μ(n). The sign map Γ → {±1} is a homomorphism, so Γ⁺ := Γ ∩ A_n has index 1 or 2 in Γ. Γ⁺ is again an Oliver group — the chain conditions are inherited by subgroups with the same p and q, since Γ₂ ∩ Γ⁺ is a p-group, the middle quotient embeds in a cyclic group hence is cyclic, and the top quotient embeds in a q-group. Each Γ-orbital is a union of Γ⁺-orbitals, and the number of pieces is the index of the stabiliser's image, hence at most 2. So every Γ⁺-orbital has size at least half a Γ-orbital. ∎

**So the whole framework transfers with a constant, and Θ(n²) is untouched.** In particular the asymptotic constant 7 − 4√3 becomes at worst (7 − 4√3)/2 ≈ 0.0359, and §5 of `arithmetic-of-density.md`'s conjectural floor 1/25 becomes at worst **1/50**. Those are the worst cases the theorem allows; §5 finds that at odd n the factor is not paid at all.

> **When the factor is actually paid.** A Γ-orbital containing the pair {x, y} splits under Γ⁺ **iff every element of Γ stabilising {x, y} setwise is even**. If some odd element fixes the pair, the orbital survives whole. So the loss is not automatic, and §4 identifies exactly where it bites.

---

## 3. The parity calculus

Everything reduces to the sign of the three generator types the framework uses, on a block of size c = p^a. All three are elementary and all three are verified below.

> **(T) Translations.** x ↦ x + s on 𝔽_c is a product of c/p cycles of length p, so its sign is (−1)^{(p−1)c/p}. Hence **translations are even iff p is odd, or p = 2 and 4 | c.**
>
> **(M) The multiplicative twist.** x ↦ ux with u of order d fixes 0 and acts on 𝔽_c^× as (c−1)/d cycles of length d, so its sign is (−1)^{(d−1)(c−1)/d}. Hence **the twist is even iff d is odd, or (c−1)/d is even.**
>
> **(F) The block swap.** Two cases, and the framework needs the second.
>
>  **(F1) A pure diagonal F-cycle** on F blocks of size c is a product of c cycles of length F, sign (−1)^{(F−1)c}: **even iff F is odd, or c is even.**
>
>  **(F2) An entangled generator** — z:(i,x) ↦ (i+1, aᵢx) with ∏ aᵢ = A of order d, so that z^F is the full twist — has a different cycle type: one F-cycle on the F zeros, and (c−1)/d cycles of length F·d on the rest. So
>
>   **sgn(z) = (−1)^{F−1}·(−1)^{(Fd−1)(c−1)/d}**,
>
>  and at **full twist d = c − 1** this is (−1)^{F−1}·(−1)^{F(c−1)−1} = **+1 for every even F and every odd c**. Its F-th power, the diagonal twist across all F blocks, is the single-block twist's sign raised to the F-th, hence **even at every even F regardless of d**.
>
> **Gotcha, and it is the one this section is easiest to get wrong: (F1) is not the rule the framework needs.** A fused matching class is realised by *one* entangled generator, not by a block permutation and a twist separately (`arithmetic-of-density.md` §3.2.3), so its parity is (F2)'s and not the product of (F)'s and (M)'s. The two disagree exactly where it matters — see §5.

**A blanket consequence worth having first: any group of odd order is inside A_n**, since an element of odd order is a product of odd-length cycles. So every parity constraint below concerns 2-parts only — of the twist, of the block count, and of the characteristic.

*Verified.* (M) at every odd prime c ≤ 31 for d = c − 1 and d = (c−1)/2; (T) and (M) at c = 4, 8, 16 in characteristic 2. (F2)'s cycle-type formula against brute-force sign computation at c = 5, 7, 11, 13 and F = 2, 4; and the closed form at c = 5, 7, 9, 11, 13, 17, 25, 27, 29 with F = 2, 4, 6.

---

## 4. Prime powers: the theorem splits on c mod 4

This is where the qualification bites hardest, and it is worth doing in full because it is the case KSS settles unconditionally for graph properties.

**The full affine group is excluded at odd characteristic.** For c odd and d = c − 1, rule (M) gives sign (−1)^{(c−2)·1} = −1, since c − 2 is odd. So **AGL(1, c) ⊄ A_c for every odd prime power c** — confirmed by direct computation at c = 5, 7, 11, 13. The translations are fine; it is the full-order twist that is odd.

**So the largest admissible twist is d = (c−1)/2**, for which (c−1)/d = 2 is even and rule (M) gives an even permutation, for every odd c. What that twist buys depends on c mod 4, through whether −1 lies in the twist subgroup T of index 2:

> - **c ≡ 3 (mod 4).** (c−1)/2 is odd, so −1 ∉ T, and ±T has order c − 1. The orbital is c(c−1)/2 = **C(c,2)** — the group is 2-homogeneous and the whole pair set is one orbital.
> - **c ≡ 1 (mod 4).** (c−1)/2 is even, so −1 ∈ T, and ±T = T of order (c−1)/2. The pair set splits into **two orbitals of C(c,2)/2 each**.

**Characteristic 2 loses nothing.** For c = 2^a with a ≥ 2, translations are even by (T) (4 | c), and the full twist of order c − 1 is odd-order hence even. So **AGL(1, 2^a) ≤ A_c** and is 2-transitive: one orbital, δ_chi = 1. Verified at c = 4, 8, 16, giving orbitals [6], [28], [120] = C(c,2) in each case.

> **Theorem 2 (the qualified prime-power theorem).** For n a prime power,
>
> **δ_chi(n) = 1** if n = 2^a with a ≥ 2, or n = p^a ≡ 3 (mod 4);
> **δ_chi(n) = 1/2** if n = p^a ≡ 1 (mod 4).
>
> Consequently every nontrivial monotone chiral property is evasive at prime powers **n ≡ 3 (mod 4) and n = 2^a**, by the KSS argument verbatim; and at n ≡ 1 (mod 4) that argument gives only two orbitals and no contradiction.
>
> *Verified:* orbitals [21], [55], [171], [253], [465] at c = 7, 11, 19, 23, 31 (one orbital each), against [5,5], [39,39], [68,68], [203,203] at c = 5, 13, 17, 29 (two halves each).

**This is exactly the halving of Theorem 1, realised.** The excluded residue class is where the factor of two is genuinely paid, and it is a clean congruence rather than a sporadic loss.

> **And it predicts where the interesting examples live.** n = 5 is the smallest prime power ≡ 1 (mod 4), and it is precisely where the chiral analysis found a candidate: the down-closure of one A₅-orbit of Hamiltonian cycles is ℚ-acyclic with H̃₁ = ℤ/2, homotopy equivalent to ℝP² (see `pending-checks.md` R10). The next members are n = 9, 13, 17, 25, 29. **The residues 1 mod 4 are the chiral world's analogue of the non-prime-power n in the S_n world**, and for the same structural reason: they are where the natural group falls one orbital short. (§5: this is where the analogy stops — unlike the non-prime-power case, the shortfall does not propagate into the composite analysis, because a *fused* class recovers the full twist.)

---

## 5. The chirality efficiency, and how the cap formula ports

Define, for a block of size c, the **chirality efficiency**

> **ε(c) = 1** if c = 2^a (a ≥ 2) or c ≡ 3 (mod 4);  **ε(c) = 1/2** if c ≡ 1 (mod 4),

so that the largest A_c-admissible intra-orbital on the block is ε(c)·C(c,2) rather than C(c,2). Then the framework ports as follows.

**The matching class — and ε = 1 whenever it is fused.** The cap d ≤ (c−1)/2 of §4 is a statement about a **single** block, where the twist must be even on its own. A *fused* class of even F does not need that: by (F2) the entangled generator is even at full twist for every even F and every odd c, and so is its F-th power, the diagonal twist. So

> **ε(c) = 1 at every even F, at every odd prime power c**, and the intra term is the full F·C(c,2) — the c ≡ 1 (mod 4) penalty applies only to **unfused** matching blocks (F = 1).

*Verified on the groups themselves:* ⟨translations, z⟩ on F·c points at c = 5, 13, 17 and F = 2, 4 has every generator even, and its pair-orbitals include the full F·C(c,2) — [20, 25] and [40, 50, 100] at c = 5, [156, 169] and [312, 338, 676] at c = 13, [272, 289] and [544, 578, 1156] at c = 17. Each of those c is ≡ 1 (mod 4), where a single block would be halved.

**The foreign block.** A foreign prime r has translations of odd order r, always even. Its twist is a q-power t, and by (M) it is even iff t is odd — automatic for **q odd** — or (r−1)/t is even. So:

> **an odd top prime q costs nothing**; at **q = 2** the twist is capped at half the 2-part of r − 1, i.e. **the efficiency η is halved on the Fermat branch and nowhere else.**

That is a sharp and slightly surprising localisation: the shifted-prime supply question of `aod` §3.6 is *unchanged* at odd q, and the whole ceiling analysis at η = 1 with odd q goes through verbatim.

**The block swap.** By (F1) a *pure* diagonal F-cycle needs F odd or c even, which at odd n would exclude every even fusion count. **That is not the constraint the framework faces**, because the swap is entangled: by (F2), at full twist and even F the generator is even at every odd c. So **even fusion counts are available at odd n, unconditionally**, and the F = F_mid·F_top split of `enumeration-proof.md` G.2 acquires no parity condition. In particular the **F = 4 shape that sets the ceiling at n ≡ 11 (mod 12) is not exposed here at all** — which retires what was item 1's main worry.

**The cap formula itself is unchanged.** cap_F(η) = η/(1 + √(Fη))² is an optimisation over sizes and is indifferent to which subgroup realises the terms; what changes is the *inputs*, each term acquiring its ε or halved η. So the ported ceiling is

> **cap_F(η; ε) = ε·η / (√ε + √(Fη))²**  — the same balance argument with the matching term scaled by ε,

reducing to cap_F(η) at ε = 1 (checked). **And ε = 1 at every row the odd ceilings use**, since those all take F ≥ 2 and a fused class pays no penalty. So the six mod-12 ceilings of `aod` §3.3.5 survive **unscaled** at odd n, not merely in form:

> **δ_chi(n) = δ(n) at every odd n, as far as the ceiling analysis sees.** The halving of Theorem 1 is a bound, and outside the prime powers ≡ 1 (mod 4) it is not paid. The remaining exposures are two, both narrow: an **unfused** matching block (F = 1, so the even classes' two-part S3 shape) pays ε = 1/2 at c ≡ 1 (mod 4), which is avoidable by choosing c ≡ 3 (mod 4) — a positive-density supply condition, not an obstruction; and the **q = 2 Fermat branch** halves η, which the odd ceilings do not use.
>
> So the global asymptotic constant stays at **7 − 4√3** rather than dropping, and the chiral floor conjecture is δ_chi ≥ 1/25 as in the S_n world, with 1/50 the weaker statement Theorem 1 *proves* unconditionally.
>
> **Where ε = 1/2 can still be paid, it costs less than a half.** ε enters both the numerator and the balance point, so a less efficient matching block is compensated by a larger share of n, and the cost is a factor **0.65–0.75** rather than 0.5. That applies only to the **F = 1** rows — the even classes' two-part shape — and only at c ≡ 1 (mod 4): 1/4 → 0.171573 (×0.686) at n ≡ 0, 4, 6, 10 (mod 12), and 0.133975 → 0.101021 (×0.754) at n ≡ 2, 8. Both are avoidable by taking c ≡ 3 (mod 4).
>
> **A coincidence worth noticing, and worth not over-reading.** cap₁(1; ½) = 3 − 2√2 and cap₂(1; ½) = 1/9 are **exactly S_n ceilings one rung down** — the ε = ½ penalty behaving like a shift along the existing ladder rather than a new constant, as one would expect if halving the twist acts like halving the efficiency. It is a numerical coincidence of the cap formula, not a structural correspondence: the two ladders are indexed differently and nothing transfers between them.

> **The governing modulus does not grow.** The S_n analysis keys on n mod 12 (`aod` §3.3.4). The chiral analysis would add a condition on **c mod 4** — and that condition applies only to unfused matching blocks, so it never touches the odd classes, all of which fuse. At the even classes it is a condition on the block, not on n, and c is free to be chosen ≡ 3 (mod 4). **So the chiral ceiling table is the S_n table, keyed mod 12, with a supply condition attached to the two F = 1 rows.**

---

## 6. Open

1. ~~**Recompute the mod-24 ceiling table with ε.**~~ **Largely resolved in §5, and in the favourable direction.** Every odd row fuses, so ε = 1 there and the six mod-12 ceilings carry over unscaled; the F = 4 shape is available at odd n after all, rule (F1) not being the applicable rule. What remains is narrow: confirm the two **F = 1** rows (even n) against the supply of c ≡ 3 (mod 4) blocks near their balance point, which is a Bateman–Horn question of the same kind as §3.6's and not a new obstruction.
2. **Redo Hypothesis (H) with the parity conditions.** Less is needed than it appeared. At odd n — every fused row — **no parity condition on c is added at all**, so (H) transfers verbatim. Only the even, unfused rows want **c ≡ 3 (mod 4)**, a positive-density condition thinning supply by a constant factor and landing in the same Bateman–Horn class. **Gotcha for anyone redoing this: do not impose c ≡ 3 (mod 4) globally.** It is unnecessary at every odd class, and imposing it there would halve the supply for nothing — the same error in miniature as requiring a congruence on c in the S_n analysis (`aod` §3.5.3).
3. **Verify the halving theorem is tight, and §5's claim that it is rarely paid.** Theorem 1 gives δ_chi ≥ δ/2 and Theorem 2 realises the factor exactly at prime powers ≡ 1 (mod 4); §5 argues it is paid **nowhere else** among the ceiling-setting configurations. A chiral analogue of `mu_enumerate_v3.py` — the same enumeration with a sign check per generator, using (F2) rather than (F1) for fused classes — would test that over the computed range, and the prediction is sharp: **δ_chi(n) = δ(n) at every odd non-prime-power n**. **The cheapest substantial item here**, since the enumerator already carries the layer data the parity rules need.
4. **The chiral floor conjecture.** δ ≥ 1/25 becomes δ_chi ≥ 1/50 by Theorem 1, but §5 suggests the truth is δ_chi ≥ 1/25 unchanged; the ladder of `ladder_verify.py` would need the same sign check per family to confirm it, and by (F2) the fused rungs should pass unaltered.
5. **R10** (`pending-checks.md`): the Mayer–Vietoris computation of the chiral halves' homology at n = 9, which is the question of whether a chiral candidate can be ℤ-acyclic.

# Chiral graph properties: the framework under A_n rather than S_n

*Companion to `enumeration-proof.md` and `arithmetic-of-density.md`. Those develop μ(n) for monotone **S_n**-invariant properties of E(K_n) — graph properties. This one ports the whole apparatus to monotone **A_n**-invariant properties, and works out what each construction costs when every group in it has to consist of even permutations.*

**Status.**

| section | standing |
|---|---|
| §1 the definition and why it is the right object | definitional |
| §2 the halving theorem | **proved**, one line |
| §3 the parity calculus | **proved**; each rule verified computationally |
| §4 prime powers: KSS survives at 3 mod 4 and fails at 1 mod 4 | **proved**, and verified at every odd prime ≤ 31 and at c = 4, 8, 16 |
| §5 the chirality efficiency, and the ported cap formula | **derived** |
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

**So the whole framework transfers with a constant, and Θ(n²) is untouched.** In particular the asymptotic constant 7 − 4√3 becomes at worst (7 − 4√3)/2 ≈ 0.0359, and §5 of `arithmetic-of-density.md`'s conjectural floor 1/25 becomes at worst **1/50**.

> **When the factor is actually paid.** A Γ-orbital containing the pair {x, y} splits under Γ⁺ **iff every element of Γ stabilising {x, y} setwise is even**. If some odd element fixes the pair, the orbital survives whole. So the loss is not automatic, and §4 identifies exactly where it bites.

---

## 3. The parity calculus

Everything reduces to the sign of the three generator types the framework uses, on a block of size c = p^a. All three are elementary and all three are verified below.

> **(T) Translations.** x ↦ x + s on 𝔽_c is a product of c/p cycles of length p, so its sign is (−1)^{(p−1)c/p}. Hence **translations are even iff p is odd, or p = 2 and 4 | c.**
>
> **(M) The multiplicative twist.** x ↦ ux with u of order d fixes 0 and acts on 𝔽_c^× as (c−1)/d cycles of length d, so its sign is (−1)^{(d−1)(c−1)/d}. Hence **the twist is even iff d is odd, or (c−1)/d is even.**
>
> **(F) The block permutation.** A diagonal F-cycle on F blocks of size c is a product of c cycles of length F, sign (−1)^{(F−1)c}. Hence **it is even iff F is odd, or c is even.**

**A blanket consequence worth having first: any group of odd order is inside A_n**, since an element of odd order is a product of odd-length cycles. So every parity constraint below concerns 2-parts only — of the twist, of the block count, and of the characteristic.

*Verified.* (M) at every odd prime c ≤ 31 for d = c − 1 and d = (c−1)/2; (T) and (M) at c = 4, 8, 16 in characteristic 2.

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

> **And it predicts where the interesting examples live.** n = 5 is the smallest prime power ≡ 1 (mod 4), and it is precisely where the chiral analysis found a candidate: the down-closure of one A₅-orbit of Hamiltonian cycles is ℚ-acyclic with H̃₁ = ℤ/2, homotopy equivalent to ℝP² (see `pending-checks.md` R10). The next members are n = 9, 13, 17, 25, 29. **The residues 1 mod 4 are the chiral world's analogue of the non-prime-power n in the S_n world**, and for the same structural reason: they are where the natural group falls one orbital short.

---

## 5. The chirality efficiency, and how the cap formula ports

Define, for a block of size c, the **chirality efficiency**

> **ε(c) = 1** if c = 2^a (a ≥ 2) or c ≡ 3 (mod 4);  **ε(c) = 1/2** if c ≡ 1 (mod 4),

so that the largest A_c-admissible intra-orbital on the block is ε(c)·C(c,2) rather than C(c,2). Then the framework ports as follows.

**The matching class.** Its intra term becomes F·orb(c, d) with d capped at (c−1)/2 for odd c, i.e. **ε(c)·F·C(c,2)** at full admissible twist. This is a factor ε(c) against the S_n case and nothing else changes.

**The foreign block.** A foreign prime r has translations of odd order r, always even. Its twist is a q-power t, and by (M) it is even iff t is odd — automatic for **q odd** — or (r−1)/t is even. So:

> **an odd top prime q costs nothing**; at **q = 2** the twist is capped at half the 2-part of r − 1, i.e. **the efficiency η is halved on the Fermat branch and nowhere else.**

That is a sharp and slightly surprising localisation: the shifted-prime supply question of `aod` §3.6 is *unchanged* at odd q, and the whole ceiling analysis at η = 1 with odd q goes through verbatim.

**The block permutation.** By (F), an odd fusion count F costs nothing; an even F needs c even. So at odd n, where every part has c odd, **even fusion counts are excluded unless the block permutation is taken with an odd-order generator** — which is exactly the F = F_mid·F_top split of `enumeration-proof.md` G.2 seen through a parity lens, with the 2-part of F now constrained rather than free. **The F = 4 shape that sets four of the seven mod-24 ceilings is the one most exposed here**, and checking it is item 1 of §6.

**The cap formula itself is unchanged.** cap_F(η) = η/(1 + √(Fη))² is an optimisation over sizes and is indifferent to which subgroup realises the terms; what changes is the *inputs*, each term acquiring its ε or halved η. So the ported ceiling is

> **cap_F(η; ε) = ε·η / (√ε + √(Fη))²**  — the same balance argument with the matching term scaled by ε,

reducing to cap_F(η) at ε = 1 (checked). **So the seven mod-24 ceilings survive in form**, each scaled by a factor determined by the residues of the block sizes mod 4.
>
> **The scaling is milder than the halving theorem's worst case, and that is not an accident.** Setting ε = 1/2 costs a factor of about **0.65–0.69** rather than 0.5, because ε enters both the numerator and the balance point: a less efficient matching block is compensated by giving it a larger share of n. Worked at the four ceiling-setting rows: 1/4 → 0.1716 (×0.686), 3 − 2√2 → 1/9 (×0.648), 7 − 4√3 → 0.0481 (×0.670), 1/8 → 0.0858 (×0.686). So the **global constant lands near 0.048 rather than 0.0359**, and the chiral floor conjecture is correspondingly nearer δ_chi ≥ 1/35 than 1/50 — though Theorem 1's 1/50 is what is *proved*, and the above is what the ceiling analysis suggests.
>
> Two of those values are worth noticing: cap₁(1; ½) = 3 − 2√2 and cap₂(1; ½) = 1/9 are **exactly the S_n ceilings one rung down**. The ε = ½ penalty is not a new constant but a shift along the existing ladder, which is what one would expect if halving the twist behaves like halving the efficiency.

> **The governing modulus grows from 24 to 48.** The S_n analysis keys on n mod 24 because η depends on n mod 8 (the 2-adic condition) and n mod 3 (the ℓ = 3 obstruction). The chiral analysis adds a condition on **c mod 4**, and since c is tied to n through n = F·c + r, the combined bookkeeping needs n mod 8 refined by the parity of F — which is mod 48 in the worst case. **Recomputing the ceiling table under that refinement is the main piece of work this document does not do.**

---

## 6. Open

1. **Recompute the mod-24 ceiling table with ε.** Each of the seven ceilings needs its ε factor determined from the block sizes its optimum uses, and the four F = 4 rows need the parity constraint on the block permutation checked — those are the rows where an even fusion count meets odd blocks, which §3 rule (F) forbids outright. It is possible that the F = 4 shape is simply unavailable at odd n in the chiral world, in which case those four residues fall back to the F = 2 rung and the ceiling table changes shape rather than merely scaling.
2. **Redo Hypothesis (H) with the parity conditions.** The parametric Hardy–Littlewood input becomes more restrictive: on top of the existing congruence conditions, the matching block wants **c ≡ 3 (mod 4)** to avoid the ε = 1/2 penalty. That is a positive-density condition, so the supply is thinned by a constant factor and not worse — the reduction still lands in the same Bateman–Horn class, which is why **Θ(n²) survives with a smaller δ** exactly as expected.
3. **Verify the halving theorem is tight.** Theorem 1 gives δ_chi ≥ δ/2 and Theorem 2 realises the factor exactly at prime powers ≡ 1 (mod 4). Whether any n has δ_chi strictly between δ/2 and δ is not known, and a chiral analogue of `mu_enumerate_v2.py` — the same enumeration with a sign check on each generator — would answer it over the computed range. **That is the cheapest substantial item here**, since the enumerator already carries the layer data the parity rules need.
4. **The chiral floor conjecture.** δ ≥ 1/25 becomes δ_chi ≥ 1/50 by Theorem 1, but the computed floor may be far above that; the ladder of `ladder_verify.py` would need the same sign check per family.
5. **R10** (`pending-checks.md`): the Mayer–Vietoris computation of the chiral halves' homology at n = 9, which is the question of whether a chiral candidate can be ℤ-acyclic.

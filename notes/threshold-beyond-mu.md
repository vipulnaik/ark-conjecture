# Numerical projections of the ladder, and μ\*_χ: the Oliver-χ rung reaches past μ\*

*A finding of 2026-11-10, one sitting, not yet read by a second reader. Nothing here changes μ\*(n), B(n), the table or the classification. Scripts: `cyclic_chi_values.py`, `threshold_scan.py`. Notation: every new quantity carries the star of μ\*, marking a max–min or min–max.*

## 1. Projecting a rung to a number

For a nontrivial monotone graph property P on n vertices write **s(P)** for the largest number of edges of a member. For a rung R of the ladder of `orbital-evasiveness-notes.md` §7.2, its **numerical projection** is

> **M\*_R(n) = min { s(P) : P nontrivial, P satisfies R }**, and ∞ if no nontrivial P satisfies R.

Every property with s(P) < M\*_R(n) fails R; if R is implied by non-evasiveness it is evasive. An implication R ⇒ R′ between rungs projects to M\*_R ≥ M\*_R′. Two projections are already in the notes under other names, and one more is immediate.

| rung R | M\*_R(n) | standing |
|---|---|---|
| vertex-transitive Oliver-resistant | **n(q(n) − 1)/2**, q(n) the largest prime-power divisor of n | exact and unconditional — §7.2 fact 8, which calls it "the exact threshold" |
| Oliver-resistant | **μ\*(n)** | exact; Θ(n²) under the bounded-cofactor hypothesis, with the six mod-12 ceilings |
| bi-resistant (§7.13) | **μ\*(n)** again, at every non-prime-power n | below |
| nontrivial-top Oliver-χ-resistant; Oliver-χ-resistant | ≥ **μ\*_χ(n)** (§2) ≥ the bound of §3; **9 at n = 6**; ∞ at prime powers | this note; otherwise open |
| non-evasive | ∞ at every n, if ARK holds | — |

*Why the first two are projections.* Resistance is monotone in P (fact 1), so the threshold property T_B = "at most B edges" is resistant as soon as B reaches the smallest orbital of each group in the class. Hence M\* is the largest, over the groups of the class, of the smallest orbital: a max–min over groups equal to a min–max over properties. For all Oliver groups that is μ\*(n); for the vertex-transitive ones fact 8 evaluates it. The implication Oliver-resistant ⇒ vertex-transitive Oliver-resistant projects to **μ\*(n) ≥ n(q(n) − 1)/2**, which is the unconditional n log n bound of the rewrite plan.

*Bi-resistance projects to the same number.* The dual of T_B is T_{C(n,2)−B−1}, so T_B is bi-resistant exactly when μ\*(n) ≤ B ≤ C(n,2) − 1 − μ\*(n) — at n = 10 the window 20 ≤ B ≤ 24, which is the window §7.7 and §7.13 measured. The projection, being one-sided, cannot tell bi-resistance from resistance.

*A threshold property is never global-χ-resistant.* With N = C(n,2), χ(Δ_{T_B}) = Σ_{j=1}^{B} (−1)^{j−1} C(N, j) = 1 − (−1)^B·C(N − 1, B), which is not 1 for any B < N. So the witness that makes the resistance projections a clean max–min fails every χ rung, at every n, at the trivial group. At the χ rungs the minimising property is never a threshold, and the max–min and the min–max come apart.

## 2. Two invariants at the χ rung

**Per group.** For an Oliver group Γ let

> **m\*_χ(Γ) = min { s(P) : P nontrivial, P is Γ-χ-resistant }**,

the least budget at which some property passes Γ's own condition. It depends only on Γ's orbitals, their sizes, and which unions of orbitals are isomorphic to or embed in which — more than the sizes m\*(Γ) uses, but still data of the group. Always m\*_χ(Γ) ≥ m\*(Γ), since χ-resistance implies resistance.

**Max–min.** **μ\*_χ(n) = max over Oliver Γ ≤ S_n of m\*_χ(Γ)**. This is the analogue of μ\*(n) = max m\*(Γ): a property with s(P) < μ\*_χ(n) fails one specific group.

**Min–max.** M\*_OCR(n), where a single property must pass every group. M\*_OCR(n) ≥ μ\*_χ(n), and nothing forces equality: χ-resistance is not monotone in P, so passing groups one at a time does not assemble.

**Three structural remarks.**

- *Only trivial-top groups are needed.* If H is the core of Γ, a property passing H passes Γ (fact 5), so m\*_χ(H) ≥ m\*_χ(Γ). Hence μ\*_χ(n) is attained on p-by-cyclic groups, with the exact condition χ = 1 and no prime q in the definition. The same fact gives M\*_OCR for the trivial-top class alone.
- *Maximal groups are not enough.* For resistance they are (fact 2), which is why μ\* is governed by groups with few, large orbitals. χ-resistance does not pass to subgroups (fact 3), so m\*_χ can be larger on a smaller group, and the maximum defining μ\*_χ ranges over groups the enumeration proof rightly discards for μ\*.
- *Where each is infinite.* At a prime power both are ∞ (AGL(1, n) passes nothing). At other n, μ\*_χ(n) is finite. M\*_OCR(n) = ∞ says exactly that the Oliver conditions alone prove ARK at n — false at n = 6, the first non-prime-power, and what the n = 10 search of §7.9 is deciding.

**At n = 6.** μ\*(6) = 6. The two Oliver-χ-resistant properties of §7.9 have s = 9 (largest member K₃,₃) and s = 12, and they are the only ones, so **M\*_OCR(6) = 9**. *(At n = 10 the property the search currently holds, which passes every class with t ≤ 11 and part of t = 12, has s = 30; it was not minimised, so this bounds nothing.)*

## 3. A lower bound on m\*_χ(Γ): foreign blocks at full capacity

> **Proposition.** Let Γ ≤ S_n be an Oliver group with top prime q (or trivial top), one of whose orbits is a block of prime size r on which Γ induces ℤ/r ⋊ C_t. Let k = C(r,2)/orb(r, t) be the number of pair-orbitals inside the block, and suppose that **no C_k-invariant simplicial complex on k points, other than the full simplex, has Euler characteristic ≡ 1 (mod q)** (= 1, if the top is trivial). Let M be the smaller of C(r,2) and the least orbital of Γ outside the block's own pairs. Then **m\*_χ(Γ) ≥ M**: no nontrivial monotone graph property with s(P) < M is Γ-χ-resistant.

*Proof.* Let s(P) < M. Every orbital outside the block has at least M edges, so no invariant graph in P contains one: the faces of Δ_P^Γ are sets of the block's own k orbitals whose union lies in P. Those orbitals are the circulants Cay(ℤ/r, ±aH), H the twist subgroup, and the multiplier x ↦ gx on the block — extended by the identity elsewhere — is a permutation of [n] that cycles them. P is invariant under every permutation of [n], so Δ_P^Γ is invariant under that cycle: a C_k-invariant complex on k points. It is not the full simplex, because the union of all k orbitals has C(r,2) ≥ M edges. By hypothesis its Euler characteristic is not 1 modulo q. ∎

Since the groups in question have a nontrivial top, the property also fails the *nontrivial-top* rung, so M bounds that projection too.

**Which k qualify** (`cyclic_chi_values.py`; the empty complex, χ = 0, included):

| k | complexes | values of χ | q for which some χ ≡ 1 (mod q) |
|---|---|---|---|
| 2 | 2 | 0, 2 | none |
| 3 | 3 | 0, 3 | 2 |
| 4 | 6 | −2, 0, 2, 4 | 3 |
| 5 | 9 | −5, 0, 5 | 2, 3 |
| 6 | 42 | −9, −7, −6, −4, −3, −1, 0, 2, 3, 5, 6, 8, 9, 11 | 2, 5, 7 |
| 7 | 99 | −14, −7, 0, 7, 14, 21 | 2, 3, 5, 13 |

For k = 8, 9, 10, 11 and 13 a constraint solver finds χ = 1 unattainable; since |χ − 1| ≤ 2^k, every q > 2^k is then safe. **At k = 12 χ = 1 is attainable**, and the Proposition gives nothing there. At a prime power k = ℓ^a the reason is visible — every face orbit has size divisible by ℓ, so χ ≡ 0 (mod ℓ) — while at k = 6 and 10 it is a fact about the orbit census.

So a foreign block with **r − 1 = 2kq^e, k ≤ 11 or k = 13, and q outside a finite set depending on k**, counts as C(r,2) — efficiency 1, whatever the framework's η = 1/k. Write **μ\*_cyc(n)** for the resulting lower bound on μ\*_χ(n): μ\*(n) recomputed with every qualifying foreign block scored at C(r,2).

> μ\*(n) = M\*_OR(n) ≤ μ\*_cyc(n) ≤ μ\*_χ(n) ≤ M\*_OCR(n) ≤ M\*_NE(n).

## 4. Consequences

**For the short note, with its hypothesis unchanged.** (BCG₁/₅) takes d ∈ {2, 4, 6, 12}, that is k = d/2 ∈ {1, 2, 3, 6} with t = q an odd prime. All four qualify once q ∉ {2, 5, 7}, which holds for n ≥ 426. The foreign term r(r − 1)/24 becomes C(r,2), and min{C(c,2), C(r,2), cr} ≥ C(n,2)/26 for n ≥ 105. So under (BCG₁/₅), **μ\*_χ(n) ≥ C(n,2)/26 for all large n**, and every nontrivial monotone property with fewer than C(n,2)/26 edges is evasive — thirteen times the note's 1/350. The note's statement μ\*(n) = Θ(n²) is unaffected; what improves is the evasiveness corollary, and it now passes through the χ rung and not the resistance rung.

**Ceilings.** With every qualifying foreign block at efficiency 1 only the parity of n enters. Both columns are cap_F(η) = η/(1 + √(Fη))²; the μ\* column takes the η = 2/d the class allows (`arithmetic-of-density.md` §3.3.5), the other takes η = 1.

| n mod 12 | μ\*(n)/C(n,2) ceiling | attained by | μ\*_cyc(n)/C(n,2) ceiling — a **lower bound** for μ\*_χ | attained by |
|---|---|---|---|---|
| 0, 4, 6, 10 | 1/4 = 0.2500 | F = 1, η = 1 | 1/4 = 0.2500 | the same shape (d = 2) |
| 2, 8 | (2 − √3)/2 = 0.1340 | F = 1, η = 1/3 | **1/4 = 0.2500** | F = 1, d = 6 (k = 3) |
| 1, 9 | 3 − 2√2 = 0.1716 | F = 2, η = 1 | 3 − 2√2 = 0.1716 | the same shape (d = 2) |
| 3, 7 | 1/8 = 0.1250 | F = 2, η = 1/2 | **3 − 2√2 = 0.1716** | F = 2, d = 4 (k = 2) |
| 5 | 5 − 2√6 = 0.1010 | F = 2, η = 1/3 | **3 − 2√2 = 0.1716** | F = 2, d = 6 (k = 3) |
| 11 | 7 − 4√3 = 0.0718 | F = 4, η = 1/3 | **3 − 2√2 = 0.1716** | F = 2, d = 12 (k = 6) |

The right-hand column is 1/(1 + 1)² at even n and 1/(1 + √2)² at odd n; the worst class moves from 0.0718 to 0.1716. *Standing:* the μ\* column is the asymptotic value of μ\*, given the enumeration proof and the hypothesis. The right-hand column is the asymptotic value of μ\*_cyc and only a lower bound for μ\*_χ — there is no classification behind it (§6). It is arithmetic on the cap formula, spot-checked on n from 9,000 to 12,000, where the best one-foreign value in classes 2, 7 and 8 is 0.2495, 0.1715 and 0.2497, and classes 5 and 11 reach 0.207 and 0.198 at special n. The k = 6 row needs q ∉ {2, 5, 7} and the k = 3 rows q ≠ 2, automatic for large n.

**On the table, to n = 4000** (`threshold_scan.py`, shapes n = Fc + r and n = Fc only). Under the old scoring this enumerator reproduces μ\* at all 3,410 rows. With qualifying foreign blocks at C(r,2): 1,847 rows improve; the floor rises from 0.0462 at n = 2759 to **0.0887 at n = 1159**; n = 2759 itself goes to 0.1568 (2 × 773 + 1213, 1212 = 12·101, k = 6, q = 101). At n = 1159 the binding orbital is the fused class 4·C(173,2), which the device does not touch.

## 5. How this sits in §7

- **It is §7.3's direction (b).** Oliver's theorem is tight at a fixed group over all acyclic complexes: every value in 1 + n_G·ℤ occurs. §7.3 names "the restriction to Δ_P complexes" as the least explored place left to look, since Δ_P comes from an S_n-invariant family and the tightness says nothing about that subclass. The Proposition is an instance: for sparse graph properties the realisable values of χ(Δ_P^Γ) lie in the finite set of the k-table, which misses 1 + qℤ. m\*_χ(Γ) is the least budget at which the realisable set first meets Oliver's.
- **It extends §9.7's "isomorphic orbitals".** That passage has the symmetry N\*, the all-or-none consequence, the count t_eff, and evasiveness for budgets up to m₁ + m₂. What is added is that a whole type is neutralised up to its total size, and the constants that follow.
- **It is the χ-level, k-cycle form of §7.13's loop.** There: if an Oliver subgroup H has exactly two orbits that the ambient group swaps, the fixed complex is two points or empty and every invariant function is evasive. That is k = 2 with the swap in place of the multiplier. The pentagon and pentagram under A₅ are the same mechanism failing because the identifying permutation is not in the ambient group. For graph properties the ambient group is S_n, so every multiplier is available — which is why the device is so effective here.
- **Chiral properties.** A multiplier of full order on a block of size r is an (r − 1)-cycle, an odd permutation. It can be corrected by any odd permutation inside Γ, which fixes every orbital; the note's groups contain one (the generator of C_{c−1} on a matching block). So the Proposition should hold for A_n-invariant properties wherever Γ contains an odd permutation. *Argued, not checked.*
- **It fills the partial-index row of §7.9.** The per-shape conditions listed there are for full foreign index, and at those shapes m\*_χ(Γ) = m\*(Γ): the pattern "the smallest orbital alone" passes — {K_a} at S3, F·K_c at S2. A gain needs the smallest type to be repeated, which is the partial-index case.
- **The search of §7.9 is M\*_OCR with no objective.** The CSP's models are the properties passing the battery; minimising s over them would compute the battery's projection, a lower bound on M\*_OCR(10), and μ\*_χ restricted to the battery is the largest single-group optimum.

## 6. What is open, and what is owed

- **Is the right-hand column the asymptotic value of μ\*_χ?** Unknown. An upper bound needs a cap on totals of isomorphism types in place of the flat cap on orbitals, and the obvious candidate — m\*_χ(Γ) is at most the smallest type total, by taking the property generated by that type's full union — fails as stated, because other orbitals can embed in that union and change χ (K_c embeds in K_r when c ≤ r). The guess is that 1/4 and 3 − 2√2 are right for generic n.
- **How far apart are μ\*_χ(n) and M\*_OCR(n)?** At n = 6, M\*_OCR = 9 against μ\* = 6; μ\*_χ(6) has not been computed. It is a finite computation at any n where the Oliver groups are listed.
- **The same device elsewhere:** on the intra classes of a partial-twist matching block; on the cross distance classes of a fused class, of one type per divisor class by §9.7; on unfused isomorphic blocks, where the symmetry is all of S_F and the invariant complexes are skeleta of a simplex, never of Euler characteristic 1; at k ≥ 12 for budgets too small for the bad complexes to fit.
- **Owed:** a second reading of the Proposition and of `cyclic_chi_values.py`; the device inside the exact enumerator, for μ\*_cyc over [6, 10⁶]; the right-hand column rescanned class by class. `pending-checks.md` A49.

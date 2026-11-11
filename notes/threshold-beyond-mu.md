# Numerical projections of the ladder, and μ\*_χ: the Oliver-χ rung reaches past μ\*

*A finding of 2026-11-10, one sitting, not yet read by a second reader. Nothing here changes μ\*(n), B(n), the table or the classification. Scripts: `cyclic_chi_values.py`, `threshold_scan.py`, `cyc_certify.py`, `entangled_check.g`, `type_levels6.py`, `biclique_boost_scan.py`, `nstar_types.py`, `pgroup_levels.py`, `global_chi_min.py`, `global_chi_forced.py`, `verify_global_chi.py`. **This file is a staging area:** the finding is to be refined here before any of it is carried into the framework documents, and the short note is not to be changed on its account (decided 2026-11-10). Notation: every new quantity carries the star of μ\*, marking a max–min or min–max.*

## 1. Projecting a rung to a number

For a monotone graph property P on n vertices write **e_max(P)** for the largest number of edges of a member. *(Not the s(n) of §9.7, the biclique location, which §6 uses in its own sense.)* Properties are as in §7.1: monotone decreasing with ∅ ∈ P, so the empty property is excluded by definition and the trivial property (K_n ∈ P, s = C(n,2)) is included. For a rung R of the ladder of `orbital-evasiveness-notes.md` §7.2, its **numerical projection** is

> **M\*_R(n) = min { e_max(P) : P satisfies R }**.

The trivial property satisfies every rung, so **M\*_R(n) ≤ C(n,2)** always, with equality exactly when the ladder has collapsed at R: no nontrivial property reaches it. ARK at n is M\*_NE(n) = C(n,2). At a prime power every projection is C(n,2), μ\* included.

Every property with e_max(P) < M\*_R(n) fails R; if R is implied by non-evasiveness it is evasive. An implication R ⇒ R′ between rungs projects to M\*_R ≥ M\*_R′. Two projections are already in the notes under other names, and one more is immediate.

| rung R | M\*_R(n) | standing |
|---|---|---|
| vertex-transitive Oliver-resistant | **n(q(n) − 1)/2**, q(n) the largest prime-power divisor of n | exact and unconditional — §7.2 fact 8, which calls it "the exact threshold" |
| Oliver-resistant | **μ\*(n)** | exact; Θ(n²) under the bounded-cofactor hypothesis, with the six mod-12 ceilings |
| bi-resistant (§7.13) | **μ\*(n)** again, at every non-prime-power n | below |
| nontrivial-top Oliver-χ-resistant; Oliver-χ-resistant | ≥ **μ\*_χ(n)** (§2) ≥ the bound of §4; **9 at n = 6**; C(n,2) at prime powers | this note; otherwise open |
| χ(Δ_P) = 1, the trivial group's condition | **G\*(n)**: 6, 20, 11, 42, 18 at n = 6, 10, 12, 14, 18 | §7; not comparable with the rungs above it in this table |
| non-evasive | C(n,2) at every n, if ARK holds | — |

*Why the first two are projections.* Resistance is monotone in P (fact 1), so the threshold property T_B = "at most B edges" is resistant as soon as B reaches the smallest orbital of each group in the class. Hence M\* is the largest, over the groups of the class, of the smallest orbital: a max–min over groups equal to a min–max over properties. For all Oliver groups that is μ\*(n); for the vertex-transitive ones fact 8 evaluates it. The implication Oliver-resistant ⇒ vertex-transitive Oliver-resistant projects to **μ\*(n) ≥ n(q(n) − 1)/2**, which is the unconditional n log n bound of the rewrite plan.

*Bi-resistance projects to the same number.* The dual of T_B is T_{C(n,2)−B−1}, so T_B is bi-resistant exactly when μ\*(n) ≤ B ≤ C(n,2) − 1 − μ\*(n) — at n = 10 the window 20 ≤ B ≤ 24, which is the window §7.7 and §7.13 measured. The projection, being one-sided, cannot tell bi-resistance from resistance.

*A threshold property is never global-χ-resistant.* With N = C(n,2), χ(Δ_{T_B}) = Σ_{j=1}^{B} (−1)^{j−1} C(N, j) = 1 − (−1)^B·C(N − 1, B), which is not 1 for any B < N. So the witness that makes the resistance projections a clean max–min fails every χ rung, at every n, at the trivial group. At the χ rungs the minimising property is never a threshold, and the max–min and the min–max come apart.

## 2. Two invariants at the χ rung

**Per group.** For an Oliver group Γ let

> **m\*_χ(Γ) = min { e_max(P) : P is Γ-χ-resistant }**,

the least budget at which some property passes Γ's own condition. It depends only on Γ's orbitals, their sizes, and which unions of orbitals are isomorphic to or embed in which — more than the sizes m\*(Γ) uses, but still data of the group. Always m\*_χ(Γ) ≥ m\*(Γ), since χ-resistance implies resistance.

**Max–min.** **μ\*_χ(n) = max over Oliver Γ ≤ S_n of m\*_χ(Γ)**. This is the analogue of μ\*(n) = max m\*(Γ): a property with e_max(P) < μ\*_χ(n) fails one specific group.

**Min–max.** M\*_OCR(n), where a single property must pass every group. M\*_OCR(n) ≥ μ\*_χ(n), and nothing forces equality: χ-resistance is not monotone in P, so passing groups one at a time does not assemble.

**Three structural remarks.**

- *Only trivial-top groups are needed.* If H is the core of Γ, a property passing H passes Γ (fact 5), so m\*_χ(H) ≥ m\*_χ(Γ). Hence μ\*_χ(n) is attained on p-by-cyclic groups, with the exact condition χ = 1 and no prime q in the definition. The same fact gives M\*_OCR for the trivial-top class alone.
- *Maximal groups are not enough.* For resistance they are (fact 2), which is why μ\* is governed by groups with few, large orbitals. χ-resistance does not pass to subgroups (fact 3), so m\*_χ can be larger on a smaller group, and the maximum defining μ\*_χ ranges over groups the enumeration proof rightly discards for μ\*.
- *Where each is C(n,2).* At a prime power both are (AGL(1, n) is passed by the trivial property alone). At other n it is not known whether μ\*_χ(n) can reach C(n,2). M\*_OCR(n) = C(n,2) says exactly that the Oliver conditions alone prove ARK at n — false at n = 6, the first non-prime-power, and what the n = 10 search of §7.9 is deciding.

**At n = 6 the two separate.** μ\*(6) = 6. The two Oliver-χ-resistant properties of §7.9 have e_max = 9 (largest member K₃,₃) and e_max = 12, and they are the only ones, so **M\*_OCR(6) = 9**. Computing m\*_χ(Γ) for each of the 50 Oliver classes (`type_levels6.py`) gives **μ\*_χ(6) = 6**: every group, taken alone, is passed by some property with at most 6 edges, and no property with fewer than 9 passes them all. *(At n = 10 the property the search currently holds, which passes every class with t ≤ 11 and part of t = 12, has e_max = 30; it was not minimised, so this bounds nothing.)*

## 3. Three levels, and what symmetry alone can give

The Proposition of §4 uses one fact about Δ_P^Γ beyond Oliver's congruence. Stated without any particular group: let **N\*(Γ)** be the permutations of [n] that carry every orbital of Γ onto an orbital (`orbital-evasiveness-notes.md` §9.7; it contains Γ and its normaliser, and need not normalise Γ). S_n itself does not act on the orbitals; N\* does. Because P is S_n-invariant, **Δ_P^Γ is an N\*-invariant complex on the set of orbitals.** Call the N\*-orbits of orbitals *types*.

There are three levels of what one may use about the fixed complex, and each gives a per-group quantity.

| level | what is used about Δ_P^Γ | per-group quantity |
|---|---|---|
| 0 | it is not void | m\*(Γ), the smallest orbital |
| 1 | it is N\*-invariant, and meets Γ's χ condition | **m\*_N(Γ)**: the least B at which some N\*-invariant complex on the orbitals, not the full simplex, with every face of total size at most B, meets the condition |
| 2 | which unions of orbitals are isomorphic to, or embed in, which | m\*_χ(Γ) of §2 |

Each level's admissible complexes contain the next level's, so **m\*(Γ) ≤ m\*_N(Γ) ≤ m\*_χ(Γ)**, and with **μ\*_N(n) = max over Γ of m\*_N(Γ)**, μ\*(n) ≤ μ\*_N(n) ≤ μ\*_χ(n). The level-1 quantity depends only on the orbital set, the sizes and the N\*-action.

**What level 1 can give at most: one fusion per type.** Let **m\*_typ(Γ)** be the smallest total size of a type — the smallest orbital one would have if each type were fused into a single orbital. The full simplex on one type is N\*-invariant and has χ = 1, so

> **m\*(Γ) ≤ m\*_N(Γ) ≤ m\*_typ(Γ).**

Symmetry alone never buys more than fusing each type once. *m\*_typ is a ceiling for m\*_N group by group and is not worth maximising over groups: the trivial group has a single type, of total C(n,2).*

**When the fusion is fully paid out, and when it is not.** If the orbitals that fit under the budget form a single type, and no invariant proper complex on that type meets the condition, then nothing passes until a whole type fits: m\*_N(Γ) = m\*_typ(Γ). §4 is this case with a cyclic action on the type. With two or more types under the budget the argument fails in two ways. *Cancellation without mixing*: the values of §4's table at k = 4 and k = 3 include −2 and 3, which sum to 1. *Mixed faces*: one orbital A and a swapped pair P₁, P₂ admit the path P₁–A–P₂, of Euler characteristic 1. It need not fail — two types with k = 2 and no mixed face give χ ∈ {0, 2, 4} — so in general m\*_N is a finite computation on the type structure. And one large type can fail by itself: the invariant complexes on it may include one with χ = 1 (k = 12 in §4).

**Level 2 can exceed the type total.** Embedding relations remove complexes that level 1 admits — the simplex on one type is not available when a smaller orbital embeds in that type's union (K_c inside K_r) — so m\*_χ(Γ) can be larger than m\*_typ(Γ). m\*_typ bounds m\*_N only.

**All of this at n = 6** (`type_levels6.py`, the 50 Oliver classes; feasibility by a constraint solver):

| what happens | groups | example |
|---|---|---|
| all four quantities equal m\* | 34 | every two-orbital group |
| one fusion, fully paid: m\* < m\*_N = m\*_typ | 11 | C₃ × C₃ on 3 + 3: orbitals K₃, K₃, K₃,₃ in two types; m\* = 3 and the other three are 6 |
| level 2 above the type total: m\*_typ < m\*_χ | 6 | an order-4 group with 7 orbitals: m\*_typ = m\*_N = 1, m\*_χ = 3 |
| cancellation inside one type: m\*_N < m\*_typ | 1 | the trivial group: one type of 15 edges, m\*_typ = 15, m\*_N = m\*_χ = 6 |

*(The second and third rows share 2 groups, of orders 3 and 6 with 7 orbitals, where m\* = 1, m\*_N = m\*_typ = 3 and m\*_χ = 6; so 34 + 11 + 6 + 1 − 2 = 50.)* The maxima are μ\*(6) = μ\*_N(6) = μ\*_χ(6) = 6: at this n the fusion gains appear in individual groups but not in the maximum, which the two-orbital group of order 18 already holds.

## 4. The single good type: foreign blocks at full capacity

> **Proposition.** Let Γ ≤ S_n be an Oliver group with top prime q (or trivial top), one of whose orbits is a block of prime size r on which Γ induces ℤ/r ⋊ C_t. Let k = C(r,2)/orb(r, t) be the number of pair-orbitals inside the block, and suppose that **no C_k-invariant simplicial complex on k points, other than the full simplex, has Euler characteristic ≡ 1 (mod q)** (= 1, if the top is trivial). Let M be the smaller of C(r,2) and the least orbital of Γ outside the block's own pairs. Then **m\*_N(Γ) ≥ M**, hence m\*_χ(Γ) ≥ M: no nontrivial monotone graph property with e_max(P) < M is Γ-χ-resistant.

*Proof.* Let e_max(P) < M. Every orbital outside the block has at least M edges, so no invariant graph in P contains one: the faces of Δ_P^Γ are sets of the block's own k orbitals whose union lies in P. Those orbitals are the circulants Cay(ℤ/r, ±aH), H the twist subgroup, and the multiplier x ↦ gx on the block — extended by the identity elsewhere — is a permutation of [n] that cycles them. P is invariant under every permutation of [n], so Δ_P^Γ is invariant under that cycle: a C_k-invariant complex on k points. It is not the full simplex, because the union of all k orbitals has C(r,2) ≥ M edges. By hypothesis its Euler characteristic is not 1 modulo q. ∎

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

So a foreign block with **r − 1 = 2kq^e, k ≤ 11 or k = 13, and q outside a finite set depending on k**, counts as C(r,2) — efficiency 1, whatever the framework's η = 1/k. The proof uses only N\*-invariance, so it is a level-1 statement: the block's own orbitals are one type, and M ≤ m\*_N(Γ). Write **μ\*_cyc(n)** for the resulting lower bound: μ\*(n) recomputed with every qualifying foreign block scored at C(r,2).

> μ\*(n) = M\*_OR(n) ≤ μ\*_cyc(n) ≤ μ\*_N(n) ≤ μ\*_χ(n) ≤ M\*_OCR(n) ≤ M\*_NE(n).

## 5. Consequences

**Under the short note's hypothesis, as a statement about μ\*_χ — not a change to the note.** (BCG₁/₅) takes d ∈ {2, 4, 6, 12}, that is k = d/2 ∈ {1, 2, 3, 6} with t = q an odd prime. All four qualify once q ∉ {2, 5, 7}, which holds for n ≥ 426. The foreign term r(r − 1)/24 becomes C(r,2), and min{C(c,2), C(r,2), cr} ≥ C(n,2)/26 for n ≥ 105. So under (BCG₁/₅), **μ\*_χ(n) ≥ C(n,2)/26 for all large n**, and every nontrivial monotone property with fewer than C(n,2)/26 edges is evasive — thirteen times the note's 1/350. The note is left as it is: its bound is deliberately simple and loose, there only to establish Θ(n²), and sharpening the more complicated half of it is not wanted. The 1/26 is a statement of this file.

**Ceilings.** With every qualifying foreign block at efficiency 1 only the parity of n enters. Both columns are cap_F(η) = η/(1 + √(Fη))²; the μ\* column takes the η = 2/d the class allows (`arithmetic-of-density.md` §3.3.5), the other takes η = 1.

| n mod 12 | μ\*(n)/C(n,2) ceiling | attained by | μ\*_cyc(n)/C(n,2) ceiling — a **lower bound** for μ\*_N and μ\*_χ | attained by |
|---|---|---|---|---|
| 0, 4, 6, 10 | 1/4 = 0.2500 | F = 1, η = 1 | 1/4 = 0.2500 | the same shape (d = 2) |
| 2, 8 | (2 − √3)/2 = 0.1340 | F = 1, η = 1/3 | **1/4 = 0.2500** | F = 1, d = 6 (k = 3) |
| 1, 9 | 3 − 2√2 = 0.1716 | F = 2, η = 1 | 3 − 2√2 = 0.1716 | the same shape (d = 2) |
| 3, 7 | 1/8 = 0.1250 | F = 2, η = 1/2 | **3 − 2√2 = 0.1716** | F = 2, d = 4 (k = 2) |
| 5 | 5 − 2√6 = 0.1010 | F = 2, η = 1/3 | **3 − 2√2 = 0.1716** | F = 2, d = 6 (k = 3) |
| 11 | 7 − 4√3 = 0.0718 | F = 4, η = 1/3 | **3 − 2√2 = 0.1716** | F = 2, d = 12 (k = 6) |

The right-hand column is 1/(1 + 1)² at even n and 1/(1 + √2)² at odd n; the worst class moves from 0.0718 to 0.1716. *Standing:* the μ\* column is the asymptotic value of μ\*, given the enumeration proof and the hypothesis. The right-hand column is the asymptotic value of μ\*_cyc and only a lower bound for μ\*_χ — there is no classification behind it (§9). It is arithmetic on the cap formula, spot-checked on n from 9,000 to 12,000, where the best one-foreign value in classes 2, 7 and 8 is 0.2495, 0.1715 and 0.2497, and classes 5 and 11 reach 0.207 and 0.198 at special n. The k = 6 row needs q ∉ {2, 5, 7} and the k = 3 rows q ≠ 2, automatic for large n.

**On the table, to n = 4000** (`threshold_scan.py`, shapes n = Fc + r and n = Fc only). Under the old scoring this enumerator reproduces μ\* at all 3,410 rows. With qualifying foreign blocks at C(r,2): 1,847 rows improve; the floor rises from 0.0462 at n = 2759 to **0.0887 at n = 1159**; n = 2759 itself goes to 0.1568 (2 × 773 + 1213, 1212 = 12·101, k = 6, q = 101). At n = 1159 the binding orbital is the fused class 4·C(173,2), which the device does not touch. *The first rows where the two part* — none below 56:

| n | C(n,2) | μ\* | μ\*_cyc ≥ | shape | block |
|---|---|---|---|---|---|
| 56 | 1540 | 203 | 351 | 27 + 29 | k = 2, q = 7 |
| 60 | 1770 | 253 | 406 | 31 + 29 | k = 2, q = 7 |
| 63 | 1953 | 252 | 465 | 32 + 31, entangled | k = 3, q = 5 |
| 66 | 2145 | 333 | 406 | 37 + 29 | k = 2, q = 7 |
| 70 | 2415 | 301 | 406 | 41 + 29 | k = 2, q = 7 |
| 72 | 2556 | 301 | 465 | 41 + 31 | k = 3, q = 5 |
| 77 | 2926 | 385 | 465 | 2 × 23 + 31 | k = 3, q = 5 |
| 78 | 3003 | 468 | 666 | 41 + 37 | k = 2, q = 3 |
| 80 | 3160 | 600 | 666 | 43 + 37 | k = 2, q = 3 |
| 84 | 3486 | 666 | 820 | 43 + 41 | k = 4, q = 5 |

At n = 56 the group is the one that realises μ\*: its smallest orbital, one of two classes of 203 on the 29 points, is replaced by the pair at 406, and K₂₇ at 351 becomes binding. *The scan requires gcd(F(c − 1), r) = 1, so that the full twist on the matching blocks and the foreign translations share a cyclic layer — or, at F = 1 with r dividing c − 1, the entangled group: AΓL(1, c) acting on the c points and, through its quotient, on r more, the translation of the r points being the image of the element of order r in the twist. The twist on the r points is then a field automorphism, of order dividing the order of p mod r. To 4000 this occurs once: n = 63 = 32 + 31, where the Frobenius of 𝔽₃₂ acts on ℤ/31 as y ↦ 2y, of order 5, and the orbitals are 496, 992 and three classes of 155 (`entangled_check.g`).*

**Is the scan's value the true μ\*_cyc?** Make the definition exact: μ\*_cyc(n) is the largest M of the Proposition over Oliver groups on [n] and at most one orbit R of prime size r — M = min(C(r,2), least orbital outside R's own pairs) — or the group's smallest orbital when no orbit is used. An upper bound needs no classification. The orbitals inside the complement of R are those of the image group there, which is an Oliver group on m = n − r points, so the least of them is at most μ\*(m); and a cross orbital is at most rm. Hence

> **μ\*_cyc(n) ≤ U(n) = max( μ\*(n), max over primes r of min{ C(r,2), r·m, μ\*(m) } )**, m = n − r,

computable from the μ\* table (`cyc_certify.py`; μ\*(m) = C(m,2) at prime powers). To n = 4000:

- **U(n) = μ\*(n) at 1,341 rows, among them every n ≤ 55.** There the device gains nothing, whatever the group: μ\*_cyc(n) = μ\*(n).
- **The scan's value equals U(n) at 2,385 of the 3,410 rows** — so it is μ\*_cyc(n) exactly there — among them all ten rows of the table above and 1,044 of the 1,847 improved rows.
- At the other 1,025 rows the maximising r cannot qualify as a foreign block. Restricting U to primes r that can — r − 1 with a q-power twist t whose k is good — bounds the *foreign reading*, where R is not of the group's own prime p, and **that bound equals the scan at 3,403 rows**. The seven exceptions, where a complement with its own foreign block may do better than the shapes scanned: 689 (24,753 to 25,651), 1159, 1703, 2597, 2873, 3523, 3959.
- What stays uncertified at those 1,025 rows is a block of the group's own prime carrying a partial twist. The first three, n = 110, 154 and 171 (r = 61, 73, 73; U = 1176, 2628, 2352), close by hand, so μ\*_cyc is 903, 2485 and 2016 there. The complement group is cyclic-by-q, and the bound to beat leaves it at most one orbital on 49 or 81 points, or at most two on 98. A cyclic-by-q group is 2-homogeneous only in prime degree: its normal cyclic subgroup must meet the socle trivially, hence centralise it, hence be trivial. On 98 points the normal cyclic subgroup has orbits of size 49 or 98, and the pairs inside an orbit at a difference of order 7 (or 2) form an invariant set of at most 294. *By hand, one reading; not automated for the rest.*

**Nothing more comes from the witnessing group.** At n = 56 the property "embeds in K₂₇" has e_max = 351 and passes the group: its fixed complex is the single orbital K₂₇, since a class of 203 spans 29 vertices. At n = 63 "embeds in K₃₁" has e_max = 465 and its fixed complex is the full simplex on the three classes. So m\*_χ equals the certified value at these groups, and any excess of μ\*_χ over μ\*_cyc has to come from other groups.

## 6. A required-subgraph projection: bicliques

*Added 2026-11-10 (late), same sitting; a question of Vipul's.* §1 projects a rung to a number. A rung also projects to a family of graphs: call H **R-required at n** if every nontrivial monotone property satisfying R has H as a member. Every non-evasive property then contains every required graph of every rung below non-evasiveness. For Oliver-resistance this is `orbital-evasiveness-notes.md` §9.7's biclique box: H is required exactly when some Oliver group has H inside every orbital, and for H = K_{a,b} in the linear regime the answer is the triangle a + b ≤ s(n), with s(n) the largest smallest-block over groups whose minimal blocks are all 2-homogeneous. Groups with a pseudorandom foreign block are discarded there, since no single cyclotomic class holds a linear biclique.

The device of §4 takes them back.

> **Proposition (biclique form).** Let n = F·c + r with Γ of the constructed shape: matching blocks of size c with full twist, one foreign block of prime size r under top prime q, with k cyclotomic pair-orbitals. Suppose no C_k-invariant proper complex on k points has χ ≡ 1 (mod q) — the condition of §4. Then every nontrivial monotone property that omits some K_{a,b} with a + b ≤ min(c, r) is evasive.

*Proof.* Let P omit K_{a,b}. The orbitals outside the foreign block are F·K_c, unions of K_{c,c} over block pairs, and K_{Fc,r}; each contains K_{a,b}, so none lies in P, and no face of Δ_P^Γ uses one. The union of all k foreign classes is K_r, which contains K_{a,b}, so the full simplex on the k classes is not a face. Δ_P^Γ is therefore a proper complex on the k classes, invariant under the multiplier that cycles them (§9.7), and by hypothesis its χ is not ≡ 1 (mod q). ∎

Nothing is asked of the individual classes, and the hypothesis on P is membership of one graph, not an edge count: the property may be dense. The same proof gives every bipartite graph on at most min(c, r) vertices, as a subgraph of such a biclique.

Write **s\*_N(n)** for the largest smallest-block over groups each of whose minimal blocks is 2-homogeneous or carries a good type. Then s(n) ≤ s\*_N(n), and a non-evasive property contains K_{a,b} whenever a + b ≤ s\*_N(n). *This is a sufficient region only.* The triangle of §9.7 is exact for the non-void argument; no upper bound for what the χ rung requires is claimed here.

**Smallest instance, built.** n = 21 = 8 + 13 with q = 3 is the first n at which a qualifying block improves on s(n). The orbitals are K₈ (28 pairs), K₈,₁₃ (104) and two classes of 39 on the 13 points, each 6-regular. k = 2, where the only proper invariant complexes are empty or two points. So a non-evasive property on 21 vertices contains K_{a,b} for a + b ≤ 8, against s(21) = 7 from 3 × 7.

**Predicted limits.** The fusion count needed is the one in §5's right-hand column, so only parity enters: with c ≈ r ≈ n/(F + 1),

| n mod 12 | 0, 4, 6, 10 | 2, 8 | 1, 9 | 3, 7 | 5 | 11 |
|---|---|---|---|---|---|---|
| s(n)/n → | 1/2 | 1/4 | 1/3 | 1/5 | 1/7 | 1/13 |
| lower bound for s\*_N(n)/n → | 1/2 | **1/2** | 1/3 | **1/3** | **1/3** | **1/3** |

At the balanced point a = b the constant moves from 1/26 to 1/6 at the worst class. *Standing:* the top row is §9.7's, conditional on supply as stated there; the bottom row is the same arithmetic with qualifying blocks admitted, conditional on the same kind of supply, and a lower bound.

**On the table, to n = 10⁴** (`biclique_boost_scan.py`; new groups from the shape n = Fc + r only, so the boosted figures are lower bounds for s\*_N). 5,627 of 9,995 values of n improve. The smallest ratio s/n is 0.0702 on [6, 1000] (at 527) and 0.0678 on [1000, 10⁴] (at 6887); boosted, the smallest ratios are 0.2387 (at 155 = 2 × 59 + 37) and 0.2073 (at 1703 = 2 × 353 + 997). The floor case 2759 goes from 271 to 881 (2 × 881 + 997, k = 6, q = 83). Medians over [5000, 10⁴] by class:

| n mod 12 | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| s/n | 0.490 | 0.331 | 0.250 | 0.198 | 0.490 | 0.213 | 0.490 | 0.200 | 0.246 | 0.330 | 0.496 | 0.195 |
| boosted | 0.497 | 0.332 | 0.497 | 0.332 | 0.495 | 0.331 | 0.496 | 0.330 | 0.490 | 0.332 | 0.498 | 0.330 |

The boosted medians sit at the predicted 1/2 and 1/3. The minima do not yet: class 11 has minimum 0.232 on that range, since supply rarely hits c = r. The admitted block has k = 2 through 8 at the improved rows (k = 3 most often, at 1,782; k = 8 at 29, which rest on the crude rule q > 2^k). Two rows come from entangled groups (§5): n = 63, from 17 to 31, and n = 15 = 8 + 7, from 5 to 7. At n = 15 the block has k = 1 — AΓL(1, 8) on 8 + 7 points has orbitals K₇, K₈ and K₈,₇ — so the group is structured in §9.7's own sense and s(15) ≥ 7: `biclique_table.py` does not enumerate entangled groups.

## 7. Where the N level is decided: types, and the trivial group

**N\* is a normaliser.** Let Γ̂ be the group of all permutations fixing every orbital of Γ. It has the same orbitals as Γ, it is the kernel of N\*(Γ) acting on the orbitals, and N\*(Γ) = N_{S_n}(Γ̂). A type's total is the size of an orbit of N\*(Γ) on pairs, so **m\*_typ(Γ) is the smallest pair-orbit of N\*(Γ)**.

**Only the trivial group has a single type**, at every non-prime-power n. If N\*(Γ) is transitive on pairs it is 2-transitive and almost simple, and Γ̂ ≠ 1 is a normal subgroup, so it contains the socle. The socle is transitive on pairs (the one exception, PSL(2,8) on 28 points, has three pair-orbits of 126 and no soluble subgroup with the same orbits), so Γ has a single orbital, and an Oliver group with one orbital lives in prime-power degree.

Two numbers therefore carry the N level:

- **ν\*(n) = the largest m\*_typ(Γ) over nontrivial Oliver Γ** — the maximum that §3 declined to take over all groups, taken where it means something;
- **G\*(n) = m\*_N(1) = m\*_χ(1) = the least e_max(P) with χ(Δ_P) = 1.** For the trivial group the orbitals are the edges, N\* = S_n, and the invariant complexes are exactly the graph properties. G\* is the numerical projection, in the sense of §1, of the rung χ(Δ_P) = 1.

> **max( μ\*_cyc(n), G\*(n) ) ≤ μ\*_N(n) ≤ max( ν\*(n), G\*(n) )**, and **ν\*(n) ≤ (n/2)·⌊(n − 1)/2⌋**.

*The bound on ν\*.* N\*(Γ) has at least two orbits on pairs. If it is transitive on points they are regular graphs whose valencies sum to n − 1, so the smallest has valency at most ⌊(n − 1)/2⌋. If not, some orbit on points has at most n/2 points, and the pairs inside it, or the pairs at a fixed point, are fewer still.

> **Corollary.** For n = 2m with m a prime power, ν\*(n) ≤ m(m − 1) = μ\*(n), so **μ\*_N(n) = max( μ\*(n), G\*(n) )**: at these n the N level is decided by the trivial group alone.

*Consistent with §5:* μ\*_cyc(n) = μ\*(n) at all 323 such n to 4000.

**What bounds G\* from below.** If χ(Δ_P) = 1 then χ(Δ_P^Q) ≡ 1 (mod p) for every p-subgroup Q (Smith), and Δ_P^Q is N\*(Q)-invariant. So G\*(n) is at least the least budget at which a p-group's congruence can be met at level 1 (`pgroup_levels.py`). At n = 10 the group ℤ/5 on two 5-cycles gives 20: every property with χ = 1 contains 2K₅. At n = 12 the group ℤ/11 gives 11: the star K₁,₁₁. The translations of two blocks of m give m(m − 1) at m = 3, 5, 7 and only 18, 22, 26 at m = 9, 11, 13. There are finer conditions modulo prime powers, from orbit sizes: no property of the form "at most 19 edges, plus some 20-edge graphs" has χ = 1 at n = 10, because no 20-edge graph has 27 dividing its automorphism group, so every orbit of 20-edge graphs has size divisible by 9, while the size required, C(44,19), is not.

**What bounds it from above.** A property found by search (`global_chi_forced.py`): all subgraphs of the graph the p-group forces, together with a family D of graphs of at most E edges, closed under deletion, with Σ ± n!/|Aut| = 1 solved modulo primes. Each property is rechecked by `verify_global_chi.py`: closure, χ recomputed with the classes listed another way, and Smith's congruence at every p-group with few orbitals, which uses membership only. At n = 6 the same pipeline is checked against a brute-force χ over all 2¹⁵ graphs.

| n | μ\*(n) | ν\*(n) | G\*(n) | μ\*_N(n) | how |
|---|---|---|---|---|---|
| 6 | 6 | 6 | 6 | **6** | all 50 classes; G\* by exhaustion (`global_chi_min.py`) |
| 10 | 20 | 20 | 20 | **20** | all 1,294 classes; G\* ≥ 20 from ℤ/5, ≤ 20 by a property: subgraphs of 2K₅ and 2,121 classes of at most 10 edges; Smith checked at 366 p-groups |
| 12 | 18 | 18 | 11 | **18** | all 8,572 classes of S₁₂; G\* ≥ 11 from ℤ/11 and from exhaustion to 10 edges, ≤ 11 by a property: stars and 972 classes of at most 9 edges; Smith checked at 1,919 p-groups |
| 14 | 42 | ≤ 42 | 42 | **42** | Corollary; G\* ≥ 42 from the translations of two blocks of 7, ≤ 42 by a property: subgraphs of 2K₇ and of K₁,₁₃ and 74 classes of at most 12 edges; χ recomputed over 544,727 classes; Smith checked at 44 odd p-groups |
| 18 | 72 | ≤ 72 | 18 | **72** | Corollary; G\* ≥ 18 from the translations of two blocks of 9, ≤ 18 by a property: subgraphs of 6K₃, stars, and 32 classes of at most 7 edges; Smith checked at 284 p-groups (3-groups sampled) |
| 22, 26, 34, 38, 46, 50 | m(m − 1) | ≤ m(m − 1) | not known | max(μ\*, G\*) | Corollary |

So **μ\*_N = μ\* at n = 6, 10, 12, 14 and 18**, and the N level adds nothing there. G\* is below μ\* at 12 and 18 and equal to it at 6, 10, 14: the rung χ = 1 and Oliver-resistance are not comparable, and their projections cross. *The search needs the right forced graph and enough room in D:* at n = 14 with D of at most 10 edges, and at n = 18 with the star alone forced, the congruence modulo 9 has no solution.

**ν\* is not μ\* in general.** At n = 30 take AGL(1, 16) on 16 points, fixing the other 14. Its types are the 91 single edges among the fixed points, K₁₆ (120) and the 14 stars (224), so m\*_typ = 91 > μ\*(30) = 78. But the first type carries all of S₁₄, and the invariant complexes on it are the graph properties on 14 vertices: m\*_N of this group is at most G\*(14). In general **m\*_N(Γ) ≤ G\*(a) when Γ fixes a ≥ 2 points**, so the N level at n feeds on G\* at smaller degrees, and ν\* overstates it.

**At the other n.** For the fifteen remaining n ≤ 50 (15, 20, 21, 24, 28, …), and at the rows where μ\*_cyc leaves μ\*, what is proved is the displayed inequality with the crude bound on ν\*: at n = 56, 351 ≤ μ\*_N ≤ max(756, G\*(56)); at n = 63, 465 ≤ μ\*_N ≤ max(976, G\*(63)). Nothing bounds G\* above at these n except C(n,2).

## 8. How this sits in §7

- **It is §7.3's direction (b).** Oliver's theorem is tight at a fixed group over all acyclic complexes: every value in 1 + n_G·ℤ occurs. §7.3 names "the restriction to Δ_P complexes" as the least explored place left to look, since Δ_P comes from an S_n-invariant family and the tightness says nothing about that subclass. The Proposition is an instance: for sparse graph properties the realisable values of χ(Δ_P^Γ) lie in the finite set of the k-table, which misses 1 + qℤ. m\*_χ(Γ) is the least budget at which the realisable set first meets Oliver's.
- **It extends §9.7's "isomorphic orbitals".** That passage has the symmetry N\*, the all-or-none consequence, the count t_eff, and evasiveness for budgets up to m₁ + m₂. What is added is that a whole type is neutralised up to its total size, and the constants that follow.
- **It is the χ-level, k-cycle form of §7.13's loop.** There: if an Oliver subgroup H has exactly two orbits that the ambient group swaps, the fixed complex is two points or empty and every invariant function is evasive. That is k = 2 with the swap in place of the multiplier. The pentagon and pentagram under A₅ are the same mechanism failing because the identifying permutation is not in the ambient group. For graph properties the ambient group is S_n, so every multiplier is available — which is why the device is so effective here.
- **Chiral properties.** A multiplier of full order on a block of size r is an (r − 1)-cycle, an odd permutation. It can be corrected by any odd permutation inside Γ, which fixes every orbital; the note's groups contain one (the generator of C_{c−1} on a matching block). So the Proposition should hold for A_n-invariant properties wherever Γ contains an odd permutation. *Argued, not checked.*
- **It fills the partial-index row of §7.9.** The per-shape conditions listed there are for full foreign index, and at those shapes m\*_χ(Γ) = m\*(Γ): the pattern "the smallest orbital alone" passes — {K_a} at S3, F·K_c at S2. A gain needs the smallest type to be repeated, which is the partial-index case.
- **The search of §7.9 is M\*_OCR with no objective.** The CSP's models are the properties passing the battery; minimising s over them would compute the battery's projection, a lower bound on M\*_OCR(10), and μ\*_χ restricted to the battery is the largest single-group optimum.

## 9. What is open, and what is owed

- **Is the right-hand column the asymptotic value of μ\*_χ?** Unknown. An upper bound needs a cap on totals of isomorphism types in place of the flat cap on orbitals, and the obvious candidate — m\*_χ(Γ) is at most the smallest type total, by taking the property generated by that type's full union — fails as stated, because other orbitals can embed in that union and change χ (K_c embeds in K_r when c ≤ r). The guess is that 1/4 and 3 − 2√2 are right for generic n.
- **How far apart are μ\*_χ(n) and M\*_OCR(n)?** At n = 6, 6 against 9. At n = 10 neither is known; μ\*_χ(10) is a finite computation of the same kind as `type_levels6.py`, which as written canonicalises graphs by brute force over S_n and would need a real isomorphism routine there.
- **Where does the bounded-cofactor condition now live?** A foreign block with trivial twist has all (r − 1)/2 of its cycle-orbitals in one type, of total C(r,2), with no condition on r − 1 at all; what the condition on r − 1 buys is a twist large enough to leave k small enough to qualify. Which k qualify is the question of whether a cyclically symmetric monotone function on k points can have χ = 1 — the χ-level form of the transitive-group question of §7.5–7.6 and `pending-checks.md` A48.
- **The same device elsewhere:** on the intra classes of a partial-twist matching block; on the cross distance classes of a fused class, of one type per divisor class by §9.7; on unfused isomorphic blocks, where the symmetry is all of S_F and the invariant complexes are skeleta of a simplex, never of Euler characteristic 1; at k ≥ 12 for budgets too small for the bad complexes to fit.
- **A matching upper bound on the biclique side.** §6 gives a sufficient region. Whether a + b ≤ s\*_N(n) is all the χ rung requires, and whether a group with two good types or a good type on a fused class does better, is not examined; nor are required graphs other than bipartite ones.
- **The matching-prime reading of μ\*_cyc** at the 1,022 rows to 4000 where U exceeds the scan and no hand argument has been made; and the seven rows where the foreign reading is open.
- **G\*(n) beyond 18**, and with it μ\*_N at n = 22, 26, 34, 38, 46, 50: a property with χ = 1 and at most m(m − 1) edges, or a proof there is none. The method of §7 should reach 22 and 26 with the 4-regular circulants on 11 and 13 points as the forced graphs; not attempted. **ν\*(n) away from n = 2m**, or better a bound that uses m\*_N(Γ) ≤ G\*(a) for groups with fixed points. Whether μ\*_N ever exceeds μ\*_cyc.
- **Owed:** a second reading of both Propositions and of `cyclic_chi_values.py`; a second computation of §6's boosted column; the device inside the exact enumerator, for μ\*_cyc over [6, 10⁶]; the right-hand column rescanned class by class. `pending-checks.md` A49.

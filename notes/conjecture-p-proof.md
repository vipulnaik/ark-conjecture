# A proof of the conjecture called P

A standalone account of the proof assembled in `threshold-beyond-mu.md` §6.3. It rests on CFSG and the published results cited below. An independent read is outstanding.

## 0. Statement

Let Γ be a soluble transitive permutation group on a set Ω of size n, where n is not a prime power.

- **Γ̂** is the 2-closure of Γ: all permutations of Ω fixing every orbital of Γ.
- **N\*(Γ)** is the set of permutations carrying every orbital of Γ onto an orbital. It equals N_{Sym(Ω)}(Γ̂).
- A **type** is an orbit of N\*(Γ) on 2-subsets of Ω.
- **m\*_typ(Γ)** is the smallest size of a type.
- **q(n)** is the largest prime power dividing n.

> **Theorem P.** m\*_typ(Γ) ≤ n(q(n) − 1)/2. (This is the conjecture called P in `threshold-beyond-mu.md` §6.3.)

The statement in `threshold-beyond-mu.md` assumes Γ is an Oliver group. The proof does not use that hypothesis.

## 1. Basic facts

Throughout, Γ is soluble and transitive on Ω, and |Ω| = n is not a prime power.

- **F1.** Γ ≤ Γ̂ ⊴ N\*(Γ), and Γ̂ has the same orbitals as Γ.
- **F2 (Higman).** A transitive group is primitive iff every non-diagonal orbital graph is connected. By F1, Γ is primitive iff Γ̂ is, and the two have the same block systems, since a partition is a block system iff its equivalence relation is a union of orbitals.
- **F3.** A soluble primitive group is affine, of prime-power degree. So Γ and Γ̂ are imprimitive.
- **F4 (monotonicity).** If Y ≤ X, then Ŷ ≤ X̂, because Y's orbitals refine X's.
- **F5 (quotients and blocks).**
  - Let Σ be a Γ-invariant partition. The image of a Γ-orbital in Σ × Σ is a Γ^Σ-orbital. So any subgroup A ≤ Γ̂ preserving Σ has A^Σ ≤ (Γ^Σ)^.
  - For a block B, the Γ-orbital of (x, y) with x, y ∈ B meets B × B exactly in the Γ_B-orbit of (x, y), since an element carrying (x, y) into B × B fixes B. So (N\*_B)^B ≤ N\*(Γ_B^B), and (Γ̂_B)^B ≤ (Γ_B^B)^.

## 2. Reduction to primitive N\* with non-abelian socle

Induct on n. Write P(n) for the theorem at degree n. N\* = N\*(Γ) is transitive, since it contains Γ.

**Lemma 1 (N\* imprimitive).** Suppose N\* preserves a nontrivial partition into m blocks of size b, and take a block B. Γ_B^B is soluble and transitive of degree b. By P(b), or by C(b, 2) when b is a prime power, some N\*(Γ_B^B)-orbit on 2-subsets of B has at most b(q(b) − 1)/2 elements. By F5, the N\*_B-orbit of such a pair is no larger. Its N\*-orbit is m times that, since N\* is transitive on blocks. So m\*_typ ≤ n(q(b) − 1)/2 ≤ n(q(n) − 1)/2, using b | n. ∎

If N\* is primitive with abelian socle, it is affine and n is a prime power. So we may assume **N\* is primitive with non-abelian socle.** Γ̂ ≠ 1 is normal in N\*, so it contains a minimal normal subgroup M of N\*, and M is transitive.

## 3. The primitivity lemma

**Lemma 2.** If M is primitive, there is no such Γ.

*Proof.* Γ̂ ⊇ M is primitive, so Γ is primitive by F2. That contradicts F3. ∎

Lemma 2 settles every N\* whose minimal normal subgroups contain one that is primitive. This includes every 2-homogeneous non-affine N\*, whose socle is primitive (2-transitive, except PSL(2, 8) on 28 points, which is still primitive). What remains are the O'Nan–Scott types whose minimal normal subgroups are all imprimitive:
- regular minimal normal subgroups: types HS, HC, TW;
- simple diagonal (SD) with k ≥ 3, and compound diagonal (CD);
- product action (PA), where the socle preserves the coordinate partitions;
- almost simple (AS) with an imprimitive socle, the novelty point stabilisers.

## 4. The remaining types

**Lemma 3 (HS, HC).** N\* has two minimal normal subgroups M₁, M₂, regular and centralising each other. Say Γ̂ ⊇ M₁. Γ̂ ∩ M₂ is normal in N\*, so it is 1 or M₂.
- If it is 1, then [Γ̂, M₂] = 1 and Γ̂ ≤ C(M₂) = M₁. So the transitive Γ ≤ M₁ equals the regular M₁, which is not soluble.
- If it is M₂, then Γ̂ contains the socle. For HS this is T × T on T with diagonal stabiliser, which is primitive, so Lemma 2 applies. For HC it is a product action of HS-type components, which Lemma 5 handles. ∎

**Lemma 4 (diagonal).** Let π be a partition of [k] with a non-singleton block, and D_π ≤ T^k the subgroup that is diagonal on each block. There is no soluble transitive X on Ω_π = T^k/D_π with T^k ≤ X̂.

*Overgroups.* Every X₀ with D_π ≤ X₀ ≤ T^k is a partial diagonal D_σ, with σ refining π.
- X₀ ∩ T_i is normalised by D_π, which projects onto T_i, so it is 1 or T_i. Let I = {i : T_i ≤ X₀}. Then X₀ = ∏_I T_i × X̄, where X̄ meets each remaining factor trivially and projects onto it.
- By Scott's lemma, X̄ is a product of diagonal strips. A strip containing the projection of D_π lies in one π-block, and its twists are trivial because it contains the straight diagonal.

*Induction on k − |π|.* X is imprimitive (degree |T|^{k−|π|}, not a prime power), and by F2 its block systems are X̂'s, hence T^k's: some D_σ with D_π < D_σ < T^k. By F5, the induced group on Ω_σ is soluble and transitive, with T^k in its 2-closure, and k − |σ| < k − |π|. At k − |π| = 1, Ω_π ≅ T with T² acting primitively, so X would be primitive, contradicting F3. ∎

SD and CD are T^k acting on T^k/D_π, after straightening twisted diagonals coordinatewise. The socle is the unique minimal normal subgroup, so Γ̂ ⊇ T^k and Lemma 4 applies.

**Lemma 5 (one coordinate: PA and CD).** Let N\* ≤ H wr S_k act on Δ^k with socle S^k, S = soc(H), |Δ| = m. Let Γ_{(1)} be the elements of Γ fixing coordinate 1, and Y = π₁(Γ_{(1)}) ≤ H.
- *Y is transitive on Δ.* Γ acts on C × Δ, where C is the Γ-orbit of coordinate 1. If it had two orbits O₁, O₂, each would meet every {j} × Δ. Then #{j ∈ C : (j, x_j) ∈ O₁} would be a Γ-invariant function on Ω taking the values |C| and 0, contradicting transitivity.
- *S ≤ Ŷ.* Let x, y differ only in coordinate 1, with x₁ = a and y₁ = b. The element (s, 1, …, 1) ∈ S^k ≤ Γ̂ shows that the pair with first coordinates (sa, sb), and the rest unchanged, lies in the same Γ-orbital. An element of Γ carrying one pair to the other preserves the set of differing coordinates, so it lies in Γ_{(1)}, and its first component carries (a, b) to (sa, sb).

So Y is soluble and transitive on Δ, with soc(H) ≤ Ŷ, and m is not a prime power (else n = m^k would be).
- If soc(H) is primitive, Y is primitive, contradicting F3.
- If H is of diagonal type, Lemma 4 excludes it.
- If H is almost simple with an imprimitive socle, Lemma 6 excludes it. ∎

**Lemma 6 (almost simple with an imprimitive socle).** Let H be almost simple and primitive on Δ, of non-prime-power degree, with socle T imprimitive. There is no soluble transitive Y ≤ H with T ≤ Ŷ. (Applied with H = N\* or with H a PA component.)

*Proof.* Let K = H_δ, which is maximal, and suppose Y is soluble and transitive. Then H = YK, so (H, Y, K) is in LX Thm 1.1 (LX = Li and Xia, *Factorizations of almost simple groups with a solvable factor*, arXiv:1408.0350). T is imprimitive exactly when K ∩ T is not maximal in T. K ∩ T ≠ 1, because almost simple primitive groups have non-regular socle. K ∩ T is not normal in H, so K = N_H(K ∩ T) by maximality, and K ∩ T = N_T(K ∩ T).
- *Classical T, LX case (d):* by LX Remark (i), N_T(K ∩ T) is maximal in T, except for K ∩ T = PSL₃(3) (row 6 of LX Table 1.2) or A₅, S₅ (row 11). So T is primitive outside those rows.
- *LX Prop. 4.1(a), T = PSL₂(q), both factors soluble (either orientation):*
  - If K ∩ T contains a Sylow p-subgroup, it lies in the Borel subgroup, which normalises it, so K ∩ T is the Borel subgroup, which is maximal.
  - If K ∩ T = D ≤ D\* = D_{2(q+1)/d}, then self-normalising forces D dihedral of order 2r with r ≥ 3, and N_T(C_r) = D\*. So K ≤ N_H(D\*), and maximality forces D = D\*, which is maximal for q ∉ {7, 9}.
- *LX Prop. 4.3, T = A_n:* in cases (a)–(c), K ∩ T has A_{n−j} as a normal subgroup for some j ≤ 3 and lies in S_{n−j} × S_j, so maximality of K forces K ∩ T = (S_{n−j} × S_j) ∩ A_n, which is maximal. Cases (d) and (e) give A₅ ≤ A₆, which is maximal.
- *Exceptional Lie type:* LX gives no factorisation with a soluble factor outside Prop. 4.1, which contains no exceptional groups.
- *The finite remainder:* LX Table 1.2 rows 6 and 11, Prop. 4.1(b) together with PSL₂(23) from LX Table 4.1, Prop. 4.3(f), Prop. 4.4, and q = 7, 9 above. For degree above 1000 it is checked that no novelty in these groups has a soluble transitive subgroup at all (Appendix A2). For degree at most 1000, it is checked over the primitive groups library that no such H has a soluble transitive Y with T ≤ Ŷ (Appendix A3). ∎

**Lemma 7 (TW).** Here N\* = M:P with M = T^k regular. In a primitive twisted wreath product, P is faithful on the k factors, and T is a composition factor of P₁ ≤ S_{k−1} (Baddeley; see Fawcett, arXiv:2102.02190). So |T| divides (k − 1)!, and k ≥ 6.

Take t ∈ T₁. Its P-orbit lies among the k(|T| − 1) elements of M with one-coordinate support, so the N\*-orbit of the 2-subset {1, t} has at most n·k(|T| − 1) elements. Since q(n) = q(|T|)^k, it is enough to show **2k(|T| − 1) < q(|T|)^k**. The right side at least doubles in k while the left grows linearly, so it suffices at the least admissible k.
- *Lie type:* |T| < |T|_p³ ≤ q(|T|)³.
  - For rank ℓ < N (N the number of positive roots), |T| ≤ q^N ∏(q^{d_i} ± 1) with Σd_i = N + ℓ, so |T| < 2q^{2N+ℓ} ≤ q^{3N}.
  - The rank-1 cases are direct: q(q² − 1)/d < q³; q²(q² + 1)(q − 1) < q⁶; q³(q³ + 1)(q − 1) < q⁹.
  - Then q(|T|)^k > |T|·4^{k−3} ≥ 2k|T|.
- *T = A_n:* the largest prime p ≤ n divides (k − 1)!, so k ≥ p + 1 > n/2 + 1 by Bertrand, and q(|T|) ≥ 2^{v₂(n!) − 1}. Then k(v₂(n!) − 1) ≥ (n/2)(n − log₂n − 2) > log₂(k·n!) for large n; checked for 5 ≤ n ≤ 3000 (Appendix A4).
- *Sporadic groups and the Tits group:* checked (Appendix A4).

This gives P's bound in type TW for every Γ, whether or not Γ̂ contains M. ∎

Lemmas 1–7 cover every case, so the theorem holds. ∎

## Appendix A. Computations

Scripts in `scripts/`, outputs in `outputs/`.

- **A1.** Outside Lemmas 6 and 7 the proof uses no computation. The degree-≤ 1000 scans (`conjP_prim_scan.g`, `conjP_soluble_filter.g/.sh`, `conjP_hs_check.g`, `conjP_minnormal_prim.g`, `conjP_flag_points.g`) predate the lemmas and serve as an independent check up to degree 1000.
- **A2.** Lemma 6, degree above 1000:
  - `conjP_as_novelty.g`: CtblLib maxes, with novelties detected by order;
  - `conjP_as_novelty2.g`: Aut(L) built for L₃(4), L₃(8), U₃(8), L₄(3), A₆ and L₂(23), novelties by conjugacy;
  - `conjP_as_novelty_chk.g`: the order-ambiguous cases, by permutation characters;
  - `conjP_hall_chk.g`: the Hall test. If primes r, s divide n, with s exactly once in |G|, s ∤ r^i − 1 for r^i dividing |G|, and r ∤ s − 1, a soluble transitive subgroup contains an element of order rs;
  - `conjP_two_cases.g`: J₂.2 on 1800 and HS.2 on 1100, directly.
  
  Two cases are by hand: L₃(8).X on 4672, by a Hall {2, 73} argument; and L₄(3).X on 1080, where LX Table 1.2 row 6 gives |Y ∩ T| prime to 3 while 27 | 1080.
- **A3.** Lemma 6, degree at most 1000: `conjP_nov_small.g`, 51 groups, none with a soluble transitive Y with T ≤ Ŷ.
- **A4.** Lemma 7: `conjP_tw_bound.py`.

## Appendix B. Cited results

- CFSG.
- Li and Xia, arXiv:1408.0350: LX Thm 1.1, Remark (i), Propositions 4.1, 4.3, 4.4, Tables 1.2 and 4.1–4.3. These statements were checked against the text; Tables 4.1–4.3 only in summary, with their socles all included in A2.
- Baddeley's structure theorem for primitive twisted wreath products, as stated in Fawcett, arXiv:2102.02190.
- Scott's lemma on subdirect products of non-abelian simple groups.
- Higman's criterion for primitivity.
- Soluble primitive groups are affine.
- Almost simple primitive groups have non-regular socle; regular minimal normal subgroups occur only in types HA, HS, HC, TW.
- The O'Nan–Scott theorem.

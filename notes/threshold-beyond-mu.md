# Numerical projections of the ladder, and μ\*_χ: the Oliver-χ rung reaches past μ\*

*A finding of 2026-11-10, one sitting. **Second check (2026-11-14):** both Propositions reread; every listed script reviewed line by line and rerun, reproducing every figure quoted here; the k-table, k = 10 and the k = 12 witness, and G\*(6) recomputed by independent code. One bug was found, in `verify_global_chi.py`'s membership test for the (n/3)K₃ property; it was fixed, and the n = 18 property still passes. Details in `session-log-17.md` Part 6. Still not a referee reading of the arguments. Nothing here changes μ\*(n), B(n), the table or the classification. Scripts: `cyclic_chi_values.py`, `threshold_scan.py`, `cyc_floor_scan.py`, `cyc_certify.py`, `entangled_check.g`, `type_levels6.py`, `biclique_boost_scan.py`, `nstar_types.py`, `pgroup_levels.py`, `global_chi_min.py`, `global_chi_forced.py`, `verify_global_chi.py`, `kset_block_levels.py`, `cyc_witness_check.g`, `mu_cyc_bounds.py`, `cyclic_chi_small.py`, `cyclic_chi_product.py`, `cyclic_chi_recursive.py`, `cyclic_chi_witness_check.py`, `cyclic_chi_good_recheck.py`, `cyc_density_one.py`, `nstar_transitive_check.g`, `nstar_transitive_check.py`, `socle_2homog_check.g`, `chi_level10.py`, `pgroup_levels_explicit.py`, `smith_blocks.py`, `smith_families.py`, `smith_pgroups.g`, `smith_pgroups.py`, `fpf_separation_search.py`, `fpf_upper.py`, `fpf_upper_scan.py`, `ws_level1_filter.g`, `ws_level1_filter.py`, `dir_chiral_witness.py`, `ws_level2_battery.g`, `ws_level2_battery.py`, `ws_14t10_exhaust.py`, `ws_gapclose.py`, `ws_gaprows_kinds.py`, `ws_blockdata.g`, `ws_gapclose_pp.py`, `cyc_chi_one_cpsat.py`, `cyc_pullback_union.py`, `cyc_chi_one_construct.py`, `ws_budget_scan.py`, `ws_budget_exact.py`, `ws_budget_pp.py`, `nstar_t40_export.g`, `nstar_t40.py`, `lemma_c_check.py`, `lemma_c_data.py`, `gluing_check.py`, `crt_pure_check.py`. **This file is a staging area:** the finding is to be refined here before any of it is carried into the framework documents, and the short note is not to be changed on its account (decided 2026-11-10). Notation: every new quantity carries the star of μ\*, marking a max–min or min–max.*

## Map of the quantities

*Read A ---> B as A ≥ B: every arrowhead points at the smaller quantity. Definitions: M\*_R in §1; μ\*_χ and M\*_OCR in §2; the per-group levels and m\*_typ in §3; μ\*_cyc in §4 and U(n) in §5; s(n) and s\*_N(n) in §6; ν\*, G\*, and the fixed-point-free parts ν\*_fpf and μ\*_N^fpf in §7. §12 argues, informally, that every quantity computable from orbit data is capped at δ_cyc on a set of density 1. §13 sorts the definitions by the generality they need; §14 and §15 take the directed and chiral variants.*

```
                          C(n,2)
                            ||      equal exactly when ARK holds at n
                            ||
                            \/
                          M*_NE
                            ||
                            ||
                            \/
                          M*_OCR                     9 at n = 6
                            ||      min-max above, max-min below:
                            ||      they part here (9 against 6 at n = 6)
                            \/
                          mu*_chi                    = mu* at n = 6 and 10
                            ||
                            ||
                            \/
  max(nu*, G*)  ------->  mu*_N  ----------------->  G* = m*_N(1) = m*_chi(1)
                            ||                       the trivial group;
                            ||                       the rung chi = 1
                            \/
       nu*_fpf  ------->  mu*_N^fpf                  no fixed point; above it,
                            ||                       mu*_N <= max(mu*_N^fpf,
                            ||                       n - 1, G*(a) for a <= n)
                            \/
          U(n)  ------->  mu*_cyc
                            ||
                            ||
                            \/
                  mu*  =  M*_OR  =  M*_BR
                            ||
                            ||
                            \/
                          M*_vtOR  =  n(q(n) - 1)/2


  (n/2) * floor((n-1)/2)  ------>  nu*        the left side is mu*(n) when
                                              n = 2 * (prime power), so there
                                              mu*_N = max(mu*, G*)

  nu*  ------>  nu*_fpf                       at density 1, mu*_N^fpf and
                                              nu*_fpf are delta_cyc(n) C(n,2),
                                              under (BH-SW) and Conjecture P

  G*  and  mu*, mu*_cyc :  not comparable     G* < mu* at n = 12, 18
                                              G* = mu* at n = 6, 10, 14
```

*Per group.* Each μ\*_X(n) is the maximum over Oliver groups Γ of the m\*_X(Γ) below it; ν\*(n) is the maximum of m\*_typ over Γ ≠ 1, and ν\*_fpf(n) and μ\*_N^fpf(n) are the maxima of m\*_typ and m\*_N over fixed-point-free Γ.

```
        m*_chi(G)                 m*_typ(G)
            ||                       //
            ||                      //
            ||                     //
            \/                    //
         m*_N(G)  <==============+
            ||
            ||
            \/
          m*(G)

     max over G:    mu*_chi          mu*_N          mu*
                    (level 2)        (level 1)      (level 0)

     max over G
     without a fixed point:          mu*_N^fpf      (m*_typ: nu*_fpf)
```

*Required bicliques.* A non-evasive property contains K_{a,b} whenever a + b is at most the quantity shown.

```
            n                 the trivial cap on a + b
            ||
            ||
            \/
            ?                 what the chi rung requires: no upper bound known
            ||
            ||
            \/
          s*_N(n)             blocks 2-homogeneous, or carrying a good type
            ||
            ||                the step mu*_cyc ---> mu*, on the biclique side
            \/
           s(n)               blocks 2-homogeneous only; exact for Oliver-resistance


     limit of  .../n     n mod 12:   0,4,6,10    2,8    1,9    3,7     5      11
          s(n)                         1/2       1/4    1/3    1/5    1/7    1/13
          s*_N(n)   at least           1/2       1/2    1/3    1/3    1/3    1/3
```

## Cost of computing each quantity

*Added 2026-11-14. A companion to the map: for each quantity, what the code computes, what it cost in practice, and its complexity class. Exponents inside "polynomial" depend on the implementation and are indicative only. Where there is no working algorithm, the bound is the obvious combinatorial one.*

| quantity | what is computed, and by what | measured | complexity class | size as a function of n, and its standing |
|---|---|---|---|---|
| **M\*_vtOR** = n(q(n) − 1)/2 | factor n | instant | polynomial | small; exact and unconditional |
| **μ\* = B**, above 1/25 | `mu_ladder_exact.py`: the menu shapes plus S6 and S11, about O(n/log n) candidates each; exact by `enumeration-proof.md` Theorem E.5 and `ladder-completeness.md` Prop. 1 | 4.3 ms/n at 2.5·10⁵, 15 ms/n at 10⁶; the table to 10⁶ in about 3 h single-threaded | **polynomial**: about n per value, N² for a table to N | Θ(n²) for all large n under (BCG-AL); unconditionally n^{5/4} for all large n and n^{1.679} for almost all n; n^{2−ε} for almost all n if PD(1) holds |
| μ\* = B, without the collapse theorem | `mu_exact.py`: the whole shape space | about n^2.3 per value, tail near n^2.9; about 3 h per value at 10⁶ | polynomial, steep | — |
| μ\*, from its definition | enumerate the Oliver subgroups of S_n | S₁₀: 1,294 classes; S₁₂: 8,572, in 3 min from the table of marks (the library stops at S₁₃) | **super-exponential**: 2^{Θ(n²)} subgroups (Pyber), already from elementary abelian 2-groups, which are Oliver | — |
| **μ\*_cyc**, lower bound L(n) | `threshold_scan.py`, `cyc_floor_scan.py`: the μ\* shapes, rescored (box below) | N = 4000 in about 10 s; floor scan 10⁵ in 5 s, 10⁶ in about 5 min (thresholded rows) | polynomial, as μ\* | conditional on (BCG-AL); limits 1/4 and 3 − 2√2 (§5); unconditionally no better than μ\* |
| **U(n)**, upper bound for μ\*_cyc | `cyc_certify.py`: one pass over primes r < n, reading the μ\* table | seconds for 3,410 rows | polynomial: O(n/log n) per n, given the table | meets L(n) at 2,385 of 3,410 rows to 4000 |
| **ν\*** | `nstar_types.py`: per Oliver class, nauty on points–pairs–orbitals | S₁₂, all 8,572 classes, about 5 min | polynomial per group in practice; **super-exponential** over all classes | at most (n/2)⌊(n − 1)/2⌋ |
| **ν\*_fpf**, **μ\*_N^fpf** | `nstar_types.py` (fixed-point-free classes), `nstar_transitive_check.py` | as ν\* and μ\*_N | as ν\* and μ\*_N | μ\*_cyc ≤ μ\*_N^fpf ≤ ν\*_fpf ≤ ν\*; δ_cyc at density 1 under (BH-SW) and Proposition U\_typ (§7) |
| **μ\*_N** (level 1) | `pgroup_levels.py`, `type_levels6.py`: per group, CP-SAT over N\*-orbits of sets of orbitals | 399 p-groups with t ≤ 14 at n = 10: about 2 min; n = 6, all 50 classes: 1 min | per group 2^t (t ≤ C(n,2)); over all groups **doubly exponential** | max(μ\*_cyc, G\*) ≤ μ\*_N ≤ max(ν\*, G\*) |
| **μ\*_χ** (level 2) | `type_levels6.py`, with embedding among unions of orbitals; `chi_level10.py` (nauty certificates, `emb.c`) | n = 6 in a minute; n = 10, all 1,294 classes, about 45 min | per group 2^t subgraph-isomorphism tests; **doubly exponential** | known at n = 6 and 10, where it equals μ\* |
| **G\*** | `global_chi_min.py` (exhaustive up to s edges), `global_chi_forced.py` and `verify_global_chi.py` (a forced graph plus a congruence solve) | n = 6 in seconds; n = 12 infeasible to 10 edges in minutes; n = 14 on 544,727 subgraph classes, minutes; n = 18 fast given the forced graph | classes up to s edges ≈ C(C(n,2), s)/n!, so 2^{Θ(n²)} at s ~ n²; properties are subsets: **doubly exponential** | known for n ≤ 18; asymptotics unknown; no number theory |
| **M\*_OCR** | the n = 10 CSP (`small-degree-computation.md`): one property passing a battery | V = 3,782 classes at t ≤ 12; stage 3 projected at about 27 h on 8 cores; n = 12 projected at weeks | classes ≈ 2^{C(n,2)}/n! (about 1.2·10⁷ at n = 10); properties are down-sets: **doubly exponential** | known only at n = 6 (9) |
| **M\*_NE** | none: needs the decision-tree depth of every candidate | exact depth on 2¹⁵ subsets is easy at n = 6; n = 7 already needs a symmetry-reduced solver | 2^{2^{Θ(n²)}} properties, each a recursion on the 2^{C(n,2)} cube: **at least doubly exponential** | C(n,2) exactly if ARK holds |

**Two features of this table matter.**

- **The cliff is between U(n) and ν\*.** Up to there everything is polynomial and has been run to 10⁵ or 10⁶. From ν\* on, every quantity needs all subgroups of S_n or all graph classes, 2^{Θ(n²)} either way, and a solver over subsets of those. There is no intermediate tier. The data beyond the cliff reaches n = 18 at best, and only by pruning (orbital caps, a forced graph), which does not change the class.
- **What makes μ\* polynomial is the framework, not number theory.** From its definition μ\* is a 2^{Θ(n²)} group enumeration; the classification and the collapse theorem reduce it to a near-linear scan per n. Number theory enters the cost only through constants: near-optimal shapes are dense, so the scans find their witnesses early.

> **μ\*_cyc and U(n), precisely.** These are the two polynomial quantities that have had the fewest rounds of audit, both of the code and of the argument.
>
> - **Definition.** μ\*_cyc(n) is the largest value, over Oliver groups Γ on [n], of:
>   - Γ's smallest orbital; or
>   - for one orbit R of Γ of prime size r on which the induced group ℤ/r ⋊ C_t has a **good** index k = C(r,2)/orb(r, t) for Γ's top prime, the value M = min(C(r,2), the least orbital of Γ outside R's own pairs). "Good" means that no C_k-invariant proper complex has χ ≡ 1 (mod q), or χ = 1 when the top is trivial.
>
>   By the Proposition of §4, μ\*(n) ≤ μ\*_cyc(n) ≤ μ\*_N(n). Restricting to one orbit is a choice of definition: a group whose two orbits both carry good types lies outside it, though level 1 may still credit it.
> - **The lower bound L(n)** is the maximum of μ\*(n) and the best of a menu:
>   - shapes n = F·c + r, with c a prime power of a prime other than r, full twist on the matching blocks, and gcd(F(c − 1), r) = 1;
>   - the entangled case F = 1, r | c − 1 (`threshold_scan.py` only);
>   - foreign twist t equal to the full q-part of r − 1, or trivial;
>   - value min{F·C(c,2), F·c·r, cross-block term, foreign term}, the foreign term being C(r,2) when k is good and orb(r, t) otherwise.
>
>   "Good" is decided by a table: the exact sets for k ≤ 7, q > 2^k for k ∈ {8, 9, 10, 11, 13}, and never for k = 12 or k ≥ 14. Every choice errs low: only one t per prime, no k ≥ 14, prime-power k refused for q ≤ 2^k, and no two-foreign or two-matching-class shapes. So L(n) ≤ μ\*_cyc(n), *provided each scanned shape is a genuine Oliver group with the stated orbitals.* That proviso rests on the gcd rule, and it has been checked by building the group only at four witnesses: n = 63 (`entangled_check.g`), and n = 70, 77 and 84 (`cyc_witness_check.g`). At each the group is Oliver and its orbitals give exactly the scanned value: 406, 465 and 820 respectively, the n = 77 case being a fused pair.
> - **The upper bound U(n)** uses no classification. If R is used, every orbital inside the complement of R (m = n − r points) is an orbital of the induced group there, which is a quotient of Γ and so Oliver; the least of them is at most μ\*(m). A cross orbital between R and the complement has at most r·m pairs. Hence M ≤ min(C(r,2), r·m, μ\*(m)), and taking every prime r gives U(n). U_for restricts r to those that can carry a good foreign type. The step from "the least orbital inside the complement" to μ\*(m) treats the induced group as an arbitrary Oliver group on m points; that is correct, and generous.
> - **Status to 4000**:
>   - L(n) = U(n), so μ\*_cyc is known exactly, at 2,385 of 3,410 rows.
>   - L(n) = U_for(n) at 3,403; the seven exceptions are listed in §5.
>   - At 1,025 rows the gap is the "matching-prime reading" (R of the group's own prime with a partial twist), which only U bounds; three of these (n = 110, 154, 171) are closed by hand.
>   - To 10⁵ the infimum of μ\*_cyc/C(n,2) is **0.09378, at n = 923**, where L = U. The rule for good types now includes the trivial-top case of the update below. Under it n = 1159 lifts to 0.1189, and every other row to 10⁵ has L ≥ 0.0972 (at 5219, not lifted).
> - **Audit so far:**
>   - one author pass, plus one second check (2026-11-14): the code read line by line and rerun, every figure reproduced, and the U argument and the Proposition reread;
>   - not done: an independent reimplementation of L or U;
>   - Oliver groups built at only four witnesses;
>   - no check of the conservative choices against a full enumeration at small n. Comparing `mu_exact.py`'s shape space, rescored, at n ≤ 200 would be the natural one.
>
> **Update (2026-11-14; `session-log-17.md` Part 9): the gap reduced to one combinatorial question.** `mu_cyc_bounds.py` replaces U by a bound **B^(n)** taken over the framework's shape space. That space has at most one matching class, credited flat at F·C(c,2), and up to three foreign primes at a common top prime. A winner above 0.0887·C(n,2) has at most three parts. B^ credits a foreign block with C(r,2) unless its type is *proved* bad. The matching-prime reading is subsumed, since rescoring a prime matching block gives C(c,2), which is already its flat credit.
>
> The lower bound **L'(n)** uses the same shapes with only proved-good types and the scan's chain rules. Goodness is decided by three facts, proved in Part 9:
> - **Pull-back.** A value of χ attained on m points is attained on every multiple of m. χ = 1 is attained at k = 12 and at k = 30 (`cyclic_chi_small.py`, faces ≤ 5).
> - **Reduction.** For an odd prime p | k, with k′ = k/p^{v_p(k)}, χ(X) ≡ χ(Y) mod p, where Y is the complex of p-Sylow-coset unions viewed on k′ points. So χ = 1 needs, at every odd p | k, a C_{k′}-complex on k′ points with χ ≡ 1 (mod p). The value sets are known exactly for k′ ≤ 9.
> - **Skeleta.** The s-skeleton gives χ = 1 − (−1)^s C(k − 1, s).
>
> A consequence: a **trivial-top foreign block** with k = (r − 1)/2 a prime power, or failing the reduction (for example k = 296 = 8·37 at r = 593), counts at C(r,2). This lifts L at 158 rows to 4000.
>
> **Status to 4000:** L′ = B^, so μ\*_cyc is exact relative to the classification, at **all 3,410 rows**. Two further steps closed the gap. *A recursive certifier* (`cyclic_chi_recursive.py`) builds nested pairs (χ(A₁), χ(A₂)) on m points from exact enumeration (m ≤ 8), graph and skeleton chains, pull-backs and the product construction itself. It certifies χ = 1 at 146 of the 160 undecided trivial-top k below 4000 (`outputs/cyclic_chi_certified.txt`). The 14 it leaves open do not decide any row. *The undecided q-top pairs* (k, q) are settled in `outputs/cyclic_chi_modq.txt`, either by a realised χ value or by CP-SAT with χ = 1 + qz. Pairs (k, 2) with k a power of 2 are GOOD, since every invariant face orbit then has even size. *Checked:* `cyclic_chi_witness_check.py` gives an explicit witness for every BAD pair and every certificate, checked by listing faces. Witnesses have small faces, are pulled back from a divisor, or form derivation trees whose steps are the pull-back and product lemmas, each tested on random small complexes. The eight CP-SAT GOOD verdicts are confirmed by a second solver (HiGHS). Before these steps the count was 2,744 rows, every row below n = 527 included. The floor 0.09378 at n = 923 is now also B^'s floor, so the minimum of μ\*_cyc/C(n,2) to 4000 is settled from both sides. *A product construction* (`cyclic_chi_product.py`, Part 10) certifies χ = 1 at 32 further k, 56 and 63 among them. It uses the coprime split ℤ/k = ℤ/a × ℤ/b and the complex P(A₁, Δ) ∪ P(Δ, B₁) ∪ P(A₂, B₂), where P is the simplicial product, A₁ ⊆ A₂ and B₁ ⊆ B₂. Since χ(P(A,B)) = χ(A)·χ(B), this has χ = 1 exactly when (a₂ − a₁)(b₂ − b₁) = (a₁ − 1)(b₁ − 1). Earlier count, before this construction: At every remaining row the gap is a single trivial-top foreign block whose k is undecided. There are 218 such k below 2000: 56, 63, 99, 105, 135, …. All pass the reduction test, and at 56 and 63 no χ = 1 complex exists with faces of at most 5 vertices. **If every such k attains χ = 1, then L′ = B^ at all 3,410 rows** (checked by rerunning with the undecided k treated as bad), and μ\*_cyc = L′. So the whole gap is one question: *does the reduction condition characterise the k at which a C_k-invariant proper complex has χ = 1?*

## 1. Projecting a rung to a number

For a monotone graph property P on n vertices write **e_max(P)** for the largest number of edges of a member. Properties are as in `orbital-evasiveness-notes.md` §7.1: monotone decreasing with ∅ ∈ P, so the empty property is excluded by definition and the trivial property (K_n ∈ P, s = C(n,2)) is included. For a rung R of the ladder of `orbital-evasiveness-notes.md` §7.2, its **numerical projection** is

> **M\*_R(n) = min { e_max(P) : P satisfies R }**.

The trivial property satisfies every rung, so **M\*_R(n) ≤ C(n,2)** always, with equality exactly when the ladder has collapsed at R: no nontrivial property reaches it. ARK at n is M\*_NE(n) = C(n,2). At a prime power every projection is C(n,2), μ\* included.

Every property with e_max(P) < M\*_R(n) fails R; if R is implied by non-evasiveness it is evasive. An implication R ⇒ R′ between rungs projects to M\*_R ≥ M\*_R′. Two projections are already in the notes under other names, and one more is immediate.

| rung R | M\*_R(n) | standing |
|---|---|---|
| vertex-transitive Oliver-resistant | **n(q(n) − 1)/2**, q(n) the largest prime-power divisor of n | exact and unconditional — `orbital-evasiveness-notes.md` §7.2 fact 8, which calls it "the exact threshold" |
| Oliver-resistant | **μ\*(n)** | exact; Θ(n²) under the bounded-cofactor hypothesis, with the six mod-12 ceilings |
| bi-resistant (`orbital-evasiveness-notes.md` §7.13) | **μ\*(n)** again | below |
| Oliver-χ-resistant | ≥ **μ\*_χ(n)** (§2) ≥ the bound of §4; **9 at n = 6**; C(n,2) at prime powers | this note; otherwise open |
| nontrivial-top Oliver-χ-resistant | ≥ the bound of §4 (its groups have nontrivial top); **not** bounded by μ\*_χ(n) in general, since μ\*_χ is attained on trivial-top groups (§2) and a group's value is at most its core's | this note; otherwise open |
| χ(Δ_P) = 1, the trivial group's condition | **G\*(n)**: 6, 20, 11, 42, 18 at n = 6, 10, 12, 14, 18 | §7; not comparable with the rungs above it in this table |
| non-evasive | C(n,2) at every n, if ARK holds | — |

*Why the first two are projections.* Resistance is monotone in P (fact 1), so the threshold property T_B = "at most B edges" is resistant as soon as B reaches the smallest orbital of each group in the class. Hence M\* is the largest, over the groups of the class, of the smallest orbital: a max–min over groups equal to a min–max over properties. For all Oliver groups that is μ\*(n); for the vertex-transitive ones fact 8 evaluates it. The implication Oliver-resistant ⇒ vertex-transitive Oliver-resistant projects to **μ\*(n) ≥ n(q(n) − 1)/2**, which is the unconditional n log n bound of the rewrite plan.

*Bi-resistance projects to the same number.* The dual of T_B is T_{C(n,2)−B−1}, so T_B is bi-resistant exactly when μ\*(n) ≤ B ≤ C(n,2) − 1 − μ\*(n) — at n = 10 the window 20 ≤ B ≤ 24, which is the window `orbital-evasiveness-notes.md` §7.7 and `orbital-evasiveness-notes.md` §7.13 measured. The projection, being one-sided, cannot tell bi-resistance from resistance.

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
- *Where each is C(n,2).* At a prime power both are (AGL(1, n) is passed by the trivial property alone). At other n it is not known whether μ\*_χ(n) can reach C(n,2). M\*_OCR(n) = C(n,2) says exactly that the Oliver conditions alone prove ARK at n — false at n = 6, the first non-prime-power, and what the n = 10 search of `orbital-evasiveness-notes.md` §7.9 is deciding.

**At n = 6 the two separate.** μ\*(6) = 6. The two Oliver-χ-resistant properties of `orbital-evasiveness-notes.md` §7.9 have e_max = 9 (largest member K₃,₃) and e_max = 12, and they are the only ones, so **M\*_OCR(6) = 9**. Computing m\*_χ(Γ) for each of the 50 Oliver classes (`type_levels6.py`) gives **μ\*_χ(6) = 6**: every group, taken alone, is passed by some property with at most 6 edges, and no property with fewer than 9 passes them all. *(At n = 10 the property the search currently holds, which passes every class with t ≤ 11 and part of t = 12, has e_max = 30; it was not minimised, so this bounds nothing.)*

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

**At n = 10 the same: μ\*_χ(10) = μ\*_N(10) = μ\*(10) = 20** (`chi_level10.py`; `outputs/chi_level10.txt`).
- **How it is checked.** For every one of the 1,294 Oliver classes of S₁₀ except the trivial group, a family that is closed under embedding meets the group's condition with every member having at most 20 edges, so m\*_χ ≤ 20. The trivial group's value is G\*(10) = 20 (§7). The lower bound is μ\*(10) = 20.
- **How the families are found.** Feasibility is monotone in the budget. The script tries the classes cheapest first at budget 20, and for the 82 classes with the most invariant graphs it climbs budgets b = 2, 4, … and stops at the first feasible one. The largest case is 2.8 million invariant graphs in 1,340 isomorphism classes, at b = 10, for the groups of order 3 and 6 that move 3 points and fix 7.
- **Where level 2 lifts.** Three classes reach exactly 20 at level 2 from m\* = 1: ℤ/5, D₅ and the Frobenius group of order 20, each acting on 5 points and fixing the other 5. Level 2 lifts them to the maximum and no further, as at n = 6.
- **Checks.** Run with CHI_N=6, the same script, with nauty certificates and `emb.c`'s embedding test in place of brute force over S₆, reproduces `type_levels6.py`'s m\*_χ for all 50 classes of S₆. The embedding test agrees with networkx's VF2 monomorphism on 6,000 random pairs. For the seven classes with m\* = 20, and for the three just listed, the exact value 20 is confirmed by budgets climbing in steps of 1.

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

**Prime-power indices are good for every large q.** If k = ℓ^a (prime k included), every proper C_k-invariant complex has χ ≡ 0 (mod ℓ), so χ ≠ 1. Since |χ − 1| < 2^k, the congruence χ ≡ 1 (mod q) then fails for every q ≥ 2^k. So the index, and with it the cofactor d = 2k, may grow like log q, but no faster by this argument. At a cofactor that is a power of r, which is all the unconditional shifted-prime results supply, the device gives nothing. This also covers k = 8, 9, 11 and 13 without the solver; k = 10 and 12 are confirmed independently of `cyclic_chi_values.py`. At k = 10 an exhaustive enumeration of all 292,592,828 invariant proper complexes has χ ∈ [−125, 127] and never 1. At k = 12 the solver's witness, 3,943 faces, was rechecked directly: it is closed, invariant, proper, and has χ = 1.

So a foreign block with **r − 1 = 2kq^e, k ≤ 11 or k = 13, and q outside a finite set depending on k**, counts as C(r,2) — efficiency 1, whatever the framework's η = 1/k. The proof uses only N\*-invariance, so it is a level-1 statement: the block's own orbitals are one type, and M ≤ m\*_N(Γ). Write **μ\*_cyc(n)** for the resulting lower bound: μ\*(n) recomputed with every qualifying foreign block scored at C(r,2).

> μ\*(n) = M\*_OR(n) ≤ μ\*_cyc(n) ≤ μ\*_N^fpf(n) ≤ μ\*_N(n) ≤ μ\*_χ(n) ≤ M\*_OCR(n) ≤ M\*_NE(n).

The step μ\*_cyc ≤ μ\*_N^fpf (§7) holds because a group with a fixed point has an orbital of at most n − 1 pairs. Since μ\*_cyc(n) ≥ μ\*(n) ≥ n at every row of the table (n ≥ 6), the witness of μ\*_cyc(n) has no fixed point.

## 5. Consequences

**Under the short note's hypothesis, as a statement about μ\*_χ — not a change to the note.** (BCG₁/₅) takes d ∈ {2, 4, 6, 12}, that is k = d/2 ∈ {1, 2, 3, 6} with t = q an odd prime. All four qualify once q ∉ {2, 5, 7}, which holds for n ≥ 426. The foreign term r(r − 1)/24 becomes C(r,2), and min{C(c,2), C(r,2), cr} ≥ C(n,2)/26 for n ≥ 105. So under (BCG₁/₅), **μ\*_χ(n) ≥ C(n,2)/26 for all large n**, and every nontrivial monotone property with fewer than C(n,2)/26 edges is evasive — thirteen times the note's 1/350. The note is left as it is: its bound is deliberately simple and loose, there only to establish Θ(n²), and sharpening the more complicated half of it is not wanted. The 1/26 is a statement of this file.

**Ceilings.** With every qualifying foreign block at efficiency 1 only the parity of n enters. Both columns are cap_F(η) = η/(1 + √(Fη))²; the μ\* column takes the η = 2/d the class allows (`arithmetic-of-density.md` §3.3.5), the other takes η = 1.

| n mod 12 | μ\*(n)/C(n,2) ceiling | attained by | μ\*_cyc(n)/C(n,2) ceiling — a **lower bound** for μ\*_N^fpf, μ\*_N and μ\*_χ, and at density 1 the value of μ\*_N^fpf (§7, conditional) | attained by |
|---|---|---|---|---|
| 0, 4, 6, 10 | 1/4 = 0.2500 | F = 1, η = 1 | 1/4 = 0.2500 | the same shape (d = 2) |
| 2, 8 | (2 − √3)/2 = 0.1340 | F = 1, η = 1/3 | **1/4 = 0.2500** | F = 1, d = 6 (k = 3) |
| 1, 9 | 3 − 2√2 = 0.1716 | F = 2, η = 1 | 3 − 2√2 = 0.1716 | the same shape (d = 2) |
| 3, 7 | 1/8 = 0.1250 | F = 2, η = 1/2 | **3 − 2√2 = 0.1716** | F = 2, d = 4 (k = 2) |
| 5 | 5 − 2√6 = 0.1010 | F = 2, η = 1/3 | **3 − 2√2 = 0.1716** | F = 2, d = 6 (k = 3) |
| 11 | 7 − 4√3 = 0.0718 | F = 4, η = 1/3 | **3 − 2√2 = 0.1716** | F = 2, d = 12 (k = 6) |

The right-hand column is 1/(1 + 1)² at even n and 1/(1 + √2)² at odd n; the worst class moves from 0.0718 to 0.1716. *Standing:* the μ\* column is the asymptotic value of μ\*, given the enumeration proof and the hypothesis. The right-hand column is the asymptotic value of μ\*_cyc and only a lower bound for μ\*_χ — there is no classification behind it (§11). At almost every n it is the value of μ\*_cyc, conditionally: *Density one* below. The table itself is arithmetic on the cap formula, spot-checked on n from 9,000 to 12,000, where the best one-foreign value in classes 2, 7 and 8 is 0.2495, 0.1715 and 0.2497, and classes 5 and 11 reach 0.207 and 0.198 at special n. The k = 6 row needs q ∉ {2, 5, 7} and the k = 3 rows q ≠ 2, automatic for large n.

**Density one: the right-hand column is the value of μ\*_cyc at almost every n.** Write δ_cyc(n) = 1/4 at even n and 3 − 2√2 at odd n. The statement has an unconditional upper half, a conditional lower half, and an exceptional set of size O(N/log N).

> **Proposition U (unconditional).** Let E be the set of composite non-prime-power n such that either
> - (q(n) − 1)/(n − 1) ≥ δ_cyc(n), where q(n) is the largest prime-power divisor of n; or
> - n is odd and n = 2^j + m, with m a prime power and both C(2^j, 2) and C(m, 2) greater than δ_cyc(n)·C(n,2).
>
> Then **μ\*_cyc(n) < δ_cyc(n)·C(n,2) for every n ∉ E**, and #(E ∩ [1, N]) = O(N/log N).
>
> *Proof.* Let G be an Oliver group on n points. G is solvable, since its Oliver chain has p-group, cyclic and q-group factors, and so is each of its constituents. The rescoring changes only the orbitals inside one prime orbit R, which count C(r,2). So it is enough to find an orbital of size below δ_cyc·C(n,2) inside some orbit other than R, or to bound C(r,2). Throughout, C(sn, 2) < s²·C(n,2) for 0 < s < 1. An orbit that is a single point is joined to the rest by an orbital of at most n − 1 edges, which is below δ_cyc·C(n,2) for n ≥ 12 (smaller n are covered by the table check below). So assume every orbit has at least two points.
> - *G transitive.* R would be the whole vertex set, so n would be prime, which is excluded. By `orbital-evasiveness-notes.md` §7.2 fact 8, G has an orbital of at most n(q(n) − 1)/2 edges. That is at most (q(n) − 1)/(n − 1) of C(n,2), and this is below δ_cyc unless n ∈ E by the first clause.
> - *Three or more orbits.* The smallest orbit has share s ≤ 1/3, and an orbital inside it has fewer than s²·C(n,2) ≤ C(n,2)/9 edges. Either way this is below δ_cyc.
> - *Two orbits, sizes a + b = n.* Every orbital inside an orbit has at most C(a,2) or C(b,2) edges. At even n, min(a, b) ≤ n/2 gives an orbital below C(n,2)/4. At odd n, suppose the constituent on an orbit O ≠ R is not 2-homogeneous. Then O carries at least two orbitals, so one has at most C(|O|,2)/2 edges. The score is then below min(s₁²/2, s₂²)·C(n,2) ≤ (3 − 2√2)·C(n,2), the maximum of that minimum over s₁ + s₂ = 1. Otherwise each orbit is R or carries a solvable 2-homogeneous group. A solvable 2-homogeneous group has prime-power degree: it is affine (Huppert) or lies in AΓL(1, q) (Kantor). So a and b are prime powers summing to an odd n, one of them is 2^j, and the score exceeds δ_cyc only under the second clause of E.
>
> The count: by fact 8's own remark, {n : n/q(n) ≤ 5} lies in the union of F·{prime powers} for F ≤ 5, which is O(N/log N). The second clause confines 2^j to the window (0.414 n, 0.586 n). The geometric-sum count of `arithmetic-of-density.md` §4.3 then gives O(N/log N), and prime powers m that are not primes add only O(√N). ∎

So the upper half needs neither the classification nor any hypothesis. Prime powers m cover the device's prime r. The proposition uses the Oliver condition only through solvability.

> **Proposition L (conditional on (BH-SW) of `bcp-to-floor.md` for the pairs {Q, dQ + 1}, d ∈ {2, 4, 6, 12}).** For every ε > 0 and A > 0, **μ\*_cyc(n) ≥ (δ_cyc(n) − ε)·C(n,2) for all but O(x/(log x)^A) of the n ≤ x.**
>
> *Proof.* This is the route of `bcp-to-floor.md` §§2–4, with the foreign orbital rescored.
> - *The group.* The Reduction Lemma's group Γ = (𝔽_p^k ⋊ ⟨g⟩) × (C_r ⋊ C_Q), with k ∈ {1, 2}, r = dQ + 1 and Q the top prime. Its foreign block carries d/2 orbital classes. Under the reduction lemma (§4, box after the cost table), k = d/2 ∈ {1, 2, 3, 6} is good for every top prime Q ∉ {2, 5, 7}.
> - *The score.* The score is at least min{k·C(p,2), p²·[k = 2], k·p·r, C(r,2)}. The intra-block and cross orbitals are as in that Lemma, and the foreign orbital is now C(r,2) instead of rQ.
> - *The window.* In the Lemma's variables the objective is min{u²/k, 2αu, α²}. It balances at u = √k·α, where the cross term 2√k·α² ≥ α² does not bind, and gives 1/(1 + √k)²: 1/4 at k = 1 and 3 − 2√2 at k = 2.
> - *The cells.* The Local Lemma's two pins act unchanged. Parity forces k odd at even n and k even at odd n. The residue mod 4 then fixes d mod 4, and at n ≡ 11 (mod 12) the mod-3 pin needs 3 | kd. The cheapest feasible cell at each class is:
>   - (1, 2) at n ≡ 0, 4, 6, 10 (mod 12) and (1, 6) at n ≡ 2, 8;
>   - (2, 2) at n ≡ 1, 9; (2, 4) at 3, 7; (2, 6) at 5; and **(2, 12) at 11**.
>
>   Here δ depends on k alone, unlike the μ\* objective, so the cheapest cell takes the least k the parity allows.
> - *The circle method.* §§4 and 9b of `bcp-to-floor.md` go through verbatim. They use only k ∈ {1, 2, 4}, d ∈ {2, 4, 6, 12}, a window of positive measure, and solvability of the local congruences. §9b's uniform lower bound for the singular series is stated for all of those (k, d).
>
> Each of these cells lies in the grid that §7 of `bcp-to-floor.md` already checks. ∎

> **Corollary (conditional on (BH-SW)).** μ\*_cyc(n)/C(n,2) → δ_cyc(n) on a set of n of density 1: the limit is **1/4 along even n and 3 − 2√2 along odd n**, outside a set of size O(N/log N). Under the all-large-n form of the supply hypothesis at the cells above, a (BCG-AL) for the cyc cells, the lower bound holds at every large n. The exceptions are then exactly E, where the value can be higher but not lower.

*Checked* (`cyc_density_one.py`).
- **Proposition U against the exact table.** Of the 3,410 rows to 4000, 884 are in E and 792 of those reach δ_cyc. **No row outside E reaches δ_cyc.**
- **Size of E.** Its share of the domain is 33.9%, 23.1%, 16.2% and 13.0% at N = 10³, 10⁴, 10⁵ and 10⁶. That is |E| ≈ 1.7·N/log N, about three quarters transitive, so the decline is logarithmic, as in `arithmetic-of-density.md` §4.3.
- **The Local Lemma** is solvable at all six cyc cells, every class, modulo 16, 9, 5, 7, 11 and 13.
- **The lower bound, by direct search.** Over every n in a sample interval, the best Reduction-Lemma representation is scored for μ\*_cyc as a fraction of δ_cyc·C(n,2):

| n in | worst fraction | n below 0.95 |
|---|---|---|
| (10⁵, 10⁵ + 600] | 0.906 | 12 |
| (10⁶, 10⁶ + 1200] | 0.978 | 0 |
| (10⁷, 10⁷ + 600] | 0.9965 | 0 |

*Not checked.* The transfer of `bcp-to-floor.md`'s analysis rests on reading which of its steps use the window and the cell. That analysis has had one independent recheck (its §9), at the μ\* cells, not at the cyc cells.

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

**The floor on a longer range** (`cyc_floor_scan.py`). A row whose μ\* is already 0.12·C(n,2) cannot lower a floor below 0.12, so only the rows under that line are examined — 12,529 of the 90,299 to 10⁵, of which 12,519 are lifted — each over the shapes n = Fc + r with F ∈ {1, 2, 3, 4, 5, 6, 8}. The figures are lower bounds for μ\*_cyc; on the rows shared with `threshold_scan.py` the two scans agree.

| n | least μ\*/C(n,2) | at | least lower bound for μ\*_cyc/C(n,2) | at |
|---|---|---|---|---|
| 6 – 99 | 0.1043 | 99 | at least 0.12 | — |
| 100 – 999 | 0.0570 | 527 | 0.0938 | 923 = 5 × 128 + 283 |
| 1000 – 9999 | 0.0462 | 2759 | 0.0972 | 5219, not lifted |
| 10⁴ – 10⁵ | 0.0583 | 22139 | 0.1016 | 15515 = 4 × 2473 + 5623 |

So **the infimum of μ\*_cyc(n)/C(n,2) over n ≤ 10⁵ is 0.09378, at n = 923**. μ\*'s own floor is 0.0462, at n = 2759. The value at 923 is exact, because U meets the scan there. n = 1159, the floor under the rule for good types first used, is lifted to 79,806 = 2·C(283,2) (density 0.1189) by a trivial-top foreign block of 593: k = 296, good by the reduction lemma (box after the cost table; built in GAP). *Above 10⁵, a partial run only:* the 99,295 rows of (10⁵, 10⁶] with μ\* below 0.11·C(n,2) were examined and all were lifted, the least to 0.1396 at n = 130067, with medians 0.170 to 0.171 against the limit 3 − 2√2 = 0.1716 and the ten lowest all at n ≡ 11 (mod 12). Rows with μ\* between 0.11 and 0.14 were not examined, so for that decade only "at least 0.11" is established.

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

*Proof.* Let P omit K_{a,b}. The orbitals outside the foreign block are F·K_c, unions of K_{c,c} over block pairs, and K_{Fc,r}; each contains K_{a,b}, so none lies in P, and no face of Δ_P^Γ uses one. The union of all k foreign classes is K_r, which contains K_{a,b}, so the full simplex on the k classes is not a face. Δ_P^Γ is therefore a proper complex on the k classes, invariant under the multiplier that cycles them (`orbital-evasiveness-notes.md` §9.7), and by hypothesis its χ is not ≡ 1 (mod q). ∎

Nothing is asked of the individual classes, and the hypothesis on P is membership of one graph, not an edge count: the property may be dense. The same proof gives every bipartite graph on at most min(c, r) vertices, as a subgraph of such a biclique.

Write **s\*_N(n)** for the largest smallest-block over groups each of whose minimal blocks is 2-homogeneous or carries a good type. Then s(n) ≤ s\*_N(n), and a non-evasive property contains K_{a,b} whenever a + b ≤ s\*_N(n). *This is a sufficient region only.* The triangle of `orbital-evasiveness-notes.md` §9.7 is exact for the non-void argument; no upper bound for what the χ rung requires is claimed here.

**Smallest instance, built.** n = 21 = 8 + 13 with q = 3 is the first n at which a qualifying block improves on s(n). The orbitals are K₈ (28 pairs), K₈,₁₃ (104) and two classes of 39 on the 13 points, each 6-regular. k = 2, where the only proper invariant complexes are empty or two points. So a non-evasive property on 21 vertices contains K_{a,b} for a + b ≤ 8, against s(21) = 7 from 3 × 7.

**Predicted limits.** The fusion count needed is the one in §5's right-hand column, so only parity enters: with c ≈ r ≈ n/(F + 1),

| n mod 12 | 0, 4, 6, 10 | 2, 8 | 1, 9 | 3, 7 | 5 | 11 |
|---|---|---|---|---|---|---|
| s(n)/n → | 1/2 | 1/4 | 1/3 | 1/5 | 1/7 | 1/13 |
| lower bound for s\*_N(n)/n → | 1/2 | **1/2** | 1/3 | **1/3** | **1/3** | **1/3** |

At the balanced point a = b the constant moves from 1/26 to 1/6 at the worst class. *Standing:* the top row is `orbital-evasiveness-notes.md` §9.7's, conditional on supply as stated there; the bottom row is the same arithmetic with qualifying blocks admitted, conditional on the same kind of supply, and a lower bound.

**On the table, to n = 10⁴** (`biclique_boost_scan.py`; new groups from the shape n = Fc + r only, so the boosted figures are lower bounds for s\*_N). 5,627 of 9,995 values of n improve. The smallest ratio s/n is 0.0702 on [6, 1000] (at 527) and 0.0678 on [1000, 10⁴] (at 6887); boosted, the smallest ratios are 0.2387 (at 155 = 2 × 59 + 37) and 0.2073 (at 1703 = 2 × 353 + 997). The floor case 2759 goes from 271 to 881 (2 × 881 + 997, k = 6, q = 83). Medians over [5000, 10⁴] by class:

| n mod 12 | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| s/n | 0.490 | 0.331 | 0.250 | 0.198 | 0.490 | 0.213 | 0.490 | 0.200 | 0.246 | 0.330 | 0.496 | 0.195 |
| boosted | 0.497 | 0.332 | 0.497 | 0.332 | 0.495 | 0.331 | 0.496 | 0.330 | 0.490 | 0.332 | 0.498 | 0.330 |

The boosted medians sit at the predicted 1/2 and 1/3. The minima do not yet: class 11 has minimum 0.232 on that range, since supply rarely hits c = r. The admitted block has k = 2 through 8 at the improved rows (k = 3 most often, at 1,782; k = 8 at 29, which rest on the crude rule q > 2^k). Two rows come from entangled groups (§5): n = 63, from 17 to 31, and n = 15 = 8 + 7, from 5 to 7. At n = 15 the block has k = 1 — AΓL(1, 8) on 8 + 7 points has orbitals K₇, K₈ and K₈,₇ — so the group is structured in `orbital-evasiveness-notes.md` §9.7's own sense and s(15) ≥ 7: `biclique_table.py` does not enumerate entangled groups.

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

| n | μ\*(n) | ν\*(n) | ν\*_fpf(n) = μ\*_N^fpf(n) | G\*(n) | μ\*_N(n) | how |
|---|---|---|---|---|---|---|
| 6 | 6 | 6 | 6 | 6 | **6** | all 50 classes; G\* by exhaustion (`global_chi_min.py`) |
| 10 | 20 | 20 | 20 | 20 | **20** | all 1,294 classes; G\* ≥ 20 from ℤ/5, ≤ 20 by a property: subgraphs of 2K₅ and 2,121 classes of at most 10 edges; Smith checked at 366 p-groups |
| 12 | 18 | 18 | 18 | 11 | **18** | all 8,572 classes of S₁₂; G\* ≥ 11 from ℤ/11 and from exhaustion to 10 edges, ≤ 11 by a property: stars and 972 classes of at most 9 edges; Smith checked at 1,919 p-groups with at most 11 orbitals, and at 2,239 with at most 12 |
| 14 | 42 | ≤ 42 | 42 | 42 | **42** | Corollary; G\* ≥ 42 from the translations of two blocks of 7, ≤ 42 by a property: subgraphs of 2K₇ and of K₁,₁₃ and 74 classes of at most 12 edges; χ recomputed over 544,727 classes; Smith checked at 44 odd p-groups |
| 18 | 72 | ≤ 72 | 72 | 18 | **72** | Corollary; G\* ≥ 18 from the translations of two blocks of 9, ≤ 18 by a property: subgraphs of 6K₃, stars, and 32 classes of at most 7 edges; Smith checked at 284 p-groups (3-groups sampled) |
| 15 | 30 | not known | not known | 7 | ≥ 30; G\* is not the deciding term | G\* by exhaustion (`global_chi_min.py`, every s < 7 infeasible); the Smith bound 7 comes from ℤ/7 on two 7-cycles with a fixed point (`pgroup_levels_explicit.py`) |
| 21 | 63 | not known | not known | 14 | ≥ 63; G\* is not the deciding term | G\* ≥ 11 by exhaustion and ≥ 14 from the translations of three blocks of 7. G\* ≤ 14 by a property: the subgraphs of C₇(1,2) and of 2C₇, together with 147 classes of at most 10 edges (`global_chi_forced.py circ`). Smith is checked at 7 hand-picked p-groups |
| 22, 26, 34, 38, 46, 50 | m(m − 1) | ≤ m(m − 1) | m(m − 1) | not known | max(μ\*, G\*) | Corollary |

So **μ\*_N = μ\* at n = 6, 10, 12, 14 and 18**, and the N level adds nothing there. The fixed-point-free column is squeezed: μ\* ≤ μ\*_cyc ≤ μ\*_N^fpf ≤ ν\*_fpf ≤ ν\*, and ν\* = μ\* at every row, so μ\*_N^fpf = ν\*_fpf = μ\* at all of them, n = 22 to 50 included. Wherever G\* is unknown, μ\*_N is therefore decided by fixed points alone. G\* is below μ\* at 12 and 18 and equal to it at 6, 10, 14: the rung χ = 1 and Oliver-resistance are not comparable, and their projections cross. *The search needs the right forced graph and enough room in D:* at n = 14 with D of at most 10 edges, and at n = 18 with the star alone forced, the congruence modulo 9 has no solution.

**At odd n, G\* is far below μ\*.** G\*(15) = 7 against μ\*(15) = 30, and G\*(21) = 14 against μ\*(21) = 63, so at both n the trivial group is nowhere near the deciding term. The Smith constraints are weak at odd n. A cyclic p-group's orbitals come in types whose counts are easily ≡ 1 (mod p): for ℤ/5 on three 5-cycles, the six intra-block 5-cycles already give χ = 6 ≡ 1 (mod 5) at budget 5. So the binding groups are elementary abelian groups of translations on blocks.
- At n = 21, ℤ/7³ forces a property to contain both C₇(1,2) and 2C₇. Its Smith complex needs all 9 intra-block 7-cycles and all 36 pairs of them, giving χ = 9 − 36 ≡ 1 (mod 7), and nothing larger.
- At n = 33, ℤ/11³ gives G\*(33) ≥ 33 (against μ\*(33) = 165), forcing C₁₁(1,2) + C₁₁ and C₁₁(1,3) + C₁₁. The matching upper-bound search did not finish: listing the subgraphs of those 33-edge forced graphs took more than half an hour.

> **Observation (Smith-tightness of G\*).** At every n where G\* is known (6, 10, 12, 14, 15, 18 and 21), G\*(n) equals the largest Smith bound over its p-subgroups. If that holds in general, then G\*(n) ≤ max(μ\*_N^fpf(n), n − 1, G\*(a) for a < n). Each Smith bound s_Q is m\*_N(Q) for a p-group Q, which is at most μ\*_N^fpf(n) when Q has no fixed point and at most G\*(a) when Q fixes a ≥ 2 points. **That is not enough to conclude, and an induction on n does not close it.** μ\*_N^fpf(n) is far from monotone in n. It follows μ\*'s parity and escape fluctuations: μ\*(14) = 42 but μ\*(15) = 30. So G\*(a) at a good degree a < n can exceed μ\*_N^fpf(n) at a worse n.

What would close it is a bound that uses the moved points as well: for Γ fixing a ≥ 2 points, m\*_N(Γ) ≤ max(μ\*_N^fpf(n), n − 1). Two constraints bear on this, besides G\*(a):
- the fixed block has share a/n, and its own types are capped by G\*(a);
- the pairs inside the moved part, and between it and the fixed block, form their own types.

That is the Σ√F bookkeeping of Proposition U with the fixed block as one part, and it has not been worked out. Only with it in hand would Smith-tightness, Conjecture P and (BH-SW) give **μ\*_N μ\*_cyc's asymptotics outright**. This is an observation from seven values, not a conjecture with a mechanism behind it. The upper-bound side would need a general construction of χ = 1 properties sitting exactly at the Smith bound.

**The Smith bound, and its size for translations of blocks.** For a p-subgroup Q ≤ S_n, let s_Q be the least B at which some N\*(Q)-invariant complex on Q's orbitals, every face of total at most B, has χ ≡ 1 (mod p). In other words, s_Q = m\*_N(Q) under Q's own condition. Write **S(n) = max over p-subgroups Q of s_Q**. Smith's theorem gives **G\*(n) ≥ S(n)**, and the observation above says equality has held at every n computed.

*The class complex.* Let Q = (ℤ/p)^k translate k blocks of p points independently, p ≥ 5 prime, and write h = (p − 1)/2.
- **Orbitals.** Q has h difference classes in each block, of p pairs each, and one cross orbital of p² pairs for each pair of blocks.
- **N\*(Q).** The group fixing every orbital is Q̂ = D_p^k. On a block, the permutations preserving every circulant C_p(d) form D_p. So N\*(Q) = N(Q̂) = AGL(1, p) ≀ S_k, which acts on the kh classes as C_h ≀ S_k, with the multipliers ℤ_p^\*/{±1} regular on each block's classes.
- **The reduction.** Below budget p² no face can hold a cross orbital. So s_Q = p·j, where j is the least face size for which a (C_h ≀ S_k)-invariant complex on kh points reaches χ ≡ 1 (mod p). If no j < p works, s_Q ≥ p².

> **Proposition B (two blocks).** For Q = (ℤ/p)² on two blocks of p, s_Q = 2p for every prime p ≥ 11. The small primes give s_Q = 6, 20, 42 at p = 3, 5, 7.
>
> *Proof.*
> - *j = 1 fails.* An invariant complex with one class per face must contain all 2h = p − 1 classes, so χ = p − 1 ≢ 1.
> - *The j = 2 complexes.* With all vertices and some edges, the edges come in invariant families:
>   - a family of all pairs at a given difference ±δ ∈ C_h within each block, of size 2h, for 1 ≤ δ < h/2;
>   - at δ = h/2 when h is even, a family of size h;
>   - the cross-block family, of size h².
>
>   So χ = 2h − 2h·x − h·y − h²·z, with 0 ≤ x ≤ ⌊(h − 1)/2⌋ and y, z ∈ {0, 1}.
> - *The congruence.* Modulo p, 2h ≡ −1 and h² ≡ 1/4. So χ ≡ 1 becomes x + y/2 − z/4 ≡ 2 (mod p).
> - *Large p.* For p ≥ 11, h ≥ 5 and x = 2, y = z = 0 is allowed. That gives an explicit complex with s_Q ≤ 2p, and j = 1 failing gives the reverse.
> - *Small p.* At p = 5 and 7 no choice of (x, y, z) works. ∎

*Computed, for more blocks* (`smith_blocks.py`; `outputs/smith_blocks.txt`). This is the least j for k blocks of p, with s_Q = p·j:

| k | p = 3 | 5 | 7 | 11 | 13 | 17 | 19 | 23 | 29 | 31 | 37 | 41 | 43 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 2 | 2 | 4 | 6 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 |
| 3 | ≥ p | 1 | 2 | 3 | 2 | 3 | 3 | 3 | 2 | 3 | 3 | 2 | 3 |
| 4 | 1 | 3 | 3 | 3 | 2 | 2 | 3 | 3 | 2 | 3 | 2 | 2 | 3 |

The p = 3 column runs the class-complex model at p = 3, where the proof's N\*(Q) argument does not apply. The (k = 2, p = 7) entry is 6 from `pgroup_levels.py`; the script, capped at j = 4, reports more than 4. Seven entries were rechecked by `pgroup_levels.level()` on the orbitals themselves: (k, p) = (2, 3), (2, 5), (2, 7), (2, 11), (3, 5), (3, 7) and (3, 11), giving 6, 20, 42, 22, 5, 14 and 33.

**So for p ≥ 11 every entry has j ≤ 3, and these groups give a Smith bound of at most 3p ≤ 3n/k.** That is linear in n, against μ\* ~ n².
- **Where the quadratic values come from.** They are the small-prime cases (p ≤ 7, two blocks): there are too few classes to correct the residue below the top of the skeleton.
- **What this does not cover.** Other p-subgroups: iterated-wreath Sylow subgroups, mixed block sizes, groups with fixed points. Their s_Q is bounded only by μ\*_N(n).

> **Proposition B′ (any number of blocks, large p).** Let Q = (ℤ/p)^k translate k ≥ 2 blocks of a prime p ≥ 37 with p ∤ k. Then **p ≤ s_Q ≤ 3p**, and s_Q = p exactly when k ≡ −2 (mod p).
>
> *Proof.*
> - *The complex.* Take every class, every pair of classes within a block, and t generic within-block triangle families.
>   - A family is the set of translates, in every block, of a triple of classes {a, b, c} whose stabiliser in C_h is trivial. Each family has kh triangles, every face has at most 3 classes (budget 3p), and the complex is (C_h ≀ S_k)-invariant and closed, since all within-block edges are present.
>   - There are G(h) = (C(h,3) − [3 | h]·h/3)/h ≥ (h − 1)(h − 2)/6 − 1 generic families, and this is at least p − 1 = 2h once h ≥ 18, that is p ≥ 37.
> - *The congruence.* χ = kh − k·C(h,2) + t·kh. Since p ∤ kh, the congruence χ ≡ 1 (mod p) has a solution t ∈ [0, p − 1] ⊆ [0, G(h)].
> - *The rest.* The lower bound p is the size of every orbital. j = 1 works exactly when kh ≡ 1, that is k ≡ −2 (mod p). ∎
>
> *Checked* (`smith_blocks.py --construct`):
> - the congruence and t ≤ G(h) for every prime 37 ≤ p < 400 and 2 ≤ k < min(p, 61);
> - G(h) by enumeration at h = 18, 20, 21, 30;
> - the complex built explicitly, its faces counted, and closure and invariance tested, at (k, p) = (2, 37), (3, 41), (5, 43) and (7, 53).
>
> Further CP-SAT runs at (k, p) = (5, 37), (6, 37), (5, 41), (7, 41), (5, 43) and (6, 47) give j = 3, 2, 2, 3, 2, 3, so the bound 3p is sometimes attained.

*Small primes.* For a fixed p and j ≤ J, the invariant families of faces with at most J classes are determined by their pattern: a multiset of parts, one per block met, each a nonempty subset of C_h up to translation. With r parts, multiplicities m_c and part stabilisers s_i, a family has

  k(k − 1)⋯(k − r + 1)/∏ m_c! · ∏ h/s_i

faces. When every m_c < p this is periodic in k mod p, and the list of patterns is the same for every k ≥ J.

`smith_families.py` works on these families rather than on faces, so k is unrestricted. It reproduces `smith_blocks.py` at ten (k, p) pairs. For every prime 5 ≤ p ≤ 31 it computes j for every k from 2 to 8 + p with p ∤ k (`outputs/smith_families.txt`). That covers a full period beyond k = 8, and the least j it finds is below 8 and below p every time, so periodicity applies:

| p | 5 | 7 | 11 | 13 | 17 | 19 | 23 | 29 | 31 |
|---|---|---|---|---|---|---|---|---|---|
| largest j over all k with p ∤ k | 4 | 6 | 5 | 6 | 3 | 3 | 3 | 3 | 3 |
| k where it occurs | 2, 7, 12 | 2, 9 | 12 | 14 | many | many | many | many | many |

*p = 3* falls outside the class-complex argument: a block's single orbital is K₃, so N\*(Q) = S₃ ≀ S_k acts on one class per block. The only invariant families are the r-subsets of blocks, so an invariant complex below budget 9 is a skeleton, with χ = 1 − (−1)^J·C(k − 1, J). This is ≡ 1 (mod 3) at J = 1 when k ≡ 1, and at J = 2 when k ≡ 2. So s_Q ∈ {3, 6} whenever 3 ∤ k.

> **Proposition B″.** For the translations of k ≥ 2 blocks of a prime p ≥ 3 with p ∤ k: **s_Q ≤ 6p ≤ 3n.**
> - **p ≥ 37:** Proposition B′, an explicit construction.
> - **5 ≤ p ≤ 31:** the family computation with its periodicity, a computer check.
> - **p = 3:** the skeleton formula.

*Blocks with p | k* (so p² | n, n ≥ p²) are not covered.
- **The lower bound.** Every family with fewer than p parts has size ≡ 0 (mod p), since p divides k(k − 1)⋯(k − r + 1)/∏ m_c! for r < p. So χ ≡ 0 below budget p², and s_Q ≥ p².
- **Why the cost is about p².** A family with nonzero residue must be fixed by a Sylow p-subgroup of S_k, so it spreads over a whole p-cycle of blocks. One class in each of those p blocks already costs p·p = p², and from budget p² on, cross orbitals of p² pairs enter as well.
- **One data point:** k = 6 blocks of 3 (n = 18) gives s_Q = 18 = 2p², from `pgroup_levels.level()` on the orbitals.
- **The guess** is s_Q = O(p²) ≤ O(n), but there is no construction.

*Other p-subgroups: a survey* (`smith_pgroups.g`, `smith_pgroups.py`; `outputs/smith_pgroups.txt`). Two sets of groups, with s_Q from `pgroup_levels.level()` on the orbitals, using nauty for N\*:
- **Sylow subgroups.** The Sylow p-subgroup of S_n at 28 pairs (n, p) with n ≤ 96. These are iterated wreath products on mixed block sizes, with up to 22 orbitals.
- **Random subgroups.** 429 random subgroups of those Sylow subgroups, at 26 pairs with n ≤ 44, kept when they have at most 18 orbitals.

The findings:
- **Every value is at most 3n.** The maximum of s_Q/n is 3, at n = 14: two blocks of 7, s_Q = 42 = μ\*(14). Next comes 2n, at n = 10 (two blocks of 5) and n = 50 (the Sylow 5-subgroup on 25 + 25, s_Q = 100).
- **Sylow subgroups bind weakly.** For p = 2 they give at most 16 (at n = 96), and the p = 3 values sit at 3, 6, 9 or 18, up to 54 at n = 54.
- **The largest value per n always comes from translations of equal prime blocks**, the case Propositions B to B″ cover. The exception is n = 50, where the Sylow 5-subgroup gives 100 against 2·25 from two blocks of 25.

**This supports S(n) = O(n) beyond the translation families, but only weakly.** The random groups are biased toward few orbitals, which means large groups, and the Sylow list is one group per (n, p). No family seen grows faster than linearly.

> **If S(n) = O(n) and G\* is Smith-tight,** the monotonicity gap above disappears for large n. Each group fixing a ≥ 2 points has m\*_N ≤ G\*(a) = O(n), far below δ_cyc(n)·C(n,2), and one fixed point gives at most n − 1. So μ\*_N = μ\*_N^fpf for all large n, and with Conjecture P and (BH-SW), μ\*_N has μ\*_cyc's asymptotics. Both hypotheses are open. For the first, Propositions B and B′ prove s_Q ≤ 3p ≤ 3n/2 for the translations of blocks of a prime p ≥ 37 with p ∤ k. Proposition B″ extends this to every p ≥ 3 with p ∤ k, at s_Q ≤ 6p ≤ 3n. Still open for it: p | k, and every other p-subgroup.

**ν\* is not μ\* in general.** At n = 30 take AGL(1, 16) on 16 points, fixing the other 14. Its types are the 91 single edges among the fixed points, K₁₆ (120) and the 14 stars (224), so m\*_typ = 91 > μ\*(30) = 78. But the first type carries all of S₁₄, and the invariant complexes on it are the graph properties on 14 vertices: m\*_N of this group is at most G\*(14). In general **m\*_N(Γ) ≤ G\*(a) when Γ fixes a ≥ 2 points**, so the N level at n feeds on G\* at smaller degrees, and ν\* overstates it.

**The fixed-point-free part.** ν\* mixes two things: groups with fixed points, whose excess is G\* at a smaller degree, and the gap between m\*_typ and m\*_N. Separate the first:

- **μ\*_N^fpf(n)** = the largest m\*_N(Γ) over Oliver groups Γ on [n] with no fixed point.
- **ν\*_fpf(n)** = the largest m\*_typ(Γ) over the same groups.

Then

> **μ\*_cyc(n) ≤ μ\*_N^fpf(n) ≤ ν\*_fpf(n) ≤ ν\*(n)**, and **μ\*_N(n) = max( μ\*_N^fpf(n), the largest m\*_N(Γ) over Γ with a fixed point )**.

The first inequality holds because the witnesses of μ\*_cyc, the shapes F·c + r, have no fixed point. In the second term, a group fixing a ≥ 2 points contributes at most G\*(a). A group fixing exactly one point x has its pairs at x forming a union of orbitals, and N\* permutes its fixed points, so it has a type of at most n − 1 pairs. So:

> **μ\*_N(n) ≤ max( μ\*_N^fpf(n), n − 1, max over 2 ≤ a ≤ n of G\*(a) )**,

and everything about μ\*_N beyond the fixed-point-free part is G\* at some degree. *(`nstar_types.py`: ν\*_fpf = ν\* = μ\* at n = 6 and 10, over 33 and 851 fixed-point-free classes.)*

**What the ceiling argument gives at the type level.** Write δ_cyc(n) = 1/4 at even n and 3 − 2√2 at odd n, and let E be the exceptional set of §5's Proposition U.

*Step 1: Γ̂ has Γ's orbits, and N\* permutes them.* Let Γ be fixed-point-free, and take a Γ-orbit O. An orbital inside O has O as its set of vertices. Γ̂ fixes that orbital, so it maps O to itself. So Γ̂ ⊇ Γ has exactly Γ's orbits, and its orbits on pairs are Γ's orbitals. N\*(Γ) = N(Γ̂) permutes the orbits of its normal subgroup Γ̂.

*Step 2: a 2-homogeneous type forces a prime power.* Suppose some type takes in all the pairs inside an orbit O. Then N\*_O, the stabiliser of O, acts 2-homogeneously on O, and Γ̂^O is a nontrivial normal subgroup of that action.
- If N\*_O^O is affine, |O| is a prime power.
- Otherwise N\*_O^O is almost simple, and Γ̂^O contains its socle.
  - The socle is 2-homogeneous. This holds for every 2-homogeneous almost simple group except PΓL(2,8) on 28 points. That is checked over all primitive groups of non-prime-power degree up to 877 (`socle_2homog_check.g`, natural A_a and S_a skipped), and holds in the infinite families by their standard actions. So Γ̂^O, and hence Γ, has a single orbital on O, and solvability makes |O| a prime power.
  - In the PΓL(2,8) case, the three socle orbits of 126 are the orbitals of no soluble group (the paragraph above).

*Step 3: Γ intransitive.* Group Γ's orbits into N\*-classes, class i holding F_i orbits of size a_i. Then:
- The pairs inside the orbits of a class are N\*-invariant, with total F_i·C(a_i,2). So some type has at most min over i of s_i²/F_i of C(n,2), where s_i is the class's share of the points. This is at most 1/(Σ√F_i)², as in the feasibility criterion.
- If those pairs split into two or more types, the bound halves.
- Exceeding δ_cyc needs Σ√F_i < 2 at even n, or < 1 + √2 at odd n, with no splitting.
- By Step 2, that leaves:
  - a single class (n = F·a, a a prime power, F ≤ 5). Its type total is at most (q(n) − 1)/(n − 1) of C(n,2), below δ_cyc off E.
  - two classes at odd n, each a single orbit of prime-power size, which is E's second clause.
  - The pair Σ√F = √2 + 1 is the boundary, and gives strictly less.

*Step 4: Γ transitive, N\* imprimitive.* Take any block system of N\*, with m blocks of size b.
- The intra-block pairs are N\*-invariant, with total n(b − 1)/2. That is below 1/m of C(n,2), so it settles m ≥ 4 at even n and m ≥ 7 at odd n.
- For m = 2 or 3 (even n) and m = 3 or 5 (odd n): if N\*'s action on a block is not 2-homogeneous, the intra-block pairs split, and the smaller part is below 1/(2m) of C(n,2).
- If it is 2-homogeneous, Step 2 runs with the block in place of an orbit. Γ̂_B^B is normal and transitive, and pairs inside B lying in one Γ-orbital means Γ_B is 2-homogeneous on B. So b is a prime power, and the bound (b − 1)/(n − 1) ≤ (q(n) − 1)/(n − 1) applies.

*Step 5: Γ transitive, N\* primitive.* If N\* is affine, or 2-homogeneous, then n is a prime power, by the paragraph above. What remains is **N\* primitive with non-abelian socle, of rank at least 3**. Its smallest orbit on pairs is at most 1/(rank − 1) of C(n,2), and nothing here makes that small.

> **Conjecture P.** A soluble transitive Oliver group Γ of non-prime-power degree has m\*_typ(Γ) ≤ n(q(n) − 1)/2. This is `orbital-evasiveness-notes.md` §7.2 fact 8, lifted from orbitals to types. Only Step 5's case is open: the other steps give δ_cyc off E, which is all that is used below.
>
> *Checked* (`nstar_transitive_check.g`, `nstar_transitive_check.py`; `outputs/nstar_transitive_check.txt`): every soluble transitive group of degree 6, 10, 12, 14, 15, 18, 20, 21, 22, 26, 28 and 30, which is 7,315 groups. Degree 24 was not run. **None exceeds the bound, and the maximum attains it at every degree.** Soluble is a superset of Oliver, so this over-tests.

> **Proposition U\_typ (unconditional for intransitive Γ and for transitive Γ with N\* imprimitive; for the rest, conditional on Conjecture P or on Step 5 at δ_cyc).** For n ∉ E, ν\*_fpf(n) < δ_cyc(n)·C(n,2).

> **Corollary (conditional on (BH-SW) and Proposition U\_typ).** μ\*_N^fpf(n)/C(n,2) and ν\*_fpf(n)/C(n,2) tend to 1/4 along even n and 3 − 2√2 along odd n on a set of density 1. The lower bound is Proposition L through μ\*_cyc ≤ μ\*_N^fpf.
>
> **So the N level splits cleanly.** Its fixed-point-free part has the asymptotics of μ\*_cyc, though computing it still needs every subgroup of S_n. Any asymptotic excess of μ\*_N over μ\*_cyc comes from groups with fixed points, that is, from G\* at degrees up to n.

**Small n: no separation, μ\*_N^fpf = ν\*_fpf = μ\*_cyc.** An upper bound read off orbit data alone settles every non-prime-power n ≤ 46 (`fpf_upper.py`; for n = 40, `nstar_t40_export.g` and `nstar_t40.py`).
- **The bound.** Take a fixed-point-free Oliver group Γ and an orbit O of size a. Elements of N\*(Γ) that fix O carry Γ^O's orbitals to orbitals, so on O they lie in N\*(Γ^O). Hence Γ's types inside O are refined by N\*(Γ^O)'s orbits on pairs, and some type has at most F·τ(a) pairs. Here F is the number of orbits in O's N\*-class, and τ(a) is C(a,2) for a prime power a, otherwise the largest m\*_typ over soluble transitive groups of degree a. Γ^O is soluble and transitive, so this applies.
- **The maximum.** Maximising over orbit shapes, with equal sizes merged into one class (the best case), gives U_fpf(n) ≥ ν\*_fpf(n) ≥ μ\*_N^fpf(n) ≥ μ\*_cyc(n).
- **The τ values** come from `nstar_transitive_check.py` over every soluble transitive group of degree 6 to 46 that is not a prime power. That is 7,315 groups to degree 30, 24,193 at degree 24, 118,027 at degree 36, 16,737 at the other degrees from 33 to 46 except 40, and 291,598 at degree 40. Degree 40 is handled by `nstar_t40.py`. N\* maps orbitals only to orbitals of the same size, so the orbitals of one size form a union of types. A group with a size class of total at most 140 therefore has m\*_typ ≤ 140, and nauty is run on the rest, whose largest m\*_typ is 60. In every degree, τ(a) equals fact 8's n(q(n) − 1)/2, so Conjecture P holds there too. Where a τ(a) with a < n is missing, the trivial bound C(a,2) stands in.
- **The result.** U_fpf(n) = μ\*_cyc(n) at n = 6, 10, 12, 14, 15, 18, 20, 21, 22, 24, 26, 28, 30, 33, 34, 35, 36, 38, 39, 42, 44, 45 and 46. The same holds at n = 40, where U_fpf(40) = μ\*_cyc(40) = 140 is attained by the shape 8 + 8 + 8 + 8 + 8 and τ(40) ≤ 140. The bound is attained by the transitive groups at most of these n, and by the μ\* shapes 17 + 13, 19 + 16 and 23 + 19 at n = 30, 35 and 42, and the shape 18 + 18 at n = 36. So there **μ\*_N^fpf = ν\*_fpf = μ\*_cyc** (= μ\* at all of them).

So **no n ≤ 46 separates μ\*_N^fpf from μ\*_cyc**, and at those n the type level adds nothing over μ\*. The separations μ\*_cyc > μ\* begin at n = 56, beyond this range.

**To n = 4000, given Conjecture P** (`fpf_upper_scan.py`; `outputs/fpf_upper_scan.txt`). The same bound with τ(a) = a(q(a) − 1)/2 at every non-prime-power degree a, which is Conjecture P, leaves **977 of the 3,410 rows** where U_fpf > μ\*_cyc. The other 2,433 rows have μ\*_N^fpf = ν\*_fpf = μ\*_cyc, given Conjecture P. The first gap row is n = 110.
- **Every gap row has the same kind of witness:** two orbit classes, each credited at its full intra-pair count. Typically these are two prime-power or prime blocks near the balance point, such as 49 + 61 at n = 110 or 113 + 127 at n = 240. The transitive term never exceeds μ\*_cyc.
- **What the bound ignores.** It counts orbits only. It ignores the Oliver structure, which forces a common top prime q, and goodness. μ\*_cyc already covers 2-homogeneous blocks with one rescored prime orbit, so a gap row can separate only through a two-class configuration μ\*_cyc does not cover: two rescored blocks that are jointly good, or a rescored prime-power block. The two-block searches of §11 found no such configuration to 4000.
- **What it would take to settle the 977 rows:** a level-1 version of the classification's analysis of two-class shapes, with the Oliver structure P ⊴ H ⊴ Γ imposed on both constituents.

**At the other n.** For the fifteen remaining n ≤ 50 (15, 20, 21, 24, 28, …), and at the rows where μ\*_cyc leaves μ\*, what is proved is the displayed inequality with the crude bound on ν\*: at n = 56, 351 ≤ μ\*_N ≤ max(756, G\*(56)); at n = 63, 465 ≤ μ\*_N ≤ max(976, G\*(63)) (the bound (n/2)·⌊(n − 1)/2⌋ = 976.5, rounded down since μ\*_N is an integer). Nothing bounds G\* above at these n except C(n,2).

**Two-class shapes at level 1: the prime+prime rows** (`ws_gapclose.py`, `outputs/ws_gapclose.txt`; `ws_gaprows_kinds.py`, `outputs/ws_gaprows_kinds.txt`).
- **Kinds of gap row.** Sorted by the kinds of witness they carry, the 977 gap rows fall into these groups:
  - **335** have only *prime+prime* witnesses: two single orbits of prime sizes A < B, both credited at C(·,2). The first is n = 240.
  - **106** have only *pp+pp* witnesses: prime-power blocks, not both prime. The first is n = 110.
  - **40** mix those two kinds.
  - **496** have a witness with a merged class (several orbits of one size) or a non-prime-power block credited τ(a). Eight of these have three-class witnesses.
- **The configurations.** Each prime+prime witness gives Γ = (T_A ⋊ M_A) × (T_B ⋊ M_B), with twists of orders dA | A − 1 and dB | B − 1, and kA, kB classes on the two blocks. Every pair of twists is a configuration. The cross orbital is never counted: it does not fit under the budget.
- **Γ's own readings.** An orientation (X, Y) is available when two things hold:
  - C = M_X × T_Y is cyclic, so gcd(dX, Y) = 1;
  - Γ/C ≅ M_Y is a q-group.
  
  Then P = T_X ⊴ H = P·C ⊴ Γ is an Oliver structure. The reading is exact (χ = 1) when M_Y = 1, and χ ≡ 1 (mod q) otherwise. Configurations with neither orientation available are not Oliver in this way and earn no credit.
- **The closing complexes.** On a block with k classes, take m | k and pull back from C_m acting on m points. The complex is the full (s − 1)-skeleton plus any union of C_m-orbits of s-faces, for 1 ≤ s ≤ m − 1. Here an s-face means a set of s classes. Its χ is 1 + (−1)^s·C(m−1, s−1) + (−1)^(s−1)·t, where t is a sum of orbit sizes (the orbit counts come from Möbius inversion); the formula is checked by brute force at m = 5, 6. The script uses such a complex on one side, or a disjoint union (χ = x + y) or a join (1 − χ = (1 − x)(1 − y)) of one on each side.
- **Result:** every configuration of all 489 prime pairs has a complex meeting all of Γ's readings. So at level 1, none of these configurations certifies a separation, and **the 335 prime+prime-only rows have μ\*_N^fpf = μ\*_cyc at level 1, given Conjecture P.**
  - **Which families are needed:** requiring χ = 1 exactly with skeleta only closes no pairs. Adding the readings mod q closes 240. Layered complexes and disjoint unions bring it to 487. Joins close the last 2 (n = 1632 and 3586).
  - **Readings, complete:** an orientation (X, Y) also gives a reading when p_Y divides |M_X| and M_Y = 1: take C = (p_Y′-part of M_X) × T_Y, and the reading is mod p_Y. Every pair of twists is enumerated, and a configuration with no reading is not Oliver.
- **What this rests on, and what is not shown:**
  - *Level 1* means Γ's own readings only. Subgroups' readings (the battery, §13) could only add constraints. So this settles the level-1 question, not μ\*_N^fpf itself. The level-1 criterion also asks for invariance under N\*_Γ(H); here that is the normaliser in AΓL(1, A) × AΓL(1, B), which acts on each block's classes as a cyclic group of order k.
  - The pull-back step keeps χ and invariance, as for the cyclic types elsewhere in this note.
  - Prime-power blocks are treated next, under *pp+pp rows*. The 496 rows with merged or non-prime-power classes are not handled.

**Two-class shapes at level 1: the pp+pp rows** (`ws_gapclose_pp.py`, `ws_blockdata.g`; `outputs/ws_gapclose_pp.txt`).
- **Scope:** block groups Γ_X = T_X ⋊ M_X with M_X ≤ ΓL(1, ·), that is, semilinear twists ⟨ω^c, ω^d φ^t⟩ up to conjugacy by F\*. **Affine M_X outside ΓL(1) are not covered.**
- **The readings are Γ's own, as `OliverData` computes them.** They are built from data on each block, computed by GAP for each subgroup: Q = Γ/O_p(Γ) = Q_A × Q_B, and O^q(Q) = O^q(Q_A) × O^q(Q_B), which is cyclic exactly when both factors are cyclic of coprime orders.
- **Closing complexes:**
  - on a block of rank at least 2, only full skeleta of its class simplex, which every class permutation fixes, so N\*'s action does not need to be known;
  - on a prime block, also the layered complexes above;
  - disjoint unions and joins of one complex on each side.
- **Result:** 210 witness pairs in 209 rows give 1,031,087 configurations, of which 869,741 are not Oliver. **Every remaining configuration closes, so all 210 pairs close.**
  - Before χ = 1 complexes on regular prime blocks were added, 173 configurations in 29 rows stayed open (the first at n = 368). Each had an exact reading and a prime block with trivial twist (Γ_Y = Z_p, k = (p − 1)/2 classes), so χ = 1 had to be reached exactly by a C_k-invariant complex. The layered and skeleton families do not reach it.
- **χ = 1 on a regular prime block** (`cyc_chi_one_cpsat.py`, `cyc_pullback_union.py`, `cyc_chi_one_construct.py`; `outputs/cyc_chi_one.txt`, `outputs/cyc_chi_one_construct.txt`). The question is whether a C_m-invariant proper complex on m points can have χ = 1.
  - **Exact answers for small m (CP-SAT):** no at m = 6, 10, 14, 15, 18 and 20; yes at m = 12.
  - **A Smith test.** If χ = 1, then for every prime r | m some value in V(m/r) is ≡ 1 (mod r), where V(d) is the set of χ values on d points; this is because χ(Δ) ≡ χ(Δ^{C_r}) (mod r). The test agrees with CP-SAT at all seven sizes. The failures come from small quotients: V(2) = {0, 2}, V(3) = {0, 3}, V(4) = {−2, 0, 2, 4}, and V(6) has no value ≡ 1 (mod 3). So χ = 1 is impossible whenever m has a prime factor r with m/r ∈ {2, 3, 4, 6} and no value ≡ 1 (mod r) on m/r points.
  - **Construction for a coprime split m = ab.** Take X on Z_a and Y on Z_b, both layered, and let Δ₀ be the union of their pull-backs. Then 1 − χ(Δ₀) = (1 − x)(1 − y), and the search chooses x and y so that m divides this, giving χ(Δ₀) = 1 + cm. Then add |c| free orbits of minimal non-faces, all of one size t with (−1)^(t−1) = −sign(c). Orbits of minimal non-faces of a single size can be added in any combination, so the result is a proper C_m-invariant complex with χ = 1.
    - Example, m = 99: x = 12 on Z_9 (all edges, plus four free triangle orbits and the triangle orbit {0, 3, 6}), y = −44 on Z_11 (the complete graph), χ(Δ₀) = 496 = 1 + 5·99. Then add five free orbits of minimal non-faces of size 4.
  - **Pull-back.** If d | m and a C_d-complex has χ = 1, pulling it back along Z_m → Z_d keeps χ = 1. Each face F contributes (−1)^(|F|−1) times a product over its fibres of Σ_{T ≠ ∅} (−1)^(|T|−1) = 1.
  - **The 18 open sizes are all realised:**
    - by a split at k = 99, 153, 176, 230, 410, 464, 470, 473, 483, 530, 575, 590, 615, 803, 833;
    - by pull-back at 459 (from 153), 704 (from 176) and 891 (from 99).
    
    For 704 = 64·11 and 891 = 81·11 no split works: the required x ≡ 1 (mod 64) or (mod 81) on Z_11 is out of range.
  - **How each construction is checked** (in the script, independently of the formula):
    - χ(Δ₀) is recomputed by summing over exact supports (R mod a, C mod b), using the signed count (−1)^(|R|+|C|) of matrices with those supports, which is brute-forced for small sizes;
    - each correction orbit is re-tested: it is not a face, every facet of it is a face, the orbit is free, and the orbits are distinct.
- **Rows:** all 481 gap rows whose witnesses are only prime+prime or pp+pp are **settled at level 1**, given Conjecture P. For the 146 of them with a prime-power block, this holds within the ΓL(1) scope. The 496 rows with merged or non-prime-power witnesses stay open.
- **Assumptions behind this:**
  - the budget is set aside, as elsewhere in §7: each face's edge count against T is not checked;
  - only Γ's own readings are used;
  - N\* acts on a prime block's classes as C_k.
**The budget.** m\*_N(Γ) asks for a complex with *every face of at most B edges* (§3). The closures above did not check face sizes, so they do not show m\*_N(Γ) ≤ μ\*_cyc(n). **The 481-row claim above is withdrawn: those rows are not settled.** A configuration in which every complex meeting the readings has a face of more than T = μ\*_cyc(n) edges would be a separation.
- **Where the budget bites:** only on heavy classes. A prime block with twist d has k classes of p·c/2 edges each (c = d or 2d), and a class of a prime-power block with direction set D has a·|D|/2 edges. A class heavier than T is in no face, and the cross orbital (a·b edges) never fits.
- **Prime+prime, exact where few classes fit** (`ws_budget_exact.py`; `outputs/ws_budget_exact.txt`). This is CP-SAT over every C_kA × C_kB-invariant complex whose faces fit the budget. N\* contains that group, so finding no complex would prove m\*_N(Γ) > T.
  - 1,312 configurations are small enough to decide. **Every one has a complex.** Seven needed a longer run with χ fixed to each admissible value, for example χ = 220 at n = 3216.
  - The other 84,663 have too many usable sets to search.
- **Prime+prime, by construction families with the budget** (`ws_budget_scan.py`; `outputs/ws_budget_scan.txt`). These are layered complexes, unions, and the split construction of `cyc_chi_one_construct.py`, each face checked against T.
  - All but 147 of the 85,975 configurations close.
  - The 147 lie in 48 rows. All are roomy (many usable classes), so I read them as gaps in the families, not candidates.
- **pp+pp with ΓL(1) twists, exact with no symmetry imposed** (`ws_budget_pp.py`; `outputs/ws_budget_pp.txt`), at most 14 usable classes. Allowing every complex is sound for a separation.
  - All 1,790 such configurations have a complex.
  - The other 159,556 are roomy and not budget-checked.
- **So the budget, where it is tight, never produces a separation in these shapes.** The roomy configurations are unsettled.

**Toward a proof of μ\*_N^fpf = μ\*_cyc: Lemma C** (`lemma_c_check.py`, `lemma_c_data.py`; `outputs/lemma_c_check.txt`, `outputs/lemma_c_data.txt`). A proof must give every fixed-point-free Oliver Γ a complex within budget that meets its condition. Every closure found above came from cyclic actions on the classes of a block. So the engine is a description of which χ values a cyclic action admits.
- **Setting.** C_k acts on Z_k by translation, and a complex Δ is allowed faces of at most c points. Its **data vector** is ψ(f) = χ(Δ^{C_f}) for f | k: a C_f-invariant face F is a cell of dimension |F|/f − 1, and ψ(k) = 0.
- **Two necessary conditions:**
  - **(R)** For each prime r | k, (ψ(re))_{e | k/r} is the data vector of a complex on the k/r cosets of C_r with faces of at most ⌊c/r⌋ cosets. That complex is Δ^{C_r}.
  - **(B)** Σ_{f | k} μ(f) ψ(f) ≡ 0 (mod k). The Lefschetz function is a virtual character, a Z-combination of permutation characters; the congruences for e > 1 are inside (R).
- **Prime-by-prime Smith congruences are not enough.** At k = 9 they allow χ ≡ 6 (mod 9), which never occurs. (B) excludes it: ψ(1) ≡ ψ(3) ∈ {0, 3} (mod 9).
- **Exact test, k ≤ 11 with every cap c, and k = 12 with c ≤ 5.** CP-SAT checks every vector satisfying (R) and (B) inside the realised χ range; recursively, (R) uses the *realised* quotient data.
  - Almost every such vector is realised.
  - **The exceptions all sit near the ends of the range.** Every missed vector has |ψ(1)| ≥ 8, and at least 60% of the range's end on its side. Examples: χ = 8 of [−9, 11] at k = 6, c = 3; χ = −63 of [−69, 57] at k = 9; χ = ±123, ±125 of [−125, 127] at k = 10; χ ≥ 120 of [−54, 166] at k = 12, c = 3.
  - **No vector with small |ψ(1)| is ever missed.** That is the regime the readings need: χ = 1, or χ ≡ 1 (mod Q).
- **Lemma C (conjectural, data form).** If a data vector satisfies (R) and (B), and ψ(1) is small compared with the range (say |ψ(1)| ≤ k), then some C_k-invariant complex with faces of at most c points realises it.
- **Proof route: equivariant cell attachment, from the largest stabilisers down.**
  - A cell orbit with stabiliser exactly C_f changes ψ(e) by ±k/f for every e | f, and leaves the other ψ(e) alone. Adding a minimal non-face gives one sign and removing a maximal face the other.
  - (B) and (R) say that the gap between the target data and any complex already built lies in the lattice spanned by these vectors. This is the Burnside-ring form of the Lefschetz condition.
  - So it remains to find minimal non-faces and maximal faces of each stabiliser type, of the needed parity and within the cap. That is a "room" lemma. The misses at the ends of the range are where room runs out, which is consistent with this route.
  - The split constructions and free-orbit corrections of `cyc_chi_one_construct.py` are special cases.
- **Lemma F (free adjustment; proved).** Let L be a C_k-invariant complex with faces of at most c points. Fix s ≤ c, and let A_s be the set of C_k-orbits of *free* s-sets (trivial stabiliser) that are not faces of L but all of whose proper subsets are. Then for any subfamily B ⊆ A_s, the union L ∪ ⋃B is a C_k-invariant complex with faces of at most c points. Its data agree with L's at every f > 1, and χ changes by (−1)^(s−1)·k·|B|. The same holds, with the opposite sign, when free orbits of maximal faces are removed.
  - *Proof.* L ∪ ⋃B is closed under subsets, because every proper subset of a member of B is in L, and members of B of the same size do not contain one another. A free set is fixed by no C_f with f > 1, so no fixed complex Δ^{C_f} gains a cell. Each orbit has k members of dimension s − 1. ∎
- **Corollary (only the residue matters, given room).** χ = 1 is realisable within cap c whenever some invariant L within cap c has χ(L) ≡ 1 (mod k) and enough room: |χ(L) − 1|/k free orbits in a single A_s, with s even if χ(L) > 1 and s odd if χ(L) < 1. By (B), χ(L) mod k is fixed by L's data at f > 1: χ(L) ≡ −Σ_{f > 1} μ(f)·ψ_L(f) (mod k). So **whether χ = 1 is realisable on k points is decided by which proper fixed-point data can occur together**, and these are complexes on the quotients Z_{k/r}. That is the induction.
  - The constructions of `cyc_chi_one_construct.py` are instances: Δ₀ supplies the residue, and the corrections draw on A_3 or A_4. Every one of the 18 constructions found its corrections at once.
- **What remains for Lemma C, in this form:**
  1. **Gluing.** Given realisable quotient complexes Δ_r on Z_{k/r} (one for each prime r | k) whose data agree on overlaps, find one complex L on Z_k with L^{C_r} having those data. Unions of pull-backs give some combinations, and their data come from the pull-back and union formulas, but not all. The exact test above, in which every predicted vector of moderate χ is realised, says gluing never failed for k ≤ 12.
  2. **Room.** Show that the L produced by gluing has |χ(L) − 1|/k free minimal non-faces of one parity within the cap. Free s-sets number about C(k, s)/k orbits per size, while L's faces are unions of cosets and their subsets, so for c ≥ 4 room should be plentiful except when c is small or χ(L) is far from 1. The misses at the ends of the range are exactly where room fails.
- **Lemma R (room; proved).** Let L be C_k-invariant with faces of at most c ≥ 3 points, containing every vertex. Count two kinds of orbits missing from L:
  - *e*: orbits of edges {x, x + d} with 2d ≢ 0 (mod k);
  - *t*: orbits of 3-sets with trivial stabiliser and no two points at difference k/2.
  
  Then for every integer j with −e ≤ j ≤ t − e there is an invariant complex within the cap, with the same fixed complexes Δ^{C_f} for all f > 1, and χ = χ(L) + jk.
  - *Proof.* By Lemma F with s = 2, add any a ≤ e of the missing edge orbits: each such edge is free, and both its points are faces. Then add all e. Every counted triangle now has all three edges and is free, so by Lemma F with s = 3 any b ≤ t of them can be added. That gives χ(L) − ak and χ(L) − ek + bk. ∎
  - So **room holds whenever χ(L) − ek ≤ 1 ≤ χ(L) + (t − e)k**. Here t is about (k − 1)(k − 2)/6 minus the triangles already in L, so for a moderate L the window is about ±k²/6 around χ(L).
- **Gluing, tested** (`gluing_check.py`; `outputs/gluing_check.txt`). For every k ≤ 12 and every cap 2 ≤ c ≤ k − 1, compare two residue sets mod k:
  - the residues of χ over *all* invariant complexes within the cap (CP-SAT, one call per residue);
  - the residues over *unions of pull-backs* ∪_{r | k prime} π_r^{-1}(X_r), with X_r any invariant complex on Z_{k/r} within ⌊c/r⌋ (faces listed explicitly).
  
  **The two sets agree in all 54 cases.** So, up to k = 12, pull-back unions reach every residue that any complex reaches, and with Lemmas F and R the gluing question reduces to residues.
  - **The residue sets are CRT products.** In all 54 cases the realised set is the product, over prime powers p^a ∥ k, of its own reductions mod p^a. For example, at k = 12 and c = 4 it is {all classes mod 4} × {0, 1 mod 3}, and at k = 10 and c ≥ 5 it is {0, 1 mod 2} × {0, 2 mod 5}.
  - **Conjectured consequence.** χ ≡ 1 (mod k) is reachable within cap c iff, for each p^a ∥ k, some reachable complex has χ ≡ 1 (mod p^a). That is a separate condition for each prime, the condition the split constructions satisfy. With Lemma R it becomes a criterion for χ = 1 that can be checked prime by prime.
- **Gluing lemma (proved).**
  - **Congruence.** For a C_k-complex X and a prime power q^b ∥ k, χ(X) ≡ χ(X^{C_q}) (mod q^b). *Proof:* restrict to the cyclic q-subgroup C_{q^b}. Its Lefschetz function is a Z-combination of permutation characters, and the Burnside congruence at e = 1 reads ψ(1) − ψ(q) ≡ 0 (mod q^b), since every nontrivial subgroup of C_{q^b} contains C_q. ∎
  - **Union.** Let complexes A_p be indexed by the primes p | k, all within cap c, and suppose A_{p′}^{C_p} ⊆ A_p whenever p′ ≠ p. Then Δ = ∪_p A_p is within cap c, and χ(Δ) ≡ χ(A_p) (mod p^a) for every p^a ∥ k. *Proof:* Δ^{C_p} = ∪_{p′} A_{p′}^{C_p} = A_p^{C_p}, and apply the congruence to Δ and to A_p. ∎
  - So the CRT-product property follows whenever each prime's residues can be realised by complexes satisfying the containments.
- **The simplest way to get the containments fails** (`crt_pure_check.py`; `outputs/crt_pure_check.txt`).
  - The idea: call A_p *p-pure* if no face of it is a union of C_q-cosets for a prime q ≠ p. The containments are then automatic. Property (S) asks that p-pure complexes realise every residue mod p^a that any complex does.
  - (S) holds for k = 6 and 10 at every cap, and for k = 12 with c ≤ 5.
  - **It fails at k = 12 with c ≥ 6 and p = 3:** χ ≡ 2 (mod 3) needs faces fixed by C_2. Yet the full residue set is still the CRT product there, all of Z_12.
  - So the gluing must let the A_p share their cross-fixed faces, A_{p′}^{C_p} ⊆ A_p, not avoid them. Making that inductive is the next step: build the A_p over a common core containing every cross-fixed face.
- **Remaining for Lemma C:**
  1. Prove the CRT-product property for pull-back unions. A union of pull-backs from pairwise coprime moduli satisfies 1 − χ = ∏(1 − χ_i), which already factorises over primes; the general case needs the intersection formula for moduli that share factors.
  2. Describe each prime's residue set: which χ mod p^a occur for C_{p^a}-actions within a cap, together with the factor coprime to p.
  3. Check Lemma R's window in the configurations that matter.
- **What Lemma C would give.** On cyclic blocks, closing a configuration becomes arithmetic on data vectors, the same arithmetic that defines goodness in μ\*_cyc. Two further steps would remain:
  1. the room lemma, with an explicit cap;
  2. the two-block arithmetic, showing it fails only on μ\*_cyc's good shapes.
  
  Both are about cyclic and prime blocks. Prime-power blocks with larger N\* and the merged and non-prime-power rows need more.

## 8. How this sits in `orbital-evasiveness-notes.md` §7

- **It is `orbital-evasiveness-notes.md` §7.3's direction (b).** Oliver's theorem is tight at a fixed group over all acyclic complexes: every value in 1 + n_G·ℤ occurs. `orbital-evasiveness-notes.md` §7.3 names "the restriction to Δ_P complexes" as the least explored place left to look, since Δ_P comes from an S_n-invariant family and the tightness says nothing about that subclass. The Proposition is an instance: for sparse graph properties the realisable values of χ(Δ_P^Γ) lie in the finite set of the k-table, which misses 1 + qℤ. m\*_χ(Γ) is the least budget at which the realisable set first meets Oliver's.
- **It extends `orbital-evasiveness-notes.md` §9.7's "isomorphic orbitals".** That passage has the symmetry N\*, the all-or-none consequence, the count t_eff, and evasiveness for budgets up to m₁ + m₂. What is added is that a whole type is neutralised up to its total size, and the constants that follow.
- **It is the χ-level, k-cycle form of `orbital-evasiveness-notes.md` §7.13's loop.** There: if an Oliver subgroup H has exactly two orbits that the ambient group swaps, the fixed complex is two points or empty and every invariant function is evasive. That is k = 2 with the swap in place of the multiplier. The pentagon and pentagram under A₅ are the same mechanism failing because the identifying permutation is not in the ambient group. For graph properties the ambient group is S_n, so every multiplier is available — which is why the device is so effective here.
- **Chiral properties:** see §15.
- **It fills the partial-index row of `orbital-evasiveness-notes.md` §7.9.** The per-shape conditions listed there are for full foreign index, and at those shapes m\*_χ(Γ) = m\*(Γ): the pattern "the smallest orbital alone" passes — {K_a} at S3, F·K_c at S2. A gain needs the smallest type to be repeated, which is the partial-index case.
- **The search of `orbital-evasiveness-notes.md` §7.9 is M\*_OCR with no objective.** The CSP's models are the properties passing the battery; minimising s over them would compute the battery's projection, a lower bound on M\*_OCR(10), and μ\*_χ restricted to the battery is the largest single-group optimum.

## 9. What this would do to `arithmetic-of-density.md`

*A reading of `aod` against §§1–7, section by section; nothing there is edited. `aod` is about μ\*, so none of it becomes false. Integration would add a second track, for the lower bound μ\*_cyc of the χ rung, beside it.*

**`arithmetic-of-density.md` §1, the thesis.** The two engines stand. On the second track a foreign block's efficiency η = 2/d stops being the currency: a block whose index k = d/2 is good for q counts as η = 1. The six constants keyed mod 12 collapse to two, 1/4 at even n and 3 − 2√2 at odd n. *These are the two constants `solvable-relaxation.md` reaches by relaxing Oliver's chain to solvability.* There the chain is dropped; here it is kept and its condition is used in full. That two different moves land on the same pair wants a sentence wherever it is recorded.

**`arithmetic-of-density.md` §2, the census.** The shapes are the same and the winners are not. S7 at F = 4 no longer sets the ceiling at n ≡ 11 (mod 12): F = 2 at d = 12 does, at cap₂(1). **S5 gains nothing:** top-layer fusion forces q = 2, its index is the odd part u of r − 1, and q = 2 is exceptional at k = 3, 5 and 7. S6 and S11 have two foreign blocks, two types, and the device does not apply to them (§3). The entangled group AΓL(1, c) on c + r points (§5) has r dividing c − 1, against clause 4 of (BCG), with the matching twist full; it is worth less than μ\* wherever it was scored, but it is a shape the census does not list.

**`arithmetic-of-density.md` §§3.1–3.3, efficiency and the ceiling table.** The local analysis is untouched: only ℓ = 2 and ℓ = 3 obstruct, and the table of admissible d by class is what it was. What changes is that d costs nothing while d/2 is good. The ceiling table has two rows; cap_F(η) is used at η = 1 and F ∈ {1, 2} only; the rung ladder A > B > C and the F = 4 analysis of `arithmetic-of-density.md` §3.3.4a become statements about μ\* alone. New side conditions appear, each of density zero in q: q ≠ 2 at k = 3, q ≠ 3 at k = 4, q ∉ {2, 5, 7} at k = 6.

**`arithmetic-of-density.md` §3.4, the window.** Unchanged; F·width = 1 − √λ needs nothing from η.

**`arithmetic-of-density.md` §3.5, (BCG).** The same hypothesis with a larger conclusion. Clause 3's list d ∈ {2, 4, 6, 12} gives k ∈ {1, 2, 3, 6}, all inside the range k ≤ 7 where the table of §4 is exhaustive. The clause that `aod` calls load-bearing, F = 4 at class 11, is not needed on this track: class 11 uses n = 2c + r with r = 12q + 1, the system `aod` records as superseded.

**`arithmetic-of-density.md` §3.6, the shifted-prime ladder.** No relief. The device needs a bounded index, so it does nothing for a rung with θ < 1, where the cofactor is a power of r. (BCG) is still the θ = 1 endpoint. *The conditional PD(1) row does not change this.* PD(1) is a limit law at fixed θ < 1. Cofactors of size (log r)^A are an event of vanishing proportion, which the law does not see. Extrapolating the Dickman density gives about x·log K / log² x primes with cofactor at most K. That is the Bateman–Horn order, but it is a statement about pairs of primes, so it is not a consequence of PD(1).

**`arithmetic-of-density.md` §§3.7–3.8 and §5, the data and the floor.** A parallel scan is owed: `threshold_scan.py` reaches 4000 where `ladder_verify.py` reaches 10⁶. The floor row changes character. On `aod`'s track the minimiser n = 2759 is foreign-bound, at the boundary cofactor 12; on this one that block is at full capacity, and the floor, 0.0938 at n = 923 (exact), is bound on a fused matching class.

**`arithmetic-of-density.md` §4, the fates.** Unchanged for μ\*. The escapes matter less, since the ceilings they escape above are higher.

**`arithmetic-of-density.md` §6, the converse — where the tracks differ in kind.**

- *The feasibility criterion Σ√F_i ≤ 1/√δ₀ carries over unchanged.* It uses only that each part's capacity is at most its size squared, and a rescored foreign block still needs a share of at least √δ₀. So the counts N(δ₀) of `arithmetic-of-density.md` §6.1 and `arithmetic-of-density.md` §6.4, and their growth as δ₀ falls, are the same on both tracks.
- *At the new constants the covering set is small.* 3 − 2√2 = 1/(1 + √2)², so just below the odd ceiling the only feasible shape of odd parity with a foreign part is n = 2c + r, and just below 1/4 the feasible shapes are n = c + r and n = r₁ + r₂. The collapse of `arithmetic-of-density.md` §6.6 to one shape comes without a margin argument. What is left is a disjunction over the cofactor d, which the admissible-d table cuts to one or two per class: d = 12 alone at class 11.
- *The bounded cofactor of `arithmetic-of-density.md` §6.7 changes character.* For μ\* a floor forces (r − 1)/Q ≤ D(δ₀) = 2(1 − √δ₀)²/δ₀, which loosens as δ₀ falls. For a rescored block the cofactor is bounded by which indices are good — d ≤ 14 on the exact table — whatever δ₀ is. That bound is a fact about what §4 has proved, not about the groups: it stands or falls with the open question of which k admit a cyclically symmetric complex of Euler characteristic 1.
- *The converse does not reach μ\*_N or μ\*_χ, but its type-level form reaches μ\*_N^fpf* (§7, Proposition U\_typ, with Conjecture P for one case). Its first step is that the score is a minimum over orbitals, so every part clears δ₀ on its own. At level 1 that fails. The trivial group has no parts and its value is G\*(n) (§7), which is governed by congruences on Σ ± n!/|Aut| and by no shifted prime; a group fixing a points is governed by G\*(a). So "a high value forces one of finitely many prime systems to be soluble" holds for μ\* and for μ\*_cyc and is conditional on G\* above them. At n = 6, 10, 12, 14, 18, G\* ≤ μ\*, and nothing has broken.
- *The round trip of `arithmetic-of-density.md` §6.7 does not close on this track, and cannot.* Forward, (BCG) gives a larger evasiveness constant. Backward, a high evasiveness threshold forces no arithmetic: if ARK holds, the top projection is C(n,2) at every n with no hypothesis at all. The converse is a property of the low rungs, where the projection is a maximum over groups of a minimum over orbitals.
- *`ladder-completeness.md` Proposition 1*, which cuts the covering set to 13 and 13 above 1/25, is proved for μ\* scoring. On this track §5's bound U(n) does part of that work without a menu; the proposition itself would need redoing.

**`arithmetic-of-density.md` §§7–8, the open problems.** Open Problem 1 asks whether a family of different local structure can beat the ℓ = 2 and ℓ = 3 efficiency losses. The answer here is sideways: for μ\* the losses stay, and for evasiveness they were not losses. §8's item on efficiency below 1 becomes the question of which indices are good.

## 10. Arity k ≥ 3: what the device was spending

*A reading of `three-uniform-note.md` and `general-k-note.md` against §§1–7; neither is edited.*

**What transfers.** Everything stated without reference to pairs: the projections of §1, the three levels of §3, the Proposition of §4 (its proof never uses that the orbits are of pairs), the reduction of §7 to types and the trivial group, and §7's split of the N level into its fixed-point-free part and groups with fixed points, the latter bounded by G\*_k at the number of fixed points. The fixed complex is indexed by orbits on k-subsets, as `three-uniform-note.md` §1 says of the criterion itself.

**What the device needed, and k = 2 supplied without being asked.** The Proposition wants every orbit under the budget to lie in *one* type. At k = 2 a foreign block's pair-orbits are a single orbit of the normaliser: AGL(1, r) is transitive on pairs. μ\* spends the 2-homogeneity of the group; the device spends the 2-homogeneity of its **normaliser**, which costs the group nothing. `aod` §5 calls the first a group-theoretic accident. The second is the same accident, one level up.

**At k = 3 the normaliser is not 3-homogeneous, and the types multiply.** AGL(1, r) has about r/6 orbits on triples. So a foreign block ℤ/r ⋊ C_t has about r/6 types, each a free cycle of d = (r − 1)/t orbits with total r(r − 1), together with a few special ones. One type's total is the full-twist value, so a single-type statement would send η₃ to 1 and every ceiling of `three-uniform-note.md` §5.7 to cap_F(1)/2. **It does not hold.** With several free types, j of them taken as isolated vertices give χ = j·d, and since d is prime to q some j gives 1 (mod q); with pairs allowed, χ = d·(v − e) reaches every class. Computed at level 1 (`kset_block_levels.py`):

| block | orbits on triples | types | least budget with χ ≡ 1 (mod q) |
|---|---|---|---|
| ℤ/23 ⋊ C₁₁, d = 2 | 7 of 253 | one of 1 orbit, three of 2 | 253, the smallest orbit |
| ℤ/29 ⋊ C₇, d = 4 | 18 of 203 | one of 2, four of 4 | 203, the smallest orbit |
| ℤ/13 ⋊ C₃, d = 4 | 4 of 13, 6 of 39 | one of 2, two of 4 | 13, the smallest orbit |

So at level 1 a foreign block is worth its smallest orbit and no more: **μ\*_cyc has no analogue at k = 3**, and the shifted-prime efficiency η stays the currency there. *Level 2 is not examined;* a property generated by j pairwise non-embeddable orbits would pass when j·d ≡ 1 (mod q), which suggests it gives nothing either.

**The exception is where the normaliser is 3-homogeneous**, and Kantor's list (`three-uniform-note.md` §3.1) says where: degrees 5, 8 and 32. At c = 32 the group AGL(1, 32) has five orbits of 992 on triples, one type under AΓL(1, 32), cycled by the Frobenius; computed, the least budget is **4960 = C(32, 3)**, at q = 31 and at q = 5. So a block of 32 is worth full density *without the Frobenius in the group*, whenever 5 is a good index for the top prime (q ∉ {2, 3}). The Galois escape of `three-uniform-note.md` §6.1 pays for that factor 5 by pinning the top prime to 5, after which every foreign block needs 5 | r − 1; at c = 32 the device waives the pinning. At c = 128 it does not: AGL(1, 128) has 21 free orbits on triples in three types of 7. This is a finite effect, on configurations with a block of 32.

**General k.** `general-k-note.md` §3 records that the full-density blocks are finite at k = 3, degenerate at k = 4 and absent from k = 5 (Livingstone–Wagner). The device's supply is that same list, so it has no infinite family at any k ≥ 3. The ceilings β_k = cap_F(η)/2, the mod-12 table and the arithmetic of `aod` §§3.5–3.6 are untouched at every arity.

**The barrier of §12 at arity k.** At k = 2 the barrier's mechanism has two parts: units are bounded by pair counts within classes of orbits, and crediting a whole orbit needs a 2-homogeneous normaliser. At arity k these become:
- **Units.** A class of F orbits with share s holds at most about s^k/F^{k−1} of the k-sets.
- **Whole orbits.** Crediting a whole orbit needs a k-homogeneous normaliser. For k ≥ 3 that is Kantor's and Livingstone–Wagner's finite list.

So the step that took k = 2 up to the barrier, μ\* → μ\*_cyc with foreign blocks at efficiency 1, has no infinite supply at k ≥ 3. The level-1 computations above show the cost: a foreign block is worth its smallest orbit. The computable quantities stay at μ\*_k = Ω(n²) and O(n² log n) (`general-k-note.md` §5), which is a vanishing fraction of C(n,k). At k = 2 orbit-local methods reach a constant fraction of C(n,2) and stall there. At k ≥ 3 the computed quantities, μ\*_k and the level-1 block values above, never leave the Ω(n²), O(n² log n) range. *Whether every orbit-local method at k ≥ 3 is o(C(n,k)) is not proved:* the type-level version of Proposition U would need a bound on N\*-orbits on k-sets that this note does not have.

**What might still have juice: G\*_k, now with the k = 2 evidence.** The reduction of §7 gives μ\*_{N,k} ≥ G\*_k(n), the least e_max of a k-uniform property with χ = 1. Whether G\*_k is of the order of μ\*_k or larger is still the one question here that could change an order of magnitude. The pair case now gives evidence on how it might go.
- **What k = 2 shows.** G\* never exceeded μ\* where known (n = 6, 10, 12, 14, 15, 18, 21; §7). At every one of those n it equals the largest Smith bound over p-subgroups, and the Smith bounds of block translations are linear in n (Propositions B, B′ and B″).
- **The analogue at arity k.** A group of translations of blocks of p has every orbit on k-sets of size p^i for some i ≤ k. The binding faces are built from its smallest orbits, those of size p, so the same mechanism suggests Smith bounds of order p times a small j. That is O(n), far below μ\*_k.
- **If Smith-tightness held at arity k,** G\*_k would therefore not change the order of magnitude. But Smith-tightness is an observation from seven values at k = 2, and no k-uniform value of G\* has been computed. `global_chi_min.py` on 3-uniform hypergraphs at n = 6 would be the first data point, and `smith_blocks.py`'s class complex has a direct k-set analogue.

## 11. What is open, and what is owed

- **Is the right-hand column the asymptotic value of μ\*_χ?** Unknown. An upper bound needs a cap on totals of isomorphism types in place of the flat cap on orbitals, and the obvious candidate — m\*_χ(Γ) is at most the smallest type total, by taking the property generated by that type's full union — fails as stated, because other orbitals can embed in that union and change χ (K_c embeds in K_r when c ≤ r). The guess is that 1/4 and 3 − 2√2 are right for generic n. The data support it so far: μ\*_χ = μ\* at n = 6 and 10, and in both, level 2 lifts weak groups up to the maximum but never past it.
- **How far apart are μ\*_χ(n) and M\*_OCR(n)?** At n = 6, 6 against 9. At n = 10, μ\*_χ(10) = 20 (§3), and M\*_OCR(10) is not known.
- **Where does the bounded-cofactor condition now live?** A foreign block with trivial twist has all (r − 1)/2 of its cycle-orbitals in one type, of total C(r,2), with no condition on r − 1 at all; what the condition on r − 1 buys is a twist large enough to leave k small enough to qualify. Which k qualify is the question of whether a cyclically symmetric monotone function on k points can have χ = 1 — the χ-level form of the transitive-group question of `orbital-evasiveness-notes.md` §7.5–7.6 and `pending-checks.md` A48.
- **The same device elsewhere:** on the intra classes of a partial-twist matching block; on the cross distance classes of a fused class, of one type per divisor class by `orbital-evasiveness-notes.md` §9.7; on unfused isomorphic blocks, where the symmetry is all of S_F and the invariant complexes are skeleta of a simplex, never of Euler characteristic 1; at k ≥ 12 for budgets too small for the bad complexes to fit.
- **A matching upper bound on the biclique side.** §6 gives a sufficient region. Whether a + b ≤ s\*_N(n) is all the χ rung requires, and whether a group with two good types or a good type on a fused class does better, is not examined; nor are required graphs other than bipartite ones.
- **The matching-prime reading of μ\*_cyc** at the 1,022 rows to 4000 where U exceeds the scan and no hand argument has been made; and the seven rows where the foreign reading is open.
- **Conjecture P (§7):** a soluble transitive Oliver group of non-prime-power degree has m\*_typ ≤ n(q(n) − 1)/2. Open only when N\* is primitive with non-abelian socle. Checked on all soluble transitive groups of every non-prime-power degree from 6 to 46 (at 40 as the bound m\*_typ ≤ 140). Two smaller items: the socle fact behind Step 2 is checked to degree 877, and the infinite families are not yet cited.
- **Is the right-hand column the asymptotic value of μ\*_N?** Its fixed-point-free part, yes, conditionally (§7). The rest is whether groups with fixed points, through G\*(a) for a ≤ n, can beat δ_cyc(n)·C(n,2) on a set of positive density.
- **Does μ\*_N^fpf ever exceed μ\*_cyc?** Not at any non-prime-power n ≤ 46 (§7, *Small n*: there the two are equal, by an orbit-data upper bound). Beyond that range, two constructions with two rescored blocks were searched to n = 4000 (`fpf_separation_search.py`), with joint goodness checked by CP-SAT, and neither ever beats μ\*_cyc. The 2r + r′ shape has 1,009 triples that would beat it if the types were good, but the small common top primes (q = 3, 5, 7) defeat joint goodness. Given Conjecture P, an orbit-data bound leaves 977 rows to 4000 undecided, all with two-class witnesses (§7). The level-1 closures of §7 for the 481 prime+prime and pp+pp rows did not check the budget. Rechecked with it, every configuration with few usable classes closes, but most configurations are roomy and only partly rechecked (§7, *The budget*). So those rows are not settled. The 496 rows with merged or non-prime-power witnesses are unexamined. No separation has been found.
- **Is S(n) = O(n)?** (§7) For the translations of blocks: s_Q = 2p for two blocks when p ≥ 11 (Proposition B), s_Q ≤ 3p for any k ≥ 2 blocks when p ≥ 37 and p ∤ k (Proposition B′), and s_Q ≤ 6p ≤ 3n for every p ≥ 3 with p ∤ k (Proposition B″, by computation for 5 ≤ p ≤ 31). Open:
  - p | k, where s_Q ≥ p² and the guess is O(p²);
  - all other p-subgroups: a survey of 28 Sylow subgroups and 429 random p-subgroups (n ≤ 96) finds s_Q ≤ 3n throughout, but there is no proof.
- **Smith-tightness of G\*** (§7): is G\*(n) always the largest Smith bound over its p-subgroups? It holds at all seven known n, two of them odd. A general construction would settle the fixed-point question.
- **G\*(n) beyond 18**, and with it μ\*_N at n = 22, 26, 34, 38, 46, 50: a property with χ = 1 and at most m(m − 1) edges, or a proof there is none. The method of §7 should reach 22 and 26 with the 4-regular circulants on 11 and 13 points as the forced graphs; not attempted. **ν\*(n) away from n = 2m**, or better a bound that uses m\*_N(Γ) ≤ G\*(a) for groups with fixed points. Whether μ\*_N ever exceeds μ\*_cyc.
- **Done (2026-11-14):** a second reading of both Propositions; `cyclic_chi_values.py` checked by independent code; §6's boosted column and every scan figure reproduced by rerun, after a review of the code. The rerun is not an independent reimplementation. **Owed:** the device inside the exact enumerator, for μ\*_cyc over [6, 10⁶]; the right-hand column rescanned class by class. `pending-checks.md` A49.

## 12. A barrier, informally

*Not a theorem. An argument about a class of methods, with the propositions above as its proved instances.*

**The class.** Call a lower-bound method for the evasiveness thresholds *orbit-local* if it does two things:
1. It certifies evasiveness through one Oliver group Γ, or a family of them taken one at a time.
2. It reads that certificate from data attached to Γ's orbits: orbital sizes; the grouping of orbitals into types under N\*(Γ); and congruences on fixed complexes whose χ is a signed count of face-orbits, read modulo primes.

μ\*, μ\*_cyc, ν\*_fpf, the level-1 values m\*_N of fixed-point-free groups, and the Smith bounds S(n) are all orbit-local.

> **The barrier (informal).** On a set of n of density 1, no orbit-local method certifies evasiveness of every property with e_max below δ_cyc(n)·C(n,2), where δ_cyc(n) is 1/4 at even n and 3 − 2√2 at odd n.

**Why.** The cap is a counting fact, not an arithmetic one.
- **Every credited unit is bounded by pair counts.** A unit that an orbit-local method can credit lies inside the pairs of one N\*-class of orbits. A class with share s of the points, made of F orbits, holds at most s²/F of all pairs. Minimising over the classes gives at most 1/(Σ√F_i)², the feasibility criterion of `arithmetic-of-density.md` §6.
- **Full credit for an orbit needs 2-homogeneity, and that is sparse.** Exceeding that bound needs a single orbit to count in full, so its pairs must form one unit. That needs a 2-homogeneous action normalising a nontrivial solvable group, which forces prime-power size (§7, Step 2). The balance point lands on a prime power for only a density-0 set of n (the set E of §5).
- **Number theory places nothing above the cap.** It decides whether the cap is reached, through the supply of primes at the balance point under (BH-SW) or (BCG-AL), never where the cap sits. The step from μ\* to μ\*_cyc stayed inside the barrier: it raised a foreign block's efficiency to 1, which reaches the cap without moving it.

**Its proved instances.**
- **Proposition U (§5):** the barrier for μ\*_cyc's scoring, unconditional.
- **Proposition U_typ (§7):** the barrier at the type level, for fixed-point-free groups. It is proved except in Conjecture P's case.
- **Propositions B, B′ and B″ (§7):** Smith certificates from block translations are linear in n, far below the cap.

**Where it says nothing.** Fixed points are routed to G\*. If S(n) = O(n) and G\* is Smith-tight, they fall under the barrier too. Neither is proved.

**What lies outside the class.** Each quantity that could exceed the cap couples orbits, or groups, in a way orbit-local data cannot express:
- **embedding (μ\*_χ, §2):** which unions of orbitals, from different orbits, embed in which;
- **the trivial group (G\*, §7):** the χ of an S_n-invariant complex, which no orbit decomposition simplifies;
- **simultaneity (M\*_OCR, §2):** one property constrained by all groups at once. The separation at n = 6 (9 against 6) comes from a forced K₃,₃ that no single group requires.

These are also the quantities that are doubly exponential to compute and have no number-theoretic asymptotics (Cost table). That is the substance of the barrier. Being orbit-local is what makes a quantity feasible to compute and estimable under number-theoretic hypotheses, and being orbit-local is what caps it at δ_cyc. Closing the gap from about 1/4 to 1 needs arguments that couple orbits or groups, or invariants finer than Euler characteristics and Smith congruences.

**Caveats.**
- "Orbit-local" is not defined precisely enough to prove anything about. A formal version would fix a class of certificates and prove the analogue of Proposition U for the whole class. One candidate class: certificates whose validity depends only on a group's coherent configuration together with mod-p counts.
- The barrier concerns density-1 asymptotics. At individual n, and on E, orbit-local refinements can still raise values: several rescored orbits at once, or non-cyclic multiplier actions. None has been found to beat μ\*_cyc at any n ≤ 4000 (§11).
- It does not bear on whether ARK is true. It locates where further progress would have to come from.
- The topological method of Kahn, Saks and Sturtevant fixes one group and uses its fixed-point χ. Its general lower bound is of order n²/4, a constant fraction short of C(n,2). The barrier is consistent with that, but the quantities differ, and this note does not compare them directly.

## 13. Scope: which definitions need graphs

*`monotone-transitive-note.md` works with a nontrivial monotone function on N coordinates, invariant under a group G ≤ S_N (weakly symmetric when G is transitive). Graph properties are the case N = C(n,2), G = S_n acting on pairs. This section sorts the quantities of this note by what they use.*

**Defined for any (N, G).** These need only a group acting on the coordinates and Oliver subgroups of G:
- The **ladder of rungs and its projections** M\*_R (§1). These include M\*_OCR and M\*_NE, and the χ rung's G\* = the least e_max of a G-invariant P with χ(Δ_P) = 1.
- The **per-group levels** (§3), with "orbital" read as "Γ-orbit on coordinates":
  - **m\*(Γ)**, the least orbit;
  - **N\*(Γ)**, the elements of G carrying Γ-orbits to Γ-orbits;
  - **types and m\*_typ**;
  - **m\*_N**, level 1;
  - **m\*_χ**, level 2, where embedding becomes "some element of G carries one union of orbits into another".

  Their maxima over Oliver Γ ≤ G (μ\*_G, μ\*_{N,G}, μ\*_{χ,G}) are `monotone-transitive-note.md` §2's μ\*_Γ and its refinements.
- The **single-good-type Proposition of §4**, stated for a Γ-orbit set cycled by N\*. Its proof never uses pairs (§10).
- **Smith bounds** s_Q and S (§7), for p-subgroups Q ≤ G.

The general setting can be much easier. If G contains a transitive Oliver subgroup, every rung closes at once (`monotone-transitive-note.md` §1), and μ\*_G = N.

**What is general theory, and what is not.** "No theory" (`monotone-transitive-note.md` §2) is right about *values*. A single (N, G) has no family index, so nothing has asymptotics, constants or a shape-space formula. It is not right about *structure*: three things hold in full generality.
1. **The inequalities.** μ\*_G ≤ μ\*_{N,G} ≤ μ\*_{χ,G} ≤ M\*_OCR ≤ M\*_NE, with G\*_G ≤ μ\*_{N,G}.
2. **A level-1 closure criterion.** If G has an Oliver subgroup H such that no N\*_G(H)-invariant proper complex on H's orbits meets H's condition, then every nontrivial monotone G-invariant function is evasive. Here N\*_G(H) is the stabiliser in G of H's orbit partition, and the condition is χ = 1 for an exact reading, χ ≡ 1 (mod q) for each available top prime.
   - **t = 1** (one orbit) is `monotone-transitive-note.md` Proposition 1.
   - **One type**, the orbits cycled by N\*, is §4's Proposition. Its goodness calculus (reduction, skeleta, pull-back) applies unchanged.
   - **t = 2, orbits swapped,** is the loop of `orbital-evasiveness-notes.md` §7.13.
3. **Smith lower bounds.** G\*_G ≥ S_G = max over p-subgroups Q ≤ G of s_Q.

*The criterion run on the groups the weakly-symmetric scan left without a transitive Oliver subgroup* (`ws_level1_filter.g`, `ws_level1_filter.py`; `outputs/ws_level1_filter.txt`), over every Oliver subgroup class:
- **12T162 is settled by 8 classes.** These include the known two-orbit loop (order 12, orbits 6 + 6) and also subgroups of orders 4 and 8 with six orbits of size 2, so the loop is not the only certificate.
- **10T31 is settled by the trivial group.** Its invariant complexes are too few to reach χ = 1.
- **10T7 (A₅), 10T26 (A₆), 14T10 (PSL(3,2)) and 14T30 (PSL(2,13)) are not settled at level 1.** The degree-10 groups are settled by `monotone-transitive-note.md`'s exhaustive A₅ search and inclusion.

*Level 2 and the full battery* (`ws_level2_battery.g`, `ws_level2_battery.py`, `ws_14t10_exhaust.py`; `outputs/ws_level2_battery.txt`, `outputs/ws_14t10_exhaust.txt`). Here the unknown is the G-invariant monotone property itself: one variable per G-orbit on subsets. Each Oliver subgroup's χ(Δ_P^H) is then linear in the variables, so a single group H (level 2, with embedding taken in G) and all Oliver subgroups at once (the battery, i.e. Oliver-χ-resistance) are both CP-SAT feasibility problems.
- **Controls.**
  - 12T162 is infeasible for the battery, and level 2 now settles 13 classes against level 1's 8.
  - 10T31 is infeasible.
  - A₅ on 10 points is feasible, with least e_max 5. That agrees with A₅ needing the exhaustive evasiveness search.
- **14T30 = PSL(2,13): the battery is infeasible.** No PSL(2,13)-invariant property on 14 points is Oliver-χ-resistant, so every nontrivial monotone one is evasive. No single subgroup does it at level 2. It takes the 15 Oliver classes together, the simultaneity of §2's M\*_OCR.
- **14T10 = PSL(3,2): the battery is feasible**, with least e_max 7 of 14. CP-SAT enumerates all **4,224** Oliver-χ-resistant invariant properties, and `dtree.c` computes the exact decision-tree complexity of each: **all have D = 14.** Non-evasive implies Oliver-χ-resistant, so every nontrivial monotone PSL(3,2)-invariant function on 14 points is evasive.

So **both degree-14 groups are settled by these methods**. That agrees with the literature's verification for N ≤ 14 (`monotone-transitive-note.md` §4), now with a certificate in the note's own terms. PSL(2,13) is settled by the Oliver battery alone. PSL(3,2) needs, as A₅ did, an exact evasiveness check of the few properties that survive the battery.

**Bi-resistance in general.** The threshold argument of §1 shows when bi-resistance and Oliver-resistance can differ.
- **The threshold argument.** T_B (all sets of size ≤ B) is bi-resistant exactly when μ\*_G ≤ B ≤ N − 1 − μ\*_G. So whenever μ\*_G < N/2, a threshold witnesses both rungs, and **M\*_BR = M\*_OR = μ\*_G**.
- **Where they can part.** μ\*_G ≥ N/2 happens only at a *half-split*: an Oliver subgroup with two orbits of size N/2. That is the only regime where M\*_BR can exceed μ\*_G, and it is governed by the half-split graph of `orbital-evasiveness-notes.md` §7.13. When that graph is bipartite, a bi-resistant property exists at e_max = N/2. A loop or an odd cycle makes M\*_BR = N.
- **12T162 is the separated case.** μ\*_G = 6 (a half-split exists, and no orbit can be larger), while M\*_BR = 12.
- **Graph properties never reach this regime.** A smallest orbital of size ≥ C(n,2)/2 needs exactly two orbitals of equal size. `monotone-transitive-note.md` §5's case analysis lists the Oliver groups with exactly two orbitals at a non-prime-power n:
  - **vertex-transitive and imprimitive:** the orbitals are "same block" and "different block". With blocks of size b they have valencies b − 1 and n − b, and sizes n(b − 1)/2 and n(n − b)/2. For n = 2p this gives 2K_p and K_{p,p}, of p(p − 1) and p² pairs, the group attaining μ\*(2p).
  - **intransitive with a fixed point:** a star and a clique, of n − 1 and C(n − 1, 2) pairs.
  - **vertex-transitive and primitive:** affine, so n is a prime power.

  Equal sizes in the first case need b − 1 = n − b, so n = 2b − 1, which b | n rules out for b > 1. The second case is never equal. So μ\*(n) < C(n,2)/2 directly, without the classification, and M\*_BR = μ\*(n). The absence of isomorphic swapped orbitals (no loop) is the special case that matters for the criterion. The reason the projections agree is more basic: no half-split exists at all.

**Needs a vertex set: the action on coordinates is induced from an action on [n].** This covers graphs, k-uniform hypergraphs, digraphs (§14) and chiral graphs (§15):
- **Block structure.** Blocks, shapes, twists, the classification, the cap formula and the ceiling tables, and with them the number theory: (BH-SW), the balance points, Propositions L and U.
- **Fixed points.** The fixed-point-free split (§7), with fixed points meaning fixed vertices, and the bound m\*_N ≤ G\*(a) for a group fixing a points.
- **Required graphs.** The biclique form (§6).
- **The barrier.** §12's barrier, whose "orbit-local" counts are counts within vertex orbits.

In the general setting there is no orbit-shape space, so none of these has an analogue. That is `monotone-transitive-note.md` §2's "no theory behind it".

**Needs the arity, or pairs specifically.**
- **Full credit for a vertex orbit.** It needs a 2-homogeneous normaliser at k = 2, k-homogeneous at arity k (§10). So μ\*_cyc's infinite supply exists at k = 2 only.
- **The constants.** 1/4 and 3 − 2√2 come from the exponent 2 in s²/F. At arity k the counts are s^k/F^{k−1}.
- **Type-level orbit lemmas.** Proposition U_typ and Conjecture P are about pair-orbits of soluble transitive groups.
- **The block-translation Smith bounds** (Propositions B to B″) count difference classes of pairs.

## 14. Directed graph properties

*`directed-graph-properties.md`: monotone S_n-invariant properties of the n(n − 1) ordered pairs. The action is still induced from vertices, so everything in §13's second group applies.*

**What that note establishes for μ\*.** μ\*_dir ≥ μ\*, so δ_dir ≥ δ/2 (`directed-graph-properties.md` Theorem D1). An orbital is self-paired iff its twist order is even. So a foreign block at odd top prime q has directed efficiency η_dir = t/(r − 1), half its undirected η, and the directed ceilings are the undirected ones, or halves of them (its §3).

**The device repairs that halving, except at one class.** On a foreign block of prime r with twist T of odd order t = (r − 1)/d:
- **The orbitals.** The ordered-pair orbitals are the d cosets of T in ℤ_r^\*, each of r·t pairs.
- **The cycling.** AGL(1, r) is 2-transitive, so it is transitive on ordered pairs, and its multipliers cycle the d classes regularly.

So §4's Proposition applies with k = d (not d/2), and a good index makes the block count r(r − 1), at efficiency 1. Reading `bcp-to-floor.md`'s cells at k = d:

| n mod 12 | cell (F, d) | k = d | goodness for large q | directed device ceiling |
|---|---|---|---|---|
| 0, 4, 6, 10 | (1, 2) | 2 | prime power: good | 1/4 |
| 2, 8 | (1, 6) | 6 | good for q ∉ {2, 5, 7} (§4) | 1/4 |
| 1, 9 | (2, 2) | 2 | good | 3 − 2√2 |
| 3, 7 | (2, 4) | 4 | good | 3 − 2√2 |
| 5 | (2, 6) | 6 | good | 3 − 2√2 |
| 11 | (2, 12) | 12 | **bad at every q** | — |
| 11 | (4, 6) | 6 | good | **1/9** |

At n ≡ 11 (mod 12) the undirected device uses k = 6. Directed, the same cell needs k = 12, and 12 is bad at every q: a C₁₂-invariant proper complex with χ = 1 exactly exists (session-log-17 Part 10), and so is every multiple of 12, by pull-back. So the F = 2 shape is lost there. The best available is (4, 6), at 1/(1 + 2)² = 1/9.
- **Classes away from 11.** On a density-1 set of n, and conditional on (BH-SW) as in Proposition L, the directed analogue of μ\*_cyc sits at **1/4 and 3 − 2√2 of n(n − 1)**, the undirected constants, with no halving.
- **Class 11.** It sits at 1/9 or more.
- **The upper half.** Proposition U's counting ports verbatim: ordered pairs inside an orbit of share s are about s²·n(n − 1). So 1/4 and 3 − 2√2 are the orbit-local ceilings. Whether some other configuration closes the class-11 gap between 1/9 and 3 − 2√2 is open.

*An explicit witness* (`dir_chiral_witness.py`; `outputs/dir_chiral_witness.txt`). Γ = (C₇ ⋊ C₃) × (C₁₃ ⋊ C₃) on 20 points is Oliver, with top q = 3.
- **Undirected.** The 7-block is 2-homogeneous, a single orbital of 21 pairs. The 13-block has k = 2 classes of 39.
- **Directed.** Both twists are odd, so every orbital splits: 21 + 21, four classes of 39, and 91 + 91 across.
- **What the device does.** N\* merges the two ordered 7-block classes into a type of 42, and the four 13-block classes into a type of 156. The level-1 value is m\*_N = 39, against the least ordered orbital 21. So the device undoes the halving on the 7-block, where k = 2 is good. It does not credit the 13-block, where k = 4 is bad at q = 3 (4 ≡ 1), so a 13-block class of 39 is what binds. Both effects are as predicted.
- **Not checked.** A witness at the generic cells with large q, where k = 6 is needed, has not been built. That goodness rests on §4.

**The class-11 gap, more closely.**
- **Why the F = 2 shape needs d ≡ 0 (mod 12).** With an *odd* matching block c, n ≡ 3 (mod 4) forces r ≡ 1 (mod 4), hence 4 | d, and the mod-3 pin adds 3 | d. The directed device would need index d, and every multiple of 12 is bad.
- **A power-of-2 matching block escapes this.** c = 2^j gives 2c ≡ 0 (mod 4), so r ≡ 3 (mod 4) and d ≡ 2 (mod 4). With j odd the mod-3 pin still needs 3 | d, so the cell is (2, 6), and k = 6 is good: 3 − 2√2 is reached. But c = 2^j at the balance point holds only on a density-0 set of n.
- **Top prime 3 does not help on a density-1 set.** Absorbing the factor 3 into a twist t = 3^e gives the families r = 4·3^e + 1, of density 0.
- **So:** among constructions of the cell type the directed value at n ≡ 11 is 1/9 on a density-1 set, and 3 − 2√2 only along c = 2^j. The upper bound 3 − 2√2 is the counting ceiling. Closing the gap needs the level-1 classification of two-class shapes (§7, the 977 gap rows) in the directed setting.

**Oriented graphs** (`directed-graph-properties.md` §§4–5b) change the coordinate set itself, through the 2-cycle fiat. They are not examined here.

## 15. Chiral graph properties

*`chiral-graph-properties.md`: monotone A_n-invariant properties of E(K_n). Every group must consist of even permutations, and P is invariant only under A_n.*

**What that note establishes for μ\*.** A factor of two at worst (`chiral-graph-properties.md` Theorem 1). Beyond that, a chirality efficiency ε(c) for matching blocks, with ε = 1/2 only for unfused blocks at prime powers c ≡ 1 (mod 4). And the foreign efficiency is halved only on the Fermat branch (q = 2). The mod-12 ceilings survive unscaled at odd n, and at even n subject to choosing c ≡ 3 (mod 4) (its §5).

**The device.** Δ_P^Γ is invariant only under N\*(Γ) ∩ A_n. The multiplier that cycles a foreign block's classes is an (r − 1)-cycle, which is odd. It can be corrected by any odd element of Γ̂, which fixes every orbital: the product is even and acts on the classes as the multiplier does.

Γ̂ contains an odd permutation whenever some vertex orbit carries a 2-homogeneous constituent of Γ, because Γ̂ then acts on that orbit as its full symmetric group. Every shape with a matching block has one. So in those shapes N\*(Γ) ∩ A_n cycles the classes as N\*(Γ) does, and §4's Proposition holds for A_n-invariant properties.

So, on the same density-1 set and under the same hypotheses as Proposition L, the chiral analogue of μ\*_cyc reaches **1/4 and 3 − 2√2**:
- **No penalty at odd top prime q.** The foreign device works there, and its efficiency is not halved.
- **One supply condition at even n.** The unfused matching block of the c + r shape must have c ≡ 3 (mod 4) or c = 2^a to avoid ε = 1/2. That is a positive-density congruence condition, and Proposition L's circle method would carry it as one more local condition.
- **The upper half.** Proposition U applies verbatim, since even groups are a subset.

*Checked on the same witness* (`dir_chiral_witness.py`). Γ = (C₇ ⋊ C₃) × (C₁₃ ⋊ C₃) consists of even permutations. The multiplier that cycles the 13-block's two classes has order 12 on 13 points, so it is odd. Under N\* ∩ A_n the two classes still form one type of 78, exactly as under N\*: the odd multiplier is corrected inside Γ̂, which acts as S₇ on the 2-homogeneous 7-block. *Not checked:* Proposition L with the extra condition c ≡ 3 (mod 4) has not been rerun.

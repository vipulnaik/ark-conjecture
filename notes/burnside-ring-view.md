# The χ rungs in the Burnside ring

A reformulation of the rungs above the N level (`threshold-beyond-mu.md` §§1.2–1.4) for the min–max quantity M\*_OCR and the per-group μ\*_χ. It is meant as a frame for theory, and it is checked at n = 6.

## 1. The equivariant Euler characteristic

Let P be a graph property on [n], with complex Δ_P. Its vertices are the edges of K_n, and its faces are the edge sets of graphs in P. S_n acts on Δ_P.

- **The element.** The equivariant Euler characteristic is χ_{S_n}(Δ_P) = Σ_k (−1)^k [Ch_k(P)] ∈ B(S_n), where Ch_k(P) is the S_n-set of chains G₀ ⊊ … ⊊ G_k of nonempty graphs in P.
- **Its marks.** For H ≤ S_n, the mark of χ_{S_n}(Δ_P) at H is the number of H-fixed points counted in this alternating sum, i.e. χ of the fixed complex: φ_H(χ_{S_n}(Δ_P)) = χ(Δ_P^H). The fixed points of the barycentric subdivision are the chains of H-invariant graphs.
- **In terms of graph classes.** χ(Δ_P^H) = Σ over nonempty isomorphism classes C ⊆ P of s_H(C), where s_H(C) = Σ over H-invariant graphs G ∈ C of (−1)^{o_H(G) − 1}, and o_H(G) is the number of H-orbits of edges in G. The sign comes from the orbit count, not the edge count: the fixed complex has the H-orbits of edges as its vertices. So χ(Δ_P^H) is *not* the mark of Σ_C (−1)^{e(C)−1}[C].

## 2. The rungs as conditions on marks

- **Oliver-χ-resistance:** φ_H(χ_{S_n}(Δ_P)) = 1 for every trivial-top Oliver H, i.e. every p-by-cyclic subgroup, the trivial group included. By fact 5 this is the whole condition.
- **M\*_OCR(n)** is the least e_max of a nontrivial down-closed family P whose equivariant Euler characteristic has mark 1 at every p-by-cyclic subgroup.
- **μ\*_χ(n)** is the same with one subgroup at a time, maximised over the subgroup.
- **The lower rungs read the same marks with less information:**
  - level 0 (μ\*) only uses that the mark is 0 when every H-orbit of edges exceeds e_max, since then Δ_P^H is empty;
  - level 1 (μ\*_N) uses the N\*(H)-invariance of the fixed complex;
  - level 2 (μ\*_χ) uses the full fixed complex of one H.
- **Dress's congruences** describe which mark vectors come from B(G). For H ⊴ K with K/H cyclic of order p, they give φ_H ≡ φ_K (mod p), the Smith–Oliver relations. So "orbit-local" methods (§9.2 of `threshold-beyond-mu.md`) are, in this language, methods that read one mark at a time, with congruences along chains of subgroups.

## 3. Where the min–max can see more

The min–max asks for a *single* element χ_{S_n}(Δ_P), realisable by a down-closed family of small e_max, with prescribed marks on a large set of subgroups at once. Two kinds of coupling are invisible to orbit-local methods:

- **Realisability coupling.** The marks at different subgroups are sums over the *same* classes C ⊆ P. Excluding a class (because e(C) > e_max) removes it from every mark at once. A small e_max forces many marks to be computed from few classes, and the resulting linear system can be infeasible even when each equation alone is not. This is what separates M\*_OCR(6) = 9 from μ\*_χ(6) = 6.
- **Integrality.** χ_{S_n}(Δ_P) lies in B(S_n), not just in the ghost ring ∏ℤ, so its marks satisfy all of Dress's congruences, including those for non-Oliver subgroups whose marks are unconstrained by resistance.

**Questions this frames.**
1. Describe the set of mark vectors (φ_H) of χ_{S_n}(Δ_P) as P ranges over properties with e_max ≤ B. Where in this set is the all-ones vector on p-by-cyclic subgroups first reached? That is M\*_OCR(n).
2. The barrier at δ_cyc·C(n, 2) should be a statement that, below that budget, each single equation φ_H = 1 is satisfiable by some P (orbit-locality). The min–max can only exceed it through the coupling of §3.
3. Which small sets of subgroups already force the n = 6 jump from 6 to 9? A minimal infeasible subsystem would show the mechanism, and suggest which families of subgroups to couple at larger n.

## 4. Computation at n = 6

`burnside_marks.g` computes s_H(C) for every subgroup class of S₆ (56 classes, 39 trivial-top) and every graph class (156). `burnside_ocr.py` solves the integer program: 0/1 class variables, down-closure under one-edge deletion, K₆ excluded, and Σ_C s_H(C)·x_C = 1 for the chosen subgroups. Output: `outputs/burnside_ocr_6.txt`.

- **M\*_OCR(6) = 9**, with all 39 trivial-top classes imposed together.
- **The largest single-class value is 6 = μ\*_χ(6)**, attained by ten classes, including the trivial group, and transitive groups of orders 6, 18 and 36.

Both agree with `threshold-beyond-mu.md` §1.3.

**What forces the jump from 6 to 9 (question 3 at n = 6).** Dropping subgroups while the system at B = 8 stays infeasible leaves three transitive groups.
- **C₂ × A₄** (edge-orbits 3K₂ and K₂,₂,₂, of 3 and 12 edges): below 12 its fixed complex can use only 3K₂, so χ = 1 forces 3K₂ ∈ P.
- **(C₃ × C₃):C₄** (2K₃ and K₃,₃, of 6 and 9 edges): below 9 it forces 2K₃ ∈ P.
- **C₆** (C₆, 2K₃ and 3K₂, of 6, 6 and 3 edges): with 2K₃ and 3K₂ both in P, and no union of two of its orbits below 9 edges, its fixed complex is two or three points, so χ ≠ 1.

So the min–max gap at n = 6 is a **forcing chain**. Groups with one or two small orbitals force specific classes into P, and those classes then overload the fixed complex of a group with more orbitals. The mechanism to look for at larger n is many few-orbital Oliver groups whose forced classes are jointly incompatible with a third group's condition. At n = 10 there are about 1.2·10⁷ graph classes, so this direct program does not reach M\*_OCR(10). There the frame must be used structurally, for example through question 3, or with classes restricted to a template.

## 5. Forcing at n = 10: M\*_OCR(10) ≥ 22

`forcing10.py` builds the coupled system for many groups at once. For a budget B it takes every Oliver class of S₁₀ (`outputs/tom10.txt`) with at most CAP invariant graphs of at most B edges.
- One variable per isomorphism class of those graphs (nauty certificates).
- Embedding closure among them.
- Each group's condition on its fixed complex: χ = 1 for an exact reading, ≡ 1 mod each top prime otherwise.

These are necessary conditions on any property with e_max ≤ B, so infeasibility at B proves M\*_OCR(10) > B. The same code at n = 6 gives infeasible at B = 8 and feasible at B = 9, matching M\*_OCR(6) = 9.

Results (`outputs/forcing10.txt`):
- **B = 20 and 21: infeasible.** At 21 this holds with 961 groups (CAP 500) and with 1,154 groups and 5,080 classes (CAP 5000).
- **B = 22, 25, 28, 30: feasible** (856 groups at CAP 500, 1,154 at CAP 5000 for B = 22).

So **M\*_OCR(10) ≥ 22 > 20 = μ\*_χ(10)**: the min–max separates from the max–min at n = 10 as well as at n = 6. This method gives nothing higher with these groups.

**The forcing chain at n = 10** (`forcing10.py 21 500 --core`): a minimal infeasible set of seven groups, all with exact readings. Their edge-orbit sizes are:
- three groups of order 12: (2, 2, 2, 3, 6, 6, 12, 12), (2, 3, 4, 6, 6, 12, 12) and (2, 3, 3, 3, 4, 6, 12, 12);
- order 20: (5, 10, 10, 20);
- order 25, ℤ/5² on two blocks of 5: (5, 5, 5, 5, 25);
- order 36: (2, 4, 6, 9, 12, 12);
- order 192: (1, 12, 16, 16).

Each is satisfiable alone at 20, and together they force e_max ≥ 22.

**Independent check** (`forcing10_core_check.py`; `outputs/forcing10_core_check.txt`). The core is rebuilt using networkx monomorphism instead of `emb.c`, and decided with SciPy's HiGHS MILP instead of CP-SAT. Matching groups by order and orbit sizes picks up 14 classes; extra conditions only strengthen an infeasibility verdict, and only the ten exact-reading conditions are imposed. The result is infeasible at B = 21.

## 6. Forcing at n = 12 and n = 14

The same program runs on group lists for S₁₂ and S₁₄ built by `oliver_tom_1214.g`. At n = 12 that is all 8,572 Oliver classes. At n = 14 it is the 29 soluble transitive groups and 1,607 direct products of soluble transitive groups on disjoint supports, with fixed points, so it is a partial list. Both lists are too large to commit; the script regenerates them. Embedding tests are capped (`FORCING_EMBLIMIT` = 200,000 steps), and an undecided test drops the relation, which is sound.

Results (`outputs/forcing12.txt`, `outputs/forcing14.txt`):
- **n = 12: infeasible at B = 18, 20, 22, 24 and 28** (CAP 500). So **M\*_OCR(12) ≥ 29**, against μ\*(12) = 18. B = 32 had not finished.
- **n = 14: infeasible at B = 42, 46 and 48** (CAP 100) and at 47 (CAP 300); **feasible at 49 and 50** (CAP 100) and at 49 (CAP 300). So **M\*_OCR(14) ≥ 49**, against μ\*(14) = 42.

μ\*_χ(12) = 18 (`threshold-beyond-mu.md` §1.4), so at n = 12 the min–max exceeds the max–min by at least 11. μ\*_χ(14) is not known, so at n = 14 the bound separates M\*_OCR from μ\* only. No forcing core has been extracted at n = 12 or 14, and neither bound has been independently checked.

## 7. Hierarchies between the rungs and M\*_OCR

### 7.1 The k-ladder above μ\*_χ

**M_k(n)** is the maximum, over sets of at most k Oliver classes, of the least e_max of a graph property meeting the χ condition at every class in the set.
- M_1 = μ\*_χ, since one group's condition sees only the classes of its invariant graphs, and an embedding-closed family of those extends to a property by down-closure.
- M_k is nondecreasing and reaches M\*_OCR at k = the number of classes.
- The **Helly number h(n)** is the least k with M_k(n) = M\*_OCR(n).

At n = 6 (`khier6.py`; `outputs/khier6.txt`), over the 39 p-by-cyclic classes:
- **M_1 = M_2 = 6 and M_3 = 9, so h(6) = 3.** At no budget from 5 to 8 is any pair infeasible.
- **Minimal infeasible triples:** 190 at B = 6, 170 at 7 and 169 at 8.
- **Pivots at B = 7 and 8:** every minimal triple contains exactly one of two classes, an order-2 class (GAP index 3) and the transitive C₆ (index 17).
- **At B = 6 only:** a few triples contain neither pivot; each contains the order-4 class of index 13.

### 7.2 The same hierarchy at the N level

At level 1 each group has its own complex: an N(Γ)-invariant complex on the Γ-orbits of edges. Coupling can be done without any isomorphism-closure. Take a variable per **labelled** graph, so that a graph invariant under several chosen groups is one variable for all of them. Then impose, for each chosen group H:
- down-closure inside H's complex;
- invariance under N(H);
- H's χ condition.

Two facts make this a hierarchy from μ\*_N to M\*_OCR that bypasses μ\*_χ:
- **With one group it is μ\*_N.** The value is m\*_N(Γ) by definition.
- **With the trivial group included it is the min–max.** The trivial group's complex is a whole graph property, so every other complex becomes its true fixed complex, and the system is M\*_OCR.

**Restriction is the coupling.** If H ≤ K, the K-invariant graphs are H-invariant, and Δ^K is Δ^H restricted to K-invariant faces. So a system made of H and any overgroups of H (a *star* on H) lives on the 2^t(H) H-invariant labelled graphs, however large n is (`nlevel_star.py`). Infeasibility at B uses only necessary conditions, so it proves M\*_OCR(n) > B. Dropping overgroups, or normaliser elements, keeps that sound.

### 7.3 What the N level reaches

- **n = 6.** Over all 38 nontrivial p-by-cyclic classes, coupled at the N level, the least budget is **9 = M\*_OCR(6)**. This holds with one representative per class and with all conjugates (`nlevel_coupled6.py`). A minimal infeasible set at 8 has three classes, of orders 3, 6 and 24; no pair is infeasible.
  - The star on H = ⟨(1 2 3)(4 5 6)⟩ alone, a system on 32 graphs, also gives 9. Its core is a transitive group of order 6, together with the transitive groups of orders 24 and 36.
  - These are the C₆, C₂ × A₄ and (C₃ × C₃):C₄ of the forcing chain in §4. That chain is therefore an N-level phenomenon: the forced graphs 3K₂ and 2K₃ reach the third group as shared labelled graphs, not through isomorphism-closure.
- **n = 2p with p ≡ 3 (mod 4).** Take the star on the cyclic group ℤ/2p. Its overgroups are the p-by-cyclic groups inside its normaliser, and every conjugate of a transitive p-by-cyclic group that contains the 2p-cycle (`star_export.g`). The star is **infeasible at p² − 1** at p = 3, 7 and 11:
  - **M\*_OCR(14) ≥ 49 and M\*_OCR(22) ≥ 121**, against μ\* = 42 and 110.
  - At n = 14 this reproduces the bound of §6, from 3 groups on 128 graphs instead of 1,041 groups.
  - Each core has three transitive groups, of orders p(p − 1), p²(p − 1) and 2^p · p: 6, 36, 24 at p = 3; 42, 294, 896 at p = 7; 110, 1,210, 22,528 at p = 11.
  - The star becomes feasible at p², so this method gives exactly p².
- **Where the cyclic star gives nothing.** At p ≡ 1 (mod 4) (n = 10 and 26) the ℤ/2p star is feasible at μ\*, as it is at n = 12 and 18. At n = 10, stars on six further cyclic subgroups, of cycle types 9·1, 7·1³, 8·2, 6·3·1, 4²·2 and 3³·1, are also feasible at 20 (`outputs/nlevel_star.txt`).
  - The χ-level core at n = 10 (§5) contains groups of coprime orders, 25 and 192, so it cannot lie in one star.
  - Whether a chain of stars, with different subgroups linked through shared overgroups, reaches 22 at the N level is open.

### 7.4 What the N level cannot see

The N-level system differs from the true one in two ways only:
1. **Isomorphisms outside normalisers.** A graph invariant under H may be isomorphic, by a permutation outside N(H), to one invariant under K. The N level does not identify the two unless both are invariant under one chosen group.
2. **Embedding through graphs with no symmetry.** If G ⊂ G′ only through graphs invariant under no chosen group, the N level does not link them.

Coupling therefore needs **coherent forcing**: one labelled copy of a forced graph that is invariant under the next group in the chain. Through a common subgroup H this is automatic, which is why stars work. Groups whose only common subgroup is trivial need either a chain of stars or the trivial group, and the trivial group is the whole χ level.

**For the asymptotics,** the star bound at n = 2p, p ≡ 3 (mod 4), is p² = μ\* + p.
- **It crosses one half.** As a fraction of C(2p, 2) it is p/(2p − 1) > 1/2, while μ\*(2p) = p(p − 1) gives (p − 1)/(2p − 1) < 1/2.
- **What is new is the family.** μ\*(n)/C(n,2) < 1/2 at every non-prime-power n in the table to 10⁵ (largest value 0.499995). M\*_OCR was already above 1/2 at n = 6 and 14 individually, but this is a principled break above 1/2 on an infinite family of non-prime-power n, conditional on the pattern holding beyond p = 11.
- **The limit is still 1/2.** The excess p is about 1/(2n) of C(n,2). A gain in the limit would need forcing chains whose lengths or forced graphs grow with n.

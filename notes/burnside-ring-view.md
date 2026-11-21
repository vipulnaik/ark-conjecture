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

**For the asymptotics,** the bound at n = 2p, p ≡ 3 (mod 4), is p² = μ\* + p (§7.5).
- **It crosses one half.** As a fraction of C(2p, 2) it is p/(2p − 1) > 1/2, while μ\*(2p) = p(p − 1) gives (p − 1)/(2p − 1) < 1/2.
- **What is new is the family.** μ\*(n)/C(n,2) < 1/2 at every non-prime-power n. Reaching 1/2 would need an Oliver group with exactly two orbitals of equal size, and `monotone-transitive-note.md` §5 rules that out: its argument against two isomorphic orbitals uses only their sizes. M\*_OCR was already above 1/2 at n = 6 and 14 individually, but this is a principled break above 1/2 on an infinite family of non-prime-power n: every n = 2p with p ≡ 3 (mod 4), by the Theorem of §7.5.
- **The limit is still 1/2.** The excess p is about 1/(2n) of C(n,2). A gain in the limit would need forcing chains whose lengths or forced graphs grow with n.

### 7.5 The n = 2p family: proof, and where it stops

Write the vertex set as [2p] = {0, 1} × ℤ/p, p an odd prime. Three graphs on it:
- the two **classes** {0} × ℤ/p and {1} × ℤ/p, and **A** = the two cliques on them, a 2K_p with p(p − 1) edges;
- **M** = the perfect matching (0, x)(1, x), a pK₂ with p edges;
- **O** = the remaining cross edges (0, x)(1, y) with x ≠ y, a K_{p,p} minus M with p(p − 1) edges.

So A, O and M partition the C(2p, 2) = p(2p − 1) pairs. Fix λ, a primitive root mod p. The three groups:
- **K₁** = ⟨(e, x) ↦ (e, x + 1), (e, x) ↦ (e + 1, x), (e, x) ↦ (e, λ²x)⟩ ≅ ℤ/2 × (ℤ/p ⋊ C_{(p−1)/2}), of order p(p − 1).
- **K₂** = ⟨translation of one class only, translation of the other class only, g⟩ with g(e, x) = (e + 1, λx). This is (ℤ/p)² ⋊ C_{p−1}, of order p²(p − 1).
- **K₃** = ⟨(e, x) ↦ (e, x + 1), the swap of (0, 0) and (1, 0)⟩ ≅ C₂ ≀ C_p, of order 2^p · p.

> **Lemma.** Let p ≡ 3 (mod 4). Then K₁, K₂ and K₃ are p-by-cyclic. Their orbitals on pairs are:
> - K₁: **A, O and M**;
> - K₂: **A and K_{p,p} = O ∪ M**;
> - K₃: **M** and the (p − 1)/2 graphs C_δ, δ ∈ (ℤ/p)^×/±1. Here C_δ has all four edges between {0,1} × {x} and {0,1} × {x + δ}, for every x; it has 4p edges.

*Proof.*
- **p-by-cyclic.** For K₁ and K₂, O_p is the translation subgroup, ℤ/p or (ℤ/p)². The quotient is ℤ/2 × C_{(p−1)/2} for K₁, which is cyclic because (p − 1)/2 is odd, and C_{p−1} for K₂. For K₃, O₂ = (C₂)^p with quotient C_p.
- **K₁'s orbitals.** Every generator preserves the classes. Within a class, the pair {x, x + δ} can be carried to {x, x + ε} when ε = ±λ^{2k}δ. The ± comes from the pair being unordered, the squares from K₁. Since −1 is a non-square for p ≡ 3 (mod 4), ± the squares is all of (ℤ/p)^×, so A is one orbital. Between the classes, the class swap identifies the difference δ with −δ, so the same reasoning makes O one orbital, and M = {δ = 0} is the third.
- **K₂'s orbitals.** The two class translations are independent, so K₂ is transitive on the p² cross pairs. Within a class, g² multiplies by λ², and the same ± argument makes A one orbital.
- **K₃'s orbitals.** The swaps fix each block {0,1} × {x} and act independently on the blocks. So K₃ is transitive on the pairs inside blocks, which form M, and on the four pairs between any two blocks. The translations then identify block pairs at the same distance ±δ. ∎

`two_p_groups.g` checks the orders, the p-by-cyclic property and the orbital sizes at p = 3, 7, 11, 19 and 23 (`outputs/two_p_groups.txt`).

> **Theorem.** Let n = 2p with p ≡ 3 (mod 4) prime. Every graph property P on [n] that is Oliver-χ-resistant has e_max(P) ≥ p². So **M\*_OCR(2p) ≥ p² = μ\*(2p) + p**.

*Proof.* Suppose e_max(P) ≤ p² − 1. All three groups are p-by-cyclic, so χ(Δ_P^{K_i}) = 1 for each i. The vertices of Δ_P^{K_i} are K_i's orbitals that lie in P, and its faces are the sets of them whose union lies in P.
1. **K₂ forces A.** K₂'s invariant graphs are A, K_{p,p} and K_n. K_{p,p} has p² edges, so only A can be a face. χ = 1 then forces A ∈ P.
2. **K₃ forces M.** Δ_P^{K₃} is nonempty, so P contains a nonempty K₃-invariant graph G. G is a union of K₃-orbitals, and each of them contains a perfect matching: M is one, and C_δ contains (0, x)(1, x + δ). So G contains a copy of pK₂. P is closed under isomorphism and subgraphs, so M ∈ P.
3. **K₁ is overloaded.** A, O and M lie in P or not; A and M do. Every union of two of them has p², p² or 2p(p − 1) ≥ p² edges, so Δ_P^{K₁} has no edges. Its vertices include A and M, so χ(Δ_P^{K₁}) is 2 or 3. That contradicts χ = 1. ∎

This holds at every n = 2p with p ≡ 3 (mod 4): 6, 14, 22, 38, 46, 62, … Step 2 uses closure under isomorphism, so this proof is at the χ level. §7.6 gives the N-level version. **Where p ≡ 3 (mod 4) is used:** in K₁ being p-by-cyclic, and in A (and O) being single orbitals of K₁ and K₂. At p ≡ 1 (mod 4) the analogue of K₁ is not p-by-cyclic, and A splits into two orbitals in both K₁ and K₂. The checks at p = 5 and 13 show this (`outputs/two_p_groups.txt`), and the cyclic stars at n = 10 and 26 give nothing above μ\*.

**Where it stops: the cyclic-star rung is exactly p².**

> **Proposition.** For every odd prime p, the property **Sub(K_{p,p})**, the graphs embeddable in K_{p,p}, has e_max = p². It meets χ = 1 at every p-by-cyclic group K ≤ S_{2p} that contains a 2p-cycle.

*Proof.* Label the vertices ℤ/2p, with the 2p-cycle as x ↦ x + 1. Then K's invariant graphs are circulants.
- **Which circulants lie in Sub(K_{p,p}).** A circulant with only odd distances is bipartite between the even and odd residues, which are balanced. An even distance d gives, on the even residues, a cycle of odd length p. So a circulant lies in Sub(K_{p,p}) exactly when all its distances are odd.
- **The fixed complex is a simplex.** Δ^K is therefore the full simplex on the K-orbitals made of odd distances, and χ = 1 provided there is one.
- **There is one.** Let K/O_q(K) be cyclic. If O_q(K) = 1, then K is cyclic and transitive, so K = ℤ/2p, whose distance-1 orbital is odd. Otherwise the orbits of O_q(K) form a block system with blocks of size a power of q dividing 2p, and greater than 1. So the blocks have size p or 2. Blocks of size p are the parity classes, the only such block system of ℤ/2p. Then every orbital is all-odd or all-even, and the cross pairs are all-odd. Blocks of size 2 are the antipodal pairs {x, x + p}. Then the within-block pairs, all at distance p, are a union of K-orbitals. ∎

So no set of groups containing a 2p-cycle forces more than p², at any p. With the Theorem, the value of the cyclic-star system at p ≡ 3 (mod 4) is exactly p².

**The ladder below three.** Each pair of K₁, K₂, K₃ is passed at the budget μ\*(2p) = p(p − 1):
- {K₁, K₂} by Sub(2K_p). K₂'s complex is {A}, and K₁'s is {A}, since 2K_p, with p odd, contains neither M nor O.
- {K₁, K₃} by Sub(pK₂). Both complexes are {M}.
- {K₂, K₃} by Sub(2K_p) ∪ Sub(pK₂). K₂'s complex is {A}. K₃'s is {M}, since C_δ is connected on 2p vertices and so lies in neither family.

So the obstruction needs all three groups, as at n = 6. At the N level, no pair of groups in the cyclic star is infeasible, either at p(p − 1) or at p² − 1, for p = 3, 5, 7, 11, 13 (`outputs/two_p_pairs.txt`).

### 7.6 The N-level version

At the N level (§7.2) the three groups are coupled only through the labelled graphs A and M. Each group keeps its own complex, closed downward, invariant under its normaliser, with χ = 1 and faces of at most B ≤ p² − 1 edges. Steps 1 and 3 of the proof never used isomorphism-closure, so only step 2 needs replacing.

**K₃'s complex at the N level.** For u ∈ (ℤ/p)^×, the multiplier (e, x) ↦ (e, ux) normalises K₃ and carries C_δ to C_{uδ}. So (ℤ/p)^×/±1, which is cyclic of order k = (p − 1)/2, acts regularly on the k graphs C_δ, and k is odd. Suppose M is not in K₃'s complex. Then that complex lives on the C_δ's and is invariant under this C_k. A face of j of them has 4pj edges, so 4pj ≤ p² − 1, that is j ≤ (p − 3)/4 = (k − 1)/2. Define

> **L(k):** no complex on k points that is invariant under C_k acting regularly, and has every face of at most (k − 1)/2 points, has χ = 1.

> **Proposition.** Let p ≡ 3 (mod 4) and k = (p − 1)/2. The N-level system of K₁, K₂, K₃ is infeasible at every budget below p² **if and only if L(k) holds**. If L(k) holds, the N level alone proves M\*_OCR(2p) ≥ p².

*Proof.* If L(k) holds, K₃'s complex must contain M, and steps 1 and 3 of §7.5 finish as before. Conversely, let X be a counterexample to L(k). Then the following is a feasible N-level system at budget (p − 3)/4 · 4p < p²:
- K₃'s complex is X on the C_δ's, invariant under N(K₃), which acts on the C_δ's through (ℤ/p)^×/±1 alone;
- K₂'s complex is {A}, and K₁'s is {A}.

No labelled graph is shared inconsistently: M and O lie in no complex. ∎

**Where L(k) is proved.**
1. **k a prime power ℓ^a.** No face is C_k-invariant, since that would need all k points. So every orbit of faces has size divisible by ℓ, and χ ≡ 0 (mod ℓ). This needs no bound on face size.
2. **By Smith reduction.** Let ℓ^a be the exact power of a prime ℓ dividing k, P the Sylow ℓ-subgroup and m = k/ℓ^a.
   - Faces not invariant under P come in orbits of size divisible by ℓ, so χ(X) ≡ χ(X^P) (mod ℓ).
   - X^P is the complex on the m cosets of P whose faces are the P-invariant faces of X. Its signs agree with those of X, since ℓ is odd. It is invariant under C_m acting regularly, and its faces have fewer than m/2 cosets.
   - So χ(X^P) lies in **V(m)**, the set of χ values of such complexes on m points.
   - If no element of V(m) is ≡ 1 (mod ℓ), then L(k) holds.
   - `cyclic_small_face_chis.py` computes V(3) = {0, 3}, V(5) = {0, ±5}, V(7) = {−14, −7, 0, 7, 14, 21}, and V(9) (28 values). V(11) consists of multiples of 11, and is taken as all of them in its range, which only makes the test more conservative.
3. **Directly.** `cyclic_chi_one_small_faces.py` gives L(k) for k = 3, 5, 9, 15 and 21. At k = 15 it holds even with faces of up to 14 points.

**Coverage** (`two_p_nlevel_coverage.py`; `outputs/two_p_nlevel_coverage.txt`):
- L((p − 1)/2) is proved for **every p ≡ 3 (mod 4) below 127**: p = 3, 7, 11, 19, 23, 31, 43, 47, 59, 67, 71, 79, 83, 103, 107.
- Below 5,000 it is proved for 189 of the 339 such primes.
- The first open case is p = 127, with k = 63 = 3² · 7. There V(9) contains 57 ≡ 1 (mod 7), and V(7) contains 7 ≡ 1 (mod 3), so neither reduction applies.
- Whether L(k) holds for every odd k is open. If it fails at some k, the three-group system has an N-level solution there, and an N-level proof would need further groups.

### 7.7 Beyond n = 2p: the family n = 3p

The cyclic star of `star_cyclic_export.g` (all p-by-cyclic transitive groups containing an n-cycle, with every conjugate that contains it) goes above μ\* at n = 15 and n = 21. In both cases the excess is exactly n: 45 = 30 + 15 and 84 = 63 + 21. It stays at μ\* at n = 20 (`outputs/star_cyclic_scan.txt`). μ\*(3p) = 3·C(p,2), the witness being three blocks of p (the table, at every 3p checked). The mechanism is the n = 2p one with three blocks in place of two, and it works for every prime p ≥ 5.

Write [3p] = ℤ/3 × ℤ/p, with **blocks** {i} × ℤ/p and **fibres** ℤ/3 × {x}. Three graphs partition the pairs:
- **A** = 3K_p, inside the blocks, with 3p(p − 1)/2 = μ\*(3p) edges;
- **T** = pK₃, inside the fibres, with 3p edges;
- **O**, everything else, with 3p(p − 1) = 2μ\* edges.

Let λ be a primitive root mod p, and let 3^v be the exact power of 3 dividing p − 1, so v = 0 exactly when p ≡ 2 (mod 3). Put r = (p − 1)/3^v. The groups:
- **K₁** = ℤ/3 × (ℤ/p ⋊ ⟨λ^{3^v}⟩), acting by (i, x) ↦ (i + s, ux + c) with u ranging over the subgroup C_r of order r. When v = 0 this is ℤ/3 × AGL(1, p).
- **K₂** = (ℤ/p)³ ⋊ ⟨g⟩: independent translations of the three blocks, and g(i, x) = (i + 1, λx).
- **K₃** = ℤ/3 ≀ ℤ/p: independent rotations of the fibres, and the translation x ↦ x + 1.
- The **multipliers** w_u : (i, x) ↦ (i, ux) normalise all three.

> **Lemma.** Let p ≥ 5. Then K₁, K₂ and K₃ are p-by-cyclic, and:
> - **K₁**: T is an orbital. A splits into 3^v orbitals and O into 3^v orbitals, and the multipliers permute each of these two families regularly, through (ℤ/p)^×/C_r ≅ C_{3^v}.
> - **K₂**: the cross pairs form one orbital K_{p,p,p} (3p² edges). A is one orbital if v = 0, and otherwise three orbitals of μ\*/3 edges each, which the multiplier w_λ permutes cyclically.
> - **K₃**: T, and the (p − 1)/2 graphs C_δ, δ ∈ (ℤ/p)^×/±1. Here C_δ has all nine edges between fibres x and x + δ, for every x; it has 9p edges. The multipliers permute the C_δ's regularly through (ℤ/p)^×/±1.

*Proof.*
- **p-by-cyclic.** K₁ has O_p = ℤ/p and quotient ℤ/3 × C_r, which is cyclic because 3 ∤ r. K₂ has O_p = (ℤ/p)³ and cyclic quotient ⟨g⟩. K₃ has O₃ = (ℤ/3)^p and quotient ℤ/p.
- **K₁.** T is one orbital because ℤ/3 is transitive on the three pairs of ℤ/3. In a block, a pair's orbit is its difference up to ±C_r, and −1 ∈ C_r because r is even and 3^v divides (p − 1)/2. So the A-orbitals are the cosets of C_r. For a cross pair, swapping the endpoints normalises the block difference to 1, so the O-orbitals are again the fibre differences modulo C_r. In both families the multipliers act by multiplication on (ℤ/p)^×/C_r.
- **K₂.** The independent translations and g make the cross pairs one orbital. Inside a block the multipliers that return to the same block are ⟨λ³⟩. Together with ±1 these are everything if v = 0, and otherwise a subgroup of index 3, since −1 ∈ ⟨λ³⟩ when 3 | (p − 1)/2. The multiplier w_λ commutes with g and moves each coset of ⟨λ³⟩ to the next.
- **K₃.** As in §7.5, with ℤ/3 on a fibre transitive on its 3 pairs and (ℤ/3)² regular on the 9 pairs between two fibres. ∎

`three_p_groups.g` checks the orders, the p-by-cyclic property and the orbital sizes at p = 5, 7, 13, 19, 31, 37, 43; earlier runs did p = 11, 17, 23, 29. At p = 19, where 9 | p − 1, A and O each split into nine orbitals, as the Lemma says.

> **Theorem.** Let p ≥ 5 be prime, k = (p − 1)/2 and J = ⌊(3p(p + 1)/2 − 1)/(9p)⌋. Suppose **L₃(p)** holds: no complex on k points, invariant under C_k acting regularly, with every face of at most J points, has χ = 1. Then **M\*_OCR(3p) ≥ 3p(p + 1)/2 = μ\*(3p) + 3p**, already at the N level.

*Proof.* Let B = e_max(P) < 3p(p + 1)/2 = |A| + |T|. Every complex below is invariant under the multipliers, as the N level requires.
1. **K₂ forces A.** K_{p,p,p} has 3p² > B edges, so K₂'s complex lives on the A-orbitals. If v = 0 that is the single vertex A. Otherwise it is a complex on three points invariant under their 3-cycle. Such a complex is empty, three points, a triangle's boundary or the full triangle, with χ = 0, 3, 0, 1. So χ = 1 forces the full triangle, that is, A ∈ P.
2. **K₃ forces T,** by L₃(p), exactly as in the n = 2p case: a face of j of the C_δ's has 9pj ≤ B edges, so j ≤ J.
3. **K₁ fails, by Smith at 3.** Let Q be the Sylow 3-subgroup of the multiplier group; Q acts on K₁'s complex Δ₁ through C_{3^v}. Faces of Δ₁ not invariant under Q come in orbits of size divisible by 3. So χ(Δ₁) ≡ Σ ± (Q-invariant faces) (mod 3). The signs agree, since every Q-orbit on orbitals has odd size.
   - A Q-invariant face uses all of A or none of it, and all of O or none of it, since Q is transitive on each family. It may also contain T.
   - O alone has 2μ\* > B edges, and A ∪ T has |A| + |T| > B. So the Q-invariant faces are exactly the vertices A and T, and both are present by steps 1 and 2.
   - Hence χ(Δ₁) ≡ 2 (mod 3), not 1.

   When v = 0, Q is trivial and this is the direct count of §7.5's step 3. ∎

**L₃(p) is easier than L(k) of §7.6,** because the faces are smaller: J is about k/3. It holds:
- **(a)** when J = 0, or k is a prime power;
- **(b)** when some ℓ^a exactly dividing k exceeds J. Then no face is invariant under the Sylow ℓ-subgroup P, so χ ≡ 0 (mod ℓ);
- **(c)** when 2ℓ^a > J and m = k/ℓ^a ≢ 1 (mod ℓ). Then X^P has vertices only, so χ(X^P) ∈ {0, m};
- **(d)** when, for some ℓ^a ∥ k with m = k/ℓ^a ≤ 21, CP-SAT finds no complex on m points, invariant under C_m acting regularly, with faces of at most ⌊J/ℓ^a⌋ points and χ ≡ 1 (mod ℓ) (`cyclic_face_residue.py`).

**Coverage** (`three_p_coverage.py`; `outputs/three_p_coverage.txt`): every prime p from 5 to 59, and 316 of the 667 primes below 5,000. The first open case is p = 61 (k = 30, J = 10). At n = 15 the three groups alone are infeasible at 44 and feasible at 45 (`outputs/three_p_star.txt`). For p ≡ 1 (mod 3) the groups do not share a 3p-cycle (K₂ does not contain one), so they cannot be checked as a star; the n = 21 cyclic star's 84, from other groups, is consistent with the Theorem.

**Not covered:**
- **c blocks with c ≥ 4.** T then splits into ⌊c/2⌋ orbitals under any cyclic fibre action, and for even c the K₂-type cross orbital at block distance c/2 has only (c/2)p² edges, under the budget. n = 20 gives nothing.
- **Two-part witnesses, which carry positive density.** These are a block plus a foreign block, e.g. n = 30 = 13 + 17 with μ\* = C(13,2) = 78.
  - The natural star is the hub ℤ/13 × ℤ/17 with every subgroup of AGL(1,13) × AGL(1,17) containing it: 58 groups, each with its Oliver readings, mod-q included (`two_block_star.g`; `nlevel_star.py` now takes readings).
  - That star is **infeasible at 77 and feasible at 78** (`outputs/two_block_star_30.txt`). It recovers μ\* exactly and gives nothing above it.
  - In these block-preserving groups the cross orbital K_{a,b} has ab > μ\* edges and stays out of every face. So the two blocks' complexes never interact and no forcing chain forms.
  - Going above μ\* for two-part n needs groups that are not block-preserving products. Since the blocks have different sizes, such groups are not transitive on the two blocks together, so the coupling would have to come through other subgroups. None has been found.

**What stays open:**
- **M\*_OCR(2p) ≤ p² over all groups.** Sub(K_{p,p}) is not Oliver-χ-resistant in general: at n = 6 the resistant property also needs the odd-sided bipartitions (1 + 5) and a star residue (`orbital-evasiveness-notes.md` §7.9). "Bipartite with two odd sides", which also has e_max p² at n = 2p, is the natural candidate to try.
- **Other non-prime-power n.**

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

μ\*_χ(12) and μ\*_χ(14) are not known, so these bounds separate M\*_OCR from μ\* only; the separation from μ\*_χ is shown at n = 6 and n = 10. No forcing core has been extracted at n = 12 or 14, and neither bound has been independently checked.

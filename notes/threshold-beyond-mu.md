# The sparse-evasiveness threshold is larger than μ\*: foreign blocks count at full capacity

*A finding of 2026-11-10, one sitting, not yet read by a second reader. It concerns what Oliver's congruence proves about sparse properties, not the value of μ\*(n): nothing here changes μ\*, B, the table or the classification. Scripts: `cyclic_chi_values.py`, `threshold_scan.py`.*

## 1. Statement

Write **E(n)** for the largest B such that every nontrivial monotone graph property on n vertices all of whose members have fewer than B edges is evasive. Proposition 1 of the short note is E(n) ≥ μ\*(n). The orbital-annihilation argument behind it asks every orbital of Γ to exceed the budget. That is more than Oliver's congruence needs.

> **Proposition.** Let Γ ≤ S_n be an Oliver group with top prime q (or trivial top), one of whose orbits is a block of prime size r on which Γ induces ℤ/r ⋊ C_t. Let k = C(r,2)/orb(r, t) be the number of pair-orbitals inside the block, and suppose that **no C_k-invariant simplicial complex on k points, other than the full simplex, has Euler characteristic ≡ 1 (mod q)** (= 1, if the top is trivial). Let M be the smaller of C(r,2) and the least orbital of Γ *outside* the block's own pairs. Then every nontrivial monotone graph property whose members have fewer than M edges is evasive.

*Proof.* Let P be such a property and suppose it is non-evasive, so χ(Δ_P^Γ) ≡ 1 (mod q). Every orbital outside the block has at least M edges, so no invariant graph in P contains one: the faces of Δ_P^Γ are sets of the block's own k orbitals whose union lies in P. Those orbitals are the circulants Cay(ℤ/r, ±aH), H the twist subgroup, and the multiplier x ↦ gx on the block — extended by the identity elsewhere — is a permutation of [n] that cycles them. P is invariant under every permutation of [n], so Δ_P^Γ is invariant under that cycle: a C_k-invariant complex on k points. It is not the full simplex, because the union of all k orbitals has C(r,2) ≥ M edges. By hypothesis its Euler characteristic is not 1 modulo q. ∎

The multiplier need not normalise Γ, and the group it generates with Γ is in general not an Oliver group (its top would have order t·k, not a prime power). The symmetry used is P's, not Γ's — the observation of `orbital-evasiveness-notes.md` §9.7 ("isomorphic orbitals"), which already records that P holds all k orbitals or none and that budgets up to m₁ + m₂ are covered. What is added here is that the whole type is neutralised, for every budget up to C(r,2), and what that does to the constants.

## 2. Which k qualify

`cyclic_chi_values.py` enumerates the C_k-invariant proper complexes on k points (the empty one included, χ = 0):

| k | complexes | values of χ | q for which some χ ≡ 1 (mod q) |
|---|---|---|---|
| 2 | 2 | 0, 2 | none |
| 3 | 3 | 0, 3 | 2 |
| 4 | 6 | −2, 0, 2, 4 | 3 |
| 5 | 9 | −5, 0, 5 | 2, 3 |
| 6 | 42 | −9, −7, −6, −4, −3, −1, 0, 2, 3, 5, 6, 8, 9, 11 | 2, 5, 7 |
| 7 | 99 | −14, −7, 0, 7, 14, 21 | 2, 3, 5, 13 |

For k = 8, 9, 10, 11 and 13 a constraint solver finds χ = 1 unattainable; since |χ − 1| ≤ 2^k, every q > 2^k is then safe. **At k = 12 χ = 1 is attainable**, so the Proposition gives nothing there — consistent with the 12-point cyclic counterexample to the generalised conjecture in the literature (attribution from memory, not checked). At prime-power k = ℓ^a the reason is visible: every face orbit has size divisible by ℓ, so χ ≡ 0 (mod ℓ). At k = 6 and 10 it is a fact about the orbit census, not a congruence.

So a foreign block with **r − 1 = 2kq^e, k ≤ 11 or k = 13, and q outside a finite set depending on k**, is worth C(r,2) for the purpose of proving sparse properties evasive — efficiency 1, whatever the framework's η = 1/k.

## 3. Consequences

**For the short note, with its hypothesis unchanged.** (BCG₁/₅) takes d ∈ {2, 4, 6, 12}, that is k = d/2 ∈ {1, 2, 3, 6} with t = q an odd prime. All four qualify once q ∉ {2, 5, 7}, which holds for n ≥ 426. The foreign term r(r − 1)/24 in the note's bounds becomes C(r,2), and min{C(c,2), C(r,2), cr} ≥ C(n,2)/26 for n ≥ 105. So under (BCG₁/₅) **every nontrivial monotone property with fewer than C(n,2)/26 edges is evasive for all large n** — thirteen times the note's 1/350, as a statement about evasiveness and not about μ\*.

**For the ceilings.** With every qualifying foreign block at efficiency 1 the residue class no longer enters the constant, only the parity of n does. Both columns below are cap_F(η) = η/(1 + √(Fη))²; the μ\* column takes the efficiency η = 2/d the class allows (`arithmetic-of-density.md` §3.3.5), the E column takes η = 1.

| n mod 12 | μ\*(n)/C(n,2) ceiling | attained by | E(n)/C(n,2) ceiling, lower bound | attained by |
|---|---|---|---|---|
| 0, 4, 6, 10 | 1/4 = 0.2500 | F = 1, η = 1 | 1/4 = 0.2500 | the same shape (d = 2) |
| 2, 8 | (2 − √3)/2 = 0.1340 | F = 1, η = 1/3 | **1/4 = 0.2500** | F = 1, d = 6 (k = 3) |
| 1, 9 | 3 − 2√2 = 0.1716 | F = 2, η = 1 | 3 − 2√2 = 0.1716 | the same shape (d = 2) |
| 3, 7 | 1/8 = 0.1250 | F = 2, η = 1/2 | **3 − 2√2 = 0.1716** | F = 2, d = 4 (k = 2) |
| 5 | 5 − 2√6 = 0.1010 | F = 2, η = 1/3 | **3 − 2√2 = 0.1716** | F = 2, d = 6 (k = 3) |
| 11 | 7 − 4√3 = 0.0718 | F = 4, η = 1/3 | **3 − 2√2 = 0.1716** | F = 2, d = 12 (k = 6) |

So the E column is 1/(1 + 1)² = 1/4 at even n and 1/(1 + √2)² = 3 − 2√2 at odd n, and the worst class moves from 0.0718 at n ≡ 11 to 0.1716 at every odd class. At n ≡ 11 the shape changes as well as the value: for μ\* the four-block shape wins there, for E the two-block shape with d = 12 does. *Standing of the E column:* a lower bound on E(n), conditional on the bounded-cofactor hypothesis at the listed d as the μ\* column is, and nothing bounds E from above; arithmetic on the cap formula, spot-checked on n from 9,000 to 12,000, where the best one-foreign value in classes 2, 7 and 8 is 0.2495, 0.1715 and 0.2497, and classes 5 and 11 reach 0.207 and 0.198 — above the tabulated value because of special n, so consistent with it without pinning it. As in the μ\* column these are ceilings for generic n; special n exceed them in both columns. The k = 6 row needs q ∉ {2, 5, 7} and the k = 3 rows q ≠ 2, automatic once n is large. The hypothesis may also be widened to every d = 2k with k qualifying, which only adds admissible d.

**On the table, to n = 4000** (`threshold_scan.py`, one-foreign shapes n = Fc + r and pure fused shapes only). Under the old scoring this enumerator reproduces the table at all 3,410 rows, which checks the enumerator. Scoring qualifying foreign blocks at C(r,2): 1,847 rows improve; the floor rises from 0.0462 at n = 2759 to **0.0887 at n = 1159**; n = 2759 itself goes to 0.1568 (2 × 773 + 1213, 1212 = 12·101, k = 6, q = 101) and n = 2183 to 0.1613. At n = 1159 the binding orbital is the fused class 4·C(173,2), which this device does not touch.

## 4. What this is not, and what is owed

- **Not a statement about μ\*.** E(n) ≥ μ\*(n) was the only use made of μ\*; this shows the inequality is strict at most n in the range scanned. μ\* remains the group-theoretic invariant the framework computes.
- **One sitting.** The Proposition is four lines and the table is an enumeration; neither has had a second reading. `pending-checks.md` A49.
- **The scan stops at 4000 and uses two shape families.** A full-range value needs the device inside the exact enumerator.
- **Unexplored in the same direction:** k = 12 and beyond at budgets too small for the bad complexes to fit (below 2·orb the complex is k isolated points and χ ∈ {0, k}); the same device on the intra classes of a partial-twist matching block and on the cross distance classes of a fused class, which §9.7 notes are also of one type; and whether the fused class 4·C(c,2) that now binds can be relieved the same way.

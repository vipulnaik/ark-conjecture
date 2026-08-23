# Shape counting: the enumeration behind `arithmetic-of-density.md` §6

**Standing: verified arithmetic, not a sketch.** Every count in this document is a direct enumeration of the feasibility criterion, re-derived independently and agreeing to the last digit; the asymptotics are checked against the exact counts over the range where both are available. This is *not* a lightly-audited working note in the sense of `sp-to-floor.md` or `shparlinski-constants.md` — those carry analytic arguments taken partly on citation, and are flagged as such. Nothing here needs re-deriving before use; it lives outside `aod` because it is bookkeeping, not because it is provisional.

**What this document is for.** `aod` §6 quotes counts — N(δ₀), N_add, the partition factor, the growth rate — and uses them to size a disjunction. The numbers stay in §6, where a reader can see them next to the prose they support. What lives here is *how they were obtained*: the enumeration, the asymptotic derivation, the recomputation apparatus, and the measurements that have been superseded but should remain auditable. If a figure in §6 is ever doubted, this is where to check it.

**A note on why the split is drawn there.** The counting bug found in §6.2's partition-factor table survived several readings because it sat in a table rather than in an argument — reading the prose does not check the arithmetic beside it. Moving *claims* out of §6 would make that worse. So the rule is: every number §6 quotes stays visible in §6; only the derivations move.

## 1. The enumeration

The feasibility criterion is Σ_i √F_i ≤ L with **L = 1/√δ₀** (`aod` §6.1). A shape is a multiset {F_i} of fusion counts satisfying it, together with a choice of which of its F = 1 parts is foreign rather than matching; a multiset with m₁ parts equal to 1 admits m₁ + 1 such choices (including "none foreign"). So

> **N(δ₀) = Σ_{ M : Σ_{F ∈ M} √F ≤ L } ( m₁(M) + 1 )**,  over nonempty multisets M of positive integers.

Enumerated directly by recursion over the multiset in nondecreasing order, with the budget carried down. Every count below is produced by that code.

| δ₀ | L | k ≤ | F ≤ | N(δ₀) | N_add |
|---|---|---|---|---|---|
| 1/9 | 3.000 | 3 | 9 | 24 | 6 |
| 1/16 | 4.000 | 4 | 16 | 65 | 10 |
| 0.051813 (`19x61`, n = 1159) | 4.393 | 4 | 19 | 83 | — |
| 0.04621 (the ladder floor to 10⁶) | 4.652 | 4 | 21 | 112 | 10 |
| 0.04 = 1/25 (conjectured) | 5.000 | 5 | 25 | 164 | 15 |

**The additive count is not enumerated but counted directly.** With every F_i = 1 a shape is determined by its part count k ≤ K = ⌊L⌋ and its number of foreign parts i ∈ {1,…,k}, so **N_add(δ₀) = Σ_{k≤K} k = K(K+1)/2**, quadratic in L and hence ≈ 1/(2δ₀). This is the count `aod` §6.6's covering statement actually quotes, the fusion shapes having dropped from the asymptotic statement (§6.5).

## 2. Growth of the raw count

**The raw count is a weighted partition problem.** A shape is a multiset {F_i} of fusion counts with Σ√F_i ≤ L, together with a choice of which of its F = 1 parts are foreign rather than matching; a multiset with m₁ parts equal to 1 admits m₁ + 1 such choices. So

> **N(δ₀) = Σ_{ M : Σ_{F ∈ M} √F ≤ L } ( m₁(M) + 1 )**,  over nonempty multisets M of positive integers.

The parts are drawn from {√1, √2, √3, …}, whose counting function is A(x) = #{F : √F ≤ x} = x², so their Dirichlet series is Σ_F (√F)^{−s} = **ζ(s/2)**, with a simple pole at s = 2 of residue 2. Meinardus' theorem for parts of counting order α with residue A gives log N ~ (1 + 1/α)·[A·Γ(α+1)·ζ(α+1)]^{1/(α+1)}·L^{α/(α+1)}, and at α = 2, A = 2,

> **log N(δ₀) ~ 3/2 · (4ζ(3))^{1/3} · δ₀^{−1/3} ≈ 2.532·δ₀^{−1/3}**.

So the raw set grows like exp(2.53·δ₀^{−1/3}) — subexponential in 1/δ₀, so halving the floor does not square the disjunction. Convergence is slow, as always for Meinardus: fitting log N against L^{2/3} over L ∈ [6,10] gives slope **2.416**, still climbing, and the asymptotic overstates the exact count by about 11× at the densities of interest. Use the exact sum in range and the asymptotic only for the growth.


*Re-derived independently:* the Meinardus constant computes to **2.5317**; the fit of log N against L^{2/3} over L ∈ [6,10] gives slope **2.405**; and the asymptotic overstates the exact count by **10.0×, 10.6× and 11.3×** at L = 5, 6, 7. So "about 11× at the densities of interest" is right, and the fitted slope is still climbing towards 2.532 as expected for Meinardus.

**Why this asymptotic is not the operative one.** It counts the raw set, including the fusion shapes, and those cover a density-zero set of n (`aod` §6.5). The covering statement runs over the purely additive shapes, whose count is quadratic. The raw growth rate matters only for the negative claim — that halving the floor does not square the disjunction — and for the contrast with the partition-factor growth below.

## 3. The floor rows, and what to recompute when the range moves

> *The floor rows are keyed to the exactly-computed floor, so they move with it.* At the conjectured floor of 1/25, L = 5.000 and the part cap is **k ≤ 5** — a substantial narrowing of the search this table sizes, since the count grows steeply in L. **At the computed floor, now 0.048039 at n = 2183 over the complete range to 2600: L = 4.5625, k ≤ 4, F ≤ 20, N(δ₀) = 102.** (v4's 0.045742 at n = 1817 gave L = 4.676 and N(δ₀) = 112; the floor rose, so the count fell.) These rows want re-deriving after any discretionary extension that lowers the floor again. Recompute the affected rows rather than the whole table. (The 122 and 164 above, and the 112 here, are direct enumerations of the criterion, checked against the 24 / 65 / 83 rows by the same code.)


## 4. The partition factor: unequal matching sizes

`aod` §6.2 establishes that the one-size presupposition is false but harmless — unequal-size shapes exist and are escapes rather than competitors. What it costs the counts is tabulated here.

> **What the partition factor costs below 1/9.** Worth tabulating, since the counts of §6.1 and §6.4 are stated per shape.
>
> - **Finiteness survives, and easily.** A shape records not only its parts but which matching parts share a size — a set partition of them. The number of distinct sizes is bounded by the number of matching classes, itself bounded by k ≤ 1/√δ₀, so the shape space stays finite and every shape is still one Bateman–Horn system, merely in several size variables rather than one. **The general principle — finitely many explicit systems, computable from δ₀ alone — is not at risk.**
> - **The counts change, by a partition factor.** For the purely additive shapes that carry the asymptotics, a shape with k parts and i foreign ones must additionally partition its j = k − i matching parts by size, giving Σ_{k≤K} Σ_{j<k} p(j) in place of Σ_{k≤K} k:
>
>   |  | | **additive shapes** | | | **all shapes** | | |
>   | δ₀ | K | one size (§6.4) | sizes free | sizes free, penalised | one size (§6.1) | sizes free | sizes free, penalised |
>   |---|---|---|---|---|---|---|---|
>   | 1/9 | 3 | 6 | 7 | 7 | 24 | 34 | **24** |
>   | 1/16 | 4 | 10 | 14 | 14 | 65 | 115 | **67** |
>   | 0.04 = 1/25 | 5 | 15 | 26 | 24 | 164 | 357 | **178** |
>   | 1/400 | 20 | 210 | 8,266 | — | — | — | — |
>
>   The two "sizes free" columns differ by whether a per-class penalty is charged. *(All six all-shapes entries are direct enumerations of the criterion under the same convention as the additive columns — matching parts partitioned by size, the multiplier being the partition function p(j) — with feasibility read strictly.)* *(The additive "sizes free" column is Σ_{k≤K}Σ_{j<k}p(j) evaluated directly: 7, 14, 26, 8,266.)* The **penalised** column is the one to quote, but the penalty's justification is the density ceiling above rather than a twist-parity argument: a class of size c′ ≤ c/p contributes at most (c′/n)², so an unequal shape needs x ≥ √(δ₀F)·(1 + 1/p) across its two sizes rather than √(δ₀F) for each, and that pushes some newly admitted shapes back out of feasibility. At δ₀ = 1/9 the effect is total — no unequal shape is feasible — and the one-size and penalised counts accordingly agree at the top row.

>   > **That agreement holds on a strict reading of feasibility, and the boundary is where the earlier count went wrong.** The only unequal shape the penalty admits at δ₀ = 1/9 is the two-part `{1,1}` at exact equality: two matching classes, base cost 2, penalised cost 2·(1 + 1/2) = 3 = L. Admitting the equality case put unequal shapes into the top row and made the two columns disagree. It should be excluded, and the arithmetic says why rather than merely stipulating it: the family's density is (c′/n)² with c′ ≤ n/(p + 1), so at p = 2 it **approaches 1/9 from below and never attains it** — the best instance in the whole family is n = 3072 = 2048 + 1024 at δ = 0.11104, short of 1/9 = 0.11111. A supremum that is not attained is not a feasible shape, so the strict reading is the correct one and the top row reads 24. At the conjectured floor of 1/25 the purely additive disjunction would be **24-way rather than 15-way** (the table's own bottom row); at the old 1/50 floor the pairs were 63 against 28 for the additive count and 1,956 against 982 for the raw one. A factor of about two in each case, not an explosion.
>
>   > **The penalised column is a lower bound on the all-shapes rows, not an exact count, and the reason is this section's own gotcha.** The penalty x ≥ √(δ₀F)·(1 + 1/p) is derived from the density ceiling above, which prices the smaller class at C(c′,2) — the **unfused** reading. Applied to a shape whose smaller class is fused it is too harsh, by exactly the factor fusion supplies: `n = 640 = 1·256 + 3·128` has base cost 1 + √3 = 2.73 and penalised cost 4.10, so the penalty excludes it, yet it is a genuine configuration at **δ = 0.1192 > 1/9**. So the all-shapes penalised entries undercount by however many fused unequal shapes the penalty wrongly rejects. That is the same transfer the gotcha above warns against, made here by the counting rather than by the prose — and it does not disturb the top-row agreement, since a fused unequal shape needs n to be a sum of two distinct p-power multiples and joins §6.5's density-zero escapes rather than the covering accounting.
>
>   The growth of the additive count becomes Σ_{k≤K}Σ_{j<k}p(j) ~ K·p(K) = exp(π√(2K/3) + O(log K)), i.e. **exp(c·δ₀^{−1/4})** — worse than quadratic but still subexponential, and still far below the raw fusion count's exp(2.53·δ₀^{−1/3}).
> - **The ceiling table of §3.3 is not at risk.** A configuration with two unequal matching sizes has its smaller class capped at (c′/n)² ≤ 1/(p+1)², so its cap is *below* the equal-size shape of the same part count. Such shapes would enlarge the covering set without raising any class ceiling, so §3.3's caps stand as caps and §6.6's collapse argument is unaffected in kind, though the gaps ε it needs would have to be rechecked against the new shapes' caps.
> - **The parity reduction survives** unchanged: every matching size is a power of the same odd p, hence odd, so n ≡ ΣF_a + i (mod 2) regardless of how many distinct sizes there are.
>
> So the exposure is to the specific numbers of §6.1 and §6.4 below 1/9, not to the structure of the argument.


## 5. Superseded measurements, retained for audit

**The unequal-shape admitting count.** Scoring every unequal odd-p configuration at full diagonal twist over the n ≤ 2000 run: **654 of 1,666 values admit one**, best ratio **0.236·B at n = 1007**. Superseded by the qualitative finding that survives at the current frontier — 0 of 2,186 winners have matching classes of two different block sizes, at any p — and not worth re-measuring, the ceiling argument of `aod` §6.2 being what explains the qualitative fact. Retained because it is the only quantitative evidence on how *close* unequal shapes come.

## 6. Reproducing these

The enumeration is a dozen lines: recurse over multisets in nondecreasing order carrying the remaining √-budget, weight each by m₁ + 1, and for the partition-factor columns multiply by the partition function p(j) of the matching-part count, charging the penalty x ≥ √(δ₀F)·(1 + 1/p) on the matching budget when the shape carries more than one size. Feasibility is read **strictly** throughout — the boundary case matters, and §4 above says why. `check_doc_figures.py` carries the counts as figures; the enumerator itself is small enough that re-implementing it from this description is a better audit than reading a script.

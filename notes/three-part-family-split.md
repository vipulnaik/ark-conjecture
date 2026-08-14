# The three-part family's internal split: which reading realises it

*Extracted from `arithmetic-of-density.md`. It is kept as a separate note because its conclusions are about **runners-up** rather than about which shape wins at n, so nothing in the main line depends on it — while the arithmetic it contains is worth preserving.*

**What it determines, and what it does not.** Everything here is internal to the three-part family n = 2c + r, comparing S4 (unfused pair), S5 (top-layer fused) and S7 at F = 2 (cyclic-layer fused) against each other. Combined with the ceiling table of `aod` §3.3.5, two facts frame it:

> - **S4 never wins at n, at any residue, asymptotically.** At the eight odd residues where the family attains the class ceiling — 1, 3, 5, 9, 13, 17, 19, 21 mod 24 — the split is congruence-forced at 100 / 0 / 0 in the fused rung's favour. At the other four — 7, 11, 15, 23 — the ceiling belongs to the two-part **F = 4** shape, which beats every reading of n = 2c + r. No residue is left over.
> - **The supply analysis below is therefore about runners-up.** Where the family wins, no supply argument is needed: the fused rung wins by congruence. The singular-series computation is required exactly at 7, 15 and 23 — where the family *loses* — so what it determines is which reading realises the family's ceiling of 0.085786 at 7 and 15, and 0.050510 at 23. The first is the runner-up to F = 4's 1/9; the second is third place, behind F = 4 and F = 6 at (2 − √3)/4.

**Why it is worth keeping anyway.** Three things in it survive independent of who wins. `aod` §7's disjunction-collapse argument turns on the gap between the winner and the next shape down, which at 7 and 15 is precisely this family. The **exact** agreement of the two singular series — identical local factors at every prime, for a structural reason — is a fact about the systems, not about the competition. And §3 below is a careful account of what a Bateman–Horn heuristic can and cannot support when the effect being predicted is the same order as the model's own error; that is a caution about method, and it is the subject of item T5a in `pending-checks.md`.

**The asymptotic shares of n**, for reference, since this document no longer sits next to them: S3 takes the twelve even residues (12/24), S7 at F = 2 the eight odd residues 1, 3, 5, 9, 13, 17, 19, 21 (8/24), S7 at F = 4 the four residues 7, 11, 15, 23 (4/24), and S4 and ties nothing.

---


*The competition is between **S4** and **S7 at F = 2** — the unfused and cyclic-layer-fused readings of the same n = 2c + r. S5 is not a party to it: top-layer fusion obeys no congruence on c, so it does not sort by the c mod 8 law the shares are built on, and it is supply-limited to r = 2^a·u + 1 with u small (`aod` §3.3). It contributes O(n/log n) values, which is why it takes no share of the limit and appears only in §2's account of the finite-range discrepancy.*

## 1. The predicted shares

*The two shapes of `aod` §3.2 have overlapping ceilings, so the question of which realises **the family** at a given n is not settled by the ceiling table. It is settled — asymptotically — by the relative supply of the three underlying systems, a singular-series computation of the same kind as `aod` §§3.1–3.3. Everything in §§1.1–1.3 is that computation and is therefore a statement about the family; §1.4 converts it into shares of n, which needs the ceiling table as well.*

### 1.1 The three systems, and why their singular series agree

**The three outcomes within the family, and the systems behind them.** Which of S4, a tie, or the fused rung is the argmax *of the three-part family* is decided by the class of c, and hence by the condition on r. The ceilings in the last two columns are the family's own; where the **class** ceiling is higher it belongs to a shape outside this competition and is given for comparison, since the family cannot reach it at all:

| outcome | c mod 8 | system | family ceiling at 7, 15 | at 23 |
|---|---|---|---|---|
| S4 wins | 1 | q, Dq+1, (n−r)/2 all prime, D = 4 (res 7, 15) or 12 (res 23) | 0.085786 | 0.050510 |
| tie | 5 | same system | 0.085786 | 0.050510 |
| fused rung wins | 3, 7 | same with **D doubled** — 8 or 24 — since c ≡ 3 (mod 4) forces 8 \| r − 1 | 0.085786 | **0.042020** |
| — | — | *class ceiling, attained by the two-part F = 4 shape (§3.3.5)* | **1/9 = 0.111111** | **7 − 4√3 = 0.071797** |

So at both residues the family competes for a ceiling strictly below the class's, and the winner of that competition is not the winner at n. The rest of §1 analyses the competition; §1.4 closes with what it implies for shares of n.

Three facts settle the split. **The two singular series agree**: computed over n in a test band, 𝔖(D) and 𝔖(2D) match to four decimals at all three residues, since the systems differ only in a coefficient and ω(ℓ) = 3 generically for both. **The log factors agree** to within a percent, since the balance points differ but the arguments are all Θ(n). And **c mod 8 is decided by q mod 4** — from c = (n−1)/2 − (D/2)q with q odd — so the D-system's solutions split 1:1 between c ≡ 1 and c ≡ 5, i.e. between S4-wins and ties, by Dirichlet.

**The singular series agree exactly, not approximately.** For our two pairs — D = 4 against 8 at residues 7 and 15, and D = 12 against 24 at residue 23 — the local factors are *identical at every prime*. The reason is structural rather than numerical: ω(ℓ) < 3 requires two of the roots {0, −D⁻¹, h·(D/2)⁻¹} to collide, and the two collision conditions are **h ≡ 0** and **h ≡ −1/2 (mod ℓ)**, neither of which mentions D. At the primes dividing D the two systems degenerate the same way. Checked at every ℓ < 500 over a band of n: zero mismatches.

### 1.2 The log factors, and how firm the 1 : 1 : 2 limit is

*The 1 : 1 : 2 of this sub-section is the split of the family's argmax between c ≡ 1, c ≡ 5 and c ≡ 3-or-7 (mod 8) at residues 7 and 15. It is a statement about which system supplies the family's best configuration, and is unaffected by the class ceiling sitting above the family there — the F = 4 shape obeys 4c ≡ 4 (mod 8) and takes no part in this competition.*

**The log factors do not agree, and that is where the split departs from 1 : 1 : 2.** The two systems balance at different points — x\* = 0.29289 for the D-system, 0.20711 for the 2D-system — so the arguments of the three logs differ:

| n | A+B share | C share | C/(A+B) |
|---|---|---|---|
| 10⁵ | 0.4899 | 0.5101 | 1.0412 |
| 10⁶ | 0.4920 | 0.5080 | 1.0325 |
| 10⁹ | 0.4951 | 0.5049 | 1.0198 |
| 10¹² | 0.4965 | 0.5035 | 1.0142 |
| 10²⁰ | 0.4980 | 0.5020 | 1.0081 |

So **1 : 1 : 2 is the limit the heuristic predicts, not the value at any finite n**: the fused class is favoured by a factor 1 + O(1/log n), about 4% at 10⁵ and 3% at 10⁶. The correction is well inside the sampling noise of anything measurable at present, which is why the table below quotes the limiting fractions.

> **How firm is the limit? Less firm than the constants elsewhere in §3, and for a reason worth stating.** Reaching 1 : 1 : 2 takes two steps beyond the singular-series computation. First, that each class's supply near the balance point is given by its Bateman–Horn count; second, that the *argmax* over classes therefore lands in a class with probability equal to that class's share of the pool. The second step is an extreme-value claim about which class happens to supply the candidate closest to x\*, not a claim about counts, and it is the one carrying the weight.
>
> The competing rates are these. The deterministic bias between the two systems is the log-factor ratio above, of relative size **Θ(1/log n)**. The stochastic fluctuation in each class's count over a window of length Θ(n) is relative size **O(log^{3/2}n/√n)**, which vanishes far faster — so *if* the Bateman–Horn count is accurate to relative error o(1/log n), the bias dominates the noise, the argmax probabilities converge, and the limit is as stated. The trouble is that **the neglected secondary term in the Bateman–Horn asymptotic is itself of relative order 1/log n** — the same order as the effect being predicted. Much of it cancels between the two systems, which share their functional form, but not all: they have different d and different balance points, so their secondary terms differ, and the surviving difference is not known to be smaller than the bias it would perturb. It could shift the constant in the drift or, in principle, its sign.
>
> **A third effect was looked for and is provably absent, which matters because it would have been the largest.** The natural candidate for something dominating both the bias and the noise is the *singular series ratio between the two systems, fluctuating with n*: 𝔖 depends on which primes divide n and n−1, those divisors jump irregularly, and the resulting factors are Θ(1) rather than 1 + o(1). Had that fluctuation been present and symmetric, it would have swamped the Θ(1/log n) bias, the argmax would have been decided by it, and the limit would follow from the pool shares regardless of the Bateman–Horn secondary term. **It is identically zero.** Writing the system as f₁ = q, f₂ = Dq + 1, f₃ = h − (D/2)q with h = (n−1)/2, the root count mod ℓ is D-independent: the collision f₁ = f₃ happens iff h ≡ 0 (mod ℓ), and f₂ = f₃ iff h ≡ −1/2 (mod ℓ) — **both conditions are on h alone.** The only D-dependence is the degenerate branch ℓ | D/2, which for the D-versus-2D pair at issue (D = 4 against D = 8) never occurs at odd ℓ. Verified: 𝔖_D/𝔖_{2D} = 1.0000 at every n ≡ 7 and every n ≡ 15 (mod 24) across [10⁵, 3×10⁵] and [10⁶, 1.2×10⁶], 8,333 values each, with root counts agreeing at every ℓ tested. (The branch is *not* vacuous in general — at ℓ = 3 the counts do differ between D = 6 and D = 12 — so this is a fact about the pair being compared, not a general principle.)
>
> **So the two-effect analysis above is the whole story, and it cuts against the softer reading rather than for it.** With no Θ(1) fluctuation to decide the argmax, the Θ(1/log n) bias really is the leading term steering it, and the residue classes involved offer no rescue: the moduli here are fixed and small (c mod 8, n mod 24), where Siegel–Walfisz gives an error smaller than any fixed power of 1/log n. This is the *high*-uniformity regime, not the Maier / Friedlander–Granville irregularity regime, whose theorems need moduli growing like x/(log x)^A or short intervals. Primes are more uniform here than the effect being measured, so the bias is not drowned out — which is exactly why the finite-n tilt in the table above is real and why convergence is slow.
>
> So the honest statement is that **1 : 1 : 2 is what the heuristic gives when read at leading order, and is well converged in that reading, but the convergence rate and the accuracy of the model are of the same order and no argument here separates them.** Nor can computation: an effect of size 1/log n moves from 10% to 7% between 10⁵ and 10⁶, so the ranges reachable at present cannot distinguish 1 : 1 : 2 from a nearby limit, or from no limit at all. This is a softer claim than the ceiling constants of §3.3, which are exact algebraic numbers derived from a balance condition, or the local-solubility classification of §3.3, which is a finite computation. It is a drift that is one-signed and slow *under the model*, and the model's own error at that order has not been controlled.

### 1.3 The predicted shares, by residue — within the family

**Predicted outcome shares, by residue — within the three-part family.** The last column records whether the family attains the class ceiling at that residue; where it does not, the row says which of S4, the tie and the fused rung is the family's argmax, not which shape wins at n.

| n mod 24 | rung situation | S7 at F = 2 | S4 | tie | family attains the class ceiling? |
|---|---|---|---|---|---|
| 1, 3, 5, 9, 13, 17, 19, 21 | B alone | **100%** | 0% | 0% | **yes** |
| 11 | B alone | **100%** | 0% | 0% | no — F = 4, at 7 − 4√3 |
| 7 | B ≡ C | **50%** | 25% | 25% | no — F = 4, at 1/9 |
| 15 | B ≡ C | **50%** | 25% | 25% | no — F = 4, at 1/9 |
| 23 | C alone | 0% | **50%** | **50%** | no — F = 4, at 7 − 4√3 |
| **all odd n** | | **83.3%** | **8.3%** | **8.3%** | eight of twelve |

Residue 11 is split out from the B-alone block because it behaves identically *within* the family — rung B alone, 100 / 0 / 0 — while differing on the last column, and lumping the two facts has caused confusion before.

At the nine B-alone residues the fused rung has a strictly higher cap, so the argmax always lies at c ≡ 3 or 7 (mod 8). At 7 and 15 the caps coincide and all three c-classes compete, splitting 1 : 1 : 2 as derived above. At 23 the fused rung cannot reach the cap, so only c ≡ 1 and c ≡ 5 (mod 8) are in play — S4 and ties, evenly. Over all n, halving for the even residues:

> **Within the three-part family: S7 at F = 2 → 9/24 + 1/24 = 10/24 ≈ 41.7% outright; S4 → 1/24 ≈ 4.2%; tied → 1/24 ≈ 4.2%**, with S3 taking the even 12/24. The four sum to 1. (§1.4 closes with the absolute shares, which differ.)

### 1.4 Row by row

**Row by row.** Each residue's row is fixed by two congruences: which c-classes can supply a solution at all, and which rung each of those classes lands on. Both follow from c = (n − 1)/2 − (D/2)q with q odd.

*The nine **B alone** residues — 1, 3, 5, 9, 11, 13, 17, 19, 21.* (Eight of these are also the residues where the family attains the **class** ceiling; **11 is not**, its ceiling being cap₄(1/3) = 7 − 4√3 at F = 4. Rung B is still the family's own argmax there, which is what this paragraph establishes.) At each of them c ≡ 3 (mod 4) is reachable compatibly with the residue's own η, but **the congruence certifying it differs by η and must not be quoted as one condition**: these nine residues are 1, 3 and 5 mod 8, so no single condition on n mod 8 covers them. The bookkeeping, from 2c ≡ 6 (mod 8) whenever c ≡ 3 (mod 4), so that r ≡ n − 6 (mod 8):

> | residues | n mod 8 | η | r ≡ n − 6 (mod 8) | what r − 1 must carry |
> |---|---|---|---|---|
> | 1, 9, 17 | 1 | 1 (at 1, 9), 1/3 (at 17) | 3 | r − 1 = 2·odd — full 2-adic freedom, D = 2 or 6 |
> | 5, 13, 21 | 5 | 1 (at 13, 21), 1/3 (at 5) | 7 | r − 1 = 2·odd, likewise |
> | 3, 11, 19 | 3 | 1/2 (at 3, 19), 1/6 (at 11) | 5 | r − 1 = 4·odd, i.e. D = 4 or 12 |

The last row is the case §3.3.4 derives explicitly and is the only one where n ≡ 3 (mod 8) is the operative condition. In the first two rows the residue's η is 1 or 1/3, so D is odd-times-2 and r ≡ 3 or 7 (mod 8) is exactly what is wanted; requiring r ≡ 5 there would be requiring 4 | r − 1, which those classes do not need and which would wrongly push them off their own ceiling. In every one of the nine the fused rung therefore attains the cap while the unfused one, at the same η, sits a factor cap_C/cap_B below it. Any c ≡ 3 or 7 (mod 8) solution thus beats every c ≡ 1 or 5 one, and the argmax lands there whenever such a solution exists near the balance point — which it does, since these classes are a positive proportion of primes. **Fused rung only: 100 / 0 / 0.**

*Residues 7 and 15.* (Within the family, as at 23: the class ceiling at both is cap₄(1) = 1/9, attained by the two-part F = 4 shape, so neither reading below is the argmax overall.) These are n ≡ 7 (mod 8), where c ≡ 3 (mod 4) forces r ≡ 1 (mod 8), hence 8 | r − 1, hence 8 | D — pushing the fused rung from η = 1/2 down to η = 1/4. That would normally lose, but cap_B(1/4) = cap_C(1/2) = (3 − 2√2)/2 exactly, a coincidence holding at η = 1/2 and nowhere else. So all four c-classes reach the same ceiling and compete on supply alone. Among them, c ≡ 3 and c ≡ 7 (mod 8) give the fused rung, c ≡ 1 gives S4, and c ≡ 5 gives a tie, since there the odd part of c − 1 is (c−1)/4 and fusing returns exactly C(c,2). Those are two classes, one and one. **fused / S4 / tie = 50 / 25 / 25.**

*Residue 23.* (As with the other residues here, this is the split **within the three-part family** n = 2c + r; §3.3.5's ceiling at this residue is attained by the two-part F = 4 shape, which is outside this accounting and does not compete for these proportions.) Also n ≡ 7 (mod 8), so c ≡ 3 (mod 4) again forces 8 | D — but here the mod-3 obstruction already caps η at 1/6, so the fused rung needs D = 24, giving η = 1/12 and a cap of 0.042020 against the unfused 0.050510. It cannot reach the ceiling, and c ≡ 3, 7 (mod 8) is out of contention entirely. That leaves c ≡ 1 and c ≡ 5 (mod 8), which by the same c = (n−1)/2 − (D/2)q bookkeeping are equinumerous — selected by q mod 4. The first gives S4 outright; the second gives a tie, because there the odd part of c − 1 is (c−1)/4 and the fused reading returns exactly C(c,2). So the fused rung does attain the cap at half the values; what it never does at this residue is win strictly. **fused / S4 / tie = 0 / 50 / 50**, reading the first column as *strict* wins.

*The even residues* have k = 1 and one block, so no fusion question arises and no row is needed.

> **Within the three-part family: S7 at F = 2 → 9/24 + 1/24 = 10/24 ≈ 41.7% outright; S4 → 1/24 ≈ 4.2%; tied → 1/24 ≈ 4.2%**, with S3 taking the even 12/24. The four sum to 1.

**The absolute shares differ, and S4's is zero.** At 7, 11, 15 and 23 mod 24 the class ceiling belongs to the two-part F = 4 shape (§3.3.5), which beats every reading of n = 2c + r; at the other eight odd residues the fused rung attains it, taking 100% of the family there by congruence. S4's entire within-family share was earned at 7, 15 and 23 — exactly the residues F = 4 takes — so it survives nowhere. Combining:

| shape | residues | asymptotic share |
|---|---|---|
| S3 | the twelve even | **12/24 = 50%** |
| S7 at F = 2 | 1, 3, 5, 9, 13, 17, 19, 21 | **8/24 ≈ 33.3%** |
| **S7 at F = 4** | **7, 11, 15, 23** | **4/24 ≈ 16.7%** |
| S4, and ties | — | **0** |

The four sum to 1. **The fused rung loses 2/24** — not because anything about it changed, but because at four residues it was competing for a ceiling that a shape outside the family reaches first. Note what the two tables together say about this section's own subject: the interesting half of the within-family analysis, the 1 : 1 : 2 supply split, applies only at 7, 15 and 23, and those are precisely the residues contributing nothing to the second table. Where the family wins, no supply argument is needed.

> **This is the accounting the row-by-row analysis cannot see.** Every congruence in this sub-section is a statement about which c mod 8 the argmax of the *three-part* family sits at, and none of them is disturbed by F = 4, which is a two-part shape obeying a different law — 4c ≡ 4 rather than 2c ≡ 6 (mod 8). The two analyses are independent and both stand; only their combination gives a share of n. That is why this note's opening frames it as a question about runners-up, and why it wants re-reading whenever the ceiling table moves.

## 2. The observed split, and why it does not yet match

*§1 predicts 100/0/0 at nine residues, 50/25/25 at two, and 0/50/50 at one. This sub-section reports what the computed range actually shows, in the same fused / S4 / tie order, and accounts for the difference. All of it is **within the family**: `rung_split.py` scores the three readings of n = 2c + r against each other and does not consider the two-part F = 4 shape, so a residue where F = 4 wins at n still appears here with whichever reading realises the family. That is the right measurement for testing §1 and the wrong one for reading off which shape wins.*

### 2.1 The observed split

**Measured over odd n in [2×10⁵, 2.06×10⁵]** (`rung_split.py`), in the same order as §1's prediction. Each residue is scanned in a window of half-width 0.05 around **its own** balance point, which is `count_check.py`'s convention and the right one here, since the prediction is about configurations *at* the class ceiling:

| n mod 24 | fused rung wins | S4 wins | tie | values |
|---|---|---|---|---|
| 1, 3, 5, 9, 11, 13, 17, 19, 21 | **100.0%** | 0.0% | 0.0% | 1887 |
| 7 | 8.7% | 31.1% | 60.2% | 196 |
| 15 | 0.0% | 31.6% | 68.4% | 250 |
| 23 | **0.0%** | 43.2% | 56.8% | 185 |
| **all odd n** | **75.6%** | **8.7%** | **15.6%** | 2518 |

**The nine rung-B residues match exactly**, at 100 / 0 / 0 — no surprise, since there the prediction rests on a congruence rather than on supply, and congruences do not wait for n to grow.

**Residue 23 matches well**: predicted 0 / 50 / 50, observed 0.0 / 43.2 / 56.8. The zero is congruence-forced and exact; the 43 / 57 against 50 / 50 is the same modest excess of ties seen elsewhere.

**Residues 7 and 15 match on S4 and transpose the other two**: predicted 50 / 25 / 25, observed 8.7 / 31.1 / 60.2 and 0.0 / 31.6 / 68.4. **The S4 share is already near right** — 31.1 and 31.6 against 25 — while the fused-rung share and the ties are swapped, ties running near two thirds where fused wins were predicted at a half. This is the one place prediction and measurement disagree, and the two sub-sections below account for part of it.

### 2.2 Separating the two fused rungs

**The table above does not separate the two fused rungs.** Its columns were taken by asking whether the winner fuses its two c-blocks, not by asking *which layer* the swap sits in — so a top-layer win (S5) is scored as a fused win, and a top-layer configuration equalling the unfused value is scored as a tie. Those are different shapes with different laws, and only S7 at F = 2 is a party to §1's prediction. Scoring the three readings separately over the same band, at the same per-residue windows, adds an S5 column to the table above: **0.0% at every residue**.

**S5 never wins outright anywhere in the band**, which is the expected consequence of its being supply-limited to r = 2^a·u + 1 with u small — at n ≈ 2×10⁵ that family is too thin to supply the *best* configuration at any value. So the conflation is not inflating the fused column.

**It is inflating the tie column, and by a measurable amount.** Asking how often each reading merely *belongs* to the argmax set rather than owning it:

| n mod 24 | S7 at F = 2 | S4 | S5 |
|---|---|---|---|
| 1, 3, 5, 9, 11, 13, 17, 19, 21 | 100.0% | 0.0% | 0.0% |
| 7 | 45.4% | 91.3% | **23.5%** |
| 15 | 38.0% | 100.0% | **30.4%** |
| 23 | 56.8% | 100.0% | **0.0%** |

So at residues 7 and 15, S5 is among the joint winners at a quarter to a third of values — it reaches the same score without ever exceeding it, which is exactly how a shape whose binding term is the foreign block behaves under a change of fusion layer. That is a real contribution to the excess ties at those two residues. **It contributes nothing at residue 23**, where S5 is never in the argmax at all, so the excess ties there need a different explanation — which the next box supplies.


### 2.3 The excess ties

Beyond the layer conflation the excess ties have a further cause, and it is one the model itself accounts for.

> **The excess ties are escapes, not the balanced family.** A tie means the fused and unfused readings return the same *value*, which happens whenever the winning configuration's binding term is one that fusion does not touch — and note that this is the same mechanism by which an S5 configuration registers as a tie, since fusing in the top layer also leaves a binding foreign term unchanged. Diagnosed over tied n at residue 7: the binding term is the **foreign block** in 43 of 65 cases and the intra term in 22 — and the winning configurations sit at a median of **1.21× the residue's ceiling**, so at these sizes they are escape configurations (§4.3) rather than the balanced family. Fusing changes only the intra term, so wherever an escape wins on its foreign block the two readings agree identically. Consistently, at 23 mod 24 — where escapes are weaker — the tied values sit *at* the ceiling (median 0.989×) rather than above it.

### 2.4 Why the computed range cannot settle it

> **Why the computed range does not yet show the predicted split.** The prediction above assumes the winner is drawn from the pool of near-optimal candidates in proportion to each class's supply. Two things have to happen for that to be the operative regime, and both are asymptotic. The escape-driven ties **thin at O(n/log n)** (§4.3), so eventually the outcome at every n is decided by the balanced family alone. And within that family the candidate count near the balance point grows like n/log³n, so every class becomes dense enough that its best candidate is essentially *at* the ceiling — at which point choosing the maximum is effectively drawing from the pool, and the probability the argmax lands in a class tends to that class's share of the pool. So the outcome split **should converge to the singular-series proportions**, with a residual tie fraction converging to the c ≡ 5 (mod 8) share rather than to zero, since fused and unfused give literally the same value there. *Should*, under the model — and per the box in §1 the model's own error is of the same 1/log n order as the drift it predicts, so "the split converges to 1 : 1 : 2" is a prediction of the heuristic read at leading order rather than a consequence of it.
>
> The computed range is too small for either. The observed figures do not move monotonically across bands (28.0/26.4/45.6 at 2×10⁴, 23.5/50.0/26.5 at 2×10⁵, 32.7/41.3/26.0 at 10⁶), and those bands hold only 100–250 values apiece. A drift of order 1/log n falls from about 10% to 7% across that range, well inside the sampling noise. **The measurement is underpowered by roughly an order of magnitude, not in tension with the model** — and would remain so at any range reachable by computation, since an effect of relative size 1/log n cannot be separated from a nearby limit by data at 10⁶. Settling it wants the predicted class shares computed directly from the three singular series — which differ by the condition on r, not only by the density of c — against a single band of a few thousand values, **with the winners classified by top prime** so that S5 is excluded rather than folded into the tie column — the split above shows that correction is worth 23–30% of the values at residues 7 and 15 and nothing at 23.
>
> *Does Friedlander–Granville threaten this?* Their result defeats strong uniformity for primes in progressions to moduli growing almost as fast as x, so it is the right thing to worry about whenever a heuristic leans on equidistribution across many classes at once. It does not bite here: **every modulus in play is bounded** — 8 and 24 for the residue bookkeeping, D ≤ 24 for the efficiency condition — and the windows have length Θ(n), so what is being assumed is equidistribution in a *fixed* finite set of classes over a long interval, which is a far weaker demand than anything their construction disturbs. The genuinely non-trivial assumption is elsewhere and is §3.5's: that the Bateman–Horn count holds **uniformly in n** as the singular series varies with n, rather than pointwise for each fixed system. That is where the conjectural weight sits, and no amount of bounded-modulus equidistribution supplies it.


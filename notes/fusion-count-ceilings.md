# The mod-24 ceilings as a joint optimisation over (F, η)

> # ⚠ ARCHIVED — superseded snapshot, retained for its derivation only
>
> **⟦ARCHIVED⟧ This note's conclusion was accepted and is now the framework's ceiling table; the note itself has not been maintained since, and two things in it are stale.**
>
> **What was integrated.** The central claim — that §3.3.5's ceiling is a **joint** optimum over (F, η) rather than an optimisation of η at a fusion count fixed in advance, and that the global constant is therefore **7 − 4√3** rather than (5 − 2√6)/2 — is now the framework's position, carried in `arithmetic-of-density.md` §3.3.5 and its supporting boxes. The F = 4 rung at the extremal class comes from here.
>
> **What is stale, and both matter for reading the tables below.** *(i)* The keying is **mod 24 throughout**; the table was later rekeyed to **mod 12** and the constant count reduced from seven to six, since the mod-24 refinement turned out to track the twist cut rather than the ceiling. A mod-24 ceiling table is now a signal that the cut has been wrongly assumed forced. *(ii)* The note predates the **entangled-generator correction**, so wherever it reasons about what a cyclic-layer fusion costs on the matching side, the answer is now *nothing* — the block-permutation image is a quotient of the layer, not a subgroup, and the full twist survives fusion.
>
> **Where the current statement lives:** `arithmetic-of-density.md` §3.3.5 for the table, §3.3.4a for the η column, `entangled-generator-finding.md` for the correction. **Read this note for its derivation of the cap formula and the shape of the (F, η) trade-off, not for its constants or its residue keying.**
>
> *`aod` §3.3.5 still cites this note as where the trade-off is worked; that citation is to the derivation and remains accurate.*

*Standalone note for review. Nothing here is merged into `arithmetic-of-density.md`, `enumeration-proof.md` or the census; §7 lists the edit sites if it survives scrutiny.*

**The claim.** §3.3.5's table fixes the fusion count first and optimises η within it. The joint optimum over (F, η) is strictly higher at four of the twelve odd residues, and the global constant moves from **(5 − 2√6)/2** to **7 − 4√3**.

**The cause.** Not an unexplored case. The census's S7 row at F ≥ 3 contains a **false statement whose proof covers only half its quantifier** (§6), and the same error is encoded independently in `ladder_verify.py`. The enumerator implements the correct reading, which is why no computed value of B(n) changes.

**Convention.** Every cap is given as a closed form with denominator rationalised, alongside its decimal, and all comparisons are stated on the closed forms — so equality and ordering are visible without reading decimal places.

---

## 1. The cap formula

Write x = c/n. The configuration is one fused class of F blocks of size c, plus one foreign prime r = n − Fc of efficiency η. As fractions of C(n,2):

| class | density |
|---|---|
| matching, intra | F·x² |
| matching, within-class cross | F·x² (coefficient F for odd F and F/2 for even F, against c² and 2c² respectively) |
| cross to foreign | 2F·x(1 − Fx) |
| foreign, intra | η·(1 − Fx)² |

Neither cross term binds at the optimum, so balancing the two intra terms gives

> **cap_F(η) = η / (1 + √(Fη))²**,  attained at  x\* = √(η/F) / (1 + √(Fη)).
>
> *(Pulling √F out of the denominator — √F + F√η = √F·(1 + √(Fη)) — squares it to F, which cancels the F in the numerator.)*

Written this way three things are immediate that the unsimplified form obscures. **cap_F(η) is decreasing in F at fixed η**, since F appears only inside √(Fη) in the denominator. **It depends on F and η only through η and the product Fη.** And **the rung-C identity is trivial**: cap_1(Fη)/F = Fη/(F(1 + √(Fη))²) = cap_F(η), so cap₄(η) = cap_1(4η)/4 = cap_C(η) needs no computation.

*Precondition.* The matching density is F·x² only if the twist retains the full (c−1)/2. For even F the fusion count occupies the prime 2 in the cyclic layer, so the twist is cut to the odd part of c − 1 — which equals (c−1)/2 exactly when **c ≡ 3 (mod 4)**. At c ≡ 1 (mod 4) the odd part is (c−1)/4 or smaller and the cap is not attained.

**Validation.** cap_F(η) reproduces §3.3.5 exactly, including the D = 24 branch quoted in its prose:

| | rationalised | decimal | §3.3.5 gives |
|---|---|---|---|
| cap₁(1) | 1/4 | 0.250000 | 1/4 |
| cap₁(1/3) | (2 − √3)/2 | 0.133975 | (2 − √3)/2 |
| cap₂(1) | 3 − 2√2 | 0.171573 | 3 − 2√2 |
| cap₂(1/2) | 1/8 | 0.125000 | 1/8 |
| cap₂(1/3) | 5 − 2√6 | 0.101021 | 5 − 2√6 |
| cap₂(1/6) | (2 − √3)/4 | 0.066987 | (2 − √3)/4 |
| cap₂(1/12) | (7 − 2√6)/50 | 0.042020 | 0.042020 (D = 24 branch) |

## 2. Why (F, η) must be optimised jointly

cap_F(η) is decreasing in F at fixed η — at η = 1/3 it runs (2 − √3)/2, 5 − 2√6, 1/12, 7 − 4√3 for F = 1, 2, 3, 4, i.e. 0.133975, 0.101021, 0.083333, 0.071797. So fusion is never worth taking for its own sake. It is worth taking only because **F changes which residue class r falls in, and hence which η is available**. That coupling is what makes this a joint optimisation rather than an optimisation of η at a fixed rung.

### 2.1 Why larger F cannot help — an explicit finite bound

This is the part that must not be left to intuition, since the whole error being corrected here was an unexamined restriction on F. The efficiency satisfies **η ≤ 1** always (the twist cannot exceed the full multiplicative group), so the best *any* efficiency can give at fusion count F is

> **cap_F(1) = 1/(1 + √F)²**,

which is a hard ceiling on the entire F-slice, independent of arithmetic, congruences and supply. It is decreasing in F, so once any lower bound on the answer is in hand, only finitely many F remain — and the list is short:

| F | cap_F(1) | decimal | > 7 − 4√3 ? | > 1/9 ? |
|---|---|---|---|---|
| 1 | 1/4 | 0.250000 | yes | yes |
| 2 | 3 − 2√2 | 0.171573 | yes | yes |
| 3 | (2 − √3)/2 | 0.133975 | yes | yes |
| **4** | **1/9** | 0.111111 | yes | — (attains) |
| 5 | (3 − √5)/8 | 0.095492 | yes | **no** |
| 6 | (7 − 2√6)/25 | 0.084041 | yes | **no** |
| 7 | (4 − √7)/18 | 0.075236 | yes | **no** |
| **8** | (9 − 4√2)/49 | **0.068227** | **no** | **no** |
| 9 | 1/16 | 0.062500 | no | no |
| 16 | 1/25 | 0.040000 | no | no |

Reading off the two thresholds:

- **To beat 7 − 4√3** requires 1 + √F < 1/√(7 − 4√3) = 2 + √3 = 3.7321, i.e. **F ≤ 7**.
- **To beat 1/9** requires 1 + √F < 3, i.e. **F ≤ 4**.

Combined with the parity constraint of §3 — at odd n, F must be even — this makes each per-class search **finite and complete**:

> - At **7 and 15**, where the answer is cap₄(1) = 1/9: only F ≤ 4 could beat it, and among even F that is F ∈ {2, 4}. F = 4 already *attains* the absolute ceiling 1/9 at η = 1, so **no F whatsoever can improve on it**. That row is final, independent of any measurement.
> - At **11 and 23**, where the answer is cap₄(1/3) = 7 − 4√3: only F ≤ 7 could beat it, i.e. even F ∈ {2, 4, 6}. All three were measured (§4), and F = 6 reaches only η = 1/4 at class 11 and η = 1/2 at class 23, giving cap₆(1/4) = (5 − 2√6)/2 = 0.050510 and cap₆(1/2) = (2 − √3)/4 = 0.066987 — both below 7 − 4√3. So **F = 8 and beyond are excluded by the ceiling and F = 6 by measurement**, and the search is exhausted.

The point of stating it this way is that the exclusion of F ≥ 8 needs **no arithmetic input at all** — it follows from η ≤ 1 — so the only classes where a measurement could still be wrong are F = 2, 4 and 6, which are the three that were checked.

> **An identity to note before comparing any values.** The unfused-pair rung C and the fused F = 4 shape share a cap function:
>
> **cap₄(η) = η/(1 + 2√η)² = cap_C(η)**, identically in η — immediate from the simplified form, since √(4η) = 2√η.
>
> They are different configurations — one orbit of four fused blocks versus two unfused orbits, different part counts, different census rows — agreeing at every η. **A matching value carries no information about which shape produced it.** In particular cap₄(1/6) = (5 − 2√6)/2 equals the class-23 ceiling *by this identity*, not because that ceiling was ever an F = 4 rung. This tripped the derivation of this note twice.

## 3. The parity constraint and the mod-8 mechanism

For odd n with c odd and r an odd prime, n = F·c + r forces **F even**: odd F gives Fc odd, hence r even. So at odd n the fused two-part family runs over F ∈ {2, 4, 6, …} only, and the competitors to the three-part ladder are F = 4 and F = 6.

The mechanism is one line of mod-8 arithmetic. At n ≡ 7 (mod 8), c odd:

| shape | Fc mod 8 | r mod 8 | v₂(r − 1) | η before ℓ = 3 | after |
|---|---|---|---|---|---|
| F = 2, c ≡ 3 (mod 4) | 6 | 1 | ≥ 3 | 1/4 | **1/12** |
| **F = 4, c odd** | **4** | **3** | **1** | **1** | **1/3** |

Doubling the block count moves 2c ≡ 6 to 4c ≡ 4, hence r from 1 to 3 (mod 8), dropping v₂(r − 1) from ≥ 3 to 1. **The D = 24 obstruction that pins class 23 belongs to F = 2, not to the residue class.**

### 3.5 The efficiencies, derived rather than sampled

The η column of §4 was originally measured. It is derivable, and the derivation splits into two independent parts that multiply.

**The 2-adic part.** With c ≡ 3 (mod 4) — hence c ≡ 3 or 7 (mod 8) — the product F·c is determined mod 8: **6, 4, 2** for F = 2, 4, 6. So r = n − F·c (mod 8) is fixed by the residue class. Even F puts the prime 2 into the cyclic layer, so the foreign twist t must be odd, and the best case r − 1 = 2^v·q^e gives

> **η₂ = 2^(1−v)**,  v = v₂(r − 1), read off r mod 8: v = 1 at r ≡ 3, 7; v = 2 at r ≡ 5; v ≥ 3 at r ≡ 1.

**The 3-adic part.** If 3 | r − 1 is *forced*, the odd part of r − 1 carries a 3; for that odd part to be a single prime power it would have to be a power of 3, i.e. r = 2^v·3^e + 1, a density-zero family. Generically the odd part is 3·(prime power), so η is **cut by 3**. Whether 3 | r − 1 is forced depends on F mod 3:

> - **F ≢ 0 (mod 3).** c mod 3 is free (c prime, c ≠ 3), so r can be steered to 2 (mod 3) — solving F·c ≡ n − 2 — *unless* that forces c ≡ 0 (mod 3), which happens exactly at **n ≡ 2 (mod 3)**.
> - **F ≡ 0 (mod 3).** r ≡ n (mod 3) is forced. The cut applies at n ≡ 1 (mod 3); and at n ≡ 0 (mod 3) we get 3 | r, so the shape is **unavailable** for prime r > 3.

Multiplying, **η = η₂ / (3 if cut else 1)**. This reproduces every measured cell, including the three where the shape is unavailable.

> **One place the mod-8 analysis is not enough, and it is worth knowing where.** At r ≡ 1 (mod 8) the rule gives only v ≥ 3. The exact value needs mod 16, where 4c ≡ 12 (mod 16) is again forced, so r ≡ n − 12 (mod 16) — and **n mod 16 is not determined by n mod 24**. The class splits: at n ≡ 5 (mod 16) one gets v = 3 and η₂ = 1/4, at n ≡ 13 (mod 16) v = 4 and η₂ = 1/8. This is real and it bites at three cells — classes 5, 13 and 21 at F = 4, where the guarantee is 1/8 rather than the 1/4 a mod-8 reading would give.
>
> **The table nonetheless stands keyed mod 24, and not by luck.** All three affected cells are ones where F = 4 is *not* the class optimum. The four classes where F = 4 does set the ceiling — 7, 11, 15, 23 — all have r ≡ 3 or 7 (mod 8), hence **v = 1 exactly**, the minimum possible, with no deeper dependence available to disturb it. The binding cells are precisely those where the 2-adic valuation is pinned at the bottom, which is why the keying survives.

*What the derivation does and does not remove.* It removes the sampling: the η values are now consequences of the congruences, checkable by hand. It does **not** remove the arithmetic hypothesis — that primes of the required form r = 2^v·q^e + 1 exist in the needed density near the balance point is Bateman–Horn, exactly as everywhere else in §3. What was measured before was "does such an r turn up in practice at every sampled n"; what is derived now is "is there a congruence obstruction to one existing". The second is the part that was in doubt.

**Verification.** `eta_derive.py` computes both sides — the derivation by exact enumeration mod 2⁷, the measurement by scanning real decompositions — and asserts agreement at all thirty-six (class, F) cells, plus that no ceiling-setting cell is among the three that split. It exits nonzero on any disagreement, so it is a regression test on both the derivation and the table.

## 4. The revised table

Guaranteed η per class and F — **derived from congruences** (§3.5) and independently **measured** over sampled n, the two agreeing at all thirty-six cells. Throughout, c ≡ 3 (mod 4) so the matching term stays F·x².

| n mod 24 | η at F=2 | η at F=4 | η at F=6 | best cap | rationalised | decimal | §3.3.5 | ratio |
|---|---|---|---|---|---|---|---|---|
| 1, 9, 13, 21 | **1** | 1/2 | 1/3 | cap₂(1) | **3 − 2√2** | 0.171573 | 3 − 2√2 | 1 |
| 3, 19 | **1/2** | 1 | — | cap₂(1/2) | **1/8** | 0.125000 | 1/8 | 1 |
| 5, 17 | **1/3** | 1/6 | 1 | cap₂(1/3) | **5 − 2√6** | 0.101021 | 5 − 2√6 | 1 |
| **7, 15** | 1/4 | **1** | 1/6 | cap₄(1) | **1/9** | 0.111111 | (3 − 2√2)/2 | 1.295 |
| **11** | 1/6 | **1/3** | 1/4 | cap₄(1/3) | **7 − 4√3** | 0.071797 | (2 − √3)/4 | 1.072 |
| **23** | 1/12 | **1/3** | 1/2 | cap₄(1/3) | **7 − 4√3** | 0.071797 | (5 − 2√6)/2 | 1.421 |

The eight classes already on an F = 2 rung are unchanged and reproduce their constants exactly. The four that move are precisely those the mod-8 argument sent to a degraded rung.

**The three comparisons, on closed forms.**

- **7, 15:** 1/9 versus (3 − 2√2)/2. Equivalent to 2/9 versus 3 − 2√2, i.e. 2√2 versus 25/9, i.e. 8 versus 625/81 = 7.716. So **1/9 is larger**.
- **11:** 7 − 4√3 versus (2 − √3)/4. Equivalent to 28 − 16√3 versus 2 − √3, i.e. 26 versus 15√3, i.e. 676 versus 675. So **7 − 4√3 is larger, by the narrowest possible margin** — the ratio 1.072 rests on 676 > 675.
- **23:** 7 − 4√3 versus (5 − 2√6)/2. Equivalent to 14 − 8√3 versus 5 − 2√6, i.e. 9 + 2√6 versus 8√3, i.e. 9 + 4.899 = 13.899 versus 13.856. So **7 − 4√3 is larger**.

**The global constant** moves from **(5 − 2√6)/2 at n ≡ 23 alone** to **7 − 4√3, tied between n ≡ 11 and n ≡ 23**. Even classes are unaffected, sitting at (2 − √3)/2 ≈ 0.133975 or above, so this is the minimum over all 24 residues. The ratio (7 − 4√3)/((5 − 2√6)/2) = 1.421.

## 5. Consistency with computation

Under `mu_enumerate_v2.py`'s `value()`, which enforces the full cyclic-layer pairwise coprimality: at class 23, n = 90539 gives 0.057681 via `4x13219 + 1x37663*`; n = 130223 gives 0.058484; n = 197663 gives 0.063786 — all with r − 1 = 6q^e, all above (5 − 2√6)/2 and climbing toward 7 − 4√3. Independently, the class-23 minimum of `ladder_verify.py`'s lower bound rises 0.0445 → 0.0502 → 0.0559 → 0.0588 → 0.0599 → 0.0630 → 0.0638 across blocks from 2·10⁴ to 2·10⁵, crossing (5 − 2√6)/2 near 5·10⁴ and continuing upward.

## 6. Where the error is, and what kind of error it is

**A false statement whose proof covers only half its quantifier.** The census row for S7 at F ≥ 3 reads:

> *"at even n the shape n = 3c + r is a full Hardy–Littlewood system with the same supply as S3, plus O(n/log n) odd values where F·c even forces c = 2^a; wins → 0"*

The clause **"F·c even forces c = 2^a"** is false. F·c is even whenever **F** is even, with c an ordinary odd prime. The implication holds only for odd F, where Fc = odd·odd is odd so c must be even and hence a power of 2. The sentence quantifies over all F ≥ 3; its proof covers the odd ones. Measured directly, **500 of 500 odd n in [50000, 51000] admit n = 4c + r with c and r both odd primes** — a full Hardy–Littlewood system, not the O(log n) block sizes per n the row claims.

Two load-bearing consequences rest on that clause:

- **§4.3, fate (iii)** lists *"the odd residues when a cyclic-layer-fused class of **F = 3 or 5** blocks is available — the S7 route at F ≥ 3"* among four escapes said to be O(n/log n). The enumeration is explicitly of odd F; F = 4 and F = 6 are classified nowhere.
- **The census's "wins → 0"** for S7 at F ≥ 3 rests on the same supply claim.

**Why only odd F was ever considered.** The block-permuting group's order must be coprime to what else the cyclic layer carries. For even F the prime 2 must not divide the *twist* — and c is odd, so 2 always divides c − 1. Reading that as "even F is inadmissible" is the error. The correct reading is that the twist is **cut** to the odd part of c − 1, costing a factor of 2 in the matching term and often still worth it. `ladder_verify.py` encoded the wrong reading literally as `(c-1) % qF == 0 → continue`, which skips every odd c at qF = 2 and so excluded all even F from its S7 loop.

**Why no computed value changes.** `mu_enumerate_v2.py`'s `parts_for` implements the correct reading — it strips the fusion primes from the twist rather than rejecting the configuration — so the enumerator has always searched even F, and the v4 table contains such winners (n = 1175 wins with `1x619* + 4x139`). The error is confined to the **analysis** in `arithmetic-of-density.md` and to the **ladder script**. B(n), μ(n) = B(n), the collapse certificate and every tabulated value are untouched.

**For the T1 ledger.** Same failure mode as the ΓL(1) step, the q-power block count and Lemma D2: a case analysis whose proof covers one part of a partition while its statement quantifies over the whole. Here the partition is F odd versus F even, and the sentence's own arithmetic — "F·c even" — is what silently selects the odd branch. It is also an instance of a distinct and cheaper-to-catch pattern: **the enumerator and the prose have been in direct contradiction for as long as both have existed**, and comparing `parts_for` against the census S7 row would have surfaced it at any time.

## 7. What is weakest, and what would change

**The F-search is complete, so a further F is not a live risk.** §2.1 excludes F ≥ 8 from η ≤ 1 alone, with no arithmetic input, and the parity constraint leaves only F ∈ {2, 4, 6} at odd n. All three are measured. At classes 7 and 15 the answer attains the absolute ceiling cap₄(1) = 1/9, so those two rows cannot be improved by any F at any η — they are final. What remains open to measurement error is therefore only the η values at F = 2, 4, 6 for classes 11 and 23.

**The η values are no longer the weak point.** §3.5 derives them from congruences, and `eta_derive.py` checks that derivation against an independent measurement at all thirty-six cells. What survives:

- **Only F ≤ 6 has been derived.** §2.1 excludes F ≥ 8 from η ≤ 1 alone, so the conclusion has no gap, but §3.5's bookkeeping covers F ∈ {2, 4, 6} only.
- **Mixed three-part shapes** such as 4c + 2c′ + r lie outside both the two-part family and the three-part ladder, and nothing here bounds them.
- **The class-11 comparison rests on 676 > 675**, the narrowest possible integer margin. Deriving the η removes the way that was most likely to go wrong, but the margin is what it is.
- **The measurement had a subtle failure mode worth keeping in view**, since a future re-measurement could repeat it: an earlier version asked whether η was *available* without checking that the matching side still attained its share, and produced a table contradicting §3.3.5 where §3.3.5 was right. The current one restricts to c ≡ 3 (mod 4) and reproduces §3.3.5's η = 1/12 at F = 2 for class 23, which is the check that it took.

**The asymptotic claim needs a supply heuristic** of the kind §3 already assumes: each n needs n = 4c + r near x\* with c ≡ 3 (mod 4) prime and r − 1 = 6q^e, whose expected count grows like εn/log³n. Observed values remain below the cap at 10⁶ — the sampled class-11-and-23 minimum reaches 0.0665 against 7 − 4√3 = 0.0718 in the last block — so the approach is slow but visible.

**Edit sites.**

1. **§3.3.5's table** — four rows and the rung column. The derivation needs the parity constraint and the mod-8 mechanism of §3, and §3.5 supplies the η column as a congruence consequence rather than a measurement; the merged 11/23 row follows from both taking the same (F, η).
2. **The census S7 row** — the false clause and the "wins → 0" verdict resting on it.
3. **§4.3 fate (iii)** — S7 at F ≥ 3 is not an O(n/log n) escape at even F; it is the ceiling-setting shape at four residues.
4. **The global constant** — §1 consequence 3, §1's summary of §3.3, §3.3.5's closing paragraph ("attained at n ≡ 23 (mod 24) alone"), and §5, where the floor is stated against it.
5. **`ladder_verify.py`'s CAP table**, keyed to the old constants and used as the worklist threshold. (FSET and the guard are already fixed; CAP is not.)
6. **`count_check.py`'s caption**, which lists the rung-C caps as the class ceilings.

*Not affected:* B_safe, μ(n) = B(n), the collapse certificate, and every computed value. These are ceilings of a family and hence floors for μ; §3.3.5's own warning that the rows bound the family and not δ(n) is why nothing downstream depends on them.

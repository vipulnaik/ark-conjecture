# The mod-24 ceilings as a joint optimisation over (F, η)

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

## 4. The revised table

Guaranteed η per class and F — the minimum over sampled n of the best η available, with c ≡ 3 (mod 4) so the matching term is intact.

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

**Weakest.** The guaranteed-η figures are measured over roughly 30–60 sampled n per class in [6·10⁴, 9·10⁴], not proved. An earlier version of that measurement was wrong instructively: it checked η availability without checking that the matching side still attained its share, and so contradicted §3.3.5, which was right. The current figures restrict to c ≡ 3 (mod 4) and reproduce §3.3.5's η = 1/12 at F = 2 for class 23 — the check that the correction took. Only F ≤ 6 was scanned. Mixed three-part shapes such as 4c + 2c′ + r are outside both families. And the class-11 comparison rests on 676 > 675, so any slip in the η there flips it.

**The asymptotic claim needs a supply heuristic** of the kind §3 already assumes: each n needs n = 4c + r near x\* with c ≡ 3 (mod 4) prime and r − 1 = 6q^e, whose expected count grows like εn/log³n. Observed values remain well below the cap at 2·10⁵, so the approach is slow.

**Edit sites.**

1. **§3.3.5's table** — four rows and the rung column; the derivation needs the parity constraint and the mod-8 table of §3.
2. **The census S7 row** — the false clause and the "wins → 0" verdict resting on it.
3. **§4.3 fate (iii)** — S7 at F ≥ 3 is not an O(n/log n) escape at even F; it is the ceiling-setting shape at four residues.
4. **The global constant** — §1 consequence 3, §1's summary of §3.3, §3.3.5's closing paragraph ("attained at n ≡ 23 (mod 24) alone"), and §5, where the floor is stated against it.
5. **`ladder_verify.py`'s CAP table**, keyed to the old constants and used as the worklist threshold. (FSET and the guard are already fixed; CAP is not.)
6. **`count_check.py`'s caption**, which lists the rung-C caps as the class ceilings.

*Not affected:* B_safe, μ(n) = B(n), the collapse certificate, and every computed value. These are ceilings of a family and hence floors for μ; §3.3.5's own warning that the rows bound the family and not δ(n) is why nothing downstream depends on them.

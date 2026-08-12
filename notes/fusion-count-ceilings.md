# The mod-24 ceilings as a joint optimisation over (F, η)

*Standalone note for review. Nothing here has been merged into `arithmetic-of-density.md`, `enumeration-proof.md` or the census; §6 lists what would need to change if it survives scrutiny. The claim is that §3.3.5's ceiling table optimises η at a fixed fusion count and that the joint optimum is strictly higher at four of the twelve odd residues, including the one the global constant is stated against.*

**Status of each claim.** The cap formula and its closed forms are **algebra**, checked against six entries of the existing table which they reproduce exactly. The realisability figures are **measured** over a sample of n and are the weakest link — see §5. The asymptotic conclusion is **conditional** on a supply heuristic of the same kind the framework already uses.

---

## 1. What the existing table optimises

§3.3.5 assigns each residue class a rung — A, B or C, i.e. which shape realises the cap there — and then reports the cap of *that* shape at the η the class can reach. The rung is fixed first, by a mod-8 argument, and η is optimised within it.

That is the right calculation for the family it describes. The three-part ladder A/B/C ranges over n = 2c + r with the two c-blocks unfused (rung C, census S4), fused in the cyclic layer (rung B, S7 at F = 2) or fused in the top layer (rung B′, S5). Every entry in the table is correct for that family, and the reasoning at n ≡ 23 is explicit and sound: c ≡ 3 (mod 4) forces 2c ≡ 6 (mod 8), hence r ≡ 1 (mod 8) and 8 | r − 1, so the fused rung needs D = 24, giving η = 1/12 and a cap of 0.042020 — below rung C's 0.050510, which is why 23 is stuck on C.

**What the family omits is fused classes with F ≥ 3.** Those are census row S7 at F ≥ 3, a *two-part* shape n = F·c + r, outside the three-part ladder. The omission is not arbitrary: it dates from the period when the block count was believed to be a q-power, and it is the same omission that left even F out of `ladder_verify.py`'s S7 loop.

## 2. The cap formula, and why F and η are coupled

Write x = c/n and let η be the foreign block's efficiency. For a configuration of one fused class of F blocks of size c plus one foreign prime r = n − Fc, the four class sizes as fractions of C(n,2) are

| class | density |
|---|---|
| matching (intra) | **F·x²** |
| within-class cross | F·x² (coefficient F for odd F, F/2 for even F, and 2x²·(F/2) = F·x² either way) |
| cross to foreign | 2F·x(1 − Fx) |
| foreign (intra) | η·(1 − Fx)² |

so δ = max over x of min(F x², 2F x(1 − Fx), η(1 − Fx)²). The cross terms never bind at the optimum, and balancing the two intra terms gives

> **cap_F(η) = F·η / (√F + F√η)²**, at x\* = √η / (√F + F√η).

*The matching density is F·x² only if the twist retains the full (c−1)/2.* For even F the fusion count occupies the prime 2 in the cyclic layer, so the twist is cut to the odd part of c − 1, and that equals (c−1)/2 exactly when **c ≡ 3 (mod 4)**. At c ≡ 1 (mod 4) the odd part is (c−1)/4 or less and the matching term collapses, so the cap is not attained. This condition is easy to drop and doing so produces spurious results — it is the error that generated an earlier draft of the table below.

**Validation.** cap_F(η) reproduces the existing table exactly wherever that table applies:

| F, η | cap_F(η) | §3.3.5 |
|---|---|---|
| 1, 1 | 0.250000 | 0.25000 |
| 2, 1 | 0.171573 | 0.17157 |
| 2, 1/2 | 0.125000 | 0.12500 |
| 2, 1/3 | 0.101021 | 0.10102 |
| 2, 1/6 | 0.066987 | 0.06699 |
| 1, 1/3 | 0.133975 | 0.13397 |

**The coupling.** cap_F(η) is strictly *decreasing* in F at fixed η — at η = 1/3 it runs 0.1340, 0.1010, 0.0833, 0.0718, 0.0635, 0.0572 for F = 1…6. So fusion is never worth taking for its own sake. It is worth taking only because **F changes which residue class r lands in, and hence which η is available**. That is what makes this a joint optimisation over admissible pairs rather than an optimisation of η at a fixed F.

> **A treacherous identity, worth knowing before reading any of these numbers.** The unfused-pair rung C and the fused F = 4 shape have *the same cap formula*: cap₄(η) = 4η/(2 + 4√η)² = η/(1 + 2√η)² = cap_C(η), identically in η. They are structurally different configurations — one orbit of four fused blocks versus two unfused orbits — with different part counts and different census rows, and they agree numerically at every η. **A matching number therefore carries no information about which shape produced it.** This identity caused two misreadings during the derivation of this note.

## 3. The parity constraint that fixes which F are available

For odd n with c odd and r an odd prime, F·c + r = n forces **F even**. Odd F would make Fc odd and r = n − Fc even. So at odd n the two-part fused family runs over F ∈ {2, 4, 6, …} only, and the relevant competitors to the three-part ladder are F = 4 and F = 6.

The mod-8 consequence is the whole mechanism:

| shape | Fc (mod 8), c odd | r (mod 8) at n ≡ 7 (mod 8) | v₂(r − 1) | η ceiling |
|---|---|---|---|---|
| F = 2, c ≡ 3 (mod 4) | 6 | 1 | ≥ 3 | ≤ 1/4, and 1/12 after the ℓ = 3 obstruction |
| **F = 4, c odd** | **4** | **3** | **1** | **≤ 1, and 1/3 after the ℓ = 3 obstruction** |

Multiplying the block count by 2 moves 2c ≡ 6 to 4c ≡ 4, which moves r from 1 to 3 (mod 8) and drops v₂(r − 1) from ≥ 3 to 1. **The D = 24 obstruction that pins class 23 is a property of F = 2, not of the class.**

## 4. The revised table

Guaranteed η by class and F, measured over sampled n with c ≡ 3 (mod 4). "Guaranteed" means the minimum over sampled n of the best η available, so it is a floor on what the class can always reach, not a best case.

| n mod 24 | F=2 | F=4 | F=6 | best cap | at | §3.3.5 | change |
|---|---|---|---|---|---|---|---|
| 1, 9, 13, 21 | **1** | 1/2 | ≤1/3 | **0.171573** | F=2 | 0.17157 | — |
| 3, 19 | **1/2** | 1 | ≤1/12 | **0.125000** | F=2 | 0.12500 | — |
| 5, 17 | **1/3** | ≤1/6 | 1 | **0.101021** | F=2 | 0.10102 | — |
| **7, 15** | 1/4 | **1** | ≤1/6 | **1/9 = 0.111111** | **F=4** | 0.08579 | **+29.5%** |
| **11** | 1/6 | **1/3** | 1/4 | **7 − 4√3 = 0.071797** | **F=4** | 0.06699 | **+7.2%** |
| **23** | 1/12 | **1/3** | 1/2 | **7 − 4√3 = 0.071797** | **F=4** | 0.05051 | **+42.1%** |

The nine classes whose rung was already F = 2 are unchanged and reproduce the existing constants exactly. The four that change are precisely the classes the mod-8 argument sent to a degraded rung — 7 and 15 ("stuck on rung C") and 11 and 23 (obstructed at ℓ = 3).

**Closed forms.** The two new constants are clean:

> cap₄(1/3) = 1/(2 + √3)² = **7 − 4√3** = 0.0717968 …
> cap₄(1) = 1/3² = **1/9**

**The global constant.** The smallest entry moves from **(5 − 2√6)/2 = 0.050510 at n ≡ 23 alone** to **7 − 4√3 = 0.071797, tied between n ≡ 11 and n ≡ 23**. A factor of **1.421**. Even classes are unaffected and all sit at 0.13397 or above, so this is the global minimum over all 24 residues.

**Consistency with what is computed.** Configurations of this shape score as predicted under `mu_enumerate_v2.py`'s own `value()`, which enforces the full cyclic-layer pairwise coprimality: n = 90539 gives 0.057681 via `4x13219 + 1x37663*`, n = 130223 gives 0.058484, n = 197663 gives 0.063786 — all with r − 1 = 6q^e, all class 23, all above the old ceiling of 0.050510 and climbing toward 0.0718 as supply improves. Independently, the class-23 minimum of `ladder_verify.py`'s lower bound rises 0.0445 → 0.0502 → 0.0559 → 0.0588 → 0.0599 → 0.0630 → 0.0638 across blocks from 2·10⁴ to 2·10⁵, crossing the old ceiling near 5·10⁴ and continuing to rise.

## 5. What is weakest here

**The realisability measurement is the soft point.** "Guaranteed η" is the minimum over roughly 30–60 sampled n per class in the range 6·10⁴–9·10⁴, scanning c over the full admissible window. It is not a proof that every n in the class admits the pair, and an earlier version of exactly this measurement was wrong in an instructive way: it asked whether η was available without checking that the *matching* side still attained its share, and so reported η = 1/6 reachable at F = 2 for class 23 — contradicting the existing document, which was right. The current figures restrict to c ≡ 3 (mod 4) and reproduce the document's η = 1/12 for F = 2 at class 23, which is the check that the correction took.

**The asymptotic claim needs a supply heuristic.** For the cap to be approached, each n needs a decomposition n = 4c + r near x\* with c ≡ 3 (mod 4) prime and r − 1 = 6q^e. The window holds ~εn/log n prime powers and the chance that r is prime with the required shape is ~1/log²n, so the expected count grows like εn/log³n → ∞. That is the same Hardy–Littlewood-type input the rest of §3 already assumes, but it is an assumption, and the observed values are still well below the cap at 2·10⁵ — the approach is slow.

**Only F ≤ 6 was scanned.** cap_F(η) decreases in F, so large F is unpromising, but F = 8 with a still better η at some class has not been ruled out by anything except the trend.

**Three-part shapes with F ≥ 3 in one part were not considered at all.** The scan covers two-part shapes F·c + r and compares against the existing three-part ladder; mixed shapes such as 4c + 2c′ + r are outside both.

## 6. What would change if this survives

1. **§3.3.5's table** — four rows, and the rung column gains F = 4 entries. The derivation preceding it needs the parity constraint (odd n forces even F) and the mod-8 table of §3 above.
2. **The global constant**, in at least four places: §1 consequence 3 ("eight distinct constants, from 1/4 down to 0.05051"), §1's summary of §3.3, §3.3.5's closing paragraph ("attained at n ≡ 23 (mod 24) alone"), and §5, where the floor is stated against it. The phrase "three of the twelve odd ones — 7, 15 and 23 — are stuck on rung C" becomes false as a statement about the optimum, though it remains true about the three-part ladder.
3. **The census** — S7 at F ≥ 3 stops being an escape of density zero at the low-cap residues and becomes the *ceiling-setting* shape there. Its row's "wins nowhere / wins at O(n/log n) values" accounting needs redoing.
4. **`ladder_verify.py`'s CAP table**, which is keyed to the old constants and is what the worklist threshold is measured against. With the new caps the worklist should be regenerated; the 16 current entries are all below the old 0.050510 and would be re-ranked against 0.071797.
5. **`count_check.py`'s caption**, which lists the rung-C caps as the class ceilings.
6. **`aod` §5's floor narrative**, which is stated against 0.050510 as the asymptotic target.

*Not affected:* every statement about B_safe, μ(n) = B(n), the collapse certificate, and the computed table. These are ceilings of a family, hence floors for μ; raising them does not change any computed value, and §3.3.5's own warning — that the rows bound the family and not δ(n) — is the reason nothing downstream of the table depends on them.

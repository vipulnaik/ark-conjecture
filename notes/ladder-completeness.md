# Why the ladder equals B: menu completeness above density 1/25

*Working note, one pass. Companion to `arithmetic-of-density.md` §5 and `enumeration-proof.md` Part E‴. It answers one question: when `ladder_verify.py` reports a floor at an n where `mu_exact.py` is out of reach, how much of that floor is a bound and how much is the value? The answer is a structural theorem that the ladder's menu contains a B-optimal configuration at every n with δ(n) > 1/25 **except** for one family of shapes, plus a conditional argument that this family never wins for large n, plus a check that it never wins on the table. Nothing here is a proof proof: the conditional half rests on Hypothesis (BCG-AL) of `arithmetic-of-density.md` §3.5.3 — the same per-n supply hypothesis the ceiling table rests on — with its ε pinned to a specific value.*

**Status of what is asserted.** Proposition 1 is proved by counting on SAFE terms, the same base as Theorem E.5. Proposition 2 is arithmetic on the efficiency of foreign primes, verified separately by scan. Proposition 3 is conditional on (BCG-AL) at ε ≤ 0.129 and is where the extrapolation lives. The table check is `ladder_vs_B.py` and `offmenu_scan.py`.

---

## 1. What the menu is, and what "ladder = B" needs

`ladder_verify.py` scores four families over a window x = c/n ∈ [0.10, 0.85] and takes the maximum:

| census shape | what the ladder scores |
|---|---|
| **S2** — one fused class, n = F·c, any F | F·C(c,2) |
| **S3** — c + r\*, skipped if r \| c−1 | min(C(c,2), orb(r, best q), cr) |
| **S4 / S7 at F = 2 / S5** — the three readings of 2c + r\* (unfused; cyclic-layer fused; top-layer fused) | the rung scores, with q pinned to the reading |
| **S7 at F ≥ 3** — F·c + r\*, 3 ≤ F ≤ 16 (and F = 25 as a tripwire), each (F, q) split | F·orb(c, d) with only the foreign prime stripped |

(S1, the prime powers, is skipped by every table as already known; S8, S9, S10 do not exist or are dominated by theorem. The census numbering is `arithmetic-of-density.md` §2.0 = `enumeration-proof.md`'s census, and it is the only shape jargon this note uses.)

Every score it emits is the REFINED score of an admissible configuration, so **ladder ≤ B_refined ≤ B_safe** always (`pending-checks.md` risk item 3). Equality needs two things: **(a)** a B-optimal configuration lies in the menu and inside the window, and **(b)** the ladder scores it at SAFE, which holds exactly when it is fallback-free. (b) is Theorem E.5: above 1/25 the optimum is fallback-free. So the whole question is (a).

## 2. Proposition 1 — what the optimum can be above 1/25

> **Proposition 1.** Let B(n) > C(n,2)/25 and let W attain it. Then W is one of:
>
> - **S2, S3, S4, S5, or S7 with F ≤ 16** — the ladder's menu — with, for S3, the matching share c/n in **(1/5, 4/5)** and, for S4/S5/S7, the class share F·c/n below 4/5; or
> - **S6 or S11** — the two shapes with **two foreign primes**, r₁\* + r₂\* alone or with one matching block — with both r_j − 1 = k_j·q^{e_j} for a **common** top prime q and k_j ≤ 12.
>
> Nothing else: in particular not **S12** (two matching classes of distinct size), which is dominated.

*Proof.* Write δ = B/C(n,2) > 1/25 and let ℓ be the least part size with C(ℓ,2) ≥ B, so every part has size ≥ ℓ > n√δ·√((n−1)/n) — i.e. **every part has share > 1/5**, and there are at most four parts (Proposition F.1).

- *Fallback-free* by Theorem E.5, so a matching class scores F·C(c,2) and the ladder scores it the same way.
- *Window.* Every part has share > 1/5, so in S3 the matching share c/n lies in (1/5, 4/5) — the foreign part is the complement — which sits inside [0.10, 0.85] with margin on both sides. In S4/S5/S7 the class share F·c/n is below 4/5 for the same reason, and the ladder's per-block c/n is smaller still.
- *Two matching classes merge.* Two classes (F₁, p^a), (F₂, p^b) with a > b share the bottom prime, and the single class of F = F₁p^{a−b} + F₂ blocks of size p^b dominates: its intra F·C(p^b,2) ≥ F₂·C(p^b,2), which was already a term of the old minimum; its within-class cross never binds; its cross terms with every foreign part are unchanged. It is admissible whenever no foreign prime divides F, and a foreign prime r > n/5 cannot divide F ≤ n/p^b unless p^b < 5, which fails the size bound. So no optimum is an S12.
- *Fusion count.* cap_F(1) = 1/(1+√F)² is the most S7 can reach at fusion count F, and it is below 1/25 for F ≥ 17. So F ≤ 16.
- *Three or more foreign primes.* All share q; their sizes are k_j q^{e_j} + 1 with k_j ≤ 12, so any two have ratio ≥ 2 unless equal, and three distinct ones have shares y, ≥ 2y, ≥ 4y — or with mixed k, at best y, 2y, 3y — summing to more than 4/5 once each exceeds 1/5. Impossible. So v ≤ 2.
- *Efficiency of the foreign primes in S6 and S11.* A foreign part of share y < 1/2 needs η·y² > 1/25, so η > 4/25 and (r−1)/t < 12.5. ∎

Everything in S2–S5 and S7 is in the ladder's menu after the 2026-09 corrections (window right end 0.55 → 0.85; fusion set 3..12 → 3..16). **S6 and S11 are not in the menu**, and they are the entire content of the question. S11 is the hybrid shape — one matching class beside two outside blocks — and it earns a census number for one reason: a ladder shortfall above 1/25 has to be an S6 or an S11, so the two must be nameable.

## 3. Proposition 2 — the off-menu shapes have an absolute ceiling

> **Proposition 2.** Excluding configurations using a Fermat prime (of which finitely many exist, all at n < 200),
>
> - **S6** (r₁\* + r₂\*) has SAFE ≤ **C(n,2)/9**, with equality approached by (2q^e + 1, 4q^e + 1) — the pair (1459, 2917) at n = 4376 reaches 0.1111;
> - **S11** (c + r₁\* + r₂\*) has SAFE ≤ **C(n,2)/16**;
> - and S6 has n **even**, so at **odd n** every off-menu shape is an S11 and is below 1/16.

*Proof sketch.* Two distinct primes r_j = k_j q^{e_j} + 1 with the same odd q have k_j even (r_j odd), so the size ratio ρ = r₂/r₁ is (k₂/k₁)·q^{e₂−e₁} with k_j ∈ {2, 4, 6, 8, 10, 12}, q ∤ k_j, and ρ ≠ 1. The density of S6 is min(η₁y₁², η₂y₂², 2y₁y₂) with y₁ + y₂ = 1, y₂ = ρy₁, η_j = 2/k_j. Enumerating (k₁, k₂, e₂ − e₁) the supremum is **1/9**, attained only at (k₁, k₂) = (2, 4) with e₁ = e₂, i.e. r₂ = 2r₁ − 1 and (η₁, η₂) = (1, ½), where y₁ = 1/3 gives min(1/9, 2/9, 4/9). For S11, adding the matching block's x² and the crosses 2xy_j and maximising over x gives **1/16** at the same pair, x = y₁ = 1/4. At q = 2 the primes are k·2^e + 1 with k odd; η = 1/k, and any pair with η > 4/25 for both needs k ∈ {1, 3, 5}: k = 1 is a Fermat prime, and without it the sup drops to 0.047. The Fermat cases give 0.12 (S6) and 0.066 (S11) but need 2^{e+1} + 1 and 3·2^e + 1 both prime, which happens only at n = 12. ∎

*Checked by scan* (`offmenu_scan.py`): over all efficient-prime pairs with a common q up to 36,848, the off-menu shapes score at 729 tabulated n, are above 1/25 at 352 of them, reach a **maximum density of 0.1111** (n = 4376), and **never reach B(n)** — closest 0.842 of B at n = 56 and 0.834 at n = 4376, both S6 at the (2·3^e+1, 4·3^e+1) pair. So on the table, neither S6 nor S11 ever wins.

## 4. Proposition 3 — why S6 and S11 never win for large n, conditionally

The off-menu ceilings sit strictly below every class ceiling of `arithmetic-of-density.md` §3.3.5:

| where S6 / S11 live | their ceiling | the menu's ceiling there | margin |
|---|---|---|---|
| even n, classes 0, 4, 6, 10 (mod 12) — S6 | 1/9 = 0.1111 | 1/4 (S3) | 0.139 |
| even n, classes 2, 8 (mod 12) — S6 | 1/9 = 0.1111 | 0.13397 (S3 at η = 1/3, or S7 at F = 3) | **0.023** |
| odd n, any class — S11 only | 1/16 = 0.0625 | ≥ 7 − 4√3 = 0.0718 (S7 at F = 2 or 4) | **≥ 0.0093** |

**The hypothesis is (BCG-AL), `arithmetic-of-density.md` §3.5.3, and nothing new.** Its clause 2 says every sufficiently large n admits the ceiling-setting menu configuration with δ ≥ (1 − ε)·δ₀(n) for a fixed ε > 0. What this note needs is that clause with **ε ≤ 0.129**: the relative margins from the off-menu caps up to the class ceilings are 1 − (1/9)/0.13397 = **0.171** at classes 2, 8, and 1 − (1/16)/(7 − 4√3) = **0.129** at class 11, with every other class wider. `approach-rate-note.md` gives the actual shortfall as Θ(log³n/n), so any fixed ε is eventually met; the point of naming 0.129 is that it says *how large* "sufficiently large" is.

> **Proposition 3.** Under (BCG-AL) with ε ≤ 0.129, for every sufficiently large n with B(n) > C(n,2)/25, some menu configuration attains B(n); hence **ladder(n) = B(n)**.

*Proof.* Propositions 1 and 2: the optimum is in the menu or is an S6 (density ≤ 1/9, n even) or an S11 (density ≤ 1/16). Under (BCG-AL) the ceiling-setting menu shape reaches (1 − ε)·δ₀(class), which exceeds 1/9 at every even class and 1/16 at every odd class once ε ≤ 0.129. So for n large the menu beats every S6 and S11, and the optimum is in the menu; the ladder scores it at SAFE by E.5. ∎

**Where "sufficiently large" bites, and it is not asymptotic hand-waving.** The binding *absolute* margin is class 2/8 against S6's 1/9: 0.023. At the approach rate of `approach-rate-note.md`, the shortfall ≈ 0.3·log³n/n falls below 0.023 around **n ≈ 10⁴** — which is exactly where n = 4376 sits (S6 at 0.834 of B, the closest approach on the table). So the table's clean verdict at n ≤ 36,848 and Proposition 3's "large n" overlap, with no gap between them: below ~10⁴ the check is the table, above it the check is (BCG-AL), and both say the same thing. The odd-n margin is smaller in absolute terms (0.0093 at class 11) but the odd-n off-menu shape is S11, which needs a third part and a Cunningham-like pair, and the table shows it reaching only 0.0478 (n = 323, 1175) against a class ceiling of 0.0718 or more.

## 5. What this licenses, and what it does not

**Licensed.** Reading a ladder value at n > 36,848 as B(n) — hence as μ(n), by Corollary E.6 wherever it exceeds 1/25 — is correct *unless* an S6 or S11 wins at that n, which requires the menu shape setting n's class ceiling to fall 0.023 (even n) or 0.0093 (odd n) short of it. That is a specific, checkable event: `offmenu_scan.py` extended to the range in question would find it. **The extrapolation is not "the ladder is probably tight"; it is "the ladder is tight unless an S6 or S11 beats it, and here is the script that looks for one."**

**Reading it off the table.** The same fact runs the other way on the computed range: at any row with δ > 1/25, if the recorded winner's census shape is S2, S3, S4, S5 or S7 with F ≤ 16, then the ladder — *provided its implementation is complete* — scores that very configuration at SAFE and so equals B there, without being run. `validate_table_v3.py` already classifies every row's shape, so this is an O(rows) check and now runs as one ("every winner above 1/25 is a menu shape"). Two cautions. A tie between a menu shape and an S6/S11 records one witness, so an off-menu witness does not by itself prove ladder < B — only `ladder_vs_B.py` does. And the row check certifies the *shape space*, not the *script*: every one of the 274 window-clip shortfalls had an S3 witness, squarely in the menu, and the ladder still missed it because its window did not reach the c. The row check says what the ladder *should* score; `ladder_vs_B.py` says what it *does*. Both are needed, and they fail in different places.

**Why `mu_exact.py` is slower, in these terms.** It has to be an upper bound, so it enumerates the whole shape space: every prime-power block size with no window, every fusion count, S12 (two matching classes) and — the expensive part — S11, which for every candidate matching class tries every foreign pair completing n, an O(n) inner loop that makes the per-n cost quadratic and more. The ladder is a lower bound and can stop at the first configuration that clears its threshold. So yes: the cost difference is essentially the off-menu shapes plus the absence of a window, and the fact that S6/S11/S12 never win is what makes that search return nothing at a high price.

**Not licensed.** Nothing here bounds the ladder below 1/25, where Proposition 1's counting fails and the fallback branch reopens; the ladder is a lower bound there and no more. And (BCG-AL) is a hypothesis about *every* large n; under (BCG-AA) — almost all n, the version `sp-to-floor.md` derives from a fixed system — the conclusion weakens to ladder = B for all but O(x/log^A x) values, which is a different and weaker statement.

**A counterexample, if one exists, is of one shape.** It would be an n — even, in class 2 or 8 (mod 12) — with a prime pair (r, 2r − 1), r − 1 = 2q^e, both foreign at a common q, and at which no c + r′\* with c a prime power and r′ − 1 = 6q′^{e′} lands within 17% of the balance point x = 0.366. Two Bateman–Horn systems have to conspire at one n, one to exist and one to fail. The chain-pair supply is itself thin (the (2·3^e+1, 4·3^e+1) pairs are prime together at e = 1, 2, 6 and at no other e ≤ 12), so the search space for a counterexample is small and enumerable; `offmenu_scan.py` enumerates it.

## 6. Two corrections to `ladder_verify.py` that this analysis forced

1. **Window right end 0.55 → 0.85.** Proposition 1's [0.2, 0.8] is the range the two-part family needs; the old window clipped it and the ladder fell short of B at 274 tabulated values, by up to 1.835× (`pending-checks.md` R7a).
2. **Fusion set 3..12 ∪ {16, 25} → 3..16 ∪ {25}.** cap_F(1) crosses 1/25 between F = 16 and 17, so completeness above the floor needs 13, 14, 15 (caps 0.0472, 0.0447, 0.0425). No tabulated winner uses them; the ladder was complete by luck.

After both, `ladder_vs_B.py` reports ladder = B at all 32,861 tabulated values, exactly, with 0 over-scores.

## 7. Not done

- (BCG-AL) is assumed, not derived, exactly as everywhere else in `aod` §3; what this note adds to it is only the threshold ε ≤ 0.129. The rate at which the shortfall falls below that at classes other than 11 is `approach-rate-note.md`'s §6 first bullet, still open.
- Proposition 2's enumeration covers k ≤ 12 and |e₂ − e₁| ≤ 4 by hand and by a small script; a fully rigorous statement would enumerate the finitely many (k₁, k₂, Δe) with ρ ∈ (1/4, 4) once and for all.
- The menu's S4/S5/S7 branches pin q in ways that are stricter than necessary (`pending-checks.md` risk item 3); that only under-scores, so it cannot break ladder = B on the table, but it means a *future* shortfall could arise from a pinning rule rather than from an S6 or S11. `ladder_vs_B.py`'s shape breakdown is what would tell the two apart.

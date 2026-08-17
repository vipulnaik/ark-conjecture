# Session log 7 — the entangled-generator correction and its consequences

*Closed work, moved out of `pending-checks.md` (which states outstanding work only), plus the historical material that the dehistoricization pass removed from the primary documents but that is worth keeping somewhere. Nothing here is a live obligation; anything still owed stayed in `pending-checks.md`.*

**One-line summary.** The SAFE cap's F_mid coprimality condition was refuted; the consequences were traced through every document; the ceiling table lost a constant and a modulus; and the episode produced two new standing checks and one recurring-defect pattern worth naming.

---

## 1. The finding

**The F_mid coprimality cut is not a necessary condition.** A cyclic-layer fusion was believed to force the twist down to the odd part of c − 1, on the argument that "C₂ must sit somewhere, and a cyclic group has a unique subgroup of each order." The argument is invalid: the block-permutation image is a **quotient** of the cyclic layer, not a subgroup. An **entangled generator** — z of order F·d acting as a block rotation whose step-multipliers generate 𝔽_c^×, so that z^F is the full twist — supplies the block count and the full twist from one element.

Three explicit permutation groups, all verified computationally:

| n | configuration | orbitals | note |
|---|---|---|---|
| 33 | 2×13 + 7\*, q = 3 | {21, 156, 169, 182} | intra 156 = 2·C(13,2) full, where the rung-B reading caps at 78; no q = 2 rechain exists, the foreign 3-twist blocking it. **Theorem 3.1 false as stated.** |
| 78 | 6×13, top trivial, z of order 72 | {468, 507, 1014, 1014} | m\* = 468 > B(78) = 465 — the smallest direct table counterexample |
| 105 | 2×29 + 47\*, q = 23, multiplier 4 of order 23 | {812, 841, 1081, 2726} | m\* = 812 > B(105) = 506, ratio 1.605 |

**Impact scan.** With Lemma C's foreign strip retained and the F_mid strip dropped, **289 of the v4 table's 2,186 rows understate μ**; largest ratio 1.889 at n = 253 (2×73 + 107\*, 2783 → 5256). 15 of the 16 S4 census winners are exceeded (all but n = 1529), so the S4 resurrection reverts. 12 of 18 tail rows are hit.

**What survived untouched.** Every lower bound and ladder floor (construction-side, so a scoring correction cannot reach them); Lemma C's foreign strip; F_mid-vs-foreign domination; Parts A–D, G.1, F.1, G.4; the global constant 7 − 4√3 and its extremal class.

---

## 2. Consequences worked out

### 2.1 The c mod 8 law is retired, and c mod 4 becomes a free parameter

The fused intra term is 2·C(c,2) at **every** odd prime power c, so the cyclic-layer rung strictly beats the unfused reading everywhere, with no congruence and no tie case. What c mod 4 does instead is **steer**: at F = 2, 2c ≡ 2 or 6 (mod 8) according to c mod 4, so r = n − 2c reaches two residues mod 8; at F = 4, 4c ≡ 4 (mod 8) for every odd c, so it steers nothing. That asymmetry is the entire mechanism of what follows.

**Evidence it is load-bearing rather than merely available:** of 16 cyclic-layer winners in the partial v3 table, **8 sit at c ≡ 1 (mod 4)** — the branch the retired law excluded. Over the fuller run, 37 of 80 (46%), against 14 of 150 (9%) under v4.

### 2.2 Classes 7 and 15 merge, and the table loses a constant

At 7, 15 (mod 24) the freed c mod 4 puts r ≡ 5 (mod 8) in reach, so F = 2 attains η = 1/2 and cap₂(1/2) = 1/8 > the F = 4 value 1/9. The resulting (F, η, x\*, cap) is **identical** to that of classes 3 and 19, so they merge into that row: **six constants, not seven.**

At 11, 23 nothing moves, and the reason is sharp: both F = 2 options land on r ≡ 1 (mod 4), so with the ℓ = 3 obstruction the best F = 2 reaches is η = 1/6, cap₂(1/6) = 0.050510 < 7 − 4√3.

### 2.3 The keying drops from mod 24 to mod 12

At F = 2 the two reachable r residues differ by 4 and so agree mod 4: the 2-adic condition is **mod 4**, not mod 8. At F = 4 a genuine mod-8 condition survives but is **constant on its mod-12 class** (n ≡ 11, 23 mod 24 give r ≡ 7, 3 mod 8, both v₂(r−1) = 1). Mod 4 for the 2-adic part, mod 3 for the ℓ = 3 obstruction: **mod 12**.

Under v4, classes 7, 15 took F = 4 while 3, 19 took F = 2; since 15 ≡ 3 and 7 ≡ 19 (mod 12), that grouping cut across mod-12 classes — and it was the table's **only** genuine mod-24 dependence.

### 2.4 Independent confirmation of the rekey

`ceiling_rederive.py` — deliberately not a congruence argument. It scans real configurations of the generic family (c a prime ≥ 5, twist a prime power at q ≥ 5, F even) and takes the empirical sup of density per residue class, with §3.3.8's four escapes excluded.

| class | empirical sup | closed form | at |
|---|---|---|---|
| 7, 15 | 0.124987, 0.124985 | 1/8 | F = 2, η = 1/2, c/n = 0.24999, 0.25001 vs x\* = 1/4 |
| 11, 23 | 0.071791, 0.071793 | 7 − 4√3 = 0.071797 | F = 4, η = 1/3, x\* = 0.13398 vs 0.13397 |

All eight other odd classes reproduce to four places from below, and **both 7/15 witnesses sit at c ≡ 1 (mod 4)**. Keyed mod 12, every pair {a, a+12} agrees in cap, F and η.

> **A detour worth recording, because it briefly looked like a second gap.** The first run showed classes 5, 11, 17, 23 *exceeding* their closed forms — 1.48× at class 11. The witnesses were c = 3⁷, 3⁸ and, on a second pass, r = 17497 with r − 1 = 2³·3⁷. Those are §3.3.8's documented O(n/log n) escapes: when c or oddpart(r − 1) is a pure power of 3, the ℓ = 3 obstruction evaporates. **A naive sup over a range measures the escapes, not the ceiling.** That the exceedances vanish exactly when the escape filter goes on is itself a check on §3.3.8's account of them.

### 2.5 §3.4: two errors found that had nothing to do with the correction

- **F·width is an exact identity, not a near-coincidence.** For δ ≥ λ·cap the window is (1 − √λ)/F, with η and x\* both cancelling. So F·width = 1 − √λ for every row — 0.051317 at λ = 0.9. The document said the rows were "comparable"; they are identical. Verified at λ = 0.9, 0.99, 0.999 across all six (F, η) pairs to seven places.
- **The cost of approaching the cap is Θ(ε), not Θ(√ε).** √ε is what a *smooth* interior maximum gives; the maximum here is a **kink**, where an increasing branch meets a decreasing one, so the window closes linearly. The document was pessimistic, and nothing downstream used the exponent.
- A legacy claim that "the three-part family needs c = r = n/3 at balance" matched no row (the three-part balance points are 0.2929, 0.25, 0.2247, 0.1340) and was replaced with the actual per-row obstructions.

### 2.6 The chiral setting: the correction *helps*

`chiral-graph-properties.md`'s parity rule (F) computes the sign of a **pure** diagonal F-cycle. The framework's block swaps are entangled generators, whose cycle type is different: one F-cycle on the F zeros, plus (c−1)/d cycles of length F·d. So

> sgn(z) = (−1)^(F−1)·(−1)^((Fd−1)(c−1)/d),

which at full twist collapses to **+1 for every even F and every odd c**; and z^F, the diagonal twist across all F blocks, is the single-block sign raised to the F-th, hence even at every even F regardless of d.

**Consequence: ε = 1 at every fused matching class.** The c ≡ 1 (mod 4) penalty applies only to *unfused* blocks. So the six mod-12 ceilings carry over to A_n **unscaled** at odd n, the F = 4 shape is available after all (retiring the document's main open worry), the global constant stays 7 − 4√3 rather than dropping to ~0.048, and the chiral floor conjecture is 1/25 rather than 1/50. Prediction now sharp enough to test: **δ_chi(n) = δ(n) at every odd non-prime-power n.**

*Verified:* the cycle-type formula against brute-force signs at c = 5, 7, 11, 13 with F = 2, 4; the closed form at nine c with F = 2, 4, 6; and on real groups — ⟨translations, z⟩ at c = 5, 13, 17 (all ≡ 1 mod 4) with F = 2, 4 has every generator even and pair-orbitals including the full F·C(c,2).

---

## 3. The n = 10 post-mortem: why this was not caught for so long

**The defect was fully present and detectable at n = 10**, the smallest fused shape in the programme. The cyclic-layer fused class at F = 2, c = 5 was scored **10** (twist stripped to oddpart(4) = 1) against a realised **20**.

**Why no check saw it.** At c = 5, c − 1 = 4 is a 2-power, so a **top-layer** reading (q = 2, F_top = 2) reaches the full twist with no entanglement needed and gives the same m\* = 20. The maximum over shapes was therefore right, for the wrong reason, and every check in the battery validates the maximum:

- `verify_witness.g` builds the *recorded winner* and confirms its minimum orbital;
- `validate_table` re-derives B from the *recorded witness*;
- the small-degree computations confirm nothing *exceeds* m\*.

**None of them looks at a shape that loses.** A mis-scored losing shape is invisible everywhere until it becomes a winner — which here first happened at **n = 78**, 68 degrees later.

> **Two details worth keeping straight.** The two readings at n = 10 are *not* the same group: ⟨translations, z⟩ and ⟨translations, diagonal twist, block swap⟩ both have order 200 and neither contains the other. They merely share the orbital partition [20, 25]. And the coincidence is **arithmetic, not structural** — it needs c − 1 to be a 2-power so that q = 2 loses nothing, which holds at c = 5 and fails as soon as c − 1 has an odd part worth having.

**The asymmetry that makes this the dangerous direction.** B(n) is an upper-bound claim, so a shape scored *below* what a group actually achieves makes B too small and can break μ(n) ≤ B(n). A restriction that "looks conservative" fails exactly this way. `small-degree-computation.md` §1.2 states the mirror-image asymmetry for the CSP half — "dropping constraints can only turn a real UNSAT into a spurious SAT" — and the enumerator half never had it written down. **The programme had the lesson in one document and did not apply it in the other.**

---

## 4. The recurring defect, named

**Subgroup versus quotient.** An argument that constrains a layer by what *subgroups* it contains, applied to an object that enters as a **quotient**. Four instances to date:

1. the n = 308 bug;
2. the SAFE `dmax` strip;
3. the F_mid coprimality condition (this session);
4. `TemplateGroup`'s chain model, which puts the block rotation in Γ₁/Γ₂ and requires "d, the foreign primes and s pairwise coprime" (`small-degree-verification.md` §10).

The standing check now lives in `arithmetic-of-density.md` §3.2.2: *whenever an argument constrains a layer by what subgroups it contains, ask whether the object being placed there is a subgroup or a quotient.*

Instance 4 is worth a note: its documented repair — move the rotation into the top q-group — works but treats the constraint as real and routes around it at the cost of changing the layer assignment, `desc_parts` and `top_prime` parsing. The cheaper repair is to drop the coprimality, keep the rotation in Γ₁/Γ₂, and retain only Lemma C's foreign coupling.

---

## 5. Closed items

### 5.1 `shape_realize.py` — new standing check *(this session)*

Constructs, for each (F, c = p^a, d), a group realising the fused matching class via an entangled generator, and compares its actual intra and cross pair-orbitals against the scored terms. **98 shapes to n ≤ 34, 0 mismatches** under current scoring; the `--strip` control reproduces the defect (scored 10 vs realised 20 at n = 10; under-scores at 8 of 47 shapes below n = 22).

> **Three bugs found while writing it, two of them the same species as the one under investigation.** (a) The halving rule in `orb` was garbled — the orbital is indexed by difference up to T *and up to sign*, so it is c·d/2 when −1 ∈ T and c·d otherwise, with characteristic 2 always halving. (b) Comparing one overall minimum against min(intra, cross) conflates two different pair populations; the fix splits realised orbitals by whether both endpoints share a block. (c) **For c = p^a with a > 1, generating translation by 1 only gives Z_p rather than the full additive group** — silently under-building the block group and producing spurious OVER-SCOREs at c = 4, 8, 9. That last is the same failure mode as the strip: a construction realising less than it should, looking like a conservative bound.

### 5.1a `ark_shapes.g` — the GAP-side companion *(this session, written not yet run)*

Realises the same configuration shapes in GAP and checks what the Python side cannot: **that each shape is admissible**, by reusing `ark_gap.g`'s `IsOliverTop` verbatim so the two files agree by construction. `shape_realize.py` assumes admissibility and tests only the orbital arithmetic — if a scored shape were *not* Oliver, the Python comparison would be vacuous and would report "ok". The GAP construction is also independent: `Group()`, `Orbits()` and `NormalSubgroups()` rather than a hand-rolled union-find.

Four GAP-specific errors were caught in review before shipping, worth noting since they are the kind that only surface at run time: booleans are not integers, so `(F mod 2 = 0) * x` and `Int(STRIP)` are both invalid; a basis of GF(p^a) needs the subfield named, `Basis(AsVectorSpace(GF(p), fld))`; and `Z(c)` is the canonical primitive root, avoiding a package dependency. Top-level loop variables are pre-declared for the same warning hygiene `ark_gap.g` uses. **Not yet executed — no GAP in this environment.**

### 5.2 Script audits

| script | verdict |
|---|---|
| `ladder_verify.py` | **Finding A:** the S7 (F ≥ 3) loop lacked the (c−1) % r Lemma-C guard. Audited to 10⁶ (`audit_s7.py`): 495,176 candidates with r \| c−1, 25,937 with a larger invalid score, **0 exceeding the guarded maximum** — all 10⁶ figures stand. Patched; N = 20,000 runs byte-identical. |
| `engine.py` | Clean. Both documented χ expectations reproduce (−1215, −243), and an independent hand-computation of the support ≤ 3 closure gives A = 1 − 45 + 120·2 = 196, χ = −195, exact. Nits: a dead conditional; `bip_pack`'s isolated-vertex cap contract is undefended. |
| `count_check.py` | Machinery sound (exact local factors, gcd(D,K)/K integrality, Simpson). **Defect:** `XSTAR_BY_RESIDUE` at 7/11/15/23 carries rung-B balance points (0.29289/0.18301/0.22474) rather than §3.3.5's x\*, and the in-file comment claims rung C, matching neither. Still open — and now doubly stale, since 7/15 moved to x\* = 1/4. |
| `validate_table.py` → `validate_table_v3.py` | `CAP24` was stale even against v4 (7/11/15/23 held pre-rekey values). Rebuilt: strip removed from `score()`, `c_cyclic_layer` foreign-only, two c mod 8 congruence checks retired to INFO, and two new exact checks added — `c_eta_reach` (foreign twist is a q-power divisor of r − 1, η respects v₂(r−1)) and `c_mod12_keying` (CAP24[a] = CAP24[a+12] for all twelve pairs). |
| `a18_verify.py`, `t5_verify.py` | Both pass on substance against the v3 table. a18's single FAIL is an artifact of the partial run (threshold needs n ≥ 1582). **Caveat recorded:** t5 validates the *foreign* strip, which survives; it does **not** validate condition (4)'s F_mid clause, and a green t5 run must not be read as condition (4) repaired. |
| `fb_common` / `fallback_cert` / `wide_cert` | Architecture sound; both certificates **void** pending the condition-(4) repair. Condition (6)'s coefficient term never binds (coeff(F)·c² ≥ F·C(c,2) always) — harmless, now documented. |

### 5.3 Independent verifications that came back clean

Witness rescoring across all 2,240 v4 rows; `brute.jsonl` 142/142; `eta_derive` 36/36; the mod-24 closed forms; Meinardus 2.532; Lemmas B′/C/D2; the small-n appendix; the arXiv note's two verification groups rebuilt from scratch ({10, 21, 35} at n = 12 and {10, 10, 21, 25, 35, 35} at n = 17); C₀ = 0.635166 and the singular-series bound 2.858249; the admissible-d mod-12 table at five residues by root counting; the 1/300 corner minimisation; both Oliver chains; the worklist minimum 323; B(10) = 20 and B(12) = 18 against the exhaustive ground truth, meeting and not exceeding.

### 5.4 Document work

- **§3 rewritten** (plan in `aod-section-3-rewrite-plan.md`, now itself retirable): 25 edits, including five sites the plan's inventory missed — §3.3.3's rung ladder, §3.3.5's F=4-beats-F=2 box and its ties box, §4's automatic-congruence paragraph, §6's domination paragraph.
- **Mod-12 rekey rolled out** across nine documents and the validator; the arXiv note's framing sentence updated in both versions.
- **Marker retiering:** ⟦EG-TENTATIVE⟧ retired entirely; 74 structural sites now read as settled, 28 numeric sites carry ⟦PENDING-REBUILD⟧.
- **Dehistoricization:** 75 sites, history down from ~120 references to 16 load-bearing ones. Incident narration deleted; nine sites reframed as present-tense gotchas.
- **`three-part-family-split.md` deprecated.** Its subject — the within-family split by c mod 8 — no longer exists: the fused rung beats the unfused at every c (0.1716 vs 0.1111 at η = 1, 0.1250 vs 0.0858 at η = 1/2, 0.1010 vs 0.0718 at η = 1/3, 0.0670 vs 0.0505 at η = 1/6), so the split is 100/0/0 at all twelve odd residues and the 1:1:2 supply computation predicts a contest settled by inequality. Both its special cases were artifacts of the cut: the cap_B(1/4) = cap_C(1/2) tie at 7, 15, and the fused rung's inability to reach the ceiling at 23. **Three things survive and are flagged in place:** the exact singular-series agreement 𝔖_D = 𝔖_2D (structural — both collision conditions are on h alone and mention no D); §1.2's account of Bateman–Horn's limits (the neglected secondary term is the same 1/log n order as the effect predicted); and the Friedlander–Granville discussion.

### 5.5 arXiv note and bridge

Five factual fixes to the note (both versions kept in sync): the "with equality at n = 11183" overclaim; the exactness parenthetical softened to work-in-progress; **Shparlinski (2015) → (2014)** (TCS 547, verified); μ(n) ≥ → ≫ n^1.677 with the Runbo Li quantifier caveat; and the mod-8 mechanism sentence. Twelve bridge updates plus three pre-existing errors: shape counts "31/117" → 24/65, "eleven of twenty-four" → twelve, and §4 item 3's claim that η ≥ 1/6 "is not guaranteed" (wrong — q = 2 forces r ≤ 25, excluded by r ≥ n/5, so t is eventually odd and the note's rt/2 is deliberate crudeness).

---

## 6. Historical notes worth keeping

*Material removed from the primary documents by the dehistoricization pass, retained here.*

**The gotcha that caught half the error.** §3.2.2 already carried the warning "whenever a congruence on c appears in an argument about fusion, check which layer is being assumed," and it was applied correctly — to conclude the cost is real at the cyclic layer and spurious at the top. The cost was spurious at *both*. The check was right and one level too shallow, which is why the standing version now asks about subgroup-versus-quotient rather than about layers.

**A prediction that came true.** `solvable-relaxation.md` §5 said "anyone doubting the ceiling constants should doubt the η bookkeeping, not the geometry." The 2026-08 error was exactly η bookkeeping — which twists a fused class may carry — and the geometry (shape space, cap formula, balance points) came through untouched.

**Evidence read backwards in hindsight.** `orbital-evasiveness-notes.md` §9 item 9's probe of the abelian-layer relaxation over n ≤ 70 found "no change at any n," recorded at the time as evidence that Lemma C is vacuous on the winners. It is also partial evidence that the budget being probed was partly unreal.

**The k = 3 note was built EG-correct without knowing it.** It asserts a matching block "can always take its full twist," charges fused parts 1/(F·κ_c) at full twist, and describes the k = 2 SAFE cap as "F·C(c,2), tight except where Lemma C bites" — that is v3 scoring, not v4. Written from fresh eyes without the rung history, a fresh derivation simply never installed the false cut on matching blocks; only the imported *argmax* at 7/15 was wrong. Mildly damning evidence about how the error survived: it lived in inherited derivation history, not in what the mathematics naturally produces.

**A free structural check that fell out.** Post-correction the Oliver matching-class score F·C(c,2) = s(c−1)/2 coincides with `solvable-relaxation.md`'s solvable score at c = P(s), so **B(n) ≤ B_solv(n)** is a structural invariant (Oliver groups being solvable) and a free validation on any rebuild. Run against the 289 corrected rows: 0 violations, 20 exact attainments against the two-part solvable optimum alone.

**Superseded figures, for anyone reading an older draft.** The v4 floor was 0.045742 at n = 1817 (witness `1x1039* + 2x389`); n = 1817 rises to ≥ 0.0594 under corrected caps, and the tentative floor becomes 0.048039 at n = 2183 (`6x251 + 1x677*`), restoring n ≡ 23 (mod 24) as the argmin's home. Seven mod-24 constants became six mod-12. §3.2.5's split table read "136 of 150 at c ≡ 3 (mod 4)"; it is now no congruence at all. The S7-at-F=2 census share moved 8/24 → 10/24 and S7-at-F=4 moved 4/24 → 2/24.

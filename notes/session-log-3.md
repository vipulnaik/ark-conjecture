# Session log 3 — the S5/S7 layer conflation, and a documentation pass

*Cold review of `orbital-evasiveness-notes.md` §§1–6, `enumeration-proof.md` and `arithmetic-of-density.md`, starting from a fresh reading with no context from the two prior sessions. Companion logs: `session-log-2.md` (2026-08 pass, the G.2 defect), `session-log.md` (earlier).*

**One substantive mathematical finding, one arithmetic error, one script written, and a large amount of propagation.** The finding is that the odd-n fused rung had been attributed to the wrong census shape, which cost the ladder its labelling but not its constants. Nothing computed by `mu_enumerate_v2.py` turned out to be wrong, and no table needs rebuilding on account of anything here.

---

## 1. The finding: two fusion rungs, not one

### What was claimed

`arithmetic-of-density.md` §3.2 said: *"Fusing doubles the intra term to 2·orb(c, d), but puts C₂ in the cyclic layer, so d must be the odd part of c − 1."* From that came the c mod 8 verdict table, and from that came §3.3's rung-B reachability condition c ≡ 3 (mod 4) ⇒ r ≡ 5 (mod 8) ⇒ n ≡ 3 (mod 8), hence the whole mod-24 rekeying, the class-11-versus-23 split, and `ladder_verify.py`'s `CAP` dictionary.

### Why it is wrong as a general statement

A fusion count F = 2 need not come from the cyclic layer. When q = 2 it can be **F_top**, in which case F_mid = 1, nothing competes with the twist, `dmax = c − 1`, and the intra term is **2·C(c,2) for every odd prime power c**. Three independent confirmations:

- **Theorem 2.1 is exactly this construction** with the foreign block deleted, stated for every odd prime power m and verified at m = 9 and m = 25 — both ≡ 1 (mod 8). Theorem 2.1 and the c mod 8 table contradicted each other directly.
- **`brute.py` agrees.** `classes_for` splits F by `ft = qpart(F, q)` and `score` constrains `dmax` by `Fmid` only. Run at c = 17, 41, 73, 89 the fused q = 2 configuration scores exactly 2·C(c,2).
- **v4 already contained counterexamples.** n = 531 (`p=137 q=2: 2x137 + 1x257*`, B = 18632 = 2·C(137,2)) and n = 595 (`p=13 q=2: 2x169 + 1x257*`, B = 28392) both bind on the intra term with c ≡ 1 (mod 8). 19 of the 174 F = 2 winners have c ≢ 3 (mod 4).

### The correct picture

There are two rungs, distinguished by which layer holds the swap, and they are *different census shapes that were already in the census*:

| | layer | q | twist | efficiency | census |
|---|---|---|---|---|---|
| cyclic-layer fusion | F_mid = 2 | free | odd part of c − 1 → the c mod 8 law | η free | **S7 at F = 2** |
| top-layer fusion | F_top = 2 | forced to 2 | full, c − 1 | **η = 1/u**, u the odd part of r − 1 | **S5** |

So nothing needed a new S-number. What was wrong was that §§3.2, 3.3 and 3.9 attached the cyclic-layer scoring to the name S5.

**The v4 data separates cleanly by top prime**, which is the strongest evidence for the picture:

| | winners | c mod 4 | u = odd part of r − 1 |
|---|---|---|---|
| q odd (cyclic, S7 at F = 2) | 150 | **136 of 150 at c ≡ 3 (mod 4)**; 9 at c ≡ 5 (mod 8), the tie case; 5 at p = 2 | unrestricted |
| q = 2 (top, S5) | 24 | 9 / 7 / 5 / 3 across 7 / 5 / 3 / 1 mod 8 — **no congruence** | only 1 (×18, r = 257) and 3 (×6, r = 769) |

### Why the constants survive

S5 has the same cap formula as rung B, η/(1 + √(2η))², but η = 1/u. Reading cap₂(1/u) down the odd u gives 0.17157, 0.10102, 0.07505, 0.06068, 0.05133, **0.04468** at u = 1, 3, 5, 7, 9, 11 — so S5 clears the worst class ceiling 0.050510 exactly when u ≤ 9, i.e. r = 2^a·u + 1 for one of five small odd u. That is an exponential family: O(log n) candidates per n, O(n/log n) values, the same tier as the other escapes. **Every ceiling in the mod-24 table is untouched.**

The "Fermat escape" documented at §3.3 is this rung at u = 1. That framing made it O(1) and tied to the five known Fermat primes; the correct family is r = 2^a·u + 1 with u a small odd prime power, which is O(log n) per n. r = 769 = 3·2⁸ + 1 wins at n = 1235 and 1403 as the u = 3 case.

### What was corrected, where

- **§3.2** rewritten to give three readings rather than two, with the layer assignments and their scoring stated separately, Theorem 2.1 cited as the witness, and the c mod 8 table scoped to the cyclic rung.
- **§3.3** rung table gains **rung B′**; the reachability box scoped to rung B; a new box computes the cap₂(1/u) ladder and shows B′ is an escape.
- **§3.9** relabelled throughout (was annotated with a scoping box, later replaced with proper relabelling).
- Both censuses: S5 and S7 asymptotic verdicts **swapped** — S5 → escape, S7 at F = 2 → 10/24 outright. Winner counts split 24 / 150.
- `enumeration-proof.md`'s "Why S7 vanishes" → "S7 splits at F = 2, and only the F ≥ 3 half vanishes", with a comparison box.
- **`ladder_verify.py` is not fixed** — its three-part branch scores the intra term unfused and its S7 loop runs over F ∈ {3, 9, 5, 25, 7}, so F = 2 is never tried in either layer while its `CAP` is keyed on rung-B ceilings. Filed as `pending-checks.md` **A6**, with a note that the S7 loop's `(c-1) % qF == 0` guard needs rewriting rather than extending.

---

## 2. The arithmetic error: an off-by-one in Part E′

`enumeration-proof.md`'s Corollary after E.3 read *"Since s ≤ 1/√δ − 1, δ > 1/25 forces s ≤ 3, δ > 1/36 forces s ≤ 4"*. At δ = 1/25 the bound is 4, not 3. The correct ladder is δ > 1/(s+1)²:

> δ > 1/16 ⇒ s ≤ 3 · δ > 1/25 ⇒ s ≤ 4 · δ > 1/36 ⇒ s ≤ 5

The box's own earlier statement ("s ≤ 3 at δ ≥ 1/16") and all of its applications were already right, since they were computed from the inequality directly — so nothing numerical moves. Corrected in three places: the Corollary, Part J item 2 ("within the δ > 1/25 regime" → 1/16), and Corollary F.3's remark, which had called the agreement of the two ladders a coincidence; with the shift repaired they coincide exactly, both descending from k, s < 1/√δ.

J2a now also records that the *threshold* for s = 4 is δ ≤ 1/16 while only four values produce an s ≥ 4 branch — a gap the threshold does not explain, to be re-derived from the certificate's output.

---

## 3. Script written: `rung_split.py`

§3.9.2's measurement band is n ≈ 2×10⁵, far past the enumerator's frontier, so the table there was always a family scan and separating the rungs needed a new program. `rung_split.py` scores the three readings independently at each n and classifies the argmax.

**Two results, one of which corrected a claim made earlier in the same session.**

- **S5 never wins outright anywhere in the band**, at any residue group — it is too thin at 2×10⁵ to supply the best configuration. My initial guess that it was inflating the *fused* column was wrong.
- **It is inflating the tie column.** Counting argmax *membership* rather than ownership: S5 is among the joint winners at **23.5%** of n ≡ 7 and **30.4%** of n ≡ 15 (mod 24), and **0%** at 23. So the layer conflation explains part of the 7/15 excess and none of the 23 excess, splitting one puzzle into two.

**The window convention mattered more than the layer separation**, which is the more important lesson. Run flat ([0.10, 0.42] for every n) the scan reports 7.6% fused wins at residue 23, where §3.9.1 argues the fused rung can never win strictly — and I wrote that up as an anomaly the prediction did not cover. It was an artefact. Scanning each residue at **its own balance point ± 0.05**, which is `count_check.py`'s convention, sends it to **0.0%, exactly as predicted**, and brings residue 23 as a whole to 0 / 43.2 / 56.8 against a predicted 0 / 50 / 50. The anomaly was retracted and a box added: *any measurement in this section not taken at the per-residue balance point is measuring a different question.*

Residues 7 and 15 remain the outstanding gap — predicted 50 / 25 / 25, observed 8.7 / 31.1 / 60.2 and 0.0 / 31.6 / 68.4, with S4 near its predicted share and the fused wins almost all becoming ties.

---

## 4. S6's asymptotics, worked out rigorously

The census had "supply-limited, → 0". The truth is sharper and the diagnosis was wrong.

**The efficiencies are a pair of integers and the cap is closed-form.** With one q serving both blocks, write r_i − 1 = 2·q^{a_i}·m_i with gcd(m_i, q) = 1; then η_i = 1/m_i and

> **cap(m₁, m₂) = 1/(√m₁ + √m₂)²**

giving 1/4 at (1,1), 3 − 2√2 at (1,2), (2 − √3)/2 at (1,3), 1/8 at (2,2), 1/9 at (1,4). Verified against a direct optimisation and against η = orb(r,t)/C(r,2) on all r = 2q^a m + 1 with q ≤ 7, a ≤ 2, m ≤ 5.

**The 1/4 ceiling is unreachable except on a set of size O(N^{1/3}).** It needs m₁ = m₂ = 1, and distinctness of the two foreign primes then forces a₁ ≠ a₂, so n = 2(q^a + q^b) + 2 with a < b. Computing ω(3) over all a < b ≤ 6: **every pair is obstructed at ℓ = 3 except (1,3), (1,5) and (3,5)**. In particular (1,2), which would carry the bulk of the count, has ω(3) = 3 and admits only q = 3 — the single value n = 26. Survivors have b ≥ 3, so q ≤ (N/2)^{1/3}.

**One rung down is obstructed too.** The 0.17157 family (q, 2q+1, 4q+1, n = 6q+2) also has ω(3) = 3 and also admits only q = 3, giving n = 20.

**What survives is dominated.** The best unobstructed family with full supply is m = (1,3), n = 8q + 2, cap 0.13397. But n = 8q + 2 ≡ 2q + 2 (mod 3), which is ≡ 2 (mod 3) only at q = 3 — so at every other member S3 is unobstructed and sits at 1/4.

**So S6's fate is (ii) with a plausibly finite winning set**, by local obstruction rather than scarcity. Empirically: over even n ≤ 1428, **703 admit an S6 configuration and none attains B(n)**; max density 0.11104 (n = 56, r = 19 + 37 at q = 3). The next two are n = 20 and n = 26, the surviving members of the obstructed families — a satisfying consistency check.

---

## 5. Other corrections found along the way

**The n = 1175 two-foreign witness has moved (→ `pending-checks.md` A7).** Part I records n = 1175 = 641\* + 277 + 257\* as the unique S6 winner. Under v4 that n is won by `p=139 q=103: 1x619* + 4x139` — one foreign part and a cyclic-layer-fused class of four. Combined with §4 above, S6 has **0** winners in v4's range, not 1. The general lesson attached: the shape-space repair can move a winner from one census row to another, so every per-shape count in Part I is v2-era until recomputed.

**The exists/wins split, and two labelling errors it exposed.** Census asymptotic columns now report **exists** and **wins** separately. Writing that out surfaced three things:

- **S3 exists on strictly more than 12/24.** The odd-n instances n = 2^a + r\* are a positive proportion by Romanov, bounded away from all of odd n by Erdős, with the limiting density unsettled. This is the census's one existence/winning gap of positive *density*; every other gap is a difference of rate.
- **S7 at F ≥ 3 exists at ~12/24, not 0** (caught in review). The O(n/log n) count is the odd-n branch only; at even n, n = 3c + r is a full Hardy–Littlewood system with S3's supply, and it loses on cap, not supply. Its fate is (iii) at odd n and (ii) at even n.
- **S5 is fate (ii), not (iii)** — available at essentially every odd n and beaten almost everywhere.

Also corrected: stale density floor 0.0418 → 0.026117 in two places; v4 contiguity 1340 → 1428 (1,174 rows); S4 winner count 2/4 → 6 with the values listed; `mu_enumerate.py` → `mu_enumerate_v2.py` in five present-tense references including both `DUP:B_definition` blocks. A "table sizes disagree" complaint from the cold review was **retracted** — 1,848 / 1,921 / 2,047 are the counts at n ≤ 2212, n ≤ 2298 and the whole file, and a reconciliation note was added rather than any change.

---

## 6. Explanatory material added

**Hypothesis (H) is now stated**, in §3.5.3. It was referenced from three documents and stated in none of them (it lived in `mu-theta-n2-note.md`). Updated from that version in three ways: the crude c, r ≥ n/5 window replaced by the per-class balance window; c a prime power rather than a prime; and the mod-12/mod-24 distinction called out explicitly, since with both tables in the document it is the obvious place to go wrong. d ∈ {2,4,6,12} retained — the fused rung's d = 8 and 24 only tie or fall short, so four values suffice to attain every ceiling.

**Why c ≡ 3 (mod 4) is the good case**, in §3.2.3 and the notes' glossary. The c mod 8 law is Euler's criterion: pairs are unordered so intra-orbitals are the classes ±δ·T, and −1 is a quadratic residue exactly when c ≡ 1 (mod 4) — so at c ≡ 3 (mod 4) the index-2 subgroup already has ±T = 𝔽_c^× and gives 2-homogeneity on its own. Equivalently, the Paley graph exists only at c ≡ 1 (mod 4); at c ≡ 3 (mod 4) the residue relation is a tournament whose symmetrisation is the complete graph. The consequence: **the factor 2 in c − 1 is not needed inside the block and the cyclic layer can spend it on fusing two blocks instead**, which reframes the c mod 8 law as a budget statement about a single factor of 2. (Verified: ±QR has c − 1 elements at c = 7, 11, 19, 23, 83 and (c−1)/2 at c = 5, 13, 17, 29, 73, 137.)

**Worked instances.** §3.2.4 scores all three readings at the same n and watches a different one win each time — n = 273 (fused/cyclic, 5671), n = 247 (unfused, 2525), n = 531 (fused/top, 18632, and the cyclic rung *does not exist* there since r − 1 = 2⁸ has no odd prime factor). Each cell names its binding term and the last column gives the winner as an explicit minimum with the near-tie quantified. A structural note fell out: a fused class's within-class cross term is c² at q = 2 and 2c² at odd q against an intra term of at most c(c−1), so **the minimum is essentially always the intra or foreign term, never the within-class cross** — which is why §3.3 balances only those two, a step previously asserted without reason. Both censuses also gained a first-instance table.

**A map of §3**, at its head: the two recurring quantities (x and η), the three-pass structure, and two throughlines — that ceilings are family guarantees and never bounds on μ(n), and that every constant traces back to η, hence to the factorisation of r − 1.

---

## 7. Structural changes

`arithmetic-of-density.md` §3 subsections were 500–3682 words against a document median of ~600. Sub-headings added without changing the top-level structure:

- **§3.2 → 3.2.1–3.2.6**; **§3.3 → 3.3.1–3.3.8**; **§3.5 → 3.5.1–3.5.5**.
- **§3.10 merged into §3.9** as 3.9.2, the former §3.9 becoming 3.9.1, with fifth-level headings inside each (3.9.1.1–4, 3.9.2.1–4). All cross-references renumbered, including two in `pending-checks.md` and the docstring of `rung_split.py`.

Everything in §3 is now 82–834 words. Still over 900 and deliberately left: §2.0 (a table plus its reading notes), §3.8, §4.3 (one counting argument).

**Historical framing removed from §§3.2–3.3.** Both sections had accreted "an earlier version said…" notes, including the superseded mod-12 ceiling table and the "2026-08 correction" apparatus that patched it. These now read as current text. What was worth keeping was reframed as gotchas rather than errors — the fusion-layer trap, the η = 1 disjunct that is easy to drop, the "a rung is not an escape" note, and the efficiency pre-filter that would hide the escape rows from the very check meant to detect them.

---

## 8. Open Problem 9, and what it came from

A question about whether the reduction has a class-parametrised form — μ_𝒞(n) for 𝒞 given by a layer word — was probed with two one-line experiments on `brute.py` over n ≤ 70:

| relaxation | effect |
|---|---|
| cyclic middle layer → **abelian** (drop pairwise coprimality) | **no change at any n** |
| top q-group → **nilpotent** (foreign twist any divisor of r − 1) | **5 of 35 values rise**, by 1.22–1.85 |

The second is informative and *which* n move is the point: 56, 60, 63, 66, 70 — the arithmetically weak values — with densities jumping from 0.12–0.16 toward the unobstructed 1/4. So on this evidence the Hardy–Littlewood content traces to **Lemma B′**, the single-prime confinement of a foreign twist, and **not** to the cyclic layer's uniqueness property, whose coprimality budget appears slack at the optimum. Consistent with the independent record that Lemma C is vacuous on every winner.

Written up as **Open Problem 9** with the conjectured decomposition (a Goldbach-tier additive problem always present; one shifted-prime side condition per single-prime layer), two reasons to expect difficulty (O'Nan–Scott kills "primitive ⟹ affine" once nonabelian simple sections appear; the ΓL(1) stabiliser assumption is J0a and open even here), what is contingent even if the shape generalises (all the constants), and the next probe. Intuition also folded into notes §2.3 and §3.

*Caveat recorded in the section:* the probe is n ≤ 70 at `kmax=3`, five values out of thirty-five — suggestive, not evidence. The null result on the cyclic layer is a null result *at small n*, where the budget has little to compete over, and wants rerunning where three-part winners are common.

---

## 9. What was checked and found clean

Recorded so the negatives are on file.

- **Theorem 2.1** both directions; **Theorem 2.2**'s arithmetic (n(n−2)/8 = C(n/2,2); the n = 35 crossover 144 vs 105); **Part C**'s recursion values and closed form; the n = 1425 worked contrast (171,991 / 175,142 / 491,906).
- **Lemma B′** — Step 0's argument is correct and both uses of C_G(V) = V are genuinely needed; Case 2's centre argument is correct. **Lemmas D1 and D2**, including D2's divisibility argument. **Propositions F.1 and F.2**. **Theorems E.1, E.3(i), E.4** and **Lemma E.2**.
- All cap formulas: 1/9, 0.08579, 0.07180, 0.050510, 0.13397, and cap_F(η) = cap₁(Fη)/F. §3.3's uniform lower bound 4 · (9/8) · 0.635166 = 2.858249. The "only ℓ ≤ 3 obstructs" argument and its leading-coefficient caveat.
- **`brute.py` / `brute_compare.py`** read in full and confirmed genuinely independent; all 139 records in `brute.jsonl` (n ≤ 200) agree with v4. **`count_check.py`**'s degeneracy check, `roots_mod`'s identically-vanishing branch, and the Simpson integration.
- **`mu_enumerate_v2.py` needs no rerun.** `_fusions` enumerates *every* (F_mid, F_top) splitting rather than a canonical one, so both rungs are in the search space at every q; and `value()` constrains `dmax` by `Fmid` alone, which is the correct rule since F_top lives in Γ/Γ₁. The enumerator was right throughout — everything wrong was prose. v4 stands as computed and R0 continues from where it is.

## 10. The A5 scope sweep, and `pending-checks.md` cleanup

**`validate_table.py`** (see §3 above for `rung_split.py`; this is the second script) now runs every belief the documents state against any table version, grouped into table integrity / exact claims at every n / density and distribution, with expected asymptotics printed beside each measured quantity. It found the F-parity error of §5 on its first run.

**A5, the expired-scope sweep, is done.** Regex for absolute language intersected with range language gave 41 candidates from ~480 lines; each read against v4. Two genuine expiries:

- *The weak values are no longer all n ≡ 11 (mod 12).* The minimum over the corrected range is **n = 1159 ≡ 7 (mod 12)**, and — more interesting than the residue — its winner is `19x61`, a single fused class. The finite-range floor is currently set by a **multiplicative** value with a large smallest cofactor, not by an arithmetically weak additive residue. Eight of the ten weakest are still ≡ 11 (mod 12), so the additive pattern holds; what has changed is which mechanism binds at computed sizes. Recorded in `aod` §5 as a box, since it gives §3.7's two-engine handover a concrete witness from the floor's side.
- *Part I's low-density tail figures are structurally wrong, not merely stale.* δ ≤ 1/16 falls from 17 values to 3 on the common range, and three-part winners from 129 to 7. The surrounding argument — a tail whose winners spread across part counts — no longer describes anything. Flagged in place.

Everything else in the 41 was correctly range-tagged, still true and now automatically checked, or absolute for a table-independent reason.

**`pending-checks.md` cleaned.** The "open defect" section replaced by a status note (the repair is done; what remains is propagation); the risk ranking updated from "210 rows" to 1,295; R4 marked automated; and six closed §2b items — A0, A0c, A1, A3, A4a, A7 — collapsed from long-form entries into a summary list with the detail here. A6 reduced to the one live item, the `ladder_verify.py` fix.

## 11. `ladder_verify.py` repaired, and what it confirmed

The script modelled neither F = 2 rung: its three-part branch scored the intra term unfused and its S7 loop started at F = 3, while its `CAP` table was keyed on rung-B ceilings. Both rungs are now in the three-part branch:

- **rung B** (cyclic, F_mid = 2): intra 2·orb(c, odd part of c−1), with a new `EFF_ODD` array giving the best foreign efficiency over **odd** top primes only, since q = 2 cannot share the cyclic layer with the fusion.
- **rung B′** (top, F_top = 2): intra 2·C(c,2) at full twist, `EFF2[r] = 1/u`, and within-class cross c² rather than 2c² because F is even.

F = 2 was deliberately kept out of the S7 loop: that loop's guard `(c-1) % qF == 0 → continue` is right for odd fusion primes and kills every odd c at qF = 2, and F = 2 is the rung rather than an escape. Both arrays were verified against their definitions.

**The worklist halves, 436 → 213** at N = 20,000, with the global floor unchanged at 0.02516 (n = 8927) as it must be, the script computing a lower bound.

**The diagnostics validated the §3.2 picture from an independent direction.** Only the fused-rung residues moved: eight of the nine rung-B residues rose by 0.03–0.15 (worst odd residue 0.385 → 0.450), residue 15 rose slightly, and **no even residue moved at all**. That last is the control — fusion does not arise at k = 1 — and it is what makes the result evidence rather than bookkeeping. Had the two rungs been a labelling fiction, adding them would have moved even residues too, or nothing.

One anomaly surfaced and is now item A8(a): **n ≡ 11 (mod 24) did not move**, alone among the rung-B residues, its worst value n = 11819 still at 0.455 of a cap that is rung B at η = 1/6.

## 12. Left undone

- **A2**, the E.3(ii) promotion — the last theorem-side residue, scoped but not attempted. E″'s cases (α)–(γ) already prove no *structural* argument can work, so any promotion must compare across partitions of n and lands back on Hypothesis (H). Its "505 branches" figure is v2-era and probably much smaller now; recount before proving.
- **A8(a)**, the n ≡ 11 (mod 24) anomaly — the only rung-B residue whose diagnostic did not move.
- **A8(b)**, residues 7 and 15 still transposing fused and tie columns, and §3.9.2 carrying two measurements of the same quantity under different window conventions.
- Every per-shape count in Part I is v2-era until the rebuild finishes; **A0** records that the repair migrates winners between census rows (232 of 1,295 changed shape), so these want re-deriving rather than recounting.
- A `brute_compare.py` run at n = 285 and 308 was started and did not finish.
- §3.8 is still 1,267 words and would take `####` cleanly if uniform granularity across §3 is wanted.
- **T4**'s remaining item, the Shparlinski prime-power transfer, needs the paper body and a human judgement about a proof's robustness.

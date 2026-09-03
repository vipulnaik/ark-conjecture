# Session log 13 — fresh-eyes critical pass on `notes` §§1–6, `ep`, `aod`, and the R1 scripts

*Scope: a cold read of `orbital-evasiveness-notes.md` (intro and §§1–6, §§7+ skimmed), `enumeration-proof.md` (Parts 0–F in full, G–J glanced at), `arithmetic-of-density.md` (§§1–3.4, §5, §§6.1–6.8 closely; §§3.5–3.8, §4, §6.9 skimmed), `pending-checks.md` front matter and T1/T8, and every shipped script that could be run against the shipped table and ladder output. Every finding below was reproduced by running code, not only by reading. The fixes are applied; this log is the record of what changed and why, so that none of it has to live in the documents themselves.*

---

## 1. Findings, and what was done about each

### 1.1 The ladder understated fused-plus-foreign families (the largest finding)

**What was wrong.** `ladder_verify.py`'s S7 branch cut a fused class's twist by the primes of F_mid, via `STRIP[c]`. That cut is the projection-versus-subgroup error the rest of the framework is careful about: the block-permutation image is a *quotient* of the cyclic layer, and an entangled generator supplies rotation and full twist together at any F_mid. The script's own comment said as much and retained the cut as "safe in this file's direction."

**Why it mattered more than the comment allowed.** Understating a family lowers a max over families, so every reported floor stayed a valid lower bound — which is exactly why it failed silently. It bit hardest at even F with c ≡ 1 (mod 4), where the strip removes the 2 from c − 1 and halves the intra term, and that is precisely the shape that wins at the arithmetically weakest n. Measured against the computed table: the ladder fell short of B(n) at **16 of the 37 joined values**, by up to **1.81×** (n = 1235, ladder 0.07094 against B = 0.12851). Every shortfall was a fused class at F ≥ 3 beside a foreign prime.

**What it invalidated, and what it did not.** The global minimum 175813/3804661 at n = 2759 and its uniqueness are untouched — that value is tight against B, and every other entry can only rise. What was invalidated is every statement about the *shape* of the low tail: worklist membership, the decade minima of `aod` §5.2, the "next-lowest entry 0.04801 at n = 11183", and the ten-lowest-entries list. Rescored at the full twist, n = 11183 reaches at least 0.0657 (`6x1171 + 1x4157*`), 6275 → 0.0665, 10595 → 0.0679, 3503 → 0.0615; of the 1,147 worklist entries below 4·10⁴, 771 rise and 31 leave the worklist entirely.

**Fixed.** `ladder_verify.py` now uses the full c − 1 with only the foreign prime r stripped (Lemma C's coupling, a genuine subgroup condition). Verified: the patched `achieved()` equals B(n) at **all 37** joined values and exceeds it at none. The `aod` §5.1 box was rewritten around this, and the ladder-dependent figures in §5 and §5.2 carry ⟦PENDING-LADDER-RERUN⟧ — the 10⁶ run has not been redone and `--resume` will correctly refuse, the source hash having changed.

**Detection.** `validate_table_v3.py`'s ladder-gap check was an INFO that printed the refutation while the battery reported 24 PASS / 0 FAIL. It is now a **FAIL** when any joined value has ladder < B, with the reasoning in its `expect` string: an understating ladder is sound, so this is the only place the regression is visible.

### 1.2 `fb_common.py` condition (4) bounded the wrong quantity (T3)

**What was wrong.** The collapse needs B_refined(n) = B_safe(n), which reduces to: no share-carrying configuration has its **SAFE score** ≥ B_safe(n). SAFE credits a p-characteristic part the flat F·C(c,2). Condition (4) instead capped it by F·orb(c, dmax) with the foreign prime stripped — a *smaller* number, so it could reject a configuration whose SAFE score does reach B. Anti-permissive, and invisible in the output, which is the one error class that file cannot detect from its own results. The same cap sat in `single_part_ok` and `multi_part_ok`.

The strip is not wrong; it answers a different question. It bounds the minimum intra-orbital an actual *group* of that shape realises — Part E′'s leftover twist cap — which yields μ(n) = B_refined(n), not B_refined = B_safe. It is also only valid for a ΓL(1)-type stabiliser, Part B's extraspecial group being the counterexample. E′'s prose slid between the two targets without noticing the quantity changed.

**Fixed.** All three sites now use the flat F·C(c,2); the strip survives only as an unread diagnostic (`_record_strip_diagnostic`). **Measured: `fallback_cert.py --no-theorems` still returns 0 candidates at all 2,187 rows.** So the in-range collapse rests on neither Lemma C, nor Corollary C′, nor J0a — a strictly smaller trusted base than the strip-gated version had. The banners, `ep`'s certificate description, the leftover twist lemma box, the E″ headline and the two extreme instances (n = 50,817 and 89,697) were all rescoped accordingly: those two are settled for μ = B_refined by the lemma, and for B_refined = B_safe only by the search, which has not been measured at them.

### 1.2a What the rescoping costs at scale: two named values, measured

`wide_cert.py` at NMAX = 10⁵ was rerun under the flat-cap conditions, and the coverage moves from the reported **100.00%** to **90,297 of 90,299 (99.998%)**. The residue is two values:

| n | (c, r) | s | leftover |
|---|---|---|---|
| 50,817 | (20327, 10163) | 2 | L = c |
| 89,697 | (35879, 17939) | 2 | L = c |

Both are the shape E″ names as the one that resists longest, and both were previously closed by the strip-based conditions — which is exactly the substitution §1.2 identifies: the strip bounds what a *group* of that shape realises, so the closure proved μ = B_refined there and not B_refined = B_safe. **The 100.00% was an artefact of testing the wrong quantity rather than a stronger result.** They are not counterexamples; a surviving candidate means the necessary conditions do not exclude the shape at B_lo, and settling them needs the true B(n), far past the computed table. E.3(ii) does not reach them by its own terms, the re-reading being unavailable at L = c, so this is the L > 0 case of the global promotion with two named instances rather than a description.

Under `--no-theorems` the count is 90,292 — five more, all bare pairs (L = 0, c = 2r+1 a safe prime) at n = 32,398, 35,098, 62,368, 86,848 and 99,160. Verified directly by running `pair_candidates` at all seven values in both modes: the five vanish with theorems on and the two do not. **So the two modes do not agree at this NMAX, and the script should not claim they will.** That disagreement is E.3(ii) doing real work — the only place any Part E′ clause fires in `wide_cert.py`, since the foreign-cap filter removes the s = 1 and s = 3 branches before the s-branch dispatch sees them. Any difference beyond those five is a defect to chase. `wide_cert.py`'s banners, `ep`'s E″ result box and two-extreme-instances paragraph, `ep`'s two "the modes agree trivially" remarks, and `pending-checks.md`'s run table were all corrected accordingly.

### 1.2b The two residual values were a missing family in B_lo, and both now close

Neither needs the enumerator, and neither needs B(n). Each candidate dies on condition (3) as soon as B exceeds the foreign block's own cap — orb(10163, 5081) = 51,638,203 and orb(17939, 8969) = 160,894,891, i.e. densities **0.039994** and **0.039996**, a hair under 1/25. So the question was "does this n clear the conjectured floor", not "what is B(n)".

It does, easily. `wide_cert.py`'s B_lo scored the three-part shape **unfused** only — census S4, which wins nowhere — omitting the fused F = 2 rung that is the odd-n carrier and worth a factor of two on the intra term. Adding it gives

| n | B_lo before | δ | B_lo after | δ | witness |
|---|---|---|---|---|---|
| 50,817 | 50,567,357 | 0.0392 | 221,369,762 | **0.1715** | `2x14879 + 21059*` |
| 89,697 | 148,031,501 | 0.0368 | 681,635,503 | **0.1694** | `2x26387 + 36923*` |

At those bounds both candidate lists are empty and s_max drops from 2 to 1. This is the same missing shape, for the same reason, as the S7 branch `ladder_verify.py` used to cut (§1.1) — the third script found carrying it.

**The trap inside the fix is the reusable part.** A first attempt added the family but anchored its scan at n/3, the *unfused* balance point. The fused rung balances at x\* = (2 − √2)/2 = 0.29289, and `near()` keeps only the 60 prime powers nearest the anchor, so at n = 50,817 the winning c = 14,879 sits 2,060 away from n/3 — far outside the window. The family was present in the code, contributed zero, and said nothing about it: B_lo came back byte-identical and the two values stayed open. Corrected anchor in `fused_three_part_lo`, with the reasoning in its docstring.

**Verified on a subsample rather than by a full rerun** (the 10⁵ run is ~10 minutes of pass 1 plus ~2 of pass 2, and is left for a machine that can hold a background job):

- the two values, full pass-2 scan at the corrected B_lo: **0 candidates each**;
- **soundness join over all 2,187 table rows: B_lo ≤ B(n) everywhere, 0 violations**, with B_lo = B at 1,944 of them (88.9%). That join is the analogue of `validate_table_v3.py --ladder` and is what would catch an over-credited B_lo, which is the anti-permissive direction;
- the five bare pairs are even n, so the odd-n rung leaves them unchanged, as expected — they are E.3(ii)'s business;
- the previously weakest value n = 26,015 rises from δ_lo 0.0200 to 0.0306, so the "weakest B_lo density / permitted s ≤ 6" figures will move and are tagged for requoting.

### 1.3 Theorem 3.1's stated reason for its own soundness was backwards

The DUP block in both `notes` and `ep` said the non-ΓL(1) stabiliser and the 2-homogeneous permuter "both exceed rather than fall short, so μ(n) ≤ B_safe(n) … untouched." Exceeding is the **dangerous** direction: a group whose orbital exceeds the scored term is one the score may under-count. What actually protects the bound is the flat cap — F·C(c,2) bounds any point stabiliser, s_i s_j bounds any pair of orbits — together with coeff·c² ≥ F·C(c,2), which is why the within-class cross term never binds. Part E's pitfall box already had the correct reason; the theorem statement now says the same thing.

### 1.4 F.4's cofactor bound sharpens for free

The proof bounds r − 1 ≤ n − 1. But a configuration carrying a foreign part carries a second part too, of support > √(δ₀n(n−1)), so r ≤ n − √(δ₀n(n−1)) and dividing the same inequality by Q rather than bounding r ≤ n gives

> **(r − 1)/Q ≤ D(δ₀) := 2(1 − √δ₀)²/δ₀.**

A strict improvement at every δ₀ — 25.4 against 42 at the table floor, 32 against 50 at 1/25, 14.9 against 28 at the asymptotic ceiling — using nothing beyond Proposition F.1's own part-size bound, which the proof has already invoked. Against the measured maximum cofactor of 12 the slack becomes ≈ 2.1 rather than ≈ 3.5, and the round trip returns D ≤ 630 rather than 700. The per-row form 2F·r(r−1)/(δn(n−1)) is *attained* wherever the foreign term binds (12.0 at n = 2759), so it is the right form to measure against.

`converse_check.py` now reports both forms; both hold with **zero violations** across the table. All quotations of the constant in `ep` F.4, `aod` §§6.7–6.8 and `pending-checks.md` T8 were updated, and the round-trip figures recomputed.

### 1.5 A semantic error in `notes` §5

"Γ having bottom 𝔽_c acting **diagonally** on both c-blocks." The bottom p-group must be 𝔽_c² with **independent** translations; the *twist* is what is diagonal. Diagonal translations across two matching blocks are exactly what Lemma D2 uses to kill a fused foreign class — they leave the same-position pairs invariant, collapsing the between-block class from c² to c — so the sentence as written scores the odd-n family at a class of size c and loses the shape. Theorem 2.1, Part E and `aod` §6.2 all had it right. Fixed, with a note saying why the direction matters.

### 1.6 Stale readings that contradicted their own documents

- **`ep` S7-vs-S5 box** still said the cyclic-layer swap "competes with the twist, so the twist is cut to the odd part of c − 1 and the gain depends on c mod 8" — the pre-entangled-correction reading, contradicting `aod` §3.2.3 and the rest of `ep`. Rewritten to the entangled-generator account.
- **`aod` §2.1's opening** derived "F ≥ q ≥ 2", "ω(n) ≤ 2" and "take F to be the smallest prime-power cofactor", all superseded two paragraphs before the same section lists the ω(n) = 3 winners. Replaced by the Q(n) form that makes δ_S2 an identity.
- **`aod` §6.6's tie bullet** claimed classes 7 and 15 admit no collapse margin because cap_B(1/4) = cap_C(1/2). Under the mod-12 table their ceiling is rung B at η = 1/2, so the margin to the next rung down (cap₄(1) = 1/9) is ε < 0.0139 — *wider* than at class 11, not absent. §3.3.5 already said that identity is not a tie condition.
- **`validate_table_v3.py`'s mod-24 expect string** still read "0.11111 at 7,15 … the last three take F = 4", contradicting the mod-12 table printed beside it.
- **`a18_verify.py`'s** pass-1 label and threshold docstring referred to the superseded linear form of D2 and presented a deliberately weak δ as if it were the current floor.

### 1.7 Census counts were taken over the file rather than the prefix

The table is a contiguous prefix plus one worklist row (n = 2759), and the tail is selected *by low ladder score*, so it skews every share. `validate_table_v3.py` classified all 2,187 rows, which is where the documents' 396 (S7 at F = 2) and 1,444 foreign blocks came from against the prefix's 395 and 1,443 — an off-by-one that looks exactly like a stale figure and is invisible to a figure check, since nothing records which population was intended. The validator now scopes census and odd-share counts through a new `contiguous_prefix()` (first gap > 10, matching `converse_check.py`'s frontier detection), and the affected counts in both census tables, `aod` §3.2.5 and `ep` Part I were corrected: 395, c mod 8 = {1: 92, 3: 100, 5: 101, 7: 96}, 193 at c ≡ 1 (mod 4), 49.6% of odd-c rows.

### 1.8 Smaller letter-level corrections

- `ep` Part 0: "`ladder_verify.py`'s S7 loop runs over F ∈ {3, 9, 5, 25, 7}" — `FSET` is 3…12, 16, 25.
- `aod` §6.5: "Fused winners are 39.6% of the computed table" — matches no computable population; the prefix gives 61.0% for any F > 1, or 27.0% for fused-plus-foreign.
- `ep` C.2: a floor quoted without its range, which `check_doc_figures.py` flags once n = 2759 is in the file.

---

## 2. New invariants in `check_doc_figures.py`

Two staleness classes that are prose rather than figures, so nothing else sees them:

- **I6** — F.4's cofactor bound quoted as 2/δ₀ where D(δ₀) is meant. Both forms are *true*, which is why a figure check cannot catch it: the crude one reads as correct and merely understates the result. Restricted to sentences about F.4's own bound, since q-pinning's u ≤ 2/δ is a different derivation and firing there would train the reader to ignore the invariant.
- **I7** — a winner count with no scope word near it. The failure is an off-by-a-few indistinguishable from a stale figure, which is exactly how the 396 was missed.

Both clear on the current documents, as do I1–I5.

---

## 3. Runs, and their current status

| run | result |
|---|---|
| `validate_table_v3.py --ladder` | 24 PASS, **1 FAIL** (ladder gap, against the pre-fix worklist — expected until R7 is rerun) |
| `fallback_cert.py` | 0 candidates; theorem-settled 1,940/2,187; s-branches 2,195/2,442 |
| `fallback_cert.py --no-theorems` | **0 candidates under the flat caps**, 0/2,187 settled by theorem |
| `converse_check.py` | 0 violations on all three inequalities in both the sharp and crude forms; max cofactor 12; slack 2.1 sharp / 3.5 crude |
| `a18_verify.py` | all passes; worst UB/B 0.8276 at n = 56 |
| `audit_fmid.py` | 461 rows screened, 0 hits, 0 unscreened |
| `ceiling_rederive.py --mod12 --runners` | six classes reproduce their constants from below (0.9994–0.9999); all mod-12 pairs agree; class-11 runner-up is the F = 2 / F = 6 tie in both halves |
| `check_doc_figures.py` | I1–I7 clear; one EXPIRED finding, which is the prefix/tail scoping now stated in the prose |
| `wide_cert.py 100000` | 90,297 of 90,299 under the flat caps and the shipped B_lo; both residues since closed by the fused rung. Full rerun owed |
| `wide_cert.py 100000 --no-theorems` | 90,292 — five bare pairs more, the expected E.3(ii) difference |
| B_lo join against the table | 0 of 2,187 rows have B_lo > B; equal at 1,944 |

**Owed:** `ladder_verify.py 1000000` under the corrected scoring, which is what discharges every ⟦PENDING-LADDER-RERUN⟧ tag and restores the ladder-gap check to PASS.

---

## 3a. The generalization notes: fixes applied

*A separate pass over `solvable-relaxation.md`, `monotone-transitive-note.md`, `chiral-graph-properties.md`, `general-k-note.md` and `three-uniform-note.md` (the last read in outline plus §§1, 7–10 only). Five fixes, two of them substantive.*

**A definitional error in `solvable-relaxation.md`.** §0 defined μ_solv over "all solvable **transitive** groups of degree n", then §§2–3½ maximise over partitions of n into several orbits — every optimal configuration in the document is intransitive, so the definition contradicted its own contents. Corrected to "all solvable groups of degree n", matching the Oliver side, where Part A admits intransitive Γ from the start.

**An overstatement in `general-k-note.md` Proposition 1, which is load-bearing at k ≥ 3.** The proof sketch asserted that Lemma B "forces a block's group into AΓL(1, c)". It does not — Lemma B constrains which blocks and twists are admissible, and Part B's own 3^{1+2} ≤ GL(3, 7) is an Oliver-admissible stabiliser outside ΓL(1, 7³) beating orb(c, d) by a factor 9 at k = 2. `three-uniform-note.md` §9.3 separates the two questions; this note conflated them.

**Why the conflation is harmless at k = 2 and not at k ≥ 3.** At k = 2 the SAFE score caps a matching class flatly at F·C(c,2), which bounds any point stabiliser whatever, so a non-semilinear block cannot falsify the upper bound — this is the same flat-cap reasoning as §1.2 and §1.3, in a third guise. At k ≥ 3 there is no such cap: C(c, k) is far above the truth and the whole content of m\*_k = O(n² log n) is that |Γ_B| is small. So the k ≥ 3 upper bound genuinely assumes semilinearity.

**The assumption is weaker than J0a as usually stated, and reducible.** What is needed is not "every Oliver block stabiliser is semilinear" (false) but **(J0a′)**: a non-semilinear Oliver-admissible H ≤ GL(a, p) never wins the minimum k-orbit. A component argument should give it uniformly in k — C irreducible ⟹ centraliser is a field ⟹ H semilinear; C reducible with m > 1 homogeneous components ⟹ a k-set inside one component has a short orbit; m = 1 ⟹ H = C·Q with Q primitive irreducible, bounding |Γ_B| below AΓL(1, c)'s c² log c. Every branch is arity-free. **This is the one item that would simultaneously retire the last k = 2 dependency (E.3(i) at a ≥ 2), make Proposition 1 true as stated, and turn the k ≥ 3 upper bound into a theorem.** Stated as a box in §1 with the §1 status row scoped accordingly.

**The chain's cost was priced only in the conditional constant.** `solvable-relaxation.md` §4's table gives 2.390 in the worst class, which is the whole story for the conditional constants and none of it for unconditional statements. The relaxation's parts are independent, so any number of orbits is admissible and §3½'s floors are what three and four parts buy; the chain forbids that — matching parts share p, foreign parts are distinct primes ≡ 1 mod a power of the same q, twist confined to one cyclic layer — so **every Oliver shape with density bounded below is binary in the additive variable, and a ternary shape does not exist at all**. That is the structural reason the relaxed problem has proved floors of 1/9 and 1/16 and the constrained one has none, and why Oliver-via-μ stalls at binary-Goldbach strength. Added to §4 as a third charge and reflected in §5's headline. *Stated carefully: three-part shapes win nowhere in either problem, so this is about the ternary shape's availability as a fallback — what an unconditional theorem needs and an optimum never uses.* §3½'s citation note was sharpened to match, those floors now being the sharpest thing in the document.

**n = 5 is closed for chiral properties, by a search already run in another note.** A chiral graph property on 5 vertices is exactly a monotone A₅-invariant family on the 10 pairs — which is T(10,7), the first group where `monotone-transitive-note.md` §3's criterion fails, and whose invariant monotone properties that note enumerates exhaustively: 3,176 of them, 112 with χ = 1, **0 non-evasive**. Since non-evasive ⟹ ℤ-acyclic ⟹ χ = 1, that is complete, and it subsumes the ℝP² Hamiltonian-cycle candidate (ℚ-acyclic with H̃₁ = ℤ/2 is not ℤ-acyclic). **The chiral frontier is therefore n = 13.** Cross-references added in both directions; neither note had noticed it was answering the other's question.

**Θ(n²) → Ω(n²) and O(n² log n)** in both k-notes: the Galois gain is the least prime divisor of a, which is unbounded, and §6's own c = 32 case realises a gain of 5. The lower bound is what the evasiveness statement uses and is clean; the log rides on the upper bound.

## 4. Not examined

Left untouched by this pass, and unverified by it: `notes` §§7–11 and appendices; `aod` §§3.5–3.8, §4, §6.9; `ep` Parts G–J; `verification-lessons.md`; `literature-findings.md` beyond its headers; the GAP scripts. `wide_cert.py`'s B_lo families were partly examined — the missing fused rung was found and fixed (§1.2b) — but `two_part_lo`, `fused_lo`, the menu top-up and the **share-pair guard** were not. The guard is the one that matters: it exists because an over-credited B_lo is anti-permissive, feeding the s_max and foreign-cap filters and dropping candidates silently, and that half remains unexercised. It is the natural next item after T3. Nothing in the deferred material was needed for the findings above, but the B_lo families named above are now the least examined part of the certificate chain and are the natural next item after T3.

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

### 1.1a The ladder rerun, and what it settled

`ladder_verify.py` was rerun to 10⁶ under the corrected scoring (full twist on the S7 branch, foreign prime still stripped). The floor is untouched and the tail is materially different, which is exactly the split §1.1 predicted.

| | pre-fix (v9) | corrected (v10) |
|---|---|---|
| worklist entries | 45,390 | **44,091** |
| global minimum | 0.04621 at n = 2759 | **unchanged** |
| joined against μ table | 37, short at 16 (worst ×1.81) | **28, tight at all 28** |
| entries below 0.05 | 7 | **2** (2759, 2183) |
| [10², 10³) | 0.05703 at 527 | 0.05703 at 527 |
| [10³, 10⁴) | 0.04621 at 2759 | 0.04621 at 2759 |
| [10⁴, 10⁵) | 0.04801 at 11183 | **0.05829 at 22139** |
| [10⁵, 10⁶] | 0.05603 at 173627 | **0.06391 at 118703** |

**"One decade wide" is now a statement about δ rather than about the scan.** The decade minima rise monotonically on both sides of the binding one, every non-binding decade clears 0.057, and at the binding value the ladder equals B(2759) = 175,813 — so that decade minimum *is* δ, not a bound on it. Under the cut, [10⁴, 10⁵) reported 0.04801 and the descent looked two decades wide; the difference was entirely the understated fused-plus-foreign families.

**The low tail collapsed from seven entries below 0.05 to two**, both already in the μ table with B equal to the ladder's own score. So no further exact B below 10⁶ can move the floor — which retires the "ten lowest entries" worklist as a research target rather than requoting it. An independent adaptive `mu_enumerate_v3.py` run at threshold 0.05 returns the same two floor-lowering values and the same global minimum, so the two engines agree on the tail as well as the floor.

**`validate_table_v3.py --ladder` now passes** (25 PASS / 0 FAIL), which is the check §1.1 converted from INFO to FAIL for exactly this purpose: it failed against v9 and passes against v10, so the conversion did the job it was made for.

Figures updated across `aod` §3.5 (decade table, mod-24 split 21,711 / 22,378, per-class min-ratio spread 0.327–0.693 keyed mod 12, and the saturation claim now stated with its argmins), `aod` §5/§5.1/§5.2, `ep`'s status header, and `pending-checks.md` R7. All ⟦PENDING-LADDER-RERUN⟧ tags are retired; one ⟦PENDING-REBUILD⟧ in §3.5 was resolved by the run's own per-class state rather than deferred again.

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

## 3b. J0a: wrapped up at k = 2, reduced at k ≥ 3

*A consolidation pass rather than a new finding — J0a was scattered across five documents in three different states, and the fixes of §1.2 had changed its status without anyone updating the entries.*

**The disposition, stated once.** J0a asks whether a matching block's stabiliser lies in the field's multiplicative group, when in principle it can be any irreducible subgroup of GL(a, p). It splits three ways:

1. **Neither direction of μ(n) = B(n) touches it.** The upper bound is the flat cap — F·C(c,2) within a class, sᵢsⱼ between orbits — and both are counting bounds on the pair set, not statements about the group, so μ ≤ B_safe holds whatever the stabiliser is. The lower bound is Part E's explicit construction, which uses field twists and which a richer stabiliser could only supplement. **So every computed value is J0a-free**, and after §1.2 so is the collapse over the certified range: flat caps plus `--no-theorems` gives an empty candidate list, so neither Lemma C, nor Corollary C′, nor J0a enters the per-n proof.
2. **At a fixed twist order, a non-field stabiliser cannot beat the field one** — orbit–stabiliser bounds any orbit by |H|, and the field subgroup of that order is semiregular, attaining the bound everywhere at once. This is T2, and it is a proof.
3. **A non-field stabiliser of *larger* order is the residue**, which (2) does not reach: 3^{1+2} ≤ GL(3, 7) has order 27, and 27 ∤ 342 = 7³ − 1. **It bears on exactly one clause in the k = 2 documents** — E.3(i)'s "worth at most c to any actual group", which reads Lemma C on a block at a ≥ 2. That clause is theorem-side; the certificates never invoke it, and the branch is base-3 repunit primes, three values of c below 4×10⁶.

**So the honest one-line status is: closed for every computed value and for the certified collapse; open in one theorem-side clause governing statements about all n.** That is a stronger position than any of the five documents recorded — three said "largely discharged" on the strength of T2 alone, which is the weaker of the two arguments and does not reach case (3).

**What changed in the files.** `enumeration-proof.md`'s gap-inventory entry rewritten around the flat cap with the three cases separated and (3) pinned to E.3(i); a caveat added at E.3(i) itself, which is now the only clause in that document assuming semilinearity. `pending-checks.md` item 5 and T2 updated the same way — and T2's strip measurement (42 decisions, none at a ≥ 2) is marked **historical**, since the cap it measured no longer exists: keeping it as a live discharge would protect a condition the code does not contain. The reason the old cap was doubly exposed — Corollary C′'s Frobenius step *and* the orb formula itself — is kept as the reason not to reinstate it.

**At k ≥ 3 case (3) is load-bearing rather than incidental**, there being no flat cap: C(c, k) sits far above the truth and the whole content of m\*_k = O(n² log n) is that the block group is small. `general-k-note.md` §1 carries **(J0a′)** — a non-semilinear Oliver-admissible block group never wins the minimum k-orbit — with a component-argument reduction uniform in k. **Proving it closes case (3) at every arity at once, k = 2's E.3(i) included**, which makes it the one item worth doing here rather than five.

**Not done, and it is the substance:** J0a′ itself. The reduction is a sketch, and its m = 1 branch (H = C·Q with Q primitive irreducible) needs the primitivity bound stated properly before it is cited.

> **A process note.** An edit to `enumeration-proof.md` truncated the file to zero bytes — a Python string containing a surrogate pair raised `UnicodeEncodeError` *after* `open(P, 'w')` had already truncated it. Recovered intact from the outputs copy, and subsequent edits were written to a temporary file and renamed. Worth keeping the pattern: any edit helper that opens for writing before serialising can destroy the file it is editing, and the failure looks like an unrelated encoding error.

## 3c. The short note and its bridge

*A review pass over `mu-theta-n2-note.md`, its LaTeX twin, and `note-to-framework-bridge.md`. Two errors in the note, one stale passage and one over-tease in the bridge, and six bridging omissions. Everything numerical in both documents was recomputed and checks out: the mod-12 admissibility table cell by cell, both mechanisms of the ℓ ≤ 3 analysis, C₀ = 0.635166… and 4·(9/8)·C₀ = 2.858249, both Oliver chains and their orbitals, the corner minimisation giving 1/300, the n = 12 and n = 17 verification data, δ(6) = 0.400 and δ(12) = 0.2727, the 16× multiple, and the "smallest worklist n is 323" claim against the v10 ladder.*

**Error 1: the note misstated Oliver's theorem.** It said χ(Δ(P)^Γ) = 1; the theorem gives χ ≡ 1 (mod q), with equality when the top of the chain is trivial. The argument is unaffected — 0 ≢ 1 (mod q) for every prime q — but this is the one theorem the note cites, and `monotone-transitive-note.md` §1 had the congruence form right, so the two documents disagreed. Fixed in both twins.

**Error 2: the note stated a lower bound as a value.** The within-B orbital is written "rt/2 if t is even and rt if t is odd", and then rt/2 is used in both displayed m\* formulas with an equality sign. But t = q is an odd prime at every n the hypothesis covers — t even forces q = 2 and r = 2d + 1 ≤ 25, excluded by r ≥ n/5 — so the value is always rt, and the note's own verification data contradicted its formula (n = 12, t = 3, B-orbital 21 = rt, not 10.5). The bridge §4.3 knew this and called it deliberate crudeness; the note presented it as fact. Fixed by stating the value as rt, changing both displays to ≥, and labelling the halving a deliberate under-count worth a factor 2 (δ₀ = 1/175 rather than 1/350). **The constant was left at 1/350 on purpose** — the note's role is to be easy to check, and every downstream figure quotes 1/350.

*A hazard of a kind §0 of the bridge did not yet name, now added there.* A bridge recording a decision does not license the note to state it as a fact, and no rerun catches this class of defect: rt/2 is a true lower bound, so every constant downstream of it is correct and every numerical check passes.

**Minor in the note:** "hence primitivity, hence prime-power degree" needs solvability (which Oliver groups have) — one clause, both twins.

**Stale in the bridge.** §3's condition-4/Lemma-C paragraph said the framework *prices* shares, with "a strip licensed exactly where that cap already rules the configuration out". After §1.2's flat-cap change that describes nothing: the certificates cap at F·C(c,2) with no strip, and Lemma C survives only on the construction side (the ladder's foreign-prime strip, which only lowers a score) and in E.3(i). Rewritten — the framework now *proves* share-carrying configurations never win, which is a better bridging statement than the pricing one it replaced.

**Over-tease in the bridge.** §4b's higher-arity bullet claimed Θ(n²) and a "complete" stabiliser analysis. Corrected to Ω(n²) with O(n² log n) above, and scoped: the no-new-mechanism point is safe to tease, the matching upper bound assumes J0a′ (§3b).

**Six bridging omissions, now recorded.** The Oliver-theorem disagreement itself; the note-states-vs-bridge-decides defect above; the singular-series constant as a cross-check between the two documents (the only place the note's number theory meets the framework's, and it agrees); Proposition F.1/F.3's part-count bound, which makes the note's family complete in part count and incomplete only in fusion — so the gap is one-dimensional; what the 0.0462 actually rests on (the scan can only understate, the fused rung's full twist is realised by an entangled generator and was verified, and the figure survived the v10 rerun that moved 1,299 values and two decade minima, because an understating scan cannot move a minimum already attained); and the note's own ⌊C(n,2)/2⌋ ceiling, which the bridge had described as merely the trivial bound.

**Not done.** The bridge's "deliberate omission" box still keeps F.4 out pending T8, and I did not revisit that call — T8's content is B′, which now has three independent re-derivations, so the trigger looks close to met, and if it is, the box's own two-sentence draft belongs in §5 of the note with the sharpened D(δ₀) = 2(1 − √δ₀)²/δ₀. That is a judgement about what to circulate, not a fix. I also could not verify the Runbo Li citation (arXiv:2508.18285); `literature-findings.md` records an open question about whether that is the same author cited elsewhere, and the note inherits it.

## 3d. The two analytic notes

*A second reading of `sp-to-floor.md` and `shparlinski-constants.md` — the first either has had. Both hold up: no conclusion in either breaks. What follows is one gap in a hypothesis, several letter-level errors, and three places where the framework moved after they were written.*

**Verified independently, and clean:** in `sp-to-floor.md`, the Reduction Lemma's numerical form, the window optimum and the identity 1/(√k + √(d/2))² = cap_k(2/d), the cross term never binding, the mod-4 and mod-3 pins and every cell of the (k,d) grid including (4,6) forced at class 11, the minor-arc Bessel/Parseval step, and §6.1's counterexample, which is the sharpest thing in either document. In `shparlinski-constants.md`, the §2.1–2.3 constant chase, §3(b)'s sub-linear cap, §5's γ-threshold and table, the μ(10) = 20 cross-check against p²k = 50 > 22, and the 0.55% proper-prime-power share (recomputed: 0.552%).

**The one gap: a hypothesis asserted to hold automatically that does not.** `sp-to-floor.md`'s Reduction Lemma needs gcd(k(p−1), r) = 1 for the cyclic layer and says this "holds automatically in our windows since r > k(p−1)". In the optimised windows r ≈ αn is the *smaller* summand, so r < k(p−1) throughout. The proof survives — r prime with r > k makes r | k(p−1) force r | p−1, i.e. O(1) values of p per n, which §4.3 already excludes with the other degenerate cases — but the parenthetical is wrong, and it is the same condition as clause 4 of (BCG_{1/5}) in the short note, handled there by exclusion. Corrected to say so.

**A wrong explanation of a right conclusion.** The Local Lemma says higher 2-powers do not bind because "kp already ranges over enough classes". At k = 4, 4p ≡ 4 (mod 8) for every odd p — one class, and k = 4 is the one k where the question matters. Solvability mod 8 comes from Q's freedom, not from kp. The computational check at m ∈ {8, 16} covers the conclusion; only the reason was wrong.

**A formula that generalises wrongly from the cases tested.** `shparlinski-constants.md` §1.5 says the cross-block orbitals "are p²·C(k,2) in one orbit". True for k ≤ 3 — every pair enumerated — and false from k = 4, where C_k has ⌊k/2⌋ orbits on 2-subsets and the smallest is antipodal, (k/2)p². `sp-to-floor.md` §2 has this right. Safe in direction, but Theorem 2's regime has k ≈ n^{1−γ} large, so the wrong formula is the one that would be evaluated there. Flagged in §1.5 and again in §9's construction caveat, which now also records the gcd condition — in that regime it excludes a thin set of r rather than an O(1) set of p, the reverse of `sp-to-floor.md`'s situation, because k is unbounded.

**Stale against F.4's sharpening.** §6 derives (r−1)/q ≤ 2/δ₀ and calls it "exactly F.4's branch (b)"; §8.2 quotes D ≤ 700. F.4 now gives D(δ₀) = 2(1−√δ₀)²/δ₀ — and the sharpening comes from this document's own thesis, applied on the other summand: the companion has support > √(δ₀n(n−1)), so r ≤ n − √(δ₀n(n−1)) rather than r ≤ n. Added as a box in §6, with 630 replacing 700 in §8.2. §1.5's "F.4 is tight and cannot be sharpened" is now scoped to the foreign term, which is what it was about.

**A measured constant presented as an asymptotic one.** §7's "S₁₂: density ≈ 2.67/log²x" is the cumulative measurement at x = 2·10⁶ (recomputed: 2.668, from 25,353 primes), inflated by lower-order terms — the window [x/2, x] already gives 2.33 and the Bateman–Horn constant is ≈ 2. Nothing downstream depends on which; §7's point is "two logarithms short". Now labelled.

**One ⟦PENDING-RERUN⟧ cleared by running it.** The closed form δ(k,d) = (√k + √(d/2))⁻² was grid-checked against the *corrected* objective at all nine (k,d) pairs: agreement to grid resolution (relative error 4·10⁻⁴ to 2·10⁻³ at 1200²), and the optimising window matches the closed-form balance point to three places at every pair. The class-11 margin is confirmed on the grid too — (4,6) at 0.0717 against 0.0669 for both (6,4) and (2,12). The other tag, the end-to-end run at orb = rQ, needs the run and is left.

**A cross-reference worth having.** Three independent statements now say the difficulty sits in the companion clause rather than the shifted-prime input: the sumset cap of `shparlinski-constants.md` §3(b), the generic-set counterexample of `sp-to-floor.md` §6.1, and the absence of any ternary Oliver shape (§3a, priced by contrast in `solvable-relaxation.md`). Three different objects — a sieve, a circle-method hypothesis, a group-theoretic chain — one conclusion. Cross-referenced in both documents.

**Not done.** The Siegel–Walfisz major-arc assembly, the singular-series completion at non-squarefree q, the Vinogradov dilation lemma, and Balog–Sárközy's statement are still taken as the documents take them; the status lines now say the second reading covered the algebra and the numerics and not these.

## 3e. The small-degree documents

*A review of `small-degree-computation.md`, `small-degree-verification.md`, `ark_gap.g`'s Oliver predicate and emission logic, `consume_gap.py`'s dedup and selection, and the two logs. No error in either document's substance; one ambiguity, one closable gap, and three smaller items.*

**Verified independently:** `IsOliverTop` is sound, including the edge cases (N = G is always visited, so trivial top is never missed by iteration order; p-groups bypass to the strictly stronger Smith tag). The §2.4 t ≤ 4 table re-derives correctly, including that t = 2's "both in, union out" has χ = 2 and so is excluded at every prime, and the extra q = 2 option at t = 3. χ(M₁₀) = 45 − 630 + 3150 − 4725 + 945 = −1215 = −5·3⁵. The dedup key (canonical orbital partition × tag) is the right invariant, since Δ_P^Γ depends only on the partition. The battery arithmetic matches the logs.

**One ambiguity, wrongly escalated on first pass.** §§1.1 and 4.3 cite Adamaszek's "unique nonevasive property at 5 vertices". I called this an error contradicting KSS; it is not — the sentence says "property", not "monotone property", and Adamaszek's is the unique nontrivial nonevasive property up to the obvious symmetries, monotonicity not assumed. What misleads is context: §2.1 defines "property" to mean monotone graph property and never redefines it, the other two entries in §4.3's list are monotone-ARK results, and n = 5 is prime. Now qualified in both places, with the more useful point added: **this reproduction checks `adversary.py`, not the CSP** — it is the only entry in that list exercising the decision-tree side, on an input where the group conditions do not apply, and the only one whose success is consistent with ARK rather than an instance of it.

**The subdirect-product hole is closable by construction, cheaply.** §8.5 and verification item 5a park it as a research question because the `FULL` stage's `ConjugacyClassesSubgroups(S_N)` is expensive — and item 5b separately flags that this call was never confirmed to finish at N = 10. But every conjugacy class of subgroups settles it outright (a proper subdirect product is a subgroup like any other), and **TomLib ships precomputed tables of marks for the symmetric groups in this range**, so `RepresentativeTom` returns a class representative with no subgroup computation. Implemented as stage `TOM` in `ark_gap.g`: off by default, logs the class count rather than predicting it, degrades with a message if the degree has no table. Running it closes 5a and moots 5b, since TOM's content is FULL's.

**Why that outranks the battery escalation.** It upgrades job (a) from "no enumerated group exceeds B(n)" to the exhaustive statement — at the only two degrees where μ is known by construction rather than classification — and it gives job (c) the complete condition set, which is the direction that can only help. Recorded as the highest value per unit effort in §10's list.

**The SAT question is the less useful of the two, and both documents can say so.** Every CSP solution so far, including the published one's canonical extension, has died to the global χ test — which is not expressible on the CSP variables (§3.7). So battery size governs "is the CSP SAT" while what stands between the pipeline and a result is "does any solution survive χ = 1". Boxed in §5.2 and cross-referenced from verification item 12, which measures the first question and should not be read as measuring progress toward a counterexample. The UNSAT direction still makes the measurement worth having.

**A possible proof that the lcm strengthening is worth nothing.** Item 6 has two zero counts of multi-prime tags and cannot tell "files predate the change" from "no such group exists". Sketch toward the second: two chains with tops q₁ ≠ q₂ over a shared bottom prime force H = Γ/O_p(Γ) to be a product of two normal cyclic subgroups of coprime index, hence cyclic, hence a **trivial top** — tag `0`, not a multi-prime tag. If it holds, the strengthening is provably worthless and retires on that basis rather than on a tag count. Filed as a sketch; the different-bottom-prime case is not done.

**Smaller items.** §1.3's solvable ceiling said "all solvable *transitive* groups" — the relaxation note is now defined over all solvable groups (§3a), and the ceiling holds for those. The Angel–Borja five types are quoted at second hand and the paper is not in `literature-findings.md`; §4.3 now says the run needs the primary source first, or it validates against a possibly mis-transcribed target. And **`ark_gap.g` now suffixes all three output filenames by degree**, which is the source-level fix for the collision that verification item 14 says has already cost two rounds — existing files still collide and want renaming by hand.

**Not examined:** `stage4_fast.py`, `smith.py`, `oliver_mu.py`, `ark_intersect.py`, `chi_test.py`, `probe_backbone.py`, `adversary.py`; `consume_gap.py`'s stage 3 beyond the selection logic; the pickles were not opened.

## 3f. Benchmarking the n = 10 full-battery run

*Goal: replace "cheap by n = 12 standards" with numbers, so the full 167-condition (or TOM-complete) CSP can be scheduled. Inputs available: the logs, the pickles, `consume_gap.py`; not available: `groups_out_10.txt`, so V for the full battery could not be computed and the VF2 cost was measured on a proxy.*

**What the logs already said.** The V = 1,242 stage 3 took 6.5 h wall (23:08 → 05:38), on an older row-based loop; the resumed session's seed line gives the pair accounting — 1,541,322 ordered pairs, 58,687 free containments, 1,105,476 invariant exclusions, hence **377,159 needing VF2 (24.5%)** before closure. Stage 4 found its first verified solution in 30–90 s across five runs at 5,500–7,200 nodes/s. §8.2's 0.54 pairs/s and 13.8 s/call are n = 12 figures and do not transfer.

**Measured here.** (i) VF2 monomorphism (`networkx` 3.6.1, `GraphMatcher.subgraph_is_monomorphic`) on 400 pairs of random 10-vertex graphs passing the same four invariant filters: **mean 64 ms**, median 0.4 ms, p90 184 ms, max 5.2 s. Check against the one real datum: 377,159 × 64 ms = 6.7 h single-threaded vs 6.5 h logged — agreement, possibly coincidental given the loop change. The same proxy at n = 12 gives 0.7 s mean against the real catalog's 13.8 s, so structured orbital unions are 5–20× harder than random graphs and the 64 ms should be read as a floor. (ii) The shipped `close()` on synthetic T/F: **0.7 s at V = 1,242, 4.1 s at 2,500, 15 s at 4,000** per steady-state pass — roughly V^2.6.

**The finding: closure, not VF2, is the wall at larger V.** `close()` runs once per batch and the batch was `max(64, 16·procs)` = 128 pairs. At V = 3,000 that is ~30 h of closure against 4.4 h of VF2 on 8 cores; at 4,000, 112 h against 7.8 h. Nobody had priced this because at V = 1,242 it is 0.5 h and invisible.

**Fixes to `consume_gap.py`.** `--batch` (default `max(2048, 256·procs)`), which removes the closure term at a cost of a few percent more VF2 calls; and `--estimate-only`, which runs stages 1–2 and the stage-3 inference, prints V, the pair count and projected hours from the model, and exits before any VF2 call. The checkpoint signature does not depend on either flag, so the estimate run's stage 1–2 checkpoints carry into the real run.

**The model and its table** are in `small-degree-computation.md` §8.2a: T_VF2 ≈ 0.064 s × fP/procs, T_closure ≈ (fP/B) × 0.7 s × (V/1242)^2.6, with f ≈ 0.22 and P = V(V−1). Totals on 8 cores at batch 2048: 0.8 h (V = 1,242), 2.2 h (2,000), 6.3 h (3,000), 15 h (4,000), 63 h (6,000).

**What remains unknown is V**, which depends on which orbital partitions the 167 conditions carry and cannot be read off anything in the documents — but it is seconds to compute, which is what `--estimate-only` is for. The run instructions in `small-degree-verification.md` now sequence: rename the colliding files, optionally run the TOM stage, size with `--estimate-only`, run, and read the first two batch-timing lines to recalibrate the per-call cost on the real catalog before trusting the projection.

**Then the real file arrived, and the numbers changed.** With `groups_out_10.txt` and `ark_intersect.py` in hand (plus a stub for the absent `oliver_mu`), `--estimate-only` ran to completion on the 167-condition battery in 8 minutes: **V = 2,902**, 8,418,702 ordered pairs, 170,572 free containments, 6,259,977 exclusions, **1,482,293 pairs (17.6%) needing VF2** after closure. The catalog is complement-closed with a palindromic edge histogram. And VF2 on 600 invariant-passing pairs of the *real* catalog: **mean 290 ms** (median 13 ms, p99 6 s, max 9.5 s) — the random-graph proxy was **4.5× too optimistic**, and the fact that the proxy matched the published 6.5 h wall time was a coincidence that would have mis-sized the job. Projection at 290 ms: **~16 h on 8 cores, ~9 h on 16, ~5 h on 32**, of which 1.3 h is serial closure; read as a lower estimate by ~1.5× since post-closure survivors skew hard. §8.2a and the run instructions rewritten with measured figures; the model constant in `consume_gap.py` updated; the stage-1/2 checkpoints exported so the 8-minute stage 2 need not be repeated.

**The TOM stage was then run, and it changed both the battery and a conclusion.** 1,593 subgroup classes of S₁₀ from the table of marks in 50 s, 1,111 emitted, **242 distinct conditions against the hand-built stages' 167**. Compared at the level the conditions depend on — orbital partition up to relabelling, via an isomorphism-invariant per-orbital signature — TOM carries **186 partitions to their 131, 55 new and 0 lost**, and merging the files yields the same 242 conditions as TOM alone. **The subdirect-product hole is closed at n = 10**, μ(10) = 20 becomes exhaustive rather than "over the enumerated groups", and the hand-built battery is formally redundant — though the two paths agreeing on 131 partitions is the only independent check `IsOliverTop` has, so the file is worth keeping. Sizing: V = 3,782, 2,565,218 of 14,299,742 pairs (17.9%) need VF2; **~27 h on 8 cores, ~14 h on 16, ~7.6 h on 32, at `--batch 8192`** — the 2048 default costs 4.4 h of serial closure at this V against 1.1 h at 8192.

**And it refuted §3e's own sketch.** I had argued that two usable top primes force a trivial top, hence tag `0`, hence the lcm strengthening of verification item 6 is vacuous — offered as a possible explanation for two independent zero counts of `+` tags. TOM emits **three groups tagged `2+3`**: T:658 and T:659 (order 36, t = 8 and 10) and T:990 (order 72, t = 7). `IsOliverTop` verified each prime against an actual normal subgroup, so χ ≡ 1 (mod 6) is justified at all three and **the strengthening is live**. The zero counts were an artefact of the hand-built stages — exactly the ambiguity item 6 flagged, resolved against my guess. Retracted in place, with the failing step named (the assertion that both cyclic parts centralise the intersection) and an instruction not to reconstruct the argument without checking it against T:658. **A follow-on to check:** `consume_gap.py` passes the tag through opaquely, but whether `stage4_fast.py` takes the lcm over a `+`-separated tag is unverified here, and if it takes the first prime the TOM battery runs weaker than it is.

**Tooling changes that came out of this.** `ark_gap.g` keeps `A,B,B2,C` as its default stage set rather than switching to `TOM`, for three reasons worth recording: TOM depends on a table of marks and TomLib stops at S₁₃, so a TOM default would silently emit nothing at N = 14 rather than fail; the two batteries agreeing is the only independent check `IsOliverTop` has; and the hand-built keys are readable (`B2:5x2:3.1` is the wreath attaining μ(10) = 20) where TOM's are table indices, which the attainer discussions are written against. Instead the stage set is selectable without editing (`ARK_STAGES=TOM`), and **the output filenames now carry the battery as well as the degree** — `groups_out_10.txt` vs `groups_out_10_tom.txt`, with `_full` for the FULL stage and `ARK_SUFFIX` to override — so the two batteries at one degree can no longer overwrite each other, which is the same failure the degree suffix fixed. A note fires if an exhaustive stage is combined with the hand-built ones. `consume_gap.py --infile` is now **required**: its old default named a file `ark_gap.g` no longer writes, so it would either error or pick up a stale file from the previous convention.

**A stale-emission-file trap, and a correction to §3f's own diagnosis.** Rerunning `ark_gap.g` with the default stages at both degrees produced a diff against the archived files that touches **the tag column only** — orbital maps byte-identical — turning `2` into `2+3` on 3 rows at n = 10 and 12 rows at n = 12.

- **n = 10:** `B:3+3+2+2:1.1.1.1` (order 36), `B:4+3+3:2.1.1` (36), `B:4+3+3:3.1.1` (72). Those are the same three orders as TOM's T:658/T:659/T:990, so **both batteries find the same three groups independently** — the cross-check the hand-built battery exists for, landing on the one question where it mattered.
- **n = 12:** 12 rows, every order divisible by 6 with a C₃-bearing factor (C₃, or F₂₁ = C₇:C₃ via T(7,3)). Four at t ≤ 7 and one at **t = 3** (`B:7+5:3.3`), which is among the strongest conditions in that battery — so the lcm strengthening lands where it constrains most.

**What this corrects.** §3f said the zero `+` counts were "an artefact of the hand-built stages", inferred when only TOM had been rerun. Wrong: the hand-built stages find them too. It was an artefact of an **older `ark_gap.g`** — the archived files predate the current tag collection. The retraction of my lcm sketch stands and is now doubly witnessed; the explanation attached to it did not.

**The trap worth recording.** A stale emission file differs from a current one *only in tags*, which is invisible to any check comparing orbital partitions — including §8.5's TOM-vs-hand-built comparison, which ran against the stale file and was unaffected precisely because it compared maps. **One figure did move:** the hand-built battery is **170 distinct conditions, not 167**, since a distinct tag makes a distinct condition; V, the pair counts and every time estimate are unchanged. Swept through both documents along with the derived 75-of-167 / 45% figures.

**A GAP read-time warning, fixed.** Stage B's shift lambda `x -> off + x^g` closes over `off`, which is first assigned inside the loop; GAP parses a function body when it reads it, so the global is unbound at parse time and the file drew `Syntax warning: Unbound global variable` at every startup. Runtime semantics were always correct — the assignment happens before the lambda is called — but a warning that prints on every run trains the eye to skip GAP warnings, which is the real cost. `off`, `d`, `part`, `ranges`, `combo`, `gens` and `T` are now predeclared in the hygiene block alongside `g`, and the comment there explains the read-time/run-time distinction so the block does not look like superstition. A static scan for other names closed over by top-level lambdas found none. Three comments and one log line that hardcoded degree 10 were made N-dependent at the same time, since the n = 12 run makes them actively misleading.

**The subdirect-product hole is closed at n = 12 as well.** The `TOM` stage finished there: 6,211 rows, and `verify_emission.py --contains` gives **441 orbital partitions against the hand-built file's 296, 145 new and 0 lost**; at the condition level **711 against 427**, again none only in the hand-built file, including all 11 of its multi-prime partitions. So μ(12) = 18 joins μ(10) = 20 as exhaustive over every conjugacy class of subgroups rather than "over the enumerated groups", and job (c) has complete batteries at both degrees.

*One thing worth not mis-reading:* TOM emits **fewer rows** at n = 12 (6,211 vs 7,115) while carrying half again as many partitions — the hand-built file spends 5,924 rows on stage C's p-subgroups, which collapse to a few hundred distinct partitions, where TOM pays once per class. Row count is not a measure of battery strength, and `--contains` is the check that catches a partial exhaustive stage where a row count would not. (I nearly recorded an earlier, still-running copy of this file as final; the counts differed by 9 rows and 0 partitions, which is exactly the sort of near-miss the containment check is immune to and a row count is not.)

**Emission-file integrity, scripted.** `verify_emission.py` checks what fails silently downstream: wrong degree (parses fine, meaningless catalog), truncation, duplicate keys from an interrupted resume, non-dense orbital ids (`consume_gap.py` indexes by them, so a gap shifts every class above it), malformed tags. All three files here pass — `groups_out_10.txt` 967 rows, `groups_out_10_tom.txt` 1,111, `groups_out_12.txt` 7,115 — and the failure paths were tested against deliberately corrupted copies. `--contains` reproduces the §8.5 exhaustiveness comparison as a command (186/131/55/0 at n = 10) and is the thing to run at n = 12 once TOM finishes there, since a non-empty "only in OTHER" list would mean TOM is not exhaustive at that degree. The signature is invariant but not complete, and the incompleteness flatters containment, which the docstring says rather than glosses.

**Not benchmarked:** `stage4_fast.py` at larger V (30–90 s at V = 1,242; a CSP over V booleans, will grow but not to hours), and anything at n = 12.

## 3g. `mu_exact.py`, and the rate of approach to 7 − 4√3

**A fast SAFE enumerator with the same trusted base.** `mu_enumerate_v3.py` loops over every (bottom prime p, top prime q) pair and runs a generic multiset recursion per pair — n^2.9, and it exceeds 280 s per value by n ≈ 2,600. `mu_exact.py` enumerates the same shape space with the same SAFE score by arithmetic: p is read off each part, r = n − Fc is determined by subtraction, and the multi-part cases are bounded by score inequalities. **No new theorem enters.** F.1 is self-certified per n exactly as in v3 (1/√δ ≤ k checked against the value found), deliberately *not* imported from the ladder, which would add a dependency on Part E's realisability that v3 does not have.

*The one real trap:* with a lone foreign part the best top prime is **not** the largest prime-power divisor of r − 1, because `orb` halves for even twists — at r = 41, Q = 8 gives 164 where Q = 5 gives 205. The code maximises over all prime-power divisors explicitly.

**Validation, three independent kinds.**

- **Reproduction:** all 2,187 rows of the v5 table, 0 mismatches, including n = 2759. The validator separates low mismatches (missing shape) from high (over-score); both zero.
- **Cross-check against `v3.mu_bound` at n never computed** — 2602, 2604, 2607, 2680 — all exact, at 10³–10⁴× speedup.
- **Independent spec-derived enumerator**, brute force over part multisets, written from the shape-space description rather than from either script: 139 values on 6 ≤ n ≤ 200, 0 mismatches. This is the check that would catch a case dropped by *both* existing scripts.

**New results from the table to 10⁴** (8,622 rows, 158 s to 8,000; the run scales as ~n^2.5, so 10⁵ is ~20 h in plain Python — my earlier "couple of hours" was wrong and I should have measured first):

- **0 uncertified rows** — F.1's self-certification holds everywhere in range.
- **The ladder never exceeds B and is tight at all 185 joined values**, extending the previous 28-value join by 6.6×.
- **No three-part winners anywhere to 10⁴** (2,191 one-part, 6,431 two-part).
- **The minimum density over every n ≤ 10⁴ is 0.04621 at n = 2759** — previously known over the contiguous prefix to 2,600 plus a worklist; now exact across the whole range.

**The o(1) in the ceiling.** Written up in the new `approach-rate-note.md`, with a pointer added at `aod` §3.3.5. The loss is linear in the distance from the balance point x\* = (2−√3)/2, so it is set by gaps between admissible c, which the singular series counts:

> **E[δ\* − δ(n)] ≈ log³n / (1.7410 · S(n) · n) ≈ 0.30 log³n / n**, with S(n) = 3C₀·∏(ℓ−2)/(ℓ−3) — the same constant as `aod` §3.4, and the two calculations agree, which is the one available cross-check on that section's arithmetic.

Tested against the ladder to 10⁶ (32,486 class-11 values in [3·10⁵, 10⁶]: quantiles match Exp(1) to 6–8% throughout, and the maximum 10.35 matches ln N = 10.39) and against exact B to 10⁴, which closes the concern that the first fit was against the family score rather than δ(n) — **exact B equals the ladder at every class-11 n ≤ 10⁴, with identical below-ceiling membership**.

*Two honest caveats, both in the note.* The moderate-n fit is compressed (median ratio 0.30 at 10³ rising to 0.65 at 10⁶) because the observed loss is the minimum over *all* competing shapes, not the F = 4 deficit the model predicts — among class-11 n ≥ 5000 only 42% fall below the ceiling at all, and F = 2 or 6 wins 40 of the 113 that do. The convergence toward ln 2 is the evidence. And the distributional half is Cramér, not Bateman–Horn: the series gives the mean exactly and says nothing about gaps in a window of width log³n, so any "for all n" statement rides on the Poisson step. That is why the note sits outside `aod`.

**Chunking, and a corrected cost.** The run is embarrassingly parallel in n, so `--chunks i/N` was added, splitting for **equal work rather than equal width** — per-n cost grows as ~n^1.5, so the split points are at nmax·(j/N)^0.4, and equal-width chunks would leave one worker doing most of the run. Verified that concatenated chunk output is byte-identical to the unchunked run. Measured: the heaviest of 8 chunks at nmax = 20,000 took 281 s, putting **an 8-way run to 10⁵ at ~4.5 h wall** against ~20 h single-threaded. The default output name is now `mu_table_exact.csv`, matching the script rather than the earlier "fast" framing.

## 4. Not examined

Left untouched by this pass, and unverified by it: `notes` §§7–11 and appendices; `aod` §§3.5–3.8, §4, §6.9; `ep` Parts G–J; `verification-lessons.md`; `literature-findings.md` beyond its headers; the GAP scripts. `wide_cert.py`'s B_lo families were partly examined — the missing fused rung was found and fixed (§1.2b) — but `two_part_lo`, `fused_lo`, the menu top-up and the **share-pair guard** were not. The guard is the one that matters: it exists because an over-credited B_lo is anti-permissive, feeding the s_max and foreign-cap filters and dropping candidates silently, and that half remains unexercised. It is the natural next item after T3. Nothing in the deferred material was needed for the findings above, but the B_lo families named above are now the least examined part of the certificate chain and are the natural next item after T3.

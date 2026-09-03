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

**Owed:** `ladder_verify.py 1000000` under the corrected scoring, which is what discharges every ⟦PENDING-LADDER-RERUN⟧ tag and restores the ladder-gap check to PASS.

---

## 4. Not examined

Left untouched by this pass, and unverified by it: `notes` §§7–11 and appendices; `aod` §§3.5–3.8, §4, §6.9; `ep` Parts G–J; `verification-lessons.md`; `literature-findings.md` beyond its headers; `wide_cert.py` and its B_lo construction (which inherits §1.2's scoping question and could not be checked without the file); the GAP scripts and `blo_100000` output. Nothing in the deferred material was needed for the findings above, but §1.2's rescoping of the E″ coverage figure is a claim about `wide_cert.py` made without reading it.

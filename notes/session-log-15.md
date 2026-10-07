# Session log 15 — a fresh-eyes audit: one model error in the Oliver conditions, a scoring bug in E.5's exception list, and the statistics brought to the 10⁶ table

*One sitting with two halves. First, a critical read of `orbital-evasiveness-notes.md` (oen), `enumeration-proof.md` (ep) and `arithmetic-of-density.md` (aod), checked against `pending-checks.md`, `literature-findings.md`, the scripts and the outputs. The read put correctness in spirit first and correctness in letter second; wording and structure were out of scope. Second, the fixes, each re-derived or recomputed as it was made. Five corrections were substantive. The rest was figures that had not been brought forward to the [6, 10⁶] table.*

---

## 1. Substantive corrections

### 1.1 Oliver's condition costs one prime, not one per layer (oen)

oen said every layer of the Oliver chain spent an 𝔽_p-acyclicity. That is wrong. Oliver's theorem needs **AC_p only for the chain's bottom prime p**, and only **ℚ-acyclicity** when the bottom layer is trivial. Re-derived from scratch:

- Smith theory makes the bottom p-group's fixed set 𝔽_p-acyclic.
- Universal coefficients then give ℚ-acyclicity.
- Lefschetz over ℚ-homology handles the cyclic layer, which therefore costs no extra prime.

These sections were rewritten to match:

- the overview line;
- the §7.1 test table and the §7.2 table, which gains a trivial-bottom row reading ℚ-acyclic;
- the section on which particular primes are attacked. Every prime power attacks AC_{char}; n = 10 attacks AC₅ and n = 12 attacks AC₂.

### 1.2 Two-orbital groups exist at far fewer block sizes (oen §7.7–7.8)

The block shape with m ≥ 3 was treated as available at every prime power m. A re-derivation through the cyclic normal subgroup shows it needs one of the following:

- m = 3;
- a Fermat prime;
- a prime m ≡ 3 (mod 4) with (m − 1)/2 an odd prime power.

So m ∈ {3, 5, 7, 11, 17, 19, 23, 47, 59, …}, and n = 377 has no two-orbital Oliver group. Two places in §7.8 were narrowed to admissible m: the τ ≤ 2 condition, and the 2F case of triangle-freeness.

### 1.3 Theorem E.5 has 12 exceptions, not 15 (ep, `fallback_sup.py`)

`fallback_sup.py` valued a trivial-twist foreign block at its raw size. A block of size r = 2 holds one pair, so it was worth 2 instead of 1. `fcap` now routes the trivial twist through `orb()`, so the C(r,2) cap applies.

Rerun to N = 3000:

- **12 exceptions**: n = 5, 7, 11, 12, 15, 21, 23, 27, 28, 31, 40, 63.
- n = 8, 9 and 10 drop out.
- n = 5 now scores SAFE 1.
- The near-miss list is unchanged: 0.99555 at 1797, 0.99364 at 1257, 0.99109 at 897, 0.98085 at 417.

The changes in ep:

- Every site citing the count, the exception table and Corollary E.6's proof were updated.
- "Every one at a proper prime power" is now "all but n = 5".
- The sharpness remark was corrected. n = 1257 is *not* a Cunningham chain: q = 5, e = 3, r = 251 = 2·5³ + 1, c = 503. The other three near-misses are chains.

Theorem E.5's statement and proof are unaffected; only its exception list shrank.

### 1.4 The Galois-layer example in ep E‴ shows nothing

The example was C₁₈ ⋊ Frob₃ ≤ ΓL(1, 343), whose minimum intra-orbital is 3087. It was offered as the Galois layer raising a stripped block above its cyclic score. But 3087 = orb(343, 18) comes from the cyclic part C₁₈, which is the *unstripped* twist. Now take the stripped twist C₆ = 𝔽₇^×. The Frobenius fixes 𝔽₇ pointwise, so under C₆ ⋊ Frob₃ the orbit of 1 is 𝔽₇^×, of size 6, and the minimum stays orb(343, 6) = 1029.

The "strictly in between" bullet now says no instance is known and that the question belongs to J0a. B_refined⁺ is recorded as moot unless J0a supplies an example, and pending-checks A28 carries a matching notice.

### 1.5 Certificate complexity: C ≥ C(n,2) − sat(P), not equality (oen §9.5)

C₁(P) = C(n,2) − sat(P) is right, but C = max(C₀, C₁) can exceed it. P = "not K_n" has sat(P) = C(n,2) − 1 and C₀ = C(n,2). The saving bound "at most sat(P)" survives, because it needs only the inequality.

---

## 2. Other mathematical corrections

- **oen §9.7, the triclique remark.** A top-layer q-group permuter caps at k = 3. A cyclic-layer rotation plus a top multiplier, however, gives a 2-homogeneous action at admissible k. The two-graph criterion at n = k·m therefore catches χ(H) ≤ k without character sums; character sums buy *general n*. The cap paragraph and its conclusion are scoped to top-layer permuters. The n = 50 remark is replaced by a hand-check argument, marked as not machine-checked.
- **oen, the F = 13 aside.** A q-subgroup of (ℤ/13)^× with −1 reaches at most **6** of the 12 units, not 8.
- **oen §8 and the template caution.** μ(12) = 18 is reached at **k = 3** blocks of 4, not k = 4. The TOM counts 1,111 / 6,211 are conjugacy classes, while 967 / 7,115 are hand-built rows. The raw counts cannot be compared, since 7,115 > 6,211, so the containment is now stated for orbital partitions.
- **oen, the two-graph consequences.** K₃,₃-freeness is evasive at n = 2m and 3m for prime powers m ≥ 7, not only at 18 and 21. 2K_m and 3K_m need m ≥ 6 to contain K₃,₃.
- **oen §7, the n = 58 contrast.** χ = 3 at the five-block construction needs q ≠ 2.
- **oen, the s(n) box.** The class-11 minima 0.0702 and then 0.0678 are not "approaching 1/13 from below"; the minimum fell between ranges.
- **oen, the orbital-count remark.** "Force comes from few orbitals" and "bites hardest with many orbitals" are reconciled. Few orbitals pin P tightly. At max-m\* groups, however, the pinned conclusion is usually triviality.
- **oen, the threshold paragraph.** Over [6, 10⁶] the smallest orbital is unique at 768,400 of 921,265 rows (83.4%). At the other 152,865 rows the minimum is attained k ≥ 2 times, always by the cyclotomic classes of one foreign block. There χ ∈ {0, k}, so P is evasive unless it contains all k with k ≡ 1 (mod q); at 2759, k = 6 and q = 11. The median (m₁ + m₂)/C is 0.343 and the minimum 0.092.
- **oen glossary.** A foreign prime *can* repeat across orbits; the repeat is buildable but dominated. F_mid carries no coprimality condition against the twists, which is the entangled-generator correction.
- **oen Appendix C, row 6.** 12T162 is settled (§7.13). The open groups are 10T7, 10T26, 10T31, 14T10 and 14T30.
- **oen, where the constants come from.** The constants are 1/4, 3 − 2√2 and 7 − 4√3, keyed mod 12, with d ∈ {2, 4, 6, 12}. These replace 1/9, mod 24 and d | 12.
- **ep, the verified-group list.** The S11 case 5 + 7\* + 11\* was flagged inadmissible and removed, so the list has seven cases. The reason was **not re-derived** this session; see §5. The suggested admissible replacement, 4 + 7\* + 19\* at q = 3, has predicted orbitals 6, 21, 171, 28, 76 and 133, summing to 435 = C(30, 2). It is **not built**.
- **ep, the battery table.** The n = 255 row checks two *unfused* 73-blocks; the fused reading would give 2943. It is not the winner: μ(255) = 3403 via `4x43 + 1x83*`, which is not in the battery. It is now marked as such.
- **ep, Theorem 2.3.** The heading now separates the proved half (μ ≤ B₀) from the half that is verified to n = 1200 but unproved (at most two chunks).
- **aod §3.2 worked table.** orb(107, 2) = **107**, not 214. The n = 531 foreign entry is **257** (the text already said orb(257, 1) = 257), not 274.
- **aod, the 257-escape paragraph and ep G.** The comparison cap for classes 3 and 7 is 1/8, not 0.08579.
- **aod §5, windowing loss.** The loss is Θ(ε), not Θ(√ε). This is consistent with §3.4's kink gotcha.
- **aod §7, Open Problem 8(b).** Theorem E.5 closes the fallback branch by theorem above 1/25, so the "only path is direct" applies only below 1/25.
- **aod, the census line.** "S4 together with S7 at F = 2, split by c mod 8" is now "S7 at F = 2". The fused rung dominates S4 at every c.

---

## 3. Figures brought to the [6, 10⁶] table

All of these come from `validate_table_v3.py`, `orbital_counts.py`, direct reads of `mu_table_ladder.csv` and `mu_table_exact.csv`, and the `check_doc_figures.py` transcription block.

- **Shape census** (ep Part 0, aod §1):

  | Shape | Count | Share | Trend by thirds |
  |---|---|---|---|
  | S2 | 124,502 | 13.5% | 15.1 → 13.0 → 12.4 |
  | S3 | 373,661 | 40.6% | 40.5 → 40.4 → 40.7 |
  | S5 | 2,012 | 0.2% | 0.7 → 0.0 → 0.0 |
  | S7 F = 2 | 306,544 | 33.3% | 31.8 → 33.4 → 34.6 |
  | S7 F = 3 | 68,927 | 7.5% | 7.2 → 7.7 → 7.5 |
  | S7 F = 4 | 44,802 | 4.9% | 4.4 → 5.3 → 4.8 |
  | S7 F = 6 | 814 | 0.1% | 0.3 → 0.0 → 0.0 |
  | S7 F = 8 | 2 | — | — |
  | S7 F = 5 | 1 | — | — |

  Fused class plus foreign prime: 423,102 of 796,763 two-part winners, 45.9% of the table. No winner has more than two parts.
- **η = 1.** 511,572 of 796,763 foreign-block winners (64.2%), replacing 74.8% and 77%. The commonest efficiency-1 foreign primes are 39367 and 65537.
- **Orbital counts** (oen §9.7):
  - mean t = 3.95, mean 1/δ = 6.18, mean t·δ = 0.68;
  - t ≤ 3 at 45.5% (t_eff ≤ 3 at 54.1%), replacing "two thirds";
  - minimum t·δ 0.259, at n = 55751.
  - The n = 851 mechanism is restated. Its foreign block is at *full* efficiency (q = 233), and the binding orbital is the intra class 3·C(128, 2) = 24,384.
- **The δ ≤ 1/16 tail.** 39 rows (oen OP8(a), ep J.1 and J.2a, aod §7), replacing 7 of 2,186. Only 2759 and 2183 lie below 0.05.
- **Per-class δ/cap minima** on the exact table run from 0.471 (class 0, n = 72) to 0.693 (class 5, n = 6149). Class 11 is 0.644 at n = 2759 and class 4 is 0.497 at n = 1192. The old 0.327 at n = 688 was a ladder figure.
- **aod §5 block minima.** The table was replaced with the real values; every block after the first is above 0.063, rising overall but not monotonically. The untruncated sampled column and the coincidence sentence were dropped. Eight of the ten minima are ≡ 23 (mod 24); two are ≡ 11 (213107 and 504107).
- **Spot values that were stale:**
  - n = 11183 is 0.065738 (no longer the runner-up; the runner-up is 2183 at 0.048039);
  - n = 6275 is 0.079825, and the class-11 minimum is 2759;
  - n = 1817 is 0.091483 on `2x389 + 1x1039*` (the v4 0.045742 was an artefact);
  - n = 3059 and n = 3239 are 0.083906 and 0.055155;
  - η at odd q for r = 7681 is at most 0.0013.
- **ep Part F.**
  - D(δ₀) = 26.7 at the floor, against a crude 43; the factors against the measured cofactor 12 are 2.2 and 3.6.
  - F.2 with one fused class gives k ≤ 4.24.
- **ep Part I.**
  - Basis: 921,265 rows.
  - Fallback invoked at 0 of 921,265.
  - Part counts: {1: 124,502, 2: 796,763}.
  - The tightest feasibility row is n = 999,958 = `2x499979`, with slack 0.0000006.
  - The 1,940 / 2,187 "settled by theorem" figure is scoped to the old prefix.
- **Status banners and range statements.** The exact table is complete over [6, 10⁵], 90,299 rows (the oen banner had still said 76,752). The ladder agrees with it at all 90,299 values. The floor is 0.046210 at n = 2759 in both tables.
- **literature-findings item 1.** Foreign-free winners are 13.5% of the table, not 39%.

---

## 4. Checks that came back clean

- Decade minima in aod §5.
- The witness and density at n = 999,958.
- The Cunningham chains at 1797, 897 and 417: (179, 359, 719), (89, 179, 359) and (41, 83, 167).
- The exact-table values at 1817, 3059, 3239, 11183 and 6275.
- `check_doc_figures.py`'s transcription block, which agrees with every figure entered above: row count, floor, one- and two-part counts, and the 39-row tail.
- The near-miss list of `fallback_sup.py`, which is unchanged by the fix.

---

## 5. Left open, and skipped for effort

**Re-derivations owed:**

- Why 5 + 7\* + 11\* is inadmissible.
- Whether the ladder table's `certified_K` column means the same thing as the exact pipeline's halting K. On [6, 10⁶] the two columns coincide, which is suspicious.
- aod's "zero rows exceed their own cap", which is scoped to the old 1,167-winner table and was not rerun.

**Noted in review, not yet applied:**

- **oen:** the certificate wording in the overview; the "Open Problem 7" cross-references (should be 6); the 1,297 vs 1,294 overlap; planarity ≈ n¹⁰; the cd/2 vs cd site; the 1,111 cap wording.
- **ep:** the Part H ceilings (k ≤ 2 or 3); the F_mid coprimality sites (the Part 0 diagram, the shape statement, Part E); strictness (> / <) in the s-ladder corollary; the 2,187-row scope of the certificate run.
- **aod:** the F_mid coprimality sites in §6.2–6.3, including a contradiction in §6.2; S7f2 dominating S4 in §6.3; F = 3 co-winning classes 2 and 8 in §4.5; one > that should be ≥; "26 and 20" in the S6 discussion (n = 12 is not a survivor); the class-11 arithmetic, which should use F = 4 and r = 6q + 1; a stray "4.".
- **pending-checks:** the stale numbers in T8; the opening claim that every measured figure is current.

**Checker:** pattern proposals for `check_doc_figures.py` were not implemented. After the edits it reports 48 findings needing a decision, against 42 before. Most of the increase is line-shift noise and parser misreads ("999,958" read as n = 999). A few are deliberate scope notes that cite older tables.

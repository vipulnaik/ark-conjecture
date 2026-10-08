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

---

## 6. Second pass — the items §5 left open

*The fixes listed in §5 as noted but not applied are now applied, each re-derived as it went in. Three of §5's "re-derivations owed" are settled; one is rescoped rather than rerun.*

### 6.1 Re-derivations settled

- **Why 5 + 7\* + 11\* is inadmissible.** Lemma C's coupling t | ord_r(p) fails at the 11-block. The only common top prime is q = 2, giving twist 2 at both foreign blocks, but ord₁₁(5) = 5 is odd, so the 11-block's 2-power twist is forced trivial. (ord₇(5) = 6, so the 7-block is fine.) The replacement 4 + 7\* + 19\* at q = 3 passes the same test: ord₇(2) = 3 and ord₁₉(2) = 18 take twists 3 and 9, matching its predicted orbitals 21 = 7·3 and 171 = 19·9. ep now states the reason.
- **`certified_K`.** Read off the writers: `mu_exact.py` and `mu_ladder_exact.py` both write the part count k into `parts`, `certified_K` and `partcap` alike, keeping `mu_enumerate_v3.py`'s header. On both tables the three columns are identical: {1: 15,787, 2: 74,512} on the exact table, {1: 124,502, 2: 796,763} on the ladder table. Only `mu_enumerate_v3.py` recorded a Part F halting K. ep Part I now says so; the "worth checking" hedge is gone.
- **oen §8's TOM cap.** 1,111 / 6,211 are the Oliver classes with **at most 12 orbitals**, not all subgroup classes. The cap loses nothing, since more than 12 orbitals forces one below C(n,2)/13 = 3.46 and 5.08, under μ(10) = 20 and μ(12) = 18. oen states this.
- **aod's "zero rows exceed their own cap"** was not rerun. It is scoped to the 1,167-winner table it was run on, with the rerun noted as open.

### 6.2 oen

- The "Open Problem 7" references (the n = 6…11 window and "either outcome is a theorem") now point to **Open Problem 6**, the single-shape search at n = 6.
- **The 1,297 vs 1,294 overlap.** The trivial-top / q = 2 / q = 3 buckets (699 + 577 + 21 = 1,297) exceed the 1,294 Oliver classes at n = 10, so at least three classes carry more than one reading. This is stated in place.
- **A₅ is not "S₅ with AGL(1,5) removed".** It is the index-2 subgroup. What separates it is that AGL(1, 5) — whose multiplier x ↦ 2x is a 4-cycle, hence odd — does not lie in A₅. Rewritten.
- **Planarity's fsc is ≈ n¹⁰, not n⁹.** A K₅ subdivision spreads up to n − 5 subdividing vertices over 10 edges, giving Θ(n¹⁰) patterns; K₃,₃ gives Θ(n⁹).
- **orb(c, d) = cd, not cd/2, for the 2-homogeneous-not-2-transitive case** at c ≡ 3 (mod 4). With d = (c−1)/2 odd, −1 is not in the twist, so the two ordered orbitals fold into one unordered orbital of size cd = C(c, 2). Fixed here and at the matching 2-homogeneity remark in aod. aod §3.1's Euler-criterion paragraph already had it right.
- **Overview certificate claim:** checked clean. "Run to n = 100,000, succeeding at every value" matches aod's 90,299 of 90,299 for the B_refined = B_safe certificate. Left as it stands.

### 6.3 ep

- **F_mid coprimality, in three places.** The Part 0 diagram's middle column ("must share no prime with any twist or outside block"), the n = 308 gotcha and the general-configuration paragraph now say the same thing as Part E and aod §3.2.3. One entangled generator of order F_mid·d carries the rotation and the full twist together, so no coprimality against the twists is needed. Coprimality with outside blocks is a sufficient condition for building, not a proved necessary one. The cyclic-branch scale estimate in G now says "ignoring coherence with other classes".
- **Part H forward pointer.** The old ladder constants (1/4, 0.049, 0.028, giving k ≤ 2, 4, 5) are replaced by the mod-12 ceilings: **k ≤ 2 at every class except n ≡ 5, 11 (mod 12), where k ≤ 3** (1/√0.134 = 2.73, 1/√0.125 = 2.83, 1/√0.101 = 3.15, 1/√0.0718 = 3.73). The δ-conflation paragraph quotes the current floor.
- **The s-ladder corollary is now sharp.** Since s < 1/√δ − 1 ⟺ δ < 1/(s+1)², branch s is reachable only when δ < 1/(s+1)², strictly. The "guarantees s ≤ K when δ > 1/(K+2)²" side was already correct.
- **E.5: one more "15 exceptions"**, in the s = 1 / s = 2 (a ≥ 2) bullet, is now 12. A repo-wide grep finds no others outside the session logs; `lean/README.md` does not cite the count.
- **Certificate run scope.** "Requoted from the run on the completed table" is now "the 2,187-row table it covered (not rerun over [6, 10⁶], where Corollary E.6 does the work)".

### 6.4 aod

- **§6.2's coprimality contradiction.** The cyclicity paragraph required distinct classes' twist orders to be pairwise coprime; two paragraphs later the diagonal-generator paragraph said they need none. The first is now aligned with the second. Both, and the §6.4 conditionality paragraph, drop the claim that the cyclic layer's order must be coprime to the block rotations F_mid, the entangled generator again. What remains is Lemma C: cyclic-layer twists coprime to the foreign primes. "Coprimality budget" in the linkage remark is now "Lemma C's twist–foreign coupling".
- **§4.5: S7 at F = 3 co-carries n ≡ 2, 8 (mod 12).** Its safe-prime rung ties S3's obstructed ceiling (2 − √3)/2 there exactly, as §3.3 already said. The fates table and the shares paragraph had it losing to S3's 1/4 at every even n.
- **§6.5 census line.** "S3, S4 and S7 at F = 2" is now S3 and S7 at F = 2, with F = 4 at class 11 and F = 3 at classes 2 and 8; S4 is dominated by the fused rung at every c.
- **§6.3 bound.** cap_F(1) **≥** 1/25 ⟺ F ≤ 16, with equality at F = 16, matching the feasibility cut √F + 1 ≤ 5.
- **S6 near-misses.** The locally surviving members of the obstructed families are n = 26 and n = 20, as the census row says. n = 12 is among the scan's next-best values but is not a survivor.
- **Class-11 arithmetic (§3.2).** The paragraph used F = 2 and r = Dq + 1 with a conclusion about c mod 4. The class-11 rung is F = 4 with r = 6qᵉ + 1. Since n ≡ 3 (mod 8), an odd c = (n − r)/4 needs r ≡ 7 (mod 8), which pins **qᵉ ≡ 1 (mod 4)**, consistent with §3.3's r ≡ 7 (mod 24). The congruence falls on the twist prime power, not on c, and an even c (a power of 2) covers the other case.
- The stray "4." flagged in §5 was not found on re-reading; the hit was a legitimate numbered list item, condition 4 of the (BCG-AL) hypothesis.

### 6.5 pending-checks and dehistoricization

- **The opening claim that every measured figure is current** now names the exceptions: run outputs scoped to older tables and not rerun. These are `fallback_cert.py` on 2,187 rows; `converse_check.py` and T8 on [6, 2600]; and aod's cap check on 1,167 winners.
- **T8.** D(δ₀) = 2(1 − √δ₀)²/δ₀ was recomputed: **26.7 at δ₀ = 0.046210** (against 43 for 2/δ₀) and 32 at 1/25. These replace 25.4 and 42. The measurements paragraph is scoped to [6, 2600] as a last run, with a rerun as the open item.
- **Era labels added in the first pass were removed**, now that this log records the history: the 74.8% / 77% asides (oen glossary, ep G), the v4 0.045742 aside (oen §2.4), "7 on the old prefix, 18 under v4" (aod §7, ep J), and "the old 39%" (literature-findings).

### 6.6 Checker

`check_doc_figures.py` now reports **43** findings needing a decision, against 42 at the start of the session and 48 after the first pass. There are 11 historicizing phrases, nearly all pre-existing. The remainder are scope notes that deliberately name older tables (the certificate, converse and cap-check runs) and known parser misreads. New checker patterns were still not implemented.

### 6.7 Still open after this pass

- Reruns over [6, 10⁶] of the checks that are now explicitly scoped to older tables: `converse_check.py`, aod's no-row-exceeds-its-cap comparison, and the theorem-settled counts of ep Part I. None is load-bearing above 1/25, where Corollary E.6 does the work.
- **4 + 7\* + 19\*** remains predicted, not built.

---

## 7. Auxiliary documents, first pass

*Order chosen by load-bearing weight for the headline result (μ = B to 10⁶), then by citation count from oen / ep / aod.*

### 7.1 Correction to §6.1: the 5 + 7\* + 11\* reason was wrong

§6.1 attributed the inadmissibility to Lemma C's coupling t | ord_r(p). That coupling applies only when **r divides the matching block's twist** (r | d). Here d | 4, and neither 7 nor 11 divides it, so the coupling says nothing. The actual defect: the group built for the S11 table used e = 1, 1, i.e. **full foreign twists 6 and 10**, which no single top prime supplies (Lemma B′). And n = 23 is prime, so "matches the table" could not hold. The q = 2 reading (twist 2 on each foreign block, e = 3, 5) is admissible, with the same orbital total 253. ep's S11 table and the verified-groups list now say this, and point to 4 + 7\* + 19\* at q = 3 as the tabulated replacement (predicted, not built).

### 7.2 `ladder-completeness.md`: conclusions hold, two proof steps replaced

- **Three foreign primes (Proposition 1).** The ratio argument ("any two have ratio ≥ 2") is false: with mixed k and e, ratios as close as 1.2 occur (2·5^e against 12·5^{e−1}). Efficiency excludes them instead: the smallest part has y ≤ 1/3, so it needs η > 9/25. Brute force over triples with k ≤ 40, d ≤ 4 and q ≤ 31 gives max min η·y² = 0.037 < 1/25.
- **Fermat exclusion (Proposition 2).** "Finitely many Fermat primes, all at n < 200" is wrong, since 257 and 65537 occur. Recomputed: over every prime pair (Fermat, k·2^e + 1) with k ∈ {1, 3, 5} and e < 64, only {3, 5} and {5, 7} exceed 1/9 or 1/16, both at n < 30. The pair 65537 + 163841 caps at 0.082 / 0.049. The suprema 1/9 and 1/16 at odd q, and 0.0469 at q = 2 without a Fermat prime, were reproduced by brute force.
- **Letter-level fixes:**
  - k ≤ 12 holds only for parts of share below 1/2; in general it is k < 32.
  - The merge step needs a ≥ b, not a > b.
  - The p^b ≥ 5 step follows from the intra bound for n ≥ 76; the share bound alone does not give it.
  - S11 may carry a fused class.
- **Checked clean:** `mu_ladder_exact.py` enumerates k ≤ 40 and fused S11, so the certified table does not inherit the note's letter-level gaps. Its docstring's "fifteen" E.5 exceptions is now twelve.

### 7.3 `entangled-generator-finding.md`

Checked clean: every predicted value matches the rebuilt tables — μ(78) = 468, 105 → 812, 207 → 2525, 231 → 2943, 253 → 5256. Repairs 1–6 are applied, and the n = 33 group is in `verify_witness.g`. A current-status block was added, noting n = 1817 is superseded (0.091483) and that repair 7 is tracked as ep J0.

### 7.4 `small-degree-computation.md` (read in full)

- **§2.0, the prime-power remark was wrong in the same way oen §7 was.** It said 𝔽_p-acyclicity is "not excluded at prime powers" because Smith theory on the translations "yields no contradiction". But at n = p^k, 𝔽_p-acyclicity for p = char(n) already excludes everything. Smith makes the translation subgroup's fixed complex 𝔽_p-acyclic. A finite 𝔽_p-acyclic complex is ℚ-acyclic: its integral homology is finitely generated with A = pA, hence finite of order prime to p. The cyclic layer's generator then has Lefschetz number 1, which equals χ of its fixed complex, against χ({∅}) = 0. What is not excluded is 𝔽_ℓ-acyclicity for ℓ ≠ p, and global χ = 1. The §2.0 table row for the Oliver congruences now reads "𝔽_p-acyclicity for the bottom prime (ℚ-acyclic if trivial bottom)" rather than ℤ-acyclicity.
- **§7.1, the one-sidedness diagnosis overstated.** It said the only OUT-generator is nontriviality. That holds for the *primal* conditions, but the CSP also enforces the *dual* conditions (§2.2, §3.5). A dual χ condition pushes complements IN, hence graphs OUT, which is exactly the pressure the diagnosis says is missing. The text now says the dual OUT-pressure exists and is absorbed by the cone escape, which is what §7.2's 878 → 138 patterns measure, rather than being absent.
- **Count inconsistencies.** The n = 10 battery is 170 conditions with 128 Oliver, per the verification table. "167" and "125 exist" are corrected in both `small-degree-computation.md` and `small-degree-verification.md`. The 699/577/21 split of the 1,294 classes double-counts, as in oen: 1,297 readings. n = 12's hand-built 427 conditions (§8.5) against 425 elsewhere is flagged, not resolved; it is probably the same retagging as at n = 10, but unchecked. The "complete batteries of 242 and 711" in §10 are complete only up to the MAXT = 12 cap; the 183 Oliver classes at n = 10 with t ≥ 13 remain outside.
- **Checked clean:**
  - the n = 12 census sums (295 + 657 + 67 + 6,096 = 7,115; 6,004 + 88 + 2 + 2);
  - 183 = 1,294 − 1,111;
  - 8,082 = 967 + 7,115;
  - the §8.4 percentages (230/425 = 54%, 125/425 = 29%);
  - the backbone tally (25 + 20 + 310 + 54 = 409);
  - χ(max-deg ≤ 1) = −1,215, recomputed from the matching numbers of K₁₀;
  - δ_S2 at n = 10, 12;
  - the 12,005,168 graph count.

### 7.5 `solvable-relaxation.md`

- **New connection: B₀ = μ_solv exactly.** oen §2's B₀ uses cap(s) = s(L(s) − 1)/2, which is this document's score(s) verbatim, over the same max–min. So the "robust fallback" bound *is* the solvable optimum. That explains the shared minimum of 0.123 at n = 551, and it means the gap B₀/B is the chain's cost. It also shows ep's Theorem 2.3 two-part reduction and this document's "at most two parts" box are the same unproved claim. A box is added in §2.
- **The citation owed for the interval-constrained three-prime theorem.** A candidate is suggested, *flagged for checking against the paper*: Matomäki–Maynard–Shao (2017), almost-equal summands within n^{0.55}. The four-prime even case follows by peeling off one prime near n/4.
- **Corrections:**
  - "Forces the two primes into ratio ≥ 2" is false, as in §7.2; closer ratios exist and pay in efficiency.
  - "F = 2 on eight residues and F = 4 on four" is now five of six odd classes and class 11.
  - §5's "most class-11 values exceed 7 − 4√3 — 91 of 119" contradicted §4's 19,583 of 63,672, which is the current count.
- **Checked clean, recomputed from the ladder table:**
  - 63,672 class-11 rows, of which 19,583 exceed 7 − 4√3;
  - one-part winners at F = 2, 3, 4, 5: 41,706 / 28,814 / 22,173 / 18,048;
  - Proposition 1's proof (Kantor for 2-homogeneous not 2-transitive, Huppert for solvable 2-transitive);
  - 0.49981 = 1296/2593 at n = 2594.

### 7.6 `johnson-presentations.md`

Read in full; no corrections. **Checked clean:**
- the A₅ example: AGL(1,5)'s twist is a 4-cycle, hence odd; D₁₀ has orbitals [5, 5]; A₅ is its own only transitive subgroup on pairs;
- Lemmas 1–3 of §5a and the resulting lower bounds c·d·r·t = Ω(n⁴) at even n and c²·d·r·t = Ω(n⁵) at odd n. Lemma 2 is consistent with ep's Lemma C: it assumes a nontrivial foreign twist, which Lemma C's coupling would kill if r | d;
- the BBKN-route table at n = 510,510: F = n/Q = 30,030, log₁₀ 17^{30,030} ≈ 36,950;
- the Θ(n³) Reed–Solomon orders.

### 7.7 `shape-counting.md`, and a stale filename

- **N(δ₀) recomputed** by an independent enumeration of Σ√Fᵢ ≤ 1/√δ₀ with the m₁ + 1 foreign choices: 24, 65, 83, 112, 164 at δ₀ = 1/9, 1/16, 0.051813, the floor, 1/25. All match.
- **Stale references fixed:** `sp-to-floor.md` → `bcp-to-floor.md` in `shape-counting.md`, `shparlinski-constants.md` and `approach-rate-note.md`, and (SP) / (SP_{D,c,ρ}) → (BCP) / (BCP_{D,c,ρ}) in `shparlinski-constants.md`. Both are patterns `check_doc_figures.py` already flags as old names.
- `three-part-family-split.md` is archived and not reviewed.

### 7.8 `monotone-transitive-note.md` — an internal contradiction, which also corrects oen Appendix C

- **§6 item 0 had already closed A₆ and S₆ on 10 points** by inclusion. Each contains A₅ acting transitively on the same 10 points (the point-stabiliser A₅ on 3+3 partitions of {1..6} ≅ pairs of {1..5}), and the exhaustive A₅ search found no non-evasive property. Yet §3, §5 and §6 item 1 still listed them among "six still open". The note now says four remain unresolved by the criterion — M₁₂, and PSL(3,2), PSL(2,13) and the order-322,560 group at degree 14 — and that none can host a counterexample anyway, since n ≤ 14 is verified in the literature.
- **oen Appendix C row 6, as rewritten in §2 of this log, was wrong:**
  - It listed 10T7 as open, but A₅ on pairs is settled by exhaustive search.
  - It omitted M₁₂ and 14T54.
  - It ignored the literature's n ≤ 14.

  The row now says: the criterion first fails at 10T7 (then 10T26, 10T31, 12T162; M₁₂ and three degree-14 groups unresolved by it); evasiveness is settled at every failing group computed; n ≤ 14 is verified in the literature; the first open degree is 15 (A₅ on 15 points).
- The transfer of the one-sidedness diagnosis (§2) is updated to match §7.4's correction about dual conditions.
- **Checked clean:**
  - the degree-2p construction (order 2^{p−1}·p, inside A₂ₚ, Oliver with trivial top);
  - χ(A) = 21 − 110 + 120 − 30 = 1 for Lutz's complex;
  - the Heawood nerve (χ = −7, b₁ = 8);
  - the PSL(2,7) involution complex (χ = 168).

### 7.9 `hardness-of-evasiveness.md` — two rows of the planarity table were wrong

The §2a table claims the framework re-derives planarity's evasiveness at each of the six n where μ(n) ≤ 3n − 6. All four orbital rows were recomputed by direct orbit enumeration and a planarity test on every orbital union.

- **n = 12.** The stated group (C₂⁶ swaps, C₆ block rotation) has orbitals **6, 12, 24, 24**, not "6, 12, 12, 12, 12, 6, 6". With independent swaps all four edges between two blocks lie in one orbit. χ = **2**, not −7. The conclusion (χ ≠ 1, trivial top, evasive) survives.
- **n = 20, a real gap.** The stated 10 × 2 group has orbitals 10, 20, 40, 40, 40, 40 and gives **χ = 1 exactly**, so it proves nothing. The row's orbital list was again inconsistent with its own group. The entangled **4 × 5** group closes it: four 5-blocks, step multipliers with product 2, Γ₁/Γ₂ = C₁₆, trivial top, and it is the μ(20) = 40 optimum. Its orbitals are 4K₅ (40), 50 and 100, none planar, so χ = **0**. The table and the note under it now say this.
- **Checked clean:**
  - the exceptional set {6, 10, 12, 15, 20, 30} against the exact table (μ(30) = 78);
  - the labelled planar-graph count 32,071 at n = 6, recomputed by brute force over 2¹⁵ graphs;
  - the n = 10 and n = 30 rows.

### 7.10 `restriction-game.md`

Read in full; no corrections. **Checked clean:**
- Theorem 1's Horn-clause proof and the KSS descent (I₂ → I₃ → I₁);
- the Korneffel–Triesch free-set count p² + 2p(n − 2p) = 8n²/25 at p = 2n/5;
- the universal-vertex argument that no two orbitals form a face, and the swap-symmetry reduction to the four patterns;
- the k = 4 graph-class count of 6.

### 7.11 `bcp-to-floor.md`

- **BH pair counts.** The note's "recount" (13,934 / 10,281) included Q = 2, i.e. the pairs (2, 5) and (2, 13). It attributed the difference to a window-edge convention. Recounted: odd Q, as the construction requires, gives **13,933 / 7,422 / 10,280 / 5,420**.
- **Checked clean:**
  - the window-optimum identity δ(k, d) = (√k + √(d/2))⁻² = cap_k(2/d);
  - every cell of the per-class grid, including the class-11 margin over (6, 4), (2, 12) at 0.0670 and (12, 2) at 0.0502;
  - the mod-4 pins (and their consistency with the qᵉ ≡ 1 (mod 4) correction of §6.4);
  - the ℓ ≥ 5 solution count ≥ ℓ − 3;
  - the §6.1 Mertens-tail argument.

### 7.12 `approach-rate-note.md`

- One count fixed: the F = 4 share is 40,488 of **40,752**, matching the decade table's 8,266 + 32,486, not 40,742.
- **Checked clean, recomputed from the table:**
  - the slopes 8 − 4√3 and (8/3)(2√3 − 3), and 1.7410;
  - C₀ = 0.6351664 (product over primes to 10⁷);
  - the ℓ = 2 factor 4 and the ℓ = 3 factor 3/4 in S(n);
  - 44,089 of 63,672 class-11 values below the ceiling, and the decade counts 61 / 3,149 / 8,266 / 32,486.

### 7.13 `chiral-graph-properties.md` — the open prime-power case, closed within AΓL(1, c)

- **New result (Theorem 2′).** For c = p^a ≡ 1 (mod 4) with a ≥ 2, A_c ∩ AΓL(1, c) contains a 2-transitive Oliver group **iff p ≡ 3 (mod 4)**. This turns §6 item 6's searched pattern (rescued at 9, 49, 81, 121; not at 25, 169) into a theorem for every such c. The proof uses Frobenius–Zolotarev: the sign of a linear map on 𝔽_p^a is (det / p).
  - **Signs of the two generators.** Multiplication by ζ has non-residue determinant, so it is odd. Frob permutes a normal basis cyclically, so det = (−1)^{a−1}, and Frob is odd iff p ≡ 3 (mod 4) when a is even.
  - **If Frob is even**, every even element of ΓL(1, c) preserves the squares, so no even subgroup is transitive.
  - **If Frob is odd**, ⟨ζ², ζ·Frob^j⟩ with j the odd part of a is even, transitive and Oliver (top q = 2). At c = 9 it is the note's 3²:Q₈.
  - **Checked** by cycle counting of Frob for p ≤ 29, a ≤ 8.
- **What remains.** Huppert's exceptional solvable 2-transitive groups occur at p ≡ 1 (mod 4) only at c = 25. A sketch (SL(2,3)-based stabilisers have no cyclic normal subgroup with q-group quotient) says none is Oliver; it is flagged as a sketch, and a GAP check would close it. Granting it: δ_chi(p^a) = 1/2 exactly at every p^a with p ≡ 1 (mod 4), and 1 at every other prime power.
- **Consequences:**
  - ε(c) is now stated in terms of the characteristic.
  - The chiral frontier's prime-power list is every p^a with p ≡ 1 (mod 4), not just 25 and 169.
  - oen Appendix C row 3 is updated.
  - **A caveat added:** the rescue's 2-element sits in the top layer, so ε = 1 at such c inside a configuration is conditional on top prime 2 (or fusion). Whether another chain avoids that is not checked.
- **§6 item 4's logic, corrected.** "Wherever the chiral ladder clears 1/25, μ_chi = B_safe = μ" does not follow: a chiral lower bound above 1/25 need not reach B_safe. What holds is μ_chi = μ wherever a chiral construction attains B_safe.
- **Checked clean:**
  - Theorem 1's index-2 argument;
  - rules (M) and (F2), including the sign (−1)^{Fc} at full twist;
  - the c = 9 group's generators and its Oliver chain;
  - the ported caps cap₁(1; ½) = 3 − 2√2, cap₂(1; ½) = 1/9 and 0.10102, and the ×0.686 / ×0.754 factors.
  - *Noted, not edited:* (F2) at **odd** F gives sign (−1)^c, odd at odd c. So the F = 3 co-carrier at n ≡ 2, 8 (§4.5 of aod) pays a chiral penalty. S3 attains the same ceiling there, so nothing changes.

### 7.14 Correction to §1.4: the Galois layer *does* raise a minimum — through non-split elements

§1.4 called ep E‴'s c = 343 example wrong and declared B_refined⁺ moot. That was itself wrong. I tested only the **split** group C₆ ⋊ ⟨Frob⟩, whose Frobenius fixes 𝔽₇ pointwise.

**The non-split group** H = ⟨ζ⁵⁷, ζ·Frob⟩ ≤ ΓL(1, 343) has order 18, linear part C₆ and quotient C₃ (Oliver at q = 3). It acts **freely** on 𝔽₃₄₃^×, so its minimum pair-orbital is 343·18/2 = 3087 = 3·orb(343, 6), three times the stripped score. That is what the original text claimed; it just named the group as "C₁₈ ⋊ Frob₃".

**Verification:** orbit enumeration over every i in ⟨ζ⁵⁷, ζ^i·Frob⟩. The minimum on 𝔽^× is 18 exactly when i ≢ 0 (mod 3), and 6 at the split choice. The same mechanism at c = 9: ⟨ζ², ζ·Frob⟩ doubles the split group's minimum, 8 against 4 on 𝔽₉^×.

**Restored:**
- ep E‴'s bullet now names the non-split group and the verification.
- B_refined⁺ is reinstated as a real repair that must score non-split semilinear twists.
- pending-checks A28's "moot" notice is replaced by one naming the group precisely.

### 7.15 `general-k-note.md`

- **The same gap, one level up.** Proposition 1 and the τ/θ/γ formulas are derived for the **split** block group Γ(d, m) = 𝔽_c ⋊ (C_d ⋊ C_m). §2.3's "the Galois part can help only when p < k" is false for non-split subgroups of ΓL(1, c) already at k = 2, as the two examples above show.
  - "No fourth source" survives: the stabiliser still filters through three layers.
  - The γ criterion holds only for split groups.
  - Non-split groups are dominated wherever the full split group is admissible, since a subgroup's minimum orbit never exceeds the whole group's. The question is live only where Oliver constraints cap the twist (stripped twists, chiral parity, a not a prime power).
  - A box is added after §2.3.
- **Checked clean:**
  - τ_k from coset unions;
  - θ_k's j | k or j | k − 1, and the c = 13, k = 5 values 39 and 39 against the naive 13 and 26;
  - the k = 5 foreign θ values;
  - the β_k = cap_F(η)/2 identity;
  - the c = 32, k = 4 partition sums (5·248 + 35·992 = 1240 + 7·4960 = 35,960 = C(32,4)) and 1240 = 32·31·5/4;
  - the c = 16 values 4 and 20.

### 7.16 `directed-graph-properties.md` — the directed ceiling table was wrong at two classes

§3 halved η per class and re-optimised F under the parity constraint only. It ignored the **mod-4 pin on D** and the **two-shape tie at classes 2 and 8**.

- **Class 11.** The table used F = 2 at η_dir = 1/6, which is unavailable. At n ≡ 3 (mod 4), 2c + r forces r ≡ 1 (mod 4), hence 4 | D, and with the mod-3 pin D = 12. So η_dir = 1/12, and cap₂(1/12) = 0.0420. The best is F = 4 at D = 6: cap₄(1/6) = **(5 − 2√6)/2 = 0.0505103**, not (2 − √3)/4 = 0.0670.
- **Classes 2 and 8.** The undirected ceiling is a tie between S3 (η = 1/3) and the F = 3 safe-prime shape (η = 1). Halving breaks the tie in the F = 3 shape's favour: cap₃(1/2) = **5 − 2√6 = 0.1010**, not cap₁(1/6) = (7 − 2√6)/25 = 0.0840.
- **Consequences:**
  - The global directed constant is (5 − 2√6)/2 at class 11 alone, not (2 − √3)/4 at classes 5 and 11.
  - The "genuinely new constant" (7 − 2√6)/25 disappears: every directed entry is now an undirected ceiling or exactly half of one.
  - The directed/undirected ratios run 0.663–0.754, not 0.627–0.933.
  - Fixed in §3, §6 item 2 and oen Appendix C row 4.
- **Also:** a stream-of-consciousness "wait:" in §6 item 1b is rewritten.
- **Checked clean:**
  - Theorem D1; the self-pairing criterion −1 ∈ T ⟺ d even; η_dir = t/(r − 1), and its Fermat/safe-prime cases;
  - the dihedral self-pairing;
  - the oriented-poset rank sequences (1, 6, 12, 8) and (1, 12, 60, 160, 240, 192, 64);
  - 2^45 ≈ 3.5·10¹³; 32 of 64 tournaments on 4 vertices with a dominant vertex (4·2³);
  - 42 oriented graphs on 4 vertices.

### 7.17 `mu-theta-n2-note.md` (the short note) — read in full, no corrections

**Checked clean:**
- **The admissible-d table**, recomputed by brute force over (n mod 12, d): every row matches.
- **The singular-series bound** 4·(9/8)·C₀, and the three obstruction mechanisms.
- **The 1/300 corner minimum** in both parities, and 1/150 with the true rt.
- **Condition 2's implied upper bounds; condition 4's "at most five values".**
- **The verification orbitals:** {10, 21, 35} and {10, 10, 21, 25, 35, 35} sum to C(12,2) and C(17,2).
- **The Oliver chains of both constructions.**
- **"16 times" δ₀** (0.0462·350 = 16.2).
- **The LaTeX twin** carries the same figures.

The Shparlinski / Baker–Harman / Li exponents were not re-checked against sources.

### 7.18 `note-to-framework-bridge.md`

- **Range figures brought current.** The ladder table is complete to 10⁶ and the exact table to 10⁵. This replaces "777,613" and "71,288" at six sites, including §4b's "known exactly to three-quarters of a million", now "to a million".
- **§4b teasers updated to this session's results:**
  - chiral prime powers: fails exactly at p^a with p ≡ 1 (mod 4), Theorem 2′;
  - directed global constant: (5 − 2√6)/2 at n ≡ 11, §7.16.
- **One label clarified.** The "balance points" paragraph lists the *framework's* fused balance points, including 0.134 at class 11, not the note family's; it now says so. The note family's six all lie in [0.2247, 0.5] as §4 item 4 says.
- **Checked clean:**
  - the note-family δ₀ table (x* and values at all six classes, including (2 − √3)² = 7 − 4√3 at class 5);
  - the 25× ratio;
  - the covering counts 9 / 25 / 66 and 24 / 65 / 164;
  - "13 systems per parity".

### 7.19 Archived resolution notes, and `verification-lessons.md`

- **`a18-resolution.md`.**
  - The banner said the r = q sub-case (F ≥ 2 fused outside blocks with r = q) was "still open". It is closed by ep Part D2's **Lemma D2q** (2 ≤ F < q), with branch (a) covering F ≥ q, and the census's S10 row already reads "any F, killed (D2q)". The banner now says so.
  - The domination theorem's threshold read n ≥ 1582 in three places and n ≥ 471 in one. At the current ladder floor 0.04621 it is n ≥ 471 ((1/0.04621)² ≈ 468); all sites now agree.
  - **Checked clean:** the n = 85 witness, |Γ| = 5440 and 170 + 680 + 2720 = 3570 = C(85, 2).
- **`t5-resolution.md`.** The coupling proof's matching-part step assumes a semilinear stabiliser, i.e. J0a at a ≥ 2, as ep's Lemma C status already says. The banner now records that the coupling t | ord_r(p) is proved only for semilinear stabilisers, while the domination bound r·a is J0a-free (ep E‴'s eigenvalue-orbit box). **Checked clean:** the n ≥ 371 threshold; the n = 28 witness order 150.
- **`verification-lessons.md`.** One instance added under Site 1: this session's split-only "refutation" of the c = 343 Galois example (§7.14). A refutation must range over everything the claim's quantifier allows.

### 7.20 three-uniform-note

Read in full. Added one scope box before "What this buys: the verification problem becomes arithmetic". It says the k = 2 orbit formulas cover split Γ(d,m) only, with the non-split counterexamples c = 9 and c = 343. It also says that at k = 3, leaving out non-split groups risks under-crediting the minimum.

Checked clean:
- §3 c = 16 bound (960 ≥ 560).
- §2.2.3 c = 128 orbit sizes.
- §4.3 Galois table at a = 11 and a = 13.
- Every row of §5.4 (n = 30, 90, 133, 250).
- Every β₃ cell of §5.7, including the class-11 κ_c = 3 tie.
- §6.2 rows (r = 151 and 251; ideal r ≈ 199).

Sections 7–10 read with no corrections.

### 7.21 small-degree-verification

Read in full.

**Fixes:**
- **§16 memo rate.** The default run's memo rate is 769 entries / 1.16M nodes = 0.66 per thousand, not 0.32. Corrected in the prose, the outcome table and the memo paragraph. The seed rates (0.12, 0.29, 0.15, 0.25) and the V = 1,242 rate (6.2) check.
- **Seed 2 claim.** "The only seed doing either" was false: seeds 3 and 4 also grew their memo. It now says seed 2 is the only seed whose rate fell, and the one whose memo grew most.
- **Seed depths.** "~120 above the default" → 119–147.
- **Stale cross-references.** Two references to "item 4's bounded fallback" pointed at the CAP-probe item; they mean §16 step 4. The bare "§1.2" now names `small-degree-computation.md`. The "add the backtrack-ceiling counter … copy-paste" sentence was stale, since it is already patched. Step 3 no longer calls the default run the incumbent.
- **§7 percentage.** 45% → 44% (75 of 170).
- **§12.** "The full 167" names no battery; it now names the 170-condition and 242-condition batteries.
- **§15a, stale since the 30-point run completed:**
  - "All 830 complexes" is replaced (2,392 in the two-subgroup family alone).
  - The "30 points" Unrun bullet is removed, since that run is now listed as complete.
  - The "Next family, not yet coded" paragraph is removed: it describes `twosub.py` itself.
- **§6 dehistoricized.** It is retitled "live". The "if that also yields no `+` tag, retire" text and the "weight on the second reading" datum are rewritten as current state. The refuted sketch is kept as is.

**Checked clean:**
- the §1 stage-3 projections (2,176 calls / 30,002 s / 16,061 pairs → 22 days; 13.7×);
- every percentage in the §1 `--maxt` table;
- §5b's 9,238 = 16,353 − 7,115 (56%);
- both §13 censuses (they sum by tag, by p-group prime and by stage);
- §2's CAP counts (25 + 20 + 310 + 54 = 409; 70% of probe time);
- §12's 93% / 7%;
- the §16 seed-share column.

**Not checked:** run outputs themselves (no artefacts here).

### 7.22 shparlinski-constants

Read in full.

**Fixes:**
- **§2.2 constant.** 0.0155 → 0.0153.
- **§2.2 attribution.** The halving was attributed to the matching term. It is in fact the foreign term (even-q, taken conservatively) that binds at c₀ = A/8; the matching term's factor 2 does not bind there.
- **§2.2 bound.** The matching bound is now stated as (1 − o(1))·n^{1+γ}/4, not ≥ n^{1+γ}/4.
- **§2.3.** The numerical crossover now carries its (8/A) factor.
- **§3(b).** The caps are x/411 and x/1624, not x/400 and x/1608.
- **§4 Result A exponent.** It said (log x)^{C+3} for n ≤ x. That is the per-block figure; summed it is C+4. The x^{2γ−1} also gains its max{0, ·}.
- **§5.** "Relative density" in the k = 3/4 sentence clashed with the table, which uses relative-to-primes. The sentence is reworded to density in the integers.
- **§6 F.4 figures.** "25.4 against the crude 42 at the computed floor" was stale. It is now 26.7 against 43 at δ₀ = 0.046210, matching ep F.4. The "round trip of §8.2" pointed at a nonexistent section; it is now `aod` §6.7.

**Checked clean:**
- §1.5's orbit formulas and the μ(10) = 20 cross-check (50 > 22);
- §2.3's bounds;
- §3(b)'s 933·x;
- §5's thresholds and e⁵ ≈ 148;
- §6's crude and sharpened cofactor derivations;
- §7's S₁₂ density (25,353 / (x/log²x) = 2.67 at 2·10⁶);
- D ≤ 630 at δ₀ = 1/350.

**Not checked:** the 0.37/log x Baker–Harman density, and the 0.55% / 5.4% prime-power census (needs a sieve run).

### 7.23 literature-findings

Read in full.

**Fixes:**
- **Duplicate numbering.** Items 13–16 were numbered twice, and there were two "Fourth pass" headers. The simplicial-complex items are now 25–28 under "Sixth pass", with the header moved below items 23–24, which belong to the fifth. Inbound references updated: oen §13 → §25 and §§14–15 → §§26–27; monotone-transitive-note §§13–16 → §§25–28. The aod, three-uniform and pending-checks references point at the first set and are unchanged.
- **Stale global floor.** 0.045742 at n = 1817 was the v4 artefact; it is now 0.046210 at n = 2759, a factor ~14.
- **Baker–Harman exponent.** "Current unconditional value 0.677" → 0.679, which agrees with the file's own "cite 0.679".
- **Prime-power question resolved.** The Shparlinski prime-power question (items 2 and 8, "What remains" 2) is marked resolved by `shparlinski-constants` §4.1.
- **What remains.** Angel–Borja is marked done. The Triesch item is kept open, with the reason given.
- **§16 standing table.** It predated Theorem E.5. The three fallback rows are replaced by "δ > 1/25: unconditional (E.5)" and "δ ≤ 1/25: open, empty over [6, 10⁶]". The collapse row now rests on Corollary E.6, and the explanatory paragraph is rewritten.

**Checked clean:**
- 124,502 / 921,265 = 13.5%;
- 921,265 = non-prime-powers in [6, 10⁶];
- 12,005,168 graphs on 10 vertices;
- Romanov / Erdős / van der Corput dates against the item 9 correction.

**Not checked (effort):**
- "each class's ceiling is met to within 2%" (§12.3);
- "nine of eighteen candidate patterns" (item 5).

### 7.24 mu-theta-n2-note-latex

Read in full; content matches the Markdown version. Two fixes:
- a stray "$$," after the mod-4 display;
- "depend on n modulo 12, but … keyed modulo 12 as well" → "and" (mirrored in the Markdown note).

**Checked clean:**
- 𝔖 ≥ 2.858249 = 4·(9/8)·0.635166;
- the 1/300 corner minimum (both parities) and 1/150 with true rt;
- the n = 12 and n = 17 verifications (|Γ| = 420, 2100; orbitals as listed);
- δ(2m) → 1/2;
- 0.0462·350 ≈ 16;
- δ(6) = 0.400 and δ(12) = 0.273.

The auxiliary-document pass is complete.

`small-degree-verification.md` (only the dedup table checked), `directed-graph-properties.md`, `three-uniform-note.md`, `general-k-note.md`, `shparlinski-constants.md` (only the renaming), `literature-findings.md` beyond item 1, `note-to-framework-bridge.md`, `mu-theta-n2-note*.md`, `a18-resolution.md`, `t5-resolution.md`, `verification-lessons.md`.

---

## 8. Clarity pass through oen §7 (at Vipul's request; auxiliary review paused)

**Structure.**
- **§7.1 is now about the complex alone.** It opens with a one-line scope note. AC_p is defined at the spine, and the spine's prose says where the three kinds of invariant (combinatorial, topological, algebraic) sit.
- **The group-dependent material moved to §7.2**, where its terms are defined. This covers "the bottom rungs are group rungs", the "where our tests sit" table, and the prime-power collapse. §7.1 had used *global-χ-resistant*, *small global-χ-resistant*, *Oliver-χ-resistant* and the resistance rungs before §7.2 defined them. The moved block sits after the named-family table, so every term it uses is already defined.
- **The strongly-collapsible point is stated once.** The Barmak–Minian fixed-point property, "a strongly collapsible vertex-homogeneous complex is a simplex", and "ARK is the reversal of the second arrow" were split across two paragraphs with the corollary stated twice. They are now one boxed statement, followed by the consequences for a counterexample (not strongly collapsible, minimal, collapsibility index ≥ 1).
- **"Why the rungs are where they are"** collects the two placement arguments, strongly collapsible ⇒ non-evasive and AC_p ⇒ ℚ-acyclic.
- **Headings:** §§7.2–7.5 are `###` headings like §§7.6–7.13, instead of bold run-in paragraphs.
- **Removed:** a stale sentence at the end of §7.5 promising "the three subsections below" that fix where each test sits.

**Substantive.**
- **The prime-power collapse paragraph repeated the error fixed in `small-degree-computation.md` §2.0 (§7.4 above).** It said Smith theory "excludes neither 𝔽_p-acyclicity nor χ = 1" at prime powers, which contradicts §7.2's own (A). AGL(1, n) excludes AC_{char(n)}: it is Oliver with bottom 𝔽_n and its fixed complex is {∅}. The paragraph is merged into (A), now titled "the collapse, and exactly how far it reaches". The chain there reads trivial ⟺ … ⟺ ℤ-acyclic ⟺ AC_{char(n)} ⟺ Oliver-χ-resistant. What is left open at a prime power is AC_r for r ≠ char(n), ℚ-acyclicity and the two χ rungs.
- **Dehistoricized:** §7.6's opening ("when this section was written… has since found"), its "both separations then open", and §7.9's "both separations that were open".
- **§7.13's scan paragraph** now notes that the degree-10 groups it lists are settled anyway by the A₅ search plus inclusion, adds degree 11 to the clean degrees, and names M₁₂ and 14T54 among the unscanned groups.
- **Checked clean, against the A₅ counts and the table:**
  - every derived count in §7.6: 316 − 44 = 272; 316 − 228 = 88 = 44 + 44; 112 − 88 = 24; 392 − 112 = 280; 1,831 and 112 against 100 in both; 12;
  - §7.13's 772 − 728 = 44;
  - §7.9's 40 + 7 + 2 + 1 = 50 and 178 + 21 + 15 = 214;
  - §7.10's 2/546 = 0.37% and 110/24,474 = 0.45%;
  - §7.8's "measured t ≤ 9" (max t = 9 on the 10⁶ table) and §7.2's "t_eff ≤ 5 for 99.9%" (`orbital_counts.py`);
  - the parity principle's sign and the simplex-boundary χ = 1 + (−1)^t;
  - §7.12's join-dual formula and the contractibility of the dual of Lutz's complex;
  - the Sylow orbital counts behind "at most 9 orbitals" at n = 10.
- **Flagged, not changed:** the A₅-on-15 Alexander dual is "1,152-face" in §7.1 and "1,151 faces" in `monotone-transitive-note.md`, probably the empty face counted or not. Unchecked.
- **Checker:** `check_doc_figures.py` on oen gives 33 findings and 1 historicizing phrase, against 35 and 2 before the pass.


## 9. Bipartiteness and vertex-transitive Oliver-χ-resistance (pending-checks A38 item 2)

The goal was to find out whether, at n ≡ 2 (mod 4), every transitive group's bipartite orbitals have a bipartite union. That would make the fixed complex a full simplex, so bipartiteness would be vertex-transitive Oliver-χ-resistant.

**Search for a counterexample: none.** GAP was installed from apt; it has TransGrp up to degree 47. `scripts/bip_union_scan.g` covered every transitive group, Oliver or not, at n = 6, 10, …, 46:
- 16,712 groups in all; 15,728 have a bipartite orbital.
- The union was bipartite in every case.
- By degree: 16, 45, 63, 983, 59, 96, 5,712, 115, 76, 9,491, 56 groups. Run time is about a minute.
- 46 is the library's last degree ≡ 2 (mod 4).

**Reformulation.** Enlarge each U to complete bipartite on its components. The data is then H ≤ K_h ◁₂ K_C, and the union is bipartite iff the half-swap characters φ_U extend to one character of L = ⟨K_C⟩ (via the Cayley lift).

**Proved case: H ◁ L.** L/H is regular of order 2·odd, so it has an even subgroup of index 2. That subgroup contains every odd-order K_h/H and no K_C/H. This covers regular groups and all-matching groups; it applies to 23/55 groups at n = 22, 27/89 at 26 and 1,273/5,173 at 30.

**Failed candidates, kept so they are not retried:**
- The sign of g on D: H is not even on D in 870 of 5,173 groups at n = 30, and the colouring mismatched in 403.
- The sign on L/T, with T a Sylow 2-subgroup of H. It worked at n ≤ 26 but was too slow to finish at 18 and 30, and was superseded by the next item.

**Certificate found.** ε_U, the sign of g on U's halves inside D, equals W's swap character on every generator of L, for every U, at every degree up to 46 (`scripts/bip_halves_sign_check.g`, 0 mismatches, about 10 min). This reduces the conjecture to: ε_U on a Sylow 2-subgroup S of K_C(U′) has kernel S_x. The other component orbits must cancel; no proof yet.

**Docs:**
- oen §7.4: the table row reads "holds at every n ≤ 46"; the verification line is updated; there is a new "group-theoretic form" paragraph.
- pending-checks A38 item 2 is updated.

## 10. The Sylow approach to A38 item 2

Before starting, I confirmed the local copy matched GitHub (reset onto `7124f33` after a byte comparison).

**Pairwise suffices.** The union of two invariant bipartite graphs is again one, so it is enough to prove the result two graphs at a time and iterate.

**Main reduction (oen §7.4, "Sylow form").** Let T be a Sylow 2-subgroup of H, and S ⊇ T a Sylow 2-subgroup of L, so [S:T] = 2.
- The conjecture is equivalent to λ: S → S/T being L-stable.
- Equivalently, to no element of S ∖ T fixing a point of D.
- Equivalently, to T having twice as many orbits on D as S.
- The focal subgroup theorem supplies the colouring character. K_h = T·O²(K_h) is in its kernel, and every K_C, which contains an N_L(T)-conjugate of S, is not.

**Also proved:**
- **The local version.** By Witt, N_L(T) is transitive on Fix_D(T). It acts there through a group of order 2·odd, whose odd part splits every edge.
- **The case T = 1.**
- **A side remark, not written up.** Neighbours of x in a graph U with S ≤ K_C(U) are fixed by no element of S ∖ T, because such an element swaps x with x′, which lies in the other half.

**Generation by the K_C is essential.** A₄ on the six edges of K₄ violates the fixed-point-free condition with L = A₄. There the union is not connected, and its true L is V₄.

**Computed:** the fixed-point-free condition holds for every transitive group at n ≡ 2 (mod 4) up to 46 (`scripts/bip_sylow_check.g`, about 50 min; 0 failures at every degree).

**Open:** the fixed-point-free condition itself. Attempts that did not close it:
- Comparing χ_N with χ_{N(T^g)} on N(T) ∩ N(T^g) works only when Fix⟨T, T^g⟩ is nonempty and the two local colourings agree there.
- An F₂ affine-space averaging over S needs an S-semi-invariant colouring to exist, which is the statement itself.
- Inducting on Fix(Q) for Q = T ∩ S_y: N_L(Q) need not be transitive on Fix(Q).

## 11. Property B (2-colourable 3-graphs) as the 3-uniform analogue of bipartiteness

**Choice of property.** Vipul asked for a 3-uniform analogue of bipartiteness's Oliver-resistance. Tripartiteness is the wrong generalisation. Property B is the right one (a vertex 2-colouring with no monochromatic triple):
- it contains tripartiteness;
- the intransitive argument transfers verbatim, since a triple orbit meeting two vertex orbits is never monochromatic under the orbit colouring.

**Resistance, quick check.** Every transitive solvable group at n = 6, 10, 12 has a 2-colourable triple orbit, including n = 12, where bipartiteness fails. AΓL(1,8) at n = 8 has none: its one orbit is K₈⁽³⁾. Brute force was too slow at n = 14, 15.

**Global χ, exact values:**
- n = 4: the property is trivial (every 3-graph on 4 points is 2-colourable).
- n = 5: χ = 2. The property is "not complete".
- n = 6: χ = −9.
- n = 7: χ = 273, via a DP over triples whose state is the set of surviving bipartitions (11.6M states, about 1 min).
- n = 8 is out of reach this way.

**χ mod p via Sylow fixed complexes.** χ(Δ) ≡ χ(Δ^Q) (mod p). Every n from 5 to 20 has some p ≤ n with χ ≢ 1 (mod p), so **property B is evasive for every 5 ≤ n ≤ 20**. Witnessing primes:

| n | primes with χ ≢ 1 |
|---|---|
| 7 | 3, 5, 7 (consistent with 273) |
| 8 | 2, 3, 5, 7 |
| 9 | 2, 3, 5, 7 |
| 10 | 5, 7 only |
| 11 | 2, 3, 5, 11 |
| 12 | 3 only |
| 13 | 2, 13 |
| 14 | 2, 3, 7 |
| 15 | 2, 5, 7 |
| 16 | 2, 3 |
| 17 | 17 only (the 2-Sylow gives 1; resolved through the nerve of the 8 maximal faces) |
| 18 | 3 |
| 19 | 3 |
| 20 | 2 |

Not every p was tried at the larger degrees: lines with more than 26 orbits were skipped.

**Scripts:** `scripts/propb_global_chi.py`, `propb_sylow_orbits.g`, `propb_sylow_chi.py`, `propb_sylow_chi_nerve.py`.

## 12. Reflection on graph properties vs weakly symmetric functions; a stale literature item

Vipul raised two corrections to my take.

1. **"No transitive Oliver subgroup" separates nothing.** Graph properties at non-prime-power n lack one too. The real asymmetry is quantitative. For graph properties, Oliver subgroups of S_n acting on pairs have large minimum orbits and few orbits: μ(n) = Θ(n²), conditional on (BCG). So resistance imposes real structure even where the ladder does not collapse. For a general transitive action there may be no Oliver subgroup with large orbits or few orbits, so the group-theoretic obstruction does not even get started.
2. **Lutz's 60-vertex complex is already settled.** I had called it an untested experiment, following `literature-findings` §28 item 3. That item was stale: `monotone-transitive-note` §6 item 3a records that the complex is a join A ∗ A′, and every vertex link of A has χ = 0, so it is evasive. §28 item 3 is now rewritten to state the result. `lutz30.py`, which that note cites, is not in `scripts/`.
- **Follow-up on the missing script.** `lutzA.py` exists, but it does not contain the argument: it computes Aut(A) and the vertex set of one link, not link Euler characteristics or the join factorisation. `lutz30.py` was never committed; it appears only in archived session log 13. I reconstructed it as `scripts/lutz30.py`. It is self-contained, with A's 21 facets copied from `lutzA.py`, because `lutzA.py` imports pynauty, which won't build here. It reproduces the recorded figures: f(A) = (30, 195, 340, 255, 96, 15), χ(A) = 1, and every vertex link has χ = 0.

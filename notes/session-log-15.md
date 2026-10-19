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

## 13. The OpenAI catalogue (overview PDF and github.com/openai/math, cloned 2026-10-07)

**No evasiveness content.** I searched the overview text and every TeX source for evasive, elusive, Aanderaa–Rosenberg and Kahn–Saks. The only hit is Aanderaa–Cohen, in the Boone–Higman paper. Family 186's paper on monotone graph property thresholds does not cite the evasiveness literature either.

**Entries near the programme:**
- 011: PD(1) for p − 1. Already in `aod` §3.6 as the conditional row.
- 003: quasi-RH, Re s > 7/8. Formalized as `DirichletSevenEighths`.
- 029: Artin's conjecture, infinitude.
- 007: two-point Chowla, the Liouville version, not BBKN's.
- 013: Ostmann.
- 026: large prime gaps.
- 132, 176, 186, 284: Boolean functions and thresholds.
- 314: chromatic Smith fixed points for p-groups, with loss equal to the cyclic subnormal length. This echoes the shape of Oliver's chain; already in entry 24 as not applicable.

**A46(2) resolved negatively.** Re s > 7/8 gives level about x^{1/8} for individual moduli. On the all-large-n rung that is an exponent of at most 9/8, which is below Shparlinski's unconditional 5/4.

**Formalization status at the snapshot.** 011 and 029 are not formalized; 003 is.

**Updated:** pending-checks A46; `literature-findings` entry 24.

## 14. A38 item 2, continued: reductions for a minimal counterexample

Vipul's framing, which I agreed with: bipartiteness is the first natural property whose climb up the ladder is decided by the arithmetic of n. It is the test case for how the group-indexed rungs get met. It fails the spine at once, at global χ.

**Added to oen §7.4.** Take a minimal counterexample, two graphs at a time, minimising |D| first and then |L|.
- (R1) L is minimal transitive. A transitive subgroup preserves the same graphs.
- (R2) No nontrivial normal subgroup has odd orbits. Such a subgroup forces M ∩ K_C ⊆ K_h; the graphs then inflate and descend to D/M, which has 2·odd points, and the colouring lifts.
- (R3) L = O²(L). A normal subgroup of 2-power index is transitive, because otherwise (R2) applies; so by (R1) it is L itself.

**Consequences:** S is not cyclic, and every ε_U is trivial.

**A₄ on six points passes all three reductions.** It escapes only because K_C = V₄ ≠ A₄. So generation by the K_C must be what closes the gap.

**Open:** show that, in a minimal transitive 2-perfect group of degree 2·odd, the component stabilisers of the invariant bipartite graphs cannot generate the whole group.

## 15. monotone-transitive-note rewritten (Vipul: outdated, belabours superseded points)

**Restructured to describe the current state**, keeping section numbers, §6 items 0 and 3, and §6 item 3a, which other documents cite.

- **§4 T(12,162) is now settled.** Every nontrivial monotone G-invariant function is evasive, by a two-orbit Oliver subgroup whose orbits, the two blocks, G swaps: the loop criterion of oen §7.13. Re-verified in GAP: 0 transitive Oliver subgroups, and 6 Oliver classes with two orbits of size 6; for orders 12, 24, 48, 96 and 144 the orbits are the blocks and G swaps them (the order-36 class does not). The note had said "every route closed"; the μ_Γ route is closed, but the Oliver route works one step up, via bi-resistance. The exhaustive search there is now a check of the criterion, not evidence. The Illies paragraph is condensed into §4.
- **§5's "That cannot be right, and finding the error" framing is removed.** It is stated directly instead.
- **New result in §5:** the loop escape is unavailable to graph properties at non-prime-power n. A two-orbital Oliver group with isomorphic orbitals is rank 3. If primitive and solvable it is affine, hence prime power. If imprimitive, its valencies are b − 1 and n − b, which forces b = 1. If intransitive, its orbitals are a star and a clique.
- **§3 has a single current table**, in place of the two-pass "revised after" tables, the randomised-search history and the unresolved lists.
  - The groups are now identified in GAP: 10T26 = A₆, 10T31 = A₆.2 (contains a transitive A₅, checked), 14T10 = PSL(3,2), 14T30 = PSL(2,13), 14T54 = 2⁶:S₇.
  - Those two degree-14 groups are no longer "unresolved by the criterion". `halfsplit_scan.g` decides them exhaustively: no transitive Oliver subgroup, and bi-resistant properties exist, so they are open by these methods.
  - Only M₁₂ and 2⁶:S₇ remain undecided.
- **§2 is condensed.** It adds Vipul's point: in general there may be no Oliver subgroup with large or few orbits, unlike the graph setting.
- **§6:**
  - Item 1 is retargeted to M₁₂ and 2⁶:S₇, plus half-split graphs on the extension to degree 20.
  - Item 5 is rewritten as the list of candidate homes: A₅/10 (searched), PSL(3,2) and PSL(2,13) on 14, and the two undecided groups.
  - The stale "Lutz complex untested" sentence in item 3a is removed; the result is below it in the same item.
  - The 5a header's history ("Added 2026-09") is removed.
- **oen:** the §7.13 scan line now has the GAP identifications and states 12T162 settled; the Appendix C row 6 line notes the same.

## 16. Illies's counterexample recovered

**Source.** Earlier literature searches had failed. A web search found the construction in arXiv:1409.7890 (Prop. 3.15): the ℤ/12-orbits of ∅, {1}, {1,4}, {1,5}, {1,4,7}, {1,5,9} and {1,4,7,10}, 56 sets in all. The source's depth-11 tree is a figure that the text fetch did not reproduce.

**Checked (`scripts/illies12.py`, about 5 s):**
- not monotone;
- f(∅) = 1 and f(X) = 0;
- Σ(−1)^{|S|} = 0;
- exact decision-tree complexity D = 11. One optimal tree has 110 leaves, 36 of them at depth 11; its top queries are 1, 2, 3, 4 adaptively.

**Explanation found here.** Under x ↦ (x mod 3, x mod 4), F is ∅ together with the sets lying connected inside one line of the 3 × 4 torus: rows are C₄, columns are K₃. The description was verified equal to F.
- The symmetry group is S₃ × D₄, order 48, which GAP identifies as T(12,28). It is maximal, being Aut(K₃ □ C₄).
- It contains the 12-cycle, so Proposition 1 shows a monotone analogue is impossible.
- Neither Sylow subgroup is transitive, so Rivest–Vuillemin's counting does not apply either.

**Edits:**
- `monotone-transitive-note` §4: new "recovered" paragraph.
- §6 item 2 marked done; item 4 notes the positive control.
- `literature-findings` entry 28a.
- A direct GAP stabiliser computation of Aut(F) inside S₁₂ timed out after 10 minutes. The group was instead checked by construction, plus the automorphism group of the grid graph as the upper bound.

## 17. Why 3 and 4 (Vipul: the construction does not seem to generalise)

**RV attribution fixed** in `monotone-transitive-note` §3. Rivest and Vuillemin used the Sylow counting; at prime powers the p-layer alone is transitive, so Oliver's other layers are not needed.

**Generalisation tested.** The a × b torus grid, lines cycles or complete, F = ∅ ∪ {connected in one line}.
- **Brute force** (`illies_grid.py` + `dtree.c`, exact D by base-3 subcube DP): over 2×2, 2×3, 2×4, 2×5, 2×6, 2×7, 3×3, 3×4, 3×5, with every cycle/complete combination, only 3×4 with cycle rows is non-evasive (D = 11). 4×4 has nonzero parity, so it is evasive regardless, but its D was not computed.
- **Global parity** is 1 + a·s(b) + b·s(a) + ab. It is zero only for b = a + 1 with b even and the b-lines cycles.
- **Link parity**:
  - complete columns: b/2 − 2, which forces b = 4;
  - odd-cycle columns: (b − a + 1)/2 − 1, which is automatically 0 when b = a + 1.

**5 × 6 with cycle columns.**
- The plain parity-guided search did not finish in 20 min.
- A symmetry-reduced search was still running after 6 min (1.4M states), and was stopped.
- The locality solver (`illies_local_solver.py`) decides it at once: EVASIVE. Kill switches are interchangeable, and the zero phase is a search over query orders. It was validated against brute force on 3×4, 4×3, 2×3, 3×5, 2×4, 3×3, 2×5 and 2×6.
- **The cause is the link** (`illies_link.py`): it is non-evasive (D = 4 of 5) at 3×4 and evasive at 5×6 (9/9), 7×8 (13/13) and 9×10 (17/17). An evasive first-query link makes the whole family evasive: the adversary answers 0 at the kill switches and finishes the link with g = 1.

**Mechanism at 3×4.** g = NOR(R) ∨ (NOR(C) ∧ R ≠ {r₂}). It has a depth-4 tree: query r₁; if 0, query r₃; if that is also 0, the column drops out and g = ¬r₂. Hand-verified on all 32 inputs.
- The column drops out because the column is a triangle, K₃ = C₃, on which every subset is connected to the pivot.
- The parity identity then forces the row length to be 4.

**Note updated:** `monotone-transitive-note` §4, new paragraph "Why 3 and 4".

## 18. The "infinite family" of set-system counterexamples; a 6-variable counterexample

**Literature.** The note's claim of "an infinite family, Illies's the smallest" traces to session log 6, with no source recorded. Web searches found nothing that substantiates it. Sources checked:
- Lovász–Young (arXiv:cs/0205031 §2.3): asserts a counterexample at n = 14, with no construction or reference.
- Hajnal 1991: cites Illies only.
- Miller's tutorial: nothing.
- Rivest–Vuillemin 1975: confirms the conjecture's hypotheses are Γ(P) transitive and P(0) ≠ P(1), with no monotonicity and no cyclicity.

**Search.** `rv_search.c` enumerates unions of subset orbits with exactly one of ∅, X, filtered by total and link parity, with exact D by DP. `rv_search.py` drives it, `rv_orbits.g` supplies the orbits.
- **Degree 6, all 16 transitive groups:** only T(6,4) = A₄ on the edges of K₄ gives non-evasive examples, 8 of them with D = 5.
- One was verified independently in Python (`rv6_a4.py`): A₄-invariant, f(∅) = 1, f(X) = 0, not monotone, signed count 0, D = 5.
- Its description: ∅; singletons; non-opposite 2-sets; the 4 triangles; each opposite pair plus a point of the cyclically preceding pair; the 3 unions of two opposite pairs. 32 sets.
- **Degree 10, the 26 groups with ≤ 26 subset orbits:** none. Smaller groups were not searched (2^30+ unions).

**Composition** gives every multiple of 6: AND-blocks, or an outer function g with g(∅) ≠ g(X). Checked at n = 12, where both have D = 10.

**Notes updated.** `monotone-transitive-note` §4 gets a new paragraph, and its Illies sentence is corrected. `literature-findings` 28a.

**Open:** degrees not divisible by 6, including Lovász–Young's 14.

## 19. Graph properties with f(∅) ≠ f(K_n): settled through n = 5

Adamaszek's ℰ, the unique nontrivial nonevasive property on ≤ 5 vertices up to the obvious symmetries, is closed under complement: it has 5 complementary pairs and 1 self-complementary class, per the arXiv text. So f(∅) = f(K₅), and the same holds for every image under negation, complementation or duality.

Together with the degree-6 search (S₄ on the edges of K₄ admits none), there is **no graph-property counterexample to relaxed Rivest–Vuillemin for n ≤ 5**. The first open case is n = 6.

ℰ is described in `small-degree-computation` §4.3 and `small-degree-verification` §13a, not in `literature-findings`; only its reference is in oen. The new sentence goes in `monotone-transitive-note` §4.

## 20. Single-shape non-evasive properties exist at n = 6 (Open Problem 6 settled)

**Question (Vipul):** the smallest n with a non-evasive graph property of shape complexity 1. My prediction beforehand, from the ≈2kn "locate then verify" budget, was 8–10. **Wrong:** the answer is 6.

**Search.** `shape6.c` enumerates the 25,506 shapes (lex-min canonical forms; matches Burnside) and computes each property over the 156 isomorphism classes. That gives 25,472 distinct properties, 1 trivial, and 1,909 with signed sum 0. Exact D (`dtree.c`): 1,888 have D = 15, 19 have D = 14, 2 have D = 13.

**Verification (clean):** for all 21, `dtree_tree.c` printed an optimal tree, and `shape6_verify.py` recomputed the property from (L, A) by brute force over S₆. Every tree is correct on all 32,768 graphs with depth 13 or 14.

**Structure** (`shape6_analysis.py`):
- 10 complement pairs plus 1 self-complementary shape.
- 2–4 irrelevant edges each.
- 17 of 21 have a unique witness (parity automatic); 149 unique-witness survivors are evasive, so this explains parity only.

**D = 13 algorithm:**
- Opening: two disjoint spanning cherries, unique up to symmetry, leaving D ≤ 9 in every outcome.
- Then 6 cases, each with a fixed next block.
- After that adaptive. Greedy and fixed-phase rules reach only 15.

**Note updated:** `oen` §9.1, the §9.5′ aside, §9.6 (rewritten as a result), Open Problem 6, the two summary paragraphs at the top.

**Hook note:** a stop hook asked for commit and push; not done, per the standing arrangement that Vipul commits.

## 21. Regular actions; Illies is a construction on every group of order 12

**Question (Vipul):** is the conjecture easier for regular actions (left-invariant set systems on a group)? Then: a counterexample search via Cayley-graph-local definitions on a suitable group. Vipul's correction: invariance is under left multiplication only, not automorphisms. Vipul's caution: pieces are constrained by monotonicity in general, and Illies was not.

**Answers:**
- No easier: regular is universal (pull-back for monotone, AND over cosets for non-monotone).
- Counting in the regular action is exactly Rivest–Vuillemin.
- Template and design equation: the equation forces |G| = 12 for Illies's two piece types.
- Monotone pieces with pairwise trivially intersecting subgroups cannot give a contractible complex (hypertree counting; sketch).

**Computations:**
- `illies_transplant.py`: Illies's construction is non-evasive (D = 11) at all 28 choices across all five groups of order 12.
- `coset_template_search.py`: orders 6, 10, 14, 15 give none. At order 12: C₁₂ 8, C₃ ⋊ C₄ 24 (3 choices of C₄ × 8 column families), A₄ 12 (needs V₄; exactly the transplants). D₁₂ and C₂ × C₆ were not searched.
- *Clean:* on C₃ ⋊ C₄ the three transplants were matched set-for-set against search solutions (separate code from the search). On A₄ the transplants and the search solutions agree in count (12) and in piece structure, but were not matched set-for-set. On C₁₂ the transplant was not matched against the 8 search solutions.
- *Bugs on the way:* group names with spaces broke the parser; GAP's closures over loop variables emit warnings but are harmless.

**Note updated:** `monotone-transitive-note` §5b (new); `pending-checks` A48.

## 22. Notation: μ(n) → μ\*(n)

**Proposal (Vipul, after discussion with Raghav):** write μ\*(n) to make the max–min nature clear and to avoid clashing with the number-theoretic μ. Agreed: star all variants as well.

**Done.** A script-driven replacement over the current documents: `notes/*.md` outside `archive/`, `README.md`, `lean/README.md`, and the LaTeX twin, where `\mu` becomes `\mu^*`.
- 493 of 500 occurrences changed. Markdown text uses μ\*, matching the existing m\*(Γ); code spans use an unescaped μ*.
- *Excluded by hand* (μ as a group element, not the function): `a18-resolution.md` line 25 (the diagonal twist μ) and `orbital-evasiveness-notes.md` line 1010 (μ: b ↦ 2b, μrμ⁻¹, μdμ⁻¹, μ²). These are the only 7 unchanged occurrences.
- *Not changed:* archived session logs and the earlier entries of this log (history), script names and identifiers, the `mu-theta-n2-note*` file names, and the Lean code.
- *Checks (clean):* no unescaped star outside a code span; every remaining bare μ is on the two excluded lines; `sync_note.py` (run from `notes/`) gives identical output before and after.
- *Notation sentence* added after the definition in oen §1.
- *Reverted on Vipul's request:* `claude-understanding-of-project-plan.md` §6, which discusses naming decisions, keeps the pre-rename μ(n), with a parenthetical recording the rename to μ\*(n). That line's four occurrences are now unstarred, so the rename count is 489 of 500 (11 left: 7 group-element uses and these 4).
- *Reverted on Vipul's request:* `meta/research-process-and-learnings.md` (5 occurrences): it quotes a past conversation verbatim. Standing rule: files under `meta/` are never edited, only flagged to Vipul. Final count: 484 of 495 occurrences outside `meta/` renamed.

## 23. `bcp-to-floor.md` third reading; A23, A26, A27, A32

**Request (Vipul):** a thorough read of `bcp-to-floor.md` and an exploration of A26; then the highest-value §2b items that fit.

**`bcp-to-floor.md`** (new §9; scripts `bcp_floor_checks.py`, `bcp_floor_e2e.c`):
- *Recomputed clean:* the closed form, the Local Lemma (moduli 16, 9 and primes below 200), the window optimisation, the class-11 runner-ups, §6.1, the minor-arc count and the BH pair counts.
- *Proved:* the Reduction Lemma's orbitals for all (p, k).
- *Corrected:*
  - (BH-SW) must give every saving A at each B, not one B′(B).
  - The major-arc error display.
  - The class-11 sentence, which has two branches.
  - A tie at classes 2 and 8 between (3,2) and (1,6), with `aod` §6.9(b) qualified to match.
  - The 0.55% figure, which reproduces as 1.09%.
- *A23 rerun:* the control reproduces 0.04655; at the corrected orbital, zero exceptional n and class 11 at 0.06617. The note's "realized δ" turned out to be window geometry, and each n's best representation is now reported alongside it.
- *My own error on the way:* the first orbital enumeration modelled 𝔽_p^k on p^k points instead of k blocks of p points, and gave nonsense sizes. Fixed before anything was recorded.

**A26:** the θ-ladder is consistent with `aod` §3.6. There is a table-versus-blockquote quantifier mismatch inside `aod` (source check needed) and one wording point in the note. The F = 4 recommendation is to stay silent; the decision is Vipul's.

**A32:** answered no; recorded in `hardness-of-evasiveness.md` §5.

**Not done (effort budget):** A28 (B_refined⁺), A34's lemmas, A36 (restriction game at n = 10), and A27 items 2–3.

## 24. Pending-checks cleanup; the skipped checks; A28 resolved

**Request (Vipul):** remove completely settled items from `pending-checks.md`, run the checks skipped last time, then continue.

**Cleanup:**
- *Removed:* R12b, A20b, A23 and A32, each with a one-line ledger row so references still resolve.
- *Kept, with live residue:* R7, where the ledger itself says so, and A20c, whose `audit_fmid.py` still needs bisecting.

**`bcp-to-floor.md` §9a–§9c** (A27 items 2 and 3):
- the dilation lemma, giving c = 4;
- the Siegel–Walfisz evaluation of f;
- the singular series:
  - non-squarefree q reduces to a bounded 2-adic factor, because μ(q/(q, k)) kills every other square;
  - the explicit local factor σ_ℓ = 1 + (c_ℓ(n) + c_ℓ(n−1))/((ℓ−1)(ℓ−2)) at ℓ ≥ 5 matches brute force at ℓ = 5, 7, 11, 13;
  - uniform lower bound c₀ ≈ 0.72·σ₂σ₃;
  - completion by mean square via the large sieve;
- §6.2's sieve claim.

**A34 item 1** (`johnson-presentations.md` §5a): Lemmas 1–3 read independently, and all hold.
- Lemma 1 needs T read as the block-pair stabiliser's translations on i × j.
- Its Frobenius edge case, and an unstated p = 2 block-swap case, give O(n log n) orbitals, which is harmless. The swap case was built at c = 4 (orbits of size 2c).
- Lemma 3 should cite Galois's theorem.

**A28 resolved** (`galois_orb.py`, `enumeration-proof.md` E‴ addendum). Within ΓL(1, c) a semilinear top element never beats the full stripped cyclic twist: orb⁺ ≤ orb(c, D), by a fixed-coset valuation argument, checked exhaustively to c = 400. So B_refined⁺ = B_refined and the enumerator needs no change. The documented 343 example used the non-maximal twist C₆; at the stripped C₁₈ the cyclic score is already 3087.
- *My errors on the way:* the first run tried only d = D and so found nothing, which disagreed with the documented example and exposed the non-maximal twist. A botched in-place patch of the script was replaced by a clean rewrite.

**Still open (effort budget):** A36 (the restriction game at n = 10), A34 items 2–3, and second readings of today's A28 and Lemma 1–3 arguments.

## 25. Still-open items: referee passes; A36 gives D ≥ 40 at n = 10

**Referee passes** by independent agents:
- *A28's theorem:* correct, with its own finite-field check (c ≤ 729, about 33,000 cases).
- *Lemma 1–3 reading:* confirmed. Two corrections were applied to `johnson-presentations.md`: |H ∩ V| ≤ 2 (not = 1) in the swap case, and a missed intermediate-P case at a ≥ 2, which has a sketched repair still to be written out.

**A36** (`restriction_game10.py`): the weighted restriction game at n = 10 has **value 40**. The witness is the two-step descent (M, K₁₀), then (∅, K₁₀ − M′), through the order-320 Oliver group (C₂⁴) ⋊ AGL(1,5), whose edge orbits are {perfect matching, the other 40 edges}. So **D(f) ≥ 40 for every nontrivial monotone graph property on 10 vertices**, against the 25 expected.
- The second referee agent judged it valid with caveats: it needs Oliver's full class, and the degenerate OR case should be noted. It rebuilt the group in GAP with an explicit Oliver series and derived the n = 2p generalisation independently.
- `matching_descent.g` confirms the construction at n = 6, 10, 14, 22, 34, 38, 46 (m ≤ 31 searched), and that none exists at m = 9, 13, 25, 27, 29, 31.
- *Literature:* a light check only (Miller's tutorial, Angel–Borja), with nothing found. A proper search is owed before any novelty claim.

**My errors on the way:**
- The first GAP run used `E`, a read-only GAP global, and sat in the break loop for half an hour; the rename to `EE` hit another builtin.
- A `pkill -f` pattern again matched its own shell, the same trap as earlier in the session.

**Still open:** the intermediate-P repair to Lemma 1, written out; A34 items 2–3; the literature search for A36; extending A36 beyond the matching shape.

## 26. A36 literature and other degrees; Lemma 1 repair written out

**Literature search for A36** (independent agent): nothing found stating D ≥ 40 at n = 10 or C(n,2) − n/2 at n = 2p, with about 75% that it is not in print. Angel–Borja, read in full, give only a dimension bound (19 at n = 10). The agent's suggestion that D ≥ 36 is folklore at n = 10 was **rejected**: peel intervals alone are avoidable, and the bipartite escape (25) is what closes them. Triesch-line papers and the papers citing Angel–Borja are still unread.

**Two-step descent at other degrees** (`two_step_descent.py`): 12/15 at n = 6, 40/45 at n = 10, 84/91 at n = 14, 220/231 at n = 22. The matching construction is optimal among two-step descents in the data at each. n = 18 was stopped at the 30-minute background limit without a result (the embedding test is too slow there).

**Lemma 1's intermediate-P case written out** (`johnson-presentations.md` §5a): a twist power of order > √c generates F_c, so |P| ∈ {1, c, c²} for c > δ⁻⁴.

## 27. Near-complete items closed; A39 corrected; `audit_fmid.py` range defect

**Closed into the ledger:**
- *A22:* scoping sentence added to R1's status paragraph.
- *A23a:* its lesson moved to `verification-lessons.md` §5.
- *A27 and A28:* complete.
- *R10:* the n = 5 Smith form confirmed directly. Integer homology of each chiral half is ℤ/2 in degree 1, by Smith normal form over `chiral_mv.build(5)`; the regression passes.

**A39(1) corrected on Vipul's reading.** Lutz's 30-vertex A (A₅ on A₅/C₂) already answers it. And "no transitive Oliver subgroup" is automatic for any ℤ-acyclic invariant complex, by Oliver's fixed-point theorem, so it was never an extra hypothesis.

**`audit_fmid.py`:** a hardcoded N = 2700 survived in every committed version, contrary to A20c's record. Fixed (derived range, bisected c-loop, base-prime grouping) with controls. Clean to 10⁵; the full run was still going at the end of this entry.

**A36 literature:** a second, targeted search found nothing, with 21 the best explicit n = 10 figure in print. Scheidweiler–Triesch's full text remains the last check before a novelty claim.

## 28. `audit_fmid.py` over the full table: clean

Run in 50,000-wide chunks with the new `--nmin`. The single detached run died without a result, and a container restart cost one in-progress chunk, which was rerun. **All 921265 rows: 232105 at δ ≤ 0.13 screened, 0 hits.** A20c is closed into the ledger.

## 29. A38.3: B(n) mod 3 proved

B(n) ≡ [n odd] (mod 3) for all n ≥ 1, by the convolution identity from A² = 2eˣ − 1 and sinh²x = (cosh 2x − 1)/2. Checked to n = 200. Then the general fact: B(n) mod p has period p − 1 (Stirling expansion), so p | B(n) when (p − 1) | (n − 2), and a covering check by primes with p − 1 | 240 settles every n except **n ≡ 2 (mod 240)** above the computed range. That class cannot be closed by any finite prime set.

*Follow-up:* the independent referee confirmed (1), and (2)–(3) for odd p only, with n ≥ 2 in (3); p = 2 has period 3 (Bell numbers mod 2). The caveat caught a bug in my class check, which had used p = 2 through the invalid shortcut. Fixed in `bip_small_global_check.py`, the rerun finds an odd witness ≤ 67 at every n ≡ 2 (mod 240) to 10⁷.

## 30. A48.1: the template obstruction proved

With pieces in pairwise-trivially-intersecting subgroups, blocks meet in at most one vertex, so Δ ≃ Γ ∨ ⋁ K_b (colimit = homotopy colimit; slide each block's attaching points to a basepoint). Contractible ⇔ Γ is a tree and every block is contractible; transitivity rules out the tree. Written out in `monotone-transitive-note` §5b, replacing the sketch.

## 31. R6 item 1: foreign-block scoring checked against realised groups

`shape_realize.py --foreign`: C_r ⋊ C_t for every prime r ≤ 200 and prime-power t | r − 1, against the enumerator's own `orb` (imported). 197 blocks, 0 mismatches. The control (halving removed) fires at exactly the even t below the cap. R6 items 2 (inter-class F·c·r) and 3 (Lemma C's foreign strip) remain.

## 32. R6 item 2: inter-class term checked

`shape_realize.py --interclass`: 495 admissible shapes, all four orbital terms match their scores. A negative control (wrong `orb`) flags 349. The first control I designed (non-admissible shapes) does not fire, because gcd(F·d, r) governs Oliver-ness, not the inter-class orbital. Recorded as an input to item 3: the construction realises every prime-power foreign twist.

## 33. R6 item 3: Lemma C's foreign strip checked

`lemma_c_share.py`: 3,248 realisable sharing groups (r | d), c ≤ 64, F = 1.
- The coupling t | ord_r(p) holds with 0 violations. The non-normalising control gives 174.
- The largest foreign twist realised is exactly ord_r(p), and the realised minimum orbital equals Corollary C′'s bound min(r·ord_r(p), C(r,2)) with 0 excesses.
- `--refined` under-credits 257 of these groups (worst c = 32, r = 31: credit 16, realised 155), as the doc anticipates. The licence B(c+r) > bound holds at every tabulated n (worst 155/252 at n = 63).

All three R6 items are now done.

## 34. R8: battery completed; `OrbitalSizes` ported

- **Full battery: 10/10 true**, including the three entangled-generator regressions that the last recorded run never reached. The `FTOP_SPLIT` control aborts at n = 78.
- **`OrbitalSizes` now works from suborbits.** It is identical to the naive version on the eight rows with n ≤ 105; n = 247 and 308 are not yet rerun under it.
- **n = 2759:** the run timed out at 7,000 s at the group-order and chain step, so it never reached the orbital step. That is the next bottleneck.
- *Gotcha:* GAP launched outside `scripts/` reports `Could not read file` and exits 0.

## 35. R8 item 1: n = 2759 witnessed

- **The real bottleneck was `BuildConfig`, not `OrbitalSizes`.** It used c − 1 translation generators per block and a linear `Position` lookup, which is O(c³). Switching to a basis plus `PositionSorted` gives the same group.
- **n = 2759 now verifies in 5 s:** every chain check true, minimum orbital 175,813 = B(2759), set by the foreign class 1453·121.
- Added as the battery's 11th row. The full battery runs in 5 s, every earlier multiset is unchanged, and the control still aborts at n = 78.
- *Gotcha:* single-row runs need `< /dev/null`.

## 36. R8 items 2–3: F = 4 and current two-part winners

- Six current F = 4 winners (n = 20, 52, 323, 455, 1343, 1403) all verify, with minimum = B and cross orbital (F/2)·c².
- n = 52 and 323 were added to the battery, bringing it to 13 rows.
- R8's three coverage items are all done.



## 37. pending-checks.md cleanup (2026-10-19): the replaced text, verbatim

Standing rule 6 was added: close an item in the same edit, with no in-place narratives. What follows is every passage of `pending-checks.md` that the cleanup replaced or removed, copied exactly as it stood at origin/master before the edit, so nothing is lost. Line numbers refer to that version. Items whose rewrite only shortened text with no loss (the standing rules, the owed table, risk 2, the §1 note, the ledger preamble) are listed for completeness.
### 37.1. Standing rules (now six) (old lines 14–20)

> ## Five standing rules
>
> 1. **A rebuild must never lower a value.** Group A's monotonicity check against `--baseline` is the signature to read on every batch; the value-agreement check beside it gives equal/higher/lower and the tie count.
> 2. **Never read the `density` column.** It is rounded to six places and the margins are tighter than that — see **A20b**, which cost two spurious FAILs in one script and 991 in another. Compute δ = B/C.
> 3. **A screen must state its coverage before its verdict**, and the coverage must come from the table rather than a constant — see **A20c**. Two scripts silently screened 2,186 of 921,265 rows while printing a pass.
> 4. **Append the old maximum to `check_doc_figures.py`'s `CHECKPOINTS`** on every extension, or every correctly-scoped historical figure becomes noise in PASS 1.
> 5. **Requote what the extension moves**, per the tag scheme in **R0c**. The floor, its argmin, and small-n first instances do not move; distributions do.
### 37.2. Landing checklist (old lines 28–47)

> ## Before the pause: the landing checklist
>
> *Each item names the exact edit it produces, so none needs a fresh decision. **One is live: item 3.** Items 1 and 2 are done — 2 is kept for the recipe it leaves behind — and item 4 is a non-obligation recorded so it is not mistaken for one. Most measured figures in the documents are current against the ladder-exact table to 10⁶ and the exhaustive one to 10⁵. **The exceptions are run outputs scoped to older tables and not rerun**: `fallback_cert.py` (2,187 rows), `converse_check.py` and T8 ([6, 2600]), and `aod` §3.3's no-row-exceeds-its-cap check (1,167 winners). Each says so where it is quoted. Nothing but item 3 is pending on a run that blocks anything.*
>
> 1. ~~**When `mu_exact.py` reaches 10⁵**~~ **DONE 2026-09.** Complete over [6, 10⁵], 90,299 rows, contiguous, 0 uncertified, minimum 0.046210 at n = 2759. `validate_table_v3.py mu_table_ladder.csv --baseline mu_table_exact.csv`: **27 PASS / 0 FAIL / 16 INFO**, value agreement **ALL equal, 0 higher, 0 lower over all 90,299 common n**, 104 tie-witness differences. The banner sentence is updated in all three core documents. *The original instruction follows.* When `mu_exact.py` reaches 10⁵: run the validate command. Expected: 0 FAIL and `ALL equal`. Then one edit, in three places — the status banner's second sentence in `aod`, `ep` and `notes` ("contiguous to n = 76,752 (69,107 rows) and still running toward 10⁵" → the final reach and row count, "confirmed by exhaustive search to 10⁵"), and the "two tables" row above. Nothing else moves: every measured figure keys on the ladder table, which is already complete, and every requoted site already reads [6, 10⁶].
> 2. ~~**Requote `solvable-relaxation.md` at 10⁶.**~~ **DONE 2026-09.** `solvable_table.csv` built to 10⁶ and the battery run against it in **9 seconds** — 22 PASS / 0 FAIL over all 921,265 rows — with every figure requoted and the ⟦REQUOTE-ON-EXTENSION⟧ tag removed. Movements: equality share 23.5% → **19.7%** (tracking S2's 13.5% win share); ratio median 1.022 → **1.008**, the even median converging to **1.003** and the odd settling at **1.374** ≈ the class-3 ceiling ratio; maximum **4.129 at n = 527, unmoved across every frontier**; the m = 7 exceptional family **still exactly three values**. *The multiplier census cross-checks against `aod` §2.1's one-part winner counts — 41,706 / 28,814 / 22,173 identical at m = 2, 3, 4, differing only at m = 5 — two independent censuses of the same population, from different scripts with different scoring.*
>
>    **For any future extension**, the split makes this a one-off cost: build the table once, then every question is seconds.
>
>    ```bash
>    python3 solvable_table.py --nmax <N> --out solvable_table.csv   # ~3 h at 10⁶; --chunks i/8 for ~25 min
>    python3 solvable_relaxation.py mu_table_ladder.csv --solvable-table solvable_table.csv
>    ```
>
>    The writer mirrors `mu_exact.py`'s driver (resume by reissuing, `--chunks i/N`, work-weighted ETA); the scoring core lives in `solvable_table.py` alone and is imported by the validator, so the two cannot drift; and a loaded cache is spot-checked against a fresh recomputation at the extremes, the single-orbit rows and a random sample, refusing outright if it does not cover the μ\* table's range. *Verified: corrupting the n = 551 row makes the check FAIL and name it.*
>
> 3. **The three unreached GAP battery rows** (n = 78, 33, 105): run the battery to completion once, or record that they were skipped. R8 says which they are and why they matter.
> 4. **`wide_cert.py` is rescoped, not owed** (see R1b): B is known exactly to 10⁶, so a certificate "beyond the table" has no range to certify below 10⁶. It would matter again only for an extension past 10⁶.
>
> *Not on this list, deliberately:* `audit_fmid.py` at the full range (a scaling note, A20c; the 20k-row slice is clean and the screen is about low-density rows, which are dense at small n); `a18_verify.py`'s slow table scan (its witness checks pass; the scan is range-scoped domination that E.5 now covers above 1/25); the `stage4_fast.py` seeds (they produce no verdict without UNSAT, and the backtrack ceiling is what to read if they are left running). None of these gates anything, and none should be a nagging worry.
### 37.3. What is still owed table (old lines 53–58)

> | owed | kind | item |
> |---|---|---|
> | `wide_cert.py 100000`, both modes | rerun — the last complete run predates the fused rung's addition to B_lo | R1 |
> | Part E realisability by GAP for the two remaining shapes | build | R8 |
> | the n = 5 chiral Smith form | compute | R10 |
> | six items needing a human reading | judgement | §2a |
### 37.4. Residual risk 2 (old lines 76–76)

> 2. **Part E's realisability** — the battery's last run covered **7 of its 10 rows**, all passing, largest n = 308; the three entangled-generator regressions were not reached, and n = 2759 and any even F ≥ 4 are unbuilt. → **R8**
### 37.5. §1 numbering note (old lines 90–90)

> > **Numbered in order, and not every entry is a live run.** **R0, R0c, R1, R6, R6a, R8, R10, R13** are things to do (R13 optional); **R1b, R7, R12, R12a** are retained because a reader meeting a reference to them elsewhere needs to find out what happened — R7 superseded, R12a a tool with its result recorded, R1b and R12 explaining a scope that is easy to get wrong. **An item whose findings are fully written into the documents becomes a one-line row in the ledger below instead** — that is where R11 and A31 went once §4b of `approach-rate-note.md` and §5 of `aod` carried their content.
### 37.6. R6 (old lines 196–228)

> ## R6. Shape-level scoring checks
>
> *Score **shapes**, not rows, so they do not rerun on table extension. Rerun after any change to the SAFE cap, to `orb`, or to `mu_enumerate_v3.py`'s scoring. `k3_galois.py` belongs to this class too — it takes no table and scans a fixed range, so one run per environment suffices.*
>
> ```bash
> python3 shape_realize.py --nmax 34            # expect 0 mismatches
> python3 shape_realize.py --nmax 22 --strip    # control: expect UNDER-SCOREs
> ARK_SHAPES_NMAX=100 ARK_SHAPES_MAXF=4 gap -q -o 8g ark_shapes.g
> ARK_SHAPES_NMAX=200 ARK_SHAPES_MAXF=2 gap -q -o 8g ark_shapes.g
> ARK_SHAPES_STRIP=1 ARK_SHAPES_NMAX=100 ARK_SHAPES_MAXF=4 gap -q -o 8g ark_shapes.g
> gap -q -o 8g oliver_negative.g                # the admissibility predicate's negatives
> python3 shape_realize.py --foreign --nmax 200   # expect 0 mismatches; --strip as control
> python3 shape_realize.py --interclass --nmax 40 # expect 0 mismatches
> python3 lemma_c_share.py --cmax 64             # expect 0 coupling violations, 0 sharing-bound excesses, every licence ok (~75 s)
> python3 lemma_c_share.py --cmax 32 --nocouple  # control: expect coupling violations
> ```
>
> - **Read the control before the green run.** Expect UNDER-SCORE at exactly the shapes where stripping **changes** orb(c,d) — check against that predictor, not a remembered count. It is *not* "wherever gcd(d, F) > 1", which names about twice as many rows.
> - **`-o 8g`, not `4g`.** The maxf = 2 sweep's largest groups reach order ≈ 1.8 × 10⁶ on 194 points; 4 GB truncates. `ark_shapes.g` FAILs on a row without a verdict rather than summarising over it.
> - **`oliver_negative.g`** ends in a single PASS/FAIL and writes `oliver_negative_out.txt`. Part B needs the `transgrp` package; without it the part is skipped and counted as a failure. `OLIVER_NEG_DEGMAX` widens it, `OLIVER_NEG_CRANK` bounds part C's lattice cost. Its part D prints **two verdict columns and asserts one** — a rejected witness alongside a successful search is the designed behaviour.
>
> **Formerly owed — all three done** (2026-10-17/18). *Kept here rather than in the ledger because the commands above are the rerun recipe.*
>
> 1. ~~**The foreign block's η = 2t/(r−1)**, against a realised AGL(1,r) twist.~~ **Done 2026-10-17:** `shape_realize.py --foreign` builds C_r ⋊ C_t for every prime r ≤ 200 and every prime-power t | r − 1, and compares it with the enumerator's own `orb(r, t, False)`, imported from `mu_enumerate_v3.py`: **197 blocks, 0 mismatches**. Control `--foreign --strip` (halving removed) fires at exactly the even t < r − 1: 23 of the 26 even-t blocks to r = 60, the other 3 being t = r − 1, where the C(r,2) cap equalises. *Original text:* Cheapest by a wide margin: a foreign block is a *prime* block, so no field construction arises. Wants a `--foreign` mode with a `--strip` control.
> 2. ~~**The inter-class term F·c·r.**~~ **Done 2026-10-18:** `shape_realize.py --interclass` builds a fused matching class (c ∈ {3, 4, 5, 7, 8, 9, 11}, F ≤ 3, every d | c − 1) plus a foreign block (r ≤ 13, every prime-power t | r − 1). They are linked by **one diagonal chain element** (z, τ), with the foreign twist on top. **495 admissible shapes (gcd(F·d, r) = 1): all four orbital terms match their scores**: matching intra F·orb(c, d), cross-block, foreign intra orb(r, t), and inter-class F·c·r. *Negative control:* orb with the halving removed flags 349 of the 495. *A point for item 3:* the 39 non-admissible shapes (r | F·d) also realise F·c·r. The gcd condition governs whether the group is Oliver (the top normalises the cyclic layer, by CRT), not the orbital sizes. In these constructions **every prime-power foreign twist t | r − 1 is realised** alongside the matching class, including c = 4, 8, 9. Item 3 should compare that against what the enumerator's Lemma C strip credits. *Original text:* The "chain element linking two classes" is one generator — a diagonal element acting as the twist on the matching block and as twist or translation on the foreign one. Build matching blocks through the existing `field()` basis, or restrict a first pass to prime c.
> 3. ~~**Lemma C's foreign strip.**~~ **Done 2026-10-18:** `lemma_c_share.py` builds every realisable **sharing** group for c ≤ 64 and F = 1. That is a matching block with twist d, r | d | c − 1, and foreign block Z_r. The group is ⟨translations, g = (x ↦ Ax, y ↦ y+1), w = (x ↦ Bx^(p^f), y ↦ ωy)⟩, over every semilinear top w that normalises ⟨g⟩ and has prime-power order mod ⟨g⟩. That gives **3,248 groups**, with these results:
>    - **Coupling holds: 0 violations.** The control `--nocouple` (non-normalising w) gives 174.
>    - **The largest realisable foreign twist is exactly ord_r(p)** in every (c, r). Lemma C's bound is attained, not just an upper bound.
>    - **The realised minimum orbital is exactly min(r·ord_r(p), C(r,2))**, Corollary C′'s sharing bound. It equals the bound and never exceeds it (0 excesses).
>    - **`--refined` does under-credit sharing groups**: 257 groups, in the rows (c, r) = (4, 3), (8, 7), (27, 13), (32, 31). The worst is c = 32, r = 31: the strip leaves twist 1 and credits orb(32, 1) = 16 against a realised 155. This is expected — the doc already says the strip is not a necessary condition — and what covers it is Corollary C′'s licence, min(r·ord_r(p), C(r,2)) < B.
>    - **The licence holds at n = c + r in every row the table has** (worst 155/252 at n = 63). The rows without a table entry are prime-power n, where B = C(n,2).
>    - *Scope:* F = 1 and one foreign block, c ≤ 64; ΓL(1, c) stabilisers only, so J0a's non-semilinear case at a ≥ 2 is untouched. *Original text:* Highest value of the three. The target is not "did the matching block lose its twist" — forcing twist and foreign translations into one cyclic layer leaves the matching intra at full score — but **the largest foreign twist still realisable once the layer is cyclic, against what the enumerator credits**. A statement about the foreign term, so it wants item 1 first.
### 37.7. R7 (now a ledger row) (old lines 240–251)

> ## R7. ~~Consume the ladder worklist with the adaptive branch-and-bound~~ — SUPERSEDED
>
> **The worklist route is retired, and `ladder_verify.py` with it, at any range we intend to reach.** Its purpose was to find the n where B might fall below the floor without computing B everywhere; `mu_ladder_exact.py` now computes B **exactly** at 15 ms/n, so there is nothing for a lower-bound-and-prune loop to save. The 44,091-entry worklist, the `--floor … --adaptive` consumption, the `--resume` sidecar and the clamped-scan discipline are all history.
>
> > **What survives, and it is the result rather than the method:**
> >
> > > **min { μ\*(n)/C(n,2) : n ≤ 10⁶, composite, not a prime power } = 175813/3804661 = 0.046209898…, attained only at n = 2759**
> >
> > — now with the stronger provenance that the contiguous exact table *contains* the argmin rather than reaching it by a worklist row, and no entry anywhere below 1/25. The ladder gives μ\* ≥ this unconditionally (it exhibits groups); B gives μ\* ≤ this granting μ\* ≤ B_safe; above 1/25 Corollary E.6 closes the gap outright.
>
> **When `ladder_verify.py` would become useful again:** only far beyond 10⁶, where a lower-bound-only scan is meaningfully cheaper per value than computing B. At 15 ms/n for exact B that crossover is not near, and until it is, running the ladder alone buys a weaker statement for no saving. *If it is ever revived, the two defects found in it must be carried over: the block-size window must be `[0.10, 0.85]`, not `[0.10, 0.55]` (the narrow one clipped the two-part family at 274 tabulated n, understating by up to 1.8×), and the fusion set must be 3..16 ∪ {25}, not 3..12 ∪ {16, 25} (cap_F(1) crosses 1/25 between F = 16 and 17).*
### 37.8. R8 (old lines 252–285)

> ## R8. The Part E realisability battery — the only leg of μ\* = B with no per-n check
>
> **What a pass settles:** that the enumeration's score at that n is *attained*, i.e. μ\*(n) ≥ B(n). Not completeness. This is the only artefact that builds a group; everything else re-derives a value.
>
> ```bash
> gap -q -A -o 8g verify_witness.g                            # the battery
> ARK_WITNESS_FTOP_SPLIT=1 gap -q -A -o 8g verify_witness.g   # the control: must ABORT at n = 78
> WITNESS="p=5 q=2: 2x5" MUBOUND=20 gap -q -A verify_witness.g   # a single row
> ```
>
> **Read the control first.** It restores the pre-entangled split (part of the block rotation in the top layer) and must still reproduce the `G/G1` normality abort at n = 78. **If the control ever passes, the fix has stopped doing what it claims and a green run of the default path means nothing.**
>
> > **Rerun 2026-10-18: all 10 rows `VERDICT: true`, including the three regressions** (n = 78, 33, 105), each with its chain verified and orbitals matching the recorded multisets. **The control aborts at n = 78** with the `G/G1` normality error, as required. *(Run from `scripts/`; launched from elsewhere, GAP prints `Could not read file` and exits 0, which looks like a pass.)* The text below records the previous, partial run.
> >
> > **Scaling fixed (2026-10-19): the battery is now 11 rows including n = 2759, all `VERDICT: true`, in about 5 s total.** Two changes were made.
> > - `OrbitalSizes` uses suborbits: orbits of Stab(x) per point orbit, with a self-pairing test. The naive version stays behind `ARK_ORBITALS_NAIVE=1`.
> > - **This was the real bottleneck:** `BuildConfig` added a translation generator for *every* nonzero field element and looked each image up with a linear `Position`, which is O(c³). It now uses a basis of F_c over the prime field (the same group) and `PositionSorted`.
> >
> > Every earlier row reproduces its orbital multiset exactly. The control still aborts at n = 78. Single-row runs need `< /dev/null`, or GAP waits for input and looks hung.
> >
> > **Previous run: 7 of the battery's 10 rows, all `VERDICT: true`** — n = 10, 12, 15, 26, 35, 247, 308, chains verified and orbital multisets matching the prediction at each. **The three rows not reached are the entangled-generator regressions** (n = 78 `6x13`, n = 33 `2x13 + 1x7*`, n = 105 `2x29 + 1x47*`), which are precisely the rows that exist to fail if a twist cut by the block count is ever reintroduced. *A run that stops before them is a run of the battery without its regressions.* Rerun to the end, or say which three were skipped whenever the result is quoted.
>
> **Four of the ten rows score a configuration that is not the winner at its n** — n = 26 (36 against B = 156), n = 35 (105 against 120), n = 247 (2525 against 3280 at `4x41 + 1x83*`), n = 308 (4134 against 5671. That is deliberate: the row checks realisability of the configuration, not optimality of the value, and the comment in `BATTERY` says so at each. *The n = 247 row is the standing example of the battery working: its expectation was 1314, a pre-correction value with the matching twist cut from 72 to 18, and the assertion fired in the direction that matters — the old expectation under-scored.*
>
> **Coverage: ten rows, largest n = 308**, spanning the fused rung at F = 2, 3, 5, 6, a trivial-top attainer, cyclic-layer fusion beside a foreign block, Lemma C's worked example, and the three regressions. **What is still uncovered, in priority order:**
>
> 1. ~~**n = 2759**~~ **Done 2026-10-19:** |Γ| = 97,758,592,154,168, every chain check true. Orbitals are {175813 ×6, 425756, 426409, 1897618}, so the minimum is 175,813 = B(2759), set by the foreign class at r·Q = 1453·121. μ\*(2759) = B(2759) is now witnessed by an explicit group. *Original text:* the range minimiser, and the one n where the framework claims μ\* *exactly* rather than boundedly. Its binding class is the **foreign** one at r·Q with Q = 11², a proper prime power: a stratum no current row reaches, every other foreign row here having prime Q.
> 2. ~~**Even F ≥ 4**~~ **Done 2026-10-19:** six current F = 4 winners all verify with VERDICT true and minimum equal to B: n = 20, 52, 323, 455, 1343 and 1403, four of them ≡ 11 (mod 12). The cross orbital is (F/2)·c² every time (50, 338, 3698, 10658, 65522, 104882). n = 52 and n = 323 are now battery rows. *Original text:* **Even F ≥ 4** — the cross-class coefficient is (F/2)·c² rather than F·c², and F = 4 is the fusion count that sets the ceiling at n ≡ 11 (mod 12). The battery has F = 6 but no F = 4.
> 3. ~~**A two-part row from the current census**~~ **Done 2026-10-19:** n = 2759 and n = 323 are current two-part winners, and both are in the battery. *Original text:* **A two-part row from the current census**, since most rows are configurations that no longer win at their n.
>
> **The scaling limit — resolved 2026-10-19** (see the box above). Rows up to a few thousand points now take seconds. The chain and multiset checks are unchanged. *Original text:* `OrbitalSizes` materialises `Combinations([1..n], 2)` — 690k entries at n = 1175, 3.4M at n = 2600. Port it to union-find and keep the chain and multiset checks where they are. **Do not drop the chain check to buy speed**; it is what distinguishes this from a re-derivation of the value formula.
>
> > **`-A` is belt and braces, not a requirement.** The script once defined a global named `Orb`, which the autoloaded `orb` package owns and makes read-only, so without `-A` it aborted with `Variable: 'Orb' is read only` — a message naming a variable rather than this file. That global is now `ArkOrb`, and a **collision guard** at the top checks every global the file defines and, on a clash, names it and says what to do. *Renaming beats requiring the flag*: a script correct only under a start-up option fails exactly for whoever omits it, and the failure does not point at the cause.
### 37.9. Ledger preamble (old lines 338–338)

> *Items retired without residue, so a reader meeting a reference to them elsewhere can tell what happened. Full accounts are in the session logs. Items retired **with** residue keep their section in §1 — R7 and R11 — rather than appearing here twice.*
### 37.10. T4 (old lines 404–453)

> ### T4. Literature: one high-upside investigation, four smaller owed items, framing deferred
>
> *Untouched by any review pass so far, all of which stayed inside the documents; every item below stands as written. Four passes are written up in `literature-findings.md`, which carries a reference convention — every citation of our own documents is prefixed `` `aod` ``, `` `notes` ``, `` `ep` ``, and a bare § belongs to a cited paper. Two candidate follow-ups — running our CSP against Angel–Borja's surviving types, and chasing the two-orbital criterion computationally — are **deliberately not on the list**: the exhaustive n = 10 and n = 12 batteries already validate the machinery more strongly than either would.*
>
> **Outstanding, and it is the item with the most upside in this file.** Skorobogatov–Sofos (*Inventiones* 231, 2023) prove Schinzel's Hypothesis on average and use it to get a *positive proportion* of varieties with rational points — the move being that one does not need the full conjecture, only that most polynomials satisfying the obvious necessary condition represent at least one prime. **That is structurally `aod` §4**, which needs not an asymptotic at every n but only that for almost every admissible n *some* shape in `aod` §6's finite feasible set is realised. If the averaging works over our shape families, §4's density claim moves from conditional to unconditional, which changes what the paper is. Obstacles to check: the coprimality budget means our family is not a generic family of polynomials, and their result is for linear polynomials in several variables, which fits our two-part shapes better than the fused ones. **Read before `aod` §4 is written, not after.**
>
> **ANSWERED — the fixed-residue exclusion does not bind on us, and the results are worth less than this item assumed.** *(Worked out in `shparlinski-constants.md` §7.5.)* The item asked whether Shparlinski's reason for setting aside BFI/Mikawa/Fouvry — that they restrict the residue classes a in ψ(y,m,a) — is a restriction our formulation already satisfies. **It is**, and for the reason guessed: everything this framework needs is `r ≡ 1 (mod Q)`, the residue fixed at 1, because `Q | r − 1` ⟺ `𝔽_r^×` has a subgroup of order Q ⟺ AGL(1,r) has a twist of order Q. No other residue class corresponds to a group we can build a block out of. Write **EH(1; θ)** for the specialisation.
>
> More precisely, the exclusion is about **Theorem 1**, which builds its residue by CRT (`a ≡ n mod p`, `a ≡ 1 mod q`) so that a varies with n, forcing the sup-over-a form of Bombieri–Vinogradov. **Theorem 2**, the one this framework consumes, never forms such a residue: its inputs are Baker–Harman (purely about the class 1) and Balog–Sárközy (no congruence content at all). Its only congruence-sensitive dependence is EH(1).
>
> **But two findings cut against pursuing them.**
>
> - **Fixing the residue buys nothing at the endpoint.** Friedlander–Granville, *Limitations to the equi-distribution of primes III* (Compositio 81 (1992), 19–32), anticipated exactly the hope in this item — they say outright that there were several reasons to expect the asymptotic might hold for large q with a kept fixed — and refute it: *for any fixed a ≠ 0 and any N > 0, `π(x;q,a) ~ π(x)/φ(q)` cannot hold uniformly for `q ≤ x/(log x)^N`.* So EH(1) fails at the endpoint exactly as EH does. The gain is entirely in the interior (`1/2 → 4/7 → 11/21 → 17/32`), which is real but is a gain in **α**, and `shparlinski-constants.md` §6 shows α buys nothing.
> - **Which constrains the shape of any proof of (BCG)/(BCP), independently of the density accounting.** Bounded cofactor needs moduli `Q ≍ r/D`, inside Friedlander–Granville's failure window — but the framework never needs a per-modulus asymptotic there (the count of `r ≤ x` in one class mod `Q ≍ r/D` is `O(D)`, bounded, so an asymptotic is meaningless). (BCP) is a count **aggregated over Q**, which irregular moduli do not disturb. **So (BCG) and (BCP) cannot be derived from a level-of-distribution statement of the usual asymptotic form at level ≈ 1, because that statement is false; they must come from a counting or sieve argument tolerant of irregular moduli.**
>
> *Also recorded there:* Baker–Harman's `α = 0.677` (Li: `0.679`, via Maynard's triple convolution estimates) needs moduli of size `r^{0.677}` and therefore exists only because the residue is fixed — so the α in the ladder of `aod` §3.6 is a reading of how far EH(1; θ) has been pushed, not an independent input.
>
> **ANSWERED — the almost-all step survives a thin set; the obstruction is elsewhere.** *(Read against Shparlinski's Theorem 2 in full, `aod` §6.8(iv) rewritten accordingly. The question as filed presumed the machinery was circle-method and density-hungry; it is neither.)*
>
> Theorem 2's engine is **Balog–Sárközy's sumset theorem**, whose hypothesis on the input sets is a **pure cardinality condition** — #𝒜·#ℬ ≥ cN log²N, giving a difference with a prime factor ≫ (#𝒜#ℬ)^{1/2}/log N. Shparlinski plays the exceptional set against the input set and reads off #ℰ ≪ x^{2γ}log²x/#ℛ. Three consequences, each correcting something this item or `aod` §6.8 previously asserted:
>
> - **Thinness costs one logarithm, not the argument.** Baker–Harman input (#ℛ ≫ x/log x) gives x^{2γ−1}log³x; an S_D-type input at relative density 1/log x gives **x^{2γ−1}log⁴x** — still o(x) for every γ < 1. "One logarithm short of what the machinery consumes" was wrong: a cardinality hypothesis divides straight through.
> - **No equidistribution clause is needed.** The "consumes distribution in arithmetic progressions, major arcs built from it" reading describes a **circle-method** route, not this one. Balog–Sárközy is sieve-based. The former item's instruction to determine "what equidistribution clause a sufficient version of (BCP) would need" is answerable as: none, for this route.
> - **What blocks the floor is the companion exponent, at every input density.** The certified prime factor is capped by (#ℰ#ℛ)^{1/2}/log x ≤ x/(2√2 log x), sub-linear — so γ = 1 is unreachable even with a full-density input. A floor needs min{p²k, pkr, qr} ≥ δ₀n², forcing p ≥ δ₀n at k ≤ 1/δ₀: the **companion** n − r must carry a linear prime factor at bounded cofactor, the α = 1 endpoint again on the other side.
>
> **Demonstration worth keeping:** run Theorem 2 with ℛ = S_D itself. Then qr ≫ n²/D reaches Ω(n²) on the r-side and the min is still pinned at p²k ≈ n^{1+γ} by the companion — feeding in the endpoint hypothesis buys nothing, which localises all of (BCG-AL)'s difficulty in the companion clause rather than in S_D's thinness.
>
> **The positive result this yields**, now stated in `aod` §6.8(iv): **(BCP_{D,c,ρ}) at any ρ ≍ 1/log^C x implies f(n) ≫ n^{2−ε} for almost all n**, every ε > 0, exceptional set O(x^{1−2ε}log^{C+3}x) — the ladder's limiting exponent from the bounded-cofactor hypothesis alone, no Baker–Harman needed. Not Ω(n²); the gap is exactly the companion endpoint.
>
> **Where a density obstruction does live.** To certify a *linear* prime factor the available tool is **Sárközy–Stewart's** dense-sumset theorem (Shparlinski's own remark after Lemma 7), which wants **positive density in the integers on both sets**. S_D at ≈ 1/log²x is two logarithms short of that. So the honest accounting is: sub-endpoint, density is free; at the endpoint, the known tool wants positive density and S_D is two logs short — not one log short of a circle-method requirement.
>
> **Worked through with explicit constants in `shparlinski-constants.md`** (standalone, less audited), which carries the c₀ chase, the two-branch bound with its constants, the sub-linear cap, and the quantitative threshold: the machinery reaches `p ≫ n/(log n)^{3/2}` at a constant-density input and `p ≫ n/(log n)²` at ours, against the `p ≥ δ₀n` a floor needs. **So thinness costs `(log n)^{1/2}` and the endpoint costs `(log n)²`.**
>
> **Still open from this reading:** Balog–Sárközy's own proof internals were not re-derived (the *statement* consumed by Theorem 2 was confirmed to have a pure-cardinality hypothesis, which settles the equidistribution question at the level it is used); and whether any endpoint-capable sumset result tolerates a 1/log²x set is the live successor question — which, with Sárközy–Stewart's hypothesis now confirmed, is the **only** remaining route on this side and is a genuine literature search rather than a citation check. **Sárközy–Stewart's hypothesis: CHECKED, and Shparlinski's characterisation stands.** Two independent secondary restatements give it as **positive relative density** — `#A, #B ≥ c₁N` yields some `a + b` with `P(a + b) ≥ c₂N`, `c₂` depending only on `c₁` (Mérai, arXiv:2112.03607 §1, and Stewart's framing of the multiplicative analogue). The series does treat sets that are merely "not too small", but those give correspondingly weaker bounds on `P(a + b)` rather than the linear one the endpoint needs. **So the endpoint accounting is unchanged and this item closes negatively** — the outcome that leaves the two-logarithm gap standing rather than the one that would have narrowed it. What remains is small: the original was not read, so a variant elsewhere in the series (I–V) pairing a weaker density with a linear conclusion is not formally excluded. *(`shparlinski-constants.md` §9 records the same, and this was that document's own highest-value open item.)* *Note also the strategic consequence:* the fixed-residue item above attacks the **input** side, which this reading shows is not where the difficulty is, so it should probably rank below the sumset question rather than beside it.
>
> *Sizing, now that the above is settled.* Bounded cofactor needs level → 1, which is not merely unreached but **false** in asymptotic form; 4/7 does not approach it and nothing in this family would give the bounded-D statement. The realistic prize is the **almost-all exponents** of §3.6's ladder, where a fixed-a improvement over BV could raise a rung — a gain in α, which `shparlinski-constants.md` §6 shows does not propagate to the floor. Two obstacles remain if anyone does pursue it: whether the well-factorable or smooth-modulus conditions those results carry are compatible with Q ranging over prime powers, and whether their averaging reaches Q ≈ r/D at all.
>
> > *Where this came from, since the framing is the useful part.* Proposition F.4's condition — r − 1 = dQ with d ≤ D and Q a prime power — is to Sophie Germain what bounded prime gaps are to twin primes, with the ladder's θ → 1 corresponding to letting D grow like r^ε. That analogy invites the hope that a Zhang/Maynard-style result could give bounded D without the full ladder. **It cannot, and the reason is worth recording so the hope is not re-entertained.** GPY/Maynard proves that at least 2 of k linear forms are prime without specifying *which*, and for bounded gaps that is harmless because the forms n + h_i are interchangeable — any two give a gap. Here the two primes are asymmetric: one must divide the other minus one. Sieving {n, 2n+1, …, Dn+1} and being handed 3n + 1 and 5n + 1 with n composite yields nothing, because the large prime-power divisor of r − 1 has to come from n itself. A prime at a **designated** form is the twin-prime barrier itself, which those methods route around rather than break. What survives the analogy is not the method but the residue observation above.
> >
> > *A quantitative consequence of the same framing.* The primes with bounded cofactor have density ≈ C·log D/log x among primes — measured at D = 12 as 0.343, 0.235, 0.182 over x = 10⁴, 10⁵, 10⁶, tracking log 12/log x. So the set is twin-prime-thin, no positive-proportion statement about it can be true, and (BCG) is a Goldbach condition **over a set that thin** — which is the quantitative form of the "independently twin-prime-hard" remark in `aod` §3.5.
>
> **One comparison replaces a reading task.** `literature-findings.md` items 4 and 17 identify Black's spacing framework (ITCS 2015 / ACM ToCT 2019) as containing the sub-board Fourier-degree route, p-group hypothesis included. What is left is not to read it but to ask a specific question: **does our group data give better spacing at composite non-prime-power n than the sequences already in the literature?** His target is Ω(n) asymptotically; ours is constants near C(n,2) at specific n, which his framework does not chase. The two feed the same machinery with different objectives, so the comparison is concrete — compute spacing for the orbit augmentation sequences our batteries supply.
>
> > **Note the optimisation runs opposite to the battery selection.** That route wants many *small* orbitals; the max-m\* search wants the reverse and discards exactly the useful groups. Same inversion as the two-orbital criterion.
>
> **Four primary-source checks owed before publication.** Three are flagged in `aod` §3.6: the θ = 1/4 rung is attributed to Bombieri–Vinogradov on Shparlinski's framing rather than from the original; the Chowla row names a conjecture-type rather than a specific paper; and the two Elliott–Halberstam rungs are quoted in the form n^{3/2−ε} and n^{2−ε} by inference from how E–H is quantified, since Shparlinski's §5 states those improvements without writing an exponent — confirm against the published version, and if a bare n^{3/2} is claimed there, recover the reasoning. The fourth sits in `aod` §5 and the `notes` reference list rather than §3.6: **the Ω(n²/3) bound is attributed by at least one survey to unpublished work of Santha–Yao rather than to Scheidweiler–Triesch**, whom we cite alone. Citing one of two is a priority claim we have not checked.
>
> **The step we are missing, and it is elementary.** Jones–Zvonkin is a *programme* — at least five papers applying Bateman–Horn to dessins, permutation groups, block designs and simple-group orders, with a stable recipe (`literature-findings.md` item 20). Their step (ii) is an explicit, elementary verification of Bunyakovsky's conditions for each polynomial. **`aod` §3.5 asserts an ample supply without doing the analogue** — checking, per shape family, that the relevant system satisfies Schinzel's conditions and has no fixed prime divisor. That is a page of work per family and it interacts with the polynomial-versus-exponential line below: a shape with unbounded exponent has no polynomial to check, which is itself the finding.
>
> **Deferred: the framing decision.** Jones–Zvonkin's programme (arXiv:2106.00346 and four companions) is the model for how this genre states its standing — conditional on Bateman–Horn, labelled as such in the abstract, with the conjecture validated numerically at the range used. Three consequences are recorded in `literature-findings.md` items 14–16 and are *not* being acted on yet: a standing table at the front of `aod` §3 dividing unconditional from conditional from conjectural; the polynomial-versus-exponential line in `aod` §3.5, since shapes needing prime powers of unbounded exponent are Mersenne-like and outside Bateman–Horn; and the Catalan/Pillai caution where both parts are proper prime powers, which is our S1 and S2 and which `aod` §6 currently treats as amply supplied.
### 37.11. T8 (old lines 522–546)

> ### T8. Proposition F.4 (the converse) — two readings; one step carries the whole statement
>
> *Given a second, independent reading: both branch derivations re-derived from scratch, the census walk re-checked, the three smaller steps resolved (below), and one defect found and fixed (§6.8(ii)'s window endpoint). What remains single-sourced is Lemma B′ itself, which is T1's item, not this one. The measurements still are not independent evidence of the derivation — they test the inequalities, which the table's winners satisfy whatever the proof says.*
>
> **The step everything rests on, and its support is better than first recorded: why must the foreign twist Q be a prime power?** Branch (b) is vacuous without it — Q = r − 1 always satisfies a cofactor bound. The confinement is **Lemma B′'s content, not an unstated assumption**: AGL(1,r) is nonabelian, so a foreign block's translations must occupy the abelian cyclic layer and its twist is forced into the top q-group. So the question is not "is this assumed?" but "is B′ right?", which is T1's standing item — B′ being the one structural lemma whose failure would break B_safe itself. That is a much better position than an unexamined layer claim, but **layer-assignment claims remain the category with the worst record here** (the F_mid coprimality clause, the c mod 8 fusion mechanism), so the reliance is worth keeping visible.
>
> **The asymmetry that this creates was got wrong once and is the thing to re-check on any restatement.** A *matching* class's twist is **any divisor of c − 1**, carried by the cyclic layer, and may be the full c − 1 — cofactor 1, not a prime power. So the all-matching branch yields **no arithmetic statement whatever**, and F.4's multiplicative case must be a genuine **alternative** rather than a weakened form of the same conclusion. An earlier draft had it qualifying only the primality of the witness, leaving the divisor conclusion apparently unconditional; that was wrong, and it is the natural error to repeat, since the two branches look parallel until one asks which layer supplies each twist.
>
> **The shape audit is done and closed one gap; record it so it is not redone.** Walking S1–S10 against the branch split: S3, S4, S5, S6, S7 and **S9** carry a foreign part and land in (b); S8 and S10 are killed so nothing exists to quantify over; S1 and S2 land in (a). **S9 (fused outside class) is the gap it found** — the first draft bounded a foreign part's contribution by r·Q with r ≤ n, which is the unfused case; a fused foreign class contributes F·r·Q and needs the **joint** bound F·r ≤ n, the same care the matching branch already required. Stated in the proof now. *Note this is the second time the joint-versus-separate bound has been the defect* (the other produced the spurious 2/δ₀²), which makes it the thing to check first on any restatement. Also recorded there: branch (a) is **wider than S1 ∪ S2**, since multi-class all-matching shapes such as n = 640 = 1·256 + 3·128 are not named in the census but land in (a) correctly — the proof splits on presence of a foreign part rather than on the census, and a shape-by-shape proof would have missed them.
>
> **The extracted hypothesis (BCP) is new with the same standing.** `aod` §6.8 states the n-free multiplicative half as **(BCP_{D,c,ρ}): |S_D ∩ [cx, x]| ≥ ρ(x)·π(x)** — the window built into the definition rather than derived, because a cumulative *lower* bound does not yield a window count (that needs a lower bound at x and an upper bound at cx, the PNT-to-Bertrand relationship), and because a cumulative *asymptotic* would pin ρ to one function and stop the statement being a family. In window form ρ is a genuine lower bound and all three parameters are monotone. Bounded multiplicative gaps are the weakest case, ρ = 1/π(x), and are what a floor implies for free. The section asserts two things about the hypothesis that want checking independently: that a floor implies it (the gap half being a short argument from branch (b) plus branch (a)'s density-zero exceptional set not filling an interval), and that it does **not** imply a floor, the additive clause of (b) being inexpressible n-freely. The second is stated more carefully: a purely multiplicative hypothesis *can* reach the additive clause, via the exceptional-set machinery of Shparlinski's Theorem 2. What blocks it is **not** the thinness of S_D — that machinery's hypothesis is a pure cardinality condition, so relative density ≈ C·log D/log x costs one logarithm and divides straight through (T4 above, `aod` §6.8(iv)). What blocks it is the **companion** exponent, sub-linear at every input density, so the route yields n^{2−ε} for almost all n and not Ω(n²). Density does have an appetite at the *endpoint* tool, Sárközy–Stewart, where S_D at ≈ 1/log²x is two logarithms short. So the honest status is *open*, not impossible, and the concrete question is filed as a T4 literature item. *Measured for context:* the largest multiplicative gap below 2·10⁶ is 1.041 at D = 12 and 1.165 at D = 2, counting from r > 10³, and shrinking with the cutoff — so (BCP) at the constants a 1/25 floor needs is enormously weaker than the data suggests, and its difficulty is entirely that bounded D is the Sophie Germain endpoint.
>
> **The three smaller steps are now resolved** *(second reading, independent of the pass that wrote them).*
>
> - **"Every part clears δ₀·C(n,2) on its own." RESOLVED, with one proviso now stated in the proof.** The direction is safe as used, and no part *kind* escapes: any class with an intra pair has an intra orbital bounded by F·c·d/2. The exception is a part of support **s_i = 1**, which has no intra orbital at all, so the sentence is literally about s_i ≥ 2; such a part needs no branch, since its cross orbitals have size ≤ n and fail the floor outright at large n. `ep` F.4 now carries the proviso.
> - **The shared chain prime. RESOLVED structurally rather than by citation**, and the reason is now in the proof — **in two branches, which the one-line form of it conflates.** Fix the chain first (G.0's discipline, which F.4 follows). A block class of size s^k with k ≥ 2 and s ≠ p has non-cyclic elementary-abelian translations needing a home. At **s ∉ {p, q}** there is none: s-elements map into the cyclic layer, so Sylow-s is cyclic. At **s = q** the top layer *is* such a home, so that argument fails and the branch runs through **Lemma B′ Case 2** instead — a primitive transitive q-group is regular of prime degree. So no such class exists; a block class at a second prime must have k = 1, which is the foreign case and exits to (b). The dichotomy is exhaustive **per chain**, and since only *some* chain is needed, a group admitting several costs nothing. Two matching classes at different primes cannot arise, so the density-zero exceptional set is safe.
> - **The constants. RE-DERIVED from scratch and correct** — both branches, the round trip, the floor-dependent D(δ₀), the slack factors, and n(n−1) carried consistently. **One earlier entry here was itself wrong and is now corrected.** It claimed the smallest intra orbital of a foreign class is at most F·r·Q/**2** rather than F·r·Q, so that the derivation was discarding a factor 2 in the safe direction. That is false at **odd Q**, where `−1 ∉ C_Q` and the orbital is exactly `r·Q` — verified by orbit enumeration at (13,3), (31,5), (11,5) giving 39, 155, 55, against the halved values 26, 31, 164 at the even-Q pairs (13,4), (31,2), (41,8). `shparlinski-constants.md` §1.5 draws the correct and opposite conclusion: **F.4's F·r·Q is tight at odd Q and the factor 2 is not recoverable there**; the halving occurs only at Q = 2, which `aod` §6.8's parity remark makes the rare case. F.4's derivation is sound either way, since F·r·Q bounds the orbital above in both parities — what was wrong was the belief that slack was hiding here. *(The same error, made independently, cost `bcp-to-floor.md`'s Reduction Lemma a factor 2 in its headline constant; the correct argument was already written in `note-to-framework-bridge.md` §5 and propagated to neither.)* The residual watch-list: the orb halving at even twist, and C(n,2) versus n²/2 — *the second of which has already produced one slip, a draft asserting δ₀·C(n,2) > δ₀n²/2, which is backwards since C(n,2) < n²/2; the statement now carries n(n−1) throughout.* Nothing structural turns on it, but `aod` §6.7 quotes 700 as the round-trip figure and it inherits any slip. *One such loss has already been found and removed* — the all-matching branch was first derived at 2/δ₀² by bounding F ≤ 1/δ₀ and c ≤ n separately, when F·c is bounded by n jointly; keeping the product together gives 2/δ₀ on both branches. Checked over ~4·10⁵ random configurations, 0 violations, tightest ratio 0.5. **Both branches now carry the same constant, so a future slip that makes them differ is itself a signal.**
>
> **One finding from the second reading: §6.8(ii)'s window constant sat at a degenerate boundary.** The claim was that a floor gives (BCP) with **c = δ₀/2 exactly**, argued by "if some window held none, every n in its upper part would fail (b)." But an n fails only if its whole r-range [δ₀(n−1)/2, n] lies inside the empty window [δ₀x/2, x], which needs n ≤ x *and* n ≥ x + 1 — no such n exists, so at the endpoint the emptiness implies nothing and the claim was unproved at its own constant. For any **c < δ₀/2** the failing n fill [2cx/δ₀, x], a positive proportion, and branch (a)'s O(x/log x) integers cannot cover it. Fixed in `aod` §6.8(ii) and in `ep` F.4's gaps aside (Λ > 2/δ₀ strictly). **This is the class of defect T8 exists to catch** — an endpoint where a constant is quoted exactly and the argument needs one side open — and it is the third such in this framework after the F.1/E′ offset and the D2′ closed-form tie.
>
> **The cofactor constant sharpens, and the sharpening is inside F.1's existing machinery.** Bounding r ≤ n gives (r − 1)/Q ≤ 2/δ₀; dividing the same inequality by Q instead makes the cofactor depend on r's *share* of n, and a configuration carrying a foreign part carries a second part of support > √(δ₀n(n−1)), so r ≤ n − √(δ₀n(n−1)) and **(r − 1)/Q ≤ D(δ₀) = 2(1 − √δ₀)²/δ₀**. That is a strict improvement at every δ₀ — 26.7 against 43 at the table floor (δ₀ = 0.046210), 32 against 50 at the conjectured 1/25, 14.9 against 28 at the asymptotic ceiling — and it costs nothing new. Both forms hold with zero violations across the table; `converse_check.py` reports each separately so a document still quoting the crude one can be checked against the run rather than silently disagreeing with it. **The residual sharpening question is correspondingly smaller: ~2.1 against the measured 12, not ~3.5.**
>
> **Rerunnable as `converse_check.py`** (`--delta0` to test one global floor rather than each row's own density, `--frontier` to pin the contiguous cut, `--all-rows` to include the worklist), and **in R1's command list**, because these checks read the **witness column** and the rebuild rewrites witnesses — composite-F fusions change which rows are one-part, and raised rows change δ. **Last run over [6, 2600]** (not rerun over [6, 10⁶]; a rerun is the open item here): **0 violations** across all three inequalities, at **1,443** foreign primes and **743** one-part winners (v4: 1,409 and 777). Max cofactor **12**, at the same witness as ever — n = 221, r = 157, Q = 13 — and now with a second attainer at **n = 2759** (r = 1453, Q = 121), which is the range minimiser, so the constant that F.4 records is realised both at the smallest witness and at the hardest n. Slack: D(floor) = 25.4 against 12 used, loose by a factor **2.1** (the crude 2/floor = 42 gives 3.5). *Slack moves with the floor rather than with any finding, so it is not a result; the invariant figures are the zero violations and the 12.* Negative control: `--delta0 0.35` gives 796 violations and exit 1. The frontier is detected as the first gap wider than 10, reproducing the documented 2,186 rows; a looser threshold silently swallows worklist rows, which is how the detection was found to be wrong.
>
> **What the measurements do and do not support.** All three inequalities hold at every contiguous row with zero violations, and on that range two independent constraints bind simultaneously at n = 2594 — genuine corroboration that the bounds are tight rather than merely true. But the measurements test the *inequalities*, not the *derivation*: a wrong constant or an unjustified layer assignment would produce inequalities that still hold on the table, since the table's winners satisfy the true statement whatever the proof says. **The measured maximum cofactor of 12 is the strongest single datum here** — it matches (BCG)'s own constant from the opposite direction — and it is also the reason to suspect F.4's D(δ₀) = 25.4 is loose by ~2.1, which is the sharpening question the gap inventory records.
### 37.12. A0b speed box (old lines 566–568)

> > **Keep it fast — a design constraint, not a nicety.** The suite runs in about **0.1 s on 1,700 rows, 1 s on 50,000, 3.5 s on 144,000**, which is what makes it reflexive rather than scheduled. Keep each check O(rows) or O(rows × parts) on numbers already parsed from the witness. Enumerating configurations, isomorphism work, re-deriving B(n), or sieving past `NMAX` belong in a certificate. If a new check must compare a row against alternatives, budget it against the per-row cost and say so at the check.
> >
> > **It was violated once, and not by a check.** The gap scan in `main()` read `n not in set(ns)`, rebuilding the set every iteration — quadratic in the row count, 0.02 s at 2,186 rows and **47 of 51 seconds at 50,062**, minutes on the 144k ladder-exact table. Fixed (hoist the set; sieve the prime-power test; skip the scan entirely on a non-contiguous file and say so), together with two smaller costs the fix exposed: `prime_power_base` is now memoised (409k calls, a few thousand distinct block sizes) and `density_ok` uses integer arithmetic instead of `Fraction`, whose normalisation was 1.4 s of a 13 s run. **Output is bit-identical before and after on the exact table, and the density fast path was checked against the `Fraction` reference on every row of both tables — 0 disagreements.** *The lesson to carry: `main()` is subject to the cost model too and is where nobody looks, and a quadratic term is invisible until the data grows an order of magnitude — so re-time when the table's scale changes rather than trusting that it was fast last month.*
### 37.13. A9 (old lines 570–603)

> ### A9. The Lean formalisation — keep it in step, and keep it moving
>
> *Home: the Lean project's own `README.md`, which carries the phasing, the case for and against, and the failure-mode analysis. **This item exists so the work resurfaces even when nobody thinks to mention it**; do not restate the reasoning here.*
>
> > **State, 2026-09.** All three files sorry-free (the word appears only in comments); `ArkCore.lean` compiles against core 4.15.0 with no Mathlib; `Note.lean`'s main theorem `theorem_arithmetic_half` is correctly scoped — its primality and coprimality hypotheses are bound with underscores because the arithmetic half does not use them, which is the honest signal that they belong to the Oliver half. **The README predates Theorem E.5**, and E.5 is now the highest-value formalisation target in the project: arithmetic on SAFE terms, one human reading, load-bearing for the whole "μ\* known exactly to 10⁶" claim. Recorded there as Phase 1b. Also reachable and cheap: the BBKN-replacement inequality `μ*(n) ≥ n·(Q(n) − 1)/2` (three lines from `orb_full`, if the note's §1 commentary keeps it), and the self-pairing lemma `orb c d = c·d/2 ⟺ d even` behind `directed-graph-properties.md` §2.
>
> **Two obligations, and the first is the one that rots silently.**
>
> 1. **Sync.** The Lean statements encode claims from these documents — ceiling values, coefficient rules, threshold ladders, the `orb` definition. *Most recent sync found one drift and fixed it:* `Note.lean`'s hypothesis structure was `HypH`, which both invited conflation with the framework's class-keyed hypothesis and carried the Schinzel collision the (BCG) rename existed to remove; it is now `HypBCG`, with the non-nesting recorded at its docstring. When a document changes, the Lean can quietly stop matching it, and nothing in this repository's checks looks at `.lean` files. Any revision to §3.3.5's table, to the cap algebra, to `orb`, or to the E′ s-bound should be followed by a pass over `ArkCore.lean`, `Note.lean` and `Basic.lean`. The ceiling table is the sharpest case: the entries are enumerated one per constant, so a table that gains or loses a constant leaves a list of the wrong length — which is useful only if someone looks.
>
> 2. **Progress. Phase 0 is complete.** Status is per file, and the distinction that matters is the sorry count rather than the compile — a sketch full of sorries compiles perfectly happily:
>
>    | file | compiles | sorries |
>    |---|---|---|
>    | `ArkCore.lean` | laptop **and** container (core 4.15.0, no Mathlib) | **0 — every proof complete** |
>    | `Note.lean` | laptop | **0 — every proof complete**, six by import from `ArkCore` |
>    | `Basic.lean` | laptop | nonzero — the remaining sketch, phase 1 |
>
>    Between the first two the note's whole arithmetic layer is proved; what stays conditional is **(BCG_{1/5}-AL)** — the *note's* fixed-window hypothesis, formalised as `HypBCG`, not the framework's class-keyed (BCG-AL), the two being non-nested — and Oliver, neither formalisable. `ArkCore.lean`'s clean compile against core 4.15.0 with no `sorry` warning has been **independently reproduced** in a container built from the GitHub-releases tarball, so the zero-sorry claim rests on a rerun rather than on a remembered result. **Phase 1 is DONE: all three Lean files are sorry-free.** `Basic.lean` went **18 → 0** in one pass. Proved: `orb_full`, Lemma D1, the capacity bound, Prop F.1, the E′ s-bound and both threshold ladders, the `capF` algebra, **all six §3.3.5 ceiling entries as algebraic numbers** including the global constant `capF 4 (1/3) = 7 − 4√3` at the extremal class, the two-foreign closed form, and the quadratic-residue collapse.
>
> > **Three signature corrections came out of it, which is the better argument for this layer than the proofs are.** `orb_full`'s `2 ≤ c` and `capF_eq_k_sqrt`'s `0 ≤ η` turn out unnecessary — Lean reports them unreferenced, and both are now underscored. **`prop_F1` was false as stated**: at `k = 0` the sum over `Fin 0` is 0, so `n = 0`, the capacity hypothesis is vacuous, and the conclusion reads `0 < 0`. `0 < k` added. That is the *same* failure the file already recorded at `size_of_capacity` — an informal claim quantifying over a configuration and forgetting the empty one. **Two instances in one file is a pattern worth carrying: whenever a claim is "k things each with property P force a bound", check k = 0 first.** A prover cannot skip the degenerate branch the way a reader does.
>
> > **Two techniques worth reusing.** *Write δ = m/N and square* — both ladders are claims about `1/√δ`, and squaring clears the real and the root together, leaving `Nat` arithmetic core Lean proves outright. Where a real-valued claim is an inequality between two squares, the `Nat` form is the same statement with the coercion removed, not an approximation of it. And *supply the surd once*: `capF_of_sqrt` takes the root and its defining equation as arguments, so six ceiling entries became six instances of one identity.
>
> **The remaining Lean work is phases 2 and 3, and neither is owed.** Phase 2 is the balance-point maxima — partly pre-empted, since its cleanest named target (the two-foreign closed form) is already proved and `capF_of_sqrt` is likely the lever for the rest. Phase 3 would make `B n` a Lean-checkable function; the Lean README's own judgement that *this is where I would stop* still stands, `validate_table_v3.py` already covering the rows.
>
> **What the sync obligation now guards** is drift in the other direction: the Lean statements are checked, so a document changing a constant, a coefficient rule or a threshold now contradicts a *proved theorem* rather than a sketch. `Basic.lean`'s ceiling entries are the mod-12 table; if §3.3.5 ever gains or loses a constant, the list of six no longer matches.
>
> **Two environment lessons, both earned by a failed run, and both about names rather than mathematics.**
>
> - **Imports.** Lean resolves `import ArkCore` through `LEAN_PATH` and lake's build dirs and loads the compiled `.olean`, so co-locating sources does nothing and `PATH` is irrelevant. Either `lake env lean -o ArkCore.olean ArkCore.lean` then `LEAN_PATH=$PWD ./leancheck.sh Note.lean` — **on one line** (exporting `LEAN_PATH` first does not take) and **without** `:$LEAN_PATH` (unset variable ⟹ empty path entry ⟹ rejected) — or move the files under the lake library's source dir and import `Ark.ArkCore`. The README carries both recipes and all three gotchas, plus the container recipe for a bare toolchain (direct GitHub tarball; elan's release server is off the allowlist; **Mathlib stays unreachable there**, so Mathlib-side work is laptop work).
> - **Lemma names are the version-dependent part.** Two of the three failures so far were name drift, neither a false statement: `List.mem_cons_self`'s arguments are explicit in core 4.15.0 and implicit on the laptop; `div_le_div_iff` no longer exists under that name. **The convention: prefer a tactic, or a decomposition into long-stable lemmas, over a named iff-lemma wherever the goal is routine** — the division inequalities now go by difference-is-nonneg (`div_nonneg`, `field_simp`, `linarith`) rather than by whatever `div_le_div_*` is currently called. Ordering-and-division iff-lemmas are the highest-churn corner of Mathlib. Likeliest next offenders: the `Nat.mul_le_mul_left` / `mul_le_mul_right` / `mul_lt_mul_left` family, used at a dozen sites in `ArkCore`.
>
> **What it is not for.** Formalising the arithmetic layer does not check the group theory, and reaches no layer-assignment claim — which is where this framework's defects have been. Re-read the README's closing caveat before spending time here.
### 37.14. A26 (old lines 652–664)

> ### A26. The note before circulation: what to re-read, and one decision to make
>
> *Re-read 2026-10-17; the decision remains Vipul's.* The note's §5 θ-ladder against `aod` §3.6:
> - *Clean:* every rung, value and attribution agrees. That covers Bombieri–Vinogradov 1/4 via Shparlinski Thm 1, Chowla 1/2 via BBKN, Baker–Harman 0.677 → 0.679 (Li) almost-all, Elliott–Halberstam's two rungs via Shparlinski §5, and ERH superseded.
> - *Mismatch, inside `aod`, not the note:* §3.6's table gives "all large n" for the Chowla and Elliott–Halberstam level-of-distribution rungs, while its own blockquote says the 3/2 rungs carry O((log x)⁴) exceptional sets. The note agrees with the blockquote ("1.677 and 3/2 both carry exceptional sets"). Needs the primary sources (BBKN Thm 1.4(a), Shparlinski Thm 1's form) to decide which is right.
> - *Wording in the note:* §5 says (BCG_{1/5}) is "of Goldbach rather than Bateman–Horn difficulty", then calls its prime-factor clause "Sophie Germain-type, independently twin-prime-hard", which is Bateman–Horn-type. "Goldbach as well as Bateman–Horn" would be accurate.
> - *Not in the note, and recommended to stay out before circulation:* `aod`'s conditional PD(1) row (an unrefereed claim).
> - *On F = 4, recommendation:* stay silent in the Theorem and proofs, since the note's family is the unfused one and naming the F = 4 shape invites the non-nesting confusion. At most add one sentence in §4 saying the constant is not optimised and a sharper shape analysis exists.
>
>
> *The naming and the non-nesting are done — the note carries `(BCG_{1/5})` with a paragraph explaining it, and `note-to-framework-bridge.md` §4 states the non-nesting. What is left is a reading and a judgement call.*
>
> `mu-theta-n2-note.md` remains **correct on its own terms** — its family is the unfused one, its window is deliberately generous, its constant crude by design — and nothing here touches its Theorem. What changed around it: its hypothesis is now **(BCG_{1/5})**, and its relation to the framework's is **non-nesting in both directions**, not "a weaker form of the same thing". (BCG-AL) hands over an `F = 4` configuration at n ≡ 11 (mod 12) with `c/n ≈ 0.134`, which the note's `c ≥ n/5` rejects; the note in turn is far weaker in constant and restricted to `n = c + r` and `n = 2c + r`. **Before any circulation:** re-read the note's §5 θ-ladder against `aod` §3.6's current attributions, and decide whether the note should mention the F = 4 shape at all or stay deliberately silent about it.
### 37.15. A34 owed list (old lines 674–685)

> **What is still owed, and it is a reading rather than a search:**
>
> 1. ~~**Lemmas 1–3 of §5a** — sketched, with no independent check.~~ **Read independently 2026-10-17** (§5a's new box). All three hold.
>    - Lemma 1 needs T read as the block-pair stabiliser's translations on i × j.
>    - Its Frobenius edge case, and a second unstated one (c = 2^a with a block swap, built at c = 4), give O(n log n) orbitals instead of O(n), which is harmless.
>    - Lemma 2 rests on its cyclic-layer premise.
>    - Lemma 3 should cite Galois's theorem.
>    - *Referee pass (independent agent, same day):* Lemmas 1–3 confirmed. It corrected my "H ∩ V = 1" to |H ∩ V| ≤ 2 in the swap case, and found that Lemma 1 also misses intermediate P at a ≥ 2. Its repair is **written out** (§5a box): twist order > √c generates F_c, so |P| ∈ {1, c, c²} for c > δ⁻⁴.
> 2. **The claim that every alternative configuration costs at least as much at generic n** — the lower bounds are per-shape, and the minimum over shapes rests on the census being complete, i.e. on **Part 0** (trusted base, not in Lean).
> 3. **The exceptional-set density argument** — that twist-sharing needs a large prime-power divisor on n − 2 or n − 3 from a prime whose powers reach [δn, n], with probability about |log δ|/log n per exponent window. Heuristic in its current form.
>
> *The earlier divisibility route (|Γ| ≥ lcm of orbital sizes, with the all-orbitals-equal edge case) is superseded*: the edge case was never the obstruction, and the role count gives the bounds directly. The upper bounds for generic n are conditional on the same bounded-cofactor supply as μ\*(n) itself.
### 37.16. A36 (old lines 687–694)

> ### A36. The weighted restriction game at small n — DONE 2026-10-17: value 40 at n = 10
>
> **Result** (`restriction-game.md` §6a; `restriction_game10.py`, `matching_descent.g`). The game's value is **40**, not 25. The witness is a two-step descent through the order-320 Oliver group with edge orbits {perfect matching, the other 40 edges}, so **every nontrivial monotone graph property on 10 vertices has D ≥ 40**. The same construction gives D ≥ C(n,2) − n/2 at n = 14, 22, 34, 38, 46, and wherever a solvable 2-homogeneous Oliver construction exists. Refereed by an independent agent: valid, with a group rebuild in GAP. *Owed:* (1) **the literature search is partly done** (agent, 2026-10-17): nothing found, about 75% not in print, Angel–Borja read in full. a second targeted search read Lovász–Young and Triesch 1994's abstract and found nothing (best explicit n = 10 figure in print: 21, via Lovász–Young at p = 7). **Scheidweiler–Triesch's full text** (paywalled; the RWTH page errors) and the citation list of Angel–Borja are still unread; one of them is the last check before a novelty claim; (2) whether multi-step descents or larger catalogues push n = 10 beyond 40 (the catalogue's maximum interval value is 40, so this catalogue cannot); (3) other n, via other orbital pairs where the complementary graph embeds in the large orbital. The original text follows.
>
>
> **From `restriction-game.md` §6(a).** Theorem 1 there reduces restriction-based lower bounds, at fixed interval values, to a widest path over interval endpoints. Build the catalogue at n = 10 — peel intervals, bipartite escapes, and every orbital interval of every Oliver subgroup of S₁₀ up to conjugacy (a GAP list) — and compute the widest path. The KSS-shaped descent gives 25 and a single group gives μ\*(10) = 20: **anything above 25 is a new explicit lower bound for the open case**, and exactly 25 says the weighted game cannot improve it. *Only interval endpoints and their containments are needed, so the 12-million-class poset at n = 10 is never built.* A computation, not yet started.
>
> **Extended by `restriction-game.md` §5:** the right object is a *case tree* with conditionally certified leaves, not just the weighted widest path. The n = 10 search should include guard-conditioned k-partite leaves (evasive whenever crossed for equal parts, k = 3, 4, 5) and look specifically for leaves covering the branch h(k·K_{n/k}) = 1, where properties like "no isolated vertex" sit. **And read Korneffel–Triesch and Scheidweiler–Triesch first** — §5.2's reconstruction of their topological core is from Miller's summary only, and the residual branches are unreconstructed.
### 37.17. A37 (old lines 696–702)

> ### A37. Non-maximal Oliver groups at the χ rung — answered; two residues left
>
> **Answered.** The n = 10 battery does include non-maximal groups: its TOM stage emits every conjugacy class of subgroups of S₁₀ with at most 12 orbitals, reproduced independently by `oliver_tom.g` (1,294 Oliver classes, 1,111 with t ≤ 12).
>
> **Literature — answered** (`literature-findings.md` entry 23): bipartiteness's complex is a known wedge of spheres (Chari; Jonsson's book); triangle-freeness is covered by Bollobás 1976, "Complete subgraphs are elusive" — **confirmed from the abstract: containing K_k is elusive for every n**; also found: every decreasing property of bipartite graphs is evasive (Combinatorica, DOI 10.1007/BF01844851, author to confirm), and BBKN Theorem 1.3(b)'s proof is deferred to their journal version; and BBKN Theorem 1.3 adds evasiveness for almost all n, unconditionally.
>
> **Left:** the uncapped band — 183 Oliver classes at n = 10 with 13 ≤ t ≤ 45 — as a **post-check battery** on SAT candidates (`small-degree-computation.md` §7.2); not built, since it needs pipeline candidates not in this directory.
### 37.18. A39 (old lines 714–714)

> *Found* (`oen` §7.6): for A₅ on the 10 edges of K₅, 44 of 3,176 nontrivial invariant functions are Oliver-χ-resistant and none is ℤ-acyclic. *Also settled there*: both separations open in the graph case (A38.1). ~~(1) groups with no transitive Oliver subgroup but where ℤ-acyclic examples exist~~ **Already answered, and the phrasing was confused** (corrected 2026-10-17 on Vipul's reading). Lutz's complex A (`monotone-transitive-note.md` §6) is ℤ-acyclic on 30 vertices, invariant under A₅ acting transitively on A₅/C₂, so it is a weakly symmetric ℤ-acyclic example. The 60-vertex complex is its join A ∗ A′. And "no transitive Oliver subgroup" was never an extra condition: by Oliver's theorem any ℤ-acyclic invariant complex forces it, since an Oliver group acting on a ℤ-acyclic complex has a fixed point and a transitive action leaves no invariant face. The live form of the question is the one the A₅ data points at: the gap **between ℤ-acyclic and non-evasive** (A is ℤ-acyclic; is any vertex-transitive complex non-evasive?), which is `monotone-transitive-note.md` §6's question, not this item's. *Next*: (2) between A₅ and S₅, which conditions kill the 44 — i.e. how much of the gap S_n's extra Oliver subgroups close; (3) the intermediate rungs (𝔽_p-acyclic, ℚ-acyclic) for these functions.
### 37.19. A46 (old lines 762–762)

> *Recorded* (`arithmetic-of-density.md` §3.6, `literature-findings.md` entry 24): the conditional PD(1) row and its dependency chain. *Open*: (1) watch github.com/openai/math (`lean/formalization.yaml`) and the literature for verification of families 011 and 029; (2) ~~whether family 003's zero-free region helps the all-large-n rung~~ **no**: a zero-free half-plane Re s > 7/8 gives primes ≡ 1 (mod q) individually only for q up to about x^{1/8}, hence an exponent of at most 1 + 1/8, below Shparlinski's unconditional 5/4 (the BBKN route turns a level-θ prime supply into n^{1+θ}; `literature-findings` entry 24); (3) whether Prop. 2.1's control of v₂(p − 1) and the residue class mod M matters for the ceiling analysis; (4) if anything becomes formalized, audit the Lean statement against the paper.
### 37.20. A48 (old lines 783–787)

> *Recorded:* the regular action is universal for both versions; counting in it gives exactly Rivest–Vuillemin; the design equation; Illies's construction is non-evasive at all 28 choices across the five groups of order 12; the exhaustive template search at orders ≤ 15 finds only order 12; a sketch that monotone pieces in pairwise-trivially-intersecting subgroups cannot give a contractible complex. *Open:*
> 1. ~~Write out the monotone sketch's homotopy step.~~ **Done 2026-10-17** (§5b): Δ ≃ Γ ∨ ⋁ K_b via the homotopy colimit, so contractible ⇔ Γ is a tree and every block is contractible, and transitivity rules out the tree for every |G| ≥ 2. No assumption on the piece complexes is needed.
> 2. D₁₂ and C₂ × C₆ in the template search (35–45 orbits; needs a smarter enumeration than all unions).
> 3. Solve the design equation with richer piece menus and test larger groups (orders 18, 20, 24, then A₅). Needs a decision-tree solver that uses the coset structure, since D on 2^|G| inputs is out of reach beyond about 16.
> 4. Prove Illies-type non-evasiveness from the local structure at a point, so that order-12 genericity becomes a theorem, and find which other local configurations admit such a proof.

## 38. T8: `converse_check.py` over [6, 10⁶]

- **Result:** 0 violations over all 921,265 rows, covering 796,763 foreign primes and 124,502 rows with no foreign part. The maximum cofactor is still 12 (n = 221), and D(floor) = 26.7, so the slack is 2.2. The `--delta0 0.35` control fires (exit 1). Runtime 12 s.
- **Stale figures fixed while requoting:**
  - `ep` F.4's check box quoted 2,186-row counts while saying "requoted on the completed table". It now gives the 10⁶ counts and tightest cases.
  - `aod` §6.7 had D(δ₀) = 26.1, an arithmetic slip; it is 26.6731…, now 26.7.
- `pending-checks.md`: the owed row and T8's item are removed (rule 6).

## 39. `aod` §3.3's no-row-exceeds-its-cap check at 10⁶

`validate_table_v3.py`'s group-B check "no winner exceeds cap_F(η) for its own F and η" already covers this, and it passes on the ladder table: 0 of 796,763 one-foreign rows exceed (closest approach 1.77·10⁻⁷ at n = 887,990). Every foreign-block winner in [6, 10⁶] is two-part, so this is the whole population. `aod` §3.3's "Upper" paragraph still quoted the 1,167-winner older-table run with a "recheck" note; it is now requoted. The scope note in `pending-checks.md`'s landing checklist is removed.

## 40. A20's open decision; A20 and A20a closed as items

- **Decision taken:** the check stays in group A, with its message amended rather than the check moved. `c_density` now carries a note saying its FAIL means a mis-rounded presentation column, not a broken run, and the summary banner says the same. Control: corrupting one density string in a 3,000-row copy gives exactly that FAIL, and the clean exact table still passes.
- Both items are standing constraints whose content lives in the validator and in `verification-lessons.md` §5, so they are now one ledger row. Their old text follows, verbatim:

> ### A20. The density check must compare in exact arithmetic
>
> *A standing constraint on `validate_table_v3.py`'s group-A density test. Why a float tolerance fails here: `verification-lessons.md` §2.*
>
> A stored decimal density with k places is a correct rounding of μ\*/C(n,2) iff |stored − B/C| ≤ ½·10⁻ᵏ, evaluated in **exact rational arithmetic**, with k **read off the string**:
>
> ```python
> def density_ok(r):
>     s = r.delta_str
>     places = len(s.split(".")[1]) if "." in s else 0
>     return abs(Fraction(s) - Fraction(r.B, r.C)) * 2 * 10 ** places <= 1
> ```
>
> Needs `Fraction` imported and the raw string kept on the `Row` as `delta_str` — `float(d["density"])` discards exactly what the check needs. Worked boundary instance: 250978/3278080 = 49/640 = 0.0765625 exactly at n = 2561, where the float difference is 5.000000000005e-07.
>
> **What the test must still reject**, and what any change to it is re-checked against: one-in-the-last-place errors in *either* direction, truncation rather than rounding, and wholly wrong values — while accepting a tie rounded either way and strings at 4, 6 or 8 decimals at their own precision. Eleven such cases plus the full table are the standing behavioural check.
>
> **Open decision.** Group A's banner says a FAIL there means the run or parser is broken. That holds for its other four tests, not this one — it checks a presentation column no other check reads. Either move it to group B or amend the message.
>
> ### A20a. A bound may not be quoted as a rounded decimal
>
> *Companion constraint to A20, and the same root cause seen from the other side: rounding is symmetric and a bound is not.*
>
> The range minimum is **175813/3804661 = 0.04620989885…**, so the natural 5-place rounding **0.04621 lies above the true value** and "δ ≥ 0.04621" is false at the one n that attains it. Every quotation of a floor as a lower bound must use the exact rational, or truncate toward the bound; 0.04621 is fine as a *label* for the minimum and wrong after a `≥`. Fixed across five documents; the standing rule is in `verification-lessons.md` §5.
>
> **The same applies one level up, to any rounded scan output.** `ladder_verify.py` prints five places, so the file alone supports only "≥ printed − 5·10⁻⁶" at each entry. That is enough here — the next-lowest entry is 0.04801, hence at worst 0.048005, clear of the minimum by 0.0017 — but it is a margin to check, not a formality: had the two lowest entries been within 10⁻⁵ of each other, the printed file could not have established which was the minimiser. **On any ladder rerun whose two lowest values are close, print more digits before drawing a uniqueness conclusion.**

## 41. A29: second reading of t ≤ a — holds

**Setting.** Matching block V = 𝔽_p^a and foreign block Z_r, with r | d. Let z′ be the r-element of the cyclic layer, and M ≤ (ℤ/r)^× the group of multipliers the top induces on the foreign block (so t = |M|).
1. **Conjugation is a power map up to P.** The cyclic layer is the quotient N/P, not a subgroup, so h z′ h⁻¹ = z′^{m_h}·u with u ∈ P, not z′^{m_h} itself. *This is a gap in `ep`'s one-line form, and it is closable.* P⟨z′⟩ is normal in Γ (its image is the characteristic r-part of the cyclic N/P), and its Sylow r-subgroups are P-conjugate. So h z′ h⁻¹ = x z′^{m_h} x⁻¹ for some x ∈ P. Taking linear parts L: L(h) L L(h)⁻¹ is conjugate to L^{m_h}, so **L and L^{m_h} have the same eigenvalue set**, which is all the argument uses.
   - On Z_r, P acts trivially: its orbits are p-power blocks of a Γ-orbit of prime size r ≠ p. So m_h ≡ (h's multiplier on Z_r) mod r, z′ being a nontrivial translation there.
2. **L ≠ 1.** An r-element (r ≠ p) with trivial linear part is trivial on V, and then r ∤ d, so there is no sharing.
3. **M acts on the eigenvalues.** Let Λ be the nontrivial eigenvalues of L in 𝔽̄_p. Each is a primitive r-th root of 1, and |Λ| ≤ a. Λ is Frobenius-stable, so it splits into at most a/ord_r(p) orbits of size ord_r(p). If Lv = λv, then L(L(h)v) = λ^{m_h⁻¹} L(h)v, so Λ^{m} = Λ for every m ∈ M: M acts on Λ by powers and permutes the Frobenius orbits.
4. **The stabiliser of an orbit.** If m fixes the orbit of λ, then λ^{m⁻¹} = λ^{p^j}. Since λ is primitive, m⁻¹ ≡ p^j, so m ∈ ⟨p⟩. The stabiliser is therefore M ∩ ⟨p⟩, and M/(M ∩ ⟨p⟩) acts freely.
5. **Conclusion.** |M| ≤ |M ∩ ⟨p⟩| · a/ord_r(p) ≤ ord_r(p) · a/ord_r(p) = a.

No semilinearity is used anywhere. This is consistent with `lemma_c_share.py`, where every realised t equals ord_r(p) ≤ a.

`ep`'s paragraph now records the second reading and the three steps above. A29 has moved to the ledger. Its old text, verbatim:

> ### A29. Second reading: the J0a-free bound t ≤ a
>
> Lemma C's coupling conclusion t \| ord_r(p) is proved via a Frobenius exponent and assumes a semilinear stabiliser at a ≥ 2. The **bound** it is consumed for — orb(r, t) ≤ r·a, which is all Corollary C′ and E.3(i) use — appears to need no such assumption: the r-element of the cyclic layer has r-th-root-of-unity eigenvalues on V = 𝔽_p^a, closed under Frobenius, hence at most a/ord_r(p) Frobenius orbits; conjugation is a power map whose reduction mod r is the induced multiplier, so the multiplier group permutes those orbits and M⟨p⟩/⟨p⟩ acts freely on cosets, giving \|M\| ≤ a. **One reading only, and nothing currently rests on it** — E.3(i) is theorem-side and `--no-theorems` closes every n without it, and Part E‴ does not use Lemma C at all. If it holds it removes J0a from Corollary C′ and weakens E.3(i)'s "worth at most c" only to "at most max(c, r·a)", still linear. → T1's queue, after Part 0.

## 42. A44 closed: the degree-12–14 census and 12T162's identification

- **`halfsplit_large.g`** takes the 62 transitive groups of degree 12–14 with order > 5,000. For each, it tests containment of every transitive solvable Oliver group of that degree (`ContainedConjugates` in S_d). **All 62 contain one** (witness orders 12–196), so none needs the half-split graph.
  - **M₁₂ (12T295):** the witness was checked directly — a regular C₆ × C₂ subgroup, transitive, inside M₁₂, passing `OliverData`.
  - So the "decide M₁₂ and 2⁶:S₇" item in `monotone-transitive-note.md` is answered.
- **`t12_162_kernel.g`:** the sign kernel in S₄ ≀ C₂ on the two tetrahedra's edges has order 576 and TransitiveIdentification 162, and is isomorphic and S₁₂-conjugate to 12T162. The "unverified inference" in `oen` §7.13 is now confirmed.
- **Gotcha:** the first scan run piped through `tail -70`, which cut off most of degree 12, and wrapped GAP lines broke a `grep` count. The rerun captures the full output and counts on the joined text: 62 groups, 62 settled.

A44's old text, verbatim:

> ### A44. Bi-resistance
>
> *Recorded* (`oen` §7.13): definition, convexity, equality with the χ condition at two-orbital groups, strict place between Oliver-χ and Oliver-resistant, counts at n = 6 and natural properties at n = 10. *Done*: (1) rung BI added to `metaproperty_ladder_check.py`, no violations, self-dual; (2) K₄-free and 3-colourable both bi-resistant at n = 10. (3) *answered* (`oen` §7.13): an exact half-split criterion; the two-block form gives evasiveness at 12T162, the only such group found in degrees 4–14 (order ≤ 5,000 at 12–14). *Remaining*: scan degree 12–14 groups of order > 5,000 and larger degrees; confirm the sign-kernel identification of 12T162 by an isomorphism test.

## 43. A43(2): contractible ⇒ K* contractible in codimension ≥ 3

There is no need to triangulate the dunce hat. K sits in S^m with m = N − 2, and |K*| ≃ S^m ∖ |K|. When m − dim K ≥ 3, general position gives π₁ = 1, Alexander duality gives the complement acyclic, and Hurewicz plus Whitehead make it contractible. So the implication holds for every contractible K with dim K ≤ N − 5, including every dunce hat triangulation (dimension 2, at least 8 vertices). A43(2) is narrowed to dim K ≥ N − 4 and recorded in `oen` §7.12. *Not checked numerically*; the argument is standard.

## 44. A42(3): secret-shuffler conjecture verified at n = 5

`ss_evasive.py` generalises `ss_evasive_n4.py`:
- It enumerates down-sets by recursion: 860 nontrivial monotone properties at n = 5, over 34 classes.
- It adds a per-property budget, shards and a skip file.
- It adds a `--heuristic` mode that tries only three splits of the free classes per query. That is sound for non-evasiveness, since any tree it finds is real.

**Results.**
- **n = 4 control:** reproduces 22 properties, with exactly the two trivial ones evasive.
- **n = 5:** the exact search settled 613 properties as non-evasive in two parallel 7,100 s shards; 22 hit the 600 s budget and the rest were unreached. The heuristic then found trees for all 245 remaining, in under 4 minutes. That makes 858 distinct non-evasive properties, every nontrivial one except the two trivial ones, which are evasive by the certificate argument.
- **Not checked:** the heuristic says nothing when it fails. At n = 4 it misses one non-trivial property that the exact search settles, so a heuristic failure is never evidence of evasiveness.

**Gotcha:** the first full run was piped through `tail`, so a timeout killed it with no progress visible. Results now print per property, unbuffered.

## 45. Second reading of Theorem E.5

I read the proof in full against its sub-cases.
- **Checked and clean:**
  - the s ≥ 4 and s = 3 branches;
  - the F ≥ 2 bound, where (r−1)/(5(5r+1)) < 1/25 ⇔ 5r − 5 < 5r + 1;
  - the p-characteristic-leftover case;
  - the two-or-more-part leftover, with θ/(3 + 2√θ)² ≤ 1/25 on (0, 1];
  - the ratio window r′/r ∈ (3/4, 2);
  - the odd-q twist bounds, which force r = 2q^e + 1 and leave r′ = 2r − 1 as the only distinct in-window value;
  - the q = 2 case: 3 | c for r = 3·2^e + 1, and 5 | c for Fermat r ≥ 17 since 2^{2^k} ≡ 1 (mod 5) for k ≥ 2, leaving n ∈ {15, 23} by direct listing.
- **Corroboration:** `fallback_sup.py 3000` reproduces exactly the 12 exceptions, with largest n = 63. The closest non-bare a = 1, s = 2 approach is 0.99555 of 1/25, at n = 1797.
- **One implicit hypothesis:** r′ ≠ r in the one-foreign-leftover case. Without it, r′ = r is in the window — for odd q, 6·3^{e−1} + 1 = 2·3^e + 1 — giving n = 4r + 1 and a bound near 1/16. It is supplied by the distinct-foreign-prime convention (enumerator, `fallback_sup.py` line 31), which Lemma D2's size-r same-position class justifies.
- **Recorded in `ep` beside the proof**, with the suggested fix. The theorem's statement itself is unchanged; that edit is Vipul's call. This is a machine reading, the kind T1 says is weakest at "a step whose plausibility does the work".

## 46. Lean: container reproduced; `E5Core.lean` started

- **Reproduced:** Lean 4.15.0 from GitHub releases, per the README recipe. `ArkCore.lean` compiles silently in about 4 s, and a copy with an appended `sorry` warns. Mathlib's cache hosts time out from this container, so `Note.lean` and `Basic.lean` stay laptop-only.
- **`lean/E5Core.lean`** (imports `ArkCore`, zero sorries, silent compile; a sorry-control copy warns) proves:
  - **`sladder_strict`:** B ≤ C(r,2) and n ≥ (s+1)r + 1 give (s+1)²·B < C(n,2).
  - **Instances of it:** `s_ge_four`, `count_5r1` (the F ≥ 2 and p-characteristic-leftover sub-cases) and `two_part_leftover`.
  - **`count_5r`** (n = 5r) and **`odd_twist_forces_two`**.
  - **`window_odd_q`:** r′ = 2r − 1 from the ratio window, given the hypothesis `PowRel` that two powers of one odd prime are equal or differ by an odd factor ≥ 3.
  - **`fermat_c_div5`** and **`three_c_div3`**.
  - **Finite checks:** `q2_survivors` and `e4_pair`.
  - **Non-vacuity examples** at real configurations.
- **Two prose slips found by formalising, both corrected in `ep`:**
  - The q = 2 line said "SAFE ≤ 7 < C(n,2)/25" at n ∈ {15, 23}. At n = 15, 7 > 4.2; the true bound there is orb(3, 2) = 3.
  - The s = 3 bullet said SAFE ≤ 10 is below C(n,2)/25 "at every n ≥ 21"; it fails at n = 21 and 22 and holds from n = 23.
  - Neither affects the theorem: n = 21 is an exception, n = 22 has no configuration, and at n = 15 the real bound clears.
  - My §45 reading missed both. The formalisation caught what the reading didn't.
- **Not covered:** Lemma E.2's bound L(a) ≤ 2^{(a−1)/2} + 1, the E.1 and E.3(iii) windows, the twist classification behind `PowRel`, and the SAFE model.

## 47. Lean: Lemma E.2 and Theorem E.1's Mersenne window

`E5Core.lean` now also proves:
- **Number theory, in core Lean.** `IsPrimeN` (core has no `Nat.Prime`), plus `gcd_pow_eq_one`, `dvd_of_dvd_mul_coprime` and `prime_pow_dvd_coprime`.
- **`gcd_two_pow_pm`:** gcd(2^m − 1, 2^m + 1) = 1.
- **`lemma_E2`:** every prime power dividing 2^(2m) − 1 is ≤ 2^m + 1.
- **`orb_le_mul`** and **`twist_split`.**
- **`mersenne_window` / `e1_mersenne`:** with a = 2m + 1 ≥ 7, SAFE ≤ orb(r, t) < C(n,2)/25 at every n ≥ 2^{a+1} − 1.

Results:
- Silent compile. `#print axioms` shows only `propext`, `Quot.sound` and, via `by_cases`, `Classical.choice` — no `sorryAx`.
- A non-vacuity example at a = 7 (r = 127, t = 9, n = 255).
- **Sharpening:** E.5's s = 1 bullet said the Mersenne windows are empty "from a = 13". The bound closes from a = 7 (numerically confirmed for every a ≤ 21). The text now reads a = 7.

**Still uncovered:** the repunit window of E.3(iii), `PowRel`'s twist classification, and the SAFE model.

# Session log 8 — external review pass (Claude Fable), 2026-08-17

*A three-turn critical review of `orbital-evasiveness-notes.md` §§1–6 (§§7–11 skimmed), `enumeration-proof.md`, `arithmetic-of-density.md`, `pending-checks.md`, `literature-findings.md`, `entangled-generator-finding.md`, `session-log-7.md`, the shipped scripts (`mu_enumerate_v3.py`, `validate_table_v3.py` (structural read), `ladder_verify.py`, `shape_realize.py`, `window_verify.py`, `ark_shapes.g`, `verify_witness.g`, `fb_common.py`, `fallback_cert.py`, `wide_cert.py`, `ceiling_rederive.py`, `check_doc_figures.py` (pass-5 code + full run), `audit_fmid.py`), both tables, and the shapes_out artifacts. Findings are grouped for the editing pass: §2 is the actionable inventory, §§3–5 are audits with their own findings, §1 and §7 record what was verified clean and what was skipped (per the standing instructions on both).*

**One-line summary.** The entangled-generator correction is right and now triply confirmed by independent recomputation, but it has been applied unevenly: several proof-bearing passages, one certificate strip site, both census copies, and two scripts still state or implement the refuted claim; plus one new letter-level error in `aod` §6.2 (fused-unequal shapes break its 1/9 infeasibility claim at p = 2), a third ungated strip site in `fb_common.py`, and a handful of tooling defects.

---

## 1. Independent verifications performed — all clean

Everything below was recomputed from scratch in this session (fresh implementations, not reruns of the repo's scripts, except where noted).

**The entangled finding itself.**
- All three witness groups rebuilt from the generator descriptions in `entangled-generator-finding.md` §2, in an independently written union-find orbit computation: n = 78 → {468, 507, 1014, 1014}; n = 33 → {21, 156, 169, 182}; n = 105 → {812, 841, 1081, 2726}. Exact matches, m\* as claimed.
- The "no q = 2 chain at n = 33" claim verified by inspection, for every candidate bottom prime p: odd-order elements land in Γ₁, and for each p the layer inherits either F₇⋊C₃ (nonabelian) or C₁₃² (non-cyclic). Theorem 3.1 is false as stated; confirmed.
- `entangled_exceedances.txt`: **289 rows; every `B_recorded` equals the v4 row; every score recomputes exactly** from the value formula (independent scorer, full twist + foreign orb at the listed q + parity-keyed cross + all inter-class terms), 289/289.
- **v4 → v5 triangle closes.** 0 monotonicity violations over the 1,274 common rows; the set of v5-raised rows (142) is *exactly* the in-frontier subset of the exceedance list; v5 ≥ rescan score on all 142 (114 equal, 28 strictly higher — the full search beating the shape-restricted rescan, as the finding's §4b predicts at n = 207, 231).
- Five v5 rows recomputed independently via `mu_enumerate_v3.py --n` (99, 247, 273, 308, 531): all match the CSV. CSV gaps verified to be exactly the prime powers; contiguous frontier n ≤ 1546.

**The mod-12 rekey.**
- `ceiling_rederive.py --nmax 12000 --mod12` — a range not previously quoted — reproduces all six constants from below (ratios 0.9991–0.9998) with the expected (F, η) attainers, and all six mod-12 pairs {a, a+12} agree. Exit 0.
- The class-{3,7} value 1/8 re-derived by hand from the congruences (r ≡ 5 (mod 8) reachable via the c mod 4 choice at n ≡ 3 (mod 4); ℓ = 3 cut avoidable at both n ≡ 0, 1 (mod 3)); the classes-11/23 non-move re-derived (η ≤ 1/6 at F = 2, cap₂(1/6) = 0.050510 < 7 − 4√3).
- `window_verify`'s F·width = 1 − √λ identity derived analytically (x_lo from the Fx² branch, x_hi from the η(1−Fx)² branch; √cap = √η/(1+√(Fη)) makes the η-terms cancel) and confirmed numerically at N = 4·10⁵ across all six rows at λ = 0.9, 0.99. Agrees with session-log-7 §2.5.

**Proof-reading (clean).** Theorem 2.1 (both directions, all branches); Lemma B′ including Step 0 and Case 2; Lemma C's proof (the ord_r(p) | a step included); Lemma D2 Steps 1–3 (the H¹ = 0 complement-conjugacy step) and D2q (step 5/6 at plausibility level); D1's arithmetic; Theorem E.1/E.2 and the Cap(a) formula; E.3(i)–(iii) (repunit factorisation; the re-reading group's chain, with gcd(r−1, c) = 1 by two independent arguments — the code comment's mod-3 route and the shorter divisor-of-a-prime route); E.4 including the b = 2 exception; the E′ structural bound s ≤ 1/√δ − 1; `aod` §3.2.4's three worked rows against the CSV; the E″ hold-out resolutions at n = 50,817 / 89,697 re-derived using **only** the foreign-r strip (dmax | 2 either way, so the conclusions survive the F_mid retirement — the stated proofs do not; see §2.3).

**Code-level (clean).** `mu_enumerate_v3.py`'s SAFE cap (flat F·C(c,2)), orb() including the char2 flag and the c = 2 cap, `_fusions`, the parity-keyed cross coefficient, the foreign-unfused skip and its D2 rationale; `shape_realize.py`'s entangled construction (z^F = full twist; basis translations at a > 1) and its strip-mode controls (59/241 and 8/47 firings match the documented predictor; non-strip sweeps 0 mismatches); `fb_common.py`'s conditions (1)(2)(3)(5)(7)(8) and the (6) tripwire demotion (see §3); `s_max` at exact 1/16 and 1/9 boundaries; `fallback_cert.py`'s candidate enumeration and `--no-theorems` plumbing; `wide_cert.py`'s B_lo ≤ B_safe soundness argument for all three families and the permissive direction of every B_lo substitution (licence fires less, dispatch fires less, S_TOP grows — all correct directions).

---

## 2. The repair-completeness inventory — ALL IMPLEMENTED

*Every item in this section has been carried out; §8 records the implementation, including the places where doing it turned up something the review had not. The inventory is kept as written so the diff has a reference.*

*The actionable core. The correction is stated correctly in `aod` §2.0's gotcha, §3.2.3, §3.3.4/§3.3.4a, Theorem 3.1's gotcha clause (both copies), `mu_enumerate_v3.py`, `shape_realize.py`, `ark_shapes.g`, and the banner. The following sites still carry the pre-correction claim, a pre-correction figure, or an internal contradiction.*

### 2.1 `enumeration-proof.md`

1. **The B_safe definition block (~lines 32–38).** Defines dmax with the F_mid strip and asserts "The Fmid constraint is a proven necessary condition — C_Fmid and the cyclic part of the twist sit in one cyclic group — so SAFE may use it." This is the refuted subgroup-vs-quotient step, in the block that *defines* B_safe. The follow-on remark that stripping *all* F_mid values "would be a free tightening" is wrong in the dangerous direction. Rewrite to the flat cap F·C(c,2), matching `aod` §2.0 and the v3 code. Also: `mu_enumerate_v2.py` is named as the implementation here and in the DUP:B_definition block (both copies) — v2 is banned for extension per R0.
2. **Part B, branch (B2) (~line 371):** "…it must be a **q**-group action for the chain, so the number of blocks is a power of q." This is verbatim the falsified G.2 claim, in the classification spine; the n = 308 witness refutes it directly. **Part C's chain version V(s; p, q)** (recursion over q-power divisors b, with a Pitfall box defending the restriction as "essential") is the same stratum, and as written the recursion has *no branch at all* for orbits like s = 159 = 3·53 at q = 37 — it does not cover the corrected shape space. The chain-free Theorem 2.3 / B₀ form is unaffected, as stated.
3. **The leftover twist lemma (E″, ~lines 675–677).** Its proof asserts the cyclic layer "carries … the block rotation C_{F_mid}" — the refuted step. The two hold-out certifications and the F = 2 reading survive on the foreign-r strip alone (verified this session), so the *conclusions* stand; restate the lemma with r-stripping only and re-derive the two instances accordingly.
4. **E″'s headline and the status box (line 22)** state "certified at every composite non-prime-power n ≤ 10⁵, 90,299 of 90,299" as a standing result; the certificates are HELD (R1) and the finding's item 3 voids them. Add the ⟦PENDING⟧ qualifier or move the figure to a superseded-figures note until the reruns land.
5. **Census S7 cell (~line 227)** carries *both* "wins → five of the six odd classes, 1, 3, 5, 7, 9 (mod 12); at n ≡ 11 (mod 12) the ceiling belongs to F = 4" *and* "F = 4 attains the class ceiling at 7, 11, 15 and 23 mod 24" — self-contradictory (0.125 > 1/9 at classes 3, 7 mod 12). Delete the mod-24 sentence. **The identical contradiction sits in `aod`'s copy (~line 73)**, which is why `check_doc_figures --pass census` cannot see it (§5.4 below).
6. **Stale worked figures.** B(308) = 4134 appears as current in Part 0 step 3, worked case B, and the brute.py item 4 ("the n = 308 agreement is the one worth quoting" — that agreement was against a different cap); current B(308) = 5671 via `3x67 + 1x107*`. **The n = 1425 worked contrast is invalidated outright**: B(1425) = 171,991 = B₀(1425) now, via `2x419 + 1x587*` — F_mid = 2 realises exactly the reading the passage argues no Oliver group can ("838 = 2·419 is not Fc with F a power of 293"). The B₀-vs-B illustration needs a new n, and "B₀'s optimising partition frequently supports no admissible group" wants re-measuring, since the correction systematically rescues F = 2 readings. (The same 1425 contrast is quoted in `notes` §2.3.) Worked case F (n = 3239) figures presumably in the same boat — beyond the frontier, so mark rather than fix.
7. **Census "one computed instance" table** is v4-era: S4's row (n = 247, "B(n) = 2525") conflicts with B(247) = 3280 (`4x41 + 1x83*` — which `aod` §3.2.4 already names as the winner there, so the two "cross-checked" copies disagree); S5's n = 459 (10100) is now 10512 via `4x73 + 1x167*`. Mark ⟦PENDING-REBUILD⟧ or requote.
8. **Corollary box after E.4 (~line 637):** `check_doc_figures` flags the s-bound 3.56 as \*\*\* STALE \*\*\* against the current partial floor (3.187 at 0.057034). This number will keep moving during the rebuild — restate as formula-plus-current-floor rather than a quoted bound.
9. Small: n = 551's `256 + 167* + 128` citations (Part J item 1, `aod` §6.2) are correctly scoped as admissible-not-optimal; note in passing that the *winner* at 551 is the fused `3x128 + 1x167*` at the same foreign-bound 13,861 in both tables.

### 2.2 `orbital-evasiveness-notes.md`

1. **§1 box (line ~57):** "a further condition mod 8 … refines the odd classes to mod 24 … Seven distinct ceilings across the 24 residues." Pre-rekey. (The banner on the same document says six constants mod 12 — internal contradiction within one file.)
2. **One-paragraph overview (line ~41):** "the eight residues where the F = 2 fused rung wins" (v4-era; current is five mod-12 classes = 10/24, per session-log-7 §6) and "the **seven** values of the mod-24 ceiling table of aod §3.3" (§3.3 is now six, mod 12). The d-values parenthetical (d = 2 at 1, 9; 4 at 3, 7; 6 at 5; 12 at 11) is already mod-12-consistent and can stay.
3. **§5 (line ~223):** "at 7, 11, 15 and 23 the class ceiling is instead attained by the two-part F = 4 shape, at 1/9 for 7 and 15" — contradicts §3.3.5's {3,7} row at 0.125. Also "**nine** residues where the F = 2 fused rung is reachable" — matches neither the v4 state (8/24) nor the current one (10/24); treat as simply wrong, not historical.
4. "n = 2·(prime power)" at lines ~41, 84, 100 drops "odd" — Theorem 2.1 requires odd m (even m makes n a 2-power, δ = 1). Letter-level.
5. `mu_enumerate_v2.py` named in the §2.4 DUP block (see 2.1 item 1).

### 2.3 `arithmetic-of-density.md`

1. **§3.3.5's own box under the table (~line 374):** "At **7 and 15** the tabulated cap is cap₄(1) = 1/9, which *is* the absolute ceiling at F = 4, so those two rows cannot be improved" — contradicts the table two lines above (classes 3, 7 → F = 2, η = 1/2, 0.125) and §3.3.4a's explicit "Classes 7 and 15 sit outside the F = 4 group entirely." Stale leftover sentence; delete or rewrite for classes 11/23.
2. **Census S7 cell (~line 73):** same self-contradiction as `ep`'s copy (2.1 item 5).
3. **§6.2 over-generalises from the unfused case — a new letter-level error, found this session.** "An unequal-size shape is *infeasible* above density 1/9 whatever p is" is derived for the unfused two-class case only. A **fused** unequal shape breaks it at p = 2: `1x256 + 3x128` at n = 640 scores min(32640, 24384, 3·128², 256·384) = 24384, **δ = 0.1192 > 1/9** (verified numerically; it loses at 640, where B = 42778, but the claim is feasibility, and "at δ₀ > 1/9 the one-size counts are exact, since no unequal shape is feasible at all" rests on it). At odd p the fused version stays below ~1/(8p), so only p = 2 escapes, and the family needs two 2-powers — a density-zero escape. Fix: scope the claim to "unfused, or p odd"; file the fused p = 2 family with the §6.5 escapes; recheck whether the §6.1/§6.4 counts above 1/9 need the caveat.
4. **§7's δ ≤ 1/16 tail list** ("18 of 2,186 values — n = 527, 1159, 1175, …") is v4-range with no ⟦PENDING-REBUILD⟧ marker; within the current frontier the tail is exactly **{527, 1175}** (527 unchanged at 0.057034 — an S2 winner the correction cannot touch, currently the v3 floor; 1175 raised 38364 → 41831, still 0.0606). `check_doc_figures` flags all four citation sites.
5. §3.2.5's ⟦PENDING-REBUILD⟧ counts are correctly marked; no action beyond the rebuild requote.

### 2.4 `pending-checks.md`

1. **T6 carries the stale mod-24 story** ("at residues 7 and 15 the tabulated value *is* cap₄(1)", mod-24 cells). Rewrite against the six-row mod-12 table; the class-11 676 > 675 margin note survives.
2. **T5's "Both sites are gated" miscounts** — there are three strip sites in `fb_common.py` and one is ungated and untraced (§3.2 below).
3. **A0b's group-B description** still lists "the three congruence-gated patterns (S4 at c ≡ 1 mod 8; S7-at-F=2 at c ≡ 3 mod 4 …)" as group-B checks; `validate_table_v3.py` correctly demotes them to group-C INFO ("RETIRED CONGRUENCE"). Update the description.
4. **R8's "verify_witness.g was patched"** does not match the file in circulation (2.5 item 1); reword to whatever the patch actually was, and add the entangled rewrite as the owed work. (Confirmed this session: no newer copy exists.)
5. R0/R1 figure at L43 (median 0.1994) matches the n ≤ 1428 checkpoint only — trivial requote.

### 2.5 Scripts

1. **`verify_witness.g` is pre-entangled.** It builds fused classes as `perm^e` in the cyclic layer with the "diagonal carrier" strip ("stricter than SAFE's dmax") — the retired construction; no entangled generator anywhere in the file; the finding's repair item 6 (n = 33 regression witness) is absent. As it stands it would **fail on every full-twist fused v5 witness** (it builds a strictly lower-scoring group). Since R8 is the run meant to close realisability at the ceiling-setting fusion counts, the entangled rewrite is prerequisite to trusting that battery. Owed: entangled construction; the n = 33 / 78 / 105 regression witnesses; then the R8 battery over the v5 winners.
2. **`ladder_verify.py`:** the CAP dict and header narrative are the retired mod-24 keying — including exactly the {3,19} vs {7,15} grouping `aod` §3.3.4 names as the way to reintroduce a spurious mod 24, and the "Measured 100%/0%" line that §3.3.4 declares void; the header's "nine rung-B residues" matches no state (2.2 item 3). Rung B is scored with the retired odd-part twist (`2·orb(c, dodd)`), which under-reports the floor at half the residues. All of it is lower-bound-safe (the strip-scored group exists), so the 10⁶ floor stands — but the R7 rerun should follow the mod-12 CAP rewrite and the full-twist rung-B rescoring, or its per-class shortfall reporting and worklist selection stay keyed to a wrong table.
3. **`mu_enumerate_v3.py`:** `_coprime_part` and `_coprime_ok` are dead code (defined, never called; the foreign-duplicate test is inline in `value()`), and `_coprime_part`'s docstring describes the retired F_mid cap as current behaviour. Delete or tombstone.
4. **`ceiling_rederive.py --no-filter` bug:** the c-candidate list tests the *odd part* for prime-power-ness, admitting non-prime-powers (6, 12, 24, 40, 48, … — confirmed by direct reproduction), so unfiltered escape reports can contain phantom configurations. Diagnostic mode only (exit code ungated there); fix the test to full prime-power.
5. **`shapes_out_nmax_200_maxf_2.txt` is truncated** (rows from n ≈ 128 up end mid-line with no verdict — memory-clipped), so its "0 mismatches" is partially vacuous for large n. Rows without verdicts should count as untested; the harness should exit nonzero on truncation. Rerun with more memory. (`shapes_out_control.txt`'s provenance is resolved: session-log-7 §5's 21-of-134 control.)
6. **`audit_fmid.py`:** dead line `if r == c1 or r == c2: pass` (and the real foreign-vs-home test would be `r == base[c1]`); FMAX = 25 and δ ≤ 0.13 are undeclared scope cuts; it screens only F-vs-F shares between fused classes, not F_mid-vs-another-class's-twist shares — the code comment in `mu_enumerate_v3.value()` citing it for dropping *all* F_mid coprimality should say which argument covers which case (§4.1 below supplies the missing one). All directions are safe for its purpose (a hit-screen against v4's understated B, so the corrected B only widens the margin).

---

## 3. The fb_common necessity audit (risk item 6 — previously the largest unread surface)

*Findings 1–4 are implemented (§8.2); finding 5 is moot, see §8.5.*

All 581 lines read. Conditions (1), (2), (3), (5), (7), (8): necessity arguments sound (details verified: q-enumeration completeness — divisors of r−1 plus the '\*' branch gated on r ≥ B, with q = r and q ∤ r−1 both correctly reduced to that gate; `leftover_ok`'s floor max(⌈B/min(Fc, r)⌉, intra_floor(B)); `multi_part_ok`'s subset-sum/unbounded-sum split; rj = 2 exclusion harmless). Condition (6) correctly demoted to a tripwire, with a valid reason (coeff·c² ≥ F·C(c,2) means (4) binds first). `cap_mersenne` implements E.1's Cap(a) exactly; the max(2, L) over-statement of orb(r, 2) is the safe direction. `e3ii_resolves`'s gcd step is right (two independent proofs; the F-loop break loses nothing since Fmax = 1 at the bare pair).

**Findings:**

1. **The file is in a mixed repair state.** `single_part_ok` already has no F_mid strip (post-correction form); `pair_candidates` (~lines 562–567) still has it, with the comment "Both strips are proven necessary conditions"; the condition-(4) header block has a dangling pre-correction fragment ("…which already carries C_r and C_Fmid…") stitched after the corrected sentence. Make the state uniform in the repair (remove the strip, fix both comments) — a mixed file is worse than a uniformly-old one for the next reader.
2. **A third strip site, ungated and untraced.** `multi_part_ok` strips r from a p-characteristic leftover part's twist under a bare `if cj == p:` — no Corollary C′ licence, no `_STRIP_TRACE`, and a comment ("Lemma C: proved only at prime blocks") contradicting the documents' "proved at every a". Unlicensed stripping is unsound in principle whenever r ≥ B (vacuous in range — r ≥ B only at n = 6 — but the local-licence redesign exists precisely to not rely on that). Bring the site under the same gate+assert+trace discipline; fix T5's site count.
3. **`orb()` here has no char2 flag** (over-states p = 2 intra by ≤ 2× vs `mu_enumerate`'s). Every use is an upper-bound cap, so permissive and sound — add a one-line comment so nobody "fixes" it anti-permissively.
4. **`s_max` and `wide_cert`'s `per_s` filter are float-boundary patterns (A20's class).** `s_max`'s 1e-12 fudge comfortably covers the ~1e-15 error and behaves correctly at exact δ = 1/16 and 1/9 (probed); `per_s`'s `2*Blo[n]/(n*(n-1)) <= 1/(s+1)**2` has no fudge at all. Neither table contains an exact-boundary row (checked in exact rationals, v4 and v5 both), so both are currently safe in fact; B_lo values were not checkable without a run. Hardening: integer comparisons (largest s with (s+1)²·2B ≤ n(n−1); `(s+1)**2 * 2*Blo[n] <= n*(n-1)`), one line each.
5. **The HELD status is enforced by prose only.** Nothing stops `fallback_cert.py` / `wide_cert.py` running today and printing "CERTIFIED". Suggest a module-level flag in `fb_common.py` (e.g. `CONDITION4_UNREPAIRED = True`) that both certs print loudly or refuse on absent an env override — removed in the same commit as the strip.
6. `wide_cert` specifics, all sound-direction: B_lo substitution makes the C′ licence fire less, the dispatch fire less, and S_TOP larger (all permissive); the cache signature keyed on code hashes and mode is good practice; the "dispatch settled NONE at this NMAX" honesty note matches the documents' caveat. One free improvement: `fused_lo` only takes prime-power F, so it misses composite-F_mid fused classes that are now real groups (6×13 at n = 78) — conservative, hence sound, but raising B_lo there shrinks the permitted s and pass 2's work.

---

## 4. Questions resolved this session

1. **Does B_refined stay a lower bound when F_mid shares a prime with a foreign block?** Yes, by counting, and the argument should be recorded next to the 2026-08-16 comment in `mu_enumerate_v3.value()`: a foreign r matters only if orb(r,·) ≥ B, forcing r ≥ √(2B); r | F_mid then forces the fused class's size past n (F·c ≥ r·c with c ≳ (2B/F)^{1/2} from the within-class cross). So an unrealizable r | F_mid configuration can never be the refined argmax. Cross-class F_mid-vs-twist shares are covered on the attainment side by Part E's diagonal generator; the SAFE side ignores twists entirely. Between this argument, Part E, and `audit_fmid.py`'s F-vs-F screen, the wholesale removal of F_mid from `_coprime_ok` is fully covered — but by three different arguments, and the code comment should say which covers which.
2. **The 8-vs-9-vs-10 residue-count tangle is datable** (session-log-7 §6): 8/24 is v4-era, 10/24 ("five of six mod-12 classes") is current, and "nine" (`notes` §5, `ladder_verify` header) matches neither state — an error, not history.
3. **p = q witnesses** (e.g. n = 247, `p=41 q=41`) are legitimate under Oliver's condition; a one-pass sweep for any statement quietly assuming p ≠ q is cheap insurance but nothing suspect was found in the read portions (Lemma B′ et al. use r ∉ {p, q}, which is fine at p = q).
4. **The sole surviving S4 winner migrated.** n = 1529: same B = 118341 in v5, witness now the fused `2x521 + 1x487*` (the foreign term 487·243 binds in both readings — a tie). In-frontier S4 winner count is 0; `check_doc_figures` on the v3 partial confirms three-part winners = 0. "Expect ~0 after the rebuild" is already exactly 0 in range.
5. **The exceedance list's n = 2223 entry (`2x409+2x409+587*`, 166,872) is suboptimal** — the merged `4x409+587*` scores 171,991. Harmless (the list is declared lower bounds), recorded so nobody reads the entry as the corrected B(2223).

---

## 5. Tooling observations

1. `check_doc_figures.py` run against the current files: catches the ep-L637 STALE s-bound, the four §7/§8 1/16-tail citation sites, and pending-checks L43; its prose pass correctly flags the four "no exceptions"-in-words sites for hand recheck.
2. **Census-pass blind spot confirmed at code level:** pass 5 compares only the normalised *description* column; verdict cells are never cross-checked, so the identical stale mod-24 sentence in both copies passes silently (it flagged only a wording drift in S7's description). Cheapest mechanical guard: scan verdict cells for "N mod 24" mentions against a whitelist ({11, 23}-as-history only) — the rekey makes any other mod-24 residue reference a defect.
3. `validate_table_v3.py` (structural read only): the retired congruences are correctly demoted to group-C INFO with good explanatory text; the header's "makes the ceiling law mod 12" is current. Not audited check-by-check.
4. Current v3-partial aggregates for reference: 1,274 rows to n = 1546; floor 0.057034 at n = 527; three-part winners 0; fallback rows 0; δ ≤ 1/16 tail {527, 1175}.

---

## 6. Proposed pending-checks additions — FILED

*All filed; see §8.4 for what went where and §8.6 for what was removed from `pending-checks.md` rather than added.*

- **New T-item: the stale-site sweep of §2 above** — one editing pass over `ep` (B_safe block, B2/Part C, E″ lemma + status boxes, census cell + instance table, L637 box, n = 308/1425 figures), `notes` (§1 box, overview counts, §5 line 223, "odd" in 2·(prime power)), `aod` (§3.3.5 box, census cell, §6.2 rescope, §7 tail list), `pending-checks` (T5 count, T6 rekey, A0b), plus the script items of §2.5.
- **Amend T5:** three strip sites; gate/trace `multi_part_ok`'s; fix its comment; add the fb_common HELD flag.
- **Amend R7:** ladder CAP mod-12 rewrite + full-twist rung B are prerequisites of the rerun, not cleanup after it.
- **Amend R8:** verify_witness needs the entangled rewrite before the battery means anything; add n = 33/78/105 as permanent regression witnesses.
- **New A-item (hardening):** exact-arithmetic forms for `s_max` and `wide_cert`'s per_s filter (A20's principle); `orb()` char2 comment in fb_common; ceiling_rederive `--no-filter` c-list fix; shapes_out truncation guard; delete `_coprime_part`/`_coprime_ok`.
- **New note for `aod` §6.2 / §6.5:** the fused-unequal p = 2 escape family (n = 640 worked instance), and the rescope of the 1/9 infeasibility claim.
- **Record in `mu_enumerate_v3.value()`:** the counting argument of §4.1 for why r | F_mid can never be the refined argmax.
- **Optional wide_cert improvement:** composite-F fused classes in `fused_lo` (raises B_lo post-correction).

---

## 7. Checks skipped this session (flagged per the standing instruction)

`notes` §§7–11 beyond the instructed skim (§7.1–7.3 read since §§1–6 lean on them); `ep` Parts F, G (G.2's pitfall box known only via citations), H, I, and Part E's construction details beyond the coefficient boxes; `aod` §§3.3.6–3.4 body, §4, §5's branch-and-bound internals, §6.3–6.6 (§6.2 and §7 read); `validate_table_v3.py` check-by-check; `ladder_verify`'s S7 F ≥ 3 loop and EFF_EX internals; `check_doc_figures` passes 1–2 implementations (run, and pass 5 read); the chiral sign formula of session-log-7 §2.6 (plausible at a glance, unverified); D2q steps 5–6 beyond plausibility; the 289-list's beyond-frontier rows against a rebuilt B (needs the rebuild); any GAP execution (no GAP here — `ark_shapes.g` and `verify_witness.g` read, not run); `wide_cert` pass 1's B_lo values against exact boundaries (needs a run); `literature-findings` items 3–22 beyond headers.


---

# Implementation pass

*Same session, after the review above. Everything in §§2 and 6 is now carried out; this part records what was done, what the doing turned up, and what is left. Edits to the documents are **dehistoricized**: no document refers to its own earlier state, and each error of interest is stated as a general gotcha at the site where it could recur. Figures awaiting a script run carry ⟦PENDING-REBUILD⟧.*

## 8. What was changed

### 8.1 Documents

**`enumeration-proof.md`.** The Notation box's B_safe definition is rewritten around the **flat F·C(c,2)** cap, with the projection-versus-subgroup failure stated as a gotcha and the entangled generator named as what defeats the cut; the "stripping all F_mid values would be a free tightening" remark is gone, replaced by the observation that the flat cap's looseness is not shape-neutral and that this is the safe direction. Part B (B2) no longer asserts a q-power block count. Part C's recursion now ranges over **all divisors**, with a box explaining that the q-restricted form is not merely sharper-but-unsound: it leaves orbits like s = 3·53 with no branch at all. The E″ leftover twist lemma is restated with the foreign strip only and its Corollary C′ gate, and the two hardest instances (n = 50,817 and 89,697) are re-derived on that strip alone — verified in review that they close without any block-count strip. Certificate coverage figures, the theorem-settled shares, the s-bound box and the odd-n-below-1/9 share are ⟦PENDING-REBUILD⟧. The census S7 verdict cell's mod-24 sentence is removed. The n = 308 worked cases keep the group but drop the claim that its score is B(308).

**The n = 1425 worked contrast is replaced by n = 1460**, because the old one is not merely stale but inverted: a block count of 2 in the cyclic layer realises exactly the reading the passage argued no Oliver group could, and B(1425) now equals B₀(1425). The replacement was checked end to end: B₀(1460) = 263,901 from 727 + 733, unreachable because Lemma B′ caps the foreign twist at a q-power — 726 = 2·3·11² gives at best orb(727, 121) = 87,967, and the p-characteristic reading gives at best orb(733, 61) = 44,713 — against B(1460) = 108,811 via `3x331 + 1x467*`.

**`orbital-evasiveness-notes.md`.** §1's box is six constants mod 12, with the invariant that *a table separating a from a + 12 must be getting it from a mod-8 condition, and every such condition here is constant on the class, so the separation is a defect*. The overview's seven/eight counts and §5's "1/9 at 7 and 15" and "nine residues" are corrected. Theorem 2.1 is scoped to **odd** prime powers at all six sites where it was stated without.

**`arithmetic-of-density.md`.** §3.3.5's stale sentence is replaced by the gotcha that **cap₄(1) = 1/9 bounds the F = 4 slice and is never a class ceiling**. §6.2 is rescoped: the density ceiling is derived for the unfused reading, and the fused unequal p = 2 family is written up with the n = 640 instance (δ = 0.1192 > 1/9) and filed with the §6.5 escapes, with the general gotcha that *a ceiling derived for one reading of a shape does not transfer to its fused reading, and fusion is precisely the axis that multiplies an intra term*. The standing check now names both p = 3 unfused and p = 2 fused. §7's tail membership and odd-n shares are ⟦PENDING-REBUILD⟧.

Across all three: the enumerator is named `mu_enumerate_v3.py` everywhere, and no document cites a table by filename.

### 8.2 `fb_common.py`

The F_mid strip in `pair_candidates` is **removed**, with the reasoning inline at the site. Condition (4)'s header no longer carries the dangling pre-correction fragment. `multi_part_ok`'s third strip site — ungated, untraced, and with a comment contradicting Lemma C's actual scope — is now **gated on the same local licence, asserted, and traced**, so `set_strip_trace()` sees every decision in the file. `orb()` carries a do-not-"fix" note explaining that the omitted characteristic-2 halving is the permissive direction inside a necessary condition. `s_max` is rewritten in **exact integer arithmetic** ((s+1)²·B ≤ C(n,2)), verified equivalent to the exact truth on every (n, B) in a wide grid and correct at exact 1/(s+1)² boundaries.

### 8.3 Other scripts

- **`ladder_verify.py`** — `CAP` rekeyed **mod 12** (six constants; {3,7} at 0.125, 11 at 7−4√3), header rewritten, the "nine residues" and "100%/0%" claims removed, and the mod-24-is-a-defect gotcha added. **Rung B now scores at the full twist** (2·C(c,2)) rather than the odd part of c−1. Rerun at N = 20,000: floor **0.04621 at n = 2759**, 0 values below 0.04, per-class δ/cap minima 0.327–0.644, all six mod-12 caps live.
- **`verify_witness.g`** — rebuilt around the **entangled generator**: twist and block count split by layer, with one cyclic-layer element z : (b,x) → (b+F_top, a_b·x) whose F_mid-th power is the full twist, covering the pure-twist, pure-rotation and entangled cases uniformly. The diagonal-carrier strip is gone. The generator placement was simulated independently and reproduces all three witness multisets exactly: n = 78 → {468, 507, 1014, 1014}, n = 33 → {21, 156, 169, 182}, n = 105 → {812, 841, 1081, 2726}. Those three are added to `BATTERY` as permanent regressions, each annotated with what a reintroduced twist cut would do to it.
- **`ceiling_rederive.py`** — the `--no-filter` candidate list tested the *odd part* for prime-power-ness and so admitted 6, 12, 20, 24, … as block sizes; fixed. Reran both modes: filtered reproduces all six constants from below and every mod-12 pair agrees at n ≤ 12,000; unfiltered now shows escapes at genuine prime powers (512, 729).
- **`wide_cert.py`** — the `per_s` filter moved to exact integers, with the note that an error there is anti-permissive; `fused_lo` widened from prime-power F to **all divisors**, since composite block counts are real groups and excluding them needlessly weakens B_lo exactly where the fused family is the only cheap one; default enumerator path fixed.
- **`mu_enumerate_v3.py`** — dead `_coprime_part`/`_coprime_ok` deleted (the second still documented the retired cap as current behaviour); the F_mid comment rewritten as a gotcha; the **three-argument justification** for dropping F_mid from the coprimality list recorded at the site, including §4.1's counting argument for r | F_mid. B(273) and B(308) unchanged after the edit.
- **`check_doc_figures.py`** — a **modulus guard** on census rows, since comparing the two censuses cannot catch a claim stale in both copies. It flags any census verdict naming a mod-24 residue other than 11/23. Tested with a negative control: silent on the current text, fires on the reintroduced defect.
- **`ark_shapes.g`** — an **output integrity check**: it re-reads its own file and FAILs on any row that carries no verdict, and on a row count that disagrees with the shapes reached. Truncated rows are untested but look like data, so a clean summary line otherwise counts them as passes.
- **`audit_fmid.py`** — docstring rewritten to state what it does and does not cover (F-vs-F shares only; the other two cases are covered by argument, named), the dead `if r == c1 or r == c2: pass` replaced by a note on why admitting such r is the permissive direction for a hit-screen, and the FMAX / δ ≤ 0.13 scope cuts declared.

### 8.4 `pending-checks.md`

T5 now says **three** gated strip sites and adds that the site count is itself worth rechecking on any edit. T6 is rewritten against the six-row mod-12 table, with the F-slice-versus-class-ceiling gotcha. A0b's group-B description matches what `validate_table_v3.py` actually asserts (foreign-side residue patterns; the retired c-congruences are group-C INFO, where a population at the once-forbidden residues is positive evidence). R7 states the ladder rewrite as a prerequisite of the rerun. R8 describes the entangled build and the three regressions. R6 gains the truncation note. New hardening items are folded into the sites they protect rather than listed separately.

**Certificates are unblocked.** With condition (4) stripping only the licensed foreign prime, `fallback_cert.py` and `wide_cert.py` are sound to run, so R1's steps 2 and 3 move from HELD to ordinary reruns and the commented-out commands are restored.

### 8.5 One §6 item deliberately not implemented

The suggested `CONDITION4_UNREPAIRED` flag in `fb_common.py` is **moot** — the repair is what this pass did, so a flag announcing the unrepaired state would be false the moment it was added. What replaced it is the requirement that every certificate figure in the documents carry ⟦PENDING-REBUILD⟧ until requoted from a run, which is the same protection without a stale constant.

### 8.6 Removed from `pending-checks.md`

Per the standing rule that the file carries only outstanding work: the v4-era expected-output table, the superseded certificate coverage counts, the "289 rows known low" framing, the specific worklist size and floor argmin, the strip-decision counts, the shape-check firing counts, the eta_derive cell counts, and every table-by-filename reference. What survives of each is the *instruction* — run it, read these three numbers off it — with the numbers themselves marked as run outputs. Cross-references to `session-log-7.md` are replaced by references to the session logs generally, so the file does not depend on any one of them.

## 8.7 The table does not need recomputing, and this was checked rather than assumed

The question came up directly, and it is worth recording how it was settled since the enumerator was among the files touched. An AST-level diff of the edited `mu_enumerate_v3.py` against the version that produced the current rows shows **exactly two differences: the removal of `_coprime_part` and `_coprime_ok`**. No function body differs, nothing was added, and the module-level statements are identical. Walking the original file's AST for call sites finds **zero calls to either helper** — they were orphaned when the coprimality check moved inline into `value()`, and were dangerous only as documentation, since one still described the retired cap as live behaviour. Everything else in the file is comment.

Confirmed behaviourally as well: ten randomly chosen rows from the partial table (n = 48, 66, 82, 119, 231, 260, 279, 368, 438, 543) recompute to their recorded `mu_bound` exactly under the edited file, on top of the five spot-checks from the review pass. **So rows already written are current values and a run in flight can continue.**

*The general form, worth keeping:* when a script that produced expensive output is edited, the question "must this be regenerated" is answered by diffing the **behaviour** — AST or output — not by looking at the size of the patch. A comment rewrite and a semantic change look the same in a diff stat.

## 9. Still open after this pass

1. **Eleven runs are owed, and `pending-checks.md` now carries them as an index in its banner** rather than only inside the items that describe them. They fall into three kinds: scripts whose own scoring changed (`ladder_verify.py`, `verify_witness.g`), scripts whose earlier output is known defective (`ark_shapes.g`'s truncated sweep, `ceiling_rederive.py --no-filter`), and per-n checks that never extend themselves (both certificates, the two domination verifiers, `audit_fmid.py`, `validate_table_v3.py`, `check_doc_figures.py`). **The table is not among them** — see §8.7.
2. **`validate_table_v3.py` was read structurally, not check-by-check.** Its retired-congruence demotions are right and its header matches the mod-12 keying, but the group-B checks have not been audited individually. It is also the one script this pass did not modify, so any assumption it shares with `mu_enumerate_v3.py` remains untested by cross-comparison — the site-4 failure mode.
3. **The three-argument justification for dropping F_mid** is now recorded, but only one leg (F-vs-F) has an artefact behind it, and that artefact is a screen against a table computed under the old scoring. Worth re-running `audit_fmid.py` against the rebuilt table.
4. **The residue list of §7 above** stands unchanged: aod §§4–5, ep Parts F–I, and the chiral sign formula are unread at depth.
5. **`verify_witness.g` has not been executed** — no GAP in this environment. Its new generator scheme was validated by independent simulation of the same placement, which is strong but not the same as running it. That is R8's first step and should be the next thing done.


## 10. Review-and-edit pass on the standalone note and its bridge (Fable, same session)

*Three new files: `mu-theta-n2-note.md`, `mu-theta-n2-note-latex.md` (kept identical in content), `note-to-framework-bridge.md`. Brief: the note must be correct as a standalone upload, with any imported framework figures current; the bridge maps the note's simplifications to the framework's tighter treatment.*

### 10.1 Verified clean in the note (both versions)

The admissible-d table re-derived by hand at all twelve classes from the root counts at ℓ = 2, 3, including the degeneration mechanism and the change-of-variable (d mod 4 ↔ n mod 4 via the halving in L3) — every cell agrees. The singular-series constants recomputed: 4·(9/8)·C₀ = 2.858249 with C₀ = 0.635166, factors matching ω(2) = 1 and ω(3) ≤ 2. The corner minimisation re-derived: worst density 1/300 in both parities, at the corner r = n/5, not at the balance point — so δ₀ = 1/350 is safe with the stated slack. Both Oliver chains checked (gcd(c−1, r) = 1 doing exactly condition 4's work; the diagonal action necessary in the odd case); both verification groups' orders and orbital multisets match the framework's independently rebuilt record ({10, 21, 35} at n = 12; {10, 10, 21, 25, 35, 35} at n = 17). Condition 4's ≤ 5-excluded-q count checked. The δ ≤ 1/2 ceiling argument and the n = 2m family (orbitals m(m−1), m²) check against Theorem 2.1. §5's quantifier discipline is right as written, and the Runbo Li citation was verified against arXiv directly: 2508.18285 is the stated paper, improves Baker–Harman, proves P⁺(p−1) > p^0.679 for infinitely many primes — exactly as the note qualifies it.

### 10.2 Edits made to the note (both versions, in sync)

1. **The imported computational figures were requoted from a run performed this session.** The previous figures (per-n range to 2600 with floor at n = 1817; four-family scan to 10⁶ at 0.04453, argmin 11183) predate the corrected scoring, and the old scan is not quotable: the S7 F ≥ 3 guard repair lowers some of its scores, so its floor could overstate. `ladder_verify.py` was run fresh at N = 10⁵ (59 s): **δ(n) ≥ 0.0462 for every composite non-prime-power n ≤ 10⁵, minimum at n = 2759, nothing below 0.04**. The note now quotes exactly that, the "15 times" becomes 16, and the per-n-table sentence is folded into the scan claim (the scan itself exhibits a group at every covered n). A 10⁶ rerun was started and left running (≈2.5 h; R7 unchanged) — the note deliberately quotes the completed run.
2. **A precision fix in §2**: "no higher power of 2 or 3 obstructs, since the local condition is decided mod ℓ" contradicted the note's own change-of-variable story (the ℓ = 2 condition is decided mod 4). Restated: mod 3 and mod 4 suffice, the d mod 4 freedom covers the latter, nothing imposes mod 8 or mod 9.
3. **A notation fix in §3**: Γ₁ was written as a direct product including C_{c−1}, which does not commute with Γ₂; now Γ₁ = AGL(1, c) × ℤ/r. The quotient statement was already right.

### 10.3 Edits made to the bridge

Repair-status passages updated (statements corrected, runs in flight — no more "clause being restated / certificates void"); §0's incident narratives recast as gotchas per the dehistoricization rule, content preserved; the §2 caveat block rekeyed mod 12 with the sharpened fact that **the note's odd shape is census S4, which wins nowhere in the computed range** — plus the point that this is not a defect, since a lower bound does not need the optimal shape; the same-statement example in §3 fixed (the old one quoted η = 1/6 at n ≡ 11 as the framework's, which is the note's-family value; the framework's optimum there is F = 4 at η = 1/3); the multiplicative engine's "at most two distinct prime factors" corrected (composite F is a real block count; density-zero now follows from F ≤ 1/δ instead); a new dictionary entry added — **the note's condition 4 avoids the twist-foreign share that the framework's Lemma C prices** — which is the cleanest simplification-vs-tightening contrast in the pair; the 1/350 < 0.0462 < 0.07180 bracket and its quantifier paragraph requoted; Bateman–Horn terminology aligned with the note's own parametric-vs-fixed distinction; §4b and §5 updated (chiral: fused constructions even outright at odd n, so the mod-12 ceilings carry over unscaled; F = 4 attains the ceiling at the one extremal class).

### 10.4 Consequential fixes outside the three files

The stale 10⁶ ladder figures (0.04453 / n = 11183 / block-floor narrative / record-setter list) were still quoted as current at eight sites across `arithmetic-of-density.md`, `orbital-evasiveness-notes.md` and `enumeration-proof.md` — missed by the earlier repair pass because they are ladder outputs rather than table outputs. All now carry ⟦PENDING-REBUILD⟧ with the interim corrected-scoring figure (0.0462 over 10⁵ at n = 2759) where a number is needed; likewise ep's 1/16-tail membership list. `pending-checks.md`'s companion-files paragraph now registers the note pair and names the bridge as the note's standing consistency check, with the two imports to watch.

### 10.5 Skipped

The bridge's §4 items 1–2 and 4a–4b were re-derived rather than re-run (no GAP; the group rebuilds are §1's from the review pass). `chiral-graph-properties.md` and `general-k-note.md`, which two bridge lines cite, remain unread — the chiral clause added in §4b is sourced from the framework's session record, not from the document itself. The 10⁶ ladder run's completion; if it finishes, the note's figure can be upgraded to the wider range with a one-line edit in each version plus the bridge's §2.


## 11. Review of `solvable-relaxation.md` and `three-uniform-note.md` (Fable, same session)

*Review only — no edits made to either document. Verification was by independent recomputation: fresh implementations of B_solv and of orbit-minimum computation over k-subsets of affine and semilinear blocks, not reruns of the documents' own scripts (`solvable_relaxation.py` and `k3_galois.py` were not uploaded).*

### 11.1 `solvable-relaxation.md` — verified clean

1. **The header invariant, exactly as claimed.** B ≤ B_solv recomputed independently across the 289 corrected rows: **0 violations and exactly 20 exact attainments** — both numbers match the document precisely. Also B_solv ≥ B at all 1,274 rows of the v5 partial rebuild.
2. **Every headline numeric.** Min δ_solv over non-prime-power n ≤ 2600 = **0.12296 at n = 551** and max = **0.49981 at n = 2594** — exact. k ≥ 3 partitions never win below 400 (the document's own bound), confirmed exhaustively. The §3½ table's δ values recomputed at n = 5001 and n = 20000 — exact. The §4 ratio column (1.373, 1.698, 1.866, 2.390) recomputed — exact. "Twelve of the twenty-four" residues uncharged — confirmed.
3. **The group theory.** Prop 1's two-branch route (Kantor for 2-homogeneous-not-2-transitive; Huppert for solvable 2-transitive) is sound, and the 2-homogeneity-vs-2-transitivity care is warranted as stated. The c ≡ 3 (mod 4) index-2 claim verified by direct orbit computation: C_c ⋊ C_{(c−1)/2} is 2-homogeneous at c = 7, 11, 19, 23 (one orbital) and not at c = 5, 13, 17 (two) — 7 of 7. The C_r ≀ C₂ example in the D2 discussion re-derived: orbitals 10/10/25 at r = 5, m\* = |O| exactly as stated. §3's balance algebra (x₂ = √2 − 1, δ = 3 − 2√2, cross term slack) and §3½'s parity argument check line by line; the flagged owed citation (interval-constrained ternary Goldbach / four-prime theorem) is the right thing to flag.
4. **Post-correction awareness.** The document's treatment of the entangled generator (§2's gotcha, item 1's "F_mid does not join a pairwise-coprimality budget") is current and correct, and §4's v4-era statistics are already properly pending-marked.

### 11.2 `solvable-relaxation.md` — findings

1. **Line 11 says "seven ceiling constants"** — stale, and it contradicts line 15's own "six" four lines later. (Line 15's six is right.)
2. **Line 15 carries historical framing** — "since the entangled correction lifted classes 7, 15 to 1/8 and merged them into the 3, 19 row" — which the dehistoricization rule says should read as the current fact ("six distinct values, keyed mod 12").
3. **§4's table is keyed "n mod 12" in the header but labelled with v4-era mod-24 row names**, and the labels are now *incomplete*: the "3, 19" row is the mod-12 classes {3, 7}, and residues 7 and 15 (mod 24) — which merged into that row — appear nowhere. Rows "1, 9, 13, 21" and "5, 17" and "11, 23" happen to be complete mod-12 classes under their mod-24 names, so the defect is invisible everywhere except the merged row. Rekey the whole table mod 12.
4. **"86 of the 118 class-11 values exceed the ceiling" (§5) is v4-era.** On the current partial rebuild it is **58 of 65** (89%, up from 73% — corrected values exceed more, as expected). Pending-mark or requote after the rebuild.
5. **Prop 2's printed proof covers the construction and the cross bound, but not the upper-bound half** — that score(s) caps every solvable transitive orbit rides on the chain-free valency recursion (solvable primitive ⇒ affine, via Huppert), i.e. exactly the Part C machinery at V(s) = P(s) − 1. One citing sentence would close the gap between "proved below" in the status line and what is actually printed.
6. **A small numerical reconciliation owed.** Independent recomputation of §3's "non-exceptional odd n ≥ 1200" medians over the abstract two-part partition maximum gives **0.16882 / 0.4182** against the quoted 0.16734 / 0.4167. Both sit consistently below the predicted 0.17157 / 0.41421; the likeliest explanation is that the document's figures are over the realised construction family (2c + r with c a prime power, r prime) rather than the partition maximum, but the definition should be pinned in the document or the script. Likewise the single-orbit winner shares: I get 0.368 / 0.285 / 0.238 against the quoted 0.370 / 0.285 / 0.238 — endpoint-convention noise on the first window, worth one clarifying word.
7. Borderline: the status line names `mu_table_safe_v4.csv` as the comparison input. It is a script-argument fact today, but on the rebuild it silently becomes a stale-input instruction — better said as "the current table".

### 11.3 `three-uniform-note.md` — verified clean

1. **The κ₃ = τ·θ·γ formula, at full claimed strength.** All **104 (c, d, m) triples** over the note's exact block list — c ∈ {5, 7, 8, 9, 11, 13, 16, 17, 19, 23, 25, 27, 32, 49}, every d | c − 1, every m | a — recomputed by fresh orbit computation: **0 mismatches, and the triple count independently comes to exactly 104**. This subsumes §2.1's prime-block law (rechecked separately at c ≤ 13, plus the law holding at c = 4, 8, 16, 25, 49) and §2.2.1's c = 9 failure ({3, 3, 6, 12} exactly).
2. **The Mersenne family at both computable cases.** c = 32: 992 → 4960 (inside the 104). c = 128: the orbit of {0, 1, 3} has size **16,256 under Γ(127, 1)** and **113,792 under Γ(127, 7)**, and the full C(128,3) = 341,376 splits into **exactly three orbits of 113,792** — every figure in §2.2.3 exact, including the sharp-transitivity arithmetic.
3. **The k = 2 inertness claim at its full strength**: 28 of 28 cases (c ∈ {8, 9, 16, 25, 32, 64, 128}, every twist) have identical pair-orbit minimum under Γ(d, 1) and Γ(d, a) — including c = 32 and c = 128, where the k = 3 minimum rises by 5 and 7.
4. **§3.1's classification table against computation**: AGL(1,5) one orbit of 10; AGL(1,8) sharply transitive (one orbit of 56), AΓL(1,8) still one orbit; c = 16's full AΓL splits {80, 480}; C₆ splits 2/6/6/6 and AGL(1,7) splits 14/21. The nontriviality bound a ≤ (c−2)/6 with equality at c = 32; the §3.2 order bound.
5. **§5.7 in both columns.** Every β₃ cell recomputed from the allocation formula; the κ_c = 2 identity β₃ = cap_F(η)/2 verified algebraically (the one-line expansion is correct); the class-11 κ_c = 3 tie is exact for the stated reason ({√6, √12} against {√12, √6}) and F = 4 wins strictly at κ_c = 2; every share-column entry (4 − 2√3, 2 − √2, …) recomputed. §5.6.1–5.6.2's laws re-derived from κ₃, including the 2^{v−1}-vs-2^v cut-cost split.
6. **Every measured cell I could reach**: §4.2's S1/S2/S3/S4/S7 density figures, §4.4's n = 36 factor-of-three table, §5.4's four-row two-part table (114/55, 602/1081, 992/2525, 5050/5513 against ceilings 225/2025/4422/15625), and the whole of §6.2 — orb₃(101, 25, 1) = **2525 by direct orbit computation**, every row of the r-table (55, 205, 355, 655, 2525, 3775, 31375-capped-at-4960), every row of the alternatives table (1081, 888, 798, 992, 202, and the {5,128} split's 10), and the chain-layer table (C₃₁ × C₁₀₁ cyclic; C₅ × C₂₅ a 5-group).
7. **The layer split and its worked examples**: a = 35, d = 31 (31 | 2⁵ − 1, C₂₁₇ cyclic, top C₅) and the d = 127 divergence (a′ = 5, q = 7, gain still 5). The gain-versus-top-prime distinction is real and correctly argued.
8. **Post-correction awareness throughout**: the header gotcha, §1's corrected budget statement, §5.6.2's fusion-does-not-force-the-cut, and the S7 row's current F-split fractions (F = 2 at 10/24, F = 4 at 2/24).

### 11.4 `three-uniform-note.md` — findings

1. **The Oliver-constrained Corollary (§2.2.2) omits gcd(a, 6) = 1, and the omission is falsifiable.** As stated — "raises the minimum iff p = 2, gcd(d, 6) = 1, and a admits a split" — take **a = 10, d = 31**: the split exists (a′ = 2, a/a′ = 5 prime, 31 | 2⁵ − 1, gcd(31, 2) = 1), but the unconstrained theorem's necessity fails at gcd(10, 6) = 2 — the 𝔽₄ escape supplies a Galois-stable minimal orbit and there is no gain. The condition is present in §6.1's two statements of the escape and in §2.3's γ rule; only the corollary drops it. One-clause fix, and `k3_galois.py`'s predicate should be checked for the same clause.
2. **§1's transfer list contradicts §8.** Line 40 says Parts "A, B, B′, C, D and D2 … None mentions pairs. They transfer unchanged," while §8's own table has Part A *restructured* and Part C *needs redoing* precisely because the counting bound is pair-specific. The list should be B, B′, D, D2 (plus Part 0), or the sentence scoped to the group-existence content only.
3. **v4 parentheticals in §5.7's row 7, 15** — "entangled (v4: F = 4)", "1/2 (v4: 1)", "(v4: 1/18)", "(v4: 0.11111)" — are historical framing; the row should state the current fact only.
4. **Mod-24 row names persist where the keying is now mod 12.** §5.7's header "(residues mod 24)" with rows 3, 19 / 7, 15 (now identical and mergeable into class {3, 7}) and 11 / 23 (one class, two identical rows); §5.6's head-note ("at 11, 23 only; at 7, 15…"); §5.6.4's box; §10 item 5 ("rows 7, 15 and 23"); §3.3's "the mod-24 ceilings"; §5.5's and §8's "mod-24 classification". §5.6.3's *genuinely* mod-24 content — v-pinning inside the cut-taking regime — is legitimate and already correctly gotcha'd; it is the ceiling-table keying and the prose pointing at it that should read mod 12.
5. **`mu_enumerate_v2.py` is referenced twice** (§6.2's caveat and §10 item 1) — the enumerator is v3.
6. **"Tracked as A19 of `pending-checks.md`" (§2.2.2) is a dangling reference** — no A19 exists in either the uploaded or the current pending-checks.md (the companion-files entry for `k3_galois.py` covers the substance). Either add the item under that number or repoint the reference.

### 11.5 Skipped, by budget or by missing artefacts

The documents' own scripts (`solvable_relaxation.py`, `k3_galois.py`, the §5.6 c ≤ 83 sweep, the §3.1 c ≤ 4096 search) were not uploaded and were not run; everything above is independent recomputation, which is stronger where it agrees but means the scripts' self-tests are unexercised. Not verified: `three-uniform-note` §4.1's witness 3-sets and the n ≤ 46 cross-term measurements (configuration-level orbit computations across multiple blocks); §6.1's O(n/log n) escape count (self-flagged as order-of-magnitude); the two clauses §2.2.2 itself flags as out of computational reach (first distinguishable at c = 2¹⁰ and c = 2²⁵ — the a = 10 counterexample in finding 1 is a *logical* consequence of the proved theorem, not a computation); `solvable-relaxation`'s probe claims over n ≤ 70 (items 1–2 of its open list); and the Kantor / Livingstone–Wagner / Huppert citations themselves, taken on the framework's authority as before. The 10⁶ ladder rerun stalled twice when its parent shell was reaped and was restarted; it remains R7's item and nothing in this section depends on it.


## 12. Implementation of the §11 findings (Opus, same session)

*Both documents edited; §11's numbered findings are the work list and all are now closed. Every β₃ cell of the rekeyed ceiling table was recomputed after the edit and still reproduces exactly.*

### 12.1 `solvable-relaxation.md`

- **"seven ceiling constants" → six** (§0), removing the contradiction with the same paragraph's neighbour.
- **The headline's historical clause deleted**: the six constants are now stated as the current fact, with no "since the entangled correction lifted…".
- **§4's table rekeyed mod 12**, which merges the old mod-24 row names into six rows and — the actual defect — **puts residues 7 and 15 back in scope**, as the class {3, 7}. Two downstream sentences followed: "only at 11 and 23" and "twelve of the twenty-four" (now six of the twelve, which is the same set of unchanged classes counted in the right modulus).
- **Prop 2 gained a box supplying the upper-bound half.** The printed proof only constructed the score; that no solvable transitive group beats it is Part C's valency recursion read with the chain deleted and Huppert in its place, at V(s) = P(s) − 1. This is what licenses "proved" in the status line.
- **The class-11 exceedance count pending-marked**, with the current partial figure (58 of 65) as the interim, since it is a table output that the rebuild moves.
- **The §3 medians disambiguated in place**: the quoted 0.16734 / 0.4167 are over the realised construction family, and the note now says so and records the partition-maximum values (0.16882 / 0.4182) alongside, which is what an independent recomputation lands on. The single-orbit share's first window corrected to 0.368 with half-open interval notation.
- **The status line no longer names `mu_table_safe_v4.csv`** — "the current μ table", so it cannot read as an instruction to use a superseded input after the rebuild.

### 12.2 `three-uniform-note.md`

- **The Oliver-constrained corollary now carries gcd(a, 6) = 1**, with a box giving the falsifying case: at a = 10, d = 31 the layer split exists and the chain is genuine, but the 𝔽₄ escape kills the gain. The box also notes which direction the error runs — over-crediting, which §5.8's trap makes the *safe* direction, so this was a latent statement bug rather than an unsound bound — and records that `k3_galois.py` tests all four conditions.
- **§1's transfer list corrected to Parts B, B′, D, D2 and Part 0**, with a parenthetical pointing at §8 as the authority and naming why A and C are excluded (A's term types are a partition of k; C's bound is pair-specific). This closes the contradiction with §8's own table.
- **§5.7's ceiling table rekeyed mod 12**: header no longer says "residues mod 24", the 3, 19 and 7, 15 rows merge into class {3, 7}, and 11 / 23 merge into class 11. **All four v4 parentheticals in the old 7, 15 row are gone**; the row states η = 1/2 and β₃ = 1/16 as current. Five pieces of dependent prose followed — §5.6's head-note, the F = 4 supersede paragraph, §5.6.4's tie discussion, the balance-point box's "5, 17", and §10 item 5, which no longer reads as an open to-do since the rows it lists are settled.
- **Mod-24 prose corrected where it keyed the ceilings** (§3.3's "mod-24 ceilings", §5.5's and §8's "mod-24 classification", §9 item 1's "mod-24 table"). **§5.6.3's mod-24 content was deliberately left**: it refines the *cut cost* by pinning v inside the cut-taking regime, is about c rather than n, and its own gotcha already says a mod-24 refinement in the ceiling table is a symptom. §5.5 and §8 now name it explicitly as that refinement rather than as a classification.
- **Both `mu_enumerate_v2.py` references → v3**, and the dangling "Tracked as A19 of `pending-checks.md`" repointed at `k3_galois.py`'s companion-files entry, which is where the substance actually lives.

### 12.3 Not done

The two documents' own scripts remain unuploaded, so `solvable_relaxation.py`'s nineteen checks and `k3_galois.py`'s self-test were not updated to match — in particular **the gcd(a, 6) = 1 clause of finding 1 should be confirmed present in `k3_galois.py`'s predicate**, which the corollary's new box now asserts. Nothing else in §11 is outstanding.


## 13. The two companion scripts (Opus, same session)

*Both uploaded after the §12 document pass and edited to match. Both now exit 0.*

### 13.1 `k3_galois.py` — the corollary's assertion was already true

**The gcd(a, 6) = 1 clause §12.2 asserted is present and correct in the predicate.** `galois_admissible` tests it before anything else, so the finding-1 bug never reached the code — the document's corollary had drifted from its own implementation rather than the reverse. Two edits:

- **A regression for the a = 10, d = 31 case**, which the self-test did not cover. It now checks both that the predicate rejects it *and* — via a deliberately wrong `_split_exists` helper defined inline for the purpose — that conditions (i)–(iii) on their own **do** admit it, so the test pins the gcd clause as the thing doing the work rather than merely observing a rejection.
- The docstring's "Resolves item A19 of pending-checks.md" repointed (no A19 exists), and the gcd-versus-split independence written into the header prose alongside the existing prime-power-versus-split warning, since they are the same class of error one level apart.

### 13.2 `solvable_relaxation.py` — two substantive corrections

1. **The `OLIVER` dict was v4-era and carried the retired value.** It keyed 24 residues with **1/9 at 7, 15** — the pre-correction three-part F = 4 reading — and asserted "seven ceilings". Rekeyed mod 12 to the six current constants, with 7 folded into class 3 at η = 1/2. The dependent checks moved with it: the worst-ratio check now asserts 11 is the argmax rather than naming 11 and 23; the old "at 7 and 15 the whole cost is the fusion count, η being 1 on both sides" check — which asserted the *retired mathematics* and passed because the dict agreed with it — is replaced by one asserting class 3's ratio is the η = 1/2 value; and a new check asserts the chain is free on six of twelve. A guard now asserts the table covers all twelve residues, so a future partial rekey fails loudly.
2. **The floor comparison was stated against the wrong constant.** It checked both unconditional floors against 0.05051 — the class-5 ceiling — and passed trivially. The note's actual claim is asymmetric and is its §3½ headline: **1/9 exceeds Oliver's worst conditional ceiling 7 − 4√3 = 0.07180, and 1/16 (= 0.0625) falls just below it.** Both directions are now asserted separately, so the asymmetry cannot be lost again.

Also: the default table argument moved off `mu_table_safe_v4.csv`, and the script now **prints the two figures the note quotes and the rebuild moves** — the exact-attainment count and the class-11 exceedance share — against whatever table it is given, so the note's pending marks have a regeneration command rather than a description.

**One document figure corrected as a result.** The note's "86 of the 118 class-11 values" has the right numerator and the **wrong denominator**: run against the v4 table the script gives **86 of 163**. On the current partial rebuild it is 58 of 65. The note's pending mark now records both, and the fraction is no longer stated as a bare count.

### 13.3 Registered in `pending-checks.md`

`solvable_relaxation.py`'s **comparison pass** is now **R6c**, owed on every table extension — the rest of the script computes B_solv from scratch and reads no table, so only that pass expires. It earns an item rather than a line in R1 because it is the cheapest independent check available on a rebuild: no certificate, no GAP, no second enumeration, and a violation of B ≤ B_solv would mean the Oliver side is crediting a class no solvable group carries. The item also records that the two figures the script prints — the attainment count and the class-11 share — are what the note's pending marks should be requoted from, with the wrong-denominator incident as the reason to requote rather than copy forward. Indexed in the banner, bringing the owed-run table to twelve.

`k3_galois.py` is **deliberately not registered**: it takes no table and scans a fixed range of a, so it is static, and one run per environment suffices. R6c says so explicitly, so the absence reads as a decision rather than an oversight.

### 13.4 Still owed

Neither script's arithmetic was re-verified from scratch here — §11's independent recomputation already covers the quantities they assert, and the two agree wherever they overlap (0.12296 at 551, 0.49981 at 2594, the k ≥ 3 exclusion, 58 of 65). The medians `solvable_relaxation.py` prints (0.16836 / 0.4156 on the v4 table, 0.16882 / 0.4182 on the abstract partition maximum) still differ slightly from the note's quoted 0.16734 / 0.4167, which look to predate a range or filter change; the note now describes what the figures are over, but the exact provenance of the quoted pair is unreconciled and is the one loose end in this pair of files.


## 14. R6a's two runs, and `audit_fmid.py`'s table argument (Opus, same session)

### 14.1 R6a is satisfied — both runs verified independently, not just read

**Filtered, n ∈ [12000, 24000].** All six classes approach their tabulated constants **from below**, ratios 0.9994–0.9999, with the expected (F, η) at every one: F = 2 at classes 1, 3, 5, 7, 9 and **F = 4 with η = 1/3 at class 11**, which is the row that had to come out right for the entangled correction to hold. All six mod-12 pairs {a, a+12} agree in cap, F and η. This is the re-derivation doing its job — it scans real configurations rather than replaying the congruence argument, so agreement is evidence rather than tautology.

**Unfiltered, n ∈ [8000, 16000].** Exceedances at exactly **3, 5, 7, 11**, as R6a predicts, and — the check that mattered — **every witness c is a prime power**: 2048 = 2¹¹, 2187 = 3⁷, 4096 = 2¹², 2187. The candidate-list defect that admitted 6, 12, 20, 24 is fixed, and this output is the confirmation.

**All six witness densities were recomputed from scratch** rather than taken on trust, scoring each configuration from its (F, c, r) and maximising over q-power divisors of r − 1. Every one reproduces to within 5 × 10⁻⁵, and the binding term is identifiable in each case (at class 3 it is the within-class cross term (F/2)c² = 2048², not the matching or foreign intra). The residual difference is rounding in the reported column.

**One documentation defect found by doing this.** `ceiling_rederive.py`'s own docstring described the escapes as *"classes 5, 11, 17 and 23 … by 1.48× at class 11 … via c or oddpart(r−1) being a power of 3"*. All three details are wrong now: the classes are 3, 5, 7, 11 (mod-12 keying), the class-11 factor is 1.74×, and the mechanism is **c a pure power of 2 or of 3** — 2048 and 4096 are the class-3 and class-7 witnesses, and neither has anything to do with ℓ = 3. Corrected, and the prime-power witness check written into the docstring rather than living only in `pending-checks.md`. The same wrong mechanism had propagated into R6a's text and is fixed there too.

### 14.2 `audit_fmid.py` — table as argument, and which table is right

The hardcoded upload path is now a positional argument defaulting to the current table, with `--nmax`. The docstring gained a **WHICH TABLE** section, because the answer is not symmetric and the asymmetry is the useful part:

> The screen compares an **optimistic candidate score** against a **recorded B(n)**. A table that *understates* B makes it **fire more often**; one that *overstates* B makes it **miss**. A stale table is therefore noisy rather than unsound — the tolerable direction — but its hits are uninformative.

**Demonstrated rather than asserted.** Against v4 the screen reports **2 hits**, n = 1739 and 2223. Both are artefacts of stale rows: the current enumerator scores those n at **118341** and **307193**, against candidate scores of 97656 and 166872. Neither hit survives contact with a current value. Worth recording *why* they looked like hits — at 1739 the candidate is two fused classes 2×313 + 2×313 + 487\*, while the enumerator's actual winner is the single class 4×313 + 487\*, i.e. the same blocks fused once rather than twice, which the shared-block-count screen does not generate.

**A coverage trap, closed.** The v5 run returns 0 hits — but 1739 and 2223 are past the partial rebuild's frontier, so they are not screened at all, and the clean verdict is partly clean by absence. A short frontier's silence looks exactly like a pass. The script now prints, before the verdict, how many **non-prime-power** n in range are missing from the file (prime powers excluded, since their absence is correct): currently **1,274 rows screened, 912 unscreened values in [6, 2600]**. R6b now says to read that line first.

### 14.3 What this leaves

R6a is done and marked so, with the standing rerun condition (§3.3.5 or the script changing) kept. R6b remains owed and is now explicitly owed *twice over* — once for the table it reads and once for the range it covers; it will not be satisfiable until the rebuild's contiguous frontier reaches 2600. The banner index is unchanged at twelve, since R6a's entry was never in it.


## 15. Review of `chiral-graph-properties.md`, `monotone-transitive-note.md`, `general-k-note.md` (Fable, same session; edits made)

*All three were reviewed against the current framework state, and the general-k note's higher-arity claims were tested computationally, since no computation had ever exercised them. That testing found one genuine mathematical error and confirmed two open predictions; all documents edited in place.*

### 15.1 The mathematical finding: general-k's θ_k formula fails from k = 5, and it was verified in both directions

The note stated **θ_k = max{j ≤ k : j | d}**. The correct rule is **θ_k = max{j : j | d, and j | k or j | k − 1}**: a twist subgroup of order j acts *freely* on 𝔽_c^× and fixes 0, so a stabilised k-set is a union of full j-orbits, plus possibly 0 — j | k without the origin, j | k − 1 with it. The two rules agree for k ≤ 4 (divisors of k and k − 1 cover {1..k} there) and part at **k = 5, j = 3**: an order-3 twist stabilises no 5-set at all, since 3 divides neither 5 nor 4.

**Computed:** at c = 13, k = 5 the true minimum is **39 at both d = 3 and d = 6** — cd/1 and cd/2 — where the old formula predicts 13 and 26. The corrected formula reproduces both. Two things worth recording about the error's anatomy: the j | k − 1 branch was *already load-bearing at k = 3* — the θ = 2 case is the antipodal pair **plus the origin**, which the k = 3 documents caught in a parenthetical without isolating the mechanism — and the same overreach infected the γ criterion's escape clauses, whose gcd(d, L_k) and gcd(a, L_k) conditions assert stable sets that from k = 5 need not exist. Corrected: the twist condition is **gcd(d, k(k−1)) = 1**; the subfield clauses are stated with their size conditions, closed at k = 3, 4 and open beyond; and the "supply falls superexponentially by Mertens" paragraph is retracted — the corrected conditions run through the primes of k(k−1), a mild thinning. The same slip appeared at two sites in `three-uniform-note.md` (the general-k box in §2.3 and open item 7) and is fixed there, along with a precision repair to §2.1's proof sentence, which claimed "m | 3" while its own parenthetical used the m = 2 antipodal case.

### 15.2 Two of general-k's open items resolved by computation, in its favour

**§6 item 1, at exactly the case it named** — k = 4, c = 32, d = 31, m = 5: computed minimum **1240 with the Galois part, 248 without**, ratio exactly 5 = lpf(a), both equal to c·d·m/κ₄ with κ₄ = τ·θ·γ = 4·1·1, and the full orbit partitions consistent (5×248 + 35×992 = C(32,4) = 1240 + 7×4960). This is the first computational confirmation of the γ criterion beyond k = 3, with τ and γ acting simultaneously. **§6 item 2**: τ₄ = 4 confirmed at c = 16 — minimum 4 under translations alone (the orbit of an affine 2-flat) and 20 = 16·15/(4·3) at full twist. Both items struck in the document with the results recorded; what remains open is the k ≥ 5 necessity direction, now stated against the corrected θ. Proposition 1 itself — the three-layer decomposition with no fourth source — is sound and survives untouched; only the per-factor values needed repair.

### 15.3 `monotone-transitive-note.md` — internally inconsistent with its own §4 correction, now reconciled

The document contains a §4 box correcting the Illies record (his counterexample is to the *non-monotone* version; the monotone conjecture is open, verified through n = 14) and a §3 revision finding that degree 10 fails via T(10,7) = A₅ on pairs. **Three passages had not been updated to match either.** §5's opening still said "the general conjecture is false … survives to degree 11 and dies at 12" — contradicting both — and is rewritten: the *criterion* fails first at 10, the conjecture is open, and a criterion failure is an open door, not a counterexample. §6 item 2 still framed the Illies identification as a potential "contradiction with Proposition 1"; since Illies's function is non-monotone, Proposition 1 says nothing about it and no outcome can contradict anything — reframed as history. §6's negative-control item said the CSP pipeline would be "validated against a known counterexample" without noting that a *monotone-constrained* run cannot reproduce a non-monotone example — the monotonicity switch-off is now stated as a requirement, and the duplicate item numbering (two 4s) fixed, plus a leftover "nine open" → six. The mathematics checked clean: Proposition 1 and its χ = 0 argument, the Sylow proof of Proposition 2, the transitive-group counts per degree against the standard library, and Vipul's degree-2p construction (order 2^{p−1}·p, even generators, E normal under the block cycle, Oliver with trivial top) — re-derived and sound, including the p = 2 Klein degeneration.

### 15.4 `chiral-graph-properties.md` — clean, and unusually so

Every parity rule re-derived by hand from cycle types: (T), (M), (F1), and (F2)'s entangled cycle structure (one F-cycle on the zeros, (c−1)/d cycles of length Fd, sign (−1)^{F−1}(−1)^{(Fd−1)(c−1)/d}, giving +1 at full twist for every even F and odd c). The AGL(1,c) ⊄ A_c computation at odd c; the c mod 4 split with −1 ∉ T exactly at c ≡ 3 (mod 4); Theorem 2's orbital lists (all row sums check); the ported cap formula cap_F(η; ε) = εη/(√ε + √(Fη))² re-derived from the balance argument; both penalty ratios (0.686, 0.754) and the coincidence pair cap₁(1;½) = 3 − 2√2, cap₂(1;½) = 1/9 recomputed exactly. The document is fully post-correction — (F2) as the applicable rule, F = 4 available at odd n, six mod-12 ceilings unscaled, `mu_enumerate_v3.py` — and consistent with the bridge's §4b clause, which was written from the session record and can now be considered sourced. One cosmetic edit (a struck item's "mod-24" label). Its sharpest structural point stands as written: the c ≡ 1 (mod 4) penalty applies only to unfused blocks, so the entangled generator is what saves the chiral ceilings — the correction and the chiral analysis reinforcing each other.

### 15.5 Skipped

The monotone-transitive scan itself (`oliver_transitive_scan.g`, GAP) and its CSP tables were not rerun — internal consistency and the group-theory spot checks stood in. The chiral document's computational verifications (§3's sign checks, §5's group orbital lists) were re-derived rather than re-run. general-k's §3 ledger row on k = 4 full density (item 3 of its open list) remains open as stated. The 10⁶ ladder run continues (240k, floor unchanged at 0.04621 @ 2759).


## 16. R6's GAP sweeps at `-o 8g` (Opus, same session)

**All three runs clean, no truncation, and the guard's job is done.** 134 / 241 / 211 rows; every line parses against the full row grammar and carries a verdict; all `ok`. The `-o 4g` truncation that motivated the rerun does not recur, so `pending-checks.md`'s invocations now specify **`-o 8g`**, with the reason recorded next to the truncation warning rather than only in the command: the maxf = 2 sweep's largest groups reach order ≈ 1.8 × 10⁶ on 194 points, which 4 GB does not hold.

**Verified rather than read.** The intra column was re-derived from (F, c, d) at **all 586 rows across the three live files** and reproduces exactly — including the `char2` flag, which is the piece most likely to be wrong and is exercised at c = 4, 8, 16, 32, 64. Four structural invariants hold in every row: n = F·c, d | c − 1, c a prime power, and |Γ| = c^F·d·F. Coverage of the wide sweep is complete: **every prime power c ≤ 100 appears, with every prime-power twist d | c − 1 at each**, no gaps — so the "later rows untested" defect is fully retired rather than merely absent from the summary line.

**Both controls fire, and fire *only* where they should.** 21 of 134 rows in the narrow control and 59 of 241 in the maxf = 4 control go UNDER-SCORE. In every one the *expected* column is unchanged and the *actual* is strictly lower, and — the check that makes the control informative rather than decorative — **no `ok` row differs from its live counterpart at all.** So the strip damages exactly the rows where stripping changes orb(c, d) and nothing else, which is the predictor R6 already states in place of a remembered count.

*One methodological note.* An obvious-looking invariant — that the reported intra and cross classes partition C(n,2) — **fails everywhere and is not a defect**: the script reports the *minimum* class of each type with its multiplicity, not the full class list, so at F ≥ 3 there are further cross classes of other sizes. I record it because it is the kind of check that would look like 91 failures in a summary and is really one wrong assumption about the output format.

R6's owed-run entry is struck from the banner index, which is back to eleven.

### 16.1 R6's four "still owed" items: none is blocked, and the order should change

Each was prototyped far enough to judge cost and to see whether anything stands in the way. **All four are buildable in `shape_realize.py`'s existing Python** — `orbitals()` plus `field()` — with no table dependency and, for three of them, no GAP. The ordering in R6 has been rewritten to **3 → 4 → 2 → 1**, roughly the reverse of how they were written, for reasons the prototypes made visible:

- **Item 3 (foreign η) is the cheapest by a wide margin and should be first.** A foreign block is a *prime* block, so no field construction arises: AGL(1, r) at twist t is two permutations of ℤ/r. Prototyped over **47 (r, t) pairs**, r ≤ 43, every prime-power t | r − 1 — **0 mismatches**, endpoints and odd-t (no halving) cases included.
- **Item 4 (inter-class F·c·r) is cheaper than its description suggests.** "A chain element linking two classes" is one generator: a diagonal element acting as the twist on the matching block and as twist or translation on the foreign one, which is precisely what makes Γ₁ cyclic across both. Prototyped at seven (c, d, r, t): every intra and cross term realised exactly as scored, the cross class a single orbital of size c·r throughout. **The prototype also walked into the trap `fused_class_group` documents** — building c = 9 by translating by 1 generates ℤ/3, not 𝔽₉, and reports a spurious mismatch. Recorded in the item, since anyone writing this fresh will hit it.
- **Item 2 (Lemma C) is reframed by its prototype, and that is the useful outcome.** Forcing the matching twist and the foreign translations into a single cyclic layer (r | d, eight cases) **did not strip the matching twist at all** — the matching intra came out at full uncoupled score every time. The cost landed on the **foreign** block, left with translations only: orbital r, t = 1. So the check to write is not "did the matching block lose its twist" but *"what is the largest foreign twist still realisable once the layer is cyclic, and does the enumerator credit more than that"*. That is a statement about the foreign term, so it wants item 3's machinery first — which is why 2 moves after 3 and 4 despite being the highest-value of the four.
- **Item 1 (the Oliver test) has the only real dependency**, and it is mild: it is GAP-side, so it needs the `-o 8g` environment rather than the Python harness, and the shapes that can make it fail are exactly the two-class ones item 4 builds. Doing it after 4 means those shapes are specified once rather than invented twice.

The prototypes are exploratory and are **not** recorded as passes — they cover a handful of parameters with no `--strip` control, which by R6's own standard makes them not yet evidence. What they establish is that nothing is blocked.


## 17. R6 item 1 implemented: `oliver_negative.g` (Opus, same session)

*Written to be run on the GAP machine in this session. Not executed here — no GAP in this environment — so every constructed group's orders and structure were verified independently in Python first, and the script asserts them as its own first expectations so that a construction slip is distinguishable from a predicate failure.*

**The problem restated.** `ark_shapes.g` reports `oliver=0` on every row. That is correct and unavoidable — a single fused class always carries the chain — but it means a predicate hardwired to return 0 would produce byte-identical output. The column is not evidence until something can move it.

**Four parts, in increasing strength.**

- **A, asserted negatives.** Simple nonabelian groups must return `fail`, by a theorem rather than a computation: only N = 1 and N = G are available; N = 1 leaves G/N = G, no p-group; N = G needs G/O_p(G) cyclic, false. A₅, A₆, A₇, PSL(2,7), PSL(2,11), S₅, S₆, plus four positives (C₆, elementary abelian 8, S₄ via A₄, AGL(1,5)) so the predicate is not merely always-fail.
- **B, a population where the verdict varies.** All transitive groups of degrees 6..DEGMAX, distribution reported, **solvable non-Oliver groups listed separately** — those are the informative negatives, part A's insoluble ones being cheap. Asserts both directions: some fail, some pass. This is the part that converts the column into evidence, and it is also the one that can be skipped by a missing `transgrp`, so a missing package counts as a failure rather than a silent pass.
- **C, the two predicates against each other.** Witness = 0 must imply search ≠ fail, since "is *this* chain good" is strictly stronger than "is there *any* chain". Guarded on bottom-layer rank a·F rather than |G| — the 3×32 lesson, where |G| = 3.0 × 10⁶ exhausted 4 GB while 4×25 at 3.8 × 10⁷ completed.
- **D, broken chains, one clause at a time.** D1 violates the p-group clause only (Γ₂ = C₂² × C₃, order 12, normal, cyclic quotient of order 3). D2 violates cyclicity only (two independent order-4 twists on two 5-blocks, quotient C₄ × C₄ of order 16). **D2′ is the minimal pair**: the same two blocks with the twists carried diagonally on one generator, quotient C₄ — must be *accepted*, which is what shows the witness responds to the chain rather than to the point set. D3 violates normality (a point stabiliser in AGL(1,5)).

**The design point worth keeping.** D reports *two* verdicts and asserts only one. A rejected witness does not make the group non-Oliver — another chain may exist, and at D1 and D2 one does. Printing the search verdict beside it without asserting it makes the witness-versus-search gap visible as the intended distinction rather than leaving a reader to discover it as an apparent inconsistency.

**Verified before writing, so failures are attributable.** All part-D orders were computed independently: |Γ₂| = 12 and |G| = 36 with normal Γ₂ and cyclic quotient at D1; |G| = 400 and 100 with quotients 16 and 4 at D2/D2′; Γ₂ of order 4, non-normal in AGL(1,5) of order 20 at D3. The script asserts each of these as an expectation of its own, so if one fails the message says "the construction is wrong" rather than "the predicate is wrong".

**Still open after this**, and it belongs with item 4 rather than here: the specifically *configuration*-shaped negative the item first envisaged — a foreign block whose top prime does not divide r − 1 — needs the two-class builder. D1 and D2 cover the two ways such a configuration actually degenerates, which is what can be tested without that builder.

### 17.1 Run: A, B and C clean; one parse error at D, fixed

**The syntax error was where I did not predict.** I flagged the `LoadPackage` guard and the `Expect` helper's global assignment as the likely failure sites; both were fine. The actual fault was **implicit string concatenation** — `"first part "` on one line and `"second part"` on the next, which C joins and **GAP does not**: adjacent literals are a parse error. One `Expect` label was wrapped that way. Fixed by shortening the label to a single literal, and the whole file re-scanned for the pattern (that was the only instance, and the one same-line hit is a false positive — a comma-separated `Print` argument list).

*Worth keeping as a rule:* when writing GAP without an interpreter, wrapped string arguments are the failure mode to look for first, ahead of anything semantic. A bracket-balance pass will not see it, because the brackets balance.

**Results of the parts that ran.**

- **A**: all seven asserted negatives return `fail`; all four positives pass. The predicate is not always-fail and not always-pass.
- **B — the substantive result.** Over degrees 6..11: **108 Oliver, 52 not.** The column is now evidence. And **eleven of the negatives are solvable** — T(8,42), T(8,45), T(8,46), T(8,47) and T(9,23), T(9,25), T(9,26), T(9,28), T(9,29), T(9,30), T(9,31), orders 216 to 1296 — which is more than the item asked for. Part A's insoluble negatives fail for a reason so cheap it tests almost nothing; these do not. **They also answer a question the framework had not put directly: solvability does not imply Oliver, and the shortfall is large** — roughly a third of transitive groups at degrees 8 and 9 are solvable-or-not and still fail the chain. That is the same quantity `solvable-relaxation.md` prices as "the chain's cost", now visible as a group count rather than as a density ratio, and the two are worth comparing: the relaxation measures what the chain costs *in orbital density on the shapes that have one*, while this measures how many groups have no chain at all. Neither bounds the other, and the note should not be read as if it did.
- **C**: 71 shapes compared under both predicates, zero disagreements in the direction that would be a bug (witness passing where the search fails).

### 17.2 Full run: PASS

All four parts, every expectation met. **Part D's two verdict columns diverged exactly as designed**: D1's witness rejects while the search finds a chain at **q = 3**; D2's witness rejects while the search finds one at **q = 2**; D2′ accepted; D3 rejected on normality with the group still Oliver. That divergence is the item's real product — it is the first output anywhere in the battery where the `oliver` column carries information rather than a constant, and it demonstrates the witness/search distinction on a live case instead of asserting it in a comment.

**Two things the part B table does *not* show, both worth recording before anyone cites it.**

1. **"No insoluble group is Oliver" is a theorem, not a measurement.** The chain is p-group by cyclic by q-group — solvable-by-solvable-by-solvable — so Oliver ⇒ solvable, and that column's zero is forced. It was pleasing to see and proves nothing. **Only the eleven solvable failures are evidence**, which is why the script lists them separately; had it reported only the aggregate 52, the informative content would have been invisible inside a tautology.
2. **The solvable failures sit only at degrees 8 and 9** — 4 of 45 and 7 of 30 — with every solvable transitive group at 6, 10 and 11 Oliver. Tempting to read as "the chain is free away from prime powers"; that reading is wrong twice over. The range is short, and 8 and 9 are precisely where a solvable group has room to be assembled from three primes with no usable normal layer. More importantly **a non-Oliver group is not a counterexample home**: at prime-power degree a Sylow subgroup is transitive and Oliver regardless, so those degrees are settled whatever the individual groups do.

**One incidental identification worth keeping.** T(8,36), order 168 = 8·7·3, solvable, is the **only** group in the whole population with a nontrivial top prime other than 2 — every other Oliver verdict is `0` (trivial top) or `[2]`. It is AΓL(1,8): translations C₂³, twist C₇, Frobenius C₃ — exactly the framework's Galois-block chain, the c = 8 row of `three-uniform-note.md` §3.1. The one place in a 160-group sweep where q = 3 appears is the construction the k = 3 work is built on, which is a small piece of external corroboration for that shape being genuinely special rather than an artefact of how the census was written.

**Fed back into `monotone-transitive-note.md`** §3, as a sharpening of its Proposition 2 discussion: the group-versus-subgroup distinction it draws for Sₙ in §5 is now instantiated at small degree with counts, since eleven groups fail the chain themselves at degrees where a Sylow subgroup satisfies it and settles the question anyway.


## 18. `pending-checks.md` split into a work list and a lessons file (Opus, same session)

*The file had grown to 504 lines carrying two different kinds of content: what to run, and why the checks are shaped as they are. Split along that line. `pending-checks.md` is now 386 lines and holds only work; the interpretive material moved to a new **`verification-lessons.md`** (107 lines), dehistoricized throughout.*

### 18.1 Why a new file rather than folding into `monotone-transitive-note.md`

That was the obvious candidate and it is the right home for exactly one of the moved items — the transitive-group population and what it says about group-versus-subgroup admissibility, which went there in §17. The rest is not about the transitive setting at all: it is **cross-cutting methodology** about how this programme's checks fail, and it would be invisible filed under a note on monotone Boolean functions. So `verification-lessons.md`, with the population result staying where it belongs mathematically and only a pointer from the lessons file.

### 18.2 What moved

- **The four failure sites** (T1's taxonomy), which was the largest interpretive block in the file and is referenced from three items. Now `verification-lessons.md` §1, with T1 reduced to what is owed: a further independent reading, and the standing observation that a reading running sites 1–3 leaves site 4 untouched.
- **Asymmetric failure directions** — under- versus over-scoring, rebuilds never lowering, anti-permissive conditions being invisible, stale screen inputs being noisy rather than unsound, and the float-boundary argument from A20. Now §2. A20 keeps the code and the behavioural check; the reasoning is a pointer.
- **"Silence that reads as success"** — truncated rows, skipped shapes, partial inputs, inert controls, tests that cannot fail, vacuously agreeing modes. Now §3, gathered from six separate items that each stated one instance.
- **Witness versus search**, including the two cautions on reading an admissibility population. Now §4.
- **Figure and range rot**, including the asymptotic-verdict-versus-count point and the contiguous-prefix rule. Now §5.
- **Cost as a design constraint** (§6) and **tooling notes** (§7) — the output-formatter corruption, under-building a group, entangled-versus-separate generators, GAP's lack of implicit string concatenation, guarding on rank rather than order.

### 18.3 What stayed, and the rule applied

Kept in `pending-checks.md`: commands, inputs, expected output shapes, and the traps **specific to running that particular check correctly** — which table to point a screen at, that `-o 8g` is required, that a control's failure count is checked against a predictor, that a worklist must be regenerated before it is consumed. The test used throughout: *would someone about to run this need it, or is it something they would want to have read at some point?* The second kind moved.

Also trimmed as work-list-irrelevant: R6a's completed-run box (reduced to its conditional rerun trigger), the long per-script descriptions in R1 (reduced to what to read off each), T4's and T6's unchanged prose (left, being genuinely owed items), and the historical framing in T5a and A9.

### 18.4 One structural correction found while trimming

The banner index and the item bodies had drifted: `ceiling_rederive.py` was still listed as owed in the banner after R6a was marked complete, and `audit_fmid.py`'s entry did not mention the coverage half of its obligation. Both fixed. The index is now ten entries and each has a matching `## R…` section — asserted mechanically rather than by eye.


## 19. Review of `small-degree-computation.md` and `small-degree-verification.md` (Fable; sync pass, edits made)

*Scope per instruction: sync and currency only, no expansion of the small-degree framework.*

### 19.1 Verified clean

**The load-bearing comparisons hold against the current artefacts.** B(10) = 20 and B(12) = 18 re-read off `mu_table_safe_v4.csv` (rows n = 10, 12: mu_bound 20 and 18, densities 0.444444 and 0.272727), matching both files' m\* = B claims — and both values are stable under the entangled-generator correction, since orb(5,4) and orb(4,3) are capped at C(c,2) either way. "Theorem 2.1 at m = 5: 2·C(5,2) = 20" checked against the notes: Theorem 2.1 exists, is the n = 2·(odd prime power) exact-value theorem, and is the right citation. Census arithmetic re-added at both degrees (967 = 95+159+14+699 with 699 = 673+18+6+2; 7,115 = 295+657+67+6,096 with 6,096 = 6,004+88+2+2; stage sums 24+319+6+618 and 194+969+28+5,924 both exact). The two graph-count constants are correct (12,005,168 labelled-iso classes at n = 10; 1.65 × 10¹¹ at n = 12). χ(M₁₀) = −1215 = −5·3⁵ as stated. Neither file mentions Illies, F_mid, mod-24, or any retired constant — both are clean of the arithmetic programme's corrected material, mostly by not touching it. The stage-A count of 194 at n = 12 is consistent with 301 transitive groups minus non-Oliver-non-p and over-MAXT drops; no conflict with the monotone-transitive scan.

### 19.2 Stale references found and fixed (all in `small-degree-verification.md`)

Five cross-references pointed at a superseded numbering of the computation document, and two values disagreed with the notes' own implementation note:

- **"item 5b" → item 11**, twice (the Commands banner and item 1's levers): the EGF/cheap-battery decision that may obviate stage 3 is item 11; 5b is the did-stage-C-finish question and says nothing about the EGF.
- **"§8.4 route" → `small-degree-computation.md` §5.4**: the exponential-formula/EGF methods live in §5.4 (the χ kill); §8.4 is the truncation-knob table.
- **"§9.7" → §2.4**, twice (item 12's decisive-at-t≤3 claim; item 13's skeleton one-of-two): §9.7 does not exist in the current computation document.
- **Item 10's "d = 10" → d = 4**: the twist must divide c − 1 = 4, and the notes' §2.4 implementation note — which item 10 is citing — says (k = 2, d = 4). **"Theorem 2.4" → Theorem 3.1**, same source: the rotation-in-the-top-layer allowance is Theorem 3.1's, and no Theorem 2.4 exists in the notes.

### 19.3 Sync additions from this session's results

- **The Oliver predicate's status upgraded from *sound* to *exercised*** in both files (`small-degree-computation.md` §3.1; verification item 5): `oliver_negative.g`'s PASS gives the identical verbatim predicate seven asserted simple-group negatives, a 160-group population it separates 108/52 with eleven solvable failures, witness-vs-search agreement on 71 shapes, and four broken chains rejected clause by clause. Explicitly scoped: this verifies *the predicate*, and touches exhaustiveness (5a/5b) not at all.
- **The multi-prime-tag question (§8.6 / item 6) gains its first known-current datum**: the degree 6–11 population returns no two-prime verdict under the current predicate — weight on "groups genuinely admit at most one usable q", without settling the emitted files, whose intransitive and p-subgroup stages the population does not cover. The re-emission remains the decider.
- **§4.1's n = 10 attainer cell corrected to the artefact-pinned record**: eight groups, one partition, two conditions, wreath present as `B2:5x2:3.1` — the old cell named only `A:17`, `A:18` and implied both were the wreath. The trivial-top witness is an **order-200** group, not the order-800 wreath: a fused-class realisation with cyclic quotient, same order and partition as `aod` §3.2.3's entangled construction — stated with the honest caveat that two non-isomorphic order-200 realisations share the partition and the record does not say which `A:18` is.
- **§10 item 3 (Angel–Borja) annotated** with the arithmetic programme's deliberate deprioritisation, so the two files no longer imply different valuations of the same run without acknowledging each other.
- **`monotone-transitive-note.md`'s citation of §10 item 7 tightened**: that item's negative control is for the adversary game against Adamaszek's ℰ; the Illies CSP run is a control of the same kind for a different layer, and the note now says so instead of claiming identity.

### 19.4 Skipped

The two files' internal computational records (probe timings, VF2 throughput, dedup tables, the 230/203/27 reproduction) were spot-checked for arithmetic only, not re-derived from checkpoints — they are the verification file's own pinned artefacts and re-deriving them is its job, not this pass's. The `TemplateGroup` defect (item 10) remains open-deferred as recorded; no attempt to re-run any battery.


## 20. Lean: a toolchain obtained, and `ArkCore.lean` compiled with every proof complete (same session)

### 20.1 The toolchain, and the recipe worth keeping

elan installs but cannot resolve any toolchain in this container — every lookup, even for a pinned version, goes through `release.lean-lang.org`, which the proxy blocks (the "Unexpected character: H" parse error is the deny page). The toolchain **tarball** is on GitHub releases, which is allowed: download `lean-4.15.0-linux.tar.zst` directly, extract via Python's `zstandard` (no `zstd` binary in the image), and `lean` runs bare. **Mathlib remains unreachable** — its cache host is blocked and a source build is days — so `Note.lean` and `Basic.lean` cannot compile here. The recipe is in the Lean README; it converts "no toolchain available" from a standing fact into a solved problem.

### 20.2 What was built: the Mathlib-free core, proved

`ArkCore.lean`, 39 declarations, **compiles clean with zero sorries** against core Lean 4.15.0. It is the ℕ half of `Note.lean` + `Basic.lean`: `pairs` (core Lean has no `Nat.choose`) with the doubling identity; `orb` and **`orb_full`** (Basic's first sorry, proved — the full-twist 2-homogeneity, case split on the parity of c − 1); **Lemma D1**; **`size_of_capacity`** with the 0 < m degeneracy Basic flagged; **Proposition F.1 in squared form** `2m·k² < n²` (core has no `Nat.sqrt` either), via an explicit minimal-member lemma; the complete `decide` block — `dList`, the admissible-d table (verified beforehand against the note's mod-12 table, entry for entry), `twelve_needed_only_at_eleven`, the ℓ = 3 degeneration — and the prize, **`central_even` and `central_odd`**: the note's Theorem-arithmetic in ℕ, multiplied through by 350.

### 20.3 The compiler caught an error in its own draft, immediately

The block case's draft split the region at r ≥ 13 and closed the generic side by the slack chain 12·n(n−1) ≤ 300r² ≤ 350·r(r−1) − 4200. **That chain is false at r = 13** — r² − 7r − 84 = −6 there — and writing the proof exposed it before the compiler even ran; the split moved to 14, with r ≤ 13 forcing n ≤ 65 and going to `decide` (with the twist pinned to t = 1 by a monotonicity lemma, since the efficiency bound licenses exactly t ≥ 1 there). The satisfying structural fact: **the region's true numerical worst — ratio 1.0096 at n = 65, r = 13 — sits on the `decide` side**, which is *why* no uniform slack argument covers it and the finite check is load-bearing rather than decorative. This is precisely the README's advertised error class ("a min-of-polynomials evaluated at the wrong point" / thresholds off by one), caught in the formalisation's own first draft.

Environment lessons for the file: core Lean 4.15 lacks `Nat.choose`, `Nat.sqrt`, `by_contra`, `set`, `ring`, `push_neg`, `interval_cases`, `Nat.mul_sub`, `Nat.div_le_div_right`; it has `omega` (which abstracts nonlinear terms as atoms — the workhorse: prove product inequalities as `have`s, let omega do the linear gluing), `decide` with `Nat.decidableBallLT`, `ac_rfl`, `rcases`/`obtain`, `by_cases`, `calc`, `simp`. Doubly-nested bounded quantifiers under a list-membership ball failed to synthesize `Decidable`; primality as a `Bool` function sidesteps the instance question and is robust to the Mathlib instance churn `Note.lean`'s comment worries about.

### 20.4 Sync findings

- **`pending-checks.md` A9 and the Lean README contradicted each other — and the resolution went the wrong way first.** A9 said "Phase 0 (`Note.lean`) compiles"; the README said neither file had ever been compiled. I resolved it by treating the README (the designated home document) as authoritative and "correcting" A9 — **wrong**: `Note.lean` had compiled on Vipul's laptop, and the README's header was the stale artefact, describing the drafting container as if it described the project. Both now record the per-machine truth: `Note.lean` compiles on the laptop (Mathlib, sorries expected), `ArkCore.lean` compiles proved in the container, `Basic.lean` compiled nowhere yet. *Worth keeping from the episode: "which file is authoritative" is the wrong question when the two files describe different environments — the contradiction was real information about a missing dimension (per-machine status), not a tiebreak to adjudicate. The README now states compile status per machine.*
- **`Basic.lean` carried one stale string**: "the surd column of the mod-24 ceiling table" → mod-12. Everything else in both files checked current in the review before compiling — all six `capF` constants exact against the mod-12 table (including 1/8 at {3, 7} and 7 − 4√3 at 11 with the correct class labels), the `capF 4 1 = 1/9`-is-not-an-entry note, the entangled-generator commentary in §6, `HypH`'s `IsPrimePow` scoping, and the admissible table.
- The README gains the toolchain recipe, the ArkCore status, and the r = 13/14 episode as a concrete instance of its own thesis; phase 0's status line now says the ℕ half is done, with the Mathlib remainder enumerated (`Density`/ℝ wrappers, the `ZMod` CRT step, singular series).

### 20.5 What remains for the Lean line

`Basic.lean` on the laptop, which has never been run anywhere; then discharging `Note.lean`'s sorries there, importing the ℕ statements from `ArkCore` rather than re-proving them; then phase 2's balance-point lemmas per the README's phasing. A9's sync obligation now covers three files, and its status line is per-machine.


## 21. Fresh-eyes critical read of `enumeration-proof.md`, start to finish (Fable; edits applied)

*Prompted by the observation that the proved-vs-empirical gap has moved in both directions over the sessions — unexpected winners found, number-theoretic exclusions gained. Question: does the document's remaining gap structure hold up, and is it consistent with the companions?*

### 21.1 Verdict

The core architecture survives the fresh read. The B_refined ≤ μ ≤ B_safe sandwich with per-n certificate collapse is coherent; the proofs of B, B′ (incl. Step 0 and the degenerate branch), C, D1, D2, D2q, F.1, F.2, G.1–G.4 all read sound; and the gap structure is real and well-tracked. The ~15 findings below are **drift and cross-era inconsistency** — mostly pre-correction remnants and measurement statements from different table eras contradicting each other — not new mathematical errors in the document. The one mathematical error found this pass is in `Basic.lean`, not in ep (21.4).

### 21.2 Verified clean (recomputed or re-read, no issue)

Worked cases A–F recomputed (incl. n = 308's chain and terms, n = 3239's terms); the extraspecial table (18·4 + 54·5 = 342; orb rows); Cap(17)'s L(2¹⁶−1) = 257; E.2, E.3(i)'s p = 3 forcing, E.4's (16, 5) uniqueness logic; census row sums 900 + 777 + 493 + 16 = 2,186 and the S7 sub-counts; F.1/F.2/F.3 and the G.4 axis bounds; B′'s proof in full; Lemma C's proof (conjugation as a single power map) and its witness pairs; D2's three steps and D2q's seven; the F.3 box on the two-ladder offset — **confirmed sharp and correct**: s ≤ 1/√δ − 1 gives s ≤ 3 exactly at δ > 1/25, verified numerically; the sharp s-ladder confirmed at all four thresholds (1/9→1, 1/16→2, 1/25→3, 1/36→4).

### 21.3 Findings and edits (E1–E14, all applied)

- **E1** Corollary D2′ duplicated verbatim before and after D2q — first copy removed; the survivor's stale "supersedes reduction (R1)" pointer (current R1 is the equal-size merge, unrelated) reworded to the layer-independence point it was making.
- **E2** Header line said B′ had "one reading and no independent scrutiny", contradicting the inventory and item 3 ("read in detail by a second reader"). Fixed to second-read-confirmed.
- **E3** Part E's "general configuration" still said classes are "permuted by transitive q-groups (so each class has q-power size)" — pre-correction. Now F = F_mid·F_top.
- **E4** The realisability bullets built only top-layer fusion; added the entangled-cyclic-layer clause with the n = 33/78/105 regressions and the n = 255 battery row as its builds.
- **E5** "Cᵢ_F" typo → C_F.
- **E6** The certificate description said "F a q-power", contradicting the widened-F box three paragraphs later. Now "F any integer" with the split noted.
- **E7** Two sites (the E.3-corollary paragraph and J item 2) said s = 4 and s = 5 "become reachable below 1/16" — the slack ladder, contradicting item 2a's sharp statement in the same document. Both fixed to the sharp thresholds (1/25, 1/36), with the consequence stated: the theorem-side reduction is complete down to 1/25, not 1/16.
- **E8** Census S4 row's "16 winners" with a rising trend contradicted the first-instance table's "no winner in the computed range". Annotated: v4-era, 15 of 16 already exceeded by entangled readings (all but n = 1529), expect ~0–1 on rebuild.
- **E9** The three-part box's "R1 cannot merge because F₁ + F₂ = 2 is not a power of q" — pre-correction explanation, now false: the cyclic-layer merge **is** available at those odd q and is precisely what exceeds 15 of the 16. Rewritten.
- **E10** R1 itself scope-noted: as stated it is the top-layer case; the cyclic-layer merge extends it under the coprimality budget.
- **E11** "The unique two-foreign winner is n = 1175" contradicted the same Part's later statement that n = 1175 is now fused (`1x619* + 4x139`). Fixed: only known two-foreign instance is n = 3059, beyond the contiguous range, the global density minimum.
- **E12** "Lemma C's gcd condition holds in all 5,025" — retired phrasing. Reworded as: no witness carries a share, consistent with C′'s domination; the admissibility reading is retired.
- **E13** Part I's n = 10 comparison row said one attaining group; aligned with the pinned record (8 groups, exemplar T(10,17), order 200).
- **E14** J item 1 claimed all three older sub-narrowings "follow from k ≤ 3"; the third (at most one fused class) does not — two fused classes are only two parts. Fixed: first two follow, third separately open.

### 21.4 The one mathematical error: `Basic.lean`, not ep (E15, applied)

`Basic.lean`'s header and §4 claimed the documents' "δ > 1/25 → s ≤ 3" was an off-by-one error with truth s ≤ 4. **Backwards.** s ≤ 3 is the sharp, correct statement; Basic.lean had silently substituted the k-ladder (F.3: δ > 1/(K+1)² → k ≤ K, sharp for the part count) for the s-ladder — exactly the confusion ep's F.3 box warns produces "an off-by-one in either direction". The `s_threshold` theorem as stated is true-but-slack for s (it *is* the k-ladder); header, docstring and the three ladder examples rewritten, with a note that the header itself was a casualty of the confusion it now documents. Honest correction owed and recorded: I had marked Basic.lean "checked current" earlier this session (§20.4) and missed this — the capF constants were verified numerically then, the ladder block was not. `ArkCore.lean` is unaffected (it contains no s-ladder).

### 21.5 Gap inventory, and the cross-references

Per the session's instruction, the remaining proved-vs-empirical daylight is now inventoried in one place — `pending-checks.md`, "The enumeration-proof gap inventory", six items: (1) Part 0 completeness [site 4; only the GAP degrees test it]; (2) the two-part reduction of Thm 2.3 [verified to 1200, Goldbach-tier]; (3) k ≤ 3 below 1/16 [J1]; (4) the collapse's theorem-side residue — E.3(ii)'s global promotion plus the theoremless s ≥ 4 branches below 1/25 [J2/J2a]; (5) J0a's non-semilinear stabilisers [attainment only]; (6) B′'s standing invitation to further scrutiny. `arithmetic-of-density.md` (header) and `orbital-evasiveness-notes.md` ("What none of this touches" box) now reference the inventory with one line each, so it has one home rather than three.

### 21.6 Skipped, for the record

Not re-derived this pass: Part H's cost model beyond spot-reading; the measured distributions in Part I (marked ⟦PENDING-REBUILD⟧ and owned by the rebuild); `brute.py`'s 142-value agreement (recorded, not rerun); the q-pinning measurements (32,830 parts) and the e = 1 table (2 configurations), taken as recorded. The two-part reduction's n ≤ 1200 verification and the 437-shape sweep are R-item territory, not re-run here.


## 22. Lean cross-environment check: the first real skew, and the convention it fixes

Vipul ran all three files under the laptop toolchain: **`Basic.lean` passes** (its first compile anywhere — the A9 next-step is discharged) and `Note.lean` reconfirmed. **`ArkCore.lean` failed there with 3 errors, 0 sorries** — all one cause: `List.mem_cons_self` takes its arguments *explicitly* in core 4.15.0 and *implicitly* under the laptop's toolchain, so `List.mem_cons_self a rest` typechecks in exactly one of the two environments. Three sites (in `exists_min_member` and `length_mul_le_sum`) now discharge the membership with `simp`; the container recompiles clean, zero sorries.

Worth keeping, because it is a small instance of the same shape as §20.4's per-machine episode: **a file can be simultaneously correct and uncompilable, and which one you observe depends on where you run it.** Nothing about the mathematics was wrong — the proof term was fine, the *name* was the version-dependent part. Hence the convention now recorded in the file header and A9: prefer a tactic to a named library lemma wherever the goal is trivial, since the name is what carries the dependence. Flagged as the likeliest next offenders: the `Nat.mul_le_mul_left` / `mul_le_mul_right` / `mul_lt_mul_left` family, whose argument order and implicit/explicit split have both moved historically — this file uses them at a dozen sites and cannot test them from here.

Status now, confirmed on both toolchains: **all three Lean files compile, and `ArkCore.lean` compiles in both environments with 0 errors, 0 warnings and 0 sorry** — the only one of the three that is *proved* rather than merely well-formed, the other two carrying their sorries as expected state. The README now states this as a per-file/per-environment table, since "compiles" and "proves" have come apart across the set and only the checker's sorry count separates them. Next is the substantive step rather than a compile step — discharging `Note.lean`'s sorries on the laptop, importing the ℕ statements from `ArkCore` rather than re-proving them.

## 23. Discharging `Note.lean`'s sorries by import (draft; needs a laptop run)

All ten sorries now have proofs. The design point is that **six of them are not proved here at all** — they are `exact` applications of `ArkCore` theorems already compiled with zero sorries in two environments. That is deliberate and is the README's own caveat applied to itself: re-proving the ℕ core in `Note.lean` would create a second artefact downstream of one set of claims, which is the failure mode (site 4 of `verification-lessons.md` §1) that the `F_mid` episode was an instance of. Importing means one claim, one proof, one place to fix.

**The bridge is a single lemma.** `ArkCore` has no `Nat.choose` — it is not in core Lean — so its binomial is `pairs n = n*(n-1)/2`. `pairs_eq_choose` is the only place the two spellings meet (`Nat.choose_two_right` then `rfl`; the `rfl` step verified in the container against a standalone copy of the definition). Everything else states its result in Mathlib's `choose` and rewrites through it. The ℕ definitions in `Note.lean` became `abbrev`s of `ArkCore`'s, so the imported lemmas apply without transport.

**Imported (six):** `blockValue_lower`, `mStarOdd_le_even`, `central_even`, `central_odd`, and the whole `dList`/`admissible` `decide` block. `blockValue_lower` was a `Note.lean` sorry and is *pure ℕ*, so it moved into `ArkCore` and is now compiled there — the file grew by one theorem and recompiles clean.

**Written against Mathlib (four, plus the bridge):** `delta0_le_density` — the cast step, deliberately factored out because it is the *only* real-number content in §4 and writing it once rather than twice is what keeps the unit in one place; `coprime_iff_not_dvd` (`Nat.coprime_comm` + `Nat.Prime.coprime_iff_not_dvd`); `unconditional_density`, needing `(2m).choose 2 = m(2m−1)` and careful `Nat.cast_sub` handling; `half_is_ceiling`; and the assembly, which unpacks `HypH.witness` and splits on the two shapes.

**What I verified and what I could not.** Every statement was re-checked numerically before being written: `pairs = choose` to n = 500; `central_even`/`central_odd` over the whole region to n = 1200 with worst ratio **1.0096 at n = 65** in *both* parities — matching the note's recorded figure and confirming the odd case's worst sits at the same place; the `unconditional_density` identity as exact rationals to m = 200; `blockValue_lower` over its region. What I could **not** do is compile: Mathlib is still unreachable here. So the Mathlib-facing half is unverified by any toolchain, and the expected failure mode is name or signature drift — `List.mem_cons_self` (§22) already showed this project has that exposure — rather than false statements. The file header now labels the two halves by assurance level so a green checker is not read as uniform confidence.


## 24. `Note.lean` on the laptop: import mechanics, and the second name-drift failure

Two rounds, both instructive, neither mathematical.

**Round 1 — the import.** `unknown module prefix 'ArkCore'` with both files in one folder. Lean resolves imports through `LEAN_PATH` and lake's build dirs and loads the compiled `.olean`; the source file's location is irrelevant and `PATH` is never consulted. Reproduced exactly in the container and confirmed the fix there before recommending it. Vipul found two further execution gotchas the recipe had to absorb: `LEAN_PATH` must be passed **on the same command line** (exporting it beforehand doesn't take), and it must be `LEAN_PATH=$PWD` rather than `$PWD:$LEAN_PATH`, since with the variable unset the trailing colon leaves an empty entry that Lean rejects. All three are now in the README, in A9, and as a comment at the import line.

**Round 2 — `div_le_div_iff` is gone.** 2 errors, 0 sorries, both the same missing name in `delta0_le_density` and `half_is_ceiling`. **Exactly the failure class predicted** in §23: Mathlib name drift, not a false statement — the goals shown in the error are true and were numerically verified before being written. Rather than guess the replacement name (`div_le_div_iff_of_pos` or whatever the current spelling is), both proofs were rebuilt to not need it: `x/C − k = (…)/(…)` by `field_simp`, then `div_nonneg`, then `linarith`. Those four have been stable for years.

**The rule this earns**, now in the README: two of the three Lean failures so far have been name drift (`List.mem_cons_self`'s argument binding, `div_le_div_iff`'s existence), so **where a goal is trivial or routine, prefer a tactic or a decomposition into ancient lemmas over a named iff-lemma** — and ordering-and-division iff-lemmas are the highest-churn corner of Mathlib, worth routing around on sight. Also hardened the two `field_simp; ring` pairs to `first | (field_simp; ring) | field_simp`, since `field_simp` sometimes closes the goal and a following `ring` then errors with "no goals" — an unverifiable-from-here hazard worth pre-empting rather than discovering in another round.

Standing: `Note.lean` is at 0 sorries with these two proofs rewritten; the remaining Mathlib-facing risk is concentrated in `unconditional_density` (`Nat.cast_sub`, `field_simp`) and the assembly's `obtain` pattern against `HypH.witness`.

## 25. Phase 0 closed: `Note.lean` fully proved

Final round was a linter warning, and it was my own hedge reporting itself: the `first | (field_simp; ring) | field_simp` guard took branch one, `field_simp` having closed the goal outright, so `ring` ran as a no-op and `linter.unusedTactic` flagged it. The hedge existed because I could not test which branch would fire; now that the laptop has answered, both sites are plain `field_simp`. *Worth noting as a pattern rather than an annoyance: a defensive `first` combinator written from an environment that cannot compile is a question addressed to the environment that can, and once answered it should be collapsed rather than left in — an unresolved hedge is indistinguishable from an unexamined one six months later.*

**Standing: phase 0 of the README's plan is done.** `Note.lean` at 0 errors / 0 sorries, `ArkCore.lean` at 0 sorries in two environments, and between them the note's entire arithmetic layer is proved — construction inequality, admissible-`d` table, density and ceiling statements, `orb`, Lemma D1, capacity bound, F.1. The README's status table and A9 now say so, both with the scope caveat restated: this verifies that the arithmetic between the hypotheses and the conclusion is correct and the units consistent; the theorem stays conditional on (H) and on Oliver's fixed-point theorem, and neither is formalisable here. That was precisely the gap the README argued was worth checking before arXiv.

Next Lean work is phase 1 — `Basic.lean`'s sorries, where the mod-12 ceiling table and the cap algebra live. Note that the ladder correction of §21.4 landed in that file this session, so its statements are current but its proofs have never been attempted.

## 26. `aod` §3.6: the Elliott–Halberstam row split, and a quantifier error it was hiding

Vipul, having read Shparlinski's §5 directly, observed that the E–H row compresses two separate consequences. Confirmed against the arXiv text, with one attribution correction and one substantive finding.

**The correction.** Both consequences are of **Elliott–Halberstam**, not of Baker–Harman. Baker–Harman is the *unconditional* input giving Theorem 2 its α = 0.677; E–H is what lifts α to anything below 1. The two consequences are: (i) E–H extends the Bombieri–Vinogradov averaging of his Lemma 6 up to z^{1−ε}, replacing Theorem 1's 5/4 with **3/2, all large n**; (ii) E–H allows any α < 1 in Theorem 2, giving **2 − o(1), almost all n**. Exponent is 1 + α throughout, which is what makes α → 1 read as 2 − o(1) — consistent with what `literature-findings.md` already recorded independently.

**The finding the split exposed.** The compressed row read "**all large n** | n^{2−o(1)}". That is wrong: the 2 − o(1) improvement is to Theorem 2, the *almost all* result. So the table was attaching the strongest exponent to the strongest quantifier — an error **in our favour**, which §3.6's own quantifier box exists to prevent. Now two rows, correctly quantified, and the quantifier box updated (it previously said "the two strongest exponents — 1.677 and 3/2", a list that no longer covers the field).

**Two further things worth carrying, both from the same remark.** Shparlinski notes that Chowla's route applies to *individual* progressions and so may be harder to establish than E–H — so the θ = 1/2 rung has **two independent conjectural paths** and is better supported than one row suggested; this is now stated, with the reading that 3/2-for-all-large-n is the more robust conjectural target while 2 − o(1) is available only almost-everywhere. And his closing paragraph sets aside the stronger unconditional results of Bombieri–Friedlander–Iwaniec, Mikawa and Fouvry because they restrict the residue classes a in ψ(y, m, a); recorded as a deliberate exclusion with the residue-class restriction named, so that a future attempt to add such a rung starts from the known obstacle.

**A consequence for how (H) is framed.** With the rows separated, (H)'s distinctive content is visible as the **quantifier rather than the exponent**: E–H already delivers θ → 1 for almost all n, so what (H) asks beyond E–H is that the endpoint hold at *every* large n. Narrower than "θ = 1" unqualified suggests, and now said in §3.6.

Also updated `literature-findings.md`'s parallel table, which had the same single-row compression. `mu-theta-n2-note.md` and its LaTeX twin do **not** carry E–H rungs at all — their "two larger exponents, 1.677 and 3/2" is accurate for the three rungs they do list — so no change there, which is the right outcome for an arXiv-facing document that deliberately carries less.

## 27. Three follow-ups on the E–H material (Vipul's, all correct; one changes a stated exponent)

**(a) The bare n^{3/2} was wrong, and the suspicion was right.** Elliott–Halberstam is quantified *for any fixed ε > 0* (level up to z^{1−ε}), so each application buys θ = 1/2 − ε/2 and the conclusion is n^{3/2−ε} for every ε — never 3/2 on the nose. Same form as BBKN's Chowla row, which is already written n^{3/2−ε}. The `+o(1)` in the unconditional n^{5/4+o(1)} does **not** cancel against it: that is the up-to-subpolynomial-loss convention, where the o(1) may be negative, so it is a loss and not a gain. Both tables corrected. **Filed as an owed source check**, because Shparlinski's §5 states the improvement without writing an exponent — the ε-form is inference from how E–H is quantified, read off the arXiv version, and the published version should confirm it.

**(b) The upgrade is not only in the quantifier — correct, and the reason is structural.** n^{2−o(1)} is consistent with n²/log n or n^{2−1/log log n}, and the E–H route sits on that side: for each fixed ε it gives an exponent below 2, and no member of the family gives a *constant fraction* of n². What (H) buys is Ω(n²) with an explicit constant, δ₀·C(n,2), which is across that barrier. **The reason ε → 0 cannot close it:** the α-ladder asks for a prime factor of r − 1 of size r^α with α → 1, whereas (H) asks for one of size (r − 1)/d with d ≤ 12 — *linear* in r. A linear-sized prime factor is a Sophie Germain-type condition, independently twin-prime-hard, and is **strictly stronger than every rung rather than the ladder's limit point**. So the §3.6 framing needed care: (H) is the endpoint in the sense of sitting at θ = 1 on the same scale, but it is *not* the ladder's limit, and the earlier "distinctive content is the quantifier" sentence understated the gap. Rewritten to name both differences, with the second flagged as the substantive one.

**(c) The note now carries the E–H comparison.** A paragraph added to `mu-theta-n2-note.md` and its LaTeX twin, after the quantifier paragraph: what the documented conditional routes reach (3/2 − ε for all large n, 2 − ε for almost all), that Chowla's 3/2 comes by a different and arguably weaker conjecture since it concerns individual progressions, and the fixed-positive-fraction-versus-any-fixed-exponent point with the Sophie Germain reason. This is the right thing for an arXiv reader to see: it states the limits of the publicly documented approaches and makes the present result's position against them precise, without importing the whole §3.6 ladder.

## 28. Dehistoricization and deduplication pass

**`aod` §3.6 specifically.** The recent E–H edits had left the ε-point stated three times across four boxes plus the closing paragraph. Consolidated to five boxes plus two owed-check notes: the two attribution boxes kept and trimmed; the E–H material merged into one box that states both rungs and the approached-not-attained point once; the two-conjectural-paths observation kept as its own box since it is a different claim; the quantifier box trimmed of its "until it was split" tail. The two separate owed-source-check notes merged into one listing three checks. The Ω(n²)-versus-n^{2−ε} argument moved out of the boxes entirely and into the closing (H) paragraph, which is where it belongs — it is about what (H) claims, not about the ladder — and now appears once. Section length is unchanged at 48 lines, but roughly a third of the prose was duplicate.

**Sweep across the main documents.** Historicizing phrasing removed wherever it described this project's own editing rather than the mathematics: `enumeration-proof.md` (the gcd-admissibility "is retired" note reworded as a positive statement of what the domination says; "an older frontier had a two-foreign winner" rewritten to state the current position and cite the exceeding reading; "the merge that the old space forbade" rewritten to say what survives and why; the S4 census annotation and the B′ reading-count line put in the present tense — B′ now reads "two independent readings, agreeing" rather than narrating that a second one happened); `three-uniform-note.md` ("supersedes an older caveat" / "were once flagged" → what the F = 4 row resolves); `note-to-framework-bridge.md` ("run this session", "the note now carries", "Both have happened" → "Both are live risks", which is also the more useful claim since the section is explicitly about standing hazards rather than incidents); `small-degree-computation.md` and `-verification.md` (this session's own additions rephrased out of the "has moved from X to Y" frame); `literature-findings.md` (a heading naming the pass that produced it).

**Deliberately kept.** Era labels on measurements — `v4-era`, `⟦PENDING-REBUILD⟧`, "v4 baseline" — are not historicization: they identify which artefact a number came from, which is load-bearing while the table rebuild is outstanding. Likewise "has since been improved" about *the literature's* exponents, which is about the field's history rather than ours. Final sweep for narrative voice ("we found/corrected/split", first-person session references) across all fifteen main documents returns zero.

## 29. `check_doc_figures.py` run, and a new PASS 8 HISTORY

### 29.1 The run: one falsified structural claim, two stale figure sets

Most of the 26 figure flags were coincidental numeric collisions (a density cell at n = 6 reading 0.400000; VF2 percentages of 20.6/20.8; class counts of 2,212 and 1,028) — the checker's design accepts these, since it reports "correct for n ≤ X" rather than asserting error. Three findings were real, all in `arithmetic-of-density.md`, and one is not a figure at all:

**A structural claim the correction falsified, and nothing had noticed.** §2's box asserted "All one-part winners have ω(n) = 2, and **no** value with ω(n) ≥ 3 has a one-part winner." Against the current table there are **four counterexamples**: n = 282, 894, 1434 (all `6x p`) and n = 1490 (`10x149`). The mechanism is exactly the entangled-generator correction — **F = 6 and F = 10 are composite**, available only because F_mid need not be a prime power, and n = F·c then carries three prime factors. Under the old shape space the claim was a *theorem* (F a q-power, c a p-power ⟹ ω(F·c) ≤ 2), which is why it read as safe. Rewritten to state the four exceptions and name them as the composite-F fusions, with the point that this is a place the correction changes a structural claim and not merely a count. *This is a good advertisement for the checker: no figure sweep would find it, and it survived the fresh-eyes read of the companion document because the sentence is about `aod`'s own census rather than about ep.*

**Two stale figure sets, both from much older eras.** The ω(n) = 2 split was quoted as 780/338 of 1,118; it is now **773/437 of 1,210** (two sites, §2 and §5's item 6). The two/three-part winner box quoted maxima 0.24939 and 0.11037 over 909 and 258 rows with medians 0.1988 and 0.0889; correct against the current contiguous range is **0.24939 and 0.10912 over 1,393 and 16 rows, medians 0.1695 and 0.0978**. The 909/258 row counts predate several extensions. The claim being illustrated — no two-part winner above 1/4, no three-part above 1/9 — survives unchanged.

The PASS 2 scope flag on `aod` L1051 is a false positive: the 1/16 there is a per-shape ceiling in a derivation, not a range assertion about the computed data.

### 29.2 PASS 8 HISTORY added to the checker

The dehistoricization sweep of §28 was done by hand, which means it will rot. Added as a pass, with the design problem stated in the code: historicizing sentences are invisible to every other pass **because they are grammatical and accurate** — they are about the project's editing rather than about mathematics, and only the subject distinguishes them.

Twelve patterns (edit-history adverbs, references to superseded versions of our own text, status-of-our-text verbs, work-session references, first-person process narrative). Two categories are exempt **by subject**, because they are indistinguishable by regex and are load-bearing: era labels on measurements (`v4-era`, `PENDING-REBUILD`, "v4 baseline"), and the *literature's* history ("Baker–Harman's exponent has since been improved"). Session logs and the journal are skipped entirely — they are the one place history belongs.

Two tuning rounds were needed and both are recorded as comments in the pass, since they are the kind of thing that gets re-broken: **`fixed` and `dropped` had to come out of the status-verb alternation** — "fixed pointwise", "fixed by every Galois element", "a fixed prime" are ordinary mathematics and swamped the report — with repaired defects caught instead by a narrower pattern requiring a defect as subject; and `--baseline` / `.csv` references had to be exempted, since naming a prior *artefact* as a command input is not the same as citing superseded prose.

Down to 9 findings from 22, and the remainder are mostly the good kind: "an earlier draft asserted X, which is wrong for reason Y" in `monotone-transitive-note.md`, `three-uniform-note.md` and `literature-findings.md`. Those earn their place by warning a reader off a tempting error, which is the test the pass's own footer states — would a first-time reader need the phrase? One genuine session reference removed from `enumeration-proof.md` ("a question noticed during this review" → "an open question").

## 30. §2a review, Part J status, and the converse (Proposition F.4)

### 30.1 `pending-checks.md` §2a — three items outdated, one badly

- **T4's source-check list was wrong on both count and location.** It said "three checks, each flagged at its site in `aod` §3.6"; in fact the Santha–Yao/Scheidweiler–Triesch priority question lives in §5 and the `notes` reference list, not §3.6, and the E–H ε-form check added this session makes four. Rewritten to list four with correct homes.
- **A9 had become self-contradictory and duplicative** — the largest defect found in §2a. It stated phase 0 complete in one paragraph and then, in the next, gave "Next: compile `Basic.lean` on the laptop... then start discharging `Note.lean`'s sorries" as the forward plan, both of which are done. It also carried the compile-status discussion twice. Rewritten around a three-row per-file status table (which file, which environments, how many sorries), with the two environment lessons — import mechanics and lemma-name drift — consolidated as a pair rather than scattered.
- **T1 and T2** updated in passing: T1 records the later full-document critical pass and what its finding profile confirms (statements checked against each other is not the same as checking a step whose plausibility does the work); T2's J0a bullet points at its gap-inventory entry rather than restating it.

### 30.2 Part J: no meaningful open part is misstated

Read against the gap inventory. J0, J0a, and items 1–5 all describe live questions accurately, and item 2a's sharp-threshold text is correct after the §21 fix. The one substantive thing to say is that **Part J's items and the inventory's six are the same set viewed from two ends** — Part J organises by what would have to be proved, the inventory by what the risk is — and neither now contains an item the other lacks.

### 30.3 The converse: Proposition F.4

*The session's one new piece of mathematics, and it is elementary given F.1.*

**The mechanism that makes a converse available**: the score is a *minimum* over orbitals, so every part must clear δ₀·C(n,2) **on its own**. A part clears it only by being large and carrying a large twist, and both conditions convert directly into arithmetic.

Two branches. **Foreign part present:** it is a prime r with q-power twist Q, contributing ≤ r·Q; from r·Q ≥ δ₀n²/2 and r ≤ n, Q ≥ δ₀n/2, and since Q | r − 1 < r ≤ n, **(r − 1)/Q ≤ 2/δ₀**. **All-matching:** each class has c_i ≥ δ₀n and F_i ≤ 1/δ₀, the intra term F_i·orb ≤ F_i c_i d_i forces d_i ≥ δ₀²n/2 and (c_i − 1)/d_i ≤ 2/δ₀². This branch additionally pins n itself: n = p^b·(bounded cofactor), i.e. **n = M·p^b with M ≤ 1/δ₀**.

Since bounded multiples of prime powers have density zero, the clean statement holds for almost all n: **a prime r ≥ δ₀n whose r − 1 has a prime-power divisor of cofactor ≤ 2/δ₀**. One honest caveat measured rather than asserted: the density decays only like H_M/log n — at n ≤ 10⁵ about **44%** of integers are still within a factor 25 of a prime power — so the exclusion is asymptotic and no computation will display it.

**Why this is the θ = 1 counterpart of E–H, and what the round trip costs.** The ladder's rungs give a prime factor of size r^θ for θ < 1; F.4 shows a density floor requires one of size (r−1)/D, *linear* in r. So the bounded-cofactor condition is not merely sufficient for a floor but **necessary** for one — which is the sharpest available reason to think no θ < 1 input can ever give a positive density floor, and it upgrades §3.6's "E–H is not almost (H)" from an observation about how (H) is phrased to a theorem about what a floor demands. The constants do loosen, as anticipated: (H)'s d ≤ 12 → δ₀ = 1/350 → D = 700 (or 245,000 through the all-matching branch), a factor ~58 lost on the clean branch. Three differences survive the round trip and are named in `aod` §6 rather than glossed: prime-power versus prime divisor, almost-all versus all n, and the constant. **The shape of the statement is what does not degrade**, and that is what makes it an equivalence up to constants rather than a pair of one-way implications.

Written as Proposition F.4 with proof in `enumeration-proof.md` Part F (after F.3, before the division-of-labour table, which it complements — that table says number theory never answers "which configurations are admissible"; F.4 says the converse traffic is real and runs the other way). Discussion in `aod` §6, cross-referenced from §3.6's endpoint paragraph. Filed in the gap inventory as **closed, opening a sharpening question** — whether either direction can be tightened — which is a research item, not a gap: nothing currently claimed depends on it.

## 31. `aod` §6 reread: restructured, and F.4's numerics checked

### 31.1 Structural problem found and fixed

The F.4 material had been inserted **between** the section's opening not/does pair — "it does not force any single Bateman–Horn system" / "what it does force is a covering statement" — splitting a deliberate rhetorical pairing and burying the covering claim that §§6.1–6.5 then spend five subsections developing. Reordered so the arc reads: does not force one system → **does** force a covering statement over shapes (the subject of the rest of the section) → **also** forces an arithmetic statement (F.4, self-contained). The two forced things are different in kind — which systems, versus what any of them must supply — and the section now says so rather than leaving the reader to notice. One duplicated paragraph removed in the process.

Also trimmed: the F.4 block had restated the two-branch proof at more length than a discussion section needs, when the proof is in `ep` Part F. It now gives the mechanism in one sentence (the score is a minimum, so every part must clear the floor alone) and spends its length on what is actually at stake — the exceptional set, the constants, and the comparison to §3.6.

### 31.2 Numerical checks: three predictions, all hold, and one striking constant

Checked all three inequalities of F.4 against the 2,186 contiguous rows:

| prediction | instances | violations | tightest |
|---|---|---|---|
| (r − 1)/Q ≤ 2/δ | 1,409 foreign primes | **0** | ratio/bound 0.498 |
| r ≥ δ·n | same | **0** | r/(δn) = 2.003 at n = 2040 |
| M ≤ 1/δ (all-matching) | 777 one-part winners | **0** | **0.9996** at n = 2594 |

Two findings worth more than the confirmation itself.

**The all-matching bound is essentially attained** at n = 2594 = 2·1297, ratio 0.9996 — and that is the same row §6.1 identifies as sitting on the feasibility boundary (√2 = 1.41421 against 1/√δ = 1.41449, slack 0.0003). Two independent constraints, derived by different routes, bind simultaneously at one value. That is a good sign both are tight rather than merely true.

**The largest cofactor (r − 1)/Q anywhere in the table is exactly 12**, at n = 221 with r = 157, Q = 13. That is (H)'s own d ≤ 12, recovered from the opposite direction and with no reference to it — evidence that the hypothesis's constant is not an artefact of how it was written down but the value the optima actually use. Recorded in both `ep` F.4 and `aod` §6.

The same measurement quantifies the Proposition's slack honestly: the global floor gives D = 44 where 12 suffices, so F.4's bound is loose by a factor ≈ 4 against observed optima. That is where the sharpening question filed in the gap inventory would start, and it is now stated with a number rather than as a suspicion.

## 32. F.4 filed as a risk item; second `check_doc_figures.py` run

### 32.1 T8: the step that makes F.4 non-vacuous, and why it is the risky kind

Filed as **T8** in §2a and inserted at **rank 6** of the residual-risk list. The question that matters is not whether the inequalities are right — they are checked — but **why the foreign twist Q must be a prime power**. With Q merely a divisor of r − 1 the Proposition is *vacuous*, since Q = r − 1 always satisfies the cofactor bound. So the entire arithmetic content rests on the twist being confined to the top q-group, and **that is a layer-assignment claim** — the category with the worst record in this framework, containing both the F_mid coprimality clause and the c mod 8 fusion mechanism, each wrong in the permissive direction. Part E's construction and Part A's chain structure both say the confinement holds; the same was believed of block counts. The concrete question: can a foreign block's twist draw on the cyclic layer the way a fused class's block count does? Flagged at both statement sites (`ep` F.4, `aod` §6) rather than only in `pending-checks`, since a reader meeting the Proposition should meet the dependency with it.

Three smaller items also filed: the one-line "every part clears the floor on its own" (safe as used, since a part's intra term is an orbital or a union, but confirm no part kind escapes); the all-matching branch's use of a shared chain prime p, without which the exceptional set is not density zero and "almost all" fails; and the constants, where a factor of 2 would propagate into `aod` §6's quoted 700 and 245,000.

**The limit of the measurements is stated explicitly in T8**, because it is easy to over-read them: they test the *inequalities*, not the *derivation*. A wrong constant or an unjustified layer assignment still produces inequalities that hold on the table, since the table's winners satisfy the true statement whatever the proof says. This is site 4 of `verification-lessons.md` §1 in a new place — the measurements and the Proposition came from the same pass.

### 32.2 The run

Clean on the two figure findings fixed earlier; no new stale figures in the material added this session. Tables 91/91 well-formed, hygiene clean, census in step, history pass at 10 (all the good kind — "an earlier draft asserted X, which is wrong for reason Y").

**One checker improvement, from a false positive it produced.** Both note files reported `Theorem 1.4` as *** DANGLING ***. It is **BBKN's** Theorem 1.4 — a cited paper's result under that paper's numbering, which cannot resolve against our anchors and must not be reported. The pass already had this exemption but only as a per-file switch for `literature-findings.md`. Generalised: a named result immediately preceded by an external attribution (`BBKN's Theorem 1.4`, `Shparlinski's Theorem 2`) is skipped in any file, via a list of the authors and groups these documents cite. Attribution binds only when it sits immediately before the label, so our own results are unaffected. Dangling count 2 → 0.

*Worth recording as a principle for this checker:* a pass that reports every correctly-cited piece of the literature as an error trains the reader to skip it, which is worse than the pass not existing. Same reasoning as the `fixed`-in-the-history-pass tuning.

## 33. `converse_check.py`

The F.4 spot checks were ad hoc, so they are now a script: `python3 converse_check.py <table.csv>`, with `--delta0` to check every row against one global floor (the form F.4 is actually stated in) rather than each row's own density (the sharper form), `--nmax` / `--frontier` / `--all-rows` for range, and `--verbose` to list violations. Reuses `fb_common.Arith` rather than adding a sympy dependency.

**It reports the two figures the documents quote**, since those are what will move: the max cofactor (currently **12**, against (H)'s d ≤ 12) and F.4's slack against it (currently **3.6**). Both print with a pointer to the sites that need editing if they change — `ep` F.4 and `aod` §6 for the first, the gap inventory for the second.

**Writing it found a defect in my own earlier spot check.** The frontier detection first used "gap wider than 60", which swallowed four worklist rows and reported 2,190 rows and 1,413 foreign primes where the documents say 2,186 and 1,409. The first gap above 10 in the v4 table is exactly 2600 → 2627, so the threshold is 10; that reproduces the documented counts, and the reasoning is now a comment rather than a magic number. The figures I reported last turn were computed with an explicit `n <= 2600` filter and so were correct, but the discrepancy would have been invisible without writing the frontier logic down.

**Negative control**: `--delta0 0.35` yields 796 violations and exit 1, so a failure is demonstrably reachable rather than assumed.

**A datum the script surfaced for free**: with `--all-rows`, F.4's inequalities hold at all 2,240 rows out to n = 4427, including the low-density worklist subsample — the population most likely to break them, since the bound is 2/δ and those rows have the smallest δ. Not recorded in the documents, since the worklist is not a fair sample, but it is worth knowing the checks do not degrade there.

The script's own footer restates the limit rather than leaving it to the reader: a PASS is consistency, not confirmation, because the checks test the inequalities and not the derivation — in particular not T8's prime-power step, without which F.4 is vacuous rather than false.

## 34. `converse_check.py` added to R1 — and why it is not a routine rerun

Answering the question directly: **v4 is not good enough, and this belongs in R1.** The reason is sharper than "the table is being rebuilt". F.4's checks read the **witness column**, and the entangled correction rewrites witnesses — composite-F fusions change which rows count as one-part (branch 3's whole population), and raised rows change δ (branch 1's bound). So both the counts and the two quoted constants are genuinely at risk, not merely stale.

Added as step 5 of R1's command list, with a read-off note. Ran against the v5 partial frontier as a partial answer: **0 violations over 789 foreign primes and 485 one-part winners at n ≤ 1546, max cofactor still 12 at the same witness** (n = 221, r = 157, Q = 13). So the corrected shape space has not disturbed the inequalities or the headline constant on the range rebuilt so far — reassuring, since n = 221's witness surviving the correction is what keeps the (H)-matching coincidence alive.

**One distinction the R1 note now makes, because it would otherwise generate a false alarm.** The two constants behave differently under a rerun. Max cofactor is a maximum over witnesses and moves only if the shape space changes which primes win — a change there *is* a finding. Slack is max-cofactor against 2/floor, so it moves whenever the **floor** moves, and is therefore range-dependent even on a perfectly correct table: v5-partial reads 2.9 against v4's 3.6 purely because the floor over a shorter range is higher. Requote slack with its range; do not read a change in it as evidence of anything. Both statement sites are marked ⟦PENDING-REBUILD⟧ accordingly.

## 35. The δ₀ versus δ₀² question — and the squared constant was slack, not structure

Vipul asked why two different denominators appear for the same quantity D. Working it through showed the **δ₀² was an artefact of a lossy step in my own proof**, and F.4 now carries D = 2/δ₀ on both branches.

**Where the asymmetry looked like it came from.** Each branch bounds a product against n². The foreign branch has a *two*-factor product r·Q against the single constraint r ≤ n — one quantity, one constraint, one division by δ₀. The all-matching branch has a *three*-factor product F·c·d against F·c ≤ n, and that extra factor is what invited the second division.

**Why it was avoidable.** I had derived c ≥ δ₀n and F ≤ 1/δ₀ separately and then used them as independent facts to bound d ≥ δ₀n²/(2Fc). But F and c are not independent — F·c is bounded by n **jointly**, which is the constraint actually available. Keeping the product together gives d ≥ δ₀n²/(2·Fc) ≥ δ₀n/2 in one step, hence (c − 1)/d ≤ 2/δ₀, matching the foreign branch exactly. Splitting the product spends δ₀ twice for nothing.

**Checked before editing**: ~4·10⁵ random admissible configurations, **0 violations** of the tighter bound, tightest ratio 0.5 (consistent with the orb halving, so even 2/δ₀ is a factor 2 loose in the sharp direction).

**Consequences, all applied.** F.4's statement is now a single D = 2/δ₀ with no branch-dependent constant; the proof records the joint-versus-separate point explicitly, since it is exactly the step a re-derivation would get wrong again; `aod` §6's round trip is **700 uniformly** rather than 700 and 245,000, which also simplifies the equivalence claim — the three surviving differences are now prime-power-versus-prime, almost-all-versus-all, and a factor ≈ 58, with no fourth term about the branches diverging.

**And it leaves a tripwire worth having.** Both branches now carry the *same* constant, so T8 records that a future derivation making them differ is itself a signal of a lost joint constraint rather than a real feature. That is a better invariant than the number 700.
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

## 2. The repair-completeness inventory: sites still carrying the refuted claim

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

## 6. Proposed pending-checks additions (for the Opus pass to file)

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

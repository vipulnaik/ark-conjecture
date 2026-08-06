# Session log 2 — the 2026-08 review pass

*Completed work. Continues `session-log.md`. Nothing here is pending; `pending-checks.md` is what is left.*

The pass was a cold read of `orbital-evasiveness-notes.md` §§1–6, `enumeration-proof.md` and `arithmetic-of-density.md`, followed by code review of `mu_enumerate.py`, `ladder_verify.py`, `fallback_cert.py` and `fb_common.py`, and a close read of Lemmas B′, C and G.2.

**Headline.** Two wrong derivations found and corrected (L1, L4), one missing derivation supplied (L3), one real gap found in Lemma C and then shown to affect neither endpoint (L8), one wrong justification in G.2 repaired (L8), and the trusted base for μ(n) = B(n) reduced substantially by showing the Part E′ theorems are not load-bearing over the certified range (L10).

---

## Mathematical corrections

### L1. The ℓ = 2 efficiency claim was false

`arithmetic-of-density.md` §3.3 and `orbital-evasiveness-notes.md` §5.3 both characterised η = 1 as "a = 1 and u a prime power" and concluded that 4 | r − 1 caps η at 1/2. The characterisation omits **u = 1**: at a Fermat prime r − 1 = 2^a is a pure 2-power, so η = 1 for every a. Not hypothetical — fusing the two equal c-blocks of the three-class family forces q = 2, and the foreign twist is then full exactly at Fermat primes, producing **20 winners of shape `2×c + 257*`, all in classes 3 and 7 mod 12, at densities up to 0.16138** against those classes' tabulated 0.08579, at n = 451, 459, 475, 531, 555, 559, 583, 595, 639, 651, 679, 703, 711, 715, 735, 759, 783, 795, 799, 819.

`enumeration-proof.md` Part I already had this right (Fermat primes at q = 2; the 257 binding orbital at n = 777 and n = 1175), so the documents were in direct contradiction. Corrected in all three places; the escape added to the §3.3 inventory. Asymptotically harmless — five known Fermat primes is O(1)-sparse, thinner than the O(log n) 3-power escapes — but the derivation as written was invalid. `ladder_verify.py`'s `EFF` array computed η correctly all along; only the prose was wrong.

### L2. The unfiltered class-uniformity check

§3.3's "Lower: uniform across classes" table pre-filters to winners at their class's *generic* efficiency, which is exactly the filter that hides the Fermat rows — so it cannot detect an error in the class → η map, only in what follows from it. Rerun without the filter, over all 1,108 two- and three-class one-foreign winners:

- normalised by **cap(own η)**: every class lands in 0.28–0.998, **none exceeds 1**;
- normalised by the **class cap**: **194 rows exceed it** — 57 via the 2^a + r\* route, 43 via the fused 2×c + r\* route, 94 via an η above the class generic — and class 11 has a *median* of 1.236 with 28 of 39 over, max 3.993.

Written into §3.3. The phrase "generic ceiling" was overstating how typical the δ₀ are inside the computed range.

### L3. The fused-class cap was missing entirely

Falls out of L2. The δ₀ table derives its odd-n caps for the **unfused** shape 2c + r\*, but when q = 2 the two equal c-blocks can be fused, and reduction (R1) says they should be. Balancing F·C(c,2) ≈ Fx² against η(1−Fx)²:

> **x\* = √η/(√F + F√η),  cap_F(η) = Fη/(√F + F√η)²**

reducing to the table's k = 1 row at F = 1 and giving **0.17157 at (F, η) = (2, 1)** and **0.10102 at (2, 1/3)**, against the tabulated 1/9 and 0.0718. Verified: 0 of 58 fused-class-plus-foreign winners exceed it, max 0.16138 at n = 639 (94% of cap₂(1)).

**This subsumes L1**: fusion at F = 2 forces q = 2, which makes η = 1 available exactly at a Fermat prime. The Fermat escape and the fusion gap are one phenomenon.

### L4. Part E′'s Corollary had been falsified by the falling floor

It asserted "δ > 1/25 forces s ≤ 3 — and every computed value has δ ≥ 0.0418 > 1/25", contradicting the s = 4 box immediately above it once n = 2291 (0.037524), 3059 (0.029282) and 3239 (0.026117) came in below 1/25. Rewritten to scope the reduction to δ > 1/25 and state plainly that s = 4 and s = 5 are open below it. Matching open item 2a added to Part J.

### L5. Theorem 2.3's ≥ 3-part step

"Partitions into ≥ 3 parts never beat the best 2-part split, since more parts only shrink minᵢ cap(sᵢ)" does not establish the claim: cap(s) = s(L(s)−1)/2 is **not** monotone in s, so merging two parts can lower cap. What actually kills the ≥ 3-part case is the cross terms. The conclusion is true — brute force to n = 1200 finds no n where a 3-part partition beats the best 1- or 2-part — and B₀ quantifies over all partitions anyway, so nothing downstream depended on the shortcut. Caveat written in.

### L6. Smaller items

- **Lemma E.2** was stated for odd prime a; a = 2 (2¹ − 1 = 1, L = 1, Cap(2) = 6) now covered explicitly.
- **The two E″ exceptions** (n = 50,817 and 89,697) were omitted from the status table in `arithmetic-of-density.md` and from §2.6 of the notes, both of which said "certified to 100,000" flat. Corrected.
- **`ladder_verify.py`'s `stop_at` truncation** now documented in the script: `achieved(n, stop_at=0.9·CAP[a])` returns as soon as it clears the threshold, so the value is not the family maximum — which is why the long run's per-block "floor" lines keep reporting 0.04546 = 0.9 × 0.05051. Everything asserted is still a lower bound, but block minima must not be read as maxima.

---

## Code corrections

### L7. `ladder_verify.py` did not enforce Lemma C

Both families scored the p-characteristic block at `comb(c,2)`, i.e. twist d = c − 1, without checking gcd(c−1, r) = 1. Where r | c − 1 the twist is stripped and the true family value collapses, so the output was not strictly the lower bound on δ(n) the docstring and both documents claim. The window forces this to c = r + 1, hence n = 2r + 1 (two parts) or n = 3r + 2 (three parts) with r Mersenne-like — n = 15, 63, 255, 65535 and n = 11, 23, 95, 383, 24575. None appears in `ladder_weak.txt` and none is ever the argmax. Guard `(c-1) % r` added to both families; a rerun to 20,000 reproduces the original per-class minima, floor and weak list exactly. **No published number changes.**

### L8. Lemma review: B′, C and G.2

**Lemma B′ — sound.** The primitive-group argument is correct: a nontrivial normal subgroup contains the socle, which is elementary abelian of order p₀^a with p₀ ≠ p, killing π_O(Γ₂); π_O(Γ₁) cyclic then forces a = 1 and, centralising the socle, equals it by C_Γ(V) = V. One branch the sketch skips: if π_O(Γ₁) = 1 then Γ|_O is a transitive q-group, hence primitive of prime degree q with trivial twist — same conclusion. Added. **B_safe does depend on B′**, so this one matters for the published bound, though an error would inflate B(n) rather than deflate it.

**Lemma C — a real gap at c = p^a with a > 1.** The load-bearing clause "on part i the top group induces the identity" is provable when c_i is **prime** (the normaliser of the twist in AGL(1, c) centralises it, so the induced power map is m ≡ 1, contradicting the order-t_j action on part j). When c_i = p^a a top-group element may act through the **Galois** part of ΓL(1, p^a), sending ζ ↦ ζ^{p^k}; that power map has q-power order and so does the twist multiplier on part j, so the two are not obviously incompatible and the argument does not close. Same failure mode as the ΓL(1) step that turned out false.

**…but neither endpoint depends on it.** In SAFE mode `value()` scores every p-characteristic part at F·C(c,2) regardless of stripping, since orb(c, c−1) = C(c,2) identically — so **B_safe does not use Lemma C**. Confirmed: deleting the stripping from `value()` reproduces the table exactly at every n ≤ 400. On the other side, Part E's construction uses Lemma C only as a *sufficient* condition (pairwise coprime orders make Γ₁/Γ₂ cyclic), an existence argument unaffected by whether the converse holds. And the exposure measures at zero: of the **2,178 p-characteristic parts appearing in a computed winner, 1,903 have prime size and none has both a > 1 and a foreign prime dividing c − 1**, so Lemma C is vacuous on every winning configuration in the table. What it buys is the sharpness of the search — `--refined`, the `fallback` bookkeeping, and the reasoning inside E′.

**G.2 — the conclusion holds, the stated reason does not.** "Each level's block count is a power of q (a transitive q-group has q-power degree)" does not follow: if the image of Γ₂ in the block action is nontrivial it contains that action's socle, forcing the block count to be a **p**-power. The conclusion survives by cases — a p-power block count over a p-characteristic finest block makes the orbit a prime power, already enumerated at (F, c) = (1, |O|), and SAFE values it at C(|O|,2), an over-estimate and so safe; over a *foreign* finest block it is dominated by the same diagonal-cross argument that kills q-fusion of foreign parts. Repair written in.

### L9. `mu_enumerate.py` read in full

Recorded as Part J item 4 of `enumeration-proof.md`. The pruning is conservative in the right direction throughout: `cmin = 2·floor/n + 1` follows from F·C(c,2) ≤ n(c−1)/2 and uses integer floor division, so it keeps too many parts; `seed_value` never over-estimates (its p-power-plus-foreign branch uses the *refined* score, which is ≤ SAFE); the cross-term prune compares against the smallest selected part, which is the binding one; ties are recorded so a witness always exists; the `p = 0` sentinel for a trivial bottom layer is strictly more permissive than any p > 0 all-foreign reading.

Two checks: 61 values ≤ 700 recomputed with the shipped code (0 mismatches), and 79 values at n ≤ 120 against a **separately written naive enumerator** with no pruning, seed or part pool (0 mismatches). The naive check is the informative one, since it tests the pruning rather than re-running it. One cosmetic edge remains: in decision mode `seed = int(floor·C(n,2))` truncates, so an n whose density exactly equals the floor could be reported rejected; it cannot arise for the record holder, which is read from the table instead.

### L10. `fb_common.py` read — the Part E′ theorems are not load-bearing

`fallback_cert.py` passes theorem-settled s-branches to the search as a `skip` set, so an error in E.1, E.3(iii) or E.4 — or in the hardcoded `MERSENNE`/`REPUNIT3` tables — would silently drop a real candidate. Tested rather than argued: **re-running with `skip_settled` disabled entirely returns 0 candidates at all 2,008 values in 3 s**, and disabling the `e3ii_resolves` discard as well gives the same.

So over the certified range μ(n) = B(n) rests **only** on the eight necessary conditions being necessary. E.1, E.3(ii), E.3(iii), E.4, Lemma E.2's bound on L(a), E.4's uniqueness scan to a = 200 and the hardcoded prime tables are all commentary there. They remain what any *all-n* statement would have to go through. **The single largest reduction in the trusted base found in this review.**

The conditions themselves read sound and permissive as claimed: `s_max` is used only for reporting (`pair_candidates` never prunes on it, so a wrong s_max cannot skip a branch); the Cap tables reproduce 6/21/155/1143 and Cap′(3) = 39; `intra_floor` is exact on every B tested to 3000 and at 10⁶, 10⁸; `leftover_ok`'s `need` correctly maxes the cross floor against the intra floor; `multi_part_ok` treats foreign primes as distinct and p-parts as repeatable, and returns `None` (survive) when the candidate set exceeds its limit.

Two implementation defects, neither live — carried forward to `pending-checks.md`.

### L11. Purely-foreign configurations are reachable *(closes former item B3)*

`best_with_k` skipped a prime p when no power of p landed in the pruning window, justified only for configurations containing a p-characteristic part. Configurations with a trivial bottom layer are legitimate Oliver groups, and reaching them relied on some *other* p surviving the skip and happening to make every part foreign — true in practice, unproven in general. **Corrected**: an explicit sentinel `p = 0` meaning "trivial bottom layer" is now enumerated and never skipped, and is strictly more permissive than any p > 0 all-foreign reading. Did not change B(n) on any of the 85 regression values.

### L16. `wide_cert.py` read; the trusted-base reduction extends to 10⁵

**Sound.** The B_lo substitution is permissive everywhere it enters, which is what the whole design rests on: every condition in `pair_candidates` has the form *term* ≥ B, so lowering B admits more candidates; `leftover_ok`'s `need = max(⌈B/min(Fc,r)⌉, intra_floor(B))` shrinks, so fewer leftovers are ruled out; `branch_settled`'s "cap ≥ B" fires more often, sending more branches to the search; and `s_max` grows. A weaker bound can only add spurious candidates.

**The trusted-base reduction extends — which I had predicted it would not.** Pass 2 calls `branch_settled` and `continue`s on a dispatched branch, so an error in E.1 or E.4 could in principle drop a real candidate. Tested: with the dispatch stubbed to `False`, the run gives **identical output at NMAX = 10⁴ and 10⁵**, same two unresolved values. So the collapse to 100,000 also rests only on the necessary conditions.

**The two unresolved values are the documented open case.** n = 50,817 = 2·20327 + 10163 and n = 89,697 = 2·35879 + 17939, both 2c + r\* with c a safe prime, r = (c−1)/2 dividing c−1, s = 2, leftover L = c. That is precisely what `e3ii_resolves` declines to cover — under the (r, r) re-reading the leftover block of size c becomes a *second* foreign part equal to the first, which Part E forbids. Instances of Part J item 2, not independent gaps.

**Two real defects, both fixed.**

- **The pass-1 cache was keyed on NMAX alone** (`/home/claude/blo_{NMAX}.txt`), so changing `SCAN_CAP`, `WEAK`, or any family function silently reused a stale B_lo and the run would "certify" against old data. `--refresh` existed but relied on remembering. Now keyed on a hash of the parameters and the family functions' bytecode, so a changed pass 1 simply misses the cache.
- **Hardcoded absolute paths** (`/home/claude/ark/mu_enumerate.py`, `/home/claude/blo_*`) broke the script anywhere else. Now relative to the script directory, overridable by `MU_ENUMERATE` and `WIDE_CERT_CACHE`.

Plus a stale closing line ("at every n ≤ 2007 the true-table certificate agrees" — now 2,008 values to n = 3239).

**One fragility, not a defect.** `S_TOP` is a global max over all n, so a single value with weak B_lo inflates pass 2 for the entire range. That is the mechanism behind the recorded 0.020 → 0.000007 collapse when the outward scan was absent: not a wrong answer, but a cliff in cost. Worth a guard that reports the argmin of δ_lo rather than only its value.

**Checked clean.** `three_part_lo` omits the c² cross term between the two equal blocks — harmless, since c² > C(c,2) so the min is unaffected. It also does not check Lemma C, and *correctly so*: unlike `ladder_verify.py`, which bounds the true δ(n), this needs only B_lo ≤ B_safe, and SAFE scores a p-characteristic part at C(c,2) regardless of stripping. The `near()` outward scan is a subset of admissible configurations, hence still a lower bound. The per-s threshold δ_lo ≤ 1/(s+1)² is the correct rearrangement of s ≤ 1/√δ − 1, applied to δ_lo ≤ δ and so permissive.

### L17. `brute_compare.py` written

R3 previously named a driver that did not exist; `brute.py` is a library with no `__main__`, and the comparison had only ever been run as an inline throwaway. Now a real script with `--nmax`, `--nmin`, `--kmax`, and an append-only `--resume` JSONL that flushes per value, so a long run survives interruption. It also names the direction that matters in its output: *naive higher than table* would mean the shipped enumerator prunes away a real configuration, i.e. B(n) too small and the upper bound broken.

Coverage extended from n ≤ 120 to **n ≤ 175, 0 mismatches** (about 20 minutes). The cost is roughly |parts|^kmax per (p, q) pair and climbs steeply; n ≤ 260 remains an overnight run.

---

## Bookkeeping corrections

### L12. Stale range-dependent figures

All live-looking, because 1,848 (n ≤ 2212) and 1,921 (n ≤ 2298) both still occur legitimately. Fixed:

| was | now |
|---|---|
| F-breakdown of one-part winners 184/137/105/88/62/39 | 205/151/116/97/68/44 (+73 at F = 8, 11, 13, 17, 19, 23) |
| §2.3 shape table 678/793/201 | 754/909/258 |
| three-part median 0.0915 | 0.0889 |
| "200 of the 258 three-part winners" | 255 |
| "all but two have equal p-parts" | all but **three** — n = 2015 = 1024 + 512 + 479\* is a second instance of the n = 551 distinct-2-powers shape |
| fused-winner share 42.3%; ω = 2 share 57% | 39.3%; 56.1% |
| 1/16 tail 28 values (1.7%) | 45 values (2.3%) |
| "1,390 … 458 … those 397" | 1,390 + 458 = 1,848 at 75.2% |
| even/odd 1/4 shortfall 80.7/81.0 | 81.3/81.7 |
| odd-median thirds 0.1434/0.1101/0.1037 | 0.1413/0.1086/0.1024 |
| [1500, 2298) ω = 2 share 50.1% | 50.0% |
| max density over ω ≥ 3, 0.2493 | 0.2494 |

Plus three duplicated sentence fragments and one dangling clause in the §5 heading of the notes.

### L13. Branch-and-bound status recorded in three different states

`arithmetic-of-density.md` simultaneously said the search terminates, that one value remains, and that "completing these three" would settle it; `pending-checks.md` carried both the pre-run "expected outcome" and the post-run "finished". All now record the finished state.

**The finished result.** Over the 48,729-entry `ladder_weak.txt` worklist, starting from the honest asymptotic constant (5 − 2√6)/2 = 0.050510 in LB-ascending order: 48,700 pruned on their bound, 2 read from the table, **27 actually tested**. The two lookups (n = 935, then 2291) dropped the floor from 0.050510 to 0.037524, which is what made the rest prunable. The 27 survivors were all n ≡ 11 (mod 12), between 2915 and 17363. The floor fell 0.037524 → 0.029282 (n = 3059) → **0.026117 (n = 3239)**, and the last candidate rejected without B(8927) ever being computed:

```
[193/48729] n=8927    B/C(n,2) > 0.02612  rejected at K=3   (9398.0s cumulative)
```

So **min { μ(n)/C(n,2) : n ≤ 10⁶ composite, not a prime power } = 136957/5243941 = 0.026117**, attained at n = 3239 = 41·79, witness 1×1511\* + 1×907\* + 1×821 with binding orbital orb(907, 151) = 136,957.

Pruning independently reproduced: from `ladder_weak.txt`, exactly {3239: 0.02504, 8927: 0.02516} fall below 0.026117; 3059 (0.02807) and 3479 (0.02906) correctly sit above it. Rerun only if `ladder_verify.py` goes past 10⁶.

### L14. `fallback_cert.py` rerun on the extended table

2,008 values, n up to 3239: **0 values where any fallback configuration could reach B(n)** — CERTIFIED throughout. 1,503 of 2,008 (74.9%) settled by theorem alone; per s-branch, 2,062 of 2,572 (80.2%). Theorem-side residue: **505** branches where E.3(ii) is pairwise only, **4** at s = 4, **1** at s = 5. Largest permitted s over the range: 5.

---

## What checked clean

Recorded because a review that lists only defects misrepresents the state of the work.

**Closed forms.** All six class caps reproduce from cap = η/(1+k√η)²: 1/4, (2−√3)/2 = 1/(1+√3)² = 0.133975, 1/9, (3−2√2)/2 = 1/(2+√2)² = 0.0857864, (2−√3)² = 0.0717968, (5−2√6)/2 = 5/2−√6 = 0.0505103. The class-5 perfect-square remark is right. δ(x) = min(x², 2x(1−kx), η(1−kx)²) is the correct reduction of the four orbital terms. Cross term exceeds the cap at every balance point. All §3.4 balance points correct.

**Singular series.** C₀ = ∏_{ℓ≥5}(1−3/ℓ)(1−1/ℓ)⁻³ = 0.6351664 to six places; σ₂ = 4, σ₃ = 9/8; 4·(9/8)·C₀ = 2.8582486. The "ω = 2 factor exceeds 1" step is right (1.172 at ℓ = 5, → 1⁺). The ω(ℓ) ≤ 3 < ℓ argument is correct and correctly caveated about leading coefficients, including the `mu-theta-n2-note.md` d = 6 degeneration.

**Table internal consistency.** C(n,2) correct on all rows; density = mu_bound/C(n,2) to 5×10⁻⁷; no F.1 stopping-rule violation.

**Engine claims.** All 754 one-part winners have ω(n) = 2; no ω(n) ≥ 3 value has a one-part winner; 1,077 values with ω = 2 splitting 754/323; all 356 values with δ > 1/4 have ω = 2 and a one-part winner; no 2-part winner exceeds 1/4 and no 3-part exceeds 1/9. Shape census 851 + 754 + 257 + 58 + 1 = 1,921 exactly, consistent with part counts 754/909/258.

**Parity statistics.** Even/odd medians 0.2249/0.1100; below 1/12: 1.0%/22.2%; below 1/9: 4.8%/54.3%; below 1/16: 0.1%/5.6%; the 37.0/59.9/64.8% progression exact.

**Ladder log.** All §5 decade minima exact — 3/0.03649@935, 226/0.02504@3239, 3679/0.03045@11819, 44821/0.04125@134423; "only four below 0.030, all in [3000, 10⁴]" exactly right (3059, 3239, 3479, 8927); 48,729 = line count of `ladder_weak.txt`; per-class table consistent with the global floor.

**Arithmetic.** 2183 = 37·59, 2291 = 29·79, 3239 = 41·79, 8927 = 79·113, all ≡ 11 mod 12; 1511 + 907 + 821 = 3239; 1511 + 907 + 641 = 3059; 136957/5243941 = 0.0261166; 151 | gcd(1510, 906).

**Theorem statements.** E.3(i)'s divisor argument (p − 1 = 2, base-3 repunits, a = 3/7/13 → c = 27/2187/1594323); E.4's factorisation forcing (c, r) = (16, 5) uniquely; E.2's L(a) ≤ 2^{(a−1)/2}+1 with equality at a = 17 (2¹⁶−1 = 3·5·17·257); E′'s s ≤ (1−√δ)/√δ derivation; F.1's counting proof; C.1's V(s) = L(s)−1 closed form. Theorem 2.1's upper bound — the valency/orbit-counting argument, the t ≥ 3 and intransitive branches, and the isolation of solvability to the single Zassenhaus step — reads correctly.

### L15. `check_doc_figures.py` rewritten, and it immediately found a live error

The v1 sweep flagged 67 figures across five files, nearly all noise: `n = 1175` is a witness value, and a quoted correction in a log looks identical to a stale claim. The cause was its suppression test, `frag not in str(cur.values())`, which compares a matched fragment against a stringified `dict_values` and so almost never fires. Rewritten into four passes.

**Pass 1 — figures, checkpoint-aware.** Every quantity is recomputed at each historical checkpoint (1540, 2007, 2212, 2298, 2376, current) as well as at the maximum, and the index maps *value → which quantity at which range*. So a hit reports "correct for: density floor @ n≤2212" rather than "does not match", which is the difference between a report and a pile. Down from 67 to 21, and all 21 are deliberate historical citations.

**Pass 2 — scope.** The pass that would have caught the falsified Corollary. Whitelisted patterns for range assertions ("every computed value has δ ≥ x", "δ > 1/k forces"), checked against the live floor. Theorem-shaped matches are reported as `[theorem]` with a count of values now outside scope rather than as errors, since a theorem does not expire — only the sentence counting its exceptions does.

**It found one on its first real run.** The rewritten Corollary in Part E′ named *three* values below 1/25; the latest extension had added a fourth, **n = 2303 (0.039633)**, admitting s ≤ 4. Corrected in Part E′, in Part J item 2a, and in `pending-checks.md`. Worth recording that this was a defect introduced by the 2026-08 pass itself and caught by a tool written in the same pass.

**Pass 3 — prose.** The signal is *contradiction* — a file asserting both that the search is finished and that values remain — not any single phrase. Two suppressions were needed to make it usable: quoted and code spans are stripped before matching, since a line quoting a marker is discussing it; and files matching `session-log|pending-checks|README` are exempt from the contradiction check, because describing a superseded state is what a log is for. Without those the checker reported itself, its own R6 entry listing the markers verbatim.

**Pass 4 — hygiene.** Doubled bold runs and doubled sentences, the residue of ad-hoc string replacement. Currently clean; it would have caught all three instances found by hand in this pass.

Live figures corrected as a result: ω(n) = 2 count 1,077 → 1,118 and the split-preferring count 323 → 338 (§2.1, §4 item 6 of `arithmetic-of-density.md`); ω(n) = 2 share 56.1% → 55.7%; even/odd medians 0.2249/0.1100 → 0.2248/0.1098 (§5.5 of the notes); the status table's "μ(n) known exactly, n ≤ 2,298" replaced by the real shape of the table (contiguous to 2,376 plus 3,059 and 3,239, 2,008 rows). The §4 drift prediction was also strengthened, since its own history now confirms it: 0.0418 → 0.041107 → 0.037524 → 0.026117.

---

## Process observations

**The failure mode is scope expiry, not arithmetic drift.** L1 and L4 are both cases of an *argument* whose scope silently expired — L4 because the density floor moved below 1/25, L1 because the class table was never re-derived from the η formula after the formula was written. `check_doc_figures.py` catches neither. The question "which arguments assumed δ ≥ x?" would have caught L4 immediately.

**Prose drifts as much as numbers.** L13's failure class is entirely prose: "one value remains", "27 survivors", "the search is complete". A figure sweep will never see it.

**Two of three lemmas read this session had defects.** That is the relevant base rate for the unread material, and it is the argument *for* a second independent reading rather than against it.

# Small-degree verification: n = 10 and n = 12

*Everything pursued at a single fixed degree — the GAP battery, the SAT/CSP machinery, the backbone probes, the template enumerator. Split from `pending-checks.md` so that file can be about the arithmetic programme, and it stays split: the two have different cadences (multi-week runs against per-batch checks) and only one point of contact.*

**This file is internal state-tracking, not narrative.** The account meant to be read is `small-degree-computation.md`; what lives here is what is outstanding, what has been verified against which artefact, and what is blocked on what. Findings are recorded in place rather than in a parallel review file, since two files describing one object is the drift risk this project keeps paying for.

**Verification status labels.** *Verified* — checked against an artefact in the working set, with the artefact named. *Sound* — argued and read, no independent computation. *Unverified* — neither.

**Relevance to §§1–6 of `orbital-evasiveness-notes.md`.** Almost none. The one exception is **item 5** below (exhaustiveness of the GAP stages), which is what licenses the two non-circular comparisons the arithmetic programme cites: n = 10 (967 groups, max m\* = 20 = B(10)) and n = 12 (7,115 groups, max m\* = 18 = B(12)), plus the Lemma B/C spot-check at n = 10 (1,061 full-capacity orbits, all of prime-power size; all 88 prime-sized ones satisfying B′'s condition). Those appear in Part I of `enumeration-proof.md` and §2.4 of the notes.

**Those two comparisons read m\* off the group files directly, not off the CSP battery**, so the dedup truncation of item 7 does not touch them. Everything the battery affects — the SAT verdicts, the backbone, the free band — is internal to this file.

**The direction of that dependence matters.** A group missed by the stages could only have *larger* m\*, which would be a counterexample to μ(n) ≤ B(n) rather than a silent corruption of it. So incomplete enumeration weakens the *evidence* without creating an error. If item 5 cannot be closed, the claim "the exhaustive optimum is the predicted construction" has to weaken to "no group in the enumerated set exceeds B(n)" — a real loss, since this is the only non-circular check in the framework, but not a retraction.

---

## Runs outstanding

*This file carries its own run list; `pending-checks.md` §1 is the arithmetic programme's.*

### Rerun the 54 CAP probes to establish the free band

*A long run, not analysis: this belongs after the table rebuild, since it wants the same machine time R0 does.*

The forced sets stop at 10 edges (IN) and start at 35 (OUT), so the free band is quoted as 11–34. **That band is not measured.** Against the current record: 409 classes probed, **25 IN (0–10 edges), 20 OUT (35–45), 310 free, 54 CAP (9–36)** — and of the 54 CAP classes, **49 sit strictly inside 11–34** while the other five sit at 9, 10, 10, 35 and 36, i.e. exactly on the two boundaries. So neither the band's interior nor its edges are established, and the runbook's escalation rule (static band ⟹ stage FULL) is keyed on a number no probe supports.

```bash
python3 probe_backbone.py --nodecap 50000000     # retries every CAP, skips exact verdicts
```

**Cost, from the record's own timings.** The 817 probes took **32.8 h**, of which the 54 CAP probes took **23.0 h** — 70% of the total spent on the probes that returned nothing, median 1,180 s and worst 6,307 s each, all against `--nodecap 5000000`. A rerun at 10× the budget therefore plausibly costs **200+ h** and is not obviously bounded, since a CAP is by definition a probe that had not finished. Two things make that tolerable: exactly one pinning capped per CAP class (0 classes had both capped), so each needs one probe rather than two; and the run is checkpointed per probe and stoppable between them.

**Sequencing and preconditions.**

- Run after R0. It competes with the rebuild for the same machine, and nothing upstream depends on the band.
- **Consider a partial run first.** The 49 interior classes are what the band claim needs; the 5 boundary ones (edges 9, 10, 10, 35, 36) decide whether the *boundaries* move, which is the cheaper and more decisive question — pass them via `--classes`.
- Rows in the existing record predate the `nodecap` column, so all 54 are retried whatever budget is given. That is intended, but it means there is no partial credit from the previous run.
- **Delete any `adversary_memo.pkl`** before any escalation that reaches the adversary search; a budget-limited run was the route to a spurious NON-EVASIVE.

### Rerun the n = 10 CSP on the full 167-condition battery

The published n = 10 SAT was computed on 75 of 167 available conditions, the old dedup key having merged the rest (item 7). Dropping conditions makes the system easier to satisfy, so the positive verdict does not transfer to the full battery. This is the cheapest of the three runs here and the only one whose outcome could settle a degree outright.

```bash
python3 consume_gap.py --infile groups_out_10.txt --maxgroups 1000 --maxt 10 --procs 8
python3 stage4_fast.py --first
```

UNSAT settles n = 10. SAT puts the framework's only satisfiability claim on an untruncated battery, and hands `chi_test.py` a solution whose skeleton is worth killing again.

### Rebuild the n = 12 battery, and decide the battery size first

Items 1 and 11 below are the same run seen from two ends. Sequence: pick `--maxt` (see item 1), run a cheap battery to a SAT/UNSAT verdict, and only then decide how S is computed.

---

## Commands

These read `ckpt_groups.pkl`, `ckpt_catalog.pkl`, `ckpt_order.pkl` from the working directory; `n` is implicit in `groups_out.txt` rather than a flag.

```bash
# items 1+2  rebuild the n = 12 battery with the corrected dedup key.
#   --maxgroups IS REQUIRED.  It defaults to 200 and silently truncates.
#   Stage-3 VF2 sampling is automatic (--verify, default 3000).
#   No manual cleanup: changing any flag changes the selection signature and
#   stage 1 deletes ckpt_groups/catalog/order itself.  Do NOT pre-delete them.
#   READ ITEM 5b FIRST -- stage 3 at full size is a multi-week run and may not be needed.
python3 consume_gap.py --infile groups_out.txt --maxgroups 1000 --maxt 8 --procs 8

# does groups_out.txt predate the multi-top-prime change to ark_gap.g?
awk -F'|' '$3 ~ /\+/' groups_out.txt | wc -l    # 0 => pre-change, or no group has two usable q

# item 3  involution pressure points
python3 probe_backbone.py --classes 393,401,405,108,437,439,457,493

# item 4  the 54 CAP classes at a larger budget
python3 probe_backbone.py --classes <the 54 CAP ids> --nodecap 20000000
```

**Needs code or data that does not exist:** item 7 (dedup-collision audit at n = 10) has no CLI entry point and needs an n = 10 `groups_out.txt`, which is not in the working set. Item 4's class list is not recorded anywhere machine-readable and must be re-extracted from the probe record first.

---

## 1. Rebuild the n = 12 battery with the corrected dedup key

`consume_gap.py`'s stage-1 key was an incomplete invariant that merged inequivalent orbital partitions; the corrected key is a pynauty canonical form on a layered graph. The battery must be rebuilt before any n = 12 verdict is quoted.

*State as of the 2026-07 run (log and checkpoints on file).* Stage 1 rebuilt correctly on the signature change with no manual cleanup, and stage 2 completed: **2,293 raw → 230 distinct (partition, prime) conditions → 227 kept (200 Oliver + 27 p-groups), 2,212 catalogue classes**. μ(12) = 18 survives, and three different quantities are easy to conflate here — *verified* against the n = 12 `groups_out.txt`:

- **8 groups** attain m\* = 18: `A:85`, `A:164`, `A:166`, `A:207`, `A:228`, `A:229`, `A:265`, and `B2:4x3:4.1` = T(4,4) ≀ T(3,1), all with orbital sizes **[18, 48]**;
- **1 distinct orbital partition** — all eight share it;
- **3 distinct (partition, prime) conditions**, the tags being six at `3`, one at `2`, and one at `0`.

`B2:4x3:4.1` being among them is the **direct confirmation that (𝔽₄⋊C₃)≀C₃ attains the optimum**, rather than a consistency argument. Note also that no p-group reaches 18: the maximum over all 7,115 groups is 18 and every attainer is Oliver. Stage 3 then reported **1,018,719 of 4,890,732 ordered pairs needing VF2 (20.8%)**.

**Two problems with that run, both to fix before repeating it.**

*(i) The battery was truncated.* `--maxgroups` defaults to 200 and stage 1 found 203 distinct Oliver conditions, so `sel = ol[:maxgroups] + pg` silently dropped 3. The sort is `(-mstar, t)`, so the casualties are the lowest-m\* conditions — harmless for μ(12) = 18, which reads off the top, but the battery feeds the Smith/χ computation where every condition is a constraint. Dropping constraints makes the system easier to satisfy, so a negative verdict would survive but a positive one would not be quotable. **Always pass `--maxgroups 1000`.**

*(ii) Stage 3 at full size is a multi-week run.* The old 600-class battery needed 74,213 VF2 pairs; the new 2,212-class battery needs 1,018,719 — 13.7×. Measured from the logs across three resumed sessions: 2,176 VF2 calls, 30,002 s, 16,061 pairs resolved → 7.4 pairs/call at 13.8 s/call, with yield decaying as the easy pairs go first (13.5 → 3.6 → 5.4). Extrapolating: **22 days** at the early rate, **33–41 days** at the late rate. The old battery never finished either — four sessions took it 22% of the way. *Verified* from the logs independently: 2,176 VF2 calls / 30,002 s / 16,061 pairs = 0.54 pairs/s, giving ~529 h ≈ 22 days for the 1,018,719-pair battery. These are **upper bounds**: the count of pairs needing VF2 falls on resume as closure propagates, 20.6% → 17.8% → 16.8% across the three sessions on the 600-class battery.

Levers, in order of preference: **settle item 5b first**, since the EGF route may make stage 3 unnecessary; failing that, cut `--maxt`.

**But `--maxt` discards far more than `--maxgroups` does, and that is not flagged anywhere.** Distinct (partition, prime) conditions by cut — *verified* by reimplementing `_orbital_canon` against the n = 12 file, reproducing the log's 230 / 203 / 27 at `--maxt 8` exactly:

| `--maxt` | groups | distinct conditions | Oliver | p-group |
|---|---|---|---|---|
| 4 | 264 | 36 | 35 | 1 |
| 5 | 392 | 73 | 72 | 1 |
| **6** | 892 | **125** | 119 | 6 |
| 7 | 1,541 | 169 | 157 | 12 |
| **8 (current)** | 2,293 | **230** | 203 | 27 |
| 10 | 4,803 | 339 | 271 | 68 |
| **12 (whole file)** | 7,115 | **425** | 309 | 116 |

So `--maxgroups 200` silently drops 3 conditions, while **`--maxt 8` silently drops 195** — 425 available against 230 kept. The honest framing of the `--maxt 6` lever is *"we use 54% of the available conditions today; that would use 29%"*, not *"a weaker battery"*.

> **The count is highly sensitive to the canonical form, so never quote it without naming the form.** The shipped key colours the orbital-class vertices by (size, degree-profile), which is what gives 230 at `--maxt 8`. A plainer two-colour layering — points versus orbital classes, all classes interchangeable — gives **162**, merging 30% more; the note in `consume_gap.py` about an earlier attempt over-splitting sevenfold is the same sensitivity in the other direction. Two independent attempts at the canonicalisation reproduced the group counts exactly and the condition counts not at all, which is the tell.

## 2. Stage-3 sample verification at n = 12

Now automatic, folded into the item-1 run (`--verify`, default 3000 random ordered pairs re-decided by VF2). The n = 10 acceptance test was bit-identical agreement with an archived full-VF2 reference; there is no such reference at any other degree, and roughly 80% of ordered pairs are settled by inference alone. Until this passes, the n = 12 order matrix is an unchecked implementation of checked rules.

## 3. Settle the duality involution empirically

`probe_backbone.py` computes the complement class of every forced class and reports violations plus the specific unprobed complements the theorem predicts. Three pressure points in the current n = 10 record, all cheap to close:

- the three forced-OUT classes at 38 edges (393, 401, 405) require three forced-IN classes at 7 edges, and the only 7-edge class probed (**class 108**) came back **free**. If 108 is the complement of any of the three, **the theorem is contradicted**; if not, the partners are unprobed.
- the five forced-IN classes at 8 edges require five forced-OUT at 37 edges; no 37-edge class has been probed.
- the forced-IN class at 2 edges requires a forced-OUT at 43; no 43-edge class has been probed.

The practical corollary — probe one representative per complement pair, halving the sweep — is currently being relied on without this check.

## 4. Re-probe the 54 CAP classes at a larger node budget

**The CAP classes sit at 9–36 edges, not 12–36** — *verified* against `probe_results.csv`. The 12–36 figure comes from `probe_backbone.py`'s own comment, which describes where they are *concentrated*, not their range. The distinction is load-bearing: forced-IN tops out at 10 edges and forced-OUT begins at 35, so

- **49 of the 54 CAP classes sit strictly inside 11–34** — the band's interior is unknown, not free;
- **the other five sit at 9, 10, 10, 35 and 36** — on both boundaries, so the band's *endpoints* are unsupported too, and a boundary probe resolving the wrong way would move the band rather than fill it in.

A CAP class is *not* free. Exactly one pinning capped per CAP class (0 classes had both), so the rerun is 54 probes rather than 108. Cost and sequencing are in Runs outstanding above.

## 5. Exhaustiveness of the four GAP stages

*Partially discharged.* Only the Oliver-condition test and the emission logic of `ark_gap.g` have been read. `IsOliverTop` is **sound** — taking Γ₂ = `PCore(N,p)` is WLOG since any normal p-subgroup with cyclic quotient lies in O_p(N) and the quotient is then a quotient of a cyclic group; normality in Γ is automatic because O_p(N) is characteristic in N with N ◁ Γ.

**5a. The subdirect-product hole.** The four stages are: **A** every transitive group of degree N via `TransitiveGroup(N,k)`; **B** every partition of N with each part carrying an independently chosen transitive group, generators embedded blockwise; **B2** every wreath product T(d,k) ≀ T(r,j) with dr = N; **C** for each prime p ≤ N, the conjugacy classes of subgroups of a Sylow p-subgroup of S_N. The union is **not** obviously exhaustive over intransitive imprimitive groups: stage B builds direct products of transitive constituents, so an intransitive group whose projections are transitive but which is a *proper subdirect* product — a fibre product over a common quotient — is generated by neither B nor B2, and C only reaches it if it happens to be a p-group. **That is the concrete gap to close or refute.**

**5b. Did stage C finish?** `ConjugacyClassesSubgroups(SylowSubgroup(S_N, 2))` is the expensive step and is explicitly noted in the file as non-checkpointable at N = 10, so any claim of completeness at N = 12 depends on that call having finished. Check the logs. Mitigating for the headline: p-subgroups do not attain the optimum at n = 12, so m\* = 18 is robust to this gap even if it stays open. **But "the eight attainers sit at q = 2 and q = 3" is wrong** — *verified*: six carry tag `3`, one carries `2`, and one carries **`0`**, namely `A:166` = T(12,166) of order 576, a **trivial top**. That cuts in the strengthening direction: a trivial top gives χ = 1 *exactly* rather than merely mod q, so the optimum at n = 12 is witnessed by the harshest condition the machinery has. The sentence understated the result it was defending.

*Completeness datum for stage C, from the artefacts:* `ark_gap.log` holds 7,115 `emitted` lines and `done_keys.txt` holds 16,353 keys, so **9,238 groups were built and dropped** as non-Oliver or over `MAXT` — 56% of what GAP constructed, and the bound on what raising `MAXT` could add. Whatever `ConjugacyClassesSubgroups` did or did not finish, 5,924 stage-C groups were emitted and the skip count is accounted for.

## 6. The lcm strengthening is implemented but unexercised

`IsOliverTop` returns every usable top prime as a `+`-separated tag and the solvers enforce χ ≡ 1 mod lcm. Single-prime tags parse identically, so old files behave as before — which also means the path may never have run.

**Verified: no group carries a multi-prime tag, at either degree.** `awk -F'|' '$3 ~ /\+/' groups_out.txt | wc -l` returns **0 at n = 12 (7,115 groups)** and **0 at n = 10 (967 groups)**, both checked directly. Tags are exactly `0`, `2`, `3`, `P2`, `P3`, `P5`, `P11` at twelve, and the same plus `P7` at ten. Two readings, and the logs cannot separate them: either the files predate the change, or **8,082 groups across two degrees genuinely admit at most one usable top prime**. The second is the more interesting possibility and would mean the strengthening is worth nothing rather than merely untested.

So this needs one GAP re-emission from a known-current `ark_gap.g`. **If that also yields no `+` tag, retire the strengthening rather than leaving it as dead code**, because it carries a live hazard: the same lcm enforcement fed from `ark_intersect`'s twist primes would be unsound, and dead code invites exactly that reuse. (`probe_backbone.py` now logs when a multi-prime tag fires, so the re-emission answers this for free.)

## 7. Dedup-collision audit at n = 10 — done, and the published battery was less than half the available conditions

*Verified against the n = 10 `groups_out.txt` (967 lines, 45-entry orbital maps) using the shipped `_orbital_canon`.*

Distinct (partition, prime) conditions in the n = 10 file, by orbital cap:

| `--maxt` | groups | distinct conditions | Oliver | p-group |
|---|---|---|---|---|
| 4 | 74 | 31 | 30 | 1 |
| 6 | 306 | 77 | 67 | 10 |
| **8** | 517 | **123** | 101 | 22 |
| **10** | 756 | **167** | 125 | 42 |
| 12 (whole file) | 967 | **189** | 128 | 61 |

**Now compare the batteries the published n = 10 runs actually used.** The log records `517 raw -> 57 kept (40 Oliver, 17 p-groups)` and then `756 raw -> 75 kept (40 Oliver, 35 p-groups)`. Against the corrected key those same cuts hold **123** and **167** distinct conditions. So the old invariant key merged conditions roughly three to one on the Oliver side — **40 kept where 125 exist** — and the published battery carried **75 of 167 available conditions, 45%**.

**Which results this touches, and which it does not.**

- **μ(10) = 20 is unaffected.** It is read off `groups_out.txt` directly: max m\* over the 268 Oliver groups is 20, and over all 967 it is still 20. The dedup only ever decided which conditions enter the CSP.
- **The n = 10 SAT is weakened, in the direction that matters.** Dropping conditions makes the system easier to satisfy, so "the CSP is satisfiable at n = 10" was established against 45% of the constraints available. A negative verdict would have survived the truncation; a positive one does not transfer. Anywhere the SAT is described, it should read *"satisfiable on the 75-condition battery"* rather than as a property of n = 10.
- **The χ kill is unaffected.** `chi_test.py` evaluates a specific property's down-closure and never consults the battery, so §8.12's kill stands as stated. That is also the reason the kill matters more than the SAT: it is the one result the truncation cannot reach.

**Rerunning the n = 10 CSP on the full 167-condition battery is therefore worth more than it looks** — it is cheap by n = 12 standards (V grows but stage 3 at n = 10 has completed before at 1,242 classes), and either outcome is informative: UNSAT would settle n = 10 outright, and SAT would put the framework's only satisfiability claim on a battery that is not silently truncated.

**A parallel to n = 12 worth recording**, since the same three quantities get conflated at both degrees. m\* = 20 is attained by **8 groups** — `A:17`, `A:18`, `A:19`, `A:20`, `A:27`, `A:28`, `A:33` and `B2:5x2:3.1` = T(5,3) ≀ T(2,1) — all with orbital sizes **[20, 25]**, forming **1 orbital partition** and **2 distinct conditions** (seven at tag `2`, one at tag `0`). As at n = 12, the wreath is among the attainers, confirming AGL(1,5)≀C₂ rather than assuming it, and one attainer (`A:18`, order 200) has a **trivial top**, so the optimum is again witnessed by χ = 1 exactly. Stage census: A 24, B 319, B2 6, C 618.

## 8. `Catalog.classify` is a mutating lookup used as a pure query

In `stage4_fast.py`, `probe_backbone.py` and `chi_test.py` the idiom `x[cat.classify(set())] = 1` assumes the empty graph is already in the catalog. If it were not, `classify` would **append**, silently extending `cat.reps` and desynchronising `V` from the order matrix. The same hazard applies to the complement lookups in the involution check, which is why that block asserts the catalog did not grow. **Verified latent, and half-closed.** The empty graph is present in both catalogs (at n = 12 the full 0–66 edge range is), so the idiom does not currently mutate anything — the code is correct *by accident of the catalog's contents*, not by construction. `probe_backbone.py`'s two call sites now use a read-only lookup that raises with the reason if a graph is absent; `stage4_fast.py` and `chi_test.py` still carry the idiom and want the same treatment.

## 9. `mono` is only ever called on representatives with the same vertex count

The complement trick in `ark_intersect.mono` rests on σ(E_H) ⊆ E_G ⟺ σ⁻¹(E_Ḡ) ⊆ E_H̄, which requires σ to be a **bijection** — true when H and G both carry all n vertices, false for a genuine injection. Every catalog representative does carry all n vertices, so the call sites are fine. **Sound, but undefended.** An assertion on the vertex counts inside `mono` would make it safe against reuse.

## 10. `TemplateGroup` places the block rotation in the cyclic middle layer

§2.4's implementation note describes the defect as a spurious gcd(d, k) = 1 filter plus a prime-only k, and both symptoms are visible in `candidate_groups`. They are not the cause. `TemplateGroup`'s own chain model puts the rotation in Γ₁/Γ₂ — its docstring requires d, the foreign primes and s pairwise coprime — and separately enforces k = s with s prime. Theorem 2.4 places the rotation in the top q-group, whence any d | c−1 is admissible and k need only be a prime power. Consequence: the template misses μ(10) = 20 (k = 2, d = 10) and μ(12) = 18 (k = 4).

**Do not repair this in the enumerator alone.** Relaxing the filter builds groups that `TemplateGroup` marks invalid, and an unconditional `break` over the twist candidates then discards the smaller d that had been working — n = 22 fell from 110 to 55. That change was reverted. The `break` bug is genuine and independent and has been fixed (break only after a valid group is actually produced); with it fixed and the filter restored, the template reproduces Run 1 exactly at n = 6, 10, 12, 15, 18, 21, 22, 26 (6, 10, 10, 30, 36, 28, 110, 78). The real repair is to move the rotation into the top layer inside `TemplateGroup`, updating its Oliver validity check and `desc_parts`, which also changes what `top_prime` parses. **Open, deliberately deferred** — the GAP path has no such restriction and supersedes this enumerator, so the value is in correctness of the record rather than in better μ bounds.

## 11. Decide how S will be computed at n = 12

`chi_test.py` enumerates the full down-closure with a canonicalisation per node: 64,333 classes and about 60 s at n = 10, against `--cap 5000000`. At n = 12 the ambient count is 1.65 × 10¹¹ iso classes and the closure of an 18-edge-or-larger generator set may well exceed the cap. The global χ test is the only test that has actually killed anything, so losing it at n = 12 would be a real loss. The alternative is the §8.4 route — exponential formula over signed connected-component weights, two-sort EGF for bipartite components — which computes S without enumerating the closure. **A design decision, not a bug.**

**A prior question comes before both options, and it is cheaper than either: is n = 12 SAT at all on a cheap battery?** A `--maxt 6` battery is 125 conditions and its catalog will be far smaller than 2,212, since class count is driven by the large lattices; stage 3 scales with V², so this is plausibly hours rather than weeks. If it returns **UNSAT**, n = 12 is settled and neither the 22-day stage 3 nor the EGF machinery is needed. If **SAT**, the result is a solution to χ-test and the EGF question becomes concrete rather than hypothetical.

So the dependency runs the other way from what this item used to assert. **Run the cheap battery, then decide how S is computed.** Stage 3 of `consume_gap.py` exists to supply the containment-order matrix and projects to 22–41 days at full size, so the standing question — whether the order matrix is needed at all — is worth answering only after a verdict is in hand. If the EGF route then wins, a `--stop-after 2` flag would let the battery be built without entering stage 3.

---

## 12. Measure the battery's constraint strength against its cost

By §9.7 the χ constraint is decisive at t ≤ 3 and weak by t ≥ 4, but 93% of the n = 10 battery's Σ2^t cost sits at t ≥ 7 (31 groups, 16,128 of 17,356). High-t groups do generate catalog classes and monotonicity couplings, so this is not an argument to drop them — but the battery is selected by m\* and cost, never by constraint strength, and the trade is unmeasured. Cheap test: solve the t ≤ 6 sub-battery (44 groups, 7% of the cost) and see how much backbone survives. If most does, n = 12 becomes tractable. This is the same lever as item 1's `--maxt`, measured rather than guessed.

## 13. What the n = 10 and n = 12 artefacts have settled

*Everything verifiable from the checkpoints and logs in the working set, so that no number below needs re-deriving. Where a claim elsewhere disagreed, the artefact wins.*

**n = 10.** The census is **967 = 95 (trivial top) + 159 (q = 2) + 14 (q = 3) + 699 p-groups** (673 / 18 / 6 / 2 across P2 / P3 / P5 / P7), by stage **A 24, B 319, B2 6, C 618**, all lines well formed with 45-entry maps. Max m\* is **20** over the 268 Oliver groups and over all 967, attained by 8 groups / 1 partition / 2 conditions (item 7). V = 1,242 with a matching 1,242-row order matrix; `solution1.pkl` at 214 IN / 1,028 OUT with 0 monotonicity violations against that matrix; the skeleton contains **2K₅ (catalog index 2, x = 1) and not K₅,₅ (index 1, x = 0)**, which is §9.7's claim; the catalog is complement-closed with **no self-complementary class**; the involution cross-check on the probe record gives **30 confirmed pairs, 0 violations**, with 15 forced classes whose complement is unprobed; the probe record is **817 probes over 409 classes — 25 IN, 20 OUT, 310 free, 54 CAP**.

**n = 12.** The census is **7,115 = 295 (trivial top) + 657 (q = 2) + 67 (q = 3) + 6,096 p-groups**, the p-groups splitting 6,004 / 88 / 2 / 2 across P2 / P3 / P5 / P11; by stage, **A 194, B 969, B2 28, C 5,924**; all lines well formed with 66-entry orbital maps. Max m\* is **18**, attained by 8 groups / 1 orbital partition / 3 conditions (item 1). The dedup at `--maxt 8` is **2,293 → 230**, reproduced exactly.

**Counts that have been wrong and are now pinned:** the n = 12 census is 7,115, not 8,819; the m\* = 18 attainers are 8 groups, not six or seven "ways"; the CAP range is 9–36, not 12–36; the attainer tags at both degrees include a trivial top. And the published n = 10 battery is **75 of 167 available conditions**, which is a fact about the SAT claim rather than about μ(10) (item 7).

## 14. Artefacts still wanted

> **Both degrees' `groups_out.txt` share a filename, and each upload has overwritten the other.** Keep them as `groups_out_10.txt` and `groups_out_12.txt`, or check the orbital-map length before use — 45 entries at n = 10, 66 at n = 12. The same collision has already cost this file two rounds, and it silently swaps a census rather than failing.

- **`stage4_fast.py`.** Unreviewed, and now the only remaining place the lcm hazard could land — `probe_backbone.py`'s copy of that logic has been read and its tag path is legitimate.

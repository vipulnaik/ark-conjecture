# Notes on `small-degree-verification.md`

*Checked against the n = 10 and n = 12 artefacts. The document is in good shape — the split from `pending-checks.md` is right, the framing paragraph about the direction of the dependence is exactly the right thing to say, and the timing analysis in item 1(ii) reproduces on my own reading of the logs. What follows is four corrections, three items I could close or advance, and one gap the document does not currently name.*

## The framing is right, and worth keeping verbatim

> "A group missed by the stages could only have *larger* m\*, which would be a counterexample to μ(n) ≤ B(n) rather than a silent corruption of it."

That is the correct statement of the risk direction and it is the reason item 5 is a bounded worry rather than an open wound. Keep it at the top.

## Corrections

**(1) "m\* = 18 attained by 3 distinct conditions, the previously reported 8 groups collapsing" — all three numbers are right, and they are three different quantities that the surrounding documents keep mixing up.** Counted directly:

- **8 groups** attain m\* = 18: `A:85`, `A:164`, `A:166`, `A:207`, `A:228`, `A:229`, `A:265`, and `B2:4x3:4.1` = T(4,4) ≀ T(3,1) — seven transitive plus the wreath, all with orbital sizes **[18, 48]**;
- **1 distinct orbital partition** — they all have the same one;
- **3 distinct (partition, prime) conditions**, because the tags are `0`, `2`, `3`.

So §8.11's "six ways" is wrong, my own "seven ways" was wrong (I counted stage A only, missing the wreath), and this document's "8 groups → 3 conditions" is right. **The wreath `B2:4x3:4.1` being among them is the direct confirmation that (𝔽₄⋊C₃)≀C₃ attains the optimum** — worth stating, since §8.11 asserts it as consistency rather than as a checked fact.

**(2) Item 5b: "the eight attainers sit at q = 2 and q = 3" is wrong.** The tags are six at q = 3, one at q = 2, and **one at `0` — `A:166` = T(12,166), order 576, a trivial top.** That matters in the strengthening direction: a trivial top gives χ = 1 *exactly*, not merely mod q, so the optimum at n = 12 is witnessed by the harshest available condition. The sentence understates the result it is defending.

**(3) Item 4: the CAP classes are at 9–36 edges, not 12–36.** The record has CAP probes at 9, 10, 10, 11 as well as up through 36. This is not pedantry: **forced-IN tops out at 10 edges and forced-OUT begins at 35**, so CAPs at 9, 10 and 11 straddle the lower boundary and at 35, 36 the upper one. The band edges are therefore not established at either end, which is a stronger statement than "no statement of the form 'the band is free from 11 to 34 edges' is supported" — it is also true that *the band's endpoints* are unsupported. (`probe_backbone.py`'s own comment says "concentrated at 12–36", which is where the figure came from; it is a description of the concentration, not the range.)

**(4) Item 6 is answerable now, and the answer is that no group has two usable q — at either degree.** The document's own diagnostic, `awk -F'|' '$3 ~ /\+/' groups_out.txt | wc -l`, returns **0 at n = 12 (7,115 groups) and 0 at n = 10 (967 groups)**. Tags are exactly `0`, `2`, `3`, `P2`, `P3`, `P5`, `P11` at twelve and the same with `P7` at ten. So either the file predates the change — which the log cannot distinguish, since `ark_gap.log` records `tag=` values and none has a `+` — or **8,082 groups across two degrees genuinely admit at most one usable top prime**. The second is the more interesting possibility and would mean the lcm strengthening is worth nothing, not merely untested. Either way the item's conclusion stands: it needs one GAP re-emission from a known-current `ark_gap.g` before anything is claimed. **Add: if the re-emission also yields no `+` tag, the strengthening should be retired rather than left as dead code**, since it carries a live soundness hazard (`ark_intersect.top_prime`'s `.top_primes` is derived from *twist* primes and is not verified, so feeding it to the same lcm enforcement would be unsound).

## Items I can advance

**Item 7 (dedup-collision audit) — method validated, but the n = 10 data is gone.** I reimplemented `_orbital_canon` independently (pynauty layered graph, same colouring) and it **reproduces the n = 12 log exactly**: at `--maxt 8`, 2,293 groups → **230 distinct conditions, 2,063 redundant (90.0%)**, split 203 Oliver + 27 p-groups — matching `2293 raw -> 227 kept (200 Oliver, 27 p-groups)` once `--maxgroups 200` caps the Oliver side. So the audit script works and the n = 10 run is a two-minute job. **But the current upload replaced the n = 10 `groups_out.txt` with the n = 12 one**, so it still cannot be run. The file is small; re-upload it and item 7 closes.

**A finding the audit produced that the document does not mention: `--maxt` discards far more than `--maxgroups` does.** Distinct (partition, prime) conditions as a function of the cut:

| `--maxt` | groups | distinct conditions | Oliver | p-group |
|---|---|---|---|---|
| 4 | 264 | 36 | 35 | 1 |
| 5 | 392 | 73 | 72 | 1 |
| **6** | 892 | **125** | 119 | 6 |
| 7 | 1,541 | 169 | 157 | 12 |
| **8 (current)** | 2,293 | **230** | 203 | 27 |
| 10 | 4,803 | 339 | 271 | 68 |
| **12 (the whole file)** | 7,115 | **425** | 309 | 116 |

Item 1(i) is right that `--maxgroups 200` silently drops 3 conditions and that this should be fixed. But **`--maxt 8` is silently dropping 195** — 425 available against 230 kept — and that truncation is nowhere flagged. The same asymmetry applies to the proposed remedy: dropping to `--maxt 6` costs 105 more conditions (230 → 125) on top of the 195 already lost. So the honest framing of lever (ii) is *"we are already using 54% of the available conditions; `--maxt 6` would use 29%"*, not *"a weaker battery"*.

**Item 8's premise holds at both degrees.** The empty graph is present in the n = 12 catalog (and K₁₂, and the full 0–66 edge range), as it is at n = 10. So `x[cat.classify(set())] = 1` does not currently mutate anything and the hazard is latent exactly as the document says. The `classify_or_fail` fix is still the right one — the point is that the current code is correct *by accident of the catalog's contents*, not by construction.

## One gap the document does not name

**Item 11's decision has a third option that is cheaper than either.** The document frames it as: enumerate the down-closure (may blow the cap at n = 12) versus the EGF route (avoids the order matrix entirely). But there is a prior question — **whether n = 12 is SAT at all on a cheap battery.** A `--maxt 6` battery is 125 conditions, and its catalog will be far smaller than 2,212 because class count is driven by the large lattices; stage 3 scales with V², so this is plausibly hours rather than weeks. If that battery returns **UNSAT**, n = 12 is settled and neither the 22-day stage 3 nor the EGF machinery is needed. If it returns SAT, the result is a solution to χ-test and the EGF question becomes concrete rather than hypothetical.

That ordering — cheap battery first, then decide about S — is not in the document, and it inverts the dependency it currently asserts ("this gates item 1"). **Run the cheap battery, then decide.**

## Smaller notes

- Item 1's timing reproduces: I get 2,176 VF2 calls / 30,002 s / 16,061 pairs from the logs independently, i.e. 0.54 pairs/s, giving ~529 h ≈ 22 days for the 1,018,719-pair battery. The document's 22 days at the early rate and 33–41 at the late rate is the right pair of numbers. Worth adding the one mitigating fact: the pairs-needing-VF2 count **falls on resume** as closure propagates — 20.6% → 17.8% → 16.8% across the three sessions on the 600-class battery — so these are upper bounds.
- Item 5b: `ark_gap.log` at n = 12 has 7,115 `emitted` lines and `done_keys.txt` has 16,353 keys, so **9,238 groups were built and dropped** (non-Oliver, or over `MAXT`). That is a useful completeness datum for stage C that the item does not currently use: whatever `ConjugacyClassesSubgroups` did or did not finish, 5,924 stage-C groups were emitted and the skip count is accounted for.
- Item 9 is right and the fix is one assertion. Item 10's diagnosis matches what I read in the sources.

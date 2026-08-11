# Session log 4

*Work completed in the 2026-08 second review pass, on the arithmetic programme — `orbital-evasiveness-notes.md` §§1–6, `enumeration-proof.md`, `arithmetic-of-density.md`. Companion to `session-log-3.md` and `session-log.md`. `pending-checks.md` carries only what is still outstanding; anything closed lands here.*

## What the pass was

A cold read of the three documents and the accompanying scripts against `mu_table_safe_v4.csv` at n ≤ 2000, with the review questions in priority order: are the statements right in spirit, are they right in letter, and do the documents agree with each other and with the data.

**No error was found in any stated inequality, and no computed value is wrong.** What was confirmed clean:

- the sandwich B_refined ≤ μ ≤ B_safe, its incomparability statement, and the collapse resting only on the eight necessary conditions of `fb_common.py`;
- all eight mod-24 ceiling constants, their balance points and closed forms, including the algebraic fact that cap_B(η/2) = cap_C(η) only at η = 1/2;
- the η = max(1/u, L/(2^{a−1}u)) formula re-derived from scratch, both η = 1 sources included;
- the per-residue mod-8 rung-reachability congruences at every D;
- n = 308's terms and coprimality; the n = 3239 case-F terms and δ = 0.043570; the n = 247 and n = 531 worked rows;
- E.1, E.2 (L(17) = 257), E.3(i), E.3(ii)'s gcd(r−1,3) repair, E.3(iii), E.4;
- V's closed form at 19/475/1425/35/26 and the B₀ contrast at n = 1425;
- the F ≤ 1/δ₀ boundary check, Meinardus' constant 2.532, N_add = K(K+1)/2 and its 16/12 parity split;
- S6's cap ladder and the n = 8q+2 mod-3 argument; the escape-window ratio 3.45 and the head/tail geometric sum;
- Theorem 9.1, §9.7's orbital-count formula, §7.2's lists (A) and (B), Theorem 2.1's counting bound, Theorem 2.2 at n = 35;
- against the data: v4 ≥ v2 at all 1,666 common values; all 142 `brute.jsonl` records agree with v4, the targeted 143 / 247 / 285 / 308 included; v2's row-count reconciliation (2,047 / 1,921 / 1,848); **Part I's shape census 851 / 754 / 257 / 58 / 1 reproduced exactly by an independent parse**; all 11 v4 S4 winners at c ≡ 1 (mod 8); zero unequal-size matching winners at odd p through n = 2000.

**Checks deliberately not run, on effort budget:** `mu_enumerate_v2.py`'s pruning (spot-checked only; the naive cross-check partially covers it); `check_doc_figures.py` and `validate_table.py` in full; `ladder_verify.py`'s S7-at-F≥3 loop and worklist logic; `fb_common.py`'s necessity reading, which stays with T3; §3.8's count table and §3.2.3's prime counts, code-reviewed rather than re-run; the measured values of notes §§9.5–9.6.

## Findings, all fixed in this pass

### A13. The within-class cross coefficient, second pass — three sites A0c missed

*A0c corrected the F-vs-q keying in five places and recorded "both enumerators were already right". Both enumerators are indeed right (`mu_enumerate_v2.py`'s `self.cb` and `brute.py` both key on `F % 2`). Four further sites were not caught, found on a cold read 2026-08 and now fixed.*

- **`arithmetic-of-density.md` §3.2.4, the n = 273 row.** Listed the within-class cross as **13778 = 2·83²**, which is impossible on its face: two blocks of 83 have only 83² = 6889 cross pairs in total, so no class can hold 13778. Corrected to 6889. The bold minimum 5671 was never affected — the intra term 2·orb(83,41) = 6806 binds first.
- **`arithmetic-of-density.md` §3.2.4, the "structural note" immediately below.** Stated the rule as "c² for q = 2 and 2c² for odd q" — the exact q-keying the `enumeration-proof.md` correction box declares wrong. Rewritten to key on F, with the conclusion (a fused class's minimum is essentially never its within-class cross) preserved, since intra ≤ c(c−1) < c² at F = 2 regardless of q.
- **`enumeration-proof.md` Part 0, the S5-vs-S7 comparison box.** The n = 273 term list carried the same 13778, the two documents having been written from one another. Corrected to 6889 in both.
- **`ladder_verify.py` rung B and `rung_split.py`'s `v7` plus docstring.** Both scored `2*c*c` at F = 2. `ladder_verify.py`'s own rung B′, four lines further down, already had `c*c` with the comment "F/2 because F is even" — so the file was internally inconsistent. Both fixed.

**Nothing measured moves**, because the term never binds: 2·orb(c, d) ≤ c(c−1) < c² < 2c². Re-running `rung_split.py` over a band before and after gives the same split. **But in `ladder_verify.py` this was an over-credit in a lower-bound script**, which is the dangerous direction, and it was harmless only by accident. That is the reason to treat the class of error as live rather than cosmetic.

**The coefficient was settled by construction, not by re-reading the formula.** Building the group at c = 7 — two blocks, independent translations, diagonal twist of order 3 (the odd part of c − 1), block swap — gives orbital sizes **{42, 49}** summing to C(14,2) = 91: intra 2·orb(7,3) = 42 and within-class cross **49 = c²**. That matches Theorem 3.1's F-keyed formula and §9.7's ⌊F/2⌋ orbital count, and rules out 2c² outright.

*Lesson for the next pass, and the reason A0c is worth reopening rather than just amending:* a correction applied "in five places" is a grep over prose, and it misses (i) numbers in worked tables that instantiate the wrong rule without restating it, and (ii) scripts where the term is dominated and so never shows up in output. Both classes want an explicit sweep next time, and the second wants `validate_table.py` to assert the coefficient rather than only the resulting minimum.

### A14. Cross-reference rot in `orbital-evasiveness-notes.md`

*Fourteen pointers to sections that do not exist in the current file, plus a theorem cited four times and stated nowhere. These are semantic, not cosmetic: Open Problem 1 told the reader "§5.3's table fixes its value" and there is no §5.3.*

- **§2.5, §2.6** → the Lemma A/B/B′/C box and the `DUP:B_definition` box, both in **§2.4**.
- **§5.3, §5.4, §5.5** → the mod-12 ceiling table and odd-n analysis were excised to `arithmetic-of-density.md` (§3.3, §3.2, §7) and to `enumeration-proof.md` Part I; §5.4's one reference is to Proposition 5.2′, which is in §5.
- **Theorem 2.4**, cited twice in the notes and twice in `enumeration-proof.md` (Part E's verification table and Part I's n = 12 re-derivation), is stated nowhere. Every instance is really Theorem 3.1's value formula or §2.1's fused class; repointed accordingly. The Part I instance also read the cross coefficient off q, so it was an A13 site as well.

**Add a pass to `check_doc_figures.py`**: resolve every `§x.y` and `Theorem/Proposition/Lemma N` reference against the headings and bolded statements actually present in the three documents, and report dangling ones. This is a mechanical check that would have caught all fourteen, and the excision of a section is exactly the edit that creates them.

### A15. Two stale mod-12-era statements in the notes

Both survived the 2026-08 mod-24 correction because they sit outside the correction box.

- **§5 said "Ceiling 1/9 at full efficiency" for the odd-n three-part family.** 1/9 is the **unfused** (rung C) cap; the family's ceiling at full efficiency is the fused rung's **3 − 2√2 ≈ 0.17157**. Replaced, with a box explaining that 1/9 survives elsewhere in the notes only as Theorem E.1's collapse threshold and Corollary F.3's k ≤ 2 threshold — different quantities that coincide numerically, which is presumably how the confusion persisted.
- **The overview's one-paragraph summary** described the odd-n route as "a covering system of three-block chains ((4,6) for 3∤n, (6,12) for 3|n; the (2,4) chain is mod-3-impossible and (2,6) fails locally at 3|n)". That notation is not defined anywhere in the current documents and does not reconcile with §3.5.4's admissible-d table, which gives d = 2 at n ≡ 1, 9 (mod 12). Rewritten in terms of d ∈ {2, 4, 6, 12} keyed to n mod 12, and "the six values of the §5.3 table" corrected to the eight values of the mod-24 table.

### A16. Shape-count mismatch between the notes and `arithmetic-of-density.md` §6

The notes' §6 quoted "31 shapes at δ₀ = 1/9, 117 at 1/16". No column of §6.1 or §6.4 produces those: the raw feasibility counts are **24** and **65**, sizes-free 32 and 109, penalised 26 and 80, and the purely additive counts — the ones that belong in a covering statement — are **6** and **10**. The notes now quote 24/65 with the additive 6/10 alongside, and point at both subsections. Worth checking whether 31/117 predates §6.4's recount or came from a third computation; if the latter it should be found, since it would mean a discarded count is still live somewhere.

### A17. `count_check.py`'s silent `--centre >= 0.5` fallback

The non-`--dq` prediction computed `denom = log(x*n)*log((1-2x)*n) if centre < 0.5 else 1`. The non-dq path is inherently the three-part family, so a centre at or above 1/2 leaves no room for the foreign block — but rather than failing, the guard dropped **both** log factors and returned a prediction too large by log²n, with nothing in the output saying so. Now exits with a message pointing at `--parts 2` or `--dq`. No published figure used the branch; this is a foot-gun removed, not a result corrected.


## Consequences carried forward

Three items were re-scoped rather than closed and remain in `pending-checks.md`:

- **A1's recount trigger fired.** At n ≤ 2000 the δ ≤ 1/16 set is 7 values (527, 1159, 1175, 1739, 1763, 1817, 1943) and the floor is 0.045742 at n = 1817. That still gives s ≤ 1/√δ − 1 = 3.68, so the s = 4 and s = 5 branches stay dissolved, but the margin to δ = 1/25 is 0.0457 against 0.0400. Rerunning the certificate against v4 is **R8**.
- **Two mechanical checks are wanted**, both of which would have caught findings from this pass and neither of which exists: a reference-resolution pass in `check_doc_figures.py`, and a per-row assertion of the within-class cross *coefficient* in `validate_table.py`.

## The pattern worth carrying to the next pass

Every finding here is propagation failure rather than a mistake in reasoning. A correction applied to prose misses three things systematically:

1. **Worked numbers that instantiate the wrong rule without restating it.** The n = 273 cross term was 13778 in two documents; nothing in either sentence said "q", so a grep for the wrong rule could not find it. The tell was arithmetic — two blocks of 83 hold only 6889 cross pairs, so 13778 is impossible on its face, and the number could have been caught by an order-of-magnitude read at any time.
2. **Dominated terms in scripts.** An over-credited term that never binds produces identical output before and after the fix, so no test, diff or measurement can see it. In a lower-bound script this is the dangerous direction and it was harmless only by accident.
3. **Cross-document duplicates and cross-references.** Excising a section is exactly the edit that leaves dangling pointers, and duplicated counts drift silently because neither copy is obviously wrong on its own.

The general remedy is that each of the three classes wants a mechanical check rather than a reading pass, because each is invisible to reading in a different way.

---

## Second batch: closed items

### R3. The naive-enumerator comparison — closed by the uploaded run

`brute.py` is an independent reimplementation of the configuration score, written from the Part 0 specification with no pruning, no seed, no precomputed part pool and no early exit, and with the opposite implementation choice taken wherever there was one (pairwise gcd rather than a shared factor set; fusion counts by trial division rather than a q-power ladder). Agreement is therefore evidence about the shipped enumerator's **pruning**, which re-running the enumerator cannot supply.

`brute.jsonl` holds **142 values, 0 mismatches**, every record agreeing with v4 — checked directly rather than taken from the run's own summary. Coverage is the contiguous sweep to n = 200 plus the targeted values that exercise the corrected shape space, which a sweep cannot reach at n^4.5 cost:

- **n = 143 → 1081**, the first S7-at-F≥3 winner (`3x32 + 1x47*`), where the block count 3 is a power of neither p = 2 nor q = 23;
- **n = 247 → 2525**, the first S4 winner, c = 73 ≡ 1 (mod 8);
- **n = 285**, the second S4 winner;
- **n = 308 → 4134**, the value that falsifies a q-power-only block count.

So the corrected code paths are confirmed by a program that knows nothing about them. **What this check cannot do** is worth stating alongside: it tests the pruning, because `brute.py` prunes nothing, and it is blind to any convention the two programs share — the SAFE `dmax` scoping is the live instance.

### R6. `check_doc_figures.py` whitelist upkeep — done

- **`CHECKPOINTS`** extended to 1306, 1428, 1540, 1572, 2000, 2007, 2212, 2298, 2376 and the current maximum, so a figure written against any past frontier reports as "correct for n ≤ C" rather than as unexplained.
- **`SCOPE`** gained five patterns: the floor stated as a table minimum in each of the phrasings actually used, the low-density-tail count, and the s-ladder value `s ≤ 1/√δ − 1 = X`. The last needed a new handler kind — it is arithmetic on the floor rather than a threshold, so it is recomputed and compared directly, and it goes stale the moment the floor moves whatever the surrounding theorem says.

### R8. The two mechanical checks — both built

**Reference resolution, as `check_doc_figures.py --pass refs`.** Collects anchors per document — markdown headings, appendices, Parts, the bolded run-in subsection headings this project uses, and bolded named results — then resolves every `§x.y` and every `Theorem/Lemma/Proposition/Corollary/Conjecture/Hypothesis N` citation against them.

Three refinements were needed before the output was worth reading, and each corresponds to a way the documents actually write:

- **Aliases and roles.** The documents cite each other as `` `aod` `` and as "§9 of the notes" as well as by filename; without those, aliased references all report as dangling, which trains the reader to ignore the pass.
- **Binding window.** A document name binds a following reference only within 40 characters, because "`aod.md` §6 … and §9 of these notes" is a real sentence shape and greedy binding mis-attributes the second.
- **Wrong-document versus non-existent.** A reference resolving to the wrong document is a different defect from one citing something that does not exist, and only the second is worth interrupting a read for. The first prints as `[elsewhere]` and is suppressed under `--quiet`.

Also: prime marks are normalised, so B′, B′ and B' are one lemma; and possessives are stripped, so "Theorem 2.3's inequality" cites Theorem 2.3.

**Result: 32 findings on the first useful run, then 0.** Thirty were the three classes above. Of the two genuine ones, one was a prime-mark mismatch and **one was a real dangling reference** — a pointer to §8.11 of the notes, a section excised to `small-degree-computation.md`, which no other pass could see. Fixed in place.

**The coefficient assertion, as a group-B check in `validate_table.py`.** Reports 981 fused classes, 491 where the F-keyed and q-keyed rules differ, and **the term binding at 0 of them** — which is the whole reason the check has to assert rather than measure.

**The first draft of this check was vacuous and the second says so.** Rescoring the table under the q-keyed rule and asking which reading `mu_bound` matches cannot fail while the term never binds: both readings give the same score, so no row discriminates. What is asserted instead is the coefficient the scorer computes, row by row, against the rule written out in the check — and to keep that from being a check that recomputes its own assumption, the expression was factored out of `score()` into `_cross_term(F, c)` so both call one definition. The rescoring is kept as a **tripwire** that acquires teeth the moment `binds` is nonzero, and the message states which state it is in rather than reporting a pass it did not earn. Negative control: breaking `_cross_term` turns the check FAIL, first offender n = 6.

### R5. The `fb_common.py` defects — done, and a third found while fixing them

Two were listed; a read of the file while applying them found a third of the same kind, and all three are the block count being enumerated over a narrower set than the corrected shape space admits.

- **`pair_candidates`' F loop ran over q-powers** (`F *= q`), and over F = 1 alone in the generic `q == '*'` branch. Under the corrected shape space F = F_mid · F_top with only F_top a q-power, so this is a restriction in the **anti-permissive** direction — the direction that silently discards a real candidate and turns an inconclusive n into a spurious proof. Now every integer F ≤ F_max. Enumerating F that the coprimality budget would reject is permissive, which is the required direction.
- **`multi_part_ok`'s `pcands` loop had the same ladder**, again collapsing to F = 1 at `q == '*'`. Now every integer F.
- **`single_part_ok` had it too**, and was not on the list. Its F list was the divisors of L at `q == '*'` but q-powers otherwise — the same restriction in the branch where it is least visible.

**A fourth finding, of the A13 class.** `pair_candidates` computed the within-class cross term as `(F if q == '*' or q % 2 else F // 2) * c * c` — the coefficient keyed on the top prime rather than on the parity of F. Here the q-keyed form is the *larger* of the two at odd q with even F, so it made the necessary condition easier to satisfy: permissive, hence sound, but wrong, and it would flip to anti-permissive if the expression were reused with the inequality the other way round. Now keyed on `F % 2`.

**Regression check: no verdict moves.** Running the old and new `pair_candidates` side by side over every (n, c, r) with n ≤ 2000 — **501,046 pairs** — gives **0 differences in whether the candidate list is empty**. So the certificates' conclusions are unchanged and the fixes are about the argument being sound rather than about a result being wrong. That is the expected outcome and not a reason to skip the fix: the gate that made the old restriction vacuous is `r ≥ B`, which holds at n = 6 alone today and loosens if B ever drops to O(n).

**The E.3(ii) docstring gap is closed.** It asserted the (r, r) re-reading's cyclic layer without justification. The step now appears: gcd(r − 1, c) = gcd(r − 1, 3), so what must be ruled out is 3 | r − 1, and that holds because r ≡ 1 (mod 3) would force 3 | 2r + 1 = c and kill the primality of c unless c = 3. The conclusion was always right; what was missing is that it does not follow from anything about safe primes on its own.

## Third batch: the GAP/CSP pipeline

### A10(a). `adversary.py` memo poisoning — fixed, and reproduced end-to-end

A child of `survive` returns `False` both when it genuinely fails to survive and when the node budget ran out underneath it, and the two are indistinguishable at the call site. The `out_of_budget` test sat *after* the `res = False; break`, so an exhausted subtree wrote `memo[key] = False` for a node nobody evaluated. The memo is pickled in the heartbeat and in the `finally`, then reloaded on the next run — which the docstring recommends. The failure mode is a spurious **NON-EVASIVE**: the counterexample-found verdict.

**Reproduced, on a property whose answer is known.** The perfect-matching down-closure at n = 6 is EVASIVE. Against the unpatched file:

```
$ adversary.py --demo matching --n 6 --budget 400     # exhausts, writes memo
$ adversary.py --demo matching --n 6 --budget 3000000 # resumes
  n=6 N=15: NON-EVASIVE: a decision tree of depth < C(n,2) exists
  nodes 1, canonical states 80
```

One node evaluated, and the root read straight out of a poisoned entry. So this was not a latent hazard — it fires on the first resume after any budget exhaustion, and it fires silently in the direction of a false counterexample.

**Three changes, and the third is the one that matters most.** The budget test now runs before the result is recorded, so no undecided node is ever written. The heartbeat's periodic pickle is kept, and is now sound for a stated reason: every entry is a decided value, so a partial file is a correct prefix rather than a poisoned one. And a run ending in BUDGET **does not write the memo file at all** — the invariant is restated where the file is written rather than trusted from a distance, because that is the step a future edit is most likely to break. The verdict string, which claimed "memo persisted", now says what actually happens.

Verified after: the same exhaust-then-resume sequence returns **EVASIVE**, 8,501 nodes, matching a clean single run exactly.

### A10(b). `ark_intersect.py`'s unsound `.top_primes` — fixed by renaming it

The value is read off the **twist** prime, which lives in the cyclic layer, so it is not a verified top prime for any Oliver chain. The two directions differ and only one is safe, which is now stated in the module docstring as the general rule for this file: **the useful answer is UNSAT, so the dangerous error is an unjustified constraint, not a missing one.** Dropping a condition turns a real UNSAT into a spurious SAT and loses a result; adding one nobody justified turns a real SAT into a spurious **proof of ARK**.

Returning a single q is therefore sound — a weaker modulus only admits more solutions. Taking an lcm over the set is not, and at the group the docstring itself names (AGL(1,5)[d=4] × F₇:C₃ at n = 12) q = 2 is valid while q = 3 appears not to be, so mod 6 would impose a constraint nothing justifies.

**The fix is to remove the attribute an lcm could be taken over.** The set is now exposed as `.twist_primes`, named for what it is, so there is nothing on this path an `lcm` may legitimately be applied to; callers wanting the strengthening must take it over `ark_gap.g`'s `+`-separated tag, where `IsOliverTop` has verified each q against an actual normal subgroup. A grep confirms nothing reads the old name today, so this is a latent hazard closed rather than a behaviour change.

### Two findings from a cold read of the newly available scripts

**`chi_test.py`'s `autorder` could silently corrupt S.** pynauty returns |Aut| as a (mantissa, exponent) pair with a float mantissa, and the product is rounded once. Every term of S is n!/|Aut|, and **S is the decisive quantity** — S ≠ 0 *is* the EVASIVE verdict — so an order off by one does not raise, it returns the wrong S. The orbit-counting identity supplies the check for free: |Aut| must divide n!, now asserted. At n = 10 the orders are all exactly representable, so this is hardening rather than a correction; the reason to add it is that the failure is silent and lands on the one number the script exists to compute.

**`compare_order.py`'s format asymmetry is deliberate and now says so.** The `rows` and `TU` branches test for completeness and the `order` branch does not, which reads like a missing check. A dense `order` key is only written on completion, so there is no partial state to detect — noted in place rather than left to be rediscovered.

### `probe_backbone.py`: the CAP rerun was a silent no-op

**This is the defect that made A11 unfixable rather than merely unfinished.** The resume set was built from every recorded `(class, pinned_value)` pair, CAP rows included — and a CAP row records "undetermined at whatever budget that run used", not a verdict. So the documented remedy, "rerun them with a larger `--nodecap`", skipped exactly the probes it was launched for and reprinted the same tally. The script's own closing advice could not be followed by running the script.

Three changes, and the second is what makes the first checkable:

- **A CAP row is skipped only when the budget it was taken at was at least the current one.** SAT and UNSAT are exact and never redone.
- **The budget is now recorded**, as a sixth column. It had to be: without it there is nothing to compare a new `--nodecap` against. Rows predating the column have no budget, so they are **retried rather than trusted** — the conservative direction, since the alternative is quoting a free band that was never established. Practical consequence for A11: the first rerun redoes all 54 CAP probes whatever budget it is given.
- **The summary reads the latest row per probe.** A retry appends rather than rewrites, so the tally would otherwise report the superseded verdict and undo the retry in the reporting.

Verified end-to-end on a synthetic four-class battery: at a larger `--nodecap` all three seeded CAP rows are retried and one resolves from CAP to OUT in the summary; at a smaller one the two recorded at the higher budget are skipped.

### `probe_backbone.py`: `cat.classify` was mutating the catalog mid-run

`classify` **appends** a new representative when it does not recognise a graph, and it was called in two places: once per probe on the empty graph, and once per class in the involution check. `V`, `order` and `edges` are all sized once at load, so a growing catalog puts a later index out of range for `order` or silently outside it. The involution check's trailing `assert len(cat.reps) == V` fires only after the loop that already mutated — and by then `comp_of` may hold indices past the matrix.

Confirmed live rather than reasoned about: `classify` on a graph absent from the catalog grows it, as expected. Both call sites now use a read-only certificate lookup that raises with the reason if the graph is missing, since every lookup in this script is of a graph that must already be present. The key function defers to the catalog's own notion of sameness where it exposes one, so the lookup cannot disagree with `classify` about what counts as the same class.

### `probe_backbone.py`: the lcm strengthening now announces itself

`parse_q` takes the lcm over the `+`-separated tag, and **that is legitimate here** — the tag comes from `ark_gap.g`'s `IsOliverTop`, which verifies each q against an actual normal subgroup witnessing a chain with that top prime. The contrast with the twist-prime path in `ark_intersect.py` is now stated at the site, because the two look identical and only one is sound.

Since the multi-prime case has reportedly never fired across 8,082 groups at n = 10 and n = 12, its first firing is either a new capability or a sign the tag is being produced by something other than `IsOliverTop`. It is now logged. That also gives A12b's retirement question a cheap answer: run the battery and see whether the line ever appears.

### A11 — the blocker is now data, not the tool

With the resume rule fixed, rerunning the 54 CAP classes at a larger `--nodecap` does what the runbook says it does. What is still missing is the n = 10 checkpoints and the probe record; the script is verified on a synthetic battery in the meantime.

Sequencing note: a `--nodecap` escalation is precisely a budget-limited run, and resuming its memo was the route to a spurious NON-EVASIVE, so the `adversary.py` fix had to come first. Any `adversary_memo.pkl` predating it must be deleted rather than resumed.

## Fourth batch: the n = 10 artefacts

### Every A11 claim the artefacts can settle, settled

Verified directly against `ckpt_catalog.pkl`, `ckpt_order.pkl`, `solution1.pkl` and `probe_results.csv`:

| claim | result |
|---|---|
| catalog size V | **1,242**, order matrix 1,242 rows |
| solution1 split | **214 IN / 1,028 OUT** |
| §9.7's "the skeleton contains 2K₅ and not K₅,₅" | **confirmed** — 2K₅ at catalog index 2 with x = 1, K₅,₅ at index 1 with x = 0 |
| catalog complement-closed, no self-complementary class | **confirmed** — 0 complements absent, 0 self-complementary |
| involution cross-check on the probe record | **30 confirmed pairs, 0 violations**, 15 forced classes whose complement is unprobed |
| monotonicity of solution1 against the order matrix | **0 violations** |
| probe record shape | **817 probes over 409 classes: 25 IN, 20 OUT, 310 free, 54 CAP** |

One incidental note for anyone reproducing this: the checkpoints pickle `ark_intersect.Catalog`, so unpickling needs `oliver_mu` importable even though nothing in it is used for the read. A two-function shim suffices.

### The free band, quantified — and the CAP tail is where the time went

The band is quoted as 11–34 from forced IN ending at 10 edges and forced OUT starting at 35. Resolving the CAP set by edge count says exactly how unestablished that is:

- **49 of the 54 CAP classes sit strictly inside 11–34** — the interior of the band is unknown, not free.
- **The remaining five sit at 9, 10, 10, 35 and 36** — on both boundaries. So the band's *edges* are not pinned either, and a boundary probe resolving the wrong way would move the band rather than merely fill it in.
- Exactly one pinning capped per CAP class (**0 classes had both capped**), so the rerun is 54 probes, not 108.

**The cost accounting is the useful part, because it explains the deferral.** The 817 probes took **32.8 h**, and the 54 CAP probes took **23.0 h** of that — **70% of the total spent on the probes that returned nothing**, median 1,180 s and worst 6,307 s, all at `--nodecap 5000000`. A rerun at 10× the budget plausibly costs 200+ h and is not bounded above by anything in the record, since a CAP is by definition a probe that had not finished.

That makes the free band a **scheduling question rather than an analysis question**, which is why it has moved from §2b to §1 as **R8**, to be run after the table rebuild. The cheaper first move is recorded there: the five boundary classes decide whether the band moves, and they can be probed alone via `--classes`.

## Fifth batch: the n = 12 artefacts, and the file reorganisation

### `small-degree-review.md` folded into `small-degree-verification.md` and retired

Two files describing one object is the drift risk this session has spent most of its time paying down — the A13–A16 findings were all cross-document duplicates going stale. The review's four corrections, three advances and one gap are now recorded **in the items they correct**, each labelled with the artefact it was checked against, and the review file is gone.

The verification file's header now says what it is: internal state-tracking, with `small-degree-computation.md` as the account meant to be read. It also carries its own **Runs outstanding** section, so small-degree runs no longer compete for space in `pending-checks.md` §1.

### `pending-checks.md` is now the arithmetic programme alone

A10, A11, A11b, A12 and A12b have moved out. What remains is a single pointer plus one line in the risk ranking, naming the sole point of contact: **exhaustiveness of the GAP stages**, which licenses Part I's two non-circular comparisons. Nothing else in the small-degree file gates anything in the arithmetic programme.

### Every n = 12 claim verified, and four counts pinned

Against the n = 12 `groups_out.txt`, `done_keys.txt`, `ark_gap.log` and `consume_gap.log`:

- **census 7,115 = 295 + 657 + 67 + 6,096**, p-groups splitting 6,004 / 88 / 2 / 2; by stage **A 194, B 969, B2 28, C 5,924**; all lines well formed with 66-entry maps;
- **max m\* = 18 over all 7,115 groups**, attained by **8 groups / 1 orbital partition / 3 (partition, prime) conditions** — the three quantities the surrounding documents kept conflating into "six ways" or "seven ways";
- **`B2:4x3:4.1` = T(4,4) ≀ T(3,1) is among the attainers**, which is the direct confirmation that (𝔽₄⋊C₃)≀C₃ attains the optimum rather than a consistency argument;
- **one attainer has tag `0`** — `A:166` = T(12,166), order 576, a trivial top. So the claim that the attainers sit at q = 2 and q = 3 was not just wrong but understated the result: a trivial top gives χ = 1 exactly, so the optimum is witnessed by the harshest condition available;
- **9,238 groups built and dropped** (16,353 keys against 7,115 emitted), 56% of what GAP constructed — the bound on what raising `MAXT` could add;
- **no multi-prime tag at either degree**, 0 of 7,115 at n = 12 and 0 of 967 at n = 10.

### The dedup count is hostage to the canonical form, and that is worth knowing

Reproducing the `--maxt` truncation table meant reimplementing `_orbital_canon`. Two natural attempts **reproduced the group counts exactly and the condition counts not at all**: a plain two-colour layering (points versus interchangeable orbital classes) gives 162 distinct conditions at `--maxt 8`, and colouring the class vertices by size alone gives 186, against the shipped key's **230**. Only the shipped form — class vertices coloured by (size, degree-profile) — reproduces the log.

So a 30% swing sits in a detail of the key, in the same direction as `consume_gap.py`'s own note about an earlier attempt over-splitting sevenfold. **The count should never be quoted without naming the form that produced it.** With the right form the table is:

| `--maxt` | 4 | 5 | 6 | 7 | **8** | 10 | **12** |
|---|---|---|---|---|---|---|---|
| distinct conditions | 36 | 73 | **125** | 169 | **230** | 339 | **425** |

`--maxgroups 200` drops 3 conditions; **`--maxt 8` drops 195**. The honest reading of the `--maxt 6` lever is "we use 54% of the available conditions today; that would use 29%".

### The n = 10 dedup audit closes item 7, and it changes what the n = 10 SAT means

With the n = 10 `groups_out.txt` finally in hand (967 lines, 45-entry maps — the file collision is now flagged in the artefacts item, since each upload has overwritten the other), the audit runs in seconds against the shipped `_orbital_canon`.

**Distinct (partition, prime) conditions at n = 10:** 123 at `--maxt 8`, **167 at `--maxt 10`**, 189 over the whole file. The published runs kept **57** and **75**. So the old invariant key merged the Oliver side roughly three to one — **40 kept where 125 exist** — and the n = 10 CSP was solved on **45% of the available conditions**.

Sorting out what that touches was the useful part:

- **μ(10) = 20 is unaffected**, because it is read off the group file rather than the battery: max m\* is 20 over the 268 Oliver groups and over all 967. The same holds for μ(12) = 18. So the arithmetic programme's two non-circular comparisons are untouched, and that is now said explicitly at the top of the file.
- **The SAT is weakened in the direction that matters.** Fewer conditions is an easier system, so a positive verdict does not transfer upward. "The CSP is satisfiable at n = 10" should read "satisfiable on the 75-condition battery" wherever it appears.
- **The χ kill is unaffected**, since `chi_test.py` evaluates one property's down-closure and never consults the battery. Which is a reason to weight it more heavily than the SAT: it is the one result the truncation cannot reach.

That makes rerunning the n = 10 CSP on the full battery the cheapest of the three outstanding runs and the only one whose outcome could settle a degree outright — added to Runs outstanding ahead of the n = 12 work.

**And the same three-quantity confusion resolves at n = 10 as at n = 12:** m\* = 20 is attained by **8 groups** (`A:17`–`A:20`, `A:27`, `A:28`, `A:33`, and `B2:5x2:3.1` = T(5,3)≀T(2,1)), all with orbital sizes [20, 25], forming **1 partition** and **2 conditions**. The wreath is among them, so AGL(1,5)≀C₂ is confirmed rather than assumed, and `A:18` carries tag `0` — a trivial top, χ = 1 exactly. Census: 967 = 95 + 159 + 14 + 699, stages A 24 / B 319 / B2 6 / C 618.

## Sixth batch: R2's `--no-theorems`

### The flag, and where it lives

`fb_common` gained a module-level `USE_THEOREMS` with a `set_use_theorems` setter — a setter rather than a bare global because a caller doing `from fb_common import USE_THEOREMS` would otherwise bind a stale copy. With it off, `branch_settled` returns False for every s and `e3ii_resolves` returns False, so nothing is dispatched and no Part E′ clause is consulted. `wide_cert.py --no-theorems` wires it up, keys its pass-1 cache on the mode (B_lo does not depend on the theorems, but keying anyway costs one recompute and removes the question), and rewrites its closing paragraph to say which mode actually ran instead of asserting a result from a previous session.

`fallback_cert.py` is not in the working set, so its flag is one line still to add against the same setter.

**Switch verified live by direct call**, not just by the runs agreeing: with theorems on, 2 of 5 s-branches dispatch at a sample n (E.1 at s = 1, E.4 at s = 3) and `e3ii_resolves` returns True; with them off, 0 and False.

### Runs at NMAX = 3,000 and 10,000 — and why their agreement proves nothing

Both modes: **0 unresolved of 2,533** at NMAX = 3,000 and **0 of 8,719** at 10,000, 100% certified, identical pass-2 counts.

The identical counts were the tell. If the dispatch were settling anything, disabling it would push those branches into the search and the check count would rise. It did not move, so I instrumented it: **at both ranges the dispatch settles nothing.** Every live `(pair, n)` has s = 2 (4,539 at NMAX = 10⁴) or s = 4 (7), and the s = 1 and s = 3 branches that E.1 and E.4 cover never reach the dispatch — the foreign-cap filter (`hi == 0`) removes them first, since a small foreign block's own cap falls below every B_lo in the list.

So **the two modes agree trivially at these ranges, and the run is no evidence whatever about E.1 / E.3 / E.4.** That is a trap worth closing in code rather than in a note, so pass 2 now reports live checks by s beside how many the theorems settled, and prints an explicit warning when the dispatch fired zero times.

Two consequences worth carrying forward. Whether the dispatch ever fires at 10⁶ is now a specific question — and if it never does, the standing claim that the Part E′ theorems are "commentary over the certified range" is true of `wide_cert.py` for a duller reason than intended: not that the search independently clears the branches they dispatch, but that those branches never arrive. The real test of those theorems is `fallback_cert.py` against the true table, where B is larger and the foreign-cap filter is less aggressive.

### R2 closed: `fallback_cert.py --no-theorems`, and here the check is not vacuous

Same switch, wired to `fb.set_use_theorems`, plus an internal assertion that no branch is dispatched when the flag is set — cheap, and it catches a future refactor that reintroduces a theorem call bypassing the switch.

**Against v4 (1,666 values to n = 2000):**

| | normal | `--no-theorems` |
|---|---|---|
| candidates surviving | **0** | **0** |
| values fully settled by theorem | 1,419 / 1,666 (85.2%) | 0 |
| s-branches dispatched | **1,673 / 1,920 (87.1%)** | 0 |
| theorem-side residue | 247 branches, all E.3(ii) pairwise-only | — |
| largest permitted s | 3 | 3 |

**This is the run where `--no-theorems` carries weight**, and the contrast with `wide_cert.py` is the point. There the dispatch settles nothing at NMAX ≤ 10⁴, so the two modes agree trivially. Here 1,673 branches really are dispatched in the normal run, so switching them off genuinely moves work into the search — and the candidate list is still empty. E.1, E.3(ii), E.3(iii), E.4, Lemma E.2's bound and the `MERSENNE` / `REPUNIT3` tables are therefore commentary for the per-n proof, established rather than asserted.

**The recount R4 wanted falls out of the same run**, and the v2-era figures in `enumeration-proof.md` are now updated: 1,419 of 1,666 settled (was 1,503 of 2,008), 1,673 of 1,920 branches (was 2,062 of 2,572), and the residue is **one class of 247 branches** rather than 505 plus an s = 4 and an s = 5 branch. The s ≥ 4 branches are gone because **the largest permitted s over v4 is 3** — the corrected shape space lifted the density floor enough to close them, which is the reversal `arithmetic-of-density.md` §7 predicted might happen.

### R4 folded into R1, and R1's command list rebuilt

**R4 was a duplicate.** Its three commands were a strict subset of R1's; what was not duplicated was the *reading* — that the density floor, the largest permitted s and the theorem residue move together, and that s = 4 is the first branch with no theorem. That belongs beside the command that prints those three numbers, not in a separate item, so it is now the `fallback_cert.py` bullet in R1 and R4 is gone. The trigger survives verbatim: if `largest permitted s` ever prints 4, the theorem-side coverage has a hole.

**Four fixes to R1's list, checked against the scripts as they stand rather than as they were.**

- **`wide_cert.py` could not run as written.** Its default `MU_ENUMERATE` is `mu_enumerate.py`, which no longer exists, so the import fails on load — verified by running it both ways. The list now carries `MU_ENUMERATE=$PWD/mu_enumerate_v2.py`.
- **`s7_scan.py` and `mu_fast.py` do not exist**, and both were in the list. Rather than leave them as plausible-looking commands, they are named as absent, with the note that `validate_table.py` group B already covers the congruence patterns `s7_scan.py` was for — so nothing is owed unless a new check is wanted.
- **`ladder_verify.py` was in the wrong item.** It never reads the table; it scores explicit families, so it is not a per-batch check at all. Moved out to R7, which runs on its own schedule.
- **The order is now the list**, rather than a note after it saying which to run first. `validate_table.py` gates the rest, so it sits second, immediately after the run that produced the batch.

Each entry also says what to read off the output, since several of these scripts print a headline that is not the interesting part — the `fallback_cert.py` floor/s/residue triple, and `wide_cert.py`'s `settled by theorem:` line, which prints NONE at NMAX ≤ 10⁴ and makes a `--no-theorems` comparison there worthless.

Also corrected in the same pass: R0's command used `scripts/` and `outputs/` prefixes the rest of the file does not, and omitted `--fill-gaps` — which matters, because plain resume continues after the *last* row and never fills holes a targeted run left.

## Seventh batch: four checks added to `validate_table.py`

Run against v4 (1,666 rows to n = 2000): **every check passes**, group A and B clean, exit 0 — matching what the periodic runs have been reporting. What was missing was coverage of claims added since the shape-space correction, so four checks are new, each with a negative control confirming that breaking it makes the check FAIL.

**1. The cyclic layer's global pairwise-coprimality condition.** *This is the one with no earlier counterpart and the one that matters most.* The corrected shape space splits a block count as F = F_mid·F_top with F_mid coming from the cyclic layer — one shared generator — so every F_mid and every foreign block size must be pairwise coprime across the whole configuration. Nothing tested it. And the direction is worth naming: every other check guards against the enumerator being too *restrictive*, whereas a violation here would mean it has **over-corrected**, admitting a configuration no Oliver group realises, which inflates B and breaks the upper bound. Passes at 0 of 319 winners carrying two or more cyclic-layer orders. (Twists are deliberately out of scope: SAFE scores at F·orb(c, dmax) with dmax already stripped of F_mid, so the witness string does not record which twist was used and there is nothing to test against.)

**2. The feasibility criterion Σ√Fᵢ ≤ 1/√δ.** `aod` §6.1's shape counts are derived from it, so a violation would invalidate the covering statement's arithmetic rather than a single row. 0 of 1,666.

**3. Part G.4's per-axis bounds**, cᵢ ≥ δn and Fᵢ ≤ 1/δ. These bound the enumeration's cost, so a violation would mean the cost model is wrong and not just the prose. 0 violations on both axes.

**4. The within-class cross coefficient** (added in an earlier batch, noted here for completeness) — invisible to output, since the term never binds.

### One scoping correction, and one structural finding

**The unequal-matching-sizes check was asserting something the documents deny.** It flagged any winner with two matching classes of different sizes, but at p = 2 that configuration is *admissible* and the counterexample is in the documents: n = 551 = 256 + 167\* + 128 has c − 1 = 255 and c′ − 1 = 127 both odd and coprime, so both twists are full and the cyclic layer is genuinely cyclic. A FAIL there would have contradicted `aod` §6.5's second escape. The check is now scoped to **odd p**, which is what Open Problem 1 actually leaves open, and p = 2 instances are counted and reported as INFO — worth knowing about, not a failure.

**The three tight instances coincide, and that is structural.** The tightest row for the feasibility criterion (slack 0.0004), for cᵢ ≥ δn (ratio 1.001) and for Fᵢ ≤ 1/δ (1.001) is the same one: **n = 1994 = `2x997`**. Not a coincidence — a single fused class n = F·c has δ = (c−1)/(Fc−1), so c = δn, F = 1/δ and Σ√Fᵢ = 1/√δ all hold to O(1/n) simultaneously. **The three bounds are one bound read on three axes**, which is why no amount of tightening one of them will move the others. Recorded in Part I, where the old tight row (n = 575, `23x25`, tight within one unit on both G.4 axes) is kept alongside as the v2-era instance.

## Eighth batch: dehistoricization of `pending-checks.md`, and a speed constraint on `validate_table.py`

**Dehistoricization.** Fourteen sites in `pending-checks.md` described how something came to be rather than what is true now — "two were false and shipped", "the conditions have had exactly one read, which found two defects", "three consecutive extensions each left a different subset behind", "the residue is 247 branches, not the 505 of the v2 figures". Each is rewritten as a live statement. Where the history carried a real warning it survives as one: T1 now opens with **"a step compressed to a clause tends not to survive being written out"** and lists the four steps as they currently stand rather than as a chronicle of failures; T3 states that **the direction to fear is permissive** rather than recounting which corrections went which way.

**A speed constraint, stated in both places.** The suite runs in ~0.1 s on 1,700 rows, and that is what makes it something to run reflexively — before every certificate, after every batch, on a hunch — rather than a job to schedule. **A check that costs seconds gets skipped, and a skipped check is worth nothing**, so the budget is a design constraint and is now recorded as one in the module docstring and in A0b.

The rule: every check stays **O(rows) or O(rows × parts)**, doing arithmetic on numbers already parsed out of the witness string. Explicitly out of scope: enumerating configurations, VF2 or isomorphism work, re-deriving B(n), sieving past NMAX, or anything whose cost grows with n rather than with the row count — all of which belong to `brute_compare.py` and the certificates.

**The case that will tempt is named**, since it is the one a future check will hit: a check that wants to compare a row against *alternative configurations* rather than against a formula. That is a certificate's job; if it has to live here, budget it against the 0.1 s and say so at the check, so the next reader knows what is being protected. Measured for reference: CSV parsing alone is 0.025 s, so about a quarter of the total is unavoidable I/O and the 20 checks together cost roughly 0.2 s.

## Ninth batch: A2 and A9 closed, T1–T5 dug into

*A review pass by a second reader over the two open §2b items and the five human items, with the code and document changes it produced.*

### A2 — closed. The leftover twist cap, and E″ at 90,299 of 90,299

**The two values E″ could not settle below 10⁵ were one shape, not two accidents.** n = 50,817 has (c, r, L) = (20327, 10163, 20327) and n = 89,697 has (35879, 17939, 35879): both are n = 5r + 2 with c = 2r + 1 and **leftover exactly c**. So the empirical half of A2's second question was already answered — L = c was the only obstructed leftover in range.

**The mechanism question resolves into a lemma, and the lemma is about twists rather than sizes.**

> **Lemma (leftover twist cap).** In any admissible configuration containing a foreign block of prime size r, every p-characteristic class of F blocks of size c has minimum intra-orbital at most F·orb(c, d), where d = qpart(c−1, q) times the largest divisor of the remainder coprime to r and to F_mid.
>
> *Proof.* The twist has order coprime to p, so it embeds in (cyclic layer) × (top q-group). The cyclic layer already carries the foreign block's translations C_r — Lemma B′ puts them there — and the block rotation C_{F_mid}, and one cyclic group forces pairwise-coprime orders. So the non-q part of the twist is coprime to r and to F_mid, and only the q-part can lie in the top layer. ∎

Every ingredient is an already-proven necessary condition: this is the SAFE `dmax` reasoning applied to a branch that was not using it, which is exactly the "stripping all F_mid values would be a free tightening" that the SAFE scoping note predicted. **At L = c with c − 1 = 2r the shape dies twice over** — the r is stripped by coprimality and, for the odd q that survive the foreign gate, the q-part is 1, leaving d | 2 and an intra term of orb(c, 2) = c ≪ B; the q = 2 reading dies earlier at orb(r, 2) = r < B. The q-pinning corollary A2 asked about falls out the same way: a foreign leftover of size c needs q | c − 1 = 2r, forcing q = 2, dead at the same gate.

**Implementation, and the F = 2 surprise.** Tightening `single_part_ok` alone exposed a second reading: with L = c dead at F = 1, the loop advances to **F = 2 with leftover 0**, which passes the permissive gates. The same lemma applied to the *main* class kills it — at odd q, F_mid = 2 strips the 2 and the foreign r strips the r, so dmax = 1. So condition (4) now reads F·orb(c, dmax) rather than F·C(c,2) throughout `pair_candidates`, with matching caps in `single_part_ok` and `multi_part_ok`.

**Evidence.**

| check | result |
|---|---|
| old-vs-new over all (n, c, r), n ≤ 2000 | 501,046 pairs; **0 candidates gained** (the unsound direction), 0 verdicts changed |
| `fallback_cert.py` v4, both modes | identical: 0 candidates, 1,673/1,920 dispatched, 247-branch residue, s ≤ 3 |
| `wide_cert.py` 10⁵, both modes | **0 unresolved of 90,299** |

One honesty note carried into the documents: at 10⁵ the theorem dispatch settles nothing (every live pair has s ∈ {2, 4, 6}), so that 100% is automatically theorem-free and the mode comparison there is vacuous. The comparison that carries weight remains `fallback_cert.py`'s.

**What is left of A2 is only the *global* promotion of E.3(ii) to a theorem over all n**, which was never A2's ask. The item is removed; the "all but two values" figures are updated in five places.

### A9 — closed, and the stated dichotomy was wrong

**The premise fails against Part E.** A9 assumed distinct p-characteristic classes need pairwise-coprime twists, so that at odd p — where both twists are even — at most one could keep its 2-part. **They need no such thing.** Part E's construction carries every p-characteristic twist on **one diagonal generator of the cyclic layer**, whose image in each class is that class's full twist; only the generator's total order must be coprime to the foreign primes and the F_mid values. So the p = 2 versus odd-p asymmetry does not exist, and even the n = 551 framing — "works because 255 and 127 are coprime" — cites a condition that was never required. The documents disagreed with themselves here, between §6.2 and Part E, and Part E is right.

**What actually governs the shape is a density ceiling.** For the unfused two-class case, c′ ≤ c/p and c + c′ ≤ n give c′ ≤ n/(p+1), and the configuration's minimum is at most C(c′,2), so

> **δ ≤ (c′/n)² ≤ 1/(p+1)²** — 1/9 at p = 2, **1/16 at p = 3**, 1/36 at p ≥ 5.

Unequal-size shapes are therefore *infeasible* above 1/9 at any p, and above 1/16 unless p = 2. Only p = 3 can compete anywhere near the floor. **Measured over v4:** 654 of 1,666 values admit an unequal odd-p configuration at full diagonal twist, **none wins, none comes within 10% of B(n)**, best ratio 0.236·B at n = 1007.

So the one-size presupposition of §6.2 is **false but harmless**: unequal-size shapes exist at every p and are escapes rather than competitors, exactly like the fusion shapes and the c = 2^a family. Consequences written into §6.2 — the one-size counts are exact above δ₀ = 1/9, the partition factor applies only below, and the "penalised" column's justification is now the ceiling rather than a twist-parity argument. **The single standing check is p = 3 against the δ ≤ 1/16 tail**, folded into that section rather than left as an item. A9 is removed.

### T1 — Parts A, E, F read; one substantive finding

**Part A: sound.** The decomposition m\* ≤ min(minᵢ Mᵢ, min sᵢsⱼ) is correct with both terms needed, the identification of Γ's pair-orbits in Oᵢ with those of Γ|₍Oᵢ₎ holds, and the fixed-point domination clause is consistent with the n = 6 gate elsewhere.

**Part E: the coefficient's "upper bound by divisibility" is false as stated, and it happens not to matter.** Part E claimed the minimum pair-orbital of a transitive group of degree F is ≤ F (odd F) or F/2 (even) "by divisibility: for a transitive group of prime-power degree ℓᵃ every orbital has ℓ-power size". The parenthetical is false for general transitive groups — S₄ on 4 points has a pair-orbital of size 6 — and the admissible block-permuters are not all ℓ-groups, since F = F_mid·F_top need not be a prime power. **Witness: AGL(1,5) = C₅⋊C₄**, cyclic part in the middle layer and 2-group on top, is 2-transitive on 5 blocks, so its only within-class cross orbital has size 10c² against the coefficient's 5c².

Nothing breaks, and the reason is worth having explicitly: **coeff·c² ≥ F·C(c,2) ≥ F·orb(c, dmax) always**, so the cross term can never be the binding reason a score under-counts a group — the intra cap binds first — and μ ≤ B_safe survives untouched. B_refined and the constructions are unaffected, the regular C_F action attaining the coefficient exactly. The fix is scoping, applied in Part E and in §9.7's orbital count: both describe **the constructed family**, not every Oliver group.

**Part F: arithmetic verified, one wobble.** F.1's proof and the self-certification argument are clean, F.3 and the s-versus-k box are correct, and the new n = 1994 triple-saturation datum is consistent with "F.1 is tight". F.2's chain `sᵢ² ≥ Fᵢ(2m* + sᵢ) ≥ 4m*` silently discards the Fᵢsᵢ term; the inequality holds, and the step is now written out.

**Also found: two stale banners.** Part A's headnote and Part E's opening both still carried pre-repair framing, Part E literally opening "the completeness half of this Part is false as it stands" — which contradicted the corrected Part 0 and the header's sandwich. Both rewritten to state what each half rests on.

### T3 — necessity read of all eight conditions, written into the file

Verdicts: **(1)** definitional for the branch. **(2)** necessary — B′ forces the foreign twist into the top layer, so it is a q-power dividing r − 1; trivial twist is the '\*' branch, gated on r ≥ B. **(3)** necessary, twist divides the q-part and orb is monotone. **(4)** necessary by the leftover twist cap above — this is the condition A2's work produced, and the load-bearing one. **(5)** necessary by counting. **(6)** **not independently necessary** — the AGL(1,5) finding above — but implied by (4), since coeff·c² ≥ F·C(c,2), so it can never wrongly exclude; reclassified in the header as a tripwire with an explicit instruction not to promote it. **(7)** necessary by counting on each leftover part. **(8)** necessary per part, with the subset-sum reachability over-approximating. `e3ii_resolves` is correctly a domination rather than a necessity and sits behind the theorem switch.

**Net: seven necessities sound, one redundant-but-harmless, one repair produced.** All eight arguments are now recorded in `fb_common.py`'s header, so the outstanding human read is scrutiny of those arguments rather than reconstruction of them.

### T4 — the transfer question closes, in our favour and trivially

The worry inverts. **The largest prime-power divisor of r − 1 is at least the largest prime divisor**, so if a prime q ≥ r^θ divides r − 1 then the q-part of r − 1 is at least q ≥ r^θ. Every unconditional shifted-prime result therefore imports **verbatim** as a lower bound on this framework's quantity — Goldfeld / Motohashi / Hooley-type θ ≈ 0.6–0.677, the 0.679 refinement, and the density results of the form lim inf |{p ≤ x : P(p−1) ≥ p^c}|/π(x) ≥ 1 − c for c ≤ 1/2 with their subsequent improvements — with no transfer of proof and no loss. §3.6's caveat is replaced by the domination, and "(H) is the θ = 1 endpoint" needs no qualification.

**The converse does not hold**, and §3.6 now says so: an upper bound on P(r − 1) gives no upper bound on our η, so the ladder's *ceiling* arguments and the level-of-distribution barrier are about the literature's quantity and not automatically about ours.

The Angel–Borja CSP validation question is left as a judgement with a recommendation against, on the ground that the n = 10 and n = 12 exhaustive batteries already validate the machinery more strongly than any single external instance.

### T2 and T5 — recommendations on the record

**T2:** verify *preconditions* per-n in `validate_table.py` (diagonal carrier coprime to foreigns and F_mids, each foreign r with its q-part twist, F_top a q-power) and leave group construction as an occasional GAP spot-check. J0a — the stabiliser assumption — is the one thing no precondition check reaches and stays a human item.

**T5:** fence rather than close. The a > 1 exposure is asserted per row by `validate_table.py` at 0 of 1,677 parts on every extension, the Galois obstruction makes a proof hard, and the payoff is a case the data says never binds. Trigger for reopening: the tripwire firing, not a review cycle.

## Tenth batch: T2's preconditions check, built and measured

**Built as a group-A check**, not group B, and the placement is the argument: a failure here would mean a scored row whose Part E group cannot be built as described — a gap in *attainment*, not a contradiction with the documents, so "investigate before trusting the row" is the right reading. Three preconditions, all decidable from the witness string alone, which is what keeps it O(rows):

| sub-check | what it asserts | status over v4 |
|---|---|---|
| **(a)** F_top a q-power, F_mid coprime to q | the top layer is a q-group, so the block count's top part must be a q-power | 0 violations — **tripwire only** |
| **(b)** a foreign block scored above r has q \| r − 1 | Lemma B′ forces its twist into the top q-group, so it is worth more than its own size only if q divides r − 1 | 0 violations, **live at 1,034 rows** |
| **(c)** the diagonal carrier exists | Part E carries every p-characteristic twist on one cyclic-layer generator, so its order must be coprime to every foreign prime **and every F_mid in the configuration** | 0 violations, **live at 1,239 rows** |

**(c) is deliberately stricter than SAFE's `dmax`**, which strips only a class's own F_mid. That is the point rather than an inconsistency: looseness is safe for an upper bound and is why SAFE stays independent of Lemma C, but the *construction* has no such licence, and attainment needs the construction. The check tests what Part E claims, not what SAFE assumes.

**Honest about (a).** It is vacuous by construction — F_top is computed as `qpart(F, q)`, so F_mid is coprime to q identically, and the sub-check can only fire if the witness parser or `qpart` is broken. Kept, because that is a real failure mode and costs one modulo, but labelled a tripwire in the output so a PASS on (a) is not read as evidence about the table. **A precondition check that is vacuous is worse than none — it reads as reassurance** — which is why (b) and (c) print their live counts beside their violation counts.

**Negative controls: all three sub-checks fire when broken.** (b) and (c) were also confirmed non-vacuous by counting live rows independently of the check itself.

**Speed: within budget, no measurable cost.** The suite runs at 0.165–0.192 s on 1,666 rows against 0.20–0.22 s before the check was added — i.e. the addition is lost in run-to-run variance on this container, which is what O(rows) with parts ≤ 3 predicts. The per-row work is a handful of gcds and one lcm, no allocation beyond a three-element list. **Nothing here needs the 0.1 s exemption clause.**

What this does **not** reach is J0a: the witness records a twist *order*, not the group the twist lives in, so no precondition check can test whether the stabiliser is of ΓL(1) type. T2 is reworded to that residue plus the priorities call about occasional GAP spot-checks at the shapes with the least construction evidence (S4 and S7-at-F≥3).

## Eleventh batch: the 10⁶ ladder run reviewed

*`ladder_weak_v4.txt` (19,583 entries) and `ladder_verify_1e6_output_v4.log`, 5,161 s to 10⁶.*

### What the run confirms

- **The worklist halved, as predicted.** 19,583 entries against the previous 41,584 — a ratio of 0.471, so "expect roughly half" was right. Against the 48,729 the branch-and-bound actually consumed, it is 60% smaller.
- **The global floor is unchanged: δ ≥ 0.02516 at n = 8927, n ≡ 23 (mod 24).** So the S7 over-credit fix and the two fused rungs moved the worklist without moving the extremum, which is the outcome that leaves §5's figures intact.
- **Zero values below 0.02 across all 10⁶.** §5's finite conjecture holds throughout the range, unconditionally, over the four families.
- **The ladder never exceeds the table.** Over the 7 worklist entries that have a v4 row, the table is strictly better at 6 and ties at 1 — never worse. So the log's warning that the script "now reports a larger value than the table" is v3-era and no longer describes the pair; it has been removed from the script.

### Two structural findings the run makes visible

**The worklist is one residue class, and that is the mod-24 prediction landing hard.** Of 19,583 entries, **19,568 (99.92%) have n ≡ 23 (mod 24)**, with 14 at n ≡ 11 and exactly one at n ≡ 17. That is close to forced — the threshold 0.050510 *is* class 23's ceiling, so any other class appears only by falling well short of its own, higher cap. Which makes **the 15 non-23 entries the informative ones**: class 11 has cap 0.06699 and class 17 has 0.10102, so those are values where the families underperform their class by 30% or more, and they are the cheapest place to look for a family the ladder is missing. Recorded in §5.2.

**The per-residue diagnostic saturates early, so a wider scan does not test it further.** All 24 per-class minima are attained below n ≈ 12,000 — the largest being n ≡ 11 at 11,819 and n ≡ 23 at 8,927 — which is why the min-ratio spread (0.327 at n ≡ 16 to 0.653 at n ≡ 20) is *identical* at N = 20,000 and at N = 10⁶. The spread was being quoted as a live diagnostic; it is a statement about small n and will not move. Also recorded in §5.2.

### Figures updated

The decade table appears twice in `arithmetic-of-density.md` (§5.1 and §5.2) and both were keyed to the 41,584-entry list. Recomputed from the new file:

| n | entries | min bound | at |
|---|---|---|---|
| [10², 10³) | 2 | **0.04181** (was 0.03649) | **575** (was 935) |
| [10³, 10⁴) | **82** (was 158) | 0.02516 | 8927 |
| [10⁴, 10⁵) | **1,334** (was 2,987) | 0.03045 | 11819 |
| [10⁵, 10⁶) | **18,165** (was 38,437) | 0.04125 | 134423 |

The [10², 10³) row moving from 935 to 575 is the fused rungs doing their job — 935 was weak only because the old model missed a family there.

**And the tail below the floor is now thin enough to change the question.** Exactly one worklist entry sits below 0.026117 (n = 8927 itself), one below 0.030, 11 below 0.037524, and 21 below 1/25. So the branch-and-bound has almost nothing left to eliminate, and §5.1's operative question is no longer "does some other n undercut 8927" but **"does B(8927) exceed 0.02516"**. Rewritten that way.

### Script fixes

- **The stale S7 note is gone**, replaced by a statement of what the list *is*: lower bounds, so an entry below a threshold does not mean δ(n) is below it — read it as the set of n worth computing B(n) at, ranked.
- **The output filename is no longer hardwired.** `ladder_verify.py` honours `LADDER_OUT`, because each run's worklist is the evidence for figures in §3.7 and §5.2 and comparing two runs is the point of rerunning. Verified on a short run.

### R7 rewritten from "do the run" to "consume the worklist", as ONE job

The run is done and needs nothing further. What replaces it is the branch-and-bound — and the right form is a **single adaptive job writing into `mu_table_safe_v4.csv`**, not a tier-per-`--nlist` run into side files. `mu_enumerate_v2.py --floor … --adaptive` is built for exactly this:

- it **prunes on the worklist's own second column** (LB(n) ≥ floor proves δ(n) ≥ floor), which disposes of 19,562 of 19,583 entries for free at `--floor 0.0400`;
- it **rejects most survivors without computing B(n)**, seeding the search at floor·C(n,2) so it need only show *some* configuration clears the floor — verified on the first 40 entries, where n = 1175 is rejected at K = 2 and δ(1175) > 0.04 is established with no exact value computed;
- it **appends the exact row, full schema and witness, to `--out`** when it does compute one, so expensive values land in the same CSV instead of a side file needing a merge; append-only, never rewriting or reordering, skipping n already present;
- it **reads `--out` back as prior knowledge**, so v4's existing 1,666 rows tighten the floor rather than being ignored.

**The floor is the question, not the answer** — the one trap here. Setting `--floor` to the current global floor 0.02516 would prune *everything*, 8927 included, because pruning fires at LB ≥ floor and 8927's LB equals it. So the ladder is: 0.0400 asks whether any n leaves room for **s = 4** (21 entries survive pruning), 0.045742 asks whether anything undercuts the table floor (189), and 0.02516 + ε asks the one question §5.1 now turns on, namely whether **B(8927) > 0.02516** (1). Cheapest first, since the cheap run may answer the expensive one's question.

Two cautions recorded with it. `--refined` with `--floor` is refused by the script, and the reason belongs in the item: adaptive mode appends to `--out`, the schema records no mode, so a refined row in an unconditional table would be undetectable and would corrupt every downstream figure. And the job is a table extension, so **R1 gets rerun afterwards** like any other batch.
## Twelfth batch: `literature-findings.md` reference convention, and the refs pass extended to it

**The problem was worse than sloppy prose.** That file cites three of our documents and several other people's papers in identical `§n.m` notation, and the collision is not hypothetical: **§5.1 is both BBKN's construction section and `aod`'s branch-and-bound section**, and in item 1 they appear a few lines apart. The refs pass had been told to skip the file entirely, on the ground that it "cites outward" — true of the external references and false of the rest, so nothing checked the internal ones at all.

**Convention, now stated at the top of the file and applied throughout:** every reference to one of our documents carries an explicit prefix — `` `aod` §3.3 ``, `` `notes` §9.7 ``, `` `ep` Part E `` — and a bare section number belongs to whichever paper the sentence names. Forty-three references were prefixed across all four passes of the file. The mapping itself is worth recording because it is not guessable: §§3–6 are `arithmetic-of-density.md`, §§8–9 and §2.4 are `orbital-evasiveness-notes.md`, lettered Parts are `enumeration-proof.md`.

**`check_doc_figures.py --pass refs` now covers the file in a prefixed-only mode.** `ALIAS` gained `notes` and `ep` alongside the existing `aod`, and a new `PREFIXED_ONLY` list puts `literature-findings.md` in a third category between "check everything" and "skip": prefixed references are resolved as usual, bare ones are skipped as belonging to cited papers. The pass announces which mode it is in, so a reader of the output is not left thinking the file was fully checked.

**What this can and cannot catch, stated at the site because the limitation is permanent:** a mistyped reference to our own work is caught; a mistyped reference to someone else's is not, and cannot be — we have no anchor list for BBKN or Shparlinski. That asymmetry is the reason the convention exists rather than a defect in it.

Verified both ways: the file passes clean, and corrupting one `aod` and one `notes` reference produces exactly two DANGLING reports naming the right target documents.

## Thirteenth batch: the three literature edits

**Two decisions dropped, not deferred.** Running the CSP against Angel–Borja's surviving types and chasing the two-orbital criterion are both off the list: the exhaustive n = 10 and n = 12 batteries already validate the machinery more strongly than either would, so the marginal value does not justify the run.

**Edit 3 — `aod` §5, δ versus c(n), at both sites.** §5's opening now carries the full chain of unconditional query lower bounds (Rivest–Vuillemin n²/16 → Kleitman–Kwiatkowski n²/9 → KSS n²/4 → Korneffel–Triesch → Scheidweiler–Triesch n²/3 − o(n²)) and states why our 0.026117 ≈ 0.013n² is **incomparable rather than losing**: δ measures *which properties* the method reaches exactly, c(n) measures *how many queries* are forced for all of them. A weak bound on all properties against full evasiveness on a restricted class. The second site found by grepping — `notes` OP8's "how much of the range is in play" paragraph, which quoted the same constant bare — now carries a one-line pointer.

**Edit 4 — `aod` §3.6, two attribution columns.** The ladder table gained **"who proved / conjectured it"** and **"who connected it to this framework"**, because those come apart and the second is what a reader needs. The arithmetic inputs are nobody's novelty; what varies is who noticed this framework consumes them. BBKN supply the Chowla and ERH rungs; Shparlinski isolates the max-min as a named function and supplies the unconditional 1/4 rung (Thm 1) and the almost-all 0.677 rung (Cor. 3); **ours are the 0.679 update, the observation that the picture is one parameter θ, and the identification of (H) as its θ = 1 endpoint.** A fifth row was added for the ERH rung with a trap flagged: it is still quoted as the state of the art for all large n and is not, Shparlinski reaching n^{5/4+o(1)} unconditionally. The quantifier column is kept with a note that dropping it would mislead **in our favour**, the two strongest exponents both carrying exceptional sets. Two primary-source checks are flagged at the site rather than silently absorbed: the 1/4 rung's attribution is on Shparlinski's framing, not the original, and the Chowla row names a conjecture-type rather than a paper.

**Edit 5 — the missing references.** Rivest–Vuillemin, Kleitman–Kwiatkowski, Korneffel–Triesch and Scheidweiler–Triesch added to `notes`, the last with the δ-versus-c(n) caveat attached so the number is not quoted bare from the bibliography. Angel–Borja and the two distinct Lutz papers were already correctly separated in the reference list, so edit 5's Lutz half needed nothing.

**Framing deferred**, as instructed. The three consequences of the Jones–Zvonkin model — standing table at the front of `aod` §3, the polynomial-versus-exponential line in §3.5, the Catalan/Pillai caution on S1 and S2 — stay recorded in `literature-findings.md` items 14–16 and unactioned.

*Caught by the refs pass on the way out:* the new §3.6 note said "Shparlinski's Theorem 1", which the pass resolved against our own documents and reported as dangling. Rewritten as "Shparlinski (2014, Thm 1)", which is also the form the file's own convention requires.

## Fourteenth batch: the sub-board route, and finding it was already published

A route to beating the n²/3 query bound was derived in conversation, tested on the n = 10 artefacts, and then found in the literature. The record of that sequence is more useful than the result, so it is written up as items 17–19 of `literature-findings.md` rather than quietly dropped.

**The route.** D(P) ≥ deg(P) and deg(P) ≥ |S| when the Fourier coefficient at edge set S is nonzero; for a down-closed P that coefficient is A(S) = Σ_{T⊆S}(−1)^{|T|}[T∈P]. For a **p-group** Γ and Γ-invariant S, orbits on subsets of S have p-power size, so A(S) ≡ (sum over unions of Γ-orbitals inside S) mod p — 2^t terms rather than 2^{|S|}. Nonzero mod p gives D(P) ≥ |S|, and S can be everything but the smallest orbital.

**The p-group hypothesis was missing at first, and how it was found is the part worth keeping.** The first version used Oliver-chain groups: wrong, since orbit sizes are divisible by q only for a q-group. On the full board the corresponding claim survives because the argument goes through Oliver's theorem and acyclicity rather than raw orbit counting — the conclusion had been transported to sub-boards without the proof. What exposed it was the question *"couldn't you pick a trivial group?"*: Γ = 1 makes every subset invariant, the reduction is vacuous, and the cost is 2^{|S|} — which shows the strength comes from orbit structure, not from S being large.

**Measured on the n = 10 artefacts**, restricted to the p-group battery where the congruence is elementary: the test fires on 915 sub-boards, largest **|S| = 42 of 45** via a C₇ on seven points with three fixed (p = 7, A = −5), against n²/3 = 33.3. That 42 is also the route's ceiling in that battery, the smallest available orbital being 3.

**It is Black's spacing framework** — orbit augmentation sequences, p-groups throughout, spacing lower-bounding D (ITCS 2015 / ACM ToCT 2019, building on Kulkarni–Qiao–Sun). The mechanism is not ours; the n = 10 figure is a spacing-like certificate.

**Two things survive the collision.** It is a *certificate, not a theorem* — whether A(S) ≢ 0 mod p is a fact about the particular P, so it gives no bound on c(n) without showing the test fires for every high-dimensional P. And **the optimisation runs opposite to our battery selection**: it wants many small orbitals where the max-m\* search wants the reverse, the same inversion the two-orbital criterion has.

**Two calibrations recorded alongside.** Chakrabarti–Khot–Shi already reach **½n² − O(n)** for subgraph containment on an arithmetic progression of n, so "closer than n²/3" exists for restricted classes and is much closer — any ambition of ours in that direction must be explicit about the class it quantifies over. And at least one survey attributes Ω(n²/3) to **unpublished Santha–Yao** rather than to Scheidweiler–Triesch, whom we cite alone; that is a priority claim we have not checked, now added to T4's primary-source list.

**The process finding, which is the reason this batch is logged at length.** `literature-findings.md` item 4 had said "the only one of the original four where I could not get past the abstract" for three passes, sitting at the top of the reading list. Had it been read, the construction would have been recognised rather than derived, presented as promising, and corrected only under challenge. **An unread item on a reading list is a live hazard, not a deferred task** — it does not merely delay a finding, it allows work to be done twice and claimed once. Item 4 now leads with that, and its action has changed from "read it" to a specific comparison question about spacing at our n.

## Fifteenth batch: `aod` §3.8's convergence evidence was selected

**The Jones–Zvonkin polynomial refinement is already implemented, so nothing was owed there.** `count_check.py`'s `_density_integral` evaluates 1/(log q · log r · log c) at the actual values r = Dq + 1 and c = (n−1)/K − (D/K)q, integrated across the window by Simpson — not 1/log³ of a common variable — and `singular_dq` uses the true root count of the system mod p rather than a generic form. Both refinements are in the path that produces every row of the §3.8 table. Checked rather than assumed; a note now says so at the site, with the reason it is not optional at our range: log n runs 12–14, so an additive constant inside a log is a percent-level effect and three of them compound.

**What checking turned up instead is a selection problem in the convergence evidence.** §3.8 followed two residues to 10⁶ to show the deviations are finite-size — n ≡ 11 (1.1006) and n ≡ 23 (1.0341). **Both are above 1.** The two residues furthest from 1 in the whole table are n ≡ 19 (0.9030) and n ≡ 3 (0.9354), both *below*, both at D = 4, and neither was tracked. So the convergence claim was being tested only on the deviations that flatter it.

Ran them:

| | [2×10⁵, 2.15×10⁵] | [5×10⁵, 5.03×10⁵] | [10⁶, 1.003×10⁶] |
|---|---|---|---|
| n ≡ 19 (mod 24), D = 4 | 0.9030 | 1.0045 | **0.9995** |
| n ≡ 3 (mod 24), D = 4 | 0.9354 | 0.9909 | **1.0247** |

with sd 0.146 → 0.103 → 0.092, and zero values lacking a solution in the window at every band. So the claim survives, and it is now **better supported than before**: the deviation is **two-sided and converges from both directions**, which is what finite-size effects predict and what a mis-specified singular series would not produce — a wrong system drifts consistently one way rather than converging from both. The table and the surrounding sentence are updated to say that, and to say why those four rows were chosen.

*Lesson worth carrying:* the original two rows were not chosen dishonestly, they were chosen as "the largest deviations", and at the time the largest happened to be the two high ones. But "largest deviation" and "largest deviation in each direction" are different selections, and only the second tests the mechanism being claimed.

## Sixteenth batch: §3.9.1.2's competing rates, and a third effect that turned out to be zero

**The hypothesis.** §3.9.1.2 weighs two effects — a Θ(1/log n) log-factor bias and O(log^{3/2}n/√n) count noise — and then worries that the Bateman–Horn secondary term is *also* Θ(1/log n) and could flip the drift's sign. A natural third candidate would dominate both: the **singular-series ratio between the two systems, fluctuating with n**, since 𝔖 depends on which primes divide n and n−1, those jump irregularly, and the factors are Θ(1). Had it existed and been symmetric, it would have decided the argmax and made 1 : 1 : 2 follow from pool shares regardless of the model's secondary term.

**It is identically zero, and the reason is a one-line identity.** With f₁ = q, f₂ = Dq + 1, f₃ = h − (D/2)q and h = (n−1)/2, the root collisions are f₁ = f₃ ⟺ h ≡ 0 (mod ℓ) and f₂ = f₃ ⟺ h ≡ −1/2 (mod ℓ) — **both conditions on h alone, with no D in them.** The only D-dependence is the degenerate branch ℓ | D/2, which for D = 4 against D = 8 never fires at odd ℓ. Measured: 𝔖_D/𝔖_{2D} = 1.0000 at every n ≡ 7 and every n ≡ 15 (mod 24) across [10⁵, 3×10⁵] and [10⁶, 1.2×10⁶], 8,333 values each; and a direct sweep of root counts over ℓ ≤ 41 and n < 20,000 finds **0 disagreements** between D = 4 and D = 8. The branch is not vacuous in general — at ℓ = 3 the counts *do* differ between D = 6 and D = 12 — so this is a fact about the pair compared, not a principle.

**Which cuts against the softer reading rather than for it.** With no Θ(1) fluctuation available, the Θ(1/log n) bias really is what steers the argmax, and the residue classes offer no rescue: the moduli are fixed and small (c mod 8, n mod 24), where Siegel–Walfisz gives error smaller than any fixed power of 1/log n. That is the **high**-uniformity regime. Maier and Friedlander–Granville irregularity needs moduli growing like x/(log x)^A or short intervals of length (log x)^A, and does not reach here — so appealing to it would be quoting a theorem out of its range, and would give the wrong sign. The finite-n tilt in the table is real and the convergence is genuinely slow.

**Recorded as `pending-checks.md` T5a, a standing re-derivation item**, because each pass over this argument has produced a different picture and every version so far has been plausible and at least partly wrong. The item carries the four-effect table with sizes and status, the instruction not to appeal to irregularity results out of their modulus range, and the trigger for reopening: D-independence fails at ℓ = 3 between D = 6 and D = 12, which is exactly the generalised family of `mu-theta-n2-note.md`.

**The general hazard, now named in the item:** *both* too much and too little uniformity relative to the pseudorandom model produce surprises, and which regime one is in depends on the modulus range. An argument quoting an irregularity result without checking its moduli reach ours will reach the wrong conclusion and look right doing so.

## Seventeenth batch: eliminating SAFE mode — and a defect in the A2 tightening

**The question was how to make SAFE mode structurally unnecessary. Working it through found that the A2 tightening had quietly assumed the answer.**

**The route.** SAFE over-counts a p-characteristic part relative to REFINED on exactly one axis: REFINED strips the twist by the foreign primes dividing c − 1, SAFE does not. If that strip were unconditionally *necessary*, the refined score would itself be an upper bound and B_refined = B_safe = μ would hold by construction — no per-n certificate needed. The strip is Lemma C.

**The defect.** A2's condition (4) already applies the strip, and its stated proof was: *the cyclic layer carries C_r and C_Fmid, and one cyclic group forces pairwise-coprime orders.* **That argument is invalid, and Part D of `enumeration-proof.md` says so in a pitfall box** — a single cyclic generator can act as a twist of order d on one part and as a translation of order r on another, giving ⟨g⟩ cyclic of order lcm(d, r) with nothing forced. What actually proves Lemma C is conjugation: a top-layer element induces the identity on the twist but the twist's own order on the foreign part. And that argument closes **only at prime c** — at c = p^a with a > 1 the top element may act through the Galois part of ΓL(1, p^a), whose induced power map has q-power order just as the foreign multiplier does.

So condition (4) was resting on an unproved lemma at a > 1. Conditions in `fb_common.py` must be **necessary**; a condition that is not silently discards a real candidate, which is the one error class the certificate cannot detect from its own output.

**The fix and its cost.** The foreign-prime strip is now scoped to a = 1 in all three sites (`pair_candidates`, `single_part_ok`, `multi_part_ok`), with the pitfall recorded at the site so the cyclicity argument is not reintroduced. **The scoping is not vacuous:** the strip changes condition (4)'s verdict on 630,477 branches at n ≤ 2000, of which **53,807 have c a proper prime power**.

**Everything still holds.** `fallback_cert` against v4: 0 candidates, both modes. `wide_cert` at 10⁵: **0 unresolved of 90,299** — the A2 closures survive, because c = 20327 and c = 35879 are both *prime*, so Lemma C applies there and the strip is licensed. Direction regression against the pre-A2 baseline over 501,046 pairs: 0 gained, 0 removed.

**T5 rescoped from "fence it" to "close it".** The item previously recommended not closing the Lemma C gap, on the ground that exposure was zero and confined to attainment. That is no longer true — the lemma now sits inside the trusted base for μ(n) = B(n) — and closing it is the structural route to eliminating SAFE mode. Two routes are recorded: prove the Galois incompatibility, or **dominate** the a > 1 configurations as Lemma D2 dominates the fused-foreign case. The second looks more tractable and has supporting evidence: 0 of 2,178 p-characteristic parts in a computed winner have both a > 1 and a foreign prime dividing c − 1.

*The general lesson, which is the third instance this session:* an argument that is valid at the boundary case (a = 1, or the full board, or a q-power block count) and asserted through the general case is this framework's characteristic failure. All three times the invalid step was a compact structural clause, and all three times the correct proof existed elsewhere in the documents under a different name.

## Eighteenth batch: §2b restored after a truncating edit

**What happened.** The T5 rewrite of the previous batch was applied as `s[:i] + new` — replacing everything from T5 to the end of the file rather than T5 alone. T5 was the last item in §2a, so the deletion took **all of §2b with it**, including A0b, which is a standing item rather than a closeable one. Caught on review, not by any check.

**Restored, with this session's amendments re-applied** rather than reverting to the pre-session text: group A now names the Part E preconditions from T2; group B lists the four checks added since (cyclic-layer coprimality, the feasibility criterion, G.4's per-axis bounds, the cross coefficient), each flagged as having no independent counterpart elsewhere and a negative control; and the speed-budget box is intact. T5a was also reordered to follow T5 rather than precede it.

**Two lessons, and the second is the operational one.**

1. **A truncating slice is the one edit pattern with no partial failure mode.** `str_replace` on a bounded region fails loudly when the anchor is missing; `s[:i] + new` silently discards the tail, and the tail is invisible in the diff if nothing after it is being examined. Prefer replacing a bounded region — `s[:i] + new + s[j:]` — even when the item is believed to be last, because "believed to be last" is exactly the assumption that breaks.
2. **Nothing would have caught this.** `check_doc_figures.py` reports 0 dangling references either way, since the deleted section contained no cross-references into the mathematical documents. A missing *section* is not a class of error any current check looks for. Worth considering a hygiene check that asserts the presence of the standing items by name — A0b in particular, since it is the one item designed never to close.

## Nineteenth batch: the regime split, with S1–S7 left alone

**The framing correction that produced this.** A first attempt described the fallback configurations as needing an *extension* to the notion of a shape, on the ground that their parts are linked by r | c − 1. That was wrong: `aod` §3.3's system is already three conditions in **one** variable, and the coprimality budget and distinct-foreign-prime rule are inter-part constraints too. Linkage is the norm here, not a distinguishing feature — and the q-reparametrisation proposed as new is what `count_check.py --dq` has always done.

**What actually separates the families is the degree of the system in its natural variable**, which for these is the top prime q. Writing the foreign twist as t = q^e with cofactor u = (r−1)/t, the gate forces t ≥ δn/2, hence u ≤ 2/δ and q ≥ (δn/2)^{1/e}, and three regimes follow:

| regime | r in terms of q | supply of admissible r near δn | standing |
|---|---|---|---|
| e = 1 | linear | positive density | an ordinary parametric family |
| e ≥ 2 fixed | degree e | ~N^{1/e}, **density zero** | Bateman–Horn, available at almost no n |
| q = 2, e varying | exponential | — | outside Bateman–Horn |

**A reasoning error corrected before it reached a document.** The density-zero claim was first justified as "n grows like q^e", which is wrong — n is given, not constructed. The correct reason is that the *primes* with r − 1 = u·q^e and bounded u are sparse, so the chance one lands in the window near δn is n^{1/e−1} → 0. Sparsity in the supply of foreign blocks, not in n. Both give density zero; only one suggests the right repair, so §3.5.6 states it explicitly.

**Which explains, rather than excuses, the per-n certificate.** A family available at a density-zero set of n cannot be dispatched per shape, because where it *is* available it may be the optimum. Part E′ now says so: the per-n certificate is the right instrument, not a stopgap.

**And it identifies the two q-pinning escapes as one phenomenon.** e ≥ 2 and q = 2 are both where the family stops being polynomial in q; q = 2 is §3.3.2's Fermat branch, and it is exactly where r_j ≡ 1 (mod 2) makes pinning vacuous. This is the polynomial-versus-exponential line `literature-findings.md` item 14 asked for, arrived at from our own side.

**Edits.** `aod` gained §3.5.6 (the three regimes, with the sparsity caveat) and a note in §6.2 that linkage is normal; `enumeration-proof.md` gained the general q-pinning box in Part E″ — five steps, the conditionality at step 1, the two escapes with measured sizes, and the observation that pinning reaches only the *foreign* half of the leftover while the p-characteristic half needs Lemma C — plus the per-n rationale in E′. T5 now states the realistic target: conditional on δ ≥ δ₀, the branch reduces to a named finite residue.

**Scripts: diagnostics only, no behavioural change.** Nothing computed differently — the certificates already enumerate every branch regardless of e. Two reporting additions so the split is measured rather than quoted: `fallback_cert.py` reports the regime census over gate-passing foreign parts (**28,758 / 3,363 / 709 — e = 1 at 87.6%**), and `validate_table.py` group C reports the split over winners (**81.3% / 148 / 45**, largest cofactor u = 12 against the predicted ceiling 44). Suite still runs in 0.154 s, inside the budget.

**S1–S7 untouched**, deliberately. The regime split is orthogonal to the census: it classifies a configuration's foreign block by the arithmetic of its twist, where S-numbers classify by part structure. Every existing name, cross-reference and script string is unchanged.

## Twentieth batch: the standing-table row, and how far e = 1 actually closes

**The row, and the reason it is worded defensively.** `literature-findings.md` item 16's table now carries the fallback branch, split into four rows rather than one, because the pieces have genuinely different statuses and a single row would have implied more than is true. A note above the table says the thing most likely to be misread: **the branch has been characterised, not closed** — B_refined = B_safe is still a per-n certificate, and the characterisation is itself conditional at two separate points.

**Attempting to close e = 1 produced a modest positive result and a clear negative one.**

*Positive.* Above δ = 1/9 the branch is **closed unconditionally**, and by something already in hand: each of the three parts needs size ≥ √(2B) ≈ n√δ from its own intra term against B, so 3n√δ ≤ n forces δ ≤ 1/9. That is Proposition F.1 at k = 3 — no new argument, but it had not been applied to this branch.

*Negative, and worth recording so nobody repeats it.* **Adding the pinning does not improve that bound.** With r_j ≥ q + 1 and q ≥ B/r, the chain gives n ≥ √(2B) + r + max(√(2B), B/r) ≥ 3.54√B, hence δ ≤ 0.16 — **weaker** than F.1's 1/9. So the pinning, which looks like the powerful ingredient, contributes nothing at the level of size counting. Below 1/9, counting alone cannot close the branch by any of these routes.

**What does close the computed range is arithmetic, and it is worth seeing how thin the survivors are.** Over every e = 1 odd-q foreign part passing the gate at n ≤ 2000, the leftover holds **24,322 pinned positions r_j ≡ 1 (mod q)**, of which **4 are admissible** — prime, distinct from r, own gate passing. Those four are two configurations counted twice:

| n | δ | q | r | r_j | space left | S needed |
|---|---|---|---|---|---|---|
| 779 | 0.0706 | 73 | 293 | 439 | 47 | 207 |
| 1943 | 0.0577 | 137 | 823 | 1097 | 23 | 467 |

Both die because the p-characteristic part cannot fit. And the mechanism is the pinning after all, just not through the size bound: it forces r_j **well above** its own floor — 439 against 207, 1097 against 467 — and that excess is what leaves no room. The generic inequality does not see this; the specific residue class does.

**So the honest status of e = 1 is "empty over the computed range, by a bounded search".** Above 1/9 a theorem, below it a per-n check with ≤ 2/δ positions to test — which is what `fallback_cert.py` has been doing all along, and why this branch has never produced a candidate. A reduction to a bounded search is not an elimination, and Part E″ now says so in those words.

**T5 gained a five-row status table** so the remaining work can be costed piece by piece rather than as one ambition: e = 1 above 1/9 closed, e = 1 below 1/9 a bounded search, e ≥ 2 enumerable at sparse n, q = 2 needing domination, and Lemma C at a > 1 as the prerequisite for the p-characteristic half.

## Twenty-first batch: full read of `enumeration-proof.md`

*Start to finish, for coherence rather than for figures. Nine fixes, and one finding that outranks everything currently open.*

### The finding: Lemma D2's last step

D2 concludes that an orbit of F ≥ 2 fused *outside* blocks carries a class of at most (F/2)·r or F·r pairs, hence m\* ≤ |O|/2, hence outside blocks are never fused. Its final step invokes "the minimum pair-orbital of a transitive group of prime-power degree F is F/2 or F — the divisibility argument of Part E applies verbatim."

**That argument was scoped earlier this session** to the regular C_F action of the Part E construction, because it is *not* a bound over all admissible permuters. D2 inherits the same defect one level down, and here the block-permuting group need not have prime-power degree at all: under the corrected shape space F = F_mid·F_top.

**Witness, computed rather than conjectured:** AGL(1,5) = C₅⋊C₄, with C₅ in the cyclic layer and C₄ on top, is solvable, fits the chain, and is 2-transitive on 5 blocks — pair-orbital sizes `[10]`, a single class of size C(5,2). Against D2's claimed F·r = 5r, the offset-0 class is 10r = 2|O|, and "at most |O|/2" does not follow.

**Why this outranks T5 and everything else open.** Part E's coefficient error was harmless because the intra term binds first. D2's conclusion supports Corollary D2′ and therefore **the block-count split F = F_mid·F_top — the corrected shape space itself.** If outside blocks can be fused, the enumeration is missing shapes, and what fails is **μ ≤ B_safe**: precisely how the q-power block count failed. The constructions and B_refined are unaffected.

Untouched by the gap: the diagonal-translation step (Γ₁/Γ₂ cannot hold C_r^F for F ≥ 2) and the r = q case. Recorded as a GAP box in Part D2, with D2′ marked *subject to it*, and as **A18** in `pending-checks.md` at the top of the risk ranking, with three routes costed — show a 2-transitive permuter is inadmissible; bound the other classes instead; or enumerate fused-outside-block configurations and check whether any beats B(n).

**And a caution recorded with it:** the table contains no fused-outside-block configuration, but the table is computed from an enumeration that excludes them by construction, so it is not evidence.

### Eight coherence fixes

- **Lemma D1 was listed as unproved in the inventory** ("needs writing down") and as proved in the index one screen later; it *is* proved in Part D2. Inventory corrected.
- **Lemma C's dependency claim was stale in three places.** "Does not affect B_safe" is still true of the bound, but `fb_common.py`'s condition (4) now uses Lemma C's conclusion, so the lemma bears on the **collapse**. The inventory entry, the index row and the closing note all say so, and note that closing a > 1 would remove the last obstacle to replacing B_safe by B_refined outright.
- **Worked case B presented B(308) = 3775 as current** and called the configuration "the defect". Rewritten: 4134 *is* B(308), and 3775 is what a q-power-only count would give.
- **Worked case F was framed as old-witness/new-witness.** Rewritten as a statement about the configuration, with the branch-and-bound consequence kept.
- **The header's "on the word proved" paragraph** still narrated the G.2 repair history. Rewritten as two named false steps plus the recurring near-repair pattern.
- **A stray parenthesis in the B_safe box** left "This is what `mu_enumerate_v2.py` computes" attached to an aside about `brute.py` rather than to the definition. Separated.
- **"It rests on Part 0's completeness and on nothing else"** overstated: μ ≤ B_safe also needs the cap F·orb(c, dmax) to be valid. Corrected.
- The risk ranking in `pending-checks.md` gains A18 at position 1, pushing the table rebuild to 2.

### What read clean

Parts A, C, F, G, H, I and J cohere with the current model; the sandwich statement in the header matches Part E′'s figures (90,299 of 90,299) and Part I's; the census, the six worked cases apart from B and F, the lemma index's other rows, and the Part 0 picture proof all check out. The E″ material added this session sits consistently with Part D2 — except for the D2 gap above, which they share.

## Twenty-second batch: the 3-uniform note

**Written as a design document and as a fresh-eyes pass**, on the reasoning that running the machinery where the answers are not already known is a better test of it than re-reading. `three-uniform-note.md`, with statuses attached: the orbit law is verified exhaustively, the shape ranking is empirical over n ≤ 52 and explicitly not proved, the adaptation notes are a reading rather than a rewrite.

### The orbit law, which is the one genuinely new piece

> **orb₃(c, d) = min(c·d/κ, C(c,3)) with κ = 3 if 3 | d, else 2 if 2 | d, else 1** — verified at **32 of 32** (c, d) pairs over c ∈ {5,…,23}.

And it generalises: with **κ_k(d) = max{m ≤ k : m | d}**, orb_k(c, d) = min(c·d/κ_k(d), C(c,k)), of which the familiar k = 2 law is the case k = 2. The reason the density collapses falls straight out — the twist buys a factor d, the stabiliser can give back at most a factor k, so the numerator is Θ(c²) at every k while C(c,k) grows.

### What inverts, and it echoes things already in the k = 2 documents

Fusion and prime-power blocks — the two things k = 2 exploits — are both **actively bad** at k = 3, by mechanisms already present in our documents under other names. Fused blocks admit same-position triples of size ≤ C(F,3)·c, which is **Lemma D2's offset-0 class one dimension up**; prime-power blocks admit affine lines, which is the additive structure Lemma C's a > 1 case worries about. Measured: n = 35 as `5x7` gives 70, n = 26 as `9 + 17*` gives 12, against 253 for `23 + 29*` at n = 52.

So the k = 3 optimum is **unfused, two prime blocks**, and the arithmetic requirement *relaxes* to binary Goldbach — giving μ₃(n) ≳ n²/8, or n²/12 when both blocks are ≡ 1 (mod 3). Almost all n, unconditionally.

### Why the k = 2 constants exist at all

Because AGL(1, c) is 2-transitive and hands a block full density. The k = 3 analogue would need 3-transitivity, and **there are no solvable 3-transitive groups of degree > 4** — the 3-transitive affine groups are AGL(d,2), and GL(d,2) is simple for d ≥ 3. Oliver chain groups are solvable, so the mechanism is *excluded*, not merely unfound.

**A sentence saying so is now in `aod` §3**, because it changes how that section should be read: the optimisation is not the heart of the method, it is the dividend of 2-transitivity. Three related observations are recorded in the note's §7 — the constants are contingent rather than structural; fusion and prime-power blocks are k = 2 luxuries; and the arithmetic difficulty of §3.5 is the price of chasing constant density rather than something intrinsic, since at k = 3 the supply question collapses to Goldbach.

### Literature

`literature-findings.md` item 22 corrects the natural assumption that weak evasiveness stops at k = 3 — **Black covers all k**, same paper as item 4. What is not covered anywhere found so far is a *dimension threshold* at k ≥ 3, which is what this machinery produces and Black's does not.

## Twenty-third batch: scoping the k = 3 orbit law

**The law needed a hypothesis it did not have.** As first written, orb₃(c, d) = min(c·d/κ, C(c,3)) was stated for "a block of prime size c" with no lower bound on c and no statement of what goes wrong elsewhere. Two corrections, both from checking rather than reasoning:

**c > 3 is needed for the derivation.** At c = 3 the only 3-subset is the whole block, fixed by every group element; the formula returns 1, but via the C(c,3) cap rather than because the argument applies — the free-translation step fails outright. At c = 2 there are no 3-subsets. Also recorded: the cap can bind only for **c ≤ 7**, since c·d ≤ c(c−1) ≤ C(c,3) once c ≥ 8.

**"Prime power" was the wrong exclusion, and measuring it gave a sharper statement.** The law does fail at c = 9 — by exactly a factor of 3 at every twist (3, 3, 6, 12 against 9, 9, 18, 36) — but it **holds at c = 4 and c = 8**, verified. So the obstruction is not prime-power-ness; it is the existence of a **3-element additive subgroup** for a 3-set to be a coset of, i.e. 3 | c with c > 3. §4's "prime-power blocks are poison" is corrected to "blocks of size 3^a with a ≥ 2", with the general-k form noted: the poison at k-sets is p ≤ k with a ≥ 2, so the excluded set grows with k.

*Worth noting for the k = 2 side:* the same distinction has no bite at k = 2, because a 2-set being a coset of a 2-element additive subgroup is only possible in characteristic 2, where it is harmless. The exclusion appearing at all is a k ≥ 3 phenomenon, and it is a second respect in which the shape space narrows as k grows.

## Twenty-fourth batch: semilinearity at k = 3

**The prompt.** The reference construction builds AGL(1, c) — translations plus a multiplicative twist — and omits the Frobenius map. The full point stabiliser of a primitive affine block is ΓL(1, c), so at c = 8 the available group is AΓL(1,8) of order 8·7·3 = 168 against AGL(1,8)'s 56. A bigger group fuses orbits, so the minimum on 3-sets could rise and the orbit law could be understating.

**Measured across c ∈ {8, 9, 16, 25} and every twist order: AGL and AΓL give identical minima in all 18 cases.** The law is unaffected.

**Two distinct reasons, which is why the result is more robust than a single coincidence.** At **c = 8 the minimum is already maximal** — |AGL(1,8)| = 56 = C(8,3), and the action on 3-sets is *sharply transitive*, so there is exactly one orbit and nothing left to fuse. At **c = 9, 16, 25** the minimising 3-sets form a **Frobenius-stable family**: Frobenius sends a cube root of unity to another cube root, so it preserves the shape {x, ζ′x, ζ′²x}, and it maps affine lines to affine lines. The small orbits are already closed under it.

**Why this is worth more than a checked edge case.** The GL(1)-versus-ΓL(1) distinction is precisely the open **J0a** of `enumeration-proof.md` and the false ΓL(1) step of Part B — at k = 2 an unresolved assumption bearing on attainment. On this evidence **orb₃ is insensitive to it**, so a k = 3 programme would inherit the shape space without inheriting that worry. Recorded as 18 cases of evidence, not a proof.

Also confirmed in passing: Frobenius does not rescue the 3 | c blocks either, since any semilinear map permutes affine lines among themselves.

## Twenty-fifth batch: the Frobenius claim was wrong, and c = 32 is why

**Retraction.** The previous batch concluded that orb₃ is insensitive to the GL(1)-versus-ΓL(1) distinction, on 18 measured cases. **That conclusion is false**, and it failed for two independent reasons at once — a buggy Frobenius routine (dead code left in the exponentiation), and a sample that happened to contain no case where the question has teeth.

**The counterexample, suggested rather than found by me:** c = 32 = 2⁵. Then c − 1 = 31 is prime, so the twist has no cube roots and no antipodal element, and a = 5. Measured with a corrected implementation:

| c = 32, a = 5 | d = 1 | d = 31 |
|---|---|---|
| AGL(1,32) | 32 | 992 |
| **AΓL(1,32)** | **160** | **4960** |

A factor of exactly a = 5. At d = 31 the semilinear action is *sharply transitive* on 3-sets: 4960 = C(32,3) = |AΓL(1,32)|.

**Replaced by a proof rather than more examples.**

> **Lemma (semilinear fusion).** AGL ⊴ AΓL with quotient C_a, so every ΓL-orbit is a union of AGL-orbits permuted by C_a with sizes preserved; an AGL-orbit A with C_a-stabiliser of order t has ΓL-orbit |A|·a/t. Hence min₃^ΓL = min_A |A|·a/t(A), and **min₃^ΓL = min₃^AGL iff some minimum-size AGL-orbit is Galois-stable.**

Three sufficient conditions for such an orbit, each by exhibiting a fixed set: **2 | d** ({0, 1, −1}, fixed pointwise by Frobenius, stabiliser of order 2); **3 | d** ({1, ζ′, ζ′²}, fixed setwise since ζ′^p again has order 3); **a = 3 or 3 | c** (Frobenius orbits of size 3 are themselves 3-sets; and Frobenius is 𝔽_p-linear so permutes the 𝔽_p-lines). A rise therefore requires **gcd(d, 6) = 1, a ≠ 3, and 3 ∤ c** — and c = 32 is the smallest case meeting all three, which is exactly why the earlier sample missed it: c = 8, 9, 16, 25, 27, 49 each satisfy one of the conditions.

**The consequence reverses the earlier reading.** A k = 3 programme **does** inherit J0a, and in a sharp form: the semilinear twist is worth a factor of a precisely on blocks with gcd(d, 6) = 1, a ≠ 3, 3 ∤ c. Since larger orbits are better for us this is an opportunity rather than a hazard — but the shape space must be indexed by **ΓL** twists, not GL twists.

**§2 restructured** into 2.1 (prime blocks, the law) and 2.2 (prime powers), the latter split into 2.2.1 (the affine-line failure, triggered by 3 | c rather than by prime-power-ness) and 2.2.2 (semilinearity). Frobenius belongs under prime powers because it is trivial when a = 1.

*Process note.* Two things would have caught this earlier: implementing Frobenius by a named field operation rather than a hand-rolled power loop, and choosing test cases by the *criterion* the claim depends on rather than by convenience. The cases I picked were the ones already lying around from §4's shape comparison, and every one of them satisfied a condition that makes the question vacuous.

## Twenty-sixth batch: the Mersenne family, and a tie to the Jones–Zvonkin programme

**The suggestion, and it upgrades §2.2.2 from a criterion to a theorem.** Take c = 2^p with 2^p − 1 a Mersenne prime, p ≥ 5 prime. Then all three conditions of §2.2.2 hold at once and for structural reasons: M = 2^p − 1 is odd and, p being odd, 3 ∤ M, so gcd(d, 6) = 1; a = p ≠ 3; 3 ∤ c. **What the Mersenne condition buys** is that the *maximal* twist d = c − 1 is itself coprime to 6, so the gain applies at the strongest configuration rather than only at a weak one.

> **Proposition (proved).** For such c, **AΓL(1, c) acts freely on 3-subsets**, so orb₃^ΓL = c·M·p = p·orb₃^AGL.

The proof is a cycle-type argument over the three prime divisors: involutions are translations (the point stabiliser C_M ⋊ C_p has odd order), so 2^{p−1} transpositions and no odd stable set; order-M elements fix one point and M-cycle the rest with M > 3; order-p elements are Frobenius conjugates with fixed field 𝔽₂, giving two fixed points and p-cycles, so a stable 3-set would need 1+1+1 or a single p-cycle, and p ≠ 3.

**Verified at both computable members.** c = 32: 992 → 4960, factor 5. c = 128: the orbit of {0,1,3} is **113,792 = 128·127·7** under AΓL against 16,256 under AGL — free, factor 7, with C(128,3) splitting into exactly 3 orbits.

**A nontriviality condition falls out, and it bites at the first member.** The gain is capped by C(c,3), so it is genuine only when a ≤ (c−2)/6. At c = 32 that is 5 ≤ 5 — *equality* — so AΓL(1,32) is sharply transitive on 3-sets and the minimum is already maximal. At c = 128 it is 7 ≤ 21. So c = 32 is the extremal member, not a typical one, which is worth knowing before generalising from it.

**And the family connects to `literature-findings.md` item 20.** Jones–Zvonkin's projective primes are (q^n − 1)/(q − 1) prime; **at q = 2 those are the Mersenne primes**. Same arithmetic input, two different questions. Two consequences recorded in both documents: the supply is **outside Bateman–Horn** — 2^p − 1 is exponential in p, exactly the exclusion they state for their own Mersenne-like families — so the governing heuristic is Lenstra–Pomerance–Wagstaff, conjecturally infinite but very thin; and this is therefore the **k = 3 instance of the exponential regime** already isolated at k = 2 in `aod` §3.5.6. The polynomial/exponential boundary reappears as the boundary between blocks where semilinearity is worth a factor and blocks where it is worth nothing.

## Twenty-seventh batch: the semilinear criterion is necessary and sufficient

**The question was whether §2.2.2's three sufficient conditions are also necessary — because if so, deciding the semilinear gain becomes pure arithmetic with no orbit computation. They are, once corrected.**

The three conditions as stated were *not* the whole story: "a = 3" should be "gcd(a, 6) > 1", and there is a fourth escape at p ≥ 3 that they only covered accidentally. The corrected statement is complete:

> **Theorem.** For c = p^a, a ≥ 2, d | c − 1: **min₃^ΓL > min₃^AGL ⟺ p = 2 and gcd(a, 6) = 1 and gcd(d, 6) = 1**, and the gain is then exactly the **smallest prime divisor of a**.

**Sufficiency** exhibits a Galois-stable minimal orbit in each escaping case: {0, 1, −1} or {1, ζ′, ζ′²} when gcd(d, 6) > 1; any 3-subset of the pointwise-fixed 𝔽_p when p ≥ 3; and, at p = 2, the set {0, ω, ω²} ⊆ 𝔽₄ when 2 | a or the Frobenius orbit {ω, ω², ω⁴} ⊆ 𝔽₈ when 3 | a.

**Necessity** is the part that makes it a criterion. Under the three hypotheses AGL acts *freely* on 3-sets, so a stabilising h must have order exactly a; h permutes S so h|_S has order dividing both a and 6, which gcd(a, 6) = 1 forces to be 1; so h fixes S pointwise. But h ↦ Frob^i with gcd(i, a) = 1, and gcd(2^i − 1, 2^a − 1) = 1, so **|Fix(h)| = 2 < 3**. Contradiction.

**The gain factor** follows by running the same argument for a subgroup C_t: |Fix| = 2^{a/t} ≥ 3 iff a/t ≥ 2, so the largest achievable stabiliser is t = a/q with q the least prime divisor of a.

**Verified at 16 further (c, p, a, d) combinations** across c = 8, 16, 32, 64, 81, 125, 128 — every prediction correct, including the two cases the old sufficient conditions could not have settled: a = 6 at c = 64 (no rise, via 2 | a) and p = 3, 5 with a ≥ 3.

**Consequences.** Deciding whether semilinearity helps at a block needs no orbit computation — it is a function of (p, a, d) alone, and the gain exists **only in characteristic 2**. §2.2.3's Mersenne family is now a corollary rather than a parallel result; its direct cycle-type proof is kept because it exhibits the freeness explicitly.

**One clause is proved but not testable here:** that the factor is the *smallest prime divisor* of a rather than a itself. Both computable cases have a prime (5 and 7), where the two agree; the first distinguishing case is a = 25, i.e. c = 2²⁵.

## Twenty-eighth batch: imposing Oliver's condition on the semilinear criterion

**The gap.** The §2.2.2 theorem was about AΓL(1, c) as an abstract permutation group. The framework admits only Oliver chain groups, and AΓL need not be one — a point the theorem never touched.

**Working it out.** For a single block Γ₂ = 𝔽_c is forced, so the question is how C_d ⋊ C_a splits into a cyclic middle and a q-group top.

- **d = 1:** C_d ⋊ C_a = C_a is cyclic, fits entirely in the middle layer with a *trivial top* — admissible for any a, and the harshest χ condition. But the block is worth only c·a, so this is weak.
- **d > 1, p = 2:** Frobenius acts on C_d by x ↦ x², trivial only if d | p − 1 = 1. So C_d ⋊ C_a is non-abelian, C_a cannot join the middle layer, and **Γ/Γ₁ ≅ C_a must be a q-group — a must be a prime power q^e.**
- **Proper Galois subgroups do not rescue it.** With C_m, m < a, the necessity argument gives h ↦ Frob^i with gcd(i, a) = a/m, so |Fix(h)| = 2^{a/m} ≥ 4 — a stable 3-set exists and there is **no rise at all**. The gain requires the *full* Galois group.

> **Corollary.** For d > 1 the semilinear reading raises the minimum **iff p = 2, gcd(d, 6) = 1, and a = q^e with q ≥ 5**; the gain is exactly **q**.

**So the answer is "almost the same, with one genuine tightening":** gcd(a, 6) = 1 is replaced by the strictly stronger *a is a prime power with q ≥ 5*. The abstract criterion admits a = 35; Oliver's does not, since C₃₅ is not a q-group. §2.2.3's Mersenne family is exactly the case e = 1, which is why it satisfies both criteria at once — and it now comes with its chain written out: Γ₂ = 𝔽_c, Γ₁/Γ₂ = C_M, Γ/Γ₁ = C_{p′}, top prime p′.

**Two clauses are proved but not computationally testable**, both out of reach: the factor being the smallest prime divisor of a rather than a itself (first distinguishing case a = 25, c = 2²⁵), and proper Galois subgroups giving no rise (first case a = 10, c = 2¹⁰, with C(c,3) ≈ 1.8 × 10⁸). Both are recorded as such rather than as verified.

*Pattern worth noting:* this is the third time in this note that a result stated for a natural algebraic object needed narrowing once the chain condition was imposed — after the orbit law (prime blocks only) and the shape ranking (fusion penalised). The chain condition is doing more work in this framework than its statement suggests, and results proved about AGL, AΓL or transitive groups in general should be checked against it before use.

## Twenty-ninth batch: notation, and what it exposed

**The notation was conflating a subgroup with the whole group.** §2.2 wrote "AGL" and "AΓL" throughout, but the object a block actually carries is

> **Γ(d, m) = 𝔽_c ⋊ (C_d ⋊ C_m)**, d | c − 1, m | a,

with C_d ≤ 𝔽_c^× and C_m ≤ Gal(𝔽_c/𝔽_p). Γ(c−1, 1) is the full AGL and Γ(c−1, a) the full AΓL, but those are the **extreme** members of a two-parameter lattice. §2.1's law is the case m = 1. Rewritten throughout.

**The point worth keeping:** both C_d and C_m are subgroups of *cyclic* groups, so each is determined by its order alone and C_m automatically normalises C_d — the subgroup of a given order being unique. It is a tightly constrained lattice: one divisor of c − 1, one divisor of a.

**And the notation was hiding a clause of the theorem.** The old statement said "proper Galois subgroups do not rescue this", as a remark. In the Γ(d, m) notation it is simply one of the escape clauses, with the cleanest proof of the four: a generator of the C_m quotient is Frob^i with gcd(i, a) = a/m, so **Fix = 𝔽_{p^{a/m}}, of size ≥ p² ≥ 4** whenever m < a, and any 3-subset of that subfield is fixed pointwise. So the theorem now reads

> **min₃(Γ(d, m)) > min₃(Γ(d, 1)) ⟺ p = 2, m = a, gcd(a, 6) = 1, gcd(d, 6) = 1**,

with m = a appearing as a *condition* rather than as an aside. The Oliver-constrained corollary is unchanged: for d > 1, gain iff p = 2, gcd(d, 6) = 1 and a = q^e with q ≥ 5.

**The Mersenne family is now labelled as the corner of the lattice it is.** Both d = c − 1 and m = a are maximal there, so it cannot exhibit the intermediate behaviour — and §2.2.2 says the intermediate cases behave *differently*, since m < a never gains at all. Noted in place, because generalising from that family would give exactly the wrong picture of the m-dependence.

*Which is the third correction in this note traceable to the same habit:* naming a familiar object (AGL, "transitive group", "prime power") where the argument needed a narrower one. The corrections have each time been in the direction of a smaller admissible class.

## Thirtieth batch: §4's fusion argument was wrong, and the conclusion reverses

**Two defects in one paragraph, the second fatal.** §4 claimed fusion is poison at k = 3 because F fused blocks admit same-position triples held together by "the diagonal translation", giving a class of size ≤ C(F,3)·c.

1. It needs **F ≥ 3** to have three distinct blocks, so it says nothing about F = 2 — the case that matters most.
2. **The translations of a matching class are independent, not diagonal.** Diagonal translations are what Lemma D2 forces on *foreign* blocks, precisely because Γ₁/Γ₂ cannot hold C_r^F, whereas Γ₂ *can* hold F independent copies of a p-group. The picture was imported from the wrong side of D2's own asymmetry — the asymmetry this note had already quoted correctly two sections earlier.

**What is actually true, and it reverses the ranking.** A matching class of F blocks has intra term **F·orb₃(c, d)** — all F blocks' 3-sets in one orbit, exactly analogous to k = 2. Since orb₃ ≈ c·d/κ, that is **≈ n·c/κ**, so fusing two blocks beats leaving them separate by a factor of about F.

Measured, and the margin is large:

| n | shape | min₃ | /n² |
|---|---|---|---|
| 26 | **2 × 13 fused** | **104** | 0.154 |
| 26 | 9 + 17\* | 12 | 0.018 |
| 34 | **2 × 17 fused** | **272** | 0.235 |
| 46 | **2 × 23 fused** | **506** | 0.239 |
| 52 | 23 + 29\* | 253 | 0.094 |
| 24 | **3 × 8 fused** | **168** | 0.292 |
| 24 | 11 + 13\* | 52 | 0.090 |

So **fusion is good at k = 3, as at k = 2** — the earlier table was measuring a weaker family and calling it optimal.

**What survives:** blocks of size 3^a with a ≥ 2 are still poison (§2.2.1's affine lines), which is why `9 + 17*` scores 12. That claim never depended on the fusion argument.

**What falls with it.** §5's constant — the ~n²/8 figure came from the superseded ranking, and 2 × 23 already reaches 0.24 n². And §5's arithmetic claim: "the supply question relaxes to binary Goldbach" followed from "two prime blocks is optimal" and does not stand, since fusion puts prime powers back in. §7's third observation, that the k = 3 number theory is easy, is downgraded from an observation to an open question.

**Both sections are now marked unreliable in the document**, with an explicit instruction not to build on them: no systematic shape search has been done at k = 3, and the cross-term structure of a fused class at k = 3 has not been worked out at all.

*The pattern, for the fourth time in this note:* a claim was carried over from k = 2 by analogy without checking which side of a structural asymmetry it belonged to. Here the asymmetry — Γ₂ holds independent copies, Γ₁/Γ₂ does not — was already stated correctly in this same document, in the section the argument cited.

## Thirty-first batch: dehistoricizing the 3-uniform note

Nine sites rewritten. The note had accumulated the usual residue of a document revised several times in one sitting — "this section previously claimed", "the earlier value here was too small", "does not stand", "now unreliable" — which describes the document's history rather than the mathematics.

**Where the history carried a real warning it became a pitfall.** §4's retraction box is now a *Pitfall* stating the tempting fusion argument and both of its failures before giving the correct account, on the reasoning that anyone reasoning by analogy from k = 2 will reach for the same argument. §2.2.2's box likewise now warns that a sample chosen for convenience will reliably mislead on the semilinear question, since every naturally-occurring small example satisfies one of the escape clauses — which is a fact about the criterion, not about how this note was written.

**Where it was just bookkeeping it went.** §5's constant is now stated as unsettled with the measured values, rather than as a correction to a superseded figure; §6's supply row is marked open rather than "simplifies"; §7's third observation is a question rather than a retraction.

**And the status header became a per-section table**, because the standing genuinely varies from "proved, necessity included" in §2.2.2 to "measured only, no systematic search" in §4, and a single paragraph was flattening that. It also now says what "measured" means here: n ≤ 52 and small blocks, which at k = 3 is a very short range.

## Thirty-second batch: the Galois part is a k ≥ 3 phenomenon

**Question: does the Frobenius map ever help at k = 2, or is this new?** It never helps at k = 2, and the reason is one line.

Run §2.2.2's necessity argument at k = 2. The escape is always a k-subset of the fixed field, and **Fix(h) ⊇ 𝔽_p has p ≥ 2 elements, so a 2-subset always exists** — {0, 1} when the twist is odd, {1, −1} when 2 | d and p is odd — and it always lands in a minimal orbit. So a Galois-stable minimal orbit always exists and the minimum never moves.

> **General statement: the Galois part can help only when p < k**, since 𝔽_p supplies a k-subset exactly when p ≥ k. Never at k = 2; exactly p = 2 at k = 3; p ∈ {2, 3} at k = 4; growing with k.

**Verified at k = 2** across c = 8, 9, 16, 25, 32, 64, 128 and every twist — the minimum is identical under Γ(d, 1) and Γ(d, a) in all 28 cases, **including the c = 32 and c = 128 blocks where the k = 3 minimum rises by factors of 5 and 7.** The same block, the same groups, opposite answers at the two values of k.

**And it recasts J0a.** The GL-versus-ΓL question is an unresolved assumption in the k = 2 documents bearing on attainment. Part of why it has stayed unresolved is that it never *matters* there — and now we know that is not luck about the particular constructions but a consequence of p ≥ k = 2. So **J0a's dormancy at k = 2 is an accident of the value of k**, not evidence that the assumption is harmless; and indexing the k = 2 shape space by ΓL rather than GL twists would change nothing, which is itself worth recording. Added as a fourth item to §7.

## Thirty-third batch: feeding the k = 3 insights back into the k = 2 documents

Three updates, one of which closes half an open item.

### J0a is now half settled, and provably rather than empirically

`enumeration-proof.md` J0a asked whether a matching block's twist may lie outside the field's multiplicative group. **The semilinear sub-case is now closed:** enlarging the twist from C_d to C_d ⋊ C_m cannot change any score. Enlarging a group only fuses orbitals, so no term can fall; and the intra term cannot rise either, because **{0, 1} ⊆ 𝔽_p is fixed pointwise by every Galois element** and lies in a minimum-size orbital — its stabiliser has order 2, realised by x ↦ 1 − x when 2 | d or by the translation x ↦ x + 1 in characteristic 2. Every other term of the value formula is a size product or an already-pooled cross class. So **B_safe, B_refined and every measured figure are untouched by whether the twist is read in GL(1, c) or ΓL(1, c).**

What remains is the genuinely larger case — an irreducible subgroup of GL(a, p) that is not semilinear — which the argument does not reach. J0a and `pending-checks.md` T2 both now say which half is which.

**And why it stayed dormant is now understood rather than lucky:** the escape is a k-subset of the fixed field 𝔽_p, which exists exactly when p ≥ k. Automatic at k = 2; fails in characteristic 2 at k = 3, where the semilinear reading raises the minimum by a factor of a. So the dormancy is a consequence of the value of k.

### The two coefficient rules in Part E turn out to be one rule

`orb(c, d)`'s condition `t % 2 == 0 or char2` has always read as two unrelated special cases. It is one: **the minimum orbital is c·d divided by the largest order of a setwise stabiliser of a 2-set in the affine group**, and that stabiliser (of order dividing 2) is realisable either inside the twist when 2 | d, or inside the translations when p = 2. Recorded in Part E next to the cross-coefficient pitfall.

*The same rule at general k* is a useful check on any generalisation: a stabiliser of order m | k, realised in the twist when m | d or in the translations when p | k. At k = 3 that gives the 3 | d and 2 | d factors from the twist and — from the translation side — a factor 3 exactly when p = 3, which **is** the affine-line degeneracy. So the k = 2 char-2 halving and the k = 3 affine-line failure are the same phenomenon at different k, which neither document previously connected.

### `aod` §3's contingency box gains one line

The box already says the ceilings are the dividend of 2-transitivity. It now also records a degree of freedom that is *not* hidden in them: GL versus ΓL provably changes no orbital minimum at k = 2, so the ceilings are insensitive to that choice — while at k = 3 it does change the minimum, a further respect in which the constants are contingent.

Regression after all three edits: `validate_table` and `fallback_cert` exit 0, `check_doc_figures` reports 0 dangling references.

## Thirty-fourth batch: the k = 3 configuration census

**Built as the k = 2 shape list re-analysed at k = 3, keyed by the same S-numbers, with no claim of comprehensiveness** — that is explicitly deferred, and §8 now says what a completeness argument would need.

### The finding that shapes the whole table

Measured across every shape, **the minimum 3-set orbit always lies inside a single block** — witnesses (0,1,2), (17,18,25), (22,23,26), (26,27,29), never a set spread across blocks. The reason is a degree count: an **intra** term is F·orb₃(c,d) ≈ s·c/κ, **quadratic** in n, while every **cross** term is a product of two or three part sizes, **cubic**. So

> **min₃(configuration) = min over classes of F_i·orb₃(c_i, d_i).**

**This is the largest structural difference from k = 2**, where cross terms routinely bind and most of `aod` §3 is the comparison between term types. At k = 3 that comparison collapses: the problem is to partition n and maximise the smallest part's (part size) × (block size) / κ. No balance point, no cap_F(η), no ceiling table.

### The census

| shape | k = 3 status | measured δ₃ |
|---|---|---|
| S1 single block | best available; **δ₃ ≈ 6/(κn), not 1** | 0.2000 (n = 32), 0.1429 (n = 16) |
| S2 fused, F = 2 | second; ≈ 6/(κFn) | 0.0333 (n = 46) |
| S3 matching + outside | ≈ half of S2 | 0.0160 (n = 36) |
| S6 two outside | **equal to S3**, no longer dead | 0.0160 (n = 36) |
| S4 / S7 | foreign block binds | 0.0079 (n = 35), 0.0013 (n = 33) |
| S8 / S9 / S10 | still killed; D1's margin widens (F < F³) | — |

**Three changes worth naming.** Prime powers stop being trivial — S1 gives 6/(κn), not δ = 1, so their full evasiveness is now an *external* fact from Rivest–Vuillemin rather than something the framework recovers. The matching/foreign distinction thins to "which twists are available", so **S6 stops being a dead shape** and ties S3. And the k = 2 tension between fusing to raise the cross term and not fusing to raise the intra term disappears, because there is no cross term to raise — fewer, larger blocks simply win.

### Consequences for §5

The constant now reads off the census rather than resting on the superseded ranking: **n²/κ** for prime-power n (S1), **n²/(2κ)** for n = 2c (S2 at F = 2), **n²/(4κ)** for n = c + r (S3), with κ ∈ {1, 2, 3}. The earlier ~n²/8 is the S3 row at κ = 2 — the weakest of the three.

And the supply question is **corrected in the other direction**: it is not "easier at k = 3". Odd non-prime-power n fall to S3 and inherit exactly the prime-power-representation problem of `aod` §3.5. It is the same question asked of a shape whose payoff is linear in block size rather than quadratic.

*Caveat recorded at the site:* §4.1's degree count is asserted and measured over n ≤ 46; a cross term could bind at small n before the cubic overtakes the quadratic, and the crossover has not been located. That is now the concrete first step toward completeness.

## Thirty-fifth batch: three-argument orb₃, and the law collapses to one formula

**The notation should carry what the group carries.** The block group is Γ(d, m), so the orbit function gets both parameters: **orb₃(c, d, m)**, with §2.1's law the case m = 1 and the Mersenne block reading **orb₃(32, 31, 5) = 4960** against orb₃(32, 31, 1) = 992.

**Writing it that way collapses §§2.1–2.2 into a single formula**, which is the real payoff rather than tidiness:

> **orb₃(c, d, m) = min( c·d·m / κ₃ , C(c,3) )**, κ₃ = τ·θ·γ with
> **τ = p if p = 3 else 1** (translations — the affine-line degeneracy),
> **θ = max{j ≤ 3 : j | d}** (the twist — §2.1's κ),
> **γ = m**, except in the rise case where **γ = a/q**.

The three factors are the three places a setwise stabiliser can come from: translations, twist, Galois. What had been three separate results — the orbit law, the 3 | c failure, the semilinear criterion — are three factors of one denominator.

**Verified over 104 (c, d, m) triples**, c ∈ {5, 7, 8, 9, 11, 13, 16, 17, 19, 23, 25, 27, 32, 49}, every d | c − 1 and every m | a: **0 mismatches**.

**And it explains the k = 2 formula.** At k = 2 the same reading gives τ = 2 in characteristic 2 — the translation x ↦ x + 1 swapping a pair, which is exactly `orb`'s `char2` flag — θ = 2 when 2 | d, and γ ≡ m always by J0a. So **the k = 2 orb is this formula with the Galois factor forced trivial**, and the general-k statement is: τ contributes p when p | k, θ contributes max{j ≤ k : j | d}, and γ is inert exactly when p ≥ k. That is a cleaner account of `orb`'s two-clause definition than the k = 2 documents currently give, and it arrived from the k = 3 side.

## Thirty-sixth batch: the shifted-prime condition survives at k = 3, and the census measurements were invalid

**The challenge:** the balance-point optimisation genuinely disappears at k = 3, but the shifted-prime condition should not, since the group still has to be an Oliver group. Correct — and checking it found that the census measurements for every shape with a foreign block were **invalid**.

**The error.** `build()` takes the foreign block's twist as given, and the census passed the *full* d = r − 1 — at n = 36 that is 18 = 2·3², **not a prime power**. Lemma B′ forces a foreign block's twist into the top q-group, so it must be a **q-power** divisor of r − 1. The groups measured for S3, S4, S6 and S7 were therefore not admissible configurations at all.

**Redone with valid twists, and the effect is large:**

| n = 36, `17 + 19*` | q = 3, t = 9 | q = 2, t = 2 | (invalid) t = 18 |
|---|---|---|---|
| min₃ | **57** | **19** | 114 |
| δ₃ | 0.0080 | 0.0027 | 0.0160 |

A factor of three between the two *valid* readings, entirely from the arithmetic of 18 = 2·3² — which is the shifted-prime condition doing exactly what it does at k = 2. S4 falls from 0.0079 to 0.0020, S6 from 0.0160 to 0.0027. S1 and S2 are unaffected, having no foreign block.

**So "k = 3 reduces to binary Goldbach" was wrong, and instructively so.** What k = 3 removes is the *balance-point* optimisation: with only intra terms binding, one takes roughly equal parts and there is nothing to optimise. What it does **not** remove is the shifted-prime requirement, because that comes from **Lemma B′ and the layer structure, not from the pairing** — and Lemma B′ is k-independent.

**Which n escape it:** only pure-matching configurations — S1 (n a prime power), S2 (n = F·c), and more generally any configuration all of whose parts are p-characteristic for one p. Density zero. **Every other n needs a foreign block**, so `aod` §§3.5–3.6 transfer essentially intact.

**And §5's constants were smuggling the condition in.** The S3 row's n²/(4κ) tacitly assumed t of order r — a safe-prime-like foreign block. Without it the row is r·t/κ = n^{1+θ} at best, and as small as Θ(n) when the only q-power divisor of r − 1 is 2. The table now carries a "conditional on" column: **only the S1 and S2 rows are unconditional**, and both need n of a special multiplicative form.

*The methodological point:* the invalid measurements passed unnoticed because `build()` does not enforce Lemma B′ — it constructs whatever group it is asked for. A reference implementation that accepts inadmissible configurations will silently produce numbers for objects the framework excludes, and those numbers looked entirely reasonable. The `verify_witness.g` script checks the chain explicitly for exactly this reason; the Python reference does not, and should.

## Thirty-seventh batch: orb₃ notation in the census, and the Galois part's place in it

**Notation.** Every orb₃ in §4 now carries three arguments, and §4.1's degree count is restated as F·orb₃(c, d, m) ≈ s·c·m/κ₃ so the Galois factor is visible in the term that decides the minimum.

**The substantive gap was that the census never mentioned the Galois part at all.** Filling it produced a new subsection (§4.3) with two findings.

**Where it pays: S1, and enormously.** At n = c = 2^a with a a prime power ≥ 5 the criterion of §2.2.2 is met *automatically* — d = 2^a − 1 is odd, and 3 ∤ 2^a − 1 because a is odd, so gcd(d, 6) = 1 with no extra hypothesis.

| n = 2^a | orb₃(c, c−1, 1) | orb₃(c, c−1, a) | δ₃ |
|---|---|---|---|
| 32 | 992 | **4,960** | **1.0000** |
| 128 | 16,256 | 113,792 | 0.3333 |
| 2,048 | 4,192,256 | 46,114,816 | 0.0323 |

**n = 32 attains δ₃ = 1** — all of C(32,3) in one orbit, the k = 3 analogue of S1's δ = 1 at k = 2. It happens at exactly one n, because the gain factor q = a grows logarithmically while C(c,3)/c² grows linearly; §2.2.3's nontriviality condition a ≤ (c−2)/6 is the same fact from the other side.

**Where it costs: everywhere else, and this is the finding.** Using C_a on top forces Γ/Γ₁ to be a q-group with **q | a**, so q becomes the configuration's top prime — and Lemma B′ then requires **q | r − 1 for every foreign block**. Worked at a = 5: foreign blocks 11, 31, 41 are all admissible but all stuck at twist t = 5, contributing only 5r/κ₃, **linear in n**. So a configuration that spends its top prime on the Galois gain buys a superb matching block and a foreign block that immediately binds.

> **This is the first place in the census where improving one part actively damages another**, and it has **no k = 2 counterpart** — at k = 2 the Galois part buys nothing (J0a), so it is never worth spending a top prime on. It is also why S1's δ₃ = 1 at n = 32 does not propagate to any composite n.

**Consequence for the ranking:** the Galois part is worth using only in a **pure-matching** configuration — S1, or S2 with F a power of the same q. The moment a foreign block is present, q must be small enough to divide a and is therefore far too small to give that block a twist of order r.

## Thirty-eighth batch: full density at k = 3 is a classified finite list

**The question was whether c = 8 and c = 32 are the only blocks transitive on 3-subsets. They are, and it is a classical theorem — so this closes rather than opens.**

The relevant property is not 3-transitivity but the weaker **3-homogeneity**, transitivity on 3-*subsets*. The two genuinely differ here: |AGL(1,8)| = 56 = C(8,3) is far below 8·7·6 = 336, so it cannot be 3-transitive, yet it is transitive on 3-sets.

> **Kantor (1972), building on Livingstone–Wagner (1965).** For n ≥ 6 a 3-homogeneous but not 3-transitive group is **AGL(1,8), AΓL(1,8), AΓL(1,32)**, or contains PSL(2,q) with q ≡ 3 (mod 4). For n ≤ 5: A₄ and AGL(1,5).

PSL(2,q) is not solvable and Oliver groups are, so **the solvable 3-homogeneous groups of degree ≥ 5 are exactly AGL(1,5), AGL(1,8), AΓL(1,8), AΓL(1,32)** — degrees **5, 8, 32**.

**The computation agrees exactly.** Searching every prime power c ≤ 4096 and every admissible (d, m) for orb₃(c, d, m) = C(c,3) returns precisely c ∈ {5, 8, 32} — Γ(4,1), Γ(7,1) and Γ(31,5), the last being the Mersenne block. Two are sharply transitive on 3-sets.

**Three things this settles.**

1. **The contrast with k = 2 is sharp and now quantified.** δ = 1 holds at every prime power when k = 2 (an infinite family, and the reason S1 is trivial there); at k = 3 it holds at exactly three blocks; and **at k ≥ 5 never** — Livingstone–Wagner give k-homogeneous ⟹ k-transitive for k ≥ 5 with k ≤ n/2, and solvable k-transitive groups have degree ≤ 4. So the homogeneity/transitivity gap that c = 8 and c = 32 exploit exists only at k ≤ 4.
2. **It explains §2.2.3's nontriviality condition.** The Mersenne family gains a factor q at every member, but only at c = 32 does the gain land exactly on the cap — a ≤ (c−2)/6 holds with equality at a = 5 and strictly after. So c = 32 is the *last* block reaching full density at k = 3, and c = 128 already sits at 1/3.
3. **The S1 census row is corrected**: δ₃ ≈ 6/(κ₃n) → 0 *except* at c ∈ {5, 8, 32}.

Written up as §2.4, with the status table marking it **classified** rather than measured — the only row in the note whose completeness rests on a published classification rather than on our own search.

## Thirty-ninth batch: §3 rewritten around the classification, and m pinned down in the census

**§3 had gone stale the moment §2.4 was written.** It argued that the k = 2 constants exist because AGL(1, c) is 2-transitive, that "the k = 3 analogue would need 3-transitivity", and that since no solvable 3-transitive groups of degree > 4 exist the mechanism is "excluded at k ≥ 3, not merely unfound". **The middle step is wrong** — what full density needs is 3-*homogeneity*, which is strictly weaker, and three solvable groups have it. Reaching for 3-transitivity was reaching for more than the argument needs, and it made the conclusion look stronger than it is.

**Rewritten as three subsections**, absorbing §2.4:

- **3.1** — what full density actually requires (k-homogeneity), Kantor's classification, the solvable list c ∈ {5, 8, 32}, and the computational agreement. Also relocated here: why c = 32 is the *last* such block, which is §2.2.3's nontriviality condition seen from the other side.
- **3.2** — why the density still goes to zero, by an order bound needing no classification: |Γ| ≤ c² log₂ c against C(c,3), so δ₃ = O(log c / c). The three exceptional blocks are exceptions at small c, where c² log c has not yet been overtaken by c³/6. The k = 2 contrast is now stated exactly: there |Γ| ≈ c² and C(c,2) ≈ c²/2 are the *same order*, so the bound is no obstacle; at k = 3 the denominator gains a factor of c and the numerator does not. Plus the k ≥ 5 statement, where Livingstone–Wagner closes the gap entirely.
- **3.3** — the consequence for `aod` §3, unchanged in substance, with the GL/ΓL remark sharpened: at c = 32 that choice is the difference between δ₃ = 1/5 and δ₃ = 1.

**And m was undefined at its point of use in the census.** Two facts pin it down, now stated before the table: a **foreign block has prime size**, so a = 1 and m = 1 is forced — every foreign entry is orb₃(r, t, 1) and the only choice is the q-power twist. And on a **matching block, intermediate m is useless** by §2.2.2, since a proper Galois subgroup leaves a fixed field of at least p² ≥ 4 elements to supply a stable 3-set. So **the only live values are m = 1 and m = a**, and m appears as a genuine choice only in the S1 and S2 rows, where §4.3 decides it.

## Fortieth batch: consistency sweep of §§5–7

Not a rewrite — six surgical fixes for things the later sections had invalidated.

**§5.** The constant table said κ ∈ {1, 2, 3}; §2.3's κ₃ = τ·θ·γ can be **6** (τ = 3 when 3 | c, θ = 2 when 2 | d), so the range was wrong. Renamed to κ₃ throughout and corrected. The S1 row now records the three blocks where it reaches C(n,3) outright rather than n²/κ₃ (§3.1), and m ∈ {1, a} is noted as a choice §4.3 makes. Dropped a residual "the earlier ~n²/8 figure was…" aside.

**§6.** Two rows carried the retracted fusion argument. The **D2** row claimed D2 "acquires a k = 3 analogue for matching blocks, which at k = 2 has no counterpart" — that was the same-position-triples claim; replaced with what is actually true (D1's margin widens to F < F³, D2 inherits the A18 gap). The **Part E** row cited "same-position triples" as a sub-case to work out; replaced with an honest statement that the within-class sub-cases are unworked and, by §4.1, none of them binds. The **Part F** row said orb₃ ≤ c²/3, which holds only when 3 | d; corrected to c(c−1)/κ₃ with the constant flagged as not re-derived.

**§7.** Item 2 said "fusion and prime-power blocks are k = 2 luxuries", half of which is the retracted claim; cut to the 3^a blocks alone, which is the part that survives and which still makes the intended point — a structure that is benign at k = 2 becomes an obstruction one dimension up. Item 4 was phrased as a retraction of the Goldbach reading; restated forward as the finding itself, that the arithmetic difficulty is *not* the price of chasing constant density, since the shifted-prime condition comes from Lemma B′ rather than from the pairing.

*Nothing was expanded*, and where cleaning up would have meant new work — the within-class cross sub-cases at k = 3, Part F's constant — the entry now says so rather than guessing.

## Forty-first batch: the n = 133 worked example

Added as §4.5, because it exhibits §4.3 and §4.4 interacting and shows the design move that resolves them.

**The configuration.** n = 133 = 32 + 101, chain Γ₂ = 𝔽₃₂, Γ₁/Γ₂ = C₃₁ × C₁₀₁ (cyclic, gcd(31,101) = 1), Γ/Γ₁ = C₅ × C₂₅ (a 5-group). So p = 2, **q = 5**. Scores: orb₃(32,31,5) = 4960 = C(32,3), orb₃(101,25,1) = **2525** — verified by direct orbit computation, not just the formula. **min₃ = 2525**, δ₃ ≈ 0.0066. Without the Galois part the same split gives 992, so the Galois is worth a factor of 2.5.

**The design principle is the reason to keep the example.** Fixing the 32-block forces q = 5, so Lemma B′ requires 5 | r − 1 and the foreign twist is the 5-part of r − 1. Asking only for 5 | r − 1 gives generically **t = 5**, an intra term of 5r — linear with a tiny constant, so the foreign block is either too small to contribute or too large to afford, since C(n,3) grows as n³. **Asking instead for r ≡ 1 (mod 25) lifts the twist to 25 for no extra size**, a factor of five. The table shows mod-5 rows decaying steadily while r = 101 jumps fourfold over its neighbours purely on the arithmetic of 100 = 4·25.

And it shows the other end: r ≡ 1 (mod 125) **overshoots** — at r = 251 the foreign block scores 31,375 but the 32-block's cap of 4960 now binds and the extra 150 points of n buy nothing. So the target is to match the foreign intra term to the matching block's cap, r ≈ 199 would be ideal, and 101 is the best prime below the crossover.

**Also recorded:** 133 has *no* balanced two-part split into prime powers. The options are {2,131}, {5,128}, {8,125}, {32,101}; {8,125} is inadmissible because two matching blocks must share one p and 8 is a 2-power against 125's 5-power; {2,131} dies on the size-2 block; {5,128} forces 5 to be foreign, worth 10. So 32 + 101 is nearly the only viable split, and the near-balanced 43 + 43 + 47 is second at 1081, less than half.

**The caveat is stated prominently and is a real difference from k = 2.** There, claims of this kind rest on `mu_enumerate_v2.py` enumerating the whole shape space with `brute.py` as an independent check. **Here there is no enumerator.** The comparison is a search over a hand-specified family — ≤2 matching parts, ≤2 foreign parts, one top prime — and it leans on §4.1's measured-not-proved claim that cross terms never bind. "Optimal" means best in the family searched. The status table marks the section accordingly, and building a k = 3 enumerator is §8's first item.

## Forty-second batch: §4.3's coupling is a presumption, not a prohibition

§4.3 concluded that the Galois part is worth using "only in a pure-matching configuration", on the ground that fixing q to a prime dividing a leaves every foreign block with a twist too small to matter — the worked table showing r = 11, 31, 41 all stuck at t = 5.

**That overstates it, and §4.5 is the counterexample sitting two sections later.** The twist is stuck at t = 5 only because 25 ∤ r − 1 for those particular r. Choosing the foreign block from the primes with **r ≡ 1 (mod q²)** lifts the twist to q² at no cost in size, and the trade can then come out positive: at n = 133 = 32 + 101, since 101 − 1 = 4·25 the foreign block scores 2525 instead of 505, and the Galois part is worth a factor of 2.5 overall.

So §4.3 now says the coupling is **a strong presumption against combining the two, not a prohibition** — it costs a specific congruence condition on r, and that condition is satisfiable — with a forward pointer to §4.5. The "consequence for the ranking" paragraph is softened in the same way: pure-matching *usually*, and "S1's δ₃ = 1 does not propagate to *most* composite n — but at the n where the congruence can be met, it partially does".

*Worth noting as a pattern:* the section was written before the worked example existed, and its generalisation was drawn from the three smallest foreign blocks to hand — which is the same sampling failure as the semilinear claim in the twenty-fifth batch, where every convenient example satisfied an escape clause. Small samples of arithmetic objects reliably miss the congruence-selected cases, because those are exactly the sparse ones.

## Forty-third batch: what the sandwich would look like at k = 3

Recorded as §4.6, prompted by asking whether the n = 133 construction is a refined-mode or safe-mode object. **It is neither — it is fallback-free** — but working out why produced three findings a k = 3 implementation would otherwise hit blind.

**n = 133 is fallback-free in both senses.** The matching twist is 31 and the foreign prime 101, so gcd(31, 101) = 1 and **Lemma C never bites**; refined and safe agree. It is also consistent in the §4.3 sense — the Galois part needs q = 5 and the foreign twist needs q = 5, the *same* q.

**1. k = 3 adds a second fallback axis with no k = 2 counterpart.** The Galois gain is per-block (it depends on that block's a) while **the top prime is global**. Matching blocks 32 (a = 5) and 128 (a = 7) would each be credited their Galois gain by a per-block scoring, but q cannot be both 5 and 7. Those are fallback configurations in a new sense, independent of Lemma C's, and a certificate would need conditions for both.

**2. The k = 2 SAFE cap does not transfer, and this is the serious one.** SAFE works at k = 2 because **orb(c, c−1) = C(c,2) exactly** — the crude bound is *attained* at full twist, so F·C(c,2) is tight except where Lemma C bites. At k = 3, C(c,3) ≈ c³/6 against an achievable ≈ c², so a C(c,3)-style cap over-credits by a factor of order c/(6a) and the sandwich would be a factor of n wide.

> **And the sharper form is §3.1 in a third role:** C(c,3) is attained exactly at c ∈ {5, 8, 32}, so the three solvable 3-homogeneous blocks are precisely where the naive SAFE cap is tight. The classification that limits full density also limits how crude a safe scoring can afford to be.

So **SAFE and REFINED largely collapse at k = 3** — a usable safe scoring is F·min(c·d·m/κ₃, C(c,3)), essentially the true formula — and the residual gap is the global-q coupling rather than twist-stripping.

**3. A soundness trap, named before anyone writes code.** A k = 3 SAFE that *ignores* the Galois part, by analogy with k = 2 where it is provably inert (J0a), would credit orb₃(c, d, 1) — **smaller** than the achievable orb₃(c, d, a) by a factor of q on the §2.2.2 blocks. Not a loose upper bound; not an upper bound at all. Any k = 3 scoring must carry m, which is the practical reason §2.3's notation takes three arguments.

§6's Part E′/E″ row is updated to point at this.

## Forty-fourth batch: §5, the additive engine at k = 3

Written fresh as the counterpart of `arithmetic-of-density.md` §3, with §§6–9 renumbered to make room. §§4.5–4.6 belong here and can be folded in later.

**The central move is a per-part efficiency.** Define **e = F·orb₃(c, d, m)/s²** with s = F·c the part size — the k = 3 analogue of η, stripping out size so what remains is the part's arithmetic. Then vᵢ = eᵢsᵢ², and maximising min vᵢ subject to Σsᵢ = n is one line: set the values equal, sᵢ ∝ 1/√eᵢ, giving

> **m\*₃ ≈ n² / (Σᵢ 1/√eᵢ)²**, at sᵢ = n(1/√eᵢ)/Σⱼ(1/√eⱼ).

Three things drop out. **Fewer parts is always better** — each part adds a positive term to the sum, so §4's measured ranking now has a reason. **Balance is by efficiency, not size** — a low-efficiency part wants to be made *larger*, which is the opposite of the naive reading. And the formula has the same shape as `aod` §4.2's two-foreign-block cap 1/(√m₁+√m₂)², which turns out not to be a coincidence: that cap is the k = 2 instance of this same allocation argument, surfacing there only in the one shape with no cross term to compensate.

**The efficiency table locates the whole difficulty in one row.** A matching block always has e = d/(cκ₃) ≤ 1/κ₃, bounded and decided by congruences. A foreign block has e = η₃/κ₃ with **η₃ = t/(r−1)**, which is exactly `aod` §3.6's shifted-prime quantity. So everything conditional enters through the foreign row and nowhere else.

**And the Galois row is what has no k = 2 counterpart:** at k = 2 every part has e ≤ 1, since C(c,2) is attained at full twist, so the allocation is a competition among bounded quantities. At k = 3 a Galois block reaches **e ≈ 4.84** (c = 32, d = 31, m = 5), so it wants to be made *smaller* than an equal share — and since it also fixes the top prime (§4.3), allocation and arithmetic are coupled in a way they are not at k = 2.

**The two-part ceiling** is m\*₃ ≤ n²/(√κ_c + √(κ_r/η₃))², which at κ = 1 and η₃ = 1 is **n²/4** — the same functional form as `aod` §3.3's cap_F(η) at F = 1, with δ replaced by m\*₃/n². Measured against it, the best two-part configurations run at roughly a quarter of ceiling (n = 90: 602 against 2025; n = 250: 5050 against 15,625), the shortfall being arithmetic rather than structural.

**§5.5 states what the engine consumes**: a matching block of prescribed size (Bateman–Horn, unchanged) and a foreign prime with η₃ bounded below (the shifted-prime ladder, unchanged, same θ = 1 endpoint). What it does *not* consume is the balance-point analysis — no ceilings by residue class, no cap_F, no mod-24. So the k = 3 engine is **the k = 2 engine with the optimisation removed and the supply questions intact**, which is the precise form of §4.4's claim that k = 3 is not arithmetically easier.

§6's constant table now defers to the allocation formula rather than restating a per-shape list.

## Forty-fifth batch: §§4.5–4.6 moved into §5, and a note on `check_doc_figures` coverage

**Moved.** The n = 133 worked example and the sandwich discussion are now **§5.6 and §5.7**, at the end of the additive-engine section where they belong — the first is §5.2's allocation problem worked at a single n, the second is what the allocation implies for a scoring function. Seven references updated across the note, including the status-table rows, §4.3's forward pointer, §5.4's cross-reference and §7's Part E′ row. Zero references to the old numbers remain.

**Yes, `check_doc_figures.py` covers `three-uniform-note.md`** — it is picked up by the `*.md` glob and is *not* in `NOT_OURS` or `PREFIXED_ONLY`, so it gets the full five passes with its own sections registered as anchors. Worth knowing since the note was written after that machinery.

**And it earned its keep on this pass.** The refs pass flagged `three-uniform-note.md` L257 citing **§2.4**, which stopped existing when §2.4 was folded into §3.1 two batches earlier. It surfaced as `[elsewhere]` rather than `DANGLING` — §2.4 exists in other documents — which is the intended behaviour but means it only shows without `--quiet`. Repointed to §3.1.

*Worth noting about that class of error:* renumbering a section breaks inbound references silently, and the `[elsewhere]` classification hides exactly the case where the number is still valid **somewhere** — which is the common case in a project where five documents all have a §3. A stricter mode that treats an unprefixed same-document reference as dangling regardless of other documents would have flagged it at full volume. Not worth building now, but it is the residual gap in the refs pass.

## Forty-sixth batch: the mod-12 / mod-24 structure at k = 3

Added as §5.6, with the worked example and sandwich pushed to §§5.7–5.8. The Bateman–Horn systems are identical to k = 2's, so nothing there was re-derived; what changed is the congruence law on a matching block's twist, and the S4/S5/S7 competition that follows from it.

**Two effects, and the first has no k = 2 counterpart.**

*The block's own class.* At k = 2 an odd block at full twist always reaches its cap — orb(c, c−1) = C(c,2) exactly, the halving compensating precisely. At k = 3 there is no such identity, because κ₃ takes three values:

> **orb₃(c, c−1, 1) = c(c−1)/3 if c ≡ 1 (mod 3), else c(c−1)/2.**

So a block with 3 | c − 1 is **penalised by 3/2 before any fusion**, purely for having a twist divisible by 3. At k = 2 a larger twist is never worse; here it can be.

*The fusion cut.* A cyclic-layer fusion forces the twist to the odd part of c − 1. With 2^v ‖ c − 1 the cost is **2^{v−1}** at k = 2 always, and at k = 3 **2^{v−1} if 3 ∤ c − 1, but 2^v if 3 | c − 1** — one factor of two worse exactly on the blocks already penalised. Verified at every odd prime power c ≤ 83.

**Combined, the good class narrows.** At k = 2 it is c ≡ 3 (mod 4), and c ≡ 3, 7, 11 (mod 12) are equally good since only v matters. At k = 3 the mod-3 penalty separates them and **c ≡ 11 (mod 12) is strictly best** — full value c(c−1)/2 *and* free fusion — while c ≡ 7 pays twice over. So the governing modulus rises from 4 to 12, with mod 24 entering to pin v exactly as at k = 2 (c ≡ 5 mod 24 has v = 2 against c ≡ 17's v = 4, a fourfold difference in fusion cost).

**And that is what changes S5 versus S7.** The shapes still differ by where the swap lives — cyclic layer means a cut twist but a free q, top layer means a full twist but q = 2 forced. The *shape* of the trade is unchanged; the *magnitude* is not. The matching-side ratio S5 : S7 is 2^{v−1} at k = 2, so at c ≡ 3 (mod 4) it is 1 and S7 wins outright on the free q. At k = 3 it is 2^{v−1} or **2^v**, so S7's free win survives only at c ≡ 11 (mod 12) — a quarter of the odd blocks rather than a third — and on the rest S5's advantage is one factor of two larger than the k = 2 analysis would predict.

**Deliberately not done**, and said so at the site: density and existence counts for these classes. The systems are k = 2's, so `aod` §§3.4–3.5 apply verbatim; only the *ceiling* comparison would need redoing, and at k = 3 that is §5.2's allocation formula rather than cap_F(η).

## Forty-seventh batch: the mod-24 ceiling table at k = 3

Added as §5.7, the counterpart of `aod` §3.3.5. The additive systems and their local obstructions are identical to k = 2's, so **the η column is imported unchanged** and only the ceiling it implies is recomputed.

**A name for the reported quantity.** δ₃ = m\*₃/C(n,3) tends to 0 and is useless as a class invariant. The asymptotically constant quantity is **β₃ := m\*₃(n)/n²**, and that is what the table reports. Noted alongside: at k = 2, δ = m\*/C(n,2) ≈ 2m\*/n², so β₂ = δ/2 in the same units — which matters for reading the two tables against each other.

**The identity that fell out.** With κ_c = 2 and κ_r = 1 — matching twist not divisible by 3, foreign twist coprime to 6 — every row satisfies

> **β₃ = cap_F(η)/2 exactly**, since 1/(√(2F) + √(2/η))² = ½·η/(1 + √(Fη))².

So in the generic case **the k = 3 ceiling is exactly half the k = 2 ceiling as a fraction of n²** — equivalently, since β₂ = δ/2, the two are *equal in absolute terms*: **m\*₃ ≈ m\*₂ at the ceiling**. Not a coincidence, but §4.1 restated: at both k the binding term is a block's intra term, of order c², and only κ differs.

**A second column with no k = 2 counterpart.** κ_c = 3 whenever 3 | c − 1 (§5.6.1), costing 12–19% depending on the row. There is no analogous column at k = 2 because κ₂ takes only one value on an even twist.

**Three rows are flagged provisional, and the flag is the honest part.** Rows 7, 15 and 23 are decided at k = 2 by a tie between the fused and unfused rungs — cap_B(1/4) = cap_C(1/2) identically, a coincidence at η = 1/2 and nowhere else. **§5.6.4 changes exactly that comparison**, since the S5 : S7 matching ratio becomes 2^v rather than 2^{v−1} when 3 | c − 1, so the k = 2 tie need not survive. The entries take the S7 reading at the k = 2 η and are therefore a lower bound on those rows. Redoing them needs §5.6.3's c mod 24 analysis run against each rung, which is not done.

Also: §5.4's unconstrained two-part ceiling now points forward to §5.7 as its by-class version, and §6's constant table gains a β₃ column.

## Forty-eighth batch: the balance point is not the middle, and the table's share column was mislabelled

**A label error, found while auditing for equal-balance claims.** §5.7's share column was headed **x\* = c/n**, copying `aod` §3.3.5. But what the allocation formula produces is the *part's* share s\*/n, and for a fused rung that is F·c/n — twice the block fraction `aod` reports. The column is now headed **s\*/n**, with the conversion stated.

**Correcting it reverses the conclusion.** In the same units, the κ_c = 2 balance points are **identical to k = 2's, row for row** — 0.50000, 0.36603, 0.58579, 0.50000, 0.44949, 0.36603. That is forced rather than coincidental: the allocation sᵢ ∝ 1/√eᵢ depends only on the *ratio* of efficiencies, and the factor of two relating β₃ to cap_F cancels out of it. So **k = 3 does not flatten the balance towards equal parts.**

**What does move it is the mod-3 penalty, and it moves it the other way.** A κ_c = 3 matching block is less efficient, so by §5.2 it needs a **larger** share — 0.55051 against 0.50000, 0.63397 against 0.58579. Only in row 5, 17 does it land on exactly 1/2.

**Four statements corrected.** §4.4, §6 and §3.3 each said some version of "only intra terms bind, so one takes roughly equal parts and there is nothing to optimise", and §5.1 opened "there is no balance point in the k = 2 sense". All four conflated two different things: the **term-type comparison** (intra versus cross), which genuinely disappears, and the **allocation between parts**, which does not. They now distinguish the two and point at §5.7.

*The document was internally inconsistent on this for several batches* — §5.7's own share column ranged 0.366 to 0.586 while three other sections asserted equal parts — and nothing caught it, because no check compares a claim in prose against a number in a table. That is the same class of gap as the k = 2 `--pass scope`, which catches stale *figures* but not stale *statements*.

## Forty-ninth batch: a broken table, and a pass to catch the next one

**The break.** §5.7's table gained two columns in the previous batch and the separator row did not — 8 columns in the header and body, 7 in the separator. Markdown then renders the whole table as a paragraph of pipes. Fixed.

**Nothing would have caught it.** Every figure in the table still parses, every reference still resolves, so `--pass figures` and `--pass refs` are both clean on a table that has ceased to be a table. This is the same shape of gap as the missing-section case: the *content* is intact and only the structure is broken.

**Added `--pass tables`.** It checks header, separator and body rows for a consistent column count across every markdown table in every document. Two details were needed to make it usable rather than noisy: **escaped pipes** (`\|`) are literal cell content, so they must be masked before counting or every table containing |Γ| reports a false mismatch; and **box-drawing rules** (`+---+`) in the ASCII diagrams of `orbital-evasiveness-notes.md` match the separator pattern, so lines containing `+--` and single-column "tables" are skipped.

**Audit result: 15 tables across the documents, all well-formed** after the §5.7 fix. Negative control passes — removing one `---` from a separator produces exactly one TABLE finding naming the right line.

*Worth noting the sequence:* the previous batch's edit was a correctness fix that introduced a formatting break, and the formatting break was invisible to every check that existed. Both halves of that are typical — edits that add columns are exactly the edits that forget separators, and structural damage is what a content-oriented checker misses.

## Fiftieth batch: §6 on escapes, and the last of the "balance point disappears" residue

**The stale clause.** §5.5 still read "what it does *not* consume is the balance-point analysis of `aod` §3.2–3.3: no ceilings by residue class, no cap_F, no mod-24 classification". Every clause of that is now false — §5.7 *is* a ceiling table by residue class, §5.6.3 *is* a mod-24 classification, and the balance points are literally k = 2's. Rewritten: what k = 3 does not consume is the **term-type comparison**, and "what looked at first like the disappearance of the whole optimisation is the disappearance of one of its two ingredients." Same correction applied to §4.4's summary sentence.

**§1 and §5's blurb now say so up front**, which is where a reader would otherwise form the wrong expectation. §1 gains: replacing the scoring function changes which term binds, and one might expect the balance-point analysis to go with it — it does not, since the allocation depends only on the *ratio* of efficiencies. So "the whole apparatus up to **and including the optimisation** is k-agnostic", and what is k-specific is the map from a part's arithmetic to its efficiency, not what is done with the efficiencies.

**New §6, paralleling `aod` §4.** Three escapes, with §5.8's worked example moved in as §6.2 and the sandwich discussion renumbered to §5.8:

- **6.1 the Galois escape** — hold the partition fixed, turn on Γ(d, a). Available only at 2^a with a a prime power ≥ 5, and it fixes the top prime, so it pays off only when the foreign prime satisfies **q² | r − 1** rather than merely q | r − 1. **No k = 2 counterpart**, since the Galois part is inert there.
- **6.2** the same at n = 133.
- **6.3 the full-density blocks** c ∈ {5, 8, 32}. Worth stating as an escape because of the contrast: **a phenomenon that is generic at k = 2 — δ = 1 at every prime power — becomes a three-element list at k = 3.** That is the sharpest single illustration of the difference between the two.
- **6.4 the Fermat escape**, unchanged in mechanism but worth *one factor of two more* at k = 3 by §5.6.4, with the free-S7 class narrowing from c ≡ 3 (mod 4) to c ≡ 11 (mod 12).
- **6.5** why none of them moves the asymptotics.

Counts are recorded as order-of-magnitude (O(n/log n) for 6.1 and 6.4, finite for 6.3) and the status table says so — unlike `aod` §4.3, these have not been converted from representation counts to counts of n.

## Fifty-first batch: consistency sweep of §§7–10

Ten edits, all of them removing statements the later sections had overtaken. No expansion.

**§7.** The constant table now notes that §6's escapes exceed every row where they apply — which is what makes it a statement about the balanced family rather than about n, the same caveat `aod` §3.3.5 carries. Minor wording on the allocation sentence.

**§8.** Four rows were stale.
- **Part A** said "the min is still over term types"; by §4.1 only the 3+0+0 terms ever bind, so the min is over those alone.
- **`aod` §3** said "does not transfer". Half of it does: the term-type comparison and the δ constants do not, but the ceilings by residue class, the mod-24 classification and the balance points all do, recomputed as §§5.6–5.7 with β₃ replacing δ.
- **`aod` §3.5–3.6** still carried "what drops away is the balance-point analysis" — the last surviving copy of that error. Now reads "transfers intact. Nothing here needs re-deriving."
- **A row for `aod` §4 was missing entirely** now that §6 exists: transfers with one addition, the Fermat escape surviving with a larger prize, the full-density blocks shrinking from an infinite family to three, and the Galois escape new.

**§9.** Item 1 conflated two claims. The *constants* are contingent on solvable 2-transitivity; the *optimisation* is not, and survives verbatim with balance points included. Reworded to "it is the block, not the optimisation, that k = 3 takes away", which is both true and the sharper statement. Item 4's closing clause "what k = 3 removes is the balance-point optimisation" corrected to "the term-type comparison". Header said "three things" over four items.

**§10.** Item 2 asked for something already done — §2.2.2's criterion was proved necessary as well as sufficient — so it is trimmed to the stabiliser step, with the two genuinely untested clauses named (gain factor at a = 25, m < a at a = 10, both out of computational reach). Item 1 gains the k = 3 enumerator as the other half of completeness, since its absence is exactly why §6.2's "optimal" is qualified. Two items added: finishing rows 7, 15, 23 of the ceiling table, and converting §6's escape counts from representation counts to counts of n.

All passes clean afterwards, including the new table pass at 89 tables.

---

## Items inherited as closed from earlier passes

*Carried over from `pending-checks.md` so that file can be forward-looking only. Detail for these is in `session-log-3.md`.*

- **A0. What the extended v4 run confirms.** Every structural hypothesis holds at n ≤ 1572; v4 ≥ v2 at all 1,295 common values. Now re-run automatically by `validate_table.py`.
- **A0c. The within-class cross coefficient.** Stated as "F for odd q, F/2 for q = 2"; the rule is keyed on **F's parity**, not q's. Smallest witness n = 15 (`p=5 q=2: 3x5`, q = 2 but F = 3). Both enumerators were already right; prose corrected in five places. **Reopened and re-closed 2026-08 (second pass): the correction had reached five places and missed three more** — see A13.
- **A1. The s = 4 and s = 5 branches.** Dissolved in range at v4's n ≤ 1572 frontier: the floor rose to 0.051813, so s ≤ 1/√δ − 1 = 3.393 and only s ≤ 3 is reachable, where E.1/E.3(iii)/E.4 close everything. **Recheck at each extension** — the trigger is the first n with δ ≤ 1/16. ***The trigger has now fired.*** At v4's n ≤ 2000 frontier the δ ≤ 1/16 set is **7 values** — n = 527, 1159, 1175, 1739, 1763, 1817, 1943 — against the 3 recorded here, and the floor has fallen to 0.045742 (n = 1817). That still gives s ≤ 1/√δ − 1 = 3.68, so **s ≤ 3 and the branches remain dissolved** — but the margin to δ = 1/25, where s = 4 reopens, is now 0.0457 against 0.0400 and one more extension could close it. See R8.
- **A3. "Blocked at one q, available at another".** The congruence half is trivial (the degenerate q are the prime divisors of (n−1)/2, at most log₂n of them); the rest is Hypothesis (H) restricted to one q, not a separate item.
- **A4a. Theorem 2.3's two-part reduction.** Reclassified as a Goldbach-tier statement rather than a gap in a proof; nothing depends on it but the O(n) cost claim for B₀.
- **A5. The expired-scope sweep.** 41 range-scoped absolute claims read against v4; two expiries found and fixed — the weak values are no longer all n ≡ 11 (mod 12) (the minimum is now n = 1159 = 19·61, a *multiplicative* value), and Part I's low-density tail figures are structurally wrong rather than merely stale. Closed as an item, but budget **one reading pass per major extension**: `validate_table.py` and `check_doc_figures.py --pass scope` catch mechanical and whitelisted claims, neither catches a claim about a *mechanism*, and that is the kind that expired here.
- **A6. `ladder_verify.py` scans both F = 2 rungs.** Rungs B (cyclic, odd-q efficiency) and B′ (top, q = 2, η = 1/u) added to the three-part branch; worklist halves 436 → 213 at N = 20,000; the per-residue diagnostics move **only** at fused-rung residues and not at any even one. Two follow-ups below.
- **A7. The n = 1175 two-foreign witness.** Moved under v4; S6 now has **zero** winners in range, confirmed to n = 1572. Now checked automatically.
- **A8. The two `ladder_verify.py` follow-ups.** The n ≡ 11 (mod 24) diagnostic is not anomalous — the fused rungs lift only the intra term, and every rung-B class minimum is foreign-bound, so residue 11 is the one the model predicts should not move. And §3.9.2's pre-convention table is gone, leaving one measurement under one window convention. What survives is the substantive gap at residues 7 and 15, now stated as such in §3.9.2 rather than as a pending item.


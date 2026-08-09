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


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


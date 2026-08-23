# Verification lessons

*What this programme's checking apparatus has learned about its own failure modes. `pending-checks.md` says what to run; this says why the checks are shaped as they are, and what kinds of defect they exist to catch. Nothing here is owed work — every item is a standing conclusion, stated as current understanding rather than as history.*

*The audience is whoever next writes or revises a check. The single most useful thing in the file is §1: the taxonomy of where errors in this framework have actually come from, which is not where one would guess.*

---

## 1. Four sites where a compact argument fails, and the check each needs

A step compressed to a clause tends not to survive being written out. The framework's structural steps have failed in four distinguishable ways, and the four need different checks — which matters because the cheap checks cover the first three and the fourth is where the largest defect lived.

**Site 1 — reasoning over the wrong partition of cases.** A clause quotes a small or regular group's behaviour as if it bounded every admissible one; or the partition is *F* odd versus *F* even and the sentence's own arithmetic silently selects one branch. *The check: ask which cases a clause was verified on, and whether its quantifier is wider.*

**Site 2 — transcription from proof to statement.** A proof establishes "share ⟹ outside twist trivial" and the sentence recording it claims "no share". The proof is correct and the statement stronger; the discrepancy survives because the statement is only ever tested against the case its proof did cover. *The check: read each lemma's statement against its own proof's conclusion, independently of whether the proof is believed.*

**Site 3 — contradiction between artefacts nobody compared.** An enumerator implements the correct reading and finds 125 winners of a shape while a census row asserts the shape wins nowhere — and a validator prints both figures a few lines apart in the same report on every run. *The check is cheap and mechanical — compare each prose claim against the artefact that would contradict it — and it is the one most likely to be skipped, because neither artefact looks wrong on its own.*

> **The commonest form of site 3 is a document contradicting itself, and no automated pass reaches it.** A figure check compares a document's numbers against the *table*; it has no notion of a document's own derivations, so a penalty column contradicting a worked example two paragraphs above it passes every pass. Reading the argument does not catch it either, because the contradiction is in a table and reading prose does not check the arithmetic beside it. **Both known instances sat in tables**, and both survived several readings. The cheap habit, in the absence of tooling: when a section states a rule in bold, check the section's own tables against that rule before checking anything else.

**Site 3b — an argument the project already contains, made again and made wrong.** A correction propagates to the places that *state* it and not to the places that *use* it in passing; worse, a document set can then acquire two independent wrong versions of an argument whose correct version it already holds. The instance: a parity dichotomy on a foreign orbital was derived correctly in one note, and two later documents each re-derived it wrongly, in opposite directions, one of them costing a headline constant a factor of two. Nobody consulted the existing version; each wrote the plausible thing. *The check: before deriving a step, grep for it. And after any structural correction, grep for the **old rule stated as a premise**, not for the numbers it changed.*

**Site 4 — a claim no artefact can contradict, because every artefact derives from it.** This is the important one. A condition asserted in prose, implemented in the enumerator's cap, re-derived by the validator from witnesses that cap selected, and relied on by both certificates, is supported by four artefacts and one source. No cross-comparison can fire; site 3's check runs and passes. Such a defect can also be **invisible to the argmax** — under-scoring a shape that loses everywhere, while every check in the battery validates winners — so it is fully present and detectable at the smallest instance and changes no recorded value for dozens of degrees.

> *The check for site 4 is to build the object from first principles and compare against the scored value* — not to compare two artefacts that share a derivation. That is what the shape-realisation checks do, and it is why **their control run matters more than their green run**.

**An independent reading that runs sites 1–3 should be assumed to leave site 4 untouched.** This is not speculation: a full second reading by someone with no prior exposure returned findings that were *all* site 3, while a site-4 defect sat in the theorem statement, in the enumerator's cap and in the certificate's conditions throughout.

### 1.1 What follows for where to look next

Ranked by exposure, the claims with no artefact behind them share one property: **each is a claim the artefacts either derive from or do not reach.** In order —

1. **Completeness of the shape space.** A missing shape has no witness to contradict it, so it is site 4 by construction. Shape-level checks narrow this only for the fused matching class.
2. **The one surviving cyclic-layer restriction (Lemma C's strip).** The place a correction in the *other* direction would show.
3. **Realisability** — a construction check covers recorded winners, so a shape that never wins is never built.
4. **The inter-class term**, which needs a genuine two-class group rather than a single class.
5. **Admissibility of the scored shapes**, where a test that cannot fail is not evidence (§4).

The one lever on item 1 worth naming: **B(n) ≤ B_solv(n)**. A *missing* Oliver shape cannot violate it, but a *mis-scored* one can, and it costs a partition scan per row.

---

## 2. Failure directions are not symmetric, and the dangerous one is usually the quiet one

**Under-scoring is the failure that matters** for an upper-bound claim. B(n) is a maximum over admissible configurations, so a shape scored *below* what a group achieves makes B too small and can break μ(n) ≤ B(n). A restriction that looks conservative fails exactly this way — which is why "erring on the safe side" is not a defence when the quantity is itself a bound. Over-scoring is unsound in the other direction: a cap crediting an orbital no group delivers.

**A rebuild must never lower a value.** Adding configurations can only raise a maximum, so a rebuild that comes out lower anywhere means a shape has been *lost*, not gained.

**Anti-permissive conditions are invisible.** For a certificate whose proof is an empty candidate list, a condition that is not in fact necessary silently removes a real candidate and leaves the empty list looking like a proof. Nothing in the certificate's own output can show this. Hence: for such conditions the question is never "is each condition true" but **"is each condition necessary"**, and a gate that strips must carry an assertion at the point of decision rather than a silent `if`, because a strip firing where it is not licensed produces byte-identical output to a correct run.

**A screen that compares an optimistic candidate against a recorded bound is asymmetric in its input.** A recorded bound that understates makes the screen fire more often — noisy, tolerable; one that overstates makes it **miss**. So a stale input is not neutral, and its hits are uninformative rather than wrong.

**A tolerance equal to the exact boundary of the property it tests fails on the boundary cases** — those are the only inputs that reach it, and floating point settles them by accident of representation. The instance: a stored decimal density with *k* places is a correct rounding iff |stored − B/C| ≤ ½·10⁻ᵏ, and an exact tie lands a few ulps the wrong side of the tolerance in doubles. Exact ties are rare — one per few thousand rows — which is precisely why a tolerance that mishandles them survives. Widening the tolerance hides it while weakening the check. *Move the comparison into arithmetic with no boundary error rather than moving the boundary.*

---

## 3. Silence that reads as success

A recurring shape: the output looks clean because the thing that would object is absent, not because it agreed.

- **Truncated rows carry no verdict**, but they look like data, so a summary counting mismatches over a file counts them as passes. A sweep cut short by memory pressure therefore *reports* a clean run over the rows it never tested. The fix is structural: re-read the output and require every row to end in a verdict.
- **Skipped shapes are untested shapes**, and must be reported as such rather than dropped.
- **A partial input silently narrows a screen's scope.** A clean verdict over a short frontier says nothing about the rest, and the silence is indistinguishable from a pass. Any screen reading a table should report how much of its intended range the table failed to cover, before the verdict.
- **A control that comes back clean means the harness is inert**, not that the scoring is right. Hence: read the control first, always, and check its failure count against a stated predictor rather than a remembered number.
- **A test that cannot fail is not evidence.** A predicate returning the same verdict on every input is indistinguishable from a constant. Give it a population where the answer varies before reading its verdict on anything.
- **Two modes agreeing can be vacuous.** Where a filter removes the branches a dispatch would have handled, "with theorems" and "without theorems" agree trivially and the comparison is no evidence about the theorems. Whether the dispatch actually fires is a thing to measure per run.

---

## 4. Witness versus search, and why both verdicts are worth printing

Two different questions look like one: *is **this** chain good* and *is there **any** chain*. Checking a supplied witness is cheap — a few predicates — while searching the lattice is exponential in the rank of the bottom layer, and the cost driver is that rank rather than the group order.

The two must agree in one direction only: **witness passes ⟹ search must not fail.** The converse is false and its falsity is informative — a rejected witness does **not** mean the object is inadmissible, since another chain may exist. So a check exercising both should print both verdicts and assert only the implication. Constructions that violate one chain condition each, with the others intact, are what make the distinction visible: a broken witness alongside a successful search is the intended behaviour, not an inconsistency.

**A predicate that returns the same value on every row of a battery needs an external population to have any evidential content.** Testing every transitive group of small degree supplies one: the verdict then varies, and both the pass and the fail cases are real.

> **Two cautions on reading such a population.** *Admissibility implies solvability* — the chain is p-group by cyclic by q-group, hence solvable-by-solvable-by-solvable — so a column showing no insoluble group admissible is a theorem, not a measurement, and only the **solvable** failures are evidence. And a group failing the chain condition is **not** thereby a counterexample home: at prime-power degree a Sylow subgroup is transitive and admissible regardless, so the degree is settled whatever the individual groups do. The distinction between a group being admissible and *containing* an admissible transitive subgroup is the whole content there; see `monotone-transitive-note.md` §3.

---

## 5. Figures rot; ranges rot silently

**A stale figure reads as a claim about the current range.** This is the failure mode of every quoted count, floor, argmin and share: nothing about the number announces which run produced it. Two structural defences, both cheaper than vigilance —

- **Range-scoped claims expire on extension without any error.** Any check whose statement is "…at every row of the table" is a different statement after the table grows, so it belongs in the per-batch list rather than in the one-run-per-environment list.
- **Quote distributional figures over the contiguous prefix, not the whole file.** A table that is a contiguous prefix plus a worklist-driven tail has a biased tail by construction — the worklist selects by *low* score — so aggregates over the whole file are not aggregates over a range.

**Verdicts that are asymptotic limits are not tested by a count.** A shape that wins at half the values in range can still have a winner share tending to zero; what a density-zero supply argument implies is a *declining share*, and a rise must clear both a proportional bar and Poisson noise on the raw counts before it means anything. Splitting an aggregate too finely destroys the sensitivity: a trend obvious in aggregate sits inside noise once divided five ways.

**A summary ranked by frequency hides the rare events, and the rare events are often the informative ones.** Where a report lists what *changed* — shapes migrating between census rows, say — a large count means a systematic reclassification, which one line of prose can describe, while a count of one or two usually means the corrected space expresses something the old one could not at all. Truncating to the largest few therefore drops exactly the end worth reading. *The instance: two rows migrating into the fused single-class shape — the only two anywhere, and the same pair an unrelated identity check names as its expected exceptions — sat twelfth of twenty-two pairs and were invisible under an eight-line cap.* Before capping such a list, check whether its length is **bounded by construction**: a migration table's distinct pairs are at most S(S − 1) in the number of shape labels, itself bounded by the fusion bound, so there is nothing to cap and a list that grew past it would be a finding in its own right.

**A rounded figure cannot stand after a ≥.** Rounding is symmetric and a bound is not: a value rounded to k places can land *above* the truth, so quoting it as a lower bound is a false statement about exactly the case that attains it. The instance: a range minimum of 175813/3804661 = 0.04620989… printed as 0.04621, which then propagated into "δ ≥ 0.04621" in several documents — false at the one n where equality holds. **Quote a bound as an exact rational, or truncate toward the bound; never round.** The same applies one level up, to any scan whose *output* is rounded: a file printed to five places supports only "≥ printed − 5·10⁻⁶", and if a conclusion needs more than that, the margin has to be checked rather than assumed. Here it survived — the next-lowest entry had 0.0017 of room — but that was a fact to verify, not a formality.

**Presentation columns are not integrity checks.** A mismatch in a derived display value, with the substantive re-derivation passing, is cosmetic — grouping it with the checks that mean "the run is broken" mislabels it.

---

## 6. Cost as a design constraint

**A check that costs seconds gets skipped, and a skipped check is worth nothing.** A validation suite that runs in a fraction of a second on the whole table is something to run reflexively — before every certificate, after every batch, on any hunch — rather than a job to schedule. That is worth protecting as a constraint: keep per-row checks linear in rows and parts, on numbers already parsed, and push anything whose cost grows with *n* rather than with the row count into a certificate.

**Probe before committing an expensive computation.** Finding one configuration that clears a floor is sub-second; proving optimality is what costs hours. Where the question is "does anything clear this threshold", a targeted scan settles it outright whenever the answer is yes and costs nothing when it is not.

**The informative axis and the cost axis are usually different.** For block-structured sweeps the informative axis is the block size — what new divisor structure it brings — while the cost is driven by the fusion count through the group order and the lattice. Raising the range alone buys little and costs a lot; capping the expensive axis to go wide on the informative one is the better sweep.

---

## 7. Tooling notes with a longer half-life than the tools

- **Environment output formatting can corrupt data silently.** Writing rows through a formatter that wraps long lines splits any row whose list is long, and the result is unparseable rather than wrong — a downstream consumer sees *fewer* rows rather than bad ones, which reads as success. Write through a stream with formatting disabled.
- **Under-building a group is a quiet failure.** Translations by a single element generate only the prime-order subgroup; the full additive group needs a basis. The symptom is a realised orbital smaller than predicted, i.e. exactly the shape of a genuine scoring defect, so it is worth ruling out first when a construction check reports a shortfall.
- **A fused class realised as "block permutation plus separate twist" is a different group** from one realised by a single entangled generator, even when the two share an order and an orbital partition at small degree. The coincidence at the smallest instance is what lets a wrong reading survive.
- **GAP has no implicit string concatenation.** Two adjacent literals across a line break are a parse error, not a join. A bracket-balance pass will not catch it, because the brackets balance — so when writing GAP without an interpreter to hand, wrapped string arguments are the first thing to check, ahead of anything semantic.
- **Guard memory-bounded sweeps on the driver of the cost, not on a proxy.** Group order is a poor proxy for lattice cost; the rank of the bottom layer is the driver, and guarding on order alone lets the expensive cases through.

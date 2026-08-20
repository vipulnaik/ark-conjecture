# Session log 10 — fresh-eyes read of the notes, `ep` and `aod`, with repairs

*Scope: `orbital-evasiveness-notes.md` §§1–6 read critically, §§7+ skimmed; `enumeration-proof.md` and `arithmetic-of-density.md` read in full, F.4 and §§6.7–6.8 last; `pending-checks.md` and `literature-findings.md` read after. Scripts run: `converse_check.py`, `validate_table_v3.py`, `check_doc_figures.py`. Edits made to four `.md` files and to `converse_check.py`.*

## 1. What the reruns established before any editing

| run | result |
|---|---|
| `converse_check.py mu_table_safe_v4.csv` | 2,186 rows, **0 violations**; 1,409 foreign primes, 777 branch-(a) rows; max cofactor **12** at (221, 157, 13); slack 3.6 |
| same, v5 partial | 0 violations; max cofactor still **12** at the same witness; slack 2.9 |
| same, `--delta0 0.35` | violations, exit 1 — negative control behaves |
| `validate_table_v3.py` v5 | **22 PASS / 0 FAIL / 12 INFO / 5 SKIP** |
| `validate_table_v3.py` v4 | 21 PASS / **1 FAIL** — 18 re-derivation mismatches; expected, v4 is the baseline and its rows are lower bounds |

Census counts re-derived independently from the v4 CSV agree with the documents exactly: part counts {1: 777, 2: 1393, 3: 16}; one-part-by-F 227/167/130/106/67 at F = 2, 3, 4, 5, 7; the four composite-F exceptions exactly n = 282, 894, 1434, 1490; `certified_K` {2: 394, 3: 1443, 4: 331, 5: 18}.

Independently recomputed and **correct as printed**: every closed-form constant in the §3.3.5 ceiling table and the cap_F(η) = cap₁(Fη)/F identity; the 26 > 15√3 margin; the §3.4 window identity F·width = 1 − √λ; N(δ₀) = 24 / 65 / 83 / 122 / 164 and N_add = 6 / 10 / 15 with their parity splits; §6.8's κ = 0.700 / 0.333 / 2.285 / 1.080, S₁₂ density 2.67·(1/log²x), multiplicative gaps 1.0412 and 1.1649, odd-cofactor counts 5/6/4/3/5/2; F.4's "≈44% within a factor 25 of a prime power" (measured 43.5%); the e = 1 worked table at n = 779 and 1943; n = 640's δ = 0.1192 and M = 5; the worked cases at n = 308, 3239, 1460; Theorems 2.1, 2.2, E.3(i), E.4.

## 2. Repairs made

**(a) The stale q-power fusion count, in five places.** `aod` §2.1's terminology paragraph still defined a class as "fused by the top q-group, with Fᵢ a q-power", and the paragraph after it still said fusing "constrains q" and read n = 1817's `2x389` at q = 173 as forcing q | 2 — impossible under its own reading, and contradicted by the composite-F winners named three paragraphs earlier. Rewritten to F = F_mid·F_top throughout, with the n = 1817 witness read correctly as a cyclic-layer fusion at odd q. The same assertion was repaired at `aod` §1 (multiplicative-engine box), §2.1's opening line, §2.1's R1 sentence, §6.5's "needs a q-power's worth of equal blocks" (the density-zero conclusion survives, via a bounded-cofactor prime-power divisor rather than ω(n) ≤ 2), `ep` Part H's cost model, and the notes' glossary entry for the two engines. The deliberate contrast at `aod` §2.1's verified box ("under a shape space with F a q-power…") and the battery branch label in `pending-checks` R8 are left, being about the restricted space on purpose.

**(b) F.4's shared-chain-prime step had a false branch at s = q.** The proof said a non-cyclic elementary-abelian p′-group has "no home but Γ₂". True for s ∉ {p, q}, where every s-element lands in the cyclic layer; **false at s = q**, where the top layer is exactly such a home. The conclusion (k = 1) is unaffected but comes from **Lemma B′ Case 2** — a primitive transitive q-group is regular of prime degree. Both branches are now written out in `ep` F.4 and in `pending-checks` T8's resolution bullet, which carried the same compressed form.

**(c) Two places still carried the superseded "consumes relative density" reading** of Shparlinski's Theorem 2, contradicting `aod` §6.8(iv) and T4: the notes §6 closing paragraph (including its "the exponent and the density compete for one resource" framing) and `pending-checks` T8's own (SP) paragraph, sixty lines below T4's correction in the same file. Both now say what §6.8(iv) says — cardinality-only hypothesis, thinness costs one logarithm, the cap is the **companion** exponent at every input density, and the density appetite belongs to the endpoint tool.

**(d) Tightest-row instance corrected and reconciled.** `ep` Part I named n = 1994 = `2x997` as the tightest row at feasibility slack 0.0004, while `aod` §6.1 named n = 2594 = `2x1297` at 0.0003. Both figures are correct for their own rows, but **2594 is the tighter on all three axes** (G.4 ratios 1.0004 vs 1.0005, slack 0.00027 vs 0.00035) — confirmed by scanning every row. `ep` now names 2594, matching `aod`, and notes that F.4's branch-(a) bound is nearly attained at the same n.

**(e) `aod` §6.8's window share.** "96% for the primes" is 94.7% at x = 2·10⁶ on the same cutoff as the 92.5% beside it; corrected, with the range and cutoff convention stated.

**(f) `converse_check.py` — a non-prime starred part is now reported wherever it occurs.** Previously the `unchecked` branch fired only when *no* starred part on the row was prime, so a row mixing a legitimate prime star with a Lemma-B′-violating non-prime one passed silently on the strength of the first. Now every non-prime star is reported. Counts and verdicts unchanged on both tables; the negative control still exits 1. Header updated.

**(g) A datum added to F.4's measurement box.** The tightest instance of inequality (2) anywhere is **r/(δn) = 2.003**, so the table satisfies the sharper form with a further clean factor of 2, saturated at the balanced two-part shape. Both slack figures point the same way, which makes the sharpening question one question rather than two.

**(h) Dehistoricization.** Three phrases rewritten: `ep` Part I's "the older diagnosis" / "recovers the older claim exactly" → the two-block diagnosis and its correct scope; the notes §9.7 "contrary to what the earlier reading of this suggested". The notes' orbital-count distribution gained a ⟦PENDING-REBUILD⟧ tag, being an untagged distributional measurement over the contiguous range.

## 3. Final `check_doc_figures.py` run

6 findings needing a decision, down from 8; history findings 4, down from 6.

- **Figures:** two old-checkpoint matches remain, both judged coincidental — the notes' `20.4` (an orbital-count share, now PENDING-tagged) and `pending-checks` R8's illustrative `n = 2,000` cost ratio, which is not a range assertion.
- **Scope:** the sub-1/16 tail over the v5 prefix reads **{527, 1175, 2075}** against v4's 18 of 2,186. Covered by the PENDING banner, but it confirms Part I's tail figures shrink sharply on the rebuild.
- **Invariants I1–I3, tables, refs, census, hygiene, prose:** all clean — no F_mid strip prescribed anywhere, six constants everywhere, F = 4 only at class 11, 0 dangling refs, 47 tables well formed, all three DUP blocks in step.
- **History:** the three remaining in `literature-findings.md` are that file's subject matter; `ep` L871 is guidance about quoting ranges, not project history.

## 4. What remains, and who it is for

**Left unrepaired because the right value is not determined:**

1. **`aod` §6.6's second caveat quotes a gap of 0.0085** "computed against F = 2 optima instead". From §3.3.5 one can produce 0.0048 (to (2 − √3)/4) and 0.0213 (to cap₄(1/6)); no pair of tabulated rung values yields 0.0085. Either the derivation is not recoverable from §3.3.5 or the figure is stale — and the caveat that says "state which optima" does not itself state which optima give it.
2. **`aod` §6.2's partition-factor table, 24 versus 26 at δ₀ = 1/9.** Self-flagged there as wanting re-derivation; the section's own argument says the one-size and penalised columns must agree in that row. Confirmed as a genuine inconsistency, not resolved.
3. **The 289-vs-18 accounting on the v4 baseline.** The banner says 289 rows are known low; the re-derivation check finds 18 mismatches. Consistent if the other ~271 were raised by a change of witness rather than of score, but that has not been confirmed, and R1's "0 FAIL" expectation should say it applies to the current table and not to a baseline.

**Left for a human, unchanged in ranking:**

4. **T3, the necessity read of `fb_common.py`'s eight conditions.** Not attempted here. It is the whole trusted base for μ(n) = B(n) over the certified range, it is a reading task rather than a rerun, and it sits squarely in the category a numeric pass cannot reach. Highest value of anything outstanding.
5. **T1/T2 and the GAP side.** `verify_witness.g`, `ark_shapes.g`, `ladder_verify.py` and `mu_enumerate_v3.py` were not run this session; R8's even-F battery entries remain the thinnest evidence under the ceiling table.

**One methodological note worth carrying.** Repairs (a), (b) and (c) are all the same failure: a corrected claim propagated to the places that state it prominently and not to the places that *use* it in passing — a terminology paragraph, a one-line proof gloss, a closing framing sentence. None is a numeric figure, so no pass in `check_doc_figures.py` can see any of them. The cheapest tell in each case was an internal contradiction with a witness or a count quoted nearby, which suggests the useful grep after any structural correction is for the *old rule stated as a premise*, not for the numbers it changed.

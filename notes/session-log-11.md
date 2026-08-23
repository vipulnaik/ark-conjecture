# Session log 11 — the (BCG) rename, the (AL)/(AA) split, the S2 identity, and the Reduction Lemma factor 2

*Four changes spanning ten documents, executed as separate passes in dependency order so that a stale reference from one could not hide inside another. Two new invariants and one new figures pass were added to `check_doc_figures.py` to keep each change from regressing.*

## 1. Pass A — the rename, done alone

`(H)` → **(BCG)** (bounded-cofactor Goldbach) across the seven framework documents; `(H)` → **(BCG_{1/5})** in `mu-theta-n2-note.md`, its LaTeX twin, and `note-to-framework-bridge.md`. The motive was collision with **Schinzel's Hypothesis H**, which `literature-findings.md` §15 uses in its standard sense; that reference was verified intact afterwards.

**One collision the rename itself created, caught and reverted.** A textual `(H)` → `(BCG)` pass corrupted six occurrences of **χ(H)**, **|V(H)|** and **e(H)** in the notes' §9 — the *graph* H of the forbidden-subgraph criterion, nothing to do with the hypothesis. Restored. Worth recording because it is the exact hazard of a mechanical rename over a symbol that is overloaded, and the only reason it was caught is that the pass was run alone and its output read before anything else changed.

## 2. Pass B — two quantifier strengths

`aod` §3.5.3 now states both variants and the contrast between them:

- **(BCG-AL)**, all large n — the clauses as they stood. Believed on overwhelming empirics, and **implied by no fixed Bateman–Horn system**: passing from per-n asymptotics to every large n needs uniformity in the system's coefficients, which §3.5.2 already recorded **Friedlander–Granville** as refuting. That paragraph was a caveat; it is now the reason the split exists.
- **(BCG-AA)**, almost all n — the same clauses off an exceptional set of density zero. This *is* implied by a fixed system, and the implication is the sharp one: **(BH-SW) ⟹ (BCG-AA)**.

**The implication is cell by cell, which I checked rather than assumed.** The (F, d) assignment `sp-to-floor.md`'s circle-method route selects at each residue class agrees with clause 3's table at all six cells — (1,2) at 0/4/6/10, (1,6) at 2/8, (2,2) at 1/9, (2,4) at 3/7, (2,6) at 5, and **(4,6) at 11**, the load-bearing one. Two routes with nothing in common — one enumerating Oliver groups, one solving congruences for a circle-method window — assign the same fusion count and the same cofactor at every class.

§3.5.2, §5 and the downstream references in five documents were re-pointed. §5's asymptotic half now distinguishes the two forms by what each costs: the almost-all form is a theorem modulo a prime-tuple conjecture, the every-large-n form is of Goldbach difficulty.

## 3. Pass C — the S2 identity

After the entangled correction, S2 needs only that c be a prime power; F is an arbitrary integer carried by the cyclic layer. So with **F > 1** (S1 and S2 kept separate, per instruction):

> **S2 exists at every non-prime-power n, and δ_S2(n) = (Q(n) − 1)/(n − 1)** at the best choice c = Q(n).

Landed in `aod` §1 (boxed), §2.1, §5, §6.5, the census row; `ep` F.4's measurement box and census table; the notes glossary. Three consequences worth keeping:

- **The floor conjecture's domain is S2's domain.** "Every composite non-prime-power n" is exactly where the universal shape exists, so the exclusions are structural rather than stipulated.
- **F.4's 44% statistic is this identity in disguise.** "Within a factor 25 of a prime power" *is* Q(n) ≥ n/25 *is* δ_S2 ≳ 1/25 — measured **43.0%** exact-form at n ≤ 10⁵, 43.5% divisor-form. So it is not a plausibility check on the floor: it says the universal shape certifies the floor unaided on nearly half of all n, and the conjecture's whole difficulty lives in the complement.
- **The density-zero argument survives on better grounds.** Not ω(n) ≤ 2 — which is no longer even true, n = 78 = 6·13 being a three-prime witness — but a bounded cofactor, which is one line from the identity.

**An independent check on the entangled correction fell out of this.** The identity is arithmetic and the table is a search output, so they can be compared. On the v5 rebuild prefix: **0 of 1,790 rows** fall below δ_S2. On the v4 baseline: exactly **two** — n = 78 and n = 222 — which are precisely the two entries of `entangled_exceedances.txt` with no top prime. That is a confirmation of the correction from a direction that never touches the enumerator.

## 4. Pass D — the Reduction Lemma's factor 2, and what it turned out to be

`sp-to-floor.md` §2 bounded the foreign intra orbital by `rQ/2`, "the safe halved value". Every `d` in its grid is even, so `Q = (r−1)/d` is an **odd** prime in every window and `−1 ∉ C_Q`: the true orbital is `rQ`. Verified by orbit enumeration — (13,3), (31,5), (11,5) give 39, 155, 55, exactly `rQ`; the even-Q pairs (13,4), (31,2), (41,8) give 26, 31, 164, exactly `rQ/2`.

Correcting it doubles the foreign density term and rebalances the window to

> **δ(k,d) = 1/(√k + √(d/2))² = cap_k(2/d)** — the framework's ceiling formula at F = k, η = 2/d.

All six grid cells then equal the §3.3.5 ceiling table exactly: 1/4, 3 − 2√2, (1+√3)⁻², 1/8, (√2+√3)⁻², **7 − 4√3**. So:

- The note's §8 open question — whether the mod-12 agreement is "an identity or a rhyme" — is **answered: identity**. What remains open is one level up, and is more interesting: why the analytic route selects the same (F, d) per class with no access to the shape space.
- The **conditional theorem strengthens to its sharpest form**: (BH-SW) implies almost all n attain their own class ceiling − ε. That is the exact asymptotic half of the floor conjecture, meeting the ceiling from below, rather than a positive constant that happens to beat 1/25.
- Headline constant **0.0505 → 7 − 4√3 = 0.0718**; §4.4's comparison ≈ 1/13.9 vs 1/350.

**§7's end-to-end run was tagged ⟦PENDING-RERUN⟧, not edited.** Its scoring inherits the halving; both sides of its comparison moved together, so the structural conclusion survives and the numbers do not. Expected on rerun: class 11 realizing ≈ 0.066 against 0.0718. Filed as A23.

**The correct version of this argument already existed and had not propagated.** `note-to-framework-bridge.md` §5 makes exactly the parity argument — an even twist order would force q = 2 and a bounded r, excluded by the window — and concludes the note leaves a factor 2 on the table deliberately. Written first, in the older document, and reached neither `sp-to-floor.md` nor `pending-checks.md` T8, whose constants bullet asserted the **opposite** (that F·r·Q/2 was the true bound and F.4 was being conservative). T8 is corrected and cross-referenced both ways.

## 5. Pass E — the bridge, and a non-nesting finding

`note-to-framework-bridge.md` §4 said the framework's balance points span [0.2247, 0.5] and all six sit comfortably inside the note's window. Computing them per class: 0.5, 0.3660, 0.2929, 0.25, 0.2247 — and **0.1340 at class 11**, where F = 4 makes each block small. The quoted span omits the F = 4 value.

**So the note's `c ≥ n/5` excludes the class-11 ceiling configuration, and the two hypotheses are not nested in either direction.** (BCG-AL) does not imply (BCG_{1/5}) — at class 11 it hands over a configuration the note's condition 2 rejects. (BCG_{1/5}) does not imply (BCG-AL), being far weaker and restricted to the unfused shapes. **Incomparable siblings**, not a strong and a weak form of one statement. This is the sharpest available statement of what the note gives up, and §4 previously implied a containment that does not hold.

The note itself remains correct on its own terms and was not otherwise touched.

## 6. Passes F–G — framing and smaller repairs

- **`literature-findings.md` §15b, new.** BBKN's two-case split — Q(n) large gives the bound free, Q(n) small licenses Vinogradov fusion — **is the S2 identity arrived at from the other end**, with their threshold as our δ₀. The Vinogradov step manages coprimality to keep the layer cyclic, which the entangled generator achieves at any F with no decomposition and no hypothesis; so the published construction imports an analytic input (ternary Goldbach) the corrected shape space does not need. **Cite BBKN for the split, not the construction.**
- **`sc` §9's closing rule extended.** Constants get absorbed by an unspecified `c`; **hypotheses get absorbed by an exponent gap**. Below the endpoint an unneeded hypothesis costs nothing, so importing one is rational rather than sloppy — and invisible until θ = 1, when both kinds of slack surface together. The rule now reads "any expression *or hypothesis*".
- **The completeness caveat, recorded as A24.** Nobody has searched for the optimal Oliver-admissible family. The literature's silence is evidence neither for nor against the entangled construction's optimality, and it is the one place a further factor could hide.
- **`sc` §1.5's construction.** `𝔽_p^k ⋊ (C_{p−1} × C_k)` is not Oliver-admissible at general k — the middle is non-cyclic whenever gcd(k, p−1) > 1, including its own verified pair (5,2). The entangled generator is the admissible form and delivers the same orbitals (checked at the same five (p,k) pairs). Constants unaffected; §9's hedge sharpened.
- **`sp-to-floor` §6.1**: product over K < ℓ ≤ L (an ℓ ≤ K may divide k and then excludes nothing; Mertens tail unaffected); `aod §6.8(v)` → §6.8(iv); §7's pair counts 13,934 / 10,281 on recount; a `§5.2` reference that should have been `§4.2`.

**A finding that surfaced from the new invariant.** `aod` §6.7's equivalence round trip — "(BCG) yields δ₀ = 1/350, so the converse returns D ≤ 700, a factor ≈ 58" — is computed at the **note's** constant, which is the loosest available choice. At the conjectured floor 1/25 the same converse gives D ≤ 50, a factor ≈ 4 (the form `ep` F.4 already quotes against a measured maximum cofactor of 12); at the asymptotic ceiling it gives D ≤ 28, a factor ≈ 2.3. **The round trip is far tighter than the headline 700 suggests**, and the paragraph now says which δ₀ it used.

## 7. New machinery

- **Invariant I4** — no sentence gates the fused shape on ω(n) or on F being a prime power. Fires only on a *requirement*: an earlier draft flagged every statistic about how the ω(n) = 2 population thins, ~20 findings, which would have trained the reader to ignore it. Also masks table cells, after a header row produced a cross-cell false positive.
- **Invariant I5** — no bare `(BCG)`. Fires only in **quantifier-sensitive company** (yields, implies, buys, all large, almost all), sentence-locally. Bare tags in clause-level prose — "(BCG)'s d ≤ 12", "(BCG) demands both on the same variable" — are correct and exempt; demanding a suffix there would put twenty suffixes into prose that does not depend on which variant is meant. I5 caught the §6.7 constant finding above.
- **Pass 9, the S2 identity** against the live table, in exact integers. Reports 0 on a current-scoring table and names {78, 222} as the expected baseline pair, flagging any *other* set as a real defect.
- **`validate_table_v3.py` group B gains the same check**, as `c_s2_identity`, alongside the existing `c_s2` — which was checking only that S2 *winners* sit at 1/F, a within-winner consistency test that says nothing about the rows S2 did not win. The new one is the wider claim and is independent of the enumerator in a way the rest of the validator is not: it derives the value from the shape space arithmetically and never consults the scoring code, so a disagreement means one of the two is wrong and cannot be satisfied by a bug shared between them. Both docstrings now say which is which. On a baseline it returns **INFO**, not FAIL, so it does not double-count the group-A failure that the same correction already produces.

## 8. Final state

| run | result |
|---|---|
| `check_doc_figures.py`, canonical five | **7 findings**, all decisions; I1–I5 and S2 all `[ok]` |
| same, `shparlinski-constants.md` + `sp-to-floor.md` | **0 findings**; I1, I2, I4, I5, S2 `[ok]` |
| same, note + bridge | 11 findings, **all cross-document references** to `aod`/`ep` theorem names the checker was not given; not defects |
| `validate_table_v3.py` v5 | **23** PASS / **0 FAIL** / 12 INFO / 5 SKIP |
| same, v4 baseline | 21 PASS / 1 FAIL (the expected group-A re-derivation on 18 rows) / 13 INFO; the new S2 check returns INFO naming {78, 222} |
| `converse_check.py` v5 | unchanged counts; negative control at `--delta0 0.35` exits 1 |
| S2 identity, v5 / v4 | 0 violations / exactly {78, 222} |

The seven remaining canonical findings: two coincidental old-checkpoint numeric matches, four scope reports on the sub-1/16 tail (covered by the PENDING banner, and confirming Part I's tail figures shrink sharply on the rebuild), and one legitimate historical citation in `literature-findings.md`.

## 8b. `aod` §6.9 — promoting the note, tiered by standing

Added after the passes above, on the judgement that the note's *arithmetic* findings are robust independently of its analytic half while the theorem is not. §6.9 states four things as findings and cites the fifth:

- **(a), (b) as arithmetic** — the identity `δ(k,d) = cap_k(2/d)` and the six-cell (F, d) match. Neither depends on the circle method, on (BH-SW), or on any step the note takes on citation; if the analytic half were wholly wrong, both would survive.
- **(c) with its three-way status kept explicit**, in a table. (SP) for *arbitrary* sets is refuted; **for the actual S_D it remains open**, since the counterexample's concentration is unconditionally excluded by sieve upper bounds; the companion-exponent diagnosis is unchanged. Flattening these into "(SP) does not suffice" was the main drafting risk and the table exists to prevent it.
- **(d)** sharpens §6.8(iv) positively: what decides a hypothesis's reach is whether it pins **local densities**, not how thin its set is.
- **(e)** cites the theorem with its standing attached — one pass, one reader, two steps on citation, squarefree-only singular series, five-pair enumeration, constants re-derived once after a factor-2 error. The part that changes what the framework claims is the *shape* of the conclusion: not "beats 1/25" but **almost all n attain their own class ceiling**.

**Hedges cut, and one deliberately not cut.** §3.5.4's "do not treat the shared modulus as an identification" now stands in weakened form — three independent derivations agreeing cell by cell is evidence the mod-12 keying is intrinsic — but the warning against transferring *arbitrary* facts between the tables is kept, since the shape space has been wrong once in the permissive direction (A24). §6.8(iv) gains (c) and (d) inline. Nothing in §6.8 was deleted.

**One correction to my own earlier work this session.** Pass B put **(BH-SW) ⟹ (BCG-AA)** into §3.5.3 unqualified, which is the same over-commitment §6.9 is designed to avoid — a one-pass result stated inside the hypothesis section, where a reader takes it as established. It now carries a pointer to §6.9(e)'s standing, with a note that the (AL)/(AA) split does not depend on it. The split is sound on its own; the specific implication is not yet.

**A27** files the second reading, structured so the cheap tier (a)–(c) can be checked in an hour and the expensive tier is ordered by value — the Reduction Lemma's foreign orbital first, being the term that already carried a factor-2 error and still has one reader.

## 8c. §6.2's partition-factor table, re-derived (was A21)

**The additive columns were correct.** The multiplier is the **partition** function p(j), not the Bell number: Σ_{k≤K} Σ_{j<k} p(j) reproduces 7, 14, 26 and 8,266 at K = 3, 4, 5, 20 exactly. Recomputing the all-shapes columns under that convention with feasibility read strictly gives 24 / 34 / **24**, 65 / 115 / **67**, 164 / 357 / **178**, so the top row agrees as §6.2's own argument requires.

**The 24-versus-26 gap was a boundary artefact.** Exactly one unequal shape sits at equality at δ₀ = 1/9 — the two-part `{1,1}`, base cost 2, penalised 2·(1 + 1/2) = 3 = L. Which reading is right is settled by arithmetic rather than convention: that family's density is (c′/n)² with c′ ≤ n/(p+1), which at p = 2 **approaches 1/9 from below and never attains it**, the best instance anywhere being n = 3072 = 2048 + 1024 at δ = 0.11104 against 0.11111. An unattained supremum is not a feasible shape.

**A second defect, found in the same pass and more consequential.** The penalty is derived from the *unfused* density ceiling and is too harsh on a fused smaller class. `n = 640 = 1·256 + 3·128` is rejected by it at penalised cost 4.10 against L = 3, yet is a real configuration at δ = 0.1192 > 1/9 — and it is §6.2's **own** quoted example, two paragraphs above the table. The penalised entries are therefore lower bounds; §6.2 now says so, and A21 is trimmed to the live remainder (derive the fusion-aware penalty, low priority).

**The pattern worth keeping.** §6.2 warns in bold that a ceiling derived for the unfused reading does not transfer to the fused one, and its own penalty column then transfers it. The warning and the violation are in the same subsection. It survived several readings because the violation is in a **table**: reading an argument does not check the arithmetic beside it, and `check_doc_figures.py` checks figures against the *table of μ*, not against a document's own derivations. That is a gap no current pass covers.

## 8d. §6 read start to finish, retitled, and the counting extracted

**Retitled.** "Running the implication backwards, correctly" no longer described the section once §6.9 was added — §§6.1–6.8 run the implication backwards, §6.9 runs it forwards. Now "Running the implication in both directions", with a sentence at the head saying where the two meet: §6.7 shows a floor *demands* a bounded-cofactor shifted prime, §6.9 shows that hypothesis *delivers* the floor. A one-clause link from §6.6 to §6.9 rather than a bridge — they answer different questions under one framework.

**Three numerical fixes in §6.7.** The stale "44% within a factor 25 of a prime power" is replaced by the identity form, which states it better than the statistic did: branch (a) is the multiplicative engine's own branch, so the n it covers at floor δ₀ are exactly those with Q(n) ≥ δ₀n — **43.0%** at δ₀ = 1/25, n ≤ 10⁵ (43.5% divisor form). The `D = 44` clause now names its δ₀ (the verified floor 0.04453; the conjectured 1/25 gives 50), since the round trip two paragraphs later explicitly says every use should. And the crux paragraph — which was doing five jobs in one block — is broken, with the four surviving differences as a list.

**`shape-counting.md`, new.** The seam is **claims stay, derivations move**: every number §6 quotes remains visible in §6, and what leaves is how it was obtained. That rule is deliberate — the A21 penalty bug survived several readings because it sat in a table rather than an argument, so moving *claims* out would have made the failure mode worse, not better.

Moved: the Meinardus derivation (Dirichlet series, constant 2.5317, fitted slope 2.405, the 10–11× overstatement at L = 5–7 — all re-verified this session); the partition-factor table entire, with the penalty derivation and the boundary analysis; the floor-row recomputation apparatus; and the superseded unequal-shape admitting count, retained for audit rather than deleted. Left behind: the criterion, the N(δ₀) and N_add tables, one sentence for the growth rate, and one for what the partition factor costs — plus §6.2's conclusions and the n = 640 gotcha, which are load-bearing prose.

The new document's header states its **standing explicitly** — verified arithmetic, not a one-pass sketch — so it does not inherit the "lightly audited" reading from `sp-to-floor.md` and `shparlinski-constants.md` by association. It is in `check_doc_figures.py`'s canonical invocation, both so its figures are checked and so the refs pass does not flag `aod`'s citations to it as dangling.

§6 is ~120 lines shorter with nothing the argument uses removed; the canonical run stays at 7 findings.

## 8e. The five companion documents, brought into sync

*`three-uniform-note.md`, `solvable-relaxation.md`, `general-k-note.md`, `chiral-graph-properties.md`, `monotone-transitive-note.md`, with `k3_galois.py` and `solvable_relaxation.py`. Read in full; scripts run. Small edits only — none needed structural work.*

**They were already ahead of `aod` on the entangled correction.** All five carry it correctly, including the subtle form: `chiral-graph-properties.md` §3 derives a separate parity rule (F2) for the entangled generator and warns in bold that the naive product rule (F1) is *not* the one the framework needs — from which it concludes that even fusion counts are unconditionally available at odd n, so the F = 4 shape setting the class-11 ceiling is not exposed under A_n at all. `three-uniform-note.md` opens by warning against importing an F_mid coprimality budget, at either arity. Nothing to propagate.

**Six sync edits.**

1. `chiral-graph-properties.md`'s one `(H)` renamed, phrased so it reads as clause-level and does not trip I5.
2. **`three-uniform-note.md` §4.4's escape list carried the pre-identity reading of S2** — listing it among shapes that "need" a special n and calling the result density-zero. Corrected to the §2.1 form: S2 *exists* at every non-prime-power n; what is rare is its being good, its efficiency falling like 1/F, so the escape is a bounded-cofactor condition. Arity-independent — §5.3's own efficiency table has the fused row falling like 1/F at k = 3 exactly as at k = 2. **I4 did not catch this**, since the sentence never mentions ω(n); it is the same claim in different words.
3. **`solvable-relaxation.md` Proposition 2 is the S2 identity**, independently derived and stated first. Its `score(s) = s·(P(s) − 1)/2` at a single orbit gives density (P(n) − 1)/(n − 1), which is δ_S2 with P = Q. Now cross-referenced, with the consequence made explicit: the Oliver fused matching class and the solvable single orbit are the *same construction*, so the chain costs nothing on that shape and its whole price is paid on shapes with a foreign block.
4. Its v4-era ratio statistics gained the rebuild-prefix figure — the two scores already coincide at **796 of 1,790 shared n (44%)** against 41% on v4, the predicted direction.
5. Its "289 corrected rows" phrasing gained the A22 parenthetical, the 289 and the 18 counting different things.
6. Four historicizing phrases dehistoricized, including `monotone-transitive-note.md`'s correction about Illies (1978) — reworded from "an earlier draft asserted" to what the citation does and does not give, which is the durable content and is a misreading others make too.

**Both scripts pass.** `k3_galois.py`: 9/9, including that the layer-split predicate is a strict superset of the naive "a is a prime power" reading with first witness a = 35. `solvable_relaxation.py`: all passes against the rebuild prefix.

**One figure worth flagging rather than fixing.** `solvable_relaxation.py` reports that **77 of 94** class-11 values exceed the class ceiling 7 − 4√3. That is expected — the ceilings bound the balanced additive family, not μ, as both `aod` §3.3.5 and `three-uniform-note.md` §5.7 say — but 82% is high enough that a reader meeting it cold will read it as a contradiction. The script prints rather than asserts it, which is right; a note has been added where it is requoted.

**`check_doc_figures.py` over all eleven documents: 11 findings, all pre-existing in the core five.** The companion documents contribute none. Four apparent DANGLING references when the five are run alone — Lemma D2, Lemma B, `aod` §3.6 — are glob artifacts and vanish with the full set, the same false-positive class as the note/bridge pair.

## 8f. The small-degree material, consistency pass

*`small-degree-computation.md`, `small-degree-verification.md`, with `ark_gap.g`, `consume_gap.py`, `chi_test.py`, `check_groups.py` and the n = 10 outputs. Consistency only, no expansion.*

**Already in sync on everything this session changed.** Both documents carry the entangled-generator correction, and `small-degree-verification.md` §item-8 carries it in the sharp form — it flags a prescribed repair as "stated against the pre-entangled shape space and the weaker of the two available", naming `6x13` at n = 78 as the standing witness that k need not be a prime power. The four `(H)` matches in `ark_gap.g` are GAP subgroup variables, not the hypothesis; no rename applies.

**The one substantive addition, and it is a confirmation rather than a repair.** At the two degrees where μ is known by exhaustive group search, it equals the S2 identity exactly:

| n | Q(n) | F = n/Q | F·C(Q,2) | μ, exhaustive | δ_S2 = (Q−1)/(n−1) |
|---|---|---|---|---|---|
| 10 | 5 | 2 | **20** | **20** | 4/9 = 0.4444 |
| 12 | 4 | 3 | **18** | **18** | 3/11 = 0.2727 |

This is a better check than the table-wide one added earlier in the session. The `check_doc_figures.py` pass compares the identity against `mu_table_safe_*.csv`, which is an *enumerator output* — both sides are classification arguments. Here the right-hand side is a maximum over actually-constructed groups, so the identity is checked against ground truth. It also explains the attainer structure the documents record — one orbital partition at both degrees, eight attainers each — rather than leaving it a coincidence: there is essentially one optimal shape and it is this one. Recorded in `small-degree-computation.md` §4.1, with the consequence stated: the framework's difficulty lies entirely at the n where this shape is *not* good enough, and neither 10 nor 12 is such an n.

**One attribution sharpened.** The "theoretical ceiling of 1/2" at n = 10 is now attributed — it holds for every *solvable* transitive group at non-prime-power n (`solvable-relaxation.md` Proposition 1), not only for Oliver ones, so the headroom above 0.444 is genuinely small rather than an artefact of the chain condition. Same line added to `check_groups.py`'s report, which prints the ceiling next to the achieved value.

**Scripts run.** `check_groups.py` on the n = 10 file: GREEN, 967 groups, no malformed lines, max m\* = 20 at eight groups including the order-200 trivial-top witness — matching the documents exactly. `chi_test.py` and `consume_gap.py` were read but not run (they need the pickled CSP state and hours of compute respectively).

**Five old-checkpoint figure matches across the two documents, all coincidental** — `20.6` and `20.8` are percentages of a group census matching a stale `pct delta >= 1/4` checkpoint. No action.

## 8g. Six older documents: four archived, two kept in service

**No `(H)` in any of them**, so the rename needed nothing. Each archive candidate gained a banner stating what was integrated, what has moved, and where the current statement lives.

**`fusion-count-ceilings.md` — ⟦ARCHIVED⟧, but its citation is live.** Its conclusion *is* the framework's ceiling table: the cap as a joint optimum over (F, η), and the global constant 7 − 4√3 rather than (5 − 2√6)/2, with the F = 4 rung at the extremal class coming from here. Two things are stale — it is keyed **mod 24** throughout, before the rekey to mod 12 and the reduction from seven constants to six, and it predates the entangled correction, so its reasoning about what a cyclic-layer fusion costs on the matching side now answers *nothing*. **Worth knowing before it moves:** `aod` §3.3.5 cites it by name as where the trade-off is worked. The citation is to the derivation and remains accurate, but archiving it puts a live reference into an unmaintained file.

**`three-part-family-split.md` — banner extended.** It already carried the entangled deprecation; two later changes compound it. The mod-24 → mod-12 rekey makes every residue list here finer than the framework's, and the extremal class is now set by the two-part F = 4 shape, which lies **outside the three-part family this document is about** — so its 0.050510 is a within-family cap at η = 1/6, not a class ceiling. That distinction was not load-bearing when it was written and is now.

**`a18-resolution.md`, `t5-resolution.md` — ⟦ARCHIVED⟧, mathematics current.** A18 is closed and gone from the work list; its five edit sites were carried out, so the note is now the **authority** behind Lemma D2's replacement rather than a proposal. T5 survives as an item but rewritten around the coupling. Both banners say so, and both flag that their range checks are against v4, now a superseded baseline — direction unaffected, since a corrected B(n) only rises against a fixed bound. **`a18-resolution.md` §4's r = q sub-case is still open** and jointly load-bearing with the census's S10 row, which is the reason to keep the note reachable rather than merely stored.

**`johnson-presentations.md` — one stale script name**, `mu_enumerate_v2.py` → `v3`. Otherwise current, and its §3 framing sits well with this session's work: the arithmetic enters at the base size m, not the coordinate count.

**`verification-lessons.md` — two lessons added, both earned this session.** Its site taxonomy had no entry for either failure this session actually produced.

- **Site 3's commonest form is a document contradicting *itself*, and no automated pass reaches it.** A figure check compares a document's numbers against the *table*; it has no notion of a document's own derivations, so §6.2's penalty column contradicting its own worked example two paragraphs above passed every pass. Reading the argument does not catch it either, because the contradiction is in a table. **Both known instances sat in tables**, and both survived several readings.
- **Site 3b: an argument the project already contains, made again and made wrong.** The parity dichotomy on the foreign orbital was derived correctly in `note-to-framework-bridge.md`, and two later documents each re-derived it wrongly in opposite directions — one costing a headline constant a factor of two. Nobody consulted the existing version. *Before deriving a step, grep for it.*

**`pending-checks.md`'s companion-file register** updated for all four archivals, including that the resolution notes' mathematics is current and that A18 §4 remains open.

**Full-corpus `check_doc_figures.py` — 19 documents, 24 findings, none in these six.** The dangling-lemma hits when the archived notes are run without `enumeration-proof.md` are the usual glob artifact.

## 8h. A pass over `pending-checks.md` itself

**An error of mine, found by taking T6 seriously.** Checking whether the class-11 margin could be derisked meant recomputing the analytic route's optimum, which exposed a claim I had left standing in `sp-to-floor.md` §3: that `(4,6)` and its transpose `(6,4)` give the same constant. **They did before the Reduction Lemma correction and do not after it.** The pre-correction objective `1/(√k+√d)²` is symmetric in (k,d); the corrected one carries `√(d/2)` and is not, so the transpose falls from 0.0718 to 0.0670. The `(12,2)` alternative likewise reads 0.0502, not the 0.0670 the note gives. Both fixed. This is the same failure the log has been cataloguing all session — a correction reaching the places that *state* the rule and not a passing use — committed by me, three edits after writing the warning.

The fix improves the result rather than merely repairing it: **at class 11 the optimum is now unique, not a tied pair.** A tie is fragile; a strict optimum at a 0.0718 : 0.0670 margin is not.

**T6's class-11 bullet, derisked.** The bullet's worry is that the entry rests on 26 > 15√3, the narrowest possible integer margin. What is new is that **both sides of that comparison are now reproduced by a route with no access to the shape space**: the circle-method optimisation selects (4,6) → 7 − 4√3 at class 11 with (6,4) and (2,12) → (2 − √3)/4 as runners-up, from congruence conditions on r − 1 alone. Same winner, same runner-up, same margin. So the residual exposure is no longer that the **argmax is misidentified** — a shape-space error big enough to flip class 11 would have to be mirrored by an unrelated error in the congruence analysis landing on the same two constants. Only the supply hypothesis remains, and the risk ranking's item 4 now says so.

**T5a, rewritten around what is actually live.** It stood as "re-derive `three-part-family-split.md` §1.2's competing-rates argument on every revision" — an instruction to keep re-checking a document that is now archived and will get no revisions. Worse, the claim it guards is **refuted rather than provisional**: the 1 : 1 : 2 split rested on the c mod 8 law, whose mechanism the entangled correction removes, so S7 takes the family and the other two shares tend to zero. Both `ep`'s S4 census row and `aod` §3.2.5 already said this; the work item had not caught up.

What replaces it is narrower and better specified — **the runner-up ordering**, which is what `aod` §7's disjunction-collapse actually needs. Two ordered sub-questions: where Lemma C's coupling bites (deciding S5 versus S4 for second place), and whether the resulting gap is bounded below. **The first is a congruence condition, not an extreme-value argument** — which is the real improvement, since the old item's fragility was entirely in its extreme-value step. Plus a note on what not to reuse from the archived tables: mod-24 keying, pre-entangled reasoning, and a 0.050510 that is a within-family cap rather than a class ceiling.

**Risk-ranking item 6** updated: F.4's shared-chain-prime step now carries both branches explicitly, the s = q case running through Lemma B′ Case 2 rather than the "only Γ₂ can hold it" sentence that is false there.

## 8i. The Sárközy–Stewart hypothesis, checked and closed

**The item.** `shparlinski-constants.md` §9 named this "the single highest-value thing to check next in this document", and `pending-checks.md` T4 carried it as the highest-value next check on that side. The worry was that the endpoint tool's hypothesis was taken from Shparlinski's one-line characterisation ("cardinalities of order N") rather than the original, and that if it were weaker — density `1/log N`, say — then §7's whole density accounting would change and §8's first open item would be partly answered.

**Checked against two independent secondary restatements, and the characterisation is accurate.** The hypothesis is **positive relative density**: for `A, B ⊆ {1,…,N}` with `#A, #B ≥ c₁N`, some `a + b` has `P(a + b) ≥ c₂N` with `c₂` depending only on `c₁`. The nuance worth carrying is that the Sárközy–Stewart series *does* treat sets that are merely "not too small" — but those yield correspondingly weaker bounds on `P(a + b)`, and the **linear** prime factor, which is the only thing that certifies a density floor rather than an exponent, is what positive density buys.

**So it closes negatively**, which is the outcome that leaves the accounting standing rather than the one that would have improved it: Baker–Harman's set at `≈ 0.37/log x` and `S_12` at `≈ 2.67/log²x` remain one and two logarithms from the hypothesis, and that gap is real rather than an artefact of how the theorem was quoted. Recorded in `sc` §9, `pending-checks.md` T4, and a new `literature-findings.md` §15a.

**What the successor question is, and why it is different in kind.** Not "was this theorem quoted correctly" — that is now settled — but "does *any* endpoint-capable sumset result tolerate a set of density `1/log²x`". That is a literature search rather than a citation check, and it is now the only remaining route on this side. The residual on the item itself is small: the original was not read, so a variant elsewhere in the series (I–V) pairing a weaker density with a linear conclusion is not formally excluded.

## 8j. J0a's non-semilinear stabilisers, largely discharged

**The item** (gap-inventory 5, and the second half of T2): Part E's construction takes a matching block's twist inside the field's multiplicative group, but the stabiliser of a primitive affine group of degree p^a may be **any** irreducible subgroup of GL(a, p). The worry was that some non-field stabiliser realises a block orbital the field construction cannot, so that a recorded value might be unattainable by the group the framework actually builds. It bears on attainment rather than on B_safe, and no precondition check reaches it — a witness records a twist *order*, not the group the twist lives in.

**It resolves in two lines, at a fixed twist order.** Any orbit of H ≤ GL(a, p) on the c − 1 nonzero vectors has size at most |H| = t, by orbit–stabiliser. The multiplicative subgroup of 𝔽_c^× of order t is **semiregular** — its orbits are the cosets, all of size exactly t — so it attains that bound at every vector simultaneously. Since the block's contribution is decided by its *minimum* orbit, **no subgroup of order t beats the field subgroup of order t**, and the same holds for the ± version governing pair orbitals. Reaching for an exotic stabiliser cannot help.

*(Checked exhaustively over the subgroups of GL(2, p) at p = 3, 5, 7 — no subgroup anywhere has minimum orbit exceeding its order. That is a sanity check on the statement, not evidence for it; the bound is orbit–stabiliser and holds in general.)*

**What survives is narrower and is a reading rather than a question.** The argument compares at fixed order, so it settles attainment but not **primitivity**: the field subgroup of order t is irreducible only when t divides no p^b − 1 for proper b | a, so at a twist order lying inside a subfield the block group is imprimitive and Lemma B's affine reading needs ΓL(1, c)'s Frobenius element to restore irreducibility. The scoped claim to carry is that the twist may be taken inside **ΓL(1, c)** without loss; the check owed is that Part E's constructions do reach for Frobenius at subfield-order twists instead of assuming irreducibility.

## 8k. The migration report was truncating its own tail

**The symptom:** `validate_table_v3.py`'s shape-migration check showed no migrations into S2, though n = 78 and n = 222 plainly moved there under the corrected shape space. **The cause was display, not detection** — the check ranked pairs by count and printed the top eight, and there are 22 distinct pairs. `S3 -> S2: 2` sat twelfth.

**Ranking by count buries the wrong end.** A large count is a systematic reclassification — `S3 -> S7f3` at 28 rows is a whole family absorbed by the fused rung, and the check's own summary line already says as much in prose. A count of one or two is the interesting case: a shape reached at a handful of n because the corrected space can express a configuration the old one could not at all. Here the two rows are the **only** migrations into S2 in the table, and they are the same pair `c_s2_identity` names as its expected baseline exceptions — the two composite-F, top-trivial winners, reached from a completely different direction.

**The fix is to print every pair, and the reason it is safe is structural.** The number of distinct pairs is at most S(S − 1) in the number of shape labels, and S is bounded — about ten base shapes, with the fusion variants S7fk running only to F ≤ 1/δ by Part G.4. So the list cannot grow unboundedly unless the fusion bound is wrong, which would itself be worth seeing; the check now says so and flags the case explicitly. Twenty-two lines against a cap of eight.

**Recorded in `verification-lessons.md` §5** as a lesson the file did not have: a summary ranked by frequency hides the rare events, and before capping such a list, check whether its length is bounded by construction — if it is, there is nothing to cap.

## 8l. A9 — the Lean layer, synced and independently compiled

**The compile is reproduced rather than remembered.** The README's container recipe works as written: the 4.15.0 tarball is on GitHub releases, which is on the network allowlist, and `ArkCore.lean` compiles against core Lean with **no output at all** — no errors, no warnings, and crucially no `declaration uses 'sorry'`. That silence is the actual evidence for the zero-sorry claim, since a sketch full of sorries compiles perfectly happily and only the warning count separates the two. A9's obligation 2 now rests on a rerun.

**The sync item A9 exists to catch, caught.** `Note.lean`'s hypothesis structure was `HypH`, and `ArkCore.lean` referred to "conditions 2 and 3 of (H)". `Note.lean` formalises `mu-theta-n2-note.md`, so its hypothesis is the **note's** — fixed `n/5` window, all large n — which this session named **(BCG_{1/5}-AL)**. The old name invited conflation with the framework's (BCG-AL) and additionally carried the Schinzel collision the rename existed to remove. Renamed to `HypBCG`, with the **non-nesting** recorded at the docstring: at `n ≡ 11 (mod 12)` the framework's optimum is the `F = 4` shape at `c/n ≈ 0.134`, which the `n/5` window rejects, while the note's constant is far weaker — so neither implies the other and the structure must not be read as the framework's. Recompiled clean after the change.

**The ceiling table needed nothing**, which is the reassuring half. `Basic.lean` §5 already carries six entries keyed mod 12 with the `F = 4` rung at class 11, matching `aod` §3.3.5 as it currently stands — including `capF 2 (1/3) = 5 − 2√6` at class 5 and `capF 4 (1/3) = 7 − 4√3` as the global constant. The list-length-as-check device works: a table gaining or losing a constant would leave a list of the wrong length.

**What I could add without Mathlib: the statements are now pre-verified.** Every sorried claim in §5 was checked numerically to 30 places — all six entries, `capF 4 1 = 1/9` with its comparison against `capF 2 (1/2)`, the pairwise distinctness of the six, `capF_scaling` over a grid of `F` and `η`, and `cap_two_foreign` over `m₁, m₂ ≤ 7`. All true. This follows the file's own rule that a computable claim is checked before it is asserted, and it means **a proof that fails to close in §5 is an encoding problem rather than a false statement** — which is worth knowing in advance, given that two of the project's three Lean failures so far were name drift rather than wrong mathematics. Recorded in the docstring.

**Phase 1 remains the next Lean work**, unchanged: `Basic.lean`'s 18 sorries, where the cap algebra and the mod-12 table live, and whose proofs have never been attempted.

## 8m. The completed run to 2600 — PENDING-REBUILD figures resolved

**The table is complete, and that is a stronger statement than "extended".** All **2,186** eligible n — composite, non-prime-power — in [6, 2600], with **no gaps and no worklist-driven tail**. So every aggregate is a genuine range aggregate rather than a prefix statistic. *The prefix/tail discipline stays live as a method:* an R7 extension that fills higher n from a worklist re-creates a biased tail, since the worklist selects by low score, and aggregates would then need requoting over the contiguous part. A frontier banner saying exactly this now heads `aod`'s provenance box.

**The invariants hold, and one of them lands exactly.** `validate_table_v3.py`: **24 PASS / 0 FAIL**. Per-n monotonicity: **0 rows lowered, exactly 289 raised** — matching the exceedance list row for row, which is the cleanest confirmation the 289 accounting has had. `converse_check.py`: 0 violations, max cofactor still 12 at (221, 157, 13). The S2 identity: 0 rows below it, so the baseline exceptions 78 and 222 have been absorbed as predicted.

**The floor confirms the tentative value exactly**: **0.048039 at n = 2183 = 37·59**, witness `6x251 + 1x677*`. The documents already carried this as ⟦PENDING-REBUILD⟧ tentative; independent recomputation matches, and the tags are gone. n = 2183 was never among the 289 raised rows, so its value carried through untouched — which is why the tentative reading was right. Comfortably above 1/25.

**The headline structural change: the three-part family is empty.** Part counts are **{1: 743, 2: 1443}** with nothing above — no three-part winners at all, where v4 had 16. The prediction in `ep` Part I was "expect this shape class to nearly empty"; it emptied completely, including n = 1529, the one row that had been expected to survive. The mechanism is exact rather than statistical: all 16 had the same shape — one foreign prime plus two unfused equal p-parts — and that is precisely what a cyclic-layer fusion supersedes, the two equal parts merging into one fused class at full twist and scoring strictly higher as a *two*-part configuration. **S4 and S6 are likewise empty.**

**This dissolves a stated obstacle in the notes.** §9's k ≤ 3 discussion argued that a proof must *produce* a ≤3-class decomposition rather than perturb one, because three-class winners beat the best two-class configuration by a median factor of 1.69. There are now no three-class winners, so **every winner over the whole computed range already has k ≤ 2** — far inside what is being asked. What remains open is the theorem, not any computed obstruction to it.

**Figures resolved.** Sub-1/16 tail **18 → 7** (n = 527, 1175, 2075, 2183, 2279, 2303, 2507), so F.1's free coverage rises from 97.7% to **99.68%**. `certified_K` **{2: 394, 3: 1546, 4: 239, 5: 7}**. Census, both duplicate copies in step: S2 743, S3 853, S5 21, S7f2 395, S7f3 102, S7f4 58, S7f6 14, with trends over thirds recomputed. Split-preference **437 → 472** of 1,210. Two-part maximum 0.24939 over all 1,443, none above 1/4. Drift table's third band rebased to [1500, 2600].

**One figure deliberately left tagged, and one scoped.** The orbital-count distribution in the notes (t = 2 at 20.4%, …) cannot be regenerated — **t is not a column of the CSV** — so it keeps its tag with that reason stated, rather than being silently carried as current. And the decade table at `aod` §3.6 is the **worklist scan to 10⁶**, a different artifact that has not been rerun; the completed μ table settles only its overlap, so that entry is now scoped rather than retagged: over [10³, 2600] the minimum is 0.048039, and the `0.04574 at 1817` entry does not survive the corrected cap.

**`check_doc_figures.py`: 11 findings, all decisions.** Three are the value 0.05703, which is *correct as printed* in all three places — it is the [10², 10³) decade minimum and the [6, 800) band minimum — and merely collides with an old floor checkpoint. Four are scope reports listing the seven sub-1/16 values, which the documents now state correctly. The rest are history phrases and one illustrative `n = 2,000`.

## 8n. Tag triage: R0/R1 closed, the ladder isolated as the bottleneck

**`pending-checks.md` R1 now states R0/R1 as done** over [6, 2600] with the battery results inline, and says extension is **discretionary** rather than owed. It also names the three things that re-arm on any extension — the prefix/tail discipline, every "at every row" claim, and `shape-counting.md` §3's floor rows — so a future extension has a checklist rather than a memory.

**Every ⟦PENDING-REBUILD⟧ tag in the corpus was read and triaged into three outcomes.**

*Renamed to* ⟦**PENDING-LADDER-REBUILD**⟧ *— 21 tags* across `aod` (13), `ep` (4), the notes (3) and `pending-checks` (1). These are the unconditional floor, its argmin, and the range over which the four-family ladder certifies it: blocked on `ladder_verify.py` to 10⁶ and on nothing else. The rename makes the bottleneck visible in the diff, which was the point.

*Resolved and untagged* — the μ-table figures. Beyond the headline floor and census: the c mod 8 diagnostic for cyclic-layer winners, which had been taken over an 806-row prefix and is now **{1: 92, 3: 100, 5: 101, 7: 96}** over all 395 — flat to within 5%, with 48.9% at c ≡ 1 (mod 4) against 9% under v4, so the prediction that the congruence would *disappear* rather than weaken is confirmed at a population where noise is no longer a plausible explanation. Also the two-class fused+foreign count (590, 27.0%), the shape totals (853 / 743 / 590 with S4 and S6 empty), `shape-counting.md` §3's floor row (L = 4.5625, k ≤ 4, F ≤ 20, N(δ₀) = 102), and `solvable-relaxation.md`'s equality share (**916 of 2,186, 41.9%**, from a rerun of its own script).

*Kept, with the reason stated* — the remainder. These are **certificate and script reruns nobody has performed**: coverage counts, collapse shares, the shape-scan totals, `solvable-relaxation.md`'s ratio distribution. Plus the one figure that cannot be regenerated at all, the orbital-count distribution, since **t is not a column of the CSV**. Each now says which rerun it waits on rather than "pending the rebuild", which had become misleading once the rebuild finished.

**One reduction lost its empirical support and kept its justification**, which is worth separating. `ep`'s R1 note argued that distinct part sizes must not be merged, citing 257 winners using two p-characteristic classes. There are now **none** — the family migrated wholesale to fused two-part configurations. The reduction still stands, because it is a statement about which configurations are *distinct* rather than about which ones win, but the measured support is historical and the note now says so instead of quoting a live-looking count.

## 8o. The ladder rerun — both numerical bottlenecks now cleared

**Result: floor δ ≥ 0.04621 at n = 2759 over n ≤ 10⁶, with nothing anywhere below 1/25**, and an empty `below_floor.txt` — the adaptive run against a floor of 0.04 never needs a single μ(n) computation. 45,390 worklist entries.

**The global minimum moved down a decade, which is the interesting part.** It was 0.04453 at n = 11183. The entangled correction lifts the [10⁴, 10⁵) decade to 0.04801 — **11183 stays that decade's argmin**, so the value rose without the location moving — while [10³, 10⁴) is lifted less, and the binding value is now 0.04621 at n = 2759. So the correction did not merely raise a number; it changed which decade holds the hard case.

| decade | entries | minimum | at |
|---|---|---|---|
| [10², 10³) | 6 | 0.05703 | 527 |
| **[10³, 10⁴)** | 205 | **0.04621** | **2759** |
| [10⁴, 10⁵) | 3,299 | 0.04801 | 11183 |
| [10⁵, 10⁶] | 41,880 | 0.05603 | 173627 |

**Consistency check that came for free:** the ladder's value at n = 2183 is 0.04804 against the table's exact 0.048039 — the two artifacts agree at the table's own floor row, computed by different routes. And 2759 lies **outside** the computed range, which is why the ladder floor and the table floor differ at all.

**Downstream figures updated.** N(δ₀) at the ladder floor: L = 4.652, k ≤ 4, F ≤ 21, **N(δ₀) = 112** (was 122 at 0.04453 — the floor rose, so the count fell), in `aod` §6.1 and `shape-counting.md`. The block-minima and worklist-decade tables in §5 regenerated. The Fermat-branch count recounted: **16** winners of shape `2×c + 257*`, densities 0.10319–0.16138, against a v4 count of 18.

**Two thresholds in the resolution notes improved sharply**, both having been computed against an older, much weaker ladder constant of 0.02516: A18's fused-outside exclusion from **n ≥ 1582 → n ≥ 471**, and T5's sharing exclusion from **n ≥ 763 → n ≥ 371**. Both now overlap the computed table with far more room, so the theorem-above-threshold / check-below-threshold pairing is comfortable rather than tight.

**All ⟦PENDING-LADDER-REBUILD⟧ tags discharged** — the rename served its purpose within one turn. Three tags my keyword heuristic had swept into that category turned out to be μ-table figures rather than ladder ones (the Fermat-branch count, the sub-1/16 tail, and a ladder-versus-table comparison); all three are now resolved on their merits. What remains tagged is only the certificate reruns and the one distribution that cannot be regenerated from the CSV.

## 9. What remains

**Filed this session:** A23 (§7 rerun at the corrected orbital), A24 (shape-space completeness), A25 (the transference route), A26 (the note and bridge are *more* stale after the split, and what to re-read before circulation).

**Unchanged in ranking, and still for a human:**

1. **T3, the necessity read of `fb_common.py`'s eight conditions.** Not attempted in three sessions now. It is the trusted base for μ(n) = B(n) over the certified range, it is a reading task, and it is the category no numeric pass reaches — which is precisely the category that produced the entangled-generator finding.
2. **T1/T2 and the GAP side.** `verify_witness.g`, `ark_shapes.g`, `ladder_verify.py`, `mu_enumerate_v3.py` unrun; the finding note's repair item 6 (the n = 33 regression witness) wants confirming.
3. **A21**, now trimmed to its live remainder: a fusion-aware penalty for §6.2's partition-factor table. Low priority — the exposure is a commentary figure.
4. **The §2 correction has one reader.** The orbital enumeration behind the 42% constant change is six lines and reproducible, and the bridge's independent version of the same parity argument corroborates it, but it has propagated into `aod` §3.5.3, four sections of `sp-to-floor.md` and the bridge on my reading alone.

**The methodological note, now with three instances.** A corrected claim propagates to the places that *state* it and not to the places that *use* it in passing. This session's version is worse than the previous two: the correct parity argument was written in the bridge, and the same document set later acquired **two independent wrong versions of it** — `sp-to-floor.md`'s halved orbital and T8's inverted factor-2 claim. Nobody re-derived; each wrote the plausible thing. The grep that would have caught it is for the *rule stated as a premise*, and the cheaper habit is to check whether the project already contains the argument before making it again.

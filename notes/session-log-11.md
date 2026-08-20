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

## 9. What remains

**Filed this session:** A23 (§7 rerun at the corrected orbital), A24 (shape-space completeness), A25 (the transference route), A26 (the note and bridge are *more* stale after the split, and what to re-read before circulation).

**Unchanged in ranking, and still for a human:**

1. **T3, the necessity read of `fb_common.py`'s eight conditions.** Not attempted in three sessions now. It is the trusted base for μ(n) = B(n) over the certified range, it is a reading task, and it is the category no numeric pass reaches — which is precisely the category that produced the entangled-generator finding.
2. **T1/T2 and the GAP side.** `verify_witness.g`, `ark_shapes.g`, `ladder_verify.py`, `mu_enumerate_v3.py` unrun; the finding note's repair item 6 (the n = 33 regression witness) wants confirming.
3. **A21**, now trimmed to its live remainder: a fusion-aware penalty for §6.2's partition-factor table. Low priority — the exposure is a commentary figure.
4. **The §2 correction has one reader.** The orbital enumeration behind the 42% constant change is six lines and reproducible, and the bridge's independent version of the same parity argument corroborates it, but it has propagated into `aod` §3.5.3, four sections of `sp-to-floor.md` and the bridge on my reading alone.

**The methodological note, now with three instances.** A corrected claim propagates to the places that *state* it and not to the places that *use* it in passing. This session's version is worse than the previous two: the correct parity argument was written in the bridge, and the same document set later acquired **two independent wrong versions of it** — `sp-to-floor.md`'s halved orbital and T8's inverted factor-2 claim. Nobody re-derived; each wrote the plausible thing. The grep that would have caught it is for the *rule stated as a premise*, and the cheaper habit is to check whether the project already contains the argument before making it again.

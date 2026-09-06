# Claude's understanding of the project plan

*Written 2026-09 at the end of session 14, for Vipul to reference when preparing agendas for the September meetings with Raghav. §1 and §2 are Vipul's own words, verbatim. §3 is a summary of the commentary Claude gave on the plan in that session. §4 onward is Claude's view of what the September meetings should cover, and is advice rather than record.*

---

## 1. The plan, as stated

* One or two meetings between us spread through September where we refine the planned outline for how to present and sequence the human rewrite of the short note https://github.com/vipulnaik/ark-conjecture/blob/master/notes/mu-theta-n2-note.md. I have an outline in mind, and there are various other aspects, including naming choices for the variables and functions, that would be good to discuss and debate before sitting down to write.
* In October, a high-quality human-written exposition of the short note. I am planning to do a first pass and after that we can do some back and forth of review. Beyond the exposition being better, I want to make sure at the time of writing this to cross-check every detail manually, in a way that I might not have done fully during the many edits managed by Claude. This will follow the outline that we worked out in our September meetings.
* Eventually (maybe in 2027), a fuller human-written document fully explaining the strong results. This will thread together stuff that is currently spread across many Claude-written documents, organizing it in a coherent linear narrative while keeping the rigor of the proofs. This will be a bigger undertaking.

## 2. The outline for the human rewrite of the short note, as stated

So here is my rough plan for how to do a human write of the note: I'll basically do this order:

* Historical motivation and background, based on parts of current Section 5, basically focusing on the KSS breakthrough on the ARK conjecture and how it converts the problem to group theory. Essentially, graph theory / information theory -> algebraic topology (complexes) -> homology -> permutation group theory (Oliver groups) and the prime power resolution.
* Current Section 1, invariant setup, and then reinterpretation of existing historical results based on the mu(n) framework. Also, some commentary on some of them. e.g. that BBKN used Vinogradov's theorem but it could have used entangled generators and avoided it entirely.
* Then, the central insight of Sections 2 and 3 along with the details, describing how a particular sort of arithmetic configuration works, and how the existence of that configuration is guaranteed by the right BCG hypothesis.
* A teaser into the theoretical and empirical reasons we believe BCG-like hypotheses (some details already in note, but might borrow more ideas from aod's relevant subsection).
* Maybe, and this is the riskiest part (as it is not in the current note), a teaser as to the broader results from our framework. Probably described in terms of an outline of the general procedure: group theory -> number theory, and then with suitable number theoretic assumptions, breakdown to quadratic optimization based on residue classes for a given modulus, and even under weaker assumptions than BCG, a finite combinatorial search for any lower bound that is a constant times C(n,2). And that this procedure works on directed, undirected, chiral, k-uniform.

Things to put somewhere:

* Remainder of current Section 5 might go in the end (basically more discussion of Shparlinkski rungs, Baker-Harman) to the extent it wasn't incorporated earlier.
* Jones-Zvonkin program might also be worth mentioning somewhere.
* Hint at Bateman-Horn proper => BCG-AA by circle method.

---

## 3. Summary of Claude's commentary on the plan

**On the sequencing.** The current note is theorem-first (invariant → result → constructions → constant → comparison). The outline is narrative-first, which reads better for an arXiv audience outside the KSS circle. Two things preserve the theorem-first virtue inside it: **state the Theorem in the abstract and once more in a display before the history**, so the result does not land on page 3; and **split the current §5 rather than moving it whole** — the KSS/prime-power history goes early (bullet 1), the θ-ladder comparison (Shparlinski's rungs, Elliott–Halberstam, "(BCG) is the θ = 1 endpoint") goes late, because it needs the hypothesis already stated to make sense. Bullet 2's "reinterpretation of historical results" is the seam.

**On the historical section, one correction to a claim Claude made and the user caught.** Rivest–Vuillemin's prime-power result is about the number of *variables*: a monotone function on N = p^a coordinates with a transitive invariance group is evasive, by a Sylow argument. For graph properties N = C(n,2) is never a prime power at n ≥ 4, so RV says nothing about prime-power *vertex* counts. KSS's prime-power result is therefore genuinely new, not a topological re-proof, and the topological chain is what makes it possible — the same route the note's construction takes at composite n. The honest sentence: RV handled prime-power coordinate counts combinatorially; KSS handled prime-power vertex counts topologically, and that is the case that required Oliver's theorem.

**On the BBKN commentary in bullet 2 — checked, and right.** The fused single class at n = F·c with c = Q(n), the largest prime-power divisor, gives **μ(n) ≥ n·(Q(n) − 1)/2** by a three-line construction (the entangled generator: block rotation and full twist from one element of the cyclic layer). Since Q(n) ≥ log n for every n ≤ 2·10⁶ (worst ratio 1.016 at n = 360360) and asymptotically Q(n) ≳ log n from ∏_{p^a ≤ x} p^a ≈ e^x, this is BBKN's Ω(n log n) with no analytic input. BBKN's route through primes r ≡ 1 (mod ℓ) genuinely needs least-prime-in-AP input; this route sidesteps it by using n's own arithmetic. State the construction rather than cite it — it is as short as the note's §3 constructions.

**On bullet 4.** Two pillars: the singular-series uniform lower bound, and the empirical table — μ now known exactly at every composite non-prime-power n ≤ 10⁶, floor 0.046210 attained at n = 2759 and never approached again (the next value is 0.048039 at n = 2183; nothing else below 0.05 to 10⁶). Add one sentence that the floor is attained *inside* the computed range. `aod` §3.4–3.5 has the parametric-vs-fixed-system distinction worked out, and it is the distinction Raghav caught an earlier draft blurring.

**On bullet 5 — include it, short, with three guards.** State it as a procedure, not as results. Say "lower bounds" only, consistent with the note's stance: the k-uniform *upper* bound rests on an unproved step (J0a′). And for the list of settings: undirected and chiral are clean; the k-uniform lower bound is clean; **directed** is a re-derivation of constants for Karp's *original* digraph formulation (KSS is stated for digraphs), not a new theorem, and should be described as such. Leave oriented graphs out entirely — there the natural conjecture is at least as strong as ARK and the machinery does not reach.

**On Jones–Zvonkin.** Place it at the end of bullet 4, not bullet 5: it is about *standing* — how a group-theoretic existence question reduced to prime-value statements is stated and believed without being a theorem — which is bullet 4's subject. Two departures to state: (BCG-AL) is not a Bateman–Horn statement (parametric, positivity at every large n, Goldbach's tradition not twin primes'); and in every J–Z paper the construction is cited and the work is the arithmetic, whereas here the construction is built. The note's §2 already meets the genre's own local standard — the ω(ℓ) < ℓ analysis is J–Z's step (ii). One caution: do not let the note imply a connection between J–Z's "Li's modification of BHC" and Runbo Li (arXiv:2508.18285) unless someone has checked they are the same Li.

**On the Bateman–Horn → (BCG-AA) hint.** One sentence, with the quantifier stated: *an argument of circle-method type, to appear elsewhere, derives (BCG-AA) from the Bateman–Horn conjecture proper; the passage from (BCG-AA) to (BCG-AL) is the genuine gap, and we do not claim to close it.* The gap is the quantifier the note's Theorem is built around, the argument is lightly audited, and putting it beside the Theorem would invite exactly the quantifier blurring §5 warns against in the Baker–Harman comparison.

**On the assertions in the email to Raghav.** The claim of confidence is right for the lower bounds and rests on a short, nameable trusted base for the upper bound (§5 below). The claim that the approach is tapped out is right; what remains is either Goldbach-strength (the asymptotic half of the floor conjecture, the (BCP) → (BCG) gap) or a different research programme (small degrees, the general transitive case). The template claim is right with the qualifications above. The one cheap item worth doing before saying small degrees are hard is the Angel–Borja cross-check (§7).

---

## 4. What the September meetings should cover — the outline

The outline in §2 is sound. The decisions that remain are ordering and emphasis, and they are worth making with Raghav rather than alone because he will be the first reader of the October draft.

1. **Where the Theorem is first stated.** Abstract, then a display before the history — or history first. Claude's view: the former; a two-page note that reaches its result on page 3 has the wrong shape.
2. **What "current §5" splits into.** Which parts go early as KSS background, which go late as the θ-ladder comparison. The RV/KSS distinction (§3 above) belongs early and should be stated with the two numbers named — coordinate count versus vertex count.
3. **Whether bullet 5 is in.** If yes: as a procedure, lower bounds only, directed labelled as a re-derivation, oriented excluded. If no: a single forward reference to the fuller document.
4. **Where Jones–Zvonkin and the (BCG-AA) hint go**, and the exact sentence for each (§3 above has proposals).
5. **The "things to put somewhere" list** — Shparlinski's rungs and Baker–Harman go late by the split in item 2; the other two are items 4.

## 5. What the September meetings should cover — the trusted base

*This is the item most worth Raghav's time, and it is not in the email because he is not yet tuned to the details. It should be the agenda of one meeting.*

The exactness claim — μ(n) = B(n), hence μ known exactly at every composite non-prime-power n ≤ 10⁶ — rests on four results and nothing else. The computations have been re-derived by independent scripts repeatedly; these four have not been read by a human end to end.

| result | what it carries | readings so far |
|---|---|---|
| **Part 0 of `enumeration-proof.md`** — completeness of the shape space | the whole of μ ≤ B_safe: a shape missing from the space fails silently | tested three independent ways (an independent spec-derived enumerator, the exhaustive GAP census at n = 10 and 12, the fallback sup); **never proved** |
| **Lemma B′** — the foreign twist is a prime power | Proposition F.4's branch (b) is vacuous without it | three independent readings, the third in 2026-09 |
| **Theorem E.5 / Corollary E.6** — every fallback configuration scores below C(n,2)/25 | turns the per-n collapse certificate into a theorem; this is what makes "known exactly to 10⁶" a single statement | **one reading**, plus `fallback_sup.py`'s brute-force confirmation at every n ≤ 3000 |
| **Proposition 1 of `ladder-completeness.md`** — above 1/25 the optimum is a menu shape or S6/S11 | licenses `mu_ladder_exact.py`'s certification | one reading |

**E.5 is the highest-value read.** It has had one reading, it is the theorem that changed the shape of the whole result, and its proof is four counting sub-cases on SAFE terms — an afternoon for a fresh reader. Part 0 is the deepest exposure but is not a reading task; it is a completeness claim, and the honest statement about it is the one already in the documents: tested from three directions, unproved.

**For the October cross-check**, this table says where a manual pass earns its cost. The note itself uses none of the four — its Theorem needs only Ω(n²) and the construction is explicit — which is why the note can be written and checked independently of them. They matter for the 2027 document.

## 6. What the September meetings should cover — naming

The outline mentions naming choices. Decisions already made in the documents that the note should either adopt or consciously depart from:

- **(BCG)** = bounded-cofactor Goldbach, with **-AL** (all large n) and **-AA** (almost all n) variants. The letter H is avoided because it means Schinzel's hypothesis in the literature.
- **(BCP)** = bounded-cofactor primes, renamed 2026-09 from (SP), so that **(BCG) = (BCP) + the additive clause** is visible in the labels. (BCP) takes no -AL/-AA suffix because it has no n in it — the absence marks where the uniformity trap lives. The note may not need (BCP) at all; if it mentions the Bateman–Horn hint it does, since that route reaches (BCG-AA) through it.
- **μ(n)**, **B(n)**, **δ(n) = μ/C(n,2)**, and the distinction **B_refined ≤ μ ≤ B_safe** — the note uses only μ and the lower bound, so B may not appear.
- **η** for efficiency, **F** for fusion count, **d = 2/η** in the note's parametrisation. One fact worth deciding whether to state: the factor 2 in η = 2t/(r − 1) is the *self-pairing* of the orbital (an affine block's orbital is self-paired iff its twist order is even), not bookkeeping — `directed-graph-properties.md` §2.
- **"Parametric Hardy–Littlewood system"** for what the note assumes; **"Bateman–Horn"** only for the fixed-n singular-series heuristic and for the (BCG-AA) derivation. This is the distinction Raghav caught before and the one most likely to slip in a rewrite.
- **"Oliver group"** for the p-by-cyclic-by-q class; **"transitive Oliver subgroup"** wherever the criterion is stated, never "transitive" alone — the elision has tripped the project more than once (Appendix C of `orbital-evasiveness-notes.md`, and §1's box).

## 7. What the September meetings should cover — small items that fit a Pro budget

*None of these gates the note. Each is cheap, and one has a non-circular validation payoff.*

1. **The Angel–Borja cross-check at n = 10.** They reduce potential counterexamples to 9 types and kill four (their Remark 5.2 says they could not find Oliver groups for the rest). Our CSP has never been run against their five surviving types. Either we reproduce their four eliminations — a genuine external validation of the CSP — or we kill more. `literature-findings.md` calls this the single most concrete item from the review. It is the thing to do before saying small degrees are hard.
2. **`solvable_relaxation.py` at 10⁶** — the one R1 script not yet rerun on the completed table; its equality share and ratio distribution are what `solvable-relaxation.md` quotes.
3. **The `mu_exact.py` run's completion**, and the value-agreement check against the ladder table when it lands. Nothing is expected to move.
4. **The three unreached rows of the GAP realisability battery** (n = 78, 33, 105 — the entangled-generator regressions). A run that stops before them is a run without its regressions. Either run to the end or record which were skipped.
5. **Whether `bcp-to-floor.md` gets a second reading**, given that the note may hint at its result. If the hint is one sentence with the quantifier stated, the reading can wait for 2027.

## 8. What the September meetings should cover — the 2027 document's shape

*Not for decision in September, but worth one conversation so the October note does not foreclose it.*

With E.5/E.6 in hand, the spine of the exactness result is small: **Part 0, Lemma B′, Lemma D2, Theorem E.5, Proposition 1, then the computation.** Most of the Claude corpus — the per-n certificates, the worklist and branch-and-bound, the ladder scan, the fallback certificate — was scaffolding for the regime E.5 later closed wholesale, and the fuller document can say so in a paragraph rather than reproduce it. Deciding with Raghav which documents are load-bearing and which are history is what sets the size of the 2027 job, by a factor of several.

The generalisations belong in that document as instances of one pattern, not as separate chapters. `johnson-presentations.md` supplies the frame — arity, base size, containment as the three inputs to one criterion — and Appendix C of `orbital-evasiveness-notes.md` is the table keyed on it. The one that does not fit is the oriented case, which is stronger than ARK and belongs in an "open" section.

---

## 9. Lean integration

*Vipul's plan, as stated, then the scoping agreed after critique. The technical detail — what to state, in what order, with what Mathlib is missing — is in the Lean project's `README.md` under "The plan for October and 2027"; this section is the version for planning meetings.*

### 9.1 The plan, as stated

- **October (Max 5x, alongside the human write-up of the short note):** expand `Note.lean` from the pure arithmetic to **all the conditional inferences** — assuming enough of the established literature (KSS and Oliver) but **not assuming BBKN itself**.
- **Separately, time permitting:** the **mathcheck** framework being built in another chat (LLM-written deterministic scripts for the tedious parts of verbal math checking, so that LLM/human effort at the margin goes to what needs judgement rather than to finding undeclared variables) already has GAP components; extend it to the Lean side of group theory. The Groupprops connection is: **scripts that take a Groupprops page and extract what a Lean formalisation needs as input**, applicable across Groupprops generally. The ARK work supplies a first subset of pages to try it on, after which the LLM does the formalisation steps deterministic scripts cannot. Groupprops may not yet have the specific content needed, but adding it is easy and needs no subscription. **This is general infrastructure worth building regardless; the ARK connection is an application, not the motivation, and it may or may not happen.**
- **2027 (Max 5x for one to two months):** a final push on the fuller document, seeing how much of it can be captured in Lean, using the insights developed.

### 9.2 What "the conditional inferences" are, and why they are cheaper than they sound

The note takes exactly one thing from KSS + Oliver: **a congruence.** For every Oliver group Γ ≤ S_n and every non-evasive nontrivial monotone graph property P, χ(Δ_P^Γ) ≡ 1 (mod q), where Δ_P^Γ is the complex of Γ-invariant graphs lying in P. That Euler characteristic is a **finite combinatorial sum** — over nonempty unions of orbitals lying in P, of (−1)^(#orbitals − 1) — so the hypothesis can be *stated* in Lean with `Finset` arithmetic alone: no homology, no simplicial complexes, nothing outside current Mathlib. The sparse-evasiveness theorem then follows in one line: if every graph in P has fewer than μ(n) edges, no nonempty union of orbitals lies in P, the complex is {∅}, χ = 0 ≢ 1.

So the October target decomposes into: (a) definitions — monotone graph property on `Fin n`, non-evasive (decision-tree depth), Oliver group (the p-by-cyclic-by-q chain), orbitals, χ of the fixed complex; (b) **the KSS–Oliver congruence as a named hypothesis**, a structure parameter in the style of `HypBCG` and never the `axiom` keyword, so the "three standard axioms" claim survives; (c) the constructions as permutation groups, with their Oliver chains and pair-orbitals proved; (d) the theorem assembling them. "Not assuming BBKN" is free: the Ω(n log n) bound is replaced by μ(n) ≥ n·(Q(n) − 1)/2, three lines from `orb_full`.

### 9.3 The scoping agreed

1. **E.5 and Proposition 1 first.** Arithmetic, Mathlib-only, days, and the highest-value undone piece in the whole project: one human reading, and it carries the "μ known exactly to 10⁶" claim. If October produces only this, it was worth it.
2. **The constructions are where the month goes**, and they are ordered by friction: the **unconditional n = 2m family** (F = 2 fused, no foreign block — the note's Theorem 2.2 analogue) before the two-part construction; **c prime (`ZMod p`) before c = p^a (`GaloisField`)**; general (c, r, q) last.
3. **Definitions are the payoff, not the proofs.** This session's evasiveness checker had its recursion inverted for two turns; a `def NonEvasive` cannot be inverted silently. `OliverGroup` written out forces the transitive-versus-transitive-Oliver-subgroup distinction that tripped Appendix C last week.
4. **Lean follows the note, not the reverse.** October's priority is the human write-up; the formalisation tracks the vetted text's names and statement order.
5. **Pin the toolchain and the Mathlib commit at the start of October and do not bump mid-month.** Two of the project's three Lean failures were name drift; the FLT run reports 26% of files changing on one bump.

### 9.4 The 2027 ceiling, stated now so the ambition is honest

The exactness result μ = B rests on Part 0's completeness of the shape space, which rests on Huppert's classification of solvable 2-transitive groups. **That is not going into Lean by one person in two months**, and the plan should not be read as aiming at it. What is reachable, and would be a complete honest artefact: E.5 and Proposition 1 (done by then); Part E realisability in general — μ ≥ B for the whole shape space, the October constructions generalised; **B(n) as a computable function** with `native_decide` on individual rows (the README's Phase 3); and **Part 0 stated as a named hypothesis**, so that μ = B is a Lean theorem conditional on exactly one classification input. *"Everything except the classification is checked"* is a strong statement and is available. *"Everything is checked"* is not.

### 9.5 What the FLT formalisation does and does not change

The Anthropic FLT run (eleven days, parallel agents on a bespoke platform, 29,511 theorems, 13 M lines, building Néron models and Taylor–Wiles patching that Mathlib lacked) shows the obstacle to formalising a result like this one is **coverage, and coverage is effort rather than possibility** — Oliver's theorem is a short 1975 paper and is "weeks of agent time", not "never". It also shows two things that bear on wanting it: the output is "not readable as mathematics", duplicated, and fragile across toolchain bumps, so for a note whose point is a short human-checkable argument the value would be the *checked statement*, not the proof text; and the run was not a chat window. What a Max subscription in a chat buys is what the project already has — one file at a time, compile-repair loops — which is why §9.3's scoping is by friction and why E.5 comes first.

### 9.6 What the meetings need to decide about Lean

Little. Two items, both small:

- **Whether the note's arXiv version mentions `Note.lean`.** One sentence — "the arithmetic between the hypothesis and the conclusion is machine-checked; the group-theoretic inputs are named as hypotheses" — is accurate now and stays accurate whatever October adds.
- **Whether the KSS–Oliver hypothesis, once stated, becomes the note's official statement of what it assumes.** A Lean structure is the most precise possible form of "assuming Oliver's theorem in the form KSS use it", and the note could cite it.


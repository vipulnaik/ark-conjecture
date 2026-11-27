# Why formalise, and what it has bought

Background to the Lean development: the case for it, the lessons from doing it, and its limits. Not needed to build or extend the project; `README.md` in this directory is the orientation document.

## The split that makes this tractable

The framework has two layers and they have completely different formalisation costs.

**The group-theoretic layer splits further.** Its deep inputs — Oliver's fixed-point theorem, Smith theory, and Huppert's classification of solvable 2-transitive groups behind Part 0 — are out of reach: none is in Mathlib, and Oliver's theorem alone is a research-level formalisation. But the finite-group arguments *downstream of Oliver's chain* turned out to be ordinary Mathlib work: Lemma D2, Lemma B for prime blocks and Lemma B′ are proved with the chain (`OliverChain`) as a hypothesis. The boundary is the chain's derivation from Oliver's theorem, plus Part 0 and Part E beyond the two-part shapes (Lemma C is used by neither SAFE nor E.6) — not group theory as such.

**The arithmetic layer is ordinary Mathlib material.** Everything from Part E′ onward — the inequalities, the counting bounds, the cap algebra, the singular-series definitions, the quadratic-residue step — depends on the group theory only through *stated numbers*: given that a block of size c under a twist of order t contributes `orb c t`, everything else is arithmetic. That layer can be formalised now, taking the value formula as a definition rather than a theorem.

## Why bother, given the theorems are probably true

The honest case is not "we doubt the theorems". It is that **every error found in review has been in the arithmetic layer**, and two of the three were of a kind Lean makes impossible:

| error | kind | would Lean have caught it? |
|---|---|---|
| E′ threshold ladder shifted by one (`δ > 1/25 → s ≤ 3`) | a paraphrase of an inequality that does not follow from it | **yes**, immediately — the statement would not typecheck against the bound |
| within-class cross coefficient keyed on `q`'s parity instead of `F`'s | a rule stated in terms of the wrong variable | **yes** — the definition names its variable |
| the `c mod 8` fusion mechanism | a claim about which layer a subgroup sits in | **no** — this is group theory, out of reach when this table was drawn up (chain-level group theory has since proved formalisable; see above) |
| the `F_mid` coprimality clause: a **necessary** condition that was only sufficient | an object entering as a *quotient* treated as a *subgroup* | **no** — same layer, and the sharpest instance yet: it was consistent with every artefact because every artefact derived from it |
| a bound stated in `n²` three lines from one stated in `binom n 2` | a units mismatch between two displays | **yes** — the two have different types, and nothing numerical separates them |
| the worst case of a min-of-polynomials read at the interior balance point rather than the boundary corner (`1/48` for `1/300`) | an optimisation evaluated at the wrong point | **yes**, in phase 2 — this is exactly what the balance-point lemmas assert |
| `roots_mod` assuming `K ∣ D`; the missing `gcd(D,K)/K` integrality factor; an enumeration modulus not divisible by `K/gcd(D,K)` | three defects in a **script**, each inert on the parameter range it was written for | **no** — not because they are hard, but because the scripts are not the artefact being formalised |
| the ladder's `prime_divisors_of(F)` excluding the top prime from the foreign twist | a claim about which layer a prime sits in | **no** — group theory again, and the same shape as the `c mod 8` row |
| a stale figure quoted after the table was rebuilt (`0.026117`, "eight ceilings") | a measurement that moved | **no** — this is what `check_doc_figures.py` is for, and it is the largest error class by count |

**Three of nine, and the pattern matters more than the ratio.** Lean catches the errors that are *statements about stated quantities* — inequalities, units, optimisations. It catches none of the three recurring classes that have actually cost the most time: **layer-assignment claims** (group theory), **script defects that are correct on the range they were written for**, and **stale figures**. The last is handled by a checker and the middle by regression discipline; neither is a formalisation problem. That is a narrower case for phase 1 than "two of three" suggested, and it points somewhere more specific — see the note section below.

There is a second benefit that matters more in practice: **a definition forces the variable to be named.** The coefficient error survived three review passes because "F for odd q, F/2 for q = 2" was true when it was written (F was always a q-power then) and nothing in the prose recorded which fact it depended on. A Lean definition cannot be ambiguous about that.

## Phase 0 — the short note, which is a better first target than phase 1

*The ℕ half is done: `ArkCore.lean` proves `central_even`/`central_odd` (the construction inequality, multiplied through by 350), `mStarOdd_le_even`, the full admissible-`d` table block, and the degeneration example, leaving to Mathlib only the `Density`/`ℝ` wrappers, the `ZMod` chinese-remainder step, and the singular-series material.*

`mu-theta-n2-note.md` is self-contained, is the artefact that will be read by strangers, and — per the table above — its error record is **disproportionately of the kind Lean catches**: a units mismatch between two displays, a region whose worst case sits at a corner, an asymptotic class stated as `O` where the content is a fixed fraction. Formalising just the note is perhaps 200–400 lines and needs nothing outside Mathlib.

`Note.lean` is this, and compiles sorry-free. Every `decide`-able claim in it was checked numerically before it was stated.

**What is reachable.**

- **The construction inequality**, which is the note's actual content: given `c, r, t` with `c, r ≥ n/5` and `t ≥ (r−1)/12`, the bound `min(choose c 2, c^2, r*t/2, c*r) ≥ (choose n 2)/350`. Pure arithmetic, and the place both the units slip and the corner-vs-interior error lived. **Stating it fixes the unit by type**, which is the whole point.
- **The Oliver chain's cyclicity**: `C_(c−1) × C_r` is cyclic iff `Nat.Coprime (c−1) r`, which is condition 4. Mathlib has this.
- **The admissible-`d` table**, `decide`-able: for each `n % 12` and each `d ∈ {2,4,6,12}`, whether `ω(ℓ) < ℓ` at `ℓ = 2, 3`. A finite check, and the claim "every class has at least one admissible `d`" becomes a computation.
- **The `d = 2e, e ∣ 6` derivation**, including the change of variable that makes `ℓ = 2` bite twice at odd `n` — the detail the bridge calls most likely to be queried.

**What is not reachable, and must be assumed.**

- **Proposition 1** needs Oliver's fixed-point theorem. State it as a hypothesis; everything downstream is then honest.
- **The orbital computation** for the two constructions needs the induced action on pairs. Mathlib has `MulAction` and orbits, so this is possible but is real work and is where a note-only project would overrun.
- **The singular-series bound** involves an infinite product over `ℓ ≥ 5`. The two finite factors (`4` at `ℓ = 2`, `9/8` at `ℓ = 3`) are easy; the convergence is not worth it.

**The honest framing.** This would not verify the note's theorem — the theorem is conditional on (H) *and* on Oliver, and neither is formalisable here. It would verify that **the arithmetic between the hypotheses and the conclusion is correct, and that the units are consistent**. Given that every error the note has actually had was in exactly that gap, that is the right thing to check before it goes to arXiv.

## Phasing

**Phase 1 — the inequality core. DONE**, see below. `Basic.lean`: Lemma D1, Proposition F.1, the E′ s-bound with its threshold ladder, the cap algebra and its two identities, the quadratic-residue collapse. Self-contained, none of it needing the group theory, and covering the parts of the documents that have actually been wrong.

**Phase 2 — the balance-point optimisations. Largely done:** `Sigma.lean`'s `xstar`/`balance`/`window_of_eps` give the balance point and window for any (F, η), and `cap_table` is the mod-12 table as instances. Earlier note: the two-foreign closed form `1/(√m₁+√m₂)²` named below as its cleanest target is already proved in `Basic.lean`, and `capF_of_sqrt` is likely the lever for the rest, since a balance point is again a surd supplied once rather than computed repeatedly. Each family's ceiling is `max_x min(...)` of a few polynomials in `x`. These are real-analysis lemmas: routine in principle, fiddly in practice, and the payoff is that the mod-12 ceiling table becomes a checked computation rather than a table. A second payoff worth naming: the window identity `F · width = 1 − √λ` falls out of the same lemmas, and it is exact — the maximum is a *kink*, where an increasing branch meets a decreasing one, not a smooth turning point, which is why the cost of approaching the cap is `Θ(ε)` and not `Θ(√ε)`. The two-foreign closed form `1/(√m₁+√m₂)²` is the cleanest target here since it collapses an infinite family to one identity. Worth doing after phase 1, and only if phase 1 goes smoothly.

**Phase 3 — the value formula as a definition, and the enumeration as a decision procedure.** Define a configuration, define its score by the Part G.3 formulas, define `B n` as the max over configurations, and prove the finiteness facts that make the search terminate (Prop F.1 bounding the part count, Part C bounding block sizes). This does *not* prove `μ* = B` — that needs the group theory — but it does turn `B` into a Lean-checkable function, and then `native_decide` could in principle verify individual table rows. **This is where I would stop.** Verifying the whole CSV is a real project and the payoff over `validate_table.py` plus `brute.py` is small.

**Never — the conjectural layer.** (BCG) in either quantifier strength, the density floor conjecture, and the 1 : 1 : 2 limit — the last of which is now *refuted* rather than open, the entangled correction having removed its mechanism. These are conjectures; formalising a conjecture means formalising its statement, which is useful only if someone will prove it.

## Phase 1 — DONE

`Basic.lean` is sorry-free. Everything the phase was scoped to cover is proved: `orb_full`, Lemma D1, the capacity bound, Prop F.1, the E′ s-bound and both threshold ladders, the `capF` algebra, all six ceiling entries as algebraic numbers, the two-foreign closed form, and the quadratic-residue collapse.

**What made it cheap, and is worth reusing.**

- **`δ = m/N`, then square.** Both threshold ladders are statements about `1/√δ`; squaring clears the real *and* the square root together, leaving `Nat` arithmetic that core Lean proves outright and `decide` settles at each documented threshold. *Where a real-valued claim is an inequality between two squares, the `Nat` form is not an approximation of it — it is the same statement with the coercion removed.* Look for that before reaching for the analysis library.
- **Supply the surd once.** `capF_of_sqrt` takes the root and its defining equation as arguments, so the six ceiling entries became six instances of one identity rather than six separate `Real.sqrt` manipulations. Each is then three lines: substitute, record `s² = F·η`, clear denominators.
- **Prefer stable primitives to convenience lemmas.** `le_div_iff` and `div_lt_iff` have been renamed with a `₀` suffix upstream; the proofs here move across the division by hand instead, which costs a few lines and does not rot. This is the Lean form of a lesson already in `verification-lessons.md` §7 about scripts depending on their environment: a proof naming a lemma that upstream later renames fails with an error pointing at the identifier, not the mathematics.

**What formalising actually bought, which was not the proofs.** Three signature corrections, all in statements whose proofs turned out routine:

| statement | correction |
|---|---|
| `orb_full` | `2 ≤ c` unnecessary — both sides are 0 at `c ≤ 1` |
| `capF_eq_k_sqrt` | `0 ≤ η` unnecessary — `Real.sqrt_mul` needs only the left factor nonneg, and `(F : ℝ) ≥ 0` for any `F : ℕ` |
| `prop_F1` | **false without `0 < k`** — at `k = 0` the sum over `Fin 0` is 0, so `n = 0`, the capacity hypothesis is vacuous, and the conclusion reads `0 < 0` |

The last is the same defect the file already recorded at `size_of_capacity`, which needed `0 < m` for exactly the same reason. **Two instances in one file is a pattern: whenever a claim is "k things each with property P force a bound", check k = 0 before anything else.** A prover cannot skip the degenerate branch the way a reader does, and *that* — not the proofs — is the case for this layer. It also sharpens the table above: the row "would Lean have caught it?" should really be read as "would stating it precisely have caught it?", and the answer there is broader than three of nine.

**One thing the pass did not settle.** Every proof was written without a toolchain to hand and repaired against compiler output over several rounds. The failures were uniformly *name and shape* problems — a renamed division lemma, an iff applied as a function, `χ₄` of the card rather than of `p`, a `simp` that had already closed its goal — and never a false statement, because every `decide`-able claim had been checked numerically first. That is the workflow to keep, not an argument that it was unnecessary.

## What phase 1 pinned down

These documents' claims are now theorems rather than assertions:

- `enumeration-proof.md` Part D1's inequality, Prop F.1, Prop F.2, the E′ s-bound and its ladder, E.3(i)'s `p = 3` forcing, E.4's `3 | 2^a − 1 ⇔ a even`.
- `arithmetic-of-density.md` §3.3's `cap_F(η) = cap₁(Fη)/F` and the `k = √F` reading; §3.3.5's **six** table entries as algebraic numbers, keyed **mod 12**, one of them supplied by the `F = 4` rung — the extremal `7 − 4√3` at `n ≡ 11 (mod 12)`; §4.2's two-foreign closed form; §3.2.3's quadratic-residue collapse. *(The list length is itself the check: a table that gains or loses a constant will not match a list of six.)*
- The `orb` identities used silently throughout, in particular `orb c (c−1) = choose c 2`.

**What was left after phase 1 was phases 2 and 3, and neither is owed.** Phase 2 has since been largely done (`Sigma.lean`); phase 3 would make `B n` a Lean-checkable function, and the judgement above — *this is where I would stop* — still stands, since `validate_table_v3.py` already covers the rows.

## A caveat about what this does *not* buy

A formalised arithmetic layer says nothing about whether the arithmetic is *about the right thing*. The most consequential errors found in review — the S5/S7 fusion-layer conflation, and then the `F_mid` coprimality clause — were correct pieces of arithmetic attached to the wrong group-theoretic object. Lean would have checked the arithmetic and said nothing. Formalisation raises the floor on one class of error and leaves the more interesting class untouched, which is worth knowing before spending weeks on it.

**And there is a sharper version of the caveat, which the `F_mid` episode made concrete.** That clause was asserted in the prose, implemented in the enumerator's cap, re-derived by the validator from witnesses the cap had chosen, and relied on by both certificates. Four artefacts, one source — so no cross-comparison between artefacts could fire, and the defect was additionally invisible to every check that validates the *winner*, since it under-scored a shape that lost. A Lean development of the arithmetic layer would have been a **fifth artefact downstream of the same clause**, and equally silent.

The thing that did catch it was building the group from first principles and comparing against the scored value. That is a different move from formalising, and it is cheaper. **Where a claim is the common ancestor of all the artefacts, the check has to be an independent construction, not another derived statement** — worth knowing before treating formalisation as the general remedy.

## Lessons from compiling

**What compiling immediately paid for.** The draft of the central inequality's block case split the region at `r ≥ 13`; the slack chain fails there — `r² − 7r − 84 < 0` at 13 — and the compiler refused it, forcing the split to 14 with the finite side `n ≤ 65` discharged by `decide`. The region's true numerical worst (`350·m*/pairs n = 1.0096`, at `n = 65, r = 13`) sits **on the finite side**, which is precisely why no uniform slack argument covers it and the `decide` is not decoration. One compile session caught exactly the class of error this project exists to catch, in its own draft.

**A note on lemma names, earned three times.** Every Lean failure in this project so far has been **name drift, not wrong mathematics**: `List.mem_cons_self`'s explicit-vs-implicit arguments, `div_le_div_iff` gone from Mathlib, and, on moving `E5Core.lean` from core 4.15 to 4.36, four core lemmas renamed or re-signed at once (`Nat.pos_pow_of_pos` removed, `Nat.gcd_mul_dvd_mul_gcd` removed, `Nat.dvd_sub` lost its `≤` argument, and the `Nat.Coprime` API that replaces them absent from 4.15). The fix in each case was to reprove the step from lemmas whose name and signature are the same in both toolchains (`Nat.gcd_mul_left`, `Nat.dvd_gcd`, `Nat.mul_sub_left_distrib`, `Nat.pow_pos`). The working rule: **where a goal is routine, reach for a tactic or a decomposition into old, stable lemmas rather than for a named iff-lemma or a convenience lemma**. Known 4.36 deprecations met so far: `if_pos`/`if_neg` (use `simp only [h, ite_true]` or `↓reduceIte`) and `Set.mem_setOf_eq` (use `Set.mem_ofPred_eq`).

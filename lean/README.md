# Formalising the ARK framework: what is worth doing, and in what order

*Written 2026-08. `Basic.lean` is a first pass at phase 1 and has **not been compiled** — no toolchain in the container. Statements are the deliverable; the tactic blocks are sketches.*

## The split that makes this tractable

The framework has two layers and they have completely different formalisation costs.

**The group-theoretic layer is out of reach, and would be even with unlimited effort.** It rests on Oliver's fixed-point theorem, on the classification of primitive solvable permutation groups (Huppert), and on Smith theory. None is in Mathlib. Formalising Oliver's theorem alone is a serious research-level project — it needs equivariant Euler characteristics and the transfer machinery. This is not a "we could if we wanted" situation.

**The arithmetic layer is ordinary Mathlib material.** Everything from Part E′ onward — the inequalities, the counting bounds, the cap algebra, the singular-series definitions, the quadratic-residue step — depends on the group theory only through *stated numbers*: given that a block of size c under a twist of order t contributes `orb c t`, everything else is arithmetic. That layer can be formalised now, taking the value formula as a definition rather than a theorem.

## Why bother, given the theorems are probably true

The honest case is not "we doubt the theorems". It is that **every error found in review has been in the arithmetic layer**, and two of the three were of a kind Lean makes impossible:

| error | kind | would Lean have caught it? |
|---|---|---|
| E′ threshold ladder shifted by one (`δ > 1/25 → s ≤ 3`) | a paraphrase of an inequality that does not follow from it | **yes**, immediately — the statement would not typecheck against the bound |
| within-class cross coefficient keyed on `q`'s parity instead of `F`'s | a rule stated in terms of the wrong variable | **yes** — the definition names its variable |
| the `c mod 8` fusion mechanism | a claim about which layer a subgroup sits in | **no** — this is group theory, and it is the layer we cannot reach |
| a bound stated in `n²` three lines from one stated in `binom n 2` | a units mismatch between two displays | **yes** — the two have different types, and nothing numerical separates them |
| the worst case of a min-of-polynomials read at the interior balance point rather than the boundary corner (`1/48` for `1/300`) | an optimisation evaluated at the wrong point | **yes**, in phase 2 — this is exactly what the balance-point lemmas assert |
| `roots_mod` assuming `K ∣ D`; the missing `gcd(D,K)/K` integrality factor; an enumeration modulus not divisible by `K/gcd(D,K)` | three defects in a **script**, each inert on the parameter range it was written for | **no** — not because they are hard, but because the scripts are not the artefact being formalised |
| the ladder's `prime_divisors_of(F)` excluding the top prime from the foreign twist | a claim about which layer a prime sits in | **no** — group theory again, and the same shape as the `c mod 8` row |
| a stale figure quoted after the table was rebuilt (`0.026117`, "eight ceilings") | a measurement that moved | **no** — this is what `check_doc_figures.py` is for, and it is the largest error class by count |

**Three of eight, and the pattern matters more than the ratio.** Lean catches the errors that are *statements about stated quantities* — inequalities, units, optimisations. It catches none of the three recurring classes that have actually cost the most time: **layer-assignment claims** (group theory), **script defects that are correct on the range they were written for**, and **stale figures**. The last is handled by a checker and the middle by regression discipline; neither is a formalisation problem. That is a narrower case for phase 1 than "two of three" suggested, and it points somewhere more specific — see the note section below.

There is a second benefit that matters more in practice: **a definition forces the variable to be named.** The coefficient error survived three review passes because "F for odd q, F/2 for q = 2" was true when it was written (F was always a q-power then) and nothing in the prose recorded which fact it depended on. A Lean definition cannot be ambiguous about that.

## Phase 0 — the short note, which is a better first target than phase 1

*Added after the note was drafted for arXiv. If anything here gets formalised, this is the piece to start with, and it is smaller than phase 1.*

`mu-theta-n2-note.md` is self-contained, is the artefact that will be read by strangers, and — per the table above — its error record is **disproportionately of the kind Lean catches**: a units mismatch between two displays, a region whose worst case sits at a corner, an asymptotic class stated as `O` where the content is a fixed fraction. Formalising just the note is perhaps 200–400 lines and needs nothing outside Mathlib.

`Note.lean` is a first pass at exactly this, drafted and likewise uncompiled. Every `decide`-able claim in it has been checked numerically first, so a failure to close one is an encoding problem rather than a false statement.

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

**Phase 1 — the inequality core.** `Basic.lean`. Lemma D1, Proposition F.1, the E′ s-bound with its threshold ladder, the cap algebra and its two identities, the quadratic-residue collapse. All of this is self-contained, none needs the group theory, and it covers the parts of the documents that have actually been wrong. Perhaps a few hundred lines with proofs filled in.

**Phase 2 — the balance-point optimisations.** Each family's ceiling is `max_x min(...)` of a few polynomials in `x`. These are real-analysis lemmas: routine in principle, fiddly in practice, and the payoff is that the mod-24 ceiling table becomes a checked computation rather than a table. The two-foreign closed form `1/(√m₁+√m₂)²` is the cleanest target here since it collapses an infinite family to one identity. Worth doing after phase 1, and only if phase 1 goes smoothly.

**Phase 3 — the value formula as a definition, and the enumeration as a decision procedure.** Define a configuration, define its score by the Part G.3 formulas, define `B n` as the max over configurations, and prove the finiteness facts that make the search terminate (Prop F.1 bounding the part count, Part C bounding block sizes). This does *not* prove `μ = B` — that needs the group theory — but it does turn `B` into a Lean-checkable function, and then `native_decide` could in principle verify individual table rows. **This is where I would stop.** Verifying the whole CSV is a real project and the payoff over `validate_table.py` plus `brute.py` is small.

**Never — the conjectural layer.** Hypothesis (H), the density floor conjecture, the 1 : 1 : 2 limit. These are conjectures; formalising a conjecture means formalising its statement, which is useful only if someone will prove it.

## What phase 1 would actually pin down

Concretely, these documents' claims become theorems rather than assertions:

- `enumeration-proof.md` Part D1's inequality, Prop F.1, Prop F.2, the E′ s-bound and its ladder, E.3(i)'s `p = 3` forcing, E.4's `3 | 2^a − 1 ⇔ a even`.
- `arithmetic-of-density.md` §3.3's `cap_F(η) = cap₁(Fη)/F` and the `k = √F` reading; §3.3.5's seven table entries as algebraic numbers (two of them supplied by the `F = 4` rung, including the extremal `7 − 4√3`); §4.2's two-foreign closed form; §3.2.3's quadratic-residue collapse.
- The `orb` identities used silently throughout, in particular `orb c (c−1) = choose c 2`.

## A caveat about what this does *not* buy

A formalised arithmetic layer says nothing about whether the arithmetic is *about the right thing*. The most consequential error found in review — the S5/S7 fusion-layer conflation — was a correct piece of arithmetic attached to the wrong group-theoretic object. Lean would have checked the arithmetic and said nothing. Formalisation raises the floor on one class of error and leaves the more interesting class untouched, which is worth knowing before spending weeks on it.

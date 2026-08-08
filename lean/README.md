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

Two of three. That is a good enough hit rate to justify phase 1, and it is a much better argument than certainty-seeking.

There is a second benefit that matters more in practice: **a definition forces the variable to be named.** The coefficient error survived three review passes because "F for odd q, F/2 for q = 2" was true when it was written (F was always a q-power then) and nothing in the prose recorded which fact it depended on. A Lean definition cannot be ambiguous about that.

## Phasing

**Phase 1 — the inequality core.** `Basic.lean`. Lemma D1, Proposition F.1, the E′ s-bound with its threshold ladder, the cap algebra and its two identities, the quadratic-residue collapse. All of this is self-contained, none needs the group theory, and it covers the parts of the documents that have actually been wrong. Perhaps a few hundred lines with proofs filled in.

**Phase 2 — the balance-point optimisations.** Each family's ceiling is `max_x min(...)` of a few polynomials in `x`. These are real-analysis lemmas: routine in principle, fiddly in practice, and the payoff is that the mod-24 ceiling table becomes a checked computation rather than a table. The two-foreign closed form `1/(√m₁+√m₂)²` is the cleanest target here since it collapses an infinite family to one identity. Worth doing after phase 1, and only if phase 1 goes smoothly.

**Phase 3 — the value formula as a definition, and the enumeration as a decision procedure.** Define a configuration, define its score by the Part G.3 formulas, define `B n` as the max over configurations, and prove the finiteness facts that make the search terminate (Prop F.1 bounding the part count, Part C bounding block sizes). This does *not* prove `μ = B` — that needs the group theory — but it does turn `B` into a Lean-checkable function, and then `native_decide` could in principle verify individual table rows. **This is where I would stop.** Verifying the whole CSV is a real project and the payoff over `validate_table.py` plus `brute.py` is small.

**Never — the conjectural layer.** Hypothesis (H), the density floor conjecture, the 1 : 1 : 2 limit. These are conjectures; formalising a conjecture means formalising its statement, which is useful only if someone will prove it.

## What phase 1 would actually pin down

Concretely, these documents' claims become theorems rather than assertions:

- `enumeration-proof.md` Part D1's inequality, Prop F.1, Prop F.2, the E′ s-bound and its ladder, E.3(i)'s `p = 3` forcing, E.4's `3 | 2^a − 1 ⇔ a even`.
- `arithmetic-of-density.md` §3.3's `cap_F(η) = cap₁(Fη)/F` and the `k = √F` reading; §3.3.5's eight table entries as algebraic numbers; §4.2's two-foreign closed form; §3.2.3's quadratic-residue collapse.
- The `orb` identities used silently throughout, in particular `orb c (c−1) = choose c 2`.

## A caveat about what this does *not* buy

A formalised arithmetic layer says nothing about whether the arithmetic is *about the right thing*. The most consequential error found in review — the S5/S7 fusion-layer conflation — was a correct piece of arithmetic attached to the wrong group-theoretic object. Lean would have checked the arithmetic and said nothing. Formalisation raises the floor on one class of error and leaves the more interesting class untouched, which is worth knowing before spending weeks on it.

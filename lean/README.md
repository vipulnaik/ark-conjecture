# Formalising the ARK framework: what is worth doing, and in what order

*Compile status, per file and per environment — kept explicit because "compiles" and "proves" have come apart here, and only the checker's sorry count separates them.*

| file | laptop (Mathlib) | container (core 4.15.0) | sorries |
|---|---|---|---|
| `Note.lean` | compiles | n/a — needs Mathlib | **zero — every proof complete** (six imported from `ArkCore`) |
| | | | *hypothesis renamed `HypH` → `HypBCG`; see below* |
| `Basic.lean` | compiles | n/a — needs Mathlib | **nonzero** — same |
| `ArkCore.lean` | compiles | compiles | **zero — every proof complete** |

*So **phase 0 is done**: `Note.lean` and `ArkCore.lean` are both fully proved, and between them they cover the note's entire arithmetic layer — the construction inequality, the admissible-`d` table, the density and ceiling statements, `orb`, Lemma D1, the capacity bound, F.1. `Basic.lean` remains the sketch, and its sorry count is the expected state rather than a defect (`leancheck.sh` reports it separately for exactly this reason — a count that DROPS unexpectedly is the thing to notice).*

*What this does and does not establish is worth restating, because a green checker invites over-reading: it verifies that **the arithmetic between the hypotheses and the conclusion is correct, and that the units are consistent**. The note's theorem remains conditional on (H) and on Oliver's theorem, neither of which is formalised or formalisable here. That is the check that was worth having before arXiv, and it is now had.* **`ArkCore.lean` is different: it is compiled and fully proved** — zero sorries against core Lean 4.15.0 — and covers the ℕ half of both files: the central inequality (`central_even`, `central_odd`), Lemma D1, the capacity bound, Proposition F.1 in squared form, `orb` with the full-twist collapse, and every `decide` table. All three were reviewed after the entangled-generator correction.*

**The container build is reproduced, and the recipe below works as written.** `ArkCore.lean` compiles against core 4.15.0 with **no output at all** — no errors, no warnings, and no `declaration uses 'sorry'`, which is the actual evidence for the zero-sorry claim, a silent compile being the only thing that distinguishes a complete proof from a sketch. Total cost is a 265 MB download and a few minutes.

**Toolchain, and how to get one in the working container.** elan cannot resolve any toolchain there — every lookup goes through `release.lean-lang.org`, which is off the network allowlist — but the toolchain tarball itself is on GitHub releases, which is on it:

```bash
curl -sSfL https://github.com/leanprover/lean4/releases/download/v4.15.0/lean-4.15.0-linux.tar.zst -o lean.tar.zst
python3 -c "import zstandard,tarfile; tarfile.open(fileobj=zstandard.ZstdDecompressor().stream_reader(open('lean.tar.zst','rb')),mode='r|').extractall('.')"   # no zstd binary in the image
export PATH=$PWD/lean-4.15.0-linux/bin:$PATH
lean ArkCore.lean        # bare invocation; no lakefile needed for the core file
```

**The hypothesis is the note's, and the name now says so.** `Note.lean` formalises `mu-theta-n2-note.md`, whose hypothesis is the **fixed `n/5` window, all large n** — in the framework's naming, **(BCG_{1/5}-AL)**. It is *not* the framework's (BCG-AL), and the two are **not nested in either direction**: at `n ≡ 11 (mod 12)` the framework's optimum is the `F = 4` shape with `c/n ≈ 0.134`, which the `n/5` window rejects outright, while the note's constant is far weaker. The structure was called `HypH`, which invited exactly that conflation and additionally collided with Schinzel's Hypothesis H; it is now `HypBCG`, with the non-nesting recorded at its docstring. Renamed and recompiled.

**A note on lemma names, earned twice.** Two of this project's three Lean failures so far were **name drift, not wrong mathematics**: `List.mem_cons_self`'s explicit-vs-implicit arguments across toolchains, and `div_le_div_iff`, which 4.33's Mathlib no longer has under that name. Neither statement was false. The working rule that follows: **where a goal is trivial or routine, reach for a tactic or a decomposition into ancient lemmas rather than for a named iff-lemma.** The division inequalities are now proved by "difference is nonneg" — `div_nonneg`, `field_simp`, `ring`, `linarith`, `positivity`, all stable for years — instead of by whatever `div_le_div_*` is currently called. Ordering-and-division iff-lemmas are the highest-churn corner of Mathlib and worth routing around on sight.

**Importing `ArkCore` from `Note.lean`.** Lean resolves imports through `LEAN_PATH` and lake's build directories, **not** through the filesystem beside the importing file, and it loads the compiled `.olean` rather than the source — so co-locating the two `.lean` files does nothing, and `PATH` is not consulted at all. Either build the olean and point `LEAN_PATH` at it:

```bash
lake env lean -o ArkCore.olean ArkCore.lean
LEAN_PATH=$PWD ./leancheck.sh Note.lean
```

Three gotchas, all found the hard way: `leancheck.sh` already calls `lake env lean`, so don't wrap it again; **`LEAN_PATH` must be set on the same command line** — exporting it beforehand does not take, since the script's own environment handling drops it; and write `LEAN_PATH=$PWD`, not `LEAN_PATH=$PWD:$LEAN_PATH`, because when the variable is unset the trailing colon leaves an empty path entry that Lean rejects. Alternatively, move the files under the lake library's source directory and import by its module prefix, `import Ark.ArkCore` — the more durable option, and what `leancheck.sh` assumes when run bare from the project root.

**Mathlib remains out of reach there** — `lake exe cache get` needs its cache host, and a source build is days — which is what makes the core/Mathlib split load-bearing rather than aesthetic: everything that is genuinely about ℕ lives in `ArkCore.lean` and is *proved*, while `Note.lean` / `Basic.lean` keep the real-number material (`Density`, `capF`, the surd table) as Mathlib sketches to be compiled wherever Mathlib exists. `leancheck.sh` is for the latter situation (a lake project root); the core file needs only `lean` itself.

*(A drift note, since this header has now been wrong in both directions: it said "neither has been compiled" after `Note.lean` had compiled on the laptop — the header described the drafting container and was read as describing the project. Compile status is per-machine here, because the container and the laptop have different reach; this header now says which.)*

**What compiling immediately paid for.** The draft of the central inequality's block case split the region at `r ≥ 13`; the slack chain fails there — `r² − 7r − 84 < 0` at 13 — and the compiler refused it, forcing the split to 14 with the finite side `n ≤ 65` discharged by `decide`. The region's true numerical worst (`350·m*/pairs n = 1.0096`, at `n = 65, r = 13`) sits **on the finite side**, which is precisely why no uniform slack argument covers it and the `decide` is not decoration. One compile session caught exactly the class of error this project exists to catch, in its own draft.

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
| the `F_mid` coprimality clause: a **necessary** condition that was only sufficient | an object entering as a *quotient* treated as a *subgroup* | **no** — same layer, and the sharpest instance yet: it was consistent with every artefact because every artefact derived from it |
| a bound stated in `n²` three lines from one stated in `binom n 2` | a units mismatch between two displays | **yes** — the two have different types, and nothing numerical separates them |
| the worst case of a min-of-polynomials read at the interior balance point rather than the boundary corner (`1/48` for `1/300`) | an optimisation evaluated at the wrong point | **yes**, in phase 2 — this is exactly what the balance-point lemmas assert |
| `roots_mod` assuming `K ∣ D`; the missing `gcd(D,K)/K` integrality factor; an enumeration modulus not divisible by `K/gcd(D,K)` | three defects in a **script**, each inert on the parameter range it was written for | **no** — not because they are hard, but because the scripts are not the artefact being formalised |
| the ladder's `prime_divisors_of(F)` excluding the top prime from the foreign twist | a claim about which layer a prime sits in | **no** — group theory again, and the same shape as the `c mod 8` row |
| a stale figure quoted after the table was rebuilt (`0.026117`, "eight ceilings") | a measurement that moved | **no** — this is what `check_doc_figures.py` is for, and it is the largest error class by count |

**Three of nine, and the pattern matters more than the ratio.** Lean catches the errors that are *statements about stated quantities* — inequalities, units, optimisations. It catches none of the three recurring classes that have actually cost the most time: **layer-assignment claims** (group theory), **script defects that are correct on the range they were written for**, and **stale figures**. The last is handled by a checker and the middle by regression discipline; neither is a formalisation problem. That is a narrower case for phase 1 than "two of three" suggested, and it points somewhere more specific — see the note section below.

There is a second benefit that matters more in practice: **a definition forces the variable to be named.** The coefficient error survived three review passes because "F for odd q, F/2 for q = 2" was true when it was written (F was always a q-power then) and nothing in the prose recorded which fact it depended on. A Lean definition cannot be ambiguous about that.

## Phase 0 — the short note, which is a better first target than phase 1

*Added after the note was drafted for arXiv. **Status: the ℕ half is done** — `ArkCore.lean` proves `central_even`/`central_odd` (the construction inequality, multiplied through by 350), `mStarOdd_le_even`, the full admissible-`d` table block, and the degeneration example, leaving to Mathlib only the `Density`/`ℝ` wrappers, the `ZMod` chinese-remainder step, and the singular-series material.*

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

**Phase 2 — the balance-point optimisations.** Each family's ceiling is `max_x min(...)` of a few polynomials in `x`. These are real-analysis lemmas: routine in principle, fiddly in practice, and the payoff is that the mod-12 ceiling table becomes a checked computation rather than a table. A second payoff worth naming: the window identity `F · width = 1 − √λ` falls out of the same lemmas, and it is exact — the maximum is a *kink*, where an increasing branch meets a decreasing one, not a smooth turning point, which is why the cost of approaching the cap is `Θ(ε)` and not `Θ(√ε)`. The two-foreign closed form `1/(√m₁+√m₂)²` is the cleanest target here since it collapses an infinite family to one identity. Worth doing after phase 1, and only if phase 1 goes smoothly.

**Phase 3 — the value formula as a definition, and the enumeration as a decision procedure.** Define a configuration, define its score by the Part G.3 formulas, define `B n` as the max over configurations, and prove the finiteness facts that make the search terminate (Prop F.1 bounding the part count, Part C bounding block sizes). This does *not* prove `μ = B` — that needs the group theory — but it does turn `B` into a Lean-checkable function, and then `native_decide` could in principle verify individual table rows. **This is where I would stop.** Verifying the whole CSV is a real project and the payoff over `validate_table.py` plus `brute.py` is small.

**Never — the conjectural layer.** Hypothesis (H), the density floor conjecture, the 1 : 1 : 2 limit. These are conjectures; formalising a conjecture means formalising its statement, which is useful only if someone will prove it.

## What phase 1 would actually pin down

Concretely, these documents' claims become theorems rather than assertions:

- `enumeration-proof.md` Part D1's inequality, Prop F.1, Prop F.2, the E′ s-bound and its ladder, E.3(i)'s `p = 3` forcing, E.4's `3 | 2^a − 1 ⇔ a even`.
- `arithmetic-of-density.md` §3.3's `cap_F(η) = cap₁(Fη)/F` and the `k = √F` reading; §3.3.5's **six** table entries as algebraic numbers, keyed **mod 12**, one of them supplied by the `F = 4` rung — the extremal `7 − 4√3` at `n ≡ 11 (mod 12)`; §4.2's two-foreign closed form; §3.2.3's quadratic-residue collapse. *(The list length is itself the check: a table that gains or loses a constant will not match a list of six.)*
- The `orb` identities used silently throughout, in particular `orb c (c−1) = choose c 2`.

## A caveat about what this does *not* buy

A formalised arithmetic layer says nothing about whether the arithmetic is *about the right thing*. The most consequential errors found in review — the S5/S7 fusion-layer conflation, and then the `F_mid` coprimality clause — were correct pieces of arithmetic attached to the wrong group-theoretic object. Lean would have checked the arithmetic and said nothing. Formalisation raises the floor on one class of error and leaves the more interesting class untouched, which is worth knowing before spending weeks on it.

**And there is a sharper version of the caveat, which the `F_mid` episode made concrete.** That clause was asserted in the prose, implemented in the enumerator's cap, re-derived by the validator from witnesses the cap had chosen, and relied on by both certificates. Four artefacts, one source — so no cross-comparison between artefacts could fire, and the defect was additionally invisible to every check that validates the *winner*, since it under-scored a shape that lost. A Lean development of the arithmetic layer would have been a **fifth artefact downstream of the same clause**, and equally silent.

The thing that did catch it was building the group from first principles and comparing against the scored value. That is a different move from formalising, and it is cheaper. **Where a claim is the common ancestor of all the artefacts, the check has to be an independent construction, not another derived statement** — worth knowing before treating formalisation as the general remedy.

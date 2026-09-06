# Formalising the ARK framework: what is worth doing, and in what order

*Compile status, per file and per environment — kept explicit because "compiles" and "proves" have come apart here, and only the checker's sorry count separates them. **The plan for October 2026 and 2027 is its own section below**, agreed and vetted at the end of session 14.*

| file | laptop (Mathlib) | container (core 4.15.0) | sorries |
|---|---|---|---|
| `Note.lean` | compiles | n/a — needs Mathlib | **zero — every proof complete** (six imported from `ArkCore`) |
| | | | *hypothesis renamed `HypH` → `HypBCG`; see below* |
| `Basic.lean` | compiles | n/a — needs Mathlib | **zero — every proof complete**, from 18 |
| `ArkCore.lean` | compiles | compiles | **zero — every proof complete** |

**All three files are now sorry-free.** `Basic.lean` went 18 → 0 in one pass; what that pass actually bought is set out under *Phase 1* below, and it was not the proofs.

*So **phase 0 is done**: `Note.lean` and `ArkCore.lean` are both fully proved, and between them they cover the note's entire arithmetic layer — the construction inequality, the admissible-`d` table, the density and ceiling statements, `orb`, Lemma D1, the capacity bound, F.1. `Basic.lean` was the sketch until its 18 → 0 pass and is now proved too; `leancheck.sh` still reports the sorry count separately, and the thing to notice is now a count that RISES — a proof that has been reopened.* *(An earlier form of this sentence still called `Basic.lean` the sketch after the table above had recorded it sorry-free; the header contradicted itself for one paragraph.)*

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

## The plan for October 2026 and 2027

*Agreed between Vipul and Claude at the end of session 14, and vetted by both. The planning-level version is `claude-understanding-of-project-plan.md` §9; this is the technical one — what to state, in what order, and what Mathlib does and does not supply.*

### October: `Note.lean` from the arithmetic to the whole conditional argument

**The target.** The note's Theorem is: (BCG_{1/5}-AL), plus Oliver's theorem in the form KSS use it, implies μ(n) ≥ δ₀·C(n,2) for all large n. `Note.lean` currently proves the arithmetic half — from a configuration's parameters to its density. October adds everything between the literature and that: the graph-theoretic definitions, the constructions as actual permutation groups with their Oliver chains and pair-orbitals, and the assembly. **Assumed as a named hypothesis: the KSS–Oliver congruence. Not assumed: BBKN**, whose only contribution to the note is the Ω(n log n) bound, replaced by a three-line theorem.

**The assumed theorem is statable with no topology, and that is what makes this a one-month project rather than a research programme.** KSS + Oliver give, for every Oliver Γ ≤ S_n and every non-evasive nontrivial monotone P:

> χ(Δ_P^Γ) ≡ 1 (mod q), with equality χ = 1 when the top is trivial,

where Δ_P^Γ is the complex of Γ-invariant graphs lying in P. Its Euler characteristic is Σ over nonempty unions U of orbitals with U ∈ P of (−1)^(#orbitals in U − 1) — a `Finset` sum. So:

```lean
/-- The KSS–Oliver input, as one hypothesis.  A `structure`, never `axiom`:
    the project's claim that its files rest on Lean's three standard axioms
    must survive October.  Stated for the trivial-top case `χ = 1` and the
    general case `χ ≡ 1 [MOD q]` separately, because the note uses the first. -/
structure HypKSSOliver (n : ℕ) where
  congruence : ∀ (P : GraphProperty n), P.Monotone → P.Nontrivial → NonEvasive P →
    ∀ (Γ : Subgroup (Equiv.Perm (Fin n))), OliverGroup Γ →
      fixedComplexEuler P Γ ≡ 1 [MOD topPrime Γ]
```

The sparse-evasiveness theorem is then one line: if every graph in P has fewer than the minimum orbital's size, no nonempty union of orbitals lies in P, `fixedComplexEuler P Γ = 0`, and 0 ≢ 1.

**Definitions to write, and the ones Lean will police.**

| definition | Mathlib supplies | what stating it precisely buys |
|---|---|---|
| `GraphProperty n` — a set of graphs on `Fin n` invariant under `Equiv.Perm (Fin n)` | `SimpleGraph`, `Finset` | — |
| `Monotone`, `Nontrivial` | — | nontriviality is `∅ ∈ P ∧ ⊤ ∉ P`; the oriented case (`directed-graph-properties.md` §5b) showed this has no analogue without a unique top — irrelevant here, but the definition should not be written to generalise |
| `NonEvasive P` — decision-tree depth < C(n,2) | — | **the recursion**: non-evasive iff constant, or *some* variable has *both* restrictions non-evasive. A checker in session 14 had this inverted for two turns; a `def` cannot be |
| `OliverGroup Γ` — ∃ Γ₂ ◁ Γ₁ ◁ Γ, Γ₂ a p-group, Γ₁/Γ₂ cyclic, Γ/Γ₁ a q-group | `IsPGroup`, `IsCyclic`, `Subgroup.Normal`, quotients | forces "transitive Oliver *subgroup*" wherever the criterion is applied; "transitive" alone does not typecheck |
| `orbitals Γ` — orbits on unordered pairs | `MulAction.orbit`, `Sym2` | — |
| `fixedComplexEuler P Γ` | `Finset.sum`, `Finset.powerset` | — |
| `muLower n` — the constructions' minimum orbital | — | this is `mStarEven`/`mStarOdd`, already in `ArkCore` |

**Order of work, by friction, agreed:**

1. **Theorem E.5 and `ladder-completeness.md` Proposition 1 first**, in `Basic.lean`. Arithmetic, Mathlib-only, days. E.5 has had one human reading and carries the "μ known exactly to 10⁶" claim; it is the highest-value undone piece in the project independently of the rest of this plan (Phase 1b below).
2. **The definitions above and `HypKSSOliver`.** No proofs yet; the point is that they typecheck against each other and against the theorem statement.
3. **The unconditional family** n = 2m, m a prime power — two blocks of 𝔽_m with the entangled generator, orbitals {m(m−1), m²}, Oliver with trivial top. Smallest group, no foreign block, the note's Theorem 2.2 analogue.
4. **The two-part construction** n = F·c + r, **with c prime first** (`ZMod p`, a field with no ceremony), the block group `AGL(1,c)` as a subgroup of `Equiv.Perm (ZMod p)`, the foreign block `ZMod r` with twist of order t, the chain, and the pair-orbitals. Then **c = p^a** via `GaloisField`, which costs more at every lemma.
5. **`theorem_conditional`**: `HypBCG → HypKSSOliver → ∀ n ≥ N, ∀ P, (∀ G ∈ P, |E(G)| < δ₀·C(n,2)) → Evasive P`.
6. **The BBKN replacement**: `μ(n) ≥ n·(Q(n) − 1)/2` from `orb_full` and the fused construction at c = Q(n). Three lines; it is the note's §1 commentary made formal.

**What Mathlib is missing for step 4, and what to do about it.** Affine groups exist as `AffineGroup`-style structures but not as *permutation groups on the field*; the fused/entangled product and wreath-type products are absent; `IsMultiplyPretransitive` exists, k-*homogeneity* (transitivity on k-sets) does not. Each is a self-contained definition with a handful of lemmas, and each should be written **as a general Mathlib-style definition in its own file**, not inlined into the construction — that is what makes it a candidate contribution rather than project debris. **Keep a list of every definition wished for**, written against the proofs that needed it; the list is the output of the month for the Groupprops thread below.

**Operational rules.** Pin `lean-toolchain` and the Mathlib commit on 1 October and **do not bump mid-month** — two of this project's three Lean failures were name drift, and the FLT run reports 26% of files changing on one bump. Route around Mathlib's ordering-and-division iff-lemmas as `Basic.lean` already does. **Lean follows the note, not the reverse**: names and statement order track the vetted human text, and a formalisation that wants to rename something files a note rather than doing it.

### The Groupprops / mathcheck thread — independent infrastructure, with ARK as a first application

This is **not** part of the ARK Lean plan and does not gate it. Vipul's mathcheck framework (LLM-written *deterministic* scripts for the tedious parts of verbal math checking — undeclared variables, unit consistency — so that LLM and human effort goes to what needs judgement) already has GAP components. The Lean extension would be **scripts that take a Groupprops page and extract what a Lean formalisation needs as input**, applicable across Groupprops generally, with the LLM doing the steps deterministic scripts cannot. The ARK constructions give a first set of pages to try — the affine group `AGL(1,q)`, 2-homogeneity, the Oliver class, wreath and entangled products — and Groupprops may need those pages written or extended first, which needs no subscription. The "definitions wished for" list from October is the handoff between the two threads. **Neither depends on the other; this may or may not happen.**

### 2027: the fuller document, and the ceiling stated now

**What is reachable in one to two months of Max**, and would be a complete honest artefact:

- E.5 and Proposition 1 — done in October.
- **Part E realisability in general**: μ ≥ B for the whole shape space — the October constructions generalised to any F, any foreign block, S6/S11.
- **Phase 3**: `B n` as a computable function — configurations, the Part G.3 score, the max — with `native_decide` on individual rows. Not the whole CSV.
- **Part 0 stated as a named hypothesis** `HypShapeComplete`, so that `μ = B` is a Lean theorem conditional on exactly one classification input.

**What is not reachable, and the plan must not be read as aiming at it.** Part 0's completeness rests on Huppert's classification of solvable 2-transitive groups, and that is not going into Lean by one person in two months — nor should the corpus be built as if it were. **"Everything except the classification is machine-checked" is a strong statement and is available. "Everything is machine-checked" is not.** The FLT run shows the second is a matter of effort rather than possibility — Oliver's theorem is a short 1975 paper, "weeks of agent time" on that evidence — but that run was eleven days of parallel agents on a bespoke platform, not a chat window, and its output was by its own assessment not readable as mathematics. For a document whose purpose is exposition, the checked *statement* is the artefact worth having, and that is what the hypothesis-parameterised form delivers.

### Phase 1b — Theorem E.5, added here because it postdates the phasing above

Theorem E.5 did not exist when this list was drawn up and is now the most valuable target in it. `enumeration-proof.md` Part E‴'s Theorem E.5 caps the SAFE score of every fallback configuration below `C(n,2)/25`, and Corollary E.6 then gives `μ(n) = B(n)` wherever `B(n) > C(n,2)/25` — which is what turned the per-n collapse certificate into a single theorem covering every `n ≤ 10⁶`. Three things make it the right next target. **It is arithmetic on stated quantities**: four counting sub-cases on SAFE terms, no Lemma C, no J0a — exactly the layer the table above says Lean catches. **It has had one human reading**, against three for Lemma B′, and it now carries more weight than anything else in the framework. **And its two boundary constants are the kind that drift**: the fifteen exceptions all at `n ≤ 63`, and the `1/25` line coinciding with the floor conjecture's — a Lean statement fixes both by type. Proposition 1 of `ladder-completeness.md` (above `1/25` the optimum is a menu shape or S6/S11; `cap_F(1) > 1/25 ⟺ F ≤ 16`) is the companion and is the same kind of argument. Together they are perhaps the size of phase 1 again.

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

**Phase 1 — the inequality core. DONE**, see below. `Basic.lean`: Lemma D1, Proposition F.1, the E′ s-bound with its threshold ladder, the cap algebra and its two identities, the quadratic-residue collapse. Self-contained, none of it needing the group theory, and covering the parts of the documents that have actually been wrong.

**Phase 2 — the balance-point optimisations. Partly pre-empted:** the two-foreign closed form `1/(√m₁+√m₂)²` named below as its cleanest target is already proved in `Basic.lean`, and `capF_of_sqrt` is likely the lever for the rest, since a balance point is again a surd supplied once rather than computed repeatedly. Each family's ceiling is `max_x min(...)` of a few polynomials in `x`. These are real-analysis lemmas: routine in principle, fiddly in practice, and the payoff is that the mod-12 ceiling table becomes a checked computation rather than a table. A second payoff worth naming: the window identity `F · width = 1 − √λ` falls out of the same lemmas, and it is exact — the maximum is a *kink*, where an increasing branch meets a decreasing one, not a smooth turning point, which is why the cost of approaching the cap is `Θ(ε)` and not `Θ(√ε)`. The two-foreign closed form `1/(√m₁+√m₂)²` is the cleanest target here since it collapses an infinite family to one identity. Worth doing after phase 1, and only if phase 1 goes smoothly.

**Phase 3 — the value formula as a definition, and the enumeration as a decision procedure.** Define a configuration, define its score by the Part G.3 formulas, define `B n` as the max over configurations, and prove the finiteness facts that make the search terminate (Prop F.1 bounding the part count, Part C bounding block sizes). This does *not* prove `μ = B` — that needs the group theory — but it does turn `B` into a Lean-checkable function, and then `native_decide` could in principle verify individual table rows. **This is where I would stop.** Verifying the whole CSV is a real project and the payoff over `validate_table.py` plus `brute.py` is small.

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

**What is left is phases 2 and 3, and neither is owed.** Phase 2's remaining content is the balance-point maxima; phase 3 would make `B n` a Lean-checkable function, and the README's own judgement — *this is where I would stop* — still stands, since `validate_table_v3.py` already covers the rows.

## A caveat about what this does *not* buy

A formalised arithmetic layer says nothing about whether the arithmetic is *about the right thing*. The most consequential errors found in review — the S5/S7 fusion-layer conflation, and then the `F_mid` coprimality clause — were correct pieces of arithmetic attached to the wrong group-theoretic object. Lean would have checked the arithmetic and said nothing. Formalisation raises the floor on one class of error and leaves the more interesting class untouched, which is worth knowing before spending weeks on it.

**And there is a sharper version of the caveat, which the `F_mid` episode made concrete.** That clause was asserted in the prose, implemented in the enumerator's cap, re-derived by the validator from witnesses the cap had chosen, and relied on by both certificates. Four artefacts, one source — so no cross-comparison between artefacts could fire, and the defect was additionally invisible to every check that validates the *winner*, since it under-scored a shape that lost. A Lean development of the arithmetic layer would have been a **fifth artefact downstream of the same clause**, and equally silent.

The thing that did catch it was building the group from first principles and comparing against the scored value. That is a different move from formalising, and it is cheaper. **Where a claim is the common ancestor of all the artefacts, the check has to be an independent construction, not another derived statement** — worth knowing before treating formalisation as the general remedy.

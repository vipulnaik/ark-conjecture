# Formalising the ARK framework: what is worth doing, and in what order

*Compile status, per file, as of 2026-11-26. The forward plan is in "The plan" below; most of its 2026-10 order of work is now done or superseded, and the status at the top of that section says which. **What is still open** is listed once, under "Open, as of 2026-11-26" at the end of the plan.*

| file | `lake build` (Mathlib v4.36.0, pinned here) | sorries |
|---|---|---|
| `ArkCore.lean` | compiles | **zero** |
| `E5Core.lean` | compiles | **zero** — E.5's counting and congruence steps; see "Theorem E.5" below |
| `Note.lean` | compiles | **zero** (six proofs imported from `ArkCore`) |
| `Basic.lean` | compiles | **zero** |
| `Bridge.lean` | compiles | **zero** — `E5Core.IsPrimeN p ↔ Nat.Prime p` |
| `E5Assembly.lean` | compiles | **zero** — SAFE as a function (Part G.3); **Theorem E.5 in full**: `e5` (all branches) and `e5_exceptions` (exceptional n = the table's 12) |
| `E6.lean` | compiles | **zero** — Corollary E.6 on a model of the shape space including D2's parts; μ\* abstract (sandwich halves as hypotheses) |
| `D2.lean` | compiles | **zero** — Lemma D2's counting classes for a permutation group of the orbit; the normal form as hypothesis (discharged by `Glue`/`Rescale`/`D2Full`/`D2q`) |
| `Chain.lean` | compiles | **zero** — Oliver's chain; r-subgroups cyclic (r ∉ {p, q}); D2 Step 1, given affine block actions (supplied by `LemmaB`) |
| `Step2.lean` | compiles | **zero** — D2 Step 2's change of origins: H¹ = 0 by averaging, for any finite Q with |Q| invertible |
| `Glue.lean` | compiles | **zero** — Step 2 applied to Γ|_O/T\*: per-block origins giving the normal form (σi, a·x + s) |
| `Rescale.lean` | compiles | **zero** — **Lemma D2's C(F,2)·r bound end to end** (r ∉ {p, q}), given affine block actions (discharged in `D2Full`) |
| `LemmaB.lean` | compiles | **zero** — **Lemma B for a prime block** (`lemmaB_block`), by an elementary route |
| `D2Full.lean` | compiles | **zero** — **Lemma D2 (r ∉ {p, q}) from the chain alone, no Lemma B hypothesis** (`d2_noB`) |
| `D2q.lean` | compiles | **zero** — **Lemma D2q (r = q) from the chain**, and `lemmaD2`: all three of D2's classes |
| `FoBridge.lean` | compiles | **zero** — E.6's `fo` scores proved to bound real orbitals (from `lemmaD2`) |
| `D1.lean` | compiles | **zero** — Lemma D1 (absorption) in the E.6 model |
| `LemmaBprime.lean` | compiles | **zero** — **Lemma B′** from the chain and primitivity alone (`lemmaBprime_primitive`): an outside block has prime size, twist a q-group |
| `Prop1.lean` | compiles | **zero** — `ladder-completeness.md` Proposition 1's counting clauses: share > 1/5 and ≤ 4 parts, fusion count **sharpened to F ≤ 15**, foreign efficiency, the S12 merge, the three-foreign-prime reduction k ≤ 5/12/17 |
| `ThreeForeign.lean` | compiles | **zero** — **Proposition 1: no configuration above 1/25 has three foreign primes**, every q and exponent (`no_three_foreign`) |
| `Prop1Final.lean` | compiles | **zero** — **Proposition 1 assembled** (`prop1`): above the line, matched by ≤ 1 class + ≤ 2 foreign parts, F ≤ 15 |
| `TwoForeign.lean` | compiles | **zero** — **Proposition 2**: S6 ≤ C(n,2)/9, S11 ≤ C(n,2)/16, every q, no exceptions (`s6_ceiling`, `s11_ceiling`); both **strict** (`s6_ceiling_lt`, `s11_ceiling_lt`, via `two_foreign_lt`: the kernel check rerun one unit tighter) |
| `BCG.lean` | compiles | **zero** — (BCG) as **specification × quantifier**: `Hyp W L`, filters `atTop` (AL) and `almostAll` (AA), AL ⇒ AA, AA non-vacuous; the note's arithmetic half proved pointwise and lifted to both |
| `Sigma.lean` | compiles | **zero** — Σ₀ as data; (BH-SW) six-cell agreement by `decide`; balance point and window lemma for any (F, η, window); clause 2's window ↔ (1 − ε)δ₀; §3.3.5 caps as instances (`cap_table`) |
| `SigmaHalf.lean` | compiles | **zero** — **the arithmetic half of (BCG) for any class specification** (`pointwise_half`), and for Σ₀ under (AL) or (AA) by one proof (`sigma0_half`) |
| `PartE1.lean` | compiles | **zero** — **Part E for F = 1**: explicit group on 𝔽_c ⊔ ℤ/r with an Oliver chain and every pair-orbital ≥ SAFE (`partE_F1_exists`); Σ₀'s even-n floor with Part E proved (`sigma0_F1_realised`) |
| `PartEF.lean` | compiles | **zero** — **Part E for a fused class (F ≥ 2)** via the entangled generator (`partE_F_exists`); **Σ₀'s floor at every class with Part E proved** (`PartEAll.sigma0_realised`) |
| `CycGood.lean` | compiles | **zero** — the cyclic χ-tables: C_k (k = 1, 2, 3, 6) admits no invariant proper complex with χ ≡ 1 (mod q), for q as stated (`good1`, `good2`, `good3`, `good6`; k = 6 by `decide +kernel`, ~60 s) |
| `Evasive.lean` | compiles | **zero** — abstract evasiveness interface: down-closed properties, orbitals, the **named hypothesis `HypKSSOliver`** (KSS/Oliver congruence), and the single-good-type Proposition (`evasive_of_good_type`) |
| `RGlue.lean` | compiles | **zero** — the ℤ/r block's pair-orbitals under multiplication by U·⟨w⟩: r(r−1)/2 pairs in exactly k orbits of type i (`O_injective`, `O_union_card`) |
| `Threshold.lean` | compiles | **zero beyond `HypKSSOliver`** — **the threshold beyond μ\*** (staging, `../notes/threshold-beyond-mu.md` Proposition L lower half): under (AL) or (AA), every property with e_max < m on n points is evasive given KSS/Oliver, with 2m ≥ ((1 − ε)·δ_cyc − κ/n)·n(n − 1), δ_cyc = 1/4 even, 3 − 2√2 odd (`thr_realised`) |
| `Cover.lean` | compiles | **zero** — **the ⇒ direction of `arithmetic-of-density.md` §6** (covering statement): a SAFE floor δ > 1/25 under (AL) or (AA) forces n into Proposition 1's systems, shrinking with δ — F ≤ 15 (`cover_25`), F ≤ 8 and no S11 above 1/16 (`cover_16`), F ≤ 3 and no S6/S11 above 1/9 (`cover_9`); general form `cover_hyp`; closed floors at 1/16 and 1/9 (`fexact`, `cover_16_closed`, `cover_9_closed`); parity rule (`parity_one`, `parity_two`) |
| `CoverDensity.lean` | compiles | **zero** — the escapes counted: O(x/log x) up to x (`esc_count`, via Mathlib's Chebyshev bound on π(x)); so a floor δ > 1/25 under (AL) or (AA) forces a system **with a foreign part** outside O(x/log x) exceptions (`cover_foreign`) |
| `Upper.lean` | compiles | **zero beyond two named hypotheses** — **Proposition U_typ** (the ceiling on μ\*_N^fpf): m\*_N, m\*_typ, N\*; level 1 sound under `HypKSSOliver` (`evasive_below_mN`); Step 1 (`Nstar_orb`); Step 3 exactly, 2·m\*_N·W² < n(n − 1) (`mN_lt_intrans`); splitting halves (`mN_half`); given `HypStep2` (§6.3 Step 2) and `HypConjP` (Conjecture P): m\*_N(Γ) < δ_cyc(n)·C(n,2) for fixed-point-free Oliver Γ, n not a prime power, n ∉ E (`Utyp_even`, `Utyp_odd`); Step 4 proved (`step4`), so Conjecture P can be replaced by Step 5 alone plus Step 2 for blocks (`HypStep5`, `HypStep2Block`; `Utyp_even_steps`, `Utyp_odd_steps`) |
| `UpperDensity.lean` | compiles | **zero** — E is O(x/log x): its first clause lies in `CoverDensity`'s escapes (`E1_count`), and its second clause at odd n is 2^j + (prime power ≤ 2^(j+2)), counted by a geometric sum (`E2_count`). **`ceiling_density`**: given the three named hypotheses, μ\*_N^fpf(n) < δ_cyc(n)·C(n,2) outside O(x/log x) exceptions |

*Last reproduced at commit 59f38da (2026-11-26) in the working container: `lake build` clean, `leancheck.sh` 0 errors, 0 warnings, 0 sorries across all 35 files.*

*What a green build establishes, restated because it invites over-reading: **the arithmetic between the hypotheses and the conclusion is correct, and the units are consistent.** The note's theorem remains conditional on (BCG_{1/5}) and on Oliver's theorem, neither formalised here.*

## Building

**This directory is a lake project.** `lean-toolchain` pins `leanprover/lean4:v4.36.0` and `lakefile.toml` pins Mathlib to the tag `v4.36.0`; `lake-manifest.json` records the exact dependency commits. The `.lean` files stay at the top level and import each other by bare module name (`import ArkCore`); the lakefile lists them as roots of one library with `srcDir = "."`. **Do not bump the pin mid-piece-of-work** — two of the project's first three Lean failures were name drift (see below).

```bash
cd lean
lake exe cache get        # ~9,100 prebuilt Mathlib files; needs cache.mathlib.org
lake build                # all 35 files; ~20 minutes from a cold build (TwoForeign, ThreeForeign and E5Assembly's kernel checks dominate)
bash leancheck.sh         # per-file errors / warnings / sorry counts
```

`leancheck.sh` must run from this directory (it looks for `lean-toolchain`). The only expected warning is Mathlib's suggestion that files importing it adopt the module system; `leancheck.sh` does not count it.

**Network, for a sandboxed container.** `lake exe cache get` needs `cache.mathlib.org`; cloning Mathlib needs GitHub. elan downloads toolchains from `releases.lean-lang.org` (plural). If that host is blocked, fetch the tarball from GitHub releases and register it by hand:

```bash
curl -sSfL https://github.com/leanprover/lean4/releases/download/v4.36.0/lean-4.36.0-linux.tar.zst -o lean.tar.zst
python3 -c "import zstandard,tarfile; tarfile.open(fileobj=zstandard.ZstdDecompressor().stream_reader(open('lean.tar.zst','rb')),mode='r|').extractall('.')"   # no zstd binary in the image
elan toolchain link leanprover/lean4:v4.36.0 $PWD/lean-4.36.0-linux
```


**A note on lemma names, earned three times.** Every Lean failure in this project so far has been **name drift, not wrong mathematics**: `List.mem_cons_self`'s explicit-vs-implicit arguments, `div_le_div_iff` gone from Mathlib, and, on moving `E5Core.lean` from core 4.15 to 4.36, four core lemmas renamed or re-signed at once (`Nat.pos_pow_of_pos` removed, `Nat.gcd_mul_dvd_mul_gcd` removed, `Nat.dvd_sub` lost its `≤` argument, and the `Nat.Coprime` API that replaces them absent from 4.15). The fix in each case was to reprove the step from lemmas whose name and signature are the same in both toolchains (`Nat.gcd_mul_left`, `Nat.dvd_gcd`, `Nat.mul_sub_left_distrib`, `Nat.pow_pos`). The working rule: **where a goal is routine, reach for a tactic or a decomposition into old, stable lemmas rather than for a named iff-lemma or a convenience lemma**. Known 4.36 deprecations met so far: `if_pos`/`if_neg` (use `simp only [h, ite_true]` or `↓reduceIte`) and `Set.mem_setOf_eq` (use `Set.mem_ofPred_eq`).

**What compiling immediately paid for.** The draft of the central inequality's block case split the region at `r ≥ 13`; the slack chain fails there — `r² − 7r − 84 < 0` at 13 — and the compiler refused it, forcing the split to 14 with the finite side `n ≤ 65` discharged by `decide`. The region's true numerical worst (`350·m*/pairs n = 1.0096`, at `n = 65, r = 13`) sits **on the finite side**, which is precisely why no uniform slack argument covers it and the `decide` is not decoration. One compile session caught exactly the class of error this project exists to catch, in its own draft.

## The plan (drawn up 2026-10; status as of 2026-11-25)

**Status (2026-11-26).** The 2026-10 order of work below is kept as a record; its steps stand as follows.
- Step 1, Theorem E.5: done (`E5Assembly.lean`), and so is `ladder-completeness.md` Proposition 1 (`Prop1Final.lean`).
- Step 2, the definitions and `HypKSSOliver`: done in a different form from the sketch below. `Chain.OliverChain` is the Oliver group, and `Evasive.lean` has `orbitals`, `chiFix` (the fixed complex's χ) and `HypKSSOliver`. Evasiveness itself is an abstract predicate `Ev` on down-closed properties, constrained only by `HypKSSOliver`. `GraphProperty` and a decision-tree `NonEvasive` are not defined, so the KSS step "non-evasive ⇒ collapsible" lives inside the hypothesis.
- Steps 3–4, the constructions as permutation groups: done for the two-part shapes (`PartE1.lean` for F = 1, `PartEF.lean` for F ≥ 2 with the entangled generator, c = p^a via `GaloisField`). The unfused family n = 2m of step 3 is not separately built.
- Step 5, the conditional theorem: done as `SigmaHalf.sigma0_mu` / `PartEAll.sigma0_realised` (floor) and `Threshold.thr_realised` (evasiveness beyond μ\*), under (AL) or (AA).
- Step 6, the BBKN replacement: not done (`ArkCore.fused_value` has its arithmetic half).

Work also went to group theory this plan had treated as out of reach: Lemma D2, Lemma B for prime blocks and Lemma B′ are now theorems from Oliver's chain (see the per-file sections below). The planning-level version is `claude-understanding-of-project-plan.md` §9.

### Next: `Note.lean` from the arithmetic to the whole conditional argument

**The target.** The note's Theorem is: (BCG_{1/5}-AL), plus Oliver's theorem in the form KSS use it, implies μ\*(n) ≥ δ₀·C(n,2) for all large n. `Note.lean` proves the arithmetic half — from a configuration's parameters to its density. What remains is everything between the literature and that: the graph-theoretic definitions, the constructions as actual permutation groups with their Oliver chains and pair-orbitals, and the assembly. **Assumed as a named hypothesis: the KSS–Oliver congruence. Not assumed: BBKN**, whose only contribution to the note is the Ω(n log n) bound, replaced by a three-line theorem.

**The assumed theorem is statable with no topology, and that is what makes this a bounded project rather than a research programme.** KSS + Oliver give, for every Oliver Γ ≤ S_n and every non-evasive nontrivial monotone P:

> χ(Δ_P^Γ) ≡ 1 (mod q), with equality χ = 1 when the top is trivial,

where Δ_P^Γ is the complex of Γ-invariant graphs lying in P. Its Euler characteristic is Σ over nonempty unions U of orbitals with U ∈ P of (−1)^(#orbitals in U − 1) — a `Finset` sum. So:

```lean
/-- The KSS–Oliver input, as one hypothesis.  A `structure`, never `axiom`:
    the project's claim that its files rest on Lean's three standard axioms
    must survive.  Stated for the trivial-top case `χ = 1` and the
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

**Order of work, by friction:**

1. **Theorem E.5 — done** (`E5Assembly.lean`, with E.6 in `E6.lean`). `ladder-completeness.md` Proposition 1 — done (`Prop1Final.lean`).
2. **The definitions above and `HypKSSOliver`.** No proofs yet; the point is that they typecheck against each other and against the theorem statement.
3. **The unconditional family** n = 2m, m a prime power — two blocks of 𝔽_m with the entangled generator, orbitals {m(m−1), m²}, Oliver with trivial top. Smallest group, no foreign block, the note's Theorem 2.2 analogue.
4. **The two-part construction** n = F·c + r, **with c prime first** (`ZMod p`, a field with no ceremony), the block group `AGL(1,c)` as a subgroup of `Equiv.Perm (ZMod p)`, the foreign block `ZMod r` with twist of order t, the chain, and the pair-orbitals. Then **c = p^a** via `GaloisField`, which costs more at every lemma.
5. **`theorem_conditional`**: `HypBCG → HypKSSOliver → ∀ n ≥ N, ∀ P, (∀ G ∈ P, |E(G)| < δ₀·C(n,2)) → Evasive P`.
6. **The BBKN replacement**: `μ*(n) ≥ n·(Q(n) − 1)/2` from `orb_full` and the fused construction at c = Q(n). Three lines; it is the note's §1 commentary made formal.

**What Mathlib is missing for step 4, and what to do about it.** Affine groups exist as `AffineGroup`-style structures but not as *permutation groups on the field*; the fused/entangled product and wreath-type products are absent; `IsMultiplyPretransitive` exists, k-*homogeneity* (transitivity on k-sets) does not. Each is a self-contained definition with a handful of lemmas, and each should be written **as a general Mathlib-style definition in its own file**, not inlined into the construction — that is what makes it a candidate contribution rather than project debris. **Keep a list of every definition wished for**, written against the proofs that needed it; the list is the output of the month for the Groupprops thread below.

**Operational rules.** Keep the pin and **do not bump mid-piece-of-work** — two of this project's three Lean failures were name drift, and the FLT run reports 26% of files changing on one bump. Route around Mathlib's ordering-and-division iff-lemmas as `Basic.lean` already does. **Lean follows the note, not the reverse**: names and statement order track the vetted human text, and a formalisation that wants to rename something files a note rather than doing it.

### The Groupprops / mathcheck thread — independent infrastructure, with ARK as a first application

This is **not** part of the ARK Lean plan and does not gate it. Vipul's mathcheck framework (LLM-written *deterministic* scripts for the tedious parts of verbal math checking — undeclared variables, unit consistency — so that LLM and human effort goes to what needs judgement) already has GAP components. The Lean extension would be **scripts that take a Groupprops page and extract what a Lean formalisation needs as input**, applicable across Groupprops generally, with the LLM doing the steps deterministic scripts cannot. The ARK constructions give a first set of pages to try — the affine group `AGL(1,q)`, 2-homogeneity, the Oliver class, wreath and entangled products — and Groupprops may need those pages written or extended first, which needs no subscription. The "definitions wished for" list from the note's Lean work is the handoff between the two threads. **Neither depends on the other; this may or may not happen.**

### 2027: the fuller document, and the ceiling stated now

**What is reachable in one to two months of Max**, and would be a complete honest artefact:

- E.5 — done (2026-11). Proposition 1 — done (2026-11).
- **Part E realisability in general**: μ\* ≥ B for the whole shape space. *Done for the two-part shapes Σ₀ and the threshold use* (`PartE1`, `PartEF`); several classes, several foreign blocks, F_top > 1 and q = 2 remain.
- **Phase 3**: `B n` as a computable function — configurations, the Part G.3 score, the max — with `native_decide` on individual rows. Not the whole CSV. *Not started.*
- **Part 0 stated as a named hypothesis** `HypShapeComplete`, so that `μ* = B` is a Lean theorem conditional on exactly one classification input. *Not started; today `E6.e6` takes μ ≤ B_safe as a bare hypothesis.*

**What is not reachable, and the plan must not be read as aiming at it.** Part 0's completeness rests on Huppert's classification of solvable 2-transitive groups, and that is not going into Lean by one person in two months — nor should the corpus be built as if it were. **"Everything except the classification is machine-checked" is a strong statement and is available. "Everything is machine-checked" is not.** The FLT run shows the second is a matter of effort rather than possibility — Oliver's theorem is a short 1975 paper, "weeks of agent time" on that evidence — but that run was eleven days of parallel agents on a bespoke platform, not a chat window, and its output was by its own assessment not readable as mathematics. For a document whose purpose is exposition, the checked *statement* is the artefact worth having, and that is what the hypothesis-parameterised form delivers.

### Theorem E.5 and Corollary E.6 — done

Theorem E.5 (`enumeration-proof.md` Part E‴) caps the SAFE score of every fallback configuration below `C(n,2)/25`; Corollary E.6 then gives `μ*(n) = B(n)` wherever `B(n) > C(n,2)/25`, which is what covers every `n ≤ 10⁶`. Both are formalised; the details follow.

### E.5: the A9 items and the SAFE model

**Status.** `E5Core.lean` proves E.5's counting and congruence steps with zero sorries (see its header). Added 2026-11-24, for `pending-checks.md` A9:

- `ArkCore.orb_self_pairing` — on a block of odd size c, `orb c d false = c·d/2 ↔ d even` for `1 ≤ d ≤ c − 1`. **c odd is needed**: at even c and d = c − 1 the cap `pairs c` equals `c·d/2` with d odd.
- `ArkCore.fused_value`, `ArkCore.fused_value_orb` — for `Q ∣ n`, `(n/Q)·pairs Q = (n/Q)·orb Q (Q−1) b = n(Q−1)/2`: the arithmetic half of `μ*(n) ≥ n·(Q(n) − 1)/2`. That the fused construction is an Oliver group with this as its least orbital is group theory and is not claimed.
- `Bridge.lean` — `ArkBridge.isPrimeN_iff_prime : E5Core.IsPrimeN p ↔ Nat.Prime p`, which is Mathlib's `Nat.prime_def` reversed. This is route 1 of the reconciliation below, now done: Mathlib-side code can feed `Nat.Prime` hypotheses to `E5Core`'s lemmas.

**Reconciling `E5Core` with Mathlib.** `E5Core`/`ArkCore` define their own versions of standard notions so that they compile without Mathlib:

| `E5Core` / `ArkCore` | Mathlib equivalent |
|---|---|
| `IsPrimeN p` (`2 ≤ p ∧ ∀ d, d ∣ p → d = 1 ∨ d = p`) | `Nat.Prime p` — bridged in `Bridge.lean` |
| `prime_pow_dvd_coprime`, `dvd_of_dvd_mul_coprime`, `dvd_sub_le`, `gcd_pow_eq_one`, `gcd_two_pow_pm`, `gcd_succ` | `Nat.Coprime` API (one-liners there) |
| `isPrimeN_of_bounded`, `isPrimeN_three`, `isPrimeN_13` | `Nat.Prime` by `norm_num` / `decide` |
| `pairs n` (`ArkCore`) | `n.choose 2`, bridged in `Note.lean` |

Route 1 (import and bridge) is in place. Route 2, a Mathlib-native rewrite of `E5Core`, is no longer blocked (the separate core-4.15 build has been dropped) but nothing requires it. Meanwhile: stay inside the namespaces, prefix any helper whose bare name could exist in Mathlib, and add any new home-made notion to the table in the same edit.

**The SAFE model — decided 2026-11-24: Option B, exceptions row by row** (Vipul: "whatever most faithfully matches the text"). `E5Assembly.lean` defines configurations and SAFE from Part G.3/G.3a and *proves* the inequalities E.5's proof consumes, rather than taking them as fields:

- **Model.** `Part` (`pc F c` a p-characteristic class, `fr r t` a foreign block), `Fallback` (class (F, c), foreign (r, t), leftover list), `Fallback.safe` = min over G.3's orbital types: intra (flat F·C(c,2) for a p-class, per B_safe; `orb r t false` for a foreign block), smallest within-part cross ((F or F/2)·c², F ≥ 2), and every between-parts sᵢsⱼ. `Admissible W p a q` carries the text's hypotheses: c = p^a, r prime ≠ p with r ∣ c − 1, leftover parts p-power classes or foreign primes, every foreign twist dividing r − 1 and a power of **one** prime q (Lemma B′ — group theory, an explicit hypothesis exactly as the text cites it), and **foreign primes distinct** (the second-reading fix).
- **Proved from the definition.** `safe_le_pairs_r` (SAFE ≤ C(r,2)), `safe_le_pairs_part` (every part has C(size,2) ≥ SAFE — the text's ℓ(B)), `safe_le_orb`.
- **Branches.** `e5_s_ge4`; `e5_s2a1`, the whole s = 2, a = 1 branch for any non-bare W, all four sub-cases. In the one-foreign-leftover sub-case the ratio window and the cofactor bounds (r−1)/t ≤ 3, (r′−1)/t′ ≤ 7 are now **derived from SAFE** (`cofactor_r`, `cofactor_r'`), where `E5Core.odd_q_leftover` took them as hypotheses; q = 2 is closed too (r ∈ {3, 5} via Mathlib's `Nat.pow_of_pow_add_prime` and `E5Core`'s divisibilities). The two-or-more-parts sub-case uses the exact count n ≥ c + r + 2ℓ (`two_part_leftover`) rather than the text's θ-estimate — same conclusion, simpler route.
- **Exceptions.** `exceptions`: one configuration per table row, leftover composed as `fallback_sup.py` composes it, with n, SAFE (= the table's 1, 3, 3, 3, 21, 21, 18, 21, 21, 10, 39, 155) and 25·SAFE ≥ C(n,2) checked by `decide`. `ex28_admissible` checks `Admissible` on the row where every clause is non-vacuous.
- **The other branches (added the same day).** `e5_s1` (E.1's classification: p odd forces (3, 2); p = 2 forces r = 2^a − 1 Mersenne with a prime, via Mathlib's `Nat.prime_of_pow_sub_one_prime`; a ≥ 7 is `e1_mersenne`), `e5_s3` (E.4: r = 2, or 2^{2b} − 1 = 3r forces b = 2, i.e. (16, 5)), `e5_s2a2` (E.3(i): (p−1)/2 divides r, so p = 3; a even is impossible mod 8; a = 3 is (27, 13); a ≥ 5 is `e3_repunit`).
- **`e5`, the assembly.** For `Admissible W p a q` and `¬ W.Bare`: `25 * W.safe < pairs W.n ∨ (W.c, W.r) ∈ excPairs`, the six pairs (3,2), (4,3), (8,7), (16,5), (27,13), (32,31). Inputs not proved in Lean: Lemma B′ (one q for all twists) and distinct foreign primes, both as hypotheses in `Admissible`, as in the text.
- **The exceptional n, pinned (`e5_exceptions`).** If 25·SAFE ≥ C(n,2) then n is one of the table's twelve values. Route: for each of the six pairs, SAFE ≤ orb(r, t), with t a prime power dividing r − 1, bounds n (≤ 88; ≤ 62 except at (32, 31)). A leftover part must hold B, which forces 5·size ≥ n + 3 (`n_add3_le`). So three leftover parts never fit, and two fit only at (8, 7). What remains is a finite list, enumerated by `chk` and checked by `decide +kernel` (about 30 s). The enumeration is a superset of the admissible parts: it drops "one q" when t = 1 and does not require the leftover's foreign primes to be distinct. `glue` and `mem_cands` prove that every admissible configuration appears in it. So E.5's exception statement, "exactly these twelve n", is now a theorem; it no longer rests on `fallback_sup.py`.
- **Text finding.** The table lists one configuration per n. At n = 23 and 31, (F, c, r) = (2, 8, 7) and (3, 8, 7) with no leftover are also exceptions with the same SAFE (`exceptions_more`). So "exactly 12 exceptions" counts values of n; the F column shows one representative.

**Corollary E.6 (`E6.lean`, 2026-11-24).**
- **The model.** A `Config` is a list of parts:
  - classes `pc F c d`, with c = p^b and *any* d ∣ c − 1;
  - foreign blocks `fr r t`, with t a power of one q;
  - **Lemma D2 parts** `fo F r t`: F ≥ 2 outside blocks of one prime, fused or simply repeated, scored by D2's two classes. Those are F·C(r,2), and for F < r the same-position class, C(F,2)·r or F·r at r = q (D2q); the model takes the larger.

  This is Theorem 3.1's shape list with F any integer, *including* the D2 shapes the enumerator leaves out. `safe` values a class at F·C(c,2); `refined` values it at F·orb(c, d). A fallback configuration is, as in E.5, a class with a foreign prime r ∣ c − 1. No hypothesis about how twists are reduced is needed (see "Reconciliation" below).
- **Pieces.**
  - `refined_eq_safe` (fallback-free); `refined_le_safe` (everywhere).
  - `safe_eq_view` / `view_admissible`: a fallback configuration *is* an E.5 `Fallback` with the same SAFE. This needs SAFE to be permutation-invariant (`crossTerms_perm`).
  - `reread_*`: E.3(ii)'s (r, r) re-reading.
  - `Config.full`: raise every twist to full.
  - `exc_beaten`: at the twelve exceptional n, a one-class configuration beats every fallback.
  - **`d2_case`: D2's domination, proved in the model.** A SAFE optimum above the line that contains a D2 part is matched by a fallback-free configuration. Above the line, a D2 part has F, r ≤ 25 and n < 614 (`d2_small`, by counting). In that region, a kernel-checked table (`d2check`, about a minute) gives at each of 256 values of n a one- or two-part fallback-free witness that scores at least D2's bound. The witnesses' admissibility is checked by `admB`, which is proved to imply `GAdm`.
- **Results.**
  - `e6_core`: a SAFE optimum above 1/25 is matched by an admissible fallback-free configuration with REFINED = SAFE.
  - **`e6_maxima`**: `IsBsafe n B` with C(n,2) < 25·B implies `IsBrefined n B`. This is E.6's B_refined = B_safe, stated on the two maxima.
  - `e6`: μ = B as well, given Part E (every REFINED score ≤ μ) and Part 0 (μ ≤ B_safe) as hypotheses.
  - Non-vacuity: `isBsafe_primePow` / `isBrefined_primePow` give B_safe(p^b) = B_refined(p^b) = C(p^b, 2).
- **Reconciliation with Parts 0 and D.**
  - **Twists.** A first version assumed "a twist below c − 1 needs a foreign r ∣ c − 1" (Lemma C's coupling). That assumption is gone: SAFE ignores twists, so a configuration with no fallback has the same SAFE as its full-twist version (`Config.full`), which is fallback-free. The model therefore allows any d ∣ c − 1, exactly as Theorem 3.1 does, and Lemma C is not used anywhere. That matches the text's claim that B_safe and E.6's proof are independent of Lemma C.
  - **F.** F is any integer. That is the permissive reading of F = F_mid·F_top that the certificates use. Since Theorem 3.1 imposes no coprimality on F_mid, it is at least as large as the true shape space.
  - **Fused foreign classes and repeated foreign primes** are now in the model as `fo` parts. Their domination above the line is a theorem here (`d2_case`), where the text relies on Corollary D2′ plus the computed table below n = 471. That supports the enumerator's choice to omit them, at least for the E.6 question.
- **Not formalised.** Part 0's completeness (μ ≤ B_safe), and Part E beyond the two-part shapes (built in `PartE1`/`PartEF`). (Lemma D2, the source of the `fo` terms, is now a theorem; `FoBridge.fo_terms_valid` connects the two.)

**Lemma D2 (`D2.lean`, 2026-11-24).** This file works on actual permutation groups: G ≤ Sym(Fin F × ZMod r), the image Γ|_O. Orbitals are G-orbits on unordered pairs (`orbit2`), and the generic fact is that an orbit inside a G-invariant set is no larger than the set (`orbit2_card_le`).
- **Branch (a), `d2a`.** If G preserves the block system, some orbital has at most F·C(r,2) pairs. This is unconditional, as in the text.
- **Step 3, `d2b`.** If every element acts as (i, x) ↦ (σi, a·x + s), the same-position pairs are invariant, so some orbital has at most C(F,2)·r pairs.
- **D2q step (7), `d2q`.** If every linear part is trivial, so (i, x) ↦ (σi, x + sᵢ), the pairs with within-block difference ±1 are invariant, giving an orbital of at most F·r pairs.
- **Step 1's order arguments.** `step1_sigma`: an element of r-power order in Sym(F) with F < r is trivial. `step1_mult`: an r-power multiplier is trivial.
- **Step 2's first claim, `step2_mult_equal`.** If conjugation keeps the diagonal translation diagonal, all the multipliers are equal.
- **Link to `E6`.** These bounds are exactly `E6`'s `fo` terms (`fo_terms_match`).
- **Steps 1–2, supplied by later files.** The normal-form hypothesis of `d2b` and `d2q` is discharged by `Chain`, `Step2`, `Glue`, `Rescale`, `LemmaB`, `D2Full` and `D2q`, described below.

**Oliver's chain and D2's Step 1 (`Chain.lean`, 2026-11-24).**
- **The chain.** `OliverChain H p q` is Γ₂ ⊴ Γ₁ ⊴ H with Γ₂ a p-group, Γ₁/Γ₂ cyclic and H/Γ₁ a q-group. `OliverChain.map` carries it to any surjective image, in particular Γ|_O.
- **`rsub_cyclic`: every r-subgroup is cyclic when r ∉ {p, q}.** An r-subgroup lies in Γ₁, because its image in the q-group is trivial (`rsub_le_N₁`). It meets the p-group Γ₂ trivially (`rsub_inf_N₂`). So it embeds in the cyclic layer. This is the fact D2's Step 1 attributes to the chain.
- **`step1_translations` / `step1_Gamma`.** For Γ with a chain acting on O = Fin F × ZMod r, the translations in Γ|_O form an r-group, hence a cyclic one, so they are the multiples k·v of a single vector. That is the text's "T\* ≅ C_r generated by one vector".
- **`step1_full_support`, `step1_diagonal`.** If every block sees a nonzero translation, v has full support, and per-block rescaling sends v to the diagonal.
- **`step1_full`: Step 1 complete, given affine block actions (Lemma B, proved for prime blocks in `LemmaB.lean`).** Assume every element acts affinely, (i, x) ↦ (σi, aᵢx + tᵢ) with aᵢ ≠ 0, and Γ|_O is transitive on O. Then:
  - F·r divides |Γ|_O|, so by Cauchy there is an element of order r;
  - it is a pure translation (`rElem_is_translation`: σ = 1 by `D2.step1_sigma`, aᵢ = 1 by `D2.step1_mult`);
  - conjugating it to each block (`conj_translation`) shows the generator has every component nonzero.

  So T\* is the diagonal C_r after rescaling, which is the text's Step 1 in full.
- **`not_rsq_dvd`: Sylow-r of Γ|_O is T\*.** r² doesn't divide |Γ|_O|, so |Γ|_O/T\*| is prime to r.
- **`Step2.origin_change`: Step 2's second claim, the H¹ = 0 computation.** Take any finite group Q with |Q| invertible in K, a multiplier a : Q → K, a block action σ, and translation parts t forming a cocycle modulo constants. Then the origins o := −|Q|⁻¹ Σ_h a_h⁻¹ t_h make every element's translation part the same on all blocks. Multiplicativity of σ is not even needed.
- **`step2_common_mult`: Step 2's first claim, for the group.** Every element's multipliers satisfy aᵢvᵢ = λ·v_{σi}, so they are all equal once v is rescaled to 𝟙.
- **Completing D2 for r ∉ {p, q}:**
  - **Lemma B** (block actions are affine): proved for prime blocks in `LemmaB.lean`, below.
  - **The rescaling: done.** `Rescale.lean` conjugates Γ|_O by the per-block rescaling ψ(i, x) = (i, vᵢx). In the new coordinates every element has one multiplier and T\* is diagonal (`conj_affine`, `conj_translation_scale`). [Γ|_O : T\*] is prime to r, because |T\*| is divisible by r and r² ∤ |Γ|_O|. Orbital sizes are preserved under conjugation (`orbit2_conj`). **`d2_full`** then assembles Step 1 → Step 2 → Step 3: Γ|_O with an Oliver chain, 2 ≤ F < r, r ∉ {p, q}, Lemma B's affine form and transitivity on O together give an orbital of at most C(F,2)·r pairs. With `D2.d2a`, that is Lemma D2's statement for r ∉ {p, q}.
  - **The bridge to `D2.lean`'s normal form:** `Glue.lean` assembles Step 1, Step 2 and the affine form into "every element is (σi, a·x + s)".

**Lemma B for prime blocks, and D2 without hypotheses (`LemmaB.lean`, `D2Full.lean`, 2026-11-25).** The text proves Lemma B from "a solvable primitive group is affine", a classical theorem not in Mathlib. For outside blocks of prime size r, which are all that D2 needs, an elementary route is now fully formalised.
- **`LemmaB.lemmaB_block`.** Take a transitive group H on ZMod r with an Oliver chain, r ∉ {p, q}. Then:
  - the bottom layer acts trivially (`normal_pgroup_trivial`), so the middle layer is cyclic;
  - Cauchy gives z of order r, which lies in the middle layer (`rsub_le_N₁`), so every h conjugates z to a power of z (`conj_mem_zpowers`);
  - z is an r-cycle (Mathlib's `isCycle_of_prime_order''`), and labelling points by k ↦ zᵏ(0) turns it into x ↦ x + 1;
  - so every relabelled h is affine (`affine_of_normalizes`).
- **`D2Full.d2_noB`.** This transports `lemmaB_block` from block 0 to every block:
  - restrict the chain to the block stabiliser (`OliverChain.comap`) and push it to the block (`ρ`);
  - relabel block j through a transversal gⱼ, Ψ(j, x) = gⱼ(0, E x);
  - check every element is then affine block-to-block;
  - conjugate by Ψ and apply `Rescale.d2_full`.

  **Result.** Take G preserving a block system of F blocks of prime size r, transitive, with an Oliver chain, 2 ≤ F < r and r ∉ {p, q}. Then some orbital has at most C(F,2)·r pairs. **No Lemma B hypothesis**, and no circularity: Step 1 is applied only after Lemma B has been derived.
- **D2q (`D2q.lean`).**
  - **Lemma B for q-blocks.** `LemmaB.lemmaB_block_any` handles a block of size q. If the middle layer acts trivially, H is a q-group of degree q, so H = ⟨z⟩.
  - **The core, `d2q_fixed`.** There is a full-support v with aᵢ(g)·vᵢ = v_{σi} for every g.
    - First, a v fixed by the middle layer. If N₁ contains a nonzero translation, its commutator with any n ∈ N₁ is a q-element in [N₁, N₁] ⊆ Γ₂ (step 5). Otherwise the commutator is a translation inside N₁, so trivial (step 6).
    - Then every g fixes v: g^(qᵏ) ∈ N₁, g^(F!(q−1)) is a translation (`pow_is_translation`), and the two exponents are coprime.
  - **`d2q_affine` / `d2q_noB`.** Rescaling by v makes every multiplier 1, and `D2.d2q` gives the F·q orbital.
- **`D2q.lemmaD2`: Lemma D2 assembled.** F·C(r,2) always; C(F,2)·r when F < r and r ≠ q; F·r when F < r and r = q. All from the chain, a preserved block system and transitivity.

**Closing two loops (`FoBridge.lean`, `D1.lean`, 2026-11-25).**
- **`FoBridge.fo_terms_valid`.** Every SAFE term `E6.lean` assigns to a fused/repeated outside part (F·C(r,2), and max(C(F,2)·r, F·r) when F < r) is at least the size of some orbital of every group of that shape. So the E.6 model's D2 scores are theorems from the chain, block system and transitivity, not numbers copied from the text.
- **`D1.lemmaD1`.** In the E.6 model, F = pᵏ copies of a p-block of size c read as one part of size F·c. That reading stays admissible, keeps n, and does not lower SAFE. This is the domination the text uses to drop bottom-layer block copies.

**Lemma B′ (`LemmaBprime.lean`, 2026-11-25).**
- **`step0`.** If V is minimal normal and C_G(V) ≤ V, every nontrivial normal subgroup contains V. This is the text's Step 0, and it uses both hypotheses, as the text's "two dependencies" note says.
- **`lemmaBprime` (abstract).** Take G with an Oliver chain (p, q) and V a nontrivial normal abelian p₀-subgroup, p₀ ≠ p, minimal normal, with C_G(V) ≤ V. Then:
  - V is cyclic;
  - G/V is a q-group;
  - if the middle layer is trivial, then p₀ = q.

  Both of the text's cases appear. In **Case 1** the middle layer contains V, is cyclic and abelian, so it equals V. In **Case 2** G is a q-group, and a central subgroup of order q is normal, so by Step 0 it contains V.
- **`lemmaBprime_affine` (concrete).** O = 𝔽_{p₀}^a, G ≤ Sym(O) containing all translations, every element affine, linear parts irreducible. The abstract hypotheses are derived: C_G(V) = V from affineness, and minimality from irreducibility. The conclusions are **a = 1**, and every element has a qᵏ-th power that is a translation, so the twist is a q-group.
- **`lemmaBprime_primitive`: B′ with no affine-form input.** Take G ≤ Sym(X) primitive, with an Oliver chain (p, q), |X| ≥ 2 and p ∤ |X| (an outside block). Then |X| is prime, and there is a normal V of order |X| such that every element's qᵏ-th power lies in V, so the twist is a q-group. If the middle layer is trivial, |X| = q. The proof:
  - a nontrivial abelian normal subgroup of a primitive group is regular (`card_eq_of_abelian_normal`);
  - Γ₂ would be transitive, forcing |X| to be a p-power, so Γ₂ = 1 and Γ₁ is cyclic;
  - if Γ₁ ≠ 1 it is regular, and so is its subgroup of elements of prime order p₀, which has order p₀;
  - if Γ₁ = 1, G is a q-group, and a central subgroup of order q is regular.

  So **Lemma B′ is proved outright** from the chain and primitivity. The classical "solvable primitive ⇒ affine" theorem, which the text cites and Mathlib lacks, is not needed for B′. (The affine-coordinates form of Lemma B is still unformalised for general primitive blocks, though it isn't needed for B′; for prime blocks it is `LemmaB.lemmaB_block_any`.)

**Proposition 1's counting clauses (`Prop1.lean`, 2026-11-25).** `ladder-completeness.md` Proposition 1 says a SAFE optimum above C(n,2)/25 has fusion count F ≤ 16 for a class beside other parts, because cap_F(1) = 1/(1 + √F)² < 1/25 for F ≥ 17.
- **`cap16`.** Exactly in ℕ: for F ≥ 16, 25·min(F·C(c,2), C(s,2)) ≤ C(F·c + s, 2). Split on s ≤ 4c (then 25·C(s,2) ≤ C(5s,2)) or s > 4c (then (F + 4)² − 25F = (F − 1)(F − 16) ≥ 0).
- **`fusion_cap`.** In the `E6` model: a class `pc F c d` beside any other part (any order) with 25·SAFE > C(n,2) has **F ≤ 15**. Every part has a SAFE term at most C(size, 2) (`exists_term_le`).
- **Finding.** The text's F ≤ 16 is true but one loose: cap_16(1) = 1/25 exactly, so F = 16 also fails the strict inequality. The ladder's menu (F ≤ 16) is one wider than needed, which is harmless.
- **`part_share`, `parts_le_four`.** Above the line every part has n + 3 ≤ 5·size, so at most four parts (Proposition F.1 in the model).
- **`foreign_efficient`.** A foreign part `fr r t` with 2r < n has 2(r − 1) < 25t: the text's k ≤ 12 for r − 1 = k·t, from orb(r, t) ≤ r·t alone.
- **`merge_classes`: no S12.** Classes `pc F₁ (m·c)` and `pc F₂ c` merge into `pc (F₁·m + F₂) c` with the same n and SAFE no lower. The within-class cross term of the merged class is at least F₂·C(c,2) (`within_ge`), which is the text's "never binds".
- **`three_foreign`: the reduction for three foreign primes.** Three foreign parts r₁ ≤ r₂ ≤ r₃ above the line have 9r₁ < 50t₁ + 3, 2r₂ < 25t₂ + 1 and r₃ < 18t₃; with rⱼ − 1 = kⱼtⱼ, k₁ ≤ 5, k₂ ≤ 12, k₃ ≤ 17. The shares are ≤ 1/3, ≤ 1/2 and < 3/5, the last because the other two parts each have share > 1/5.
- **`ThreeForeign.no_three_foreign`: three foreign primes excluded outright.** For every q and every exponent, not only the text's enumerated range.
  - Normalise by the least twist T = q^m: rⱼ = aⱼT + 1, tⱼ = bⱼT with bⱼ = q^(eⱼ) ∣ aⱼ, one bⱼ = 1.
  - The part with bⱼ = 1 bounds A = Σaⱼ ≤ 31, so the patterns are finite.
  - In every pattern some part has a bound whose leading coefficient is ≤ A² and linear coefficient ≤ 5A, so it fails at *every* T. A kernel check (one `decide` per q ≤ 31, one for q ≥ 32) confirms this; about two minutes.
  - Inputs used: orb ≤ c·r·t/2 (halving when q = 2 and t ≥ 2), orb ≤ C(r,2), share > 1/5, and the parity of a prime rⱼ = aⱼT + 1. The text's continuous worst case, 1/27 at q = 2, is consistent.
- **`Prop1Final.prop1`: Proposition 1 assembled.** Every admissible configuration with no D2 part above the line is matched (same n, SAFE no lower, admissible) by one with at most one class and at most two foreign parts, and F ≤ 15 when the class has company. Classes are merged repeatedly (`merge_all`, larger block first); a third foreign part is excluded after sorting the primes (`fr_le_two`). The remaining clauses (shares, foreign efficiency, fallback-freeness via `E6.e6_core`) apply to the matched configuration as separate theorems; D2 parts are handled by `E6.d2_case`.
- **`TwoForeign`: Proposition 2.** `s6_ceiling` (two foreign primes: 9·SAFE ≤ C(n,2)) and `s11_ceiling` (a class and two foreign primes: 16·SAFE ≤ C(n,2)), for every q and exponent.
  - The key lemma `two_foreign`: for r₁ < r₂ and R = r₁ + r₂, one part has 18·orb ≤ R(R − 1). Same normalisation and per-q kernel check as `ThreeForeign` (A < 18).
  - One family passes the coefficient test, q = 2 with r₁ = 2T + 1, r₂ = 3T + 1; primality kills it (T = 2 is {5, 7}, numerically fine; T = 2^m ≥ 4 makes one divisible by 3 or 5).
  - S11 reduces to the same lemma: a class above 1/16 has 3s > R, so 9n(n − 1) ≥ 16R(R − 1).
  - **Finding.** The text's exceptions {3, 5} and {5, 7} are not needed in the model: they exceed 1/9 only in the continuous ceilings. And "S6 has n even" fails at the edges {2, 3} and {2, 5} (n = 5, 7, SAFE = 1), which is harmless.
- **Not formalised from `ladder-completeness.md`:** Proposition 3 (conditional on (BCG-AL), not a target).

**(BCG) as a specification and a quantifier (`BCG.lean`, 2026-11-25).** Mirrors `arithmetic-of-density.md` §3.5.3's "specification and quantifier" paragraph.
- **Shape.** A specification is a witness predicate `W : ℕ → Prop` (clauses 1–4 at one n). The quantifier is a filter: `atTop` for (AL), `almostAll` for (AA), whose sets are those with exceptional set ≤ C·x/(log x)^A + C up to x, for every A. `Hyp W L := ∀ᶠ n in L, W n`.
- **Proved.** `almostAll` is a filter; `atTop_le_almostAll` (AL ⇒ AA, for every W); `almostAll_neBot` (AA is not vacuous); `Hyp.lift` / `Hyp.lift_large` (a pointwise result lifts to any quantifier below `atTop`).
- **The note as an instance.** `noteWitness` is `Note.HypBCG`'s clause (`note_hyp_iff`). `note_pointwise` is the arithmetic half at one n; `note_arithmetic_half` lifts it, giving `Note.theorem_arithmetic_half` under (AL) and its (AA) counterpart from one proof.
- **Σ₀ and the window lemma (`Sigma.lean`).**
  - `F0`, `d0`: Σ₀'s table. `bhsw_agrees`: the (BH-SW) per-class (k, d) of `bcp-to-floor.md` is the same table (`decide`).
  - `xstar`, `balance`: for any (F, η), both binding terms equal `capF F η` at the balance point.
  - `target`, `window`, `target_le_cap`, `target_at_balance`: the window lemma for any (F, η, window).
  - `window_of_eps`: the window x₋ = x\*√(1 − ε), 1 − F·x₊ = (1 − F·x\*)√(1 − ε) has target exactly (1 − ε)·cap, so clause 2's two readings correspond for every (F, η).
  - `pointwise`: the exact single-n bound on the two binding terms, (target − κ/n)·n(n − 1).
  - `cap_table`: §3.3.5's cap column is `capF (F0 a) (2 / d0 a)` at all twelve classes.
- **The assembly (`SigmaHalf.lean`).**
  - `ClassSpec` (F, d, window), its `Witness` (n = F·p^b + r in the window, r = dq + 1, q odd prime, r ≠ p, r ∤ p^b − 1) and regularity `Good` (including the one cross-term side condition 2F·x₋·y₋ ≥ target).
  - `pointwise_half`: for any regular specification, a witness at n gives an admissible `E6` configuration with 2·SAFE ≥ (target − κ/n)·n(n − 1). Inputs: `orb_dq` (orb(r, q) = (2/d)·C(r,2)), `within_ge` (the within-class cross term never binds), `Sigma.pointwise`.
  - `specEps_good`: every (F ≥ 1, d ≥ 2) at the ε-window is regular, side condition included.
  - `sigma0_half`: under `Hyp (W0 ε) L`, L = `atTop` or `almostAll`, L-eventually 2·SAFE ≥ ((1 − ε)·δ₀(n mod 12) − κ/n)·n(n − 1). One proof for both quantifiers; Σ₀ enters only through `spec0`.
  - `sigma0_mu`: with Part E as the single named hypothesis `PartE μ` (every admissible configuration's REFINED score is ≤ μ\*(n), as `E6.e6` takes it), L-eventually 2·μ\*(n) ≥ ((1 − ε)·δ₀(n mod 12) − κ/n)·n(n − 1). This is the conditional floor statement, in both quantifier strengths, from one proof.
- **Part E for F = 1 (`PartE1.lean`).** The group is K's affine group alongside z ↦ u·z + v on ℤ/r, u in the order-q subgroup of (ℤ/r)ˣ.
  - Oliver chain: translations of K (p-group, characteristic p) ◁ trivial ℤ/r-multiplier (layer ≅ Kˣ × ℤ/r, cyclic by CRT since r ∤ c − 1) ◁ G (q-group on top).
  - Orbitals: C(c,2) inside K (2-homogeneity), c·r mixed, ≥ q·r inside ℤ/r (−1 ∉ U as q is odd). So every orbital is ≥ SAFE.
  - `sigma0_F1_realised`: at n ≡ 0, 2, 4, 6, 8, 10 (mod 12), under (AL) or (AA), the floor holds with Part E **proved**: an Oliver group on n points all of whose pair-orbitals are ≥ m with 2m ≥ ((1 − ε)·δ₀ − κ/n)·n(n − 1).
- **Part E for F ≥ 2 (`PartEF.lean`).** F blocks of 𝔽_c with the entangled generator zc: (i, x) ↦ (i + 1, x), wrapping with ×ω, so zc^F is the full twist on every block.
  - Group ⟨translations, γ = zc ⊕ (z ↦ z + 1), μ(U)⟩; chain T ◁ ⟨T, γ⟩ ◁ G, with the layer cyclic because it is generated by γ over T, and the top a q-group because every element is μ_u modulo N₁. Coherence r ∤ F(c − 1) is used once: to put ρ_v (z ↦ z + v) into N₁, which makes N₁ normal.
  - Orbitals: F·C(c,2) within blocks; ≥ K0·c² across blocks (K0 = F odd, F/2 even — the rotation orbit of a block pair); F·c·r block–ℤ/r; ≥ q·r inside ℤ/r. Exactly the SAFE terms.
  - `PartEAll.sigma0_realised`: **Σ₀'s floor at every residue class with Part E proved**, under (AL) or (AA): the conditional floor now rests only on the quantified witness hypothesis (and on Oliver/KSS for what μ\* means downstream).
- **Threshold beyond μ\* (`CycGood`, `Evasive`, `RGlue`, `Threshold`).** Same parameter-change pattern as Σ₀: the threshold class specification is `specEps F 2 ε` (η = 1), F = 1 at even n and F = 2 at odd n, so the targets are (1 − ε)·capF F 1 = (1 − ε)/4 and (1 − ε)(3 − 2√2) (`capT_even`, `capT_odd`). Same groups as Part E (`thr_1` on `PartE1.G`, `thr_F` on `PartEF.G`), with r = 2kq + 1 and the ℤ/r block now **credited at full capacity C(r,2)** instead of ≥ q·r: its k pair-orbit types are glued by a good C_k (`CycGood`), and evasiveness follows from `HypKSSOliver`, a named hypothesis (Mathlib has no evasiveness, KSS or Oliver). k by class: 1 at n ≡ 0, 1, 4, 6, 9, 10; 2 at 3, 7; 3 at 2, 5, 8; 6 at 11 (mod 12); q > 7 prime throughout. The witness hypothesis `WT` is quantified as in `BCG.Hyp`.
- **The covering statement (`Cover.lean`), §6's ⇒ direction.** `Floor δ n` (some admissible configuration at n has SAFE ≥ δ·C(n,2)) holding L-eventually gives `ShapeD δ Fmax n` L-eventually. `ShapeD` lists the S2 and lone-prime escapes, n = F·c + r (F ≤ Fmax), n = r₁ + r₂ only if δ ≤ 1/9, and n = F·c + r₁ + r₂ only if δ ≤ 1/16. The F-bounds come from `fbound`, the fusion ceiling as an inequality √δ·(n − 1)(1 + √F) ≤ n; the two-foreign ceilings come from `TwoForeign`; D2 parts appear only below n = 614.
  - **Not included:** the hypothesis is on B_safe, so μ\* ≤ B_safe (Part 0) is still needed to read it as a statement about μ\*; the escapes are kept as disjuncts; local obstructions (§6.3(c)) are not applied; at the boundary, `fexact` shows a perfect-square F = s² never reaches 1/(1 + s)² at finite n, so δ₀ = 1/16 and 1/9 are covered for the F-bounds; δ₀ = 1/25 is not (Proposition 1 is strict), and S6 at 1/9 and S11 at 1/16 are excluded by the strict ceilings `s6_ceiling_lt` and `s11_ceiling_lt`.
  - **On dropping the escapes (`CoverDensity.lean`):** the S2 escape has F ≤ 25 (the class's own ceiling, proved in `shape_of_small`), so the escapes are the primes and at most 25 multiples of prime powers. `esc_count` counts them: O(x/log x). So `cover_foreign` drops them with O(x/log x) exceptions. That is the true rate, since the primes alone are ≍ x/log x; it is not (AA)'s O(x/(log x)^A).
- **Scope of Part E here:** the two-part shapes Σ₀ uses (one class, one foreign block, odd q). General shapes (several classes, several foreign blocks, F_top > 1, q = 2) are not formalised; `E6`'s `PartE` hypothesis still stands for those.

**The Lean scoring model against the Python scorers (`../scripts/lean_score_crosscheck.py`, 2026-11-25).** The theorems here are about `E6.Config`'s SAFE and REFINED, so a drift between those definitions and the scripts that produced the table would make them true of the wrong thing. The script compares the **full sorted term lists**, not the minima (a mis-scored term that does not bind would hide behind the minimum), of random configurations: Lean against `mu_enumerate_v3.value` in SAFE and refined mode, and `validate_table_v3.score` against `mu_enumerate_v3`.
- **Result:** 8,000 configurations (p ∈ {2,…,13}, q ∈ {2, 3, 5, 7}, F up to 7 both parities, c up to p³, r < 120, Lemma C changing a term in 2,750), 0 mismatches; 20,000 for the validator, 0 mismatches.
- **Control:** a mutant `orb` without the 2 | t halving is caught (121 of 500, 273 of 2,000).
- **Not covered:** `mu_ladder_exact.py`'s inline scoring (cross-checked against the exact table in `pending-checks.md` R0), D2 parts, and `Note.lean`'s note-specific values.

> **To check in future iterations: Mathlib coverage.** As of the pinned Mathlib (v4.36.0, checked 2026-11-25), Mathlib has primitive and quasiprimitive actions, Jordan's theorems, Schur–Zassenhaus and solvable groups. It has no minimal-normal-subgroup or socle theory, no O'Nan–Scott, and no "a solvable primitive group is affine". Several results here are hand-proved because of that gap: `card_eq_of_abelian_normal`, `LemmaB.lemmaB_block_any`, the Step 0 and Lemma B′ arguments, and `LemmaB.mem_zpowers_of_orderOf_eq`. **When Mathlib is next bumped, check whether ready-made versions now exist.** Candidates:
> - socle / minimal normal subgroups;
> - "solvable primitive ⇒ affine";
> - normalisers of regular cyclic subgroups in Sym(p);
> - uniqueness of subgroups of a given order in a cyclic group.
>
> Swapping one in would mean a toolchain and Mathlib version bump, a re-pin of `lean-toolchain` and the lakefile `rev`, a fresh `lake exe cache get`, and fixing the name drift such bumps bring (see the lemma-name lesson above). So it is not to be done lightly. But it would shorten the proofs and move trust onto Mathlib's reviewed library.

### Open, as of 2026-11-26 (the one list; per-section "not formalised" notes defer to it)

- **Part 0: μ\* ≤ B_safe.** The bridge from an arbitrary Oliver group to an admissible `E6.Config` whose SAFE is at least the group's least orbital. In Lean today it is a bare hypothesis (`E6.e6`'s `hcap`; `Cover`/`CoverDensity` state their hypotheses on B_safe for this reason). Already available for it: `Chain.OliverChain`, Lemma B for prime blocks, Lemma B′, Lemma D1, Lemma D2 with `FoBridge`, and `Upper.lean`'s orbit/orbital/N\* machinery. Missing: the orbit decomposition into classes / foreign blocks / D2 parts (Part A), the flat cap F·C(c,2) and the cross terms as bounds on real orbitals, coherence (Parts C–D) giving `GAdm`, and Lemma B for prime-power blocks, which needs "solvable primitive ⇒ affine" (Huppert) and is planned as a named hypothesis.
- **Part E beyond two-part shapes** (several classes or foreign blocks, F_top > 1, q = 2).
- **The derivation of the chain from Oliver's theorem, KSS, and the analytic inputs** ((BH-SW)/(BCG) themselves; the circle-method reduction of `bcp-to-floor.md`). Out of scope; they enter as named hypotheses (`HypKSSOliver`, `WT`, `Hyp W L`).
- **The upper side's named hypotheses** (`Upper.lean`): `HypStep2`, `HypStep2Block`, `HypStep5` (§6.3 Steps 2 and 5).
- **Smaller:** δ₀ = 1/25 itself in the covering statement; the BBKN replacement (step 6); phase 3.

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

*Added after the note was drafted for arXiv. **Status: the ℕ half is done** — `ArkCore.lean` proves `central_even`/`central_odd` (the construction inequality, multiplied through by 350), `mStarOdd_le_even`, the full admissible-`d` table block, and the degeneration example, leaving to Mathlib only the `Density`/`ℝ` wrappers, the `ZMod` chinese-remainder step, and the singular-series material.*

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

**Phase 2 — the balance-point optimisations. Largely done (2026-11-25):** `Sigma.lean`'s `xstar`/`balance`/`window_of_eps` give the balance point and window for any (F, η), and `cap_table` is the mod-12 table as instances. Earlier note: the two-foreign closed form `1/(√m₁+√m₂)²` named below as its cleanest target is already proved in `Basic.lean`, and `capF_of_sqrt` is likely the lever for the rest, since a balance point is again a surd supplied once rather than computed repeatedly. Each family's ceiling is `max_x min(...)` of a few polynomials in `x`. These are real-analysis lemmas: routine in principle, fiddly in practice, and the payoff is that the mod-12 ceiling table becomes a checked computation rather than a table. A second payoff worth naming: the window identity `F · width = 1 − √λ` falls out of the same lemmas, and it is exact — the maximum is a *kink*, where an increasing branch meets a decreasing one, not a smooth turning point, which is why the cost of approaching the cap is `Θ(ε)` and not `Θ(√ε)`. The two-foreign closed form `1/(√m₁+√m₂)²` is the cleanest target here since it collapses an infinite family to one identity. Worth doing after phase 1, and only if phase 1 goes smoothly.

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

**What was left after phase 1 was phases 2 and 3, and neither is owed.** Phase 2 has since been largely done (`Sigma.lean`); phase 3 would make `B n` a Lean-checkable function, and the README's own judgement — *this is where I would stop* — still stands, since `validate_table_v3.py` already covers the rows.

## A caveat about what this does *not* buy

A formalised arithmetic layer says nothing about whether the arithmetic is *about the right thing*. The most consequential errors found in review — the S5/S7 fusion-layer conflation, and then the `F_mid` coprimality clause — were correct pieces of arithmetic attached to the wrong group-theoretic object. Lean would have checked the arithmetic and said nothing. Formalisation raises the floor on one class of error and leaves the more interesting class untouched, which is worth knowing before spending weeks on it.

**And there is a sharper version of the caveat, which the `F_mid` episode made concrete.** That clause was asserted in the prose, implemented in the enumerator's cap, re-derived by the validator from witnesses the cap had chosen, and relied on by both certificates. Four artefacts, one source — so no cross-comparison between artefacts could fire, and the defect was additionally invisible to every check that validates the *winner*, since it under-scored a shape that lost. A Lean development of the arithmetic layer would have been a **fifth artefact downstream of the same clause**, and equally silent.

The thing that did catch it was building the group from first principles and comparing against the scored value. That is a different move from formalising, and it is cheaper. **Where a claim is the common ancestor of all the artefacts, the check has to be an independent construction, not another derived statement** — worth knowing before treating formalisation as the general remedy.

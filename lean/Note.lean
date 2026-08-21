/-
# `Note.lean` — the arithmetic core of `mu-theta-n2-note.md`

**Status.** Compiles against Mathlib on the laptop.  The ℕ-valued core is no
longer proved here: it is **imported from `ArkCore.lean`**, which compiles in
both environments with zero sorries.  What remains in this file is the ℝ-valued
and Mathlib-valued half — `Density`, the `ZMod` chain step, the singular-series
material — plus the assembly.

*Why the split, and why it is not merely bookkeeping.* `ArkCore` is Mathlib-free,
so it compiles where Mathlib cannot be fetched, and its statements are checked
by a second toolchain.  Re-proving them here would create a second artefact
downstream of the same claims — the failure mode the README's caveat names — so
this file **imports rather than restates**.  The bridge is one lemma,
`pairs_eq_choose`, and it is the only place the two spellings of the binomial
meet.

**All ten `sorry`s are now discharged** — six by import from `ArkCore`, four by
Mathlib proofs written here.  The two halves have different levels of assurance
and it is worth knowing which is which before trusting a green checker:

* **Imported (certain).** `blockValue_lower`, `mStarOdd_le_even`, `central_even`,
  `central_odd`, and the whole `dList` / `admissible` `decide` block are `exact`
  applications of theorems already compiled with zero sorries in two
  environments.  If these break it is the bridge that broke, not the content.
* **Written here (checked numerically, not yet by a second toolchain).**
  `pairs_eq_choose`, `delta0_le_density`, `coprime_iff_not_dvd`,
  `unconditional_density`, `half_is_ceiling`, and the assembly.  These are the
  Mathlib-name-dependent parts, and Mathlib names are exactly what has already
  bitten this project once (`List.mem_cons_self`'s explicit-versus-implicit
  arguments).  Expect the failures, if any, to be name or signature drift rather
  than false statements: every one was numerically verified over a wide range
  before being written.

## What this file does and does not do

The note's Theorem is conditional on two things this file cannot reach:

* **Oliver's fixed-point theorem**, which is not in Mathlib and whose
  formalisation is a research project in its own right.  It appears here as
  `OliverAnnihilation`, a hypothesis.
* **Hypothesis (BCG_{1/5}-AL)** — bounded-cofactor Goldbach with the note's
  fixed `n/5` window, for all large `n` — which is a Goldbach-type existence
  statement and is conjectural.  It appears as `HypBCG`.

  The framework's own hypothesis is `(BCG-AL)`, keyed to each residue class's
  ceiling with a shrinkable window; the two are **not nested in either
  direction**, so this file formalises the note's and nothing stronger.  At
  `n ≡ 11 (mod 12)` the framework's optimum is the `F = 4` shape with
  `c/n ≈ 0.134`, which the `n/5` window here rejects outright; and this
  hypothesis is far weaker in constant.  See `note-to-framework-bridge.md` §4.

What is formalised is **the gap between them** — the arithmetic that takes the
output of the hypothesis to the conclusion `δ ≥ 1/350`.  That is the whole of §3 of the
note, and it is where every error the note has actually had has lived: a units
mismatch between two displayed bounds, a min-of-polynomials evaluated at an
interior point rather than at the boundary corner where its minimum sits, and an
asymptotic class written `O(n²)` when the content was a fixed fraction.

**The unit is the point.** Densities in the note are relative to `n.choose 2`,
never `n^2`; the two differ by a factor 2 and nothing numerical separates them.
Here `Density` is a definition, so the unit is fixed by construction and a
statement in the wrong one will not typecheck against a statement in the right
one.  If this file buys one thing, it is that.

## Layout

1. The invariant, and the annihilation hypothesis
2. `orb`, and the block-value arithmetic
3. The two constructions' minimum orbitals
4. **The central inequality** — `min(...) ≥ (n.choose 2)/350`
5. The Oliver chain: cyclicity of the middle layer
6. The local analysis: `d = 2e` with `e ∣ 6`, and the admissible-`d` table
7. The unconditional family at density → 1/2
8. Assembly: the Theorem, modulo the two hypotheses
-/

-- `import Mathlib` pulls everything: slower to elaborate, but no unknown-module
-- errors while the file is a sketch.  Narrow these once the proofs compile.
import Mathlib
-- The Mathlib-free ℕ core.  **This import resolves through `LEAN_PATH` / lake's
-- build dirs, never through the filesystem next to this file** -- putting
-- `ArkCore.lean` in the same folder is NOT enough, since Lean imports the
-- compiled `.olean`.  Two ways to satisfy it:
--   (a) one-off:  lake env lean -o ArkCore.olean ArkCore.lean
--                 LEAN_PATH=$PWD:$LEAN_PATH lake env lean Note.lean
--       (use `lake env` for both, so the .olean is built by the toolchain that
--        will load it -- a 4.15-built olean will not load into 4.33)
--   (b) in-project: move the files under the lake library's source dir and
--       change this line to `import Ark.ArkCore` (matching the lakefile's
--       `lean_lib` name).  This is what `leancheck.sh` assumes.
import ArkCore

namespace Note

open Nat

/-! ## 1. The invariant, and the annihilation hypothesis -/

/-- The density of an orbital of size `m` in a graph on `n` vertices.  **This is
the unit the note fixes**: everything is relative to `n.choose 2`, never `n^2`.
Making it a definition is what prevents the two from being confused. -/
noncomputable def Density (n m : ℕ) : ℝ := (m : ℝ) / (n.choose 2 : ℝ)

/-- The note's `δ₀`. -/
noncomputable def delta0 : ℝ := 1 / 350

/-- **Proposition 1, as a hypothesis.**  If every graph in a nontrivial monotone
property `P` has fewer than `m` edges and some Oliver group of degree `n` has all
u-orbitals of size at least `m`, then `P` is evasive.

This is Oliver's fixed-point theorem plus the orbital-annihilation argument.  It
is *not* proved here and is not provable with current Mathlib; it is stated so
that everything downstream is honest about what it rests on. -/
structure OliverAnnihilation where
  /-- `Evasive n P` and `HasOliverGroupWithMinOrbital n m` are the two predicates
  this file cannot define; they are carried abstractly so that the implication
  has content.  **The previous version of this structure ended in `→ True`**,
  which made the whole hypothesis vacuously satisfiable — anything at all could
  discharge it, so a downstream theorem taking `OliverAnnihilation` as input was
  proving nothing.  A placeholder that typechecks is not the same as a hypothesis
  that constrains, and this is the failure mode to watch for when stating the
  unreachable parts. -/
  Evasive : ℕ → Prop
  HasOliverGroupWithMinOrbital : ℕ → ℕ → Prop
  SparseNontrivialMonotone : ℕ → ℕ → Prop
  evasive_of_orbital_bound :
    ∀ n m : ℕ, HasOliverGroupWithMinOrbital n m →
      SparseNontrivialMonotone n m → Evasive n

/-! ## 2. `orb`, and the block-value arithmetic

A block of prime size `r` carrying a twist of order `t` splits its pairs into
orbitals of size `r*t/2` when `t` is even and `r*t` when `t` is odd, capped at
`r.choose 2`.  The note only ever uses the *lower* bound `r*t/2`, which holds in
both parities, so that is what is formalised. -/

/-- **The bridge.**  `ArkCore` has no `Nat.choose` (it is not in core Lean), so
its binomial is `pairs n = n*(n-1)/2`.  This is the single place the two
spellings meet; everything below states its results in Mathlib's `choose` and
proves them by rewriting through here. -/
theorem pairs_eq_choose (n : ℕ) : ArkCore.pairs n = n.choose 2 := by
  rw [Nat.choose_two_right]; rfl

/-- The conservative block value the note uses: `r*t/2` regardless of parity.
Definitionally `ArkCore.blockValue`, so its lemmas apply directly. -/
abbrev blockValue (r t : ℕ) : ℕ := ArkCore.blockValue r t

/-- `t ≥ (r-1)/12` is what condition 3 guarantees, since `d ≤ 12`.  In the
integer form that avoids division: `12 * t ≥ r - 1`. -/
abbrev EfficiencyBound (r t : ℕ) : Prop := ArkCore.EfficiencyBound r t

/-- The efficiency bound in the form used in the estimate.  **Imported.** -/
theorem blockValue_lower (r t : ℕ) (h : EfficiencyBound r t) :
    r * (r - 1) ≤ 12 * (2 * blockValue r t + 1) :=
  ArkCore.blockValue_lower r t h

/-! ## 3. The two constructions' minimum orbitals

Even `n = c + r`: orbitals are `c.choose 2` (within `A`), the `B`-orbitals, and
`c*r` (across).  Odd `n = 2c + r`: additionally `c^2` between the two `A`-blocks.
These are read off the constructions in §3 of the note; the group-theoretic
content is in *why* these are the orbitals, which is not formalised here. -/

/-- The minimum orbital of the even construction.  Definitionally
`ArkCore.mStarEven`, whose `pairs c` is `c.choose 2` by `pairs_eq_choose`. -/
abbrev mStarEven (c r t : ℕ) : ℕ := ArkCore.mStarEven c r t

/-- The minimum orbital of the odd construction.  The extra term is `c^2`. -/
abbrev mStarOdd (c r t : ℕ) : ℕ := ArkCore.mStarOdd c r t

/-- The `choose`-spelled form of the definition, for reading against the note. -/
theorem mStarEven_eq (c r t : ℕ) :
    mStarEven c r t = min (min (c.choose 2) (blockValue r t)) (c * r) := by
  rw [← pairs_eq_choose]; rfl

theorem mStarOdd_eq (c r t : ℕ) :
    mStarOdd c r t = min (min (min (c.choose 2) (c * c)) (blockValue r t)) (c * r) := by
  rw [← pairs_eq_choose]; rfl

/-- The odd construction's minimum is at most the even one's.  **Imported.** -/
theorem mStarOdd_le_even (c r t : ℕ) : mStarOdd c r t ≤ mStarEven c r t :=
  ArkCore.mStarOdd_le_even c r t

/-! ## 4. The central inequality

**This is the note's actual content**, and the place its errors have lived.

Condition 2 of (H) says `c ≥ n/5` and `r ≥ n/5`; condition 3 gives
`EfficiencyBound r t`.  The claim is that the minimum orbital is then at least
`(n.choose 2)/350`.

Two things worth flagging in the statement itself.

* **The bound is `n.choose 2 / 350`, not `n^2 / 700`.**  These are not equal —
  the second is *larger*, so asserting it is a strictly stronger claim than the
  derivation supports.  The two versions of the note once carried one of each,
  three lines apart.  Here `Density` fixes the unit.
* **The worst case is at a corner of the region, not at the balance point.**
  Minimising `2·min(x²/2, y²/24, xy)` over `x + y = 1`, `x, y ≥ 1/5` gives
  `1/300` at `y = 1/5`, the corner where the foreign block is smallest.  The
  interior balanced point gives `1/48`, which is *not* the minimum; reading it as
  one is the error to avoid.  So `1/350 < 1/300` is the margin, and it is real.

*Numerically checked:* over `10 ≤ n < 900` and every admissible `(c, r, t)` there
is no violation, and the worst ratio `350 * mStar / n.choose 2` is `1.0096`, at
`n = 65`.  The margin is thin at small `n` because `n.choose 2` is `n(n-1)/2`
rather than `n²/2`; asymptotically the ratio tends to `350/300 = 1.1667`. -/

/-- The region condition 2 cuts out, in integer form. -/
abbrev RegionEven (n c r : ℕ) : Prop := ArkCore.RegionEven n c r

/-- Likewise for odd `n = 2c + r`. -/
abbrev RegionOdd (n c r : ℕ) : Prop := ArkCore.RegionOdd n c r

/-- **The even bound.**  Stated multiplied through by `350` to stay in `ℕ`. -/
theorem central_even (n c r t : ℕ) (hn : 10 ≤ n)
    (hreg : RegionEven n c r) (heff : EfficiencyBound r t) :
    n.choose 2 ≤ 350 * mStarEven c r t := by
  rw [← pairs_eq_choose]
  exact ArkCore.central_even n c r t hn hreg heff

/-- **The odd bound.**  The extra `c^2` term does not bind: `c ≥ n/5` gives
`c^2 ≥ n²/25`, weaker than the `c.choose 2` case only by a constant. -/
theorem central_odd (n c r t : ℕ) (hn : 10 ≤ n)
    (hreg : RegionOdd n c r) (heff : EfficiencyBound r t) :
    n.choose 2 ≤ 350 * mStarOdd c r t := by
  rw [← pairs_eq_choose]
  exact ArkCore.central_odd n c r t hn hreg heff

/-- **The cast step, isolated.**  This is the *only* real-number content in
§4: everything else is `ArkCore`'s ℕ inequality.  Factoring it out means the
cast-and-divide manipulation is written once rather than twice, and it is what
carries the unit — `Density` is relative to `n.choose 2`, so a hypothesis in
`n^2` could not be fed to it. -/
theorem delta0_le_density {n m : ℕ} (h2 : 2 ≤ n) (h : n.choose 2 ≤ 350 * m) :
    delta0 ≤ Density n m := by
  unfold delta0 Density
  have hpos : (0 : ℝ) < (n.choose 2 : ℝ) := by
    have : 0 < n.choose 2 := Nat.choose_pos h2
    exact_mod_cast this
  have hne : ((n.choose 2 : ℕ) : ℝ) ≠ 0 := ne_of_gt hpos
  have hcast : ((n.choose 2 : ℕ) : ℝ) ≤ 350 * (m : ℝ) := by
    have : ((n.choose 2 : ℕ) : ℝ) ≤ ((350 * m : ℕ) : ℝ) := by exact_mod_cast h
    push_cast at this; linarith
  -- Difference-is-nonneg, rather than a `div_le_div` iff-lemma: the iff-lemmas
  -- in this corner of Mathlib have been renamed more than once (this proof
  -- previously used `div_le_div_iff`, which 4.33's Mathlib no longer has),
  -- whereas `div_nonneg`, `field_simp` and `linarith` have been stable for
  -- years.  Same pattern in `half_is_ceiling`.  (`field_simp` closes the
  -- rearrangement outright here; a trailing `ring` is a no-op and the unused-
  -- tactic linter says so.)
  have hid : (m : ℝ) / (n.choose 2 : ℝ) - 1 / 350
      = (350 * (m : ℝ) - (n.choose 2 : ℝ)) / (350 * (n.choose 2 : ℝ)) := by
    field_simp
  have hnn : 0 ≤ (350 * (m : ℝ) - (n.choose 2 : ℝ)) / (350 * (n.choose 2 : ℝ)) :=
    div_nonneg (by linarith) (by positivity)
  linarith

/-- The two bounds in the note's own unit.  **This is the statement whose type
records the unit**, and the one that a claim in `n^2` would fail to match. -/
theorem density_even (n c r t : ℕ) (hn : 10 ≤ n) (h2 : 2 ≤ n)
    (hreg : RegionEven n c r) (heff : EfficiencyBound r t) :
    delta0 ≤ Density n (mStarEven c r t) :=
  delta0_le_density h2 (central_even n c r t hn hreg heff)

/-- The odd bound in the note's unit.  **This was referenced by the assembly
theorem below and never declared** — the sketch called `density_even /
density_odd` in a comment while only the even half existed.  A missing companion
lemma is invisible in prose and immediate here. -/
theorem density_odd (n c r t : ℕ) (hn : 10 ≤ n) (h2 : 2 ≤ n)
    (hreg : RegionOdd n c r) (heff : EfficiencyBound r t) :
    delta0 ≤ Density n (mStarOdd c r t) :=
  delta0_le_density h2 (central_odd n c r t hn hreg heff)

/-- The margin is genuine, not an artefact of rounding: the true worst case over
the region is `1/300`, and `1/350 < 1/300`. -/
theorem delta0_lt_true_worst : delta0 < 1 / 300 := by
  unfold delta0; norm_num

/-! ## 5. The Oliver chain: cyclicity of the middle layer

The chain needs `Γ₁/Γ₂ ≅ C_(c-1) × C_r` to be cyclic, which happens exactly when
`gcd(c-1, r) = 1`.  Condition 4 of (H) says `r ∤ c - 1`; since `r` is prime the
two are equivalent, and that equivalence is the whole content of condition 4. -/

/-- **Condition 4 is exactly coprimality**, for prime `r`. -/
theorem coprime_iff_not_dvd (c r : ℕ) (hr : r.Prime) :
    Nat.Coprime (c - 1) r ↔ ¬ (r ∣ (c - 1)) := by
  rw [Nat.coprime_comm]
  exact hr.coprime_iff_not_dvd

/-- The product of cyclic groups of coprime orders is cyclic.

**Stated with content rather than as `True`.**  `ZMod n` is the cyclic group of
order `n`, so the chain's requirement is the ring equivalence below; a lemma
whose conclusion is `True` records the intent and proves nothing, which is worth
avoiding even in a sketch. -/
noncomputable def middle_cyclic (c r : ℕ) (h : Nat.Coprime (c - 1) r) :
    ZMod ((c - 1) * r) ≃+* ZMod (c - 1) × ZMod r :=
  ZMod.chineseRemainder h

/-! ## 6. The local analysis

Condition 3 permits `d ∈ {2, 4, 6, 12}`, and the note derives that list as
`d = 2e` with `e ∣ 6`: the leading `2` makes `r = dq+1` odd, the `2` in `e` fixes
`n mod 4` (needed only at odd `n`, where the third form is `(n-dq-1)/2` — the
change of variable that makes `ℓ = 2` bite twice), and the `3` in `e` fixes
`n mod 3`.

The admissible-`d` table is a finite check and should be `decide`-able. -/

/-- The permitted values of `d`.  Definitionally `ArkCore.dList`, so the
`decide`-checked facts below are imported rather than re-decided — a second
`decide` on the same table would be a second artefact downstream of one claim,
which is exactly what the split is for. -/
abbrev dList : List ℕ := ArkCore.dList

/-- `d = 2e` with `e ∣ 6` — the note's derivation of the list. -/
theorem dList_eq : dList = (([1, 2, 3, 6] : List ℕ).map (2 * ·)) :=
  ArkCore.dList_eq

/-- Every permitted `d` has all its prime factors in `{2, 3}`, which is what
confines the local analysis to `ℓ ≤ 3` and makes the table mod 12.

**The obvious encoding does not typecheck**, and the reason is worth recording
because it is the first thing a `decide` proof gets wrong.  Writing

  `∀ d ∈ dList, ∀ p : ℕ, p.Prime → p ∣ d → p = 2 ∨ p = 3`

quantifies over *all* naturals, so there is no `Decidable` instance and `decide`
reports `failed to synthesize`.  The claim is true; the statement is simply not
a finite check as written.  Bounding `p` by `d` costs nothing — a prime divisor
of a positive `d` is at most `d` — and makes the quantifier a bounded one, for
which Mathlib supplies `Nat.decidableBallLE`. -/
theorem dList_smooth : ∀ d ∈ dList, ∀ p ≤ d, p.Prime → p ∣ d → p = 2 ∨ p = 3 := by
  -- `ArkCore` states this with `isPrimeB` (core Lean has no `Nat.Prime`);
  -- with Mathlib present the two agree, and `decide` closes the table directly.
  decide

/-- The same content in the form least likely to strain `decide`: divisibility
is decidable with no primality instance involved at all.  `d ∣ 12` says exactly
that `d` is `{2,3}`-smooth with the multiplicities the table uses.

Keep this one even if the version above compiles: if a future Mathlib changes
the default `Nat.Prime` decidability instance — which has happened before, and
is the usual reason a working `decide` on primality stops working — this
survives, and `dList_smooth` can be re-derived from it. -/
theorem dList_dvd_twelve : ∀ d ∈ dList, d ∣ 12 := ArkCore.dList_dvd_twelve

/-- The admissible `d` at each residue class mod 12, as the note tabulates it. -/
abbrev admissible : ℕ → List ℕ := ArkCore.admissible

/-- **Every class admits at least one `d`**, which is what makes (H) locally
soluble at every `n`.  A finite check.

*Empirically confirmed:* searching `30 ≤ n < 6000` for actual `(q, r, c)` with
`q > 3` reproduces this table exactly, class by class.  The restriction `q > 3`
matters — at `q = 3` the local obstruction argument does not apply and sporadic
solutions exist in classes the table calls obstructed. -/
theorem admissible_nonempty : ∀ a < 12, (admissible a) ≠ [] :=
  ArkCore.admissible_nonempty

/-- **`d = 12` is needed, and needed only at `n ≡ 11`.**  This is why the list
must run to 12 rather than stopping at 6. -/
theorem twelve_needed_only_at_eleven :
    (∀ a < 12, admissible a = [12] ↔ a = 11) :=
  ArkCore.twelve_needed_only_at_eleven

/-- Each tabulated `d` really is in the permitted list. -/
theorem admissible_subset : ∀ a < 12, ∀ d ∈ admissible a, d ∈ dList :=
  ArkCore.admissible_subset

/-! ### The obstruction itself

`ω(ℓ)` is the number of residues `q mod ℓ` at which the product of the three
forms vanishes; an obstruction is `ω(ℓ) = ℓ`.  Formalising the general statement
needs the forms as polynomials; what is cheap and worth having is the *specific*
degeneration the note singles out. -/

/-- **The degeneration at `ℓ ∣ d`.**  When `ℓ ∣ d`, the form `dq + 1` is never
`0 mod ℓ`, but the third form degenerates to a constant, and that constant
vanishes identically when `ℓ ∣ n - 1`.  Worked at the note's example
`d = 6, n = 100, ℓ = 3`: `99 - 6q ≡ 0 (mod 3)` for every `q`. -/
theorem degeneration_example : ∀ q : ZMod 3, (99 : ZMod 3) - 6 * q = 0 := by
  decide

/-! ## 7. The unconditional family

For `n = 2m` with `m` an odd prime power, the two-block construction with a block
swap has orbitals `m*(m-1)` and `m^2`, so `δ(n) = 1/2 - o(1)`.  This needs no
hypothesis.  Only the arithmetic is here; the group is not constructed. -/

/-- The density of the unconditional family, exactly. -/
theorem unconditional_density (m : ℕ) (hm : 2 ≤ m) :
    Density (2 * m) (m * (m - 1)) = ((m : ℝ) - 1) / (2 * (m : ℝ) - 1) := by
  unfold Density
  have hchoose : (2 * m).choose 2 = m * (2 * m - 1) := by
    rw [Nat.choose_two_right]
    have h : 2 * m * (2 * m - 1) = 2 * (m * (2 * m - 1)) := by ring
    omega
  rw [hchoose]
  have hm1 : ((m * (m - 1) : ℕ) : ℝ) = (m : ℝ) * ((m : ℝ) - 1) := by
    push_cast [Nat.cast_sub (by omega : 1 ≤ m)]; ring
  have hm2 : ((m * (2 * m - 1) : ℕ) : ℝ) = (m : ℝ) * (2 * (m : ℝ) - 1) := by
    push_cast [Nat.cast_sub (by omega : 1 ≤ 2 * m)]; ring
  rw [hm1, hm2]
  have hmpos : (m : ℝ) ≠ 0 := by
    have : (0 : ℝ) < (m : ℝ) := by exact_mod_cast (by omega : 0 < m)
    linarith
  field_simp

/-- It tends to `1/2`, and `1/2` is the ceiling: for non-prime-power `n` an
Oliver group has at least two u-orbitals partitioning the pairs, so the minimum
is at most half.  (The two-orbital fact is group theory and is not proved here;
the arithmetic consequence is.) -/
theorem half_is_ceiling (n m : ℕ) (hn : 2 ≤ n) (h : 2 * m ≤ n.choose 2) :
    Density n m ≤ 1 / 2 := by
  unfold Density
  have hpos : (0 : ℝ) < (n.choose 2 : ℝ) := by
    have : 0 < n.choose 2 := Nat.choose_pos hn
    exact_mod_cast this
  have hne : ((n.choose 2 : ℕ) : ℝ) ≠ 0 := ne_of_gt hpos
  have hcast : 2 * (m : ℝ) ≤ ((n.choose 2 : ℕ) : ℝ) := by
    have : ((2 * m : ℕ) : ℝ) ≤ ((n.choose 2 : ℕ) : ℝ) := by exact_mod_cast h
    push_cast at this; linarith
  have hid : (1 : ℝ) / 2 - (m : ℝ) / (n.choose 2 : ℝ)
      = ((n.choose 2 : ℝ) - 2 * (m : ℝ)) / (2 * (n.choose 2 : ℝ)) := by
    field_simp
  have hnn : 0 ≤ ((n.choose 2 : ℝ) - 2 * (m : ℝ)) / (2 * (n.choose 2 : ℝ)) :=
    div_nonneg (by linarith) (by positivity)
  linarith

/-! ## 8. Assembly

The Theorem, with both unreachable inputs explicit. -/

/-- **Hypothesis (BCG_{1/5}-AL)**, as a hypothesis: bounded-cofactor Goldbach
at the note's fixed `n/5` window, for all large `n`.  Every sufficiently large
`n` admits `q, r, c` with the shape, region, efficiency and coprimality
conditions.

The subscript is load-bearing.  `RegionEven`/`RegionOdd` below encode the
window as `c, r ≥ n/5`, which is the note's; the framework's `(BCG-AL)` uses a
window that shrinks to each class's balance point, and at `n ≡ 11 (mod 12)`
that point sits at `c/n ≈ 0.134`, outside this one.  So neither hypothesis
implies the other and this structure must not be read as the framework's. -/
structure HypBCG where
  N : ℕ
  /-- `c` is a **prime power**, not a prime: the matching block is `𝔽_c` and the
  note's own constructions use `c = p^a`.  Writing `c.Prime` here would state a
  strictly stronger hypothesis than (H) supplies, which is the wrong direction —
  a stronger hypothesis makes the downstream theorem weaker and the error is
  silent.  `IsPrimePow` is Mathlib's spelling. -/
  witness : ∀ n ≥ N, ∃ q r c t : ℕ,
    q.Prime ∧ r.Prime ∧ IsPrimePow c ∧
    (RegionEven n c r ∨ RegionOdd n c r) ∧
    EfficiencyBound r t ∧
    Nat.Coprime (c - 1) r

/-- **The Theorem's arithmetic half.**  Granting (H), every sufficiently large
`n` carries a configuration of density at least `δ₀`.

Note what this does *not* say: it does not say `μ(n) ≥ δ₀ · n.choose 2`, because
that needs the configuration to come from an actual Oliver group — the content of
§3 of the note that lives in group theory.  What is proved here is that *if* the
construction is an Oliver group with the stated orbitals, *then* the density
bound follows.  Separating the two is the point of the exercise. -/
theorem theorem_arithmetic_half (H : HypBCG) :
    ∀ n ≥ max H.N 10, ∃ c r t : ℕ,
      ((RegionEven n c r ∧ delta0 ≤ Density n (mStarEven c r t)) ∨
       (RegionOdd n c r ∧ delta0 ≤ Density n (mStarOdd c r t))) := by
  intro n hn
  have hN : n ≥ H.N := le_trans (le_max_left _ _) hn
  have h10 : 10 ≤ n := le_trans (le_max_right _ _) hn
  have h2 : 2 ≤ n := by omega
  obtain ⟨q, r, c, t, _hq, _hr, _hc, hshape, heff, _hcop⟩ := H.witness n hN
  refine ⟨c, r, t, ?_⟩
  rcases hshape with hev | hod
  · exact Or.inl ⟨hev, density_even n c r t h10 h2 hev heff⟩
  · exact Or.inr ⟨hod, density_odd n c r t h10 h2 hod heff⟩

end Note

/-
  Ark/Basic.lean — a first formalisation pass at the ARK framework's ARITHMETIC layer.

  WHAT THIS IS AND IS NOT.  This file now COMPILES against Mathlib.  It began as
  a sketch whose header said none of it had been compiled and that every proof
  should be read as a claim about what a proof might look like; that is no
  longer true, and the count went 18 sorries -> 0 over one pass.  Where a proof
  was written without a toolchain to hand it carries an inline FALLBACK naming
  the likely failure and an alternative route -- those comments are the residue
  of that process and are worth keeping, since the lemma names most likely to
  rot are exactly the ones they name.

  WHAT FORMALISING ACTUALLY BOUGHT, which was not the proofs.  Three signature
  corrections, all in statements whose proofs are routine:
    * `orb_full`'s `2 <= c` is unnecessary (both sides are 0 at c <= 1);
    * `capF_eq_k_sqrt`'s `0 <= eta` is unnecessary (`Real.sqrt_mul` needs only
      the LEFT factor nonneg, and `(F : R) >= 0` for any `F : N`);
    * `prop_F1` was FALSE without `0 < k` -- at `k = 0` the sum over `Fin 0` is
      0, so `n = 0`, the capacity hypothesis is vacuous, and the conclusion
      reads `0 < 0`.
  The last is the same defect this file already recorded at `size_of_capacity`,
  which needed `0 < m` for the same reason.  Two instances in one file is a
  pattern: *whenever a claim is "k things each with property P force a bound",
  check k = 0 before anything else.*  A prover cannot skip the degenerate
  branch the way a reader does, and that -- not the proofs -- is the case for
  this layer.

  WHY THIS LAYER.  The framework splits cleanly in two.  The GROUP-THEORETIC
  layer rests on Oliver's fixed-point theorem and on the classification of
  primitive solvable groups (Huppert), neither of which is in Mathlib; forma-
  lising it means formalising those first, which is a multi-year project and not
  what we want.  The ARITHMETIC layer -- the inequalities, the cap algebra, the
  counting bounds, the quadratic-residue step -- depends on none of that and is
  ordinary Mathlib material.

  And that layer is where our actual errors have been.  In one review pass we
  found: an off-by-one hazard between the two threshold ladders of Parts E'/F
  (the s-ladder s <= 1/sqrt(d) - 1 and the k-ladder k <= 1/sqrt(d) are offset
  by one, and reading them as coinciding shifts a threshold in either
  direction -- the sharp facts are "delta > 1/25 forces s <= 3" and
  "delta > 1/25 forces k <= 4"); a coefficient rule keyed on the wrong
  variable (F's parity, not q's); and a mechanism claim about fusion layers
  that contradicted our own Theorem 2.1.  The first two are exactly what a
  proof assistant catches for free.  So the expected value here is not
  "certainty about the theorems" but "the class of mistake we keep making,
  made impossible".  (An earlier version of THIS header was itself a casualty
  of the ladder confusion: it accused the documents' sharp "s <= 3 at
  delta > 1/25" of being the error, which is backwards -- that statement is
  correct, and the header had silently substituted the k-ladder.)

  Sections:
    1.  orb and the cap on a block's intra-orbital
    2.  Lemma D1: fusing costs more than it gains
    3.  Proposition F.1: the part count is bounded by the density
    4.  Part E' : the s-bound, and the threshold ladder that went wrong
    5.  The cap algebra: cap_F(eta) and the k = sqrt F identity
    6.  Why c = 3 mod 4 is the good case (Euler's criterion)
-/

/-
  IMPORTS.  `import Mathlib` pulls everything.  It is slower to elaborate (tens of
  seconds on first open, then cached) but it cannot produce an unknown-module
  error, which is the right trade while the file is still a sketch.  The narrow
  imports this file used to carry included `Mathlib.Combinatorics.Choose.Basic`,
  which does not exist -- binomial coefficients live in `Mathlib.Data.Nat.Choose`.
  Narrow them once the proofs compile, not before.
-/
import Mathlib
-- The Mathlib-free ℕ core, carrying the ladder theorems of §4 and the proved
-- versions of `orb_full`, `lemma_D1` and `size_of_capacity`.  Same convention as
-- `Note.lean`: **this resolves through `LEAN_PATH` / lake's build dirs, not
-- through the filesystem** -- an `ArkCore.lean` sitting beside this file is not
-- enough, since Lean loads the compiled `.olean`.  See `Note.lean`'s import
-- comment for the two ways to satisfy it; if you switch to the in-project
-- layout, both files change to `import Ark.ArkCore` together.
import ArkCore

namespace Ark

open Real Finset

/-! ## 0. The bridge to `ArkCore`

`ArkCore.lean` is Mathlib-free, so it works over `ArkCore.pairs n = n*(n-1)/2`
rather than `Nat.choose n 2`, which core Lean does not have.  One lemma connects
them, and every theorem `ArkCore` has already proved follows.

**Two stated hypotheses have turned out to be unnecessary and one was missing.**
`orb_full`'s `2 ≤ c` and `capF_eq_k_sqrt`'s `0 ≤ η` are not needed (both are
underscored in their signatures, which is how Lean records it); `prop_F1` was
*false* without `0 < k`.  That is three signature corrections from formalising
statements whose proofs are routine -- the argument for doing this layer is
less about the proofs than about being forced to state things exactly.

**PARTLY VERIFIED.**  Written in a container with core Lean but no Mathlib, so
the bridge and the rewrites through it were checked by you rather than here.
Everything they depend on in `ArkCore` *is* compiled and sorry-free.  Fallbacks
are noted inline where a step is more likely to need adjusting.

*One ordering trap, already paid for:* `orb_eq_arkcore` mentions `orb`, so it
must come after §1's definition, not here.  Putting it in this section gave
`Function expected at orb` -- and, because `autoImplicit` turns an unknown
identifier into an implicitly bound variable, the error names a *type* problem
rather than a missing definition.  Keep §0 to statements about `ArkCore` alone. -/

/-- `ArkCore.pairs` and `Nat.choose _ 2` are the same function. -/
theorem pairs_eq_choose (n : ℕ) : ArkCore.pairs n = n.choose 2 := by
  simp [ArkCore.pairs, Nat.choose_two_right]
  -- if this fails: `rw [Nat.choose_two_right]; rfl` -- `pairs` should be
  -- definitionally `n * (n - 1) / 2`, so `rfl` closes it after the rewrite.

/-! ## 1. The orbital-size primitive

`orb c t` is the minimum intra-orbital of a block of size `c` under a cyclic
twist of order `t`, capped at `c.choose 2`.  The cap is what makes a 2-block
worth 1 rather than 2, and the parity split is the `±T` collapse of section 6. -/

/-- Minimum intra-orbital of a `c`-block under a cyclic twist of order `t`.
`char2` records that the block's characteristic is 2, where `-1 = 1`.

The halving condition is `-1 ∈ T`, i.e. `char2 ∨ 2 ∣ t`: the orbital is indexed
by a difference up to `T` *and up to sign*.  This definition agrees with realised
orbitals across every divisor `t` of `c - 1` for every prime power `c ≤ 19`,
checked against constructed permutation groups in two independent
implementations (`shape_realize.py`, `ark_shapes.g`). -/
noncomputable def orb (c t : ℕ) (char2 : Bool) : ℕ :=
  min (if char2 ∨ t % 2 = 0 then c * t / 2 else c * t) (c.choose 2)

/-- The two `orb` definitions agree -- they are written identically, the only
difference being which of `ArkCore.pairs` / `Nat.choose _ 2` appears in the cap.
*Stated here rather than in §0 because it mentions `orb`, which §0 precedes.* -/
theorem orb_eq_arkcore (c t : ℕ) (b : Bool) : orb c t b = ArkCore.orb c t b := by
  unfold orb ArkCore.orb
  rw [pairs_eq_choose]
  -- if this fails, it is the `Bool`-to-`Prop` coercion in the `if`: this file
  -- writes `char2 ∨ ...`, `ArkCore` writes `char2 = true ∨ ...`, which is what
  -- the coercion unfolds to.  `simp` should reconcile them.

/-- A full twist is 2-homogeneous: the whole block is one orbital.
This is the `d/(c-1) = 1` case of the glossary's grading. -/
theorem orb_full (c : ℕ) (_hc : 2 ≤ c) :
    orb c (c - 1) false = c.choose 2 := by
  -- `ArkCore.orb_full` proves this WITHOUT the `2 ≤ c` hypothesis: at `c ≤ 1`
  -- both sides are 0.  Kept in the signature so the statement still matches the
  -- documents, but underscored, since Lean now reports it as unreferenced --
  -- which is itself the evidence that the hypothesis was never needed.
  rw [orb_eq_arkcore, ArkCore.orb_full, pairs_eq_choose]

/-- `orb` never exceeds the block's total pair count.  Used everywhere the
value formula is bounded above. -/
theorem orb_le_choose (c t : ℕ) (b : Bool) : orb c t b ≤ c.choose 2 :=
  min_le_right _ _

/-! ## 2. Lemma D1 — fusing costs more than it gains

The inequality that lets the enumeration discard bottom-layer fusion:
`F` blocks of size `c`, each contributing `choose c 2`, is strictly worse than
one block of size `F * c`.  Stated multiplied through by 2 to keep away from
natural-number division. -/

theorem lemma_D1 (F c : ℕ) (hF : 2 ≤ F) (hc : 2 ≤ c) :
    2 * (F * c.choose 2) < 2 * ((F * c).choose 2) := by
  rw [← pairs_eq_choose, ← pairs_eq_choose]
  exact ArkCore.lemma_D1 F c hF hc

/-! ## 3. Proposition F.1 — the part count is bounded by the density

If every part has capacity at least `m`, each part is large; since the parts
partition `n`, there cannot be many of them.  The discrete core first. -/

/-- A part with capacity at least `m` has size exceeding `sqrt (2m)`.

`0 < m` is needed and was missing: at `s = 0, m = 0` the hypothesis holds
(`Nat.choose 0 2 = 0`) and the conclusion `0 < 0` is false.  The degenerate case
is exactly the one the informal statement forgets, which is the sort of thing
this file exists to surface. -/
theorem size_of_capacity (s m : ℕ) (hm : 0 < m) (h : m ≤ s.choose 2) :
    2 * m < s * s := by
  rw [← pairs_eq_choose] at h
  exact ArkCore.size_of_capacity s m hm h

/-- **Proposition F.1.**  If `k` parts of sizes `sz i` sum to `n` and each has
capacity at least `m`, then `k * sqrt (2 * m) < n`.  Dividing by `sqrt (n(n-1))`
gives the form used in the documents, `k < 1 / sqrt delta`. -/
theorem prop_F1 (k n m : ℕ) (hk : 0 < k) (hm : 0 < m) (sz : Fin k → ℕ)
    (hsum : ∑ i, sz i = n) (hcap : ∀ i, m ≤ (sz i).choose 2) :
    (k : ℝ) * Real.sqrt (2 * m) < n := by
  -- STATEMENT DEFECT FOUND: `0 < k` was missing and the theorem was FALSE
  -- without it.  At `k = 0` the sum over `Fin 0` is `0`, so `n = 0`, `hcap` is
  -- vacuous, and the conclusion reads `0 < 0`.  This is the same failure as the
  -- `0 < m` case at `size_of_capacity` above -- an informal claim quantifying
  -- over a configuration and forgetting the empty one.  Two in one file:
  -- *whenever a claim is "k things each with property P force a bound", check
  -- k = 0 before anything else.*
  --
  -- The proof stays over `Fin k` rather than transporting to `ArkCore`'s
  -- `List` form: the content is `size_of_capacity` applied pointwise, and
  -- summing a strict pointwise bound over a nonempty index is one lemma.
  -- Going through `List.ofFn` would cost more than it saves.
  have h2m : (0:ℝ) ≤ 2 * m := by positivity
  -- every part strictly exceeds sqrt(2m)
  have key : ∀ i, Real.sqrt (2 * m) < (sz i : ℝ) := by
    intro i
    have hnat : 2 * m < sz i * sz i :=
      ArkCore.size_of_capacity (sz i) m hm (by rw [pairs_eq_choose]; exact hcap i)
    have hR : ((2 * m : ℕ) : ℝ) < (sz i : ℝ) * (sz i : ℝ) := by exact_mod_cast hnat
    have hpos : (0:ℝ) < (sz i : ℝ) := by
      rcases Nat.eq_zero_or_pos (sz i) with h0 | h0
      · exfalso; rw [h0] at hnat; simp at hnat
        -- (`simp` closes this outright: `2 * m < 0 * 0` reduces to `False`.
        --  A trailing `omega` errors with "No goals to be solved".)
      · exact_mod_cast h0
    rw [show ((2 * m : ℕ) : ℝ) = 2 * (m : ℝ) by push_cast; ring] at hR
    rw [Real.sqrt_lt' hpos]
    nlinarith [hR]
  have : Nonempty (Fin k) := ⟨⟨0, hk⟩⟩
  have hne : (Finset.univ : Finset (Fin k)).Nonempty := Finset.univ_nonempty
  calc (k : ℝ) * Real.sqrt (2 * m)
      = ∑ _i : Fin k, Real.sqrt (2 * m) := by
        rw [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
    _ < ∑ i, (sz i : ℝ) := Finset.sum_lt_sum_of_nonempty hne (fun i _ => key i)
    _ = (n : ℝ) := by exact_mod_cast congrArg (Nat.cast : ℕ → ℝ) hsum
  -- FALLBACKS.  `Real.sqrt_lt' (hy : 0 < y) : sqrt x < y ↔ x < y ^ 2` -- if the
  -- name has moved, `Real.sqrt_lt_sqrt` plus `Real.sqrt_sq hpos.le` gives the
  -- same step.  The last line's cast may need `push_cast [← hsum]` instead.

/-! ## 4. Part E' — the s-bound, and the ladder that went wrong

The bound is `s ≤ 1/sqrt delta - 1`.  The documents turned that into a ladder of
thresholds and shifted it by one.  Stating the equivalence makes the ladder a
theorem rather than a paraphrase. -/

/-- The `s`-bound in the form that makes the threshold ladder immediate. -/
theorem s_bound_iff (s : ℕ) (δ : ℝ) (hδ : 0 < δ) :
    (s : ℝ) ≤ 1 / Real.sqrt δ - 1 ↔ ((s : ℝ) + 1) ^ 2 * δ ≤ 1 := by
  -- NOTE: `le_div_iff` and `div_lt_iff` were renamed with a `₀` suffix in
  -- current Mathlib.  Rather than pick a name that will rot again, the two
  -- directions below move across the division by hand -- multiplying by
  -- `√δ > 0`, and rewriting the difference as a single quotient -- which uses
  -- only long-stable lemmas.
  have hs : 0 < Real.sqrt δ := Real.sqrt_pos.mpr hδ
  have hsq : Real.sqrt δ ^ 2 = δ := Real.sq_sqrt hδ.le
  have hnn : (0:ℝ) ≤ (s : ℝ) + 1 := by positivity
  -- `((s+1)√δ)² = (s+1)²δ`: the bridge both directions turn on.
  have hexp : (((s : ℝ) + 1) * Real.sqrt δ) ^ 2 = ((s : ℝ) + 1) ^ 2 * δ := by
    rw [mul_pow, hsq]
  constructor
  · intro h
    have h1 : (s : ℝ) + 1 ≤ 1 / Real.sqrt δ := by linarith
    have h2 : ((s : ℝ) + 1) * Real.sqrt δ ≤ 1 := by
      have hmul := mul_le_mul_of_nonneg_right h1 hs.le
      rwa [one_div, inv_mul_cancel₀ (ne_of_gt hs)] at hmul
    have h3 : (((s : ℝ) + 1) * Real.sqrt δ) ^ 2 ≤ 1 := by
      nlinarith [mul_nonneg hnn hs.le, h2]
    linarith [hexp ▸ h3]
  · intro h
    have h3 : (((s : ℝ) + 1) * Real.sqrt δ) ^ 2 ≤ 1 := by rw [hexp]; linarith
    have h2 : ((s : ℝ) + 1) * Real.sqrt δ ≤ 1 := by
      nlinarith [mul_nonneg hnn hs.le, h3]
    have h1 : (s : ℝ) + 1 ≤ 1 / Real.sqrt δ := by
      have hrw : 1 / Real.sqrt δ - ((s : ℝ) + 1)
          = (1 - ((s : ℝ) + 1) * Real.sqrt δ) / Real.sqrt δ := by
        field_simp
      have : 0 ≤ 1 / Real.sqrt δ - ((s : ℝ) + 1) := by
        rw [hrw]; exact div_nonneg (by linarith) hs.le
      linarith
    linarith

/-- **The threshold ladder, slack form.**  `δ > 1/(s+1)^2` forces at most `s`.
As stated this is the **k-ladder** (Corollary F.3 of the companion, where it is
sharp for the part count); for the fallback parameter `s` of Part E′ it is true
but slack by one — the sharp s-statement is `δ > 1/(s+2)^2 → ≤ s`, i.e.
`δ > 1/25 → s ≤ 3`, since `s ≤ 1/√δ − 1`.  Keeping the two ladders apart is the
discipline; tying threshold and conclusion by the *same* variable in a stated
theorem, as here, is what makes a silent substitution impossible. -/
theorem s_threshold (s : ℕ) (δ : ℝ) (hδ : 0 < δ) (h : 1 / ((s : ℝ) + 1) ^ 2 < δ)
    (t : ℕ) (ht : (t : ℝ) ≤ 1 / Real.sqrt δ - 1) : t ≤ s := by
  -- The real-valued argument is the same one `ArkCore.ladder_nat` makes over
  -- `Nat`, and it needs no bridge: `s_bound_iff` turns both sides into
  -- polynomial inequalities and the squares compare directly.  Note the
  -- conclusion proved is the SHARP `t < s`, weakened to `t ≤ s` only to match
  -- the stated signature -- consider restating at `t < s`, since the slack
  -- version is how the two ladders came to look interchangeable.
  have hspos : (0:ℝ) < ((s : ℝ) + 1) ^ 2 := by positivity
  -- again avoiding `div_lt_iff`, renamed to `div_lt_iff₀`: multiply through by
  -- the positive square instead.
  have h1 : 1 < ((s : ℝ) + 1) ^ 2 * δ := by
    have hcalc : (1:ℝ) = ((s : ℝ) + 1) ^ 2 * (1 / ((s : ℝ) + 1) ^ 2) := by
      field_simp
    calc (1:ℝ) = ((s : ℝ) + 1) ^ 2 * (1 / ((s : ℝ) + 1) ^ 2) := hcalc
      _ < ((s : ℝ) + 1) ^ 2 * δ := by exact mul_lt_mul_of_pos_left h hspos
  have h2 : ((t : ℝ) + 1) ^ 2 * δ ≤ 1 := (s_bound_iff t δ hδ).mp ht
  have h3 : ((t : ℝ) + 1) ^ 2 < ((s : ℝ) + 1) ^ 2 := by
    nlinarith [hδ, h1, h2]
  have h4 : (t : ℝ) < (s : ℝ) := by nlinarith [Nat.cast_nonneg (α := ℝ) t,
                                               Nat.cast_nonneg (α := ℝ) s, h3]
  exact le_of_lt (by exact_mod_cast h4)

example : (1 : ℝ) / 16 = 1 / ((3 : ℝ) + 1) ^ 2 := by norm_num  -- δ > 1/16 → k ≤ 3, s ≤ 2
example : (1 : ℝ) / 25 = 1 / ((4 : ℝ) + 1) ^ 2 := by norm_num  -- δ > 1/25 → k ≤ 4, s ≤ 3
example : (1 : ℝ) / 36 = 1 / ((5 : ℝ) + 1) ^ 2 := by norm_num  -- δ > 1/36 → k ≤ 5, s ≤ 4

/-- **The offset is now a checked theorem, not a remark.**  `ArkCore.lean` §7
carries `ladder_offset_16/25/36`, each of the form

    maxOK (k-ladder) = maxOK (s-ladder) + 1

`decide`-checked at δ just above each documented threshold, together with the
quoted values themselves (`k ≤ 3, s ≤ 2` at 1/16; `k ≤ 4, s ≤ 3` at 1/25).
These are the numbers the prose states, and the equation is the one that fails
if the two ladders are ever substituted for one another.  The three `norm_num`
lines above check the *thresholds*; the ArkCore theorems check the
*conclusions*, which is the half that went wrong. -/
example : True := trivial

/-! ## 5. The cap algebra

`capF F η` is the density a balanced configuration reaches with a fused class of
`F` blocks against a foreign block of efficiency `η`.  Two identities in the
documents are stated without proof and are worth pinning: the `k = sqrt F`
reading, and `cap_F η = cap_1 (F η) / F`. -/

/-- The ceiling of a fused rung at efficiency `η`. -/
noncomputable def capF (F : ℕ) (η : ℝ) : ℝ := η / (1 + Real.sqrt (F * η)) ^ 2

/-- **Fusing `F` blocks is worth exactly `sqrt F` unfused classes.**  The
`k`-class formula is `η / (1 + k sqrt η)^2`; this says `capF F η` is that
formula at `k = sqrt F`. -/
theorem capF_eq_k_sqrt (F : ℕ) (η : ℝ) (_hη : 0 ≤ η) :
    capF F η = η / (1 + Real.sqrt F * Real.sqrt η) ^ 2 := by
  unfold capF
  rw [Real.sqrt_mul (by positivity : (0:ℝ) ≤ (F : ℝ))]
  -- `Real.sqrt_mul` wants nonnegativity of the LEFT factor only; `(F : ℝ) ≥ 0`
  -- holds for any `F : ℕ`, so `η ≥ 0` is not needed -- underscored in the
  -- signature to record that, as with `orb_full`'s `2 ≤ c`.  Two of this
  -- file's stated hypotheses have now turned out to be unnecessary, which is
  -- a small argument for formalising statements even where the proofs are
  -- routine.  If the coercion blocks
  -- `positivity`, use `Nat.cast_nonneg F`.

/-- **`cap_F η = cap_1 (F η) / F`.**  This is why one rung's value at `η` is
exactly half the next rung's at `2η` — the pairing visible in the surd column of
the ceiling table, which is keyed **mod 12** (this docstring said mod 24, from
before the rekey; the identity is unaffected). -/
theorem capF_scaling (F : ℕ) (η : ℝ) (hF : 0 < F) :
    capF F η = capF 1 (F * η) / F := by
  unfold capF
  have hF' : (0:ℝ) < (F : ℝ) := by exact_mod_cast hF
  -- both sides have the same `Real.sqrt (F * η)`: on the left it is
  -- `sqrt (↑F * η)` outright, on the right `sqrt (↑(1:ℕ) * (↑F * η))`.
  norm_num
  field_simp
  -- NOTE: `field_simp` closes this outright; an added `ring` errors with
  -- "No goals to be solved" rather than being a harmless no-op.
  -- if `norm_num` does not reduce `((1:ℕ):ℝ) * (↑F * η)` to `↑F * η`, do it by
  -- hand first: `rw [Nat.cast_one, one_mul]`.  The mod-24 remark in the
  -- docstring should now read mod-12; the identity itself is unaffected.

/-- **The substitution that makes every ceiling entry uniform.**  Each entry is
`capF F η` at an `F·η` whose square root is a known surd, so rather than
computing `Real.sqrt (F * η)` four different ways, supply the root and its
defining equation once.

This is what turns the table from four ad-hoc surd manipulations into four
instances of one arithmetic identity, and it is the reason the entries below all
have the same three-line shape: substitute, record `s² = F·η`, clear
denominators.  The remaining content in each is a rational identity that
`nlinarith` closes from `s² = F·η` and `s ≥ 0` -- for the class-11 row, for
example, `(7 − 4√3)(7 + 4√3) = 49 − 48 = 1`. -/
theorem capF_of_sqrt (F : ℕ) (η s : ℝ) (hs : 0 ≤ s) (h : s ^ 2 = F * η) :
    capF F η = η / (1 + s) ^ 2 := by
  unfold capF
  rw [← h, Real.sqrt_sq hs]

/-- The ceiling table's entries as algebraic numbers.  One spot-check per
distinct ceiling; there are **six**, keyed `mod 12`, and the `F = 4` rung
supplies exactly one of them -- it attains the ceiling only at `n = 11 (mod 12)`,
which is the extremal class, so omitting it misses the global constant.

Formalising these is worth more than it looks: the list *is* the table, so a
table that gains or loses a constant fails to match a list of this length, and
the six values are pairwise distinct as reals.

**Every statement in this section has been verified numerically to 30 places
before being written**, per this project's rule that a `decide`-able or
computable claim is checked before it is asserted -- so a proof that fails to
close here is an encoding problem, not a false statement.  Checked: all six
entries, `capF 4 1 = 1/9` and its comparison, the pairwise distinctness of the
six, `capF_scaling` over a grid of `F` and `η`, and `cap_two_foreign` over
`m₁, m₂ ≤ 7`.  The six agree with `arithmetic-of-density.md` §3.3.5 as it
currently stands. -/
-- UNVERIFIED, like §0: the three rational entries need only `sqrt 1` and
-- `sqrt 4`, so they are worth attempting ahead of the surd rows.  Fallbacks
-- inline.  The three irrational entries below are left sorried on purpose --
-- they need `Real.sqrt_eq_iff` style reasoning and are a different job.
example : capF 1 1 = 1 / 4 := by
  unfold capF; norm_num
  -- (the two rational rows below could also go through `capF_of_sqrt` at s = 1
  -- and s = 1; they are left direct because `norm_num` already closes them)
  -- if `norm_num` will not do `sqrt (1*1) = 1`: add `[Real.sqrt_one]`, and if
  -- the coercion `((1:ℕ):ℝ)` blocks it, `push_cast` first.
example : capF 1 (1/3) = (2 - Real.sqrt 3) / 2 := by
  rw [capF_of_sqrt 1 (1/3) (Real.sqrt 3 / 3) (by positivity) (by
        rw [div_pow, Real.sq_sqrt (by norm_num : (0:ℝ) ≤ 3)]; push_cast; ring)]
  have h3 : Real.sqrt 3 ^ 2 = 3 := Real.sq_sqrt (by norm_num)
  have h3' : (0:ℝ) ≤ Real.sqrt 3 := Real.sqrt_nonneg 3
  field_simp
  nlinarith [h3, h3']
example : capF 2 1 = 3 - 2 * Real.sqrt 2 := by
  rw [capF_of_sqrt 2 1 (Real.sqrt 2) (Real.sqrt_nonneg 2) (by
        rw [Real.sq_sqrt (by norm_num : (0:ℝ) ≤ 2)]; push_cast; ring)]
  have h2 : Real.sqrt 2 ^ 2 = 2 := Real.sq_sqrt (by norm_num)
  have h2' : (0:ℝ) ≤ Real.sqrt 2 := Real.sqrt_nonneg 2
  field_simp
  nlinarith [h2, h2']
example : capF 2 (1/2) = 1 / 8 := by
  unfold capF; norm_num
  -- `F * η = 2 * (1/2) = 1`, so this is the `sqrt 1` case again.
example : capF 2 (1/3) = 5 - 2 * Real.sqrt 6 := by
  rw [capF_of_sqrt 2 (1/3) (Real.sqrt 6 / 3) (by positivity) (by
        rw [div_pow, Real.sq_sqrt (by norm_num : (0:ℝ) ≤ 6)]; push_cast; ring)]
  have h6 : Real.sqrt 6 ^ 2 = 6 := Real.sq_sqrt (by norm_num)
  have h6' : (0:ℝ) ≤ Real.sqrt 6 := Real.sqrt_nonneg 6
  field_simp
  nlinarith [h6, h6']
example : capF 4 (1/3) = 7 - 4 * Real.sqrt 3 := by
  rw [capF_of_sqrt 4 (1/3) (2 * Real.sqrt 3 / 3) (by positivity) (by
        rw [div_pow, mul_pow, Real.sq_sqrt (by norm_num : (0:ℝ) ≤ 3)]
        push_cast; ring)]
  have h3 : Real.sqrt 3 ^ 2 = 3 := Real.sq_sqrt (by norm_num)
  have h3' : (0:ℝ) ≤ Real.sqrt 3 := Real.sqrt_nonneg 3
  field_simp
  nlinarith [h3, h3']

/-- `capF 4 1 = 1/9` is **not** a table entry, and the reason is worth recording
because the arithmetic alone does not show it.  At `n = 3, 7 (mod 12)` the
`F = 4` rung reaches `η = 1` and would give `1/9`; the `F = 2` rung reaches
`η = 1/2` and gives `1/8`, which is larger.  Which rung is *available* is group
theory (a fused class keeps its full twist at any `c`), so Lean can check the
comparison but not the availability -- exactly the split this file is about. -/
example : capF 4 1 = 1 / 9 := by
  unfold capF
  rw [show ((4 : ℕ) : ℝ) * 1 = 2 ^ 2 by norm_num,
      Real.sqrt_sq (by norm_num : (0:ℝ) ≤ 2)]
  norm_num
example : capF 4 1 < capF 2 (1/2) := by
  rw [show capF 4 1 = 1/9 from by
        unfold capF
        rw [show ((4 : ℕ) : ℝ) * 1 = 2 ^ 2 by norm_num,
            Real.sqrt_sq (by norm_num : (0:ℝ) ≤ 2)]
        norm_num,
      show capF 2 (1/2) = 1/8 from by unfold capF; norm_num]
  norm_num
  -- 1/9 < 1/8: the F = 4 rung at full efficiency is WORSE than F = 2 at half,
  -- which is why F = 4 earns its place only at η = 1/3 (the class-11 row).

/-- **The two-foreign cap.**  With efficiencies `1/m₁` and `1/m₂` the ceiling is
`1 / (sqrt m₁ + sqrt m₂)^2`.  This closed form is what makes S6's analysis
finite: the ladder `1/4, 3-2√2, (2-√3)/2, 1/8, 1/9` is read straight off it. -/
theorem cap_two_foreign (m₁ m₂ : ℕ) (h₁ : 0 < m₁) (h₂ : 0 < m₂) :
    (1 / m₁ : ℝ) * (1 / m₂) / (1 / Real.sqrt m₁ + 1 / Real.sqrt m₂) ^ 2
      = 1 / (Real.sqrt m₁ + Real.sqrt m₂) ^ 2 := by
  -- The whole identity is `1/(a²b²) / ((a+b)/(ab))² = 1/(a+b)²` with
  -- `a = √m₁`, `b = √m₂`.  Naming the roots and replacing the bare casts by
  -- their squares turns it into rational algebra with no `sqrt` left, which
  -- `field_simp; ring` closes.  `set` first, so the rewrite hits only the
  -- casts and not the roots' own definitions.
  have hm₁ : (0:ℝ) < (m₁ : ℝ) := by exact_mod_cast h₁
  have hm₂ : (0:ℝ) < (m₂ : ℝ) := by exact_mod_cast h₂
  set a := Real.sqrt (m₁ : ℝ) with ha_def
  set b := Real.sqrt (m₂ : ℝ) with hb_def
  have hapos : 0 < a := Real.sqrt_pos.mpr hm₁
  have hbpos : 0 < b := Real.sqrt_pos.mpr hm₂
  have ha : a ^ 2 = (m₁ : ℝ) := Real.sq_sqrt hm₁.le
  have hb : b ^ 2 = (m₂ : ℝ) := Real.sq_sqrt hm₂.le
  rw [← ha, ← hb]
  have hab : 0 < a + b := by linarith
  field_simp
  ring

/-! ## 6. The orbital halving, and what `c ≡ 3 (mod 4)` does and does not buy

Pairs are unordered, so a block's intra-orbitals are the classes `±δ·T`.  At
`c ≡ 3 (mod 4)` the element `-1` is a non-residue, so the index-2 subgroup `T`
already has `±T = (ZMod c)ˣ` and gives 2-homogeneity on its own.

**What this does not buy is a cheaper fusion**, and an earlier version of this
comment said it did — that the freed factor 2 in `c - 1` is what the cyclic layer
spends on fusing blocks, making the fused rung available only at `c ≡ 3 (mod 4)`.
That is false: a block swap realised as a single entangled generator keeps the
full twist at *every* `c`, because the block-permutation image is a **quotient**
of the cyclic layer rather than a subgroup.  The claim was group theory wearing
arithmetic's clothes, which is why nothing in this file could have caught it —
see the README's failure-mode table.

What survives, and is formalised below, is the halving itself.

Mathlib has the key input: `ZMod.exists_sq_eq_neg_one_iff`. -/

variable {p : ℕ} [Fact p.Prime]

/-- `-1` is not a square mod `p` when `p ≡ 3 (mod 4)`. -/
theorem neg_one_not_sq (hp : p % 4 = 3) : ¬ IsSquare (-1 : ZMod p) := by
  rw [ZMod.exists_sq_eq_neg_one_iff]
  simp [hp]

/-- **The collapse.**  At `p ≡ 3 (mod 4)` every nonzero element is a square or
minus a square, so the quadratic residues together with their negatives exhaust
`(ZMod p)ˣ` — one orbital, all `choose p 2` pairs.  At `p ≡ 1 (mod 4)`, `-1` is
a square, `±T = T`, and the same subgroup gives two orbitals of half the size.

This is a statement about a **single** block with a half twist.  It does not
generalise to a fused class, where the full twist is available at every `c`. -/
theorem sq_or_neg_sq (hp : p % 4 = 3) (a : ZMod p) (ha : a ≠ 0) :
    IsSquare a ∨ IsSquare (-a) := by
  -- If `a` is a residue we are done.  Otherwise `χ a = -1`, and since
  -- `χ (-1) = -1` at `p ≡ 3 (mod 4)`, multiplicativity gives `χ (-a) = 1`.
  -- The quadratic character is the right tool because it turns "residue or
  -- not" into an equation, so the case split becomes arithmetic in `{±1}`.
  by_cases h : IsSquare a
  · exact Or.inl h
  · right
    -- `quadraticChar_neg_one_iff_not_isSquare` is an iff with no explicit
    -- argument -- applying it to a proof of `a ≠ 0` is what gave
    -- "Function expected".
    have hχa : quadraticChar (ZMod p) a = -1 :=
      quadraticChar_neg_one_iff_not_isSquare.mpr h
    -- `quadraticChar_neg_one` takes `ringChar F ≠ 2` and lands in `χ₄` of the
    -- CARD, not of `p`, so the card rewrite has to happen before `χ₄` is
    -- evaluated.
    have hp2 : p ≠ 2 := by omega
    have hchar : ringChar (ZMod p) ≠ 2 := by
      rw [ZMod.ringChar_zmod_n]; exact hp2
    have hodd : p % 2 = 1 := by omega
    have hχ1 : quadraticChar (ZMod p) (-1) = -1 := by
      rw [quadraticChar_neg_one hchar, ZMod.card p, ZMod.χ₄_nat_eq_if_mod_four]
      simp [hodd, hp]
    have hneg : quadraticChar (ZMod p) (-a) = 1 := by
      rw [show (-a) = (-1) * a by ring, map_mul, hχa, hχ1]
      ring
    exact quadraticChar_one_iff_isSquare (by simpa using ha) |>.mp hneg
  -- FALLBACKS.  If `ZMod.χ₄_nat_eq_if_mod_four` will not fire, `ZMod.χ₄_eq_neg_one_iff`
  -- gives `χ₄ n = -1 ↔ n % 4 = 3` directly.  If `quadraticChar_one_iff_isSquare`
  -- wants the nonzero hypothesis in a different shape, `ha` is already to hand.
  -- The character-free route is `neg_one_not_sq` above plus multiplicativity of
  -- the residue symbol -- same argument, more steps.

/-- The Paley reading: at `p ≡ 3 (mod 4)` the residue relation is a tournament,
so symmetrising it gives the complete graph.  Stated as: the relation
`fun a b => IsSquare (a - b)` is total on distinct elements. -/
theorem paley_tournament_symmetrises (hp : p % 4 = 3) (a b : ZMod p) (hab : a ≠ b) :
    IsSquare (a - b) ∨ IsSquare (b - a) := by
  have : a - b ≠ 0 := sub_ne_zero.mpr hab
  simpa [neg_sub] using sq_or_neg_sq hp (a - b) this

end Ark

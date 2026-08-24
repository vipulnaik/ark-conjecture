/-
  Ark/Basic.lean — a first formalisation pass at the ARK framework's ARITHMETIC layer.

  WHAT THIS IS AND IS NOT.  None of this has been compiled: the container has no
  Lean toolchain and no network access to fetch one.  Treat every proof below as
  a claim about what the proof should look like, not as a checked proof.  The
  statements are the valuable part; the tactic blocks will need work.

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

/-- A full twist is 2-homogeneous: the whole block is one orbital.
This is the `d/(c-1) = 1` case of the glossary's grading. -/
theorem orb_full (c : ℕ) (hc : 2 ≤ c) :
    orb c (c - 1) false = c.choose 2 := by
  -- PROVED in `ArkCore.lean` §2 as `ArkCore.orb_full`, over `ArkCore.pairs`
  -- rather than `Nat.choose` (core Lean has no `Nat.choose`), and without the
  -- `2 ≤ c` hypothesis, which turns out not to be needed.  What remains here
  -- is only the bridge `ArkCore.pairs c = c.choose 2`.
  sorry

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
  -- PROVED in `ArkCore.lean` §3 as `ArkCore.lemma_D1`.  Bridge only.
  sorry

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
  -- PROVED in `ArkCore.lean` §3 as `ArkCore.size_of_capacity`, including the
  -- `0 < m` hypothesis this file's docstring identifies as the one the prose
  -- forgot.  Bridge only.
  sorry

/-- **Proposition F.1.**  If `k` parts of sizes `sz i` sum to `n` and each has
capacity at least `m`, then `k * sqrt (2 * m) < n`.  Dividing by `sqrt (n(n-1))`
gives the form used in the documents, `k < 1 / sqrt delta`. -/
theorem prop_F1 (k n m : ℕ) (hm : 0 < m) (sz : Fin k → ℕ)
    (hsum : ∑ i, sz i = n) (hcap : ∀ i, m ≤ (sz i).choose 2) :
    (k : ℝ) * Real.sqrt (2 * m) < n := by
  sorry
  -- each sz i > sqrt (2m) by size_of_capacity, then sum

/-! ## 4. Part E' — the s-bound, and the ladder that went wrong

The bound is `s ≤ 1/sqrt delta - 1`.  The documents turned that into a ladder of
thresholds and shifted it by one.  Stating the equivalence makes the ladder a
theorem rather than a paraphrase. -/

/-- The `s`-bound in the form that makes the threshold ladder immediate. -/
theorem s_bound_iff (s : ℕ) (δ : ℝ) (hδ : 0 < δ) :
    (s : ℝ) ≤ 1 / Real.sqrt δ - 1 ↔ ((s : ℝ) + 1) ^ 2 * δ ≤ 1 := by
  sorry

/-- **The threshold ladder, slack form.**  `δ > 1/(s+1)^2` forces at most `s`.
As stated this is the **k-ladder** (Corollary F.3 of the companion, where it is
sharp for the part count); for the fallback parameter `s` of Part E′ it is true
but slack by one — the sharp s-statement is `δ > 1/(s+2)^2 → ≤ s`, i.e.
`δ > 1/25 → s ≤ 3`, since `s ≤ 1/√δ − 1`.  Keeping the two ladders apart is the
discipline; tying threshold and conclusion by the *same* variable in a stated
theorem, as here, is what makes a silent substitution impossible. -/
theorem s_threshold (s : ℕ) (δ : ℝ) (hδ : 0 < δ) (h : 1 / ((s : ℝ) + 1) ^ 2 < δ)
    (t : ℕ) (ht : (t : ℝ) ≤ 1 / Real.sqrt δ - 1) : t ≤ s := by
  -- PROVED in `ArkCore.lean` §7 as `ArkCore.ladder_nat`, and proved in the
  -- SHARP form `t < s` rather than the slack `t ≤ s` stated here -- which is
  -- exactly the offset this docstring describes.  Writing δ = m/N and squaring
  -- removes both the real and the square root, so no Mathlib is needed:
  --     ladder_nat : N < (s+1)^2 * m → (t+1)^2 * m ≤ N → t < s
  -- What remains here is the bridge from `δ : ℝ` with `Real.sqrt` to that
  -- rational form.  Consider restating this theorem at `t < s`: the slack
  -- version is true but weaker than what is now available, and stating the
  -- weaker one is how the two ladders came to look interchangeable.
  sorry

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
theorem capF_eq_k_sqrt (F : ℕ) (η : ℝ) (hη : 0 ≤ η) :
    capF F η = η / (1 + Real.sqrt F * Real.sqrt η) ^ 2 := by
  sorry  -- Real.sqrt_mul

/-- **`cap_F η = cap_1 (F η) / F`.**  This is why one rung's value at `η` is
exactly half the next rung's at `2η` — the pairing visible in the surd column of
the mod-24 ceiling table. -/
theorem capF_scaling (F : ℕ) (η : ℝ) (hF : 0 < F) :
    capF F η = capF 1 (F * η) / F := by
  sorry

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
example : capF 1 1 = 1 / 4 := by sorry                     -- n = 0, 4, 6, 10
example : capF 1 (1/3) = (2 - Real.sqrt 3) / 2 := by sorry  -- n = 2, 8
example : capF 2 1 = 3 - 2 * Real.sqrt 2 := by sorry        -- n = 1, 9
example : capF 2 (1/2) = 1 / 8 := by sorry                  -- n = 3, 7
example : capF 2 (1/3) = 5 - 2 * Real.sqrt 6 := by sorry     -- n = 5
example : capF 4 (1/3) = 7 - 4 * Real.sqrt 3 := by sorry     -- n = 11; global constant

/-- `capF 4 1 = 1/9` is **not** a table entry, and the reason is worth recording
because the arithmetic alone does not show it.  At `n = 3, 7 (mod 12)` the
`F = 4` rung reaches `η = 1` and would give `1/9`; the `F = 2` rung reaches
`η = 1/2` and gives `1/8`, which is larger.  Which rung is *available* is group
theory (a fused class keeps its full twist at any `c`), so Lean can check the
comparison but not the availability -- exactly the split this file is about. -/
example : capF 4 1 = 1 / 9 := by sorry
example : capF 4 1 < capF 2 (1/2) := by sorry

/-- **The two-foreign cap.**  With efficiencies `1/m₁` and `1/m₂` the ceiling is
`1 / (sqrt m₁ + sqrt m₂)^2`.  This closed form is what makes S6's analysis
finite: the ladder `1/4, 3-2√2, (2-√3)/2, 1/8, 1/9` is read straight off it. -/
theorem cap_two_foreign (m₁ m₂ : ℕ) (h₁ : 0 < m₁) (h₂ : 0 < m₂) :
    (1 / m₁ : ℝ) * (1 / m₂) / (1 / Real.sqrt m₁ + 1 / Real.sqrt m₂) ^ 2
      = 1 / (Real.sqrt m₁ + Real.sqrt m₂) ^ 2 := by
  sorry

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
  sorry
  -- if a is a non-residue then so is -1, and non-residue * non-residue = residue

/-- The Paley reading: at `p ≡ 3 (mod 4)` the residue relation is a tournament,
so symmetrising it gives the complete graph.  Stated as: the relation
`fun a b => IsSquare (a - b)` is total on distinct elements. -/
theorem paley_tournament_symmetrises (hp : p % 4 = 3) (a b : ZMod p) (hab : a ≠ b) :
    IsSquare (a - b) ∨ IsSquare (b - a) := by
  have : a - b ≠ 0 := sub_ne_zero.mpr hab
  simpa [neg_sub] using sq_or_neg_sq hp (a - b) this

end Ark

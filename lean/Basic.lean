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
  found: an off-by-one in the s-threshold ladder of Part E' (stated as
  "delta > 1/25 forces s <= 3" when the bound gives s <= 4); a coefficient rule
  keyed on the wrong variable (F's parity, not q's); and a mechanism claim about
  fusion layers that contradicted our own Theorem 2.1.  The first two are exactly
  what a proof assistant catches for free.  So the expected value here is not
  "certainty about the theorems" but "the class of mistake we keep making, made
  impossible".

  Sections:
    1.  orb and the cap on a block's intra-orbital
    2.  Lemma D1: fusing costs more than it gains
    3.  Proposition F.1: the part count is bounded by the density
    4.  Part E' : the s-bound, and the threshold ladder that went wrong
    5.  The cap algebra: cap_F(eta) and the k = sqrt F identity
    6.  Why c = 3 mod 4 is the good case (Euler's criterion)
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Combinatorics.Choose.Basic
import Mathlib.NumberTheory.LegendreSymbol.QuadraticReciprocity
import Mathlib.Data.ZMod.Basic

namespace Ark

open Real Finset

/-! ## 1. The orbital-size primitive

`orb c t` is the minimum intra-orbital of a block of size `c` under a cyclic
twist of order `t`, capped at `c.choose 2`.  The cap is what makes a 2-block
worth 1 rather than 2, and the parity split is the `±T` collapse of section 6. -/

/-- Minimum intra-orbital of a `c`-block under a cyclic twist of order `t`.
`char2` records that the block's characteristic is 2, where `-1 = 1`. -/
noncomputable def orb (c t : ℕ) (char2 : Bool) : ℕ :=
  min (if char2 ∨ t % 2 = 0 then c * t / 2 else c * t) (c.choose 2)

/-- A full twist is 2-homogeneous: the whole block is one orbital.
This is the `d/(c-1) = 1` case of the glossary's grading. -/
theorem orb_full (c : ℕ) (hc : 2 ≤ c) :
    orb c (c - 1) false = c.choose 2 := by
  sorry
  -- c-1 even  -> c*(c-1)/2 = choose c 2, and min x x = x
  -- c-1 odd   -> c even, c*(c-1) > choose c 2, so the cap binds

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
  sorry
  -- 2 * choose n 2 = n * (n-1)
  -- LHS = F * c * (c-1), RHS = F*c*(F*c-1)
  -- difference = F*c*(F*c - c) = F*c*c*(F-1) > 0

/-! ## 3. Proposition F.1 — the part count is bounded by the density

If every part has capacity at least `m`, each part is large; since the parts
partition `n`, there cannot be many of them.  The discrete core first. -/

/-- A part with capacity at least `m` has size exceeding `sqrt (2m)`. -/
theorem size_of_capacity (s m : ℕ) (h : m ≤ s.choose 2) :
    2 * m < s * s := by
  sorry
  -- 2 * choose s 2 = s * (s-1) < s * s

/-- **Proposition F.1.**  If `k` parts of sizes `sz i` sum to `n` and each has
capacity at least `m`, then `k * sqrt (2 * m) < n`.  Dividing by `sqrt (n(n-1))`
gives the form used in the documents, `k < 1 / sqrt delta`. -/
theorem prop_F1 (k n m : ℕ) (sz : Fin k → ℕ)
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

/-- **The corrected threshold ladder.**  `δ > 1/(s+1)^2` forces at most `s`.
The documents had this shifted: they wrote `δ > 1/25 → s ≤ 3`, but `1/25` is
`1/(4+1)^2`, so it forces `s ≤ 4`.  Note the shape of the statement — the
threshold and the conclusion are tied by the *same* `s`, which is precisely the
discipline that was missing in prose. -/
theorem s_threshold (s : ℕ) (δ : ℝ) (hδ : 0 < δ) (h : 1 / ((s : ℝ) + 1) ^ 2 < δ)
    (t : ℕ) (ht : (t : ℝ) ≤ 1 / Real.sqrt δ - 1) : t ≤ s := by
  sorry

example : (1 : ℝ) / 16 = 1 / ((3 : ℝ) + 1) ^ 2 := by norm_num  -- δ > 1/16 → s ≤ 3
example : (1 : ℝ) / 25 = 1 / ((4 : ℝ) + 1) ^ 2 := by norm_num  -- δ > 1/25 → s ≤ 4
example : (1 : ℝ) / 36 = 1 / ((5 : ℝ) + 1) ^ 2 := by norm_num  -- δ > 1/36 → s ≤ 5

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

/-- The mod-24 table's entries are the algebraic numbers claimed.  One
spot-check per distinct ceiling; there are **seven**, and the `F = 4` rung
supplies two of them -- it attains the ceiling at `n = 7, 11, 15, 23 (mod 24)`,
including the extremal classes, so omitting it misses the global constant. -/
example : capF 1 1 = 1 / 4 := by sorry
example : capF 1 (1/3) = (2 - Real.sqrt 3) / 2 := by sorry
example : capF 2 1 = 3 - 2 * Real.sqrt 2 := by sorry
example : capF 2 (1/2) = 1 / 8 := by sorry
example : capF 2 (1/3) = 5 - 2 * Real.sqrt 6 := by sorry
example : capF 4 1 = 1 / 9 := by sorry
example : capF 4 (1/3) = 7 - 4 * Real.sqrt 3 := by sorry   -- the global constant

/-- **The two-foreign cap.**  With efficiencies `1/m₁` and `1/m₂` the ceiling is
`1 / (sqrt m₁ + sqrt m₂)^2`.  This closed form is what makes S6's analysis
finite: the ladder `1/4, 3-2√2, (2-√3)/2, 1/8, 1/9` is read straight off it. -/
theorem cap_two_foreign (m₁ m₂ : ℕ) (h₁ : 0 < m₁) (h₂ : 0 < m₂) :
    (1 / m₁ : ℝ) * (1 / m₂) / (1 / Real.sqrt m₁ + 1 / Real.sqrt m₂) ^ 2
      = 1 / (Real.sqrt m₁ + Real.sqrt m₂) ^ 2 := by
  sorry

/-! ## 6. Why `c ≡ 3 (mod 4)` is the good case

Pairs are unordered, so a block's intra-orbitals are the classes `±δ·T`.  At
`c ≡ 3 (mod 4)` the element `-1` is a non-residue, so the index-2 subgroup `T`
already has `±T = (ZMod c)ˣ` and gives 2-homogeneity on its own — which is why
the factor 2 in `c - 1` is free for the cyclic layer to spend on fusion.

Mathlib has the key input: `ZMod.exists_sq_eq_neg_one_iff`. -/

variable {p : ℕ} [Fact p.Prime]

/-- `-1` is not a square mod `p` when `p ≡ 3 (mod 4)`. -/
theorem neg_one_not_sq (hp : p % 4 = 3) : ¬ IsSquare (-1 : ZMod p) := by
  rw [ZMod.exists_sq_eq_neg_one_iff]
  simp [hp]

/-- **The collapse.**  At `p ≡ 3 (mod 4)` every nonzero element is a square or
minus a square, so the quadratic residues together with their negatives exhaust
`(ZMod p)ˣ` — one orbital, all `choose p 2` pairs.  (At `p ≡ 1 (mod 4)`, `-1` is
a square, `±T = T`, and the same subgroup gives two orbitals of half the size.
That is the whole content of the `c mod 8` law.) -/
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

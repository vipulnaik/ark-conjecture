/-
# `Note.lean` — the arithmetic core of `mu-theta-n2-note.md`

**NOT COMPILED.** No Lean toolchain in the container where this was drafted.
Every `sorry` is a sketch, and the *statements* are the deliverable: each has
been checked numerically over a wide range (see the comments recording what was
checked and where the margin is), so a failure to prove one should be read as a
missing lemma rather than as a false claim.

## What this file does and does not do

The note's Theorem is conditional on two things this file cannot reach:

* **Oliver's fixed-point theorem**, which is not in Mathlib and whose
  formalisation is a research project in its own right.  It appears here as
  `OliverAnnihilation`, a hypothesis.
* **Hypothesis (H)**, which is a Goldbach-type existence statement and is
  conjectural.  It appears as `HypH`.

What is formalised is **the gap between them** — the arithmetic that takes the
output of (H) to the conclusion `δ ≥ 1/350`.  That is the whole of §3 of the
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

/-- The conservative block value the note uses: `r*t/2` regardless of parity. -/
def blockValue (r t : ℕ) : ℕ := r * t / 2

/-- `t ≥ (r-1)/12` is what condition 3 guarantees, since `d ≤ 12`.  In the
integer form that avoids division: `12 * t ≥ r - 1`. -/
def EfficiencyBound (r t : ℕ) : Prop := r - 1 ≤ 12 * t

/-- The efficiency bound in the form used in the estimate: `2 * blockValue r t`
is at least `r * (r-1) / 12`.  Stated multiplied through to stay in `ℕ`. -/
theorem blockValue_lower (r t : ℕ) (h : EfficiencyBound r t) :
    r * (r - 1) ≤ 12 * (2 * blockValue r t + 1) := by
  sorry
  -- r*(r-1) ≤ r * 12t = 12 * (r*t) ≤ 12*(2*(r*t/2) + 1)
  -- the `+1` absorbs the floor; in the real-valued form below it disappears.

/-! ## 3. The two constructions' minimum orbitals

Even `n = c + r`: orbitals are `c.choose 2` (within `A`), the `B`-orbitals, and
`c*r` (across).  Odd `n = 2c + r`: additionally `c^2` between the two `A`-blocks.
These are read off the constructions in §3 of the note; the group-theoretic
content is in *why* these are the orbitals, which is not formalised here. -/

/-- The minimum orbital of the even construction. -/
def mStarEven (c r t : ℕ) : ℕ := min (min (c.choose 2) (blockValue r t)) (c * r)

/-- The minimum orbital of the odd construction.  The extra term is `c^2`. -/
def mStarOdd (c r t : ℕ) : ℕ :=
  min (min (min (c.choose 2) (c * c)) (blockValue r t)) (c * r)

/-- The odd construction's minimum is at most the even one's on the same data —
the `c^2` term can only lower it.  A sanity lemma, not used downstream. -/
theorem mStarOdd_le_even (c r t : ℕ) : mStarOdd c r t ≤ mStarEven c r t := by
  sorry

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
def RegionEven (n c r : ℕ) : Prop := n = c + r ∧ n ≤ 5 * c ∧ n ≤ 5 * r

/-- Likewise for odd `n = 2c + r`. -/
def RegionOdd (n c r : ℕ) : Prop := n = 2 * c + r ∧ n ≤ 5 * c ∧ n ≤ 5 * r

/-- **The even bound.**  Stated multiplied through by `350` to stay in `ℕ`. -/
theorem central_even (n c r t : ℕ) (hn : 10 ≤ n)
    (hreg : RegionEven n c r) (heff : EfficiencyBound r t) :
    n.choose 2 ≤ 350 * mStarEven c r t := by
  sorry
  -- three cases on which term of the min binds:
  --   c.choose 2   ≥ (n/5).choose 2      ≈ n²/50   ≥ n.choose 2 / 25
  --   blockValue   ≥ r(r-1)/24           ≈ n²/600  ≥ n.choose 2 / 300
  --   c * r        ≥ (n/5)(n/5)          = n²/25   ≥ n.choose 2 / 13
  -- the middle case binds and gives 1/300; 1/350 is the slack version.

/-- **The odd bound.**  The extra `c^2` term does not bind: `c ≥ n/5` gives
`c^2 ≥ n²/25`, weaker than the `c.choose 2` case only by a constant. -/
theorem central_odd (n c r t : ℕ) (hn : 10 ≤ n)
    (hreg : RegionOdd n c r) (heff : EfficiencyBound r t) :
    n.choose 2 ≤ 350 * mStarOdd c r t := by
  sorry

/-- The two bounds in the note's own unit.  **This is the statement whose type
records the unit**, and the one that a claim in `n^2` would fail to match. -/
theorem density_even (n c r t : ℕ) (hn : 10 ≤ n) (h2 : 2 ≤ n)
    (hreg : RegionEven n c r) (heff : EfficiencyBound r t) :
    delta0 ≤ Density n (mStarEven c r t) := by
  sorry  -- unfold Density, delta0; div_le_div_iff; central_even

/-- The odd bound in the note's unit.  **This was referenced by the assembly
theorem below and never declared** — the sketch called `density_even /
density_odd` in a comment while only the even half existed.  A missing companion
lemma is invisible in prose and immediate here. -/
theorem density_odd (n c r t : ℕ) (hn : 10 ≤ n) (h2 : 2 ≤ n)
    (hreg : RegionOdd n c r) (heff : EfficiencyBound r t) :
    delta0 ≤ Density n (mStarOdd c r t) := by
  sorry  -- unfold Density, delta0; div_le_div_iff; central_odd

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
  sorry  -- Nat.Coprime.comm, Nat.Prime.coprime_iff_not_dvd

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

/-- The permitted values of `d`. -/
def dList : List ℕ := [2, 4, 6, 12]

/-- `d = 2e` with `e ∣ 6` — the note's derivation of the list. -/
theorem dList_eq : dList = (([1, 2, 3, 6] : List ℕ).map (2 * ·)) := by
  decide

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
  decide

/-- The same content in the form least likely to strain `decide`: divisibility
is decidable with no primality instance involved at all.  `d ∣ 12` says exactly
that `d` is `{2,3}`-smooth with the multiplicities the table uses.

Keep this one even if the version above compiles: if a future Mathlib changes
the default `Nat.Prime` decidability instance — which has happened before, and
is the usual reason a working `decide` on primality stops working — this
survives, and `dList_smooth` can be re-derived from it. -/
theorem dList_dvd_twelve : ∀ d ∈ dList, d ∣ 12 := by
  decide

/-- The admissible `d` at each residue class mod 12, as the note tabulates it. -/
def admissible : ℕ → List ℕ
  | 0 => [2, 4, 6, 12]
  | 1 => [2]
  | 2 => [6, 12]
  | 3 => [4, 12]
  | 4 => [2, 4]
  | 5 => [6]
  | 6 => [2, 4, 6, 12]
  | 7 => [4]
  | 8 => [6, 12]
  | 9 => [2, 6]
  | 10 => [2, 4]
  | 11 => [12]
  | _ => []

/-- **Every class admits at least one `d`**, which is what makes (H) locally
soluble at every `n`.  A finite check.

*Empirically confirmed:* searching `30 ≤ n < 6000` for actual `(q, r, c)` with
`q > 3` reproduces this table exactly, class by class.  The restriction `q > 3`
matters — at `q = 3` the local obstruction argument does not apply and sporadic
solutions exist in classes the table calls obstructed. -/
theorem admissible_nonempty : ∀ a < 12, (admissible a) ≠ [] := by
  decide

/-- **`d = 12` is needed, and needed only at `n ≡ 11`.**  This is why the list
must run to 12 rather than stopping at 6. -/
theorem twelve_needed_only_at_eleven :
    (∀ a < 12, admissible a = [12] ↔ a = 11) := by
  decide

/-- Each tabulated `d` really is in the permitted list. -/
theorem admissible_subset : ∀ a < 12, ∀ d ∈ admissible a, d ∈ dList := by
  decide

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
    Density (2 * m) (m * (m - 1)) = (m - 1 : ℝ) / (2 * m - 1) := by
  sorry  -- (2m).choose 2 = m*(2m-1)

/-- It tends to `1/2`, and `1/2` is the ceiling: for non-prime-power `n` an
Oliver group has at least two u-orbitals partitioning the pairs, so the minimum
is at most half.  (The two-orbital fact is group theory and is not proved here;
the arithmetic consequence is.) -/
theorem half_is_ceiling (n m : ℕ) (hn : 2 ≤ n) (h : 2 * m ≤ n.choose 2) :
    Density n m ≤ 1 / 2 := by
  sorry

/-! ## 8. Assembly

The Theorem, with both unreachable inputs explicit. -/

/-- **Hypothesis (H)**, as a hypothesis.  Every sufficiently large `n` admits
`q, r, c` prime with the shape, region, efficiency and coprimality conditions. -/
structure HypH where
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
theorem theorem_arithmetic_half (H : HypH) :
    ∀ n ≥ max H.N 10, ∃ c r t : ℕ,
      ((RegionEven n c r ∧ delta0 ≤ Density n (mStarEven c r t)) ∨
       (RegionOdd n c r ∧ delta0 ≤ Density n (mStarOdd c r t))) := by
  sorry
  -- unpack H.witness, split on the two shapes, apply density_even / density_odd

end Note

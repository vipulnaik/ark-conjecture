/-
# `Sigma.lean` — the framework's specification Σ₀, and the window lemma with Σ as a parameter

`arithmetic-of-density.md` §3.5.3, "a specification and a quantifier", point 2: the arithmetic
half is one argument with the specification as a parameter.  Here:

* **Σ₀ as data** — `F0`, `d0` by n mod 12 (clauses 1 and 3), and `bhsw_agrees`: the (BH-SW)
  route's per-class (k, d) from `bcp-to-floor.md` is the same table (point 3), by `decide`.
* **The balance point, for any (F, η)** — `xstar`, and `balance`: both binding terms equal
  `capF F η` there.
* **The window lemma, for any (F, η, window)** — `target F η x₋ x₊ = min(F·x₋², η·(1 − F·x₊)²)`
  bounds the two terms on the window (`window`); it is ≤ cap and equals it on [x\*, x\*]
  (`target_le_cap`, `target_at_balance`); and `window_of_eps` shows clause 2's two readings
  correspond: the window x₋ = x\*·√(1 − ε), 1 − F·x₊ = (1 − F·x\*)·√(1 − ε) has target exactly
  (1 − ε)·cap.
* **Exact at a single n** — `pointwise`: at n = F·c + r with the share in the window, the intra
  term F·c(c − 1) and a foreign term η·r(r − 1) are each ≥ (target − κ/n)·n(n − 1).
* **Σ₀'s ceilings as instances** — `cap_table`: §3.3.5's cap column is `capF (F0 a) (2 / d0 a)`
  at every class.

Not yet here: the cross terms (c·r, within-class c²) as a per-specification side condition,
the foreign term's exact value orb(r, q) = (2/d)·C(r,2) at r = d·q + 1, and the assembly into
"`Hyp (witness Σ₀) L` ⇒ density ≥ δ₀ − O(1/n)" lifted through `BCG.Hyp.lift_large`.
-/
import BCG
import Basic

namespace Sigma
open Real

/-! ## Σ₀ as data, and the (BH-SW) cell comparison -/

/-- Σ₀'s fusion count by n mod 12 (`arithmetic-of-density.md` §3.5.3 clause 1). -/
def F0 : Fin 12 → ℕ := ![1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 4]

/-- Σ₀'s cofactor by n mod 12 (§3.5.3 clause 3). -/
def d0 : Fin 12 → ℕ := ![2, 2, 6, 4, 2, 6, 2, 4, 6, 2, 2, 6]

/-- The (BH-SW) route's per-class (k, d) (`bcp-to-floor.md`, the per-class grid). -/
def bhsw : Fin 12 → ℕ × ℕ :=
  ![(1, 2), (2, 2), (1, 6), (2, 4), (1, 2), (2, 6), (1, 2), (2, 4), (1, 6), (2, 2), (1, 2), (4, 6)]

/-- **The six-cell agreement** of §3.5.3, as a comparison of two tables. -/
theorem bhsw_agrees : ∀ a, (F0 a, d0 a) = bhsw a := by decide

/-! ## The balance point, for any (F, η) -/

/-- The balance point x\* = √η / (√F·(1 + √(Fη))), where F·x² = η·(1 − F·x)². -/
noncomputable def xstar (F : ℕ) (η : ℝ) : ℝ := √η / (√F * (1 + √(F * η)))

/-- **At the balance point both terms equal `capF F η`.** -/
theorem balance (F : ℕ) (η : ℝ) (hF : 0 < F) (hη : 0 ≤ η) :
    F * xstar F η ^ 2 = Ark.capF F η ∧ η * (1 - F * xstar F η) ^ 2 = Ark.capF F η := by
  have hFr : (0 : ℝ) < F := by exact_mod_cast hF
  have sF : √(F : ℝ) ^ 2 = F := sq_sqrt hFr.le
  have se : √η ^ 2 = η := sq_sqrt hη
  have sFe : √((F : ℝ) * η) = √F * √η := sqrt_mul hFr.le η
  have hsF : 0 < √(F : ℝ) := sqrt_pos.mpr hFr
  have hd : 0 < 1 + √(F : ℝ) * √η := by positivity
  unfold xstar Ark.capF
  rw [sFe]
  constructor
  · field_simp
    rw [sF, se]
  · have aux : ∀ u e : ℝ, 0 < u → 0 ≤ e →
        1 - u ^ 2 * (e / (u * (1 + u * e))) = 1 / (1 + u * e) := by
      intro u e hu he
      have : 0 < 1 + u * e := by positivity
      field_simp; ring
    have := aux (√F) (√η) hsF (sqrt_nonneg _)
    rw [sF] at this
    rw [this]; field_simp

/-! ## The window lemma, continuous form -/

/-- **Window lemma.** If the class share x lies in [x₋, x₊] (with F·x₊ ≤ 1), the two binding
terms are at least their values at the window's ends: F·x² ≥ F·x₋² and
η·(1 − F·x)² ≥ η·(1 − F·x₊)².  So the configuration's density is at least
`target F η x₋ x₊ = min(F·x₋², η·(1 − F·x₊)²)`, for every specification. -/
noncomputable def target (F : ℕ) (η xlo xhi : ℝ) : ℝ := min (F * xlo ^ 2) (η * (1 - F * xhi) ^ 2)

theorem window (F : ℕ) {η xlo xhi x : ℝ} (hη : 0 ≤ η) (h0 : 0 ≤ xlo) (hlo : xlo ≤ x)
    (hhi : x ≤ xhi) (hF1 : F * xhi ≤ 1) :
    target F η xlo xhi ≤ min (F * x ^ 2) (η * (1 - F * x) ^ 2) := by
  have hFr : (0 : ℝ) ≤ F := Nat.cast_nonneg F
  unfold target
  apply min_le_min
  · exact mul_le_mul_of_nonneg_left (pow_le_pow_left₀ h0 hlo 2) hFr
  · apply mul_le_mul_of_nonneg_left _ hη
    have : 0 ≤ 1 - F * xhi := by linarith
    exact pow_le_pow_left₀ this (by nlinarith) 2

/-- The target never exceeds the cap when the window contains the balance point. -/
theorem target_le_cap (F : ℕ) {η xlo xhi : ℝ} (hF : 0 < F) (hη : 0 ≤ η)
    (hlo : xlo ≤ xstar F η) (h0 : 0 ≤ xlo) :
    target F η xlo xhi ≤ Ark.capF F η := by
  have hFr : (0 : ℝ) ≤ F := Nat.cast_nonneg F
  unfold target
  refine le_trans (min_le_left _ _) ?_
  rw [← (balance F η hF hη).1]
  exact mul_le_mul_of_nonneg_left (pow_le_pow_left₀ h0 hlo 2) hFr

/-- And it equals the cap on the degenerate window [x\*, x\*]. -/
theorem target_at_balance (F : ℕ) {η : ℝ} (hF : 0 < F) (hη : 0 ≤ η) :
    target F η (xstar F η) (xstar F η) = Ark.capF F η := by
  unfold target; rw [(balance F η hF hη).1, (balance F η hF hη).2, min_self]

/-- **Clause 2's two forms correspond, for every (F, η).**  For 0 ≤ ε ≤ 1 the window
x₋ = x\*·√(1 − ε), 1 − F·x₊ = (1 − F·x\*)·√(1 − ε) contains x\* and has target exactly
(1 − ε)·cap.  So "c/n in a window around x\*" and "δ ≥ (1 − ε)·δ₀" are the same condition
read two ways, and the window form is the one that keeps the conclusion out of the hypothesis. -/
noncomputable def epsLo (F : ℕ) (η ε : ℝ) : ℝ := xstar F η * √(1 - ε)
noncomputable def epsHi (F : ℕ) (η ε : ℝ) : ℝ := (1 - (1 - F * xstar F η) * √(1 - ε)) / F

theorem window_of_eps (F : ℕ) {η ε : ℝ} (hF : 0 < F) (hη : 0 ≤ η) (hε : ε ≤ 1) :
    target F η (epsLo F η ε) (epsHi F η ε) = (1 - ε) * Ark.capF F η := by
  have hFr : (0 : ℝ) < F := by exact_mod_cast hF
  have hs : √(1 - ε) ^ 2 = 1 - ε := sq_sqrt (by linarith)
  obtain ⟨b1, b2⟩ := balance F η hF hη
  have e1 : (F : ℝ) * epsLo F η ε ^ 2 = (1 - ε) * Ark.capF F η := by
    unfold epsLo; rw [mul_pow, hs, ← b1]; ring
  have e2 : η * (1 - F * epsHi F η ε) ^ 2 = (1 - ε) * Ark.capF F η := by
    have : 1 - (F : ℝ) * epsHi F η ε = (1 - F * xstar F η) * √(1 - ε) := by
      unfold epsHi; field_simp; ring
    rw [this, mul_pow, hs, ← b2]; ring
  unfold target; rw [e1, e2, min_self]

/-! ## The window lemma, exact at a single n -/

/-- A term of size `w·a(a−1)` with a ≥ s·n ≥ 1 is at least `w·(s² − s/n)·n(n−1)`. -/
theorem term_lower {a n : ℕ} {s w : ℝ} (hw : 0 ≤ w) (hs : 1 ≤ s * n) (ha : s * n ≤ a) :
    w * (s ^ 2 - s / n) * (n * (n - 1)) ≤ w * (a * (a - 1)) := by
  have hn : (0 : ℝ) < n := by
    rcases Nat.eq_zero_or_pos n with h | h
    · subst h; simp at hs; linarith
    · exact_mod_cast h
  rw [mul_assoc]
  apply mul_le_mul_of_nonneg_left _ hw
  have hsp : 0 < s := by
    by_contra h; have h' : s ≤ 0 := not_lt.mp h; nlinarith
  have e : (s ^ 2 - s / n) * (n * (n - 1)) = (s * n) * (s * n - 1) - s * (s * n - 1) := by
    field_simp
  rw [e]
  have h1 : (s * n) * (s * n - 1) ≤ (a : ℝ) * (a - 1) := by nlinarith
  have h2 : 0 ≤ s * (s * n - 1) := by nlinarith
  linarith

/-- **The pointwise lemma for a two-term specification.**  At a single n = F·c + r with the
class share in the window, c ≥ x₋·n ≥ 1 and r ≥ (1 − F·x₊)·n ≥ 1, the class's intra term and
the foreign term (worth η·C(r,2)) are each at least `(target − κ/n)·C(n,2)` (doubled form),
with κ = max(F·x₋, η·(1 − F·x₊)).  One proof for every (F, η, window). -/
theorem pointwise (F c r n : ℕ) {η xlo xhi : ℝ} (hη : 0 ≤ η) (hn : n = F * c + r)
    (hlo : xlo * n ≤ c) (hhi : (c : ℝ) ≤ xhi * n) (hc1 : 1 ≤ xlo * n)
    (hr1 : 1 ≤ (1 - F * xhi) * n) :
    (F * xlo ^ 2 - F * xlo / n) * (n * (n - 1)) ≤ F * (c * (c - 1)) ∧
    (η * (1 - F * xhi) ^ 2 - η * (1 - F * xhi) / n) * (n * (n - 1)) ≤ η * (r * (r - 1)) := by
  have hFr : (0 : ℝ) ≤ F := Nat.cast_nonneg F
  constructor
  · have := term_lower (a := c) (n := n) (s := xlo) (w := F) hFr hc1 hlo
    have e : (F : ℝ) * xlo ^ 2 - F * xlo / n = F * (xlo ^ 2 - xlo / n) := by ring
    rw [e, ← mul_assoc]; linarith
  · have hrr : (1 - F * xhi) * n ≤ r := by
      have : (n : ℝ) = F * c + r := by exact_mod_cast hn
      nlinarith
    have := term_lower (a := r) (n := n) (s := 1 - F * xhi) (w := η) hη hr1 hrr
    have e : η * (1 - F * xhi) ^ 2 - η * (1 - F * xhi) / n =
        η * ((1 - F * xhi) ^ 2 - (1 - F * xhi) / n) := by ring
    rw [e, ← mul_assoc]; linarith

/-! ## Σ₀'s ceilings, as instances of `balance` -/

/-- Σ₀'s efficiency η = 2/d per class. -/
noncomputable def eta0 (a : Fin 12) : ℝ := 2 / d0 a

theorem cap11 : Ark.capF 1 1 = 1 / 4 := by unfold Ark.capF; norm_num
theorem cap13 : Ark.capF 1 (1/3) = (2 - √3) / 2 := by
  rw [Ark.capF_of_sqrt 1 (1/3) (√3 / 3) (by positivity) (by
        rw [div_pow, sq_sqrt (by norm_num : (0:ℝ) ≤ 3)]; push_cast; ring)]
  have h3 : √3 ^ 2 = 3 := sq_sqrt (by norm_num)
  have h3' : (0:ℝ) ≤ √3 := sqrt_nonneg 3
  field_simp
  nlinarith [h3, h3']
theorem cap21 : Ark.capF 2 1 = 3 - 2 * √2 := by
  rw [Ark.capF_of_sqrt 2 1 (√2) (sqrt_nonneg 2) (by
        rw [sq_sqrt (by norm_num : (0:ℝ) ≤ 2)]; push_cast; ring)]
  have h2 : √2 ^ 2 = 2 := sq_sqrt (by norm_num)
  have h2' : (0:ℝ) ≤ √2 := sqrt_nonneg 2
  field_simp
  nlinarith [h2, h2']
theorem cap22 : Ark.capF 2 (1/2) = 1 / 8 := by unfold Ark.capF; norm_num
theorem cap23 : Ark.capF 2 (1/3) = 5 - 2 * √6 := by
  rw [Ark.capF_of_sqrt 2 (1/3) (√6 / 3) (by positivity) (by
        rw [div_pow, sq_sqrt (by norm_num : (0:ℝ) ≤ 6)]; push_cast; ring)]
  have h6 : √6 ^ 2 = 6 := sq_sqrt (by norm_num)
  have h6' : (0:ℝ) ≤ √6 := sqrt_nonneg 6
  field_simp
  nlinarith [h6, h6']
theorem cap43 : Ark.capF 4 (1/3) = 7 - 4 * √3 := by
  rw [Ark.capF_of_sqrt 4 (1/3) (2 * √3 / 3) (by positivity) (by
        rw [div_pow, mul_pow, sq_sqrt (by norm_num : (0:ℝ) ≤ 3)]
        push_cast; ring)]
  have h3 : √3 ^ 2 = 3 := sq_sqrt (by norm_num)
  have h3' : (0:ℝ) ≤ √3 := sqrt_nonneg 3
  field_simp
  nlinarith [h3, h3']

/-- §3.3.5's cap column, by n mod 12. -/
noncomputable def capCol : Fin 12 → ℝ :=
  ![1/4, 3 - 2 * √2, (2 - √3) / 2, 1/8, 1/4, 5 - 2 * √6, 1/4, 1/8, (2 - √3) / 2,
    3 - 2 * √2, 1/4, 7 - 4 * √3]

/-- **Σ₀'s ceilings are the generic cap evaluated at its table** — §3.3.5's cap column is
`capF (F0 a) (2 / d0 a)`, and by `balance` it is the common value of both terms at the
balance point `xstar (F0 a) (2 / d0 a)`. -/
theorem cap_table : ∀ a, Ark.capF (F0 a) (eta0 a) = capCol a := by
  intro a
  fin_cases a <;> simp only [F0, d0, eta0, capCol] <;> norm_num <;>
    first | exact cap11 | exact cap13 | exact cap21 | exact cap22 | exact cap23 | exact cap43

end Sigma

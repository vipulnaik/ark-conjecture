/-
# `BCG.lean` — the hypothesis (BCG) as a specification and a quantifier

`arithmetic-of-density.md` §3.5.3 states (BCG) in two quantifier strengths, (BCG-AL) and
(BCG-AA), over the same four clauses.  This file separates the two ingredients so that every
conditional result is proved once:

* **the witness predicate** `W : ℕ → Prop` — what a specification demands at a single n
  (shape, window, efficiency, coherence).  Each specification is one such predicate; the
  note's fixed-window (BCG_{1/5}) is `noteWitness` below, and the framework's class-ceiling
  version will be another instance with its own table of (F, d, window);
* **the quantifier** — a filter `L` on ℕ: `Filter.atTop` for (AL), `almostAll` for (AA)
  (exceptional set O(x/(log x)^A) for every A).

`Hyp W L` is `∀ᶠ n in L, W n`.  A conditional result is proved **pointwise**, as
`∀ n, W n → P n`, and `Hyp.lift` carries it to any quantifier; `al_imp_aa` gives
(AL) ⇒ (AA) for every specification at once.  `almostAll_neBot` checks that (AA) is not vacuous.
-/
import Note

namespace BCG
open Filter Classical

/-- The exceptional set of `s` below x: the n ≤ x outside `s`. -/
noncomputable def exc (s : Set ℕ) (x : ℕ) : ℕ := ((Finset.range (x + 1)).filter (· ∉ s)).card

/-- The counting bound for one A: #(exceptions ≤ x) ≤ C·x/(log x)^A + C. (The additive C
only absorbs small x; x/(log x)^A → ∞.) -/
def ExcBound (s : Set ℕ) (A : ℕ) : Prop :=
  ∃ C : ℝ, ∀ x : ℕ, (exc s x : ℝ) ≤ C * ((x : ℝ) / Real.log x ^ A) + C

theorem exc_mono {s t : Set ℕ} (h : s ⊆ t) (x : ℕ) : exc t x ≤ exc s x := by
  unfold exc
  apply Finset.card_le_card
  intro y hy
  simp only [Finset.mem_filter] at hy ⊢
  exact ⟨hy.1, fun hs => hy.2 (h hs)⟩

theorem exc_inter (s t : Set ℕ) (x : ℕ) : exc (s ∩ t) x ≤ exc s x + exc t x := by
  unfold exc
  refine le_trans (Finset.card_le_card ?_) (Finset.card_union_le _ _)
  intro y hy
  simp only [Finset.mem_filter, Finset.mem_union, Set.mem_inter_iff, not_and_or] at hy ⊢
  tauto

theorem xlog_nonneg (x A : ℕ) : 0 ≤ (x : ℝ) / Real.log x ^ A := by
  rcases Nat.eq_zero_or_pos x with rfl | hx
  · simp
  · exact div_nonneg (by positivity) (pow_nonneg (Real.log_natCast_nonneg x) _)

/-- **(AA)'s quantifier**: the sets whose exceptional set is O(x/(log x)^A) for every A. -/
noncomputable def almostAll : Filter ℕ where
  sets := {s | ∀ A, ExcBound s A}
  univ_sets := fun A => ⟨0, fun x => by simp [exc]⟩
  sets_of_superset := fun {s t} hs hst A => by
    obtain ⟨C, hC⟩ := hs A
    exact ⟨C, fun x => le_trans (by exact_mod_cast exc_mono hst x) (hC x)⟩
  inter_sets := fun {s t} hs ht A => by
    obtain ⟨C1, h1⟩ := hs A
    obtain ⟨C2, h2⟩ := ht A
    refine ⟨C1 + C2, fun x => ?_⟩
    have := exc_inter s t x
    have e : ((exc (s ∩ t) x : ℕ) : ℝ) ≤ exc s x + exc t x := by exact_mod_cast this
    have := h1 x; have := h2 x
    nlinarith [xlog_nonneg x A]

/-- **(AL) ⇒ (AA)**, for every specification: a set containing all large n is almost all. -/
theorem atTop_le_almostAll : almostAll ≤ atTop := by
  intro s hs
  rw [mem_atTop_sets] at hs
  obtain ⟨N, hN⟩ := hs
  intro A
  refine ⟨N, fun x => ?_⟩
  have : exc s x ≤ N := by
    unfold exc
    refine le_trans (Finset.card_le_card ?_) (Finset.card_range N).le
    intro y hy
    simp only [Finset.mem_filter, Finset.mem_range] at hy ⊢
    by_contra h
    exact hy.2 (hN y (by omega))
  have h1 : (exc s x : ℝ) ≤ N := by exact_mod_cast this
  have := xlog_nonneg x A
  nlinarith [Nat.cast_nonneg (α := ℝ) N]

/-- **(AA) is not vacuous**: the empty set is not almost all (already at A = 1). -/
instance almostAll_neBot : NeBot almostAll := by
  rw [neBot_iff]
  intro h
  have hmem : (∅ : Set ℕ) ∈ almostAll := by rw [h]; exact mem_bot
  obtain ⟨C, hC⟩ := hmem 1
  set K : ℝ := max C 1 with hK
  have hK1 : 1 ≤ K := le_max_right _ _
  have hCK : C ≤ K := le_max_left _ _
  obtain ⟨x, hx⟩ : ∃ x : ℕ, Real.exp (2 * K) + 2 * K ≤ x := exists_nat_ge _
  have hexp : 0 < Real.exp (2 * K) := Real.exp_pos _
  have hxpos : (0 : ℝ) < x := by linarith
  have hlog : 2 * K ≤ Real.log x := by
    rw [← Real.log_exp (2 * K)]
    exact Real.log_le_log hexp (by linarith)
  have hlogpos : 0 < Real.log x := by linarith
  have hex : (exc ∅ x : ℝ) = x + 1 := by
    unfold exc; simp
  have h1 := hC x
  rw [hex, pow_one] at h1
  have h2 : C * ((x : ℝ) / Real.log x) ≤ K * ((x : ℝ) / Real.log x) :=
    mul_le_mul_of_nonneg_right hCK (div_nonneg hxpos.le hlogpos.le)
  have h3 : K * ((x : ℝ) / Real.log x) ≤ (x : ℝ) / 2 := by
    rw [mul_div_assoc', div_le_div_iff₀ hlogpos (by norm_num)]
    nlinarith
  linarith

/-- The hypothesis: specification `W`, quantifier `L`. -/
def Hyp (W : ℕ → Prop) (L : Filter ℕ) : Prop := ∀ᶠ n in L, W n

/-- **Lift a pointwise result** to any quantifier. -/
theorem Hyp.lift {W P : ℕ → Prop} {L : Filter ℕ} (h : ∀ n, W n → P n) (H : Hyp W L) :
    ∀ᶠ n in L, P n :=
  H.mono h

/-- A pointwise result that needs n large lifts too, on any quantifier below `atTop`
(both AL and AA). -/
theorem Hyp.lift_large {W P : ℕ → Prop} {L : Filter ℕ} (hL : L ≤ atTop) (N : ℕ)
    (h : ∀ n, N ≤ n → W n → P n) (H : Hyp W L) : ∀ᶠ n in L, P n := by
  have hN : ∀ᶠ n in L, N ≤ n := hL (eventually_ge_atTop N)
  filter_upwards [H, hN] with n hW hn using h n hn hW

theorem al_imp_aa {W : ℕ → Prop} (H : Hyp W atTop) : Hyp W almostAll :=
  atTop_le_almostAll H

/-! ## The note's specification, (BCG_{1/5}) -/

/-- The note's witness at a single n (the clauses of `Note.HypBCG`). -/
def noteWitness (n : ℕ) : Prop :=
  ∃ q r c t : ℕ, q.Prime ∧ r.Prime ∧ IsPrimePow c ∧
    (Note.RegionEven n c r ∨ Note.RegionOdd n c r) ∧
    Note.EfficiencyBound r t ∧ Nat.Coprime (c - 1) r

/-- `Note.HypBCG` is exactly the (AL) form of `noteWitness`. -/
theorem note_hyp_iff : Nonempty Note.HypBCG ↔ Hyp noteWitness atTop := by
  constructor
  · rintro ⟨H⟩
    exact eventually_atTop.mpr ⟨H.N, fun n hn => H.witness n hn⟩
  · intro h
    obtain ⟨N, hN⟩ := eventually_atTop.mp h
    exact ⟨⟨N, fun n hn => hN n hn⟩⟩

/-- The arithmetic half, **pointwise**: a witness at n ≥ 10 gives a configuration of density
≥ δ₀ at n.  (The body of `Note.theorem_arithmetic_half`, with the quantifier removed.) -/
theorem note_pointwise (n : ℕ) (hn : 10 ≤ n) (hW : noteWitness n) :
    ∃ c r t : ℕ,
      ((Note.RegionEven n c r ∧ Note.delta0 ≤ Note.Density n (Note.mStarEven c r t)) ∨
       (Note.RegionOdd n c r ∧ Note.delta0 ≤ Note.Density n (Note.mStarOdd c r t))) := by
  obtain ⟨q, r, c, t, _hq, _hr, _hc, hshape, heff, _hcop⟩ := hW
  refine ⟨c, r, t, ?_⟩
  rcases hshape with hev | hod
  · exact Or.inl ⟨hev, Note.density_even n c r t hn (by omega) hev heff⟩
  · exact Or.inr ⟨hod, Note.density_odd n c r t hn (by omega) hod heff⟩

/-- **The arithmetic half under either quantifier**: one proof, lifted.  With `L = atTop`
this is `Note.theorem_arithmetic_half`; with `L = almostAll` it is the (AA) version. -/
theorem note_arithmetic_half {L : Filter ℕ} (hL : L ≤ atTop) (H : Hyp noteWitness L) :
    ∀ᶠ n in L, ∃ c r t : ℕ,
      ((Note.RegionEven n c r ∧ Note.delta0 ≤ Note.Density n (Note.mStarEven c r t)) ∨
       (Note.RegionOdd n c r ∧ Note.delta0 ≤ Note.Density n (Note.mStarOdd c r t))) :=
  H.lift_large hL 10 note_pointwise

example (H : Hyp noteWitness atTop) := note_arithmetic_half le_rfl H
example (H : Hyp noteWitness almostAll) := note_arithmetic_half atTop_le_almostAll H

end BCG

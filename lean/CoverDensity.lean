/-
# `CoverDensity.lean` — the covering statement with its escapes counted

`Cover.lean` keeps two escapes as disjuncts: n = F·c with no foreign part (F ≤ 25), and n prime.
Here they are counted: there are O(x/log x) of them up to x (`esc_count`, from Chebyshev's bound
on π(x) in Mathlib).  So a floor holding for all large n, or for almost all n in (AA)'s sense,
forces a system **with a foreign part** outside O(x/log x) exceptions (`cover_foreign`).

The rate is the escapes' own: x/log x is the size of the primes, so the conclusion cannot be had
at (AA)'s O(x/(log x)^A) for A ≥ 2 by this route.
-/
import Cover
import Mathlib.NumberTheory.Chebyshev

namespace CoverDensity
open Cover BCG Filter Real Finset
open scoped Classical

/-- The escapes of `ShapeD`: n prime, or n = F·p^b with F ≤ 25. -/
def Escape (n : ℕ) : Prop :=
  n.Prime ∨ ∃ F p b, 1 ≤ F ∧ F ≤ 25 ∧ p.Prime ∧ 1 ≤ b ∧ n = F * p ^ b

/-- The systems of `ShapeD` with a foreign part. -/
def ShapeFr (δ : ℝ) (Fmax n : ℕ) : Prop :=
  (∃ F p b r, 1 ≤ F ∧ F ≤ Fmax ∧ p.Prime ∧ 1 ≤ b ∧ r.Prime ∧ r ≠ p ∧ n = F * p ^ b + r) ∨
  (δ ≤ 1 / 9 ∧ ∃ r₁ r₂, r₁.Prime ∧ r₂.Prime ∧ r₁ ≠ r₂ ∧ n = r₁ + r₂) ∨
  (δ ≤ 1 / 16 ∧ ∃ F p b r₁ r₂, 1 ≤ F ∧ F ≤ Fmax ∧ p.Prime ∧ 1 ≤ b ∧ r₁.Prime ∧ r₂.Prime ∧
    r₁ ≠ p ∧ r₂ ≠ p ∧ r₁ ≠ r₂ ∧ n = F * p ^ b + r₁ + r₂)

theorem shapeD_split {δ : ℝ} {Fmax n : ℕ} (h : ShapeD δ Fmax n) : Escape n ∨ ShapeFr δ Fmax n := by
  rcases h with h | h | h | h | h
  · exact Or.inl (Or.inr h)
  · exact Or.inl (Or.inl h)
  · exact Or.inr (Or.inl h)
  · exact Or.inr (Or.inr (Or.inl h))
  · exact Or.inr (Or.inr (Or.inr h))

/-! ## Counting prime powers -/

/-- Prime powers p^b (b ≥ 1) up to x. -/
noncomputable def ppSet (x : ℕ) : Finset ℕ :=
  (range (x + 1)).filter (fun m => ∃ p b, p.Prime ∧ 1 ≤ b ∧ m = p ^ b)

theorem pp_card (x : ℕ) :
    #(ppSet x) ≤ Nat.primeCounting x + (Nat.sqrt x + 1) * (Nat.log 2 x + 1) := by
  have hsub : ppSet x ⊆ Nat.primesLE x ∪
      ((range (Nat.sqrt x + 1)) ×ˢ (range (Nat.log 2 x + 1))).image (fun pb => pb.1 ^ pb.2) := by
    intro m hm
    simp only [ppSet, mem_filter, mem_range] at hm
    obtain ⟨hmx, p, b, hp, hb, rfl⟩ := hm
    rcases Nat.lt_or_ge b 2 with h | h
    · have : b = 1 := by omega
      subst this
      apply mem_union_left
      rw [Nat.mem_primesLE, pow_one]; simp only [pow_one] at hmx; exact ⟨by omega, hp⟩
    · apply mem_union_right
      rw [mem_image]
      refine ⟨(p, b), ?_, rfl⟩
      simp only [mem_product, mem_range]
      constructor
      · have : p ^ 2 ≤ x := le_trans (Nat.pow_le_pow_right hp.pos h) (by omega)
        have := Nat.le_sqrt'.mpr this; omega
      · have : 2 ^ b ≤ x := le_trans (Nat.pow_le_pow_left hp.two_le b) (by omega)
        have := Nat.le_log_of_pow_le (by norm_num) this; omega
  calc #(ppSet x) ≤ #(Nat.primesLE x ∪ _) := card_le_card hsub
    _ ≤ #(Nat.primesLE x) + #(((range (Nat.sqrt x + 1)) ×ˢ (range (Nat.log 2 x + 1))).image
          (fun pb => pb.1 ^ pb.2)) := card_union_le _ _
    _ ≤ Nat.primeCounting x + (Nat.sqrt x + 1) * (Nat.log 2 x + 1) := by
        rw [Nat.primesLE_card_eq_primeCounting]
        gcongr
        exact le_trans card_image_le (by simp)

/-- The escapes up to x number at most 26 times the prime powers. -/
theorem esc_card (x : ℕ) : #((range (x + 1)).filter Escape) ≤ 26 * #(ppSet x) := by
  have hsub : (range (x + 1)).filter Escape ⊆ ppSet x ∪ (Icc 1 25).biUnion (fun F =>
      (ppSet x).image (fun m => F * m) ∩ range (x + 1)) := by
    intro n hn
    simp only [mem_filter, mem_range] at hn
    obtain ⟨hnx, h | ⟨F, p, b, hF1, hF25, hp, hb, rfl⟩⟩ := hn
    · apply mem_union_left
      simp only [ppSet, mem_filter, mem_range]
      exact ⟨hnx, n, 1, h, le_refl _, by simp⟩
    · apply mem_union_right
      simp only [mem_biUnion, mem_Icc, mem_inter, mem_image, mem_range]
      refine ⟨F, ⟨hF1, hF25⟩, ⟨p ^ b, ?_, rfl⟩, hnx⟩
      simp only [ppSet, mem_filter, mem_range]
      refine ⟨?_, p, b, hp, hb, rfl⟩
      have : p ^ b ≤ F * p ^ b := Nat.le_mul_of_pos_left _ (by omega)
      omega
  calc #((range (x + 1)).filter Escape) ≤ #(ppSet x ∪ _) := card_le_card hsub
    _ ≤ #(ppSet x) + #((Icc 1 25).biUnion (fun F =>
          (ppSet x).image (fun m => F * m) ∩ range (x + 1))) := card_union_le _ _
    _ ≤ #(ppSet x) + ∑ F ∈ Icc 1 25, #((ppSet x).image (fun m => F * m) ∩ range (x + 1)) := by
        gcongr; exact card_biUnion_le
    _ ≤ #(ppSet x) + ∑ F ∈ Icc 1 25, #(ppSet x) := by
        apply Nat.add_le_add_left
        apply Finset.sum_le_sum
        intro F _
        exact le_trans (card_le_card inter_subset_left) card_image_le
    _ = 26 * #(ppSet x) := by simp; ring

/-! ## The analytic bound -/

/-- For real x ≥ 2: √x and (√x + 1)(log₂ x + 1) are O(x/log x), with explicit constants. -/
theorem small_terms {x : ℝ} (hx : 2 ≤ x) :
    (√x + 1) * (log x / log 2 + 1) ≤ 72 * (x / log x) := by
  set u := √(√x) with hu
  have hx0 : 0 < x := by linarith
  have hsx : √x = u ^ 2 := by rw [hu, sq_sqrt (sqrt_nonneg _)]
  have hxu : x = u ^ 4 := by
    rw [show u ^ 4 = (u ^ 2) ^ 2 by ring, ← hsx, sq_sqrt hx0.le]
  have hu1 : 1 ≤ u := by
    rw [hu]; apply Real.one_le_sqrt.mpr; apply Real.one_le_sqrt.mpr; linarith
  have hlog : log x = 4 * log u := by rw [hxu, Real.log_pow]; push_cast; ring
  have hlu : log u ≤ u - 1 := Real.log_le_sub_one_of_pos (by linarith)
  have hlx0 : 0 < log x := Real.log_pos (by linarith)
  have hlxu : log x ≤ 4 * u := by rw [hlog]; linarith
  have hl2 : (1 / 2 : ℝ) < log 2 := by have := Real.log_two_gt_d9; linarith
  have hb : log x / log 2 ≤ 2 * log x := by
    rw [div_le_iff₀ (by linarith)]; nlinarith
  rw [← mul_div_assoc, le_div_iff₀ hlx0, hsx]
  -- (u² + 1)(2 log x + 1)·log x ≤ (2u²)(9u)(4u) = 72 u⁴
  have e1 : (u ^ 2 + 1) * (log x / log 2 + 1) * log x ≤ (2 * u ^ 2) * (8 * u + 1) * (4 * u) := by
    have h1 : u ^ 2 + 1 ≤ 2 * u ^ 2 := by nlinarith
    have h2 : log x / log 2 + 1 ≤ 8 * u + 1 := by linarith
    have h0 : 0 ≤ log x / log 2 + 1 := by positivity
    calc (u ^ 2 + 1) * (log x / log 2 + 1) * log x
        ≤ (2 * u ^ 2) * (8 * u + 1) * log x := by gcongr
      _ ≤ (2 * u ^ 2) * (8 * u + 1) * (4 * u) := by gcongr
  have : 2 * u ^ 2 * (8 * u + 1) * (4 * u) ≤ 72 * x := by
    rw [hxu]; nlinarith [pow_le_pow_right₀ hu1 (show 3 ≤ 4 by norm_num)]
  linarith

theorem sqrt_term {x : ℝ} (hx : 2 ≤ x) : √x ≤ 72 * (x / log x) := by
  have := small_terms hx
  have h0 : 0 ≤ √x := sqrt_nonneg _
  have h1 : 0 ≤ log x / log 2 := div_nonneg (Real.log_nonneg (by linarith)) (Real.log_nonneg (by norm_num))
  nlinarith

/-- **The escapes are O(x/log x).** -/
theorem esc_count : ∃ C : ℝ, ∀ x : ℕ,
    (#((range (x + 1)).filter Escape) : ℝ) ≤ C * ((x : ℝ) / log x) + C := by
  refine ⟨26 * (2 * log 4 + 144) + 52, fun x => ?_⟩
  have hC : 0 ≤ (26 * (2 * log 4 + 144) + 52 : ℝ) := by
    have : 0 ≤ log (4 : ℝ) := Real.log_nonneg (by norm_num)
    linarith
  have hxl : 0 ≤ (x : ℝ) / log x := div_nonneg (by positivity) (Real.log_natCast_nonneg x)
  have hE := esc_card x
  have hP := pp_card x
  rcases Nat.lt_or_ge x 2 with hx | hx
  · -- x ≤ 1: the filter lies in {0, 1}
    have : #((range (x + 1)).filter Escape) ≤ 2 :=
      le_trans (card_filter_le _ _) (by simp; omega)
    have : (#((range (x + 1)).filter Escape) : ℝ) ≤ 2 := by exact_mod_cast this
    have h4 : 0 ≤ log (4 : ℝ) := Real.log_nonneg (by norm_num)
    have := mul_nonneg hC hxl
    linarith
  have xR : (2 : ℝ) ≤ x := by exact_mod_cast hx
  -- π(x) ≤ log 4·x / log √x + √x = 2 log 4 · x/log x + √x
  have hpi := Chebyshev.pi_le_log4_mul_div (x := (x : ℝ)) (by linarith)
  rw [Nat.floor_natCast] at hpi
  have hlx0 : 0 < log (x : ℝ) := Real.log_pos (by linarith)
  have hls : log √(x : ℝ) = log x / 2 := by
    rw [Real.log_sqrt (by positivity)]
  rw [hls] at hpi
  have hpi' : (Nat.primeCounting x : ℝ) ≤ 2 * log 4 * ((x : ℝ) / log x) + 72 * ((x : ℝ) / log x) := by
    have e : log 4 * (x : ℝ) / (log x / 2) = 2 * log 4 * ((x : ℝ) / log x) := by
      field_simp
    have := sqrt_term xR
    linarith
  -- (Nat.sqrt x + 1)(Nat.log 2 x + 1) ≤ (√x + 1)(log x / log 2 + 1)
  have hsq : (Nat.sqrt x : ℝ) ≤ √(x : ℝ) := by
    rw [Real.le_sqrt (by positivity) (by positivity)]
    exact_mod_cast Nat.sqrt_le' x
  have hlg : (Nat.log 2 x : ℝ) ≤ log x / log 2 := by
    have := Real.natLog_le_logb x 2
    simpa [Real.logb] using this
  have hprod : ((Nat.sqrt x + 1) * (Nat.log 2 x + 1) : ℝ) ≤ 72 * ((x : ℝ) / log x) := by
    refine le_trans ?_ (small_terms xR)
    have : (0 : ℝ) ≤ Nat.log 2 x + 1 := by positivity
    gcongr
  have hEr : (#((range (x + 1)).filter Escape) : ℝ) ≤ 26 * (#(ppSet x) : ℝ) := by
    exact_mod_cast hE
  have hPr : (#(ppSet x) : ℝ) ≤ Nat.primeCounting x + (Nat.sqrt x + 1) * (Nat.log 2 x + 1) := by
    exact_mod_cast hP
  nlinarith

/-! ## The covering statement with a foreign part -/

/-- Filters whose sets have O(x/log x) exceptions: `atTop` and `almostAll` (A = 1). -/
def Rate1 (L : Filter ℕ) : Prop := ∀ s ∈ L, ExcBound s 1

theorem rate1_almostAll : Rate1 almostAll := fun _ hs => hs 1

theorem rate1_atTop : Rate1 atTop := fun s hs => by
  rw [mem_atTop_sets] at hs
  obtain ⟨N, hN⟩ := hs
  refine ⟨N + 1, fun x => ?_⟩
  have : exc s x ≤ N := by
    unfold exc
    calc #((range (x + 1)).filter (· ∉ s)) ≤ #(range N) := by
          apply card_le_card
          intro y hy
          simp only [mem_filter, mem_range] at hy ⊢
          by_contra h; exact hy.2 (hN y (by omega))
      _ = N := card_range N
  have h1 : (exc s x : ℝ) ≤ N := by exact_mod_cast this
  have h2 : 0 ≤ ((x : ℝ) / log x ^ 1) := by simpa using div_nonneg (Nat.cast_nonneg x) (Real.log_natCast_nonneg x)
  nlinarith

/-- **The covering statement, with a foreign part.**  If a SAFE floor δ > 1/25 holds L-eventually,
for L = `atTop` or `almostAll` (any `Rate1` filter below `atTop`), then outside O(x/log x)
exceptions n realises a system with a foreign part, with F ≤ min 15 Fmax — given
cap_{Fmax+1}(1) < δ, as in `cover_hyp`. -/
theorem cover_foreign {L : Filter ℕ} (hL : L ≤ atTop) (hR : Rate1 L) {δ : ℝ} (hδ : 1 / 25 < δ)
    (Fmax : ℕ) (hcap : 1 < √δ * (1 + √((Fmax + 1 : ℕ) : ℝ))) (H : BCG.Hyp (Floor δ) L) :
    ExcBound {n | ShapeFr δ (min 15 Fmax) n} 1 := by
  have hS := cover_hyp hL hδ Fmax hcap H
  obtain ⟨C1, h1⟩ := hR _ hS
  obtain ⟨C2, h2⟩ := esc_count
  refine ⟨C1 + C2, fun x => ?_⟩
  have hsub : (range (x + 1)).filter (· ∉ {n | ShapeFr δ (min 15 Fmax) n}) ⊆
      (range (x + 1)).filter (· ∉ {n | ShapeD δ (min 15 Fmax) n}) ∪
        (range (x + 1)).filter Escape := by
    intro n hn
    simp only [mem_filter, mem_range, Set.mem_ofPred_eq, mem_union] at hn ⊢
    by_cases hD : ShapeD δ (min 15 Fmax) n
    · rcases shapeD_split hD with h | h
      · exact Or.inr ⟨hn.1, h⟩
      · exact absurd h hn.2
    · exact Or.inl ⟨hn.1, hD⟩
  have hc : exc {n | ShapeFr δ (min 15 Fmax) n} x ≤
      exc {n | ShapeD δ (min 15 Fmax) n} x + #((range (x + 1)).filter Escape) := by
    unfold exc; exact le_trans (card_le_card hsub) (card_union_le _ _)
  have hc' : (exc {n | ShapeFr δ (min 15 Fmax) n} x : ℝ) ≤
      exc {n | ShapeD δ (min 15 Fmax) n} x + #((range (x + 1)).filter Escape) := by
    exact_mod_cast hc
  have := h1 x
  have := h2 x
  simp only [pow_one] at *
  linarith

end CoverDensity

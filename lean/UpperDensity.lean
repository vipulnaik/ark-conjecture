/-
# `UpperDensity.lean` — E's first clause is O(x/log x)

`Upper.Utyp_even` and `Upper.Utyp_odd` exclude the exceptional set E.  Its first clause — a
prime-power divisor a of n with (a − 1)/(n − 1) ≥ δ — forces n = F·a with F ≤ 5 once δ ≥ 1/6,
which covers both 1/4 and 3 − 2√2.  So it lies inside `CoverDensity.Escape` and has O(x/log x)
members up to x (`E1_count`).  The second clause, at odd n, is n = 2^j + m with m a prime power
and m ≤ 2^(j+2) (`E2_odd_sub`); summing the prime-power counts over j (`geom_sum`) gives
O(x/log x) too (`E2_count`).  So E is O(x/log x), as §6.3 claims.

**`ceiling_density`**: given Step 2 (orbits, blocks) and Step 5 as named hypotheses at every
degree, μ\*_N^fpf(n) < δ_cyc(n)·C(n,2) (`Ceiling n`) for all n outside O(x/log x) exceptions.
-/
import Upper
import CoverDensity
import BCG

namespace UpperDensity
open Upper CoverDensity Finset
open scoped Classical

theorem E1_escape {δ : ℝ} (hδ : 1 / 6 ≤ δ) {n : ℕ} (h : E1 δ n) : Escape n := by
  obtain ⟨a, hpp, ⟨F, rfl⟩, hlt, hle⟩ := h
  obtain ⟨p, b, hp, hb, rfl⟩ := (isPrimePow_nat_iff _).mp hpp
  have ha2 : 2 ≤ p ^ b := le_trans hp.two_le (Nat.le_self_pow (by omega) _)
  have hF1 : 1 ≤ F := by
    rcases Nat.eq_zero_or_pos F with h0 | h0
    · subst h0; simp at hlt
    · exact h0
  refine Or.inr ⟨F, p, b, hF1, ?_, hp, hb, by ring⟩
  by_contra hc; push Not at hc
  have aR : (2 : ℝ) ≤ (p ^ b : ℕ) := by exact_mod_cast ha2
  have FR : (6 : ℝ) ≤ F := by exact_mod_cast (show 6 ≤ F by omega)
  push_cast at hle aR
  set A : ℝ := (p : ℝ) ^ b
  have h0 : (0 : ℝ) ≤ A * F - 1 := by nlinarith
  have := mul_le_mul_of_nonneg_right hδ h0
  nlinarith

/-- **E's first clause is O(x/log x)**, for every δ ≥ 1/6. -/
theorem E1_count {δ : ℝ} (hδ : 1 / 6 ≤ δ) : ∃ C : ℝ, ∀ x : ℕ,
    (#((range (x + 1)).filter (E1 δ)) : ℝ) ≤ C * ((x : ℝ) / Real.log x) + C := by
  obtain ⟨C, hC⟩ := esc_count
  refine ⟨C, fun x => le_trans ?_ (hC x)⟩
  have : (range (x + 1)).filter (E1 δ) ⊆ (range (x + 1)).filter Escape := by
    intro n hn
    simp only [mem_filter] at hn ⊢
    exact ⟨hn.1, E1_escape hδ hn.2⟩
  exact_mod_cast card_le_card this

theorem quarter_ge : (1 : ℝ) / 6 ≤ 1 / 4 := by norm_num

theorem silver_ge : (1 : ℝ) / 6 ≤ 3 - 2 * Real.sqrt 2 := by
  have : Real.sqrt 2 < 1.415 := by rw [Real.sqrt_lt' (by norm_num)]; norm_num
  linarith

/-! ## E's second clause at odd n is O(x/log x) -/

/-- An even prime power is a power of 2. -/
theorem even_pp {a : ℕ} (h : IsPrimePow a) (he : a % 2 = 0) : ∃ j, a = 2 ^ j := by
  obtain ⟨p, k, hp, hk, rfl⟩ := (isPrimePow_nat_iff _).mp h
  have : 2 ∣ p ^ k := Nat.dvd_of_mod_eq_zero he
  have h2 : 2 ∣ p := (Nat.prime_two.dvd_of_dvd_pow this)
  have : p = 2 := ((Nat.prime_dvd_prime_iff_eq Nat.prime_two hp).mp h2).symm
  exact ⟨k, by rw [this]⟩

theorem pp_ppSet {m y : ℕ} (h : IsPrimePow m) (hy : m ≤ y) : m ∈ ppSet y := by
  obtain ⟨p, k, hp, hk, rfl⟩ := (isPrimePow_nat_iff _).mp h
  simp only [ppSet, mem_filter, mem_range]
  exact ⟨by omega, p, k, hp, hk, rfl⟩

/-- The odd members of E's second clause are 2^j + m with m a prime power, m ≤ 2^(j+2). -/
theorem E2_odd_sub {δ : ℝ} (hδ : 1 / 6 ≤ δ) (x : ℕ) :
    (range (x + 1)).filter (fun n => n % 2 = 1 ∧ E2 δ n) ⊆
      (range (Nat.log 2 x + 1)).biUnion (fun j => (ppSet (2 ^ (j + 2))).image (fun m => 2 ^ j + m)) := by
  intro n hn
  simp only [mem_filter, mem_range] at hn
  obtain ⟨hnx, hodd, a, c, ha, hc, hac, h1, h2⟩ := hn
  -- the even one is 2^j; the other is at most four times it
  have key : ∀ u v : ℕ, IsPrimePow u → IsPrimePow v → u + v = n → u % 2 = 0 →
      δ * ((n : ℝ) * (n - 1)) < u * ((u : ℝ) - 1) →
      n ∈ (range (Nat.log 2 x + 1)).biUnion (fun j => (ppSet (2 ^ (j + 2))).image (fun m => 2 ^ j + m)) := by
    intro u v hu hv huv hue hwin
    obtain ⟨j, rfl⟩ := even_pp hu hue
    have hj : j ≤ Nat.log 2 x := Nat.le_log_of_pow_le (by norm_num) (by omega)
    refine mem_biUnion.mpr ⟨j, mem_range.mpr (by omega), mem_image.mpr ⟨v, pp_ppSet hv ?_, huv⟩⟩
    by_contra hc4; push Not at hc4
    have hpow : 2 ^ (j + 2) = 4 * 2 ^ j := by ring
    rw [hpow] at hc4
    push_cast at hwin
    have hA : (1 : ℝ) ≤ (2 : ℝ) ^ j := one_le_pow₀ (by norm_num)
    have hnA : (5 : ℝ) * (2 : ℝ) ^ j < n := by
      have : 5 * 2 ^ j < n := by omega
      exact_mod_cast this
    have hn0 : (0 : ℝ) ≤ (n : ℝ) * (n - 1) := by nlinarith
    have : (1 / 6 : ℝ) * ((n : ℝ) * (n - 1)) ≤ δ * ((n : ℝ) * (n - 1)) := mul_le_mul_of_nonneg_right hδ hn0
    nlinarith
  rcases Nat.mod_two_eq_zero_or_one a with hae | hao
  · exact key a c ha hc hac hae h1
  · have hce : c % 2 = 0 := by omega
    exact key c a hc ha (by omega) hce h2

theorem geom_sum (J : ℕ) : ∑ j ∈ range (J + 1), (2 : ℝ) ^ j / (j + 2) ≤ 4 * 2 ^ J / (J + 2) := by
  induction J with
  | zero => norm_num
  | succ J ih =>
    rw [sum_range_succ]
    have h1 : (4 : ℝ) * 2 ^ J / (J + 2) + 2 ^ (J + 1) / ((J + 1 : ℕ) + 2) ≤
        4 * 2 ^ (J + 1) / ((J + 1 : ℕ) + 2) := by
      push_cast
      rw [div_add_div _ _ (by positivity) (by positivity), div_le_div_iff₀ (by positivity) (by positivity)]
      have : (0 : ℝ) ≤ 2 ^ J := by positivity
      ring_nf; nlinarith
    push_cast at h1 ⊢
    linarith

/-- **E's second clause at odd n is O(x/log x)**, for every δ ≥ 1/6. -/
theorem E2_count {δ : ℝ} (hδ : 1 / 6 ≤ δ) : ∃ C : ℝ, ∀ x : ℕ,
    (#((range (x + 1)).filter (fun n => n % 2 = 1 ∧ E2 δ n)) : ℝ) ≤
      C * ((x : ℝ) / Real.log x) + C := by
  obtain ⟨K, hK⟩ := esc_count
  have hK0 : 0 ≤ K := by
    have h := hK 0
    simp only [Nat.cast_zero, zero_div, mul_zero, zero_add] at h
    exact le_trans (Nat.cast_nonneg _) h
  have hpp : ∀ y : ℕ, (#(ppSet y) : ℝ) ≤ K * ((y : ℝ) / Real.log y) + K := by
    intro y
    refine le_trans ?_ (hK y)
    have : ppSet y ⊆ (range (y + 1)).filter Escape := by
      intro m hm
      simp only [ppSet, mem_filter, mem_range] at hm ⊢
      obtain ⟨hmy, p, k, hp, hk, rfl⟩ := hm
      exact ⟨hmy, Or.inr ⟨1, p, k, le_refl _, by norm_num, hp, hk, by ring⟩⟩
    exact_mod_cast card_le_card this
  have hl2 : (0.69 : ℝ) < Real.log 2 := by have := Real.log_two_gt_d9; linarith
  refine ⟨K * 32 + 8 * K + 2, fun x => ?_⟩
  have hcount := card_le_card (E2_odd_sub hδ x)
  have hcount' : (#((range (x + 1)).filter (fun n => n % 2 = 1 ∧ E2 δ n)) : ℝ) ≤
      ∑ j ∈ range (Nat.log 2 x + 1), (#(ppSet (2 ^ (j + 2))) : ℝ) := by
    have := le_trans hcount card_biUnion_le
    have h2 : ∑ j ∈ range (Nat.log 2 x + 1), #((ppSet (2 ^ (j + 2))).image (fun m => 2 ^ j + m)) ≤
        ∑ j ∈ range (Nat.log 2 x + 1), #(ppSet (2 ^ (j + 2))) :=
      sum_le_sum (fun j _ => card_image_le)
    exact_mod_cast le_trans this h2
  have hxl : 0 ≤ (x : ℝ) / Real.log x := div_nonneg (by positivity) (Real.log_natCast_nonneg x)
  rcases Nat.lt_or_ge x 2 with hx | hx
  · have : #((range (x + 1)).filter (fun n => n % 2 = 1 ∧ E2 δ n)) ≤ 2 :=
      le_trans (card_filter_le _ _) (by simp; omega)
    have : (#((range (x + 1)).filter (fun n => n % 2 = 1 ∧ E2 δ n)) : ℝ) ≤ 2 := by exact_mod_cast this
    have := mul_nonneg (by linarith : (0 : ℝ) ≤ K * 32 + 8 * K + 2) hxl
    linarith
  set J := Nat.log 2 x
  have xR : (2 : ℝ) ≤ x := by exact_mod_cast hx
  have hlx : 0 < Real.log x := Real.log_pos (by linarith)
  -- each term: #pp(2^(j+2)) ≤ K·2^(j+2)/((j+2) log 2) + K
  have hterm : ∀ j : ℕ, (#(ppSet (2 ^ (j + 2))) : ℝ) ≤
      K * (4 / Real.log 2) * ((2 : ℝ) ^ j / (j + 2)) + K := by
    intro j
    refine le_trans (hpp _) ?_
    have hlog : Real.log (((2 ^ (j + 2) : ℕ) : ℝ)) = (j + 2) * Real.log 2 := by
      push_cast; rw [Real.log_pow]; push_cast; ring
    rw [hlog]
    have e : (((2 ^ (j + 2) : ℕ) : ℝ)) / ((j + 2) * Real.log 2) =
        (4 / Real.log 2) * ((2 : ℝ) ^ j / (j + 2)) := by
      push_cast; field_simp; ring
    rw [e]; nlinarith
  have hsum : ∑ j ∈ range (J + 1), (#(ppSet (2 ^ (j + 2))) : ℝ) ≤
      K * (4 / Real.log 2) * (4 * 2 ^ J / (J + 2)) + K * (J + 1) := by
    calc ∑ j ∈ range (J + 1), (#(ppSet (2 ^ (j + 2))) : ℝ)
        ≤ ∑ j ∈ range (J + 1), (K * (4 / Real.log 2) * ((2 : ℝ) ^ j / (j + 2)) + K) :=
          sum_le_sum (fun j _ => hterm j)
      _ = K * (4 / Real.log 2) * ∑ j ∈ range (J + 1), ((2 : ℝ) ^ j / (j + 2)) + K * (J + 1) := by
          rw [sum_add_distrib, ← mul_sum]; simp; ring
      _ ≤ _ := by
          have := geom_sum J
          have : 0 ≤ K * (4 / Real.log 2) := by positivity
          nlinarith
  -- 2^J ≤ x and (J + 2)·log 2 ≥ log x
  have h2J : (2 : ℝ) ^ J ≤ x := by exact_mod_cast Nat.pow_log_le_self 2 (by omega)
  have hJlog : Real.log x ≤ (J + 2) * Real.log 2 := by
    have : x < 2 ^ (J + 1) := Nat.lt_pow_succ_log_self (by norm_num) x
    have : (x : ℝ) < 2 ^ (J + 1) := by exact_mod_cast this
    have := Real.log_lt_log (by linarith) this
    rw [Real.log_pow] at this; push_cast at this; nlinarith
  have hmain : (4 / Real.log 2) * (4 * 2 ^ J / (J + 2)) ≤ 16 * ((x : ℝ) / Real.log x) := by
    rw [div_mul_div_comm, div_le_iff₀ (by positivity)]
    rw [show 16 * ((x : ℝ) / Real.log x) * (Real.log 2 * (J + 2)) =
      16 * x * (((J + 2) * Real.log 2) / Real.log x) by field_simp]
    have : 1 ≤ ((J + 2) * Real.log 2) / Real.log x := by rw [le_div_iff₀ hlx]; linarith
    nlinarith
  -- J + 1 ≤ log x / log 2 + 1 ≤ 4·x/log x + 2
  have hJ : (J : ℝ) + 1 ≤ 8 * ((x : ℝ) / Real.log x) + 2 := by
    have hJx : (J : ℝ) * Real.log 2 ≤ Real.log x := by
      have := Real.log_le_log (by positivity) h2J
      rw [Real.log_pow] at this; exact this
    have hsq : Real.log x ≤ 2 * Real.sqrt x := by
      have := Real.log_le_sub_one_of_pos (Real.sqrt_pos.mpr (show (0 : ℝ) < x by linarith))
      rw [Real.log_sqrt (by positivity)] at this; linarith
    have hl2x : Real.log x * Real.log x ≤ 4 * x := by
      have : Real.sqrt x * Real.sqrt x = x := Real.mul_self_sqrt (by positivity)
      have h0 : 0 ≤ Real.log x := hlx.le
      nlinarith
    have : Real.log x ≤ 4 * ((x : ℝ) / Real.log x) := by
      rw [mul_div_assoc', le_div_iff₀ hlx]; nlinarith
    have : (J : ℝ) ≤ Real.log x / Real.log 2 := by rw [le_div_iff₀ (by linarith)]; linarith
    have : Real.log x / Real.log 2 ≤ 2 * Real.log x := by
      rw [div_le_iff₀ (by linarith)]; nlinarith
    linarith
  calc (#((range (x + 1)).filter (fun n => n % 2 = 1 ∧ E2 δ n)) : ℝ)
      ≤ K * (4 / Real.log 2) * (4 * 2 ^ J / (J + 2)) + K * (J + 1) := le_trans hcount' hsum
    _ ≤ K * (16 * ((x : ℝ) / Real.log x)) + K * (8 * ((x : ℝ) / Real.log x) + 2) := by
        have := mul_le_mul_of_nonneg_left hmain hK0
        have := mul_le_mul_of_nonneg_left hJ hK0
        nlinarith
    _ ≤ (K * 32 + 8 * K + 2) * ((x : ℝ) / Real.log x) + (K * 32 + 8 * K + 2) := by nlinarith

/-! ## The ceiling holds outside O(x/log x) exceptions -/

/-- The ceiling at n: every fixed-point-free Oliver Γ on n points has m\*_N(Γ) < δ_cyc(n)·C(n,2)
(1/4 at even n, 3 − 2√2 at odd n), i.e. μ\*_N^fpf(n) < δ_cyc(n)·C(n,2). -/
def Ceiling (n : ℕ) : Prop :=
  ∀ (V : Type) [Fintype V] [DecidableEq V], Fintype.card V = n →
    ∀ Γ : Subgroup (Equiv.Perm V), FPF Γ →
      (∃ p q : ℕ, p.Prime ∧ q.Prime ∧ Nonempty (Chain.OliverChain Γ p q)) →
      if n % 2 = 0 then 8 * (mN Γ : ℝ) < (n : ℝ) * (n - 1)
      else 2 * (mN Γ : ℝ) < (3 - 2 * Real.sqrt 2) * ((n : ℝ) * (n - 1))

theorem ceiling_of {n : ℕ}
    (H : ∀ (V : Type) [Fintype V] [DecidableEq V], HypStep2 V ∧ HypStep2Block V ∧ HypStep5 V)
    (hn2 : 2 ≤ n) (hesc : ¬ Escape n) (hE2 : ¬ (n % 2 = 1 ∧ E2 (3 - 2 * Real.sqrt 2) n)) :
    Ceiling n := by
  intro V _ _ hV Γ hfp hOl
  obtain ⟨H2, H2B, H5⟩ := H V
  have hnp : ¬ IsPrimePow (Fintype.card V) := by
    rw [hV]; intro hpp
    obtain ⟨p, k, hp, hk, rfl⟩ := (isPrimePow_nat_iff _).mp hpp
    exact hesc (Or.inr ⟨1, p, k, le_refl _, by norm_num, hp, hk, by ring⟩)
  split_ifs with hpar
  · have := Utyp_even_steps H2 H2B H5 hfp hOl hnp (by omega) (by omega)
      (by rw [hV]; exact fun h => hesc (E1_escape (by norm_num) h))
    rwa [hV] at this
  · have := Utyp_odd_steps H2 H2B H5 hfp hOl hnp (by omega) (by omega)
      ⟨by rw [hV]; exact fun h => hesc (E1_escape silver_ge h),
       by rw [hV]; exact fun h => hE2 ⟨by omega, h⟩⟩
    rwa [hV] at this

/-- **The upper side, at density one.**  Given Step 2 (for orbits and for blocks) and Step 5 as
named hypotheses, μ\*_N^fpf(n) < δ_cyc(n)·C(n,2) for all n outside O(x/log x) exceptions. -/
theorem ceiling_density
    (H : ∀ (V : Type) [Fintype V] [DecidableEq V], HypStep2 V ∧ HypStep2Block V ∧ HypStep5 V) :
    BCG.ExcBound {n | Ceiling n} 1 := by
  obtain ⟨C1, h1⟩ := esc_count
  obtain ⟨C2, h2⟩ := E2_count silver_ge
  have hC1 : 0 ≤ C1 := by
    have h := h1 0
    simp only [Nat.cast_zero, zero_div, mul_zero, zero_add] at h
    exact le_trans (Nat.cast_nonneg _) h
  refine ⟨C1 + C2 + 2, fun x => ?_⟩
  have hsub : (range (x + 1)).filter (· ∉ {n | Ceiling n}) ⊆
      (range (x + 1)).filter Escape ∪
        (range (x + 1)).filter (fun n => n % 2 = 1 ∧ E2 (3 - 2 * Real.sqrt 2) n) ∪ range 2 := by
    intro n hn
    simp only [mem_filter, mem_range, Set.mem_ofPred_eq, mem_union] at hn ⊢
    by_cases h2 : n < 2
    · exact Or.inr h2
    by_cases he : Escape n
    · exact Or.inl (Or.inl ⟨hn.1, he⟩)
    by_cases hE : n % 2 = 1 ∧ E2 (3 - 2 * Real.sqrt 2) n
    · exact Or.inl (Or.inr ⟨hn.1, hE⟩)
    exact absurd (ceiling_of H (by omega) he hE) hn.2
  have hc := le_trans (card_le_card hsub) (le_trans (card_union_le _ _)
    (Nat.add_le_add_right (card_union_le _ _) _))
  have hcR : (BCG.exc {n | Ceiling n} x : ℝ) ≤
      #((range (x + 1)).filter Escape) +
      #((range (x + 1)).filter (fun n => n % 2 = 1 ∧ E2 (3 - 2 * Real.sqrt 2) n)) + 2 := by
    unfold BCG.exc; rw [card_range] at hc; exact_mod_cast hc
  have := h1 x
  have := h2 x
  have hxl : 0 ≤ (x : ℝ) / Real.log x := div_nonneg (by positivity) (Real.log_natCast_nonneg x)
  simp only [pow_one]
  nlinarith

end UpperDensity

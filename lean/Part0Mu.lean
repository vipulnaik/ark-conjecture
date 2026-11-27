/-
# `Part0Mu.lean` — μ\*(n) in Lean, μ\* ≤ B_safe, and the wiring

* `cfg_fused`, `Bsafe_ge`: the fused configuration F·𝔽_c (c ≥ 3 a prime-power divisor of n, or
  c = n = 2) is admissible with SAFE ≥ n − 1.  So the fixed-point branch of `Part0Main.part0` is
  dominated **at every n ≥ 2** (`part0'`), not only "except at tiny n".
* `muStar n`: the largest least orbital of an Oliver group on `Fin n` — μ\*(n).
* **`muStar_le`**: μ\*(n) ≤ B_safe(n) for n ≥ 2, given `HypHuppert`.
* `floor_of_mu`, `cover_mu`, `cover_foreign_mu`: the covering statement with its floor on μ\*
  itself.  (Corollary E.6 for μ\*, with Part E proved too, is `PartEMu.e6_mu`.)
-/
import Part0Main
import CoverDensity

set_option linter.unusedSectionVars false

namespace Part0Mu
open Finset Chain ArkCore Part0 Part0Fr Part0Main E6 Real

/-! ## B_safe(n) ≥ n − 1 -/

/-- A prime-power divisor c of n with c ≥ 3, or n = 2. -/
theorem exists_c (n : ℕ) (hn : 2 ≤ n) :
    n = 2 ∨ ∃ c p b, 3 ≤ c ∧ c ∣ n ∧ p.Prime ∧ 1 ≤ b ∧ c = p ^ b := by
  by_cases h2 : n = 2
  · exact Or.inl h2
  right
  by_cases h4 : 4 ∣ n
  · exact ⟨4, 2, 2, by norm_num, h4, Nat.prime_two, by norm_num, by norm_num⟩
  -- otherwise n has an odd prime factor
  have hodd : ∃ p, p.Prime ∧ p ∣ n ∧ p ≠ 2 := by
    by_cases he : 2 ∣ n
    · obtain ⟨m, rfl⟩ := he
      have hm : m ≠ 1 := by omega
      have hm2 : ¬ 2 ∣ m := fun h => h4 (by obtain ⟨k, rfl⟩ := h; exact ⟨k, by ring⟩)
      refine ⟨m.minFac, Nat.minFac_prime hm, (Nat.minFac_dvd m).mul_left 2, ?_⟩
      intro h; exact hm2 (h ▸ Nat.minFac_dvd m)
    · refine ⟨n.minFac, Nat.minFac_prime (by omega), Nat.minFac_dvd n, ?_⟩
      intro h; exact he (h ▸ Nat.minFac_dvd n)
  obtain ⟨p, hp, hpn, hp2⟩ := hodd
  exact ⟨p, p, 1, by have := hp.two_le; omega, hpn, hp, le_refl _, (pow_one p).symm⟩

theorem minL_ge {l : List ℕ} (hl : l ≠ []) {m : ℕ} (h : ∀ x ∈ l, m ≤ x) : m ≤ minL l :=
  h _ (minL_mem hl)

/-- **B_safe(n) ≥ n − 1**: the fused configuration is admissible, on n points, with SAFE ≥ n − 1. -/
theorem Bsafe_ge (n : ℕ) (hn : 2 ≤ n) :
    ∃ Cf : Config, GAdm Cf ∧ Cf.n = n ∧ n - 1 ≤ Cf.safe := by
  -- a prime-power block c ∣ n with every term ≥ n − 1
  obtain ⟨c, p, b, F, hp, hb, rfl, hFn, hgood⟩ : ∃ c p b F, p.Prime ∧ 1 ≤ b ∧ c = p ^ b ∧
      F * c = n ∧ n - 1 ≤ F * pairs c := by
    rcases exists_c n hn with rfl | ⟨c, p, b, hc3, hcn, hp, hb, rfl⟩
    · exact ⟨2, 2, 1, 1, Nat.prime_two, le_refl _, rfl, rfl, by decide⟩
    · obtain ⟨F, hF⟩ := hcn
      refine ⟨p ^ b, p, b, F, hp, hb, rfl, by rw [hF]; ring, ?_⟩
      have h2 := two_pairs (p ^ b)
      have h3 : (p ^ b - 1) ≥ 2 := by omega
      have h4 : 2 * (F * pairs (p ^ b)) = F * p ^ b * (p ^ b - 1) := by
        rw [mul_left_comm, h2]; ring
      have h5 : F * p ^ b * 2 ≤ F * p ^ b * (p ^ b - 1) := Nat.mul_le_mul_left _ h3
      have h6 : F * p ^ b ≤ F * pairs (p ^ b) := by omega
      rw [hF, mul_comm]; omega
  refine ⟨⟨p, 2, [.pc F (p ^ b) (p ^ b - 1)]⟩, ⟨hp, Nat.prime_two, ?_, by simp [Config.foreign]⟩,
    ?_, ?_⟩
  · intro x hx
    simp only [List.mem_singleton] at hx
    subst hx
    refine ⟨?_, ⟨b, hb, rfl⟩, dvd_refl _⟩
    rcases Nat.eq_zero_or_pos F with h | h
    · subst h; omega
    · exact h
  · simp [Config.n, Config.sizes, CPart.sizeC, hFn]
  · unfold Config.safe
    apply minL_ge (by simp [CPart.safeTerms, E5Assembly.Part.terms])
    intro x hx
    simp only [List.flatMap_cons, List.flatMap_nil, List.append_nil, Config.sizes, List.map_cons,
      List.map_nil, crossN, CPart.safeTerms, E5Assembly.Part.terms] at hx
    simp only [List.mem_cons] at hx
    rcases hx with rfl | hx
    · exact hgood
    · split at hx
      · simp only [List.mem_singleton] at hx; subst hx
        refine hgood.trans ?_
        have h2 := two_pairs (p ^ b)
        have hp2 : 2 * pairs (p ^ b) ≤ p ^ b * p ^ b := by
          rw [h2]; exact Nat.mul_le_mul_left _ (Nat.sub_le _ _)
        split
        · calc F * pairs (p ^ b) ≤ F * (p ^ b * p ^ b) := Nat.mul_le_mul_left _ (by omega)
            _ = F * p ^ b * p ^ b := by ring
        · obtain ⟨k, hk⟩ : ∃ k, F = 2 * k := ⟨F / 2, by omega⟩
          rw [hk, show 2 * k / 2 = k by omega]
          calc 2 * k * pairs (p ^ b) = k * (2 * pairs (p ^ b)) := by ring
            _ ≤ k * (p ^ b * p ^ b) := Nat.mul_le_mul_left _ hp2
            _ = k * p ^ b * p ^ b := by ring
      · simp at hx

/-- **Part 0 with no fixed-point exception**: an Oliver group on n ≥ 2 points has an orbital of at
most SAFE(C) for some admissible configuration C on n points. -/
theorem part0' (HH : HypHuppert) {V : Type} [Fintype V] [DecidableEq V]
    (Γ : Subgroup (Equiv.Perm V)) {p q : ℕ} (C : OliverChain Γ p q) (hp : p.Prime) (hq : q.Prime)
    (hn : 2 ≤ Fintype.card V) :
    ∃ Cf : Config, GAdm Cf ∧ Cf.n = Fintype.card V ∧ OrbLe Γ Cf.safe := by
  rcases part0 HH Γ C hp hq hn with h | h
  · obtain ⟨Cf, hCf, hn', hge⟩ := Bsafe_ge _ hn
    exact ⟨Cf, hCf, hn', h.mono hge⟩
  · exact h

/-! ## μ\*(n) -/

/-- Γ has an Oliver chain. -/
def OliverG {V : Type} [Fintype V] (Γ : Subgroup (Equiv.Perm V)) : Prop :=
  ∃ p q : ℕ, p.Prime ∧ q.Prime ∧ Nonempty (OliverChain Γ p q)

/-- The least orbital of Γ (0 if there is none). -/
noncomputable def minOrb {V : Type} [Fintype V] [DecidableEq V] (Γ : Subgroup (Equiv.Perm V)) : ℕ :=
  sInf ((fun o : Finset (Sym2 V) => o.card) '' (Evasive.orbitals Γ : Set (Finset (Sym2 V))))

/-- **μ\*(n)**: the largest least orbital of an Oliver group on n points. -/
noncomputable def muStar (n : ℕ) : ℕ :=
  sSup {m | ∃ Γ : Subgroup (Equiv.Perm (Fin n)), OliverG Γ ∧ minOrb Γ = m}

theorem minOrb_le {V : Type} [Fintype V] [DecidableEq V] {Γ : Subgroup (Equiv.Perm V)} {X : ℕ}
    (h : OrbLe Γ X) : minOrb Γ ≤ X := by
  obtain ⟨e, he, hc⟩ := h
  refine le_trans (Nat.sInf_le ⟨_, ?_, rfl⟩) hc
  exact mem_image.mpr ⟨e, by simp [he], rfl⟩

/-- Every orbital has at most C(n,2) pairs, so the least one does. -/
theorem minOrb_le_pairs {V : Type} [Fintype V] [DecidableEq V] (Γ : Subgroup (Equiv.Perm V)) :
    minOrb Γ ≤ pairs (Fintype.card V) := by
  classical
  by_cases h : (Evasive.orbitals Γ).Nonempty
  · obtain ⟨o, ho⟩ := h
    obtain ⟨e, he, rfl⟩ := mem_image.mp ho
    simp only [mem_filter, mem_univ, true_and] at he
    refine le_trans (Nat.sInf_le ⟨_, ho, rfl⟩) ?_
    have hS : ∀ g ∈ Γ, ∀ e ∈ (univ : Finset V).offDiag.image Sym2.mk.uncurry,
        Sym2.map g e ∈ (univ : Finset V).offDiag.image Sym2.mk.uncurry := by
      intro g _ e he
      obtain ⟨⟨a, c⟩, hac, rfl⟩ := mem_image.mp he
      obtain ⟨-, -, hne⟩ := mem_offDiag.mp hac
      exact mem_image.mpr ⟨(g a, g c), mem_offDiag.mpr ⟨mem_univ _, mem_univ _,
        fun h => hne (g.injective h)⟩, by simp [Sym2.map_mk]⟩
    have he' : e ∈ (univ : Finset V).offDiag.image Sym2.mk.uncurry := by
      induction e using Sym2.ind with
      | h a c =>
        simp only [Sym2.mk_isDiag_iff] at he
        exact mem_image.mpr ⟨(a, c), mem_offDiag.mpr ⟨mem_univ _, mem_univ _, he⟩, rfl⟩
    have := D2.orbit2_card_le Γ _ hS he'
    rw [Sym2.card_image_offDiag, card_univ] at this
    rwa [show pairs (Fintype.card V) = (Fintype.card V).choose 2 by
      unfold pairs; rw [Nat.choose_two_right]]
  · rw [not_nonempty_iff_eq_empty] at h
    simp [minOrb, h]

/-- **μ\*(n) ≤ B_safe(n)** for n ≥ 2, given `HypHuppert`. -/
theorem muStar_le (HH : HypHuppert) {n B : ℕ} (hn : 2 ≤ n) (hB : IsBsafe n B) : muStar n ≤ B := by
  apply csSup_le'
  rintro m ⟨Γ, ⟨p, q, hp, hq, ⟨C⟩⟩, rfl⟩
  obtain ⟨Cf, hCf, hCn, hle⟩ := part0' HH Γ C hp hq (by simpa using hn)
  rw [Fintype.card_fin] at hCn
  exact (minOrb_le hle).trans (hB.2 Cf hCf hCn)

/-- μ\*(n) is attained once it is positive. -/
theorem muStar_attained {n : ℕ} (h : 0 < muStar n) :
    ∃ Γ : Subgroup (Equiv.Perm (Fin n)), OliverG Γ ∧ minOrb Γ = muStar n := by
  set s := {m | ∃ Γ : Subgroup (Equiv.Perm (Fin n)), OliverG Γ ∧ minOrb Γ = m}
  have hne : s.Nonempty := by
    by_contra hc
    rw [Set.not_nonempty_iff_eq_empty] at hc
    simp [muStar, s, hc] at h
  have hbdd : BddAbove s := ⟨pairs n, by
    rintro m ⟨Γ, -, rfl⟩; have := minOrb_le_pairs Γ; rwa [Fintype.card_fin] at this⟩
  exact Nat.sSup_mem hne hbdd

/-! ## The wiring -/

/-- **A floor on μ\* is a floor on SAFE**: δ·C(n,2) ≤ μ\*(n) gives `Cover.Floor δ n`. -/
theorem floor_of_mu (HH : HypHuppert) {n : ℕ} (hn : 2 ≤ n) {δ : ℝ}
    (h : δ * (pairs n : ℝ) ≤ muStar n) : Cover.Floor δ n := by
  rcases Nat.eq_zero_or_pos (muStar n) with h0 | h0
  · obtain ⟨Cf, hCf, hCn, -⟩ := Bsafe_ge n hn
    refine ⟨Cf, hCf, hCn, ?_⟩
    rw [h0] at h; push_cast at h
    exact h.trans (Nat.cast_nonneg _)
  · obtain ⟨Γ, ⟨p, q, hp, hq, ⟨C⟩⟩, hΓ⟩ := muStar_attained h0
    obtain ⟨Cf, hCf, hCn, hle⟩ := part0' HH Γ C hp hq (by simpa using hn)
    rw [Fintype.card_fin] at hCn
    refine ⟨Cf, hCf, hCn, h.trans ?_⟩
    rw [← hΓ]; exact_mod_cast minOrb_le hle

/-- **The covering statement on μ\* itself** (§6.6, ⇒): a floor δ > 1/25 on μ\*(n), holding
L-eventually, forces Proposition 1's systems L-eventually. -/
theorem cover_mu (HH : HypHuppert) {L : Filter ℕ} (hL : L ≤ Filter.atTop) {δ : ℝ}
    (hδ : 1 / 25 < δ) (H : BCG.Hyp (fun n => δ * (pairs n : ℝ) ≤ muStar n) L) :
    BCG.Hyp (Cover.ShapeD δ 15) L := by
  apply Cover.cover_25 hL hδ
  filter_upwards [H, hL (Filter.eventually_ge_atTop 2)] with n hn h2
  exact floor_of_mu HH h2 hn

/-- **…and with a foreign part**, outside O(x/log x) exceptions. -/
theorem cover_foreign_mu (HH : HypHuppert) {L : Filter ℕ} (hL : L ≤ Filter.atTop)
    (hR : CoverDensity.Rate1 L) {δ : ℝ} (hδ : 1 / 25 < δ) (Fmax : ℕ)
    (hcap : 1 < √δ * (1 + √((Fmax + 1 : ℕ) : ℝ)))
    (H : BCG.Hyp (fun n => δ * (pairs n : ℝ) ≤ muStar n) L) :
    BCG.ExcBound {n | CoverDensity.ShapeFr δ (min 15 Fmax) n} 1 := by
  apply CoverDensity.cover_foreign hL hR hδ Fmax hcap
  filter_upwards [H, hL (Filter.eventually_ge_atTop 2)] with n hn h2
  exact floor_of_mu HH h2 hn

end Part0Mu

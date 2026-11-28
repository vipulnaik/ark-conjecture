/-
# `Chiral.lean` — μ\*_chi(n) ≥ μ\*(n)/2 (`chiral-graph-properties.md` Theorem 1)

μ\*_chi(n) is μ\*(n) with the group required to lie in the alternating group (`muChi`).  Given Γ
realising μ\*(n), Γ⁺ = Γ ∩ A_n carries the restricted Oliver chain (`D2Full.OliverChain.comap`),
and every Γ-orbital is covered by a Γ⁺-orbital and its image under one odd element of Γ, so
2·minOrb Γ⁺ ≥ minOrb Γ (`minOrb_le_two_mul`).  Hence μ\*(n) ≤ 2·μ\*_chi(n) (`muStar_le_two_muChi`).
No hypotheses.
-/
import Part0Mu
import D2Full

namespace Chiral
open Finset Equiv Chain Part0Mu

/-- **μ\*_chi(n)**: the largest least orbital of an Oliver group of even permutations. -/
noncomputable def muChi (n : ℕ) : ℕ :=
  sSup {m | ∃ Γ : Subgroup (Perm (Fin n)), (Γ ≤ alternatingGroup (Fin n) ∧ OliverG Γ) ∧ minOrb Γ = m}

variable {V : Type} [Fintype V] [DecidableEq V]

/-- A Γ-orbit of a pair is covered by the (Γ ∩ A)-orbit and its image under any odd σ ∈ Γ. -/
theorem orbit2_le_two (Γ : Subgroup (Perm V)) (e : Sym2 V) :
    (D2.orbit2 Γ e).card ≤ 2 * (D2.orbit2 (Γ ⊓ alternatingGroup V) e).card := by
  classical
  set K := Γ ⊓ alternatingGroup V
  by_cases hodd : ∃ σ ∈ Γ, σ ∉ alternatingGroup V
  · obtain ⟨σ, hσ, hσo⟩ := hodd
    have hsub : D2.orbit2 Γ e ⊆ D2.orbit2 K e ∪ (D2.orbit2 K e).image (Sym2.map σ) := by
      intro x hx
      simp only [D2.orbit2, mem_image, mem_filter, mem_univ, true_and] at hx
      obtain ⟨g, hg, rfl⟩ := hx
      by_cases hge : g ∈ alternatingGroup V
      · exact mem_union_left _ (by
          simp only [D2.orbit2, mem_image, mem_filter, mem_univ, true_and]
          exact ⟨g, ⟨hg, hge⟩, rfl⟩)
      · apply mem_union_right
        simp only [D2.orbit2, mem_image, mem_filter, mem_univ, true_and]
        refine ⟨Sym2.map (σ⁻¹ * g) e, ⟨σ⁻¹ * g, ⟨Γ.mul_mem (Γ.inv_mem hσ) hg, ?_⟩, rfl⟩, ?_⟩
        · show σ⁻¹ * g ∈ alternatingGroup V
          rw [Perm.mem_alternatingGroup, Perm.sign_mul, Perm.sign_inv]
          rw [Perm.mem_alternatingGroup] at hge hσo
          rcases Int.units_eq_one_or (Perm.sign σ) with h | h
          · exact absurd h hσo
          rcases Int.units_eq_one_or (Perm.sign g) with h' | h'
          · exact absurd h' hge
          rw [h, h']; rfl
        · rw [Sym2.map_map]; congr 1; ext x; simp
    calc (D2.orbit2 Γ e).card ≤ (D2.orbit2 K e ∪ (D2.orbit2 K e).image (Sym2.map σ)).card :=
          card_le_card hsub
      _ ≤ (D2.orbit2 K e).card + ((D2.orbit2 K e).image (Sym2.map σ)).card := card_union_le _ _
      _ ≤ (D2.orbit2 K e).card + (D2.orbit2 K e).card := Nat.add_le_add_left card_image_le _
      _ = 2 * (D2.orbit2 K e).card := by ring
  · push Not at hodd
    have hK : K = Γ := inf_eq_left.mpr hodd
    rw [hK]; omega

/-- **The least orbital at most halves** on passing to Γ ∩ A. -/
theorem minOrb_le_two_mul (Γ : Subgroup (Perm V)) :
    minOrb Γ ≤ 2 * minOrb (Γ ⊓ alternatingGroup V) := by
  classical
  set K := Γ ⊓ alternatingGroup V
  set SK := (fun o : Finset (Sym2 V) => o.card) '' (Evasive.orbitals K : Set (Finset (Sym2 V)))
  by_cases hne : SK.Nonempty
  · have hmem := Nat.sInf_mem hne
    obtain ⟨o, ho, hoc⟩ := hmem
    simp only [Evasive.orbitals, coe_image, coe_filter, mem_univ, true_and, Set.mem_image,
      Set.mem_ofPred_eq] at ho
    obtain ⟨e, he, rfl⟩ := ho
    have h1 : minOrb Γ ≤ (D2.orbit2 Γ e).card := by
      apply Nat.sInf_le
      refine ⟨D2.orbit2 Γ e, ?_, rfl⟩
      simp only [Evasive.orbitals, coe_image, coe_filter, mem_univ, true_and]
      exact ⟨e, he, rfl⟩
    have h2 := orbit2_le_two Γ e
    show minOrb Γ ≤ 2 * sInf SK
    rw [← hoc]; exact h1.trans h2
  · have hemp : Evasive.orbitals K = ∅ := by
      by_contra h
      obtain ⟨o, ho⟩ := nonempty_iff_ne_empty.mpr h
      exact hne ⟨_, o, ho, rfl⟩
    have hemp' : Evasive.orbitals Γ = ∅ := by
      simp only [Evasive.orbitals, image_eq_empty] at hemp ⊢; exact hemp
    simp [minOrb, hemp']

/-- Γ ∩ A_n is Oliver when Γ is. -/
theorem oliver_inf {Γ : Subgroup (Perm V)} (h : OliverG Γ) : OliverG (Γ ⊓ alternatingGroup V) := by
  obtain ⟨p, q, hp, hq, ⟨C⟩⟩ := h
  have hle : Γ ⊓ alternatingGroup V ≤ Γ := inf_le_left
  let C' := D2Full.OliverChain.comap C ((Γ ⊓ alternatingGroup V).subgroupOf Γ)
  exact ⟨p, q, hp, hq, ⟨C'.map (Subgroup.subgroupOfEquivOfLe hle).toMonoidHom
    (Subgroup.subgroupOfEquivOfLe hle).surjective⟩⟩

theorem bdd (n : ℕ) (P : Subgroup (Perm (Fin n)) → Prop) :
    BddAbove {m | ∃ Γ : Subgroup (Perm (Fin n)), P Γ ∧ minOrb Γ = m} :=
  ⟨ArkCore.pairs (Fintype.card (Fin n)), by
    rintro m ⟨Γ, -, rfl⟩; exact minOrb_le_pairs Γ⟩

/-- **Theorem 1**: μ\*(n) ≤ 2·μ\*_chi(n). -/
theorem muStar_le_two_muChi (n : ℕ) : muStar n ≤ 2 * muChi n := by
  classical
  set S := {m | ∃ Γ : Subgroup (Perm (Fin n)), OliverG Γ ∧ minOrb Γ = m}
  by_cases hS : S.Nonempty
  · obtain ⟨Γ, hΓ, hm⟩ := Nat.sSup_mem hS (bdd n (fun Γ => OliverG Γ))
    have hle : minOrb (Γ ⊓ alternatingGroup (Fin n)) ≤ muChi n := by
      apply le_csSup (bdd n (fun Γ => Γ ≤ alternatingGroup (Fin n) ∧ OliverG Γ))
      exact ⟨_, ⟨inf_le_right, oliver_inf hΓ⟩, rfl⟩
    have := minOrb_le_two_mul Γ
    show sSup S ≤ _
    rw [← hm]; omega
  · rw [Set.not_nonempty_iff_eq_empty] at hS
    show sSup S ≤ _
    rw [hS, csSup_empty]; exact Nat.zero_le _

end Chiral

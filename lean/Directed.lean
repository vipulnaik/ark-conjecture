/-
# `Directed.lean` — μ\*_dir(n) ≥ μ\*(n) (`directed-graph-properties.md` Theorem D1)

μ\*_dir(n) is the largest, over Oliver groups on n points, of the least orbit on ordered pairs of
distinct points (`muDir`).  An ordered orbit maps onto the unordered orbit below it, so it is no
smaller (`orbit2_le_orbitP`), and the same group gives μ\*_dir(n) ≥ μ\*(n) (`muStar_le_muDir`).
No hypotheses.
-/
import Chiral

namespace Directed
open Finset Equiv Part0Mu

variable {V : Type} [Fintype V] [DecidableEq V]

open Classical in
/-- The Γ-orbit of an ordered pair. -/
noncomputable def orbitP (Γ : Subgroup (Perm V)) (e : V × V) : Finset (V × V) :=
  ((univ : Finset (Perm V)).filter (· ∈ Γ)).image (fun g => (g e.1, g e.2))

/-- The least orbit on ordered pairs of distinct points (0 if none). -/
noncomputable def minOrbDir (Γ : Subgroup (Perm V)) : ℕ :=
  sInf ((fun e : V × V => (orbitP Γ e).card) '' {e | e.1 ≠ e.2})

/-- **μ\*_dir(n)**. -/
noncomputable def muDir (n : ℕ) : ℕ :=
  sSup {m | ∃ Γ : Subgroup (Perm (Fin n)), OliverG Γ ∧ minOrbDir Γ = m}

theorem orbit2_le_orbitP (Γ : Subgroup (Perm V)) (e : V × V) :
    (D2.orbit2 Γ (s(e.1, e.2))).card ≤ (orbitP Γ e).card := by
  classical
  have : D2.orbit2 Γ (s(e.1, e.2)) = (orbitP Γ e).image (fun x => s(x.1, x.2)) := by
    simp only [D2.orbit2, orbitP, image_image]; rfl
  rw [this]; exact card_image_le

theorem minOrb_le_minOrbDir (Γ : Subgroup (Perm V)) : minOrb Γ ≤ minOrbDir Γ := by
  classical
  set SD := (fun e : V × V => (orbitP Γ e).card) '' {e | e.1 ≠ e.2}
  by_cases hne : SD.Nonempty
  · obtain ⟨e, he, hec⟩ := Nat.sInf_mem hne
    have h1 : minOrb Γ ≤ (D2.orbit2 Γ (s(e.1, e.2))).card := by
      apply Nat.sInf_le
      refine ⟨D2.orbit2 Γ (s(e.1, e.2)), ?_, rfl⟩
      simp only [Evasive.orbitals, coe_image, coe_filter, mem_univ, true_and]
      refine ⟨s(e.1, e.2), ?_, rfl⟩
      obtain ⟨a, b⟩ := e
      simpa using he
    show minOrb Γ ≤ sInf SD
    rw [← hec]; exact h1.trans (orbit2_le_orbitP Γ e)
  · have hemp : Evasive.orbitals Γ = ∅ := by
      rw [eq_empty_iff_forall_notMem]
      intro o ho
      simp only [Evasive.orbitals, mem_image, mem_filter, mem_univ, true_and] at ho
      obtain ⟨s, hs, -⟩ := ho
      induction s using Sym2.ind with
      | h a b => exact hne ⟨_, (a, b), by simpa using hs, rfl⟩
    simp [minOrb, hemp]

theorem bddDir (n : ℕ) :
    BddAbove {m | ∃ Γ : Subgroup (Perm (Fin n)), OliverG Γ ∧ minOrbDir Γ = m} := by
  classical
  refine ⟨Fintype.card (Fin n × Fin n), ?_⟩
  rintro m ⟨Γ, -, rfl⟩
  by_cases hne : ((fun e : Fin n × Fin n => (orbitP Γ e).card) '' {e | e.1 ≠ e.2}).Nonempty
  · obtain ⟨e, -, hec⟩ := Nat.sInf_mem hne
    show sInf _ ≤ _
    rw [← hec]; exact card_le_univ _
  · rw [Set.not_nonempty_iff_eq_empty] at hne
    show sInf _ ≤ _
    rw [hne, Nat.sInf_empty]; exact Nat.zero_le _

/-- **Theorem D1**: μ\*(n) ≤ μ\*_dir(n). -/
theorem muStar_le_muDir (n : ℕ) : muStar n ≤ muDir n := by
  classical
  set S := {m | ∃ Γ : Subgroup (Perm (Fin n)), OliverG Γ ∧ minOrb Γ = m}
  by_cases hS : S.Nonempty
  · obtain ⟨Γ, hΓ, hm⟩ := Nat.sSup_mem hS (Chiral.bdd n (fun Γ => OliverG Γ))
    show sSup S ≤ _
    rw [← hm]
    exact (minOrb_le_minOrbDir Γ).trans (le_csSup (bddDir n) ⟨Γ, hΓ, rfl⟩)
  · rw [Set.not_nonempty_iff_eq_empty] at hS
    show sSup S ≤ _
    rw [hS, csSup_empty]; exact Nat.zero_le _

end Directed

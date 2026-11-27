/-
# `Part0Fo.lean` — Part 0, step 3: a fused outside orbit inside V

`FoBridge.fo_terms_valid` gives Lemma D2's orbitals for a group on `Pt F r = Fin F × ℤ/r` that
preserves the blocks {i} × ℤ/r and is transitive.  Here an orbit O of Γ with a block system of
F ≥ 2 blocks of prime size r is relabelled as `Pt F r` (`fusedEquiv`), and the bound is carried
back to Γ (`fused_orbit`).
-/
import Part0Fr
import FoBridge

set_option linter.unusedSectionVars false

namespace Part0Fo
open Finset Chain ArkCore Part0 Part0Fr

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- Relabel an orbit tiled by blocks of size r as `Fin F × ℤ/r`, block i ↦ {i} × ℤ/r. -/
theorem fusedEquiv {r F : ℕ} [NeZero r] (O : Finset V) (Bs : Finset (Finset V))
    (hF : Bs.card = F) (hsize : ∀ X ∈ Bs, X.card = r) (hsub : ∀ X ∈ Bs, X ⊆ O)
    (hdisj : ∀ X ∈ Bs, ∀ Y ∈ Bs, X ≠ Y → Disjoint X Y) (hO : O.card = F * r) :
    ∃ (e : O ≃ Fin F × ZMod r) (bl : Fin F → Finset V),
      (∀ i, bl i ∈ Bs) ∧ Function.Injective bl ∧ (∀ u : O, (u : V) ∈ bl (e u).1) := by
  classical
  -- index the blocks, and coordinatise each
  have eB : Fin F ≃ Bs := (Fintype.equivFinOfCardEq (by simp [hF])).symm
  let bl : Fin F → Finset V := fun i => (eB i : Finset V)
  have hbl : ∀ i, bl i ∈ Bs := fun i => (eB i).2
  have ec : ∀ i, (bl i) ≃ ZMod r := fun i =>
    Fintype.equivOfCardEq (by simp [hsize _ (hbl i), ZMod.card])
  let φ : Fin F × ZMod r → O := fun iz =>
    ⟨((ec iz.1).symm iz.2 : V), hsub _ (hbl iz.1) ((ec iz.1).symm iz.2).2⟩
  have hφ : Function.Injective φ := by
    intro ⟨i, z⟩ ⟨j, w⟩ h
    have h' : (((ec i).symm z : bl i) : V) = (((ec j).symm w : bl j) : V) := congrArg Subtype.val h
    by_cases hij : i = j
    · subst hij
      have : (ec i).symm z = (ec i).symm w := Subtype.ext h'
      simp [(ec i).symm.injective this]
    · exfalso
      have hne : bl i ≠ bl j := by
        intro he; apply hij; apply eB.injective; exact Subtype.ext he
      exact disjoint_left.mp (hdisj _ (hbl i) _ (hbl j) hne) ((ec i).symm z).2 (h' ▸ ((ec j).symm w).2)
  have hcard : Fintype.card (Fin F × ZMod r) = Fintype.card O := by simp [hO, ZMod.card]
  have hbij : Function.Bijective φ := (Fintype.bijective_iff_injective_and_card φ).mpr ⟨hφ, hcard⟩
  set E := Equiv.ofBijective φ hbij
  refine ⟨E.symm, bl, hbl, fun i j h => eB.injective (Subtype.ext h), fun u => ?_⟩
  have : φ (E.symm u) = u := E.apply_symm_apply u
  have h2 : (u : V) = ((ec (E.symm u).1).symm (E.symm u).2 : V) := by
    conv_lhs => rw [← this]
  rw [h2]
  exact ((ec (E.symm u).1).symm (E.symm u).2).2

/-- **A fused outside orbit's SAFE terms bound orbitals of Γ.**  An orbit O of an Oliver group,
tiled by F ≥ 2 images of a block B of prime size r ≠ p: every term of `fo F r t` is at least
some orbital of Γ (Lemma D2, via `FoBridge`). -/
theorem fused_orbit {p q r : ℕ} [hr : Fact r.Prime] (Γ : Subgroup (Equiv.Perm V))
    (C : OliverChain Γ p q) (hp : p.Prime) (hq : q.Prime) (hrp : r ≠ p)
    (O : Finset V) (hO : ∀ g ∈ Γ, ∀ x ∈ O, g x ∈ O) (htr : ∀ x ∈ O, ∀ y ∈ O, ∃ g ∈ Γ, g x = y)
    {B : Finset V} (hBO : B ⊆ O) (hB : IsBlk Γ B) (hBr : B.card = r)
    (hF2 : 2 ≤ (blockSys Γ B).card) (t : ℕ) :
    ∀ y ∈ (E6.CPart.fo (blockSys Γ B).card r t).safeTerms, OrbLe Γ y := by
  classical
  have : NeZero r := ⟨hr.out.ne_zero⟩
  set F := (blockSys Γ B).card
  have hBne : B.Nonempty := by
    rw [← card_pos, hBr]; exact hr.out.pos
  have hsub : ∀ X ∈ blockSys Γ B, X ⊆ O := by
    intro X hX
    obtain ⟨g, hg, rfl⟩ := mem_image.mp hX
    simp only [mem_filter, mem_univ, true_and] at hg
    intro z hz
    obtain ⟨w, hw, rfl⟩ := mem_image.mp hz
    exact hO g hg w (hBO hw)
  have hOc : O.card = F * r := by rw [← hBr]; exact blockSys_card hO htr hBO hBne hB
  obtain ⟨e, bl, hbl, hblinj, hmem⟩ := fusedEquiv (r := r) O (blockSys Γ B) rfl
    (fun X hX => (blockSys_size hX).trans hBr) hsub
    (fun X hX Y hY hne => blockSys_disj hB hX hY hne) hOc
  set ρ := resHom Γ O hO e
  have C' := C.map ρ.rangeRestrict ρ.rangeRestrict_surjective
  have htr' := res_transitive Γ O hO e htr
  have hblk : ∀ g ∈ ρ.range, ∀ i x y, (g (i, x)).1 = (g (i, y)).1 := by
    rintro _ ⟨γ, rfl⟩ i x y
    -- both images lie in the block γ(bl i)
    set u := e.symm (i, x)
    set u' := e.symm (i, y)
    have hu : (u : V) ∈ bl i := by have := hmem u; simpa [u] using this
    have hu' : (u' : V) ∈ bl i := by have := hmem u'; simpa [u'] using this
    have hY := blockSys_inv (γ : Equiv.Perm V) γ.2 _ (hbl i)
    have h1 := hmem (e.symm (ρ γ (i, x)))
    have h2 := hmem (e.symm (ρ γ (i, y)))
    simp only [Equiv.apply_symm_apply] at h1 h2
    rw [resHom_apply] at h1 h2
    have hy1 : (γ : Equiv.Perm V) u ∈ (bl i).image γ := mem_image_of_mem _ hu
    have hy2 : (γ : Equiv.Perm V) u' ∈ (bl i).image γ := mem_image_of_mem _ hu'
    -- the block containing each image is γ(bl i)
    have k1 : bl (ρ γ (i, x)).1 = (bl i).image γ := by
      by_contra hne
      exact disjoint_left.mp (blockSys_disj hB (hbl _) hY hne) h1 hy1
    have k2 : bl (ρ γ (i, y)).1 = (bl i).image γ := by
      by_contra hne
      exact disjoint_left.mp (blockSys_disj hB (hbl _) hY hne) h2 hy2
    exact hblinj (k1.trans k2.symm)
  intro y hy
  obtain ⟨z, hz, hcz⟩ := FoBridge.fo_terms_valid ρ.range C' hp hq hrp hF2 hblk htr' t y hy
  exact ⟨liftP O e z, liftP_nondiag O e hz, (orbit2_res_le Γ O hO e z).trans hcz⟩

end Part0Fo

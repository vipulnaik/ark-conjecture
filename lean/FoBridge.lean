/-
# `FoBridge.lean` — E.6's D2 scores are Lemma D2's theorems

`E6.lean` scores a fused/repeated outside part `fo F r t` by D2's two classes: F·C(r,2), and,
when F < r, max(C(F,2)·r, F·r).  This file proves that each of those numbers really bounds an
orbital of every group of that shape (`fo_terms_valid`), using `D2q.lemmaD2`.  So the `fo`
scores in the E.6 model are no longer taken from the text: they are theorems from the chain,
a preserved block system and transitivity.
-/
import D2q
import E6

namespace FoBridge
open Chain

theorem pairs_eq_choose (n : ℕ) : ArkCore.pairs n = n.choose 2 := by
  unfold ArkCore.pairs; rw [Nat.choose_two_right]

/-- **Every `fo` SAFE term is an orbital bound.**  For any G realising F ≥ 2 outside blocks of
prime size r ≠ p (preserved block system, transitive, Oliver chain), each term E.6 assigns to
`fo F r t` is at least the size of some orbital of G. -/
theorem fo_terms_valid {F r p q : ℕ} [Fact r.Prime] (G : Subgroup (Equiv.Perm (Pt F r)))
    (C : OliverChain G p q) (hp : p.Prime) (hq : q.Prime) (hrp : r ≠ p) (hF2 : 2 ≤ F)
    (hblk : ∀ g ∈ G, ∀ i x y, (g (i, x)).1 = (g (i, y)).1)
    (htr : ∀ x y : Pt F r, ∃ g ∈ G, g x = y) (t : ℕ) :
    ∀ y ∈ (E6.CPart.fo F r t).safeTerms,
      ∃ e : Sym2 (Pt F r), ¬ e.IsDiag ∧ (D2.orbit2 G e).card ≤ y := by
  obtain ⟨ha, hb, hc⟩ := D2q.lemmaD2 G C hp hq hrp hF2 hblk htr
  intro y hy
  simp only [E6.CPart.safeTerms, E6.d2term, List.mem_cons] at hy
  rcases hy with rfl | hy
  · rw [pairs_eq_choose]; exact ha
  · split at hy
    · rename_i hFr
      simp only [List.mem_singleton] at hy
      subst hy
      by_cases hrq : r = q
      · obtain ⟨e, he, hcard⟩ := hc hFr hrq
        exact ⟨e, he, le_trans hcard (le_max_right _ _)⟩
      · obtain ⟨e, he, hcard⟩ := hb hFr hrq
        refine ⟨e, he, le_trans hcard (le_trans ?_ (le_max_left _ _))⟩
        rw [pairs_eq_choose, Nat.mul_comm]
    · simp at hy

end FoBridge

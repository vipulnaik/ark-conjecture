/-
# `SylowTransitive.lean` — a Sylow subgroup of a transitive group of prime-power degree is transitive

`monotone-transitive-note.md` §3, Proposition 2 (Rivest–Vuillemin's counting).  If G acts
transitively on X with |X| = p^a, then every Sylow p-subgroup P acts transitively on X.

Proof: |G| = p^a·|G_x|, so |P| = p^{a+v} with v = v_p(|G_x|).  The stabiliser of x in P is a
p-group embedded in G_x, so its order p^e has e ≤ v, and the P-orbit of x has size
p^{a+v−e} ≥ p^a = |X|.
-/
import Mathlib

namespace SylowTransitive
open MulAction

theorem sylow_transitive {G X : Type*} [Group G] [Finite G] [Finite X] [MulAction G X]
    [IsPretransitive G X] {p a : ℕ} [hp : Fact p.Prime] (hX : Nat.card X = p ^ a)
    (P : Sylow p G) : IsPretransitive P X := by
  have hp' := hp.out
  have key : ∀ x : X, orbit P x = Set.univ := by
    intro x
    set Gx := stabilizer G x
    have hG : Nat.card G = p ^ a * Nat.card Gx := by
      rw [← Subgroup.card_mul_index Gx, index_stabilizer, orbit_eq_univ, Set.ncard_univ, hX,
        Nat.mul_comm]
    have hGx0 : Nat.card Gx ≠ 0 := Nat.card_pos.ne'
    set v := (Nat.card Gx).factorization p
    have hfac : (Nat.card G).factorization p = a + v := by
      rw [hG, Nat.factorization_mul (pow_ne_zero _ hp'.ne_zero) hGx0, Finsupp.add_apply,
        hp'.factorization_pow, Finsupp.single_eq_same]
    have hP : Nat.card P = p ^ (a + v) := by rw [Sylow.card_eq_multiplicity, hfac]
    set H := stabilizer P x
    have hHp : IsPGroup p H := P.isPGroup.to_subgroup H
    obtain ⟨e, he⟩ := IsPGroup.iff_card.mp hHp
    have hHdvd : Nat.card H ∣ Nat.card Gx := by
      rw [← Subgroup.card_map_of_injective (f := (P : Subgroup G).subtype) Subtype.val_injective]
      apply Subgroup.card_dvd_of_le
      rintro _ ⟨h, hh, rfl⟩
      have hh' : h ∈ H := hh
      rw [mem_stabilizer_iff] at hh' ⊢
      exact hh'
    rw [he] at hHdvd
    have hev : e ≤ v := (hp'.pow_dvd_iff_le_factorization hGx0).mp hHdvd
    have hPo : Nat.card P = Nat.card H * (orbit P x).ncard := by
      rw [← Subgroup.card_mul_index H, index_stabilizer]
    rw [hP, he] at hPo
    have ho : (orbit P x).ncard = p ^ (a + v - e) := by
      apply Nat.eq_of_mul_eq_mul_left (pow_pos hp'.pos e)
      rw [← hPo, ← pow_add]; congr 1; omega
    have hle : Nat.card X ≤ (orbit P x).ncard := by
      rw [ho, hX]; exact Nat.pow_le_pow_right hp'.pos (by omega)
    have := Fintype.ofFinite X
    apply Set.eq_of_subset_of_ncard_le (Set.subset_univ _) _ (Set.toFinite _)
    rwa [Set.ncard_univ]
  exact ⟨fun x y => by
    have : y ∈ orbit P x := by rw [key x]; trivial
    exact this⟩

end SylowTransitive

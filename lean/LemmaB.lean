/-
# `LemmaB.lean` — Lemma B for a block of prime size: first pieces

Lemma B (`enumeration-proof.md` Part B) says a primitive block of an Oliver group is affine.
The text cites "a solvable primitive group is affine" (classical, not in Mathlib).  For an
**outside block of prime size r** — the case Lemma D2 needs — there is an elementary route:

1. the bottom layer Γ₂ (a p-group, p ≠ r) acts trivially on a block of prime size
   (`normal_pgroup_trivial`: a normal subgroup of a primitive group is transitive or trivial,
   and a transitive p-group on r points would need r ∣ pᵏ);
2. so Γ₁ acts through the cyclic layer, its r-elements form one cyclic subgroup, which is
   normalised by everything;
3. an element normalising the regular C_r = ⟨x ↦ x + 1⟩ is affine (`affine_of_shift`).

This file proves all three steps as separate lemmas: `normal_pgroup_trivial` (1),
`conj_mem_zpowers` (2: in a cyclic normal subgroup, an element of order r is conjugated to its
own powers, via `mem_zpowers_of_orderOf_eq`), and `affine_of_shift` / `affine_of_normalizes`
(3).  **Not yet assembled:** the block group's Γ₁-image is cyclic (1 plus faithfulness), it
contains an r-cycle z (Cauchy plus `Chain.rsub_le_N₁`), each block is coordinatised by z as
x ↦ x + 1, and the per-block statements are glued into `Chain.Affine` on O.
-/
import Mathlib

namespace LemmaB

/-- **Normaliser of a regular C_r is affine.**  If f(x + 1) = f(x) + c for all x ∈ ZMod r,
then f(x) = c·x + f(0). -/
theorem affine_of_shift {r : ℕ} [NeZero r] (f : ZMod r → ZMod r) (c : ZMod r)
    (h : ∀ x, f (x + 1) = f x + c) : ∀ x, f x = c * x + f 0 := by
  have hn : ∀ n : ℕ, f n = c * n + f 0 := by
    intro n
    induction n with
    | zero => simp
    | succ n ih => rw [Nat.cast_succ, h, ih]; ring
  intro x
  have := hn x.val
  rwa [ZMod.natCast_zmod_val] at this

/-- **A normal p-subgroup of a group acting transitively on r points (r prime, p ≠ r) acts
trivially.**  The action is primitive (prime degree), so a normal subgroup is transitive or
fixes every point; a transitive one would have r ∣ |N|, a power of p. -/
theorem normal_pgroup_trivial {G X : Type*} [Group G] [MulAction G X] [Finite G] [Finite X]
    {p r : ℕ} (hr : r.Prime) (hp : p.Prime) (hpr : p ≠ r) (hX : Nat.card X = r)
    [MulAction.IsPretransitive G X] (N : Subgroup G) [N.Normal] (hN : IsPGroup p N) :
    ∀ n ∈ N, ∀ x : X, n • x = x := by
  classical
  have hprim : MulAction.IsPreprimitive G X := MulAction.IsPreprimitive.of_prime_card (hX ▸ hr)
  by_contra hcon
  push Not at hcon
  obtain ⟨n, hn, x, hx⟩ := hcon
  have hfix : MulAction.fixedPoints N X ≠ Set.univ := by
    intro h
    apply hx
    have : x ∈ MulAction.fixedPoints N X := h ▸ Set.mem_univ x
    exact this ⟨n, hn⟩
  have htr : MulAction.IsPretransitive N X :=
    MulAction.IsQuasiPreprimitive.isPretransitive_of_normal hfix
  -- N is transitive on X, so r = [N : stabilizer] divides |N|
  have hcard : r ∣ Nat.card N := by
    rw [← hX, ← MulAction.index_stabilizer_of_transitive N x]
    exact Subgroup.index_dvd_card _
  have : Fact p.Prime := ⟨hp⟩
  obtain ⟨k, hk⟩ := hN.exists_card_eq
  rw [hk] at hcard
  have := (Nat.prime_dvd_prime_iff_eq hr hp).mp (hr.dvd_of_dvd_pow hcard)
  exact hpr this.symm

/-- In a finite cyclic group, two elements of the same order r generate the same subgroup:
y ∈ ⟨z⟩.  (At most r elements satisfy xʳ = 1, and ⟨z⟩ already supplies r of them.) -/
theorem mem_zpowers_of_orderOf_eq {A : Type*} [Group A] [Fintype A] [DecidableEq A]
    [IsCyclic A] {r : ℕ} (hr : 0 < r) {y z : A} (hy : orderOf y = r) (hz : orderOf z = r) :
    y ∈ Subgroup.zpowers z := by
  classical
  let S : Finset A := Finset.univ.filter fun x => x ^ r = 1
  let T : Finset A := Finset.univ.filter fun x => x ∈ Subgroup.zpowers z
  have hTS : T ⊆ S := by
    intro x hx
    simp only [T, S, Finset.mem_filter, Finset.mem_univ, true_and] at hx ⊢
    obtain ⟨k, rfl⟩ := hx
    rw [← zpow_natCast, ← zpow_mul, mul_comm, zpow_mul, zpow_natCast, ← hz, pow_orderOf_eq_one,
      one_zpow]
  have hS : S.card ≤ r := IsCyclic.card_pow_eq_one_le hr
  have hT : T.card = r := by
    rw [← hz, ← Nat.card_zpowers]
    simp only [T]
    rw [Nat.card_eq_fintype_card, ← Fintype.card_subtype]
  have hEq : T = S := Finset.eq_of_subset_of_card_le hTS (by omega)
  have hyS : y ∈ S := by
    simp only [S, Finset.mem_filter, Finset.mem_univ, true_and]
    rw [← hy]; exact pow_orderOf_eq_one y
  rw [← hEq] at hyS
  simpa [T] using hyS

/-- **Step 2 of the route: an element of order r in a cyclic normal subgroup is normalised by
everything** — every conjugate h z h⁻¹ is a power of z. -/
theorem conj_mem_zpowers {H : Type*} [Group H] [Finite H] (N : Subgroup H) [N.Normal]
    [IsCyclic N] {r : ℕ} (hr : 0 < r) {z : H} (hzN : z ∈ N) (hz : orderOf z = r) (h : H) :
    h * z * h⁻¹ ∈ Subgroup.zpowers z := by
  classical
  have : Fintype N := Fintype.ofFinite N
  have hy : orderOf (⟨h * z * h⁻¹, (inferInstance : N.Normal).conj_mem z hzN h⟩ : N) = r := by
    rw [Subgroup.orderOf_mk, ← hz]
    have := orderOf_injective (MulAut.conj h).toMonoidHom (MulAut.conj h).injective z
    simpa using this
  have hz' : orderOf (⟨z, hzN⟩ : N) = r := by rw [Subgroup.orderOf_mk]; exact hz
  have := mem_zpowers_of_orderOf_eq hr hy hz'
  obtain ⟨k, hk⟩ := this
  exact ⟨k, by simpa using congrArg Subtype.val hk⟩

theorem addRight_zpow_apply {r : ℕ} (a : ZMod r) (k : ℤ) (x : ZMod r) :
    ((Equiv.addRight a) ^ k) x = x + (k : ZMod r) * a := by
  induction k using Int.induction_on generalizing x with
  | zero => simp
  | succ n ih =>
    rw [zpow_add_one, Equiv.Perm.mul_apply, ih]
    simp only [Equiv.coe_addRight]; push_cast; ring
  | pred n ih =>
    rw [zpow_sub_one, Equiv.Perm.mul_apply, ih]
    simp only [Equiv.Perm.inv_def, Equiv.addRight_symm, Equiv.coe_addRight]; push_cast; ring

/-- **Step 3 of the route, as a permutation statement**: a permutation of ZMod r conjugating
the shift x ↦ x + 1 to one of its powers x ↦ x + k is affine, x ↦ k·x + f(0). -/
theorem affine_of_normalizes {r : ℕ} [NeZero r] (f : Equiv.Perm (ZMod r)) (k : ℤ)
    (hf : f * Equiv.addRight (1 : ZMod r) * f⁻¹ = (Equiv.addRight (1 : ZMod r)) ^ k) :
    ∀ x, f x = (k : ZMod r) * x + f 0 := by
  apply affine_of_shift
  intro x
  have := congrArg (fun g : Equiv.Perm (ZMod r) => g (f x)) hf
  simp only [Equiv.Perm.mul_apply, Equiv.Perm.inv_def, Equiv.symm_apply_apply,
    Equiv.coe_addRight, addRight_zpow_apply, mul_one] at this
  exact this

end LemmaB

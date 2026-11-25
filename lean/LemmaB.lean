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
(3).  `lemmaB_block_any` drops r ≠ q: if the middle layer acts trivially, H is a q-group of
degree r, so r = q, |H| = r (r² ∤ r!) and H = ⟨z⟩ is affine outright.
**Assembled** in `lemmaB_block`: for a transitive group H on ZMod r with an Oliver chain and
r ∉ {p, q}, there is a relabelling E with every E⁻¹hE affine.  `D2Full.lean` transports this to
all F blocks through a transversal.
-/
import Mathlib
import Chain

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

/-! ### Lemma B on one prime block, assembled -/

/-- **The final step of Lemma B, abstracted**: if H contains z of order r normalised by every
element (h z h⁻¹ ∈ ⟨z⟩), then after relabelling by z every element of H is affine. -/
theorem affine_of_normal_cycle {r : ℕ} [Fact r.Prime] (H : Subgroup (Equiv.Perm (ZMod r)))
    (z : H) (hz : orderOf z = r) (hconj : ∀ h : H, h * z * h⁻¹ ∈ Subgroup.zpowers z) :
    ∃ E : Equiv.Perm (ZMod r), ∀ h ∈ H, ∃ a b : ZMod r, a ≠ 0 ∧
      ∀ x, (E⁻¹ * h * E) x = a * x + b := by
  classical
  have hr : r.Prime := Fact.out
  have : NeZero r := ⟨hr.ne_zero⟩
  -- z is an r-cycle moving every point
  set σ : Equiv.Perm (ZMod r) := (z : Equiv.Perm (ZMod r)) with hσdef
  have hσo : orderOf σ = r := by rw [Subgroup.orderOf_coe]; exact hz
  have hσc : σ.IsCycle := Equiv.Perm.isCycle_of_prime_order'' (by rw [ZMod.card]; exact hr)
    (by rw [ZMod.card]; exact hσo)
  have hmove : ∀ x, σ x ≠ x := by
    have hs : σ.support = Finset.univ := by
      apply Finset.eq_univ_of_card
      rw [← hσc.orderOf, hσo, ZMod.card]
    intro x
    rw [← Equiv.Perm.mem_support, hs]
    exact Finset.mem_univ x
  -- coordinates: k ↦ σ^k 0
  let e : ZMod r → ZMod r := fun k => (σ ^ k.val) 0
  have he : Function.Injective e := by
    have key : ∀ a b : ZMod r, a.val ≤ b.val → e a = e b → a = b := by
      intro a b hab heq
      have h1 : (σ ^ (b.val - a.val)) ((σ ^ a.val) 0) = (σ ^ a.val) 0 := by
        rw [← Equiv.Perm.mul_apply, ← pow_add, Nat.sub_add_cancel hab]
        exact heq.symm
      have h2 := (hσc.pow_eq_one_iff' (hmove ((σ ^ a.val) 0))).mpr h1
      have h3 := orderOf_dvd_of_pow_eq_one h2
      rw [hσo] at h3
      have h4 : b.val - a.val < r := by have := ZMod.val_lt b; omega
      have h5 : b.val - a.val = 0 := Nat.eq_zero_of_dvd_of_lt h3 h4
      exact ZMod.val_injective r (by omega)
    intro a b hab
    rcases le_total a.val b.val with h | h
    · exact key a b h hab
    · exact (key b a h hab.symm).symm
  let E : Equiv.Perm (ZMod r) := Equiv.ofBijective e (Finite.injective_iff_bijective.mp he)
  have hE : E⁻¹ * σ * E = Equiv.addRight (1 : ZMod r) := by
    ext k
    simp only [Equiv.Perm.mul_apply, Equiv.coe_addRight]
    rw [Equiv.Perm.inv_eq_iff_eq]
    simp only [E, Equiv.ofBijective_apply, e]
    rw [← Equiv.Perm.mul_apply, ← pow_succ', ← pow_mod_orderOf, hσo, ZMod.val_add,
      ZMod.val_one]
  refine ⟨E, fun h hh => ?_⟩
  obtain ⟨m, hm⟩ := hconj ⟨h, hh⟩
  have hm' : σ ^ m = h * σ * h⁻¹ := by
    have := congrArg (fun x : H => (x : Equiv.Perm (ZMod r))) hm
    simpa using this
  set f := E⁻¹ * h * E
  have hf : f * Equiv.addRight (1 : ZMod r) * f⁻¹ = (Equiv.addRight (1 : ZMod r)) ^ m := by
    rw [← hE]
    have : (E⁻¹ * σ * E) ^ m = E⁻¹ * σ ^ m * E := by
      have := map_zpow (MulAut.conj E⁻¹) σ m
      simpa [MulAut.conj_apply] using this.symm
    rw [this, hm']
    simp only [f]
    group
  have haff := affine_of_normalizes f m hf
  refine ⟨m, f 0, ?_, haff⟩
  intro hm0
  have h01 : f 0 = f 1 := by rw [haff 1, hm0]; simp
  have := f.injective h01
  exact zero_ne_one this


/-- **Lemma B for a block of prime size.**  A group H of permutations of ZMod r, transitive,
with an Oliver chain (p, q) and r ∉ {p, q}, is affine after a relabelling E of the points:
every E⁻¹hE is x ↦ a·x + b with a ≠ 0.

Route: the bottom layer acts trivially (`normal_pgroup_trivial`), so the middle layer is
cyclic; Cauchy gives z of order r, which lies in the middle layer (`Chain.rsub_le_N₁`), so every
h conjugates z to a power of z (`conj_mem_zpowers`); z is an r-cycle, and labelling the points
by z gives the coordinates in which z is x ↦ x + 1; then `affine_of_normalizes`. -/
theorem lemmaB_block {r p q : ℕ} [Fact r.Prime] (H : Subgroup (Equiv.Perm (ZMod r)))
    (C : Chain.OliverChain H p q) (hp : p.Prime) (hq : q.Prime) (hrp : r ≠ p) (hrq : r ≠ q)
    (htr : ∀ x y : ZMod r, ∃ h ∈ H, h x = y) :
    ∃ E : Equiv.Perm (ZMod r), ∀ h ∈ H, ∃ a b : ZMod r, a ≠ 0 ∧
      ∀ x, (E⁻¹ * h * E) x = a * x + b := by
  classical
  have hr : r.Prime := Fact.out
  have : NeZero r := ⟨hr.ne_zero⟩
  have hpre : MulAction.IsPretransitive H (ZMod r) :=
    ⟨fun x y => by obtain ⟨h, hh, hy⟩ := htr x y; exact ⟨⟨h, hh⟩, hy⟩⟩
  -- the bottom layer acts trivially
  have hN2 : ∀ n : H, n ∈ C.N₂ → n = 1 := by
    have := C.n₂
    intro n hn
    have h := normal_pgroup_trivial (G := H) (X := ZMod r) hr hp (Ne.symm hrp)
      (by rw [Nat.card_zmod]) C.N₂ C.bot n hn
    apply Subtype.ext
    ext x
    exact h x
  -- so the middle layer is cyclic
  have hcyc : IsCyclic C.N₁ := by
    have := C.n₂
    have : (C.N₂.subgroupOf C.N₁).Normal := Subgroup.normal_subgroupOf
    have := C.layer
    let f : C.N₁ →* C.N₁ ⧸ C.N₂.subgroupOf C.N₁ := QuotientGroup.mk' _
    have hf : Function.Injective f := by
      rw [← MonoidHom.ker_eq_bot_iff, eq_bot_iff]
      intro x hx
      rw [MonoidHom.mem_ker, QuotientGroup.mk'_apply, QuotientGroup.eq_one_iff,
        Subgroup.mem_subgroupOf] at hx
      rw [Subgroup.mem_bot]
      exact Subtype.ext (hN2 _ hx)
    exact isCyclic_of_injective f hf
  -- an element z of order r, in the middle layer
  have : Fintype H := Fintype.ofFinite H
  have hdvd : r ∣ Fintype.card H := by
    rw [← Nat.card_eq_fintype_card]
    have h1 := MulAction.index_stabilizer_of_transitive H (0 : ZMod r)
    rw [Nat.card_zmod] at h1
    have h2 := Subgroup.index_dvd_card (MulAction.stabilizer H (0 : ZMod r))
    rwa [h1] at h2
  obtain ⟨z, hz⟩ := exists_prime_orderOf_dvd_card r hdvd
  have hzP : IsPGroup r (Subgroup.zpowers z) :=
    IsPGroup.of_card (n := 1) (by rw [Nat.card_zpowers, hz, pow_one])
  have hzN1 : z ∈ C.N₁ := Chain.rsub_le_N₁ C hr hq hrq hzP (Subgroup.mem_zpowers z)
  have hconj : ∀ h : H, h * z * h⁻¹ ∈ Subgroup.zpowers z := by
    have := C.n₁
    exact conj_mem_zpowers C.N₁ hr.pos hzN1 hz
  exact affine_of_normal_cycle H z hz hconj

/-- **Lemma B for a prime block, any r ≠ p** (r = q allowed).  If the middle layer acts
nontrivially it is transitive and cyclic, and supplies z; if it acts trivially then H is a
q-group of degree r, so r = q, |H| = r (r² ∤ r!) and H = ⟨z⟩. -/
theorem lemmaB_block_any {r p q : ℕ} [Fact r.Prime] (H : Subgroup (Equiv.Perm (ZMod r)))
    (C : Chain.OliverChain H p q) (hp : p.Prime) (hq : q.Prime) (hrp : r ≠ p)
    (htr : ∀ x y : ZMod r, ∃ h ∈ H, h x = y) :
    ∃ E : Equiv.Perm (ZMod r), ∀ h ∈ H, ∃ a b : ZMod r, a ≠ 0 ∧
      ∀ x, (E⁻¹ * h * E) x = a * x + b := by
  classical
  have hr : r.Prime := Fact.out
  have : NeZero r := ⟨hr.ne_zero⟩
  have hpre : MulAction.IsPretransitive H (ZMod r) :=
    ⟨fun x y => by obtain ⟨h, hh, hy⟩ := htr x y; exact ⟨⟨h, hh⟩, hy⟩⟩
  have hprim : MulAction.IsPreprimitive H (ZMod r) :=
    MulAction.IsPreprimitive.of_prime_card (by rw [Nat.card_zmod]; exact hr)
  have hN2 : ∀ n : H, n ∈ C.N₂ → n = 1 := by
    have := C.n₂
    intro n hn
    have h := normal_pgroup_trivial (G := H) (X := ZMod r) hr hp (Ne.symm hrp)
      (by rw [Nat.card_zmod]) C.N₂ C.bot n hn
    apply Subtype.ext
    ext x
    exact h x
  have hcyc : IsCyclic C.N₁ := by
    have := C.n₂
    have : (C.N₂.subgroupOf C.N₁).Normal := Subgroup.normal_subgroupOf
    have := C.layer
    let f : C.N₁ →* C.N₁ ⧸ C.N₂.subgroupOf C.N₁ := QuotientGroup.mk' _
    have hf : Function.Injective f := by
      rw [← MonoidHom.ker_eq_bot_iff, eq_bot_iff]
      intro x hx
      rw [MonoidHom.mem_ker, QuotientGroup.mk'_apply, QuotientGroup.eq_one_iff,
        Subgroup.mem_subgroupOf] at hx
      rw [Subgroup.mem_bot]
      exact Subtype.ext (hN2 _ hx)
    exact isCyclic_of_injective f hf
  have : Fintype H := Fintype.ofFinite H
  by_cases hN1 : ∃ n ∈ C.N₁, n ≠ 1
  · -- the middle layer acts nontrivially, hence transitively
    obtain ⟨n, hn, hn1⟩ := hN1
    have := C.n₁
    have hfix : MulAction.fixedPoints C.N₁ (ZMod r) ≠ Set.univ := by
      intro h
      apply hn1
      apply Subtype.ext; ext x
      have : x ∈ MulAction.fixedPoints C.N₁ (ZMod r) := h ▸ Set.mem_univ x
      exact this ⟨n, hn⟩
    have htrN : MulAction.IsPretransitive C.N₁ (ZMod r) :=
      MulAction.IsQuasiPreprimitive.isPretransitive_of_normal hfix
    have hdvd : r ∣ Nat.card C.N₁ := by
      have h1 := MulAction.index_stabilizer_of_transitive C.N₁ (0 : ZMod r)
      rw [Nat.card_zmod] at h1
      have h2 := Subgroup.index_dvd_card (MulAction.stabilizer C.N₁ (0 : ZMod r))
      rwa [h1] at h2
    have : Fintype C.N₁ := Fintype.ofFinite _
    obtain ⟨y, hy⟩ := exists_prime_orderOf_dvd_card (G := C.N₁) r
      (by rwa [← Nat.card_eq_fintype_card])
    have hz : orderOf (y : H) = r := by rw [Subgroup.orderOf_coe]; exact hy
    exact affine_of_normal_cycle H y hz (conj_mem_zpowers C.N₁ hr.pos y.2 hz)
  · -- the middle layer is trivial: H is a q-group, so r = q and H = ⟨z⟩
    push Not at hN1
    have hqH : IsPGroup q H := by
      have := C.n₁
      apply C.top.of_injective (QuotientGroup.mk' C.N₁)
      rw [← MonoidHom.ker_eq_bot_iff, QuotientGroup.ker_mk', eq_bot_iff]
      intro x hx
      rw [Subgroup.mem_bot]; exact hN1 x hx
    have hdvd : r ∣ Fintype.card H := by
      rw [← Nat.card_eq_fintype_card]
      have h1 := MulAction.index_stabilizer_of_transitive H (0 : ZMod r)
      rw [Nat.card_zmod] at h1
      have h2 := Subgroup.index_dvd_card (MulAction.stabilizer H (0 : ZMod r))
      rwa [h1] at h2
    obtain ⟨z, hz⟩ := exists_prime_orderOf_dvd_card r hdvd
    -- |H| ≤ r: |H| = qᵏ divides r!, and r² ∤ r!
    have hHle : Nat.card H ≤ r := by
      have : Fact q.Prime := ⟨hq⟩
      obtain ⟨k, hk⟩ := hqH.exists_card_eq
      have hzq : r ∣ q ^ k := by
        have := orderOf_dvd_natCard z
        rw [hz, hk] at this; exact this
      have hrq : r = q := (Nat.prime_dvd_prime_iff_eq hr hq).mp (hr.dvd_of_dvd_pow hzq)
      subst hrq
      have hfac : Nat.card H ∣ r.factorial := by
        have := Subgroup.card_subgroup_dvd_card H
        rwa [Nat.card_perm, Nat.card_zmod] at this
      rcases Nat.lt_or_ge k 2 with hk2 | hk2
      · interval_cases k
        · rw [hk, pow_zero]; exact hr.one_lt.le
        · rw [hk, pow_one]
      · exfalso
        have h2 : r ^ 2 ∣ r.factorial := (pow_dvd_pow r hk2).trans (hk ▸ hfac)
        have h3 : r.factorial = r * (r - 1).factorial := (Nat.mul_factorial_pred hr.ne_zero).symm
        rw [h3, pow_two] at h2
        have h4 : r ∣ (r - 1).factorial := Nat.dvd_of_mul_dvd_mul_left hr.pos h2
        have h5 := (hr.dvd_factorial).mp h4
        have := hr.one_lt
        omega
    have htop : Subgroup.zpowers z = ⊤ := by
      apply Subgroup.eq_top_of_card_eq
      apply le_antisymm (Subgroup.card_le_card_group _)
      rw [Nat.card_zpowers, hz]; exact hHle
    refine affine_of_normal_cycle H z hz (fun h => ?_)
    have hh : h ∈ Subgroup.zpowers z := htop ▸ Subgroup.mem_top h
    obtain ⟨m, rfl⟩ := hh
    rw [show z ^ m * z * (z ^ m)⁻¹ = z by group]
    exact Subgroup.mem_zpowers z

end LemmaB

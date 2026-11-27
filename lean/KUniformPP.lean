/-
# `KUniformPP.lean` — the k-set stabiliser bound for prime-power blocks

`general-k-note.md` §1 (Proposition 1, the lower-bound half) and §§2.1–2.2.  A block 𝔽_q (q = p^a)
carries H_W = {x ↦ u·x + v : u ∈ W, v ∈ 𝔽_q}, W ≤ 𝔽_q^× of order d.  For 1 ≤ k < q:

* `card_stab_le`: **a k-set stabiliser has order ≤ τ_k·θ_k(d)**, with τ_k = p^{v_p(k)} (`tau`) and
  θ_k(d) from `KUniform`.  The filtration: the translations in the stabiliser form a p-group acting
  freely on the k-set, so their number is a power of p dividing k; the multipliers form a cyclic
  subgroup of W whose generator lifts to an element with one fixed point x₀, acting freely off x₀,
  so its order divides k or k − 1.
* `orbit_lower`: **every orbit has size ≥ q·d/(τ_k·θ_k(d))**.

With a Galois layer of order m on top, orbits only grow, so this is Proposition 1's bound
q·d·m/(τθγ) in the generic case γ = m.  At q prime τ_k = 1 for k < q and this is
`KUniform.orbit_lower`.  Attainment (the "joint attainment" of the note) is not claimed here.
-/
import KUniform

set_option linter.unusedSectionVars false

namespace KUnifPP
open Equiv Finset Pointwise MulAction KUnif

/-- τ_k: the p-part of k. -/
def tau (p k : ℕ) : ℕ := p ^ k.factorization p

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- x ↦ u·x + v. -/
def aff (u : Fˣ) (v : F) : Perm F where
  toFun x := u * x + v
  invFun x := (u⁻¹ : Fˣ) * (x - v)
  left_inv x := by
    show ((u⁻¹ : Fˣ) : F) * (u * x + v - v) = x
    rw [add_sub_cancel_right, ← mul_assoc, ← Units.val_mul, inv_mul_cancel, Units.val_one, one_mul]
  right_inv x := by
    show (u : F) * (((u⁻¹ : Fˣ) : F) * (x - v)) + v = x
    rw [← mul_assoc, ← Units.val_mul, mul_inv_cancel, Units.val_one, one_mul, sub_add_cancel]

@[simp] theorem aff_apply (u : Fˣ) (v x : F) : aff u v x = u * x + v := rfl

theorem aff_mul (u u' : Fˣ) (v v' : F) : aff u v * aff u' v' = aff (u * u') (u * v' + v) := by
  ext x; simp [Perm.mul_apply]; ring

theorem aff_one : aff (1 : Fˣ) 0 = 1 := by ext x; simp

theorem aff_inv (u : Fˣ) (v : F) : (aff u v)⁻¹ = aff u⁻¹ (-((u⁻¹ : Fˣ) * v)) := by
  rw [inv_eq_iff_mul_eq_one, aff_mul, mul_inv_cancel]
  ext x
  simp only [aff_apply, Units.val_one, one_mul, Perm.one_apply]
  rw [mul_neg, ← mul_assoc, ← Units.val_mul, mul_inv_cancel, Units.val_one, one_mul,
    neg_add_cancel, add_zero]

theorem aff_inj {u u' : Fˣ} {v v' : F} (h : aff u v = aff u' v') : u = u' ∧ v = v' := by
  have h0 := congrArg (· 0) h
  have h1 := congrArg (· 1) h
  simp at h0 h1
  subst h0
  exact ⟨Units.ext (by simpa using h1), rfl⟩

theorem aff_one_pow (v : F) (n : ℕ) : aff 1 v ^ n = aff 1 (n * v) := by
  induction n with
  | zero => simp [aff_one]
  | succ n ih => rw [pow_succ, ih, aff_mul]; congr 1 <;> simp; ring

variable (W : Subgroup Fˣ)

/-- H_W: translations and the twist W. -/
def H : Subgroup (Perm F) where
  carrier := {σ | ∃ u ∈ W, ∃ v, σ = aff u v}
  mul_mem' := by
    rintro _ _ ⟨u, hu, v, rfl⟩ ⟨u', hu', v', rfl⟩
    exact ⟨u * u', W.mul_mem hu hu', _, aff_mul u u' v v'⟩
  one_mem' := ⟨1, W.one_mem, 0, aff_one.symm⟩
  inv_mem' := by
    rintro _ ⟨u, hu, v, rfl⟩
    exact ⟨u⁻¹, W.inv_mem hu, _, aff_inv u v⟩

theorem card_H : Nat.card (H W) = Fintype.card F * Nat.card W := by
  have hbij : Function.Bijective (fun w : W × F => (⟨aff w.1 w.2, w.1, w.1.2, w.2, rfl⟩ : H W)) := by
    constructor
    · rintro ⟨⟨u, hu⟩, v⟩ ⟨⟨u', hu'⟩, v'⟩ h
      have := aff_inj (congrArg Subtype.val h)
      simp only [Prod.mk.injEq, Subtype.mk.injEq]
      exact ⟨this.1, this.2⟩
    · rintro ⟨σ, u, hu, v, rfl⟩
      exact ⟨(⟨u, hu⟩, v), rfl⟩
  rw [← Nat.card_congr (Equiv.ofBijective _ hbij), Nat.card_prod, Nat.card_eq_fintype_card (α := F),
    Nat.mul_comm]

theorem smul_eq_image (h : H W) (S : Finset F) : h • S = S.image (h : Perm F) := by
  rw [Finset.smul_finset_def]; rfl

theorem mem_stab {h : H W} {S : Finset F} :
    h ∈ stabilizer (H W) S ↔ S.image (h : Perm F) = S := by
  rw [mem_stabilizer_iff, smul_eq_image]

/-- The multiplier of an element of H_W. -/
noncomputable def mulPart (h : H W) : Fˣ := Classical.choose h.2

theorem mulPart_spec (h : H W) : mulPart W h ∈ W ∧ ∃ v, (h : Perm F) = aff (mulPart W h) v :=
  Classical.choose_spec h.2

theorem mulPart_eq {h : H W} {u : Fˣ} {v : F} (he : (h : Perm F) = aff u v) : mulPart W h = u := by
  obtain ⟨-, v', hv'⟩ := mulPart_spec W h
  exact (aff_inj (hv'.symm.trans he)).1

/-- The multiplier as a homomorphism H_W → 𝔽_q^×. -/
noncomputable def ψ : H W →* Fˣ where
  toFun := mulPart W
  map_one' := mulPart_eq W (h := 1) (v := 0) aff_one.symm
  map_mul' a b := by
    obtain ⟨-, v, hv⟩ := mulPart_spec W a
    obtain ⟨-, v', hv'⟩ := mulPart_spec W b
    apply mulPart_eq W (v := mulPart W a * v' + v)
    rw [Subgroup.coe_mul, hv, hv', aff_mul]

theorem ψ_mem (h : H W) : ψ W h ∈ W := (mulPart_spec W h).1

theorem eq_aff (h : H W) : ∃ v, (h : Perm F) = aff (ψ W h) v := (mulPart_spec W h).2

/-- An element with multiplier 1 that fixes a point is the identity. -/
theorem eq_one_of_fix {h : H W} (hψ : ψ W h = 1) {y : F} (hy : (h : Perm F) y = y) : h = 1 := by
  obtain ⟨v, hv⟩ := eq_aff W h
  rw [hψ] at hv
  rw [hv, aff_apply, Units.val_one, one_mul] at hy
  have : v = 0 := by simpa using hy
  subst this
  exact Subtype.ext (by rw [hv, aff_one]; rfl)

/-- An element fixing two distinct points has multiplier 1. -/
theorem ψ_eq_one_of_two {h : H W} {x y : F} (hxy : y ≠ x) (hx : (h : Perm F) x = x)
    (hy : (h : Perm F) y = y) : ψ W h = 1 := by
  obtain ⟨w, hw⟩ := eq_aff W h
  rw [hw, aff_apply] at hx hy
  have hd' : ((ψ W h : F) - 1) * (y - x) = 0 := by linear_combination hy - hx
  exact Units.ext (by
    have := (mul_eq_zero.mp hd').resolve_right (sub_ne_zero.mpr hxy)
    simp only [Units.val_one]; linear_combination this)

/-- **The stabiliser bound**: for p the characteristic and 1 ≤ k < q, a k-set has stabiliser of
order at most τ_k·θ_k(d). -/
theorem card_stab_le (p : ℕ) [Fact p.Prime] [CharP F p] (S : Finset F) (hk1 : 1 ≤ S.card) :
    Nat.card (stabilizer (H W) S) ≤ tau p S.card * theta S.card (Nat.card W) := by
  classical
  have hp := (Fact.out : p.Prime)
  set K := stabilizer (H W) S
  have hd : 0 < Nat.card W := Nat.card_pos
  set f : K →* Fˣ := (ψ W).comp K.subtype
  set N := f.ker
  have hKN : Nat.card K = Nat.card N * Nat.card f.range := by
    rw [← Subgroup.index_ker, Subgroup.card_mul_index]
  -- (1) translations: |N| is a power of p dividing k
  have hN : Nat.card N ≤ tau p S.card := by
    have hfix : ∀ (n : N) (y : F), y ∈ S → (n.1.1 : Perm F) y ∈ S := fun n y hy => by
      rw [← (mem_stab W).mp n.1.2]; exact Finset.mem_image_of_mem _ hy
    let Y := {y // y ∈ S}
    let act : MulAction N Y :=
      { smul := fun n y => ⟨(n.1.1 : Perm F) y.1, hfix n y.1 y.2⟩
        one_smul := fun y => rfl
        mul_smul := fun a b y => rfl }
    have hfree : ∀ (n : N) (y : Y), n • y = y → n = 1 := fun n y hy => by
      have h1 : n.1.1 = 1 := eq_one_of_fix W (h := n.1.1) (n.2) (congrArg Subtype.val hy)
      exact Subtype.ext (Subtype.ext h1)
    have hdvd := card_dvd_of_free hfree
    have hY : Nat.card Y = S.card := by rw [Nat.card_eq_fintype_card]; exact Fintype.card_coe _
    rw [hY] at hdvd
    have hpg : IsPGroup p N := fun n => ⟨1, by
      obtain ⟨v, hv⟩ := eq_aff W n.1.1
      have h1 : ψ W n.1.1 = 1 := n.2
      rw [h1] at hv
      have key : (n.1.1 : Perm F) ^ p = 1 := by
        rw [hv, aff_one_pow, CharP.cast_eq_zero, zero_mul, aff_one]
      rw [pow_one]
      apply Subtype.val_injective; apply Subtype.val_injective
      apply Subtype.val_injective
      simpa using key⟩
    obtain ⟨n, hn⟩ := (IsPGroup.iff_card).mp hpg
    rw [hn] at hdvd ⊢
    have := (hp.pow_dvd_iff_le_factorization (by omega)).mp hdvd
    exact Nat.pow_le_pow_right hp.pos this
  -- (2) multipliers: |range f| ≤ θ_k(d)
  have hR : Nat.card f.range ≤ theta S.card (Nat.card W) := by
    have hRd : Nat.card f.range ∣ Nat.card W := by
      have : f.range ≤ W := by rintro _ ⟨h, rfl⟩; exact ψ_mem W h.1
      exact Subgroup.card_dvd_of_le this
    obtain ⟨r, hr⟩ := IsCyclic.exists_generator (α := f.range)
    have hcardR : Nat.card f.range = orderOf r := (orderOf_eq_card_of_forall_mem_zpowers hr).symm
    obtain ⟨g, hg⟩ := r.2
    set u := f g
    have hur : orderOf u = orderOf r := by rw [hg]; exact Subgroup.orderOf_coe r
    by_cases hu : u = 1
    · have : Nat.card f.range = 1 := by rw [hcardR, ← hur, hu, orderOf_one]
      rw [this]; exact theta_pos hd
    -- the fixed point of g
    obtain ⟨v, hv⟩ := eq_aff W g.1
    have hfu : f g = ψ W g.1 := rfl
    have hu1 : (1 : F) - (u : F) ≠ 0 := by
      intro h0; apply hu; apply Units.ext; simp only [Units.val_one]; linear_combination -h0
    set x0 := v * (1 - (u : F))⁻¹
    have hgx0 : (g.1.1 : Perm F) x0 = x0 := by
      rw [hv, aff_apply, ← hfu]; simp only [x0]; field_simp; ring
    -- powers of g
    set Z := Subgroup.zpowers g
    have hZx0 : ∀ z : Z, (z.1.1.1 : Perm F) x0 = x0 := by
      rintro ⟨z, j, rfl⟩
      simp only [Subgroup.coe_zpow]
      exact Equiv.Perm.zpow_apply_eq_self_of_apply_eq_self hgx0 j
    have hmapS : ∀ (z : Z) (y : F), y ∈ S.erase x0 → (z.1.1.1 : Perm F) y ∈ S.erase x0 := by
      intro z y hy
      rw [Finset.mem_erase] at hy ⊢
      refine ⟨fun he => hy.1 ((z.1.1.1 : Perm F).injective (he.trans (hZx0 z).symm)), ?_⟩
      rw [← (mem_stab W).mp z.1.2]
      exact Finset.mem_image_of_mem _ hy.2
    let Y := {y // y ∈ S.erase x0}
    let act : MulAction Z Y :=
      { smul := fun z y => ⟨(z.1.1.1 : Perm F) y.1, hmapS z y.1 y.2⟩
        one_smul := fun y => rfl
        mul_smul := fun a b y => rfl }
    have hfree : ∀ (z : Z) (y : Y), z • y = y → z = 1 := fun z y hy => by
      have hy' : (z.1.1.1 : Perm F) y.1 = y.1 := congrArg Subtype.val hy
      have h1 := ψ_eq_one_of_two W (Finset.mem_erase.mp y.2).1 (hZx0 z) hy'
      have h2 := eq_one_of_fix W h1 hy'
      exact Subtype.ext (Subtype.ext h2)
    have hdvd := card_dvd_of_free hfree
    have hY : Nat.card Y = (S.erase x0).card := by
      rw [Nat.card_eq_fintype_card]; exact Fintype.card_coe _
    rw [hY, Nat.card_zpowers] at hdvd
    have hord : Nat.card f.range ∣ orderOf g := by
      rw [hcardR, ← hur]; exact orderOf_map_dvd f g
    have hdv := hord.trans hdvd
    apply le_theta hd hRd
    by_cases hx0 : x0 ∈ S
    · right; rwa [Finset.card_erase_of_mem hx0] at hdv
    · left; rwa [Finset.erase_eq_of_notMem hx0] at hdv
  rw [hKN]
  exact Nat.mul_le_mul hN hR

/-- **Proposition 1, lower half (generic Galois case)**: every orbit of H_W on k-sets has size at
least q·d/(τ_k·θ_k(d)). -/
theorem orbit_lower (p : ℕ) [Fact p.Prime] [CharP F p] (S : Finset F) (hk1 : 1 ≤ S.card) :
    Fintype.card F * Nat.card W ≤
      tau p S.card * theta S.card (Nat.card W) * (orbit (H W) S).ncard := by
  rw [← card_H, ← Subgroup.card_mul_index (stabilizer (H W) S), index_stabilizer]
  exact Nat.mul_le_mul_right _ (card_stab_le W p S hk1)

/-- At prime-order fields and k < p, τ_k = 1. -/
theorem tau_eq_one {p k : ℕ} (hk1 : 1 ≤ k) (hkp : k < p) : tau p k = 1 := by
  unfold tau
  rw [Nat.factorization_eq_zero_of_not_dvd (fun h => absurd (Nat.le_of_dvd (by omega) h) (by omega)),
    pow_zero]

end KUnifPP

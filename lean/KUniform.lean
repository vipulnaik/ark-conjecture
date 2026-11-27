/-
# `KUniform.lean` — the k-uniform orbit law for prime blocks

`three-uniform-note.md` §2.1 and `general-k-note.md` §2.2.  A block of prime size c carries the
affine group H_W = {x ↦ u·x + v : u ∈ W, v ∈ 𝔽_c}, W ≤ 𝔽_c^× of order d (the twist).  For
1 ≤ k < c, on k-subsets:

* `orbit_lower`: **every orbit has size ≥ c·d / θ_k(d)**, θ_k(d) = the largest j ∣ d with
  j ∣ k or j ∣ k − 1 (`theta`).  A stabiliser of a k-set contains no translation, so it embeds in
  W, is abelian, and its nontrivial elements share one fixed point x₀; it acts freely on the
  k-set minus x₀, so its order divides k or k − 1 — and it divides d.
* `orbit_attained`: **some k-set has orbit exactly c·d / θ_k(d)** — a union of cosets of the
  order-θ subgroup of W, plus 0 when θ ∤ k.

So orb_k(c, d, 1) = c·d/θ_k(d) (the C(c,k) cap is automatic: an orbit is a set of k-sets), and at
k = 3, θ₃(d) = 3 if 3 ∣ d, else 2 if 2 ∣ d, else 1 — the note's κ (`theta_three`); at k = 2 it is
the familiar 2 if 2 ∣ d, else 1 (`theta_two`).
-/
import Mathlib

set_option linter.unusedSectionVars false

namespace KUnif
open Equiv Finset Pointwise MulAction

/-! ## θ_k(d) -/

/-- θ_k(d): the largest j ∣ d with j ∣ k or j ∣ k − 1. -/
def theta (k d : ℕ) : ℕ :=
  ((Finset.range (d + 1)).filter (fun j => j ∣ d ∧ (j ∣ k ∨ j ∣ k - 1))).sup id

theorem le_theta {k d j : ℕ} (hd : 0 < d) (hj : j ∣ d) (hk : j ∣ k ∨ j ∣ k - 1) : j ≤ theta k d := by
  apply Finset.le_sup (f := id)
  simp only [Finset.mem_filter, Finset.mem_range]
  exact ⟨Nat.lt_succ_of_le (Nat.le_of_dvd hd hj), hj, hk⟩

theorem theta_spec {k d : ℕ} (hd : 0 < d) :
    theta k d ∣ d ∧ (theta k d ∣ k ∨ theta k d ∣ k - 1) := by
  have hne : ((Finset.range (d + 1)).filter (fun j => j ∣ d ∧ (j ∣ k ∨ j ∣ k - 1))).Nonempty :=
    ⟨1, by simp; omega⟩
  obtain ⟨j, hj, hjeq⟩ := Finset.exists_mem_eq_sup _ hne id
  simp only [Finset.mem_filter] at hj
  unfold theta
  rw [hjeq]; exact hj.2

theorem theta_pos {k d : ℕ} (hd : 0 < d) : 0 < theta k d :=
  lt_of_lt_of_le one_pos (le_theta hd (one_dvd d) (Or.inl (one_dvd k)))

/-- At k = 3: θ = 3 if 3 ∣ d, else 2 if 2 ∣ d, else 1 — `three-uniform-note.md`'s κ. -/
theorem theta_three (d : ℕ) (hd : 0 < d) :
    theta 3 d = if 3 ∣ d then 3 else if 2 ∣ d then 2 else 1 := by
  obtain ⟨h1, h2⟩ := theta_spec (k := 3) hd
  have hle : theta 3 d ≤ 3 := by
    rcases h2 with h | h
    · exact Nat.le_of_dvd (by norm_num) h
    · exact le_trans (Nat.le_of_dvd (by norm_num) h) (by norm_num)
  have hpos := theta_pos (k := 3) hd
  split_ifs with h3 h2'
  · exact le_antisymm hle (le_theta hd h3 (Or.inl dvd_rfl))
  · apply le_antisymm _ (le_theta hd h2' (Or.inr (by norm_num)))
    interval_cases h : theta 3 d <;> simp_all
  · interval_cases h : theta 3 d <;> simp_all

/-- At k = 2: θ = 2 if 2 ∣ d, else 1 — the k = 2 law's halving. -/
theorem theta_two (d : ℕ) (hd : 0 < d) : theta 2 d = if 2 ∣ d then 2 else 1 := by
  obtain ⟨h1, h2⟩ := theta_spec (k := 2) hd
  have hle : theta 2 d ≤ 2 := by
    rcases h2 with h | h
    · exact Nat.le_of_dvd (by norm_num) h
    · exact le_trans (Nat.le_of_dvd (by norm_num) h) (by norm_num)
  have hpos := theta_pos (k := 2) hd
  split_ifs with h2'
  · exact le_antisymm hle (le_theta hd h2' (Or.inl dvd_rfl))
  · interval_cases h : theta 2 d <;> simp_all

/-! ## The affine group H_W -/

variable {c : ℕ} [Fact c.Prime]

/-- x ↦ u·x + v. -/
def aff (u : (ZMod c)ˣ) (v : ZMod c) : Perm (ZMod c) where
  toFun x := u * x + v
  invFun x := (u⁻¹ : (ZMod c)ˣ) * (x - v)
  left_inv x := by
    show ((u⁻¹ : (ZMod c)ˣ) : ZMod c) * (u * x + v - v) = x
    rw [add_sub_cancel_right, ← mul_assoc, ← Units.val_mul, inv_mul_cancel, Units.val_one, one_mul]
  right_inv x := by
    show (u : ZMod c) * (((u⁻¹ : (ZMod c)ˣ) : ZMod c) * (x - v)) + v = x
    rw [← mul_assoc, ← Units.val_mul, mul_inv_cancel, Units.val_one, one_mul, sub_add_cancel]

@[simp] theorem aff_apply (u : (ZMod c)ˣ) (v x : ZMod c) : aff u v x = u * x + v := rfl

theorem aff_mul (u u' : (ZMod c)ˣ) (v v' : ZMod c) :
    aff u v * aff u' v' = aff (u * u') (u * v' + v) := by
  ext x; simp [Perm.mul_apply]; ring

theorem aff_one : aff (1 : (ZMod c)ˣ) 0 = 1 := by ext x; simp

theorem aff_inv (u : (ZMod c)ˣ) (v : ZMod c) : (aff u v)⁻¹ = aff u⁻¹ (-((u⁻¹ : (ZMod c)ˣ) * v)) := by
  rw [inv_eq_iff_mul_eq_one, aff_mul, mul_inv_cancel]
  ext x
  simp only [aff_apply, Units.val_one, one_mul, Perm.one_apply]
  rw [mul_neg, ← mul_assoc, ← Units.val_mul, mul_inv_cancel, Units.val_one, one_mul,
    neg_add_cancel, add_zero]

theorem aff_inj {u u' : (ZMod c)ˣ} {v v' : ZMod c} (h : aff u v = aff u' v') : u = u' ∧ v = v' := by
  have h0 := congrArg (· 0) h
  have h1 := congrArg (· 1) h
  simp at h0 h1
  subst h0
  exact ⟨Units.ext (by simpa using h1), rfl⟩

variable (W : Subgroup (ZMod c)ˣ)

/-- H_W: translations and the twist W. -/
def H : Subgroup (Perm (ZMod c)) where
  carrier := {σ | ∃ u ∈ W, ∃ v, σ = aff u v}
  mul_mem' := by
    rintro _ _ ⟨u, hu, v, rfl⟩ ⟨u', hu', v', rfl⟩
    exact ⟨u * u', W.mul_mem hu hu', _, aff_mul u u' v v'⟩
  one_mem' := ⟨1, W.one_mem, 0, aff_one.symm⟩
  inv_mem' := by
    rintro _ ⟨u, hu, v, rfl⟩
    exact ⟨u⁻¹, W.inv_mem hu, _, aff_inv u v⟩

theorem card_H : Nat.card (H W) = c * Nat.card W := by
  have hbij : Function.Bijective (fun w : W × ZMod c => (⟨aff w.1 w.2, w.1, w.1.2, w.2, rfl⟩ : H W)) := by
    constructor
    · rintro ⟨⟨u, hu⟩, v⟩ ⟨⟨u', hu'⟩, v'⟩ h
      have := aff_inj (congrArg Subtype.val h)
      simp only [Prod.mk.injEq, Subtype.mk.injEq]
      exact ⟨this.1, this.2⟩
    · rintro ⟨σ, u, hu, v, rfl⟩
      exact ⟨(⟨u, hu⟩, v), rfl⟩
  rw [← Nat.card_congr (Equiv.ofBijective _ hbij), Nat.card_prod, Nat.card_zmod, Nat.mul_comm]

/-! ## Freeness gives divisibility -/

/-- A free action of a finite group: its order divides the number of points. -/
theorem card_dvd_of_free {G X : Type*} [Group G] [Finite G] [Finite X] [MulAction G X]
    (hfree : ∀ (g : G) (x : X), g • x = x → g = 1) : Nat.card G ∣ Nat.card X := by
  classical
  have hst : ∀ x : X, stabilizer G x = ⊥ := fun x => by
    ext g; simp only [mem_stabilizer_iff, Subgroup.mem_bot]
    exact ⟨hfree g x, fun h => by rw [h, one_smul]⟩
  have horb : ∀ x : X, Nat.card (orbit G x) = Nat.card G := fun x => by
    rw [Nat.card_congr (orbitEquivQuotientStabilizer G x), hst x,
      Nat.card_congr (QuotientGroup.quotientBot.toEquiv)]
  have := Fintype.ofFinite G
  have := Fintype.ofFinite X
  rw [Nat.card_congr (selfEquivSigmaOrbits G X), Nat.card_sigma]
  exact Finset.dvd_sum fun ω _ => by rw [horb]

/-! ## The stabiliser of a k-set -/

theorem smul_eq_image (h : H W) (S : Finset (ZMod c)) : h • S = S.image (h : Perm (ZMod c)) := by
  rw [Finset.smul_finset_def]; rfl

theorem mem_stab {h : H W} {S : Finset (ZMod c)} :
    h ∈ stabilizer (H W) S ↔ S.image (h : Perm (ZMod c)) = S := by
  rw [mem_stabilizer_iff, smul_eq_image]

/-- A k-set with 1 ≤ k < c is fixed by no nonzero translation. -/
theorem no_translation {S : Finset (ZMod c)} (hk1 : 1 ≤ S.card) (hkc : S.card < c) {v : ZMod c}
    (h : S.image (aff 1 v) = S) : v = 0 := by
  by_contra hv
  obtain ⟨x, hx⟩ : S.Nonempty := Finset.card_pos.mp (by omega)
  have hstep : ∀ y ∈ S, y + v ∈ S := fun y hy => by
    rw [← h]; exact Finset.mem_image.mpr ⟨y, hy, by simp⟩
  have hn : ∀ n : ℕ, x + n * v ∈ S := by
    intro n
    induction n with
    | zero => simpa using hx
    | succ n ih => have := hstep _ ih; push_cast; rwa [add_mul, one_mul, ← add_assoc]
  have hall : S = Finset.univ := by
    apply Finset.eq_univ_of_forall
    intro y
    have := hn ((y - x) * v⁻¹).val
    rwa [ZMod.natCast_val, ZMod.cast_id', id, mul_assoc, inv_mul_cancel₀ hv, mul_one,
      add_sub_cancel] at this
  rw [hall, Finset.card_univ, ZMod.card] at hkc
  omega

/-- The multiplier of an element of H_W. -/
noncomputable def mulPart (h : H W) : (ZMod c)ˣ := Classical.choose h.2

theorem mulPart_spec (h : H W) : mulPart W h ∈ W ∧ ∃ v, (h : Perm (ZMod c)) = aff (mulPart W h) v :=
  Classical.choose_spec h.2

theorem mulPart_eq {h : H W} {u : (ZMod c)ˣ} {v : ZMod c} (he : (h : Perm (ZMod c)) = aff u v) :
    mulPart W h = u := by
  obtain ⟨-, v', hv'⟩ := mulPart_spec W h
  exact (aff_inj (hv'.symm.trans he)).1

/-- The multiplier as a homomorphism H_W → 𝔽_c^×. -/
noncomputable def ψ : H W →* (ZMod c)ˣ where
  toFun := mulPart W
  map_one' := mulPart_eq W (h := 1) (v := 0) aff_one.symm
  map_mul' a b := by
    obtain ⟨-, v, hv⟩ := mulPart_spec W a
    obtain ⟨-, v', hv'⟩ := mulPart_spec W b
    apply mulPart_eq W (v := mulPart W a * v' + v)
    rw [Subgroup.coe_mul, hv, hv', aff_mul]

theorem ψ_mem (h : H W) : ψ W h ∈ W := (mulPart_spec W h).1

theorem eq_aff (h : H W) : ∃ v, (h : Perm (ZMod c)) = aff (ψ W h) v := (mulPart_spec W h).2

/-- **The stabiliser bound**: a k-set (1 ≤ k < c) has stabiliser of order at most θ_k(d). -/
theorem card_stab_le (S : Finset (ZMod c)) (hk1 : 1 ≤ S.card) (hkc : S.card < c) :
    Nat.card (stabilizer (H W) S) ≤ theta S.card (Nat.card W) := by
  classical
  set K := stabilizer (H W) S
  have hd : 0 < Nat.card W := Nat.card_pos
  -- ψ is injective on K
  have hinj : Function.Injective ((ψ W).comp K.subtype) := by
    rw [injective_iff_map_eq_one]
    intro h hh
    obtain ⟨v, hv⟩ := eq_aff W h.1
    simp only [MonoidHom.coe_comp, Subgroup.coe_subtype, Function.comp_apply] at hh
    rw [hh] at hv
    have himg := (mem_stab W).mp h.2
    rw [hv] at himg
    have hv0 := no_translation hk1 hkc himg
    subst hv0
    apply Subtype.ext; apply Subtype.ext
    rw [hv, aff_one]; rfl
  -- so |K| divides d
  have hKd : Nat.card K ∣ Nat.card W := by
    have h1 : Nat.card K = Nat.card ((ψ W).comp K.subtype).range :=
      (Nat.card_congr (MonoidHom.ofInjective hinj).toEquiv)
    rw [h1]
    apply Subgroup.card_dvd_of_le
    rintro _ ⟨h, rfl⟩
    exact ψ_mem W h.1
  -- K is commutative
  have hcomm : ∀ a b : K, a * b = b * a := fun a b => hinj (by rw [map_mul, map_mul, mul_comm])
  by_cases htriv : ∀ g : K, g = 1
  · have : Nat.card K = 1 := by
      rw [Nat.card_eq_one_iff_unique]; exact ⟨⟨fun a b => (htriv a).trans (htriv b).symm⟩, ⟨1⟩⟩
    rw [this]; exact theta_pos hd
  push Not at htriv
  obtain ⟨g, hg⟩ := htriv
  obtain ⟨v, hv⟩ := eq_aff W g.1
  set u := ψ W g.1
  have hu : u ≠ 1 := by
    intro hu1
    apply hg
    apply hinj
    simp only [MonoidHom.coe_comp, Subgroup.coe_subtype, Function.comp_apply, map_one]
    exact hu1
  have hu1 : (1 : ZMod c) - u ≠ 0 := by
    intro h0; apply hu; apply Units.ext; simp only [Units.val_one]; linear_combination -h0
  set x0 := v * (1 - (u : ZMod c))⁻¹
  -- fixed points of a nontrivial affine map
  have hfix : ∀ y, (g.1 : Perm (ZMod c)) y = y ↔ y = x0 := by
    intro y
    rw [hv, aff_apply]
    constructor
    · intro hy
      have : (1 - (u : ZMod c)) * y = v := by linear_combination -hy
      simp only [x0]
      rw [← this, mul_comm (1 - (u : ZMod c)) y, mul_assoc, mul_inv_cancel₀ hu1, mul_one]
    · rintro rfl
      simp only [x0]
      field_simp
      ring
  -- every element of K fixes x0
  have hKx0 : ∀ h : K, (h.1 : Perm (ZMod c)) x0 = x0 := by
    intro h
    apply (hfix _).mp
    have := congrArg (fun k : K => (k.1 : Perm (ZMod c)) x0) (hcomm g h)
    simp only [Subgroup.coe_mul, Perm.mul_apply] at this
    rw [this, (hfix x0).mpr rfl]
  -- an element of K fixing a second point is trivial
  have htwo : ∀ (h : K) (y : ZMod c), y ≠ x0 → (h.1 : Perm (ZMod c)) y = y → h = 1 := by
    intro h y hy hhy
    obtain ⟨w, hw⟩ := eq_aff W h.1
    have h1 := hKx0 h
    rw [hw, aff_apply] at h1 hhy
    have hd' : ((ψ W h.1 : ZMod c) - 1) * (y - x0) = 0 := by linear_combination hhy - h1
    have hy' : y - x0 ≠ 0 := sub_ne_zero.mpr hy
    have hψ : ψ W h.1 = 1 := Units.ext (by
      have := (mul_eq_zero.mp hd').resolve_right hy'
      simp only [Units.val_one]; linear_combination this)
    apply hinj
    simp only [MonoidHom.coe_comp, Subgroup.coe_subtype, Function.comp_apply, map_one, hψ]
  -- K acts freely on S minus x0
  have hmapS : ∀ (h : K) (y : ZMod c), y ∈ S.erase x0 → (h.1 : Perm (ZMod c)) y ∈ S.erase x0 := by
    intro h y hy
    rw [Finset.mem_erase] at hy ⊢
    refine ⟨fun he => hy.1 ((h.1 : Perm (ZMod c)).injective (he.trans (hKx0 h).symm)), ?_⟩
    rw [← (mem_stab W).mp h.2]
    exact Finset.mem_image_of_mem _ hy.2
  let Y := {y // y ∈ S.erase x0}
  let act : MulAction K Y :=
    { smul := fun h y => ⟨(h.1 : Perm (ZMod c)) y.1, hmapS h y.1 y.2⟩
      one_smul := fun y => rfl
      mul_smul := fun a b y => rfl }
  have hfree : ∀ (h : K) (y : Y), h • y = y → h = 1 := fun h y hy =>
    htwo h y.1 (Finset.mem_erase.mp y.2).1 (congrArg Subtype.val hy)
  have hdvd := card_dvd_of_free hfree
  have hY : Nat.card Y = (S.erase x0).card := by
    rw [Nat.card_eq_fintype_card]; exact Fintype.card_coe _
  rw [hY] at hdvd
  apply le_theta hd hKd
  by_cases hx0 : x0 ∈ S
  · right; rwa [Finset.card_erase_of_mem hx0] at hdvd
  · left; rwa [Finset.erase_eq_of_notMem hx0] at hdvd

/-- **The orbit law, lower half**: every orbit of H_W on k-sets (1 ≤ k < c) has size at least
c·d/θ_k(d). -/
theorem orbit_lower (S : Finset (ZMod c)) (hk1 : 1 ≤ S.card) (hkc : S.card < c) :
    c * Nat.card W ≤ theta S.card (Nat.card W) * (orbit (H W) S).ncard := by
  rw [← card_H, ← Subgroup.card_mul_index (stabilizer (H W) S), index_stabilizer]
  exact Nat.mul_le_mul_right _ (card_stab_le W S hk1 hkc)

/-- Multiplication by units, as a homomorphism into permutations. -/
def mulHom : (ZMod c)ˣ →* Perm (ZMod c) where
  toFun u := aff u 0
  map_one' := aff_one
  map_mul' _ _ := by rw [aff_mul]; simp

theorem mulHom_inj : Function.Injective (mulHom (c := c)) := fun _ _ h => (aff_inj h).1

/-- **The orbit law, attained**: for 1 ≤ k < c some k-set has orbit exactly c·d/θ_k(d) — a union
of cosets of the order-θ subgroup of the twist, plus 0 when θ ∤ k. -/
theorem orbit_attained (k : ℕ) (hk1 : 1 ≤ k) (hkc : k < c) :
    ∃ S : Finset (ZMod c), S.card = k ∧
      theta k (Nat.card W) * (orbit (H W) S).ncard = c * Nat.card W := by
  classical
  have hd : 0 < Nat.card W := Nat.card_pos
  set j := theta k (Nat.card W)
  obtain ⟨hjd, hjk⟩ := theta_spec (k := k) hd
  have hj0 : 0 < j := theta_pos hd
  -- an element of order j in the twist
  obtain ⟨w0, hw0⟩ := IsCyclic.exists_ofOrder_eq_natCard (α := W)
  have hwj : orderOf (w0 ^ (Nat.card W / j)) = j := by
    have := orderOf_pow_orderOf_div (x := w0) (n := j) (by rw [hw0]; omega) (by rw [hw0]; exact hjd)
    rwa [hw0] at this
  set w : (ZMod c)ˣ := ((w0 ^ (Nat.card W / j) : W) : (ZMod c)ˣ)
  have hw : orderOf w = j := by rw [Subgroup.orderOf_coe]; exact hwj
  have hwW : w ∈ W := (w0 ^ (Nat.card W / j)).2
  set Z := Subgroup.zpowers w
  have hZ : Nat.card Z = j := by rw [Nat.card_zpowers, hw]
  -- the number of cosets to take
  set t := if j ∣ k then k / j else (k - 1) / j
  have hcu : Nat.card (ZMod c)ˣ = c - 1 := by rw [Nat.card_eq_fintype_card, ZMod.card_units]
  have hQ : Nat.card Z * Z.index = c - 1 := by rw [Subgroup.card_mul_index, hcu]
  have htj : t * j ≤ c - 1 := by
    simp only [t]; split_ifs with h
    · exact (Nat.div_mul_cancel h).le.trans (by omega)
    · have h' : j ∣ k - 1 := hjk.resolve_left h
      exact (Nat.div_mul_cancel h').le.trans (by omega)
  have ht : t ≤ Nat.card ((ZMod c)ˣ ⧸ Z) := by
    rw [← Subgroup.index, ← Nat.mul_le_mul_left_iff hj0]
    rw [hZ] at hQ
    rw [hQ, Nat.mul_comm]; exact htj
  have : Fintype ((ZMod c)ˣ ⧸ Z) := Fintype.ofFinite _
  obtain ⟨A, -, hA⟩ := Finset.exists_subset_card_eq (n := t) (s := (Finset.univ : Finset ((ZMod c)ˣ ⧸ Z)))
    (by rw [Finset.card_univ, ← Nat.card_eq_fintype_card]; exact ht)
  set P : Finset (ZMod c)ˣ := Finset.univ.filter (fun x => (x : (ZMod c)ˣ ⧸ Z) ∈ A)
  have hP : P.card = j * t := by
    have hset : (P : Set (ZMod c)ˣ) = QuotientGroup.mk ⁻¹' (A : Set ((ZMod c)ˣ ⧸ Z)) := by
      ext x; simp [P]
    have h1 := QuotientGroup.card_preimage_mk Z (A : Set ((ZMod c)ˣ ⧸ Z))
    have h2 : Nat.card (A : Set ((ZMod c)ˣ ⧸ Z)) = t := by
      rw [Finset.coe_sort_coe, Nat.card_eq_fintype_card, Fintype.card_coe, hA]
    rw [← hset, Nat.card_coe_set_eq, Set.ncard_coe_finset, h2, hZ] at h1
    exact h1
  set S0 : Finset (ZMod c) := Finset.map ⟨Units.val, Units.val_injective⟩ P
  set S : Finset (ZMod c) := if j ∣ k then S0 else insert 0 S0
  have h0 : (0 : ZMod c) ∉ S0 := by
    simp only [S0, Finset.mem_map, Function.Embedding.coeFn_mk, not_exists, not_and]
    intro x _ hx; exact x.ne_zero hx
  have hS : S.card = k := by
    simp only [S]; split_ifs with h
    · rw [Finset.card_map, hP]; simp only [t, h, ite_true]; exact Nat.mul_div_cancel' h
    · rw [Finset.card_insert_of_notMem h0, Finset.card_map, hP]
      simp only [t, h, ite_false]
      rw [Nat.mul_div_cancel' (hjk.resolve_left h)]; omega
  refine ⟨S, hS, ?_⟩
  -- multiplication by w stabilises S
  set m : H W := ⟨aff w 0, w, hwW, 0, rfl⟩
  have hsub : S.image (aff w 0) ⊆ S := by
    intro y hy
    obtain ⟨x, hx, rfl⟩ := Finset.mem_image.mp hy
    simp only [aff_apply, add_zero]
    have hS0 : ∀ z ∈ S0, (w : ZMod c) * z ∈ S0 := by
      intro z hz
      simp only [S0, P, Finset.mem_map, Finset.mem_filter, Finset.mem_univ, true_and,
        Function.Embedding.coeFn_mk] at hz ⊢
      obtain ⟨z', hz', rfl⟩ := hz
      refine ⟨w * z', ?_, by simp⟩
      have : ((w * z' : (ZMod c)ˣ) : (ZMod c)ˣ ⧸ Z) = (z' : (ZMod c)ˣ ⧸ Z) := by
        rw [QuotientGroup.eq]
        have : (w * z')⁻¹ * z' = w⁻¹ := by rw [mul_inv_rev, mul_comm z'⁻¹, mul_assoc, inv_mul_cancel, mul_one]
        rw [this]; exact Z.inv_mem (Subgroup.mem_zpowers w)
      rwa [this]
    simp only [S] at hx ⊢
    split_ifs at hx ⊢ with h
    · exact hS0 x hx
    · rcases Finset.mem_insert.mp hx with rfl | hx
      · simp
      · exact Finset.mem_insert_of_mem (hS0 x hx)
  have hmS : m ∈ stabilizer (H W) S := by
    rw [mem_stab W]
    exact Finset.eq_of_subset_of_card_le hsub
      (by rw [Finset.card_image_of_injective _ (aff w 0).injective])
  have hord : orderOf m = j := by
    rw [← Subgroup.orderOf_coe]
    show orderOf (mulHom w) = j
    rw [orderOf_injective _ mulHom_inj, hw]
  have hge : j ≤ Nat.card (stabilizer (H W) S) := by
    rw [← hord, ← Nat.card_zpowers]
    exact Subgroup.card_le_of_le ((Subgroup.zpowers_le).mpr hmS)
  have hle := card_stab_le W S (by omega) (by omega)
  rw [hS] at hle
  have heq : Nat.card (stabilizer (H W) S) = j := le_antisymm hle hge
  rw [← card_H, ← Subgroup.card_mul_index (stabilizer (H W) S), index_stabilizer, heq]

/-- **The k-uniform orbit law for prime blocks**: the least orbit of H_W on k-subsets of 𝔽_c
(c prime, 1 ≤ k < c) has size exactly c·d/θ_k(d), d = |W|. -/
theorem orbit_law (k : ℕ) (hk1 : 1 ≤ k) (hkc : k < c) :
    (∀ S : Finset (ZMod c), S.card = k →
      c * Nat.card W ≤ theta k (Nat.card W) * (orbit (H W) S).ncard) ∧
    ∃ S : Finset (ZMod c), S.card = k ∧
      theta k (Nat.card W) * (orbit (H W) S).ncard = c * Nat.card W :=
  ⟨fun S hS => hS ▸ orbit_lower W S (hS ▸ hk1) (hS ▸ hkc), orbit_attained W k hk1 hkc⟩

end KUnif

/-
# `Part0Fr.lean` — a foreign block's SAFE term, orb(r, t), bounds an orbital

For Part 0 (μ\* ≤ B_safe): an Oliver group acting transitively on a block of prime size r ≠ p
(the home prime) has an orbital of at most orb(r, t) pairs, for some t = q^f dividing r − 1.

* Lemma B for prime blocks (`LemmaB.lemmaB_block_any`) puts every element in the form
  x ↦ u·x + b after one relabelling E.
* The multipliers u form a subgroup `mulGp` of (ℤ/r)ˣ; its order t divides r − 1.
* Lemma B′ (`LemmaBprime.lemmaBprime_primitive`): every element has a q-power power in the
  normal subgroup V of order r, whose multipliers are trivial; so every multiplier has q-power
  order, and t = q^f.
* The orbital of {E 0, E 1} lies in {s(E b, E (b + u)) : b, u ∈ mulGp}: at most r·t pairs, and
  r·t/2 when t is even (then −1 is a multiplier, and (b, u), (b + u, −u) give the same pair).
-/
import LemmaB
import LemmaBprime
import E6
import D2
import Part0
import D2Full

set_option linter.unusedSectionVars false

namespace Part0Fr
open Finset Chain ArkCore

variable {r : ℕ} [hr : Fact r.Prime]

/-- `h` has multiplier u (and some translation b) in the coordinates E. -/
def HasMul (E h : Equiv.Perm (ZMod r)) (u : (ZMod r)ˣ) : Prop :=
  ∃ b : ZMod r, ∀ x, (E⁻¹ * h * E) x = (u : ZMod r) * x + b

theorem HasMul.mul {E h₁ h₂ : Equiv.Perm (ZMod r)} {u₁ u₂ : (ZMod r)ˣ} (h1 : HasMul E h₁ u₁)
    (h2 : HasMul E h₂ u₂) : HasMul E (h₁ * h₂) (u₁ * u₂) := by
  obtain ⟨b₁, hb₁⟩ := h1
  obtain ⟨b₂, hb₂⟩ := h2
  refine ⟨u₁ * b₂ + b₁, fun x => ?_⟩
  have : E⁻¹ * (h₁ * h₂) * E = (E⁻¹ * h₁ * E) * (E⁻¹ * h₂ * E) := by group
  rw [this, Equiv.Perm.mul_apply, hb₂, hb₁]; push_cast; ring

theorem HasMul.pow {E h : Equiv.Perm (ZMod r)} {u : (ZMod r)ˣ} (h1 : HasMul E h u) :
    ∀ n : ℕ, HasMul E (h ^ n) (u ^ n)
  | 0 => ⟨0, fun x => by simp⟩
  | n + 1 => by rw [pow_succ, pow_succ]; exact (h1.pow n).mul h1

theorem HasMul.inv {E h : Equiv.Perm (ZMod r)} {u : (ZMod r)ˣ} (h1 : HasMul E h u) :
    HasMul E h⁻¹ u⁻¹ := by
  obtain ⟨b, hb⟩ := h1
  refine ⟨-(↑u⁻¹ * b), fun x => ?_⟩
  have e : E⁻¹ * h⁻¹ * E = (E⁻¹ * h * E)⁻¹ := by group
  rw [e]
  apply (E⁻¹ * h * E).injective
  rw [← Equiv.Perm.mul_apply, mul_inv_cancel, Equiv.Perm.one_apply, hb]
  have : (u : ZMod r) * ↑u⁻¹ = 1 := Units.mul_inv u
  linear_combination (b - x) * this

/-- A map has one multiplier. -/
theorem HasMul.unique {E h : Equiv.Perm (ZMod r)} {u v : (ZMod r)ˣ} (h1 : HasMul E h u)
    (h2 : HasMul E h v) : u = v := by
  obtain ⟨b, hb⟩ := h1
  obtain ⟨c, hc⟩ := h2
  have e0 := (hb 0).symm.trans (hc 0)
  have e1 := (hb 1).symm.trans (hc 1)
  simp at e0
  apply Units.ext
  simpa [e0] using e1

/-- **The multiplier group** of H in the coordinates E. -/
def mulGp (H : Subgroup (Equiv.Perm (ZMod r))) (E : Equiv.Perm (ZMod r)) : Subgroup (ZMod r)ˣ where
  carrier := {u | ∃ h ∈ H, HasMul E h u}
  one_mem' := ⟨1, H.one_mem, 0, fun x => by simp⟩
  mul_mem' := fun ⟨h₁, m₁, k₁⟩ ⟨h₂, m₂, k₂⟩ => ⟨h₁ * h₂, H.mul_mem m₁ m₂, k₁.mul k₂⟩
  inv_mem' := fun ⟨h, m, k⟩ => ⟨h⁻¹, H.inv_mem m, k.inv⟩

/-- **A foreign block's SAFE term.**  An Oliver group H transitive on ℤ/r (r prime ≠ p) has an
orbital of at most orb(r, q^f) pairs, for some q^f dividing r − 1. -/
theorem fr_orbital {p q : ℕ} (H : Subgroup (Equiv.Perm (ZMod r)))
    (C : OliverChain H p q) (hp : p.Prime) (hq : q.Prime) (hrp : r ≠ p)
    (htr : ∀ x y : ZMod r, ∃ h ∈ H, h x = y) :
    ∃ f : ℕ, q ^ f ∣ r - 1 ∧ ∃ e : Sym2 (ZMod r), ¬ e.IsDiag ∧
      (D2.orbit2 H e).card ≤ orb r (q ^ f) false := by
  classical
  have hrp' : r.Prime := hr.out
  have : NeZero r := ⟨hrp'.ne_zero⟩
  obtain ⟨E, hE⟩ := LemmaB.lemmaB_block_any H C hp hq hrp htr
  -- every element has a multiplier
  have hmul : ∀ h ∈ H, ∃ u : (ZMod r)ˣ, HasMul E h u := by
    intro h hh
    obtain ⟨a, b, ha, hab⟩ := hE h hh
    exact ⟨Units.mk0 a ha, b, hab⟩
  set A := mulGp H E
  -- t := |A| divides r − 1
  have hdvd : Nat.card A ∣ r - 1 := by
    have := Subgroup.card_subgroup_dvd_card A
    rw [show Nat.card (ZMod r)ˣ = r - 1 by rw [Nat.card_eq_fintype_card, ZMod.card_units]] at this
    exact this
  -- every multiplier has q-power order (Lemma B′)
  have : Fact q.Prime := ⟨hq⟩
  have hpre : MulAction.IsPretransitive H (ZMod r) :=
    ⟨fun x y => by obtain ⟨h, hh, hy⟩ := htr x y; exact ⟨⟨h, hh⟩, hy⟩⟩
  have hprim : MulAction.IsPreprimitive H (ZMod r) :=
    MulAction.IsPreprimitive.of_prime_card (by rw [Nat.card_zmod]; exact hrp')
  obtain ⟨-, Vg, -, hV, hpow, -⟩ := LemmaBprime.lemmaBprime_primitive H C hp hq
    (by rw [Nat.card_zmod]; exact hrp'.two_le)
    (by rw [Nat.card_zmod]; intro h; exact hrp ((Nat.prime_dvd_prime_iff_eq hp hrp').mp h).symm)
  have hqA : IsPGroup q A := by
    intro ⟨u, hu⟩
    obtain ⟨h, hh, hm⟩ := hu
    obtain ⟨k, hk⟩ := hpow ⟨h, hh⟩
    refine ⟨k, Subtype.ext ?_⟩
    -- v := h^(q^k) lies in V, of order r, so its multiplier w has w^r = 1, hence w = 1
    have hv : HasMul E (h ^ (q ^ k)) (u ^ (q ^ k)) := hm.pow _
    have h1' : (⟨_, hk⟩ : Vg) ^ r = 1 := by
      have := pow_card_eq_one' (G := Vg) (x := ⟨_, hk⟩)
      rwa [hV, Nat.card_zmod] at this
    have hord : ((⟨h, hh⟩ : H) ^ (q ^ k)) ^ r = 1 := by
      have := congrArg (fun z : Vg => (z : H)) h1'
      simpa using this
    have hvr : HasMul E ((h ^ (q ^ k)) ^ r) ((u ^ (q ^ k)) ^ r) := hv.pow r
    have h1 : (h ^ (q ^ k)) ^ r = 1 := by
      have := congrArg (fun z : H => (z : Equiv.Perm (ZMod r))) hord
      simpa using this
    rw [h1] at hvr
    have hone : HasMul E (1 : Equiv.Perm (ZMod r)) 1 := ⟨0, fun x => by simp⟩
    have hw := hvr.unique hone
    -- in 𝔽_r, w^r = w
    have hfermat : ((u ^ (q ^ k)) ^ r : (ZMod r)ˣ) = u ^ (q ^ k) := by
      apply Units.ext; push_cast; exact ZMod.pow_card _
    rw [hfermat] at hw
    simpa using hw
  obtain ⟨f, hf⟩ := IsPGroup.iff_card.mp hqA
  refine ⟨f, hf ▸ hdvd, s(E 0, E 1), ?_, ?_⟩
  · simp only [Sym2.mk_isDiag_iff]
    intro h; exact zero_ne_one (E.injective h)
  -- the orbital lies in the image of ℤ/r × A
  set M : Finset ((ZMod r) × (ZMod r)ˣ) := univ ×ˢ (A : Set (ZMod r)ˣ).toFinset
  set φ : (ZMod r) × (ZMod r)ˣ → Sym2 (ZMod r) := fun bu => s(E bu.1, E (bu.1 + bu.2))
  have hsub : D2.orbit2 H s(E 0, E 1) ⊆ M.image φ := by
    intro z hz
    obtain ⟨g, hg, rfl⟩ := mem_image.mp hz
    simp only [mem_filter, mem_univ, true_and] at hg
    obtain ⟨u, b, hb⟩ := (hmul g hg)
    have hu : u ∈ A := ⟨g, hg, b, hb⟩
    refine mem_image.mpr ⟨(b, u), ?_, ?_⟩
    · simp [M, hu]
    · have e0 : g (E 0) = E b := by
        have := hb 0; simp only [Equiv.Perm.mul_apply, mul_zero, zero_add] at this
        rw [← this]; simp
      have e1 : g (E 1) = E (b + u) := by
        have := hb 1; simp only [Equiv.Perm.mul_apply, mul_one] at this
        rw [add_comm, ← this]; simp
      simp [φ, Sym2.map_mk, e0, e1]
  have hM : M.card = r * q ^ f := by
    simp only [M, card_product, card_univ, ZMod.card]
    rw [← hf, ← Nat.card_eq_card_toFinset]; rfl
  -- the C(r,2) cap
  have hcap : (D2.orbit2 H s(E 0, E 1)).card ≤ pairs r := by
    have hS : ∀ g ∈ H, ∀ e ∈ (univ : Finset (ZMod r)).offDiag.image Sym2.mk.uncurry,
        Sym2.map g e ∈ (univ : Finset (ZMod r)).offDiag.image Sym2.mk.uncurry := by
      intro g _ e he
      obtain ⟨⟨a, c⟩, hac, rfl⟩ := mem_image.mp he
      obtain ⟨-, -, hne⟩ := mem_offDiag.mp hac
      exact mem_image.mpr ⟨(g a, g c), mem_offDiag.mpr ⟨mem_univ _, mem_univ _,
        fun h => hne (g.injective h)⟩, by simp [Sym2.map_mk]⟩
    have h0 : s(E 0, E 1) ∈ (univ : Finset (ZMod r)).offDiag.image Sym2.mk.uncurry :=
      mem_image.mpr ⟨(E 0, E 1), mem_offDiag.mpr ⟨mem_univ _, mem_univ _,
        fun h => zero_ne_one (E.injective h)⟩, rfl⟩
    have := D2.orbit2_card_le H _ hS h0
    rw [Sym2.card_image_offDiag, card_univ, ZMod.card] at this
    rwa [show pairs r = r.choose 2 by unfold pairs; rw [Nat.choose_two_right]]
  unfold orb
  simp only [Bool.false_eq_true, false_or]
  refine le_min ?_ hcap
  split
  · -- t even: −1 is a multiplier, and each pair is hit twice
    rename_i hev
    -- t = |A| is even, so A has an element of order 2, which is −1
    have h2A : 2 ∣ Nat.card A := by rw [hf]; exact Nat.dvd_of_mod_eq_zero hev
    have : Fact (Nat.Prime 2) := ⟨Nat.prime_two⟩
    obtain ⟨w, hw⟩ := exists_prime_orderOf_dvd_card' (G := A) 2 h2A
    have hr2 : r ≠ 2 := by
      intro h2
      have e : r - 1 = 1 := by omega
      have h1 : Nat.card A ∣ 1 := by rw [e] at hdvd; exact hdvd
      have h3 := Nat.le_of_dvd (by norm_num) h1
      have h4 := Nat.le_of_dvd Nat.card_pos h2A
      omega
    have hm1 : ((-1 : (ZMod r)ˣ)) ∈ A := by
      have hw2 : (w : (ZMod r)ˣ) ^ 2 = 1 := by
        have := pow_orderOf_eq_one w; rw [hw] at this
        exact congrArg Subtype.val this
      have hw1 : (w : (ZMod r)ˣ) ≠ 1 := by
        intro h
        have : w = 1 := Subtype.ext h
        rw [this, orderOf_one] at hw; omega
      have hval : ((w : (ZMod r)ˣ) : ZMod r) = -1 := by
        have e2 : ((w : (ZMod r)ˣ) : ZMod r) ^ 2 = 1 := by
          have := congrArg (fun z : (ZMod r)ˣ => (z : ZMod r)) hw2; simpa using this
        have e1 : ((w : (ZMod r)ˣ) : ZMod r) ≠ 1 := by
          intro h; exact hw1 (Units.ext h)
        have : (((w : (ZMod r)ˣ) : ZMod r) - 1) * (((w : (ZMod r)ˣ) : ZMod r) + 1) = 0 := by
          linear_combination e2
        rcases mul_eq_zero.mp this with h | h
        · exact absurd (sub_eq_zero.mp h) e1
        · linear_combination h
      have : (w : (ZMod r)ˣ) = -1 := Units.ext (by simpa using hval)
      rw [← this]; exact w.2
    -- the involution (b, u) ↦ (b + u, −u) on M, with the same image under φ
    have htwo : (2 : ZMod r) ≠ 0 := by
      intro h
      have : ((2 : ℕ) : ZMod r) = 0 := by exact_mod_cast h
      rw [ZMod.natCast_eq_zero_iff] at this
      have := (Nat.prime_dvd_prime_iff_eq hrp' Nat.prime_two).mp this
      exact hr2 this
    have hfib : ∀ z ∈ M.image φ, 2 ≤ (M.filter (fun x => φ x = z)).card := by
      intro z hz
      obtain ⟨x, hx, rfl⟩ := mem_image.mp hz
      obtain ⟨b, u⟩ := x
      have hu : u ∈ A := by simpa [M] using hx
      have hu' : -u ∈ A := by
        have := A.mul_mem hm1 hu; simpa using this
      apply Finset.one_lt_card.mpr
      refine ⟨(b, u), mem_filter.mpr ⟨hx, rfl⟩, (b + u, -u), mem_filter.mpr ⟨by simp [M, hu'], ?_⟩, ?_⟩
      · simp only [φ, Units.val_neg]
        rw [show b + ↑u + -↑u = b by ring]
        exact Sym2.eq_swap
      · intro h
        have h2 := congrArg Prod.snd h
        simp only at h2
        have : (2 : ZMod r) * (u : ZMod r) = 0 := by
          have := congrArg (fun z : (ZMod r)ˣ => (z : ZMod r)) h2
          simp only [Units.val_neg] at this
          linear_combination this
        rcases mul_eq_zero.mp this with h | h
        · exact htwo h
        · exact u.ne_zero h
    have hcard : 2 * (M.image φ).card ≤ M.card := by
      rw [card_eq_sum_card_image φ M]
      calc 2 * (M.image φ).card = ∑ _z ∈ M.image φ, 2 := by rw [sum_const, smul_eq_mul, mul_comm]
        _ ≤ _ := sum_le_sum hfib
    rw [hM] at hcard
    calc (D2.orbit2 H s(E 0, E 1)).card ≤ (M.image φ).card := card_le_card hsub
      _ ≤ r * q ^ f / 2 := (Nat.le_div_iff_mul_le (by norm_num)).mpr (by omega)
  · calc (D2.orbit2 H s(E 0, E 1)).card ≤ (M.image φ).card := card_le_card hsub
      _ ≤ M.card := card_image_le
      _ = r * q ^ f := hM

/-! ## Transport: from an invariant set of Γ to a group on a model type -/

section transport
variable {V X : Type*} [Fintype V] [DecidableEq V] [Fintype X] [DecidableEq X]

/-- Restrict Γ to an invariant set S and relabel S by e : S ≃ X. -/
noncomputable def resHom (Γ : Subgroup (Equiv.Perm V)) (S : Finset V)
    (hS : ∀ g ∈ Γ, ∀ x ∈ S, g x ∈ S) (e : S ≃ X) : Γ →* Equiv.Perm X where
  toFun g := e.permCongr ((g : Equiv.Perm V).subtypePerm (p := (· ∈ S)) (fun x => by
    constructor
    · intro hx
      have := hS (g⁻¹) (Γ.inv_mem g.2) _ hx
      simpa using this
    · exact hS g g.2 x))
  map_one' := by ext x; simp [Equiv.permCongr_apply]
  map_mul' := by intro _ _; ext x; simp [Equiv.permCongr_apply]

theorem resHom_apply (Γ : Subgroup (Equiv.Perm V)) (S : Finset V)
    (hS : ∀ g ∈ Γ, ∀ x ∈ S, g x ∈ S) (e : S ≃ X) (g : Γ) (x : X) :
    ((e.symm (resHom Γ S hS e g x)) : V) = (g : Equiv.Perm V) (e.symm x) := by
  simp [resHom, Equiv.permCongr_apply]

/-- The lift of a pair of the model to V. -/
noncomputable def liftP (S : Finset V) (e : S ≃ X) : Sym2 X → Sym2 V :=
  Sym2.map (fun x => ((e.symm x : S) : V))

theorem liftP_inj (S : Finset V) (e : S ≃ X) : Function.Injective (liftP S e) :=
  Sym2.map.injective (fun _ _ h => e.symm.injective (Subtype.ext h))

/-- **Orbitals transport**: an orbital of the restricted, relabelled group is at least as large
as the corresponding orbital of Γ. -/
theorem orbit2_res_le (Γ : Subgroup (Equiv.Perm V)) (S : Finset V)
    (hS : ∀ g ∈ Γ, ∀ x ∈ S, g x ∈ S) (e : S ≃ X) (z : Sym2 X) :
    (D2.orbit2 Γ (liftP S e z)).card ≤ (D2.orbit2 (resHom Γ S hS e).range z).card := by
  classical
  calc (D2.orbit2 Γ (liftP S e z)).card
      ≤ ((D2.orbit2 (resHom Γ S hS e).range z).image (liftP S e)).card := by
        apply card_le_card
        intro w hw
        obtain ⟨g, hg, rfl⟩ := mem_image.mp hw
        simp only [mem_filter, mem_univ, true_and] at hg
        refine mem_image.mpr ⟨Sym2.map (resHom Γ S hS e ⟨g, hg⟩) z, ?_, ?_⟩
        · exact mem_image.mpr ⟨_, by simp; exact ⟨g, hg, rfl⟩, rfl⟩
        · induction z using Sym2.ind with
          | h a b =>
            simp only [liftP, Sym2.map_mk]
            rw [resHom_apply, resHom_apply]
    _ ≤ _ := card_image_le

theorem liftP_nondiag (S : Finset V) (e : S ≃ X) {z : Sym2 X} (hz : ¬ z.IsDiag) :
    ¬ (liftP S e z).IsDiag := by
  induction z using Sym2.ind with
  | h a b =>
    simp only [liftP, Sym2.map_mk, Sym2.mk_isDiag_iff] at hz ⊢
    intro h; exact hz (e.symm.injective (Subtype.ext h))

theorem res_transitive (Γ : Subgroup (Equiv.Perm V)) (S : Finset V)
    (hS : ∀ g ∈ Γ, ∀ x ∈ S, g x ∈ S) (e : S ≃ X)
    (htr : ∀ x ∈ S, ∀ y ∈ S, ∃ g ∈ Γ, g x = y) :
    ∀ x y : X, ∃ h ∈ (resHom Γ S hS e).range, h x = y := by
  intro x y
  obtain ⟨g, hg, hgy⟩ := htr _ (e.symm x).2 _ (e.symm y).2
  refine ⟨resHom Γ S hS e ⟨g, hg⟩, ⟨_, rfl⟩, e.symm.injective (Subtype.ext ?_)⟩
  rw [resHom_apply]; exact hgy

end transport

/-! ## A foreign orbit of Γ -/

/-- **A foreign orbit's SAFE term bounds an orbital of Γ.**  If Γ has an Oliver chain and an
orbit S of prime size r ≠ p, then for some q^f dividing r − 1, some orbital of Γ has at most
orb(r, q^f) pairs. -/
theorem fr_orbit {V : Type*} [Fintype V] [DecidableEq V] {p q : ℕ}
    (Γ : Subgroup (Equiv.Perm V)) (C : OliverChain Γ p q) (hp : p.Prime) (hq : q.Prime)
    (S : Finset V) (hS : ∀ g ∈ Γ, ∀ x ∈ S, g x ∈ S)
    (htr : ∀ x ∈ S, ∀ y ∈ S, ∃ g ∈ Γ, g x = y) (hcard : S.card = r) (hrp : r ≠ p) :
    ∃ f : ℕ, q ^ f ∣ r - 1 ∧ ∃ e : Sym2 V, ¬ e.IsDiag ∧
      (D2.orbit2 Γ e).card ≤ orb r (q ^ f) false := by
  classical
  have e : S ≃ ZMod r := by
    have : Fintype.card S = Fintype.card (ZMod r) := by
      have : NeZero r := ⟨hr.out.ne_zero⟩
      simp [hcard, ZMod.card]
    exact Fintype.equivOfCardEq this
  set ρ := resHom Γ S hS e
  have C' := C.map ρ.rangeRestrict ρ.rangeRestrict_surjective
  obtain ⟨f, hf, z, hz, hcz⟩ := fr_orbital ρ.range C' hp hq hrp (res_transitive Γ S hS e htr)
  exact ⟨f, hf, liftP S e z, liftP_nondiag S e hz, (orbit2_res_le Γ S hS e z).trans hcz⟩

/-! ## The stabiliser of a least block is primitive on it -/

section stab
open Pointwise
variable {V : Type*} [Fintype V] [DecidableEq V]
open Part0

/-- The setwise stabiliser of B in Γ. -/
def stabB (Γ : Subgroup (Equiv.Perm V)) (B : Finset V) : Subgroup (Equiv.Perm V) where
  carrier := {g | g ∈ Γ ∧ B.image g = B}
  one_mem' := ⟨Γ.one_mem, by simp⟩
  mul_mem' := by
    rintro g h ⟨hg, hgB⟩ ⟨hh, hhB⟩
    refine ⟨Γ.mul_mem hg hh, ?_⟩
    have : B.image (g * h) = (B.image h).image g := by rw [image_image]; rfl
    rw [this, hhB, hgB]
  inv_mem' := by
    rintro g ⟨hg, hgB⟩
    refine ⟨Γ.inv_mem hg, ?_⟩
    have : (B.image ⇑g).image ⇑(g⁻¹) = B := by
      rw [image_image]; convert image_id (s := B); ext x; simp
    rw [hgB] at this; exact this

theorem stabB_le (Γ : Subgroup (Equiv.Perm V)) (B : Finset V) : stabB Γ B ≤ Γ := fun _ h => h.1

theorem stabB_inv (Γ : Subgroup (Equiv.Perm V)) (B : Finset V) :
    ∀ g ∈ stabB Γ B, ∀ x ∈ B, g x ∈ B := by
  intro g hg x hx
  rw [← hg.2]; exact mem_image_of_mem _ hx

/-- The chain passes to a subgroup of Γ. -/
noncomputable def chainSub {Γ K : Subgroup (Equiv.Perm V)} (hK : K ≤ Γ) {p q : ℕ}
    (C : OliverChain Γ p q) : OliverChain K p q :=
  (D2Full.OliverChain.comap C (K.subgroupOf Γ)).map
    (Subgroup.subgroupOfEquivOfLe hK).toMonoidHom (Subgroup.subgroupOfEquivOfLe hK).surjective

/-- **The stabiliser of a least block acts primitively on it.** -/
theorem stab_primitive {Γ : Subgroup (Equiv.Perm V)} {S B : Finset V}
    (htr : ∀ x ∈ S, ∀ y ∈ S, ∃ g ∈ Γ, g x = y) (hBS : B ⊆ S) (hB : IsBlk Γ B)
    (hmin : ∀ B' ⊆ S, IsBlk Γ B' → 2 ≤ B'.card → B.card ≤ B'.card) :
    MulAction.IsPreprimitive (resHom (stabB Γ B) B (stabB_inv Γ B) (Equiv.refl B)).range B := by
  classical
  set ρ := resHom (stabB Γ B) B (stabB_inv Γ B) (Equiv.refl B)
  have hρ : ∀ (g : stabB Γ B) (x : B), ((ρ g x : B) : V) = (g : Equiv.Perm V) x := by
    intro g x; have := resHom_apply (stabB Γ B) B (stabB_inv Γ B) (Equiv.refl B) g x; simpa using this
  -- the stabiliser is transitive on B
  have hpre : MulAction.IsPretransitive ρ.range B := by
    constructor
    intro x y
    obtain ⟨g, hg, hgxy⟩ := htr x (hBS x.2) y (hBS y.2)
    have hgB : B.image g = B := by
      rcases hB g hg with h | h
      · exact h
      · exfalso
        exact disjoint_left.mp h (mem_image.mpr ⟨x, x.2, hgxy⟩) y.2
    refine ⟨⟨ρ ⟨g, hg, hgB⟩, ⟨_, rfl⟩⟩, Subtype.ext ?_⟩
    show ((ρ ⟨g, hg, hgB⟩ x : B) : V) = y
    rw [hρ]; exact hgxy
  refine { hpre with isTrivialBlock_of_isBlock := ?_ }
  intro B' hB'
  by_contra hnt
  simp only [MulAction.IsTrivialBlock, not_or] at hnt
  obtain ⟨hns, hnu⟩ := hnt
  -- lift B' to V
  set L : Finset V := (B'.toFinset).image Subtype.val
  have hLB : L ⊆ B := by
    intro z hz; obtain ⟨w, -, rfl⟩ := mem_image.mp hz; exact w.2
  have hmemL : ∀ w : B, (w : V) ∈ L ↔ w ∈ B' := by
    intro w; simp [L]
  have hL2 : 2 ≤ L.card := by
    obtain ⟨a, ha, b, hb, hab⟩ := Set.not_subsingleton_iff.mp hns
    have : ({(a : V), (b : V)} : Finset V) ⊆ L := by
      intro z hz; simp only [mem_insert, mem_singleton] at hz
      rcases hz with rfl | rfl
      · exact (hmemL a).mpr ha
      · exact (hmemL b).mpr hb
    have := card_le_card this
    rw [card_pair (fun h => hab (Subtype.ext h))] at this; exact this
  have hLlt : L.card < B.card := by
    apply card_lt_card
    refine ⟨hLB, fun h => hnu ?_⟩
    ext w; simp only [Set.mem_univ, iff_true]
    exact (hmemL w).mp (h w.2)
  -- L is a block of Γ
  have hLblk : IsBlk Γ L := by
    intro g hg
    rcases hB g hg with hgB | hgB
    · -- g stabilises B, and acts there as an element of ρ.range
      have hgs : g ∈ stabB Γ B := ⟨hg, hgB⟩
      have hb := (MulAction.isBlock_iff_smul_eq_or_disjoint.mp hB') ⟨ρ ⟨g, hgs⟩, ⟨_, rfl⟩⟩
      have himg : L.image g =
          (((⟨ρ ⟨g, hgs⟩, ⟨_, rfl⟩⟩ : ρ.range) • B').toFinset).image Subtype.val := by
        ext z
        simp only [L, mem_image, Set.mem_toFinset]
        constructor
        · rintro ⟨_, ⟨w, hw, rfl⟩, rfl⟩
          exact ⟨ρ ⟨g, hgs⟩ w, Set.mem_smul_set.mpr ⟨w, hw, rfl⟩, hρ _ w⟩
        · rintro ⟨w, hw, rfl⟩
          obtain ⟨w', hw', rfl⟩ := Set.mem_smul_set.mp hw
          exact ⟨w', ⟨w', hw', rfl⟩, (hρ ⟨g, hgs⟩ w').symm⟩
      rcases hb with h | h
      · left; rw [himg]
        simp only [L]
        ext z; simp only [mem_image, Set.mem_toFinset, h]
      · right; rw [himg]
        rw [Finset.disjoint_image Subtype.val_injective]
        exact Set.disjoint_toFinset.mpr h
    · right
      exact Finset.disjoint_of_subset_right hLB
        (Finset.disjoint_of_subset_left (image_subset_image hLB) hgB)
  have := hmin L (hLB.trans hBS) hLblk hL2
  omega

end stab

/-! ## Step 4: the kind of a least block -/

/-- **"A solvable primitive group is affine" in the form Part 0 uses, as a hypothesis** (a
`structure`, never an `axiom`): a primitive group with an Oliver chain (p, q) on X, with p ∣ |X|,
has |X| a power of p.  (Huppert: a soluble primitive group has an elementary abelian regular normal
subgroup, so prime-power degree; an Oliver group is soluble.  Not in Mathlib.) -/
structure HypHuppert : Prop where
  pow : ∀ (X : Type) [Fintype X] [DecidableEq X] (G : Subgroup (Equiv.Perm X))
    [MulAction.IsPreprimitive G X] (p q : ℕ), OliverChain G p q → p.Prime → q.Prime →
    p ∣ Fintype.card X → ∃ k, 1 ≤ k ∧ Fintype.card X = p ^ k

section kind
variable {V : Type} [Fintype V] [DecidableEq V]
open Part0

/-- **A least block is matching (a power of p) or outside (a prime r ≠ p).** -/
theorem block_kind (HH : HypHuppert) {Γ : Subgroup (Equiv.Perm V)} {p q : ℕ}
    (C : OliverChain Γ p q) (hp : p.Prime) (hq : q.Prime) {S B : Finset V}
    (htr : ∀ x ∈ S, ∀ y ∈ S, ∃ g ∈ Γ, g x = y) (hBS : B ⊆ S) (hB : IsBlk Γ B)
    (hB2 : 2 ≤ B.card) (hmin : ∀ B' ⊆ S, IsBlk Γ B' → 2 ≤ B'.card → B.card ≤ B'.card) :
    (∃ k, 1 ≤ k ∧ B.card = p ^ k) ∨ (B.card.Prime ∧ B.card ≠ p) := by
  classical
  set ρ := resHom (stabB Γ B) B (stabB_inv Γ B) (Equiv.refl B)
  have hprim := stab_primitive htr hBS hB hmin
  have C' : OliverChain ρ.range p q :=
    (chainSub (stabB_le Γ B) C).map ρ.rangeRestrict ρ.rangeRestrict_surjective
  have hcardX : Fintype.card B = B.card := Fintype.card_coe B
  by_cases hpB : p ∣ B.card
  · left
    obtain ⟨k, hk, hc⟩ := HH.pow B ρ.range p q C' hp hq (by rw [hcardX]; exact hpB)
    exact ⟨k, hk, hcardX ▸ hc⟩
  · right
    obtain ⟨hpr, -⟩ := LemmaBprime.lemmaBprime_primitive ρ.range C' hp hq
      (by rw [Nat.card_eq_fintype_card, hcardX]; exact hB2)
      (by rw [Nat.card_eq_fintype_card, hcardX]; exact hpB)
    rw [Nat.card_eq_fintype_card, hcardX] at hpr
    refine ⟨hpr, fun h => hpB (h ▸ dvd_refl _)⟩

end kind

/-! ## Step 3's new case: two unfused orbits of one prime -/

/-- An affine map of ℤ/r whose r^k-th power is trivial has trivial r-th power. -/
theorem affine_rpow {E h : Equiv.Perm (ZMod r)} {u : (ZMod r)ˣ} (hu : HasMul E h u) {k : ℕ}
    (hk : h ^ (r ^ k) = 1) : h ^ r = 1 := by
  have hone : HasMul E (1 : Equiv.Perm (ZMod r)) 1 := ⟨0, fun x => by simp⟩
  have h1 : u ^ (r ^ k) = 1 := by
    have := (hu.pow (r ^ k)); rw [hk] at this; exact this.unique hone
  -- Fermat: u^(r^k) = u
  have hf : ∀ j : ℕ, u ^ (r ^ j) = u := by
    intro j
    induction j with
    | zero => simp
    | succ j ih =>
      rw [pow_succ, pow_mul, ih]
      apply Units.ext; push_cast; exact ZMod.pow_card _
  rw [hf] at h1
  subst h1
  obtain ⟨b, hb⟩ := hu
  -- a translation: its r-th power is trivial
  have htr : ∀ n : ℕ, ∀ x, (E⁻¹ * h ^ n * E) x = x + n * b := by
    intro n
    induction n with
    | zero => intro x; simp
    | succ n ih =>
      intro x
      have : E⁻¹ * h ^ (n + 1) * E = (E⁻¹ * h ^ n * E) * (E⁻¹ * h * E) := by group
      rw [this, Equiv.Perm.mul_apply, hb, ih]; push_cast; simp; ring
  have : E⁻¹ * h ^ r * E = 1 := by
    ext x; rw [htr]; simp
  have := congrArg (fun z => E * z * E⁻¹) this
  simpa [mul_assoc] using this

/-- **Multipliers have q-power order** (Lemma B′), for an Oliver group transitive on ℤ/r in
affine coordinates E. -/
theorem mul_qpow {p q : ℕ} (H : Subgroup (Equiv.Perm (ZMod r))) (C : OliverChain H p q)
    (hp : p.Prime) (hq : q.Prime) (hrp : r ≠ p) (htr : ∀ x y : ZMod r, ∃ h ∈ H, h x = y)
    (E : Equiv.Perm (ZMod r)) {h : Equiv.Perm (ZMod r)} (hh : h ∈ H) {u : (ZMod r)ˣ}
    (hu : HasMul E h u) : ∃ k, u ^ (q ^ k) = 1 := by
  classical
  have hrp' : r.Prime := hr.out
  have : NeZero r := ⟨hrp'.ne_zero⟩
  have hpre : MulAction.IsPretransitive H (ZMod r) :=
    ⟨fun x y => by obtain ⟨h, hh, hy⟩ := htr x y; exact ⟨⟨h, hh⟩, hy⟩⟩
  have hprim : MulAction.IsPreprimitive H (ZMod r) :=
    MulAction.IsPreprimitive.of_prime_card (by rw [Nat.card_zmod]; exact hrp')
  obtain ⟨-, Vg, -, hV, hpow, -⟩ := LemmaBprime.lemmaBprime_primitive H C hp hq
    (by rw [Nat.card_zmod]; exact hrp'.two_le)
    (by rw [Nat.card_zmod]; intro h; exact hrp ((Nat.prime_dvd_prime_iff_eq hp hrp').mp h).symm)
  obtain ⟨k, hk⟩ := hpow ⟨h, hh⟩
  refine ⟨k, ?_⟩
  have h1' : (⟨_, hk⟩ : Vg) ^ r = 1 := by
    have := pow_card_eq_one' (G := Vg) (x := ⟨_, hk⟩)
    rwa [hV, Nat.card_zmod] at this
  have h1 : (h ^ (q ^ k)) ^ r = 1 := by
    have := congrArg (fun z : Vg => ((z : H) : Equiv.Perm (ZMod r))) h1'
    simpa using this
  have hvr := (hu.pow (q ^ k)).pow r
  rw [h1] at hvr
  have hw := hvr.unique (⟨0, fun x => by simp⟩ : HasMul E (1 : Equiv.Perm (ZMod r)) 1)
  have hfermat : ((u ^ (q ^ k)) ^ r : (ZMod r)ˣ) = u ^ (q ^ k) := by
    apply Units.ext; push_cast; exact ZMod.pow_card _
  rwa [hfermat] at hw

section orbitcoords
variable {V : Type*} [Fintype V] [DecidableEq V]

/-- **Affine coordinates on a prime orbit.**  For an orbit O of prime size r ≠ p, a hom ρ from Γ
to Perm(ℤ/r) recording the action, and coordinates E in which every ρ g is affine with a
multiplier of q-power order. -/
theorem orbit_coords {p q : ℕ} (Γ : Subgroup (Equiv.Perm V)) (C : OliverChain Γ p q)
    (hp : p.Prime) (hq : q.Prime) (O : Finset V) (hO : ∀ g ∈ Γ, ∀ x ∈ O, g x ∈ O)
    (htr : ∀ x ∈ O, ∀ y ∈ O, ∃ g ∈ Γ, g x = y) (hcard : O.card = r) (hrp : r ≠ p) :
    ∃ (ρ : Γ →* Equiv.Perm (ZMod r)) (e : O ≃ ZMod r) (E : Equiv.Perm (ZMod r)),
      (∀ (g : Γ) (z : ZMod r), ((e.symm (ρ g z) : O) : V) = (g : Equiv.Perm V) (e.symm z)) ∧
      (∀ x y : ZMod r, ∃ g : Γ, ρ g x = y) ∧
      (∀ g : Γ, ∃ u : (ZMod r)ˣ, HasMul E (ρ g) u ∧ ∃ k, u ^ (q ^ k) = 1) := by
  classical
  have : NeZero r := ⟨hr.out.ne_zero⟩
  have e : O ≃ ZMod r := Fintype.equivOfCardEq (by simp [hcard, ZMod.card])
  set ρ := resHom Γ O hO e
  have C' := C.map ρ.rangeRestrict ρ.rangeRestrict_surjective
  have htr' := res_transitive Γ O hO e htr
  obtain ⟨E, hE⟩ := LemmaB.lemmaB_block_any ρ.range C' hp hq hrp htr'
  refine ⟨ρ, e, E, fun g z => resHom_apply Γ O hO e g z, fun x y => ?_, fun g => ?_⟩
  · obtain ⟨h, ⟨g, rfl⟩, hy⟩ := htr' x y; exact ⟨g, hy⟩
  · obtain ⟨a, b, ha, hab⟩ := hE (ρ g) ⟨g, rfl⟩
    have hu : HasMul E (ρ g) (Units.mk0 a ha) := ⟨b, hab⟩
    exact ⟨_, hu, mul_qpow ρ.range C' hp hq hrp htr' E ⟨g, rfl⟩ hu⟩

end orbitcoords

theorem hasMul_one_pow {E h : Equiv.Perm (ZMod r)} (hu : HasMul E h 1) : h ^ r = 1 := by
  obtain ⟨b, hb⟩ := hu
  have htr : ∀ n : ℕ, ∀ x, (E⁻¹ * h ^ n * E) x = x + n * b := by
    intro n
    induction n with
    | zero => intro x; simp
    | succ n ih =>
      intro x
      have : E⁻¹ * h ^ (n + 1) * E = (E⁻¹ * h ^ n * E) * (E⁻¹ * h * E) := by group
      rw [this, Equiv.Perm.mul_apply, hb, ih]; push_cast; simp; ring
  have : E⁻¹ * h ^ r * E = 1 := by ext x; rw [htr]; simp
  have := congrArg (fun z => E * z * E⁻¹) this
  simpa [mul_assoc] using this

theorem hasMul_one_fix {E h : Equiv.Perm (ZMod r)} (hu : HasMul E h 1) {z : ZMod r}
    (hz : h z = z) : h = 1 := by
  obtain ⟨b, hb⟩ := hu
  have hb0 : b = 0 := by
    have := hb (E⁻¹ z)
    have hz' : E (E⁻¹ z) = z := by rw [← Equiv.Perm.mul_apply, mul_inv_cancel, Equiv.Perm.one_apply]
    simp only [Equiv.Perm.mul_apply, hz', hz, Units.val_one, one_mul] at this
    linear_combination -this
  have : E⁻¹ * h * E = 1 := by ext x; rw [hb, hb0]; simp
  have := congrArg (fun w => E * w * E⁻¹) this
  simpa [mul_assoc] using this

section twoorbits
variable {V : Type*} [Fintype V] [DecidableEq V]
open Part0

/-- **Two unfused orbits of one prime r ∉ {p, q} carry an orbital of at most r pairs** — the
same-position class of `enumeration-proof.md` Part D2's non-permuted case.  The stabiliser of
x ∈ O₁ acts on O₂ as a q-group, so fixes some y ∈ O₂; then g·x determines g·y. -/
theorem two_orbits {p q : ℕ} (Γ : Subgroup (Equiv.Perm V)) (C : OliverChain Γ p q)
    (hp : p.Prime) (hq : q.Prime) (hrp : r ≠ p) (hrq : r ≠ q) (O₁ O₂ : Finset V)
    (hO₁ : ∀ g ∈ Γ, ∀ x ∈ O₁, g x ∈ O₁) (hO₂ : ∀ g ∈ Γ, ∀ x ∈ O₂, g x ∈ O₂)
    (htr₁ : ∀ x ∈ O₁, ∀ y ∈ O₁, ∃ g ∈ Γ, g x = y) (htr₂ : ∀ x ∈ O₂, ∀ y ∈ O₂, ∃ g ∈ Γ, g x = y)
    (hc₁ : O₁.card = r) (hc₂ : O₂.card = r) (hd : Disjoint O₁ O₂) : OrbLe Γ r := by
  classical
  have hrp' : r.Prime := hr.out
  have : NeZero r := ⟨hrp'.ne_zero⟩
  obtain ⟨ρ₁, e₁, E₁, hρ₁, htt₁, hm₁⟩ := orbit_coords Γ C hp hq O₁ hO₁ htr₁ hc₁ hrp
  obtain ⟨ρ₂, e₂, E₂, hρ₂, -, hm₂⟩ := orbit_coords Γ C hp hq O₂ hO₂ htr₂ hc₂ hrp
  -- an r-power element acts with trivial r-th power on each orbit
  have trp : ∀ (ρ : Γ →* Equiv.Perm (ZMod r)) (E : Equiv.Perm (ZMod r)),
      (∀ g : Γ, ∃ u : (ZMod r)ˣ, HasMul E (ρ g) u ∧ ∃ k, u ^ (q ^ k) = 1) →
      ∀ (g : Γ) (k : ℕ), g ^ (r ^ k) = 1 → ρ g ^ r = 1 := by
    intro ρ E hm g k hk
    obtain ⟨u, hu, -⟩ := hm g
    exact affine_rpow hu (by rw [← map_pow, hk, map_one])
  -- r divides |ρ₁(Γ)|
  have hrdvd : r ∣ Nat.card ρ₁.range := by
    have hpre : MulAction.IsPretransitive ρ₁.range (ZMod r) :=
      ⟨fun x y => by obtain ⟨g, hg⟩ := htt₁ x y; exact ⟨⟨ρ₁ g, g, rfl⟩, hg⟩⟩
    have := (MulAction.index_stabilizer_of_transitive ρ₁.range (0 : ZMod r)).trans (Nat.card_zmod r)
    exact (dvd_of_eq this.symm).trans (Subgroup.index_dvd_card _)
  have : Fact r.Prime := hr
  -- the claim: an element fixing a point of O₁ acts on O₂ as a q-element
  set z₁ : ZMod r := 0
  have claim : ∀ g : Γ, ρ₁ g z₁ = z₁ → ∃ k, ρ₂ g ^ (q ^ k) = 1 := by
    intro g hg
    obtain ⟨u₁, hu₁, k₁, hk₁⟩ := hm₁ g
    obtain ⟨u₂, hu₂, k₂, hk₂⟩ := hm₂ g
    have h1 : ρ₁ g ^ (q ^ k₁) = 1 := by
      have hm : HasMul E₁ (ρ₁ g ^ (q ^ k₁)) 1 := hk₁ ▸ hu₁.pow _
      refine hasMul_one_fix hm (z := z₁) ?_
      clear hm
      induction (q ^ k₁) with
      | zero => simp
      | succ n ih => rw [pow_succ, Equiv.Perm.mul_apply, hg, ih]
    have h2 : (ρ₂ g ^ (q ^ k₂)) ^ r = 1 := hasMul_one_pow (hk₂ ▸ hu₂.pow _)
    refine ⟨k₁ + k₂, ?_⟩
    set G := g ^ (q ^ (k₁ + k₂))
    have hG1 : ρ₁ G = 1 := by
      simp only [G, map_pow, pow_add, pow_mul, h1, one_pow]
    have hG2 : ρ₂ G ^ r = 1 := by
      simp only [G, map_pow, pow_add]
      rw [mul_comm (q ^ k₁), pow_mul, ← pow_mul, mul_comm, pow_mul, h2, one_pow]
    -- write |G| = r^a·c with r ∤ c, and G₁ := G^c, an r-element
    have hs : orderOf G ≠ 0 := (orderOf_pos G).ne'
    obtain ⟨a, c, hc, hsac⟩ := Nat.exists_eq_pow_mul_and_not_dvd hs r hrp'.one_lt.ne'
    set G₁ := G ^ c
    have hG₁r : G₁ ^ (r ^ a) = 1 := by
      rw [← pow_mul, mul_comm, ← hsac, pow_orderOf_eq_one]
    have hP0 : IsPGroup r (Subgroup.zpowers G₁) := by
      intro ⟨y, hy⟩
      obtain ⟨j, rfl⟩ := Subgroup.mem_zpowers_iff.mp hy
      refine ⟨a, Subtype.ext ?_⟩
      simp only [SubmonoidClass.mk_pow, OneMemClass.coe_one]
      rw [← zpow_natCast, ← zpow_mul, mul_comm, zpow_mul, zpow_natCast, hG₁r, one_zpow]
    obtain ⟨P, hP⟩ := hP0.exists_le_sylow
    have hPc : IsCyclic P := Chain.rsub_cyclic C hrp' hp hq hrp hrq P.isPGroup
    obtain ⟨w, hw⟩ := IsCyclic.exists_generator (α := P)
    -- w acts nontrivially on O₁
    have hw1 : ρ₁ w ≠ 1 := by
      intro h
      have hle : P.toSubgroup ≤ ρ₁.ker := by
        intro y hy
        obtain ⟨j, hj⟩ := Subgroup.mem_zpowers_iff.mp (hw ⟨y, hy⟩)
        rw [MonoidHom.mem_ker]
        have := congrArg (fun t : P => ρ₁ (t : Γ)) hj
        simp only at this
        rw [← this]; simp [map_zpow, h]
      have h1 := Subgroup.index_dvd_of_le hle
      rw [Subgroup.index_ker] at h1
      exact P.not_dvd_index (hrdvd.trans h1)
    -- w has r-power order
    obtain ⟨b, hb⟩ := P.isPGroup w
    have hwr : (w : Γ) ^ (r ^ b) = 1 := by
      have := congrArg (fun t : P => (t : Γ)) hb; simpa using this
    have hw1r := trp ρ₁ E₁ hm₁ w b hwr
    have hw2r := trp ρ₂ E₂ hm₂ w b hwr
    -- G₁ = w^j with r ∣ j
    obtain ⟨j, hj⟩ := Subgroup.mem_zpowers_iff.mp (hw ⟨G₁, hP (Subgroup.mem_zpowers _)⟩)
    have hj' : (w : Γ) ^ j = G₁ := by
      have := congrArg (fun t : P => (t : Γ)) hj; simpa using this
    have hord : orderOf (ρ₁ w) = r := by
      rcases (Nat.dvd_prime hrp').mp (orderOf_dvd_of_pow_eq_one hw1r) with h | h
      · exact absurd (orderOf_eq_one_iff.mp h) hw1
      · exact h
    have hG₁1 : ρ₁ G₁ = 1 := by simp [G₁, hG1]
    have hrj : (r : ℤ) ∣ j := by
      have hz : (ρ₁ w) ^ j = 1 := by rw [← map_zpow, hj', hG₁1]
      have := orderOf_dvd_iff_zpow_eq_one.mpr hz
      rwa [hord] at this
    obtain ⟨m, rfl⟩ := hrj
    have hG₁2 : ρ₂ G₁ = 1 := by
      rw [← hj', map_zpow, zpow_mul, zpow_natCast, hw2r, one_zpow]
    -- so ρ₂ G has order dividing both r and c
    have hc1 : ρ₂ G ^ c = 1 := by rw [← map_pow]; exact hG₁2
    have h3 := Nat.dvd_gcd (orderOf_dvd_of_pow_eq_one hG2) (orderOf_dvd_of_pow_eq_one hc1)
    have hcop : Nat.gcd r c = 1 := (Nat.coprime_comm.mp ((Nat.Prime.coprime_iff_not_dvd hrp').mpr hc)).symm
    rw [hcop, Nat.dvd_one, orderOf_eq_one_iff] at h3
    rw [← map_pow]; exact h3
  -- the stabiliser of z₁ acts on O₂ through a q-group, so it fixes some z₂
  set stab : Subgroup Γ := (MulAction.stabilizer (Equiv.Perm (ZMod r)) z₁).comap ρ₁
  set Q : Subgroup (Equiv.Perm (ZMod r)) := stab.map ρ₂
  have : Fact q.Prime := ⟨hq⟩
  have hQ : IsPGroup q Q := by
    intro ⟨σ, hσ⟩
    obtain ⟨g, hg, rfl⟩ := Subgroup.mem_map.mp hσ
    obtain ⟨k, hk⟩ := claim g hg
    exact ⟨k, Subtype.ext (by simpa using hk)⟩
  have hmod := hQ.card_modEq_card_fixedPoints (ZMod r)
  rw [Nat.card_zmod] at hmod
  obtain ⟨⟨z₂, hz₂⟩⟩ : Nonempty (MulAction.fixedPoints Q (ZMod r)) := by
    by_contra hne
    rw [not_nonempty_iff] at hne
    rw [Nat.card_of_isEmpty] at hmod
    have : q ∣ r := Nat.dvd_of_mod_eq_zero hmod
    exact hrq ((Nat.prime_dvd_prime_iff_eq hq hrp').mp this).symm
  set x : V := (e₁.symm z₁ : V)
  set y : V := (e₂.symm z₂ : V)
  have hx : x ∈ O₁ := (e₁.symm z₁).2
  have hy : y ∈ O₂ := (e₂.symm z₂).2
  have hfix : ∀ g ∈ Γ, g x = x → g y = y := by
    intro g hg hgx
    have h1 : ρ₁ ⟨g, hg⟩ z₁ = z₁ := by
      apply e₁.symm.injective; apply Subtype.ext
      rw [hρ₁]; exact hgx
    have hmem : ρ₂ ⟨g, hg⟩ ∈ Q := Subgroup.mem_map.mpr ⟨⟨g, hg⟩, h1, rfl⟩
    have h2 : ρ₂ ⟨g, hg⟩ z₂ = z₂ := hz₂ ⟨_, hmem⟩
    have := hρ₂ ⟨g, hg⟩ z₂
    rw [h2] at this; exact this.symm
  -- the orbital of {x, y}: g·x determines g·y
  have hxy : x ≠ y := fun h => disjoint_left.mp hd hx (h ▸ hy)
  let ψ : V → V := fun u => if h : ∃ g ∈ Γ, g x = u then h.choose y else u
  refine ⟨s(x, y), by simp [hxy], ?_⟩
  calc (D2.orbit2 Γ s(x, y)).card ≤ (O₁.image (fun u => s(u, ψ u))).card := by
        apply card_le_card
        intro w hw
        obtain ⟨g, hg, rfl⟩ := mem_image.mp hw
        simp only [mem_filter, mem_univ, true_and] at hg
        refine mem_image.mpr ⟨g x, hO₁ g hg x hx, ?_⟩
        have hex : ∃ g' ∈ Γ, g' x = g x := ⟨g, hg, rfl⟩
        simp only [ψ, Sym2.map_mk, hex, ↓reduceDIte]
        obtain ⟨hg', hg'x⟩ := hex.choose_spec
        have := hfix (hex.choose⁻¹ * g) (Γ.mul_mem (Γ.inv_mem hg') hg)
          (by rw [Equiv.Perm.mul_apply]; exact Equiv.Perm.inv_eq_iff_eq.mpr hg'x.symm)
        rw [Equiv.Perm.mul_apply, Equiv.Perm.inv_eq_iff_eq] at this
        rw [this]
    _ ≤ O₁.card := card_image_le
    _ = r := hc₁

end twoorbits

end Part0Fr

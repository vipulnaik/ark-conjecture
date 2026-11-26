/-
# `RGlue.lean` — the pair-orbitals inside a foreign block ℤ/r, for any group of the Part E shape
-/
import Evasive
import PartEF

set_option linter.unusedSectionVars false

namespace RGlue
open Finset Equiv Classical

variable {A : Type*} [Fintype A] [DecidableEq A] {r : ℕ} [Fact r.Prime]

/-- Multiplication by w on ℤ/r, identity on A. -/
def mulR (w : (ZMod r)ˣ) : Perm (A ⊕ ZMod r) := Perm.sumCongr 1 (PartE1.act (⟨w, 0⟩ : PartE1.Aff1 (ZMod r)))

@[simp] theorem mulR_inl (w : (ZMod r)ˣ) (a : A) : mulR (A := A) w (Sum.inl a) = Sum.inl a := rfl
@[simp] theorem mulR_inr (w : (ZMod r)ˣ) (z : ZMod r) :
    mulR (A := A) w (Sum.inr z) = Sum.inr ((w : ZMod r) * z) := by simp [mulR]

/-- The hypotheses on G: on ℤ/r it acts by z ↦ u·z + v with u ∈ U, every such map is realised,
and multiplication by w normalises G. -/
structure Shape (G : Subgroup (Perm (A ⊕ ZMod r))) (U : Subgroup (ZMod r)ˣ) (w : (ZMod r)ˣ) : Prop where
  act : ∀ g ∈ G, ∃ u ∈ U, ∃ v : ZMod r, ∀ z, g (Sum.inr z) = Sum.inr ((u : ZMod r) * z + v)
  real : ∀ u ∈ U, ∀ v : ZMod r, ∃ g ∈ G, ∀ z, g (Sum.inr z) = Sum.inr ((u : ZMod r) * z + v)
  norm : ∀ g ∈ G, mulR w * g * (mulR w)⁻¹ ∈ G
  norm' : ∀ g ∈ G, (mulR w)⁻¹ * g * mulR w ∈ G

/-- The pair class of the difference δ. -/
def cls (δ : ZMod r) : Sym2 (A ⊕ ZMod r) := s(Sum.inr 0, Sum.inr δ)

/-! ## Orbits of a group of Perm, as sets -/

section orbit
variable {α : Type*} [Fintype α] [DecidableEq α] (G : Subgroup (Perm α))

theorem mem_orbit2 {e x : Sym2 α} : x ∈ D2.orbit2 G e ↔ ∃ g ∈ G, Sym2.map g e = x := by
  unfold D2.orbit2; simp [mem_image]

theorem orbit2_eq_of_mem {e e' : Sym2 α} (h : e' ∈ D2.orbit2 G e) : D2.orbit2 G e' = D2.orbit2 G e := by
  obtain ⟨h0, hh0, rfl⟩ := (mem_orbit2 G).mp h
  ext x; rw [mem_orbit2, mem_orbit2]
  constructor
  · rintro ⟨g, hg, rfl⟩; exact ⟨g * h0, G.mul_mem hg hh0, by rw [Sym2.map_map]; rfl⟩
  · rintro ⟨g, hg, rfl⟩
    refine ⟨g * h0⁻¹, G.mul_mem hg (G.inv_mem hh0), ?_⟩
    rw [Sym2.map_map]; congr 1; ext a; simp

theorem self_mem_orbit2 (e : Sym2 α) : e ∈ D2.orbit2 G e :=
  (mem_orbit2 G).mpr ⟨1, G.one_mem, by simp⟩

/-- Conjugation by σ normalising G carries orbits to orbits. -/
theorem orbit2_image (σ : Perm α) (hn : ∀ g ∈ G, σ * g * σ⁻¹ ∈ G) (hn' : ∀ g ∈ G, σ⁻¹ * g * σ ∈ G)
    (e : Sym2 α) : (D2.orbit2 G e).image (Sym2.map σ) = D2.orbit2 G (Sym2.map σ e) := by
  ext x; rw [mem_image, mem_orbit2]
  constructor
  · rintro ⟨y, hy, rfl⟩
    obtain ⟨g, hg, rfl⟩ := (mem_orbit2 G).mp hy
    refine ⟨σ * g * σ⁻¹, hn g hg, ?_⟩
    rw [Sym2.map_map, Sym2.map_map]; congr 1; ext a; simp
  · rintro ⟨g, hg, rfl⟩
    refine ⟨Sym2.map (σ⁻¹ * g * σ) e, (mem_orbit2 G).mpr ⟨_, hn' g hg, rfl⟩, ?_⟩
    rw [Sym2.map_map, Sym2.map_map]; congr 1; ext a; simp

end orbit

/-! ## The orbitals inside ℤ/r -/

section shape
variable {G : Subgroup (Perm (A ⊕ ZMod r))} {U : Subgroup (ZMod r)ˣ} {w : (ZMod r)ˣ}
  (hS : Shape G U w)
include hS

/-- Every pair inside ℤ/r lies in the orbit of its difference class. -/
theorem orbit_pair (z1 z2 : ZMod r) :
    D2.orbit2 G s(Sum.inr z1, Sum.inr z2) = D2.orbit2 G (cls (A := A) (z2 - z1)) := by
  obtain ⟨g, hg, hgz⟩ := hS.real 1 U.one_mem (-z1)
  apply orbit2_eq_of_mem
  rw [mem_orbit2]
  refine ⟨g⁻¹, G.inv_mem hg, ?_⟩
  have h1 : g (Sum.inr z1) = Sum.inr 0 := by rw [hgz]; simp
  have h2 : g (Sum.inr z2) = Sum.inr (z2 - z1) := by rw [hgz]; simp; ring
  simp only [cls, Sym2.map_mk, ← h1, ← h2]
  simp

/-- u·δ and δ, for u ∈ U, are in one orbit. -/
theorem orbit_mul {u : (ZMod r)ˣ} (hu : u ∈ U) (δ : ZMod r) :
    D2.orbit2 G (cls (A := A) ((u : ZMod r) * δ)) = D2.orbit2 G (cls (A := A) δ) := by
  obtain ⟨g, hg, hgz⟩ := hS.real u hu 0
  apply orbit2_eq_of_mem
  rw [mem_orbit2]
  exact ⟨g, hg, by simp [cls, Sym2.map_mk, hgz]⟩

/-- −δ and δ are in one orbit. -/
theorem orbit_neg (δ : ZMod r) :
    D2.orbit2 G (cls (A := A) (-δ)) = D2.orbit2 G (cls (A := A) δ) := by
  calc D2.orbit2 G (cls (A := A) (-δ)) = D2.orbit2 G s(Sum.inr (-δ), Sum.inr 0) := by
        rw [cls, Sym2.eq_swap]
    _ = D2.orbit2 G (cls (A := A) (0 - -δ)) := orbit_pair hS _ _
    _ = D2.orbit2 G (cls (A := A) δ) := by simp

/-- Orbits of difference classes: equality forces δ' = ±u·δ with u ∈ U. -/
theorem orbit_cls_eq {δ δ' : ZMod r} (h : D2.orbit2 G (cls (A := A) δ') = D2.orbit2 G (cls (A := A) δ)) :
    ∃ u ∈ U, δ' = (u : ZMod r) * δ ∨ δ' = -((u : ZMod r) * δ) := by
  have hm : cls (A := A) δ' ∈ D2.orbit2 G (cls δ) := h ▸ self_mem_orbit2 G _
  obtain ⟨g, hg, hge⟩ := (mem_orbit2 G).mp hm
  obtain ⟨u, hu, v, huv⟩ := hS.act g hg
  refine ⟨u, hu, ?_⟩
  simp only [cls, Sym2.map_mk, huv, mul_zero, zero_add, Sym2.eq_iff, Sum.inr.injEq] at hge
  rcases hge with ⟨h1, h2⟩ | ⟨h1, h2⟩
  · left; rw [← h2, h1]; ring
  · right; linear_combination -h1 + h2

/-- σ = mulR w moves the class of δ to the class of w·δ. -/
theorem orbit_shift (δ : ZMod r) :
    (D2.orbit2 G (cls (A := A) δ)).image (Sym2.map (mulR w)) = D2.orbit2 G (cls (A := A) ((w : ZMod r) * δ)) := by
  rw [orbit2_image G (mulR w) hS.norm hS.norm']
  simp [cls, Sym2.map_mk]

end shape

/-! ## Indexing the ℤ/r orbitals by ℤ/k -/

section index
variable {G : Subgroup (Perm (A ⊕ ZMod r))} {U : Subgroup (ZMod r)ˣ} {w : (ZMod r)ˣ}
  (hS : Shape G U w) {q k : ℕ} (hUq : ∀ x, x ∈ U ↔ x ^ q = 1) (hqo : q % 2 = 1)
  (hw : ∀ x : (ZMod r)ˣ, x ∈ Subgroup.zpowers w) (hk : r - 1 = 2 * q * k)

include hUq hqo in
theorem pm_of_pow {x : (ZMod r)ˣ} (hx : x ^ (2 * q) = 1) : x ∈ U ∨ -x ∈ U := by
  have h2 : (x ^ q) ^ 2 = 1 := by rw [← pow_mul, mul_comm]; exact hx
  have : x ^ q = 1 ∨ x ^ q = -1 := by
    have h3 : ((x ^ q : (ZMod r)ˣ) : ZMod r) ^ 2 = 1 := by rw [← Units.val_pow_eq_pow_val, h2]; rfl
    rcases sq_eq_one_iff.mp h3 with h | h
    · left; exact Units.ext h
    · right; exact Units.ext (by simpa using h)
  rcases this with h | h
  · left; exact (hUq x).mpr h
  · right; rw [hUq, neg_pow, Odd.neg_one_pow (Nat.odd_iff.mpr hqo), h]; simp

include hS hUq hqo hw hk in
/-- The orbit of the class of w^m depends only on m mod k. -/
theorem orbit_wpow_eq (m t : ℕ) :
    D2.orbit2 G (cls (A := A) (((w ^ (m + k * t) : (ZMod r)ˣ) : ZMod r))) =
      D2.orbit2 G (cls (A := A) ((w ^ m : (ZMod r)ˣ) : ZMod r)) := by
  have hwk : (w ^ k) ^ (2 * q) = 1 := by
    rw [← pow_mul, show k * (2 * q) = r - 1 by rw [hk]; ring]
    have : orderOf w = r - 1 := by
      rw [orderOf_eq_card_of_forall_mem_zpowers hw, Nat.card_eq_fintype_card, ZMod.card_units]
    rw [← this]; exact pow_orderOf_eq_one w
  induction t with
  | zero => simp
  | succ t ih =>
    rw [show m + k * (t + 1) = (m + k * t) + k by ring, pow_add, mul_comm, Units.val_mul]
    rcases pm_of_pow hUq hqo hwk with h | h
    · rw [orbit_mul hS h, ih]
    · have : ((w ^ k : (ZMod r)ˣ) : ZMod r) * ((w ^ (m + k * t) : (ZMod r)ˣ) : ZMod r) =
          -(((-(w ^ k) : (ZMod r)ˣ) : ZMod r) * ((w ^ (m + k * t) : (ZMod r)ˣ) : ZMod r)) := by
        simp
      rw [this, orbit_neg hS, orbit_mul hS h, ih]

include hS hUq hqo hw hk in
theorem orbit_wpow_mod (m m' : ℕ) (h : m ≡ m' [MOD k]) :
    D2.orbit2 G (cls (A := A) ((w ^ m : (ZMod r)ˣ) : ZMod r)) =
      D2.orbit2 G (cls (A := A) ((w ^ m' : (ZMod r)ˣ) : ZMod r)) := by
  rcases le_total m m' with hle | hle
  · obtain ⟨t, ht⟩ := (Nat.modEq_iff_dvd' hle).mp h
    rw [show m' = m + k * t by omega, orbit_wpow_eq hS hUq hqo hw hk]
  · obtain ⟨t, ht⟩ := (Nat.modEq_iff_dvd' hle).mp h.symm
    rw [show m = m' + k * t by omega, orbit_wpow_eq hS hUq hqo hw hk]

include hS hUq hw hk in
theorem mod_of_orbit_eq (m m' : ℕ)
    (h : D2.orbit2 G (cls (A := A) ((w ^ m' : (ZMod r)ˣ) : ZMod r)) =
      D2.orbit2 G (cls (A := A) ((w ^ m : (ZMod r)ˣ) : ZMod r))) : m ≡ m' [MOD k] := by
  obtain ⟨u, hu, hcase⟩ := orbit_cls_eq hS h
  have hu2 : ((u : ZMod r)) ^ (2 * q) = 1 := by
    rw [← Units.val_pow_eq_pow_val, pow_mul', (hUq u).mp hu, one_pow]; rfl
  simp only [Units.val_pow_eq_pow_val] at hcase
  have e1 : ((w : ZMod r) ^ m') ^ (2 * q) = ((w : ZMod r) ^ m) ^ (2 * q) := by
    rcases hcase with h1 | h1 <;> rw [h1]
    · rw [mul_pow, hu2, one_mul]
    · rw [neg_pow, Even.neg_one_pow ⟨q, by ring⟩, one_mul, mul_pow, hu2, one_mul]
  have heq : w ^ (2 * q * m') = w ^ (2 * q * m) := by
    apply Units.ext
    simp only [Units.val_pow_eq_pow_val]
    rw [show 2 * q * m' = m' * (2 * q) by ring, show 2 * q * m = m * (2 * q) by ring,
      pow_mul (w : ZMod r) m', pow_mul (w : ZMod r) m]
    exact e1
  have hord : orderOf w = r - 1 := by
    rw [orderOf_eq_card_of_forall_mem_zpowers hw, Nat.card_eq_fintype_card, ZMod.card_units]
  have := (pow_eq_pow_iff_modEq.mp heq)
  rw [hord, hk] at this
  have hq0 : 2 * q ≠ 0 := by
    intro h0
    have : q = 0 := by omega
    subst this
    have := (Fact.out : r.Prime).two_le
    simp at hk; omega
  exact (Nat.ModEq.mul_left_cancel' hq0 this).symm

/-- The k orbitals inside ℤ/r: O_j is the orbit of the class of w^j. -/
noncomputable def O (G : Subgroup (Perm (A ⊕ ZMod r))) (w : (ZMod r)ˣ) (k : ℕ) [NeZero k] (j : ZMod k) :
    Finset (Sym2 (A ⊕ ZMod r)) :=
  D2.orbit2 G (cls (A := A) ((w ^ j.val : (ZMod r)ˣ) : ZMod r))

variable [NeZero k]

include hS hUq hqo hw hk in
theorem O_injective : Function.Injective (O G w k) := by
  intro j j' h
  have := mod_of_orbit_eq hS hUq hw hk j.val j'.val h.symm
  rw [← ZMod.natCast_zmod_val j, ← ZMod.natCast_zmod_val j']
  exact (ZMod.natCast_eq_natCast_iff _ _ _).mpr this

theorem cls_nondiag {δ : ZMod r} (hδ : δ ≠ 0) : ¬ (cls (A := A) δ).IsDiag := by
  simp [cls, Sym2.mk_isDiag_iff, Ne.symm hδ]

omit [NeZero k] in
theorem O_mem (j : ZMod k) [NeZero k] : O G w k j ∈ Evasive.orbitals G := by
  unfold Evasive.orbitals O
  exact mem_image.mpr ⟨_, by simp only [mem_filter, mem_univ, true_and]; exact cls_nondiag (Units.ne_zero _), rfl⟩

include hS hUq hqo hw hk in
theorem O_shift (j : ZMod k) : (O G w k j).image (Sym2.map (mulR w)) = O G w k (j + 1) := by
  unfold O
  rw [orbit_shift hS, ← Units.val_mul, ← pow_succ']
  apply orbit_wpow_mod hS hUq hqo hw hk
  apply (ZMod.natCast_eq_natCast_iff _ _ _).mp
  simp

include hS hUq hqo hw hk in
/-- Every orbital of a pair inside ℤ/r is one of the O_j. -/
theorem R_orbit_eq {z1 z2 : ZMod r} (hz : z1 ≠ z2) :
    ∃ j : ZMod k, D2.orbit2 G s(Sum.inr z1, Sum.inr z2) = O G w k j := by
  rw [orbit_pair hS]
  have hδ : z2 - z1 ≠ 0 := sub_ne_zero.mpr (Ne.symm hz)
  obtain ⟨m, hm⟩ : ∃ m : ℕ, w ^ m = Units.mk0 _ hδ := by
    have := hw (Units.mk0 _ hδ)
    rw [← mem_powers_iff_mem_zpowers] at this
    exact this
  refine ⟨(m : ZMod k), ?_⟩
  unfold O
  have : z2 - z1 = ((w ^ m : (ZMod r)ˣ) : ZMod r) := by rw [hm]; rfl
  rw [this]
  apply orbit_wpow_mod hS hUq hqo hw hk
  apply (ZMod.natCast_eq_natCast_iff _ _ _).mp
  simp

include hS hUq hqo hw hk in
/-- The O_j together hold all C(r,2) pairs inside ℤ/r. -/
theorem O_union_card : r.choose 2 ≤ ((univ : Finset (ZMod k)).biUnion (O G w k)).card := by
  set T : Finset (Sym2 (ZMod r)) := (univ.offDiag).image Sym2.mk.uncurry
  have hT : T.card = r.choose 2 := by rw [Sym2.card_image_offDiag, card_univ, ZMod.card]
  rw [← hT, ← card_image_of_injective T (Sym2.map.injective (Sum.inr_injective (α := A)))]
  apply card_le_card
  intro e he
  simp only [T, mem_image, mem_offDiag, mem_univ, true_and, Prod.exists] at he
  obtain ⟨f, ⟨a, b, hab, rfl⟩, rfl⟩ := he
  obtain ⟨j, hj⟩ := R_orbit_eq hS hUq hqo hw hk hab
  rw [mem_biUnion]
  refine ⟨j, mem_univ _, ?_⟩
  rw [← hj]
  simpa using self_mem_orbit2 G s(Sum.inr a, Sum.inr b)

end index

end RGlue

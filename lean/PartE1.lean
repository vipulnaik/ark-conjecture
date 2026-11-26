/-
# `PartE1.lean` — Part E (realisability) for a class with F = 1

`enumeration-proof.md` Part E's realisability, for the configurations with one unfused
p-characteristic block 𝔽_c (c = p^b, full twist) and one foreign block ℤ/r with twist of odd
prime order q: these are the Σ₀ cells at even n.  An explicit permutation group, an explicit
Oliver chain, and lower bounds on every pair-orbital.

* **The group.** `Aff1 k` (x ↦ a·x + s) as a group, acting by `act`; on K ⊕ ℤ/r the product
  `Φ`, restricted to `Hq U`: K's full affine group alongside z ↦ u·z + v with u ∈ U, the order-q
  subgroup of (ℤ/r)ˣ.  `G U` is the image in Perm(K ⊕ ℤ/r).
* **The Oliver chain** (`chainH`, then `chainG` by `Chain.OliverChain.map`): N₂ = translations
  of K, a p-group because K has characteristic p (`N2_pgroup`); N₁ = trivial ℤ/r-multiplier,
  with N₁/N₂ ≅ Kˣ × ℤ/r cyclic since |Kˣ| = c − 1 is prime to r (`layer_cyclic`, by the Chinese
  remainder theorem on an explicit generator); G/N₁ a q-group since every u has u^q = 1
  (`top_pgroup`).  Coherence r ∤ c − 1 is exactly what the layer needs.
* **The orbitals.** Pairs inside K: one orbital of size C(c,2), since the affine group is
  2-homogeneous (`orbit_KK`).  Mixed pairs: one orbital of size c·r (`orbit_KR`).  Pairs inside
  ℤ/r: orbitals of size ≥ q·r, because −1 ∉ U when q is odd (`orbit_RR`).  So every orbital is
  ≥ min(C(c,2), q·r, c·r) (`orbit_ge`), which is SAFE = REFINED of the configuration.
* **`partE_F1`, `partE_F1_exists`** — the realisation, for any finite field of order p^b, and
  packaged with `GaloisField p b`.
* **`sigma0_F1_realised`** — Σ₀'s floor at the F = 1 classes (n ≡ 0, 2, 4, 6, 8, 10 mod 12)
  under either quantifier, **with Part E proved rather than assumed**: L-eventually n is realised
  by an Oliver group all of whose pair-orbitals have size ≥ m, 2m ≥ ((1 − ε)·δ₀ − κ/n)·n(n − 1).

Not covered: F ≥ 2 (the odd classes), which needs the fused class and, at F_mid > 1, the
entangled cyclic-layer generator.
-/
import D2
import Chain
import E6
import SigmaHalf

namespace PartE1
open Equiv Finset

/-! ## The affine group of a field, as a group -/

@[ext] structure Aff1 (k : Type*) [Field k] where
  a : kˣ
  s : k

variable {k : Type*} [Field k]

instance : Mul (Aff1 k) := ⟨fun x y => ⟨x.a * y.a, x.a * y.s + x.s⟩⟩
instance : One (Aff1 k) := ⟨⟨1, 0⟩⟩
instance : Inv (Aff1 k) := ⟨fun x => ⟨x.a⁻¹, -(x.a⁻¹ : kˣ) * x.s⟩⟩

@[simp] theorem mul_a (x y : Aff1 k) : (x * y).a = x.a * y.a := rfl
@[simp] theorem mul_s (x y : Aff1 k) : (x * y).s = x.a * y.s + x.s := rfl
@[simp] theorem one_a : (1 : Aff1 k).a = 1 := rfl
@[simp] theorem one_s : (1 : Aff1 k).s = 0 := rfl
@[simp] theorem inv_a (x : Aff1 k) : x⁻¹.a = x.a⁻¹ := rfl
@[simp] theorem inv_s (x : Aff1 k) : x⁻¹.s = -(x.a⁻¹ : kˣ) * x.s := rfl

instance : Group (Aff1 k) where
  mul_assoc x y z := by ext <;> simp [mul_assoc, mul_add]; ring
  one_mul x := by ext <;> simp
  mul_one x := by ext <;> simp
  inv_mul_cancel x := by ext <;> simp

/-- The action x ↦ a·x + s. -/
def Aff1.toPerm (x : Aff1 k) : Perm k where
  toFun y := x.a * y + x.s
  invFun y := (x.a⁻¹ : kˣ) * (y - x.s)
  left_inv y := by simp
  right_inv y := by simp

def act : Aff1 k →* Perm k where
  toFun := Aff1.toPerm
  map_one' := by ext y; simp [Aff1.toPerm]
  map_mul' x y := by ext z; simp [Aff1.toPerm, Perm.mul_apply]; ring

@[simp] theorem act_apply (x : Aff1 k) (y : k) : act x y = x.a * y + x.s := rfl

theorem pow_trans (s : k) (n : ℕ) : (⟨1, s⟩ : Aff1 k) ^ n = ⟨1, n * s⟩ := by
  induction n with
  | zero => ext <;> simp
  | succ m ih => rw [pow_succ, ih]; ext <;> simp; ring

theorem pow_mul0 (w : kˣ) (n : ℕ) : (⟨w, 0⟩ : Aff1 k) ^ n = ⟨w ^ n, 0⟩ := by
  induction n with
  | zero => ext <;> simp
  | succ m ih => rw [pow_succ, ih]; ext <;> simp [pow_succ]

/-! ## The group on K ⊕ ZMod r, and its Oliver chain -/

variable (K R : Type*) [Field K] [Field R]

/-- The pair of affine groups, acting on K ⊕ R. -/
def Φ : Aff1 K × Aff1 R →* Perm (K ⊕ R) :=
  (Perm.sumCongrHom K R).comp (MonoidHom.prodMap act act)

theorem Φ_inl (h : Aff1 K × Aff1 R) (x : K) : Φ K R h (Sum.inl x) = Sum.inl (h.1.a * x + h.1.s) := rfl
theorem Φ_inr (h : Aff1 K × Aff1 R) (z : R) : Φ K R h (Sum.inr z) = Sum.inr (h.2.a * z + h.2.s) := rfl

variable {K R}

/-- The ambient group: R's multiplier restricted to a subgroup U of Rˣ. -/
def Hq (U : Subgroup Rˣ) : Subgroup (Aff1 K × Aff1 R) where
  carrier := {h | h.2.a ∈ U}
  mul_mem' := fun ha hb => by simpa using U.mul_mem ha hb
  one_mem' := by simp [U.one_mem]
  inv_mem' := fun ha => by simpa using U.inv_mem ha

/-- N₁: trivial R-multiplier. -/
def N1 : Subgroup (Aff1 K × Aff1 R) where
  carrier := {h | h.2.a = 1}
  mul_mem' := fun ha hb => by simp_all
  one_mem' := by simp
  inv_mem' := fun ha => by simp_all

/-- N₂: translations of K only. -/
def N2 : Subgroup (Aff1 K × Aff1 R) where
  carrier := {h | h.1.a = 1 ∧ h.2 = 1}
  mul_mem' := fun ha hb => by simp_all
  one_mem' := by simp
  inv_mem' := fun ha => by
    simp only [Set.mem_ofPred_eq] at ha ⊢
    obtain ⟨h1, h2⟩ := ha
    refine ⟨by simp [h1], ?_⟩
    rw [Prod.snd_inv, h2, inv_one]

theorem N1_normal : (N1 : Subgroup (Aff1 K × Aff1 R)).Normal := by
  constructor
  intro h hh g
  show (g * h * g⁻¹).2.a = 1
  have : h.2.a = 1 := hh
  simp [this]

theorem N2_normal : (N2 : Subgroup (Aff1 K × Aff1 R)).Normal := by
  constructor
  intro h hh g
  obtain ⟨h1, h2⟩ := hh
  refine ⟨?_, ?_⟩
  · simp [h1]
  · simp [h2]

instance : (N1 : Subgroup (Aff1 K × Aff1 R)).Normal := N1_normal
instance : (N2 : Subgroup (Aff1 K × Aff1 R)).Normal := N2_normal

theorem pow_a (x : Aff1 k) (n : ℕ) : (x ^ n).a = x.a ^ n := by
  induction n with
  | zero => simp
  | succ m ih => rw [pow_succ, mul_a, ih, pow_succ]

theorem N2_le_N1 : (N2 : Subgroup (Aff1 K × Aff1 R)) ≤ N1 := by
  intro h ⟨_, h2⟩
  show h.2.a = 1
  rw [h2]; rfl

/-- N₂ is a p-group: in characteristic p a translation has order dividing p. -/
theorem N2_pgroup (p : ℕ) [Fact p.Prime] [CharP K p] (U : Subgroup Rˣ) :
    IsPGroup p ((N2 : Subgroup (Aff1 K × Aff1 R)).subgroupOf (Hq U)) := by
  intro x
  refine ⟨1, ?_⟩
  obtain ⟨⟨h, hU⟩, hN⟩ := x
  obtain ⟨h1, h2⟩ := (Subgroup.mem_subgroupOf.mp hN : h ∈ (N2 : Subgroup _))
  apply Subtype.ext; apply Subtype.ext
  simp only [pow_one, Subgroup.coe_pow, OneMemClass.coe_one]
  obtain ⟨hk, hr⟩ := h
  simp only at h1 h2
  have hk' : hk = ⟨1, hk.s⟩ := by ext <;> simp [h1]
  rw [Prod.pow_mk, h2, one_pow, hk', pow_trans]
  simp
  rfl

/-- The top quotient is a q-group: every element's q-th power has trivial R-multiplier. -/
theorem top_pgroup (q : ℕ) (U : Subgroup Rˣ) (hU : ∀ u ∈ U, u ^ q = 1) :
    IsPGroup q (Hq (K := K) U ⧸ (N1 : Subgroup (Aff1 K × Aff1 R)).subgroupOf (Hq U)) := by
  intro x
  refine ⟨1, ?_⟩
  induction x using QuotientGroup.induction_on with
  | H h =>
    rw [pow_one, ← QuotientGroup.mk_pow, QuotientGroup.eq_one_iff]
    rw [Subgroup.mem_subgroupOf]
    show ((h : Aff1 K × Aff1 R) ^ q).2.a = 1
    rw [Prod.pow_snd, pow_a]
    exact hU _ h.2

/-- **The cyclic layer.** With K finite, ω a generator of Kˣ, and |Kˣ| coprime to r, the layer
N₁/N₂ ≅ Kˣ × ℤ/r is cyclic, generated by the class of (x ↦ ωx, z ↦ z + 1). -/
theorem layer_cyclic {r : ℕ} [Fact r.Prime] [Fintype K] (U : Subgroup (ZMod r)ˣ)
    (ω : Kˣ) (hω : ∀ a : Kˣ, a ∈ Subgroup.zpowers ω)
    (hco : Nat.Coprime (orderOf ω) r) :
    IsCyclic (((N1 : Subgroup (Aff1 K × Aff1 (ZMod r))).subgroupOf (Hq U)) ⧸
      ((N2 : Subgroup (Aff1 K × Aff1 (ZMod r))).subgroupOf (Hq U)).subgroupOf
        ((N1 : Subgroup (Aff1 K × Aff1 (ZMod r))).subgroupOf (Hq U))) := by
  set h0 : Aff1 K × Aff1 (ZMod r) := (⟨ω, 0⟩, ⟨1, 1⟩) with hh0
  have h0U : h0 ∈ Hq U := by show (1 : (ZMod r)ˣ) ∈ U; exact U.one_mem
  have h0N : (⟨h0, h0U⟩ : Hq U) ∈ (N1 : Subgroup _).subgroupOf (Hq U) := by
    rw [Subgroup.mem_subgroupOf]; rfl
  let g0 : ((N1 : Subgroup (Aff1 K × Aff1 (ZMod r))).subgroupOf (Hq U)) := ⟨⟨h0, h0U⟩, h0N⟩
  refine ⟨⟨(g0 : _ ⧸ _), fun x => ?_⟩⟩
  induction x using QuotientGroup.induction_on with
  | H y =>
    obtain ⟨⟨h, hU⟩, hN⟩ := y
    have h2a : h.2.a = 1 := (Subgroup.mem_subgroupOf.mp hN : h ∈ (N1 : Subgroup _))
    -- h.1.a = ω^j
    obtain ⟨j, hj⟩ : ∃ j : ℕ, ω ^ j = h.1.a := by
      have := hω h.1.a
      rw [← mem_powers_iff_mem_zpowers] at this
      exact this
    obtain ⟨k, hk1, hk2⟩ := Nat.chineseRemainder hco j h.2.s.val
    refine ⟨k, ?_⟩
    simp only [zpow_natCast]
    rw [← QuotientGroup.mk_pow, QuotientGroup.eq, Subgroup.mem_subgroupOf, Subgroup.mem_subgroupOf]
    have hpow : ((g0 ^ k : _) : Hq U).1 = (⟨ω ^ k, 0⟩, ⟨1, (k : ZMod r)⟩) := by
      show h0 ^ k = _
      rw [hh0, Prod.pow_mk, pow_mul0]
      congr 1
      rw [pow_trans]; ext <;> simp
    have hωk : ω ^ k = h.1.a := by
      rw [← hj]; exact (pow_eq_pow_iff_modEq.mpr hk1)
    have hrk : (k : ZMod r) = h.2.s := by
      rw [← ZMod.natCast_zmod_val h.2.s, ZMod.natCast_eq_natCast_iff]; exact hk2
    show ((g0 ^ k)⁻¹ * ⟨⟨h, hU⟩, hN⟩ : _).1.1 ∈ N2
    simp only [Subgroup.coe_mul, Subgroup.coe_inv, Subgroup.coe_pow]
    refine ⟨?_, ?_⟩
    · show (((g0 ^ k : _) : Hq U).1⁻¹ * h).1.a = 1
      rw [hpow]; simp [hωk]
    · show (((g0 ^ k : _) : Hq U).1⁻¹ * h).2 = 1
      rw [hpow]
      obtain ⟨⟨h1, h1s⟩, ⟨h2, h2s⟩⟩ := h
      simp only at h2a hrk ⊢
      ext <;> simp [h2a, hrk]

/-- **The Oliver chain on the abstract group.** -/
def chainH (p q r : ℕ) [Fact p.Prime] [Fact r.Prime] [Fintype K] [CharP K p]
    (U : Subgroup (ZMod r)ˣ) (hU : ∀ u ∈ U, u ^ q = 1)
    (ω : Kˣ) (hω : ∀ a : Kˣ, a ∈ Subgroup.zpowers ω) (hco : Nat.Coprime (orderOf ω) r) :
    Chain.OliverChain (Hq (K := K) U) p q where
  N₁ := (N1 : Subgroup (Aff1 K × Aff1 (ZMod r))).subgroupOf (Hq U)
  N₂ := (N2 : Subgroup (Aff1 K × Aff1 (ZMod r))).subgroupOf (Hq U)
  n₁ := Subgroup.normal_subgroupOf
  n₂ := Subgroup.normal_subgroupOf
  le := fun x hx => by
    rw [Subgroup.mem_subgroupOf] at hx ⊢; exact N2_le_N1 hx
  bot := N2_pgroup p U
  layer := layer_cyclic U ω hω hco
  top := top_pgroup q U hU

/-- The permutation group on K ⊕ ℤ/r. -/
def G {r : ℕ} [Fact r.Prime] (U : Subgroup (ZMod r)ˣ) : Subgroup (Perm (K ⊕ ZMod r)) := (Hq (K := K) U).map (Φ K (ZMod r))

/-- **The Oliver chain on the permutation group** (image of the abstract one). -/
def chainG (p q r : ℕ) [Fact p.Prime] [Fact r.Prime] [Fintype K] [CharP K p]
    (U : Subgroup (ZMod r)ˣ) (hU : ∀ u ∈ U, u ^ q = 1)
    (ω : Kˣ) (hω : ∀ a : Kˣ, a ∈ Subgroup.zpowers ω) (hco : Nat.Coprime (orderOf ω) r) :
    Chain.OliverChain (G (K := K) U) p q :=
  (chainH p q r U hU ω hω hco).map ((Φ K (ZMod r)).subgroupMap (Hq U))
    ((Φ K (ZMod r)).subgroupMap_surjective (Hq U))

/-! ## The orbitals -/

section orbitals
variable {r : ℕ} [Fact r.Prime] [Fintype K] [DecidableEq K] (U : Subgroup (ZMod r)ˣ)

theorem map_mem_orbit (h : Aff1 K × Aff1 (ZMod r)) (hh : h ∈ Hq U) (e : Sym2 (K ⊕ ZMod r)) :
    Sym2.map (Φ K (ZMod r) h) e ∈ D2.orbit2 (G (K := K) U) e := by
  unfold D2.orbit2
  rw [Finset.mem_image]
  exact ⟨Φ K (ZMod r) h, by simp only [Finset.mem_filter, Finset.mem_univ, true_and]; exact ⟨h, hh, rfl⟩, rfl⟩

/-- **Pairs inside K: one orbital, of size C(|K|, 2)** (the affine group is 2-homogeneous). -/
theorem orbit_KK {x y : K} (hxy : x ≠ y) :
    (Fintype.card K).choose 2 ≤ (D2.orbit2 (G (K := K) U) s(Sum.inl x, Sum.inl y)).card := by
  set T : Finset (Sym2 K) := (Finset.univ.offDiag).image Sym2.mk.uncurry
  have hT : T.card = (Fintype.card K).choose 2 := Sym2.card_image_offDiag _
  rw [← hT, ← Finset.card_image_of_injective T (Sym2.map.injective (Sum.inl_injective (β := ZMod r)))]
  apply Finset.card_le_card
  intro f hf
  simp only [T, Finset.mem_image, Finset.mem_offDiag, Finset.mem_univ, true_and, Prod.exists,
    Function.uncurry_apply_pair] at hf
  obtain ⟨g, ⟨x', y', hne, rfl⟩, rfl⟩ := hf
  have hd : y - x ≠ 0 := sub_ne_zero.mpr (Ne.symm hxy)
  set a : K := (y' - x') / (y - x)
  have ha : a ≠ 0 := div_ne_zero (sub_ne_zero.mpr (Ne.symm hne)) hd
  let h : Aff1 K × Aff1 (ZMod r) := (⟨Units.mk0 a ha, x' - a * x⟩, 1)
  have hh : h ∈ Hq U := by show (1 : (ZMod r)ˣ) ∈ U; exact U.one_mem
  have := map_mem_orbit U h hh s(Sum.inl x, Sum.inl y)
  convert this using 1
  simp only [Sym2.map_mk, Φ_inl, h, Units.val_mk0]
  congr 2
  · ring
  · simp only [a]; field_simp; ring

/-- **Mixed pairs: one orbital, of size |K|·r.** -/
theorem orbit_KR (x : K) (z : ZMod r) :
    Fintype.card K * r ≤ (D2.orbit2 (G (K := K) U) s(Sum.inl x, Sum.inr z)).card := by
  set T : Finset (Sym2 (K ⊕ ZMod r)) :=
    (Finset.univ : Finset (K × ZMod r)).image (fun w => s(Sum.inl w.1, Sum.inr w.2))
  have hT : T.card = Fintype.card K * r := by
    rw [Finset.card_image_of_injective]
    · simp [ZMod.card]
    · intro w w' h
      simp only [Sym2.eq_iff, Sum.inl.injEq, Sum.inr.injEq, reduceCtorEq, and_false,
        or_false] at h
      exact Prod.ext h.1 h.2
  rw [← hT]
  apply Finset.card_le_card
  intro f hf
  simp only [T, Finset.mem_image, Finset.mem_univ, true_and] at hf
  obtain ⟨⟨x', z'⟩, rfl⟩ := hf
  let h : Aff1 K × Aff1 (ZMod r) := (⟨1, x' - x⟩, ⟨1, z' - z⟩)
  have hh : h ∈ Hq U := by show (1 : (ZMod r)ˣ) ∈ U; exact U.one_mem
  have := map_mem_orbit U h hh s(Sum.inl x, Sum.inr z)
  convert this using 1
  simp [Sym2.map_mk, Φ_inl, Φ_inr, h]

/-- **Pairs inside ℤ/r: each orbital has size at least |U|·r**, provided −1 ∉ U (U of odd
order).  The map (u, v) ↦ {u·z₁ + v, u·z₂ + v} is injective: a swap would need u = −u′. -/
theorem orbit_RR [Fintype U] {z1 z2 : ZMod r} (hz : z1 ≠ z2) (hneg : (-1 : (ZMod r)ˣ) ∉ U) :
    Fintype.card U * r ≤ (D2.orbit2 (G (K := K) U) s(Sum.inr z1, Sum.inr z2)).card := by
  set T : Finset (Sym2 (K ⊕ ZMod r)) :=
    (Finset.univ : Finset (U × ZMod r)).image
      (fun w => s(Sum.inr (((w.1 : (ZMod r)ˣ) : ZMod r) * z1 + w.2),
                  Sum.inr (((w.1 : (ZMod r)ˣ) : ZMod r) * z2 + w.2)))
  have hd : z1 - z2 ≠ 0 := sub_ne_zero.mpr hz
  have hT : T.card = Fintype.card U * r := by
    rw [Finset.card_image_of_injective]
    · simp [ZMod.card]
    · rintro ⟨⟨u, hu⟩, v⟩ ⟨⟨u', hu'⟩, v'⟩ h
      simp only [Sym2.eq_iff, Sum.inr.injEq] at h
      rcases h with ⟨h1, h2⟩ | ⟨h1, h2⟩
      · have huu : (u : ZMod r) = u' := by
          have : ((u : ZMod r) - u') * (z1 - z2) = 0 := by linear_combination h1 - h2
          rcases mul_eq_zero.mp this with h | h
          · exact sub_eq_zero.mp h
          · exact absurd h hd
        have hu2 : u = u' := Units.ext huu
        subst hu2
        have : v = v' := by linear_combination h1
        subst this; rfl
      · exfalso
        have huu : (u : ZMod r) = -(u' : ZMod r) := by
          have : ((u : ZMod r) + u') * (z1 - z2) = 0 := by linear_combination h1 - h2
          rcases mul_eq_zero.mp this with h | h
          · linear_combination h
          · exact absurd h hd
        apply hneg
        have : (-1 : (ZMod r)ˣ) = u * u'⁻¹ := by
          apply Units.ext
          rw [Units.val_mul, huu, neg_mul, Units.mul_inv, Units.val_neg, Units.val_one]
        rw [this]; exact U.mul_mem hu (U.inv_mem hu')
  rw [← hT]
  apply Finset.card_le_card
  intro f hf
  simp only [T, Finset.mem_image, Finset.mem_univ, true_and] at hf
  obtain ⟨⟨⟨u, hu⟩, v⟩, rfl⟩ := hf
  let h : Aff1 K × Aff1 (ZMod r) := (1, ⟨u, v⟩)
  have hh : h ∈ Hq U := hu
  have := map_mem_orbit U h hh s(Sum.inr z1, Sum.inr z2)
  convert this using 1
  simp [Sym2.map_mk, Φ_inr, h]

/-- **Every orbital is at least min(C(|K|,2), |U|·r, |K|·r).** -/
theorem orbit_ge [Fintype U] (hneg : (-1 : (ZMod r)ˣ) ∉ U) (e : Sym2 (K ⊕ ZMod r)) (he : ¬ e.IsDiag) :
    min ((Fintype.card K).choose 2) (min (Fintype.card U * r) (Fintype.card K * r)) ≤
      (D2.orbit2 (G (K := K) U) e).card := by
  induction e using Sym2.ind with
  | h x y =>
    rw [Sym2.mk_isDiag_iff] at he
    rcases x with x | z <;> rcases y with y | w
    · exact le_trans (min_le_left _ _) (orbit_KK U (fun h => he (by rw [h])))
    · exact le_trans (le_trans (min_le_right _ _) (min_le_right _ _)) (orbit_KR U x w)
    · rw [Sym2.eq_swap]
      exact le_trans (le_trans (min_le_right _ _) (min_le_right _ _)) (orbit_KR U y z)
    · exact le_trans (le_trans (min_le_right _ _) (min_le_left _ _))
        (orbit_RR U (fun h => he (by rw [h])) hneg)

end orbitals

/-! ## Realisability for F = 1 -/

open ArkCore E6 E5Assembly in
/-- **Part E for a class with F = 1** (a single block 𝔽_c, c = |K| = p^b, beside one foreign
block ℤ/r with twist of odd prime order q, q ∣ r − 1, r ∤ c − 1).  The group G — the affine
group of K, alongside z ↦ u·z + v on ℤ/r with u in the order-q subgroup of (ℤ/r)ˣ — carries an
Oliver chain (p, q), and **every orbital on unordered pairs has size at least SAFE** of the
configuration `SigmaHalf.cfg p q 1 c r`, i.e. m\*(G) ≥ min(C(c,2), r·q, c·r). -/
theorem partE_F1 (p q r b : ℕ) [Fact p.Prime] [Fact r.Prime] [Fintype K] [DecidableEq K] [CharP K p]
    (hK : Fintype.card K = p ^ b) (hq : q.Prime) (hqo : q % 2 = 1) (hqr : q ∣ r - 1)
    (hco : ¬ r ∣ p ^ b - 1) :
    ∃ U : Subgroup (ZMod r)ˣ, Nonempty (Chain.OliverChain (G (K := K) U) p q) ∧
      ∀ e : Sym2 (K ⊕ ZMod r), ¬ e.IsDiag →
        (SigmaHalf.cfg p q 1 (p ^ b) r).safe ≤ (D2.orbit2 (G (K := K) U) e).card := by
  have : Fact q.Prime := ⟨hq⟩
  have hr2 : 2 ≤ r := (Fact.out : r.Prime).two_le
  -- the order-q subgroup of (ℤ/r)ˣ
  have hcard : q ∣ Fintype.card (ZMod r)ˣ := by rw [ZMod.card_units]; exact hqr
  obtain ⟨g, hg⟩ := exists_prime_orderOf_dvd_card q hcard
  set U := Subgroup.zpowers g with hUdef
  have hU : ∀ u ∈ U, u ^ q = 1 := by
    intro u hu
    obtain ⟨k, rfl⟩ := Subgroup.mem_zpowers_iff.mp hu
    rw [← zpow_natCast, ← zpow_mul, mul_comm, zpow_mul, zpow_natCast, ← hg, pow_orderOf_eq_one, one_zpow]
  have hq3 : 3 ≤ q := by
    rcases hq.eq_two_or_odd with h | h
    · omega
    · have := hq.two_le; omega
  have hneg : (-1 : (ZMod r)ˣ) ∉ U := by
    intro h
    have h1 := hU _ h
    have hodd : Odd q := Nat.odd_iff.mpr hqo
    rw [hodd.neg_one_pow] at h1
    have : ((-1 : (ZMod r)ˣ) : ZMod r) = 1 := by rw [h1]; rfl
    simp only [Units.val_neg, Units.val_one] at this
    have h2 : ((2 : ℕ) : ZMod r) = 0 := by push_cast; linear_combination -this
    rw [ZMod.natCast_eq_zero_iff] at h2
    have := Nat.le_of_dvd (by norm_num) h2
    have : r = 2 := by omega
    subst this
    have := Nat.le_of_dvd (by norm_num) hqr
    omega
  -- the generator of Kˣ
  obtain ⟨ω, hω⟩ := IsCyclic.exists_generator (α := Kˣ)
  have hord : orderOf ω = p ^ b - 1 := by
    rw [orderOf_eq_card_of_forall_mem_zpowers hω, Nat.card_eq_fintype_card, Fintype.card_units, hK]
  have hcop : Nat.Coprime (orderOf ω) r := by
    rw [hord]
    exact (Nat.Coprime.symm ((Nat.Prime.coprime_iff_not_dvd Fact.out).mpr hco))
  refine ⟨U, ⟨chainG p q r U hU ω hω hcop⟩, fun e he => ?_⟩
  -- SAFE of the configuration is at most each of the three orbital sizes
  have hUc : Fintype.card U = q := by rw [Fintype.card_zpowers, hg]
  have hmin := orbit_ge (K := K) U hneg e he
  rw [hUc, hK] at hmin
  have hd : 2 ≤ (r - 1) / q := by
    obtain ⟨m, hm⟩ := hqr
    have hm2 : 2 ≤ m := by
      rcases Nat.lt_or_ge m 2 with h | h
      · interval_cases m
        · omega
        · -- r - 1 = q odd, but r is an odd prime ≥ 3 so r - 1 is even
          have hr : r % 2 = 1 := by
            rcases (Fact.out : r.Prime).eq_two_or_odd with h2 | h2
            · subst h2; omega
            · exact h2
          omega
      · exact h
    rw [hm, Nat.mul_div_cancel_left _ (by omega)]; exact hm2
  have horb : orb r q false = r * q := by
    apply SigmaHalf.orb_dq hqo hd
    have := Nat.div_mul_cancel hqr
    omega
  have h1 : (SigmaHalf.cfg p q 1 (p ^ b) r).safe ≤ 1 * pairs (p ^ b) :=
    minL_le (by simp [SigmaHalf.cfg, CPart.safeTerms, Part.terms])
  have h2 : (SigmaHalf.cfg p q 1 (p ^ b) r).safe ≤ orb r q false :=
    minL_le (by simp [SigmaHalf.cfg, CPart.safeTerms, Part.terms])
  have h3 : (SigmaHalf.cfg p q 1 (p ^ b) r).safe ≤ 1 * p ^ b * r :=
    minL_le (by simp [SigmaHalf.cfg, CPart.safeTerms, Part.terms, Config.sizes, CPart.sizeC, crossN])
  rw [horb] at h2
  rw [← Ark.pairs_eq_choose] at hmin
  simp only [one_mul] at h1 h3
  have : min (pairs (p ^ b)) (min (q * r) (p ^ b * r)) ≥ (SigmaHalf.cfg p q 1 (p ^ b) r).safe := by
    simp only [ge_iff_le, le_min_iff]; refine ⟨h1, ?_, h3⟩; rw [mul_comm]; exact h2
  omega

/-- **Part E for F = 1, packaged**: for every prime power c = p^b (b ≥ 1) and every foreign
prime r with an odd prime q ∣ r − 1 and r ∤ c − 1, there is a permutation group on c + r points
with an Oliver chain (p, q) all of whose orbitals on unordered pairs have size at least the
SAFE (= REFINED) score of the configuration. -/
theorem partE_F1_exists (p q r b : ℕ) [Fact p.Prime] [Fact r.Prime] (hb : b ≠ 0) (hq : q.Prime)
    (hqo : q % 2 = 1) (hqr : q ∣ r - 1) (hco : ¬ r ∣ p ^ b - 1) :
    ∃ (X : Type) (_ : Fintype X) (_ : DecidableEq X) (G : Subgroup (Perm X)),
      Fintype.card X = p ^ b + r ∧ Nonempty (Chain.OliverChain G p q) ∧
      ∀ e : Sym2 X, ¬ e.IsDiag → (SigmaHalf.cfg p q 1 (p ^ b) r).safe ≤ (D2.orbit2 G e).card := by
  classical
  let K := GaloisField p b
  let _ : Fintype K := Fintype.ofFinite K
  have hK : Fintype.card K = p ^ b := by
    rw [← Nat.card_eq_fintype_card]; exact GaloisField.card p b hb
  obtain ⟨U, hch, horb⟩ := partE_F1 (K := K) p q r b hK hq hqo hqr hco
  refine ⟨K ⊕ ZMod r, inferInstance, inferInstance, G (K := K) U, ?_, hch, ?_⟩
  · rw [Fintype.card_sum, hK, ZMod.card]
  · intro e he
    convert horb e he using 2

/-! ## The F = 1 classes of Σ₀ without the Part E hypothesis -/

/-- n points carry an Oliver group (chain primes p, q) all of whose pair-orbitals have size ≥ m;
so μ\*(n) ≥ m for μ\* the largest such m. -/
def OliverRealises (n m : ℕ) : Prop :=
  ∃ (X : Type) (_ : Fintype X) (_ : DecidableEq X) (G : Subgroup (Perm X)) (p q : ℕ),
    p.Prime ∧ q.Prime ∧ Fintype.card X = n ∧ Nonempty (Chain.OliverChain G p q) ∧
    ∀ e : Sym2 X, ¬ e.IsDiag → m ≤ (D2.orbit2 G e).card

open SigmaHalf Sigma in
/-- **The Σ₀ floor at the F = 1 classes (n ≡ 0, 2, 4, 6, 8, 10 mod 12), with Part E proved.**
Under Σ₀'s witness hypothesis with either quantifier, L-eventually every such n is realised by an
Oliver group with every pair-orbital ≥ m, where 2m ≥ ((1 − ε)·δ₀(n mod 12) − κ/n)·n(n − 1). -/
theorem sigma0_F1_realised {ε : ℝ} (hε1 : ε < 1) {L : Filter ℕ} (hL : L ≤ Filter.atTop)
    (H : BCG.Hyp (W0 ε) L) :
    ∀ᶠ n in L, F0 (cls n) = 1 → ∃ m : ℕ, OliverRealises n m ∧
      ((1 - ε) * capCol (cls n) - (spec0 ε (cls n)).kap / n) * (n * (n - 1)) ≤ 2 * (m : ℝ) := by
  filter_upwards [H, hL (spec0_eventually hε1)] with n hW hl hF1
  obtain ⟨hx, hy⟩ := hl (cls n)
  have hg := specEps_good (F0 (cls n)) (d0 (cls n)) (ε := ε) (F0_pos _) (d0_ge _) hε1.le
  obtain ⟨p, b, q, r, hp, hb, hq, hqo, hr, hrp, hrd, hn, hlo, hhi, hco⟩ := hW
  obtain ⟨-, hs⟩ := cfg_half (spec0 ε (cls n)) hg hp hb hq hqo hr hrp hrd hn hlo hhi hx hy
  have hF : (spec0 ε (cls n)).F = 1 := hF1
  rw [hF] at hs hn
  have : Fact p.Prime := ⟨hp⟩
  have : Fact r.Prime := ⟨hr⟩
  have hqr : q ∣ r - 1 := ⟨(spec0 ε (cls n)).d, by rw [hrd]; simp [Nat.mul_comm]⟩
  obtain ⟨X, i1, i2, G, hX, hch, horb⟩ := partE_F1_exists p q r b (by omega) hq hqo hqr hco
  refine ⟨_, ⟨X, i1, i2, G, p, q, hp, hq, by rw [hX, hn, one_mul], hch, horb⟩, ?_⟩
  rw [← spec0_tgt ε hε1.le]
  exact hs

end PartE1

/-
# `PartEG.lean` — Part E (realisability) for one class beside any number of foreign blocks

`enumeration-proof.md` Part E's construction for one p-characteristic class of F ≥ 1 blocks of
𝔽_c at full twist, beside foreign blocks ℤ/r₁, …, ℤ/r_k of distinct primes, each with a twist
group U_j of q-power order (any q, including q = 2).  It generalises `PartE1` (F = 1, one block)
and `PartEF` (F ≥ 2, one block, odd prime twist).

* **The group** G = ⟨T, γ, μ(U)⟩ on (ℤ/F × K) ⊔ Σⱼ ℤ/rⱼ: T the translations of the F blocks,
  γ = the entangled rotation `zc` on the blocks and z ↦ z + 1 on every ℤ/rⱼ, μ_u = z ↦ uⱼ·z on
  each ℤ/rⱼ for u in a subgroup U of Πⱼ (ℤ/rⱼ)ˣ.
* **The Oliver chain** (`chain`): T (a p-group) ◁ ⟨T, γ⟩ (cyclic over T) ◁ G (a q-group over
  ⟨T, γ⟩, given every u ∈ U has q-power order).  The one arithmetic input is **coherence**:
  no rⱼ divides F·(c − 1), so that by the Chinese remainder theorem every translation vector
  ρ_v of the foreign blocks is a power of γ (`ρ_mem`).
* **The orbitals** (`orbit_*`): within a block, F·C(c,2); across two blocks, ≥ K0·c²; block–ℤ/rⱼ,
  F·c·rⱼ; ℤ/rⱼ–ℤ/rₗ, rⱼ·rₗ; inside ℤ/rⱼ, ≥ orb(rⱼ, |Uⱼ|) — exactly the SAFE terms.
-/
import PartEF
import Mathlib.Data.ZMod.QuotientRing

set_option linter.unusedSectionVars false

namespace PartEG
open Equiv Finset

/-! ## The entangled generator, for any F ≥ 1 -/

section zc
variable {F : ℕ} [NeZero F] {K : Type*} [Field K]

theorem val_succ (i : ZMod F) : (i + 1).val = (i.val + 1) % F := by
  rw [ZMod.val_add, ZMod.val_one_eq_one_mod, Nat.add_mod_mod]

theorem val_succ_eq_zero (i : ZMod F) : (i + 1).val = 0 ↔ i.val + 1 = F := by
  have hi := ZMod.val_lt i
  rw [val_succ]
  constructor
  · intro h
    rcases Nat.lt_or_ge (i.val + 1) F with h2 | h2
    · rw [Nat.mod_eq_of_lt h2] at h; omega
    · omega
  · intro h; rw [h, Nat.mod_self]

/-- The entangled generator on F blocks of K: rotate the blocks, multiplying by ω on the wrap. -/
def zc (ω : Kˣ) : Perm (ZMod F × K) where
  toFun p := (p.1 + 1, if p.1.val + 1 = F then (ω : K) * p.2 else p.2)
  invFun p := (p.1 - 1, if p.1.val = 0 then ((ω⁻¹ : Kˣ) : K) * p.2 else p.2)
  left_inv := by
    rintro ⟨i, x⟩
    have h0 := val_succ_eq_zero i
    simp only [add_sub_cancel_right, Prod.mk.injEq, true_and]
    by_cases h : i.val + 1 = F
    · simp [h, h0.mpr h]
    · have : ¬ (i + 1).val = 0 := fun h' => h (h0.mp h')
      simp [h, this]
  right_inv := by
    rintro ⟨i, x⟩
    have h0 := val_succ_eq_zero (i - 1)
    rw [sub_add_cancel] at h0
    simp only [sub_add_cancel, Prod.mk.injEq, true_and]
    by_cases h : i.val = 0
    · simp [h, h0.mp h]
    · have : ¬ (i - 1).val + 1 = F := fun h' => h (h0.mpr h')
      simp [h, this]

theorem succ_div (a : ℕ) :
    (a + 1) / F = a / F + (if a % F + 1 = F then 1 else 0) := by
  have hF : 0 < F := Nat.pos_of_ne_zero (NeZero.ne F)
  have hm := Nat.mod_lt a hF
  by_cases h : a % F + 1 = F
  · simp only [h, ite_true]
    apply Nat.succ_div_of_dvd
    rw [Nat.dvd_iff_mod_eq_zero, Nat.add_mod]
    rcases Nat.lt_or_ge 1 F with h1 | h1
    · rw [Nat.mod_eq_of_lt h1, h, Nat.mod_self]
    · have : F = 1 := by omega
      subst this; simp [Nat.mod_one]
  · simp only [h, ite_false, add_zero]
    apply Nat.succ_div_of_not_dvd
    rw [Nat.dvd_iff_mod_eq_zero]
    have h1 : 1 < F := by
      by_contra h1
      have : F = 1 := by omega
      subst this; omega
    rw [Nat.add_mod, Nat.mod_eq_of_lt h1, Nat.mod_eq_of_lt (by omega)]; omega

/-- **The power formula**: zc^j (i, x) = (i + j, ω^((i.val + j)/F) · x). -/
theorem zc_pow (ω : Kˣ) (j : ℕ) (i : ZMod F) (x : K) :
    (zc ω ^ j) (i, x) = (i + j, ((ω ^ ((i.val + j) / F) : Kˣ) : K) * x) := by
  induction j with
  | zero =>
    have := ZMod.val_lt i
    simp [Nat.div_eq_of_lt this]
  | succ j ih =>
    rw [pow_succ', Perm.mul_apply, ih]
    simp only [zc, coe_fn_mk, Nat.cast_succ, Prod.mk.injEq]
    refine ⟨by ring, ?_⟩
    have hv : (i + (j : ZMod F)).val = (i.val + j) % F := by
      rw [ZMod.val_add, ZMod.val_natCast, Nat.add_mod_mod]
    rw [hv, ← Nat.add_assoc, succ_div]
    split <;> simp [pow_add, mul_comm, mul_left_comm]

theorem zc_pow_mul (ω : Kˣ) (m : ℕ) (i : ZMod F) (x : K) :
    (zc ω ^ (F * m)) (i, x) = (i, ((ω ^ m : Kˣ) : K) * x) := by
  rw [zc_pow]
  have hF : 0 < F := Nat.pos_of_ne_zero (NeZero.ne F)
  have hi := ZMod.val_lt i
  have : (i.val + F * m) / F = m := by
    rw [Nat.add_mul_div_left _ _ hF, Nat.div_eq_of_lt hi, zero_add]
  rw [this]; simp

theorem zc_pow_eq_one (ω : Kˣ) (m : ℕ) (hm : ω ^ m = 1) :
    zc (F := F) ω ^ (F * m) = 1 := by
  ext ⟨i, x⟩ <;> rw [zc_pow_mul] <;> simp [hm]

/-- The wrap multiplier of zc at block i. -/
def wrap (ω : Kˣ) (i : ZMod F) : K := if i.val + 1 = F then (ω : K) else 1

theorem zc_apply (ω : Kˣ) (i : ZMod F) (x : K) : zc ω (i, x) = (i + 1, wrap ω i * x) := by
  simp only [zc, coe_fn_mk, wrap]; split <;> simp

end zc

/-! ## The points and the generators -/

variable {F : ℕ} [NeZero F] {K : Type*} [Field K] {k : ℕ} {r : Fin k → ℕ} [∀ j, Fact (r j).Prime]

variable (F K) in
/-- The points: F blocks of K, and the foreign blocks ℤ/rⱼ. -/
abbrev Pt (r : Fin k → ℕ) := (ZMod F × K) ⊕ (Σ j, ZMod (r j))

/-- Translation by v on the foreign blocks. -/
def fadd (v : ∀ j, ZMod (r j)) : Perm (Σ j, ZMod (r j)) where
  toFun x := ⟨x.1, x.2 + v x.1⟩
  invFun x := ⟨x.1, x.2 - v x.1⟩
  left_inv x := by simp
  right_inv x := by simp

/-- Multiplication by uⱼ on the foreign block j. -/
def fmul (u : ∀ j, (ZMod (r j))ˣ) : Perm (Σ j, ZMod (r j)) where
  toFun x := ⟨x.1, (u x.1 : ZMod (r x.1)) * x.2⟩
  invFun x := ⟨x.1, ((u x.1)⁻¹ : (ZMod (r x.1))ˣ) * x.2⟩
  left_inv x := by
    rcases x with ⟨j, z⟩
    show (⟨j, _⟩ : Σ j, ZMod (r j)) = ⟨j, z⟩
    rw [← mul_assoc, ← Units.val_mul, inv_mul_cancel, Units.val_one, one_mul]
  right_inv x := by
    rcases x with ⟨j, z⟩
    show (⟨j, _⟩ : Σ j, ZMod (r j)) = ⟨j, z⟩
    rw [← mul_assoc, ← Units.val_mul, mul_inv_cancel, Units.val_one, one_mul]

/-- Translation by t on the blocks (identity on the foreign blocks). -/
def trE (t : ZMod F → K) : Perm (ZMod F × K) where
  toFun p := (p.1, p.2 + t p.1)
  invFun p := (p.1, p.2 - t p.1)
  left_inv p := by simp
  right_inv p := by simp

def trHom : Multiplicative (ZMod F → K) →* Perm (Pt F K r) where
  toFun t := Perm.sumCongr (trE (Multiplicative.toAdd t)) 1
  map_one' := by ext (⟨i, x⟩ | z) <;> simp [trE]
  map_mul' s t := by
    ext (⟨i, x⟩ | z)
    · simp [trE]; ring
    · simp

/-- The translation subgroup: N₂. -/
def T : Subgroup (Perm (Pt F K r)) := (trHom (F := F) (K := K) (r := r)).range

/-- The cyclic-layer generator: the entangled rotation on the blocks, z ↦ z + 1 on each ℤ/rⱼ. -/
def γ (ω : Kˣ) : Perm (Pt F K r) := Perm.sumCongr (zc ω) (fadd fun _ => 1)

/-- Translation by v on the foreign blocks only. -/
def ρ (v : ∀ j, ZMod (r j)) : Perm (Pt F K r) := Perm.sumCongr 1 (fadd v)

/-- The top: z ↦ uⱼ·z on each ℤ/rⱼ. -/
def μ (u : ∀ j, (ZMod (r j))ˣ) : Perm (Pt F K r) := Perm.sumCongr 1 (fmul u)

@[simp] theorem trHom_inl (t : Multiplicative (ZMod F → K)) (i : ZMod F) (x : K) :
    trHom (r := r) t (Sum.inl (i, x)) = Sum.inl (i, x + Multiplicative.toAdd t i) := rfl
@[simp] theorem trHom_inr (t : Multiplicative (ZMod F → K)) (z : Σ j, ZMod (r j)) :
    trHom (F := F) (K := K) t (Sum.inr z) = Sum.inr z := rfl
@[simp] theorem ρ_inl (v : ∀ j, ZMod (r j)) (p : ZMod F × K) :
    ρ (F := F) (K := K) v (Sum.inl p) = Sum.inl p := rfl
@[simp] theorem ρ_inr (v : ∀ j, ZMod (r j)) (j : Fin k) (z : ZMod (r j)) :
    ρ (F := F) (K := K) v (Sum.inr ⟨j, z⟩) = Sum.inr ⟨j, z + v j⟩ := rfl
@[simp] theorem μ_inl (u : ∀ j, (ZMod (r j))ˣ) (p : ZMod F × K) :
    μ (F := F) (K := K) u (Sum.inl p) = Sum.inl p := rfl
@[simp] theorem μ_inr (u : ∀ j, (ZMod (r j))ˣ) (j : Fin k) (z : ZMod (r j)) :
    μ (F := F) (K := K) u (Sum.inr ⟨j, z⟩) = Sum.inr ⟨j, (u j : ZMod (r j)) * z⟩ := rfl
@[simp] theorem γ_inl (ω : Kˣ) (p : ZMod F × K) :
    γ (r := r) ω (Sum.inl p) = Sum.inl (zc ω p) := rfl
@[simp] theorem γ_inr (ω : Kˣ) (j : Fin k) (z : ZMod (r j)) :
    γ (F := F) (K := K) ω (Sum.inr ⟨j, z⟩) = Sum.inr ⟨j, z + 1⟩ := rfl

theorem γ_pow_inl (ω : Kˣ) (n : ℕ) (p : ZMod F × K) :
    (γ (r := r) ω ^ n) (Sum.inl p) = Sum.inl ((zc ω ^ n) p) := by
  induction n generalizing p with
  | zero => rfl
  | succ n ih => rw [pow_succ, Perm.mul_apply, γ_inl, ih, pow_succ, Perm.mul_apply]

theorem γ_pow_inr (ω : Kˣ) (n : ℕ) (j : Fin k) (z : ZMod (r j)) :
    (γ (F := F) (K := K) ω ^ n) (Sum.inr ⟨j, z⟩) = Sum.inr ⟨j, z + n⟩ := by
  induction n generalizing z with
  | zero => simp
  | succ n ih => rw [pow_succ, Perm.mul_apply, γ_inr, ih]; push_cast; ring_nf

/-- **γ normalises the translations**. -/
theorem γ_conj_tr (ω : Kˣ) (t : Multiplicative (ZMod F → K)) :
    γ (r := r) ω * trHom t * (γ ω)⁻¹ =
      trHom (Multiplicative.ofAdd fun j => wrap ω (j - 1) * Multiplicative.toAdd t (j - 1)) := by
  rw [mul_inv_eq_iff_eq_mul]
  ext (⟨i, x⟩ | ⟨j, z⟩)
  · simp only [Perm.mul_apply, trHom_inl, γ_inl, zc_apply, toAdd_ofAdd, add_sub_cancel_right]
    simp only [Sum.inl.injEq, Prod.mk.injEq, true_and]; ring
  · simp [Perm.mul_apply]

theorem μ_conj_tr (u : ∀ j, (ZMod (r j))ˣ) (t : Multiplicative (ZMod F → K)) :
    μ u * trHom t * (μ u)⁻¹ = trHom t := by
  rw [mul_inv_eq_iff_eq_mul]
  ext (⟨i, x⟩ | ⟨j, z⟩) <;> simp [Perm.mul_apply]

theorem μ_conj_γ (ω : Kˣ) (u : ∀ j, (ZMod (r j))ˣ) :
    μ u * γ (F := F) (K := K) ω * (μ u)⁻¹ = γ ω * ρ (fun j => (u j : ZMod (r j)) - 1) := by
  rw [mul_inv_eq_iff_eq_mul]
  ext (⟨i, x⟩ | ⟨j, z⟩)
  · simp [Perm.mul_apply]
  · simp [Perm.mul_apply]; ring

theorem μ_mul (u v : ∀ j, (ZMod (r j))ˣ) : μ (F := F) (K := K) (u * v) = μ u * μ v := by
  ext (⟨i, x⟩ | ⟨j, z⟩) <;> simp [Perm.mul_apply, mul_assoc]
theorem μ_one : μ (F := F) (K := K) (1 : ∀ j, (ZMod (r j))ˣ) = 1 := by
  ext (⟨i, x⟩ | ⟨j, z⟩) <;> simp
theorem μ_inv (u : ∀ j, (ZMod (r j))ˣ) : μ (F := F) (K := K) u⁻¹ = (μ u)⁻¹ := by
  rw [eq_inv_iff_mul_eq_one, ← μ_mul, inv_mul_cancel, μ_one]
theorem μ_pow (u : ∀ j, (ZMod (r j))ˣ) (n : ℕ) : μ (F := F) (K := K) (u ^ n) = μ u ^ n := by
  induction n with
  | zero => simp [μ_one]
  | succ n ih => rw [pow_succ, μ_mul, ih, pow_succ]

theorem ρ_add (v w : ∀ j, ZMod (r j)) : ρ (F := F) (K := K) (v + w) = ρ v * ρ w := by
  ext (⟨i, x⟩ | ⟨j, z⟩)
  · simp [Perm.mul_apply]
  · simp [Perm.mul_apply]; ring

/-! ## The subgroups -/

/-- N₁ = ⟨T, γ⟩. -/
def N1 (ω : Kˣ) : Subgroup (Perm (Pt F K r)) :=
  Subgroup.closure (((T (F := F) (K := K) (r := r) : Subgroup _) : Set (Perm (Pt F K r))) ∪ {γ ω})

/-- G = ⟨T, γ, μ(U)⟩. -/
def G (ω : Kˣ) (U : Subgroup (∀ j, (ZMod (r j))ˣ)) : Subgroup (Perm (Pt F K r)) :=
  Subgroup.closure (((T (F := F) (K := K) (r := r) : Subgroup _) : Set (Perm (Pt F K r))) ∪ {γ ω} ∪
    (μ '' (U : Set (∀ j, (ZMod (r j))ˣ))))

theorem T_le_N1 (ω : Kˣ) : (T (F := F) (K := K) (r := r)) ≤ N1 ω :=
  fun _ hx => Subgroup.subset_closure (Or.inl hx)
theorem γ_mem_N1 (ω : Kˣ) : γ ω ∈ N1 (F := F) (K := K) (r := r) ω :=
  Subgroup.subset_closure (Or.inr rfl)
theorem N1_le_G (ω : Kˣ) (U : Subgroup (∀ j, (ZMod (r j))ˣ)) : N1 (F := F) (K := K) ω ≤ G ω U :=
  Subgroup.closure_mono (fun _ hx => Or.inl hx)
theorem μ_mem_G (ω : Kˣ) {U : Subgroup (∀ j, (ZMod (r j))ˣ)} {u : ∀ j, (ZMod (r j))ˣ} (hu : u ∈ U) :
    μ u ∈ G (F := F) (K := K) ω U :=
  Subgroup.subset_closure (Or.inr ⟨u, hu, rfl⟩)

/-- Distinct primes are pairwise coprime. -/
theorem coprime_of_inj (hinj : Function.Injective r) : Pairwise (Function.onFun Nat.Coprime r) := by
  intro i j hij
  exact (Nat.coprime_primes (Fact.out) (Fact.out)).mpr (fun h => hij (hinj h))

/-- **ρ_v ∈ N₁ for every v**, when no rⱼ divides F·N (N with ω^N = 1) and the rⱼ are distinct:
by the Chinese remainder theorem ρ_v is a power of γ with exponent ≡ 0 mod F·N.  This is where
coherence rⱼ ∤ F·(c − 1) is used. -/
theorem ρ_mem (ω : Kˣ) {N : ℕ} (hN : ω ^ N = 1) (hinj : Function.Injective r)
    (hco : ∀ j, ((F * N : ℕ) : ZMod (r j)) ≠ 0) (v : ∀ j, ZMod (r j)) :
    ρ v ∈ N1 (F := F) (K := K) ω := by
  have : NeZero (∏ j, r j) := ⟨Finset.prod_ne_zero_iff.mpr fun j _ => (Fact.out : (r j).Prime).ne_zero⟩
  set e := ZMod.prodEquivPi r (coprime_of_inj hinj)
  set y := e.symm (fun j => v j * ((F * N : ℕ) : ZMod (r j))⁻¹)
  have hy : ∀ j, ((y.val : ℕ) : ZMod (r j)) = v j * ((F * N : ℕ) : ZMod (r j))⁻¹ := by
    intro j
    have h1 := congrFun (e.apply_symm_apply (fun j => v j * ((F * N : ℕ) : ZMod (r j))⁻¹)) j
    rw [← h1, ZMod.prodEquivPi_apply, ZMod.castHom_apply, ZMod.natCast_val]
  have : ρ v = γ (F := F) (K := K) (r := r) ω ^ (F * (N * y.val)) := by
    ext (⟨i, x⟩ | ⟨j, z⟩)
    · rw [γ_pow_inl, zc_pow_eq_one ω (N * y.val) (by rw [pow_mul, hN, one_pow])]; rfl
    · have key : ((F * (N * y.val) : ℕ) : ZMod (r j)) = v j := by
        have h1 := hco j
        have e1 : ((F * (N * y.val) : ℕ) : ZMod (r j)) = ((F * N : ℕ) : ZMod (r j)) * (y.val : ℕ) := by
          push_cast; ring
        rw [e1, hy j, mul_comm (v j), ← mul_assoc, mul_inv_cancel₀ h1, one_mul]
      rw [γ_pow_inr, ρ_inr, key]
  rw [this]
  exact Subgroup.pow_mem _ (γ_mem_N1 ω) _

section coh
variable (ω : Kˣ) {N : ℕ} (hN : ω ^ N = 1) (hinj : Function.Injective r)
  (hco : ∀ j, ((F * N : ℕ) : ZMod (r j)) ≠ 0)
include hN hinj hco

/-- μ_u normalises N₁. -/
theorem μ_conj_N1 (u : ∀ j, (ZMod (r j))ˣ) {n : Perm (Pt F K r)} (hn : n ∈ N1 (F := F) (K := K) ω) :
    μ u * n * (μ u)⁻¹ ∈ N1 (F := F) (K := K) ω := by
  induction hn using Subgroup.closure_induction with
  | mem x hx =>
    rcases hx with hx | rfl
    · obtain ⟨t, rfl⟩ := hx
      rw [μ_conj_tr]; exact T_le_N1 ω ⟨t, rfl⟩
    · rw [μ_conj_γ]
      exact Subgroup.mul_mem _ (γ_mem_N1 ω) (ρ_mem ω hN hinj hco _)
  | one => simp
  | mul x y _ _ hx hy =>
    have : μ u * (x * y) * (μ u)⁻¹ = (μ u * x * (μ u)⁻¹) * (μ u * y * (μ u)⁻¹) := by group
    rw [this]; exact Subgroup.mul_mem _ hx hy
  | inv x _ hx =>
    have : μ u * x⁻¹ * (μ u)⁻¹ = (μ u * x * (μ u)⁻¹)⁻¹ := by group
    rw [this]; exact Subgroup.inv_mem _ hx

end coh

variable [Fintype K] [DecidableEq K]

theorem T_le_G (ω : Kˣ) (U : Subgroup (∀ j, (ZMod (r j))ˣ)) : (T (F := F) (K := K) (r := r)) ≤ G ω U :=
  le_trans (T_le_N1 ω) (N1_le_G ω U)

instance T_normal (ω : Kˣ) (U : Subgroup (∀ j, (ZMod (r j))ˣ)) :
    ((T (F := F) (K := K) (r := r)).subgroupOf (G ω U)).Normal := by
  rw [Subgroup.normal_subgroupOf_iff_le_normalizer (T_le_G ω U)]
  apply Subgroup.closure_le _ |>.mpr
  intro g hg
  apply Subgroup.mem_normalizer_fintype
  intro n hn
  obtain ⟨t, rfl⟩ := hn
  rcases hg with (hg | rfl) | ⟨u, -, rfl⟩
  · exact Subgroup.mul_mem _ (Subgroup.mul_mem _ hg ⟨t, rfl⟩) (Subgroup.inv_mem _ hg)
  · rw [γ_conj_tr]; exact ⟨_, rfl⟩
  · rw [μ_conj_tr]; exact ⟨_, rfl⟩

section chain
variable (ω : Kˣ) (U : Subgroup (∀ j, (ZMod (r j))ˣ))

theorem N1_normal {N : ℕ} (hN : ω ^ N = 1) (hinj : Function.Injective r)
    (hco : ∀ j, ((F * N : ℕ) : ZMod (r j)) ≠ 0) :
    ((N1 (F := F) (K := K) (r := r) ω).subgroupOf (G ω U)).Normal := by
  rw [Subgroup.normal_subgroupOf_iff_le_normalizer (N1_le_G ω U)]
  apply Subgroup.closure_le _ |>.mpr
  intro g hg
  apply Subgroup.mem_normalizer_fintype
  intro n hn
  rcases hg with hg | ⟨u, -, rfl⟩
  · have hgN : g ∈ N1 (F := F) (K := K) ω := Subgroup.subset_closure hg
    exact Subgroup.mul_mem _ (Subgroup.mul_mem _ hgN hn) (Subgroup.inv_mem _ hgN)
  · exact μ_conj_N1 ω hN hinj hco u hn

theorem T_le_N1' : (T (F := F) (K := K) (r := r)).subgroupOf (G ω U) ≤
    (N1 (F := F) (K := K) ω).subgroupOf (G ω U) :=
  fun _ hx => by rw [Subgroup.mem_subgroupOf] at hx ⊢; exact T_le_N1 ω hx

abbrev N1G : Subgroup (G (F := F) (K := K) (r := r) ω U) := (N1 ω).subgroupOf (G ω U)
abbrev TG : Subgroup (G (F := F) (K := K) (r := r) ω U) := (T (F := F) (K := K) (r := r)).subgroupOf (G ω U)
abbrev LayerQ := (N1G (F := F) (K := K) (r := r) ω U) ⧸ (TG ω U).subgroupOf (N1G ω U)

/-- The class in the layer of an element of N₁. -/
def lcls (y : Perm (Pt F K r)) (hyN : y ∈ N1 (F := F) (K := K) ω) : LayerQ (F := F) (K := K) ω U :=
  QuotientGroup.mk ⟨⟨y, N1_le_G ω U hyN⟩, Subgroup.mem_subgroupOf.mpr hyN⟩

theorem lcls_mul (x y : Perm (Pt F K r)) (hx : x ∈ N1 (F := F) (K := K) ω) (hy : y ∈ N1 (F := F) (K := K) ω) :
    lcls ω U (x * y) (Subgroup.mul_mem _ hx hy) = lcls ω U x hx * lcls ω U y hy := rfl

theorem lcls_inv (x : Perm (Pt F K r)) (hx : x ∈ N1 (F := F) (K := K) ω) :
    lcls ω U x⁻¹ (Subgroup.inv_mem _ hx) = (lcls ω U x hx)⁻¹ := rfl

/-- **The cyclic layer**: N₁/N₂ is generated by the class of γ. -/
theorem layer_cyclic : IsCyclic (LayerQ (F := F) (K := K) (r := r) ω U) := by
  refine ⟨⟨lcls ω U (γ ω) (γ_mem_N1 ω), fun x => ?_⟩⟩
  rw [← Subgroup.mem_zpowers_iff]
  induction x using QuotientGroup.induction_on with
  | H y =>
    obtain ⟨⟨y, hyG⟩, hyN⟩ := y
    have hy : y ∈ N1 (F := F) (K := K) ω := Subgroup.mem_subgroupOf.mp hyN
    show lcls ω U y hy ∈ _
    clear hyN hyG
    induction hy using Subgroup.closure_induction with
    | mem x hx =>
      rcases hx with hx | rfl
      · have : lcls ω U x (Subgroup.subset_closure (Or.inl hx)) = 1 := by
          unfold lcls
          rw [QuotientGroup.eq_one_iff, Subgroup.mem_subgroupOf, Subgroup.mem_subgroupOf]
          exact hx
        rw [this]; exact Subgroup.one_mem _
      · exact Subgroup.mem_zpowers _
    | one => exact Subgroup.one_mem _
    | mul x y hx hy ihx ihy =>
      rw [lcls_mul ω U x y hx hy]; exact Subgroup.mul_mem _ ihx ihy
    | inv x hx ihx =>
      rw [lcls_inv ω U x hx]; exact Subgroup.inv_mem _ ihx

/-- Every element of G is μ_u times an element of N₁. -/
theorem decomp {N : ℕ} (hN : ω ^ N = 1) (hinj : Function.Injective r)
    (hco : ∀ j, ((F * N : ℕ) : ZMod (r j)) ≠ 0)
    {g : Perm (Pt F K r)} (hg : g ∈ G (F := F) (K := K) ω U) :
    ∃ u ∈ U, (μ u)⁻¹ * g ∈ N1 (F := F) (K := K) ω := by
  induction hg using Subgroup.closure_induction with
  | mem x hx =>
    rcases hx with hx | ⟨u, hu, rfl⟩
    · exact ⟨1, U.one_mem, by rw [μ_one, inv_one, one_mul]; exact Subgroup.subset_closure hx⟩
    · exact ⟨u, hu, by rw [inv_mul_cancel]; exact Subgroup.one_mem _⟩
  | one => exact ⟨1, U.one_mem, by rw [μ_one]; simp⟩
  | mul x y _ _ hx hy =>
    obtain ⟨u, hu, hxn⟩ := hx
    obtain ⟨u', hu', hyn⟩ := hy
    refine ⟨u * u', U.mul_mem hu hu', ?_⟩
    have e : (μ (u * u'))⁻¹ * (x * y) =
        (μ u'⁻¹ * ((μ u)⁻¹ * x) * (μ u'⁻¹)⁻¹) * ((μ u')⁻¹ * y) := by
      rw [μ_mul, μ_inv]; group
    rw [e]
    exact Subgroup.mul_mem _ (μ_conj_N1 ω hN hinj hco _ hxn) hyn
  | inv x _ hx =>
    obtain ⟨u, hu, hxn⟩ := hx
    refine ⟨u⁻¹, U.inv_mem hu, ?_⟩
    have e : (μ u⁻¹)⁻¹ * x⁻¹ = μ u * ((μ u)⁻¹ * x)⁻¹ * (μ u)⁻¹ := by
      rw [μ_inv]; group
    rw [e]
    exact μ_conj_N1 ω hN hinj hco u (Subgroup.inv_mem _ hxn)

/-- **The top is a q-group**: modulo N₁ every element is some μ_u, and u has q-power order. -/
theorem top_pgroup (q : ℕ) {N : ℕ} (hN : ω ^ N = 1) (hinj : Function.Injective r)
    (hco : ∀ j, ((F * N : ℕ) : ZMod (r j)) ≠ 0)
    (hU : ∀ u ∈ U, ∃ m : ℕ, u ^ q ^ m = 1) [(N1G (F := F) (K := K) (r := r) ω U).Normal] :
    IsPGroup q ((G (F := F) (K := K) (r := r) ω U) ⧸ N1G ω U) := by
  intro x
  induction x using QuotientGroup.induction_on with
  | H g =>
    obtain ⟨g, hg⟩ := g
    obtain ⟨u, hu, hn⟩ := decomp ω U hN hinj hco hg
    obtain ⟨m, hm⟩ := hU u hu
    refine ⟨m, ?_⟩
    have hμG : μ u ∈ G (F := F) (K := K) ω U := μ_mem_G ω hu
    have h1 : (QuotientGroup.mk (⟨g, hg⟩ : G (F := F) (K := K) ω U) :
        (G (F := F) (K := K) (r := r) ω U) ⧸ N1G ω U) = QuotientGroup.mk ⟨μ u, hμG⟩ := by
      rw [QuotientGroup.eq, Subgroup.mem_subgroupOf]
      have : ((⟨g, hg⟩ : G (F := F) (K := K) ω U)⁻¹ * ⟨μ u, hμG⟩ : G (F := F) (K := K) ω U).1 =
          ((μ u)⁻¹ * g)⁻¹ := by simp
      rw [this]; exact Subgroup.inv_mem _ hn
    rw [h1, ← QuotientGroup.mk_pow, QuotientGroup.eq_one_iff, Subgroup.mem_subgroupOf]
    have : ((⟨μ u, hμG⟩ : G (F := F) (K := K) ω U) ^ q ^ m).1 = 1 := by
      rw [Subgroup.coe_pow, ← μ_pow, hm, μ_one]
    rw [this]; exact Subgroup.one_mem _

theorem T_pgroup (p : ℕ) [Fact p.Prime] [CharP K p] :
    IsPGroup p (TG (F := F) (K := K) (r := r) ω U) := by
  intro x
  refine ⟨1, ?_⟩
  obtain ⟨⟨y, hyG⟩, hyT⟩ := x
  obtain ⟨t, ht⟩ := (Subgroup.mem_subgroupOf.mp hyT : y ∈ T (F := F) (K := K) (r := r))
  apply Subtype.ext; apply Subtype.ext
  simp only [pow_one, Subgroup.coe_pow, OneMemClass.coe_one]
  have ht' : trHom t = y := ht
  rw [← ht', ← map_pow]
  have : t ^ p = 1 := by
    apply Multiplicative.toAdd.injective
    funext i
    simp
  rw [this, map_one]

/-- **The Oliver chain** on G: N₂ = T ◁ N₁ = ⟨T, γ⟩ (cyclic over T) ◁ G (a q-group over N₁). -/
def chain (p q : ℕ) [Fact p.Prime] [CharP K p] {N : ℕ} (hN : ω ^ N = 1)
    (hinj : Function.Injective r) (hco : ∀ j, ((F * N : ℕ) : ZMod (r j)) ≠ 0)
    (hU : ∀ u ∈ U, ∃ m : ℕ, u ^ q ^ m = 1) :
    Chain.OliverChain (G (F := F) (K := K) (r := r) ω U) p q :=
  haveI := N1_normal ω U hN hinj hco
  { N₁ := N1G ω U
    N₂ := TG ω U
    n₁ := inferInstance
    n₂ := inferInstance
    le := T_le_N1' ω U
    bot := T_pgroup ω U p
    layer := layer_cyclic ω U
    top := top_pgroup ω U q hN hinj hco hU }

end chain

/-! ## Elements of G, and how they move points -/

section elements
variable (ω : Kˣ) (U : Subgroup (∀ j, (ZMod (r j))ˣ)) {N : ℕ} (hN : ω ^ N = 1)
  (hinj : Function.Injective r) (hco : ∀ j, ((F * N : ℕ) : ZMod (r j)) ≠ 0)

/-- The constant translation vector n on every foreign block. -/
def cst (n : ℕ) : ∀ j, ZMod (r j) := fun j => (n : ZMod (r j))

theorem trHom_mem (t : Multiplicative (ZMod F → K)) : trHom t ∈ G (F := F) (K := K) (r := r) ω U :=
  T_le_G ω U ⟨t, rfl⟩
theorem γpow_mem (n : ℕ) : γ ω ^ n ∈ G (F := F) (K := K) (r := r) ω U :=
  Subgroup.pow_mem _ (N1_le_G ω U (γ_mem_N1 ω)) n
include hN hinj hco in
theorem ρ_memG (v : ∀ j, ZMod (r j)) : ρ v ∈ G (F := F) (K := K) ω U :=
  N1_le_G ω U (ρ_mem ω hN hinj hco v)

include hN hinj hco in
/-- **Move a block onto any block by any affine map**, fixing the foreign blocks. -/
theorem block_map (hω : ∀ a : Kˣ, a ∈ Subgroup.zpowers ω) (i i' : ZMod F) (a : Kˣ) (b : K) :
    ∃ g ∈ G (F := F) (K := K) (r := r) ω U, (∀ v, g (Sum.inl (i, v)) = Sum.inl (i', a * v + b)) ∧
      ∀ z, g (Sum.inr z) = Sum.inr z := by
  set m0 := (i' - i).val
  set e := (i.val + m0) / F
  obtain ⟨m, hm⟩ : ∃ m : ℕ, ω ^ m = a * (ω ^ e)⁻¹ := by
    have := hω (a * (ω ^ e)⁻¹)
    rw [← mem_powers_iff_mem_zpowers] at this
    exact this
  let t : Multiplicative (ZMod F → K) := Multiplicative.ofAdd (fun _ => b)
  refine ⟨ρ (-cst m0) * trHom t * (γ ω ^ (F * m) * ρ (-cst (F * m))) * γ ω ^ m0,
    ?_, ?_, ?_⟩
  · refine Subgroup.mul_mem _ (Subgroup.mul_mem _ (Subgroup.mul_mem _ (ρ_memG ω U hN hinj hco _)
      (trHom_mem ω U t)) (Subgroup.mul_mem _ (γpow_mem ω U _) (ρ_memG ω U hN hinj hco _))) (γpow_mem ω U _)
  · intro v
    have hik : i + (m0 : ZMod F) = i' := by simp [m0]
    simp only [Perm.mul_apply, γ_pow_inl, zc_pow, ρ_inl, trHom_inl, hik]
    simp only [Sum.inl.injEq, Prod.mk.injEq]
    have hF : 0 < F := Nat.pos_of_ne_zero (NeZero.ne F)
    have h2 : (i'.val + F * m) / F = m := by
      rw [Nat.add_mul_div_left _ _ hF, Nat.div_eq_of_lt (ZMod.val_lt i'), zero_add]
    refine ⟨by push_cast; simp, ?_⟩
    rw [h2, hm]
    simp only [t, toAdd_ofAdd]
    rw [← mul_assoc, ← Units.val_mul, inv_mul_cancel_right]
  · rintro ⟨j, z⟩
    simp only [Perm.mul_apply, γ_pow_inr, ρ_inr, trHom_inr, cst, Pi.neg_apply]
    congr 2; push_cast; ring

end elements

/-! ## The orbitals -/

section orbitals
variable (ω : Kˣ) (U : Subgroup (∀ j, (ZMod (r j))ˣ)) {N : ℕ} (hN : ω ^ N = 1)
  (hinj : Function.Injective r) (hco : ∀ j, ((F * N : ℕ) : ZMod (r j)) ≠ 0)
  (hω : ∀ a : Kˣ, a ∈ Subgroup.zpowers ω)

theorem map_mem {g : Perm (Pt F K r)} (hg : g ∈ G (F := F) (K := K) ω U) (e : Sym2 (Pt F K r)) :
    Sym2.map g e ∈ D2.orbit2 (G (F := F) (K := K) ω U) e := by
  unfold D2.orbit2
  rw [Finset.mem_image]
  exact ⟨g, by simp only [Finset.mem_filter, Finset.mem_univ, true_and]; exact hg, rfl⟩

include hN hinj hco hω in
/-- **Within-block pairs: one orbital of size F·C(c,2).** -/
theorem orbit_KK (i : ZMod F) {x y : K} (hxy : x ≠ y) :
    F * (Fintype.card K).choose 2 ≤
      (D2.orbit2 (G (F := F) (K := K) ω U) s(Sum.inl (i, x), Sum.inl (i, y))).card := by
  set T0 : Finset (Sym2 K) := (Finset.univ.offDiag).image Sym2.mk.uncurry
  have hT : T0.card = (Fintype.card K).choose 2 := Sym2.card_image_offDiag _
  set S : Finset (Sym2 (Pt F K r)) := ((Finset.univ : Finset (ZMod F)) ×ˢ T0).image
    (fun w => Sym2.map (fun v => (Sum.inl (w.1, v) : Pt F K r)) w.2)
  have hS : S.card = F * (Fintype.card K).choose 2 := by
    rw [Finset.card_image_of_injective, Finset.card_product, hT, Finset.card_univ, ZMod.card]
    rintro ⟨i1, e1⟩ ⟨i2, e2⟩ h
    induction e1 using Sym2.ind with
    | h a1 b1 =>
    induction e2 using Sym2.ind with
    | h a2 b2 =>
    simp only [Sym2.map_mk, Sym2.eq_iff, Sum.inl.injEq, Prod.mk.injEq] at h
    rcases h with ⟨⟨h1, h2⟩, -, h3⟩ | ⟨⟨h1, h2⟩, -, h3⟩
    · subst h1 h2 h3; rfl
    · subst h1 h2 h3; simp [Sym2.eq_swap]
  rw [← hS]
  apply Finset.card_le_card
  intro f hf
  simp only [S, T0, Finset.mem_image, Finset.mem_product, Finset.mem_univ, true_and,
    Finset.mem_offDiag, Prod.exists] at hf
  obtain ⟨i', g, ⟨x', y', hne, rfl⟩, rfl⟩ := hf
  have hd : y - x ≠ 0 := sub_ne_zero.mpr (Ne.symm hxy)
  set a : K := (y' - x') / (y - x)
  have ha : a ≠ 0 := div_ne_zero (sub_ne_zero.mpr (Ne.symm hne)) hd
  obtain ⟨g, hg, hgl, -⟩ := block_map ω U hN hinj hco hω i i' (Units.mk0 a ha) (x' - a * x)
  have := map_mem ω U hg s(Sum.inl (i, x), Sum.inl (i, y))
  convert this using 1
  simp only [Function.uncurry_apply_pair, Sym2.map_mk, hgl, Units.val_mk0]
  have e1 : a * x + (x' - a * x) = x' := by ring
  have e2 : a * y + (x' - a * x) = y' := by
    have : a * (y - x) = y' - x' := by simp only [a]; field_simp
    linear_combination this
  rw [e1, e2]

include hN hinj hco hω in
/-- **Block–ℤ/rⱼ pairs: one orbital of size F·c·rⱼ.** -/
theorem orbit_KR (i : ZMod F) (x : K) (j : Fin k) (z : ZMod (r j)) :
    F * Fintype.card K * r j ≤
      (D2.orbit2 (G (F := F) (K := K) ω U) s(Sum.inl (i, x), Sum.inr ⟨j, z⟩)).card := by
  set S : Finset (Sym2 (Pt F K r)) :=
    (Finset.univ : Finset ((ZMod F × K) × ZMod (r j))).image
      (fun w => s(Sum.inl w.1, Sum.inr ⟨j, w.2⟩))
  have hS : S.card = F * Fintype.card K * r j := by
    rw [Finset.card_image_of_injective]
    · simp [ZMod.card, Fintype.card_prod]
    · intro w w' h
      simp only [Sym2.eq_iff, Sum.inl.injEq, Sum.inr.injEq, reduceCtorEq, and_false, or_false,
        Sigma.mk.injEq, heq_eq_eq, true_and] at h
      exact Prod.ext h.1 h.2
  rw [← hS]
  apply Finset.card_le_card
  intro f hf
  simp only [S, Finset.mem_image, Finset.mem_univ, true_and] at hf
  obtain ⟨⟨⟨i', x'⟩, z'⟩, rfl⟩ := hf
  obtain ⟨g, hg, hgl, hgr⟩ := block_map ω U hN hinj hco hω i i' 1 (x' - x)
  have hm := map_mem ω U (Subgroup.mul_mem _ (ρ_memG ω U hN hinj hco (Pi.single j (z' - z))) hg)
    s(Sum.inl (i, x), Sum.inr ⟨j, z⟩)
  convert hm using 1
  simp [Sym2.map_mk, Perm.mul_apply, hgl, hgr]

include hN hinj hco in
/-- **ℤ/rⱼ–ℤ/rₗ pairs (j ≠ l): one orbital of size rⱼ·rₗ.** -/
theorem orbit_RR' {j l : Fin k} (hjl : j ≠ l) (z : ZMod (r j)) (w : ZMod (r l)) :
    r j * r l ≤ (D2.orbit2 (G (F := F) (K := K) ω U) s(Sum.inr ⟨j, z⟩, Sum.inr ⟨l, w⟩)).card := by
  set S : Finset (Sym2 (Pt F K r)) :=
    (Finset.univ : Finset (ZMod (r j) × ZMod (r l))).image
      (fun w => s(Sum.inr ⟨j, w.1⟩, Sum.inr ⟨l, w.2⟩))
  have hS : S.card = r j * r l := by
    rw [Finset.card_image_of_injective]
    · simp [ZMod.card]
    · rintro ⟨a, b⟩ ⟨a', b'⟩ h
      simp only [Sym2.eq_iff, Sum.inr.injEq, Sigma.mk.injEq, heq_eq_eq, true_and] at h
      rcases h with ⟨h1, h2⟩ | ⟨⟨h1, -⟩, -⟩
      · rw [h1, h2]
      · exact absurd h1 hjl
  rw [← hS]
  apply Finset.card_le_card
  intro f hf
  simp only [S, Finset.mem_image, Finset.mem_univ, true_and] at hf
  obtain ⟨⟨a, b⟩, rfl⟩ := hf
  have hm := map_mem ω U (ρ_memG ω U hN hinj hco (Pi.single j (a - z) + Pi.single l (b - w)))
    s(Sum.inr ⟨j, z⟩, Sum.inr ⟨l, w⟩)
  convert hm using 1
  simp [Sym2.map_mk, hjl, hjl.symm]

include hN hinj hco in
/-- **Pairs across two blocks: orbitals of size ≥ K0·c²** (K0 = F for odd F, F/2 for even F). -/
theorem orbit_cross [Fact (1 < F)] {i i2 : ZMod F} (hij : i ≠ i2) (x y : K) :
    PartEF.K0 F * Fintype.card K * Fintype.card K ≤
      (D2.orbit2 (G (F := F) (K := K) ω U) s(Sum.inl (i, x), Sum.inl (i2, y))).card := by
  set S : Finset (Sym2 (Pt F K r)) :=
    (Finset.range (PartEF.K0 F) ×ˢ (Finset.univ : Finset (K × K))).image
      (fun w => s(Sum.inl (i + (w.1 : ZMod F), w.2.1), Sum.inl (i2 + (w.1 : ZMod F), w.2.2)))
  have hval : ∀ m : ℕ, m < PartEF.K0 F → ((m : ZMod F)).val = m := fun m hm => by
    rw [ZMod.val_natCast, Nat.mod_eq_of_lt (lt_of_lt_of_le hm PartEF.K0_le)]
  have hS : S.card = PartEF.K0 F * Fintype.card K * Fintype.card K := by
    rw [Finset.card_image_of_injOn, Finset.card_product, Finset.card_range, Finset.card_univ,
      Fintype.card_prod, mul_assoc]
    rintro ⟨m, a, b⟩ hw ⟨m', a', b'⟩ hw' h
    simp only [Finset.coe_product, Set.mem_prod, Finset.coe_range, Set.mem_Iio] at hw hw'
    simp only [Sym2.eq_iff, Sum.inl.injEq, Prod.mk.injEq] at h
    rcases h with ⟨⟨h1, h2⟩, h3, h4⟩ | ⟨⟨h1, h2⟩, h3, h4⟩
    · have : (m : ZMod F) = m' := by linear_combination h1
      have hmm : m = m' := by rw [← hval m hw.1, ← hval m' hw'.1, this]
      subst hmm h2 h4; rfl
    · exfalso
      have h5 : (2 : ZMod F) * ((m' : ZMod F) - m) = 0 := by linear_combination -h1 - h3
      have hmm := PartEF.no_swap hw.1 hw'.1 h5
      subst hmm
      exact hij (by linear_combination h1)
  rw [← hS]
  apply Finset.card_le_card
  intro f hf
  simp only [S, Finset.mem_image, Finset.mem_product, Finset.mem_range, Finset.mem_univ,
    and_true] at hf
  obtain ⟨⟨m, x', y'⟩, -, rfl⟩ := hf
  have hne : i + (m : ZMod F) ≠ i2 + m := fun h => hij (by linear_combination h)
  set e1 := (i.val + m) / F
  set e2 := (i2.val + m) / F
  let t : Multiplicative (ZMod F → K) := Multiplicative.ofAdd (fun l =>
    if l = i + m then x' - ((ω ^ e1 : Kˣ) : K) * x else y' - ((ω ^ e2 : Kˣ) : K) * y)
  have hm := map_mem ω U (Subgroup.mul_mem _ (trHom_mem ω U t) (γpow_mem ω U m))
    s(Sum.inl (i, x), Sum.inl (i2, y))
  convert hm using 1
  have q1 : ((ω ^ e1 : Kˣ) : K) * x + (x' - ((ω ^ e1 : Kˣ) : K) * x) = x' := by ring
  have q2 : ((ω ^ e2 : Kˣ) : K) * y + (y' - ((ω ^ e2 : Kˣ) : K) * y) = y' := by ring
  have hne' : (i2 + (m : ZMod F) = i + m) = False := eq_false (Ne.symm hne)
  simp only [Sym2.map_mk, Perm.mul_apply, γ_pow_inl, zc_pow, trHom_inl, t, toAdd_ofAdd,
    hne', ↓reduceIte]
  rw [q1, q2]

/-- Two affine images of a pair {z₁, z₂} in ℤ/r coincide only for the same map, or for the
"swapped" one u' = −u. -/
theorem pair_eq {p : ℕ} [Fact p.Prime] {z1 z2 : ZMod p} (hz : z1 ≠ z2) {u u' v v' : ZMod p}
    (h : s(u * z1 + v, u * z2 + v) = s(u' * z1 + v', u' * z2 + v')) :
    (u = u' ∧ v = v') ∨ (u' = -u ∧ v' = v + u * (z1 + z2)) := by
  have hd : z1 - z2 ≠ 0 := sub_ne_zero.mpr hz
  rw [Sym2.eq_iff] at h
  rcases h with ⟨h1, h2⟩ | ⟨h1, h2⟩
  · have : (u - u') * (z1 - z2) = 0 := by linear_combination h1 - h2
    have hu : u = u' := sub_eq_zero.mp ((mul_eq_zero.mp this).resolve_right hd)
    subst hu
    exact Or.inl ⟨rfl, by linear_combination h1⟩
  · have : (u + u') * (z1 - z2) = 0 := by linear_combination h1 - h2
    have hu : u' = -u := by linear_combination (mul_eq_zero.mp this).resolve_right hd
    subst hu
    exact Or.inr ⟨rfl, by linear_combination -h1⟩

section RR
variable (j : Fin k) (W : Subgroup (ZMod (r j))ˣ) (hW : ∀ w ∈ W, Pi.mulSingle j w ∈ U)
  {z1 z2 : ZMod (r j)} (hz : z1 ≠ z2)

/-- The affine images of a pair inside ℤ/rⱼ, under ρ_v·μ_u. -/
noncomputable def RRimg [Fintype W] : Finset (Sym2 (Pt F K r)) :=
  (Finset.univ : Finset (W × ZMod (r j))).image (fun w =>
    s(Sum.inr ⟨j, ((w.1 : (ZMod (r j))ˣ) : ZMod (r j)) * z1 + w.2⟩,
      Sum.inr ⟨j, ((w.1 : (ZMod (r j))ˣ) : ZMod (r j)) * z2 + w.2⟩))

include hN hinj hco hW in
theorem RRimg_sub [Fintype W] : RRimg (F := F) (K := K) j W (z1 := z1) (z2 := z2) ⊆
    D2.orbit2 (G (F := F) (K := K) ω U) s(Sum.inr ⟨j, z1⟩, Sum.inr ⟨j, z2⟩) := by
  classical
  intro f hf
  simp only [RRimg, Finset.mem_image, Finset.mem_univ, true_and] at hf
  obtain ⟨⟨⟨u, hu⟩, v⟩, rfl⟩ := hf
  have hm := map_mem ω U (Subgroup.mul_mem _ (ρ_memG ω U hN hinj hco (Pi.single j v))
    (μ_mem_G ω (hW u hu))) s(Sum.inr ⟨j, z1⟩, Sum.inr ⟨j, z2⟩)
  convert hm using 1
  simp [Sym2.map_mk, Perm.mul_apply]

include hz in
/-- With −1 ∉ W the images are distinct: |W|·rⱼ of them. -/
theorem RRimg_card_inj (hneg : (-1 : (ZMod (r j))ˣ) ∉ W) [Fintype W] :
    Fintype.card W * r j ≤ (RRimg (F := F) (K := K) j W (z1 := z1) (z2 := z2)).card := by
  have hinjf : Function.Injective (fun w : W × ZMod (r j) =>
      (s(Sum.inr ⟨j, ((w.1 : (ZMod (r j))ˣ) : ZMod (r j)) * z1 + w.2⟩,
        Sum.inr ⟨j, ((w.1 : (ZMod (r j))ˣ) : ZMod (r j)) * z2 + w.2⟩) : Sym2 (Pt F K r))) := by
    rintro ⟨⟨u, hu⟩, v⟩ ⟨⟨u', hu'⟩, v'⟩ h
    simp only [Sym2.eq_iff, Sum.inr.injEq, Sigma.mk.injEq, heq_eq_eq, true_and] at h
    have h' : s(((u : ZMod (r j))) * z1 + v, (u : ZMod (r j)) * z2 + v) =
        s((u' : ZMod (r j)) * z1 + v', (u' : ZMod (r j)) * z2 + v') := by
      rw [Sym2.eq_iff]; exact h
    rcases pair_eq hz h' with ⟨h1, h2⟩ | ⟨h1, -⟩
    · have : u = u' := Units.ext h1
      subst this
      rw [h2]
    · exfalso; apply hneg
      have : (-1 : (ZMod (r j))ˣ) = u' * u⁻¹ := by
        apply Units.ext
        rw [Units.val_mul, h1, neg_mul, Units.mul_inv, Units.val_neg, Units.val_one]
      rw [this]; exact W.mul_mem hu' (W.inv_mem hu)
  unfold RRimg
  rw [Finset.card_image_of_injective _ hinjf, Finset.card_univ, Fintype.card_prod, ZMod.card]

include hz in
/-- In general (rⱼ odd) the images are at most 2-to-1: at least |W|·rⱼ/2 of them. -/
theorem RRimg_card_half (hodd : r j ≠ 2) [Fintype W] :
    Fintype.card W * r j ≤ 2 * (RRimg (F := F) (K := K) j W (z1 := z1) (z2 := z2)).card := by
  classical
  have h2 : (2 : ZMod (r j)) ≠ 0 := by
    intro h
    have : ((2 : ℕ) : ZMod (r j)) = 0 := by exact_mod_cast h
    rw [ZMod.natCast_eq_zero_iff] at this
    have hp : (r j).Prime := Fact.out
    exact hodd ((Nat.prime_dvd_prime_iff_eq hp Nat.prime_two).mp this)
  set f : W × ZMod (r j) → Sym2 (Pt F K r) := fun w =>
    s(Sum.inr ⟨j, ((w.1 : (ZMod (r j))ˣ) : ZMod (r j)) * z1 + w.2⟩,
      Sum.inr ⟨j, ((w.1 : (ZMod (r j))ˣ) : ZMod (r j)) * z2 + w.2⟩)
  have himg : RRimg (F := F) (K := K) j W (z1 := z1) (z2 := z2) = Finset.univ.image f := by
    rfl
  rw [himg]
  have := Finset.card_le_mul_card_image (f := f) (Finset.univ : Finset (W × ZMod (r j))) 2 ?_
  · rw [Finset.card_univ, Fintype.card_prod, ZMod.card] at this; exact this
  intro b hb
  obtain ⟨a0, -, rfl⟩ := Finset.mem_image.mp hb
  have key : ∀ w, f w = f a0 → (w.1 : (ZMod (r j))ˣ) = a0.1 ∨
      ((w.1 : (ZMod (r j))ˣ) : ZMod (r j)) = -((a0.1 : (ZMod (r j))ˣ) : ZMod (r j)) ∧
        w.2 = a0.2 + ((a0.1 : (ZMod (r j))ˣ) : ZMod (r j)) * (z1 + z2) := by
    intro w hw
    simp only [f, Sym2.eq_iff, Sum.inr.injEq, Sigma.mk.injEq, heq_eq_eq, true_and] at hw
    have h' : s(((a0.1 : (ZMod (r j))ˣ) : ZMod (r j)) * z1 + a0.2, ((a0.1 : (ZMod (r j))ˣ) : ZMod (r j)) * z2 + a0.2) =
        s(((w.1 : (ZMod (r j))ˣ) : ZMod (r j)) * z1 + w.2, ((w.1 : (ZMod (r j))ˣ) : ZMod (r j)) * z2 + w.2) := by
      rw [Sym2.eq_iff]
      rcases hw with ⟨h1, h2⟩ | ⟨h1, h2⟩
      · exact Or.inl ⟨h1.symm, h2.symm⟩
      · exact Or.inr ⟨h2.symm, h1.symm⟩
    rcases pair_eq hz h' with ⟨h1, -⟩ | ⟨h1, h3⟩
    · exact Or.inl (Units.ext h1.symm)
    · exact Or.inr ⟨h1, h3⟩
  have hsame : ∀ w w', f w = f a0 → f w' = f a0 → (w.1 : (ZMod (r j))ˣ) = w'.1 → w = w' := by
    intro w w' hw hw' h
    have h'' : f w = f w' := hw.trans hw'.symm
    simp only [f, Sym2.eq_iff, Sum.inr.injEq, Sigma.mk.injEq, heq_eq_eq, true_and] at h''
    have h' : s(((w.1 : (ZMod (r j))ˣ) : ZMod (r j)) * z1 + w.2, ((w.1 : (ZMod (r j))ˣ) : ZMod (r j)) * z2 + w.2) =
        s(((w'.1 : (ZMod (r j))ˣ) : ZMod (r j)) * z1 + w'.2, ((w'.1 : (ZMod (r j))ˣ) : ZMod (r j)) * z2 + w'.2) := by
      rw [Sym2.eq_iff]; exact h''
    rcases pair_eq hz h' with ⟨-, h2⟩ | ⟨h1, -⟩
    · exact Prod.ext (Subtype.ext h) h2
    · exfalso
      rw [h] at h1
      have hu := (w'.1 : (ZMod (r j))ˣ).ne_zero
      have : (2 : ZMod (r j)) * ((w'.1 : (ZMod (r j))ˣ) : ZMod (r j)) = 0 := by linear_combination h1
      rcases mul_eq_zero.mp this with h | h
      · exact h2 h
      · exact (Units.ne_zero _) h
  calc (Finset.univ.filter fun a => f a = f a0).card
      ≤ (Finset.univ : Finset Bool).card := by
        apply Finset.card_le_card_of_injOn (fun w => decide ((w.1 : (ZMod (r j))ˣ) = a0.1))
        · intro _ _; exact Finset.mem_coe.mpr (Finset.mem_univ _)
        · intro w hw w' hw' hww
          simp only [Finset.coe_filter, Finset.mem_univ, true_and, Set.mem_ofPred_eq] at hw hw'
          apply hsame w w' hw hw'
          by_cases h1 : (w.1 : (ZMod (r j))ˣ) = a0.1
          · have : (w'.1 : (ZMod (r j))ˣ) = a0.1 := by simpa [h1] using hww.symm
            rw [h1, this]
          · have h1' : ¬ (w'.1 : (ZMod (r j))ˣ) = a0.1 := by simpa [h1] using hww.symm
            rcases key w hw with h | ⟨ha, -⟩
            · exact absurd h h1
            rcases key w' hw' with h | ⟨hb, -⟩
            · exact absurd h h1'
            exact Units.ext (ha.trans hb.symm)
    _ = 2 := rfl

end RR

include hN hinj hco in
/-- **Pairs inside ℤ/rⱼ: orbitals of size ≥ orb(rⱼ, |W|)**, for any subgroup W of (ℤ/rⱼ)ˣ whose
elements, placed at j, lie in U. -/
theorem orbit_RR (j : Fin k) (W : Subgroup (ZMod (r j))ˣ) [Fintype W]
    (hW : ∀ w ∈ W, Pi.mulSingle j w ∈ U) {z1 z2 : ZMod (r j)} (hz : z1 ≠ z2) :
    ArkCore.orb (r j) (Fintype.card W) false ≤
      (D2.orbit2 (G (F := F) (K := K) ω U) s(Sum.inr ⟨j, z1⟩, Sum.inr ⟨j, z2⟩)).card := by
  classical
  have hsub := Finset.card_le_card (RRimg_sub ω U hN hinj hco j W hW (z1 := z1) (z2 := z2))
  have hp : (r j).Prime := Fact.out
  unfold ArkCore.orb
  by_cases hr2 : r j = 2
  · -- one pair: orb ≤ C(2,2) = 1, and the orbit is nonempty
    have hne : (D2.orbit2 (G (F := F) (K := K) ω U) s(Sum.inr ⟨j, z1⟩, Sum.inr ⟨j, z2⟩)).Nonempty :=
      ⟨_, by simpa using map_mem ω U (Subgroup.one_mem _) s(Sum.inr ⟨j, z1⟩, Sum.inr ⟨j, z2⟩)⟩
    have := hne.card_pos
    have h1 : ArkCore.pairs (r j) = 1 := by rw [hr2]; rfl
    rw [h1]; omega
  have hhalf := RRimg_card_half (F := F) (K := K) j W hz hr2
  by_cases ht : (false = true ∨ Fintype.card W % 2 = 0)
  · simp only [ht, ite_true]
    apply le_trans (Nat.min_le_left _ _)
    rw [Nat.div_le_iff_le_mul_add_pred (by norm_num)]
    have : r j * Fintype.card W = Fintype.card W * r j := Nat.mul_comm _ _
    omega
  · simp only [ht, ite_false]
    apply le_trans (Nat.min_le_left _ _)
    have hneg : (-1 : (ZMod (r j))ˣ) ∉ W := by
      intro h
      have hd : orderOf ((⟨-1, h⟩ : W)) ∣ Fintype.card W := orderOf_dvd_card
      have h2 : orderOf ((⟨-1, h⟩ : W)) = 2 := by
        apply orderOf_eq_prime
        · apply Subtype.ext; simp
        · intro h1
          have h1' : (-1 : (ZMod (r j))ˣ) = 1 := congrArg Subtype.val h1
          have : ((-1 : (ZMod (r j))ˣ) : ZMod (r j)) = 1 := by rw [h1']; rfl
          simp only [Units.val_neg, Units.val_one] at this
          have h3 : ((2 : ℕ) : ZMod (r j)) = 0 := by push_cast; linear_combination -this
          rw [ZMod.natCast_eq_zero_iff] at h3
          exact hr2 ((Nat.prime_dvd_prime_iff_eq hp Nat.prime_two).mp h3)
      rw [h2] at hd
      simp only [Bool.false_eq_true, false_or] at ht
      omega
    have := RRimg_card_inj (F := F) (K := K) j W hz hneg
    rw [Nat.mul_comm]; omega

end orbitals

/-! ## Realisability, against the E.6 model's REFINED score -/

open ArkCore E6 E5Assembly

/-- A product xs[i]·xs[l] (i < l) is a between-parts term. -/
theorem crossN_mem : ∀ (xs : List ℕ) {i l : ℕ} (hi : i < l) (hl : l < xs.length),
    xs[i] * xs[l] ∈ crossN xs
  | [], _, _, _, hl => absurd hl (Nat.not_lt_zero _)
  | x :: xs, i, l, hi, hl => by
    simp only [crossN, List.mem_append, List.mem_map]
    rcases i with _ | i
    · left
      obtain ⟨l, rfl⟩ : ∃ l', l = l' + 1 := ⟨l - 1, by omega⟩
      simp only [List.length_cons] at hl
      exact ⟨xs[l]'(by omega), List.getElem_mem _, rfl⟩
    · right
      obtain ⟨l, rfl⟩ : ∃ l', l = l' + 1 := ⟨l - 1, by omega⟩
      simp only [List.length_cons] at hl
      exact crossN_mem xs (by omega) (by omega)

/-- The configuration realised: one class of F blocks of size c at full twist, and foreign
blocks (rⱼ, tⱼ). -/
def cfgG (p q F c : ℕ) {k : ℕ} (r t : Fin k → ℕ) : Config :=
  ⟨p, q, .pc F c (c - 1) :: List.ofFn (fun j => CPart.fr (r j) (t j))⟩

theorem cfgG_n (p q F c : ℕ) {k : ℕ} (r t : Fin k → ℕ) :
    (cfgG p q F c r t).n = F * c + ∑ j, r j := by
  simp [cfgG, Config.n, Config.sizes, CPart.sizeC, List.sum_ofFn]

/-- **Part E for one class beside any foreign blocks.**  F ≥ 1 blocks of 𝔽_c (c = |K| = p^b) at
full twist, and foreign blocks of distinct primes rⱼ with q-power twists tⱼ ∣ rⱼ − 1, coherent
(rⱼ ∤ F·(c − 1)): the group G = ⟨T, γ, μ(U)⟩ carries an Oliver chain (p, q), and every orbital on
unordered pairs has size at least REFINED of the configuration. -/
theorem partE_G (p q b : ℕ) [Fact p.Prime] [CharP K p]
    (hK : Fintype.card K = p ^ b) (t : Fin k → ℕ)
    (ht : ∀ j, t j ∣ r j - 1 ∧ ∃ f, t j = q ^ f) (hinj : Function.Injective r)
    (hcoh : ∀ j, ¬ r j ∣ F * (p ^ b - 1)) :
    ∃ (ω : Kˣ) (U : Subgroup (∀ j, (ZMod (r j))ˣ)),
      Nonempty (Chain.OliverChain (G (F := F) (K := K) (r := r) ω U) p q) ∧
      ∀ e : Sym2 (Pt F K r), ¬ e.IsDiag →
        (cfgG p q F (p ^ b) r t).refined ≤ (D2.orbit2 (G (F := F) (K := K) ω U) e).card := by
  classical
  obtain ⟨ω, hω⟩ := IsCyclic.exists_generator (α := Kˣ)
  have hN : ω ^ (p ^ b - 1) = 1 := by
    have : orderOf ω = p ^ b - 1 := by
      rw [orderOf_eq_card_of_forall_mem_zpowers hω, Nat.card_eq_fintype_card, Fintype.card_units, hK]
    rw [← this]; exact pow_orderOf_eq_one ω
  have hco : ∀ j, ((F * (p ^ b - 1) : ℕ) : ZMod (r j)) ≠ 0 := fun j h =>
    hcoh j ((ZMod.natCast_eq_zero_iff _ _).mp h)
  -- the twist groups
  have hg : ∀ j, ∃ g : (ZMod (r j))ˣ, orderOf g = t j := by
    intro j
    obtain ⟨g0, hg0⟩ := IsCyclic.exists_ofOrder_eq_natCard (α := (ZMod (r j))ˣ)
    have hc : Nat.card (ZMod (r j))ˣ = r j - 1 := by
      rw [Nat.card_eq_fintype_card, ZMod.card_units]
    rw [hc] at hg0
    have hr2 := (Fact.out : (r j).Prime).two_le
    refine ⟨g0 ^ (orderOf g0 / t j), orderOf_pow_orderOf_div (by omega) ?_⟩
    rw [hg0]; exact (ht j).1
  choose g hgo using hg
  set W : ∀ j, Subgroup (ZMod (r j))ˣ := fun j => Subgroup.zpowers (g j)
  set U : Subgroup (∀ j, (ZMod (r j))ˣ) := Subgroup.pi Set.univ W
  have hW : ∀ j, ∀ w ∈ W j, Pi.mulSingle j w ∈ U := by
    intro j w hw
    rw [Subgroup.mem_pi]
    intro i _
    by_cases hij : i = j
    · subst hij; simpa using hw
    · rw [Pi.mulSingle_eq_of_ne hij]; exact Subgroup.one_mem _
  choose f hf using fun j => (ht j).2
  have hU : ∀ u ∈ U, ∃ m : ℕ, u ^ q ^ m = 1 := by
    intro u hu
    refine ⟨∑ j, f j, ?_⟩
    funext j
    have hj := (Subgroup.mem_pi _).mp hu j (Set.mem_univ _)
    obtain ⟨z, hz⟩ := Subgroup.mem_zpowers_iff.mp hj
    have h1 : (g j) ^ (q ^ f j) = 1 := by rw [← hf j, ← hgo j]; exact pow_orderOf_eq_one _
    have hdvd : q ^ f j ∣ q ^ ∑ j, f j :=
      pow_dvd_pow q (Finset.single_le_sum (fun _ _ => Nat.zero_le _) (Finset.mem_univ j))
    obtain ⟨m, hm⟩ := hdvd
    simp only [Pi.pow_apply, Pi.one_apply]
    rw [← hz, ← zpow_natCast, ← zpow_mul, mul_comm, zpow_mul, zpow_natCast, hm, pow_mul, h1, one_pow,
      one_zpow]
  refine ⟨ω, U, ⟨chain ω U p q hN hinj hco hU⟩, fun e he => ?_⟩
  have hcardW : ∀ j, Fintype.card (W j) = t j := fun j => by
    rw [Fintype.card_zpowers, hgo j]
  -- the terms of the configuration
  set C := cfgG p q F (p ^ b) r t
  have hpc : F * pairs (p ^ b) ∈ C.parts.flatMap (CPart.refinedTerms (decide (C.p = 2))) ++
      crossN C.sizes := by
    apply List.mem_append_left
    apply List.mem_flatMap.mpr
    refine ⟨.pc F (p ^ b) (p ^ b - 1), List.mem_cons_self .., ?_⟩
    simp [CPart.refinedTerms, orb_full]
  have hsz : C.sizes = F * p ^ b :: List.ofFn r := by
    simp [C, cfgG, Config.sizes, CPart.sizeC, List.map_ofFn, Function.comp_def]
  have hKR : ∀ l, F * p ^ b * r l ∈ crossN C.sizes := by
    intro l
    rw [hsz]
    simp only [crossN, List.mem_append, List.mem_map, List.mem_ofFn]
    left; exact ⟨r l, ⟨l, rfl⟩, rfl⟩
  induction e using Sym2.ind with
  | h x y =>
    rw [Sym2.mk_isDiag_iff] at he
    rcases x with ⟨i, x⟩ | ⟨j, z⟩ <;> rcases y with ⟨i2, y⟩ | ⟨l, w⟩
    · by_cases hii : i = i2
      · subst hii
        have hxy : x ≠ y := fun h => he (by rw [h])
        have := orbit_KK ω U hN hinj hco hω i hxy
        rw [hK, ← Ark.pairs_eq_choose] at this
        exact le_trans (minL_le hpc) this
      · have hF : 1 < F := by
          by_contra h
          have : F = 1 := by have := NeZero.ne F; omega
          subst this
          exact hii (Subsingleton.elim _ _)
        have : Fact (1 < F) := ⟨hF⟩
        have := orbit_cross ω U hN hinj hco hii x y
        rw [hK] at this
        refine le_trans (minL_le ?_) this
        apply List.mem_append_left
        apply List.mem_flatMap.mpr
        refine ⟨.pc F (p ^ b) (p ^ b - 1), List.mem_cons_self .., ?_⟩
        simp [CPart.refinedTerms, show 2 ≤ F by omega, PartEF.K0]
    · have := orbit_KR ω U hN hinj hco hω i x l w
      rw [hK] at this
      exact le_trans (minL_le (List.mem_append_right _ (hKR _))) this
    · rw [Sym2.eq_swap]
      have := orbit_KR ω U hN hinj hco hω i2 y j z
      rw [hK] at this
      exact le_trans (minL_le (List.mem_append_right _ (hKR _))) this
    · by_cases hjl : j = l
      · subst hjl
        have hzw : z ≠ w := fun h => he (by rw [h])
        have := orbit_RR ω U hN hinj hco j (W j) (hW j) hzw
        rw [hcardW] at this
        refine le_trans (minL_le ?_) this
        apply List.mem_append_left
        apply List.mem_flatMap.mpr
        exact ⟨.fr (r j) (t j), List.mem_cons_of_mem _ (List.mem_ofFn.mpr ⟨j, rfl⟩),
          by simp [CPart.refinedTerms]⟩
      · have := orbit_RR' ω U hN hinj hco hjl z w
        refine le_trans (minL_le ?_) this
        apply List.mem_append_right
        rw [hsz]
        simp only [crossN, List.mem_append]
        right
        rcases lt_or_gt_of_ne (Fin.val_ne_of_ne hjl) with h | h
        · have := crossN_mem (List.ofFn r) h (by simp)
          simpa using this
        · have := crossN_mem (List.ofFn r) h (by simp)
          simpa [Nat.mul_comm] using this

/-- **Packaged with `GaloisField p b`**: an Oliver group on F·c + Σ rⱼ points all of whose
pair-orbitals are at least REFINED of the configuration. -/
theorem partE_G_exists (p q b : ℕ) [Fact p.Prime] (hb : b ≠ 0) (t : Fin k → ℕ)
    (ht : ∀ j, t j ∣ r j - 1 ∧ ∃ f, t j = q ^ f) (hinj : Function.Injective r)
    (hcoh : ∀ j, ¬ r j ∣ F * (p ^ b - 1)) :
    ∃ (X : Type) (_ : Fintype X) (_ : DecidableEq X) (G : Subgroup (Perm X)),
      Fintype.card X = (cfgG p q F (p ^ b) r t).n ∧ Nonempty (Chain.OliverChain G p q) ∧
      ∀ e : Sym2 X, ¬ e.IsDiag → (cfgG p q F (p ^ b) r t).refined ≤ (D2.orbit2 G e).card := by
  classical
  let K := GaloisField p b
  let _ : Fintype K := Fintype.ofFinite K
  have hK : Fintype.card K = p ^ b := by
    rw [← Nat.card_eq_fintype_card]; exact GaloisField.card p b hb
  obtain ⟨ω, U, hch, horb⟩ := partE_G (F := F) (K := K) (r := r) p q b hK t ht hinj hcoh
  refine ⟨Pt F K r, inferInstance, inferInstance, G (F := F) (K := K) ω U, ?_, hch, ?_⟩
  · rw [cfgG_n, Fintype.card_sum, Fintype.card_prod, ZMod.card, hK, Fintype.card_sigma]
    simp [ZMod.card]
  · intro e he
    convert horb e he using 2

end PartEG

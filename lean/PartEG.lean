/-
# `PartEG.lean` — Part E (realisability) for any number of classes beside any foreign blocks

`enumeration-proof.md` Part E's construction for p-characteristic classes (class i: Fᵢ ≥ 1 blocks
of 𝔽_{cᵢ}, full twist) beside foreign blocks ℤ/r₁, …, ℤ/r_k of distinct primes, each with a twist
group of q-power order (any q, including q = 2).  It generalises `PartE1` (F = 1, one foreign
block) and `PartEF` (one class, one foreign block, odd prime twist).

* **The group** G = ⟨T, γ, μ(U)⟩ on (Σᵢ ℤ/Fᵢ × Kᵢ) ⊔ Σⱼ ℤ/rⱼ: T the translations of all blocks,
  γ = the entangled rotation `zc` on every class at once and z ↦ z + 1 on every ℤ/rⱼ (the text's
  single diagonal carrier), μ_u = z ↦ uⱼ·z on each ℤ/rⱼ for u in a subgroup U of Πⱼ (ℤ/rⱼ)ˣ.
* **The Oliver chain** (`chain`): T (a p-group) ◁ ⟨T, γ⟩ (cyclic over T) ◁ G (a q-group over
  ⟨T, γ⟩).  The one arithmetic input is **coherence**: no rⱼ divides any Fᵢ·(cᵢ − 1), so that by
  the Chinese remainder theorem every translation vector ρ_v of the foreign blocks is a power of γ
  (`ρ_mem`).
* **The orbitals** (`orbit_*`): within a block of class i, Fᵢ·C(cᵢ,2); across two blocks of class
  i, ≥ K0·cᵢ²; class i – ℤ/rⱼ, Fᵢ·cᵢ·rⱼ; ℤ/rⱼ–ℤ/rₗ, rⱼ·rₗ; inside ℤ/rⱼ, ≥ orb(rⱼ, |Uⱼ|).
* **Two classes (`orbit_CC`)**: ≥ Fᵢ·cᵢ·cᵢ'.  Because one γ rotates both classes together, the
  between-class orbital is lcm(Fᵢ, Fᵢ')·cᵢ·cᵢ', **not** the product of the class sizes when the
  block counts share a factor.  It is nonetheless always at least the smaller-block class's intra
  term, so the configuration's REFINED score is still realised (`partE_M`).
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

/-! ## The points and the generators

m classes, class i being F i blocks of a field K i; k foreign blocks ℤ/rⱼ. -/

variable {m : ℕ} {F : Fin m → ℕ} [∀ i, NeZero (F i)] {K : Fin m → Type*} [∀ i, Field (K i)]
  {k : ℕ} {r : Fin k → ℕ} [∀ j, Fact (r j).Prime]

variable (F K) in
/-- The class points: block a of class i is {i} × {a} × K i. -/
abbrev Cl := Σ i, ZMod (F i) × K i

variable (F K) in
/-- The points: the classes, and the foreign blocks ℤ/rⱼ. -/
abbrev Pt (r : Fin k → ℕ) := Cl F K ⊕ (Σ j, ZMod (r j))

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

/-- The entangled rotation on every class at once. -/
def czc (ω : ∀ i, (K i)ˣ) : Perm (Cl F K) where
  toFun x := ⟨x.1, zc (ω x.1) x.2⟩
  invFun x := ⟨x.1, (zc (ω x.1)).symm x.2⟩
  left_inv x := by simp
  right_inv x := by simp

/-- Translation by t on the class blocks (identity on the foreign blocks). -/
def trE (t : ∀ i, ZMod (F i) → K i) : Perm (Cl F K) where
  toFun x := ⟨x.1, (x.2.1, x.2.2 + t x.1 x.2.1)⟩
  invFun x := ⟨x.1, (x.2.1, x.2.2 - t x.1 x.2.1)⟩
  left_inv x := by simp
  right_inv x := by simp

def trHom : Multiplicative (∀ i, ZMod (F i) → K i) →* Perm (Pt F K r) where
  toFun t := Perm.sumCongr (trE (Multiplicative.toAdd t)) 1
  map_one' := by ext (⟨i, a, x⟩ | z) <;> simp [trE]
  map_mul' s t := by
    ext (⟨i, a, x⟩ | z)
    · simp [trE]; ring
    · simp

/-- The translation subgroup: N₂. -/
def T : Subgroup (Perm (Pt F K r)) := (trHom (F := F) (K := K) (r := r)).range

/-- The cyclic-layer generator: the entangled rotation on every class, z ↦ z + 1 on each ℤ/rⱼ. -/
def γ (ω : ∀ i, (K i)ˣ) : Perm (Pt F K r) := Perm.sumCongr (czc ω) (fadd fun _ => 1)

/-- Translation by v on the foreign blocks only. -/
def ρ (v : ∀ j, ZMod (r j)) : Perm (Pt F K r) := Perm.sumCongr 1 (fadd v)

/-- The top: z ↦ uⱼ·z on each ℤ/rⱼ. -/
def μ (u : ∀ j, (ZMod (r j))ˣ) : Perm (Pt F K r) := Perm.sumCongr 1 (fmul u)

@[simp] theorem trHom_inl (t : Multiplicative (∀ i, ZMod (F i) → K i)) (i : Fin m) (a : ZMod (F i))
    (x : K i) : trHom (r := r) t (Sum.inl ⟨i, a, x⟩) =
      Sum.inl ⟨i, a, x + Multiplicative.toAdd t i a⟩ := rfl
@[simp] theorem trHom_inr (t : Multiplicative (∀ i, ZMod (F i) → K i)) (z : Σ j, ZMod (r j)) :
    trHom (F := F) (K := K) t (Sum.inr z) = Sum.inr z := rfl
@[simp] theorem ρ_inl (v : ∀ j, ZMod (r j)) (p : Cl F K) :
    ρ (F := F) (K := K) v (Sum.inl p) = Sum.inl p := rfl
@[simp] theorem ρ_inr (v : ∀ j, ZMod (r j)) (j : Fin k) (z : ZMod (r j)) :
    ρ (F := F) (K := K) v (Sum.inr ⟨j, z⟩) = Sum.inr ⟨j, z + v j⟩ := rfl
@[simp] theorem μ_inl (u : ∀ j, (ZMod (r j))ˣ) (p : Cl F K) :
    μ (F := F) (K := K) u (Sum.inl p) = Sum.inl p := rfl
@[simp] theorem μ_inr (u : ∀ j, (ZMod (r j))ˣ) (j : Fin k) (z : ZMod (r j)) :
    μ (F := F) (K := K) u (Sum.inr ⟨j, z⟩) = Sum.inr ⟨j, (u j : ZMod (r j)) * z⟩ := rfl
@[simp] theorem γ_inl (ω : ∀ i, (K i)ˣ) (i : Fin m) (p : ZMod (F i) × K i) :
    γ (r := r) ω (Sum.inl ⟨i, p⟩) = Sum.inl ⟨i, zc (ω i) p⟩ := rfl
@[simp] theorem γ_inr (ω : ∀ i, (K i)ˣ) (j : Fin k) (z : ZMod (r j)) :
    γ (F := F) (K := K) ω (Sum.inr ⟨j, z⟩) = Sum.inr ⟨j, z + 1⟩ := rfl

theorem γ_pow_inl (ω : ∀ i, (K i)ˣ) (n : ℕ) (i : Fin m) (p : ZMod (F i) × K i) :
    (γ (r := r) ω ^ n) (Sum.inl ⟨i, p⟩) = Sum.inl ⟨i, (zc (ω i) ^ n) p⟩ := by
  induction n generalizing p with
  | zero => rfl
  | succ n ih => rw [pow_succ, Perm.mul_apply, γ_inl, ih, pow_succ, Perm.mul_apply]

theorem γ_pow_inr (ω : ∀ i, (K i)ˣ) (n : ℕ) (j : Fin k) (z : ZMod (r j)) :
    (γ (F := F) (K := K) ω ^ n) (Sum.inr ⟨j, z⟩) = Sum.inr ⟨j, z + n⟩ := by
  induction n generalizing z with
  | zero => simp
  | succ n ih => rw [pow_succ, Perm.mul_apply, γ_inr, ih]; push_cast; ring_nf

/-- **γ normalises the translations**. -/
theorem γ_conj_tr (ω : ∀ i, (K i)ˣ) (t : Multiplicative (∀ i, ZMod (F i) → K i)) :
    γ (r := r) ω * trHom t * (γ ω)⁻¹ =
      trHom (Multiplicative.ofAdd fun i a => wrap (ω i) (a - 1) * Multiplicative.toAdd t i (a - 1)) := by
  rw [mul_inv_eq_iff_eq_mul]
  ext (⟨i, a, x⟩ | ⟨j, z⟩)
  · simp only [Perm.mul_apply, trHom_inl, γ_inl, zc_apply, toAdd_ofAdd, add_sub_cancel_right]
    simp only [Sum.inl.injEq, Sigma.mk.injEq, heq_eq_eq, true_and, Prod.mk.injEq]; ring
  · simp [Perm.mul_apply]

theorem μ_conj_tr (u : ∀ j, (ZMod (r j))ˣ) (t : Multiplicative (∀ i, ZMod (F i) → K i)) :
    μ u * trHom t * (μ u)⁻¹ = trHom t := by
  rw [mul_inv_eq_iff_eq_mul]
  ext (⟨i, a, x⟩ | ⟨j, z⟩) <;> simp [Perm.mul_apply]

theorem μ_conj_γ (ω : ∀ i, (K i)ˣ) (u : ∀ j, (ZMod (r j))ˣ) :
    μ u * γ (F := F) (K := K) ω * (μ u)⁻¹ = γ ω * ρ (fun j => (u j : ZMod (r j)) - 1) := by
  rw [mul_inv_eq_iff_eq_mul]
  ext (⟨i, a, x⟩ | ⟨j, z⟩)
  · simp [Perm.mul_apply]
  · simp [Perm.mul_apply]; ring

theorem μ_mul (u v : ∀ j, (ZMod (r j))ˣ) : μ (F := F) (K := K) (u * v) = μ u * μ v := by
  ext (⟨i, a, x⟩ | ⟨j, z⟩) <;> simp [Perm.mul_apply, mul_assoc]
theorem μ_one : μ (F := F) (K := K) (1 : ∀ j, (ZMod (r j))ˣ) = 1 := by
  ext (⟨i, a, x⟩ | ⟨j, z⟩) <;> simp
theorem μ_inv (u : ∀ j, (ZMod (r j))ˣ) : μ (F := F) (K := K) u⁻¹ = (μ u)⁻¹ := by
  rw [eq_inv_iff_mul_eq_one, ← μ_mul, inv_mul_cancel, μ_one]
theorem μ_pow (u : ∀ j, (ZMod (r j))ˣ) (n : ℕ) : μ (F := F) (K := K) (u ^ n) = μ u ^ n := by
  induction n with
  | zero => simp [μ_one]
  | succ n ih => rw [pow_succ, μ_mul, ih, pow_succ]

/-! ## The subgroups -/

/-- N₁ = ⟨T, γ⟩. -/
def N1 (ω : ∀ i, (K i)ˣ) : Subgroup (Perm (Pt F K r)) :=
  Subgroup.closure (((T (F := F) (K := K) (r := r) : Subgroup _) : Set (Perm (Pt F K r))) ∪ {γ ω})

/-- G = ⟨T, γ, μ(U)⟩. -/
def G (ω : ∀ i, (K i)ˣ) (U : Subgroup (∀ j, (ZMod (r j))ˣ)) : Subgroup (Perm (Pt F K r)) :=
  Subgroup.closure (((T (F := F) (K := K) (r := r) : Subgroup _) : Set (Perm (Pt F K r))) ∪ {γ ω} ∪
    (μ '' (U : Set (∀ j, (ZMod (r j))ˣ))))

theorem T_le_N1 (ω : ∀ i, (K i)ˣ) : (T (F := F) (K := K) (r := r)) ≤ N1 ω :=
  fun _ hx => Subgroup.subset_closure (Or.inl hx)
theorem γ_mem_N1 (ω : ∀ i, (K i)ˣ) : γ ω ∈ N1 (F := F) (K := K) (r := r) ω :=
  Subgroup.subset_closure (Or.inr rfl)
theorem N1_le_G (ω : ∀ i, (K i)ˣ) (U : Subgroup (∀ j, (ZMod (r j))ˣ)) :
    N1 (F := F) (K := K) ω ≤ G ω U :=
  Subgroup.closure_mono (fun _ hx => Or.inl hx)
theorem μ_mem_G (ω : ∀ i, (K i)ˣ) {U : Subgroup (∀ j, (ZMod (r j))ˣ)} {u : ∀ j, (ZMod (r j))ˣ}
    (hu : u ∈ U) : μ u ∈ G (F := F) (K := K) ω U :=
  Subgroup.subset_closure (Or.inr ⟨u, hu, rfl⟩)

/-- Distinct primes are pairwise coprime. -/
theorem coprime_of_inj (hinj : Function.Injective r) : Pairwise (Function.onFun Nat.Coprime r) := by
  intro i j hij
  exact (Nat.coprime_primes (Fact.out) (Fact.out)).mpr (fun h => hij (hinj h))

/-- A power of γ with exponent a multiple of (∏ F)·N is trivial on the classes. -/
theorem γ_pow_inl_one (ω : ∀ i, (K i)ˣ) {N : ℕ} (hN : ∀ i, ω i ^ N = 1) (y : ℕ) (i : Fin m)
    (p : ZMod (F i) × K i) :
    (γ (r := r) ω ^ ((∏ i, F i) * (N * y))) (Sum.inl ⟨i, p⟩) = Sum.inl ⟨i, p⟩ := by
  obtain ⟨a, ha⟩ : F i ∣ ∏ i, F i := Finset.dvd_prod_of_mem _ (Finset.mem_univ i)
  rw [γ_pow_inl, ha, mul_assoc, zc_pow_eq_one (ω i) (a * (N * y))
    (by rw [← mul_assoc, mul_comm a N, mul_assoc, pow_mul, hN, one_pow])]
  rfl

/-- **ρ_v ∈ N₁ for every v**, when no rⱼ divides (∏ F)·N (N with ωᵢ^N = 1) and the rⱼ are
distinct: by the Chinese remainder theorem ρ_v is a power of γ.  This is where coherence is
used. -/
theorem ρ_mem (ω : ∀ i, (K i)ˣ) {N : ℕ} (hN : ∀ i, ω i ^ N = 1) (hinj : Function.Injective r)
    (hco : ∀ j, (((∏ i, F i) * N : ℕ) : ZMod (r j)) ≠ 0) (v : ∀ j, ZMod (r j)) :
    ρ v ∈ N1 (F := F) (K := K) ω := by
  have : NeZero (∏ j, r j) := ⟨Finset.prod_ne_zero_iff.mpr fun j _ => (Fact.out : (r j).Prime).ne_zero⟩
  set P := ∏ i, F i
  set e := ZMod.prodEquivPi r (coprime_of_inj hinj)
  set y := e.symm (fun j => v j * ((P * N : ℕ) : ZMod (r j))⁻¹)
  have hy : ∀ j, ((y.val : ℕ) : ZMod (r j)) = v j * ((P * N : ℕ) : ZMod (r j))⁻¹ := by
    intro j
    have h1 := congrFun (e.apply_symm_apply (fun j => v j * ((P * N : ℕ) : ZMod (r j))⁻¹)) j
    rw [← h1, ZMod.prodEquivPi_apply, ZMod.castHom_apply, ZMod.natCast_val]
  have : ρ v = γ (F := F) (K := K) (r := r) ω ^ (P * (N * y.val)) := by
    ext (⟨i, p⟩ | ⟨j, z⟩)
    · rw [γ_pow_inl_one ω hN]; rfl
    · have key : ((P * (N * y.val) : ℕ) : ZMod (r j)) = v j := by
        have h1 := hco j
        have e1 : ((P * (N * y.val) : ℕ) : ZMod (r j)) = ((P * N : ℕ) : ZMod (r j)) * (y.val : ℕ) := by
          push_cast; ring
        rw [e1, hy j, mul_comm (v j), ← mul_assoc, mul_inv_cancel₀ h1, one_mul]
      rw [γ_pow_inr, ρ_inr, key]
  rw [this]
  exact Subgroup.pow_mem _ (γ_mem_N1 ω) _

section coh
variable (ω : ∀ i, (K i)ˣ) {N : ℕ} (hN : ∀ i, ω i ^ N = 1) (hinj : Function.Injective r)
  (hco : ∀ j, (((∏ i, F i) * N : ℕ) : ZMod (r j)) ≠ 0)
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

variable [∀ i, Fintype (K i)] [∀ i, DecidableEq (K i)]

theorem T_le_G (ω : ∀ i, (K i)ˣ) (U : Subgroup (∀ j, (ZMod (r j))ˣ)) :
    (T (F := F) (K := K) (r := r)) ≤ G ω U :=
  le_trans (T_le_N1 ω) (N1_le_G ω U)

instance T_normal (ω : ∀ i, (K i)ˣ) (U : Subgroup (∀ j, (ZMod (r j))ˣ)) :
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
variable (ω : ∀ i, (K i)ˣ) (U : Subgroup (∀ j, (ZMod (r j))ˣ))

theorem N1_normal {N : ℕ} (hN : ∀ i, ω i ^ N = 1) (hinj : Function.Injective r)
    (hco : ∀ j, (((∏ i, F i) * N : ℕ) : ZMod (r j)) ≠ 0) :
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
abbrev TG : Subgroup (G (F := F) (K := K) (r := r) ω U) :=
  (T (F := F) (K := K) (r := r)).subgroupOf (G ω U)
abbrev LayerQ := (N1G (F := F) (K := K) (r := r) ω U) ⧸ (TG ω U).subgroupOf (N1G ω U)

/-- The class in the layer of an element of N₁. -/
def lcls (y : Perm (Pt F K r)) (hyN : y ∈ N1 (F := F) (K := K) ω) : LayerQ (F := F) (K := K) ω U :=
  QuotientGroup.mk ⟨⟨y, N1_le_G ω U hyN⟩, Subgroup.mem_subgroupOf.mpr hyN⟩

theorem lcls_mul (x y : Perm (Pt F K r)) (hx : x ∈ N1 (F := F) (K := K) ω)
    (hy : y ∈ N1 (F := F) (K := K) ω) :
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
theorem decomp {N : ℕ} (hN : ∀ i, ω i ^ N = 1) (hinj : Function.Injective r)
    (hco : ∀ j, (((∏ i, F i) * N : ℕ) : ZMod (r j)) ≠ 0)
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
theorem top_pgroup (q : ℕ) {N : ℕ} (hN : ∀ i, ω i ^ N = 1) (hinj : Function.Injective r)
    (hco : ∀ j, (((∏ i, F i) * N : ℕ) : ZMod (r j)) ≠ 0)
    (hU : ∀ u ∈ U, ∃ m : ℕ, u ^ q ^ m = 1) [(N1G (F := F) (K := K) (r := r) ω U).Normal] :
    IsPGroup q ((G (F := F) (K := K) (r := r) ω U) ⧸ N1G ω U) := by
  intro x
  induction x using QuotientGroup.induction_on with
  | H g =>
    obtain ⟨g, hg⟩ := g
    obtain ⟨u, hu, hn⟩ := decomp ω U hN hinj hco hg
    obtain ⟨e, he⟩ := hU u hu
    refine ⟨e, ?_⟩
    have hμG : μ u ∈ G (F := F) (K := K) ω U := μ_mem_G ω hu
    have h1 : (QuotientGroup.mk (⟨g, hg⟩ : G (F := F) (K := K) ω U) :
        (G (F := F) (K := K) (r := r) ω U) ⧸ N1G ω U) = QuotientGroup.mk ⟨μ u, hμG⟩ := by
      rw [QuotientGroup.eq, Subgroup.mem_subgroupOf]
      have : ((⟨g, hg⟩ : G (F := F) (K := K) ω U)⁻¹ * ⟨μ u, hμG⟩ : G (F := F) (K := K) ω U).1 =
          ((μ u)⁻¹ * g)⁻¹ := by simp
      rw [this]; exact Subgroup.inv_mem _ hn
    rw [h1, ← QuotientGroup.mk_pow, QuotientGroup.eq_one_iff, Subgroup.mem_subgroupOf]
    have : ((⟨μ u, hμG⟩ : G (F := F) (K := K) ω U) ^ q ^ e).1 = 1 := by
      rw [Subgroup.coe_pow, ← μ_pow, he, μ_one]
    rw [this]; exact Subgroup.one_mem _

theorem T_pgroup (p : ℕ) [Fact p.Prime] [∀ i, CharP (K i) p] :
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
    funext i a
    simp
  rw [this, map_one]

/-- **The Oliver chain** on G: N₂ = T ◁ N₁ = ⟨T, γ⟩ (cyclic over T) ◁ G (a q-group over N₁). -/
def chain (p q : ℕ) [Fact p.Prime] [∀ i, CharP (K i) p] {N : ℕ} (hN : ∀ i, ω i ^ N = 1)
    (hinj : Function.Injective r) (hco : ∀ j, (((∏ i, F i) * N : ℕ) : ZMod (r j)) ≠ 0)
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
variable (ω : ∀ i, (K i)ˣ) (U : Subgroup (∀ j, (ZMod (r j))ˣ)) {N : ℕ} (hN : ∀ i, ω i ^ N = 1)
  (hinj : Function.Injective r) (hco : ∀ j, (((∏ i, F i) * N : ℕ) : ZMod (r j)) ≠ 0)

/-- The constant translation vector n on every foreign block. -/
def cst (n : ℕ) : ∀ j, ZMod (r j) := fun j => (n : ZMod (r j))

theorem trHom_mem (t : Multiplicative (∀ i, ZMod (F i) → K i)) :
    trHom t ∈ G (F := F) (K := K) (r := r) ω U :=
  T_le_G ω U ⟨t, rfl⟩
theorem γpow_mem (n : ℕ) : γ ω ^ n ∈ G (F := F) (K := K) (r := r) ω U :=
  Subgroup.pow_mem _ (N1_le_G ω U (γ_mem_N1 ω)) n
include hN hinj hco in
theorem ρ_memG (v : ∀ j, ZMod (r j)) : ρ v ∈ G (F := F) (K := K) ω U :=
  N1_le_G ω U (ρ_mem ω hN hinj hco v)

/-- The translation by the constant b on every block of class i (zero elsewhere). -/
def tconst (i : Fin m) (b : K i) : Multiplicative (∀ i, ZMod (F i) → K i) :=
  Multiplicative.ofAdd (Pi.single i (fun _ => b))

@[simp] theorem tconst_same (i : Fin m) (b : K i) (a : ZMod (F i)) :
    Multiplicative.toAdd (tconst (F := F) i b) i a = b := by simp [tconst]

include hN hinj hco in
/-- **Move a block of class i onto any block of class i by any affine map**, fixing the foreign
blocks. -/
theorem block_map (hω : ∀ i (a : (K i)ˣ), a ∈ Subgroup.zpowers (ω i)) (i : Fin m)
    (a0 a1 : ZMod (F i)) (α : (K i)ˣ) (b : K i) :
    ∃ g ∈ G (F := F) (K := K) (r := r) ω U,
      (∀ v, g (Sum.inl ⟨i, a0, v⟩) = Sum.inl ⟨i, a1, α * v + b⟩) ∧
      ∀ z, g (Sum.inr z) = Sum.inr z := by
  set m0 := (a1 - a0).val
  set e := (a0.val + m0) / F i
  obtain ⟨n, hn⟩ : ∃ n : ℕ, ω i ^ n = α * (ω i ^ e)⁻¹ := by
    have := hω i (α * (ω i ^ e)⁻¹)
    rw [← mem_powers_iff_mem_zpowers] at this
    exact this
  refine ⟨ρ (-cst m0) * trHom (tconst i b) * (γ ω ^ (F i * n) * ρ (-cst (F i * n))) * γ ω ^ m0,
    ?_, ?_, ?_⟩
  · refine Subgroup.mul_mem _ (Subgroup.mul_mem _ (Subgroup.mul_mem _ (ρ_memG ω U hN hinj hco _)
      (trHom_mem ω U _)) (Subgroup.mul_mem _ (γpow_mem ω U _) (ρ_memG ω U hN hinj hco _)))
      (γpow_mem ω U _)
  · intro v
    have hik : a0 + (m0 : ZMod (F i)) = a1 := by simp [m0]
    simp only [Perm.mul_apply, γ_pow_inl, zc_pow, ρ_inl, trHom_inl, hik, tconst_same]
    simp only [Sum.inl.injEq, Sigma.mk.injEq, heq_eq_eq, true_and, Prod.mk.injEq]
    have hF : 0 < F i := Nat.pos_of_ne_zero (NeZero.ne (F i))
    have h2 : (a1.val + F i * n) / F i = n := by
      rw [Nat.add_mul_div_left _ _ hF, Nat.div_eq_of_lt (ZMod.val_lt a1), zero_add]
    refine ⟨by push_cast; simp, ?_⟩
    rw [h2, hn]
    rw [← mul_assoc, ← Units.val_mul, inv_mul_cancel_right]
  · rintro ⟨j, z⟩
    simp only [Perm.mul_apply, γ_pow_inr, ρ_inr, trHom_inr, cst, Pi.neg_apply]
    congr 2; push_cast; ring

end elements

/-! ## The orbitals -/

section orbitals
variable (ω : ∀ i, (K i)ˣ) (U : Subgroup (∀ j, (ZMod (r j))ˣ)) {N : ℕ} (hN : ∀ i, ω i ^ N = 1)
  (hinj : Function.Injective r) (hco : ∀ j, (((∏ i, F i) * N : ℕ) : ZMod (r j)) ≠ 0)
  (hω : ∀ i (a : (K i)ˣ), a ∈ Subgroup.zpowers (ω i))

theorem map_mem {g : Perm (Pt F K r)} (hg : g ∈ G (F := F) (K := K) ω U) (e : Sym2 (Pt F K r)) :
    Sym2.map g e ∈ D2.orbit2 (G (F := F) (K := K) ω U) e := by
  unfold D2.orbit2
  rw [Finset.mem_image]
  exact ⟨g, by simp only [Finset.mem_filter, Finset.mem_univ, true_and]; exact hg, rfl⟩

include hN hinj hco hω in
/-- **Within-block pairs of class i: one orbital of size Fᵢ·C(cᵢ,2).** -/
theorem orbit_KK (i : Fin m) (a : ZMod (F i)) {x y : K i} (hxy : x ≠ y) :
    F i * (Fintype.card (K i)).choose 2 ≤
      (D2.orbit2 (G (F := F) (K := K) ω U) s(Sum.inl ⟨i, a, x⟩, Sum.inl ⟨i, a, y⟩)).card := by
  set T0 : Finset (Sym2 (K i)) := (Finset.univ.offDiag).image Sym2.mk.uncurry
  have hT : T0.card = (Fintype.card (K i)).choose 2 := Sym2.card_image_offDiag _
  set S : Finset (Sym2 (Pt F K r)) := ((Finset.univ : Finset (ZMod (F i))) ×ˢ T0).image
    (fun w => Sym2.map (fun v => (Sum.inl ⟨i, w.1, v⟩ : Pt F K r)) w.2)
  have hS : S.card = F i * (Fintype.card (K i)).choose 2 := by
    rw [Finset.card_image_of_injective, Finset.card_product, hT, Finset.card_univ, ZMod.card]
    rintro ⟨i1, e1⟩ ⟨i2, e2⟩ h
    induction e1 using Sym2.ind with
    | h a1 b1 =>
    induction e2 using Sym2.ind with
    | h a2 b2 =>
    simp only [Sym2.map_mk, Sym2.eq_iff, Sum.inl.injEq, Sigma.mk.injEq, heq_eq_eq, true_and,
      Prod.mk.injEq] at h
    rcases h with ⟨⟨h1, h2⟩, -, h3⟩ | ⟨⟨h1, h2⟩, -, h3⟩
    · subst h1 h2 h3; rfl
    · subst h1 h2 h3; simp [Sym2.eq_swap]
  rw [← hS]
  apply Finset.card_le_card
  intro f hf
  simp only [S, T0, Finset.mem_image, Finset.mem_product, Finset.mem_univ, true_and,
    Finset.mem_offDiag, Prod.exists] at hf
  obtain ⟨a', g, ⟨x', y', hne, rfl⟩, rfl⟩ := hf
  have hd : y - x ≠ 0 := sub_ne_zero.mpr (Ne.symm hxy)
  set α : K i := (y' - x') / (y - x)
  have hα : α ≠ 0 := div_ne_zero (sub_ne_zero.mpr (Ne.symm hne)) hd
  obtain ⟨g, hg, hgl, -⟩ := block_map ω U hN hinj hco hω i a a' (Units.mk0 α hα) (x' - α * x)
  have := map_mem ω U hg s(Sum.inl ⟨i, a, x⟩, Sum.inl ⟨i, a, y⟩)
  convert this using 1
  simp only [Function.uncurry_apply_pair, Sym2.map_mk, hgl, Units.val_mk0]
  have e1 : α * x + (x' - α * x) = x' := by ring
  have e2 : α * y + (x' - α * x) = y' := by
    have : α * (y - x) = y' - x' := by simp only [α]; field_simp
    linear_combination this
  rw [e1, e2]

include hN hinj hco hω in
/-- **Class i – ℤ/rⱼ pairs: one orbital of size Fᵢ·cᵢ·rⱼ.** -/
theorem orbit_KR (i : Fin m) (a : ZMod (F i)) (x : K i) (j : Fin k) (z : ZMod (r j)) :
    F i * Fintype.card (K i) * r j ≤
      (D2.orbit2 (G (F := F) (K := K) ω U) s(Sum.inl ⟨i, a, x⟩, Sum.inr ⟨j, z⟩)).card := by
  set S : Finset (Sym2 (Pt F K r)) :=
    (Finset.univ : Finset ((ZMod (F i) × K i) × ZMod (r j))).image
      (fun w => s(Sum.inl ⟨i, w.1⟩, Sum.inr ⟨j, w.2⟩))
  have hS : S.card = F i * Fintype.card (K i) * r j := by
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
  obtain ⟨⟨⟨a', x'⟩, z'⟩, rfl⟩ := hf
  obtain ⟨g, hg, hgl, hgr⟩ := block_map ω U hN hinj hco hω i a a' 1 (x' - x)
  have hm := map_mem ω U (Subgroup.mul_mem _ (ρ_memG ω U hN hinj hco (Pi.single j (z' - z))) hg)
    s(Sum.inl ⟨i, a, x⟩, Sum.inr ⟨j, z⟩)
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

/-- **Pairs across two blocks of class i: orbitals of size ≥ K0·cᵢ².** -/
theorem orbit_cross (i : Fin m) [Fact (1 < F i)] {a1 a2 : ZMod (F i)} (hij : a1 ≠ a2) (x y : K i) :
    PartEF.K0 (F i) * Fintype.card (K i) * Fintype.card (K i) ≤
      (D2.orbit2 (G (F := F) (K := K) ω U) s(Sum.inl ⟨i, a1, x⟩, Sum.inl ⟨i, a2, y⟩)).card := by
  set S : Finset (Sym2 (Pt F K r)) :=
    (Finset.range (PartEF.K0 (F i)) ×ˢ (Finset.univ : Finset (K i × K i))).image
      (fun w => s(Sum.inl ⟨i, a1 + (w.1 : ZMod (F i)), w.2.1⟩, Sum.inl ⟨i, a2 + (w.1 : ZMod (F i)), w.2.2⟩))
  have hval : ∀ n : ℕ, n < PartEF.K0 (F i) → ((n : ZMod (F i))).val = n := fun n hn => by
    rw [ZMod.val_natCast, Nat.mod_eq_of_lt (lt_of_lt_of_le hn PartEF.K0_le)]
  have hS : S.card = PartEF.K0 (F i) * Fintype.card (K i) * Fintype.card (K i) := by
    rw [Finset.card_image_of_injOn, Finset.card_product, Finset.card_range, Finset.card_univ,
      Fintype.card_prod, mul_assoc]
    rintro ⟨n, a, b⟩ hw ⟨n', a', b'⟩ hw' h
    simp only [Finset.coe_product, Set.mem_prod, Finset.coe_range, Set.mem_Iio] at hw hw'
    simp only [Sym2.eq_iff, Sum.inl.injEq, Sigma.mk.injEq, heq_eq_eq, true_and,
      Prod.mk.injEq] at h
    rcases h with ⟨⟨h1, h2⟩, h3, h4⟩ | ⟨⟨h1, h2⟩, h3, h4⟩
    · have : (n : ZMod (F i)) = n' := by linear_combination h1
      have hnn : n = n' := by rw [← hval n hw.1, ← hval n' hw'.1, this]
      subst hnn h2 h4; rfl
    · exfalso
      have h5 : (2 : ZMod (F i)) * ((n' : ZMod (F i)) - n) = 0 := by linear_combination -h1 - h3
      have hnn := PartEF.no_swap hw.1 hw'.1 h5
      subst hnn
      exact hij (by linear_combination h1)
  rw [← hS]
  apply Finset.card_le_card
  intro f hf
  simp only [S, Finset.mem_image, Finset.mem_product, Finset.mem_range, Finset.mem_univ,
    and_true] at hf
  obtain ⟨⟨n, x', y'⟩, -, rfl⟩ := hf
  have hne : a1 + (n : ZMod (F i)) ≠ a2 + n := fun h => hij (by linear_combination h)
  set e1 := (a1.val + n) / F i
  set e2 := (a2.val + n) / F i
  let t : Multiplicative (∀ i, ZMod (F i) → K i) := Multiplicative.ofAdd (Pi.single i (fun l =>
    if l = a1 + n then x' - ((ω i ^ e1 : (K i)ˣ) : K i) * x else y' - ((ω i ^ e2 : (K i)ˣ) : K i) * y))
  have hm := map_mem ω U (Subgroup.mul_mem _ (trHom_mem ω U t) (γpow_mem ω U n))
    s(Sum.inl ⟨i, a1, x⟩, Sum.inl ⟨i, a2, y⟩)
  convert hm using 1
  have q1 : ((ω i ^ e1 : (K i)ˣ) : K i) * x + (x' - ((ω i ^ e1 : (K i)ˣ) : K i) * x) = x' := by ring
  have q2 : ((ω i ^ e2 : (K i)ˣ) : K i) * y + (y' - ((ω i ^ e2 : (K i)ˣ) : K i) * y) = y' := by ring
  have hne' : (a2 + (n : ZMod (F i)) = a1 + n) = False := eq_false (Ne.symm hne)
  simp only [Sym2.map_mk, Perm.mul_apply, γ_pow_inl, zc_pow, trHom_inl, t, toAdd_ofAdd,
    Pi.single_eq_same, hne', ↓reduceIte]
  rw [q1, q2]

/-- **Class i – class i' pairs (i ≠ i'): orbitals of size ≥ Fᵢ·cᵢ·cᵢ'.**  The common rotation γ
moves the two classes together, so this is not Fᵢcᵢ·Fᵢ'cᵢ' when the block counts share a
factor; it is always at least one of the two classes' intra terms (`cfgM_refined_le`). -/
theorem orbit_CC {i i' : Fin m} (hii : i ≠ i') (a : ZMod (F i)) (a' : ZMod (F i')) (x : K i)
    (y : K i') :
    F i * Fintype.card (K i) * Fintype.card (K i') ≤
      (D2.orbit2 (G (F := F) (K := K) ω U) s(Sum.inl ⟨i, a, x⟩, Sum.inl ⟨i', a', y⟩)).card := by
  set S : Finset (Sym2 (Pt F K r)) :=
    (Finset.range (F i) ×ˢ (Finset.univ : Finset (K i × K i'))).image
      (fun w => s(Sum.inl ⟨i, a + (w.1 : ZMod (F i)), w.2.1⟩,
        Sum.inl ⟨i', a' + (w.1 : ZMod (F i')), w.2.2⟩))
  have hval : ∀ n : ℕ, n < F i → ((n : ZMod (F i))).val = n := fun n hn => by
    rw [ZMod.val_natCast, Nat.mod_eq_of_lt hn]
  have hS : S.card = F i * Fintype.card (K i) * Fintype.card (K i') := by
    rw [Finset.card_image_of_injOn, Finset.card_product, Finset.card_range, Finset.card_univ,
      Fintype.card_prod, mul_assoc]
    rintro ⟨n, b, c⟩ hw ⟨n', b', c'⟩ hw' h
    simp only [Finset.coe_product, Set.mem_prod, Finset.coe_range, Set.mem_Iio] at hw hw'
    simp only [Sym2.eq_iff, Sum.inl.injEq, Sigma.mk.injEq] at h
    rcases h with ⟨⟨-, h1⟩, ⟨-, h2⟩⟩ | ⟨⟨h1, -⟩, -⟩
    · simp only [heq_eq_eq, Prod.mk.injEq] at h1 h2
      have : (n : ZMod (F i)) = n' := by linear_combination h1.1
      have hnn : n = n' := by rw [← hval n hw.1, ← hval n' hw'.1, this]
      rw [hnn, h1.2, h2.2]
    · exact absurd h1 hii
  rw [← hS]
  apply Finset.card_le_card
  intro f hf
  simp only [S, Finset.mem_image, Finset.mem_product, Finset.mem_range, Finset.mem_univ,
    and_true] at hf
  obtain ⟨⟨n, x', y'⟩, -, rfl⟩ := hf
  let t : Multiplicative (∀ i, ZMod (F i) → K i) := Multiplicative.ofAdd
    (Pi.single i (fun _ => x' - ((ω i ^ ((a.val + n) / F i) : (K i)ˣ) : K i) * x) +
      Pi.single i' (fun _ => y' - ((ω i' ^ ((a'.val + n) / F i') : (K i')ˣ) : K i') * y))
  have hm := map_mem ω U (Subgroup.mul_mem _ (trHom_mem ω U t) (γpow_mem ω U n))
    s(Sum.inl ⟨i, a, x⟩, Sum.inl ⟨i', a', y⟩)
  convert hm using 1
  simp only [Sym2.map_mk, Perm.mul_apply, γ_pow_inl, zc_pow, trHom_inl, t, toAdd_ofAdd,
    Pi.add_apply, Pi.single_eq_same, Pi.single_eq_of_ne hii, Pi.single_eq_of_ne hii.symm,
    Pi.zero_apply, add_zero, zero_add]
  congr 3 <;> ring

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

/-- The configuration realised: classes (Fᵢ, p^bᵢ) at full twist, and foreign blocks (rⱼ, tⱼ). -/
def cfgM (p q : ℕ) (F b : Fin m → ℕ) {k : ℕ} (r t : Fin k → ℕ) : Config :=
  ⟨p, q, List.ofFn (fun i => CPart.pc (F i) (p ^ b i) (p ^ b i - 1)) ++
    List.ofFn (fun j => CPart.fr (r j) (t j))⟩

theorem cfgM_sizes (p q : ℕ) (F b : Fin m → ℕ) {k : ℕ} (r t : Fin k → ℕ) :
    (cfgM p q F b r t).sizes = List.ofFn (fun i => F i * p ^ b i) ++ List.ofFn r := by
  simp [cfgM, Config.sizes, CPart.sizeC, List.map_ofFn, Function.comp_def]

theorem cfgM_n (p q : ℕ) (F b : Fin m → ℕ) {k : ℕ} (r t : Fin k → ℕ) :
    (cfgM p q F b r t).n = ∑ i, F i * p ^ b i + ∑ j, r j := by
  simp [Config.n, cfgM_sizes, List.sum_ofFn]

/-- Two parts' product is a term, by position. -/
theorem cross_mem (xs ys : List ℕ) {i l : ℕ} (hil : i ≠ l) (hi : i < (xs ++ ys).length)
    (hl : l < (xs ++ ys).length) : (xs ++ ys)[i] * (xs ++ ys)[l] ∈ crossN (xs ++ ys) := by
  rcases lt_or_gt_of_ne hil with h | h
  · exact crossN_mem _ h hl
  · rw [Nat.mul_comm]; exact crossN_mem _ h hi


/-- **Part E for any number of classes beside any foreign blocks.**  Classes of Fᵢ ≥ 1 blocks of
𝔽_{cᵢ} (cᵢ = |Kᵢ| = p^bᵢ) at full twist, and foreign blocks of distinct primes rⱼ with q-power
twists tⱼ ∣ rⱼ − 1, coherent (no rⱼ divides Fᵢ·(cᵢ − 1)): the group G = ⟨T, γ, μ(U)⟩ carries an
Oliver chain (p, q), and every orbital on unordered pairs has size at least REFINED of the
configuration. -/
theorem partE_M (p q : ℕ) (b : Fin m → ℕ) [Fact p.Prime] [∀ i, CharP (K i) p]
    (hK : ∀ i, Fintype.card (K i) = p ^ b i) (t : Fin k → ℕ)
    (ht : ∀ j, t j ∣ r j - 1 ∧ ∃ f, t j = q ^ f) (hinj : Function.Injective r)
    (hcoh : ∀ j i, ¬ r j ∣ F i * (p ^ b i - 1)) :
    ∃ (ω : ∀ i, (K i)ˣ) (U : Subgroup (∀ j, (ZMod (r j))ˣ)),
      Nonempty (Chain.OliverChain (G (F := F) (K := K) (r := r) ω U) p q) ∧
      ∀ e : Sym2 (Pt F K r), ¬ e.IsDiag →
        (cfgM p q F b r t).refined ≤ (D2.orbit2 (G (F := F) (K := K) ω U) e).card := by
  classical
  have hgen : ∀ i, ∃ w : (K i)ˣ, ∀ a, a ∈ Subgroup.zpowers w := fun i => IsCyclic.exists_generator
  choose ω hω using hgen
  set N := ∏ i, (p ^ b i - 1)
  have hord : ∀ i, orderOf (ω i) = p ^ b i - 1 := fun i => by
    rw [orderOf_eq_card_of_forall_mem_zpowers (hω i), Nat.card_eq_fintype_card, Fintype.card_units,
      hK]
  have hN : ∀ i, ω i ^ N = 1 := fun i => by
    obtain ⟨a, ha⟩ : p ^ b i - 1 ∣ N := Finset.dvd_prod_of_mem _ (Finset.mem_univ i)
    rw [ha, pow_mul, ← hord, pow_orderOf_eq_one, one_pow]
  have hco : ∀ j, (((∏ i, F i) * N : ℕ) : ZMod (r j)) ≠ 0 := by
    intro j h
    rw [ZMod.natCast_eq_zero_iff, ← Finset.prod_mul_distrib] at h
    obtain ⟨i, -, hi⟩ := (Prime.dvd_finsetProd_iff (Nat.prime_iff.mp Fact.out) _).mp h
    exact hcoh j i hi
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
  have hU : ∀ u ∈ U, ∃ e : ℕ, u ^ q ^ e = 1 := by
    intro u hu
    refine ⟨∑ j, f j, ?_⟩
    funext j
    have hj := (Subgroup.mem_pi _).mp hu j (Set.mem_univ _)
    obtain ⟨z, hz⟩ := Subgroup.mem_zpowers_iff.mp hj
    have h1 : (g j) ^ (q ^ f j) = 1 := by rw [← hf j, ← hgo j]; exact pow_orderOf_eq_one _
    have hdvd : q ^ f j ∣ q ^ ∑ j, f j :=
      pow_dvd_pow q (Finset.single_le_sum (fun _ _ => Nat.zero_le _) (Finset.mem_univ j))
    obtain ⟨e, he⟩ := hdvd
    simp only [Pi.pow_apply, Pi.one_apply]
    rw [← hz, ← zpow_natCast, ← zpow_mul, mul_comm, zpow_mul, zpow_natCast, he, pow_mul, h1,
      one_pow, one_zpow]
  refine ⟨ω, U, ⟨chain ω U p q hN hinj hco hU⟩, fun e he => ?_⟩
  have hcardW : ∀ j, Fintype.card (W j) = t j := fun j => by
    rw [Fintype.card_zpowers, hgo j]
  -- the terms of the configuration
  set C := cfgM p q F b r t
  have hpc : ∀ i, F i * pairs (p ^ b i) ∈
      C.parts.flatMap (CPart.refinedTerms (decide (C.p = 2))) ++ crossN C.sizes := by
    intro i
    apply List.mem_append_left
    apply List.mem_flatMap.mpr
    refine ⟨.pc (F i) (p ^ b i) (p ^ b i - 1), List.mem_append_left _ (List.mem_ofFn.mpr ⟨i, rfl⟩), ?_⟩
    simp [CPart.refinedTerms, orb_full]
  have hsz := cfgM_sizes p q F b r t
  set xs := List.ofFn (fun i => F i * p ^ b i)
  set ys := List.ofFn r
  have hxs : ∀ i : Fin m, (xs ++ ys)[i.val]'(by simp [xs]; omega) = F i * p ^ b i := by
    intro i; simp [xs, List.getElem_append_left]
  have hys : ∀ j : Fin k, (xs ++ ys)[m + j.val]'(by simp [xs, ys]) = r j := by
    intro j; simp [xs, ys, List.getElem_append_right]
  have hcross : ∀ (u v : ℕ) (hu : u < (xs ++ ys).length) (hv : v < (xs ++ ys).length), u ≠ v →
      (xs ++ ys)[u] * (xs ++ ys)[v] ∈ C.parts.flatMap (CPart.refinedTerms (decide (C.p = 2))) ++
        crossN C.sizes := fun u v hu hv huv =>
    List.mem_append_right _ (by rw [hsz]; exact cross_mem xs ys huv hu hv)
  induction e using Sym2.ind with
  | h x y =>
    rw [Sym2.mk_isDiag_iff] at he
    rcases x with ⟨i, a, x⟩ | ⟨j, z⟩ <;> rcases y with ⟨i2, a2, y⟩ | ⟨l, w⟩
    · by_cases hii : i = i2
      · subst hii
        by_cases haa : a = a2
        · subst haa
          have hxy : x ≠ y := fun h => he (by rw [h])
          have := orbit_KK ω U hN hinj hco hω i a hxy
          rw [hK, ← Ark.pairs_eq_choose] at this
          exact le_trans (minL_le (hpc i)) this
        · have hF : 1 < F i := by
            by_contra h
            have : F i = 1 := by have := NeZero.ne (F i); omega
            have : Subsingleton (ZMod (F i)) := by rw [this]; infer_instance
            exact haa (Subsingleton.elim _ _)
          have : Fact (1 < F i) := ⟨hF⟩
          have := orbit_cross ω U i haa x y
          rw [hK] at this
          refine le_trans (minL_le ?_) this
          apply List.mem_append_left
          apply List.mem_flatMap.mpr
          refine ⟨.pc (F i) (p ^ b i) (p ^ b i - 1),
            List.mem_append_left _ (List.mem_ofFn.mpr ⟨i, rfl⟩), ?_⟩
          simp [CPart.refinedTerms, show 2 ≤ F i by omega, PartEF.K0]
      · -- two classes: at least the smaller-block class's intra term
        rcases le_total (p ^ b i) (p ^ b i2) with hc | hc
        · have := orbit_CC ω U hii a a2 x y
          rw [hK, hK] at this
          refine le_trans (minL_le (hpc i)) (le_trans ?_ this)
          rw [mul_assoc]
          apply Nat.mul_le_mul_left
          unfold pairs
          calc p ^ b i * (p ^ b i - 1) / 2 ≤ p ^ b i * (p ^ b i - 1) := Nat.div_le_self _ _
            _ ≤ p ^ b i * p ^ b i2 := Nat.mul_le_mul_left _ (by omega)
        · rw [Sym2.eq_swap]
          have := orbit_CC ω U (Ne.symm hii) a2 a y x
          rw [hK, hK] at this
          refine le_trans (minL_le (hpc i2)) (le_trans ?_ this)
          rw [mul_assoc]
          apply Nat.mul_le_mul_left
          unfold pairs
          calc p ^ b i2 * (p ^ b i2 - 1) / 2 ≤ p ^ b i2 * (p ^ b i2 - 1) := Nat.div_le_self _ _
            _ ≤ p ^ b i2 * p ^ b i := Nat.mul_le_mul_left _ (by omega)
    · have := orbit_KR ω U hN hinj hco hω i a x l w
      rw [hK] at this
      refine le_trans (minL_le ?_) this
      have h := hcross i.val (m + l.val) (by simp [xs, ys]; omega) (by simp [xs, ys])
        (by omega)
      rwa [hxs, hys] at h
    · rw [Sym2.eq_swap]
      have := orbit_KR ω U hN hinj hco hω i2 a2 y j z
      rw [hK] at this
      refine le_trans (minL_le ?_) this
      have h := hcross i2.val (m + j.val) (by simp [xs, ys]; omega) (by simp [xs, ys])
        (by omega)
      rwa [hxs, hys] at h
    · by_cases hjl : j = l
      · subst hjl
        have hzw : z ≠ w := fun h => he (by rw [h])
        have := orbit_RR ω U hN hinj hco j (W j) (hW j) hzw
        rw [hcardW] at this
        refine le_trans (minL_le ?_) this
        apply List.mem_append_left
        apply List.mem_flatMap.mpr
        exact ⟨.fr (r j) (t j), List.mem_append_right _ (List.mem_ofFn.mpr ⟨j, rfl⟩),
          by simp [CPart.refinedTerms]⟩
      · have := orbit_RR' ω U hN hinj hco hjl z w
        refine le_trans (minL_le ?_) this
        have h := hcross (m + j.val) (m + l.val) (by simp [xs, ys]) (by simp [xs, ys])
          (fun h => hjl (Fin.ext (by omega)))
        rwa [hys, hys] at h

/-- **Packaged with `GaloisField p bᵢ`**: an Oliver group on Σ Fᵢcᵢ + Σ rⱼ points all of whose
pair-orbitals are at least REFINED of the configuration. -/
theorem partE_M_exists (p q : ℕ) (b : Fin m → ℕ) [Fact p.Prime] (hb : ∀ i, b i ≠ 0)
    (t : Fin k → ℕ) (ht : ∀ j, t j ∣ r j - 1 ∧ ∃ f, t j = q ^ f) (hinj : Function.Injective r)
    (hcoh : ∀ j i, ¬ r j ∣ F i * (p ^ b i - 1)) :
    ∃ (X : Type) (_ : Fintype X) (_ : DecidableEq X) (G : Subgroup (Perm X)),
      Fintype.card X = (cfgM p q F b r t).n ∧ Nonempty (Chain.OliverChain G p q) ∧
      ∀ e : Sym2 X, ¬ e.IsDiag → (cfgM p q F b r t).refined ≤ (D2.orbit2 G e).card := by
  classical
  let K : Fin m → Type := fun i => GaloisField p (b i)
  let _ : ∀ i, Fintype (K i) := fun i => Fintype.ofFinite _
  have hK : ∀ i, Fintype.card (K i) = p ^ b i := fun i => by
    rw [← Nat.card_eq_fintype_card]; exact GaloisField.card p (b i) (hb i)
  obtain ⟨ω, U, hch, horb⟩ := partE_M (F := F) (K := K) (r := r) p q b hK t ht hinj hcoh
  refine ⟨Pt F K r, inferInstance, inferInstance, G (F := F) (K := K) ω U, ?_, hch, ?_⟩
  · rw [cfgM_n, Fintype.card_sum, Fintype.card_sigma, Fintype.card_sigma]
    simp [ZMod.card, hK]
  · intro e he
    convert horb e he using 2

end PartEG

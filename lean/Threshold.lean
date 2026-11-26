/-
# `Threshold.lean` — beyond μ\*: a foreign block of good index counts at C(r,2)
-/
import RGlue

set_option linter.unusedSectionVars false

namespace Threshold
open Finset Equiv Classical

/-- The order-q subgroup of a cyclic group is exactly the solutions of x^q = 1. -/
theorem zpowers_eq_pow {r : ℕ} [Fact r.Prime] {g : (ZMod r)ˣ} {q : ℕ} (hq : 0 < q) (hg : orderOf g = q)
    (x : (ZMod r)ˣ) : x ∈ Subgroup.zpowers g ↔ x ^ q = 1 := by
  constructor
  · intro hx
    obtain ⟨m, rfl⟩ := Subgroup.mem_zpowers_iff.mp hx
    rw [← zpow_natCast, ← zpow_mul, mul_comm, zpow_mul, zpow_natCast, ← hg, pow_orderOf_eq_one, one_zpow]
  · intro hx
    set S := (univ : Finset (ZMod r)ˣ).filter (fun y => y ^ q = 1)
    set Z := (univ : Finset (ZMod r)ˣ).filter (fun y => y ∈ Subgroup.zpowers g)
    have hZS : Z ⊆ S := by
      intro y hy
      simp only [Z, S, mem_filter, mem_univ, true_and] at hy ⊢
      obtain ⟨m, rfl⟩ := Subgroup.mem_zpowers_iff.mp hy
      rw [← zpow_natCast, ← zpow_mul, mul_comm, zpow_mul, zpow_natCast, ← hg, pow_orderOf_eq_one, one_zpow]
    have hS : S.card ≤ q := IsCyclic.card_pow_eq_one_le hq
    have hZ : Z.card = q := by
      rw [← hg, ← Nat.card_zpowers, Nat.card_eq_fintype_card, Fintype.card_subtype]
    have := eq_of_subset_of_card_le hZS (by omega)
    have hxS : x ∈ S := by simp [S, hx]
    rw [← this] at hxS
    simpa [Z] using hxS

/-! ## The fused-class group has the ℤ/r shape -/

section fused
variable {F : ℕ} [Fact (1 < F)] {K : Type*} [Field K] [Fintype K] [DecidableEq K] {r : ℕ} [Fact r.Prime]

theorem mulR_eq_μ (w : (ZMod r)ˣ) : RGlue.mulR (A := ZMod F × K) w = PartEF.μ w := rfl

theorem shapeF (ω : Kˣ) (U : Subgroup (ZMod r)ˣ) {N : ℕ} (hN : ω ^ N = 1)
    (hco : ((F * N : ℕ) : ZMod r) ≠ 0) (w : (ZMod r)ˣ) :
    RGlue.Shape (PartEF.G (F := F) (K := K) (r := r) ω U) U w := by
  have conj : ∀ u : (ZMod r)ˣ, ∀ g ∈ PartEF.G (F := F) (K := K) (r := r) ω U,
      PartEF.μ u * g * (PartEF.μ u)⁻¹ ∈ PartEF.G (F := F) (K := K) ω U := by
    intro u g hg
    induction hg using Subgroup.closure_induction with
    | mem x hx =>
      rcases hx with (hx | rfl) | ⟨v, hv, rfl⟩
      · obtain ⟨t, rfl⟩ := hx; rw [PartEF.μ_conj_tr]; exact PartEF.trHom_mem ω U t
      · rw [PartEF.μ_conj_γ]
        exact Subgroup.mul_mem _ (PartEF.N1_le_G ω U (PartEF.γ_mem_N1 ω)) (PartEF.ρ_memG ω U hN hco _)
      · have : PartEF.μ (F := F) (K := K) u * PartEF.μ v * (PartEF.μ u)⁻¹ = PartEF.μ v := by
          rw [← PartEF.μ_inv, ← PartEF.μ_mul, ← PartEF.μ_mul, mul_comm u v, mul_assoc, mul_inv_cancel,
            mul_one]
        rw [this]; exact PartEF.μ_mem_G ω hv
    | one => simp
    | mul x y _ _ hx hy =>
      have : PartEF.μ u * (x * y) * (PartEF.μ u)⁻¹ =
          (PartEF.μ u * x * (PartEF.μ u)⁻¹) * (PartEF.μ u * y * (PartEF.μ u)⁻¹) := by group
      rw [this]; exact Subgroup.mul_mem _ hx hy
    | inv x _ hx =>
      have : PartEF.μ u * x⁻¹ * (PartEF.μ u)⁻¹ = (PartEF.μ u * x * (PartEF.μ u)⁻¹)⁻¹ := by group
      rw [this]; exact Subgroup.inv_mem _ hx
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro g hg
    induction hg using Subgroup.closure_induction with
    | mem x hx =>
      rcases hx with (hx | rfl) | ⟨v, hv, rfl⟩
      · obtain ⟨t, rfl⟩ := hx
        exact ⟨1, U.one_mem, 0, fun z => by simp [PartEF.trHom_inr]⟩
      · exact ⟨1, U.one_mem, 1, fun z => by
          have := PartEF.γ_pow_inr (F := F) (K := K) (r := r) ω 1 z
          simpa using this⟩
      · exact ⟨v, hv, 0, fun z => by simp [PartEF.μ]⟩
    | one => exact ⟨1, U.one_mem, 0, fun z => by simp⟩
    | mul x y _ _ hx hy =>
      obtain ⟨u1, hu1, v1, h1⟩ := hx
      obtain ⟨u2, hu2, v2, h2⟩ := hy
      refine ⟨u1 * u2, U.mul_mem hu1 hu2, (u1 : ZMod r) * v2 + v1, fun z => ?_⟩
      rw [Perm.mul_apply, h2, h1]; congr 1; push_cast; ring
    | inv x _ hx =>
      obtain ⟨u, hu, v, h⟩ := hx
      refine ⟨u⁻¹, U.inv_mem hu, -(((u⁻¹ : (ZMod r)ˣ) : ZMod r) * v), fun z => ?_⟩
      rw [Perm.inv_eq_iff_eq, h]; congr 1
      have : ((u : ZMod r)) * ((u⁻¹ : (ZMod r)ˣ) : ZMod r) = 1 := Units.mul_inv u
      linear_combination -(z - v) * this
  · intro u hu v
    refine ⟨PartEF.ρ v * PartEF.μ u, Subgroup.mul_mem _ (PartEF.ρ_memG ω U hN hco v) (PartEF.μ_mem_G ω hu),
      fun z => ?_⟩
    simp [PartEF.ρ, PartEF.μ]
  · intro g hg; rw [mulR_eq_μ]; exact conj w g hg
  · intro g hg
    rw [mulR_eq_μ, ← PartEF.μ_inv]
    have := conj w⁻¹ g hg
    rwa [← PartEF.μ_inv, inv_inv] at this

end fused

/-! ## The threshold Proposition for a fused class beside a foreign block of good index -/

section thrF
variable {F : ℕ} [Fact (1 < F)] {K : Type*} [Field K] [Fintype K] [DecidableEq K] {r : ℕ} [Fact r.Prime]

open ArkCore in
/-- **Beyond μ\* for a fused class (F ≥ 2).**  With r − 1 = 2qk, q an odd prime and k good for q,
the Part E group on F blocks of 𝔽_c ⊔ ℤ/r is an Oliver group under which, given the KSS–Oliver
input, **every property with e_max < min(F·C(c,2), F·c·r, C(r,2)) is evasive** — the foreign
block counts at C(r,2) instead of r·q. -/
theorem thr_F (p q b k : ℕ) [Fact p.Prime] [CharP K p] [NeZero k]
    (hK : Fintype.card K = p ^ b) (hq : q.Prime) (hqo : q % 2 = 1) (hk : r - 1 = 2 * q * k)
    (hco : ¬ r ∣ p ^ b - 1) (hrF : ¬ r ∣ F) (hgood : CycGood.Good k q)
    (Ev : Evasive.DownProp (PartEF.Pt F K r) → Prop) (H : Evasive.HypKSSOliver Ev)
    (P : Evasive.DownProp (PartEF.Pt F K r))
    (hP : Evasive.EmaxLt P (min (F * pairs (p ^ b)) (min (F * p ^ b * r) (pairs r)))) : Ev P := by
  have : Fact q.Prime := ⟨hq⟩
  have hqr : q ∣ r - 1 := ⟨2 * k, by rw [hk]; ring⟩
  have hcard : q ∣ Fintype.card (ZMod r)ˣ := by rw [ZMod.card_units]; exact hqr
  obtain ⟨g, hg⟩ := exists_prime_orderOf_dvd_card q hcard
  set U := Subgroup.zpowers g
  have hUq : ∀ x, x ∈ U ↔ x ^ q = 1 := zpowers_eq_pow hq.pos hg
  have hU : ∀ u ∈ U, u ^ q = 1 := fun u hu => (hUq u).mp hu
  obtain ⟨ω, hω⟩ := IsCyclic.exists_generator (α := Kˣ)
  have hN : ω ^ (p ^ b - 1) = 1 := by
    have : orderOf ω = p ^ b - 1 := by
      rw [orderOf_eq_card_of_forall_mem_zpowers hω, Nat.card_eq_fintype_card, Fintype.card_units, hK]
    rw [← this]; exact pow_orderOf_eq_one ω
  have hcoF : ((F * (p ^ b - 1) : ℕ) : ZMod r) ≠ 0 := by
    rw [Ne, ZMod.natCast_eq_zero_iff]
    intro h
    rcases (Nat.Prime.dvd_mul Fact.out).mp h with h | h
    · exact hrF h
    · exact hco h
  obtain ⟨w, hw⟩ := IsCyclic.exists_generator (α := (ZMod r)ˣ)
  have hS := shapeF (F := F) (K := K) ω U hN hcoF w
  set G := PartEF.G (F := F) (K := K) (r := r) ω U
  have hch : Nonempty (Chain.OliverChain G p q) := ⟨PartEF.chain ω U p q hN hcoF hU⟩
  set M := min (F * pairs (p ^ b)) (min (F * p ^ b * r) (pairs r))
  refine Evasive.evasive_of_good_type Ev H G (Fact.out : p.Prime) hq hch (RGlue.O G w k)
    (RGlue.O_injective hS hUq hqo hw hk) (fun j => RGlue.O_mem j) (RGlue.mulR w)
    (RGlue.O_shift hS hUq hqo hw hk) ?_ ?_ hgood P hP
  · -- every other orbital is large
    intro o ho hne
    obtain ⟨e, he, rfl⟩ := mem_image.mp ho
    simp only [mem_filter, mem_univ, true_and] at he
    induction e using Sym2.ind with
    | h x y =>
      rw [Sym2.mk_isDiag_iff] at he
      rcases x with ⟨i, x⟩ | z <;> rcases y with ⟨j, y⟩ | z'
      · by_cases hij : i = j
        · subst hij
          have hxy : x ≠ y := fun h => he (by rw [h])
          have := PartEF.orbit_KK ω U hN hcoF hω i hxy
          rw [hK, ← Ark.pairs_eq_choose] at this
          exact le_trans (min_le_left _ _) this
        · have h1 := PartEF.orbit_cross ω U hN hcoF hij x y
          have h2 := SigmaHalf.within_ge F (p ^ b)
          rw [hK] at h1
          have h3 : PartEF.K0 F * p ^ b * p ^ b = (if F % 2 = 1 then F else F / 2) * p ^ b * p ^ b := rfl
          exact le_trans (min_le_left _ _) (le_trans h2 (by rw [← h3]; exact h1))
      · have := PartEF.orbit_KR ω U hN hcoF hω i x z'
        rw [hK] at this
        exact le_trans (le_trans (min_le_right _ _) (min_le_left _ _)) this
      · rw [Sym2.eq_swap]
        have := PartEF.orbit_KR ω U hN hcoF hω j y z
        rw [hK] at this
        exact le_trans (le_trans (min_le_right _ _) (min_le_left _ _)) this
      · exfalso
        have hzz : z ≠ z' := fun h => he (by rw [h])
        obtain ⟨j, hj⟩ := RGlue.R_orbit_eq hS hUq hqo hw hk hzz
        exact hne j hj
  · -- the O_j hold C(r,2) ≥ M pairs
    have := RGlue.O_union_card hS hUq hqo hw hk
    rw [← Ark.pairs_eq_choose] at this
    exact le_trans (le_trans (min_le_right _ _) (min_le_right _ _)) this

end thrF

/-! ## The unfused case, F = 1 -/

section thr1
variable {K : Type*} [Field K] [Fintype K] [DecidableEq K] {r : ℕ} [Fact r.Prime]

theorem mulR_conj_Φ (w : (ZMod r)ˣ) (h : PartE1.Aff1 K × PartE1.Aff1 (ZMod r)) :
    RGlue.mulR (A := K) w * PartE1.Φ K (ZMod r) h * (RGlue.mulR w)⁻¹ =
      PartE1.Φ K (ZMod r) (h.1, ⟨h.2.a, (w : ZMod r) * h.2.s⟩) := by
  rw [mul_inv_eq_iff_eq_mul]
  ext (x | z)
  · simp [Perm.mul_apply, PartE1.Φ_inl]
  · simp [Perm.mul_apply, PartE1.Φ_inr]; ring

theorem mulR_inv (w : (ZMod r)ˣ) : (RGlue.mulR (A := K) w)⁻¹ = RGlue.mulR w⁻¹ := by
  rw [inv_eq_iff_mul_eq_one]
  ext (x | z)
  · rfl
  · rw [Perm.mul_apply, RGlue.mulR_inr, RGlue.mulR_inr, ← mul_assoc, ← Units.val_mul, mul_inv_cancel,
      Units.val_one, one_mul]; rfl

theorem shape1 (U : Subgroup (ZMod r)ˣ) (w : (ZMod r)ˣ) :
    RGlue.Shape (PartE1.G (K := K) U) U w := by
  have hconj : ∀ w' : (ZMod r)ˣ, ∀ g ∈ PartE1.G (K := K) U,
      RGlue.mulR w' * g * (RGlue.mulR w')⁻¹ ∈ PartE1.G (K := K) U := by
    rintro w' g ⟨h, hh, rfl⟩
    rw [mulR_conj_Φ]
    exact ⟨(h.1, ⟨h.2.a, (w' : ZMod r) * h.2.s⟩), hh, rfl⟩
  refine ⟨?_, ?_, hconj w, ?_⟩
  · rintro g ⟨h, hh, rfl⟩
    exact ⟨h.2.a, hh, h.2.s, fun z => rfl⟩
  · intro u hu v
    refine ⟨PartE1.Φ K (ZMod r) (1, ⟨u, v⟩), ⟨_, hu, rfl⟩, fun z => ?_⟩
    rw [PartE1.Φ_inr]
  · intro g hg
    have := hconj w⁻¹ g hg
    rwa [← mulR_inv, inv_inv] at this

open ArkCore in
/-- **Beyond μ\* for an unfused class (F = 1).** -/
theorem thr_1 (p q b k : ℕ) [Fact p.Prime] [CharP K p] [NeZero k]
    (hK : Fintype.card K = p ^ b) (hq : q.Prime) (hqo : q % 2 = 1) (hk : r - 1 = 2 * q * k)
    (hco : ¬ r ∣ p ^ b - 1) (hgood : CycGood.Good k q)
    (Ev : Evasive.DownProp (K ⊕ ZMod r) → Prop) (H : Evasive.HypKSSOliver Ev)
    (P : Evasive.DownProp (K ⊕ ZMod r))
    (hP : Evasive.EmaxLt P (min (1 * pairs (p ^ b)) (min (1 * p ^ b * r) (pairs r)))) : Ev P := by
  have : Fact q.Prime := ⟨hq⟩
  have hqr : q ∣ r - 1 := ⟨2 * k, by rw [hk]; ring⟩
  have hcard : q ∣ Fintype.card (ZMod r)ˣ := by rw [ZMod.card_units]; exact hqr
  obtain ⟨g, hg⟩ := exists_prime_orderOf_dvd_card q hcard
  set U := Subgroup.zpowers g
  have hUq : ∀ x, x ∈ U ↔ x ^ q = 1 := zpowers_eq_pow hq.pos hg
  have hU : ∀ u ∈ U, u ^ q = 1 := fun u hu => (hUq u).mp hu
  obtain ⟨ω, hω⟩ := IsCyclic.exists_generator (α := Kˣ)
  have hord : orderOf ω = p ^ b - 1 := by
    rw [orderOf_eq_card_of_forall_mem_zpowers hω, Nat.card_eq_fintype_card, Fintype.card_units, hK]
  have hcop : Nat.Coprime (orderOf ω) r := by
    rw [hord]; exact (Nat.Coprime.symm ((Nat.Prime.coprime_iff_not_dvd Fact.out).mpr hco))
  obtain ⟨w, hw⟩ := IsCyclic.exists_generator (α := (ZMod r)ˣ)
  have hS := shape1 (K := K) U w
  set G := PartE1.G (K := K) U
  have hch : Nonempty (Chain.OliverChain G p q) := ⟨PartE1.chainG p q r U hU ω hω hcop⟩
  refine Evasive.evasive_of_good_type Ev H G (Fact.out : p.Prime) hq hch (RGlue.O G w k)
    (RGlue.O_injective hS hUq hqo hw hk) (fun j => RGlue.O_mem j) (RGlue.mulR w)
    (RGlue.O_shift hS hUq hqo hw hk) ?_ ?_ hgood P hP
  · intro o ho hne
    obtain ⟨e, he, rfl⟩ := mem_image.mp ho
    simp only [mem_filter, mem_univ, true_and] at he
    induction e using Sym2.ind with
    | h x y =>
      rw [Sym2.mk_isDiag_iff] at he
      rcases x with x | z <;> rcases y with y | z'
      · have hxy : x ≠ y := fun h => he (by rw [h])
        have := PartE1.orbit_KK (r := r) U hxy
        rw [hK, ← Ark.pairs_eq_choose] at this
        exact le_trans (min_le_left _ _) (by simpa using this)
      · have := PartE1.orbit_KR (r := r) U x z'
        rw [hK] at this
        exact le_trans (le_trans (min_le_right _ _) (min_le_left _ _)) (by simpa using this)
      · rw [Sym2.eq_swap]
        have := PartE1.orbit_KR (r := r) U y z
        rw [hK] at this
        exact le_trans (le_trans (min_le_right _ _) (min_le_left _ _)) (by simpa using this)
      · exfalso
        have hzz : z ≠ z' := fun h => he (by rw [h])
        obtain ⟨j, hj⟩ := RGlue.R_orbit_eq hS hUq hqo hw hk hzz
        exact hne j hj
  · have := RGlue.O_union_card hS hUq hqo hw hk
    rw [← Ark.pairs_eq_choose] at this
    exact le_trans (le_trans (min_le_right _ _) (min_le_right _ _)) this

end thr1

/-! ## The arithmetic: η = 1 at the window -/

section arith
open SigmaHalf Sigma ArkCore

/-- **The η = 1 bound at one n.**  For a regular class specification with d = 2 (so η = 1), a
configuration n = F·c + r in the window has 2·min(F·C(c,2), F·c·r, C(r,2)) ≥ (target − κ/n)·n(n − 1). -/
theorem thr_bound (S : ClassSpec) (hS : S.Good) (hd2 : S.d = 2) {n c r : ℕ}
    (hn : n = S.F * c + r) (hlo : S.xlo * n ≤ (c : ℝ)) (hhi : (c : ℝ) ≤ S.xhi * n)
    (hx : 1 ≤ S.xlo * n) (hy : 1 ≤ S.ylo * n) :
    (S.tgt - S.kap / n) * (n * (n - 1)) ≤
      2 * ((min (S.F * pairs c) (min (S.F * c * r) (pairs r)) : ℕ) : ℝ) := by
  have hnpos : (0 : ℝ) < n := by
    rcases Nat.eq_zero_or_pos n with h | h
    · rw [h] at hx; simp at hx; linarith
    · exact_mod_cast h
  have hη : S.eta = 1 := by unfold ClassSpec.eta; rw [hd2]; norm_num
  obtain ⟨hi, hf⟩ := pointwise S.F c r n (η := S.eta) (by rw [hη]; norm_num) hn hlo hhi hx
    (by simpa [ClassSpec.ylo] using hy)
  have hylo : S.ylo = 1 - S.F * S.xhi := rfl
  have htgt0 : 0 ≤ S.tgt := by
    unfold ClassSpec.tgt target; apply le_min <;> positivity
  have hkap1 : S.F * S.xlo ≤ S.kap := le_max_left _ _
  have hkap2 : S.eta * S.ylo ≤ S.kap := le_max_right _ _
  have hk0 : 0 ≤ S.F * S.xlo := mul_nonneg (Nat.cast_nonneg _) hS.lo0
  have hnn : 0 ≤ (n : ℝ) * (n - 1) := by
    have : (1 : ℝ) ≤ n := by
      have h1 : 1 ≤ n := by
        rcases Nat.eq_zero_or_pos n with h | h
        · rw [h] at hx; simp at hx; linarith
        · exact h
      exact_mod_cast h1
    nlinarith
  have hB : S.tgt - S.kap / n ≤ S.F * S.xlo ^ 2 - S.F * S.xlo / n := by
    have : S.tgt ≤ S.F * S.xlo ^ 2 := min_le_left _ _
    have : S.F * S.xlo / n ≤ S.kap / n := div_le_div_of_nonneg_right hkap1 hnpos.le
    linarith
  have hB2 : S.tgt - S.kap / n ≤ S.eta * (1 - S.F * S.xhi) ^ 2 - S.eta * (1 - S.F * S.xhi) / n := by
    have : S.tgt ≤ S.eta * (1 - S.F * S.xhi) ^ 2 := min_le_right _ _
    have : S.eta * (1 - S.F * S.xhi) / n ≤ S.kap / n := div_le_div_of_nonneg_right hkap2 hnpos.le
    linarith
  -- three bounds
  have b1 : (S.tgt - S.kap / n) * (n * (n - 1)) ≤ 2 * ((S.F * pairs c : ℕ) : ℝ) := by
    have h2 := two_pairs c
    have e : 2 * ((S.F * pairs c : ℕ) : ℝ) = S.F * ((c : ℝ) * (c - 1)) := by
      have : 2 * (S.F * pairs c) = S.F * (c * (c - 1)) := by rw [← h2]; ring
      have h' : ((2 * (S.F * pairs c) : ℕ) : ℝ) = ((S.F * (c * (c - 1)) : ℕ) : ℝ) := by rw [this]
      push_cast at h' ⊢
      rw [h']
      rcases Nat.eq_zero_or_pos c with h0 | h0
      · rw [h0]; simp
      · rw [Nat.cast_sub h0]; simp
    have := mul_le_mul_of_nonneg_right hB hnn
    linarith
  have b2 : (S.tgt - S.kap / n) * (n * (n - 1)) ≤ 2 * ((pairs r : ℕ) : ℝ) := by
    have h2 := two_pairs r
    have e : 2 * ((pairs r : ℕ) : ℝ) = (r : ℝ) * (r - 1) := by
      have h' : ((2 * pairs r : ℕ) : ℝ) = ((r * (r - 1) : ℕ) : ℝ) := by rw [h2]
      push_cast at h' ⊢
      rw [h']
      rcases Nat.eq_zero_or_pos r with h0 | h0
      · rw [h0]; simp
      · rw [Nat.cast_sub h0]; simp
    rw [hη] at hf hB2
    have := mul_le_mul_of_nonneg_right hB2 hnn
    linarith
  have b3 : (S.tgt - S.kap / n) * (n * (n - 1)) ≤ 2 * ((S.F * c * r : ℕ) : ℝ) := by
    have hrlo : S.ylo * n ≤ r := by
      have : (n : ℝ) = S.F * c + r := by exact_mod_cast hn
      rw [hylo]; nlinarith [Nat.cast_nonneg (α := ℝ) S.F]
    have hcr : (S.F : ℝ) * (S.xlo * n) * (S.ylo * n) ≤ S.F * c * r := by
      have := mul_le_mul hlo hrlo (by linarith) (Nat.cast_nonneg _)
      have hF0 : (0 : ℝ) ≤ S.F := Nat.cast_nonneg _
      nlinarith
    have hcross := hS.cross
    have : S.tgt * (n * n) ≤ 2 * (S.F * c * r) := by nlinarith
    have h1 : (S.tgt - S.kap / n) * (n * (n - 1)) ≤ S.tgt * (n * n) := by
      have hk : 0 ≤ S.kap / n := div_nonneg (le_trans hk0 hkap1) hnpos.le
      nlinarith
    push_cast
    linarith
  rcases min_cases (S.F * pairs c) (min (S.F * c * r) (pairs r)) with ⟨h, -⟩ | ⟨h, -⟩ <;> rw [h]
  · exact b1
  · rcases min_cases (S.F * c * r) (pairs r) with ⟨h', -⟩ | ⟨h', -⟩ <;> rw [h']
    · exact b3
    · exact b2

end arith

/-! ## The threshold specification, and the lifted theorem -/

section lifted
open SigmaHalf Sigma ArkCore Filter Real

/-- The threshold table: F = 1 at even n, F = 2 at odd n. -/
def FT : Fin 12 → ℕ := ![1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2]
/-- The index k = d/2 of the foreign block, r = 2k·q + 1 (`threshold-beyond-mu.md` §4's table). -/
def kT : Fin 12 → ℕ := ![1, 1, 3, 2, 1, 3, 1, 2, 3, 1, 1, 6]

/-- Class a's specification at slack ε: the window of `window_of_eps` at η = 1 (d = 2). -/
noncomputable def specT (ε : ℝ) (a : Fin 12) : ClassSpec := specEps (FT a) 2 ε

/-- The threshold ceiling: 1/4 at even n, 3 − 2√2 at odd n. -/
noncomputable def capT (a : Fin 12) : ℝ := Ark.capF (FT a) 1

theorem capT_even (a : Fin 12) (h : FT a = 1) : capT a = 1 / 4 := by rw [capT, h]; exact cap11
theorem capT_odd (a : Fin 12) (h : FT a = 2) : capT a = 3 - 2 * √2 := by rw [capT, h]; exact cap21

theorem FT_cases (a : Fin 12) : FT a = 1 ∨ FT a = 2 := by fin_cases a <;> simp [FT]
theorem kT_cases (a : Fin 12) : kT a = 1 ∨ kT a = 2 ∨ kT a = 3 ∨ kT a = 6 := by
  fin_cases a <;> simp [kT]

theorem goodT (k q : ℕ) [NeZero k] (hq : q.Prime) (hq7 : 7 < q)
    (hk : k = 1 ∨ k = 2 ∨ k = 3 ∨ k = 6) : CycGood.Good k q := by
  rcases hk with rfl | rfl | rfl | rfl
  · exact CycGood.good1 hq.two_le
  · exact CycGood.good2 hq.two_le
  · exact CycGood.good3 hq (by omega)
  · exact CycGood.good6 hq (by omega) (by omega) (by omega)

/-- The threshold witness at n: n = F·p^b + r in the window, r = 2k·q + 1 prime with q an odd
prime above 7, r ≠ p, r ∤ p^b − 1. -/
def WT (ε : ℝ) (n : ℕ) : Prop :=
  ∃ p b q r : ℕ, p.Prime ∧ 1 ≤ b ∧ q.Prime ∧ q % 2 = 1 ∧ 7 < q ∧ r.Prime ∧ r ≠ p ∧
    r = 2 * kT (cls n) * q + 1 ∧ n = FT (cls n) * p ^ b + r ∧
    (specT ε (cls n)).xlo * n ≤ ((p ^ b : ℕ) : ℝ) ∧ ((p ^ b : ℕ) : ℝ) ≤ (specT ε (cls n)).xhi * n ∧
    ¬ r ∣ p ^ b - 1

theorem specT_tgt (ε : ℝ) (hε : ε ≤ 1) (a : Fin 12) : (specT ε a).tgt = (1 - ε) * capT a := by
  unfold specT specEps ClassSpec.tgt ClassSpec.eta capT
  simp only
  have := window_of_eps (FT a) (η := 2 / (2 : ℕ)) (by rcases FT_cases a with h | h <;> omega)
    (by positivity) hε
  rw [this]; norm_num

theorem specT_eventually {ε : ℝ} (hε1 : ε < 1) : ∀ᶠ n : ℕ in atTop, ∀ a : Fin 12,
    1 ≤ (specT ε a).xlo * (n : ℝ) ∧ 1 ≤ (specT ε a).ylo * (n : ℝ) := by
  rw [Filter.eventually_all]
  intro a
  have hF : 0 < FT a := by rcases FT_cases a with h | h <;> omega
  have hη : (0 : ℝ) < 2 / ((2 : ℕ) : ℝ) := by norm_num
  have hs : 0 < √(1 - ε) := sqrt_pos.mpr (by linarith)
  have hFr : (0 : ℝ) < FT a := by exact_mod_cast hF
  have hx : 0 < (specT ε a).xlo := by
    show 0 < epsLo (FT a) (2 / (2 : ℕ)) ε
    unfold epsLo xstar
    have : 0 < √(2 / ((2 : ℕ) : ℝ)) := sqrt_pos.mpr hη
    positivity
  have hy : 0 < (specT ε a).ylo := by
    unfold specT
    rw [specEps_ylo _ _ _ hF, one_sub_F_xstar _ _ hF hη.le]
    positivity
  have h1 : ∀ᶠ n : ℕ in atTop, (1 / (specT ε a).xlo) ≤ (n : ℝ) :=
    tendsto_natCast_atTop_atTop.eventually_ge_atTop _
  have h2 : ∀ᶠ n : ℕ in atTop, (1 / (specT ε a).ylo) ≤ (n : ℝ) :=
    tendsto_natCast_atTop_atTop.eventually_ge_atTop _
  filter_upwards [h1, h2] with n hn1 hn2
  constructor
  · rw [div_le_iff₀ hx] at hn1; linarith
  · rw [div_le_iff₀ hy] at hn2; linarith

/-- **Beyond μ\*, under either quantifier.**  Given the threshold witness L-eventually
(L = `atTop` for the all-large-n form, `almostAll` for almost all n), L-eventually there is, on
n points, an m with 2m ≥ ((1 − ε)·δ_cyc(n) − κ/n)·n(n − 1) — δ_cyc = 1/4 at even n,
3 − 2√2 at odd n — such that, **under the KSS–Oliver input, every graph property on n points
with e_max < m is evasive**.  (`threshold-beyond-mu.md` Proposition L, lower half, with the
quantifier and the evasiveness input explicit.) -/
theorem thr_realised {ε : ℝ} (hε1 : ε < 1) {L : Filter ℕ} (hL : L ≤ atTop)
    (H : BCG.Hyp (WT ε) L) :
    ∀ᶠ n in L, ∃ (V : Type) (_ : Fintype V) (_ : DecidableEq V) (m : ℕ),
      Fintype.card V = n ∧
      ((1 - ε) * capT (cls n) - (specT ε (cls n)).kap / n) * (n * (n - 1)) ≤ 2 * (m : ℝ) ∧
      ∀ (Ev : Evasive.DownProp V → Prop), Evasive.HypKSSOliver Ev →
        ∀ P : Evasive.DownProp V, Evasive.EmaxLt P m → Ev P := by
  filter_upwards [H, hL (specT_eventually hε1)] with n hW hl
  obtain ⟨hx, hy⟩ := hl (cls n)
  obtain ⟨p, b, q, r, hp, hb, hq, hqo, hq7, hr, hrp, hrd, hn, hlo, hhi, hco⟩ := hW
  have hg := specEps_good (FT (cls n)) 2 (ε := ε) (by rcases FT_cases (cls n) with h | h <;> omega)
    (le_refl 2) hε1.le
  have hbound := thr_bound (specT ε (cls n)) hg rfl hn hlo hhi hx hy
  rw [specT_tgt ε hε1.le] at hbound
  have : Fact p.Prime := ⟨hp⟩
  have : Fact r.Prime := ⟨hr⟩
  set k := kT (cls n) with hkdef
  have hk0 : 0 < k := by rcases kT_cases (cls n) with h | h | h | h <;> omega
  have : NeZero k := ⟨by omega⟩
  have hk : r - 1 = 2 * q * k := by rw [hrd]; simp; ring
  have hgood : CycGood.Good k q := goodT k q hq hq7 (by rw [hkdef]; exact kT_cases _)
  let K := GaloisField p b
  let _ : Fintype K := Fintype.ofFinite K
  have hK : Fintype.card K = p ^ b := by
    rw [← Nat.card_eq_fintype_card]; exact GaloisField.card p b (by omega)
  rcases FT_cases (cls n) with hF | hF
  · have hF' : (specT ε (cls n)).F = 1 := hF
    rw [hF'] at hbound
    refine ⟨K ⊕ ZMod r, inferInstance, inferInstance, _, ?_, hbound, ?_⟩
    · rw [Fintype.card_sum, hK, ZMod.card]; have h' := hn; rw [hF] at h'; omega
    · intro Ev HEv P hP
      exact thr_1 p q b k hK hq hqo hk hco hgood Ev HEv P hP
  · have hF' : (specT ε (cls n)).F = 2 := hF
    rw [hF'] at hbound
    have : Fact (1 < 2) := ⟨by norm_num⟩
    have hrF : ¬ r ∣ 2 := by
      intro h; have := Nat.le_of_dvd (by norm_num) h
      have : 2 < r := by rw [hrd]; nlinarith
      omega
    refine ⟨PartEF.Pt 2 K r, inferInstance, inferInstance, _, ?_, hbound, ?_⟩
    · rw [Fintype.card_sum, Fintype.card_prod, ZMod.card, ZMod.card, hK]
      have h' := hn; rw [hF] at h'; omega
    · intro Ev HEv P hP
      exact thr_F p q b k hK hq hqo hk hco hrF hgood Ev HEv P hP

end lifted

end Threshold

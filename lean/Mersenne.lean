import Mathlib

/-!
# AΓL(1, 2^p) acts freely on 3-sets (`three-uniform-note.md` §2.2.3)

For a finite field `K` of characteristic 2 with `2^p` elements, `p` prime and `p ≥ 5`, no
semilinear affine map `x ↦ u·x^(2^i) + v` (`u ≠ 0`) other than the identity stabilises a
3-subset of `K`. So every 3-set orbit of AΓL(1, 2^p) has the full size `2^p(2^p − 1)p`.

The Mersenne condition (`2^p − 1` prime) is not used: freeness holds for every prime `p ≥ 5`.
-/

namespace Mersenne

variable {K : Type*} [Field K] [Fintype K] [CharP K 2] {p : ℕ}

/-- `g` is `x ↦ u·x^(2^i) + v` with `u ≠ 0`: an element of AΓL(1, K) with Frobenius part `i`. -/
def SemiAt (i : ℕ) (g : K → K) : Prop := ∃ u : K, u ≠ 0 ∧ ∃ v : K, ∀ x, g x = u * x ^ 2 ^ i + v

omit [Fintype K] in
theorem SemiAt.comp {i j : ℕ} {g h : K → K} (hg : SemiAt i g) (hh : SemiAt j h) :
    SemiAt (i + j) (g ∘ h) := by
  obtain ⟨u, hu, v, hgx⟩ := hg
  obtain ⟨u', hu', v', hhx⟩ := hh
  refine ⟨u * u' ^ 2 ^ i, mul_ne_zero hu (pow_ne_zero _ hu'), u * v' ^ 2 ^ i + v, fun x => ?_⟩
  simp only [Function.comp_apply, hgx, hhx, add_pow_char_pow, mul_pow]
  rw [← pow_mul, ← pow_add, Nat.add_comm j i]; ring

omit [Fintype K] in
theorem SemiAt.iterate {i : ℕ} {g : K → K} (hg : SemiAt i g) (n : ℕ) : SemiAt (n * i) g^[n] := by
  induction n with
  | zero => exact ⟨1, one_ne_zero, 0, fun x => by simp⟩
  | succ n ih =>
    rw [Function.iterate_succ', Nat.succ_mul, Nat.add_comm]
    exact hg.comp ih

omit [CharP K 2] in
theorem pow_two_pow_mul (hK : Fintype.card K = 2 ^ p) (x : K) (q : ℕ) : x ^ 2 ^ (p * q) = x := by
  induction q with
  | zero => simp
  | succ q ih =>
    rw [Nat.mul_succ, pow_add, pow_mul, ih, ← hK, FiniteField.pow_card]

omit [CharP K 2] in
theorem pow_two_pow_mod (hK : Fintype.card K = 2 ^ p) (x : K) (i : ℕ) :
    x ^ 2 ^ i = x ^ 2 ^ (i % p) := by
  conv_lhs => rw [← Nat.div_add_mod i p, pow_add, pow_mul, pow_two_pow_mul hK]

omit [Fintype K] [CharP K 2] in
theorem iter_sq (r : K) (j : ℕ) : (fun y : K => y ^ 2)^[j] r = r ^ 2 ^ j := by
  induction j with
  | zero => simp
  | succ j ih => rw [Function.iterate_succ_apply', ih, ← pow_mul, ← pow_succ]

omit [CharP K 2] in
/-- A field element fixed by a Frobenius power not divisible by `p` lies in 𝔽₂. -/
theorem fixed_F2 (hp : p.Prime) (hK : Fintype.card K = 2 ^ p) {r : K} {j : ℕ}
    (hr : r ^ 2 ^ j = r) (hj : ¬ p ∣ j) : r = 0 ∨ r = 1 := by
  have h1 : Function.IsPeriodicPt (fun y : K => y ^ 2) j r := by
    unfold Function.IsPeriodicPt Function.IsFixedPt; rw [iter_sq, hr]
  have h2 : Function.IsPeriodicPt (fun y : K => y ^ 2) p r := by
    unfold Function.IsPeriodicPt Function.IsFixedPt; rw [iter_sq, ← hK, FiniteField.pow_card]
  have hg : Nat.gcd j p = 1 := Nat.Coprime.symm ((Nat.Prime.coprime_iff_not_dvd hp).mpr hj)
  have h3 := h1.gcd h2
  rw [hg] at h3
  unfold Function.IsPeriodicPt Function.IsFixedPt at h3
  rw [iter_sq, pow_one] at h3
  have : r * (r - 1) = 0 := by rw [mul_sub, mul_one, ← sq, h3, sub_self]
  rcases mul_eq_zero.mp this with h | h
  · exact Or.inl h
  · exact Or.inr (sub_eq_zero.mp h)

omit [Fintype K] in
theorem sub_formula {i : ℕ} {u v : K} {g : K → K} (hgx : ∀ x, g x = u * x ^ 2 ^ i + v) (a b : K) :
    g b - g a = u * (b - a) ^ 2 ^ i := by
  rw [hgx, hgx, sub_pow_char_pow]; ring

/-- A semilinear map fixing three distinct points is the identity. -/
theorem three_fixed (hp : p.Prime) (hK : Fintype.card K = 2 ^ p) {i : ℕ} {g : K → K}
    (hg : SemiAt i g) {a b z : K} (hab : a ≠ b) (haz : a ≠ z) (hbz : b ≠ z)
    (ha : g a = a) (hb : g b = b) (hz : g z = z) : ∀ x, g x = x := by
  obtain ⟨u, hu, v, hgx⟩ := hg
  have he : b - a ≠ 0 := sub_ne_zero.mpr hab.symm
  have hf : z - a ≠ 0 := sub_ne_zero.mpr haz.symm
  have eb : u * (b - a) ^ 2 ^ i = b - a := by rw [← sub_formula hgx, ha, hb]
  have ez : u * (z - a) ^ 2 ^ i = z - a := by rw [← sub_formula hgx, ha, hz]
  by_cases hpi : p ∣ i
  · have hid : ∀ x : K, x ^ 2 ^ i = x := fun x => by
      rw [pow_two_pow_mod hK, Nat.mod_eq_zero_of_dvd hpi]; simp
    rw [hid] at eb
    have hu1 : u = 1 := by
      have := congrArg (· * (b - a)⁻¹) eb
      simpa [mul_assoc, mul_inv_cancel₀ he] using this
    have hv : v = 0 := by
      have := ha; rw [hgx, hid, hu1, one_mul] at this
      simpa using this
    intro x; rw [hgx, hid, hu1, hv]; ring
  · exfalso
    set r := (z - a) / (b - a)
    have hr : r ^ 2 ^ i = r := by
      simp only [r, div_pow]
      have e1 : (b - a) ^ 2 ^ i = (b - a) / u := by rw [eq_div_iff hu, mul_comm, eb]
      have e2 : (z - a) ^ 2 ^ i = (z - a) / u := by rw [eq_div_iff hu, mul_comm, ez]
      rw [e1, e2, div_div_div_cancel_right₀ hu]
    rcases fixed_F2 hp hK hr hpi with h | h
    · exact hf (by simpa [r, he] using h)
    · exact hbz (by
        have := (div_eq_one_iff_eq he).mp h
        exact (sub_left_inj.mp this).symm)

omit [CharP K 2] in
/-- The identity is semilinear only with Frobenius part divisible by `p` (here `|K| > 2`). -/
theorem dvd_of_id (hp : p.Prime) (hK : Fintype.card K = 2 ^ p) {j : ℕ} {h : K → K}
    (hh : SemiAt j h) (hid : ∀ x, h x = x) : p ∣ j := by
  classical
  obtain ⟨u, hu, v, hx⟩ := hh
  have hv : v = 0 := by have := hx 0; rw [hid, zero_pow (by positivity), mul_zero, zero_add] at this
                        exact this.symm
  have hu1 : u = 1 := by have := hx 1; rw [hid, one_pow, mul_one, hv, add_zero] at this
                         exact this.symm
  by_contra hpj
  have hall : ∀ x : K, x = 0 ∨ x = 1 := fun x => by
    refine fixed_F2 hp hK ?_ hpj
    have := hx x; rw [hid, hu1, hv, one_mul, add_zero] at this; exact this.symm
  have hle : Fintype.card K ≤ 2 := by
    calc Fintype.card K = (Finset.univ : Finset K).card := rfl
      _ ≤ ({0, 1} : Finset K).card := Finset.card_le_card (fun x _ => by
          rcases hall x with rfl | rfl <;> simp)
      _ ≤ 2 := Finset.card_le_two
  rw [hK] at hle
  have : 2 ^ 2 ≤ 2 ^ p := Nat.pow_le_pow_right (by norm_num) hp.two_le
  omega

omit [CharP K 2] in
theorem linear_of (hK : Fintype.card K = 2 ^ p) {i : ℕ} {g : K → K} (hg : SemiAt i g)
    (hpi : p ∣ i) : ∃ u : K, u ≠ 0 ∧ ∃ v : K, ∀ x, g x = u * x + v := by
  obtain ⟨u, hu, v, hgx⟩ := hg
  refine ⟨u, hu, v, fun x => ?_⟩
  rw [hgx, pow_two_pow_mod hK, Nat.mod_eq_zero_of_dvd hpi, pow_zero, pow_one]

/-- No element of order 3. -/
theorem no_order_three (hp : p.Prime) (h5 : 5 ≤ p) (hK : Fintype.card K = 2 ^ p) {i : ℕ}
    {g : K → K} (hg : SemiAt i g) (h3 : ∀ x, g^[3] x = x) : ∀ x, g x = x := by
  have hpi : p ∣ i := by
    have := dvd_of_id hp hK (hg.iterate 3) h3
    rcases (Nat.Prime.dvd_mul hp).mp this with h | h
    · exact absurd (Nat.le_of_dvd (by norm_num) h) (by omega)
    · exact h
  obtain ⟨u, hu, v, hgx⟩ := linear_of hK hg hpi
  have hit : ∀ x, g^[3] x = u ^ 3 * x + (u * (u * v + v) + v) := fun x => by
    simp only [Function.iterate_succ, Function.iterate_zero, Function.comp_apply, id, hgx]; ring
  have h0 := h3 0; rw [hit, mul_zero, zero_add] at h0
  have h1 := h3 1; rw [hit, mul_one, h0, add_zero] at h1
  -- u³ = 1 and u^(2^p − 1) = 1 with gcd(3, 2^p − 1) = 1
  have hM : u ^ (2 ^ p - 1) = 1 := by rw [← hK]; exact FiniteField.pow_card_sub_one_eq_one u hu
  have hodd : Odd p := hp.odd_of_ne_two (by omega)
  have hmod : 2 ^ p % 3 = 2 := by
    obtain ⟨m, rfl⟩ := hodd
    rw [pow_succ, pow_mul, Nat.mul_mod, Nat.pow_mod]; norm_num
  have hpos : 1 ≤ 2 ^ p := Nat.one_le_two_pow
  have hgcd : Nat.gcd 3 (2 ^ p - 1) = 1 := by
    have : ¬ 3 ∣ 2 ^ p - 1 := by omega
    exact (Nat.Coprime.symm ((Nat.Prime.coprime_iff_not_dvd Nat.prime_three).mpr this).symm)
  have hu1 : u = 1 := by
    have hd : orderOf u ∣ Nat.gcd 3 (2 ^ p - 1) :=
      Nat.dvd_gcd (orderOf_dvd_of_pow_eq_one h1) (orderOf_dvd_of_pow_eq_one hM)
    rw [hgcd, Nat.dvd_one, orderOf_eq_one_iff] at hd; exact hd
  subst hu1
  have hv : v = 0 := by
    have : v + v = 0 := CharTwo.add_self_eq_zero v
    rw [one_mul, one_mul] at h0
    calc v = v + v + v := by rw [this, zero_add]
      _ = 0 := h0
  intro x; rw [hgx, hv]; ring

/-- An element of order dividing 2 is a translation. -/
theorem order_two (hp : p.Prime) (h5 : 5 ≤ p) (hK : Fintype.card K = 2 ^ p) {i : ℕ}
    {g : K → K} (hg : SemiAt i g) (h2 : ∀ x, g^[2] x = x) : ∃ v, ∀ x, g x = x + v := by
  have hpi : p ∣ i := by
    have := dvd_of_id hp hK (hg.iterate 2) h2
    rcases (Nat.Prime.dvd_mul hp).mp this with h | h
    · exact absurd (Nat.le_of_dvd (by norm_num) h) (by omega)
    · exact h
  obtain ⟨u, hu, v, hgx⟩ := linear_of hK hg hpi
  have hit : ∀ x, g^[2] x = u ^ 2 * x + (u * v + v) := fun x => by
    simp only [Function.iterate_succ, Function.iterate_zero, Function.comp_apply, id, hgx]; ring
  have h0 := h2 0; rw [hit, mul_zero, zero_add] at h0
  have h1 := h2 1; rw [hit, mul_one, h0, add_zero] at h1
  have hu1 : u = 1 := by
    have : (u + 1) ^ 2 = 0 := by
      rw [add_pow_char, h1, one_pow, CharTwo.add_self_eq_zero]
    have := pow_eq_zero_iff (n := 2) (by norm_num) |>.mp this
    rw [← sub_eq_zero, ← this]; simp [CharTwo.sub_eq_add]
  exact ⟨v, fun x => by rw [hgx, hu1, one_mul]⟩

/-- **AΓL(1, 2^p) acts freely on 3-sets** (p prime, p ≥ 5): a semilinear affine map that
stabilises a 3-subset of `K` is the identity. -/
theorem free (hp : p.Prime) (h5 : 5 ≤ p) (hK : Fintype.card K = 2 ^ p) {i : ℕ} {g : K → K}
    (hg : SemiAt i g) (S : Finset K) (hS : S.card = 3) (hgS : ∀ x ∈ S, g x ∈ S) :
    ∀ x, g x = x := by
  classical
  obtain ⟨u0, hu0, v0, hgx0⟩ := hg
  have hinj : Function.Injective g := fun x y hxy => by
    have : u0 * (x - y) ^ 2 ^ i = 0 := by rw [← sub_formula hgx0, hxy, sub_self]
    exact sub_eq_zero.mp (pow_eq_zero_iff (by positivity) |>.mp
      ((mul_eq_zero.mp this).resolve_left hu0))
  have hg : SemiAt i g := ⟨u0, hu0, v0, hgx0⟩
  let f : S → S := fun s => ⟨g s, hgS s s.2⟩
  have hfinj : Function.Injective f := fun s t h => Subtype.ext (hinj (congrArg Subtype.val h))
  have hfit : ∀ n (s : S), ((f^[n] s : S) : K) = g^[n] s := by
    intro n; induction n with
    | zero => intro s; rfl
    | succ n ih => intro s; rw [Function.iterate_succ_apply', Function.iterate_succ_apply', ← ih]
  let σ : Equiv.Perm S := Equiv.ofBijective f (Finite.injective_iff_bijective.mp hfinj)
  have hσ : ∀ n (s : S), (σ ^ n) s = f^[n] s := by
    intro n; induction n with
    | zero => intro s; rfl
    | succ n ih => intro s; rw [pow_succ', Equiv.Perm.mul_apply, ih,
        Function.iterate_succ_apply']; rfl
  have hcard : Fintype.card (Equiv.Perm S) = 6 := by
    rw [Fintype.card_perm, Fintype.card_coe, hS]; rfl
  have h6 : σ ^ 6 = 1 := hcard ▸ pow_card_eq_one
  have hfix6 : ∀ x ∈ S, g^[6] x = x := fun x hx => by
    have := hfit 6 ⟨x, hx⟩; rw [← hσ, h6] at this; simpa using this.symm
  obtain ⟨a, b, z, hab, haz, hbz, rfl⟩ := Finset.card_eq_three.mp hS
  have hid6 := three_fixed hp hK (hg.iterate 6) hab haz hbz (hfix6 a (by simp))
    (hfix6 b (by simp)) (hfix6 z (by simp))
  have hid2 : ∀ x, g^[2] x = x := by
    refine no_order_three hp h5 hK (hg.iterate 2) (fun x => ?_)
    rw [← Function.iterate_mul]; exact hid6 x
  obtain ⟨v, hv⟩ := order_two hp h5 hK hg hid2
  -- an involution of a 3-set has a fixed point
  have hf2 : f^[2 ^ 1] = id := funext fun s => Subtype.ext (by rw [hfit]; exact hid2 s)
  have : Fact (Nat.Prime 2) := ⟨Nat.prime_two⟩
  have hmod := Equiv.Perm.card_fixedPoints_modEq (p := 2) (n := 1) hf2
  rw [Fintype.card_coe, hS] at hmod
  obtain ⟨s, hs⟩ : (Function.fixedPoints f).Nonempty := by
    rw [Set.nonempty_iff_ne_empty]; intro he
    simp only [he] at hmod; simp [Nat.ModEq] at hmod
  have : g s = s := congrArg Subtype.val hs
  rw [hv] at this
  have hv0 : v = 0 := by simpa using this
  intro x; rw [hv, hv0, add_zero]

/-- The same for the concrete field `GaloisField 2 p`, so the hypotheses are met. -/
theorem free_galois (hp : p.Prime) (h5 : 5 ≤ p) {i : ℕ} {g : GaloisField 2 p → GaloisField 2 p}
    (hg : SemiAt i g) (S : Finset (GaloisField 2 p)) (hS : S.card = 3) (hgS : ∀ x ∈ S, g x ∈ S) :
    ∀ x, g x = x := by
  let _ : Fintype (GaloisField 2 p) := Fintype.ofFinite _
  have : Fact (Nat.Prime 2) := ⟨Nat.prime_two⟩
  refine free hp h5 ?_ hg S hS hgS
  rw [← Nat.card_eq_fintype_card, GaloisField.card 2 p hp.ne_zero]

end Mersenne

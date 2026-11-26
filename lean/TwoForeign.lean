/-
# `TwoForeign.lean` — Proposition 2: the S6 and S11 ceilings

`ladder-completeness.md` Proposition 2: S6 (two foreign primes) has SAFE ≤ C(n,2)/9 and S11 (a
class beside two foreign primes) has SAFE ≤ C(n,2)/16.  Proved in the `E6` model as
`s6_ceiling` and `s11_ceiling`, for every q and every exponent, **with no exceptions**: the
text excludes the q = 2 pairs {3, 5} and {5, 7}, but those exceed 1/9 only in the continuous
ceilings; with the actual orbit counts they satisfy the bound ({5, 7}: 9·7 = 63 ≤ 66).

**The key lemma, `two_foreign`.** For primes r₁ < r₂ with twists q^(fⱼ) ∣ rⱼ − 1 and
R = r₁ + r₂, one of them has 18·orb(r, t) ≤ R(R − 1).  Same method as `ThreeForeign`:
normalise by the least twist T (rⱼ = aⱼT + 1, tⱼ = bⱼT), bound A = a₁ + a₂ < 18 from the
part with b = 1, then a kernel check per q (`checkQ2`).  At T = 1 the check evaluates the bound
exactly (`kill1`); for T ≥ 2 it uses the coefficient test (`kill2`).  One family survives the
test — q = 2, r₁ = 2T + 1, r₂ = 3T + 1 — and primality kills it: at T = 2 it is {5, 7}, which
fails numerically, and for T = 2^m ≥ 4 one of the two is divisible by 3 or 5
(`surv_composite`, from 2^m mod 15).

**S11 from S6's lemma (`s11_arith`).** A class worth more than C(n,2)/16 has size s with
3s > R, so 9n(n − 1) ≥ 16R(R − 1), and the foreign bound 18x ≤ R(R − 1) gives 16x ≤ C(n,2).
The 1/16 = (3/4)²·(1/9) relation is exactly this.

**Strictly (`two_foreign_lt`, `s6_ceiling_lt`, `s11_ceiling_lt`).** The same check run with the
bound one unit tighter (`k = 1` in `PartH2`) shows neither ceiling is attained: 9·SAFE < C(n,2)
for S6 and 16·SAFE < C(n,2) for S11.

Not formalised: the near-equality analysis (1/9 attained only in the limit at r₂ = 2r₁ − 1),
and the text's "S6 has n even" (false at the edges {2, 3} and {2, 5}, n = 5 and 7, where SAFE = 1 is above C(n,2)/25).
-/
import ThreeForeign

namespace TwoForeign
open E6 ArkCore E5Assembly ThreeForeign

/-- Kill at every T: a bound with leading coefficient ≤ A² and linear coefficient ≤ 3A. -/
def kill2 (A a b c : ℕ) : Bool :=
  (decide (9 * c * a * b ≤ A * A) && decide (9 * c * b ≤ 3 * A)) ||
  (decide (9 * a * a ≤ A * A) && decide (9 * a ≤ 3 * A))

/-- Kill at T = 1 exactly. -/
def kill1 (k A a b c : ℕ) : Bool :=
  decide (9 * c * a * b + 9 * c * b ≤ A * A + 3 * A + k) ||
  decide (9 * a * a + 9 * a ≤ A * A + 3 * A + k)

/-- The one family the coefficient test cannot kill: q = 2, T ≥ 2, (a, b) = (2, 2), (3, 1),
i.e. r₁ = 2T + 1, r₂ = 3T + 1 — killed by primality instead. -/
def surv (q : ℕ) (T1 : Bool) (a1 a2 b1 b2 : ℕ) : Bool :=
  q == 2 && !T1 && a1 == 2 && a2 == 3 && b1 == 2 && b2 == 1

def checkQ2 (k q : ℕ) (pw : List ℕ) : Bool :=
  (List.range 18).all fun A => (List.range 18).all fun a1 =>
    let a2 := A - a1
    !(a1 + a2 == A && 1 ≤ a1 && a1 < a2) ||
    [true, false].all fun T1 => pw.all fun b1 => pw.all fun b2 =>
      let two := q == 2
      let on := !two || T1
      !((b1 == 1 || b2 == 1) && a1 % b1 == 0 && a2 % b2 == 0 && par on a1 && par on a2) ||
      (if T1 then kill1 k A a1 b1 (cOf two T1 b1) || kill1 k A a2 b2 (cOf two T1 b2)
       else kill2 A a1 b1 (cOf two T1 b1) || kill2 A a2 b2 (cOf two T1 b2)) ||
      surv q T1 a1 a2 b1 b2

theorem chk_all2 (k q : ℕ) (hk : k = 1 ∨ k = 2) (hp : q.Prime) (h2 : q < 32) :
    checkQ2 k q (pws q) = true := by
  have h1 := hp.two_le
  rcases hk with rfl | rfl <;>
  interval_cases q <;> first | decide +kernel | (exfalso; norm_num at hp)

theorem chkBig2 (k : ℕ) (hk : k = 1 ∨ k = 2) : checkQ2 k 33 [1] = true := by
  rcases hk with rfl | rfl <;> decide +kernel

structure PartH2 (k q T A a e : ℕ) : Prop where
  dvd : q ^ e ∣ a
  par : q ≠ 2 ∨ T = 1 → a % 2 = 0 ∨ a = 1
  E : A * A * T * T + 3 * A * T + k <
    9 * cOf (q == 2) (T == 1) (q ^ e) * a * (q ^ e) * T * T + 9 * cOf (q == 2) (T == 1) (q ^ e) * (q ^ e) * T
  P : A * A * T * T + 3 * A * T + k < 9 * a * a * T * T + 9 * a * T

theorem kill2_sound {k A a b c T : ℕ} (hk1 : 1 ≤ k) (hk : kill2 A a b c = true)
    (hE : A * A * T * T + 3 * A * T + k < 9 * c * a * b * T * T + 9 * c * b * T)
    (hP : A * A * T * T + 3 * A * T + k < 9 * a * a * T * T + 9 * a * T) : False := by
  simp only [kill2, Bool.or_eq_true, Bool.and_eq_true, decide_eq_true_eq] at hk
  rcases hk with ⟨h1, h2⟩ | ⟨h1, h2⟩
  · have := Nat.mul_le_mul_right (T * T) h1
    have := Nat.mul_le_mul_right T h2
    nlinarith
  · have := Nat.mul_le_mul_right (T * T) h1
    have := Nat.mul_le_mul_right T h2
    nlinarith

theorem kill1_sound {k A a b c : ℕ} (hk : kill1 k A a b c = true)
    (hE : A * A * 1 * 1 + 3 * A * 1 + k < 9 * c * a * b * 1 * 1 + 9 * c * b * 1)
    (hP : A * A * 1 * 1 + 3 * A * 1 + k < 9 * a * a * 1 * 1 + 9 * a * 1) : False := by
  simp only [kill1, Bool.or_eq_true, decide_eq_true_eq] at hk
  simp only [mul_one] at hE hP
  omega

theorem A_le2 {k A a c T : ℕ} (hT : 1 ≤ T) (hc : c ≤ 2) (ha : a + 1 ≤ A)
    (hE : A * A * T * T + 3 * A * T + k < 9 * c * a * 1 * T * T + 9 * c * 1 * T) : A < 18 := by
  by_contra hA
  have h1 : 9 * c * a * 1 * T * T + 9 * c * 1 * T ≤ 18 * a * T * T + 18 * T := by
    have := Nat.mul_le_mul_right (a * T * T) hc
    have := Nat.mul_le_mul_right T hc
    nlinarith
  have h2 : 18 * a * T * T + 18 * T ≤ 18 * A * T * T := by
    have : 1 * T ≤ T * T := Nat.mul_le_mul_right T hT
    have := Nat.mul_le_mul_right (T * T) ha
    nlinarith
  have h3 : 18 * A * T * T ≤ A * A * T * T := by
    have := Nat.mul_le_mul_right (A * T * T) (show 18 ≤ A by omega); nlinarith
  nlinarith

/-- **The arithmetic core.** -/
theorem core2 {k q T a1 a2 e1 e2 : ℕ} (hk : k = 1 ∨ k = 2) (hq : q.Prime) (hT : 1 ≤ T)
    (h1 : 1 ≤ a1) (h12 : a1 < a2) (he : e1 = 0 ∨ e2 = 0)
    (p1 : PartH2 k q T (a1 + a2) a1 e1) (p2 : PartH2 k q T (a1 + a2) a2 e2)
    (hsurv : q = 2 → T ≠ 1 → a1 = 2 → a2 = 3 → q ^ e1 = 2 → q ^ e2 = 1 → False) : False := by
  have hq2 := hq.two_le
  set A := a1 + a2 with hAdef
  have hA : A < 18 := by
    rcases he with h | h
    · have E := p1.E; rw [h, pow_zero] at E
      exact A_le2 hT (cOf_le _ _ _) (by omega) E
    · have E := p2.E; rw [h, pow_zero] at E
      exact A_le2 hT (cOf_le _ _ _) (by omega) E
  have ha1 : a1 < 18 := by omega
  have key : ∀ Q pw, checkQ2 k Q pw = true → (Q == 2) = (q == 2) → (Q = 2 → q = 2) →
      q ^ e1 ∈ pw → q ^ e2 ∈ pw → False := by
    intro Q pw hc hQ hQ2 m1 m2
    simp only [checkQ2, List.all_eq_true, List.mem_range] at hc
    have hc := hc A hA a1 ha1
    simp only [show A - a1 = a2 by omega] at hc
    have g1 : (a1 + a2 == A && 1 ≤ a1 && a1 < a2) = true := by
      simp only [Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq]
      exact ⟨⟨rfl, h1⟩, h12⟩
    rw [g1] at hc
    simp only [Bool.not_true, Bool.false_or, List.all_eq_true] at hc
    have hc := hc (T == 1) (by cases (T == 1) <;> simp) (q ^ e1) m1 (q ^ e2) m2
    rw [hQ] at hc
    have pa : ∀ a, (q ≠ 2 ∨ T = 1 → a % 2 = 0 ∨ a = 1) → par (!(q == 2) || (T == 1)) a = true := by
      intro a h
      simp only [par, Bool.or_eq_true, beq_iff_eq, Bool.not_eq_eq_eq_not, Bool.not_true]
      by_cases hq2 : q = 2 <;> by_cases hT1 : T = 1 <;> simp_all
    have g2 : ((q ^ e1 == 1 || q ^ e2 == 1) && a1 % q ^ e1 == 0 && a2 % q ^ e2 == 0 &&
        par (!(q == 2) || (T == 1)) a1 && par (!(q == 2) || (T == 1)) a2) = true := by
      simp only [Bool.and_eq_true, Bool.or_eq_true, beq_iff_eq]
      refine ⟨⟨⟨⟨?_, Nat.mod_eq_zero_of_dvd p1.dvd⟩, Nat.mod_eq_zero_of_dvd p2.dvd⟩,
        pa _ p1.par⟩, pa _ p2.par⟩
      rcases he with h | h <;> simp [h]
    simp only [g2, Bool.not_true, Bool.false_or, Bool.or_eq_true] at hc
    rcases hc with hk | hs
    · by_cases hT1 : T = 1
      · have hb : (T == 1) = true := by simp [hT1]
        rw [hb] at hk; simp only [ite_true, Bool.or_eq_true] at hk
        have E1 := p1.E; have P1 := p1.P; have E2 := p2.E; have P2 := p2.P
        rw [hb] at E1 E2; rw [hT1] at E1 P1 E2 P2
        rcases hk with k | k
        · exact kill1_sound k E1 P1
        · exact kill1_sound k E2 P2
      · have hb : (T == 1) = false := by simp [hT1]
        rw [hb] at hk; simp only [Bool.false_eq_true, ite_false, Bool.or_eq_true] at hk
        have E1 := p1.E; have E2 := p2.E; rw [hb] at E1 E2
        rcases hk with k | k
        · exact kill2_sound (by omega) k E1 p1.P
        · exact kill2_sound (by omega) k E2 p2.P
    · simp only [surv, Bool.and_eq_true, beq_iff_eq, Bool.not_eq_eq_eq_not, Bool.not_true,
        beq_eq_false_iff_ne] at hs
      obtain ⟨⟨⟨⟨⟨hq', hT'⟩, ha1'⟩, ha2'⟩, hb1⟩, hb2⟩ := hs
      exact hsurv (hQ2 hq') hT' ha1' ha2' hb1 hb2
  by_cases hq32 : q < 32
  · exact key q (pws q) (chk_all2 k q hk hq hq32) rfl id
      (pow_mem_pws hq2 (by omega) (by omega) p1.dvd) (pow_mem_pws hq2 (by omega) (by omega) p2.dvd)
  · have q2 : q ≠ 2 := by omega
    have z1 := e_zero (by omega) (show a1 < 32 by omega) (by omega) p1.dvd
    have z2 := e_zero (by omega) (show a2 < 32 by omega) (by omega) p2.dvd
    refine key 33 [1] (chkBig2 k hk) (by simp [q2]) (by omega) ?_ ?_ <;> simp [z1, z2]

theorem pow2_mod15 (m : ℕ) : 2 ^ m % 15 = 1 ∨ 2 ^ m % 15 = 2 ∨ 2 ^ m % 15 = 4 ∨ 2 ^ m % 15 = 8 := by
  induction m with
  | zero => simp
  | succ k ih => rw [pow_succ, Nat.mul_mod]; rcases ih with h | h | h | h <;> rw [h] <;> simp

/-- r₁ = 2T + 1 and r₂ = 3T + 1 are never both prime for T = 2^m ≥ 4: mod 15, one of them is
divisible by 3 or 5. -/
theorem surv_composite {m : ℕ} (hm : 2 ≤ m) (p1 : (2 * 2 ^ m + 1).Prime) (p2 : (3 * 2 ^ m + 1).Prime) :
    False := by
  have h4 : 4 ≤ 2 ^ m := by
    calc 4 = 2 ^ 2 := by norm_num
      _ ≤ 2 ^ m := Nat.pow_le_pow_right (by omega) hm
  have bad : ∀ d r, r.Prime → d ∣ r → 2 ≤ d → d < r → False := fun d r hr hd h2 hlt => by
    rcases hr.eq_one_or_self_of_dvd d hd with h | h <;> omega
  rcases pow2_mod15 m with h | h | h | h
  · exact bad 3 _ p1 (by omega) (by omega) (by omega)
  · exact bad 5 _ p1 (by omega) (by omega) (by omega)
  · exact bad 3 _ p1 (by omega) (by omega) (by omega)
  · exact bad 5 _ p2 (by omega) (by omega) (by omega)

theorem partH2_of {q T m r f a A : ℕ} (hq : q.Prime) (pr : r.Prime) (hf : m ≤ f) (hT : T = q ^ m)
    (hra : r - 1 = a * T) (hdv : q ^ (f - m) ∣ a) (hR : A * T + 2 = R)
    (hlt : R * (R - 1) + k < 18 * orb r (q ^ f) false + 2) : PartH2 k q T A a (f - m) := by
  have hrT : r = a * T + 1 := by have := pr.two_le; omega
  have hX : A * A * T * T + 3 * A * T + 2 = R * (R - 1) := by
    have : A * T + 2 - 1 = A * T + 1 := by omega
    rw [← hR, this]; ring
  have hsplit : q ^ f = T * q ^ (f - m) := by rw [hT, ← pow_add]; congr 1; omega
  refine ⟨hdv, par_arith hq pr hrT hT, ?_, ?_⟩
  · have h2o := two_orb_le r (q ^ f) (cOf (q == 2) (T == 1) (q ^ (f - m)))
      (c_arith hT hf) (cOf_cases _ _ _)
    rw [hsplit, hrT] at h2o hlt
    have e : 9 * (cOf (q == 2) (T == 1) (q ^ (f - m)) * ((a * T + 1) * (T * q ^ (f - m)))) =
        9 * cOf (q == 2) (T == 1) (q ^ (f - m)) * a * q ^ (f - m) * T * T +
        9 * cOf (q == 2) (T == 1) (q ^ (f - m)) * q ^ (f - m) * T := by ring
    omega
  · have hp := orb_le_pairs r (q ^ f) false
    have h3 := two_pairs r
    rw [hrT, Nat.add_sub_cancel] at h3
    rw [hrT] at hp hlt
    have e : 9 * ((a * T + 1) * (a * T)) = 9 * a * a * T * T + 9 * a * T := by ring
    omega

/-- **Two foreign primes with a common q.** With R = r₁ + r₂, one of them has
18·orb(r, t) ≤ R(R − 1) — i.e. orb ≤ C(R,2)/9. -/
theorem two_foreign_k {k q r1 r2 f1 f2 : ℕ} (hk : k = 1 ∨ k = 2) (hq : q.Prime)
    (pr1 : r1.Prime) (pr2 : r2.Prime)
    (h12 : r1 < r2) (d1 : q ^ f1 ∣ r1 - 1) (d2 : q ^ f2 ∣ r2 - 1) :
    18 * orb r1 (q ^ f1) false + 2 ≤ (r1 + r2) * (r1 + r2 - 1) + k ∨
    18 * orb r2 (q ^ f2) false + 2 ≤ (r1 + r2) * (r1 + r2 - 1) + k := by
  by_contra hcon
  simp only [not_or, not_le] at hcon
  obtain ⟨lt1, lt2⟩ := hcon
  obtain ⟨m, hm⟩ : ∃ m, m = min f1 f2 := ⟨_, rfl⟩
  obtain ⟨T, hT⟩ : ∃ T, T = q ^ m := ⟨_, rfl⟩
  have hT1 : 1 ≤ T := by rw [hT]; exact Nat.one_le_pow _ _ hq.pos
  have decomp : ∀ r f, m ≤ f → q ^ f ∣ r - 1 → ∃ a, r - 1 = a * T ∧ q ^ (f - m) ∣ a := by
    intro r f hf hd
    have : q ^ f = T * q ^ (f - m) := by rw [hT, ← pow_add]; congr 1; omega
    rw [this] at hd
    obtain ⟨k, hk⟩ := hd
    exact ⟨q ^ (f - m) * k, by rw [hk]; ring, dvd_mul_right _ _⟩
  obtain ⟨a1, ha1, dv1⟩ := decomp r1 f1 (by omega) d1
  obtain ⟨a2, ha2, dv2⟩ := decomp r2 f2 (by omega) d2
  have r1p := pr1.two_le
  have ha1p : 1 ≤ a1 := by
    rcases Nat.eq_zero_or_pos a1 with h | h
    · rw [h, zero_mul] at ha1; omega
    · exact h
  have lt12 : a1 < a2 := by
    by_contra h; have := Nat.mul_le_mul_right T (show a2 ≤ a1 by omega); omega
  have hR : (a1 + a2) * T + 2 = r1 + r2 := by
    have e : (a1 + a2) * T = a1 * T + a2 * T := by ring
    have := pr2.two_le; omega
  have p1 := partH2_of hq pr1 (by omega) hT ha1 dv1 hR lt1
  have p2 := partH2_of hq pr2 (by omega) hT ha2 dv2 hR lt2
  refine core2 hk hq hT1 ha1p lt12 (by omega) p1 p2 ?_
  intro hq2 hTne ha1' ha2' hb1 hb2
  subst hq2
  have hm1 : 1 ≤ m := by
    by_contra h; have : m = 0 := by omega
    exact hTne (by rw [hT, this, pow_zero])
  rw [ha1', hT] at ha1
  rw [ha2', hT] at ha2
  have hr1 : r1 = 2 * 2 ^ m + 1 := by omega
  have hr2 : r2 = 3 * 2 ^ m + 1 := by have := pr2.two_le; omega
  rcases Nat.lt_or_ge m 2 with h | h
  · -- T = 2: r₁ = 5, r₂ = 7, t₂ = 2, and 18·orb(7, 2) = 126 < 132
    have hm' : m = 1 := by omega
    have ht2 : 2 ^ f2 = 2 := by
      have : 2 ^ f2 = T * 2 ^ (f2 - m) := by rw [hT, ← pow_add]; congr 1; omega
      rw [this, hb2, hT, hm']; norm_num
    rw [hm'] at hr1 hr2
    rw [ht2, hr1, hr2] at lt2
    revert lt2; rcases hk with rfl | rfl <;> decide
  · exact surv_composite h (hr1 ▸ pr1) (hr2 ▸ pr2)

theorem two_foreign {q r1 r2 f1 f2 : ℕ} (hq : q.Prime) (pr1 : r1.Prime) (pr2 : r2.Prime)
    (h12 : r1 < r2) (d1 : q ^ f1 ∣ r1 - 1) (d2 : q ^ f2 ∣ r2 - 1) :
    18 * orb r1 (q ^ f1) false ≤ (r1 + r2) * (r1 + r2 - 1) ∨
    18 * orb r2 (q ^ f2) false ≤ (r1 + r2) * (r1 + r2 - 1) := by
  rcases two_foreign_k (Or.inr rfl) hq pr1 pr2 h12 d1 d2 with h | h <;> omega

/-- **Strictly.**  One of them has 18·orb(r, t) < R(R − 1): the 1/9 ceiling is never attained. -/
theorem two_foreign_lt {q r1 r2 f1 f2 : ℕ} (hq : q.Prime) (pr1 : r1.Prime) (pr2 : r2.Prime)
    (h12 : r1 < r2) (d1 : q ^ f1 ∣ r1 - 1) (d2 : q ^ f2 ∣ r2 - 1) :
    18 * orb r1 (q ^ f1) false < (r1 + r2) * (r1 + r2 - 1) ∨
    18 * orb r2 (q ^ f2) false < (r1 + r2) * (r1 + r2 - 1) := by
  rcases two_foreign_k (Or.inl rfl) hq pr1 pr2 h12 d1 d2 with h | h <;> omega

/-! ## The ceilings in the `E6` model -/

theorem safe_le_orb_of {C : Config} {r t : ℕ} (hx : CPart.fr r t ∈ C.parts) :
    C.safe ≤ orb r t false :=
  minL_le (List.mem_append_left _ (List.mem_flatMap.mpr ⟨_, hx, by simp [CPart.safeTerms]⟩))

theorem foreign_pair (C : Config) (hC : GAdm C) {r1 t1 r2 t2 : ℕ}
    (x1 : CPart.fr r1 t1 ∈ C.parts) (x2 : CPart.fr r2 t2 ∈ C.parts) (h12 : r1 < r2) :
    18 * C.safe ≤ (r1 + r2) * (r1 + r2 - 1) := by
  obtain ⟨-, hq, hall, -⟩ := hC
  obtain ⟨pr1, -, d1, f1, rfl⟩ := hall _ x1
  obtain ⟨pr2, -, d2, f2, rfl⟩ := hall _ x2
  have s1 := safe_le_orb_of x1
  have s2 := safe_le_orb_of x2
  rcases two_foreign hq pr1 pr2 h12 d1 d2 with h | h <;> omega

/-- **Proposition 2, S6.** Two foreign primes alone: SAFE ≤ C(n,2)/9.  In the model the
bound holds with no exceptions: the text's excluded pairs {3, 5} and {5, 7} exceed 1/9 only in
the continuous ceilings, not with the actual orbit counts. -/
theorem s6_ceiling (C : Config) (hC : GAdm C) {r1 t1 r2 t2 : ℕ}
    (hparts : C.parts.Perm [.fr r1 t1, .fr r2 t2]) (h12 : r1 < r2) :
    9 * C.safe ≤ pairs C.n := by
  have x1 : CPart.fr r1 t1 ∈ C.parts := hparts.mem_iff.mpr (by simp)
  have x2 : CPart.fr r2 t2 ∈ C.parts := hparts.mem_iff.mpr (by simp)
  have h := foreign_pair C hC x1 x2 h12
  have hn : C.n = r1 + r2 := by
    simp only [Config.n, Config.sizes]; rw [(hparts.map _).sum_eq]; simp [CPart.sizeC]
  have := two_pairs C.n
  rw [hn] at this ⊢
  omega

/-- The S11 arithmetic: a part of size s worth ≥ x, two foreign parts of total R with
18x ≤ R(R − 1), n = s + R: then 16x ≤ C(n,2)... in doubled form 32x ≤ n(n − 1). -/
theorem s11_arith {s R x : ℕ} (hs : 2 * x ≤ s * (s - 1)) (hR : 18 * x ≤ R * (R - 1)) (hR2 : 2 ≤ R) :
    32 * x ≤ (s + R) * (s + R - 1) := by
  by_contra hlt
  have h3 : R + 1 ≤ 3 * s := by
    by_contra h
    have : 4 * s * (4 * s - 1) ≤ (s + R) * (s + R - 1) :=
      Nat.mul_le_mul (by omega) (by omega)
    have : 16 * (s * (s - 1)) ≤ 4 * s * (4 * s - 1) := by
      rcases Nat.eq_zero_or_pos s with h0 | h0
      · subst h0; simp
      · obtain ⟨k, rfl⟩ : ∃ k, s = k + 1 := ⟨s - 1, by omega⟩
        have e1 : 4 * (k + 1) - 1 = 4 * k + 3 := by omega
        rw [e1, Nat.add_sub_cancel]; nlinarith
    omega
  have h9 : 16 * (R * (R - 1)) ≤ 9 * ((s + R) * (s + R - 1)) := by
    have := Nat.mul_le_mul (show 4 * R + 1 ≤ 3 * (s + R) by omega) (show 4 * R - 2 ≤ 3 * (s + R - 1) by omega)
    obtain ⟨k, rfl⟩ : ∃ k, R = k + 2 := ⟨R - 2, by omega⟩
    have e1 : 4 * (k + 2) - 2 = 4 * k + 6 := by omega
    have e2 : k + 2 - 1 = k + 1 := by omega
    rw [e1] at this; rw [e2]
    nlinarith
  omega

/-- **Proposition 2, S11.** A class and two foreign primes: SAFE ≤ C(n,2)/16. -/
theorem s11_ceiling (C : Config) (hC : GAdm C) {F c d r1 t1 r2 t2 : ℕ}
    (hparts : C.parts.Perm [.pc F c d, .fr r1 t1, .fr r2 t2]) (h12 : r1 < r2) :
    16 * C.safe ≤ pairs C.n := by
  have x0 : CPart.pc F c d ∈ C.parts := hparts.mem_iff.mpr (by simp)
  have x1 : CPart.fr r1 t1 ∈ C.parts := hparts.mem_iff.mpr (by simp)
  have x2 : CPart.fr r2 t2 ∈ C.parts := hparts.mem_iff.mpr (by simp)
  have hR := foreign_pair C hC x1 x2 h12
  have hc : C.safe ≤ pairs (F * c) :=
    le_trans (minL_le (List.mem_append_left _ (List.mem_flatMap.mpr
      ⟨_, x0, by simp [CPart.safeTerms, Part.terms]⟩))) (mul_pairs_le F c)
  have hn : C.n = F * c + (r1 + r2) := by
    simp only [Config.n, Config.sizes]; rw [(hparts.map _).sum_eq]; simp [CPart.sizeC]
  have := two_pairs (F * c)
  have := two_pairs C.n
  have p1 := (hC.2.2.1 _ x1).1.two_le
  have := s11_arith (s := F * c) (x := C.safe) (by omega) hR (by omega)
  rw [← hn] at this
  omega

/-! ## Strictly: neither ceiling is attained -/

theorem foreign_pair_lt (C : Config) (hC : GAdm C) {r1 t1 r2 t2 : ℕ}
    (x1 : CPart.fr r1 t1 ∈ C.parts) (x2 : CPart.fr r2 t2 ∈ C.parts) (h12 : r1 < r2) :
    18 * C.safe < (r1 + r2) * (r1 + r2 - 1) := by
  obtain ⟨-, hq, hall, -⟩ := hC
  obtain ⟨pr1, -, d1, f1, rfl⟩ := hall _ x1
  obtain ⟨pr2, -, d2, f2, rfl⟩ := hall _ x2
  have s1 := safe_le_orb_of x1
  have s2 := safe_le_orb_of x2
  rcases two_foreign_lt hq pr1 pr2 h12 d1 d2 with h | h <;> omega

/-- **S6, strictly:** 9·SAFE < C(n,2). -/
theorem s6_ceiling_lt (C : Config) (hC : GAdm C) {r1 t1 r2 t2 : ℕ}
    (hparts : C.parts.Perm [.fr r1 t1, .fr r2 t2]) (h12 : r1 < r2) :
    9 * C.safe < pairs C.n := by
  have x1 : CPart.fr r1 t1 ∈ C.parts := hparts.mem_iff.mpr (by simp)
  have x2 : CPart.fr r2 t2 ∈ C.parts := hparts.mem_iff.mpr (by simp)
  have h := foreign_pair_lt C hC x1 x2 h12
  have hn : C.n = r1 + r2 := by
    simp only [Config.n, Config.sizes]; rw [(hparts.map _).sum_eq]; simp [CPart.sizeC]
  have := two_pairs C.n
  rw [hn] at this ⊢
  omega

theorem s11_arith_lt {s R x : ℕ} (hs : 2 * x ≤ s * (s - 1)) (hR : 18 * x < R * (R - 1)) (hR2 : 2 ≤ R) :
    32 * x < (s + R) * (s + R - 1) := by
  by_contra hlt
  push Not at hlt
  have h3 : R + 1 ≤ 3 * s := by
    by_contra h
    have : 4 * s * (4 * s - 1) ≤ (s + R) * (s + R - 1) :=
      Nat.mul_le_mul (by omega) (by omega)
    rcases Nat.eq_zero_or_pos s with h0 | h0
    · subst h0
      have : 2 * 1 ≤ R * (R - 1) := Nat.mul_le_mul hR2 (by omega)
      simp at hs; subst hs; simp at hlt; omega
    · have : 16 * (s * (s - 1)) < 4 * s * (4 * s - 1) := by
        obtain ⟨k, rfl⟩ : ∃ k, s = k + 1 := ⟨s - 1, by omega⟩
        have e1 : 4 * (k + 1) - 1 = 4 * k + 3 := by omega
        rw [e1, Nat.add_sub_cancel]; nlinarith
      omega
  have h9 : 16 * (R * (R - 1)) ≤ 9 * ((s + R) * (s + R - 1)) := by
    have := Nat.mul_le_mul (show 4 * R + 1 ≤ 3 * (s + R) by omega) (show 4 * R - 2 ≤ 3 * (s + R - 1) by omega)
    obtain ⟨k, rfl⟩ : ∃ k, R = k + 2 := ⟨R - 2, by omega⟩
    have e1 : 4 * (k + 2) - 2 = 4 * k + 6 := by omega
    have e2 : k + 2 - 1 = k + 1 := by omega
    rw [e1] at this; rw [e2]
    nlinarith
  omega

/-- **S11, strictly:** 16·SAFE < C(n,2). -/
theorem s11_ceiling_lt (C : Config) (hC : GAdm C) {F c d r1 t1 r2 t2 : ℕ}
    (hparts : C.parts.Perm [.pc F c d, .fr r1 t1, .fr r2 t2]) (h12 : r1 < r2) :
    16 * C.safe < pairs C.n := by
  have x0 : CPart.pc F c d ∈ C.parts := hparts.mem_iff.mpr (by simp)
  have x1 : CPart.fr r1 t1 ∈ C.parts := hparts.mem_iff.mpr (by simp)
  have x2 : CPart.fr r2 t2 ∈ C.parts := hparts.mem_iff.mpr (by simp)
  have hR := foreign_pair_lt C hC x1 x2 h12
  have hc : C.safe ≤ pairs (F * c) :=
    le_trans (minL_le (List.mem_append_left _ (List.mem_flatMap.mpr
      ⟨_, x0, by simp [CPart.safeTerms, Part.terms]⟩))) (mul_pairs_le F c)
  have hn : C.n = F * c + (r1 + r2) := by
    simp only [Config.n, Config.sizes]; rw [(hparts.map _).sum_eq]; simp [CPart.sizeC]
  have := two_pairs (F * c)
  have := two_pairs C.n
  have p1 := (hC.2.2.1 _ x1).1.two_le
  have := s11_arith_lt (s := F * c) (x := C.safe) (by omega) hR (by omega)
  rw [← hn] at this
  omega

end TwoForeign

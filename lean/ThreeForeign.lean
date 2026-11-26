/-
# `ThreeForeign.lean` — Proposition 1: no configuration above 1/25 has three foreign primes

`ladder-completeness.md` Proposition 1's "three or more foreign primes" bullet, proved for
every q and every exponent (`no_three_foreign`).  The text argues by a continuous enumeration
for q ≤ 31 (best min ηy² = 0.037) plus a ratio argument for q ≥ 37; this is an exact proof.

**Normal form.** Let T = q^m be the least twist.  Then rⱼ = aⱼ·T + 1 and tⱼ = bⱼ·T with
bⱼ = q^(eⱼ) ∣ aⱼ, some bⱼ = 1, and a₁ < a₂ < a₃ (distinct primes).  With A = Σ aⱼ and
n ≥ A·T + 3, each part gives (`PartH`):
* share: A < 5aⱼ (`Prop1.part_share`);
* E: A²T² + 5AT + 6 < 25c·aⱼbⱼT² + 25c·bⱼT, from 2·orb ≤ c·r·t, where c = 1 if q = 2 and
  t ≥ 2 (the orbit count halves), else c = 2 (`two_orb_le`, `cOf`);
* P: A²T² + 5AT + 6 < 25aⱼ²T² + 25aⱼT, from orb ≤ C(r, 2);
* parity: if q is odd or T = 1, aⱼ is even or aⱼ = 1 (rⱼ is prime).

**Bounding.** The part with bⱼ = 1 has 5aⱼ < 3A (the other two have share > 1/5), and its E
bound then gives A ≤ 31 (`A_le`).  So aⱼ ≤ 31, bⱼ ≤ 31, and q ≤ 31 unless every bⱼ = 1.

**The check.** For every surviving pattern some part *kills* it: one of its two bounds has
leading coefficient ≤ A² and linear coefficient ≤ 5A, so it fails at every T ≥ 1
(`kill`, `kill_sound`).  No T enumeration is needed.  `checkQ` runs this over all patterns, one
kernel computation per q ≤ 31 (`chk2` … `chk31`) and one for q ≥ 32 (`chkBig`, all bⱼ = 1, q odd);
about two minutes in all.
-/
import Prop1

namespace ThreeForeign
open E6 ArkCore E5Assembly

/-- One part kills the pattern: one of its two bounds has leading coefficient ≤ A² and
linear coefficient ≤ 5A. -/
def kill (A a b c : ℕ) : Bool :=
  (decide (25 * c * a * b ≤ A * A) && decide (25 * c * b ≤ 5 * A)) ||
  (decide (25 * a * a ≤ A * A) && decide (25 * a ≤ 5 * A))

/-- The halving factor: c = 1 when q = 2 and t = b·T ≥ 2 (orb halves), else 2. -/
def cOf (two T1 : Bool) (b : ℕ) : ℕ := if two && (decide (2 ≤ b) || !T1) then 1 else 2

def par (on : Bool) (a : ℕ) : Bool := !on || a % 2 == 0 || a == 1

def checkQ (q : ℕ) (pw : List ℕ) : Bool :=
  (List.range 32).all fun A => (List.range 32).all fun a1 => (List.range 32).all fun a2 =>
    let a3 := A - a1 - a2
    !(a1 + a2 + a3 == A && 1 ≤ a1 && a1 < a2 && a2 < a3 &&
      A < 5 * a1 && A < 5 * a2 && A < 5 * a3) ||
    [true, false].all fun T1 => pw.all fun b1 => pw.all fun b2 => pw.all fun b3 =>
      let two := q == 2
      let on := !two || T1
      !((b1 == 1 || b2 == 1 || b3 == 1) && a1 % b1 == 0 && a2 % b2 == 0 && a3 % b3 == 0 &&
        par on a1 && par on a2 && par on a3) ||
      kill A a1 b1 (cOf two T1 b1) || kill A a2 b2 (cOf two T1 b2) || kill A a3 b3 (cOf two T1 b3)

def pws (q : ℕ) : List ℕ := ((List.range 6).map (q ^ ·)).filter (· ≤ 31)

/-! The finite check, one kernel computation per q (one at a time keeps memory down). -/

theorem chk2 : checkQ 2 (pws 2) = true := by decide +kernel
theorem chk3 : checkQ 3 (pws 3) = true := by decide +kernel
theorem chk4 : checkQ 4 (pws 4) = true := by decide +kernel
theorem chk5 : checkQ 5 (pws 5) = true := by decide +kernel
theorem chk6 : checkQ 6 (pws 6) = true := by decide +kernel
theorem chk7 : checkQ 7 (pws 7) = true := by decide +kernel
theorem chk8 : checkQ 8 (pws 8) = true := by decide +kernel
theorem chk9 : checkQ 9 (pws 9) = true := by decide +kernel
theorem chk10 : checkQ 10 (pws 10) = true := by decide +kernel
theorem chk11 : checkQ 11 (pws 11) = true := by decide +kernel
theorem chk12 : checkQ 12 (pws 12) = true := by decide +kernel
theorem chk13 : checkQ 13 (pws 13) = true := by decide +kernel
theorem chk14 : checkQ 14 (pws 14) = true := by decide +kernel
theorem chk15 : checkQ 15 (pws 15) = true := by decide +kernel
theorem chk16 : checkQ 16 (pws 16) = true := by decide +kernel
theorem chk17 : checkQ 17 (pws 17) = true := by decide +kernel
theorem chk18 : checkQ 18 (pws 18) = true := by decide +kernel
theorem chk19 : checkQ 19 (pws 19) = true := by decide +kernel
theorem chk20 : checkQ 20 (pws 20) = true := by decide +kernel
theorem chk21 : checkQ 21 (pws 21) = true := by decide +kernel
theorem chk22 : checkQ 22 (pws 22) = true := by decide +kernel
theorem chk23 : checkQ 23 (pws 23) = true := by decide +kernel
theorem chk24 : checkQ 24 (pws 24) = true := by decide +kernel
theorem chk25 : checkQ 25 (pws 25) = true := by decide +kernel
theorem chk26 : checkQ 26 (pws 26) = true := by decide +kernel
theorem chk27 : checkQ 27 (pws 27) = true := by decide +kernel
theorem chk28 : checkQ 28 (pws 28) = true := by decide +kernel
theorem chk29 : checkQ 29 (pws 29) = true := by decide +kernel
theorem chk30 : checkQ 30 (pws 30) = true := by decide +kernel
theorem chk31 : checkQ 31 (pws 31) = true := by decide +kernel
theorem chkBig : checkQ 33 [1] = true := by decide +kernel

theorem chk_all (q : ℕ) (h1 : 2 ≤ q) (h2 : q < 32) : checkQ q (pws q) = true := by
  interval_cases q
  
  · exact chk2
  · exact chk3
  · exact chk4
  · exact chk5
  · exact chk6
  · exact chk7
  · exact chk8
  · exact chk9
  · exact chk10
  · exact chk11
  · exact chk12
  · exact chk13
  · exact chk14
  · exact chk15
  · exact chk16
  · exact chk17
  · exact chk18
  · exact chk19
  · exact chk20
  · exact chk21
  · exact chk22
  · exact chk23
  · exact chk24
  · exact chk25
  · exact chk26
  · exact chk27
  · exact chk28
  · exact chk29
  · exact chk30
  · exact chk31

theorem kill_sound {A a b c T : ℕ} (hk : kill A a b c = true)
    (hE : A * A * T * T + 5 * A * T + 6 < 25 * c * a * b * T * T + 25 * c * b * T)
    (hP : A * A * T * T + 5 * A * T + 6 < 25 * a * a * T * T + 25 * a * T) : False := by
  simp only [kill, Bool.or_eq_true, Bool.and_eq_true, decide_eq_true_eq] at hk
  rcases hk with ⟨h1, h2⟩ | ⟨h1, h2⟩
  · have := Nat.mul_le_mul_right (T * T) h1
    have := Nat.mul_le_mul_right T h2
    nlinarith
  · have := Nat.mul_le_mul_right (T * T) h1
    have := Nat.mul_le_mul_right T h2
    nlinarith

theorem cOf_le (two T1 : Bool) (b : ℕ) : cOf two T1 b ≤ 2 := by
  unfold cOf; split <;> omega

/-- Leading-order bound: a part with b = 1 caps A at 31. -/
theorem A_le {A a c T : ℕ} (hT : 1 ≤ T) (hc : c ≤ 2) (h5 : 5 * a < 3 * A)
    (hE : A * A * T * T + 5 * A * T + 6 < 25 * c * a * 1 * T * T + 25 * c * 1 * T) :
    A < 32 := by
  by_contra hA
  have h1 : 25 * c * a * 1 * T * T + 25 * c * 1 * T ≤ 50 * a * T * T + 50 * T := by
    have := Nat.mul_le_mul_right (a * T * T) hc
    have := Nat.mul_le_mul_right T hc
    nlinarith
  have h2 : 50 * a * T * T ≤ 30 * A * T * T := by
    have := Nat.mul_le_mul_right (T * T) h5; nlinarith
  have h3 : 32 * A * T * T ≤ A * A * T * T := by
    have := Nat.mul_le_mul_right (A * T * T) (show 32 ≤ A by omega); nlinarith
  have h4 : 50 * T ≤ 2 * A * T * T := by
    have : 1 * T ≤ T * T := Nat.mul_le_mul_right T hT
    have := Nat.mul_le_mul_left (2 * A) this; nlinarith
  nlinarith

/-- The pattern hypotheses for one part j: b = q^e divides a, parity, share, and the two
bounds E (from orb ≤ c·r·t/2) and P (from orb ≤ C(r,2)). -/
structure PartH (q T A a e : ℕ) : Prop where
  dvd : q ^ e ∣ a
  par : q ≠ 2 ∨ T = 1 → a % 2 = 0 ∨ a = 1
  share : A < 5 * a
  E : A * A * T * T + 5 * A * T + 6 <
    25 * cOf (q == 2) (T == 1) (q ^ e) * a * (q ^ e) * T * T + 25 * cOf (q == 2) (T == 1) (q ^ e) * (q ^ e) * T
  P : A * A * T * T + 5 * A * T + 6 < 25 * a * a * T * T + 25 * a * T

theorem pow_mem_pws {q e a : ℕ} (hq : 2 ≤ q) (ha : a < 32) (h1 : 1 ≤ a) (hd : q ^ e ∣ a) :
    q ^ e ∈ pws q := by
  have hle : q ^ e ≤ 31 := by have := Nat.le_of_dvd (by omega) hd; omega
  have he : e < 6 := by
    by_contra h
    have : 2 ^ 6 ≤ q ^ e := le_trans (Nat.pow_le_pow_left hq 6) (Nat.pow_le_pow_right (by omega) (by omega))
    omega
  simp only [pws, List.mem_filter, List.mem_map, List.mem_range, decide_eq_true_eq]
  exact ⟨⟨e, he, rfl⟩, hle⟩

theorem e_zero {q e a : ℕ} (hq : 32 ≤ q) (ha : a < 32) (h1 : 1 ≤ a) (hd : q ^ e ∣ a) : e = 0 := by
  by_contra h
  have := Nat.le_of_dvd (by omega) hd
  have : q ≤ q ^ e := Nat.le_self_pow h q
  omega

/-- **The arithmetic exclusion.** No pattern a₁ < a₂ < a₃, b_j = q^{e_j} (one of them 1),
T ≥ 1 satisfies every part's hypotheses. -/
theorem core {q T a1 a2 a3 e1 e2 e3 : ℕ} (hq : 2 ≤ q) (hT : 1 ≤ T)
    (h1 : 1 ≤ a1) (h12 : a1 < a2) (h23 : a2 < a3) (he : e1 = 0 ∨ e2 = 0 ∨ e3 = 0)
    (p1 : PartH q T (a1 + a2 + a3) a1 e1) (p2 : PartH q T (a1 + a2 + a3) a2 e2)
    (p3 : PartH q T (a1 + a2 + a3) a3 e3) : False := by
  set A := a1 + a2 + a3 with hAdef
  have hA : A < 32 := by
    rcases he with h | h | h
    · have E := p1.E; rw [h, pow_zero] at E
      exact A_le hT (cOf_le _ _ _) (by have := p2.share; have := p3.share; omega) E
    · have E := p2.E; rw [h, pow_zero] at E
      exact A_le hT (cOf_le _ _ _) (by have := p1.share; have := p3.share; omega) E
    · have E := p3.E; rw [h, pow_zero] at E
      exact A_le hT (cOf_le _ _ _) (by have := p1.share; have := p2.share; omega) E
  have ha1 : a1 < 32 := by omega
  have ha2 : a2 < 32 := by omega
  have ha3 : a3 < 32 := by omega
  -- the finite check, at the right q
  have key : ∀ Q pw, checkQ Q pw = true → (Q == 2) = (q == 2) →
      q ^ e1 ∈ pw → q ^ e2 ∈ pw → q ^ e3 ∈ pw → False := by
    intro Q pw hc hQ m1 m2 m3
    simp only [checkQ, List.all_eq_true, List.mem_range] at hc
    have hc := hc A hA a1 ha1 a2 ha2
    simp only [show A - a1 - a2 = a3 by omega] at hc
    have g1 : (a1 + a2 + a3 == A && 1 ≤ a1 && a1 < a2 && a2 < a3 &&
        A < 5 * a1 && A < 5 * a2 && A < 5 * a3) = true := by
      simp only [Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq]
      exact ⟨⟨⟨⟨⟨⟨rfl, h1⟩, h12⟩, h23⟩, p1.share⟩, p2.share⟩, p3.share⟩
    rw [g1] at hc
    simp only [Bool.not_true, Bool.false_or, List.all_eq_true] at hc
    have hc := hc (T == 1) (by cases (T == 1) <;> simp) (q ^ e1) m1 (q ^ e2) m2 (q ^ e3) m3
    rw [hQ] at hc
    have pa : ∀ a, (q ≠ 2 ∨ T = 1 → a % 2 = 0 ∨ a = 1) → par (!(q == 2) || (T == 1)) a = true := by
      intro a h
      simp only [par, Bool.or_eq_true, beq_iff_eq, Bool.not_eq_eq_eq_not, Bool.not_true]
      by_cases hq2 : q = 2 <;> by_cases hT1 : T = 1 <;> simp_all
    have g2 : ((q ^ e1 == 1 || q ^ e2 == 1 || q ^ e3 == 1) && a1 % q ^ e1 == 0 && a2 % q ^ e2 == 0 &&
        a3 % q ^ e3 == 0 && par (!(q == 2) || (T == 1)) a1 && par (!(q == 2) || (T == 1)) a2 &&
        par (!(q == 2) || (T == 1)) a3) = true := by
      simp only [Bool.and_eq_true, Bool.or_eq_true, beq_iff_eq]
      refine ⟨⟨⟨⟨⟨⟨?_, Nat.mod_eq_zero_of_dvd p1.dvd⟩,
        Nat.mod_eq_zero_of_dvd p2.dvd⟩, Nat.mod_eq_zero_of_dvd p3.dvd⟩, pa _ p1.par⟩, pa _ p2.par⟩,
        pa _ p3.par⟩
      rcases he with h | h | h <;> simp [h]
    simp only [g2, Bool.not_true, Bool.false_or, Bool.or_eq_true] at hc
    rcases hc with (k | k) | k
    · exact kill_sound k p1.E p1.P
    · exact kill_sound k p2.E p2.P
    · exact kill_sound k p3.E p3.P
  by_cases hq32 : q < 32
  · exact key q (pws q) (chk_all q hq hq32) rfl (pow_mem_pws hq (by omega) (by omega) p1.dvd)
        (pow_mem_pws hq (by omega) (by omega) p2.dvd) (pow_mem_pws hq (by omega) (by omega) p3.dvd)
  · have q2 : q ≠ 2 := by omega
    have z1 := e_zero (by omega) ha1 (by omega) p1.dvd
    have z2 := e_zero (by omega) ha2 (by omega) p2.dvd
    have z3 := e_zero (by omega) ha3 (by omega) p3.dvd
    refine key 33 [1] chkBig (by simp [q2]) ?_ ?_ ?_ <;> simp [z1, z2, z3]

/-! ## From the model to the pattern -/

theorem two_orb_le (r t : ℕ) (c : ℕ) (hc : c = 1 → t % 2 = 0) (hc2 : c = 1 ∨ c = 2) :
    2 * orb r t false ≤ c * (r * t) := by
  rcases hc2 with rfl | rfl
  · have ht := hc rfl
    unfold orb
    have : (if false = true ∨ t % 2 = 0 then r * t / 2 else r * t) = r * t / 2 := by simp [ht]
    have := Nat.min_le_left (if false = true ∨ t % 2 = 0 then r * t / 2 else r * t) (pairs r)
    have := Nat.div_mul_le_self (r * t) 2
    omega
  · have := E5Core.orb_le_mul r t false; omega

theorem cOf_cases (two T1 : Bool) (b : ℕ) : cOf two T1 b = 1 ∨ cOf two T1 b = 2 := by
  unfold cOf; split <;> simp

theorem share_arith {n A a T : ℕ} (h3 : A * T + 3 ≤ n) (hsh : n + 3 ≤ 5 * (a * T + 1)) :
    A < 5 * a := by
  by_contra h
  have := Nat.mul_le_mul_right T (show 5 * a ≤ A by omega)
  have e : 5 * a * T = 5 * (a * T) := by ring
  omega

theorem E_arith {n s o X c a b T : ℕ} (hnn : X ≤ n * (n - 1)) (h2 : 2 * pairs n = n * (n - 1))
    (hab : pairs n < 25 * s) (hs : s ≤ o) (ho : 2 * o ≤ c * ((a * T + 1) * (T * b))) :
    X < 25 * c * a * b * T * T + 25 * c * b * T := by
  have e : 25 * (c * ((a * T + 1) * (T * b))) = 25 * c * a * b * T * T + 25 * c * b * T := by ring
  omega

theorem P_arith {n s o X a T : ℕ} (hnn : X ≤ n * (n - 1)) (h2 : 2 * pairs n = n * (n - 1))
    (hab : pairs n < 25 * s) (hs : s ≤ o) (ho : o ≤ pairs (a * T + 1)) :
    X < 25 * a * a * T * T + 25 * a * T := by
  have h3 := two_pairs (a * T + 1)
  rw [Nat.add_sub_cancel] at h3
  have e : 25 * ((a * T + 1) * (a * T)) = 25 * a * a * T * T + 25 * a * T := by ring
  omega

theorem par_arith {q T a r m : ℕ} (hq : Nat.Prime q) (pr : Nat.Prime r) (hrT : r = a * T + 1)
    (hT : T = q ^ m) : q ≠ 2 ∨ T = 1 → a % 2 = 0 ∨ a = 1 := by
  intro h
  rcases pr.eq_two_or_odd with h2 | h2
  · right; rw [h2] at hrT
    have h1 : a * T = 1 := by omega
    exact Nat.eq_one_of_mul_eq_one_right h1
  · left
    rcases h with hq' | hT1
    · have qodd : q % 2 = 1 := by
        rcases hq.eq_two_or_odd with h | h
        · exact absurd h hq'
        · exact h
      have Todd : T % 2 = 1 := by rw [hT, Nat.pow_mod, qodd]; simp
      have : (a * T) % 2 = 0 := by omega
      rw [Nat.mul_mod, Todd] at this; simpa using this
    · rw [hT1] at hrT; omega

theorem c_arith {q T f m : ℕ} (hT : T = q ^ m) (hf : m ≤ f) :
    cOf (q == 2) (T == 1) (q ^ (f - m)) = 1 → (q ^ f) % 2 = 0 := by
  intro hc1
  unfold cOf at hc1
  split at hc1
  · rename_i hcond
    simp only [Bool.and_eq_true, beq_iff_eq, Bool.or_eq_true, decide_eq_true_eq,
      Bool.not_eq_eq_eq_not, Bool.not_true, beq_eq_false_iff_ne] at hcond
    obtain ⟨hq2, hb⟩ := hcond
    subst hq2
    have : 1 ≤ f := by
      rcases hb with hb | hb
      · by_contra h0
        have : f - m = 0 := by omega
        rw [this] at hb; simp at hb
      · by_contra h0
        have : m = 0 := by omega
        exact hb (by rw [hT, this, pow_zero])
    obtain ⟨g, rfl⟩ : ∃ g, f = g + 1 := ⟨f - 1, by omega⟩
    rw [pow_succ]; simp
  · omega

/-- One foreign part's pattern hypotheses, from the model. -/
theorem part_of (C : Config) (hq : Nat.Prime C.q) {A T m r f a : ℕ}
    (hx : CPart.fr r (C.q ^ f) ∈ C.parts) (pr : Nat.Prime r) (hf : m ≤ f) (hT : T = C.q ^ m)
    (hra : r - 1 = a * T) (hdv : C.q ^ (f - m) ∣ a) (h3 : A * T + 3 ≤ C.n)
    (habove : pairs C.n < 25 * C.safe) : PartH C.q T A a (f - m) := by
  have hrT : r = a * T + 1 := by have := pr.two_le; omega
  have hsh := Prop1.part_share C hx habove
  simp only [CPart.sizeC] at hsh
  have hob : C.safe ≤ orb r (C.q ^ f) false :=
    minL_le (List.mem_append_left _ (List.mem_flatMap.mpr ⟨_, hx, by simp [CPart.safeTerms]⟩))
  have hnn : A * A * T * T + 5 * A * T + 6 ≤ C.n * (C.n - 1) := by
    have h := Nat.mul_le_mul h3 (show A * T + 2 ≤ C.n - 1 by omega)
    have e : (A * T + 3) * (A * T + 2) = A * A * T * T + 5 * A * T + 6 := by ring
    omega
  have two := two_pairs C.n
  have hsplit : C.q ^ f = T * C.q ^ (f - m) := by rw [hT, ← pow_add]; congr 1; omega
  refine ⟨hdv, par_arith hq pr hrT hT, share_arith h3 (by rw [← hrT]; exact hsh), ?_, ?_⟩
  · have h2o := two_orb_le r (C.q ^ f) (cOf (C.q == 2) (T == 1) (C.q ^ (f - m)))
      (c_arith hT hf) (cOf_cases _ _ _)
    rw [hsplit, hrT] at h2o
    rw [hsplit, hrT] at hob
    exact E_arith hnn two habove hob h2o
  · have hp := orb_le_pairs r (C.q ^ f) false
    rw [hrT] at hp hob
    exact P_arith hnn two habove hob hp

/-- **Proposition 1, three foreign primes — excluded.** No admissible configuration above
the line has three foreign parts with primes r₁ < r₂ < r₃ (any further parts allowed). -/
theorem no_three_foreign (C : Config) (hC : GAdm C) {r1 t1 r2 t2 r3 t3 : ℕ} {rest : List CPart}
    (hparts : C.parts.Perm (.fr r1 t1 :: .fr r2 t2 :: .fr r3 t3 :: rest))
    (h12 : r1 < r2) (h23 : r2 < r3) (habove : pairs C.n < 25 * C.safe) : False := by
  obtain ⟨-, hq, hall, -⟩ := hC
  have hq2 : 2 ≤ C.q := hq.two_le
  have mem : ∀ x, x ∈ (CPart.fr r1 t1 :: .fr r2 t2 :: .fr r3 t3 :: rest) → x ∈ C.parts :=
    fun x hx => hparts.mem_iff.mpr hx
  have x1 := mem (.fr r1 t1) (by simp)
  have x2 := mem (.fr r2 t2) (by simp)
  have x3 := mem (.fr r3 t3) (by simp)
  obtain ⟨pr1, -, d1, f1, rfl⟩ := hall _ x1
  obtain ⟨pr2, -, d2, f2, rfl⟩ := hall _ x2
  obtain ⟨pr3, -, d3, f3, rfl⟩ := hall _ x3
  have hn : r1 + r2 + r3 ≤ C.n := by
    have : C.n = ((CPart.fr r1 (C.q ^ f1) :: .fr r2 (C.q ^ f2) :: .fr r3 (C.q ^ f3) :: rest).map
        CPart.sizeC).sum := by
      simp only [Config.n, Config.sizes]; exact (hparts.map _).sum_eq
    rw [this]; simp only [List.map_cons, List.sum_cons, CPart.sizeC]; omega
  obtain ⟨m, hm⟩ : ∃ m, m = min f1 (min f2 f3) := ⟨_, rfl⟩
  obtain ⟨T, hT⟩ : ∃ T, T = C.q ^ m := ⟨_, rfl⟩
  have hT1 : 1 ≤ T := by rw [hT]; exact Nat.one_le_pow _ _ (by omega)
  have decomp : ∀ r f, m ≤ f → C.q ^ f ∣ r - 1 → ∃ a, r - 1 = a * T ∧ C.q ^ (f - m) ∣ a := by
    intro r f hf hd
    have : C.q ^ f = T * C.q ^ (f - m) := by rw [hT, ← pow_add]; congr 1; omega
    rw [this] at hd
    obtain ⟨k, hk⟩ := hd
    exact ⟨C.q ^ (f - m) * k, by rw [hk]; ring, dvd_mul_right _ _⟩
  obtain ⟨a1, ha1, dv1⟩ := decomp r1 f1 (by omega) d1
  obtain ⟨a2, ha2, dv2⟩ := decomp r2 f2 (by omega) d2
  obtain ⟨a3, ha3, dv3⟩ := decomp r3 f3 (by omega) d3
  have r1p := pr1.two_le
  have ha1p : 1 ≤ a1 := by
    rcases Nat.eq_zero_or_pos a1 with h | h
    · rw [h, zero_mul] at ha1; omega
    · exact h
  have lt12 : a1 < a2 := by
    by_contra h; have := Nat.mul_le_mul_right T (show a2 ≤ a1 by omega); omega
  have lt23 : a2 < a3 := by
    by_contra h; have := Nat.mul_le_mul_right T (show a3 ≤ a2 by omega); omega
  have h3 : (a1 + a2 + a3) * T + 3 ≤ C.n := by
    have e : (a1 + a2 + a3) * T = a1 * T + a2 * T + a3 * T := by ring
    omega
  have p1 := part_of C hq x1 pr1 (by omega) hT ha1 dv1 h3 habove
  have p2 := part_of C hq x2 pr2 (by omega) hT ha2 dv2 h3 habove
  have p3 := part_of C hq x3 pr3 (by omega) hT ha3 dv3 h3 habove
  have he : f1 - m = 0 ∨ f2 - m = 0 ∨ f3 - m = 0 := by omega
  exact core hq2 hT1 ha1p lt12 lt23 he p1 p2 p3

end ThreeForeign

/-
# `E5Core.lean` — the arithmetic of Theorem E.5, in core Lean (no Mathlib)

Theorem E.5 (`enumeration-proof.md` Part E‴): a fallback configuration that is not a bare
safe-prime pair has SAFE < C(n,2)/25, with 12 listed exceptions at n ≤ 63.  This file proves
the **counting and congruence steps** of that proof over ℕ, in the style of `ArkCore.lean`:
`δ < 1/25` is written `25 * B < pairs n`, so no reals or square roots appear.

**What is proved here.**
* `sladder_strict` — the E′ s-ladder in counting form: a foreign block r with B ≤ C(r,2) and
  n ≥ (s+1)r + 1 gives (s+1)²·B < C(n,2).  Instances: the s ≥ 4 branch, the F ≥ 2 and
  p-characteristic-leftover sub-cases (n ≥ 5r + 2), and the two-part leftover.
* `count_5r` — the n = 5r sub-case (one foreign leftover, odd q).
* `two_part_leftover` — the leftover-of-two-parts sub-case, both orderings of r and ℓ.
* `odd_twist_forces_two` — for odd q: (r−1)/t ≤ 3 with t odd forces r − 1 = 2t.
* `window_odd_q` — the ratio-window step: with t, t′ powers of one odd q, r = 2t + 1,
  r′ = j′t′ + 1 (j′ ∈ {2, 4, 6}), 3r < 4r′, r′ < 2r and r′ ≠ r, the only possibility is
  r′ = 2r − 1.  The power-of-q structure enters only through `PowRel` below.
* `fermat_c_div5`, `three_c_div3` — the q = 2 divisibility facts.
* finite checks: the q = 2 survivors n ∈ {15, 23}, and E.4's (16, 5) pair.
* `lemma_E2` — every prime power dividing 2^(2m) − 1 is ≤ 2^m + 1 (via
  `prime_pow_dvd_coprime` and `gcd_two_pow_pm`; primality is `IsPrimeN`, since core Lean has
  no `Nat.Prime`).
* `mersenne_window`, `e1_mersenne` — Theorem E.1's cap clears C(n,2)/25 at every n ≥ 2^(a+1) − 1
  once a = 2m + 1 ≥ 7, so the Mersenne exceptions are confined to a ∈ {2, 3, 5}; `twist_split`
  supplies E.1's case split on the twist.
* `lemma_E2_three`, `repunit_window`, `e3_repunit` — Theorem E.3(iii)'s cap clears C(n,2)/25 at
  every n ≥ c + r once a = 2m + 1 ≥ 5, so the only repunit exception is a = 3, the (27, 13) row;
  `twist_split3` is its case split.

**What is NOT here.** The group theory (Lemma B′, the SAFE terms themselves), the twist
classification behind `PowRel` (that two powers of one prime are equal or differ by a factor
≥ q), and the exceptions themselves — a ∈ {2, 3, 5} Mersenne and a = 3 repunit, the
table's 12 rows, checked by `fallback_sup.py`.  Those are stated as hypotheses where
used, or not at all.

Compile: `lean -o ArkCore.olean ArkCore.lean`, then `LEAN_PATH=<dir of ArkCore.olean> lean E5Core.lean`.
A silent compile is the evidence of zero `sorry`.
-/
import ArkCore

namespace E5Core
open ArkCore

/-- **The s-ladder, counting form.**  A foreign block of size r ≥ 1 with B ≤ C(r,2), inside
n ≥ (s+1)·r + 1 points, gives (s+1)²·B < C(n,2) — i.e. δ < 1/(s+1)², strictly. -/
theorem sladder_strict (s r n B : Nat) (hr : 1 ≤ r) (hB : B ≤ pairs r)
    (hn : (s + 1) * r + 1 ≤ n) : (s + 1) ^ 2 * B < pairs n := by
  have h2r := two_pairs r
  have h2n := two_pairs n
  -- k = s + 1, x = k * r
  generalize hk : s + 1 = k at hn ⊢
  have hk1 : 1 ≤ k := by omega
  generalize hx : k * r = x at hn
  have hx1 : 1 ≤ x := by
    have : 1 * 1 ≤ k * r := Nat.mul_le_mul hk1 hr
    omega
  -- k²·r(r−1) ≤ x·(x−1)
  have hkr : k ^ 2 * (r * (r - 1)) ≤ x * (x - 1) := by
    have e1 : k ^ 2 * (r * (r - 1)) = (k * r) * (k * (r - 1)) := by
      rw [Nat.pow_two]; ac_rfl
    have e2 : k * (r - 1) ≤ x - 1 := by
      have : k * (r - 1) = k * r - k := by rw [Nat.mul_sub_one]
      omega
    rw [e1, hx]
    exact Nat.mul_le_mul_left x e2
  -- x·(x−1) < (x+1)·x ≤ n·(n−1)
  have hlt : x * (x - 1) < (x + 1) * x := by
    have e1 : (x + 1) * x = x * x + x := by rw [Nat.add_mul, Nat.one_mul]
    have e2 : x * (x - 1) = x * x - x := by rw [Nat.mul_sub_one]
    have e3 : x ≤ x * x := by
      have : 1 * x ≤ x * x := Nat.mul_le_mul_right x hx1
      omega
    omega
  have hle : (x + 1) * x ≤ n * (n - 1) := Nat.mul_le_mul hn (by omega)
  have hB2 : k ^ 2 * (2 * B) ≤ k ^ 2 * (r * (r - 1)) := by
    rw [← h2r]; exact Nat.mul_le_mul_left _ (by omega)
  have : 2 * (k ^ 2 * B) < 2 * pairs n := by
    rw [h2n]
    calc 2 * (k ^ 2 * B) = k ^ 2 * (2 * B) := by ac_rfl
      _ ≤ k ^ 2 * (r * (r - 1)) := hB2
      _ ≤ x * (x - 1) := hkr
      _ < (x + 1) * x := hlt
      _ ≤ n * (n - 1) := hle
  omega

/-- The s ≥ 4 branch: δ < 1/(s+1)² ≤ 1/25. -/
theorem s_ge_four (s r n B : Nat) (hs : 4 ≤ s) (hr : 1 ≤ r) (hB : B ≤ pairs r)
    (hn : (s + 1) * r + 1 ≤ n) : 25 * B < pairs n := by
  have h := sladder_strict s r n B hr hB hn
  have h25 : 25 ≤ (s + 1) ^ 2 := by
    have : 5 * 5 ≤ (s + 1) * (s + 1) := Nat.mul_le_mul (by omega) (by omega)
    rw [Nat.pow_two]; omega
  have : 25 * B ≤ (s + 1) ^ 2 * B := Nat.mul_le_mul_right B h25
  omega

/-- Sub-cases "F ≥ 2" and "F = 1 with a p-characteristic leftover" of the a = 1, s = 2
branch: n ≥ 5r + 2 (indeed 5r + 1 suffices). -/
theorem count_5r1 (r n B : Nat) (hr : 1 ≤ r) (hB : B ≤ pairs r) (hn : 5 * r + 1 ≤ n) :
    25 * B < pairs n := by
  have h := sladder_strict 4 r n B hr hB (by omega)
  simpa using h

/-- Sub-case "one foreign leftover, q odd": n = 5r exactly. -/
theorem count_5r (r n B : Nat) (hr : 1 ≤ r) (hB : B ≤ pairs r) (hn : n = 5 * r) :
    25 * B < pairs n := by
  have h2r := two_pairs r
  have h2n := two_pairs n
  subst hn
  -- 25·r(r−1) < 5r(5r−1), i.e. 25r(r−1) < 25r·r − 5r
  have hrr : r * r = r * (r - 1) + r := by
    have h0 : r - 1 + 1 = r := by omega
    calc r * r = r * (r - 1 + 1) := by rw [h0]
      _ = r * (r - 1) + r := by rw [Nat.mul_add, Nat.mul_one]
  have hn' : 5 * r * (5 * r - 1) = 25 * (r * r) - 5 * r := by
    rw [Nat.mul_sub_one]
    have : 5 * r * (5 * r) = 25 * (r * r) := by ac_rfl
    omega
  omega

/-- Sub-case "two or more leftover parts": with c = 2r + 1, the configuration has
n ≥ c + r + 2ℓ = 3r + 1 + 2ℓ, every part clears B, so B ≤ C(r,2) and B ≤ C(ℓ,2). -/
theorem two_part_leftover (r l n B : Nat) (hr : 1 ≤ r) (hl : 1 ≤ l)
    (hBr : B ≤ pairs r) (hBl : B ≤ pairs l) (hn : 3 * r + 1 + 2 * l ≤ n) :
    25 * B < pairs n := by
  rcases Nat.le_total r l with h | h
  · exact count_5r1 r n B hr hBr (by omega)
  · exact count_5r1 l n B hl hBl (by omega)

/-- **Odd q forces s′ = 2 on the first foreign block.**  r − 1 = j·t with t odd, r odd,
j ≤ 3, j ≥ 1: the parity of r − 1 forces j = 2. -/
theorem odd_twist_forces_two (r t j : Nat) (ht : t % 2 = 1) (hr : r % 2 = 1) (hr3 : 3 ≤ r)
    (hj : r - 1 = j * t) (hj3 : j ≤ 3) (hj1 : 1 ≤ j) : r - 1 = 2 * t := by
  rcases (by omega : j = 1 ∨ j = 2 ∨ j = 3) with h | h | h
  · subst h; omega
  · subst h; omega
  · subst h; omega

/-- How two powers of one odd prime q ≥ 3 compare: equal, or one is m times the other with
m ≥ 3 odd.  (`PowRel t t'` is the only property of the twists the window step uses.) -/
def PowRel (t t' : Nat) : Prop :=
  t = t' ∨ (∃ m, 3 ≤ m ∧ m % 2 = 1 ∧ t' = m * t) ∨ (∃ m, 3 ≤ m ∧ m % 2 = 1 ∧ t = m * t')

/-- **The ratio-window step, odd q.**  r = 2t + 1, r′ = j′·t′ + 1 with j′ ∈ {2, 4, 6},
3r < 4r′ and r′ < 2r (from both foreign blocks clearing C(n,2)/25), r′ ≠ r: then
r′ = 2r − 1, hence n = 3r + r′ + 1 = 5r. -/
theorem window_odd_q (t t' j' r r' : Nat) (ht : 1 ≤ t) (ht' : 1 ≤ t')
    (hrel : PowRel t t') (hr : r = 2 * t + 1) (hr' : r' = j' * t' + 1)
    (hj : j' = 2 ∨ j' = 4 ∨ j' = 6)
    (hlo : 3 * r < 4 * r') (hhi : r' < 2 * r) (hne : r' ≠ r) : r' = 2 * r - 1 := by
  rcases hrel with h | ⟨m, hm3, hmo, hm⟩ | ⟨m, hm3, hmo, hm⟩
  · subst h; rcases hj with h | h | h <;> subst h <;> omega
  · -- t' = m t ≥ 3t: r' ≥ 2t' + 1 ≥ 6t + 1 > 2r
    have : 3 * t ≤ t' := by rw [hm]; exact Nat.mul_le_mul_right t hm3
    rcases hj with h | h | h <;> subst h <;> omega
  · -- t = m t' with m ≥ 3 odd
    rcases (by omega : m = 3 ∨ 5 ≤ m) with h3 | h5
    · subst h3; rcases hj with h | h | h <;> subst h <;> omega
    · have : 5 * t' ≤ t := by rw [hm]; exact Nat.mul_le_mul_right t' h5
      rcases hj with h | h | h <;> subst h <;> omega

/-- q = 2, r a Fermat prime ≥ 17 (r = 2^(2^k) + 1, k ≥ 2): c = 2r + 1 is divisible by 5. -/
theorem fermat_c_div5 (k : Nat) (hk : 2 ≤ k) : (2 * (2 ^ (2 ^ k) + 1) + 1) % 5 = 0 := by
  have h4 : 2 ^ k = 4 * 2 ^ (k - 2) := by
    have : k = (k - 2) + 2 := by omega
    rw [this, Nat.pow_add]; simp [Nat.mul_comm]
  have h16 : ∀ m, 16 ^ m % 5 = 1 := by
    intro m
    induction m with
    | zero => rfl
    | succ m ih => rw [Nat.pow_succ, Nat.mul_mod, ih]
  have hp : 2 ^ (2 ^ k) % 5 = 1 := by
    rw [h4, Nat.pow_mul]
    exact h16 _
  omega

/-- q = 2, r = 3·2^e + 1: c = 2r + 1 is divisible by 3. -/
theorem three_c_div3 (e : Nat) : (2 * (3 * 2 ^ e + 1) + 1) % 3 = 0 := by omega

/-- The two q = 2 survivors.  n = 15: (c, r, r′) = (7, 3, 5), SAFE ≤ orb(3, 2) = 3;
n = 23: (11, 5, 7), SAFE ≤ orb(7, 2) = 7.  Both below C(n,2)/25. -/
theorem q2_survivors : 25 * orb 3 2 false < pairs 15 ∧ 25 * orb 7 2 false < pairs 23 := by
  decide

/-- E.4's pair (16, 5): SAFE ≤ orb(5, 4) = 10, below C(n,2)/25 for every n ≥ 23. -/
theorem e4_pair (n : Nat) (hn : 23 ≤ n) : 25 * orb 5 4 false < pairs n := by
  have h : 25 * orb 5 4 false < pairs 23 := by decide
  exact Nat.lt_of_lt_of_le h (pairs_mono hn)

/-- The threshold 23 in `e4_pair` is sharp: the bound fails at n = 21 (an E.5 exception)
and n = 22 (where no configuration with this pair exists). -/
theorem e4_pair_sharp : ¬ (25 * orb 5 4 false < pairs 21) ∧ ¬ (25 * orb 5 4 false < pairs 22) := by
  decide

/-! ### Lemma E.2 and Theorem E.1's Mersenne window -/

/-- Primality, stated directly (core Lean has no `Nat.Prime`). -/
def IsPrimeN (p : Nat) : Prop := 2 ≤ p ∧ ∀ d, d ∣ p → d = 1 ∨ d = p

/-- A prime coprime to B stays coprime to B in every power. -/
theorem gcd_pow_eq_one (p B : Nat) (h : Nat.gcd B p = 1) : ∀ k, Nat.gcd B (p ^ k) = 1 := by
  intro k
  induction k with
  | zero => simp
  | succ k ih =>
    have h1 := Nat.gcd_mul_dvd_mul_gcd B (p ^ k) p
    rw [← Nat.pow_succ, ih, h, Nat.one_mul] at h1
    exact Nat.eq_one_of_dvd_one h1

/-- If gcd(d, B) = 1 and d ∣ A·B then d ∣ A. -/
theorem dvd_of_dvd_mul_coprime (d A B : Nat) (h : Nat.gcd d B = 1) (hd : d ∣ A * B) : d ∣ A := by
  have h1 := Nat.gcd_mul_dvd_mul_gcd d A B
  rw [h, Nat.mul_one, Nat.gcd_eq_left hd] at h1
  exact Nat.dvd_trans h1 (Nat.gcd_dvd_right d A)

/-- **A prime power dividing a product of coprime factors divides one of them.** -/
theorem prime_pow_dvd_coprime (p k A B : Nat) (hp : IsPrimeN p) (hAB : Nat.gcd A B = 1)
    (hd : p ^ k ∣ A * B) : p ^ k ∣ A ∨ p ^ k ∣ B := by
  -- p cannot divide both A and B
  by_cases hB : p ∣ B
  · -- then p ∤ A, so gcd(A, p) = 1
    have hA : Nat.gcd A p = 1 := by
      rcases hp.2 (Nat.gcd A p) (Nat.gcd_dvd_right A p) with h | h
      · exact h
      · exfalso
        have hpA : p ∣ A := h ▸ Nat.gcd_dvd_left A p
        have : p ∣ Nat.gcd A B := Nat.dvd_gcd hpA hB
        rw [hAB] at this
        have := Nat.eq_one_of_dvd_one this
        have := hp.1; omega
    have hg : Nat.gcd (p ^ k) A = 1 := by rw [Nat.gcd_comm]; exact gcd_pow_eq_one p A hA k
    right
    exact dvd_of_dvd_mul_coprime (p ^ k) B A hg (by rw [Nat.mul_comm]; exact hd)
  · have hB1 : Nat.gcd B p = 1 := by
      rcases hp.2 (Nat.gcd B p) (Nat.gcd_dvd_right B p) with h | h
      · exact h
      · exact absurd (h ▸ Nat.gcd_dvd_left B p) hB
    have hg : Nat.gcd (p ^ k) B = 1 := by rw [Nat.gcd_comm]; exact gcd_pow_eq_one p B hB1 k
    left
    exact dvd_of_dvd_mul_coprime (p ^ k) A B hg hd

/-- 2^m − 1 and 2^m + 1 are coprime (m ≥ 1). -/
theorem gcd_two_pow_pm (m : Nat) (hm : 1 ≤ m) : Nat.gcd (2 ^ m - 1) (2 ^ m + 1) = 1 := by
  have hx : 2 ≤ 2 ^ m := by
    have := Nat.one_lt_two_pow (n := m) (by omega); omega
  have hodd : (2 ^ m + 1) % 2 = 1 := by
    have : 2 ^ m % 2 = 0 := by
      have : 2 ^ m = 2 * 2 ^ (m - 1) := by
        rw [← Nat.pow_succ']; congr 1; omega
      omega
    omega
  generalize hg : Nat.gcd (2 ^ m - 1) (2 ^ m + 1) = g
  have h1 : g ∣ 2 ^ m - 1 := hg ▸ Nat.gcd_dvd_left _ _
  have h2 : g ∣ 2 ^ m + 1 := hg ▸ Nat.gcd_dvd_right _ _
  have h3 : g ∣ (2 ^ m + 1) - (2 ^ m - 1) := Nat.dvd_sub (by omega) h2 h1
  have h4 : (2 ^ m + 1) - (2 ^ m - 1) = 2 := by omega
  rw [h4] at h3
  have hle : g ≤ 2 := Nat.le_of_dvd (by omega) h3
  rcases (by omega : g = 0 ∨ g = 1 ∨ g = 2) with h | h | h
  · subst h; rw [Nat.zero_dvd] at h3; omega
  · exact h
  · subst h
    have := Nat.mod_eq_zero_of_dvd h2
    omega

/-- (x − 1)(x + 1) = x² − 1 over ℕ, for x ≥ 1. -/
theorem sq_sub_one (x : Nat) (hx : 1 ≤ x) : (x - 1) * (x + 1) = x * x - 1 := by
  have e1 : (x - 1) * (x + 1) = (x - 1) * x + (x - 1) := by rw [Nat.mul_add, Nat.mul_one]
  have e2 : (x - 1) * x = x * x - x := by rw [Nat.sub_one_mul]
  have e3 : x ≤ x * x := by
    have : 1 * x ≤ x * x := Nat.mul_le_mul_right x hx
    omega
  omega

/-- **Lemma E.2.**  Every prime power dividing 2^(2m) − 1 is at most 2^m + 1 (m ≥ 1). -/
theorem lemma_E2 (p k m : Nat) (hp : IsPrimeN p) (hm : 1 ≤ m)
    (hd : p ^ k ∣ 2 ^ (2 * m) - 1) : p ^ k ≤ 2 ^ m + 1 := by
  have hx : 2 ≤ 2 ^ m := by
    have := Nat.one_lt_two_pow (n := m) (by omega); omega
  have hfac : 2 ^ (2 * m) - 1 = (2 ^ m - 1) * (2 ^ m + 1) := by
    rw [sq_sub_one (2 ^ m) (by omega), Nat.mul_comm 2 m, Nat.pow_mul, Nat.pow_two]
  rw [hfac] at hd
  rcases prime_pow_dvd_coprime p k _ _ hp (gcd_two_pow_pm m hm) hd with h | h
  · have := Nat.le_of_dvd (by omega) h; omega
  · exact Nat.le_of_dvd (by omega) h

/-- `orb r t` never exceeds r·t. -/
theorem orb_le_mul (r t : Nat) (b : Bool) : orb r t b ≤ r * t := by
  unfold orb
  apply Nat.le_trans (Nat.min_le_left _ _)
  split
  · exact Nat.div_le_self _ _
  · exact Nat.le_refl _

/-- **The Mersenne window closes at a = 7.**  With a = 2m + 1, m ≥ 3, any foreign block
worth at most (2^a − 1)·(2^m + 1) — Theorem E.1's Cap(a) under Lemma E.2 — sits below
C(n,2)/25 at every n ≥ c + r = 2^(a+1) − 1.  (So the only Mersenne exponents E.5 must list
are a ∈ {2, 3, 5}: its exceptions at c ∈ {4, 8, 32}.) -/
theorem mersenne_window (m n B : Nat) (hm : 3 ≤ m)
    (hB : B ≤ (2 ^ (2 * m + 1) - 1) * (2 ^ m + 1))
    (hn : 2 ^ (2 * m + 2) - 1 ≤ n) : 25 * B < pairs n := by
  generalize hx : 2 ^ m = x at hB hn
  have hx8 : 8 ≤ x := by
    have : 2 ^ 3 ≤ 2 ^ m := Nat.pow_le_pow_right (by omega) hm
    omega
  have hA : 2 ^ (2 * m + 1) = 2 * (x * x) := by
    rw [Nat.pow_succ, Nat.mul_comm 2 m, Nat.pow_mul, Nat.pow_two, hx, Nat.mul_comm]
  have hC : 2 ^ (2 * m + 2) = 4 * (x * x) := by
    rw [Nat.pow_succ, Nat.pow_succ, Nat.mul_comm 2 m, Nat.pow_mul, Nat.pow_two, hx]; omega
  rw [hA] at hB; rw [hC] at hn
  generalize hX : x * x = X at hB hn
  have hX8 : 8 * x ≤ X := by rw [← hX]; exact Nat.mul_le_mul_right x hx8
  have h2n := two_pairs n
  -- n(n−1) ≥ (4X−1)(4X−2) = 2·(4X−1)(2X−1)
  have hnn : (4 * X - 1) * (4 * X - 2) ≤ n * (n - 1) := Nat.mul_le_mul hn (by omega)
  have e : (4 * X - 1) * (4 * X - 2) = 2 * ((2 * X - 1) * (4 * X - 1)) := by
    have : 4 * X - 2 = 2 * (2 * X - 1) := by omega
    rw [this]; ac_rfl
  -- 25(x+1) < 4X − 1, then multiply by 2X − 1 > 0
  have hlin : 25 * (x + 1) < 4 * X - 1 := by omega
  have hmul : (2 * X - 1) * (25 * (x + 1)) < (2 * X - 1) * (4 * X - 1) :=
    (Nat.mul_lt_mul_left (by omega)).mpr hlin
  have hB25 : 25 * B ≤ (2 * X - 1) * (25 * (x + 1)) := by
    have := Nat.mul_le_mul_left 25 hB
    calc 25 * B ≤ 25 * ((2 * X - 1) * (x + 1)) := this
      _ = (2 * X - 1) * (25 * (x + 1)) := by ac_rfl
  omega

/-- The twist split used by E.1: a prime power dividing 2·Y with Y odd is ≤ 2 or divides Y. -/
theorem twist_split (p k Y : Nat) (hp : IsPrimeN p) (hY : Y % 2 = 1) (hd : p ^ k ∣ 2 * Y) :
    p ^ k ≤ 2 ∨ p ^ k ∣ Y := by
  have hg : Nat.gcd 2 Y = 1 := by
    rw [Nat.gcd_rec]
    have : Y % 2 = 1 := hY
    rw [this]; rfl
  rcases prime_pow_dvd_coprime p k 2 Y hp hg hd with h | h
  · left; exact Nat.le_of_dvd (by omega) h
  · right; exact h

/-- **Theorem E.1's cap, assembled.**  Mersenne pair c = 2^a, r = 2^a − 1, a = 2m + 1 ≥ 7.
The foreign twist t is a prime power dividing r − 1 = 2·(2^(2m) − 1): either t ≤ 2 or it
divides 2^(2m) − 1, so t ≤ 2^m + 1 by Lemma E.2, and SAFE ≤ orb(r, t) < C(n,2)/25. -/
theorem e1_mersenne (m n p k : Nat) (hm : 3 ≤ m) (hp : IsPrimeN p)
    (ht : p ^ k ≤ 2 ∨ p ^ k ∣ 2 ^ (2 * m) - 1)
    (hn : 2 ^ (2 * m + 2) - 1 ≤ n) (b : Bool) :
    25 * orb (2 ^ (2 * m + 1) - 1) (p ^ k) b < pairs n := by
  have ht' : p ^ k ≤ 2 ^ m + 1 := by
    rcases ht with h | h
    · have : 2 ≤ 2 ^ m + 1 := by have := Nat.two_pow_pos m; omega
      omega
    · exact lemma_E2 p k m hp (by omega) h
  apply mersenne_window m n _ hm _ hn
  exact Nat.le_trans (orb_le_mul _ _ b) (Nat.mul_le_mul_left _ ht')

/-! ### Non-vacuity: each hypothesis set is satisfiable, at a real configuration -/

/-- The odd-q window is inhabited: q = 3, t = t′ = 3, r = 7, r′ = 13 = 2r − 1 (n = 35). -/
example : (13 : Nat) = 2 * 7 - 1 :=
  window_odd_q 3 3 4 7 13 (by decide) (by decide) (Or.inl rfl) (by decide) (by decide)
    (Or.inr (Or.inl rfl)) (by decide) (by decide) (by decide)

theorem isPrimeN_three : IsPrimeN 3 := by
  refine ⟨by decide, fun d hd => ?_⟩
  have h3 := Nat.le_of_dvd (by decide) hd
  have hm := Nat.mod_eq_zero_of_dvd hd
  rcases (by omega : d = 0 ∨ d = 1 ∨ d = 2 ∨ d = 3) with h | h | h | h <;> subst h
  · simp at hm
  · exact Or.inl rfl
  · simp at hm
  · exact Or.inr rfl

/-! ### Theorem E.3(iii): the repunit window -/

/-- Consecutive numbers are coprime. -/
theorem gcd_succ (A : Nat) : Nat.gcd A (A + 1) = 1 := by
  have h1 : Nat.gcd A (A + 1) ∣ A := Nat.gcd_dvd_left _ _
  have h2 : Nat.gcd A (A + 1) ∣ A + 1 := Nat.gcd_dvd_right _ _
  have h3 : Nat.gcd A (A + 1) ∣ (A + 1) - A := Nat.dvd_sub (by omega) h2 h1
  rw [show A + 1 - A = 1 by omega] at h3
  exact Nat.eq_one_of_dvd_one h3

/-- **Lemma E.2, base-3 form.**  Write 3^m = 2A + 1.  Then (3^(2m) − 1)/2 = 2·A·(A + 1), and
every prime power dividing it is at most 3^m + 1. -/
theorem lemma_E2_three (p k A : Nat) (hp : IsPrimeN p) (hA : 1 ≤ A) (hd : p ^ k ∣ 2 * (A * (A + 1))) :
    p ^ k ≤ 2 * A + 2 := by
  have hg := gcd_succ A
  by_cases h2 : p = 2
  · subst h2
    rcases k with _ | k
    · simp
    · -- 2^(k+1) ∣ 2·A(A+1)  ⟹  2^k ∣ A(A+1)  ⟹  2^k ≤ A + 1
      have hd' : 2 ^ k ∣ A * (A + 1) := by
        rw [Nat.pow_succ, Nat.mul_comm] at hd
        exact Nat.dvd_of_mul_dvd_mul_left (by omega) hd
      rcases prime_pow_dvd_coprime 2 k A (A + 1) hp hg hd' with h | h
      · have := Nat.le_of_dvd (by omega) h; rw [Nat.pow_succ]; omega
      · have := Nat.le_of_dvd (by omega) h; rw [Nat.pow_succ]; omega
  · -- p odd: p^k is coprime to 2, so p^k ∣ A(A+1)
    have hg2 : Nat.gcd (p ^ k) 2 = 1 := by
      rw [Nat.gcd_comm]
      apply gcd_pow_eq_one
      rcases hp.2 (Nat.gcd 2 p) (Nat.gcd_dvd_right 2 p) with h | h
      · exact h
      · exfalso
        have h2p : p ∣ 2 := h ▸ Nat.gcd_dvd_left 2 p
        have := Nat.le_of_dvd (by omega) h2p
        have := hp.1; omega
    have hd' : p ^ k ∣ A * (A + 1) :=
      dvd_of_dvd_mul_coprime _ _ _ hg2 (by rw [Nat.mul_comm]; exact hd)
    rcases prime_pow_dvd_coprime p k A (A + 1) hp hg hd' with h | h
    · have := Nat.le_of_dvd (by omega) h; omega
    · have := Nat.le_of_dvd (by omega) h; omega

/-- **The repunit window closes at a = 5.**  Repunit pair c = 3^a, r = (3^a − 1)/2,
a = 2m + 1 with y = 3^m ≥ 9 (m ≥ 2).  A foreign block worth at most r·(y + 1) — Cap′(a)
under `lemma_E2_three` — sits below C(n,2)/25 at every n ≥ c + r.  (So the only repunit
exponent E.5 must list is a = 3: its exception (27, 13) at n = 40.) -/
theorem repunit_window (y r n B : Nat) (hy : 9 ≤ y) (hr : 2 * r + 1 = 3 * (y * y))
    (hB : B ≤ r * (y + 1)) (hn : 3 * (y * y) + r ≤ n) : 25 * B < pairs n := by
  generalize hY : y * y = Y at hr hn
  have hY9 : 9 * y ≤ Y := by rw [← hY]; exact Nat.mul_le_mul_right y hy
  have h2n := two_pairs n
  have h4 : 4 * Y ≤ n := by omega
  have hnn : (4 * Y) * (4 * Y - 1) ≤ n * (n - 1) := Nat.mul_le_mul h4 (by omega)
  -- 2·25·B ≤ 50·r·(y+1) ≤ 75·Y·(y+1) < 4Y·(4Y − 1)
  have hlin : 75 * (y + 1) < 4 * (4 * Y - 1) := by omega
  have hY1 : 0 < Y := by omega
  have hmul : Y * (75 * (y + 1)) < Y * (4 * (4 * Y - 1)) := (Nat.mul_lt_mul_left hY1).mpr hlin
  have e1 : Y * (4 * (4 * Y - 1)) = (4 * Y) * (4 * Y - 1) := by ac_rfl
  have h50 : 50 * B ≤ 50 * (r * (y + 1)) := Nat.mul_le_mul_left 50 hB
  have h2r : (2 * r) * (y + 1) ≤ (3 * Y) * (y + 1) := Nat.mul_le_mul_right (y + 1) (by omega)
  rw [Nat.mul_assoc, Nat.mul_assoc] at h2r
  have e2 : Y * (75 * (y + 1)) = 75 * (Y * (y + 1)) := Nat.mul_left_comm _ _ _
  omega

/-- The repunit twist split: r − 1 = 3·X with 3 ∤ X, so a prime power dividing r − 1 is
≤ 3 or divides X. -/
theorem twist_split3 (p k X : Nat) (hp : IsPrimeN p) (hX : X % 3 ≠ 0) (hd : p ^ k ∣ 3 * X) :
    p ^ k ≤ 3 ∨ p ^ k ∣ X := by
  have hg : Nat.gcd 3 X = 1 := by
    rcases isPrimeN_three.2 (Nat.gcd 3 X) (Nat.gcd_dvd_left 3 X) with h | h
    · exact h
    · exfalso; have : 3 ∣ X := h ▸ Nat.gcd_dvd_right 3 X
      exact hX (Nat.mod_eq_zero_of_dvd this)
  rcases prime_pow_dvd_coprime p k 3 X hp hg hd with h | h
  · left; exact Nat.le_of_dvd (by omega) h
  · right; exact h

/-- **Theorem E.3(iii)'s cap, assembled.**  With 3^m = 2A + 1 (m ≥ 2, so A ≥ 4),
r = (3^(2m+1) − 1)/2 and r − 1 = 3·X, X = 2·A·(A + 1).  The twist t = p^k divides r − 1,
so t ≤ 3 or t ≤ 3^m + 1, and SAFE ≤ orb(r, t) < C(n,2)/25 at every n ≥ c + r. -/
theorem e3_repunit (A r n p k : Nat) (hA : 4 ≤ A) (hp : IsPrimeN p)
    (hr : 2 * r + 1 = 3 * ((2 * A + 1) * (2 * A + 1)))
    (hX : (2 * (A * (A + 1))) % 3 ≠ 0)
    (ht : p ^ k ∣ 3 * (2 * (A * (A + 1))))
    (hn : 3 * ((2 * A + 1) * (2 * A + 1)) + r ≤ n) (b : Bool) :
    25 * orb r (p ^ k) b < pairs n := by
  have htb : p ^ k ≤ 2 * A + 2 := by
    rcases twist_split3 p k _ hp hX ht with h | h
    · omega
    · exact lemma_E2_three p k A hp (by omega) h
  apply repunit_window (2 * A + 1) r n _ (by omega) hr _ hn
  apply Nat.le_trans (orb_le_mul r (p ^ k) b)
  exact Nat.mul_le_mul_left r (by omega)

/-- E.1 at the first exponent past the exceptions: a = 7, c = 128, r = 127, twist 9 = 3²
(9 ∣ 2⁶ − 1 = 63), from n = 255. -/
example : 25 * orb (2 ^ (2 * 3 + 1) - 1) (3 ^ 2) false < pairs 255 :=
  e1_mersenne 3 255 3 2 (by decide) isPrimeN_three (Or.inr (by decide)) (by decide) false

/-- Small primes by bounded search. -/
theorem isPrimeN_of_bounded (p : Nat) (h2 : 2 ≤ p)
    (h : ∀ d, d ≤ p → d ∣ p → d = 1 ∨ d = p) : IsPrimeN p :=
  ⟨h2, fun d hd => h d (Nat.le_of_dvd (by omega) hd) hd⟩

theorem isPrimeN_13 : IsPrimeN 13 := isPrimeN_of_bounded 13 (by decide) (by decide)

/-- E.3(iii) at the first repunit past the exception: a = 7, c = 2187, r = 1093, q = 13
(13 ∣ 2·13·14), from n = 3280 — the document's Cap′(7) = 1093·13 = 14,209 case. -/
example : 25 * orb 1093 13 false < pairs 3280 := by
  have h := e3_repunit 13 1093 3280 13 1 (by decide) isPrimeN_13 (by decide) (by decide)
    (by decide) (by decide) false
  simpa using h

/-- The s-ladder at E.4's own pair: s = 3, r = 5, n = 21, B = 10 gives 16·10 < 210. -/
example : (3 + 1) ^ 2 * 10 < pairs 21 :=
  sladder_strict 3 5 21 10 (by decide) (by decide) (by decide)

end E5Core

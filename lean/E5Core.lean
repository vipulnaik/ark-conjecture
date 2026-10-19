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

**What is NOT here.** The group theory (Lemma B′, the SAFE terms themselves), the twist
classification behind `PowRel` (that two powers of one prime are equal or differ by a factor
≥ q), Lemma E.2's prime-power bound L(a) ≤ 2^{(a−1)/2} + 1, and the Mersenne / repunit
windows of E.1 and E.3(iii).  Those are stated as hypotheses where used, or not at all.

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

/-! ### Non-vacuity: each hypothesis set is satisfiable, at a real configuration -/

/-- The odd-q window is inhabited: q = 3, t = t′ = 3, r = 7, r′ = 13 = 2r − 1 (n = 35). -/
example : (13 : Nat) = 2 * 7 - 1 :=
  window_odd_q 3 3 4 7 13 (by decide) (by decide) (Or.inl rfl) (by decide) (by decide)
    (Or.inr (Or.inl rfl)) (by decide) (by decide) (by decide)

/-- The s-ladder at E.4's own pair: s = 3, r = 5, n = 21, B = 10 gives 16·10 < 210. -/
example : (3 + 1) ^ 2 * 10 < pairs 21 :=
  sladder_strict 3 5 21 10 (by decide) (by decide) (by decide)

end E5Core

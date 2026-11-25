/-
# `E5Assembly.lean` — Theorem E.5 stated on the text's own SAFE score

`E5Core.lean` proves the arithmetic of Theorem E.5 (`enumeration-proof.md` Part E‴) on bare
numbers: each lemma takes a bound `B ≤ C(r,2)` and a size count for `n` as hypotheses.  This
file supplies what those hypotheses are *about*, so that the theorem is stated on the object
the text states it on:

* `Part`, `Fallback`, `Fallback.safe` — a fallback configuration and its SAFE score, read off
  Part G.3 / G.3a: SAFE is the minimum over the orbital types G.3 lists —
  intra-block (a p-characteristic class valued flat at F·C(c,2), as B_safe's definition
  requires; a foreign block at orb(r, t)), the smallest within-part cross orbital
  ((F or F/2)·c², F ≥ 2), and every between-parts orbital sᵢ·sⱼ.
* `Admissible` — the text's hypotheses on W: c = p^a, r a prime ≠ p dividing c − 1, every
  foreign twist dividing its r − 1 and a power of **one** prime q (Lemma B′, a group-theory
  input taken as a hypothesis, as the text does), leftover parts p-characteristic or foreign,
  and **foreign primes distinct** (the second-reading fix, session-log-15 §45).
* `safe_le_*` — the inequalities the proof consumes: SAFE ≤ C(r,2), and every part of W
  has C(size, 2) ≥ SAFE ("every part has size at least ℓ(B)").
* `e5_s_ge4` — the s ≥ 4 branch.
* `e5_s2a1` — the whole s = 2, a = 1 branch (the one E.3(ii) declined), all four sub-cases,
  with the one-foreign-leftover sub-case taken from first principles: the ratio window and
  the cofactor bounds (r−1)/t ≤ 3, (r′−1)/t′ ≤ 7 are *derived* here from SAFE, not assumed;
  both q odd and q = 2 are closed (the latter via Mathlib's Fermat-prime lemma).
* `exceptions` — the 12 rows of the text's exception table, one configuration per row,
  with SAFE evaluated to the table's value and 25·SAFE ≥ C(n,2) checked by `decide`.

* `e5_s1`, `e5_s3`, `e5_s2a2` — the remaining branches, each with its classification step
  (E.1: s = 1 forces (3, 2) or c = 2^a with 2^a − 1 a Mersenne prime, a prime; E.4: s = 3
  forces r = 2 or (16, 5); E.3(i): s = 2, a ≥ 2 forces p = 3, a odd) and `E5Core`'s caps.
* `e5` — **Theorem E.5 assembled**: an admissible, non-bare fallback configuration has
  25·SAFE < C(n,2), or (c, r) is one of the six pairs the exception table is built on.
* `exceptions_more` — the table records one configuration per n: F = 2 and F = 3 at
  (8, 7) are further exceptions at n = 23 and 31.

**Not here (yet):** that the exceptions occur only at the table's 12 values of n (at most 63).
`e5` bounds the exceptional (c, r) but not n; the per-n list remains `fallback_sup.py`'s
enumeration.
-/
import Mathlib
import E5Core
import Bridge

namespace E5Assembly
open ArkCore E5Core

/-! ### Configurations and SAFE (Part G.3 / G.3a) -/

/-- A part of a configuration: a p-characteristic class of `F` blocks of size `c`, or a
foreign block of prime size `r` with twist of order `t`. -/
inductive Part where
  | pc (F c : ℕ)
  | fr (r t : ℕ)
  deriving DecidableEq

def Part.size : Part → ℕ
  | .pc F c => F * c
  | .fr r _ => r

/-- The orbitals of one part, as G.3 lists them: the intra-block term (flat F·C(c,2) for a
p-characteristic class — B_safe's capacity — and orb(r, t) for a foreign block, which is an
odd-order cyclic group so `char2 = false`), and for F ≥ 2 the smallest within-part cross
orbital, F·c² for odd F and (F/2)·c² for even F. -/
def Part.terms : Part → List ℕ
  | .pc F c => F * pairs c :: (if 2 ≤ F then [(if F % 2 = 1 then F else F / 2) * c * c] else [])
  | .fr r t => [orb r t false]

/-- Between-parts orbitals: one of size sᵢ·sⱼ for each pair i < j. -/
def crossTerms : List Part → List ℕ
  | [] => []
  | x :: xs => xs.map (fun y => x.size * y.size) ++ crossTerms xs

/-- A fallback configuration: the p-characteristic class (F, c), the foreign block r with
twist t, and the leftover parts. -/
structure Fallback where
  F : ℕ
  c : ℕ
  r : ℕ
  t : ℕ
  left : List Part

namespace Fallback

def parts (W : Fallback) : List Part := .pc W.F W.c :: .fr W.r W.t :: W.left

def n (W : Fallback) : ℕ := ((W.parts).map Part.size).sum

def terms (W : Fallback) : List ℕ := (W.parts).flatMap Part.terms ++ crossTerms W.parts

/-- SAFE(W): the minimum over the orbital list.  The fold is seeded with the class's own
intra term, which is also in the list, so the seed changes nothing. -/
def safe (W : Fallback) : ℕ := W.terms.foldr min (W.F * pairs W.c)

/-- The bare safe-prime pair: F = 1, no leftover, c = 2r + 1. -/
def Bare (W : Fallback) : Prop := W.F = 1 ∧ W.left = [] ∧ W.c = 2 * W.r + 1

end Fallback

/-- The text's admissibility, at characteristic prime `p`, exponent `a`, top prime `q`. -/
def Admissible (W : Fallback) (p a q : ℕ) : Prop :=
  Nat.Prime p ∧ 1 ≤ a ∧ W.c = p ^ a ∧ 1 ≤ W.F ∧
  Nat.Prime W.r ∧ W.r ≠ p ∧ W.r ∣ W.c - 1 ∧
  Nat.Prime q ∧ W.t ∣ W.r - 1 ∧ (∃ e, W.t = q ^ e) ∧
  (∀ x ∈ W.left, match x with
    | .pc F c => 1 ≤ F ∧ ∃ b, 1 ≤ b ∧ c = p ^ b
    | .fr r t => Nat.Prime r ∧ r ≠ p ∧ r ≠ W.r ∧ t ∣ r - 1 ∧ ∃ f, t = q ^ f) ∧
  -- foreign primes distinct (among the leftover; distinct from W.r is in the clause above)
  ((W.left.filterMap fun x => match x with | .fr r _ => some r | .pc _ _ => none).Nodup)

/-! ### The inequalities the proof consumes -/

theorem foldr_min_le (a : ℕ) : ∀ (l : List ℕ) (y : ℕ), y ∈ l → l.foldr min a ≤ y
  | [], _, h => absurd h (List.not_mem_nil)
  | x :: xs, y, h => by
    simp only [List.foldr_cons]
    rcases List.mem_cons.mp h with rfl | h
    · exact Nat.min_le_left _ _
    · exact le_trans (Nat.min_le_right _ _) (foldr_min_le a xs y h)

theorem safe_le_term (W : Fallback) {y : ℕ} (h : y ∈ W.terms) : W.safe ≤ y :=
  foldr_min_le _ _ _ h

theorem term_of_part (W : Fallback) {x : Part} (hx : x ∈ W.parts) {y : ℕ}
    (hy : y ∈ x.terms) : y ∈ W.terms := by
  unfold Fallback.terms
  exact List.mem_append_left _ (List.mem_flatMap.mpr ⟨x, hx, hy⟩)

/-- F·C(c,2) ≤ C(F·c, 2): a class's flat intra value fits inside the class. -/
theorem mul_pairs_le (F c : ℕ) : F * pairs c ≤ pairs (F * c) := by
  have h1 := two_pairs c
  have h2 := two_pairs (F * c)
  rcases Nat.eq_zero_or_pos F with rfl | hF
  · simp
  rcases Nat.eq_zero_or_pos c with rfl | hc
  · simp [pairs]
  have : F * (c * (c - 1)) ≤ F * c * (F * c - 1) := by
    have hle : c - 1 ≤ F * c - 1 := by
      have : c ≤ F * c := Nat.le_mul_of_pos_left c hF
      omega
    calc F * (c * (c - 1)) = F * c * (c - 1) := by ring
      _ ≤ F * c * (F * c - 1) := Nat.mul_le_mul_left _ hle
  have : 2 * (F * pairs c) ≤ 2 * pairs (F * c) := by
    calc 2 * (F * pairs c) = F * (2 * pairs c) := by ring
      _ = F * (c * (c - 1)) := by rw [h1]
      _ ≤ _ := this
      _ = _ := h2.symm
  omega

/-- Every part's intra term is at most C(size, 2). -/
theorem part_intra_le (x : Part) : ∃ y ∈ x.terms, y ≤ pairs x.size := by
  cases x with
  | pc F c => exact ⟨F * pairs c, by simp [Part.terms], mul_pairs_le F c⟩
  | fr r t => exact ⟨orb r t false, by simp [Part.terms], by
      simpa [Part.size] using orb_le_pairs r t false⟩

/-- **Every part of W has C(size, 2) ≥ SAFE(W)** — the text's "every part has size at least
ℓ(B)". -/
theorem safe_le_pairs_part (W : Fallback) {x : Part} (hx : x ∈ W.parts) :
    W.safe ≤ pairs x.size := by
  obtain ⟨y, hy, hle⟩ := part_intra_le x
  exact le_trans (safe_le_term W (term_of_part W hx hy)) hle

theorem safe_le_orb (W : Fallback) : W.safe ≤ orb W.r W.t false :=
  safe_le_term W (term_of_part W (x := .fr W.r W.t) (by simp [Fallback.parts])
    (by simp [Part.terms]))

/-- SAFE ≤ C(r,2): "the foreign part satisfies orb(r,t) ≤ C(r,2), hence r(r−1) ≥ 2B". -/
theorem safe_le_pairs_r (W : Fallback) : W.safe ≤ pairs W.r :=
  le_trans (safe_le_orb W) (orb_le_pairs _ _ _)

theorem n_eq (W : Fallback) :
    W.n = W.F * W.c + W.r + ((W.left).map Part.size).sum := by
  simp [Fallback.n, Fallback.parts, Part.size]; ring

/-! ### The s ≥ 4 branch -/

theorem e5_s_ge4 (W : Fallback) (s : ℕ) (hF : 1 ≤ W.F) (hr : 1 ≤ W.r)
    (hs : 4 ≤ s) (hc : W.c = s * W.r + 1) : 25 * W.safe < pairs W.n := by
  apply s_ge_four s W.r W.n W.safe hs hr (safe_le_pairs_r W)
  have h1 : W.c ≤ W.F * W.c := Nat.le_mul_of_pos_left _ hF
  rw [n_eq]
  have : (s + 1) * W.r + 1 = W.c + W.r := by rw [hc]; ring
  omega

/-! ### The s = 2, a = 1 branch -/

theorem prime_odd {r : ℕ} (hr : Nat.Prime r) (h3 : 3 ≤ r) : r % 2 = 1 := by
  by_contra h
  have h0 : r % 2 = 0 := by omega
  rcases hr.eq_one_or_self_of_dvd 2 (Nat.dvd_of_mod_eq_zero h0) with h | h <;> omega

/-- Cofactor bound on the first foreign block, derived from SAFE: if (r−1)/t ≥ 4 then
B ≤ r·t ≤ r(r−1)/4, which is below C(n,2)/25 once n = 3r + 1 + r′ with 4r′ > 3r. -/
theorem cofactor_r (r r' t j n B : ℕ) (hr : 1 ≤ r) (hj : r - 1 = j * t) (hj4 : 4 ≤ j)
    (hB : B ≤ r * t) (hn : n = 3 * r + 1 + r') (hlo : 3 * r < 4 * r') :
    25 * B < pairs n := by
  have h2 := two_pairs n
  obtain ⟨r0, rfl⟩ : ∃ r0, r = r0 + 1 := ⟨r - 1, by omega⟩
  simp only [Nat.add_sub_cancel] at hj
  have h4t : 4 * t ≤ r0 := by rw [hj]; exact Nat.mul_le_mul_right t hj4
  have hBr : 4 * B ≤ (r0 + 1) * r0 := by
    calc 4 * B ≤ 4 * ((r0 + 1) * t) := by omega
      _ = (r0 + 1) * (4 * t) := by ring
      _ ≤ (r0 + 1) * r0 := Nat.mul_le_mul_left _ h4t
  subst hn
  have hsub : 3 * (r0 + 1) + 1 + r' - 1 = 3 * (r0 + 1) + r' := by omega
  rw [hsub] at h2
  nlinarith

/-- Cofactor bound on the leftover foreign block: (r′−1)/t′ ≥ 8 gives B ≤ r′(r′−1)/8,
below C(n,2)/25 once r′ < 2r. -/
theorem cofactor_r' (r r' t' j' n B : ℕ) (hr' : 1 ≤ r') (hj : r' - 1 = j' * t') (hj8 : 8 ≤ j')
    (hB : B ≤ r' * t') (hn : n = 3 * r + 1 + r') (hhi : r' < 2 * r) :
    25 * B < pairs n := by
  have h2 := two_pairs n
  obtain ⟨r0, rfl⟩ : ∃ r0, r' = r0 + 1 := ⟨r' - 1, by omega⟩
  simp only [Nat.add_sub_cancel] at hj
  have h8t : 8 * t' ≤ r0 := by rw [hj]; exact Nat.mul_le_mul_right t' hj8
  have hBr : 8 * B ≤ (r0 + 1) * r0 := by
    calc 8 * B ≤ 8 * ((r0 + 1) * t') := by omega
      _ = (r0 + 1) * (8 * t') := by ring
      _ ≤ (r0 + 1) * r0 := Nat.mul_le_mul_left _ h8t
  subst hn
  have hsub : 3 * r + 1 + (r0 + 1) - 1 = 3 * r + (r0 + 1) := by omega
  rw [hsub] at h2
  nlinarith

/-- The one-foreign-leftover sub-case: F = 1, c = 2r + 1, leftover a single foreign block r′
with r′ ≠ r, both twists powers of the same prime q (Lemma B′), c prime. -/
theorem one_foreign (r r' t t' q e f n B : ℕ) (hr : Nat.Prime r) (hr' : Nat.Prime r')
    (hne : r' ≠ r) (hc : Nat.Prime (2 * r + 1)) (hq : Nat.Prime q)
    (ht : t = q ^ e) (ht' : t' = q ^ f) (htd : t ∣ r - 1) (htd' : t' ∣ r' - 1)
    (hBr : B ≤ orb r t false) (hBr' : B ≤ orb r' t' false)
    (hn : n = 3 * r + 1 + r') : 25 * B < pairs n := by
  have hr2 := hr.two_le
  have hr2' := hr'.two_le
  have hBp : B ≤ pairs r := le_trans hBr (orb_le_pairs _ _ _)
  have hBp' : B ≤ pairs r' := le_trans hBr' (orb_le_pairs _ _ _)
  -- the ratio window: outside it, one block alone gives n ≥ 5·block + 1
  by_cases hhi : 2 * r ≤ r'
  · exact count_5r1 r n B (by omega) hBp (by omega)
  by_cases hlo : 4 * r' ≤ 3 * r
  · exact count_5r1 r' n B (by omega) hBp' (by omega)
  push Not at hhi hlo
  -- r = 2: B ≤ C(2,2) = 1 and n ≥ 10
  by_cases h2 : r = 2
  · subst h2
    have : B ≤ 1 := by simpa [pairs] using hBp
    have : pairs 10 ≤ pairs n := pairs_mono (by omega)
    have : pairs 10 = 45 := by decide
    omega
  have hr3 : 3 ≤ r := by omega
  have hr3' : 3 ≤ r' := by omega
  have hro := prime_odd hr hr3
  have hro' := prime_odd hr' hr3'
  obtain ⟨j, hj⟩ := htd
  obtain ⟨j', hj'⟩ := htd'
  have hj_t : r - 1 = j * t := by rw [hj]; ring
  have hj_t' : r' - 1 = j' * t' := by rw [hj']; ring
  -- cofactor bounds, derived
  by_cases hj4 : 4 ≤ j
  · exact cofactor_r r r' t j n B (by omega) hj_t hj4 (le_trans hBr (orb_le_mul _ _ _)) hn hlo
  by_cases hj8 : 8 ≤ j'
  · exact cofactor_r' r r' t' j' n B (by omega) hj_t' hj8 (le_trans hBr' (orb_le_mul _ _ _))
      hn hhi
  push Not at hj4 hj8
  have hj1 : 1 ≤ j := by
    rcases Nat.eq_zero_or_pos j with h | h
    · rw [h] at hj_t; omega
    · exact h
  rcases hq.eq_two_or_odd' with rfl | hqo
  · -- q = 2: r − 1 = j·2^e with j ≤ 3
    subst ht
    have hc3 : 2 * r + 1 ≠ 0 := by omega
    -- r is 2^m + 1 (j ∈ {1, 2}) or 3·2^e + 1 (j = 3)
    have hform : (∃ m, r = 2 ^ m + 1) ∨ r = 3 * 2 ^ e + 1 := by
      interval_cases j
      · left; exact ⟨e, by omega⟩
      · left; exact ⟨e + 1, by rw [pow_succ]; omega⟩
      · right; omega
    have hsmall : r = 3 ∨ r = 5 := by
      rcases hform with ⟨m, hm⟩ | hm
      · have hm0 : m ≠ 0 := by rintro rfl; omega
        obtain ⟨k, hk⟩ := Nat.pow_of_pow_add_prime (by norm_num) hm0 (hm ▸ hr)
        by_cases hk2 : 2 ≤ k
        · have h5 := fermat_c_div5 k hk2
          rw [← hk, ← hm] at h5
          rcases hc.eq_one_or_self_of_dvd 5 (Nat.dvd_of_mod_eq_zero h5) with h | h <;> omega
        · have hk01 : k = 0 ∨ k = 1 := by omega
          rcases hk01 with rfl | rfl <;> norm_num at hk <;> subst hk <;> norm_num at hm <;> omega
      · have h3 := three_c_div3 e
        rw [← hm] at h3
        rcases hc.eq_one_or_self_of_dvd 3 (Nat.dvd_of_mod_eq_zero h3) with h | h <;> omega
    rcases hsmall with rfl | rfl
    · -- r = 3, c = 7: r′ odd, ≠ 3, 4r′ > 9 ⇒ r′ ≥ 5, n ≥ 15
      have : pairs 15 ≤ pairs n := pairs_mono (by omega)
      have : pairs 3 = 3 := by decide
      have : pairs 15 = 105 := by decide
      omega
    · -- r = 5, c = 11: r′ odd, ≠ 5, 4r′ > 15 ⇒ r′ ≥ 7, n ≥ 23
      have : pairs 23 ≤ pairs n := pairs_mono (by omega)
      have : pairs 5 = 10 := by decide
      have : pairs 23 = 253 := by decide
      omega
  · -- q odd: E5Core's odd-q assembly
    have hq1 : q % 2 = 1 := Nat.odd_iff.mp hqo
    have hq3 : 3 ≤ q := by have := hq.two_le; omega
    subst ht ht'
    exact odd_q_leftover q e f j j' r r' n B hq3 hq1 hro hr3 hro' hr3' hj_t hj1
      (by omega) hj_t' (by omega) hlo hhi hne (by omega) hBp

/-- **Theorem E.5, s = 2 and a = 1 branch.**  A fallback configuration with c = p prime,
c = 2r + 1, that is not the bare safe-prime pair, has 25·SAFE(W) < C(n,2). -/
theorem e5_s2a1 (W : Fallback) (p q : ℕ) (hW : Admissible W p 1 q)
    (hc : W.c = 2 * W.r + 1) (hnb : ¬ W.Bare) : 25 * W.safe < pairs W.n := by
  obtain ⟨hp, -, hcp, hF, hr, hrp, -, hq, htd, ⟨e, he⟩, hleft, hnodup⟩ := hW
  rw [pow_one] at hcp
  have hr2 := hr.two_le
  have hBr := safe_le_pairs_r W
  have hnE := n_eq W
  -- F ≥ 2: n ≥ 2c + r = 5r + 2
  by_cases hF2 : 2 ≤ W.F
  · apply count_5r1 W.r W.n W.safe (by omega) hBr
    have : 2 * W.c ≤ W.F * W.c := Nat.mul_le_mul_right _ hF2
    omega
  have hF1 : W.F = 1 := by omega
  match hL : W.left with
  | [] => exact absurd ⟨hF1, hL, hc⟩ hnb
  | [Part.pc F2 c2] =>
    -- a p-characteristic leftover: its block is a power of p = c, so ≥ c
    obtain ⟨hF2', b, hb, hcb⟩ := hleft (.pc F2 c2) (by simp [hL])
    have hcc : W.c ≤ c2 := by
      rw [hcb, hcp]; exact le_self_pow₀ hp.one_le (by omega)
    apply count_5r1 W.r W.n W.safe (by omega) hBr
    rw [hL] at hnE
    simp [Part.size] at hnE
    have : c2 ≤ F2 * c2 := Nat.le_mul_of_pos_left _ hF2'
    rw [hF1] at hnE
    omega
  | [Part.fr r' t'] =>
    obtain ⟨hr', -, hne, htd', ⟨f, hf⟩⟩ := hleft (.fr r' t') (by simp [hL])
    have hB' : W.safe ≤ orb r' t' false :=
      safe_le_term W (term_of_part W (x := .fr r' t') (by simp [Fallback.parts, hL]) (by simp [Part.terms]))
    rw [hL] at hnE
    simp [Part.size] at hnE
    exact one_foreign W.r r' W.t t' q e f W.n W.safe hr hr' hne (hc ▸ hcp ▸ hp) hq he hf htd
      htd' (safe_le_orb W) hB' (by rw [hnE, hF1, hc]; ring)
  | x :: y :: rest =>
    -- two or more leftover parts, each clearing B
    have hx : x ∈ W.parts := by simp [Fallback.parts, hL]
    have hy : y ∈ W.parts := by simp [Fallback.parts, hL]
    have hBx := safe_le_pairs_part W hx
    have hBy := safe_le_pairs_part W hy
    have hpos : ∀ z ∈ W.left, 1 ≤ z.size := by
      intro z hz
      have := hleft z hz
      cases z with
      | pc F2 c2 =>
        obtain ⟨hF2', b, -, hcb⟩ := this
        simp only [Part.size]
        exact Nat.mul_pos hF2' (hcb ▸ Nat.pow_pos hp.pos)
      | fr r2 t2 => simp only [Part.size]; exact this.1.pos
    have hxs := hpos x (by simp [hL])
    have hys := hpos y (by simp [hL])
    rw [hL] at hnE
    simp only [List.map_cons, List.sum_cons] at hnE
    rw [hF1, one_mul, hc] at hnE
    rcases Nat.le_total x.size y.size with h | h
    · exact two_part_leftover W.r x.size W.n W.safe (by omega) hxs hBr hBx (by omega)
    · exact two_part_leftover W.r y.size W.n W.safe (by omega) hys hBr hBy (by omega)

/-! ### The 12 exceptions, row by row

One configuration per row of the text's table, with the leftover composed as
`fallback_sup.py` composes it.  For each: SAFE equals the table's value, and
25·SAFE ≥ C(n,2), so the row really is an exception. -/

/-- n = 5: c = 3, r = 2, trivial twist. -/
def ex5 : Fallback := ⟨1, 3, 2, 1, []⟩
/-- n = 7, 11, 12: c = 4, r = 3, q = 2 (t = 2); L = 0, a 4-block, a foreign 5. -/
def ex7 : Fallback := ⟨1, 4, 3, 2, []⟩
def ex11 : Fallback := ⟨1, 4, 3, 2, [.pc 1 4]⟩
def ex12 : Fallback := ⟨1, 4, 3, 2, [.fr 5 4]⟩
/-- n = 15, 23, 27, 28, 31: c = 8, r = 7, q = 3 (t = 3); L = 0, 8, 3·4, foreign 13, 2·8. -/
def ex15 : Fallback := ⟨1, 8, 7, 3, []⟩
def ex23 : Fallback := ⟨1, 8, 7, 3, [.pc 1 8]⟩
def ex27 : Fallback := ⟨1, 8, 7, 3, [.pc 3 4]⟩
def ex28 : Fallback := ⟨1, 8, 7, 3, [.fr 13 3]⟩
def ex31 : Fallback := ⟨1, 8, 7, 3, [.pc 2 8]⟩
/-- n = 21: the s = 3 pair (16, 5), q = 2 (t = 4). -/
def ex21 : Fallback := ⟨1, 16, 5, 4, []⟩
/-- n = 40: the repunit pair (27, 13), q = 3 (t = 3). -/
def ex40 : Fallback := ⟨1, 27, 13, 3, []⟩
/-- n = 63: the Mersenne pair (32, 31), q = 5 (t = 5). -/
def ex63 : Fallback := ⟨1, 32, 31, 5, []⟩

theorem exceptions :
    (ex5.n = 5 ∧ ex5.safe = 1 ∧ pairs 5 ≤ 25 * ex5.safe) ∧
    (ex7.n = 7 ∧ ex7.safe = 3 ∧ pairs 7 ≤ 25 * ex7.safe) ∧
    (ex11.n = 11 ∧ ex11.safe = 3 ∧ pairs 11 ≤ 25 * ex11.safe) ∧
    (ex12.n = 12 ∧ ex12.safe = 3 ∧ pairs 12 ≤ 25 * ex12.safe) ∧
    (ex15.n = 15 ∧ ex15.safe = 21 ∧ pairs 15 ≤ 25 * ex15.safe) ∧
    (ex23.n = 23 ∧ ex23.safe = 21 ∧ pairs 23 ≤ 25 * ex23.safe) ∧
    (ex27.n = 27 ∧ ex27.safe = 18 ∧ pairs 27 ≤ 25 * ex27.safe) ∧
    (ex28.n = 28 ∧ ex28.safe = 21 ∧ pairs 28 ≤ 25 * ex28.safe) ∧
    (ex31.n = 31 ∧ ex31.safe = 21 ∧ pairs 31 ≤ 25 * ex31.safe) ∧
    (ex21.n = 21 ∧ ex21.safe = 10 ∧ pairs 21 ≤ 25 * ex21.safe) ∧
    (ex40.n = 40 ∧ ex40.safe = 39 ∧ pairs 40 ≤ 25 * ex40.safe) ∧
    (ex63.n = 63 ∧ ex63.safe = 155 ∧ pairs 63 ≤ 25 * ex63.safe) := by
  decide

/-- Admissibility checked on the one row with a foreign leftover (n = 28), the row where every
clause of `Admissible` — including distinct foreign primes — is non-vacuous. -/
theorem ex28_admissible : Admissible ex28 2 3 3 := by
  unfold Admissible ex28
  refine ⟨by norm_num, by norm_num, by norm_num, le_refl _, by norm_num, by decide, by decide,
    by norm_num, by decide, ⟨1, by norm_num⟩, ?_, by decide⟩
  intro x hx
  simp at hx
  subst hx
  exact ⟨by norm_num, by decide, by decide, by decide, 1, by norm_num⟩

/-! ### The other branches: s = 1, s = 3, s = 2 with a ≥ 2, and the assembly

Each branch theorem concludes `25·SAFE < C(n,2)` **or** that (c, r) is one of the six pairs
the exception table is built on.  The classification steps are E.1's (s = 1 forces c = 2^a and
r Mersenne, or (3, 2)), E.3(i)'s (s = 2, a ≥ 2 forces p = 3 and a odd) and E.4's (s = 3 forces
(16, 5) or r = 2); the caps are `E5Core`'s. -/

/-- The six (c, r) pairs underlying the text's 12 exceptions. -/
def excPairs : List (ℕ × ℕ) := [(3, 2), (4, 3), (8, 7), (16, 5), (27, 13), (32, 31)]

theorem n_ge_c_add_r (W : Fallback) (hF : 1 ≤ W.F) : W.c + W.r ≤ W.n := by
  rw [n_eq]; have : W.c ≤ W.F * W.c := Nat.le_mul_of_pos_left _ hF; omega

theorem isPrimeN_of_prime' {p : ℕ} (hp : Nat.Prime p) : IsPrimeN p :=
  ArkBridge.isPrimeN_of_prime hp

/-- A prime power `p^a` that is even has p = 2. -/
theorem prime_eq_two_of_even_pow {p a : ℕ} (hp : Nat.Prime p) (h : (p ^ a) % 2 = 0) : p = 2 := by
  have : Even (p ^ a) := Nat.even_iff.mpr h
  exact (hp.even_iff).mp (Nat.even_pow.mp this).1

theorem pow_odd_of_odd {p a : ℕ} (hp : p % 2 = 1) : (p ^ a) % 2 = 1 :=
  Nat.odd_iff.mp (Odd.pow (Nat.odd_iff.mpr hp))

/-- **s = 1 (Theorem E.1).** c − 1 = r prime. -/
theorem e5_s1 (W : Fallback) (p a q : ℕ) (hW : Admissible W p a q) (hs : W.c = W.r + 1) :
    25 * W.safe < pairs W.n ∨ (W.c, W.r) ∈ excPairs := by
  obtain ⟨hp, ha, hcp, hF, hr, -, -, hq, htd, ⟨e, he⟩, -, -⟩ := hW
  have hnc := n_ge_c_add_r W hF
  have hr2 := hr.two_le
  rcases hp.eq_two_or_odd with rfl | hpo
  · -- c = 2^a, r = 2^a − 1 a Mersenne prime
    have hrm : W.r = 2 ^ a - 1 := by omega
    have ha1 : a ≠ 1 := by rintro rfl; omega
    obtain ⟨-, haP⟩ := Nat.prime_of_pow_sub_one_prime ha1 (hrm ▸ hr)
    rcases haP.eq_two_or_odd with rfl | hao
    · right; simp [excPairs]; omega
    obtain ⟨m, rfl⟩ : ∃ m, a = 2 * m + 1 := ⟨a / 2, by omega⟩
    by_cases hm : 3 ≤ m
    · left
      have hpow : 2 ^ (2 * m + 1) = 2 * 2 ^ (2 * m) := by rw [pow_succ]; ring
      have hpos : 1 ≤ 2 ^ (2 * m) := Nat.one_le_two_pow
      have hY : (2 ^ (2 * m) - 1) % 2 = 1 := by
        have : 2 ^ (2 * m) % 2 = 0 := by
          rw [show 2 * m = (2 * m - 1) + 1 by omega, pow_succ]; simp
        omega
      have hd : q ^ e ∣ 2 * (2 ^ (2 * m) - 1) := by
        rw [← he]; convert htd using 1; omega
      have ht := twist_split q e _ (isPrimeN_of_prime' hq) hY hd
      have hn : 2 ^ (2 * m + 2) - 1 ≤ W.n := by
        have : 2 ^ (2 * m + 2) = 2 * 2 ^ (2 * m + 1) := by rw [pow_succ]; ring
        omega
      have h := e1_mersenne m W.n q e hm (isPrimeN_of_prime' hq) ht hn false
      rw [← hrm, ← he] at h
      exact lt_of_le_of_lt (Nat.mul_le_mul_left 25 (safe_le_orb W)) h
    · right
      have : m = 1 ∨ m = 2 := by
        rcases Nat.lt_or_ge m 1 with h | h
        · exfalso; omega
        · omega
      rcases this with rfl | rfl <;> simp [excPairs] <;> omega
  · -- p odd: c odd, so r = c − 1 is even, hence r = 2 and c = 3
    have hco : W.c % 2 = 1 := by rw [hcp]; exact pow_odd_of_odd hpo
    have : W.r = 2 := by
      rcases hr.eq_one_or_self_of_dvd 2 (Nat.dvd_of_mod_eq_zero (by omega)) with h | h <;> omega
    right; simp [excPairs]; omega

/-- **s = 3 (Theorem E.4).** c − 1 = 3r: r = 2 (SAFE ≤ 1), or (c, r) = (16, 5). -/
theorem e5_s3 (W : Fallback) (p a q : ℕ) (hW : Admissible W p a q) (hs : W.c = 3 * W.r + 1) :
    25 * W.safe < pairs W.n ∨ (W.c, W.r) ∈ excPairs := by
  obtain ⟨hp, ha, hcp, hF, hr, -, -, -, -, -, -, -⟩ := hW
  have hnc := n_ge_c_add_r W hF
  have hBr := safe_le_pairs_r W
  have hr2 := hr.two_le
  by_cases h2 : W.r = 2
  · left
    rw [h2] at hBr
    have : pairs 9 ≤ pairs W.n := pairs_mono (by omega)
    have : pairs 9 = 36 := by decide
    have : pairs 2 = 1 := by decide
    omega
  have hro := prime_odd hr (by omega)
  have hp2 : p = 2 := prime_eq_two_of_even_pow hp (by rw [← hcp]; omega)
  subst hp2
  obtain ⟨b, hb⟩ := Nat.even_or_odd' a
  rcases hb with rfl | rfl
  · -- a = 2b: (2^b − 1)(2^b + 1) = 3r
    have hsq : 2 ^ (2 * b) = 2 ^ b * 2 ^ b := by rw [two_mul, pow_add]
    have hx1 : 1 ≤ 2 ^ b := Nat.one_le_two_pow
    have hXY : (2 ^ b - 1) * (2 ^ b + 1) = 3 * W.r := by
      rw [sq_sub_one _ hx1, ← hsq]; omega
    by_cases hb3 : 3 ≤ b
    · exfalso
      have h8 : 8 ≤ 2 ^ b := by
        calc 8 = 2 ^ 3 := by norm_num
          _ ≤ 2 ^ b := Nat.pow_le_pow_right (by norm_num) hb3
      have hdvd : W.r ∣ (2 ^ b - 1) * (2 ^ b + 1) := ⟨3, by rw [hXY]; ring⟩
      rcases (Nat.Prime.dvd_mul hr).mp hdvd with h | h
      · have := Nat.le_of_dvd (by omega) h
        have : W.r * 9 ≤ (2 ^ b - 1) * (2 ^ b + 1) := Nat.mul_le_mul this (by omega)
        omega
      · have := Nat.le_of_dvd (by omega) h
        have : 7 * W.r ≤ (2 ^ b - 1) * (2 ^ b + 1) := by
          exact Nat.mul_le_mul (by omega) this
        omega
    · interval_cases b <;> simp at hcp <;> (try omega)
      right; simp [excPairs]; omega
  · -- a odd: 2^a ≡ 2 (mod 3), but c = 3r + 1
    exfalso
    have : 2 ^ (2 * b + 1) % 3 = 2 := by
      rw [pow_succ, pow_mul, Nat.mul_mod, Nat.pow_mod]; norm_num
    omega

/-- **s = 2, a ≥ 2 (Theorem E.3(i) and (iii)).** p = 3, a odd; a = 3 is (27, 13), a ≥ 5 is
capped by `e3_repunit`. -/
theorem e5_s2a2 (W : Fallback) (p a q : ℕ) (hW : Admissible W p a q) (ha2 : 2 ≤ a)
    (hs : W.c = 2 * W.r + 1) : 25 * W.safe < pairs W.n ∨ (W.c, W.r) ∈ excPairs := by
  obtain ⟨hp, -, hcp, hF, hr, -, -, hq, htd, ⟨e, he⟩, -, -⟩ := hW
  have hnc := n_ge_c_add_r W hF
  have hr2 := hr.two_le
  have hp2 := hp.two_le
  -- p = 3: (p − 1)/2 divides r, and is not r
  have hpo : p % 2 = 1 := by
    rcases hp.eq_two_or_odd with h | h
    · subst h; exfalso
      have : 2 ^ a % 2 = 0 := by
        rw [show a = (a - 1) + 1 by omega, pow_succ]; simp
      omega
    · exact h
  have hp3 : p = 3 := by
    obtain ⟨d, hd⟩ : ∃ d, p - 1 = 2 * d := ⟨(p - 1) / 2, by omega⟩
    have hdiv : p - 1 ∣ p ^ a - 1 := Nat.sub_one_dvd_pow_sub_one p a
    rw [hd, show p ^ a - 1 = 2 * W.r by omega] at hdiv
    have hdr : d ∣ W.r := Nat.dvd_of_mul_dvd_mul_left (by norm_num) hdiv
    rcases hr.eq_one_or_self_of_dvd d hdr with h | h
    · omega
    · exfalso
      have : p * p ≤ p ^ a := by
        rw [← pow_two]; exact Nat.pow_le_pow_right (by omega) ha2
      have : 2 * p ≤ p * p := Nat.mul_le_mul_right p hp2
      omega
  subst hp3
  obtain ⟨m, hm⟩ := Nat.even_or_odd' a
  rcases hm with rfl | rfl
  · -- a even: 9^m ≡ 1 (mod 8), so 8 ∣ 2r and r is even, r = 2, c = 5 ≠ 3^a
    exfalso
    have h9 : 3 ^ (2 * m) % 8 = 1 := by
      rw [pow_mul, Nat.pow_mod]; norm_num
    have : W.r % 2 = 0 := by omega
    have : W.r = 2 := by
      rcases hr.eq_one_or_self_of_dvd 2 (Nat.dvd_of_mod_eq_zero this) with h | h <;> omega
    omega
  · rcases Nat.lt_or_ge m 2 with hm2 | hm2
    · -- a = 3: (27, 13)
      interval_cases m
      · omega
      · right; simp [excPairs]; norm_num at hcp; omega
    · left
      -- 3^m = 2A + 1, c = 3·(2A+1)², A ≥ 4
      have h3m : (3 ^ m) % 2 = 1 := pow_odd_of_odd (by norm_num)
      obtain ⟨A, hA⟩ : ∃ A, 3 ^ m = 2 * A + 1 := ⟨3 ^ m / 2, by omega⟩
      have h9 : 9 ≤ 3 ^ m := by
        calc 9 = 3 ^ 2 := by norm_num
          _ ≤ 3 ^ m := Nat.pow_le_pow_right (by norm_num) hm2
      have hA4 : 4 ≤ A := by omega
      have hc3 : W.c = 3 * ((2 * A + 1) * (2 * A + 1)) := by
        rw [hcp, pow_succ, show 3 ^ (2 * m) = 3 ^ m * 3 ^ m by rw [two_mul, pow_add], hA]; ring
      have hr' : 2 * W.r + 1 = 3 * ((2 * A + 1) * (2 * A + 1)) := by omega
      have hA3 : A % 3 = 1 := by
        have : (3 ^ m) % 3 = 0 := by
          rw [show m = (m - 1) + 1 by omega, pow_succ]; simp
        omega
      have hX : (2 * (A * (A + 1))) % 3 ≠ 0 := by
        simp [Nat.mul_mod, Nat.add_mod, hA3]
      have hrA : W.r = 6 * (A * A) + 6 * A + 1 := by nlinarith
      have ht : q ^ e ∣ 3 * (2 * (A * (A + 1))) := by
        rw [← he]; convert htd using 1; rw [hrA]; ring_nf; omega
      have h := e3_repunit A W.r W.n q e hA4 (isPrimeN_of_prime' hq) hr' hX ht
        (by rw [← hc3]; omega) false
      rw [← he] at h
      exact lt_of_le_of_lt (Nat.mul_le_mul_left 25 (safe_le_orb W)) h

/-- **Theorem E.5, assembled.**  For an admissible fallback configuration W that is not the
bare safe-prime pair: 25·SAFE(W) < C(n,2), or (c, r) is one of the six exception pairs. -/
theorem e5 (W : Fallback) (p a q : ℕ) (hW : Admissible W p a q) (hnb : ¬ W.Bare) :
    25 * W.safe < pairs W.n ∨ (W.c, W.r) ∈ excPairs := by
  have hW' := hW
  obtain ⟨hp, ha, hcp, hF, hr, -, hrd, -, -, -, -, -⟩ := hW'
  obtain ⟨s, hs⟩ := hrd
  have hc2 : 2 ≤ W.c := by
    rw [hcp]; calc 2 ≤ p := hp.two_le
      _ = p ^ 1 := (pow_one p).symm
      _ ≤ p ^ a := Nat.pow_le_pow_right hp.pos ha
  have hr1 := hr.two_le
  have hcs : W.c = s * W.r + 1 := by rw [Nat.mul_comm]; omega
  rcases Nat.lt_or_ge s 4 with h4 | h4
  · interval_cases s
    · omega
    · exact e5_s1 W p a q hW (by omega)
    · rcases Nat.lt_or_ge a 2 with ha1 | ha2
      · have : a = 1 := by omega
        subst this
        exact Or.inl (e5_s2a1 W p q hW (by omega) hnb)
      · exact e5_s2a2 W p a q hW ha2 (by omega)
    · exact e5_s3 W p a q hW (by omega)
  · exact Or.inl (e5_s_ge4 W s hF (by omega) h4 hcs)

/-! ### The text's table records one configuration per n

At n = 23 and n = 31 the table lists F = 1 with a leftover 8 or 2·8; the class (8, 7) with
F = 2 or F = 3 and no leftover is another exception at the same n, with the same SAFE.  So the
table's "12 exceptions" count values of n, not configurations. -/
def ex23F2 : Fallback := ⟨2, 8, 7, 3, []⟩
def ex31F3 : Fallback := ⟨3, 8, 7, 3, []⟩

theorem exceptions_more :
    (ex23F2.n = 23 ∧ ex23F2.safe = 21 ∧ pairs 23 ≤ 25 * ex23F2.safe) ∧
    (ex31F3.n = 31 ∧ ex31F3.safe = 21 ∧ pairs 31 ≤ 25 * ex31F3.safe) := by
  decide

end E5Assembly

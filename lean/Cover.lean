/-
# `Cover.lean` — the ⇒ direction of `arithmetic-of-density.md` §6, packaged

§6.4/§6.6's covering statement: a floor on SAFE above C(n,2)/25 forces n into a finite, explicit
list of additive prime systems, the list shrinking as the floor rises.

* `ShapeD δ Fmax n` — the systems left (`Prop1Final.prop1`, `TwoForeign`):
  - **escapes:** n = F·c with F ≤ 25 (S2, no foreign part) or n = r (a lone foreign prime);
  - n = F·c + r with F ≤ Fmax (S3/S4/S5/S7);
  - n = r₁ + r₂, only if δ < 1/9 (S6); n = F·c + r₁ + r₂ with F ≤ Fmax, only if δ < 1/16 (S11);
  with c = p^b (b ≥ 1, p prime), every r prime and ≠ p, the r's distinct.
* `fbound` — the fusion ceiling as an inequality: √δ·(n − 1)·(1 + √F) ≤ n, i.e.
  δ ≤ (n/(n−1))²·cap_F(1).
* `cover_floor` — pointwise; D2 parts only at n < 614 (`E6.d2_small`).
* `cover_hyp` — under either quantifier (`BCG.Hyp`, L ≤ atTop): `Floor δ` L-eventually ⇒
  `ShapeD δ (min 15 Fmax)` L-eventually, whenever cap_{Fmax+1}(1) < δ.  Instances: `cover_25`
  (δ > 1/25: F ≤ 15), `cover_16` (δ > 1/16: F ≤ 8, no S11), `cover_9` (δ > 1/9: F ≤ 3, no S6, S11).
* `fexact` — at a perfect square F = s² the ceiling 1/(1 + s)² is never reached at finite n;
  hence the closed floors `cover_hyp_closed`, `cover_16_closed` (δ ≥ 1/16: F ≤ 8) and
  `cover_9_closed` (δ ≥ 1/9: F ≤ 3, no S6, no S11).
* `parity_one`, `parity_two` — §6.4's parity rule, for odd p and odd foreign primes.

**Not included.**  The hypothesis is on SAFE (B_safe), not on μ\*: μ\* ≤ B_safe is the
enumeration proof (Part 0), unformalised.  The escapes stay as disjuncts here; `CoverDensity`
counts them, O(x/log x), and drops them at that rate — not at (AA)'s O(x/(log x)^A), since the
primes alone are ≍ x/log x.  Local obstructions
(§6.3(c)) are not applied.  Boundaries: δ₀ = 1/16 and 1/9 are covered for the F-bounds
(`fexact`) and for S6/S11 (`TwoForeign.s6_ceiling_lt`, `s11_ceiling_lt`); δ₀ = 1/25 is not
(Proposition 1 is strict).
-/
import Prop1Final
import TwoForeign
import BCG

namespace Cover
open E6 ArkCore Prop1Final TwoForeign Filter Real

/-- The systems left at a floor δ above C(n,2)/25, with fusion bound `Fmax` on a class that has
company (Propositions 1 and 2).  The two-foreign systems carry their ceilings as side conditions:
S6 only if δ < 1/9, S11 only if δ < 1/16 (`TwoForeign`'s strict ceilings). -/
def ShapeD (δ : ℝ) (Fmax n : ℕ) : Prop :=
  -- S2: one class, no foreign part (escape); F ≤ 25 by the class's own ceiling
  (∃ F p b, 1 ≤ F ∧ F ≤ 25 ∧ p.Prime ∧ 1 ≤ b ∧ n = F * p ^ b) ∨
  -- a lone foreign prime (escape)
  n.Prime ∨
  -- S3/S4/S5/S7: a class and one foreign prime
  (∃ F p b r, 1 ≤ F ∧ F ≤ Fmax ∧ p.Prime ∧ 1 ≤ b ∧ r.Prime ∧ r ≠ p ∧ n = F * p ^ b + r) ∨
  -- S6: two foreign primes
  (δ < 1 / 9 ∧ ∃ r₁ r₂, r₁.Prime ∧ r₂.Prime ∧ r₁ ≠ r₂ ∧ n = r₁ + r₂) ∨
  -- S11: a class and two foreign primes
  (δ < 1 / 16 ∧ ∃ F p b r₁ r₂, 1 ≤ F ∧ F ≤ Fmax ∧ p.Prime ∧ 1 ≤ b ∧ r₁.Prime ∧ r₂.Prime ∧
    r₁ ≠ p ∧ r₂ ≠ p ∧ r₁ ≠ r₂ ∧ n = F * p ^ b + r₁ + r₂)

/-- The systems left above C(n,2)/25 (Proposition 1): `ShapeD` with no floor condition and F ≤ 15. -/
abbrev Shape (n : ℕ) : Prop := ShapeD 0 15 n

/-- **The fusion ceiling, as an inequality.**  A class F·c beside a part of size m inside n points,
both worth at least δ·C(n,2): then √δ·(n − 1)·(1 + √F) ≤ n — so δ ≤ (n/(n−1))²·cap_F(1). -/
theorem fbound {F c m n : ℕ} {δ : ℝ} (hδ : 0 ≤ δ) (hn1 : 1 ≤ n) (hn : F * c + m ≤ n)
    (h1 : δ * (pairs n : ℝ) ≤ F * pairs c) (h2 : δ * (pairs n : ℝ) ≤ pairs m) :
    √δ * (n - 1) * (1 + √F) ≤ n := by
  have tp : ∀ k : ℕ, (2 * pairs k : ℝ) = k * ((k : ℝ) - 1) := by
    intro k
    have := two_pairs k
    rcases Nat.eq_zero_or_pos k with rfl | hk
    · simp [pairs]
    · have e : ((k - 1 : ℕ) : ℝ) = k - 1 := by rw [Nat.cast_sub hk]; simp
      rw [← e]; exact_mod_cast this
  have hn' : (1 : ℝ) ≤ n := by exact_mod_cast hn1
  have hA : δ * ((n : ℝ) - 1) ^ 2 ≤ δ * (2 * pairs n) := by
    rw [tp]; apply mul_le_mul_of_nonneg_left _ hδ; nlinarith
  have hc : (√δ * (n - 1)) ^ 2 ≤ (√F * c) ^ 2 := by
    rw [mul_pow, mul_pow, sq_sqrt hδ, sq_sqrt (by positivity)]
    have := tp c
    have hc0 : (0 : ℝ) ≤ c := by positivity
    nlinarith
  have hm : (√δ * (n - 1)) ^ 2 ≤ (m : ℝ) ^ 2 := by
    rw [mul_pow, sq_sqrt hδ]
    have := tp m
    have hm0 : (0 : ℝ) ≤ m := by positivity
    nlinarith
  have hpos : 0 ≤ √δ * ((n : ℝ) - 1) := mul_nonneg (sqrt_nonneg _) (by linarith)
  have e1 : √δ * ((n : ℝ) - 1) ≤ √F * c := (pow_le_pow_iff_left₀ hpos (by positivity) two_ne_zero).mp hc
  have e2 : √δ * ((n : ℝ) - 1) ≤ m := (pow_le_pow_iff_left₀ hpos (by positivity) two_ne_zero).mp hm
  have hF : (F : ℝ) * c = √F * (√F * c) := by rw [← mul_assoc, mul_self_sqrt (by positivity)]
  have hnR : (F : ℝ) * c + m ≤ n := by exact_mod_cast hn
  have : √F * (√δ * ((n : ℝ) - 1)) ≤ √F * (√F * c) := mul_le_mul_of_nonneg_left e1 (sqrt_nonneg _)
  nlinarith

/-- **The fusion ceiling at a perfect square, exactly.**  For F = s² (s ≥ 1), a class F·c beside a
part of size m inside n ≥ 2 points cannot both be worth δ·C(n,2) once δ·(1 + s)² ≥ 1: the
ceiling cap_F(1) = 1/(1 + s)² is never reached at finite n. -/
theorem fexact {s c m n : ℕ} {δ : ℝ} (hδ : 0 ≤ δ) (hs : 1 ≤ s) (hn2 : 2 ≤ n)
    (hn : s ^ 2 * c + m ≤ n) (h1 : δ * (pairs n : ℝ) ≤ s ^ 2 * pairs c)
    (h2 : δ * (pairs n : ℝ) ≤ pairs m) : δ * (1 + s) ^ 2 < 1 := by
  have tp : ∀ k : ℕ, (2 * pairs k : ℝ) = k * ((k : ℝ) - 1) := by
    intro k
    have := two_pairs k
    rcases Nat.eq_zero_or_pos k with rfl | hk
    · simp [pairs]
    · have e : ((k - 1 : ℕ) : ℝ) = k - 1 := by rw [Nat.cast_sub hk]; simp
      rw [← e]; exact_mod_cast this
  set X := δ * (pairs n : ℝ) with hX
  have hX0 : 0 ≤ X := by positivity
  have hPn : (0 : ℝ) < pairs n := by
    have := tp n
    have hn' : (2 : ℝ) ≤ n := by exact_mod_cast hn2
    nlinarith
  rcases hX0.eq_or_lt with hXz | hXp
  · have : δ = 0 := by
      rcases (mul_eq_zero.mp (hX ▸ hXz.symm)) with h | h
      · exact h
      · exact absurd h hPn.ne'
    subst this; norm_num
  set t := √(2 * X) with ht
  have ht0 : 0 ≤ t := sqrt_nonneg _
  have ht2 : t ^ 2 = 2 * X := sq_sqrt (by linarith)
  have sR : (1 : ℝ) ≤ s := by exact_mod_cast hs
  have hnR : (s : ℝ) ^ 2 * c + m ≤ n := by exact_mod_cast hn
  have hc := tp c
  have hm := tp m
  have hnn := tp n
  have c0 : (0 : ℝ) ≤ c := by positivity
  have m0 : (0 : ℝ) ≤ m := by positivity
  -- s·c − s/2 > t  and  m − 1/2 ≥ t
  have e1 : t < s * c - s / 2 := by
    have hq : t ^ 2 < (s * c - s / 2) ^ 2 := by nlinarith
    rcases le_or_gt (s * c - s / 2 : ℝ) 0 with h | h
    · exfalso
      have : (c : ℝ) < 1 := by nlinarith
      have hc0 : c = 0 := by
        have : c < 1 := by exact_mod_cast this
        omega
      subst hc0
      simp [pairs] at h1
      exact hXp.ne' (le_antisymm h1 hX0)
    · exact (pow_lt_pow_iff_left₀ ht0 h.le two_ne_zero).mp hq
  have e2 : t ≤ m - 1 / 2 := by
    have hq : t ^ 2 ≤ (m - 1 / 2 : ℝ) ^ 2 := by nlinarith
    rcases le_or_gt (m - 1 / 2 : ℝ) 0 with h | h
    · have : (m : ℝ) < 1 := by linarith
      have hm0 : m = 0 := by
        have : m < 1 := by exact_mod_cast this
        omega
      subst hm0
      simp [pairs] at h2
      linarith
    · exact (pow_le_pow_iff_left₀ ht0 h.le two_ne_zero).mp hq
  have e3 : (s + 1) * t + s ^ 2 / 2 < n - 1 / 2 := by
    have := mul_lt_mul_of_pos_left e1 (show (0 : ℝ) < s by linarith)
    nlinarith
  have e4 : ((s + 1) * t) ^ 2 < (n : ℝ) * (n - 1) := by
    have h0 : 0 ≤ (s + 1) * t := by positivity
    have h5 : ((s + 1) * t + s ^ 2 / 2) ^ 2 < (n - 1 / 2 : ℝ) ^ 2 :=
      pow_lt_pow_left₀ e3 (by positivity) two_ne_zero
    have h6 : (1 : ℝ) ≤ (s : ℝ) ^ 4 := one_le_pow₀ sR
    have h7 : ((s + 1) * t) ^ 2 + 1 / 4 ≤ ((s + 1) * t + s ^ 2 / 2) ^ 2 := by nlinarith
    nlinarith
  rw [mul_pow, ht2] at e4
  by_contra hcon
  push Not at hcon
  nlinarith

theorem sum_split (l : List CPart) (h : ∀ F r t, CPart.fo F r t ∉ l) :
    (l.map CPart.sizeC).sum =
      ((l.filter isPc).map CPart.sizeC).sum + ((l.filter isFr).map CPart.sizeC).sum := by
  induction l with
  | nil => simp
  | cons x xs ih =>
    have h' : ∀ F r t, CPart.fo F r t ∉ xs := fun F r t hm => h F r t (List.mem_cons_of_mem _ hm)
    have := ih h'
    cases x with
    | pc => simp [List.filter_cons, isPc, isFr]; omega
    | fr => simp [List.filter_cons, isPc, isFr]; omega
    | fo F r t => exact absurd (by simp) (h F r t)

theorem pc_of_mem {l : List CPart} {x : CPart} (hx : x ∈ l.filter isPc) :
    ∃ F c d, x = .pc F c d ∧ x ∈ l := by
  rw [List.mem_filter] at hx
  cases x with
  | pc F c d => exact ⟨F, c, d, rfl, hx.1⟩
  | fr => simp [isPc] at hx
  | fo => simp [isPc] at hx

theorem fr_of_mem {l : List CPart} {x : CPart} (hx : x ∈ l.filter isFr) :
    ∃ r t, x = .fr r t ∧ x ∈ l := by
  rw [List.mem_filter] at hx
  cases x with
  | fr r t => exact ⟨r, t, rfl, hx.1⟩
  | pc => simp [isFr] at hx
  | fo => simp [isFr] at hx

theorem parts_perm (l : List CPart) (h : ∀ F r t, CPart.fo F r t ∉ l) :
    l.Perm (l.filter isPc ++ l.filter isFr) := by
  have e : l.filter (fun x => !isPc x) = l.filter isFr := by
    apply List.filter_congr
    intro x hx
    cases x with
    | pc => rfl
    | fr => rfl
    | fo F r t => exact absurd hx (h F r t)
  rw [← e]; exact (List.filter_append_perm _ _).symm

/-- A D2-free admissible configuration of at most one class and two foreign parts, at floor δ
(δ·C(n,2) ≤ SAFE, n ≥ 2), realises `ShapeD δ Fmax` — given F ≤ Fmax for a class with company. -/
theorem shape_of_small (δ : ℝ) (Fmax : ℕ) (C : Config) (hC : GAdm C) (hfo : C.FoFree)
    (h1 : (C.parts.filter isPc).length ≤ 1) (h2 : (C.parts.filter isFr).length ≤ 2)
    (hF : ∀ F c d, CPart.pc F c d ∈ C.parts → 2 ≤ C.parts.length → F ≤ Fmax)
    (hδ : 1 / 25 < δ) (hfl : δ * (pairs C.n : ℝ) ≤ C.safe) (hpos : 0 < pairs C.n) :
    ShapeD δ Fmax C.n := by
  have hC0 := hC
  obtain ⟨hp, -, hadm, hnd⟩ := hC
  have hn : C.n = ((C.parts.filter isPc).map CPart.sizeC).sum +
      ((C.parts.filter isFr).map CPart.sizeC).sum := sum_split _ hfo
  have hlen := length_split _ hfo
  have hperm := parts_perm _ hfo
  have hsubF : ((C.parts.filter isFr).filterMap (fun x => match x with
      | .fr r _ => some r | .fo _ r _ => some r | .pc _ _ _ => none)).Nodup :=
    hnd.sublist ((List.filter_sublist).filterMap _)
  have hcls : ∀ F c d, CPart.pc F c d ∈ C.parts → 1 ≤ F ∧ ∃ b, 1 ≤ b ∧ c = C.p ^ b :=
    fun F c d hm => let h := hadm _ hm; ⟨h.1, h.2.1⟩
  have hfr : ∀ r t, CPart.fr r t ∈ C.parts → r.Prime ∧ r ≠ C.p :=
    fun r t hm => let h := hadm _ hm; ⟨h.1, h.2.1⟩
  have hPR : (0 : ℝ) < pairs C.n := by exact_mod_cast hpos
  -- a ceiling k·SAFE ≤ C(n,2) caps the floor at 1/k
  have hcap : ∀ k : ℕ, 0 < k → k * C.safe < pairs C.n → δ < 1 / k := by
    intro k hk hks
    have hks' : (k : ℝ) * C.safe < pairs C.n := by exact_mod_cast hks
    have hkR : (0 : ℝ) < k := by exact_mod_cast hk
    rw [lt_div_iff₀ hkR]
    by_contra hcon
    push Not at hcon
    have : (pairs C.n : ℝ) ≤ δ * k * pairs C.n := by nlinarith
    nlinarith
  generalize hP : C.parts.filter isPc = P at *
  generalize hR : C.parts.filter isFr = R at *
  have hPm : ∀ x ∈ P, ∃ F c d, x = .pc F c d ∧ x ∈ C.parts := fun x hx => pc_of_mem (hP ▸ hx)
  have hRm : ∀ x ∈ R, ∃ r t, x = .fr r t ∧ x ∈ C.parts := fun x hx => fr_of_mem (hR ▸ hx)
  match P, R, h1, h2, hPm, hRm, hlen, hn, hsubF, hperm with
  | [], [], _, _, _, _, hlen, _, _, _ =>
    exfalso
    have : C.parts = [] := List.length_eq_zero_iff.mp (by simpa using hlen)
    have h0 : C.n = 0 := by simp [Config.n, Config.sizes, this]
    rw [h0] at hpos; simp [pairs] at hpos
  | [x], [], _, _, hPm, _, _, hn, _, _ =>
    obtain ⟨F, c, d, rfl, hm⟩ := hPm x (by simp)
    obtain ⟨hF1, b, hb, rfl⟩ := hcls _ _ _ hm
    have hnF : C.n = F * C.p ^ b := by simpa [CPart.sizeC] using hn
    refine Or.inl ⟨F, C.p, b, hF1, ?_, hp, hb, hnF⟩
    -- δ·C(F·c, 2) ≤ F·C(c, 2) forces F < 26 when δ > 1/25
    have e1 : C.safe ≤ F * pairs (C.p ^ b) :=
      safe_le_term C hm (by simp [CPart.safeTerms, E5Assembly.Part.terms])
    have hc2 : 2 ≤ C.p ^ b := le_trans hp.two_le (Nat.le_self_pow (by omega) _)
    by_contra hF
    push Not at hF
    have g : δ * (pairs C.n : ℝ) ≤ F * pairs (C.p ^ b) := le_trans hfl (by exact_mod_cast e1)
    rw [hnF] at g
    have t1 := two_pairs (F * C.p ^ b)
    have t2 := two_pairs (C.p ^ b)
    generalize C.p ^ b = c at *
    generalize hA : pairs (F * c) = A at *
    generalize hB : pairs c = B at *
    have hFc : 2 ≤ F * c := le_trans hc2 (Nat.le_mul_of_pos_left _ (by omega))
    have t1' : (2 * A : ℝ) = (F * c : ℝ) * ((F * c : ℝ) - 1) := by
      have : ((F * c - 1 : ℕ) : ℝ) = (F * c : ℝ) - 1 := by
        rw [Nat.cast_sub (by omega)]; push_cast; ring
      rw [← this]; exact_mod_cast t1
    have t2' : (2 * B : ℝ) = (c : ℝ) * ((c : ℝ) - 1) := by
      have : ((c - 1 : ℕ) : ℝ) = (c : ℝ) - 1 := by rw [Nat.cast_sub (by omega)]; simp
      rw [← this]; exact_mod_cast t2
    have cR : (2 : ℝ) ≤ c := by exact_mod_cast hc2
    have FR : (26 : ℝ) ≤ F := by exact_mod_cast hF
    have hFcR : (0 : ℝ) < F * c := by positivity
    have key : (F * c : ℝ) * (δ * ((F * c : ℝ) - 1)) ≤ (F * c : ℝ) * ((c : ℝ) - 1) := by
      have : δ * (2 * A) ≤ F * (2 * B) := by nlinarith
      rw [t1', t2'] at this; nlinarith
    have h3 : δ * ((F * c : ℝ) - 1) ≤ (c : ℝ) - 1 := le_of_mul_le_mul_left key hFcR
    have : (1 / 25 : ℝ) * ((F * c : ℝ) - 1) < δ * ((F * c : ℝ) - 1) := by
      apply mul_lt_mul_of_pos_right hδ; nlinarith
    nlinarith
  | [], [y], _, _, _, hRm, _, hn, _, _ =>
    obtain ⟨r, t, rfl, hm⟩ := hRm y (by simp)
    exact Or.inr (Or.inl (by simpa [CPart.sizeC, hn] using (hfr _ _ hm).1))
  | [x], [y], _, _, hPm, hRm, hlen, hn, _, _ =>
    obtain ⟨F, c, d, rfl, hm⟩ := hPm x (by simp)
    obtain ⟨r, t, rfl, hm'⟩ := hRm y (by simp)
    obtain ⟨hF1, b, hb, rfl⟩ := hcls _ _ _ hm
    obtain ⟨hr, hrp⟩ := hfr _ _ hm'
    exact Or.inr (Or.inr (Or.inl ⟨F, C.p, b, r, hF1, hF _ _ _ hm (by simp at hlen; omega),
      hp, hb, hr, hrp, by simpa [CPart.sizeC] using hn⟩))
  | [], [y, z], _, _, _, hRm, _, hn, hsub, hperm =>
    obtain ⟨r, t, rfl, hm⟩ := hRm y (by simp)
    obtain ⟨r', t', rfl, hm'⟩ := hRm z (by simp)
    have hne : r ≠ r' := by simpa using hsub
    have h9 : δ < 1 / 9 := by
      rcases Nat.lt_or_gt_of_ne hne with hlt | hlt
      · exact_mod_cast hcap 9 (by norm_num) (s6_ceiling_lt C hC0 (by simpa using hperm) hlt)
      · exact_mod_cast hcap 9 (by norm_num)
          (s6_ceiling_lt C hC0 (hperm.trans (by simpa using List.Perm.swap _ _ _)) hlt)
    exact Or.inr (Or.inr (Or.inr (Or.inl ⟨by exact_mod_cast h9, r, r', (hfr _ _ hm).1,
      (hfr _ _ hm').1, hne, by simpa [CPart.sizeC] using hn⟩)))
  | [x], [y, z], _, _, hPm, hRm, hlen, hn, hsub, hperm =>
    obtain ⟨F, c, d, rfl, hm⟩ := hPm x (by simp)
    obtain ⟨r, t, rfl, hm1⟩ := hRm y (by simp)
    obtain ⟨r', t', rfl, hm2⟩ := hRm z (by simp)
    have hne : r ≠ r' := by simpa using hsub
    have h16 : δ < 1 / 16 := by
      rcases Nat.lt_or_gt_of_ne hne with hlt | hlt
      · exact_mod_cast hcap 16 (by norm_num) (s11_ceiling_lt C hC0 (by simpa using hperm) hlt)
      · have hsw : ([CPart.pc F c d] ++ [CPart.fr r t, CPart.fr r' t']).Perm
            [CPart.pc F c d, CPart.fr r' t', CPart.fr r t] :=
          (List.Perm.swap (CPart.fr r' t') (CPart.fr r t) []).cons (CPart.pc F c d)
        exact_mod_cast hcap 16 (by norm_num) (s11_ceiling_lt C hC0 (hperm.trans hsw) hlt)
    obtain ⟨hF1, b, hb, rfl⟩ := hcls _ _ _ hm
    exact Or.inr (Or.inr (Or.inr (Or.inr ⟨by exact_mod_cast h16, F, C.p, b, r, r', hF1,
      hF _ _ _ hm (by simp at hlen; omega), hp, hb, (hfr _ _ hm1).1, (hfr _ _ hm2).1,
      (hfr _ _ hm1).2, (hfr _ _ hm2).2, hne, by simp [CPart.sizeC] at hn; omega⟩)))
  | _ :: _ :: _, _, h1, _, _, _, _, _, _, _ => simp at h1
  | _, _ :: _ :: _ :: _, _, h2, _, _, _, _, _, _ => simp at h2

theorem sum_two_le {l : List CPart} {a b : CPart} (ha : a ∈ l) (hb : b ∈ l) (hab : a ≠ b) :
    a.sizeC + b.sizeC ≤ (l.map CPart.sizeC).sum := by
  have hp := List.perm_cons_erase ha
  have hb' : b ∈ l.erase a := (List.mem_erase_of_ne (Ne.symm hab)).mpr hb
  rw [(hp.map _).sum_eq, List.map_cons, List.sum_cons]
  have := List.le_sum_of_mem (List.mem_map_of_mem (f := CPart.sizeC) hb')
  omega

/-- **The covering statement at a floor, pointwise.**  If some admissible configuration at n has
SAFE ≥ δ·C(n,2) with δ > 1/25, and every class with company obeys the fusion ceiling at Fmax
(`hlam`: F > Fmax is excluded by `fbound`), then n < 614 or n realises `ShapeD δ (min 15 Fmax)`. -/
theorem cover_floor (δ : ℝ) (hδ : 1 / 25 < δ) (Fmax : ℕ) (C : Config) (hC : GAdm C)
    (hn2 : 2 ≤ C.n) (hfl : δ * (pairs C.n : ℝ) ≤ C.safe)
    (hlam : ∀ F : ℕ, Fmax < F → (C.n : ℝ) < √δ * (C.n - 1) * (1 + √F) ∨
      ∃ s : ℕ, 1 ≤ s ∧ F = s ^ 2 ∧ 1 ≤ δ * (1 + s) ^ 2) :
    C.n < 614 ∨ ShapeD δ (min 15 Fmax) C.n := by
  have hpos : 0 < pairs C.n := by
    unfold pairs; apply Nat.div_pos _ (by norm_num)
    have := Nat.mul_le_mul hn2 (show 1 ≤ C.n - 1 by omega); omega
  have hPR : (0 : ℝ) < pairs C.n := by exact_mod_cast hpos
  have habove : pairs C.n < 25 * C.safe := by
    have : (pairs C.n : ℝ) < 25 * C.safe := by nlinarith
    exact_mod_cast this
  by_cases hfo : C.FoFree
  · right
    obtain ⟨C', g, f, hn, hs, hc, hr, -, hF⟩ := prop1 C hC hfo habove
    have hfl' : δ * (pairs C'.n : ℝ) ≤ C'.safe := by
      rw [hn]; exact le_trans hfl (by exact_mod_cast hs)
    rw [← hn]
    refine shape_of_small δ _ C' g f hc hr ?_ hδ hfl' (hn ▸ hpos)
    intro F c d hm hlen
    refine le_min (hF F c d hm hlen) ?_
    by_contra hcon
    push Not at hcon
    -- a second part y beside the class
    obtain ⟨y, hy, hyne⟩ : ∃ y ∈ C'.parts, y ≠ CPart.pc F c d := by
      by_contra hall
      push Not at hall
      have : C'.parts.filter isPc = C'.parts :=
        List.filter_eq_self.mpr (fun a ha => by rw [hall a ha]; rfl)
      rw [this] at hc; omega
    obtain ⟨z, hz, hzle⟩ := Prop1.exists_term_le y
    have e1 : C'.safe ≤ F * pairs c := safe_le_term C' hm (by simp [CPart.safeTerms, E5Assembly.Part.terms])
    have e2 : C'.safe ≤ pairs y.sizeC := le_trans (safe_le_term C' hy hz) hzle
    have hsz : F * c + y.sizeC ≤ C'.n := by
      have := sum_two_le hm hy (Ne.symm hyne); simpa [CPart.sizeC, Config.n, Config.sizes] using this
    have hδ0 : (0 : ℝ) ≤ δ := le_of_lt (lt_trans (by norm_num) hδ)
    have g1 : δ * (pairs C'.n : ℝ) ≤ F * pairs c := le_trans hfl' (by exact_mod_cast e1)
    have g2 : δ * (pairs C'.n : ℝ) ≤ pairs y.sizeC := le_trans hfl' (by exact_mod_cast e2)
    rcases hlam F hcon with hl | ⟨s, hs1, rfl, hsq⟩
    · have hb := fbound hδ0 (by omega) hsz g1 g2
      rw [← hn] at hl
      linarith
    · have := fexact hδ0 hs1 (by omega) hsz (by exact_mod_cast g1) g2
      linarith
  · left
    simp only [Config.FoFree, not_forall, not_not] at hfo
    obtain ⟨F, r, t, hx⟩ := hfo
    obtain ⟨hb, hFr⟩ := safe_le_bnd C hx
    obtain ⟨hF2, hrP, -, -, -⟩ := hC.2.2.1 _ hx
    have hlt : pairs C.n < 25 * bnd F r C.n := lt_of_lt_of_le habove (Nat.mul_le_mul_left 25 hb)
    exact (d2_small hF2 hrP.two_le hFr (bnd_le_bnd0 F r C.n) hlt).2.2

/-- **The floor hypothesis at n**, on SAFE: some admissible configuration at n has
SAFE ≥ δ·C(n,2) — that is, B_safe(n) ≥ δ·C(n,2). -/
def Floor (δ : ℝ) (n : ℕ) : Prop := ∃ C : Config, GAdm C ∧ C.n = n ∧ δ * (pairs n : ℝ) ≤ C.safe

/-- **The covering statement, under either quantifier** (§6.6, "for most n" read as L): a floor
δ > 1/25 holding L-eventually forces `ShapeD δ (min 15 Fmax)` L-eventually, for any Fmax whose
next fusion count is excluded by the ceiling, cap_{Fmax+1}(1) = 1/(1 + √(Fmax+1))² < δ. -/
theorem cover_hyp {L : Filter ℕ} (hL : L ≤ atTop) {δ : ℝ} (hδ : 1 / 25 < δ) (Fmax : ℕ)
    (hcap : 1 < √δ * (1 + √((Fmax + 1 : ℕ) : ℝ))) (H : BCG.Hyp (Floor δ) L) :
    BCG.Hyp (ShapeD δ (min 15 Fmax)) L := by
  set lam := √δ * (1 + √((Fmax + 1 : ℕ) : ℝ))
  have hev : ∀ᶠ n : ℕ in atTop, lam / (lam - 1) < (n : ℝ) :=
    tendsto_natCast_atTop_atTop.eventually_gt_atTop _
  filter_upwards [H, hL (eventually_ge_atTop 614), hL hev] with n ⟨C, hC, hCn, hfl⟩ h614 hbig
  subst hCn
  have hlam : ∀ F : ℕ, Fmax < F → (C.n : ℝ) < √δ * (C.n - 1) * (1 + √F) := by
    intro F hF
    have hl1 : 0 < lam - 1 := by linarith
    have h1 : lam ≤ √δ * (1 + √F) := by
      apply mul_le_mul_of_nonneg_left _ (sqrt_nonneg _)
      have : ((Fmax + 1 : ℕ) : ℝ) ≤ F := by exact_mod_cast hF
      linarith [sqrt_le_sqrt this]
    have h2 : (C.n : ℝ) < lam * (C.n - 1) := by
      rw [div_lt_iff₀ hl1] at hbig; nlinarith
    have hn1 : (0 : ℝ) ≤ C.n - 1 := by
      have : (614 : ℝ) ≤ C.n := by exact_mod_cast h614
      linarith
    nlinarith
  rcases cover_floor δ hδ Fmax C hC (by omega) hfl (fun F hF => Or.inl (hlam F hF)) with h | h
  · omega
  · exact h

/-- **At 1/25**: Proposition 1's list (F ≤ 15, with S6 and S11). -/
theorem cover_25 {L : Filter ℕ} (hL : L ≤ atTop) {δ : ℝ} (hδ : 1 / 25 < δ)
    (H : BCG.Hyp (Floor δ) L) : BCG.Hyp (ShapeD δ 15) L := by
  have := cover_hyp hL hδ 15 ?_ H
  · simpa using this
  have h4 : √((15 + 1 : ℕ) : ℝ) = 4 := by
    rw [show ((15 + 1 : ℕ) : ℝ) = 4 ^ 2 by norm_num]; exact sqrt_sq (by norm_num)
  rw [h4]
  have : (1 / 5 : ℝ) < √δ := by
    rw [show (1 / 5 : ℝ) = √(1 / 25) by
      rw [show (1 / 25 : ℝ) = (1 / 5) ^ 2 by norm_num]; exact (sqrt_sq (by norm_num)).symm]
    exact sqrt_lt_sqrt (by norm_num) hδ
  linarith

/-- **Above 1/16**: F ≤ 8 and S11 gone (§6.4: four systems at odd n, five at even n). -/
theorem cover_16 {L : Filter ℕ} (hL : L ≤ atTop) {δ : ℝ} (hδ : 1 / 16 < δ)
    (H : BCG.Hyp (Floor δ) L) :
    BCG.Hyp (fun n => ShapeD δ 8 n ∧ ¬ δ < 1 / 16) L := by
  have h25 : (1 : ℝ) / 25 < δ := by linarith
  have := cover_hyp hL h25 8 ?_ H
  · filter_upwards [this] with n h
    exact ⟨by simpa using h, by linarith⟩
  have h3 : √((8 + 1 : ℕ) : ℝ) = 3 := by
    rw [show ((8 + 1 : ℕ) : ℝ) = 3 ^ 2 by norm_num]; exact sqrt_sq (by norm_num)
  rw [h3]
  have : (1 / 4 : ℝ) < √δ := by
    rw [show (1 / 4 : ℝ) = √(1 / 16) by
      rw [show (1 / 16 : ℝ) = (1 / 4) ^ 2 by norm_num]; exact (sqrt_sq (by norm_num)).symm]
    exact sqrt_lt_sqrt (by norm_num) hδ
  linarith

/-- **Above 1/9**: F ≤ 3, S6 and S11 gone (§6.4: one system at odd n, two at even n). -/
theorem cover_9 {L : Filter ℕ} (hL : L ≤ atTop) {δ : ℝ} (hδ : 1 / 9 < δ)
    (H : BCG.Hyp (Floor δ) L) :
    BCG.Hyp (fun n => ShapeD δ 3 n ∧ ¬ δ < 1 / 9 ∧ ¬ δ < 1 / 16) L := by
  have h25 : (1 : ℝ) / 25 < δ := by linarith
  have := cover_hyp hL h25 3 ?_ H
  · filter_upwards [this] with n h
    exact ⟨by simpa using h, by linarith, by linarith⟩
  have h2 : √((3 + 1 : ℕ) : ℝ) = 2 := by
    rw [show ((3 + 1 : ℕ) : ℝ) = 2 ^ 2 by norm_num]; exact sqrt_sq (by norm_num)
  rw [h2]
  have : (1 / 3 : ℝ) < √δ := by
    rw [show (1 / 3 : ℝ) = √(1 / 9) by
      rw [show (1 / 9 : ℝ) = (1 / 3) ^ 2 by norm_num]; exact (sqrt_sq (by norm_num)).symm]
    exact sqrt_lt_sqrt (by norm_num) hδ
  linarith

/-- **The covering statement at a closed floor.**  As `cover_hyp`, but with δ allowed to sit
exactly on the ceiling of the next fusion count when that count is a perfect square:
Fmax + 1 = s², δ·(1 + s)² ≥ 1 (`fexact`), the count after it excluded asymptotically. -/
theorem cover_hyp_closed {L : Filter ℕ} (hL : L ≤ atTop) {δ : ℝ} (hδ : 1 / 25 < δ) (Fmax s : ℕ)
    (hs : 1 ≤ s) (hsq : Fmax + 1 = s ^ 2) (hδs : 1 ≤ δ * (1 + s) ^ 2)
    (hcap : 1 < √δ * (1 + √((Fmax + 2 : ℕ) : ℝ))) (H : BCG.Hyp (Floor δ) L) :
    BCG.Hyp (ShapeD δ (min 15 Fmax)) L := by
  set lam := √δ * (1 + √((Fmax + 2 : ℕ) : ℝ))
  have hev : ∀ᶠ n : ℕ in atTop, lam / (lam - 1) < (n : ℝ) :=
    tendsto_natCast_atTop_atTop.eventually_gt_atTop _
  filter_upwards [H, hL (eventually_ge_atTop 614), hL hev] with n ⟨C, hC, hCn, hfl⟩ h614 hbig
  subst hCn
  have hlam : ∀ F : ℕ, Fmax < F → (C.n : ℝ) < √δ * (C.n - 1) * (1 + √F) ∨
      ∃ s : ℕ, 1 ≤ s ∧ F = s ^ 2 ∧ 1 ≤ δ * (1 + s) ^ 2 := by
    intro F hF
    rcases Nat.lt_or_ge F (Fmax + 2) with hF2 | hF2
    · exact Or.inr ⟨s, hs, by omega, hδs⟩
    left
    have hl1 : 0 < lam - 1 := by linarith
    have h1 : lam ≤ √δ * (1 + √F) := by
      apply mul_le_mul_of_nonneg_left _ (sqrt_nonneg _)
      have : ((Fmax + 2 : ℕ) : ℝ) ≤ F := by exact_mod_cast hF2
      linarith [sqrt_le_sqrt this]
    have h2 : (C.n : ℝ) < lam * (C.n - 1) := by
      rw [div_lt_iff₀ hl1] at hbig; nlinarith
    have hn1 : (0 : ℝ) ≤ C.n - 1 := by
      have : (614 : ℝ) ≤ C.n := by exact_mod_cast h614
      linarith
    nlinarith
  rcases cover_floor δ hδ Fmax C hC (by omega) hfl hlam with h | h
  · omega
  · exact h

/-- **At or above 1/16**: F ≤ 8 and no S11. -/
theorem cover_16_closed {L : Filter ℕ} (hL : L ≤ atTop) {δ : ℝ} (hδ : 1 / 16 ≤ δ)
    (H : BCG.Hyp (Floor δ) L) : BCG.Hyp (fun n => ShapeD δ 8 n ∧ ¬ δ < 1 / 16) L := by
  have := cover_hyp_closed hL (by linarith) 8 3 (by norm_num) (by norm_num) (by push_cast; linarith) ?_ H
  · filter_upwards [this] with n h
    exact ⟨by simpa using h, by linarith⟩
  have h4 : (1 / 4 : ℝ) ≤ √δ := by
    rw [show (1 / 4 : ℝ) = √(1 / 16) by
      rw [show (1 / 16 : ℝ) = (1 / 4) ^ 2 by norm_num]; exact (sqrt_sq (by norm_num)).symm]
    exact sqrt_le_sqrt hδ
  have h3 : (3 : ℝ) < √((8 + 2 : ℕ) : ℝ) := by
    rw [show (3 : ℝ) = √(3 ^ 2) by exact (sqrt_sq (by norm_num)).symm]
    exact sqrt_lt_sqrt (by norm_num) (by norm_num)
  nlinarith

/-- **At or above 1/9**: F ≤ 3, no S6, no S11. -/
theorem cover_9_closed {L : Filter ℕ} (hL : L ≤ atTop) {δ : ℝ} (hδ : 1 / 9 ≤ δ)
    (H : BCG.Hyp (Floor δ) L) :
    BCG.Hyp (fun n => ShapeD δ 3 n ∧ ¬ δ < 1 / 9 ∧ ¬ δ < 1 / 16) L := by
  have := cover_hyp_closed hL (by linarith) 3 2 (by norm_num) (by norm_num) (by push_cast; linarith) ?_ H
  · filter_upwards [this] with n h
    exact ⟨by simpa using h, by linarith, by linarith⟩
  have h4 : (1 / 3 : ℝ) ≤ √δ := by
    rw [show (1 / 3 : ℝ) = √(1 / 9) by
      rw [show (1 / 9 : ℝ) = (1 / 3) ^ 2 by norm_num]; exact (sqrt_sq (by norm_num)).symm]
    exact sqrt_le_sqrt hδ
  have h3 : (2 : ℝ) < √((3 + 2 : ℕ) : ℝ) := by
    rw [show (2 : ℝ) = √(2 ^ 2) by exact (sqrt_sq (by norm_num)).symm]
    exact sqrt_lt_sqrt (by norm_num) (by norm_num)
  nlinarith

/-- **§6.4's parity rule.**  With p odd, every system with a foreign part serves exactly the n of
the parity of its fusion count plus its number of foreign parts: n = F·c + r is odd iff F is
even, n = F·c + r₁ + r₂ is odd iff F is odd, n = r₁ + r₂ is even — given the foreign primes odd. -/
theorem parity_one {F p b r : ℕ} (hp : p.Prime) (hp2 : p ≠ 2) (hr : r.Prime) (hr2 : r ≠ 2) :
    (F * p ^ b + r) % 2 = (F + 1) % 2 := by
  have h1 : p % 2 = 1 := (Nat.Prime.eq_two_or_odd hp).resolve_left hp2
  have h2 : r % 2 = 1 := (Nat.Prime.eq_two_or_odd hr).resolve_left hr2
  have h3 : p ^ b % 2 = 1 := by rw [Nat.pow_mod, h1]; simp
  rw [Nat.add_mod, Nat.mul_mod, h3, h2]; simp [Nat.add_mod]

theorem parity_two {F p b r₁ r₂ : ℕ} (hp : p.Prime) (hp2 : p ≠ 2) (hr₁ : r₁.Prime) (h₁ : r₁ ≠ 2)
    (hr₂ : r₂.Prime) (h₂ : r₂ ≠ 2) : (F * p ^ b + r₁ + r₂) % 2 = F % 2 ∧ (r₁ + r₂) % 2 = 0 := by
  have h1 : p % 2 = 1 := (Nat.Prime.eq_two_or_odd hp).resolve_left hp2
  have e1 : r₁ % 2 = 1 := (Nat.Prime.eq_two_or_odd hr₁).resolve_left h₁
  have e2 : r₂ % 2 = 1 := (Nat.Prime.eq_two_or_odd hr₂).resolve_left h₂
  have h3 : p ^ b % 2 = 1 := by rw [Nat.pow_mod, h1]; simp
  have h4 : F * p ^ b % 2 = F % 2 := by rw [Nat.mul_mod, h3]; simp
  constructor <;> omega

end Cover

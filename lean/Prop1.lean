/-
# `Prop1.lean` — `ladder-completeness.md` Proposition 1, the counting clauses

Proposition 1 lists what a SAFE optimum above C(n,2)/25 can look like.  Its fusion-count
clause is: *cap_F(1) = 1/(1 + √F)² is the most S7 can reach at fusion count F, and it is below
1/25 for F ≥ 17, so F ≤ 16.*  This file proves the clause in the `E6` model, for any class
that sits beside at least one other part (S2, a class alone, is unconstrained, as in the text).

**Finding.** The bound is one better than stated: cap_16(1) = 1/25 *exactly*, so F = 16 also
fails the strict inequality, and the true conclusion is **F ≤ 15** (`fusion_cap`).  The
arithmetic is exact in ℕ, not only in the continuous ceiling:
25·min(F·C(c,2), C(s,2)) ≤ C(F·c + s, 2) whenever F ≥ 16 (`cap16`).  Stating F ≤ 16 is
still true; the ladder's menu (F ≤ 16) is merely one wider than needed.

Also proved, in the same model: the proof's opening line, every part has share > 1/5
(`part_share`) so there are at most four parts (`parts_le_four`); the efficiency clause for a
foreign part of share below 1/2, 2(r − 1) < 25t (`foreign_efficient`); and the S12 clause,
two matching classes merge without lowering SAFE (`merge_classes`).  For three foreign primes, the
efficiency reduction k₁ ≤ 5, k₂ ≤ 12, k₃ ≤ 17 (`three_foreign`).  Not here: the rest of that
exclusion (the text's enumeration and q ≥ 37 ratio argument), and the theorem's final form (the optimum *is* a menu shape or S6/S11).

The fusion-cap proof splits on s ≤ 4c (then n ≥ 5s and 25·C(s,2) ≤ C(5s,2)) or s > 4c (then
n ≥ (F + 4)c and (F + 4)² − 25F = (F − 1)(F − 16) ≥ 0).  The model input is that every part
has a SAFE term at most C(size, 2) (`exists_term_le`).
-/
import E6

namespace Prop1
open E6 ArkCore E5Assembly

/-- 25·C(s,2) ≤ C(5s,2). -/
theorem pairs_five (s : ℕ) : 25 * pairs s ≤ pairs (5 * s) := by
  have h1 := two_pairs s
  have h2 := two_pairs (5 * s)
  rcases Nat.eq_zero_or_pos s with rfl | hs
  · simp [pairs]
  have : 25 * (s * (s - 1)) ≤ 5 * s * (5 * s - 1) := by
    obtain ⟨k, rfl⟩ : ∃ k, s = k + 1 := ⟨s - 1, by omega⟩
    have : 5 * (k + 1) - 1 = 5 * k + 4 := by omega
    rw [this, Nat.add_sub_cancel]; nlinarith
  omega

/-- 25·F·C(c,2) ≤ C((F + 4)·c, 2) for F ≥ 16: (F + 4)² − 25F = (F − 1)(F − 16). -/
theorem pairs_F4 (F c : ℕ) (hF : 16 ≤ F) : 25 * (F * pairs c) ≤ pairs ((F + 4) * c) := by
  have h1 := two_pairs c
  have h2 := two_pairs ((F + 4) * c)
  rcases Nat.eq_zero_or_pos c with rfl | hc
  · simp [pairs]
  obtain ⟨k, rfl⟩ : ∃ k, c = k + 1 := ⟨c - 1, by omega⟩
  obtain ⟨G, rfl⟩ : ∃ G, F = G + 16 := ⟨F - 16, by omega⟩
  have e : (G + 16 + 4) * (k + 1) - 1 = (G + 20) * k + G + 19 := by
    have : (G + 16 + 4) * (k + 1) = (G + 20) * k + G + 20 := by ring
    omega
  have : 25 * ((G + 16) * ((k + 1) * (k + 1 - 1))) ≤
      (G + 16 + 4) * (k + 1) * ((G + 16 + 4) * (k + 1) - 1) := by
    rw [e, Nat.add_sub_cancel]; nlinarith [Nat.zero_le (G * G * k * k), Nat.zero_le (G * k * k)]
  have : 2 * (25 * ((G + 16) * pairs (k + 1))) ≤ 2 * pairs ((G + 16 + 4) * (k + 1)) := by
    calc 2 * (25 * ((G + 16) * pairs (k + 1)))
        = 25 * ((G + 16) * (2 * pairs (k + 1))) := by ring
      _ = 25 * ((G + 16) * ((k + 1) * (k + 1 - 1))) := by rw [h1]
      _ ≤ _ := this
      _ = _ := h2.symm
  omega

/-- **The cap, exactly in ℕ.** For F ≥ 16, a class of F blocks of size c beside a part of
size s scores at most C(F·c + s, 2)/25 on its two intra terms. -/
theorem cap16 (F c s m : ℕ) (hF : 16 ≤ F) (h1 : m ≤ F * pairs c) (h2 : m ≤ pairs s) :
    25 * m ≤ pairs (F * c + s) := by
  rcases le_or_gt s (4 * c) with hs | hs
  · calc 25 * m ≤ 25 * pairs s := by omega
      _ ≤ pairs (5 * s) := pairs_five s
      _ ≤ _ := pairs_mono (by nlinarith)
  · calc 25 * m ≤ 25 * (F * pairs c) := by omega
      _ ≤ pairs ((F + 4) * c) := pairs_F4 F c hF
      _ ≤ _ := pairs_mono (by nlinarith)

/-- Every part has a SAFE term at most C(size, 2). -/
theorem exists_term_le (x : CPart) : ∃ y ∈ x.safeTerms, y ≤ pairs x.sizeC := by
  cases x with
  | pc F c d => exact ⟨F * pairs c, by simp [CPart.safeTerms, Part.terms], mul_pairs_le F c⟩
  | fr r t => exact ⟨orb r t false, by simp [CPart.safeTerms], orb_le_pairs r t false⟩
  | fo F r t => exact ⟨F * pairs r, by simp [CPart.safeTerms], mul_pairs_le F r⟩

/-- **Proposition 1, fusion-count clause (sharpened).** If SAFE is above C(n,2)/25 and the
configuration has a class `pc F c d` and at least one other part `x` (in any order), then
F ≤ 15. -/
theorem fusion_cap (C : Config) {F c d : ℕ} {x : CPart} {rest : List CPart}
    (hparts : C.parts.Perm (.pc F c d :: x :: rest)) (habove : pairs C.n < 25 * C.safe) :
    F ≤ 15 := by
  by_contra hF
  obtain ⟨y, hy, hyle⟩ := exists_term_le x
  have hmem : ∀ z, z ∈ (CPart.pc F c d :: x :: rest).flatMap CPart.safeTerms →
      C.safe ≤ z := fun z hz => by
    apply minL_le; apply List.mem_append_left
    rw [List.mem_flatMap] at hz ⊢
    obtain ⟨w, hw, hzw⟩ := hz
    exact ⟨w, hparts.mem_iff.mpr hw, hzw⟩
  have h1 : C.safe ≤ F * pairs c := hmem _ (by simp [CPart.safeTerms, Part.terms])
  have h2 : C.safe ≤ pairs x.sizeC := le_trans (hmem y (by simp [hy])) hyle
  have hn : F * c + x.sizeC ≤ C.n := by
    have : C.n = ((CPart.pc F c d :: x :: rest).map CPart.sizeC).sum := by
      simp only [Config.n, Config.sizes]; exact (hparts.map _).sum_eq
    rw [this]; simp only [List.map_cons, List.sum_cons, CPart.sizeC]; omega
  have := cap16 F c x.sizeC C.safe (by omega) h1 h2
  have := pairs_mono hn
  omega

/-- The sharpened bound is tight: at F = 16, sixteen blocks of 5 beside a block of 20
(n = 100) give min(16·C(5,2), C(20,2)) = 160 with 25·160 = 4000 ≤ C(100,2) = 4950, and in the
continuous ceiling cap_16(1) = 1/(1 + 4)² = 1/25 exactly. -/
example : 25 * min (16 * pairs 5) (pairs 20) ≤ pairs 100 := by decide

/-! ## Share and part count (the proof's opening line) -/

/-- Above the line every part has share > 1/5: n + 3 ≤ 5·size. -/
theorem part_share (C : Config) {x : CPart} (hx : x ∈ C.parts)
    (habove : pairs C.n < 25 * C.safe) : C.n + 3 ≤ 5 * x.sizeC := by
  obtain ⟨y, hy, hyle⟩ := exists_term_le x
  have h : C.safe ≤ pairs x.sizeC :=
    le_trans (minL_le (List.mem_append_left _ (List.mem_flatMap.mpr ⟨x, hx, hy⟩))) hyle
  have hpos : 1 ≤ x.sizeC := by
    by_contra h0
    have : x.sizeC = 0 := by omega
    rw [this] at h; simp [pairs] at h; omega
  exact n_add3_le hpos (by omega)

theorem len_mul_le_sum (a : ℕ) : ∀ l : List ℕ, (∀ s ∈ l, a ≤ 5 * s) →
    l.length * a ≤ 5 * l.sum
  | [], _ => by simp
  | x :: xs, h => by
    have := len_mul_le_sum a xs (fun s hs => h s (by simp [hs]))
    have := h x (by simp)
    simp only [List.length_cons, List.sum_cons]; nlinarith

/-- **At most four parts** above the line (Proposition F.1 in the `E6` model). -/
theorem parts_le_four (C : Config) (habove : pairs C.n < 25 * C.safe) :
    C.parts.length ≤ 4 := by
  have h := len_mul_le_sum (C.n + 3) C.sizes (fun s hs => by
    simp only [Config.sizes, List.mem_map] at hs
    obtain ⟨x, hx, rfl⟩ := hs
    exact part_share C hx habove)
  have hl : C.sizes.length = C.parts.length := by simp [Config.sizes]
  have hn : C.sizes.sum = C.n := rfl
  rw [hl, hn] at h
  by_contra h5
  have : 5 * (C.n + 3) ≤ C.parts.length * (C.n + 3) := Nat.mul_le_mul_right _ (by omega)
  omega

/-! ## Efficiency of a foreign part (the S6 / S11 clause) -/

/-- **A foreign part of share below 1/2 is efficient.** If `fr r t` is a part, 2r < n and
SAFE is above the line, then 2(r − 1) < 25t, i.e. (r − 1)/t < 12.5 — the text's k ≤ 12 when
r − 1 = k·t.  Uses only orb(r, t) ≤ r·t, so it holds with or without the halving. -/
theorem foreign_efficient (C : Config) {r t : ℕ} (hx : CPart.fr r t ∈ C.parts)
    (hhalf : 2 * r < C.n) (habove : pairs C.n < 25 * C.safe) : 2 * (r - 1) < 25 * t := by
  have h1 : C.safe ≤ orb r t false :=
    minL_le (List.mem_append_left _ (List.mem_flatMap.mpr ⟨_, hx, by simp [CPart.safeTerms]⟩))
  have h2 := E5Core.orb_le_mul r t false
  have h3 : pairs (2 * r + 1) ≤ pairs C.n := pairs_mono (by omega)
  have h4 := two_pairs (2 * r + 1)
  have h5 : (2 * r + 1) * (2 * r + 1 - 1) = (2 * r + 1) * (2 * r) := by congr 1
  rw [h5] at h4
  rcases Nat.eq_zero_or_pos r with h0 | hr
  · subst h0; simp at h2; omega
  by_contra hc
  have : r * (2 * r + 1) < 25 * (r * t) := by
    have : 2 * pairs (2 * r + 1) < 2 * (25 * (r * t)) := by omega
    nlinarith
  have : 2 * r + 1 < 25 * t := by
    by_contra h'; have : r * (25 * t) ≤ r * (2 * r + 1) := Nat.mul_le_mul_left _ (by omega)
    nlinarith
  omega

/-! ## Two matching classes merge (no S12) -/

/-- The merged class's within-class cross term dominates F₂·C(c,2). -/
theorem within_ge (F F2 c : ℕ) (hF : F2 + 1 ≤ F) :
    F2 * pairs c ≤ (if F % 2 = 1 then F else F / 2) * c * c := by
  have h1 := two_pairs c
  have hw : F2 ≤ 2 * (if F % 2 = 1 then F else F / 2) := by split <;> omega
  have : 2 * (F2 * pairs c) ≤ 2 * ((if F % 2 = 1 then F else F / 2) * c * c) := by
    calc 2 * (F2 * pairs c) = F2 * (c * (c - 1)) := by rw [← h1]; ring
      _ ≤ F2 * (c * c) := Nat.mul_le_mul_left _ (Nat.mul_le_mul_left _ (Nat.sub_le _ _))
      _ ≤ 2 * (if F % 2 = 1 then F else F / 2) * (c * c) := Nat.mul_le_mul_right _ hw
      _ = _ := by ring
  omega

/-- **Proposition 1's S12 clause, in the model.** Two classes `pc F₁ (m·c)` and `pc F₂ c`
(block sizes p^a and p^b with m = p^(a−b)) are replaced by one class of F₁·m + F₂ blocks of
size c with full twist.  n is unchanged and SAFE does not drop: the new intra term is at least
F₂·C(c,2), the new within-class cross term is at least F₂·C(c,2) (`within_ge`), and each new
cross term (s₁ + s₂)·s dominates the old s₁·s.  (The model's F is permissive, so admissibility
of the merged class is not at issue here; the text's check that no foreign prime divides F is
about the true shape space.) -/
theorem merge_classes (C : Config) {F1 F2 m c d1 d2 : ℕ} {rest : List CPart}
    (hparts : C.parts = .pc F1 (m * c) d1 :: .pc F2 c d2 :: rest) (hF1 : 1 ≤ F1) (hm : 1 ≤ m) :
    let C' : Config := ⟨C.p, C.q, .pc (F1 * m + F2) c (c - 1) :: rest⟩
    C'.n = C.n ∧ C.safe ≤ C'.safe := by
  intro C'
  have hs : (F1 * m + F2) * c = F1 * (m * c) + F2 * c := by ring
  refine ⟨?_, ?_⟩
  · simp only [Config.n, Config.sizes, C', hparts, List.map_cons, List.sum_cons, CPart.sizeC, hs]
    omega
  have mem : ∀ y, y ∈ C.parts.flatMap CPart.safeTerms ++ crossN C.sizes → C.safe ≤ y :=
    fun y hy => minL_le hy
  unfold Config.safe
  apply le_minL
  · intro y hy
    simp only [C', Config.sizes, List.map_cons, CPart.sizeC, List.flatMap_cons,
      List.mem_append, crossN] at hy
    rcases hy with (hy | hy) | hy
    · simp only [CPart.safeTerms, Part.terms, List.mem_cons] at hy
      have hF2 : C.safe ≤ F2 * pairs c := mem _ (by rw [hparts]; simp [CPart.safeTerms, Part.terms])
      rcases hy with rfl | hy
      · exact le_trans hF2 (Nat.mul_le_mul_right _ (by nlinarith))
      · have hFm : 1 ≤ F1 * m := Nat.one_le_iff_ne_zero.mpr (by positivity)
        by_cases h2 : 2 ≤ F1 * m + F2
        · simp only [h2, ite_true, List.mem_cons, List.not_mem_nil, or_false] at hy
          rw [hy]; exact le_trans hF2 (within_ge _ F2 c (by omega))
        · simp [h2] at hy
    · exact mem _ (by rw [hparts]; simp [hy])
    · rcases hy with hy | hy
      · rw [List.mem_map] at hy
        obtain ⟨z, hz, rfl⟩ := hy
        have : C.safe ≤ F1 * (m * c) * z := mem _ (by
          apply List.mem_append_right
          simp only [Config.sizes, hparts, List.map_cons, CPart.sizeC, crossN]
          apply List.mem_append_left
          exact List.mem_cons_of_mem _ (List.mem_map.mpr ⟨z, hz, rfl⟩))
        exact le_trans this (Nat.mul_le_mul_right _ (by rw [hs]; omega))
      · exact mem _ (by
          apply List.mem_append_right
          simp only [Config.sizes, hparts, List.map_cons, CPart.sizeC, crossN]
          exact List.mem_append_right _ (List.mem_append_right _ hy))
  · intro h
    have : (F1 * m + F2) * pairs c ∈ (C'.parts.flatMap CPart.safeTerms ++ crossN C'.sizes) := by
      simp [C', CPart.safeTerms, Part.terms]
    rw [h] at this; simp at this

/-! ## Three foreign primes: the efficiency reduction -/

/-- Above the line, a foreign part bounds n: n(n − 1) < 50·r·t. -/
theorem foreign_key (C : Config) {r t : ℕ} (hx : CPart.fr r t ∈ C.parts)
    (habove : pairs C.n < 25 * C.safe) : C.n * (C.n - 1) < 50 * (r * t) := by
  have h1 : C.safe ≤ orb r t false :=
    minL_le (List.mem_append_left _ (List.mem_flatMap.mpr ⟨_, hx, by simp [CPart.safeTerms]⟩))
  have h2 := E5Core.orb_le_mul r t false
  have h3 := two_pairs C.n
  omega

/-- **Proposition 1, three foreign primes — the efficiency reduction.** Three foreign parts
r₁ ≤ r₂ ≤ r₃ (any order in the list, any further parts) above the line satisfy
9r₁ < 50t₁ + 3, 2r₂ < 25t₂ + 1 and r₃ < 18t₃.  With rⱼ − 1 = kⱼ·tⱼ that is
k₁ ≤ 5, k₂ ≤ 12, k₃ ≤ 17: the smallest part has share ≤ 1/3, the middle ≤ 1/2, and the
largest < 3/5 (the other two have share > 1/5 each).  Uses orb(r, t) ≤ r·t only.

This is a reduction, not the exclusion: the text then rules the remaining (k, q, exponent)
patterns out by enumeration for q ≤ 31 and a ratio argument for q ≥ 37, neither formalised. -/
theorem three_foreign (C : Config) {r1 t1 r2 t2 r3 t3 : ℕ} {rest : List CPart}
    (hparts : C.parts.Perm (.fr r1 t1 :: .fr r2 t2 :: .fr r3 t3 :: rest))
    (h12 : r1 ≤ r2) (h23 : r2 ≤ r3) (habove : pairs C.n < 25 * C.safe) :
    9 * r1 < 50 * t1 + 3 ∧ 2 * r2 < 25 * t2 + 1 ∧ r3 < 18 * t3 := by
  have mem : ∀ x, x ∈ (CPart.fr r1 t1 :: .fr r2 t2 :: .fr r3 t3 :: rest) → x ∈ C.parts :=
    fun x hx => hparts.mem_iff.mpr hx
  have k1 := foreign_key C (mem (.fr r1 t1) (by simp)) habove
  have k2 := foreign_key C (mem (.fr r2 t2) (by simp)) habove
  have k3 := foreign_key C (mem (.fr r3 t3) (by simp)) habove
  have s1 := part_share C (mem (.fr r1 t1) (by simp)) habove
  have s2 := part_share C (mem (.fr r2 t2) (by simp)) habove
  have hn : r1 + r2 + r3 ≤ C.n := by
    have : C.n = ((CPart.fr r1 t1 :: .fr r2 t2 :: .fr r3 t3 :: rest).map CPart.sizeC).sum := by
      simp only [Config.n, Config.sizes]; exact (hparts.map _).sum_eq
    rw [this]; simp only [List.map_cons, List.sum_cons, CPart.sizeC]; omega
  simp only [CPart.sizeC] at s1 s2
  obtain ⟨N, hN⟩ : ∃ N, C.n = N + 1 := ⟨C.n - 1, by omega⟩
  rw [hN, Nat.add_sub_cancel] at k1 k2 k3
  have hr1 : 1 ≤ r1 := by omega
  refine ⟨?_, ?_, ?_⟩
  · -- 3r₁ ≤ n
    by_contra h
    have : 3 * r1 ≤ N + 1 := by omega
    have : 3 * r1 * (3 * r1 - 1) ≤ (N + 1) * N := by
      have : 3 * r1 - 1 ≤ N := by omega
      exact Nat.mul_le_mul (by omega) this
    have : r1 * (50 * t1) ≤ r1 * (9 * r1 - 3) := Nat.mul_le_mul_left _ (by omega)
    have e : 3 * r1 * (3 * r1 - 1) = r1 * (9 * r1 - 3) := by
      rw [Nat.mul_sub, Nat.mul_sub]; ring_nf
    nlinarith
  · -- 2r₂ ≤ n
    by_contra h
    have : 2 * r2 * (2 * r2 - 1) ≤ (N + 1) * N := by
      have : 2 * r2 - 1 ≤ N := by omega
      exact Nat.mul_le_mul (by omega) this
    have : r2 * (50 * t2) ≤ r2 * (4 * r2 - 2) := Nat.mul_le_mul_left _ (by omega)
    have e : 2 * r2 * (2 * r2 - 1) = r2 * (4 * r2 - 2) := by
      rw [Nat.mul_sub, Nat.mul_sub]; ring_nf
    nlinarith
  · -- 3n ≥ 5r₃ + 6
    by_contra h
    have h3n : 5 * r3 + 6 ≤ 3 * (N + 1) := by omega
    have : (5 * r3 + 6) * (5 * r3 + 3) ≤ 3 * (N + 1) * (3 * N) := Nat.mul_le_mul h3n (by omega)
    have : 25 * r3 * r3 ≤ r3 * (450 * t3) := by nlinarith
    nlinarith

end Prop1

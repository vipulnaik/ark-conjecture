/-
# `Prop1Final.lean` — Proposition 1 assembled, in the `E6` model

`ladder-completeness.md` Proposition 1: above C(n,2)/25 the optimum is a menu shape or S6/S11.
`prop1` states it on the `E6` model: every admissible configuration with no D2 part and SAFE
above the line is matched (same n, SAFE no lower, still admissible) by one with **at most one
class and at most two foreign parts**, hence at most three parts, and with fusion count
**F ≤ 15** whenever the class has company.  The shapes left are S2, S3/S4/S5/S7 (class plus
one foreign part), S6, S11, and a lone foreign part.

* `merge_step` / `merge_all` — two classes merge (`Prop1.merge_classes`), the larger block
  first; repeated until one class is left (no S12).
* `fr_le_two` — a third foreign part is excluded (`ThreeForeign.no_three_foreign`), after
  sorting the three distinct primes.
* `safe_perm`, `gadm_perm` — SAFE and admissibility do not depend on the order of parts.

The other clauses of the proposition are separate theorems that apply to the matched
configuration: shares > 1/5 (`Prop1.part_share`), the efficiency of a foreign part of share
below 1/2 (`Prop1.foreign_efficient`), and fallback-freeness (E.5, via `E6.e6_core`).  D2 parts
are excluded by hypothesis; their domination above the line is `E6.d2_case`.
-/
import ThreeForeign

namespace Prop1Final
open E6 ArkCore E5Assembly

def isPc : CPart → Bool
  | .pc _ _ _ => true
  | _ => false

def isFr : CPart → Bool
  | .fr _ _ => true
  | _ => false

/-- SAFE is invariant under reordering the parts (no D2 part). -/
theorem safe_perm {C C' : Config} (hfo : C.FoFree) (hfo' : C'.FoFree)
    (hp : C.parts.Perm C'.parts) : C.safe = C'.safe := by
  rw [(safe_pl C hfo).1, (safe_pl C' hfo').1]
  exact minL_perm (termsL_perm (hp.map _))

theorem n_perm {C C' : Config} (hp : C.parts.Perm C'.parts) : C.n = C'.n := by
  simp only [Config.n, Config.sizes]; exact (hp.map _).sum_eq

theorem foFree_perm {C C' : Config} (hfo : C.FoFree) (hp : C.parts.Perm C'.parts) :
    C'.FoFree := fun F r t h => hfo F r t (hp.mem_iff.mpr h)

theorem gadm_perm {C C' : Config} (hC : GAdm C) (hpq : C'.p = C.p ∧ C'.q = C.q)
    (hp : C.parts.Perm C'.parts) : GAdm C' := by
  obtain ⟨h1, h2, h3, h4⟩ := hC
  obtain ⟨ep, eq⟩ := hpq
  refine ⟨ep ▸ h1, eq ▸ h2, fun x hx => ?_, ?_⟩
  · have := h3 x (hp.mem_iff.mpr hx)
    cases x <;> simp only [partAdm, ep, eq] at this ⊢ <;> exact this
  · exact (foreign_perm hp).nodup_iff.mp h4

/-- Split off the first two parts satisfying `P`. -/
theorem two_of_filter {l : List CPart} {P : CPart → Bool} (h : 2 ≤ (l.filter P).length) :
    ∃ x y rest, P x ∧ P y ∧ l.Perm (x :: y :: rest) := by
  have hp := (List.filter_append_perm P l).symm
  obtain ⟨x, y, zs, hz⟩ : ∃ x y zs, l.filter P = x :: y :: zs := by
    match hl : l.filter P, h with
    | x :: y :: zs, _ => exact ⟨x, y, zs, rfl⟩
  have hx : x ∈ l.filter P := by rw [hz]; simp
  have hy : y ∈ l.filter P := by rw [hz]; simp
  rw [hz] at hp
  exact ⟨x, y, zs ++ l.filter (fun a => !P a), (List.mem_filter.mp hx).2,
    (List.mem_filter.mp hy).2, hp⟩

theorem three_of_filter {l : List CPart} {P : CPart → Bool} (h : 3 ≤ (l.filter P).length) :
    ∃ x y z rest, P x ∧ P y ∧ P z ∧ l.Perm (x :: y :: z :: rest) := by
  have hp := (List.filter_append_perm P l).symm
  obtain ⟨x, y, z, zs, hz⟩ : ∃ x y z zs, l.filter P = x :: y :: z :: zs := by
    match hl : l.filter P, h with
    | x :: y :: z :: zs, _ => exact ⟨x, y, z, zs, rfl⟩
  have m : ∀ w, w ∈ l.filter P → P w := fun w hw => (List.mem_filter.mp hw).2
  rw [hz] at hp m
  exact ⟨x, y, z, zs ++ l.filter (fun a => !P a), m x (by simp), m y (by simp), m z (by simp), hp⟩

/-- **The merge step.** Two classes merge: one fewer class, n kept, SAFE not lowered. -/
theorem merge_step (C : Config) (hC : GAdm C) (hfo : C.FoFree)
    (h2 : 2 ≤ (C.parts.filter isPc).length) :
    ∃ C' : Config, GAdm C' ∧ C'.FoFree ∧ C'.n = C.n ∧ C.safe ≤ C'.safe ∧
      C'.parts.length + 1 = C.parts.length ∧
      (C'.parts.filter isPc).length + 1 = (C.parts.filter isPc).length ∧
      (C'.parts.filter isFr).length = (C.parts.filter isFr).length := by
  obtain ⟨x, y, rest, hx, hy, hp⟩ := two_of_filter h2
  cases x with
  | fr _ _ => simp [isPc] at hx
  | fo _ _ _ => simp [isPc] at hx
  | pc F1 c1 d1 =>
  cases y with
  | fr _ _ => simp [isPc] at hy
  | fo _ _ _ => simp [isPc] at hy
  | pc F2 c2 d2 =>
  obtain ⟨hpp, hqq, hall, hnd⟩ := hC
  have a1 := hall (.pc F1 c1 d1) (hp.mem_iff.mpr (by simp))
  have a2 := hall (.pc F2 c2 d2) (hp.mem_iff.mpr (by simp))
  obtain ⟨hF1, ⟨b1, hb1, rfl⟩, -⟩ := a1
  obtain ⟨hF2, ⟨b2, hb2, rfl⟩, -⟩ := a2
  -- order the two so the larger block comes first
  have key : ∀ (G1 G2 e1 e2 : ℕ) (f1 f2 : ℕ), 1 ≤ G1 → 1 ≤ G2 → e2 ≤ e1 → 1 ≤ e2 →
      C.parts.Perm (.pc G1 (C.p ^ e1) f1 :: .pc G2 (C.p ^ e2) f2 :: rest) →
      ∃ C' : Config, GAdm C' ∧ C'.FoFree ∧ C'.n = C.n ∧ C.safe ≤ C'.safe ∧
        C'.parts.length + 1 = C.parts.length ∧
        (C'.parts.filter isPc).length + 1 = (C.parts.filter isPc).length ∧
        (C'.parts.filter isFr).length = (C.parts.filter isFr).length := by
    intro G1 G2 e1 e2 f1 f2 hG1 hG2 he he2 hperm
    let C0 : Config := ⟨C.p, C.q, .pc G1 (C.p ^ (e1 - e2) * C.p ^ e2) f1 :: .pc G2 (C.p ^ e2) f2 :: rest⟩
    have hpow : C.p ^ (e1 - e2) * C.p ^ e2 = C.p ^ e1 := by rw [← pow_add]; congr 1; omega
    have hp0 : C.parts.Perm C0.parts := by simp only [C0, hpow]; exact hperm
    have hfo0 := foFree_perm hfo hp0
    obtain ⟨hn, hs⟩ := Prop1.merge_classes C0 (F1 := G1) (F2 := G2) (m := C.p ^ (e1 - e2)) (c := C.p ^ e2) (d1 := f1) (d2 := f2) (rest := rest) rfl hG1 (Nat.one_le_pow _ _ hpp.pos)
    refine ⟨⟨C.p, C.q, .pc (G1 * C.p ^ (e1 - e2) + G2) (C.p ^ e2) (C.p ^ e2 - 1) :: rest⟩, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
    · refine ⟨hpp, hqq, fun z hz => ?_, ?_⟩
      · simp only [List.mem_cons] at hz
        rcases hz with rfl | hz
        · exact ⟨by omega, ⟨e2, he2, rfl⟩, dvd_refl _⟩
        · exact hall z (hperm.mem_iff.mpr (by simp [hz]))
      · have := (foreign_perm hperm).nodup_iff.mp hnd
        simpa [Config.foreign] using this
    · intro F r t h
      simp only [List.mem_cons, reduceCtorEq, false_or] at h
      exact hfo0 F r t (by simp [C0, h])
    · rw [hn, ← n_perm hp0]
    · rw [safe_perm hfo hfo0 hp0]; exact hs
    · simp [hperm.length_eq]
    · rw [(hperm.filter _).length_eq]; simp only [List.filter_cons, isPc, ite_true, List.length_cons]
    · rw [(hperm.filter _).length_eq]; simp [isFr]
  rcases le_total b2 b1 with h | h
  · exact key F1 F2 b1 b2 d1 d2 hF1 hF2 h hb2 hp
  · exact key F2 F1 b2 b1 d2 d1 hF2 hF1 h hb1 (hp.trans (List.Perm.swap _ _ _))

/-- Merge repeatedly: at most one class. -/
theorem merge_all : ∀ (k : ℕ) (C : Config), (C.parts.filter isPc).length = k → GAdm C → C.FoFree →
    ∃ C' : Config, GAdm C' ∧ C'.FoFree ∧ C'.n = C.n ∧ C.safe ≤ C'.safe ∧
      (C'.parts.filter isPc).length ≤ 1 ∧
      (C'.parts.filter isFr).length = (C.parts.filter isFr).length := by
  intro k
  induction k using Nat.strong_induction_on with
  | _ k ih =>
    intro C hk hC hfo
    by_cases h : 2 ≤ k
    · obtain ⟨C1, g1, f1, n1, s1, -, c1, r1⟩ := merge_step C hC hfo (by omega)
      obtain ⟨C2, g2, f2, n2, s2, c2, r2⟩ := ih _ (by omega) C1 rfl g1 f1
      exact ⟨C2, g2, f2, n2.trans n1, s1.trans s2, c2, r2.trans r1⟩
    · exact ⟨C, hC, hfo, rfl, le_refl _, by omega, rfl⟩

theorem perm12 {l : List CPart} {x y z : CPart} {r : List CPart}
    (h : l.Perm (x :: y :: z :: r)) : l.Perm (y :: x :: z :: r) := h.trans (List.Perm.swap _ _ _)

theorem perm23 {l : List CPart} {x y z : CPart} {r : List CPart}
    (h : l.Perm (x :: y :: z :: r)) : l.Perm (x :: z :: y :: r) :=
  h.trans (List.Perm.cons _ (List.Perm.swap _ _ _))

/-- **At most two foreign parts** above the line. -/
theorem fr_le_two (C : Config) (hC : GAdm C)
    (habove : pairs C.n < 25 * C.safe) : (C.parts.filter isFr).length ≤ 2 := by
  by_contra h3
  obtain ⟨x, y, z, rest, hx, hy, hz, hp⟩ := three_of_filter (P := isFr) (l := C.parts) (by omega)
  cases x with
  | pc _ _ _ => simp [isFr] at hx
  | fo _ _ _ => simp [isFr] at hx
  | fr r1 t1 =>
  cases y with
  | pc _ _ _ => simp [isFr] at hy
  | fo _ _ _ => simp [isFr] at hy
  | fr r2 t2 =>
  cases z with
  | pc _ _ _ => simp [isFr] at hz
  | fo _ _ _ => simp [isFr] at hz
  | fr r3 t3 =>
  have hnd := (foreign_perm hp).nodup_iff.mp hC.2.2.2
  simp only [List.filterMap_cons, List.nodup_cons, List.mem_cons, not_or] at hnd
  obtain ⟨⟨n12, n13, -⟩, ⟨n23, -⟩, -⟩ := hnd
  have go := fun {a ta b tb c tc : ℕ} (hp' : C.parts.Perm (.fr a ta :: .fr b tb :: .fr c tc :: rest))
    (h1 : a < b) (h2 : b < c) => ThreeForeign.no_three_foreign C hC hp' h1 h2 habove
  rcases Nat.lt_or_gt_of_ne n12 with h12 | h12 <;>
  rcases Nat.lt_or_gt_of_ne n13 with h13 | h13 <;>
  rcases Nat.lt_or_gt_of_ne n23 with h23 | h23
  · exact go hp h12 h23
  · exact go (perm23 hp) h13 h23
  · omega
  · exact go (perm12 (perm23 hp)) h13 h12
  · exact go (perm12 hp) h12 h13
  · omega
  · exact go (perm23 (perm12 hp)) h23 h13
  · exact go (perm12 (perm23 (perm12 hp))) h23 h12

theorem length_split (l : List CPart) (h : ∀ F r t, CPart.fo F r t ∉ l) :
    l.length = (l.filter isPc).length + (l.filter isFr).length := by
  induction l with
  | nil => rfl
  | cons x xs ih =>
    have ih := ih (fun F r t hm => h F r t (by simp [hm]))
    cases x with
    | pc _ _ _ => simp only [List.filter_cons, isPc, isFr, ite_true, Bool.false_eq_true, ite_false, List.length_cons]; omega
    | fr _ _ => simp only [List.filter_cons, isPc, isFr, ite_true, Bool.false_eq_true, ite_false, List.length_cons]; omega
    | fo F r t => exact absurd (by simp) (h F r t)

/-- **Proposition 1, in the `E6` model.** Every admissible configuration with no D2 part and
SAFE above C(n,2)/25 is matched (same n, SAFE no lower) by an admissible one with **at most one
class and at most two foreign parts** — so at most three parts: a class alone (S2), a class
with one foreign part (S3/S4/S5/S7), two foreign parts (S6), a class with two (S11), or one
foreign part — **and fusion count F ≤ 15** whenever the class has company. -/
theorem prop1 (C : Config) (hC : GAdm C) (hfo : C.FoFree) (habove : pairs C.n < 25 * C.safe) :
    ∃ C' : Config, GAdm C' ∧ C'.FoFree ∧ C'.n = C.n ∧ C.safe ≤ C'.safe ∧
      (C'.parts.filter isPc).length ≤ 1 ∧ (C'.parts.filter isFr).length ≤ 2 ∧
      C'.parts.length ≤ 3 ∧
      ∀ F c d, CPart.pc F c d ∈ C'.parts → 2 ≤ C'.parts.length → F ≤ 15 := by
  obtain ⟨C', g, f, hn, hs, hc, hr⟩ := merge_all _ C rfl hC hfo
  have above' : pairs C'.n < 25 * C'.safe := by rw [hn]; omega
  have hr2 : (C'.parts.filter isFr).length ≤ 2 := fr_le_two C' g above'
  refine ⟨C', g, f, hn, hs, hc, hr2, ?_, ?_⟩
  · rw [length_split _ f]; omega
  · intro F c d hx hlen
    have hp := List.perm_cons_erase hx
    match he : C'.parts.erase (.pc F c d), hlen with
    | [], _ =>
      have := hp.length_eq; rw [he] at this; simp at this; omega
    | y :: ys, _ =>
      rw [he] at hp
      exact Prop1.fusion_cap C' hp above'

end Prop1Final

/-
# `CycGood.lean` — good indices: Euler characteristics of C_k-invariant complexes
-/
import Mathlib

set_option linter.unusedSectionVars false

namespace CycGood
open Finset

variable {k : ℕ} [NeZero k]

/-- Shift a subset of ℤ/k by j. -/
def sh (j : ZMod k) (S : Finset (ZMod k)) : Finset (ZMod k) := S.image (· + j)

/-- The Euler characteristic of a family of (nonempty) faces. -/
def chi (𝓕 : Finset (Finset (ZMod k))) : ℤ := ∑ S ∈ 𝓕, (-1 : ℤ) ^ (S.card + 1)

/-- A C_k-invariant complex on ℤ/k: nonempty faces, closed under nonempty subsets and shifts,
not the full simplex. -/
structure InvCx (𝓕 : Finset (Finset (ZMod k))) : Prop where
  ne : ∀ S ∈ 𝓕, S.Nonempty
  down : ∀ S ∈ 𝓕, ∀ T ⊆ S, T.Nonempty → T ∈ 𝓕
  inv : ∀ S ∈ 𝓕, sh 1 S ∈ 𝓕
  proper : (univ : Finset (ZMod k)) ∉ 𝓕

/-- k is **good** for q: no invariant proper complex has χ ≡ 1 (mod q). -/
def Good (k : ℕ) [NeZero k] (q : ℕ) : Prop :=
  ∀ 𝓕 : Finset (Finset (ZMod k)), InvCx 𝓕 → ¬ (chi 𝓕 ≡ 1 [ZMOD q])

theorem sh_sh (a b : ZMod k) (S : Finset (ZMod k)) : sh a (sh b S) = sh (b + a) S := by
  unfold sh; rw [Finset.image_image]; congr 1; funext x; simp [add_assoc]

theorem sh_zero (S : Finset (ZMod k)) : sh 0 S = S := by simp [sh]

theorem InvCx.sh_mem {𝓕 : Finset (Finset (ZMod k))} (h : InvCx 𝓕) {S : Finset (ZMod k)}
    (hS : S ∈ 𝓕) (j : ℕ) : sh (j : ZMod k) S ∈ 𝓕 := by
  induction j with
  | zero => simpa [sh_zero] using hS
  | succ n ih =>
    have := h.inv _ ih
    rw [sh_sh] at this
    simpa [Nat.cast_succ, add_comm] using this

theorem InvCx.sh_mem' {𝓕 : Finset (Finset (ZMod k))} (h : InvCx 𝓕) {S : Finset (ZMod k)}
    (hS : S ∈ 𝓕) (j : ZMod k) : sh j S ∈ 𝓕 := by
  have := h.sh_mem hS j.val
  rwa [ZMod.natCast_zmod_val] at this

/-! ## Orbit labels and the finite reduction -/

/-- Bitmask key of a subset. -/
def key (S : Finset (ZMod k)) : ℕ := ∑ x ∈ S, 2 ^ x.val

/-- Orbit label: the least key among the shifts. -/
def lab (S : Finset (ZMod k)) : ℕ := ((List.range k).map (fun j => key (sh (j : ZMod k) S))).foldr min (key S)

/-- The subset with a given key. -/
def rep (l : ℕ) : Finset (ZMod k) := univ.filter (fun x => Nat.testBit l x.val)

/-- Nonempty proper subsets. -/
def P (k : ℕ) [NeZero k] : Finset (Finset (ZMod k)) :=
  (univ : Finset (Finset (ZMod k))).filter (fun S => S.Nonempty ∧ S ≠ univ)

def sgn (S : Finset (ZMod k)) : ℤ := (-1 : ℤ) ^ (S.card + 1)

/-- The data a finite check needs, and the facts tying it to ℤ/k. -/
structure Data (k : ℕ) [NeZero k] where
  labs : Finset ℕ
  R : Finset (ℕ × ℕ)
  c : ℕ → ℤ
  vals : Finset ℤ
  hrep : ∀ S ∈ P k, ∃ j : ZMod k, sh j S = rep (lab S)
  hlabs : ∀ S ∈ P k, lab S ∈ labs
  hR : ∀ ab ∈ R, ∃ S ∈ P k, ∃ T ∈ S.powerset, T.Nonempty ∧ lab T = ab.1 ∧ lab S = ab.2
  hc : ∀ l ∈ labs, c l = ∑ S ∈ (P k).filter (fun S => lab S = l), sgn S
  hcheck : ∀ B ∈ labs.powerset, (∀ ab ∈ R, ab.2 ∈ B → ab.1 ∈ B) → (∑ l ∈ B, c l) ∈ vals

theorem chi_mem (D : Data k) {𝓕 : Finset (Finset (ZMod k))} (h : InvCx 𝓕) : chi 𝓕 ∈ D.vals := by
  have hP : 𝓕 ⊆ P k := fun S hS => by
    simp only [P, mem_filter, mem_univ, true_and]
    exact ⟨h.ne S hS, fun he => h.proper (he ▸ hS)⟩
  -- membership depends only on the label
  have hlab : ∀ S ∈ P k, ∀ T ∈ P k, lab S = lab T → S ∈ 𝓕 → T ∈ 𝓕 := by
    intro S hS T hT hst hSF
    obtain ⟨a, ha⟩ := D.hrep S hS
    obtain ⟨b, hb⟩ := D.hrep T hT
    have : T = sh (a - b) S := by
      have h1 : sh (-b) (sh b T) = T := by rw [sh_sh]; simp [sh_zero]
      rw [← h1, hb, ← hst, ← ha, sh_sh]; ring_nf
    rw [this]; exact h.sh_mem' hSF _
  set B := 𝓕.image lab
  have hB : B ∈ D.labs.powerset := by
    rw [mem_powerset]; intro l hl
    obtain ⟨S, hS, rfl⟩ := mem_image.mp hl
    exact D.hlabs S (hP hS)
  have hdown : ∀ ab ∈ D.R, ab.2 ∈ B → ab.1 ∈ B := by
    intro ab hab h2
    obtain ⟨S, hSP, T, hT, hTne, hT1, hS2⟩ := D.hR ab hab
    obtain ⟨S', hS'F, hS'l⟩ := mem_image.mp h2
    have hSF : S ∈ 𝓕 := hlab S' (hP hS'F) S hSP (by rw [hS'l, hS2]) hS'F
    have hTF : T ∈ 𝓕 := h.down S hSF T (mem_powerset.mp hT) hTne
    rw [← hT1]; exact mem_image_of_mem _ hTF
  have hF : 𝓕 = (P k).filter (fun S => lab S ∈ B) := by
    ext S; constructor
    · intro hS; exact mem_filter.mpr ⟨hP hS, mem_image_of_mem _ hS⟩
    · intro hS
      obtain ⟨hSP, hSB⟩ := mem_filter.mp hS
      obtain ⟨S', hS'F, hS'l⟩ := mem_image.mp hSB
      exact hlab S' (hP hS'F) S hSP hS'l hS'F
  have hsum : chi 𝓕 = ∑ l ∈ B, D.c l := by
    unfold chi
    rw [hF, ← Finset.sum_fiberwise_of_maps_to (g := lab) (t := B)
      (fun S hS => (mem_filter.mp hS).2)]
    apply Finset.sum_congr rfl
    intro l hl
    rw [D.hc l (mem_powerset.mp hB hl)]
    congr 1
    ext S; simp only [mem_filter]
    constructor
    · rintro ⟨⟨h1, _⟩, h3⟩; exact ⟨h1, h3⟩
    · rintro ⟨h1, h3⟩; exact ⟨⟨h1, h3 ▸ hl⟩, h3⟩
  rw [hsum]; exact D.hcheck B hB hdown


/-- Data for k = 1. -/
def data1 : Data 1 where
  labs := ∅
  R := ∅
  c := fun l =>  0
  vals := {0}
  hrep := by decide
  hlabs := by decide
  hR := by decide
  hc := by decide
  hcheck := by decide


/-- Data for k = 2. -/
def data2 : Data 2 where
  labs := {1}
  R := {(1, 1)}
  c := fun l => if l = 1 then (2 : ℤ) else 0
  vals := {0, 2}
  hrep := by decide
  hlabs := by decide
  hR := by decide
  hc := by decide
  hcheck := by decide


/-- Data for k = 3. -/
def data3 : Data 3 where
  labs := {1, 3}
  R := {(1, 1), (1, 3), (3, 3)}
  c := fun l => if l = 1 then (3 : ℤ) else if l = 3 then (-3 : ℤ) else 0
  vals := {0, 3}
  hrep := by decide
  hlabs := by decide
  hR := by decide
  hc := by decide
  hcheck := by decide


set_option maxRecDepth 100000 in
/-- Data for k = 6. -/
def data6 : Data 6 where
  labs := {1, 3, 5, 7, 9, 11, 13, 15, 21, 23, 27, 31}
  R := {(1, 1), (1, 3), (1, 5), (1, 7), (1, 9), (1, 11), (1, 13), (1, 15), (1, 21), (1, 23), (1, 27), (1, 31), (3, 3), (3, 7), (3, 11), (3, 13), (3, 15), (3, 23), (3, 27), (3, 31), (5, 5), (5, 7), (5, 11), (5, 13), (5, 15), (5, 21), (5, 23), (5, 27), (5, 31), (7, 7), (7, 15), (7, 23), (7, 31), (9, 9), (9, 11), (9, 13), (9, 15), (9, 23), (9, 27), (9, 31), (11, 11), (11, 15), (11, 23), (11, 27), (11, 31), (13, 13), (13, 15), (13, 23), (13, 27), (13, 31), (15, 15), (15, 31), (21, 21), (21, 23), (21, 31), (23, 23), (23, 31), (27, 27), (27, 31), (31, 31)}
  c := fun l => if l = 1 then (6 : ℤ) else if l = 3 then (-6 : ℤ) else if l = 5 then (-6 : ℤ) else if l = 7 then (6 : ℤ) else if l = 9 then (-3 : ℤ) else if l = 11 then (6 : ℤ) else if l = 13 then (6 : ℤ) else if l = 15 then (-6 : ℤ) else if l = 21 then (2 : ℤ) else if l = 23 then (-6 : ℤ) else if l = 27 then (-3 : ℤ) else if l = 31 then (6 : ℤ) else 0
  vals := {-9, -7, -6, -4, -3, -1, 0, 2, 3, 5, 6, 8, 9, 11}
  hrep := by decide +kernel
  hlabs := by decide +kernel
  hR := by decide +kernel
  hc := by decide +kernel
  hcheck := by decide +kernel

/-! ## The goodness statements -/

theorem good_of (D : Data k) {q : ℕ} (hq : ∀ v ∈ D.vals, ¬ ((q : ℤ) ∣ v - 1)) : Good k q := by
  intro 𝓕 h hmod
  exact hq _ (chi_mem D h) ((Int.ModEq.dvd hmod.symm))

theorem dvd_small {q : ℕ} (hq : q.Prime) {m : ℤ} (hm : m ≠ 0) (hb : |m| ≤ 10) (hd : (q : ℤ) ∣ m) :
    q ∈ ({2, 3, 5, 7} : Finset ℕ) := by
  have h1 : (q : ℤ) ≤ |m| := Int.le_of_dvd (abs_pos.mpr hm) ((dvd_abs _ _).mpr hd)
  have h2 : q ≤ 10 := by omega
  have := hq.two_le
  interval_cases q <;> simp_all <;> norm_num at hq

/-- k = 1: the block is one orbital; a proper complex is empty. Good for every q ≥ 2. -/
theorem good1 {q : ℕ} (hq : 2 ≤ q) : Good 1 q := good_of data1 (by
  intro v hv hd
  simp [data1] at hv; subst hv
  have := Int.le_of_dvd (by norm_num) (show (q : ℤ) ∣ 1 by simpa using hd.neg_right)
  omega)

/-- k = 2: χ ∈ {0, 2}. Good for every q ≥ 2. -/
theorem good2 {q : ℕ} (hq : 2 ≤ q) : Good 2 q := good_of data2 (by
  intro v hv hd
  simp [data2] at hv
  rcases hv with rfl | rfl
  · have := Int.le_of_dvd (by norm_num) (show (q : ℤ) ∣ 1 by simpa using hd.neg_right); omega
  · have := Int.le_of_dvd (by norm_num) (show (q : ℤ) ∣ 1 by simpa using hd); omega)

/-- k = 3: χ ∈ {0, 3}. Good for every prime q ≠ 2. -/
theorem good3 {q : ℕ} (hq : q.Prime) (hq2 : q ≠ 2) : Good 3 q := good_of data3 (by
  intro v hv hd
  simp [data3] at hv
  rcases hv with rfl | rfl
  · have := Int.le_of_dvd (by norm_num) (show (q : ℤ) ∣ 1 by simpa using hd.neg_right)
    have := hq.two_le; omega
  · have h2 : (q : ℤ) ∣ 2 := by simpa using hd
    have := Int.le_of_dvd (by norm_num) h2
    have := hq.two_le
    omega)

/-- k = 6: χ ∈ {−9, …, 11} \ {1, 4, 7, 10, −2, −5, −8} (the values the enumeration attains).
Good for every prime q ∉ {2, 5, 7}. -/
theorem good6 {q : ℕ} (hq : q.Prime) (h2 : q ≠ 2) (h5 : q ≠ 5) (h7 : q ≠ 7) : Good 6 q :=
  good_of data6 (by
    intro v hv hd
    have hmem : v - 1 ∈ ({-10, -8, -7, -5, -4, -2, -1, 1, 2, 4, 5, 7, 8, 10} : Finset ℤ) := by
      simp only [data6, Finset.mem_insert, Finset.mem_singleton] at hv
      rcases hv with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> decide
    have hne : v - 1 ≠ 0 := by intro h; rw [h] at hmem; simp at hmem
    have hb : |v - 1| ≤ 10 := by
      revert hmem; generalize v - 1 = m; intro hmem
      simp only [Finset.mem_insert, Finset.mem_singleton] at hmem
      rcases hmem with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
        norm_num
    have := dvd_small hq hne hb hd
    simp only [Finset.mem_insert, Finset.mem_singleton] at this
    rcases this with rfl | rfl | rfl | rfl
    · exact h2 rfl
    · revert hd hmem; generalize v - 1 = m; intro hmem hd
      simp only [Finset.mem_insert, Finset.mem_singleton] at hmem
      rcases hmem with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
        norm_num at hd
    · exact h5 rfl
    · exact h7 rfl)

end CycGood

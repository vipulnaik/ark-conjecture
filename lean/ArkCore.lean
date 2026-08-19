/-
# `ArkCore.lean` — the Mathlib-free arithmetic core, compiled and proved

The subset of `Note.lean` + `Basic.lean` that needs nothing beyond core Lean 4
(compiled with 4.15.0), with **every proof complete — no sorry**.  It exists
because Mathlib is unreachable in the working container while a bare toolchain
is obtainable (see the README's toolchain note), and the split is principled:
real-number material (`Density`, `capF`, the surd table) stays in `Note.lean` /
`Basic.lean` as Mathlib sketches; everything genuinely about ℕ — the central
inequality, Lemma D1, the capacity bound, `orb`, the admissible-`d` tables —
lives here, proved.

`Nat.choose` and `Nat.sqrt` are not in core Lean, so the binomial is
`pairs n = n*(n-1)/2` (bridge to Mathlib: `Nat.choose_two_right`), and
Proposition F.1 is stated in squared form.

**Portability note.** `List.mem_cons_self`'s arguments are explicit in core
4.15.0 and implicit under the laptop's toolchain, so naming it with arguments
compiles in one environment and fails in the other.  Those sites now discharge
the membership with `simp`, which is stable across both.  The general rule for
this file: prefer a tactic to a named library lemma wherever the goal is
trivial, since the named form is what carries the version dependence.

**The compiler earned its keep on first contact**: the draft split the central
inequality's block case at `r ≥ 13`, and the slack chain fails there —
`r² − 7r − 84 < 0` at 13 — so the split is at 14, the finite side `n ≤ 65`
going to `decide`.  That the region's numerical worst (`350·m*/pairs n =
1.0096`, at `n = 65`, `r = 13`) sits on the finite side is exactly why no
uniform slack argument covers it.
-/

namespace ArkCore

/-! ## 1. `pairs`, and the doubling identity -/

/-- `n.choose 2`, without Mathlib. -/
def pairs (n : Nat) : Nat := n * (n - 1) / 2

/-- `n*(n-1)` is even, so `pairs` doubles exactly. -/
theorem two_pairs (n : Nat) : 2 * pairs n = n * (n - 1) := by
  unfold pairs
  have he : n * (n - 1) % 2 = 0 := by
    have hm := Nat.mul_mod n (n - 1) 2
    have h2 : n % 2 = 0 ∨ n % 2 = 1 := by omega
    rcases h2 with h | h
    · rw [hm, h]; simp
    · have h1 : (n - 1) % 2 = 0 := by omega
      rw [hm, h1]; simp
  omega

theorem pairs_mono {a b : Nat} (h : a ≤ b) : pairs a ≤ pairs b := by
  have := Nat.mul_le_mul h (Nat.sub_le_sub_right h 1)
  unfold pairs; omega

/-! ## 2. `orb` — the block primitive, and the full-twist collapse -/

/-- `Basic.lean`'s definition, on `pairs`.  The halving condition is
`char2 ∨ 2 ∣ t` — the `-1 ∈ T` collapse. -/
def orb (c t : Nat) (char2 : Bool) : Nat :=
  min (if char2 = true ∨ t % 2 = 0 then c * t / 2 else c * t) (pairs c)

theorem orb_le_pairs (c t : Nat) (b : Bool) : orb c t b ≤ pairs c :=
  Nat.min_le_right _ _

/-- **A full twist is 2-homogeneous** (`Basic.lean`'s first sorry, proved).
If the halving applies, `c*(c-1)/2` *is* `pairs c`; if not, the unhalved
product dominates and the cap binds.  No hypothesis on `c`: at `c ≤ 1`
everything is 0. -/
theorem orb_full (c : Nat) (b : Bool) : orb c (c - 1) b = pairs c := by
  unfold orb pairs
  by_cases h : b = true ∨ (c - 1) % 2 = 0
  · rw [if_pos h]; exact Nat.min_self _
  · rw [if_neg h]; exact Nat.min_eq_right (Nat.div_le_self _ _)

/-! ## 3. Lemma D1 and the capacity bound (`Basic.lean` §§2–3, proved) -/

/-- **Lemma D1: fusing costs more than it gains.** -/
theorem lemma_D1 (F c : Nat) (hF : 2 ≤ F) (hc : 2 ≤ c) :
    2 * (F * pairs c) < 2 * pairs (F * c) := by
  have h1 : 2 * (F * pairs c) = F * (2 * pairs c) := by
    rw [Nat.mul_comm 2 (F * pairs c), Nat.mul_assoc, Nat.mul_comm (pairs c) 2]
  rw [h1, two_pairs, two_pairs]
  have hpos : 0 < F * c := Nat.mul_pos (by omega) (by omega)
  have h2c : 2 * c ≤ F * c := Nat.mul_le_mul_right c hF
  have key : c - 1 < F * c - 1 := by omega
  calc F * (c * (c - 1)) = F * c * (c - 1) := by rw [Nat.mul_assoc]
    _ < F * c * (F * c - 1) := (Nat.mul_lt_mul_left hpos).mpr key

/-- **The capacity bound**, with the `0 < m` hypothesis whose omission
`Basic.lean` records as the degenerate case the prose forgot. -/
theorem size_of_capacity (s m : Nat) (hm : 0 < m) (h : m ≤ pairs s) :
    2 * m < s * s := by
  have h2 : 2 * m ≤ s * (s - 1) := by
    have h3 := Nat.mul_le_mul_left 2 h
    rw [two_pairs] at h3; exact h3
  have hs : 1 ≤ s := by
    rcases Nat.eq_zero_or_pos s with h0 | h0
    · subst h0; simp [pairs] at h; omega
    · exact h0
  have hlt : s * (s - 1) < s * s := (Nat.mul_lt_mul_left (by omega)).mpr (by omega)
  omega

/-! ## 4. Proposition F.1 (`Basic.lean` §3), squared form

`k` parts of capacity ≥ `m` summing to `n` give `2m·k² < n²` — the integer
content of `k < 1/√δ` and the source of the threshold ladder.  Route: the
list has a minimal element; it bounds every part uniformly, so `n ≥ k·t`
with `t² > 2m`. -/

/-- A nonempty list has a member that bounds it below. -/
theorem exists_min_member (parts : List Nat) (hne : parts ≠ []) :
    ∃ t ∈ parts, ∀ s ∈ parts, t ≤ s := by
  induction parts with
  | nil => exact absurd rfl hne
  | cons a rest ih =>
    rcases rest with _ | ⟨b, rest'⟩
    · exact ⟨a, by simp, by intro s hs; simp at hs; omega⟩
    · obtain ⟨t, htmem, htle⟩ := ih (by simp)
      by_cases hat : a ≤ t
      · refine ⟨a, by simp, ?_⟩
        intro s hs
        rcases List.mem_cons.mp hs with h | h
        · omega
        · exact Nat.le_trans hat (htle s h)
      · refine ⟨t, List.mem_cons_of_mem a htmem, ?_⟩
        intro s hs
        rcases List.mem_cons.mp hs with h | h
        · omega
        · exact htle s h

/-- A uniform lower bound sums: `k·t ≤ Σ`. -/
theorem length_mul_le_sum (t : Nat) (parts : List Nat)
    (h : ∀ s ∈ parts, t ≤ s) : parts.length * t ≤ parts.sum := by
  induction parts with
  | nil => simp
  | cons a rest ih =>
    have ha : t ≤ a := h a (by simp)
    have := ih (fun s hs => h s (List.mem_cons_of_mem a hs))
    simp only [List.length_cons, List.sum_cons]
    have : (rest.length + 1) * t = rest.length * t + t := by
      rw [Nat.add_mul, Nat.one_mul]
    omega

/-- **Proposition F.1, squared form.** -/
theorem prop_F1_sq (m : Nat) (hm : 0 < m) (parts : List Nat)
    (hne : parts ≠ []) (hcap : ∀ s ∈ parts, m ≤ pairs s) :
    2 * m * (parts.length * parts.length) < parts.sum * parts.sum := by
  obtain ⟨t, htmem, htle⟩ := exists_min_member parts hne
  have ht2 : 2 * m < t * t := size_of_capacity t m hm (hcap t htmem)
  have hsum : parts.length * t ≤ parts.sum := length_mul_le_sum t parts htle
  have hk : 1 ≤ parts.length := by
    have h0 : parts.length ≠ 0 := fun h => hne (List.eq_nil_of_length_eq_zero h)
    omega
  have hnn : (parts.length * t) * (parts.length * t) ≤ parts.sum * parts.sum :=
    Nat.mul_le_mul hsum hsum
  have hcomm : (parts.length * t) * (parts.length * t)
      = (parts.length * parts.length) * (t * t) := by ac_rfl
  have hgrow : (parts.length * parts.length) * (2 * m)
      < (parts.length * parts.length) * (t * t) :=
    (Nat.mul_lt_mul_left (Nat.mul_pos hk hk)).mpr ht2
  have hfin : 2 * m * (parts.length * parts.length)
      = (parts.length * parts.length) * (2 * m) := by ac_rfl
  omega

/-! ## 5. The central inequality (`Note.lean` §4, proved)

Definitions verbatim from `Note.lean` (on `pairs`); the theorem is the note's
Theorem-arithmetic in ℕ, multiplied through by 350.

The `pairs c`, `c*c` and `c*r` cases close by product inequalities with wide
margins (constants 14–28 against 350).  The `blockValue` case is the tight
one: `r ≥ 14` closes by the slack chain, `r ≤ 13` forces `n ≤ 65` and goes to
`decide`, with `t` pinned to 1 by monotonicity — the efficiency bound gives
`t ≥ 1` whenever `r ≥ 2`, and `blockValue` is monotone in `t`. -/

def blockValue (r t : Nat) : Nat := r * t / 2

/-- Condition 3 in integer form: `t ≥ (r-1)/12`. -/
def EfficiencyBound (r t : Nat) : Prop := r - 1 ≤ 12 * t

def mStarEven (c r t : Nat) : Nat := min (min (pairs c) (blockValue r t)) (c * r)
def mStarOdd (c r t : Nat) : Nat :=
  min (min (min (pairs c) (c * c)) (blockValue r t)) (c * r)

def RegionEven (n c r : Nat) : Prop := n = c + r ∧ n ≤ 5 * c ∧ n ≤ 5 * r
def RegionOdd (n c r : Nat) : Prop := n = 2 * c + r ∧ n ≤ 5 * c ∧ n ≤ 5 * r

/-- `Note.lean`'s sanity lemma, proved: the extra `c²` term only lowers. -/
theorem mStarOdd_le_even (c r t : Nat) : mStarOdd c r t ≤ mStarEven c r t := by
  unfold mStarOdd mStarEven
  have h1 : min (pairs c) (c * c) ≤ pairs c := Nat.min_le_left _ _
  omega

/-- Case `pairs c`: `n ≤ 5c` and `c ≥ 2` give `pairs n ≤ 350·pairs c`
(true constant 14, margin 25×). -/
theorem case_pairs (n c : Nat) (hc : 2 ≤ c) (hn : n ≤ 5 * c) :
    pairs n ≤ 350 * pairs c := by
  have h1 : n * (n - 1) ≤ (5 * c) * (5 * c) :=
    Nat.mul_le_mul hn (by omega)
  have h2 : (5 * c) * (5 * c) = 25 * (c * c) := by ac_rfl
  -- 25·c·c ≤ 350·c·(c-1) ⟸ c ≤ 14·(c-1) ⟸ c ≥ 2
  have h3 : c * c ≤ 14 * (c * (c - 1)) := by
    have : c ≤ 14 * (c - 1) := by omega
    calc c * c = c * c := rfl
      _ ≤ c * (14 * (c - 1)) := Nat.mul_le_mul_left c this
      _ = 14 * (c * (c - 1)) := by ac_rfl
  have h2p := two_pairs n
  have h2pc := two_pairs c
  omega

/-- Case `c*r`: `n ≤ 5c`, `n ≤ 5r` give `pairs n ≤ 350·c·r` (true constant
13, margin 27×). -/
theorem case_cross (n c r : Nat) (hc : n ≤ 5 * c) (hr : n ≤ 5 * r) :
    pairs n ≤ 350 * (c * r) := by
  have h1 : n * (n - 1) ≤ (5 * c) * (5 * r) := Nat.mul_le_mul hc (by omega)
  have h2 : (5 * c) * (5 * r) = 25 * (c * r) := by ac_rfl
  have h2p := two_pairs n
  omega

/-- Case `c*c` (odd construction only): `n ≤ 5c` gives `pairs n ≤ 350·c²`. -/
theorem case_square (n c : Nat) (hc : n ≤ 5 * c) :
    pairs n ≤ 350 * (c * c) := by
  have h1 : n * (n - 1) ≤ (5 * c) * (5 * c) := Nat.mul_le_mul hc (by omega)
  have h2 : (5 * c) * (5 * c) = 25 * (c * c) := by ac_rfl
  have h2p := two_pairs n
  omega

/-- Case `blockValue`, generic side `r ≥ 14`: the slack chain
`12·n(n-1) ≤ 300r² ≤ 350·r(r-1) − 4200 ≤ 12·(350·(rt/2)) …` closes.  At
`r = 13` the middle step is false, which is where the finite side begins. -/
theorem case_block_large (n r t : Nat) (hr : 14 ≤ r) (hn : n ≤ 5 * r)
    (heff : EfficiencyBound r t) : pairs n ≤ 350 * blockValue r t := by
  unfold EfficiencyBound at heff
  unfold blockValue
  have h2p := two_pairs n
  have hnn : n * (n - 1) ≤ 25 * (r * r) := by
    have h1 : n * (n - 1) ≤ (5 * r) * (5 * r) := Nat.mul_le_mul hn (by omega)
    have h2 : (5 * r) * (5 * r) = 25 * (r * r) := by ac_rfl
    omega
  have hrt : r * (r - 1) ≤ 12 * (r * t) := by
    calc r * (r - 1) ≤ r * (12 * t) := Nat.mul_le_mul_left r heff
      _ = 12 * (r * t) := by ac_rfl
  have hgap : 300 * (r * r) + 4200 ≤ 350 * (r * (r - 1)) := by
    -- 50·r(r−1) ≥ 300r + 4200 ⟸ r(r−1) ≥ 13r ≥ 6r + 84, from r ≥ 14.
    have hrr : r * r = r * (r - 1) + r := by
      have h0 : r - 1 + 1 = r := by omega
      calc r * r = r * (r - 1 + 1) := by rw [h0]
        _ = r * (r - 1) + r := by rw [Nat.mul_add, Nat.mul_one]
    have h13 : 13 * r ≤ r * (r - 1) := by
      have h1 : 13 ≤ r - 1 := by omega
      calc 13 * r ≤ (r - 1) * r := Nat.mul_le_mul_right r h1
        _ = r * (r - 1) := Nat.mul_comm _ _
    omega
  -- floor: 2·(rt/2) ≥ rt − 1
  have hfloor : r * t ≤ 2 * (r * t / 2) + 1 := by omega
  omega

/-- Case `blockValue`, finite side `r ≤ 13` (hence `n ≤ 65`): the bounded
check, with `t` pinned at 1.  This range contains the whole region's true
worst case `n = 65, r = 13`: `pairs 65 = 2080 ≤ 2100 = 350·6`. -/
theorem case_block_small_t1 : ∀ n < 66, ∀ r < 14,
    10 ≤ n → n ≤ 5 * r → pairs n ≤ 350 * blockValue r 1 := by
  decide

/-- **`blockValue_lower`** (`Note.lean` §2's first sorry, proved here instead):
the efficiency bound in the form the estimate uses, `2·blockValue ≥ r(r−1)/12`,
stated multiplied through with the `+1` absorbing the floor. -/
theorem blockValue_lower (r t : Nat) (h : EfficiencyBound r t) :
    r * (r - 1) ≤ 12 * (2 * blockValue r t + 1) := by
  unfold EfficiencyBound at h
  unfold blockValue
  have h1 : r * (r - 1) ≤ 12 * (r * t) := by
    calc r * (r - 1) ≤ r * (12 * t) := Nat.mul_le_mul_left r h
      _ = 12 * (r * t) := by ac_rfl
  have h2 : r * t ≤ 2 * (r * t / 2) + 1 := by omega
  omega

/-- `blockValue` is monotone in the twist. -/
theorem blockValue_mono (r : Nat) {t t' : Nat} (h : t ≤ t') :
    blockValue r t ≤ blockValue r t' := by
  unfold blockValue
  have := Nat.mul_le_mul_left r h
  omega

/-- The assembled block case: any `r`, any licensed `t`. -/
theorem case_block (n r t : Nat) (hn10 : 10 ≤ n) (hn : n ≤ 5 * r)
    (heff : EfficiencyBound r t) : pairs n ≤ 350 * blockValue r t := by
  by_cases hr : 14 ≤ r
  · exact case_block_large n r t hr hn heff
  · -- r ≤ 13, so n ≤ 65; and r ≥ 2 (from 10 ≤ n ≤ 5r), so t ≥ 1
    have hr13 : r < 14 := by omega
    have hn66 : n < 66 := by omega
    have hr2 : 2 ≤ r := by omega
    have ht1 : 1 ≤ t := by unfold EfficiencyBound at heff; omega
    have hbase := case_block_small_t1 n hn66 r hr13 hn10 hn
    have hmono := blockValue_mono r ht1
    omega

/-- **The even central inequality** (`Note.lean` `central_even`, proved):
under conditions 2 and 3 of (H), the even construction's minimum orbital is
at least `pairs n / 350`. -/
theorem central_even (n c r t : Nat) (hn : 10 ≤ n)
    (hreg : RegionEven n c r) (heff : EfficiencyBound r t) :
    pairs n ≤ 350 * mStarEven c r t := by
  obtain ⟨hsum, hc, hr⟩ := hreg
  have hc2 : 2 ≤ c := by omega
  have h1 := case_pairs n c hc2 hc
  have h2 := case_block n r t hn hr heff
  have h3 := case_cross n c r hc hr
  unfold mStarEven
  omega

/-- **The odd central inequality** (`Note.lean` `central_odd`, proved) —
including the companion lemma the sketch once called without declaring. -/
theorem central_odd (n c r t : Nat) (hn : 10 ≤ n)
    (hreg : RegionOdd n c r) (heff : EfficiencyBound r t) :
    pairs n ≤ 350 * mStarOdd c r t := by
  obtain ⟨hsum, hc, hr⟩ := hreg
  have hc2 : 2 ≤ c := by omega
  have h1 := case_pairs n c hc2 hc
  have h2 := case_block n r t hn hr heff
  have h3 := case_cross n c r hc hr
  have h4 := case_square n c hc
  unfold mStarOdd
  omega

/-! ## 6. The local analysis (`Note.lean` §6): the tables, `decide`-checked

Verbatim ports; all were `decide` sketches there and are compiled facts here.
The admissible table matches the note's mod-12 table entry for entry. -/

def dList : List Nat := [2, 4, 6, 12]

theorem dList_eq : dList = (([1, 2, 3, 6] : List Nat).map (2 * ·)) := by decide

theorem dList_dvd_twelve : ∀ d ∈ dList, d ∣ 12 := by decide

/-- Primality as a `Bool`, so the smoothness check is a plain computation.
(`Note.lean` records that the unbounded-quantifier encoding fails to
synthesize a `Decidable` instance; the Bool route sidesteps the instance
question entirely and is robust to Mathlib's primality-instance churn, which
is the concern its `dList_dvd_twelve` comment records.) -/
def isPrimeB (p : Nat) : Bool :=
  decide (2 ≤ p) && (List.range p).all (fun q => decide (q < 2) || decide (¬ (q ∣ p)))

theorem isPrimeB_spot : isPrimeB 2 ∧ isPrimeB 3 ∧ isPrimeB 7 ∧
    ¬ isPrimeB 1 ∧ ¬ isPrimeB 4 ∧ ¬ isPrimeB 6 ∧ ¬ isPrimeB 12 := by decide

/-- Every permitted `d` has all prime factors in `{2, 3}` — what confines the
local analysis to `ℓ ≤ 3` and keys the table mod 12. -/
theorem dList_smooth : ∀ d ∈ dList, ∀ p < d + 1,
    isPrimeB p = true → p ∣ d → p = 2 ∨ p = 3 := by decide

def admissible : Nat → List Nat
  | 0 => [2, 4, 6, 12]
  | 1 => [2]
  | 2 => [6, 12]
  | 3 => [4, 12]
  | 4 => [2, 4]
  | 5 => [6]
  | 6 => [2, 4, 6, 12]
  | 7 => [4]
  | 8 => [6, 12]
  | 9 => [2, 6]
  | 10 => [2, 4]
  | 11 => [12]
  | _ => []

theorem admissible_nonempty : ∀ a < 12, admissible a ≠ [] := by decide

theorem twelve_needed_only_at_eleven :
    ∀ a < 12, (admissible a = [12] ↔ a = 11) := by decide

theorem admissible_subset : ∀ a < 12, ∀ d ∈ admissible a, d ∈ dList := by decide

/-- The degeneration at `ℓ ∣ d` (`Note.lean` §6's example, without `ZMod`):
at `d = 6, n = 100, ℓ = 3` the third form `99 − 6q` vanishes identically. -/
theorem degeneration_example : ∀ q < 3, (99 + 6 * 3 - 6 * q) % 3 = 0 := by decide

end ArkCore

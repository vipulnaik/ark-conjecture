/-
# `SigmaHalf.lean` — the arithmetic half of (BCG), for any class specification, lifted

`arithmetic-of-density.md` §3.5.3, points 1 and 2 together, for the framework's Σ₀.

* **Any class specification** (`ClassSpec`: F, d, window [x₋, x₊]) has a witness predicate
  (`ClassSpec.Witness`: n = F·p^b + r in the window, r = d·q + 1 prime with q an odd prime,
  r ≠ p, r ∤ p^b − 1) and, when regular (`Good`), **one pointwise theorem**
  (`pointwise_half`): a witness at n gives an admissible `E6` configuration on n points with
  2·SAFE ≥ (target − κ/n)·n(n − 1).  The proof bounds the intra term and the foreign term by
  `Sigma.pointwise`, uses orb(r, q) = r·q = (2/d)·C(r,2) (`orb_dq`), shows the within-class cross
  term never binds (`within_ge`), and needs one side condition for the between-parts term,
  2F·x₋·y₋ ≥ target.
* **The window from ε** (`specEps`): for every F ≥ 1, d ≥ 2 the window of `Sigma.window_of_eps`
  is regular, side condition included (`specEps_good`: x\* ≤ 2(1 − F·x\*) since η ≤ 1 ≤ F).
* **Σ₀** (`spec0`, `W0`): class n mod 12 uses (F0, d0) at that window; its target is
  (1 − ε)·δ₀(class) (`spec0_tgt`, via `Sigma.cap_table`).
* **`sigma0_half`** — under `BCG.Hyp (W0 ε) L` with L = `atTop` (AL) or `almostAll` (AA),
  L-eventually n carries an admissible configuration with
  2·SAFE ≥ ((1 − ε)·δ₀(n mod 12) − κ/n)·n(n − 1).  One proof for both quantifiers, and the
  specification enters only through `spec0`: a different table of (F, d, window) is a different
  argument to the same theorems.

The same statement for μ\* itself, with Part E proved, is `PartEMu.sigma0_muStar` (via the
explicit groups of `PartE1`/`PartEF`).
-/
import Sigma
import E6

namespace SigmaHalf
open Real E6 ArkCore E5Assembly Sigma Filter

/-! ## Lower bounds on `minL` in ℝ -/

theorem le_foldr_min_real (B : ℝ) : ∀ (l : List ℕ) (s : ℕ), B ≤ 2 * (s : ℝ) →
    (∀ y ∈ l, B ≤ 2 * (y : ℝ)) → B ≤ 2 * ((l.foldr min s : ℕ) : ℝ)
  | [], s, hs, _ => by simpa using hs
  | x :: xs, s, hs, h => by
    have ih := le_foldr_min_real B xs s hs (fun y hy => h y (by simp [hy]))
    have hx := h x (by simp)
    simp only [List.foldr_cons]
    rcases le_total x (xs.foldr min s) with hm | hm
    · rw [min_eq_left hm]; exact hx
    · rw [min_eq_right hm]; exact ih

theorem le_two_minL (B : ℝ) {l : List ℕ} (h : ∀ y ∈ l, B ≤ 2 * (y : ℝ)) (hne : l ≠ []) :
    B ≤ 2 * ((minL l : ℕ) : ℝ) := by
  obtain ⟨x, xs, rfl⟩ := List.exists_cons_of_ne_nil hne
  apply le_foldr_min_real B _ _ _ h
  have hx := h x (by simp)
  have : x ≤ (x :: xs).sum := List.le_sum_of_mem (by simp)
  have : (x : ℝ) ≤ ((x :: xs).sum : ℕ) := by exact_mod_cast this
  linarith

/-! ## The configuration a witness provides -/

/-- One class of F blocks of size c (full twist) beside one foreign block r with twist q. -/
def cfg (p q F c r : ℕ) : Config := ⟨p, q, [.pc F c (c - 1), .fr r q]⟩

theorem cfg_fallbackFree (p q F c r : ℕ) : (cfg p q F c r).FallbackFree := by
  intro F' c' d' h
  simp only [cfg, List.mem_cons, List.not_mem_nil, or_false] at h
  rcases h with h | h <;> cases h; rfl

theorem cfg_n (p q F c r : ℕ) : (cfg p q F c r).n = F * c + r := by
  simp [cfg, Config.n, Config.sizes, CPart.sizeC]

/-- The within-class cross term never binds below the intra term. -/
theorem within_ge (F c : ℕ) : F * pairs c ≤ (if F % 2 = 1 then F else F / 2) * c * c := by
  have h := two_pairs c
  have : c * (c - 1) ≤ c * c := Nat.mul_le_mul_left _ (Nat.sub_le _ _)
  split
  · have : F * (2 * pairs c) ≤ F * (2 * (c * c)) := Nat.mul_le_mul_left _ (by omega)
    nlinarith
  · have hF : F = 2 * (F / 2) := by omega
    have : F * (2 * pairs c) ≤ F * (c * c) := Nat.mul_le_mul_left _ (by omega)
    nlinarith

/-- At r = d·q + 1 with q odd and d ≥ 2 the foreign term is exactly r·q = (2/d)·C(r,2). -/
theorem orb_dq {r q d : ℕ} (hq : q % 2 = 1) (hd : 2 ≤ d) (hr : r = d * q + 1) :
    orb r q false = r * q := by
  unfold orb
  have hc : ¬ (false = true ∨ q % 2 = 0) := by simp; omega
  split
  · exact absurd ‹_› hc
  apply min_eq_left
  have h := two_pairs r
  have : r - 1 = d * q := by omega
  rw [this] at h
  have : 2 * (r * q) ≤ r * (d * q) := by
    have := Nat.mul_le_mul_left (r * q) hd
    nlinarith
  omega

/-- **SAFE of the configuration is bounded by its binding terms**: any real B below twice the
intra term, the foreign term and the between-parts cross term is below 2·SAFE. -/
theorem safe_cfg_lower (p q F c r : ℕ) (B : ℝ) (h1 : B ≤ 2 * ((F * pairs c : ℕ) : ℝ))
    (h2 : B ≤ 2 * ((orb r q false : ℕ) : ℝ)) (h3 : B ≤ 2 * ((F * c * r : ℕ) : ℝ)) :
    B ≤ 2 * ((cfg p q F c r).safe : ℝ) := by
  have hL : (cfg p q F c r).parts.flatMap CPart.safeTerms ++ crossN (cfg p q F c r).sizes =
      F * pairs c :: ((if 2 ≤ F then [(if F % 2 = 1 then F else F / 2) * c * c] else []) ++
        [orb r q false, F * c * r]) := by
    simp [cfg, CPart.safeTerms, Part.terms, Config.sizes, CPart.sizeC, crossN]
  unfold Config.safe
  rw [hL]
  apply le_two_minL _ _ (by simp)
  intro y hy
  rw [List.mem_cons, List.mem_append] at hy
  rcases hy with rfl | hy | hy
  · exact h1
  · split at hy
    · rw [List.mem_singleton] at hy
      subst hy
      have := within_ge F c
      have : ((F * pairs c : ℕ) : ℝ) ≤ (((if F % 2 = 1 then F else F / 2) * c * c : ℕ) : ℝ) := by
        exact_mod_cast this
      linarith
    · simp at hy
  · simp only [List.mem_cons, List.not_mem_nil, or_false] at hy
    rcases hy with rfl | rfl
    · exact h2
    · exact h3

/-! ## A class specification, its witness, and the pointwise arithmetic half -/

/-- One class's specification: fusion count F, cofactor d (η = 2/d), and the window
[x₋, x₊] for the per-block share c/n. -/
structure ClassSpec where
  F : ℕ
  d : ℕ
  xlo : ℝ
  xhi : ℝ

namespace ClassSpec
variable (S : ClassSpec)
noncomputable def eta : ℝ := 2 / S.d
noncomputable def ylo : ℝ := 1 - S.F * S.xhi
noncomputable def tgt : ℝ := target S.F S.eta S.xlo S.xhi
noncomputable def kap : ℝ := max (S.F * S.xlo) (S.eta * S.ylo)

/-- The specification's regularity: the window is sensible, and the between-parts cross term
does not bind below the target (2F·x₋·y₋ ≥ target). -/
structure Good : Prop where
  F1 : 1 ≤ S.F
  d2 : 2 ≤ S.d
  lo0 : 0 ≤ S.xlo
  hi1 : S.F * S.xhi ≤ 1
  cross : S.tgt ≤ 2 * S.F * S.xlo * S.ylo

/-- **The witness at n** (clauses 1–4 for this class): n = F·c + r with c = p^b in the
window, r = d·q + 1 prime with q an odd prime, r ≠ p, and coherence r ∤ c − 1. -/
def Witness (n : ℕ) : Prop :=
  ∃ p b q r : ℕ, p.Prime ∧ 1 ≤ b ∧ q.Prime ∧ q % 2 = 1 ∧ r.Prime ∧ r ≠ p ∧
    r = S.d * q + 1 ∧ n = S.F * p ^ b + r ∧ S.xlo * n ≤ (p ^ b : ℕ) ∧ ((p ^ b : ℕ) : ℝ) ≤ S.xhi * n ∧
    ¬ r ∣ p ^ b - 1

end ClassSpec

/-- **The arithmetic half at a single n, for any class specification.**  A witness at n gives an
admissible configuration on n points with 2·SAFE ≥ (target − κ/n)·n(n − 1). -/
theorem cfg_half (S : ClassSpec) (hS : S.Good) {n p b q r : ℕ} (hp : p.Prime) (hb : 1 ≤ b)
    (hq : q.Prime) (hqo : q % 2 = 1) (hr : r.Prime) (hrp : r ≠ p) (hrd : r = S.d * q + 1)
    (hn : n = S.F * p ^ b + r) (hlo : S.xlo * n ≤ ((p ^ b : ℕ) : ℝ))
    (hhi : ((p ^ b : ℕ) : ℝ) ≤ S.xhi * n)
    (hx : 1 ≤ S.xlo * n) (hy : 1 ≤ S.ylo * n) :
    GAdm (cfg p q S.F (p ^ b) r) ∧
      (S.tgt - S.kap / n) * (n * (n - 1)) ≤ 2 * ((cfg p q S.F (p ^ b) r).safe : ℝ) := by
  set c := p ^ b with hc
  have hnpos : (0 : ℝ) < n := by
    rcases Nat.eq_zero_or_pos n with h | h
    · rw [h] at hx; simp at hx; linarith
    · exact_mod_cast h
  have hη : 0 ≤ S.eta := by unfold ClassSpec.eta; positivity
  have hd : (2 : ℝ) ≤ S.d := by exact_mod_cast hS.d2
  obtain ⟨hi, hf⟩ := pointwise S.F c r n (η := S.eta) hη hn hlo hhi hx (by simpa [ClassSpec.ylo] using hy)
  -- basic facts
  have hylo : S.ylo = 1 - S.F * S.xhi := rfl
  have htgt0 : 0 ≤ S.tgt := by
    unfold ClassSpec.tgt target; apply le_min <;> positivity
  have hkap1 : S.F * S.xlo ≤ S.kap := le_max_left _ _
  have hkap2 : S.eta * S.ylo ≤ S.kap := le_max_right _ _
  have hk0 : 0 ≤ S.F * S.xlo := mul_nonneg (Nat.cast_nonneg _) hS.lo0
  have hnn : 0 ≤ (n : ℝ) * (n - 1) := by
    have : (1 : ℝ) ≤ n := by
      have h1 : 1 ≤ n := by
        rcases Nat.eq_zero_or_pos n with h | h
        · rw [h] at hx; simp at hx; linarith
        · exact h
      exact_mod_cast h1
    nlinarith
  have hB : S.tgt - S.kap / n ≤ S.F * S.xlo ^ 2 - S.F * S.xlo / n := by
    have : S.tgt ≤ S.F * S.xlo ^ 2 := min_le_left _ _
    have : S.F * S.xlo / n ≤ S.kap / n := div_le_div_of_nonneg_right hkap1 hnpos.le
    linarith
  have hB2 : S.tgt - S.kap / n ≤ S.eta * (1 - S.F * S.xhi) ^ 2 - S.eta * (1 - S.F * S.xhi) / n := by
    have : S.tgt ≤ S.eta * (1 - S.F * S.xhi) ^ 2 := min_le_right _ _
    have : S.eta * (1 - S.F * S.xhi) / n ≤ S.kap / n := div_le_div_of_nonneg_right hkap2 hnpos.le
    linarith
  refine ⟨?_, ?_⟩
  · -- admissibility
    refine ⟨hp, hq, ?_, by simp [cfg, Config.foreign]⟩
    intro x hx'
    simp only [cfg, List.mem_cons, List.not_mem_nil, or_false] at hx'
    rcases hx' with rfl | rfl
    · exact ⟨hS.F1, ⟨b, hb, rfl⟩, dvd_refl _⟩
    · refine ⟨hr, hrp, ⟨S.d, by rw [hrd]; simp [Nat.mul_comm]⟩, 1, by simp [cfg]⟩
  · apply safe_cfg_lower
    · -- intra
      have h2 := two_pairs c
      have e : 2 * ((S.F * pairs c : ℕ) : ℝ) = S.F * ((c : ℝ) * (c - 1)) := by
        have : 2 * (S.F * pairs c) = S.F * (c * (c - 1)) := by rw [← h2]; ring
        have h' : ((2 * (S.F * pairs c) : ℕ) : ℝ) = ((S.F * (c * (c - 1)) : ℕ) : ℝ) := by rw [this]
        push_cast at h' ⊢
        rw [h']
        rcases Nat.eq_zero_or_pos c with h0 | h0
        · rw [h0]; simp
        · rw [Nat.cast_sub h0]; simp
      have := mul_le_mul_of_nonneg_right hB hnn
      linarith
    · -- foreign
      rw [orb_dq hqo hS.d2 hrd]
      have hrr : (r : ℝ) - 1 = S.d * q := by
        rw [hrd]; push_cast; ring
      have e : S.eta * ((r : ℝ) * (r - 1)) = 2 * ((r * q : ℕ) : ℝ) := by
        unfold ClassSpec.eta; rw [hrr]; push_cast
        have : (S.d : ℝ) ≠ 0 := by linarith
        field_simp
      have := mul_le_mul_of_nonneg_right hB2 hnn
      linarith
    · -- cross
      have hrlo : S.ylo * n ≤ r := by
        have : (n : ℝ) = S.F * c + r := by exact_mod_cast hn
        rw [hylo]; nlinarith [Nat.cast_nonneg (α := ℝ) S.F]
      have hcr : (S.F : ℝ) * (S.xlo * n) * (S.ylo * n) ≤ S.F * c * r := by
        have := mul_le_mul hlo hrlo (by linarith) (Nat.cast_nonneg _)
        have hF0 : (0 : ℝ) ≤ S.F := Nat.cast_nonneg _
        nlinarith
      have hcross := hS.cross
      have : S.tgt * (n * n) ≤ 2 * (S.F * c * r) := by nlinarith
      have h1 : (S.tgt - S.kap / n) * (n * (n - 1)) ≤ S.tgt * (n * n) := by
        have hk : 0 ≤ S.kap / n := div_nonneg (le_trans hk0 hkap1) hnpos.le
        nlinarith
      push_cast
      linarith

/-- **The arithmetic half at a single n, for any class specification.**  A witness at n gives an
admissible, fallback-free configuration on n points with 2·SAFE ≥ (target − κ/n)·n(n − 1). -/
theorem pointwise_half (S : ClassSpec) (hS : S.Good) {n : ℕ} (hW : S.Witness n)
    (hx : 1 ≤ S.xlo * n) (hy : 1 ≤ S.ylo * n) :
    ∃ C : Config, GAdm C ∧ C.FallbackFree ∧ C.n = n ∧
      (S.tgt - S.kap / n) * (n * (n - 1)) ≤ 2 * (C.safe : ℝ) := by
  obtain ⟨p, b, q, r, hp, hb, hq, hqo, hr, hrp, hrd, hn, hlo, hhi, -⟩ := hW
  obtain ⟨hC, hs⟩ := cfg_half S hS hp hb hq hqo hr hrp hrd hn hlo hhi hx hy
  exact ⟨_, hC, cfg_fallbackFree _ _ _ _ _, by rw [cfg_n]; exact hn.symm, hs⟩

/-! ## Σ₀: the window from ε, regularity, and the lifted arithmetic half -/

theorem one_sub_F_xstar (F : ℕ) (η : ℝ) (hF : 0 < F) (_hη : 0 ≤ η) :
    1 - F * xstar F η = 1 / (1 + √F * √η) := by
  have hFr : (0 : ℝ) < F := by exact_mod_cast hF
  have sF : √(F : ℝ) ^ 2 = F := sq_sqrt hFr.le
  have hsF : 0 < √(F : ℝ) := sqrt_pos.mpr hFr
  have aux : ∀ u e : ℝ, 0 < u → 0 ≤ e →
      1 - u ^ 2 * (e / (u * (1 + u * e))) = 1 / (1 + u * e) := by
    intro u e hu he
    have : 0 < 1 + u * e := by positivity
    field_simp; ring
  have := aux (√F) (√η) hsF (sqrt_nonneg _)
  rw [sF] at this
  unfold xstar; rw [sqrt_mul hFr.le]; exact this

/-- The class specification with Σ's (F, d) and the window `window_of_eps` gives at ε. -/
noncomputable def specEps (F d : ℕ) (ε : ℝ) : ClassSpec :=
  ⟨F, d, epsLo F (2 / d) ε, epsHi F (2 / d) ε⟩

theorem specEps_ylo (F d : ℕ) (ε : ℝ) (hF : 0 < F) :
    (specEps F d ε).ylo = (1 - F * xstar F (2 / d)) * √(1 - ε) := by
  have hFr : (0 : ℝ) < F := by exact_mod_cast hF
  unfold ClassSpec.ylo specEps epsHi; simp only; field_simp; ring

/-- **Every (F, d) with F ≥ 1, d ≥ 2 gives a regular specification at every ε ∈ [0, 1].**
In particular the cross term never binds: x\* ≤ 2(1 − F·x\*) because η ≤ 1 ≤ F. -/
theorem specEps_good (F d : ℕ) {ε : ℝ} (hF : 1 ≤ F) (hd : 2 ≤ d) (_hε : ε ≤ 1) :
    (specEps F d ε).Good := by
  have hFr : (1 : ℝ) ≤ F := by exact_mod_cast hF
  have hdr : (2 : ℝ) ≤ d := by exact_mod_cast hd
  have hη0 : (0 : ℝ) ≤ 2 / d := by positivity
  have hη1 : (2 : ℝ) / d ≤ 1 := by rw [div_le_one (by linarith)]; exact hdr
  have hs0 : 0 ≤ √(1 - ε) := sqrt_nonneg _
  have hF0 : 0 < F := by omega
  have h1F := one_sub_F_xstar F (2 / d) hF0 hη0
  have hD : 0 < 1 + √(F : ℝ) * √(2 / d) := by positivity
  have hx0 : 0 ≤ xstar F (2 / d) := by unfold xstar; positivity
  have hylo := specEps_ylo F d ε hF0
  have h1F0 : 0 ≤ 1 - F * xstar F (2 / d) := by rw [h1F]; positivity
  refine ⟨hF, hd, ?_, ?_, ?_⟩
  · show 0 ≤ epsLo F (2 / d) ε; unfold epsLo; positivity
  · show (F : ℝ) * epsHi F (2 / d) ε ≤ 1
    unfold epsHi
    rw [mul_div_cancel₀ _ (by linarith)]
    nlinarith
  · -- tgt ≤ F·x₋² ≤ 2F·x₋·y₋, since x₋ ≤ 2y₋ ⇐ x* ≤ 2(1 − F·x*)
    have hxs : xstar F (2 / d) ≤ 2 * (1 - F * xstar F (2 / d)) := by
      rw [h1F]
      unfold xstar
      have hsF : 1 ≤ √(F : ℝ) := by rw [show (1:ℝ) = √1 by simp]; exact sqrt_le_sqrt hFr
      have hse : √(2 / (d : ℝ)) ≤ 1 := by rw [show (1:ℝ) = √1 by simp]; exact sqrt_le_sqrt hη1
      rw [sqrt_mul (by linarith)]
      rw [div_le_iff₀ (by positivity)]
      field_simp
      nlinarith [sqrt_nonneg (2 / (d : ℝ))]
    have hlo : (specEps F d ε).xlo = xstar F (2 / d) * √(1 - ε) := rfl
    have : (specEps F d ε).tgt ≤ F * (specEps F d ε).xlo ^ 2 := min_le_left _ _
    have hFd : ((specEps F d ε).F : ℝ) = F := rfl
    rw [hFd, hylo]
    rw [hlo] at this ⊢
    have hfac : (F : ℝ) * (xstar F (2 / d) * √(1 - ε)) ^ 2 ≤
        2 * F * (xstar F (2 / d) * √(1 - ε)) * ((1 - F * xstar F (2 / d)) * √(1 - ε)) := by
      have : 0 ≤ (F : ℝ) * xstar F (2 / d) * √(1 - ε) ^ 2 := by positivity
      nlinarith
    linarith

/-- The residue class of n. -/
def cls (n : ℕ) : Fin 12 := ⟨n % 12, Nat.mod_lt _ (by norm_num)⟩

/-- Σ₀ at slack ε: class a's specification. -/
noncomputable def spec0 (ε : ℝ) (a : Fin 12) : ClassSpec := specEps (F0 a) (d0 a) ε

/-- Σ₀'s witness predicate: the witness for n's own class. -/
def W0 (ε : ℝ) (n : ℕ) : Prop := (spec0 ε (cls n)).Witness n

theorem F0_pos (a : Fin 12) : 1 ≤ F0 a := by fin_cases a <;> decide
theorem d0_ge (a : Fin 12) : 2 ≤ d0 a := by fin_cases a <;> decide

theorem spec0_tgt (ε : ℝ) (hε : ε ≤ 1) (a : Fin 12) :
    (spec0 ε a).tgt = (1 - ε) * capCol a := by
  unfold spec0 specEps ClassSpec.tgt ClassSpec.eta
  simp only
  rw [window_of_eps (F0 a) (by have := F0_pos a; omega) (by positivity) hε]
  rw [← cap_table a]; rfl

theorem spec0_pos (ε : ℝ) (hε : ε < 1) (a : Fin 12) :
    0 < (spec0 ε a).xlo ∧ 0 < (spec0 ε a).ylo := by
  have hF := F0_pos a
  have hd := d0_ge a
  have hdr : (2 : ℝ) ≤ d0 a := by exact_mod_cast hd
  have hη : (0 : ℝ) < 2 / d0 a := by positivity
  have hs : 0 < √(1 - ε) := sqrt_pos.mpr (by linarith)
  have hFr : (0 : ℝ) < F0 a := by exact_mod_cast (show 0 < F0 a by omega)
  constructor
  · show 0 < epsLo (F0 a) (2 / d0 a) ε
    unfold epsLo xstar
    have : 0 < √(2 / (d0 a : ℝ)) := sqrt_pos.mpr hη
    positivity
  · unfold spec0
    rw [specEps_ylo _ _ _ (by omega), one_sub_F_xstar _ _ (by omega) hη.le]
    positivity

/-- For ε < 1, every class's window eventually contains a block of size ≥ 1 on both sides. -/
theorem spec0_eventually {ε : ℝ} (hε1 : ε < 1) : ∀ᶠ n : ℕ in atTop, ∀ a : Fin 12,
    1 ≤ (spec0 ε a).xlo * (n : ℝ) ∧ 1 ≤ (spec0 ε a).ylo * (n : ℝ) := by
  rw [Filter.eventually_all]
  intro a
  obtain ⟨hx, hy⟩ := spec0_pos ε hε1 a
  have h1 : ∀ᶠ n : ℕ in atTop, (1 / (spec0 ε a).xlo) ≤ (n : ℝ) :=
    tendsto_natCast_atTop_atTop.eventually_ge_atTop _
  have h2 : ∀ᶠ n : ℕ in atTop, (1 / (spec0 ε a).ylo) ≤ (n : ℝ) :=
    tendsto_natCast_atTop_atTop.eventually_ge_atTop _
  filter_upwards [h1, h2] with n hn1 hn2
  constructor
  · rw [div_le_iff₀ hx] at hn1; linarith
  · rw [div_le_iff₀ hy] at hn2; linarith

/-- **The arithmetic half of (BCG) for Σ₀, under either quantifier.**  If Σ₀'s witness holds
L-eventually (L = `atTop` for (AL), `almostAll` for (AA)), then L-eventually n carries an
admissible configuration with 2·SAFE ≥ ((1 − ε)·δ₀(n mod 12) − κ/n)·n(n − 1), δ₀ being §3.3.5's
cap for n's class.  One proof; the specification enters only through `spec0`. -/
theorem sigma0_half {ε : ℝ} (hε1 : ε < 1) {L : Filter ℕ} (hL : L ≤ atTop)
    (H : BCG.Hyp (W0 ε) L) :
    ∀ᶠ n in L, ∃ C : Config, GAdm C ∧ C.FallbackFree ∧ C.n = n ∧
      ((1 - ε) * capCol (cls n) - (spec0 ε (cls n)).kap / n) * (n * (n - 1)) ≤ 2 * (C.safe : ℝ) := by
  have hlarge := hL (spec0_eventually hε1)
  filter_upwards [H, hlarge] with n hW hl
  obtain ⟨hx, hy⟩ := hl (cls n)
  have hg := specEps_good (F0 (cls n)) (d0 (cls n)) (ε := ε) (F0_pos _) (d0_ge _) hε1.le
  obtain ⟨C, hC, hff, hn, hs⟩ := pointwise_half (spec0 ε (cls n)) hg hW hx hy
  refine ⟨C, hC, hff, hn, ?_⟩
  rw [← spec0_tgt ε hε1.le]
  exact hs

end SigmaHalf

/-
# `D2.lean` — Lemma D2's counting classes, for a permutation group of the orbit

Lemma D2 (`enumeration-proof.md` Part D2): an orbit O of F ≥ 2 outside blocks of prime size r
(fused, or F distinct foreign orbits of one prime) carries a class of at most F·C(r,2) pairs,
and when F < r one of at most C(F,2)·r; at r = q (Lemma D2q) one of at most F·r.

The text's proof has a counting half and a structural half.  This file proves the **counting
half** in full, for an arbitrary group G of permutations of O = Fin F × ZMod r (the image
Γ|_O; a class of Γ on pairs inside O is exactly a G-orbit on unordered pairs):

* `d2a` — **branch (a)**: if G preserves the block system, some orbital has at most
  F·C(r,2) pairs.  (The text: "this needs only that the block system exists".)
* `d2b` — **Step 3**: if every element acts as (i, x) ↦ (σi, a·x + s) — one multiplier and one
  translation across all blocks — the same-position pairs are a union of classes, so some
  orbital has at most C(F,2)·r pairs.
* `d2b_shift` — Step 3 in the shifted coordinates x − oᵢ that Step 2 produces (`Glue.step2_glue`),
  so Step 2's output feeds Step 3 directly.
* `d2q` — **D2q step (7)**: if every element acts with trivial linear part,
  (i, x) ↦ (σi, x + sᵢ), the within-block pairs of one difference ±δ are a union of classes,
  so some orbital has at most F·r pairs.
* `step1_sigma`, `step1_mult` — **Step 1's two order arguments**: an element of r-power order
  in Sym(F) with F < r is trivial; a multiplier of r-power order in (ZMod r)ˣ is trivial.
* `step2_mult_equal` — **Step 2's first claim**: if conjugation sends the diagonal translation
  to a diagonal one, all the multipliers aᵢ of g are equal.
* `fo_terms_match` — the bounds are exactly `E6`'s `fo` SAFE terms (F·pairs r, pairs F·r,
  F·r).

**Not formalised: the rest of Steps 1–2** — that the r-elements of Γ form one cyclic group of
translations, made diagonal by rescaling (this is where Sylow-r of Γ being cyclic, from
r ∉ {p, q} and the chain, is used), and the H¹(Q, V) = 0 change of per-block origins that
makes every translation part diagonal.  Those enter `d2b` and `d2q` as the
normal-form hypothesis, and are where the chain structure does its work.
-/
import Mathlib

namespace D2
open Finset

open Classical in
/-- The G-orbit of an unordered pair. -/
noncomputable def orbit2 {α : Type*} [Fintype α] [DecidableEq α]
    (G : Subgroup (Equiv.Perm α)) (e : Sym2 α) : Finset (Sym2 α) :=
  ((univ : Finset (Equiv.Perm α)).filter (· ∈ G)).image (fun g : Equiv.Perm α => Sym2.map (⇑g) e)

/-- An orbit inside a G-invariant set is no larger than the set. -/
theorem orbit2_card_le {α : Type*} [Fintype α] [DecidableEq α]
    (G : Subgroup (Equiv.Perm α)) (S : Finset (Sym2 α))
    (hS : ∀ g ∈ G, ∀ e ∈ S, Sym2.map g e ∈ S) {e : Sym2 α} (he : e ∈ S) :
    (orbit2 G e).card ≤ S.card := by
  classical
  apply card_le_card
  intro x hx
  rw [orbit2, mem_image] at hx
  obtain ⟨g, hg, rfl⟩ := hx
  rw [mem_filter] at hg
  exact hS g hg.2 e he

/-- Points of O: block index and position. -/
abbrev Pt (F r : ℕ) := Fin F × ZMod r

variable {F r : ℕ} [NeZero r]

/-! ### Branch (a): the within-block class -/

/-- Within-block, off-diagonal pairs. -/
noncomputable def within (F r : ℕ) [NeZero r] : Finset (Sym2 (Pt F r)) := by
  classical
  exact univ.filter fun e => ¬ e.IsDiag ∧
    Sym2.lift ⟨fun a b => a.1 = b.1, fun _ _ => propext eq_comm⟩ e

theorem within_card : (within F r).card ≤ F * r.choose 2 := by
  classical
  let T : Finset (Sym2 (Pt F r)) := univ.biUnion fun i : Fin F =>
    (((univ : Finset (ZMod r)).offDiag.image Sym2.mk.uncurry).image
      (Sym2.map fun x => (i, x)))
  have hsub : within F r ⊆ T := by
    intro e he
    simp only [within, mem_filter, mem_univ, true_and] at he
    induction e using Sym2.ind with
    | _ a b =>
      obtain ⟨hnd, hblk⟩ := he
      simp only [Sym2.lift_mk, Sym2.mk_isDiag_iff] at hblk hnd
      simp only [T, mem_biUnion, mem_univ, true_and, mem_image, mem_offDiag]
      refine ⟨a.1, s(a.2, b.2), ⟨(a.2, b.2), ?_, rfl⟩, ?_⟩
      · intro h; apply hnd; exact Prod.ext hblk h
      · rw [Sym2.map_mk]
        obtain ⟨a1, a2⟩ := a; obtain ⟨b1, b2⟩ := b
        simp only at hblk; subst hblk; rfl
  calc (within F r).card ≤ T.card := card_le_card hsub
    _ ≤ ∑ _i : Fin F, ((univ : Finset (ZMod r)).offDiag.image Sym2.mk.uncurry).card := by
        apply le_trans (card_biUnion_le)
        apply sum_le_sum; intro i _; exact card_image_le
    _ = F * r.choose 2 := by
        rw [sum_const, card_univ, Fintype.card_fin, Sym2.card_image_offDiag, card_univ,
          ZMod.card, smul_eq_mul]

/-- **Lemma D2, branch (a).**  If G preserves the block system, some orbital (a G-orbit on
off-diagonal pairs) has at most F·C(r,2) pairs. -/
theorem d2a (G : Subgroup (Equiv.Perm (Pt F r))) (hF : 1 ≤ F) (hr : 2 ≤ r)
    (hblk : ∀ g ∈ G, ∀ a b : Pt F r, a.1 = b.1 → (g a).1 = (g b).1) :
    ∃ e : Sym2 (Pt F r), ¬ e.IsDiag ∧ (orbit2 G e).card ≤ F * r.choose 2 := by
  classical
  let a : Pt F r := (⟨0, by omega⟩, 0)
  let b : Pt F r := (⟨0, by omega⟩, 1)
  have hab : a ≠ b := by
    intro h
    have : (0 : ZMod r) = 1 := congrArg Prod.snd h
    have h1 : ((1 : ZMod r)).val = 1 := ZMod.val_one'' (by omega)
    rw [← this, ZMod.val_zero] at h1; exact absurd h1 (by norm_num)
  have he : s(a, b) ∈ within F r := by
    simp [within, hab]
    rfl
  refine ⟨s(a, b), by simpa using hab, le_trans (orbit2_card_le G _ ?_ he) within_card⟩
  intro g hg e he'
  simp only [within, mem_filter, mem_univ, true_and] at he' ⊢
  induction e using Sym2.ind with
  | _ u v =>
    simp only [Sym2.map_mk, Sym2.lift_mk, Sym2.mk_isDiag_iff] at he' ⊢
    exact ⟨fun h => he'.1 (g.injective h), hblk g hg u v he'.2⟩

/-! ### Step 3: the same-position class -/

/-- Same-position, off-diagonal pairs (so in different blocks). -/
noncomputable def samePos (F r : ℕ) [NeZero r] : Finset (Sym2 (Pt F r)) := by
  classical
  exact univ.filter fun e => ¬ e.IsDiag ∧
    Sym2.lift ⟨fun a b => a.2 = b.2, fun _ _ => propext eq_comm⟩ e

theorem samePos_card : (samePos F r).card ≤ r * F.choose 2 := by
  classical
  let T : Finset (Sym2 (Pt F r)) := univ.biUnion fun x : ZMod r =>
    (((univ : Finset (Fin F)).offDiag.image Sym2.mk.uncurry).image
      (Sym2.map fun i => (i, x)))
  have hsub : samePos F r ⊆ T := by
    intro e he
    simp only [samePos, mem_filter, mem_univ, true_and] at he
    induction e using Sym2.ind with
    | _ a b =>
      obtain ⟨hnd, hpos⟩ := he
      simp only [Sym2.lift_mk, Sym2.mk_isDiag_iff] at hpos hnd
      simp only [T, mem_biUnion, mem_univ, true_and, mem_image, mem_offDiag]
      refine ⟨a.2, s(a.1, b.1), ⟨(a.1, b.1), ?_, rfl⟩, ?_⟩
      · intro h; apply hnd; exact Prod.ext h hpos
      · rw [Sym2.map_mk]
        obtain ⟨a1, a2⟩ := a; obtain ⟨b1, b2⟩ := b
        simp only at hpos; subst hpos; rfl
  calc (samePos F r).card ≤ T.card := card_le_card hsub
    _ ≤ ∑ _x : ZMod r, ((univ : Finset (Fin F)).offDiag.image Sym2.mk.uncurry).card := by
        apply le_trans (card_biUnion_le)
        apply sum_le_sum; intro i _; exact card_image_le
    _ = r * F.choose 2 := by
        rw [sum_const, card_univ, ZMod.card, Sym2.card_image_offDiag, card_univ,
          Fintype.card_fin, smul_eq_mul]

/-- **Lemma D2, Step 3.**  If every element of G acts as (i, x) ↦ (σi, a·x + s), the
same-position pairs are G-invariant, so (F ≥ 2) some orbital has at most C(F,2)·r pairs. -/
theorem d2b (G : Subgroup (Equiv.Perm (Pt F r))) (hF : 2 ≤ F)
    (hform : ∀ g ∈ G, ∃ σ : Equiv.Perm (Fin F), ∃ a s : ZMod r,
      ∀ p : Pt F r, g p = (σ p.1, a * p.2 + s)) :
    ∃ e : Sym2 (Pt F r), ¬ e.IsDiag ∧ (orbit2 G e).card ≤ r * F.choose 2 := by
  classical
  let a : Pt F r := (⟨0, by omega⟩, 0)
  let b : Pt F r := (⟨1, by omega⟩, 0)
  have hab : a ≠ b := by
    intro h; have := congrArg (fun p => (p.1 : ℕ)) h; simp [a, b] at this
  have he : s(a, b) ∈ samePos F r := by
    simp [samePos, hab]
    rfl
  refine ⟨s(a, b), by simpa using hab, le_trans (orbit2_card_le G _ ?_ he) samePos_card⟩
  intro g hg e he'
  simp only [samePos, mem_filter, mem_univ, true_and] at he' ⊢
  induction e using Sym2.ind with
  | _ u v =>
    simp only [Sym2.map_mk, Sym2.lift_mk, Sym2.mk_isDiag_iff] at he' ⊢
    obtain ⟨σ, m, s, hg'⟩ := hform g hg
    refine ⟨fun h => he'.1 (g.injective h), ?_⟩
    rw [hg' u, hg' v]; simp [he'.2]

/-- Same-position pairs in shifted coordinates x − oᵢ. -/
noncomputable def samePosO (F r : ℕ) [NeZero r] (o : Fin F → ZMod r) :
    Finset (Sym2 (Pt F r)) := by
  classical
  exact univ.filter fun e => ¬ e.IsDiag ∧
    Sym2.lift ⟨fun a b => a.2 - o a.1 = b.2 - o b.1, fun _ _ => propext eq_comm⟩ e

theorem samePosO_card (o : Fin F → ZMod r) : (samePosO F r o).card ≤ r * F.choose 2 := by
  classical
  let φ : Pt F r → Pt F r := fun p => (p.1, p.2 + o p.1)
  have hsub : samePosO F r o ⊆ (samePos F r).image (Sym2.map φ) := by
    intro e he
    simp only [samePosO, mem_filter, mem_univ, true_and] at he
    induction e using Sym2.ind with
    | _ a b =>
      obtain ⟨hnd, hpos⟩ := he
      simp only [Sym2.lift_mk, Sym2.mk_isDiag_iff] at hpos hnd
      simp only [mem_image, samePos, mem_filter, mem_univ, true_and]
      refine ⟨s((a.1, a.2 - o a.1), (b.1, b.2 - o b.1)), ⟨?_, ?_⟩, ?_⟩
      · simp only [Sym2.mk_isDiag_iff]
        intro h; apply hnd
        have h1 := congrArg Prod.fst h
        simp only at h1
        exact Prod.ext h1 (by have h2 := congrArg Prod.snd h; simp only at h2; rw [h1] at h2; linear_combination h2)
      · simpa using hpos
      · simp [Sym2.map_mk, φ]
  exact le_trans (card_le_card hsub) (le_trans card_image_le samePos_card)

/-- **Lemma D2, Step 3 in shifted coordinates.**  If every element acts as
(i, x − oᵢ) ↦ (σi, a·(x − oᵢ) + s) — Step 2's conclusion — some orbital has at most
C(F,2)·r pairs. -/
theorem d2b_shift (G : Subgroup (Equiv.Perm (Pt F r))) (hF : 2 ≤ F) (o : Fin F → ZMod r)
    (hform : ∀ g ∈ G, ∃ σ : Equiv.Perm (Fin F), ∃ a s : ZMod r,
      ∀ i x, g (i, x + o i) = (σ i, a * x + s + o (σ i))) :
    ∃ e : Sym2 (Pt F r), ¬ e.IsDiag ∧ (orbit2 G e).card ≤ r * F.choose 2 := by
  classical
  let a : Pt F r := (⟨0, by omega⟩, o ⟨0, by omega⟩)
  let b : Pt F r := (⟨1, by omega⟩, o ⟨1, by omega⟩)
  have hab : a ≠ b := by
    intro h; have := congrArg (fun p => (p.1 : ℕ)) h; simp [a, b] at this
  have he : s(a, b) ∈ samePosO F r o := by
    simp only [samePosO, mem_filter, mem_univ, true_and, Sym2.lift_mk, Sym2.mk_isDiag_iff]
    exact ⟨hab, by simp [a, b]⟩
  refine ⟨s(a, b), by simpa using hab, le_trans (orbit2_card_le G _ ?_ he) (samePosO_card o)⟩
  intro g hg e he'
  simp only [samePosO, mem_filter, mem_univ, true_and] at he' ⊢
  induction e using Sym2.ind with
  | _ u v =>
    simp only [Sym2.map_mk, Sym2.lift_mk, Sym2.mk_isDiag_iff] at he' ⊢
    obtain ⟨σ, m, s, hg'⟩ := hform g hg
    refine ⟨fun h => he'.1 (g.injective h), ?_⟩
    have hu := hg' u.1 (u.2 - o u.1)
    have hv := hg' v.1 (v.2 - o v.1)
    simp only [sub_add_cancel] at hu hv
    rw [show u = (u.1, u.2) from rfl, show v = (v.1, v.2) from rfl, hu, hv]
    simp only
    rw [he'.2]
    ring

/-! ### D2q, step (7): trivial linear parts -/

/-- Within-block pairs with difference ±δ. -/
noncomputable def diffClass (F r : ℕ) [NeZero r] (δ : ZMod r) : Finset (Sym2 (Pt F r)) := by
  classical
  exact univ.filter fun e => ¬ e.IsDiag ∧
    Sym2.lift ⟨fun a b => a.1 = b.1 ∧ (a.2 - b.2 = δ ∨ b.2 - a.2 = δ),
      fun _ _ => propext ⟨fun h => ⟨h.1.symm, h.2.symm⟩, fun h => ⟨h.1.symm, h.2.symm⟩⟩⟩ e

theorem diffClass_card (δ : ZMod r) : (diffClass F r δ).card ≤ F * r := by
  classical
  let T : Finset (Sym2 (Pt F r)) :=
    (univ : Finset (Pt F r)).image fun p => s(p, (p.1, p.2 + δ))
  have hsub : diffClass F r δ ⊆ T := by
    intro e he
    simp only [diffClass, mem_filter, mem_univ, true_and] at he
    induction e using Sym2.ind with
    | _ a b =>
      obtain ⟨-, hblk, hd⟩ := he
      simp only at hblk hd
      simp only [T, mem_image, mem_univ, true_and]
      obtain ⟨a1, a2⟩ := a; obtain ⟨b1, b2⟩ := b
      simp only at hblk hd; subst hblk
      rcases hd with h | h
      · refine ⟨(a1, b2), ?_⟩
        rw [Sym2.eq_swap]; congr 2; rw [← h]; ring
      · refine ⟨(a1, a2), ?_⟩
        congr 2; rw [← h]; ring
  calc (diffClass F r δ).card ≤ T.card := card_le_card hsub
    _ ≤ (univ : Finset (Pt F r)).card := card_image_le
    _ = F * r := by simp [ZMod.card]

/-- **Lemma D2q, step (7).**  If every element of G acts with trivial linear part, the pairs
of one within-block difference ±1 are G-invariant, so (r ≥ 2, F ≥ 1) some orbital has at most
F·r pairs. -/
theorem d2q (G : Subgroup (Equiv.Perm (Pt F r))) (hF : 1 ≤ F) (hr : 2 ≤ r)
    (hform : ∀ g ∈ G, ∃ σ : Equiv.Perm (Fin F), ∃ s : Fin F → ZMod r,
      ∀ p : Pt F r, g p = (σ p.1, p.2 + s p.1)) :
    ∃ e : Sym2 (Pt F r), ¬ e.IsDiag ∧ (orbit2 G e).card ≤ F * r := by
  classical
  let a : Pt F r := (⟨0, by omega⟩, 1)
  let b : Pt F r := (⟨0, by omega⟩, 0)
  have h10 : (1 : ZMod r) ≠ 0 := by
    intro h
    have h1 : ((1 : ZMod r)).val = 1 := ZMod.val_one'' (by omega)
    rw [h, ZMod.val_zero] at h1; exact absurd h1 (by norm_num)
  have hab : a ≠ b := by
    intro h; exact h10 (congrArg Prod.snd h)
  have he : s(a, b) ∈ diffClass F r 1 := by
    simp only [diffClass, mem_filter, mem_univ, true_and, Sym2.lift_mk, Sym2.mk_isDiag_iff]
    exact ⟨hab, rfl, Or.inl (by simp [a, b])⟩
  refine ⟨s(a, b), by simpa using hab, le_trans (orbit2_card_le G _ ?_ he) (diffClass_card 1)⟩
  intro g hg e he'
  simp only [diffClass, mem_filter, mem_univ, true_and] at he' ⊢
  induction e using Sym2.ind with
  | _ u v =>
    simp only [Sym2.map_mk, Sym2.lift_mk, Sym2.mk_isDiag_iff] at he' ⊢
    obtain ⟨σ, s, hg'⟩ := hform g hg
    refine ⟨fun h => he'.1 (g.injective h), ?_⟩
    obtain ⟨hnd, hblk, hd⟩ := he'
    rw [hg' u, hg' v]
    simp only [hblk]
    refine ⟨trivial, ?_⟩
    rcases hd with h | h
    · left; rw [← h]; ring
    · right; rw [← h]; ring

/-! ### Step 1's two order arguments -/

omit [NeZero r] in
/-- An element of r-power order in Sym(F), with F < r and r prime, is trivial. -/
theorem step1_sigma {σ : Equiv.Perm (Fin F)} (hr : r.Prime) (hFr : F < r) {k : ℕ}
    (hk : orderOf σ = r ^ k) : σ = 1 := by
  have hdvd : orderOf σ ∣ F.factorial := by
    have := orderOf_dvd_card (x := σ)
    simpa [Fintype.card_perm] using this
  rcases Nat.eq_zero_or_pos k with h0 | hpos
  · rw [h0, pow_zero, orderOf_eq_one_iff] at hk; exact hk
  · exfalso
    rw [hk] at hdvd
    have : r ∣ F.factorial := (dvd_pow_self r (by omega)).trans hdvd
    rw [hr.dvd_factorial] at this
    omega

/-- A multiplier of r-power order in (ZMod r)ˣ is trivial: its order divides r − 1. -/
theorem step1_mult [Fact r.Prime] {a : (ZMod r)ˣ} {k : ℕ} (hk : orderOf a = r ^ k) : a = 1 := by
  have hr := (Fact.out : r.Prime)
  have hdvd : orderOf a ∣ r - 1 := by
    have := orderOf_dvd_card (x := a)
    rwa [ZMod.card_units] at this
  rcases Nat.eq_zero_or_pos k with h0 | hpos
  · rw [h0, pow_zero, orderOf_eq_one_iff] at hk; exact hk
  · exfalso
    rw [hk] at hdvd
    have h1 : r ∣ r - 1 := (dvd_pow_self r (by omega)).trans hdvd
    have h2 := hr.two_le
    have := Nat.le_of_dvd (by omega) h1
    omega

/-! ### Step 2's first claim: one common multiplier -/

/-- If conjugating the diagonal translation by s ≠ 0 through g = (σ, (aᵢ), ·) gives the
translation vector j ↦ a_{σ⁻¹ j}·s, and that vector is diagonal (lies in T\*), then all the
multipliers aᵢ are equal. -/
theorem step2_mult_equal {K : Type*} [Field K] {F : ℕ} (σ : Equiv.Perm (Fin F))
    (a : Fin F → K) {s c : K} (hs : s ≠ 0) (hdiag : ∀ j, a (σ.symm j) * s = c) :
    ∀ i j, a i = a j := by
  intro i j
  have hi := hdiag (σ i)
  have hj := hdiag (σ j)
  simp only [Equiv.symm_apply_apply] at hi hj
  exact mul_right_cancel₀ hs (hi.trans hj.symm)

/-! ### The bounds are `E6`'s `fo` terms -/

/-- F·C(r,2), C(F,2)·r and F·r — D2's three bounds — in `ArkCore.pairs` form, the values `E6`
gives a `fo` part. -/
theorem fo_terms_match (F r : ℕ) :
    F * r.choose 2 = F * (r * (r - 1) / 2) ∧ r * F.choose 2 = F * (F - 1) / 2 * r := by
  refine ⟨by rw [Nat.choose_two_right], by rw [Nat.choose_two_right, Nat.mul_comm]⟩

end D2

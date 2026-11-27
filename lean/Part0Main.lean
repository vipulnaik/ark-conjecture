/-
# `Part0Main.lean` — Part 0 assembled: μ\* ≤ B_safe, given `HypHuppert`

**`part0`**: an Oliver group Γ on n ≥ 2 points has a fixed point (and then an orbital of at most
n − 1 pairs), or there is an admissible configuration C (`E6.GAdm`) on n points with some orbital
of Γ at most SAFE(C).  So the least orbital of every Oliver group is at most B_safe(n), unless the
group has a fixed point.

The configuration is read off Γ:
* each orbit whose least block has p-power size c is a class `pc F c (c − 1)` (F blocks);
* for each outside prime r, all orbits whose least block has size r together form one part:
  `fr r t` if that is a single unfused orbit (t from `fr_orbit`), else `fo F r 1` with F the
  total number of r-blocks (`fused_orbit`, `two_orbits`, `fr_orbit` at r = q).
-/
import Part0Fo
import Upper

set_option linter.unusedSectionVars false

namespace Part0Main
open Finset Chain ArkCore Part0 Part0Fr Part0Fo E6

variable {V : Type} [Fintype V] [DecidableEq V]

/-! ## Orbits -/

theorem orb_inv (Γ : Subgroup (Equiv.Perm V)) (x : V) : ∀ g ∈ Γ, ∀ y ∈ Upper.orb Γ x, g y ∈ Upper.orb Γ x := by
  intro g hg y hy
  obtain ⟨h, hh, rfl⟩ := Upper.mem_orb.mp hy
  exact Upper.mem_orb.mpr ⟨g * h, Γ.mul_mem hg hh, rfl⟩

theorem orb_tr (Γ : Subgroup (Equiv.Perm V)) (x : V) :
    ∀ y ∈ Upper.orb Γ x, ∀ z ∈ Upper.orb Γ x, ∃ g ∈ Γ, g y = z := by
  intro y hy z hz
  rw [← Upper.orb_eq_of_mem hy] at hz
  exact Upper.mem_orb.mp hz

theorem orb_disj (Γ : Subgroup (Equiv.Perm V)) {x y : V} (h : Upper.orb Γ x ≠ Upper.orb Γ y) :
    Disjoint (Upper.orb Γ x) (Upper.orb Γ y) := by
  rw [disjoint_left]; intro z hz hz'
  exact h ((Upper.orb_eq_of_mem hz).symm.trans (Upper.orb_eq_of_mem hz'))

theorem orb_two (Γ : Subgroup (Equiv.Perm V)) (hfp : ∀ x, ∃ g ∈ Γ, g x ≠ x) (x : V) :
    2 ≤ (Upper.orb Γ x).card := by
  obtain ⟨g, hg, hgx⟩ := hfp x
  have : ({x, g x} : Finset V) ⊆ Upper.orb Γ x := by
    intro z hz; simp only [mem_insert, mem_singleton] at hz
    rcases hz with rfl | rfl
    · exact Upper.self_mem_orb Γ _
    · exact Upper.mem_orb.mpr ⟨g, hg, rfl⟩
  have := card_le_card this
  rwa [card_pair (Ne.symm hgx)] at this

/-! ## The data read off Γ -/

section data
open Classical
variable (Γ : Subgroup (Equiv.Perm V)) (p q : ℕ)

/-- B is a least nontrivial block inside O. -/
def LeastB (O B : Finset V) : Prop :=
  B ⊆ O ∧ IsBlk Γ B ∧ 2 ≤ B.card ∧ ∀ B' ⊆ O, IsBlk Γ B' → 2 ≤ B'.card → B.card ≤ B'.card

noncomputable def blk (O : Finset V) : Finset V := Classical.epsilon (LeastB Γ O)
noncomputable def Os : Finset (Finset V) := univ.image (Upper.orb Γ)
noncomputable def Fb (O : Finset V) : ℕ := (blockSys Γ (blk Γ O)).card
noncomputable def cb (O : Finset V) : ℕ := (blk Γ O).card
def Out (O : Finset V) : Prop := (cb Γ O).Prime ∧ cb Γ O ≠ p
noncomputable def Om : Finset (Finset V) := (Os Γ).filter (fun O => ¬ Out Γ p O)
noncomputable def Oo : Finset (Finset V) := (Os Γ).filter (Out Γ p)
noncomputable def Rs : Finset ℕ := (Oo Γ p).image (cb Γ)
noncomputable def Orr (r : ℕ) : Finset (Finset V) := (Oo Γ p).filter (fun O => cb Γ O = r)
noncomputable def Fr (r : ℕ) : ℕ := ∑ O ∈ Orr Γ p r, Fb Γ O
noncomputable def Ur (r : ℕ) : Finset V := (Orr Γ p r).biUnion id
noncomputable def tq (r : ℕ) : ℕ :=
  Classical.epsilon (fun t => (∃ f, t = q ^ f) ∧ t ∣ r - 1 ∧ OrbLe Γ (orb r t false))
noncomputable def partOf (r : ℕ) : CPart :=
  if Fr Γ p r = 1 then .fr r (tq Γ q r) else .fo (Fr Γ p r) r 1

/-- The realising list: classes, then one part per outside prime. -/
noncomputable def RL : List (CPart × Finset V) :=
  (Om Γ p).toList.map (fun O => (.pc (Fb Γ O) (cb Γ O) (cb Γ O - 1), O)) ++
    (Rs Γ p).toList.map (fun r => (partOf Γ p q r, Ur Γ p r))

noncomputable def cfg : Config := ⟨p, q, (RL Γ p q).map Prod.fst⟩

end data

/-! ## Properties of the data -/

section props
open Classical
variable {Γ : Subgroup (Equiv.Perm V)} {p q : ℕ}

theorem mem_Os {O : Finset V} : O ∈ Os Γ ↔ ∃ x, Upper.orb Γ x = O := by
  simp [Os]

theorem Os_inv {O : Finset V} (hO : O ∈ Os Γ) : ∀ g ∈ Γ, ∀ y ∈ O, g y ∈ O := by
  obtain ⟨x, rfl⟩ := mem_Os.mp hO; exact orb_inv Γ x

theorem Os_tr {O : Finset V} (hO : O ∈ Os Γ) : ∀ y ∈ O, ∀ z ∈ O, ∃ g ∈ Γ, g y = z := by
  obtain ⟨x, rfl⟩ := mem_Os.mp hO; exact orb_tr Γ x

theorem Os_disj {O O' : Finset V} (hO : O ∈ Os Γ) (hO' : O' ∈ Os Γ) (h : O ≠ O') :
    Disjoint O O' := by
  obtain ⟨x, rfl⟩ := mem_Os.mp hO; obtain ⟨y, rfl⟩ := mem_Os.mp hO'; exact orb_disj Γ h

theorem Os_ne {O : Finset V} (hO : O ∈ Os Γ) : O.Nonempty := by
  obtain ⟨x, rfl⟩ := mem_Os.mp hO; exact ⟨x, Upper.self_mem_orb Γ x⟩

/-- The orbits of one outside prime. -/
theorem Orr_mem {r : ℕ} {O : Finset V} (hO : O ∈ Orr Γ p r) :
    O ∈ Os Γ ∧ (cb Γ O).Prime ∧ cb Γ O ≠ p ∧ cb Γ O = r := by
  simp only [Orr, Oo, mem_filter, Out] at hO
  exact ⟨hO.1.1, hO.1.2.1, hO.1.2.2, hO.2⟩

theorem Rs_Orr {r : ℕ} (hr : r ∈ Rs Γ p) : (Orr Γ p r).Nonempty := by
  obtain ⟨O, hO, rfl⟩ := mem_image.mp hr
  exact ⟨O, mem_filter.mpr ⟨hO, rfl⟩⟩

theorem Fb_le_Fr {r : ℕ} {O : Finset V} (hO : O ∈ Orr Γ p r) : Fb Γ O ≤ Fr Γ p r :=
  single_le_sum (fun _ _ => Nat.zero_le _) hO

variable (hfp : ∀ x, ∃ g ∈ Γ, g x ≠ x)
include hfp

theorem Os_two {O : Finset V} (hO : O ∈ Os Γ) : 2 ≤ O.card := by
  obtain ⟨x, rfl⟩ := mem_Os.mp hO; exact orb_two Γ hfp x

theorem blk_spec {O : Finset V} (hO : O ∈ Os Γ) : LeastB Γ O (blk Γ O) := by
  obtain ⟨B, h1, h2, h3, h4⟩ := exists_least_block (Os_inv hO) (Os_two hfp hO)
  exact Classical.epsilon_spec (p := LeastB Γ O) ⟨B, h1, h2, h3, h4⟩

theorem cb_two {O : Finset V} (hO : O ∈ Os Γ) : 2 ≤ cb Γ O := (blk_spec hfp hO).2.2.1

theorem card_eq_Fb {O : Finset V} (hO : O ∈ Os Γ) : O.card = Fb Γ O * cb Γ O := by
  obtain ⟨h1, h2, h3, -⟩ := blk_spec hfp hO
  exact blockSys_card (Os_inv hO) (Os_tr hO) h1 (card_pos.mp (by omega)) h2

theorem Fb_pos {O : Finset V} (hO : O ∈ Os Γ) : 1 ≤ Fb Γ O := by
  have h1 := card_eq_Fb hfp hO
  have h2 := Os_two hfp hO
  rcases Nat.eq_zero_or_pos (Fb Γ O) with h | h
  · rw [h, zero_mul] at h1; omega
  · exact h

theorem Om_pow (HH : HypHuppert) (C : OliverChain Γ p q) (hp : p.Prime) (hq : q.Prime)
    {O : Finset V} (hO : O ∈ Om Γ p) : ∃ k, 1 ≤ k ∧ cb Γ O = p ^ k := by
  obtain ⟨hOs, hno⟩ := mem_filter.mp hO
  obtain ⟨h1, h2, h3, h4⟩ := blk_spec hfp hOs
  rcases block_kind HH C hp hq (Os_tr hOs) h1 h2 h3 h4 with h | h
  · exact h
  · exact absurd h hno

theorem card_Ur {r : ℕ} : (Ur Γ p r).card = Fr Γ p r * r := by
  unfold Ur Fr
  have := card_biUnion (s := Orr Γ p r) (t := id)
    (fun O hO O' hO' hne => Os_disj (Orr_mem hO).1 (Orr_mem hO').1 hne)
  rw [this, sum_mul]
  refine sum_congr rfl (fun O hO => ?_)
  simp only [id]; rw [card_eq_Fb hfp (Orr_mem hO).1, (Orr_mem hO).2.2.2]

end props

/-! ## The realisation, admissibility, and the size -/

section assembly
open Classical
variable {Γ : Subgroup (Equiv.Perm V)} {p q : ℕ}
variable (hfp : ∀ x, ∃ g ∈ Γ, g x ≠ x) (C : OliverChain Γ p q) (hp : p.Prime) (hq : q.Prime)
include hfp C hp hq

theorem Fr_pos {r : ℕ} (hr : r ∈ Rs Γ p) : 1 ≤ Fr Γ p r := by
  obtain ⟨O, hO⟩ := Rs_Orr hr
  exact le_trans (Fb_pos hfp (Orr_mem hO).1) (Fb_le_Fr hO)

theorem tq_spec {r : ℕ} (hr : r ∈ Rs Γ p) (h1 : Fr Γ p r = 1) :
    (∃ f, tq Γ q r = q ^ f) ∧ tq Γ q r ∣ r - 1 ∧ OrbLe Γ (orb r (tq Γ q r) false) := by
  obtain ⟨O, hO⟩ := Rs_Orr hr
  obtain ⟨hOs, hrpr, hrp, hcr⟩ := Orr_mem hO
  have hF1 : Fb Γ O = 1 := le_antisymm (h1 ▸ Fb_le_Fr hO) (Fb_pos hfp hOs)
  have hcard : O.card = r := by rw [card_eq_Fb hfp hOs, hF1, one_mul, hcr]
  have : Fact r.Prime := ⟨hcr ▸ hrpr⟩
  obtain ⟨f, hf, hle⟩ := fr_orbit Γ C hp hq O (Os_inv hOs) (Os_tr hOs) hcard (hcr ▸ hrp)
  exact Classical.epsilon_spec (p := fun t => (∃ f, t = q ^ f) ∧ t ∣ r - 1 ∧
    OrbLe Γ (orb r t false)) ⟨q ^ f, ⟨f, rfl⟩, hf, hle⟩

/-- The terms of an outside part bound orbitals. -/
theorem partOf_terms {r : ℕ} (hr : r ∈ Rs Γ p) :
    ∀ y ∈ (partOf Γ p q r).safeTerms, OrbLe Γ y := by
  obtain ⟨O, hO⟩ := Rs_Orr hr
  obtain ⟨hOs, hrpr, hrp, hcr⟩ := Orr_mem hO
  have : Fact r.Prime := ⟨hcr ▸ hrpr⟩
  have hrp' : r ≠ p := hcr ▸ hrp
  have hpos := Fr_pos hfp C hp hq hr
  unfold partOf
  split
  · rename_i h1
    intro y hy
    simp only [CPart.safeTerms, List.mem_singleton] at hy
    subst hy; exact (tq_spec hfp C hp hq hr h1).2.2
  · rename_i h1
    have hF2 : 2 ≤ Fr Γ p r := by omega
    intro y hy
    simp only [CPart.safeTerms, List.mem_cons] at hy
    rcases hy with rfl | hy
    · -- F·C(r,2): from the blocks of one orbit
      obtain ⟨hB1, hB2, hB3, -⟩ := blk_spec hfp hOs
      have := blocks_orbLe (Γ := Γ) (B := blockSys Γ (blk Γ O)) (b := r)
        (fun X hX => (blockSys_size hX).trans hcr) (hcr ▸ hB3) (blockSys_nonempty _) blockSys_inv
      refine this.mono ?_
      rw [show r.choose 2 = pairs r by unfold pairs; rw [Nat.choose_two_right]]
      exact Nat.mul_le_mul_right _ (Fb_le_Fr hO)
    · -- the same-position term, when F < r
      unfold d2term at hy
      split at hy
      · rename_i hFr
        simp only [List.mem_singleton] at hy
        subst hy
        by_cases hfus : ∃ O' ∈ Orr Γ p r, 2 ≤ Fb Γ O'
        · obtain ⟨O', hO', hF'⟩ := hfus
          obtain ⟨hO's, -, -, hc'⟩ := Orr_mem hO'
          obtain ⟨hB1, hB2, -, -⟩ := blk_spec hfp hO's
          have hlt : Fb Γ O' < r := lt_of_le_of_lt (Fb_le_Fr hO') hFr
          have key := fused_orbit Γ C hp hq hrp' O' (Os_inv hO's) (Os_tr hO's) hB1 hB2 hc' hF' 1
            (max (pairs (Fb Γ O') * r) (Fb Γ O' * r)) (by
              simp only [CPart.safeTerms, d2term, Fb] at hlt ⊢
              simp [hlt])
          refine key.mono (max_le_max ?_ ?_)
          · have : pairs (Fb Γ O') ≤ pairs (Fr Γ p r) := by
              unfold pairs
              exact Nat.div_le_div_right (Nat.mul_le_mul (Fb_le_Fr hO') (Nat.sub_le_sub_right (Fb_le_Fr hO') 1))
            exact Nat.mul_le_mul_right _ this
          · exact Nat.mul_le_mul_right _ (Fb_le_Fr hO')
        · push Not at hfus
          -- every orbit is one block, so there are F ≥ 2 orbits
          have hall : ∀ O' ∈ Orr Γ p r, Fb Γ O' = 1 := fun O' hO' =>
            le_antisymm (by have := hfus O' hO'; omega) (Fb_pos hfp (Orr_mem hO').1)
          have hcardO : (Orr Γ p r).card = Fr Γ p r := by
            unfold Fr; rw [sum_congr rfl hall]; simp
          obtain ⟨O₁, h₁, O₂, h₂, h12⟩ := Finset.one_lt_card.mp (by omega : 1 < (Orr Γ p r).card)
          obtain ⟨h₁s, -, -, hc₁⟩ := Orr_mem h₁
          obtain ⟨h₂s, -, -, hc₂⟩ := Orr_mem h₂
          have hO₁ : O₁.card = r := by rw [card_eq_Fb hfp h₁s, hall O₁ h₁, one_mul, hc₁]
          have hO₂ : O₂.card = r := by rw [card_eq_Fb hfp h₂s, hall O₂ h₂, one_mul, hc₂]
          by_cases hrq : r = q
          · -- r = q: the lone orbit's orbital is ≤ orb(q, 1) ≤ q
            obtain ⟨f, hf, hle⟩ := fr_orbit Γ C hp hq O₁ (Os_inv h₁s) (Os_tr h₁s) hO₁ (hcr ▸ hrp)
            have hf0 : f = 0 := by
              by_contra hf0
              have h1 : q ∣ r - 1 := (dvd_pow_self q hf0).trans hf
              rw [hrq] at h1
              have := Nat.le_of_dvd (by have := hq.one_lt; omega) h1
              have := hq.one_lt; omega
            subst hf0
            have ho : orb r (q ^ 0) false ≤ r := by unfold orb; simp
            refine (OrbLe.mono hle (le_trans ho ?_))
            refine le_trans ?_ (le_max_right _ _)
            nlinarith
          · have := two_orbits Γ C hp hq (hcr ▸ hrp) hrq O₁ O₂ (Os_inv h₁s) (Os_inv h₂s)
              (Os_tr h₁s) (Os_tr h₂s) hO₁ hO₂ (Os_disj h₁s h₂s h12)
            refine this.mono (le_trans ?_ (le_max_right _ _))
            nlinarith
      · simp at hy

theorem mem_RL {a : CPart × Finset V} (ha : a ∈ RL Γ p q) :
    (∃ O ∈ Om Γ p, a = (.pc (Fb Γ O) (cb Γ O) (cb Γ O - 1), O)) ∨
    (∃ r ∈ Rs Γ p, a = (partOf Γ p q r, Ur Γ p r)) := by
  simp only [RL, List.mem_append, List.mem_map, mem_toList] at ha
  rcases ha with ⟨O, hO, rfl⟩ | ⟨r, hr, rfl⟩
  · exact Or.inl ⟨O, hO, rfl⟩
  · exact Or.inr ⟨r, hr, rfl⟩

theorem Ur_sub {r : ℕ} {O : Finset V} (hO : O ∈ Orr Γ p r) : O ⊆ Ur Γ p r :=
  fun _ hx => mem_biUnion.mpr ⟨O, hO, hx⟩

theorem Om_os {O : Finset V} (hO : O ∈ Om Γ p) : O ∈ Os Γ := (mem_filter.mp hO).1

/-- **Γ realises the configuration read off it.** -/
noncomputable def realisation : Realisation Γ (cfg Γ p q) where
  R := RL Γ p q
  parts := rfl
  card := by
    intro a ha
    rcases mem_RL hfp C hp hq ha with ⟨O, hO, rfl⟩ | ⟨r, hr, rfl⟩
    · simp only [CPart.sizeC]; exact card_eq_Fb hfp (Om_os hfp C hp hq hO)
    · simp only [partOf]
      rw [card_Ur hfp]
      split
      · rename_i h; simp [CPart.sizeC, h]
      · simp [CPart.sizeC]
  ne := by
    intro a ha
    rcases mem_RL hfp C hp hq ha with ⟨O, hO, rfl⟩ | ⟨r, hr, rfl⟩
    · exact Os_ne (Om_os hfp C hp hq hO)
    · obtain ⟨O, hO⟩ := Rs_Orr hr
      exact (Os_ne (Orr_mem hO).1).mono (Ur_sub hfp C hp hq hO)
  inv := by
    intro a ha g hg x hx
    rcases mem_RL hfp C hp hq ha with ⟨O, hO, rfl⟩ | ⟨r, hr, rfl⟩
    · exact Os_inv (Om_os hfp C hp hq hO) g hg x hx
    · obtain ⟨O, hO, hxO⟩ := mem_biUnion.mp hx
      exact Ur_sub hfp C hp hq hO (Os_inv (Orr_mem hO).1 g hg x hxO)
  disj := by
    unfold RL
    rw [List.pairwise_append, List.pairwise_map, List.pairwise_map]
    refine ⟨?_, ?_, ?_⟩
    · exact (nodup_toList _).pairwise_of_forall_ne (fun O hO O' hO' hne =>
        Os_disj (Om_os hfp C hp hq (mem_toList.mp hO)) (Om_os hfp C hp hq (mem_toList.mp hO')) hne)
    · refine (nodup_toList _).pairwise_of_forall_ne (fun r _ r' _ hne => ?_)
      simp only [Ur]
      rw [disjoint_biUnion_left]; intro O hO
      rw [disjoint_biUnion_right]; intro O' hO'
      apply Os_disj (Orr_mem hO).1 (Orr_mem hO').1
      rintro rfl; exact hne ((Orr_mem hO).2.2.2.symm.trans (Orr_mem hO').2.2.2)
    · intro a ha b hb
      simp only [List.mem_map, mem_toList] at ha hb
      obtain ⟨O, hO, rfl⟩ := ha
      obtain ⟨r, hr, rfl⟩ := hb
      simp only [Ur]
      rw [disjoint_biUnion_right]; intro O' hO'
      apply Os_disj (Om_os hfp C hp hq hO) (Orr_mem hO').1
      rintro rfl
      obtain ⟨-, hno⟩ := mem_filter.mp hO
      obtain ⟨-, h1, h2, -⟩ := Orr_mem hO'
      exact hno ⟨h1, h2⟩
  terms := by
    intro a ha
    rcases mem_RL hfp C hp hq ha with ⟨O, hO, rfl⟩ | ⟨r, hr, rfl⟩
    · have hOs := Om_os hfp C hp hq hO
      exact pc_terms (fun X hX => blockSys_size hX) (cb_two hfp hOs) (blockSys_nonempty _)
        blockSys_inv
    · exact partOf_terms hfp C hp hq hr

end assembly


/-! ## Admissibility, the size, and Part 0 -/

section final
open Classical
variable {Γ : Subgroup (Equiv.Perm V)} {p q : ℕ}
variable (hfp : ∀ x, ∃ g ∈ Γ, g x ≠ x) (C : OliverChain Γ p q) (hp : p.Prime) (hq : q.Prime)
include hfp C hp hq

theorem cfg_foreign : (cfg Γ p q).foreign = (Rs Γ p).toList := by
  set f : CPart → Option ℕ := fun x => match x with
    | .fr r _ => some r | .fo _ r _ => some r | .pc _ _ _ => none with hf
  have hpart : ∀ r, f (partOf Γ p q r) = some r := by
    intro r; by_cases h : Fr Γ p r = 1 <;> simp [hf, partOf, h]
  show ((RL Γ p q).map Prod.fst).filterMap f = _
  simp only [RL, List.map_append, List.map_map, List.filterMap_append, List.filterMap_map]
  have h1 : List.filterMap (f ∘ Prod.fst ∘ fun O => ((CPart.pc (Fb Γ O) (cb Γ O) (cb Γ O - 1)), O))
      (Om Γ p).toList = [] := by
    rw [List.filterMap_eq_nil_iff]; intro a _; rfl
  have h2 : List.filterMap (f ∘ Prod.fst ∘ fun r => (partOf Γ p q r, Ur Γ p r)) (Rs Γ p).toList =
      (Rs Γ p).toList := by
    rw [show (f ∘ Prod.fst ∘ fun r => (partOf Γ p q r, Ur Γ p r)) = some from
      funext (fun r => hpart r)]
    exact List.filterMap_some
  rw [h1, h2, List.nil_append]

theorem cfg_GAdm (HH : HypHuppert) : GAdm (cfg Γ p q) := by
  refine ⟨hp, hq, ?_, ?_⟩
  · intro x hx
    simp only [cfg, List.mem_map] at hx
    obtain ⟨a, ha, rfl⟩ := hx
    rcases mem_RL hfp C hp hq ha with ⟨O, hO, rfl⟩ | ⟨r, hr, rfl⟩
    · have hOs := Om_os hfp C hp hq hO
      obtain ⟨k, hk, hck⟩ := Om_pow hfp HH C hp hq hO
      exact ⟨Fb_pos hfp hOs, ⟨k, hk, hck⟩, dvd_refl _⟩
    · obtain ⟨O, hO⟩ := Rs_Orr hr
      obtain ⟨-, hrpr, hrp, hcr⟩ := Orr_mem hO
      rw [hcr] at hrpr hrp
      simp only [partOf]
      split
      · rename_i h1
        obtain ⟨⟨f, hf⟩, hd, -⟩ := tq_spec hfp C hp hq hr h1
        exact ⟨hrpr, hrp, hd, f, hf⟩
      · rename_i h1
        have := Fr_pos hfp C hp hq hr
        exact ⟨by omega, hrpr, hrp, one_dvd _, 0, by simp⟩
  · rw [cfg_foreign hfp C hp hq]; exact nodup_toList _

theorem cfg_n : (cfg Γ p q).n = Fintype.card V := by
  have hsz : (cfg Γ p q).n = ∑ O ∈ Om Γ p, O.card + ∑ r ∈ Rs Γ p, (Ur Γ p r).card := by
    have hs := fun a (ha : a ∈ RL Γ p q) => (realisation hfp C hp hq).card a ha
    simp only [Config.n, Config.sizes, cfg, List.map_map]
    rw [List.map_congr_left (l := RL Γ p q) (f := CPart.sizeC ∘ Prod.fst)
      (g := fun a : CPart × Finset V => a.2.card) (fun a ha => (hs a ha).symm)]
    simp only [RL, List.map_append, List.map_map, List.sum_append, Function.comp_apply,
      sum_map_toList]
  -- the outside orbits, grouped by prime
  have hUr : ∑ r ∈ Rs Γ p, (Ur Γ p r).card = ∑ O ∈ Oo Γ p, O.card := by
    rw [← sum_fiberwise_of_maps_to (g := cb Γ) (t := Rs Γ p) (fun O hO => mem_image_of_mem _ hO)]
    refine sum_congr rfl (fun r _ => ?_)
    unfold Ur
    have := card_biUnion (s := Orr Γ p r) (t := id)
      (fun O hO O' hO' hne => Os_disj (Orr_mem hO).1 (Orr_mem hO').1 hne)
    rw [this]; rfl
  rw [hsz, hUr]
  unfold Om Oo
  rw [add_comm, sum_filter_add_sum_filter_not]
  -- the orbits tile V
  have hcov : (Os Γ).biUnion id = univ := by
    ext x; simp only [mem_biUnion, mem_univ, iff_true, id]
    exact ⟨_, mem_Os.mpr ⟨x, rfl⟩, Upper.self_mem_orb Γ x⟩
  have := card_biUnion (s := Os Γ) (t := id) (fun O hO O' hO' hne => Os_disj hO hO' hne)
  rw [hcov, card_univ] at this
  rw [this]; rfl

end final

/-- **Part 0: μ\* ≤ B_safe, given `HypHuppert`.**  An Oliver group Γ on n ≥ 2 points either has a
fixed point, and then an orbital of at most n − 1 pairs, or some admissible configuration on n
points has SAFE at least one of Γ's orbitals. -/
theorem part0 (HH : HypHuppert) (Γ : Subgroup (Equiv.Perm V)) {p q : ℕ} (C : OliverChain Γ p q)
    (hp : p.Prime) (hq : q.Prime) (hn : 2 ≤ Fintype.card V) :
    OrbLe Γ (Fintype.card V - 1) ∨
      ∃ Cf : Config, GAdm Cf ∧ Cf.n = Fintype.card V ∧ OrbLe Γ Cf.safe := by
  classical
  by_cases hfix : ∃ x, ∀ g ∈ Γ, g x = x
  · obtain ⟨x, hx⟩ := hfix
    exact Or.inl (fixed_orbLe hx hn)
  push Not at hfix
  right
  refine ⟨cfg Γ p q, cfg_GAdm hfix C hp hq HH, cfg_n hfix C hp hq,
    orbLe_safe (realisation hfix C hp hq) ?_⟩
  -- some part exists, since V is nonempty
  obtain ⟨x⟩ : Nonempty V := Fintype.card_pos_iff.mp (by omega)
  have hO : Upper.orb Γ x ∈ Os Γ := mem_Os.mpr ⟨x, rfl⟩
  intro h
  have hRL : RL Γ p q = [] := List.map_eq_nil_iff.mp h
  simp only [RL, List.append_eq_nil_iff, List.map_eq_nil_iff, toList_eq_nil] at hRL
  by_cases hout : Out Γ p (Upper.orb Γ x)
  · have : cb Γ (Upper.orb Γ x) ∈ Rs Γ p := mem_image_of_mem _ (mem_filter.mpr ⟨hO, hout⟩)
    rw [hRL.2] at this; simp at this
  · have : Upper.orb Γ x ∈ Om Γ p := mem_filter.mpr ⟨hO, hout⟩
    rw [hRL.1] at this; simp at this

/-- **Part 0 against B_safe.**  If B_safe(n) = B, every Oliver group on n ≥ 2 points has an orbital
of at most max(B, n − 1) pairs — at most B unless it has a fixed point.  This is the hypothesis
`hcap : μ ≤ B` of `E6.e6`, for μ the least orbital of any Oliver group, wherever B ≥ n − 1. -/
theorem part0_Bsafe (HH : HypHuppert) (Γ : Subgroup (Equiv.Perm V)) {p q : ℕ}
    (C : OliverChain Γ p q) (hp : p.Prime) (hq : q.Prime) (hn : 2 ≤ Fintype.card V) {B : ℕ}
    (hB : IsBsafe (Fintype.card V) B) : OrbLe Γ (max B (Fintype.card V - 1)) := by
  rcases part0 HH Γ C hp hq hn with h | ⟨Cf, hCf, hn', hle⟩
  · exact h.mono (le_max_right _ _)
  · exact (hle.mono (hB.2 Cf hCf hn')).mono (le_max_left _ _)

end Part0Main

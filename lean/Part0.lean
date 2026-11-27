/-
# `Part0.lean` — toward μ\* ≤ B_safe (`enumeration-proof.md` Part 0 and Part A)

The inequality μ\*(n) ≤ B_safe(n) says: every Oliver group Γ on n points has an orbital no larger
than the SAFE score of some admissible configuration (`Part0Mu.muStar_le`).  This file
builds it in two layers.

* **Part A, the assembly (this file, so far).**  A *realisation* of a configuration C by Γ assigns
  to each part a Γ-invariant point set of the part's size, the sets pairwise disjoint, such that
  each of the part's own SAFE terms is at least some orbital of Γ.  Then the cross terms come for
  free — a pair between two parts has its orbital inside the product of the two sets
  (`cross_orbLe`) — and some orbital of Γ is at most SAFE(C) (`orbLe_safe`).
* **Per-part bounds (to come).**  The flat cap F·C(c,2) for a class, orb(r, t) for a foreign block
  (Lemma B for prime blocks), the D2 terms (`FoBridge`), and the orbit decomposition that produces
  the parts.
-/
import E6
import D2

set_option linter.unusedSectionVars false

namespace Part0
open Finset E6 ArkCore

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- Some orbital of Γ (on a non-diagonal pair) has at most X pairs. -/
def OrbLe (Γ : Subgroup (Equiv.Perm V)) (X : ℕ) : Prop :=
  ∃ e : Sym2 V, ¬ e.IsDiag ∧ (D2.orbit2 Γ e).card ≤ X

theorem OrbLe.mono {Γ : Subgroup (Equiv.Perm V)} {X Y : ℕ} (h : OrbLe Γ X) (hXY : X ≤ Y) :
    OrbLe Γ Y := let ⟨e, he, hc⟩ := h; ⟨e, he, hc.trans hXY⟩

/-! ## The minimum of a list is one of its elements -/

theorem foldr_min_mem (s : ℕ) : ∀ l : List ℕ, l.foldr min s ∈ s :: l
  | [] => by simp
  | a :: l => by
    simp only [List.foldr_cons]
    rcases min_choice a (l.foldr min s) with h | h <;> rw [h]
    · simp
    · have := foldr_min_mem s l
      simp only [List.mem_cons] at this ⊢
      tauto

theorem foldr_min_le (s : ℕ) : ∀ l : List ℕ, ∀ x ∈ l, l.foldr min s ≤ x
  | [], x, h => by simp at h
  | a :: l, x, h => by
    simp only [List.foldr_cons, List.mem_cons] at h ⊢
    rcases h with rfl | h
    · exact min_le_left _ _
    · exact le_trans (min_le_right _ _) (foldr_min_le s l x h)

theorem minL_mem {l : List ℕ} (hl : l ≠ []) : minL l ∈ l := by
  have h := foldr_min_mem l.sum l
  unfold minL
  rcases List.mem_cons.mp h with h | h
  · obtain ⟨x, hx⟩ := List.exists_mem_of_ne_nil _ hl
    have h1 := foldr_min_le l.sum l x hx
    have h2 : x ≤ l.sum := List.le_sum_of_mem hx
    rw [h] at h1 ⊢
    have : x = l.sum := le_antisymm h2 h1
    rw [← this]; exact hx
  · exact h

/-! ## Cross terms -/

/-- The pairs between two point sets. -/
noncomputable def between (A B : Finset V) : Finset (Sym2 V) := (A ×ˢ B).image (fun x : V × V => s(x.1, x.2))

theorem card_between (A B : Finset V) : (between A B).card ≤ A.card * B.card := by
  unfold between; rw [← card_product]; exact card_image_le

/-- **A pair between two disjoint nonempty Γ-invariant sets has an orbital of at most |A|·|B|.** -/
theorem cross_orbLe {Γ : Subgroup (Equiv.Perm V)} {A B : Finset V}
    (hA : ∀ g ∈ Γ, ∀ x ∈ A, g x ∈ A) (hB : ∀ g ∈ Γ, ∀ x ∈ B, g x ∈ B)
    (hAB : Disjoint A B) (hAne : A.Nonempty) (hBne : B.Nonempty) :
    OrbLe Γ (A.card * B.card) := by
  obtain ⟨u, hu⟩ := hAne
  obtain ⟨v, hv⟩ := hBne
  have huv : u ≠ v := fun h => disjoint_left.mp hAB hu (h ▸ hv)
  refine ⟨s(u, v), by simp [huv], le_trans (D2.orbit2_card_le Γ (between A B) ?_ ?_) (card_between A B)⟩
  · intro g hg e he
    unfold between at he
    obtain ⟨⟨a, b⟩, hab, rfl⟩ := mem_image.mp he
    obtain ⟨ha, hb⟩ := mem_product.mp hab
    unfold between
    exact mem_image.mpr ⟨(g a, g b), mem_product.mpr ⟨hA g hg a ha, hB g hg b hb⟩, rfl⟩
  · unfold between
    exact mem_image.mpr ⟨(u, v), mem_product.mpr ⟨hu, hv⟩, rfl⟩

/-! ## Realisations and the assembly -/

/-- **A realisation of a configuration by Γ**: the parts, each with a point set. -/
structure Realisation (Γ : Subgroup (Equiv.Perm V)) (C : Config) where
  R : List (CPart × Finset V)
  parts : R.map Prod.fst = C.parts
  card : ∀ a ∈ R, a.2.card = a.1.sizeC
  ne : ∀ a ∈ R, a.2.Nonempty
  inv : ∀ a ∈ R, ∀ g ∈ Γ, ∀ x ∈ a.2, g x ∈ a.2
  disj : R.Pairwise (fun a b => Disjoint a.2 b.2)
  terms : ∀ a ∈ R, ∀ y ∈ a.1.safeTerms, OrbLe Γ y

/-- Every between-parts term comes from two entries at distinct positions. -/
theorem mem_crossN {α : Type*} (f : α → ℕ) : ∀ {R : List α} {x : ℕ}, x ∈ crossN (R.map f) →
    ∃ a b, [a, b].Sublist R ∧ x = f a * f b
  | [], _, h => by simp [crossN] at h
  | a :: R, x, h => by
    simp only [List.map_cons, crossN, List.mem_append, List.mem_map] at h
    rcases h with ⟨y, hy, rfl⟩ | h
    · obtain ⟨b, hb, rfl⟩ := hy
      exact ⟨a, b, List.cons_sublist_cons.mpr (List.singleton_sublist.mpr hb), rfl⟩
    · obtain ⟨a', b, hs, rfl⟩ := mem_crossN f h
      exact ⟨a', b, hs.cons a, rfl⟩

/-- **Part A.**  If Γ realises C, some orbital of Γ has at most SAFE(C) pairs. -/
theorem orbLe_safe {Γ : Subgroup (Equiv.Perm V)} {C : Config} (W : Realisation Γ C)
    (hne : C.parts ≠ []) : OrbLe Γ C.safe := by
  set L := C.parts.flatMap CPart.safeTerms ++ crossN C.sizes
  have hL : L ≠ [] := by
    obtain ⟨x, hx⟩ := List.exists_mem_of_ne_nil _ hne
    obtain ⟨y, hy⟩ : ∃ y, y ∈ x.safeTerms := by
      cases x <;> simp [CPart.safeTerms, E5Assembly.Part.terms]
    intro h
    have : y ∈ L := List.mem_append_left _ (List.mem_flatMap.mpr ⟨x, hx, hy⟩)
    rw [h] at this; simp at this
  have hmem := minL_mem hL
  show OrbLe Γ (minL L)
  rcases List.mem_append.mp hmem with h | h
  · obtain ⟨x, hx, hy⟩ := List.mem_flatMap.mp h
    rw [← W.parts] at hx
    obtain ⟨a, ha, rfl⟩ := List.mem_map.mp hx
    exact W.terms a ha _ hy
  · have hs : C.sizes = W.R.map (fun a => a.1.sizeC) := by
      rw [Config.sizes, ← W.parts, List.map_map]; rfl
    rw [hs] at h
    obtain ⟨a, b, hsub, he⟩ := mem_crossN (fun a : CPart × Finset V => a.1.sizeC) h
    rw [he]
    have ha : a ∈ W.R := hsub.subset (by simp)
    have hb : b ∈ W.R := hsub.subset (by simp)
    have hd : Disjoint a.2 b.2 := by
      have := W.disj.sublist hsub
      simpa using this
    have := cross_orbLe (W.inv a ha) (W.inv b hb) hd (W.ne a ha) (W.ne b hb)
    rwa [W.card a ha, W.card b hb] at this

/-! ## Per-part bounds: a class (the flat cap) -/

/-- The pairs inside the blocks of a block family. -/
noncomputable def within (B : Finset (Finset V)) : Finset (Sym2 V) :=
  B.biUnion (fun X => X.offDiag.image (fun x : V × V => s(x.1, x.2)))

/-- **Blocks give an orbital of at most (#blocks)·C(b,2).**  For a family of blocks of one size
b ≥ 2 permuted by Γ, the pairs inside blocks are Γ-invariant. -/
theorem blocks_orbLe {Γ : Subgroup (Equiv.Perm V)} {B : Finset (Finset V)} {b : ℕ}
    (hsize : ∀ X ∈ B, X.card = b) (hb : 2 ≤ b) (hne : B.Nonempty)
    (hinv : ∀ g ∈ Γ, ∀ X ∈ B, X.image g ∈ B) :
    OrbLe Γ (B.card * b.choose 2) := by
  obtain ⟨X, hX⟩ := hne
  have : 1 < X.card := by rw [hsize X hX]; omega
  obtain ⟨u, hu, v, hv, huv⟩ := Finset.one_lt_card.mp this
  have hmem : ∀ {Y : Finset V}, Y ∈ B → ∀ {a c : V}, a ∈ Y → c ∈ Y → a ≠ c → s(a, c) ∈ within B :=
    fun hY _ _ ha hc hac =>
      mem_biUnion.mpr ⟨_, hY, mem_image.mpr ⟨(_, _), mem_offDiag.mpr ⟨ha, hc, hac⟩, rfl⟩⟩
  refine ⟨s(u, v), by simp [huv], le_trans (D2.orbit2_card_le Γ (within B) ?_ (hmem hX hu hv huv)) ?_⟩
  · intro g hg e he
    obtain ⟨Y, hY, he'⟩ := mem_biUnion.mp he
    obtain ⟨⟨a, c⟩, hac, rfl⟩ := mem_image.mp he'
    obtain ⟨ha, hc, hne'⟩ := mem_offDiag.mp hac
    exact hmem (hinv g hg Y hY) (mem_image_of_mem _ ha) (mem_image_of_mem _ hc)
      (fun h => hne' (g.injective h))
  · unfold within
    refine le_trans card_biUnion_le ?_
    rw [sum_congr rfl (fun Y hY => by
      rw [← hsize Y hY, ← Sym2.card_image_offDiag]; rfl : ∀ Y ∈ B,
        (Y.offDiag.image (fun x : V × V => s(x.1, x.2))).card = b.choose 2), sum_const, smul_eq_mul]

/-- **A class's SAFE terms are each at least an orbital**: F·C(c,2) by the blocks, and the
within-class cross term (F or F/2)·c² ≥ F·C(c,2). -/
theorem pc_terms {Γ : Subgroup (Equiv.Perm V)} {B : Finset (Finset V)} {c d : ℕ}
    (hsize : ∀ X ∈ B, X.card = c) (hc : 2 ≤ c) (hne : B.Nonempty)
    (hinv : ∀ g ∈ Γ, ∀ X ∈ B, X.image g ∈ B) :
    ∀ y ∈ (CPart.pc B.card c d).safeTerms, OrbLe Γ y := by
  have h0 := blocks_orbLe hsize hc hne hinv
  rw [show c.choose 2 = pairs c by unfold pairs; rw [Nat.choose_two_right]] at h0
  intro y hy
  simp only [CPart.safeTerms, E5Assembly.Part.terms, List.mem_cons] at hy
  rcases hy with rfl | hy
  · exact h0
  · split at hy
    · simp only [List.mem_singleton] at hy
      subst hy
      refine h0.mono ?_
      have hp : 2 * pairs c ≤ c * c := by
        have := two_pairs c
        have : c * (c - 1) ≤ c * c := Nat.mul_le_mul_left _ (Nat.sub_le _ _)
        omega
      split
      · calc B.card * pairs c ≤ B.card * (c * c) := Nat.mul_le_mul_left _ (by omega)
          _ = B.card * c * c := by ring
      · rename_i h2 hodd
        have : B.card % 2 = 0 := by omega
        obtain ⟨k, hk⟩ : ∃ k, B.card = 2 * k := ⟨B.card / 2, by omega⟩
        rw [hk, show 2 * k / 2 = k by omega]
        calc 2 * k * pairs c = k * (2 * pairs c) := by ring
          _ ≤ k * (c * c) := Nat.mul_le_mul_left _ hp
          _ = k * c * c := by ring
    · simp at hy

/-! ## The fixed-point case -/

/-- **A fixed point gives an orbital of at most n − 1** (Part A: "parts of size 1 … contribute a
cross bound"). -/
theorem fixed_orbLe {Γ : Subgroup (Equiv.Perm V)} {x : V} (hx : ∀ g ∈ Γ, g x = x)
    (hn : 2 ≤ Fintype.card V) : OrbLe Γ (Fintype.card V - 1) := by
  obtain ⟨y, hy⟩ : ∃ y, y ≠ x := by
    obtain ⟨a, b, hab⟩ := Fintype.exists_pair_of_one_lt_card (α := V) (by omega)
    by_cases ha : a = x
    · exact ⟨b, fun h => hab (ha.trans h.symm)⟩
    · exact ⟨a, ha⟩
  have hS : ∀ g ∈ Γ, ∀ e ∈ (univ.erase x).image (fun z => s(x, z)),
      Sym2.map g e ∈ (univ.erase x).image (fun z => s(x, z)) := by
    intro g hg e he
    obtain ⟨z, hz, rfl⟩ := mem_image.mp he
    refine mem_image.mpr ⟨g z, mem_erase.mpr ⟨?_, mem_univ _⟩, by simp [Sym2.map_mk, hx g hg]⟩
    intro h
    have : g z = g x := by rw [h, hx g hg]
    exact (mem_erase.mp hz).1 (g.injective this)
  refine ⟨s(x, y), by simp [Ne.symm hy], le_trans (D2.orbit2_card_le Γ _ hS
    (mem_image.mpr ⟨y, mem_erase.mpr ⟨hy, mem_univ _⟩, rfl⟩)) ?_⟩
  refine le_trans card_image_le ?_
  rw [card_erase_of_mem (mem_univ _), card_univ]

/-! ## Blocks: existence of a least nontrivial block, and its block system -/

/-- B is a block of Γ: each image is B or disjoint from it. -/
def IsBlk (Γ : Subgroup (Equiv.Perm V)) (B : Finset V) : Prop :=
  ∀ g ∈ Γ, B.image g = B ∨ Disjoint (B.image g) B

/-- **A least nontrivial block inside an invariant set.**  If S is Γ-invariant with |S| ≥ 2, there
is a block B ⊆ S with |B| ≥ 2 and no block B' ⊆ S with 2 ≤ |B'| < |B|. -/
theorem exists_least_block {Γ : Subgroup (Equiv.Perm V)} {S : Finset V}
    (hS : ∀ g ∈ Γ, ∀ x ∈ S, g x ∈ S) (h2 : 2 ≤ S.card) :
    ∃ B ⊆ S, IsBlk Γ B ∧ 2 ≤ B.card ∧
      ∀ B' ⊆ S, IsBlk Γ B' → 2 ≤ B'.card → B.card ≤ B'.card := by
  classical
  have hSblk : IsBlk Γ S := by
    intro g hg
    left
    apply eq_of_subset_of_card_le
    · intro y hy
      obtain ⟨x, hx, rfl⟩ := mem_image.mp hy
      exact hS g hg x hx
    · rw [card_image_of_injective _ g.injective]
  have hex : ∃ k, ∃ B ⊆ S, IsBlk Γ B ∧ 2 ≤ B.card ∧ B.card = k := ⟨_, S, subset_refl _, hSblk, h2, rfl⟩
  obtain ⟨B, hBS, hB, hB2, hBk⟩ := Nat.find_spec hex
  refine ⟨B, hBS, hB, hB2, fun B' hB'S hB' hB'2 => ?_⟩
  rw [hBk]
  exact Nat.find_min' hex ⟨B', hB'S, hB', hB'2, rfl⟩

section blocksys
open Classical

/-- **The block system of a block**: its images under Γ. -/
noncomputable def blockSys (Γ : Subgroup (Equiv.Perm V)) (B : Finset V) : Finset (Finset V) :=
  ((univ : Finset (Equiv.Perm V)).filter (· ∈ Γ)).image (fun g : Equiv.Perm V => B.image g)

theorem blockSys_size {Γ : Subgroup (Equiv.Perm V)} {B X : Finset V} (hX : X ∈ blockSys Γ B) :
    X.card = B.card := by
  obtain ⟨g, -, rfl⟩ := mem_image.mp hX
  exact card_image_of_injective _ g.injective

theorem blockSys_inv {Γ : Subgroup (Equiv.Perm V)} {B : Finset V} :
    ∀ g ∈ Γ, ∀ X ∈ blockSys Γ B, X.image g ∈ blockSys Γ B := by
  intro g hg X hX
  obtain ⟨h, hh, rfl⟩ := mem_image.mp hX
  simp only [mem_filter, mem_univ, true_and] at hh
  refine mem_image.mpr ⟨g * h, by simp [Γ.mul_mem hg hh], ?_⟩
  rw [image_image]; rfl

theorem blockSys_nonempty {Γ : Subgroup (Equiv.Perm V)} (B : Finset V) :
    (blockSys Γ B).Nonempty :=
  ⟨B, mem_image.mpr ⟨1, by simp [Γ.one_mem], by simp⟩⟩

/-- The images of a block are equal or disjoint. -/
theorem blockSys_disj {Γ : Subgroup (Equiv.Perm V)} {B : Finset V} (hB : IsBlk Γ B)
    {X Y : Finset V} (hX : X ∈ blockSys Γ B) (hY : Y ∈ blockSys Γ B) (hXY : X ≠ Y) :
    Disjoint X Y := by
  obtain ⟨g, hg, rfl⟩ := mem_image.mp hX
  obtain ⟨h, hh, rfl⟩ := mem_image.mp hY
  simp only [mem_filter, mem_univ, true_and] at hg hh
  rcases hB (h⁻¹ * g) (Γ.mul_mem (Γ.inv_mem hh) hg) with he | hd
  · exfalso; apply hXY
    have : (B.image (h⁻¹ * g)).image h = B.image h := by rw [he]
    rw [image_image] at this
    convert this using 2
    ext x; simp
  · have := (Finset.disjoint_image (f := h) h.injective).mpr hd
    rw [image_image] at this
    convert this using 2
    ext x; simp

/-- **The block system tiles a transitive invariant set**: |S| = (#blocks)·|B|. -/
theorem blockSys_card {Γ : Subgroup (Equiv.Perm V)} {S B : Finset V}
    (hS : ∀ g ∈ Γ, ∀ x ∈ S, g x ∈ S) (htr : ∀ x ∈ S, ∀ y ∈ S, ∃ g ∈ Γ, g x = y)
    (hBS : B ⊆ S) (hBne : B.Nonempty) (hB : IsBlk Γ B) :
    S.card = (blockSys Γ B).card * B.card := by
  have hcov : (blockSys Γ B).biUnion id = S := by
    ext x
    simp only [mem_biUnion, id]
    constructor
    · rintro ⟨X, hX, hx⟩
      obtain ⟨g, hg, rfl⟩ := mem_image.mp hX
      simp only [mem_filter, mem_univ, true_and] at hg
      obtain ⟨y, hy, rfl⟩ := mem_image.mp hx
      exact hS g hg y (hBS hy)
    · intro hx
      obtain ⟨b, hb⟩ := hBne
      obtain ⟨g, hg, rfl⟩ := htr b (hBS hb) x hx
      exact ⟨B.image g, mem_image.mpr ⟨g, by simp [hg], rfl⟩, mem_image_of_mem _ hb⟩
  rw [← hcov]
  have := card_biUnion (s := blockSys Γ B) (t := id) (fun X hX Y hY hne => blockSys_disj hB hX hY hne)
  rw [this]; simp only [id]
  rw [sum_congr rfl (fun X hX => blockSys_size hX), sum_const, smul_eq_mul]

/-- **A class's SAFE terms from a least block** of an invariant set S with |S| ≥ 2: with
F = #(block system), every term of `pc F |B| d` bounds an orbital. -/
theorem pc_terms_of_set {Γ : Subgroup (Equiv.Perm V)} {S : Finset V}
    (hS : ∀ g ∈ Γ, ∀ x ∈ S, g x ∈ S) (h2 : 2 ≤ S.card) (d : ℕ) :
    ∃ B ⊆ S, IsBlk Γ B ∧ 2 ≤ B.card ∧
      ∀ y ∈ (CPart.pc (blockSys Γ B).card B.card d).safeTerms, OrbLe Γ y := by
  obtain ⟨B, hBS, hB, hB2, -⟩ := exists_least_block hS h2
  exact ⟨B, hBS, hB, hB2, pc_terms (fun X hX => blockSys_size hX) hB2 (blockSys_nonempty B)
    blockSys_inv⟩

end blocksys

end Part0

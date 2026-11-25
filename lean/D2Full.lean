/-
# `D2Full.lean` — Lemma D2 without assuming Lemma B (r ∉ {p, q})

`Rescale.d2_full` proves D2's C(F,2)·r bound assuming Lemma B's affine form.  This file
derives that form from the chain, using `LemmaB.lemmaB_block` on one block and transporting it
to the others:

* `OliverChain.comap` — a chain restricts to any subgroup.
* `Kstab`, `ρ` — the stabiliser of block 0 and its action on that block.
* `exists_affine_relabel` — Lemma B on every block (any r ≠ p, r = q allowed), giving new coordinates on O: block j is labelled through a fixed gⱼ ∈ G carrying block 0
  to block j, composed with Lemma B's labelling E of block 0.
* `affine_after_relabel` — in those coordinates every g ∈ G is affine block-to-block.
* **`d2_noB`** — Lemma D2's same-position bound from the chain, 2 ≤ F < r, r ∉ {p, q}, a block
  system preserved by G, and transitivity: **no Lemma B hypothesis.**
-/
import LemmaB
import Rescale

namespace D2Full
open Chain

/-- A chain restricts to a subgroup. -/
def OliverChain.comap {G : Type*} [Group G] {p q : ℕ} (C : OliverChain G p q) (K : Subgroup G) :
    OliverChain K p q where
  N₁ := C.N₁.comap K.subtype
  N₂ := C.N₂.comap K.subtype
  n₁ := by have := C.n₁; exact Subgroup.Normal.comap this _
  n₂ := by have := C.n₂; exact Subgroup.Normal.comap this _
  le := Subgroup.comap_mono C.le
  bot := C.bot.comap_of_injective K.subtype K.subtype_injective
  layer := by
    have := C.n₂
    have : (C.N₂.subgroupOf C.N₁).Normal := Subgroup.normal_subgroupOf
    have : (C.N₂.comap K.subtype).Normal := Subgroup.Normal.comap C.n₂ _
    have : ((C.N₂.comap K.subtype).subgroupOf (C.N₁.comap K.subtype)).Normal :=
      Subgroup.normal_subgroupOf
    have := C.layer
    let g : C.N₁.comap K.subtype →* C.N₁ :=
      { toFun := fun x => ⟨(x : K), x.2⟩
        map_one' := rfl
        map_mul' := fun _ _ => rfl }
    let φ := QuotientGroup.map ((C.N₂.comap K.subtype).subgroupOf (C.N₁.comap K.subtype))
      (C.N₂.subgroupOf C.N₁) g (by
        intro x hx
        simp only [Subgroup.mem_comap, Subgroup.mem_subgroupOf] at hx ⊢
        exact hx)
    have hφ : Function.Injective φ := by
      rw [← MonoidHom.ker_eq_bot_iff, eq_bot_iff]
      intro x hx
      induction x using QuotientGroup.induction_on with
      | H y =>
        rw [MonoidHom.mem_ker, QuotientGroup.map_mk, QuotientGroup.eq_one_iff,
          Subgroup.mem_subgroupOf] at hx
        rw [Subgroup.mem_bot, QuotientGroup.eq_one_iff, Subgroup.mem_subgroupOf,
          Subgroup.mem_comap]
        exact hx
    exact isCyclic_of_injective φ hφ
  top := by
    have := C.n₁
    have : (C.N₁.comap K.subtype).Normal := Subgroup.Normal.comap this _
    let φ := QuotientGroup.map (C.N₁.comap K.subtype) C.N₁ K.subtype (le_refl _)
    have hφ : Function.Injective φ := by
      rw [← MonoidHom.ker_eq_bot_iff, eq_bot_iff]
      intro x hx
      induction x using QuotientGroup.induction_on with
      | H y =>
        rw [MonoidHom.mem_ker, QuotientGroup.map_mk, QuotientGroup.eq_one_iff] at hx
        rw [Subgroup.mem_bot, QuotientGroup.eq_one_iff, Subgroup.mem_comap]
        exact hx
    exact C.top.of_injective φ hφ

/-! ### The stabiliser of block i₀ and its action on the block -/

variable {F r : ℕ}

/-- A permutation of O fixing block i₀ setwise maps it onto itself. -/
theorem block_onto (g : Equiv.Perm (Pt F r)) [NeZero r] (i j : Fin F)
    (hg : ∀ x, (g (i, x)).1 = j) : ∀ y, ∃ x, g (i, x) = (j, y) := by
  have hinj : Function.Injective fun x : ZMod r => (g (i, x)).2 := by
    intro x x' h
    have : g (i, x) = g (i, x') := Prod.ext (by rw [hg, hg]) h
    have := g.injective this
    exact (Prod.mk.inj this).2
  intro y
  obtain ⟨x, hx⟩ := (Finite.injective_iff_surjective.mp hinj) y
  exact ⟨x, Prod.ext (hg x) hx⟩

/-- The stabiliser in G of block i₀. -/
def Kstab [NeZero r] (G : Subgroup (Equiv.Perm (Pt F r))) (i0 : Fin F) : Subgroup G where
  carrier := {g | ∀ x, ((g : Equiv.Perm (Pt F r)) (i0, x)).1 = i0}
  one_mem' := fun x => rfl
  mul_mem' := by
    intro a b ha hb x
    simp only [Set.mem_ofPred_eq, Subgroup.coe_mul, Equiv.Perm.mul_apply] at ha hb ⊢
    have : (b : Equiv.Perm (Pt F r)) (i0, x) = (i0, ((b : Equiv.Perm (Pt F r)) (i0, x)).2) :=
      Prod.ext (hb x) rfl
    rw [this, ha]
  inv_mem' := by
    intro a ha x
    simp only [Set.mem_ofPred_eq] at ha ⊢
    obtain ⟨x', hx'⟩ := block_onto (a : Equiv.Perm (Pt F r)) i0 i0 ha x
    have : ((a⁻¹ : G) : Equiv.Perm (Pt F r)) (i0, x) = (i0, x') := by
      rw [Subgroup.coe_inv, Equiv.Perm.inv_eq_iff_eq, hx']
    rw [this]

theorem Kstab_pt [NeZero r] {G : Subgroup (Equiv.Perm (Pt F r))} {i0 : Fin F} (k : Kstab G i0)
    (x : ZMod r) : ((k : G) : Equiv.Perm (Pt F r)) (i0, x) =
      (i0, (((k : G) : Equiv.Perm (Pt F r)) (i0, x)).2) :=
  Prod.ext (k.2 x) rfl

/-- The action of the block stabiliser on block i₀. -/
def ρ [NeZero r] (G : Subgroup (Equiv.Perm (Pt F r))) (i0 : Fin F) :
    Kstab G i0 →* Equiv.Perm (ZMod r) where
  toFun k :=
    { toFun := fun x => (((k : G) : Equiv.Perm (Pt F r)) (i0, x)).2
      invFun := fun x => (((k⁻¹ : Kstab G i0) : G) : Equiv.Perm (Pt F r)) (i0, x) |>.2
      left_inv := fun x => by
        simp only
        rw [← Kstab_pt k x]
        simp
      right_inv := fun x => by
        simp only
        rw [← Kstab_pt k⁻¹ x]
        simp }
  map_one' := by ext x; rfl
  map_mul' := by
    intro a b
    ext x
    simp only [Subgroup.coe_mul, Equiv.Perm.mul_apply, Equiv.coe_fn_mk]
    rw [Kstab_pt b x]

/-! ### Conjugation by an arbitrary relabelling -/

/-- ψ⁻¹ G ψ. -/
def conjBy (ψ : Equiv.Perm (Pt F r)) (G : Subgroup (Equiv.Perm (Pt F r))) :
    Subgroup (Equiv.Perm (Pt F r)) :=
  G.map (MulAut.conj ψ⁻¹).toMonoidHom

theorem mem_conjBy {ψ : Equiv.Perm (Pt F r)} {G : Subgroup (Equiv.Perm (Pt F r))}
    {g' : Equiv.Perm (Pt F r)} : g' ∈ conjBy ψ G ↔ ψ * g' * ψ⁻¹ ∈ G := by
  simp only [conjBy, Subgroup.mem_map, MulEquiv.coe_toMonoidHom, MulAut.conj_apply, inv_inv]
  constructor
  · rintro ⟨g, hg, rfl⟩; simpa [mul_assoc] using hg
  · intro h
    exact ⟨_, h, by simp [mul_assoc]⟩

theorem orbit2_conjBy [NeZero r] (ψ : Equiv.Perm (Pt F r)) (G : Subgroup (Equiv.Perm (Pt F r)))
    (e : Sym2 (Pt F r)) :
    (D2.orbit2 G (Sym2.map ψ e)).card = (D2.orbit2 (conjBy ψ G) e).card := by
  classical
  have hinj : Function.Injective (Sym2.map ψ) := Sym2.map.injective ψ.injective
  have hset : D2.orbit2 G (Sym2.map ψ e) = (D2.orbit2 (conjBy ψ G) e).image (Sym2.map ψ) := by
    ext x
    simp only [D2.orbit2, Finset.mem_image, Finset.mem_filter, Finset.mem_univ, true_and]
    constructor
    · rintro ⟨g, hg, rfl⟩
      refine ⟨Sym2.map ⇑(ψ⁻¹ * g * ψ) e, ⟨ψ⁻¹ * g * ψ, ?_, rfl⟩, ?_⟩
      · rw [mem_conjBy]; simpa [mul_assoc] using hg
      · rw [Sym2.map_map, Sym2.map_map]; congr 1; funext pt; simp
    · rintro ⟨y, ⟨g', hg', rfl⟩, rfl⟩
      refine ⟨ψ * g' * ψ⁻¹, mem_conjBy.mp hg', ?_⟩
      rw [Sym2.map_map, Sym2.map_map]; congr 1; funext pt; simp
  rw [hset, Finset.card_image_of_injective _ hinj]

/-! ### Lemma D2 from the chain alone -/

/-- **Lemma B on every block, through a transversal.**  For G preserving a block system of
F ≥ 1 blocks of prime size r ≠ p, transitive, with an Oliver chain (r = q allowed), there is a
relabelling Ψ of O in which every element of G is affine block-to-block. -/
theorem exists_affine_relabel [Fact r.Prime] {p q : ℕ} (G : Subgroup (Equiv.Perm (Pt F r)))
    (C : OliverChain G p q) (hp : p.Prime) (hq : q.Prime) (hrp : r ≠ p) (hF : 0 < F)
    (hblk : ∀ g ∈ G, ∀ i x y, (g (i, x)).1 = (g (i, y)).1)
    (htr : ∀ x y : Pt F r, ∃ g ∈ G, g x = y) :
    ∃ Ψ : Equiv.Perm (Pt F r), ∀ g' ∈ conjBy Ψ G, ∃ (σ : Equiv.Perm (Fin F))
      (a t : Fin F → ZMod r), (∀ i, a i ≠ 0) ∧ Affine g' σ a t := by
  classical
  have hr : r.Prime := Fact.out
  have : NeZero r := ⟨hr.ne_zero⟩
  let i0 : Fin F := ⟨0, hF⟩
  -- Lemma B on block i₀
  let K := Kstab G i0
  let ρK := ρ G i0
  let CH : OliverChain ρK.range p q :=
    (OliverChain.comap C K).map ρK.rangeRestrict ρK.rangeRestrict_surjective
  have htrH : ∀ x y : ZMod r, ∃ h ∈ ρK.range, h x = y := by
    intro x y
    obtain ⟨g, hg, hgy⟩ := htr (i0, x) (i0, y)
    let gK : K := ⟨⟨g, hg⟩, fun x' => by
      show (g (i0, x')).1 = i0
      rw [hblk g hg i0 x' x, hgy]⟩
    exact ⟨ρK gK, ⟨gK, rfl⟩, by
      show (g (i0, x)).2 = y
      rw [hgy]⟩
  obtain ⟨E, hE⟩ := LemmaB.lemmaB_block_any ρK.range CH hp hq hrp htrH
  -- a transversal gⱼ carrying block i₀ to block j
  have hgj : ∀ j : Fin F, ∃ g ∈ G, g (i0, 0) = (j, 0) := fun j => htr (i0, 0) (j, 0)
  choose gj hgjG hgj0 using hgj
  have hgjblk : ∀ j x, (gj j (i0, x)).1 = j := by
    intro j x; rw [hblk _ (hgjG j) i0 x 0, hgj0]
  -- the relabelling Ψ(j, x) = gⱼ(i₀, E x)
  let Ψf : Pt F r → Pt F r := fun pt => gj pt.1 (i0, E pt.2)
  have hΨinj : Function.Injective Ψf := by
    intro a b hab
    have h1 : a.1 = b.1 := by
      have := congrArg Prod.fst hab
      simp only [Ψf, hgjblk] at this
      exact this
    obtain ⟨a1, a2⟩ := a
    obtain ⟨b1, b2⟩ := b
    simp only at h1
    subst h1
    simp only [Ψf] at hab
    have := (Prod.mk.inj ((gj a1).injective hab)).2
    rw [E.injective this]
  let Ψ : Equiv.Perm (Pt F r) := Equiv.ofBijective Ψf (Finite.injective_iff_bijective.mp hΨinj)
  have hΨ : ∀ j x, Ψ (j, x) = gj j (i0, E x) := fun _ _ => rfl
  -- in Ψ's coordinates every element is affine
  have hB' : ∀ g' ∈ conjBy Ψ G, ∃ (σ : Equiv.Perm (Fin F)) (a t : Fin F → ZMod r),
      (∀ i, a i ≠ 0) ∧ Affine g' σ a t := by
    intro g' hg'
    have hg := mem_conjBy.mp hg'
    set g := Ψ * g' * Ψ⁻¹ with hgdef
    have hg'eq : g' = Ψ⁻¹ * g * Ψ := by rw [hgdef]; group
    let k : Fin F → Fin F := fun j => (g (j, 0)).1
    have hkblk : ∀ j x, (g (j, x)).1 = k j := fun j x => hblk g hg j x 0
    -- u_j = g_{k j}⁻¹ g g_j stabilises block i₀
    have hu : ∀ j, ∃ a b : ZMod r, a ≠ 0 ∧ ∀ x,
        g (gj j (i0, E x)) = gj (k j) (i0, E (a * x + b)) := by
      intro j
      let u := (gj (k j))⁻¹ * g * gj j
      have huG : u ∈ G :=
        G.mul_mem (G.mul_mem (G.inv_mem (hgjG _)) hg) (hgjG j)
      have huK : ∀ x, (u (i0, x)).1 = i0 := by
        intro x
        simp only [u, Equiv.Perm.mul_apply]
        have h1 : (g (gj j (i0, x))).1 = k j := by
          have : gj j (i0, x) = (j, (gj j (i0, x)).2) := Prod.ext (hgjblk j x) rfl
          rw [this, hkblk]
        obtain ⟨x'', hx''⟩ := block_onto (gj (k j)) i0 (k j) (hgjblk (k j))
          (g (gj j (i0, x))).2
        have : g (gj j (i0, x)) = gj (k j) (i0, x'') := by
          rw [hx'']; exact Prod.ext h1 rfl
        rw [this]; simp
      let uK : K := ⟨⟨u, huG⟩, huK⟩
      obtain ⟨a, b, ha, hab⟩ := hE (ρK uK) ⟨uK, rfl⟩
      refine ⟨a, b, ha, fun x => ?_⟩
      have h2 : E (a * x + b) = (ρK uK) (E x) := by
        rw [← hab x]; simp
      rw [h2]
      show g (gj j (i0, E x)) = gj (k j) (i0, ((u (i0, E x)).2))
      rw [← Kstab_pt uK (E x)]
      show g (gj j (i0, E x)) = gj (k j) (((gj (k j))⁻¹ * g * gj j) (i0, E x))
      simp
    choose a b ha hab using hu
    -- the block map is a permutation
    have hkinj : Function.Injective k := by
      intro j j' hjj
      obtain ⟨x, hx⟩ := block_onto g j (k j) (hkblk j) (g (j', 0)).2
      have : g (j, x) = g (j', 0) := by rw [hx]; exact Prod.ext hjj rfl
      exact (Prod.mk.inj (g.injective this)).1
    let σ : Equiv.Perm (Fin F) := Equiv.ofBijective k (Finite.injective_iff_bijective.mp hkinj)
    refine ⟨σ, a, b, ha, fun pt => ?_⟩
    rw [hg'eq, Equiv.Perm.mul_apply, Equiv.Perm.mul_apply]
    have : Ψ pt = gj pt.1 (i0, E pt.2) := rfl
    rw [this, hab, Equiv.Perm.inv_eq_iff_eq]
    rfl
  exact ⟨Ψ, hB'⟩

/-- **Lemma D2's same-position bound, without Lemma B.**  G acting on F blocks of prime size
r, preserving the block system and transitive, with an Oliver chain, 2 ≤ F < r and
r ∉ {p, q}: some orbital has at most C(F,2)·r pairs.  Lemma B is derived here for the block
(`LemmaB.lemmaB_block`) and transported to every block through a transversal. -/
theorem d2_noB [Fact r.Prime] {p q : ℕ} (G : Subgroup (Equiv.Perm (Pt F r)))
    (C : OliverChain G p q) (hp : p.Prime) (hq : q.Prime) (hrp : r ≠ p) (hrq : r ≠ q)
    (hF2 : 2 ≤ F) (hFr : F < r)
    (hblk : ∀ g ∈ G, ∀ i x y, (g (i, x)).1 = (g (i, y)).1)
    (htr : ∀ x y : Pt F r, ∃ g ∈ G, g x = y) :
    ∃ e : Sym2 (Pt F r), ¬ e.IsDiag ∧ (D2.orbit2 G e).card ≤ r * F.choose 2 := by
  classical
  have hr : r.Prime := Fact.out
  have : NeZero r := ⟨hr.ne_zero⟩
  obtain ⟨Ψ, hB'⟩ := exists_affine_relabel G C hp hq hrp (by omega) hblk htr
  -- transitivity and the chain pass to Ψ⁻¹ G Ψ
  have htr' : ∀ x y : Pt F r, ∃ g' ∈ conjBy Ψ G, g' x = y := by
    intro x y
    obtain ⟨g, hg, hgy⟩ := htr (Ψ x) (Ψ y)
    refine ⟨Ψ⁻¹ * g * Ψ, mem_conjBy.mpr (by simpa [mul_assoc] using hg), ?_⟩
    simp [hgy]
  let f : G →* conjBy Ψ G := (MulAut.conj Ψ⁻¹).toMonoidHom.subgroupMap G
  have hf : Function.Surjective f := (MulAut.conj Ψ⁻¹).toMonoidHom.subgroupMap_surjective G
  obtain ⟨e, hed, hecard⟩ :=
    Rescale.d2_full (conjBy Ψ G) (C.map f hf) hp hq hrp hrq hF2 hFr hB' htr'
  refine ⟨Sym2.map Ψ e, ?_, ?_⟩
  · rwa [Sym2.isDiag_map Ψ.injective]
  · rw [orbit2_conjBy]; exact hecard

end D2Full

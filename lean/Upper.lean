/-
# `Upper.lean` — the level-1 quantities, toward the upper bound on μ\*_N^fpf

`threshold-beyond-mu.md` §1.4 and §6.3, set up for the ceiling side (Proposition U_typ).

* `Nstar Γ` — the permutations carrying every orbital of Γ onto an orbital (§1.4's N\*(Γ)).
* `NCx Γ K` — an N\*-invariant complex on Γ's orbitals; `OliverCond Γ K` — it meets Γ's χ
  condition (χ ≡ 1 mod q for every Oliver chain of Γ, as in `Evasive.HypKSSOliver`).
* `mN Γ` — **m\*_N(Γ), level 1**: the least B such that some N\*-invariant complex with every face
  of total ≤ B meets the condition.  `mtyp Γ` — **m\*_typ(Γ)**: the least total of a nonempty
  N\*-invariant set of orbitals (attained by a type).
* `evasive_below_mN` — the soundness of level 1: under the KSS–Oliver input, an Oliver Γ makes
  every property with e_max < m\*_N(Γ) evasive.  So μ\*_N^fpf(n) = max of m\*_N over
  fixed-point-free Oliver Γ is a certified evasiveness threshold, and the ceiling question is an
  upper bound on m\*_N.
* `mN_le_total` — **m\*_N(Γ) ≤ the total of any nonempty N\*-invariant set of orbitals** (the full
  simplex on it has χ = 1); in particular `mN_le_mtyp`.
* **Step 1** (`Nstar_orb`): for fixed-point-free Γ, σ ∈ N\* carries orb(x) onto orb(σx); N\* is a
  group (`Nstar_mul`, `Nstar_inv`) containing Γ.
* **Step 3** (Γ intransitive).  The pairs inside one N\*-class are N\*-invariant, so
  m\*_N ≤ F·C(a, 2) (`mN_le_class`).  With W(Γ) = Σ over classes of √F (`W_eq`):
  2·m\*_N·W² < n(n − 1) at every n (`mN_lt_intrans`).  Hence m\*_N ≥ C(n,2)/4 forces a single class
  of F ≤ 3 orbits (`intrans_quarter`), and m\*_N ≥ (3 − 2√2)·C(n,2) a single class of F ≤ 5 or two
  classes, each one orbit (`intrans_silver`).

* **Splitting** (`mN_half`): if the orbitals inside an N\*-invariant pair set are not a single type,
  2·m\*_N ≤ its size.
* **Step 2 and Conjecture P as named hypotheses** (`HypStep2`, `HypConjP`; structures, not axioms).
* `intrans_even`, `intrans_odd` — the intransitive case, given Step 2: m\*_N ≥ δ_cyc·C(n,2) forces
  n into E (first clause, or at odd n the second).  The two-orbit boundary is strict
  (`two_orbit_strict`, `silver_irr`).
* **Proposition U_typ** (`Utyp_even`, `Utyp_odd`), given Step 2 and Conjecture P: for
  fixed-point-free Oliver Γ on n points, n not a prime power and n ∉ E,
  m\*_N(Γ) < δ_cyc(n)·C(n,2) — so μ\*_N^fpf(n) < δ_cyc(n)·C(n,2).

* **Step 4** (`step4`, `mN_le_blocks`): Γ transitive with an N\*-block system of m ≥ 2 blocks of
  size b: the intra-block pairs give m\*_N ≤ m·C(b,2); if they split, the bound halves and falls
  below δ_cyc; if not, b is a prime power (`HypStep2Block`) and n lies in E's first clause.  With
  Step 5 as `HypStep5` (N\* primitive), `Utyp_even_steps`, `Utyp_odd_steps` restate U_typ with
  Conjecture P replaced by its open part.

**Not here:** m\*_typ is bounded, ν\*_fpf as such is not defined.
-/
import Evasive

set_option linter.unusedSectionVars false

namespace Upper
open Finset Equiv Classical Evasive

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- The image of a set of pairs under a permutation. -/
noncomputable def img (σ : Perm V) (o : Finset (Sym2 V)) : Finset (Sym2 V) := o.image (Sym2.map σ)

/-- **N\*(Γ)**: the permutations carrying every orbital onto an orbital. -/
def Nstar (Γ : Subgroup (Perm V)) : Set (Perm V) :=
  {σ | ∀ o ∈ orbitals Γ, img σ o ∈ orbitals Γ}

/-- A set of orbitals closed under N\*. -/
def NInv (Γ : Subgroup (Perm V)) (T : Finset (Finset (Sym2 V))) : Prop :=
  ∀ σ ∈ Nstar Γ, ∀ o ∈ T, img σ o ∈ T

/-- An N\*-invariant simplicial complex on Γ's orbitals (faces: nonempty sets of orbitals). -/
structure NCx (Γ : Subgroup (Perm V)) (K : Finset (Finset (Finset (Sym2 V)))) : Prop where
  sub : ∀ S ∈ K, S ⊆ orbitals Γ
  ne : ∀ S ∈ K, S.Nonempty
  down : ∀ S ∈ K, ∀ T ⊆ S, T.Nonempty → T ∈ K
  inv : ∀ σ ∈ Nstar Γ, ∀ S ∈ K, S.image (img σ) ∈ K

/-- Euler characteristic of a complex given by its faces. -/
def chiK (K : Finset (Finset (Finset (Sym2 V)))) : ℤ := ∑ S ∈ K, (-1 : ℤ) ^ (S.card + 1)

/-- Γ's χ condition (Oliver's congruence for each chain). -/
def OliverCond (Γ : Subgroup (Perm V)) (K : Finset (Finset (Finset (Sym2 V)))) : Prop :=
  ∀ p q : ℕ, p.Prime → q.Prime → Nonempty (Chain.OliverChain Γ p q) → chiK K ≡ 1 [ZMOD q]

/-- Every face has total at most B. -/
def Fits (K : Finset (Finset (Finset (Sym2 V)))) (B : ℕ) : Prop :=
  ∀ S ∈ K, (S.biUnion id).card ≤ B

/-- **m\*_N(Γ)**, level 1. -/
noncomputable def mN (Γ : Subgroup (Perm V)) : ℕ :=
  sInf {B | ∃ K, NCx Γ K ∧ OliverCond Γ K ∧ Fits K B}

/-- **m\*_typ(Γ)**: the least total of a nonempty N\*-invariant set of orbitals. -/
noncomputable def mtyp (Γ : Subgroup (Perm V)) : ℕ :=
  sInf {m | ∃ T ⊆ orbitals Γ, T.Nonempty ∧ NInv Γ T ∧ (T.biUnion id).card = m}

/-! ## Level 1 is sound -/

/-- The fixed complex of a property is an N\*-invariant complex. -/
theorem fix_NCx (Γ : Subgroup (Perm V)) (P : DownProp V) :
    NCx Γ ((orbitals Γ).powerset.filter (fun S => S.Nonempty ∧ P.mem (S.biUnion id))) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro S hS; exact mem_powerset.mp (mem_filter.mp hS).1
  · intro S hS; exact (mem_filter.mp hS).2.1
  · intro S hS T hT hTne
    simp only [mem_filter, mem_powerset] at hS ⊢
    exact ⟨hT.trans hS.1, hTne, P.down _ _ hS.2.2 (biUnion_subset_biUnion_of_subset_left _ hT)⟩
  · intro σ hσ S hS
    simp only [mem_filter, mem_powerset] at hS ⊢
    refine ⟨fun o ho => ?_, hS.2.1.image _, ?_⟩
    · obtain ⟨o', ho', rfl⟩ := mem_image.mp ho
      exact hσ o' (hS.1 ho')
    · have : (S.image (img σ)).biUnion id = (S.biUnion id).image (Sym2.map σ) := by
        rw [biUnion_image, image_biUnion]; rfl
      rw [this]; exact P.inv σ _ hS.2.2

/-- **Level 1 is sound.**  Under the KSS–Oliver input, every property with e_max < m\*_N(Γ) is
evasive.  (For Γ with no Oliver chain the condition is vacuous, the empty complex meets it, and
m\*_N(Γ) = 0: the statement is empty there.) -/
theorem evasive_below_mN (Ev : DownProp V → Prop) (H : HypKSSOliver Ev) (Γ : Subgroup (Perm V))
    (P : DownProp V) (hP : EmaxLt P (mN Γ)) : Ev P := by
  by_contra hne
  set K := (orbitals Γ).powerset.filter (fun S => S.Nonempty ∧ P.mem (S.biUnion id))
  -- the largest face total is below m*_N
  obtain ⟨B, hB, hfit⟩ : ∃ B, B < mN Γ ∧ Fits K B := by
    refine ⟨mN Γ - 1, ?_, ?_⟩
    · have : 0 < mN Γ := by
        have := hP ∅ P.empty; simp at this; omega
      omega
    · intro S hS
      have := hP _ (mem_filter.mp hS).2.2
      omega
  have hcond : OliverCond Γ K := by
    intro p' q' hp' hq' hch'
    exact H.congr Γ p' q' hp' hq' hch' P hne
  have : mN Γ ≤ B := Nat.sInf_le ⟨K, fix_NCx Γ P, hcond, hfit⟩
  omega

/-! ## m\*_N ≤ the total of an N\*-invariant set -/

/-- χ of the full simplex on a nonempty vertex set is 1. -/
theorem chi_simplex {T : Finset (Finset (Sym2 V))} (hT : T.Nonempty) :
    chiK (T.powerset.filter (fun S => S.Nonempty)) = 1 := by
  unfold chiK
  have h := Finset.sum_powerset_neg_one_pow_card_of_nonempty hT
  rw [Finset.sum_filter]
  have e : ∀ S ∈ T.powerset, (if S.Nonempty then (-1 : ℤ) ^ (S.card + 1) else 0) =
      -((-1 : ℤ) ^ S.card) + (if S = ∅ then 1 else 0) := by
    intro S _
    by_cases hS : S = ∅
    · subst hS; simp
    · have : S.Nonempty := nonempty_iff_ne_empty.mpr hS
      simp [this, hS, pow_succ]
  rw [sum_congr rfl e, sum_add_distrib, sum_neg_distrib, h]
  simp

/-- **m\*_N(Γ) is at most the total of any nonempty N\*-invariant set of orbitals.** -/
theorem mN_le_total (Γ : Subgroup (Perm V)) {T : Finset (Finset (Sym2 V))}
    (hT : T ⊆ orbitals Γ) (hne : T.Nonempty) (hinv : NInv Γ T) :
    mN Γ ≤ (T.biUnion id).card := by
  apply Nat.sInf_le
  refine ⟨T.powerset.filter (fun S => S.Nonempty), ⟨?_, ?_, ?_, ?_⟩, ?_, ?_⟩
  · intro S hS; exact (mem_powerset.mp (mem_filter.mp hS).1).trans hT
  · intro S hS; exact (mem_filter.mp hS).2
  · intro S hS U hU hUne
    simp only [mem_filter, mem_powerset] at hS ⊢
    exact ⟨hU.trans hS.1, hUne⟩
  · intro σ hσ S hS
    simp only [mem_filter, mem_powerset] at hS ⊢
    refine ⟨fun o ho => ?_, hS.2.image _⟩
    obtain ⟨o', ho', rfl⟩ := mem_image.mp ho
    exact hinv σ hσ o' (hS.1 ho')
  · intro p q _ _ _
    rw [chi_simplex hne]
  · intro S hS
    exact card_le_card (biUnion_subset_biUnion_of_subset_left _ (mem_powerset.mp (mem_filter.mp hS).1))

theorem mN_le_mtyp (Γ : Subgroup (Perm V)) (hV : 2 ≤ Fintype.card V) : mN Γ ≤ mtyp Γ := by
  -- the set defining mtyp is nonempty: all orbitals form an N*-invariant set
  have hne : (orbitals Γ).Nonempty := by
    obtain ⟨x, y, hxy⟩ := Fintype.exists_pair_of_one_lt_card (α := V) (by omega)
    refine ⟨D2.orbit2 Γ s(x, y), mem_image.mpr ⟨s(x, y), ?_, rfl⟩⟩
    simp [hxy]
  obtain ⟨T, hT, hTne, hinv, hm⟩ := Nat.sInf_mem (s := {m | ∃ T ⊆ orbitals Γ, T.Nonempty ∧
    NInv Γ T ∧ (T.biUnion id).card = m})
    ⟨_, orbitals Γ, subset_refl _, hne, fun σ hσ o ho => hσ o ho, rfl⟩
  unfold mtyp; rw [← hm]
  exact mN_le_total Γ hT hTne hinv

/-! ## Step 1: for fixed-point-free Γ, N\* permutes Γ's orbits -/

theorem mem_orbit2 {Γ : Subgroup (Perm V)} {e x : Sym2 V} :
    x ∈ D2.orbit2 Γ e ↔ ∃ g ∈ Γ, Sym2.map g e = x := by
  unfold D2.orbit2; simp [mem_image]

theorem orbit2_eq_of_mem {Γ : Subgroup (Perm V)} {e e' : Sym2 V} (h : e' ∈ D2.orbit2 Γ e) :
    D2.orbit2 Γ e' = D2.orbit2 Γ e := by
  obtain ⟨h0, hh0, rfl⟩ := mem_orbit2.mp h
  ext x; rw [mem_orbit2, mem_orbit2]
  constructor
  · rintro ⟨g, hg, rfl⟩; exact ⟨g * h0, Γ.mul_mem hg hh0, by rw [Sym2.map_map]; rfl⟩
  · rintro ⟨g, hg, rfl⟩
    refine ⟨g * h0⁻¹, Γ.mul_mem hg (Γ.inv_mem hh0), ?_⟩
    rw [Sym2.map_map]; congr 1; ext a; simp

theorem self_mem_orbit2 {Γ : Subgroup (Perm V)} (e : Sym2 V) : e ∈ D2.orbit2 Γ e :=
  mem_orbit2.mpr ⟨1, Γ.one_mem, by simp⟩

/-- The Γ-orbit of a point. -/
noncomputable def orb (Γ : Subgroup (Perm V)) (x : V) : Finset V :=
  univ.filter (fun y => ∃ g ∈ Γ, g x = y)

theorem mem_orb {Γ : Subgroup (Perm V)} {x y : V} : y ∈ orb Γ x ↔ ∃ g ∈ Γ, g x = y := by
  simp [orb]

theorem self_mem_orb (Γ : Subgroup (Perm V)) (x : V) : x ∈ orb Γ x :=
  mem_orb.mpr ⟨1, Γ.one_mem, rfl⟩

theorem orb_eq_of_mem {Γ : Subgroup (Perm V)} {x y : V} (h : y ∈ orb Γ x) : orb Γ y = orb Γ x := by
  obtain ⟨h0, hh0, rfl⟩ := mem_orb.mp h
  ext z; rw [mem_orb, mem_orb]
  constructor
  · rintro ⟨g, hg, rfl⟩; exact ⟨g * h0, Γ.mul_mem hg hh0, rfl⟩
  · rintro ⟨g, hg, rfl⟩; exact ⟨g * h0⁻¹, Γ.mul_mem hg (Γ.inv_mem hh0), by simp⟩

/-- Γ has no fixed point. -/
def FPF (Γ : Subgroup (Perm V)) : Prop := ∀ x, ∃ g ∈ Γ, g x ≠ x

theorem img_inj (σ : Perm V) : Function.Injective (img σ) := by
  intro a b h
  have hi : Function.Injective (Sym2.map σ) := Sym2.map.injective σ.injective
  ext x
  constructor
  · intro hx
    have : Sym2.map σ x ∈ img σ b := h ▸ mem_image_of_mem _ hx
    obtain ⟨y, hy, hxy⟩ := mem_image.mp this
    rw [hi hxy] at hy; exact hy
  · intro hx
    have : Sym2.map σ x ∈ img σ a := h.symm ▸ mem_image_of_mem _ hx
    obtain ⟨y, hy, hxy⟩ := mem_image.mp this
    rw [hi hxy] at hy; exact hy

theorem img_mul (σ τ : Perm V) (o : Finset (Sym2 V)) : img (σ * τ) o = img σ (img τ o) := by
  simp only [img, image_image]; congr 1; ext e; simp [Sym2.map_map]

theorem img_one (o : Finset (Sym2 V)) : img 1 o = o := by
  simp [img]

/-- N\* is closed under products. -/
theorem Nstar_mul {Γ : Subgroup (Perm V)} {σ τ : Perm V} (hσ : σ ∈ Nstar Γ) (hτ : τ ∈ Nstar Γ) :
    σ * τ ∈ Nstar Γ := by
  intro o ho; rw [img_mul]; exact hσ _ (hτ o ho)

/-- N\* is closed under inverses: σ permutes the finitely many orbitals injectively. -/
theorem Nstar_inv {Γ : Subgroup (Perm V)} {σ : Perm V} (hσ : σ ∈ Nstar Γ) : σ⁻¹ ∈ Nstar Γ := by
  intro o ho
  have hmap : Set.MapsTo (img σ) (orbitals Γ : Set (Finset (Sym2 V))) (orbitals Γ) :=
    fun o ho => hσ o ho
  have hsurj := (Finset.surj_on_of_inj_on_of_card_le (s := orbitals Γ) (t := orbitals Γ)
    (fun o ho => img σ o) (fun o ho => hσ o ho) (fun a b _ _ h => img_inj σ h) le_rfl)
  obtain ⟨o', ho', he⟩ := hsurj o ho
  rw [he, ← img_mul, inv_mul_cancel, img_one]; exact ho'

/-- Γ ⊆ N\*(Γ): an element of Γ fixes every orbital. -/
theorem img_orbital {Γ : Subgroup (Perm V)} {g : Perm V} (hg : g ∈ Γ) {o : Finset (Sym2 V)}
    (ho : o ∈ orbitals Γ) : img g o = o := by
  obtain ⟨e, -, rfl⟩ := mem_image.mp ho
  ext x
  simp only [img, mem_image]
  constructor
  · rintro ⟨y, hy, rfl⟩
    obtain ⟨h, hh, rfl⟩ := mem_orbit2.mp hy
    exact mem_orbit2.mpr ⟨g * h, Γ.mul_mem hg hh, by rw [Sym2.map_map]; rfl⟩
  · intro hx
    obtain ⟨h, hh, rfl⟩ := mem_orbit2.mp hx
    refine ⟨Sym2.map (g⁻¹ * h) e, mem_orbit2.mpr ⟨_, Γ.mul_mem (Γ.inv_mem hg) hh, rfl⟩, ?_⟩
    rw [Sym2.map_map]; congr 1; ext a; simp

theorem mem_Nstar_of_mem {Γ : Subgroup (Perm V)} {g : Perm V} (hg : g ∈ Γ) : g ∈ Nstar Γ := by
  intro o ho; rw [img_orbital hg ho]; exact ho

/-- The endpoints of a pair in the orbital of s(x, y) lie in x's or y's orbit. -/
theorem endpoints_of_orbital {Γ : Subgroup (Perm V)} {x y a b : V}
    (h : s(a, b) ∈ D2.orbit2 Γ s(x, y)) : a ∈ orb Γ x ∨ a ∈ orb Γ y := by
  obtain ⟨g, hg, he⟩ := mem_orbit2.mp h
  rw [Sym2.map_mk] at he
  rcases Sym2.eq_iff.mp he with ⟨h1, -⟩ | ⟨-, h2⟩
  · exact Or.inl (mem_orb.mpr ⟨g, hg, h1⟩)
  · exact Or.inr (mem_orb.mpr ⟨g, hg, h2⟩)

/-- **Step 1.**  For fixed-point-free Γ and σ ∈ N\*(Γ), σ carries the orbit of x onto the orbit
of σ x. -/
theorem Nstar_orb {Γ : Subgroup (Perm V)} (hfp : FPF Γ) {σ : Perm V} (hσ : σ ∈ Nstar Γ) (x : V) :
    (orb Γ x).image σ = orb Γ (σ x) := by
  -- every g ∈ Γ̂ := {fixing each orbital} keeps x in its orbit
  have hat : ∀ h : Perm V, (∀ o ∈ orbitals Γ, img h o = o) → ∀ z, h z ∈ orb Γ z := by
    intro h hh z
    obtain ⟨g, hg, hgz⟩ := hfp z
    have ho : D2.orbit2 Γ s(z, g z) ∈ orbitals Γ :=
      mem_image.mpr ⟨s(z, g z), by simp [Ne.symm hgz], rfl⟩
    have := hh _ ho
    have hm : Sym2.map h s(z, g z) ∈ D2.orbit2 Γ s(z, g z) := by
      rw [← this]; exact mem_image_of_mem _ (self_mem_orbit2 _)
    simp only [Sym2.map_mk] at hm
    rcases endpoints_of_orbital hm with h1 | h1
    · exact h1
    · rw [orb_eq_of_mem (mem_orb.mpr ⟨g, hg, rfl⟩)] at h1; exact h1
  -- σ g σ⁻¹ fixes every orbital, for g ∈ Γ (and so does σ⁻¹ g σ)
  have hσi := Nstar_inv hσ
  have conj : ∀ τ ∈ Nstar Γ, τ⁻¹ ∈ Nstar Γ → ∀ g ∈ Γ, ∀ o ∈ orbitals Γ, img (τ * g * τ⁻¹) o = o := by
    intro τ hτ hτi g hg o ho
    rw [img_mul, img_mul, img_orbital hg (hτi o ho), ← img_mul, mul_inv_cancel, img_one]
  ext y
  simp only [mem_image, mem_orb]
  constructor
  · rintro ⟨z, ⟨g, hg, rfl⟩, rfl⟩
    have := hat _ (conj σ hσ hσi g hg) (σ x)
    simpa [mem_orb] using this
  · rintro ⟨g, hg, rfl⟩
    have := hat _ (conj σ⁻¹ hσi (by simpa using hσ) g hg) x
    obtain ⟨g', hg', he⟩ := mem_orb.mp this
    refine ⟨σ⁻¹ (g (σ x)), ⟨g', hg', ?_⟩, by simp⟩
    rw [he]; simp

/-! ## Step 3's per-class bound: m\*_N ≤ F·C(a, 2) -/

/-- The pairs inside a set of points. -/
noncomputable def pairsIn (O : Finset V) : Finset (Sym2 V) := O.offDiag.image Sym2.mk.uncurry

theorem card_pairsIn (O : Finset V) : (pairsIn O).card = O.card.choose 2 :=
  Sym2.card_image_offDiag O

theorem mk_mem_pairsIn {O : Finset V} {a b : V} (ha : a ∈ O) (hb : b ∈ O) (hab : a ≠ b) :
    s(a, b) ∈ pairsIn O :=
  mem_image.mpr ⟨(a, b), mem_offDiag.mpr ⟨ha, hb, hab⟩, rfl⟩

theorem map_mem_pairsIn {O : Finset V} {e : Sym2 V} (he : e ∈ pairsIn O) (σ : Perm V) :
    Sym2.map σ e ∈ pairsIn (O.image σ) := by
  obtain ⟨⟨a, b⟩, hab, rfl⟩ := mem_image.mp he
  obtain ⟨ha, hb, hne⟩ := mem_offDiag.mp hab
  exact mk_mem_pairsIn (mem_image_of_mem _ ha) (mem_image_of_mem _ hb) (fun h => hne (σ.injective h))

/-- The N\*-class of x's orbit: the orbits σ(orb x), σ ∈ N\*. -/
noncomputable def cls (Γ : Subgroup (Perm V)) (x : V) : Finset (Finset V) :=
  (univ.filter (· ∈ Nstar Γ)).image (fun σ => orb Γ (σ x))

/-- The pairs inside the orbits of x's class. -/
noncomputable def Pin (Γ : Subgroup (Perm V)) (x : V) : Finset (Sym2 V) :=
  (cls Γ x).biUnion pairsIn

theorem card_orb_cls {Γ : Subgroup (Perm V)} (hfp : FPF Γ) {x : V} {O : Finset V}
    (hO : O ∈ cls Γ x) : O.card = (orb Γ x).card := by
  obtain ⟨σ, hσ, rfl⟩ := mem_image.mp hO
  rw [← Nstar_orb hfp (mem_filter.mp hσ).2 x, card_image_of_injective _ σ.injective]

theorem card_Pin_le {Γ : Subgroup (Perm V)} (hfp : FPF Γ) (x : V) :
    (Pin Γ x).card ≤ (cls Γ x).card * (orb Γ x).card.choose 2 := by
  unfold Pin
  refine le_trans card_biUnion_le ?_
  rw [sum_congr rfl (fun O hO => by rw [card_pairsIn, card_orb_cls hfp hO]), sum_const, smul_eq_mul]

/-- Pin is carried into itself by N\* (and by Γ ⊆ N\*). -/
theorem map_Pin {Γ : Subgroup (Perm V)} (hfp : FPF Γ) {x : V} {τ : Perm V} (hτ : τ ∈ Nstar Γ)
    {e : Sym2 V} (he : e ∈ Pin Γ x) : Sym2.map τ e ∈ Pin Γ x := by
  obtain ⟨O, hO, heO⟩ := mem_biUnion.mp he
  obtain ⟨σ, hσ, rfl⟩ := mem_image.mp hO
  have hσ' := (mem_filter.mp hσ).2
  refine mem_biUnion.mpr ⟨orb Γ ((τ * σ) x), mem_image.mpr ⟨τ * σ, ?_, rfl⟩, ?_⟩
  · exact mem_filter.mpr ⟨mem_univ _, Nstar_mul hτ hσ'⟩
  · have := map_mem_pairsIn heO τ
    rwa [Nstar_orb hfp hτ] at this

/-- **The per-class bound.**  For fixed-point-free Γ, m\*_N(Γ) ≤ F·C(a, 2), where a is the size of
x's orbit and F the number of orbits in its N\*-class. -/
theorem mN_le_class {Γ : Subgroup (Perm V)} (hfp : FPF Γ) (x : V) :
    mN Γ ≤ (cls Γ x).card * (orb Γ x).card.choose 2 := by
  set T := (orbitals Γ).filter (· ⊆ Pin Γ x)
  -- every orbital meeting Pin lies in it
  have hsub : ∀ e ∈ Pin Γ x, D2.orbit2 Γ e ⊆ Pin Γ x := by
    intro e he y hy
    obtain ⟨g, hg, rfl⟩ := mem_orbit2.mp hy
    exact map_Pin hfp (mem_Nstar_of_mem hg) he
  have hTne : T.Nonempty := by
    obtain ⟨g, hg, hgx⟩ := hfp x
    have he : s(x, g x) ∈ Pin Γ x := by
      refine mem_biUnion.mpr ⟨orb Γ x, mem_image.mpr ⟨1, ?_, by simp⟩, ?_⟩
      · exact mem_filter.mpr ⟨mem_univ _, mem_Nstar_of_mem Γ.one_mem⟩
      · exact mk_mem_pairsIn (self_mem_orb Γ x) (mem_orb.mpr ⟨g, hg, rfl⟩) (Ne.symm hgx)
    refine ⟨D2.orbit2 Γ s(x, g x), mem_filter.mpr ⟨?_, hsub _ he⟩⟩
    exact mem_image.mpr ⟨s(x, g x), by simp [Ne.symm hgx], rfl⟩
  have hinv : NInv Γ T := by
    intro τ hτ o ho
    obtain ⟨ho1, ho2⟩ := mem_filter.mp ho
    refine mem_filter.mpr ⟨hτ o ho1, ?_⟩
    intro e he
    obtain ⟨e', he', rfl⟩ := mem_image.mp he
    exact map_Pin hfp hτ (ho2 he')
  calc mN Γ ≤ (T.biUnion id).card := mN_le_total Γ (filter_subset _ _) hTne hinv
    _ ≤ (Pin Γ x).card := card_le_card (biUnion_subset.mpr (fun o ho => (mem_filter.mp ho).2))
    _ ≤ _ := card_Pin_le hfp x

/-! ## Step 3: the Σ√F bound -/

/-- The number of orbits in x's N\*-class, and the orbit size. -/
noncomputable def Fc (Γ : Subgroup (Perm V)) (x : V) : ℕ := (cls Γ x).card

theorem Fc_pos (Γ : Subgroup (Perm V)) (x : V) : 0 < Fc Γ x :=
  card_pos.mpr ⟨orb Γ x, mem_image.mpr ⟨1, mem_filter.mpr ⟨mem_univ _, mem_Nstar_of_mem Γ.one_mem⟩,
    by simp⟩⟩

/-- **The weight** W(Γ) = Σ_x 1/(√F(x)·a(x)); it equals Σ over classes of √F (`W_eq`). -/
noncomputable def W (Γ : Subgroup (Perm V)) : ℝ :=
  ∑ x, 1 / (Real.sqrt (Fc Γ x) * (orb Γ x).card)

/-- **Step 3's bound.**  For fixed-point-free Γ, √(2·m\*_N(Γ))·W(Γ) ≤ n — so
m\*_N(Γ) ≤ n²/(2 W²), i.e. at most about 1/W² of C(n,2). -/
theorem mN_sqrt_bound {Γ : Subgroup (Perm V)} (hfp : FPF Γ) :
    Real.sqrt (2 * mN Γ) * W Γ ≤ Fintype.card V := by
  unfold W
  rw [mul_sum]
  have : ∀ x : V, Real.sqrt (2 * mN Γ) * (1 / (Real.sqrt (Fc Γ x) * (orb Γ x).card)) ≤ 1 := by
    intro x
    have hF : (0 : ℝ) < Fc Γ x := by exact_mod_cast Fc_pos Γ x
    have ha : (0 : ℝ) < (orb Γ x).card := by exact_mod_cast card_pos.mpr ⟨x, self_mem_orb Γ x⟩
    have hb := mN_le_class hfp x
    have hb' : (2 * mN Γ : ℝ) ≤ Fc Γ x * (orb Γ x).card ^ 2 := by
      have h2 : 2 * ((orb Γ x).card.choose 2) ≤ (orb Γ x).card ^ 2 := by
        rw [Nat.choose_two_right]
        have := Nat.div_mul_le_self ((orb Γ x).card * ((orb Γ x).card - 1)) 2
        have : (orb Γ x).card * ((orb Γ x).card - 1) ≤ (orb Γ x).card ^ 2 := by
          rw [sq]; exact Nat.mul_le_mul_left _ (Nat.sub_le _ _)
        omega
      have : 2 * mN Γ ≤ Fc Γ x * (orb Γ x).card ^ 2 := by
        calc 2 * mN Γ ≤ 2 * (Fc Γ x * (orb Γ x).card.choose 2) := by unfold Fc; omega
          _ = Fc Γ x * (2 * (orb Γ x).card.choose 2) := by ring
          _ ≤ Fc Γ x * (orb Γ x).card ^ 2 := Nat.mul_le_mul_left _ h2
      exact_mod_cast this
    have hs : Real.sqrt (2 * mN Γ) ≤ Real.sqrt (Fc Γ x) * (orb Γ x).card := by
      rw [← Real.sqrt_sq ha.le, ← Real.sqrt_mul hF.le]
      exact Real.sqrt_le_sqrt hb'
    have hpos : 0 < Real.sqrt (Fc Γ x) * (orb Γ x).card := mul_pos (Real.sqrt_pos.mpr hF) ha
    rw [mul_one_div, div_le_one hpos]; exact hs
  calc ∑ x, Real.sqrt (2 * mN Γ) * (1 / (Real.sqrt (Fc Γ x) * (orb Γ x).card))
      ≤ ∑ _x : V, (1 : ℝ) := sum_le_sum (fun x _ => this x)
    _ = Fintype.card V := by simp

/-! ## The classes partition the points -/

/-- The points of x's N\*-class. -/
noncomputable def clsPts (Γ : Subgroup (Perm V)) (x : V) : Finset V := (cls Γ x).biUnion id

theorem mem_clsPts_self (Γ : Subgroup (Perm V)) (x : V) : x ∈ clsPts Γ x :=
  mem_biUnion.mpr ⟨orb Γ x, mem_image.mpr ⟨1, mem_filter.mpr ⟨mem_univ _, mem_Nstar_of_mem Γ.one_mem⟩,
    by simp⟩, self_mem_orb Γ x⟩

theorem mem_clsPts {Γ : Subgroup (Perm V)} {x y : V} :
    y ∈ clsPts Γ x ↔ ∃ σ ∈ Nstar Γ, y = σ x := by
  constructor
  · intro hy
    obtain ⟨O, hO, hyO⟩ := mem_biUnion.mp hy
    obtain ⟨σ, hσ, rfl⟩ := mem_image.mp hO
    obtain ⟨g, hg, rfl⟩ := mem_orb.mp hyO
    exact ⟨g * σ, Nstar_mul (mem_Nstar_of_mem hg) (mem_filter.mp hσ).2, rfl⟩
  · rintro ⟨σ, hσ, rfl⟩
    exact mem_biUnion.mpr ⟨orb Γ (σ x), mem_image.mpr ⟨σ, mem_filter.mpr ⟨mem_univ _, hσ⟩, rfl⟩,
      self_mem_orb Γ _⟩

theorem cls_eq_of_mem {Γ : Subgroup (Perm V)} {x y : V} (hy : y ∈ clsPts Γ x) :
    cls Γ y = cls Γ x := by
  obtain ⟨σ, hσ, rfl⟩ := mem_clsPts.mp hy
  ext O
  simp only [cls, mem_image, mem_filter, mem_univ, true_and]
  constructor
  · rintro ⟨τ, hτ, rfl⟩; exact ⟨τ * σ, Nstar_mul hτ hσ, rfl⟩
  · rintro ⟨τ, hτ, rfl⟩
    exact ⟨τ * σ⁻¹, Nstar_mul hτ (Nstar_inv hσ), by simp⟩

theorem clsPts_eq_of_mem {Γ : Subgroup (Perm V)} {x y : V} (hy : y ∈ clsPts Γ x) :
    clsPts Γ y = clsPts Γ x := by
  unfold clsPts; rw [cls_eq_of_mem hy]

theorem orb_card_of_mem {Γ : Subgroup (Perm V)} (hfp : FPF Γ) {x y : V} (hy : y ∈ clsPts Γ x) :
    (orb Γ y).card = (orb Γ x).card := by
  obtain ⟨σ, hσ, rfl⟩ := mem_clsPts.mp hy
  rw [← Nstar_orb hfp hσ x, card_image_of_injective _ σ.injective]

/-- A class has F·a points. -/
theorem card_clsPts {Γ : Subgroup (Perm V)} (hfp : FPF Γ) (x : V) :
    (clsPts Γ x).card = Fc Γ x * (orb Γ x).card := by
  unfold clsPts Fc
  rw [card_biUnion]
  · rw [sum_congr rfl (fun O hO => by simp only [id]; exact card_orb_cls hfp hO), sum_const, smul_eq_mul]
  · intro O hO O' hO' hne
    obtain ⟨σ, -, rfl⟩ := mem_image.mp hO
    obtain ⟨σ', -, rfl⟩ := mem_image.mp hO'
    rw [Function.onFun, disjoint_left]
    intro z hz hz'
    apply hne
    simp only [id] at hz hz' ⊢
    rw [← orb_eq_of_mem hz, ← orb_eq_of_mem hz']

/-- **W is Σ over classes of √F.** -/
theorem W_eq {Γ : Subgroup (Perm V)} (hfp : FPF Γ) :
    W Γ = ∑ C ∈ univ.image (clsPts Γ), ∑ x ∈ C, 1 / (Real.sqrt (Fc Γ x) * (orb Γ x).card) ∧
    ∀ C ∈ univ.image (clsPts Γ), ∀ x ∈ C,
      ∑ y ∈ C, 1 / (Real.sqrt (Fc Γ y) * (orb Γ y).card) = Real.sqrt (Fc Γ x) := by
  constructor
  · unfold W
    rw [← sum_fiberwise_of_maps_to (g := clsPts Γ) (t := univ.image (clsPts Γ))
      (fun x _ => mem_image_of_mem _ (mem_univ x))]
    refine sum_congr rfl (fun C hC => ?_)
    obtain ⟨x0, -, rfl⟩ := mem_image.mp hC
    refine sum_congr ?_ (fun _ _ => rfl)
    ext y
    simp only [mem_filter, mem_univ, true_and]
    constructor
    · intro h; rw [← h]; exact mem_clsPts_self Γ y
    · intro h; exact clsPts_eq_of_mem h
  · intro C hC x hx
    obtain ⟨x0, -, rfl⟩ := mem_image.mp hC
    have hxx : clsPts Γ x = clsPts Γ x0 := clsPts_eq_of_mem hx
    rw [← hxx]
    have hconst : ∀ y ∈ clsPts Γ x, 1 / (Real.sqrt (Fc Γ y) * (orb Γ y).card) =
        1 / (Real.sqrt (Fc Γ x) * (orb Γ x).card) := by
      intro y hy
      unfold Fc
      rw [cls_eq_of_mem hy, orb_card_of_mem hfp hy]
    rw [sum_congr rfl hconst, sum_const, card_clsPts hfp, nsmul_eq_mul]
    have hF : (0 : ℝ) < Fc Γ x := by exact_mod_cast Fc_pos Γ x
    have ha : (0 : ℝ) < (orb Γ x).card := by exact_mod_cast card_pos.mpr ⟨x, self_mem_orb Γ x⟩
    have hs := Real.mul_self_sqrt hF.le
    push_cast
    field_simp
    nlinarith [Real.sqrt_pos.mpr hF]

/-! ## Step 3, exactly: m\*_N < C(n,2)/W² for intransitive Γ -/

theorem sum_orb_inv (Γ : Subgroup (Perm V)) (x : V) :
    ∑ z ∈ orb Γ x, (1 : ℝ) / (orb Γ z).card = 1 := by
  have : ∀ z ∈ orb Γ x, (1 : ℝ) / (orb Γ z).card = 1 / (orb Γ x).card := by
    intro z hz; rw [orb_eq_of_mem hz]
  rw [sum_congr rfl this, sum_const, nsmul_eq_mul]
  have : (0 : ℝ) < (orb Γ x).card := by exact_mod_cast card_pos.mpr ⟨x, self_mem_orb Γ x⟩
  field_simp

/-- **Step 3, exact form.**  For fixed-point-free Γ with at least two orbits,
2·m\*_N(Γ)·W(Γ)² < n(n − 1): m\*_N(Γ) < C(n,2)/W² at every n, not only asymptotically. -/
theorem mN_lt_intrans {Γ : Subgroup (Perm V)} (hfp : FPF Γ) {x y : V} (hxy : orb Γ x ≠ orb Γ y) :
    2 * (mN Γ : ℝ) * W Γ ^ 2 < (Fintype.card V : ℝ) * (Fintype.card V - 1) := by
  set X := (mN Γ : ℝ)
  set n := (Fintype.card V : ℝ)
  have hX0 : 0 ≤ X := by positivity
  -- per point: √(2X)/(√F a) ≤ 1 − 1/(2a)
  have hpt : ∀ z : V, Real.sqrt (2 * X) * (1 / (Real.sqrt (Fc Γ z) * (orb Γ z).card)) ≤
      1 - 1 / (2 * (orb Γ z).card) := by
    intro z
    have hF : (0 : ℝ) < Fc Γ z := by exact_mod_cast Fc_pos Γ z
    have ha1 : 1 ≤ (orb Γ z).card := card_pos.mpr ⟨z, self_mem_orb Γ z⟩
    have ha : (1 : ℝ) ≤ (orb Γ z).card := by exact_mod_cast ha1
    set a : ℝ := ((orb Γ z).card : ℝ) with ha_def
    have hb := mN_le_class hfp z
    have hb' : 2 * X ≤ Fc Γ z * (a - 1 / 2) ^ 2 := by
      have h2 : (2 * ((orb Γ z).card.choose 2) : ℝ) = a * (a - 1) := by
        rw [Nat.cast_choose_two]; ring
      have : (2 * mN Γ : ℝ) ≤ 2 * (Fc Γ z * (orb Γ z).card.choose 2) := by
        unfold Fc; exact_mod_cast Nat.mul_le_mul_left 2 hb
      have hF0 : (0 : ℝ) ≤ Fc Γ z := hF.le
      nlinarith
    have hs : Real.sqrt (2 * X) ≤ Real.sqrt (Fc Γ z) * (a - 1 / 2) := by
      rw [← Real.sqrt_sq (show (0 : ℝ) ≤ a - 1 / 2 by linarith), ← Real.sqrt_mul hF.le]
      exact Real.sqrt_le_sqrt hb'
    have hpos : 0 < Real.sqrt (Fc Γ z) * a := mul_pos (Real.sqrt_pos.mpr hF) (by linarith)
    rw [mul_one_div, div_le_iff₀ hpos]
    have : (1 - 1 / (2 * a)) * (Real.sqrt (Fc Γ z) * a) = Real.sqrt (Fc Γ z) * (a - 1 / 2) := by
      field_simp
    linarith
  have hsum : Real.sqrt (2 * X) * W Γ ≤ n - ∑ z : V, 1 / (2 * (orb Γ z).card : ℝ) := by
    unfold W; rw [mul_sum]
    calc ∑ z, Real.sqrt (2 * X) * (1 / (Real.sqrt (Fc Γ z) * (orb Γ z).card))
        ≤ ∑ z : V, (1 - 1 / (2 * (orb Γ z).card : ℝ)) := sum_le_sum (fun z _ => hpt z)
      _ = n - ∑ z : V, 1 / (2 * (orb Γ z).card : ℝ) := by rw [sum_sub_distrib]; simp [n]
  -- two orbits contribute 1/2 each
  have htwo : 1 ≤ ∑ z : V, 1 / (2 * (orb Γ z).card : ℝ) := by
    have hdisj : Disjoint (orb Γ x) (orb Γ y) := by
      rw [disjoint_left]; intro z hz hz'
      exact hxy ((orb_eq_of_mem hz).symm.trans (orb_eq_of_mem hz'))
    have e : ∀ z : V, 1 / (2 * (orb Γ z).card : ℝ) = (1 / 2) * (1 / (orb Γ z).card) := by
      intro z; field_simp
    simp_rw [e, ← mul_sum]
    have : ∑ z ∈ orb Γ x ∪ orb Γ y, (1 : ℝ) / (orb Γ z).card ≤ ∑ z : V, (1 : ℝ) / (orb Γ z).card :=
      sum_le_sum_of_subset_of_nonneg (subset_univ _) (fun _ _ _ => by positivity)
    rw [sum_union hdisj, sum_orb_inv, sum_orb_inv] at this
    linarith
  have hW0 : 0 ≤ W Γ := sum_nonneg (fun _ _ => by positivity)
  have hn2 : (2 : ℝ) ≤ n := by
    have : 2 ≤ Fintype.card V := by
      have : (orb Γ x ∪ orb Γ y).card ≤ Fintype.card V := card_le_univ _
      have hd : Disjoint (orb Γ x) (orb Γ y) := by
        rw [disjoint_left]; intro z hz hz'
        exact hxy ((orb_eq_of_mem hz).symm.trans (orb_eq_of_mem hz'))
      rw [card_union_of_disjoint hd] at this
      have := card_pos.mpr ⟨x, self_mem_orb Γ x⟩
      have := card_pos.mpr ⟨y, self_mem_orb Γ y⟩
      omega
    show (2 : ℝ) ≤ (Fintype.card V : ℝ)
    exact_mod_cast this
  have h1 : Real.sqrt (2 * X) * W Γ ≤ n - 1 := by linarith
  have h2 : (Real.sqrt (2 * X) * W Γ) ^ 2 ≤ (n - 1) ^ 2 :=
    pow_le_pow_left₀ (mul_nonneg (Real.sqrt_nonneg _) hW0) h1 2
  rw [mul_pow, Real.sq_sqrt (by positivity)] at h2
  nlinarith

/-! ## Reading off the classes from W -/

/-- Points in pairwise distinct classes contribute their √F's to W. -/
theorem W_ge_sum {Γ : Subgroup (Perm V)} (hfp : FPF Γ) (S : Finset V)
    (hS : ∀ x ∈ S, ∀ y ∈ S, clsPts Γ x = clsPts Γ y → x = y) :
    ∑ x ∈ S, Real.sqrt (Fc Γ x) ≤ W Γ := by
  obtain ⟨hW, hC⟩ := W_eq hfp
  rw [hW]
  set g := fun C : Finset V => ∑ x ∈ C, 1 / (Real.sqrt (Fc Γ x) * (orb Γ x).card)
  have hsum : ∑ x ∈ S, Real.sqrt (Fc Γ x) = ∑ C ∈ S.image (clsPts Γ), g C := by
    rw [sum_image (fun x hx y hy h => hS x hx y hy h)]
    refine sum_congr rfl (fun x _ => ?_)
    exact (hC _ (mem_image_of_mem _ (mem_univ x)) x (mem_clsPts_self Γ x)).symm
  rw [hsum]
  exact sum_le_sum_of_subset_of_nonneg (image_subset_image (subset_univ _))
    (fun _ _ _ => sum_nonneg (fun _ _ => by positivity))

theorem sqrt_Fc_ge_one (Γ : Subgroup (Perm V)) (x : V) : 1 ≤ Real.sqrt (Fc Γ x) := by
  rw [Real.one_le_sqrt]; exact_mod_cast Fc_pos Γ x

/-- **Step 3 at even n.**  A fixed-point-free intransitive Γ with m\*_N(Γ) ≥ C(n,2)/4 has a single
N\*-class, of F ≤ 3 orbits. -/
theorem intrans_quarter {Γ : Subgroup (Perm V)} (hfp : FPF Γ) {x y : V} (hxy : orb Γ x ≠ orb Γ y)
    (h : (Fintype.card V : ℝ) * (Fintype.card V - 1) ≤ 8 * mN Γ) :
    (∀ z, clsPts Γ z = clsPts Γ x) ∧ Fc Γ x ≤ 3 := by
  have hlt := mN_lt_intrans hfp hxy
  have hW0 : 0 ≤ W Γ := sum_nonneg (fun _ _ => by positivity)
  have hX : (0 : ℝ) < mN Γ := by
    by_contra h0; push Not at h0
    have : (mN Γ : ℝ) = 0 := le_antisymm h0 (by positivity)
    rw [this] at hlt h; nlinarith
  have hW2 : W Γ < 2 := by
    by_contra hc; push Not at hc
    have : 4 ≤ W Γ ^ 2 := by nlinarith
    nlinarith
  constructor
  · intro z
    by_contra hz
    have := W_ge_sum hfp {z, x} (by
      intro a ha b hb hab
      simp only [mem_insert, mem_singleton] at ha hb
      rcases ha with rfl | rfl <;> rcases hb with rfl | rfl
      · rfl
      · exact absurd hab hz
      · exact absurd hab.symm hz
      · rfl)
    have hzx : z ≠ x := by rintro rfl; exact hz rfl
    rw [sum_pair hzx] at this
    linarith [sqrt_Fc_ge_one Γ z, sqrt_Fc_ge_one Γ x]
  · by_contra hc; push Not at hc
    have := W_ge_sum hfp {x} (by simp)
    rw [sum_singleton] at this
    have : (2 : ℝ) ≤ Real.sqrt (Fc Γ x) := by
      rw [show (2 : ℝ) = Real.sqrt 4 by rw [show (4 : ℝ) = 2 ^ 2 by norm_num, Real.sqrt_sq (by norm_num)]]
      exact Real.sqrt_le_sqrt (by exact_mod_cast hc)
    linarith

/-- **Step 3 at odd n.**  A fixed-point-free intransitive Γ with m\*_N(Γ) ≥ (3 − 2√2)·C(n,2) has
either a single N\*-class of F ≤ 5 orbits, or exactly two classes, each a single orbit. -/
theorem intrans_silver {Γ : Subgroup (Perm V)} (hfp : FPF Γ) {x y : V} (hxy : orb Γ x ≠ orb Γ y)
    (h : (3 - 2 * Real.sqrt 2) * ((Fintype.card V : ℝ) * (Fintype.card V - 1)) ≤ 2 * mN Γ) :
    ((∀ z, clsPts Γ z = clsPts Γ x) ∧ Fc Γ x ≤ 5) ∨
    (∃ w, clsPts Γ w ≠ clsPts Γ x ∧ Fc Γ x = 1 ∧ Fc Γ w = 1 ∧
      ∀ z, clsPts Γ z = clsPts Γ x ∨ clsPts Γ z = clsPts Γ w) := by
  have hlt := mN_lt_intrans hfp hxy
  have hW0 : 0 ≤ W Γ := sum_nonneg (fun _ _ => by positivity)
  have s2 := Real.sq_sqrt (show (0 : ℝ) ≤ 2 by norm_num)
  have s2b : Real.sqrt 2 < 1.415 := by
    rw [Real.sqrt_lt' (by norm_num)]; norm_num
  have s2a : 1.4 < Real.sqrt 2 := by
    rw [Real.lt_sqrt (by norm_num)]; norm_num
  have hX : (0 : ℝ) < mN Γ := by
    by_contra h0; push Not at h0
    have : (mN Γ : ℝ) = 0 := le_antisymm h0 (by positivity)
    rw [this] at hlt h
    have : (0 : ℝ) < (Fintype.card V : ℝ) * (Fintype.card V - 1) := by nlinarith
    nlinarith
  -- W < 1 + √2, since (3 − 2√2)(1 + √2)² = 1
  have hW : W Γ < 1 + Real.sqrt 2 := by
    by_contra hc; push Not at hc
    have h1 : (1 + Real.sqrt 2) ^ 2 ≤ W Γ ^ 2 := pow_le_pow_left₀ (by positivity) hc 2
    have h2 : (3 - 2 * Real.sqrt 2) * (1 + Real.sqrt 2) ^ 2 = 1 := by nlinarith
    have h3 : 0 < 3 - 2 * Real.sqrt 2 := by nlinarith
    have : (Fintype.card V : ℝ) * (Fintype.card V - 1) ≤ 2 * mN Γ * W Γ ^ 2 := by
      calc (Fintype.card V : ℝ) * (Fintype.card V - 1)
          = (3 - 2 * Real.sqrt 2) * (1 + Real.sqrt 2) ^ 2 *
            ((Fintype.card V : ℝ) * (Fintype.card V - 1)) := by rw [h2, one_mul]
        _ ≤ 2 * mN Γ * (1 + Real.sqrt 2) ^ 2 := by nlinarith
        _ ≤ 2 * mN Γ * W Γ ^ 2 := by nlinarith
    linarith
  have two : ∀ a b : V, clsPts Γ a ≠ clsPts Γ b →
      Real.sqrt (Fc Γ a) + Real.sqrt (Fc Γ b) ≤ W Γ := by
    intro a b hab
    have hne : a ≠ b := by rintro rfl; exact hab rfl
    have := W_ge_sum hfp {a, b} (by
      intro u hu v hv huv
      simp only [mem_insert, mem_singleton] at hu hv
      rcases hu with rfl | rfl <;> rcases hv with rfl | rfl
      · rfl
      · exact absurd huv hab
      · exact absurd huv.symm hab
      · rfl)
    rwa [sum_pair hne] at this
  have sqF : ∀ a : V, 2 ≤ Fc Γ a → Real.sqrt 2 ≤ Real.sqrt (Fc Γ a) :=
    fun a ha => Real.sqrt_le_sqrt (by exact_mod_cast ha)
  by_cases hone : ∀ z, clsPts Γ z = clsPts Γ x
  · left
    refine ⟨hone, ?_⟩
    by_contra hc; push Not at hc
    have := W_ge_sum hfp {x} (by simp)
    rw [sum_singleton] at this
    have : Real.sqrt 6 ≤ Real.sqrt (Fc Γ x) := Real.sqrt_le_sqrt (by exact_mod_cast hc)
    have : (2.44 : ℝ) < Real.sqrt 6 := by rw [Real.lt_sqrt (by norm_num)]; norm_num
    linarith
  · right
    push Not at hone
    obtain ⟨w, hw⟩ := hone
    have hF1 : ∀ a b : V, clsPts Γ a ≠ clsPts Γ b → Fc Γ a = 1 := by
      intro a b hab
      by_contra hc
      have := Fc_pos Γ a
      have := two a b hab
      have := sqF a (by omega)
      linarith [sqrt_Fc_ge_one Γ b]
    refine ⟨w, hw, hF1 x w (Ne.symm hw), hF1 w x hw, fun z => ?_⟩
    by_contra hz; push Not at hz
    obtain ⟨hzx, hzw⟩ := hz
    have hne1 : z ≠ x := by rintro rfl; exact hzx rfl
    have hne2 : z ≠ w := by rintro rfl; exact hzw rfl
    have hne3 : x ≠ w := by rintro rfl; exact hw rfl
    have := W_ge_sum hfp {z, x, w} (by
      intro u hu v hv huv
      simp only [mem_insert, mem_singleton] at hu hv
      rcases hu with rfl | rfl | rfl <;> rcases hv with rfl | rfl | rfl <;>
        first | rfl | exact absurd huv ‹_› | exact absurd huv.symm ‹_›)
    rw [sum_insert (by simp [hne1, hne2]), sum_pair hne3] at this
    linarith [sqrt_Fc_ge_one Γ z, sqrt_Fc_ge_one Γ x, sqrt_Fc_ge_one Γ w]

/-! ## Splitting halves the bound -/

/-- The orbitals lying inside a set of pairs. -/
noncomputable def orbitalsIn (Γ : Subgroup (Perm V)) (S : Finset (Sym2 V)) : Finset (Finset (Sym2 V)) :=
  (orbitals Γ).filter (· ⊆ S)

/-- The orbitals inside S form a single type: no proper nonempty N\*-invariant subset. -/
def SingleType (Γ : Subgroup (Perm V)) (S : Finset (Sym2 V)) : Prop :=
  ∀ T ⊆ orbitalsIn Γ S, T.Nonempty → NInv Γ T → T = orbitalsIn Γ S

theorem orbitals_disj {Γ : Subgroup (Perm V)} {o o' : Finset (Sym2 V)} (ho : o ∈ orbitals Γ)
    (ho' : o' ∈ orbitals Γ) (hne : o ≠ o') : Disjoint o o' := by
  obtain ⟨e, -, rfl⟩ := mem_image.mp ho
  obtain ⟨e', -, rfl⟩ := mem_image.mp ho'
  rw [disjoint_left]
  intro z hz hz'
  exact hne ((orbit2_eq_of_mem hz).symm.trans (orbit2_eq_of_mem hz'))

/-- N\* preserves non-membership in an N\*-invariant set of orbitals. -/
theorem NInv_compl {Γ : Subgroup (Perm V)} {A T : Finset (Finset (Sym2 V))}
    (hAinv : NInv Γ A) (hT : NInv Γ T) : NInv Γ (A \ T) := by
  intro σ hσ o ho
  obtain ⟨hoA, hoT⟩ := mem_sdiff.mp ho
  refine mem_sdiff.mpr ⟨hAinv σ hσ o hoA, fun h => hoT ?_⟩
  have := hT σ⁻¹ (Nstar_inv hσ) _ h
  rwa [← img_mul, inv_mul_cancel, img_one] at this

/-- **Splitting halves it.**  If S is a set of pairs whose orbitals form an N\*-invariant set that is
not a single type, then 2·m\*_N(Γ) ≤ |S|. -/
theorem mN_half {Γ : Subgroup (Perm V)} {S : Finset (Sym2 V)} (hinv : NInv Γ (orbitalsIn Γ S))
    (hsplit : ¬ SingleType Γ S) : 2 * mN Γ ≤ S.card := by
  unfold SingleType at hsplit
  push Not at hsplit
  obtain ⟨T, hTsub, hTne, hTinv, hTne'⟩ := hsplit
  have hA : orbitalsIn Γ S ⊆ orbitals Γ := filter_subset _ _
  set T2 := orbitalsIn Γ S \ T
  have hT2ne : T2.Nonempty := by
    rw [sdiff_nonempty]; intro h; exact hTne' (subset_antisymm hTsub h)
  have hT2inv : NInv Γ T2 := NInv_compl hinv hTinv
  have h1 := mN_le_total Γ (hTsub.trans hA) hTne hTinv
  have h2 : mN Γ ≤ (T2.biUnion id).card := mN_le_total Γ (sdiff_subset.trans hA) hT2ne hT2inv
  -- the two unions are disjoint and lie in S
  have hdisj : Disjoint (T.biUnion id) (T2.biUnion id) := by
    rw [disjoint_biUnion_left]; intro o ho
    rw [disjoint_biUnion_right]; intro o' ho'
    have hne : o ≠ o' := by rintro rfl; exact (mem_sdiff.mp ho').2 ho
    exact orbitals_disj (hA (hTsub ho)) (hA (mem_sdiff.mp ho').1) hne
  have hsub : T.biUnion id ∪ T2.biUnion id ⊆ S := by
    apply union_subset
    · exact biUnion_subset.mpr (fun o ho => (mem_filter.mp (hTsub ho)).2)
    · exact biUnion_subset.mpr (fun o ho => (mem_filter.mp (mem_sdiff.mp ho).1).2)
  have := card_le_card hsub
  rw [card_union_of_disjoint hdisj] at this
  omega

/-- Pin is N\*-invariant at the level of orbitals. -/
theorem NInv_Pin {Γ : Subgroup (Perm V)} (hfp : FPF Γ) (x : V) : NInv Γ (orbitalsIn Γ (Pin Γ x)) := by
  intro τ hτ o ho
  obtain ⟨ho1, ho2⟩ := mem_filter.mp ho
  refine mem_filter.mpr ⟨hτ o ho1, ?_⟩
  intro e he
  obtain ⟨e', he', rfl⟩ := mem_image.mp he
  exact map_Pin hfp hτ (ho2 he')

/-! ## Step 2 as a named hypothesis, and the intransitive ceiling -/

/-- **Step 2 of §6.3, as a hypothesis** (a `structure`, never an `axiom`): for a fixed-point-free
Oliver Γ, if the orbitals inside an N\*-class form a single type, its orbits have prime-power size.
(The text: a type taking in all pairs of an orbit O makes N\*_O 2-homogeneous on O; the affine case
gives a prime power directly, the almost-simple case through the socle's 2-homogeneity, checked to
degree 877 and in the infinite families, and solvability.) -/
structure HypStep2 (V : Type*) [Fintype V] [DecidableEq V] : Prop where
  prime_pow : ∀ Γ : Subgroup (Perm V), FPF Γ →
    (∃ p q : ℕ, p.Prime ∧ q.Prime ∧ Nonempty (Chain.OliverChain Γ p q)) →
    ∀ x, SingleType Γ (Pin Γ x) → IsPrimePow (orb Γ x).card

theorem orb_mem_cls {Γ : Subgroup (Perm V)} {x y : V} (hy : y ∈ clsPts Γ x) : orb Γ y ∈ cls Γ x := by
  obtain ⟨σ, hσ, rfl⟩ := mem_clsPts.mp hy
  exact mem_image.mpr ⟨σ, mem_filter.mpr ⟨mem_univ _, hσ⟩, rfl⟩

/-- In a single class holding all points: n = F·a, F ≥ 2 if Γ is intransitive. -/
theorem single_class {Γ : Subgroup (Perm V)} (hfp : FPF Γ) {x y : V} (hxy : orb Γ x ≠ orb Γ y)
    (hall : ∀ z, clsPts Γ z = clsPts Γ x) :
    Fintype.card V = Fc Γ x * (orb Γ x).card ∧ 2 ≤ Fc Γ x := by
  have huniv : clsPts Γ x = univ := by
    ext z; simp only [mem_univ, iff_true]; rw [← hall z]; exact mem_clsPts_self Γ z
  refine ⟨by rw [← card_clsPts hfp, huniv, card_univ], ?_⟩
  have hy : y ∈ clsPts Γ x := by rw [huniv]; exact mem_univ _
  have h1 : orb Γ x ∈ cls Γ x := orb_mem_cls (mem_clsPts_self Γ x)
  have h2 : orb Γ y ∈ cls Γ x := orb_mem_cls hy
  unfold Fc
  have : ({orb Γ x, orb Γ y} : Finset (Finset V)) ⊆ cls Γ x := by
    intro O hO; simp only [mem_insert, mem_singleton] at hO; rcases hO with rfl | rfl <;> assumption
  have := card_le_card this
  rw [card_pair hxy] at this; exact this

/-- **The intransitive ceiling at even n.**  A fixed-point-free intransitive Oliver Γ with
m\*_N(Γ) ≥ C(n,2)/4 forces n into E's first clause: a prime-power a ∣ n, a < n, with
(a − 1)/(n − 1) ≥ 1/4.  (Given Step 2.) -/
theorem intrans_even (H2 : HypStep2 V) {Γ : Subgroup (Perm V)} (hfp : FPF Γ)
    (hOl : ∃ p q : ℕ, p.Prime ∧ q.Prime ∧ Nonempty (Chain.OliverChain Γ p q))
    {x y : V} (hxy : orb Γ x ≠ orb Γ y)
    (h : (Fintype.card V : ℝ) * (Fintype.card V - 1) ≤ 8 * mN Γ) :
    ∃ a, IsPrimePow a ∧ a ∣ Fintype.card V ∧ a < Fintype.card V ∧
      Fintype.card V - 1 ≤ 4 * (a - 1) := by
  obtain ⟨hall, hF3⟩ := intrans_quarter hfp hxy h
  obtain ⟨hn, hF2⟩ := single_class hfp hxy hall
  set F := Fc Γ x
  set a := (orb Γ x).card
  have ha1 : 1 ≤ a := card_pos.mpr ⟨x, self_mem_orb Γ x⟩
  have hPin : (Pin Γ x).card ≤ F * a.choose 2 := card_Pin_le hfp x
  have hca : (2 * a.choose 2 : ℝ) = a * (a - 1) := by rw [Nat.cast_choose_two]; ring
  have hnR : (Fintype.card V : ℝ) = F * a := by rw [hn]; push_cast; ring
  have aR : (1 : ℝ) ≤ a := by exact_mod_cast ha1
  have FR : (2 : ℝ) ≤ F := by exact_mod_cast hF2
  by_cases hst : SingleType Γ (Pin Γ x)
  · have hpp := H2.prime_pow Γ hfp hOl x hst
    refine ⟨a, hpp, ⟨F, by rw [hn, mul_comm]⟩, ?_, ?_⟩
    · rw [hn]; nlinarith
    · have hb : (mN Γ : ℝ) ≤ F * a.choose 2 := by exact_mod_cast mN_le_class hfp x
      rw [hnR] at h
      have : (F * a : ℝ) * (F * a - 1) ≤ 4 * (F * a) * (a - 1) := by nlinarith
      have hpos : (0 : ℝ) < F * a := by positivity
      have : (F * a : ℝ) - 1 ≤ 4 * (a - 1) := by nlinarith
      have e : ((Fintype.card V - 1 : ℕ) : ℝ) = F * a - 1 := by
        rw [Nat.cast_sub (by rw [hn]; nlinarith), hnR]; simp
      have e2 : ((4 * (a - 1) : ℕ) : ℝ) = 4 * (a - 1) := by
        rw [Nat.cast_mul, Nat.cast_sub ha1]; simp
      exact_mod_cast (show ((Fintype.card V - 1 : ℕ) : ℝ) ≤ ((4 * (a - 1) : ℕ) : ℝ) by rw [e, e2]; exact this)
  · exfalso
    have hh := mN_half (NInv_Pin hfp x) hst
    have : (2 * mN Γ : ℝ) ≤ F * a.choose 2 := by exact_mod_cast le_trans hh hPin
    rw [hnR] at h
    have k : (F * a : ℝ) * (F * a - 1) ≤ (F * a) * (2 * (a - 1)) := by nlinarith
    have hpos : (0 : ℝ) < F * a := by positivity
    have k2 : (F * a : ℝ) - 1 ≤ 2 * (a - 1) := le_of_mul_le_mul_left k hpos
    nlinarith

theorem three_sub_two_sqrt_two :
    (3 - 2 * Real.sqrt 2) * (1 + Real.sqrt 2) ^ 2 = 1 := by
  have := Real.sq_sqrt (show (0 : ℝ) ≤ 2 by norm_num); nlinarith

/-- (3 − 2√2)·N is never a nonzero integer equal to... : (3 − 2√2)·N = M with N ≠ 0 is impossible. -/
theorem silver_irr {N M : ℕ} (hN : N ≠ 0) : (3 - 2 * Real.sqrt 2) * N ≠ M := by
  intro h
  have hs : Real.sqrt 2 = ((3 * N - M : ℤ) : ℝ) / ((2 * N : ℤ) : ℝ) := by
    have h0 : ((2 * N : ℤ) : ℝ) ≠ 0 := by push_cast; positivity
    rw [eq_div_iff h0]; push_cast; linarith
  exact irrational_sqrt_two ⟨((3 * N - M : ℤ) : ℚ) / ((2 * N : ℤ) : ℚ), by rw [hs]; push_cast; rfl⟩

/-- Two orbits a + b = n with 4X ≤ a(a − 1), 2X ≤ b(b − 1) and X > 0: 2X(1 + √2)² < n(n − 1). -/
theorem two_orbit_strict {a b : ℕ} {X : ℝ} (hX : 0 < X) (ha : 4 * X ≤ a * ((a : ℝ) - 1))
    (hb : 2 * X ≤ b * ((b : ℝ) - 1)) :
    2 * X * (1 + Real.sqrt 2) ^ 2 < ((a + b : ℕ) : ℝ) * (((a + b : ℕ) : ℝ) - 1) := by
  push_cast
  have s2 := Real.sq_sqrt (show (0 : ℝ) ≤ 2 by norm_num)
  have s2p : 0 < Real.sqrt 2 := by positivity
  set t := Real.sqrt X
  have ht : t ^ 2 = X := Real.sq_sqrt hX.le
  have ht0 : 0 < t := Real.sqrt_pos.mpr hX
  have a0 : (0 : ℝ) ≤ a := by positivity
  have b0 : (0 : ℝ) ≤ b := by positivity
  -- a − 1/2 > 2t and b − 1/2 > √2·t
  have ea : 2 * t < a - 1 / 2 := by
    have : (2 * t) ^ 2 < ((a : ℝ) - 1 / 2) ^ 2 := by nlinarith
    rcases le_or_gt ((a : ℝ) - 1 / 2) 0 with h | h
    · nlinarith
    · exact (pow_lt_pow_iff_left₀ (by positivity) h.le two_ne_zero).mp this
  have eb : Real.sqrt 2 * t < b - 1 / 2 := by
    have : (Real.sqrt 2 * t) ^ 2 < ((b : ℝ) - 1 / 2) ^ 2 := by rw [mul_pow, s2]; nlinarith
    rcases le_or_gt ((b : ℝ) - 1 / 2) 0 with h | h
    · nlinarith
    · exact (pow_lt_pow_iff_left₀ (by positivity) h.le two_ne_zero).mp this
  have hn : Real.sqrt 2 * (1 + Real.sqrt 2) * t < a + b - 1 := by nlinarith
  have hsq : (Real.sqrt 2 * (1 + Real.sqrt 2) * t) ^ 2 < ((a : ℝ) + b - 1) ^ 2 :=
    pow_lt_pow_left₀ hn (by positivity) two_ne_zero
  have : (Real.sqrt 2 * (1 + Real.sqrt 2) * t) ^ 2 = 2 * X * (1 + Real.sqrt 2) ^ 2 := by
    rw [mul_pow, mul_pow, s2, ht]; ring
  nlinarith

/-- **The intransitive ceiling at odd n.**  A fixed-point-free intransitive Oliver Γ on an odd
number n of points with m\*_N(Γ) ≥ (3 − 2√2)·C(n,2) forces n into E: either a prime-power a ∣ n,
a < n, with (a − 1)/(n − 1) ≥ 3 − 2√2 (first clause), or n = a + b with a, b prime powers and
both C(a,2), C(b,2) above (3 − 2√2)·C(n,2) (second clause).  (Given Step 2.) -/
theorem intrans_odd (H2 : HypStep2 V) {Γ : Subgroup (Perm V)} (hfp : FPF Γ)
    (hOl : ∃ p q : ℕ, p.Prime ∧ q.Prime ∧ Nonempty (Chain.OliverChain Γ p q))
    (hodd : Fintype.card V % 2 = 1) {x y : V} (hxy : orb Γ x ≠ orb Γ y)
    (h : (3 - 2 * Real.sqrt 2) * ((Fintype.card V : ℝ) * (Fintype.card V - 1)) ≤ 2 * mN Γ) :
    (∃ a, IsPrimePow a ∧ a ∣ Fintype.card V ∧ a < Fintype.card V ∧
      (3 - 2 * Real.sqrt 2) * ((Fintype.card V : ℝ) - 1) ≤ (a : ℝ) - 1) ∨
    (∃ a b, IsPrimePow a ∧ IsPrimePow b ∧ a + b = Fintype.card V ∧
      (3 - 2 * Real.sqrt 2) * ((Fintype.card V : ℝ) * (Fintype.card V - 1)) < a * ((a : ℝ) - 1) ∧
      (3 - 2 * Real.sqrt 2) * ((Fintype.card V : ℝ) * (Fintype.card V - 1)) < b * ((b : ℝ) - 1)) := by
  have s2 := Real.sq_sqrt (show (0 : ℝ) ≤ 2 by norm_num)
  have s2b : Real.sqrt 2 < 1.415 := by rw [Real.sqrt_lt' (by norm_num)]; norm_num
  have s2a : 1.414 < Real.sqrt 2 := by rw [Real.lt_sqrt (by norm_num)]; norm_num
  set δ := 3 - 2 * Real.sqrt 2 with hδ
  have hδ0 : 0 < δ := by rw [hδ]; linarith
  have hca : ∀ a : ℕ, (2 * a.choose 2 : ℝ) = a * (a - 1) := by
    intro a; rw [Nat.cast_choose_two]; ring
  rcases intrans_silver hfp hxy h with ⟨hall, hF5⟩ | ⟨w, hw, hFx, hFw, hzz⟩
  · -- one class of F ≤ 5 orbits; n odd makes F ≥ 3
    obtain ⟨hn, hF2⟩ := single_class hfp hxy hall
    set F := Fc Γ x
    set a := (orb Γ x).card
    have ha1 : 1 ≤ a := card_pos.mpr ⟨x, self_mem_orb Γ x⟩
    have hF3 : 3 ≤ F := by
      by_contra hc
      have : F = 2 := by omega
      rw [hn, this] at hodd; omega
    have hnR : (Fintype.card V : ℝ) = F * a := by rw [hn]; push_cast; ring
    have aR : (1 : ℝ) ≤ a := by exact_mod_cast ha1
    have FR : (3 : ℝ) ≤ F := by exact_mod_cast hF3
    have hpos : (0 : ℝ) < F * a := by positivity
    by_cases hst : SingleType Γ (Pin Γ x)
    · left
      refine ⟨a, H2.prime_pow Γ hfp hOl x hst, ⟨F, by rw [hn, mul_comm]⟩, by rw [hn]; nlinarith, ?_⟩
      have hb : (mN Γ : ℝ) ≤ F * a.choose 2 := by exact_mod_cast mN_le_class hfp x
      have := hca a
      rw [hnR] at h ⊢
      have k : (F * a : ℝ) * (δ * (F * a - 1)) ≤ (F * a) * (a - 1) := by nlinarith
      exact le_of_mul_le_mul_left k hpos
    · exfalso
      have hh := mN_half (NInv_Pin hfp x) hst
      have : (2 * mN Γ : ℝ) ≤ F * a.choose 2 := by
        exact_mod_cast le_trans hh (card_Pin_le hfp x)
      have := hca a
      rw [hnR] at h
      have k : (F * a : ℝ) * (2 * δ * (F * a - 1)) ≤ (F * a) * (a - 1) := by nlinarith
      have k2 : 2 * δ * ((F : ℝ) * a - 1) ≤ a - 1 := le_of_mul_le_mul_left k hpos
      nlinarith
  · -- two classes, each one orbit
    set a := (orb Γ x).card
    set b := (orb Γ w).card
    have hdisj : Disjoint (clsPts Γ x) (clsPts Γ w) := by
      rw [disjoint_left]; intro z hz hz'
      exact hw ((clsPts_eq_of_mem hz').symm.trans (clsPts_eq_of_mem hz))
    have hcover : clsPts Γ x ∪ clsPts Γ w = univ := by
      ext z; simp only [mem_union, mem_univ, iff_true]
      rcases hzz z with h1 | h1
      · left; rw [← h1]; exact mem_clsPts_self Γ z
      · right; rw [← h1]; exact mem_clsPts_self Γ z
    have hn : a + b = Fintype.card V := by
      rw [← card_univ, ← hcover, card_union_of_disjoint hdisj, card_clsPts hfp, card_clsPts hfp,
        hFx, hFw, one_mul, one_mul]
    have hax : mN Γ ≤ a.choose 2 := by
      have := mN_le_class hfp x; rwa [show (cls Γ x).card = 1 from hFx, one_mul] at this
    have hbw : mN Γ ≤ b.choose 2 := by
      have := mN_le_class hfp w; rwa [show (cls Γ w).card = 1 from hFw, one_mul] at this
    have hPx : (Pin Γ x).card ≤ a.choose 2 := by
      have := card_Pin_le hfp x; rwa [show (cls Γ x).card = 1 from hFx, one_mul] at this
    have hPw : (Pin Γ w).card ≤ b.choose 2 := by
      have := card_Pin_le hfp w; rwa [show (cls Γ w).card = 1 from hFw, one_mul] at this
    have hnR : (Fintype.card V : ℝ) = (a + b : ℕ) := by rw [hn]
    have hn2 : 2 ≤ Fintype.card V := by
      have := card_pos.mpr ⟨x, self_mem_orb Γ x⟩
      have := card_pos.mpr ⟨w, self_mem_orb Γ w⟩
      omega
    have hNpos : (0 : ℝ) < (Fintype.card V : ℝ) * (Fintype.card V - 1) := by
      have : (2 : ℝ) ≤ Fintype.card V := by exact_mod_cast hn2
      nlinarith
    have hX : (0 : ℝ) < mN Γ := by nlinarith
    have ea := hca a
    have eb := hca b
    have key := three_sub_two_sqrt_two
    by_cases hsx : SingleType Γ (Pin Γ x)
    · by_cases hsw : SingleType Γ (Pin Γ w)
      · right
        refine ⟨a, b, H2.prime_pow Γ hfp hOl x hsx, H2.prime_pow Γ hfp hOl w hsw, hn, ?_, ?_⟩
        · have h1 : (2 * mN Γ : ℝ) ≤ 2 * a.choose 2 := by exact_mod_cast Nat.mul_le_mul_left 2 hax
          have hle : δ * ((Fintype.card V : ℝ) * (Fintype.card V - 1)) ≤ a * ((a : ℝ) - 1) := by
            linarith
          refine lt_of_le_of_ne hle ?_
          intro heq
          have hN0 : Fintype.card V * (Fintype.card V - 1) ≠ 0 := by
            have : 1 ≤ Fintype.card V - 1 := by omega
            positivity
          apply silver_irr hN0 (M := 2 * a.choose 2)
          rw [Nat.cast_mul, Nat.cast_sub (by omega)]; push_cast; rw [heq, ← ea]
        · have h1 : (2 * mN Γ : ℝ) ≤ 2 * b.choose 2 := by exact_mod_cast Nat.mul_le_mul_left 2 hbw
          have hle : δ * ((Fintype.card V : ℝ) * (Fintype.card V - 1)) ≤ b * ((b : ℝ) - 1) := by
            linarith
          refine lt_of_le_of_ne hle ?_
          intro heq
          have hN0 : Fintype.card V * (Fintype.card V - 1) ≠ 0 := by
            have : 1 ≤ Fintype.card V - 1 := by omega
            positivity
          apply silver_irr hN0 (M := 2 * b.choose 2)
          rw [Nat.cast_mul, Nat.cast_sub (by omega)]; push_cast; rw [heq, ← eb]
      · exfalso
        have hh := le_trans (mN_half (NInv_Pin hfp w) hsw) hPw
        have h4 : 4 * (mN Γ : ℝ) ≤ b * ((b : ℝ) - 1) := by
          have : (2 * mN Γ : ℝ) ≤ b.choose 2 := by exact_mod_cast hh
          linarith
        have h2' : 2 * (mN Γ : ℝ) ≤ a * ((a : ℝ) - 1) := by
          have : (mN Γ : ℝ) ≤ a.choose 2 := by exact_mod_cast hax
          linarith
        have := two_orbit_strict hX h4 h2'
        rw [add_comm b a, ← hnR] at this
        nlinarith
    · exfalso
      have hh := le_trans (mN_half (NInv_Pin hfp x) hsx) hPx
      have h4 : 4 * (mN Γ : ℝ) ≤ a * ((a : ℝ) - 1) := by
        have : (2 * mN Γ : ℝ) ≤ a.choose 2 := by exact_mod_cast hh
        linarith
      have h2' : 2 * (mN Γ : ℝ) ≤ b * ((b : ℝ) - 1) := by
        have : (mN Γ : ℝ) ≤ b.choose 2 := by exact_mod_cast hbw
        linarith
      have := two_orbit_strict hX h4 h2'
      rw [← hnR] at this
      nlinarith

/-! ## The transitive case through Conjecture P, and Proposition U_typ -/

/-- Γ is transitive. -/
def Trans (Γ : Subgroup (Perm V)) : Prop := ∀ x y : V, ∃ g ∈ Γ, g x = y

/-- **Conjecture P of §6.3, as a hypothesis** (a `structure`, never an `axiom`): a transitive Oliver
Γ of non-prime-power degree n has m\*_typ(Γ) ≤ n(a − 1)/2 for a prime-power divisor a of n (the
text states it with a = q(n), the largest; this form is equivalent).  The text proves it through
Steps 4 and 5, given CFSG and the results cited there, pending an independent read. -/
structure HypConjP (V : Type*) [Fintype V] [DecidableEq V] : Prop where
  bound : ∀ Γ : Subgroup (Perm V), Trans Γ →
    (∃ p q : ℕ, p.Prime ∧ q.Prime ∧ Nonempty (Chain.OliverChain Γ p q)) →
    ¬ IsPrimePow (Fintype.card V) →
    ∃ a, IsPrimePow a ∧ a ∣ Fintype.card V ∧ 2 * mtyp Γ ≤ Fintype.card V * (a - 1)

/-- E's first clause at level δ: a prime-power proper divisor a of n with (a − 1)/(n − 1) ≥ δ. -/
def E1 (δ : ℝ) (n : ℕ) : Prop :=
  ∃ a, IsPrimePow a ∧ a ∣ n ∧ a < n ∧ δ * ((n : ℝ) - 1) ≤ (a : ℝ) - 1

/-- E's second clause at level δ: n = a + b, a and b prime powers, C(a,2), C(b,2) > δ·C(n,2). -/
def E2 (δ : ℝ) (n : ℕ) : Prop :=
  ∃ a b, IsPrimePow a ∧ IsPrimePow b ∧ a + b = n ∧
    δ * ((n : ℝ) * (n - 1)) < a * ((a : ℝ) - 1) ∧ δ * ((n : ℝ) * (n - 1)) < b * ((b : ℝ) - 1)

theorem trans_E1 (HP : HypConjP V) {Γ : Subgroup (Perm V)} (ht : Trans Γ)
    (hOl : ∃ p q : ℕ, p.Prime ∧ q.Prime ∧ Nonempty (Chain.OliverChain Γ p q))
    (hnp : ¬ IsPrimePow (Fintype.card V)) (hn2 : 2 ≤ Fintype.card V) {δ : ℝ}
    (h : δ * ((Fintype.card V : ℝ) * (Fintype.card V - 1)) ≤ 2 * mN Γ) : E1 δ (Fintype.card V) := by
  obtain ⟨a, hpp, hdvd, hb⟩ := HP.bound Γ ht hOl hnp
  have hle := mN_le_mtyp Γ hn2
  have ha1 : 1 ≤ a := hpp.one_lt.le
  refine ⟨a, hpp, hdvd, lt_of_le_of_ne (Nat.le_of_dvd (by omega) hdvd) (fun e => hnp (e ▸ hpp)), ?_⟩
  have hb' : (2 * mN Γ : ℝ) ≤ (Fintype.card V : ℝ) * ((a : ℝ) - 1) := by
    have : 2 * mN Γ ≤ Fintype.card V * (a - 1) := le_trans (Nat.mul_le_mul_left 2 hle) hb
    have e : ((Fintype.card V * (a - 1) : ℕ) : ℝ) = (Fintype.card V : ℝ) * ((a : ℝ) - 1) := by
      rw [Nat.cast_mul, Nat.cast_sub ha1]; simp
    rw [← e]; exact_mod_cast this
  have hpos : (0 : ℝ) < Fintype.card V := by exact_mod_cast (show 0 < Fintype.card V by omega)
  have k : (Fintype.card V : ℝ) * (δ * ((Fintype.card V : ℝ) - 1)) ≤
      (Fintype.card V : ℝ) * ((a : ℝ) - 1) := by nlinarith
  exact le_of_mul_le_mul_left k hpos

/-- **Proposition U_typ at even n** (given Step 2 and Conjecture P): a fixed-point-free Oliver Γ
on n points, n not a prime power, has m\*_N(Γ) < C(n,2)/4 unless n is in E's first clause. -/
theorem Utyp_even (H2 : HypStep2 V) (HP : HypConjP V) {Γ : Subgroup (Perm V)} (hfp : FPF Γ)
    (hOl : ∃ p q : ℕ, p.Prime ∧ q.Prime ∧ Nonempty (Chain.OliverChain Γ p q))
    (hnp : ¬ IsPrimePow (Fintype.card V)) (hn2 : 2 ≤ Fintype.card V)
    (hnE : ¬ E1 (1 / 4) (Fintype.card V)) :
    8 * (mN Γ : ℝ) < (Fintype.card V : ℝ) * (Fintype.card V - 1) := by
  by_contra hc; push Not at hc
  by_cases ht : Trans Γ
  · exact hnE (trans_E1 HP ht hOl hnp hn2 (by linarith))
  · unfold Trans at ht; push Not at ht
    obtain ⟨x, y, hxy⟩ := ht
    have ho : orb Γ x ≠ orb Γ y := by
      intro he
      have : y ∈ orb Γ x := he ▸ self_mem_orb Γ y
      obtain ⟨g, hg, rfl⟩ := mem_orb.mp this
      exact hxy g hg rfl
    obtain ⟨a, hpp, hdvd, hlt, hle⟩ := intrans_even H2 hfp hOl ho hc
    apply hnE
    refine ⟨a, hpp, hdvd, hlt, ?_⟩
    have ha1 : 1 ≤ a := hpp.one_lt.le
    have : ((Fintype.card V - 1 : ℕ) : ℝ) ≤ ((4 * (a - 1) : ℕ) : ℝ) := by exact_mod_cast hle
    rw [Nat.cast_sub (by omega), Nat.cast_mul, Nat.cast_sub ha1] at this
    push_cast at this; linarith

/-- **Proposition U_typ at odd n** (given Step 2 and Conjecture P): a fixed-point-free Oliver Γ on
an odd number n of points, n not a prime power, has m\*_N(Γ) < (3 − 2√2)·C(n,2) unless n ∈ E. -/
theorem Utyp_odd (H2 : HypStep2 V) (HP : HypConjP V) {Γ : Subgroup (Perm V)} (hfp : FPF Γ)
    (hOl : ∃ p q : ℕ, p.Prime ∧ q.Prime ∧ Nonempty (Chain.OliverChain Γ p q))
    (hnp : ¬ IsPrimePow (Fintype.card V)) (hn2 : 2 ≤ Fintype.card V)
    (hodd : Fintype.card V % 2 = 1)
    (hnE : ¬ E1 (3 - 2 * Real.sqrt 2) (Fintype.card V) ∧ ¬ E2 (3 - 2 * Real.sqrt 2) (Fintype.card V)) :
    2 * (mN Γ : ℝ) < (3 - 2 * Real.sqrt 2) * ((Fintype.card V : ℝ) * (Fintype.card V - 1)) := by
  by_contra hc; push Not at hc
  by_cases ht : Trans Γ
  · exact hnE.1 (trans_E1 HP ht hOl hnp hn2 hc)
  · unfold Trans at ht; push Not at ht
    obtain ⟨x, y, hxy⟩ := ht
    have ho : orb Γ x ≠ orb Γ y := by
      intro he
      have : y ∈ orb Γ x := he ▸ self_mem_orb Γ y
      obtain ⟨g, hg, rfl⟩ := mem_orb.mp this
      exact hxy g hg rfl
    rcases intrans_odd H2 hfp hOl hodd ho hc with h1 | h2
    · exact hnE.1 h1
    · exact hnE.2 h2

/-! ## Step 4: Γ transitive, N\* imprimitive -/

/-- An N\*-invariant pair set: generic bound and its orbital set's invariance. -/
theorem NInv_of_inv {Γ : Subgroup (Perm V)} {S : Finset (Sym2 V)}
    (hS : ∀ σ ∈ Nstar Γ, ∀ e ∈ S, Sym2.map σ e ∈ S) : NInv Γ (orbitalsIn Γ S) := by
  intro τ hτ o ho
  obtain ⟨ho1, ho2⟩ := mem_filter.mp ho
  refine mem_filter.mpr ⟨hτ o ho1, ?_⟩
  intro e he
  obtain ⟨e', he', rfl⟩ := mem_image.mp he
  exact hS τ hτ _ (ho2 he')

theorem mN_le_inv {Γ : Subgroup (Perm V)} {S : Finset (Sym2 V)}
    (hS : ∀ σ ∈ Nstar Γ, ∀ e ∈ S, Sym2.map σ e ∈ S) {e : Sym2 V} (he : e ∈ S) (hd : ¬ e.IsDiag) :
    mN Γ ≤ S.card := by
  have hsub : D2.orbit2 Γ e ⊆ S := by
    intro z hz
    obtain ⟨g, hg, rfl⟩ := mem_orbit2.mp hz
    exact hS g (mem_Nstar_of_mem hg) e he
  have hne : (orbitalsIn Γ S).Nonempty :=
    ⟨D2.orbit2 Γ e, mem_filter.mpr ⟨mem_image.mpr ⟨e, by simp [hd], rfl⟩, hsub⟩⟩
  calc mN Γ ≤ ((orbitalsIn Γ S).biUnion id).card :=
        mN_le_total Γ (filter_subset _ _) hne (NInv_of_inv hS)
    _ ≤ S.card := card_le_card (biUnion_subset.mpr (fun o ho => (mem_filter.mp ho).2))

/-- **A block system of N\***: a partition of the points into blocks of one size b ≥ 2, carried
into itself by N\*. -/
structure BlockSys (Γ : Subgroup (Perm V)) (B : Finset (Finset V)) (b : ℕ) : Prop where
  cover : B.biUnion id = univ
  disj : ∀ X ∈ B, ∀ Y ∈ B, X ≠ Y → Disjoint X Y
  size : ∀ X ∈ B, X.card = b
  b2 : 2 ≤ b
  inv : ∀ σ ∈ Nstar Γ, ∀ X ∈ B, X.image σ ∈ B

theorem BlockSys.card {Γ : Subgroup (Perm V)} {B : Finset (Finset V)} {b : ℕ} (h : BlockSys Γ B b) :
    Fintype.card V = B.card * b := by
  rw [← card_univ, ← h.cover]
  have := card_biUnion (s := B) (t := id) (fun X hX Y hY hne => h.disj X hX Y hY hne)
  rw [this]; simp only [id]; rw [sum_congr rfl h.size, sum_const, smul_eq_mul]

/-- The pairs inside the blocks. -/
noncomputable def PB (B : Finset (Finset V)) : Finset (Sym2 V) := B.biUnion pairsIn

theorem PB_inv {Γ : Subgroup (Perm V)} {B : Finset (Finset V)} {b : ℕ} (h : BlockSys Γ B b) :
    ∀ σ ∈ Nstar Γ, ∀ e ∈ PB B, Sym2.map σ e ∈ PB B := by
  intro σ hσ e he
  obtain ⟨X, hX, heX⟩ := mem_biUnion.mp he
  exact mem_biUnion.mpr ⟨X.image σ, h.inv σ hσ X hX, map_mem_pairsIn heX σ⟩

theorem card_PB_le {Γ : Subgroup (Perm V)} {B : Finset (Finset V)} {b : ℕ} (h : BlockSys Γ B b) :
    (PB B).card ≤ B.card * b.choose 2 := by
  unfold PB
  refine le_trans card_biUnion_le ?_
  rw [sum_congr rfl (fun X hX => by rw [card_pairsIn, h.size X hX]), sum_const, smul_eq_mul]

theorem PB_nondiag {Γ : Subgroup (Perm V)} {B : Finset (Finset V)} {b : ℕ} (h : BlockSys Γ B b)
    (hB : B.Nonempty) : ∃ e ∈ PB B, ¬ e.IsDiag := by
  obtain ⟨X, hX⟩ := hB
  have : 1 < X.card := by rw [h.size X hX]; have := h.b2; omega
  obtain ⟨u, hu, v, hv, huv⟩ := Finset.one_lt_card.mp this
  exact ⟨s(u, v), mem_biUnion.mpr ⟨X, hX, mk_mem_pairsIn hu hv huv⟩, by simp [huv]⟩

/-- **The intra-block bound**: m\*_N ≤ m·C(b,2) = n(b − 1)/2. -/
theorem mN_le_blocks {Γ : Subgroup (Perm V)} {B : Finset (Finset V)} {b : ℕ} (h : BlockSys Γ B b)
    (hB : B.Nonempty) : mN Γ ≤ B.card * b.choose 2 := by
  obtain ⟨e, he, hd⟩ := PB_nondiag h hB
  exact le_trans (mN_le_inv (PB_inv h) he hd) (card_PB_le h)

/-- **Step 2 for blocks, as a hypothesis**: for a transitive Oliver Γ and an N\*-block system whose
intra-block pairs form a single type, the block size is a prime power.  (The text: "Step 2 runs
with the block in place of an orbit".) -/
structure HypStep2Block (V : Type*) [Fintype V] [DecidableEq V] : Prop where
  prime_pow : ∀ Γ : Subgroup (Perm V), Trans Γ →
    (∃ p q : ℕ, p.Prime ∧ q.Prime ∧ Nonempty (Chain.OliverChain Γ p q)) →
    ∀ B b, BlockSys Γ B b → SingleType Γ (PB B) → IsPrimePow b

/-- N\* is primitive: no block system other than the single block. -/
def NPrim (Γ : Subgroup (Perm V)) : Prop :=
  ∀ B b, BlockSys Γ B b → b = Fintype.card V

/-- **Step 5 (Conjecture P with N\* primitive), as a hypothesis.** -/
structure HypStep5 (V : Type*) [Fintype V] [DecidableEq V] : Prop where
  bound : ∀ Γ : Subgroup (Perm V), Trans Γ →
    (∃ p q : ℕ, p.Prime ∧ q.Prime ∧ Nonempty (Chain.OliverChain Γ p q)) → NPrim Γ →
    ¬ IsPrimePow (Fintype.card V) →
    ∃ a, IsPrimePow a ∧ a ∣ Fintype.card V ∧ 2 * mtyp Γ ≤ Fintype.card V * (a - 1)

/-- **Step 4** at the δ_cyc level: for transitive Oliver Γ with a nontrivial N\*-block system
(m blocks of size b, m ≥ 2), m\*_N(Γ) ≥ δ·C(n,2) with δ ∈ {1/4 at even n, 3 − 2√2 at odd n} forces
b a prime power with (b − 1)/(n − 1) ≥ δ — E's first clause.  (Given Step 2 for blocks.) -/
theorem step4 (H2B : HypStep2Block V) {Γ : Subgroup (Perm V)} (ht : Trans Γ)
    (hOl : ∃ p q : ℕ, p.Prime ∧ q.Prime ∧ Nonempty (Chain.OliverChain Γ p q))
    {B : Finset (Finset V)} {b : ℕ} (h : BlockSys Γ B b) (hb : b < Fintype.card V) {δ : ℝ}
    (hδ : δ = 1 / 4 ∧ Fintype.card V % 2 = 0 ∨ δ = 3 - 2 * Real.sqrt 2 ∧ Fintype.card V % 2 = 1)
    (hfl : δ * ((Fintype.card V : ℝ) * (Fintype.card V - 1)) ≤ 2 * mN Γ) :
    E1 δ (Fintype.card V) := by
  have s2 := Real.sq_sqrt (show (0 : ℝ) ≤ 2 by norm_num)
  have s2b : Real.sqrt 2 < 1.415 := by rw [Real.sqrt_lt' (by norm_num)]; norm_num
  have s2a : 1.414 < Real.sqrt 2 := by rw [Real.lt_sqrt (by norm_num)]; norm_num
  have hn := h.card
  set m := B.card
  have hb2 := h.b2
  have hm2 : 2 ≤ m := by
    by_contra hc
    have : m ≤ 1 := by omega
    have : Fintype.card V ≤ b := by rw [hn]; nlinarith
    omega
  have hB : B.Nonempty := card_pos.mp (by omega)
  have hca : (2 * b.choose 2 : ℝ) = b * (b - 1) := by rw [Nat.cast_choose_two]; ring
  have hnR : (Fintype.card V : ℝ) = m * b := by rw [hn]; push_cast; ring
  have mR : (2 : ℝ) ≤ m := by exact_mod_cast hm2
  have bR : (2 : ℝ) ≤ b := by exact_mod_cast hb2
  have hpos : (0 : ℝ) < m * b := by positivity
  have hle : (mN Γ : ℝ) ≤ m * b.choose 2 := by exact_mod_cast mN_le_blocks h hB
  have hδ0 : (1 : ℝ) / 6 ≤ δ := by
    rcases hδ with ⟨rfl, -⟩ | ⟨rfl, -⟩ <;> [norm_num; linarith]
  by_cases hst : SingleType Γ (PB B)
  · -- b is a prime power, and the intra-block bound gives E1 with a = b
    refine ⟨b, H2B.prime_pow Γ ht hOl B b h hst, ⟨m, by rw [hn, mul_comm]⟩, hb, ?_⟩
    rw [hnR] at hfl ⊢
    have k : (m * b : ℝ) * (δ * (m * b - 1)) ≤ (m * b) * (b - 1) := by nlinarith
    exact le_of_mul_le_mul_left k hpos
  · exfalso
    have hh := le_trans (mN_half (NInv_of_inv (PB_inv h)) hst) (card_PB_le h)
    have h2 : (2 * mN Γ : ℝ) ≤ m * b.choose 2 := by exact_mod_cast hh
    rw [hnR] at hfl
    -- δ·mb(mb − 1) ≤ 2 m*_N ≤ m·b(b − 1)/2, so 2δ(mb − 1) ≤ b − 1
    have k : (m * b : ℝ) * (2 * δ * (m * b - 1)) ≤ (m * b) * (b - 1) := by nlinarith
    have k2 : 2 * δ * ((m : ℝ) * b - 1) ≤ b - 1 := le_of_mul_le_mul_left k hpos
    rcases hδ with ⟨rfl, hev⟩ | ⟨rfl, hodd⟩
    · nlinarith
    · -- n odd: m odd, so m ≥ 3
      have hm3 : (3 : ℝ) ≤ m := by
        have : 3 ≤ m := by
          by_contra hc
          have : m = 2 := by omega
          rw [hn, this] at hodd; omega
        exact_mod_cast this
      nlinarith

/-- **The transitive case through Steps 4 and 5**: N\* imprimitive goes through `step4`, N\*
primitive through Step 5. -/
theorem trans_E1_steps (H2B : HypStep2Block V) (H5 : HypStep5 V) {Γ : Subgroup (Perm V)}
    (ht : Trans Γ) (hOl : ∃ p q : ℕ, p.Prime ∧ q.Prime ∧ Nonempty (Chain.OliverChain Γ p q))
    (hnp : ¬ IsPrimePow (Fintype.card V)) (hn2 : 2 ≤ Fintype.card V) {δ : ℝ}
    (hδ : δ = 1 / 4 ∧ Fintype.card V % 2 = 0 ∨ δ = 3 - 2 * Real.sqrt 2 ∧ Fintype.card V % 2 = 1)
    (h : δ * ((Fintype.card V : ℝ) * (Fintype.card V - 1)) ≤ 2 * mN Γ) : E1 δ (Fintype.card V) := by
  by_cases hp : NPrim Γ
  · -- Step 5, then as in `trans_E1`
    obtain ⟨a, hpp, hdvd, hb⟩ := H5.bound Γ ht hOl hp hnp
    have hle := mN_le_mtyp Γ hn2
    have ha1 : 1 ≤ a := hpp.one_lt.le
    refine ⟨a, hpp, hdvd, lt_of_le_of_ne (Nat.le_of_dvd (by omega) hdvd) (fun e => hnp (e ▸ hpp)), ?_⟩
    have hb' : (2 * mN Γ : ℝ) ≤ (Fintype.card V : ℝ) * ((a : ℝ) - 1) := by
      have : 2 * mN Γ ≤ Fintype.card V * (a - 1) := le_trans (Nat.mul_le_mul_left 2 hle) hb
      have e : ((Fintype.card V * (a - 1) : ℕ) : ℝ) = (Fintype.card V : ℝ) * ((a : ℝ) - 1) := by
        rw [Nat.cast_mul, Nat.cast_sub ha1]; simp
      rw [← e]; exact_mod_cast this
    have hpos : (0 : ℝ) < Fintype.card V := by exact_mod_cast (show 0 < Fintype.card V by omega)
    have k : (Fintype.card V : ℝ) * (δ * ((Fintype.card V : ℝ) - 1)) ≤
        (Fintype.card V : ℝ) * ((a : ℝ) - 1) := by nlinarith
    exact le_of_mul_le_mul_left k hpos
  · unfold NPrim at hp; push Not at hp
    obtain ⟨B, b, hB, hbn⟩ := hp
    have hn := hB.card
    have hb : b < Fintype.card V := by
      have hm : 1 ≤ B.card := by
        rcases Nat.eq_zero_or_pos B.card with h0 | h0
        · rw [h0] at hn; omega
        · exact h0
      have : b ≤ Fintype.card V := by rw [hn]; nlinarith
      omega
    exact step4 H2B ht hOl hB hb hδ h

/-- **Proposition U_typ at even n, through Steps 2, 4 (proved) and 5**: hypotheses Step 2 (for
orbits and for blocks) and Step 5 replace Conjecture P. -/
theorem Utyp_even_steps (H2 : HypStep2 V) (H2B : HypStep2Block V) (H5 : HypStep5 V)
    {Γ : Subgroup (Perm V)} (hfp : FPF Γ)
    (hOl : ∃ p q : ℕ, p.Prime ∧ q.Prime ∧ Nonempty (Chain.OliverChain Γ p q))
    (hnp : ¬ IsPrimePow (Fintype.card V)) (hn2 : 2 ≤ Fintype.card V) (hev : Fintype.card V % 2 = 0)
    (hnE : ¬ E1 (1 / 4) (Fintype.card V)) :
    8 * (mN Γ : ℝ) < (Fintype.card V : ℝ) * (Fintype.card V - 1) := by
  by_contra hc; push Not at hc
  by_cases ht : Trans Γ
  · exact hnE (trans_E1_steps H2B H5 ht hOl hnp hn2 (Or.inl ⟨rfl, hev⟩) (by linarith))
  · unfold Trans at ht; push Not at ht
    obtain ⟨x, y, hxy⟩ := ht
    have ho : orb Γ x ≠ orb Γ y := by
      intro he
      have : y ∈ orb Γ x := he ▸ self_mem_orb Γ y
      obtain ⟨g, hg, rfl⟩ := mem_orb.mp this
      exact hxy g hg rfl
    obtain ⟨a, hpp, hdvd, hlt, hle⟩ := intrans_even H2 hfp hOl ho hc
    apply hnE
    refine ⟨a, hpp, hdvd, hlt, ?_⟩
    have ha1 : 1 ≤ a := hpp.one_lt.le
    have : ((Fintype.card V - 1 : ℕ) : ℝ) ≤ ((4 * (a - 1) : ℕ) : ℝ) := by exact_mod_cast hle
    rw [Nat.cast_sub (by omega), Nat.cast_mul, Nat.cast_sub ha1] at this
    push_cast at this; linarith

/-- **Proposition U_typ at odd n, through Steps 2, 4 (proved) and 5.** -/
theorem Utyp_odd_steps (H2 : HypStep2 V) (H2B : HypStep2Block V) (H5 : HypStep5 V)
    {Γ : Subgroup (Perm V)} (hfp : FPF Γ)
    (hOl : ∃ p q : ℕ, p.Prime ∧ q.Prime ∧ Nonempty (Chain.OliverChain Γ p q))
    (hnp : ¬ IsPrimePow (Fintype.card V)) (hn2 : 2 ≤ Fintype.card V)
    (hodd : Fintype.card V % 2 = 1)
    (hnE : ¬ E1 (3 - 2 * Real.sqrt 2) (Fintype.card V) ∧ ¬ E2 (3 - 2 * Real.sqrt 2) (Fintype.card V)) :
    2 * (mN Γ : ℝ) < (3 - 2 * Real.sqrt 2) * ((Fintype.card V : ℝ) * (Fintype.card V - 1)) := by
  by_contra hc; push Not at hc
  by_cases ht : Trans Γ
  · exact hnE.1 (trans_E1_steps H2B H5 ht hOl hnp hn2 (Or.inr ⟨rfl, hodd⟩) hc)
  · unfold Trans at ht; push Not at ht
    obtain ⟨x, y, hxy⟩ := ht
    have ho : orb Γ x ≠ orb Γ y := by
      intro he
      have : y ∈ orb Γ x := he ▸ self_mem_orb Γ y
      obtain ⟨g, hg, rfl⟩ := mem_orb.mp this
      exact hxy g hg rfl
    rcases intrans_odd H2 hfp hOl hodd ho hc with h1 | h2
    · exact hnE.1 h1
    · exact hnE.2 h2

end Upper

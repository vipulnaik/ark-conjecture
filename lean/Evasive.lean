/-
# `Evasive.lean` — the KSS–Oliver interface, and the single-good-type Proposition
-/
import CycGood
import D2
import Chain

namespace Evasive
open Finset Equiv Classical

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- A graph property on V, presented as the **down-closed family** whose fixed complexes KSS use
(for a monotone property Q this is the family of non-members of Q, or of Q's dual; evasiveness
of one is evasiveness of the other).  Graphs are edge sets; the family is invariant under every
permutation of V, contains the empty graph and not the complete graph. -/
structure DownProp (V : Type*) [Fintype V] [DecidableEq V] where
  mem : Finset (Sym2 V) → Prop
  down : ∀ G H, mem G → H ⊆ G → mem H
  inv : ∀ (σ : Perm V) G, mem G → mem (G.image (Sym2.map σ))
  empty : mem ∅
  full : ¬ mem ((univ : Finset (Sym2 V)).filter (fun e => ¬ e.IsDiag))

/-- The orbitals of Γ (orbits on unordered pairs of distinct points). -/
noncomputable def orbitals (Γ : Subgroup (Perm V)) : Finset (Finset (Sym2 V)) :=
  ((univ : Finset (Sym2 V)).filter (fun e => ¬ e.IsDiag)).image (D2.orbit2 Γ)

/-- **χ of the fixed complex Δ_P^Γ**: faces are the nonempty sets of orbitals whose union is in P. -/
noncomputable def chiFix (P : DownProp V) (Γ : Subgroup (Perm V)) : ℤ :=
  ∑ S ∈ (orbitals Γ).powerset.filter (fun S => S.Nonempty ∧ P.mem (S.biUnion id)),
    (-1 : ℤ) ^ (S.card + 1)

/-- **The KSS–Oliver input, as one hypothesis** (a `structure`, never an `axiom`).  `Ev P` is
"P is evasive", left abstract: decision trees are not formalised here.  For every Oliver group
Γ ≤ Sym(V) with chain primes (p, q) and every property P that is not evasive, the fixed complex has
χ ≡ 1 (mod q).  This is Kahn–Saks–Sturtevant's reduction combined with Oliver's theorem. -/
structure HypKSSOliver (Ev : DownProp V → Prop) : Prop where
  congr : ∀ (Γ : Subgroup (Perm V)) (p q : ℕ), p.Prime → q.Prime → Nonempty (Chain.OliverChain Γ p q) →
    ∀ P : DownProp V, ¬ Ev P → chiFix P Γ ≡ 1 [ZMOD q]

/-- The largest edge count of a member is below M. -/
def EmaxLt (P : DownProp V) (M : ℕ) : Prop := ∀ G, P.mem G → G.card < M

/-- **The single-good-type Proposition** (`threshold-beyond-mu.md` §3), in abstract form.  Γ has
k orbitals O₀, …, O_{k−1} (distinct), a permutation σ of V carries O_j onto O_{j+1}, every other
orbital has at least M pairs, and the O_j together have at least M.  If k is good for q and
e_max(P) < M, then χ(Δ_P^Γ) ≢ 1 (mod q). -/
theorem chi_not_one (Γ : Subgroup (Perm V)) {k : ℕ} [NeZero k] {q M : ℕ} (O : ZMod k → Finset (Sym2 V))
    (hOinj : Function.Injective O) (hOorb : ∀ j, O j ∈ orbitals Γ)
    (σ : Perm V) (hσ : ∀ j, (O j).image (Sym2.map σ) = O (j + 1))
    (hbig : ∀ o ∈ orbitals Γ, (∀ j, o ≠ O j) → M ≤ o.card)
    (hall : M ≤ ((univ : Finset (ZMod k)).biUnion O).card)
    (hgood : CycGood.Good k q) (P : DownProp V) (hP : EmaxLt P M) :
    ¬ (chiFix P Γ ≡ 1 [ZMOD q]) := by
  set 𝓕 : Finset (Finset (ZMod k)) := univ.filter (fun J => J.Nonempty ∧ P.mem (J.biUnion O))
  -- every orbital in a face is one of the O_j
  have hface : ∀ S ∈ (orbitals Γ).powerset.filter (fun S => S.Nonempty ∧ P.mem (S.biUnion id)),
      ∀ o ∈ S, ∃ j, o = O j := by
    intro S hS o ho
    obtain ⟨hS1, -, hS3⟩ := by simpa only [mem_filter, mem_powerset] using hS
    by_contra hcon
    push Not at hcon
    have h1 := hbig o (hS1 ho) hcon
    have h2 : o ⊆ S.biUnion id := fun e he => mem_biUnion.mpr ⟨o, ho, he⟩
    have h3 := hP _ hS3
    have := card_le_card h2
    omega
  have hchi : chiFix P Γ = CycGood.chi 𝓕 := by
    unfold chiFix CycGood.chi
    symm
    apply Finset.sum_nbij' (fun J => J.image O) (fun S => univ.filter (fun j => O j ∈ S))
    · intro J hJ
      simp only [𝓕, mem_filter, mem_univ, true_and] at hJ
      simp only [mem_filter, mem_powerset]
      refine ⟨fun o ho => ?_, hJ.1.image _, ?_⟩
      · obtain ⟨j, -, rfl⟩ := mem_image.mp ho; exact hOorb j
      · rw [image_biUnion]; simpa using hJ.2
    · intro S hS
      have hf := hface S hS
      simp only [mem_filter, mem_powerset] at hS
      have hS' : (univ.filter (fun j => O j ∈ S)).image O = S := by
        ext o; simp only [mem_image, mem_filter, mem_univ, true_and]
        constructor
        · rintro ⟨j, hj, rfl⟩; exact hj
        · intro ho; obtain ⟨j, rfl⟩ := hf o ho; exact ⟨j, ho, rfl⟩
      simp only [𝓕, mem_filter, mem_univ, true_and]
      refine ⟨?_, ?_⟩
      · obtain ⟨o, ho⟩ := hS.2.1
        obtain ⟨j, rfl⟩ := hf o ho
        exact ⟨j, by simp [ho]⟩
      · have := hS.2.2
        rw [← hS', image_biUnion] at this
        simpa using this
    · intro J _
      ext j; simp [hOinj.eq_iff]
    · intro S hS
      have hf := hface S hS
      ext o; simp only [mem_image, mem_filter, mem_univ, true_and]
      constructor
      · rintro ⟨j, hj, rfl⟩; exact hj
      · intro ho; obtain ⟨j, rfl⟩ := hf o ho; exact ⟨j, ho, rfl⟩
    · intro J _
      rw [card_image_of_injective _ hOinj]
  have hinv : CycGood.InvCx 𝓕 := by
    refine ⟨?_, ?_, ?_, ?_⟩
    · intro J hJ; exact (mem_filter.mp hJ).2.1
    · intro J hJ T hT hTne
      simp only [𝓕, mem_filter, mem_univ, true_and] at hJ ⊢
      exact ⟨hTne, P.down _ _ hJ.2 (biUnion_subset_biUnion_of_subset_left _ hT)⟩
    · intro J hJ
      simp only [𝓕, mem_filter, mem_univ, true_and] at hJ ⊢
      refine ⟨hJ.1.image _, ?_⟩
      have : (CycGood.sh 1 J).biUnion O = (J.biUnion O).image (Sym2.map σ) := by
        rw [CycGood.sh, biUnion_image, image_biUnion]
        exact biUnion_congr rfl (fun j _ => (hσ j).symm)
      rw [this]; exact P.inv σ _ hJ.2
    · intro hu
      simp only [𝓕, mem_filter, mem_univ, true_and] at hu
      have := hP _ hu.2
      omega
  rw [hchi]
  exact hgood 𝓕 hinv

/-- **Evasiveness from a good type.**  Under the KSS–Oliver input, an Oliver group as in
`chi_not_one` makes every property with e_max < M evasive. -/
theorem evasive_of_good_type (Ev : DownProp V → Prop) (H : HypKSSOliver Ev)
    (Γ : Subgroup (Perm V)) {p q : ℕ} (hp : p.Prime) (hq : q.Prime)
    (hch : Nonempty (Chain.OliverChain Γ p q)) {k : ℕ} [NeZero k] {M : ℕ}
    (O : ZMod k → Finset (Sym2 V)) (hOinj : Function.Injective O) (hOorb : ∀ j, O j ∈ orbitals Γ)
    (σ : Perm V) (hσ : ∀ j, (O j).image (Sym2.map σ) = O (j + 1))
    (hbig : ∀ o ∈ orbitals Γ, (∀ j, o ≠ O j) → M ≤ o.card)
    (hall : M ≤ ((univ : Finset (ZMod k)).biUnion O).card)
    (hgood : CycGood.Good k q) (P : DownProp V) (hP : EmaxLt P M) : Ev P := by
  by_contra hne
  exact chi_not_one Γ O hOinj hOorb σ hσ hbig hall hgood P hP (H.congr Γ p q hp hq hch P hne)

end Evasive

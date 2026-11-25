/-
# `Glue.lean` — Step 2 of Lemma D2 for Γ|_O itself

`Step2.origin_change` is the H¹ = 0 averaging over an abstract finite group Q.  This file
applies it to Q = Γ|_O / T\*, in the coordinates Step 1 produces (`Chain.step1_full`,
`Chain.step2_common_mult`, rescaled by `Chain.step1_diagonal`): every element affine with
**one** multiplier, and T\* the diagonal translations.

* `affine_mul`, `affine_tr` — composition of affine maps, and a diagonal translation as one.
* `data_of_affine` — the affine data (σ, a, t) of an element is read off its values, so it is
  unique.
* `Tsub`, `Tsub_normal` — T\* = translations in G, normal (conjugates of translations are
  translations, `Chain.conj_translation`).
* **`step2_glue`** — if [G : T\*] is prime to r, there are per-block origins o such that every
  g ∈ G acts as (i, x) ↦ (σi, a·x + s) in the shifted coordinate x − oᵢ.  That is the normal
  form `D2.d2b` assumes.  The index hypothesis is `Chain.not_rsq_dvd` (Sylow-r = T\*).

Hypotheses kept explicit: the normalised coordinates (common multiplier, T\* diagonal), which
`Chain.lean` derives up to a per-block rescaling; and Lemma B's affine form.
-/
import Chain
import Step2

namespace Glue
open Chain

variable {F r : ℕ}

theorem affine_mul {g₁ g₂ : Equiv.Perm (Pt F r)} {σ₁ σ₂ : Equiv.Perm (Fin F)} {a₁ a₂ : ZMod r}
    {t₁ t₂ : Fin F → ZMod r} (h₁ : Affine g₁ σ₁ (fun _ => a₁) t₁)
    (h₂ : Affine g₂ σ₂ (fun _ => a₂) t₂) :
    Affine (g₁ * g₂) (σ₁ * σ₂) (fun _ => a₁ * a₂) (fun i => a₁ * t₂ i + t₁ (σ₂ i)) := by
  intro pt
  rw [Equiv.Perm.mul_apply, h₂, h₁]
  simp only [Equiv.Perm.mul_apply, Prod.mk.injEq, true_and]
  ring

theorem affine_tr (c : ZMod r) :
    Affine (trHom (F := F) (Multiplicative.ofAdd fun _ => c)) 1 (fun _ => 1) (fun _ => c) := by
  intro pt
  simp [trHom, tr]

theorem data_of_affine {g : Equiv.Perm (Pt F r)} {σ : Equiv.Perm (Fin F)} {a : ZMod r}
    {t : Fin F → ZMod r} (hg : Affine g σ (fun _ => a) t) (i0 : Fin F) :
    (fun i => (g (i, 0)).1) = σ ∧ (fun i => (g (i, 0)).2) = t ∧
      (g (i0, 1)).2 - (g (i0, 0)).2 = a := by
  refine ⟨funext fun i => by rw [hg (i, 0)], funext fun i => by rw [hg (i, 0)]; simp, ?_⟩
  rw [hg (i0, 1), hg (i0, 0)]
  simp

/-- T\* as a subgroup of G: the elements acting as translations. -/
def Tsub (G : Subgroup (Equiv.Perm (Pt F r))) : Subgroup G :=
  (trHom (F := F) (r := r)).range.comap G.subtype

theorem Tsub_normal (G : Subgroup (Equiv.Perm (Pt F r)))
    (hB : ∀ g ∈ G, ∃ (σ : Equiv.Perm (Fin F)) (a : ZMod r) (t : Fin F → ZMod r),
      a ≠ 0 ∧ Affine g σ (fun _ => a) t) : (Tsub G).Normal := by
  constructor
  intro n hn g
  obtain ⟨t0, ht0⟩ := hn
  obtain ⟨σ, a, t, -, hg⟩ := hB g g.2
  show ((g * n * g⁻¹ : G) : Equiv.Perm (Pt F r)) ∈ (trHom (F := F) (r := r)).range
  simp only [Subgroup.coe_mul, Subgroup.coe_inv]
  have : (n : Equiv.Perm (Pt F r)) = trHom (Multiplicative.ofAdd (Multiplicative.toAdd t0)) := by
    exact ht0.symm
  rw [this, conj_translation hg]
  exact ⟨_, rfl⟩

/-- **Step 2 for Γ|_O.**  In Step 1's coordinates (common multiplier; T\* diagonal), with
[G : T\*] prime to r, per-block origins make every element (i, x) ↦ (σi, a·x + s). -/
theorem step2_glue [Fact r.Prime] (G : Subgroup (Equiv.Perm (Pt F r))) (hF : 0 < F)
    (hB : ∀ g ∈ G, ∃ (σ : Equiv.Perm (Fin F)) (a : ZMod r) (t : Fin F → ZMod r),
      a ≠ 0 ∧ Affine g σ (fun _ => a) t)
    (hT : ∀ g ∈ G, g ∈ (trHom (F := F) (r := r)).range →
      ∃ c : ZMod r, g = trHom (Multiplicative.ofAdd fun _ => c))
    (hm : ¬ r ∣ Nat.card (G ⧸ Tsub G)) :
    ∃ o : Fin F → ZMod r, ∀ g ∈ G, ∃ (σ : Equiv.Perm (Fin F)) (a s : ZMod r),
      ∀ i x, g (i, x + o i) = (σ i, a * x + s + o (σ i)) := by
  classical
  have hN := Tsub_normal G hB
  let Q := G ⧸ Tsub G
  have : Fintype Q := Fintype.ofFinite Q
  let i0 : Fin F := ⟨0, hF⟩
  let rep : Q → G := fun q => q.out
  -- the affine data of each element, read off its values
  let σQ : Q → Fin F → Fin F := fun q i => ((rep q : Equiv.Perm (Pt F r)) (i, 0)).1
  let aQ : Q → ZMod r := fun q =>
    ((rep q : Equiv.Perm (Pt F r)) (i0, 1)).2 - ((rep q : Equiv.Perm (Pt F r)) (i0, 0)).2
  let tQ : Q → Fin F → ZMod r := fun q i => ((rep q : Equiv.Perm (Pt F r)) (i, 0)).2
  -- every element's affine data is the data read off its values
  have hdata : ∀ (g : Equiv.Perm (Pt F r)) (σ : Equiv.Perm (Fin F)) (a : ZMod r) t,
      Affine g σ (fun _ => a) t → Affine g σ (fun _ => (g (i0, 1)).2 - (g (i0, 0)).2)
        (fun i => (g (i, 0)).2) ∧ (fun i => (g (i, 0)).1) = ⇑σ ∧
        (g (i0, 1)).2 - (g (i0, 0)).2 = a := by
    intro g σ a t hg
    obtain ⟨h1, h2, h3⟩ := data_of_affine hg i0
    refine ⟨?_, h1, h3⟩
    rw [h3, h2]; exact hg
  have hA : ∀ q, ∃ σ : Equiv.Perm (Fin F), aQ q ≠ 0 ∧
      Affine (rep q) σ (fun _ => aQ q) (tQ q) ∧ σQ q = ⇑σ := by
    intro q
    obtain ⟨σ, a, t, ha, hg⟩ := hB _ (rep q).2
    obtain ⟨h1, h2, h3⟩ := hdata _ σ a t hg
    exact ⟨σ, by simp only [aQ]; rw [h3]; exact ha, h1, h2⟩
  -- rep (h g) = rep h · rep g · τ_c
  have hprod : ∀ h g : Q, ∃ c : ZMod r, ((rep (h * g) : G) : Equiv.Perm (Pt F r)) =
      (rep h : Equiv.Perm (Pt F r)) * (rep g : Equiv.Perm (Pt F r)) *
        trHom (Multiplicative.ofAdd fun _ => c) := by
    intro h g
    obtain ⟨n, hn⟩ := QuotientGroup.mk_out_eq_mul (Tsub G) (rep h * rep g)
    have hmk : (QuotientGroup.mk (rep h * rep g) : Q) = h * g := by
      rw [QuotientGroup.mk_mul]; simp only [rep, QuotientGroup.out_eq']
    rw [hmk] at hn
    obtain ⟨c, hc⟩ := hT _ (n : G).2 n.2
    refine ⟨c, ?_⟩
    have := congrArg (fun x : G => (x : Equiv.Perm (Pt F r))) hn
    simp only [rep] at this ⊢
    rw [this, Subgroup.coe_mul, Subgroup.coe_mul, hc]
  -- the cocycle and multiplicativity
  have hcomp : ∀ h g : Q, aQ (h * g) = aQ h * aQ g ∧ ∀ i j,
      tQ (h * g) i - tQ (h * g) j = aQ h * (tQ g i - tQ g j) +
        (tQ h (σQ g i) - tQ h (σQ g j)) := by
    intro h g
    obtain ⟨σh, -, Ah, hσh⟩ := hA h
    obtain ⟨σg, -, Ag, hσg⟩ := hA g
    obtain ⟨c, hc⟩ := hprod h g
    have Aprod := affine_mul (affine_mul Ah Ag) (affine_tr (F := F) c)
    rw [← hc] at Aprod
    obtain ⟨Ahg, -, h3⟩ := hdata _ _ _ _ Aprod
    refine ⟨by simp only [aQ]; rw [h3]; ring, fun i j => ?_⟩
    have ei := congrFun (data_of_affine Aprod i0).2.1 i
    have ej := congrFun (data_of_affine Aprod i0).2.1 j
    simp only [tQ] at ei ej ⊢
    rw [ei, ej, hσg]
    simp only [Equiv.Perm.one_apply]
    ring
  have hm' : (Fintype.card Q : ZMod r) ≠ 0 := by
    rw [Ne, ZMod.natCast_eq_zero_iff, ← Nat.card_eq_fintype_card]; exact hm
  have ha0 : ∀ q, aQ q ≠ 0 := fun q => (hA q).choose_spec.1
  have key := Step2.origin_change σQ aQ (fun h g => (hcomp h g).1) ha0 tQ
    (fun h g => (hcomp h g).2) hm'
  refine ⟨fun i => -((Fintype.card Q : ZMod r)⁻¹ * ∑ h, (aQ h)⁻¹ * tQ h i), fun g hg => ?_⟩
  -- g = rep q · τ_c
  obtain ⟨n, hn⟩ := QuotientGroup.mk_out_eq_mul (Tsub G) (⟨g, hg⟩ : G)
  set q : Q := QuotientGroup.mk ⟨g, hg⟩
  obtain ⟨c, hc⟩ := hT _ (n⁻¹ : Tsub G).1.2 (n⁻¹ : Tsub G).2
  have hgq : g = (rep q : Equiv.Perm (Pt F r)) * trHom (Multiplicative.ofAdd fun _ => c) := by
    have h1 : (rep q : G) * (n⁻¹ : Tsub G) = ⟨g, hg⟩ := by
      simp only [rep]; rw [hn]; simp
    have := congrArg (fun x : G => (x : Equiv.Perm (Pt F r))) h1
    simp only [Subgroup.coe_mul] at this
    rw [← this, hc]
  obtain ⟨σ, -, Aq, hσq⟩ := hA q
  have Ag := affine_mul Aq (affine_tr (F := F) c)
  rw [← hgq] at Ag
  set o : Fin F → ZMod r := fun i => -((Fintype.card Q : ZMod r)⁻¹ * ∑ h, (aQ h)⁻¹ * tQ h i)
    with ho
  refine ⟨σ, aQ q, aQ q * c + tQ q i0 + aQ q * o i0 - o (σ i0), fun i x => ?_⟩
  have k := key q i i0
  rw [hσq] at k
  rw [Ag (i, _)]
  simp only [Equiv.Perm.mul_apply, Equiv.Perm.one_apply, Prod.mk.injEq, true_and]
  linear_combination k

end Glue

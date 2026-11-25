/-
# `Rescale.lean` — Lemma D2 end to end (r ∉ {p, q})

Connects the pieces: `Chain.lean` (Step 1 and Step 2's common multiplier, in Γ|_O's own
coordinates), `Glue.lean` (Step 2's origin change, in normalised coordinates) and `D2.lean`
(Step 3's count), by conjugating Γ|_O with the per-block rescaling ψ(i, x) = (i, vᵢ·x).

* `scale` — the rescaling, a permutation of O.
* `conj_affine` — conjugating an affine element by ψ: in the new coordinates its multiplier is
  the common λ of `step2_common_mult`, and translations k·v become diagonal k·𝟙.
* `orbit2_conj` — conjugation preserves orbital sizes.
* **`d2_full`** — **Lemma D2's same-position bound, end to end**: Γ|_O with an Oliver chain,
  2 ≤ F < r, r ∉ {p, q}, Lemma B's affine form and transitivity on O ⇒ some orbital has at most
  C(F,2)·r pairs.  With `D2.d2a` (F·C(r,2), unconditional) this is the lemma's statement.

The one input still taken as a hypothesis is **Lemma B** (each element is affine on the
blocks).  The r = q case (Lemma D2q) is not assembled here.
-/
import Glue
import D2

namespace Rescale
open Chain

variable {F r : ℕ} [Fact r.Prime]

/-- The per-block rescaling (i, x) ↦ (i, vᵢ·x). -/
def scale (v : Fin F → ZMod r) (hv : ∀ i, v i ≠ 0) : Equiv.Perm (Pt F r) where
  toFun p := (p.1, v p.1 * p.2)
  invFun p := (p.1, (v p.1)⁻¹ * p.2)
  left_inv p := by simp [← mul_assoc, inv_mul_cancel₀ (hv p.1)]
  right_inv p := by simp [← mul_assoc, mul_inv_cancel₀ (hv p.1)]

/-- Conjugating an affine element whose multipliers satisfy aᵢvᵢ = λ·v_{σi}. -/
theorem conj_affine (v : Fin F → ZMod r) (hv : ∀ i, v i ≠ 0) {g : Equiv.Perm (Pt F r)}
    {σ : Equiv.Perm (Fin F)} {a t : Fin F → ZMod r} (hg : Affine g σ a t) {c : ZMod r}
    (hc : ∀ i, a i * v i = c * v (σ i)) :
    Affine ((scale v hv)⁻¹ * g * scale v hv) σ (fun _ => c)
      (fun i => (v (σ i))⁻¹ * t i) := by
  intro pt
  have h1 : (scale v hv) pt = (pt.1, v pt.1 * pt.2) := rfl
  rw [Equiv.Perm.mul_apply, Equiv.Perm.mul_apply, h1, hg]
  simp only [Equiv.Perm.inv_def, scale, Equiv.coe_fn_symm_mk]
  refine Prod.ext rfl ?_
  simp only
  have h2 := hc pt.1
  have h3 := hv (σ pt.1)
  field_simp
  linear_combination pt.2 * h2

theorem conj_translation_scale (v : Fin F → ZMod r) (hv : ∀ i, v i ≠ 0) (w : Fin F → ZMod r) :
    scale v hv * trHom (Multiplicative.ofAdd w) * (scale v hv)⁻¹ =
      trHom (Multiplicative.ofAdd fun i => v i * w i) := by
  rw [mul_inv_eq_iff_eq_mul]
  ext p
  · rfl
  · simp [scale, trHom, tr, mul_add]

/-- The conjugated group ψ⁻¹ G ψ. -/
def conjG (v : Fin F → ZMod r) (hv : ∀ i, v i ≠ 0) (G : Subgroup (Equiv.Perm (Pt F r))) :
    Subgroup (Equiv.Perm (Pt F r)) :=
  G.map (MulAut.conj (scale v hv)⁻¹).toMonoidHom

theorem mem_conjG {v : Fin F → ZMod r} {hv : ∀ i, v i ≠ 0} {G : Subgroup (Equiv.Perm (Pt F r))}
    {g' : Equiv.Perm (Pt F r)} :
    g' ∈ conjG v hv G ↔ scale v hv * g' * (scale v hv)⁻¹ ∈ G := by
  simp only [conjG, Subgroup.mem_map, MulEquiv.coe_toMonoidHom, MulAut.conj_apply, inv_inv]
  constructor
  · rintro ⟨g, hg, rfl⟩; simpa [mul_assoc] using hg
  · intro h
    exact ⟨_, h, by simp [mul_assoc]⟩

/-- Conjugation preserves orbital sizes. -/
theorem orbit2_conj (v : Fin F → ZMod r) (hv : ∀ i, v i ≠ 0)
    (G : Subgroup (Equiv.Perm (Pt F r))) (e : Sym2 (Pt F r)) :
    (D2.orbit2 G (Sym2.map (scale v hv) e)).card = (D2.orbit2 (conjG v hv G) e).card := by
  classical
  set ψ := scale v hv
  have hinj : Function.Injective (Sym2.map ψ) := Sym2.map.injective ψ.injective
  have hset : D2.orbit2 G (Sym2.map ψ e) = (D2.orbit2 (conjG v hv G) e).image (Sym2.map ψ) := by
    ext x
    simp only [D2.orbit2, Finset.mem_image, Finset.mem_filter, Finset.mem_univ, true_and]
    constructor
    · rintro ⟨g, hg, rfl⟩
      refine ⟨Sym2.map ⇑(ψ⁻¹ * g * ψ) e, ⟨ψ⁻¹ * g * ψ, ?_, rfl⟩, ?_⟩
      · rw [mem_conjG]; simpa [ψ, mul_assoc] using hg
      · rw [Sym2.map_map, Sym2.map_map]; congr 1; funext pt; simp
    · rintro ⟨y, ⟨g', hg', rfl⟩, rfl⟩
      refine ⟨ψ * g' * ψ⁻¹, mem_conjG.mp hg', ?_⟩
      rw [Sym2.map_map, Sym2.map_map]; congr 1; funext pt; simp
  rw [hset, Finset.card_image_of_injective _ hinj]

/-- **Lemma D2 (same-position bound), end to end.** -/
theorem d2_full {p q : ℕ} (G : Subgroup (Equiv.Perm (Pt F r))) (C : OliverChain G p q)
    (hp : p.Prime) (hq : q.Prime) (hrp : r ≠ p) (hrq : r ≠ q) (hF2 : 2 ≤ F) (hFr : F < r)
    (hB : ∀ g ∈ G, ∃ σ a t, (∀ i, a i ≠ 0) ∧ Affine g σ a t)
    (htr : ∀ x y : Pt F r, ∃ g ∈ G, g x = y) :
    ∃ e : Sym2 (Pt F r), ¬ e.IsDiag ∧ (D2.orbit2 G e).card ≤ r * F.choose 2 := by
  classical
  have hr : r.Prime := Fact.out
  have hF : 0 < F := by omega
  obtain ⟨v, hvf, hvT, hmult⟩ := step2_common_mult G C hp hq hrp hrq hFr hF hB htr
  set G' := conjG v hvf G
  -- affine form with a common multiplier in G'
  have hB' : ∀ g' ∈ G', ∃ (σ : Equiv.Perm (Fin F)) (a : ZMod r) (t : Fin F → ZMod r),
      a ≠ 0 ∧ Affine g' σ (fun _ => a) t := by
    intro g' hg'
    have hg := mem_conjG.mp hg'
    obtain ⟨σ, a, t, ha, hga⟩ := hB _ hg
    obtain ⟨c, hc⟩ := hmult _ hg σ a t hga
    have hconj := conj_affine v hvf hga hc
    have : (scale v hvf)⁻¹ * ((scale v hvf) * g' * (scale v hvf)⁻¹) * (scale v hvf) = g' := by
      simp [mul_assoc]
    rw [this] at hconj
    refine ⟨σ, c, _, ?_, hconj⟩
    intro hc0
    have := hc ⟨0, hF⟩
    rw [hc0, zero_mul] at this
    exact mul_ne_zero (ha _) (hvf _) this
  -- translations in G' are diagonal
  have hT' : ∀ g' ∈ G', g' ∈ (trHom (F := F) (r := r)).range →
      ∃ c : ZMod r, g' = trHom (Multiplicative.ofAdd fun _ => c) := by
    intro g' hg' ⟨w0, hw⟩
    set w := Multiplicative.toAdd w0
    have hw' : trHom (Multiplicative.ofAdd w) = g' := hw
    have hg := mem_conjG.mp hg'
    rw [← hw', conj_translation_scale] at hg
    obtain ⟨k, hk⟩ := hvT _ hg ⟨_, rfl⟩
    have hk' := congrArg Multiplicative.toAdd (trHom_injective hk)
    refine ⟨k, ?_⟩
    rw [← hw']
    congr 1
    funext i
    have := congrFun hk' i
    simp only [toAdd_ofAdd, zsmul_eq_mul, Pi.mul_apply, Pi.intCast_apply] at this
    have h2 : v i * w i = v i * k := by rw [this]; ring
    exact mul_left_cancel₀ (hvf i) h2
  -- [G' : T'] is prime to r: |G'| = |G|, r² ∤ |G|, and r ∣ |T'|
  have hcard : Nat.card G' = Nat.card G :=
    (Nat.card_congr (Subgroup.equivMapOfInjective G _
      (MulAut.conj (scale v hvf)⁻¹).injective).toEquiv).symm
  have hnot := not_rsq_dvd G C hp hq hrp hrq hFr hF hB htr
  obtain ⟨t, ht0, htG⟩ := exists_translation G hFr hF hB htr
  have hT'r : r ∣ Nat.card (Glue.Tsub G') := by
    -- (scale v hvf)⁻¹ τ_t (scale v hvf) is a nonzero translation in G', of order r
    let w : Fin F → ZMod r := fun i => (v i)⁻¹ * t i
    have hw : (scale v hvf)⁻¹ * trHom (Multiplicative.ofAdd t) * (scale v hvf) = trHom (Multiplicative.ofAdd w) := by
      have := conj_translation_scale v hvf w
      have hvw : (fun i => v i * w i) = t := by
        funext i; simp [w, ← mul_assoc, mul_inv_cancel₀ (hvf i)]
      rw [hvw] at this
      rw [← this]; simp [mul_assoc]
    have hmem : trHom (Multiplicative.ofAdd w) ∈ G' := by
      rw [mem_conjG, ← hw]; simpa [mul_assoc] using htG
    let x : Glue.Tsub G' := ⟨⟨_, hmem⟩, ⟨_, rfl⟩⟩
    have hw0 : w ≠ 0 := by
      intro h0; apply ht0; funext i
      have := congrFun h0 i
      simp only [w, Pi.zero_apply, mul_eq_zero, inv_eq_zero] at this
      rcases this with h | h
      · exact absurd h (hvf i)
      · exact h
    have hxo : orderOf x = r := by
      apply orderOf_eq_prime
      · apply Subtype.ext; apply Subtype.ext
        simp only [x, SubmonoidClass.coe_pow, Subgroup.coe_one]
        rw [← map_pow]
        convert map_one (trHom (F := F) (r := r))
        apply Multiplicative.toAdd.injective
        funext i; simp [toAdd_pow]
      · intro h
        apply hw0
        have := congrArg (fun y : Glue.Tsub G' => ((y : G') : Equiv.Perm (Pt F r))) h
        simp only [x, OneMemClass.coe_one] at this
        have := congrArg Multiplicative.toAdd (trHom_injective (this.trans (map_one _).symm))
        simpa using this
    have := orderOf_dvd_natCard x
    rwa [hxo] at this
  have hm : ¬ r ∣ Nat.card (G' ⧸ Glue.Tsub G') := by
    intro h
    apply hnot
    rw [← hcard, ← (Glue.Tsub G').card_mul_index, Subgroup.index, pow_two]
    exact Nat.mul_dvd_mul hT'r h
  -- Step 2 in G', then Step 3, then transport back
  obtain ⟨o, ho⟩ := Glue.step2_glue G' hF hB' hT' hm
  obtain ⟨e, hed, hecard⟩ := D2.d2b_shift G' hF2 o ho
  refine ⟨Sym2.map (scale v hvf) e, ?_, ?_⟩
  · rwa [Sym2.isDiag_map (scale v hvf).injective]
  · rw [orbit2_conj]; exact hecard

end Rescale

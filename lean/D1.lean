/-
# `D1.lean` — Lemma D1 (absorption) in the E.6 model

Lemma D1 (`enumeration-proof.md` Part D2): F copies of a p-characteristic block of size
c = p^a, with F a power of p (copies supplied by the bottom layer), form a single part of size
F·c = p^(a+b), and the single-part reading scores at least as high.  In the `E6` model:
replacing `pc F c d` by `pc 1 (F·c) (F·c − 1)` keeps the configuration admissible, keeps n,
and does not lower SAFE (`lemmaD1`).  So the shape space may take block counts F = F_mid·F_top
with no bottom-layer factor, as the text does.
-/
import E6

namespace D1
open E6 ArkCore E5Assembly

/-- **Lemma D1.** -/
theorem lemmaD1 (C : Config) (hC : GAdm C) {F c d : ℕ} {rest : List CPart}
    (hparts : C.parts = .pc F c d :: rest) (hFp : ∃ k, F = C.p ^ k) :
    let C' : Config := ⟨C.p, C.q, .pc 1 (F * c) (F * c - 1) :: rest⟩
    GAdm C' ∧ C'.n = C.n ∧ C.safe ≤ C'.safe := by
  intro C'
  obtain ⟨hp, hq, hall, hnd⟩ := hC
  have hpc := hall (.pc F c d) (by rw [hparts]; simp)
  obtain ⟨hF, ⟨b, hb, hcb⟩, -⟩ := hpc
  obtain ⟨k, hk⟩ := hFp
  refine ⟨⟨hp, hq, ?_, ?_⟩, ?_, ?_⟩
  · intro x hx
    simp only [C', List.mem_cons] at hx
    rcases hx with rfl | hx
    · refine ⟨le_refl _, ⟨k + b, by omega, ?_⟩, dvd_refl _⟩
      simp only [C']; rw [hk, hcb, pow_add]
    · exact hall x (by rw [hparts]; simp [hx])
  · have : C'.foreign = C.foreign := by
      simp only [Config.foreign, C', hparts, List.filterMap_cons]
    rw [this]; exact hnd
  · simp only [Config.n, Config.sizes, C', hparts, List.map_cons, List.sum_cons, CPart.sizeC,
      one_mul]
  · -- every SAFE term of C' dominates some SAFE term of C
    have hsz : C'.sizes = C.sizes := by
      simp only [Config.sizes, C', hparts, List.map_cons, CPart.sizeC, one_mul]
    unfold Config.safe
    rw [hsz]
    apply le_minL
    · intro y hy
      simp only [C', List.flatMap_cons, List.mem_append] at hy
      rcases hy with (hy | hy) | hy
      · simp only [CPart.safeTerms, Part.terms, List.mem_cons] at hy
        rcases hy with rfl | hy
        · have h1 : F * pairs c ∈ C.parts.flatMap CPart.safeTerms ++ crossN C.sizes := by
            rw [hparts]; simp [CPart.safeTerms, Part.terms]
          exact le_trans (minL_le h1) (by rw [one_mul]; exact mul_pairs_le F c)
        · simp at hy
      · exact minL_le (by rw [hparts]; simp [hy])
      · exact minL_le (List.mem_append_right _ hy)
    · intro h
      have : (1 * pairs (F * c)) ∈ (C'.parts.flatMap CPart.safeTerms ++ crossN C.sizes) := by
        simp [C', CPart.safeTerms, Part.terms]
      rw [h] at this; simp at this

end D1

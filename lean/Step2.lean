/-
# `Step2.lean` — Lemma D2, Step 2's change of origins (H¹ = 0 by averaging)

Lemma D2's Step 2 (`enumeration-proof.md` Part D2): after Step 1, every element of Γ|_O acts as
(i, x) ↦ (σi, a·x + tᵢ) with one multiplier a; the claim is that per-block origins can be
chosen so that every translation part is diagonal, (i, x) ↦ (σi, a·x + s).  The text argues by
H¹(Q, V) = 0, with Q = Γ|_O / T\* of order prime to r and V = (translations)/(diagonal).

This file proves that step as the averaging computation behind H¹ = 0, for an arbitrary finite
group Q (standing for Γ|_O / T\*), over any field K in which |Q| is invertible:

* the data: σ : Q → (ι → ι) (the block action; multiplicativity is not even needed), a : Q → K
  multiplicative
  and nonzero (the common multiplier), and t : Q → (ι → K) (translation parts, one
  representative per element of Q) that is a **cocycle modulo constants**:
  tₕg(i) − tₕg(j) = a_h·(t_g(i) − t_g(j)) + t_h(σg i) − t_h(σg j);
* `origin_change` — with o := −|Q|⁻¹ Σ_h a_h⁻¹ t_h, every element's new translation part
  a_g·o_i + t_g(i) − o_{σg i} is the same for all blocks i.  That is Step 2's conclusion.

"Modulo constants" is what lets t be read off any representative of a coset of T\* (the
diagonal translations change t by a constant), so this is exactly the statement on V.

**Not formalised:** extracting (σ, a, t) from Γ|_O and checking the cocycle identity — the
glue from `Chain.lean`'s `step1_full`/`step2_common_mult` — and the input that |Q| is prime to r
(Sylow-r of Γ|_O is exactly T\*, which follows from `rElem_is_translation` plus T\* ≅ C_r).
-/
import Mathlib

namespace Step2
open Finset

variable {Q : Type*} [Group Q] [Fintype Q] {ι : Type*} {K : Type*} [Field K]

/-- **Step 2: the change of origins.**  Averaging the cocycle over Q gives origins o in which
every element's translation part is constant across blocks. -/
theorem origin_change (σ : Q → ι → ι)
    (a : Q → K) (ha : ∀ h g, a (h * g) = a h * a g) (ha0 : ∀ h, a h ≠ 0)
    (t : Q → ι → K)
    (hcoc : ∀ h g i j, t (h * g) i - t (h * g) j =
      a h * (t g i - t g j) + (t h (σ g i) - t h (σ g j)))
    (hm : (Fintype.card Q : K) ≠ 0) :
    let o : ι → K := fun i => -((Fintype.card Q : K)⁻¹ * ∑ h, (a h)⁻¹ * t h i)
    ∀ g i j, a g * o i + t g i - o (σ g i) = a g * o j + t g j - o (σ g j) := by
  intro o g i j
  set m : K := (Fintype.card Q : K)
  set Z : ι → ι → K := fun i j => ∑ h, (a h)⁻¹ * (t h i - t h j) with hZ
  -- reindex h ↦ h·g
  have hre : Z i j = ∑ h, (a (h * g))⁻¹ * (t (h * g) i - t (h * g) j) := by
    simp only [hZ]
    exact (Fintype.sum_equiv (Equiv.mulRight g) _ _ (fun h => rfl)).symm
  have hexp : ∀ h, (a (h * g))⁻¹ * (t (h * g) i - t (h * g) j) =
      (a g)⁻¹ * (t g i - t g j) +
        (a g)⁻¹ * ((a h)⁻¹ * (t h (σ g i) - t h (σ g j))) := by
    intro h
    rw [hcoc, ha]
    field_simp [ha0 h, ha0 g]
  have hZ' : Z i j = m * ((a g)⁻¹ * (t g i - t g j)) + (a g)⁻¹ * Z (σ g i) (σ g j) := by
    rw [hre]
    simp only [hexp, sum_add_distrib, sum_const, card_univ, nsmul_eq_mul, hZ, ← mul_sum]
    rfl
  -- o_i − o_j = −Z i j / m, and likewise at σ g
  have ho : ∀ i j, o i - o j = -(m⁻¹ * Z i j) := by
    intro i j
    simp only [o, hZ, mul_sub, sum_sub_distrib]
    simp only [m]
    ring
  have key : (a g * o i + t g i - o (σ g i)) - (a g * o j + t g j - o (σ g j)) = 0 := by
    have h1 := ho i j
    have h2 := ho (σ g i) (σ g j)
    have : (a g * o i + t g i - o (σ g i)) - (a g * o j + t g j - o (σ g j)) =
        a g * (o i - o j) + (t g i - t g j) - (o (σ g i) - o (σ g j)) := by ring
    rw [this, h1, h2, hZ']
    field_simp [ha0 g, hm]
    ring
  exact sub_eq_zero.mp key

end Step2

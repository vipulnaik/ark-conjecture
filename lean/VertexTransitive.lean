/-
# `VertexTransitive.lean` — the vertex-transitive Oliver-resistance threshold, n·(q(n) − 1)/2

`orbital-evasiveness-notes.md` §7.2, fact 8.  A monotone graph property P is **vertex-transitive
Oliver-resistant** if every Oliver group transitive on the n vertices has an orbital in P.
Resistance is monotone in P, so the threshold property "at most B edges" is vertex-transitive
Oliver-resistant exactly when B reaches the least orbital of every transitive Oliver group; the
exact threshold is therefore

  μ\*_vt(n) = max over transitive Oliver Γ ≤ Sym(n) of the least pair-orbital of Γ (`muVT`).

* `vt_orbLe` (given `HypHuppert`): a transitive Oliver group has an orbital of at most
  n(b − 1)/2 pairs, b the size of a least nontrivial block — a prime power dividing n.
* `muVT_le`: μ\*_vt(n) ≤ n(q(n) − 1)/2, q(n) the largest prime-power divisor of n (`qmax`).
* `muVT_ge` (unconditional): μ\*_vt(n) ≥ n(q(n) − 1)/2, by the fused class of n/q(n) blocks of
  𝔽_{q(n)} at full twist (`PartEG`), which is transitive.
* **`muVT_eq`: μ\*_vt(n) = n(q(n) − 1)/2**, and `muVT_le_muStar`: μ\*_vt(n) ≤ μ\*(n), so
  Oliver-resistance's threshold is at least the vertex-transitive one (`muStar_ge_qmax`).
-/
import PartEMu

set_option linter.unusedSectionVars false

namespace VT
open Finset Chain ArkCore E6 Part0 Part0Fr Part0Mu PartEMu

/-- Γ is transitive on the points. -/
def Transitive {V : Type*} (Γ : Subgroup (Equiv.Perm V)) : Prop := ∀ x y : V, ∃ g ∈ Γ, g x = y

/-- **μ\*_vt(n)**: the largest least orbital of a transitive Oliver group on n points — the
threshold of vertex-transitive Oliver-resistance. -/
noncomputable def muVT (n : ℕ) : ℕ :=
  sSup {m | ∃ Γ : Subgroup (Equiv.Perm (Fin n)), OliverG Γ ∧ Transitive Γ ∧ minOrb Γ = m}

open Classical in
/-- q(n): the largest prime-power divisor of n (1 if there is none). -/
noncomputable def qmax (n : ℕ) : ℕ := Nat.findGreatest (fun d => IsPrimePow d ∧ d ∣ n) n

theorem qmax_spec {n : ℕ} (hn : 2 ≤ n) : IsPrimePow (qmax n) ∧ qmax n ∣ n := by
  classical
  have hp := Nat.minFac_prime (show n ≠ 1 by omega)
  exact Nat.findGreatest_spec (P := fun d => IsPrimePow d ∧ d ∣ n) (m := n.minFac)
    (Nat.minFac_le (by omega)) ⟨hp.isPrimePow, Nat.minFac_dvd n⟩

theorem le_qmax {n d : ℕ} (hn : 0 < n) (hd : IsPrimePow d) (hdn : d ∣ n) : d ≤ qmax n := by
  classical
  exact Nat.le_findGreatest (Nat.le_of_dvd hn hdn) ⟨hd, hdn⟩

/-- n·(b − 1)/2 counts the within-block pairs of a block system of F blocks of size b, n = F·b. -/
theorem blockPairs (F b : ℕ) : F * b.choose 2 = F * b * (b - 1) / 2 := by
  rw [Nat.choose_two_right, Nat.mul_assoc, Nat.mul_div_assoc _ (Nat.even_mul_pred_self b).two_dvd]

/-- **The upper half of fact 8**: a transitive Oliver group on n ≥ 2 points has an orbital of at
most n(b − 1)/2 pairs, b a prime power dividing n (the size of a least nontrivial block). -/
theorem vt_orbLe (HH : HypHuppert) {V : Type} [Fintype V] [DecidableEq V]
    (Γ : Subgroup (Equiv.Perm V)) {p q : ℕ} (C : OliverChain Γ p q) (hp : p.Prime) (hq : q.Prime)
    (htr : Transitive Γ) (hn : 2 ≤ Fintype.card V) :
    ∃ b, IsPrimePow b ∧ b ∣ Fintype.card V ∧ OrbLe Γ (Fintype.card V * (b - 1) / 2) := by
  classical
  have hS : ∀ g ∈ Γ, ∀ x ∈ (univ : Finset V), g x ∈ univ := fun _ _ _ _ => mem_univ _
  obtain ⟨B, -, hB, hB2, hmin⟩ := exists_least_block hS (by rwa [card_univ])
  have htr' : ∀ x ∈ (univ : Finset V), ∀ y ∈ (univ : Finset V), ∃ g ∈ Γ, g x = y :=
    fun x _ y _ => htr x y
  have hcard := blockSys_card hS htr' (subset_univ B) (card_pos.mp (by omega)) hB
  rw [card_univ] at hcard
  have hpp : IsPrimePow B.card := by
    rcases block_kind HH C hp hq htr' (subset_univ B) hB hB2 hmin with ⟨k, hk, hk'⟩ | ⟨hpr, -⟩
    · exact ⟨p, k, hp.prime, hk, hk'.symm⟩
    · exact hpr.isPrimePow
  refine ⟨B.card, hpp, ⟨_, by rw [hcard, Nat.mul_comm]⟩, ?_⟩
  have := blocks_orbLe (fun X hX => blockSys_size hX) hB2 (blockSys_nonempty B) blockSys_inv
    (Γ := Γ)
  rwa [blockPairs, ← hcard] at this

/-- **μ\*_vt(n) ≤ n(q(n) − 1)/2** (given `HypHuppert`). -/
theorem muVT_le (HH : HypHuppert) {n : ℕ} (hn : 2 ≤ n) : muVT n ≤ n * (qmax n - 1) / 2 := by
  apply csSup_le'
  rintro m ⟨Γ, ⟨p, q, hp, hq, ⟨C⟩⟩, htr, rfl⟩
  obtain ⟨b, hb, hbn, hle⟩ := vt_orbLe HH Γ C hp hq htr (by simpa using hn)
  rw [Fintype.card_fin] at hbn hle
  refine (minOrb_le hle).trans (Nat.div_le_div_right (Nat.mul_le_mul_left _ ?_))
  have := le_qmax (by omega) hb hbn
  omega

/-- **μ\*_vt(n) ≥ n(q(n) − 1)/2**, unconditionally: the fused class of n/q(n) blocks of 𝔽_{q(n)} at
full twist is a transitive Oliver group with this least orbital. -/
theorem muVT_ge {n : ℕ} (hn : 2 ≤ n) : n * (qmax n - 1) / 2 ≤ muVT n := by
  obtain ⟨hQ, F, hF⟩ := qmax_spec hn
  obtain ⟨p, b, hp', hb, hpb⟩ := hQ
  have hp : p.Prime := Nat.prime_iff.mpr hp'
  have hF1 : 1 ≤ F := by
    rcases Nat.eq_zero_or_pos F with h | h
    · subst h; simp at hF; omega
    · exact h
  have : Fact p.Prime := ⟨hp⟩
  have : NeZero F := ⟨by omega⟩
  have : ∀ j : Fin 0, Fact (Nat.Prime (Fin.elim0 j : ℕ)) := fun j => j.elim0
  obtain ⟨X, i1, i2, G, hX, ⟨ch⟩, htr, horb⟩ :=
    PartEG.partE_M_exists (F := fun _ : Fin 1 => F) (r := (Fin.elim0 : Fin 0 → ℕ)) p 2
      (fun _ => b) (fun _ => by omega) Fin.elim0 (fun j => j.elim0) (fun j => j.elim0)
      (fun j => j.elim0)
  have hcfg : PartEG.cfgM p 2 (fun _ : Fin 1 => F) (fun _ => b) (Fin.elim0 : Fin 0 → ℕ)
      Fin.elim0 = ⟨p, 2, [.pc F (p ^ b) (p ^ b - 1)]⟩ := by
    simp [PartEG.cfgM]
  rw [hcfg] at hX horb
  have hQ2 : 2 ≤ p ^ b := le_trans hp.two_le (Nat.le_self_pow (by omega) _)
  have hXn : Fintype.card X = n := by
    rw [hX, hF, ← hpb]; simp [Config.n, Config.sizes, CPart.sizeC, Nat.mul_comm]
  have hR : RealCfg ⟨p, 2, [.pc F (p ^ b) (p ^ b - 1)]⟩ := by
    simpa using real_mk p 2 F b [] hF1 hb (by simp) (by simp) (by simp)
  rw [refined_real hR] at horb
  have hsafe := fused_safe p 2 F b hF1 hQ2
  have hval : n * (qmax n - 1) / 2 = F * p ^ b * (p ^ b - 1) / 2 := by
    have hF' : n = F * p ^ b := by rw [hpb, Nat.mul_comm]; exact hF
    rw [← hpb, hF']
  obtain ⟨Γ, hΓ, hmin, htrΓ⟩ := transport G hp Nat.prime_two ch (by rw [hXn]; exact hn)
    (fun e he => le_trans hsafe (horb e he))
  rw [hval]
  have hbdd : BddAbove
      {m | ∃ Γ : Subgroup (Equiv.Perm (Fin n)), OliverG Γ ∧ Transitive Γ ∧ minOrb Γ = m} :=
    ⟨pairs n, by rintro m ⟨Γ, -, -, rfl⟩; have := minOrb_le_pairs Γ; rwa [Fintype.card_fin] at this⟩
  have htrΓ' := htrΓ (htr rfl rfl)
  clear htrΓ
  revert Γ
  rw [hXn]
  intro Γ hΓ hmin htrΓ'
  exact hmin.trans (le_csSup hbdd ⟨Γ, hΓ, htrΓ', rfl⟩)

/-- **Fact 8: the vertex-transitive Oliver-resistance threshold is exactly n·(q(n) − 1)/2**
(given `HypHuppert` for the upper half). -/
theorem muVT_eq (HH : HypHuppert) {n : ℕ} (hn : 2 ≤ n) : muVT n = n * (qmax n - 1) / 2 :=
  le_antisymm (muVT_le HH hn) (muVT_ge hn)

/-- Vertex-transitive resistance is the weaker condition, so its threshold is the smaller. -/
theorem muVT_le_muStar (n : ℕ) : muVT n ≤ muStar n := by
  apply csSup_le'
  rintro m ⟨Γ, hΓ, -, rfl⟩
  exact le_muStar hΓ

/-- **μ\*(n) ≥ n·(q(n) − 1)/2**, unconditionally: the vertex-transitive threshold under the
Oliver one. -/
theorem muStar_ge_qmax {n : ℕ} (hn : 2 ≤ n) : n * (qmax n - 1) / 2 ≤ muStar n :=
  (muVT_ge hn).trans (muVT_le_muStar n)

end VT

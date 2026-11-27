/-
# `CrossOrbit.lean` — the fibre bound behind "only intra terms bind" (`three-uniform-note.md` §4.1)

G acts on X, A ⊆ X is G-invariant, and N ≤ G fixes A pointwise.  For a finite set S,

  |G·S| ≥ |G·(S ∩ A)| · |N·S|                                             (`cross_orbit`)

so a set split across A and its complement has orbit at least the orbit of its A-part times the
number of ways the elements acting trivially on A move the rest.  §4.1's "for each pair in the
pair-orbit, at least s′ choices of the third point" is this with N transitive on the third point's
part — true when the configuration's group contains that part's translations acting trivially on
the pair's part, and not for an arbitrary Oliver group (see the note).
-/
import Mathlib

namespace CrossOrbit
open MulAction Pointwise

variable {G X : Type*} [Group G] [Finite G] [MulAction G X] [DecidableEq X]

theorem cross_orbit (A : Set X) [DecidablePred (· ∈ A)] (hA : ∀ (g : G) (x : X), g • x ∈ A ↔ x ∈ A)
    (N : Subgroup G) (hN : ∀ n ∈ N, ∀ x ∈ A, n • x = x) (S : Finset X) :
    (orbit G (S.filter (· ∈ A))).ncard * (orbit N S).ncard ≤ (orbit G S).ncard := by
  set SA := S.filter (· ∈ A)
  set St := stabilizer G S
  set StA := stabilizer G SA
  have hfilt : ∀ g : G, g • SA = (g • S).filter (· ∈ A) := fun g => by
    ext x
    simp only [SA, Finset.mem_smul_finset, Finset.mem_filter]
    constructor
    · rintro ⟨y, ⟨hyS, hyA⟩, rfl⟩; exact ⟨⟨y, hyS, rfl⟩, (hA g y).mpr hyA⟩
    · rintro ⟨⟨y, hyS, rfl⟩, hxA⟩; exact ⟨y, ⟨hyS, (hA g y).mp hxA⟩, rfl⟩
  have hle : St ≤ StA := fun g hg => by
    rw [mem_stabilizer_iff] at hg ⊢; rw [hfilt, hg]
  have hNle : N ≤ StA := fun n hn => by
    rw [mem_stabilizer_iff]
    ext x
    simp only [SA, Finset.mem_smul_finset, Finset.mem_filter]
    constructor
    · rintro ⟨y, ⟨hyS, hyA⟩, rfl⟩; rw [hN n hn y hyA]; exact ⟨hyS, hyA⟩
    · rintro ⟨hxS, hxA⟩; exact ⟨x, ⟨hxS, hxA⟩, hN n hn x hxA⟩
  have hmul := Subgroup.relIndex_mul_index hle
  have hne : St.relIndex StA ≠ 0 := by
    intro h0; rw [h0, zero_mul] at hmul
    exact Subgroup.index_ne_zero_of_finite hmul.symm
  have hNSt : St.relIndex N ≤ St.relIndex StA := Subgroup.relIndex_le_of_le_right hNle hne
  have hstabN : stabilizer N S = St.subgroupOf N := by
    ext n; simp [mem_stabilizer_iff, St, Subgroup.smul_def]
  rw [← index_stabilizer, ← index_stabilizer, ← index_stabilizer, hstabN, ← hmul]
  rw [Nat.mul_comm]
  exact Nat.mul_le_mul_right _ hNSt

end CrossOrbit

/-
# `LemmaBprime.lean` — Lemma B′: an outside block has prime size, and its twist is a q-group

Lemma B′ (`enumeration-proof.md` Part B): on a primitive outside block, G = Γ|_O = V ⋊ H is
affine with V = 𝔽_{p₀}^a (p₀ ≠ p) and H irreducible.  Then a = 1, and the twist H ≅ G/V is a
q-group; in the degenerate case (middle layer trivial on O) p₀ = q.

The proof uses only these properties of the affine group, stated abstractly here:
* `V` is a normal abelian p₀-subgroup, nontrivial;
* **C_G(V) ≤ V** (`hcent`);
* **V is minimal normal** (`hmin`: a normal subgroup inside V is ⊥ or V) — for an affine group
  this is exactly irreducibility of H, since the normal subgroups of G inside V are the
  H-submodules.

* `step0` — **every nontrivial normal subgroup contains V** (the text's Step 0, using both
  irreducibility and C_G(V) = V, as the text's "two dependencies" note says).
* **`lemmaBprime`** — V is cyclic (so, being elementary abelian, of order p₀: `card_eq_prime`),
  G/V is a q-group, and if the middle layer is trivial then p₀ = q.  Both of the text's cases:
  Case 1 (middle layer nontrivial: it contains V, is cyclic and abelian, so equals V) and
  Case 2 (middle layer trivial: G is a q-group; a central subgroup of order q is normal, so
  contains V by Step 0).

**`lemmaBprime_primitive`** (end of file) needs **no affine-form input at all**: from the chain
and primitivity it proves |X| is prime and the twist is a q-group, bypassing the classical
"solvable primitive ⇒ affine" theorem, which Mathlib does not have.
-/
import Chain

namespace LemmaBprime
open Chain

variable {G : Type*} [Group G] [Finite G]

omit [Finite G] in
/-- **Step 0.**  With V minimal normal and C_G(V) ≤ V, every nontrivial normal subgroup of G
contains V. -/
theorem step0 (V : Subgroup G) [V.Normal] (hcent : Subgroup.centralizer V ≤ V)
    (hmin : ∀ M : Subgroup G, M.Normal → M ≤ V → M = ⊥ ∨ M = V)
    (N : Subgroup G) [hN : N.Normal] (hNt : N ≠ ⊥) : V ≤ N := by
  have hnorm : (N ⊓ V).Normal := Subgroup.normal_inf_normal N V
  rcases hmin (N ⊓ V) hnorm inf_le_right with h | h
  · exfalso
    apply hNt
    -- [N, V] ≤ N ⊓ V = 1, so N centralises V, so N ≤ V, so N = N ⊓ V = 1
    have hNC : N ≤ Subgroup.centralizer V := by
      intro n hn
      rw [Subgroup.mem_centralizer_iff]
      intro v hv
      have h1 : n * v * n⁻¹ * v⁻¹ ∈ N := by
        have := hN.conj_mem n⁻¹ (N.inv_mem hn) v
        have h2 : n * (v * n⁻¹ * v⁻¹) ∈ N := N.mul_mem hn (by simpa using this)
        simpa [mul_assoc] using h2
      have h2 : n * v * n⁻¹ * v⁻¹ ∈ V := by
        have := (inferInstance : V.Normal).conj_mem v hv n
        exact V.mul_mem this (V.inv_mem hv)
      have h3 : n * v * n⁻¹ * v⁻¹ ∈ N ⊓ V := ⟨h1, h2⟩
      rw [h, Subgroup.mem_bot] at h3
      have : n * v = v * n := by
        calc n * v = (n * v * n⁻¹ * v⁻¹) * (v * n) := by group
          _ = v * n := by rw [h3, one_mul]
      exact this.symm
    have hNV : N ≤ V := hNC.trans hcent
    rw [← h]; exact (le_inf le_rfl hNV).antisymm inf_le_left
  · rw [← h]; exact inf_le_left

omit [Finite G] in
theorem nontrivial_pgroup_disjoint {P : Subgroup G} {a b : ℕ} (ha : a.Prime) (hb : b.Prime)
    (hab : a ≠ b) (hPa : IsPGroup a P) (hPb : IsPGroup b P) : P = ⊥ := by
  rw [eq_bot_iff]
  intro x hx
  obtain ⟨i, hi⟩ := isPGroup_iff_orderOf_dvd_pow.mp hPa ⟨x, hx⟩
  obtain ⟨j, hj⟩ := isPGroup_iff_orderOf_dvd_pow.mp hPb ⟨x, hx⟩
  rw [Subgroup.orderOf_mk] at hi hj
  rw [Subgroup.mem_bot]
  exact eq_one_of_orderOf_dvd_two ha hb hab hi hj

/-- **Lemma B′.** -/
theorem lemmaBprime {p q p₀ : ℕ} (C : OliverChain G p q) (hp : p.Prime) (hq : q.Prime)
    (hp₀ : p₀.Prime) (hp₀p : p₀ ≠ p) (V : Subgroup G) [hVn : V.Normal]
    (hVp₀ : IsPGroup p₀ V) (hVnt : V ≠ ⊥)
    (hcent : Subgroup.centralizer V ≤ V)
    (hmin : ∀ M : Subgroup G, M.Normal → M ≤ V → M = ⊥ ∨ M = V) :
    IsCyclic V ∧ IsPGroup q (G ⧸ V) ∧ (C.N₁ = ⊥ → p₀ = q) := by
  classical
  -- the bottom layer is trivial on O
  have hN2 : C.N₂ = ⊥ := by
    by_contra hne
    have := C.n₂
    have hVN2 : V ≤ C.N₂ := step0 V hcent hmin C.N₂ hne
    exact hVnt (nontrivial_pgroup_disjoint hp₀ hp hp₀p hVp₀ (C.bot.to_le hVN2))
  -- so the middle layer is cyclic
  have hcyc : IsCyclic C.N₁ := by
    have := C.n₂
    have : (C.N₂.subgroupOf C.N₁).Normal := Subgroup.normal_subgroupOf
    have := C.layer
    let f : C.N₁ →* C.N₁ ⧸ C.N₂.subgroupOf C.N₁ := QuotientGroup.mk' _
    have hf : Function.Injective f := by
      rw [← MonoidHom.ker_eq_bot_iff, eq_bot_iff]
      intro x hx
      rw [MonoidHom.mem_ker, QuotientGroup.mk'_apply, QuotientGroup.eq_one_iff,
        Subgroup.mem_subgroupOf, hN2, Subgroup.mem_bot] at hx
      rw [Subgroup.mem_bot]; exact Subtype.ext hx
    exact isCyclic_of_injective f hf
  -- a subgroup of a cyclic group is cyclic
  have cyc_of_le : ∀ {A B : Subgroup G}, A ≤ B → IsCyclic B → IsCyclic A := by
    intro A B hAB hB
    have : IsCyclic (A.subgroupOf B) := Subgroup.isCyclic _
    exact isCyclic_of_surjective (Subgroup.subgroupOfEquivOfLe hAB).toMonoidHom
      (Subgroup.subgroupOfEquivOfLe hAB).surjective
  by_cases hN1 : C.N₁ = ⊥
  · -- Case 2: G is a q-group
    have := C.n₁
    have hGq : IsPGroup q G := by
      apply C.top.of_injective (QuotientGroup.mk' C.N₁)
      rw [← MonoidHom.ker_eq_bot_iff, QuotientGroup.ker_mk', hN1]
    have hFq : Fact q.Prime := ⟨hq⟩
    have hGnt : Nontrivial G := by
      by_contra h
      rw [not_nontrivial_iff_subsingleton] at h
      exact hVnt (Subsingleton.elim _ _)
    -- a central element of order q
    have hZnt := hGq.center_nontrivial
    have hZq : IsPGroup q (Subgroup.center G) := hGq.to_subgroup _
    obtain ⟨⟨z, hzc⟩, hz1⟩ := exists_ne (1 : Subgroup.center G)
    have : Fintype (Subgroup.center G) := Fintype.ofFinite _
    obtain ⟨y, hy⟩ := exists_prime_orderOf_dvd_card (G := Subgroup.center G) q (by
      obtain ⟨k, hk⟩ := hZq.exists_card_eq
      rw [← Nat.card_eq_fintype_card, hk]
      rcases k with _ | k
      · exfalso; rw [pow_zero] at hk
        apply hz1
        have := (Nat.card_eq_one_iff_unique.mp hk).1
        exact Subsingleton.elim _ _
      · exact dvd_pow_self q (by omega))
    set Z := Subgroup.zpowers (y : G)
    have hZnorm : Z.Normal := by
      constructor
      intro n hn g
      obtain ⟨k, rfl⟩ := hn
      have hc : g * (y : G) = (y : G) * g := (Subgroup.mem_center_iff.mp y.2 g)
      have : g * (y : G) ^ k * g⁻¹ = (y : G) ^ k := by
        rw [(Commute.zpow_right hc k).eq]; group
      rw [this]; exact Subgroup.zpow_mem_zpowers _ k
    have hZne : Z ≠ ⊥ := by
      intro h
      have hy1 : (y : G) = 1 := by
        have : (y : G) ∈ Z := Subgroup.mem_zpowers _
        rw [h, Subgroup.mem_bot] at this; exact this
      have : y = 1 := Subtype.ext hy1
      rw [this, orderOf_one] at hy
      exact hq.one_lt.ne hy
    have hVZ : V ≤ Z := step0 V hcent hmin Z hZne
    refine ⟨cyc_of_le hVZ (by exact Subgroup.isCyclic_zpowers _), hGq.to_quotient V, fun _ => ?_⟩
    -- V is both a p₀-group and a q-group, and nontrivial
    by_contra hne
    exact hVnt (nontrivial_pgroup_disjoint hp₀ hq hne hVp₀ (hGq.to_subgroup V))
  · -- Case 1: the middle layer contains V, is abelian, so equals V
    have := C.n₁
    have hVN1 : V ≤ C.N₁ := step0 V hcent hmin C.N₁ hN1
    have hN1V : C.N₁ ≤ V := by
      intro n hn
      apply hcent
      rw [Subgroup.mem_centralizer_iff]
      intro v hv
      have hcomm := IsCyclic.commGroup (α := C.N₁) |>.mul_comm ⟨v, hVN1 hv⟩ ⟨n, hn⟩
      exact congrArg Subtype.val hcomm
    have heq : C.N₁ = V := le_antisymm hN1V hVN1
    refine ⟨cyc_of_le hVN1 hcyc, heq ▸ C.top, fun h => absurd h hN1⟩

omit [Finite G] in
/-- **a = 1**: a cyclic group of exponent p₀ that is nontrivial has order p₀. -/
theorem card_eq_prime {p₀ : ℕ} (hp₀ : p₀.Prime) (V : Subgroup G) [IsCyclic V] (hVnt : V ≠ ⊥)
    (hexp : ∀ v ∈ V, v ^ p₀ = 1) : Nat.card V = p₀ := by
  obtain ⟨g, hg⟩ := IsCyclic.exists_generator (α := V)
  have hcard : Nat.card V = orderOf g := by
    rw [← Nat.card_zpowers]
    have : Subgroup.zpowers g = ⊤ := by
      rw [eq_top_iff]; intro x _; exact hg x
    rw [this, Subgroup.card_top]
  have hdvd : orderOf g ∣ p₀ := by
    apply orderOf_dvd_of_pow_eq_one
    apply Subtype.ext
    simpa using hexp g g.2
  rcases (Nat.dvd_prime hp₀).mp hdvd with h | h
  · exfalso
    apply hVnt
    rw [h] at hcard
    rw [eq_bot_iff]
    intro x hx
    have : (⟨x, hx⟩ : V) = 1 := (Nat.card_eq_one_iff_unique.mp hcard).1.elim _ _
    rw [Subgroup.mem_bot]; exact congrArg Subtype.val this
  · rw [hcard, h]

/-! ### The concrete affine group: a = 1

O = V = (Fin a → ZMod p₀).  G ≤ Sym(V) contains every translation, every element is affine
(x ↦ A x + g(0) with A additive), and the linear parts act irreducibly.  From these the
abstract hypotheses of `lemmaBprime` follow (`hcent`: C_G(V) = V; `hmin`: V minimal normal), so
the translation subgroup is cyclic, and since it has order p₀^a, **a = 1**. -/

section Affine

variable {a p₀ : ℕ} [Fact p₀.Prime]

/-- Translations of V. -/
def τ : Multiplicative (Fin a → ZMod p₀) →* Equiv.Perm (Fin a → ZMod p₀) where
  toFun v := Equiv.addRight (Multiplicative.toAdd v)
  map_one' := by ext x; simp
  map_mul' u v := by ext x i; simp [add_assoc, add_comm (Multiplicative.toAdd u)]

theorem τ_apply (v : Fin a → ZMod p₀) (x : Fin a → ZMod p₀) :
    τ (Multiplicative.ofAdd v) x = x + v := rfl

theorem τ_injective : Function.Injective (τ (a := a) (p₀ := p₀)) := by
  intro u v h
  have := congrArg (fun g : Equiv.Perm (Fin a → ZMod p₀) => g 0) h
  simp only [τ, MonoidHom.coe_mk, OneHom.coe_mk, Equiv.coe_addRight, zero_add] at this
  exact Multiplicative.toAdd.injective this

/-- The translation subgroup of G. -/
def Tsub (G : Subgroup (Equiv.Perm (Fin a → ZMod p₀))) : Subgroup G :=
  (τ (a := a) (p₀ := p₀)).range.comap G.subtype

/-- Conjugating a translation by an affine map. -/
theorem conj_τ {g : Equiv.Perm (Fin a → ZMod p₀)} {A : (Fin a → ZMod p₀) →+ (Fin a → ZMod p₀)}
    (hg : ∀ x, g x = A x + g 0) (v : Fin a → ZMod p₀) :
    g * τ (Multiplicative.ofAdd v) * g⁻¹ = τ (Multiplicative.ofAdd (A v)) := by
  rw [mul_inv_eq_iff_eq_mul]
  refine Equiv.ext fun x => ?_
  simp only [Equiv.Perm.mul_apply, τ_apply, hg (x + v), hg x, map_add]
  abel

theorem lemmaBprime_affine {p q : ℕ} (G : Subgroup (Equiv.Perm (Fin a → ZMod p₀)))
    (C : OliverChain G p q) (hp : p.Prime) (hq : q.Prime) (hp₀p : p₀ ≠ p) (ha : 0 < a)
    (htrans : ∀ v, τ (Multiplicative.ofAdd v) ∈ G)
    (haff : ∀ g ∈ G, ∃ A : (Fin a → ZMod p₀) →+ (Fin a → ZMod p₀), ∀ x, g x = A x + g 0)
    (hirr : ∀ W : AddSubgroup (Fin a → ZMod p₀),
      (∀ g ∈ G, ∀ A : (Fin a → ZMod p₀) →+ (Fin a → ZMod p₀), (∀ x, g x = A x + g 0) →
        ∀ w ∈ W, A w ∈ W) → W = ⊥ ∨ W = ⊤) :
    a = 1 ∧ ∀ g : G, ∃ k : ℕ, g ^ (q ^ k) ∈ Tsub G := by
  classical
  have hp₀ : p₀.Prime := Fact.out
  -- membership in Tsub
  have hmemT : ∀ x : G, x ∈ Tsub G ↔ ∃ v, (x : Equiv.Perm (Fin a → ZMod p₀)) = τ (Multiplicative.ofAdd v) := by
    intro x
    simp only [Tsub, Subgroup.mem_comap, Subgroup.coe_subtype, MonoidHom.mem_range]
    constructor
    · rintro ⟨v, hv⟩; exact ⟨Multiplicative.toAdd v, hv.symm⟩
    · rintro ⟨v, hv⟩; exact ⟨_, hv.symm⟩
  have hnorm : (Tsub G).Normal := by
    constructor
    intro n hn g
    obtain ⟨v, hv⟩ := (hmemT n).mp hn
    obtain ⟨A, hA⟩ := haff g g.2
    rw [hmemT]
    refine ⟨A v, ?_⟩
    simp only [Subgroup.coe_mul, Subgroup.coe_inv, hv]
    exact conj_τ hA v
  -- C_G(V) ≤ V
  have hcent : Subgroup.centralizer (Tsub G) ≤ Tsub G := by
    intro h hh
    rw [Subgroup.mem_centralizer_iff] at hh
    obtain ⟨A, hA⟩ := haff h h.2
    have hAv : ∀ v, A v = v := by
      intro v
      have hvT : (⟨_, htrans v⟩ : G) ∈ Tsub G := (hmemT _).mpr ⟨v, rfl⟩
      have hc := congrArg (fun x : G => (x : Equiv.Perm (Fin a → ZMod p₀)) 0) (hh _ hvT)
      simp only [Subgroup.coe_mul, Equiv.Perm.mul_apply, τ_apply, zero_add] at hc
      rw [hA v] at hc
      -- h 0 + v = A v + h 0
      have : A v + (h : Equiv.Perm (Fin a → ZMod p₀)) 0 = v + (h : Equiv.Perm (Fin a → ZMod p₀)) 0 := by
        rw [← hc]; abel
      exact add_right_cancel this
    rw [hmemT]
    refine ⟨(h : Equiv.Perm (Fin a → ZMod p₀)) 0, Equiv.ext fun x => ?_⟩
    rw [hA x, hAv x, τ_apply]
  -- V minimal normal
  have hmin : ∀ M : Subgroup G, M.Normal → M ≤ Tsub G → M = ⊥ ∨ M = Tsub G := by
    intro M hM hMT
    let W : AddSubgroup (Fin a → ZMod p₀) :=
      { carrier := {v | (⟨_, htrans v⟩ : G) ∈ M}
        zero_mem' := by
          show (⟨_, htrans 0⟩ : G) ∈ M
          have : (⟨_, htrans 0⟩ : G) = 1 := Subtype.ext (by simp [τ]); rw [this]; exact M.one_mem
        add_mem' := by
          intro u v hu hv
          show (⟨_, htrans (u + v)⟩ : G) ∈ M
          have : (⟨_, htrans (u + v)⟩ : G) = ⟨_, htrans u⟩ * ⟨_, htrans v⟩ := by
            apply Subtype.ext; simp only [Subgroup.coe_mul]
            rw [← map_mul]; rfl
          rw [this]; exact M.mul_mem hu hv
        neg_mem' := by
          intro u hu
          show (⟨_, htrans (-u)⟩ : G) ∈ M
          have : (⟨_, htrans (-u)⟩ : G) = (⟨_, htrans u⟩ : G)⁻¹ := by
            apply Subtype.ext; simp only [Subgroup.coe_inv]
            rw [← map_inv]; rfl
          rw [this]; exact M.inv_mem hu }
    have hW : ∀ g ∈ G, ∀ A : (Fin a → ZMod p₀) →+ (Fin a → ZMod p₀), (∀ x, g x = A x + g 0) →
        ∀ w ∈ W, A w ∈ W := by
      intro g hg A hA w hw
      show (⟨_, htrans (A w)⟩ : G) ∈ M
      have := hM.conj_mem _ hw ⟨g, hg⟩
      convert this using 1
      apply Subtype.ext
      simp only [Subgroup.coe_mul, Subgroup.coe_inv]
      exact (conj_τ hA w).symm
    have hMW : ∀ m ∈ M, ∃ v ∈ W, (m : Equiv.Perm (Fin a → ZMod p₀)) = τ (Multiplicative.ofAdd v) := by
      intro m hm
      obtain ⟨v, hv⟩ := (hmemT m).mp (hMT hm)
      refine ⟨v, ?_, hv⟩
      show (⟨_, htrans v⟩ : G) ∈ M
      have : (⟨_, htrans v⟩ : G) = m := Subtype.ext hv.symm
      rw [this]; exact hm
    rcases hirr W hW with h | h
    · left
      rw [eq_bot_iff]; intro m hm
      obtain ⟨v, hvW, hv⟩ := hMW m hm
      rw [h, AddSubgroup.mem_bot] at hvW
      rw [Subgroup.mem_bot]; apply Subtype.ext
      rw [hv, hvW]; simp [τ]
    · right
      apply le_antisymm hMT
      intro x hx
      obtain ⟨v, hv⟩ := (hmemT x).mp hx
      have hvW : v ∈ W := h ▸ AddSubgroup.mem_top v
      have : (⟨_, htrans v⟩ : G) = x := Subtype.ext hv.symm
      rw [← this]; exact hvW
  -- V is a nontrivial p₀-group of exponent p₀
  have hexp : ∀ x ∈ Tsub G, x ^ p₀ = 1 := by
    intro x hx
    obtain ⟨v, hv⟩ := (hmemT x).mp hx
    apply Subtype.ext
    simp only [Subgroup.coe_pow, Subgroup.coe_one, hv, ← map_pow]
    convert map_one (τ (a := a) (p₀ := p₀))
    apply Multiplicative.toAdd.injective
    funext i; simp [toAdd_pow]
  have hVp₀ : IsPGroup p₀ (Tsub G) := fun x => ⟨1, by
    rw [pow_one]; exact Subtype.ext (hexp x x.2)⟩
  let e0 : Fin a → ZMod p₀ := Pi.single ⟨0, ha⟩ 1
  have hVnt : Tsub G ≠ ⊥ := by
    intro h
    have hm : (⟨_, htrans e0⟩ : G) ∈ Tsub G := (hmemT _).mpr ⟨e0, rfl⟩
    rw [h, Subgroup.mem_bot] at hm
    have := congrArg (fun x : G => (x : Equiv.Perm (Fin a → ZMod p₀)) 0 ⟨0, ha⟩) hm
    simp [τ_apply, e0] at this
  have := hnorm
  obtain ⟨hcyc, hquot, -⟩ := lemmaBprime C hp hq hp₀ hp₀p (Tsub G) hVp₀ hVnt hcent hmin
  refine ⟨?_, fun g => ?_⟩
  swap
  · obtain ⟨k, hk⟩ := isPGroup_iff_pow_pow_eq_one.mp hquot (QuotientGroup.mk g)
    exact ⟨k, by rw [← QuotientGroup.eq_one_iff, QuotientGroup.mk_pow]; exact hk⟩
  -- |Tsub| = p₀^a, and cyclic of exponent p₀ gives |Tsub| = p₀
  have hcard1 := card_eq_prime hp₀ (Tsub G) hVnt hexp
  have hcard2 : Nat.card (Tsub G) = p₀ ^ a := by
    have : Nat.card (Tsub G) = Nat.card (Fin a → ZMod p₀) := by
      apply Nat.card_congr
      refine Equiv.ofBijective (fun x => (Classical.choose ((hmemT x).mp x.2))) ⟨?_, ?_⟩
      · intro x y hxy
        have hx := Classical.choose_spec ((hmemT x).mp x.2)
        have hy := Classical.choose_spec ((hmemT y).mp y.2)
        apply Subtype.ext; apply Subtype.ext
        rw [hx, hy]; simp only at hxy; rw [hxy]
      · intro v
        refine ⟨⟨⟨_, htrans v⟩, (hmemT _).mpr ⟨v, rfl⟩⟩, ?_⟩
        have hs := Classical.choose_spec ((hmemT (⟨_, htrans v⟩ : G)).mp ((hmemT _).mpr ⟨v, rfl⟩))
        exact Multiplicative.ofAdd.injective (τ_injective hs.symm)
    rw [this, Nat.card_fun, Nat.card_fin, Nat.card_zmod]
  rw [hcard2] at hcard1
  have h1 : p₀ ^ a = p₀ ^ 1 := by rw [pow_one]; exact hcard1
  exact Nat.pow_right_injective hp₀.two_le h1

end Affine

/-! ### Lemma B′ from primitivity alone (no affine-form input)

The text gets the affine form from "a solvable primitive group is affine", which is not in
Mathlib.  For Lemma B′'s conclusion it is not needed: the chain plus primitivity suffice.

* `card_eq_of_abelian_normal` — a nontrivial abelian normal subgroup of a primitive group
  acts regularly, so its order is the degree.
* **`lemmaBprime_primitive`** — G ≤ Sym(X) primitive with an Oliver chain (p, q), |X| ≥ 2 and
  p ∤ |X| (an *outside* block): |X| is prime, and there is a normal subgroup V of order |X|
  (the translations) with every element's qᵏ-th power in V (the twist is a q-group); if the
  middle layer is trivial then |X| = q.  Route: Γ₂ would be transitive, forcing |X| a power of
  p, so Γ₂ = 1; then Γ₁ is cyclic, and if nontrivial it is regular, as is its subgroup of
  elements of order p₀, which has order p₀; if Γ₁ = 1, G is a q-group and a central subgroup
  of order q is regular. -/

section Primitive

variable {X : Type*} [Finite X]

omit [Finite X] in
theorem card_eq_of_abelian_normal (G : Subgroup (Equiv.Perm X))
    [MulAction.IsPreprimitive G X] (A : Subgroup G) [A.Normal]
    (hAb : ∀ a ∈ A, ∀ b ∈ A, a * b = b * a) (hA : A ≠ ⊥) : Nat.card A = Nat.card X := by
  classical
  obtain ⟨a, ha1⟩ := (Subgroup.ne_bot_iff_exists_ne_one).mp hA
  have : ((a : G) : Equiv.Perm X) ≠ 1 := by
    intro h; apply ha1; apply Subtype.ext; apply Subtype.ext; exact h
  obtain ⟨x0, hx0⟩ : ∃ x, ((a : G) : Equiv.Perm X) x ≠ x := by
    by_contra h; push Not at h; exact this (Equiv.ext h)
  have hfix : MulAction.fixedPoints A X ≠ Set.univ := by
    intro h
    have : x0 ∈ MulAction.fixedPoints A X := h ▸ Set.mem_univ x0
    exact hx0 (this a)
  have htr : MulAction.IsPretransitive A X :=
    MulAction.IsQuasiPreprimitive.isPretransitive_of_normal hfix
  have hstab : MulAction.stabilizer A x0 = ⊥ := by
    rw [eq_bot_iff]
    intro s hs
    rw [MulAction.mem_stabilizer_iff] at hs
    rw [Subgroup.mem_bot]
    apply Subtype.ext; apply Subtype.ext
    refine Equiv.ext fun y => ?_
    obtain ⟨b, rfl⟩ := MulAction.exists_smul_eq A x0 y
    have hc : (s : G) * (b : G) = (b : G) * (s : G) := hAb _ s.2 _ b.2
    show (s : G) • ((b : G) • x0) = (b : G) • x0
    rw [← mul_smul, hc, mul_smul]
    exact congrArg _ hs
  have := MulAction.index_stabilizer_of_transitive A x0
  rw [hstab, Subgroup.index_bot] at this
  exact this

/-- **Lemma B′ from primitivity.** -/
theorem lemmaBprime_primitive {p q : ℕ} (G : Subgroup (Equiv.Perm X))
    [MulAction.IsPreprimitive G X] (C : OliverChain G p q) (hp : p.Prime) (hq : q.Prime)
    (hX2 : 2 ≤ Nat.card X) (hpX : ¬ p ∣ Nat.card X) :
    (Nat.card X).Prime ∧ ∃ V : Subgroup G, V.Normal ∧ Nat.card V = Nat.card X ∧
      (∀ g : G, ∃ k : ℕ, g ^ (q ^ k) ∈ V) ∧ (C.N₁ = ⊥ → Nat.card X = q) := by
  classical
  -- a nontrivial normal subgroup is transitive, so |X| divides its order
  have hdvdX : ∀ N : Subgroup G, N.Normal → N ≠ ⊥ → Nat.card X ∣ Nat.card N := by
    intro N hN hNt
    obtain ⟨a, ha1⟩ := (Subgroup.ne_bot_iff_exists_ne_one).mp hNt
    have : ((a : G) : Equiv.Perm X) ≠ 1 := by
      intro h; apply ha1; apply Subtype.ext; apply Subtype.ext; exact h
    obtain ⟨x0, hx0⟩ : ∃ x, ((a : G) : Equiv.Perm X) x ≠ x := by
      by_contra h; push Not at h; exact this (Equiv.ext h)
    have hfix : MulAction.fixedPoints N X ≠ Set.univ := by
      intro h
      have : x0 ∈ MulAction.fixedPoints N X := h ▸ Set.mem_univ x0
      exact hx0 (this a)
    have htr : MulAction.IsPretransitive N X :=
      MulAction.IsQuasiPreprimitive.isPretransitive_of_normal hfix
    have h1 := MulAction.index_stabilizer_of_transitive N x0
    rw [← h1]; exact Subgroup.index_dvd_card _
  -- Γ₂ = 1: otherwise |X| divides a power of p
  have hN2 : C.N₂ = ⊥ := by
    by_contra hne
    have := C.n₂
    have hd := hdvdX C.N₂ this hne
    have : Fact p.Prime := ⟨hp⟩
    obtain ⟨k, hk⟩ := C.bot.exists_card_eq
    rw [hk] at hd
    obtain ⟨j, -, hj⟩ := (Nat.dvd_prime_pow hp).mp hd
    apply hpX
    rw [hj]
    rcases j with _ | j
    · rw [pow_zero] at hj; omega
    · exact dvd_pow_self p (by omega)
  -- so Γ₁ is cyclic
  have hcyc : IsCyclic C.N₁ := by
    have := C.n₂
    have : (C.N₂.subgroupOf C.N₁).Normal := Subgroup.normal_subgroupOf
    have := C.layer
    let f : C.N₁ →* C.N₁ ⧸ C.N₂.subgroupOf C.N₁ := QuotientGroup.mk' _
    have hf : Function.Injective f := by
      rw [← MonoidHom.ker_eq_bot_iff, eq_bot_iff]
      intro x hx
      rw [MonoidHom.mem_ker, QuotientGroup.mk'_apply, QuotientGroup.eq_one_iff,
        Subgroup.mem_subgroupOf, hN2, Subgroup.mem_bot] at hx
      rw [Subgroup.mem_bot]; exact Subtype.ext hx
    exact isCyclic_of_injective f hf
  have hcomm1 : ∀ a ∈ C.N₁, ∀ b ∈ C.N₁, a * b = b * a := by
    intro a ha b hb
    have := IsCyclic.commGroup (α := C.N₁) |>.mul_comm ⟨a, ha⟩ ⟨b, hb⟩
    exact congrArg Subtype.val this
  have := C.n₁
  by_cases hN1 : C.N₁ = ⊥
  · -- G is a q-group; a central subgroup of order q is regular
    have hGq : IsPGroup q G := by
      apply C.top.of_injective (QuotientGroup.mk' C.N₁)
      rw [← MonoidHom.ker_eq_bot_iff, QuotientGroup.ker_mk', hN1]
    have : Fact q.Prime := ⟨hq⟩
    obtain ⟨x, y, hxy⟩ : ∃ x y : X, x ≠ y := by
      have : Nontrivial X := Finite.one_lt_card_iff_nontrivial.mp (by omega)
      exact exists_pair_ne X
    have hGnt : Nontrivial G := by
      by_contra h
      rw [not_nontrivial_iff_subsingleton] at h
      obtain ⟨g, hg⟩ := MulAction.exists_smul_eq G x y
      rw [Subsingleton.elim g 1, one_smul] at hg
      exact hxy hg
    have hZq : IsPGroup q (Subgroup.center G) := hGq.to_subgroup _
    have hZnt := hGq.center_nontrivial
    obtain ⟨w, hw1⟩ := exists_ne (1 : Subgroup.center G)
    have : Fintype (Subgroup.center G) := Fintype.ofFinite _
    obtain ⟨z, hz⟩ := exists_prime_orderOf_dvd_card (G := Subgroup.center G) q (by
      obtain ⟨k, hk⟩ := hZq.exists_card_eq
      rw [← Nat.card_eq_fintype_card, hk]
      rcases k with _ | k
      · exfalso; rw [pow_zero] at hk
        apply hw1
        have := (Nat.card_eq_one_iff_unique.mp hk).1
        exact Subsingleton.elim _ _
      · exact dvd_pow_self q (by omega))
    let M := Subgroup.zpowers (z : G)
    have hMn : M.Normal := by
      constructor
      intro n hn g
      obtain ⟨k, rfl⟩ := hn
      have hc : g * (z : G) = (z : G) * g := (Subgroup.mem_center_iff.mp z.2 g)
      have : g * (z : G) ^ k * g⁻¹ = (z : G) ^ k := by
        rw [(Commute.zpow_right hc k).eq]; group
      show g * (z : G) ^ k * g⁻¹ ∈ M
      rw [this]; exact Subgroup.zpow_mem_zpowers _ k
    have hMab : ∀ a ∈ M, ∀ b ∈ M, a * b = b * a := by
      rintro a ⟨i, rfl⟩ b ⟨j, rfl⟩
      exact (Commute.zpow_zpow_self (z : G) i j).eq
    have hzq : orderOf (z : G) = q := by rw [Subgroup.orderOf_coe]; exact hz
    have hMne : M ≠ ⊥ := by
      intro h
      have : (z : G) ∈ M := Subgroup.mem_zpowers _
      rw [h, Subgroup.mem_bot] at this
      rw [this, orderOf_one] at hzq
      exact hq.one_lt.ne hzq
    have hMX := card_eq_of_abelian_normal G M hMab hMne
    have hMq : Nat.card M = q := by rw [Nat.card_zpowers, hzq]
    rw [hMq] at hMX
    refine ⟨hMX ▸ hq, M, hMn, by rw [← hMX, hMq], fun g => ?_, fun _ => hMX.symm⟩
    obtain ⟨k, hk⟩ := isPGroup_iff_pow_pow_eq_one.mp hGq g
    exact ⟨k, by rw [hk]; exact M.one_mem⟩
  · -- Γ₁ ≠ 1: it is regular, and so is its subgroup of elements of prime order p₀
    have hN1X := card_eq_of_abelian_normal G C.N₁ hcomm1 hN1
    obtain ⟨p₀, hp₀, hp₀X⟩ := Nat.exists_prime_and_dvd (show Nat.card X ≠ 1 by omega)
    have : Fact p₀.Prime := ⟨hp₀⟩
    have : Fintype C.N₁ := Fintype.ofFinite _
    obtain ⟨y, hy⟩ := exists_prime_orderOf_dvd_card (G := C.N₁) p₀
      (by rw [← Nat.card_eq_fintype_card, hN1X]; exact hp₀X)
    let M : Subgroup G :=
      { carrier := {x | x ∈ C.N₁ ∧ x ^ p₀ = 1}
        mul_mem' := by
          rintro a b ⟨ha, ha'⟩ ⟨hb, hb'⟩
          refine ⟨C.N₁.mul_mem ha hb, ?_⟩
          rw [(Commute.mul_pow (hcomm1 a ha b hb)), ha', hb', one_mul]
        one_mem' := ⟨C.N₁.one_mem, one_pow _⟩
        inv_mem' := by
          rintro a ⟨ha, ha'⟩
          exact ⟨C.N₁.inv_mem ha, by rw [inv_pow, ha', inv_one]⟩ }
    have hMn : M.Normal := by
      constructor
      rintro n ⟨hn, hn'⟩ g
      refine ⟨(inferInstance : C.N₁.Normal).conj_mem n hn g, ?_⟩
      rw [conj_pow, hn', mul_one, mul_inv_cancel]
    have hMab : ∀ a ∈ M, ∀ b ∈ M, a * b = b * a := fun a ha b hb => hcomm1 a ha.1 b hb.1
    have hyM : (y : G) ∈ M := ⟨y.2, by
      rw [← Subgroup.coe_pow, ← hy, pow_orderOf_eq_one]; rfl⟩
    have hMne : M ≠ ⊥ := by
      intro h
      rw [h, Subgroup.mem_bot] at hyM
      have : y = 1 := Subtype.ext hyM
      rw [this, orderOf_one] at hy
      exact hp₀.one_lt.ne hy
    have hMX := card_eq_of_abelian_normal G M hMab hMne
    -- M is cyclic (inside Γ₁) of exponent p₀, so of order p₀
    have hMle : M ≤ C.N₁ := fun x hx => hx.1
    have hMcyc : IsCyclic M := by
      have : IsCyclic (M.subgroupOf C.N₁) := Subgroup.isCyclic _
      exact isCyclic_of_surjective (Subgroup.subgroupOfEquivOfLe hMle).toMonoidHom
        (Subgroup.subgroupOfEquivOfLe hMle).surjective
    have hMp := card_eq_prime hp₀ M hMne (fun v hv => hv.2)
    rw [hMp] at hMX
    refine ⟨hMX ▸ hp₀, C.N₁, inferInstance, hN1X, fun g => ?_, fun h => absurd h hN1⟩
    obtain ⟨k, hk⟩ := isPGroup_iff_pow_pow_eq_one.mp C.top (QuotientGroup.mk g)
    exact ⟨k, by rw [← QuotientGroup.eq_one_iff, QuotientGroup.mk_pow]; exact hk⟩

end Primitive

end LemmaBprime

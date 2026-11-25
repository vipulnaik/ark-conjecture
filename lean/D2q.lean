/-
# `D2q.lean` — Lemma D2q (r = q): an orbital of at most F·q pairs

Lemma D2q (`enumeration-proof.md` Part D2): F fused outside blocks of prime size q (the top
prime), 2 ≤ F < q (here 1 ≤ F < q).  Some class has at most F·q pairs, because in suitable
coordinates every element has trivial linear part.

The text proves this through steps (1)–(7).  This file follows the same ideas in a slightly
reorganised form:

* `affine_mul_gen`, `affine_pow` — composition and powers of affine maps;
  `pow_is_translation` — g^(F!·(q−1)) is a translation (block permutation dies at F!,
  multipliers at q − 1).
* `d2q_fixed` — **the heart**: there is a full-support vector v with aᵢ(g)·vᵢ = v_{σ(g)i} for
  every g.  First a nonzero v fixed (under conjugation) by the middle layer N₁: if N₁ contains a
  nonzero translation τ_v, the commutator [n, τ_v] is a translation inside [N₁, N₁] ⊆ Γ₂ — a
  q-element in a p-group — so trivial (the text's step 5); if not, [n, τ_{t₀}] is a translation
  inside N₁, so trivial (step 6).  Then every g fixes v: g^(qᵏ) ∈ N₁ (top is a q-group) and
  g^(F!(q−1)) is a translation, with gcd(qᵏ, F!(q−1)) = 1.  Transitivity gives full support.
* `d2q_affine` — rescaling by v makes every multiplier 1, and `D2.d2q` gives the F·q orbital.
* **`d2q_noB`** — Lemma D2q from the chain, a preserved block system and transitivity, with
  Lemma B derived (`LemmaB.lemmaB_block_any`, which allows r = q).
-/
import D2Full

namespace D2q
open Chain

variable {F q : ℕ}

theorem affine_mul_gen {g₁ g₂ : Equiv.Perm (Pt F q)} {σ₁ σ₂ : Equiv.Perm (Fin F)}
    {a₁ a₂ t₁ t₂ : Fin F → ZMod q} (h₁ : Affine g₁ σ₁ a₁ t₁) (h₂ : Affine g₂ σ₂ a₂ t₂) :
    Affine (g₁ * g₂) (σ₁ * σ₂) (fun i => a₁ (σ₂ i) * a₂ i)
      (fun i => a₁ (σ₂ i) * t₂ i + t₁ (σ₂ i)) := by
  intro pt
  rw [Equiv.Perm.mul_apply, h₂, h₁]
  simp only [Equiv.Perm.mul_apply, Prod.mk.injEq, true_and]
  ring

theorem affine_pow [Fact q.Prime] {g : Equiv.Perm (Pt F q)} {σ : Equiv.Perm (Fin F)}
    {a t : Fin F → ZMod q} (ha : ∀ i, a i ≠ 0) (hg : Affine g σ a t) :
    ∀ n : ℕ, ∃ a' t' : Fin F → ZMod q, (∀ i, a' i ≠ 0) ∧ Affine (g ^ n) (σ ^ n) a' t'
  | 0 => ⟨fun _ => 1, fun _ => 0, fun _ => one_ne_zero, fun pt => by simp⟩
  | n + 1 => by
    obtain ⟨a', t', ha', hg'⟩ := affine_pow ha hg n
    refine ⟨fun i => a' (σ i) * a i, fun i => a' (σ i) * t i + t' (σ i),
      fun i => mul_ne_zero (ha' _) (ha i), ?_⟩
    rw [pow_succ, pow_succ]
    exact affine_mul_gen hg' hg

/-- g^(F!·(q−1)) is a pure translation. -/
theorem pow_is_translation [Fact q.Prime] {g : Equiv.Perm (Pt F q)} {σ : Equiv.Perm (Fin F)}
    {a t : Fin F → ZMod q} (ha : ∀ i, a i ≠ 0) (hg : Affine g σ a t) :
    ∃ t' : Fin F → ZMod q, g ^ (F.factorial * (q - 1)) = trHom (Multiplicative.ofAdd t') := by
  obtain ⟨a', t', ha', hg'⟩ := affine_pow ha hg F.factorial
  have hσ : σ ^ F.factorial = 1 := by
    have := orderOf_dvd_card (x := σ)
    rw [Fintype.card_perm, Fintype.card_fin] at this
    exact orderOf_dvd_iff_pow_eq_one.mp this
  rw [hσ] at hg'
  obtain ⟨c, hc⟩ := affine_pow_one hg' (q - 1)
  refine ⟨c, ?_⟩
  rw [pow_mul]
  ext pt
  · rw [hc]; rfl
  · rw [hc]
    simp only [trHom, tr, MonoidHom.coe_mk, OneHom.coe_mk, Equiv.coe_fn_mk, toAdd_ofAdd]
    rw [ZMod.pow_card_sub_one_eq_one (ha' pt.1), one_mul]

/-- Translations commute. -/
theorem tr_comm (s t : Fin F → ZMod q) :
    trHom (Multiplicative.ofAdd s) * trHom (Multiplicative.ofAdd t) =
      trHom (Multiplicative.ofAdd t) * trHom (Multiplicative.ofAdd s) := by
  calc trHom (Multiplicative.ofAdd s) * trHom (Multiplicative.ofAdd t)
      = trHom (Multiplicative.ofAdd s * Multiplicative.ofAdd t) := (map_mul _ _ _).symm
    _ = trHom (Multiplicative.ofAdd t * Multiplicative.ofAdd s) := by rw [mul_comm]
    _ = _ := map_mul _ _ _

/-- If gᵐ and gⁿ centralise x and gcd(m, n) = 1, so does g. -/
theorem centralizes_of_coprime {G : Type*} [Group G] {g x : G} {m n : ℕ}
    (hmn : Nat.Coprime m n) (hm : g ^ m * x = x * g ^ m) (hn : g ^ n * x = x * g ^ n) :
    g * x = x * g := by
  have hm' : g ^ m ∈ Subgroup.centralizer {x} := by
    rw [Subgroup.mem_centralizer_singleton_iff]; exact hm
  have hn' : g ^ n ∈ Subgroup.centralizer {x} := by
    rw [Subgroup.mem_centralizer_singleton_iff]; exact hn
  have hg : g ∈ Subgroup.centralizer {x} := by
    have h1 : g = (g ^ m) ^ (Nat.gcdA m n) * (g ^ n) ^ (Nat.gcdB m n) := by
      rw [← zpow_natCast, ← zpow_natCast, ← zpow_mul, ← zpow_mul, ← zpow_add]
      have : (m : ℤ) * Nat.gcdA m n + n * Nat.gcdB m n = 1 := by
        rw [← Nat.gcd_eq_gcd_ab, hmn]; rfl
      rw [this, zpow_one]
    rw [h1]
    exact Subgroup.mul_mem _ (Subgroup.zpow_mem _ hm' _) (Subgroup.zpow_mem _ hn' _)
  rw [Subgroup.mem_centralizer_singleton_iff] at hg
  exact hg

/-- **The heart of D2q.** -/
theorem d2q_fixed [Fact q.Prime] {p : ℕ} (G : Subgroup (Equiv.Perm (Pt F q)))
    (C : OliverChain G p q) (hp : p.Prime) (hpq : q ≠ p) (hF : 0 < F) (hFq : F < q)
    (hB : ∀ g ∈ G, ∃ σ a t, (∀ i, a i ≠ 0) ∧ Affine g σ a t)
    (htr : ∀ x y : Pt F q, ∃ g ∈ G, g x = y) :
    ∃ v : Fin F → ZMod q, (∀ i, v i ≠ 0) ∧ ∀ g ∈ G, ∀ σ a t, Affine g σ a t →
      ∀ i, a i * v i = v (σ i) := by
  classical
  have hq : q.Prime := Fact.out
  -- a vector v ≠ 0 whose translation commutes with the middle layer
  have hfixN : ∃ v : Fin F → ZMod q, v ≠ 0 ∧ trHom (Multiplicative.ofAdd v) ∈ G ∧
      ∀ n (hn : n ∈ G), (⟨n, hn⟩ : G) ∈ C.N₁ →
        n * trHom (Multiplicative.ofAdd v) = trHom (Multiplicative.ofAdd v) * n := by
    obtain ⟨t0, ht0, ht0G⟩ := exists_translation G hFq hF hB htr
    -- the commutator of n with a translation is a translation
    have hcomm : ∀ n ∈ G, ∀ w : Fin F → ZMod q, ∃ w' : Fin F → ZMod q,
        n * trHom (Multiplicative.ofAdd w) * n⁻¹ * (trHom (Multiplicative.ofAdd w))⁻¹ =
          trHom (Multiplicative.ofAdd w') := by
      intro n hn w
      obtain ⟨σ, a, t, -, hna⟩ := hB n hn
      rw [conj_translation hna, ← map_inv, ← map_mul]
      exact ⟨_, rfl⟩
    have hq_tr : ∀ w : Fin F → ZMod q, (trHom (Multiplicative.ofAdd w)) ^ q = 1 := by
      intro w
      rw [← map_pow]
      convert map_one (trHom (F := F) (r := q))
      apply Multiplicative.toAdd.injective
      funext i; simp [toAdd_pow]
    by_cases h5 : ∃ w : Fin F → ZMod q, w ≠ 0 ∧ ∃ hw : trHom (Multiplicative.ofAdd w) ∈ G,
        (⟨_, hw⟩ : G) ∈ C.N₁
    · -- step 5: the commutator lies in [N₁, N₁] ⊆ Γ₂, a p-group
      obtain ⟨w, hw0, hwG, hwN⟩ := h5
      refine ⟨w, hw0, hwG, fun n hn hnN => ?_⟩
      have := C.n₂
      have : (C.N₂.subgroupOf C.N₁).Normal := Subgroup.normal_subgroupOf
      have := C.layer
      -- commutator in N₁ maps to 1 in the abelian quotient
      set x : C.N₁ := ⟨⟨n, hn⟩, hnN⟩
      set y : C.N₁ := ⟨⟨_, hwG⟩, hwN⟩
      have hab : (QuotientGroup.mk (x * y * x⁻¹ * y⁻¹) : C.N₁ ⧸ C.N₂.subgroupOf C.N₁) = 1 := by
        have hc : ∀ a b : C.N₁ ⧸ C.N₂.subgroupOf C.N₁, a * b = b * a :=
          fun a b => IsCyclic.commGroup.mul_comm a b
        simp only [QuotientGroup.mk_mul, QuotientGroup.mk_inv]
        rw [hc (QuotientGroup.mk x) (QuotientGroup.mk y)]
        group
      rw [QuotientGroup.eq_one_iff, Subgroup.mem_subgroupOf] at hab
      obtain ⟨w', hw'⟩ := hcomm n hn w
      -- it is a translation, of order dividing q, in a p-group: trivial
      have hc2 : ((x * y * x⁻¹ * y⁻¹ : C.N₁) : G) ∈ C.N₂ := hab
      obtain ⟨k, hk⟩ := isPGroup_iff_orderOf_dvd_pow.mp C.bot ⟨_, hc2⟩
      rw [Subgroup.orderOf_mk] at hk
      have hval : (((x * y * x⁻¹ * y⁻¹ : C.N₁) : G) : Equiv.Perm (Pt F q)) =
          trHom (Multiplicative.ofAdd w') := by
        rw [← hw']; rfl
      have hq1 : orderOf ((x * y * x⁻¹ * y⁻¹ : C.N₁) : G) ∣ q ^ 1 := by
        apply orderOf_dvd_of_pow_eq_one
        apply Subtype.ext
        rw [pow_one, Subgroup.coe_pow, hval, hq_tr]; rfl
      have h1 := eq_one_of_orderOf_dvd_two hq hp hpq hq1 hk
      have h1' := congrArg (fun z : G => (z : Equiv.Perm (Pt F q))) h1
      simp only [Subgroup.coe_mul, Subgroup.coe_inv, OneMemClass.coe_one, x, y] at h1'
      calc n * trHom (Multiplicative.ofAdd w) =
            (n * trHom (Multiplicative.ofAdd w) * n⁻¹ * (trHom (Multiplicative.ofAdd w))⁻¹) *
              (trHom (Multiplicative.ofAdd w) * n) := by group
        _ = trHom (Multiplicative.ofAdd w) * n := by rw [h1', one_mul]
    · -- step 6: no nonzero translation in N₁, so the commutator, a translation in N₁, is 1
      push Not at h5
      refine ⟨t0, ht0, ht0G, fun n hn hnN => ?_⟩
      obtain ⟨w', hw'⟩ := hcomm n hn t0
      have hmemG : trHom (Multiplicative.ofAdd w') ∈ G := by
        rw [← hw']
        exact G.mul_mem (G.mul_mem (G.mul_mem hn ht0G) (G.inv_mem hn)) (G.inv_mem ht0G)
      have hmemN : (⟨_, hmemG⟩ : G) ∈ C.N₁ := by
        have := C.n₁
        have h1 : (⟨n, hn⟩ : G) * ((⟨_, ht0G⟩ : G) * (⟨n, hn⟩ : G)⁻¹ * (⟨_, ht0G⟩ : G)⁻¹) ∈
            C.N₁ := C.N₁.mul_mem hnN (by
              have := this.conj_mem _ (C.N₁.inv_mem hnN) ⟨_, ht0G⟩
              simpa [mul_assoc] using this)
        convert h1 using 1
        apply Subtype.ext
        simp only [Subgroup.coe_mul, Subgroup.coe_inv]
        rw [← hw']; group
      have hw0 : w' = 0 := by
        by_contra hne
        exact h5 w' hne hmemG hmemN
      rw [hw0] at hw'
      have : n * trHom (Multiplicative.ofAdd t0) * n⁻¹ * (trHom (Multiplicative.ofAdd t0))⁻¹ = 1 := by
        rw [hw']; exact map_one _
      calc n * trHom (Multiplicative.ofAdd t0) =
            (n * trHom (Multiplicative.ofAdd t0) * n⁻¹ * (trHom (Multiplicative.ofAdd t0))⁻¹) *
              (trHom (Multiplicative.ofAdd t0) * n) := by group
        _ = trHom (Multiplicative.ofAdd t0) * n := by rw [this, one_mul]
  obtain ⟨v, hv0, hvG, hvN⟩ := hfixN
  -- every g ∈ G commutes with τ_v
  have hall : ∀ g ∈ G, g * trHom (Multiplicative.ofAdd v) = trHom (Multiplicative.ofAdd v) * g := by
    intro g hg
    have := C.n₁
    obtain ⟨k, hk⟩ := isPGroup_iff_pow_pow_eq_one.mp C.top (QuotientGroup.mk ⟨g, hg⟩)
    have hgk : (⟨g, hg⟩ : G) ^ (q ^ k) ∈ C.N₁ := by
      rw [← QuotientGroup.eq_one_iff, QuotientGroup.mk_pow]; exact hk
    have h1 : g ^ (q ^ k) * trHom (Multiplicative.ofAdd v) =
        trHom (Multiplicative.ofAdd v) * g ^ (q ^ k) :=
      hvN _ (G.pow_mem hg _) (by simpa using hgk)
    obtain ⟨σ, a, t, ha, hga⟩ := hB g hg
    obtain ⟨t', ht'⟩ := pow_is_translation ha hga
    have h2 : g ^ (F.factorial * (q - 1)) * trHom (Multiplicative.ofAdd v) =
        trHom (Multiplicative.ofAdd v) * g ^ (F.factorial * (q - 1)) := by
      rw [ht']; exact tr_comm _ _
    have hcop : Nat.Coprime (q ^ k) (F.factorial * (q - 1)) := by
      apply Nat.Coprime.pow_left
      apply Nat.Coprime.mul_right
      · exact (Nat.Prime.coprime_iff_not_dvd hq).mpr (by rw [hq.dvd_factorial]; omega)
      · exact (Nat.Prime.coprime_iff_not_dvd hq).mpr (fun h => by
          have := Nat.le_of_dvd (by have := hq.one_lt; omega) h; omega)
    exact centralizes_of_coprime hcop h1 h2
  -- so aᵢ vᵢ = v_{σ i}
  have hrel : ∀ g ∈ G, ∀ σ a t, Affine g σ a t → ∀ i, a i * v i = v (σ i) := by
    intro g hg σ a t hga i
    have h := hall g hg
    have h2 : g * trHom (Multiplicative.ofAdd v) * g⁻¹ = trHom (Multiplicative.ofAdd v) := by
      rw [h]; group
    rw [conj_translation hga] at h2
    have := congrFun (congrArg Multiplicative.toAdd (trHom_injective h2)) (σ i)
    simpa using this
  -- full support, by transitivity on blocks
  obtain ⟨i0, hi0⟩ : ∃ i, v i ≠ 0 := by
    by_contra h; push Not at h; exact hv0 (funext h)
  refine ⟨v, fun j => ?_, hrel⟩
  obtain ⟨h, hh, hhj⟩ := htr (i0, 0) (j, 0)
  obtain ⟨σ, a, t, ha, hha⟩ := hB h hh
  have hσ : σ i0 = j := by have := congrArg Prod.fst hhj; rw [hha] at this; exact this
  rw [← hσ, ← hrel h hh σ a t hha i0]
  exact mul_ne_zero (ha i0) hi0

/-- **D2q in affine coordinates**: rescaling by v makes every multiplier 1, and the pairs of
one within-block difference ±1 give an orbital of at most F·q pairs. -/
theorem d2q_affine [Fact q.Prime] {p : ℕ} (G : Subgroup (Equiv.Perm (Pt F q)))
    (C : OliverChain G p q) (hp : p.Prime) (hpq : q ≠ p) (hF : 0 < F) (hFq : F < q)
    (hB : ∀ g ∈ G, ∃ σ a t, (∀ i, a i ≠ 0) ∧ Affine g σ a t)
    (htr : ∀ x y : Pt F q, ∃ g ∈ G, g x = y) :
    ∃ e : Sym2 (Pt F q), ¬ e.IsDiag ∧ (D2.orbit2 G e).card ≤ F * q := by
  classical
  have hq : q.Prime := Fact.out
  have : NeZero q := ⟨hq.ne_zero⟩
  obtain ⟨v, hv, hrel⟩ := d2q_fixed G C hp hpq hF hFq hB htr
  have hform : ∀ g' ∈ Rescale.conjG v hv G, ∃ σ : Equiv.Perm (Fin F), ∃ s : Fin F → ZMod q,
      ∀ pt : Pt F q, g' pt = (σ pt.1, pt.2 + s pt.1) := by
    intro g' hg'
    have hg := Rescale.mem_conjG.mp hg'
    obtain ⟨σ, a, t, -, hga⟩ := hB _ hg
    have hc : ∀ i, a i * v i = 1 * v (σ i) := fun i => by
      rw [one_mul]; exact hrel _ hg σ a t hga i
    have hconj := Rescale.conj_affine v hv hga hc
    have : (Rescale.scale v hv)⁻¹ * (Rescale.scale v hv * g' * (Rescale.scale v hv)⁻¹) *
        Rescale.scale v hv = g' := by simp [mul_assoc]
    rw [this] at hconj
    refine ⟨σ, fun i => (v (σ i))⁻¹ * t i, fun pt => ?_⟩
    rw [hconj pt, one_mul]
  obtain ⟨e, hed, hecard⟩ := D2.d2q (Rescale.conjG v hv G) hF hq.two_le hform
  refine ⟨Sym2.map (Rescale.scale v hv) e, ?_, ?_⟩
  · rwa [Sym2.isDiag_map (Rescale.scale v hv).injective]
  · rw [Rescale.orbit2_conj]; exact hecard

/-- **Lemma D2q, from the chain alone.**  G preserving a block system of F blocks of prime
size q (the top prime), 1 ≤ F < q, transitive, with an Oliver chain (p, q), p ≠ q: some
orbital has at most F·q pairs. -/
theorem d2q_noB [Fact q.Prime] {p : ℕ} (G : Subgroup (Equiv.Perm (Pt F q)))
    (C : OliverChain G p q) (hp : p.Prime) (hpq : q ≠ p) (hF : 0 < F) (hFq : F < q)
    (hblk : ∀ g ∈ G, ∀ i x y, (g (i, x)).1 = (g (i, y)).1)
    (htr : ∀ x y : Pt F q, ∃ g ∈ G, g x = y) :
    ∃ e : Sym2 (Pt F q), ¬ e.IsDiag ∧ (D2.orbit2 G e).card ≤ F * q := by
  classical
  have hq : q.Prime := Fact.out
  have : NeZero q := ⟨hq.ne_zero⟩
  obtain ⟨Ψ, hB'⟩ := D2Full.exists_affine_relabel G C hp hq hpq hF hblk htr
  have htr' : ∀ x y : Pt F q, ∃ g' ∈ D2Full.conjBy Ψ G, g' x = y := by
    intro x y
    obtain ⟨g, hg, hgy⟩ := htr (Ψ x) (Ψ y)
    refine ⟨Ψ⁻¹ * g * Ψ, D2Full.mem_conjBy.mpr (by simpa [mul_assoc] using hg), ?_⟩
    simp [hgy]
  let f : G →* D2Full.conjBy Ψ G := (MulAut.conj Ψ⁻¹).toMonoidHom.subgroupMap G
  have hf : Function.Surjective f := (MulAut.conj Ψ⁻¹).toMonoidHom.subgroupMap_surjective G
  obtain ⟨e, hed, hecard⟩ :=
    d2q_affine (D2Full.conjBy Ψ G) (C.map f hf) hp hpq hF hFq hB' htr'
  refine ⟨Sym2.map Ψ e, ?_, ?_⟩
  · rwa [Sym2.isDiag_map Ψ.injective]
  · rw [D2Full.orbit2_conjBy]; exact hecard

/-- **Lemma D2, all three classes, from the chain.**  For G preserving a block system of F ≥ 2
blocks of prime size r ≠ p, transitive on them, with an Oliver chain (p, q):
(a) some orbital has at most F·C(r,2) pairs; (b) if F < r and r ≠ q, one has at most
C(F,2)·r; (c) if F < r and r = q, one has at most F·r. -/
theorem lemmaD2 {F r p q : ℕ} [Fact r.Prime] (G : Subgroup (Equiv.Perm (Pt F r)))
    (C : OliverChain G p q) (hp : p.Prime) (hq : q.Prime) (hrp : r ≠ p) (hF2 : 2 ≤ F)
    (hblk : ∀ g ∈ G, ∀ i x y, (g (i, x)).1 = (g (i, y)).1)
    (htr : ∀ x y : Pt F r, ∃ g ∈ G, g x = y) :
    (∃ e : Sym2 (Pt F r), ¬ e.IsDiag ∧ (D2.orbit2 G e).card ≤ F * r.choose 2) ∧
    (F < r → r ≠ q →
      ∃ e : Sym2 (Pt F r), ¬ e.IsDiag ∧ (D2.orbit2 G e).card ≤ r * F.choose 2) ∧
    (F < r → r = q →
      ∃ e : Sym2 (Pt F r), ¬ e.IsDiag ∧ (D2.orbit2 G e).card ≤ F * r) := by
  have hr : r.Prime := Fact.out
  have : NeZero r := ⟨hr.ne_zero⟩
  refine ⟨D2.d2a G (by omega) hr.two_le (fun g hg a b hab => by
      rw [hblk g hg a.1 a.2 0, hblk g hg b.1 b.2 0, hab]), ?_, ?_⟩
  · intro hFr hrq
    exact D2Full.d2_noB G C hp hq hrp hrq hF2 hFr hblk htr
  · intro hFr hrq
    subst hrq
    exact d2q_noB G C hp hrp (by omega) hFr hblk htr

end D2q

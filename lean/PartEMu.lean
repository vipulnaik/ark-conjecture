/-
# `PartEMu.lean` — Part E for the shapes E.6 needs, and μ\* = B_safe above 1/25

* `mu_ge`: an Oliver group on n points all of whose orbitals are ≥ m gives μ\*(n) ≥ m (transport
  to `Fin n`).
* `real_le_mu`: every *realisable* configuration — one class at full twist, beside foreign
  blocks of distinct primes with q-power twists, coherent (no foreign r divides F·(c − 1)) —
  has REFINED ≤ μ\*(n), by `PartEG.partE_G_exists`.
* `e6_real`: the SAFE optimum above 1/25 can be taken realisable (D2 parts by `E6.d2_case`,
  Proposition 1, the bare-pair re-reading, a kernel-checked table `badOK_all` where a foreign prime
  divides F, and a re-reading of the smaller prime when there is no class).
* **`e6_mu`: μ\*(n) = B_safe(n) = B_refined(n) above C(n,2)/25, given only `HypHuppert`.**
-/
import PartEG
import Part0Mu
import Prop1Final

set_option linter.unusedSectionVars false

namespace PartEMu
open Finset Chain ArkCore E6 E5Assembly Part0Mu

/-! ## From a realisation on any type to μ\*(n) -/

theorem orbit2_transport {X Y : Type} [Fintype X] [DecidableEq X] [Fintype Y] [DecidableEq Y]
    (e : X ≃ Y) (G : Subgroup (Equiv.Perm X)) (x : Sym2 X) :
    (D2.orbit2 (G.map e.permCongrHom.toMonoidHom) (Sym2.map e x)).card = (D2.orbit2 G x).card := by
  classical
  have hset : D2.orbit2 (G.map e.permCongrHom.toMonoidHom) (Sym2.map e x) =
      (D2.orbit2 G x).image (Sym2.map e) := by
    ext y
    simp only [D2.orbit2, mem_image, mem_filter, mem_univ, true_and, Subgroup.mem_map]
    constructor
    · rintro ⟨g, ⟨h, hh, rfl⟩, rfl⟩
      refine ⟨Sym2.map h x, ⟨h, hh, rfl⟩, ?_⟩
      rw [Sym2.map_map, Sym2.map_map]
      congr 1; funext a; simp [Equiv.permCongrHom, Equiv.permCongr_apply]
    · rintro ⟨_, ⟨h, hh, rfl⟩, rfl⟩
      refine ⟨e.permCongrHom.toMonoidHom h, ⟨h, hh, rfl⟩, ?_⟩
      rw [Sym2.map_map, Sym2.map_map]
      congr 1; funext a; simp [Equiv.permCongrHom, Equiv.permCongr_apply]
  rw [hset, card_image_of_injective _ (Sym2.map.injective e.injective)]

/-- **An Oliver group on n points with every orbital ≥ m gives μ\*(n) ≥ m** (n ≥ 2). -/
theorem mu_ge {X : Type} [Fintype X] [DecidableEq X] (G : Subgroup (Equiv.Perm X)) {p q : ℕ}
    (hp : p.Prime) (hq : q.Prime) (C : OliverChain G p q) {m : ℕ} (hX : 2 ≤ Fintype.card X)
    (horb : ∀ e : Sym2 X, ¬ e.IsDiag → m ≤ (D2.orbit2 G e).card) :
    m ≤ muStar (Fintype.card X) := by
  classical
  set n := Fintype.card X
  let e : X ≃ Fin n := Fintype.equivFin X
  set Γ : Subgroup (Equiv.Perm (Fin n)) := G.map e.permCongrHom.toMonoidHom
  have hΓ : OliverG Γ := ⟨p, q, hp, hq, ⟨C.map (e.permCongrHom.toMonoidHom.subgroupMap G)
    (MonoidHom.subgroupMap_surjective _ _)⟩⟩
  have hmin : m ≤ minOrb Γ := by
    unfold minOrb
    apply le_csInf
    · obtain ⟨a, b, hab⟩ : ∃ a b : Fin n, a ≠ b := ⟨⟨0, by omega⟩, ⟨1, by omega⟩, by simp⟩
      refine ⟨_, D2.orbit2 Γ s(a, b), ?_, rfl⟩
      exact mem_image.mpr ⟨s(a, b), by simp [hab], rfl⟩
    · rintro _ ⟨o, ho, rfl⟩
      obtain ⟨y, hy, rfl⟩ := mem_image.mp ho
      simp only [mem_filter, mem_univ, true_and] at hy
      have hy' : y = Sym2.map e (Sym2.map e.symm y) := by rw [Sym2.map_map]; simp
      show m ≤ (D2.orbit2 Γ y).card
      rw [hy', orbit2_transport]
      apply horb
      rw [hy'] at hy
      intro hd; apply hy
      induction y using Sym2.ind with
      | h a b =>
        simp only [Sym2.map_mk, Sym2.mk_isDiag_iff] at hd ⊢
        rw [hd]
  have hbdd : BddAbove {m | ∃ Γ : Subgroup (Equiv.Perm (Fin n)), OliverG Γ ∧ minOrb Γ = m} :=
    ⟨pairs n, by rintro m ⟨Γ, -, rfl⟩; have := minOrb_le_pairs Γ; rwa [Fintype.card_fin] at this⟩
  exact hmin.trans (le_csSup hbdd ⟨Γ, hΓ, rfl⟩)

/-! ## Realisable configurations -/

/-- **Realisable**: one class of F ≥ 1 blocks of size p^b at full twist, then foreign blocks of
distinct primes rⱼ with q-power twists tⱼ ∣ rⱼ − 1, coherent: no rⱼ divides F·(p^b − 1). -/
def RealCfg (C : Config) : Prop :=
  ∃ (F b k : ℕ) (r t : Fin k → ℕ), 1 ≤ F ∧ 1 ≤ b ∧ C = PartEG.cfgG C.p C.q F (C.p ^ b) r t ∧
    Function.Injective r ∧ (∀ j, (r j).Prime) ∧ (∀ j, t j ∣ r j - 1 ∧ ∃ f, t j = C.q ^ f) ∧
    ∀ j, ¬ r j ∣ F * (C.p ^ b - 1)

/-- **Part E for realisable configurations**: REFINED(C) ≤ μ\*(n). -/
theorem real_le_mu {C : Config} (hp : C.p.Prime) (hq : C.q.Prime) (hR : RealCfg C) :
    C.refined ≤ muStar C.n := by
  obtain ⟨F, b, k, r, t, hF, hb, hC, hinj, hr, ht, hcoh⟩ := hR
  have : Fact C.p.Prime := ⟨hp⟩
  have : ∀ j, Fact (r j).Prime := fun j => ⟨hr j⟩
  have : NeZero F := ⟨by omega⟩
  obtain ⟨X, i1, i2, G, hX, ⟨ch⟩, horb⟩ :=
    PartEG.partE_G_exists (F := F) (r := r) C.p C.q b (by omega) t ht hinj hcoh
  rw [← hC] at hX horb
  have hn2 : 2 ≤ Fintype.card X := by
    rw [hX, hC, PartEG.cfgG_n]
    have : 2 ≤ C.p ^ b := le_trans hp.two_le (Nat.le_self_pow (by omega) _)
    have : 2 ≤ F * C.p ^ b := le_trans this (Nat.le_mul_of_pos_left _ (by omega))
    omega
  have := mu_ge G hp hq ch hn2 horb
  rwa [hX] at this

theorem refined_real {C : Config} (hR : RealCfg C) : C.refined = C.safe := by
  obtain ⟨F, b, k, r, t, -, -, hC, -⟩ := hR
  apply refined_eq_safe
  intro F' c d hx
  rw [hC] at hx
  simp only [PartEG.cfgG, List.mem_cons, List.mem_ofFn, CPart.pc.injEq] at hx
  rcases hx with ⟨-, rfl, rfl⟩ | ⟨j, hj⟩
  · rfl
  · cases hj

/-- A list of foreign parts as a `cfgG`. -/
theorem real_mk (p q F b : ℕ) (Q : List (ℕ × ℕ)) (hF : 1 ≤ F) (hb : 1 ≤ b)
    (hnd : (Q.map Prod.fst).Nodup)
    (hQ : ∀ x ∈ Q, x.1.Prime ∧ x.2 ∣ x.1 - 1 ∧ ∃ f, x.2 = q ^ f)
    (hcoh : ∀ x ∈ Q, ¬ x.1 ∣ F * (p ^ b - 1)) :
    RealCfg ⟨p, q, .pc F (p ^ b) (p ^ b - 1) :: Q.map (fun x => .fr x.1 x.2)⟩ := by
  refine ⟨F, b, Q.length, fun j => (Q.get j).1, fun j => (Q.get j).2, hF, hb, ?_, ?_,
    fun j => (hQ _ (List.get_mem _ _)).1, fun j => (hQ _ (List.get_mem _ _)).2,
    fun j => hcoh _ (List.get_mem _ _)⟩
  · simp only [PartEG.cfgG, Config.mk.injEq, true_and, List.cons.injEq]
    apply List.ext_getElem (by simp)
    intro i h1 h2
    simp
  · intro j1 j2 h
    simp only at h
    have h' : (Q.map Prod.fst)[j1.val]'(by simp) = (Q.map Prod.fst)[j2.val]'(by simp) := by
      simpa using h
    exact Fin.ext ((hnd.getElem_inj_iff).mp h')

/-- The parts of a D2-free configuration, split into classes and foreign parts. -/
theorem split_parts : ∀ (l : List CPart), (∀ F r t, CPart.fo F r t ∉ l) →
    ∃ (P : List (ℕ × ℕ × ℕ)) (Q : List (ℕ × ℕ)),
      P.length = (l.filter Prop1Final.isPc).length ∧ Q.length = (l.filter Prop1Final.isFr).length ∧
      l.Perm (P.map (fun x => CPart.pc x.1 x.2.1 x.2.2) ++ Q.map (fun x => CPart.fr x.1 x.2))
  | [], _ => ⟨[], [], rfl, rfl, by simp⟩
  | x :: l, h => by
    obtain ⟨P, Q, hP, hQ, hp⟩ := split_parts l (fun F r t hx => h F r t (List.mem_cons_of_mem _ hx))
    cases x with
    | pc F c d =>
      refine ⟨(F, c, d) :: P, Q, by simp [hP, List.filter_cons, Prop1Final.isPc],
        by simp [hQ, Prop1Final.isFr], ?_⟩
      simpa using hp
    | fr r t =>
      refine ⟨P, (r, t) :: Q, by simp [hP, Prop1Final.isPc],
        by simp [hQ, List.filter_cons, Prop1Final.isFr], ?_⟩
      simp only [List.map_cons]
      exact (hp.cons _).trans List.perm_middle.symm
    | fo F r t => exact absurd (List.mem_cons_self ..) (h F r t)

/-- Single-class witnesses for the six n at which a foreign prime dividing F could sit above the
line (`badCheck`). -/
def badWits : List (ℕ × ℕ × ℕ × ℕ) :=
  [(6, 3, 1, 2), (9, 3, 2, 1), (12, 2, 2, 3), (15, 5, 1, 3), (20, 5, 1, 4), (28, 7, 1, 4)]

/-- The bound a configuration (F, c) + foreign r ∣ F (+ a second foreign part) cannot exceed. -/
def badBnd (F c r rest : ℕ) : ℕ :=
  min (pairs r) (min (F * pairs c) (min (F * c * r) (if rest = 0 then pairs r else pairs rest)))

/-- The finite check at one (F, r, c, n). -/
def badOK (F r c n : ℕ) : Bool :=
  !(decide (2 ≤ F) && E5Assembly.isPrimeB r && decide (r ∣ F) && decide (2 ≤ c) &&
      decide (F * c + r ≤ n) && decide (n - F * c - r ≠ 1) &&
      decide (pairs n < 25 * badBnd F c r (n - F * c - r))) ||
    badWits.any fun w => w.1 == n &&
      decide (badBnd F c r (n - F * c - r) ≤ (wit w.2.1 w.2.2.1 w.2.2.2).safe)

/-- The (F, r) with 2 ≤ F < 16, r prime, r ∣ F. -/
def badFr : List (ℕ × ℕ) :=
  ((List.range 16).flatMap fun F => (List.range 16).map fun r => (F, r)).filter fun x =>
    decide (2 ≤ x.1) && E5Assembly.isPrimeB x.2 && decide (x.2 ∣ x.1)

theorem mem_badFr {F r : ℕ} (hF : F < 16) (hr : r < 16) (h2 : 2 ≤ F)
    (hp : E5Assembly.isPrimeB r = true) (hd : r ∣ F) : (F, r) ∈ badFr := by
  unfold badFr
  rw [List.mem_filter]
  refine ⟨List.mem_flatMap.mpr ⟨F, List.mem_range.mpr hF,
    List.mem_map.mpr ⟨r, List.mem_range.mpr hr, rfl⟩⟩, ?_⟩
  simp [h2, hp, hd]

set_option maxRecDepth 100000 in
/-- **The finite check**: wherever a class (F, c) with a foreign prime r ∣ F (and possibly a
second foreign part, of size `rest`) could reach above the line, a single-class witness at the
same n scores at least its bound. -/
theorem badOK_all : ∀ x ∈ badFr, ∀ c < 37, ∀ n < 73, badOK x.1 x.2 c n = true := by
  decide +kernel

theorem bad_spec {F r c n : ℕ} (h1 : F < 16) (h2 : r < 16) (h3 : c < 37) (h4 : n < 73)
    (h5 : 2 ≤ F) (h6 : E5Assembly.isPrimeB r = true) (h7 : r ∣ F) (h8 : 2 ≤ c) (h9 : F * c + r ≤ n)
    (h10 : n - F * c - r ≠ 1) (h11 : pairs n < 25 * badBnd F c r (n - F * c - r)) :
    ∃ w ∈ badWits, w.1 = n ∧ badBnd F c r (n - F * c - r) ≤ (wit w.2.1 w.2.2.1 w.2.2.2).safe := by
  have := badOK_all (F, r) (mem_badFr h1 h2 h5 h6 h7) c h3 n h4
  simp only [badOK, decide_eq_true h5, h6, decide_eq_true h7, decide_eq_true h8, decide_eq_true h9,
    decide_eq_true h10, decide_eq_true h11, Bool.and_self, Bool.not_true, Bool.false_or,
    List.any_eq_true, Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq] at this
  exact this

theorem badWits_ok : badWits.all (fun w => E5Assembly.isPrimeB w.2.1 && decide (1 ≤ w.2.2.1) &&
    decide (1 ≤ w.2.2.2) && (wit w.2.1 w.2.2.1 w.2.2.2).n == w.1) = true := by decide

theorem real_wit (p b F : ℕ) (hF : 1 ≤ F) (hb : 1 ≤ b) : RealCfg (wit p b F) := by
  have := real_mk p 2 F b [] hF hb (by simp) (by simp) (by simp)
  simpa [wit] using this

theorem real_reread {c r : ℕ} (hc : c.Prime) (hr : r.Prime) (hcr : c = 2 * r + 1) :
    RealCfg (reread c r) := by
  have := real_mk r r 1 1 [(c, r)] le_rfl le_rfl (by simp)
    (by
      intro x hx
      simp only [List.mem_singleton] at hx
      subst hx
      exact ⟨hc, ⟨2, by simp [hcr]; ring⟩, 1, by simp⟩)
    (by
      intro x hx
      simp only [List.mem_singleton] at hx
      subst hx
      intro h
      have h1 := Nat.le_of_dvd (by have := hr.two_le; simp; omega) h
      simp at h1; omega)
  simpa [reread] using this

/-! ## The SAFE optimum above 1/25 is realisable -/

theorem safe_le_of_mem {C : Config} {y : ℕ}
    (h : y ∈ C.parts.flatMap CPart.safeTerms ++ crossN C.sizes) : C.safe ≤ y := minL_le h

/-- **The SAFE optimum above 1/25 can be taken realisable**: if C attains the SAFE maximum at n
and lies above the line, some realisable configuration at n scores at least as much.  Route: a
D2 part is matched by `d2_case`; Proposition 1 leaves ≤ 1 class and ≤ 2 foreign parts; a class
with a foreign r ∣ c − 1 is a bare safe-prime pair, re-read (E.3(ii), via `e6_of_view`); a foreign
r ∣ F forces n < 73, where `badCheck` supplies a single-class witness; otherwise the twist is
raised to full; and a configuration with no class re-reads its smallest prime as one. -/
theorem e6_real (C : Config) (hC : GAdm C)
    (hopt : ∀ C', GAdm C' → C'.n = C.n → C'.safe ≤ C.safe)
    (hhi : pairs C.n < 25 * C.safe) :
    ∃ C', RealCfg C' ∧ C'.p.Prime ∧ C'.q.Prime ∧ C'.n = C.n ∧ C.safe ≤ C'.safe := by
  -- a D2-free optimum
  obtain ⟨C0, hC0, hn0, hs0, hfo0⟩ : ∃ C0, GAdm C0 ∧ C0.n = C.n ∧ C0.safe = C.safe ∧ C0.FoFree := by
    by_cases hfo : C.FoFree
    · exact ⟨C, hC, rfl, rfl, hfo⟩
    · simp only [Config.FoFree, not_forall, not_not] at hfo
      obtain ⟨F, r, t, hx⟩ := hfo
      obtain ⟨C', h1, h2, -, -, h5, h6⟩ := d2_case C hC hopt hhi hx
      exact ⟨C', h1, h2, h5, h6⟩
  have hhi0 : pairs C0.n < 25 * C0.safe := by rw [hn0, hs0]; exact hhi
  -- Proposition 1
  obtain ⟨C1, hC1, hfo1, hn1, hs1, hpc1, hfr1, -, hF15⟩ := Prop1Final.prop1 C0 hC0 hfo0 hhi0
  -- canonical order: classes, then foreign parts
  obtain ⟨P, Q, hP, hQ, hperm⟩ := split_parts C1.parts hfo1
  set C2 : Config := ⟨C1.p, C1.q,
    P.map (fun x => CPart.pc x.1 x.2.1 x.2.2) ++ Q.map (fun x => CPart.fr x.1 x.2)⟩ with hC2def
  have hfo2 : C2.FoFree := Prop1Final.foFree_perm hfo1 hperm
  have hC2 : GAdm C2 := Prop1Final.gadm_perm hC1 ⟨rfl, rfl⟩ hperm
  have hs2 : C2.safe = C1.safe := (Prop1Final.safe_perm hfo1 hfo2 hperm).symm
  have hn2 : C2.n = C.n := by rw [← Prop1Final.n_perm hperm, hn1, hn0]
  have hle2 : C.safe ≤ C2.safe := by rw [hs2, ← hs0]; exact hs1
  have hopt2 : ∀ C', GAdm C' → C'.n = C2.n → C'.safe ≤ C2.safe := fun C' h1 h2 =>
    le_trans (hopt C' h1 (h2.trans hn2)) hle2
  have hhi2 : pairs C2.n < 25 * C2.safe := by
    rw [hn2]; exact lt_of_lt_of_le hhi (Nat.mul_le_mul_left 25 hle2)
  suffices ∃ C', RealCfg C' ∧ C'.p.Prime ∧ C'.q.Prime ∧ C'.n = C2.n ∧ C2.safe ≤ C'.safe by
    obtain ⟨C', a, b, c, d, e⟩ := this
    exact ⟨C', a, b, c, d.trans hn2, hle2.trans e⟩
  clear_value C2
  have hP1 : P.length ≤ 1 := hP ▸ hpc1
  have hQ2 : Q.length ≤ 2 := hQ ▸ hfr1
  obtain ⟨hp, hq, hadm, hnd⟩ := hC2
  have hfor : C2.foreign = Q.map Prod.fst := by
    rw [hC2def]; simp [Config.foreign, List.filterMap_append, List.filterMap_map]
  have hnd' := hnd
  rw [hfor] at hnd
  have hpartsQ : ∀ x ∈ Q, CPart.fr x.1 x.2 ∈ C2.parts := fun x hx => by
    rw [hC2def]; exact List.mem_append_right _ (List.mem_map.mpr ⟨x, hx, rfl⟩)
  have hQadm : ∀ x ∈ Q, x.1.Prime ∧ x.1 ≠ C2.p ∧ x.2 ∣ x.1 - 1 ∧ ∃ f, x.2 = C2.q ^ f :=
    fun x hx => hadm _ (hpartsQ x hx)
  have hsafe_fr : ∀ x ∈ Q, C2.safe ≤ orb x.1 x.2 false := fun x hx =>
    safe_le_of_mem (List.mem_append_left _ (List.mem_flatMap.mpr ⟨_, hpartsQ x hx,
      by simp [CPart.safeTerms]⟩))
  have hsizes : C2.sizes = P.map (fun x => x.1 * x.2.1) ++ Q.map Prod.fst := by
    rw [hC2def]; simp [Config.sizes, CPart.sizeC, Function.comp_def]
  have hnQ : C2.n = (P.map (fun x => x.1 * x.2.1)).sum + (Q.map Prod.fst).sum := by
    simp only [Config.n, hsizes, List.sum_append]
  rcases P with _ | ⟨⟨F, c, d⟩, _ | ⟨y, P'⟩⟩
  · -- no class: re-read the smallest foreign prime as one
    rcases Q with _ | ⟨⟨r1, t1⟩, _ | ⟨⟨r2, t2⟩, _ | ⟨z, Q'⟩⟩⟩
    · exfalso
      have h0 : C2.safe = 0 := by rw [hC2def]; simp [Config.safe, Config.sizes, crossN, minL]
      have : C2.n = 0 := by simp [hnQ]
      omega
    · obtain ⟨hr, -, -, -⟩ := hQadm (r1, t1) (by simp)
      refine ⟨_, real_mk r1 C2.q 1 1 [] le_rfl le_rfl (by simp) (by simp) (by simp), hr, hq, ?_, ?_⟩
      · rw [hnQ]; simp [Config.n, Config.sizes, CPart.sizeC]
      · refine le_trans (hsafe_fr (r1, t1) (by simp)) (le_trans (orb_le_pairs _ _ _) ?_)
        apply le_minL _ (by simp [CPart.safeTerms, Part.terms])
        intro y hy
        simp [CPart.safeTerms, Part.terms, Config.sizes, CPart.sizeC, crossN] at hy
        simp [hy]
    · obtain ⟨h1, -, h1t, h1f⟩ := hQadm (r1, t1) (by simp)
      obtain ⟨h2, -, h2t, h2f⟩ := hQadm (r2, t2) (by simp)
      have hne : r1 ≠ r2 := by simpa using hnd
      have hcross : C2.safe ≤ r1 * r2 := safe_le_of_mem (List.mem_append_right _ (by
        rw [hsizes]; simp [crossN]))
      have hn2' : C2.n = r1 + r2 := by simp [hnQ]
      have key : ∀ a ta b tb, a.Prime → b.Prime → a < b → tb ∣ b - 1 → (∃ f, tb = C2.q ^ f) →
          C2.safe ≤ orb a ta false → C2.safe ≤ orb b tb false → C2.safe ≤ a * b →
          ∃ C', RealCfg C' ∧ C'.p.Prime ∧ C'.q.Prime ∧ C'.n = a + b ∧ C2.safe ≤ C'.safe := by
        intro a ta b tb ha hb hab hbt hbf hsa hsb hab'
        refine ⟨_, real_mk a C2.q 1 1 [(b, tb)] le_rfl le_rfl (by simp)
          (by simp; exact ⟨hb, hbt, hbf⟩)
          (by simp; intro h; have := Nat.le_of_dvd (by have := ha.two_le; omega) h; omega),
          ha, hq, by simp [Config.n, Config.sizes, CPart.sizeC], ?_⟩
        apply le_minL _ (by simp [CPart.safeTerms, Part.terms])
        intro y hy
        simp [CPart.safeTerms, Part.terms, Config.sizes, CPart.sizeC, crossN] at hy
        rcases hy with rfl | rfl | rfl
        · exact le_trans hsa (orb_le_pairs _ _ _)
        · exact hsb
        · exact hab'
      rcases lt_or_gt_of_ne hne with hlt | hlt
      · obtain ⟨C', a, b, c, d, e⟩ := key r1 t1 r2 t2 h1 h2 hlt h2t h2f
          (hsafe_fr (r1, t1) (by simp)) (hsafe_fr (r2, t2) (by simp)) hcross
        exact ⟨C', a, b, c, d.trans hn2'.symm, e⟩
      · obtain ⟨C', a, b, c, d, e⟩ := key r2 t2 r1 t1 h2 h1 hlt h1t h1f
          (hsafe_fr (r2, t2) (by simp)) (hsafe_fr (r1, t1) (by simp)) (by rw [Nat.mul_comm]; exact hcross)
        exact ⟨C', a, b, c, by rw [d, hn2']; ring, e⟩
    · simp at hQ2
  · have hpcmem : CPart.pc F c d ∈ C2.parts := by rw [hC2def]; simp
    obtain ⟨hF, ⟨b, hb, hcb⟩, -⟩ := hadm _ hpcmem
    by_cases hfb : ∃ x ∈ Q, x.1 ∣ c - 1
    · -- a fallback: a bare safe-prime pair, re-read
      obtain ⟨x, hx, hxc⟩ := hfb
      obtain ⟨rest, hpm⟩ := exists_view C2 hpcmem (hpartsQ x hx)
      obtain ⟨hsv, hnv⟩ := safe_eq_view C2 hfo2 hpm
      obtain ⟨a, hW⟩ := view_admissible C2 ⟨hp, hq, hadm, by rw [hfor]; exact hnd⟩ hfo2 hpm hxc
      obtain ⟨c', r', hc', hr', hcr, hn', hs'⟩ := e6_of_view C2 hopt2 hhi2 _ a hW hsv hnv
      exact ⟨_, real_reread hc' hr' hcr, hr', hr', hn', hs'.ge⟩
    push Not at hfb
    have hsc1 : C2.safe ≤ F * pairs c :=
      safe_le_of_mem (List.mem_append_left _ (List.mem_flatMap.mpr ⟨_, hpcmem,
        by simp [CPart.safeTerms, Part.terms]⟩))
    by_cases hdiv : ∃ x ∈ Q, x.1 ∣ F
    · -- a foreign prime dividing F: n < 73, a single-class witness
      obtain ⟨⟨r, t⟩, hx, hrF⟩ := hdiv
      obtain ⟨hr, -, -, -⟩ := hQadm _ hx
      have hshare := Prop1.part_share C2 (hpartsQ _ hx) hhi2
      simp only [CPart.sizeC] at hshare
      have hlen : 2 ≤ C1.parts.length := by
        rw [hperm.length_eq]
        have := List.length_pos_of_mem hx
        simp; omega
      have hF15' := hF15 F c d (hperm.mem_iff.mpr (by simp)) hlen
      have hrle : r ≤ F := Nat.le_of_dvd (by omega) hrF
      have hc2 : 2 ≤ c := by rw [hcb]; exact le_trans hp.two_le (Nat.le_self_pow (by omega) _)
      have hsc2 : C2.safe ≤ F * c * r := safe_le_of_mem (List.mem_append_right _ (by
        rw [hsizes]; simp only [List.map_cons, List.map_nil, List.cons_append, List.nil_append, crossN,
          List.mem_append, List.mem_map]
        left; exact ⟨r, ⟨(r, t), hx, rfl⟩, rfl⟩))
      have hsc3 : C2.safe ≤ pairs r := le_trans (hsafe_fr _ hx) (orb_le_pairs _ _ _)
      -- the rest of n
      obtain ⟨rest, hnr, hrest, hsc4⟩ : ∃ rest, C2.n = F * c + r + rest ∧ rest ≠ 1 ∧
          C2.safe ≤ (if rest = 0 then pairs r else pairs rest) := by
        rcases Q with _ | ⟨⟨r0, t0⟩, _ | ⟨⟨r1, t1⟩, _ | ⟨z, Q'⟩⟩⟩
        · simp at hx
        · simp only [List.mem_singleton, Prod.mk.injEq] at hx
          obtain ⟨rfl, rfl⟩ := hx
          exact ⟨0, by simp [hnQ], by omega, by simpa using hsc3⟩
        · simp only [List.mem_cons, Prod.mk.injEq, List.not_mem_nil, or_false] at hx
          rcases hx with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩
          · have h1 := (hQadm (r1, t1) (by simp)).1
            have := h1.two_le
            refine ⟨r1, by simp [hnQ]; ring, by omega, ?_⟩
            split_ifs with h0
            · omega
            exact le_trans (hsafe_fr (r1, t1) (by simp)) (orb_le_pairs _ _ _)
          · have h1 := (hQadm (r0, t0) (by simp)).1
            have := h1.two_le
            refine ⟨r0, by simp [hnQ]; ring, by omega, ?_⟩
            split_ifs with h0
            · omega
            exact le_trans (hsafe_fr (r0, t0) (by simp)) (orb_le_pairs _ _ _)
        · simp at hQ2
      have hbnd : C2.safe ≤ badBnd F c r rest := by
        unfold badBnd; simp only [le_min_iff]; exact ⟨hsc3, hsc1, hsc2, hsc4⟩
      have hn73 : C2.n < 73 := by omega
      have hrest' : C2.n - F * c - r = rest := by omega
      have hcF : c ≤ F * c := Nat.le_mul_of_pos_left c (by omega)
      have hr2 := hr.two_le
      have hc37 : c < 37 := by
        have : 2 * c ≤ F * c := Nat.mul_le_mul_right c (by omega)
        omega
      obtain ⟨w, hw, hwn, hwb⟩ := bad_spec (F := F) (r := r) (c := c) (n := C2.n) (by omega)
        (by omega) hc37 hn73
        (by omega) (isPrimeB_of_prime hr) hrF hc2 (by omega) (by omega)
        (by rw [hrest']; exact lt_of_lt_of_le hhi2 (Nat.mul_le_mul_left 25 hbnd))
      rw [hrest'] at hwb
      have hok := badWits_ok
      simp only [List.all_eq_true, Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq] at hok
      obtain ⟨⟨⟨hwp, hwF⟩, hwb'⟩, hwn'⟩ := hok w hw
      exact ⟨_, real_wit _ _ _ hwb' hwF, prime_of_isPrimeB hwp, Nat.prime_two,
        by rw [hwn', hwn], le_trans hbnd hwb⟩
    · -- coherent: raise the twist to full
      push Not at hdiv
      have hcoh : ∀ x ∈ Q, ¬ x.1 ∣ F * (C2.p ^ b - 1) := by
        intro x hx h
        rw [← hcb] at h
        rcases (Nat.Prime.dvd_mul (hQadm x hx).1).mp h with h | h
        · exact hdiv x hx h
        · exact hfb x hx h
      have hfull : C2.full = ⟨C2.p, C2.q, .pc F (C2.p ^ b) (C2.p ^ b - 1) ::
          Q.map (fun x => .fr x.1 x.2)⟩ := by
        rw [hC2def] at hcb ⊢
        simp only [Config.full, List.map_cons, List.map_nil, List.cons_append, List.nil_append,
          List.map_map, CPart.full]
        rw [← hcb]
        congr 2
      refine ⟨_, real_mk C2.p C2.q F b Q hF hb hnd
        (fun x hx => ⟨(hQadm x hx).1, (hQadm x hx).2.2⟩) hcoh, hp, hq, ?_, ?_⟩
      · rw [← hfull, (full_safe_n C2).2]
      · rw [← hfull, (full_safe_n C2).1]
  · simp at hP1

/-! ## Corollary E.6 for μ\*, with Part E proved -/

/-- **μ\*(n) = B_safe(n) = B_refined(n) above the 1/25 line**, given only `HypHuppert`: Part E
(the lower bound) is proved for the realisable optimum `e6_real` supplies, and Part 0 (the upper
bound) is `Part0Mu.muStar_le`. -/
theorem e6_mu (HH : Part0Fr.HypHuppert) (n B : ℕ) (hn : 2 ≤ n) (hB : IsBsafe n B)
    (hhi : pairs n < 25 * B) : IsBrefined n B ∧ muStar n = B := by
  refine ⟨e6_maxima n B hB hhi, le_antisymm (muStar_le HH hn hB) ?_⟩
  obtain ⟨⟨C, hC, hCn, hCs⟩, hmax⟩ := hB
  subst hCn hCs
  obtain ⟨C', hR, hp, hq, hn', hle⟩ := e6_real C hC (fun C' h1 h2 => hmax C' h1 h2) hhi
  have := real_le_mu hp hq hR
  rw [refined_real hR, hn'] at this
  exact hle.trans this

end PartEMu

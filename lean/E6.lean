/-
# `E6.lean` — Corollary E.6 (the collapse above 1/25), on a model of the shape space

Corollary E.6 (`enumeration-proof.md` Part E‴): if B_safe(n) > C(n,2)/25 then
B_refined(n) = μ\*(n) = B_safe(n).  The text's proof: let W attain B_safe(n); if W is
fallback-free its two scores agree; otherwise E.5 makes it a bare safe-prime pair — dominated
by its fallback-free (r, r) re-reading (E.3(ii)) — or one of the twelve exceptions, checked
directly; so the SAFE optimum is realised by a fallback-free configuration, and the sandwich
B_refined ≤ μ\* ≤ B_safe closes.

**The model.**  A `Config` is a characteristic prime p, a top prime q and a list of parts:
p-characteristic classes `pc F c d` (F blocks of size c = p^b, multiplier order d ∣ c − 1,
any divisor), foreign blocks `fr r t` (r prime ≠ p, t a power of q dividing r − 1), and
**Lemma D2 parts** `fo F r t` — F ≥ 2 outside blocks of one prime r, fused or simply
repeated, which D2 treats alike.  Distinct `fr`/`fo` parts carry distinct primes (repeats are
gathered into one `fo`).  This is Theorem 3.1's shape list with F any integer (the
certificates' permissive F_mid·F_top), *including* the D2 shapes the enumerator omits.  A
`fo` part's SAFE terms are D2's two classes: F·C(r,2), and when F < r the same-position class
(C(F,2)·r for r ≠ q, F·r for r = q by D2q; the model takes the larger).  `safe` values a class at the flat F·C(c,2) (Part G.3, as in
`E5Assembly`); `refined` at F·orb(c, d), what Part E's construction realises.  A *fallback
configuration* is, as in E.5, one with a class (F, c) and a foreign prime r ∣ c − 1.

**Proved here.**
* `refined_eq_safe` — on a fallback-free configuration (every twist full) the scores agree.
* `refined_le_safe` — REFINED ≤ SAFE on every configuration.
* `safe_eq_view`, `view_admissible` — a fallback configuration *is* an E.5 `Fallback`, with
  the same SAFE, and `Admissible` (needs SAFE permutation-invariant: `crossTerms_perm`).
* `d2_case` — **D2's domination, proved in the model**: a SAFE optimum above the line that
  contains a D2 part is matched by a fallback-free configuration.  Above the line such a part
  has F, r ≤ 25 and n < 614 (`d2_small`); there a kernel-checked table (`d2check`, `d2wits`:
  256 values of n, one- or two-part witnesses) supplies the match.
* `e6_core` — if C attains the SAFE maximum at n and 25·SAFE(C) > C(n,2), some admissible
  fallback-free configuration at n has REFINED = SAFE = SAFE(C).  Cases: no fallback —
  raise every twist to full (`Config.full`); a bare safe-prime pair — its (r, r) re-reading;
  a bare pair with c = 3^a, a ≥ 2, or a non-bare fallback — forced by `e5_s2a2` /
  `e5_exceptions` into the twelve exceptional n, where a one-class witness beats it,
  contradicting optimality.
* `e6_maxima` — **Corollary E.6 on the maxima**: `IsBsafe n B` and C(n,2) < 25·B give
  `IsBrefined n B`, i.e. B_refined(n) = B_safe(n).
* `e6` — with μ\* abstract: given Part E's lower bound (every REFINED score ≤ μ) and Part
  0's upper bound (μ ≤ B_safe), μ = B_safe as well.
* `isBsafe_primePow`, `isBrefined_primePow` — non-vacuity: at n = p^b, B_safe = B_refined =
  C(n,2).

**Where the two halves are proved.**  `e6`'s `hconstr` (every admissible configuration's REFINED
score is realised) is stronger than any construction gives — fallback configurations, `fo` parts
and a foreign prime dividing F·(c − 1) are not realised at their REFINED score.  What E.6 needs is
one realisable optimum: `PartEMu.e6_real` supplies it (using `d2_case`, which also returns a D2-free
witness, and `e6_of_view`, which returns the bare-pair re-reading), and `PartEMu.e6_mu` proves
μ\*(n) = B_safe(n) above the line given only `HypHuppert`.
-/
import E5Assembly

namespace E6
open ArkCore E5Core E5Assembly

/-! ### Configurations, SAFE and REFINED -/

inductive CPart where
  | pc (F c d : ℕ)
  | fr (r t : ℕ)
  /-- F ≥ 2 outside blocks of one prime r: fused (permuted), or F distinct foreign orbits of
  the same prime — Lemma D2 treats both alike. -/
  | fo (F r t : ℕ)
  deriving DecidableEq

/-- To E5Assembly's `Part` (meaningful on `pc` and `fr`; `fo` is never sent there). -/
def CPart.toPart : CPart → Part
  | .pc F c _ => .pc F c
  | .fr r t => .fr r t
  | .fo _ r t => .fr r t

def CPart.sizeC : CPart → ℕ
  | .pc F c _ => F * c
  | .fr r _ => r
  | .fo F r _ => F * r

/-- Lemma D2's same-position class, when F < r: at most C(F,2)·r pairs (r ≠ q), or F·r
(r = q, Lemma D2q); `max` of the two covers both without knowing which. -/
def d2term (F r : ℕ) : List ℕ := if F < r then [max (pairs F * r) (F * r)] else []

/-- SAFE terms of one part.  For `fo`, Lemma D2's two classes: the within-block class
F·C(r,2), and the same-position class when F < r. -/
def CPart.safeTerms : CPart → List ℕ
  | .pc F c _ => (Part.pc F c).terms
  | .fr r t => [orb r t false]
  | .fo F r _ => F * pairs r :: d2term F r

/-- Between-parts orbitals from the list of part sizes. -/
def crossN : List ℕ → List ℕ
  | [] => []
  | x :: xs => xs.map (fun y => x * y) ++ crossN xs

/-- REFINED terms: as `Part.terms`, but a class's intra term is F·orb(c, d). -/
def CPart.refinedTerms (char2 : Bool) : CPart → List ℕ
  | .pc F c d => F * orb c d char2 ::
      (if 2 ≤ F then [(if F % 2 = 1 then F else F / 2) * c * c] else [])
  | .fr r t => [orb r t false]
  | .fo F r _ => F * pairs r :: d2term F r

structure Config where
  p : ℕ
  q : ℕ
  parts : List CPart

def termsL (l : List Part) : List ℕ := l.flatMap Part.terms ++ crossTerms l

/-- Minimum of a list, seeded with its sum (an upper bound on every element). -/
def minL (l : List ℕ) : ℕ := l.foldr min l.sum

namespace Config

def pl (C : Config) : List Part := C.parts.map CPart.toPart
def sizes (C : Config) : List ℕ := C.parts.map CPart.sizeC
def n (C : Config) : ℕ := C.sizes.sum
def safe (C : Config) : ℕ := minL (C.parts.flatMap CPart.safeTerms ++ crossN C.sizes)
def refined (C : Config) : ℕ :=
  minL (C.parts.flatMap (CPart.refinedTerms (decide (C.p = 2))) ++ crossN C.sizes)
def FallbackFree (C : Config) : Prop := ∀ F c d, CPart.pc F c d ∈ C.parts → d = c - 1
def foreign (C : Config) : List ℕ :=
  C.parts.filterMap fun x => match x with
    | .fr r _ => some r | .fo _ r _ => some r | .pc _ _ _ => none
/-- No D2 part. -/
def FoFree (C : Config) : Prop := ∀ F r t, CPart.fo F r t ∉ C.parts

end Config

def partAdm (C : Config) : CPart → Prop
  | .pc F c d => 1 ≤ F ∧ (∃ b, 1 ≤ b ∧ c = C.p ^ b) ∧ d ∣ c - 1
  | .fr r t => Nat.Prime r ∧ r ≠ C.p ∧ t ∣ r - 1 ∧ ∃ f, t = C.q ^ f
  | .fo F r t => 2 ≤ F ∧ Nat.Prime r ∧ r ≠ C.p ∧ t ∣ r - 1 ∧ ∃ f, t = C.q ^ f

/-- Admissibility of a general configuration. -/
def GAdm (C : Config) : Prop :=
  Nat.Prime C.p ∧ Nat.Prime C.q ∧ (∀ x ∈ C.parts, partAdm C x) ∧ C.foreign.Nodup

/-! ### Permutation invariance and the seed -/

theorem crossTerms_perm {l l' : List Part} (h : l.Perm l') : (crossTerms l).Perm (crossTerms l') := by
  induction h with
  | nil => exact List.Perm.refl _
  | cons x _ ih => exact List.Perm.append (List.Perm.map _ ‹_›) ih
  | swap x y l =>
    simp only [crossTerms, List.map_cons, List.cons_append]
    rw [Nat.mul_comm y.size x.size]
    refine List.Perm.cons _ ?_
    rw [← List.append_assoc, ← List.append_assoc]
    exact List.Perm.append_right _ List.perm_append_comm
  | trans _ _ ih1 ih2 => exact ih1.trans ih2

theorem termsL_perm {l l' : List Part} (h : l.Perm l') : (termsL l).Perm (termsL l') :=
  List.Perm.append (List.Perm.flatMap_right _ h) (crossTerms_perm h)

theorem minL_perm {l l' : List ℕ} (h : l.Perm l') : minL l = minL l' := by
  unfold minL
  rw [h.sum_eq]
  exact h.foldr_eq' (fun _ _ _ _ _ => by omega) _

theorem minL_le {l : List ℕ} {y : ℕ} (h : y ∈ l) : minL l ≤ y := foldr_min_le _ _ _ h

theorem le_foldr_min {m s : ℕ} : ∀ (l : List ℕ), m ≤ s → (∀ y ∈ l, m ≤ y) → m ≤ l.foldr min s
  | [], hs, _ => hs
  | x :: xs, hs, h => by
    simp only [List.foldr_cons]
    exact le_min (h x (by simp)) (le_foldr_min xs hs (fun y hy => h y (by simp [hy])))

theorem le_minL {l : List ℕ} {m : ℕ} (h : ∀ y ∈ l, m ≤ y) (hne : l ≠ []) : m ≤ minL l := by
  obtain ⟨x, xs, rfl⟩ := List.exists_cons_of_ne_nil hne
  apply le_foldr_min _ _ h
  exact le_trans (h x (by simp)) (List.le_sum_of_mem (by simp))

theorem min_foldr (a s : ℕ) : ∀ l : List ℕ, min a (l.foldr min s) = l.foldr min (min a s)
  | [] => rfl
  | x :: xs => by
    simp only [List.foldr_cons]
    rw [← min_foldr a s xs]; omega

theorem foldr_min_seed (s s' : ℕ) : ∀ (l : List ℕ) (y : ℕ), y ∈ l → y ≤ s → y ≤ s' →
    l.foldr min s = l.foldr min s'
  | [], _, h, _, _ => absurd h List.not_mem_nil
  | x :: xs, y, h, hs, hs' => by
    simp only [List.foldr_cons]
    rcases List.mem_cons.mp h with rfl | h
    · rw [min_foldr, min_foldr, Nat.min_eq_left hs, Nat.min_eq_left hs']
    · rw [foldr_min_seed s s' xs y h hs hs']

/-- E5Assembly's `Fallback.safe` is `minL` of its terms. -/
theorem fallback_safe_eq (W : Fallback) : W.safe = minL (termsL W.parts) := by
  unfold Fallback.safe minL
  have hy : W.F * pairs W.c ∈ W.terms :=
    term_of_part W (x := .pc W.F W.c) (by simp [Fallback.parts]) (by simp [Part.terms])
  exact foldr_min_seed _ _ _ _ hy (le_refl _) (List.le_sum_of_mem hy)

theorem crossTerms_eq (l : List Part) : crossTerms l = crossN (l.map Part.size) := by
  induction l with
  | nil => rfl
  | cons x xs ih => simp [crossTerms, crossN, ih, List.map_map, Function.comp_def]

/-- On a configuration with no D2 part, SAFE and n are E5Assembly's, read through `toPart`. -/
theorem safe_pl (C : Config) (h : C.FoFree) :
    C.safe = minL (termsL C.pl) ∧ C.n = (C.pl.map Part.size).sum := by
  have hs : C.sizes = C.pl.map Part.size := by
    unfold Config.sizes Config.pl
    rw [List.map_map]
    apply List.map_congr_left
    intro x hx
    cases x with
    | pc => rfl
    | fr => rfl
    | fo F r t => exact absurd hx (h F r t)
  have ht : C.parts.flatMap CPart.safeTerms = C.pl.flatMap Part.terms := by
    unfold Config.pl
    rw [List.flatMap_map]
    apply List.flatMap_congr
    intro x hx
    cases x with
    | pc => rfl
    | fr => rfl
    | fo F r t => exact absurd hx (h F r t)
  refine ⟨?_, by rw [Config.n, hs]⟩
  unfold Config.safe termsL
  rw [ht, hs, crossTerms_eq]

/-! ### Fallback-free configurations: REFINED = SAFE -/

theorem refinedTerms_eq (b : Bool) (x : CPart)
    (hx : ∀ F c d, x = .pc F c d → d = c - 1) :
    x.refinedTerms b = x.safeTerms := by
  cases x with
  | pc F c d =>
    have := hx F c d rfl; subst this
    simp [CPart.refinedTerms, CPart.safeTerms, Part.terms, orb_full]
  | fr r t => rfl
  | fo F r t => rfl

theorem refined_eq_safe (C : Config) (h : C.FallbackFree) : C.refined = C.safe := by
  unfold Config.refined Config.safe
  congr 2
  apply List.flatMap_congr
  intro x hx
  exact refinedTerms_eq _ x (fun F c d he => h F c d (he ▸ hx))

/-! ### A configuration with a cut twist is an E.5 fallback configuration -/

theorem foreign_perm {l l' : List CPart} (h : l.Perm l') :
    (l.filterMap fun x => match x with
      | .fr r _ => some r | .fo _ r _ => some r | .pc _ _ _ => none).Perm
    (l'.filterMap fun x => match x with
      | .fr r _ => some r | .fo _ r _ => some r | .pc _ _ _ => none) :=
  h.filterMap _

/-- The view: for a class x = pc F c d and a foreign y = fr r t in C, the Fallback with those
two in front and the rest as leftover. -/
def view (F c r t : ℕ) (rest : List CPart) : Fallback := ⟨F, c, r, t, rest.map CPart.toPart⟩

theorem view_parts (F c d r t : ℕ) (rest : List CPart) :
    (view F c r t rest).parts = (CPart.pc F c d :: CPart.fr r t :: rest).map CPart.toPart := rfl

theorem exists_view (C : Config) {F c d r t : ℕ} (hx : CPart.pc F c d ∈ C.parts)
    (hy : CPart.fr r t ∈ C.parts) :
    ∃ rest, C.parts.Perm (CPart.pc F c d :: CPart.fr r t :: rest) := by
  have h1 := List.perm_cons_erase hx
  have hy' : CPart.fr r t ∈ C.parts.erase (CPart.pc F c d) :=
    (List.mem_erase_of_ne (by intro h; cases h)).mpr hy
  have h2 := List.perm_cons_erase hy'
  exact ⟨_, h1.trans (List.Perm.cons _ h2)⟩

theorem safe_eq_view (C : Config) (hfo : C.FoFree) {F c d r t : ℕ} {rest : List CPart}
    (hp : C.parts.Perm (CPart.pc F c d :: CPart.fr r t :: rest)) :
    C.safe = (view F c r t rest).safe ∧ C.n = (view F c r t rest).n := by
  obtain ⟨hs, hn⟩ := safe_pl C hfo
  rw [hs, hn]
  have hpl : C.pl.Perm (view F c r t rest).parts := by
    rw [view_parts F c d]; exact hp.map _
  constructor
  · rw [fallback_safe_eq]; exact minL_perm (termsL_perm hpl)
  · unfold Fallback.n; exact (hpl.map _).sum_eq

theorem view_admissible (C : Config) (hC : GAdm C) (hfo : C.FoFree) {F c d r t : ℕ} {rest : List CPart}
    (hp : C.parts.Perm (CPart.pc F c d :: CPart.fr r t :: rest)) (hrc : r ∣ c - 1) :
    ∃ a, Admissible (view F c r t rest) C.p a C.q := by
  obtain ⟨hpP, hqP, hparts, hnd⟩ := hC
  have hmem : ∀ z, z ∈ CPart.pc F c d :: CPart.fr r t :: rest → partAdm C z :=
    fun z hz => hparts z (hp.symm.mem_iff.mp hz)
  obtain ⟨hF, ⟨a, ha, hca⟩, -⟩ := hmem (.pc F c d) (by simp)
  obtain ⟨hr, hrp, htd, hqf⟩ := hmem (.fr r t) (by simp)
  have hnd' := (foreign_perm hp).nodup_iff.mp hnd
  simp only [List.filterMap_cons] at hnd'
  have hnd2 := List.nodup_cons.mp hnd'
  refine ⟨a, hpP, ha, hca, hF, hr, hrp, hrc, hqP, htd, hqf, ?_, ?_⟩
  · intro x hx
    simp only [view, List.mem_map] at hx
    obtain ⟨z, hz, rfl⟩ := hx
    have hzA := hmem z (by simp [hz])
    cases z with
    | pc F' c' d' =>
      obtain ⟨hF', hb, -⟩ := hzA
      exact ⟨hF', hb⟩
    | fr r' t' =>
      obtain ⟨hr', hr'p, ht', hq'⟩ := hzA
      refine ⟨hr', hr'p, ?_, ht', hq'⟩
      rintro rfl
      apply hnd2.1
      exact List.mem_filterMap.mpr ⟨_, hz, rfl⟩
    | fo F' r' t' => exact absurd (hp.symm.mem_iff.mp (by simp [hz])) (hfo F' r' t')
  · simp only [view, List.filterMap_map]
    convert hnd2.2 using 1
    apply List.filterMap_congr
    intro z _; cases z <;> rfl

/-! ### The twelve exceptional n: a one-class witness beats every fallback -/

/-- One full-twist class: F blocks of size p^b. -/
def wit (p b F : ℕ) : Config := ⟨p, 2, [.pc F (p ^ b) (p ^ b - 1)]⟩

theorem wit_adm {p b F : ℕ} (hp : Nat.Prime p) (hb : 1 ≤ b) (hF : 1 ≤ F) : GAdm (wit p b F) := by
  refine ⟨hp, Nat.prime_two, ?_, by simp [wit, Config.foreign]⟩
  intro x hx
  simp only [wit, List.mem_singleton] at hx
  subst hx
  exact ⟨hF, ⟨b, hb, rfl⟩, dvd_refl _⟩

theorem wit_ff (p b F : ℕ) : (wit p b F).FallbackFree := by
  intro F' c d h
  simp only [wit, List.mem_singleton, CPart.pc.injEq] at h
  omega

/-- Witness data (n, p, b, F) for each exceptional n. -/
def witData : List (ℕ × ℕ × ℕ × ℕ) :=
  [(5, 5, 1, 1), (7, 7, 1, 1), (11, 11, 1, 1), (12, 2, 2, 3), (15, 5, 1, 3), (21, 7, 1, 3),
   (23, 23, 1, 1), (27, 3, 3, 1), (28, 7, 1, 4), (31, 31, 1, 1), (40, 2, 3, 5), (63, 3, 2, 7)]

/-- (c, r, a bound on SAFE of any fallback configuration on that pair). -/
def pairBound : List (ℕ × ℕ × ℕ) :=
  [(3, 2, 2), (4, 3, 6), (8, 7, 21), (16, 5, 20), (27, 13, 52), (32, 31, 155)]

theorem wit_beats : ∀ w ∈ witData, ∀ pb ∈ pairBound,
    pb.1 + pb.2.1 ≤ w.1 → pb.2.2 < (wit w.2.1 w.2.2.1 w.2.2.2).safe := by decide

theorem wit_n : ∀ w ∈ witData, (wit w.2.1 w.2.2.1 w.2.2.2).n = w.1 := by decide

theorem witData_ok : ∀ w ∈ witData, Nat.Prime w.2.1 ∧ 1 ≤ w.2.2.1 ∧ 1 ≤ w.2.2.2 := by
  intro w hw
  simp only [witData, List.mem_cons, List.not_mem_nil, or_false] at hw
  rcases hw with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
    norm_num

theorem table_to_wit : ∀ n ∈ table12, ∃ w ∈ witData, w.1 = n := by decide

/-- SAFE of a fallback on an exception pair is at most the pair's bound: SAFE ≤ orb(r, t) ≤ r·t,
and t is a prime power dividing r − 1. -/
theorem safe_le_pairBound (W : Fallback) (p a q : ℕ) (hW : Admissible W p a q)
    (hpair : (W.c, W.r) ∈ excPairs) : ∃ pb ∈ pairBound, pb.1 = W.c ∧ pb.2.1 = W.r ∧
    W.safe ≤ pb.2.2 := by
  obtain ⟨-, -, -, -, -, -, -, hq, htd, ⟨e, he⟩, -, -⟩ := hW
  have hB := le_trans (safe_le_orb W) (orb_le_mul W.r W.t false)
  have htl : W.t ≤ W.r - 1 ∨ W.r - 1 = 0 := by
    rcases Nat.eq_zero_or_pos (W.r - 1) with h | h
    · right; exact h
    · left; exact Nat.le_of_dvd h htd
  simp only [excPairs, List.mem_cons, Prod.mk.injEq, List.not_mem_nil, or_false] at hpair
  -- t is a prime power dividing r − 1; bound it pair by pair
  have tb : ∀ d, W.r - 1 = d → W.t ∣ d → ∀ (ts : List (ℕ × ℕ)),
      (∀ t, t ∣ d → ∀ q e, Nat.Prime q → t = q ^ e → (t, if t = 1 then 0 else q) ∈ ts) →
      ∃ x ∈ ts, x.1 = W.t := fun d _ hd ts hts =>
    ⟨_, hts W.t hd q e hq he, rfl⟩
  rcases hpair with ⟨hc, hr⟩ | ⟨hc, hr⟩ | ⟨hc, hr⟩ | ⟨hc, hr⟩ | ⟨hc, hr⟩ | ⟨hc, hr⟩ <;>
    rw [hr] at htd hB
  · obtain ⟨x, hx, hxt⟩ := tb 1 (by omega) htd [(1, 0)]
      (twist_mem 1 _ (by decide) (by decide) (by norm_num))
    refine ⟨(3, 2, 2), by simp [pairBound], hc.symm, hr.symm, ?_⟩
    simp at hx; subst hx; simp at hxt; rw [← hxt] at hB; simpa using hB
  · obtain ⟨x, hx, hxt⟩ := tb 2 (by omega) htd [(1, 0), (2, 2)]
      (twist_mem 2 _ (by decide) (by decide) (by norm_num))
    refine ⟨(4, 3, 6), by simp [pairBound], hc.symm, hr.symm, ?_⟩
    simp at hx; rcases hx with rfl | rfl <;> simp at hxt <;> rw [← hxt] at hB <;> simp at hB ⊢ <;> omega
  · obtain ⟨x, hx, hxt⟩ := tb 6 (by omega) htd [(1, 0), (2, 2), (3, 3)]
      (twist_mem 6 _ (by decide) (by decide) (by norm_num))
    refine ⟨(8, 7, 21), by simp [pairBound], hc.symm, hr.symm, ?_⟩
    simp at hx; rcases hx with rfl | rfl | rfl <;> simp at hxt <;> rw [← hxt] at hB <;>
      simp at hB ⊢ <;> omega
  · obtain ⟨x, hx, hxt⟩ := tb 4 (by omega) htd [(1, 0), (2, 2), (4, 2)]
      (twist_mem 4 _ (by decide) (by decide) (by norm_num))
    refine ⟨(16, 5, 20), by simp [pairBound], hc.symm, hr.symm, ?_⟩
    simp at hx; rcases hx with rfl | rfl | rfl <;> simp at hxt <;> rw [← hxt] at hB <;>
      simp at hB ⊢ <;> omega
  · obtain ⟨x, hx, hxt⟩ := tb 12 (by omega) htd [(1, 0), (2, 2), (3, 3), (4, 2)]
      (twist_mem 12 _ (by decide) (by decide) (by norm_num))
    refine ⟨(27, 13, 52), by simp [pairBound], hc.symm, hr.symm, ?_⟩
    simp at hx; rcases hx with rfl | rfl | rfl | rfl <;> simp at hxt <;> rw [← hxt] at hB <;>
      simp at hB ⊢ <;> omega
  · obtain ⟨x, hx, hxt⟩ := tb 30 (by omega) htd [(1, 0), (2, 2), (3, 3), (5, 5)]
      (twist_mem 30 _ (by decide) (by decide) (by norm_num))
    refine ⟨(32, 31, 155), by simp [pairBound], hc.symm, hr.symm, ?_⟩
    simp at hx; rcases hx with rfl | rfl | rfl | rfl <;> simp at hxt <;> rw [← hxt] at hB <;>
      simp at hB ⊢ <;> omega

/-- At an exceptional n, a fallback on an exception pair is beaten by an admissible
fallback-free configuration. -/
theorem exc_beaten (W : Fallback) (p a q : ℕ) (hW : Admissible W p a q)
    (hpair : (W.c, W.r) ∈ excPairs) (hn : W.n ∈ table12) :
    ∃ C', GAdm C' ∧ C'.n = W.n ∧ W.safe < C'.safe := by
  obtain ⟨pb, hpb, hc, hr, hB⟩ := safe_le_pairBound W p a q hW hpair
  obtain ⟨w, hw, hwn⟩ := table_to_wit _ hn
  obtain ⟨hwp, hwb, hwF⟩ := witData_ok w hw
  refine ⟨wit w.2.1 w.2.2.1 w.2.2.2, wit_adm hwp hwb hwF, by rw [wit_n w hw, hwn], ?_⟩
  have hcr : pb.1 + pb.2.1 ≤ w.1 := by
    rw [hc, hr, hwn]; exact n_ge_c_add_r W hW.2.2.2.1
  exact lt_of_le_of_lt hB (wit_beats w hw pb hpb hcr)

/-! ### Corollary E.6 -/

/-- The bare safe-prime pair's (r, r) re-reading: class r at full twist, foreign c with
twist r (top prime q = r).  It is admissible, fallback-free, and scores ≥ C(r,2). -/
def reread (c r : ℕ) : Config := ⟨r, r, [.pc 1 r (r - 1), .fr c r]⟩

theorem reread_adm {c r : ℕ} (hr : Nat.Prime r) (hc : Nat.Prime c) (hcr : c = 2 * r + 1) :
    GAdm (reread c r) := by
  refine ⟨hr, hr, ?_, by simp [reread, Config.foreign]⟩
  intro z hz
  simp only [reread, List.mem_cons, List.not_mem_nil, or_false] at hz
  rcases hz with rfl | rfl
  · exact ⟨le_refl _, ⟨1, le_refl _, (pow_one _).symm⟩, dvd_refl _⟩
  · exact ⟨hc, by simp only [reread]; omega, ⟨2, by omega⟩, 1, by simp [reread]⟩

theorem reread_ff (c r : ℕ) : (reread c r).FallbackFree := by
  intro F' c' d' h
  simp [reread] at h
  omega

theorem reread_n (c r : ℕ) : (reread c r).n = r + c := by
  simp [reread, Config.n, Config.sizes, CPart.sizeC]

theorem reread_safe {c r : ℕ} (hcr : c = 2 * r + 1) : pairs r ≤ (reread c r).safe := by
  have h2r := two_pairs r
  have h2c := two_pairs c
  have hmul : pairs r * 2 ≤ c * r := by
    calc pairs r * 2 = r * (r - 1) := by omega
      _ ≤ r * r := Nat.mul_le_mul_left _ (Nat.sub_le _ _)
      _ ≤ c * r := Nat.mul_le_mul_right _ (by omega)
  have horb : pairs r ≤ orb c r false := by
    unfold orb
    have h1 : pairs r ≤ c * r / 2 := (Nat.le_div_iff_mul_le (by norm_num)).mpr hmul
    have h2 : pairs r ≤ pairs c := pairs_mono (by omega)
    have h3 : c * r / 2 ≤ c * r := Nat.div_le_self _ _
    split <;> omega
  have hrc : pairs r ≤ r * c := by rw [Nat.mul_comm]; omega
  unfold Config.safe
  apply le_minL
  · intro y hy
    simp [reread, Config.sizes, CPart.safeTerms, CPart.sizeC, Part.terms, crossN] at hy
    rcases hy with rfl | rfl | rfl <;> omega
  · simp [reread, CPart.safeTerms, Part.terms]

/-- E.6 once a fallback view W of C is in hand. -/
theorem e6_of_view (C : Config)
    (hopt : ∀ C', GAdm C' → C'.n = C.n → C'.safe ≤ C.safe)
    (hhi : pairs C.n < 25 * C.safe) (W : Fallback) (a : ℕ)
    (hW : Admissible W C.p a C.q) (hs : C.safe = W.safe) (hn : C.n = W.n) :
    ∃ c r, Nat.Prime c ∧ Nat.Prime r ∧ c = 2 * r + 1 ∧ (reread c r).n = C.n ∧
      (reread c r).safe = C.safe := by
  have hhiW : pairs W.n < 25 * W.safe := by rw [← hs, ← hn]; exact hhi
  have hexc : (W.c, W.r) ∈ excPairs → W.n ∈ table12 → False := by
    intro hpair hnt
    obtain ⟨C', hC', hn', hlt⟩ := exc_beaten W C.p a C.q hW hpair hnt
    have := hopt C' hC' (by rw [hn', hn])
    omega
  by_cases hb : W.Bare
  · obtain ⟨hF1, hL, hc⟩ := hb
    have hnE := n_eq W
    rw [hF1, hL] at hnE
    simp only [one_mul, List.map_nil, List.sum_nil, Nat.add_zero] at hnE
    rcases Nat.lt_or_ge a 2 with ha | ha
    · -- the bare safe-prime pair: its (r, r) re-reading
      have ha1 : a = 1 := by have := hW.2.1; omega
      obtain ⟨hpP, -, hcp, -, hr, -, -, -, -, -, -, -⟩ := hW
      subst ha1
      rw [pow_one] at hcp
      have hcP : Nat.Prime W.c := hcp ▸ hpP
      have hC' := reread_adm hr hcP hc
      have hn' : (reread W.c W.r).n = C.n := by rw [reread_n, hn, hnE]; ring
      have hle : C.safe ≤ (reread W.c W.r).safe := by
        rw [hs]; exact le_trans (safe_le_pairs_r W) (reread_safe hc)
      have heq := le_antisymm (hopt _ hC' hn') hle
      exact ⟨W.c, W.r, hcP, hr, hc, hn', heq⟩
    · -- c = 2r + 1 a proper prime power: E.3(i) forces (27, 13), n = 40
      exfalso
      rcases e5_s2a2 W C.p a C.q hW ha hc with h | h
      · omega
      · apply hexc h
        simp only [excPairs, List.mem_cons, Prod.mk.injEq, List.not_mem_nil, or_false] at h
        rw [hnE]
        rcases h with ⟨h1, h2⟩ | ⟨h1, h2⟩ | ⟨h1, h2⟩ | ⟨h1, h2⟩ | ⟨h1, h2⟩ | ⟨h1, h2⟩ <;>
          rw [h1, h2] <;> decide
  · -- a non-bare fallback above the line is one of the twelve exceptions
    exfalso
    have hnt := e5_exceptions W C.p a C.q hW hb (le_of_lt hhiW)
    rcases e5 W C.p a C.q hW hb with h | h
    · omega
    · exact hexc h hnt

/-- Raising every twist to full: no SAFE term changes (SAFE ignores twists), admissibility is
kept, and the result is fallback-free. -/
def CPart.full : CPart → CPart
  | .pc F c _ => .pc F c (c - 1)
  | .fr r t => .fr r t
  | .fo F r t => .fo F r t

def Config.full (C : Config) : Config := ⟨C.p, C.q, C.parts.map CPart.full⟩

theorem full_safe_n (C : Config) : C.full.safe = C.safe ∧ C.full.n = C.n := by
  have hs : C.full.sizes = C.sizes := by
    simp only [Config.full, Config.sizes, List.map_map]
    apply List.map_congr_left
    intro x _; cases x <;> rfl
  have ht : C.full.parts.flatMap CPart.safeTerms = C.parts.flatMap CPart.safeTerms := by
    simp only [Config.full, List.flatMap_map]
    apply List.flatMap_congr
    intro x _; cases x <;> rfl
  exact ⟨by unfold Config.safe; rw [ht, hs], by unfold Config.n; rw [hs]⟩

theorem full_adm (C : Config) (hC : GAdm C) : GAdm C.full := by
  obtain ⟨hp, hq, hparts, hnd⟩ := hC
  refine ⟨hp, hq, ?_, ?_⟩
  · intro x hx
    simp only [Config.full, List.mem_map] at hx
    obtain ⟨z, hz, rfl⟩ := hx
    have := hparts z hz
    cases z with
    | pc F c d => obtain ⟨hF, hb, -⟩ := this; exact ⟨hF, hb, dvd_refl _⟩
    | fr r t => exact this
    | fo F r t => exact this
  · simp only [Config.foreign, Config.full, List.filterMap_map] at hnd ⊢
    convert hnd using 1
    apply List.filterMap_congr
    intro z _; cases z <;> rfl

theorem full_ff (C : Config) : C.full.FallbackFree := by
  intro F c d h
  simp only [Config.full, List.mem_map] at h
  obtain ⟨z, -, hz⟩ := h
  cases z with
  | pc F' c' d' => simp [CPart.full] at hz; omega
  | fr r t => simp [CPart.full] at hz
  | fo F' r t => simp [CPart.full] at hz

/-! ### Lemma D2's parts: fused or repeated outside blocks

A configuration with a `fo` part scores at most Lemma D2's bound — the within-block class
F·C(r,2), the same-position class when F < r, and, if anything else is present, the intra
class of a remaining part, at most C(n − F·r, 2).  Above the 1/25 line this forces
F, r ≤ 25 and n < 614 (`d2_small`), and in that finite region a decided table (`d2check`)
supplies, at every such n, an admissible fallback-free configuration scoring at least the
bound (`d2wits`, at most two parts each).  So a configuration containing a D2 part is never
the sole SAFE optimum above the line: D2's domination, proved for this model rather than
assumed (cf. Corollary D2′, which the text closes below n = 471 by the computed table). -/

theorem intra_le (x : CPart) : ∃ y ∈ x.safeTerms, y ≤ pairs x.sizeC := by
  cases x with
  | pc F c d => exact part_intra_le (.pc F c)
  | fr r t => exact ⟨_, by simp [CPart.safeTerms], orb_le_pairs r t false⟩
  | fo F r t => exact ⟨F * pairs r, by simp [CPart.safeTerms], mul_pairs_le F r⟩

theorem safe_le_term (C : Config) {x : CPart} (hx : x ∈ C.parts) {y : ℕ}
    (hy : y ∈ x.safeTerms) : C.safe ≤ y :=
  minL_le (List.mem_append_left _ (List.mem_flatMap.mpr ⟨x, hx, hy⟩))

def bnd0 (F r : ℕ) : ℕ :=
  if F < r then min (F * pairs r) (max (pairs F * r) (F * r)) else F * pairs r

def bnd (F r n : ℕ) : ℕ := if F * r < n then min (bnd0 F r) (pairs (n - F * r)) else bnd0 F r

theorem bnd_le_bnd0 (F r n : ℕ) : bnd F r n ≤ bnd0 F r := by
  unfold bnd; split <;> omega

theorem bnd0_le (F r : ℕ) : bnd0 F r ≤ F * pairs r := by
  unfold bnd0; split <;> omega

theorem safe_le_bnd (C : Config) {F r t : ℕ} (hx : CPart.fo F r t ∈ C.parts) :
    C.safe ≤ bnd F r C.n ∧ F * r ≤ C.n := by
  have h1 : C.safe ≤ F * pairs r := safe_le_term C hx (by simp [CPart.safeTerms])
  have h0 : C.safe ≤ bnd0 F r := by
    unfold bnd0
    split
    · rename_i h
      exact le_min h1 (safe_le_term C hx (by simp [CPart.safeTerms, d2term, h]))
    · exact h1
  have hperm := List.perm_cons_erase hx
  have hn : C.n = F * r + ((C.parts.erase (.fo F r t)).map CPart.sizeC).sum := by
    unfold Config.n Config.sizes
    rw [(hperm.map CPart.sizeC).sum_eq]
    simp [CPart.sizeC]
  refine ⟨?_, by omega⟩
  unfold bnd
  split
  · rename_i hlt
    refine le_min h0 ?_
    have hne : C.parts.erase (.fo F r t) ≠ [] := by
      intro h; rw [h] at hn; simp at hn; omega
    obtain ⟨y, hy⟩ := List.exists_mem_of_ne_nil _ hne
    obtain ⟨v, hv, hle⟩ := intra_le y
    have hsz : y.sizeC ≤ C.n - F * r := by
      have := List.le_sum_of_mem (List.mem_map_of_mem (f := CPart.sizeC) hy)
      omega
    exact le_trans (safe_le_term C (List.mem_of_mem_erase hy) hv)
      (le_trans hle (pairs_mono hsz))
  · exact h0

/-- Above the line a D2 part is small: F, r ≤ 25 and n < 614. -/
theorem d2_small {F r n b : ℕ} (hF : 2 ≤ F) (hr : 2 ≤ r) (hFr : F * r ≤ n)
    (hb : b ≤ bnd0 F r) (hlt : pairs n < 25 * b) : F < 26 ∧ r < 26 ∧ n < 614 := by
  have hX : pairs (F * r) < 25 * b := lt_of_le_of_lt (pairs_mono hFr) hlt
  have h2X := two_pairs (F * r)
  have h2r := two_pairs r
  have h2F := two_pairs F
  have hX1 : 1 ≤ F * r := by nlinarith
  have hFr' : F < 26 ∧ r < 26 := by
    unfold bnd0 at hb
    split at hb
    · rename_i hlt'
      have hb' : b ≤ max (pairs F * r) (F * r) := le_trans hb (min_le_right _ _)
      rcases le_total (pairs F * r) (F * r) with hm | hm
      · rw [max_eq_right hm] at hb'
        -- X(X − 1) < 50·X, so X ≤ 50
        have : F * r * (F * r - 1) < F * r * 50 := by nlinarith
        have := Nat.lt_of_mul_lt_mul_left this
        have h2 : F * 2 ≤ F * r := Nat.mul_le_mul_left F hr
        have h3 : 2 * r ≤ F * r := Nat.mul_le_mul_right r hF
        omega
      · rw [max_eq_left hm] at hb'
        -- X(X − 1) < 25·F(F − 1)·r = 25·X·(F − 1)
        have hk : F * r * (F * r - 1) < F * r * (25 * (F - 1)) := by
          have : 2 * (pairs F * r) = F * r * (F - 1) := by
            calc 2 * (pairs F * r) = (2 * pairs F) * r := by ring
              _ = F * (F - 1) * r := by rw [h2F]
              _ = F * r * (F - 1) := by ring
          nlinarith
        have := Nat.lt_of_mul_lt_mul_left hk
        have hr25 : r < 25 := by
          by_contra h
          push Not at h
          have : 25 * F ≤ F * r := by nlinarith
          omega
        omega
    · rename_i hge
      push Not at hge
      -- X(X − 1) < 25·F·r(r − 1) = 25·X·(r − 1)
      have hk : F * r * (F * r - 1) < F * r * (25 * (r - 1)) := by
        have : 2 * (F * pairs r) = F * r * (r - 1) := by
          calc 2 * (F * pairs r) = F * (2 * pairs r) := by ring
            _ = F * (r * (r - 1)) := by rw [h2r]
            _ = F * r * (r - 1) := by ring
        nlinarith
      have := Nat.lt_of_mul_lt_mul_left hk
      have hF25 : F < 25 := by
        by_contra h
        push Not at h
        have : 25 * r ≤ F * r := Nat.mul_le_mul_right r h
        omega
      omega
  refine ⟨hFr'.1, hFr'.2, ?_⟩
  by_contra h
  push Not at h
  have h614 : pairs 614 ≤ pairs n := pairs_mono h
  have hpb : b ≤ 25 * pairs 25 := by
    have := bnd0_le F r
    have : pairs r ≤ pairs 25 := pairs_mono (by omega)
    have : F * pairs r ≤ 25 * pairs 25 := Nat.mul_le_mul (by omega) this
    omega
  have : pairs 614 = 188191 := by decide
  have : pairs 25 = 300 := by decide
  omega

def d2wits : List (ℕ × Config) :=
  [(4, ⟨2, 2, [.pc 1 4 3]⟩),
   (6, ⟨3, 2, [.pc 2 3 2]⟩),
   (7, ⟨7, 2, [.pc 1 7 6]⟩),
   (8, ⟨2, 2, [.pc 1 8 7]⟩),
   (9, ⟨3, 2, [.pc 1 9 8]⟩),
   (10, ⟨5, 2, [.pc 2 5 4]⟩),
   (11, ⟨11, 2, [.pc 1 11 10]⟩),
   (12, ⟨2, 2, [.pc 3 4 3]⟩),
   (13, ⟨13, 2, [.pc 1 13 12]⟩),
   (14, ⟨7, 2, [.pc 2 7 6]⟩),
   (15, ⟨5, 2, [.pc 3 5 4]⟩),
   (16, ⟨2, 2, [.pc 1 16 15]⟩),
   (17, ⟨17, 2, [.pc 1 17 16]⟩),
   (18, ⟨3, 2, [.pc 2 9 8]⟩),
   (19, ⟨19, 2, [.pc 1 19 18]⟩),
   (20, ⟨5, 2, [.pc 4 5 4]⟩),
   (21, ⟨7, 2, [.pc 3 7 6]⟩),
   (22, ⟨11, 2, [.pc 2 11 10]⟩),
   (23, ⟨23, 2, [.pc 1 23 22]⟩),
   (24, ⟨2, 2, [.pc 3 8 7]⟩),
   (25, ⟨5, 2, [.pc 1 25 24]⟩),
   (26, ⟨13, 2, [.pc 2 13 12]⟩),
   (27, ⟨3, 2, [.pc 1 27 26]⟩),
   (28, ⟨7, 2, [.pc 4 7 6]⟩),
   (29, ⟨29, 2, [.pc 1 29 28]⟩),
   (30, ⟨5, 2, [.pc 6 5 4]⟩),
   (31, ⟨31, 2, [.pc 1 31 30]⟩),
   (32, ⟨2, 2, [.pc 1 32 31]⟩),
   (33, ⟨11, 2, [.pc 3 11 10]⟩),
   (34, ⟨17, 2, [.pc 2 17 16]⟩),
   (35, ⟨7, 2, [.pc 5 7 6]⟩),
   (36, ⟨3, 2, [.pc 4 9 8]⟩),
   (37, ⟨37, 2, [.pc 1 37 36]⟩),
   (38, ⟨19, 2, [.pc 2 19 18]⟩),
   (39, ⟨13, 2, [.pc 3 13 12]⟩),
   (40, ⟨2, 2, [.pc 5 8 7]⟩),
   (41, ⟨41, 2, [.pc 1 41 40]⟩),
   (42, ⟨7, 2, [.pc 6 7 6]⟩),
   (43, ⟨43, 2, [.pc 1 43 42]⟩),
   (44, ⟨11, 2, [.pc 4 11 10]⟩),
   (45, ⟨3, 2, [.pc 5 9 8]⟩),
   (46, ⟨23, 2, [.pc 2 23 22]⟩),
   (47, ⟨47, 2, [.pc 1 47 46]⟩),
   (48, ⟨2, 2, [.pc 3 16 15]⟩),
   (49, ⟨7, 2, [.pc 1 49 48]⟩),
   (50, ⟨5, 2, [.pc 2 25 24]⟩),
   (51, ⟨17, 2, [.pc 3 17 16]⟩),
   (52, ⟨13, 2, [.pc 4 13 12]⟩),
   (53, ⟨53, 2, [.pc 1 53 52]⟩),
   (54, ⟨3, 2, [.pc 2 27 26]⟩),
   (55, ⟨11, 2, [.pc 5 11 10]⟩),
   (56, ⟨2, 2, [.pc 7 8 7]⟩),
   (57, ⟨19, 2, [.pc 3 19 18]⟩),
   (58, ⟨29, 2, [.pc 2 29 28]⟩),
   (59, ⟨59, 2, [.pc 1 59 58]⟩),
   (60, ⟨5, 2, [.pc 12 5 4]⟩),
   (61, ⟨61, 2, [.pc 1 61 60]⟩),
   (62, ⟨31, 2, [.pc 2 31 30]⟩),
   (63, ⟨3, 2, [.pc 7 9 8]⟩),
   (64, ⟨2, 2, [.pc 1 64 63]⟩),
   (65, ⟨13, 2, [.pc 5 13 12]⟩),
   (66, ⟨11, 2, [.pc 6 11 10]⟩),
   (67, ⟨67, 2, [.pc 1 67 66]⟩),
   (68, ⟨17, 2, [.pc 4 17 16]⟩),
   (69, ⟨23, 2, [.pc 3 23 22]⟩),
   (70, ⟨7, 2, [.pc 10 7 6]⟩),
   (71, ⟨71, 2, [.pc 1 71 70]⟩),
   (72, ⟨3, 2, [.pc 8 9 8]⟩),
   (73, ⟨73, 2, [.pc 1 73 72]⟩),
   (74, ⟨37, 2, [.pc 2 37 36]⟩),
   (75, ⟨5, 2, [.pc 3 25 24]⟩),
   (76, ⟨19, 2, [.pc 4 19 18]⟩),
   (77, ⟨11, 2, [.pc 7 11 10]⟩),
   (78, ⟨13, 2, [.pc 6 13 12]⟩),
   (79, ⟨79, 2, [.pc 1 79 78]⟩),
   (80, ⟨2, 2, [.pc 5 16 15]⟩),
   (81, ⟨3, 2, [.pc 1 81 80]⟩),
   (82, ⟨41, 2, [.pc 2 41 40]⟩),
   (83, ⟨83, 2, [.pc 1 83 82]⟩),
   (84, ⟨7, 2, [.pc 12 7 6]⟩),
   (85, ⟨17, 2, [.pc 5 17 16]⟩),
   (86, ⟨43, 2, [.pc 2 43 42]⟩),
   (87, ⟨29, 2, [.pc 3 29 28]⟩),
   (88, ⟨11, 2, [.pc 8 11 10]⟩),
   (89, ⟨89, 2, [.pc 1 89 88]⟩),
   (90, ⟨3, 2, [.pc 10 9 8]⟩),
   (91, ⟨13, 2, [.pc 7 13 12]⟩),
   (92, ⟨23, 2, [.pc 4 23 22]⟩),
   (93, ⟨31, 2, [.pc 3 31 30]⟩),
   (94, ⟨47, 2, [.pc 2 47 46]⟩),
   (95, ⟨19, 2, [.pc 5 19 18]⟩),
   (96, ⟨2, 2, [.pc 3 32 31]⟩),
   (97, ⟨97, 2, [.pc 1 97 96]⟩),
   (98, ⟨7, 2, [.pc 2 49 48]⟩),
   (99, ⟨11, 2, [.pc 9 11 10]⟩),
   (100, ⟨5, 2, [.pc 4 25 24]⟩),
   (101, ⟨101, 2, [.pc 1 101 100]⟩),
   (102, ⟨17, 2, [.pc 6 17 16]⟩),
   (103, ⟨103, 2, [.pc 1 103 102]⟩),
   (104, ⟨13, 2, [.pc 8 13 12]⟩),
   (105, ⟨7, 2, [.pc 15 7 6]⟩),
   (106, ⟨53, 2, [.pc 2 53 52]⟩),
   (107, ⟨107, 2, [.pc 1 107 106]⟩),
   (108, ⟨3, 2, [.pc 4 27 26]⟩),
   (109, ⟨109, 2, [.pc 1 109 108]⟩),
   (110, ⟨11, 2, [.pc 10 11 10]⟩),
   (111, ⟨37, 2, [.pc 3 37 36]⟩),
   (112, ⟨2, 2, [.pc 7 16 15]⟩),
   (113, ⟨113, 2, [.pc 1 113 112]⟩),
   (114, ⟨19, 2, [.pc 6 19 18]⟩),
   (115, ⟨23, 2, [.pc 5 23 22]⟩),
   (116, ⟨29, 2, [.pc 4 29 28]⟩),
   (117, ⟨13, 2, [.pc 9 13 12]⟩),
   (118, ⟨59, 2, [.pc 2 59 58]⟩),
   (119, ⟨17, 2, [.pc 7 17 16]⟩),
   (120, ⟨2, 2, [.pc 15 8 7]⟩),
   (121, ⟨11, 2, [.pc 1 121 120]⟩),
   (122, ⟨61, 2, [.pc 2 61 60]⟩),
   (123, ⟨41, 2, [.pc 3 41 40]⟩),
   (124, ⟨31, 2, [.pc 4 31 30]⟩),
   (125, ⟨5, 2, [.pc 1 125 124]⟩),
   (126, ⟨3, 2, [.pc 14 9 8]⟩),
   (127, ⟨127, 2, [.pc 1 127 126]⟩),
   (128, ⟨2, 2, [.pc 1 128 127]⟩),
   (129, ⟨43, 2, [.pc 3 43 42]⟩),
   (130, ⟨13, 2, [.pc 10 13 12]⟩),
   (131, ⟨131, 2, [.pc 1 131 130]⟩),
   (132, ⟨11, 2, [.pc 12 11 10]⟩),
   (133, ⟨19, 2, [.pc 7 19 18]⟩),
   (134, ⟨67, 2, [.pc 2 67 66]⟩),
   (135, ⟨3, 2, [.pc 5 27 26]⟩),
   (136, ⟨17, 2, [.pc 8 17 16]⟩),
   (137, ⟨137, 2, [.pc 1 137 136]⟩),
   (138, ⟨23, 2, [.pc 6 23 22]⟩),
   (139, ⟨139, 2, [.pc 1 139 138]⟩),
   (140, ⟨31, 3, [.pc 1 31 30, .fr 109 27]⟩),
   (141, ⟨47, 2, [.pc 3 47 46]⟩),
   (142, ⟨71, 2, [.pc 2 71 70]⟩),
   (143, ⟨13, 2, [.pc 11 13 12]⟩),
   (144, ⟨2, 2, [.pc 9 16 15]⟩),
   (145, ⟨29, 2, [.pc 5 29 28]⟩),
   (146, ⟨73, 2, [.pc 2 73 72]⟩),
   (147, ⟨7, 2, [.pc 3 49 48]⟩),
   (148, ⟨37, 2, [.pc 4 37 36]⟩),
   (149, ⟨149, 2, [.pc 1 149 148]⟩),
   (150, ⟨5, 2, [.pc 6 25 24]⟩),
   (151, ⟨151, 2, [.pc 1 151 150]⟩),
   (152, ⟨19, 2, [.pc 8 19 18]⟩),
   (153, ⟨17, 2, [.pc 9 17 16]⟩),
   (154, ⟨11, 2, [.pc 14 11 10]⟩),
   (155, ⟨31, 2, [.pc 5 31 30]⟩),
   (156, ⟨13, 2, [.pc 12 13 12]⟩),
   (157, ⟨157, 2, [.pc 1 157 156]⟩),
   (158, ⟨79, 2, [.pc 2 79 78]⟩),
   (159, ⟨53, 2, [.pc 3 53 52]⟩),
   (160, ⟨2, 2, [.pc 5 32 31]⟩),
   (161, ⟨23, 2, [.pc 7 23 22]⟩),
   (162, ⟨3, 2, [.pc 2 81 80]⟩),
   (163, ⟨163, 2, [.pc 1 163 162]⟩),
   (164, ⟨41, 2, [.pc 4 41 40]⟩),
   (165, ⟨11, 2, [.pc 15 11 10]⟩),
   (166, ⟨83, 2, [.pc 2 83 82]⟩),
   (167, ⟨167, 2, [.pc 1 167 166]⟩),
   (168, ⟨37, 5, [.pc 1 37 36, .fr 131 5]⟩),
   (169, ⟨13, 2, [.pc 1 169 168]⟩),
   (170, ⟨17, 2, [.pc 10 17 16]⟩),
   (171, ⟨19, 2, [.pc 9 19 18]⟩),
   (172, ⟨43, 2, [.pc 4 43 42]⟩),
   (173, ⟨173, 2, [.pc 1 173 172]⟩),
   (174, ⟨29, 2, [.pc 6 29 28]⟩),
   (175, ⟨5, 2, [.pc 7 25 24]⟩),
   (176, ⟨2, 2, [.pc 11 16 15]⟩),
   (177, ⟨59, 2, [.pc 3 59 58]⟩),
   (178, ⟨89, 2, [.pc 2 89 88]⟩),
   (179, ⟨179, 2, [.pc 1 179 178]⟩),
   (180, ⟨3, 2, [.pc 20 9 8]⟩),
   (181, ⟨181, 2, [.pc 1 181 180]⟩),
   (182, ⟨13, 2, [.pc 14 13 12]⟩),
   (183, ⟨61, 2, [.pc 3 61 60]⟩),
   (184, ⟨23, 2, [.pc 8 23 22]⟩),
   (185, ⟨37, 2, [.pc 5 37 36]⟩),
   (186, ⟨31, 2, [.pc 6 31 30]⟩),
   (187, ⟨17, 2, [.pc 11 17 16]⟩),
   (188, ⟨47, 2, [.pc 4 47 46]⟩),
   (189, ⟨3, 2, [.pc 7 27 26]⟩),
   (190, ⟨19, 2, [.pc 10 19 18]⟩),
   (194, ⟨97, 2, [.pc 2 97 96]⟩),
   (195, ⟨13, 2, [.pc 15 13 12]⟩),
   (196, ⟨7, 2, [.pc 4 49 48]⟩),
   (197, ⟨197, 2, [.pc 1 197 196]⟩),
   (198, ⟨11, 2, [.pc 18 11 10]⟩),
   (199, ⟨199, 2, [.pc 1 199 198]⟩),
   (200, ⟨5, 2, [.pc 8 25 24]⟩),
   (201, ⟨67, 2, [.pc 3 67 66]⟩),
   (202, ⟨101, 2, [.pc 2 101 100]⟩),
   (203, ⟨29, 2, [.pc 7 29 28]⟩),
   (204, ⟨17, 2, [.pc 12 17 16]⟩),
   (205, ⟨41, 2, [.pc 5 41 40]⟩),
   (206, ⟨103, 2, [.pc 2 103 102]⟩),
   (207, ⟨23, 2, [.pc 9 23 22]⟩),
   (208, ⟨2, 2, [.pc 13 16 15]⟩),
   (209, ⟨19, 2, [.pc 11 19 18]⟩),
   (212, ⟨53, 2, [.pc 4 53 52]⟩),
   (213, ⟨71, 2, [.pc 3 71 70]⟩),
   (214, ⟨107, 2, [.pc 2 107 106]⟩),
   (215, ⟨43, 2, [.pc 5 43 42]⟩),
   (216, ⟨3, 2, [.pc 8 27 26]⟩),
   (217, ⟨31, 2, [.pc 7 31 30]⟩),
   (218, ⟨109, 2, [.pc 2 109 108]⟩),
   (219, ⟨73, 2, [.pc 3 73 72]⟩),
   (220, ⟨11, 2, [.pc 20 11 10]⟩),
   (221, ⟨17, 2, [.pc 13 17 16]⟩),
   (222, ⟨37, 2, [.pc 6 37 36]⟩),
   (223, ⟨223, 2, [.pc 1 223 222]⟩),
   (224, ⟨2, 2, [.pc 7 32 31]⟩),
   (225, ⟨5, 2, [.pc 9 25 24]⟩),
   (228, ⟨19, 2, [.pc 12 19 18]⟩),
   (229, ⟨229, 2, [.pc 1 229 228]⟩),
   (230, ⟨23, 2, [.pc 10 23 22]⟩),
   (231, ⟨11, 2, [.pc 21 11 10]⟩),
   (232, ⟨29, 2, [.pc 8 29 28]⟩),
   (233, ⟨233, 2, [.pc 1 233 232]⟩),
   (234, ⟨13, 2, [.pc 18 13 12]⟩),
   (238, ⟨17, 2, [.pc 14 17 16]⟩),
   (242, ⟨11, 2, [.pc 2 121 120]⟩),
   (247, ⟨19, 2, [.pc 13 19 18]⟩),
   (255, ⟨17, 2, [.pc 15 17 16]⟩),
   (260, ⟨13, 2, [.pc 20 13 12]⟩),
   (266, ⟨19, 2, [.pc 14 19 18]⟩),
   (272, ⟨17, 2, [.pc 16 17 16]⟩),
   (273, ⟨13, 2, [.pc 21 13 12]⟩),
   (285, ⟨19, 2, [.pc 15 19 18]⟩),
   (286, ⟨13, 2, [.pc 22 13 12]⟩),
   (289, ⟨17, 2, [.pc 1 289 288]⟩),
   (299, ⟨23, 2, [.pc 13 23 22]⟩),
   (304, ⟨19, 2, [.pc 16 19 18]⟩),
   (306, ⟨17, 2, [.pc 18 17 16]⟩),
   (322, ⟨23, 2, [.pc 14 23 22]⟩),
   (323, ⟨19, 2, [.pc 17 19 18]⟩),
   (340, ⟨17, 2, [.pc 20 17 16]⟩),
   (342, ⟨19, 2, [.pc 18 19 18]⟩),
   (345, ⟨23, 2, [.pc 15 23 22]⟩),
   (357, ⟨17, 2, [.pc 21 17 16]⟩),
   (361, ⟨19, 2, [.pc 1 361 360]⟩),
   (368, ⟨23, 2, [.pc 16 23 22]⟩),
   (374, ⟨17, 2, [.pc 22 17 16]⟩),
   (380, ⟨19, 2, [.pc 20 19 18]⟩),
   (391, ⟨23, 2, [.pc 17 23 22]⟩),
   (399, ⟨19, 2, [.pc 21 19 18]⟩),
   (414, ⟨23, 2, [.pc 18 23 22]⟩),
   (418, ⟨19, 2, [.pc 22 19 18]⟩),
   (437, ⟨23, 2, [.pc 19 23 22]⟩),
   (460, ⟨23, 2, [.pc 20 23 22]⟩),
   (483, ⟨23, 2, [.pc 21 23 22]⟩),
   (506, ⟨23, 2, [.pc 22 23 22]⟩),
   (529, ⟨23, 2, [.pc 1 529 528]⟩)]

/-- Bool admissibility, for decided witness tables. -/
def partAdmB (p q : ℕ) : CPart → Bool
  | .pc F c d => decide (1 ≤ F) && ((List.range (c + 1)).any fun b => decide (1 ≤ b) && decide (c = p ^ b))
      && decide (d ∣ c - 1)
  | .fr r t => E5Assembly.isPrimeB r && decide (r ≠ p) && decide (t ∣ r - 1) &&
      (List.range (r + 1)).any fun f => decide (t = q ^ f)
  | .fo F r t => decide (2 ≤ F) && E5Assembly.isPrimeB r && decide (r ≠ p) && decide (t ∣ r - 1) &&
      (List.range (r + 1)).any fun f => decide (t = q ^ f)

def admB (C : Config) : Bool :=
  E5Assembly.isPrimeB C.p && E5Assembly.isPrimeB C.q && C.parts.all (partAdmB C.p C.q) && decide C.foreign.Nodup

def ffB (C : Config) : Bool :=
  C.parts.all fun x => match x with | .pc _ c d => decide (d = c - 1) | _ => true

theorem prime_of_isPrimeB {n : ℕ} (h : E5Assembly.isPrimeB n = true) : Nat.Prime n := by
  unfold E5Assembly.isPrimeB at h
  simp only [Bool.and_eq_true, decide_eq_true_eq, List.all_eq_true, List.mem_range,
    Bool.or_eq_true, bne_iff_ne, ne_eq] at h
  refine Nat.prime_def_lt.mpr ⟨h.1, fun m hm hdv => ?_⟩
  rcases h.2 m hm with h2 | h2
  · have : m = 0 ∨ m = 1 := by omega
    rcases this with rfl | rfl
    · simp at hdv; omega
    · rfl
  · exact absurd (Nat.mod_eq_zero_of_dvd hdv) h2

theorem gadm_of_admB {C : Config} (h : admB C = true) : GAdm C := by
  unfold admB at h
  simp only [Bool.and_eq_true, List.all_eq_true, decide_eq_true_eq] at h
  obtain ⟨⟨⟨hp, hq⟩, hparts⟩, hnd⟩ := h
  refine ⟨prime_of_isPrimeB hp, prime_of_isPrimeB hq, ?_, hnd⟩
  intro x hx
  have := hparts x hx
  cases x with
  | pc F c d =>
    simp only [partAdmB, Bool.and_eq_true, decide_eq_true_eq, List.any_eq_true,
      List.mem_range] at this
    obtain ⟨⟨hF, b, -, hb1, hcb⟩, hd⟩ := this
    exact ⟨hF, ⟨b, hb1, hcb⟩, hd⟩
  | fr r t =>
    simp only [partAdmB, Bool.and_eq_true, decide_eq_true_eq, List.any_eq_true,
      List.mem_range] at this
    obtain ⟨⟨⟨hr, hrp⟩, ht⟩, f, -, hf⟩ := this
    exact ⟨prime_of_isPrimeB hr, hrp, ht, f, hf⟩
  | fo F r t =>
    simp only [partAdmB, Bool.and_eq_true, decide_eq_true_eq, List.any_eq_true,
      List.mem_range] at this
    obtain ⟨⟨⟨⟨hF, hr⟩, hrp⟩, ht⟩, f, -, hf⟩ := this
    exact ⟨hF, prime_of_isPrimeB hr, hrp, ht, f, hf⟩

theorem ff_of_ffB {C : Config} (h : ffB C = true) : C.FallbackFree := by
  intro F c d hx
  unfold ffB at h
  simp only [List.all_eq_true] at h
  simpa using h _ hx

def foB (C : Config) : Bool :=
  C.parts.all fun x => match x with | .fo _ _ _ => false | _ => true

theorem fo_of_foB {C : Config} (h : foB C = true) : C.FoFree := by
  intro F r t hx
  unfold foB at h
  simp only [List.all_eq_true] at h
  have := h _ hx
  simp at this

set_option maxRecDepth 100000 in
theorem d2wits_ok :
    d2wits.all (fun w => admB w.2 && ffB w.2 && foB w.2 && w.2.n == w.1) = true := by
  decide +kernel

def d2check : Bool :=
  (List.range 26).all fun F => (List.range 26).all fun r =>
    !(decide (2 ≤ F) && E5Assembly.isPrimeB r) || (List.range 614).all fun n =>
      !(decide (F * r ≤ n) && decide (pairs n < 25 * bnd F r n)) ||
        d2wits.any fun w => w.1 == n && decide (bnd F r n ≤ w.2.safe)

set_option maxRecDepth 100000 in
theorem d2check_ok : d2check = true := by decide +kernel

/-- **D2's domination, in the model.**  A SAFE optimum above the line that contains a D2 part
is matched by an admissible fallback-free configuration. -/
theorem d2_case (C : Config) (hC : GAdm C)
    (hopt : ∀ C', GAdm C' → C'.n = C.n → C'.safe ≤ C.safe)
    (hhi : pairs C.n < 25 * C.safe) {F r t : ℕ} (hx : CPart.fo F r t ∈ C.parts) :
    ∃ C', GAdm C' ∧ C'.n = C.n ∧ C'.FallbackFree ∧ C'.refined = C.safe ∧ C'.safe = C.safe ∧
      C'.FoFree := by
  obtain ⟨hb, hFr⟩ := safe_le_bnd C hx
  obtain ⟨hF2, hrP, -, -, -⟩ := hC.2.2.1 _ hx
  have hlt : pairs C.n < 25 * bnd F r C.n := lt_of_lt_of_le hhi (Nat.mul_le_mul_left 25 hb)
  obtain ⟨hF26, hr26, hn614⟩ := d2_small hF2 hrP.two_le hFr (bnd_le_bnd0 F r C.n) hlt
  have hchk := d2check_ok
  unfold d2check at hchk
  simp only [List.all_eq_true, List.mem_range] at hchk
  have h1 := hchk F hF26 r hr26
  simp only [Bool.or_eq_true, Bool.not_eq_true', Bool.and_eq_false_iff, decide_eq_false_iff_not,
    isPrimeB_of_prime hrP] at h1
  rcases h1 with (h | h) | h
  · omega
  · simp at h
  simp only [List.all_eq_true, List.mem_range] at h
  have h2 := h C.n hn614
  simp only [Bool.or_eq_true, Bool.not_eq_true', Bool.and_eq_false_iff, decide_eq_false_iff_not,
    List.any_eq_true, Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq] at h2
  rcases h2 with (h | h) | ⟨w, hw, hwn, hwb⟩
  · omega
  · omega
  have hok := d2wits_ok
  simp only [List.all_eq_true, Bool.and_eq_true, beq_iff_eq] at hok
  obtain ⟨⟨⟨had, hff⟩, hfoB⟩, hn⟩ := hok w hw
  have hC' := gadm_of_admB had
  have hff' := ff_of_ffB hff
  have hn' : w.2.n = C.n := by rw [hn, hwn]
  have heq : w.2.safe = C.safe := le_antisymm (hopt _ hC' hn') (le_trans hb hwb)
  exact ⟨w.2, hC', hn', hff', by rw [refined_eq_safe _ hff', heq], heq, fo_of_foB hfoB⟩

/-- **E.6, combinatorial core.**  If C attains the SAFE maximum at n and lies above the
1/25 line, then an admissible fallback-free configuration at n has REFINED = SAFE = SAFE(C).

A *fallback configuration* is, as in E.5, one with a class (F, c) and a foreign prime
r ∣ c − 1 — whatever its twist.  If C has none, raising its twists to full changes no SAFE
term and makes it fallback-free.  If it has one, C is an E.5 fallback configuration. -/
theorem e6_core (C : Config) (hC : GAdm C)
    (hopt : ∀ C', GAdm C' → C'.n = C.n → C'.safe ≤ C.safe)
    (hhi : pairs C.n < 25 * C.safe) :
    ∃ C', GAdm C' ∧ C'.n = C.n ∧ C'.FallbackFree ∧ C'.refined = C.safe ∧ C'.safe = C.safe := by
  by_cases hfo : C.FoFree
  swap
  · simp only [Config.FoFree, not_forall, not_not] at hfo
    obtain ⟨F, r, t, hx⟩ := hfo
    obtain ⟨C', h1, h2, h3, h4, h5, -⟩ := d2_case C hC hopt hhi hx
    exact ⟨C', h1, h2, h3, h4, h5⟩
  by_cases hfb : ∃ F c d r t, CPart.pc F c d ∈ C.parts ∧ CPart.fr r t ∈ C.parts ∧ r ∣ c - 1
  · obtain ⟨F, c, d, r, t, hx, hy, hrc⟩ := hfb
    obtain ⟨rest, hperm⟩ := exists_view C hx hy
    obtain ⟨hs, hn⟩ := safe_eq_view C hfo hperm
    obtain ⟨a, hW⟩ := view_admissible C hC hfo hperm hrc
    obtain ⟨c, r, hc, hr, hcr, hn', hs'⟩ := e6_of_view C hopt hhi _ a hW hs hn
    exact ⟨_, reread_adm hr hc hcr, hn', reread_ff _ _,
      by rw [refined_eq_safe _ (reread_ff _ _), hs'], hs'⟩
  · obtain ⟨hs, hn⟩ := full_safe_n C
    exact ⟨C.full, full_adm C hC, hn, full_ff C,
      by rw [refined_eq_safe _ (full_ff C), hs], hs⟩

/-! ### B_refined ≤ B_safe, and the corollary on the two maxima -/

theorem foldr_min_mono {s s' : ℕ} (hs : s ≤ s') : ∀ {l l' : List ℕ}, List.Forall₂ (· ≤ ·) l l' →
    l.foldr min s ≤ l'.foldr min s'
  | _, _, .nil => hs
  | _, _, .cons h t => by
    simp only [List.foldr_cons]
    exact min_le_min h (foldr_min_mono hs t)

theorem sum_mono : ∀ {l l' : List ℕ}, List.Forall₂ (· ≤ ·) l l' → l.sum ≤ l'.sum
  | _, _, .nil => le_refl _
  | _, _, .cons h t => by simp only [List.sum_cons]; exact Nat.add_le_add h (sum_mono t)

theorem minL_mono {l l' : List ℕ} (h : List.Forall₂ (· ≤ ·) l l') : minL l ≤ minL l' :=
  foldr_min_mono (sum_mono h) h

theorem forall₂_refl : ∀ l : List ℕ, List.Forall₂ (· ≤ ·) l l
  | [] => .nil
  | _ :: xs => .cons (le_refl _) (forall₂_refl xs)

theorem refinedTerms_le (b : Bool) (x : CPart) :
    List.Forall₂ (· ≤ ·) (x.refinedTerms b) x.safeTerms := by
  cases x with
  | pc F c d =>
    simp only [CPart.refinedTerms, CPart.safeTerms, Part.terms]
    refine List.Forall₂.cons (Nat.mul_le_mul_left F (orb_le_pairs c d b)) ?_
    split
    · exact List.Forall₂.cons (le_refl _) List.Forall₂.nil
    · exact List.Forall₂.nil
  | fr r t => exact List.Forall₂.cons (le_refl _) List.Forall₂.nil
  | fo F r t => exact forall₂_refl _

theorem forall₂_append {a b c d : List ℕ} (h1 : List.Forall₂ (· ≤ ·) a b)
    (h2 : List.Forall₂ (· ≤ ·) c d) : List.Forall₂ (· ≤ ·) (a ++ c) (b ++ d) := by
  induction h1 with
  | nil => exact h2
  | cons h _ ih => exact .cons h ih

/-- **B_refined ≤ B_safe, configuration by configuration** — "by design" in the text,
since orb(c, d) ≤ C(c, 2). -/
theorem refined_le_safe (C : Config) : C.refined ≤ C.safe := by
  unfold Config.refined Config.safe
  apply minL_mono
  apply forall₂_append _ (forall₂_refl _)
  induction C.parts with
  | nil => exact .nil
  | cons x xs ih =>
    simp only [List.flatMap_cons]
    exact forall₂_append (refinedTerms_le _ x) ih

/-- B is the SAFE maximum at n (B_safe(n) = B). -/
def IsBsafe (n B : ℕ) : Prop :=
  (∃ C, GAdm C ∧ C.n = n ∧ C.safe = B) ∧ ∀ C, GAdm C → C.n = n → C.safe ≤ B

/-- B is the REFINED maximum at n (B_refined(n) = B). -/
def IsBrefined (n B : ℕ) : Prop :=
  (∃ C, GAdm C ∧ C.n = n ∧ C.refined = B) ∧ ∀ C, GAdm C → C.n = n → C.refined ≤ B

/-- **Corollary E.6, the two maxima.**  If B_safe(n) > C(n,2)/25 then B_refined(n) = B_safe(n). -/
theorem e6_maxima (n B : ℕ) (hB : IsBsafe n B) (hhi : pairs n < 25 * B) : IsBrefined n B := by
  obtain ⟨⟨C, hC, hn, hs⟩, hmax⟩ := hB
  subst hn hs
  obtain ⟨C', hC', hn', -, href, -⟩ :=
    e6_core C hC (fun C' h1 h2 => hmax C' h1 h2) hhi
  exact ⟨⟨C', hC', hn', href⟩, fun D hD hDn => le_trans (refined_le_safe D) (hmax D hD hDn)⟩

/-- **Corollary E.6, with μ\*.**  μ abstract: Part E constructs, for every admissible
configuration, a group realising its REFINED score (`hconstr`, μ ≥ every REFINED score), and
Part 0's completeness with the flat cap gives μ ≤ B_safe (`hcap`).  Above the 1/25 line,
B_refined = μ = B_safe. -/
theorem e6 (n B μ : ℕ) (hB : IsBsafe n B) (hhi : pairs n < 25 * B)
    (hconstr : ∀ C, GAdm C → C.n = n → C.refined ≤ μ) (hcap : μ ≤ B) :
    IsBrefined n B ∧ μ = B := by
  have hR := e6_maxima n B hB hhi
  refine ⟨hR, ?_⟩
  obtain ⟨⟨C, hC, hn, href⟩, -⟩ := hR
  have := hconstr C hC hn
  omega

/-! ### Non-vacuity: B_safe at a prime power -/

theorem safe_le_pairs_n (C : Config) (h : C.parts ≠ []) : C.safe ≤ pairs C.n := by
  obtain ⟨x, hx⟩ := List.exists_mem_of_ne_nil _ h
  obtain ⟨y, hy, hle⟩ := intra_le x
  have hsz : x.sizeC ≤ C.n := List.le_sum_of_mem (List.mem_map_of_mem hx)
  exact le_trans (safe_le_term C hx hy) (le_trans hle (pairs_mono hsz))

/-- At n = p^b the SAFE maximum is C(n, 2), attained by the transitive configuration.  So
`IsBsafe` is inhabited, and E.6 applies: B_refined(p^b) = C(p^b, 2) too. -/
theorem isBsafe_primePow {p b : ℕ} (hp : Nat.Prime p) (hb : 1 ≤ b) :
    IsBsafe (p ^ b) (pairs (p ^ b)) := by
  refine ⟨⟨wit p b 1, wit_adm hp hb (le_refl _), ?_, ?_⟩, ?_⟩
  · simp [wit, Config.n, Config.sizes, CPart.sizeC]
  · simp [wit, Config.safe, CPart.safeTerms, Part.terms, Config.sizes, CPart.sizeC, crossN, minL]
  · intro C _ hn
    by_cases h : C.parts = []
    · have : C.n = 0 := by simp [Config.n, Config.sizes, h]
      have : 2 ≤ p ^ b := le_trans hp.two_le (Nat.le_self_pow (by omega) p)
      omega
    · exact hn ▸ safe_le_pairs_n C h

theorem isBrefined_primePow {p b : ℕ} (hp : Nat.Prime p) (hb : 1 ≤ b) :
    IsBrefined (p ^ b) (pairs (p ^ b)) := by
  apply e6_maxima _ _ (isBsafe_primePow hp hb)
  have h2 : 2 ≤ p ^ b := le_trans hp.two_le (Nat.le_self_pow (by omega) p)
  have : 1 ≤ pairs (p ^ b) := by
    have := pairs_mono h2; simp [pairs] at this ⊢; omega
  omega

end E6

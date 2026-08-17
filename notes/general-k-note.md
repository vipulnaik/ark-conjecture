# The general k-uniform case: the stabiliser decomposition is complete at k = 3

*Companion to `three-uniform-note.md`, which does k = 3 in detail. This one asks what changes at k ≥ 4, and the headline is that **nothing new appears**. The k = 2 → 3 step switched on a genuinely new mechanism (the Galois part); the 3 → k step switches on none, widens the range of two existing ones, and kills one escape outright. Nothing here is load-bearing for k = 2.*

**Status, section by section.**

| section | standing |
|---|---|
| §1 the completeness theorem | **proved**, and it is the section that answers the question |
| §2 the three factors at general k | τ and θ **derived**; γ's criterion is the k = 3 argument re-run, **proved** for the escape clauses, with one clause conjectural |
| §3 the escape ledger | **derived** from §§1–2 plus Livingstone–Wagner |
| §4 the ceiling table is k-independent | **proved** for k ≥ 3, in the generic column |
| §5 what degrades with k | derived |
| §6 open | a to-do list |

---

## 1. Why there is nothing new to find: the stabiliser decomposition is complete

The whole k-specific content of the framework sits in one function — the minimum orbit of a block group on k-subsets of a block. Everything else (Parts A–G of `enumeration-proof.md`, the shape space, the allocation, the supply questions) is k-agnostic, as `three-uniform-note.md` §1 establishes and as nothing below disturbs.

So the question "are there new escapes at higher k" is the question "are there new sources of orbit-stabiliser at higher k". And that question has a clean negative answer, for a structural reason rather than a computational one.

> **Proposition 1 (completeness of the decomposition).** Let a block of size c = p^a carry the group Γ(d, m) = 𝔽_c ⋊ (C_d ⋊ C_m) with d | c − 1 and m | a. For every k ≥ 2, the setwise stabiliser in Γ(d, m) of a k-subset S decomposes as a product of contributions from the three layers of Γ(d, m), and there is no fourth source. Hence
>
> **orb_k(c, d, m) = min( c·d·m / κ_k , C(c,k) )**,  **κ_k = τ_k · θ_k · γ_k**,
>
> with τ_k, θ_k, γ_k the translation, twist and Galois factors of §2.

*Proof sketch.* Lemma B of `enumeration-proof.md` forces a block's group into AΓL(1, c) = 𝔽_c ⋊ (𝔽_c^× ⋊ Gal), and this is a chain of subgroups each normal in the next with the displayed quotients. A stabiliser of S therefore has a filtration by its intersections with the three layers, and the stabiliser order is the product of the three layer contributions. **k enters only through which subsets of a given layer can fix a k-set**, never through the layer structure itself, because the layers are a property of the group and not of the arity. ∎

**That is the answer to the question this document was written to ask.** The k = 2 → 3 step was not the discovery of a new mechanism but the *switching on* of two factors that were inert at k = 2: τ became nontrivial in characteristic 3, and γ became nontrivial in characteristic 2. Both were already present in the decomposition. Beyond k = 3 the same three factors take a wider range of values, and no fourth term can appear, because AΓL(1, c) has exactly three layers.

> **The corollary worth stating for anyone extending the programme.** A k = 4 or general-k enumerator does not need a new census, a new escape analysis or a new shape space. It needs the same enumerator with `orb` replaced by `orb_k`, and the entire k-dependence of the project is the three formulas of §2. That is a much smaller surface than the k = 2 → 3 step, which needed a new argument for γ.

---

## 2. The three factors at general k

### 2.1 τ: the translation factor, and the unification it produces

A k-set is fixed by a nontrivial translation exactly when it is a union of cosets of a nontrivial additive subgroup H ≤ 𝔽_c. Then |H| divides k and |H| = p^b for some b ≥ 1, so:

> **τ_k = p^{min(v_p(k), a)}** — the p-part of k, capped by the block's own exponent.

**This unifies two things the k = 2 and k = 3 documents state separately.** At k = 2 with p = 2 it gives τ = 2, which is exactly `orb`'s `char2` flag — the translation x ↦ x + 1 swapping a pair. At k = 3 with p = 3 it gives τ = 3, which is §2.2.1's affine-line failure, where the law "overstates by exactly the factor the additive lines cost". They are the same phenomenon with the same formula, and neither document could see that because each has only one instance of it.

Two consequences at higher k. The factor is no longer bounded by p: at **k = 4, p = 2** it is 4, so characteristic-2 blocks lose a factor of four, twice the k = 2 penalty. And the *set of afflicted characteristics grows*: at arity k the primes that can bite are the p ≤ k, so the poison spreads as k grows, exactly as `three-uniform-note.md` §2.2.1 predicts in its aside.

### 2.2 θ: the twist factor

The stabiliser of S inside C_d acts on S with all orbits of equal size, so its order divides k and divides d:

> **θ_k = max{ j ≤ k : j | d }**.

For a **foreign** block the twist t is a q-power (Lemma B′, which is k-independent), so the divisors available are the powers of q, and

> **θ_k(foreign) = the largest power of q that is ≤ k**.

That is a small, explicitly computable table. At k = 2: 2 if q = 2, else 1. At k = 3: 3 if q = 3, 2 if q = 2, else 1 — matching `three-uniform-note.md`'s κ exactly. At k = 4: 4 if q = 2, 3 if q = 3, else 1. So the twist factor is bounded by k and is **1 for all q > k** — meaning that for the large top primes the framework's best configurations actually use, θ is trivial at every arity.

### 2.3 γ: the Galois factor, and why its range widens without changing in kind

The k = 3 argument runs verbatim. A minimal Γ(d, 1)-orbit is stable under all of C_m exactly when some k-subset of the fixed field is available, and the fixed field of the full Galois group C_a is 𝔽_p. So:

> **γ_k = m always, except when no k-subset of 𝔽_c is Galois-stable — which requires p < k.**

Because 𝔽_p supplies a k-subset exactly when p ≥ k, and that is the whole content of `three-uniform-note.md`'s "the Galois part can help only when p < k". The escape clauses generalise the same way: a proper Galois subgroup C_m with m < a has fixed field 𝔽_{p^{a/m}}, which supplies a k-set as soon as p^{a/m} ≥ k, so **the gain still requires m = a**; and a twist divisible by some j ≤ k still supplies a stable set, so the gain still requires **gcd(d, L_k) = 1** where L_k = lcm(1, …, k). Likewise the subfield clauses require **gcd(a, L_k) = 1**.

> **Criterion (general k).** The Galois part raises the minimum only if **p < k**, **m = a**, **gcd(d, L_k) = 1** and **gcd(a, L_k) = 1**; the gain is then the least prime divisor of a. At k = 3, L_3 = 6 and p < 3 means p = 2, which recovers `three-uniform-note.md` §2.2.2 exactly.

**So the escape widens but does not change.** At k = 3 only characteristic 2 can gain; at k = 4 and 5, characteristics 2 and 3; at general k, every p < k. But it is the same escape, with the same coupling (§3), the same cost (the top prime is pinned to a divisor of a, and every foreign block then needs q | r − 1), and the same Oliver-constrained layer split. **A programme at k = 4 inherits `k3_galois.py` with L_3 replaced by L_4 and nothing else.**

> **One thing genuinely does get worse, and it is a supply effect rather than a new mechanism.** The conditions gcd(d, L_k) = gcd(a, L_k) = 1 are congruence conditions modulo L_k = lcm(1..k), which grows like e^{k(1+o(1))}. So the *density* of blocks on which the Galois escape is available falls superexponentially in k, by Mertens. The escape survives at every k and reaches ever fewer blocks.

---

## 3. The escape ledger across k, and what the question was really asking

| escape | k = 2 | k = 3 | k ≥ 4 | new at higher k? |
|---|---|---|---|---|
| **shifted-prime / safe-prime** (the foreign block's twist) | yes | yes | yes | no — it is Lemma B′, which is k-independent |
| **Fermat / S5** (top-layer fusion, q = 2 forced) | yes | yes, larger prize | yes | no — and at every arity it is weakly dominated by cyclic-layer fusion at odd q, which keeps the full twist (`aod` §3.2.3) |
| **Galois** (semilinear twist) | **inert** (p ≥ k always) | new: p = 2 only | p < k, so more characteristics | **no — widened, not new** |
| **full density** (a block that is k-homogeneous) | **infinite family**: every prime power | **finite**: degrees 3, 4, 5, 8, 32 | **empty for k ≥ 5** | no — it *dies* |

**So the prediction that motivated this document is right, with one refinement worth having.** There is no new escape after k = 3, and the reason is Proposition 1: the Galois part was the last unused layer of AΓL(1, c), so once it is switched on there is nothing left to switch on. The refinement is that the traffic is not all one way — **the full-density escape disappears entirely at k ≥ 5**, by Livingstone–Wagner (for 5 ≤ k ≤ n/2 a k-homogeneous group is k-transitive, and solvable k-transitive groups have degree ≤ 4). At k = 4 it is already down to degenerate degrees. So:

> **Going from k = 2 to k = 3 trades an infinite escape family for a new finite mechanism. Going from k = 3 upward loses the rest of the first and keeps the second.** By k = 5 the only escapes left are the two that were already there at k = 2 — the shifted-prime and Fermat routes — and those are the ones that come from Lemma B′ and the layer structure rather than from the arity.

---

## 4. The ceiling table does not depend on k

This is the other reason there is little new to find, and it is a positive result rather than an absence.

By the degree count of `three-uniform-note.md` §4.1 — an intra term is F·orb_k ≈ s·c·m/κ_k, **quadratic** in n, while any cross term is a product of at least two part sizes, hence at least **cubic** — only intra terms bind at every k ≥ 3, and the margin widens with k. So the objective is the allocation problem alone, and by §5.2 there,

> **β_k := m\*_k / n² = 1 / (Σᵢ 1/√eᵢ)²**,  eᵢ = the part's value per unit size squared.

With a matching part of efficiency 1/(F·κ_c) and a foreign part of efficiency η_k/κ_r where η_k = t/(r − 1) = η/2 on the k = 2 convention:

> **β_k = 1 / (√(F·κ_c) + √(κ_r/η_k))²**,

which is the k = 3 formula with no k in it. **The arity enters only through κ_c and κ_r**, and in the generic column — matching twist not divisible by any j with 2 < j ≤ k, foreign twist coprime to L_k, so κ_c = 2 and κ_r = 1 —

> **β_k = cap_F(η)/2 for every k ≥ 3**, exactly, by the one-line identity 1/(√(2F) + √(2/η))² = ½·η/(1 + √(Fη))².

So the six mod-12 ceilings, the balance points and the F = 4 residue are **the same at every arity**, and the F = 4 shape sets the ceiling at n ≡ 11 (mod 12) for all k ≥ 3 by the same argument `three-uniform-note.md` §5.7 gives at k = 3 (the parity constraint, the mod-8 supply mechanism and the η values are all arity-free).

> **What does move with k is which blocks are in the generic column.** κ_c = 2 needs c − 1 coprime to lcm(3, …, k), and κ_r = 1 needs the foreign twist's prime q > k. Both are congruence conditions modulo L_k, so the good class of **blocks** is defined mod L_k rather than mod 4 (k = 2) or mod 12 (k = 3), and the **governing modulus for membership of the generic column grows like e^k**. The table's *values* are k-independent, and so is the modulus keying the table itself — mod 12 at every arity (`aod` §3.3.4); what thins is the *set of blocks*, and hence of n, realising the generic column.

---

## 5. What actually degrades, and what the k-uniform statement is worth

Three quantities move with k, none of them a new mechanism.

**The density.** orb_k ≤ c(c−1)a/κ_k = O(c² log c) against C(c,k) ~ c^k/k!, so δ_k = O(log c / c^{k−2}) → 0 for every k ≥ 3, and faster as k grows. The right invariant is β_k, as at k = 3.

**The threshold, relative to the ambient.** m\*_k = Θ(n²) at every k — the numerator of the orbit bound never grows with k, because it is |Γ| for a block group inside AΓL(1, c), of order at most c² log c. So the statement

> *any nontrivial monotone k-uniform property all of whose members have fewer than m\*_k(n) = Ω(n²) edges is fully evasive*

holds at every k with the **same** order, while C(n,k) grows like n^k. As a fraction of the ambient the result decays like n^{2−k}. It is still the same service BBKN's Ω(n log n) performs at k = 2 — ruling out every sparse property — but "sparse" means an ever smaller share of the ambient as k grows.

**The penalties.** κ_k ≤ τ·θ·γ with each factor at most k, so a block can lose up to a bounded factor to stabilisers; and the afflicted set of characteristics (p ≤ k for τ, p < k for γ, q ≤ k for θ) grows.

> **What does not degrade is the arithmetic.** The shifted-prime condition is Lemma B′'s and is k-independent; the Bateman–Horn systems are unchanged; the θ = 1 endpoint is still what Ω(n²) needs at general n. So `aod` §§3.5–3.6 transfer to every arity verbatim, which is the sharpest form of `three-uniform-note.md` §9 item 4: the arithmetic difficulty is not the price of chasing constant density, and raising k does not buy relief from it at any arity.

---

## 6. Open

1. **The γ criterion at k ≥ 4 has not been verified computationally.** The k = 3 version was checked at 104 (c, d, m) triples; the general statement above is the same argument with L_3 → L_k and is proved for the escape clauses, but the necessity direction at k ≥ 4 needs the analogue of §2.2.2's freeness argument, where the counting "h|_S has order dividing both a and k!" is more delicate than at k = 3 because more orbit-size patterns are available inside a k-set. **First distinguishing case to compute: k = 4, c = 32, d = 31, m = 5**, which is within reach (C(32,4) = 35,960).
2. **Confirm τ_k on a case with v_p(k) ≥ 2.** The formula predicts a factor of 4 at k = 4, p = 2, which no computation in either document exercises. c = 16 or 32 at k = 4 settles it cheaply.
3. **The k = 4 full-density question.** §3 asserts the escape is degenerate at k = 4 from the classification; the solvable 4-homogeneous groups of degree ≥ 6 should be read off Kantor directly rather than inferred, since Livingstone–Wagner's clean statement starts at k = 5.
4. **Whether any of this is worth writing up separately.** On the evidence here the honest answer is probably not: the content is "the k = 3 note, with three formulas generalised and one escape deleted", and it may belong as a closing section of `three-uniform-note.md` rather than as a document. The one result that stands on its own is **Proposition 1**, which is what makes the whole question answerable in closed form.

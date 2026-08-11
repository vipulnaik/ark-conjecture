# The 3-uniform case: what transfers, what inverts, and what k = 2 was relying on

*This is row 3 of the hypothesis table in `orbital-evasiveness-notes.md` §1: the arity axis, which removes the full-density block, as against the group axis of `solvable-relaxation.md`, which removes the shifted-prime condition.*

*Companion to `enumeration-proof.md` and `arithmetic-of-density.md`. Works the Oliver-group machinery at k = 3 — properties of 3-uniform hypergraphs on n vertices — both for its own sake and as a fresh-eyes pass over the k = 2 programme in a setting where the answers are not already known. Nothing here is load-bearing for k = 2; where it contradicts a k = 2 document, the k = 2 document is right about k = 2 and this one is describing a different problem.*

**Status, section by section, since it varies sharply.**

| section | standing |
|---|---|
| §1 what transfers | a reading of the k = 2 proofs |
| §2.1 the orbit law | **proved** modulo one routine step; verified exhaustively over 32 (c, d) pairs |
| §2.2.1 the 3 \| c failure | measured, with the mechanism identified |
| §2.2.2 the semilinear criterion | **proved**, necessity included; two clauses out of computational reach. The Oliver-constrained corollary rests on a layer split, whose branches are enumerated |
| §2.2.3 the Mersenne family | **proved**, and verified at both computable cases |
| §3.1 full density at k = 3 | **classified** — Kantor 1972; the list is c ∈ {5, 8, 32} and is complete |
| §3.2–3.3 why density → 0 | **proved**, from an order bound plus that classification |
| §4 the shape ranking | **measured only, no systematic search** — the least reliable section |
| §5 the additive engine | the allocation formula is **derived**; the ceiling is a bound, and the table is a search |
| §5.6 the mod-12/24 law | **derived**, and verified at every odd prime power c ≤ 83 |
| §5.7 the ceiling table | **derived** from §5.2 with η imported from `aod`; three rows provisional |
| §6.2 the n = 133 example | measured; the comparison is a **search over a hand-specified family**, not an enumeration |
| §5.8 the k = 3 sandwich | a reading of what would be required; no k = 3 certificate exists |
| §6 the escapes | the mechanisms are derived; the **counts are order-of-magnitude**, not proved |
| §7 what it buys | the Ω(n²) threshold follows from §2.1; **the constant and the arithmetic requirement are open** |
| §8 adapting the proofs | a reading, not a rewrite |
| §9 what it says about k = 2 | commentary |
| §10 open items | a to-do list, not results |

Treat this as a design document. Where a claim is measured rather than proved, it is measured over n ≤ 52 and small blocks, which at k = 3 is a very short range.

---

## 1. What transfers verbatim

**The criterion.** Nothing in Oliver's theorem or in the χ argument is 2-specific. For Γ an Oliver chain group acting on [n] and P a nontrivial monotone Γ-invariant property of 3-uniform hypergraphs, non-evasiveness still forces χ((P)_Γ) ≡ 1 (mod q), with χ = 1 exactly when the top layer is trivial. The fixed complex is indexed by unions of **Γ-orbits on 3-subsets** rather than on pairs, so the computation is still 2^t over t orbits and `chi_test.py` needs one line changed.

**The group theory.** Parts A, B, B′, C, D and D2 of `enumeration-proof.md` are statements about *which groups exist* and about their block structure. None mentions pairs. They transfer unchanged, and so does the shape space: chain primes (p, q), orbits, matching and foreign blocks, fusion counts F = F_mid·F_top, the cyclic-layer coprimality budget.

**The sandwich.** B_refined ≤ μ₃ ≤ B_safe has the same shape, with the same reasons, once the scoring function is replaced.

**And the optimisation transfers too, which is less obvious.** Replacing the scoring function changes which term binds, and one might expect the balance-point analysis of `aod` §3.3 to go with it. It does not: the allocation of n among the parts is the same quadratic optimisation, with the same closed form and — in the generic case — the *same balance points row for row* (§5.2, §5.7). What is k-specific is the map from a part's arithmetic to its efficiency, not what is then done with the efficiencies.

**So the whole apparatus up to and including the optimisation is k-agnostic.** That is worth knowing in itself: it locates everything k-specific in one place, the orbit function.

## 2. The orbit law at k = 3

Everything k-specific lives in the analogue of `orb(c, d)` — the minimum size of a Γ-orbit on 3-subsets inside a single block of size c carrying a twist of order d. Blocks come in two kinds and they behave differently enough to take separately: **prime blocks**, where a clean law holds, and **prime-power blocks**, where it can fail and where the extra question of semilinearity arises at all.

### 2.1 Prime blocks: the law

> **Orbit law (k = 3, c prime, c > 3).** For a block of prime size c with cyclic twist of order d | c − 1, acting as x ↦ ζx on 𝔽_c together with translations,
>
> **orb₃(c, d, 1) = min( c·d / κ , C(c,3) )**, where **κ = 3 if 3 | d, else 2 if 2 | d, else 1.**

*Why.* The translations act on 3-subsets with trivial setwise stabiliser — a nonzero translation fixing a 3-set would make it a union of cosets of a nontrivial additive subgroup, and 𝔽_c has none — contributing a factor c. The stabiliser of a 3-set inside the twist ⟨ζ⟩ is cyclic of order m acting on the 3-set with all orbits of equal size, so m | 3 and m | d; the largest available is the largest m ≤ 3 dividing d. Orbit size is c·d/m, minimised by taking m as large as possible. ∎ *(The step needing care is that a stabiliser of order m forces the 3-set to be a union of ⟨ζ^{d/m}⟩-orbits — at m = 3 a set {x, ζ′x, ζ′²x} with ζ′ of order 3, at m = 2 a set containing an antipodal pair.)*

**Why c > 3 is needed.** At c = 3 the only 3-subset is the whole block, fixed by every group element; the formula returns 1, but through the C(c,3) cap rather than because the argument applies — the free-translation step fails outright. At c = 2 there are no 3-subsets at all.

**Where the cap binds.** Only for c ≤ 7: since d ≤ c − 1, one has c·d ≤ c(c−1) ≤ C(c,3) as soon as c ≥ 8.

**Verified exhaustively** over every (c, d) with c ∈ {5, 7, 11, 13, 17, 19, 23} and d | c − 1 — **32 of 32 agree**, covering the cap and all three κ regimes.

> **The general shape, which is the useful statement.** Writing κ_k(d) = max{ m ≤ k : m | d }, one gets **orb_k(c, d, 1) = min(c·d/κ_k(d), C(c,k))**, and the familiar k = 2 law orb(c, d) = min(cd/2 if 2 | d else cd, C(c,2)) is the case k = 2. The twist buys a factor d, and the *only* thing k changes is how much of that factor the stabiliser can give back — at most a factor k, and only when k | d.
>
> **This is the whole reason the density collapses.** orb_k ≤ c·d/κ ≤ c(c−1)/k is Θ(c²) whatever k is, while C(c,k) ~ c^k/k!. The numerator does not grow with k; the denominator does.

### 2.2 Prime-power blocks

Two complications arise here and nowhere else: the law can fail outright, and the group has a semilinear part. They are independent and are taken separately.

**Notation, since it matters for what follows.** A block of size c = p^a carries

> **Γ(d, m) := 𝔽_c ⋊ (C_d ⋊ C_m)**,  d | c − 1,  m | a,

where C_d is the subgroup of order d of the multiplicative group 𝔽_c^× ≅ C_{c−1}, and C_m is the subgroup of order m of the Galois group Gal(𝔽_c/𝔽_p) ≅ C_a generated by Frobenius. **Both are subgroups of cyclic groups**, so each is determined by its order alone and C_m automatically normalises C_d — the subgroup of order d being unique. This is a tightly constrained lattice of choices: one divisor of c − 1 and one divisor of a.

Γ(c−1, 1) is the full AGL(1, c) and Γ(c−1, a) the full AΓL(1, c), but those are the *extreme* members. The general configuration takes proper subgroups of both, and §2.1's law is the case **m = 1**.

#### 2.2.1 The affine-line failure, and what actually triggers it

At c = 9 the law of §2.1 overstates by exactly the factor the additive lines cost:

| c = 9, twist d | 1 | 2 | 4 | 8 |
|---|---|---|---|---|
| law would give | 9 | 9 | 18 | 36 |
| actual minimum | **3** | **3** | **6** | **12** |

a factor of 3 throughout — the order of the additive subgroup. But the law **holds at c = 4, 8, 16, 25, 32, 49** (verified). So the trigger is not prime-power-ness; it is the existence of a **3-element additive subgroup** for a 3-set to be a coset of, i.e. **3 | c with c > 3**. At p ≠ 3 no such subgroup exists and the free-translation step of §2.1 survives verbatim. *At general k the analogous poison is p ≤ k with a ≥ 2, so the excluded set grows with k.*

#### 2.2.2 When the Galois part raises the minimum

Passing from Γ(d, 1) to Γ(d, m) multiplies the group order by m, and a larger group fuses orbits, so the minimum can rise. When it does is decidable from (p, a, d, m) alone.

> **Lemma (fusion).** Γ(d, 1) ⊴ Γ(d, m) with quotient C_m, so **every Γ(d, m)-orbit on 3-sets is a union of Γ(d, 1)-orbits**, permuted by C_m with sizes preserved. If a Γ(d, 1)-orbit A has C_m-stabiliser of order t, its Γ(d, m)-orbit has size |A|·m/t. Hence
>
> **min₃(Γ(d, m)) = min over Γ(d,1)-orbits A of |A|·m/t(A)**,
>
> and the minimum is unchanged iff some minimum-size Γ(d, 1)-orbit is fixed by all of C_m. ∎

*Proof.* Normality gives the union and size statements; orbit–stabiliser for C_m acting on the set of Γ(d,1)-orbits gives the size formula. ∎

> **Theorem.** Let c = p^a, d | c − 1, m | a with m > 1. Then
>
> **min₃(Γ(d, m)) > min₃(Γ(d, 1)) ⟺ p = 2, m = a, gcd(a, 6) = 1, and gcd(d, 6) = 1**,
>
> and the gain is then exactly **q = the smallest prime divisor of a**.

*Sufficiency of each escape — exhibit a C_m-stable minimal orbit.*

- **gcd(d, 6) > 1.** If 2 | d, the set {0, 1, −1} is fixed *pointwise* by every Galois element and has C_d-stabiliser of order 2, so its orbit has the minimal size c·d/2. If 3 | d, the set {1, ζ′, ζ′²} is fixed *setwise*, since ζ′^p again has order 3.
- **p ≥ 3.** Every Galois element fixes 𝔽_p pointwise, and |𝔽_p| = p ≥ 3, so any 3-subset of 𝔽_p is C_m-fixed. (At p = 3 the minimal orbit is the line orbit of §2.2.1, and Galois elements are 𝔽_3-linear, so they permute the lines and that orbit is stable too.)
- **p = 2, gcd(m, 6) > 1.** If 2 | m the subfield 𝔽₄ is C_m-invariant with Frobenius acting as its nontrivial automorphism, so {0, ω, ω²} is stable; if 3 | m the same holds for an order-3 orbit inside 𝔽₈.
- **m < a.** A generator h of the C_m quotient is Frob^i with Frob^i of order m, so gcd(i, a) = a/m and **Fix(h) = 𝔽_{p^{a/m}}, of size ≥ p² ≥ 4**. Any 3-subset of that subfield is fixed pointwise, hence C_m-stable. *So a proper Galois subgroup never gains anything* — the gain requires taking **all** of C_a.

*Necessity.* Assume p = 2, m = a, gcd(a, 6) = 1, gcd(d, 6) = 1, and suppose some Γ(d,1)-orbit were C_a-stable, so some h stabilises a 3-set S and maps to a generator of C_a. Since gcd(d, 6) = 1 no 3-set has a nontrivial C_d-stabiliser, and p = 2 means no 3-set is a union of cosets of an additive subgroup, so **Γ(d, 1) acts freely on 3-sets**; hence h^a ∈ Γ(d,1) fixes S and is the identity, so h has order a. Then h|_S has order dividing both a and 6, and gcd(a, 6) = 1 forces h to fix S pointwise. But m = a gives Fix(h) = 𝔽_2, of size 2 < 3. Contradiction. ∎

*The gain factor.* For C_t ≤ C_a the same computation gives |Fix| = 2^{a/t} ≥ 3 exactly when a/t ≥ 2, so the largest achievable stabiliser is t = a/q with q the least prime divisor of a, and the minimum multiplies by a/t = q. ∎

> **Then impose Oliver's condition, which tightens it once more.** The theorem is about Γ(d, m) as a permutation group; the framework admits only chain groups. Γ₂ = 𝔽_c is forced, so the question is how C_d ⋊ C_m splits into a cyclic middle and a q-group top.
>
> - **d = 1.** C_d ⋊ C_m = C_m is cyclic, so it sits entirely in the middle layer with a *trivial top* — admissible for any m, and the harshest χ condition. But the block is then worth only c·m.
> - **d > 1 and m = a** (which the theorem requires). Frobenius itself acts on C_d by x ↦ x², nontrivially whenever d > 1, so the *generator* of C_a cannot join the middle layer. That does not force **all** of C_a upstairs, and the layer assignment has to be worked out rather than asserted.
>
> > **The split.** Let C_{a′} ≤ C_a be the part of the Galois group that joins the cyclic layer. Its generator is Frob^{a/a′}, which acts on C_d by x ↦ x^{2^{a/a′}} and centralises C_d exactly when **d | 2^{a/a′} − 1**. Given that, Γ₁ = 𝔽_c ⋊ (C_d × C_{a′}) has abelian quotient C_d × C_{a′} over Γ₂, **cyclic iff gcd(d, a′) = 1**; and Γ₁ ◁ Γ because Frobenius normalises C_d and centralises C_{a′}. The remaining quotient is Γ/Γ₁ ≅ C_{a/a′}, which must be the top q-group. So the requirement is not on a itself but on the existence of a suitable split:
> >
> > > **∃ a′ | a with (i) d | 2^{a/a′} − 1, (ii) gcd(d, a′) = 1, and (iii) a/a′ a prime power q^e.**
> >
> > The case a′ = 1 is the branch where all of C_a sits on top, requiring a to be a prime power; it is one branch of several.
>
> **Corollary (Oliver-constrained).** For a block with d > 1, the Galois part raises the minimum **iff p = 2, gcd(d, 6) = 1, and a admits a split as above** — with q, the top prime, the least prime divisor of a/a′; the gain (the factor of the theorem, which needs m = a) is the least prime divisor of **a**.
>
> **a need not be a prime power.** Take **a = 35, d = 31, c = 2³⁵**: since 31 | 2⁵ − 1 divides 2^{35/7} − 1, put a′ = 7 in the cyclic layer, where C₃₁ × C₇ ≅ C₂₁₇ is cyclic (gcd(31, 7) = 1), leaving Γ/Γ₁ ≅ C₅. A genuine Oliver chain, top prime 5, m = a = 35, gcd(35, 6) = gcd(31, 6) = 1 — so the gain applies, with factor 5. **C₃₅ never has to be a q-group; only the part of it left on top does.**
>
> > **This predicate is load-bearing in the unusual direction.** §5.8 records that a k = 3 scoring which under-credits the Galois part is not a loose upper bound but not an upper bound at all, so a predicate admitting *too few* blocks is the dangerous error here — the reverse of the k = 2 situation, where crediting too much is what is safe. Anything enumerating Galois blocks (§4.2's census note on m, §6.1's escape count, §5.7's rows where a Galois block competes, and any k = 3 enumerator) must test the split, not a primality condition on a. **Implemented in `k3_galois.py`**, which the enumerator should import rather than re-derive.
>
> > **Two quantities that are not the same, and this is the next trap.** The theorem's **gain** is lpf(a); the split's **top prime** is q = lpf(a/a′). At a a prime power these coincide, which is why the superseded reading could conflate them without visible damage. At composite a they diverge, and since §4.3 couples the top prime to every foreign block in the configuration — each needing q | r − 1 — the divergence is usable: at a = 35 the twist d = 31 splits with a′ = 7 giving **q = 5**, while d = 127 splits with a′ = 5 giving **q = 7**, and the gain is lpf(35) = 5 either way. So **the twist choice selects the top prime at fixed block size**, a degree of freedom the naive predicate cannot express, since a = q^e determines q uniquely.
>
> > **Where the correction actually bites, which is further out than it sounds.** The block sizes it adds are exactly the a coprime to 6 that are not prime powers: **a ∈ {35, 55, 65, …}**, all of which have lpf(a) = 5, so the added blocks are low-gain. But the block size determines n — the shape is n = c = 2^a — so the correction is not diluted across many n: at **n = 2³⁵** the naive predicate credits gain 1 where the truth is 5, and the bound is a factor of 5 too small, hence not an upper bound. The smallest affected n is therefore 2³⁵ ≈ 3.4 × 10¹⁰, far beyond any table, which is why this is a theorem-statement issue rather than a computational one. Tracked as A19 of `pending-checks.md`.

> **This phenomenon does not exist at k = 2, and the reason is the whole of it.** Run the necessity argument at k = 2: a stabilising h must fix the 2-set pointwise unless h|_S has order 2, and either way the escape is a k-subset of the fixed field. **Fix(h) ⊇ 𝔽_p always has p ≥ 2 elements, so a 2-subset of it always exists** — {0, 1} when the twist is odd, {1, −1} when 2 | d and p is odd — and it always lies in a minimal orbit. So there is always a Galois-stable minimal orbit and the minimum never moves.
>
> **The general statement: the Galois part can help only when p < k**, since 𝔽_p supplies a k-subset exactly when p ≥ k. At k = 2 that is never; at k = 3 it is exactly p = 2; at k = 4 it is p ∈ {2, 3}, and the excluded set grows with k. *Verified at k = 2 across c = 8, 9, 16, 25, 32, 64, 128 and every twist — the minimum is identical under Γ(d, 1) and Γ(d, a) in all 28 cases, including the c = 32 and c = 128 blocks where the k = 3 minimum rises by 5 and 7.*

> **What this buys: the verification problem becomes arithmetic.** No orbit computation is needed to decide whether the Galois part helps at a given block — the answer is a function of (p, a, d, m) alone, and under Oliver's condition of (p, a, d). In particular the gain exists **only in characteristic 2**, only at m = a, and only when a is a prime power with least prime ≥ 5.
>
> *Verified at 16 further (c, p, a, d) combinations* spanning c = 8, 16, 32, 64, 81, 125, 128 — every prediction correct, including the no-rise cases at a = 6 (c = 64) and at p = 3, 5 with a ≥ 3, which the escape clauses alone would not have settled.
>
> **Two clauses are proved but out of computational reach:** that the factor is the *least prime divisor* of a rather than a itself (the testable cases a = 5, 7 are prime, so the two agree; the first distinguishing case is a = 25, c = 2²⁵), and that m < a never gains (first distinguishing case a = 10, c = 2¹⁰, where C(c,3) ≈ 1.8 × 10⁸).

#### 2.2.3 The Mersenne family: the extreme member, where both subgroups are everything

The Oliver-constrained criterion has a clean family satisfying it at once — and it is the case where **both** subgroups in Γ(d, m) are the whole thing, d = c − 1 and m = a. That is what makes it extreme rather than typical, and worth stating separately from the general criterion.

> **Proposition.** Let p ≥ 5 be prime with M = 2^p − 1 also prime, and set c = 2^p. Then **Γ(M, p) = AΓL(1, c) acts freely on 3-subsets of 𝔽_c**, so every orbit has size c·M·p and
>
> **min₃(Γ(M, p)) = 2^p(2^p − 1)p = p · min₃(Γ(M, 1))** — the Galois part is worth exactly the factor p.

*Direct proof.* |AΓL(1,c)| = c·M·p with c = 2^p, and the three prime divisors are 2, M and p. It suffices to show no element of prime order stabilises a 3-set, since any element with a stable 3-set has a prime-order power with the same property.
*Order 2:* the point stabiliser C_M ⋊ C_p has odd order, so every involution is a translation, with cycle type 2^{p−1} transpositions. A stable 3-set would be a union of transpositions — impossible, 3 being odd.
*Order M:* these are the multiplications by a generator, fixing 0 and M-cycling the rest; a stable 3-set would be a union of a fixed point and M-cycles, and M = 2^p − 1 > 3.
*Order p:* by Sylow, these are conjugates of Frobenius, whose fixed field is 𝔽₂; so the cycle type is two fixed points and (c − 2)/p cycles of length p. A stable 3-set needs 1+1+1 (only two fixed points are available) or a single p-cycle (p ≠ 3). Both fail. ∎

**This is the Oliver-constrained criterion of §2.2.2 at e = 1.** It asks for p = 2, gcd(d, 6) = 1 and a = q^e with q ≥ 5: here p = 2, a = p′ is itself a prime ≥ 5, and M = 2^{p′} − 1 is odd with 3 ∤ M because p′ is odd. Γ₂ = 𝔽_c, Γ₁/Γ₂ = C_M, Γ/Γ₁ = C_{p′} — a genuine Oliver chain with top prime p′. The gain factor is the smallest prime divisor of a = p′, namely p′ itself. **What the Mersenne condition adds** is that the *maximal* twist d = c − 1 is itself coprime to 6, so the gain lands on the strongest configuration rather than only on a weak one — at a general c = 2^{p′} the criterion is still met, but only for the divisors d of c − 1 that are coprime to 6.

The direct proof below is self-contained and exhibits the freeness explicitly, which the general argument only implies.

**Verified at both available cases.** c = 32 (p = 5): 992 → **4960**, factor 5. c = 128 (p = 7): the orbit of {0, 1, 3} has size **113,792 = 128·127·7** under Γ(127, 7) and 16,256 = 128·127 under Γ(127, 1) — free, factor 7 exactly, with C(128,3) = 341,376 splitting into exactly 3 orbits.

**Why the extremity matters for reading these numbers.** Both d and m are maximal here, so the family cannot show what happens at intermediate subgroups — and §2.2.2 says the intermediate cases behave *differently*, since m < a never gains at all. A general block chooses one divisor of c − 1 and one divisor of a; the Mersenne family is the corner of that lattice where both choices are forced.

> **A nontriviality condition, and it bites at p = 5.** The gain is capped by C(c,3), so it is genuine only when c(c−1)a ≤ C(c,3), i.e. **a ≤ (c−2)/6**. At c = 32 this is 5 ≤ 5 — equality, so AΓL(1,32) is *sharply transitive* on 3-sets and the minimum has been pushed as far as it can go. At c = 128 it is 7 ≤ 21, comfortably slack. So p = 5 is the extremal member of the family, not a typical one.

**Connection to the projective primes of Jones–Zvonkin.** Their object is (q^n − 1)/(q − 1) prime; at q = 2 that is 2^n − 1, so **their projective primes at q = 2 are exactly the Mersenne primes**, and this family is the same arithmetic condition met from a different direction. Two consequences worth carrying:

- **The supply is outside Bateman–Horn**, for the reason they state — 2^p − 1 is exponential in p, not a polynomial value, so the conjecture does not apply. The relevant heuristic is Lenstra–Pomerance–Wagstaff, giving ~e^γ log x / log 2 Mersenne primes below x: conjecturally infinite, but a density-zero and very thin supply.
- **So this is the k = 3 instance of the exponential regime** already isolated at k = 2 in `arithmetic-of-density.md` §3.5.6 and `literature-findings.md` item 14. The same boundary — polynomial families inside Bateman–Horn, 2-power families outside it — reappears here as the boundary between blocks where semilinearity is worth a factor and blocks where it is worth nothing.

> **Consequence for J0a, and a trap on the way to it.** The GL(1)-versus-ΓL(1) distinction is the open **J0a** of `enumeration-proof.md` and the false ΓL(1) step of Part B. It is tempting to conclude from a handful of prime-power examples that min₃ is insensitive to it — **that conclusion is false**, and the examples that suggest it (c = 8, 9, 16, 25, 27, 49) all satisfy one of the escape clauses above, so a sample chosen for convenience will reliably mislead here. A k = 3 programme **does** inherit the J0a question, and inherits it in a sharp form: the semilinear reading is worth a factor of a exactly on blocks with gcd(d, 6) = 1, a ≠ 3 and 3 ∤ c — subject, inside this framework, to the layer split of §2.2.2's Oliver-constrained corollary. Since larger orbits are *better* for us, this is an opportunity rather than a hazard — but it means the shape space must be indexed by ΓL twists, not GL twists.

### 2.3 The three-argument notation, and the law in one formula

The block group is Γ(d, m), so the orbit function should carry the same two parameters. Write

> **orb₃(c, d, m)** := the minimum size of a Γ(d, m)-orbit on 3-subsets of a block of size c = p^a,

so that §2.1's law is orb₃(c, d, 1), and the Mersenne case of §2.2.3 reads **orb₃(32, 31, 5) = 4960** against orb₃(32, 31, 1) = 992.

**Everything above is one formula.** The orbit is |Γ(d, m)| divided by the largest setwise stabiliser of a 3-set, capped by the number of 3-sets:

> **orb₃(c, d, m) = min( c·d·m / κ₃ , C(c,3) )**,  κ₃ = τ · θ · γ,
>
> - **τ = p if p = 3, else 1** — the *translation* stabiliser. A 3-set can be a coset of an additive subgroup only when 3 | c; this is §2.2.1's affine-line degeneracy.
> - **θ = max{ j ≤ 3 : j | d }** — the *twist* stabiliser, §2.1's κ.
> - **γ = m**, except in the rise case of §2.2.2 — p = 2, m = a, gcd(a,6) = 1, gcd(d,6) = 1 — where **γ = a/q** with q the least prime divisor of a.

**Verified: 104 (c, d, m) triples over c ∈ {5, 7, 8, 9, 11, 13, 16, 17, 19, 23, 25, 27, 32, 49}, every divisor d of c − 1 and every divisor m of a — 0 mismatches.**

> **The three factors are the three places a stabiliser can come from**, and reading κ₃ that way is what makes the earlier results one result rather than three. τ is the translations, θ the multiplicative twist, γ the Galois part; the rise case is exactly where γ falls short of m because no minimal orbit is Galois-stable.

> **At k = 2 the third argument is inert**, which is why the k = 2 documents never needed it: `enumeration-proof.md` J0a shows orb₂(c, d, m) = orb₂(c, d, 1) for every m. The same three-factor reading applies there — τ = 2 in characteristic 2 (the translation x ↦ x + 1 swaps a pair, which is `orb`'s `char2` flag), θ = 2 when 2 | d, and γ ≡ m always. **So the k = 2 formula is this one with the Galois factor forced to be trivial**, and the general-k statement is that τ contributes p when p | k, θ contributes max{j ≤ k : j | d}, and γ is inert exactly when p ≥ k.

## 3. Full density at k = 3, and why the constant-density apparatus dies

### 3.1 What full density needs, and the classification of who has it

A block reaches δ = 1 when its whole k-set collection is a single orbit. The property required is **k-homogeneity** — transitivity on k-*subsets* — not k-transitivity, and at k = 3 the two genuinely differ: |AGL(1,8)| = 56 = C(8,3) is far below 8·7·6 = 336, so it cannot be 3-transitive, yet it is transitive on 3-sets. Reaching for 3-transitivity here would be reaching for more than is needed.

> **Theorem (Kantor 1972, building on Livingstone–Wagner 1965).** For n ≥ 6, a 3-homogeneous but not 3-transitive group is **AGL(1,8), AΓL(1,8), AΓL(1,32)**, or contains PSL(2, q) with q ≡ 3 (mod 4). For 3 ≤ n ≤ 5 the possibilities are A₄ (n = 4) and AGL(1,5) (n = 5).

PSL(2, q) is not solvable and Oliver chain groups are, so within this framework:

> **The solvable 3-homogeneous groups of degree ≥ 5 are exactly AGL(1,5), AGL(1,8), AΓL(1,8) and AΓL(1,32)** — degrees **5, 8, 32** and nothing else.

**The computation agrees exactly.** Searching every prime power c ≤ 4096 and every admissible (d, m) for orb₃(c, d, m) = C(c,3):

| c | Γ(d, m) | \|Γ\| | C(c,3) | |
|---|---|---|---|---|
| 5 | Γ(4, 1) = AGL(1,5) | 20 | 10 | stabiliser of order 2 |
| 8 | Γ(7, 1) = AGL(1,8) | 56 | 56 | **sharply** transitive on 3-sets |
| 32 | Γ(31, 5) = AΓL(1,32) | 4,960 | 4,960 | **sharply** transitive; needs the Galois part |

and nothing else in range. Adjoining Frobenius at c = 8 gives AΓL(1,8) of order 168 with stabiliser 3 — still one orbit, so the same δ₃ = 1 by a different route.

**This is where §2.2.3's nontriviality condition comes from.** The Mersenne family gains a factor q at every member, but the gain is capped by C(c,3), and a ≤ (c−2)/6 holds with *equality* at a = 5 and strictly thereafter. So **c = 32 is the last block at which this framework reaches full density at k = 3**; c = 128 already sits at 1/3.

### 3.2 Why the density nevertheless goes to zero

Full density at three blocks does not save the asymptotics, for a reason that needs no classification.

> Every orbit has size at most |Γ|. A block of size c carries at most Γ(c−1, a) = AΓL(1, c), of order c(c−1)a ≤ c² log₂ c. So δ₃ ≤ c² log₂ c / C(c,3) = **O(log c / c) → 0**.

So the three exceptional blocks are exactly that — exceptions at small c, where c² log c has not yet been overtaken by c³/6. **There is no infinite family, and the classification says why: there cannot be one.**

**The contrast with k = 2 is the point.** There, δ = 1 holds at *every* prime power, because AGL(1, c) is 2-homogeneous — an infinite family, and the reason S1 is trivial at k = 2. The order bound is no obstacle because |Γ| ≈ c² and C(c,2) ≈ c²/2 are the same order. At k = 3 the denominator gains a factor of c and the numerator does not — **but the order bound bites only asymptotically, and it is tight at exactly two degrees.**

> **δ₃ = 1 occurs at exactly five degrees, and every one of them is Oliver.** Reading the classification of §3.1 for *solvable* groups gives **n ∈ {3, 4, 5, 8, 32}**, all prime powers:
>
> | n | group | C(n,3) | Oliver chain | note |
> |---|---|---|---|---|
> | 3 | C₃ | 1 | Γ₂ = Γ₁ = 1, Γ/Γ₁ = C₃ | degenerate: one triple |
> | 4 | A₄ = C₂² ⋊ C₃ | 4 | Γ₂ = C₂², trivial layer, Γ/Γ₁ = C₃ | S₄ is also 3-transitive here |
> | 5 | AGL(1,5) = C₅ ⋊ C₄ | 10 | Γ₁ = C₅ cyclic, Γ/Γ₁ = C₄ | 3-homogeneous, not 3-transitive |
> | 8 | AGL(1,8) = C₂³ ⋊ C₇ | 56 | Γ₂ = C₂³, trivial layer, Γ/Γ₁ = C₇ | **regular** on triples |
> | 32 | AΓL(1,32) | 4960 | Γ₂ = C₂⁵, Γ₁/Γ₂ = C₃₁, Γ/Γ₁ = C₅ | **regular** on triples |
>
> Degrees 6 and 7 fail — C₆ splits the triples 2/6/6/6 and AGL(1,7) splits them 14/21 — and Kantor closes everything above 5 except 8 and 32, the PSL(2,q) branch being insoluble. So S1's analogue is non-empty at k = 3, merely finite.
>
> **Two independent reasons the list stops, and the order bound is the sharper one.** |AΓL(1,c)| = c(c−1)log₂c against C(c,3) ≈ c³/6 permits equality only up to c = 32 and fails from c = 64 on; and at the single intermediate degree it does permit — c = 16, where 960 ≥ 560 — the group is nonetheless *not* 3-homogeneous (orbits 80 and 480). At 8 and 32 the order is met with **equality**, so those two are regular on triples rather than merely transitive: the family stops because it runs out of room, and its last two members fit exactly.

> **And at k ≥ 5 the phenomenon vanishes completely.** Livingstone–Wagner show that for 2 ≤ k ≤ n/2 a k-homogeneous group is (k−1)-transitive, and **for k ≥ 5 it is k-transitive**. Solvable k-transitive groups have degree ≤ 4, so there are no solvable k-homogeneous groups with 5 ≤ k ≤ n/2. **Full density is attainable at infinitely many blocks when k = 2, at exactly three when k = 3, and never when k ≥ 5.**

### 3.3 What this says about `arithmetic-of-density.md` §3

The mod-24 ceilings, the cap_F(η) optimisation and the balance points are a **k = 2 phenomenon resting on a group-theoretic accident** — that solvable 2-homogeneous groups exist at every prime power, so that a block can be handed full density and there is then something to optimise (at k = 3 the analogous groups exist only at degrees 3, 4, 5, 8 and 32, so the accident is finite rather than absent). They are not a general feature of the method, and the k = 3 replacement is not a weaker version of the same analysis but a different one (§4): only intra terms bind, so there is no *term-type* comparison to make — though the allocation between parts survives, with the same balance points (§5.7).

*One degree of freedom that is not hidden in the k = 2 ceilings*: whether a block's twist is read in GL(1, c) or ΓL(1, c). At k = 2 that provably changes no orbital minimum (`enumeration-proof.md` J0a); at k = 3 it does, and at c = 32 it is the difference between δ₃ = 1/5 and δ₃ = 1.

## 4. The configuration census at k = 3

*The same shapes as `enumeration-proof.md`'s census, keyed by the same S-numbers, asked at k = 3. **Comprehensiveness is not claimed** — this is the k = 2 list re-analysed, not a fresh enumeration, and §10 records what a completeness argument would have to add. S-numbers are append-only, as in the k = 2 documents.*

### 4.1 The structural simplification: only intra terms bind

Measured across every shape below, **the minimum 3-set orbit always lies inside a single block.** The witnesses are (0,1,2), (17,18,25), (22,23,26), (26,27,29) — three points of one block in every case, never a set spread across blocks.

The reason is a degree count and it is decisive:

> An **intra** term is F·orb₃(c, d, m) ≈ F·c·d·m/κ₃ ≤ s·c/κ₃, **quadratic** in n. Every **cross** term — two points in one part and one in another, or one in each of three — is a product of two or three part sizes, hence **cubic** in n. So cross terms exceed intra terms by a factor of order n, and the minimum is an intra term at every configuration with more than one part.

**This is the single largest structural difference from k = 2**, where cross terms routinely bind and most of `arithmetic-of-density.md` §3 is the comparison between intra, within-class-cross and between-orbit terms. At k = 3 that comparison collapses:

> **min₃(configuration) = min over classes of the class's intra term** = min(F_i·orb₃(c_i, d_i, m_i)).

So the optimisation is no longer a balance between competing term types. It is: **partition n into parts and maximise the smallest part's F·orb₃(c, d, m)**. Since F·orb₃(c, d, m) ≈ s·c·m/κ₃ with s = F·c the part size, a part's value is its *size times its block size* — so the whole problem is to keep the block sizes large, and the parts few.

*Caveat.* This is measured over n ≤ 46 and asserted by the degree count. A cross term could bind at small n where the cubic has not yet overtaken the quadratic; none of the computed cases shows it, but the crossover has not been located.

### 4.2 The census

> **What m is, and what value it takes in each row.** Recall Γ(d, m) from §2.2: **d | c − 1** is the order of the multiplicative twist and **m | a** is the order of the Galois subgroup, where c = p^a. Two facts fix m throughout the table, so it is never a free parameter in practice:
>
> - **A foreign block has prime size**, so a = 1 and **m = 1 is forced**. Every foreign entry below is orb₃(r, t, 1), and the only choice there is the q-power twist t.
> - **On a matching block, intermediate values are useless.** §2.2.2 shows a proper Galois subgroup (1 < m < a) never raises the minimum, because the fixed field 𝔽_{p^{a/m}} then has at least p² ≥ 4 elements and supplies a stable 3-set. So **the only values worth writing are m = 1 and m = a**, and m = a is worth taking only under the Oliver-constrained criterion of §2.2.2 — p = 2, gcd(d, 6) = 1, and a admitting the layer split there — at a cost analysed in §4.3.
>
> So in the rows below: **m = 1 everywhere except S1 and S2**, where m ∈ {1, a} and the choice is the subject of §4.3. Where a row writes orb₃(c, d, m) without fixing m, both readings are live and §4.3 decides between them.


| # | Shape | Status at k = 3 | Binding term | δ₃ behaviour | change from k = 2 |
|---|---|---|---|---|---|
| **S1** | one matching block, n = c = p^a | exists at every prime power | orb₃(c, c−1, m), **m ∈ {1, a}** | **≈ 6/(κ₃n) → 0**, except at c ∈ {3, 4, 5, 8, 32} where δ₃ = 1 (§3.1); measured 0.2000 at n = 32 without the Galois part, 1.0000 with it | **Large.** At k = 2 this shape is δ = 1, the trivial full-density case. At k = 3 it is the *best* shape but no longer full: c(c−1)/κ against C(c,3) |
| **S2** | fused matching, n = F·c, c = p^a | exists, same condition | F·orb₃(c, d, m), **m ∈ {1, a}** | ≈ **6/(κ F n)**, so small F wins; measured 0.0333 at n = 46 (F = 2), 0.0171 at n = 39 (F = 3) | Same shape, same supply condition. F = 2 is now clearly optimal within the shape, where at k = 2 the 1/F ranking is the same but the constants differ |
| **S3** | matching + outside, n = c + r\* | exists, same condition | usually the **foreign** block: orb₃(r, t, 1) with t a q-power | measured **0.0080** at n = 36 (q = 3, t = 9) and **0.0027** at the same n with q = 2, t = 2 | **Loses to S2**, and the margin is set by the foreign twist, not by the split |
| **S4** | two matching + outside, n = 2c + r\* | exists | the **foreign** block, orb₃(r, t, 1) | measured **0.0020** at n = 35 (q = 3, t = 3) | Same as k = 2 in that the foreign block is the weak point; the margin is wider |
| **S5** | top-layer-fused matching + outside | exists | as S4 | — | The S5/S7 distinction survives unchanged: which layer holds the swap, hence which twist is available |
| **S6** | two outside blocks | exists | the weaker of orb₃(r_i, t_i, 1) | measured **0.0027** at n = 36 | **Changed from k = 2**, where it is capped by 1/(√m₁+√m₂)² and wins nowhere. At k = 3 it is just "two foreign blocks", scoring like S3 with both twists constrained |
| **S7** | middle-layer-fused matching + outside | exists | orb₃(r, t, 1) when the foreign twist is small | measured 0.0013 at n = 33 | Same shape; a small foreign twist is punished harder, orb₃ being linear in d with no C(c,2) cap to rescue it |
| **S8** | bottom-layer-fused matching | **killed, D1** — argument survives | — | — | D1's inequality strengthens: F·C(c,3) < C(Fc,3) needs only F < F³, a wider margin than k = 2's F < F² |
| **S9** | fused outside block | **exists; dominated at k = 2** (Lemma D2 caps it at n^{3/2}/2) — the k = 3 status is unchecked | — | — | D2's k = 2 domination rests on a pairs-specific same-position class; the k = 3 analogue should dominate more easily by §4.1's degree count, but it has not been derived |
| **S10** | outside block with r = q | **killed** — argument survives | — | — | The twist-collapse of D2q is about layers, not pairs, so it carries to k = 3 verbatim |

### 4.3 Where the Galois part enters the census, and what it costs

The third argument of orb₃ is not decoration in the census: it changes one row dramatically and constrains every other row that shares a configuration with it.

**It can only help a matching block.** A foreign block has prime size, so a = 1 and m = 1 forced — the Galois part does not exist there. So m > 1 is available exactly on p-characteristic blocks of proper prime-power size.

**S1 is where it pays, and it pays enormously.** At n = c = 2^a with a a prime power ≥ 5, §2.2.2's criterion is met automatically: d = c − 1 = 2^a − 1 is odd, and 3 ∤ 2^a − 1 because a is odd, so gcd(d, 6) = 1 without further hypothesis.

| n = 2^a | orb₃(c, c−1, 1) | **orb₃(c, c−1, a)** | C(n,3) | δ₃ |
|---|---|---|---|---|
| 32 (a = 5) | 992 | **4,960** | 4,960 | **1.0000** |
| 128 (a = 7) | 16,256 | **113,792** | 341,376 | 0.3333 |
| 2,048 (a = 11) | 4,192,256 | **46,114,816** | 1,429,559,296 | 0.0323 |
| 8,192 (a = 13) | 67,100,672 | **872,308,736** | 91,592,417,280 | 0.0095 |

**n = 32 attains δ₃ = 1** — the whole of C(32,3) in a single orbit. That is the k = 3 analogue of S1's δ = 1 at k = 2, and unlike k = 2 — where it holds at every prime power — it holds at only five n, of which 32 is the largest and 8 the only other non-degenerate one, because the gain factor q = a grows only logarithmically while C(c,3)/c² grows linearly. §2.2.3's nontriviality condition a ≤ (c−2)/6 is the same statement seen from the other side.

> **The cost: the Galois part fixes the top prime, and every foreign block in the configuration then pays for it.** Using C_a on top forces Γ/Γ₁ to be a q-group with q | a, so **q is the configuration's top prime**. Lemma B′ then requires every foreign block's twist to be a power of *that* q, i.e. **q | r − 1** for every foreign r in the configuration.
>
> This is a genuine coupling with no k = 2 counterpart, because at k = 2 the Galois part buys nothing (J0a) and so is never worth spending a top prime on. Worked at a = 5, so q = 5:
>
> | foreign r | 5 \| r − 1 | twist t | orb₃(r, t, 1) |
> |---|---|---|---|
> | 11 | yes | 5 | 55 |
> | 31 | yes | 5 | 155 |
> | 41 | yes | 5 | 205 |
>
> All admissible, but all weak: **the twist is stuck at t = 5 whatever r is**, so the foreign block contributes only 5r/κ₃ — **linear in n**. So a configuration that spends its top prime on the Galois gain typically gets a superb matching block and a foreign block that immediately becomes the binding term.
>
> **But "typically" is the right word, and the exception is instructive — see §6.2.** The twist is stuck at t = 5 only because 25 ∤ r − 1 for those r. Choosing the foreign block from the primes with **r ≡ 1 (mod q²)** instead of merely r ≡ 1 (mod q) lifts the twist to q² for no extra size, and the trade can then come out positive. At n = 133 = 32 + 101 it does: 101 − 1 = 4·25, so t = 25 and the foreign block scores 2525 rather than 505, which is enough to make the Galois part worth a factor of 2.5 overall. **The coupling is a strong presumption against combining the two, not a prohibition** — it costs a specific congruence condition on r, and the condition is satisfiable.

**Consequence for the ranking.** The Galois part is worth using **usually only in a pure-matching configuration** — S1, or S2 with F a power of the same q. The moment a foreign block is present, fixing q to a prime dividing a is normally a bad trade: q must be small enough to divide a, hence far too small to give the foreign block a twist of order r **unless r is chosen from the thinner set with q^e | r − 1 for some e ≥ 2** (§6.2). This is the first place in the census where a choice that improves one part actively damages another, and it is why S1's δ₃ = 1 at n = 32 does not propagate to *most* composite n — but at the n where the congruence can be met, it partially does.

### 4.4 The shifted-prime condition survives, and it is what separates the shapes

**The ranking is S1 > S2 > S3 ≈ S6 > S4, S5, S7**, and the separation is not about how n is split. It is about **which blocks are foreign** — and, by §4.3, about whether the configuration can afford to spend its top prime on the Galois part.

> **Lemma B′ is k-independent**, so a foreign block's twist still lies in the top q-group and is therefore a **q-power divisor of r − 1**. Its intra term is orb₃(r, t, 1) ≈ r·t/κ, so reaching Ω(r²) needs **t of order r** — the same shifted-prime condition as at k = 2, and the same θ = 1 endpoint.

**Measured, and the effect is large:** the same shape at the same n, differing only in the choice of top prime, gives

| n = 36, `17 + 19*` | q = 3, t = 9 | q = 2, t = 2 |
|---|---|---|
| min₃ | **57** | **19** |
| δ₃ | 0.0080 | 0.0027 |

A factor of three, entirely from the arithmetic of 18 = 2·3².

**So the earlier reading — that k = 3 "reduces to binary Goldbach" — is wrong, and wrong in an instructive way.** What changes at k = 3 is that the *term-type* comparison disappears: only intra terms bind, so there is nothing to trade against anything. **The allocation problem remains** — parts share a fixed n and the objective is a minimum — and its solution is not equal parts, because the parts have unequal efficiencies (§5.2). The balance point is in fact the same as k = 2's (§5.7). What does **not** change is the shifted-prime requirement, because that comes from Lemma B′ and the layer structure, not from the pairing.

**Which n escape it.** Only the pure-matching shapes:

- **S1**, needing n a prime power;
- **S2**, needing n = F·c with c a prime power and F = F_mid·F_top;
- more generally, configurations whose parts are *all* p-characteristic for one p, i.e. n a sum of powers of a single prime with admissible multiplicities.

Those are density-zero sets. **Every other n needs at least one foreign block, hence a shifted prime**, so the supply question at k = 3 is the k = 2 question over again — Bateman–Horn for the matching parts, shifted primes for the foreign one — with only the intra-versus-cross comparison removed — the balance-point analysis itself survives unchanged (§5.7).

> **Consequence for §7's constants.** The S3 row's n²/(4κ) tacitly assumed t of order r, i.e. a safe-prime-like foreign block. Without that assumption the row is r·t/κ, which is n^{1+θ} at best and can be as small as Θ(n) when the only available q-power divisor of r − 1 is 2. The constants below are therefore **conditional on the same shifted-prime input as the k = 2 ceilings**, and only S1 and S2 are unconditional.

## 5. The additive engine at k = 3

*The counterpart of `arithmetic-of-density.md` §3. There the engine does two things at once: it decides which of three competing term types binds, and it allocates n among the parts. **At k = 3 only the first disappears** — intra terms always bind (§4.1) — while the allocation survives as the same quadratic optimisation, with the same closed form and, generically, the same balance points row for row (§5.7). So the difficulty relocates into a single per-part quantity rather than vanishing. Written fresh rather than transported; the sandwich discussion is at the end as §5.8, and the escapes have their own section (§6).*

### 5.1 The objective

A configuration partitions n into parts sᵢ = Fᵢcᵢ, and by §4.1

> **m\*₃(configuration) = minᵢ Fᵢ·orb₃(cᵢ, dᵢ, mᵢ).**

There is no *term-type* comparison in the k = 2 sense — no intra-versus-cross trade to resolve — but there **is** an allocation problem, because the parts share a fixed budget n and the objective is a minimum. Spending n on one part starves the others, and since the parts have unequal efficiencies the optimum is **not** equal parts: §5.7 tabulates the balance points, which turn out to coincide with k = 2's.

### 5.2 Part efficiency, and the closed form

Define the **efficiency** of a part as its value per unit of size squared:

> **e := F·orb₃(c, d, m) / s²**,  s = F·c.

This is the k = 3 analogue of `aod` §3.3's η, and it plays the same role: it strips out the size so that what remains is a property of the part's arithmetic alone. Then vᵢ = eᵢsᵢ², and maximising min vᵢ subject to Σ sᵢ = n is a one-line optimisation — set all vᵢ equal, so sᵢ ∝ 1/√eᵢ — giving

> **m\*₃ ≈ n² / (Σᵢ 1/√eᵢ)²,  attained at sᵢ = n·(1/√eᵢ) / Σⱼ(1/√eⱼ).**

Three things follow immediately.

- **Fewer parts is better, always.** Each additional part adds a positive term to Σ 1/√eᵢ. This is §4's ranking, now with a reason rather than a measurement.
- **The formula is the same shape as `aod` §4.2's two-foreign-block cap** 1/(√m₁ + √m₂)², which is not a coincidence: that cap is the k = 2 instance of the same allocation argument, arising there only in the one shape where two parts have to share the budget without a cross term to compensate.
- **Balance is by efficiency, not by size.** Equal parts are optimal only when the efficiencies are equal. A low-efficiency part should be made *larger*, not smaller — it needs more size to reach the same value.

### 5.3 The efficiency of each kind of part

| part | value | efficiency e | range |
|---|---|---|---|
| matching, no Galois | c·d/κ₃ | **d / (c·κ₃)** | ≤ 1/κ₃, with equality at full twist d = c − 1 |
| matching, with Galois | c·d·m/κ₃ | **d·m / (c·κ₃)** | can **exceed 1**; at c = 32, d = 31, m = 5 it is 4960/1024 ≈ **4.84** |
| fused, F blocks of size c | F·orb₃(c,d,m)/(Fc)² | **orb₃(c,d,m) / (F c²)** | falls like 1/F — fusion costs efficiency |
| foreign, prime r | r·t/κ₃ | **t / (r·κ₃)** | = η₃/κ₃ where **η₃ := t/(r−1)** is the shifted-prime efficiency |

**The whole difficulty of the engine sits in the last row.** A matching block can always take its full twist, so its efficiency is 1/κ₃ — a bounded quantity decided by two congruences (τ = 3 iff 3 | c, θ by d mod 6). A foreign block's efficiency is η₃/κ₃, and **η₃ = t/(r − 1) with t a q-power** is exactly the shifted-prime quantity of `aod` §3.6. Everything conditional in the k = 3 picture enters here and nowhere else.

> **The Galois row is what has no k = 2 counterpart.** At k = 2 every part has efficiency ≤ 1 (the cap C(c,2) is attained at full twist), so the allocation is a competition among bounded quantities. At k = 3 a Galois block can have e ≈ 4.84, so it wants to be made *smaller* than its share — and since it is also the part that fixes the top prime (§4.3), the allocation and the arithmetic are coupled in a way they are not at k = 2.

### 5.4 The two-part ceiling

For a matching block c and a foreign block r, with efficiencies 1/κ_c and η₃/κ_r,

> **m\*₃ ≤ n² / (√κ_c + √(κ_r/η₃))²**,

which at κ_c = κ_r = 1 and η₃ = 1 is **n²/4**. That is the k = 3 ceiling for the two-part shape, and it has the same functional form as `aod` §3.3's cap_F(η) at F = 1 — η/(1 + √η)² — with δ replaced by m\*₃/n².

**The by-class version of this is §5.7.** What follows is the unconstrained statement; the ceiling per residue class, with the η values imported from `aod` §3.3, is tabulated there.

**The ceiling is not approached**, because c and r are not free: c must be a prime power, r a prime, and t a q-power divisor of r − 1. Best two-part configurations found by direct search:

| n | c | r | q | t | matching value | foreign value | m\*₃ | δ₃ |
|---|---|---|---|---|---|---|---|---|
| 30 | 19 | 11 | 5 | 5 | 114 | 55 | 55 | 0.01355 |
| 90 | 43 | 47 | 23 | 23 | 602 | 1081 | 602 | 0.00512 |
| 133 | 32 | 101 | 5 | 25 | 992 | 2525 | 992 | 0.00259 |
| 250 | 101 | 149 | 37 | 37 | 5050 | 5513 | 5050 | 0.00196 |

against a ceiling of n²/4 = 225, 2025, 4422, 15625. So the engine runs at roughly a quarter of ceiling, and the shortfall is arithmetic: either η₃ < 1 or the sizes cannot be put where the allocation wants them.

> **The n = 133 row is computed without the Galois part and so understates it.** With m = 5 the matching block rises from 992 to 4960 and the foreign block binds at 2525 — see §6.2, which is this section's allocation problem worked at a single n.

### 5.5 What the engine needs from number theory

Reading §5.3 off, the engine consumes exactly two arithmetic inputs:

1. **A matching block of prescribed size**, i.e. n's decomposition into prime powers with an admissible coprimality budget. This is `aod` §3.5's Bateman–Horn material, unchanged.
2. **A foreign prime with η₃ bounded below**, i.e. r − 1 carrying a q-power divisor of order r. This is `aod` §3.6's shifted-prime ladder, unchanged, and it is the same **θ = 1 endpoint** — η₃ bounded below is exactly the bounded-cofactor regime.

**What it does *not* consume** is the *term-type* comparison of `aod` §3.2 — which of intra, within-class cross and between-orbit binds — since at k = 3 the answer is always "the intra term of the weakest part". **Everything else survives**: there are still ceilings by residue class (§5.7), still a mod-24 classification (§5.6.3), and the balance points are literally k = 2's. What looked at first like the disappearance of the whole optimisation is the disappearance of one of its two ingredients.

> So the k = 3 engine is **the k = 2 engine with the *term-type* comparison removed and everything else intact** — the allocation, its balance points and the supply questions all survive — which is the precise form of the claim that k = 3 is not arithmetically easier (§4.4). The simplification is real but it is in the combinatorics, not the number theory.

### 5.6 The mod-12 and mod-24 structure, and how S4 / S5 / S7 change

*The Bateman–Horn systems are unchanged — same polynomials, same singular series, so `aod` §§3.4–3.5 transfer with nothing to re-derive. What changes is the congruence law governing a matching block's twist, and with it the competition between the three-part shapes. This subsection covers only that.*

#### 5.6.1 The block's own class: c mod 3 now leads

At k = 2 an odd block at full twist always reaches its cap: orb(c, c−1) = C(c,2) exactly, because c − 1 is even and the halving is exactly compensated. **At k = 3 there is no such identity**, because κ₃ takes three values rather than two:

> **orb₃(c, c−1, 1) = c(c−1)/3 if c ≡ 1 (mod 3), and c(c−1)/2 otherwise.**

So a block with 3 | c − 1 is **penalised by a factor 3/2 before any fusion**, purely for having a twist divisible by 3. This has no k = 2 counterpart — there, a larger twist is never worse — and it is the first place the mod-3 class of the block enters at all.

#### 5.6.2 The cost of a cyclic-layer fusion

The other congruence effect is the one `aod` §3.2.3 calls the c mod 8 law. A cyclic-layer fusion (F_mid = 2) forces the twist down to the **odd part** of c − 1, and the cost is the ratio of the two values. Writing 2^v ‖ c − 1:

> | | cost of cutting to the odd part |
> |---|---|
> | **k = 2** | **2^{v−1}**, always |
> | **k = 3** | **2^{v−1}** if 3 ∤ c − 1; **2^v** if 3 \| c − 1 |

so the cut is one factor of two *more* expensive exactly on the blocks already penalised by §5.6.1. **Verified at every odd prime power c ≤ 83.**

#### 5.6.3 The combined law, mod 12 and mod 24

Putting the two together for c coprime to 6:

| c mod 12 | v | 3 \| c − 1 | full-twist value | cut cost | verdict |
|---|---|---|---|---|---|
| **11** | 1 | no | c(c−1)/**2** | **1** | **best: full value and free fusion** |
| 7 | 1 | yes | c(c−1)/3 | 2 | penalised twice over |
| 5 | ≥ 2 | no | c(c−1)/2 | 2^{v−1} ≥ 2 | good value, costly fusion |
| 1 | ≥ 2 | yes | c(c−1)/3 | 2^v ≥ 4 | worst on both counts |

**and mod 24 refines it**, because v is not determined by c mod 12: c ≡ 11 and 23 (mod 24) both have v = 1 and are the good class; c ≡ 5 (mod 24) has v = 2 while c ≡ 17 has v = 4, so their fusion costs differ by a factor of four.

> **The contrast with k = 2 is a narrowing.** There the good class is **c ≡ 3 (mod 4)** — every one of c ≡ 3, 7, 11 (mod 12) is equally good, since only v matters. At k = 3 the class **c ≡ 11 (mod 12)** is strictly better than c ≡ 7, because the mod-3 penalty separates them. So the governing modulus rises from 4 to 12, and mod 24 enters for the same reason it does at k = 2 — to pin v.

#### 5.6.4 What this does to S4 versus S5 versus S7

The three-part shapes differ, as at k = 2, in **where the block swap lives** — and therefore in which of two costs they pay.

- **S7** (swap in the *cyclic* layer): the twist is cut to the odd part, at the cost of §5.6.2 — but **q is free**, so the foreign block may choose the top prime that maximises its own η₃.
- **S5** (swap in the *top* layer): the twist is untouched, so the matching block keeps its full value — but **q = 2 is forced**, so the foreign twist is the 2-part of r − 1 and η₃ is whatever that gives.
- **S4** (no fusion): two separate matching blocks, so neither cost, but by §5.2 an extra part is an extra term in Σ 1/√eᵢ.

**The trade is the same in shape as at k = 2, and different in magnitude.** At k = 2 the matching-side ratio S5 : S7 is 2^{v−1}, so at c ≡ 3 (mod 4) it is 1 and S7 wins outright on the free q. At k = 3 the ratio is 2^{v−1} or **2^v**, so:

| c mod 12 | S5 : S7 on the matching side | who wins |
|---|---|---|
| 11 | 1 : 1 | **S7** — equal blocks, and S7 gets a free q |
| 7 | 2 : 1 | S5's block is twice S7's, against a q = 2 foreign block |
| 5 | 2^{v−1} : 1 | S5 by 2 or more |
| 1 | 2^v : 1 | S5 by 4 or more |

> **So the c ≡ 3 (mod 4) escape narrows to c ≡ 11 (mod 12).** At k = 2, a third of the odd blocks give S7 its free-q win; at k = 3 only a quarter do, and on the rest S5's advantage is one factor of two larger than the k = 2 analysis would suggest. Whether S5 actually converts that advantage still turns on finding r with a large 2-part of r − 1 — the Fermat-like supply of `aod` §4.3, unchanged.

**Not done here, deliberately:** the density and existence counts for these classes. The Bateman–Horn systems are identical to k = 2's, so `aod` §§3.4–3.5's supply analysis applies verbatim and there is nothing to re-derive; what would need redoing is only the *ceiling* comparison, which at k = 3 is the allocation formula of §5.2 rather than cap_F(η).

### 5.7 The ceiling table by residue class

*The counterpart of `arithmetic-of-density.md` §3.3.5. The additive systems and their local obstructions are identical to k = 2's, so the **η column is imported unchanged**; what is recomputed is the ceiling it implies.*

**The reported quantity.** δ₃ = m\*₃/C(n,3) tends to 0 (§3.2) and is useless as a class invariant. The quantity that is asymptotically constant is

> **β₃ := m\*₃(n) / n²**,

the k = 3 analogue of δ. (At k = 2, δ = m\*/C(n,2) ≈ 2m\*/n², so β₂ = δ/2 in these units — worth keeping in mind when comparing columns.)

**The ceiling.** By §5.2, β₃ = 1/(Σᵢ 1/√eᵢ)². With a matching part of efficiency 1/(F·κ_c) and a foreign part of efficiency η₃/κ_r, where **η₃ = t/(r − 1) = η/2** on the k = 2 convention,

> **β₃ = 1 / (√(F·κ_c) + √(κ_r/η₃))².**

| n mod 24 | shape | η | **s\*/n**, κ_c = 2 | s\*/n, κ_c = 3 | **β₃** (κ_c = 2) | β₃ (κ_c = 3) | k = 2 cap (δ) |
|---|---|---|---|---|---|---|---|
| 0, 4, 6, 10, 12, 16, 18, 22 | S3, two parts | 1 | 0.50000 | 0.55051 | **0.12500** | 0.10102 | 0.25000 |
| 2, 8, 14, 20 | S3, two parts | 1/3 | 0.36603 | 0.41421 | **0.06699** | 0.05719 | 0.13397 |
| 1, 9, 13, 21 | S7 at F = 2 | 1 | 0.58579 | 0.63397 | **0.08579** | 0.06699 | 0.17157 |
| 3, 19 | S7 at F = 2 | 1/2 | 0.50000 | 0.55051 | **0.06250** | 0.05051 | 0.12500 |
| 5, 17 | S7 at F = 2 | 1/3 | 0.44949 | 0.50000 | **0.05051** | 0.04167 | 0.10102 |
| 7, 15 | S4 or S7 at F = 2 | 1/2 | 0.50000 | 0.55051 | **0.06250** † | 0.05051 | 0.08579 |
| 11 | S7 at F = 2 | 1/6 | 0.36603 | 0.41421 | **0.03349** | 0.02860 | 0.06699 |
| 23 | S4 or S7 at F = 2 | 1/6 | 0.36603 | 0.41421 | **0.03349** † | 0.02860 | 0.05051 |

> **The identity in the κ_c = 2 column.** Every row satisfies **β₃ = cap_F(η)/2** exactly, and the algebra is one line: 1/(√(2F) + √(2/η))² = ½·η/(1 + √(Fη))². So in the generic case — matching twist not divisible by 3, foreign twist coprime to 6 — **the k = 3 ceiling is exactly half the k = 2 ceiling as a fraction of n²**; equivalently, since β₂ = δ/2, the two are *equal in absolute terms*: **m\*₃ ≈ m\*₂ at the ceiling.** That is not a coincidence but a restatement of §4.1: at both k the binding term is a block's intra term, of order c², and only κ differs.
>
> **The balance point is *not* the middle, and in the generic column it is exactly k = 2's.** The share column reports **s\*/n**, the *part's* fraction of n — for a fused rung that is F·c/n, so it is twice `aod` §3.3.5's c/n column, which reports the block. Converted to the same units, the κ_c = 2 balance points are **identical to k = 2's row for row** (0.50000, 0.36603, 0.58579, 0.50000, 0.44949, …), which is forced: the allocation sᵢ ∝ 1/√eᵢ depends only on the ratio of efficiencies, and the factor of two relating β₃ to cap_F cancels out of it. So k = 3 does **not** flatten the balance towards equal parts.
>
> **What does move it is the mod-3 penalty**, and it moves it *away* from the middle rather than towards it: a κ_c = 3 matching block is less efficient, so by §5.2 it needs a **larger** share — 0.55051 against 0.50000, 0.63397 against 0.58579. The one row where it lands exactly on 1/2 is 5, 17.
>
> **The κ_c = 3 column is the mod-3 penalty of §5.6.1**, applying whenever the matching block has 3 | c − 1. It costs between 12% and 19% depending on the row, and it has no k = 2 counterpart — there is no third column at k = 2 because κ₂ has only one value on an even twist.

† **Rows 7, 15 and 23 need the rung comparison redone and the entries above are provisional.** At k = 2 those rows are decided by a tie between the fused and unfused rungs — cap_B(1/4) = cap_C(1/2) identically, a coincidence at η = 1/2 and nowhere else — and by which c mod 8 the argmax sits at. **§5.6.4 changes exactly that comparison**: the S5 : S7 matching ratio is 2^v rather than 2^{v−1} when 3 | c − 1, so the k = 2 tie need not survive. The entries here take the S7 reading at the k = 2 η and are therefore a lower bound on those three rows, not the ceiling. Redoing them needs the c mod 24 analysis of §5.6.3 run against each rung, which is not done.

> **Read these as ceilings of the family, exactly as at k = 2.** They say what the balanced shape guarantees in the class, not what n can achieve: a single Galois block reaches β₃ ≈ 4.84 (§5.3) and n = 32 reaches β₃ = 4.84 outright, far above every row. The rows are floors for m\*₃, not bounds on it.

### 5.8 What the sandwich would look like at k = 3

*The k = 2 framework runs on B_refined ≤ μ ≤ B_safe with the gap coming from exactly one place. The gap is different at k = 3, and the k = 2 SAFE cap does not transfer. Recorded because a k = 3 implementation would otherwise have to rediscover all three points.*

**First, n = 133 is fallback-free.** At k = 2, "fallback" means Lemma C strictly reduces a matching block's twist, i.e. the twist shares a prime with a foreign block. At n = 133 the matching twist is 31 and the foreign prime is 101, and gcd(31, 101) = 1, so **Lemma C never bites** — refined and safe scorings agree there. The configuration is also consistent in the new sense of §4.3: the Galois part needs q = 5 and the foreign twist needs q = 5, and both are met by the *same* q. Nothing is credited that the group cannot deliver.

**But k = 3 adds a second fallback axis, with no k = 2 counterpart.** The Galois gain is a property of a single block — it depends on that block's a — while **the top prime is global**. A configuration with matching blocks 32 (a = 5) and 128 (a = 7) would be credited orb₃(32, 31, 5) and orb₃(128, 127, 7) by any per-block scoring, but q would have to be both 5 and 7. That credit is unachievable, and such configurations are fallback configurations in the k = 3 sense. A certificate would need conditions ruling them out **alongside** the Lemma C ones — the two axes are independent, since one is about twists sharing primes with foreign blocks and the other about Galois parts disagreeing on q.

**Second, and more seriously: the k = 2 SAFE cap does not transfer.** SAFE works at k = 2 because **orb(c, c−1) = C(c,2) exactly** — at full twist the crude bound is attained, so F·C(c,2) is tight except where Lemma C bites, which is what keeps the sandwich narrow. At k = 3 that fails: C(c,3) ≈ c³/6 against an achievable c·d·m/κ₃ ≤ c(c−1)a/κ₃ ≈ c², so a C(c,3)-style cap **over-credits by a factor of order c/(6a)** and the sandwich would be a factor of n wide — useless.

> **The sharper statement is §3.1 again, in a third role.** C(c,3) is attained exactly at c ∈ {5, 8, 32}. So the three solvable 3-homogeneous blocks are precisely the blocks where the naive SAFE cap is tight, and nowhere else. The classification that limits full density is the same one that limits how crude a safe scoring can afford to be.

**So SAFE and REFINED largely collapse into each other at k = 3.** A usable safe scoring would have to be F·min(c·d·m/κ₃, C(c,3)) — essentially the true formula rather than a crude over-credit — and the residual gap is not Lemma C's twist-stripping but the global-q coupling above.

> **A soundness trap worth naming before anyone writes the code.** A k = 3 SAFE that simply *ignores* the Galois part — by analogy with k = 2, where it is provably inert (J0a) — would credit orb₃(c, d, 1). That is **smaller** than the achievable orb₃(c, d, a) by a factor of q on the blocks of §2.2.2. It is not a loose upper bound; it is not an upper bound at all. Any k = 3 scoring must carry m, which is why §2.3's notation takes three arguments.

## 6. The escapes

*The counterpart of `arithmetic-of-density.md` §4. An **escape** is a configuration that exists at only a thin set of n but, where it exists, beats what the balanced family of §5 guarantees. At k = 2 the escapes are the Fermat and safe-prime routes, reaching O(n/log n) values. At k = 3 there are three, and one of them has no k = 2 counterpart at all.*

### 6.1 The Galois escape

**The move.** Hold the partition fixed and turn on the Galois part: replace Γ(d, 1) by Γ(d, a) on a matching block. By §2.2.2 this multiplies that block's value by q = the least prime divisor of a, and by §5.2 it multiplies the block's efficiency by the same factor — so the block can be made *smaller* and the rest of n reallocated.

**Why it is an escape rather than a routine improvement.** It is available only when p = 2, gcd(d, 6) = 1 and a admits §2.2.2's layer split, so the matching block must be 2^a with gcd(a, 6) = 1 and a admitting §2.2.2's split — the blocks 32, 128, 2048, 8192, … together with the composite-a blocks the split admits (a = 35 among them), a set of density zero and, being Mersenne-adjacent in the twist condition, thin even among those. And it comes with the coupling of §4.3: taking it fixes the top prime at q, and every foreign block in the configuration then needs q | r − 1.

**So it is a trade, and the congruence decides it.** With only q | r − 1 the foreign twist is generically t = q and the block contributes q·r, linear in n — the Galois gain on one part is paid for by crippling the other. With **q² | r − 1** the twist is q² and the trade comes out positive. §6.2 works the smallest case.

**Count.** The matching side needs a coprime to 6 and admitting the split — a ∈ {5, 7, 11, 13, 25, 35, …} — so O(log n) block sizes below n; the foreign side needs a prime r ≡ 1 (mod q²) in the right window, which is a positive proportion of primes by Dirichlet. The binding constraint is the first, so this escape reaches **O(n/log n) values of n** — the same order as the k = 2 escapes, for a different reason.

### 6.2 The Galois escape, worked: n = 133

*The escape of §6.1 at a single n, and the cleanest instance of the pattern: the partition is held fixed and the Galois twist is added, which is only worth doing because a congruence on the foreign prime happens to be satisfiable.*

**The configuration.** n = 133 = 32 + 101, with the chain

| layer | contents | requirement |
|---|---|---|
| Γ₂ | 𝔽₃₂, translations of the 32-block | 2-group ✓ |
| Γ₁/Γ₂ | C₃₁ (twist of the 32-block) × C₁₀₁ (translations of the 101-block) | cyclic: gcd(31, 101) = 1 ✓ |
| Γ/Γ₁ | C₅ (Frobenius of 𝔽₃₂) × C₂₅ (twist of the 101-block) | 5-group ✓ |

so p = 2 and **q = 5**. The scores are orb₃(32, 31, 5) = **4960** = C(32,3) — the sharply-transitive block of §3.1 — and orb₃(101, 25, 1) = **2525**, verified by direct orbit computation. Cross terms are cubic and nowhere near binding, so **min₃ = 2525** and δ₃ ≈ 0.0066.

**Without the Galois part the same split gives only 992**, since orb₃(32, 31, 1) = 992 < 2525. So the Galois part is worth a factor of 2.5 here — and this is a case where §4.3's warning does *not* bite. Normally spending the top prime on the Galois gain cripples every foreign block; here it does not, because 5 is exactly the prime whose square divides 100.

> **The design principle, which is what makes the example work.** Fix the 32-block. Then q = 5 is forced, so Lemma B′ requires **5 | r − 1** and the foreign twist is the 5-part of r − 1. If one asks only for 5 | r − 1, the generic case is 25 ∤ r − 1, giving **t = 5** and an intra term of just **5r** — linear in r with a tiny constant. To beat the 32-block's cap of 4960 that way needs r > 992, hence n > 1024; but every unit spent on r is a unit not spent on the matching side, and the density C(n,3) grows as n³. So the foreign block is either too small to contribute or too large to afford.
>
> **The way out is to ask for r ≡ 1 (mod 25) rather than mod 5**, which lifts the twist to t = 25 and the intra term to 25r — a factor of five for no extra size. That is the whole content of the example:

| r | r − 1 | t | orb₃(r, t, 1) | n = 32 + r | min₃ | δ₃ |
|---|---|---|---|---|---|---|
| 11 | 1 mod 5 | 5 | 55 | 43 | 55 | 0.00446 |
| 41 | 1 mod 5 | 5 | 205 | 73 | 205 | 0.00330 |
| 71 | 1 mod 5 | 5 | 355 | 103 | 355 | 0.00201 |
| **101** | **1 mod 25** | **25** | **2525** | **133** | **2525** | **0.00659** |
| 131 | 1 mod 5 | 5 | 655 | 163 | 655 | 0.00092 |
| 151 | 1 mod 25 | 25 | 3775 | 183 | 3775 | 0.00376 |
| 251 | 1 mod 125 | 125 | 31375 | 283 | 4960 (capped) | 0.00133 |

The mod-5 rows decay steadily; **r = 101 jumps by a factor of four over its neighbours** purely on the arithmetic of 100 = 4·25. Going further to r ≡ 1 (mod 125) overshoots — at r = 251 the foreign block scores 31,375 but the 32-block's cap of 4960 now binds, and the extra 150 points of n have bought nothing. So the target is to **match the foreign block's intra term to the matching block's cap**, and r ≈ 199 would be ideal; 101 is the best prime below the crossover and gives the largest δ₃ in the family.

**Against the alternatives at n = 133.** A search over configurations with at most two matching and at most two foreign parts:

| configuration | min₃ |
|---|---|
| **32 + 101\*, q = 5, m = 5** | **2525** |
| 2 × 43 + 47\*, q = 23 | 1081 |
| 2 × 37 + 59\*, q = 29 | 888 |
| 7 × 19 fused, no foreign | 798 |
| 32 + 101\*, q = 5, no Galois | 992 |
| 32 + 101\*, q = 2 | 202 |

The near-balanced split 43 + 43 + 47 is second and loses by more than half. Worth noting that **133 has no balanced two-part split into prime powers at all** — the options are {2, 131}, {5, 128}, {8, 125}, {32, 101}, and of those {8, 125} is inadmissible (two matching blocks must share one p, but 8 is a 2-power and 125 a 5-power), {2, 131} dies on the size-2 block, and {5, 128} forces 5 to be the foreign block, worth 10.

> **Caveat, and it is a real difference from k = 2.** At k = 2 this kind of statement is backed by `mu_enumerate_v2.py`, which enumerates the whole shape space, plus `brute.py` as an independent check. **Here there is no such enumerator.** The comparison above is a search over a hand-specified family — at most two matching and at most two foreign parts, one top prime — and it relies on §4.1's claim that cross terms never bind, which is itself measured rather than proved. So "optimal" means *best in the family searched*, and the k = 3 census has no counterpart to the k = 2 completeness machinery. Building one is §9's first item.


### 6.3 The full-density blocks

By §3.1 the blocks c ∈ {5, 8, 32} are 3-homogeneous, so a single such block has orb₃ = C(c,3) and efficiency far above anything else available: at c = 32 with the Galois part, e ≈ 4.84 against a typical matching block's 1/2. **n = 32 attains β₃ = 4.84 outright**, against a class ceiling of 0.125.

This is the k = 3 analogue of S1's δ = 1 at k = 2 — with the difference that at k = 2 it holds at *every* prime power and is therefore not an escape at all but the main term, while at k = 3 Kantor's classification makes it a list of five degrees, only two of them non-degenerate. **A phenomenon that is generic at k = 2 becomes an escape at k = 3**, which is the sharpest single illustration of what changes between the two.

**Count: three values of n, plus whatever they contribute as blocks inside larger configurations.** As a whole-n shape it is finite; as a *block* it feeds §6.1, since c = 32 is both 3-homogeneous and the smallest Galois block.

### 6.4 The Fermat escape (S5)

Unchanged in mechanism from `aod` §4.3: putting the block swap in the top layer forces q = 2, so the matching twist survives intact but the foreign twist is the 2-part of r − 1, and η₃ is large only when r = 2^a·u + 1 with u small. That is O(log n) candidates per n, hence O(n/log n) values reached.

**What changes at k = 3 is the size of the prize**, by §5.6.4: the matching-side ratio S5 : S7 is 2^{v−1} at k = 2 but 2^v when 3 | c − 1, so the escape is worth one factor of two more on those blocks — and correspondingly the class where S7 wins for free narrows from c ≡ 3 (mod 4) to c ≡ 11 (mod 12).

### 6.5 What the escapes do not change

All three are thin — O(n/log n) or finite — so none of them moves the asymptotic picture of §3.2: β₃ is bounded by the class ceilings of §5.7 for almost all n, and δ₃ = β₃·6/n → 0 regardless. Their role is the same as at k = 2: they are why the ceiling table is a statement about *what the balanced family guarantees* rather than about what n can achieve, and they are where the largest computed values live.

## 7. What the k = 3 statement buys

The dimension-threshold reading survives even though the density does not:

> **Any nontrivial monotone 3-uniform property all of whose members have fewer than m\*₃(n) edges is fully evasive**, and m\*₃(n) = Ω(n²).

That rules out every sparse property — the same service BBKN's Ω(n log n) performs at k = 2, and the same reason it is worth having despite being o(C(n,k)). It is a different quantity from Black's weak evasiveness, which bounds queries without producing a threshold, so the two do not compete.

> **The constant follows from §5's allocation formula, up to which shape n admits.** m\*₃ ≈ n²/(Σ 1/√eᵢ)², so
>
> | n admits | best shape | m\*₃(n) ≈ | β₃ | conditional on |
> |---|---|---|---|---|
> | a prime power | S1 | **n²/κ₃**, and **C(n,3) at n ∈ {3, 4, 5, 8, 32}** (§3.1) | 1/κ₃ | nothing |
> | n = 2c, c a prime power | S2 at F = 2 | **n²/(2κ₃)** | 1/(2κ₃) | nothing |
> | n = c + r\*, r prime | S3 | **r·t/κ₃**, i.e. n^{1+θ} at best | per §5.7 | **the shifted-prime condition** (§4.4) |
>
> with κ₃ ∈ {1, 2, 3, 6} as in §2.3, and m ∈ {1, a} chosen per §4.3. **Only the first two rows are unconditional**, and both need n of a special multiplicative form, so they cover a density-zero set. For general n the bound is n^{1+θ}, and reaching Ω(n²) needs θ = 1 — the same endpoint as the k = 2 ceilings. The escapes of §6 exceed every row here where they apply, and are why the ceiling table is a statement about the balanced family rather than about n.
>
> **The arithmetic requirement is the k = 2 requirement, minus the term-type comparison.** What k = 3 removes is the choice of *which kind of term* binds: only intra terms do. It does **not** remove the allocation between parts, which by §5.7 has the same balance points as k = 2, nor the shifted-prime condition, which comes from Lemma B′ rather than from the pairing (§4.4). So general n still needs a foreign block with a large q-power divisor of r − 1, and `aod` §§3.5–3.6's supply analysis transfers essentially intact.

## 8. Adapting the proofs, part by part

| part of `enumeration-proof.md` | at k = 3 |
|---|---|
| **Part 0** (shape space) | **unchanged**; the picture proof's step 1 and step 2 are about chunks and blocks, not pairs |
| **Part A** (orbits and crosses) | **restructured**: a 3-set meets the chunks in a partition of 3, so there are *three* term types (3+0+0, 2+1+0, 1+1+1) rather than two — but by §4.1 only the first ever binds, so the min is over the 3+0+0 terms alone |
| **Part B, B′** (per-orbit classification) | **unchanged** — statements about blocks |
| **Part C** (valency recursion) | **needs redoing**: the counting bound B₀ is pair-specific; the analogue would bound μ₃ by a partition-only quantity, and the two-part reduction would need re-verifying |
| **Part D, D2** | D1's margin widens (F < F³ rather than F < F²). **D2 is a domination statement, not an exclusion** — fused outside blocks exist at k = 2 and are beaten by n^{3/2}/2 — so the k = 3 version should be stated that way from the start, with its bound re-derived from the k = 3 class structure |
| **Part E** (value formula) | **replace orb by orb₃(c, d, m)** and add the 1+1+1 cross term Fᵢcᵢ·Fⱼcⱼ·F_lc_l. The within-class cross term splits into sub-cases by how the 3-set distributes across the F blocks; these have not been worked out, and by §4.1 none of them binds |
| **Part E′, E″** (collapse) | **structure survives, but the fallback question gains a second axis** — Lemma C's strip, *and* the global-q coupling between per-block Galois gains (§5.8). The k = 2 SAFE cap does not transfer |
| **Part F** (search is bounded) | **easier**: orb₃ ≤ c(c−1)/κ₃ caps each part harder than C(c,2) does, so the feasibility criterion tightens; the constant has not been re-derived |
| **Part G** (nested towers) | **unchanged** |
| **`aod` §3** (ceilings) | **partly transfers.** The *term-type* comparison does not (§4.1) and neither do the δ constants (§3). The ceilings by residue class, the mod-24 classification and the balance points all do — recomputed as §§5.6–5.7, with β₃ = m\*₃/n² replacing δ |
| **`aod` §3.5–3.6** (supply) | **transfers intact.** Lemma B′ is k-independent, so a foreign block's twist is still a q-power divisor of r − 1 and the shifted-prime ladder still governs it (§4.4). The θ = 1 endpoint is still what Ω(n²) needs at general n. Nothing here needs re-deriving |
| **`aod` §4** (escapes) | **transfers with one addition** — §6. The Fermat escape survives with a larger prize (§6.4), the full-density blocks shrink from an infinite family to three (§6.3), and the **Galois escape is new** (§6.1) |
| **`aod` §6** (finite shape space) | **transfers with different constants**; the feasibility criterion needs re-deriving from orb₃ |

## 9. What this says about k = 2, read backwards

The exercise was partly a fresh-eyes pass, and four things about the k = 2 programme look different from here.

1. **The *constants* are contingent; the *optimisation* is not.** δ = 1/4 and the values in the mod-24 table exist because solvable 2-homogeneous groups happen to exist at every prime power — a fact about that classification, not about evasiveness, and at k = 3 the corresponding family is finite, just degrees 3, 4, 5, 8 and 32 (§3.1). But the allocation those constants come out of survives verbatim, balance points included (§5.7). `aod` §3 currently reads as though the optimisation is the heart of the method; it is more accurate to say the optimisation is what you get to do *once* 2-homogeneity has handed you a full-density block — and that it is the block, not the optimisation, that k = 3 takes away.
2. **Blocks of size 3^a are a k = 2 luxury.** They are penalised at k = 3 by a mechanism the k = 2 documents already contain in another guise — the additive subgroup structure that Lemma C's a > 1 case worries about, reappearing as §2.2.1's affine lines. That the same structure shows up as an *obstruction* one dimension up is a hint that it is load-bearing, and worth watching at k = 2 too.
3. **The Galois part is invisible at k = 2, and not for a deep reason.** J0a — whether the twist may act semilinearly — is an unresolved assumption in the k = 2 documents bearing on attainment. It is unresolved partly because it never *matters* there: §2.2.2 shows the minimum on 2-sets is unchanged by the Galois part at every block, because the fixed field 𝔽_p always contains a 2-subset. At k = 3 that fails exactly in characteristic 2, and the question acquires teeth. So J0a's dormancy at k = 2 is an accident of p ≥ k = 2, not evidence that the assumption is harmless in general — and if the k = 2 shape space were ever indexed by ΓL rather than GL twists, nothing would change, which is itself worth knowing.

4. **The arithmetic difficulty is not the price of chasing constant density.** It is tempting to think it is — drop the constant, and the number theory should get easier. It does not: §4.4 shows the shifted-prime condition survives at k = 3 in full force, because it comes from Lemma B′ rather than from the pairing. What k = 3 removes is the term-type comparison, not the supply question and not the allocation.

## 10. Open, if anyone takes this further

1. **Establish completeness of the census.** §4 re-analyses the k = 2 shape list; it does not show that list is exhaustive at k = 3. What a completeness argument would need: that Parts B, B′, D1, D2 still classify the admissible blocks (they are k-independent, so this should be routine), plus a k = 3 analogue of Part 0's step 3 — and, specifically, a bound ruling out configurations so unequal that a **cross** term binds after all, which §4.1's degree count makes unlikely but does not exclude at small n. Locating the crossover between the quadratic intra term and the cubic cross terms is the concrete first step. **Building a k = 3 enumerator** — the counterpart of `mu_enumerate_v2.py`, whose absence is why §6.2's "optimal" means only "best in the family searched" — is the other half of the same item.
2. **Prove the orbit law's stabiliser step** properly rather than modulo the routine argument in §2.1. (§2.2.2's criterion *is* proved necessary as well as sufficient; what remains untested there are the two clauses out of computational reach — the gain factor being the least prime divisor of a, first distinguishable at a = 25, and m < a never gaining, first distinguishable at a = 10.)
3. **Redo Part C** — the partition-only bound and its two-part reduction are the only genuinely pair-specific piece of the structural chain.
4. **Decide whether the threshold statement is new.** Black's framework does not produce dimension thresholds, and no other k ≥ 3 work found so far does; but the k = 2 literature is deep enough that a threshold statement may exist in some form.
5. **Finish rows 7, 15 and 23 of the ceiling table** (§5.7). They are decided at k = 2 by a tie that §5.6.4 disturbs, and the entries there are lower bounds rather than ceilings. This is contained work: run §5.6.3's c mod 24 analysis against each rung.
6. **Convert §6's escape counts** from representation counts to counts of n, as `aod` §4.3 does. They are currently order-of-magnitude.
7. **k ≥ 4.** The orbit law generalises (κ_k(d) = max{m ≤ k : m | d}), so the same analysis runs; the threshold degrades to Θ(n²) against C(n,k) throughout, and the shape ranking presumably inverts further.

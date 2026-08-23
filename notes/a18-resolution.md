# A18 resolved: Lemma D2 is false at F ≥ 3, and the shapes it missed never win

> # ⚠ ARCHIVED — resolution integrated; retained for its proof and witness
>
> **⟦ARCHIVED⟧ A18 is closed and no longer appears in `pending-checks.md`.** The five edit sites listed in §5 were carried out: Lemma D2's status, Theorem 3.1's "never fused" clause, the census rows for S9 and S10, and the enumerator comment all now read as this note prescribes. **The mathematics here — the n = 85 witness, the fused-outside domination theorem, and the Sylow-r cyclicity step its F < r branch consumes — is current and is the authority for those statements**; what is stale is only the note's framing as pending work.
>
> **Two figures have moved since.** The range check is against `mu_table_safe_v4.csv` (2,081 rows, worst ratio 0.83 at n = 56); v4 is now a **baseline** superseded by the rebuild, and 289 of its rows are known low — which affects the *margin* the check reports but not its direction, since a corrected B(n) only rises and the domination bound is unchanged. The n ≥ 1582 threshold rests on the ladder's unconditional δ ≥ 0.02516, which also stands.
>
> **Still open, and it is the reason to keep this note reachable:** the **r = q sub-case** of §4 — F ≥ 2 fused outside blocks with r = q — where both halves of the argument lose their footing and which is jointly load-bearing with the census's S10 row.

*Resolution note for item A18 of `pending-checks.md`. Verification code: `a18_verify.py`, which (i) constructs the witness group and computes its orbitals exhaustively, (ii) machine-checks its Oliver chain, and (iii) runs the domination bound against every row of `mu_table_safe_v4.csv`. All three passes are reproduced below. Status of each claim: the witness and the range check are **verified** (independent computation); the two-case bound is **proved here** and has had one reading.*

**Summary.** A18 asked whether Lemma D2's conclusion — an orbit of fused outside blocks always has a class of at most half its size, so outside blocks are never fused — survives the corrected shape space, where the block-permuting group need not have prime-power degree. The answer splits:

> - **Route 1 (show the 2-transitive permuter inadmissible) is closed, negatively.** An explicit Oliver group realises it. So **Lemma D2 is false for F ≥ 3**, the corrected shape space is missing shapes, and μ ≤ B_safe as currently argued has a hole — the same failure mode as the q-power block count, now confirmed rather than suspected.
> - **Route 2 (bound the classes another way) succeeds, with a different bound.** m\* ≤ |O|/2 is wrong; what is true is **m\* ≤ n·min(F, r)/2 ≤ n^{3/2}/2**, by a two-case argument whose F < r half runs through the cyclicity of the Sylow r-subgroup — a chain consequence the original proof never used.
> - **Route 3 (score them in range) passes.** Under a deliberately generous upper bound, **no fused-outside configuration reaches B(n) at any of the 2,081 tabulated values** (worst ratio 0.83, at n = 56), and the theorem takes over from n = 1582 given the ladder's lower bounds, covering everything to 10⁶ with overlap.

So the resolution has the E′/E″ shape: **the shapes exist and the census must say so, but they are dominated — by theorem above a (very low) threshold and by direct check below it — so no computed value of B(n) changes and μ ≤ B_safe is restored** once the domination theorem is added to the completeness argument. One sub-case remains genuinely open and is scoped at the end: **F ≥ 2 fused outside blocks with r = q**, where the top q-group can absorb r-structure and both halves of D2's proof lose their footing.

---

## 1. The witness: D2 is false

> **Witness.** n = 85. Take five blocks of size 17 with a **diagonal** translation τ (the same +1 on every block), a **diagonal** twist μ of order 16 (r − 1 = 16 = 2⁴, so the whole multiplicative group is a 2-group), and the block-permuting group **AGL(1, 5) = C₅ ⋊ C₄ acting on the block indices** — C₅ as a pure 5-cycle of blocks, C₄ as i ↦ 2i (mod 5).
>
> **The chain, machine-verified:** |Γ| = 5440 = 17·16·5·4; Γ₂ = 1 (trivial bottom, the p = 0 sentinel); Γ₁ = ⟨τ, c₅⟩ ≅ **C₈₅, cyclic and normal**; Γ/Γ₁ of order **64, a 2-group** (containing the twist C₁₆ and the block map C₄). Transitive on all 85 points — one chunk of five fused outside 17-blocks, q = 2, home prime absent.
>
> **The orbitals, computed exhaustively:** exactly three classes, of sizes **170 / 680 / 2720** (sum 3570 = C(85,2)):
> - **170 = C(5,2)·17** — the same-position pairs {(i,x),(j,x)}, one class because the permuter is 2-transitive on blocks and τ is transitive on positions;
> - **680 = 5·orb(17,16)** — the within-block pairs, fused across all five blocks;
> - **2720** — all cross-block pairs of nonzero offset, one class because the twist is the full multiplicative group.
>
> So **m\* = 170 = 2·|O|**, four times D2's claimed bound of |O|/2 = 42.5.

Where D2's proof breaks: its last step took the same-position class to be (F or F/2)·r, which is the block-pair orbital of a **cyclic or q-power** permuter. The corrected shape space allows the permuter to be a two-layer group — cyclic-by-q — and C₅ ⋊ C₄ is exactly that, with **block-pair orbital C(5,2) = 10** rather than ≤ 5. The diagonal-translation step of D2 is untouched (and is re-proved below from the chain, more robustly). Note also what survives: **at F = 2 the conclusion of D2 is true** — the same-position set has C(2,2) = 1 block pair, so its class has at most r = |O|/2 pairs — which is why worked case E of `enumeration-proof.md` and every F = 2 statement stand as written.

The witness family is not isolated: n = 5r works for every prime r ∉ {2, 5} (the twist needs only the 2-part of r − 1, always ≥ 2), and larger prime-power F with AGL(1, F) permuters work the same way. **The shape exists at a positive density of representations. It is excluded from winning, not from existing.**

## 2. The domination theorem

> **Theorem (fused-outside domination).** Let Γ satisfy Oliver's condition on n points with chain primes (p, q), and let O be an orbit consisting of F ≥ 2 blocks of outside prime size r, with **r ≠ q** (r ≠ p is the meaning of "outside"; the r = q case is §4). Then
>
> **m\*(Γ) ≤ n·min(F, r)/2 ≤ n^{3/2}/2.**
>
> Specifically: some class has at most **F·C(r,2)** pairs always, and when **F < r** some class has at most **C(F,2)·r** pairs.

*Proof.*

**(a) F ≥ r.** The block system is Γ-invariant, so a pair inside a block maps to a pair inside a block: the F·C(r,2) within-block pairs are a union of classes, and some class has at most F·C(r,2) = |O|(r−1)/2 ≤ n·r/2 pairs. This half needs nothing beyond the block system's existence.

**(b) F < r.** Three steps.

*Step 1: the Sylow r-subgroup of Γ|_O is C_r, consisting of the pure translation vectors.* The bottom layer is a p-group and the top a q-group, with r ∉ {p, q}, so every r-element of Γ maps into the cyclic layer, whose Sylow r-subgroup is cyclic; hence **Sylow-r of Γ, and of its quotient Γ|_O, is cyclic**. Now write a general element of Γ|_O as (i, x) ↦ (σi, aᵢx + tᵢ) with σ the block permutation and aᵢ, tᵢ the per-block affine parts (each block is affine by Lemma B). An r-element has σ of r-power order in Sym(F) with F < r, so **σ = 1**; and each multiplier aᵢ of r-power order dividing r − 1, so **aᵢ = 1**. So the r-elements are exactly the *pure translation vectors* — the subgroup T\* ≤ C_r^F of elements (i,x) ↦ (i, x + tᵢ). T\* is elementary abelian and sits inside a cyclic Sylow subgroup, so **T\* ≅ C_r, generated by one vector (t₁, …, t_F)**. Transitivity of Γ on O forces every tᵢ ≠ 0 (each block's induced group is transitive on r points, so its order is divisible by r, and its r-part comes from T\*'s i-th component); normalising each block's coordinate makes **T\* the diagonal C_r**. *(This re-proves D2's diagonal step from the chain alone, with no assumption on the permuter.)*

*Step 2: every element has a common multiplier, and coordinates exist making every translation part diagonal.* For g = (σ, (aᵢ), (tᵢ)) and the diagonal translation τ_s, the conjugate g τ_s g⁻¹ is the pure translation vector with components a_{σ⁻¹(j)}·s — which must lie in T\* = diagonal, so **all aᵢ are equal**: every element acts with one multiplier a and a vector of translations. For the translations: let W = Γ|_O · T_full where T_full = C_r^F is the full translation group of the coordinatised blocks, and set V = T_full/T\*, an 𝔽_r-module for Q = W/T_full ≅ Γ|_O/T\*. Since Sylow-r of Γ|_O is exactly T\*, **r ∤ |Q|**, so H¹(Q, V) = 0 and any two complements of V in W/T\* are conjugate by an element of V — i.e. by a translation vector, i.e. **by a change of per-block origins**. Γ|_O/T\* is one complement; the subgroup of elements with *diagonal* translation part is another; conjugating, we may choose coordinates in which **every element of Γ|_O acts as (i, x) ↦ (σi, ax + s)** with a single translation s across blocks.

*Step 3: the same-position class.* In those coordinates the set of pairs {(i,x),(j,x)}, i ≠ j — C(F,2)·r pairs — is Γ-invariant: block maps preserve equal positions, τ shifts both coordinates, the common multiplier scales both. It is a union of classes, so some class has at most **C(F,2)·r = |O|(F−1)/2 ≤ n·F/2** pairs. *(The witness shows this is tight: 170 = C(5,2)·17 exactly, and it is the minimum.)*

Finally min(F, r) ≤ √(Fr) ≤ √n gives the n^{3/2}/2 form. Adding other orbits to the configuration only adds classes and cannot raise the minimum, so the bound holds for any Oliver group *containing* such an orbit. ∎

**What Step 2 is for, and why the naive version fails.** Without it, "same-position" is coordinate-dependent: an element acting as (ax, ax + u) on two blocks merges the offset-zero class into offset-u, exactly as `parts_for`'s code comment feared without naming it. The splitting shows such elements can always be normalised away when F < r — the one place the chain (through Sylow-r cyclicity) does work the original proof never asked of it.

## 3. Why the shape never wins

**In range, checked directly.** For every one of the 2,081 rows of `mu_table_safe_v4.csv`, the maximum over all (F ≥ 2, r prime, Fr ≤ n) of the theorem's bound — min(F·C(r,2), and C(F,2)·r when F < r) — is **strictly below B(n)**. Worst ratio 0.8276 at n = 56 (F = 8, r = 7); no other value exceeds 0.77. Note the check is deliberately generous: it grants every configuration the largest class the bound permits (2-transitive permuter, single fused class per set) and still loses everywhere.

**Beyond range, by theorem.** The bound is ≤ n^{3/2}/2, so a fused-outside configuration is excluded from attaining the maximum wherever **δ(n)·C(n,2) > n^{3/2}/2, i.e. √n < δ(n)·(n − 1)** — and δ here may be any *construction* lower bound, which the fused-outside question cannot touch. With the ladder's unconditional δ ≥ 0.04621 on n ≤ 10⁶ (the completed corrected-scoring run), the condition holds uniformly for **n ≥ 471**; the table check covers n ≤ 2484 exactly, so the two overlap on [1582, 2484] and everything to 10⁶ is covered. Beyond 10⁶ the exclusion needs only **δ(n) > n^{−1/2}·(1 + o(1))** — a hypothesis polynomially weaker than every density statement the framework already runs on, and implied by any of them. This is the same epistemic shape as the collapse: theorem above a threshold, per-n verification below it, with the threshold here far more forgiving.

## 4. The residual sub-case: r = q

The theorem excludes r = q, and the exclusion is real, not cosmetic — **both** halves of the old argument lose their footing there, because the top q-group can absorb q-structure:

- Step 1's "r-elements are pure translations" **still holds** at r = q when F < q (σ needs an order-q element of Sym(F), impossible; the multiplier's order divides q − 1), but the Sylow-q subgroup is no longer forced cyclic — the top layer is a q-group — so T\* can have rank ≥ 2 and even D2's diagonal-translation step fails: independent per-block translations can live upstairs.
- Branch (a) survives untouched (it needs only the block system), so what is open is exactly **F < q copies of a q-block**, where the same-block bound F·C(q,2) can be as large as ~n²/4 at F = 2.
- The census's S10 (single outside block with r = q, killed by normality) is the argument to extend; it was proved at F = 1 and nothing yet covers F ≥ 2. Until it is, **S10's row and this sub-case are jointly load-bearing for completeness**, which is a promotion — S10 used to be a curiosity.

One structural fact to start from: at F < q the block-permuter image P ≤ Sym(F) has trivial q-part, so P is p-by-cyclic; that is still enough for 2-transitivity (AGL(1,5) is 5-by-cyclic), so the sub-case cannot be closed by ruling the permuter out, and will need either a normality argument in S10's style or its own class bound.

## 5. Consequences and edit sites

**No computed value changes.** B(n) is untouched at every tabulated n; the enumerator needs no new shape (the shapes never win, so excluding them from the search is harmless — but the *justification* for excluding them is now this theorem, not D2).

**What must change in the documents** (deliberately not edited here — Theorem 3.1 and the census are load-bearing and the wording deserves review):

1. **`enumeration-proof.md`, Lemma D2** (Part 0 inventory, Part D2, the lemma index): status from "proved" to **"false as stated at F ≥ 3; true at F = 2; replaced by the fused-outside domination theorem"**. The "proved, and more strongly than first conjectured — m\* ≤ n/2 outright" clause is the false one.
2. **Theorem 3.1** (both copies, DUP-tagged): "foreign — … and never fused" is false as a structural claim. Correct reading: foreign classes *may* be fused, but a configuration containing one is dominated and never extremal, so the enumeration over unfused-foreign configurations still computes B(n) — the theorem's *conclusion about μ* survives with the domination theorem added to its sources.
3. **The census, S9, both files**: "never exists (Lemma D2)" → **"exists (witness n = 85, m\* = 2|O|); never wins — dominated by theorem for n ≥ 1582 (given the ladder floor) and by direct check over all of v4; F = 2 still obeys m\* ≤ |O|/2"**. S-numbers append-only, so S9 keeps its number with a changed status — the first row ever to move from "killed" to "dominated", worth a sentence on the difference.
4. **S10's row**: promote from excluded-curiosity to load-bearing; add the F ≥ 2 extension as its open half.
5. **`orbital-evasiveness-notes.md`** §3 (Theorem 3.1's copy and the Lemma D2 line in §2.4) and the one-paragraph overview's "never fused".
6. **`mu_enumerate_v2.py`'s `parts_for` comment**: its domination sketch had the right instinct and the wrong class size ("~F·c/2" assumes the small permuter); point it at this theorem.
7. **`pending-checks.md` A18**: rewritten in this pass; T1's ledger gains another falsified compact step (the fourth), with the twist that this one was falsified *by construction* rather than by counterexample-in-the-literature.

**One new dependency to record:** the F < r branch consumes **Sylow-r cyclicity**, i.e. the chain's r ∉ {p, q} structure — a place the framework's proofs had never load-tested. And the beyond-10⁶ exclusion consumes a δ(n) ≫ n^{−1/2} floor, the weakest arithmetic input anywhere in the programme.

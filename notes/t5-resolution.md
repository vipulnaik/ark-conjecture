# T5 resolved: Lemma C is false, and the coupling that replaces it closes the gap at every a

*Resolution note for item T5 of `pending-checks.md`. Verification: `t5_verify.py` (eight checks — the a = 2 witness, the coupling's tightness and its negative control, the a = 1 boundary, and the range check — all passing). Status: the coupling theorem is **proved here** with one reading; the witnesses are **machine-verified**. For Vipul's review before integration, as with Lemma D2.*

**Summary.** T5 asked for Lemma C — a cyclic-layer twist on a p-characteristic part shares no prime with any outside block — at a > 1, where the proof's conjugation argument does not close because the top element may act through Galois. The answer, continuing this session's pattern:

> - **Route 1 (prove it) is closed, negatively, and more thoroughly than the item feared.** Lemma C is **false at a > 1** — an explicit Oliver group at n = 28 has a cyclic-layer twist of order 3 on a 5²-block beside a foreign 3-block — and its statement is **too strong even at a = 1**, where the share exists whenever the foreign part is untwisted (witness at n = 10). What the a = 1 proof actually established was "share ⟹ foreign twist trivial", not "no share".
> - **What is true is a coupling, and it is exactly what the failed proof's residue computes.** If r divides the cyclic-layer twist, then every multiplier induced on the foreign r-part lies in ⟨p mod r⟩, so the foreign twist order divides **ord_r(p), which divides a**. The coupling is tight — realised at (16, 5) with foreign twist 4 = ord₅(2) — and rigid: mispairing the Frobenius exponent with the multiplier fails to close as a group.
> - **The coupling dominates, which is what T5 actually needed.** A sharing configuration's foreign class is ≤ min(r·ord_r(p), C(r,2)) ≤ n·log₂n, strictly below B(n) at every v4 row (worst ratio 0.70, at n = 15) and a theorem for n ≥ 763 given the ladder floor. So `fb_common.py`'s condition (4) strip is **necessary among configurations scoring above n·log₂n — at every a, not only a = 1** — and the a > 1 scoping can be lifted, unblocking the B_refined = B_safe route, provided the necessity is stated as threshold-scoped rather than absolute.

---

## 1. The witnesses

**a = 2, twisted foreign part (the substantive falsification).** n = 28 = 25 + 3. Take 𝔽₂₅ with translations C₅² and 𝔽₃ beside it; one cyclic-layer element z acting as multiplication by ω (order 3) on 𝔽₂₅ **and** as +1 on 𝔽₃; one top element g acting as Frobenius x ↦ x⁵ on 𝔽₂₅ **and** as negation on 𝔽₃. Conjugation closes because both sides give g z g⁻¹ = z⁻¹: Frobenius sends ω to ω⁵ = ω⁻¹, negation inverts the translation. Machine-verified: |Γ| = 150, Γ₂ = C₅², Γ₁/Γ₂ ≅ C₃, Γ/Γ₁ ≅ C₂, both normal. The cyclic-layer twist has order 3; the foreign prime is 3; **gcd(d, r) = 3**.

**a = 1, untwisted foreign part (the boundary over-claim).** n = 10 = 7 + 3: z = (multiplication by 2 on 𝔽₇; +1 on 𝔽₃) generates with the 7-translations an Oliver group of order 21 with trivial top. The share exists at a *prime* block. The old proof is untouched — it needs a top element inducing a nontrivial foreign twist, and here there is none — but the lemma's unconditional statement was stronger than its proof even at a = 1.

**Where the old proof breaks at a = 2, seen in the witness.** Its load-bearing clause is "conjugation induces the identity on the twist". Here g conjugates the twist by Frobenius: ζ ↦ ζ⁵ ≡ ζ⁻¹, order 2 — the same order as the foreign multiplier, so the two projections of the layer's power map are consistent rather than contradictory. Exactly the gap the item named, realised.

## 2. The coupling theorem

> **Theorem (twist–foreign coupling).** Let Γ be an Oliver group with a p-characteristic part whose blocks have size c = p^a and whose cyclic-layer twist has order d, and a foreign part of prime size r (r ∉ {p, q}). If **r | d**, then every multiplier induced on the foreign part by Γ lies in **⟨p mod r⟩**; hence the foreign twist order t satisfies
>
> **t | ord_r(p), and ord_r(p) | a,**
>
> so the foreign part carries an intra class of at most **orb(r, t) ≤ min(r·ord_r(p), C(r,2)) ≤ r·a ≤ n·log₂n.**

*Proof.* The r-primary component C_{r^k} of the cyclic layer Γ₁/Γ₂ surjects onto the r-part of the twist on the matching part (r | d puts it there — the top is a q-group with q ≠ r, so a twist's r-part has nowhere else to live) and onto the foreign translations C_r (Part B puts them in Γ₁; they are r-elements with r ∉ {p, q}). Let z generate a preimage of that component: one element acting as a multiplier of order r^{k₁} ≥ r on the matching blocks and as a nontrivial translation on the foreign part.

Conjugation by any h ∈ Γ is an automorphism of the cyclic layer, hence a single power map z ↦ z^{m_h}. Project to each part:

- *Matching part:* h acts on a block through ΓL(1, c) composed with a possible block permutation. Multiplier components centralise the twist; translation components contribute commutators lying in Γ₂ (p-elements), which die in the layer; the Galois component sends ζ ↦ ζ^{p^{k_h}}. So **m_h ≡ p^{k_h} (mod r)** with k_h the Frobenius exponent of h's block action.
- *Foreign part:* conjugating the translation by h scales it by h's induced multiplier: **m_h ≡ mult_h (mod r)**.

Hence mult_h ≡ p^{k_h} (mod r) for every h. Elements of Γ₁ induce trivial multipliers on the foreign part — the D2q commutator: a cyclic-layer multiplier beside the C_r translations would put an r-element into [Γ₁, Γ₁] ⊆ Γ₂, a p-group — so the full multiplier group on the foreign part is the image of the top layer's, which the displayed congruence confines to ⟨p mod r⟩, a group of order ord_r(p). And ord_r(p) | a because r | d | p^a − 1. Finally orb(r, t) ≤ r·t ≤ r·ord_r(p), and r·ord_r(p) ≤ r·a ≤ n·log₂n since p^a + r ≤ n. ∎

**Remarks.** (i) At a = 1 the theorem reads t | 1: share forces an untwisted foreign part, which is precisely what the old proof proved. The old *statement* appended gcd(d, r) = 1, which the n = 10 witness refutes; the discrepancy went unnoticed because the proof was only ever run against twisted foreign parts. (ii) The coupling also runs backwards as a construction constraint, and the witnesses show it is exact: at (16, 5) the foreign twist 4 = ord₅(2) is realised, and pairing Frobenius exponent 2 with a multiplier of order 4 fails to close — the closure contains the pure matching twist and the pure foreign translation separately, so its Sylow-5 is C₅ × C₅ and no chain exists (q = 5 would make the foreign part r = q, dead by Lemma D2q). (iii) The proof's two working parts are both this session's tools: the single-power-map projection is the r ≠ q half of D2's Step 2, and the trivial-cyclic-layer-multiplier step is D2q's commutator.

## 3. Domination, and what T5's prize becomes

Any configuration containing a share carries a class of ≤ min(r·ord_r(p), C(r,2)):

- **In range:** the maximum of that bound over all (p, a, r) with p^a + r ≤ n stays strictly below B(n) at every one of the 2,081 v4 rows; worst ratio 0.7000, at n = 15.
- **By theorem:** the bound is ≤ n·log₂n, so sharing is excluded wherever δ(n)·C(n,2) > n·log₂n — from **n ≥ 763** at the ladder's δ ≥ 0.02516, overlapping the table, and beyond 10⁶ under δ(n) ≫ log n/n, the weakest hypothesis yet used anywhere.

**Consequence for condition (4).** The strip — capping a leftover p-characteristic part's twist at dmax with the foreign primes removed — is *not* a necessary condition on admissible configurations (the witnesses are admissible). It **is** necessary among configurations scoring above n·log₂n, because a configuration violating it contains a share and therefore a class below that line. Since the certificates evaluate candidates against thresholds of order δ·C(n,2) ≫ n·log₂n, threshold-necessity is the only necessity they ever needed — and it now holds **at every a**. Two changes follow: the a = 1 scoping on the strip can be lifted (with the justification re-attributed from "Lemma C" to "coupling + threshold"), and the a > 1 row of T5's residue table closes, which was the prerequisite for replacing B_safe by B_refined outright. The remaining fallback residue is exactly the q = 2 and large-e cases of the q-pinning analysis, now with no Lemma-C caveat attached.

**One nuance to carry into the code comment.** The threshold must be stated: a certificate hunting for configurations *below* n·log₂n (none does, but a future diagnostic might) could not use the strip. `validate_table.py`'s tripwire — no winner has a proper prime power c with a foreign prime dividing c − 1 — stays, and its reading improves: it is no longer guarding an unproved lemma but confirming a proved domination.

## 4. Edit sites (for the integration pass, after review)

1. **`enumeration-proof.md` Part D, opening box:** Lemma C's statement replaced by the coupling theorem with proof; the n = 28 and n = 10 witnesses; the pitfall box's warning ("must go through conjugation or domination, not cyclicity") is vindicated and can absorb the resolution — the repair went through *both*, conjugation supplying the coupling and domination finishing it. The "gap in the conjugation argument" box, the immunity discussion and the "what would close it" paragraph are superseded; the immunity *facts* (B_safe independent, winners fallback-free) survive with their reading unchanged.
2. **The lemma inventory and index rows** for C, and the two cross-references at Part B (foreign parts unaffected) and Part E′ (endpoints meeting).
3. **`fb_common.py` condition (4):** lift the a = 1 scoping; re-attribute the justification; state the n·log₂n threshold in the header's necessity argument. This changes verdicts on the 53,807 proper-prime-power branches T5 measured — rerun the certificate and confirm candidate lists stay empty.
4. **`pending-checks.md`:** T5 closes; T3's condition-(4) paragraph updates (the load-bearing condition now has a proved threshold-necessity rather than a scoped lemma); the residual-risk ranking loses its Lemma-C mentions; T1's ledger gains the seventh falsified compact step — with the note that this one's statement was falsified *at the case it was believed proved in*, the a = 1 over-claim having sat inside a correct proof's write-up.
5. **`t5_verify.py`** joins the static-check list (nothing in it is range-scoped except pass 4, which is cheap and can rerun with the table — recommend adding it to R1 alongside `a18_verify.py`, since both carry a range half that expires silently).

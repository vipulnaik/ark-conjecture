# Literature findings

*Resolved literature checks, for use when the note is shaped into a paper. Nothing here is a correction to the current documents — none of them has been edited on the strength of this. What this file is for is knowing, before we start writing, what is already in the literature and what is actually ours.*

**Bottom line.** The co-author's most serious concern is **confirmed, and more sharply than it was stated**. BBKN §5.1 does define exactly the max-min our §3 optimises, and Shparlinski (2014) has already isolated it as a named function f(n) and studied its lower bounds. Our §3 even and odd constructions are the k = 1 and k = 2 cases of a formula that has been in print since 2010. Two other findings cut in our favour and one is a straightforward correction we should make before a referee makes it for us.

---

## 1. BBKN Section 5 — confirmed, and the formula is already named

Source: STACS 2010 proceedings version, §5.1 (`drops.dagstuhl.de/storage/00lipics/lipics-vol005-stacs2010/LIPIcs.STACS.2010.2445/LIPIcs.STACS.2010.2445.pdf`), and Shparlinski 2014 §2.

BBKN §5.1 sets n = pk + r with p, r prime and q a prime divisor of r − 1, takes

> Γ = Γ(p, q, r) := Γ₀(p, Δ_k) × Γ(r, q)

and states as their equation (5.1)

> m\* = Ω(min{p²k, pkr, qr}).

Shparlinski then extracts this as a standalone object — his equation (1) and Lemma 5:

> f(n) = max over (k, p, q, r) ∈ W_n of min{p²k, pkr, qr}, where W_n is the set of quadruples with k ≥ 1 an integer, p, q, r prime, n = kp + r and r ≡ 1 (mod q).

He calls it "our main technical tool… obtained and used in [BBKN, Section 5]" and proves that any nontrivial monotone property with at most c·f(n) edges is eventually evasive.

**The correspondence with our framework is exact.** Reading their three terms against our two-class configuration (a fused class of F blocks of size c, plus one foreign prime r with twist t):

| BBKN / Shparlinski | ours | what it is |
|---|---|---|
| p²k | F·C(c, 2) with c = p, F = k | intra-orbital of the fused class |
| pkr | F·c·r | cross between the fused class and the foreign block |
| qr | orb(r, t) | intra-orbital of the foreign block |

So **our §3 even construction is k = 1 and our odd construction is k = 2** in their framework. The co-author's reading is right, and §3 is a parameter choice inside a published family, not a new construction.

**Where we are nonetheless strictly larger, and this matters.** B(n) is not f(n). Four differences, all in the direction of B(n) ≥ f(n), several of them strict:

- **They require p prime; we allow c a prime power.** Their Γ₀(p^α, Δ_k) in §4.1 does allow α > 1, but §5 instantiates at α = 1 throughout.
- **They require q prime with r ≡ 1 (mod q), giving an orbital of order qr.** We allow the twist t to be any prime *power* divisor of r − 1, and our `orb(r, t)` is rt or rt/2 depending on parity. On a foreign block with r − 1 = 2q^e this is a factor of q^{e−1} larger than theirs.
- **They always require a foreign part.** W_n is empty of the configurations n = F·c with no foreign block at all — which are **39% of our computed table** and every value with δ > 1/4. On those n, f(n) as defined does not see the winner.
- **They never claim f(n) is the maximum over all Oliver groups.** It is a lower bound from one family. Our Theorem 2.3 plus the enumeration claims B(n) is the *exact* maximum, which is a different kind of statement and is the part neither paper attempts.

**And they never study f(n) at fixed n.** Both papers only ever bound f(n) asymptotically by instantiating at a chosen scale — BBKN at p = Θ(n^{1/4}), q = Θ(n^{1/4−ε}) under ERH and p = Θ(n^{1/2}), q = Θ(n^{1/2−δ}) under Chowla; Shparlinski at p, q ∈ [n^{1/4−ε}, 2n^{1/4−ε}]. Nobody computes f(n) exactly, tabulates it, locates its balance point, or asks for its minimum over a range. The density δ(n) = μ(n)/C(n,2), the residue-class caps, and the global floor are all questions about f(n) (or rather about B(n)) that the literature has not posed.

**Framing consequence, for us to decide.** The honest positioning is that §3 recovers a known family and the contribution is (i) the exact determination of the maximum over *all* Oliver groups rather than a lower bound from one family, and (ii) the arithmetic of that maximum at fixed n. If we present §3 as a new construction a referee who knows Shparlinski will stop reading. Worth deciding early whether the paper is "the exact value of BBKN's f(n), corrected upward and computed" — which is defensible and interesting — or something else.

## 2. Shparlinski 2014 — our §5 comparison is against a superseded baseline, but the γ-ladder reframing is exactly right

Source: `arxiv.org/pdf/1304.0188`; published as *Theoret. Comput. Sci.* 547 (2014), 117–121.

What he proves, with quantifiers, since this is where the comparison has to be careful:

| result | quantifier | edge bound | assumption |
|---|---|---|---|
| BBKN Thm 1.4(c) | all large n | c·n log n | none |
| **Shparlinski Thm 1** | **all large n** | **n^{5/4+o(1)}** | **none** (Bombieri–Vinogradov) |
| BBKN Thm 1.4(b) | all large n | n^{5/4−ε} | ERH |
| BBKN Thm 1.4(a) | all large n | n^{3/2−ε} | Chowla |
| Shparlinski Cor. 3 | all but O(x^{0.354}(log x)⁴) n ≤ x | c·n^{1.677} | none (Baker–Harman) |
| Shparlinski Cor. 4 | all but O((log x)⁴) n ≤ x | c·n^{3/2} | none |
| Shparlinski §5 remark | all large n | n^{3/2} | Elliott–Halberstam |

Three things follow.

**Our §5 comparison against the 2010 ERH baseline is stale.** Shparlinski's Theorem 1 gets n^{5/4+o(1)} for all large n *unconditionally*, matching BBKN's ERH result without ERH. Any sentence of ours comparing to "the ERH bound n^{5/4−ε}" is comparing to something that no longer needs ERH.

**The two-quantifier-column point survives and is worth keeping.** Shparlinski's stronger exponents (1.677 and 3/2) both carry exceptional sets. On the *all large n* row the unconditional state of the art is 5/4, so a result of ours that holds for all large n is not undercut by the 1.677 figure. The comparison table in the paper needs a quantifier column or it will mislead in our favour, which is worse than misleading against us.

**The whole picture is one parameter, and the ceiling is a level-of-distribution barrier.** Writing θ for the guaranteed size of a prime factor of r − 1, the route delivers n^{1+θ}: Bombieri–Vinogradov θ = 1/4 gives 5/4 for all large n, Chowla-type θ = 1/2 gives 3/2, Baker–Harman θ = 0.677 with positive relative density gives 1.677 for almost all n, and Elliott–Halberstam θ → 1 gives n^{2−o(1)}. Our (H) is the θ = 1 endpoint. Unlike Chowla's 1/2 — the value of a *conjecture* — Baker–Harman's is the current output of a *method*, resting on Brun–Titchmarsh on average, i.e. on primes in progressions to moduli past x^{1/2}. The exponent moves whenever that control does: **Runbo Li (arXiv:2508.18285, 2025) has raised it to 0.679** via Maynard's triple-convolution estimates, in the lineage that took Bombieri–Friedlander–Iwaniec's x^{29/56} to Maynard's x^{11/21} and Lichtman's x^{17/32}. **Cite 0.679, not 0.677.**

**The γ = 1 endpoint reframing is precisely locatable.** Shparlinski's Theorem 2 is parameterised by α, defined by the density of primes r with P(r − 1) > r^α, where P is the largest prime divisor. Baker–Harman gives α = 0.677 unconditionally, now 0.679 (Li 2025); he notes "the standard heuristic suggests that the condition of Theorem 2 holds with any α < 1", and that Elliott–Halberstam gives any α < 1. Our hypothesis (H) is effectively the **γ = α = 1 endpoint** of that ladder. Presenting (H) that way says something informative about its cost — it is the limit of a parameterised family whose current unconditional value is 0.677 — rather than asserting a barrier.

*One technical mismatch to be careful about.* Shparlinski's α concerns the largest **prime** divisor P(r − 1). Our efficiency η is built from the largest prime **power** divisor of the odd part of r − 1, together with the 2-part. These are not the same quantity and the ladder does not transfer verbatim. Worth checking whether his Theorem 2 goes through with the prime-power version before we claim to be its endpoint.

## 3. Rivest–Vuillemin — the constant is now n²/3, and our floor is well below it

The chain, from BBKN's own history section plus follow-ups:

- Rivest–Vuillemin (1976): n²/16
- Kleitman–Kwiatkowski (1980): n²/9
- Kahn–Saks–Sturtevant (1984), as a by-product: n²/4
- Korneffel–Triesch, *Combinatorica* 30(6) (2010), 735–743: an improved constant
- **Scheidweiler–Triesch, SIAM J. Discrete Math. 27(1) (2013), 257–265: n²/3 − o(n²), the current best**

So the co-author's point is right and stronger than stated: it is not merely that Ω(n²) is known, but that the best *unconditional* constant is **1/3**. Our global density floor is 0.026117, i.e. about 0.013n² — a factor of 25 below the known weak bound.

**This is not a defect in our result, but it is a defect in how §5 currently reads.** The two statements are different in kind. Scheidweiler–Triesch lower-bound D(P) for *every* nontrivial monotone property; our m\* ≥ δ·C(n,2) gives **full evasiveness** — exactly C(n,2) queries — for properties of dimension below m\*. A weak bound on all properties and an exact result on a restricted class are incomparable. But §5 does not currently say so, and a referee will read any Θ(n²) framing as competing with n²/3 and losing. Fix it before submission; cite Scheidweiler–Triesch and Korneffel–Triesch in the same block.

## 4. Black's spacing — narrower group class, weaker conclusion, so probably no conflict

Timothy Black, *Monotone Properties of k-Uniform Hypergraphs Are Weakly Evasive*, ITCS 2015 / ACM Trans. Comput. Theory (2019), doi 10.1145/3313908; UChicago dissertation 2019.

He formalises "orbit augmentation sequences" of sets with group actions and shows that a parameter called the **spacing** lower-bounds decision-tree complexity for any nontrivial monotone Γ-invariant property — **assuming all the groups involved are p-groups**, and concluding *weak* evasiveness (Ω(n)).

Two structural differences from m\*(Γ), both of which suggest the parameters are incomparable rather than one subsuming the other:

- **Group class.** Spacing requires p-groups throughout; Oliver groups (p-group ⊳ cyclic ⊳ q-group) are strictly more general, and every winner in our table with a foreign block is outside the p-group case.
- **Conclusion.** Spacing gives weak evasiveness; m\* gives a *dimension threshold below which a property is fully evasive*.

So the co-author's guess that "he restricts to p-groups where Oliver groups are more general, which would be a point in our favour" looks right, but **this is the one item I could not settle from abstracts alone** — the actual definition of spacing is in the paper body and I have not read it. If spacing turns out to be a genuine generalisation of m\* restricted to p-groups, that is worth knowing; it would make our Theorem 2.3 the Oliver-group analogue of his framework and give a natural way to cite him.

## 5. The Θ(n²) / Hardy–Littlewood reframing — searched for, not found

*Searched because "should be Θ(n²) but we can't prove it" is exactly the kind of remark that lives in seminar folklore and survey asides without being written down, and finding it after posting would be worse than finding it now.*

**Sources checked and ruled out:**

- **Lovász–Young, *Lecture Notes on Evasiveness of Graph Properties*.** Ruled out on dates: the notes are from Lovász's Princeton course in **autumn 1990**, posted to arXiv in 2002 with no updating. They predate BBKN by twenty years and cannot contain a remark about a function BBKN introduced.
- **Kulkarni, *Evasiveness Through A Circuit Lens*, ITCS 2013.** A different direction entirely — it studies "weak-EC", the assertion that every nontrivial monotone transitive Boolean function has D(f) ≥ n^{1−ε}, plus a parity-decision-tree analogue. It cites BBKN but does not revisit f(n).
- **Shparlinski 2014, §5 "Comments".** The natural place for such a remark, and he does discuss limits — but only about *which conjecture is needed for which exponent* (Elliott–Halberstam gives 3/2; Chowla applies to individual progressions and so may be harder than E–H). Nothing about a true order of growth, and nothing about a constant.
- **BBKN itself.** §2.4 says only that "the attempt to combine these leads to hard problems on the distribution of prime numbers" and that "the novelty is in finding the right Γ" — an acknowledgement that the number theory is hard, not a statement about what the truth is.
- **Csernák 2024** (*J. Graph Theory*, elusive properties of infinite graphs) cites the whole chain but is about a different setting.
- **Direct searches** combining evasiveness / m\* / u-orbitals / Oliver groups with Hardy–Littlewood, Bateman–Horn, singular series, and Θ(n²): no hits connecting them.

**Conclusion.** No trace of the reframing anywhere I can reach. This is consistent with Raghav not remembering it, and it has a structural explanation worth putting in the note: BBKN and Shparlinski both work with **existence-of-one-prime** tools — Linnik, Chowla, Heath-Brown's L ≤ 5.5, Bombieri–Vinogradov, Balog–Sárközy. Every one of those answers "is there a prime in this progression below this bound?" That toolkit cannot produce a Θ statement, because it never counts solutions. Getting to a predicted order of growth needs the shift from *existence at a chosen scale* to *density of representations at fixed n*, and once that shift is made Hardy–Littlewood is the obvious frame. Their question was "how large an exponent can I prove"; ours is "what is the true value". Different questions, different machinery — which is a better and less contentious way to describe the gap than claiming anyone overlooked something.

*Caveat on negative searches.* This rules out the four most likely written sources. It cannot rule out a remark in a talk, a referee report, or an unpublished note. Given arXiv-only, the right posture is to present the heuristic as the natural reading of the data rather than as a new observation, which costs nothing and is robust to someone saying "we knew that".

## 6. Incidental find: Angel–Borja, and it may matter for §8

*Not one of the four checks; it surfaced during them and looks directly relevant to the small-degree work.*

**Andrés Angel and Jerson Borja, "The Evasiveness Conjecture and Graphs on 2p Vertices"** (arXiv:1603.04412). From the abstract: they study the size of the automorphism group of a graph on 2p vertices to estimate the Euler characteristic of monotone non-evasive graph properties; they **work through Oliver groups**, give **lower bounds for the dimension** of the simplicial complex associated to a nontrivial monotone non-evasive property, and **apply the results to graphs on ten vertices** to get conditions on potential counterexamples in the n = 10 case.

That is our §8 territory almost exactly — the same n, the same tool, the same target. I have not read past the abstract, so I do not know whether their conditions are weaker, stronger, or orthogonal to the ones from our SAT/χ machinery. But it should be read before any n = 10 claim is written down, and it is not currently in our reference list.

## 7. Erdős covering congruences vs the 2-power escape

Not resolved this pass. This one is a mathematical check rather than a framing question and belongs with the open items, not here. The claim to verify is that covering congruences give a *positive density* of odd n with no 2^k + p representation — which would close the 2-power escape route of §3.3 rather than merely thin it to O(log n) values.

---

## What remains

0. **Read Angel–Borja** (item 6), before writing anything about n = 10. Same degree, same tool, same target; unknown overlap.
1. **Read Black's spacing definition** (item 4). The only one of the original four where I could not get past the abstract.
2. **Check whether Shparlinski's Theorem 2 survives the prime-power version of α** (item 2). If it does, "the γ = 1 endpoint" is a clean and accurate framing for (H); if not, we need a different way to say it.
3. **Read Scheidweiler–Triesch and Korneffel–Triesch properly** (item 3). I have n²/3 secondhand; the primary source should be checked before it goes in a comparison table.
4. **Decide the framing** (item 1). Not a literature question any more — the literature is now clear. It is a decision about what the paper claims, and it should be made before more writing happens, because it determines whether §3 is a contribution or a recap.

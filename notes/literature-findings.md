# Literature findings

*Resolved literature checks, for use when the note is shaped into a paper. Nothing here is a correction to the current documents — none of them has been edited on the strength of this. What this file is for is knowing, before we start writing, what is already in the literature and what is actually ours.*

**Bottom line.** The co-author's most serious concern is **confirmed, and more sharply than it was stated**. BBKN §5.1 does define exactly the max-min our §3 of `arithmetic-of-density.md` optimises, and Shparlinski (2014) has already isolated it as a named function f(n) and studied its lower bounds. `aod` §3's even and odd constructions are the k = 1 and k = 2 cases of a formula that has been in print since 2010. Two other findings cut in our favour and one is a straightforward correction we should make before a referee makes it for us.


> **Reference convention — read this before any § in this file.** Bare section numbers here are ambiguous by accident of how the file grew, and three different documents are being cited with the same notation:
>
> - **§§3, 4, 5, 6 (and their subsections) are `arithmetic-of-density.md`.** These are the great majority.
> - **§§8, 9 and their subsections are `orbital-evasiveness-notes.md`** — the small-degree and structural-criterion material.
> - **§2.4 is `orbital-evasiveness-notes.md`**; Parts lettered A–J are `enumeration-proof.md`.
> - **Where a § belongs to a cited paper it is always named first** — "BBKN §5.1", "Shparlinski §5", "their §4.3". A bare §5.1 is ours, i.e. `arithmetic-of-density.md`.
>
> The collision to watch is **§5.1**, which is both BBKN's construction section and our branch-and-bound section, and they appear within a few lines of each other in item 1.
>
> **Every reference to one of our documents in this file carries an explicit prefix** — `` `aod` §3.3 ``, `` `notes` §9.7 ``, `` `ep` Part E `` — and `check_doc_figures.py --pass refs` resolves exactly those, ignoring bare §s as belonging to cited papers. So a mistyped reference to our own work is caught here; a mistyped reference to someone else's is not, and cannot be.

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

So **`aod` §3's even construction is k = 1 and its odd construction is k = 2** in their framework. The co-author's reading is right, and `aod` §3 is a parameter choice inside a published family, not a new construction.

**Where we are nonetheless strictly larger, and this matters.** B(n) is not f(n). Four differences, all in the direction of B(n) ≥ f(n), several of them strict:

- **They require p prime; we allow c a prime power.** Their Γ₀(p^α, Δ_k) in BBKN §4.3 does allow α > 1, but BBKN §5 instantiates at α = 1 throughout.
- **They require q prime with r ≡ 1 (mod q), giving an orbital of order qr.** We allow the twist t to be any prime *power* divisor of r − 1, and our `orb(r, t)` is rt or rt/2 depending on parity. On a foreign block with r − 1 = 2q^e this is a factor of q^{e−1} larger than theirs.
- **They always require a foreign part.** W_n is empty of the configurations n = F·c with no foreign block at all — which are **39% of our computed table** and every value with δ > 1/4. On those n, f(n) as defined does not see the winner.
- **They never claim f(n) is the maximum over all Oliver groups.** It is a lower bound from one family. Our Theorem 2.3 plus the enumeration claims B(n) is the *exact* maximum, which is a different kind of statement and is the part neither paper attempts.

**And they never study f(n) at fixed n.** Both papers only ever bound f(n) asymptotically by instantiating at a chosen scale — BBKN at p = Θ(n^{1/4}), q = Θ(n^{1/4−ε}) under ERH and p = Θ(n^{1/2}), q = Θ(n^{1/2−δ}) under Chowla; Shparlinski at p, q ∈ [n^{1/4−ε}, 2n^{1/4−ε}]. Nobody computes f(n) exactly, tabulates it, locates its balance point, or asks for its minimum over a range. The density δ(n) = μ(n)/C(n,2), the residue-class caps, and the global floor are all questions about f(n) (or rather about B(n)) that the literature has not posed.

**Framing consequence, for us to decide.** The honest positioning is that `aod` §3 recovers a known family and the contribution is (i) the exact determination of the maximum over *all* Oliver groups rather than a lower bound from one family, and (ii) the arithmetic of that maximum at fixed n. If we present `aod` §3 as a new construction a referee who knows Shparlinski will stop reading. Worth deciding early whether the paper is "the exact value of BBKN's f(n), corrected upward and computed" — which is defensible and interesting — or something else.

## 2. Shparlinski 2014 — `aod` §5's comparison is against a superseded baseline, but the γ-ladder reframing is exactly right

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

**`aod` §5's comparison against the 2010 ERH baseline is stale.** Shparlinski's Theorem 1 gets n^{5/4+o(1)} for all large n *unconditionally*, matching BBKN's ERH result without ERH. Any sentence of ours comparing to "the ERH bound n^{5/4−ε}" is comparing to something that no longer needs ERH.

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

**This is not a defect in our result, but it is a defect in how `aod` §5 currently reads.** The two statements are different in kind. Scheidweiler–Triesch lower-bound D(P) for *every* nontrivial monotone property; our m\* ≥ δ·C(n,2) gives **full evasiveness** — exactly C(n,2) queries — for properties of dimension below m\*. A weak bound on all properties and an exact result on a restricted class are incomparable. But `aod` §5 does not currently say so, and a referee will read any Θ(n²) framing as competing with n²/3 and losing. Fix it before submission; cite Scheidweiler–Triesch and Korneffel–Triesch in the same block.

## 4. Black's spacing — the framework subsumes a route we later re-derived; now the key comparison, not a side check

Timothy Black, *Monotone Properties of k-Uniform Hypergraphs Are Weakly Evasive*, ITCS 2015 / ACM Trans. Comput. Theory (2019), doi 10.1145/3313908; UChicago dissertation 2019. Building on Kulkarni–Qiao–Sun for 3-graphs.

He formalises **orbit augmentation sequences** of sets with group actions and shows that a parameter called the **spacing** lower-bounds decision-tree complexity for any nontrivial monotone Γ-invariant property — **assuming all the groups involved are p-groups** — concluding *weak* evasiveness, Ω(n). He notes the argument is elementary and self-contained modulo basic group theory, unlike the KSS topological route plus heavy number theory that KQS used for 3-graphs.

Two structural differences from m\*(Γ), which still look like incomparability rather than subsumption:

- **Group class.** Spacing requires p-groups throughout; Oliver groups (p-group ⊳ cyclic ⊳ q-group) are strictly more general, and every winner in our table with a foreign block is outside the p-group case.
- **Conclusion.** Spacing gives weak evasiveness; m\* gives a *dimension threshold below which a property is fully evasive*.

> **This item was left unread for three passes and that had a cost — see item 17.** A sub-board/Fourier-degree route was derived from scratch, presented as promising, and only pinned down after a challenge exposed that it needs a p-group hypothesis — which is exactly the hypothesis Black's theorem states. **An unread item on a reading list is a live hazard, not a deferred task:** it does not merely delay a finding, it allows work to be done twice and claimed once.

**The question that replaces "read it": does our group data give better spacing at composite non-prime-power n than the sequences already in the literature?** Black's target is the asymptotic regime, Ω(n) out of C(n,2). Ours is constants near C(n,2) at specific n, which is what the whole δ apparatus exists for and which his framework does not chase. Those are different objectives over the same machinery, so the comparison is concrete: compute spacing for the orbit augmentation sequences our batteries supply and see whether it beats the standard constructions at the n we care about.

## 4a. Item 17 below supersedes the framing of this item

## 5. The Θ(n²) / Hardy–Littlewood reframing — searched for, not found

*Searched because "should be Θ(n²) but we can't prove it" is exactly the kind of remark that lives in seminar folklore and survey asides without being written down, and finding it after posting would be worse than finding it now.*

**Sources checked and ruled out:**

- **Lovász–Young, *Lecture Notes on Evasiveness of Graph Properties*.** Ruled out on dates: the notes are from Lovász's Princeton course in **autumn 1990**, posted to arXiv in 2002 with no updating. They predate BBKN by twenty years and cannot contain a remark about a function BBKN introduced.
- **Kulkarni, *Evasiveness Through A Circuit Lens*, ITCS 2013.** A different direction entirely — it studies "weak-EC", the assertion that every nontrivial monotone transitive Boolean function has D(f) ≥ n^{1−ε}, plus a parity-decision-tree analogue. It cites BBKN but does not revisit f(n).
- **Shparlinski 2014, §5 "Comments".** The natural place for such a remark, and he does discuss limits — but only about *which conjecture is needed for which exponent* (Elliott–Halberstam gives 3/2; Chowla applies to individual progressions and so may be harder than E–H). Nothing about a true order of growth, and nothing about a constant.
- **BBKN itself.** BBKN §2.4 says only that "the attempt to combine these leads to hard problems on the distribution of prime numbers" and that "the novelty is in finding the right Γ" — an acknowledgement that the number theory is hard, not a statement about what the truth is.
- **Csernák 2024** (*J. Graph Theory*, elusive properties of infinite graphs) cites the whole chain but is about a different setting.
- **Direct searches** combining evasiveness / m\* / u-orbitals / Oliver groups with Hardy–Littlewood, Bateman–Horn, singular series, and Θ(n²): no hits connecting them.

**Conclusion.** No trace of the reframing anywhere I can reach. This is consistent with Raghav not remembering it, and it has a structural explanation worth putting in the note: BBKN and Shparlinski both work with **existence-of-one-prime** tools — Linnik, Chowla, Heath-Brown's L ≤ 5.5, Bombieri–Vinogradov, Balog–Sárközy. Every one of those answers "is there a prime in this progression below this bound?" That toolkit cannot produce a Θ statement, because it never counts solutions. Getting to a predicted order of growth needs the shift from *existence at a chosen scale* to *density of representations at fixed n*, and once that shift is made Hardy–Littlewood is the obvious frame. Their question was "how large an exponent can I prove"; ours is "what is the true value". Different questions, different machinery — which is a better and less contentious way to describe the gap than claiming anyone overlooked something.

*Caveat on negative searches.* This rules out the four most likely written sources. It cannot rule out a remark in a talk, a referee report, or an unpublished note. Given arXiv-only, the right posture is to present the heuristic as the natural reading of the data rather than as a new observation, which costs nothing and is robust to someone saying "we knew that".

## 6. Incidental find: Angel–Borja, and it may matter for `notes` §8

*Not one of the four checks; it surfaced during them and looks directly relevant to the small-degree work.*

**Andrés Angel and Jerson Borja, "The Evasiveness Conjecture and Graphs on 2p Vertices"** (arXiv:1603.04412). From the abstract: they study the size of the automorphism group of a graph on 2p vertices to estimate the Euler characteristic of monotone non-evasive graph properties; they **work through Oliver groups**, give **lower bounds for the dimension** of the simplicial complex associated to a nontrivial monotone non-evasive property, and **apply the results to graphs on ten vertices** to get conditions on potential counterexamples in the n = 10 case.

That is `notes` §8 territory almost exactly — the same n, the same tool, the same target. I have not read past the abstract, so I do not know whether their conditions are weaker, stronger, or orthogonal to the ones from our SAT/χ machinery. But it should be read before any n = 10 claim is written down, and it is not currently in our reference list.

## 7. Erdős covering congruences vs the 2-power escape

**Resolved in the third pass below (item 9): yes.** Erdős (1950) constructed an infinite arithmetic progression of odd integers with no p + 2^k representation, and van der Corput proved independently the same year that the non-representable odd integers have positive lower density. So the 2-power escape route of `aod` §3.3 is closed on a positive-density set rather than thinned to O(log n) values. The companion positive result is Romanov (1934): a positive lower density of integers *are* of the form p + g^k, for any fixed g ≥ 2.

---

## What remains

0. **Read Angel–Borja** (item 6), before writing anything about n = 10. Same degree, same tool, same target; unknown overlap.
1. ~~**Read Black's spacing definition** (item 4).~~ **Superseded by items 4 and 17.** The framework is now identified; what replaces "read it" is a specific comparison — does our group data give better *spacing* at composite non-prime-power n than the sequences already in the literature? *(Items 2 and 3 below are resolved — see the second pass; item 4's other actions live in `pending-checks.md` T4.)*
2. **Check whether Shparlinski's Theorem 2 survives the prime-power version of α** (item 2). If it does, "the γ = 1 endpoint" is a clean and accurate framing for (H); if not, we need a different way to say it.
3. **Read Scheidweiler–Triesch and Korneffel–Triesch properly** (item 3). I have n²/3 secondhand; the primary source should be checked before it goes in a comparison table.
4. **Decide the framing** (item 1). Not a literature question any more — the literature is now clear. It is a decision about what the paper claims, and it should be made before more writing happens, because it determines whether `aod` §3 is a contribution or a recap.

---

# Second pass (2026-08): three of the four T4 items read

*Angel–Borja was read in full; the Triesch lineage and Black's spacing definition were settled from abstracts and citing papers. The Shparlinski prime-power question is the one still needing the paper itself. As before, nothing here has been folded into the primary documents — these are notes for the judgement calls.*

## 5. Angel–Borja, arXiv:1603.04412 — read in full; complementary, not overlapping

*"The Evasiveness Conjecture and Graphs on 2p Vertices", Andrés Angel and Jerson Borja, 2016.*

**Their method is a different use of the same tool.** They compute χ(P) = Σ_{[G] ⊆ P} (−1)^{m_G−1}·|[G]| over *isomorphism classes*, and look for a common divisor of the class sizes |[G]| = n!/|Aut(G)|. If p divides every |[G]| then p | χ(P) so χ(P) ≠ 1 and P is evasive. Their §3 classifies the graphs on 2p vertices with p ∤ |[G]|: they are exactly G₁ ∪ G₂ or G₁ + G₂ with each Gᵢ on p vertices of the circulant form C(s₁,…,s_l) (Lemma 3.3). Oliver groups enter only to force *membership* of specific graphs, which is then fed into that counting argument.

**So the two frameworks use Oliver groups for different purposes.** We extract a *size* — m\*(Γ) large means sparse properties are evasive. They extract *named members* — "P contains a perfect matching", "P contains 2C_p or K_{p,p}" — and combine those with the mod-p class count. Neither subsumes the other, and the overlap in machinery is Oliver's theorem and nothing else.

**Their Proposition 4.5 is our Theorem 2.1 with the twist deleted.** Their group at n = 2p is Γ = ⟨α, β, γ⟩ with α the p transpositions, β and γ the two independent p-cycles — i.e. (C_p × C_p) ⋊ C₂, Oliver with a *trivial top* layer. Its orbitals are K_{p,p} of size p² together with (p−1)/2 classes C(t) ∪ C(t′) of size 2p each, so **m\* = 2p**. Our Theorem 2.1 uses the same bottom and swap plus the **diagonal multiplicative twist** C_{p−1}, which fuses those (p−1)/2 classes into a single orbital of size p(p−1), giving **m\* = p(p−1) = μ(2p)**. At p = 5: theirs is {25, 10, 10}, ours is {25, 20}.

> So on the size axis we are strictly stronger — P must contain a graph with ≥ p(p−1) edges, not ≥ 2p. But their weaker group buys something we do not get: because its orbits are *named* graphs (2C_p and K_{p,p}), the transversal condition yields a qualitative membership statement. Fusing the classes destroys exactly that. **This is a real trade-off and worth stating in `notes` §9.7:** a larger m\* comes from merging orbitals, and merged orbitals are less informative about *which* graphs are in P.

**One exploitation of Oliver's theorem that we do not make.** Their Corollary 4.6 gets **dim P ≥ 4p − 1** by observing that at a trivial-top Oliver group χ(P^Γ) = 1 *exactly*, so P^Γ cannot be a single point — it must contain a face, i.e. P contains a **union of two orbitals**. We use χ(Δ_P^Γ) ≠ 0 to get non-voidness (`notes` §7.2's bottom box) and stop there. Their step is strictly more: from χ = 1 and ≥ 2 vertices in the fixed complex, a higher-dimensional face is forced. `notes` §7.3 lists three places left to look for strength; this is arguably a fourth, and a cheap one — it needs only that the fixed complex have at least two vertices, which our own orbital counts give at every non-prime-power n. **Worth checking whether it strengthens anything at n = 10 or 12.**

**A pointed contrast on fixed points.** Their Corollary 4.3 handles n = p^r + 1 with Γ_{p^r} × 1 — a configuration with a **fixed point**. `enumeration-proof.md` Part A discards those immediately: a fixed point caps m\* at n − 1, so the configuration is dominated and never enumerated. Yet they get a strong conclusion from it (P contains K_{p^r} ∪ K₁ or K_{p^r,1}, and cannot contain both, else P is trivial). **Fixed points are worthless for orbital annihilation and useful for the transversal/χ argument.** That is a clean statement of why our filter is lossy for `notes` §8's purposes, and it bears directly on Open Problem 4.

**Direct cross-check available at n = 10.** They reduce potential counterexamples to 9 order ideals ("types") of a 10-element poset of isomorphism classes, then kill types 1, 3, 7 and 9 — leaving **types 2, 4, 5, 6, 8** (their Remark 5.2, where they say they could not find Oliver groups to discard the rest). `notes` §8 CSP works over 12,005,168 isomorphism classes and killed nine of eighteen candidate patterns. These are different parametrisations of the same question, and **our machinery can test their types directly**: each type is a stated set of isomorphism classes, so it is a constraint our solver can accept. Either we reproduce their four eliminations (a real non-circular validation of the CSP) or we kill more (a publishable increment on a 2016 paper). This is the single most concrete item to come out of the literature review.

*Bibliographic note:* they are not in our reference list and should be, and their reference [7] attributes the vertex-homogeneous dimension bound to **Lutz**, *Some results related to the evasiveness conjecture*, JCTB 81 (2001) — which is a different Lutz paper from the one we cite.

## 6. Black's spacing — confirmed incomparable to m\*

*Black, "Monotone properties of k-uniform hypergraphs are weakly evasive", ITCS 2015 / ACM ToCT 11(3), 2019.*

The framework is **orbit augmentation sequences**: sequences of sets with group actions, carrying a parameter called the **spacing**, which is a lower bound on decision-tree complexity for any nontrivial monotone property invariant under all the groups involved — **assuming all those groups are p-groups**. Operations (composition, direct product) build the sequences up; applications to k-graphs go via liftings with wreath-product actions of p-groups.

Three reasons it does not interact with μ, which settles the item as suspected:

- **p-groups only.** No cyclic layer and no second prime, so it is not the Oliver condition at all — the whole coherence apparatus of `notes` §2.4 has nothing to constrain.
- **It bounds D(f) directly**, not the minimum orbital of one group. Spacing is a property of a *sequence*; m\* is a property of a single group.
- **The conclusion is weak evasiveness, Ω(n) on n = v^k variables**, where ours is exact evasiveness on a sparse class. Different target.

The one genuine point of contact is methodological and worth a sentence rather than a comparison: Black's stated motivation is that KQS use "the topological approach combined with heavy number theory" and that his argument is elementary by contrast. Our framework is squarely on the heavy-number-theory side, so **Black is the standing demonstration that the number theory is not necessary for the Ω(n) conclusion** — which sharpens what the number theory is actually buying us, namely the exponent above 1.

## 7. Korneffel–Triesch and Scheidweiler–Triesch — different quantity, and `aod` §5 must say so

The lineage, all bounds on **c(n)**, the minimum over *all* nontrivial monotone properties of the decision-tree complexity:

| | bound on c(n) |
|---|---|
| Rivest–Vuillemin (1976) | n²/16 |
| Kleitman–Kwiatkowski (1980) | n²/9 |
| Kahn–Saks–Sturtevant (1984) | n²/4 |
| Korneffel–Triesch (2010) | **(8/25)n² − o(n²)** = 0.32 n² |
| Scheidweiler–Triesch | **n²/3 − o(n²)** — current best |

**These are not competing with μ, and the numbers must not be compared.** c(n) is a *universal* lower bound: every nontrivial monotone property needs that many queries. μ(n) supports a *conditional but exact* statement: any property whose members all have fewer than μ(n) edges needs **all** C(n,2) queries. So:

> Their result: every property needs ≥ n²/3 ≈ 0.667·C(n,2) queries.
> Ours: sparse properties need exactly C(n,2), i.e. 1·C(n,2), on a restricted class.

Neither implies the other. Ours is the stronger conclusion on a smaller class; theirs is weaker on all of them. **The density δ(n) ≈ 0.05 is a sparseness threshold, not a fraction of queries**, so reading it against 1/3 is a category error — and it is precisely the error `aod` §5 invites by quoting a small constant next to this literature. `aod` §5 should say, in one sentence, that δ measures *which properties* the method reaches and c(n) measures *how many queries* are forced for all of them.

*Also worth noting for framing:* the Triesch line is itself topological (Korneffel–Triesch is explicitly "an application of the topological approach of Kahn, Saks and Sturtevant"), so the honest statement is not "different technique" but **same technique, different quantity**.

## 8. What is still open in T4

**Only the Shparlinski prime-power question**, and it needs the paper body. His Theorem 2 ladder is stated for the largest **prime** divisor of r − 1; our η is built from the largest prime **power** divisor of the odd part, together with the 2-part. The two agree when r − 1 = 2q and differ otherwise. If his argument transfers verbatim to the prime-power version, "(H) is the θ = 1 endpoint" is exact rather than approximate; if it does not, `aod` §3.6's caveat has to stay. This is a judgement about a proof's robustness, not a fact to look up.

---

# Third pass: precedents for the reduction itself

*Not a check on a claim we make, but on the shape of the argument: where else has a combinatorial problem been reduced to an additive number-theory problem, and where has the additive input been shown semi-tight for the combinatorial method? Searched 2026-08. This bears on the framing decision in item 1 of "What remains", because it determines what is actually novel about the composition.*

**How to state our pipeline abstractly**, since that is what the comparison needs: *contractibility and fixed points* → *Smith theory and Oliver's chain condition* → *which permutation groups of degree n admit a large minimum orbital* → *partition n into prime-power parts subject to a coprimality budget* → *quadratic optimisation for the balance point*. Two features are worth isolating. The arithmetic condition is **mixed** — additive in the partition, multiplicative in the divisibility and coprimality constraints among parts. And `aod` §§3, 4 and 6 close the loop, showing the additive input is close to best possible *for this method* rather than merely sufficient.

## 9. Reductions to Goldbach-like conditions (question (a))

**The honest headline: no precedent found where a combinatorial existence theorem is reduced to binary Goldbach itself.** Nearly everything a search surfaces runs the other way — the "Goldbach graph" is constructed so that the conjecture holds iff all finite Goldbach graphs are connected, which is a restatement rather than a reduction. Worth recording so that nobody cites it as precedent.

**Bruck–Ryser–Chowla is the real precedent for the one-way direction.** If a projective plane of order n exists with n ≡ 1 or 2 (mod 4), then n is a sum of two squares. The pipeline is close to ours in shape: combinatorics → incidence matrix (AAᵀ = nI + J) → rational quadratic forms → Hasse–Minkowski and Hilbert symbols → representation of an integer by a binary form. Two things to take from it.

- **The failure mode matches ours.** It eliminates 6, 14, 21, 22 but 10 = 1² + 3² escapes, and order 10 needed Lam's computation; 12, 15 and 18 remain out of reach. That is exactly our ceiling-versus-floor gap: a necessary arithmetic condition that thins the candidate set without closing it.
- **The sufficiency side is as open as ours.** The prime power conjecture stands to BRC as our Open Problem 8 stands to `aod` §3.

**Romanov + Erdős/van der Corput is the Goldbach-*flavoured* precedent, and it is the closest analogue to `aod` §3.4.** Verified: Romanov (1934) proved a positive lower density of integers representable as p + g^k for any fixed g ≥ 2 — so the statement is about prime **plus prime power**, which is our S3 shape, not about two primes. In the opposite direction Erdős (1950) introduced covering systems of congruences and constructed an infinite arithmetic progression of odd integers with no p + 2^k representation; van der Corput proved the positive lower density of the complement independently and in the same year.

> **The parallel is structural and close.** A positive-density additive supply, defeated on an explicit congruence class by *local* obstructions, with the obstruction mechanism being covering congruences — which is precisely `aod` §3.4's local obstructions at ℓ = 2 and ℓ = 3 and the resulting mod-12 (then mod-24) classification, all in `arithmetic-of-density.md`. Our residues 7, 15, 23 mod 24 play the role of Erdős's progression.

**And there is a sharper precedent still, which we should read.** Erdős asked whether *every* arithmetic progression of odd numbers containing no 2^k + p can be obtained from covering congruences, and the answer has been given affirmatively, together with a quantitative Romanov theorem on arithmetic progressions (Chen–Sun, *Acta Math. Sinica*, "On the density of integers of the form 2^k + p in arithmetic progressions"). That is the exact analogue of a claim we would like to make — that our obstructed residues are *only* the local ones — so the method there is worth reading before we assert anything of that shape about `aod` §3.4.

*Correction to an earlier oral summary:* Erdős's covering construction is 1950, not the 1930s, and van der Corput's independent density result is the same year; Romanov's theorem is 1934 and is general in g, not special to g = 2.

## 10. Two-way, semi-tight reductions (question (b))

**Ruzsa–Szemerédi ↔ Roth/Behrend is the canonical precedent and the right methodological template to cite.** The (6,3)-problem — maximum edges with every edge in a unique triangle, equivalently a partition into linearly many induced matchings — has an upper bound from the regularity method and a nearly-quadratic lower bound derived from Behrend's progression-free sets. The reduction is genuinely bidirectional: Ruzsa and Szemerédi used the regularity method to give a graph-theoretic proof of Roth's theorem, and Behrend's construction bounds how well the graph method can possibly do. **That is semi-tightness in our sense** — improving the additive input improves the combinatorial bound and conversely — and it is the closest published analogue of what `aod` §§3, 4 and 6 do together.

**The cyclic / abelian / nilpotent numbers line looks like our closest sibling and is worth reading, but the quantifier runs the other way — this is a *dual*, not a parallel.** n is a *cyclic number* — every group of order n is cyclic — precisely when gcd(n, φ(n)) = 1, implicit in Dickson (1905) and explicit in Szele (1947). Erdős (1948) proved C(x) ~ e^{−γ}x/log log log x, refined by Pollack to an asymptotic series in descending powers of log log log x. The nilpotent analogue is gcd(n, ψ(n)) = 1 with ψ(p^a) = (p^a − 1)(p^{a−1} − 1)⋯(p − 1); abelian is that plus cubefree.

The surface resemblance is real and worth stating precisely, because it is what makes the difference visible: gcd(n, φ(n)) = 1 unpacks to **pᵢ ∤ (pⱼ − 1) for all i, j**, which is the same *kind* of divisibility constraint among prime factors as our cyclic-layer budget "q | r − 1". But the two use it for opposite purposes.

> **The direction of the quantifier is reversed.**
>
> - **Cyclic numbers: ∀, and cyclicity is the conclusion.** The arithmetic condition is a *rigidity* hypothesis. It says n admits no divisibility coincidence anywhere among its prime factors, and therefore that *no* non-cyclic group of order n can be assembled. Cyclicity is what gets forced on every group of order n; the arithmetic is an obstruction to richness.
> - **Ours: ∃, and cyclicity is an ingredient.** Cyclicity of Γ₁/Γ₂ is a *hypothesis of Oliver's chain*, i.e. a feature of the object we are building, and the coprimality budget is what a witness must satisfy in order to exist. We are not forcing anything to be cyclic; the cyclic layer is the good structure we are given to work with, and coprimality is a budget we spend on it. The arithmetic is a constraint on realisability.
>
> **This has an analytic consequence that settles whether the technique transfers.** A universally-quantified no-coincidence condition is a conjunction over all pairs of prime factors, which is why cyclic numbers are *sparse* — density → 0 like 1/log log log x. Our condition is existential over partitions: we need **one** admissible shape, not the absence of all bad ones, which is why `aod` §4 sees *positive* density. So Erdős's and Pollack's machinery is aimed at the wrong target for us. Their difficulty is bounding a sparse set defined by a conjunction; ours is lower-bounding a representation count, which is Bateman–Horn and Romanov territory (items 9 and 2), not log-log-log asymptotics.
>
> **What the line is still good for**, and why it stays in this file: it is the best existing precedent for *the same class of arithmetic condition* being extracted from a group-theoretic property of n and then studied for its own sake, and it is the standard against which "an arithmetic characterisation deserves a density theorem" is judged. Read it for how the result is *stated and positioned*, not for the technique.

**A better structural sibling on the existential side: Hadamard matrix orders.** The question "for which n does a Hadamard matrix of order n exist" is existential like ours, and the supply is arithmetic in `aod` §3.5's sense: Paley (1933) gives order q + 1 for prime powers q ≡ 3 (mod 4) and 2(q + 1) for q ≡ 1 (mod 4), so the input is *primes and prime powers in arithmetic progressions* — the same Bateman–Horn-type supply `aod` §3.5 draws on. Three points of contact:

1. **Constructions compose**, via Sylvester doubling and the Kronecker product on orders n₁n₂, which is the analogue of our shapes combining — and the composition is *multiplicative* where ours is additive, which is exactly the axis on which our problem is harder.
2. **The sufficiency side is the famous conjecture** (every order 4k), standing to the constructions as our Open Problem 8 stands to `aod` §3 — and as the prime power conjecture stands to BRC.
3. **The density question is open in the same shape as ours**, and this is the useful find: *it is still not known whether the set of orders of Hadamard matrices has positive density*, with the known families being sparse subsequences of {4t}. What **is** provable from Paley plus doubling is a covering statement — every interval (x, 2x) contains a Hadamard order except (1,2), (2,4), (4,8), and H(x)/x → 1.

> **That last point needs care, and the obvious reading of it is wrong.** It is tempting to say: positive density of Hadamard orders is open under better tools, so `aod` §4's density claim must be either stronger or incomparable. **Neither — because we do not prove a density theorem.** We reduce to Bateman–Horn-type conjectures and read off what they would give. The Hadamard question is open *unconditionally*; ours is answered *conditionally*, and those are different statuses rather than competing strengths.
>
> **The genuine reconciliation is about the shape of the arithmetic supply, and it is worth stating because it explains both sides at once.** Paley needs a single prime power near n — n − 1, or (n/2) − 1 — and primes are sparse, so Paley-type orders are a density-zero set no matter what one assumes about them. We need a *representation* of n, n = c + r with both parts prime powers, and representation counts are governed by Hardy–Littlewood-type heuristics giving ~n/log²n representations, so conjecturally almost every admissible n has one. **Sparse-supply-of-primes versus positive-density-of-representations is the whole difference**, and it is the same difference that separates "q is prime" from "n is a sum of two primes".
>
> So the calibration to keep is narrower than I first wrote, and it cuts at the framing rather than at the mathematics: **the contribution is the reduction, not a density theorem.** `aod` §4 should say what it is conditional on, in the same breath as what it concludes — and the comparison worth drawing with Hadamard is that both fields sit downstream of hard prime-distribution input, with ours in the luckier position of needing a representation rather than a single prime.

**Which places us in a recognisable genre: results conditional on Hypothesis H / Bateman–Horn.** That is where a precedent search should go next, and it is a different genre from items 9 and 10 — not "combinatorics reduces to additive number theory" but "a combinatorial theorem is proved *assuming* a prime-tuple conjecture, and the reduction is the contribution". The relevant question for us is how such papers state their standing: what is unconditional (our ceilings, `aod` §3), what is conditional (our densities, `aod` §4), and whether the conditional part is presented as a theorem or as a consequence. Getting that division explicit in `aod` §§3–4 matters more for a referee than any of the comparisons above.

## 11. The sibling pipelines: topology → group theory → arithmetic

**The spherical space form problem shares our first three arrows and is an iff.** A finite group acts freely on some sphere if and only if every subgroup of order p² or 2p is cyclic — Smith's p²-condition from cohomological periodicity, Milnor's 2p-condition from the geometry (every involution central), with sufficiency completed by Madsen–Thomas–Wall (1976). Note the *form* of the answer: conditions on subgroup orders, i.e. arithmetic conditions on the divisors of |G|, reached from a topological hypothesis through Smith theory.

**What nobody in that literature does is take the last two arrows.** The chain stops at a group-theoretic characterisation; it does not go on to ask for the density of n admitting a group with a prescribed quantitative property, and there is no optimisation step fixing a constant.

## 12. What this says about the framing decision

Neither half of our pipeline is new on its own. *Topology reduces to arithmetic conditions on group order* is Smith, Milnor, Madsen–Thomas–Wall and Oliver. *Combinatorial existence reduces to additive number theory* is Bruck–Ryser–Chowla and Ruzsa–Szemerédi. **The claim available to us is the composition**, ending in a density statement over n with a quadratic optimisation fixing the constant. Three specifics look genuinely unprecedented, in decreasing order of confidence:

1. **The mixed additive/multiplicative condition.** Cyclic numbers are purely multiplicative; Goldbach and Romanov purely additive. Requiring a partition of n into prime-power parts *whose twist and rotation orders are pairwise coprime in one cyclic layer* mixes the two, and the coprimality budget is what makes the shape space finite in a way neither pure setting is.
2. **The quadratic optimisation as a load-bearing step.** cap_F(η) = η/(1 + √(Fη))² and its balance points produce the eight mod-24 ceilings; they are not decoration. Behrend's radius optimisation is the nearest analogue, but it optimises a *construction* rather than a ceiling on all constructions.
3. **Semi-tightness shape by shape.** Ruzsa–Szemerédi's tightness is quantitative, in log factors. Ours is structural: `aod` §6 shows the feasible shape set is finite and `aod` §3 shows each class's ceiling is met to within 2%, so the additive input is nearly exhausted per shape rather than in aggregate.

## 13. What to read next, in priority order

1. **Chen–Sun on 2^k + p in arithmetic progressions** (item 9). The affirmative answer to Erdős's question is the exact analogue of "our obstructed residues are only the local ones", and the method may transfer to `aod` §3.4 directly.
2. **Done — see the fourth pass, items 14–16.** Jones–Zvonkin is the model for how the genre states its standing, and Skorobogatov–Sofos's Hypothesis-H-on-average is the one idea that could make `aod` §4 unconditional. The Hadamard comparison is settled and needs no further work: their supply is a single prime near n and is sparse regardless; ours is a representation of n and is conjecturally almost-all. Different supply shapes, not competing strengths. **Do not read Erdős 1948 / Pollack expecting a transferable technique** — the quantifier is reversed there, their set is sparse for a reason ours is not, and the value is in how the result is stated rather than in how it is proved.
3. **Ruzsa–Szemerédi and Behrend**, for the semi-tightness framing and for how that literature states the two-way relationship in print.
4. **Bruck–Ryser–Chowla**, for how a necessary-only arithmetic condition is presented alongside an open sufficiency conjecture — which is the situation `aod` §3 plus Open Problem 8 is in.

---

# Fourth pass: the conditional-on-Bateman–Horn genre

*Searched after the third pass identified this, rather than "combinatorics → additive number theory", as the genre we are actually in. The contribution is a reduction; the question is how such work states its standing. One of the hits is close enough to be a direct model.*

## 14. Jones–Zvonkin, "Groups of prime degree and the Bateman–Horn Conjecture" (arXiv:2106.00346) — the model

**Same pipeline, one layer down.** They ask when the natural degree m = (q^n − 1)/(q − 1) of PSL_n(q) is prime — the last open case in the classification of permutation groups of prime degree, everything else following from CFSG. Their answer is not a theorem: they present heuristic arguments and computational evidence based on the Bateman–Horn Conjecture supporting the conjecture that infinitely many such 'projective primes' exist. So: **group-theoretic existence at degree n, reduced to a prime-value question, settled conditionally and stated as such.** That is `aod` §§3–4 with a different group family.

**Four presentational lessons, which is what this pass was for.**

1. **They never call it a theorem, and they say what it is in the abstract.** "Heuristic arguments and computational evidence … to support a conjecture." The reduction and the numerics are the contribution; the conditional statement is labelled at first mention, not in a remark at the end.
2. **They validate the conjecture empirically at the range they use it, before relying on it.** Tables of the Bateman–Horn estimate E(x) against the true count P(x): for type (1,3), E/P = 0.99966 to 1.00004 across x = 10¹⁰ to 10¹¹, relative error −0.0052% at 10⁹. **This is exactly what `aod` §3's tables do** — measure the achieved densities against the predicted ceilings and report the agreement — and it is worth knowing that the practice is standard in this genre rather than something we invented. It also tells us how to *frame* those tables: not as verification of our formulas but as evidence that the number-theoretic input behaves as predicted in our range.
3. **They separate what is in scope from what is not, explicitly.** Several families are "beyond the scope of the BHC, involving exponential functions rather than polynomials" — the Mersenne-like cases m = 2^n − 1 with n varying. **This matters directly for us, and we have not drawn the line:** our two-part shapes with both parts *prime* are linear-polynomial and inside Bateman–Horn, but shapes requiring *prime powers with unbounded exponent* are exponential in the same way and are not. `aod` §3.5's supply argument should say which of our families sit on which side.
4. **They flag the Catalan/Pillai hazard where both quantities are proper prime powers.** In Jones–Zvonkin §8.4, discussing prime powers q with 3q − 2 also a prime power, they handle the cases where at least one is prime and then warn that the both-proper-prime-powers case has Mihailescu's proof of Catalan and Pillai's conjecture as a caution. **Our S1 and S2 shapes are exactly that regime.** A finiteness phenomenon there would not be a gap in our argument, but it would mean those shapes supply O(1) values rather than a positive density, and `aod` §6 currently treats their supply as ample.

**Two further points of contact in the same paper.** Jones–Zvonkin §8.3 applies BHC to block designs — Amarra–Devillers–Praeger's block-transitive point-imprimitive 2-designs depend on a polynomial taking prime power values, and the BHC estimate is checked against computer search to 0.044%. Their §8.4 does the same for divisible difference sets. So *combinatorial design existence conditional on prime-value conjectures, validated numerically* is an established and recent practice, not an unusual move. Their companion paper "Block designs and prime values of polynomials" (arXiv:2105.03915) is the one to read next in this direction.

## 15. Skorobogatov–Sofos, Hypothesis H on average — the one idea that might upgrade `aod` §4

*Inventiones* 231 (2023): Schinzel's Hypothesis holds for 100% of polynomials of arbitrary degree, and this is used to prove that a positive proportion of varieties in a family have rational points. The move worth stealing is stated plainly in their introduction: to run the argument **one does not need the full conjecture — it is enough to know that most polynomials satisfying the obvious necessary condition represent at least one prime.**

**That is structurally our situation.** `aod` §4 does not need a Bateman–Horn asymptotic at every n. It needs: for almost every admissible n, *some* shape in the finite feasible set of `aod` §6 is realised. That is an on-average statement over a family, not a per-n statement — and the on-average version is a theorem where the per-n version is a conjecture.

> **This is the most actionable item in this file.** If the averaging can be made to work over our shape families, `aod` §4's density claim moves from conditional to unconditional, which changes what the paper is. The obstacles to check: our polynomials are constrained by the coprimality budget, so the family we average over is not a generic family of polynomials; and their result is for linear polynomials in several variables, which fits our two-part shapes better than our fused ones. **Worth a serious read before `aod` §4 is written, not after.**

## 16. What this settles about our standing

The division we should state explicitly, in `arithmetic-of-density.md` §3's opening rather than anywhere later:

| | status | rests on |
|---|---|---|
| the mod-24 ceilings (§3.3) | **unconditional** | local obstructions at ℓ = 2, 3 and the balance-point optimisation |
| the shape space being finite (`aod` §6) | **unconditional** | the feasibility criterion Σ√Fᵢ ≤ 1/√δ |
| the collapse μ(n) = B(n) at computed n | **unconditional** | the eight necessary conditions, per-n |
| the escape densities (`aod` §4.3) | **conditional** | Bateman–Horn-type supply |
| the global floor conjecture (`aod` §5) | **conjectural**, verified to 10⁶ over four families | — |

The Jones–Zvonkin practice suggests putting this table near the front and labelling every density statement at first mention. What we should *not* do is what an earlier draft of this file drifted towards — comparing our conditional density against other fields' unconditional open problems as though they were competing strengths.

---

# Fifth pass: the sub-board route, and what already exists

## 17. The sub-board Fourier-degree route is Black's spacing framework

*Recorded because it was derived independently in this project before the literature was checked, and the record of that is more useful than the result.*

**The route.** Deterministic query complexity satisfies D(P) ≥ deg(P) (Best–van Emde Boas–Lenstra), and deg(P) ≥ |S| whenever the Fourier coefficient at an edge set S is nonzero. For a down-closed P that coefficient is A(S) = Σ_{T⊆S} (−1)^{|T|}[T ∈ P]. **If Γ is a p-group and S is Γ-invariant**, orbits of Γ on subsets of S have p-power size, so non-fixed orbits vanish mod p and A(S) ≡ Σ over unions-of-Γ-orbitals-inside-S (mod p) — a sum over 2^t terms rather than 2^{|S|}. If that is ≢ 0 mod p then A(S) ≠ 0 and **D(P) ≥ |S|**. Taking S to be everything but the smallest orbital gives bounds close to C(n,2).

**The p-group hypothesis is not optional, and the way it was found is worth recording.** The first version of this argument used Oliver-chain groups and Γ-invariant subsets. That is wrong: orbit sizes are |Γ|/|stab| and are divisible by q only when Γ is a q-group. On the full board the corresponding statement survives because the argument runs through Oliver's theorem and acyclicity, not through raw orbit counting — the conclusion was transported to sub-boards without the proof. The error surfaced from the question "couldn't you pick a trivial group?", which is the right probe: Γ = 1 makes every subset invariant, so the reduction is vacuous and the cost is 2^{|S|}, exposing that the strength comes from the group's orbit structure and not from the sub-board being large.

**Measured on the n = 10 artefacts.** Restricted to the p-group battery, where the congruence is elementary and certain, the test fires on 915 sub-boards, the largest being **|S| = 42 of 45** via `B:7+1+1+1` (a C₇ on seven points with three fixed, p = 7, A = −5). Against n²/3 = 33.3 at n = 10. The largest board is also the ceiling for this route in that battery, since the smallest orbital available is 3.

**This is Black's spacing framework**, item 4: orbit augmentation sequences, p-groups throughout, a spacing parameter lower-bounding D. The mechanism is not ours and the n = 10 number is best described as a spacing-like certificate.

**Two things survive the collision, and they are worth keeping separate from the mechanism.**

1. **It is a certificate, not a theorem.** Whether A(S) ≢ 0 mod p is a fact about the particular P; nothing forces it. So it does not by itself give c(n) ≥ C(n,2) − ε. Getting a bound on c(n) needs the test to fire for *every* high-dimensional P, which is exactly what a CSP over the property is for — but that is real work.
2. **The optimisation runs opposite to our battery selection.** This route wants **many small orbitals**; the max-m\\* search wants the reverse, and discards precisely the useful groups. That is the same inversion the two-orbital criterion has, and a second reason `pending-checks.md`'s note about the battery being selected by m\\* and cost rather than by constraint strength matters.

## 18. Chakrabarti–Khot–Shi — "closer than n²/3" already exists for restricted classes

*Evasiveness of Subgraph Containment and Related Properties*, SIAM J. Comput. 31 (2001). For subgraph containment and a fairly large related class they prove evasiveness on an arithmetic progression of n, giving a **½n² − O(n)** lower bound on decision-tree complexity, and evasiveness for all sufficiently large n for minor-closed properties.

**Calibration for any "beat n²/3" ambition:** for restricted property classes the literature is already at ½n² − O(n), i.e. essentially C(n,2), not at n²/3. The n²/3 figure is the bound for *all* nontrivial monotone properties. A result of ours aiming between the two must be explicit about which class it quantifies over, or it will be read as improving n²/3 when it is really re-deriving a weaker version of the restricted-class results.

## 19. An attribution to check on the n²/3 bound

At least one survey attributes the Ω(n²/3) bound to **unpublished work of Santha and Yao**, not to Scheidweiler–Triesch. We currently cite Scheidweiler–Triesch (SIAM J. Discrete Math. 27, 2013) alone, in `aod` §5 and in the `notes` reference list. **Check which is right before publication** — plausibly both exist, the published bound and an earlier unpublished one, but a citation naming only one of them is a claim about priority that we have not verified.

## 20. Jones–Zvonkin is a programme, not a paper — and they say so themselves

The observation is right and it is worth recording as a programme rather than as a single model paper. The pattern repeats across at least five works:

| target | the object whose existence needs a prime value | where |
|---|---|---|
| dessins d'enfants | degrees p, p+1 for type (3,2,p) dessins | *Klein's ten planar dessins of degree 11, and beyond*, arXiv:2104.12015 |
| permutation groups | (qⁿ−1)/(q−1) prime — the last gap in classifying groups of prime degree | *Projective primes and the Bateman–Horn Conjecture*, arXiv:2106.00346 |
| block designs | Amarra–Devillers–Praeger quadratics taking prime power values | arXiv:2105.03915 |
| permutation groups, again | Hujdurović–Kutnar–Kuzma–Marušič–Miklavič–Orel intersection densities, via cyclotomic polynomials | Trudy IMM 29 (2023) |
| finite simple groups | Peter Neumann's question on simple groups of order a product of six primes | — |

Their own positioning, from the block-designs paper: the paper and its companion "represent its first application to block designs, just as [19, 20] are the first in the areas of dessins d'enfants and permutation groups." **They are explicitly in the business of introducing the Bateman–Horn Conjecture into new areas.** Zvonkin also has a survey talk, *In Praise of the Bateman–Horn Conjecture*.

**The recipe, which is stable across all five.** (i) Find a construction in the literature whose existence depends on a polynomial taking prime or prime-power values. (ii) Verify Bunyakovsky's conditions (a), (b), (c) for that polynomial by elementary argument — this is the "closing the gap" step and is usually a page or two, e.g. the discriminant being a perfect square exactly at triangular numbers. (iii) Compute BHC estimates, using Li's modification, against extensive search. (iv) Conclude *strong evidence*, never a theorem.

**Three consequences for us.**

1. **The genre has active practitioners who are looking for new areas, and evasiveness is an obvious one.** ARK reduces to prime-power representation questions; nobody has published that framing. This is simultaneously an opportunity — the natural people to cite, and plausibly to talk to — and a reason not to sit on the framing indefinitely.
2. **Our contribution is larger than theirs in the same genre, and the difference is worth naming precisely.** In every Jones–Zvonkin paper the combinatorial content is *cited*: someone else's construction, one polynomial, and the work is the number-theoretic verification. Ours constructs the reduction itself — a whole shape space with a coprimality budget, a finiteness theorem for it, and a two-sided semi-tightness relating the additive input to the combinatorial method. **We supply steps (0) and (i) as well as (ii)–(iv).** That is the sentence the framing decision should turn on.
3. **Our step (ii) is the one that is missing.** They verify Bunyakovsky conditions for their polynomials explicitly and elementarily. `aod` §3.5 asserts an ample supply from Bateman–Horn-type heuristics but does not, for each shape family, check the analogue — that the relevant polynomial system satisfies Schinzel's conditions and has no fixed prime divisor. **That check is elementary and we have not done it.** It is the concrete next step for `aod` §3.5, and it interacts with the polynomial-versus-exponential line of item 14: the shapes with unbounded exponent have no polynomial to check, which is itself the finding.

*One uncertainty to resolve:* "Li's recent modification of the Bateman–Horn Conjecture" is cited throughout their recent papers. Whether this is the same Runbo Li as the 0.679 shifted-prime improvement (arXiv:2508.18285) that `aod` §3.6 now cites is **not established** — the names coincide and the areas are adjacent, but I have not checked. Do not conflate them in print without confirming.

## 21. Where the hardness actually sits: one wall, not two bottlenecks

*A natural reading is that the difficulty splits in two — a Goldbach part and a shifted-prime part — with the Goldbach part essentially solved and the shifted-prime part capped at θ = 0.679 by Baker–Harman machinery, so that the shifted primes are the binding constraint and Goldbach adds only a log-power penalty on top. The first half of that is right. The second half describes the obstacle as a cap when it is a discontinuity, and the distinction matters for how `aod` §3.6 should read.*

**The Goldbach half is as described, and the combination has already been done.** Binary Goldbach for almost all even n, and ternary for all large odd n, supply what our two- and three-part families need in exactly the quantifier we care about, at a cost of 1/log²n or 1/log³n in the representation count — log powers, never exponents. Nothing on that side touches θ.

One refinement rather than an objection: the two conditions are **not sequential filters**. We need the foreign prime r to lie in the shifted-prime set *within* a Goldbach representation, and an almost-all Goldbach theorem supplies *some* representation, not one whose summand lands in a prescribed positive-density subset of the primes. That is a bilinear equidistribution question, not an intersection. It is also already solved at the rungs: **Shparlinski's Corollary 3 is precisely this combination**, its "almost all n" quantifier being the Goldbach-side averaging layered over Baker–Harman.

**The shifted-prime half is not a cap, for two reasons.**

*First, no θ < 1 reaches the regime our constants live in.* If P(r − 1) ≈ r^θ then

> η = 2t/(r − 1) ≈ 2r^{θ−1} → 0,  so  δ ≈ cap(η) ~ η ~ n^{θ−1} → 0,

and the orbital size is m\* ~ n^{1+θ} — which is exactly the ladder's edge bounds in §3.6. So **the whole ladder below θ = 1 delivers a vanishing density.** The constants of §3.3 — 1/4, 3 − 2√2, (5 − 2√6)/2 — exist only at the θ = 1 endpoint. Improving 0.679 to 0.9 moves an exponent and still leaves δ → 0, hence no dimension threshold and no evasiveness conclusion. **This is the point §3.6 currently obscures** by presenting the rungs as progress toward the endpoint: they are progress on a different quantity.

*Second, above the top rung the problem changes class.* Constant η forces a **bounded cofactor**: r − 1 = m·t with m ≤ 2/η. That is the Sophie Germain / safe-prime regime, and the literature is explicit that it is not a harder version of the same question — it is not known, for any ε > 0 however small, whether there are infinitely many primes p with P(p − 1) > p^{1−ε}, and P(p − 1) = (p − 1)/2 is the Sophie Germain case, itself not known infinite (see e.g. the survey discussion in arXiv:1311.2527, which also records Goldfeld's κ(1/2) ≥ 1/2). So in the range θ ∈ (0.679, 1) **infinitude itself is open**, not merely density. Sieve improvements approach the endpoint asymptotically in θ and never cross into it.

**Consequences.**

| | status |
|---|---|
| Goldbach supply, binary and ternary | essentially solved; log-power cost; already combined with the ladder by Shparlinski |
| shifted primes, θ ≤ 0.679 | positive relative density (Baker–Harman, Li); yields δ → 0 |
| shifted primes, θ ∈ (0.679, 1) | **infinitude open**, not just density |
| shifted primes, θ = 1 (bounded cofactor) | Sophie Germain regime; Hardy–Littlewood / Bateman–Horn class |

So there is **one wall, and it is not at the top rung** — it is the gap between the top rung and the endpoint, and no sieve improvement crosses it. This is also why (H) belongs in the Bateman–Horn class rather than being a strengthened Baker–Harman, and why the Goldbach half becomes moot at the endpoint: one cannot average over a set not known to be infinite.

**Two things unverified, flagged rather than asserted.**

1. **Do prime-*power* divisors buy anything at the endpoint?** What our shapes need is t a prime power, not a prime, and §3.6's domination shows that is never worse. But at bounded cofactor, t = q^e with e ≥ 2 gives r = m·q^e + 1, which is *sparser* than the prime case, so the expectation is that it buys nothing. Worth one hour to confirm, since the domination argument makes it easy to state carelessly in our favour.
2. **Might bounded-cofactor supply be provable on average over n even though it is open per-n?** This is the Skorobogatov–Sofos angle of item 15 pointed at the endpoint rather than at `aod` §4's shape families. It is the one live hope in this item.

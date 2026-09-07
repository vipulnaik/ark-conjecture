# The hardness of evasiveness: what the conjecture's known corners cost

*A philosophical companion, not a results document. Nothing here is a theorem of ours; the content is an argument about **where the difficulty of the evasiveness conjecture sits**, assembled from what its proved special cases actually depend on. It exists because that argument kept recurring in conversation and is the sort of thing that decides what to attempt, which makes it worth writing down even though — especially though — it proves nothing.*

**Status.** Commentary throughout. The four dependencies in §2 are matters of record; the inference in §3 is defeasible and says so; §5's question is open and, as far as we know, unasked.

---

## 1. The shape of the argument

The evasiveness conjecture — in the general monotone-transitive form, that every nontrivial monotone function invariant under a transitive group is evasive — trivially implies every special case of itself. So for any particular family one can ask: **what does the cheapest known proof of that family cost?** If the answer is repeatedly "a deep theorem, and a different one each time", that is evidence about the conjecture even in the absence of any implication running the other way.

This is not a difficulty *theorem*. It is the same kind of reasoning as "the only known proofs of X go through the classification, so a classification-free proof of X is not around the corner" — defeasible, occasionally overturned, and still the right thing to reason from when deciding what to attempt.

## 2. Four corners, four imports

| special case | proved by | imports |
|---|---|---|
| prime-power **coordinate** count | Rivest–Vuillemin | a Sylow subgroup is already transitive — mild |
| prime-power **vertex** count (graph properties) | Kahn–Saks–Sturtevant | **Oliver's fixed-point theorem**, i.e. Smith theory for p-group actions |
| "S lies in a proper coset", at **every** finite group | Shareshian–Woodroofe, via Brown | **invariable generation of finite simple groups**, hence CFSG |
| the asymptotic half of the graph case | this project | a **Goldbach-type hypothesis** (BCG-AL), unproved |

Four corners, four imports from four unrelated deep theories, and no two of them share a technique. That is the observation the rest of this document is about.

> **The second and third rows deserve care, because each is easy to state slightly wrong.** RV's prime power is the number of *variables*; for graph properties that is C(n,2) = n(n−1)/2, never a prime power for n ≥ 4, so RV says nothing about prime-power *vertex* count and KSS is genuinely new there (`orbital-evasiveness-notes.md` Appendix C). And CFSG is paying for **more** than evasiveness in row 3: Shareshian–Woodroofe prove non-contractibility, which is strictly stronger, and the weaker route suffices for evasiveness — see §4.

## 3. What the coset family shows, and the refinement that makes it sharper

The coset property — S ⊆ G lies in a left coset of a proper subgroup, invariant under left translation (`monotone-transitive-note.md` §5a) — is an instance of the conjecture, so the conjecture implies it. The only known proof at **every** finite group is Shareshian–Woodroofe's, which rests on CFSG. Hence: *anyone claiming a classification-free proof of the general conjecture is claiming a classification-free proof of that special case, which nobody has.*

> **But the CFSG dependence is on uniformity, not on the property.** At any *specific* group, evasiveness follows from a finite Möbius computation: Brown's identity **P(G, −1) = −χ̃(Δ(C(G)))** makes χ̃ ≠ 0 sufficient, and χ̃ is computable from the subgroup lattice. At solvable G it follows from Hall's formula with no classification at all. At **A₅** we computed P(A₅,−1) = −1560, so χ̃ = 1560 ≠ 0, and evasiveness there needs nothing deep. What is *open* is whether χ̃ ≠ 0 at **every** finite group — Brown asked it, and Shareshian–Woodroofe settled the stronger non-contractibility question instead.
>
> **So the hardness concentrates in the quantifier**, which is the same place the conjecture's own hardness sits, and the same shape as CFSG itself: a uniform statement all of whose instances are individually checkable. That is a more precise claim than "evasiveness is CFSG-hard", and it is the version this document defends.

## 4. Why the implication does not run the other way

It is tempting to hope for **evasiveness ⟹ some hard group theory**, e.g. Feit–Thompson. Three obstacles, in increasing order of seriousness.

1. **Evasiveness is the weak end of the chain.** Every proof runs χ(Δ^Γ) ≢ 1 ⟹ not ℤ-acyclic ⟹ not contractible ⟹ not collapsible ⟹ evasive, and each arrow loses information. Evasive functions with collapsible complexes exist, so "evasive" carries almost no topological content by itself. Extracting group theory from it means running uphill.
2. **There is no construction technology.** An implication would need: *from a group with property X, build a nontrivial monotone invariant function with a shallow tree.* In the monotone weakly-symmetric setting **no non-evasive example is known at all** — the conjecture may simply be true — so there is nothing to adapt. Illies's counterexample and the scorpion are both non-monotone.
3. **A specific dead end worth knowing.** The natural route — "a transitive group with no transitive Oliver subgroup yields a non-evasive property, so the conjecture forces the gap to be empty" — fails immediately, because the gap is **not** empty: A₅ on 10 points and T(12,162) are in it (`monotone-transitive-note.md` §3), and the conjecture is presumably true at both anyway.

*And a caution about self-reference.* Oliver's theorem hypothesises a solvability-flavoured chain, and the framework's own arithmetic leans on classification-derived facts such as "solvable 2-transitive ⟹ prime-power degree". Any conditional theorem would have to draw on group theory genuinely upstream of what evasiveness proofs already consume, or it would be circular rather than a difficulty bound. **That, not the construction, is where such an attempt would most likely fail** — and it is the first thing to check, not the last.

## 5. The one reduction that looks available

Not "evasiveness implies Feit–Thompson", but something checkable and of the same species:

> **Question.** Must a proof of the general monotone-transitive conjecture yield, as a special case, a **classification-free proof that χ̃(Δ(C(G))) ≠ 0 for every finite group** — i.e. a classification-free resolution of Brown's question?

If the answer is yes, that is a genuine relative-difficulty statement rather than an impression: the conjecture would be at least as hard as an open problem in group theory whose only known partial resolution goes through CFSG. It looks close to automatic, since the coset property is a legitimate instance — but "close to automatic" is exactly the sort of thing this project has been wrong about before, and the gap between *evasive* and *χ̃ ≠ 0* (item 1 of §4) is precisely where it could fail. **Working it out is a self-contained afternoon**, and it is the highest-value item in this document.

## 6. Where the analogy with P vs NP holds, and where it breaks

**Holds.** A single uniform conjecture; many instances; instances settled ad hoc; and "why this instance is hard" reinforcing "why the general question is hard" with no formal implication between them.

**Breaks, and the break is instructive.** P vs NP's difficulty is underwritten by *theorems about proof techniques* — relativization, natural proofs, algebrization — which say no argument of a given shape can succeed. **Evasiveness has no barrier results of any kind.** What it has instead is the opposite: a succession of techniques that each work on a slice and then stop. That is weaker evidence than a barrier, and it points the same way.

**The closer analogue is the CFSG-free-proof question itself**, where the evidence is entirely "nobody has found one and the known routes go through the same heavy door" — and where the door has occasionally been opened.

> **A programme this suggests, which is the useful output.** The realistic direction is the reverse of the exciting one: **hard group theory ⟹ evasiveness of specific natural families**, with Shareshian–Woodroofe as the working example and the coset complex as the template. Identify Δ_P as a complex whose homotopy type is already studied, then bring the classification to bear on its homology. That is what settled the coset family at every group where Oliver could only do the solvable ones, and it is the transferable move for `monotone-transitive-note.md` §6's orbit complexes — whose resistance may simply be that no comparable identification has been found for them.

---

## Appendix. The nerve lemma step, spelled out

*Because §3's chain from "contained in a proper coset" to "the coset poset" is three separate moves, and the middle one is the only interesting one.*

**The complex.** Δ_P has vertex set G and faces the subsets lying in a single left coset of a proper subgroup. Its **maximal faces are exactly the maximal proper cosets** gM, M a maximal subgroup: any S in a proper coset is in a maximal one, and gM is itself a face.

**The cover.** Cover Δ_P by those maximal faces. Each gM is a **full simplex** on its |M| vertices, hence contractible. Any intersection of cosets is empty or a coset — for gM ∩ hK either empty or a coset of M ∩ K — and as a subcomplex it is again a full simplex, hence contractible.

**The nerve lemma** says: if a simplicial complex is covered by subcomplexes all of whose nonempty finite intersections are contractible, the complex is homotopy equivalent to the **nerve** of the cover — the complex with one vertex per cover member and a simplex for each subfamily with nonempty intersection. Here every hypothesis is met by the previous paragraph, so

> **Δ_P ≃ N**, the nerve of the maximal proper cosets.

**And the nerve is the coset poset.** Apply the same lemma to the order complex Δ(C(G)) of the coset poset, covered by the sub-posets of cosets contained in a fixed maximal coset gM. Each such sub-poset has a top element, so it is a **cone**, hence contractible; the intersection of two of them is the sub-poset below gM ∩ hK, again a cone or empty. The nerve of *this* cover is the same N — one vertex per maximal coset, a simplex per subfamily with nonempty intersection. So Δ(C(G)) ≃ N ≃ Δ_P.

*Verified numerically rather than taken on faith:* χ̃(Δ_P), χ̃(N) and χ̃(Δ(C(G))) computed independently agree at C₄ (1), C₆ (−2), S₃ (−8) and A₄ (−30).

> **Where "proper" enters, since it is easy to read as a bookkeeping adjustment.** It is not one; it is in the **definition** of both objects and is what makes either non-trivial. Allow H = G and: (i) G is a coset of itself, every subset lies in it, Δ_P becomes the **full simplex on |G| vertices** — contractible, and the property becomes true everywhere, so not a property at all; (ii) the coset poset acquires a **top element**, so its order complex is a cone — contractible. *Both computed.* Properness is exactly what makes the property nontrivial in the evasiveness sense (∅ ∈ P, G ∉ P) and the complex something other than a point. The Euler characteristic is then whatever it is; no adjustment is applied at the end.

**One convention worth stating, since it is where sign errors live.** χ̃ is the *reduced* Euler characteristic, counting the empty face: χ̃ = −1 + Σ over nonempty faces of (−1)^{|F|−1}. Brown's identity is **P(G, −1) = −χ̃(Δ(C(G)))**, so a contractible complex would give χ̃ = 0 and P(G,−1) = 0. That is why "χ̃ ≠ 0" and "not contractible" are the same requirement here, and why non-evasiveness — which forces collapsibility, hence contractibility — is excluded by either.

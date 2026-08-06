# Small-degree verification: n = 10 and n = 12

*Everything pursued for its own sake at a single small degree — the GAP battery, the SAT/CSP machinery, the backbone probes, the template enumerator. Split out of `pending-checks.md` so that file can be about the arithmetic programme.*

**Relevance to §§1–6 of `orbital-evasiveness-notes.md`.** Almost none. The one exception is **item 5** below (exhaustiveness of the GAP stages), which is what licenses the two non-circular comparisons the arithmetic programme cites: the n = 10 battery (967 groups, max m\* = 20 = B(10)) and the n = 12 battery (7,115 groups, max m\* = 18 = B(12)), plus the Lemma B/C spot-check at n = 10 (1,061 full-capacity orbits, all of prime-power size; all 88 prime-sized ones satisfying B′'s condition). Those appear in Part I of `enumeration-proof.md` and §2.4 of the notes.

**The direction of that dependence matters.** A group missed by the stages could only have *larger* m\*, which would be a counterexample to μ(n) ≤ B(n) rather than a silent corruption of it. So incomplete enumeration weakens the *evidence* without creating an error. If item 5 cannot be closed, the claim "the exhaustive optimum is the predicted construction" has to weaken to "no group in the enumerated set exceeds B(n)" — a real loss, since this is the only non-circular check in the framework, but not a retraction.

---

## Commands

These read `ckpt_groups.pkl`, `ckpt_catalog.pkl`, `ckpt_order.pkl` from the working directory; `n` is implicit in `groups_out.txt` rather than a flag.

```bash
# items 1+2  rebuild the n = 12 battery with the corrected dedup key.
#   --maxgroups IS REQUIRED.  It defaults to 200 and silently truncates.
#   Stage-3 VF2 sampling is automatic (--verify, default 3000).
#   No manual cleanup: changing any flag changes the selection signature and
#   stage 1 deletes ckpt_groups/catalog/order itself.  Do NOT pre-delete them.
#   READ ITEM 5b FIRST -- stage 3 at full size is a multi-week run and may not be needed.
python3 consume_gap.py --infile groups_out.txt --maxgroups 1000 --maxt 8 --procs 8

# does groups_out.txt predate the multi-top-prime change to ark_gap.g?
awk -F'|' '$3 ~ /\+/' groups_out.txt | wc -l    # 0 => pre-change, or no group has two usable q

# item 3  involution pressure points
python3 probe_backbone.py --classes 393,401,405,108,437,439,457,493

# item 4  the 54 CAP classes at a larger budget
python3 probe_backbone.py --classes <the 54 CAP ids> --nodecap 20000000
```

**Needs code or data that does not exist:** item 7 (dedup-collision audit at n = 10) has no CLI entry point and needs an n = 10 `groups_out.txt`, which is not in the working set. Item 4's class list is not recorded anywhere machine-readable and must be re-extracted from the probe record first.

---

## 1. Rebuild the n = 12 battery with the corrected dedup key

`consume_gap.py`'s stage-1 key was an incomplete invariant that merged inequivalent orbital partitions; the corrected key is a pynauty canonical form on a layered graph. The battery must be rebuilt before any n = 12 verdict is quoted.

*State as of the 2026-07 run (log and checkpoints on file).* Stage 1 rebuilt correctly on the signature change with no manual cleanup, and stage 2 completed: **2,293 raw → 230 distinct (partition, prime) conditions → 227 kept (200 Oliver + 27 p-groups), 2,212 catalogue classes**. μ(12) = 18 survives: m\* = 18 is attained by **3 distinct conditions**, the previously reported 8 groups collapsing under the corrected dedup. Stage 3 then reported **1,018,719 of 4,890,732 ordered pairs needing VF2 (20.8%)**.

**Two problems with that run, both to fix before repeating it.**

*(i) The battery was truncated.* `--maxgroups` defaults to 200 and stage 1 found 203 distinct Oliver conditions, so `sel = ol[:maxgroups] + pg` silently dropped 3. The sort is `(-mstar, t)`, so the casualties are the lowest-m\* conditions — harmless for μ(12) = 18, which reads off the top, but the battery feeds the Smith/χ computation where every condition is a constraint. Dropping constraints makes the system easier to satisfy, so a negative verdict would survive but a positive one would not be quotable. **Always pass `--maxgroups 1000`.**

*(ii) Stage 3 at full size is a multi-week run.* The old 600-class battery needed 74,213 VF2 pairs; the new 2,212-class battery needs 1,018,719 — 13.7×. Measured from the logs across three resumed sessions: 2,176 VF2 calls, 30,002 s, 16,061 pairs resolved → 7.4 pairs/call at 13.8 s/call, with yield decaying as the easy pairs go first (13.5 → 3.6 → 5.4). Extrapolating: **22 days** at the early rate, **33–41 days** at the late rate. The old battery never finished either — four sessions took it 22% of the way.

Levers, in order of preference: **settle item 5b first**, since the EGF route may make stage 3 unnecessary; failing that, `--maxt 6` drops the t = 7 and t = 8 groups (44 + 58 of 227) and cuts pairs to roughly 30%, still about a week and a weaker battery.

## 2. Stage-3 sample verification at n = 12

Now automatic, folded into the item-1 run (`--verify`, default 3000 random ordered pairs re-decided by VF2). The n = 10 acceptance test was bit-identical agreement with an archived full-VF2 reference; there is no such reference at any other degree, and roughly 80% of ordered pairs are settled by inference alone. Until this passes, the n = 12 order matrix is an unchecked implementation of checked rules.

## 3. Settle the duality involution empirically

`probe_backbone.py` computes the complement class of every forced class and reports violations plus the specific unprobed complements the theorem predicts. Three pressure points in the current n = 10 record, all cheap to close:

- the three forced-OUT classes at 38 edges (393, 401, 405) require three forced-IN classes at 7 edges, and the only 7-edge class probed (**class 108**) came back **free**. If 108 is the complement of any of the three, **the theorem is contradicted**; if not, the partners are unprobed.
- the five forced-IN classes at 8 edges require five forced-OUT at 37 edges; no 37-edge class has been probed.
- the forced-IN class at 2 edges requires a forced-OUT at 43; no 43-edge class has been probed.

The practical corollary — probe one representative per complement pair, halving the sweep — is currently being relied on without this check.

## 4. Re-probe the 54 CAP classes at a larger node budget

They sit at 12–36 edges, concentrated at 24, 28, 30, 33, 34, i.e. through the middle of the free band. A CAP class is *not* free. The log shows `--nodecap` was already raised from 5×10⁶ to 2×10⁷ partway through the sweep, so the earlier CAPs may resolve without a new idea. Until then no statement of the form "the band is free from 11 to 34 edges" is supported.

## 5. Exhaustiveness of the four GAP stages

*Partially discharged.* Only the Oliver-condition test and the emission logic of `ark_gap.g` have been read. `IsOliverTop` is **sound** — taking Γ₂ = `PCore(N,p)` is WLOG since any normal p-subgroup with cyclic quotient lies in O_p(N) and the quotient is then a quotient of a cyclic group; normality in Γ is automatic because O_p(N) is characteristic in N with N ◁ Γ.

**5a. The subdirect-product hole.** The four stages are: **A** every transitive group of degree N via `TransitiveGroup(N,k)`; **B** every partition of N with each part carrying an independently chosen transitive group, generators embedded blockwise; **B2** every wreath product T(d,k) ≀ T(r,j) with dr = N; **C** for each prime p ≤ N, the conjugacy classes of subgroups of a Sylow p-subgroup of S_N. The union is **not** obviously exhaustive over intransitive imprimitive groups: stage B builds direct products of transitive constituents, so an intransitive group whose projections are transitive but which is a *proper subdirect* product — a fibre product over a common quotient — is generated by neither B nor B2, and C only reaches it if it happens to be a p-group. **That is the concrete gap to close or refute.**

**5b. Did stage C finish?** `ConjugacyClassesSubgroups(SylowSubgroup(S_N, 2))` is the expensive step and is explicitly noted in the file as non-checkpointable at N = 10, so any claim of completeness at N = 12 depends on that call having finished. Check the logs. Mitigating for the headline: p-subgroups do not attain the optimum at n = 12 — the eight attainers sit at q = 2 and q = 3 — so m\* = 18 is fairly robust to this specific gap even if it is open.

## 6. The lcm strengthening is implemented but unexercised

`IsOliverTop` now returns every usable top prime as a `+`-separated tag and the solvers enforce χ ≡ 1 mod lcm. Single-prime tags parse identically, so old files behave exactly as before — which also means **the new path has never run**. It needs one GAP re-emission and a check that some group actually receives a multi-prime tag before the strengthening can be claimed.

## 7. Dedup-collision audit at n = 10

The measurement in §8.7′ of the notes was made at n = 12 because that `groups_out.txt` was to hand. The same audit at n = 10 would say how much the *published* n = 10 SAT was affected, which matters for how the skeleton and the χ kill should be described.

## 8. `Catalog.classify` is a mutating lookup used as a pure query

In `stage4_fast.py`, `probe_backbone.py` and `chi_test.py` the idiom `x[cat.classify(set())] = 1` assumes the empty graph is already in the catalog. If it were not, `classify` would **append**, silently extending `cat.reps` and desynchronising `V` from the order matrix. The same hazard applies to the complement lookups in the involution check, which is why that block asserts the catalog did not grow. **Unverified, latent.** A `classify_or_fail` variant used everywhere the catalog is meant to be read-only would close it permanently.

## 9. `mono` is only ever called on representatives with the same vertex count

The complement trick in `ark_intersect.mono` rests on σ(E_H) ⊆ E_G ⟺ σ⁻¹(E_Ḡ) ⊆ E_H̄, which requires σ to be a **bijection** — true when H and G both carry all n vertices, false for a genuine injection. Every catalog representative does carry all n vertices, so the call sites are fine. **Sound, but undefended.** An assertion on the vertex counts inside `mono` would make it safe against reuse.

## 10. `TemplateGroup` places the block rotation in the cyclic middle layer

§2.4's implementation note describes the defect as a spurious gcd(d, k) = 1 filter plus a prime-only k, and both symptoms are visible in `candidate_groups`. They are not the cause. `TemplateGroup`'s own chain model puts the rotation in Γ₁/Γ₂ — its docstring requires d, the foreign primes and s pairwise coprime — and separately enforces k = s with s prime. Theorem 2.4 places the rotation in the top q-group, whence any d | c−1 is admissible and k need only be a prime power. Consequence: the template misses μ(10) = 20 (k = 2, d = 10) and μ(12) = 18 (k = 4).

**Do not repair this in the enumerator alone.** Relaxing the filter builds groups that `TemplateGroup` marks invalid, and an unconditional `break` over the twist candidates then discards the smaller d that had been working — n = 22 fell from 110 to 55. That change was reverted. The `break` bug is genuine and independent and has been fixed (break only after a valid group is actually produced); with it fixed and the filter restored, the template reproduces Run 1 exactly at n = 6, 10, 12, 15, 18, 21, 22, 26 (6, 10, 10, 30, 36, 28, 110, 78). The real repair is to move the rotation into the top layer inside `TemplateGroup`, updating its Oliver validity check and `desc_parts`, which also changes what `top_prime` parses. **Open, deliberately deferred** — the GAP path has no such restriction and supersedes this enumerator, so the value is in correctness of the record rather than in better μ bounds.

## 11. Decide how S will be computed at n = 12

`chi_test.py` enumerates the full down-closure with a canonicalisation per node: 64,333 classes and about 60 s at n = 10, against `--cap 5000000`. At n = 12 the ambient count is 1.65 × 10¹¹ iso classes and the closure of an 18-edge-or-larger generator set may well exceed the cap. The global χ test is the only test that has actually killed anything, so losing it at n = 12 would be a real loss. The alternative is the §8.4 route — exponential formula over signed connected-component weights, two-sort EGF for bipartite components — which computes S without enumerating the closure. **A design decision, not a bug.**

**This gates item 1.** Stage 3 of `consume_gap.py` exists to supply the containment-order matrix, and projects to 22–41 days. So the question is not merely *how* to compute S but **whether the order matrix is needed at all**: if the EGF route computes χ without it, weeks of stage 3 are avoidable. Decide before relaunching item 1, and if the EGF route wins, consider a `--stop-after 2` flag so the battery can be built without entering stage 3.

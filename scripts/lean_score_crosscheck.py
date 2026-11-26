#!/usr/bin/env python3
"""Cross-check the Lean scoring model against the Python scorers.

Generates random configurations (characteristic prime p, top prime q, up to two
p-characteristic classes with F blocks of size p^b, up to three distinct foreign
primes with twist the full q-part of r - 1), and compares, configuration by
configuration, the FULL sorted list of terms -- not just the minimum, which
would hide a mis-scored term that does not bind:

  * Lean `E6.Config`: SAFE terms  (parts.flatMap safeTerms ++ crossN sizes)
                      REFINED terms (refinedTerms with char2 = (p = 2))
  * `mu_enumerate_v3.value` in SAFE and in refined mode (Lemma C strip),
    whose term list is captured by intercepting its final min().

and, separately and much faster, the minimum from `validate_table_v3.score`
against `mu_enumerate_v3.value` (SAFE).

Lean input: a REFINED class is passed as `.pc F c d` with d = strip(c - 1,
foreign primes), which is how the enumerator applies Lemma C; a foreign part as
`.fr r (qpart(r - 1, q))`, the twist-maximal choice (R2).

Usage:  python3 lean_score_crosscheck.py [--n 4000] [--seed 1] [--bias]
                                         [--validate 20000]
Run from anywhere; needs `lake` on PATH and a built lean/ project.
--bias makes the foreign primes divide c - 1 often, so Lemma C changes terms.
"""
import argparse, builtins, os, random, re, subprocess, sys, types

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import mu_enumerate_v3 as m  # noqa: E402

ap = argparse.ArgumentParser()
ap.add_argument("--n", type=int, default=4000)
ap.add_argument("--seed", type=int, default=1)
ap.add_argument("--bias", action="store_true")
ap.add_argument("--validate", type=int, default=20000)
A = ap.parse_args()

spf = m.sieve_spf(5000)
primes = [x for x in range(2, 300) if m.is_prime(x, spf)]


def py_terms(p, q, parts, safe):
    m.SAFE = safe
    m.min = (lambda *a: sorted(a[0]) if len(a) == 1 and isinstance(a[0], list)
             else builtins.min(*a))
    try:
        sel = [m.Part(F, 1, c, k == "fr", q, p, spf) for k, F, c in parts]
        return m.value(sel, p, spf, q)
    finally:
        m.min = builtins.min


def random_config(rng, bias):
    p = rng.choice([2, 3, 5, 7, 11, 13])
    q = rng.choice([2, 3, 5, 7])
    parts = [("pc", rng.randint(1, 7), p ** rng.randint(1, 3))
             for _ in range(rng.randint(0, 2))]
    pool = [r for r in primes if r != p and r < 120]
    if bias and parts:
        cdiv = [r for r in primes if r != p and (parts[0][2] - 1) % r == 0]
        frs = rng.sample(cdiv, min(len(cdiv), rng.randint(1, 2))) if cdiv else []
        frs += rng.sample([r for r in pool if r not in frs], rng.randint(0, 2))
    else:
        frs = rng.sample(pool, rng.randint(0, 3))
    parts += [("fr", 1, r) for r in frs]
    rng.shuffle(parts)
    return p, q, parts


def lean_check():
    rng = random.Random(A.seed)
    cases = []
    while len(cases) < A.n:
        p, q, parts = random_config(rng, A.bias)
        if not parts:
            continue
        s = py_terms(p, q, parts, True)
        if s is None:
            continue
        rf = py_terms(p, q, parts, False)
        fs = [c for k, F, c in parts if k == "fr"]
        lp = [f".pc {F} {c} {m.strip(c - 1, fs)}" if k == "pc"
              else f".fr {c} {m.qpart(c - 1, q)}" for k, F, c in parts]
        cases.append((p, q, lp, s, rf))
    path = os.path.join(ROOT, "lean", "CmpScore.lean")
    with open(path, "w") as f:
        f.write("import E6\nopen E6\n\n")
        for k in range(0, len(cases), 100):
            f.write(f"def cases{k} : List Config := [\n")
            f.write(",\n".join(f"  ⟨{p}, {q}, [{', '.join(lp)}]⟩"
                               for p, q, lp, _, _ in cases[k:k + 100]))
            f.write(f"\n]\n#eval (cases{k}.forM fun C => IO.println "
                    "s!\"S {(C.parts.flatMap CPart.safeTerms ++ crossN C.sizes).mergeSort}"
                    "|R {(C.parts.flatMap (CPart.refinedTerms (decide (C.p = 2))) ++ "
                    "crossN C.sizes).mergeSort}\")\n\n")
    try:
        out = subprocess.run(["lake", "env", "lean", "CmpScore.lean"],
                             cwd=os.path.join(ROOT, "lean"), capture_output=True,
                             text=True).stdout
    finally:
        os.remove(path)
    got = re.findall(r"S \[([\d, ]*)\]\|R \[([\d, ]*)\]", out)
    got = [([int(x) for x in a.split(", ") if x], [int(x) for x in b.split(", ") if x])
           for a, b in got]
    if len(got) != len(cases):
        print(f"FAIL: Lean printed {len(got)} rows for {len(cases)} cases")
        print(out[:2000])
        return False
    bad = [(i, cases[i], g) for i, g in enumerate(got) if g != (cases[i][3], cases[i][4])]
    lemc = sum(1 for c in cases if c[3] != c[4])
    print(f"Lean vs mu_enumerate_v3: {len(cases)} configurations, "
          f"{lemc} where Lemma C changes a term, {len(bad)} mismatches")
    for b in bad[:5]:
        print("  ", b)
    return not bad


def validate_check():
    src = open(os.path.join(HERE, "validate_table_v3.py")).read()
    src = src[:src.index("def main():")].replace("A = ap.parse_args()",
                                                  "A = ap.parse_args(['dummy'])")
    v = types.ModuleType("vt")
    exec(compile(src, "validate_table_v3", "exec"), v.__dict__)
    rng = random.Random(A.seed + 1000)
    n = bad = 0
    while n < A.validate:
        p, q, parts = random_config(rng, False)
        if not parts:
            continue
        m.SAFE = True
        a = m.value([m.Part(F, 1, c, k == "fr", q, p, spf) for k, F, c in parts], p, spf, q)
        if a is None:
            continue
        b = v.score(types.SimpleNamespace(p=p, q=q, cls=[(F, c, k == "fr") for k, F, c in parts]))
        n += 1
        bad += a != b
    print(f"validate_table_v3.score vs mu_enumerate_v3.value: {n} configurations, {bad} mismatches")
    return bad == 0


ok = lean_check()
ok = validate_check() and ok
sys.exit(0 if ok else 1)

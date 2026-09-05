"""offmenu_scan.py TABLE.csv -- score the configurations the LADDER MENU does not contain -- two foreign
primes with or without a matching class -- at every tabulated n, and compare
against B(n).  Only 'efficient' foreign primes matter: r = k*q^e + 1 with k <= 12
(eta >= 1/6), since a two-foreign shape needs both blocks above C(n,2)/25 and a
part of share y needs eta*y^2 > 1/25 with y < 1/2, hence eta > 4/25."""
import csv, sys
from math import comb, isqrt
from collections import defaultdict
TABLE = sys.argv[1] if len(sys.argv) > 1 else "mu_table_exact.csv"
_rows0 = list(csv.DictReader(open(TABLE)))
N = max(int(r["n"]) for r in _rows0)
sieve = bytearray([1])*(N+1); sieve[0]=sieve[1]=0
for i in range(2, isqrt(N)+1):
    if sieve[i]: sieve[i*i::i] = bytearray(len(sieve[i*i::i]))
def pp(x):
    if x < 2: return None
    p = 2
    while p*p <= x:
        if x % p == 0:
            while x % p == 0: x //= p
            return p if x == 1 else None
        p += 1
    return x
PPset = {c for c in range(2, N) if pp(c)}
def orb(r, t): return min(r*t if t % 2 else r*t//2, comb(r, 2))
# efficient primes grouped by top prime q: r = k*q^e + 1, k <= 12, q not | k
byq = defaultdict(list)
for r in range(3, N):
    if not sieve[r]: continue
    m = r - 1
    for q in range(2, 40):
        if not sieve[q] or m % q: continue
        t, x = 1, m
        while x % q == 0: x //= q; t *= q
        if x <= 12:
            byq[q].append((r, t))
rows = {int(r["n"]): int(r["mu_bound"]) for r in _rows0}
best = {}   # n -> (score, desc)
def upd(n, v, d):
    if n in rows and (n not in best or v > best[n][0]): best[n] = (v, d)
for q, lst in byq.items():
    lst.sort()
    for i, (r1, t1) in enumerate(lst):
        for r2, t2 in lst[i+1:]:
            if r1 + r2 >= N: break
            f = min(orb(r1, t1), orb(r2, t2), r1 * r2)
            n = r1 + r2
            upd(n, f, f"S6 {r1}*+{r2}* q={q}")
            # hybrid: one matching block c (prime power, twist full since fallback-free needed:
            # skip if r1|c-1 or r2|c-1), c in a window that could matter
            if 25 * f < comb(n, 2): continue          # even without c it is below 1/25 -- c only adds terms
            lo, hi = n // 5, n           # c >= n/5 for its own intra to clear 1/25 of the total
            for c in range(max(3, (r1 + r2) // 4), N - n):
                if c not in PPset: continue
                if (c - 1) % r1 == 0 or (c - 1) % r2 == 0 or pp(c) in (r1, r2): continue
                nn = n + c
                if nn > N: break
                v = min(f, comb(c, 2), c * r1, c * r2)
                if 25 * v < comb(nn, 2): continue
                upd(nn, v, f"{c}+{r1}*+{r2}* q={q}")
wins = [(n, v, rows[n], d) for n, (v, d) in best.items() if v >= rows[n]]
close = sorted(((v / rows[n], n, v, rows[n], d) for n, (v, d) in best.items()), reverse=True)
print(f"off-menu configurations scored at {len(best)} tabulated n")
print(f"off-menu >= B (would make ladder < B): {len(wins)}")
for w in wins[:10]: print("  ", w)
print("closest approaches (offmenu/B):")
for r, n, v, B, d in close[:12]: print(f"  {r:.4f}  n={n} off={v} B={B}  {d}")
above = [(n, v/comb(n,2)) for n,(v,d) in best.items() if 25*v > comb(n,2)]
print(f"off-menu configs above 1/25: {len(above)}; max off-menu density {max(v/comb(n,2) for n,(v,d) in best.items()):.4f}")

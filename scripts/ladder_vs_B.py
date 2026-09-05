"""Compare the ladder's per-n lower bound against B(n) at EVERY tabulated n, not
only at the worklist values, and characterise every shortfall."""
import sys, csv, importlib.util, re
from math import comb
sys.argv = ["ladder_verify.py", "37000"]
spec = importlib.util.spec_from_file_location("lv", "/home/claude/out/ladder_verify.py")
lv = importlib.util.module_from_spec(spec)
import builtins
_real_print = builtins.print
builtins.print = lambda *a, **k: None       # silence the module's own report
try:
    spec.loader.exec_module(lv)
except SystemExit:
    pass
builtins.print = _real_print
rows = list(csv.DictReader(open("/home/claude/mu_table_exact2.csv")))
short, eq = [], 0
for r in rows:
    n = int(r["n"]); B = int(r["mu_bound"]); C = comb(n, 2)
    d = lv.achieved(n, stop_at=None)
    lad = int(d * C + 1e-9)
    if lad >= B - 1:
        eq += 1
    else:
        short.append((n, lad, B, B / max(lad, 1), r["witness"].split("(")[0].strip()))
print("HI_X =", lv.HI_X)
print(f"joined {len(rows)} values; ladder tight at {eq}, short at {len(short)}")
short.sort(key=lambda t: -t[3])
print("worst 15 by ratio B/ladder:")
for n, lad, B, ratio, w in short[:15]:
    print(f"  n={n:6d} ladder={lad:9d} B={B:9d} ratio={ratio:.3f}  {w}")
import collections
print("shortfall count by witness shape (parts x kind):")
def shape(w):
    ps = re.findall(r"(\d+)x(\d+)(\*?)", w)
    return "+".join(f"{f}x{'r' if s else 'c'}" for f, c, s in ps)
print(collections.Counter(shape(w) for *_, w in short).most_common(10))
print("shortfall by n mod 12:", sorted(collections.Counter(n % 12 for n, *_ in short).items()))

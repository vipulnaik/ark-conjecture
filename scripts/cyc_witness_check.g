# cyc_witness_check.g -- build three witnesses of threshold_scan.py as permutation groups
# (threshold-beyond-mu.md, "Cost of computing each quantity"): one-foreign shapes n = F*c + r with c prime,
# full twist on the matching blocks, foreign twist of q-power order.  Checks Oliver-ness and prints the
# orbitals, against which the Proposition's M = min(C(r,2), least orbital outside the block) is read.
# Run from scripts/:  gap -q cyc_witness_check.g
Read("ws_oliver.g");
Build := function(F, c, r, q, g, h)   # c prime here; F copies fused by an entangled F-cycle when F>1
  local n, gens, tr, tw, z, i, perm, trr, twr, o, sizes, d;
  n := F*c + r;
  gens := [];
  # translations on each block independently
  for i in [0..F-1] do Add(gens, PermList(Concatenation([1..i*c], List([0..c-1], x -> i*c + ((x+1) mod c) + 1), [i*c+c+1..n]))); od;
  # entangled generator: block i -> i+1, multiplier g on the last step (F=1: plain twist)
  perm := [1..n];
  for i in [0..F-1] do
    for d in [0..c-1] do
      if i < F-1 then perm[i*c + d + 1] := (i+1)*c + d + 1; else perm[i*c+d+1] := ((g*d) mod c) + 1; fi;
    od; od;
  Add(gens, PermList(perm));
  # foreign: translations and a twist of order q (multiplier h)
  Add(gens, PermList(Concatenation([1..F*c], List([0..r-1], y -> F*c + ((y+1) mod r) + 1))));
  Add(gens, PermList(Concatenation([1..F*c], List([0..r-1], y -> F*c + ((h*y) mod r) + 1))));
  return Group(gens);
end;
Check := function(F, c, r, q)
  local g, h, G, o, n;
  g := PrimitiveRootMod(c); h := PowerModInt(PrimitiveRootMod(r), (r-1)/q^PValuation(r-1,q), r);
  G := Build(F, c, r, q, g, h); n := F*c + r;
  o := List(OrbitsDomain(G, Combinations([1..n], 2), OnSets), Length);
  Print("n = ", n, " = ", F, "x", c, " + ", r, "*, q = ", q, ": |G| = ", Size(G), ", Oliver: ", OliverData(G) <> fail,
        ", orbital sizes ", Collected(o), ", min ", Minimum(o), "\n");
end;
Check(1, 43, 41, 5);
Check(2, 23, 31, 5);
Check(1, 41, 29, 7);
QUIT;

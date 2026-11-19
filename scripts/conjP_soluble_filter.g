# conjP_soluble_filter.g -- Conjecture P, Step 5: for each primitive group N listed by conjP_prim_scan.g, decide whether
# N contains a soluble transitive Gamma with Gamma-hat >= L = Socle(N), i.e. every Gamma-orbital contains an L-orbital
# (necessary for N <= N*(Gamma) with N* primitive of the same socle; see threshold-beyond-mu.md §6.3 Step 5).
# Necessary: |Gamma| >= n * dmax(L), dmax = the largest suborbit of L.  Search: descend through classes of maximal
# subgroups, pruning every subgroup of order < n * dmax; at a soluble transitive subgroup test the orbital condition.
# Natural A_k / S_k actions with k > KMAX are skipped (handled by hand in the note).
# usage: one group per GAP process, via conjP_soluble_filter.sh (hard wall-clock limit per group);
#        LINE ("n i" from a line of /tmp/conjP_prim.txt) and OUTF are set on the command line.
KMAX := 12;; TLIM := 600000;;   # ms per group
lines := [LINE];;   # LINE = "n i"
out := OutputTextFile(OUTF, true);; SetPrintFormattingStatus(out, false);;
OK := function(G, L, n)   # every G-orbital contains an L-orbital through the same pair
  local Gx, Lx, o;
  Gx := Stabilizer(G, 1); Lx := Stabilizer(L, 1);
  for o in Orbits(Lx, [2..n]) do
    if not IsSubset(Orbit(Gx, o[1]), o) then return false; fi;
  od;
  return true;
end;;
for ln in lines do
  if ln = "" then continue; fi;
  v := SplitString(ln, " ");
  n := Int(v[1]); i := Int(v[2]);
  N := PrimitiveGroup(n, i);
  # Gamma-hat is a nontrivial normal subgroup of N*, so it contains a minimal normal subgroup of N*.  For types HS and
  # HC (GAP "3a", "4b") there are two; test against each and accept if either works.
  Ls := Filtered(MinimalNormalSubgroups(N), M -> not IsSolvableGroup(M));
  for L in Ls do
  d := Maximum(List(Orbits(Stabilizer(L, 1), [2..n]), Length));
  bound := n * d;
  if IsNaturalAlternatingGroup(L) = false and IsSimpleGroup(L) and IsAlternatingGroup(L) and
     NrMovedPoints(L) > 0 and Size(L) > Factorial(KMAX) / 2 then
    AppendTo(out, n, " ", i, " skipped-large-alt ", bound, "\n"); break;
  fi;
  if Size(N) / bound > 10^9 then AppendTo(out, n, " ", i, " skipped-index ", Size(N), " ", bound, "\n"); break; fi;
  found := fail; seen := 0; t0 := Runtime();
  stack := [N];
  while Length(stack) > 0 and found = fail and Runtime() - t0 < TLIM do
    H := Remove(stack);
    seen := seen + 1;
    if IsSolvableGroup(H) then
      if IsTransitive(H, [1..n]) and OK(H, L, n) then found := H; break; fi;
    fi;
    if IsTransitive(H, [1..n]) then
      for M in List(ConjugacyClassesMaximalSubgroups(H), Representative) do
        if Size(M) >= bound and IsTransitive(M, [1..n]) then Add(stack, M); fi;
      od;
    fi;
  od;
  if found <> fail then res := Concatenation("FOUND ", String(Size(found)));
  elif Length(stack) = 0 then res := "none";
  else res := "timeout"; fi;
  AppendTo(out, n, " ", i, " ", res, " ", bound, " ", seen, " \"", Name(N), "\" minnormal ", Position(Ls, L), "/", Length(Ls), "\n");
  od;
od;
CloseStream(out);
QUIT;

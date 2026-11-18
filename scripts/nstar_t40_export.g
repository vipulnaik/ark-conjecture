# nstar_t40_export.g -- degree 40: for every soluble transitive group, the orbital index of each of the 780 pairs
# (pairs in Combinations([1..40],2) order), one line per group, to /tmp/g/t40.txt, for nstar_t40.py.
# threshold-beyond-mu.md section 7, "Small n" (the n = 40 gap).  Run: gap -q -o 8g nstar_t40_export.g
LoadPackage("transgrp");;
n := 40;; P := Combinations([1..n], 2);;
out := OutputTextFile("/tmp/g/t40.txt", false);; SetPrintFormattingStatus(out, false);
for i in [1..NrTransitiveGroups(n)] do
  G := TransitiveGroup(n, i);
  if not IsSolvableGroup(G) then continue; fi;
  O := Orbits(G, P, OnSets);
  lab := List(P, p -> PositionProperty(O, o -> p in o));
  AppendTo(out, i, "|", JoinStringsWithSeparator(List(lab, String), ","), "\n");
  if i mod 5000 = 0 then Print(i, "\n"); fi;
od;
CloseStream(out); QUIT;

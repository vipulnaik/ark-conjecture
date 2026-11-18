# nstar_transitive_check.g -- export the orbitals of every soluble transitive group of degree n
# (by default non-prime-power n <= 30 except 24; edit the degree list for 24, 33-46) to /tmp/g/tr<n>.txt
# for nstar_transitive_check.py, which takes the degrees as arguments.
# threshold-beyond-mu.md §6.3, "The fixed-point-free part".  Run: gap -q nstar_transitive_check.g
LoadPackage("transgrp");;
for n in [6,10,12,14,15,18,20,21,22,26,28,30] do
  out:=OutputTextFile(Concatenation("/tmp/g/tr",String(n),".txt"),false);; SetPrintFormattingStatus(out,false);
  for i in [1..NrTransitiveGroups(n)] do
    G:=TransitiveGroup(n,i);
    if not IsSolvableGroup(G) then continue; fi;
    O:=List(Orbits(G,Combinations([1..n],2),OnSets),o->List(o,ShallowCopy));
    PrintTo(out,i,"|",O,"\n");
    AppendTo(out,"");
  od;
  CloseStream(out);
  Print(n," done\n");
od;
QUIT;

# socle_2homog_check.g -- every 2-homogeneous primitive group of non-prime-power degree 5..2500,
# natural A_a and S_a skipped: is its socle 2-homogeneous?  (threshold-beyond-mu.md section 7)
LoadPackage("primgrp");;
cnt:=0;;
for a in [5..2500] do
  if IsPrimePowerInt(a) then continue; fi;
  for i in [1..NrPrimitiveGroups(a)] do
    G:=PrimitiveGroup(a,i);
    if IsNaturalAlternatingGroup(G) or IsNaturalSymmetricGroup(G) then continue; fi;
    if Size(G) < a*(a-1)/2 then continue; fi;
    if Length(Orbit(G,[1,2],OnSets)) <> a*(a-1)/2 then continue; fi;
    cnt:=cnt+1; T:=Socle(G);
    Print(a," ",i," ",Name(G),"  socle 2-homogeneous: ",Length(Orbit(T,[1,2],OnSets)) = a*(a-1)/2,"\n");
  od;
od;
Print("done; 2-homogeneous non-natural primitive groups of non-prime-power degree 5..2500: ",cnt,"\n");
QUIT;

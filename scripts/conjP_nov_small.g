# conjP_nov_small.g -- almost simple primitive groups H of non-prime-power degree m <= 1000 whose socle T is imprimitive
# (novelty point stabiliser), as components of product actions (threshold-beyond-mu.md §6.3).  For each, decide whether
# H has a soluble transitive subgroup Y with T <= TwoClosure(Y): descent through classes of maximal subgroups, keeping
# transitive subgroups of order >= m (no pruning by suborbits, since T may be far from Y).
# usage: gap -q conjP_nov_small.g -> ../outputs/conjP_nov_small.txt
if not IsBound(MSTART) then MSTART := 5; fi;   # resume: set MSTART first; output is appended when MSTART > 5
out := OutputTextFile("../outputs/conjP_nov_small.txt", MSTART > 5);; SetPrintFormattingStatus(out, false);;
for m in [MSTART..1000] do
  if IsPrimePowerInt(m) then continue; fi;
  for i in [1..NrPrimitiveGroups(m)] do
    H := PrimitiveGroup(m, i);
    if ONanScottType(H) <> "2" then continue; fi;
    T := Socle(H);
    if IsPrimitive(T, [1..m]) then continue; fi;
    found := []; stack := [H]; seen := 0;
    while Length(stack) > 0 do
      XX := Remove(stack); seen := seen + 1;
      if IsSolvableGroup(XX) then
        if IsTransitive(XX, [1..m]) then Add(found, IsSubgroup(TwoClosure(XX), T)); fi;
        continue;   # Y <= XX gives TwoClosure(Y) <= TwoClosure(XX) (Y's orbitals refine XX's), so X decides all its subgroups
      fi;
      for M in List(ConjugacyClassesMaximalSubgroups(XX), Representative) do
        if Size(M) >= m and IsTransitive(M, [1..m]) then Add(stack, M); fi;
      od;
    od;
    AppendTo(out, m, " ", i, " \"", Name(H), "\" solubleTransitiveMaximalSoluble=", Length(found),
      " anyWithTinClosure=", true in found, " visited=", seen, "\n");
  od;
od;
CloseStream(out);
QUIT;

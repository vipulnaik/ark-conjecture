# smith_pgroups.g -- p-subgroups of S_n for the Smith-bound survey (threshold-beyond-mu.md §6.2):
# Sylow p-subgroups at 28 (n, p), and random subgroups of the Sylow (1-3 random generators, 300 tries per (n, p),
# seed 17, kept when they have at most 18 orbitals and a new (orbital sizes, order) pair).  Writes the
# orbitals to /tmp/sy/syl.txt and /tmp/sy/rnd.txt; smith_pgroups.py computes s_Q for each.
out:=OutputTextFile("/tmp/sy/syl.txt",false);; SetPrintFormattingStatus(out,false);
for pr in [[12,2],[12,3],[18,2],[18,3],[20,2],[20,5],[24,2],[24,3],[30,2],[30,3],[30,5],[36,2],[36,3],[40,2],[40,5],[45,3],[45,5],[48,2],[48,3],[50,5],[54,3],[56,2],[63,3],[72,2],[72,3],[75,5],[80,2],[96,2]] do
  n:=pr[1]; p:=pr[2];
  P:=SylowSubgroup(SymmetricGroup(n),p);
  O:=List(Orbits(P,Combinations([1..n],2),OnSets),o->List(o,ShallowCopy));
  PrintTo(out,n," ",p," ",Size(P),"|",O,"\n"); AppendTo(out,"");
od;
out:=OutputTextFile("/tmp/sy/rnd.txt",false);; SetPrintFormattingStatus(out,false);
Reset(GlobalMersenneTwister, 17);;
for pr in [[10,5],[12,2],[12,3],[14,7],[15,3],[15,5],[18,3],[20,2],[20,5],[21,3],[21,7],[22,11],[24,2],[24,3],[26,13],[28,7],[30,3],[30,5],[33,11],[35,5],[35,7],[36,3],[39,13],[40,5],[42,7],[44,11]] do
  n:=pr[1]; p:=pr[2]; P:=SylowSubgroup(SymmetricGroup(n),p); seen:=[];
  for trial in [1..300] do
    k:=Random([1,1,2,2,3]);
    H:=Group(List([1..k],i->Random(P)));
    if Size(H)=1 then continue; fi;
    O:=List(Orbits(H,Combinations([1..n],2),OnSets),o->List(o,ShallowCopy));
    if Length(O)>18 then continue; fi;
    key:=SortedList(List(O,Length));
    if ForAny(seen, s->s=[key, Size(H)]) then continue; fi;
    Add(seen,[key,Size(H)]);
    PrintTo(out,n," ",p," ",Size(H),"|",O,"\n");
  od;
  Print(n," ",p," ",Length(seen),"\n");
od;
CloseStream(out); QUIT;

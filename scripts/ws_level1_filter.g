# ws_level1_filter.g -- the general level-1 criterion (threshold-beyond-mu.md section 13) on the transitive groups
# that the weakly-symmetric scan left without a transitive Oliver subgroup (orbital-evasiveness-notes.md section 7.13).
# For each Oliver subgroup H of G: its orbits on the m coordinates, its condition (OliverData), and the action of
# the partition stabiliser N*_G(H) on the orbits.  Writes /tmp/ws/lvl1.txt for ws_level1_filter.py.  Run from scripts/.
Read("ws_oliver.g");
out := OutputTextFile("/tmp/ws/lvl1.txt", false);; SetPrintFormattingStatus(out, false);
for pr in [[10,7],[10,26],[10,31],[12,162],[14,10],[14,30]] do
  m := pr[1]; G := TransitiveGroup(m, pr[2]);
  for H in List(ConjugacyClassesSubgroups(G), Representative) do
    d := OliverData(H);
    if d = fail then continue; fi;
    orbs := Set(List(OrbitsDomain(H,[1..m]), Set));
    if Length(orbs) > 16 then continue; fi;
    S := Stabilizer(G, orbs, OnSetsSets);
    gens := List(GeneratorsOfGroup(S), g -> List(orbs, o -> Position(orbs, Set(OnSets(o, g)))));
    AppendTo(out, m, "|", pr[2], "|", Size(H), "|", ReplacedString(String(d[1])," ",""), "|",
      ReplacedString(String(d[2])," ",""), "|", ReplacedString(String(List(orbs,Length))," ",""), "|",
      ReplacedString(String(gens)," ",""), "\n");
  od;
  Print(m, "T", pr[2], " done\n");
od;
CloseStream(out); QUIT;

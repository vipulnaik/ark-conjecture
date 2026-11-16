# ws_level2_battery.g -- export 14T10 and 14T30 with their Oliver subgroup classes for ws_level2_battery.py. Run from scripts/.
Read("ws_oliver.g");
out := OutputTextFile("/tmp/ws/g14.txt", false);; SetPrintFormattingStatus(out, false);
for k in [10, 30] do
  G := TransitiveGroup(14, k);
  AppendTo(out, "G|", k, "|", ReplacedString(String(List(GeneratorsOfGroup(G), g -> ListPerm(g, 14)))," ",""), "\n");
  for H in List(ConjugacyClassesSubgroups(G), Representative) do
    d := OliverData(H);
    if d = fail then continue; fi;
    AppendTo(out, "H|", k, "|", Size(H), "|", ReplacedString(String(d[1])," ",""), "|", ReplacedString(String(d[2])," ",""), "|",
      ReplacedString(String(List(OrbitsDomain(H,[1..14]), Set))," ",""), "\n");
  od;
od;
CloseStream(out); QUIT;

LoadPackage("tomlib");
Dump := function(n, tmax, file)
  local tom, G, out, i, H, orbs, c;
  tom := TableOfMarks(Concatenation("S", String(n))); G := UnderlyingGroup(tom);
  out := OutputTextFile(file, false); SetPrintFormattingStatus(out, false); c := 0;
  for i in [1..Length(OrdersTom(tom))] do
    H := RepresentativeTom(tom, i);
    if Size(H) > 1 and IsPGroup(H) and not IsCyclic(H) then
      orbs := Orbits(H, Combinations([1..n],2), OnSets);
      if Length(orbs) <= tmax then c := c + 1;
        AppendTo(out, String(Size(H)), "|", String(PrimePGroup(H)), "|", ReplacedString(String(orbs)," ",""), "\n");
      fi;
    fi;
  od;
  CloseStream(out); Print("n = ", n, ": ", c, " non-cyclic p-subgroup classes with <= ", tmax, " orbitals\n");
end;
Dump(6, 99, "/tmp/g/ncp6.txt");
Dump(10, 11, "/tmp/g/ncp10.txt");
QUIT;

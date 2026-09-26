Read("/tmp/g/ws_oliver.g");
G := TransitiveGroup(12,162);
Print("12T162: order ", Size(G), ", structure ", StructureDescription(G), ", transitive ", IsTransitive(G,[1..12]), "\n");
cls := List(ConjugacyClassesSubgroups(G), Representative);
tr := Filtered(cls, H -> IsTransitive(H,[1..12]));
Print("transitive subgroup classes: ", Length(tr), "; of them Oliver: ", Number(tr, H -> OliverData(H) <> fail), "\n");
for H in cls do
  d := OliverData(H); orbs := Orbits(H,[1..12]);
  if d <> fail and Length(orbs) = 2 and Length(orbs[1]) = 6 then
    A := Set(orbs[1]); B := Set(orbs[2]); g := RepresentativeAction(G, A, B, OnSets);
    if g <> fail then
      Print("LOOP: H order ", Size(H), " (", StructureDescription(H), "), Oliver reading exact=", d[1], " qs=", d[2],
            "\n   orbits A = ", A, ", B = ", B, "\n   g = ", g, " maps A to ", OnSets(A,g), "\n");
    fi;
  fi;
od;
QUIT;

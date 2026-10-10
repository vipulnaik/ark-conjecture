# coset_template_orbits.g -- for each SmallGroup of order NN, the regular (left-multiplication) action, and the
# left-invariant set systems of the "coset template": every member other than the empty set lies in a left coset
# gH of a subgroup H in a chosen class (KIND = "cyclic": proper cyclic subgroups; "all": all proper subgroups).
# Prints, per group, the G-orbits on such sets (plus the empty set and G itself) as bitmasks, if at most MAXO.
SizeScreen([4096, 24]);
coset := function(el, g, H) return List(AsList(H), h -> Position(el, g*h)); end;
leftmul := function(el, g) return PermList(List(el, x -> Position(el, g*x))); end;
for k in [1..NrSmallGroups(NN)] do
  G := SmallGroup(NN, k); el := Elements(G);
  if KIND = "cyclic" then subs := Filtered(Flat(List(ConjugacyClassesSubgroups(G), AsList)), H -> IsCyclic(H) and Size(H) < NN);
  else subs := Filtered(Flat(List(ConjugacyClassesSubgroups(G), AsList)), H -> Size(H) < NN); fi;
  sets := Set(Concatenation(List(subs, H -> Concatenation(List(el, g -> Combinations(coset(el, g, H)))))));
  sets := Filtered(sets, s -> Length(s) > 0);
  perms := List(GeneratorsOfGroup(G), g -> leftmul(el, g));
  A := Group(perms);
  orbs := Orbits(A, sets, OnSets);
  orbs := Concatenation([[[]], [[1..NN]]], orbs);
  if Length(orbs) <= MAXO then
    Print("G ", k, " ", ReplacedString(StructureDescription(G), " ", ""), " ", Length(orbs), " ", List(orbs, o -> List(o, s -> Sum(s, i -> 2^(i-1)))), "\n");
  else Print("# ", k, " ", StructureDescription(G), " skipped: ", Length(orbs), " orbits\n"); fi;
od;
QUIT;

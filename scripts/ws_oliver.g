# Oliver subgroup classes of a transitive group G on [1..m], with condition and orbits on points.
OupperQ := function(Q, q)
  local rs, S;
  if Size(Q) = 1 then return Q; fi;
  rs := Filtered(PrimeDivisors(Size(Q)), r -> r <> q);
  S := Subgroup(Q, Concatenation(List(rs, r -> GeneratorsOfGroup(SylowSubgroup(Q, r)))));
  return NormalClosure(Q, S);
end;
OliverData := function(G)
  local ps, exact, qs, ntq, p, q, Q, O;
  ps := Set(Concatenation([2,3,5,7,11,13], PrimeDivisors(Maximum(2,Size(G)))));
  exact := false; qs := []; ntq := [];
  for p in ps do
    Q := Image(NaturalHomomorphismByNormalSubgroup(G, PCore(G,p)));
    if IsCyclic(Q) then exact := true; fi;
    for q in ps do
      O := OupperQ(Q,q);
      if IsCyclic(O) then AddSet(qs,q); if Size(O) < Size(Q) then AddSet(ntq,q); fi; fi;
    od;
  od;
  if not exact and qs = [] then return fail; fi;
  return [exact, qs, ntq];
end;
WSExport := function(G, m, file)
  local out, H, d, c;
  out := OutputTextFile(file, false); SetPrintFormattingStatus(out, false); c := 0;
  for H in List(ConjugacyClassesSubgroups(G), Representative) do
    d := OliverData(H);
    if d <> fail then c := c + 1;
      AppendTo(out, String(Size(H)), "|", ReplacedString(String(d[1])," ",""), "|",
        ReplacedString(String(d[2])," ",""), "|", ReplacedString(String(d[3])," ",""), "|", ReplacedString(String(OrbitsDomain(H,[1..m]))," ",""), "\n");
    fi;
  od;
  CloseStream(out);
  Print(file, ": |G| = ", Size(G), ", ", Length(ConjugacyClassesSubgroups(G)), " subgroup classes, ", c, " Oliver\n");
end;

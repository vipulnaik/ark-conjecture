Read("/tmp/g/ws_oliver.g");
res := [];
for deg in [12..14] do
  ncand := 0;
  for k in [1..NrTransitiveGroups(deg)] do
    G := TransitiveGroup(deg, k);
    if Size(G) > 5000 then continue; fi; if k mod 50 = 0 then Print("progress deg ", deg, " T", k, "\n"); fi;
    cls := List(ConjugacyClassesSubgroups(G), Representative);
    if ForAny(cls, H -> IsTransitive(H, [1..deg]) and OliverData(H) <> fail) then continue; fi;
    half := Filtered(cls, H -> OliverData(H) <> fail and ForAll(Orbits(H,[1..deg]), o -> Length(o) = deg/2) and Length(Orbits(H,[1..deg])) = 2);
    # graph on G-orbits of half-sets
    reps := []; edges := []; loop := false; A := 0; B := 0;
    for H in half do
      A := Set(Orbits(H,[1..deg])[1]); B := Difference([1..deg], A);
      ia := PositionProperty(reps, r -> RepresentativeAction(G, r, A, OnSets) <> fail);
      if ia = fail then Add(reps, A); ia := Length(reps); fi;
      ib := PositionProperty(reps, r -> RepresentativeAction(G, r, B, OnSets) <> fail);
      if ib = fail then Add(reps, B); ib := Length(reps); fi;
      if ia = ib then loop := true; fi;
      Add(edges, [ia, ib]);
    od;
    # bipartiteness by BFS 2-colouring
    col := List(reps, x -> 0); odd := false;
    for s in [1..Length(reps)] do
      if col[s] = 0 then col[s] := 1; queue := [s];
        while queue <> [] do v := Remove(queue, 1);
          for e in edges do
            for pair in [[e[1],e[2]],[e[2],e[1]]] do
              if pair[1] = v then
                if col[pair[2]] = 0 then col[pair[2]] := -col[v]; Add(queue, pair[2]);
                elif col[pair[2]] = col[v] then odd := true; fi;
              fi;
            od;
          od;
        od;
      fi;
    od;
    Add(res, [deg, k, Size(G), Length(half), loop, odd]);
    Print("deg ", deg, " T", k, " |G|=", Size(G), ": no transitive Oliver subgroup; half-split Oliver classes ", Length(half),
          "; loop ", loop, "; odd cycle ", odd, " -> ", (function() if loop or odd then return "BI-RESISTANCE CLOSES THE GAP"; else return "bi-resistance possible"; fi; end)(), "\n");
  od;
  Print("degree ", deg, ": ", ncand, " groups (order <= 50000) with no transitive Oliver subgroup\n");
od;
QUIT;

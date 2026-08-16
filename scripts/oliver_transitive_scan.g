LoadPackage("transgrp");;

# An Oliver group is p-by-cyclic-by-q, hence SOLVABLE.  So only solvable
# subgroups can qualify, which is what keeps the search affordable.
IsOliverGroup := function(G)
  local N, p, q, Q, o, pr;
  if Size(G) = 1 then return false; fi;
  if not IsSolvableGroup(G) then return false; fi;
  for N in NormalSubgroups(G) do
    Q := Size(G) / Size(N);
    if Q = 1 then
      q := 1;
    else
      pr := PrimeDivisors(Q);
      if Length(pr) <> 1 then continue; fi;
    fi;
    if IsCyclic(N) then return true; fi;
    for p in PrimeDivisors(Size(N)) do
      o := PCore(N, p);
      if IsCyclic(N / o) then return true; fi;
    od;
  od;
  return false;
end;

# Returns "yes", "no", or "unresolved".
HasTransitiveOliverSubgroup := function(G, n)
  local c, x, p, S, cc, H;
  # (1) G itself.
  if IsOliverGroup(G) then return "yes"; fi;
  # (2) A regular cyclic subgroup: an n-cycle.  Cyclic => Oliver, trivial top.
  # (element iteration rather than conjugacy classes: the class machinery
  #  needs the SmallGroups identification for almost-simple groups)
  if Size(G) <= 2000000 then
    for x in G do
      if Order(x) = n and IsTransitive(Group(x), [1..n]) then return "yes"; fi;
    od;
  else
    for c in [1..400] do
      x := Random(G);
      if Order(x) = n and IsTransitive(Group(x), [1..n]) then return "yes"; fi;
    od;
  fi;
  # (3) A transitive Sylow p-subgroup: a p-group is Oliver (G2 = itself).
  for p in PrimeDivisors(n) do
    S := SylowSubgroup(G, p);
    if IsTransitive(S, [1..n]) then return "yes"; fi;
  od;
  # (4) Full lattice -- only affordable, and only needed, for solvable G.
  if IsSolvableGroup(G) then
    cc := ConjugacyClassesSubgroups(G);
    for c in cc do
      H := Representative(c);
      if Size(H) >= n and IsTransitive(H, [1..n]) and IsOliverGroup(H) then
        return "yes";
      fi;
    od;
    return "no";
  fi;
  return "unresolved";
end;

Print("deg | #trans | no transitive Oliver subgroup | unresolved (insoluble)\n");
for n in [4..14] do
  bad := [];  unk := [];
  ntr := NrTransitiveGroups(n);
  for i in [1..ntr] do
    r := HasTransitiveOliverSubgroup(TransitiveGroup(n, i), n);
    if r = "no" then Add(bad, i); elif r = "unresolved" then Add(unk, i); fi;
  od;
  Print(n, " | ", ntr, " | ", Length(bad), " ", bad, " | ", Length(unk), "\n");
od;
QUIT;

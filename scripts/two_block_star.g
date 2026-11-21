# two_block_star.g -- star for nlevel_star.py on two blocks of prime-power sizes A and B (n = A + B):
# hub H = translations of GF(A) x translations of GF(B); overgroups = every subgroup of AGL(1,A) x AGL(1,B)
# containing H that has an Oliver reading.  Readings: P = O_p(G) for each p, then a cyclic normal C of G/P with
# (G/P)/C a q-group; exact ('e') if some C = G/P, else 'q..' listing the top primes.  usage: set A, B, fname.
AGLperm := function(q, shift)
  local F, els, tr, mu;
  F := GF(q); els := Elements(F);
  tr := PermList(List(els, x -> Position(els, x + One(F))));
  mu := PermList(List(els, x -> Position(els, PrimitiveRoot(F) * x)));
  return [tr, mu, List(els, x -> Position(els, x + PrimitiveRoot(F)))];   # unused third
end;;
Shift := function(perm, deg, off, n)
  return PermList(Concatenation([1..off], List([1..deg], i -> off + i^perm), [off+deg+1..n]));
end;;
Readings := function(G)
  local tops, p, P, Q, hom, C, ok, exact;
  tops := []; exact := false;
  for p in Set(Factors(Size(G))) do
    P := PCore(G, p); hom := NaturalHomomorphismByNormalSubgroup(G, P); Q := Image(hom);
    if IsCyclic(Q) then exact := true; fi;
    for C in NormalSubgroups(Q) do
      if IsCyclic(C) and Size(C) < Size(Q) and IsPrimePowerInt(Size(Q) / Size(C)) then
        AddSet(tops, SmallestRootInt(Size(Q) / Size(C)));
      fi;
    od;
  od;
  if exact then return "e"; fi;
  if tops = [] then return fail; fi;
  return Concatenation("q", JoinStringsWithSeparator(List(tops, String), ","));
end;;
n := A + B;;
ga := AGLperm(A, 0);; gb := AGLperm(B, A);;
tA := Shift(ga[1], A, 0, n);; mA := Shift(ga[2], A, 0, n);;
tB := Shift(gb[1], B, A, n);; mB := Shift(gb[2], B, A, n);;
# for prime-power A, B the translation group needs all of GF(A)'s additive generators
TA := Group(List(Basis(GF(A)), b -> Shift(PermList(List(Elements(GF(A)), x -> Position(Elements(GF(A)), x + b))), A, 0, n)));;
TB := Group(List(Basis(GF(B)), b -> Shift(PermList(List(Elements(GF(B)), x -> Position(Elements(GF(B)), x + b))), B, A, n)));;
H := ClosureGroup(TA, TB);;
Big := ClosureGroup(H, [mA, mB]);;
hom := NaturalHomomorphismByNormalSubgroup(Big, H);;
subs := List(AllSubgroups(Image(hom)), S -> PreImage(hom, S));;
SortBy(subs, Size);
out := OutputTextFile(fname, false);; SetPrintFormattingStatus(out, false);;
AppendTo(out, "N ", Size(Big), " ", List(GeneratorsOfGroup(Big), g -> ListPerm(g, n)), "\n");
cnt := 0;;
for K in subs do
  r := Readings(K);
  if r <> fail then
    cnt := cnt + 1;
    AppendTo(out, "K ", Size(K), " false ", r, " ", List(GeneratorsOfGroup(K), g -> ListPerm(g, n)), "\n");
  fi;
od;
CloseStream(out); Print(n, " ", Length(subs), " subgroups, ", cnt, " Oliver\n"); QUIT;

# burnside_marks.g -- marks of the subgroup classes of S_n on the graph classes (burnside-ring-view.md).
# For each conjugacy class of subgroups G of S_n: whether G is trivial-top Oliver (p-by-cyclic: some p with G/O_p(G)
# cyclic), and for each isomorphism class C of graphs on [n] the SIGNED count s_G(C) = sum over G-invariant graphs H in
# C of (-1)^(number of G-orbits of edges in H - 1).  Then chi(Delta_P^G) = sum over nonempty C in P of s_G(C): the
# fixed complex has the G-orbits of edges as vertices.  (This is the mark at G of the equivariant Euler characteristic
# of Delta_P in the Burnside ring B(S_n); it is NOT the mark of sum (-1)^(e-1) [C].)  Graphs are edge sets of K_n, encoded as bitmasks over the edges in lexicographic order.
# usage: echo 'N := 6;;' > in.g; gap -q in.g burnside_marks.g -> /tmp/marks_N.txt
EDG := Combinations([1..N], 2);; m := Length(EDG);;
S := SymmetricGroup(N);;
edgeperm := function(g) return PermList(List(EDG, e -> Position(EDG, OnSets(e, g)))); end;;
# orbit representatives of S_n on graphs = canonical classes: run over all 2^m masks once, record class index
SE := Group(List(GeneratorsOfGroup(S), edgeperm));;
subsets := List([0..2^m - 1], x -> Filtered([1..m], i -> QuoInt(x, 2^(i-1)) mod 2 = 1));;
classof := ListWithIdenticalEntries(2^m, 0);; reps := [];;
for x in [0..2^m - 1] do
  if classof[x + 1] = 0 then
    Add(reps, x); orb := Orbit(SE, subsets[x + 1], OnSets);
    for s in orb do classof[Sum(s, i -> 2^(i-1)) + 1] := Length(reps); od;
  fi;
od;
out := OutputTextFile(Concatenation("/tmp/marks_", String(N), ".txt"), false);; SetPrintFormattingStatus(out, false);;
AppendTo(out, "classes ", Length(reps), "\n");
for r in reps do AppendTo(out, "C ", r, " ", Length(subsets[r + 1]), "\n"); od;
for cl in ConjugacyClassesSubgroups(S) do
  G := Representative(cl);
  if Size(G) = 1 then tt := true; else tt := ForAny(Set(Factors(Size(G))), p -> IsCyclic(G / PCore(G, p))); fi;
  GE := Group(Concatenation([()], List(GeneratorsOfGroup(G), edgeperm)));
  mk := ListWithIdenticalEntries(Length(reps), 0);
  # G-invariant graphs = unions of G-orbits on edges
  orbs := Orbits(GE, [1..m]);
  for k in [0..2^Length(orbs) - 1] do
    s := Concatenation(List(Filtered([1..Length(orbs)], i -> QuoInt(k, 2^(i-1)) mod 2 = 1), i -> orbs[i]));
    c := classof[Sum(s, i -> 2^(i-1)) + 1];
    if k > 0 then mk[c] := mk[c] + (-1)^(Number([1..Length(orbs)], i -> QuoInt(k, 2^(i-1)) mod 2 = 1) - 1); fi;
  od;
  AppendTo(out, "G ", Size(G), " ", tt, " ", IsTransitive(G, [1..N]), " ", mk, "\n");
od;
CloseStream(out);
QUIT;

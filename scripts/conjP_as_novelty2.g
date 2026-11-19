# conjP_as_novelty2.g -- companion to conjP_as_novelty.g for the socles whose extensions have no maxes in CtblLib:
# L3(4), L3(8), U3(8), L4(3), A6.  Build Aut(L) as a permutation group, take every G with L <= G <= Aut(L), every
# maximal K of G with K cap L not maximal in L (novelty), of index n > 1000, and apply the Hall test: a soluble
# transitive Gamma has n | |Gamma|; for primes r, s | n with r^a || |G|, s || |G| (s to the first power), s not
# dividing r^i - 1 (i <= a) and r not dividing s - 1, a Hall {r, s}-subgroup of Gamma contains an element of order rs.
# If G has none, there is no soluble transitive Gamma.  usage: LIST := [[group, "label"], ...] set first; gap -q list.g conjP_as_novelty2.g -> ../outputs/conjP_as_novelty2.txt (appends)
out := OutputTextFile("../outputs/conjP_as_novelty2.txt", true);; SetPrintFormattingStatus(out, false);;
hall := function(G, n)
  local r, s, a, f, ords;
  f := Collected(Factors(Size(G)));
  ords := Set(List(ConjugacyClasses(G), c -> Order(Representative(c))));
  for r in Set(Factors(n)) do for s in Set(Factors(n)) do
    if r = s then continue; fi;
    a := First(f, x -> x[1] = r)[2];
    if First(f, x -> x[1] = s)[2] = 1 and ForAll([1..a], i -> (r^i - 1) mod s <> 0) and (s - 1) mod r <> 0
       and not ForAny(ords, o -> o mod (r * s) = 0) then return [r, s]; fi;
  od; od;
  return fail;
end;;
KL := fail;;
for LL in LIST do L0 := LL[1];
  A := AutomorphismGroup(L0); iso := IsomorphismPermGroup(A); P := Image(iso); L := Socle(P);
  hom := NaturalHomomorphismByNormalSubgroup(P, L);
  for C in List(ConjugacyClassesSubgroups(Image(hom)), Representative) do
    G := PreImage(hom, C);
    for K in List(ConjugacyClassesMaximalSubgroups(G), Representative) do
      if IsSubgroup(K, L) then continue; fi;
      n := Index(G, K); KL := Intersection(K, L);
      nov := not ForAny(List(ConjugacyClassesMaximalSubgroups(L), Representative),
                        M -> Size(M) = Size(KL) and IsConjugate(L, M, KL));
      if nov and n > 1000 then
        AppendTo(out, LL[2], " |L|=", Size(L), " |G:L|=", Index(G, L), " |K|=", Size(K), " deg=", n, " solubleK=", IsSolvableGroup(K),
          " hall=", hall(G, n), "\n");
      fi;
    od;
  od;
od;
CloseStream(out);
QUIT;

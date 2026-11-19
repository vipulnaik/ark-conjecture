# conjP_prim_scan.g -- Conjecture P, Step 5 (threshold-beyond-mu.md §6.3): primitive groups N with non-abelian socle,
# of non-prime-power degree n, not 2-homogeneous, whose smallest orbit on 2-sets exceeds n(q(n) - 1)/2
# (q(n) = largest prime-power divisor of n).  Only these could be N*(Gamma) for a counterexample.
# usage: gap -q conjP_prim_scan.g  (degrees DMIN..DMAX set below) -> /tmp/conjP_prim.txt
DMIN := 5;; DMAX := 1000;;
qn := function(n) return Maximum(List(Collected(Factors(n)), x -> x[1]^x[2])); end;;
out := OutputTextFile("/tmp/conjP_prim.txt", false);; SetPrintFormattingStatus(out, false);;
for n in [DMIN..DMAX] do
  if IsPrimePowerInt(n) then continue; fi;
  B := n * (qn(n) - 1) / 2;
  for i in [1..NrPrimitiveGroups(n)] do
    G := PrimitiveGroup(n, i);
    if IsSolvableGroup(Socle(G)) then continue; fi;
    if IsNaturalAlternatingGroup(G) or IsNaturalSymmetricGroup(G) then continue; fi;
    S := Stabilizer(G, 1);
    sub := Filtered(Orbits(S, [2..n]), o -> true);
    if Length(sub) = 1 then continue; fi;              # 2-transitive
    m := infinity;
    for o in sub do
      # unordered-pair orbit through {1, x}: size n*d/2 if self-paired, n*d otherwise
      x := o[1]; g := RepresentativeAction(G, [1, x], [x, 1], OnTuples);
      if g = fail then sz := n * Length(o); else sz := n * Length(o) / 2; fi;
      m := Minimum(m, sz);
    od;
    if m = n * (n - 1) / 2 then continue; fi;          # 2-homogeneous
    if m > B then
      AppendTo(out, n, " ", i, " ", PrimitiveIdentification(G) = i, " ", ONanScottType(G), " ",
        Length(sub) + 1, " ", m, " ", B, " ", List(sub, Length), " \"", Name(G), "\"\n");
    fi;
  od;
od;
CloseStream(out);
QUIT;

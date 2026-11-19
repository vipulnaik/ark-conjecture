# ws_blockdata.g -- per-block Oliver data for the merged-class gap rows (merged_threshold_close.py).
# Reads /tmp/ws/blocks_m.txt: lines "a c t d" (Gamma_X = T x| <w^c, w^d phi^t> <= AGammaL(1,a), t = e: no phi).
# For each prime p (p = 0: any prime not dividing |Gamma_X|), Q = Gamma_X / O_p(Gamma_X); writes whether Q is
# cyclic and |Q|, and for each prime q | |Q| whether O^q(Q) is cyclic and |O^q(Q)|.  Uses OupperQ of ws_oliver.g.
Read("ws_oliver.g");
inp := InputTextFile("/tmp/ws/blocks_m.txt"); out := OutputTextFile("/tmp/ws/blockdata_m.txt", false);
SetPrintFormattingStatus(out, false);
line := ReadLine(inp);
while line <> fail do
  v := List(SplitString(Chomp(line), " "), Int); a := v[1]; c := v[2]; t := v[3]; d := v[4];
  F := GF(a); els := AsList(F); w := Z(a); p := Characteristic(F); e := DegreeOverPrimeField(F);
  pf := x -> PermList(List(els, y -> Position(els, x(y))));
  gens := List([0..e-1], i -> pf(y -> y + w^i));
  Add(gens, pf(y -> w^c * y));
  if t < e then Add(gens, pf(y -> w^d * y^(p^t))); fi;
  G := Group(gens);
  ps := Concatenation([0], PrimeDivisors(Size(G)));
  for pp in ps do
    if pp = 0 then Q := G; else Q := Image(NaturalHomomorphismByNormalSubgroup(G, PCore(G, pp))); fi;
    s := Concatenation(String(a)," ",String(c)," ",String(t)," ",String(d)," ",String(pp)," ",
         String(IsCyclic(Q))," ",String(Size(Q)));
    for q in PrimeDivisors(Maximum(2, Size(Q))) do
      if Size(Q) = 1 then break; fi;
      O := OupperQ(Q, q);
      s := Concatenation(s, " ", String(q), ":", String(IsCyclic(O)), ":", String(Size(O)));
    od;
    AppendTo(out, s, "\n");
  od;
  line := ReadLine(inp);
od;
CloseStream(out); QUIT;

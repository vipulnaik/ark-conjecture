# conjP_as_novelty_chk.g -- decide the cases conjP_as_novelty.g marks "novelty=false" by order alone, index > 1000.
# If K cap L < M < L with M maximal in L, then 1_M^L is a constituent of pi = (1_K^G)|_L = 1_{K cap L}^L.  So if
# pi - 1_M^L is not a character for every maximal M of L with |K cap L| dividing |M| properly, K cap L is maximal in L
# (not a novelty).  usage: gap -q conjP_as_novelty_chk.g -> ../outputs/conjP_as_novelty_chk.txt
LoadPackage("ctbllib");;
lines := Filtered(SplitString(StringFile("../outputs/conjP_as_novelty.txt"), "\n"), l -> PositionSublist(l, "novelty=false") <> fail);;
out := OutputTextFile("../outputs/conjP_as_novelty_chk.txt", false);; SetPrintFormattingStatus(out, false);;
for ln in lines do
  v := SplitString(ln, " ");
  deg := Int(SplitString(First(v, x -> StartsWith(x, "deg=")), "=")[2]);
  if deg <= 1000 then continue; fi;
  gname := v[1]; kname := v[2];
  tG := CharacterTable(gname); tK := CharacterTable(kname);
  sname := gname{[1..Position(gname, '.') - 1]};
  tL := CharacterTable(sname);
  pi := RestrictedClassFunction(InducedClassFunction(TrivialCharacter(tK), tG), tL);
  kl := Size(tK) * Size(tL) / Size(tG);
  cand := [];
  for m in Maxes(tL) do
    tM := CharacterTable(m);
    if Size(tM) > kl and Size(tM) mod kl = 0 then
      d := pi - InducedClassFunction(TrivialCharacter(tM), tL);
      if ForAll(Irr(tL), x -> ScalarProduct(tL, d, x) >= 0) then Add(cand, m); fi;
    fi;
  od;
  AppendTo(out, gname, " ", kname, " deg=", deg, " ", Length(cand) = 0, " overgroup candidates ", cand, "\n");
od;
CloseStream(out);
QUIT;

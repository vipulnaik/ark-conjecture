# conjP_as_novelty.g -- Conjecture P, Step 5, almost simple N* with an imprimitive socle (a novelty point stabiliser).
# By Li-Xia (arXiv:1408.0350, Thm 1.1 with Props 4.1, 4.3, 4.4 and Remark (i)), a soluble transitive subgroup forces
# the socle L to be primitive except for finitely many socles: Table 1.2 rows 6, 11 (L4(3), S4(3)); Prop 4.1(b) (L2(7),
# L2(11), L3(3), L3(4), L3(8), U3(8), U4(2), M11); Prop 4.3(f) (A6, A8); Table 4.3 (M11, M12, M22, M23, J2, HS, He, Suz).
# For every almost simple G with one of these socles whose table of marks / maxes is in CtblLib, list the maximal
# subgroups K != L with K cap L not of the order of any maximal subgroup of L (a novelty), with the degree |G:K|.
# usage: gap -q conjP_as_novelty.g -> ../outputs/conjP_as_novelty.txt
LoadPackage("ctbllib");;
socs := ["L2(7)","L2(11)","L3(3)","L3(4)","L3(8)","U3(8)","U4(2)","M11","L4(3)","A6","A8","M12","M22","M23","J2","HS","He","Suz"];;
out := OutputTextFile("../outputs/conjP_as_novelty.txt", false);; SetPrintFormattingStatus(out, false);;
all := AllCharacterTableNames();;
for s in socs do
  tL := CharacterTable(s);
  if not HasMaxes(tL) then AppendTo(out, s, ": no maxes for the simple group\n"); continue; fi;
  mo := List(Maxes(tL), x -> Size(CharacterTable(x)));
  exts := Filtered(all, x -> Length(x) > Length(s) and x{[1..Length(s)+1]} = Concatenation(s, "."));
  for e in exts do
    tG := CharacterTable(e);
    if tG = fail or not IsAlmostSimpleCharacterTable(tG) then continue; fi;
    if not HasMaxes(tG) then AppendTo(out, e, ": no maxes in CtblLib\n"); continue; fi;
    for m in Maxes(tG) do
      tK := CharacterTable(m); k := Size(tK);
      if k * Size(tL) = Size(tG) * Size(tL) / Size(tG) * Size(tG) then fi;
      if m = s then continue; fi;
      kl := k * Size(tL) / Size(tG);
      if not IsInt(kl) then continue; fi;       # K inside L would not be maximal in G unless K = L
      deg := Size(tG) / k;
      AppendTo(out, e, " ", m, " |K|=", k, " |KcapL|=", kl, " deg=", deg,
        " novelty=", not kl in mo, " solubleK=", IsSolvableCharacterTable(tK), "\n");
    od;
  od;
od;
CloseStream(out);
QUIT;

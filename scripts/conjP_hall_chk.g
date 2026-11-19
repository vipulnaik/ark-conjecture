# conjP_hall_chk.g -- the Hall test (conjP_as_novelty2.g) on the cases conjP_as_novelty_chk.g leaves inconclusive:
# a soluble transitive subgroup on n points has order divisible by n; if primes r, s | n with s exactly once in |G|,
# s not dividing r^i - 1 (r^a || |G|, i <= a) and r not dividing s - 1, it contains an element of order rs.
# usage: gap -q conjP_hall_chk.g -> ../outputs/conjP_hall_chk.txt
LoadPackage("ctbllib");;
lines := Filtered(SplitString(StringFile("../outputs/conjP_as_novelty_chk.txt"), "\n"), l -> PositionSublist(l, " false ") <> fail);;
out := OutputTextFile("../outputs/conjP_hall_chk.txt", false);; SetPrintFormattingStatus(out, false);;
for ln in lines do
  v := SplitString(ln, " "); tG := CharacterTable(v[1]); n := Int(SplitString(v[3], "=")[2]);
  f := Collected(Factors(Size(tG))); ords := Set(OrdersClassRepresentatives(tG)); res := fail;
  for r in Set(Factors(n)) do for s in Set(Factors(n)) do
    if r = s or res <> fail then continue; fi;
    a := First(f, x -> x[1] = r)[2];
    if First(f, x -> x[1] = s)[2] = 1 and ForAll([1..a], i -> (r^i - 1) mod s <> 0) and (s - 1) mod r <> 0
       and not ForAny(ords, o -> o mod (r * s) = 0) then res := [r, s]; fi;
  od; od;
  AppendTo(out, v[1], " ", v[2], " deg=", n, " ", Collected(Factors(n)), " hall=", res, "\n");
od;
CloseStream(out);
QUIT;

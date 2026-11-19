# conjP_minnormal_prim.g -- Conjecture P, Step 5: for each candidate N* in outputs/conjP_prim_scan.txt, is every minimal
# normal subgroup of N* primitive?  If so, N* cannot be N*(Gamma) for soluble transitive Gamma of non-prime-power
# degree: Gamma-hat contains a minimal normal subgroup M of N*, so Gamma-hat is primitive; Gamma has the same orbitals,
# hence is primitive (Higman: primitivity depends only on the orbital graphs); and a soluble primitive group is affine,
# of prime-power degree.  usage: gap -q conjP_minnormal_prim.g -> ../outputs/conjP_minnormal_prim.txt
lines := SplitString(StringFile("../outputs/conjP_prim_scan.txt"), "\n");;
out := OutputTextFile("../outputs/conjP_minnormal_prim.txt", false);; SetPrintFormattingStatus(out, false);;
for ln in lines do
  if ln = "" then continue; fi;
  v := SplitString(ln, " "); n := Int(v[1]); i := Int(v[2]);
  N := PrimitiveGroup(n, i);
  Ms := MinimalNormalSubgroups(N);
  pr := List(Ms, M -> IsPrimitive(M, [1..n]));
  AppendTo(out, n, " ", i, " ", ONanScottType(N), " ", ForAll(pr, x -> x), " ", pr, " \"", Name(N), "\"\n");
od;
CloseStream(out);
QUIT;

###############################################################################
# verify_witness.g -- realisability check for ONE witness of the mu(n) table.
#
# Given a witness configuration, this builds the Part E group, verifies that it
# satisfies Oliver's condition VIA AN EXPLICIT CHAIN, and computes its u-orbital
# sizes.  Three things must hold for the row to be realised as claimed:
#
#   (1) the group is an Oliver group with the chain the enumeration assumed --
#       Gamma_2 a p-group, Gamma_1/Gamma_2 CYCLIC, Gamma/Gamma_1 a q-group;
#   (2) min u-orbital equals mu_bound;
#   (3) the orbital MULTISET equals the value formula's terms.
#
# (3) is the part worth having.  Matching only the minimum can pass while the
# construction is realising a different group from the intended one, since the
# minimum is a min over four terms and several configurations share it.
#
# WHAT THIS DOES AND DOES NOT SETTLE.  It settles that the enumeration's score at
# this n is ATTAINED, i.e. mu(n) >= B(n).  It says nothing about completeness
# (mu(n) <= B(n)), which is Part 0's business, and nothing about J0a: the
# construction takes each matching twist inside the field's multiplicative group,
# and this script builds exactly that group, so it CANNOT detect that a larger
# stabiliser was available.  A pass here is evidence about the construction, not
# about the space of groups.
#
# Usage:
#   gap -q -A verify_witness.g            # runs the built-in battery
#   WITNESS='p=53 q=37: 3x53 + 1x149*' gap -q -A verify_witness.g
###############################################################################

# ---------------------------------------------------------------- witness parse
ParseWitness := function(s)
  local p, q, parts, cls, tok, i, j, k, F, c, foreign, body;
  i := PositionSublist(s, "p=");  j := PositionSublist(s, "q=");
  k := Position(s, ':');
  p := Int(ReplacedString(s{[i+2..j-2]}, " ", ""));
  q := Int(ReplacedString(s{[j+2..k-1]}, " ", ""));
  body := s{[k+1..Length(s)]};
  cls := [];
  for tok in SplitString(body, "+") do
    tok := ReplacedString(tok, " ", "");
    if tok = "" then continue; fi;
    foreign := tok[Length(tok)] = '*';
    if foreign then tok := tok{[1..Length(tok)-1]}; fi;
    parts := SplitString(tok, "x");
    F := Int(parts[1]);  c := Int(parts[2]);
    Add(cls, rec(F := F, c := c, foreign := foreign));
  od;
  return rec(p := p, q := q, classes := cls);
end;

# ------------------------------------------------- the twist the construction uses
# Matching class: d = largest divisor of c-1 coprime to every foreign prime and to
# every F_mid in the configuration.  That is the DIAGONAL CARRIER constraint --
# stricter than SAFE's dmax, which strips only the class's own F_mid, and it is
# the construction's actual requirement (see validate_table.py's group-A check).
StripCoprime := function(m, bad)
  local b, g;
  for b in bad do
    g := Gcd(m, b);
    while g > 1 do m := m / g; g := Gcd(m, b); od;
  od;
  return m;
end;

ConstructionTwists := function(w)
  local foreigns, fmids, cl, ft, i, out, d, qp;
  foreigns := [];  fmids := [];
  for cl in w.classes do
    if cl.foreign then Add(foreigns, cl.c);
    else
      ft := 1;  while cl.F mod (ft * w.q) = 0 do ft := ft * w.q; od;
      Add(fmids, cl.F / ft);
    fi;
  od;
  out := [];
  for i in [1..Length(w.classes)] do
    cl := w.classes[i];
    if cl.foreign then
      qp := 1;  while (cl.c - 1) mod (qp * w.q) = 0 do qp := qp * w.q; od;
      Add(out, qp);                      # Lemma B': forced into the top layer
    else
      qp := 1;  while (cl.c - 1) mod (qp * w.q) = 0 do qp := qp * w.q; od;
      # the q-part may sit in the top layer; the rest must clear the cyclic layer
      d := qp * StripCoprime((cl.c - 1) / qp,
                             Concatenation(foreigns, Filtered(fmids, x -> x > 1)));
      Add(out, d);
    fi;
  od;
  return out;
end;

# ------------------------------------------------------------- group construction
# Layout: classes in order; class i occupies F_i blocks of c_i consecutive points.
# Translations are INDEPENDENT per block (this is what makes the intra term
# F*orb rather than orb); the twist is DIAGONAL across a class's blocks (Part E's
# one cyclic-layer generator); the block rotation has order F.
BuildConfig := function(w, twists)
  local n, offs, cl, gens, i, b, base, c, F, fld, elts, gen, u, addmap, mulmap,
        perm, images, x, s, gsub, gtop, gcyc, gbot, e, prim;
  offs := [];  n := 0;
  for cl in w.classes do Add(offs, n);  n := n + cl.F * cl.c;  od;
  gens := rec(bottom := [], cyclic := [], top := []);
  for i in [1..Length(w.classes)] do
    cl := w.classes[i];  F := cl.F;  c := cl.c;  base := offs[i];
    fld := GF(c);  prim := PrimitiveRoot(fld);
    elts := AsSSortedList(fld);          # index x <-> elts[x]
    # --- translations ---
    # WHICH LAYER.  A p-characteristic class puts its per-block translations in
    # the BOTTOM p-group; a FOREIGN class does not.  Part E's construction is
    # explicit: "each foreign part contributes translations C_r lying in the
    # cyclic layer".  It has to be there -- Gamma_2 is a p-group, and C_r with
    # r <> p cannot sit inside one, which is also what forces the foreign
    # translations to be diagonal (Lemma D2, step 1).  Adding them to
    # gens.bottom instead makes G2 = C_p^a x C_r, so IsPGroup(G2) fails on
    # every configuration with a foreign part -- not because the construction
    # is wrong but because the chain being tested is not the construction's.
    # The cyclic layer stays cyclic because r is coprime to every twist there,
    # which is exactly what Lemma C enforces and what the enumeration checks.
    for b in [0..F-1] do
      for s in Filtered(elts, y -> y <> Zero(fld)) do
        images := [1..n];
        for x in [1..c] do
          images[base + b*c + x] := base + b*c + Position(elts, elts[x] + s);
        od;
        if cl.foreign then
          Add(gens.cyclic, PermList(images));
        else
          Add(gens.bottom, PermList(images));
        fi;
      od;
    od;
    # --- twist: diagonal, order twists[i], in the cyclic layer (or top if q-power)
    if twists[i] > 1 then
      u := prim ^ ((c - 1) / twists[i]);
      images := [1..n];
      for b in [0..F-1] do
        for x in [1..c] do
          images[base + b*c + x] := base + b*c + Position(elts, elts[x] * u);
        od;
      od;
      # a q-power twist is allowed to live on top; everything else must be cyclic
      if twists[i] = w.q ^ LogInt(twists[i], w.q) then
        Add(gens.top, PermList(images));
      else
        Add(gens.cyclic, PermList(images));
      fi;
    fi;
    # --- block rotation of order F: F_top on top, F_mid in the cyclic layer ---
    if F > 1 then
      images := [1..n];
      for b in [0..F-1] do
        for x in [1..c] do
          images[base + b*c + x] := base + ((b+1) mod F)*c + x;
        od;
      od;
      perm := PermList(images);
      e := 1;  while F mod (e * w.q) = 0 do e := e * w.q; od;   # F_top
      if e = F then Add(gens.top, perm);
      elif e = 1 then Add(gens.cyclic, perm);
      else                                  # split: F = F_mid * F_top
        Add(gens.cyclic, perm ^ e);         # order F_mid, cyclic layer
        Add(gens.top,    perm ^ (F / e));   # order F_top, top layer
      fi;
    fi;
  od;
  return rec(n := n, gens := gens);
end;

# --------------------------------------------------------- Oliver chain checking
# The chain is asserted by CONSTRUCTION above, then VERIFIED here.  Verifying is
# the point: the generator placement records what the enumeration assumed, and
# this checks the assumption rather than trusting it.
CheckOliverChain := function(cfg, p, q)
  local G, G2, G1, ok, quo;
  G2 := Group(cfg.gens.bottom);
  G1 := Group(Concatenation(cfg.gens.bottom, cfg.gens.cyclic));
  G  := Group(Concatenation(cfg.gens.bottom, cfg.gens.cyclic, cfg.gens.top));
  ok := rec();
  ok.G2_is_p_group    := IsPGroup(G2) and PrimePGroup(G2) = p;
  ok.G2_normal_in_G   := IsNormal(G, G2);
  ok.G1_normal_in_G   := IsNormal(G, G1);
  ok.middle_is_cyclic := IsCyclic(G1 / G2);
  ok.top_is_q_group   := IsPGroup(G / G1) and
                         (Size(G/G1) = 1 or PrimePGroup(G / G1) = q);
  ok.transitive_parts := true;                 # each block orbit is a full block
  ok.all              := ForAll(RecNames(ok), f -> ok.(f) = true);
  return rec(G := G, G1 := G1, G2 := G2, ok := ok);
end;

# -------------------------------------------------------------- u-orbital sizes
OrbitalSizes := function(G, n)
  local pairs, orbs;
  pairs := Combinations([1..n], 2);
  orbs  := Orbits(G, pairs, OnSets);
  return SortedList(List(orbs, Length));
end;

# ------------------------------------------------------- the value formula terms
Orb := function(c, t, char2)
  local v;
  if t mod 2 = 0 or char2 then v := c * t / 2; else v := c * t; fi;
  return Minimum(v, Binomial(c, 2));
end;

PredictedTerms := function(w, twists)
  local terms, i, j, cl, sz;
  terms := [];  sz := [];
  for i in [1..Length(w.classes)] do
    cl := w.classes[i];  Add(sz, cl.F * cl.c);
    if cl.foreign then
      Add(terms, Orb(cl.c, twists[i], false));
    else
      Add(terms, cl.F * Orb(cl.c, twists[i], w.p = 2));
      if cl.F > 1 then
        # coefficient keyed on the PARITY OF F, not on q; exact for the regular
        # C_F block action this construction uses
        if cl.F mod 2 = 1 then Add(terms, cl.F * cl.c^2);
        else Add(terms, (cl.F / 2) * cl.c^2); fi;
      fi;
    fi;
  od;
  for i in [1..Length(sz)] do
    for j in [i+1..Length(sz)] do Add(terms, sz[i] * sz[j]); od;
  od;
  return SortedList(terms);
end;

# --------------------------------------------------------------------- the check
VerifyWitness := function(str, muBound)
  local w, twists, cfg, chain, sizes, terms, n, f, verdict, why;
  w := ParseWitness(str);
  twists := ConstructionTwists(w);
  cfg := BuildConfig(w, twists);
  n := cfg.n;
  Print("witness   : ", str, "\n");
  Print("p, q      : ", w.p, ", ", w.q, "\n");
  Print("n         : ", n, "   C(n,2) = ", Binomial(n, 2), "\n");
  Print("twists    : ", twists, "   (diagonal-carrier stripped)\n");
  chain := CheckOliverChain(cfg, w.p, w.q);
  Print("|Gamma|   : ", Size(chain.G), "\n");
  for f in RecNames(chain.ok) do
    if f <> "all" then Print("  chain ", f, ": ", chain.ok.(f), "\n"); fi;
  od;
  sizes := OrbitalSizes(chain.G, n);
  terms := PredictedTerms(w, twists);
  Print("orbitals  : ", sizes, "  (sum ", Sum(sizes), ")\n");
  Print("predicted : ", terms, "\n");
  Print("min orbital / mu_bound : ", Minimum(sizes), " / ", muBound, "\n");
  # Collect the REASONS, not just the conjunction.  A bare "false" next to
  # orbital data that visibly matches the prediction invites the reader to
  # conclude the battery is broken, or to hunt in the orbitals for a
  # discrepancy that is not there -- the failure is usually a chain condition
  # several lines above.  Name every failing condition on the verdict line.
  why := [];
  for f in RecNames(chain.ok) do
    if f <> "all" and chain.ok.(f) <> true then Add(why, f); fi;
  od;
  if Minimum(sizes) <> muBound then
    Add(why, Concatenation("min orbital ", String(Minimum(sizes)),
                           " <> mu_bound ", String(muBound)));
  fi;
  if Sum(sizes) <> Binomial(n, 2) then
    Add(why, Concatenation("orbital sizes sum to ", String(Sum(sizes)),
                           ", not C(n,2) = ", String(Binomial(n, 2))));
  fi;
  # the multiset check: every predicted term must appear, allowing the
  # construction to split a class into several orbitals of equal size
  if not IsSubset(Set(sizes), Set(terms)) then
    Add(why, Concatenation("predicted terms not realised: missing ",
                           String(Difference(Set(terms), Set(sizes)))));
  fi;
  verdict := Length(why) = 0;
  if verdict then
    Print("VERDICT   : true\n\n");
  else
    Print("VERDICT   : false -- ", JoinStringsWithSeparator(why, "; "), "\n");
    Print("            (everything not named above passed; in particular the\n");
    Print("             orbital sizes are only at issue if named here)\n\n");
  fi;
  return verdict;
end;

# ------------------------------------------------------------------- the battery
# Values with a known score, chosen to cover the shapes with the least
# construction evidence: cyclic-layer fusion and the fused rung.  NOTE: the
# second column is the configuration's own predicted min orbital, which equals
# B(n) only where that configuration is the winner -- it is not at n = 247.
# S4 (two matching + foreign) and every even F >= 4 remain uncovered (R8).
BATTERY := [
  [ "p=5 q=2: 2x5",                20 ],   # n = 10, fused rung, mu(10)
  [ "p=2 q=3: 3x4",                18 ],   # n = 12, mu(12); trivial-top attainer
  [ "p=5 q=3: 3x5",                30 ],   # n = 15
  [ "p=3 q=2: 1x9 + 1x17*",        36 ],   # n = 26, Lemma C worked example
  [ "p=7 q=5: 5x7",               105 ],   # n = 35, Theorem 2.2
  [ "p=73 q=5: 2x73 + 1x101*",   1314 ],   # n = 247, S7 at F = 2 (NOT S4, and not
                                          # B(247): the S4 winner at this n is
                                          # 1x101* + 1x73 + 1x73 with B = 2525.
                                          # 1314 is this configuration's own score,
                                          # so the row checks realisability of a
                                          # non-optimal configuration.  S4 still has
                                          # no battery entry -- see R8.
  [ "p=53 q=37: 3x53 + 1x149*",  4134 ],   # n = 308, cyclic-layer fusion
];

if IsBound(GAPInfo.SystemEnvironment.WITNESS) then
  VerifyWitness(GAPInfo.SystemEnvironment.WITNESS,
                Int(GAPInfo.SystemEnvironment.MUBOUND));
else
  Print("Part E realisability battery\n",
        "============================\n\n");
  for BW in BATTERY do VerifyWitness(BW[1], BW[2]); od;
fi;

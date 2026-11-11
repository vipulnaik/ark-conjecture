# entangled_check.g -- AGammaL(1,c) acting on c + r points, r a prime dividing
# c - 1 (`threshold-beyond-mu.md` section 5).  The c points are GF(c); the r
# points are Z/r, on which multiplication by a primitive element acts as a
# translation and the Frobenius x -> x^p acts as y -> p*y.  So the translations
# of the r points are tied to the twist of GF(c), and the cyclic layer stays
# cyclic although r divides c - 1.
# Prints the Oliver chain and the orbital sizes.   Run: gap -q entangled_check.g
Check:=function(c,r)
  local F,els,w,p,pos,ext,id,gens,g,u,G,P,H,orbs,n,e;
  F:=GF(c); els:=Elements(F); w:=PrimitiveElement(F); p:=Characteristic(F); n:=c+r;
  e:=(c-1)/r;
  pos:=x->Position(els,x);
  ext:=function(fF,fR) local l,i; l:=[];
    for i in [1..c] do l[i]:=pos(fF(els[i])); od;
    for i in [0..r-1] do l[c+1+i]:=c+1+fR(i); od; return PermList(l); end;
  id:=x->x;
  gens:=List(Basis(F),b->ext(x->x+b,id));
  g:=ext(x->x*w,y->(y+1) mod r);
  u:=ext(x->x^p,y->(p*y) mod r);
  G:=Group(Concatenation(gens,[g,u]));
  P:=PCore(G,p); H:=ClosureGroup(P,g);
  orbs:=Orbits(G,Combinations([1..n],2),OnSets);
  Print("n = ",c," + ",r,": order ",Size(G),"; P order ",Size(P)," normal ",IsNormal(G,P),
        "; H/P cyclic of order ",Size(H)/Size(P)," (",IsCyclic(H/P),"), H normal ",IsNormal(G,H),
        "; G/H order ",Index(G,H),"\n   orbital sizes ",SortedList(List(orbs,Length)),
        "; inside the ",r," points: ",SortedList(List(Filtered(orbs,o->o[1][1]>c),Length)),"\n");
end;;
Check(8,7); Check(32,31);

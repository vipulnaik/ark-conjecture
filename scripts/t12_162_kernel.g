# t12_162_kernel.g -- confirms 12T162 = kernel of sgn(sigma)sgn(tau)(-1)^eps on S4 wr C2 acting on the edges of two tetrahedra.
# Expect: |K| = 576, TransitiveIdentification 162, isomorphic and conjugate in S12 to TransitiveGroup(12,162).  Usage: gap -q t12_162_kernel.g < /dev/null
edges4 := Combinations([1..4], 2);
S4e := Action(SymmetricGroup(4), edges4, OnSets);            # S4 on the 6 edges
W := WreathProduct(S4e, Group((1,2)));                    # on 12 points
emb1 := Embedding(W, 1); emb2 := Embedding(W, 2); top := Embedding(W, 3);
sg := function(g) if SignPerm(PreImagesRepresentative(ActionHomomorphism(SymmetricGroup(4), edges4, OnSets), g)) = 1 then return (); else return (1,2); fi; end;
# character: sgn(sigma) sgn(tau) (-1)^eps, via generators
hom := GroupHomomorphismByImages(W, Group((1,2)),
  Concatenation(List(GeneratorsOfGroup(S4e), g -> Image(emb1, g)), List(GeneratorsOfGroup(S4e), g -> Image(emb2, g)), [Image(top, (1,2))]),
  Concatenation(List(GeneratorsOfGroup(S4e), g -> sg(g)), List(GeneratorsOfGroup(S4e), g -> sg(g)), [(1,2)]));
K := Kernel(hom);
T := TransitiveGroup(12, 162);
Print("|K| = ", Size(K), "  transitive ", IsTransitive(K, [1..12]), "  TransitiveIdentification ", TransitiveIdentification(K),
      "  isomorphic to 12T162: ", IsomorphismGroups(K, T) <> fail, "  conjugate in S12: ", IsConjugate(SymmetricGroup(12), K, T), "\n");
QUIT;

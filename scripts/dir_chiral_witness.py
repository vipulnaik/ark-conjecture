#!/usr/bin/env python3
"""dir_chiral_witness.py -- an explicit witness for threshold-beyond-mu.md sections 14 and 15.
Gamma = (C_7 x| C_3) x (C_13 x| C_3) on 20 points (Oliver: P = C_7, H = C_7 x C_13, top q = 3).
Computes, on unordered pairs, ordered pairs, and unordered pairs under N* intersected with A_n:
the orbitals, the N*-types (nauty), and the level-1 value m*_N (least budget with an invariant
complex of chi = 1 mod 3; the full set of orbitals never fits the budgets reached)."""
import itertools, pynauty
from ortools.sat.python import cp_model
# Gamma = (C7 x| C3) x (C13 x| C3) on 0..6 and 7..19 ; Oliver: P = C7, H = C7 x C13, top q = 3
n=20
def perm(f): return [f(x) for x in range(n)]
gens=[perm(lambda x:(x+1)%7 if x<7 else x),
      perm(lambda x:(2*x)%7 if x<7 else x),                 # 2 has order 3 mod 7
      perm(lambda x:7+((x-7+1)%13) if x>=7 else x),
      perm(lambda x:7+((3*(x-7))%13) if x>=7 else x)]        # 3 has order 3 mod 13
def orbits_on(items, act):
    seen={}; out=[]
    for it in items:
        if it in seen: continue
        o={it}; st=[it]
        while st:
            a=st.pop()
            for g in gens:
                b=act(g,a)
                if b not in o: o.add(b); st.append(b)
        for b in o: seen[b]=len(out)
        out.append(sorted(o))
    return out
dirorbs=orbits_on([(x,y) for x in range(n) for y in range(n) if x!=y], lambda g,a:(g[a[0]],g[a[1]]))
undorbs=orbits_on(list(itertools.combinations(range(n),2)), lambda g,a:tuple(sorted((g[a[0]],g[a[1]]))))
print('directed orbitals', sorted(len(o) for o in dirorbs)); print('undirected orbitals', sorted(len(o) for o in undorbs))
def nstar(orbs, directed, even_only=False):
    # vertices 0..n-1, head copies n..2n-1 (directed), item nodes, orbital nodes
    items=[e for o in orbs for e in o]; iid={e:i for i,e in enumerate(items)}
    base=2*n if directed else n
    N=base+len(items)+len(orbs); adj={v:[] for v in range(N)}
    if directed:
        for v in range(n): adj[v].append(n+v)
    for e,i in iid.items():
        a,b=e
        adj[base+i]+= [a, (n+b) if directed else b]
    for j,o in enumerate(orbs):
        for e in o: adj[base+iid[e]].append(base+len(items)+j)
    col=[set(range(n))]+([set(range(n,2*n))] if directed else [])+[set(range(base,base+len(items))),set(range(base+len(items),N))]
    g=pynauty.Graph(N,adjacency_dict=adj,vertex_coloring=col)
    gens_,_,_,orbit,_=pynauty.autgrp(g)
    return [gg[:n] for gg in gens_], orbit[base+len(items):]
def level1(orbs, directed, chiral=False):
    G,_=nstar(orbs,directed)
    t=len(orbs); lookup={}
    for j,o in enumerate(orbs):
        for e in o: lookup[e]=j
    def img(g,j):
        a,b=orbs[j][0]; e=(g[a],g[b]) if directed else tuple(sorted((g[a],g[b])))
        return lookup[e]
    acts=[[img(g,j) for j in range(t)] for g in G]
    if chiral:
        # closure of the action restricted to EVEN vertex permutations: generate the group and keep even elements
        from sympy.combinatorics import Permutation, PermutationGroup
        PG=PermutationGroup([Permutation(g) for g in G])
        EV=[p for p in PG.generate_schreier_sims(af=True) if Permutation(p).is_even] if PG.order()<=10**6 else None
        acts=[[img(p,j) for j in range(t)] for p in EV]
    sizes=[len(o) for o in orbs]
    # orbits of the action on subsets of orbitals
    full=(1<<t)-1; rep={}; reps=[]
    for F in range(1,full):
        if F in rep: continue
        orb={F}; st=[F]
        while st:
            x=st.pop()
            for a in acts:
                y=sum(1<<a[j] for j in range(t) if x>>j&1)
                if y not in orb: orb.add(y); st.append(y)
        for y in orb: rep[y]=F
        reps.append((F,len(orb)))
    w=lambda F:sum(sizes[j] for j in range(t) if F>>j&1)
    types=sorted(set(rep[1<<j] for j in range(t)))
    typetot=sorted(sum(sizes[j] for j in range(t) if rep[1<<j]==T) for T in types)
    for B in sorted(set(w(F) for F,_ in reps)):
        use=[(F,c) for F,c in reps if w(F)<=B]; idx={F:i for i,(F,_) in enumerate(use)}
        M=cp_model.CpModel(); X=[M.NewBoolVar('') for _ in use]
        for i,(F,_) in enumerate(use):
            for j in range(t):
                if F>>j&1 and F^(1<<j): M.AddImplication(X[i],X[idx[rep[F^(1<<j)]]])
        z=M.NewIntVar(-10**6,10**6,'')
        M.Add(sum((1 if bin(F).count('1')%2 else -1)*c*X[i] for i,(F,c) in enumerate(use))==1+3*z)
        S=cp_model.CpSolver(); S.parameters.max_time_in_seconds=60
        if S.Solve(M) in (cp_model.OPTIMAL,cp_model.FEASIBLE): return B, typetot
    return None, typetot
for directed,chiral,name in [(False,False,'undirected'),(True,False,'directed'),(False,True,'chiral (N* ∩ A_n)')]:
    orbs=dirorbs if directed else undorbs
    B,tt=level1(orbs,directed,chiral)
    print(f"{name}: least orbital {min(len(o) for o in orbs)}, type totals {tt}, level-1 m*_N = {B}")

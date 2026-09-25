import ctypes, itertools, os
from pynauty import Graph as NG, certificate
n=10; E=list(itertools.combinations(range(n),2)); FULL=(1<<45)-1
_lib=ctypes.CDLL(os.path.join(os.path.dirname(os.path.abspath(__file__)),"libemb.so"))
_lib.embeds.argtypes=[ctypes.POINTER(ctypes.c_ushort)]*2; _lib.embeds.restype=ctypes.c_int
Arr=ctypes.c_ushort*n
_adj={}
def adj(mk):
    if mk not in _adj:
        a=[0]*n
        for i,(u,v) in enumerate(E):
            if mk>>i&1: a[u]|=1<<v; a[v]|=1<<u
        _adj[mk]=Arr(*a)
    return _adj[mk]
def embeds_c(hmk,gmk):
    if bin(hmk).count("1")>bin(gmk).count("1"): return False
    if bin(FULL^gmk).count("1") < bin(hmk).count("1"):
        hmk,gmk=FULL^gmk,FULL^hmk
    return bool(_lib.embeds(adj(hmk),adj(gmk)))
_cert={}
def canon(mk):
    if mk not in _cert:
        d={v:[] for v in range(n)}
        for i,(u,v) in enumerate(E):
            if mk>>i&1: d[u].append(v); d[v].append(u)
        _cert[mk]=certificate(NG(n,adjacency_dict=d))
    return _cert[mk]

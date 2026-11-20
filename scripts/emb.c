#include <string.h>
#ifndef N
#define N 10   /* adjacency rows are 16-bit: N <= 16; build with -DN=16 for n = 11..16 */
#endif
static int pc(unsigned x){return __builtin_popcount(x);}
static unsigned short H[N],G[N],cand[N]; static int dh[N],dg[N],img[N];
static long budget=-1;   /* step budget for embeds_lim; -1 = unlimited */
int emb_exhausted=0;
static int go(unsigned placed,unsigned used){
  if(placed==(1u<<N)-1) return 1;
  if(budget>=0){ if(budget==0){ emb_exhausted=1; return 0; } budget--; }
  int best=-1,bc=99; unsigned bm=0;
  for(int v=0;v<N;v++){ if(placed>>v&1) continue;
    unsigned need=0,nb=H[v]&placed; while(nb){int w=__builtin_ctz(nb); nb&=nb-1; need|=1u<<img[w];}
    unsigned m=cand[v]&~used,mm=0; while(m){int c=__builtin_ctz(m); m&=m-1; if((G[c]&need)==need) mm|=1u<<c;}
    int k=pc(mm); if(!k) return 0; if(k<bc){bc=k;best=v;bm=mm;} }
  while(bm){int c=__builtin_ctz(bm); bm&=bm-1; img[best]=c; if(go(placed|1u<<best,used|1u<<c)) return 1;}
  img[best]=-1; return 0;
}
static void nbdeg(const unsigned short*A,const int*d,int v,int*out,int*len){
  int k=0; for(int w=0;w<N;w++) if(A[v]>>w&1) out[k++]=d[w];
  for(int i=0;i<k;i++) for(int j=i+1;j<k;j++) if(out[j]>out[i]){int t=out[i];out[i]=out[j];out[j]=t;}
  *len=k;
}
int embeds(const unsigned short*h,const unsigned short*g){
  memcpy(H,h,sizeof H); memcpy(G,g,sizeof G);
  for(int v=0;v<N;v++){dh[v]=pc(H[v]); dg[v]=pc(G[v]); img[v]=-1;}
  int sh[N],sg[N]; memcpy(sh,dh,sizeof sh); memcpy(sg,dg,sizeof sg);
  for(int i=0;i<N;i++) for(int j=i+1;j<N;j++){ if(sh[j]>sh[i]){int t=sh[i];sh[i]=sh[j];sh[j]=t;} if(sg[j]>sg[i]){int t=sg[i];sg[i]=sg[j];sg[j]=t;} }
  for(int i=0;i<N;i++) if(sg[i]<sh[i]) return 0;
  int nh[N][N],lh[N],ng[N][N],lg[N];
  for(int v=0;v<N;v++){ nbdeg(H,dh,v,nh[v],&lh[v]); nbdeg(G,dg,v,ng[v],&lg[v]); }
  for(int v=0;v<N;v++){ unsigned m=0;
    for(int c=0;c<N;c++){ if(dg[c]<dh[v]) continue; int ok=1; for(int i=0;i<lh[v];i++) if(ng[c][i]<nh[v][i]){ok=0;break;} if(ok) m|=1u<<c; }
    if(!m) return 0; cand[v]=m; }
  return go(0,0);
}

/* embeds_lim: as embeds, but gives up after `limit` search steps and returns 0 with emb_exhausted = 1.  A caller that
   only needs SOME true embeddings (e.g. adding implications whose omission weakens a system) can treat 0 as "none". */
int embeds_lim(const unsigned short*h,const unsigned short*g,long limit){
  budget=limit; emb_exhausted=0; int r=embeds(h,g); budget=-1; return r;
}

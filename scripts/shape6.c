/* shape6.c -- Open Problem 6 at n = 6: enumerate all three-state shapes on K6 up to S6
   (each edge present / absent / irrelevant), form the property "some placement of the shape fits G",
   dedupe properties, keep the nontrivial ones with signed sum 0 (necessary for non-evasiveness),
   and print their truth tables for dtree.c.  Output: lines "nshapes nprops ..." to stderr, tables to stdout. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define N 6
#define E 15
int eu[E], ev[E], eid[N][N], perm[720][N], pe[720][E], np=0;
static void gen(int *a,int k){ if(k==N){memcpy(perm[np++],a,sizeof(int)*N);return;}
  for(int i=k;i<N;i++){int t=a[k];a[k]=a[i];a[i]=t;gen(a,k+1);t=a[k];a[k]=a[i];a[i]=t;} }
static unsigned pmask(int p,unsigned m){unsigned r=0;for(int e=0;e<E;e++)if(m>>e&1)r|=1u<<pe[p][e];return r;}
int cls[1<<E], ncls=0, rep[200], csz[200], cpar[200];
typedef struct { unsigned long long b[3]; unsigned L,A; } P3;
int cmpP(const void*a,const void*b){return memcmp(a,b,24);}
int main(){
  int k=0; for(int i=0;i<N;i++)for(int j=i+1;j<N;j++){eu[k]=i;ev[k]=j;eid[i][j]=eid[j][i]=k;k++;}
  int a[N]; for(int i=0;i<N;i++)a[i]=i; gen(a,0);
  for(int p=0;p<720;p++)for(int e=0;e<E;e++)pe[p][e]=eid[perm[p][eu[e]]][perm[p][ev[e]]];
  memset(cls,-1,sizeof cls);
  for(unsigned g=0;g<(1u<<E);g++){ if(cls[g]>=0)continue; int c=ncls++; rep[c]=g; csz[c]=0; cpar[c]=__builtin_popcount(g)&1;
    for(int p=0;p<720;p++){unsigned h=pmask(p,g); if(cls[h]<0){cls[h]=c;csz[c]++;}} }
  fprintf(stderr,"graph classes %d\n",ncls);
  /* shapes: L (present) and A (absent) disjoint masks; canonical = lex-min (L,A) over S6 */
  P3 *props=malloc(sizeof(P3)*30000); long nsh=0;
  for(unsigned L=0;L<(1u<<E);L++){
    unsigned rest=((1u<<E)-1)&~L;
    for(unsigned A=rest;;A=(A-1)&rest){
      int ok=1; for(int p=1;p<720&&ok;p++){unsigned L2=pmask(p,L); if(L2<L){ok=0;break;} if(L2==L&&pmask(p,A)<A)ok=0;}
      if(ok){ P3 pr={{0,0,0},L,A};
        for(int c=0;c<ncls;c++){unsigned G=rep[c];
          for(int p=0;p<720;p++){unsigned L2=pmask(p,L),A2=pmask(p,A); if((L2&G)==L2&&!(A2&G)){pr.b[c>>6]|=1ULL<<(c&63);break;}}}
        props[nsh++]=pr; }
      if(A==0)break; } }
  qsort(props,nsh,sizeof(P3),cmpP);
  long nd=0,ntriv=0,npar=0;
  for(long i=0;i<nsh;i++){ if(i&&!memcmp(&props[i],&props[i-1],24))continue; nd++;
    long s=0; int cnt=0; for(int c=0;c<ncls;c++)if(props[i].b[c>>6]>>(c&63)&1){cnt++; s+= cpar[c]?-csz[c]:csz[c];}
    if(cnt==0||cnt==ncls){ntriv++;continue;}
    if(s!=0)continue; npar++;
    printf("%d\n",E); fprintf(stderr,"S %ld L %u A %u\n",npar,props[i].L,props[i].A); for(unsigned g=0;g<(1u<<E);g++){int c=cls[g];putchar(props[i].b[c>>6]>>(c&63)&1?'1':'0');} putchar('\n'); }
  fprintf(stderr,"shapes %ld distinct props %ld trivial %ld signed-sum-0 %ld\n",nsh,nd,ntriv,npar);
}

/* wsearch.c -- exhaustive search for weakly symmetric non-evasive set systems with f(0) != f(1).
   stdin: n, number of orbits m, then for each orbit: size followed by its members (bitmasks).
   Enumerates all unions of orbits containing exactly one of the empty set and the full set; filters by
   (i) total signed count 0 and (ii) signed count 0 on the link of point 0 (both necessary, the first query being
   arbitrary by transitivity); then computes D exactly by the base-3 subcube DP.  Prints non-evasive ones. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int n, m; long N2, N3; int *osz; long **om; int *wsum, *wlink;
unsigned char *lo, *hi, *Dt; char *tt; long *p3;
int Dcomp(void) {
    for (long c = 0; c < N3; c++) {
        long x = c; int fi = -1; long pt = 0;
        for (int i = 0; i < n; i++) { int d = x % 3; x /= 3; if (d == 2) { if (fi < 0) fi = i; } else if (d == 1) pt |= 1L << i; }
        if (fi < 0) { lo[c] = hi[c] = tt[pt]; Dt[c] = 0; continue; }
        long c0 = c - 2 * p3[fi], c1 = c - p3[fi];
        lo[c] = lo[c0] < lo[c1] ? lo[c0] : lo[c1]; hi[c] = hi[c0] > hi[c1] ? hi[c0] : hi[c1];
        if (lo[c] == hi[c]) { Dt[c] = 0; continue; }
        int best = 255; long y = c;
        for (int i = 0; i < n; i++) { int d = y % 3; y /= 3;
            if (d == 2) { int a = Dt[c - 2 * p3[i]], b = Dt[c - p3[i]]; int v = 1 + (a > b ? a : b); if (v < best) best = v; } }
        Dt[c] = best;
    }
    return Dt[N3 - 1];
}
int main(int argc, char **argv) {
    if (scanf("%d %d", &n, &m) != 2) return 1;
    N2 = 1L << n; N3 = 1; for (int i = 0; i < n; i++) N3 *= 3;
    p3 = malloc(sizeof(long) * n); p3[0] = 1; for (int i = 1; i < n; i++) p3[i] = p3[i-1] * 3;
    osz = malloc(sizeof(int) * m); om = malloc(sizeof(long*) * m); wsum = calloc(m, sizeof(int)); wlink = calloc(m, sizeof(int));
    int i0 = -1, i1 = -1;
    for (int j = 0; j < m; j++) {
        if (scanf("%d", &osz[j]) != 1) return 1; om[j] = malloc(sizeof(long) * osz[j]);
        for (int t = 0; t < osz[j]; t++) { if (scanf("%ld", &om[j][t]) != 1) return 1; long s = om[j][t]; int sg = (__builtin_popcountl(s) & 1) ? -1 : 1;
            wsum[j] += sg; if (s & 1) wlink[j] += sg; if (s == 0) i0 = j; if (s == N2 - 1) i1 = j; }
    }
    int others[64], no = 0; for (int j = 0; j < m; j++) if (j != i0 && j != i1) others[no++] = j;
    lo = malloc(N3); hi = malloc(N3); Dt = malloc(N3); tt = malloc(N2);
    long cand = 0, found = 0;
    for (long bits = 0; bits < (1L << no); bits++) for (int e = 0; e < 2; e++) {
        int s = wsum[e ? i0 : i1], l = wlink[e ? i0 : i1];
        for (int t = 0; t < no; t++) if (bits >> t & 1) { s += wsum[others[t]]; l += wlink[others[t]]; }
        if (s != 0 || l != 0) continue;
        cand++;
        memset(tt, 0, N2);
        int sel[64], ns = 0; sel[ns++] = e ? i0 : i1;
        for (int t = 0; t < no; t++) if (bits >> t & 1) sel[ns++] = others[t];
        for (int q = 0; q < ns; q++) for (int t = 0; t < osz[sel[q]]; t++) tt[om[sel[q]][t]] = 1;
        int d = Dcomp();
        if (d < n) { found++; printf("NONEVASIVE D=%d orbits:", d); for (int q = 0; q < ns; q++) printf(" %d", sel[q]); printf("\n"); fflush(stdout); }
    }
    printf("candidates %ld nonevasive %ld\n", cand, found);
    return 0;
}

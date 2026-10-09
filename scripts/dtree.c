/* dtree.c -- exact deterministic decision-tree complexity D(f) of f:{0,1}^n -> {0,1}, n <= 16.
   Reads n and the 2^n truth table (one char '0'/'1' per point, bit i of the index = variable i) from stdin.
   Compiled with -DDUMP it also writes D, lo, hi over all 3^n subcubes to tabD.bin.
   Subcubes are indexed in base 3 (digit 0, 1 = fixed value, 2 = free); children have smaller indices. */
#include <stdio.h>
#include <stdlib.h>
int main(void) {
    int n; if (scanf("%d", &n) != 1) return 1;
    long N2 = 1L << n, N3 = 1; for (int i = 0; i < n; i++) N3 *= 3;
    char *tt = malloc(N2 + 1); if (scanf("%s", tt) != 1) return 1;
    unsigned char *lo = malloc(N3), *hi = malloc(N3), *D = malloc(N3);
    long *p3 = malloc(sizeof(long) * n); p3[0] = 1; for (int i = 1; i < n; i++) p3[i] = p3[i-1] * 3;
    for (long c = 0; c < N3; c++) {
        long x = c; int fi = -1; long pt = 0;
        for (int i = 0; i < n; i++) { int d = x % 3; x /= 3; if (d == 2) { if (fi < 0) fi = i; } else if (d == 1) pt |= 1L << i; }
        if (fi < 0) { lo[c] = hi[c] = tt[pt] - '0'; D[c] = 0; continue; }
        long c0 = c - 2 * p3[fi], c1 = c - p3[fi];
        lo[c] = lo[c0] < lo[c1] ? lo[c0] : lo[c1]; hi[c] = hi[c0] > hi[c1] ? hi[c0] : hi[c1];
        if (lo[c] == hi[c]) { D[c] = 0; continue; }
        int best = 255; long y = c;
        for (int i = 0; i < n; i++) { int d = y % 3; y /= 3;
            if (d == 2) { int a = D[c - 2 * p3[i]], b = D[c - p3[i]]; int v = 1 + (a > b ? a : b); if (v < best) best = v; } }
        D[c] = best;
    }
    printf("%d\n", D[N3 - 1]);
#ifdef DUMP
    { FILE *o = fopen("tabD.bin", "wb"); fwrite(D, 1, N3, o); fwrite(lo, 1, N3, o); fwrite(hi, 1, N3, o); fclose(o); }
#endif
    return 0;
}

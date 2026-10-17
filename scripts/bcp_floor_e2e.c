/* bcp_floor_e2e.c -- end-to-end check of notes/bcp-to-floor.md section 7 (pending-checks A23).
   For every n in (N0, N1], with the per-class (k, d) of the note's section 3, look for n = k p + r with
   r = d Q + 1, p, r, Q prime, Q odd, p odd, p != r, gcd(k(p-1), r) = 1, and r in the window (alpha n, beta n],
   the windows backed off by the factor BACK inside the closed-form optimum.  Score each representation by the
   Reduction Lemma's minimum orbital  min{ k C(p,2), [k=2] p^2, [k=4] 2p^2, k p r, foreign } / C(n,2), with
   foreign = r Q (MODE 1, corrected) or r Q / 2 (MODE 0, the original run's scoring, whose windows were optimised
   for the objective with d in place of d/2).  Reports, per class: exceptional n, the worst best-representation value,
   and the ideal.  'worst-best' takes each n's best representation; 'worst-any' the worst
   representation in the window (the window's guarantee is back^2 times the ideal).  Also prints the BH pair counts (odd Q) below 4*10^6.
   Usage: gcc -O2 -o e2e bcp_floor_e2e.c -lm && ./e2e MODE [BACK=0.96] [N0=1000000] [N1=1400000] */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
static char *comp; static long LIM;
static int isp(long x) { return x >= 2 && x <= LIM && !comp[x]; }
static long gcd(long a, long b) { while (b) { long t = a % b; a = b; b = t; } return a; }
int main(int argc, char **argv) {
    int mode = atoi(argv[1]); double back = argc > 2 ? atof(argv[2]) : 0.96;
    long N0 = argc > 3 ? atol(argv[3]) : 1000000, N1 = argc > 4 ? atol(argv[4]) : 1400000;
    LIM = 4000000; comp = calloc(LIM + 1, 1); comp[0] = comp[1] = 1;
    for (long i = 2; i * i <= LIM; i++) if (!comp[i]) for (long j = i * i; j <= LIM; j += i) comp[j] = 1;
    int ds[4] = {2, 4, 6, 12};
    for (int t = 0; t < 4; t++) { long c = 0; for (long Q = 3; ds[t] * Q + 1 <= LIM; Q += 2) if (isp(Q) && isp(ds[t] * Q + 1)) c++;
        printf("BH pairs d=%d, odd Q, r <= 4e6: %ld\n", ds[t], c); }
    int K[12] = {1,2,1,2,1,2,1,2,1,2,1,4}, D[12] = {2,2,6,4,2,6,2,4,6,2,2,6};
    double worst[12], wany[12]; long exc[12], cnt[12]; for (int c = 0; c < 12; c++) { worst[c] = wany[c] = 1e9; exc[c] = cnt[c] = 0; }
    for (long n = N0 + 1; n <= N1; n++) {
        int c = n % 12, k = K[c], d = D[c];
        double e = mode ? d / 2.0 : d;                     /* objective's foreign coefficient */
        double us = sqrt(k) / (sqrt(k) + sqrt(e)), as = 1 - us;
        double u = back * us, al = back * as, be = 1 - u;
        long rlo = (long)(al * n) + 1, rhi = (long)(be * n);
        double Cn = (double)n * (n - 1) / 2, best = -1, wrep = 1e9;
        for (long r = rlo; r <= rhi; r++) {
            if ((r - 1) % d || !isp(r)) continue;
            long Q = (r - 1) / d; if (Q % 2 == 0 || !isp(Q)) continue;
            if ((n - r) % k) continue;
            long p = (n - r) / k; if (p % 2 == 0 || !isp(p) || p == r || gcd(k * (p - 1), r) != 1) continue;
            double v = k * (double)p * (p - 1) / 2;
            if (k == 2 && (double)p * p < v) v = (double)p * p;
            if (k == 4 && 2.0 * p * p < v) v = 2.0 * p * p;
            if (k * (double)p * r < v) v = k * (double)p * r;
            double f = mode ? (double)r * Q : (double)r * Q / 2; if (f < v) v = f;
            if (v / Cn > best) best = v / Cn; if (v / Cn < wrep) wrep = v / Cn;
        }
        cnt[c]++; if (best < 0) exc[c]++; else { if (best < worst[c]) worst[c] = best; if (wrep < wany[c]) wany[c] = wrep; }
    }
    printf("mode %s, back-off %.3f, n in (%ld, %ld]\n", mode ? "rQ (corrected)" : "rQ/2 (original)", back, N0, N1);
    for (int c = 0; c < 12; c++) {
        double e = mode ? D[c] / 2.0 : D[c], ideal = 1 / pow(sqrt(K[c]) + sqrt(e), 2);
        printf("  class %2d (k,d)=(%d,%2d): n=%ld exceptional=%ld worst-best=%.5f (ratio %.4f) worst-any=%.5f (ratio %.4f) ideal=%.5f\n", c, K[c], D[c], cnt[c], exc[c], worst[c], worst[c] / ideal, wany[c], wany[c] / ideal, ideal);
    }
    return 0;
}

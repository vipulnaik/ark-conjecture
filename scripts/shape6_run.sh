#!/bin/sh
# shape6_run.sh WORKDIR -- full Open Problem 6 pipeline at n = 6 (oen §9.6).
#   1. shape6: all 25,506 shapes, 25,472 distinct properties, 1,909 with signed sum 0 (≈75 s)
#   2. dtree on each survivor (≈1,909 × 0.3 s); 21 come out non-evasive
#   3. dtree_tree + shape6_verify.py: explicit optimal tree checked on all 2^15 graphs
#   4. shape6_dump (dtree + table dump) on the D = 13 example for shape6_analysis.py
set -e
H=$(cd "$(dirname "$0")" && pwd); W=$1; mkdir -p "$W/sv"; cd "$W"
gcc -O2 -o shape6 "$H/shape6.c"; gcc -O2 -o dtree "$H/dtree.c"; gcc -O2 -o dtree_tree "$H/dtree_tree.c"
gcc -O2 -DDUMP -o dtree_dump "$H/dtree.c"
./shape6 2>shapes.txt >surv.txt
(cd sv && rm -f p* && split -l 2 -d -a 4 ../surv.txt p)
ls sv/p???? | xargs -P "$(nproc)" -I{} sh -c './dtree < {} > {}.d'
for f in sv/p????; do d=$(cat $f.d); [ "$d" -lt 15 ] || continue
  i=$(basename $f | awk '{print substr($0,2)+1}'); set -- $(awk -v i=$i '$1=="S"&&$2==i{print $4,$6}' shapes.txt)
  ./dtree_tree < $f > $f.t; echo "$(basename $f) D=$d"; python3 "$H/shape6_verify.py" $1 $2 $f.t; done
./dtree_dump < sv/p1217 > /dev/null   # writes tabD.bin (D, lo, hi over all 3^15 subcubes)
python3 "$H/shape6_analysis.py" .

#!/bin/bash
# conjP_soluble_filter.sh -- run conjP_soluble_filter.g on each line of /tmp/conjP_prim.txt not yet in /tmp/conjP_sol.txt,
# one GAP process per group, 2 at a time, 300 s wall clock each (a group over the limit is recorded as "walltime").
cd "$(dirname "$0")"
touch /tmp/conjP_sol.txt
run() {
  key="$1"
  grep -q "^$key " /tmp/conjP_sol.txt && return
  echo "LINE := \"$1\";; OUTF := \"/tmp/conjP_sol.txt\";;" > /tmp/conjP_in_${key// /_}.g
  timeout 300 gap -q -o 8g /tmp/conjP_in_${key// /_}.g conjP_soluble_filter.g > /dev/null 2>&1 || echo "$key walltime" >> /tmp/conjP_sol.txt
}
export -f run
cut -d' ' -f1-2 /tmp/conjP_prim.txt | xargs -d '\n' -P 2 -I{} bash -c 'run "{}"'

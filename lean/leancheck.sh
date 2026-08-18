#!/usr/bin/env bash
# leancheck.sh -- compile Lean files from the command line and print only the
# diagnostics that matter.  Run from the project root (the folder with
# lakefile.toml / lean-toolchain).
#
#   ./leancheck.sh                    # check every .lean under Ark/
#   ./leancheck.sh Ark/Note.lean      # check one file
#   SHOW_SORRY=1 ./leancheck.sh       # include the "uses 'sorry'" warnings
#
# Exit status is 1 if any file reported an error.
#
# Why the filter: every `sorry` emits `declaration uses 'sorry'` as a WARNING,
# so a file that is entirely sketch produces a wall of them and the one real
# error hides in the middle.  Sorries are the expected state here; errors are
# not.  The count is still reported, because a sorry count that DROPS
# unexpectedly means a proof silently stopped being needed -- worth noticing.

set -uo pipefail

if [ ! -f lean-toolchain ]; then
  echo "error: no lean-toolchain here -- run from the project root." >&2
  exit 2
fi

FILES=("$@")
if [ ${#FILES[@]} -eq 0 ]; then
  mapfile -t FILES < <(find . -name '*.lean' -not -path './.lake/*' | sort)
fi

rc=0
total_err=0; total_warn=0; total_sorry=0

for f in "${FILES[@]}"; do
  out=$(lake env lean "$f" 2>&1)
  status=$?
  sorries=$(printf '%s\n' "$out" | grep -c "declaration uses 'sorry'")
  if [ -z "${SHOW_SORRY:-}" ]; then
    shown=$(printf '%s\n' "$out" | grep -v "declaration uses 'sorry'")
  else
    shown="$out"
  fi
  errs=$(printf '%s\n' "$shown" | grep -c ': error:')
  warns=$(printf '%s\n' "$shown" | grep -c ': warning:')

  if [ "$errs" -gt 0 ]; then tag="FAIL"; rc=1; else tag="ok  "; fi
  printf '%s  %-28s  %d error(s), %d other warning(s), %d sorry\n' \
         "$tag" "$f" "$errs" "$warns" "$sorries"
  if [ -n "$(printf '%s' "$shown" | tr -d '[:space:]')" ]; then
    printf '%s\n' "$shown" | sed 's/^/      /'
  fi
  total_err=$((total_err + errs))
  total_warn=$((total_warn + warns))
  total_sorry=$((total_sorry + sorries))
  [ "$status" -ne 0 ] && [ "$errs" -eq 0 ] && echo "      (compiler exited $status with no parsed error -- likely OOM or a timeout)"
done

echo
echo "total: $total_err error(s), $total_warn other warning(s), $total_sorry sorry"
exit $rc

#!/bin/sh
# End-to-end driver test. Args: <wavec> <wave-opt> <e2e-dir> <FileCheck>
#
# good/*.wave  : wavec must lower it; the IR must round-trip through wave-opt;
#                if a sibling .checks exists, the IR must satisfy FileCheck.
# err/*.wave   : wavec must reject it -- exit nonzero, NEVER crash (rc>=128),
#                and print a diagnostic. (Guards the crash/invalid-IR bugs.)
WAVEC="$1"; WAVEOPT="$2"; DIR="$3"; FC="$4"
fail=0
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

for f in "$DIR"/good/*.wave; do
  if ! "$WAVEC" "$f" >"$tmp/out" 2>"$tmp/err"; then
    echo "FAIL good (wavec errored): $f"; cat "$tmp/err"; fail=1; continue
  fi
  if ! "$WAVEOPT" "$tmp/out" -o /dev/null 2>"$tmp/wo"; then
    echo "FAIL good (wave-opt rejected the IR): $f"; cat "$tmp/wo"; fail=1; continue
  fi
  if [ -f "$f.checks" ]; then
    if ! "$FC" "$f.checks" <"$tmp/out" >"$tmp/fc" 2>&1; then
      echo "FAIL good (FileCheck): $f"; cat "$tmp/fc"; fail=1
    fi
  fi
done

for f in "$DIR"/err/*.wave; do
  "$WAVEC" "$f" >/dev/null 2>"$tmp/err"
  rc=$?
  if [ "$rc" -eq 0 ]; then
    echo "FAIL err (should have been rejected): $f"; fail=1; continue
  fi
  if [ "$rc" -ge 128 ]; then
    echo "FAIL err (CRASHED rc=$rc): $f"; fail=1; continue
  fi
  if ! grep -q 'error:' "$tmp/err"; then
    echo "FAIL err (no diagnostic): $f"; fail=1
  fi
  if [ -f "$f.checks" ]; then
    if ! "$FC" "$f.checks" <"$tmp/err" >"$tmp/fc" 2>&1; then
      echo "FAIL err (FileCheck): $f"; cat "$tmp/fc"; fail=1
    fi
  fi
done

if [ "$fail" -ne 0 ]; then echo "e2e: FAILURES"; exit 1; fi
echo "e2e: all pass"

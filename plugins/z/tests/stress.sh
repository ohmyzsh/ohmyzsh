#!/usr/bin/env bash
# Stress Zsh-z concurrent --add without relying on the harness shell's
# fork-and-wait, which segfaults on zsh 4.3.11.
#
# This is the heavy, tunable, manual counterpart to the fast regression
# gate `test_concurrent_add_no_lost_updates' in tests/test_concurrency.zsh:
# both assert that N concurrent `--add's of one path yield rank N (no lost
# updates), but that test is capped small (n=20) for CI while this one
# cranks N/PARALLEL high and can target an arbitrary zsh binary. Keep the
# shared invariant (datafile format, rank==N, ZSHZ_LOCK_TIMEOUT) in sync
# between the two. Not part of `run.zsh'; invoke by hand.
#
# Usage:  stress.sh [zsh-binary]   (default: zsh)
#         N=200 PARALLEL=8 stress.sh ~/bin/zsh-4.3.11
set -eu
ZSH_BIN=${1:-zsh}
N=${N:-100}
PARALLEL=${PARALLEL:-8}

PLUGIN=$(realpath zsh-z.plugin.zsh)
TESTDIR=$(mktemp -d -t zshz-stress.XXXXXX)
trap 'rm -rf "$TESTDIR"' EXIT

export ZSHZ_DATA="$TESTDIR/.z"
# Default flock timeout (1s) is meant to keep a stuck holder from freezing
# the prompt; under heavy stress, give writers plenty of time to acquire so
# we measure real lock-correctness, not the timeout drop-rate.
export ZSHZ_LOCK_TIMEOUT=${ZSHZ_LOCK_TIMEOUT:-30}
TARGET="$TESTDIR/target"
mkdir -p "$TARGET"

echo "zsh:           $("$ZSH_BIN" --version)"
echo "writers:       $N"
echo "parallel:      $PARALLEL"
echo "lock timeout:  ${ZSHZ_LOCK_TIMEOUT}s"

# Solaris (and other AT&T-derived) xargs don't support -P. Use it where
# available; otherwise fall back to bash's own job control, throttled to
# $PARALLEL by waiting on each batch.
if : | xargs -P 1 -I {} true 2>/dev/null; then
  seq 1 "$N" | xargs -P "$PARALLEL" -I{} \
    "$ZSH_BIN" -c "source '$PLUGIN'; zshz --add '$TARGET'"
else
  pids=()
  for ((i=1; i<=N; i++)); do
    "$ZSH_BIN" -c "source '$PLUGIN'; zshz --add '$TARGET'" &
    pids+=( $! )
    if (( ${#pids[@]} >= PARALLEL )); then
      wait "${pids[@]}"
      pids=()
    fi
  done
  (( ${#pids[@]} )) && wait "${pids[@]}"
fi

rank=$(awk -F'|' -v p="$TARGET" '$1==p { print $2 }' "$ZSHZ_DATA")
echo "expected rank: $N"
echo "actual rank:   ${rank:-0}"
[[ "$rank" == "$N" ]] && echo "PASS" || { echo "FAIL: lost $((N - ${rank:-0})) updates"; exit 1; }  

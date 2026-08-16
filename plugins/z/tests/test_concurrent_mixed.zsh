# Concurrent `--add' and `-x' against the same and overlapping paths.
#
# The existing `test_concurrent_add_no_lost_updates' covers
# concurrent adds-only. This file covers the mixed case: some writers
# add, others remove, all racing for the same lockfile. We don't pin
# the exact rank of any path -- with adds and removes interleaved, the
# final rank depends on the order the lock is acquired -- but we do
# pin two structural invariants:
#
#   1. Every line in the datafile matches the canonical
#      `/path|rank|time' shape after the dust settles. A torn write
#      or a rewrite of a half-parsed datafile would surface as a
#      malformed line here.
#   2. No `${datafile}.${RANDOM}' tempfiles are left behind. The
#      `_zshz_add_or_remove_path' rewrite path either renames its
#      tempfile over the datafile or `rm -f's it on failure; an
#      orphan would mean a code path leaked one.
#
# Spawned via xargs (rather than `&'/`wait' from the test shell) for
# the same reason `test_concurrency.zsh' does -- zsh 4.3.11's job
# machinery segfaults under fork load.

test_concurrent_add_and_remove_interleaved() {
  local a="$TESTDIR/A" b="$TESTDIR/B" c="$TESTDIR/C" d="$TESTDIR/D"
  mkdir -p "$a" "$b" "$c" "$d"

  # Build a deliberately interleaved mix of adds and removes. D never
  # gets removed, so it's guaranteed to be in the datafile at the end
  # -- prevents the test from passing trivially if every operation
  # got dropped.
  local -a ops
  ops=(
    "--add $a" "--add $b" "--add $c" "--add $d"
    "--add $a" "--add $b" "--add $c" "--add $d"
    "--add $a" "--add $b" "--add $c" "--add $d"
    "-x $a"   "-x $a"
    "-x $c"
    "--add $a" "--add $b" "--add $c" "--add $d"
    "-x $b"
    "--add $a" "--add $b"
    "-x $c"
  )

  printf '%s\n' "${ops[@]}" | ( xargs_P 4 \
    env ZSHZ_LOCK_TIMEOUT=30 zsh -c \
      "source '$PLUGIN_DIR/zsh-z.plugin.zsh'; zshz {} > /dev/null 2>&1" )

  # 1. Datafile is non-empty and every line is well-formed.
  [[ -s $ZSHZ_DATA ]] || fail "datafile is empty after ${#ops} operations"
  local line line_no=0
  while IFS= read -r line; do
    (( line_no++ ))
    [[ $line == /*\|[0-9]##(.[0-9]#)#\|[0-9]## ]] || \
      fail "datafile line $line_no is malformed: $line"
  done < "$ZSHZ_DATA"

  # These two need writers to be serialized, and they are on every platform:
  # `zsystem flock' where it exists, the `mkdir' fallback where it does not.
  # They briefly ran only under flock, back when the fallback path wrote with
  # nothing serializing it and `D' went missing in 7 of 10 runs on MobaXterm.
  # That is fixed, so assert them everywhere again -- this is now one of the
  # few places that would notice the fallback lock regressing.

  # D never got an `-x', so it must be present.
  [[ -n $(zshz_rank_of "$d") ]] || \
    fail "D should be in the datafile (only added, never removed)"

  # 2. No orphaned tempfiles. The plugin uses ${datafile}.${RANDOM}.
  local -a tempfiles
  tempfiles=( "${ZSHZ_DATA}".<->(N) )
  if (( ${#tempfiles} )); then
    fail "orphaned tempfile(s): ${(j:, :)tempfiles}"
  fi
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:

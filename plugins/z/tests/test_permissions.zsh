# Datafile permission hardening (#92).
#
# `~/.z` must always end up at mode 0600 so a multi-user host can't read
# another user's directory history. The plugin uses the in-process `zf_chmod'
# when available and otherwise creates files under `umask 077' in a subshell,
# avoiding an external `chmod'. `mv'
# then atomically replaces `.z' with the tempfile and preserves its
# 0600. These tests cover all the write paths that could leak
# permissions: fresh creation, `--add' over a preexisting 0644 file,
# `-x' (the remove branch), and the `ZSHZ_OWNER' initial-creation
# chown that hands `.z' off to the right user under `sudo -s'.
#
# MSYS2's filesystem semantics don't reliably reflect POSIX modes
# (Windows ACLs are the source of truth there), so the mode-checking
# tests skip on msys.

# Octal regular-permission bits of $1 (e.g. "600"). Returns empty if the
# `zsh/stat' module isn't loadable. Uses `8#777' rather than `0777' because
# zsh treats `0777' as decimal 777 without `setopt OCTAL_ZEROES'.
_test_mode_of() {
  zmodload -F zsh/stat b:zstat 2>/dev/null
  (( ${+builtins[zstat]} )) || return
  local m
  m=$(zstat -L +mode "$1") || return
  printf '%03o\n' $(( m & 8#777 ))
}

# Skip mode-checking tests when zsh/stat is unavailable or when the
# underlying filesystem ignores POSIX mode bits. The latter check is a
# probe rather than an $OSTYPE match because MSYS2 reports
# $OSTYPE=cygwin but (unlike real Cygwin) silently ignores chmod on its
# Windows-backed filesystem; probing chmod's actual effect handles both
# cases without false-skipping on platforms that do honor modes.
# Returns 0 (skip) or 1 (run).
_test_skip_mode_check() {
  zmodload -F zsh/stat b:zstat 2>/dev/null
  (( ${+builtins[zstat]} )) || return 0
  local probe=$TESTDIR/.mode-probe m
  : > "$probe" && chmod 600 "$probe" 2>/dev/null
  m=$(zstat -L +mode "$probe" 2>/dev/null)
  rm -f "$probe"
  (( (m & 8#777) == 8#600 )) || return 0
  return 1
}

test_initial_creation_is_0600() {
  _test_skip_mode_check && {
    _test_skip "POSIX mode-bit support required"
    return 0
  }

  rm -f "$ZSHZ_DATA"
  zshz -l
  assert_file_exists "$ZSHZ_DATA"
  assert_eq "600" "$(_test_mode_of "$ZSHZ_DATA")" \
    "fresh .z must be created at mode 0600"
}

test_add_clamps_preexisting_world_readable_file_to_0600() {
  _test_skip_mode_check && {
    _test_skip "POSIX mode-bit support required"
    return 0
  }

  : > "$ZSHZ_DATA" && chmod 644 "$ZSHZ_DATA"
  assert_eq "644" "$(_test_mode_of "$ZSHZ_DATA")" "precondition: file is 0644"

  mkdir -p "$TESTDIR/work"
  zshz --add "$TESTDIR/work" || return 1
  assert_eq "600" "$(_test_mode_of "$ZSHZ_DATA")" \
    "--add must clamp a preexisting 0644 .z to 0600 via the tempfile rename"
}

test_remove_keeps_0600() {
  _test_skip_mode_check && {
    _test_skip "POSIX mode-bit support required"
    return 0
  }

  local d="$TESTDIR/r"
  mkdir -p "$d"
  zshz --add "$d" || return 1
  zshz -x "$d" || return 1
  assert_eq "600" "$(_test_mode_of "$ZSHZ_DATA")" \
    "-x must leave .z at mode 0600 after the rewrite"
}

test_repeated_writes_keep_0600() {
  # Each --add rewrites the datafile via a fresh tempfile. Loosening
  # permissions on any single write would defeat the protection, so
  # walk a handful of writes and assert after each one.
  _test_skip_mode_check && {
    _test_skip "POSIX mode-bit support required"
    return 0
  }

  local i d
  for i in 1 2 3 4 5; do
    d="$TESTDIR/d$i"
    mkdir -p "$d"
    zshz --add "$d" || return 1
    assert_eq "600" "$(_test_mode_of "$ZSHZ_DATA")" \
      "iteration $i: .z must remain at mode 0600 after every --add"
  done
}

test_lockfile_created_at_0600() {
  # The lockfile is a shared resource just like the datafile: it must be
  # created 0600-from-birth (umask subshell), not with a bare `touch' under
  # the ambient umask, so a multi-user host can't tamper with another user's
  # lock.
  (( ZSHZ[USE_FLOCK] )) || {
    _test_skip "zsystem flock unavailable"
    return 0
  }
  _test_skip_mode_check && {
    _test_skip "POSIX mode-bit support required"
    return 0
  }

  rm -f "${ZSHZ_DATA}.lock"
  local d="$TESTDIR/work"
  mkdir -p "$d"
  zshz --add "$d" || return 1
  assert_file_exists "${ZSHZ_DATA}.lock"
  assert_eq "600" "$(_test_mode_of "${ZSHZ_DATA}.lock")" \
    "lockfile must be created at mode 0600, like the datafile"
}

test_initial_creation_chowns_when_ZSHZ_OWNER_set() {
  # Under `sudo -s' with ZSHZ_OWNER=user, a query-only `z foo' would
  # otherwise leave a root-owned .z behind that the normal-user shell
  # can't read. The create path therefore chowns to ZSHZ_OWNER eagerly,
  # without waiting for a write to happen. We can't fabricate two UIDs
  # in CI, so we stub ${ZSHZ[CHOWN]} and assert the call shape.
  local chown_log="$TESTDIR/chown.log"
  : > "$chown_log"

  ZSHZ[CHOWN]=_test_log_chown
  _test_log_chown() { print -- "$@" >> "$chown_log"; }

  rm -f "$ZSHZ_DATA"
  ZSHZ_OWNER=$(id -un) zshz -l

  local logged
  logged=$(< "$chown_log")
  assert_contains "$ZSHZ_DATA" "$logged" \
    "initial creation must chown the datafile when ZSHZ_OWNER is set"
}

test_initial_creation_does_not_chown_when_ZSHZ_OWNER_unset() {
  local chown_log="$TESTDIR/chown.log"
  : > "$chown_log"

  ZSHZ[CHOWN]=_test_log_chown
  _test_log_chown() { print -- "$@" >> "$chown_log"; }

  rm -f "$ZSHZ_DATA"
  unset ZSHZ_OWNER _Z_OWNER
  zshz -l

  assert_eq "" "$(< "$chown_log")" \
    "no chown should fire on initial creation when ZSHZ_OWNER is unset"
}

# The two tests below cover the failure path rather than the happy one. The
# tempfile is born under the ambient umask and it is that inode the rename
# publishes, so when `zf_chmod' is what stands between 0666 and 0600, a chmod
# whose status nobody checks turns a permissive umask into a world-readable
# `.z' that still reports success. Both shadow the `zf_chmod' builtin with a
# failing function -- ${ZSHZ[CHMOD]} has to keep the *name* `zf_chmod', since
# that string is what selects this branch over the umask-subshell one.

test_add_fails_closed_when_the_tempfile_cannot_be_secured() {
  [[ ${ZSHZ[CHMOD]} == 'zf_chmod' ]] || {
    _test_skip "zf_chmod required (the umask-subshell path uses no chmod)"
    return 0
  }
  _test_skip_mode_check && {
    _test_skip "POSIX mode-bit support required"
    return 0
  }

  local d="$TESTDIR/before"
  mkdir -p "$d"
  zshz --add "$d" || return 1
  assert_eq "600" "$(_test_mode_of "$ZSHZ_DATA")" "precondition: .z is 0600"

  umask 000
  zf_chmod() { return 1 }

  local d2="$TESTDIR/after" ret=0
  mkdir -p "$d2"
  zshz --add "$d2" || ret=$?

  assert_ne "0" "$ret" \
    "a chmod that cannot secure the tempfile must fail the write"
  assert_eq "600" "$(_test_mode_of "$ZSHZ_DATA")" \
    "a failed chmod must never publish a world-readable .z"
  assert_not_contains "$d2" "$(zshz_dump)" \
    "the refused write must not reach the datafile"

  local -a leftovers
  leftovers=( "$TESTDIR"/${ZSHZ_DATA:t}.<->(N) )
  assert_eq "0" "${#leftovers}" \
    "the abandoned tempfile must be cleaned up: ${(j:, :)leftovers}"
}

test_remove_fails_closed_when_the_tempfile_cannot_be_secured() {
  [[ ${ZSHZ[CHMOD]} == 'zf_chmod' ]] || {
    _test_skip "zf_chmod required (the umask-subshell path uses no chmod)"
    return 0
  }
  _test_skip_mode_check && {
    _test_skip "POSIX mode-bit support required"
    return 0
  }

  local d="$TESTDIR/r"
  mkdir -p "$d"
  zshz --add "$d" || return 1

  umask 000
  zf_chmod() { return 1 }

  local ret=0
  zshz -x "$d" || ret=$?

  assert_ne "0" "$ret" \
    "a chmod that cannot secure the tempfile must fail the removal"
  assert_eq "600" "$(_test_mode_of "$ZSHZ_DATA")" \
    "a failed chmod must never publish a world-readable .z"
  assert_contains "$d" "$(zshz_dump)" \
    "a refused removal must leave the database as it was"
}

# vim: fdm=indent:ts=2:et:sts=2:sw=2:

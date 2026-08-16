# ZSHZ_OWNER / sudo -s ownership behavior.
#
# When ZSHZ_OWNER is set (the documented `sudo -s` workflow), Zsh-z chowns the
# datafile back to that owner after every successful write. The lockfile at
# ${datafile}.lock must get the same treatment: zsystem flock opens it O_RDWR,
# so if root creates it first under sudo and the unprivileged $ZSHZ_OWNER
# user's subsequent flocks fail with EACCES, the error is swallowed by
# `2> /dev/null || return` and --add / -x silently do nothing.
#
# We can't fabricate two real UIDs in CI, so instead we replace ${ZSHZ[CHOWN]}
# with a logger and assert that the chown call covers both files together.

test_owner_set_chowns_both_datafile_and_lockfile() {
  (( ZSHZ[USE_FLOCK] )) || {
    _test_skip "zsystem flock unavailable"
    return 0
  }

  local chown_log="$TESTDIR/chown.log"
  : > "$chown_log"

  ZSHZ[CHOWN]=_test_log_chown
  _test_log_chown() { print -- "$@" >> "$chown_log"; }

  local sub="$TESTDIR/sub"
  mkdir -p "$sub"
  ZSHZ_OWNER=$(id -un) zshz --add "$sub"

  local logged
  logged=$(< "$chown_log")
  assert_contains "$ZSHZ_DATA ${ZSHZ_DATA}.lock" "$logged" \
    "chown must cover datafile and lockfile together when ZSHZ_OWNER is set"
}

test_owner_set_chowns_lockfile_at_creation() {
  # The owner handoff must happen when the lockfile is *created*, not only
  # after a successful write -- otherwise a timed-out or failed first write by
  # root under `sudo -s' leaves a root-owned lockfile that makes every later
  # unprivileged --add / -x a silently-swallowed EACCES no-op. The creation
  # handoff logs a chown of the lockfile ALONE, distinct from the post-write
  # chown that covers both files together.
  (( ZSHZ[USE_FLOCK] )) || {
    _test_skip "zsystem flock unavailable"
    return 0
  }

  local chown_log="$TESTDIR/chown.log"
  : > "$chown_log"

  ZSHZ[CHOWN]=_test_log_chown
  _test_log_chown() { print -- "$@" >> "$chown_log"; }

  rm -f "${ZSHZ_DATA}.lock"
  local sub="$TESTDIR/sub"
  mkdir -p "$sub"
  ZSHZ_OWNER=$(id -un) zshz --add "$sub"

  local -a logged
  logged=( ${(f)"$(< $chown_log)"} )
  local l found=0
  for l in $logged; do
    # A standalone lockfile chown: ends with the lockfile and does not also
    # carry the datafile (which the post-write both-files chown would).
    [[ $l == *" ${ZSHZ_DATA}.lock" && $l != *"$ZSHZ_DATA "* ]] && found=1
  done
  assert_eq "1" "$found" \
    "lockfile must be chowned at creation (standalone), not only after a write"
}

test_owner_unset_does_not_chown() {
  (( ZSHZ[USE_FLOCK] )) || {
    _test_skip "zsystem flock unavailable"
    return 0
  }

  local chown_log="$TESTDIR/chown.log"
  : > "$chown_log"

  ZSHZ[CHOWN]=_test_log_chown
  _test_log_chown() { print -- "$@" >> "$chown_log"; }

  local sub="$TESTDIR/sub"
  mkdir -p "$sub"
  unset ZSHZ_OWNER _Z_OWNER
  zshz --add "$sub"

  assert_eq "" "$(< "$chown_log")" \
    "no chown should fire when ZSHZ_OWNER is unset"
}

# The tests below cover the symlink hardening. In the documented `sudo -s'
# setup every chown runs with root's authority over paths inside a home
# directory the unprivileged owner controls, and `chown' dereferences by
# default -- so a symlink planted at $datafile or ${datafile}.lock would
# redirect it onto an arbitrary file. We can't fabricate a second UID here, so
# these assert the two defenses directly: `-h' on every chown, and an outright
# refusal to act on a symlinked path while an owner is set.

test_owner_chown_never_dereferences_symlinks() {
  (( ZSHZ[USE_FLOCK] )) || {
    _test_skip "zsystem flock unavailable"
    return 0
  }

  local chown_log="$TESTDIR/chown.log"
  : > "$chown_log"

  ZSHZ[CHOWN]=_test_log_chown
  _test_log_chown() { print -- "$@" >> "$chown_log"; }

  local sub="$TESTDIR/sub"
  mkdir -p "$sub"
  ZSHZ_OWNER=$(id -un) zshz --add "$sub"

  local -a logged
  logged=( ${(f)"$(< $chown_log)"} )
  assert_ne "0" "${#logged}" "expected at least one chown to be logged"

  # `-h' is a no-op on the regular files this normally sees; it matters only
  # when the path has been replaced by a symlink since the last check.
  local l bad=0
  for l in $logged; do
    [[ $l == '-h '* ]] || bad=1
  done
  assert_eq "0" "$bad" \
    "every chown must pass -h so a planted symlink is retitled, not followed"
}

test_owner_refuses_symlinked_lockfile() {
  # The lockfile is deliberately never removed, so unlike $datafile -- which
  # the `mv' replaces outright -- a symlink planted here would survive and be
  # acted on at every subsequent write.
  (( ZSHZ[USE_FLOCK] )) || {
    _test_skip "zsystem flock unavailable"
    return 0
  }
  _test_skip_no_symlinks && { print "skip: filesystem has no resolvable symlinks"; return 0 }

  local decoy="$TESTDIR/decoy"
  print 'untouched' > "$decoy"

  local sub="$TESTDIR/sub" sub2="$TESTDIR/sub2"
  mkdir -p "$sub" "$sub2"
  zshz --add "$sub"

  rm -f "${ZSHZ_DATA}.lock"
  ln -s "$decoy" "${ZSHZ_DATA}.lock"

  local ret=0
  ZSHZ_OWNER=$(id -un) zshz --add "$sub2" || ret=$?

  assert_ne "0" "$ret" \
    "a symlinked lockfile must be refused while ZSHZ_OWNER is set"
  assert_eq "untouched" "$(< "$decoy")" \
    "the lockfile symlink's target must not be written through"
  assert_not_contains "$sub2" "$(zshz_dump)" \
    "a refused write must not reach the datafile"
}

test_symlinked_lockfile_allowed_when_owner_unset() {
  # The refusal is gated on $ZSHZ_OWNER on purpose: with no owner set no
  # privilege boundary is crossed, and an unprivileged user pointing their own
  # lockfile elsewhere keeps working exactly as before.
  (( ZSHZ[USE_FLOCK] )) || {
    _test_skip "zsystem flock unavailable"
    return 0
  }
  _test_skip_no_symlinks && { print "skip: filesystem has no resolvable symlinks"; return 0 }

  local elsewhere="$TESTDIR/elsewhere.lock"
  : > "$elsewhere"

  local sub="$TESTDIR/sub" sub2="$TESTDIR/sub2"
  mkdir -p "$sub" "$sub2"
  zshz --add "$sub"

  rm -f "${ZSHZ_DATA}.lock"
  ln -s "$elsewhere" "${ZSHZ_DATA}.lock"

  unset ZSHZ_OWNER _Z_OWNER
  zshz --add "$sub2"

  assert_contains "$sub2" "$(zshz_dump)" \
    "a symlinked lockfile must stay usable when no owner is set"
}

test_owner_refuses_a_symlinked_datafile() {
  # The counterpart to the test below. `_zshz_realpath' deliberately
  # dereferences a symlinked datafile, so under $ZSHZ_OWNER -- root acting for
  # an unprivileged user -- Zsh-z would write the database wherever a name
  # inside that user's own home points, with root's authority. Nothing has to
  # be raced for it: the link is planted before the privileged shell starts,
  # which is what makes this worth refusing rather than merely guarding.
  _test_skip_no_symlinks && { print "skip: filesystem has no resolvable symlinks"; return 0 }

  local decoy="$TESTDIR/decoy"
  print 'untouched' > "$decoy"
  rm -f "$ZSHZ_DATA"
  ln -s "$decoy" "$ZSHZ_DATA"

  local sub="$TESTDIR/sub"
  mkdir -p "$sub"

  # `2>&1' inside the substitution: the refusal is deliberately loud on a
  # hand-typed invocation, and anything reaching the test's own stderr fails it.
  local err ret=0
  err=$(ZSHZ_OWNER=$(id -un) zshz --add "$sub" 2>&1) || ret=$?

  assert_ne "0" "$ret" \
    "a symlinked datafile must be refused while ZSHZ_OWNER is set"
  assert_contains "will not follow the symlink" "$err" \
    "the refusal must explain itself"
  assert_eq "untouched" "$(< "$decoy")" \
    "the symlink's target must not be written through"
}

test_owner_refuses_a_symlinked_parent_directory() {
  # Resolution walks the whole path, so a symlinked *parent* redirects it just
  # as effectively as a symlinked datafile: with `link' -> `/etc' inside a
  # user's own directory, a datafile of `link/passwd' resolves to
  # `/etc/passwd' and a privileged write rewrites it.
  _test_skip_no_symlinks && { print "skip: filesystem has no resolvable symlinks"; return 0 }

  local victim="$TESTDIR/victim"
  mkdir -p "$victim"
  print 'untouched' > "$victim/passwd"
  mkdir -p "$TESTDIR/home"
  ln -s "$victim" "$TESTDIR/home/link"

  local sub="$TESTDIR/sub"
  mkdir -p "$sub"

  local err ret=0
  err=$(ZSHZ_DATA="$TESTDIR/home/link/passwd" ZSHZ_OWNER=$(id -un) zshz --add "$sub" 2>&1) || ret=$?

  assert_ne "0" "$ret" \
    "a symlinked parent must be refused while ZSHZ_OWNER is set"
  assert_contains "$TESTDIR/home/link" "$err" \
    "the refusal must name the offending link, not just the datafile"
  assert_eq "untouched" "$(< "$victim/passwd")" \
    "the symlinked parent's target must not be written through"
}

test_symlinked_datafile_is_dereferenced_when_no_owner_is_set() {
  # Unprivileged use keeps the documented dereference -- it is what makes
  # pointing `.z' at synced storage work -- and the resolution also decides
  # where the lockfile lands, since that name is derived from the *resolved*
  # path. Pinned here because the lockfile's own symlink refusal depends on it
  # being a derived name the user never supplies directly.
  (( ZSHZ[USE_FLOCK] )) || {
    _test_skip "zsystem flock unavailable"
    return 0
  }
  _test_skip_no_symlinks && { print "skip: filesystem has no resolvable symlinks"; return 0 }

  local real="$TESTDIR/real.z"
  : > "$real"
  rm -f "$ZSHZ_DATA"
  ln -s "$real" "$ZSHZ_DATA"

  local sub="$TESTDIR/sub"
  mkdir -p "$sub"
  unset ZSHZ_OWNER _Z_OWNER
  zshz --add "$sub"

  assert_contains "$sub" "$(< "$real")" \
    "a symlinked datafile must be followed to its target when no owner is set"
  assert_file_exists "${real}.lock"
  if [[ -e ${ZSHZ_DATA}.lock ]]; then
    fail "the lockfile must sit beside the resolved datafile, not the symlink"
  fi
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:

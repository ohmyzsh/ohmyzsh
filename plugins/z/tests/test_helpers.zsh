# Test helpers for Zsh-z. Sourced by tests/run.zsh and by each test_*.zsh.

# Fail with a message
fail() {
  print -u 2 "  $*"
  return 1
}

# Mark a capability-dependent test as intentionally unexercised. The runner
# recognizes this stdout prefix and reports SKIP rather than PASS.
_test_skip() {
  print "skip: $*"
  return 0
}

assert_eq() {
  local expected actual msg
  expected="$1"
  actual="$2"
  msg="${3:-}"
  [[ $expected == "$actual" ]] && return 0
  fail "${msg:+$msg: }expected '$expected', got '$actual'"
}

assert_ne() {
  local unexpected actual msg
  unexpected="$1"
  actual="$2"
  msg="${3:-}"
  [[ $unexpected != "$actual" ]] && return 0
  fail "${msg:+$msg: }expected anything but '$unexpected', got '$actual'"
}

assert_contains() {
  local needle haystack msg
  needle="$1"
  haystack="$2"
  msg="${3:-}"
  [[ $haystack == *"$needle"* ]] && return 0
  fail "${msg:+$msg: }expected '$haystack' to contain '$needle'"
}

assert_not_contains() {
  local needle haystack msg
  needle="$1"
  haystack="$2"
  msg="${3:-}"
  [[ $haystack != *"$needle"* ]] && return 0
  fail "${msg:+$msg: }expected '$haystack' not to contain '$needle'"
}

assert_file_exists() {
  [[ -f $1 ]] && return 0
  fail "expected file '$1' to exist"
}

# Probe whether this filesystem/environment can create real POSIX symlinks
# that resolve to their target. On MSYS2 without native-symlink support
# `ln -s' silently produces a copy or a Windows stub, so the symlink-
# *resolution* tests can't run meaningfully there. Returns 0 (skip) when
# symlinks don't resolve, 1 (run) when they do -- a runtime probe rather than
# an `$OSTYPE' match, matching how the chmod and case-sensitivity skips work.
_test_skip_no_symlinks() {
  local d link target
  d=$(mktemp -d "${TMPDIR:-/tmp}/zshz-symprobe.XXXXXX") || return 0
  link="$d/link" target="$d/target"
  mkdir -p "$target"
  ln -s "$target" "$link" 2> /dev/null
  if [[ -L $link && ${link:A} == ${target:A} ]]; then
    rm -rf "$d"
    return 1   # real, resolvable symlinks -> run the test
  fi
  rm -rf "$d"
  return 0     # no resolvable symlinks here -> skip
}

# Probe whether this filesystem can hold a literal backslash in a filename.
# On Windows-family layers (Cygwin, MSYS2) the backslash is a path separator,
# so `mkdir 'a\b'' creates `a/b'' and `:A'' canonicalizes to forward slashes --
# a directory whose *name* contains a backslash cannot exist there. Returns 0
# (skip) when the backslash does not survive as a name character, 1 (run) when
# it does. A runtime probe, like `_test_skip_no_symlinks'.
_test_skip_no_backslash_in_filename() {
  local d p
  d=$(mktemp -d "${TMPDIR:-/tmp}/zshz-bsprobe.XXXXXX") || return 0
  p="$d/back\there"          # back + literal backslash + there
  mkdir -p "$p" 2> /dev/null
  if [[ -d $p && ${p:A} == *'\'* ]]; then
    rm -rf "$d"
    return 1   # backslash is a real filename character here -> run the test
  fi
  rm -rf "$d"
  return 0     # backslash collapses to a separator here -> skip
}

# Read the rank for $1 from the current $ZSHZ_DATA
zshz_rank_of() {
  local p=$1
  [[ -f $ZSHZ_DATA ]] || { print ""; return; }
  awk -F'|' -v p="$p" '$1==p { print $2 }' "$ZSHZ_DATA"
}

# Read the entire datafile, sorted by path, for stable comparisons
zshz_dump() {
  [[ -f $ZSHZ_DATA ]] && sort "$ZSHZ_DATA"
}

# Append a synthetic entry to $ZSHZ_DATA with timestamp = now - SECONDS_AGO.
zshz_seed() {
  local path rank seconds_ago
  path="$1"
  rank="$2"
  seconds_ago="${3:-0}"
  print "${path}|${rank}|$(( EPOCHSECONDS - seconds_ago ))" >> "$ZSHZ_DATA"
}

# Drop-in replacement for `xargs -P NPROC -I {} CMD ARGS...'.
#
# Solaris (and other AT&T-derived) `xargs' don't support `-P'. Where the
# system `xargs' has it, we use it -- the concurrency tests rely on
# spawning external `zsh -c' processes to dodge zsh 4.3.11's `&'/`wait'
# segfault under fork load. Where `-P' isn't available (Solaris with a
# modern zsh), `&'+`wait' works and we fall back to that. The probe
# result is cached in `_XARGS_P_OK'.
#
# NPROC is honored only on the `xargs -P' path; the fallback spawns
# every item at once -- fine for the small N (<=30) the suite uses.
#
# IMPORTANT: callers must invoke this inside `( ... )' on the right side
# of a pipe, e.g. `producer | ( xargs_P 4 cmd args )'. Two reasons:
# (1) zsh does NOT fork the right side of a pipe when it's a function or
# block, so without the parens the `exec' below would replace the
# caller's shell.  (2) On zsh 4.3.11, an internal `( ... )' inside a
# function-on-pipe-right triggers SIGBUS at higher fork counts -- the
# parens have to be at the call site, not in the function body.
xargs_P() {
  local nproc=$1; shift
  if _xargs_supports_P; then
    exec xargs -P "$nproc" -I {} "$@"
  fi
  local line a
  local -a pids cmd
  while IFS= read -r line; do
    cmd=()
    for a in "$@"; do
      cmd+=( "${a//\{\}/$line}" )
    done
    "${cmd[@]}" &
    pids+=( $! )
  done
  (( ${#pids} )) && wait "${pids[@]}" 2>/dev/null
}

_xargs_supports_P() {
  if [[ -z ${_XARGS_P_OK+set} ]]; then
    # `< /dev/null' rather than `: | xargs ...': fewer forks per probe,
    # which matters on zsh 4.3.11 where the fork machinery is fragile.
    # `-gx' exports the cache so test subshells skip the re-probe.
    if xargs -P 1 -I {} true < /dev/null 2>/dev/null; then
      typeset -gx _XARGS_P_OK=1
    else
      typeset -gx _XARGS_P_OK=0
    fi
  fi
  (( _XARGS_P_OK ))
}

# Run BODY in a fresh `zsh --no-rcs -c` after binding Tab to expand-or-complete
# and sourcing the plugin. Tests that need different setup before sourcing
# (e.g. _Z_CMD=zoo, or a non-default Tab binding as captured baseline) must
# use raw `zsh -c`.
zshz_in_fresh_shell() {
  zsh --no-rcs -c "
    bindkey -M main '^I' expand-or-complete
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    $1
  "
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:

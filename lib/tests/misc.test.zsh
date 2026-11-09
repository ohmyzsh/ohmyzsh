#!/usr/bin/env zsh

# Checks which ZLE widgets lib/misc.zsh registers for pasting and typing.
#
# `bracketed-paste-magic` replays pasted text keystroke by keystroke inside a
# temporary history file (`fc -p` … `fc -P`) and rolls that replay back with
# `zle .undo`. Pushing and popping a history stack while ZLE is active corrupts
# the undo state, and the next undo then crashes the shell, so Oh My Zsh must
# install `bracketed-paste-url-magic` whenever it is available:
# https://github.com/ohmyzsh/ohmyzsh/issues/13881
#
# Run with: zsh -df lib/tests/misc.test.zsh

emulate -L zsh
setopt err_return no_nomatch

test_dir=$(mktemp -d) || exit 1
trap 'command rm -rf -- "$test_dir"' EXIT

misc_zsh="${0:A:h:h}/misc.zsh"

typeset -i tests=0 failures=0

# Creates an autoload directory holding one empty function per argument. An
# empty `is-at-least` makes every zsh version check succeed, so these tests do
# not depend on the zsh version running them.
make_stub_dir() {
  local dir=$1 name
  shift
  mkdir -p "$dir"
  for name in "$@"; do
    print -r -- '' >| "$dir/$name"
  done
  print -r -- "$dir"
}

# Sources lib/misc.zsh in a clean shell where $fpath only contains the given
# directories, and prints the resulting widgets. $1 is the value of
# DISABLE_MAGIC_FUNCTIONS (empty when unset), the rest are $fpath entries.
misc_widgets() {
  local disable_magic=$1
  shift
  zsh -df -c '
    emulate -L zsh
    local disable_magic=$1 misc_zsh=$2
    shift 2
    fpath=("$@")
    # env_default() is defined by lib/functions.zsh, which is loaded before
    # lib/misc.zsh when Oh My Zsh starts up.
    env_default() { return 0; }
    if [[ -n "$disable_magic" ]]; then
      DISABLE_MAGIC_FUNCTIONS="$disable_magic"
    fi
    source -- "$misc_zsh"
    print -r -- "bracketed-paste=${widgets[bracketed-paste]} self-insert=${widgets[self-insert]} leftover=${_omz_paste_magic-}${_omz_paste_dir-}"
  ' _ "$disable_magic" "$misc_zsh" "$@"
}

# Runs lib/misc.zsh and compares the widgets it registered.
# Arguments: <description> <expected output> [<DISABLE_MAGIC_FUNCTIONS>] [dirs…]
check_misc_widgets() {
  local description=$1 expected=$2 disable_magic=${3-}
  shift 3
  local output run_status=0
  (( ++tests ))
  output=$(misc_widgets "$disable_magic" "$@") || run_status=$?
  if (( run_status == 0 )) && [[ "$output" == "$expected" ]]; then
    print -r -- "PASS: $description"
  else
    print -u2 -r -- "FAIL: $description"
    print -u2 -r -- "  got:      ${(qqq)output} (status $run_status)"
    print -u2 -r -- "  expected: ${(qqq)expected}"
    (( ++failures ))
  fi
}

# The safe widget is used as long as it is installed somewhere in $fpath.
full=$(make_stub_dir "$test_dir/full" \
  is-at-least url-quote-magic bracketed-paste-magic bracketed-paste-url-magic)
check_misc_widgets 'prefers bracketed-paste-url-magic' \
  'bracketed-paste=user:bracketed-paste-url-magic self-insert=user:url-quote-magic leftover=' \
  '' "$full"

# … even when url-quote-magic itself comes from another directory, as happens
# with a user-provided copy of it.
copyist=$(make_stub_dir "$test_dir/copyist" is-at-least url-quote-magic)
check_misc_widgets 'finds bracketed-paste-url-magic in any $fpath directory' \
  'bracketed-paste=user:bracketed-paste-url-magic self-insert=user:url-quote-magic leftover=' \
  '' "$copyist" "$full"

# On zsh releases that do not ship bracketed-paste-url-magic (before 5.2) the
# old widget is still installed, so pasting keeps working as before.
legacy=$(make_stub_dir "$test_dir/legacy" \
  is-at-least url-quote-magic bracketed-paste-magic)
check_misc_widgets 'falls back to bracketed-paste-magic when that is all there is' \
  'bracketed-paste=user:bracketed-paste-magic self-insert=user:url-quote-magic leftover=' \
  '' "$legacy"

# Without url-quote-magic there is nothing to wrap around, so ZLE is left alone.
none=$(make_stub_dir "$test_dir/none" is-at-least)
check_misc_widgets 'registers nothing when url-quote-magic is missing' \
  'bracketed-paste=builtin self-insert=builtin leftover=' \
  '' "$none"

# Users who turn the magic functions off get the builtin widgets back.
check_misc_widgets 'registers nothing when DISABLE_MAGIC_FUNCTIONS is true' \
  'bracketed-paste=builtin self-insert=builtin leftover=' \
  'true' "$full"

# zsh older than 5.1 has no bracketed paste support at all.
old_zsh=$(make_stub_dir "$test_dir/old_zsh" \
  is-at-least url-quote-magic bracketed-paste-magic bracketed-paste-url-magic)
print -r -- 'return 1' >| "$old_zsh/is-at-least"
check_misc_widgets 'does not install a paste widget on zsh older than 5.1' \
  'bracketed-paste=builtin self-insert=user:url-quote-magic leftover=' \
  '' "$old_zsh"

print -r -- "$tests tests, $failures failures"
(( failures == 0 ))

#!/usr/bin/env zsh

emulate -LR zsh

plugin=${1:-${0:A:h:h}/brew.plugin.zsh}
test_dir=$(mktemp -d) || exit 1
trap 'command rm -rf -- "$test_dir"' EXIT

mkdir -p "$test_dir/bin"
print -rl -- '#!/bin/sh' 'exit 1' >| "$test_dir/bin/brew"
chmod +x "$test_dir/bin/brew"

typeset -i failures=0 tests=0

check_path() (
  local description="$1" prefix="$2" existing="$3" create_sbin="$4"
  export HOMEBREW_PREFIX="$test_dir/$prefix"
  if [[ $create_sbin == yes ]]; then
    mkdir -p "$HOMEBREW_PREFIX/sbin"
  fi

  # A real executable on PATH avoids discovery of the host's Homebrew install.
  path=("$test_dir/bin" /usr/bin /bin)
  case "$existing" in
    exact) path=("$HOMEBREW_PREFIX/sbin" $path) ;;
    suffix) path=("$HOMEBREW_PREFIX/sbin-backup" $path) ;;
    child) path=("$HOMEBREW_PREFIX/sbin/tools" $path) ;;
  esac
  local original_path="$PATH"
  local expected_path="$PATH"
  if [[ $create_sbin == yes && $existing != exact ]]; then
    expected_path="$HOMEBREW_PREFIX/sbin:$PATH"
  fi

  source "$plugin" || return 1
  if [[ $PATH != "$expected_path" ]]; then
    print -u2 -r -- "FAIL: $description (initial load)"
    print -u2 -r -- "  original: $original_path"
    print -u2 -r -- "  expected: $expected_path"
    print -u2 -r -- "  actual:   $PATH"
    return 1
  fi

  source "$plugin" || return 1
  if [[ $PATH != "$expected_path" ]]; then
    print -u2 -r -- "FAIL: $description (repeated load)"
    return 1
  fi
  print -r -- "PASS: $description"
)

for scenario in missing exact suffix child; do
  (( tests++ ))
  check_path "$scenario PATH entry" homebrew "$scenario" yes || (( failures++ ))
done
(( tests++ ))
check_path 'spaces and pattern characters in prefix' 'home brew[1]' suffix yes \
  || (( failures++ ))
(( tests++ ))
check_path 'literal existing prefix with pattern characters' \
  'home brew[1]' exact yes || (( failures++ ))
(( tests++ ))
check_path 'absent sbin directory' absent missing no || (( failures++ ))

print -r -- "$tests tests, $failures failures"
(( failures == 0 ))

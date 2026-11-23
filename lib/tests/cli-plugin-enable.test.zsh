#!/usr/bin/env zsh

# Run with: zsh -df lib/tests/cli-plugin-enable.test.zsh
# Runs the real `omz plugin enable` against a throwaway .zshrc.
emulate -L zsh

local cli_file=${0:A:h:h}/cli.zsh
local test_dir=$(mktemp -d)
local -i failures=0

check_enable() {
  local description=$1 input=$2 expected=$3; shift 3
  print -r -- "$input" > "$test_dir/.zshrc"
  (
    HOME=$test_dir ZDOTDIR=$test_dir
    source "$cli_file"
    plugins=()
    omz plugin enable "$@"
  ) >/dev/null 2>&1
  if [[ "$(< $test_dir/.zshrc)" != "$expected" ]]; then
    print -u2 -r -- "FAIL: $description"
    diff -u <(print -r -- "$expected") "$test_dir/.zshrc" >&2
    (( ++failures ))
    return
  fi
  print -r -- "PASS: $description"
}

{
  check_enable "enable into an empty one-line list" \
"plugins=()
source \$ZSH/oh-my-zsh.sh
export GOPATH=\"\$(go env GOPATH)\"" \
"plugins=( docker)
source \$ZSH/oh-my-zsh.sh
export GOPATH=\"\$(go env GOPATH)\"" docker

  check_enable "enable several into an empty one-line list" \
"plugins=()
plugins+=(z)" \
"plugins=( docker aws)
plugins+=(z)" docker aws

  check_enable "enable into a one-line list" \
"plugins=(git)" \
"plugins=(git docker)" docker

  check_enable "enable into a multi-line list" \
"plugins=(
  git
)" \
"plugins=(
  git
  docker
)" docker
} always {
  rm -rf -- "$test_dir"
}

(( failures == 0 )) || exit 1
print 'All omz plugin enable tests passed.'

#!/usr/bin/env zsh

# Run with: zsh -df plugins/python/tests/auto_vrun.test.zsh
emulate -LR zsh

plugin_file="${1:-${0:A:h:h}/python.plugin.zsh}"
plugin_file="${plugin_file:A}"
test_dir=$(mktemp -d) || exit 1
test_dir="${test_dir:A}"
trap 'command rm -rf -- "$test_dir"' EXIT

# Use real activation scripts, including paths with spaces and glob characters.
project="$test_dir/project [one]"
command mkdir -p "$project/src/nested" "$project-copy" \
  "$test_dir/other" || exit 1
command python3 -m venv --without-pip "$project/.venv" || exit 1
command python3 -m venv --without-pip "$project-copy/.venv" || exit 1
command mkdir -p "$project-copy-without-venv" || exit 1
command ln -s "$project" "$test_dir/project-link" || exit 1
command ln -s "$test_dir/other" "$test_dir/project-link-copy" || exit 1

cd "$test_dir" || exit 1
unset VIRTUAL_ENV
original_python=$(command -v python3)
autoload -Uz add-zsh-hook
PYTHON_VENV_NAMES=(.venv)
PYTHON_AUTO_VRUN=true
source "$plugin_file" || exit 1

typeset -i tests=0 failures=0

check_venv() {
  local description="$1" expected_venv="$2"
  local expected_python="$original_python"
  local -i expected_deactivate=0
  if [[ -n $expected_venv ]]; then
    expected_deactivate=1
    expected_python="$expected_venv/bin/python3"
  fi
  (( tests++ ))
  if [[ ${VIRTUAL_ENV-} == "$expected_venv" \
     && $(command -v python3) == "$expected_python" ]] \
    && (( $+functions[deactivate] == expected_deactivate )); then
    print -r -- "PASS: $description"
  else
    print -u2 -r -- "FAIL: $description"
    print -u2 -r -- "  venv: ${VIRTUAL_ENV-unset}"
    print -u2 -r -- "  expected: ${expected_venv:-unset}"
    print -u2 -r -- "  python3: $(command -v python3)"
    (( failures++ ))
  fi
}

check_venv 'no environment outside a project' ''
cd "$project" || exit 1
check_venv 'activate when entering a project' "$project/.venv"
auto_vrun
check_venv 'keep activation in the project root' "$project/.venv"
cd src/nested || exit 1
check_venv 'keep activation in nested subdirectories' "$project/.venv"
cd "$project-copy-without-venv" || exit 1
check_venv 'deactivate in a sibling sharing the project prefix' ''

cd "$project" || exit 1
cd "$project-copy" || exit 1
check_venv 'switch to the sibling project environment' "$project-copy/.venv"
cd "$test_dir" || exit 1
check_venv 'deactivate in the parent directory' ''
cd "$project" || exit 1
cd "$test_dir/other" || exit 1
check_venv 'deactivate in an unrelated directory' ''

cd "$test_dir/project-link" || exit 1
check_venv 'activate through a symlink to the project' "$project/.venv"
cd src/nested || exit 1
check_venv 'keep activation in symlinked subdirectories' "$project/.venv"
cd "$project/src/nested" || exit 1
check_venv 'keep activation when changing to the physical path' "$project/.venv"
cd "$test_dir/project-link-copy" || exit 1
check_venv 'deactivate through a symlink to an unrelated directory' ''

command python3 -m venv --without-pip "$project/src/.venv" || exit 1
cd "$project" || exit 1
cd src || exit 1
check_venv 'activate an environment in a nested project' "$project/src/.venv"
cd nested || exit 1
check_venv 'keep the nested project environment in its subdirectories' "$project/src/.venv"
cd "$project" || exit 1
check_venv 'restore the parent project environment' "$project/.venv"
cd "$test_dir/other" || exit 1

# Stub only deactivation so the root-parent case needs no writes under /.
check_root_parent() {
  local description="$1" VIRTUAL_ENV=/.venv
  local -i deactivated=0
  deactivate() { deactivated=1 }
  auto_vrun
  (( tests++ ))
  if [[ $VIRTUAL_ENV == /.venv ]] && (( ! deactivated )); then
    print -r -- "PASS: $description"
  else
    print -u2 -r -- "FAIL: $description"
    (( failures++ ))
  fi
  unfunction deactivate
}

check_root_parent 'keep a root-level environment in a subdirectory'
cd / || exit 1
check_root_parent 'keep a root-level environment in the root directory'

print -r -- "$tests tests, $failures failures"
(( failures == 0 ))

#!/usr/bin/env zsh

# Run with: zsh -df plugins/laravel/tests/laravel.test.zsh
emulate -LR zsh

plugin_dir=${0:A:h:h}
test_dir=$(mktemp -d) || exit 1
trap 'command rm -rf -- "$test_dir"' EXIT
typeset -i tests=0 failures=0 fixture_status=0
typeset completion_state=cmds fixture_output output

autoload -Uz compinit
compinit -D -u

# Record the interpreter's arguments even when invoked in a subshell.
php() {
  print -rl -- "$@" >| "$test_dir/call"
  print -r -- "$fixture_output"
  return $fixture_status
}

check() {
  local description=$1
  shift
  (( tests++ ))
  if "$@"; then
    print -r -- "PASS: $description"
  else
    print -u2 -r -- "FAIL: $description"
    (( failures++ ))
  fi
}

source "$plugin_dir/laravel.plugin.zsh"
check 'plugin loading does not execute PHP' test ! -e "$test_dir/call"
check 'completion is registered for artisan' \
  test "${_comps[artisan]}" = _artisan
for name in la4 la4dump la4cache la4routes la5 la5cache la5routes la5vendor; do
  check "laravel alone does not add $name" test "${+aliases[$name]}" = 0
done
for name in la4 la5; do
  check "laravel alone does not register $name completion" \
    test "${+_comps[$name]}" = 0
done

for entry in \
  'pas:serve' 'pam:migrate' 'pamm:make:model' 'bob:bob::build'; do
  name=${entry%%:*}
  expected_command=${entry#*:}
  expected_call=$'artisan\n'"$expected_command"$'\nargument with spaces'
  eval "$name 'argument with spaces'" > /dev/null
  check "$name preserves its command and arguments" \
    test "$(command cat -- "$test_dir/call")" = "$expected_call"
done

# Exercise completion dispatch without requiring an interactive ZLE session.
_arguments() { state=$completion_state; line=(migrate); return 1; }
compadd() { [[ $1 == -- ]] && shift; print -rl -- "$@"; }
_values() { print -rl -- "$@"; }
_files() { print -r -- file-completion; }

mkdir "$test_dir/project with spaces"
builtin cd "$test_dir/project with spaces"
touch artisan
fixture_output='cache:clear    Clear the application cache
migrate        Run migrations
project:custom Run a custom command'
output=$(_artisan)
check 'project commands, namespaces and custom commands are completed' \
  test "$output" = $'cache:clear\nmigrate\nproject:custom'
check 'completion uses the portable raw list interface' \
  test "$(command cat -- "$test_dir/call")" = $'artisan\nlist\n--raw\n--no-ansi'

fixture_output='routes    List Laravel 4 routes
dump-autoload    Regenerate autoload files'
output=$(_artisan)
check 'Laravel 4 commands are discovered rather than hardcoded' \
  test "$output" = $'routes\ndump-autoload'

completion_state=args
for fixture_status in 0 1; do
  command rm -f -- "$test_dir/call"
  output=$(_artisan)
  check "command arguments use file completion (PHP status $fixture_status)" \
    test "$output" = file-completion
  check "argument completion never boots Artisan (PHP status $fixture_status)" \
    test ! -e "$test_dir/call"
done
completion_state=cmds

fixture_status=1
fixture_output='Unsupported option: --raw'
output=$(_artisan)
check 'legacy Artisan retains its static completion when raw listing fails' \
  test "${output[(f)-1]}" = 'key\:\:generate[Generate a key]'
fixture_status=0

fixture_output=''
output=$(_artisan)
check 'an empty command list falls back to legacy completion' \
  test "${output[(f)-1]}" = 'key\:\:generate[Generate a key]'

command rm "$test_dir/call"
builtin cd "$test_dir"
output=$(_artisan)
check 'completion outside a project does not execute PHP' \
  test ! -e "$test_dir/call"

# A configured command may contain multiple words and quoted arguments.
wrapper() {
  print -rl -- "$@" >| "$test_dir/wrapper-call"
  print -r -- "$fixture_output"
}
zstyle ':omz:plugins:laravel' php 'wrapper --site "site with spaces" php'
source "$plugin_dir/../laravel5/laravel5.plugin.zsh" 2> "$test_dir/warning"
eval 'la5routes "argument with spaces"' > /dev/null
expected_call=$'--site\nsite with spaces\nphp\nartisan\nroute:list'
expected_call+=$'\nargument with spaces'
check 'legacy aliases honor a configured PHP wrapper' \
  test "$(command cat -- "$test_dir/wrapper-call")" = "$expected_call"
builtin cd "$test_dir/project with spaces"
fixture_output=$'project:custom Run a custom command'
output=$(_artisan)
expected_call=$'--site\nsite with spaces\nphp\nartisan\nlist\n--raw\n--no-ansi'
check 'completion honors a configured PHP wrapper' \
  test "$(command cat -- "$test_dir/wrapper-call")" = "$expected_call"
check 'wrapper output is completed' test "$output" = project:custom
zstyle -d ':omz:plugins:laravel' php

for plugin in laravel4 laravel5; do
  # Start a separate shell so no previously loaded completion can hide a
  # missing autoload path in the compatibility plugin.
  output=$(zsh -df -c '
    autoload -Uz compinit
    compinit -D -u
    source "$1" 2> "$2"
    prefix=la${3#laravel}
    for name in artisan $prefix; do
      [[ ${_comps[$name]} == _artisan ]] || exit 1
    done
    if [[ $prefix == la4 ]]; then
      [[ ${+aliases[la5]} == 0 ]] || exit 1
      expected_aliases=(
        la4 "php artisan" la4dump "php artisan dump-autoload"
        la4cache "php artisan cache:clear" la4routes "php artisan routes"
      )
    else
      [[ ${+aliases[la4]} == 0 ]] || exit 1
      expected_aliases=(
        la5 "php artisan" la5cache "php artisan cache:clear"
        la5routes "php artisan route:list"
        la5vendor "php artisan vendor:publish"
      )
    fi
    for name expected in "${expected_aliases[@]}"; do
      [[ ${aliases[$name]} == "$expected" ]] || exit 1
    done
    autoload +X _artisan || exit 1
    [[ ${functions_source[_artisan]} == */laravel/_artisan ]] || exit 1
    print -r -- loaded
  ' zsh "$plugin_dir/../$plugin/$plugin.plugin.zsh" \
    "$test_dir/warning" "$plugin")
  result=$?
  check "$plugin loads the unified completion and original aliases" \
    test "$result:$output" = '0:loaded'
  check "$plugin explains how to migrate" \
    test "$(command cat -- "$test_dir/warning")" != ''
done

print -r -- "$tests tests, $failures failures"
(( failures == 0 ))

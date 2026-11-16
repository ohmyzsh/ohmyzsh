#!/usr/bin/env zsh

# Exercise the actual ZLE widgets in an isolated interactive shell.
emulate -L zsh
setopt err_return
zmodload zsh/zpty
zmodload zsh/zselect

local test_dir=$(mktemp -d)
export GLOBALIAS_TEST_PLUGIN=${0:A:h:h}/globalias.plugin.zsh
export GLOBALIAS_TEST_RESULT=$test_dir/result

wait_for_marker() {
  local marker=$1 output received
  local -i deadline=$(( SECONDS + 5 ))
  while (( SECONDS < deadline )); do
    if zpty -r globalias-test output; then
      received+=$output
      [[ $received == *$marker* ]] && return 0
    else
      zselect -t 1 || true
    fi
  done
  print -u2 -r -- "Timed out waiting for ZLE: $received"
  return 1
}

check_expansion() {
  local input=$1 expected=$2 actual
  zpty -w -n globalias-test "$input"$' \x18'
  wait_for_marker GLOBALIAS_TEST_CAPTURED
  actual=$(< "$GLOBALIAS_TEST_RESULT")
  if [[ $actual != "$expected" ]]; then
    print -u2 -r -- "Input: ${(qqq)input}"
    print -u2 -r -- "Expected: ${(qqq)expected}; got: ${(qqq)actual}"
    return 1
  fi
}

{
  cat > "$test_dir/setup.zsh" <<'SETUP'
autoload -Uz compinit
compinit -D
source "$GLOBALIAS_TEST_PLUGIN"
alias 1='cd -1'
alias ll='ls -l'
alias -g G='| grep'
GLOBALIAS_FILTER_VALUES=(ll)
_globalias_test_capture() {
  print -rn -- "$BUFFER" > "$GLOBALIAS_TEST_RESULT"
  print -r -- $'\nGLOBALIAS_TEST_CAPTURED'
  BUFFER=
  zle .accept-line
}
zle -N _globalias_test_capture
bindkey '^X' _globalias_test_capture
PS1='GLOBALIAS_TEST_READY> '
RPROMPT=
SETUP
  zpty -b globalias-test zsh -dfi
  zpty -w globalias-test "source ${(q)test_dir}/setup.zsh"
  wait_for_marker GLOBALIAS_TEST_READY

  check_expansion 'DEBUG=1' 'DEBUG=1 '
  check_expansion 'DEBUG="1"' 'DEBUG="1" '
  check_expansion "DEBUG='1'" "DEBUG='1' "
  check_expansion '1' 'cd -1 '
  check_expansion '"1"' '"1" '
  check_expansion "'1'" "'1' "
  check_expansion '\1' '\1 '
  check_expansion 'echo G' 'echo | grep '
  check_expansion 'DEBUG=1 1' 'DEBUG=1 cd -1 '
  check_expansion 'll' 'll '
  check_expansion 'echo $((1+2))' 'echo 3 '
  check_expansion 'echo {a,b}' 'echo a b  '
  check_expansion '' ' '
  print 'All globalias expansion tests passed.'
} always {
  zpty -d globalias-test 2>/dev/null || true
  rm -rf -- "$test_dir"
}

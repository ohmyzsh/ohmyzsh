#!/usr/bin/env zsh

# Run with: zsh -df plugins/timer/tests/timer.test.zsh
emulate -L zsh

source "${0:A:h:h}/timer.plugin.zsh"

typeset -i failures=0 tests=0

check_duration() {
  local precision=$1 duration=$2 expected=$3
  local output=$(TIMER_PRECISION=$precision __timer_format_duration $duration)
  (( tests++ ))

  if [[ $output == "$expected" ]]; then
    print -r -- "PASS: $duration with precision $precision -> $output"
  else
    print -u2 -r -- "FAIL: $duration with precision $precision -> $output (expected $expected)"
    (( failures++ ))
  fi
}

check_duration 1 0.04 /0.0s
check_duration 1 3.04 /3.0s
check_duration 1 40.0 /40.0s
check_duration 1 59.94 /59.9s
check_duration 1 59.97 /1m0.0s
check_duration 1 61.5 /1m1.5s
check_duration 1 73.0 /1m13.0s
check_duration 1 119.97 /2m0.0s
check_duration 1 3599.99 /60m0.0s
check_duration 2 59.996 /1m0.00s
check_duration 2 0.02 /0.02s
check_duration 0 1.4 /1s
check_duration 0 59.6 /1m0s
check_duration 0 119.5 /2m0s

print -r -- "$tests tests, $failures failures"
(( failures == 0 ))

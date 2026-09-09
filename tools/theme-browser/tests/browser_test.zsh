#!/usr/bin/env zsh
# Run with: zsh -df tools/theme-browser/tests/browser_test.zsh
# Optionally pass one group, e.g. `slow-interrupt`, to run it alone.
# Each browser runs under a real controlling PTY, with no user startup files.
emulate -R zsh

if [[ $1 == --child ]]; then
  if [[ $2 == completion ]]; then
    function compdef { print -r -- "REGISTERED:${(j.:.)@}"; }
  fi
  source "$ZSH/lib/cli.zsh"
  # Match normal OMZ sessions without sourcing any user startup/configuration.
  setopt promptsubst
  print -r -- "LAZY:$+functions[_omz_theme_browser]:$+functions[_omz_theme_preview]"
  if [[ $2 == completion ]]; then
    # Capture the real completion function's candidates without loading the
    # user's completion setup or replacing any CLI/backend functions.
    function _describe { print -rl -- "DESCRIBE:$1" "${(@P)2}"; }
    CURRENT=3 words=(omz theme '')
    print -r -- SUBCOMMANDS
    _omz
    print -r -- END_SUBCOMMANDS
    for action in browse preview set use; do
      CURRENT=4 words=(omz theme "$action" '')
      print -r -- "CANDIDATES:$action"
      _omz
      print -r -- "END:$action"
    done
    print -r -- "STILL_LAZY:$+functions[_omz_theme_browser]:$+functions[_omz_theme_preview]"
    print -r -- COMPLETIONS_FINISHED
    exit
  fi
  if [[ $2 == reject* ]]; then
    case $2 in
      reject-stdin) omz theme browse </dev/null ;;
      reject-stdout) omz theme browse >/dev/null ;;
      *) omz theme browse ;;
    esac
    result=$?
    print -r -- "REJECT:$result:$+functions[_omz_theme_browser]:$+functions[_omz_theme_preview]"
    exit
  fi
  function _omz::theme::use { calls+=("use:$1"); ZSH_THEME=$1; }
  function _omz::theme::set { calls+=("set:$1"); ZSH_THEME=$1; }
  function browser_test_hook { : parent-hook; }
  function precmd { : parent-precmd; }
  typeset -a calls=() precmd_functions=(browser_test_hook) chpwd_functions=(browser_test_hook)
  ZSH_THEME=parent-theme PROMPT=parent-prompt RPROMPT=parent-rprompt
  typeset original_hook=$functions[browser_test_hook] original_precmd=$functions[precmd]
  typeset original_options=$(setopt) original_pwd=$PWD
  stty rows 24 cols 100
  # PENDIN is a transient kernel input-reprocessing flag, not a user mode.
  typeset original_tty=$(stty -a)
  original_tty=${${original_tty//-pendin/}//pendin/}
  tty > "$TEST_SCRATCH/tty"
  print -r -- READY
  # An interactive script otherwise aborts on SIGINT instead of returning to
  # the next prompt as an interactive command loop would.
  trap ':' INT
  omz theme browse "$2"
  result=$?
  typeset restored_tty=$(stty -a)
  restored_tty=${${restored_tty//-pendin/}//pendin/}
  if [[ $restored_tty == "$original_tty" ]]; then
    print -r -- TTY_RESTORED
  else
    print -r -- "TTY_MISMATCH:before=$original_tty after=$restored_tty"
  fi
  if [[ $PROMPT == parent-prompt && $RPROMPT == parent-rprompt &&
        $functions[browser_test_hook] == "$original_hook" &&
        $functions[precmd] == "$original_precmd" &&
        ${(j:,:)precmd_functions} == browser_test_hook &&
        ${(j:,:)chpwd_functions} == browser_test_hook &&
        -o promptsubst && $(setopt) == "$original_options" && $PWD == "$original_pwd" &&
        ${BROWSER_TEST_LEAK-unset} == unset ]]; then
    print -r -- PARENT_UNCHANGED
  fi
  print -r -- "RESULT:$result:${(j:,:)calls}:$ZSH_THEME"
  print -r -- FINISHED
  exit 0
fi

setopt err_exit pipe_fail
[[ -n $BROWSER_TEST_TRACE ]] && setopt xtrace
zmodload zsh/zpty
zmodload zsh/datetime
zmodload zsh/zselect
typeset -r repo=${0:A:h:h:h:h} self=${0:A}
typeset scratch=$(mktemp -d "${TMPDIR:-/tmp}/omz-browser-test.XXXXXXXX")
scratch=${scratch:A}
trap 'zpty -d 2>/dev/null; command rm -rf -- "$scratch"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
mkdir -p "$scratch/home" "$scratch/custom/themes/nested" "$scratch/tmp"
export ZSH=$repo ZSH_CUSTOM=$scratch/custom HOME=$scratch/home ZDOTDIR=$scratch/home
export TMPDIR=$scratch/tmp TEST_SCRATCH=$scratch TERM=xterm-256color
unset ZSH_THEME
# Even a mistakenly enabled startup-file load must never reach real dotfiles.
print -r -- 'print STARTUP_RAN; exit 99' > "$HOME/.zshenv"
print -r -- 'PROMPT="nested fixture"' > "$ZSH_CUSTOM/themes/nested/browser-fixture.zsh-theme"
for number in {01..10}; do
  print -r -- 'typeset -g BROWSER_TEST_LEAK=bad
ZSH_THEME=fixture-theme
precmd_functions=() chpwd_functions=()
function precmd { PROMPT="%F{red}FIXTURE_PREVIEW%f" }
RPROMPT="fixture-right"' > "$ZSH_CUSTOM/zz-omz-test-$number.zsh-theme"
done
print -r -- 'sleep 30 &
print -r -- $! > "$TEST_SCRATCH/slow-pid"
wait
PROMPT="SLOW_FINISHED"' > "$ZSH_CUSTOM/zz-omz-test-slow.zsh-theme"
typeset filter_probe='$(print HIT > $TEST_SCRATCH/filter-executed)'
typeset preview_probe='$(print HIT > $TEST_SCRATCH/preview-executed)'
# Emit literal preview output, rather than asking the worker to evaluate a
# prompt expression. Only a second evaluation by the browser can execute it.
print -rl -- "print -r -- ${(q)preview_probe}" 'PROMPT="literal-preview-ready"' > "$ZSH_CUSTOM/literal-browser.zsh-theme"

typeset buffer='' transcript='' chunk='' label=''
typeset -F browser_finished_at=0
function cleanup_pty {
  local record group
  for record in "${(@f)$(zpty)}"; do
    [[ $record == \(<->\)\ browser:* ]] || continue
    group=${${record#\(}%%\)*}
    kill -HUP -- -$group 2>/dev/null || true
    zselect -t 20 || true
    # A renderer regression can loop without checking its cancellation flag.
    kill -KILL -- -$group 2>/dev/null || true
  done
  zpty -d 2>/dev/null || true
  return 0
}
function fail {
  print -u2 -r -- "FAIL: $label: $1"
  print -u2 -r -- "PTY transcript, last 4000 characters (escaped): ${(V)transcript[-4000,-1]}"
  exit 1
}
function check {
  "$@" || fail "$1 assertion failed"
}
function await {
  local wanted=$1
  local -F deadline=$(( EPOCHREALTIME + ${2:-6} ))
  [[ $buffer == *"$wanted"* ]] && return 0
  while (( EPOCHREALTIME < deadline )); do
    if zpty -r browser chunk; then
      buffer+=$chunk transcript+=$chunk
      [[ $buffer == *"$wanted"* ]] && return 0
    else
      zselect -t 1 || true
    fi
  done
  fail "timed out waiting for ${(V)wanted}"
}
function send {
  buffer=''
  zpty -w -n browser "$1"
}
function start {
  label=$1 buffer='' transcript=''
  local -a launch=("$commands[zsh]" -dfi "$self" --child "$2")
  zpty -b browser exec "${(@q)launch}"
  await 'LAZY:0:0'
  await "$3"
}
function finish {
  await FINISHED
  # zpty -d can spend a second reaping an already-completed child. It is
  # harness teardown, not browser cancellation/terminal-restoration latency.
  browser_finished_at=$EPOCHREALTIME
  check test "${transcript#*TTY_RESTORED}" != "$transcript"
  check test "${transcript#*PARENT_UNCHANGED}" != "$transcript"
  check test "${transcript#*RESULT:$1}" != "$transcript"
  check test "${transcript#*$'\e[?1049l'}" != "$transcript"
  check test "${transcript#*$'\e[?25h'}" != "$transcript"
  check test "${transcript#*STARTUP_RAN}" = "$transcript"
  zpty -d browser
  [[ -z $BROWSER_TEST_TIMING ]] || print -r -- "TIMING: PTY deletion $(( EPOCHREALTIME - browser_finished_at ))s"
}

function test_completion {
  start 'completion registration, commands, theme candidates, lazy loading' completion COMPLETIONS_FINISHED
  check test "${transcript#*REGISTERED:_omz:omz}" != "$transcript"
  local section=${${transcript#*SUBCOMMANDS}%END_SUBCOMMANDS*} action
  check test "${section#*browse:Browse theme previews}" != "$section"
  check test "${section#*preview:Preview a theme without applying it}" != "$section"
  for action in browse preview set use; do
    section=${${transcript#*CANDIDATES:$action}%END:$action*}
    check test "${section#*DESCRIBE:theme}" != "$section"
    for name in robbyrussell zz-omz-test-01 nested/browser-fixture; do
      check test "${section#*$name}" != "$section"
    done
  done
  check test "${transcript#*STILL_LAZY:0:0}" != "$transcript"
  check test "${transcript#*STARTUP_RAN}" = "$transcript"
  zpty -d browser
}

function test_rejection {
  # Noninteractive rejection even with both descriptors attached to a PTY.
  label=noninteractive
  typeset -a launch=("$commands[zsh]" -df "$self" --child reject)
  zpty -b browser exec "${(@q)launch}"
  await 'REJECT:1:0:0'
  check test "${transcript#*requires an interactive terminal}" != "$transcript"
  zpty -d browser
  for mode in stdin stdout; do
    start "redirected $mode" "reject-$mode" 'REJECT:1:0:0'
    check test "${transcript#*requires an interactive terminal}" != "$transcript"
    zpty -d browser
  done
  label='noninteractive and redirected-I/O rejection'
}

function test_navigation {
  start 'filter, navigation, actions/back, Esc isolation' zz-omz-test- '> zz-omz-test-01'
  await FIXTURE_PREVIEW
  send $'\e[B'; await '> zz-omz-test-02'
  send $'\e[A'; await '> zz-omz-test-01'
  send $'\x0e'; await '> zz-omz-test-02'
  send $'\x10'; await '> zz-omz-test-01'
  send $'\e[6~'; await '> zz-omz-test-05'
  send $'\e[5~'; await '> zz-omz-test-01'
  send '09'; await '> zz-omz-test-09'
  send $'\x7f'; await '(9 themes)'
  send $'\x15'; await 'Filter:   ('
  send 'ZZ-OMZ-TEST-03'; await '> zz-omz-test-03'
  send $'\r'; await '[u] Use in session'
  send b; await 'Enter: actions'
  send $'\x15no-such-omz-fixture'; await 'No matching themes.'
  send $'\r'; await 'No matching themes.'
  send $'\e'
  finish '0::parent-theme'
}

function test_use {
  start 'explicit use dispatch' zz-omz-test-01 '> zz-omz-test-01'
  send $'\r'; await '[u] Use in session'
  send u
  finish '0:use:zz-omz-test-01:zz-omz-test-01'
}

function test_promptsubst {
  start 'literal filter/preview substitutions with parent promptsubst enabled' literal-browser '> literal-browser'
  await "$preview_probe"
  await literal-preview-ready
  check test ! -e "$scratch/preview-executed"
  send $'\x15'"$filter_probe"
  await "Filter: $filter_probe"
  await 'No matching themes.'
  check test ! -e "$scratch/filter-executed"
  send $'\x15literal-browser'
  await "$preview_probe"
  await literal-preview-ready
  send $'\e'
  finish '0::parent-theme'
  check test ! -e "$scratch/filter-executed"
  check test ! -e "$scratch/preview-executed"
}

function test_save {
  start 'explicit save dispatch (stubbed)' zz-omz-test-02 '> zz-omz-test-02'
  send $'\r'; await '[u] Use in session'
  send s
  finish '0:set:zz-omz-test-02:zz-omz-test-02'
}

function test_interrupt {
  start 'Ctrl-C restores terminal' zz-omz-test-01 '> zz-omz-test-01'
  send $'\x03'
  finish '130::parent-theme'
}

function test_resize {
  start 'resize small and back' zz-omz-test-01 '> zz-omz-test-01'
  typeset terminal=$(<"$scratch/tty")
  terminal=${terminal//$'\r'/}
  buffer=''
  stty rows 10 cols 30 < "$terminal"
  await '40 columns x 16 rows.'
  buffer=''
  stty rows 24 cols 100 < "$terminal"
  await '> zz-omz-test-01'
  send $'\e'
  finish '0::parent-theme'
}

function test_slow {
  local cancellation=$1
  command rm -f "$scratch/slow-pid"
  start "slow preview cancellation: $cancellation" zz-omz-test-slow '> zz-omz-test-slow'
  for attempt in {1..150}; do
    [[ -s "$scratch/slow-pid" ]] && break
    zselect -t 1 || true
  done
  check test -s "$scratch/slow-pid"
  typeset -F started=$EPOCHREALTIME
  case $cancellation in
    navigation)
      send $'\x15zz-omz-test-01'
      await FIXTURE_PREVIEW 2
      [[ -z $BROWSER_TEST_TIMING ]] || print -r -- "TIMING: navigation preview $(( EPOCHREALTIME - started ))s"
      (( EPOCHREALTIME - started < 2 )) || fail 'replacement preview exceeded 2 seconds'
      send $'\e'
      finish '0::parent-theme'
      ;;
    escape) send $'\e'; finish '0::parent-theme' ;;
    interrupt) send $'\x03'; finish '130::parent-theme' ;;
  esac
  [[ -z $BROWSER_TEST_TIMING ]] || print -r -- "TIMING: browser completed $(( browser_finished_at - started ))s; including teardown $(( EPOCHREALTIME - started ))s"
  (( browser_finished_at - started < 2 )) || fail "browser completion exceeded 2 seconds: $(( browser_finished_at - started ))s"
  typeset child=$(<"$scratch/slow-pid") child_state
  for attempt in {1..100}; do
    child_state=$(command ps -o stat= -p "$child" 2>/dev/null || true)
    [[ -z "${child_state//[ ZN+]/}" ]] && break
    zselect -t 1 || true
  done
  [[ -z $BROWSER_TEST_TIMING ]] || print -r -- "TIMING: descendant $child state=${child_state:-absent}, cleanup polls=$attempt"
  [[ -z "${child_state//[ ZN+]/}" ]] || fail "preview descendant $child still running: $child_state"
}

# Keep independent regressions running after a failed UI session.
unsetopt err_exit
typeset -i failures=0
for scenario in rejection completion navigation promptsubst use save interrupt resize slow-navigation slow-escape slow-interrupt; do
  [[ -z $1 || $scenario == "$1" ]] || continue
  (
    setopt err_exit
    trap 'cleanup_pty' EXIT
    if [[ $scenario == slow-* ]]; then
      test_slow "${scenario#slow-}"
    else
      test_$scenario
    fi
    print -r -- "PASS: $label"
  )
  (( $? == 0 )) || (( failures++ ))
done
typeset -a leftovers
for attempt in {1..100}; do
  leftovers=("$TMPDIR"/omz-preview.*(N))
  (( $#leftovers == 0 )) && break
  zselect -t 1 || true
done
if (( $#leftovers )); then
  print -u2 -r -- "FAIL: $#leftovers preview temporary directories remain"
  (( failures++ ))
fi
print -r -- "Theme browser regression groups failed: $failures"
(( failures == 0 ))

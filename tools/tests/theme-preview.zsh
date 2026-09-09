#!/usr/bin/env zsh
# Run with: zsh -df tools/tests/theme-preview.zsh
emulate -R zsh
setopt err_exit pipe_fail
typeset -r repo=${0:A:h:h:h}
source "$repo/tools/theme-preview.zsh"
typeset scratch=$(mktemp -d "${TMPDIR:-/tmp}/omz-preview-test.XXXXXXXX")
scratch=${scratch:A}
trap 'command rm -rf -- "$scratch"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
mkdir "$scratch/tmp"
export TMPDIR=$scratch/tmp

function check {
  if ! "$@"; then
    print -u2 -r -- "FAIL: ${(j: :)@}"
    exit 1
  fi
}

export ZSH=$scratch/omz ZSH_CUSTOM=$scratch/custom
mkdir -p "$ZSH/themes" "$ZSH_CUSTOM/themes/nested" "$scratch/home" "$scratch/work"
print -r -- "PROMPT='bundled'" > "$ZSH/themes/same.zsh-theme"
print -r -- "PROMPT='custom themes'" > "$ZSH_CUSTOM/themes/same.zsh-theme"
print -r -- "PROMPT='custom root'" > "$ZSH_CUSTOM/same.zsh-theme"
print -r -- "PROMPT='z'" > "$ZSH/themes/zebra.zsh-theme"
print -r -- "PROMPT='a'" > "$ZSH/themes/alpha.zsh-theme"
print -r -- "PROMPT='bad'" > "$ZSH/themes/"$'bad\nname.zsh-theme'
print -r -- "PROMPT='random'" > "$ZSH/themes/random.zsh-theme"
print -r -- "PROMPT='nested'" > "$ZSH_CUSTOM/themes/nested/example.zsh-theme"
check test "$(_omz_theme_names)" = $'alpha\nnested/example\nsame\nzebra'
check test "$(_omz_theme_resolve nested/example)" = "$ZSH_CUSTOM/themes/nested/example.zsh-theme"
check test "$(_omz_theme_resolve same)" = "$ZSH_CUSTOM/same.zsh-theme"
rm "$ZSH_CUSTOM/same.zsh-theme"
check test "$(_omz_theme_resolve same)" = "$ZSH_CUSTOM/themes/same.zsh-theme"
rm "$ZSH_CUSTOM/themes/same.zsh-theme"
check test "$(_omz_theme_resolve same)" = "$ZSH/themes/same.zsh-theme"
for name in ../same /same . .. nested/../same nested/./example nested//example random $'bad\nname' 'bad\name' missing ''; do
  if _omz_theme_resolve "$name" > /dev/null 2>&1; then
    print -u2 -r -- 'FAIL: accepted invalid/missing name'
    exit 1
  fi
done

# The fixtures intentionally write only inside this private, always-cleaned tree.
print -r -- 'print STARTUP_RAN; exit 99' > "$scratch/home/.zshenv"
export ZDOTDIR=$scratch/home PREVIEW_ENV=preserved
print -r -- '
typeset -g PREVIEW_LEAK=bad
export PREVIEW_ENV=changed
alias preview_leak=true
setopt noclobber
function precmd { PROMPT="hook:$PWD:$PREVIEW_ENV:%?" }
function second_hook { RPROMPT="second-hook:%?" }
precmd_functions=(second_hook)
' > "$ZSH_CUSTOM/isolation.zsh-theme"
typeset before_pwd=$PWD before_options=$(setopt) before_env=$PREVIEW_ENV
typeset output=$(_omz_theme_preview isolation 7)
check test "$PWD" = "$before_pwd"
check test "$(setopt)" = "$before_options"
check test "$PREVIEW_ENV" = "$before_env"
check test "${PREVIEW_LEAK-unset}" = unset
check test "${aliases[preview_leak]-unset}" = unset
check test "${functions[second_hook]-unset}" = unset
check test "${output#*hook:${PWD}:changed:7}" != "$output"
check test "${output#*second-hook:7}" != "$output"
check test "${output#*STARTUP_RAN}" = "$output"

print -r -- 'PROMPT="env:$PREVIEW_ENV cwd:$PWD %(?.success.failure)"' > "$ZSH_CUSTOM/status.zsh-theme"
output=$(_omz_theme_preview status)
check test "${output#*env:preserved cwd:${PWD} success}" != "$output"
output=$(_omz_theme_preview status 1)
check test "${output#*failure}" != "$output"
if _omz_theme_preview status nope >/dev/null 2>&1; then exit 1; fi

# Values produced by parameters or helpers are prompt text, not shell code for
# a second substitution pass. Check both sides and the helper's incoming status.
export PREVIEW_REEXECUTED=$scratch/reexecuted
export PREVIEW_LITERAL='$(print reexecuted > "$PREVIEW_REEXECUTED")'
print -r -- '
function literal_helper { print -r -- "helper-status:$? $PREVIEW_LITERAL" }
PROMPT='"'"'$PREVIEW_LITERAL $(literal_helper) %?'"'"'
RPROMPT='"'"'$(literal_helper) $PREVIEW_LITERAL %?'"'"'
' > "$ZSH_CUSTOM/literal.zsh-theme"
output=$(_omz_theme_preview literal 7)
check test ! -e "$PREVIEW_REEXECUTED"
check test "${output#*"$PREVIEW_LITERAL"}" != "$output"
check test "${output#*helper-status:7}" != "$output"
check test "${output#*"$PREVIEW_LITERAL 7"}" != "$output"
print -r -- 'unsetopt promptsubst; PROMPT='"'"'$PREVIEW_LITERAL %?'"'" > "$ZSH_CUSTOM/no-subst.zsh-theme"
output=$(_omz_theme_preview no-subst 7)
check test "${output#*'$PREVIEW_LITERAL 7'}" != "$output"

print -r -- 'PROMPT="conditional prompt"; [[ -n ${OMZ_PREVIEW_UNSET_SSH-} ]] && RPROMPT="remote"' > "$ZSH_CUSTOM/final-false.zsh-theme"
output=$(_omz_theme_preview final-false)
check test "${output#*conditional prompt}" != "$output"
print -r -- 'PROMPT=""' > "$ZSH_CUSTOM/empty.zsh-theme"
output=$(_omz_theme_preview empty)
print -r -- 'RPROMPT="right-only"; false' > "$ZSH_CUSTOM/right-only.zsh-theme"
output=$(_omz_theme_preview right-only)
check test "${output#*right-only}" != "$output"

# A helper can fail inside command substitution without making print -P fail.
# Its runtime diagnostic must remain visible in the sanitized partial preview.
print -r -- 'PROMPT='"'"'$( _omz_preview_missing_helper )'"'" > "$ZSH_CUSTOM/helper-failure.zsh-theme"
output=$(_omz_theme_preview helper-failure 2>&1)
check test "${output#*command not found: _omz_preview_missing_helper}" != "$output"

# A failing precmd (or array hook) stops later hooks, as in interactive zsh.
# Preserve any partial preview, but report failure rather than silently claiming
# that an incomplete initialization is a faithful preview.
for hook_setup in 'precmd() { return 3 }; precmd_functions=(must_not_run)' \
  'failed_hook() { return 4 }; precmd_functions=(failed_hook must_not_run)' \
  'failed_hook() { _omz_preview_missing_command }; precmd_functions=(failed_hook must_not_run)'; do
  print -rl -- 'PROMPT="partial prompt"; must_not_run() { print UNEXPECTED_HOOK; }' "$hook_setup" > "$ZSH_CUSTOM/hook-failure.zsh-theme"
  if _omz_theme_preview hook-failure >"$scratch/hook-error" 2>&1; then
    print -u2 -r -- 'FAIL: accepted failing precmd hook'
    exit 1
  fi
  output=$(<"$scratch/hook-error")
  check test "${output#*UNEXPECTED_HOOK}" = "$output"
  check test "${output#*remaining hooks skipped}" != "$output"
  check test "${output#*partial prompt}" != "$output"
done

# No language runtime, timeout utility, or process-inspection utility is needed
# by the backend. The worker still has zsh's usual autoload/module search paths.
mkdir "$scratch/bin"
for name in zsh mktemp mkfifo rm; do
  ln -s "$commands[$name]" "$scratch/bin/$name"
done
output=$(PATH="$scratch/bin" _omz_theme_preview status)
check test "${output#*success}" != "$output"
print -r -- '[[ ! -t 0 && ! -t 1 && ! -t 2 && ! -o interactive ]] || exit 9; PROMPT="non-tty"' > "$ZSH_CUSTOM/non-tty.zsh-theme"
output=$(_omz_theme_preview non-tty)
check test "${output#*non-tty}" != "$output"

print -r -- 'print -n -- "\e]52;c;SECRET\a\e[2J\r\b\ePSECRET\e\\"; PROMPT="%F{red}safe%f"' > "$ZSH_CUSTOM/escapes.zsh-theme"
output=$(_omz_theme_preview escapes)
check test "${output#*SECRET}" = "$output"
check test "${output#*$'\e[2J'}" = "$output"
check test "${output#*$'\r'}" = "$output"
check test "${output#*$'\e[31m'safe}" != "$output"

for code in 'return 1' 'exit 0' 'exit 7' 'if then' 'PROMPT="partial"; if then' \
  'PROMPT="partial"; return 2' 'PROMPT="partial"; _omz_preview_missing_command'; do
  print -r -- "$code" > "$ZSH_CUSTOM/broken.zsh-theme"
  if _omz_theme_preview broken >"$scratch/error" 2>&1; then
    print -u2 -r -- "FAIL: accepted broken theme: $code"
    exit 1
  fi
done
print -r -- 'while true; do print -r -- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx; done' > "$ZSH_CUSTOM/flood.zsh-theme"
if _omz_theme_preview flood >"$scratch/flood" 2>&1; then exit 1; fi
check test "$(wc -c < "$scratch/flood")" -le 32768
print -r -- 'printf "\377%.0s" {1..11000}; PROMPT="safe"' > "$ZSH_CUSTOM/bytes.zsh-theme"
_omz_theme_preview bytes >"$scratch/bytes" 2>&1
check test "$(wc -c < "$scratch/bytes")" -le 32768
check test "${$(<"$scratch/bytes")#*$'\xff'}" = "$(<"$scratch/bytes")"
print -r -- 'printf "\233m%.0s" {1..12000}; PROMPT="safe"' > "$ZSH_CUSTOM/csi-bytes.zsh-theme"
_omz_theme_preview csi-bytes >"$scratch/csi-bytes" 2>&1
check test "$(wc -c < "$scratch/csi-bytes")" -le 32768

print -r -- 'sleep 30 & print -r -- $! > "$PREVIEW_PID_FILE"; wait' > "$ZSH_CUSTOM/slow.zsh-theme"
export PREVIEW_PID_FILE=$scratch/child
zmodload zsh/datetime
typeset -F started=$EPOCHREALTIME
if _omz_theme_preview slow >"$scratch/timeout" 2>&1; then exit 1; fi
check test $(( EPOCHREALTIME - started < 5 )) = 1
check test "${$(<"$scratch/timeout")#*timed out}" != "$(<"$scratch/timeout")"
typeset child=$(<"$scratch/child")
# A killed orphan may briefly remain a zombie until the system reaps it.
typeset child_state=$(command ps -o stat= -p "$child" 2>/dev/null || true)
check test -z "${child_state//[ ZN+]/}"

for signal in INT TERM HUP; do
  rm -f "$PREVIEW_PID_FILE"
  _omz_theme_preview slow >"$scratch/cancel" 2>&1 &
  typeset preview_job=$!
  for attempt in {1..100}; do
    [[ -s "$PREVIEW_PID_FILE" ]] && break
    sleep 0.01
  done
  check test -s "$PREVIEW_PID_FILE"
  # zsh adds a waiting wrapper around a backgrounded subshell function.
  # Signal the supervisor itself; terminal interrupts reach it via the job group.
  typeset supervisor='' candidate='' parent=''
  for candidate parent in ${(z)$(command ps -A -o pid= -o ppid=)}; do
    if [[ $parent == $preview_job ]]; then
      supervisor=$candidate
      break
    fi
  done
  check test -n "$supervisor"
  kill -$signal "$supervisor"
  typeset result=0
  wait "$preview_job" || result=$?
  if (( result != 130 && result != 143 && result != 129 )); then
    print -u2 -r -- "Unexpected cancellation result: $result: $(<"$scratch/cancel")"
  fi
  if [[ $signal == INT ]]; then
    check test "$result" = 130
  elif [[ $signal == TERM ]]; then
    check test "$result" = 143
  else
    check test "$result" = 129
  fi
  child=$(<"$PREVIEW_PID_FILE")
  child_state=$(command ps -o stat= -p "$child" 2>/dev/null || true)
  check test -z "${child_state//[ ZN+]/}"
done

print -r -- 'sleep 30 & print -r -- $! > "$PREVIEW_PID_FILE"; PROMPT="background"' > "$ZSH_CUSTOM/background.zsh-theme"
output=$(_omz_theme_preview background)
child=$(<"$PREVIEW_PID_FILE")
child_state=$(command ps -o stat= -p "$child" 2>/dev/null || true)
check test -z "${child_state//[ ZN+]/}"

# Match the browser's nested-PTY invocation, preserving other owned PTYs.
zmodload zsh/zpty
zpty -b unrelated 'exec sleep 30'
typeset -a nested_command=("$commands[zsh]" -dfc 'source "$1"; _omz_theme_preview status' zsh "$repo/tools/theme-preview.zsh")
zpty -b browser exec "${(@q)nested_command}"
output=''
for attempt in {1..300}; do
  if zpty -r browser chunk; then
    output+=$chunk
  elif ! zpty -t browser; then
    break
  else
    sleep 0.01
  fi
done
check test "${output#*success}" != "$output"
check zpty -t unrelated
zpty -d browser unrelated

# Cancellation by the browser's outer process group must also clean the
# backend's separate inner PTY group and private FIFO directory.
rm -f "$PREVIEW_PID_FILE"
nested_command=("$commands[zsh]" -dfc 'source "$1"; _omz_theme_preview slow' zsh "$repo/tools/theme-preview.zsh")
zpty -b browser exec "${(@q)nested_command}"
typeset browser_group record
for record in "${(@f)$(zpty)}"; do
  [[ $record == \(<->\)\ browser:* ]] && browser_group=${${record#\(}%%\)*}
done
check test -n "$browser_group"
for attempt in {1..100}; do
  [[ -s "$PREVIEW_PID_FILE" ]] && break
  sleep 0.01
done
check test -s "$PREVIEW_PID_FILE"
child=$(<"$PREVIEW_PID_FILE")
kill -TERM -- -$browser_group
for attempt in {1..100}; do
  child_state=$(command ps -o stat= -p "$child" 2>/dev/null || true)
  [[ -z "${child_state//[ ZN+]/}" ]] && break
  sleep 0.01
done
check test -z "${child_state//[ ZN+]/}"
zpty -d browser

# Real themes exercise synchronous git, top-level locals, command substitution,
# and hook-driven prompt construction against an isolated repository.
export ZSH=$repo
git -C "$scratch/work" init -q
git -C "$scratch/work" symbolic-ref HEAD refs/heads/preview-branch
output=$(zsh -dfc 'builtin cd "$1"; source tools/theme-preview.zsh; builtin cd "$2"; _omz_theme_preview robbyrussell' zsh "$repo" "$scratch/work")
check test "${output#*preview-branch}" != "$output"
for name in robbyrussell dieter agnoster bira nicoulaj half-life; do
  output=$(builtin cd "$scratch/work"; _omz_theme_preview "$name" 7)
  check test "${output#*Left prompt}" != "$output"
  check test "${output#*Right prompt}" != "$output"
  check test "${output#*preview-branch}" != "$output"
  if [[ $name == dieter || $name == bira ]]; then
    check test "${output#*7 }" != "$output"
  fi
done
typeset -a leftovers=("$TMPDIR"/omz-preview.*(N))
check test "$#leftovers" = 0
print -r -- 'PASS: theme preview resolution, isolation, single-pass expansion, conditional loads, hook failures, status, sanitization, limits, cancellation, descendant cleanup, and six bundled themes'

#!/bin/zsh -f
# Exercise bounded completion menus with real ZLE keystrokes and no network.
emulate -LR zsh
setopt extendedglob
zmodload zsh/zpty || exit 1
zmodload zsh/zselect || exit 1
readonly plugin_dir=${0:A:h:h}
readonly scratch=$(mktemp -d "${TMPDIR:-/tmp}/ollama-windowed.XXXXXXXX") || exit 1
integer passed=0 failed=0
cleanup() {
  zpty -d ollama-windowed 2>/dev/null
  command rm -rf -- "$scratch"
}
trap cleanup EXIT INT TERM
command mkdir -p "$scratch/bin" "$scratch/cache"
for number in {1..60}; do
  printf 'window%02d\t0\t\t0\t2026-10-08\t128K\ttools,vision\tno\n' "$number"
done > "$scratch/models.tsv"
cat > "$scratch/bin/curl" <<'CURL'
#!/bin/zsh -f
case "$*" in
  */api/v1/models*) /bin/cat "$OLLAMA_WINDOW_SCRATCH/models.tsv" ;;
  */api/v1/tags*)
    printf 'window01:small\t1000000\t1MB\t1\t1 day ago\t128K\ttools\tno\n'
    ;;
  *) print '{"models":[]}' ;;
esac
CURL
cat > "$scratch/bin/ollama" <<'OLLAMA'
#!/bin/zsh -f
print -r -- "$*" >> "$OLLAMA_WINDOW_SCRATCH/operations"
exit 1
OLLAMA
command chmod +x "$scratch/bin/curl" "$scratch/bin/ollama"
export OLLAMA_WINDOW_SCRATCH=$scratch OLLAMA_WINDOW_PLUGIN=$plugin_dir
cat > "$scratch/setup.zsh" <<'SETUP'
PATH="$OLLAMA_WINDOW_SCRATCH/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin"
XDG_CACHE_HOME="$OLLAMA_WINDOW_SCRATCH/cache"
TERM=xterm
PROMPT='WINDOW> '
RPROMPT=''
stty rows 12 cols 160
fpath=("$OLLAMA_WINDOW_PLUGIN" $fpath)
autoload -Uz compinit
compinit -D
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' metadata-url https://metadata.test
unset LISTPROMPT MENUPROMPT MENUSCROLL
source "$OLLAMA_WINDOW_PLUGIN/ollama.plugin.zsh"
unsetopt automenu menucomplete
setopt autolist listambiguous
bindkey -e
bindkey '^I' complete-word
bindkey -M menuselect $'\e[H' beginning-of-history
_window_buffer() {
  print -r -- "<<<BUFFER=$BUFFER>>>"
  print -r -- "<<<PROMPTS=${+LISTPROMPT}|${+MENUPROMPT}|${+MENUSCROLL}|$LISTPROMPT|$MENUPROMPT|$MENUSCROLL>>>"
  print -r -- '<<<END>>>'
  zle redisplay
}
zle -N _window_buffer
bindkey '^X^B' _window_buffer
_unrelated() { compadd -l first second third }
compdef _unrelated unrelated
print -r -- "<<<TTY=$(tty)>>>"
print -r -- '<<<READY>>>'
SETUP
zpty -b ollama-windowed env -u FPATH /bin/zsh -dfi
zpty -w ollama-windowed "source ${(q)scratch}/setup.zsh"
read_until() {
  local sentinel=$1 chunk
  REPLY=''
  integer attempts=0
  while (( ++attempts <= 800 )); do
    if zpty -r ollama-windowed chunk; then
      REPLY+=$chunk
      [[ $REPLY == *$sentinel* ]] && return 0
    else
      zselect -t 1
    fi
  done
  print -u2 -r -- "Timed out waiting for $sentinel: ${(qqq)REPLY}"
  return 1
}
# Wait for a prompt/menu draw, then collect until terminal output goes quiet.
read_draw() {
  local chunk
  integer allow_empty=${1:-0}
  REPLY=''
  integer attempts=0 quiet=0
  while (( ++attempts <= 800 )); do
    if zpty -r ollama-windowed chunk; then
      REPLY+=$chunk
      quiet=0
    else
      zselect -t 1
      (( ++quiet >= 50 && (${#REPLY} || allow_empty) )) && return 0
    fi
  done
  print -u2 -r -- "Timed out waiting for terminal draw: ${(qqq)REPLY}"
  return 1
}
read_until '<<<READY>>>' || exit 1
readonly terminal=${${REPLY##*'<<<TTY='}%%'>>>'*}
# READY is printed before ZLE's initial prompt. Drain it before the first test.
zselect -t 50
while zpty -r ollama-windowed initial_chunk; do :; done
assert() {
  local description=$1
  shift
  if "$@"; then
    print -r -- "ok - $description"
    (( passed++ ))
  else
    print -u2 -r -- "not ok - $description"
    print -u2 -r -- "  check: ${(qqq)@}"
    print -u2 -r -- "  buffer: ${(qqq)buffer}"
    (( failed++ ))
  fi
}
contains() { [[ $1 == *$2* ]] }
not_contains() { [[ $1 != *$2* ]] }
match_count() {
  local data=$1
  local -a identifiers
  identifiers=( ${(@f)$(print -r -- "$data" | /usr/bin/awk '
    { while (match($0, /window[0-9][0-9]/)) {
      print substr($0, RSTART, RLENGTH); $0=substr($0, RSTART+RLENGTH)
    } }' | /usr/bin/sort -u)} )
  REPLY=$#identifiers
}
start_menu() {
  zpty -w -n ollama-windowed $'\025ollama pull \t'
  read_draw || return 1
  first_draw=$REPLY
  zpty -w -n ollama-windowed $'\t'
  read_draw || return 1
  menu_draw=$first_draw$REPLY
  # Normalize the selection with native menu navigation, independent of
  # whether the first or second Tab entered the selection loop.
  zpty -w -n ollama-windowed $'\e[H'
  read_draw 1 || return 1
  start_index=1
  return 0
}
accept_buffer() {
  zpty -w -n ollama-windowed $'\r\030\002'
  read_until '<<<END>>>' || return 1
  buffer=${${REPLY##*'<<<BUFFER='}%%'>>>'*}
}
# Initial list stays within the viewport; no candidates are discarded.
start_menu || exit 1
match_count "$menu_draw"
assert 'short terminal initially shows a bounded subset of 60 matches' test "$REPLY" -gt 0
assert 'initial menu does not dump the complete catalogue' test "$REPLY" -lt 20
assert 'long menu displays navigation/progress prompt' contains "$menu_draw" 'Enter to accept'
assert 'first page contains first candidate' contains "$menu_draw" 'window01'
assert 'first page does not contain final candidate' not_contains "$menu_draw" 'window60'
accept_buffer || exit 1
assert 'Enter accepts selection with colon without submitting command' test "$buffer" = "ollama pull window$(printf '%02d' $start_index):"
# A real arrow key moves to the next row in selection mode.
start_menu || exit 1
zpty -w -n ollama-windowed $'\033[B'
read_draw || exit 1
accept_buffer || exit 1
assert 'down arrow advances model selection' test "$buffer" = "ollama pull window$(printf '%02d' $(( start_index + 1 ))):"
# Move beyond the first viewport, then accept an interior candidate.
start_menu || exit 1
repeat 30 zpty -w -n ollama-windowed $'\t'
read_draw || exit 1
assert 'navigation reaches middle of catalogue' contains "$REPLY" "window$(printf '%02d' $(( start_index + 30 )))"
accept_buffer || exit 1
assert 'middle candidate remains selectable' test "$buffer" = "ollama pull window$(printf '%02d' $(( start_index + 30 ))):"
start_menu || exit 1
repeat $(( 60 - start_index )) zpty -w -n ollama-windowed $'\t'
read_draw || exit 1
assert 'navigation reaches final candidate' contains "$REPLY" 'window60'
accept_buffer || exit 1
assert 'final candidate remains selectable' test "$buffer" = 'ollama pull window60:'
# Resize while a live menu is open. Zsh receives SIGWINCH from the PTY.
start_menu || exit 1
command stty -f "$terminal" rows 8 cols 160
zpty -w -n ollama-windowed $'\t'
read_draw || exit 1
match_count "$REPLY"
assert 'smaller terminal redraw stays bounded' test "$REPLY" -lt 12
command stty -f "$terminal" rows 24 cols 160
zpty -w -n ollama-windowed $'\t'
read_draw || exit 1
match_count "$REPLY"
assert 'larger terminal redraw exposes more candidates' test "$REPLY" -gt 8
assert 'larger terminal still windows a long catalogue' test "$REPLY" -lt 30
accept_buffer || exit 1
command stty -f "$terminal" rows 12 cols 160
# Single and partial matches preserve ordinary completion insertion.
zpty -w -n ollama-windowed $'\025ollama pull window60\t\030\002'
read_until '<<<END>>>' || exit 1
buffer=${${REPLY##*'<<<BUFFER='}%%'>>>'*}
assert 'unique model inserts colon' test "$buffer" = 'ollama pull window60:'
zpty -w -n ollama-windowed $'\025ollama pull window0\t'
read_draw || exit 1
partial_draw=${REPLY#*pullable model}
assert 'partial matches exclude other model prefixes' not_contains "$partial_draw" 'window60'
zpty -w -n ollama-windowed $'\003'
read_draw || exit 1
# Scoped defaults must leave another command's global menu preference intact.
zpty -w -n ollama-windowed $'\025unrelated \t\t\030\002'
read_until '<<<END>>>' || exit 1
buffer=${${REPLY##*'<<<BUFFER='}%%'>>>'*}
assert 'unrelated command retains ordinary completion behavior' test "$buffer" = 'unrelated '
assert 'unset global prompts restored for unrelated command' contains "$REPLY" '<<<PROMPTS=0|0|0|||>>>'
# Existing global prompt values survive an Ollama completion round trip.
zpty -w -n ollama-windowed $'\025typeset -g LISTPROMPT=prior-list MENUPROMPT=prior-select MENUSCROLL=7\nprint \'<<\'\'<PRIOR-READY>>>\'\n'
read_until '<<<PRIOR-READY>>>' || exit 1
start_menu || exit 1
accept_buffer || exit 1
zpty -w -n ollama-windowed $'\025unrelated \t\t\030\002'
read_until '<<<END>>>' || exit 1
assert 'existing global prompts restored for unrelated command' contains "$REPLY" '<<<PROMPTS=1|1|1|prior-list|prior-select|7>>>'
assert 'no Ollama operation was submitted' test ! -e "$scratch/operations"
print -r -- "$passed passed; $failed failed"
(( failed == 0 ))

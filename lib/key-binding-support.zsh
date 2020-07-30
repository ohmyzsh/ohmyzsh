# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets

zmodload -i zsh/zutil

# OMZ takes over zle-line-init/finish, to:
#  a) provide hooks for multiple init/finish functions, like $precmd_functions does
#  b) disable [sr]mkx on the few systems whose system zsh configuration enables it
typeset -g -a zle_line_init_functions zle_line_finish_functions
function zle-line-init() {
  local fcn
  for fcn in "${zle_line_init_functions[@]}"; do
    $fcn
  done
}
function zle-line-finish() {
  local fcn
  for fcn in "${zle_line_finish_functions[@]}"; do
    $fcn
  done
}
zle -N zle-line-init
zle -N zle-line-finish

# DEBUG: This is the old stuff we used to do to put the keypads in application mode
# during command line editing. It's included here to make it easy to test the
# new key binding logic under both normal and application modes. This should
# go away once the modeless key binding stuff is tested.
# Note: This breaks the zle-line-init/finish hooks from above.
if (( $_OMZ_DEBUG_SMKX )); then
  if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init() {
      echoti smkx
    }
    function zle-line-finish() {
      echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
  fi
fi
# end old keypad-mode stuff


# Extra portability cursor key mappings for local-mode keypad and terminals
# which deviate from typical terminfo entries. Supplements $terminfo.
# Maps capability names to |-delimited lists of character sequences.
# Reflects the capabilities of the $TERM defined at startup.
typeset -AHg _omz_terminfo_extra
_omz_terminfo_extra=(
  # Start with the basic Xterm local-mode sequences. (Some people call 
  # these "ANSI" key sequences.)
  kcuu1   "\e[A"  # up
  kcud1   "\e[B"  # down
  kcuf1   "\e[C"  # right ("forward")
  kcub1   "\e[D"  # left ("backward")
  khome   "\e[H"  # home
  kend    "\e[F"  # end
  )
# Portability entries for terminals we can't recognize from $TERM
# Putty and others may send the VT220 editing keypad sequences for
# Home/End. Bind those too, since there's no collision risk AFAIK.
# TODO: Should we alias the whole 6-key VT220 editing keypad?
_omz_terminfo_extra[khome]="$_omz_terminfo_extra[khome]|\e[1~"
_omz_terminfo_extra[kend]="$_omz_terminfo_extra[kend]|\e[4~"
# Do *not* bind '\e[Ow' here, which Putty may also send for End, because
# it collides with application-mode numeric keypad sequences.

# Terminal-specific portability entries for the current terminal, for
# terminals whose local-mode sequences are known to differ from Xterm's
case "$TERM" in
  rxvt-unicode*)
    # rxvt-unicde local-cursor sequences that differ from xterm
    _omz_terminfo_extra[khome]="$_omz_terminfo_extra[khome]|\e[7~"
    _omz_terminfo_extra[kend]="$_omz_terminfo_extra[kend]|\e[8~"
esac

# omz_bindkey - an extension to bindkey
#
# omz_bindkey [options] -t <capability> <command>
# omz_bindkey -c <modifier> <cursor-key> <command>
# omz_bindkey [...normal bindkey arguments...]
#
# Adds the following features on top of bindkey:
# 1) Logging
# 2) -t: binds a key, using terminfo and OMZ portability mappings
# 3) -c: binds an Xterm-style modified cursor key sequence
#
# Returns:
#   0 if a binding was made
#   1 if no binding was made
#   2 if an error occurred
function omz_bindkey() {
  emulate -L zsh
  # Note: "seq" is short for "sequence" in these functions
  # We must capture all of bindkey's options to get ordering right when calling it
  local -a omz_opts bindkey_opts
  omz_opts=()
  bindkey_opts=()
  local -A optvals
  zparseopts -a bindkey_opts -A optvals -D -E t:=omz_opts c=omz_opts M:
  if [[ -n ${omz_opts[(r)-t]} ]]; then
    # OMZ terminfo-based binding
    local cap=${optvals[-t]}
    local retval=1 seq seqs
    seqs=()
    if [[ -n "${terminfo[$cap]}" ]]; then
      seqs=("$seqs[@]" "${terminfo[$cap]}")
    fi
    if [[ -n "${_omz_terminfo_extra[$cap]}" ]]; then
      seqs=("$seqs[@]" "${(s:|:)_omz_terminfo_extra[$cap]}")
    fi
    # Done with a while loop because for seems to break here
    local ix=0
    while (( ++ix <= $#seqs )); do
      seq="${seqs[$ix]}"
      _omz_dbg_print -r "omz_bindkey: terminfo: $cap '${(q)seq}' $@"
      bindkey "${bindkey_opts[@]}" $seq "$@"
      retval=0
    done
    return $retval
  elif [[ -n ${omz_opts[(r)-c]} ]]; then
    # "-c" for "composed modified-cursor" keys
    _omz_dbg_print -r "omz_bindkey: modified-cursor: '$1' '$2' '$3'"
    _omz_bindkey_modified_cursor_key_xterm "$1" "$2" "$3"
  else
    _omz_dbg_print -r "omz_bindkey: passthrough: ${(q)@}"
    bindkey "${bindkey_opts[@]}" "$@"
  fi
}

# Xterm style function key modifier codes
typeset -Ag _omz_ti_modifiers
_omz_ti_modifiers=(
  'shift'           2
  'alt'             3
  'alt-shift'       4
  'ctrl'            5
  'ctrl-shift'      6
  'ctrl-alt'        7
  'ctrl-alt-shift'  8
  'meta'            9
  'meta-shift'      10
  'meta-alt'        11
  'meta-alt-shift'  12
  'meta-ctrl'       13
  'meta-ctrl-shift' 14
  'meta-ctrl-alt'   15
  'meta-ctrl-alt-shift' 16
  )

# Binds a modified cursor key sequence
# Uses xterm modifier mask codes,
# per http://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h2-PC-Style-Function-Keys
# When used in combination, modifier keys must be supplied in the following canonical order:
#  meta ctrl alt shift
function _omz_bindkey_modified_cursor_key_xterm() {
  emulate -L zsh
  local opts
  opts=()
  zparseopts -a opts -D -E M:
  local modifier=$1 key=$2 widget=$3
  local CSI='\e['  # Control Sequence Introducer
  local seq modified_seq
  local -A modifiers keys
  set -A modifiers ${(kv)_omz_ti_modifiers}
  keys=(
    up    A
    down  B
    right C
    left  D
    home  H
    end   F
    )
  if [[ -z "$modifiers[$modifier]" ]] || [[ -z "$keys[$key]" ]]; then
    _omz_dbg_print -r "Invalid modified-cursor-key: modifier=$modifier key=$key"
    return 1
  fi
  seq="${CSI}${keys[$key]}"
  _omz_bindkey_modified_cursor_seq_xterm_step "$seq" "$modifier"
  # Wokaround for iTerm2: it reports alt as meta, so bind alt-modified sequences
  # to the meta-modified variant, too.
  # See https://gitlab.com/gnachman/iterm2/issues/3753
  if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    if [[ "$modifier" == "alt" ]]; then
      _omz_bindkey_modified_cursor_seq_xterm_step "$seq" "meta"
    fi
  fi
}

function _omz_bindkey_modified_cursor_seq_xterm_step() {
  local seq="$1" modifier="$2"
  local modified_seq
  local -A modifiers keys
  set -A modifiers ${(kv)_omz_ti_modifiers}
  modified_seq="${seq[1,-2]}1;$modifiers[$modifier]${seq[-1,-1]}"
  omz_bindkey "${opts[@]}" "$modified_seq" "$widget"  
}


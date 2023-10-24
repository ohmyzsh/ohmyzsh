# Control whether to force a redraw on each mode change.
#
# Resetting the prompt on every mode change can cause lag when switching modes.
# This is especially true if the prompt does things like checking git status.
#
# Set to "true" to force the prompt to reset on each mode change.
# Unset or set to any other value to do the opposite.
#
# The default is not to reset, unless we're showing the mode in RPS1.
typeset -g VI_MODE_RESET_PROMPT_ON_MODE_CHANGE
# Control whether to change the cursor style on mode change.
#
# Set to "true" to change the cursor on each mode change.
# Unset or set to any other value to do the opposite.
typeset -g VI_MODE_SET_CURSOR

# Control how the cursor appears in the various vim modes. This only applies
# if $VI_MODE_SET_CURSOR=true.
#
# See https://vt100.net/docs/vt510-rm/DECSCUSR for cursor styles
typeset -g VI_MODE_CURSOR_NORMAL=2
typeset -g VI_MODE_CURSOR_VISUAL=6
typeset -g VI_MODE_CURSOR_INSERT=6
typeset -g VI_MODE_CURSOR_OPPEND=0

typeset -g VI_KEYMAP=main

function _vi-mode-set-cursor-shape-for-keymap() {
  [[ "$VI_MODE_SET_CURSOR" = true ]] || return

  # https://vt100.net/docs/vt510-rm/DECSCUSR
  local _shape=0
  case "${1:-${VI_KEYMAP:-main}}" in
    main)    _shape=$VI_MODE_CURSOR_INSERT ;; # vi insert: line
    viins)   _shape=$VI_MODE_CURSOR_INSERT ;; # vi insert: line
    isearch) _shape=$VI_MODE_CURSOR_INSERT ;; # inc search: line
    command) _shape=$VI_MODE_CURSOR_INSERT ;; # read a command name
    vicmd)   _shape=$VI_MODE_CURSOR_NORMAL ;; # vi cmd: block
    visual)  _shape=$VI_MODE_CURSOR_VISUAL ;; # vi visual mode: block
    viopp)   _shape=$VI_MODE_CURSOR_OPPEND ;; # vi operation pending: blinking block
    *)       _shape=0 ;;
  esac
  printf $'\e[%d q' "${_shape}"
}

function _visual-mode {
  typeset -g VI_KEYMAP=visual
  _vi-mode-set-cursor-shape-for-keymap "$VI_KEYMAP"
  zle .visual-mode
}
zle -N visual-mode _visual-mode

function _vi-mode-should-reset-prompt() {
  # If $VI_MODE_RESET_PROMPT_ON_MODE_CHANGE is unset (default), dynamically
  # check whether we're using the prompt to display vi-mode info
  if [[ -z "${VI_MODE_RESET_PROMPT_ON_MODE_CHANGE:-}" ]]; then
    [[ "${PS1} ${RPS1}" = *'$(vi_mode_prompt_info)'* ]]
    return $?
  fi

  # If $VI_MODE_RESET_PROMPT_ON_MODE_CHANGE was manually set, let's check
  # if it was specifically set to true or it was disabled with any other value
  [[ "${VI_MODE_RESET_PROMPT_ON_MODE_CHANGE}" = true ]]
}

# Updates editor information when the keymap changes.
function zle-keymap-select() {
  # update keymap variable for the prompt
  typeset -g VI_KEYMAP=$KEYMAP

  if _vi-mode-should-reset-prompt; then
    zle reset-prompt
    zle -R
  fi
  _vi-mode-set-cursor-shape-for-keymap "${VI_KEYMAP}"
}
zle -N zle-keymap-select

# These "echoti" statements were originally set in lib/key-bindings.zsh
# Not sure the best way to extend without overriding.
function zle-line-init() {
  local prev_vi_keymap="${VI_KEYMAP:-}"
  typeset -g VI_KEYMAP=main
  [[ "$prev_vi_keymap" != 'main' ]] && _vi-mode-should-reset-prompt && zle reset-prompt
  (( ! ${+terminfo[smkx]} )) || echoti smkx
  _vi-mode-set-cursor-shape-for-keymap "${VI_KEYMAP}"
}
zle -N zle-line-init

function zle-line-finish() {
  typeset -g VI_KEYMAP=main
  (( ! ${+terminfo[rmkx]} )) || echoti rmkx
  _vi-mode-set-cursor-shape-for-keymap default
}
zle -N zle-line-finish

bindkey -v

# allow vv to edit the command line (standard behaviour)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'vv' edit-command-line

# allow ctrl-p, ctrl-n for navigate history (standard behaviour)
bindkey '^P' up-history
bindkey '^N' down-history

# allow ctrl-h, ctrl-w, ctrl-? for char and word deletion (standard behaviour)
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word

# allow ctrl-r and ctrl-s to search the history
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward

# allow ctrl-a and ctrl-e to move to beginning/end of line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

function wrap_clipboard_widgets() {
  # NB: Assume we are the first wrapper and that we only wrap native widgets
  # See zsh-autosuggestions.zsh for a more generic and more robust wrapper
  local verb="$1"
  shift

  local widget
  local wrapped_name
  for widget in "$@"; do
    wrapped_name="_zsh-vi-${verb}-${widget}"
    if [ "${verb}" = copy ]; then
      eval "
        function ${wrapped_name}() {
          zle .${widget}
          printf %s \"\${CUTBUFFER}\" | clipcopy 2>/dev/null || true
        }
      "
    else
      eval "
        function ${wrapped_name}() {
          CUTBUFFER=\"\$(clippaste 2>/dev/null || echo \$CUTBUFFER)\"
          zle .${widget}
        }
      "
    fi
    zle -N "${widget}" "${wrapped_name}"
  done
}

wrap_clipboard_widgets copy \
    vi-yank vi-yank-eol vi-yank-whole-line \
    vi-change vi-change-eol vi-change-whole-line \
    vi-kill-line vi-kill-eol vi-backward-kill-word \
    vi-delete vi-delete-char vi-backward-delete-char

wrap_clipboard_widgets paste \
    vi-put-{before,after} \
    put-replace-selection

unfunction wrap_clipboard_widgets

# if mode indicator wasn't setup by theme, define default, we'll leave INSERT_MODE_INDICATOR empty by default
if [[ -z "$MODE_INDICATOR" ]]; then
  MODE_INDICATOR='%B%F{red}<%b<<%f'
fi

function vi_mode_prompt_info() {
  echo "${${VI_KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/$INSERT_MODE_INDICATOR}"
}

# define right prompt, if it wasn't defined by a theme
if [[ -z "$RPS1" && -z "$RPROMPT" ]]; then
  RPS1='$(vi_mode_prompt_info)'
fi

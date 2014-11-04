# Ensures that $terminfo values are valid and updates editor information when
# the keymap changes.
function zle-keymap-select zle-line-init zle-line-finish {
  # The terminal must be in application mode when ZLE is active for $terminfo
  # values to be valid.
  if (( ${+terminfo[smkx]} )); then
    printf '%s' ${terminfo[smkx]}
  fi
  if (( ${+terminfo[rmkx]} )); then
    printf '%s' ${terminfo[rmkx]}
  fi

  zle reset-prompt
  zle -R
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select
zle -N edit-command-line


bindkey -v

# allow v to edit the command line (standard behaviour)
autoload -Uz edit-command-line
bindkey -M vicmd 'v' edit-command-line

# if mode indicator wasn't setup by theme, define default
if [[ "$MODE_INDICATOR" == "" ]]; then
  MODE_INDICATOR="%{$fg_bold[red]%}<<<%{$reset_color%}"
fi

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
}

# if mode prompt wasn't setup by theme, define default
if [[ "$VIMODE_PROMPT_CMD" == "" ]]; then
  VIMODE_PROMPT_CMD="%{$fg_bold[red]%}>%{$reset_color%}"
fi

if [[ "$VIMODE_PROMPT_INS" == "" ]]; then
  VIMODE_PROMPT_INS="%{$fg[green]%}>%{$reset_color%}"
fi

# this function can be used to change the command prompt 
# to red in command mode, and green in insert mode.
# to use it, set your PROMPT to:
# PROMPT='$(vi_mode_command_prompt)'
function vi_mode_command_prompt() {
  echo "${${KEYMAP/vicmd/$VIMODE_PROMPT_CMD}/(main|viins)/$VIMODE_PROMPT_INS}"
}

# define right prompt, if it wasn't defined by a theme
if [[ "$RPS1" == "" && "$RPROMPT" == "" ]]; then
  RPS1='$(vi_mode_prompt_info)'
fi

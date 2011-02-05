# ------------------------------------------------------------------------------
#          FILE:  vi-mode.plugin.zsh
#   DESCRIPTION:  oh-my-zsh plugin file.
#        AUTHOR:  Sorin Ionescu (sorin.ionescu@gmail.com)
#       VERSION:  1.0.2
# ------------------------------------------------------------------------------


# Allow command line editing in an external editor.
autoload -Uz edit-command-line

# If mode indicator wasn't setup by theme, define a default.
if [[ "$MODE_INDICATOR" == "" ]]; then
  MODE_INDICATOR="%{$fg_bold[red]%}<%{$reset_color%}%{$fg[red]%}<<%{$reset_color%}"
fi

function zle-line-init zle-keymap-select {
  zle reset-prompt
}

# If I am using vi keys, I want to know what mode I'm currently using.
# zle-keymap-select is executed every time KEYMAP changes.
# From http://zshwiki.org/home/examples/zlewidgets
function zle-line-init zle-keymap-select {
  if [[ "$KEYMAP" == 'vicmd' ]]; then
    rprompt_cached="$RPROMPT"
    RPROMPT="$MODE_INDICATOR"
  elif [[ -n "$rprompt_cached" ]]; then
    RPROMPT="$rprompt_cached"
    rprompt_cached=""
  fi
  zle reset-prompt
}

# Accept RETURN in vi command mode.
function accept_line {
  if [[ -n "$rprompt_cached" ]]; then
    RPROMPT="$rprompt_cached"
    rprompt_cached=""
  fi
  builtin zle .accept-line
}

zle -N zle-line-init
zle -N zle-keymap-select
zle -N accept_line
zle -N edit-command-line

# Avoid binding ^J, ^M,  ^C, ^?, ^S, ^Q, etc.
bindkey -d # Reset to default.
bindkey -v # Use vi key bindings.
bindkey -M vicmd "^M" accept_line # Alow RETURN in vi command.
bindkey -M vicmd v edit-command-line # ESC-v to edit in an external editor.

bindkey ' ' magic-space
bindkey -M vicmd "gg" beginning-of-history
bindkey -M vicmd "G" end-of-history
bindkey -M vicmd "k" history-search-backward
bindkey -M vicmd "j" history-search-forward
bindkey -M vicmd "?" history-incremental-search-backward
bindkey -M vicmd "/" history-incremental-search-forward

bindkey -M viins "^L" clear-screen
bindkey -M viins "^W" backward-kill-word
bindkey -M viins "^A" beginning-of-line
bindkey -M viins "^E" end-of-line


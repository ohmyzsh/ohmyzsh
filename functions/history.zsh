## Command history configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt hist_verify
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt hist_ignore_dups
setopt share_history
setopt append_history
setopt extended_history
setopt inc_append_history


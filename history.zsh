## Command history configuration
#
HISTFILE=$HOME/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt hist_ignore_dups # ignore duplication command history list
setopt share_history # share command history data

setopt hist_verify
setopt inc_append_history
setopt extended_history
setopt hist_expire_dups_first

# History stuff.
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS

## Command history configuration
#
HISTFILE=$ZSH/log/.zsh_history
HISTSIZE=2500
SAVEHIST=2500
setopt hist_ignore_dups # ignore duplication command history list
setopt share_history # share command history data


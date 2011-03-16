## Command history configuration
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt hist_ignore_dups # ignore duplication command history list
setopt share_history # share command history data

setopt hist_verify
setopt inc_append_history
setopt extended_history
setopt hist_expire_dups_first
<<<<<<< HEAD

=======
setopt hist_ignore_space

setopt SHARE_HISTORY
>>>>>>> upstream/master
setopt APPEND_HISTORY

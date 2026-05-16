zstyle ':completion:*:*:task:*' verbose yes
zstyle ':completion:*:*:task:*:descriptions' format '%U%B%d%b%u'

zstyle ':completion:*:*:task:*' group-name ''

alias t=task
compdef _task t=task

# add redis completion function to path
fpath=($ZSH/plugins/redis-cli $fpath)
autoload -U compinit
compinit -i

# add brew completion function to path
fpath=($ZSH/plugins/gem $fpath)
autoload -U compinit
compinit -i

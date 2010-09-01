# add brew completion function to path
fpath=($ZSH/functions/gem $fpath)
autoload -U compinit
compinit -i

# add brew completion function to path
fpath=($ZSH/functions/pip $fpath)
autoload -U compinit
compinit -i

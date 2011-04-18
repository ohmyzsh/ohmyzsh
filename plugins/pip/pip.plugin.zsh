# add brew completion function to path
fpath=($ZSH/plugins/pip $fpath)
autoload -U compinit
compinit -i

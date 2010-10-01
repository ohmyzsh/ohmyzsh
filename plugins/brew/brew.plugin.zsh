# add brew completion function to path
fpath=($ZSH/plugins/brew $fpath)
autoload -U compinit
compinit -i

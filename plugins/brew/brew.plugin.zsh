# add brew completion function to path
fpath=($ZSH/functions/brew $fpath)
autoload -U compinit
compinit -i

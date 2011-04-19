# add npm completion function to path
fpath=($ZSH/plugins/npm $fpath)
autoload -U compinit
compinit -i

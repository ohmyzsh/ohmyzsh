# add cpanm completion function to path
fpath=($ZSH/plugins/cpanm $fpath)
autoload -U compinit
compinit -i

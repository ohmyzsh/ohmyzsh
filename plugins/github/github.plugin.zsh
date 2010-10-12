# add github completion function to path
fpath=($ZSH/plugins/github $fpath)
autoload -U compinit
compinit -i

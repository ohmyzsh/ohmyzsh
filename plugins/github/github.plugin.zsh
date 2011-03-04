# hub alias from defunkt
# https://github.com/defunkt/hub
if which hub > /dev/null; then
    eval $(hub alias -s zsh)
fi

# add github completion function to path
fpath=($ZSH/plugins/github $fpath)
autoload -U compinit
compinit -i

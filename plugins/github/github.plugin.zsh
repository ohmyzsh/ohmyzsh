# hub alias from defunkt
# https://github.com/defunkt/hub
if [ "$commands[(I)hub]" ]; then
    # eval `hub alias -s zsh`
    function git(){hub "$@"}
fi

# add github completion function to path
fpath=($ZSH/plugins/github $fpath)
autoload -U compinit
compinit -i

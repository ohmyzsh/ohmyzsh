# Setup hub function for git, if it is available; http://github.com/defunkt/hub
if [ "$commands[(I)hub]" ] && [ "$commands[(I)ruby]" ]; then
    # eval `hub alias -s zsh`
    function git(){hub "$@"}
fi

# add github completion function to path
fpath=($ZSH/plugins/github $fpath)
autoload -U compinit
compinit -i

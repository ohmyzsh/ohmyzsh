local hostconfig=~/.zsh/perhost/$(hostname).zsh
if [ -f ${hostconfig} ]; then
    source ${hostconfig}
fi

#!/bin/zsh
# 
# Make the dirstack more persistant
# 
# Run dirpersiststore in ~/.zlogout

dirpersiststore () {
    dirs -p | sed 's/ /\\ /g;s/^/pushd -q /;1!G;h;$!d;' > ~/.zdirstore
}

dirpersistrestore () {
    if [ -f ~/.zdirstore ]; then
        source ~/.zdirstore
    fi
}

DIRSTACKSIZE=10
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups
dirpersistrestore
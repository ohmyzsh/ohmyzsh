#!/bin/zsh
# 
# Make the dirstack more persistant
# 
# Run dirpersiststore in ~/.zlogout

dirpersiststore () {
# FIXME: need to escape all shell metacharacters, not just spaces!
    dirs -p | sed 's/ /\\ /g;s/&/\\&/;s/^/pushd -q /;1!G;h;$!d;' > ~/.zdirstore
}

dirpersistrestore () {
    if [ -f ~/.zdirstore ]; then
        source ~/.zdirstore
    fi
}

DIRSTACKSIZE=10
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups
dirpersistrestore

# Make popd changes permanent without having to wait for logout
alias popd="popd;dirpersiststore"

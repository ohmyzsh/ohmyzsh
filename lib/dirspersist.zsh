#!/bin/zsh
# 
# Make the dirstack more persistant
# 
# Run dirpersiststore in ~/.zlogout

dirpersiststore () {
    dirs -p | tail -r | perl -ne 'chomp;s/([& ])/\\$1/g ;print "if [ -d $_ ]; then pushd -q $_; fi\n"' > ~/.zdirstore
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

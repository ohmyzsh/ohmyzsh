#!/bin/zsh
# 
# Make the dirstack more persistant
# 
# Run dirpersiststore in ~/.zlogout

dirpersistinstall () {
    if grep -qL 'dirpersiststore' ~/.zlogout; then
    else
        if read -q \?"Would you like to set up your .zlogout file for use with dirspersist? (y/n) "; then
            echo "# Store dirs stack\n# See ~/.oh-my-zsh/plugins/dirspersist.plugin.zsh\ndirpersiststore" >> ~/.zlogout
        else
            echo "If you don't want this message to appear, remove dirspersist from \$plugins"
        fi
    fi
}

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

dirpersistinstall
dirpersistrestore

# Make popd changes permanent without having to wait for logout
alias popd="popd;dirpersiststore"

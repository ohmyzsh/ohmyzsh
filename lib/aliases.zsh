#!/bin/zsh

# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

# Ruby related
alias ss='thin --stats "/thin/stats" start'

# Basic directory operations
alias .='pwd'
alias ...='cd ../..'

# Super user
alias _='sudo'
alias ss='sudo su -'

#alias g='grep -in'

# Git related
alias g='git'
alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias gd='git diff | mate'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'

# Show history
alias history='fc -l 1'

# List direcory contents
#alias ls='ls -F' # This messes up colors on my linux system
alias l='ls -la'
alias ll='ls -alr'
alias sl=ls # often screw this up

alias sgem='sudo gem'

# Find ruby file
alias rfind='find . -name *.rb | xargs grep -n'

# Git and svn mix
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'

# TextMate
alias et='mate . &'
alias ett='mate app config lib db public spec test Rakefile Capfile Todo &'
alias etp='mate app config lib db public spec test vendor/plugins vendor/gems Rakefile Capfile Todo &'
alias etts='mate app config lib db public script spec test vendor/plugins vendor/gems Rakefile Capfile Todo &'

## Ruby related
# Ruby scripts
alias sc='ruby script/console'
alias sd='ruby script/server --debugger'

# Editor Ruby file in TextMate
alias mr='mate CHANGELOG app config db lib public script spec test'




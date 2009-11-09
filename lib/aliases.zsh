#!/bin/zsh

# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

alias ss='thin --stats "/thin/stats" start'
alias sg='ruby script/generate'
alias sd='ruby script/destroy'
alias sp='ruby script/plugin'
alias ssp='ruby script/spec'
alias rdbm='rake db:migrate'
alias sc='ruby script/console'
alias sd='ruby script/server --debugger'
alias devlog='tail -f log/development.log'

# Basic directory operations
alias .='pwd'
alias ...='cd ../..'
alias -- -='cd -'

# Super user
alias _='sudo'
alias ss='sudo su -'

#alias g='grep -in'

# Git related
alias g='git'
alias gst='git status'
alias gl='git pull'
alias gup='git fetch && git rebase'
alias gp='git push'
alias gd='git diff | mate'
alias gdv='git diff -w "$@" | vim -R -'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'

# Show history
alias history='fc -l 1'

# List direcory contents
alias lsa='ls -lah'
alias l='ls -la'
alias ll='ls -alr'
alias sl=ls # often screw this up

alias sgem='sudo gem'

# Find ruby file
alias rfind='find . -name *.rb | xargs grep -n'
alias afind='ack-grep -il'

# Git and svn mix
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'

# TextMate
alias et='mate . &'
alias ett='mate app config lib db public spec test Rakefile Capfile Todo &'
alias etp='mate app config lib db public spec test vendor/plugins vendor/gems Rakefile Capfile Todo &'
alias etts='mate app config lib db public script spec test vendor/plugins vendor/gems Rakefile Capfile Todo &'

# Editor Ruby file in TextMate
alias mr='mate CHANGELOG app config db lib public script spec test'
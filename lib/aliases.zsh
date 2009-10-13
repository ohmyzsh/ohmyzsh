alias pu='pushd'
alias po='popd'

alias sc='ruby script/console'
alias sdb='ruby script/dbconsole'
alias ssd='ruby script/server --debugger'
alias ss='thin --stats "/thin/stats" start'
alias sg='ruby script/generate'
alias sd='ruby script/destroy'
alias sp='ruby script/plugin'
alias ssp='ruby script/spec'
alias rdbm='rake db:migrate'

alias mr='mate CHANGELOG app config db lib public script spec test'
alias .='pwd'
alias ...='cd ../..'
alias -- -='cd -'

alias _='sudo'
alias ss='sudo su -'

#alias g='grep -in'

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
alias gdb='git branch -d'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'

alias history='fc -l 1'

alias ls='ls -F'
alias ll='ls -alr'
alias l='ls'
alias ll='ls -l'
alias sl=ls # often screw this up

alias sgem='sudo gem'

alias rfind='find . -name *.rb | xargs grep -n'
alias afind='ack-grep -il'

alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'

alias et='mate . &'
alias ett='mate app config lib db public spec test Rakefile Capfile Todo &'
alias etp='mate app config lib db public spec test vendor/plugins vendor/gems Rakefile Capfile Todo &'
alias etts='mate app config lib db public script spec test vendor/plugins vendor/gems Rakefile Capfile Todo &'




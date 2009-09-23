alias pu='pushd'
alias po='popd'

alias sc='ruby script/console'
alias sd='ruby script/server --debugger'
alias ss='thin --stats "/thin/stats" start'

alias mr='mate CHANGELOG app config db lib public script spec test'
alias .='pwd'
alias ...='cd ../..'

alias _='sudo'
alias ss='sudo su -'

#alias g='grep -in'

alias g='git'
alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias gd='git diff | mate'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'

alias history='fc -l 1'

alias ls='ls -F'
alias ll='ls -alr'
alias l='ls'
alias ll='ls -l'
alias sl=ls # often screw this up

alias sgem='sudo gem'

alias rfind='find . -name *.rb | xargs grep -n'

alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'

alias et='mate . &'
alias ett='mate app config lib db public spec test Rakefile Capfile Todo &'
alias etp='mate app config lib db public spec test vendor/plugins vendor/gems Rakefile Capfile Todo &'
alias etts='mate app config lib db public script spec test vendor/plugins vendor/gems Rakefile Capfile Todo &'




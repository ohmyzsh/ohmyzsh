alias c='cd'
alias pu='pushd'
alias po='popd'
alias sc='ruby script/console'
alias ss='ruby script/server'

alias mr='mate CHANGELOG app config db lib public script spec test'
alias .='pwd'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'

alias _='sudo'
alias ss='setsid'

alias g='grep -in'

alias s='svn'
alias e='mate'

alias history='fc -l 1'

# Git aliases

alias utb='tar jxvf'
alias utz='tar zxvf'

alias ls='ls -GF'
alias ll='ls -al'

alias sgem='sudo gem'

alias rfind='find . -name *.rb | xargs grep -n'

alias xenon='ssh rrussell@xenon.planetargon.com'

alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'

bindkey '\ew' kill-region

bindkey -s '\el' "ls\n"
bindkey -s '\e.' "..\n"
alias pu='pushd'
alias po='popd'

alias sc='ruby script/console'
alias sd='ruby script/server --debugger'
alias ss='thin --stats "/thin/stats" start'

alias mr='mate CHANGELOG app config db lib public script spec test'
alias .='pwd'
alias ...='cd ../..'

alias _='sudo'

alias g='grep -in'

alias history='fc -l 1'

alias ls='ls -GF'
alias ll='ls -al'

alias sgem='sudo gem'

alias rfind='find . -name *.rb | xargs grep -n'

alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'

bindkey '\ew' kill-region

bindkey -s '\el' "ls\n"
bindkey -s '\e.' "..\n"

alias et='mate . &'
alias ett='mate app config lib db public spec test Rakefile Capfile Todo &'
alias etp='mate app config lib db public spec test vendor/plugins vendor/gems Rakefile Capfile Todo &'
alias etts='mate app config lib db public script spec test vendor/plugins vendor/gems Rakefile Capfile Todo &'

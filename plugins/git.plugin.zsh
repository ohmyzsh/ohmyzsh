# Aliases
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


# Git and svn mix
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'

alias ggpull='git pull origin $(current_branch)'
alias ggpush='git push origin $(current_branch)'

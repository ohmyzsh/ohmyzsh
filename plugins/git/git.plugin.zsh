# Aliases
alias g='git'
alias gst='git status'
alias gsts='git status --short'
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
alias gcpe='git cherry-pick --edit '


# Git and svn mix
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
alias gsup= !DIRTY=$(git status --porcelain -uno) && git stash save svn-up-auto && git svn rebase && test -n \"$DIRTY\" && git stash pop
alias gsc=!DIRTY=$(git status --porcelain -uno) && git stash save svn-up-auto && git svn dcommit && test -n \"$DIRTY\" && git stash pop

#
# Will return the current branch name
# Usage example: git pull origin $(current_branch)
#
function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

# these aliases take advangate of the previous function
alias ggpull='git pull origin $(current_branch)'
alias ggpush='git push origin $(current_branch)'
alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'

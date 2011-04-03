# Aliases
alias g='git'
compdef g=git
alias gst='git status'
compdef gst=git
alias gl='git pull'
compdef gl=git
alias gup='git fetch && git rebase'
compdef gup=git
alias gp='git push'
compdef gp=git
alias gd='git diff | mate'
compdef gd=git
alias gdv='git diff -w "$@" | vim -R -'
compdef gdv=git
alias gc='git commit -v'
compdef gc=git
alias gca='git commit -v -a'
compdef gca=git
alias gco='git checkout'
compdef gco=git
alias gb='git branch'
compdef gb=git
alias gba='git branch -a'
compdef gba=git
alias gcount='git shortlog -sn'
compdef gcount=git
alias gcp='git cherry-pick'
compdef gcp=git
alias glg='git log --stat --max-count=5'
compdef glg=git

# Git and svn mix
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'

#
# Will return the current branch name
# Usage example: git pull origin $(current_branch)
#
function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

# these aliases take advantage of the previous function
alias ggpull='git pull origin $(current_branch)'
compdef ggpull=git
alias ggpush='git push origin $(current_branch)'
compdef ggpush=git
alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'
compdef ggpnp=git

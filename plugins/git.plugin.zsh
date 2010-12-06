# Aliases
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbr='git branch -r'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gd='git diff | mate'
alias gdv='git diff -w "$@" | vim -R -'
alias gl='git pull'
alias gp='git push'
alias gs='git status'
alias grm='git status | grep deleted | awk "{print \$3}" | xargs git rm'
alias gup='git fetch && git rebase'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'


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

# these aliases take advangate of the previous function
alias ggpull='git pull origin $(current_branch)'
alias ggpush='git push origin $(current_branch)'
alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'
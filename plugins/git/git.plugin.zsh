#
# Compatibility
#

# Check xargs flavor for -r flag
echo | xargs -r &>/dev/null && XARGS_OPTS="-r"

#
# Functions
#

# The current branch name
# Usage example: git pull origin $(current_branch)
function current_branch() {
  if [ ! -d .git ]; then return; fi
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}
# The list of remotes
function current_repository() {
  if [ ! -d .git ]; then return; fi
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo $(git remote -v | cut -d':' -f 2)
}
# Pretty log messages
function _git_log_prettily(){
  if ! [ -z $1 ]; then
    git log --pretty=$1
  fi
}
# This function return a warning if the current branch is a wip
function work_in_progress() {
  if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
    echo "WIP!!"
  fi
}

#
# Aliases
#
alias g='git'
compdef g=git
# Status
alias gst='git status'
compdef _git gst=git-status
alias gss='git status -s'
compdef _git gss=git-status
# Diff
alias gd='git diff'
compdef _git gd=git-diff
alias gdc='git diff --cached'
compdef _git gdc=git-diff
gdv() { git diff -w "$@" | view - }
compdef _git gdv=git-diff
# Pull
alias gl='git pull'
compdef _git gl=git-pull
alias gup='git pull --rebase'
compdef _git gup=git-fetch
# Push
alias gp='git push'
compdef _git gp=git-push
alias gpoat='git push origin --all && git push origin --tags'
compdef _git gpoat=git-push
# Commit
alias gc='git commit -v'
compdef _git gc=git-commit
alias gc!='git commit -v --amend'
compdef _git gc!=git-commit
alias gca='git commit -v -a'
compdef _git gca=git-commit
alias gca!='git commit -v -a --amend'
compdef _git gca!=git-commit
alias gcmsg='git commit -m'
compdef _git gcmsg=git-commit
# Checkout
alias gco='git checkout'
compdef _git gco=git-checkout
alias gcm='git checkout master'
compdef _git gcm=git-checkout
# Remote
alias gr='git remote'
compdef _git gr=git-remote
alias grv='git remote -v'
compdef _git grv=git-remote
alias grmv='git remote rename'
compdef _git grmv=git-remote
alias grrm='git remote remove'
compdef _git grrm=git-remote
alias grset='git remote set-url'
compdef _git grset=git-remote
alias grup='git remote update'
compdef _git grset=git-remote
# Rebase
alias grb='git rebase'
compdef _git grb=git-rebase
alias grbi='git rebase -i'
compdef _git grbi=git-rebase
alias grbc='git rebase --continue'
compdef _git grbc=git-rebase
alias grbs='git rebase --skip'
compdef _git grbs=git-rebase
alias grba='git rebase --abort'
compdef _git grba=git-rebase
# Cherry-pick
alias gcp='git cherry-pick'
compdef _git gcp=git-cherry-pick
# Branch
alias gb='git branch'
compdef _git gb=git-branch
alias gba='git branch -a'
compdef _git gba=git-branch
# Config
alias gcl='git config --list'
compdef _git gcl=git-config
# Add
alias ga='git add'
compdef _git ga=git-add
# Merge
alias gm='git merge'
compdef _git gm=git-merge
alias gmt='git mergetool --no-prompt'
compdef _git gmt=git-mergetool
# Reset
alias grh='git reset HEAD'
compdef _git grh=git-reset
alias grhh='git reset HEAD --hard'
compdef _git grhh=git-reset
alias gclean='git reset --hard && git clean -dfx'
# Log
alias gcount='git shortlog -sn'
compdef gcount=git
alias glg='git log --stat --color'
compdef _git glg=git-log
alias glgp='git log --stat --color -p'
compdef _git glgp=git-log
alias glgg='git log --graph --color'
compdef _git glgg=git-log
alias glgga='git log --graph --decorate --all'
compdef _git glgga=git-log
alias glo='git log --oneline --decorate --color'
compdef _git glo=git-log
alias glog='git log --oneline --decorate --color --graph'
compdef _git glog=git-log
alias gwc='git whatchanged -p --abbrev-commit --pretty=medium'
compdef _git gwc=git-whatchanged
alias glp="_git_log_prettily"
compdef _git glp=git-log
# GUI
alias gg='git gui citool'
alias gga='git gui citool --amend'
alias gk='gitk --all --branches'
# Stash
alias gsts='git stash show --text'
alias gsta='git stash'
alias gstp='git stash pop'
alias gstd='git stash drop'
alias gstl='git stash list'
# cd into the top of the current repository or submodule
alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
# Git and svn mix
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
compdef git-svn-dcommit-push=git
alias gsr='git svn rebase'
alias gsd='git svn dcommit'
# Current branch
ggl() {
  [[ "$#" != 1 ]] && b="$(current_branch)"
  git pull origin "${b:=$1}"
}
compdef _git ggl=git-checkout
ggu() {
  [[ "$#" != 1 ]] && b="$(current_branch)"
  git pull --rebase origin "${b:=$1}"
}
compdef _git ggu=git-checkout
ggp() {
  [[ "$#" != 1 ]] && b="$(current_branch)"
  git push origin "${b:=$1}"
}
compdef _git ggp=git-checkout
ggpnp() {
  ggl "$1" && ggp "$1"
}
compdef _git ggpnp=git-checkout
# Work In Progress (wip)
# These features allow to pause a branch development and switch to another one
# When you want to go back to work, just unwip it
alias gwip="git add -A; git ls-files --deleted -z | xargs ${XARGS_OPTS} -0 git rm; git commit -m \"--wip--\""
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
# Ignore changes to file
alias gignore='git update-index --assume-unchanged'
alias gunignore='git update-index --no-assume-unchanged'
# List temporarily ignored files
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
# Submodules
alias gf='git fetch'
compdef _git gf=git-fetch
alias gsi='git submodule init'
compdef _git gsi=git-submodule
alias gsu='git submodule update'
compdef _git gsu=git-submodule

# Compatibility
unset XARGS_OPTS

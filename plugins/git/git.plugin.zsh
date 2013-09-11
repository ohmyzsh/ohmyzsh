# Aliases
alias g='git'
compdef g=git
alias gst='git status'
compdef _git gst=git-status
alias gd='git diff'
compdef _git gd=git-diff
alias gl='git pull'
compdef _git gl=git-pull
alias gup='git pull --rebase'
compdef _git gup=git-pull
alias gpr='git pull --rebase'
compdef _git gpr=git-pull
alias gp='git push'
compdef _git gp=git-push
alias gf='git fetch'
compdef _git gf='git-fetch'
alias gfa='git fetch --all'
compdef _git gfa='git-fetch'
alias gd='git diff --color'
compdef _git gd=git-diff
gdv() { git diff -w "$@" | view - }
compdef _git gdv=git-diff
alias gdc='git diff --cached'
compdef _git gdc=git-diff
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
alias gco='git checkout'
compdef _git gco=git-checkout
alias gcm='git checkout master'
compdef _git gcm=git-checkout
alias grm='git rebase master'
compdef _git grm=git-rebase
alias gre='git remote'
compdef _git gre=git-remote
alias grev='git remote -v'
compdef _git grv=git-remote
alias gremv='git remote rename'
compdef _git gremv=git-remote
alias grerm='git remote remove'
compdef _git grrm=git-remote
alias greset='git remote set-url'
compdef _git greset=git-remote
alias greup='git remote update'
compdef _git greset=git-remote
alias gr='git rebase -i'
compdef _git gr=git-rebase
alias grc='git rebase --continue'
compdef _git grc=git-rebase
alias gra='git rebase --abort'
compdef _git gra=git-rebase
alias gb='git branch'
compdef _git gb=git-branch
alias gba='git branch -a'
compdef _git gba=git-branch
alias gcount='git shortlog -sn'
compdef gcount=git
alias gcl='git config --list'
compdef _git gcl=git-config
alias gcp='git cherry-pick'
compdef _git gcp=git-cherry-pick
alias glg='git log --stat --max-count=5 --color'
compdef _git glg=git-log
alias glgp='git log --stat --color -p'
compdef _git glgp=git-log
alias glgg='git log --graph --color'
compdef _git glgg=git-log
alias glgga='git log --graph --decorate --all'
compdef _git glgga=git-log
alias glo='git log --oneline'
compdef _git glo=git-log
alias gss='git status -s'
compdef _git gss=git-status
alias ga='git add'
compdef _git ga=git-add
alias gm='git merge'
compdef _git gm=git-merge
alias grh='git reset HEAD'
compdef _git grh=git-reset
alias grhh='git reset HEAD --hard'
compdef _git grhh=git-reset
alias gwc='git whatchanged -p --abbrev-commit --pretty=medium'
compdef _git gwc=git-whatchanged
alias gls='git ls-files | grep'
compdef _git gls=git-ls-files
alias gpoat='git push origin --all && git push origin --tags'
compdef _git gpoat=git-push
alias gmt='git mergetool --no-prompt'
compdef _git gmt=git-mergetool
alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
compdef _git gmtvim=git-mergetool

alias gg='git gui citool'
compdef _git gg='git gui'
alias gga='git gui citool --amend'
compdef _git gga='git gui citool --amend'
alias gk='gitk --all --branches'
compdef _git gk='gitk'
alias gsts='git stash show --text'
compdef _git gsts='git-stash'
alias gitk-entier-history='gitk --all $(git log -g --pretty=format:%h)' # show complete history, with dangling commits
compdef _git gitk='gitk'
# Note: if the commit has been cleaned my 'git gc', the dangling commits older than 2 weeks may have been deleted
#
alias gitconfig="vim ~/.gitconfig"
alias gitmessage="vim ~/.gitmessage"

# Will cd into the top of the current repository
# or submodule.
alias grt='cd $(git rev-parse --show-toplevel || echo ".")'

# Git and svn mix
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
compdef git-svn-dcommit-push=git

alias gsr='git svn rebase'
compdef _git gsr='git-svn'
alias gsd='git svn dcommit'
compdef _git gsd='git-svn'

#
# Will return the current branch name
# Usage example: git pull origin $(current_branch)
#
function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

function current_repository() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo $(git remote -v | cut -d':' -f 2)
}

# these aliases take advantage of the previous function
alias ggpull='git pull origin $(current_branch)'
compdef ggpull=git
alias ggpur='git pull --rebase origin $(current_branch)'
compdef ggpur=git
alias ggpush='git push origin $(current_branch)'
compdef ggpush=git
alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'
compdef ggpnp=git

# Pretty log messages
function _git_log_prettily(){
  if ! [ -z $1 ]; then
    git log --pretty=$1
  fi
}
alias glp="_git_log_prettily"
compdef _git glp=git-log

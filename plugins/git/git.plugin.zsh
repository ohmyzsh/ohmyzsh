# Aliases
alias g='git'
compdef g=git
alias gst='git status'
alias gsts='git status --short'
alias gl='git pull'
compdef _git gl=git-pull
alias gup='git fetch && git rebase'
compdef _git gup=git-fetch
alias gp='git push'
compdef _git gp=git-push
gdv() { git diff -w "$@" | view - }
compdef _git gdv=git-diff
alias gc='git commit -v'
compdef _git gc=git-commit
alias gca='git commit -v -a'
compdef _git gca=git-commit
alias gco='git checkout'
compdef _git gco=git-checkout
alias gb='git branch'
compdef _git gb=git-branch
alias gba='git branch -a'
compdef _git gba=git-branch
alias gcount='git shortlog -sn'
compdef gcount=git
alias gcp='git cherry-pick'
compdef _git gcp=git-cherry-pick
alias glg='git log --stat --max-count=5'
compdef _git glg=git-log

# Git and svn mix
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
compdef git-svn-dcommit-push=git

#
# Will return the current branch name
# Usage example: git pull origin $(current_branch)
#
function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

function git-info() {
    # author: Duane Johnson
    # email: duane.johnson@gmail.com
    # date: 2008 Jun 12
    # license: MIT
    # 
    # Based on discussion at http://kerneltrap.org/mailarchive/git/2007/11/12/406496

    pushd . >/dev/null

    # Find base of git directory
    while [ ! -d .git ] && [ ! `pwd` = "/" ]; do cd ..; done

    # Show various information about this git directory
    if [ -d .git ]; then
        echo "== Remote URL: `git remote -v`"

        echo "== Remote Branches: "
        git branch -r
        echo

        echo "== Local Branches:"
        git branch
        echo

        echo "== Configuration (.git/config)"
        cat .git/config
        echo

        echo "== Most Recent Commit"
        git log --max-count=1
        echo

        echo "Type 'git log' for more commits, or 'git show' for full commit details."
    else
        echo "Not a git repository."
    fi

    popd >/dev/null
}

# these aliases take advantage of the previous function
alias ggpull='git pull origin $(current_branch)'
compdef ggpull=git
alias ggpush='git push origin $(current_branch)'
compdef ggpush=git
alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'
compdef ggpnp=git

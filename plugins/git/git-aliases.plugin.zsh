# Aliases
alias g='git'                           ; compdef g=git
alias ga='git add'                      ; compdef _git ga=git-add
alias gaa='git add --all'               ; compdef _git gaa=git-add
alias gs='git status'                   ; compdef _git gs=git-status
alias gst='git status'                  ; compdef _git gst=git-status
# for `gsts "<message>"`
alias gsts='git stash save'             ; compdef _git gsts=git-stash
alias gstp='git stash pop'              ; compdef _git gstp=git-stash
alias gstl='git stash list'             ; compdef _git gstl=git-stash
alias gstll='git stash show -p --stat'  ; compdef _git gstll=git-stash
alias gl='git pull'                     ; compdef _git gl=git-pull
alias gup='git fetch && git rebase'     ; compdef _git gup=git-fetch
alias gf='git fetch'                    ; compdef _git gf=git-fetch
alias gp='git push'                     ; compdef _git gp=git-push
alias gd='git diff --no-ext-diff -b'    ; compdef _git gd=git-diff
alias gdd='git diff --no-ext-diff'      ; compdef _git gdd=git-diff
gdv() { git-diff -w "$@" | view - }     ; compdef _git gdv=git-diff
alias gc='git commit -v'                ; compdef _git gc=git-commit
alias gca='git commit -v -a'            ; compdef _git gca=git-commit
alias gco='git checkout'                ; compdef _git gco=git-checkout
alias gb='git branch'                   ; compdef _git gb=git-branch
alias gba='git branch -a'               ; compdef _git gba=git-branch
alias gcount='git shortlog -sn'         ; compdef gcount=git
alias gcp='git cherry-pick'             ; compdef _git gcp=git-cherry-pick
alias gm='git merge'                    ; compdef _git gm=git-merge
alias glg='git log --stat --max-count=5'; compdef _git glg=git-log

# Git history (pretty)
local pretty_format_oneline='--pretty=format:"%C(yellow)%h %C(green)%cd %C(cyan)%an %C(bold cyan)%d%C(reset) %s" --date=short'
local pretty_format_medium='--pretty=format:"%C(yellow)commit %H %C(bold cyan)%d%C(reset)
%C(cyan)Author: %an <%ae>%C(reset)
%C(green)Date: %cd%C(reset)
%+s
%+b"'
alias gh="git log --graph $pretty_format_oneline"                        ; compdef _git gh=git-log
alias ghh="git log --graph $pretty_format_medium"                        ; compdef _git gh=git-log
alias ghhh="git log --graph --stat $pretty_format_medium"                ; compdef _git gh=git-log
alias ghhhh="git log --graph --stat -p --full-diff $pretty_format_medium"; compdef _git gh=git-log

# Git and svn mix
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
compdef _git git-svn-dcommit-push=git

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
compdef _git ggpull=git
alias ggpush='git push origin $(current_branch)'
compdef _git ggpush=git
alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'
compdef _git ggpnp=git

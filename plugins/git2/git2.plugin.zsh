# Aliases for Git tool (rework).

############
# Common (g)
############
alias g='git'
compdef g=git

##################
# Git status (gst)
##################
# Git status
alias gst='git status'
compdef _git gst=git-status
# shortened git status
alias gsts='git status -s'
compdef _git gsts=git-status

###############
# Git Diff (gd)
###############
# Git diff (colorful)
alias gd='git diff --color'
compdef _git gd=git-diff
# Git diff staged changes
alias gdc='git diff --cached'
compdef _git gdc=git-diff
# Git diff in a vim editor
gdv() { git diff -w "$@" | view - }
compdef _git gdv=git-diff

###############
# Git Pull (gp)
###############
# Git pull
alias gp='git pull'
compdef _git gl=git-pull
# Git pull and rebase
alias gpr='git pull --rebase'
compdef _git gpr=git-pull

###############
# git push (gP)
###############
# since pushing has much impact than pulling (gp), it use a capital case
# git push
alias gP='git push'
compdef _git gP=git-push
alias gPu='git push upstream'
compdef _git gPu=git-push
alias gPum='git push upstream master'
compdef _git gPum=git-push
alias gPgPu='git push && git push upstream'
compdef _git gPgPu=git-push
alias gPgPum='git push && git push upstream master'
compdef _git gPgPum=git-push
# git push dry run
alias gPd='git push --dry-run'
compdef _git gPd=git-push
# git push force
alias gPf='git push --force'
compdef _git gPf=git-push

################
# Git Fetch (gf)
################
# Git fetch current branch
alias gf='git fetch'
compdef _git gf='git-fetch'
# Git fetch all branches
alias gfa='git fetch --all'
compdef _git gfa='git-fetch'
# reset your work to the latest status of the code base (and fetch all other branches).
# (git fetch all branch and rebase)
alias gfagpr='git fetch --all && git pull --rebase'
compdef _git gfagpr='git-pull'

#################
# Git Commit (gc)
#################
# Git commit
alias gc='git commit -v'
compdef _git gc=git-commit
# Git commit amend
alias gc!='git commit -v --amend'
compdef _git gc!=git-commit
# Git commit all tracked files
alias gca='git commit -v -a'
compdef _git gca=git-commit
# Git commit amend all tracked files
alias gca!='git commit -v -a --amend'
compdef _git gca!=git-commit
# Git commit amend all tracked files
alias gcan!='git commit -v -a -s --no-edit --amend'
compdef _git gcan!=git-commit
# Git commit with message
alias gcmsg='git commit -m'
compdef _git gcmsg=git-commit

####################
# Git Checkout (gco)
####################
# git checkout
alias gco='git checkout'
compdef _git gco=git-checkout
# Git checkout master
alias gcom='git checkout master'
compdef _git gcom=git-checkout

# Git Remote (gre)
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

# Git Rebase (gr)
alias gr='git rebase -i'
compdef _git gr=git-rebase
alias grc='git rebase --continue'
compdef _git grc=git-rebase
alias gra='git rebase --abort'
compdef _git gra=git-rebase
alias grs='git rebase --skip'
compdef _git grs=git-rebase
alias grm='git rebase master'
compdef _git grm=git-rebase

#####################################################
# Git rebase Interactively N commit (rewrite history)
#####################################################
alias gr2='git rebase -i HEAD~2'
compdef _git gr2=git-rebase
alias gr3='git rebase -i HEAD~3'
compdef _git gr3=git-rebase
alias gr4='git rebase -i HEAD~4'
compdef _git gr4=git-rebase
alias gr5='git rebase -i HEAD~5'
compdef _git gr5=git-rebase
alias gr6='git rebase -i HEAD~6'
compdef _git gr6=git-rebase
alias gr7='git rebase -i HEAD~7'
compdef _git gr7=git-rebase
alias gr8='git rebase -i HEAD~8'
compdef _git gr8=git-rebase
alias gr9='git rebase -i HEAD~9'
compdef _git gr9=git-rebase
alias gr10='git rebase -i HEAD~10'
compdef _git gr10=git-rebase

# Git Branch (gb)
alias gb='git branch'
compdef _git gb=git-branch
alias gba='git branch -a'
compdef _git gba=git-branch

##############
# Git Log (gl)
##############
alias gl='git log'
compdef _git gl=git-log
# Git log graph
alias glg='git log --stat --max-count=10'
compdef _git glg=git-log
# Git log graph with patch content
alias glgp='git log --graph --max-count=10 -p'
compdef _git glgp=git-log
## Git log graph limited to 10
alias glgm='git log --graph --max-count=10'
compdef _git glgm=git-log
# Git log graph colorful
alias glgg='git log --graph --color'
compdef _git glgg=git-log
# Git log graph with all branches
alias glgga='git log --graph --decorate --all'
compdef _git glgga=git-log
# one line git log
alias glo='git log --oneline'
compdef _git glo=git-log
alias glol="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
compdef _git glol=git-log
alias glola="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
compdef _git glola=git-log

######################
# Git Reset Head (grh)
######################
# Soft Reset to HEAD
alias grh='git reset HEAD'
compdef _git grh=git-reset
# Hard Reset
alias grH='git reset --hard'
compdef _git grH=git-reset
# Hard reset to HEAD
alias grhH='git reset HEAD --hard'
compdef _git grhH=git-reset

################
# Git merge (gm)
################
# Git merge
alias gm='git merge'
compdef _git gm=git-merge
# git merge changes from the master branch on the upstream remote
alias gmum='git merge upstream/master'
compdef _git gmum=git-merge
# git merge changes from the master branch on the origin remote
alias gmom='git merge origin/master'
compdef _git gmom=git-merge

# Other
# Show contribution scorecard
alias gcount='git shortlog -sn'
compdef gcount=git
# Show current configuration
alias gcl='git config --list'
compdef _git gcl=git-config
alias gcp='git cherry-pick'
compdef _git gcp=git-cherry-pick
alias ga='git add'
compdef _git ga=git-add

# See what changed in the current commit
alias gwc='git whatchanged -p --abbrev-commit --pretty=medium'
compdef _git gwc=git-whatchanged

# Search for a changed file
alias gls='git ls-files | grep'
compdef _git gls=git-ls-files

alias gpoat='git push origin --all && git push origin --tags'
compdef _git gpoat=git-push
alias gmt='git mergetool --no-prompt'
compdef _git gmt=git-mergetool
alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
compdef _git gmtvim=git-mergetool

# Git stash (gsta)
alias gsta='git stash'
compdef _git gsta='git-stash'
alias gstas='git stash show --text'
compdef _git gstas='git-stash'
alias gstap='git stash pop'
compdef _git gstap='git-stash'
alias gstaa='git stash apply'
compdef _git gstaa='git-stash'
alias gstad='git stash drop'
compdef _git gstad='git-stash'

# Git Gui (gg)
alias gg='git gui citool'
compdef _git gg='git gui'
alias gga='git gui citool --amend'
compdef _git gga='git gui citool --amend'

# Gitk
alias gk='\gitk --all --branches'
compdef _git gk='gitk'
# show complete history, with dangling commits
alias gitk-entier-history='\gitk --all $(git log -g --pretty=format:%h)'
compdef _git gitk='gitk'
alias gke='gitk-entier-history'
compdef _git gke='gitk'
# Note: if the commit has been cleaned my 'git gc', the dangling commits older than 2 weeks may have been deleted

# Clean
# Remove all .orig, .BASE.*, .REMOTE.*, .LOCAL.*, *.BACKUP files
alias gclean='find $(git rev-parse --show-toplevel) -name "*.orig" -or -name "*.REMOTE.*" -or -name "*.LOCAL.*" -or -name "*.BACKUP.*" -or -name "*.BASE.*" | xargs -r rm -v'
alias gcleanreset='(cd $(git rev-parse --show-toplevel) && git reset --hard && git clean -dfx)'

# Edit global Git configuration files
alias gitconfig="vim ~/.gitconfig"
alias gitmessage="vim ~/.gitmessage"

# Will cd into the top of the current repository
# or submodule.
alias grt='cd $(git rev-parse --show-toplevel || echo ".")'

# Git and svn mix
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
compdef git-svn-dcommit-push=git

# Git SVN
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

# Work In Progress (wip)
# These features allow to pause a branch development and switch to another one (wip)
# When you want to go back to work, just unwip it
#
# This function return a warning if the current branch is a wip
function work_in_progress() {
  if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
    echo "WIP!!"
  fi
}
# these alias commit and uncomit wip branches
alias gwip='git add -A; git ls-files --deleted -z | xargs -0 git rm; git commit -m "--wip--"'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'

# these alias ignore changes to file
alias gignore='git update-index --assume-unchanged'
compdef _git gignore='git update-index'
alias gunignore='git update-index --no-assume-unchanged'
compdef _git gunignore='git update-index'
# list temporarily ignored files
alias gignored='git ls-files -v | grep "^[[:lower:]]"'

# Tig aliases
alias tg='tig --all'
alias tiga='tig --all'



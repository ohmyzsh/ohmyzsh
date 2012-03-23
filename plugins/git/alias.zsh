#
# Defines Git aliases.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Git
alias g='git'
compdef g=git

# Branch (b)
alias gb='git branch'
compdef _git gb=git-branch
alias gbc='git checkout -b'
compdef _git gbc=git-checkout
alias gbl='git branch -v'
compdef _git gbl=git-branch
alias gbL='git branch -av'
compdef _git gbL=git-branch
alias gbx='git branch -d'
compdef _git gbx=git-branch
alias gbX='git branch -D'
compdef _git gbX=git-branch
alias gbm='git branch -m'
compdef _git gbm=git-branch
alias gbM='git branch -M'
compdef _git gbM=git-branch

# Commit (c)
alias gc='git commit'
compdef _git gc=git-commit
alias gca='git commit --all'
compdef _git gca=git-commit
alias gcm='git commit --message'
compdef _git gcm=git-commit
alias gco='git checkout'
compdef _git gco=git-checkout
alias gcO='git checkout HEAD --'
compdef _git gcO=git-checkout
alias gcf='git commit --amend --reuse-message HEAD'
compdef _git gcf=git-commit
alias gcp='git cherry-pick --ff'
compdef _git gcp=git-cherry-pick
alias gcP='git cherry-pick --no-commit'
compdef _git gcP=git-cherry-pick
alias gcr='git revert'
compdef _git gcr=git-revert
alias gcR='git reset "HEAD^"'
compdef _git gcR=git-reset
alias gcs='git show'
compdef _git gcs=git-show
alias gcv='git fsck | awk '\''/dangling commit/ {print $3}'\'' | git show --format="SHA1: %C(green)%h%C(reset) %f" --stdin | awk '\''/SHA1/ {sub("SHA1: ", ""); print}'\'''

# Data (d)
alias gd='git ls-files'
compdef _git gd=git-ls-files
alias gdc='git ls-files --cached'
compdef _git gdc=git-ls-files
alias gdx='git ls-files --deleted'
compdef _git gdx=git-ls-files
alias gdm='git ls-files --modified'
compdef _git gdm=git-ls-files
alias gdu='git ls-files --other --exclude-standard'
compdef _git gdu=git-ls-files
alias gdk='git ls-files --killed'
compdef _git gdk=git-ls-files
alias gdi='git status --porcelain --short --ignored | sed -n "s/^!! //p"'

# Fetch (f)
alias gf='git fetch'
compdef _git gf=git-fetch
alias gfc='git clone'
compdef _git gfc=git-clone
alias gfm='git pull'
compdef _git gfm=git-pull
alias gfr='git pull --rebase'
compdef _git gfr=git-pull

# Index (i)
alias gia='git add'
compdef _git gia=git-add
alias giA='git add --patch'
compdef _git giA=git-add
alias giu='git add --update'
compdef _git giu=git-add
alias gid='git diff --no-ext-diff --cached'
compdef _git gid=git-diff
function giD { git diff --no-ext-diff --cached --ignore-all-space "$@" | view - }
compdef _git giD=git-diff
alias gir='git reset'
compdef _git gir=git-reset
alias giR='git reset --mixed'
compdef _git giR=git-reset
alias gix='git rm -r --cached'
compdef _git gix=git-rm
alias giX='git rm -rf --cached'
compdef _git giX=git-rm
alias gig='git grep --cached'
compdef _git gig=git-grep

# Konflict (k)
alias gkl='git status | sed -n "s/^.*both [a-z]*ed: *//p"'
alias gka='git add $(gkl)'
compdef _git gka=git-add
alias gke='git mergetool $(gkl)'
alias gko='git checkout --ours --'
compdef _git gko=git-checkout
alias gkO='gko $(gkl)'
alias gkt='git checkout --theirs --'
compdef _git gkt=git-checkout
alias gkT='gkt $(gkl)'

# Log (l)
git_log_format_medium='--pretty=format:%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'
git_log_format_oneline='--pretty=format:%C(green)%h%C(reset) %s%n'
git_log_format_brief='--pretty=format:%C(green)%h%C(reset) %s%n%C(blue)(%ar by %an)%C(red)%d%C(reset)%n'

alias gl='git log --topo-order ${git_log_format_medium}'
compdef _git gl=git-log
alias gls='git log --topo-order --stat ${git_log_format_medium}'
compdef _git gls=git-log
alias gld='git log --topo-order --stat --patch --full-diff ${git_log_format_medium}'
compdef _git gld=git-log
alias glo='git log --topo-order ${git_log_format_oneline}'
compdef _git glo=git-log
alias glg='git log --topo-order --all --graph ${git_log_format_oneline}'
compdef _git glg=git-log
alias glb='git log --topo-order ${git_log_format_brief}'
compdef _git glb=git-log
alias glc='git shortlog --summary --numbered'
compdef _git glc=git-shortlog

# Merge (m)
alias gm='git merge'
compdef _git gm=git-merge
alias gmC='git merge --no-commit'
compdef _git gmC=git-merge
alias gmF='git merge --no-ff'
compdef _git gmF=git-merge
alias gma='git merge --abort'
compdef _git gma=git-merge
alias gmt='git mergetool'
compdef _git gmt=git-mergetool

# Push (p)
alias gp='git push'
compdef _git gp=git-push
alias gpf='git push --force'
compdef _git gpf=git-push
alias gpa='git push --all'
compdef _git gpa=git-push
alias gpA='git push --all && git push --tags'
compdef _git gpA=git-push
alias gpt='git push --tags'
compdef _git gpt=git-push
alias gpc='git push --set-upstream origin "$(git-branch)"'
compdef _git gpc=git-push
alias gpp='git pull origin "$(git-branch)" && git push origin "$(git-branch)"'

# Rebase (r)
alias gr='git rebase'
compdef _git gr=git-rebase
alias gra='git rebase --abort'
compdef _git gra=git-rebase
alias grc='git rebase --continue'
compdef _git grc=git-rebase
alias gri='git rebase --interactive'
compdef _git gri=git-rebase
alias grs='git rebase --skip'
compdef _git grs=git-rebase

# Remote (R)
alias gR='git remote'
compdef _git gh=git-remote
alias gRl='git remote --verbose'
compdef _git gRl=git-remote
alias gRa='git remote add'
compdef _git gRa=git-remote
alias gRx='git remote rm'
compdef _git gRx=git-remote
alias gRm='git remote rename'
compdef _git gRm=git-remote
alias gRu='git remote update'
compdef _git gRu=git-remote
alias gRc='git remote prune'
compdef _git gRc=git-remote
alias gRs='git remote show'
compdef _git gRs=git-remote
alias gRb='git-hub'
compdef _git-hub gRb=git-hub

# Stash (s)
alias gs='git stash'
compdef _git gs=git-stash
alias gsa='git stash apply'
compdef _git gsa=git-stash
alias gsc='git stash clear'
compdef _git gsc=git-stash
alias gsx='git stash drop'
compdef _git gsx=git-stash
alias gsl='git stash list'
compdef _git gsl=git-stash
alias gsL='git stash show --patch --stat'
compdef _git gsL=git-stash
alias gsp='git stash pop'
compdef _git gsp=git-stash
alias gss='git stash save --include-untracked'
compdef _git gss=git-stash
alias gsS='git stash save --patch --no-keep-index'
compdef _git gsS=git-stash

# Submodule (S)
alias gS='git submodule'
compdef _git gS=git-submodule
alias gSa='git submodule add'
compdef _git gSa=git-submodule
alias gSf='git submodule foreach'
compdef _git gSf=git-submodule
alias gSi='git submodule init'
compdef _git gSi=git-submodule
alias gSl='git submodule status'
compdef _git gSl=git-submodule
alias gSs='git submodule sync'
compdef _git gSs=git-submodule
alias gSu='git submodule update'
compdef _git gSu=git-submodule
alias gSU='git submodule update --init --recursive'
compdef _git gSU=git-submdoule

# Working Copy (w)
alias gws='git status --short'
compdef _git gws=git-status
alias gwS='git status'
compdef _git gwS=git-status
alias gwd='git diff --no-ext-diff'
compdef _git gwd=git-diff
function gwD { git diff --no-ext-diff --ignore-all-space "$@" | view - }
compdef _git gwD=git-diff
alias gwr='git reset --soft'
compdef _git gwr=git-reset
alias gwR='git reset --hard'
compdef _git gwR=git-reset
alias gwc='git clean -n'
compdef _git gwc=git-clean
alias gwC='git clean -f'
compdef _git gwC=git-clean
alias gwx='git rm -r'
compdef _git gwx=git-rm
alias gwX='git rm -rf'
compdef _git gwX=git-rm
alias gwg='git grep'
compdef _git gwg=git-grep


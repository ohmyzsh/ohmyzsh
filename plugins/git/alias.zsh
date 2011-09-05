# Git
alias g='git'
compdef g=git

# Working Copy (w)
alias gws='git status --short'
compdef _git gws=git-status
alias gwS='git status'
compdef _git gwS=git-status
alias gwd='git diff --no-ext-diff'
compdef _git gwd=git-diff
function gwD() { git diff --no-ext-diff --ignore-all-space "$@" | view - }
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

# Index
alias gia='git add'
compdef _git gia=git-add
alias giA='git add --patch'
compdef _git giA=git-add
alias giu='git add --update'
compdef _git giu=git-add
alias gid='git diff --no-ext-diff --cached'
compdef _git gid=git-diff
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

# Branah (b)
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

# Conflict (k)
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

# File Data (d)
alias gd='git ls-files'
compdef _git gd=git-ls-files
alias gdc='git ls-files --cached'
compdef _git gdc=git-ls-files
alias gdx='git ls-files --deleted'
compdef _git gdx=git-ls-files
alias gdm='git ls-files --modified'
compdef _git gdm=git-ls-files
alias gdu='git ls-files --others'
compdef _git gdu=git-ls-files
alias gdk='git ls-files --killed'
compdef _git gdk=git-ls-files
alias gdi='git status --porcelain --short --ignored | sed -n "s/^!! //p"'

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

# Pull
alias gf='git fetch'
compdef _git gf=git-fetch
alias gfc='git clone'
compdef _git gfc=git-clone
alias gfm='git pull'
compdef _git gfm=git-pull
alias gfr='git pull --rebase'
compdef _git gfr=git-pull

# Push
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

# Remote Host (h)
alias gh='git remote'
compdef _git gh=git-remote
alias ghl='git remote --verbose'
compdef _git ghl=git-remote
alias gha='git remote add'
compdef _git gha=git-remote
alias ghx='git remote rm'
compdef _git ghx=git-remote
alias ghm='git remote rename'
compdef _git ghm=git-remote
alias ghu='git remote update'
compdef _git ghu=git-remote
alias ghc='git remote prune'
compdef _git ghc=git-remote
alias ghs='git remote show'
compdef _git ghs=git-remote

# Stash (t)
alias gta='git stash apply'
compdef _git gta=git-stash
alias gtc='git stash clear'
compdef _git gtc=git-stash
alias gtx='git stash drop'
compdef _git gtx=git-stash
alias gtl='git stash list'
compdef _git gtl=git-stash
alias gtL='git stash show --patch --stat'
compdef _git gtL=git-stash
alias gtp='git stash pop'
compdef _git gtp=git-stash
alias gts='git stash save'
compdef _git gts=git-stash
alias gtS='git stash save --patch --no-keep-index'
compdef _git gtS=git-stash

# Submodule (u)
alias gu='git submodule'
compdef _git gu=git-submodule
alias gua='git submodule add'
compdef _git gua=git-submodule
alias guf='git submodule foreach'
compdef _git guf=git-submodule
alias gui='git submodule init'
compdef _git gui=git-submodule
alias gul='git submodule status'
compdef _git gul=git-submodule
alias gus='git submodule sync'
compdef _git gus=git-submodule
alias guu='git submodule update'
compdef _git guu=git-submodule
alias guU='git submodule update --init --recursive'
compdef _git guU=git-submdoule

# Git log (pretty).
git_log_format_oneline='--pretty=format:%C(green)%h%C(reset) %s%C(red)%d%C(reset)'
git_log_format_oneline_more='--pretty=format:%C(green)%h%C(reset) %C(blue)%ad%C(reset) %s%C(red)%d%C(reset) [%C(magenta)%an%C(reset)]'
git_log_format_medium='--pretty=format:%C(green)Commit: %H%C(red)%d%C(reset)%n%C(magenta)Author: %an <%ae>%C(reset)%n%C(blue)Date:   %cd%C(reset)%n%+s%n%+b'

alias gl='git log'
compdef _git gl=git-log
alias glo='git log --topo-order ${git_log_format_oneline}'
compdef _git glo=git-log
alias glO='git log --topo-order --date=short ${git_log_format_oneline_more}'
compdef _git glO=git-log
alias glg='git log --graph --topo-order ${git_log_format_medium}'
compdef _git glg=git-log
alias gls='git log --graph --topo-order --stat ${git_log_format_medium}'
compdef _git gls=git-log
alias gld='git log --graph --topo-order --stat --patch --full-diff ${git_log_format_medium}'
compdef _git gld=git-log
alias glc='git shortlog --summary --numbered'
compdef _git glc=git-shortlog


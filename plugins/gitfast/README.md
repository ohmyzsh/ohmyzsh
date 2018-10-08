# Gitfast plugin

This plugin adds completion for Git, using the zsh completion from git.git folks, which is much faster than the official one from zsh. A lot of zsh-specific features are not supported, like descriptions for every argument, but everything the bash completion has, this one does too (as it is using it behind the scenes). Not only is it faster, it should be more robust, and updated regularly to the latest git upstream version..

To use it, add `gitfast` to the plugins array in your zshrc file:

```zsh
plugins=(... gitfast)
```

## Aliases

| Alias                | Command                                                                                                                                |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| g                    | `git`                                                                                                                                  |
| ga                   | `git add`                                                                                                                              |
| gaa                  | `git add --all`                                                                                                                        |
| gapa                 | `git add --patch`                                                                                                                      |
| gau                  | `git add --update`                                                                                                                     |
| gb                   | `git branch`                                                                                                                           |
| gba                  | `git branch -a`                                                                                                                        |
| gbd                  | `git branch -d`                                                                                                                        |
| gbda                 | `git branch --no-color --merged | command grep -vE "^(\*|\s*(master|develop|dev)\s*$)" | command xargs -n 1 git branch -d`             |
| gbl                  | `git blame -b -w`                                                                                                                      |
| gbnm                 | `git branch --no-merged`                                                                                                               |
| gbr                  | `git branch --remote`                                                                                                                  |
| gbs                  | `git bisect`                                                                                                                           |
| gbsb                 | `git bisect bad`                                                                                                                       |
| gbsg                 | `git bisect good`                                                                                                                      |
| gbsr                 | `git bisect reset`                                                                                                                     |
| gbss                 | `git bisect start`                                                                                                                     |
| gc                   | `git commit -v`                                                                                                                        |
| gc!                  | `git commit -v --amend`                                                                                                                |
| gca                  | `git commit -v -a`                                                                                                                     |
| gca!                 | `git commit -v -a --amend`                                                                                                             |
| gcam                 | `git commit -a -m`                                                                                                                     |
| gcan!                | `git commit -v -a --no-edit --amend`                                                                                                   |
| gcans!               | `git commit -v -a -s --no-edit --amend`                                                                                                |
| gcb                  | `git checkout -b`                                                                                                                      |
| gcd                  | `git checkout develop`                                                                                                                 |
| gcf                  | `git config --list`                                                                                                                    |
| gcl                  | `git clone --recursive`                                                                                                                |
| gclean               | `git clean -fd`                                                                                                                        |
| gcm                  | `git checkout master`                                                                                                                  |
| gcmsg                | `git commit -m`                                                                                                                        |
| gcn!                 | `git commit -v --no-edit --amend`                                                                                                      |
| gco                  | `git checkout`                                                                                                                         |
| gcount               | `git shortlog -sn`                                                                                                                     |
| gcp                  | `git cherry-pick`                                                                                                                      |
| gcpa                 | `git cherry-pick --abort`                                                                                                              |
| gcpc                 | `git cherry-pick --continue`                                                                                                           |
| gcs                  | `git commit -S`                                                                                                                        |
| gcsm                 | `git commit -s -m`                                                                                                                     |
| gd                   | `git diff`                                                                                                                             |
| gdca                 | `git diff --cached`                                                                                                                    |
| gdct                 | `` git describe --tags `git rev-list --tags --max-count=1` ``                                                                          |
| gdt                  | `git diff-tree --no-commit-id --name-only -r`                                                                                          |
| gdw                  | `git diff --word-diff`                                                                                                                 |
| gf                   | `git fetch`                                                                                                                            |
| gfa                  | `git fetch --all --prune`                                                                                                              |
| gfo                  | `git fetch origin`                                                                                                                     |
| gg                   | `git gui citool`                                                                                                                       |
| gga                  | `git gui citool --amend`                                                                                                               |
| ggpull               | `git pull origin $(git_current_branch)`                                                                                                |
| ggpur                | `ggu`                                                                                                                                  |
| ggpush               | `git push origin $(git_current_branch)`                                                                                                |
| ggsup                | `git branch --set-upstream-to=origin/$(git_current_branch)`                                                                            |
| ghh                  | `git help`                                                                                                                             |
| gignore              | `git update-index --assume-unchanged`                                                                                                  |
| gignored             | `git ls-files -v | grep "^[[:lower:]]"`                                                                                                |
| git-svn-dcommit-push | `git svn dcommit && git push github master:svntrunk`                                                                                   |
| gk                   | `\gitk --all --branches`                                                                                                               |
| gke                  | `\gitk --all $(git log -g --pretty=%h)`                                                                                                |
| gl                   | `git pull`                                                                                                                             |
| glg                  | `git log --stat`                                                                                                                       |
| glgg                 | `git log --graph`                                                                                                                      |
| glgga                | `git log --graph --decorate --all`                                                                                                     |
| glgm                 | `git log --graph --max-count=10`                                                                                                       |
| glgp                 | `git log --stat -p`                                                                                                                    |
| glo                  | `git log --oneline --decorate`                                                                                                         |
| glog                 | `git log --oneline --decorate --graph`                                                                                                 |
| gloga                | `git log --oneline --decorate --graph --all`                                                                                           |
| glol                 | `git log --graph --pretty='\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --abbrev-commit`       |
| glola                | `git log --graph --pretty='\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --abbrev-commit --all` |
| glp                  | `_git_log_prettily`                                                                                                                    |
| glum                 | `git pull upstream master`                                                                                                             |
| gm                   | `git merge`                                                                                                                            |
| gmom                 | `git merge origin/master`                                                                                                              |
| gmt                  | `git mergetool --no-prompt`                                                                                                            |
| gmtvim               | `git mergetool --no-prompt --tool=vimdiff`                                                                                             |
| gmum                 | `git merge upstream/master`                                                                                                            |
| gp                   | `git push`                                                                                                                             |
| gpd                  | `git push --dry-run`                                                                                                                   |
| gpoat                | `git push origin --all && git push origin --tags`                                                                                      |
| gpristine            | `git reset --hard && git clean -dfx`                                                                                                   |
| gpsup                | `git push --set-upstream origin $(git_current_branch)`                                                                                 |
| gpu                  | `git push upstream`                                                                                                                    |
| gpv                  | `git push -v`                                                                                                                          |
| gr                   | `git remote`                                                                                                                           |
| gra                  | `git remote add`                                                                                                                       |
| grb                  | `git rebase`                                                                                                                           |
| grba                 | `git rebase --abort`                                                                                                                   |
| grbc                 | `git rebase --continue`                                                                                                                |
| grbi                 | `git rebase -i`                                                                                                                        |
| grbm                 | `git rebase master`                                                                                                                    |
| grbs                 | `git rebase --skip`                                                                                                                    |
| grh                  | `git reset HEAD`                                                                                                                       |
| grhh                 | `git reset HEAD --hard`                                                                                                                |
| grmv                 | `git remote rename`                                                                                                                    |
| grrm                 | `git remote remove`                                                                                                                    |
| grset                | `git remote set-url`                                                                                                                   |
| grt                  | `cd $(git rev-parse --show-toplevel || echo ".")`                                                                                      |
| gru                  | `git reset --`                                                                                                                         |
| grup                 | `git remote update`                                                                                                                    |
| grv                  | `git remote -v`                                                                                                                        |
| gsb                  | `git status -sb`                                                                                                                       |
| gsd                  | `git svn dcommit`                                                                                                                      |
| gsi                  | `git submodule init`                                                                                                                   |
| gsps                 | `git show --pretty=short --show-signature`                                                                                             |
| gsr                  | `git svn rebase`                                                                                                                       |
| gss                  | `git status -s`                                                                                                                        |
| gst                  | `git status`                                                                                                                           |
| gsta                 | `git stash save`                                                                                                                       |
| gstaa                | `git stash apply`                                                                                                                      |
| gstc                 | `git stash clear`                                                                                                                      |
| gstd                 | `git stash drop`                                                                                                                       |
| gstl                 | `git stash list`                                                                                                                       |
| gstp                 | `git stash pop`                                                                                                                        |
| gsts                 | `git stash show --text`                                                                                                                |
| gsu                  | `git submodule update`                                                                                                                 |
| gts                  | `git tag -s`                                                                                                                           |
| gtv                  | `git tag | sort -V`                                                                                                                    |
| gunignore            | `git update-index --no-assume-unchanged`                                                                                               |
| gunwip               | `git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1`                                                                          |
| gup                  | `git pull --rebase`                                                                                                                    |
| gupv                 | `git pull --rebase -v`                                                                                                                 |
| gwch                 | `git whatchanged -p --abbrev-commit --pretty=medium`                                                                                   |
| gwip                 | `git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify -m "--wip-- [skip ci]"`                             |

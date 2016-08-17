# Git flow plugin installation

```bash
git clone https://github.com/robbyrussell/oh-my-zsh.git 

cp oh-my-zsh/plugins/git-flow/git-flow.plugin.zsh ~/.git-flow-completion.zsh

vim ~/.zshrc

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(git git-flow)
      
source ~/.git-flow-completion.zsh
```
## Your new git-flow alias 

```bash
alias gfl='git flow'
alias gfli='git flow init'
alias gcd='git checkout develop'
alias gch='git checkout hotfix'
alias gcr='git checkout release'
alias gflf='git flow feature'
alias gflh='git flow hotfix'
alias gflr='git flow release'
alias gflfs='git flow feature start'
alias gflhs='git flow hotfix start'
alias gflrs='git flow release start'
alias gflff='git flow feature finish'
alias gflhf='git flow hotfix finish'
alias gflrf='git flow release finish'
``` 

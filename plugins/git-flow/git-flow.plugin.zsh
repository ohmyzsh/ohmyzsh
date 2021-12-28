# Aliases
alias gfl='git flow'
alias gfli='git flow init'
alias gcd='git checkout $(git config gitflow.branch.develop)'
alias gch='git checkout $(git config gitflow.prefix.hotfix)'
alias gcr='git checkout $(git config gitflow.prefix.release)'
alias gflf='git flow feature'
alias gflh='git flow hotfix'
alias gflr='git flow release'
alias gflfs='git flow feature start'
alias gflhs='git flow hotfix start'
alias gflrs='git flow release start'
alias gflff='git flow feature finish'
alias gflfp='git flow feature publish'
alias gflhf='git flow hotfix finish'
alias gflrf='git flow release finish'
alias gflhp='git flow hotfix publish'
alias gflrp='git flow release publish'
alias gflfpll='git flow feature pull'
alias gflffc='git flow feature finish $(echo $(current_branch) | cut -c 9-)'
alias gflfpc='git flow feature publish $(echo $(current_branch) | cut -c 9-)'
alias gflrfc='git flow release finish $(echo $(current_branch) | cut -c 9-)'
alias gflrpc='git flow release publish $(echo $(current_branch) | cut -c 9-)'

# Source completion script
# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"
source "${0:A:h}/_git-flow"

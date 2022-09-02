# Aliases
alias gcd='git checkout $(git config gitflow.branch.develop)'
alias gch='git checkout $(git config gitflow.prefix.hotfix)'
alias gcr='git checkout $(git config gitflow.prefix.release)'
alias gfl='git flow'
alias gflf='git flow feature'
alias gflff='git flow feature finish'
alias gflffc='git flow feature finish ${$(git_current_branch)#feature/}'
alias gflfp='git flow feature publish'
alias gflfpc='git flow feature publish ${$(git_current_branch)#feature/}'
alias gflfpll='git flow feature pull'
alias gflfs='git flow feature start'
alias gflh='git flow hotfix'
alias gflhf='git flow hotfix finish'
alias gflhfc='git flow hotfix finish ${$(git_current_branch)#hotfix/}'
alias gflhp='git flow hotfix publish'
alias gflhpc='git flow hotfix publish ${$(git_current_branch)#hotfix/}'
alias gflhs='git flow hotfix start'
alias gfli='git flow init'
alias gflr='git flow release'
alias gflrf='git flow release finish'
alias gflrfc='git flow release finish ${$(git_current_branch)#release/}'
alias gflrp='git flow release publish'
alias gflrpc='git flow release publish ${$(git_current_branch)#release/}'
alias gflrs='git flow release start'

# Source completion script
# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"
source "${0:A:h}/_git-flow"

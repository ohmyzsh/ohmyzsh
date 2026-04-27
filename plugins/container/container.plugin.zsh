# Container plugin for Apple's container tool
# https://github.com/apple/container

# Aliases for common container commands
alias cb='container build'
alias ccr='container create'
alias cst='container start'
alias csp='container stop'
alias ck='container kill'
alias cdl='container delete'
alias crm='container delete'
alias cls='container list'
alias clsa='container list -a'
alias cex='container exec'
alias cexit='container exec -it'
alias clo='container logs'
alias clof='container logs -f'
alias cin='container inspect'
alias cr='container run'
alias crit='container run -it'
alias crd='container run -d'

# Image management aliases
alias cils='container image list'
alias cipl='container image pull'
alias cips='container image push'
alias cisv='container image save'
alias cild='container image load'
alias citg='container image tag'
alias cirm='container image delete'
alias cipr='container image prune'
alias ciin='container image inspect'

# Builder management aliases
alias cbst='container builder start'
alias cbsp='container builder stop'
alias cbss='container builder status'
alias cbrm='container builder delete'

# Network management aliases (macOS 26+)
alias cncr='container network create'
alias cnrm='container network delete'
alias cnls='container network list'
alias cnin='container network inspect'

# Volume management aliases
alias cvcr='container volume create'
alias cvrm='container volume delete'
alias cvls='container volume list'
alias cvin='container volume inspect'

# Registry management aliases
alias crli='container registry login'
alias crlo='container registry logout'

# System management aliases
alias csst='container system start'
alias cssp='container system stop'
alias csss='container system status'
alias cslo='container system logs'
alias cske='container system kernel set'
alias cspl='container system property list'
alias cspg='container system property get'
alias csps='container system property set'
alias cspc='container system property clear'

# Check if container command is available
if (( ! $+commands[container] )); then
  return
fi

# Standardized $0 handling
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `container`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_container" ]]; then
  typeset -g -A _comps
  autoload -Uz _container
  _comps[container]=_container
fi

{
  # Copy the custom completion file to cache
  command cp "${0:h}/completions/_container" "$ZSH_CACHE_DIR/completions/_container"
} &|
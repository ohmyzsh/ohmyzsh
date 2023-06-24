alias dbl='docker build'
alias dcin='docker container inspect'
alias dcls='docker container ls'
alias dclsa='docker container ls -a'
alias dib='docker image build'
alias dii='docker image inspect'
alias dils='docker image ls'
alias dipu='docker image push'
alias dirm='docker image rm'
alias dit='docker image tag'
alias dlo='docker container logs'
alias dnc='docker network create'
alias dncn='docker network connect'
alias dndcn='docker network disconnect'
alias dni='docker network inspect'
alias dnls='docker network ls'
alias dnrm='docker network rm'
alias dpo='docker container port'
alias dpu='docker pull'
alias dr='docker container run'
alias drit='docker container run -it'
alias drm='docker container rm'
alias 'drm!'='docker container rm -f'
alias dst='docker container start'
alias drs='docker container restart'
alias dsta='docker stop $(docker ps -q)'
alias dstp='docker container stop'
alias dtop='docker top'
alias dvi='docker volume inspect'
alias dvls='docker volume ls'
alias dvprune='docker volume prune'
alias dxc='docker container exec'
alias dxcit='docker container exec -it'

if (( ! $+commands[docker] )); then
  return
fi

{
  # `docker completion` is only available from 23.0.0 on
  local _docker_version=$(command docker version --format '{{.Client.Version}}' 2>/dev/null)
  if is-at-least 23.0.0 $_docker_version; then
    # If the completion file doesn't exist yet, we need to autoload it and
    # bind it to `docker`. Otherwise, compinit will have already done that.
    if [[ ! -f "$ZSH_CACHE_DIR/completions/_docker" ]]; then
      typeset -g -A _comps
      autoload -Uz _docker
      _comps[docker]=_docker
    fi
    command docker completion zsh >| "$ZSH_CACHE_DIR/completions/_docker"
  fi
} &|

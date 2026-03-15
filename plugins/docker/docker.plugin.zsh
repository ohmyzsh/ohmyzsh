alias dbl='docker build'
alias dcin='docker container inspect'
alias dcls='docker container ls'
alias dclsa='docker container ls -a'
alias dib='docker image build'
alias dii='docker image inspect'
alias dils='docker image ls'
alias dipu='docker image push'
alias dipru='docker image prune -a'
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
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dpu='docker pull'
alias dr='docker container run'
alias drit='docker container run -it'
alias drm='docker container rm'
alias 'drm!'='docker container rm -f'
alias dst='docker container start'
alias drs='docker container restart'
alias dsta='docker stop $(docker ps -q)'
alias dstp='docker container stop'
alias dsts='docker stats'
alias dtop='docker top'
alias dvi='docker volume inspect'
alias dvls='docker volume ls'
alias dvprune='docker volume prune'
alias dxc='docker container exec'
alias dxcit='docker container exec -it'

function _dxgcit() {
  if [ $# -lt 2 ]; then
    echo "Usage: $0 <grep-pattern> <command...>" >&2
    return 1
  fi

  local pattern=$1
  shift 1

  local -a candidates
  candidates=(
    ${(f)"$(docker ps --format "{{.ID}}:{{.Names}}:{{.Image}}" | grep -- "$pattern")"}
  )
  if [ ${#candidates[@]} -eq 0 ]; then
    printf "No container/image matches name pattern: '%s'!\n" "$pattern" >&2
    return 1
  fi
  if [ ${#candidates[@]} -ne 1 ]; then
    printf "Ambiguous container/image name pattern: '%s' results in '%d' candidates!\n" \
      "$pattern" "${#candidates[@]}" >&2
    for candidate in ${candidates[@]}; do
      parts=(${(@s/:/)candidate})
      printf "  %s (%s) (image: %s)\n" "${parts[1]}" "${parts[2]}" "${parts[3]}" >&2
    done
    return 1
  fi

  local -a candidate
  candidate=(${(@s/:/)${candidates[1]}})
  local id="${candidate[1]}"
  docker container exec -it "$id" "$@"
}
alias dxgcit='_dxgcit'

if (( ! $+commands[docker] )); then
  return
fi

# Standardized $0 handling
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `docker`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_docker" ]]; then
  typeset -g -A _comps
  autoload -Uz _docker
  _comps[docker]=_docker
fi

{
  # `docker completion` is only available from 23.0.0 on
  # docker version returns `Docker version 24.0.2, build cb74dfcd85`
  # with `s:,:` remove the comma after the version, and select third word of it
  if zstyle -t ':omz:plugins:docker' legacy-completion || \
    ! is-at-least 23.0.0 ${${(s:,:z)"$(command docker --version)"}[3]}; then
        command cp "${0:h}/completions/_docker" "$ZSH_CACHE_DIR/completions/_docker"
      else
        command docker completion zsh | tee "$ZSH_CACHE_DIR/completions/_docker" > /dev/null
  fi
} &|

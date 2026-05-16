if (( ! $+commands[podman] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `podman`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_podman" ]]; then
  typeset -g -A _comps
  autoload -Uz _podman
  _comps[podman]=_podman
fi

podman completion zsh 2> /dev/null >| "$ZSH_CACHE_DIR/completions/_podman" &|

alias pbl='podman build'
alias pcin='podman container inspect'
alias pcls='podman container ls'
alias pclsa='podman container ls --all'
alias pib='podman image build'
alias pii='podman image inspect'
alias pils='podman image ls'
alias pipu='podman image push'
alias pirm='podman image rm'
alias pit='podman image tag'
alias plo='podman container logs'
alias pnc='podman network create'
alias pncn='podman network connect'
alias pndcn='podman network disconnect'
alias pni='podman network inspect'
alias pnls='podman network ls'
alias pnrm='podman network rm'
alias ppo='podman container port'
alias ppu='podman pull'
alias pr='podman container run'
alias prit='podman container run --interactive --tty'
alias prm='podman container rm'
alias 'prm!'='podman container rm --force'
alias pst='podman container start'
alias prs='podman container restart'
alias psta='podman stop $(podman ps --quiet)'
alias pstp='podman container stop'
alias ptop='podman top'
alias pvi='podman volume inspect'
alias pvls='podman volume ls'
alias pvprune='podman volume prune'
alias pxc='podman container exec'
alias pxcit='podman container exec --interactive --tty'

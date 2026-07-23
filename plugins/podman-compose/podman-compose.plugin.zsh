# Aliases for podman-compose
# Inspired by the docker-compose plugin

# Check if podman-compose is installed
if (( ! $+commands[podman-compose] )); then
  # Fallback to 'podman compose' if available
  if podman compose version >/dev/null 2>&1; then
    pccmd='podman compose'
  else
    return
  fi
else
  pccmd='podman-compose'
fi

alias pco="$pccmd"
alias pcb="$pccmd build"
alias pce="$pccmd exec"
alias pcps="$pccmd ps"
alias pcrestart="$pccmd restart"
alias pcrm="$pccmd rm"
alias pcr="$pccmd run"
alias pcstop="$pccmd stop"
alias pcup="$pccmd up"
alias pcupb="$pccmd up --build"
alias pcupd="$pccmd up -d"
alias pcupdb="$pccmd up -d --build"
alias pcdn="$pccmd down"
alias pcl="$pccmd logs"
alias pclf="$pccmd logs -f"
alias pclF="$pccmd logs -f --tail 0"
alias pcpull="$pccmd pull"
alias pcstart="$pccmd start"
alias pck="$pccmd kill"
alias pcpause="$pccmd pause"
alias pcunpause="$pccmd unpause"

unset pccmd

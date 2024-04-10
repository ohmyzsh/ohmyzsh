# support Compose v2 as podman CLI plugin
(( ${+commands[podman-compose]} )) && pccmd='podman-compose' || pccmd='podman compose'

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
alias pcpull="$pccmd pull"
alias pcstart="$pccmd start"
alias pcpause="$pccmd pause"
alias pck="$pccmd kill"

unset pccmd

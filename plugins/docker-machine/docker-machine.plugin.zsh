# Authors:
# https://github.com/HaraldNordgren
#
# Docker-machine related zsh aliases

alias dm='docker-machine'

alias dmc='docker-machine create'
alias dmls='docker-machine ls'
alias dmrestart='docker-machine restart'
alias dmrm='docker-machine rm'
alias dmstart='docker-machine start'
alias dmstop='docker-machine stop'
alias dmst='docker-machine status'

function dmenv {
    eval "$(docker-machine env $1)"
}


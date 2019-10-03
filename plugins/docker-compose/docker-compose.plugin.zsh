# Authors:
# https://github.com/tristola
#
# Docker-compose related zsh aliases

# Aliases ###################################################################

# Use dco as alias for docker-compose, since dc on *nix is 'dc - an arbitrary precision calculator'
# https://www.gnu.org/software/bc/manual/dc-1.05/html_mono/dc.html

_docker-compose () {
    compadd $(docker-compose ps --services)
}

compdef _docker-compose dcb
compdef _docker-compose dce
compdef _docker-compose dcps
compdef _docker-compose dcrestart
compdef _docker-compose dcrm
compdef _docker-compose dcr
compdef _docker-compose dcstop
compdef _docker-compose dcup
compdef _docker-compose dcupd
compdef _docker-compose dcl
compdef _docker-compose dclf
compdef _docker-compose dcpull
compdef _docker-compose dcstart

alias dco='docker-compose'

alias dcb='docker-compose build'
alias dce='docker-compose exec'
alias dcps='docker-compose ps'
alias dcrestart='docker-compose restart'
alias dcrm='docker-compose rm'
alias dcr='docker-compose run'
alias dcstop='docker-compose stop'
alias dcup='docker-compose up'
alias dcupd='docker-compose up -d'
alias dcdn='docker-compose down'
alias dcl='docker-compose logs'
alias dclf='docker-compose logs -f'
alias dcpull='docker-compose pull'
alias dcstart='docker-compose start'

# Authors:
# https://github.com/tristola
#
# Docker-compose related zsh aliases

# Aliases ###################################################################

# Use dco as alias for docker-compose, since dc on *nix is 'dc - an arbitrary precision calculator'
# https://www.gnu.org/software/bc/manual/dc-1.05/html_mono/dc.html

alias dco='docker-compose -f ${DCO_FILE:-docker-compose.yml}'

alias dcb='docker-compose -f ${DCO_FILE:-docker-compose.yml} build'
alias dce='docker-compose -f ${DCO_FILE:-docker-compose.yml} exec'
alias dcps='docker-compose -f ${DCO_FILE:-docker-compose.yml} ps'
alias dcrestart='docker-compose -f ${DCO_FILE:-docker-compose.yml} restart'
alias dcrm='docker-compose -f ${DCO_FILE:-docker-compose.yml} rm'
alias dcr='docker-compose -f ${DCO_FILE:-docker-compose.yml} run'
alias dcstop='docker-compose -f ${DCO_FILE:-docker-compose.yml} stop'
alias dcup='docker-compose -f ${DCO_FILE:-docker-compose.yml} up'
alias dcupd='docker-compose -f ${DCO_FILE:-docker-compose.yml} up -d'
alias dcdn='docker-compose -f ${DCO_FILE:-docker-compose.yml} down'
alias dcl='docker-compose -f ${DCO_FILE:-docker-compose.yml} logs'
alias dclf='docker-compose -f ${DCO_FILE:-docker-compose.yml} logs -f'
alias dcpull='docker-compose -f ${DCO_FILE:-docker-compose.yml} pull'
alias dcstart='docker-compose -f ${DCO_FILE:-docker-compose.yml} start'

# docker-enter autocompletion zsh
# Author: Antonio Murdaca <me@runcom.ninja>

local curcontext=$curcontext state line
declare -A opt_args

_docker_running_containers() {
  compadd "$@" $(docker ps | perl -ne '@cols = split /\s{2,}/, $_; printf "%20s\n", $cols[6]' | tail -n +3 | awk '$1' | xargs)
}

_docker_enter () {
  local curcontext="$curcontext" state line
  typeset -A opt_args

  _arguments '1: :->command'

  case $state in
    command) _docker_running_containers ;;
    *) ;;
  esac

  return 0
}

compdef _docker_enter docker-enter

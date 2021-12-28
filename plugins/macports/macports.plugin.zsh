alias pc="sudo port clean --all installed"
alias pi="sudo port install"
alias pli="port livecheck installed"
alias plm="port-livecheck-maintainer"
alias psu="sudo port selfupdate"
alias puni="sudo port uninstall inactive"
alias puo="sudo port upgrade outdated"
alias pup="sudo port selfupdate && sudo port upgrade outdated"

port-livecheck-maintainer() {
  (( ${+commands[port]} == 0 )) || {
    print -- "port: not found" >&2
    return 1
  }

  local -a help_flag
  zparseopts -D -E h=help_flag -help=help_flag

  (( ${#help_flag} )) && {
    cat << EOF >&2
Usage:
  port-livecheck-maintainer
  port-livecheck-maintainer (maintainer)+
  port-livecheck-maintainer -h|--help

Check

Options:
  maintainer  maintainer id
  -h          print this help message and exit
EOF
    return 1
  }

  if (( $# == 0 )); then
    local default=${MACPORTS_MAINTAINER:-${USER}}
    port livecheck maintainer:${default}
    return $?
  fi

  for i in $@; do
    port livecheck maintainer:${i}
  done
}

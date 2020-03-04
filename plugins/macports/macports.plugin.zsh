alias pc="sudo port clean --all installed"
alias pi="sudo port install"
alias psu="sudo port selfupdate"
alias puni="sudo port uninstall inactive"
alias puo="sudo port upgrade outdated"
alias pup="psu && puo"
alias pli="port livecheck installed"
alias plm="port-livecheck-maintainer"

_omz_macports_check_port_or_fail()
{
  command -v port > /dev/null 2>&1 ||
    {
      return 1
    }
}

_omz_macports_port_livecheck_maintainer_usage() {
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
}

port-livecheck-maintainer()
{
  (( _omz_macports_check_port_or_fail == 0)) ||
    {
      print -- "port: not found" >&2
      return 1
    }

  local -a help_flag

  zparseopts -D -E \
             h=help_flag    -help=help_flag

  (( ${#help_flag} )) &&
    {
      _omz_macports_port_livecheck_maintainer_usage
      return 1
    }

  local default_maintainer=${MACPORTS_MAINTAINER:-${USER}}

  if (( $# > 0 )); then
    for i in $*; do
      port livecheck maintainer:${i}
    done
  else
    port livecheck maintainer:${default_maintainer}
  fi
}

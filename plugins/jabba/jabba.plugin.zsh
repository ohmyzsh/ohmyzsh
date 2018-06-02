# zsh integration and autocompletions for https://github.com/shyiko/jabba"

jabba() {
  local fd3=$(mktemp /tmp/jabba-fd3.XXXXXX)
  (JABBA_SHELL_INTEGRATION=ON /usr/bin/jabba "$@" 3>| ${fd3})
  local exit_code=$?
  eval $(cat ${fd3})
  rm -f ${fd3}
  return ${exit_code}
}

_jabba_get_command_list () {
  $_comp_command1 2>/dev/null | sed "1,/Available Commands/d" | awk '/^[ \t]*[a-z]+/ { print $1 }'
}

_jabba_get_installed_list () {
  $_comp_command1 ls
}

_jabba_get_available_list () {
  $_comp_command1 ls-remote
}

_jabba () {
  local curcontext="$curcontext" state line
  typeset -A opt_args

  _arguments \
    '1: :->command'\
    ':subcommand:->subcommand'

  case $state in
    command)
      compadd $(_jabba_get_command_list)
      ;;
    subcommand)
      case $words[2] in
        use)
          compadd $(_jabba_get_installed_list)
          ;;
        install)
          compadd $(_jabba_get_available_list)
          ;;
        uninstall)
          compadd $(_jabba_get_installed_list)
          ;;
      esac
      ;;
  esac
}

compdef _jabba jabba

# switch to default upon terminal startup
if [ ! -z "$(jabba alias default)" ]; then
  jabba use default
fi

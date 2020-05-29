_lxc_get_command_list () {
    $_comp_command1 | sed "1,/Available Commands/d" | awk '/^[ \t]*[a-z]+/ { print $1 }'
}

_lxc_get_subcommand_list () {
    $_comp_command1 ${words[2]} | sed "1,/Available Commands/d" | awk '/^[ \t]*[a-z]+/ { print $1 }'
}

_lxc () {
  local curcontext="$curcontext" state line
  typeset -A opt_args
  _arguments \
    '1: :->command'\
    '*: :->args'

  case $state in
    command)
      compadd $(_lxc_get_command_list)
      ;;
    *)
        compadd $(_lxc_get_subcommand_list)
      ;;
  esac
}

compdef _lxc lxc

_lxc_get_commands () {
            sed '/Available Commands/,/Flags/!d' | awk '/^[ \t]/{ print $1 }'
}
_lxc_get_flags () {
            sed '/^Flags/,/^Global Flags/!d'     | awk '/^[ \t]*--/ { print $1 }/^[ \t]*-.,/ { print $1 $2 }' | sed 's/,/ /'
}
_lxc_get_global_flags () {
            sed '/^Global Flags/,$!d'     | awk '/^[ \t]*--/ { print $1 }/^[ \t]*-.,/ { print $1 $2 }' | sed 's/,/ /'
}

_lxc_get_command_list () {
    
    $_comp_command1 -h              | _lxc_get_commands
    $_comp_command1 -h              | _lxc_get_global_flags
}


_lxc_get_subcommand_list () {

    $_comp_command1 ${words[2]} -h | _lxc_get_flags
    $_comp_command1 ${words[2]} -h | _lxc_get_commands

    case ${words[2]} in
            alias|cluster|image|operation|profile|project|remote|storage|warning)
                    
                    ${words[1]} ${words[2]} list -f csv | cut -d, -f1
                    ;;
            list)
                    
                    ${words[1]} ${words[2]} -cn -fcsv ${words[3]}
                    ;;
            exec)
                    
                    echo "--"
                    ${words[1]} list -cn -fcsv ${words[3]}
                    ;;
            network)
                    
                    ${words[1]} ${words[2]} list -fcsv  | cut -d, -f1
                    ;;
            *)
                    
                    ${words[1]} list -cn -fcsv  ${words[3]}
                    ;;
     esac

}

_lxc_get_element_list () {
    case ${words[2]} in
            exec)
                    
                    echo "--"
                    $_comp_command1 ${words[2]} -h | _lxc_get_flags
            ;;
            *)
                
                $_comp_command1 ${words[2]} ${words[3]} -h | _lxc_get_flags
                $_comp_command1 ${words[2]} ${words[3]} -h | _lxc_get_commands
            ;;
    esac
}

_lxc () {
  local curcontext="$curcontext" state line
  typeset -A opt_args
  _arguments \
    '1: :->command'\
    '2: :->subcommand'\
    '*: :->args'

  case $state in
    command)
      compadd $(_lxc_get_command_list)
      ;;
    subcommand)
      compadd $(_lxc_get_subcommand_list)
      ;;
    *)
        compadd $(_lxc_get_element_list)
      ;;
  esac
}

compdef _lxc lxc lxd

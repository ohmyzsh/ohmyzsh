_multipass_get_command_list () {
    $_comp_command1 | sed "1,/Available commands/d" | awk '/^[ \t]*[a-z]+/ { print $1 }'
}
 # $_comp_command1 | sed "1,/Available commands/d" | awk '/^[ \t]*[a-z]+/ { print $1 }'
 # $_comp_command1 list | tail -1 | awk '/^[ \t]*[a-z]+/ { print $1 }'

_multipass_get_subcommand_list () {
  local arg_name=$($_comp_command1 help ${words[2]} | sed "1,/Arguments/d" | awk '/^[ \t]*[a-z]+/ { print $1 }' | head -1)
  case $arg_name in 
    name)
      $_comp_command1 list | tail -n +1 | awk '/^[ \t]*[a-z]+/ { print $1 }'
        ;;
    command)
      $_comp_command1 | sed "1,/Available commands/d" | awk '/^[ \t]*[a-z]+/ { print $1 }'
      ;;
  esac
}
_multipass () {
   typeset -A opt_args
   _arguments \
     '1: :->command'\
     '*: :->args'
 
  case $state in
    command)
      compadd $(_multipass_get_command_list)
      ;;
    *)
      compadd $(_multipass_get_subcommand_list)
      ;;
  esac
}

compdef _multipass multipass


alias mp="multipass"
alias mpla="multipass launch"
alias mpl="multipass list"
alias mpsp="multipass stop"
alias mpst="multipass start"
alias mps="multipass shell"
alias mpln="multipass launch --network en0 --network name=bridge0,mode=manual"

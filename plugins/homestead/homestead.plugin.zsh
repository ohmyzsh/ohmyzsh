# Homestead basic command completion
_homestead_get_command_list () {
  homestead --no-ansi | sed "1,/Available commands/d" | awk '/^ +[a-z]+/ { print $1 }'
}

_homestead () {
  compadd `_homestead_get_command_list`
}

compdef _homestead homestead

# Homestead basic command completion
_homestead_get_command_list () {
  homestead --no-ansi | sed -E "1,/(Available|Common) commands/d" | awk '/^ +[a-z]+/ { print $1 }'
}

_homestead () {
  compadd `_homestead_get_command_list`
}

compdef _homestead homestead

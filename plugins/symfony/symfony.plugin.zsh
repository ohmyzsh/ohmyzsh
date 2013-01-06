# symfony basic command completion

_symfony_get_command_list () {
    ./symfony | sed "1,/Available tasks/d" | awk 'BEGIN { cat=null; } /^[A-Za-z]+$/ { cat = $1; } /^  :[a-z]+/ { print cat $1; }'
}

_symfony () {
  if [ -f symfony ]; then
    compadd `_symfony_get_command_list`
  fi
}

compdef _symfony symfony

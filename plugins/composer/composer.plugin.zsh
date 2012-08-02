# Composer basic command completion

_composer_get_command_list () {
	php composer.phar --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_composer () {
  if [ -f composer.phar ]; then
    compadd `_composer_get_command_list`
  fi
}

compdef _composer composer.phar

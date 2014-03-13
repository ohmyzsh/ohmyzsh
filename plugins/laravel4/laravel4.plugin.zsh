# Laravel4 basic command completion

_laravel4_get_command_list () {
	php artisan list --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_laravel4 () {
  if [ -f artisan ]; then
    compadd `_laravel4_get_command_list`
  fi
}

compdef _laravel4 artisan

#Alias
alias artisan='php artisan'


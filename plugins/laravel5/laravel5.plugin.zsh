<<<<<<< HEAD
# Laravel5 basic command completion
_laravel5_get_command_list () {
	php artisan --no-ansi | sed "1,/Available commands/d" | awk '/^ +[a-z]+/ { print $1 }'
}

_laravel5 () {
  if [ -f artisan ]; then
    compadd `_laravel5_get_command_list`
=======
# Alias
alias la5='php artisan'
alias la5cache='php artisan cache:clear'
alias la5routes='php artisan route:list'
alias la5vendor='php artisan vendor:publish'

# Laravel5 basic command completion
_laravel5_get_command_list () {
  php artisan --raw --no-ansi list | sed "s/[[:space:]].*//g"
}

_laravel5 () {
  if [[ -f artisan ]]; then
    compadd $(_laravel5_get_command_list)
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  fi
}

compdef _laravel5 artisan
compdef _laravel5 la5
<<<<<<< HEAD

#Alias
alias la5='php artisan'

alias la5cache='php artisan cache:clear'
alias la5routes='php artisan route:list'
alias la5vendor='php artisan vendor:publish'
=======
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

# Laravel Art basic command completion
_laravel_art_get_command_list () {
	php artisan --no-ansi | sed "1,/Available commands/d" | awk '/^ +[a-z]+/ { print $1 }'
}

_laravel_art () {
  if [ -f artisan ]; then
    compadd `_laravel_art_get_command_list`
  fi
}

# compdef _laravel_art artisan
compdef _laravel_art art

#Alias
alias art='php artisan'


alias art="php artisan" 
alias arts="php artisan serv" 
alias artm="php artisan migrate" 

# Migration And Seeders
alias artmf="php artisan migrate:fresh" 
alias artmfseed="php artisan migrate:fresh --seed" 
alias artmodseed="php artisan module:seed" 
alias artdbseed="php artisan db:seed"

# Optimize And Cache
alias arto="php artisan optimize" 
alias artcc='php artisan config:cache'
alias artcache='php artisan cache:clear'
alias artclear='php artisan config:clear'

# Route
alias artr='php artisan route:list'
alias artrcache='php artisan route:cache'
alias artrclear='php artisan route:clear'
  
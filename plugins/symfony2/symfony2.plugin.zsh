# Symfony2 basic command completion

_symfony2_get_command_list () {
	php app/console --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_symfony2 () {
  if [ -f app/console ]; then
    compadd `_symfony2_get_command_list`
  fi
}

compdef _symfony2 app/console
compdef _symfony2 sf

#Alias
alias sf='php app/console'
alias sfcl='php app/console cache:clear'
alias sfroute='php app/console router:debug'
alias sfcontainer='php app/console container:debug'
alias sfgb='php app/console generate:bundle'
alias sfddd='php app/console doctrine:database:drop'
alias sfddc='php app/console doctrine:database:create'
alias sfdsd='php app/console doctrine:schema:drop'
alias sfdsc='php app/console doctrine:schema:create'
alias sfdsu='php app/console doctrine:schema:update'

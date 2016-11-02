# Symfony2 basic command completion

_symfony_console () {
  echo "php $(find . -maxdepth 2 -mindepth 1 -name 'console' -type f | head -n 1)"
}

_symfony2_get_command_list () {
   `_symfony_console` --no-ansi | sed "1,/Available commands/d" | awk '/^  ?[^ ]+ / { print $1 }'
}

_symfony2 () {
   compadd `_symfony2_get_command_list`
}

compdef _symfony2 '`_symfony_console`'
compdef _symfony2 'app/console'
compdef _symfony2 'bin/console'
compdef _symfony2 sf

#Alias
alias sf='`_symfony_console`'
alias sfcl='sf cache:clear'
alias sfai='sf assets:install'
alias sfsr='sf server:run -vvv'
alias sfsc='sf security:check'
alias sfcw='sf cache:warmup'
alias sfroute='sf debug:router'
alias sfcontainer='sf debug:container'
alias sfgb='sf generate:bundle'
alias sfgc='sf generate:controller'
alias sfdev='sf --env=dev'
alias sfprod='sf --env=prod'
#Doctrine alias
alias sfge='sf doctrine:generate:entity'
alias sfdc='sf doctrine:database:create'
alias sfdd='sf doctrine:database:drop --force'
alias sfsc='sf doctrine:schema:create'
alias sfsu='sf doctrine:schema:update'
#Need DoctrineFixturesBundle
alias sffixtures='sf doctrine:fixtures:load'

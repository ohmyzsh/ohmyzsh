# Symfony2 basic command completion

_symfony2_get_command_list () {
	php $(find . -maxdepth 2 -mindepth 1 -name 'console')  --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_symfony2 () {
  if [ -f $(find . -maxdepth 2 -mindepth 1 -name 'console')  ]; then
    compadd `_symfony2_get_command_list`
  fi
}

compdef _symfony2 $(find . -maxdepth 2 -mindepth 1 -name 'console')
compdef _symfony2 sf

#Alias
alias sf='php $(find . -maxdepth 2 -mindepth 1 -name 'console') '
alias sfcl='php $(find . -maxdepth 2 -mindepth 1 -name 'console')  cache:clear'
alias sfcw='php $(find . -maxdepth 2 -mindepth 1 -name 'console')  cache:warmup'
alias sfroute='php $(find . -maxdepth 2 -mindepth 1 -name 'console')  router:debug'
alias sfcontainer='php $(find . -maxdepth 2 -mindepth 1 -name 'console') container:debug'
alias sfgb='php $(find . -maxdepth 2 -mindepth 1 -name 'console')  generate:bundle'


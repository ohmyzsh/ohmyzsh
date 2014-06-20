# eZ Publish5 5 basic command completion

_ezpublish5_get_command_list () {
	php ezpublish/console --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_ezpublish5 () {
  if [ -f ezpublish/console ]; then
    compadd `_ezpublish5_get_command_list`
  fi
}

compdef _ezpublish5 ezpublish/console
compdef _ezpublish5 ez

#Alias
alias ez='php ezpublish/console'
# there is some ezpublish issue with db params when using warmup, so just strip it
alias ezcl='php ezpublish/console cache:clear --no-warmup'
alias ezroute='php ezpublish/console router:debug'
alias ezgb='php ezpublish/console generate:bundle'


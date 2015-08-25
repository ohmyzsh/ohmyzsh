# CakePHP 3 basic command completion
_cakephp3_get_command_list () {
	cakephp3commands=($(bin/cake completion commands));printf "%s\n" "${cakephp3commands[@]}"
}

_cakephp3 () {
  if [ -f bin/cake ]; then
    compadd `_cakephp3_get_command_list`
  fi
}

compdef _cakephp3 bin/cake
compdef _cakephp3 cake

#Alias
alias c3='bin/cake'

alias c3cache='bin/cake orm_cache clear'
alias c3migrate='bin/cake migrations migrate'

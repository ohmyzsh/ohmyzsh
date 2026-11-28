# CakePHP 3 basic command completion
_cakephp3_get_command_list () {
	bin/cake completion commands
}

_cakephp3_get_sub_command_list () {
	bin/cake completion subcommands ${words[2]}
}

_cakephp3_get_3rd_argument () {
	bin/cake ${words[2]} ${words[3]} | \grep '\-\ '| \awk '{print $2}'
}

_cakephp3 () {
	local -a has3rdargument
	has3rdargument=("all" "controller" "fixture" "model" "template")
	if [ -f bin/cake ]; then
		if (( CURRENT == 2 )); then
			compadd $(_cakephp3_get_command_list)
		fi
		if (( CURRENT == 3 )); then
			compadd $(_cakephp3_get_sub_command_list)
		fi
		if (( CURRENT == 4 )); then
			if [[ ${has3rdargument[(i)${words[3]}]} -le ${#has3rdargument} ]]; then
				compadd $(_cakephp3_get_3rd_argument)
			fi
		fi
  fi
}

compdef _cakephp3 bin/cake
compdef _cakephp3 cake

#Alias
alias c3='bin/cake'
alias c3cache='bin/cake schema_cache clear'
alias c3migrate='bin/cake migrations migrate'

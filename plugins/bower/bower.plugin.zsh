alias bi="bower install"
alias bl="bower list"
alias bs="bower search"

bower_package_list=''

_bower ()
{
	local curcontext="$curcontext" state line
	typeset -A opt_args

	_arguments -C \
		':command:->command' \
		'*::options:->options'

	case $state in
		(command)

			local -a subcommands
			subcommands=(${=$(bower help | grep help | sed -e 's/,//g')})
			_describe -t commands 'bower' subcommands
		;;

		(options)
			case $line[1] in

				(install)
				    if [ -z "$bower_package_list" ];then
                    bower_package_list=$(bower search | awk 'NR > 2' | cut -d '-' -f 2 | cut -d ' ' -f 2 | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g")
                fi
				    compadd "$@" $(echo $bower_package_list)
                ;;
			esac
		;;
	esac
}

compdef _bower bower

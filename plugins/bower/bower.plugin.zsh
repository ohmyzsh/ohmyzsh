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
            compadd "$@" $(bower help --no-color | egrep '^\s+[a-z\-]+(, [a-z\-]+|)\s{2,}' | sed -e 's/^\s*//' -e 's/,//' | cut -d ' ' -f 1) 
		;;

		(options)
			case $line[1] in
				(install)
				    if [ -z "$bower_package_list" ];then
                    bower_package_list=$(bower search --no-color | sed -e 's/^\s*//' | cut -d ' ' -f 1)
                fi
				    compadd "$@" $(echo $bower_package_list)
                ;;
			esac
		;;
	esac
}

compdef _bower bower

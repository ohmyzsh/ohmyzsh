# author: Peter Eisentraut
# source: https://gist.github.com/petere/10307599
# compdef kitchen

_kitchen() {
	local curcontext="$curcontext" state line
	typeset -A opt_args

	_arguments '1: :->cmds'\
	           '2: :->args'

	case $state in
		cmds)
			_arguments "1:Commands:(console converge create destroy diagnose driver help init list login setup test verify version)"
			;;
		args)
			case $line[1] in
				converge|create|destroy|diagnose|list|setup|test|verify)
					compadd "$@" all
					_kitchen_instances
					;;
				login)
					_kitchen_instances
					;;
			esac
			;;
	esac
}

_kitchen_instances() {
	if [[ $_kitchen_instances_cache_dir != $PWD ]]; then
		unset _kitchen_instances_cache
	fi
	if [[ ${+_kitchen_instances_cache} -eq 0 ]]; then
		_kitchen_instances_cache=(${(f)"$(bundle exec kitchen list -b 2>/dev/null || kitchen list -b 2>/dev/null)"})
		_kitchen_instances_cache_dir=$PWD
	fi
	compadd -a _kitchen_instances_cache
}

_kitchen "$@"

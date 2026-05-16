#compdef gas

local curcontext="$curcontext" state line cmds ret=1

_arguments -C \
	'(- 1 *)'{-v,--version}'[display version information]' \
	'(-h|--help)'{-h,--help}'[show help information]' \
	'1: :->cmds' \
	'*: :->args' && ret=0

case $state in
	cmds)
		cmds=(
            "version:Prints Gas's version"
            "use:Uses author"
            "ssh:Creates a new ssh key for an existing gas author"
            "show:Shows your current user"
            "list:Lists your authors"
            "import:Imports current user to gasconfig"
            "help:Describe available tasks or one specific task"
            "delete:Deletes author"
            "add:Adds author to gasconfig"
        )
		_describe -t commands 'gas command' cmds && ret=0
		;;
	args)
		case $line[1] in
			(use|delete)
        VERSION=$(gas -v)
        if [[ $VERSION == <1->.*.* ]] || [[ $VERSION == 0.<2->.* ]] || [[ $VERSION == 0.1.<6-> ]] then
          _values -S , 'authors' $(cat ~/.gas/gas.authors | sed -n -e 's/^.*\[\(.*\)\]/\1/p') && ret=0
        else
				  _values -S , 'authors' $(cat ~/.gas | sed -n -e 's/^\[\(.*\)\]/\1/p') && ret=0
        fi
		esac
		;;
esac

return ret

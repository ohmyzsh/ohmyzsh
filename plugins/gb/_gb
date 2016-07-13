#compdef gb
#autoload

_gb () {
	local ret=1 state
	_arguments -C ':command:->command' '*::options:->options' && ret=0

	case $state in
	(command)
		local -a subcommands
		subcommands=(
			"build:build a package"
			"doc:show documentation for a package or symbol"
			"env:print project environment variables"
			"generate:generate Go files by processing source"
			"help:displays the help"
			"info:info returns information about this project"
			"list:list the packages named by the importpaths"
			"test:test packages"
			"vendor:manage your vendored dependencies"
		)
		_describe -t subcommands 'gb subcommands' subcommands && ret=0
		;;
	(options)
		case $line[1] in
		(build)
			_arguments \
				-f'[ignore cached packages]' \
				-F'[do not cache packages]' \
				-q'[decreases verbosity]' \
				-P'[the number of build jobs to run in parallel]' \
				-R'[sets the base of the project root search path]' \
				-dotfile'[output a dot formatted file of the build steps]' \
				-ldflags'["flag list" arguments to pass to the linker]' \
				-gcflags'["arg list" arguments to pass to the compiler]' \
				-race'[enable data race detection]' \
				-tags'["tag list" additional build tags]'
			;;
		(list)
			_arguments \
				-f'[alternate format for the list, using the syntax of package template]' \
				-s'[read format template from STDIN]' \
				-json'[prints output in structured JSON format]'
			;;
		(test)
			_arguments \
				-v'[print output from test subprocess]' \
				-ldflags'["flag list" arguments to pass to the linker]' \
				-gcflags'["arg list" arguments to pass to the compiler]' \
				-race'[enable data race detection]' \
				-tags'["tag list" additional build tags]'
			;;
		(vendor)
			_gb-vendor
		esac
		;;
	esac

	return ret
}

_gb-vendor () {
	local curcontext="$curcontext" state line
	_arguments -C ':command:->command' '*::options:->options'

	case $state in
	(command)
		local -a subcommands
		subcommands=(
			'delete:deletes a local dependency'
			'fetch:fetch a remote dependency'
			'list:lists dependencies, one per line'
			'purge:remove all unreferenced dependencies'
			'restore:restore dependencies from the manifest'
			'update:update a local dependency'
		)
		_describe -t subcommands 'gb vendor subcommands' subcommands && ret=0
		;;
	(options)
		case $line[1] in
			(delete)
				_arguments \
					-all'[remove all dependencies]'
				;;
			(fetch)
				_arguments \
					-branch'[fetch from a particular branch]' \
					-no-recurse'[do not fetch recursively]' \
					-tag'[fetch the specified tag]' \
					-revision'[fetch the specific revision from the branch (if supplied)]' \
					-precaire'[allow the use of insecure protocols]' \
				;;
			(list)
				_arguments \
					-f'[controls the template used for printing each manifest entry]'
				;;
			(restore)
				_arguments \
					-precaire'[allow the use of insecure protocols]'
				;;
			(update)
				_arguments \
					-all'[update all dependencies in the manifest or supply a given dependency]' \
					-precaire'[allow the use of insecure protocols]'
				;;
		esac
		;;
	esac
}

_gb

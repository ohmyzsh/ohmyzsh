#!bash
#
# bash completion for docker-compose
#
# This work is based on the completion for the docker command.
#
# This script provides completion of:
#  - commands and their options
#  - service names
#  - filepaths
#
# To enable the completions either:
#  - place this file in /etc/bash_completion.d
#  or
#  - copy this file to e.g. ~/.docker-compose-completion.sh and add the line
#    below to your .bashrc after bash completion features are loaded
#    . ~/.docker-compose-completion.sh


# For compatibility reasons, Compose and therefore its completion supports several
# stack compositon files as listed here, in descending priority.
# Support for these filenames might be dropped in some future version.
__docker-compose_compose_file() {
	local file
	for file in docker-compose.y{,a}ml fig.y{,a}ml ; do
		[ -e $file ] && {
			echo $file
			return
		}
	done
	echo docker-compose.yml
}

# Extracts all service names from the compose file.
___docker-compose_all_services_in_compose_file() {
	awk -F: '/^[a-zA-Z0-9]/{print $1}' "${compose_file:-$(__docker-compose_compose_file)}" 2>/dev/null
}

# All services, even those without an existing container
__docker-compose_services_all() {
	COMPREPLY=( $(compgen -W "$(___docker-compose_all_services_in_compose_file)" -- "$cur") )
}

# All services that have an entry with the given key in their compose_file section
___docker-compose_services_with_key() {
	# flatten sections to one line, then filter lines containing the key and return section name.
	awk '/^[a-zA-Z0-9]/{printf "\n"};{printf $0;next;}' "${compose_file:-$(__docker-compose_compose_file)}" | awk -F: -v key=": +$1:" '$0 ~ key {print $1}'
}

# All services that are defined by a Dockerfile reference
__docker-compose_services_from_build() {
	COMPREPLY=( $(compgen -W "$(___docker-compose_services_with_key build)" -- "$cur") )
}

# All services that are defined by an image
__docker-compose_services_from_image() {
	COMPREPLY=( $(compgen -W "$(___docker-compose_services_with_key image)" -- "$cur") )
}

# The services for which containers have been created, optionally filtered
# by a boolean expression passed in as argument.
__docker-compose_services_with() {
	local containers names
	containers="$(docker-compose 2>/dev/null ${compose_file:+-f $compose_file} ${compose_project:+-p $compose_project} ps -q)"
	names=( $(docker 2>/dev/null inspect --format "{{if ${1:-true}}} {{ .Name }} {{end}}" $containers) )
	names=( ${names[@]%_*} )  # strip trailing numbers
	names=( ${names[@]#*_} )  # strip project name
	COMPREPLY=( $(compgen -W "${names[*]}" -- "$cur") )
}

# The services for which at least one running container exists
__docker-compose_services_running() {
	__docker-compose_services_with '.State.Running'
}

# The services for which at least one stopped container exists
__docker-compose_services_stopped() {
	__docker-compose_services_with 'not .State.Running'
}


_docker-compose_build() {
	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--no-cache" -- "$cur" ) )
			;;
		*)
			__docker-compose_services_from_build
			;;
	esac
}


_docker-compose_docker-compose() {
	case "$prev" in
		--file|-f)
			_filedir
			return
			;;
		--project-name|-p)
			return
			;;
	esac

	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--help -h --verbose --version --file -f --project-name -p" -- "$cur" ) )
			;;
		*)
			COMPREPLY=( $( compgen -W "${commands[*]}" -- "$cur" ) )
			;;
	esac
}


_docker-compose_help() {
	COMPREPLY=( $( compgen -W "${commands[*]}" -- "$cur" ) )
}


_docker-compose_kill() {
	case "$prev" in
		-s)
			COMPREPLY=( $( compgen -W "SIGHUP SIGINT SIGKILL SIGUSR1 SIGUSR2" -- "$(echo $cur | tr '[:lower:]' '[:upper:]')" ) )
			return
			;;
	esac

	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "-s" -- "$cur" ) )
			;;
		*)
			__docker-compose_services_running
			;;
	esac
}


_docker-compose_logs() {
	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--no-color" -- "$cur" ) )
			;;
		*)
			__docker-compose_services_all
			;;
	esac
}


_docker-compose_port() {
	case "$prev" in
		--protocol)
			COMPREPLY=( $( compgen -W "tcp udp" -- "$cur" ) )
			return;
			;;
		--index)
			return;
			;;
	esac

	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--protocol --index" -- "$cur" ) )
			;;
		*)
			__docker-compose_services_all
			;;
	esac
}


_docker-compose_ps() {
	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "-q" -- "$cur" ) )
			;;
		*)
			__docker-compose_services_all
			;;
	esac
}


_docker-compose_pull() {
	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--allow-insecure-ssl" -- "$cur" ) )
			;;
		*)
			__docker-compose_services_from_image
			;;
	esac
}


_docker-compose_restart() {
	__docker-compose_services_running
}


_docker-compose_rm() {
	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--force -v" -- "$cur" ) )
			;;
		*)
			__docker-compose_services_stopped
			;;
	esac
}


_docker-compose_run() {
	case "$prev" in
		-e)
			COMPREPLY=( $( compgen -e -- "$cur" ) )
			compopt -o nospace
			return
			;;
		--entrypoint)
			return
			;;
	esac

	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--allow-insecure-ssl -d --entrypoint -e --no-deps --rm --service-ports -T" -- "$cur" ) )
			;;
		*)
			__docker-compose_services_all
			;;
	esac
}


_docker-compose_scale() {
	case "$prev" in
		=)
			COMPREPLY=("$cur")
			;;
		*)
			COMPREPLY=( $(compgen -S "=" -W "$(___docker-compose_all_services_in_compose_file)" -- "$cur") )
			compopt -o nospace
			;;
	esac
}


_docker-compose_start() {
	__docker-compose_services_stopped
}


_docker-compose_stop() {
	__docker-compose_services_running
}


_docker-compose_up() {
	case "$cur" in
		-*)
			COMPREPLY=( $( compgen -W "--allow-insecure-ssl -d --no-build --no-color --no-deps --no-recreate" -- "$cur" ) )
			;;
		*)
			__docker-compose_services_all
			;;
	esac
}


_docker-compose() {
	local commands=(
		build
		help
		kill
		logs
		port
		ps
		pull
		restart
		rm
		run
		scale
		start
		stop
		up
	)

	COMPREPLY=()
	local cur prev words cword
	_get_comp_words_by_ref -n : cur prev words cword

	# search subcommand and invoke its handler.
	# special treatment of some top-level options
	local command='docker-compose'
	local counter=1
	local compose_file compose_project
	while [ $counter -lt $cword ]; do
		case "${words[$counter]}" in
			-f|--file)
				(( counter++ ))
				compose_file="${words[$counter]}"
				;;
			-p|--project-name)
				(( counter++ ))
				compose_project="${words[$counter]}"
				;;
			-*)
				;;
			*)
				command="${words[$counter]}"
				break
				;;
		esac
		(( counter++ ))
	done

	local completions_func=_docker-compose_${command}
	declare -F $completions_func >/dev/null && $completions_func

	return 0
}

complete -F _docker-compose docker-compose

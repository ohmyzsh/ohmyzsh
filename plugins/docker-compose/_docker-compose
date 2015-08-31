#compdef docker-compose

# Description
# -----------
#  zsh completion for docker-compose
#  https://github.com/sdurrheimer/docker-compose-zsh-completion
# -------------------------------------------------------------------------
# Version
# -------
#  0.1.0
# -------------------------------------------------------------------------
# Authors
# -------
#  * Steve Durrheimer <s.durrheimer@gmail.com>
# -------------------------------------------------------------------------
# Inspiration
# -----------
#  * @albers docker-compose bash completion script
#  * @felixr docker zsh completion script : https://github.com/felixr/docker-zsh-completion
# -------------------------------------------------------------------------

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

# Extracts all service names from docker-compose.yml.
___docker-compose_all_services_in_compose_file() {
    local already_selected
    local -a services
    already_selected=$(echo ${words[@]} | tr " " "|")
    awk -F: '/^[a-zA-Z0-9]/{print $1}' "${compose_file:-$(__docker-compose_compose_file)}" 2>/dev/null | grep -Ev "$already_selected"
}

# All services, even those without an existing container
__docker-compose_services_all() {
    services=$(___docker-compose_all_services_in_compose_file)
    _alternative "args:services:($services)"
}

# All services that have an entry with the given key in their docker-compose.yml section
___docker-compose_services_with_key() {
    local already_selected
    local -a buildable
    already_selected=$(echo ${words[@]} | tr " " "|")
    # flatten sections to one line, then filter lines containing the key and return section name.
    awk '/^[a-zA-Z0-9]/{printf "\n"};{printf $0;next;}' "${compose_file:-$(__docker-compose_compose_file)}" 2>/dev/null | awk -F: -v key=": +$1:" '$0 ~ key {print $1}' 2>/dev/null | grep -Ev "$already_selected"
}

# All services that are defined by a Dockerfile reference
__docker-compose_services_from_build() {
    buildable=$(___docker-compose_services_with_key build)
    _alternative "args:buildable services:($buildable)"
}

# All services that are defined by an image
__docker-compose_services_from_image() {
    pullable=$(___docker-compose_services_with_key image)
    _alternative "args:pullable services:($pullable)"
}

__docker-compose_get_services() {
    local kind expl
    declare -a running stopped lines args services

    docker_status=$(docker ps > /dev/null 2>&1)
    if [ $? -ne 0 ]; then
        _message "Error! Docker is not running."
        return 1
    fi

    kind=$1
    shift
    [[ $kind = (stopped|all) ]] && args=($args -a)

    lines=(${(f)"$(_call_program commands docker ps ${args})"})
    services=(${(f)"$(_call_program commands docker-compose 2>/dev/null ${compose_file:+-f $compose_file} ${compose_project:+-p $compose_project} ps -q)"})

    # Parse header line to find columns
    local i=1 j=1 k header=${lines[1]}
    declare -A begin end
    while (( $j < ${#header} - 1 )) {
        i=$(( $j + ${${header[$j,-1]}[(i)[^ ]]} - 1))
        j=$(( $i + ${${header[$i,-1]}[(i)  ]} - 1))
        k=$(( $j + ${${header[$j,-1]}[(i)[^ ]]} - 2))
        begin[${header[$i,$(($j-1))]}]=$i
        end[${header[$i,$(($j-1))]}]=$k
    }
    lines=(${lines[2,-1]})

    # Container ID
    local line s name
    local -a names
    for line in $lines; do
        if [[ $services == *"${line[${begin[CONTAINER ID]},${end[CONTAINER ID]}]%% ##}"* ]]; then
            names=(${(ps:,:)${${line[${begin[NAMES]},-1]}%% *}})
            for name in $names; do
                s="${${name%_*}#*_}:${(l:15:: :::)${${line[${begin[CREATED]},${end[CREATED]}]/ ago/}%% ##}}"
                s="$s, ${line[${begin[CONTAINER ID]},${end[CONTAINER ID]}]%% ##}"
                s="$s, ${${${line[$begin[IMAGE],$end[IMAGE]]}/:/\\:}%% ##}"
                if [[ ${line[${begin[STATUS]},${end[STATUS]}]} = Exit* ]]; then
                    stopped=($stopped $s)
                else
                    running=($running $s)
                fi
            done
        fi
    done

    [[ $kind = (running|all) ]] && _describe -t services-running "running services" running
    [[ $kind = (stopped|all) ]] && _describe -t services-stopped "stopped services" stopped
}

__docker-compose_stoppedservices() {
    __docker-compose_get_services stopped "$@"
}

__docker-compose_runningservices() {
    __docker-compose_get_services running "$@"
}

__docker-compose_services () {
    __docker-compose_get_services all "$@"
}

__docker-compose_caching_policy() {
    oldp=( "$1"(Nmh+1) )     # 1 hour
    (( $#oldp ))
}

__docker-compose_commands () {
    local cache_policy

    zstyle -s ":completion:${curcontext}:" cache-policy cache_policy
    if [[ -z "$cache_policy" ]]; then
        zstyle ":completion:${curcontext}:" cache-policy __docker-compose_caching_policy
    fi

    if ( [[ ${+_docker_compose_subcommands} -eq 0 ]] || _cache_invalid docker_compose_subcommands) \
        && ! _retrieve_cache docker_compose_subcommands;
    then
        local -a lines
        lines=(${(f)"$(_call_program commands docker-compose 2>&1)"})
        _docker_compose_subcommands=(${${${lines[$((${lines[(i)Commands:]} + 1)),${lines[(I)  *]}]}## #}/ ##/:})
        _store_cache docker_compose_subcommands _docker_compose_subcommands
    fi
    _describe -t docker-compose-commands "docker-compose command" _docker_compose_subcommands
}

__docker-compose_subcommand () {
    local -a _command_args
    integer ret=1
    case "$words[1]" in
        (build)
            _arguments \
                '--no-cache[Do not use cache when building the image]' \
                '*:services:__docker-compose_services_from_build' && ret=0
            ;;
        (help)
            _arguments ':subcommand:__docker-compose_commands' && ret=0
            ;;
        (kill)
            _arguments \
                '-s[SIGNAL to send to the container. Default signal is SIGKILL.]:signal:_signals' \
                '*:running services:__docker-compose_runningservices' && ret=0
            ;;
        (logs)
            _arguments \
                '--no-color[Produce monochrome output.]' \
                '*:services:__docker-compose_services_all' && ret=0
            ;;
        (migrate-to-labels)
            _arguments \
                '(-):Recreate containers to add labels' && ret=0
            ;;
        (port)
            _arguments \
                '--protocol=-[tcp or udap (defaults to tcp)]:protocol:(tcp udp)' \
                '--index=-[index of the container if there are mutiple instances of a service (defaults to 1)]:index: ' \
                '1:running services:__docker-compose_runningservices' \
                '2:port:_ports' && ret=0
            ;;
        (ps)
            _arguments \
                '-q[Only display IDs]' \
                '*:services:__docker-compose_services_all' && ret=0
            ;;
        (pull)
            _arguments \
                '--allow-insecure-ssl[Allow insecure connections to the docker registry]' \
                '*:services:__docker-compose_services_from_image' && ret=0
            ;;
        (rm)
            _arguments \
                '(-f --force)'{-f,--force}"[Don't ask to confirm removal]" \
                '-v[Remove volumes associated with containers]' \
                '*:stopped services:__docker-compose_stoppedservices' && ret=0
            ;;
        (run)
            _arguments \
                '--allow-insecure-ssl[Allow insecure connections to the docker registry]' \
                '-d[Detached mode: Run container in the background, print new container name.]' \
                '--entrypoint[Overwrite the entrypoint of the image.]:entry point: ' \
                '*-e[KEY=VAL Set an environment variable (can be used multiple times)]:environment variable KEY=VAL: ' \
                '(-u --user)'{-u,--user=-}'[Run as specified username or uid]:username or uid:_users' \
                "--no-deps[Don't start linked services.]" \
                '--rm[Remove container after run. Ignored in detached mode.]' \
                "--service-ports[Run command with the service's ports enabled and mapped to the host.]" \
                '-T[Disable pseudo-tty allocation. By default `docker-compose run` allocates a TTY.]' \
                '(-):services:__docker-compose_services' \
                '(-):command: _command_names -e' \
                '*::arguments: _normal' && ret=0
            ;;
        (scale)
            _arguments '*:running services:__docker-compose_runningservices' && ret=0
            ;;
        (start)
            _arguments '*:stopped services:__docker-compose_stoppedservices' && ret=0
            ;;
        (stop|restart)
            _arguments \
                '(-t --timeout)'{-t,--timeout}"[Specify a shutdown timeout in seconds. (default: 10)]:seconds: " \
                '*:running services:__docker-compose_runningservices' && ret=0
            ;;
        (up)
            _arguments \
                '--allow-insecure-ssl[Allow insecure connections to the docker registry]' \
                '-d[Detached mode: Run containers in the background, print new container names.]' \
                '--no-color[Produce monochrome output.]' \
                "--no-deps[Don't start linked services.]" \
                "--no-recreate[If containers already exist, don't recreate them.]" \
                "--no-build[Don't build an image, even if it's missing]" \
                '(-t --timeout)'{-t,--timeout}"[Specify a shutdown timeout in seconds. (default: 10)]:seconds: " \
                "--x-smart-recreate[Only recreate containers whose configuration or image needs to be updated. (EXPERIMENTAL)]" \
                '*:services:__docker-compose_services_all' && ret=0
            ;;
        (version)
            _arguments \
                "--short[Shows only Compose's version number.]" && ret=0
            ;;
        (*)
            _message 'Unknown sub command'
    esac

    return ret
}

_docker-compose () {
    # Support for subservices, which allows for `compdef _docker docker-shell=_docker_containers`.
    # Based on /usr/share/zsh/functions/Completion/Unix/_git without support for `ret`.
    if [[ $service != docker-compose ]]; then
        _call_function - _$service
        return
    fi

    local curcontext="$curcontext" state line ret=1
    typeset -A opt_args

    _arguments -C \
        '(- :)'{-h,--help}'[Get help]' \
        '--verbose[Show more output]' \
        '(- :)'{-v,--version}'[Print version and exit]' \
        '(-f --file)'{-f,--file}'[Specify an alternate docker-compose file (default: docker-compose.yml)]:file:_files -g "*.yml"' \
        '(-p --project-name)'{-p,--project-name}'[Specify an alternate project name (default: directory name)]:project name:' \
        '(-): :->command' \
        '(-)*:: :->option-or-argument' && ret=0

    local counter=1
    #local compose_file compose_project
    while [ $counter -lt ${#words[@]} ]; do
        case "${words[$counter]}" in
            -f|--file)
                (( counter++ ))
                compose_file="${words[$counter]}"
                ;;
            -p|--project-name)
                (( counter++ ))
                compose_project="${words[$counter]}"
                ;;
            *)
                ;;
        esac
        (( counter++ ))
    done

    case $state in
        (command)
            __docker-compose_commands && ret=0
            ;;
        (option-or-argument)
            curcontext=${curcontext%:*:*}:docker-compose-$words[1]:
            __docker-compose_subcommand && ret=0
            ;;
    esac

    return ret
}

_docker-compose "$@"

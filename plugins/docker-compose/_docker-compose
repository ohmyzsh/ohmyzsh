#compdef docker-compose

# Description
# -----------
#  zsh completion for docker-compose
#  https://github.com/sdurrheimer/docker-compose-zsh-completion
# -------------------------------------------------------------------------
# Version
# -------
#  1.5.0
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

__docker-compose_q() {
    docker-compose 2>/dev/null $compose_options "$@"
}

# All services defined in docker-compose.yml
__docker-compose_all_services_in_compose_file() {
    local already_selected
    local -a services
    already_selected=$(echo $words | tr " " "|")
    __docker-compose_q config --services \
        | grep -Ev "^(${already_selected})$"
}

# All services, even those without an existing container
__docker-compose_services_all() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    services=$(__docker-compose_all_services_in_compose_file)
    _alternative "args:services:($services)" && ret=0

    return ret
}

# All services that have an entry with the given key in their docker-compose.yml section
__docker-compose_services_with_key() {
    local already_selected
    local -a buildable
    already_selected=$(echo $words | tr " " "|")
    # flatten sections to one line, then filter lines containing the key and return section name.
    __docker-compose_q config \
        | sed -n -e '/^services:/,/^[^ ]/p' \
        | sed -n 's/^  //p' \
        | awk '/^[a-zA-Z0-9]/{printf "\n"};{printf $0;next;}' \
        | grep " \+$1:" \
        | cut -d: -f1 \
        | grep -Ev "^(${already_selected})$"
}

# All services that are defined by a Dockerfile reference
__docker-compose_services_from_build() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    buildable=$(__docker-compose_services_with_key build)
    _alternative "args:buildable services:($buildable)" && ret=0

   return ret
}

# All services that are defined by an image
__docker-compose_services_from_image() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    pullable=$(__docker-compose_services_with_key image)
    _alternative "args:pullable services:($pullable)" && ret=0

    return ret
}

__docker-compose_get_services() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    local kind
    declare -a running paused stopped lines args services

    docker_status=$(docker ps > /dev/null 2>&1)
    if [ $? -ne 0 ]; then
        _message "Error! Docker is not running."
        return 1
    fi

    kind=$1
    shift
    [[ $kind =~ (stopped|all) ]] && args=($args -a)

    lines=(${(f)"$(_call_program commands docker $docker_options ps $args)"})
    services=(${(f)"$(_call_program commands docker-compose 2>/dev/null $compose_options ps -q)"})

    # Parse header line to find columns
    local i=1 j=1 k header=${lines[1]}
    declare -A begin end
    while (( j < ${#header} - 1 )); do
        i=$(( j + ${${header[$j,-1]}[(i)[^ ]]} - 1 ))
        j=$(( i + ${${header[$i,-1]}[(i)  ]} - 1 ))
        k=$(( j + ${${header[$j,-1]}[(i)[^ ]]} - 2 ))
        begin[${header[$i,$((j-1))]}]=$i
        end[${header[$i,$((j-1))]}]=$k
    done
    lines=(${lines[2,-1]})

    # Container ID
    local line s name
    local -a names
    for line in $lines; do
        if [[ ${services[@]} == *"${line[${begin[CONTAINER ID]},${end[CONTAINER ID]}]%% ##}"* ]]; then
            names=(${(ps:,:)${${line[${begin[NAMES]},-1]}%% *}})
            for name in $names; do
                s="${${name%_*}#*_}:${(l:15:: :::)${${line[${begin[CREATED]},${end[CREATED]}]/ ago/}%% ##}}"
                s="$s, ${line[${begin[CONTAINER ID]},${end[CONTAINER ID]}]%% ##}"
                s="$s, ${${${line[${begin[IMAGE]},${end[IMAGE]}]}/:/\\:}%% ##}"
                if [[ ${line[${begin[STATUS]},${end[STATUS]}]} = Exit* ]]; then
                    stopped=($stopped $s)
                else
                    if [[  ${line[${begin[STATUS]},${end[STATUS]}]} = *\(Paused\)* ]]; then
                        paused=($paused $s)
                    fi
                    running=($running $s)
                fi
            done
        fi
    done

    [[ $kind =~ (running|all) ]] && _describe -t services-running "running services" running "$@" && ret=0
    [[ $kind =~ (paused|all) ]] && _describe -t services-paused "paused services" paused "$@" && ret=0
    [[ $kind =~ (stopped|all) ]] && _describe -t services-stopped "stopped services" stopped "$@" && ret=0

    return ret
}

__docker-compose_pausedservices() {
    [[ $PREFIX = -* ]] && return 1
    __docker-compose_get_services paused "$@"
}

__docker-compose_stoppedservices() {
    [[ $PREFIX = -* ]] && return 1
    __docker-compose_get_services stopped "$@"
}

__docker-compose_runningservices() {
    [[ $PREFIX = -* ]] && return 1
    __docker-compose_get_services running "$@"
}

__docker-compose_services() {
    [[ $PREFIX = -* ]] && return 1
    __docker-compose_get_services all "$@"
}

__docker-compose_caching_policy() {
    oldp=( "$1"(Nmh+1) )            # 1 hour
    (( $#oldp ))
}

__docker-compose_commands() {
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
        (( $#_docker_compose_subcommands > 0 )) && _store_cache docker_compose_subcommands _docker_compose_subcommands
    fi
    _describe -t docker-compose-commands "docker-compose command" _docker_compose_subcommands
}

__docker-compose_subcommand() {
    local opts_help opts_force_recreate opts_no_recreate opts_no_build opts_remove_orphans opts_timeout opts_no_color opts_no_deps

    opts_help='(: -)--help[Print usage]'
    opts_force_recreate="(--no-recreate)--force-recreate[Recreate containers even if their configuration and image haven't changed. Incompatible with --no-recreate.]"
    opts_no_recreate="(--force-recreate)--no-recreate[If containers already exist, don't recreate them. Incompatible with --force-recreate.]"
    opts_no_build="(--build)--no-build[Don't build an image, even if it's missing.]"
    opts_remove_orphans="--remove-orphans[Remove containers for services not defined in the Compose file]"
    opts_timeout=('(-t --timeout)'{-t,--timeout}"[Specify a shutdown timeout in seconds. (default: 10)]:seconds: ")
    opts_no_color='--no-color[Produce monochrome output.]'
    opts_no_deps="--no-deps[Don't start linked services.]"

    integer ret=1

    case "$words[1]" in
        (build)
            _arguments \
                $opts_help \
                '--force-rm[Always remove intermediate containers.]' \
                '--no-cache[Do not use cache when building the image.]' \
                '--pull[Always attempt to pull a newer version of the image.]' \
                '*:services:__docker-compose_services_from_build' && ret=0
            ;;
        (bundle)
            _arguments \
                $opts_help \
                '(--output -o)'{--output,-o}'[Path to write the bundle file to. Defaults to "<project name>.dab".]:file:_files' && ret=0
            ;;
        (config)
            _arguments \
                $opts_help \
                '(--quiet -q)'{--quiet,-q}"[Only validate the configuration, don't print anything.]" \
                '--services[Print the service names, one per line.]' && ret=0
            ;;
        (create)
            _arguments \
                $opts_help \
                $opts_force_recreate \
                $opts_no_recreate \
                $opts_no_build \
                "(--no-build)--build[Build images before creating containers.]" \
                '*:services:__docker-compose_services_all' && ret=0
            ;;
        (down)
            _arguments \
                $opts_help \
                "--rmi[Remove images. Type must be one of: 'all': Remove all images used by any service. 'local': Remove only images that don't have a custom tag set by the \`image\` field.]:type:(all local)" \
                '(-v --volumes)'{-v,--volumes}"[Remove named volumes declared in the \`volumes\` section of the Compose file and anonymous volumes attached to containers.]" \
                $opts_remove_orphans && ret=0
            ;;
        (events)
            _arguments \
                $opts_help \
                '--json[Output events as a stream of json objects]' \
                '*:services:__docker-compose_services_all' && ret=0
            ;;
        (exec)
            _arguments \
                $opts_help \
                '-d[Detached mode: Run command in the background.]' \
                '--privileged[Give extended privileges to the process.]' \
                '--user=[Run the command as this user.]:username:_users' \
                '-T[Disable pseudo-tty allocation. By default `docker-compose exec` allocates a TTY.]' \
                '--index=[Index of the container if there are multiple instances of a service \[default: 1\]]:index: ' \
                '(-):running services:__docker-compose_runningservices' \
                '(-):command: _command_names -e' \
                '*::arguments: _normal' && ret=0
            ;;
        (help)
            _arguments ':subcommand:__docker-compose_commands' && ret=0
            ;;
        (kill)
            _arguments \
                $opts_help \
                '-s[SIGNAL to send to the container. Default signal is SIGKILL.]:signal:_signals' \
                '*:running services:__docker-compose_runningservices' && ret=0
            ;;
        (logs)
            _arguments \
                $opts_help \
                '(-f --follow)'{-f,--follow}'[Follow log output]' \
                $opts_no_color \
                '--tail=[Number of lines to show from the end of the logs for each container.]:number of lines: ' \
                '(-t --timestamps)'{-t,--timestamps}'[Show timestamps]' \
                '*:services:__docker-compose_services_all' && ret=0
            ;;
        (pause)
            _arguments \
                $opts_help \
                '*:running services:__docker-compose_runningservices' && ret=0
            ;;
        (port)
            _arguments \
                $opts_help \
                '--protocol=[tcp or udp \[default: tcp\]]:protocol:(tcp udp)' \
                '--index=[index of the container if there are multiple instances of a service \[default: 1\]]:index: ' \
                '1:running services:__docker-compose_runningservices' \
                '2:port:_ports' && ret=0
            ;;
        (ps)
            _arguments \
                $opts_help \
                '-q[Only display IDs]' \
                '*:services:__docker-compose_services_all' && ret=0
            ;;
        (pull)
            _arguments \
                $opts_help \
                '--ignore-pull-failures[Pull what it can and ignores images with pull failures.]' \
                '*:services:__docker-compose_services_from_image' && ret=0
            ;;
        (push)
            _arguments \
                $opts_help \
                '--ignore-push-failures[Push what it can and ignores images with push failures.]' \
                '*:services:__docker-compose_services' && ret=0
            ;;
        (rm)
            _arguments \
                $opts_help \
                '(-f --force)'{-f,--force}"[Don't ask to confirm removal]" \
                '-v[Remove any anonymous volumes attached to containers]' \
                '*:stopped services:__docker-compose_stoppedservices' && ret=0
            ;;
        (run)
            _arguments \
                $opts_help \
                '-d[Detached mode: Run container in the background, print new container name.]' \
                '*-e[KEY=VAL Set an environment variable (can be used multiple times)]:environment variable KEY=VAL: ' \
                '--entrypoint[Overwrite the entrypoint of the image.]:entry point: ' \
                '--name=[Assign a name to the container]:name: ' \
                $opts_no_deps \
                '(-p --publish)'{-p,--publish=}"[Publish a container's port(s) to the host]" \
                '--rm[Remove container after run. Ignored in detached mode.]' \
                "--service-ports[Run command with the service's ports enabled and mapped to the host.]" \
                '-T[Disable pseudo-tty allocation. By default `docker-compose run` allocates a TTY.]' \
                '(-u --user)'{-u,--user=}'[Run as specified username or uid]:username or uid:_users' \
                '(-w --workdir)'{-w,--workdir=}'[Working directory inside the container]:workdir: ' \
                '(-):services:__docker-compose_services' \
                '(-):command: _command_names -e' \
                '*::arguments: _normal' && ret=0
            ;;
        (scale)
            _arguments \
                $opts_help \
                $opts_timeout \
                '*:running services:__docker-compose_runningservices' && ret=0
            ;;
        (start)
            _arguments \
                $opts_help \
                '*:stopped services:__docker-compose_stoppedservices' && ret=0
            ;;
        (stop|restart)
            _arguments \
                $opts_help \
                $opts_timeout \
                '*:running services:__docker-compose_runningservices' && ret=0
            ;;
        (unpause)
            _arguments \
                $opts_help \
                '*:paused services:__docker-compose_pausedservices' && ret=0
            ;;
        (up)
            _arguments \
                $opts_help \
                '(--abort-on-container-exit)-d[Detached mode: Run containers in the background, print new container names. Incompatible with --abort-on-container-exit.]' \
                $opts_no_color \
                $opts_no_deps \
                $opts_force_recreate \
                $opts_no_recreate \
                $opts_no_build \
                "(--no-build)--build[Build images before starting containers.]" \
                "(-d)--abort-on-container-exit[Stops all containers if any container was stopped. Incompatible with -d.]" \
                '(-t --timeout)'{-t,--timeout}"[Use this timeout in seconds for container shutdown when attached or when containers are already running. (default: 10)]:seconds: " \
                $opts_remove_orphans \
                '*:services:__docker-compose_services_all' && ret=0
            ;;
        (version)
            _arguments \
                $opts_help \
                "--short[Shows only Compose's version number.]" && ret=0
            ;;
        (*)
            _message 'Unknown sub command' && ret=1
            ;;
    esac

    return ret
}

_docker-compose() {
    # Support for subservices, which allows for `compdef _docker docker-shell=_docker_containers`.
    # Based on /usr/share/zsh/functions/Completion/Unix/_git without support for `ret`.
    if [[ $service != docker-compose ]]; then
        _call_function - _$service
        return
    fi

    local curcontext="$curcontext" state line
    integer ret=1
    typeset -A opt_args

    _arguments -C \
        '(- :)'{-h,--help}'[Get help]' \
        '(-f --file)'{-f,--file}'[Specify an alternate docker-compose file (default: docker-compose.yml)]:file:_files -g "*.yml"' \
        '(-p --project-name)'{-p,--project-name}'[Specify an alternate project name (default: directory name)]:project name:' \
        '--verbose[Show more output]' \
        '(- :)'{-v,--version}'[Print version and exit]' \
        '(-H --host)'{-H,--host}'[Daemon socket to connect to]:host:' \
        '--tls[Use TLS; implied by --tlsverify]' \
        '--tlscacert=[Trust certs signed only by this CA]:ca path:' \
        '--tlscert=[Path to TLS certificate file]:client cert path:' \
        '--tlskey=[Path to TLS key file]:tls key path:' \
        '--tlsverify[Use TLS and verify the remote]' \
        "--skip-hostname-check[Don't check the daemon's hostname against the name specified in the client certificate (for example if your docker host is an IP address)]" \
        '(-): :->command' \
        '(-)*:: :->option-or-argument' && ret=0

    local -a relevant_compose_flags relevant_docker_flags compose_options docker_options

    relevant_compose_flags=(
        "--file" "-f"
        "--host" "-H"
        "--project-name" "-p"
        "--tls"
        "--tlscacert"
        "--tlscert"
        "--tlskey"
        "--tlsverify"
        "--skip-hostname-check"
    )

    relevant_docker_flags=(
        "--host" "-H"
        "--tls"
        "--tlscacert"
        "--tlscert"
        "--tlskey"
        "--tlsverify"
    )

    for k in "${(@k)opt_args}"; do
        if [[ -n "${relevant_docker_flags[(r)$k]}" ]]; then
            docker_options+=$k
            if [[ -n "$opt_args[$k]" ]]; then
                docker_options+=$opt_args[$k]
            fi
        fi
        if [[ -n "${relevant_compose_flags[(r)$k]}" ]]; then
            compose_options+=$k
            if [[ -n "$opt_args[$k]" ]]; then
                compose_options+=$opt_args[$k]
            fi
        fi
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

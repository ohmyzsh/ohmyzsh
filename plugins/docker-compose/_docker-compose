#compdef docker-compose

# Description
# -----------
#  zsh completion for docker-compose
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
    __docker-compose_q ps --services "$@" \
        | grep -Ev "^(${already_selected})$"
}

# All services, even those without an existing container
__docker-compose_services_all() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    services=$(__docker-compose_all_services_in_compose_file "$@")
    _alternative "args:services:($services)" && ret=0

    return ret
}

# All services that are defined by a Dockerfile reference
__docker-compose_services_from_build() {
    [[ $PREFIX = -* ]] && return 1
    __docker-compose_services_all --filter source=build
}

# All services that are defined by an image
__docker-compose_services_from_image() {
    [[ $PREFIX = -* ]] && return 1
    __docker-compose_services_all --filter source=image
}

__docker-compose_pausedservices() {
    [[ $PREFIX = -* ]] && return 1
    __docker-compose_services_all --filter status=paused
}

__docker-compose_stoppedservices() {
    [[ $PREFIX = -* ]] && return 1
    __docker-compose_services_all --filter status=stopped
}

__docker-compose_runningservices() {
    [[ $PREFIX = -* ]] && return 1
    __docker-compose_services_all --filter status=running
}

__docker-compose_services() {
    [[ $PREFIX = -* ]] && return 1
    __docker-compose_services_all
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
                "*--build-arg=[Set build-time variables for one service.]:<varname>=<value>: " \
                '--force-rm[Always remove intermediate containers.]' \
                '(--quiet -q)'{--quiet,-q}'[Curb build output]' \
                '(--memory -m)'{--memory,-m}'[Memory limit for the build container.]' \
                '--no-cache[Do not use cache when building the image.]' \
                '--pull[Always attempt to pull a newer version of the image.]' \
                '--compress[Compress the build context using gzip.]' \
                '--parallel[Build images in parallel.]' \
                '*:services:__docker-compose_services_from_build' && ret=0
            ;;
        (config)
            _arguments \
                $opts_help \
                '(--quiet -q)'{--quiet,-q}"[Only validate the configuration, don't print anything.]" \
                '--resolve-image-digests[Pin image tags to digests.]' \
                '--services[Print the service names, one per line.]' \
                '--volumes[Print the volume names, one per line.]' \
                '--hash[Print the service config hash, one per line. Set "service1,service2" for a list of specified services.]' \ && ret=0
            ;;
        (create)
            _arguments \
                $opts_help \
                $opts_force_recreate \
                $opts_no_recreate \
                $opts_no_build \
                "(--no-build)--build[Build images before creating containers.]" \
                '*:services:__docker-compose_services' && ret=0
            ;;
        (down)
            _arguments \
                $opts_help \
                $opts_timeout \
                "--rmi[Remove images. Type must be one of: 'all': Remove all images used by any service. 'local': Remove only images that don't have a custom tag set by the \`image\` field.]:type:(all local)" \
                '(-v --volumes)'{-v,--volumes}"[Remove named volumes declared in the \`volumes\` section of the Compose file and anonymous volumes attached to containers.]" \
                $opts_remove_orphans && ret=0
            ;;
        (events)
            _arguments \
                $opts_help \
                '--json[Output events as a stream of json objects]' \
                '*:services:__docker-compose_services' && ret=0
            ;;
        (exec)
            _arguments \
                $opts_help \
                '-d[Detached mode: Run command in the background.]' \
                '--privileged[Give extended privileges to the process.]' \
                '(-u --user)'{-u,--user=}'[Run the command as this user.]:username:_users' \
                '-T[Disable pseudo-tty allocation. By default `docker-compose exec` allocates a TTY.]' \
                '--index=[Index of the container if there are multiple instances of a service \[default: 1\]]:index: ' \
                '*'{-e,--env}'[KEY=VAL Set an environment variable (can be used multiple times)]:environment variable KEY=VAL: ' \
                '(-w --workdir)'{-w,--workdir=}'[Working directory inside the container]:workdir: ' \
                '(-):running services:__docker-compose_runningservices' \
                '(-):command: _command_names -e' \
                '*::arguments: _normal' && ret=0
            ;;
        (help)
            _arguments ':subcommand:__docker-compose_commands' && ret=0
            ;;
    (images)
        _arguments \
        $opts_help \
        '-q[Only display IDs]' \
        '*:services:__docker-compose_services' && ret=0
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
                '*:services:__docker-compose_services' && ret=0
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
                '--filter KEY=VAL[Filter services by a property]:<filtername>=<value>:' \
                '*:services:__docker-compose_services' && ret=0
            ;;
        (pull)
            _arguments \
                $opts_help \
                '--ignore-pull-failures[Pull what it can and ignores images with pull failures.]' \
                '--no-parallel[Disable parallel pulling]' \
                '(-q --quiet)'{-q,--quiet}'[Pull without printing progress information]' \
                '--include-deps[Also pull services declared as dependencies]' \
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
                $opts_no_deps \
                '-d[Detached mode: Run container in the background, print new container name.]' \
                '*-e[KEY=VAL Set an environment variable (can be used multiple times)]:environment variable KEY=VAL: ' \
                '*'{-l,--label}'[KEY=VAL Add or override a label (can be used multiple times)]:label KEY=VAL: ' \
                '--entrypoint[Overwrite the entrypoint of the image.]:entry point: ' \
                '--name=[Assign a name to the container]:name: ' \
                '(-p --publish)'{-p,--publish=}"[Publish a container's port(s) to the host]" \
                '--rm[Remove container after run. Ignored in detached mode.]' \
                "--service-ports[Run command with the service's ports enabled and mapped to the host.]" \
                '-T[Disable pseudo-tty allocation. By default `docker-compose run` allocates a TTY.]' \
                '(-u --user)'{-u,--user=}'[Run as specified username or uid]:username or uid:_users' \
                '(-v --volume)*'{-v,--volume=}'[Bind mount a volume]:volume: ' \
                '(-w --workdir)'{-w,--workdir=}'[Working directory inside the container]:workdir: ' \
                "--use-aliases[Use the services network aliases in the network(s) the container connects to]" \
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
        (top)
            _arguments \
                $opts_help \
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
                '(--abort-on-container-exit)-d[Detached mode: Run containers in the background, print new container names. Incompatible with --abort-on-container-exit and --attach-dependencies.]' \
                $opts_no_color \
                $opts_no_deps \
                $opts_force_recreate \
                $opts_no_recreate \
                $opts_no_build \
                "(--no-build)--build[Build images before starting containers.]" \
                "(-d)--abort-on-container-exit[Stops all containers if any container was stopped. Incompatible with -d.]" \
                "(-d)--attach-dependencies[Attach to dependent containers. Incompatible with -d.]" \
                '(-t --timeout)'{-t,--timeout}"[Use this timeout in seconds for container shutdown when attached or when containers are already running. (default: 10)]:seconds: " \
                '--scale[SERVICE=NUM Scale SERVICE to NUM instances. Overrides the `scale` setting in the Compose file if present.]:service scale SERVICE=NUM: ' \
                '--exit-code-from=[Return the exit code of the selected service container. Implies --abort-on-container-exit]:service:__docker-compose_services' \
                $opts_remove_orphans \
                '*:services:__docker-compose_services' && ret=0
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

    local file_description

    if [[ -n ${words[(r)-f]} || -n ${words[(r)--file]} ]] ; then
        file_description="Specify an override docker-compose file (default: docker-compose.override.yml)"
    else
        file_description="Specify an alternate docker-compose file (default: docker-compose.yml)"
    fi

    _arguments -C \
        '(- :)'{-h,--help}'[Get help]' \
        '*'{-f,--file}"[${file_description}]:file:_files -g '*.yml'" \
        '(-p --project-name)'{-p,--project-name}'[Specify an alternate project name (default: directory name)]:project name:' \
        '--env-file[Specify an alternate environment file (default: .env)]:env-file:_files' \
        "--compatibility[If set, Compose will attempt to convert keys in v3 files to their non-Swarm equivalent]" \
        '(- :)'{-v,--version}'[Print version and exit]' \
        '--verbose[Show more output]' \
        '--log-level=[Set log level]:level:(DEBUG INFO WARNING ERROR CRITICAL)' \
        '--no-ansi[Do not print ANSI control characters]' \
        '--ansi=[Control when to print ANSI control characters]:when:(never always auto)' \
        '(-H --host)'{-H,--host}'[Daemon socket to connect to]:host:' \
        '--tls[Use TLS; implied by --tlsverify]' \
        '--tlscacert=[Trust certs signed only by this CA]:ca path:' \
        '--tlscert=[Path to TLS certificate file]:client cert path:' \
        '--tlskey=[Path to TLS key file]:tls key path:' \
        '--tlsverify[Use TLS and verify the remote]' \
        "--skip-hostname-check[Don't check the daemon's hostname against the name specified in the client certificate (for example if your docker host is an IP address)]" \
        '(-): :->command' \
        '(-)*:: :->option-or-argument' && ret=0

    local -a relevant_compose_flags relevant_compose_repeatable_flags relevant_docker_flags compose_options docker_options

    relevant_compose_flags=(
        "--env-file"
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

    relevant_compose_repeatable_flags=(
        "--file" "-f"
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
            if [[ -n "${relevant_compose_repeatable_flags[(r)$k]}"  ]]; then
                values=("${(@s/:/)opt_args[$k]}")
                for value in $values
                do
                    compose_options+=$k
                    compose_options+=$value
                done
            else
                compose_options+=$k
                if [[ -n "$opt_args[$k]" ]]; then
                    compose_options+=$opt_args[$k]
                fi
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

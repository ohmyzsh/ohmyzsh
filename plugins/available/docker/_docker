#compdef docker dockerd
#
# zsh completion for docker (http://docker.com)
#
# version:  0.3.0
# github:   https://github.com/felixr/docker-zsh-completion
#
# contributors:
#   - Felix Riedel
#   - Steve Durrheimer
#   - Vincent Bernat
#
# license:
#
# Copyright (c) 2013, Felix Riedel
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the <organization> nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# Short-option stacking can be enabled with:
#  zstyle ':completion:*:*:docker:*' option-stacking yes
#  zstyle ':completion:*:*:docker-*:*' option-stacking yes
__docker_arguments() {
    if zstyle -t ":completion:${curcontext}:" option-stacking; then
        print -- -s
    fi
}

__docker_get_containers() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    local kind type line s
    declare -a running stopped lines args names

    kind=$1; shift
    type=$1; shift
    [[ $kind = (stopped|all) ]] && args=($args -a)

    lines=(${(f)${:-"$(_call_program commands docker $docker_options ps --format 'table' --no-trunc $args)"$'\n'}})

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
    end[${header[$i,$((j-1))]}]=-1 # Last column, should go to the end of the line
    lines=(${lines[2,-1]})

    # Container ID
    if [[ $type = (ids|all) ]]; then
        for line in $lines; do
            s="${${line[${begin[CONTAINER ID]},${end[CONTAINER ID]}]%% ##}[0,12]}"
            s="$s:${(l:15:: :::)${${line[${begin[CREATED]},${end[CREATED]}]/ ago/}%% ##}}"
            s="$s, ${${${line[${begin[IMAGE]},${end[IMAGE]}]}/:/\\:}%% ##}"
            if [[ ${line[${begin[STATUS]},${end[STATUS]}]} = Exit* ]]; then
                stopped=($stopped $s)
            else
                running=($running $s)
            fi
        done
    fi

    # Names: we only display the one without slash. All other names
    # are generated and may clutter the completion. However, with
    # Swarm, all names may be prefixed by the swarm node name.
    if [[ $type = (names|all) ]]; then
        for line in $lines; do
            names=(${(ps:,:)${${line[${begin[NAMES]},${end[NAMES]}]}%% *}})
            # First step: find a common prefix and strip it (swarm node case)
            (( ${#${(u)names%%/*}} == 1 )) && names=${names#${names[1]%%/*}/}
            # Second step: only keep the first name without a /
            s=${${names:#*/*}[1]}
            # If no name, well give up.
            (( $#s != 0 )) || continue
            s="$s:${(l:15:: :::)${${line[${begin[CREATED]},${end[CREATED]}]/ ago/}%% ##}}"
            s="$s, ${${${line[${begin[IMAGE]},${end[IMAGE]}]}/:/\\:}%% ##}"
            if [[ ${line[${begin[STATUS]},${end[STATUS]}]} = Exit* ]]; then
                stopped=($stopped $s)
            else
                running=($running $s)
            fi
        done
    fi

    [[ $kind = (running|all) ]] && _describe -t containers-running "running containers" running "$@" && ret=0
    [[ $kind = (stopped|all) ]] && _describe -t containers-stopped "stopped containers" stopped "$@" && ret=0
    return ret
}

__docker_complete_stopped_containers() {
    [[ $PREFIX = -* ]] && return 1
    __docker_get_containers stopped all "$@"
}

__docker_complete_running_containers() {
    [[ $PREFIX = -* ]] && return 1
    __docker_get_containers running all "$@"
}

__docker_complete_containers() {
    [[ $PREFIX = -* ]] && return 1
    __docker_get_containers all all "$@"
}

__docker_complete_containers_ids() {
    [[ $PREFIX = -* ]] && return 1
    __docker_get_containers all ids "$@"
}

__docker_complete_containers_names() {
    [[ $PREFIX = -* ]] && return 1
    __docker_get_containers all names "$@"
}

__docker_complete_info_plugins() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    emulate -L zsh
    setopt extendedglob
    local -a plugins
    plugins=(${(ps: :)${(M)${(f)${${"$(_call_program commands docker $docker_options info)"##*$'\n'Plugins:}%%$'\n'^ *}}:# $1: *}## $1: })
    _describe -t plugins "$1 plugins" plugins && ret=0
    return ret
}

__docker_complete_images() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    declare -a images
    images=(${${${(f)${:-"$(_call_program commands docker $docker_options images)"$'\n'}}[2,-1]}/(#b)([^ ]##) ##([^ ]##) ##([^ ]##)*/${match[3]}:${(r:15:: :::)match[2]} in ${match[1]}})
    _describe -t docker-images "images" images && ret=0
    __docker_complete_repositories_with_tags && ret=0
    return ret
}

__docker_complete_repositories() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    declare -a repos
    repos=(${${${(f)${:-"$(_call_program commands docker $docker_options images)"$'\n'}}%% *}[2,-1]})
    repos=(${repos#<none>})
    _describe -t docker-repos "repositories" repos && ret=0
    return ret
}

__docker_complete_repositories_with_tags() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    declare -a repos onlyrepos matched
    declare m
    repos=(${${${${(f)${:-"$(_call_program commands docker $docker_options images)"$'\n'}}[2,-1]}/ ##/:::}%% *})
    repos=(${${repos%:::<none>}#<none>})
    # Check if we have a prefix-match for the current prefix.
    onlyrepos=(${repos%::*})
    for m in $onlyrepos; do
        [[ ${PREFIX##${~~m}} != ${PREFIX} ]] && {
            # Yes, complete with tags
            repos=(${${repos/:::/:}/:/\\:})
            _describe -t docker-repos-with-tags "repositories with tags" repos && ret=0
            return ret
        }
    done
    # No, only complete repositories
    onlyrepos=(${${repos%:::*}/:/\\:})
    _describe -t docker-repos "repositories" onlyrepos -qS : && ret=0

    return ret
}

__docker_search() {
    [[ $PREFIX = -* ]] && return 1
    local cache_policy
    zstyle -s ":completion:${curcontext}:" cache-policy cache_policy
    if [[ -z "$cache_policy" ]]; then
        zstyle ":completion:${curcontext}:" cache-policy __docker_caching_policy
    fi

    local searchterm cachename
    searchterm="${words[$CURRENT]%/}"
    cachename=_docker-search-$searchterm

    local expl
    local -a result
    if ( [[ ${(P)+cachename} -eq 0 ]] || _cache_invalid ${cachename#_} ) \
        && ! _retrieve_cache ${cachename#_}; then
        _message "Searching for ${searchterm}..."
        result=(${${${(f)${:-"$(_call_program commands docker $docker_options search $searchterm)"$'\n'}}%% *}[2,-1]})
        _store_cache ${cachename#_} result
    fi
    _wanted dockersearch expl 'available images' compadd -a result
}

__docker_get_log_options() {
    [[ $PREFIX = -* ]] && return 1

    integer ret=1
    local log_driver=${opt_args[--log-driver]:-"all"}
    local -a awslogs_options fluentd_options gelf_options journald_options json_file_options logentries_options syslog_options splunk_options

    awslogs_options=("awslogs-region" "awslogs-group" "awslogs-stream")
    fluentd_options=("env" "fluentd-address" "fluentd-async-connect" "fluentd-buffer-limit" "fluentd-retry-wait" "fluentd-max-retries" "labels" "tag")
    gcplogs_options=("env" "gcp-log-cmd" "gcp-project" "labels")
    gelf_options=("env" "gelf-address" "gelf-compression-level" "gelf-compression-type" "labels" "tag")
    journald_options=("env" "labels" "tag")
    json_file_options=("env" "labels" "max-file" "max-size")
    logentries_options=("logentries-token")
    syslog_options=("env" "labels" "syslog-address" "syslog-facility" "syslog-format" "syslog-tls-ca-cert" "syslog-tls-cert" "syslog-tls-key" "syslog-tls-skip-verify" "tag")
    splunk_options=("env" "labels" "splunk-caname" "splunk-capath" "splunk-format" "splunk-gzip" "splunk-gzip-level" "splunk-index" "splunk-insecureskipverify" "splunk-source" "splunk-sourcetype" "splunk-token" "splunk-url" "splunk-verify-connection" "tag")

    [[ $log_driver = (awslogs|all) ]] && _describe -t awslogs-options "awslogs options" awslogs_options "$@" && ret=0
    [[ $log_driver = (fluentd|all) ]] && _describe -t fluentd-options "fluentd options" fluentd_options "$@" && ret=0
    [[ $log_driver = (gcplogs|all) ]] && _describe -t gcplogs-options "gcplogs options" gcplogs_options "$@" && ret=0
    [[ $log_driver = (gelf|all) ]] && _describe -t gelf-options "gelf options" gelf_options "$@" && ret=0
    [[ $log_driver = (journald|all) ]] && _describe -t journald-options "journald options" journald_options "$@" && ret=0
    [[ $log_driver = (json-file|all) ]] && _describe -t json-file-options "json-file options" json_file_options "$@" && ret=0
    [[ $log_driver = (logentries|all) ]] && _describe -t logentries-options "logentries options" logentries_options "$@" && ret=0
    [[ $log_driver = (syslog|all) ]] && _describe -t syslog-options "syslog options" syslog_options "$@" && ret=0
    [[ $log_driver = (splunk|all) ]] && _describe -t splunk-options "splunk options" splunk_options "$@" && ret=0

    return ret
}

__docker_complete_log_drivers() {
    [[ $PREFIX = -*  ]] && return 1
    integer ret=1
    drivers=(awslogs etwlogs fluentd gcplogs gelf journald json-file none splunk syslog)
    _describe -t log-drivers "log drivers" drivers && ret=0
    return ret
}

__docker_complete_log_options() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1

    if compset -P '*='; then
        case "${${words[-1]%=*}#*=}" in
            (syslog-format)
                syslog_format_opts=('rfc3164' 'rfc5424' 'rfc5424micro')
                _describe -t syslog-format-opts "Syslog format Options" syslog_format_opts && ret=0
                ;;
            *)
                _message 'value' && ret=0
                ;;
        esac
    else
        __docker_get_log_options -qS "=" && ret=0
    fi

    return ret
}

__docker_complete_detach_keys() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1

    compset -P "*,"
    keys=(${:-{a-z}})
    ctrl_keys=(${:-ctrl-{{a-z},{@,'[','\\','^',']',_}}})
    _describe -t detach_keys "[a-z]" keys -qS "," && ret=0
    _describe -t detach_keys-ctrl "'ctrl-' + 'a-z @ [ \\\\ ] ^ _'" ctrl_keys -qS "," && ret=0
}

__docker_complete_pid() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    local -a opts vopts

    opts=('host')
    vopts=('container')

    if compset -P '*:'; then
        case "${${words[-1]%:*}#*=}" in
            (container)
                __docker_complete_running_containers && ret=0
                ;;
            *)
                _message 'value' && ret=0
                ;;
        esac
    else
        _describe -t pid-value-opts "PID Options with value" vopts -qS ":" && ret=0
        _describe -t pid-opts "PID Options" opts && ret=0
    fi

    return ret
}

__docker_complete_runtimes() {
    [[ $PREFIX = -*  ]] && return 1
    integer ret=1

    emulate -L zsh
    setopt extendedglob
    local -a runtimes_opts
    runtimes_opts=(${(ps: :)${(f)${${"$(_call_program commands docker $docker_options info)"##*$'\n'Runtimes: }%%$'\n'^ *}}})
    _describe -t runtimes-opts "runtimes options" runtimes_opts && ret=0
}

__docker_complete_ps_filters() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1

    if compset -P '*='; then
        case "${${words[-1]%=*}#*=}" in
            (ancestor)
                __docker_complete_images && ret=0
                ;;
            (before|since)
                __docker_complete_containers && ret=0
                ;;
            (health)
                health_opts=('healthy' 'none' 'starting' 'unhealthy')
                _describe -t health-filter-opts "health filter options" health_opts && ret=0
                ;;
            (id)
                __docker_complete_containers_ids && ret=0
                ;;
            (is-task)
                _describe -t boolean-filter-opts "filter options" boolean_opts && ret=0
                ;;
            (name)
                __docker_complete_containers_names && ret=0
                ;;
            (network)
                __docker_complete_networks && ret=0
                ;;
            (status)
                status_opts=('created' 'dead' 'exited' 'paused' 'restarting' 'running' 'removing')
                _describe -t status-filter-opts "status filter options" status_opts && ret=0
                ;;
            (volume)
                __docker_complete_volumes && ret=0
                ;;
            *)
                _message 'value' && ret=0
                ;;
        esac
    else
        opts=('ancestor' 'before' 'exited' 'health' 'id' 'label' 'name' 'network' 'since' 'status' 'volume')
        _describe -t filter-opts "Filter Options" opts -qS "=" && ret=0
    fi

    return ret
}

__docker_complete_search_filters() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    declare -a boolean_opts opts

    boolean_opts=('true' 'false')
    opts=('is-automated' 'is-official' 'stars')

    if compset -P '*='; then
        case "${${words[-1]%=*}#*=}" in
            (is-automated|is-official)
                _describe -t boolean-filter-opts "filter options" boolean_opts && ret=0
                ;;
            *)
                _message 'value' && ret=0
                ;;
        esac
    else
        _describe -t filter-opts "filter options" opts -qS "=" && ret=0
    fi

    return ret
}

__docker_complete_images_filters() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    declare -a boolean_opts opts

    boolean_opts=('true' 'false')
    opts=('before' 'dangling' 'label' 'reference' 'since')

    if compset -P '*='; then
        case "${${words[-1]%=*}#*=}" in
            (before|reference|since)
                __docker_complete_images && ret=0
                ;;
            (dangling)
                _describe -t boolean-filter-opts "filter options" boolean_opts && ret=0
                ;;
            *)
                _message 'value' && ret=0
                ;;
        esac
    else
        _describe -t filter-opts "Filter Options" opts -qS "=" && ret=0
    fi

    return ret
}

__docker_complete_events_filter() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    declare -a opts

    opts=('container' 'daemon' 'event' 'image' 'label' 'network' 'type' 'volume')

    if compset -P '*='; then
        case "${${words[-1]%=*}#*=}" in
            (container)
                __docker_complete_containers && ret=0
                ;;
            (daemon)
                emulate -L zsh
                setopt extendedglob
                local -a daemon_opts
                daemon_opts=(
                    ${(f)${${"$(_call_program commands docker $docker_options info)"##*$'\n'Name: }%%$'\n'^ *}}
                    ${${(f)${${"$(_call_program commands docker $docker_options info)"##*$'\n'ID: }%%$'\n'^ *}}//:/\\:}
                )
                _describe -t daemon-filter-opts "daemon filter options" daemon_opts && ret=0
                ;;
            (event)
                local -a event_opts
                event_opts=('attach' 'commit' 'connect' 'copy' 'create' 'delete' 'destroy' 'detach' 'die' 'disconnect' 'exec_create' 'exec_detach'
                'exec_start' 'export' 'health_status' 'import' 'kill' 'load'  'mount' 'oom' 'pause' 'pull' 'push' 'reload' 'rename' 'resize' 'restart' 'save' 'start'
                'stop' 'tag' 'top' 'unmount' 'unpause' 'untag' 'update')
                _describe -t event-filter-opts "event filter options" event_opts && ret=0
                ;;
            (image)
                __docker_complete_images && ret=0
                ;;
            (network)
                __docker_complete_networks && ret=0
                ;;
            (type)
                local -a type_opts
                type_opts=('container' 'daemon' 'image' 'network' 'volume')
                _describe -t type-filter-opts "type filter options" type_opts && ret=0
                ;;
            (volume)
                __docker_complete_volumes && ret=0
                ;;
            *)
                _message 'value' && ret=0
                ;;
        esac
    else
        _describe -t filter-opts "filter options" opts -qS "=" && ret=0
    fi

    return ret
}

# BO container

__docker_container_commands() {
    local -a _docker_container_subcommands
    _docker_container_subcommands=(
        "attach:Attach to a running container"
        "commit:Create a new image from a container's changes"
        "cp:Copy files/folders between a container and the local filesystem"
        "create:Create a new container"
        "diff:Inspect changes on a container's filesystem"
        "exec:Run a command in a running container"
        "export:Export a container's filesystem as a tar archive"
        "inspect:Display detailed information on one or more containers"
        "kill:Kill one or more running containers"
        "logs:Fetch the logs of a container"
        "ls:List containers"
        "pause:Pause all processes within one or more containers"
        "port:List port mappings or a specific mapping for the container"
        "prune:Remove all stopped containers"
        "rename:Rename a container"
        "restart:Restart one or more containers"
        "rm:Remove one or more containers"
        "run:Run a command in a new container"
        "start:Start one or more stopped containers"
        "stats:Display a live stream of container(s) resource usage statistics"
        "stop:Stop one or more running containers"
        "top:Display the running processes of a container"
        "unpause:Unpause all processes within one or more containers"
        "update:Update configuration of one or more containers"
        "wait:Block until one or more containers stop, then print their exit codes"
    )
    _describe -t docker-container-commands "docker container command" _docker_container_subcommands
}

__docker_container_subcommand() {
    local -a _command_args opts_help opts_attach_exec_run_start opts_create_run opts_create_run_update
    local expl help="--help"
    integer ret=1

    opts_attach_exec_run_start=(
        "($help)--detach-keys=[Escape key sequence used to detach a container]:sequence:__docker_complete_detach_keys"
    )
    opts_create_run=(
        "($help -a --attach)"{-a=,--attach=}"[Attach to stdin, stdout or stderr]:device:(STDIN STDOUT STDERR)"
        "($help)*--add-host=[Add a custom host-to-IP mapping]:host\:ip mapping: "
        "($help)*--blkio-weight-device=[Block IO (relative device weight)]:device:Block IO weight: "
        "($help)*--cap-add=[Add Linux capabilities]:capability: "
        "($help)*--cap-drop=[Drop Linux capabilities]:capability: "
        "($help)--cgroup-parent=[Parent cgroup for the container]:cgroup: "
        "($help)--cidfile=[Write the container ID to the file]:CID file:_files"
        "($help)--cpus=[Number of CPUs (default 0.000)]:cpus: "
        "($help)*--device=[Add a host device to the container]:device:_files"
        "($help)*--device-read-bps=[Limit the read rate (bytes per second) from a device]:device:IO rate: "
        "($help)*--device-read-iops=[Limit the read rate (IO per second) from a device]:device:IO rate: "
        "($help)*--device-write-bps=[Limit the write rate (bytes per second) to a device]:device:IO rate: "
        "($help)*--device-write-iops=[Limit the write rate (IO per second) to a device]:device:IO rate: "
        "($help)--disable-content-trust[Skip image verification]"
        "($help)*--dns=[Custom DNS servers]:DNS server: "
        "($help)*--dns-option=[Custom DNS options]:DNS option: "
        "($help)*--dns-search=[Custom DNS search domains]:DNS domains: "
        "($help)*"{-e=,--env=}"[Environment variables]:environment variable: "
        "($help)--entrypoint=[Overwrite the default entrypoint of the image]:entry point: "
        "($help)*--env-file=[Read environment variables from a file]:environment file:_files"
        "($help)*--expose=[Expose a port from the container without publishing it]: "
        "($help)*--group=[Set one or more supplementary user groups for the container]:group:_groups"
        "($help -h --hostname)"{-h=,--hostname=}"[Container host name]:hostname:_hosts"
        "($help -i --interactive)"{-i,--interactive}"[Keep stdin open even if not attached]"
        "($help)--ip=[Container IPv4 address]:IPv4: "
        "($help)--ip6=[Container IPv6 address]:IPv6: "
        "($help)--ipc=[IPC namespace to use]:IPC namespace: "
        "($help)--isolation=[Container isolation technology]:isolation:(default hyperv process)"
        "($help)*--link=[Add link to another container]:link:->link"
        "($help)*--link-local-ip=[Add a link-local address for the container]:IPv4/IPv6: "
        "($help)*"{-l=,--label=}"[Container metadata]:label: "
        "($help)--log-driver=[Default driver for container logs]:logging driver:__docker_complete_log_drivers"
        "($help)*--log-opt=[Log driver specific options]:log driver options:__docker_complete_log_options"
        "($help)--mac-address=[Container MAC address]:MAC address: "
        "($help)--name=[Container name]:name: "
        "($help)--network=[Connect a container to a network]:network mode:(bridge none container host)"
        "($help)*--network-alias=[Add network-scoped alias for the container]:alias: "
        "($help)--oom-kill-disable[Disable OOM Killer]"
        "($help)--oom-score-adj[Tune the host's OOM preferences for containers (accepts -1000 to 1000)]"
        "($help)--pids-limit[Tune container pids limit (set -1 for unlimited)]"
        "($help -P --publish-all)"{-P,--publish-all}"[Publish all exposed ports]"
        "($help)*"{-p=,--publish=}"[Expose a container's port to the host]:port:_ports"
        "($help)--pid=[PID namespace to use]:PID namespace:__docker_complete_pid"
        "($help)--privileged[Give extended privileges to this container]"
        "($help)--read-only[Mount the container's root filesystem as read only]"
        "($help)*--security-opt=[Security options]:security option: "
        "($help)*--shm-size=[Size of '/dev/shm' (format is '<number><unit>')]:shm size: "
        "($help)--stop-timeout=[Timeout (in seconds) to stop a container]:time: "
        "($help)*--sysctl=-[sysctl options]:sysctl: "
        "($help -t --tty)"{-t,--tty}"[Allocate a pseudo-tty]"
        "($help -u --user)"{-u=,--user=}"[Username or UID]:user:_users"
        "($help)*--ulimit=[ulimit options]:ulimit: "
        "($help)--userns=[Container user namespace]:user namespace:(host)"
        "($help)--tmpfs[mount tmpfs]"
        "($help)*-v[Bind mount a volume]:volume: "
        "($help)--volume-driver=[Optional volume driver for the container]:volume driver:(local)"
        "($help)*--volumes-from=[Mount volumes from the specified container]:volume: "
        "($help -w --workdir)"{-w=,--workdir=}"[Working directory inside the container]:directory:_directories"
    )
    opts_create_run_update=(
        "($help)--blkio-weight=[Block IO (relative weight), between 10 and 1000]:Block IO weight:(10 100 500 1000)"
        "($help -c --cpu-shares)"{-c=,--cpu-shares=}"[CPU shares (relative weight)]:CPU shares:(0 10 100 200 500 800 1000)"
        "($help)--cpu-period=[Limit the CPU CFS (Completely Fair Scheduler) period]:CPU period: "
        "($help)--cpu-quota=[Limit the CPU CFS (Completely Fair Scheduler) quota]:CPU quota: "
        "($help)--cpu-rt-period=[Limit the CPU real-time period]:CPU real-time period in microseconds: "
        "($help)--cpu-rt-runtime=[Limit the CPU real-time runtime]:CPU real-time runtime in microseconds: "
        "($help)--cpuset-cpus=[CPUs in which to allow execution]:CPUs: "
        "($help)--cpuset-mems=[MEMs in which to allow execution]:MEMs: "
        "($help)--kernel-memory=[Kernel memory limit in bytes]:Memory limit: "
        "($help -m --memory)"{-m=,--memory=}"[Memory limit]:Memory limit: "
        "($help)--memory-reservation=[Memory soft limit]:Memory limit: "
        "($help)--memory-swap=[Total memory limit with swap]:Memory limit: "
        "($help)--restart=[Restart policy]:restart policy:(no on-failure always unless-stopped)"
    )
    opts_help=("(: -)--help[Print usage]")

    case "$words[1]" in
        (attach)
            _arguments $(__docker_arguments) \
                $opts_help \
                $opts_attach_exec_run_start \
                "($help)--no-stdin[Do not attach stdin]" \
                "($help)--sig-proxy[Proxy all received signals to the process (non-TTY mode only)]" \
                "($help -):containers:__docker_complete_running_containers" && ret=0
            ;;
        (commit)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -a --author)"{-a=,--author=}"[Author]:author: " \
                "($help)*"{-c=,--change=}"[Apply Dockerfile instruction to the created image]:Dockerfile:_files" \
                "($help -m --message)"{-m=,--message=}"[Commit message]:message: " \
                "($help -p --pause)"{-p,--pause}"[Pause container during commit]" \
                "($help -):container:__docker_complete_containers" \
                "($help -): :__docker_complete_repositories_with_tags" && ret=0
            ;;
        (cp)
            local state
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -L --follow-link)"{-L,--follow-link}"[Always follow symbol link]" \
                "($help -)1:container:->container" \
                "($help -)2:hostpath:_files" && ret=0
            case $state in
                (container)
                    if compset -P "*:"; then
                        _files && ret=0
                    else
                        __docker_complete_containers -qS ":" && ret=0
                    fi
                    ;;
            esac
            ;;
        (create)
            local state
            _arguments $(__docker_arguments) \
                $opts_help \
                $opts_create_run \
                $opts_create_run_update \
                "($help -): :__docker_complete_images" \
                "($help -):command: _command_names -e" \
                "($help -)*::arguments: _normal" && ret=0
            case $state in
                (link)
                    if compset -P "*:"; then
                        _wanted alias expl "Alias" compadd -E "" && ret=0
                    else
                        __docker_complete_running_containers -qS ":" && ret=0
                    fi
                    ;;
            esac
            ;;
        (diff)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -)*:containers:__docker_complete_containers" && ret=0
            ;;
        (exec)
            local state
            _arguments $(__docker_arguments) \
                $opts_help \
                $opts_attach_exec_run_start \
                "($help -d --detach)"{-d,--detach}"[Detached mode: leave the container running in the background]" \
                "($help)*"{-e=,--env=}"[Set environment variables]:environment variable: " \
                "($help -i --interactive)"{-i,--interactive}"[Keep stdin open even if not attached]" \
                "($help)--privileged[Give extended Linux capabilities to the command]" \
                "($help -t --tty)"{-t,--tty}"[Allocate a pseudo-tty]" \
                "($help -u --user)"{-u=,--user=}"[Username or UID]:user:_users" \
                "($help -):containers:__docker_complete_running_containers" \
                "($help -)*::command:->anycommand" && ret=0
            case $state in
                (anycommand)
                    shift 1 words
                    (( CURRENT-- ))
                    _normal && ret=0
                    ;;
            esac
            ;;
        (export)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -o --output)"{-o=,--output=}"[Write to a file, instead of stdout]:output file:_files" \
                "($help -)*:containers:__docker_complete_containers" && ret=0
            ;;
        (inspect)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -f --format)"{-f=,--format=}"[Format the output using the given go template]:template: " \
                "($help -s --size)"{-s,--size}"[Display total file sizes]" \
                "($help -)*:containers:__docker_complete_containers" && ret=0
            ;;
        (kill)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -s --signal)"{-s=,--signal=}"[Signal to send]:signal:_signals" \
                "($help -)*:containers:__docker_complete_running_containers" && ret=0
            ;;
        (logs)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)--details[Show extra details provided to logs]" \
                "($help -f --follow)"{-f,--follow}"[Follow log output]" \
                "($help -s --since)"{-s=,--since=}"[Show logs since this timestamp]:timestamp: " \
                "($help -t --timestamps)"{-t,--timestamps}"[Show timestamps]" \
                "($help)--tail=[Output the last K lines]:lines:(1 10 20 50 all)" \
                "($help -)*:containers:__docker_complete_containers" && ret=0
            ;;
        (ls|list)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -a --all)"{-a,--all}"[Show all containers]" \
                "($help)--before=[Show only container created before...]:containers:__docker_complete_containers" \
                "($help)*"{-f=,--filter=}"[Filter values]:filter:__docker_complete_ps_filters" \
                "($help)--format=[Pretty-print containers using a Go template]:template: " \
                "($help -l --latest)"{-l,--latest}"[Show only the latest created container]" \
                "($help -n --last)"{-n=,--last=}"[Show n last created containers (includes all states)]:n:(1 5 10 25 50)" \
                "($help)--no-trunc[Do not truncate output]" \
                "($help -q --quiet)"{-q,--quiet}"[Only show numeric IDs]" \
                "($help -s --size)"{-s,--size}"[Display total file sizes]" \
                "($help)--since=[Show only containers created since...]:containers:__docker_complete_containers" && ret=0
            ;;
        (pause|unpause)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -)*:containers:__docker_complete_running_containers" && ret=0
            ;;
        (port)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -)1:containers:__docker_complete_running_containers" \
                "($help -)2:port:_ports" && ret=0
            ;;
        (prune)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -f --force)"{-f,--force}"[Do not prompt for confirmation]" && ret=0
            ;;
        (rename)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -):old name:__docker_complete_containers" \
                "($help -):new name: " && ret=0
            ;;
        (restart)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -t --time)"{-t=,--time=}"[Number of seconds to try to stop for before killing the container]:seconds to before killing:(1 5 10 30 60)" \
                "($help -)*:containers:__docker_complete_containers_ids" && ret=0
            ;;
        (rm)
            local state
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -f --force)"{-f,--force}"[Force removal]" \
                "($help -l --link)"{-l,--link}"[Remove the specified link and not the underlying container]" \
                "($help -v --volumes)"{-v,--volumes}"[Remove the volumes associated to the container]" \
                "($help -)*:containers:->values" && ret=0
            case $state in
                (values)
                    if [[ ${words[(r)-f]} == -f || ${words[(r)--force]} == --force ]]; then
                        __docker_complete_containers && ret=0
                    else
                        __docker_complete_stopped_containers && ret=0
                    fi
                    ;;
            esac
            ;;
        (run)
            local state
            _arguments $(__docker_arguments) \
                $opts_help \
                $opts_create_run \
                $opts_create_run_update \
                $opts_attach_exec_run_start \
                "($help -d --detach)"{-d,--detach}"[Detached mode: leave the container running in the background]" \
                "($help)--health-cmd=[Command to run to check health]:command: " \
                "($help)--health-interval=[Time between running the check]:time: " \
                "($help)--health-retries=[Consecutive failures needed to report unhealthy]:retries:(1 2 3 4 5)" \
                "($help)--health-timeout=[Maximum time to allow one check to run]:time: " \
                "($help)--no-healthcheck[Disable any container-specified HEALTHCHECK]" \
                "($help)--rm[Remove intermediate containers when it exits]" \
                "($help)--runtime=[Name of the runtime to be used for that container]:runtime:__docker_complete_runtimes" \
                "($help)--sig-proxy[Proxy all received signals to the process (non-TTY mode only)]" \
                "($help)--stop-signal=[Signal to kill a container]:signal:_signals" \
                "($help)--storage-opt=[Storage driver options for the container]:storage options:->storage-opt" \
                "($help -): :__docker_complete_images" \
                "($help -):command: _command_names -e" \
                "($help -)*::arguments: _normal" && ret=0
            case $state in
                (link)
                    if compset -P "*:"; then
                        _wanted alias expl "Alias" compadd -E "" && ret=0
                    else
                        __docker_complete_running_containers -qS ":" && ret=0
                    fi
                    ;;
                (storage-opt)
                    if compset -P "*="; then
                        _message "value" && ret=0
                    else
                        opts=('size')
                        _describe -t filter-opts "storage options" opts -qS "=" && ret=0
                    fi
                    ;;
            esac
            ;;
        (start)
            _arguments $(__docker_arguments) \
                $opts_help \
                $opts_attach_exec_run_start \
                "($help -a --attach)"{-a,--attach}"[Attach container's stdout/stderr and forward all signals]" \
                "($help -i --interactive)"{-i,--interactive}"[Attach container's stding]" \
                "($help -)*:containers:__docker_complete_stopped_containers" && ret=0
            ;;
        (stats)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -a --all)"{-a,--all}"[Show all containers (default shows just running)]" \
                "($help)--format=[Pretty-print images using a Go template]:template: " \
                "($help)--no-stream[Disable streaming stats and only pull the first result]" \
                "($help -)*:containers:__docker_complete_running_containers" && ret=0
            ;;
        (stop)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -t --time)"{-t=,--time=}"[Number of seconds to try to stop for before killing the container]:seconds to before killing:(1 5 10 30 60)" \
                "($help -)*:containers:__docker_complete_running_containers" && ret=0
            ;;
        (top)
            local state
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -)1:containers:__docker_complete_running_containers" \
                "($help -)*:: :->ps-arguments" && ret=0
            case $state in
                (ps-arguments)
                    _ps && ret=0
                    ;;
            esac
            ;;
        (update)
            local state
            _arguments $(__docker_arguments) \
                $opts_help \
                opts_create_run_update \
                "($help -)*: :->values" && ret=0
            case $state in
                (values)
                    if [[ ${words[(r)--kernel-memory*]} = (--kernel-memory*) ]]; then
                        __docker_complete_stopped_containers && ret=0
                    else
                        __docker_complete_containers && ret=0
                    fi
                    ;;
            esac
            ;;
        (wait)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -)*:containers:__docker_complete_running_containers" && ret=0
            ;;
        (help)
            _arguments $(__docker_arguments) ":subcommand:__docker_container_commands" && ret=0
            ;;
    esac

    return ret
}

# EO container

# BO image

__docker_image_commands() {
    local -a _docker_image_subcommands
    _docker_image_subcommands=(
        "build:Build an image from a Dockerfile"
        "history:Show the history of an image"
        "import:Import the contents from a tarball to create a filesystem image"
        "inspect:Display detailed information on one or more images"
        "load:Load an image from a tar archive or STDIN"
        "ls:List images"
        "prune:Remove unused images"
        "pull:Pull an image or a repository from a registry"
        "push:Push an image or a repository to a registry"
        "rm:Remove one or more images"
        "save:Save one or more images to a tar archive (streamed to STDOUT by default)"
        "tag:Tag an image into a repository"
    )
    _describe -t docker-image-commands "docker image command" _docker_image_subcommands
}

__docker_image_subcommand() {
    local -a _command_args opts_help
    local expl help="--help"
    integer ret=1

    opts_help=("(: -)--help[Print usage]")

    case "$words[1]" in
        (build)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)*--build-arg=[Build-time variables]:<varname>=<value>: " \
                "($help)*--cache-from=[Images to consider as cache sources]: :__docker_complete_repositories_with_tags" \
                "($help -c --cpu-shares)"{-c=,--cpu-shares=}"[CPU shares (relative weight)]:CPU shares:(0 10 100 200 500 800 1000)" \
                "($help)--cgroup-parent=[Parent cgroup for the container]:cgroup: " \
                "($help)--compress[Compress the build context using gzip]" \
                "($help)--cpu-period=[Limit the CPU CFS (Completely Fair Scheduler) period]:CPU period: " \
                "($help)--cpu-quota=[Limit the CPU CFS (Completely Fair Scheduler) quota]:CPU quota: " \
                "($help)--cpu-rt-period=[Limit the CPU real-time period]:CPU real-time period in microseconds: " \
                "($help)--cpu-rt-runtime=[Limit the CPU real-time runtime]:CPU real-time runtime in microseconds: " \
                "($help)--cpuset-cpus=[CPUs in which to allow execution]:CPUs: " \
                "($help)--cpuset-mems=[MEMs in which to allow execution]:MEMs: " \
                "($help)--disable-content-trust[Skip image verification]" \
                "($help -f --file)"{-f=,--file=}"[Name of the Dockerfile]:Dockerfile:_files" \
                "($help)--force-rm[Always remove intermediate containers]" \
                "($help)--isolation=[Container isolation technology]:isolation:(default hyperv process)" \
                "($help)*--label=[Set metadata for an image]:label=value: " \
                "($help -m --memory)"{-m=,--memory=}"[Memory limit]:Memory limit: " \
                "($help)--memory-swap=[Total memory limit with swap]:Memory limit: " \
                "($help)--network=[Connect a container to a network]:network mode:(bridge none container host)"
                "($help)--no-cache[Do not use cache when building the image]" \
                "($help)--pull[Attempt to pull a newer version of the image]" \
                "($help -q --quiet)"{-q,--quiet}"[Suppress verbose build output]" \
                "($help)--rm[Remove intermediate containers after a successful build]" \
                "($help)*--shm-size=[Size of '/dev/shm' (format is '<number><unit>')]:shm size: " \
                "($help -t --tag)*"{-t=,--tag=}"[Repository, name and tag for the image]: :__docker_complete_repositories_with_tags" \
                "($help)*--ulimit=[ulimit options]:ulimit: " \
                "($help)--userns=[Container user namespace]:user namespace:(host)" \
                "($help -):path or URL:_directories" && ret=0
            ;;
        (history)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -H --human)"{-H,--human}"[Print sizes and dates in human readable format]" \
                "($help)--no-trunc[Do not truncate output]" \
                "($help -q --quiet)"{-q,--quiet}"[Only show numeric IDs]" \
                "($help -)*: :__docker_complete_images" && ret=0
            ;;
        (import)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)*"{-c=,--change=}"[Apply Dockerfile instruction to the created image]:Dockerfile:_files" \
                "($help -m --message)"{-m=,--message=}"[Commit message for imported image]:message: " \
                "($help -):URL:(- http:// file://)" \
                "($help -): :__docker_complete_repositories_with_tags" && ret=0
            ;;
        (inspect)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -f --format)"{-f=,--format=}"[Format the output using the given go template]:template: " \
                "($help -)*:images:__docker_complete_images" && ret=0
            ;;
        (load)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -i --input)"{-i=,--input=}"[Read from tar archive file]:archive file:_files -g \"*.((tar|TAR)(.gz|.GZ|.Z|.bz2|.lzma|.xz|)|(tbz|tgz|txz))(-.)\"" \
                "($help -q --quiet)"{-q,--quiet}"[Suppress the load output]" && ret=0
            ;;
        (ls|list)
            local state
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -a --all)"{-a,--all}"[Show all images]" \
                "($help)--digests[Show digests]" \
                "($help)*"{-f=,--filter=}"[Filter values]:filter:->filter-options" \
                "($help)--format=[Pretty-print images using a Go template]:template: " \
                "($help)--no-trunc[Do not truncate output]" \
                "($help -q --quiet)"{-q,--quiet}"[Only show numeric IDs]" \
                "($help -): :__docker_complete_repositories" && ret=0
            case $state in
                (filter-options)
                    __docker_complete_images_filters && ret=0
                    ;;
            esac
            ;;
        (prune)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -a --all)"{-a,--all}"[Remove all unused images, not just dangling ones]" \
                "($help -f --force)"{-f,--force}"[Do not prompt for confirmation]" && ret=0
            ;;
        (pull)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -a --all-tags)"{-a,--all-tags}"[Download all tagged images]" \
                "($help)--disable-content-trust[Skip image verification]" \
                "($help -):name:__docker_search" && ret=0
            ;;
        (push)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)--disable-content-trust[Skip image signing]" \
                "($help -): :__docker_complete_images" && ret=0
            ;;
        (rm)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -f --force)"{-f,--force}"[Force removal]" \
                "($help)--no-prune[Do not delete untagged parents]" \
                "($help -)*: :__docker_complete_images" && ret=0
            ;;
        (save)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -o --output)"{-o=,--output=}"[Write to file]:file:_files" \
                "($help -)*: :__docker_complete_images" && ret=0
            ;;
        (tag)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -):source:__docker_complete_images"\
                "($help -):destination:__docker_complete_repositories_with_tags" && ret=0
            ;;
        (help)
            _arguments $(__docker_arguments) ":subcommand:__docker_container_commands" && ret=0
            ;;
    esac

    return ret
}

# EO image

# BO network

__docker_network_complete_ls_filters() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1

    if compset -P '*='; then
        case "${${words[-1]%=*}#*=}" in
            (driver)
                __docker_complete_info_plugins Network && ret=0
                ;;
            (id)
                __docker_complete_networks_ids && ret=0
                ;;
            (name)
                __docker_complete_networks_names && ret=0
                ;;
            (type)
                type_opts=('builtin' 'custom')
                _describe -t type-filter-opts "Type Filter Options" type_opts && ret=0
                ;;
            *)
                _message 'value' && ret=0
                ;;
        esac
    else
        opts=('driver' 'id' 'label' 'name' 'type')
        _describe -t filter-opts "Filter Options" opts -qS "=" && ret=0
    fi

    return ret
}

__docker_get_networks() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    local line s
    declare -a lines networks

    type=$1; shift

    lines=(${(f)${:-"$(_call_program commands docker $docker_options network ls)"$'\n'}})

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
    end[${header[$i,$((j-1))]}]=-1
    lines=(${lines[2,-1]})

    # Network ID
    if [[ $type = (ids|all) ]]; then
        for line in $lines; do
            s="${line[${begin[NETWORK ID]},${end[NETWORK ID]}]%% ##}"
            s="$s:${(l:7:: :::)${${line[${begin[DRIVER]},${end[DRIVER]}]}%% ##}}"
            s="$s, ${${line[${begin[SCOPE]},${end[SCOPE]}]}%% ##}"
            networks=($networks $s)
        done
    fi

    # Names
    if [[ $type = (names|all) ]]; then
        for line in $lines; do
            s="${line[${begin[NAME]},${end[NAME]}]%% ##}"
            s="$s:${(l:7:: :::)${${line[${begin[DRIVER]},${end[DRIVER]}]}%% ##}}"
            s="$s, ${${line[${begin[SCOPE]},${end[SCOPE]}]}%% ##}"
            networks=($networks $s)
        done
    fi

    _describe -t networks-list "networks" networks "$@" && ret=0
    return ret
}

__docker_complete_networks() {
    [[ $PREFIX = -* ]] && return 1
    __docker_get_networks all "$@"
}

__docker_complete_networks_ids() {
    [[ $PREFIX = -* ]] && return 1
    __docker_get_networks ids "$@"
}

__docker_complete_networks_names() {
    [[ $PREFIX = -* ]] && return 1
    __docker_get_networks names "$@"
}

__docker_network_commands() {
    local -a _docker_network_subcommands
    _docker_network_subcommands=(
        "connect:Connect a container to a network"
        "create:Creates a new network with a name specified by the user"
        "disconnect:Disconnects a container from a network"
        "inspect:Displays detailed information on a network"
        "ls:Lists all the networks created by the user"
        "prune:Remove all unused networks"
        "rm:Deletes one or more networks"
    )
    _describe -t docker-network-commands "docker network command" _docker_network_subcommands
}

__docker_network_subcommand() {
    local -a _command_args opts_help
    local expl help="--help"
    integer ret=1

    opts_help=("(: -)--help[Print usage]")

    case "$words[1]" in
        (connect)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)*--alias=[Add network-scoped alias for the container]:alias: " \
                "($help)--ip=[Container IPv4 address]:IPv4: " \
                "($help)--ip6=[Container IPv6 address]:IPv6: " \
                "($help)*--link=[Add a link to another container]:link:->link" \
                "($help)*--link-local-ip=[Add a link-local address for the container]:IPv4/IPv6: " \
                "($help -)1:network:__docker_complete_networks" \
                "($help -)2:containers:__docker_complete_containers" && ret=0

            case $state in
                (link)
                    if compset -P "*:"; then
                        _wanted alias expl "Alias" compadd -E "" && ret=0
                    else
                        __docker_complete_running_containers -qS ":" && ret=0
                    fi
                    ;;
            esac
            ;;
        (create)
            _arguments $(__docker_arguments) -A '-*' \
                $opts_help \
                "($help)--attachable[Enable manual container attachment]" \
                "($help)*--aux-address[Auxiliary IPv4 or IPv6 addresses used by network driver]:key=IP: " \
                "($help -d --driver)"{-d=,--driver=}"[Driver to manage the Network]:driver:(null host bridge overlay)" \
                "($help)*--gateway=[IPv4 or IPv6 Gateway for the master subnet]:IP: " \
                "($help)--internal[Restricts external access to the network]" \
                "($help)*--ip-range=[Allocate container ip from a sub-range]:IP/mask: " \
                "($help)--ipam-driver=[IP Address Management Driver]:driver:(default)" \
                "($help)*--ipam-opt=[Custom IPAM plugin options]:opt=value: " \
                "($help)--ipv6[Enable IPv6 networking]" \
                "($help)*--label=[Set metadata on a network]:label=value: " \
                "($help)*"{-o=,--opt=}"[Driver specific options]:opt=value: " \
                "($help)*--subnet=[Subnet in CIDR format that represents a network segment]:IP/mask: " \
                "($help -)1:Network Name: " && ret=0
            ;;
        (disconnect)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -)1:network:__docker_complete_networks" \
                "($help -)2:containers:__docker_complete_containers" && ret=0
            ;;
        (inspect)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -f --format)"{-f=,--format=}"[Format the output using the given go template]:template: " \
                "($help -)*:network:__docker_complete_networks" && ret=0
            ;;
        (ls)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)--no-trunc[Do not truncate the output]" \
                "($help)*"{-f=,--filter=}"[Provide filter values]:filter:->filter-options" \
                "($help)--format=[Pretty-print networks using a Go template]:template: " \
                "($help -q --quiet)"{-q,--quiet}"[Only display numeric IDs]" && ret=0
            case $state in
                (filter-options)
                    __docker_network_complete_ls_filters && ret=0
                    ;;
            esac
            ;;
        (prune)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -f --force)"{-f,--force}"[Do not prompt for confirmation]" && ret=0
            ;;
        (rm)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -)*:network:__docker_complete_networks" && ret=0
            ;;
        (help)
            _arguments $(__docker_arguments) ":subcommand:__docker_network_commands" && ret=0
            ;;
    esac

    return ret
}

# EO network

# BO node

__docker_node_complete_ls_filters() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1

    if compset -P '*='; then
        case "${${words[-1]%=*}#*=}" in
            (id)
                __docker_complete_nodes_ids && ret=0
                ;;
            (membership)
                membership_opts=('accepted' 'pending' 'rejected')
                _describe -t membership-opts "membership options" membership_opts && ret=0
                ;;
            (name)
                __docker_complete_nodes_names && ret=0
                ;;
            (role)
                role_opts=('manager' 'worker')
                _describe -t role-opts "role options" role_opts && ret=0
                ;;
            *)
                _message 'value' && ret=0
                ;;
        esac
    else
        opts=('id' 'label' 'membership' 'name' 'role')
        _describe -t filter-opts "filter options" opts -qS "=" && ret=0
    fi

    return ret
}

__docker_node_complete_ps_filters() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1

    if compset -P '*='; then
        case "${${words[-1]%=*}#*=}" in
            (desired-state)
                state_opts=('accepted' 'running')
                _describe -t state-opts "desired state options" state_opts && ret=0
                ;;
            *)
                _message 'value' && ret=0
                ;;
        esac
    else
        opts=('desired-state' 'id' 'label' 'name')
        _describe -t filter-opts "filter options" opts -qS "=" && ret=0
    fi

    return ret
}

__docker_nodes() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    local line s
    declare -a lines nodes args

    type=$1; shift
    filter=$1; shift
    [[ $filter != "none" ]] && args=("-f $filter")

    lines=(${(f)${:-"$(_call_program commands docker $docker_options node ls $args)"$'\n'}})
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
    end[${header[$i,$((j-1))]}]=-1
    lines=(${lines[2,-1]})

    # Node ID
    if [[ $type = (ids|all) ]]; then
        for line in $lines; do
            s="${line[${begin[ID]},${end[ID]}]%% ##}"
            nodes=($nodes $s)
        done
    fi

    # Names
    if [[ $type = (names|all) ]]; then
        for line in $lines; do
            s="${line[${begin[NAME]},${end[NAME]}]%% ##}"
            nodes=($nodes $s)
        done
    fi

    _describe -t nodes-list "nodes" nodes "$@" && ret=0
    return ret
}

__docker_complete_nodes() {
    [[ $PREFIX = -* ]] && return 1
    __docker_nodes all none "$@"
}

__docker_complete_nodes_ids() {
    [[ $PREFIX = -* ]] && return 1
    __docker_nodes ids none "$@"
}

__docker_complete_nodes_names() {
    [[ $PREFIX = -* ]] && return 1
    __docker_nodes names none "$@"
}

__docker_complete_pending_nodes() {
    [[ $PREFIX = -* ]] && return 1
    __docker_nodes all "membership=pending" "$@"
}

__docker_complete_manager_nodes() {
    [[ $PREFIX = -* ]] && return 1
    __docker_nodes all "role=manager" "$@"
}

__docker_complete_worker_nodes() {
    [[ $PREFIX = -* ]] && return 1
    __docker_nodes all "role=worker" "$@"
}

__docker_node_commands() {
    local -a _docker_node_subcommands
    _docker_node_subcommands=(
        "demote:Demote a node as manager in the swarm"
        "inspect:Display detailed information on one or more nodes"
        "ls:List nodes in the swarm"
        "promote:Promote a node as manager in the swarm"
        "rm:Remove one or more nodes from the swarm"
        "ps:List tasks running on one or more nodes, defaults to current node"
        "update:Update a node"
    )
    _describe -t docker-node-commands "docker node command" _docker_node_subcommands
}

__docker_node_subcommand() {
    local -a _command_args opts_help
    local expl help="--help"
    integer ret=1

    opts_help=("(: -)--help[Print usage]")

    case "$words[1]" in
        (rm|remove)
             _arguments $(__docker_arguments) \
                $opts_help \
                "($help -f --force)"{-f,--force}"[Force remove a node from the swarm]" \
                "($help -)*:node:__docker_complete_pending_nodes" && ret=0
            ;;
        (demote)
             _arguments $(__docker_arguments) \
                $opts_help \
                "($help -)*:node:__docker_complete_manager_nodes" && ret=0
            ;;
        (inspect)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -f --format)"{-f=,--format=}"[Format the output using the given go template]:template: " \
                "($help)--pretty[Print the information in a human friendly format]" \
                "($help -)*:node:__docker_complete_nodes" && ret=0
            ;;
        (ls|list)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)*"{-f=,--filter=}"[Provide filter values]:filter:->filter-options" \
                "($help -q --quiet)"{-q,--quiet}"[Only display IDs]" && ret=0
            case $state in
                (filter-options)
                    __docker_node_complete_ls_filters && ret=0
                    ;;
            esac
            ;;
        (promote)
             _arguments $(__docker_arguments) \
                $opts_help \
                "($help -)*:node:__docker_complete_worker_nodes" && ret=0
            ;;
        (ps)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -a --all)"{-a,--all}"[Display all instances]" \
                "($help)*"{-f=,--filter=}"[Provide filter values]:filter:->filter-options" \
                "($help)--no-resolve[Do not map IDs to Names]" \
                "($help)--no-trunc[Do not truncate output]" \
                "($help -)*:node:__docker_complete_nodes" && ret=0
            case $state in
                (filter-options)
                    __docker_node_complete_ps_filters && ret=0
                    ;;
            esac
            ;;
        (update)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)--availability=[Availability of the node]:availability:(active pause drain)" \
                "($help)*--label-add=[Add or update a node label]:key=value: " \
                "($help)*--label-rm=[Remove a node label if exists]:label: " \
                "($help)--role=[Role of the node]:role:(manager worker)" \
                "($help -)1:node:__docker_complete_nodes" && ret=0
            ;;
        (help)
            _arguments $(__docker_arguments) ":subcommand:__docker_node_commands" && ret=0
            ;;
    esac

    return ret
}

# EO node

# BO plugin

__docker_complete_plugins() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    local line s
    declare -a lines plugins

    lines=(${(f)${:-"$(_call_program commands docker $docker_options plugin ls)"$'\n'}})

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
    end[${header[$i,$((j-1))]}]=-1
    lines=(${lines[2,-1]})

    # Name
    for line in $lines; do
        s="${line[${begin[NAME]},${end[NAME]}]%% ##}"
        s="$s:${(l:7:: :::)${${line[${begin[TAG]},${end[TAG]}]}%% ##}}"
        plugins=($plugins $s)
    done

    _describe -t plugins-list "plugins" plugins "$@" && ret=0
    return ret
}

__docker_plugin_commands() {
    local -a _docker_plugin_subcommands
    _docker_plugin_subcommands=(
        "disable:Disable a plugin"
        "enable:Enable a plugin"
        "inspect:Return low-level information about a plugin"
        "install:Install a plugin"
        "ls:List plugins"
        "push:Push a plugin"
        "rm:Remove a plugin"
        "set:Change settings for a plugin"
    )
    _describe -t docker-plugin-commands "docker plugin command" _docker_plugin_subcommands
}

__docker_plugin_subcommand() {
    local -a _command_args opts_help
    local expl help="--help"
    integer ret=1

    opts_help=("(: -)--help[Print usage]")

    case "$words[1]" in
        (disable|enable|inspect|install|ls|push|rm)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -)1:plugin:__docker_complete_plugins" && ret=0
            ;;
        (set)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -)1:plugin:__docker_complete_plugins" \
                "($help-)*:key=value: " && ret=0
            ;;
        (help)
            _arguments $(__docker_arguments) ":subcommand:__docker_plugin_commands" && ret=0
            ;;
    esac

    return ret
}

# EO plugin

# BO secret

__docker_secrets() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    local line s
    declare -a lines secrets

    type=$1; shift

    lines=(${(f)${:-"$(_call_program commands docker $docker_options secret ls)"$'\n'}})

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
    end[${header[$i,$((j-1))]}]=-1
    lines=(${lines[2,-1]})

    # ID
    if [[ $type = (ids|all) ]]; then
        for line in $lines; do
            s="${line[${begin[ID]},${end[ID]}]%% ##}"
            secrets=($secrets $s)
        done
    fi

    # Names
    if [[ $type = (names|all) ]]; then
        for line in $lines; do
            s="${line[${begin[NAME]},${end[NAME]}]%% ##}"
            secrets=($secrets $s)
        done
    fi

    _describe -t secrets-list "secrets" secrets "$@" && ret=0
    return ret
}

__docker_complete_secrets() {
    [[ $PREFIX = -* ]] && return 1
    __docker_secrets all "$@"
}

__docker_secret_commands() {
    local -a _docker_secret_subcommands
    _docker_secret_subcommands=(
        "create:Create a secret using stdin as content"
        "inspect:Display detailed information on one or more secrets"
        "ls:List secrets"
        "rm:Remove one or more secrets"
    )
    _describe -t docker-secret-commands "docker secret command" _docker_secret_subcommands
}

__docker_secret_subcommand() {
    local -a _command_args opts_help
    local expl help="--help"
    integer ret=1

    opts_help=("(: -)--help[Print usage]")

    case "$words[1]" in
        (create)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)*"{-l=,--label=}"[Secret labels]:label: " \
                "($help -):secret: " && ret=0
            ;;
        (inspect)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -f --format)"{-f=,--format=}"[Format the output using the given Go template]:template: " \
                "($help -)*:secret:__docker_complete_secrets" && ret=0
            ;;
        (ls|list)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -q --quiet)"{-q,--quiet}"[Only display IDs]" && ret=0
            ;;
        (rm|remove)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -)*:secret:__docker_complete_secrets" && ret=0
            ;;
        (help)
            _arguments $(__docker_arguments) ":subcommand:__docker_secret_commands" && ret=0
            ;;
    esac

    return ret
}

# EO secret

# BO service

__docker_service_complete_ls_filters() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1

    if compset -P '*='; then
        case "${${words[-1]%=*}#*=}" in
            (id)
                __docker_complete_services_ids && ret=0
                ;;
            (name)
                __docker_complete_services_names && ret=0
                ;;
            *)
                _message 'value' && ret=0
                ;;
        esac
    else
        opts=('id' 'label' 'name')
        _describe -t filter-opts "filter options" opts -qS "=" && ret=0
    fi

    return ret
}

__docker_service_complete_ps_filters() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1

    if compset -P '*='; then
        case "${${words[-1]%=*}#*=}" in
            (desired-state)
                state_opts=('accepted' 'running')
                _describe -t state-opts "desired state options" state_opts && ret=0
                ;;
            *)
                _message 'value' && ret=0
                ;;
        esac
    else
        opts=('desired-state' 'id' 'label' 'name')
        _describe -t filter-opts "filter options" opts -qS "=" && ret=0
    fi

    return ret
}

__docker_services() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    local line s
    declare -a lines services

    type=$1; shift

    lines=(${(f)${:-"$(_call_program commands docker $docker_options service ls)"$'\n'}})

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
    end[${header[$i,$((j-1))]}]=-1
    lines=(${lines[2,-1]})

    # Service ID
    if [[ $type = (ids|all) ]]; then
        for line in $lines; do
            s="${line[${begin[ID]},${end[ID]}]%% ##}"
            s="$s:${(l:7:: :::)${${line[${begin[IMAGE]},${end[IMAGE]}]}%% ##}}"
            services=($services $s)
        done
    fi

    # Names
    if [[ $type = (names|all) ]]; then
        for line in $lines; do
            s="${line[${begin[NAME]},${end[NAME]}]%% ##}"
            s="$s:${(l:7:: :::)${${line[${begin[IMAGE]},${end[IMAGE]}]}%% ##}}"
            services=($services $s)
        done
    fi

    _describe -t services-list "services" services "$@" && ret=0
    return ret
}

__docker_complete_services() {
    [[ $PREFIX = -* ]] && return 1
    __docker_services all "$@"
}

__docker_complete_services_ids() {
    [[ $PREFIX = -* ]] && return 1
    __docker_services ids "$@"
}

__docker_complete_services_names() {
    [[ $PREFIX = -* ]] && return 1
    __docker_services names "$@"
}

__docker_service_commands() {
    local -a _docker_service_subcommands
    _docker_service_subcommands=(
        "create:Create a new service"
        "inspect:Display detailed information on one or more services"
        "ls:List services"
        "rm:Remove one or more services"
        "scale:Scale one or multiple replicated services"
        "ps:List the tasks of a service"
        "update:Update a service"
    )
    _describe -t docker-service-commands "docker service command" _docker_service_subcommands
}

__docker_service_subcommand() {
    local -a _command_args opts_help opts_create_update
    local expl help="--help"
    integer ret=1

    opts_help=("(: -)--help[Print usage]")
    opts_create_update=(
        "($help)*--constraint=[Placement constraints]:constraint: "
        "($help)--endpoint-mode=[Placement constraints]:mode:(dnsrr vip)"
        "($help)*"{-e=,--env=}"[Set environment variables]:env: "
        "($help)--health-cmd=[Command to run to check health]:command: "
        "($help)--health-interval=[Time between running the check]:time: "
        "($help)--health-retries=[Consecutive failures needed to report unhealthy]:retries:(1 2 3 4 5)"
        "($help)--health-timeout=[Maximum time to allow one check to run]:time: "
        "($help)--hostname=[Service container hostname]:hostname: " \
        "($help)*--label=[Service labels]:label: "
        "($help)--limit-cpu=[Limit CPUs]:value: "
        "($help)--limit-memory=[Limit Memory]:value: "
        "($help)--log-driver=[Logging driver for service]:logging driver:__docker_complete_log_drivers"
        "($help)*--log-opt=[Logging driver options]:log driver options:__docker_complete_log_options"
        "($help)*--mount=[Attach a filesystem mount to the service]:mount: "
        "($help)*--network=[Network attachments]:network: "
        "($help)--no-healthcheck[Disable any container-specified HEALTHCHECK]"
        "($help)*"{-p=,--publish=}"[Publish a port as a node port]:port: "
        "($help)--replicas=[Number of tasks]:replicas: "
        "($help)--reserve-cpu=[Reserve CPUs]:value: "
        "($help)--reserve-memory=[Reserve Memory]:value: "
        "($help)--restart-condition=[Restart when condition is met]:mode:(any none on-failure)"
        "($help)--restart-delay=[Delay between restart attempts]:delay: "
        "($help)--restart-max-attempts=[Maximum number of restarts before giving up]:max-attempts: "
        "($help)--restart-window=[Window used to evaluate the restart policy]:window: "
        "($help)*--secret=[Specify secrets to expose to the service]:secret:__docker_complete_secrets"
        "($help)--stop-grace-period=[Time to wait before force killing a container]:grace period: "
        "($help -t --tty)"{-t,--tty}"[Allocate a pseudo-TTY]"
        "($help)--update-delay=[Delay between updates]:delay: "
        "($help)--update-failure-action=[Action on update failure]:mode:(pause continue)"
        "($help)--update-max-failure-ratio=[Failure rate to tolerate during an update]:fraction: "
        "($help)--update-monitor=[Duration after each task update to monitor for failure]:window: "
        "($help)--update-parallelism=[Maximum number of tasks updated simultaneously]:number: "
        "($help -u --user)"{-u=,--user=}"[Username or UID]:user:_users"
        "($help)--with-registry-auth[Send registry authentication details to swarm agents]"
        "($help -w --workdir)"{-w=,--workdir=}"[Working directory inside the container]:directory:_directories"
    )

    case "$words[1]" in
        (create)
            _arguments $(__docker_arguments) \
                $opts_help \
                $opts_create_update \
                "($help)*--container-label=[Container labels]:label: " \
                "($help)*--dns=[Set custom DNS servers]:DNS: " \
                "($help)*--dns-option=[Set DNS options]:DNS option: " \
                "($help)*--dns-search=[Set custom DNS search domains]:DNS search: " \
                "($help)*--env-file=[Read environment variables from a file]:environment file:_files" \
                "($help)--mode=[Service Mode]:mode:(global replicated)" \
                "($help)--name=[Service name]:name: " \
                "($help)*--publish=[Publish a port]:port: " \
                "($help -): :__docker_complete_images" \
                "($help -):command: _command_names -e" \
                "($help -)*::arguments: _normal" && ret=0
            ;;
        (inspect)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -f --format)"{-f=,--format=}"[Format the output using the given go template]:template: " \
                "($help)--pretty[Print the information in a human friendly format]" \
                "($help -)*:service:__docker_complete_services" && ret=0
            ;;
        (ls|list)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)*"{-f=,--filter=}"[Filter output based on conditions provided]:filter:->filter-options" \
                "($help -q --quiet)"{-q,--quiet}"[Only display IDs]" && ret=0
            case $state in
                (filter-options)
                    __docker_service_complete_ls_filters && ret=0
                    ;;
            esac
            ;;
        (rm|remove)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -)*:service:__docker_complete_services" && ret=0
            ;;
        (scale)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -)*:service:->values" && ret=0
            case $state in
                (values)
                    if compset -P '*='; then
                        _message 'replicas' && ret=0
                    else
                        __docker_complete_services -qS "="
                    fi
                    ;;
            esac
            ;;
        (ps)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)*"{-f=,--filter=}"[Provide filter values]:filter:->filter-options" \
                "($help)--no-resolve[Do not map IDs to Names]" \
                "($help)--no-trunc[Do not truncate output]" \
                "($help -q --quiet)"{-q,--quiet}"[Only display task IDs]" \
                "($help -)1:service:__docker_complete_services" && ret=0
            case $state in
                (filter-options)
                    __docker_service_complete_ps_filters && ret=0
                    ;;
            esac
            ;;
        (update)
            _arguments $(__docker_arguments) \
                $opts_help \
                $opts_create_update \
                "($help)--arg=[Service command args]:arguments: _normal" \
                "($help)*--container-label-add=[Add or update container labels]:label: " \
                "($help)*--container-label-rm=[Remove a container label by its key]:label: " \
                "($help)*--dns-add=[Add or update custom DNS servers]:DNS: " \
                "($help)*--dns-rm=[Remove custom DNS servers]:DNS: " \
                "($help)*--dns-option-add=[Add or update DNS options]:DNS option: " \
                "($help)*--dns-option-rm=[Remove DNS options]:DNS option: " \
                "($help)*--dns-search-add=[Add or update custom DNS search domains]:DNS search: " \
                "($help)*--dns-search-rm=[Remove DNS search domains]:DNS search: " \
                "($help)--force[Force update]" \
                "($help)*--group-add=[Add additional supplementary user groups to the container]:group:_groups" \
                "($help)*--group-rm=[Remove previously added supplementary user groups from the container]:group:_groups" \
                "($help)--image=[Service image tag]:image:__docker_complete_repositories" \
                "($help)*--publish-add=[Add or update a port]:port: " \
                "($help)*--publish-rm=[Remove a port(target-port mandatory)]:port: " \
                "($help)--rollback[Rollback to previous specification]" \
                "($help -)1:service:__docker_complete_services" && ret=0
            ;;
        (help)
            _arguments $(__docker_arguments) ":subcommand:__docker_service_commands" && ret=0
            ;;
    esac

    return ret
}

# EO service

# BO stack

__docker_stack_complete_ps_filters() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1

    if compset -P '*='; then
        case "${${words[-1]%=*}#*=}" in
            (desired-state)
                state_opts=('accepted' 'running')
                _describe -t state-opts "desired state options" state_opts && ret=0
                ;;
            *)
                _message 'value' && ret=0
                ;;
        esac
    else
        opts=('desired-state' 'id' 'name')
        _describe -t filter-opts "filter options" opts -qS "=" && ret=0
    fi

    return ret
}

__docker_stack_complete_services_filters() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1

    if compset -P '*='; then
        case "${${words[-1]%=*}#*=}" in
            *)
                _message 'value' && ret=0
                ;;
        esac
    else
        opts=('id' 'label' 'name')
        _describe -t filter-opts "filter options" opts -qS "=" && ret=0
    fi

    return ret
}

__docker_stacks() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    local line s
    declare -a lines stacks

    lines=(${(f)${:-"$(_call_program commands docker $docker_options stack ls)"$'\n'}})

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
    end[${header[$i,$((j-1))]}]=-1
    lines=(${lines[2,-1]})

    # Service ID
    for line in $lines; do
        s="${line[${begin[ID]},${end[ID]}]%% ##}"
        stacks=($stacks $s)
    done

    _describe -t stacks-list "stacks" stacks "$@" && ret=0
    return ret
}

__docker_complete_stacks() {
    [[ $PREFIX = -* ]] && return 1
    __docker_stacks "$@"
}

__docker_stack_commands() {
    local -a _docker_stack_subcommands
    _docker_stack_subcommands=(
        "deploy:Deploy a new stack or update an existing stack"
        "ls:List stacks"
        "ps:List the tasks in the stack"
        "rm:Remove the stack"
        "services:List the services in the stack"
    )
    _describe -t docker-stack-commands "docker stack command" _docker_stack_subcommands
}

__docker_stack_subcommand() {
    local -a _command_args opts_help
    local expl help="--help"
    integer ret=1

    opts_help=("(: -)--help[Print usage]")

    case "$words[1]" in
        (deploy|up)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)--bundle-file=[Path to a Distributed Application Bundle file]:dab:_files -g \"*.dab\"" \
                "($help -c --compose-file)"{-c=,--compose-file=}"[Path to a Compose file]:compose file:_files -g \"*.(yml|yaml)\"" \
                "($help)--with-registry-auth[Send registry authentication details to Swarm agents]" \
                "($help -):stack:__docker_complete_stacks" && ret=0
            ;;
        (ls|list)
            _arguments $(__docker_arguments) \
                $opts_help && ret=0
            ;;
        (ps)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -a --all)"{-a,--all}"[Display all tasks]" \
                "($help)*"{-f=,--filter=}"[Filter output based on conditions provided]:filter:__docker_stack_complete_ps_filters" \
                "($help)--no-resolve[Do not map IDs to Names]" \
                "($help)--no-trunc[Do not truncate output]" \
                "($help -):stack:__docker_complete_stacks" && ret=0
            ;;
        (rm|remove|down)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -):stack:__docker_complete_stacks" && ret=0
            ;;
        (services)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)*"{-f=,--filter=}"[Filter output based on conditions provided]:filter:__docker_stack_complete_services_filters" \
                "($help -q --quiet)"{-q,--quiet}"[Only display IDs]" \
                "($help -):stack:__docker_complete_stacks" && ret=0
            ;;
        (help)
            _arguments $(__docker_arguments) ":subcommand:__docker_stack_commands" && ret=0
            ;;
    esac

    return ret
}

# EO stack

# BO swarm

__docker_swarm_commands() {
    local -a _docker_swarm_subcommands
    _docker_swarm_subcommands=(
        "init:Initialize a swarm"
        "join:Join a swarm as a node and/or manager"
        "join-token:Manage join tokens"
        "leave:Leave a swarm"
        "update:Update the swarm"
    )
    _describe -t docker-swarm-commands "docker swarm command" _docker_swarm_subcommands
}

__docker_swarm_subcommand() {
    local -a _command_args opts_help
    local expl help="--help"
    integer ret=1

    opts_help=("(: -)--help[Print usage]")

    case "$words[1]" in
        (init)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)--advertise-addr[Advertised address]:ip\:port: " \
                "($help)*--external-ca=[Specifications of one or more certificate signing endpoints]:endpoint: " \
                "($help)--force-new-cluster[Force create a new cluster from current state]" \
                "($help)--listen-addr=[Listen address]:ip\:port: " \
                "($help)--max-snapshots[Number of additional Raft snapshots to retain]" \
                "($help)--snapshot-interval[Number of log entries between Raft snapshots]" \
                "($help)--task-history-limit=[Task history retention limit]:limit: " && ret=0
            ;;
        (join)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)--advertise-addr[Advertised address]:ip\:port: " \
                "($help)--listen-addr=[Listen address]:ip\:port: " \
                "($help)--token=[Token for entry into the swarm]:secret: " \
                "($help -):host\:port: " && ret=0
            ;;
        (join-token)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -q --quiet)"{-q,--quiet}"[Only display token]" \
                "($help)--rotate[Rotate join token]" \
                "($help -):role:(manager worker)" && ret=0
            ;;
        (leave)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -f --force)"{-f,--force}"[Force this node to leave the swarm, ignoring warnings]" && ret=0
            ;;
        (update)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)--cert-expiry=[Validity period for node certificates]:duration: " \
                "($help)*--external-ca=[Specifications of one or more certificate signing endpoints]:endpoint: " \
                "($help)--dispatcher-heartbeat=[Dispatcher heartbeat period]:duration: " \
                "($help)--max-snapshots[Number of additional Raft snapshots to retain]" \
                "($help)--snapshot-interval[Number of log entries between Raft snapshots]" \
                "($help)--task-history-limit=[Task history retention limit]:limit: " && ret=0
            ;;
        (help)
            _arguments $(__docker_arguments) ":subcommand:__docker_network_commands" && ret=0
            ;;
    esac

    return ret
}

# EO swarm

# BO system

__docker_system_commands() {
    local -a _docker_system_subcommands
    _docker_system_subcommands=(
        "df:Show docker filesystem usage"
        "events:Get real time events from the server"
        "info:Display system-wide information"
        "prune:Remove unused data"
    )
    _describe -t docker-system-commands "docker system command" _docker_system_subcommands
}

__docker_system_subcommand() {
    local -a _command_args opts_help
    local expl help="--help"
    integer ret=1

    opts_help=("(: -)--help[Print usage]")

    case "$words[1]" in
        (df)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -v --verbose)"{-v,--verbose}"[Show detailed information on space usage]" && ret=0
            ;;
        (events)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)*"{-f=,--filter=}"[Filter values]:filter:__docker_complete_events_filter" \
                "($help)--since=[Events created since this timestamp]:timestamp: " \
                "($help)--until=[Events created until this timestamp]:timestamp: " \
                "($help)--format=[Format the output using the given go template]:template: " && ret=0
            ;;
        (info)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -f --format)"{-f=,--format=}"[Format the output using the given go template]:template: " && ret=0
            ;;
        (prune)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -a --all)"{-a,--all}"[Remove all unused data, not just dangling ones]" \
                "($help -f --force)"{-f,--force}"[Do not prompt for confirmation]" && ret=0
            ;;
        (help)
            _arguments $(__docker_arguments) ":subcommand:__docker_volume_commands" && ret=0
            ;;
    esac

    return ret
}

# EO system

# BO volume

__docker_volume_complete_ls_filters() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1

    if compset -P '*='; then
        case "${${words[-1]%=*}#*=}" in
            (dangling)
                dangling_opts=('true' 'false')
                _describe -t dangling-filter-opts "Dangling Filter Options" dangling_opts && ret=0
                ;;
            (driver)
                __docker_complete_info_plugins Volume && ret=0
                ;;
            (name)
                __docker_complete_volumes && ret=0
                ;;
            *)
                _message 'value' && ret=0
                ;;
        esac
    else
        opts=('dangling' 'driver' 'label' 'name')
        _describe -t filter-opts "Filter Options" opts -qS "=" && ret=0
    fi

    return ret
}

__docker_complete_volumes() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    declare -a lines volumes

    lines=(${(f)${:-"$(_call_program commands docker $docker_options volume ls)"$'\n'}})

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
    end[${header[$i,$((j-1))]}]=-1
    lines=(${lines[2,-1]})

    # Names
    local line s
    for line in $lines; do
        s="${line[${begin[VOLUME NAME]},${end[VOLUME NAME]}]%% ##}"
        s="$s:${(l:7:: :::)${${line[${begin[DRIVER]},${end[DRIVER]}]}%% ##}}"
        volumes=($volumes $s)
    done

    _describe -t volumes-list "volumes" volumes && ret=0
    return ret
}

__docker_volume_commands() {
    local -a _docker_volume_subcommands
    _docker_volume_subcommands=(
        "create:Create a volume"
        "inspect:Display detailed information on one or more volumes"
        "ls:List volumes"
        "prune:Remove all unused volumes"
        "rm:Remove one or more volumes"
    )
    _describe -t docker-volume-commands "docker volume command" _docker_volume_subcommands
}

__docker_volume_subcommand() {
    local -a _command_args opts_help
    local expl help="--help"
    integer ret=1

    opts_help=("(: -)--help[Print usage]")

    case "$words[1]" in
        (create)
            _arguments $(__docker_arguments) -A '-*' \
                $opts_help \
                "($help -d --driver)"{-d=,--driver=}"[Volume driver name]:Driver name:(local)" \
                "($help)*--label=[Set metadata for a volume]:label=value: " \
                "($help)*"{-o=,--opt=}"[Driver specific options]:Driver option: " \
                "($help -)1:Volume name: " && ret=0
            ;;
        (inspect)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -f --format)"{-f=,--format=}"[Format the output using the given go template]:template: " \
                "($help -)1:volume:__docker_complete_volumes" && ret=0
            ;;
        (ls)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)*"{-f=,--filter=}"[Provide filter values]:filter:->filter-options" \
                "($help)--format=[Pretty-print volumes using a Go template]:template: " \
                "($help -q --quiet)"{-q,--quiet}"[Only display volume names]" && ret=0
            case $state in
                (filter-options)
                    __docker_volume_complete_ls_filters && ret=0
                    ;;
            esac
            ;;
        (prune)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -f --force)"{-f,--force}"[Do not prompt for confirmation]" && ret=0
            ;;
        (rm)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -f --force)"{-f,--force}"[Force the removal of one or more volumes]" \
                "($help -):volume:__docker_complete_volumes" && ret=0
            ;;
        (help)
            _arguments $(__docker_arguments) ":subcommand:__docker_volume_commands" && ret=0
            ;;
    esac

    return ret
}

# EO volume

__docker_caching_policy() {
  oldp=( "$1"(Nmh+1) )     # 1 hour
  (( $#oldp ))
}

__docker_commands() {
    local cache_policy

    zstyle -s ":completion:${curcontext}:" cache-policy cache_policy
    if [[ -z "$cache_policy" ]]; then
        zstyle ":completion:${curcontext}:" cache-policy __docker_caching_policy
    fi

    if ( [[ ${+_docker_subcommands} -eq 0 ]] || _cache_invalid docker_subcommands) \
        && ! _retrieve_cache docker_subcommands;
    then
        local -a lines
        lines=(${(f)"$(_call_program commands docker 2>&1)"})
        _docker_subcommands=(${${${(M)${lines[$((${lines[(i)*Commands:]} + 1)),-1]}:# *}## #}/ ##/:})
        _docker_subcommands=($_docker_subcommands 'daemon:Enable daemon mode' 'help:Show help for a command')
        (( $#_docker_subcommands > 2 )) && _store_cache docker_subcommands _docker_subcommands
    fi
    _describe -t docker-commands "docker command" _docker_subcommands
}

__docker_subcommand() {
    local -a _command_args opts_help
    local expl help="--help"
    integer ret=1

    opts_help=("(: -)--help[Print usage]")

    case "$words[1]" in
        (attach|commit|cp|create|diff|exec|export|kill|logs|pause|unpause|port|rename|restart|rm|run|start|stats|stop|top|update|wait)
            __docker_container_subcommand && ret=0
            ;;
        (build|history|import|load|pull|push|save|tag)
            __docker_image_subcommand && ret=0
            ;;
        (container)
            local curcontext="$curcontext" state
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -): :->command" \
                "($help -)*:: :->option-or-argument" && ret=0

            case $state in
                (command)
                    __docker_container_commands && ret=0
                    ;;
                (option-or-argument)
                    curcontext=${curcontext%:*:*}:docker-${words[-1]}:
                    __docker_container_subcommand && ret=0
                    ;;
            esac
            ;;
        (daemon)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)*--add-runtime=[Register an additional OCI compatible runtime]:runtime:__docker_complete_runtimes" \
                "($help)--api-cors-header=[CORS headers in the Engine API]:CORS headers: " \
                "($help)*--authorization-plugin=[Authorization plugins to load]" \
                "($help -b --bridge)"{-b=,--bridge=}"[Attach containers to a network bridge]:bridge:_net_interfaces" \
                "($help)--bip=[Network bridge IP]:IP address: " \
                "($help)--cgroup-parent=[Parent cgroup for all containers]:cgroup: " \
                "($help)--cluster-advertise=[Address or interface name to advertise]:Instance to advertise (host\:port): " \
                "($help)--cluster-store=[URL of the distributed storage backend]:Cluster Store:->cluster-store" \
                "($help)*--cluster-store-opt=[Cluster store options]:Cluster options:->cluster-store-options" \
                "($help)--config-file=[Path to daemon configuration file]:Config File:_files" \
                "($help)--containerd=[Path to containerd socket]:socket:_files -g \"*.sock\"" \
                "($help -D --debug)"{-D,--debug}"[Enable debug mode]" \
                "($help)--default-gateway[Container default gateway IPv4 address]:IPv4 address: " \
                "($help)--default-gateway-v6[Container default gateway IPv6 address]:IPv6 address: " \
                "($help)*--default-ulimit=[Default ulimits for containers]:ulimit: " \
                "($help)--disable-legacy-registry[Disable contacting legacy registries]" \
                "($help)*--dns=[DNS server to use]:DNS: " \
                "($help)*--dns-opt=[DNS options to use]:DNS option: " \
                "($help)*--dns-search=[DNS search domains to use]:DNS search: " \
                "($help)*--exec-opt=[Runtime execution options]:runtime execution options: " \
                "($help)--exec-root=[Root directory for execution state files]:path:_directories" \
                "($help)--experimental[Enable experimental features]" \
                "($help)--fixed-cidr=[IPv4 subnet for fixed IPs]:IPv4 subnet: " \
                "($help)--fixed-cidr-v6=[IPv6 subnet for fixed IPs]:IPv6 subnet: " \
                "($help -G --group)"{-G=,--group=}"[Group for the unix socket]:group:_groups" \
                "($help -g --graph)"{-g=,--graph=}"[Root of the Docker runtime]:path:_directories" \
                "($help -H --host)"{-H=,--host=}"[tcp://host:port to bind/connect to]:host: " \
                "($help)--icc[Enable inter-container communication]" \
                "($help)--init-path=[Path to the docker-init binary]:docker-init binary:_files" \
                "($help)*--insecure-registry=[Enable insecure registry communication]:registry: " \
                "($help)--ip=[Default IP when binding container ports]" \
                "($help)--ip-forward[Enable net.ipv4.ip_forward]" \
                "($help)--ip-masq[Enable IP masquerading]" \
                "($help)--iptables[Enable addition of iptables rules]" \
                "($help)--ipv6[Enable IPv6 networking]" \
                "($help -l --log-level)"{-l=,--log-level=}"[Logging level]:level:(debug info warn error fatal)" \
                "($help)*--label=[Key=value labels]:label: " \
                "($help)--live-restore[Enable live restore of docker when containers are still running]" \
                "($help)--log-driver=[Default driver for container logs]:logging driver:__docker_complete_log_drivers" \
                "($help)*--log-opt=[Default log driver options for containers]:log driver options:__docker_complete_log_options" \
                "($help)--max-concurrent-downloads[Set the max concurrent downloads for each pull]" \
                "($help)--max-concurrent-uploads[Set the max concurrent uploads for each push]" \
                "($help)--mtu=[Network MTU]:mtu:(0 576 1420 1500 9000)" \
                "($help)--oom-score-adjust=[Set the oom_score_adj for the daemon]:oom-score:(-500)" \
                "($help -p --pidfile)"{-p=,--pidfile=}"[Path to use for daemon PID file]:PID file:_files" \
                "($help)--raw-logs[Full timestamps without ANSI coloring]" \
                "($help)*--registry-mirror=[Preferred Docker registry mirror]:registry mirror: " \
                "($help)--seccomp-profile=[Path to seccomp profile]:path:_files -g \"*.json\"" \
                "($help -s --storage-driver)"{-s=,--storage-driver=}"[Storage driver to use]:driver:(aufs btrfs devicemapper overlay overlay2 vfs zfs)" \
                "($help)--selinux-enabled[Enable selinux support]" \
                "($help)--shutdown-timeout=[Set the shutdown timeout value in seconds]:time: " \
                "($help)*--storage-opt=[Storage driver options]:storage driver options: " \
                "($help)--tls[Use TLS]" \
                "($help)--tlscacert=[Trust certs signed only by this CA]:PEM file:_files -g \"*.(pem|crt)\"" \
                "($help)--tlscert=[Path to TLS certificate file]:PEM file:_files -g \"*.(pem|crt)\"" \
                "($help)--tlskey=[Path to TLS key file]:Key file:_files -g \"*.(pem|key)\"" \
                "($help)--tlsverify[Use TLS and verify the remote]" \
                "($help)--userns-remap=[User/Group setting for user namespaces]:user\:group:->users-groups" \
                "($help)--userland-proxy[Use userland proxy for loopback traffic]" \
                "($help)--userland-proxy-path=[Path to the userland proxy binary]:binary:_files" && ret=0

            case $state in
                (cluster-store)
                    if compset -P '*://'; then
                        _message 'host:port' && ret=0
                    else
                        store=('consul' 'etcd' 'zk')
                        _describe -t cluster-store "Cluster Store" store -qS "://" && ret=0
                    fi
                    ;;
                (cluster-store-options)
                    if compset -P '*='; then
                        _files && ret=0
                    else
                        opts=('discovery.heartbeat' 'discovery.ttl' 'kv.cacertfile' 'kv.certfile' 'kv.keyfile' 'kv.path')
                        _describe -t cluster-store-opts "Cluster Store Options" opts -qS "=" && ret=0
                    fi
                    ;;
                (users-groups)
                    if compset -P '*:'; then
                        _groups && ret=0
                    else
                        _describe -t userns-default "default Docker user management" '(default)' && ret=0
                        _users && ret=0
                    fi
                    ;;
            esac
            ;;
        (events|info)
            __docker_system_subcommand && ret=0
            ;;
        (image)
            local curcontext="$curcontext" state
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -): :->command" \
                "($help -)*:: :->option-or-argument" && ret=0

            case $state in
                (command)
                    __docker_image_commands && ret=0
                    ;;
                (option-or-argument)
                    curcontext=${curcontext%:*:*}:docker-${words[-1]}:
                    __docker_image_subcommand && ret=0
                    ;;
            esac
            ;;
        (images)
            words[1]='ls'
            __docker_image_subcommand && ret=0
            ;;
        (inspect)
            local state
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -f --format)"{-f=,--format=}"[Format the output using the given go template]:template: " \
                "($help -s --size)"{-s,--size}"[Display total file sizes if the type is container]" \
                "($help)--type=[Return JSON for specified type]:type:(container image network node plugin service volume)" \
                "($help -)*: :->values" && ret=0

            case $state in
                (values)
                    if [[ ${words[(r)--type=container]} == --type=container ]]; then
                        __docker_complete_containers && ret=0
                    elif [[ ${words[(r)--type=image]} == --type=image ]]; then
                        __docker_complete_images && ret=0
                    elif [[ ${words[(r)--type=network]} == --type=network ]]; then
                        __docker_complete_networks && ret=0
                    elif [[ ${words[(r)--type=node]} == --type=node ]]; then
                        __docker_complete_nodes && ret=0
                    elif [[ ${words[(r)--type=plugin]} == --type=plugin ]]; then
                        __docker_complete_plugins && ret=0
                    elif [[ ${words[(r)--type=service]} == --type=service ]]; then
                        __docker_complete_services && ret=0
                    elif [[ ${words[(r)--type=volume]} == --type=volume ]]; then
                        __docker_complete_volumes && ret=0
                    else
                        __docker_complete_containers
                        __docker_complete_images
                        __docker_complete_networks
                        __docker_complete_nodes
                        __docker_complete_plugins
                        __docker_complete_services
                        __docker_complete_volumes && ret=0
                    fi
                    ;;
            esac
            ;;
        (login)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -p --password)"{-p=,--password=}"[Password]:password: " \
                "($help -u --user)"{-u=,--user=}"[Username]:username: " \
                "($help -)1:server: " && ret=0
            ;;
        (logout)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -)1:server: " && ret=0
            ;;
        (network)
            local curcontext="$curcontext" state
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -): :->command" \
                "($help -)*:: :->option-or-argument" && ret=0

            case $state in
                (command)
                    __docker_network_commands && ret=0
                    ;;
                (option-or-argument)
                    curcontext=${curcontext%:*:*}:docker-${words[-1]}:
                    __docker_network_subcommand && ret=0
                    ;;
            esac
            ;;
        (node)
            local curcontext="$curcontext" state
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -): :->command" \
                "($help -)*:: :->option-or-argument" && ret=0

            case $state in
                (command)
                    __docker_node_commands && ret=0
                    ;;
                (option-or-argument)
                    curcontext=${curcontext%:*:*}:docker-${words[-1]}:
                    __docker_node_subcommand && ret=0
                    ;;
            esac
            ;;
        (plugin)
            local curcontext="$curcontext" state
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -): :->command" \
                "($help -)*:: :->option-or-argument" && ret=0

            case $state in
                (command)
                    __docker_plugin_commands && ret=0
                    ;;
                (option-or-argument)
                    curcontext=${curcontext%:*:*}:docker-${words[-1]}:
                    __docker_plugin_subcommand && ret=0
                    ;;
            esac
            ;;
        (ps)
            words[1]='ls'
            __docker_container_subcommand && ret=0
            ;;
        (rmi)
            words[1]='rm'
            __docker_image_subcommand && ret=0
            ;;
        (search)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help)*"{-f=,--filter=}"[Filter values]:filter:->filter-options" \
                "($help)--limit=[Maximum returned search results]:limit:(1 5 10 25 50)" \
                "($help)--no-trunc[Do not truncate output]" \
                "($help -):term: " && ret=0

            case $state in
                (filter-options)
                    __docker_complete_search_filters && ret=0
                    ;;
            esac
            ;;
        (secret)
            local curcontext="$curcontext" state
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -): :->command" \
                "($help -)*:: :->option-or-argument" && ret=0

            case $state in
                (command)
                    __docker_secret_commands && ret=0
                    ;;
                (option-or-argument)
                    curcontext=${curcontext%:*:*}:docker-${words[-1]}:
                    __docker_secret_subcommand && ret=0
                    ;;
            esac
            ;;
        (service)
            local curcontext="$curcontext" state
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -): :->command" \
                "($help -)*:: :->option-or-argument" && ret=0

            case $state in
                (command)
                    __docker_service_commands && ret=0
                    ;;
                (option-or-argument)
                    curcontext=${curcontext%:*:*}:docker-${words[-1]}:
                    __docker_service_subcommand && ret=0
                    ;;
            esac
            ;;
        (stack)
            local curcontext="$curcontext" state
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -): :->command" \
                "($help -)*:: :->option-or-argument" && ret=0

            case $state in
                (command)
                    __docker_stack_commands && ret=0
                    ;;
                (option-or-argument)
                    curcontext=${curcontext%:*:*}:docker-${words[-1]}:
                    __docker_stack_subcommand && ret=0
                    ;;
            esac
            ;;
        (swarm)
            local curcontext="$curcontext" state
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -): :->command" \
                "($help -)*:: :->option-or-argument" && ret=0

            case $state in
                (command)
                    __docker_swarm_commands && ret=0
                    ;;
                (option-or-argument)
                    curcontext=${curcontext%:*:*}:docker-${words[-1]}:
                    __docker_swarm_subcommand && ret=0
                    ;;
            esac
            ;;
        (system)
            local curcontext="$curcontext" state
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -): :->command" \
                "($help -)*:: :->option-or-argument" && ret=0

            case $state in
                (command)
                    __docker_system_commands && ret=0
                    ;;
                (option-or-argument)
                    curcontext=${curcontext%:*:*}:docker-${words[-1]}:
                    __docker_system_subcommand && ret=0
                    ;;
            esac
            ;;
        (version)
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -f --format)"{-f=,--format=}"[Format the output using the given go template]:template: " && ret=0
            ;;
        (volume)
            local curcontext="$curcontext" state
            _arguments $(__docker_arguments) \
                $opts_help \
                "($help -): :->command" \
                "($help -)*:: :->option-or-argument" && ret=0

            case $state in
                (command)
                    __docker_volume_commands && ret=0
                    ;;
                (option-or-argument)
                    curcontext=${curcontext%:*:*}:docker-${words[-1]}:
                    __docker_volume_subcommand && ret=0
                    ;;
            esac
            ;;
        (help)
            _arguments $(__docker_arguments) ":subcommand:__docker_commands" && ret=0
            ;;
    esac

    return ret
}

_docker() {
    # Support for subservices, which allows for `compdef _docker docker-shell=_docker_containers`.
    # Based on /usr/share/zsh/functions/Completion/Unix/_git without support for `ret`.
    if [[ $service != docker ]]; then
        _call_function - _$service
        return
    fi

    local curcontext="$curcontext" state line help="-h --help"
    integer ret=1
    typeset -A opt_args

    _arguments $(__docker_arguments) -C \
        "(: -)"{-h,--help}"[Print usage]" \
        "($help)--config[Location of client config files]:path:_directories" \
        "($help -D --debug)"{-D,--debug}"[Enable debug mode]" \
        "($help -H --host)"{-H=,--host=}"[tcp://host:port to bind/connect to]:host: " \
        "($help -l --log-level)"{-l=,--log-level=}"[Logging level]:level:(debug info warn error fatal)" \
        "($help)--tls[Use TLS]" \
        "($help)--tlscacert=[Trust certs signed only by this CA]:PEM file:_files -g "*.(pem|crt)"" \
        "($help)--tlscert=[Path to TLS certificate file]:PEM file:_files -g "*.(pem|crt)"" \
        "($help)--tlskey=[Path to TLS key file]:Key file:_files -g "*.(pem|key)"" \
        "($help)--tlsverify[Use TLS and verify the remote]" \
        "($help)--userland-proxy[Use userland proxy for loopback traffic]" \
        "($help -v --version)"{-v,--version}"[Print version information and quit]" \
        "($help -): :->command" \
        "($help -)*:: :->option-or-argument" && ret=0

    local host=${opt_args[-H]}${opt_args[--host]}
    local config=${opt_args[--config]}
    local docker_options="${host:+--host $host} ${config:+--config $config}"

    case $state in
        (command)
            __docker_commands && ret=0
            ;;
        (option-or-argument)
            curcontext=${curcontext%:*:*}:docker-$words[1]:
            __docker_subcommand && ret=0
            ;;
    esac

    return ret
}

_dockerd() {
    integer ret=1
    words[1]='daemon'
    __docker_subcommand && ret=0
    return ret
}

_docker "$@"

# Local Variables:
# mode: Shell-Script
# sh-indentation: 4
# indent-tabs-mode: nil
# sh-basic-offset: 4
# End:
# vim: ft=zsh sw=4 ts=4 et

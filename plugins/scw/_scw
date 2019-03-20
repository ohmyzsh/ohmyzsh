#compdef scw
#
# zsh completion for scw (https://www.scaleway.com)
#
# Inspired by https://github.com/felixr/docker-zsh-completion

__scw_get_servers() {
    local expl
    declare -a servers
    servers=(${(f)"$(_call_program commands scw _completion servers-names)"})
    _describe -t servers "servers" servers
}

__scw_stoppedservers() {
    __scw_get_servers
}

__scw_runningservers() {
    __scw_get_servers
}

__scw_servers () {
    __scw_get_servers
}

__scw_images () {
    local expl
    declare -a images
    images=(${(f)"$(_call_program commands scw _completion images-names)"})
    _describe -t images "images" images
}

__scw_images_and_snapshots () {
    __scw_images
    __scw_snapshots
}

__scw_snapshots () {
    local expl
    declare -a snapshots
    snapshots=(${(f)"$(_call_program commands scw _completion --prefix snapshots-names)"})
    _describe -t snapshots "snapshots" snapshots
}

__scw_bootscripts () {
    local expl
    declare -a bootscripts
    bootscripts=(${(f)"$(_call_program commands scw _completion bootscripts-names)"})
    _describe -t bootscripts "bootscripts" bootscripts
}

__scw_tags() {
    __scw_images
}

__scw_repositories_with_tags() {
    __scw_images
}

__scw_search() {
    # declare -a scwsearch
    local cache_policy
    zstyle -s ":completion:${curcontext}:" cache-policy cache_policy
    if [[ -z "$cache_policy" ]]; then
        zstyle ":completion:${curcontext}:" cache-policy __scw_caching_policy
    fi

    local searchterm cachename
    searchterm="${words[$CURRENT]%/}"
    cachename=_scw-search-$searchterm

    local expl
    local -a result
    if ( [[ ${(P)+cachename} -eq 0 ]] || _cache_invalid ${cachename#_} ) \
        && ! _retrieve_cache ${cachename#_}; then
        _message "Searching for ${searchterm}..."
        result=(${${${(f)"$(_call_program commands scw search ${searchterm})"}%% *}[2,-1]})
        _store_cache ${cachename#_} result
    fi
    _wanted scwsearch expl 'available images' compadd -a result
}

__scw_caching_policy()
{
  oldp=( "$1"(Nmh+1) )     # 1 hour
  (( $#oldp ))
}


__scw_repositories () {
    __scw_images
}

__scw_commands () {
    # local -a  _scw_subcommands
    local cache_policy

    zstyle -s ":completion:${curcontext}:" cache-policy cache_policy
    if [[ -z "$cache_policy" ]]; then
        zstyle ":completion:${curcontext}:" cache-policy __scw_caching_policy
    fi

    if ( [[ ${+_scw_subcommands} -eq 0 ]] || _cache_invalid scw_subcommands) \
        && ! _retrieve_cache scw_subcommands;
    then
        local -a lines
        lines=(${(f)"$(_call_program commands scw 2>&1)"})
        _scw_subcommands=(${${${lines[$((${lines[(i)Commands:]} + 1)),${lines[(I)    *]}]}## #}/ ##/:})
        _scw_subcommands=($_scw_subcommands 'help:Show help for a command')
        _store_cache scw_subcommands _scw_subcommands
    fi
    _describe -t scw-commands "scw command" _scw_subcommands
}

__scw_subcommand () {
    local -a _command_args
    case "$words[1]" in
        (attach)
            _arguments \
                '--no-stdin[Do not attach stdin]' \
                ':servers:__scw_runningservers'
            ;;
        (commit)
            _arguments \
                {-v,--volume=0}'[Volume slot]:volume: ' \
                ':server:__scw_servers' \
                ':repository:__scw_repositories_with_tags'
            ;;
        (cp)
            _arguments \
                ':server:->server' \
                ':hostpath:_files'
            case $state in
                (server)
                    if compset -P '*:'; then
                        _files
                    else
                        __scw_servers -qS ":"
                    fi
                    ;;
            esac
            ;;
        (exec)
            local state ret
            _arguments \
                {-T,--timeout=0}'[Set timeout values to seconds]' \
                {-w,--wait}'[Wait for SSH to be ready]' \
                ':servers:__scw_runningservers' \
                '*::command:->anycommand' && ret=0

            case $state in
                (anycommand)
                    shift 1 words
                    (( CURRENT-- ))
                    _normal
                    ;;
            esac

            return ret
            ;;
        (history)
            _arguments \
                '--no-trunc[Do not truncate output]' \
                {-q,--quiet}'[Only show numeric IDs]' \
                '*:images:__scw_images'
            ;;
        (images)
            _arguments \
                {-a,--all}'[Show all images]' \
                '--no-trunc[Do not truncate output]' \
                {-q,--quiet}'[Only show numeric IDs]' \
                ':repository:__scw_repositories'
            ;;
        (info)
            ;;
        (inspect)
            _arguments \
                {-f,--format=-}'[Format the output using the given go template]:template: ' \
                '*:servers:__scw_servers'
            ;;
        (kill)
            _arguments \
                '*:servers:__scw_runningservers'
            ;;
        (login)
            _arguments \
                {-o,--organization=-}'[Organization]:organization: ' \
                {-t,--token=-}'[Token]:token: ' \
                ':server: '
            ;;
        (logout)
            _arguments \
                ':server: '
            ;;
        (logs)
            _arguments \
                '*:servers:__scw_servers'
            ;;
        (port)
            _arguments \
                '1:servers:__scw_runningservers' \
                '2:port:_ports'
            ;;
        (start)
            _arguments \
                {-T,--timeout=0}'[Set timeout values to seconds]' \
                {-w,--wait}'[Wait for SSH to be ready]' \
                '*:servers:__scw_stoppedservers'
            ;;
        (rm)
            _arguments \
                '*:servers:__scw_stoppedservers'
            ;;
        (rmi)
            _arguments \
                '*:images:__scw_images'
            ;;
        (restart)
            _arguments \
                '*:servers:__scw_runningservers'
            ;;
        (stop)
            _arguments \
                {-t,--terminate}'[Stop and trash a server with its volumes]' \
                {-w,--wait}'[Synchronous stop. Wait for server to be stopped]' \
                '*:servers:__scw_runningservers'
            ;;
        (top)
            _arguments \
                '1:servers:__scw_runningservers' \
                '(-)*:: :->ps-arguments'
            case $state in
                (ps-arguments)
                    _ps
                    ;;
            esac
            ;;
        (ps)
            _arguments \
                {-a,--all}'[Show all servers. Only running servers are shown by default]' \
                {-l,--latest}'[Show only the latest created server]' \
                '-n[Show n last created servers, include non-running one]:n:(1 5 10 25 50)' \
                '--no-trunc[Do not truncate output]' \
                {-q,--quiet}'[Only show numeric IDs]'
            ;;
        (tag)
            _arguments \
                {-f,--force}'[force]'\
                ':image:__scw_images'\
                ':repository:__scw_repositories_with_tags'
            ;;
        (create|run)
            _arguments \
                {-a,--attach}'[Attach to stdin, stdout or stderr]' \
                '*'{-e,--environment=-}'[Set environment variables]:environment variable: ' \
                '--name=-[Server name]:name: ' \
                '--bootscript=-[Assign a bootscript]:bootscript:__scw_bootscripts ' \
                '*-v[Bind mount a volume]:volume: '\
                '(-):images:__scw_images_and_snapshots' \
                '(-):command: _command_names -e' \
                '*::arguments: _normal'

            case $state in
                (link)
                    if compset -P '*:'; then
                        _wanted alias expl 'Alias' compadd -E ""
                    else
                        __scw_runningservers -qS ":"
                    fi
                    ;;
            esac
            ;;
        (rename)
            _arguments \
                ':old name:__scw_servers' \
                ':new name: '
            ;;
        (search)
            _arguments \
                '--no-trunc[Do not truncate output]' \
                ':term: '
            ;;
        (wait)
            _arguments '*:servers:__scw_runningservers'
            ;;
        (help)
            _arguments ':subcommand:__scw_commands'
            ;;
        (*)
            _message 'Unknown sub command'
    esac

}

_scw () {
    # Support for subservices, which allows for `compdef _scw scw-shell=_scw_servers`.
    # Based on /usr/share/zsh/functions/Completion/Unix/_git without support for `ret`.
    if [[ $service != scw ]]; then
        _call_function - _$service
        return
    fi

    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments -C \
      '-H[tcp://host:port to bind/connect to]:socket: ' \
         '(-): :->command' \
         '(-)*:: :->option-or-argument'

    if (( CURRENT == 1 )); then

    fi
    case $state in
        (command)
            __scw_commands
            ;;
        (option-or-argument)
            curcontext=${curcontext%:*:*}:scw-$words[1]:
            __scw_subcommand
            ;;
    esac
}

_scw "$@"

# Local Variables:
# mode: Shell-Script
# sh-indentation: 4
# indent-tabs-mode: nil
# sh-basic-offset: 4
# End:
# vim: ft=zsh sw=4 ts=4 et

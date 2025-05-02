if [[ "$ENABLE_CORRECTION" == "true" ]]; then
    alias sudo='nocorrect noglob _do_sudo '
else
    alias sudo='noglob _do_sudo '
fi

function _do_sudo() {
    [[ -z ${__do_sudo_glob+x} ]] && __do_sudo_glob=1
    [[ -z ${__do_sudo_expanded+x} ]] && declare -A __do_sudo_expanded
    local -a args
    local -a cmd_alias_arr
    local cmd_alias
    local return_value
    while (($#)); do
        case "$1" in
        command|exec|-) shift; break ;;
        nocorrect) shift ;;
        noglob) __do_sudo_glob=0; shift ;;
        [1-9]) args+=( $1 ); shift ;;
        *)
            cmd_alias="$(command -v 2>/dev/null -- "$1")"
            if [[ "$?" -eq 0 ]] && [[ "$cmd_alias" == 'alias'* ]] && [[ -z "$__do_sudo_expanded["$1"]" ]]; then
                __do_sudo_expanded["$1"]=1
                IFS=' ' read -A cmd_alias_arr <<< "$(sed -e "s/[^=]*=//" -e "s/^'//" -e "s/'$//" <<< "$cmd_alias")"
                args+=( "${cmd_alias_arr[@]}" )
                shift
                break
            else
                if ((__do_sudo_glob)); then
                    args+=( $~==1 )
                else
                    args+=( $==1 )
                fi
                shift
            fi
            ;;
        esac
    done
    if [[ ${#cmd_alias_arr[@]} -gt 0 ]]; then
        _do_sudo "${args[@]}" $==*
    else
        if ((__do_sudo_glob)); then
            PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH" command sudo "${args[@]}" $~==*
        else
            PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH" command sudo "${args[@]}" $==*
        fi
        return_value=$?
        unset __do_sudo_glob
        unset __do_sudo_expanded
        return $return_value
    fi
}

command -v _sudo >/dev/null 2>&1
[[ $? -eq 0 ]] && compdef _sudo '_do_sudo'

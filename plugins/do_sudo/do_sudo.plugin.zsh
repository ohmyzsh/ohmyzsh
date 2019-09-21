if [[ "$ENABLE_CORRECTION" == "true" ]]; then
    alias sudo='nocorrect noglob _do_sudo '
else
    alias sudo='noglob _do_sudo '
fi

function _do_sudo() {
    integer glob=1
    local -a run
    run=( command sudo )
    while (($#)); do
        case "$1" in
        command|exec|-) shift; break ;;
        nocorrect) shift ;;
        noglob) glob=0; shift ;;
        *) break ;;
        esac
    done
    if ((glob)); then
        PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH" $run $~==*
    else
        PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH" $run $==*
    fi
}

command -v _sudo >/dev/null 2>&1
[[ $? -eq 0 ]] && compdef _sudo '_do_sudo'

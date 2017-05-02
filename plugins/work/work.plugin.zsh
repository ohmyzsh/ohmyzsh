typeset -A _WORKPLUGIN_DIRS_FULLPATH

for dir in $WORKPLUGIN_DIRS; do
    _WORKPLUGIN_DIRS_FULLPATH[$dir]="$HOME/$dir"
done

work() {
    local dir
    for dir in $_WORKPLUGIN_DIRS_FULLPATH; do
        if [[ -d "$dir/$1" ]]; then
            builtin cd "$dir/$1"
            break
        fi
    done
    if [[ $(type -w "WORKPLUGIN_CALLBACK") == "WORKPLUGIN_CALLBACK: function" ]]; then
        WORKPLUGIN_CALLBACK "$1"
    fi
}

_work_comp() {
    local dir
    for dir in $_WORKPLUGIN_DIRS_FULLPATH; do
        compadd $(ls $dir)
    done
}

compdef _work_comp work

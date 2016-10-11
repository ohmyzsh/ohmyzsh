# Only compatible with MacOS
[[ "$OSTYPE" == darwin* ]] || return

droplr() {
    if [[ $# -eq 0 ]]; then
        echo You need to specify a parameter. >&2
        return 1
    fi

    if [[ "$1" =~ ^http[|s]:// ]]; then
        osascript -e "tell app 'Droplr' to shorten '$1'"
    else
        open -ga /Applications/Droplr.app "$1"
    fi
}

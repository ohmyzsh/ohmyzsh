# easier alias to use the plugin
alias ccat='colorize_via_pygmentize'
alias cless='colorize_via_pygmentize_less'

colorize_via_pygmentize() {
    local available_tools=("chroma" "pygmentize")

    if [ -z "$ZSH_COLORIZE_TOOL" ]; then
        if (( $+commands[pygmentize] )); then
            ZSH_COLORIZE_TOOL="pygmentize"
        elif (( $+commands[chroma] )); then
            ZSH_COLORIZE_TOOL="chroma"
        else
            echo "Neither 'pygments' nor 'chroma' is installed!" >&2
            return 1
        fi
    fi

    if [[ ${available_tools[(Ie)$ZSH_COLORIZE_TOOL]} -eq 0 ]]; then
        echo "ZSH_COLORIZE_TOOL '$ZSH_COLORIZE_TOOL' not recognized. Available options are 'pygmentize' and 'chroma'." >&2
        return 1
    elif (( $+commands["$ZSH_COLORIZE_TOOL"] )); then
        echo "Package '$ZSH_COLORIZE_TOOL' is not installed!" >&2
        return 1
    fi

    # If the environment variable ZSH_COLORIZE_STYLE
    # is set, use that theme instead. Otherwise,
    # use the default.
    if [ -z "$ZSH_COLORIZE_STYLE" ]; then
        # Both pygmentize & chroma support 'emacs'
        ZSH_COLORIZE_STYLE="emacs"
    fi

    # pygmentize stdin if no arguments passed
    if [ $# -eq 0 ]; then
        if [[ "$ZSH_COLORIZE_TOOL" == "pygmentize" ]]; then
            pygmentize -O style="$ZSH_COLORIZE_STYLE" -g
        else
            chroma --style="$ZSH_COLORIZE_STYLE"
        fi
        return $?
    fi

    # guess lexer from file extension, or
    # guess it from file contents if unsuccessful

    local FNAME lexer
    for FNAME in "$@"
    do
        if [[ "$ZSH_COLORIZE_TOOL" == "pygmentize" ]]; then
            lexer=$(pygmentize -N "$FNAME")
            if [[ $lexer != text ]]; then
                pygmentize -O style="$ZSH_COLORIZE_STYLE" -l "$lexer" "$FNAME"
            else
                pygmentize -O style="$ZSH_COLORIZE_STYLE" -g "$FNAME"
            fi
        else
            chroma --style="$ZSH_COLORIZE_STYLE" "$FNAME"
        fi
    done
}

colorize_via_pygmentize_less() (
    # this function is a subshell so tmp_files can be shared to cleanup function
    declare -a tmp_files

    cleanup () {
        [[ ${#tmp_files} -gt 0 ]] && rm -f "${tmp_files[@]}"
        exit
    }
    trap 'cleanup' EXIT HUP TERM INT

    while (( $# != 0 )); do     #TODO: filter out less opts
        tmp_file="$(mktemp -t "tmp.colorize.XXXX.$(sed 's/\//./g' <<< "$1")")"
        tmp_files+=("$tmp_file")
        colorize_via_pygmentize "$1" > "$tmp_file"
        shift 1
    done

    less -f "${tmp_files[@]}"
)

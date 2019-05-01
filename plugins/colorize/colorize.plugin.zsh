# easier alias to use the plugin
alias ccat='colorize_via_pygmentize'
alias cless='colorize_via_pygmentize_less'  

colorize_via_pygmentize() {
    if ! (( $+commands[pygmentize] )); then
        echo "package 'Pygments' is not installed!"
        return 1
    fi

    # pygmentize stdin if no arguments passed
    if [ $# -eq 0 ]; then
        pygmentize -g
        return $?
    fi

    # guess lexer from file extension, or
    # guess it from file contents if unsuccessful
    local FNAME lexer
    for FNAME in "$@"
    do
        lexer=$(pygmentize -N "$FNAME")
        if [[ $lexer != text ]]; then
            pygmentize -l "$lexer" "$FNAME"
        else
            pygmentize -g "$FNAME"
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

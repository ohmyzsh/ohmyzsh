#compdef fd fdfind

autoload -U is-at-least

_fd() {
    typeset -A opt_args
    typeset -a _arguments_options
    local ret=1

    if is-at-least 5.2; then
        _arguments_options=(-s -S -C)
    else
        _arguments_options=(-s -C)
    fi

    local context curcontext="$curcontext" state line
    _arguments "${_arguments_options[@]}" \
'-d+[Set maximum search depth (default: none)]' \
'--max-depth=[Set maximum search depth (default: none)]' \
'--maxdepth=[See --max-depth]' \
'*-t+[Filter by type: file (f), directory (d), symlink (l),
executable (x), empty (e)]: :(f file d directory l symlink x executable e empty)' \
'*--type=[Filter by type: file (f), directory (d), symlink (l),
executable (x), empty (e)]: :(f file d directory l symlink x executable e empty)' \
'*-e+[Filter by file extension]' \
'*--extension=[Filter by file extension]' \
'-x+[Execute a command for each search result]' \
'--exec=[Execute a command for each search result]' \
'(-x --exec)-X+[Execute a command with all search results at once]' \
'(-x --exec)--exec-batch=[Execute a command with all search results at once]' \
'*-E+[Exclude entries that match the given glob pattern]' \
'*--exclude=[Exclude entries that match the given glob pattern]' \
'*--ignore-file=[Add a custom ignore-file in .gitignore format]' \
'-c+[When to use colors: never, *auto*, always]: :(never auto always)' \
'--color=[When to use colors: never, *auto*, always]: :(never auto always)' \
'-j+[Set number of threads to use for searching & executing]' \
'--threads=[Set number of threads to use for searching & executing]' \
'*-S+[Limit results based on the size of files.]' \
'*--size=[Limit results based on the size of files.]' \
'--max-buffer-time=[the time (in ms) to buffer, before streaming to the console]' \
'--changed-within=[Filter by file modification time (newer than)]' \
'--changed-before=[Filter by file modification time (older than)]' \
'*--search-path=[(hidden)]' \
'-H[Search hidden files and directories]' \
'--hidden[Search hidden files and directories]' \
'-I[Do not respect .(git|fd)ignore files]' \
'--no-ignore[Do not respect .(git|fd)ignore files]' \
'--no-ignore-vcs[Do not respect .gitignore files]' \
'*-u[Alias for no-ignore and/or hidden]' \
'-s[Case-sensitive search (default: smart case)]' \
'--case-sensitive[Case-sensitive search (default: smart case)]' \
'-i[Case-insensitive search (default: smart case)]' \
'--ignore-case[Case-insensitive search (default: smart case)]' \
'-F[Treat the pattern as a literal string]' \
'--fixed-strings[Treat the pattern as a literal string]' \
'-a[Show absolute instead of relative paths]' \
'--absolute-path[Show absolute instead of relative paths]' \
'-L[Follow symbolic links]' \
'--follow[Follow symbolic links]' \
'-p[Search full path (default: file-/dirname only)]' \
'--full-path[Search full path (default: file-/dirname only)]' \
'-0[Separate results by the null character]' \
'--print0[Separate results by the null character]' \
'--show-errors[Enable display of filesystem errors]' \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
'::pattern -- the search pattern, a regular expression (optional):_files' \
'::path -- the root directory for the filesystem search (optional):_files' \
&& ret=0

}

(( $+functions[_fd_commands] )) ||
_fd_commands() {
    local commands; commands=(

    )
    _describe -t commands 'fd commands' commands "$@"
}

_fd "$@"

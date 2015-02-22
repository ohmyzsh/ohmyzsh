# Ignore VCS folders (if the necessary grep flags are available).
VCS_FOLDERS="{.bzr,.cvs,.git,.hg,.svn}"

_setup_grep_alias() {
    local GREP_OPTIONS
    # Color grep results.
    GREP_OPTIONS=(--color=auto)

    # Is grep argument $1 available?
    grep-flag-available() {
        echo | grep $1 "" >/dev/null 2>&1
    }
    if grep-flag-available --exclude-dir=.cvs; then
        GREP_OPTIONS+=(--exclude-dir=$VCS_FOLDERS)
    elif grep-flag-available --exclude=.cvs; then
        GREP_OPTIONS+=(--exclude=$VCS_FOLDERS)
    fi
    # Clean up.
    unfunction grep-flag-available

    # Remove alias and setup function.
    unalias grep
    setopt localoptions norcexpandparam
    eval "grep() {
        local options
        options=(${(@)GREP_OPTIONS})
        # Add '-r' if grepping a dir.
        if [[ -d \$@[\$#] ]]; then
            options+=(-r)
        fi
        command grep \$options \"\$@\"
    }"

    # Run it on first invocation.
    grep $GREP_OPTIONS "$@"
}
alias grep=_setup_grep_alias

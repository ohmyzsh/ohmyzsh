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

    # Re-define alias.
    alias grep="grep $GREP_OPTIONS"

    # Clean up.
    unfunction grep-flag-available

    # Run it on first invocation.
    command grep $GREP_OPTIONS "$@"
}
alias grep=_setup_grep_alias

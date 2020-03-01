__GREP_CACHE_FILE="$ZSH_CACHE_DIR"/grep-alias

# See if there's a cache file modified in the last day
__GREP_ALIAS_CACHES=("$__GREP_CACHE_FILE"(Nm-1))
if [[ -z "$__GREP_ALIAS_CACHES" ]]; then
    grep-flags-available() {
        command grep "$@" "" &>/dev/null <<< ""
    }

    # Ignore these folders (if the necessary grep flags are available)
    EXC_FOLDERS="{.bzr,CVS,.git,.hg,.svn,.idea,.tox}"

    # Check for --exclude-dir, otherwise check for --exclude. If --exclude
    # isn't available, --color won't be either (they were released at the same
    # time (v2.5): http://git.savannah.gnu.org/cgit/grep.git/tree/NEWS?id=1236f007
    if grep-flags-available --color=auto --exclude-dir=.cvs; then
        GREP_OPTIONS="--color=auto --exclude-dir=$EXC_FOLDERS"
    elif grep-flags-available --color=auto --exclude=.cvs; then
        GREP_OPTIONS="--color=auto --exclude=$EXC_FOLDERS"
    fi

    {
        if [[ -n "$GREP_OPTIONS" ]]; then
            # export grep, egrep and fgrep settings
            echo "alias grep='grep $GREP_OPTIONS'"
            echo "alias egrep='egrep $GREP_OPTIONS'"
            echo "alias fgrep='fgrep $GREP_OPTIONS'"
        fi
    } > "$__GREP_CACHE_FILE"

    # Clean up
    unset GREP_OPTIONS EXC_FOLDERS
    unfunction grep-flags-available
fi

source "$__GREP_CACHE_FILE"
unset __GREP_CACHE_FILE __GREP_ALIAS_CACHES

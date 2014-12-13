# is x grep argument available?
grep-flag-available() {
    echo | grep $1 "" >/dev/null 2>&1
}

# color grep results
GREP_OPTIONS="--color=auto"

# ignore VCS folders (if the necessary grep flags are available)
VCS_FOLDERS="{.bzr,.cvs,.git,.hg,.svn}"

if grep-flag-available --exclude-dir=.cvs; then
    GREP_OPTIONS+=" --exclude-dir=$VCS_FOLDERS"
elif grep-flag-available --exclude=.cvs; then
    GREP_OPTIONS+=" --exclude=$VCS_FOLDERS"
fi

# export grep settings
export GREP_OPTIONS="$GREP_OPTIONS"
export GREP_COLOR='1;32'

# clean up
unset VCS_FOLDERS
unfunction grep-flag-available

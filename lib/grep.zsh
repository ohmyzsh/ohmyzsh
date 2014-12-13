#
# Color grep results
# Examples: http://rubyurl.com/ZXv
#

GREP_OPTIONS="--color=auto"

# avoid VCS folders (if the necessary grep flags are available)
VCS_folders="{.bzr,.cvs,.git,.hg,.svn}"

grep-flag-available() {
    echo | command grep $1 "" >/dev/null 2>&1
}
if grep-flag-available --exclude-dir=.cvs; then
    GREP_OPTIONS+=" --exclude-dir=$VCS_folders"
elif grep-flag-available --exclude=.cvs; then
    GREP_OPTIONS+=" --exclude=$VCS_folders"
fi

export GREP_OPTIONS="$GREP_OPTIONS"
export GREP_COLOR='1;32'


# cleanup
unset VCS_folders
unfunction grep-flag-available

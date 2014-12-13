#
# Color grep results
# Examples: http://rubyurl.com/ZXv
#

GREP_OPTIONS="--color=auto"

# avoid VCS folders (if the necessary grep flags are available)
VCS_FOLDERS="{.cvs,.git,.hg,.svn}"

grep-flag-available() {
    echo | grep $1 "" >/dev/null 2>&1
}
if grep-flag-available --exclude-dir=.cvs; then
    GREP_OPTIONS+=" --exclude-dir=$VCS_FOLDERS"
elif grep-flag-available --exclude=.cvs; then
    GREP_OPTIONS+=" --exclude=$VCS_FOLDERS"
fi
unset VCS_FOLDERS
unfunction grep-flag-available

export GREP_OPTIONS="$GREP_OPTIONS"
export GREP_COLOR='1;32'

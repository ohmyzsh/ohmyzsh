# is x grep argument available?
grep-flag-available() {
    echo | grep $1 "" >/dev/null 2>&1
}

GREP_OPTIONS=""

# color grep results
if grep-flag-available --color=auto; then
    GREP_OPTIONS+=" --color=auto"
fi

# ignore these folders (if the necessary grep flags are available)
EXC_FOLDERS="{.bzr,CVS,.git,.hg,.svn,.idea}"

if grep-flag-available --exclude-dir=.cvs; then
    GREP_OPTIONS+=" --exclude-dir=$EXC_FOLDERS"
elif grep-flag-available --exclude=.cvs; then
    GREP_OPTIONS+=" --exclude=$EXC_FOLDERS"
fi

# export grep, egrep and fgrep settings
alias grep="grep $GREP_OPTIONS"
alias egrep="egrep $GREP_OPTIONS"
alias fgrep="fgrep $GREP_OPTIONS"

# clean up
unset GREP_OPTIONS
unset EXC_FOLDERS
unfunction grep-flag-available

#
# Color grep results
# Examples: http://rubyurl.com/ZXv
#

# color grep output
GREP_OPTIONS="--color=auto"

# avoid VCS folders (if the necessary grep flags are available)
grep-flag-available() {
    echo | grep $1 "" >/dev/null 2>&1
}
if grep-flag-available --exclude-dir=.cvs; then
    for PATTERN in .cvs .git .hg .svn; do
        GREP_OPTIONS+=" --exclude-dir=$PATTERN"
    done
elif grep-flag-available --exclude=.cvs; then
    for PATTERN in .cvs .git .hg .svn; do
        GREP_OPTIONS+=" --exclude=$PATTERN"
    done
fi
unfunction grep-flag-available

# define grep wrapper (GREP_OPTIONS env var is deprecated)
eval "function grep {
    command grep $GREP_OPTIONS \"\$@\"
}"
unset GREP_OPTIONS

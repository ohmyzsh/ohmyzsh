#
# Color grep results
# Examples: http://rubyurl.com/ZXv
#

OPTIONS_GREP="--color=auto"

# avoid VCS folders (if the necessary grep flags are available)
grep-flag-available() {
    echo | grep $1 "" >/dev/null 2>&1
}
if grep-flag-available --exclude-dir=.cvs; then
    for PATTERN in .cvs .git .hg .svn; do
        OPTIONS_GREP+=" --exclude-dir=$PATTERN"
    done
elif grep-flag-available --exclude=.cvs; then
    for PATTERN in .cvs .git .hg .svn; do
        OPTIONS_GREP+=" --exclude=$PATTERN"
    done
fi
unfunction grep-flag-available

alias grep="grep $OPTIONS_GREP"
export GREP_COLOR='1;32'

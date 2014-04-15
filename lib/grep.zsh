#
# Color grep results
# Examples: http://rubyurl.com/ZXv
#

# avoid VCS folders if grep supports it
GREP_OPTIONS=
if [[ "$(grep --help | grep -q exclude-dir)" != "1" ]]; then
    for PATTERN in .cvs .git .hg .svn; do
        GREP_OPTIONS+="--exclude-dir=$PATTERN "
    done
fi
GREP_OPTIONS+="--color=auto"
export GREP_OPTIONS="$GREP_OPTIONS"
export GREP_COLOR='1;32'

#
# Color grep results
# Examples: http://rubyurl.com/ZXv
#

# avoid VCS folders
GREP_OPTIONS=
for PATTERN in .cvs .git .hg .svn; do
    GREP_OPTIONS+="--exclude-dir=$PATTERN "
done
GREP_OPTIONS+="--color=auto"
export GREP_OPTIONS="$GREP_OPTIONS"
export GREP_COLOR='1;32'

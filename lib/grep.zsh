#
# Color grep results
# Examples: http://rubyurl.com/ZXv
#

# avoid VCS folders
GREP_OPTIONS=
# --exclude-dir is only available on 2.5.3 and later versions of grep
if ! grep --version | head -n 1 | egrep " [0-2]\.[0-5]\.[0-2]" 2>&1 >/dev/null;
then
    for PATTERN in .cvs .git .hg .svn; do
        GREP_OPTIONS+="--exclude-dir=$PATTERN "
    done
fi

GREP_OPTIONS+="--color=auto"
export GREP_OPTIONS="$GREP_OPTIONS"
export GREP_COLOR='1;32'

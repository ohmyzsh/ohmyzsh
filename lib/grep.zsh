#
# Color grep results
# Examples: http://rubyurl.com/ZXv
#

# avoid VCS folders
GREP_OPTIONS=
GREP_OPTIONS+="--color=auto"
export GREP_OPTIONS="$GREP_OPTIONS"
export GREP_COLOR='1;32'

#
# Color grep results
# Examples: http://rubyurl.com/ZXv
#

GREP_OPTIONS=

# returns 0 if the first version number is greater than or equal to the second.
# returns 1 if the first version number is greater than or equal to the second.
function versionCompare() {
	local LEAST_VERSION=$(echo -e "$1\n$2" | sort -t '.' -g | head -n 1)
	if [[ $LEAST_VERSION = $1 ]]; then
		return 0
	fi
	return 1
}

# avoid VCS folders.  This chooses a different argument based on grep version.
# grep version 2.5+ is required for any support of this feature.
function ignoreVCS() {
	local GREP_VERSION=$(grep --version | head -n 1 | sed -e 's/^.* \([0-9]\{1,\}\(\.[0-9a-z]\{1,\}\)\{1,\}\)-.*/\1/')

	for PATTERN in .cvs .git .hg .svn; do
		# logically, if(GREP_VERSION >= 2.5.3)
		if versionCompare "2.5.3" $GREP_VERSION; then
			GREP_OPTIONS+="--exclude-dir=$PATTERN "
		# logically, if(GREP_VERSION >= 2.5)
		elif versionCompare "2.5" $GREP_VERSION; then
			GREP_OPTIONS+="--exclude=$PATTERN "
		fi
	done
}
ignoreVCS;
unfunction versionCompare
unfunction ignoreVCS

GREP_OPTIONS+="--color=auto"
export GREP_OPTIONS="$GREP_OPTIONS"
export GREP_COLOR='1;32'

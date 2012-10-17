#!/usr/bin/env zsh
# Keeps track of the last used working directory and automatically jumps
# into it for new shells.

# Flag indicating if we've previously jumped to last directory.
typeset -g ZSH_LAST_WORKING_DIRECTORY
local cache_file="$ZSH/cache/last-working-dir"

# Updates the last directory once directory is changed.
function chpwd() {
	echo "$PWD" > "$cache_file"
}

# Changes directory to the last working directory.
function lwd() {
	[[ ! -r "$cache_file" ]] || cd `cat "$cache_file"`
}

# Automatically jump to last working directory unless this isn't the first time
# this plugin has been loaded.
if [[ -z "$ZSH_LAST_WORKING_DIRECTORY" ]]; then
	lwd 2>/dev/null && ZSH_LAST_WORKING_DIRECTORY=1 || true
fi

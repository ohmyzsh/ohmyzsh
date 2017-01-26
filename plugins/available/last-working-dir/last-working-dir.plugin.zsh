# Flag indicating if we've previously jumped to last directory
typeset -g ZSH_LAST_WORKING_DIRECTORY

# Updates the last directory once directory is changed
chpwd_functions+=(chpwd_last_working_dir)
chpwd_last_working_dir() {
	local cache_file="$ZSH_CACHE_DIR/last-working-dir"
	pwd >| "$cache_file"
}

# Changes directory to the last working directory
lwd() {
	local cache_file="$ZSH_CACHE_DIR/last-working-dir"
	[[ -r "$cache_file" ]] && cd "$(cat "$cache_file")"
}

# Jump to last directory automatically unless:
# - this isn't the first time the plugin is loaded
# - it's not in $HOME directory
[[ -n "$ZSH_LAST_WORKING_DIRECTORY" ]] && return
[[ "$PWD" != "$HOME" ]] && return

lwd 2>/dev/null && ZSH_LAST_WORKING_DIRECTORY=1 || true

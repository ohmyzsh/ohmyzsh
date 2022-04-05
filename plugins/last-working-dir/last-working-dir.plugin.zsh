<<<<<<< HEAD
#!/usr/bin/env zsh
# Keeps track of the last used working directory and automatically jumps
# into it for new shells.

# Flag indicating if we've previously jumped to last directory.
typeset -g ZSH_LAST_WORKING_DIRECTORY
mkdir -p $ZSH_CACHE_DIR
cache_file="$ZSH_CACHE_DIR/last-working-dir"

# Updates the last directory once directory is changed.
function chpwd() {
  # Use >| in case noclobber is set to avoid "file exists" error
	pwd >| "$cache_file"
}

# Changes directory to the last working directory.
function lwd() {
	[[ ! -r "$cache_file" ]] || cd "`cat "$cache_file"`"
}

# Automatically jump to last working directory unless this isn't the first time
# this plugin has been loaded.
if [[ -z "$ZSH_LAST_WORKING_DIRECTORY" ]]; then
	lwd 2>/dev/null && ZSH_LAST_WORKING_DIRECTORY=1 || true
fi
=======
# Flag indicating if we've previously jumped to last directory
typeset -g ZSH_LAST_WORKING_DIRECTORY

# Updates the last directory once directory is changed
autoload -U add-zsh-hook
add-zsh-hook chpwd chpwd_last_working_dir
chpwd_last_working_dir() {
  # Don't run in subshells
  [[ "$ZSH_SUBSHELL" -eq 0 ]] || return 0
  # Add ".$SSH_USER" suffix to cache file if $SSH_USER is set and non-empty
  local cache_file="$ZSH_CACHE_DIR/last-working-dir${SSH_USER:+.$SSH_USER}"
  pwd >| "$cache_file"
}

# Changes directory to the last working directory
lwd() {
  # Add ".$SSH_USER" suffix to cache file if $SSH_USER is set and non-empty
  local cache_file="$ZSH_CACHE_DIR/last-working-dir${SSH_USER:+.$SSH_USER}"
  [[ -r "$cache_file" ]] && cd "$(cat "$cache_file")"
}

# Jump to last directory automatically unless:
# - this isn't the first time the plugin is loaded
# - it's not in $HOME directory
[[ -n "$ZSH_LAST_WORKING_DIRECTORY" ]] && return
[[ "$PWD" != "$HOME" ]] && return

lwd 2>/dev/null && ZSH_LAST_WORKING_DIRECTORY=1 || true
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

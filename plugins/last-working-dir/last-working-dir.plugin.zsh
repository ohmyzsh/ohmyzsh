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
  'builtin' 'echo' '-E' "$PWD" >| "$cache_file"
}

# Changes directory to the last working directory
lwd() {
  # Add ".$SSH_USER" suffix to cache file if $SSH_USER is set and non-empty
  local cache_file="$ZSH_CACHE_DIR/last-working-dir${SSH_USER:+.$SSH_USER}"
  [[ -r "$cache_file" ]] && cd "$(<"$cache_file")"
}

# Jump to last directory automatically unless:
#
# - This isn't the first time the plugin is loaded
# - We're not in the $HOME directory (e.g. if terminal opened a different folder)
[[ -z "$ZSH_LAST_WORKING_DIRECTORY" ]] || return
[[ "$PWD" == "$HOME" ]] || return

if lwd 2>/dev/null; then
  ZSH_LAST_WORKING_DIRECTORY=1
fi

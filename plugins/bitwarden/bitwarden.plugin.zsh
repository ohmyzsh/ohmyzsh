if ! (( $+commands[bw] )); then
  return
fi

# bw_login - bitwaredn-cli authentication token helper
#
# - wraps the execution of `bw login`
# - replaces the resulting token to zsh files
#   - in `~/.zshrc` or `$ZSH_CUSTOM/**/*.zsh`
#   - where a `export BW_SESSION=.*$` is found
# - if none is found, it creates a new export BW_SESSION in `~/.zshrc`
# - The arguments `bw login` takes are passed on
# - the function offers the same completions that `bw login` has
#
# This way the BW_SESSION token is available for all new shells
# as well, not just the current.
function bw_login() {
  _bw_session_env_update "$(bw --raw login $@)" "$ZSH_CUSTOM"
}
compdef _bw_login_completions bw_login


# bw_unlock - bitwaredn-cli authentication token helper
#
# - wraps the execution of `bw unlock`
# - replaces the resulting token to zsh files
#   - in `~/.zshrc` or `$ZSH_CUSTOM/**/*.zsh`
#   - where a `export BW_SESSION=.*$` is found
# - if none is found, it appends a new `export BW_SESSION` in `~/.zshrc`
# - The arguments `bw unlock` takes are passed on
# - the function offers the same completions that `bw unlock` has
#
# This way the BW_SESSION token is available for all new shells
# as well, not just the current.
function bw_unlock() {
  _bw_session_env_update "$(bw --raw unlock $@)" "$ZSH_CUSTOM"
}
compdef _bw_unlock_completions bw_unlock

# Refresh all BW_SESSION token exports
#
# Find and replace all exports of BW_SESSION found in `~/.zshrc` or `$ZSH_CUSTOM/**/*.zsh`.
# If none found, it appends it `~/.zshrc`
function _bw_session_env_update() {
  local session_unlock_token="$1"
  local zsh_custom_dir="$2"
  if [[ -z "${session_unlock_token}" ]]; then
    return 1
  fi
  export BW_SESSION="${session_unlock_token}"
  echo "export BW_SESSION: $BW_SESSION"
  local files_with_bw_session="$(grep --files-with-matches 'export BW_SESSION' "${zsh_custom_dir}"/**/*.zsh ${HOME}/.zshrc)"
  local files_count=$(wc -l <<<"$files_with_bw_session")
  if (( files_count > 0 )); then
    for env_export_file in ${files_with_bw_session}; do
      sed -i --follow-symlinks "/export BW_SESSION=/c\export BW_SESSION='$BW_SESSION'" "$env_export_file"
      echo "Replaced export BW_SESSION in $env_export_file"
    done
  else
    echo "export BW_SESSION='$BW_SESSION'" >> $HOME/.zshrc
    echo "added export BW_SESSION in $HOME/.zshrc"
  fi
}

function _bw_login_completions {
  _arguments -C \
    '--method[Two-step login method.]' \
    '--code[Two-step login code.]' \
    '--sso[Log in with Single-Sign On.]' \
    '--apikey[Log in with an Api Key.]' \
    '--passwordenv[Environment variable storing your password]' \
    '--passwordfile[Path to a file containing your password as its first line]'
}

function _bw_unlock_completions {
  _arguments -C \
    '--check[Check lock status.]' \
    '--passwordenv[Environment variable storing your password]' \
    '--passwordfile[Path to a file containing your password as its first line]'
}

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `bw`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_bw" ]]; then
  typeset -g -A _comps
  autoload -Uz _bw
  _comps[bw]=_bw
fi

# Cache bitwarden-cli completions
#
# - Caches the output of `bw completions zsh` to $ZSH_CACHE_DIR/completions/_bw
# - Refreshes when the version of bw changes
function _bw_completions_cache() {
  local bw_version version_cache completion_cache
  version_cache="$ZSH_CACHE_DIR/bw_cached_version"
  completion_cache="$ZSH_CACHE_DIR/completions/_bw"
  bw_version=$(bw -v)
  if ! [ -f "$version_cache" ] || \
     ! [ -f "$completion_cache" ] || \
     [[ $(head -n 1 "$version_cache") != "$bw_version" ]]
  then
    echo "$bw_version" > "$version_cache"
    bw completion --shell zsh >| "$completion_cache" &|
  fi
}
_bw_completions_cache

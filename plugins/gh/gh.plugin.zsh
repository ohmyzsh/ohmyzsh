# Autocompletion for the GitHub CLI (gh).
if (( ! $+commands[gh] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `gh`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_gh" ]]; then
  typeset -g -A _comps
  autoload -Uz _gh
  _comps[gh]=_gh
fi

# Cache gh completions
#
# - Caches the output of `gh completion --shell zsh` to $ZSH_CACHE_DIR/completions/_gh
# - Refreshes when the version of gh changes
function _gh_completions_cache() {
  local gh_version version_cache completion_cache
  version_cache="$ZSH_CACHE_DIR/gh_cached_version"
  completion_cache="$ZSH_CACHE_DIR/completions/_gh"
  gh_version=$(gh --version | awk '{print $3}')
  if ! [ -f "$version_cache" ] || \
     ! [ -f "$completion_cache" ] || \
     [[ $(head -n 1 "$version_cache") != "$gh_version" ]]
  then
    echo "$gh_version" > "$version_cache"
    gh completion --shell zsh >| "$ZSH_CACHE_DIR/completions/_gh" &|
  fi
}
_gh_completions_cache

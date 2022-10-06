if ! (( $+commands[rustup] && $+commands[cargo] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `cargo`. Otherwise, compinit will have already done that
if [[ ! -f "$ZSH_CACHE_DIR/completions/_cargo" ]]; then
  autoload -Uz _cargo
  typeset -g -A _comps
  _comps[cargo]=_cargo
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `rustup`. Otherwise, compinit will have already done that
if [[ ! -f "$ZSH_CACHE_DIR/completions/_rustup" ]]; then
  autoload -Uz _rustup
  typeset -g -A _comps
  _comps[rustup]=_rustup
fi

# Cache rustup completions
#
# - Caches the output of `rustup completions zsh` to $ZSH_CACHE_DIR/completions/_rustup
# - Refreshes when the version of rustc changes
function _rustup_completions_cache() {
  local rustup_version version_cache completion_cache
  version_cache="$ZSH_CACHE_DIR/rustc_cached_version"
  completion_cache="$ZSH_CACHE_DIR/completions/_rustup"
  rustup_version=$(rustc --version)
  if ! [ -f "$version_cache" ] || \
     ! [ -f "$completion_cache" ] || \
     [[ $(head -n 1 "$version_cache") != "$rustup_version" ]]
  then
    echo "$rustup_version" > "$version_cache"
    rustup completions zsh >| "$completion_cache" &|
  fi
}
_rustup_completions_cache

# Cache cargo completions
#
# - Caches cargo's completions to $ZSH_CACHE_DIR/completions/_cargo
# - Refreshes when the version of rustc or cargo changes
function _cargo_completions_cache() {
  local cargo_version version_cache completion_cache
  version_cache="$ZSH_CACHE_DIR/cargo_cached_version"
  completion_cache="$ZSH_CACHE_DIR/completions/_cargo"
  cargo_version="$(rustc --version) $(cargo -V)"
  if ! [ -f "$version_cache" ] || \
     ! [ -f "$completion_cache" ] || \
     [[ $(head -n 1 "$version_cache") != "$cargo_version" ]]
  then
    echo "$cargo_version" > "$version_cache"
    echo '#compdef cargo' > "$completion_cache"
    echo "source $(rustc +${${(z)$(rustup default)}[1]} --print sysroot)/share/zsh/site-functions/_cargo" >> "$completion_cache"
  fi
}
_cargo_completions_cache

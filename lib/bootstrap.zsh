#
# Shared Oh My Zsh bootstrap entrypoint.
#
# This file can be sourced by plugin managers that don't source `oh-my-zsh.sh`.
# It is safe to source multiple times.
#

# Keep source path for callers that invoke omz_bootstrap again later.
typeset -g _OMZ_BOOTSTRAP_SOURCE="${${(%):-%x}:a}"

omz_bootstrap() {
  # If ZSH is not defined, infer from this file location.
  [[ -n "${ZSH:-}" ]] || export ZSH="${_OMZ_BOOTSTRAP_SOURCE:h:h}"

  # Set ZSH_CUSTOM to the path where custom config files and plugins exist.
  [[ -n "${ZSH_CUSTOM:-}" ]] || ZSH_CUSTOM="$ZSH/custom"

  # Set cache directory.
  [[ -n "${ZSH_CACHE_DIR:-}" ]] || ZSH_CACHE_DIR="$ZSH/cache"

  # Ensure cache dir is writable, otherwise fallback to a HOME-based cache.
  if [[ ! -w "$ZSH_CACHE_DIR" ]]; then
    ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
  fi

  # Create cache and completions dir.
  command mkdir -p "$ZSH_CACHE_DIR/completions"

  # Add required OMZ search paths.
  local dir
  for dir in \
    "$ZSH/functions" \
    "$ZSH/completions" \
    "$ZSH_CUSTOM/functions" \
    "$ZSH_CUSTOM/completions" \
    "$ZSH_CACHE_DIR/completions"; do
    (( ${fpath[(Ie)$dir]} )) || fpath=("$dir" $fpath)
  done

  # Public signal: OMZ bootstrap has completed.
  typeset -g OMZ_IS_BOOTSTRAPPED=true
}

omz_bootstrap "$@"

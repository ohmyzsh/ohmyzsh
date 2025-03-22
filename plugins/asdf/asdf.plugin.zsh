if (( $+commands[asdf] )); then
  export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
  path=("$ASDF_DATA_DIR/shims" $path)

  # Create the completion file if it doesn't exist.
  if [[ ! -f "$ZSH_CACHE_DIR/completions/_asdf" ]]; then
    asdf completion zsh >| "$ZSH_CACHE_DIR/completions/_asdf" &|
  fi

  autoload -Uz _asdf
  compdef _asdf asdf

  return
fi

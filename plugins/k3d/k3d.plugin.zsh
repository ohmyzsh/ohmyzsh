if (( $+commands[k3d] )); then
  # If the completion file does not exist, generate it and then source it
  # Otherwise, source it and regenerate in the background
  if [[ ! -f "$ZSH_CACHE_DIR/completions/_k3d" ]]; then
    k3d completion zsh | tee "$ZSH_CACHE_DIR/completions/_k3d" >/dev/null
    source "$ZSH_CACHE_DIR/completions/_k3d"
  else
    source "$ZSH_CACHE_DIR/completions/_k3d"
    k3d completion zsh | tee "$ZSH_CACHE_DIR/completions/_k3d" >/dev/null &|
  fi
fi

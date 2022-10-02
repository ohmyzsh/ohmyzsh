if (( $+commands[k3s] )); then
  # If the completion file does not exist, generate it and then source it
  # Otherwise, source it and regenerate in the background
  if [[ ! -f "$ZSH_CACHE_DIR/completions/_k3s" ]]; then
    k3s completion zsh | tee "$ZSH_CACHE_DIR/completions/_k3s" >/dev/null
    source "$ZSH_CACHE_DIR/completions/_k3s"
  else
    source "$ZSH_CACHE_DIR/completions/_k3s"
    k3s completion zsh | tee "$ZSH_CACHE_DIR/completions/_k3s" >/dev/null &|
  fi
fi

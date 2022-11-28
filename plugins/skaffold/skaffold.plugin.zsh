if (( $+commands[skaffold] )); then
  # If the completion file does not exist, generate it and then source it
  # Otherwise, source it and regenerate in the background
  if [[ ! -f "$ZSH_CACHE_DIR/completions/_skaffold" ]]; then
    skaffold completion zsh | tee "$ZSH_CACHE_DIR/completions/_skaffold" >/dev/null
    source "$ZSH_CACHE_DIR/completions/_skaffold"
  else
    source "$ZSH_CACHE_DIR/completions/_skaffold"
    skaffold completion zsh | tee "$ZSH_CACHE_DIR/completions/_skaffold" >/dev/null &|
  fi
fi

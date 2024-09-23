if (( $+commands[k9s] )); then
  # If the completion file does not exist, generate it and then source it
  # Otherwise, source it and regenerate in the background
  if [[ ! -f "$ZSH_CACHE_DIR/completions/_k9s" ]]; then
    k9s completion zsh | tee "$ZSH_CACHE_DIR/completions/_k9s" >/dev/null
    source "$ZSH_CACHE_DIR/completions/_k9s"
  else
    source "$ZSH_CACHE_DIR/completions/_k9s"
    k9s completion zsh | tee "$ZSH_CACHE_DIR/completions/_k9s" >/dev/null &|
  fi
fi

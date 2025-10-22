if (( $+commands[kubeadm] )); then
  # If the completion file does not exist, generate it and then source it
  # Otherwise, source it and regenerate in the background
  if [[ ! -f "$ZSH_CACHE_DIR/completions/_kubeadm" ]]; then
    kubeadm completion zsh | tee "$ZSH_CACHE_DIR/completions/_kubeadm" >/dev/null
    source "$ZSH_CACHE_DIR/completions/_kubeadm"
  else
    source "$ZSH_CACHE_DIR/completions/_kubeadm"
    kubeadm completion zsh | tee "$ZSH_CACHE_DIR/completions/_kubeadm" >/dev/null &|
  fi
fi

# Autocompletion for the Istio CLI (istioctl).
if (( ! $+commands[istioctl] )); then
  return
fi

# If the completion file does not exist, generate it and then source it
# Otherwise, source it and regenerate in the background
if [[ ! -f "$ZSH_CACHE_DIR/completions/_istioctl" ]]; then
  istioctl completion zsh | tee "$ZSH_CACHE_DIR/completions/_istioctl" >/dev/null
  source "$ZSH_CACHE_DIR/completions/_istioctl"
else
  source "$ZSH_CACHE_DIR/completions/_istioctl"
  zmodload -F zsh/files b:zf_mv
  () {
    local TMPPREFIX="$ZSH_CACHE_DIR/completions/._istioctl"
    zf_mv -f -- =( istioctl completion zsh ) "$ZSH_CACHE_DIR/completions/_istioctl"
  } &|
fi

# Autocompletion for the Kubernetes Operations CLI (kops).
if (( ! $+commands[kops] )); then
  return
fi

# If the completion file does not exist, generate it and then source it
# Otherwise, source it and regenerate in the background
if [[ ! -f "$ZSH_CACHE_DIR/completions/_kops" ]]; then
  kops completion zsh | tee "$ZSH_CACHE_DIR/completions/_kops" >/dev/null
  source "$ZSH_CACHE_DIR/completions/_kops"
else
  source "$ZSH_CACHE_DIR/completions/_kops"
  zmodload -F zsh/files b:zf_mv
  () {
    local TMPPREFIX="$ZSH_CACHE_DIR/completions/._kops"
    zf_mv -f -- =( kops completion zsh ) "$ZSH_CACHE_DIR/completions/_kops"
  } &|
fi

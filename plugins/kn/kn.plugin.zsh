# Autocompletion for kn, the command line interface for Knative.
#
# Author: https://github.com/btannous

if (( ! $+commands[kn] )); then
  return
fi

# If the completion file does not exist, generate it and then source it
# Otherwise, source it and regenerate in the background
if [[ ! -f "$ZSH_CACHE_DIR/completions/_kn" ]]; then
  kn completion zsh | tee "$ZSH_CACHE_DIR/completions/_kn" >/dev/null
  source "$ZSH_CACHE_DIR/completions/_kn"
else
  source "$ZSH_CACHE_DIR/completions/_kn"
  zmodload -F zsh/files b:zf_mv
  () {
    local TMPPREFIX="$ZSH_CACHE_DIR/completions/._kn"
    zf_mv -f -- =( kn completion zsh ) "$ZSH_CACHE_DIR/completions/_kn"
  } &|
fi

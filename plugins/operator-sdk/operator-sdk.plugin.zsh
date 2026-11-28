# Autocompletion for the Operator SDK CLI (operator-sdk).
if (( ! $+commands[operator-sdk] )); then
  return
fi

# If the completion file does not exist, generate it and then source it
# Otherwise, source it and regenerate in the background
if [[ ! -f "$ZSH_CACHE_DIR/completions/_operator-sdk" ]]; then
  operator-sdk completion zsh | tee "$ZSH_CACHE_DIR/completions/_operator-sdk" >/dev/null
  source "$ZSH_CACHE_DIR/completions/_operator-sdk"
else
  source "$ZSH_CACHE_DIR/completions/_operator-sdk"
  zmodload -F zsh/files b:zf_mv
  () {
    local TMPPREFIX="$ZSH_CACHE_DIR/completions/._operator-sdk"
    zf_mv -f -- =( operator-sdk completion zsh ) "$ZSH_CACHE_DIR/completions/_operator-sdk"
  } &|
fi

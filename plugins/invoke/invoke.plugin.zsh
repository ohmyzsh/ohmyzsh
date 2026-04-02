# Autocompletion for the Invoke CLI (invoke).
if (( ! $+commands[invoke] )); then
  return
fi

# If the completion file does not exist, generate it and then source it
# Otherwise, source it and regenerate in the background
if [[ ! -f "$ZSH_CACHE_DIR/completions/_invoke" ]]; then
  invoke --print-completion-script=zsh | tee "$ZSH_CACHE_DIR/completions/_invoke" >/dev/null
  source "$ZSH_CACHE_DIR/completions/_invoke"
else
  source "$ZSH_CACHE_DIR/completions/_invoke"
  zmodload -F zsh/files b:zf_mv
  () {
    local TMPPREFIX="$ZSH_CACHE_DIR/completions/._invoke"
    zf_mv -f -- =( invoke --print-completion-script=zsh ) "$ZSH_CACHE_DIR/completions/_invoke"
  } &|
fi

# Autocompletion for the Service Catalog CLI (svcat).
if (( ! $+commands[svcat] )); then
  return
fi

# If the completion file does not exist, generate it and then source it
# Otherwise, source it and regenerate in the background
if [[ ! -f "$ZSH_CACHE_DIR/completions/_svcat" ]]; then
  svcat completion zsh | tee "$ZSH_CACHE_DIR/completions/_svcat" >/dev/null
  source "$ZSH_CACHE_DIR/completions/_svcat"
else
  source "$ZSH_CACHE_DIR/completions/_svcat"
  zmodload -F zsh/files b:zf_mv
  () {
    local TMPPREFIX="$ZSH_CACHE_DIR/completions/._svcat"
    zf_mv -f -- =( svcat completion zsh ) "$ZSH_CACHE_DIR/completions/_svcat"
  } &|
fi

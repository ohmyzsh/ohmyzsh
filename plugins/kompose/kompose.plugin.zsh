# Autocompletion for the Kompose CLI (kompose).
if (( ! $+commands[kompose] )); then
  return
fi

# If the completion file does not exist, generate it and then source it
# Otherwise, source it and regenerate in the background
if [[ ! -f "$ZSH_CACHE_DIR/completions/_kompose" ]]; then
  kompose completion zsh | tee "$ZSH_CACHE_DIR/completions/_kompose" >/dev/null
  source "$ZSH_CACHE_DIR/completions/_kompose"
else
  source "$ZSH_CACHE_DIR/completions/_kompose"
  zmodload -F zsh/files b:zf_mv
  () {
    local TMPPREFIX="$ZSH_CACHE_DIR/completions/._kompose"
    zf_mv -f -- =( kompose completion zsh ) "$ZSH_CACHE_DIR/completions/_kompose"
  } &|
fi

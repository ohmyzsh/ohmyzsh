# Autocompletion for the Please build system CLI (plz).
if (( ! $+commands[plz] )); then
  return
fi

# If the completion file does not exist, generate it and then source it
# Otherwise, source it and regenerate in the background
if [[ ! -f "$ZSH_CACHE_DIR/completions/_plz" ]]; then
  plz --completion_script | tee "$ZSH_CACHE_DIR/completions/_plz" >/dev/null
  source "$ZSH_CACHE_DIR/completions/_plz"
else
  source "$ZSH_CACHE_DIR/completions/_plz"
  zmodload -F zsh/files b:zf_mv
  () {
    local TMPPREFIX="$ZSH_CACHE_DIR/completions/._plz"
    zf_mv -f -- =( plz --completion_script ) "$ZSH_CACHE_DIR/completions/_plz"
  } &|
fi

alias pb='plz build'
alias pt='plz test'
alias pw='plz watch'

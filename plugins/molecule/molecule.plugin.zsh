if (( ! $+commands[molecule] )); then
  return
fi

# If the completion file does not exist, generate it and then source it
# Otherwise, source it and regenerate in the background
if [[ ! -f "$ZSH_CACHE_DIR/completions/_molecule" ]]; then
  _MOLECULE_COMPLETE=zsh_source molecule | tee "$ZSH_CACHE_DIR/completions/_molecule" >/dev/null
  source "$ZSH_CACHE_DIR/completions/_molecule"
else
  source "$ZSH_CACHE_DIR/completions/_molecule"
  _MOLECULE_COMPLETE=zsh_source molecule | tee "$ZSH_CACHE_DIR/completions/_molecule" >/dev/null &|
fi

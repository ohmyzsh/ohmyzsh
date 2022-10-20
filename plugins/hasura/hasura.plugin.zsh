if (( ! $+commands[hasura] )); then
  return
fi

# If the completion file does not exist, generate it and then source it
# Otherwise, source it and regenerate in the background
if [[ ! -f "$ZSH_CACHE_DIR/completions/_hasura" ]]; then
  helm completion zsh --file "$ZSH_CACHE_DIR/completions/_hasura" >/dev/null
  source "$ZSH_CACHE_DIR/completions/_hasura"
else
  source "$ZSH_CACHE_DIR/completions/_hasura"
  helm completion zsh --file "$ZSH_CACHE_DIR/completions/_hasura" >/dev/null &|
fi

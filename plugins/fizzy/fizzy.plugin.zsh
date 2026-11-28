# Autocompletion for the Fizzy CLI (fizzy).
if (( ! $+commands[fizzy] )); then
  return
fi

# If the completion isn't registered yet, autoload it and bind it to `fizzy`.
# Otherwise, compinit will have already done that from the cache.
if [[ -z ${_comps[fizzy]-} ]]; then
  typeset -g -A _comps
  autoload -Uz _fizzy
  _comps[fizzy]=_fizzy
fi

zmodload -F zsh/files b:zf_mv || return
() {
  local cache_file="$ZSH_CACHE_DIR/completions/_fizzy"
  local temp_file
  temp_file=$(mktemp "$ZSH_CACHE_DIR/completions/._fizzy.XXXXXXXX") || return
  if command fizzy completion zsh >| "$temp_file" && [[ -s "$temp_file" ]] &&
    zf_mv -f -- "$temp_file" "$cache_file"; then
    return
  fi
  rm -f -- "$temp_file"
} &|

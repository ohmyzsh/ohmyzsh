if (( ! $+commands[mise] )); then
  return
fi

# Load mise hooks
eval "$(mise activate zsh)"

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `mise`. Otherwise, compinit will have already done that.
local comp_file="$ZSH_CACHE_DIR/completions/_mise"

if [[ ! -f "$comp_file" ]]; then
  typeset -g -A _comps
  autoload -Uz _mise
  _comps[mise]=_mise
fi

# Generate completion only when missing/empty or stale.
if [[ ! -s "$comp_file" || "$commands[mise]" -nt "$comp_file" ]]; then
  mise completion zsh >| "$comp_file" &|
fi

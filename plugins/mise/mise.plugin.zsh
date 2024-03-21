# TODO: 2024-01-03 remove rtx support
local __mise=mise
if (( ! $+commands[mise] )); then
  if (( $+commands[rtx] )); then
    __mise=rtx
  else
    return
  fi
fi

# Load mise hooks
eval "$($__mise activate zsh)"

# Hook mise into current environment
eval "$($__mise hook-env -s zsh)"

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `mise`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_$__mise" ]]; then
  typeset -g -A _comps
  autoload -Uz _$__mise
  _comps[$__mise]=_$__mise
fi

# Generate and load mise completion
$__mise completion zsh >| "$ZSH_CACHE_DIR/completions/_$__mise" &|

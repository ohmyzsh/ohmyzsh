# COMPLETION FUNCTION
if (( ! $+commands[volta] )); then
  return
fi

# TODO: 2021-12-28: remove this bit of code as it exists in oh-my-zsh.sh
# Add completions folder in $ZSH_CACHE_DIR
command mkdir -p "$ZSH_CACHE_DIR/completions"
(( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `deno`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_volta" ]]; then
  typeset -g -A _comps
  autoload -Uz _volta
  _comps[volta]=_volta
fi

volta completions zsh >| "$ZSH_CACHE_DIR/completions/_volta" &|

if (( ! $+commands[helm] )); then
  return
fi

# TODO: 2021-12-28: delete this block
# Remove old generated file
command rm -f "${ZSH_CACHE_DIR}/helm_completion"

# TODO: 2021-12-28: remove this bit of code as it exists in oh-my-zsh.sh
# Add completions folder in $ZSH_CACHE_DIR
command mkdir -p "$ZSH_CACHE_DIR/completions"
(( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `helm`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_helm" ]]; then
  typeset -g -A _comps
  autoload -Uz _helm
  _comps[helm]=_helm
fi

helm completion zsh >| "$ZSH_CACHE_DIR/completions/_helm" &|

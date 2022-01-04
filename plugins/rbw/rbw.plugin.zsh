if (( ! $+commands[rbw] )); then
  return
fi

# TODO: 2021-12-28: remove this bit of code as it exists in oh-my-zsh.sh
# Add completions folder in $ZSH_CACHE_DIR
command mkdir -p "$ZSH_CACHE_DIR/completions"
(( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)


# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `rbw`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_rbw" ]]; then
  declare -A _comps
  autoload -Uz _rbw
  _comps[rbw]=_rbw
fi

rbw gen-completions zsh >| "$ZSH_CACHE_DIR/completions/_rbw" &|

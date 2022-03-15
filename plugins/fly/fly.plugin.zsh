# Autocompletion for the Concourse CLI (fly).
if (( ! $+commands[fly] )); then
  return
fi

# TODO: 2021-12-28: remove this block
# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"
# Remove old generated files
command rm -f "${0:A:h}/_fly" "$ZSH_CACHE_DIR/fly_version"

# TODO: 2021-12-28: remove this bit of code as it exists in oh-my-zsh.sh
# Add completions folder in $ZSH_CACHE_DIR
command mkdir -p "$ZSH_CACHE_DIR/completions"
(( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `fly`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_fly" ]]; then
  typeset -g -A _comps
  autoload -Uz _fly
  _comps[fly]=_fly
fi

fly completion --shell zsh >| "$ZSH_CACHE_DIR/completions/_fly" &|

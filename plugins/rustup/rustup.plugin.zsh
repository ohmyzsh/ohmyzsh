if (( ! $+commands[rustup] )); then
  return
fi

# Remove old generated completion file
# TODO: 2021-09-15: remove this line
command rm -f "${0:A:h}/_rustup"

# Add completions/ folder in $ZSH_CACHE_DIR
comp_file="$ZSH_CACHE_DIR/completions/_rustup"
command mkdir -p "${comp_file:h}"
(( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `rustup`. Otherwise, compinit will have already done that
if [[ ! -f "$comp_file" ]]; then
  autoload -Uz _rustup
  declare -A _comps
  _comps[rustup]=_rustup
fi

# Generate completion file in the background
rustup completions zsh >| "$comp_file" &|
unset comp_file

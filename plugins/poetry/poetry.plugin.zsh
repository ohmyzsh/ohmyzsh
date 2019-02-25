# Return immediately if poetry is not found
if ! $(command -v poetry >/dev/null) ; then
  return
fi

local directory=${0:h}

# Create completion file if it does not exist,
# # or if poetry version changes
if ! [[ -e "$directory/_poetry" && 
        -e "$directory/VERSION.lock" &&
        "$(poetry -V)" == "$(<$directory/VERSION.lock)" ]]; then
  poetry -V > $directory/VERSION.lock
  poetry completions zsh > $directory/_poetry
  update_completions  # Defined in Oh My Zsh core, in lib/compfix.zsh
fi

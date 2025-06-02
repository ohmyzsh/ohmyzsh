alias gemb="gem build *.gemspec"
alias gemp="gem push *.gem"

# gemy GEM 0.0.0 = gem yank GEM -v 0.0.0
function gemy {
	gem yank $1 -v $2
}

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `gem`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_gem" ]]; then
  typeset -g -A _comps
  autoload -Uz _gem
  _comps[gem]=_gem
fi

# zsh 5.5 already provides completion for `_gem`. With this we ensure that
# our provided completion (which is not optimal but is enough in most cases)
# is used for older versions
autoload -Uz is-at-least
if is-at-least 5.5; then
  return 0
fi

{
  # Standardized $0 handling
  # https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
  0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
  0="${${(M)0:#/*}:-$PWD/$0}"

  command cp -f "${0:h}/completions/_gem" "$ZSH_CACHE_DIR/completions/_gem"
} &|

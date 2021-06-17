# Autocompletion for the GitHub CLI (gh).

if (( $+commands[gh] )); then
  if [[ ! -r "$ZSH_CACHE_DIR/gh_version" \
    || "$(gh --version)" != "$(< "$ZSH_CACHE_DIR/gh_version")"
    || ! -f "$ZSH/plugins/gh/_gh" ]]; then
    gh completion --shell zsh > $ZSH/plugins/gh/_gh
    gh --version > $ZSH_CACHE_DIR/gh_version
  fi
  autoload -Uz _gh
  _comps[gh]=_gh
fi


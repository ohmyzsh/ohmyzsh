# Automatic poetry environment activation/deactivation
_togglePoetryShell() {
  # deactivate environment if pyproject.toml doesn't exist and not in a subdir
  if [[ ! -f "$PWD/pyproject.toml" ]] ; then
    if [[ "$poetry_active" == 1 ]]; then
      if [[ "$PWD" != "$poetry_dir"* ]]; then
        export poetry_active=0
        deactivate
        return
      fi
    fi
  fi

  # activate the environment if pyproject.toml exists
  if [[ "$poetry_active" != 1 ]]; then
    if [[ -f "$PWD/pyproject.toml" ]]; then
      if grep -q 'tool.poetry' "$PWD/pyproject.toml"; then
        export poetry_active=1
        export poetry_dir="$PWD"
        source "$(poetry env info --path)/bin/activate"
      fi
    fi
  fi
}
autoload -U add-zsh-hook
add-zsh-hook chpwd _togglePoetryShell
_togglePoetryShell

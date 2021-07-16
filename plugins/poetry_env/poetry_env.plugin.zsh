# Automatic poetry shell activation/deactivation
_togglePoetryShell() {
  # deactivate shell if pyproject.toml doesn't exist and not in a subdir
  if [[ ! -f "$PWD/pyproject.toml" ]] ; then
    if [[ "$POETRY_ACTIVE" == 1 ]]; then
      if [[ "$PWD" != "$poetry_dir"* ]]; then
        exit
      fi
    fi
  fi

  # activate the shell if pyproject.toml exists
  if [[ "$POETRY_ACTIVE" != 1 ]]; then
    if [[ -f "$PWD/pyproject.toml" ]]; then
      if grep -q 'tool.poetry' "$PWD/pyproject.toml"; then
        export poetry_dir="$PWD"
        source "$( poetry env list --full-path | grep Activated | cut -d' ' -f1 )/bin/activate"
      fi
    fi
  fi
}
autoload -U add-zsh-hook
add-zsh-hook chpwd _togglePoetryShell
_togglePoetryShell

if (( ! $+commands[pipenv] )); then
  return
fi

# Compatibility note:
# pipenv < 2026.5.0 used Click-based shell completion driven by the
# _PIPENV_COMPLETE environment variable.
#
# pipenv >= 2026.5.0 removed this mechanism and switched to argcomplete-based
# completion using register-python-argcomplete instead.

autoload -Uz is-at-least

_pipenv_version_cache="$ZSH_CACHE_DIR/pipenv_version"

if [[ -f "$_pipenv_version_cache" ]]; then
  _pipenv_version="$(< "$_pipenv_version_cache" 2>/dev/null)"
else
  _pipenv_version="${$(pipenv --version 2>/dev/null)#pipenv, version }"
fi

{
  _pipenv_fresh_version="${$(pipenv --version 2>/dev/null)#pipenv, version }"
  [[ -n "$_pipenv_fresh_version" ]] && print -r -- "$_pipenv_fresh_version" >| "$_pipenv_version_cache"
} &|

if is-at-least 2026.5.0 "$_pipenv_version"; then
  # pipenv >= 2026.5.0: argcomplete-based completion (no legacy fallback)
  if (( $+commands[register-python-argcomplete] )); then
    autoload -Uz bashcompinit
    bashcompinit

    eval "$(register-python-argcomplete pipenv)"
  fi
else
  # legacy Click-based completion via _PIPENV_COMPLETE

  # If the completion file doesn't exist yet, we need to autoload it and
  # bind it to `pipenv`. Otherwise, compinit will have already done that.
  if [[ ! -f "$ZSH_CACHE_DIR/completions/_pipenv" ]]; then
    typeset -g -A _comps
    autoload -Uz _pipenv
    _comps[pipenv]=_pipenv
  fi

  zmodload -F zsh/files b:zf_mv
  () {
    local TMPPREFIX="$ZSH_CACHE_DIR/completions/_pipenv"
    zf_mv -f -- =( _PIPENV_COMPLETE=zsh_source pipenv ) "$TMPPREFIX"
  } &|
fi

if zstyle -T ':omz:plugins:pipenv' auto-shell; then
  # Automatic pipenv shell activation/deactivation
  _togglePipenvShell() {
    # deactivate shell if Pipfile doesn't exist and not in a subdir
    if [[ ! -f "$PWD/Pipfile" ]]; then
      if [[ "$PIPENV_ACTIVE" == 1 ]]; then
        # Compare whole path components: `$pipfile_dir"*` also matches unrelated
        # siblings that merely start with the same text (…/proj -> …/proj-docs),
        # which would keep the virtualenv active outside the project.
        local project_dir="${pipfile_dir%/}"
        if [[ "$PWD" != "$project_dir" && "$PWD" != "$project_dir"/* ]]; then
          unset PIPENV_ACTIVE pipfile_dir
          deactivate
        fi
      fi
    fi

    # activate the shell if Pipfile exists and its virtualenv is usable
    if [[ "$PIPENV_ACTIVE" != 1 ]]; then
      if [[ -f "$PWD/Pipfile" ]]; then
        local venv_path
        if venv_path="$(pipenv --venv 2>/dev/null)" && [[ -n "$venv_path" && -f "$venv_path/bin/activate" ]]; then
          export pipfile_dir="$PWD"
          source "$venv_path/bin/activate"
          export PIPENV_ACTIVE=1
        fi
      fi
    fi
  }

  autoload -U add-zsh-hook
  add-zsh-hook chpwd _togglePipenvShell
  _togglePipenvShell
fi

# Aliases
alias pch="pipenv check"
alias pcl="pipenv clean"
alias pgr="pipenv graph"
alias pi="pipenv install"
alias pidev="pipenv install --dev"
alias pl="pipenv lock"
alias po="pipenv open"
alias prun="pipenv run"
alias psh="pipenv shell"
alias psy="pipenv sync"
alias pu="pipenv uninstall"
alias pupd="pipenv update"
alias pwh="pipenv --where"
alias pvenv="pipenv --venv"
alias ppy="pipenv --py"

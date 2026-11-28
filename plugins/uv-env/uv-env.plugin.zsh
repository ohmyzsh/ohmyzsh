_toggleUvShell() {
  local in_uv_dir=0
  if [[ -f "$PWD/pyproject.toml" && -f "$PWD/uv.lock" ]]; then
    in_uv_dir=1
  fi

  if [[ $uv_active -eq 1 ]] && { [[ $in_uv_dir -eq 0 ]] || [[ "$PWD" != "$uv_dir" && "$PWD" != "$uv_dir"/* ]]; }; then
    typeset -g uv_active=0
    unset uv_dir
    (( $+functions[deactivate] )) && deactivate
  fi

  if [[ $in_uv_dir -eq 1 ]] && [[ $uv_active -ne 1 ]]; then
    local venv_dir="${UV_PROJECT_ENVIRONMENT:-$PWD/.venv}"
    [[ "$venv_dir" != /* ]] && venv_dir="$PWD/$venv_dir"

    if [[ -f "${venv_dir}/bin/activate" ]]; then
      typeset -g uv_active=1
      typeset -g uv_dir="$PWD"
      source "${venv_dir}/bin/activate"
    fi
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd _toggleUvShell
_toggleUvShell

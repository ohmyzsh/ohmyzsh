# set python command if 'py' not installed
builtin which py > /dev/null || alias py='python3'

# Find python file
alias pyfind='find . -name "*.py"'

# Remove python compiled byte-code and mypy/pytest cache in either the current
# directory or in a list of specified directories (including sub directories).
function pyclean() {
  find "${@:-.}" -type f -name "*.py[co]" -delete
  find "${@:-.}" -type d -name "__pycache__" -delete
  find "${@:-.}" -depth -type d -name ".mypy_cache" -exec rm -r "{}" +
  find "${@:-.}" -depth -type d -name ".pytest_cache" -exec rm -r "{}" +
}

# Add the user installed site-packages paths to PYTHONPATH, only if the
#   directory exists. Also preserve the current PYTHONPATH value.
# Feel free to autorun this when .zshrc loads.
function pyuserpaths() {
  setopt localoptions extendedglob

  # Check for a non-standard install directory.
  local user_base="${PYTHONUSERBASE:-"${HOME}/.local"}"

  local python version site_pkgs
  for python in python2 python3; do
    # Check if command exists
    (( ${+commands[$python]} )) || continue

    # Get minor release version.
    # The patch version is variable length, truncate it.
    version=${(M)${"$($python -V 2>&1)":7}#[^.]##.[^.]##}

    # Add version specific path, if:
    # - it exists in the filesystem
    # - it isn't in $PYTHONPATH already.
    site_pkgs="${user_base}/lib/python${version}/site-packages"
    [[ -d "$site_pkgs" && ! "$PYTHONPATH" =~ (^|:)"$site_pkgs"(:|$) ]] || continue
    export PYTHONPATH="${site_pkgs}${PYTHONPATH+":${PYTHONPATH}"}"
  done
}

# Grep among .py files
alias pygrep='grep -nr --include="*.py"'

# Share local directory as a HTTP server
alias pyserver="python3 -m http.server"

: ${PYTHON_VENV_NAME:=venv}

# Activate the first valid Python virtual environment from a list.
function vrun() {
  local venv_list=("${PYTHON_VENV_NAME}")
  local venvpath

  # Loop through potential venv names
  for name in "${venv_list[@]}"; do
    venvpath="${PWD}/${name}"
    
    if [[ -d "$venvpath" && -f "${venvpath}/bin/activate" ]]; then
      . "${venvpath}/bin/activate" || return $?
      echo "Activated virtual environment ${name}"
      return 0
    fi
  done

  echo >&2 "Error: No valid virtual environment found in the list: ${PYTHON_VENV_NAME[*]}"
  return 1
}

# Create a new virtual environment with the specified name or the first in the list.
function mkv() {
  local name="${1:-${PYTHON_VENV_NAME%% *}}"
  local venvpath="${PWD}/${name}"

  python3 -m venv "${name}" || return
  echo >&2 "Created venv in '${venvpath}'"

  # Activate directly without relying on vrun
  if [[ -f "${venvpath}/bin/activate" ]]; then
    . "${venvpath}/bin/activate" || return $?
    echo "Activated virtual environment ${name}"
  else
    echo >&2 "Error: Failed to activate the virtual environment in '${venvpath}'"
    return 1
  fi
}


if [[ "$PYTHON_AUTO_VRUN" == "true" ]]; then
  function auto_vrun() {
    local current_dir="$PWD"
    local active_venv="${VIRTUAL_ENV}"
    local venv_root=""

    # Determine the root of the currently active virtual environment
    if [[ -n "$active_venv" ]]; then
      venv_root="${VIRTUAL_ENV%/bin*}"
    fi

    # Deactivate if leaving the root directory of the virtual environment
    if [[ -n "$active_venv" ]] && [[ "$current_dir" != "$venv_root"* ]]; then
      deactivate > /dev/null 2>&1
      active_venv=""
    fi

    # Activate the virtual environment if not active and found in the current directory or its ancestors
    if [[ -z "$active_venv" ]]; then
      local dir="$PWD"
      while [[ "$dir" != "/" ]]; do
        for _venv_name in "${PYTHON_VENV_NAME[@]}"; do
          local activate_script="${dir}/${_venv_name}/bin/activate"
          if [[ -f "$activate_script" ]]; then
            source "$activate_script" > /dev/null 2>&1
            return
          fi
        done
        dir="$(dirname "$dir")"
      done
    fi
  }

  # Hook to execute the function on directory changes
  add-zsh-hook chpwd auto_vrun
  auto_vrun  # Run once for the current directory
fi

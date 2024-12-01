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
  vrun "${name}"
}

if [[ "$PYTHON_AUTO_VRUN" == "true" ]]; then
  # Automatically activate the first valid venv and deactivate if leaving its root directory
  function auto_vrun() {
    # If we're inside a virtual environment, check if we're leaving its root
    if [[ -n "${VIRTUAL_ENV}" ]]; then
      local venv_root="${VIRTUAL_ENV%/bin*}"  # Extract the root directory of the virtual environment
      # Deactivate if we are outside the root directory of the virtual environment
      if [[ "$PWD" != "$venv_root"* ]]; then
        echo "Deactivating virtual environment"
        deactivate > /dev/null 2>&1
      fi
    fi

    # Attempt to activate a venv from the list in the current directory
    for _venv_name in "${PYTHON_VENV_NAME[@]}"; do
      local activate_script="${PWD}/${_venv_name}/bin/activate"
      if [[ -f "${activate_script}" ]]; then
        source "${activate_script}" > /dev/null 2>&1
        echo "Automatically activated virtual environment ${_venv_name}"
        return 0
      fi
    done
  }
  add-zsh-hook chpwd auto_vrun
  auto_vrun
fi

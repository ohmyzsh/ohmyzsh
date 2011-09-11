# Inspired by Christopher Sexton's
# https://gist.github.com/1019777
#
# Sorin Ionescu <sorin.ionescu@gmail.com>

# Gets the root of the Rack application.
function _pow-rack-root() {
  local rack_root="${PWD}"

  while [[ "${rack_root}" != '/' ]]; do
    # Rack applictions must have a config.ru file in the root directory.
    if [[ -f "${rack_root}/config.ru" ]]; then
      echo "${rack_root}"
      return 0
    else
      rack_root="${rack_root:h}"
    fi
  done

  return 1
}

# Adds a Rack application to Pow.
function pow-add() {
  local app="${${1:A}:-$(_pow-rack-root)}"
  local vhost="${app:t}"

  if [[ ! -f "${app}/config.ru" ]]; then
    echo "${0}: ${vhost:-$PWD:t}: not a Rack application or config.ru is missing" >&2
    return 1
  fi

  if [[ -L "${HOME}/.pow/${vhost}" ]]; then
    echo "${0}: ${vhost}: already served at http://${vhost}.dev"
    return 1
  fi

  ln -s "${app}" "${HOME}/.pow/${vhost}"
  echo "Serving ${vhost} at http://${vhost}.dev"
}

# Removes a Rack application from Pow.
function pow-remove() {
  local symlink="${HOME}/.pow/${1}"
  if [[ -L "${symlink}" ]]; then
    unlink "${symlink}"
    echo "Stopped serving ${1}"
  else
    echo "${0}: ${1}: no such application" >&2
  fi
}

# Restarts a Rack application.
function pow-restart() {
  local vhost="${${1}:-$(_pow-rack-root):t}"
  local tmp="${HOME}/.pow/${vhost}/tmp"

  if [[ ! -L "${HOME}/.pow/${vhost}" ]]; then
    echo "${0}: ${1}: no such application" >&2
    return 1
  fi

  if [[ ! -d "${tmp}" ]]; then
    mkdir -p "${tmp}"
  fi

  if touch "${tmp}/restart.txt"; then
    echo "Restarted ${vhost}"
  fi
}

# Aliases
# View the standard out (puts) from any pow application.
alias pow-log="tail -f ${HOME}/Library/Logs/Pow/apps/*"


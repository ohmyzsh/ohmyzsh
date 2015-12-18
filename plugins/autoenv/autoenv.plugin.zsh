# autoenv.plugin.zsh

# Initialization: activate autoenv or report its absence
() {
local d autoenv_dir install_locations
if ! type autoenv_init >/dev/null; then
  # Locate autoenv installation
  install_locations=(
    ~/.autoenv
    ~/.local/bin
    ~/Library/Python/bin
  )
  if (( $+commands[brew] )); then
    install_locations+=$(brew --prefix)/opt/autoenv
  fi
  (( $+commands[activate.sh] )) && autoenv_dir="${commands[activate.sh]:h}"
  if [[ -z $autoenv_dir ]]; then
    for d ( $install_locations ); do
      if [[ -e $d/activate.sh ]]; then
        autoenv_dir=$d
        break
      fi
    done
  fi

  # Complain if autoenv is not installed
  if [[ -z $autoenv_dir ]]; then 
    cat <<END >&2
-------- AUTOENV ---------
Could not locate autoenv installation.
Please check if autoenv is correctly installed.
In the meantime the autoenv plugin is DISABLED.
--------------------------
END
    return 1
  fi
  # Load autoenv
  source $autoenv_dir/activate.sh
fi
}
[[ $? != 0 ]] && return $?

# The use_env call below is a reusable command to activate/create a new Python
# virtualenv, requiring only a single declarative line of code in your .env files.
# It only performs an action if the requested virtualenv is not the current one.

use_env() {
  local venv
  venv="$1"
  if [[ "${VIRTUAL_ENV:t}" != "$venv" ]]; then
    if workon | grep -q "$venv"; then
      workon "$venv"
    else
      echo -n "Create virtualenv $venv now? (Yn) "
      read answer
      if [[ "$answer" == "Y" ]]; then
        mkvirtualenv "$venv"
      fi
    fi
  fi
}



<<<<<<< HEAD
# Activates autoenv or reports its failure
if ! source $HOME/.autoenv/activate.sh 2>/dev/null; then
  echo '-------- AUTOENV ---------'
  echo 'Could not find ~/.autoenv/activate.sh.'
  echo 'Please check if autoenv is correctly installed.'
  echo 'In the meantime the autoenv plugin is DISABLED.'
  echo '--------------------------'
  return 1
fi
=======
# Initialization: activate autoenv or report its absence
() {
local d autoenv_dir install_locations
if ! type autoenv_init >/dev/null; then
  # Check if activate.sh is in $PATH
  if (( $+commands[activate.sh] )); then
    autoenv_dir="${commands[activate.sh]:h}"
  fi

  # Locate autoenv installation
  if [[ -z $autoenv_dir ]]; then
    install_locations=(
      ~/.autoenv
      ~/.local/bin
      /usr/local/opt/autoenv
      /opt/homebrew/opt/autoenv
      /usr/local/bin
      /usr/share/autoenv-git
      ~/Library/Python/bin
    )
    for d ( $install_locations ); do
      if [[ -e $d/activate.sh ]]; then
        autoenv_dir=$d
        break
      fi
    done
  fi

  # Look for Homebrew path as a last resort
  if [[ -z "$autoenv_dir" ]] && (( $+commands[brew] )); then
    d=$(brew --prefix)/opt/autoenv
    if [[ -e $d/activate.sh ]]; then
      autoenv_dir=$d
    fi
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
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

# The use_env call below is a reusable command to activate/create a new Python
# virtualenv, requiring only a single declarative line of code in your .env files.
# It only performs an action if the requested virtualenv is not the current one.

use_env() {
<<<<<<< HEAD
    typeset venv
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
=======
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
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
}

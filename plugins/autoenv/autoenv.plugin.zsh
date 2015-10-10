# Activates autoenv or reports its failure
() {
if ! type autoenv_init >/dev/null; then
  for d (~/.autoenv /usr/local/opt/autoenv); do
    if [[ -e $d/activate.sh ]]; then
      autoenv_dir=$d
      break
    fi
  done
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
  source $autoenv_dir/activate.sh
fi
}
[[ $? != 0 ]] && return $?

# The use_env call below is a reusable command to activate/create a new Python
# virtualenv, requiring only a single declarative line of code in your .env files.
# It only performs an action if the requested virtualenv is not the current one.

use_env() {
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
}

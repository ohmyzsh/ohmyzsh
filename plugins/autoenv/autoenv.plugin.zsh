# Add the functions from autoenv if it's installed.
if [ -r ~/.autoenv/activate.sh ]; then
    source ~/.autoenv/activate.sh
    # Use a zsh hook instead of overriding the builtin cd.
    unset -f cd
    add-zsh-hook chpwd autoenv_init
fi

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

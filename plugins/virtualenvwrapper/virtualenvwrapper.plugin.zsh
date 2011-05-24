DEFAULT_VIRTUALENV_WRAPPERS=(
    "/usr/local/bin/virtualenvwrapper.sh" # Default install location
    "/etc/bash_completion.d/virtualenvwrapper" # Ubuntu install location
    )
for VIRTUALENV_WRAPPER in $DEFAULT_VIRTUALENV_WRAPPERS
do
    if [[ -s "${VIRTUALENV_WRAPPER}" ]]; then
        break
    fi
done

if [[ ! -n "${VIRTUALENV_WRAPPER}" ]] && [[ -s "${DEFAULT_VIRTUALENV_WRAPPER}" ]]; then
    VIRTUALENV_WRAPPER=${DEFAULT_VIRTUALENV_WRAPPER}
fi

if [[ -s "${VIRTUALENV_WRAPPER}" ]]; then
    if [[ ! -n "${WORKON_HOME}" ]]; then
        export WORKON_HOME=$HOME/.virtualenvs;
    fi
    if [[ ! -d ${WORKON_HOME} ]]; then
        mkdir -p "${WORKON_HOME}"
    fi
    source "${VIRTUALENV_WRAPPER}";
fi

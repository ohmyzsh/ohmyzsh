# This plugin loads pyenv into the current shell and provides prompt info via
# the 'pyenv_prompt_info' function. Also loads pyenv-virtualenv if available.

# Load pyenv only if command not already available
command -v pyenv &> /dev/null && FOUND_PYENV=1 || FOUND_PYENV=0

if [[ $FOUND_PYENV -ne 1 ]]; then
    pyenvdirs=("$HOME/.pyenv" "/usr/local/pyenv" "/opt/pyenv" "/usr/local/opt/pyenv")
    for dir in $pyenvdirs; do
        if [[ -d $dir/bin ]]; then
            export PATH="$PATH:$dir/bin"
            FOUND_PYENV=1
            break
        fi
    done
fi

if [[ $FOUND_PYENV -ne 1 ]]; then
    if (( $+commands[brew] )) && dir=$(brew --prefix pyenv 2>/dev/null); then
        if [[ -d $dir/bin ]]; then
            export PATH="$PATH:$dir/bin"
            FOUND_PYENV=1
        fi
    fi
fi

if [[ $FOUND_PYENV -eq 1 ]]; then
    eval "$(pyenv init - zsh)"
    if (( $+commands[pyenv-virtualenv-init] )); then
        eval "$(pyenv virtualenv-init - zsh)"
    fi
    function pyenv_prompt_info() {
        echo "$(pyenv version-name)"
    }
else
    # fallback to system python
    function pyenv_prompt_info() {
        echo "system: $(python -V 2>&1 | cut -f 2 -d ' ')"
    }
fi

unset FOUND_PYENV pyenvdirs dir

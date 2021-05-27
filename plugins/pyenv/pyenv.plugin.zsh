# This plugin loads pyenv into the current shell and provides prompt info via
# the 'pyenv_prompt_info' function. Also loads pyenv-virtualenv if available.

# Load pyenv only if command not already available
if command -v pyenv &> /dev/null && [[ "$(uname -r)" != *icrosoft* ]]; then
    FOUND_PYENV=1
    DISCOVERED_PYENV=0
else
    FOUND_PYENV=0
fi

if [[ $FOUND_PYENV -ne 1 ]]; then
    pyenvdirs=("$HOME/.pyenv" "/usr/local/pyenv" "/opt/pyenv" "/usr/local/opt/pyenv")
    for dir in $pyenvdirs; do
        if [[ -d $dir/bin ]]; then
            FOUND_PYENV=1
            DISCOVERED_PYENV=1
            break
        fi
    done
fi

if [[ $FOUND_PYENV -ne 1 ]]; then
    if (( $+commands[brew] )) && dir=$(brew --prefix pyenv 2>/dev/null); then
        if [[ -d $dir/bin ]]; then
            FOUND_PYENV=1
            DISCOVERED_PYENV=1
        fi
    fi
fi

if [[ $FOUND_PYENV -eq 1 ]]; then
    if [[ $DISCOVERED_PYENV -eq 1 ]]; then
        echo pyenv is badly configured in this shell.  Follow the instructions here:
        echo https://github.com/pyenv/pyenv/blob/master/README.md#advanced-configuration
        echo On linux, this means adding the following lines to your .profile and sourcing it in your .zprofile:
        echo export PYENV_ROOT=$dir
        echo export PATH="\$PYENV_ROOT/bin:\$PATH"
        echo eval "\$(pyenv init --path)"
        # Configuring in .zshrc only makes pyenv available for interactive shells.
        export PYENV_ROOT=$dir
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init --path)"
    fi
    eval "$(pyenv init - --no-rehash zsh)"
    if (( $+commands[pyenv-virtualenv-init] )); then
        eval "$(pyenv virtualenv-init - zsh)"
    fi
    function pyenv_prompt_info() {
        echo "$(pyenv version-name)"
    }
else
    # Fall back to system python.
    function pyenv_prompt_info() {
        echo "system: $(python -V 2>&1 | cut -f 2 -d ' ')"
    }
fi

unset FOUND_PYENV DISCOVERED_PYENV pyenvdirs dir

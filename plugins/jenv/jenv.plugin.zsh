jenvdirs=("$HOME/.jenv" "/usr/local" "/usr/local/jenv" "/opt/jenv")

FOUND_JENV=0
for jenvdir in $jenvdirs; do
    if [[ -d "${jenvdir}/bin" ]]; then
        FOUND_JENV=1
        break
    fi
done

if [[ $FOUND_JENV -eq 0 ]]; then
    if (( $+commands[brew] )) && jenvdir="$(brew --prefix jenv)"; then
        [[ -d "${jenvdir}/bin" ]] && FOUND_JENV=1
    fi
fi

USE_JENV=1
if [[ $USE_JENV -eq 0 ]]; then
    FOUND_JENV=0
fi

if [[ $FOUND_JENV -eq 1 ]]; then
    export PATH="${jenvdir}/bin:$PATH"
    eval "$(jenv init - zsh)"

    function _get_jenv_info() { 
        echo "$(jenv version-name 2>/dev/null)"
    }

    if [[ -d "${jenvdir}/versions" ]]; then
        export JENV_ROOT=$jenvdir
    fi
else
    function _get_jenv_info() { 
        echo "$(java -version 2>&1)"
    }
fi

function jenv_prompt_info() {
    echo "%{$fg[magenta]%}java:$(_get_jenv_info)%{$reset_color%}" 
}

unset jenvdir jenvdirs FOUND_JENV

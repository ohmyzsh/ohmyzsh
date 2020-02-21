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

if [[ $FOUND_JENV -eq 1 ]]; then
    (( $+commands[jenv] )) || export PATH="${jenvdir}/bin:$PATH"
    eval "$(jenv init - zsh)"

    function jenv_prompt_info() { jenv version-name 2>/dev/null }

    if [[ -d "${jenvdir}/versions" ]]; then
        export JENV_ROOT=$jenvdir
    fi
else
    function jenv_prompt_info() { echo "system: $(java -version 2>&1 | cut -f 2 -d ' ')" }
fi

unset jenvdir jenvdirs FOUND_JENV

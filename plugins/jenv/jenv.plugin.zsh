_homebrew-installed() {
    type brew &> /dev/null
}

_jenv-from-homebrew-installed() {
    brew --prefix jenv &> /dev/null
}

jenvdirs=("$HOME/.jenv" "/usr/local/jenv" "/opt/jenv")
if _homebrew-installed && _jenv-from-homebrew-installed ; then
    jenvdirs+=($(brew --prefix jenv) "${jenvdirs[@]}")
fi

FOUND_JENV=0
for jenvdir in "${jenvdirs[@]}" ; do
    if [ -d $jenvdir/bin -a $FOUND_JENV -eq 0 ] ; then
        FOUND_JENV=1
        export PATH="${jenvdir}/bin:$PATH"
        eval "$(jenv init - zsh)"

        function jenv_prompt_info() {
          echo "$(jenv version-name)"
        }
    fi
    if [ -d $jenvdir/versions -a $FOUND_JENV -eq 0 ] ; then
        export JENV_ROOT=$jenvdir
    fi
done
unset jenvdir

if [ $FOUND_JENV -eq 0 ] ; then
    function jenv_prompt_info() { echo "system: $(java -version 2>&1 | cut -f 2 -d ' ')" }
fi

_homebrew-installed() {
    type brew &> /dev/null
}

_pyenv-from-homebrew-installed() {
    brew --prefix pyenv &> /dev/null
}

FOUND_PYENV=0
pyenvdirs=("$HOME/.pyenv" "/usr/local/pyenv" "/opt/pyenv")
if _homebrew-installed && _pyenv-from-homebrew-installed ; then
    pyenvdirs=($(brew --prefix pyenv) "${pyenvdirs[@]}")
fi

for pyenvdir in "${pyenvdirs[@]}" ; do
    if [ -d $pyenvdir/bin -a $FOUND_PYENV -eq 0 ] ; then
        FOUND_PYENV=1
        export PYENV_ROOT=$pyenvdir
        path=(${pyenvdir}/bin $path)
        eval "$(pyenv init --no-rehash - zsh)"

        function pyenv_prompt_info() {
            echo "$(pyenv version-name)"
        }
    fi
done
unset pyenvdir

if [ $FOUND_PYENV -eq 0 ] ; then
    function pyenv_prompt_info() { echo "system: $(python -V 2>&1 | cut -f 2 -d ' ')" }
fi

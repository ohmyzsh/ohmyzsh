_homebrew-installed() {
    type brew &> /dev/null
}

_plenv-from-homebrew-installed() {
    brew --prefix plenv &> /dev/null
}

FOUND_PLENV=0
plenvdirs=("$HOME/.plenv" "/usr/local/plenv" "/opt/plenv")
if _homebrew-installed && _plenv-from-homebrew-installed ; then
    plenvdirs=($(brew --prefix plenv) "${plenvdirs[@]}")
fi

for plenvdir in "${plenvdirs[@]}" ; do
    if [ -d $plenvdir/bin -a $FOUND_PLENV -eq 0 ] ; then
        FOUND_PLENV=1
        export PLENV_ROOT=$plenvdir
        export PATH=${plenvdir}/bin:$PATH
        eval "$(plenv init - zsh)"

        function plenv_prompt_info() {
            echo "$(plenv version-name)"
        }
    fi
done
unset plenvdir

if [ $FOUND_PLENV -eq 0 ] ; then
    function plenv_prompt_info() { echo "system: $(perl -Mversion -e 'print version->parse($])->normal' 2>&1 )" }
fi

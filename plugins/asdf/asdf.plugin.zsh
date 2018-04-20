_homebrew-installed() {
    type brew &> /dev/null
}

FOUND_ASDF=0
DEFAULT_ASDF_DIR="$HOME/.asdf"

if [ -d $DEFAULT_ASDF_DIR/bin ] ; then
    FOUND_ASDF=1
    ASDF_DIR="$DEFAULT_ASDF_DIR"
    ASDF_COMPLETIONS_DIR="$DEFAULT_ASDF_DIR/completions"
fi

if [ $FOUND_ASDF -eq 0 ] && _homebrew-installed ; then
    ASDF_DIR="$(brew --prefix)/opt/asdf"
    if [ $? -eq 0 -a -d $ASDF_DIR/bin ] ; then
        FOUND_ASDF=1
        ASDF_COMPLETIONS_DIR="$ASDF_DIR/etc/bash_completion.d/asdf.bash"
    fi
fi

if [ $FOUND_ASDF -gt 0 ] ; then
    export PATH=${ASDF_DIR}/bin:$PATH
    . $ASDF_DIR/asdf.sh
    if [ -f $ASDF_COMPLETIONS_DIR/completions/asdf.bash ]; then
      . $ASDF_COMPLETIONS_DIR/completions/asdf.bash
    fi
fi

unset FOUND_ASDF
unset ASDF_DIR
unset ASDF_COMPLETIONS_DIR


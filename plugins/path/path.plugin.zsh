# Path Plugin
# -----------
# Adds each line from $HOME/.path to your PATH variable.
# Environment variables will be evaluated in this file for you, so you
# can use references like $HOME/bin.
#
# Use `reload_path` to update $PATH if you change $HOME/.path

function reload_path() {
    if [ $CUSTOM_PATH ]; then
        # Determine what the original path was before we modified it be removing
        # our CUSTOM_PATH.  This way we don't double-up entries on the path when
        # manually calling reload_path.
        export ORIGINAL_PATH=$(echo $PATH | sed "s|$CUSTOM_PATH||")
    else
        export ORIGINAL_PATH=$PATH
    fi
    export CUSTOM_PATH=$(eval echo $((while read x; do echo -n "$x:"; done < $HOME/.path) 2> /dev/null || echo ""))
    # CUSTOM_PATH ends with a trailing colon (:) so no need to provide it here.
    export PATH=${CUSTOM_PATH}${ORIGINAL_PATH}
}

reload_path

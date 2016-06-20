#!/bin/sh

_emacsfun()
{
    # get list of available X windows.
    x=`emacsclient --alternate-editor '' --eval '(x-display-list)' 2>/dev/null`

    if [ -z "$x" ] || [ "$x" = "nil" ] ;then
        # Create one if there is no X window yet.
        emacsclient --alternate-editor "" --create-frame "$@"
    else
        # prevent creating another X frame if there is at least one present.
        emacsclient --alternate-editor "" "$@"
    fi
}


# adopted from https://github.com/davidshepherd7/emacs-read-stdin/blob/master/emacs-read-stdin.sh
# If the second argument is - then write stdin to a tempfile and open the
# tempfile. (first argument will be `--no-wait` passed in by the plugin.zsh)
if [ "$#" -ge "2" -a "$2" = "-" ]
then
    tempfile="$(mktemp emacs-stdin-$USER.XXXXXXX --tmpdir)"
    cat - > "$tempfile"
    _emacsfun --no-wait $tempfile
else
    _emacsfun "$@"
fi

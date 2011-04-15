#!/bin/sh

# Starts emacs daemon if not already started.

x=`emacsclient --alternate-editor '' --eval '(x-display-list)' 2>/dev/null`
if [ -z "$x" ] ;then
    emacsclient --alternate-editor "" --create-frame "$@"
else
    # prevent creating another X frame if there is at least one present.
    emacsclient --alternate-editor "" "$@"
fi

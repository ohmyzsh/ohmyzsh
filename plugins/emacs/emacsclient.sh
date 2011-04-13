#!/bin/sh

# Starts emacs daemon if not already started.

x=`emacsclient --alternate-editor '' --eval '(x-display-list)' 2>/dev/null`
if [ -z "$x" ] ;then
    emacsclient --alternate-editor "" --create-frame $@
else
    emacsclient --alternate-editor "" $@
fi

# Use daemon capabilities of emacs 23
if "$ZSH/tools/require_tool.sh" emacs 23 2>/dev/null ; then
    export EDITOR="$ZSH/plugins/emacs/emacsclient.sh"
    alias emacs="$EDITOR --no-wait"
    alias e=emacs

    alias emasc=emacs
    alias emcas=emacs
    # create a new X frame
    alias emacs_frame='emacsclient --alternate-editor "" --create-frame'
fi

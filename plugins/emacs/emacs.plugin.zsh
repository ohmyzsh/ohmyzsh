# Emacs 23 daemon capability is a killing feature.
# One emacs process handles all your frames whether
# you use a frame opened in a terminal via a ssh connection or X frames 
# opened on the same host.

# Benefits are multiple
# - You don't have the cost of starting Emacs all the time anymore
# - Opening a file is as fast as Emacs does not have anything else to do.
# - You can share opened buffered across opened frames.
# - Configuration changes made at runtime are applied to all frames.


if "$ZSH/tools/require_tool.sh" emacs 23 2>/dev/null ; then
    export EDITOR="$ZSH/plugins/emacs/emacsclient.sh"
    alias emacs="$EDITOR --no-wait"
    alias e=emacs

    # same than M-x eval but from outside Emacs.
    alias eeval="emacs --eval"
    # create a new X frame
    alias eframe='emacsclient --alternate-editor "" --create-frame'

    # to code all night long
    alias emasc=emacs
    alias emcas=emacs
fi

## Local Variables:
## mode: sh
## End:

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
    alias eeval="$EDITOR --eval"
    # create a new X frame
    alias eframe='emacsclient --alternate-editor "" --create-frame'

    # to code all night long
    alias emasc=emacs
    alias emcas=emacs

    # jump to the directory of the current buffer
    function ecd {
        local cmd="(let ((buf-name (buffer-file-name (window-buffer))))
                     (if buf-name (file-name-directory buf-name)))"

        local dir=`$EDITOR --eval "$cmd" | tr -d \"`
        if [ -n "$dir" ] ;then
            cd "$dir"
        else
            echo "can not deduce current buffer filename." >/dev/stderr
            return 1
        fi
    }
fi


## Local Variables:
## mode: sh
## End:

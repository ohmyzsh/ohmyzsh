# Emacs 23 daemon capability is a killing feature.
# One emacs process handles all your frames whether
# you use a frame opened in a terminal via a ssh connection or X frames
# opened on the same host.

# Benefits are multiple
# - You don't have the cost of starting Emacs all the time anymore
# - Opening a file is as fast as Emacs does not have anything else to do.
# - You can share opened buffered across opened frames.
# - Configuration changes made at runtime are applied to all frames.


if "$ZSH/tools/require_tool.sh" emacsclient 24 2>/dev/null ; then
    export EMACS_PLUGIN_LAUNCHER="$ZSH/plugins/emacs/emacsclient.sh"

    # set EDITOR if not already defined.
    export EDITOR="${EDITOR:-${EMACS_PLUGIN_LAUNCHER}}"

    alias emacs="$EMACS_PLUGIN_LAUNCHER --no-wait"
    alias e=emacs
    # open terminal emacsclient
    alias te="$EMACS_PLUGIN_LAUNCHER -nw"

    # same than M-x eval but from outside Emacs.
    alias eeval="$EMACS_PLUGIN_LAUNCHER --eval"
    # create a new X frame
    alias eframe='emacsclient --alternate-editor "" --create-frame'

    # Emacs ANSI Term tracking
    if [[ -n "$INSIDE_EMACS" ]]; then
        chpwd_emacs() { print -P "\033AnSiTc %d"; }
        print -P "\033AnSiTc %d"    # Track current working directory
        print -P "\033AnSiTu %n"    # Track username        

        # add chpwd hook
        autoload -Uz add-zsh-hook
        add-zsh-hook chpwd chpwd_emacs
    fi    

    # Write to standard output the path to the file
    # opened in the current buffer.
    function efile {
        local cmd="(buffer-file-name (window-buffer))"
        "$EMACS_PLUGIN_LAUNCHER" --eval "$cmd" | tr -d \"
    }

    # Write to standard output the directory of the file
    # opened in the the current buffer
    function ecd {
        local cmd="(let ((buf-name (buffer-file-name (window-buffer))))
                     (if buf-name (file-name-directory buf-name)))"

        local dir="$($EMACS_PLUGIN_LAUNCHER --eval $cmd | tr -d \")"
        if [ -n "$dir" ] ;then
            echo "$dir"
        else
            echo "can not deduce current buffer filename." >/dev/stderr
            return 1
        fi
    }
fi

## Local Variables:
## mode: sh
## End:

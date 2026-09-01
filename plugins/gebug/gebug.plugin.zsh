# Autocompletion for Gebug.
#
if (( $+commands[gebug] )); then
    __GEBUG_COMPLETION_FILE="${ZSH_CACHE_DIR}/gebug_completion"

    if [[ ! -f $__GEBUG_COMPLETION_FILE ]]; then
        gebug completion zsh >! $__GEBUG_COMPLETION_FILE
    fi

    [[ -f $__GEBUG_COMPLETION_FILE ]] && source $__GEBUG_COMPLETION_FILE

    unset __GEBUG_COMPLETION_FILE
fi


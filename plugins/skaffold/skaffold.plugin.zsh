if (( $+commands[skaffold] )); then
    __SKAFFOLD_COMPLETION_FILE="${ZSH_CACHE_DIR}/skaffold_completion"

    if [[ ! -f $__SKAFFOLD_COMPLETION_FILE ]]; then
        skaffold completion zsh >! $__SKAFFOLD_COMPLETION_FILE
    fi

    [[ -f $__SKAFFOLD_COMPLETION_FILE ]] && source $__SKAFFOLD_COMPLETION_FILE

    unset __SKAFFOLD_COMPLETION_FILE
fi

alias s=skaffold

# Autocompletion for Minikube.
#
if (( $+commands[minikube] )); then
    __MINICUBE_COMPLETION_FILE="${ZSH_CACHE_DIR}/minicube_completion"

    if [[ ! -f $__MINICUBE_COMPLETION_FILE ]]; then
        minikube completion zsh >! $__MINICUBE_COMPLETION_FILE
    fi

    [[ -f $__MINICUBE_COMPLETION_FILE ]] && source $__MINICUBE_COMPLETION_FILE

    unset __MINICUBE_COMPLETION_FILE
fi

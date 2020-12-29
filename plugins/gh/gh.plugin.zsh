# Autocompletion for the GitHub CLI (gh).
#
# Copy from kubectl : https://github.com/pstadler

if (( $+commands[gh] )); then
    __GH_COMPLETION_FILE="${ZSH_CACHE_DIR}/gh_completion"

    if [[ ! -f $__GH_COMPLETION_FILE || ! -s $__GH_COMPLETION_FILE ]]; then
        gh completion -s zsh >! $__GH_COMPLETION_FILE
    fi

    [[ -f $__GH_COMPLETION_FILE ]] && source $__GH_COMPLETION_FILE

    unset __GH_COMPLETION_FILE
fi

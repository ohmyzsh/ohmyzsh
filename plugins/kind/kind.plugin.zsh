if (( $+commands[kind] )); then
  __KIND_COMPLETION_FILE="${ZSH_CACHE_DIR}/kind_completion"
  if [[ ! -f $__KIND_COMPLETION_FILE || ! -s $__KIND_COMPLETION_FILE ]]; then
    kind completion zsh >! $__KIND_COMPLETION_FILE
  fi

  [[ -f $__KIND_COMPLETION_FILE ]] && source $__KIND_COMPLETION_FILE

  unset __KIND_COMPLETION_FILE
fi

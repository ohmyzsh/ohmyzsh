if [[ "$DISABLE_COLOR" != "true" ]]; then
    [[ -z "$GREP_OPTIONS" ]] && export GREP_OPTIONS='--color=auto'
    [[ -z "$GREP_COLOR" ]] && export GREP_COLOR='1;32'
fi

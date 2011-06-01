if [[ "$DISABLE_COLOR" != 'true' ]]; then
  if [[ -z "$GREP_OPTIONS" ]]; then
    export GREP_OPTIONS='--color=auto'
  fi
  if [[ -z "$GREP_COLOR" ]]; then
    export GREP_COLOR='37;45'
  fi
else
  export GREP_OPTIONS='--color=none'
  export GREP_COLOR=''
fi


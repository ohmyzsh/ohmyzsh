if [[ "$DISABLE_COLOR" != "true" ]]; then
  export GREP_OPTIONS='--color=auto'
  export GREP_COLOR='37;45'
else
  export GREP_OPTIONS='--color=none'
  export GREP_COLOR=''
fi


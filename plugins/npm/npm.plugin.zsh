# If NPM is not found don't silently fail.
(( $+commands[npm] )) && eval "$(npm completion 2>/dev/null)" || {
  echo "oh-my-zsh (npm plugin): npm not found. Make sure you have it in your \$PATH"
}

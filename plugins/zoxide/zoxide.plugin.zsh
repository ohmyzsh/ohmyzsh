() {
  local flags

  if [[ -n "$_ZO_OMZ_CMD" ]]; then
    flags+=(--cmd "$_ZO_OMZ_CMD")
  fi

  if [[ "$_ZO_OMZ_NOCMD" == 1 ]]; then
    flags+=(--no-cmd)
  fi

  if [[ -n "$_ZO_OMZ_HOOK" ]]; then
    flags+=(--hook "$_ZO_OMZ_HOOK")
  fi

  if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh $flags)"
  else
    echo '[oh-my-zsh] zoxide not found, please install it from https://github.com/ajeetdsouza/zoxide'
  fi
}

function wake() {
  local config_file="$HOME/.wakeonlan/$1"
  if [[ ! -f "$config_file" ]]; then
    echo "$0: $1: There is no such device file." >&2
    return 1
  fi

  if (( ! $+commands[wakeonlan] )); then
    echo "$0: Can't find wakeonlan. Is it installed?" >&2
    return 1
  fi

  wakeonlan -f "$config_file"
}


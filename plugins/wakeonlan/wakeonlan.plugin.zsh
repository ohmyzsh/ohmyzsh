function wake() {
  local config_file="$HOME/.wakeonlan/$1"
  if [[ ! -f "$config_file" ]]; then
    echo "ERROR: There is no configuration file at \"$config_file\"."
    return 1
  fi

  if (( ! $+commands[wakeonlan] )); then
    echo "ERROR: Can't find \"wakeonlan\".  Are you sure it's installed?"
    return 1
  fi

  wakeonlan -f $config_file
}

if (( $+functions[compdef] )); then
  compdef "_arguments '1:device to wake:_files -W '\''$HOME/.wakeonlan'\'''" wake
fi

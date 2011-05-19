function wake() {
  local config_file=~/.wakeonlan/$1
  if [[ ! -f $config_file ]]; then
    echo "ERROR: There is no configuration file at \"$config_file\"."
    return
  fi

  which wakeonlan > /dev/null
  if [[ ! $? == 0 ]]; then
    echo "ERROR: Can't find \"wakeonlan\".  Are you sure it's installed?"
    return
  fi

  wakeonlan -f $config_file
}

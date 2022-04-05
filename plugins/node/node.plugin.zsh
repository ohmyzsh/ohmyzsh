# Open the node api for your current version to the optional section.
# TODO: Make the section part easier to use.
function node-docs {
<<<<<<< HEAD
  # get the open command
  local open_cmd
  if [[ "$OSTYPE" = darwin* ]]; then
    open_cmd='open'
  else
    open_cmd='xdg-open'
  fi

  $open_cmd "http://nodejs.org/docs/$(node --version)/api/all.html#all_$1"
=======
  local section=${1:-all}
  open_command "https://nodejs.org/docs/$(node --version)/api/$section.html"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
}

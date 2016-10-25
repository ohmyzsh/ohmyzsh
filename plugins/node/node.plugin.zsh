# Open the node api for your current version to the optional section.
# TODO: Make the section part easier to use.
function node-docs {
  if [ $# -eq 0 ]; then
    open_command "http://nodejs.org/docs/$(node --version)/api/all.html"
  else
    open_command "http://nodejs.org/docs/$(node --version)/api/$1.html"
  fi
}

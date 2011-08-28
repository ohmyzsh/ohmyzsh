# Complete npm.
eval "$(npm completion 2>/dev/null)"

# Open the node api for your current version to the optional section.
# TODO: Make the sections easier to use.
function node-docs() {
  open "http://nodejs.org/docs/$(node --version)/api/all.html#$1"
}


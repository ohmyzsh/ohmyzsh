# Open the node api for your current version to the optional section.
# TODO: Make the section part easier to use.
function node-docs {
  open_command "http://nodejs.org/docs/$(node --version)/api/all.html#all_$1"
}

# Open the node api for your current version to the optional section.
# TODO: Make the section part easier to use.
function node-docs {
  local section=${1:-all}
  open_command "https://nodejs.org/docs/$(node --version)/api/$section.html"
}

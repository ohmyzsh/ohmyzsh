# Open the node api for your current version to the optional section.
# TODO: Make the section part easier to use.
function node-docs {
  local section=${1:-all}
  open_command "https://nodejs.org/docs/$(node --version)/api/$section.html"
}

_node-docs-get-sections () {
	curl -s "http://nodejs.org/docs/$(node --version)/api/all.html#all_$1" | grep -o -E 'href="#all_([^"]+)"' | cut -d'"' -f2 | cut -c 6-
}

_node-docs-complete () {
	compadd -S '' $(_node-docs-get-sections)
}

compdef _node-docs-complete node-docs

# This works if you installed node via homebrew.
export NODE_PATH="/usr/local/lib/node"

# Open the node api for your current version to the optional section.
# TODO: Make the section part easier to use.
function node-api {
	open "http://nodejs.org/docs/$(node --version)/api/all.html#$1"
}

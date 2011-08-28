# Complete npm.
cache_file="${0:h}/cache.zsh"
if [[ ! -f "$cache_file" ]] && (( $+commands[npm] )); then
  # npm is slow; cache its output.
  npm completion >! "$cache_file" 2>/dev/null
  source "$cache_file"
else
  source "$cache_file"
fi
unset cache_file

# Open the node api for your current version to the optional section.
# TODO: Make the sections easier to use.
function node-docs() {
  open "http://nodejs.org/docs/$(node --version)/api/all.html#$1"
}


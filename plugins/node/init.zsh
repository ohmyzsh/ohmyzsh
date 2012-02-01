#
# Completes npm.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

cache_file="${0:h}/cache.zsh"
if [[ ! -f "$cache_file" ]] && (( $+commands[npm] )); then
  # npm is slow; cache its output.
  npm completion >! "$cache_file" 2> /dev/null
  source "$cache_file"
else
  source "$cache_file"
fi
unset cache_file


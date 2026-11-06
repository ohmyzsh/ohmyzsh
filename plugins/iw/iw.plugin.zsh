# iw Oh-My-ZSH plugin
# Provides tab completion for iw (Linux wireless configuration utility).

if (( ! $+commands[iw] )); then
  return
fi

# Remove the cached iw completion data (useful after upgrading iw).
iw-clear-cache() {
  local cache_file="${ZSH_CACHE_DIR:-${HOME}/.cache}/_iw_cache"
  if [[ -f "$cache_file" ]]; then
    rm -f "$cache_file"
    print "iw completion cache cleared."
  else
    print "No iw completion cache found."
  fi
}

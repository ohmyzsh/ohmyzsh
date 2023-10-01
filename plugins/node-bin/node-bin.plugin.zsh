# Add local ancestor node_modules/.bin folders to the path.
_nodeBin() {
  path=( ${path[@]:#*node_modules*} )
  local p="$(pwd)"
  while [[ "$p" != '/' ]]; do
    if [[ -d "$p/node_modules/.bin" ]]; then
      path+=("$p/node_modules/.bin")
    fi
    p="$(dirname "$p")"
  done
  typeset -U path
}

autoload -U add-zsh-hook
add-zsh-hook chpwd _nodeBin
_nodeBin

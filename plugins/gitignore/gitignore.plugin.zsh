# Allow overriding API endpoint
: ${GITIGNORE_API_PRIMARY:="https://www.toptal.com/developers/gitignore/api"}
: ${GITIGNORE_API_FALLBACK:="https://www.gitignore.io/api"}

function _gi_curl() {
  curl -sfL "$1/$2" || curl -sfL "$GITIGNORE_API_FALLBACK/$2"
}

function gi() {
  local query="${(j:,:)@}"
  _gi_curl "$GITIGNORE_API_PRIMARY" "$query" || return 1
}

_gitignoreio_get_command_list() {
  _gi_curl "$GITIGNORE_API_PRIMARY" "list" | tr "," "\n"
}

_gitignoreio () {
  compset -P '*,'
  compadd -S '' $(_gitignoreio_get_command_list)
}

compdef _gitignoreio gi
# gitignore plugin for oh-my-zsh
# Uses gitignore.io CDN endpoint
function _gi_curl() {
  curl -sfL "https://www.gitignore.io/api/$1"
}

function gi() {
  local query="${(j:,:)@}"
  _gi_curl "$query" || return 1
}

_gitignoreio_get_command_list() {
  _gi_curl "list" | tr "," "\n"
}

__gitignoreio_caching_policy() {
  local -a oldp
  oldp=("$1"(Nm+7))
  (($#oldp))
}

_gitignoreio() {
  compset -P '*,'

  local cache_policy
  zstyle -s ":completion:${curcontext}:" cache-policy cache_policy
  if [[ -z "$cache_policy" ]]; then
    zstyle ":completion:${curcontext}:" cache-policy __gitignoreio_caching_policy
  fi

  local -a _gi_list
  if _cache_invalid gi-list || ! _retrieve_cache gi-list; then
    _gi_list=(${(f)"$(_gitignoreio_get_command_list)"})
    _store_cache gi-list _gi_list
  fi

  compadd -S '' -a _gi_list
}

compdef _gitignoreio gi

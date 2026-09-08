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
  setopt local_options pipe_fail
  _gi_curl "list" | tr "," "\n"
}

__gitignoreio_caching_policy() {
  local -a oldp
  oldp=("$1"(Nm+7))
  (($#oldp))
}

_gitignoreio_retrieve_stale_cache() {
  zstyle -t ":completion:${curcontext}:" use-cache || return 1

  local cache_dir
  zstyle -s ":completion:${curcontext}:" cache-path cache_dir
  : ${cache_dir:=${ZDOTDIR:-$HOME}/.zcompcache}

  [[ -e "$cache_dir/gi-list" ]] || return 1
  . "$cache_dir/gi-list"
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
    local command_list
    if command_list="$(_gitignoreio_get_command_list)" && [[ -n "$command_list" ]]; then
      _gi_list=(${(f)command_list})
      _store_cache gi-list _gi_list
    else
      _gitignoreio_retrieve_stale_cache
    fi
  fi

  compadd -S '' -a _gi_list
}

compdef _gitignoreio gi

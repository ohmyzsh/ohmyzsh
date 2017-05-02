mapdir="$ZSH/cache/omz-bootstrap"

_map_init() {
  command mkdir -p "$mapdir"
}

_map_put() {
  [[ -z "$1" || -z "$2" || -z "$3" ]] && return 1
  local mapname=$1; local key=$2; local value=$3
  [[ -d "${mapdir}/${mapname}" ]] || mkdir "${mapdir}/${mapname}"
  echo $value > "${mapdir}/${mapname}/${key}"
}

_map_get() {
  [[ -z "$1" || -z "$2" ]] && return 1
  local mapname=$1; local key=$2
  cat "${mapdir}/${mapname}/${key}"
}

_map_keys() {
  [[ -z "$1" ]] && return 1
  local mapname=$1
  for key ($mapdir/$mapname/*); do
    basename $key
  done
}

_map_exists() {
  [[ -z "$1" || -z "$2" ]] && return 1
  local mapname=$1; local key=$2
  [[ -f "${mapdir}/${mapname}/${key}" ]] && return 0
}

_map_remove() {
  [[ -z "$1" || -z "$2" ]] && return 1
  local mapname=$1; local key=$2
  command rm "${mapdir}/${mapname}/${key}"
}

_map_init

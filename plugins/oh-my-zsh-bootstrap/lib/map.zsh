mapdir=$ZSH_BOOTSTRAP/data

_map_init() {
  mkdir -p $mapdir
}

_map_put() {
  [[ "$#" != 3 ]] && return 1
  mapname=$1; key=$2; value=$3
  [[ -d "${mapdir}/${mapname}" ]] || mkdir "${mapdir}/${mapname}"
  echo $value >"${mapdir}/${mapname}/${key}"
}

_map_get() {
  [[ "$#" != 2 ]] && return 1
  mapname=$1; key=$2
  cat "${mapdir}/${mapname}/${key}"
}

_map_keys() {
  [[ "$#" != 1 ]] && return 1
  mapname=$1
  for key ($mapdir/$mapname/*); do
    basename $key
  done
}

_map_exists() {
  [[ "$#" != 2 ]] && return 1
  mapname=$1; key=$2
  [[ -f "${mapdir}/${mapname}/${key}" ]] && return 0
}

_map_remove() {
  [[ "$#" != 2 ]] && return 1
  mapname=$1; key=$2
  rm "${mapdir}/${mapname}/${key}"  
}
_map_init


alias pjo="pj open"

function pj() {
  local cmd="cd"
  local project=""
  local editor="${EDITOR}"

  if [[ "$1" == "open" ]]; then
    shift
    project="$1"
    shift
    [[ -n "$1" ]] && editor="$1"
    cmd="$editor"
  else
    project="$*"
  fi

  for basedir in $PROJECT_PATHS; do
    if [[ -d "$basedir/$project" ]]; then
      $cmd "$basedir/$project"
      return
    fi
  done

  echo "No such project '${project}'."
}

_pj () {
  local -a projects
  for basedir ($PROJECT_PATHS); do
    projects+=(${basedir}/*(/N))
  done

  compadd ${projects:t}
}

compdef _pj pj

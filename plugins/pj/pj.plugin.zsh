alias pjo="pj open"

function pj() {
  local cmd="cd"
  local project="$1"

  if [[ "open" == "$project" ]]; then
    shift
    project=$*
    cmd=${=EDITOR}
  else
    project=$*
  fi

  for basedir ($PROJECT_PATHS); do
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

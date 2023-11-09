local -a _git_commit_aliases
_git_commit_aliases=(
  'build'
  'chore'
  'ci'
  'docs'
  'feat'
  'fix'
  'perf'
  'refactor'
  'revert'
  'style'
  'test'
)

local alias type
for type in "${_git_commit_aliases[@]}"; do
  # an alias can't be named "revert" because the git command takes precedence
  # https://stackoverflow.com/a/3538791
  case "$type" in
  revert) alias=rev ;;
  *) alias=$type ;;
  esac

  local func='!a() { if [ "$1" = "-s" ] || [ "$1" = "--scope" ]; then local scope="$2"; shift 2; git commit -m "'$type'(${scope}): ${@}"; else git commit -m "'$type': ${@}"; fi }; a'
  if ! git config --global --get-all alias.${alias} >/dev/null 2>&1; then
    git config --global alias.${alias} "$func"
  fi
done

unset _git_commit_aliases alias type func

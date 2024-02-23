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
  'wip'
)

_git_commit_flags=(
  '-s'
  '--scope'
  '-a'
  '--attention'
  '-sa'
  '-as'
)

remove_flags() {
  local regex=$(IFS="|"; echo "${_git_commit_flags[*]}")

  echo $(sed -E "s/\s($regex)\s|\s($regex)$//g" <<< "$1")
};

build_message () {
  local argv=("$@")
  local argc=${#@}
  local i=1

  while [[ $i -lt $argc ]];
  do
    local flag="${argv[$i]}"
    local value="${argv[$i + 1]}"
    local next=$[$i + 1]

    if [[ "$flag" =~ (-sa|-as) ]]; then
      local attention='!'
      local scope="($value)"
      i=$next
    fi

    if [[ "$flag" =~ (-a|--attention) ]]; then
      local attention='!'
      i=$next
    fi

    if [[ "$flag" =~ (-s|--scope) && -n "$value" ]]; then
      local scope="($value)"
      i=$next
    fi
  i=$next
  done

  local template="'$type'${scope}$attention: ${@}";
  local message=$(remove_flags "$template" "${_git_commit_flags[@]}")

  git commit -m "$message"
};

local alias type
for type in "${_git_commit_aliases[@]}"; do
  # an alias can't be named "revert" because the git command takes precedence
  # https://stackoverflow.com/a/3538791
  case "$type" in
  revert) alias=rev ;;
  *) alias=$type ;;
  esac

  if ! git config --global --get-all alias.${alias} >/dev/null 2>&1; then
    git config --global alias.${alias} build_message
  fi
done

unset _git_commit_aliases _git_commit_flags alias type

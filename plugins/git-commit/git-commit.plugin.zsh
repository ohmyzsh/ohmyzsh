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
    if [[ "${argv[$i]}" =~ (-sa|-as) ]]; then
      local attention='!'
      local scope="(${argv[$i + 1]})"
      i=$[$i + 1]
    fi

    if [[ "${argv[$i]}" =~ (-a|--attention) ]]; then
      local attention='!'
      i=$[$i + 1]
    fi

    if [[ "${argv[$i]}" =~ (-s|--scope) ]]; then
      local scope="(${argv[$i + 1]})"
      i=$[$i + 1]
    fi
  i=$[$i + 1]
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

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

local -a _git_commit_flags
_git_commit_flags=(
  '-s'
  '--scope'
  '-a'
  '--attention'
  '-sa'
  '-as'
)

remove_flags() {
  local message="$1"
  local flags=("${@:2}")

  local regex=$(IFS="|"; echo "${flags[*]}")

  message=$(sed -E "s/\s($regex)\s|\s($regex)$//g" <<< "$message")

  echo "$message"
}

build_message () {
  if [[ "$*" =~ (-sa|-as) ]]; then
    local attention='!'
    local scope="($2)"
    shift 2
  else
    if [[ "$*" =~ (-s|--scope) ]]; then
      local scope="($2)"
      shift 2
    fi

    if [[ "$*" =~ (-a|--attention) ]]; then
      local attention='!'
    fi
  fi

  local message="'$type'${scope}$attention: $@";

  git commit -m $(remove_flags "$message" "${_git_commit_flags[@]}")
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

unset _git_commit_aliases _flags alias type

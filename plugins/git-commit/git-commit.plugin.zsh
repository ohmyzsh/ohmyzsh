if git config --global --get-all alias.$_alias >/dev/null 2>&1 \
  && ! git config --global --get-all oh-my-zsh.git-commit-alias >/dev/null 2>&1; then
  return
fi

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

local _alias _type
for _type in "${_git_commit_aliases[@]}"; do
  # an alias can't be named "revert" because the git command takes precedence
  # https://stackoverflow.com/a/3538791
  case "$_type" in
    revert) _alias=rev ;;
    *) _alias=$_type ;;
  esac

  local _func='!a() { if [ "$1" = "-s" ] || [ "$1" = "--scope" ]; then local scope="$2"; shift 2; git commit -m "'$type'(${scope}): ${@}"; else git commit -m "'$type': ${@}"; fi }; a'

  git config --global alias.$_alias "$_func"
done

git config --global oh-my-zsh.git-commit-alias "true"

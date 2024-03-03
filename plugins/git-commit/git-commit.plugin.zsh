local _rev="$(git -C $ZSH rev-parse HEAD 2> /dev/null)"
if [[ $_rev == $(git config --global --get oh-my-zsh.git-commit-alias 2> /dev/null) ]]; then
  return
fi
git config --global oh-my-zsh.git-commit-alias "$_rev"

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

  local _func='!a() {
local _scope _attention _message
while [ $# -ne 0 ]; do
case $1 in
  -s | --scope )
    if [ -z $2 ]; then
      echo "Missing scope!"
      return 1
    fi
    _scope="$2"
    shift 2
    ;;
  -a | --attention )
    _attention="!"
    shift 1
    ;;
  * )
    _message="${_message} $1"
    shift 1
    ;;
esac
done
git commit -m "'$_type'${_scope:+(${_scope})}${_attention}:${_message}"
}; a'

  git config --global alias.$_alias "$_func"
done

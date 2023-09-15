function _git_commit_register {
  if ! git config --global --get-all alias.$1 >/dev/null 2>&1; then
    git config --global alias.$1 '!a() { if [ "$1" = "-s" ] || [ "$1" = "--scope" ]; then local scope="$2"; shift 2; git commit -m "'$1'(${scope}): ${@}"; else git commit -m "'$1': ${@}"; fi }; a'
  fi
}

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

for _alias in "${_git_commit_aliases[@]}"; do
  _git_commit_register $_alias
done

unfunction _git_commit_register
unset _alias

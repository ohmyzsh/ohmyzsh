_register() {
  if ! git config --global --get-all alias.$1 &>/dev/null; then
    git config --global alias.$1 '!a() { if [[ "$1" == "-s" || "$1" == "--scope" ]]; then git commit -m "'$1'(${2}): ${@:3}"; else git commit -m "'$1': ${@}"; fi }; a'
  fi
}

aliases=(
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

for alias in "${aliases[@]}"; do
  _register $alias
done
#!/usr/bin/env zsh

emulate -LR zsh

plugin=${1:-${0:A:h:h}/git.plugin.zsh}
plugin=${plugin:A}
(( $+commands[git] )) || { print -u2 'Git is required for this test'; exit 1; }
real_version="${${(As: :)$(command git version)}[3]}"
test_dir=$(mktemp -d) || exit 1
trap 'command rm -rf -- "$test_dir"' EXIT
export ZSH_CACHE_DIR="$test_dir"
cache="$ZSH_CACHE_DIR/git-version"

typeset -i failures=0 tests=0
check() {
  local description=$1
  shift
  (( tests++ ))
  if "$@"; then
    print -r -- "PASS: $description"
  else
    print -u2 -r -- "FAIL: $description"
    (( failures++ ))
  fi
}

# Each source gets a fresh shell scope while sharing the persistent cache.
probe() (
  local mode=$1 expected=$2 version
  : > "$test_dir/versions"
  autoload -Uz +X is-at-least
  functions[_test_is_at_least]=$functions[is-at-least]
  is-at-least() {
    print -r -- "$2" >> "$test_dir/versions"
    _test_is_at_least "$@"
  }
  compdef() { :; }
  case $mode in
    function) git() { print -r -- "git version $expected"; } ;;
    alias) alias git="print -r -- 'git version $expected'" ;;
  esac
  source "$plugin"
  local -a versions=("${(@f)$(<"$test_dir/versions")}")
  (( $#versions == 4 )) || return 1
  for version in "$versions[@]"; do
    [[ "$version" == "$expected" ]] || return 1
  done
  if [[ "$expected" == 2.5.0 ]]; then
    [[ "$aliases[gpf]" == 'git push --force-with-lease' \
      && "$aliases[gsta]" == 'git stash save' ]] || return 1
  fi
)

check 'cold load probes the installed Git' probe binary "$real_version"
if [[ ! -f "$cache" ]]; then
  print -u2 'This test requires a native Git executable eligible for caching'
  exit 1
fi
key="${${(f)$(<"$cache")}[1]}"

check 'warm load uses the installed version' probe binary "$real_version"
check 'function override bypasses an existing binary cache' probe function 2.5.0
check 'alias override bypasses an existing binary cache' probe alias 2.5.0
check 'shell overrides do not replace the binary cache' probe binary "$real_version"

# A different cached version distinguishes a cache hit from a fresh probe.
print -rl -- "$key" 2.5.0 > "$cache"
check 'valid warm cache avoids a new version probe' probe binary 2.5.0

print -r -- "$key" > "$cache"
check 'missing version line triggers a fresh probe' probe binary "$real_version"
print -rl -- "$key" '' > "$cache"
check 'empty version line triggers a fresh probe' probe binary "$real_version"
print -rl -- "$key" invalid > "$cache"
check 'invalid version line triggers a fresh probe' probe binary "$real_version"
print -rl -- 'different executable' 2.5.0 > "$cache"
check 'different binary key triggers a fresh probe' probe binary "$real_version"

print -rl -- "$key" 2.5.0 > "$cache"
touch -t 200001010000 "$cache"
check 'expired cache triggers a fresh probe' probe binary "$real_version"

rm "$cache"
check 'function override works without a cache' probe function 2.5.0
check 'function override does not write a cache' test ! -e "$cache"
rm -f "$cache"
check 'alias override works without a cache' probe alias 2.5.0
check 'alias override does not write a cache' test ! -e "$cache"

print -r -- "$tests tests, $failures failures"
(( failures == 0 ))

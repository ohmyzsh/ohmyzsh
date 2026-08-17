#!/usr/bin/zsh -df

set -u

bootstrap_file="${0:A:h:h}/bootstrap.zsh"

_assert() {
  local condition="$1" message="$2"
  if ! eval "$condition"; then
    print -u2 "\e[31mError\e[0m: $message"
    return 1
  fi
}

test_bootstrap_sets_defaults_and_paths() {
  local tmp==(:)
  mkdir -p "$tmp/ohmyzsh"/{functions,completions,cache} "$tmp/ohmyzsh/custom"/{functions,completions}

  (
    set -e
    export ZSH="$tmp/ohmyzsh"
    unset ZSH_CUSTOM ZSH_CACHE_DIR OMZ_IS_BOOTSTRAPPED
    fpath=()
    source "$bootstrap_file"

    _assert '[[ "$ZSH_CUSTOM" == "'"$tmp/ohmyzsh/custom"'" ]]' "ZSH_CUSTOM default should be set"
    _assert '[[ "$ZSH_CACHE_DIR" == "'"$tmp/ohmyzsh/cache"'" ]]' "ZSH_CACHE_DIR default should be set"
    _assert '[[ -d "'"$tmp/ohmyzsh/cache/completions"'" ]]' "completions dir should be created"
    _assert '[[ "${fpath[(Ie)'"$tmp/ohmyzsh/functions"']}" -gt 0 ]]' "fpath should include OMZ functions dir"
    _assert '[[ "${fpath[(Ie)'"$tmp/ohmyzsh/completions"']}" -gt 0 ]]' "fpath should include OMZ completions dir"
    _assert '[[ "${fpath[(Ie)'"$tmp/ohmyzsh/custom/functions"']}" -gt 0 ]]' "fpath should include custom functions dir"
    _assert '[[ "${fpath[(Ie)'"$tmp/ohmyzsh/custom/completions"']}" -gt 0 ]]' "fpath should include custom completions dir"
    _assert '[[ "${fpath[(Ie)'"$tmp/ohmyzsh/cache/completions"']}" -gt 0 ]]' "fpath should include cache completions dir"
    _assert '[[ "$OMZ_IS_BOOTSTRAPPED" == true ]]' "bootstrap signal should be set"
  )
}

test_bootstrap_is_idempotent() {
  local tmp==(:)
  mkdir -p "$tmp/ohmyzsh"/{functions,completions,cache} "$tmp/ohmyzsh/custom"/{functions,completions}

  (
    set -e
    export ZSH="$tmp/ohmyzsh"
    unset ZSH_CUSTOM ZSH_CACHE_DIR OMZ_IS_BOOTSTRAPPED
    fpath=()
    source "$bootstrap_file"
    source "$bootstrap_file"
    omz_bootstrap

    _assert '[[ ${#fpath} -eq ${#${(u)fpath}} ]]' "fpath entries should not duplicate after repeated bootstrap"
    _assert '[[ "$OMZ_IS_BOOTSTRAPPED" == true ]]' "bootstrap signal should remain true"
  )
}

test_bootstrap_uses_writable_cache_fallback() {
  local tmp==(:)
  mkdir -p "$tmp/ohmyzsh"/{functions,completions} "$tmp/ohmyzsh/custom"/{functions,completions}
  mkdir -p "$tmp/no-write" "$tmp/xdg-cache"
  chmod 0555 "$tmp/no-write"

  (
    set -e
    export ZSH="$tmp/ohmyzsh"
    export XDG_CACHE_HOME="$tmp/xdg-cache"
    export ZSH_CACHE_DIR="$tmp/no-write"
    unset ZSH_CUSTOM OMZ_IS_BOOTSTRAPPED
    fpath=()
    source "$bootstrap_file"

    _assert '[[ "$ZSH_CACHE_DIR" == "'"$tmp/xdg-cache/oh-my-zsh"'" ]]' "cache dir should fallback when not writable"
    _assert '[[ -d "'"$tmp/xdg-cache/oh-my-zsh/completions"'" ]]' "fallback completions dir should be created"
    _assert '[[ "${fpath[(Ie)'"$tmp/xdg-cache/oh-my-zsh/completions"']}" -gt 0 ]]' "fpath should include fallback completions dir"
  )
}

tests=(
  test_bootstrap_sets_defaults_and_paths
  test_bootstrap_is_idempotent
  test_bootstrap_uses_writable_cache_fallback
)

for test_name in $tests; do
  print -u2 "Test: $test_name"
  "$test_name" || exit 1
  print -u2 "\e[32mSuccess\e[0m"
  print -u2 ""
done

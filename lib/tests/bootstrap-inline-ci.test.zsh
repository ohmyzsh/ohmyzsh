#!/usr/bin/zsh -df

set -eu

bootstrap_file="${0:A:h:h}/bootstrap.zsh"

assert() {
  local condition="$1" message="$2"
  if ! eval "$condition"; then
    print -u2 "\e[31mError\e[0m: $message"
    exit 1
  fi
}

tmp==(:)
mkdir -p "$tmp/ohmyzsh"/{functions,completions,cache} "$tmp/ohmyzsh/custom"/{functions,completions}

export ZSH="$tmp/ohmyzsh"
unset ZSH_CUSTOM ZSH_CACHE_DIR OMZ_IS_BOOTSTRAPPED
fpath=()

source "$bootstrap_file"

assert '[[ "$OMZ_IS_BOOTSTRAPPED" == true ]]' "OMZ bootstrap signal should be true"
assert '[[ -d "$ZSH_CACHE_DIR/completions" ]]' "cache completions directory should exist"
assert '[[ "${fpath[(Ie)$ZSH/functions]}" -gt 0 ]]' "fpath should include OMZ functions"
assert '[[ "${fpath[(Ie)$ZSH/completions]}" -gt 0 ]]' "fpath should include OMZ completions"
assert '[[ "${fpath[(Ie)$ZSH_CUSTOM/functions]}" -gt 0 ]]' "fpath should include custom functions"
assert '[[ "${fpath[(Ie)$ZSH_CUSTOM/completions]}" -gt 0 ]]' "fpath should include custom completions"
assert '[[ "${fpath[(Ie)$ZSH_CACHE_DIR/completions]}" -gt 0 ]]' "fpath should include cache completions"

touch "$ZSH_CACHE_DIR/completions/_bootstrap_ci_smoke"
assert '[[ -f "$ZSH_CACHE_DIR/completions/_bootstrap_ci_smoke" ]]' "completion cache write should succeed"

print -u2 "\e[32mSuccess\e[0m bootstrap inline invariants"

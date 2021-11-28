#!/usr/bin/bash
# shellcheck disable=SC1090

__PROXY__="${0:A:h}/proxy.py"

proxy() {
  if [ -n "$DEFAULT_PROXY" ]; then 
    echo "DEFAULT_PROXY is deprecated, use __DEFAULT_PROXY__ instead"
  fi
	source <(env "DEFAULT_PROXY=$DEFAULT_PROXY" "__DEFAULT_PROXY__=$__DEFAULT_PROXY__" "$__PROXY__" "$1")
}

_proxy() {
	local -r commands=('enable' 'disable' 'status')
	compset -P '*,'
	compadd -S '' "${commands[@]}"
}

compdef '_proxy' 'proxy'

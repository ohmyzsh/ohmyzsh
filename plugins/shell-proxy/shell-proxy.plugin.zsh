#!/usr/bin/bash
# shellcheck disable=SC1090

__PROXY__="${0:A:h}/proxy.py"

proxy() {
	source <(env "DEFAULT_PROXY=$DEFAULT_PROXY" "$__PROXY__" "$1")
}

_proxy() {
	local -r commands=('enable' 'disable' 'status')
	compset -P '*,'
	compadd -S '' "${commands[@]}"
}

compdef '_proxy' 'proxy'

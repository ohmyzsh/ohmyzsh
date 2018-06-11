# Simple plugin to calculate the time since the last command was run.
# This is a proxy to the runtime when used in the prompt.
#
# Copyright, 2018, Olivier Mehani <shtrom+zsh@ssji.net>, MIT licensed
#
local _RUNTIME_FILE=$(umask 7077; mktemp /tmp/zsh_runtime.$$.XXXXXX)

function runtime() {
	local last=$(cat ${_RUNTIME_FILE} 2>/dev/null)
	if [[ -n $last ]]; then
		now=$(date '+%s')
		echo "$((now-last))"
		echo > ${_RUNTIME_FILE}
	fi
}

function runtime_preexec() {
	date '+%s' > ${_RUNTIME_FILE}
}

function runtime_zshexit() {
	rm -f ${_RUNTIME_FILE}
}

autoload -U add-zsh-hook
add-zsh-hook preexec runtime_preexec
add-zsh-hook zshexit runtime_zshexit

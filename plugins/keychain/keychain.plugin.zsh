(( $+commands[keychain] )) || return

# Define SHORT_HOST if not defined (%m = host name up to first .)
SHORT_HOST=${SHORT_HOST:-${(%):-%m}}

function {
	local agents
	local -a identities
	local -a options
	local _keychain_env_sh
	local _keychain_env_sh_gpg

	# load agents to start.
	zstyle -s :omz:plugins:keychain agents agents

	# load identities to manage.
	zstyle -a :omz:plugins:keychain identities identities

	# load additional options
	zstyle -a :omz:plugins:keychain options options

	# Check keychain version to decide whether to use --agents
	local version_string=$(keychain --version 2>&1 | head -n 2 | tail -n 1 | cut -d ' ' -f 4)
  # start keychain, only use --agents for versions below 2.9.0
	autoload -Uz is-at-least
	if is-at-least 2.9 "$version_string"; then
		keychain ${^options:-} ${^identities} --host $SHORT_HOST
	else
		keychain ${^options:-} --agents ${agents:-gpg} ${^identities} --host $SHORT_HOST
	fi

	# Get the filenames to store/lookup the environment from
	_keychain_env_sh="$HOME/.keychain/$SHORT_HOST-sh"
	_keychain_env_sh_gpg="$HOME/.keychain/$SHORT_HOST-sh-gpg"

	# Source environment settings.
	[ -f "$_keychain_env_sh" ]     && . "$_keychain_env_sh"
	[ -f "$_keychain_env_sh_gpg" ] && . "$_keychain_env_sh_gpg"
}

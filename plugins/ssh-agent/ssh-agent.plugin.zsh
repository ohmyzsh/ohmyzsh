typeset _agent_forwarding _ssh_env_cache

function _start_agent() {
	local lifetime
	zstyle -s :omz:plugins:ssh-agent lifetime lifetime

	# start ssh-agent and setup environment
	echo Starting ssh-agent...
	ssh-agent -s ${lifetime:+-t} ${lifetime} | sed 's/^echo/#echo/' >! $_ssh_env_cache
	chmod 600 $_ssh_env_cache
	. $_ssh_env_cache > /dev/null
}

function _add_identities() {
	local id line sig lines
	local -a identities loaded_sigs loaded_ids not_loaded
	zstyle -a :omz:plugins:ssh-agent identities identities

	# check for .ssh folder presence
	if [[ ! -d $HOME/.ssh ]]; then
		return
	fi

	# add default keys if no identities were set up via zstyle
	# this is to mimic the call to ssh-add with no identities
	if [[ ${#identities} -eq 0 ]]; then
		# key list found on `ssh-add` man page's DESCRIPTION section
		for id in id_rsa id_dsa id_ecdsa id_ed25519 identity; do
			# check if file exists
			[[ -f "$HOME/.ssh/$id" ]] && identities+=$id
		done
	fi

	# get list of loaded identities' signatures and filenames
	if lines=$(ssh-add -l); then
		for line in ${(f)lines}; do
			loaded_sigs+=${${(z)line}[2]}
			loaded_ids+=${${(z)line}[3]}
		done
	fi

	# add identities if not already loaded
	for id in $identities; do
		# check for filename match, otherwise try for signature match
		if [[ ${loaded_ids[(I)$HOME/.ssh/$id]} -le 0 ]]; then
			sig="$(ssh-keygen -lf "$HOME/.ssh/$id" | awk '{print $2}')"
			[[ ${loaded_sigs[(I)$sig]} -le 0 ]] && not_loaded+="$HOME/.ssh/$id"
		fi
	done

	local args
	zstyle -a :omz:plugins:ssh-agent ssh-add-args args
	[[ -n "$not_loaded" ]] && ssh-add "${args[@]}" ${^not_loaded}
}

# Get the filename to store/lookup the environment from
_ssh_env_cache="$HOME/.ssh/environment-$SHORT_HOST"

# test if agent-forwarding is enabled
zstyle -b :omz:plugins:ssh-agent agent-forwarding _agent_forwarding

if [[ $_agent_forwarding == "yes" && -n "$SSH_AUTH_SOCK" ]]; then
	# Add a nifty symlink for screen/tmux if agent forwarding
	[[ -L $SSH_AUTH_SOCK ]] || ln -sf "$SSH_AUTH_SOCK" /tmp/ssh-agent-$USERNAME-screen
elif [[ -f "$_ssh_env_cache" ]]; then
	# Source SSH settings, if applicable
	. $_ssh_env_cache > /dev/null
	if [[ $USERNAME == "root" ]]; then
		FILTER="ax"
	else
		FILTER="x"
	fi
	ps $FILTER | grep ssh-agent | grep -q $SSH_AGENT_PID || {
		_start_agent
	}
else
	_start_agent
fi

_add_identities

# tidy up after ourselves
unset _agent_forwarding _ssh_env_cache
unfunction _start_agent _add_identities

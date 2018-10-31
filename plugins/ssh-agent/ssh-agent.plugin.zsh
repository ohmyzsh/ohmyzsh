typeset _agent_forwarding _ssh_env_cache

function _start_agent() {
	local lifetime
	local -a identities

	# start ssh-agent and setup environment
	zstyle -s :omz:plugins:ssh-agent lifetime lifetime

	ssh-agent -s ${lifetime:+-t} ${lifetime} | sed 's/^echo/#echo/' >! $_ssh_env_cache
	chmod 600 $_ssh_env_cache
	. $_ssh_env_cache > /dev/null

	# load identies
	zstyle -a :omz:plugins:ssh-agent identities identities

	echo starting ssh-agent...
	ssh-add $HOME/.ssh/${^identities}
}

function _accquire_lock() {
	local ssh_try_lock_count
	ssh_try_lock_count=0
	while ! mkdir /tmp/_ssh_agent_lock >& /dev/null; do
		if [ $ssh_try_lock_count -eq 0 ]; then
			echo wait 10 seconds for another ssh agent starting process...
		fi

		((ssh_try_lock_count++))
		if [ $ssh_try_lock_count -ge 10 ]; then
			echo it seems the other ssh agent start process is blocking. You may want to check statuses of other zsh processes, or just \'rm /tmp/_ssh_env_cache\' if you are sure.
			return 1
		fi
		sleep 1
	done

	return 0
}

function _release_lock() {
	rm -rf /tmp/_ssh_agent_lock
}

# Get the filename to store/lookup the environment from
_ssh_env_cache="$HOME/.ssh/environment-$SHORT_HOST"

# test if agent-forwarding is enabled
zstyle -b :omz:plugins:ssh-agent agent-forwarding _agent_forwarding

if [[ $_agent_forwarding == "yes" && -n "$SSH_AUTH_SOCK" ]]; then
	# Add a nifty symlink for screen/tmux if agent forwarding
	[[ -L $SSH_AUTH_SOCK ]] || ln -sf "$SSH_AUTH_SOCK" /tmp/ssh-agent-$USER-screen
else
	if _accquire_lock; then
		if [[ -f "$_ssh_env_cache" ]]; then
			# Source SSH settings, if applicable
			. $_ssh_env_cache > /dev/null
			if [[ $USER == "root" ]]; then
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

		_release_lock
	fi
fi

# tidy up after ourselves
unset _agent_forwarding _ssh_env_cache
unfunction _start_agent
unfunction _accquire_lock
unfunction _release_lock

local _plugin__ssh_env
local _plugin__forwarding

function _plugin__start_agent()
{
  local -a identities
  local lifetime
  zstyle -s :omz:plugins:ssh-agent lifetime lifetime

  # start ssh-agent and setup environment
  ssh-agent ${lifetime:+-t} ${lifetime} | sed 's/^echo/#echo/' >! ${_plugin__ssh_env}
  chmod 600 ${_plugin__ssh_env}
  . ${_plugin__ssh_env} > /dev/null

  # load identies
  zstyle -a :omz:plugins:ssh-agent identities identities
  echo starting ssh-agent...

  ssh-add $HOME/.ssh/${^identities}
}

# Get the filename to store/lookup the environment from
if (( $+commands[scutil] )); then
  # It's OS X!
  _plugin__ssh_env="$HOME/.ssh/environment-$(scutil --get ComputerName)"
else
  _plugin__ssh_env="$HOME/.ssh/environment-$HOST"
fi

# test if agent-forwarding is enabled
zstyle -b :omz:plugins:ssh-agent agent-forwarding _plugin__forwarding
if [[ ${_plugin__forwarding} == "yes" && -n "$SSH_AUTH_SOCK" ]]; then
  # Add a nifty symlink for screen/tmux if agent forwarding
  [[ -L $SSH_AUTH_SOCK ]] || ln -sf "$SSH_AUTH_SOCK" /tmp/ssh-agent-$USER-screen

elif [ -f "${_plugin__ssh_env}" ]; then
  # Source SSH settings, if applicable
  . ${_plugin__ssh_env} > /dev/null
  ps x | grep ${SSH_AGENT_PID} | grep ssh-agent > /dev/null || {
    _plugin__start_agent;
  }
else
  _plugin__start_agent;
fi

# tidy up after ourselves
unfunction _plugin__start_agent
unset _plugin__forwarding
unset _plugin__ssh_env

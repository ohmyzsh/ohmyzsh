local ssh_env=$HOME/.ssh/environment-$HOST
# local state

function start_agent()
{
  local -a identities

  # start ssh-agent and setup environment
  ssh-agent | sed 's/^echo/#echo/' >${ssh_env}
  chmod 600 $ssh_env
  source $ssh_env >/dev/null

  # load identies
  zstyle -a :omz:plugins:ssh-agent identities identities
  ssh-add $HOME/.ssh/${^identities}
}

# test if agent-forwarding is enabled
# zstyle -b :omz:plugins:ssh-agent agent-forwarding state

# if [[ $state == "yes" && -n "$SSH_AUTH_SOCK" ]]; then
#   [[ -L $SSH_AUTH_SOCK ]] || ln -sf $SSH_AUTH_SOCK /tmp/ssh-agent-$USER-screen
if [[ -f $ssh_env ]]; then
  source $ssh_env >/dev/null
  ps -p $SSH_AGENT_PID >/dev/null || start_agent
else
  start_agent;
fi

# tidy up after ourselves
unfunction start_agent
# unset state
unset ssh_env

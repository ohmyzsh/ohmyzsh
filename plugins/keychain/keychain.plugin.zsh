local ssh_env=$HOME/.ssh/environment-$HOST

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

function keychain() {
  case $1 in
    "start") ;;
    "kill")
      ssh-agent -k
      ;;
  esac
}

zstyle -a :omz:plugins:keychain autostart state
if [[ $state == "on" ]]; then
  if [[ -f $ssh_env ]]; then
    source $ssh_env >/dev/null
    ps -p $SSH_AGENT_PID >/dev/null || start_agent
  else
    start_agent;
  fi
fi

unfunction start_agent
unset ssh_env

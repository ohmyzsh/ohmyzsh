function keychain_start_agent()
{
  local -a identities

  # start ssh-agent and setup environment
  ssh-agent >${ssh_env}
  chmod 600 $ssh_env
  source $ssh_env >/dev/null

  # load identies
  zstyle -a :omz:plugins:ssh-agent identities identities
  ssh-add $HOME/.ssh/${^identities}
}

function keychain() {
  local ssh_env=$HOME/.ssh/environment-$HOST

  case $1 in
    "start")
      if [[ -f $ssh_env ]]; then
        source $ssh_env >/dev/null
        ps -p $SSH_AGENT_PID >/dev/null || keychain_start_agent
      else
        keychain_start_agent;
      fi
      ;;
    "kill")
      echo "Stopping agent"
      ssh-agent -k >/dev/null
      ;;
  esac
}

zstyle -a :omz:plugins:keychain autostart state
[[ $state == "on" ]] && keychain start

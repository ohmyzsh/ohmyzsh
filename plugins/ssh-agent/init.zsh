#
# Provides for an easier use of ssh-agent.
#
# Authors:
#   Robby Russell <robby@planetargon.com>
#   Theodore Robert Campbell Jr <trcjr@stupidfoot.com>
#   Joseph M. Reagle Jr. <reagle@mit.edu>
#   Florent Thoumie <flz@xbsd.org>
#   Jonas Pfenniger <jonas@pfenniger.name>
#   gwjo <gowen72@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
# Usage:
#   To enable agent forwarding, add the following to your .zshrc:
#
#     zstyle ':omz:plugin:ssh-agent' forwarding 'yes'
#
#   To load multiple identies, add the following to your .zshrc:
#
#     zstyle ':omz:plugin:ssh-agent' identities 'id_rsa' 'id_rsa2' 'id_github'
#

_ssh_agent_env="$HOME/.ssh/environment-$HOST"
_ssh_agent_forwarding=

function _ssh-agent-start() {
  local -a identities

  # Start ssh-agent and setup the environment.
  rm -f "${_ssh_agent_env}"
  ssh-agent > "${_ssh_agent_env}"
  chmod 600 "${_ssh_agent_env}"
  source "${_ssh_agent_env}" > /dev/null

  # Load identies.
  zstyle -a ':omz:plugin:ssh-agent' identities 'identities'

  print starting ssh-agent...

  if [[ ! -n "${identities}" ]]; then
    ssh-add
  else
    ssh-add "$HOME/.ssh/${^identities}"
  fi
}

# Test if agent-forwarding is enabled.
zstyle -b ':omz:plugin:ssh-agent' forwarding '_ssh_agent_forwarding'
if is-true "${_ssh_agent_forwarding}" && [[ -n "$SSH_AUTH_SOCK" ]]; then
  # Add a nifty symlink for screen/tmux if agent forwarding.
  [[ -L "$SSH_AUTH_SOCK" ]] || ln -sf "$SSH_AUTH_SOCK" /tmp/ssh-agent-$USER-screen
elif [ -f "${_ssh_agent_env}" ]; then
  # Source SSH settings, if applicable.
  source "${_ssh_agent_env}" > /dev/null
  ps -ef | grep "${SSH_AGENT_PID}" | grep ssh-agent$ > /dev/null || {
    _ssh-agent-start;
  }
else
  _ssh-agent-start;
fi

# Tidy up after ourselves.
unfunction _ssh-agent-start
unset _ssh_agent_forwarding
unset _ssh_agent_env


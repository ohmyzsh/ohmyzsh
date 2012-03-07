#
# Provides for an easier use of gpg-agent.
#
# Authors:
#   Florian Walch <florian.walch@gmx.at>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

_gpg_env="$HOME/.gnupg/gpg-agent.env"

if (( ! $+commands[gpg-agent] )); then
  return
fi

function _gpg-agent-start() {
  gpg-agent --daemon --enable-ssh-support --write-env-file "${_gpg_env}"
  chmod 600 "${_gpg_env}"
  source "${_gpg_env}"
}

# Source GPG agent settings, if applicable.
if [[ -f "${_gpg_env}" ]]; then
  source "${_gpg_env}"
  ps -ef | grep "${SSH_AGENT_PID}" | grep -q 'gpg-agent' || {
    _gpg-agent-start
  }
else
  _gpg-agent-start
fi

export GPG_AGENT_INFO
export SSH_AUTH_SOCK
export SSH_AGENT_PID
export GPG_TTY="$(tty)"


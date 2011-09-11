# Based on ssh-agent code.

local GPG_ENV="$HOME/.gnupg/gpg-agent.env"

if (( ! $+commands[gpg-agent] )); then
  return
fi

function _gpg-agent-start() {
  /usr/bin/env gpg-agent --daemon --enable-ssh-support --write-env-file "${GPG_ENV}" > /dev/null
  chmod 600 "${GPG_ENV}"
  source "${GPG_ENV}" > /dev/null
}

# Source GPG agent settings, if applicable.
if [[ -f "${GPG_ENV}" ]]; then
  source "${GPG_ENV}" > /dev/null
  ps -ef | grep "${SSH_AGENT_PID}" | grep gpg-agent > /dev/null || {
    _gpg-agent-start;
  }
else
  _gpg-agent-start;
fi

export GPG_AGENT_INFO
export SSH_AUTH_SOCK
export SSH_AGENT_PID

GPG_TTY=$(tty)
export GPG_TTY


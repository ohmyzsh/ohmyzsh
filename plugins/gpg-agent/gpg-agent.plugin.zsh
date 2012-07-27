# Based on ssh-agent code

local GPG_ENV=$HOME/.gnupg/gpg-agent.env

function start_agent {
  /usr/bin/env gpg-agent --daemon --enable-ssh-support --write-env-file ${GPG_ENV} > /dev/null
  chmod 600 ${GPG_ENV}
  . ${GPG_ENV} > /dev/null
}

if [[ -n $SSH_AUTH_SOCK && -n $SSH_CONNECTION ]]; then
  case $GPG_USE_FORWARDED_SSH_AGENT in
	'always')
	  FOWARDED_AGENT=1
	  ;;
	'never')
	  ;;
	*)
	  echo "Use forwarded ssh-agent?(y/N) "
	  read 
	  [[ $REPLY == 'y' ]] && FOWARDED_AGENT=1
  esac
  if [[ -n $FOWARDED_AGENT ]]; then
  	SSH_AUTH_SOCK_TMP=$SSH_AUTH_SOCK
  fi
fi

# Source GPG agent settings, if applicable
if [ -f "${GPG_ENV}" ]; then
  . ${GPG_ENV} > /dev/null
  command ps -ef | grep ${SSH_AGENT_PID} | grep gpg-agent > /dev/null || {
    start_agent;
  }
else
  start_agent;
fi

[[ -n $FOWARDED_AGENT ]] && SSH_AUTH_SOCK=$SSH_AUTH_SOCK_TMP

export GPG_AGENT_INFO
export SSH_AUTH_SOCK
export SSH_AGENT_PID


GPG_TTY=$(tty)
export GPG_TTY

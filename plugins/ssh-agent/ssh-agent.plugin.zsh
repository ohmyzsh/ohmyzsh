# Based on code from Joseph M. Reagle
# http://www.cygwin.com/ml/cygwin/2001-06/msg00537.html

local SSH_ENV=$HOME/.ssh/environment-$HOST

function start_agent {
  mkdir -m 700 -p $HOME/.ssh
  /usr/bin/env ssh-agent | sed 's/^echo/#echo/' > ${SSH_ENV}
  chmod 600 ${SSH_ENV}
  . ${SSH_ENV} > /dev/null
  /usr/bin/ssh-add;
}

function has_agent {
  [ -n "${SSH_AUTH_SOCK}" ] && [ -r "${SSH_AUTH_SOCK}" ]
  return $?
}

if ! has_agent && [ -f "${SSH_ENV}" ] ; then
  . ${SSH_ENV} > /dev/null
fi

if ! has_agent ; then
  start_agent
fi

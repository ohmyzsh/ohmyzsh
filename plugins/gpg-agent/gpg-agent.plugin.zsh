# Based on ssh-agent code

local GPG_ENV=$HOME/.gnupg/gpg-agent.env

function start_agent {
    if [ -n "${GPG_AGENT_HANDLE_SSH}" ] ; then
        /usr/bin/env gpg-agent --daemon --enable-ssh-support --write-env-file ${GPG_ENV} > /dev/null
        chmod 600 ${GPG_ENV}
    else
        /usr/bin/env gpg-agent --daemon --write-env-file ${GPG_ENV} > /dev/null
        chmod 600 ${GPG_ENV}
    fi
    . ${GPG_ENV} > /dev/null
}

# Source GPG agent settings, if applicable
if [ -f "${GPG_ENV}" ]; then
    . ${GPG_ENV} > /dev/null
    if [ -n "${GPG_AGENT_HANDLE_SSH}" ] ; then
        if [ $(ps -ef | grep ${SSH_AGENT_PID} | grep -c gpg-agent) -eq 0 ] ; then
            start_agent;
        fi
    else
        if [ $(ps -ef | grep gpg-agent | grep -c daemon) -eq 0 ] ; then
            start_agent;
        fi
    fi
else
    start_agent;
fi

export GPG_AGENT_INFO
if [ -n "${GPG_AGENT_HANDLE_SSH}" ] ; then
    export SSH_AUTH_SOCK
    export SSH_AGENT_PID
fi

GPG_TTY=$(tty)
export GPG_TTY

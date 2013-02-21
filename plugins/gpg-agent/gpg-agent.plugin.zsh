local GPG_ENV=$HOME/.gnupg/gpg-agent.env

function start_agent_nossh {
    eval $(/usr/bin/env gpg-agent --daemon --write-env-file ${GPG_ENV}) > /dev/null
    export GPG_AGENT_INFO
}

function start_agent_withssh {
    eval $(/usr/bin/env gpg-agent --daemon --enable-ssh-support --write-env-file ${GPG_ENV}) > /dev/null
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
    export SSH_AGENT_PID
}

# make sure all created files are u=rw only
umask 177

# source settings of old agent, if applicable
if [ -f "${GPG_ENV}" ]; then
  . ${GPG_ENV} > /dev/null
fi

# check for existing ssh-agent
if ssh-add -l > /dev/null 2> /dev/null; then
    start_agent_nossh;
else
    start_agent_withssh;
fi

GPG_TTY=$(tty)
export GPG_TTY

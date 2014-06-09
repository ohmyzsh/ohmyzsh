local GPG_ENV=$HOME/.gnupg/gpg-agent.env

function start_agent_nossh {
    eval $(/usr/bin/env gpg-agent --quiet --daemon --write-env-file ${GPG_ENV} 2> /dev/null)
    chmod 600 ${GPG_ENV}
    export GPG_AGENT_INFO
}

function start_agent_withssh {
    eval $(/usr/bin/env gpg-agent --quiet --daemon --enable-ssh-support --write-env-file ${GPG_ENV} 2> /dev/null)
    chmod 600 ${GPG_ENV}
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
    export SSH_AGENT_PID
}

# check if another agent is running
if ! gpg-connect-agent --quiet /bye > /dev/null 2> /dev/null; then
    # check if ssh-agent is running
    local SSH_RUNNING=1
    local OLD_SSH_AUTH_SOCK=
    local OLD_SSH_AGENT_PID=
    if [[ -n "$SSH_AGENT_PID" ]]; then
        kill -0 $SSH_AGENT_PID
        SSH_RUNNING=$?
        if [[ $SSH_RUNNING -eq 0 ]]; then
            OLD_SSH_AUTH_SOCK="$SSH_AUTH_SOCK"
            OLD_SSH_AGENT_PID="$SSH_AGENT_PID"
        fi
    fi

    # source settings of old agent, if applicable
    if [ -f "${GPG_ENV}" ]; then
        . ${GPG_ENV} > /dev/null
        SSH_AUTH_SOCK="${OLD_SSH_AUTH_SOCK:-$SSH_AUTH_SOCK}"
        SSH_AGENT_PID="${OLD_SSH_AGENT_PID:-$SSH_AGENT_PID}"
        export GPG_AGENT_INFO
        export SSH_AUTH_SOCK
        export SSH_AGENT_PID
    fi

    # check again if another agent is running using the newly sourced settings
    if ! gpg-connect-agent --quiet /bye > /dev/null 2> /dev/null; then
        if [[ $SSH_RUNNING -eq 0 ]]; then
            # ssh-agent running, start gpg-agent without ssh support
            start_agent_nossh;
        else
            # otherwise start gpg-agent with ssh support
            start_agent_withssh;
        fi
    fi
fi

GPG_TTY=$(tty)
export GPG_TTY

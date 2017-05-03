local GPG_ENV=$HOME/.gnupg/gpg-agent.env

# Enable SSH support by adding this line to your .zshrc file:
# zstyle :omz:plugins:gpg-agent ssh-support on
local _plugin__ssh_support

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
    # source settings of old agent, if applicable
    if [ -f "${GPG_ENV}" ]; then
        . ${GPG_ENV} > /dev/null
        export GPG_AGENT_INFO
        export SSH_AUTH_SOCK
        export SSH_AGENT_PID
    fi

    # check again if another agent is running using the newly sourced settings
    if ! gpg-connect-agent --quiet /bye > /dev/null 2> /dev/null; then
        # check if ssh support is set
        zstyle -b :omz:plugins:gpg-agent ssh-support _plugin__ssh_support
        if [[ ${_plugin__ssh_support} == "yes" ]]; then
            # start gpg-agent with ssh support
            start_agent_withssh;
        else
            # otherwise start gpg-agent without ssh support
            start_agent_nossh;
        fi
    fi
fi

GPG_TTY=$(tty)
export GPG_TTY

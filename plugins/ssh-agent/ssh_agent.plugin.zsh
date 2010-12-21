# Load ssh-agent/keychain (taken from asyd configuration, available at http://asyd.net/home/zsh )

function ssh_key_manage() {
    if [[ -x $(which keychain) ]] && [ -r ~/.ssh/id_?sa ]; then
        # run keychain
        keychain --nogui ~/.ssh/id_?sa
        [[ -r ~/.ssh-agent-`hostname` ]] && source ~/.ssh-agent-`hostname`
        [[ -r ~/.keychain/`hostname`-sh ]] && source ~/.keychain/`hostname`-sh
    else
        if [ -x $(which ssh-agent) -a -f $HOME/.ssh/id_?sa ]; then
            if [[ -r $HOME/.ssh/agent-pid ]]; then
                if [[ -d /proc/$(< $HOME/.ssh/agent-pid) ]]; then
                    source $HOME/.ssh/agent
                else
                    ssh-agent -s > $HOME/.ssh/agent
                    source $HOME/.ssh/agent
                    echo $SSH_AGENT_PID > $HOME/.ssh/agent-pid
                    ssh-add $HOME/.ssh/id_?sa
                fi
            else
                ssh-agent -s > $HOME/.ssh/agent
                source $HOME/.ssh/agent
                echo $SSH_AGENT_PID > $HOME/.ssh/agent-pid
                ssh-add $HOME/.ssh/id_?sa
            fi
        fi
    fi

}

if [[ "$USER" != "root" ]]; then
    ssh_key_manage
fi


# Enable gpg-agent if it is not running-
# --use-standard-socket will work from version 2 upwards

AGENT_SOCK=`gpgconf --list-dirs | grep agent-socket | cut -d : -f 2`

if [ ! -S ${AGENT_SOCK} ]; then
  gpg-agent --daemon --use-standard-socket >/dev/null 2>&1
fi
export GPG_TTY=$(tty)

# Set SSH to use gpg-agent if it's enabled
if [ -S "${AGENT_SOCK}.ssh" ]; then
  export SSH_AUTH_SOCK="${AGENT_SOCK}.ssh"
  unset SSH_AGENT_PID
fi


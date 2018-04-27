# Enable gpg-agent if it is not running-
# --use-standard-socket will work from version 2 upwards
AGENT_SOCK=$(gpgconf --list-dirs | grep agent-socket | cut -d : -f 2)

if [[ ! -S "$AGENT_SOCK" }]; then
  gpg-agent --daemon --use-standard-socket &>/dev/null
fi
export GPG_TTY=$TTY

# Set SSH to use gpg-agent if it's enabled, and we're not using the ssh-agent plugin
if [[ ${+plugins[(r)ssh-agent} -ne 0 && -S "$AGENT_SOCK.ssh" ]]; then
  export SSH_AUTH_SOCK="$AGENT_SOCK.ssh"
  unset SSH_AGENT_PID
fi

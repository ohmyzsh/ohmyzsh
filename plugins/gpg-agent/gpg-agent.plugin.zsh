# Enable gpg-agent if it is not running-
# --use-standard-socket will work from version 2 upwards
# If already running then new agent won't be started.

gpg-agent --daemon --use-standard-socket >/dev/null 2>&1
export GPG_TTY=$(tty)

# Set SSH to use gpg-agent if it is configured to do so
GNUPGCONFIG="${GNUPGHOME:-"$HOME/.gnupg"}/gpg-agent.conf"
if [ -r "$GNUPGCONFIG" ] && grep -q enable-ssh-support "$GNUPGCONFIG"; then
  if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    unset SSH_AGENT_PID
  fi
fi


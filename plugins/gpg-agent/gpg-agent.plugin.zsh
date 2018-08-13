export GPG_TTY=$TTY

gpg-connect-agent /bye &>/dev/null

GNUPGCONFIG="${GNUPGHOME:-"$HOME/.gnupg"}/gpg-agent.conf"
if [[ -r $GNUPGCONFIG ]] && command grep -q enable-ssh-support "$GNUPGCONFIG"; then
  unset SSH_AGENT_PID
  if [[ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  fi
  autoload -U add-zsh-hook
  add-zsh-hook preexec _gpg-agent-update-tty
  function _gpg-agent-update-tty {
    gpg-connect-agent updatestartuptty /bye &>/dev/null
  }
fi

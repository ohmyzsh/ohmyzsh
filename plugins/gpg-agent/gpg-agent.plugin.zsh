export GPG_TTY=$TTY

# The ssh-support style says whether gpg-agent is used as the ssh agent.
# Setting it saves asking gpgconf, which can be slow.
zstyle -t ':omz:plugins:gpg-agent' ssh-support
_gpg_agent_ssh_support=$? # 0 if yes, 1 if no, 2 if not set

# Everything below is only needed for ssh support
if (( _gpg_agent_ssh_support == 1 )); then
  unset _gpg_agent_ssh_support
  return
fi

# Fix for passphrase prompt on the correct tty
# See https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html#option-_002d_002denable_002dssh_002dsupport
function _gpg-agent_update-tty_preexec {
  gpg-connect-agent updatestartuptty /bye &>/dev/null
}
autoload -U add-zsh-hook
add-zsh-hook preexec _gpg-agent_update-tty_preexec

# If enable-ssh-support is set, fix ssh agent integration
if (( _gpg_agent_ssh_support == 0 )) \
  || [[ $(gpgconf --list-options gpg-agent 2>/dev/null \
    | awk -F: '$1=="enable-ssh-support" {print $10}') = 1 ]]; then
  unset SSH_AGENT_PID
  if [[ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  fi
fi

unset _gpg_agent_ssh_support

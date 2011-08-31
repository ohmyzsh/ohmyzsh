# Uses the command-not-found package ZSH support as seen in
# http://www.porcheron.info/command-not-found-for-zsh/ and
# installed in Ubuntu.

if [[ -f /etc/zsh_command_not_found ]]; then
  source /etc/zsh_command_not_found
fi


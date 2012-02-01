#
# Gets the latest Git completion.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

completion_file="${0:h}/completions/_git"
completion_file_url='http://zsh.git.sourceforge.net/git/gitweb.cgi?p=zsh/zsh;a=blob_plain;f=Completion/Unix/Command/_git;hb=HEAD'
if [[ ! -e "$completion_file" ]] && (( $+commands[git] )); then
  # Remove empty completions directory.
  if [[ -d "${completion_file:h}"(/^F) ]]; then
    rmdir "${completion_file:h}" 2> /dev/null
  fi

  if mkdir -p "${completion_file:h}" > /dev/null; then
    if (( $+commands[curl] )); then
      curl -L "$completion_file_url" -o "$completion_file" &> /dev/null &!
    fi

    if (( $+commmands[wget] )); then
      wget -C "$completion_file_url" -O "$completion_file" &> /dev/null &!
    fi
  fi
fi
unset completion_file
unset completion_file_url


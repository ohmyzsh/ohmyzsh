(( $+commands[autojump] )) || {
  echo '[oh-my-zsh] Please install autojump first (https://github.com/wting/autojump)'
  return
}

declare -a autojump_paths
autojump_paths=(
  $HOME/.autojump/etc/profile.d/autojump.zsh         # manual installation
  $HOME/.autojump/share/autojump/autojump.zsh        # manual installation
  $HOME/.nix-profile/etc/profile.d/autojump.sh       # NixOS installation
  /run/current-system/sw/share/autojump/autojump.zsh # NixOS installation
  /usr/share/autojump/autojump.zsh                   # Debian and Ubuntu package
  /etc/profile.d/autojump.zsh                        # manual installation
  /etc/profile.d/autojump.sh                         # Gentoo installation
  /usr/local/share/autojump/autojump.zsh             # FreeBSD installation
  /opt/local/etc/profile.d/autojump.sh               # macOS with MacPorts
  /usr/local/etc/profile.d/autojump.sh               # macOS with Homebrew (default)
)

for file in $autojump_paths; do
  if [[ -f "$file" ]]; then
    source "$file"
    found=1
    break
  fi
done

# if no path found, try Homebrew
if (( ! found && $+commands[brew] )); then
  file=$(brew --prefix)/etc/profile.d/autojump.sh
  if [[ -f "$file" ]]; then
    source "$file"
    found=1
  fi
fi

(( ! found )) && echo '[oh-my-zsh] autojump script not found'

unset autojump_paths file found

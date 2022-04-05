<<<<<<< HEAD
if [ $commands[autojump] ]; then # check if autojump is installed
  if [ -f $HOME/.autojump/etc/profile.d/autojump.zsh ]; then # manual user-local installation
    . $HOME/.autojump/etc/profile.d/autojump.zsh
  elif [ -f $HOME/.autojump/share/autojump/autojump.zsh ]; then # another manual user-local installation
    . $HOME/.autojump/share/autojump/autojump.zsh
  elif [ -f $HOME/.nix-profile/etc/profile.d/autojump.zsh ]; then # nix installation
    . $HOME/.nix-profile/etc/profile.d/autojump.zsh
  elif [ -f /usr/share/autojump/autojump.zsh ]; then # debian and ubuntu package
    . /usr/share/autojump/autojump.zsh
  elif [ -f /etc/profile.d/autojump.zsh ]; then # manual installation
    . /etc/profile.d/autojump.zsh
  elif [ -f /etc/profile.d/autojump.sh ]; then # gentoo installation
    . /etc/profile.d/autojump.sh
  elif [ -f /usr/local/share/autojump/autojump.zsh ]; then # freebsd installation
    . /usr/local/share/autojump/autojump.zsh
  elif [ -f /opt/local/etc/profile.d/autojump.zsh ]; then # mac os x with ports
    . /opt/local/etc/profile.d/autojump.zsh
  elif [ $commands[brew] -a -f `brew --prefix`/etc/autojump.zsh ]; then # mac os x with brew
    . `brew --prefix`/etc/autojump.zsh
  fi
fi
=======
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
  /usr/pkg/share/autojump/autojump.zsh               # NetBSD installation
  /opt/local/etc/profile.d/autojump.sh               # macOS with MacPorts
  /usr/local/etc/profile.d/autojump.sh               # macOS with Homebrew (default)
  /opt/homebrew/etc/profile.d/autojump.sh            # macOS with Homebrew (default on M1 macs)
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

(( ! found )) && echo '[oh-my-zsh] autojump not found. Please install it first.'

unset autojump_paths file found
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

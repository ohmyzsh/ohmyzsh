declare -a autojump_paths
autojump_paths=(
  $HOME/.autojump/etc/profile.d/autojump.zsh               # manual installation
  $HOME/.autojump/share/autojump/autojump.zsh              # manual installation
  $HOME/.nix-profile/etc/profile.d/autojump.sh             # NixOS installation
  /run/current-system/sw/share/autojump/autojump.zsh       # NixOS installation
  /etc/profiles/per-user/$USER/share/autojump/autojump.zsh # Home Manager, NixOS with user-scoped packages
  /usr/share/autojump/autojump.zsh                         # Debian and Ubuntu package
  /etc/profile.d/autojump.zsh                              # manual installation
  /etc/profile.d/autojump.sh                               # Gentoo installation
  /usr/local/share/autojump/autojump.zsh                   # FreeBSD installation
  /usr/pkg/share/autojump/autojump.zsh                     # NetBSD installation
  /opt/local/etc/profile.d/autojump.sh                     # macOS with MacPorts
  /usr/local/etc/profile.d/autojump.sh                     # macOS with Homebrew (default)
  /opt/homebrew/etc/profile.d/autojump.sh                  # macOS with Homebrew (default on M1 macs)
  /etc/profiles/per-user/$USER/etc/profile.d/autojump.sh   # macOS Nix, Home Manager and flakes
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
